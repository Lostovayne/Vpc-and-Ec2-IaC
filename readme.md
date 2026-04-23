# 🌐 AWS VPC Architecture - Public Subnet with NGINX

<div align="center">
  <img src="https://i.sstatic.net/wH20f9xV.png" alt="AWS VPC Architecture with NGINX" width="800"/>
</div>

Este proyecto documenta una arquitectura básica en AWS donde se expone un servidor web (NGINX) a Internet utilizando una **VPC con una subnet pública**. Este diseño es ideal para ser implementado como Infraestructura como Código (IaC) utilizando **Terraform**.

---

## 🏗️ Arquitectura

La infraestructura está compuesta por los siguientes componentes clave de AWS:

- ☁️ **VPC (Virtual Private Cloud)**
- 🟩 **Public Subnet**
- 🌐 **Internet Gateway**
- 🧭 **Route Table (Public RTB)**
- 🔐 **Security Group**
- 🖥️ **EC2 Instance con NGINX**

---

## 🔷 1. VPC (Virtual Private Cloud)

La VPC es el entorno de red aislado donde se despliegan todos los recursos.

- 📍 Define un rango de direcciones IP privadas (ej: `172.16.0.0/16`).
- 🛡️ Proporciona aislamiento lógico dentro de AWS.
- 🎛️ Permite controlar completamente la topología de red.

> 💡 **Nota:** Es el equivalente lógico a un datacenter tradicional en la nube.

---

## 🟩 2. Public Subnet

Una subnet pública es una subdivisión de la VPC que permite acceso directo a Internet.

- 🔢 Forma parte del rango IP de la VPC (ej: `172.16.1.0/24`).
- 🔗 Está asociada a una tabla de rutas con una ruta predeterminada hacia Internet.
- 📦 Contiene la instancia EC2 que ejecuta NGINX.

> 💡 **Nota:** Una subnet se considera "pública" solo si su tabla de rutas apunta a un Internet Gateway.

---

## 🌐 3. Internet Gateway (IGW)

El Internet Gateway es el componente que permite la comunicación bidireccional entre los recursos de la VPC e Internet.

- ⚙️ Completamente gestionado por AWS.
- ⚡ Altamente disponible y escalable.
- 🚦 Permite tanto el tráfico entrante como el saliente.

---

## 🧭 4. Route Table (Public RTB)

La tabla de rutas actúa como un enrutador virtual, definiendo cómo se dirige el tráfico dentro y fuera de la VPC.

**Configuración clave:**

- **Rutas internas:**
  - `172.16.0.0/16` → `local` (Comunicación interna dentro de la VPC).
- **Ruta pública:**
  - `0.0.0.0/0` → `Internet Gateway` (Acceso al exterior).

> 💡 **Nota:** Esta última regla (`0.0.0.0/0`) es la que habilita efectivamente a la subnet para tener salida y entrada desde Internet.

---

## 🔐 5. Security Group

El Security Group actúa como un firewall virtual a nivel de instancia, controlando el tráfico hacia y desde la EC2.

### 📥 Reglas de Entrada (Inbound):

- ✅ **Puerto `80` (HTTP):** Para tráfico web no encriptado.
- ✅ **Puerto `443` (HTTPS):** Para tráfico web seguro.

### 📤 Reglas de Salida (Outbound):

- ✅ Permitidas por defecto hacia cualquier destino (`0.0.0.0/0`).

### 📌 Características:

- **Stateful:** Las respuestas a peticiones entrantes permitidas están automáticamente autorizadas.
- Asociado directamente a la Interfaz de Red (ENI) de la instancia EC2.

---

## 🖥️ 6. EC2 Instance (NGINX)

Servidor virtual desplegado dentro de la subnet pública.

- 🚀 Ejecuta el servidor web **NGINX**.
- 🎧 Escucha peticiones en los puertos `80` (HTTP) y `443` (HTTPS).
- 🌍 Accesible públicamente desde cualquier parte de Internet gracias a una IP pública o Elastic IP.

