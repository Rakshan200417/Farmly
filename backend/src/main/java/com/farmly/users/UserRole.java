package com.farmly.users;

import jakarta.persistence.*;
import java.time.LocalDateTime;

public enum UserRole {
    FARMER,
    BUYER,
    SHOP,
    MARKET_ADMIN,
    ADMIN
}
