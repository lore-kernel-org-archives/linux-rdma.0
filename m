From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 01/23] send_lat: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:31:56 -0400
Message-ID: <1471541538-20270-2-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clang noticed that we might leak mcg_params.ib_devname in failure paths.
There are additional leaks after fixing this initial one that it still
reported, here's hoping I've got them all now...

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
 37. perftest-3.0/src/send_lat.c:227:3: note: Taking false branch
 38. perftest-3.0/src/perftest_parameters.h:217:3: note: expanded from macro 'GET_STRING'
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

v2: fix up failure labels and segfault on qp alloc fail

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/send_lat.c | 71 +++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/src/send_lat.c b/src/send_lat.c
index 282cf11..cc424c4 100755
--- a/src/send_lat.c
+++ b/src/send_lat.c
@@ -205,9 +205,11 @@ int main(int argc, char *argv[])
 	if (ret_val) {
 		if (ret_val != VERSION_EXIT && ret_val != HELP_EXIT)
 			fprintf(stderr," Parser function exited with Error\n");
-		return 1;
+		return FAILURE;
 	}
 
+	ret_val = FAILURE;
+
 	if(user_param.use_xrc || user_param.connection_type == DC) {
 		user_param.num_of_qps *= 2;
 	}
@@ -215,14 +217,14 @@ int main(int argc, char *argv[])
 	/* Checking that the user did not run with RawEth. for this we have raw_etherent_bw test. */
 	if (user_param.connection_type == RawEth) {
 		fprintf(stderr," This test cannot run Raw Ethernet QPs (you have chosen RawEth as connection type\n");
-		return FAILURE;
+		return ret_val;
 	}
 
 	/* Finding the IB device selected (or defalut if no selected). */
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
 		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
-		return 1;
+		return ret_val;
 	}
 
 	if (user_param.use_mcg)
@@ -232,19 +234,19 @@ int main(int argc, char *argv[])
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		goto free_ib_devname;
 	}
 
 	/* See if MTU and link type are valid and supported. */
 	if (check_link(ctx.context,&user_param)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return FAILURE;
+		goto free_ib_devname;
 	}
 
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm,&user_param)) {
 		fprintf(stderr," Unable to create RDMA_CM resources\n");
-		return 1;
+		goto free_ib_devname;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) {
@@ -256,7 +258,7 @@ int main(int argc, char *argv[])
 	/* Initialize the connection and print the local data. */
 	if (establish_connection(&user_comm)) {
 		fprintf(stderr," Unable to init the socket connection\n");
-		return FAILURE;
+		goto free_ib_devname;
 	}
 
 	exchange_versions(&user_comm, &user_param);
@@ -266,7 +268,7 @@ int main(int argc, char *argv[])
 	/* See if MTU and link type are valid and supported. */
 	if (check_mtu(ctx.context,&user_param, &user_comm)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return FAILURE;
+		goto free_ib_devname;
 	}
 
 	ALLOCATE(my_dest , struct pingpong_dest , user_param.num_of_qps);
@@ -283,17 +285,17 @@ int main(int argc, char *argv[])
 		if (user_param.machine == CLIENT) {
 			if (retry_rdma_connect(&ctx,&user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_dests;
 			}
 
 		} else {
 			if (create_rdma_resources(&ctx,&user_param)) {
 				fprintf(stderr," Unable to create the rdma_resources\n");
-				return FAILURE;
+				goto free_dests;
 			}
 			if (rdma_server_connect(&ctx,&user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_dests;
 			}
 		}
 
@@ -302,14 +304,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources (data buffer, PD, MR, CQ and events channel) */
 		if (ctx_init(&ctx,&user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto free_dests;
 		}
 	}
 
 	/* Set up the Connection. */
 	if (send_set_up_connection(&ctx,&user_param,my_dest,&mcg_params,&user_comm)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	/* Print basic test information. */
@@ -324,7 +326,7 @@ int main(int argc, char *argv[])
 		/* shaking hands and gather the other side info. */
 		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
@@ -334,7 +336,7 @@ int main(int argc, char *argv[])
 		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
 			fprintf(stderr,"\n Found Incompatibility issue with GID types.\n");
 			fprintf(stderr," Please Try to use a different IP version.\n\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -348,7 +350,7 @@ int main(int argc, char *argv[])
 			/* Request for Mcast group create registery in SM. */
 			if (join_multicast_group(SUBN_ADM_METHOD_SET,&mcg_params)) {
 				fprintf(stderr," Failed to Join Mcast request\n");
-				return 1;
+				goto destroy_ctx;
 			}
 		}
 
@@ -369,26 +371,26 @@ int main(int argc, char *argv[])
 		/* Prepare IB resources for rtr/rts. */
 		if (ctx_connect(&ctx,rem_dest,&user_param,my_dest)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	/* shaking hands and gather the other side info. */
 	if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 		fprintf(stderr,"Failed to exchange data between server and clients\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (user_param.use_event) {
 
 		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
 			fprintf(stderr, "Couldn't request RCQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if (ibv_req_notify_cq(ctx.recv_cq, 0)) {
 			fprintf(stderr, "Couldn't request RCQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 	if (user_param.output == FULL_VERBOSITY) {
@@ -411,7 +413,7 @@ int main(int argc, char *argv[])
 			/* Post receive recv_wqes fo current message size */
 			if (ctx_set_recv_wqes(&ctx,&user_param)) {
 				fprintf(stderr," Failed to post receive recv_wqes\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
 			/* Sync between the client and server so the client won't send packets
@@ -420,11 +422,13 @@ int main(int argc, char *argv[])
 
 			if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 				fprintf(stderr,"Failed to exchange data between server and clients\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
-			if(run_iter_lat_send(&ctx, &user_param))
-				return 17;
+			if(run_iter_lat_send(&ctx, &user_param)) {
+				ret_val = 17;
+				goto destroy_ctx;
+			}
 
 			user_param.test_type == ITERATIONS ? print_report_lat(&user_param) : print_report_lat_duration(&user_param);
 		}
@@ -434,7 +438,7 @@ int main(int argc, char *argv[])
 		/* Post recevie recv_wqes fo current message size */
 		if (ctx_set_recv_wqes(&ctx,&user_param)) {
 			fprintf(stderr," Failed to post receive recv_wqes\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		/* Sync between the client and server so the client won't send packets
@@ -443,11 +447,13 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,my_dest,rem_dest)) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
-		if(run_iter_lat_send(&ctx, &user_param))
-			return 17;
+		if(run_iter_lat_send(&ctx, &user_param)) {
+			ret_val = 17;
+			goto destroy_ctx;
+		}
 
 		user_param.test_type == ITERATIONS ? print_report_lat(&user_param) : print_report_lat_duration(&user_param);
 	}
@@ -462,4 +468,13 @@ int main(int argc, char *argv[])
 	}
 
 	return send_destroy_ctx(&ctx,&user_param,&mcg_params);
+
+destroy_ctx:
+	destroy_ctx(&ctx,&user_param);
+free_dests:
+	free(my_dest);
+	free(rem_dest);
+free_ib_devname:
+	free(mcg_params.ib_devname);
+	return ret_val;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
