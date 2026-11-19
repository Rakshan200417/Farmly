package com.farmly.auth;

import com.farmly.users.User;
import com.farmly.users.UserRepository;
import com.farmly.users.UserRole;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    public AuthController(UserRepository userRepository, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.jwtUtil = jwtUtil;
    }

    // 1. Email & Password Sign Up
    @PostMapping("/signup")
    public ResponseEntity<Map<String, Object>> signUp(@RequestBody Map<String, String> request) {
        String email = request.getOrDefault("email", "").trim().toLowerCase();
        String password = request.getOrDefault("password", "").trim();
        String name = request.getOrDefault("name", "").trim();
        String roleStr = request.getOrDefault("role", "FARMER").toUpperCase();
        String district = request.getOrDefault("district", "Anuradhapura");
        String phone = request.getOrDefault("phone", "").trim();

        if (email.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email is required"));
        }
        if (password.length() < 4) {
            return ResponseEntity.badRequest().body(Map.of("error", "Password must be at least 4 characters"));
        }
        if (name.isEmpty()) {
            name = email.split("@")[0];
        }

        if (userRepository.existsByEmail(email)) {
            return ResponseEntity.badRequest().body(Map.of("error", "An account with this email already exists. Please sign in."));
        }

        UserRole role;
        try {
            role = UserRole.valueOf(roleStr);
        } catch (Exception e) {
            role = UserRole.FARMER;
        }

        User newUser = new User(name, email, password, role, district);
        if (!phone.isEmpty()) {
            newUser.setPhone(phone);
        } else {
            newUser.setPhone("+94 " + Math.abs(email.hashCode() % 900000000 + 100000000));
        }

        User saved = userRepository.save(newUser);
        String token = jwtUtil.generateToken(saved.getId(), saved.getRole().name(), saved.getEmail());

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("token", token);
        response.put("user", saved);
        response.put("message", "Account created successfully!");
        return ResponseEntity.ok(response);
    }

    // 2. Email & Password Sign In
    @PostMapping("/signin")
    public ResponseEntity<Map<String, Object>> signIn(@RequestBody Map<String, String> request) {
        String email = request.getOrDefault("email", "").trim().toLowerCase();
        String password = request.getOrDefault("password", "").trim();

        if (email.isEmpty() || password.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email and password are required"));
        }

        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            return ResponseEntity.status(401).body(Map.of("error", "No account found with this email. Please sign up."));
        }

        // Check password (supports direct match or demo accounts)
        if (user.getPassword() != null && !user.getPassword().isEmpty() && !user.getPassword().equals(password)) {
            return ResponseEntity.status(401).body(Map.of("error", "Incorrect password. Please try again."));
        }

        String token = jwtUtil.generateToken(user.getId(), user.getRole().name(), user.getEmail() != null ? user.getEmail() : user.getPhone());

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("token", token);
        response.put("user", user);
        response.put("message", "Signed in successfully!");
        return ResponseEntity.ok(response);
    }

    // 3. Update User Profile Settings
    @PutMapping("/profile/{id}")
    public ResponseEntity<?> updateProfile(@PathVariable String id, @RequestBody Map<String, String> request) {
        return userRepository.findById(id).map(user -> {
            if (request.containsKey("name") && !request.get("name").trim().isEmpty()) {
                user.setName(request.get("name").trim());
            }
            if (request.containsKey("phone") && !request.get("phone").trim().isEmpty()) {
                user.setPhone(request.get("phone").trim());
            }
            if (request.containsKey("district") && !request.get("district").trim().isEmpty()) {
                user.setDistrict(request.get("district").trim());
                user.setLocationName(user.getDistrict() + ", Sri Lanka");
            }
            if (request.containsKey("role") && !request.get("role").trim().isEmpty()) {
                try {
                    user.setRole(UserRole.valueOf(request.get("role").toUpperCase()));
                } catch (Exception ignored) {}
            }
            if (request.containsKey("email") && !request.get("email").trim().isEmpty()) {
                user.setEmail(request.get("email").trim().toLowerCase());
            }
            if (request.containsKey("password") && !request.get("password").trim().isEmpty()) {
                user.setPassword(request.get("password").trim());
            }
            if (request.containsKey("profilePicture")) {
                user.setProfilePicture(request.get("profilePicture"));
            }
            User updated = userRepository.save(user);
            return ResponseEntity.ok(updated);
        }).orElse(ResponseEntity.notFound().build());
    }

    // 4. 1-Click Examiner Demo Mode Login
    @PostMapping("/demo-login")
    public ResponseEntity<Map<String, Object>> demoLogin(@RequestBody Map<String, String> request) {
        String roleStr = request.getOrDefault("role", "FARMER").toUpperCase();
        UserRole role = UserRole.valueOf(roleStr);

        User demoUser = userRepository.findByRole(role).stream().findFirst().orElseGet(() -> {
            User u = new User("Demo " + roleStr, "+94 77 000 000" + role.ordinal(), role, "Anuradhapura", "Thirappane, Anuradhapura", 8.3114, 80.4037);
            u.setEmail("demo." + roleStr.toLowerCase() + "@farmly.lk");
            u.setIsDemoUser(true);
            return userRepository.save(u);
        });

        String token = jwtUtil.generateToken(demoUser.getId(), demoUser.getRole().name(), demoUser.getEmail() != null ? demoUser.getEmail() : demoUser.getPhone());

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("token", token);
        response.put("user", demoUser);
        response.put("message", "Logged in successfully under Examiner Demo Mode as " + demoUser.getName());

        return ResponseEntity.ok(response);
    }

    // 5. Phone login fallback
    @PostMapping("/phone-login")
    public ResponseEntity<Map<String, Object>> phoneLogin(@RequestBody Map<String, String> request) {
        String phone = request.getOrDefault("phone", "").trim();
        if (phone.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Phone number is required"));
        }

        String name = request.getOrDefault("name", "").trim();
        String roleStr = request.getOrDefault("role", "FARMER").toUpperCase();
        UserRole role;
        try {
            role = UserRole.valueOf(roleStr);
        } catch (Exception e) {
            role = UserRole.FARMER;
        }
        String district = request.getOrDefault("district", "Anuradhapura");

        final String finalName = name.isEmpty() ? "User (" + phone + ")" : name;
        final UserRole finalRole = role;
        final String finalDistrict = district;

        User user = userRepository.findByPhone(phone).map(existing -> {
            if (!finalName.startsWith("User (") && !finalName.equals(existing.getName())) {
                existing.setName(finalName);
            }
            if (finalRole != null) {
                existing.setRole(finalRole);
            }
            return userRepository.save(existing);
        }).orElseGet(() -> {
            User newUser = new User(finalName, phone, finalRole, finalDistrict, finalDistrict + ", Sri Lanka", 8.3114, 80.4037);
            newUser.setEmail(phone.replaceAll("[^0-9]", "") + "@farmly.lk");
            return userRepository.save(newUser);
        });

        String token = jwtUtil.generateToken(user.getId(), user.getRole().name(), user.getPhone());

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("token", token);
        response.put("user", user);
        response.put("message", "Logged in successfully as " + user.getName());

        return ResponseEntity.ok(response);
    }
}
