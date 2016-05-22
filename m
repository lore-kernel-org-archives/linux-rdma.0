From: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH perftest] Fix assorted memory leaks on error paths
Date: Sun, 22 May 2016 07:25:58 +0000
Message-ID: <HE1PR05MB1161CBD222FA0968211017C7B54D0@HE1PR05MB1161.eurprd05.prod.outlook.com>
References: <1463593448-30864-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463593448-30864-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Jarod.
Same patch is also needed for src/send_bw.c ? 

-----Original Message-----
From: Jarod Wilson [mailto:jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org] 
Sent: Wednesday, May 18, 2016 8:44 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH perftest] Fix assorted memory leaks on error paths

Clang noticed that we might leak mcg_params.ib_devname in failure paths.
There are additional leaks after fixing this initial one that it still reported, here's hoping I've got them all now...

 1. perftest-3.0/src/send_lat.c:232:3: warning: Potential leak of memory pointed to by 'mcg_params.ib_devname'
 #                 fprintf(stderr, " Couldn't get context for the device\n");
 #                 ^
 4. perftest-3.0/src/send_lat.c:203:6: note: Assuming 'ret_val' is 0
 #         if (ret_val) {
 #             ^~~~~~~
 7. perftest-3.0/src/send_lat.c:203:2: note: Taking false branch
 #         if (ret_val) {
 #         ^
 10. perftest-3.0/src/send_lat.c:209:5: note: Left side of '||' is false
 #         if(user_param.use_xrc || user_param.connection_type == DC) {
 #            ^
 13. perftest-3.0/src/send_lat.c:209:2: note: Taking false branch
 #         if(user_param.use_xrc || user_param.connection_type == DC) {
 #         ^
 16. perftest-3.0/src/send_lat.c:214:2: note: Taking false branch
 #         if (user_param.connection_type == RawEth) {
 #         ^
 19. perftest-3.0/src/send_lat.c:221:6: note: Assuming 'ib_dev' is non-null
 #         if (!ib_dev) {
 #             ^~~~~~~
 22. perftest-3.0/src/send_lat.c:221:2: note: Taking false branch
 #         if (!ib_dev) {
 #         ^
 25. perftest-3.0/src/send_lat.c:226:2: note: Taking true branch
 #         if (user_param.use_mcg)
 #         ^
 28. perftest-3.0/src/send_lat.c:227:3: note: Memory is allocated
 #                 GET_STRING(mcg_params.ib_devname,ibv_get_device_name(ib_dev));
 #                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 31. perftest-3.0/src/perftest_parameters.h:217:3: note: expanded from macro 'GET_STRING'
 # { ALLOCATE(orig,char,(strlen(temp) + 1)); strcpy(orig,temp); }
 #   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 34. perftest-3.0/src/perftest_parameters.h:212:20: note: expanded from macro 'ALLOCATE'
 # { if((var = (type*)malloc(sizeof(type)*(size))) == NULL)        \
 #                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
 37. perftest-3.0/src/send_lat.c:227:3: note: Taking false branch  38. perftest-3.0/src/perftest_parameters.h:217:3: note: expanded from macro 'GET_STRING'
 # { ALLOCATE(orig,char,(strlen(temp) + 1)); strcpy(orig,temp); }
 #   ^
 41. perftest-3.0/src/perftest_parameters.h:212:3: note: expanded from macro 'ALLOCATE'
 # { if((var = (type*)malloc(sizeof(type)*(size))) == NULL)        \
 #   ^
 44. perftest-3.0/src/send_lat.c:231:2: note: Taking true branch
 #         if (!ctx.context) {
 #         ^
 47. perftest-3.0/src/send_lat.c:232:3: note: Potential leak of memory pointed to by 'mcg_params.ib_devname'
 #                 fprintf(stderr, " Couldn't get context for the device\n");
 #                 ^
 #   230|   	ctx.context = ibv_open_device(ib_dev);
 #   231|   	if (!ctx.context) {
 #   232|-> 		fprintf(stderr, " Couldn't get context for the device\n");
 #   233|   		return 1;
 #   234|   	}

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/send_lat.c | 62 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff --git a/src/send_lat.c b/src/send_lat.c index bc194d8..e5beda9 100755
--- a/src/send_lat.c
+++ b/src/send_lat.c
@@ -230,19 +230,19 @@ int main(int argc, char *argv[])
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		goto failure;
 	}
 
 	/* See if MTU and link type are valid and supported. */
 	if (check_link(ctx.context,&user_param)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return FAILURE;
+		goto failure;
 	}
 
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm,&user_param)) {
 		fprintf(stderr," Unable to create RDMA_CM resources\n");
-		return 1;
+		goto failure;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) { @@ -254,7 +254,7 @@ int main(int argc, char *argv[])
 	/* Initialize the connection and print the local data. */
 	if (establish_connection(&user_comm)) {
 		fprintf(stderr," Unable to init the socket connection\n");
-		return FAILURE;
+		goto failure;
 	}
 
 	exchange_versions(&user_comm, &user_param); @@ -264,7 +264,7 @@ int main(int argc, char *argv[])
 	/* See if MTU and link type are valid and supported. */
 	if (check_mtu(ctx.context,&user_param, &user_comm)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return FAILURE;
+		goto failure;
 	}
 
 	/* Print basic test information. */
@@ -284,17 +284,17 @@ int main(int argc, char *argv[])
 		if (user_param.machine == CLIENT) {
 			if (retry_rdma_connect(&ctx,&user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto failure2;
 			}
 
 		} else {
 			if (create_rdma_resources(&ctx,&user_param)) {
 				fprintf(stderr," Unable to create the rdma_resources\n");
-				return FAILURE;
+				goto failure2;
 			}
 			if (rdma_server_connect(&ctx,&user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto failure2;
 			}
 		}
 
@@ -303,14 +303,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources (data buffer, PD, MR, CQ and events channel) */
 		if (ctx_init(&ctx,&user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto failure2;
 		}
 	}
 
 	/* Set up the Connection. */
 	if (send_set_up_connection(&ctx,&user_param,my_dest,&mcg_params,&user_comm)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return 1;
+		goto failure2;
 	}
 
 	for (i=0; i < user_param.num_of_qps; i++) @@ -322,7 +322,7 @@ int main(int argc, char *argv[])
 		/* shaking hands and gather the other side info. */
 		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto failure2;
 		}
 
 		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
@@ -332,7 +332,7 @@ int main(int argc, char *argv[])
 		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
 			fprintf(stderr,"\n Found Incompatibility issue with GID types.\n");
 			fprintf(stderr," Please Try to use a different IP version.\n\n");
-			return 1;
+			goto failure2;
 		}
 	}
 
