# Rago Meditation App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.19.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.3.0-blue.svg)](https://dart.dev/)

Aplicación móvil de meditación personalizada que se adapta al estado de ánimo del usuario, ofreciendo una experiencia de meditación única y personalizada.

## 📱 Características Principales

### Autenticación y Perfil
- Registro e inicio de sesión seguro con JWT
- Perfil de usuario personalizable
- Cierre de sesión seguro

### Personalización
- Selección de estados de ánimo
- Interfaz adaptativa al modo claro/oscuro
- Preferencias de notificaciones

### Meditación
- Sesiones adaptadas al estado de ánimo
- Seguimiento de progreso
- Historial de sesiones

### Seguridad
- Autenticación con JWT y cookies HTTP-Only
- Validación de formularios
- Manejo seguro de credenciales

## 🛠️ Stack Tecnológico

### Frontend (App Móvil)
- **Framework**: [Flutter 3.19.0](https://flutter.dev/) (Dart 3.3.0)
- **Gestión de Estado**: [Provider](https://pub.dev/packages/provider)
- **Navegación**: [GoRouter](https://pub.dev/packages/go_router)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio) con interceptores
- **Almacenamiento Local**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Formularios**: [flutter_form_builder](https://pub.dev/packages/flutter_form_builder)
- **UI**: [Material Design 3](https://m3.material.io/)
- **Testing**: [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html), [mockito](https://pub.dev/packages/mockito)

### Backend (API REST)
- **Runtime**: [Node.js 18+](https://nodejs.org/)
- **Framework**: [Express.js](https://expressjs.com/)
- **Base de Datos**: [MongoDB](https://www.mongodb.com/) con [Mongoose](https://mongoosejs.com/)
- **Autenticación**: [JWT](https://jwt.io/) con cookies HTTP-Only
- **Seguridad**: [bcrypt](https://www.npmjs.com/package/bcrypt), [helmet](https://helmetjs.github.io/), [cors](https://www.npmjs.com/package/cors)
- **Validación**: [express-validator](https://express-validator.github.io/)
- **Logging**: [winston](https://github.com/winstonjs/winston)

## 📱 Pantallas Principales

### Autenticación
- **Registro de usuario**
- **Inicio de sesión**
- **Recuperación de contraseña**

### Principal
- **Selección de estado de ánimo**
- **Reproductor de meditación**
- **Historial de sesiones**

### Perfil
- **Información del usuario**
- **Estadísticas de uso**
- **Configuración**

## 🔄 Integración con el Backend

### Endpoints Principales

#### Autenticación
- `POST /api/auth/register` - Registrar nuevo usuario
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/logout` - Cerrar sesión
- `GET /api/auth/profile` - Obtener perfil
- `PUT /api/auth/profile` - Actualizar perfil

#### Modelo de Datos del Usuario
```dart
class User {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final List<MoodEntry> moodHistory;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class MoodEntry {
  final String mood;
  final DateTime date;
}
```

## 🚀 Empezando

### Requisitos Previos

#### Para Desarrollo
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.19.0 o superior)
- [Dart SDK](https://dart.dev/get-dart) (3.3.0 o superior)
- [Node.js](https://nodejs.org/) (18.x LTS o superior)
- [npm](https://www.npmjs.com/) (9.x o superior) o [Yarn](https://yarnpkg.com/)
- [MongoDB](https://www.mongodb.com/try/download/community) (6.0 o superior) o [MongoDB Atlas](https://www.mongodb.com/atlas/database)
- Un emulador o dispositivo físico para pruebas

#### Para Producción
- Servidor con Node.js 18.x
- Base de datos MongoDB (autogestionada o MongoDB Atlas)
- Servidor web (Nginx, Apache) para servir la aplicación compilada
- Certificado SSL (recomendado)

### 🛠️ Instalación

1. **Clonar el repositorio**
   ```bash
   # Clonar el repositorio
   git clone https://github.com/Bytefield/meditation_app_flutter.git
   cd meditation_app_flutter
   ```

2. **Configuración del Entorno**
   ```bash
   # Copiar archivo de configuración de ejemplo
   cp .env.example .env
   ```
   
   Editar el archivo `.env` con tus configuraciones:
   ```env
   # Configuración de la API
   API_BASE_URL=http://localhost:3000
   
   # Configuración de Firebase (opcional)
   FIREBASE_API_KEY=your_api_key
   FIREBASE_AUTH_DOMAIN=your_auth_domain
   FIREBASE_PROJECT_ID=your_project_id
   ```

3. **Instalar Dependencias**
   ```bash
   # Instalar dependencias de Flutter
   flutter pub get
   
   # Instalar dependencias del backend
   cd ../meditation_app_server
   npm install
   ```

4. **Configurar Base de Datos**
   - Asegúrate de tener MongoDB en ejecución
   - Configura la conexión en `meditation_app_server/.env`

5. **Ejecutar la Aplicación**
   ```bash
   # Iniciar el servidor de desarrollo de Flutter
   flutter run
   
   # En otra terminal, iniciar el servidor backend
   cd meditation_app_server
   npm run dev
   ```

## 🧪 Testing

### Ejecutar Pruebas Unitarias
```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas con cobertura
flutter test --coverage
```

### Ejecutar Pruebas de Integración
```bash
flutter test integration_test/
```

## 🏗️ Estructura del Proyecto

```
lib/
├── config/              # Configuraciones de la aplicación
├── models/              # Modelos de datos
├── providers/           # Proveedores de estado (Provider)
├── screens/            # Pantallas de la aplicación
│   ├── auth/           # Flujos de autenticación
│   ├── home/           # Pantalla principal
│   └── profile/        # Gestión de perfil
├── services/           # Servicios (API, almacenamiento, etc.)
├── theme/              # Temas y estilos
├── utils/              # Utilidades y helpers
└── widgets/            # Componentes reutilizables
```

## 🤝 Contribuir

1. Haz un fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Haz push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Contacto

Tu Nombre - [@tu_twitter](https://twitter.com/tu_twitter) - tu.email@ejemplo.com

Enlace del Proyecto: [https://github.com/Bytefield/meditation_app_flutter](https://github.com/Bytefield/meditation_app_flutter)
   # Editar .env con tus configuraciones
   npm install
   npm run dev
   ```

3. **Configurar el frontend**
   ```bash
   cd ../meditacion_app
   flutter pub get
   flutter run
   ```

## 📁 Estructura del Proyecto

### Frontend (App Móvil)
```
meditacion_app/
├── assets/               # Recursos estáticos
│   ├── images/          # Imágenes
│   ├── fonts/           # Fuentes personalizadas
│   └── audio/           # Archivos de audio
├── lib/
│   ├── config/         # Configuraciones
│   ├── models/          # Modelos de datos
│   ├── providers/       # Providers para gestión de estado
│   ├── screens/         # Pantallas de la aplicación
│   │   ├── auth/        # Pantallas de autenticación
│   │   ├── home/        # Pantalla principal
│   │   └── profile/     # Perfil de usuario
│   ├── services/        # Servicios y API
│   ├── utils/           # Utilidades y constantes
│   ├── widgets/         # Componentes reutilizables
│   ├── app_router.dart  # Configuración de rutas
│   ├── app_theme.dart   # Tema de la aplicación
│   └── main.dart        # Punto de entrada
└── ...
```

### Backend (API REST)
```
meditacion_app_server/
├── config/            # Configuraciones
│   └── db.js         # Conexión a MongoDB
├── controllers/       # Controladores de la API
│   └── authController.js  # Lógica de autenticación
├── middleware/        # Middlewares
│   ├── auth.js       # Middleware de autenticación
│   └── error.js      # Manejo de errores
├── models/            # Modelos de MongoDB
│   └── User.js       # Modelo de Usuario
├── routes/            # Definición de rutas
│   └── authRoutes.js # Rutas de autenticación
├── .env.example      # Variables de entorno de ejemplo
└── server.js         # Punto de entrada del servidor
```

## 🔒 Seguridad

- Autenticación con JWT almacenado en cookies HTTP-Only
- Validación de formularios en el cliente y servidor
- Manejo seguro de credenciales
- Protección de rutas autenticadas
- CORS configurado para el dominio del frontend
- Rate limiting para prevenir ataques de fuerza bruta
- Headers de seguridad con Helmet

## 🧪 Pruebas

### Pruebas Unitarias
```bash
# Ejecutar pruebas del backend
cd meditacion_app_server
npm test

# Ejecutar pruebas del frontend
cd ../meditacion_app
flutter test
```

### Cobertura de Código
```bash
# Generar cobertura del backend
npm run test:coverage

# Generar cobertura del frontend
flutter test --coverage
```

## 🚀 Despliegue

### Configuración de Producción
1. Asegúrate de configurar correctamente las variables de entorno en producción
2. Configura HTTPS con certificados SSL válidos
3. Configura un servidor web como Nginx como proxy inverso

### Backend en Producción
```bash
# Construir para producción
npm run build

# Iniciar en producción
npm start
```

### Frontend en Producción
```bash
# Construir APK para Android
flutter build apk --release

# Construir App Bundle para Play Store
flutter build appbundle

# Construir para iOS
flutter build ios --release
```

## 🤝 Contribución

1. Haz un fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Haz push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más información.

## 🙏 Agradecimientos

- A todos los colaboradores que han ayudado a mejorar este proyecto
- A la comunidad de Flutter por su increíble soporte
- A los desarrolladores de los paquetes utilizados

---

<div align="center">
  <sub>Desarrollado con ❤️ por J. Miguel Ramos Perez</sub>
</div>
