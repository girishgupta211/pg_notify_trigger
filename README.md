This TRIGGER function calls PosgreSQL's NOTIFY command with a JSON payload. 

You can listen for these calls and then send the JSON payload to a message queue (like AMQP/RabbitMQ) or trigger other actions.



There's some restrictions in terms on what you can send

Maximum of 8000 bytes in the payload
8GB queue by default.
