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
  
// {"id":93867,"name":"NETAJI SUBHAS UNIVERSITY OF TECHNOLOGY2","state_id":10,"university_id":3094,"unique_code":"U-1056","created_at":"2021-03-08T19:34:55.367821","updated_at":"2021-03-08T19:34:55.367821","workflow_state":"active"}
