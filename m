From: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Subject: asynchronous operation with poll()
Date: Tue, 09 Nov 2010 15:58:27 +0000
Message-ID: <ibbr34$ima$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have a client and server test program to explore fully asynchronous 
communication written as close to a conventional sockets application as 
possible and am encountering difficulty.

Both programs run the same code in a thread, sending buffers to each 
other as fast as possible. On the client side only, my poll() call never 
blocks and cm_id->send_cq_channel->fd always seems to be readable. This 
causes the program to loop wildly and consume 100% CPU.

Any ideas? I have ensured that O_NONBLOCK is set on the underlying file 
descriptors. I'm not sure why the server side should run with almost no 
cpu usage yet the client does not.

Here is the client/server loop:

>   struct ibv_mr *mr;
>   int ret;
>   int send_buf_num = 0;
>   int recv_buf_num = 0;
>
>   #define NUM_BUFFERS 20
>   #define SIZE 1024*1024
>   uint8_t *buffer = (uint8_t*)malloc(SIZE * NUM_BUFFERS * 2);
>   uint8_t *send_msg[NUM_BUFFERS];
>   uint8_t *recv_msg[NUM_BUFFERS];
>
>   for(int i=0; i<NUM_BUFFERS; i++) {
>     send_msg[i] = buffer + (i*SIZE);
>     recv_msg[i] = buffer + ((i+NUM_BUFFERS) * SIZE);
>   }
>
>   //--------------------------------------------------------------------
>   // setup
>   fprintf(stderr, "rdma_reg_msgs\n");
>   mr = rdma_reg_msgs(cm_id, buffer, SIZE*NUM_BUFFERS*2);
>   if (!mr) {
>     perror("rdma_reg_msgs");
>   }
>
>   //prepare to for the first receive before connecting
>   for(int i=0; i<10; i++) {
>     fprintf(stderr, "rdma_post_recv\n");
>     ret = rdma_post_recv(cm_id, NULL, recv_msg[recv_buf_num++], SIZE, mr);
>     recv_buf_num %= NUM_BUFFERS;
>     if (ret) {
>       perror("rdma_post_recv");
>     }
>   }
>
>   //connect
>   fprintf(stderr, "rdma_connect\n");
>   ret = rdma_connect(cm_id, NULL);
>   if (ret) {
>     perror("rdma_connect");
>   }
>
>   const int NUM_FDS = 4;
>
>   const int POLL_CM = 0;
>   const int POLL_RECV_CQ = 1;
>   const int POLL_SEND_CQ = 2;
>   const int POLL_WAKE = 3;
>   struct pollfd fds[NUM_FDS];
>
>   //prime notification of events on the recv completion queue
>   ibv_req_notify_cq(cm_id->recv_cq, 0);
>   //
>
>   //--------------------------------------------------------------------
>   // main loop
>   while(ret == 0)
>   {
>     memset(fds, 0, sizeof(pollfd) * NUM_FDS);
>     fds[POLL_CM].fd = cm_channel->fd;
>     fds[POLL_CM].events = POLLIN;
>
>     fds[POLL_RECV_CQ].fd = cm_id->recv_cq_channel->fd;
>     fds[POLL_RECV_CQ].events = POLLIN;
>
>     fds[POLL_SEND_CQ].fd = cm_id->send_cq_channel->fd;
>     fds[POLL_SEND_CQ].events = POLLIN;
>
>     fds[POLL_WAKE].fd = wake_fds[0];
>     fds[POLL_WAKE].events = POLLIN;
>
>     int nready = poll(fds, NUM_FDS, -1);
>     if(nready < 0) {
>       perror("poll");
>     }
>
>     if(fds[POLL_CM].revents & POLLIN) {
>       struct rdma_cm_event *cm_event;
>       ret = rdma_get_cm_event(cm_channel, &cm_event);
>       if(ret) {
>         perror("client connection rdma_get_cm_event");
>       }
>       fprintf(stderr, "Got cm event %s\n", rdma_event_str(cm_event->event));
>
>       if(cm_event->event == RDMA_CM_EVENT_ESTABLISHED) {
>         //send as soon as we are connected
>         ibv_req_notify_cq(cm_id->send_cq, 0);
>         ret = rdma_post_send(cm_id, NULL, send_msg[send_buf_num], SIZE, mr, 0);
>         send_buf_num++;
>         send_buf_num %= NUM_BUFFERS;
>         if (ret) {
>           perror("rdma_post_send");
>         }
>       }
>
>       int finish=0;
>       if(cm_event->event == RDMA_CM_EVENT_DISCONNECTED ||
>          cm_event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
>           finish = 1;
>
>       rdma_ack_cm_event(cm_event);
>       if(finish) {
>         goto out;
>       }
>     }
>
>     //if the send completed
>     if(fds[POLL_SEND_CQ].revents & POLLIN) {
>       struct ibv_cq *cq;
>       struct ibv_wc wc[10];
>       void *context;
>       int num_send = ibv_poll_cq(cm_id->send_cq, 10, &wc[0]);
>
>       if(num_send == 0) fprintf(stderr, ".");
>
>       for(int i=0; i<num_send; i++) {
>         fprintf(stderr,"Got SEND CQ event : %d of %d %s\n", i, num_send, ibv_wc_status_str(wc[i].status));
>         ibv_get_cq_event(cm_id->send_cq_channel, &cq, &context);
>         assert(cq == cm_id->send_cq);
>
>         //our send completed, send some more right away
>         fprintf(stderr, "rdma_post_send\n");
>         ret = rdma_post_send(cm_id, NULL, send_msg[send_buf_num++], SIZE, mr, 0);
>         send_buf_num %= NUM_BUFFERS;
>         if (ret) {
>           perror("rdma_post_send");
>         }
>       }
>
>       //expensive call, ack all received events together
>       ibv_ack_cq_events(cm_id->send_cq, num_send);
>       ibv_req_notify_cq(cm_id->send_cq, 0);
>     }
>
>     //if the receive completed, prepare to receive more
>     if(fds[POLL_RECV_CQ].revents & POLLIN) {
>       struct ibv_cq *cq;
>       struct ibv_wc wc[10];
>       void *context;
>       int num_recv=ibv_poll_cq(cm_id->recv_cq, 10, &wc[0]);
>
>       for(int i=0; i<num_recv; i++) {
>         fprintf(stderr,"Got RECV CQ event : %d of %d %s\n", i, num_recv, ibv_wc_status_str(wc[i].status));
>         ibv_get_cq_event(cm_id->recv_cq_channel, &cq, &context);
>         assert(cq == cm_id->recv_cq);
>
>         //we received some payload, prepare to receive more
>         fprintf(stderr, "rdma_post_recv\n");
>         ret = rdma_post_recv(cm_id, NULL, recv_msg[recv_buf_num++], SIZE, mr);
>         recv_buf_num %= NUM_BUFFERS;
>         if (ret) {
>            perror("rdma_post_recv");
>         }
>       }
>
>       //expensive call, ack all received events together
>       ibv_ack_cq_events(cm_id->recv_cq, num_recv);
>       ibv_req_notify_cq(cm_id->recv_cq, 0);
>     }
>
>     if(fds[POLL_WAKE].revents & POLLIN) {
>       fprintf(stderr, "poll WAKE\n");
>       char buffer[1];
>       int nread = read(wake_fds[0], buffer, 1);
>       fprintf(stderr, "Got Wake event %d\n", nread);
>       goto out;
>     }
>
>   }
>
> out:
>   rdma_disconnect(cm_id);
>   rdma_dereg_mr(mr);
>   rdma_destroy_ep(cm_id);
>
>   free(buffer);
>   fprintf(stderr, "poll: client completed\n");



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
