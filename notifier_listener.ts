import { Client } from 'pg';

const client = new Client({
      host: 'localhost',
      port: 5432,
      user: 'postgres',
      password: 'postgres',
      database: 'postgres'
  });

    // const client = LtiDb.client
    client.connect((err: any) => {
      if (err) {
          console.log('Error in connecting database: ', err);
      } else {
          console.log('Database connected');
  
          client.on('notification', (msg: any) => {
              console.log('msg.payload');
              console.log(msg.payload);
          });
  
          const query = client.query('LISTEN update_notification');
      }
  });
  

// msg.payload
// {"operation" : "update", "data" : {"id":93995,"name":"Sample College","state_id":34,"university_id":4000,"unique_code":"U-0011","created_at":null,"updated_at":null,"workflow_state":"active"}}
// msg.payload
// {"operation" : "delete", "data" : {"id":93995,"name":"Sample College","state_id":34,"university_id":4000,"unique_code":"U-0011","created_at":null,"updated_at":null,"workflow_state":"active"}}
// msg.payload
// {"operation" : "insert", "data" : {"id":93996,"name":"Sample College","state_id":3,"university_id":4000,"unique_code":"U-0011","created_at":null,"updated_at":null,"workflow_state":"active"}}

