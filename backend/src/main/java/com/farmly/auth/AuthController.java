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

    // 1-Click Examiner Demo Mode Login
    @PostMapping("/demo-login")
    public ResponseEntity<Map<String, Object>> demoLogin(@RequestBody Map<String, String> request) {
        String roleStr = request.getOrDefault("role", "FARMER").toUpperCase();
        UserRole role = UserRole.valueOf(roleStr);

        User demoUser = userRepository.findByRole(role).stream().findFirst().orElseGet(() -> {
            User u = new User("Demo " + roleStr, "+94 77 000 000" + role.ordinal(), role, "Anuradhapura", "Thirappane, Anuradhapura", 8.3114, 80.4037);
            u.setIsDemoUser(true);
            return userRepository.save(u);
        });

        String token = jwtUtil.generateToken(demoUser.getId(), demoUser.getRole().name(), demoUser.getPhone());

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("token", token);
        response.put("user", demoUser);
        response.put("message", "Logged in successfully under Examiner Demo Mode as " + demoUser.getName());

        return ResponseEntity.ok(response);
    }

    @PostMapping("/otp/send")
    public ResponseEntity<Map<String, Object>> sendOtp(@RequestBody Map<String, String> request) {
        String phone = request.getOrDefault("phone", "+94 71 234 5678");
        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Verification code sent to " + phone,
                "demoCode", "123456"
        ));
    }

    @PostMapping("/otp/verify")
    public ResponseEntity<Map<String, Object>> verifyOtp(@RequestBody Map<String, String> request) {
        String phone = request.getOrDefault("phone", "+94 71 234 5678");
        String roleStr = request.getOrDefault("role", "FARMER").toUpperCase();
        UserRole role = UserRole.valueOf(roleStr);

        User user = userRepository.findByPhone(phone).orElseGet(() -> {
            User newUser = new User("Suneth Perera", phone, role, "Anuradhapura", "Anuradhapura, Sri Lanka", 8.3114, 80.4037);
            return userRepository.save(newUser);
        });

        String token = jwtUtil.generateToken(user.getId(), user.getRole().name(), user.getPhone());

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("token", token);
        response.put("user", user);

        return ResponseEntity.ok(response);
    }
}