---

## 🔁 Flujo de Tráfico

### 📥 Flujo de Entrada (Request)

1. 👤 El cliente realiza una petición desde su navegador (ej: `http://example.com`).
2. 🚪 La petición llega al **Internet Gateway** de la VPC.
3. 🗺️ La **Route Table** evalúa el destino y enruta el tráfico hacia la **Public Subnet**.
4. 🎯 El tráfico alcanza la interfaz de red de la **Instancia EC2**.
5. 🛡️ El **Security Group** valida la conexión y permite el paso si el puerto es el 80 o 443.
6. ⚙️ **NGINX** recibe y procesa la solicitud web.

### 📤 Flujo de Salida (Response)

1. 📄 NGINX genera la página web o respuesta HTTP.
2. 🛫 El paquete sale de la instancia EC2.
3. 🔓 El **Security Group**, al ser _stateful_, permite automáticamente la respuesta saliente vinculada a la conexión inicial.
4. 🛣️ La tabla de rutas dirige el tráfico de vuelta a través del **Internet Gateway**.
5. 💻 La respuesta llega finalmente al cliente original.

---

## 🧠 Resumen de Componentes

| Componente              | Función Principal                                 |
| :---------------------- | :------------------------------------------------ |
| ☁️ **VPC**              | Red privada virtual y aislada en AWS.             |
| 🟩 **Public Subnet**    | Segmento de la red con acceso directo a Internet. |
| 🌐 **Internet Gateway** | Puerta de enlace física lógica hacia Internet.    |
| 🧭 **Route Table**      | Conjunto de reglas de enrutamiento de red.        |
| 🔐 **Security Group**   | Firewall virtual a nivel de instancia.            |
| 🖥️ **EC2 + NGINX**      | Servidor web que atiende las peticiones.          |

---

## ⚠️ Consideraciones y Limitaciones

Esta arquitectura representa el escenario más **básico** posible y presenta ciertas limitaciones para entornos de producción:

- ❌ **No incluye Load Balancer (ALB):** Todo el tráfico va a un solo servidor.
- ❌ **No tiene Auto Scaling:** No se adapta automáticamente a picos de demanda.
- ❌ **No usa subnets privadas:** La base de datos o lógica de negocio (si hubiera) estaría expuesta en una subnet pública.
- ❌ **No incluye NAT Gateway:** No aplicable en este caso de uso específico, pero necesario si tuviéramos recursos en subnets privadas que requieran salida a Internet.
- ❌ **Punto único de fallo (SPOF):** Toda la aplicación depende de una sola instancia EC2 en una única Availability Zone.

---

## ✅ Casos de Uso Ideales

- 🧪 Entornos de prueba y QA.
- 🛠️ Prototipos rápidos (PoC).
- 📚 Laboratorios de aprendizaje sobre redes en AWS y Terraform.
- 📄 Alojamiento de servicios o páginas estáticas muy simples.

---

## 🚀 Posibles Mejoras (Evolución de la Arquitectura)

Para transformar esta arquitectura básica en una solución robusta y lista para producción (Production-Ready), se podría implementar:

- ⚖️ **Application Load Balancer (ALB):** Para distribuir tráfico entre múltiples instancias.
- 📈 **Auto Scaling Group (ASG):** Para reemplazar instancias caídas y escalar según la carga.
- 🔒 **Arquitectura Multi-Tier:** Mover la aplicación a **subnets privadas** y dejar solo el Load Balancer en la subnet pública.
- 🌐 **NAT Gateway:** Para proporcionar salida a Internet segura a las instancias en las subnets privadas.
- 🛡️ **AWS WAF:** Incorporar un Firewall de Aplicaciones Web para seguridad adicional frente a ataques comunes (SQLi, XSS).

---

## 📌 Nota Final

Este diseño y su implementación en Terraform priorizan la simplicidad y la claridad. Su objetivo principal es ayudar a entender los conceptos fundamentales de networking en AWS y cómo interconectarlos de manera efectiva.
