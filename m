From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 23/23] perftest: replace 0/1 with SUCCESS/FAILURE
Date: Thu, 18 Aug 2016 13:32:18 -0400
Message-ID: <1471541538-20270-24-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For consistency's sake, let's use the SUCCESS and FAILURE defines in
returns everywhere we can.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_communication.c | 156 +++++++++++++++++++++----------------------
 src/perftest_parameters.c    |  46 ++++++-------
 src/perftest_resources.c     | 104 ++++++++++++++---------------
 src/raw_ethernet_resources.c |  10 +--
 src/raw_ethernet_send_bw.c   |  26 ++++----
 src/send_bw.c                |  18 ++---
 src/send_lat.c               |  18 ++---
 7 files changed, 189 insertions(+), 189 deletions(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index 6b3b1d9..31ddb53 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -73,7 +73,7 @@ strverscmp (const char *s1, const char *s2)
     };
 
   if (p1 == p2)
-    return 0;
+    return SUCCESS;
 
   c1 = *p1++;
   c2 = *p2++;
@@ -98,7 +98,7 @@ strverscmp (const char *s1, const char *s2)
     case LEN:
       while (isdigit (*p1++))
 	if (!isdigit (*p2++))
-	  return 1;
+	  return FAILURE;
 
       return isdigit (*p2) ? -1 : diff;
 
