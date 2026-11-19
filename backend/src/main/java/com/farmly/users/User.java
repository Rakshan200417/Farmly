package com.farmly.users;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(unique = true)
    private String email;

    private String password;

    private String phone;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role = UserRole.FARMER;

    private String district;

    private String locationName;

    private Double latitude = 8.3114;

    private Double longitude = 80.4037;

    private Double rating = 4.8;

    private Integer reviewsCount = 112;

    private Boolean isVerified = true;

    private Boolean isDemoUser = false;

    @Column(columnDefinition = "LONGTEXT")
    private String profilePicture;

    private LocalDateTime createdAt = LocalDateTime.now();

    public User() {}

    public User(String name, String phone, UserRole role, String district, String locationName, Double latitude, Double longitude) {
        this.name = name;
        this.phone = phone;
        this.role = role;
        this.district = district;
        this.locationName = locationName;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public User(String name, String email, String password, UserRole role, String district) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.district = district;
        this.locationName = district != null ? district + ", Sri Lanka" : "Sri Lanka";
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public UserRole getRole() { return role; }
    public void setRole(UserRole role) { this.role = role; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public Integer getReviewsCount() { return reviewsCount; }
    public void setReviewsCount(Integer reviewsCount) { this.reviewsCount = reviewsCount; }

    public Boolean getIsVerified() { return isVerified; }
    public void setIsVerified(Boolean verified) { isVerified = verified; }

    public Boolean getIsDemoUser() { return isDemoUser; }
    public void setIsDemoUser(Boolean demoUser) { isDemoUser = demoUser; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
}
