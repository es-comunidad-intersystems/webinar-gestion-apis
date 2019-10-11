# webinar-gestion-apis
Webinar sobre cómo desarrollar y gestionar APIs con InterSystems IRIS Data Platform

# ¿Qué necesitas?
* Docker Container
* Docker Compose
* Postman
* IRIS 2019.3
* IRIS API Manager
* Visual Studio Code
* Plugin VS Code InterSystems ObjectScript

# Desarrollo API 
## Configuración previa
Carga la imagen Docker de InterSystems IRIS
```
$ docker load -i iris-2019.3.0.302.0-docker.tar
```

## Descargar código del webinar
```
$ git clone https://github.com/es-comunidad-intersystems/webinar-gestion-apis.git
```

Copia la licencia de InterSystems IRIS en `config/iris.key`.

## Construir imagen Docker del webinar
Construiremos una imagen Docker que contiene un IRIS con todo lo que necesitamos para el webinar.
```
$ docker build . --tag webinar-gestion-apis:stable --no-cache
```

### Ejecutar container del webinar
Ejecutamos la instancia de IRIS que utilizaremos durante el webinar.
```
$ docker-compose up -d
```

* Accede al portal de gestión de IRIS con el usuario `superuser` y contraseña `SYS`
http://localhost:52773/csp/sys/UtilHome.csp

* Cambia la contraseña inicial.


## Especificaciones

### OpenAPI (Swagger)
* La especificación de la API está en `shared/leaderboard-api-v1.yaml`. 
* Abre https://editor.swagger.io ó https://app.swaggerhub.com/login y échale un vistazo.

## Implementación
La imagen Docker que nos hemos construido para el webinar ya tiene la API implementada y lista para funcionar :)

