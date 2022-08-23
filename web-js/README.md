# Getting started with mfereji.io messaging.

Mfereji.io is a business communications platform that aims to simplify onboarding communications features onto customer engagement software including websites and mobile apps.

 We do this by availing easy to use modules that the software developers of our clentele can use to get started quickly without building the complex infrastructure required to run such services 
 as realtime chat among other services.

 We continue to be the preferred choice for developers who want to easily integrate reliable communications into their applications.

## Create a Mfereji.io account
In order to get started, a customer, or their software developer will need to create an account 
at mfereji.io. 

The account creation will require:
- a login username and password, or a social media account login
- an organization name, around which functionality will be organized.

Once the account is set up, an application will be created.
An application will have access credentials that will be used to authenticate and access the mfereji service. Importantly, each application will have:

- an app identifier - used to organize resources together, such as messages, users, etc.
- an app signing key - use to sign the access tokens used by frontend access to Mfereji
- an api key - used in REST API access

## Git pull our sample app
git pull the example from mfereji.io

serve the html using a basic web server

eg, on mac:
brew install http-server

$ cd chat_examples/web-js
$ http-server

go to your browser at the http server address and open the first chat window (index.html)

eg:

http://127.0.0.1:8080/index.html

Open the second chat window (index2.html)

Enjoy Mfereji chat!

## Beyond the basics

### Main concept

Mfereji.io messaging API exposes two main interfaces: 

- A presence management interface
    This interface is mainly consumed by frontend access clients, such as web pages and mobile apps. Its main role is to manage and exchange real-time data amongst application users, such as online status, new message notification events, etc.

- A message interchange interface
  This interface can be consumed by both frontends and backeds and is responsible for bulk and non-realtime data interchange. It is a RESTful interface used to access such information as pages of messages sent by a specific user, list of groups which a certain user is a member of, etc.

  It is also useful for backends to execute such admin tasks as programmatically adding or removing new users onto their mfereji.io account, managing user subscriptions, etc.

### The Client

The mfereji.io consumer client will exchange data over a Realtime websocket connection, 
- REST/JSON for web/js
- gRPC/protobuf for mobile clients

Clients will maintain realtime connection capabilities including:
- Connection status monitoring and update
- Subscription status monitoring, such as online, offline
- Realtime event generation and notification, such as so and so has joined, etc

#### Connection user parameters

The client will establish a connection with the mfereji.io API, and identify themselves using a JWT token signed with their account information.

 Since the client will be connected through a specific third-party user, mfereji will also expect a user token for such user, duly signed with the developers app signing key.

The JWT token will contain additional information about the connecting user, including:

- user id 
- client_id of the app
- expiration and renewal information
- groups that the user is connecting to 

It is important to note that the frontend client will need to obtain these credentials from their own backend (see real-world sample to get started).

The following pictogram shows the developer workflow.

#before [https://github.com/mfereji-io/chat_examples/blob/main/web-js/mfereji-workflow-Start.drawio.png]

#configure account [https://github.com/mfereji-io/chat_examples/blob/main/web-js/mfereji-workflow-Create%20account%20and%20integrate.drawio.png]

#chat [https://github.com/mfereji-io/chat_examples/blob/main/web-js/mfereji-workflow-set%20up%20chat.drawio.png]


## Further Documentation
For more documentation, please see https://docs.mfereji.io/chat

## Contact us
Use the real-time chat feature here for a quick one. We will follow up on email in case we are not online.