@@ -234,7 +234,7 @@ static int send_qp_num_for_ah(struct pingpong_context *ctx,
 
 	if (ibv_post_send(ctx->qp[0],&wr,&bad_wr)) {
 		fprintf(stderr, "Function ibv_post_send failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	do {
@@ -243,10 +243,10 @@ static int send_qp_num_for_ah(struct pingpong_context *ctx,
 
 	if (wc.status || wc.opcode != IBV_WC_SEND || wc.wr_id != 0) {
 		fprintf(stderr, " Couldn't post send my QP number %d\n",(int)wc.status);
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 
 }
 
@@ -267,7 +267,7 @@ static int create_ah_from_wc_recv(struct pingpong_context *ctx,
 
 	if (wc.status || !(wc.opcode & IBV_WC_RECV) || wc.wr_id != 0) {
 		fprintf(stderr, "Bad wc status when trying to create AH -- %d -- %d \n",(int)wc.status,(int)wc.wr_id);
-		return 1;
+		return FAILURE;
 	}
 
 	ctx->ah[0] = ibv_create_ah_from_wc(ctx->pd, &wc, (struct ibv_grh*)ctx->buf[0], ctx->cm_id->port_num);
@@ -275,7 +275,7 @@ static int create_ah_from_wc_recv(struct pingpong_context *ctx,
 	ibv_query_qp(ctx->qp[0],&attr, IBV_QP_QKEY,&init_attr);
 	user_param->rem_ud_qkey = attr.qkey;
 
-	return 0;
+	return SUCCESS;
 }
 
 
@@ -295,7 +295,7 @@ static int ethernet_write_keys(struct pingpong_dest *my_dest,
 		if (write(comm->rdma_params->sockfd,msg,sizeof msg) != sizeof msg) {
 			perror("client write");
 			fprintf(stderr, "Couldn't send local address\n");
-			return 1;
+			return FAILURE;
 		}
 
 	} else {
@@ -315,12 +315,12 @@ static int ethernet_write_keys(struct pingpong_dest *my_dest,
 		if (write(comm->rdma_params->sockfd, msg, sizeof msg) != sizeof msg) {
 			perror("client write");
 			fprintf(stderr, "Couldn't send local address\n");
-			return 1;
+			return FAILURE;
 		}
 
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -336,7 +336,7 @@ static int ethernet_read_keys(struct pingpong_dest *rem_dest,
 
 		if (read(comm->rdma_params->sockfd, msg, sizeof msg) != sizeof msg) {
 			fprintf(stderr, "ethernet_read_keys: Couldn't read remote address\n");
-			return 1;
+			return FAILURE;
 		}
 
 		parsed = sscanf(msg,KEY_PRINT_FMT,(unsigned int*)&rem_dest->lid,
@@ -345,7 +345,7 @@ static int ethernet_read_keys(struct pingpong_dest *rem_dest,
 
 		if (parsed != 7) {
 			fprintf(stderr, "Couldn't parse line <%.*s>\n",(int)sizeof msg, msg);
-			return 1;
+			return FAILURE;
 		}
 
 	} else {
@@ -357,7 +357,7 @@ static int ethernet_read_keys(struct pingpong_dest *rem_dest,
 
 		if (read(comm->rdma_params->sockfd, msg, sizeof msg) != sizeof msg) {
 			fprintf(stderr, "ethernet_read_keys: Couldn't read remote address\n");
-			return 1;
+			return FAILURE;
 		}
 
 		term = strpbrk(pstr, ":");
@@ -419,7 +419,7 @@ static int ethernet_read_keys(struct pingpong_dest *rem_dest,
 		rem_dest->srqn = (unsigned)strtoul(tmp, NULL, 16); /*SRQN*/
 
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -469,7 +469,7 @@ static int rdma_write_keys(struct pingpong_dest *my_dest,
 
 	if (ibv_post_send(comm->rdma_ctx->qp[0],&wr,&bad_wr)) {
 		fprintf(stderr, "Function ibv_post_send failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	do {
@@ -478,10 +478,10 @@ static int rdma_write_keys(struct pingpong_dest *my_dest,
 
 	if (wc.status || wc.opcode != IBV_WC_SEND || wc.wr_id != SYNC_SPEC_ID) {
 		fprintf(stderr, " Bad wc status %d\n",(int)wc.status);
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -502,7 +502,7 @@ static int rdma_read_keys(struct pingpong_dest *rem_dest,
 
 	if (wc.status || !(wc.opcode & IBV_WC_RECV) || wc.wr_id != SYNC_SPEC_ID) {
 		fprintf(stderr, "Bad wc status -- %d -- %d \n",(int)wc.status,(int)wc.wr_id);
-		return 1;
+		return FAILURE;
 	}
 
 	#ifdef HAVE_ENDIAN
@@ -521,10 +521,10 @@ static int rdma_read_keys(struct pingpong_dest *rem_dest,
 
 	if (post_one_recv_wqe(comm->rdma_ctx)) {
 		fprintf(stderr, "Couldn't post send \n");
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 
@@ -635,7 +635,7 @@ static int ethernet_client_connect(struct perftest_comm *comm)
 
 	if (check_add_port(&service,comm->rdma_params->port,comm->rdma_params->servername,&hints,&res)) {
 		fprintf(stderr, "Problem in resolving basic address and port\n");
-		return 1;
+		return FAILURE;
 	}
 
 	for (t = res; t; t = t->ai_next) {
@@ -653,11 +653,11 @@ static int ethernet_client_connect(struct perftest_comm *comm)
 
 	if (sockfd < 0) {
 		fprintf(stderr, "Couldn't connect to %s:%d\n",comm->rdma_params->servername,comm->rdma_params->port);
-		return 1;
+		return FAILURE;
 	}
 
 	comm->rdma_params->sockfd = sockfd;
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -678,7 +678,7 @@ static int ethernet_server_connect(struct perftest_comm *comm)
 
 	if (check_add_port(&service,comm->rdma_params->port,NULL,&hints,&res)) {
 		fprintf(stderr, "Problem in resolving basic adress and port\n");
-		return 1;
+		return FAILURE;
 	}
 
 	for (t = res; t; t = t->ai_next) {
@@ -689,7 +689,7 @@ static int ethernet_server_connect(struct perftest_comm *comm)
 			if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &n, sizeof n)) {
 				freeaddrinfo(res);
 				close(sockfd);
-				return 1;
+				return FAILURE;
 			}
 			if (!bind(sockfd, t->ai_addr, t->ai_addrlen))
 				break;
@@ -701,7 +701,7 @@ static int ethernet_server_connect(struct perftest_comm *comm)
 
 	if (sockfd < 0) {
 		fprintf(stderr, "Couldn't listen to port %d\n", comm->rdma_params->port);
-		return 1;
+		return FAILURE;
 	}
 
 	listen(sockfd, 1);
@@ -711,11 +711,11 @@ static int ethernet_server_connect(struct perftest_comm *comm)
 		perror("server accept");
 		fprintf(stderr, "accept() failed\n");
 		close(sockfd);
-		return 1;
+		return FAILURE;
 	}
 	close(sockfd);
 	comm->rdma_params->sockfd = connfd;
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -745,7 +745,7 @@ int set_up_connection(struct pingpong_context *ctx,
 
 	if (user_param->gid_index != -1) {
 		if (ibv_query_port(ctx->context, user_param->ib_port, &attr))
-			return 0;
+			return SUCCESS;
 
 		if (user_param->use_gid_user) {
 			if (ibv_query_gid(ctx->context, user_param->ib_port, user_param->gid_index, &temp_gid))
@@ -762,7 +762,7 @@ int set_up_connection(struct pingpong_context *ctx,
 	if (user_param->dualport == ON) {
 		if (user_param->gid_index2 != -1) {
 			if (ibv_query_port(ctx->context, user_param->ib_port2, &attr))
-				return 0;
+				return SUCCESS;
 
 			if (user_param->use_gid_user) {
 				if (ibv_query_gid(ctx->context, user_param->ib_port2, user_param->gid_index2, &temp_gid2))
@@ -836,7 +836,7 @@ int set_up_connection(struct pingpong_context *ctx,
 		for (i=0; i < user_param->num_of_qps; i++) {
 			if (ibv_get_srq_num(ctx->srq,&(my_dest[i].srqn))) {
 				fprintf(stderr, "Couldn't get SRQ number\n");
-				return 1;
+				return FAILURE;
 			}
 		}
 	}
@@ -848,13 +848,13 @@ int set_up_connection(struct pingpong_context *ctx,
 			for (i=0; i < user_param->num_of_qps; i++) {
 				if (ibv_get_srq_num(ctx->srq, &(my_dest[i].srqn))) {
 					fprintf(stderr, "Couldn't get SRQ number\n");
-					return 1;
+					return FAILURE;
 				}
 			}
 		}
 	}
 	#endif
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -984,7 +984,7 @@ int rdma_client_connect(struct pingpong_context *ctx,struct perftest_parameters
 
 		if (post_one_recv_wqe(ctx)) {
 			fprintf(stderr, "Couldn't post send \n");
-			return 1;
+			return FAILURE;
 		}
 	}
 
@@ -1089,22 +1089,22 @@ int rdma_server_connect(struct pingpong_context *ctx,
 
 	if (rdma_bind_addr(ctx->cm_id_control,(struct sockaddr *)&sin)) {
 		fprintf(stderr," rdma_bind_addr failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (rdma_listen(ctx->cm_id_control,0)) {
 		fprintf(stderr, "rdma_listen failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (rdma_get_cm_event(ctx->cm_channel,&event)) {
 		fprintf(stderr, "rdma_get_cm_events failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (event->event != RDMA_CM_EVENT_CONNECT_REQUEST) {
 		fprintf(stderr, "bad event waiting for connect request %d\n",event->event);
-		return 1;
+		return FAILURE;
 	}
 
 	ctx->cm_id = (struct rdma_cm_id*)event->id;
@@ -1137,7 +1137,7 @@ int rdma_server_connect(struct pingpong_context *ctx,
 
 		if (post_one_recv_wqe(ctx)) {
 			fprintf(stderr, "Couldn't post send \n");
-			return 1;
+			return FAILURE;
 		}
 
 	} else if (user_param->connection_type == UD) {
@@ -1146,14 +1146,14 @@ int rdma_server_connect(struct pingpong_context *ctx,
 
 			if (post_recv_to_get_ah(ctx)) {
 				fprintf(stderr, "Couldn't post send \n");
-				return 1;
+				return FAILURE;
 			}
 		}
 	}
 
 	if (rdma_accept(ctx->cm_id, &conn_param)) {
 		fprintf(stderr, "Function rdma_accept failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param->work_rdma_cm && user_param->connection_type == UD) {
@@ -1161,14 +1161,14 @@ int rdma_server_connect(struct pingpong_context *ctx,
 		if (user_param->tst == LAT || (user_param->tst == BW && user_param->duplex)) {
 			if (create_ah_from_wc_recv(ctx,user_param)) {
 				fprintf(stderr, "Unable to create AH from WC\n");
-				return 1;
+				return FAILURE;
 			}
 		}
 	}
 
 	rdma_ack_cm_event(event);
 	rdma_destroy_id(ctx->cm_id_control);
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1238,12 +1238,12 @@ int establish_connection(struct perftest_comm *comm)
 		if (comm->rdma_params->machine == CLIENT) {
 			if (rdma_client_connect(comm->rdma_ctx,comm->rdma_params)) {
 				fprintf(stderr," Unable to perform rdma_client function\n");
-				return 1;
+				return FAILURE;
 			}
 		} else {
 			if (rdma_server_connect(comm->rdma_ctx,comm->rdma_params)) {
 				fprintf(stderr," Unable to perform rdma_server function\n");
-				return 1;
+				return FAILURE;
 			}
 		}
 	} else {
@@ -1251,10 +1251,10 @@ int establish_connection(struct perftest_comm *comm)
 
 		if ((*ptr)(comm)) {
 			fprintf(stderr,"Unable to open file descriptor for socket connection");
-			return 1;
+			return FAILURE;
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1281,11 +1281,11 @@ int ctx_hand_shake(struct perftest_comm *comm,
 	if (comm->rdma_params->servername) {
 		if ((*write_func_ptr)(my_dest,comm)) {
 			fprintf(stderr," Unable to write to socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 		if ((*read_func_ptr)(rem_dest,comm)) {
 			fprintf(stderr," Unable to read from socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		/*Server side will wait for the client side to reach the write function.*/
@@ -1293,15 +1293,15 @@ int ctx_hand_shake(struct perftest_comm *comm,
 
 		if ((*read_func_ptr)(rem_dest,comm)) {
 			fprintf(stderr," Unable to read to socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 		if ((*write_func_ptr)(my_dest,comm)) {
 			fprintf(stderr," Unable to write from socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 
@@ -1318,12 +1318,12 @@ int ctx_xchg_data_ethernet( struct perftest_comm *comm,
 	if (comm->rdma_params->servername) {
 		if (ethernet_write_data(comm, (char *) my_data, size)) {
 			fprintf(stderr," Unable to write to socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		if (ethernet_read_data(comm, (char *) rem_data, size)) {
 			fprintf(stderr," Unable to read from socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		/*Server side will wait for the client side to reach the write function.*/
@@ -1331,15 +1331,15 @@ int ctx_xchg_data_ethernet( struct perftest_comm *comm,
 
 		if (ethernet_read_data(comm, (char *) rem_data, size)) {
 			fprintf(stderr," Unable to read to socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		if (ethernet_write_data(comm, (char *) my_data, size)) {
 			fprintf(stderr," Unable to write from socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1352,12 +1352,12 @@ int ctx_xchg_data_rdma( struct perftest_comm *comm,
 	if (comm->rdma_params->servername) {
 		if (rdma_write_data(my_data,comm,size)) {
 			fprintf(stderr," Unable to write to socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		if (rdma_read_data(rem_data,comm,size)) {
 			fprintf(stderr," Unable to read from socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		/*Server side will wait for the client side to reach the write function.*/
@@ -1365,15 +1365,15 @@ int ctx_xchg_data_rdma( struct perftest_comm *comm,
 
 		if (rdma_read_data(rem_data,comm,size)) {
 			fprintf(stderr," Unable to read to socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 
 		if (rdma_write_data(my_data,comm,size)) {
 			fprintf(stderr," Unable to write from socket/rdam_cm\n");
-			return 1;
+			return FAILURE;
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 
@@ -1392,17 +1392,17 @@ int rdma_read_data(void *data,
 
 	if (wc.status || !(wc.opcode & IBV_WC_RECV) || wc.wr_id != SYNC_SPEC_ID) {
 		fprintf(stderr, "Bad wc status -- %d -- %d \n",(int)wc.status,(int)wc.wr_id);
-		return 1;
+		return FAILURE;
 	}
 
 	memcpy(data,comm->rdma_ctx->buf[0], size);
 
 	if (post_one_recv_wqe(comm->rdma_ctx)) {
 		fprintf(stderr, "Couldn't post send \n");
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1431,7 +1431,7 @@ int rdma_write_data(void *data,
 
 	if (ibv_post_send(comm->rdma_ctx->qp[0],&wr,&bad_wr)) {
 		fprintf(stderr, "Function ibv_post_send failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	do {
@@ -1440,10 +1440,10 @@ int rdma_write_data(void *data,
 
 	if (wc.status || wc.opcode != IBV_WC_SEND || wc.wr_id != SYNC_SPEC_ID) {
 		fprintf(stderr, " Bad wc status %d\n",(int)wc.status);
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1454,10 +1454,10 @@ int ethernet_write_data(struct perftest_comm *comm, char *msg, size_t size)
 	if (write(comm->rdma_params->sockfd, msg, size) != size) {
 		perror("client write");
 		fprintf(stderr, "Couldn't send reports\n");
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 
 }
 /******************************************************************************
@@ -1467,10 +1467,10 @@ int ethernet_read_data(struct perftest_comm *comm, char *recv_msg, size_t size)
 {
 	if (read(comm->rdma_params->sockfd, recv_msg, size) != size) {
 		fprintf(stderr, "ethernet_read_data: Couldn't read reports\n");
-		return 1;
+		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 
@@ -1486,7 +1486,7 @@ int ctx_xchg_data( struct perftest_comm *comm,
 	else
 		ctx_xchg_data_ethernet(comm,my_data,rem_data,size);
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1633,7 +1633,7 @@ int ctx_close_connection(struct perftest_comm *comm,
 {
 	/*Signal client is finished.*/
 	if (ctx_hand_shake(comm,my_dest,rem_dest)) {
-		return 1;
+		return FAILURE;
 	}
 
 	if (!comm->rdma_params->use_rdma_cm && !comm->rdma_params->work_rdma_cm) {
@@ -1645,10 +1645,10 @@ int ctx_close_connection(struct perftest_comm *comm,
 		}
 
 		close(comm->rdma_params->sockfd);
-		return 0;
+		return SUCCESS;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1775,9 +1775,9 @@ int ctx_check_gid_compatibility(struct pingpong_dest *my_dest,
 	gid_type2 = ipv6_addr_v4mapped((struct in6_addr *)rem_dest->gid.raw);
 
 	if (gid_type1 != gid_type2)
-		return 1;
+		return FAILURE;
 
-	return 0;
+	return SUCCESS;
 }
 /******************************************************************************
  * End
diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index b18588f..3ffddd7 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -720,7 +720,7 @@ int set_eth_mtu(struct perftest_parameters *user_param)
 		return -1;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1625,7 +1625,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 			case 'S': user_param->sl = (uint8_t)strtol(optarg, NULL, 0);
 				  if (user_param->sl > MAX_SL) {
 					  fprintf(stderr," Only %d Service levels\n",MAX_SL);
-					  return 1;
+					  return FAILURE;
 				  }
 				  if (user_param->connection_type == RawEth)
 					  user_param->raw_qos = 1;
@@ -1636,32 +1636,32 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 			case 'q':
 				  if (user_param->tst != BW) {
 					  fprintf(stderr," Multiple QPs only available on bw tests\n");
-					  return 1;
+					  return FAILURE;
 				  }
 				  CHECK_VALUE(user_param->num_of_qps,int,MIN_QP_NUM,MAX_QP_NUM,"num of Qps");
 				  break;
 			case 'I': CHECK_VALUE(user_param->inline_size,int,0,MAX_INLINE,"Max inline");
 				  if (user_param->verb == READ || user_param->verb ==ATOMIC) {
 					  fprintf(stderr," Inline feature not available on READ/Atomic verbs\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'o': user_param->out_reads = strtol(optarg, NULL, 0);
 				  if (user_param->verb != READ && user_param->verb != ATOMIC) {
 					  fprintf(stderr," Setting Outstanding reads only available on READ verb\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'M': GET_STRING(user_param->user_mgid,strdupa(optarg)); break;
 			case 'r': CHECK_VALUE(user_param->rx_depth,int,MIN_RX,MAX_RX," Rx depth");
 				  if (user_param->verb != SEND && user_param->rx_depth > DEF_RX_RDMA) {
 					  fprintf(stderr," On RDMA verbs rx depth can be only 1\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'Q': CHECK_VALUE(user_param->cq_mod,int,MIN_CQ_MOD,MAX_CQ_MOD,"CQ moderation"); break;
 			case 'A':
 				  if (user_param->verb != ATOMIC) {
 					  fprintf(stderr," You are not running the atomic_lat/bw test!\n");
 					  fprintf(stderr," To change the atomic action type, you must run one of the atomic tests\n");
-					  return 1;
+					  return FAILURE;
 				  }
 
 				  if (strcmp(atomicTypesStr[0],optarg)==0)
@@ -1679,14 +1679,14 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 			case 'D': user_param->duration = strtol(optarg, NULL, 0);
 				  if (user_param->duration <= 0) {
 					  fprintf(stderr," Duration period must be greater than 0\n");
-					  return 1;
+					  return FAILURE;
 				  }
 				  user_param->test_type = DURATION;
 				  break;
 			case 'f': user_param->margin = strtol(optarg, NULL, 0);
 				  if (user_param->margin < 0) {
 					  fprintf(stderr," margin must be positive.\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'O':
 				  user_param->ib_port  = DEF_IB_PORT;
@@ -1715,47 +1715,47 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 				  user_param->size = (uint64_t)strtol(optarg, NULL, 0) * size_factor;
 				  if (user_param->size < 1 || user_param->size > (UINT_MAX / 2)) {
 					  fprintf(stderr," Message Size should be between %d and %d\n",1,UINT_MAX/2);
-					  return 1;
+					  return FAILURE;
 				  }
 				  break;
 			case 'e': user_param->use_event = ON;
 				  if (user_param->verb == WRITE) {
 					  fprintf(stderr," Events feature not available on WRITE verb\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'b': user_param->duplex = ON;
 				  if (user_param->tst == LAT) {
 					  fprintf(stderr," Bidirectional is only available in BW test\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'N': user_param->noPeak = ON;
 				  if (user_param->tst == LAT) {
 					  fprintf(stderr," NoPeak only valid for BW tests\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'C':
 				  if (user_param->tst != LAT) {
 					  fprintf(stderr," Availible only on Latency tests\n");
-					  return 1;
+					  return FAILURE;
 				  }
 				  user_param->r_flag->cycles = ON;
 				  break;
 			case 'g': user_param->use_mcg = ON;
 				  if (user_param->verb != SEND) {
 					  fprintf(stderr," MultiCast feature only available on SEND verb\n");
-					  return 1;
+					  return FAILURE;
 				  } break;
 			case 'H':
 				  if (user_param->tst != LAT) {
 					  fprintf(stderr," Availible only on Latency tests\n");
-					  return 1;
+					  return FAILURE;
 				  }
 				  user_param->r_flag->histogram = ON;
 				  break;
 			case 'U':
 				  if (user_param->tst != LAT) {
 					  fprintf(stderr," Availible only on Latency tests\n");
-					  return 1;
+					  return FAILURE;
 				  }
 				  user_param->r_flag->unsorted = ON;
 				  break;
@@ -1958,7 +1958,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 				  if(user_param->connection_type == RawEth) {
 					  usage_raw_ethernet(user_param->tst);
 				  }
-				  return 1;
+				  return FAILURE;
 		}
 	}
 
@@ -2037,7 +2037,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 
 	} else if (optind < argc) {
 		fprintf(stderr," Invalid Command line. Please check command rerun \n");
-		return 1;
+		return FAILURE;
 	}
 
 	if(user_param->connection_type != RawEth)
@@ -2052,7 +2052,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc)
 	}
 
 	force_dependecies(user_param);
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -2316,7 +2316,7 @@ static float calc_cpu_util (struct perftest_parameters *user_param)
 	if ((ustat_diff + idle_diff) != 0)
 		return ((float)ustat_diff / (ustat_diff + idle_diff)) * 100;
 	else
-		return 0;
+		return SUCCESS;
 }
 
 /******************************************************************************
@@ -2480,9 +2480,9 @@ static int cycles_compare(const void *aptr, const void *bptr)
 	const cycles_t *a = aptr;
 	const cycles_t *b = bptr;
 	if (*a < *b) return -1;
-	if (*a > *b) return 1;
+	if (*a > *b) return FAILURE;
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 959a5df..a557d0e 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -73,7 +73,7 @@ static int pp_init_gpu(struct pingpong_context *ctx, size_t _size)
 	/* This function call returns 0 if there are no CUDA capable devices. */
 	if (deviceCount == 0) {
 		printf("There are no available device(s) that support CUDA\n");
-		return 1;
+		return FAILURE;
 	} else if (deviceCount == 1)
 		printf("There is 1 device supporting CUDA\n");
 	else
@@ -93,14 +93,14 @@ static int pp_init_gpu(struct pingpong_context *ctx, size_t _size)
 	error = cuCtxCreate(&cuContext, CU_CTX_MAP_HOST, cuDevice);
 	if (error != CUDA_SUCCESS) {
 		printf("cuCtxCreate() error=%d\n", error);
-		return 1;
+		return FAILURE;
 	}
 
 	printf("making it the current CUDA Ctx\n");
 	error = cuCtxSetCurrent(cuContext);
 	if (error != CUDA_SUCCESS) {
 		printf("cuCtxSetCurrent() error=%d\n", error);
-		return 1;
+		return FAILURE;
 	}
 
 	printf("cuMemAlloc() of a %zd bytes GPU buffer\n", size);
@@ -108,13 +108,13 @@ static int pp_init_gpu(struct pingpong_context *ctx, size_t _size)
 	error = cuMemAlloc(&d_A, size);
 	if (error != CUDA_SUCCESS) {
 		printf("cuMemAlloc error=%d\n", error);
-		return 1;
+		return FAILURE;
 	}
 	printf("allocated GPU buffer address at %016llx pointer=%p\n", d_A,
 	       (void *) d_A);
 	ctx->buf[0] = (void*)d_A;
 
-	return 0;
+	return SUCCESS;
 }
 
 static int pp_free_gpu(struct pingpong_context *ctx)
@@ -139,7 +139,7 @@ static int pp_init_mmap(struct pingpong_context *ctx, size_t size,
 	int fd = open(fname, O_RDWR);
 	if (fd < 0) {
 		printf("Unable to open '%s': %s\n", fname, strerror(errno));
-		return 1;
+		return FAILURE;
 	}
 
 	ctx->buf[0] = mmap(NULL, size, PROT_WRITE | PROT_READ, MAP_SHARED, fd,
@@ -148,18 +148,18 @@ static int pp_init_mmap(struct pingpong_context *ctx, size_t size,
 
 	if (ctx->buf[0] == MAP_FAILED) {
 		printf("Unable to mmap '%s': %s\n", fname, strerror(errno));
-		return 1;
+		return FAILURE;
 	}
 
 	printf("allocated mmap buffer of size %zd at %p\n", size, ctx->buf[0]);
 
-	return 0;
+	return SUCCESS;
 }
 
 static int pp_free_mmap(struct pingpong_context *ctx)
 {
 	munmap(ctx->buf[0], ctx->buff_size);
-	return 0;
+	return SUCCESS;
 }
 
 #ifdef HAVE_VERBS_EXP
@@ -302,7 +302,7 @@ static int ctx_xrcd_create(struct pingpong_context *ctx,struct perftest_paramete
 		fprintf(stderr,"Error opening XRC domain\n");
 		return FAILURE;
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -333,7 +333,7 @@ static int ctx_xrc_srq_create(struct pingpong_context *ctx,
 		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -492,7 +492,7 @@ static int ctx_dc_tgt_create(struct pingpong_context *ctx,struct perftest_parame
 		return FAILURE;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 #endif
 
@@ -958,19 +958,19 @@ static int check_odp_support(struct pingpong_context *ctx)
 	int ret = ibv_exp_query_device(ctx->context, &dattr);
 	if (ret) {
 		fprintf(stderr, " Couldn't query device for on-demand paging capabilities.\n");
-		return 0;
+		return SUCCESS;
 	} else if (!(dattr.comp_mask & IBV_EXP_DEVICE_ATTR_ODP)) {
 		fprintf(stderr, " On-demand paging not supported by driver.\n");
-		return 0;
+		return SUCCESS;
 	} else if (!(dattr.odp_caps.per_transport_caps.rc_odp_caps & IBV_EXP_ODP_SUPPORT_SEND)) {
 		fprintf(stderr, " Send is not supported for RC transport.\n");
-		return 0;
+		return SUCCESS;
 	} else if (!(dattr.odp_caps.per_transport_caps.rc_odp_caps & IBV_EXP_ODP_SUPPORT_RECV)) {
 		fprintf(stderr, " Receive is not supported for RC transport.\n");
-		return 0;
+		return SUCCESS;
 	}
 
-	return 1;
+	return FAILURE;
 }
 #endif
 
@@ -1149,7 +1149,7 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
 	#ifdef HAVE_ODP
 	if (user_param->use_odp) {
 		if ( !check_odp_support(ctx) )
-			return 1;
+			return FAILURE;
 
 		/* ODP does not support contig pages */
 		ctx->is_contig_supported = FAILURE;
@@ -1162,7 +1162,7 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
 		ctx->is_contig_supported = FAILURE;
 		if(pp_init_gpu(ctx, ctx->buff_size)) {
 			fprintf(stderr, "Couldn't allocate work buf.\n");
-			return 1;
+			return FAILURE;
 		}
 	} else
 	#endif
@@ -1177,7 +1177,7 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
 				 user_param->mmap_offset))
 		{
 			fprintf(stderr, "Couldn't allocate work buf.\n");
-			return 1;
+			return FAILURE;
 		}
 
 	} else {
@@ -1190,7 +1190,7 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
 			#endif
 			if (!ctx->buf[qp_index]) {
 				fprintf(stderr, "Couldn't allocate work buf.\n");
-				return 1;
+				return FAILURE;
 			}
 
 			memset(ctx->buf[qp_index], 0, ctx->buff_size);
@@ -1245,7 +1245,7 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
 
 	if (!ctx->mr[qp_index]) {
 		fprintf(stderr, "Couldn't allocate MR\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (ctx->is_contig_supported == SUCCESS)
@@ -1258,7 +1258,7 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
 		((char*)ctx->buf[qp_index])[i] = (char)rand();
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1271,7 +1271,7 @@ int create_mr(struct pingpong_context *ctx, struct perftest_parameters *user_par
 	/* create first MR */
 	if (create_single_mr(ctx, user_param, 0)) {
 		fprintf(stderr, "failed to create mr\n");
-		return 1;
+		return FAILURE;
 	}
 
 	/* create the rest if needed, or copy the first one */
@@ -1279,7 +1279,7 @@ int create_mr(struct pingpong_context *ctx, struct perftest_parameters *user_par
 		if (user_param->mr_per_qp) {
 			if (create_single_mr(ctx, user_param, i)) {
 				fprintf(stderr, "failed to create mr\n");
-				return 1;
+				return FAILURE;
 			}
 		} else {
 			ALLOCATE(ctx->mr[i], struct ibv_mr, 1);
@@ -1289,7 +1289,7 @@ int create_mr(struct pingpong_context *ctx, struct perftest_parameters *user_par
 		}
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -1582,7 +1582,7 @@ static int check_scatter_fcs_support(struct pingpong_context *ctx,
 	dev_attr.exp_device_cap_flags = IBV_EXP_DEVICE_SCATTER_FCS;
 	if (ibv_exp_query_device(ctx->context, &dev_attr)) {
 		fprintf(stderr, "ibv_exp_query_device failed\n");
-		return 1;
+		return FAILURE;
 	}
 
 	return MASK_IS_SET(IBV_EXP_DEVICE_SCATTER_FCS, dev_attr.exp_device_cap_flags);
@@ -1861,9 +1861,9 @@ int ctx_modify_dc_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_
 
 	if (err) {
 		fprintf(stderr, "Failed to modify QP to INIT (%s)\n", strerror(err));
-		return 1;
+		return FAILURE;
 	}
-	return 0;
+	return SUCCESS;
 }
 #endif
 
@@ -1959,9 +1959,9 @@ int ctx_modify_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_par
 
 	if (ret) {
 		fprintf(stderr, "Failed to modify QP to INIT, (%s)\n",strerror(ret));
-		return 1;
+		return FAILURE;
 	}
-	return 0;
+	return SUCCESS;
 }
 
 #ifdef HAVE_DC
@@ -2670,14 +2670,14 @@ int ctx_set_recv_wqes(struct pingpong_context *ctx,struct perftest_parameters *u
 
 				if (ibv_post_srq_recv(ctx->srq,&ctx->rwr[i], &bad_wr_recv)) {
 					fprintf(stderr, "Couldn't post recv SRQ = %d: counter=%d\n",i,j);
-					return 1;
+					return FAILURE;
 				}
 
 			} else {
 
 				if (ibv_post_recv(ctx->qp[i],&ctx->rwr[i],&bad_wr_recv)) {
 					fprintf(stderr, "Couldn't post recv Qp = %d: counter=%d\n",i,j);
-					return 1;
+					return FAILURE;
 				}
 			}
 
@@ -2691,7 +2691,7 @@ int ctx_set_recv_wqes(struct pingpong_context *ctx,struct perftest_parameters *u
 			}
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 int ctx_alloc_credit(struct pingpong_context *ctx,
@@ -2717,7 +2717,7 @@ int ctx_alloc_credit(struct pingpong_context *ctx,
 		my_dest[i].rkey  = ctx->credit_mr->rkey;
 		my_dest[i].vaddr = (uintptr_t)ctx->credit_buf + i*sizeof(uint32_t);
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /* Should be called after the remote keys have been exchanged */
@@ -2746,7 +2746,7 @@ int ctx_set_credit_wqes(struct pingpong_context *ctx,
 		ctx->ctrl_wr[i].wr.rdma.remote_addr = rem_dest[i].vaddr;
 		ctx->ctrl_wr[i].wr.rdma.rkey = rem_dest[i].rkey;
 	}
-	return 0;
+	return SUCCESS;
 }
 
 static int clean_scq_credit(int send_cnt,struct pingpong_context *ctx,struct perftest_parameters *user_param)
@@ -2755,7 +2755,7 @@ static int clean_scq_credit(int send_cnt,struct pingpong_context *ctx,struct per
 	struct ibv_wc 	*swc = NULL;
 	int		return_value = 0;
 	if (!send_cnt)
-		return 0;
+		return SUCCESS;
 
 	ALLOCATE(swc,struct ibv_wc,user_param->tx_depth);
 	do {
@@ -4024,7 +4024,7 @@ int run_iter_lat_write(struct pingpong_context *ctx,struct perftest_parameters *
 			#endif
 			if (err) {
 				fprintf(stderr,"%s: Couldn't post send: scnt=%lu, err=%s\n",__func__,scnt,strerror(err));
-				return 1;
+				return FAILURE;
 			}
 		}
 
@@ -4039,7 +4039,7 @@ int run_iter_lat_write(struct pingpong_context *ctx,struct perftest_parameters *
 
 				if (wc.status != IBV_WC_SUCCESS) {
 					NOTIFY_COMP_ERROR_SEND(wc,scnt,ccnt);
-					return 1;
+					return FAILURE;
 				}
 
 				ccnt++;
@@ -4052,7 +4052,7 @@ int run_iter_lat_write(struct pingpong_context *ctx,struct perftest_parameters *
 			}
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -4118,7 +4118,7 @@ int run_iter_lat(struct pingpong_context *ctx,struct perftest_parameters *user_p
 		#endif
 		if (err) {
 			fprintf(stderr,"%s: Couldn't post send: scnt=%lu, err=%s\n",__func__,scnt,strerror(err));
-			return 1;
+			return FAILURE;
 		}
 
 		if (user_param->test_type == DURATION && user_param->state == END_STATE)
@@ -4127,7 +4127,7 @@ int run_iter_lat(struct pingpong_context *ctx,struct perftest_parameters *user_p
 		if (user_param->use_event) {
 			if (ctx_notify_events(ctx->channel)) {
 				fprintf(stderr, "Couldn't request CQ notification\n");
-				return 1;
+				return FAILURE;
 			}
 		}
 
@@ -4137,7 +4137,7 @@ int run_iter_lat(struct pingpong_context *ctx,struct perftest_parameters *user_p
 			if(ne > 0) {
 				if (wc.status != IBV_WC_SUCCESS) {
 					NOTIFY_COMP_ERROR_SEND(wc,scnt,scnt);
-					return 1;
+					return FAILURE;
 				}
 				if (user_param->test_type==DURATION && user_param->state == SAMPLE_STATE)
 					user_param->iters++;
@@ -4150,7 +4150,7 @@ int run_iter_lat(struct pingpong_context *ctx,struct perftest_parameters *user_p
 		} while (!user_param->use_event && ne == 0);
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -4216,7 +4216,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 			if (user_param->use_event) {
 				if (ctx_notify_events(ctx->channel)) {
 					fprintf(stderr , " Failed to notify events to CQ");
-					return 1;
+					return FAILURE;
 				}
 			}
 
@@ -4235,7 +4235,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 
 					if (wc.status != IBV_WC_SUCCESS) {
 						NOTIFY_COMP_ERROR_RECV(wc,rcnt);
-						return 1;
+						return FAILURE;
 					}
 
 					rcnt++;
@@ -4252,7 +4252,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 
 							if (ibv_post_srq_recv(ctx->srq,&ctx->rwr[wc.wr_id],&bad_wr_recv)) {
 								fprintf(stderr, "Couldn't post recv SRQ. QP = %d: counter=%lu\n",(int)wc.wr_id,rcnt);
-								return 1;
+								return FAILURE;
 							}
 
 						} else {
@@ -4273,7 +4273,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 					}
 				} else if (ne < 0) {
 					fprintf(stderr, "poll CQ failed %d\n", ne);
-					return 1;
+					return FAILURE;
 				}
 			} while (!user_param->use_event && ne == 0);
 		}
@@ -4318,7 +4318,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 			#endif
 			if (err) {
 				fprintf(stderr,"%s: Couldn't post send: scnt=%lu, err=%s \n",__func__,scnt,strerror(err));
-				return 1;
+				return FAILURE;
 			}
 
 			if (user_param->flows != DEF_FLOWS) {
@@ -4356,7 +4356,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 
 				if (s_wc.status != IBV_WC_SUCCESS) {
 					NOTIFY_COMP_ERROR_SEND(s_wc,scnt,scnt)
-						return 1;
+						return FAILURE;
 				}
 				poll = 0;
 
@@ -4370,7 +4370,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 		}
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -4381,7 +4381,7 @@ uint16_t ctx_get_local_lid(struct ibv_context *context,int port)
 	struct ibv_port_attr attr;
 
 	if (ibv_query_port(context,port,&attr))
-		return 0;
+		return SUCCESS;
 
 	return attr.lid;
 }
diff --git a/src/raw_ethernet_resources.c b/src/raw_ethernet_resources.c
index 22e1bab..dfed47d 100755
--- a/src/raw_ethernet_resources.c
+++ b/src/raw_ethernet_resources.c
@@ -64,14 +64,14 @@ int check_flow_steering_support(char *dev_name)
 	int is_flow_steering_supported = 0;
 
 	if (strstr(dev_name, "mlx5") != NULL)
-		return 0;
+		return SUCCESS;
 
 	fp = fopen(file_name, "r");
 	if (fp == NULL)
-		return 0;
+		return SUCCESS;
 	if (fgets(line,4,fp) == NULL) {
 		fclose(fp);
-		return 0;
+		return SUCCESS;
 	}
 
 	int val = atoi(line);
@@ -634,7 +634,7 @@ static int set_up_flow_rules(
 		spec_info->eth.mask.ether_type = 0xffff;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -695,7 +695,7 @@ int send_set_up_connection(
 			rem_dest_info->port = user_param->client_port;
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
diff --git a/src/raw_ethernet_send_bw.c b/src/raw_ethernet_send_bw.c
index 89b8ba0..8d8dacb 100755
--- a/src/raw_ethernet_send_bw.c
+++ b/src/raw_ethernet_send_bw.c
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 			fprintf(stderr," Parser function exited with Error\n");
 		}
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.raw_mcast) {
@@ -130,12 +130,12 @@ int main(int argc, char *argv[])
 	if (!ib_dev) {
 		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		return FAILURE;
 	}
 	GET_STRING(user_param.ib_devname, ibv_get_device_name(ib_dev));
 
 	if (check_flow_steering_support(user_param.ib_devname)) {
-		return 1;
+		return FAILURE;
 	}
 
 	/* Getting the relevant context from the device */
@@ -143,7 +143,7 @@ int main(int argc, char *argv[])
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		return FAILURE;
 	}
 
 	/* See if MTU and link type are valid and supported. */
@@ -159,7 +159,7 @@ int main(int argc, char *argv[])
 	/* set mac address by user choose */
 	if (send_set_up_connection(&flow_rules,&ctx,&user_param,&my_dest_info,&rem_dest_info)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return 1;
+		return FAILURE;
 	}
 
 	/* Print basic test information. */
@@ -207,7 +207,7 @@ int main(int argc, char *argv[])
 		if (ctx_connect(&ctx,NULL,&user_param,NULL)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
 			DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-			return 1;
+			return FAILURE;
 		}
 	}
 
@@ -277,7 +277,7 @@ int main(int argc, char *argv[])
 			if (ctx_set_recv_wqes(&ctx,&user_param)) {
 				fprintf(stderr," Failed to post receive recv_wqes\n");
 				DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-				return 1;
+				return FAILURE;
 			}
 		}
 
@@ -320,7 +320,7 @@ int main(int argc, char *argv[])
 
 			if (ctx_set_recv_wqes(&ctx,&user_param)) {
 				fprintf(stderr," Failed to post receive recv_wqes\n");
-				return 1;
+				return FAILURE;
 			}
 		}
 
@@ -328,14 +328,14 @@ int main(int argc, char *argv[])
 
 			if(run_iter_bw_infinitely(&ctx,&user_param)) {
 				fprintf(stderr," Error occured while running infinitely! aborting ...\n");
-				return 1;
+				return FAILURE;
 			}
 
 		} else if (user_param.machine == SERVER) {
 
 			if(run_iter_bw_infinitely_server(&ctx,&user_param)) {
 				fprintf(stderr," Error occured while running infinitely on server! aborting ...\n");
-				return 1;
+				return FAILURE;
 			}
 		}
 	}
@@ -374,18 +374,18 @@ int main(int argc, char *argv[])
 	if (destroy_ctx(&ctx, &user_param)) {
 		fprintf(stderr,"Failed to destroy_ctx\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		return FAILURE;
 	}
 
 	/* limit verifier */
 	if (!user_param.is_bw_limit_passed && (user_param.is_limit_bw == ON ) ) {
 		fprintf(stderr,"Error: BW result is below bw limit\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.output == FULL_VERBOSITY)
 		printf(RESULT_LINE);
 
 	DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-	return 0;
+	return SUCCESS;
 }
diff --git a/src/send_bw.c b/src/send_bw.c
index 45cbb67..e7caa18 100755
--- a/src/send_bw.c
+++ b/src/send_bw.c
@@ -53,15 +53,15 @@ static int set_mcast_group(struct pingpong_context *ctx,
 	struct ibv_port_attr port_attr;
 
 	if (ibv_query_gid(ctx->context,user_param->ib_port,user_param->gid_index,&mcg_params->port_gid)) {
-		return 1;
+		return FAILURE;
 	}
 
 	if (ibv_query_pkey(ctx->context,user_param->ib_port,DEF_PKEY_IDX,&mcg_params->pkey)) {
-		return 1;
+		return FAILURE;
 	}
 
 	if (ibv_query_port(ctx->context,user_param->ib_port,&port_attr)) {
-		return 1;
+		return FAILURE;
 	}
 	mcg_params->sm_lid  = port_attr.sm_lid;
 	mcg_params->sm_sl   = port_attr.sm_sl;
@@ -71,10 +71,10 @@ static int set_mcast_group(struct pingpong_context *ctx,
 		/* Request for Mcast group create registery in SM. */
 		if (join_multicast_group(SUBN_ADM_METHOD_SET,mcg_params)) {
 			fprintf(stderr,"Couldn't Register the Mcast group on the SM\n");
-			return 1;
+			return FAILURE;
 		}
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -98,13 +98,13 @@ static int send_set_up_connection(struct pingpong_context *ctx,
 		mcg_params->user_mgid = user_param->user_mgid;
 		set_multicast_gid(mcg_params,ctx->qp[0]->qp_num,(int)user_param->machine);
 		if (set_mcast_group(ctx,user_param,mcg_params)) {
-			return 1;
+			return FAILURE;
 		}
 
 		for (i=0; i < user_param->num_of_qps; i++) {
 			if (ibv_attach_mcast(ctx->qp[i],&mcg_params->mgid,mcg_params->mlid)) {
 				fprintf(stderr, "Couldn't attach QP to MultiCast group");
-				return 1;
+				return FAILURE;
 			}
 		}
 
@@ -113,7 +113,7 @@ static int send_set_up_connection(struct pingpong_context *ctx,
 		my_dest->lid = mcg_params->mlid;
 		my_dest->qpn = QPNUM_MCAST;
 	}
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -581,7 +581,7 @@ int main(int argc, char *argv[])
 		goto destroy_ctx;
 	}
 
-	return 0;
+	return SUCCESS;
 
 destroy_ctx:
 	destroy_ctx(&ctx,&user_param);
diff --git a/src/send_lat.c b/src/send_lat.c
index cc424c4..9d7b6bd 100755
--- a/src/send_lat.c
+++ b/src/send_lat.c
@@ -61,15 +61,15 @@ static int set_mcast_group(struct pingpong_context *ctx,
 	struct ibv_port_attr port_attr;
 
 	if (ibv_query_gid(ctx->context,user_param->ib_port,user_param->gid_index,&mcg_params->port_gid)) {
-		return 1;
+		return FAILURE;
 	}
 
 	if (ibv_query_pkey(ctx->context,user_param->ib_port,DEF_PKEY_IDX,&mcg_params->pkey)) {
-		return 1;
+		return FAILURE;
 	}
 
 	if (ibv_query_port(ctx->context,user_param->ib_port,&port_attr)) {
-		return 1;
+		return FAILURE;
 	}
 	mcg_params->sm_lid  = port_attr.sm_lid;
 	mcg_params->sm_sl   = port_attr.sm_sl;
@@ -81,7 +81,7 @@ static int set_mcast_group(struct pingpong_context *ctx,
 		/* Request for Mcast group create registery in SM. */
 		if (join_multicast_group(SUBN_ADM_METHOD_SET,mcg_params)) {
 			fprintf(stderr," Failed to Join Mcast request\n");
-			return 1;
+			return FAILURE;
 		}
 	}
 
@@ -89,12 +89,12 @@ static int set_mcast_group(struct pingpong_context *ctx,
 
 		if (ibv_attach_mcast(ctx->qp[i],&mcg_params->mgid,mcg_params->mlid)) {
 			fprintf(stderr, "Couldn't attach QP to MultiCast group");
-			return 1;
+			return FAILURE;
 		}
 	}
 	mcg_params->mcast_state |= MCAST_IS_ATTACHED;
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
@@ -118,13 +118,13 @@ static int send_set_up_connection(struct pingpong_context *ctx,
 		mcg_params->user_mgid = user_param->user_mgid;
 		set_multicast_gid(mcg_params,ctx->qp[0]->qp_num,(int)user_param->machine);
 		if (set_mcast_group(ctx,user_param,mcg_params)) {
-			return 1;
+			return FAILURE;
 		}
 
 		for (i=0; i < user_param->num_of_qps; i++) {
 			if (ibv_attach_mcast(ctx->qp[i],&mcg_params->mgid,mcg_params->mlid)) {
 				fprintf(stderr, "Couldn't attach QP to MultiCast group");
-				return 1;
+				return FAILURE;
 			}
 		}
 
@@ -134,7 +134,7 @@ static int send_set_up_connection(struct pingpong_context *ctx,
 		my_dest->qpn = QPNUM_MCAST;
 	}
 
-	return 0;
+	return SUCCESS;
 }
 
 /******************************************************************************
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
