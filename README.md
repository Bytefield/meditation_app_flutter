# MeditApp - Aplicación de Meditación Personalizada

![Banner de MeditApp](assets/images/app_banner.png)

Aplicación móvil para sesiones de meditación personalizadas según el estado de ánimo del usuario.

## 🚀 Características

- **Autenticación segura** con JWT y cookies HTTP-Only
- **Gestión de perfiles de usuario**
- **Selección de estados de ánimo** para personalizar la experiencia
- **Sesiones de meditación** adaptadas a cada emoción
- **Seguimiento de progreso** y estadísticas
- **Diseño moderno** con Material Design 3 y tema oscuro/claro

## 🛠️ Stack Tecnológico

### Frontend (App Móvil)
- **Framework**: Flutter (Dart)
- **Gestión de Estado**: Provider
- **Navegación**: GoRouter
- **HTTP Client**: http con interceptores
- **Almacenamiento Local**: shared_preferences
- **Reproducción de Audio**: just_audio
- **Formularios**: FormBuilder
- **Estilos**: Material Design 3 con tema personalizado

### Backend (API REST)
- **Lenguaje**: Node.js con Express
- **Base de Datos**: MongoDB con Mongoose
- **Autenticación**: JWT con cookies HTTP-Only
- **Seguridad**: Bcrypt, CORS, Helmet, Rate Limiting
- **Validación**: Express Validator
- **Logging**: Morgan y Winston

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
- Flutter SDK (última versión estable)
- Node.js 16+ y npm
- MongoDB (local o Atlas)
- Un dispositivo físico o emulador

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/meditacion-app.git
   cd meditacion-app
   ```

2. **Configurar el backend**
   ```bash
   cd meditacion_app_server
   cp .env.example .env
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
