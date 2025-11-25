// FILE: lib/config/routes.dart
// PURPOSE: Route definitions

import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/main/main_navigation.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/address_book_screen.dart';
import '../screens/checkout/address_form_screen.dart';
import '../screens/orders/order_history_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/profile/favorites_screen.dart';
import '../screens/profile/payment_methods_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/add_product_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String checkout = '/checkout';
  static const String addressBook = '/address-book';
  static const String addressForm = '/address-form';
  static const String orderHistory = '/order-history';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String favorites = '/favorites';
  static const String paymentMethods = '/payment-methods';
  static const String adminDashboard = '/admin-dashboard';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    home: (context) => const MainNavigation(),
    checkout: (context) => const CheckoutScreen(),
    addressBook: (context) => const AddressBookScreen(),
    addressForm: (context) => const AddressFormScreen(),
    orderHistory: (context) => const OrderHistoryScreen(),
    editProfile: (context) => const EditProfileScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    favorites: (context) => const FavoritesScreen(),
    paymentMethods: (context) => const PaymentMethodsScreen(),
    adminDashboard: (context) => const AdminDashboard(),
    addProduct: (context) => const AddProductScreen(),
  };
}
