import 'package:flutter/material.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';
import '../screens/customer/customer_homepage.dart';
import '../screens/designer/designer_dashboard.dart';
import '../screens/designer/designer_profile.dart';
import '../screens/customer/customer_profile.dart';
import '../screens/customer/customer_design.dart';
import '../screens/customer/customer_furniture.dart';
import '../screens/designer/designer_homepage.dart';
import '../screens/designer/designer_furniture.dart';
import '../screens/designer/designer_design.dart';
import '../screens/designer/designer_order.dart';
import '../screens/designer/designer_order_detail.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String customerHomepage = '/customerHomepage';
  static const String designerDashboard = '/designerDashboard';
  static const String designerProfile = '/designerProfile';
  static const String customerProfile = '/customerProfile';
  static const String customerDesign = '/customerDesign';
  static const String customerFurniture = '/customerFurniture';
  static const String designerHomepage = '/designerHomepage';
  static const String designerFurniture = '/designerFurniture';
  static const String designerDesign = '/designerDesign';
  static const String designerOrder = '/designerOrder';
  static const String designerOrderDetail = '/designerOrderDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case customerHomepage:
        return MaterialPageRoute(builder: (_) => const CustomerHomePage());
      case designerDashboard:
        return MaterialPageRoute(builder: (_) => const DesignerDashboard());
      case designerProfile:
        return MaterialPageRoute(builder: (_) => const DesignerProfile());
      case customerProfile:
        return MaterialPageRoute(builder: (_) => const CustomerProfile());
      case customerDesign:
        return MaterialPageRoute(builder: (_) => const CustomerDesign());
      case customerFurniture:
        return MaterialPageRoute(builder: (_) => const CustomerFurniture());
      case designerHomepage:
        return MaterialPageRoute(builder: (_) => const DesignerHomepage());
      case designerFurniture:
        return MaterialPageRoute(builder: (_) => const DesignerFurniture());
      case designerDesign:
        return MaterialPageRoute(builder: (_) => const DesignerDesign());
      case designerOrder:
        return MaterialPageRoute(builder: (_) => const DesignerOrder());
      case designerOrderDetail:
        final orderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => DesignerOrderDetail(orderId: orderId));

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No route defined'))),
        );
    }
  }
}