@@ -346,7 +346,7 @@ int main(int argc, char *argv[])
 			/* Request for Mcast group create registery in SM. */
 			if (join_multicast_group(SUBN_ADM_METHOD_SET,&mcg_params)) {
 				fprintf(stderr," Failed to Join Mcast request\n");
-				return 1;
+				goto failure;
 			}
 		}
 
@@ -367,26 +367,26 @@ int main(int argc, char *argv[])
 		/* Prepare IB resources for rtr/rts. */
 		if (ctx_connect(&ctx,rem_dest,&user_param,my_dest)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
-			return 1;
+			goto failure2;
 		}
 	}
 
 	/* shaking hands and gather the other side info. */
 	if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 		fprintf(stderr,"Failed to exchange data between server and clients\n");
-		return 1;
+		goto failure;
 	}
 
 	if (user_param.use_event) {
 
 		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
 			fprintf(stderr, "Couldn't request RCQ notification\n");
-			return 1;
+			goto failure2;
 		}
 
 		if (ibv_req_notify_cq(ctx.recv_cq, 0)) {
 			fprintf(stderr, "Couldn't request RCQ notification\n");
-			return 1;
+			goto failure;
 		}
 	}
 	if (user_param.output == FULL_VERBOSITY) { @@ -409,7 +409,7 @@ int main(int argc, char *argv[])
 			/* Post receive recv_wqes fo current message size */
 			if (ctx_set_recv_wqes(&ctx,&user_param)) {
 				fprintf(stderr," Failed to post receive recv_wqes\n");
-				return 1;
+				goto failure2;
 			}
 
 			/* Sync between the client and server so the client won't send packets @@ -418,11 +418,15 @@ int main(int argc, char *argv[])
 
 			if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 				fprintf(stderr,"Failed to exchange data between server and clients\n");
-				return 1;
+				goto failure2;
 			}
 
-			if(run_iter_lat_send(&ctx, &user_param))
+			if(run_iter_lat_send(&ctx, &user_param)) {
+				free(my_dest);
+				free(rem_dest);
+				free(mcg_params.ib_devname);
 				return 17;
+			}
 
 			user_param.test_type == ITERATIONS ? print_report_lat(&user_param) : print_report_lat_duration(&user_param);
 		}
@@ -432,7 +436,7 @@ int main(int argc, char *argv[])
 		/* Post recevie recv_wqes fo current message size */
 		if (ctx_set_recv_wqes(&ctx,&user_param)) {
 			fprintf(stderr," Failed to post receive recv_wqes\n");
-			return 1;
+			goto failure2;
 		}
 
 		/* Sync between the client and server so the client won't send packets @@ -441,11 +445,15 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,my_dest,rem_dest)) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto failure2;
 		}
 
-		if(run_iter_lat_send(&ctx, &user_param))
+		if(run_iter_lat_send(&ctx, &user_param)) {
+			free(my_dest);
+			free(rem_dest);
+			free(mcg_params.ib_devname);
 			return 17;
+		}
 
 		user_param.test_type == ITERATIONS ? print_report_lat(&user_param) : print_report_lat_duration(&user_param);
 	}
@@ -460,4 +468,12 @@ int main(int argc, char *argv[])
 	}
 
 	return send_destroy_ctx(&ctx,&user_param,&mcg_params);
+
+failure2:
+	free(my_dest);
+	free(rem_dest);
+	destroy_ctx(&ctx,&user_param);
+failure:
+	free(mcg_params.ib_devname);
+	return FAILURE;
 }
--
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
