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
  