Así que puedes saltar directamente a la sección [Probar la API](#probar-la-api).

De todas formas, te ponemos a continuación los pasos para crearla desde cero tú mismo.

### Generar API a partir de especificaciones
En este caso utilizamos la herramienta de línea de comando `^%REST` para crear el código a partir de las especificaciones.

Abre una sesión de sesión de WebTerminal desde http://localhost:52773/terminal/

```
WEBINAR > do ^%REST 
REST Command Line Interface (CLI) helps you CREATE or DELETE a REST application.Enter an application name or (L)ist all REST applications (L): L 
Applications        Web Applications
------------        ----------------
Enter an application name or (L)ist all REST applications (L): Webinar.API.Leaderboard.v1
REST application not found: Webinar.API.Leaderboard.v1
Do you want to create a new REST application? Y or N (Y): Y
File path or absolute URL of a swagger document.
If no document specified, then create an empty application.
OpenAPI 2.0 swagger: /shared/leaderboard-api-v1.json

OpenAPI 2.0 swagger document: /shared/leaderboard-api-v1.json
Confirm operation, Y or N (Y): Y
-----Creating REST application: Webinar.API.Leaderboard.v1-----
CREATE Webinar.API.Leaderboard.v1.spec
GENERATE Webinar.API.Leaderboard.v1.disp
CREATE Webinar.API.Leaderboard.v1.impl
REST application successfully created.

Create a web application for the REST application? Y or N (Y): Y
Specify web application name. Default is /csp/Webinar/API/Leaderboard/v1
Web application name: /leaderboard/api/v1

-----Deploying REST application: Webinar.API.Leaderboard.v1-----
Application Webinar.API.Leaderboard.v1 deployed to /leaderboard/api/v1
```

### Completa el código de los métodos

Utiliza Visual Studio Code + [InterSystems ObjectScript Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) para conectar a la instancia de IRIS.

Completa el código que falta en los métodos de la clase `Webinar.API.Leaderboard.v1.impl`.

#### addPlayer
```
ClassMethod addPlayer(body As %DynamicObject) As %DynamicObject
{
    set player = ##class(Webinar.Data.Player).%New()
    do player.%JSONImport(body)
    set sc = player.%Save()
    if $$$ISERR(sc) {
    	do ..%SetStatusCode(405)
    	quit ""
    }
    do player.%JSONExportToStream(.stream)
    quit stream
}
```

#### getPlayers
```
ClassMethod getPlayers() As %DynamicObject
{
    set sql = "SELECT Id, Name, Alias FROM Webinar_Data.Player order by Score"
    set statement = ##class(%SQL.Statement).%New()
    set sc = statement.%Prepare(sql)
    set rs = statement.%Execute()
    
    set array = []
    while rs.%Next() {
    	do array.%Push( 
    		{
    			"Id": (rs.%Get("Id")),
    			"Name": (rs.%Get("Name")),
    			"Alias": (rs.%Get("Alias"))
    		})
    }
    
    quit array
}
```

#### getPlayerById
```
ClassMethod getPlayerById(playerId As %Integer) As %DynamicObject
{
    set player = ##class(Webinar.Data.Player).%OpenId(playerId)
    if '$isobject(player) {
    	do ..%SetStatusCode(404)
    	quit ""
    }
    do player.%JSONExportToStream(.stream)
    quit stream
}
```

#### updatePlayer
```
ClassMethod updatePlayer(playerId As %Integer, body As %DynamicObject) As %DynamicObject
{
    set player = ##class(Webinar.Data.Player).%OpenId(playerId)
    if '$isobject(player) {
    	do ..%SetStatusCode(404)
    	quit ""
    }
    do player.%JSONImport(body)
    do player.%Save()
    do player.%JSONExportToStream(.stream)
    quit stream
}
```

#### deletePlayer
```
ClassMethod deletePlayer(playerId As %Integer) As %DynamicObject
{
    set sc = ##class(Webinar.Data.Player).%DeleteId(playerId)
    if $$$ISERR(sc) {
    	do ..%SetStatusCode(404)
    }
    quit ""
}
```

### Configurar acceso a la API en IRIS
* Configurar aplicación web creada automáticamente `/leaderboard/api/v1`
* Permitir acceso sin autenticar y atribuir el rol temporal `Webinar`.

### Probar la API
* Cargar en Postman el archivo `postman/leaderboard-api.postman_collection.json`
* Probar `GET Player`, `GET Players`, `POST Player` y `PUT Player`


# API Manager
## Instalación
* *Habilita* y establece una *nueva contraseña* al usuario IAM en [Portal Gestión IRIS](http://localhost:52773/csp/sys/UtilHome.csp) 
`System Administration > Security > Users > IAM`.
* *Habilita* la aplicación web /api/iam en [Portal Gestión IRIS](http://localhost:52773/csp/sys/UtilHome.csp) 
`System Administration > Security > Applications > Web Applications`.
* Descomprime archivo `IAM-0.34-1-1.tar` (creará el directorio `IAM`) 

* Cargar imagen docker IAM
```
$ docker load -i iam_image.tar
```

* Configuración inicial. Script que prepara las variables de entorno para que IAM se conecte a nuestro IRIS.
```
$ cd IAM/scripts/unix
$ source iam-setup.sh 
Welcome to the InterSystems IRIS and InterSystems API Manager (IAM) setup script.
This script sets the ISC_IRIS_URL environment variable that is used by the IAM container to get the IAM license key from InterSystems IRIS.
Enter the full image repository, name and tag for your IAM docker image: intersystems/iam:0.34-1-1
Enter the IP address for your InterSystems IRIS instance. The IP address has to be accessible from within the IAM container, therefore, do not use "localhost" or "127.0.0.1" if IRIS is running on your local machine. Instead use the public IP address of your local machine. If IRIS is running in a container, use the public IP address of the host environment, not the IP address of the IRIS container: {ipaddr}
Enter the web server port for your InterSystems IRIS instance: 52773
Enter the password for the IAM user for your InterSystems IRIS instance: 
Re-enter your password: 
Your inputs are:
Full image repository, name and tag for your IAM docker image: intersystems/iam:0.34-1-1
IP address for your InterSystems IRIS instance: {ipaddr}
Web server port for your InterSystems IRIS instance: 52773
Would you like to continue with these inputs (y/n)? y
Getting IAM license using your inputs...
Successfully got IAM license!
The ISC_IRIS_URL environment variable was set to: http://IAM:***@{ipaddr}:52773/api/iam/license
WARNING: The environment variable is set for this shell only!
To start the services, run the following command in the top level directory: docker-compose up -d
To stop the services, run the following command in the top level directory: docker-compose down
URL for the IAM Manager portal: http://localhost:8002
```

* Ejecutar API Manager
```
$ cd IAM/scripts
$ docker-compose up -d
```

* Accede al API Manager utilizando http://localhost:8002/default/dashboard


## Añadir la API al API Manager

Añadir un servicio que invoque a la API desarrollada en IRIS
```
$ curl -i -X POST --url http://localhost:8001/services/ \
--data 'name=iris-leaderboard-v1-service' \
--data 'url=http://{ipaddr}:52773/leaderboard/api/v1'
```

Añadir una ruta al IAM por la que se pueda acceder al servicio que hemos desarrollado en IRIS
```
$ curl -i -X POST --url http://localhost:8001/services/iris-leaderboard-v1-service/routes \
--data 'paths[]=/leaderboard'
```

Probar en Postman `IAM - Get Player - No auth`.

## Añadir autenticación
Añadir el plugin *Key Authentication* al servicio de iris-leaderboard-v1.
```
$ curl -X POST http://localhost:8001/services/iris-leaderboard-v1-service/plugins \
    --data "name=key-auth"
```

Probar de nuevo en Postman `IAM - Get Player - No auth`.

### Consumidores
Con la autenticación habilitada, crear consumidores que pueden autenticarse al utilizar la API.

Crear un consumidor `systemA`
```
$ curl -d "username=systemA&custom_id=SYSTEM_A" http://localhost:8001/consumers/
```

Crear la clave para `systemA`
```
$ curl -X POST http://localhost:8001/consumers/systemA/key-auth -d 'key=systemAsecret'
```

Probar en Postman `IAM - GET Player. Consumer SystemA`.

Crear un consumidor `webapp`
```
$ curl -d "username=webapp&custom_id=WEB_APP" http://localhost:8001/consumers/
```

Crear la clave para `webapp`
```
$ curl -X POST http://localhost:8001/consumers/webapp/key-auth -d 'key=webappsecret'
```

Probar en Postman `IAM - GET Players - Consumer WebApp`.

## Restricción de tráfico
Podemos simular tráfico de peticiones a la API utilizando el script `shared/simulate.sh`.

Crear una restricción de tráfico para el consumidor `webapp`. Limitar a 100 llamadas por minuto.
```
$ curl -X POST http://localhost:8001/consumers/webapp/plugins \
    --data "name=rate-limiting" \
    --data "config.minute=100"
```

## Developer Portal

### Configurar el Developer Portal
Configuramos el portal para que los desarrolladores se puedan registrar automáticamente.
[Portal IAM](http://localhost:8002/default/dashboard) `Dev Portal > Settings > Authentication Plugin=Basic, Auto Approve Access=Enable > Save Changes`

### Publicar especificaciones API
Publicamos las especificaciones de nuestra API para que estén disponibles en el portal:
[Portal IAM](http://localhost:8002/default/dashboard) `Dev Portal > Specs > Add Spec > "leaderboard" > Añadir especificaciones`

### Desarrolladores y API credentials
* Accedemos al [Developer Portal](http://127.0.0.1:8003/default) y hacemos click en `Sign Up`.
* Como desarrolladores, nos creamos una API en `Create API Credential`.
* Probamos en Postman `IAM - Get Players - Developer` cambiando la cabecera `api-key` por la API credential que acabamos de generar.
* Podemos acceder a la documentación publicada de APIs haciendo click en `Documentation`.
