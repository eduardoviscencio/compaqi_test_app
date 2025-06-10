# COMPAQi Test APP - Locations APP

Aplicación que permite compartir tus lugares favoritos alrededor del mundo.

## Arquitectura

### Capa de Aplicación

La carpeta `/lib/application` contiene casos de uso organizados por funcionalidad:
- `use_cases/auth/`: Operaciones de autenticación (login, logout)
- `use_cases/locations/`: Gestión de ubicaciones (agregar, eliminar, obtener ubicaciones guardadas)

Los casos de uso encapsulan la lógica de negocio y coordinan entre los repositorios del dominio y la capa de presentación.

### Capa de Inyección de Dependencias

La carpeta `/lib/di` contiene la configuración de inyección de dependencias:
- `injection.dart`: Centraliza y gestiona todas las dependencias de la aplicación

La clase DependencyInjector crea y conecta las fuentes de datos, repositorios y casos de uso con el flujo de dependencias adecuado.

### Capa de Dominio

La carpeta `/lib/domain` contiene la lógica de negocio central:
- `models/`: Entidades de negocio (User, Location)
- `repositories/`: Interfaces abstractas de repositorios (AuthRepository, LocationRepository)

La capa de dominio define contratos y reglas de negocio sin dependencias de frameworks externos.

### Capa de Infraestructura

La carpeta `/lib/infrastructure` contiene implementaciones de servicios externos:
- `data_sources/`: Acceso a datos externos (Google Auth, Locations API)
- `repositories/`: Implementación de interfaces de repositorios del dominio
- `dtos/`: Objetos de transferencia de datos para comunicación con la API
- `config/`: Configuración del entorno y OAuth
- `services/`: Servicios utilitarios (gestión de tokens)
- `utils/`: Funciones auxiliares para análisis de datos

La capa de infraestructura maneja todas las dependencias externas y proporciona implementaciones concretas para las abstracciones del dominio.

### Capa de Presentación

La carpeta `/lib/presentation` contiene la interfaz de usuario y gestión de estado:
- `screens/`: Pantallas de la aplicación (auth, locations, map)
- `providers/`: Gestión de estado usando el patrón Provider
- `widgets/`: Componentes de UI reutilizables (drawer, snackbar, campos de texto, etc)
- `theme/`: Estilos de la aplicación (colores, fuentes, datos del tema)
- `ui/`: Decoraciones de UI y utilidades de estilo
- `l10n/`: Archivos de localización para internacionalización (se adapta al idioma del sistema)

La capa de presentación maneja las interacciones del usuario y muestra datos de la capa de aplicación a través de providers.

## Paquetes Principales

- **provider**: Solución de gestión de estado
- **flutter_appauth**: Autenticación OAuth 2.0
- **google_maps_flutter**: Integración de Google Maps para mostrar mapas
- **google_places_flutter**: API de Google Places para búsqueda de ubicaciones
- **http**: Cliente HTTP para comunicación con APIs
- **flutter_secure_storage**: Almacenamiento seguro para datos sensibles (tokens)
- **equatable**: Simplifica las comparaciones de igualdad para modelos
- **mockito**: Generación de mocks para pruebas

## Decisiones técnicas clave

Tomando en cuenta todos los puntos solicitados en la prueba, se optó por desarrollar una aplicación funcional que integrara cada uno de ellos de manera coherente. La solución presentada permite a los usuarios autenticarse mediante OAuth con Google y comunicarse con una API pública propia. Aunque la creación de esta API no formaba parte explícita de los requisitos, se consideró esencial para garantizar una comunicación adecuada entre la aplicación y el backend, permitiendo así obtener, guardar y eliminar datos de forma segura en una base de datos.

**URL**: https://compaqi-test-backend.onrender.com
**Repositorio**: https://github.com/eduardoviscencio/compaqi-test-backend

## Mejoras futuras

1. **Comunicación en tiempo real**: Implementar actualizaciones de marcadores en tiempo real utilizando tecnologías como Socket.IO, permitiendo que los usuarios vean las ubicaciones compartidas por otros usuarios de forma instantánea sin necesidad de recargar la aplicación.

2. **Manejo avanzado de errores**: Integrar herramientas como Firebase Crashlytics para el monitoreo y reporte automático de errores, facilitando la identificación y resolución de problemas en producción. Además, es óptimo manejar CustomExceptions para identificar de manera correcta los errores.

3. **Cambio dinámico de idioma**: Permitir a los usuarios cambiar el idioma de la aplicación directamente desde la interfaz, independientemente del idioma del sistema, ofreciendo una experiencia más personalizada y flexible.

4. **Automatización de despliegue continuo**: Implementar herramientas como Fastlane para automatizar completamente el proceso de despliegue a las tiendas de aplicaciones (Google Play Store y App Store). Esto incluiría la automatización de subida de metadatos, capturas de pantalla, generación automática de changelogs, y distribución a diferentes tracks (alpha, beta, producción), reduciendo significativamente el tiempo y esfuerzo manual requerido para cada release.