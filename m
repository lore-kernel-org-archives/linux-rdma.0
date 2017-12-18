From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] Rename a few variables
Date: Mon, 18 Dec 2017 10:26:43 -0500
Message-ID: <c2f29e88858dfa640cf3dfac2a6c6f8995ff2b2a.1513609601.git.dledford@redhat.com>
References: <cover.1513609601.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In preparation for making sockperf use multiple threads both in server
and client mode, rename a few variables related to the multi-thread
operation that had hints that they only applied to server mode to more
generic names that don't provide what will soon be a false hint.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/Defs.h       |  2 +-
 src/Server.cpp   |  4 ++--
 src/SockPerf.cpp | 58 ++++++++++++++++++++++++++++----------------------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/src/Defs.h b/src/Defs.h
index 51098e8ba098..0ee0f1e229c7 100644
--- a/src/Defs.h
+++ b/src/Defs.h
@@ -590,7 +590,7 @@ struct user_params_t {
 	unsigned int  burst_size;
 	bool packetrate_stats_print_details;
 //	bool stream_mode; - use b_stream instead
-	int mthread_server;
+	int mthread;
 	struct timeval* select_timeout;
 	int sock_buff_size;
 	int threads_num;
diff --git a/src/Server.cpp b/src/Server.cpp
index efc0222197bf..adbc29f07b65 100644
--- a/src/Server.cpp
+++ b/src/Server.cpp
@@ -146,7 +146,7 @@ void ServerBase::cleanupAfterLoop() {
 	// cleanup
 	log_dbg("thread %lu released allocations",(unsigned long)os_getthread().tid);
 
-	if (!g_pApp->m_const_params.mthread_server) {
+	if (!g_pApp->m_const_params.mthread) {
 		log_msg("%s() exit", __func__);
 	}
 }
@@ -461,7 +461,7 @@ void server_sig_handler(int signum) {
 	   (g_pApp->m_const_params.packetrate_stats_print_ratio < g_receiveCount))
 		printf("\n");
 
-	if (g_pApp->m_const_params.mthread_server) {
+	if (g_pApp->m_const_params.mthread) {
 		if (os_getthread().tid == thread_pid_array[0].tid) {  //main thread
 			if (g_debug_level >= LOG_LVL_DEBUG) {
 				log_dbg("Main thread %lu got signal %d - exiting",(unsigned long)os_getthread().tid,signum);
diff --git a/src/SockPerf.cpp b/src/SockPerf.cpp
index 9603fa305bf6..a7bc55e6bbc8 100644
--- a/src/SockPerf.cpp
+++ b/src/SockPerf.cpp
@@ -94,9 +94,9 @@ extern void server_handler(handler_info *);
 extern void server_select_per_thread(int fd_num);
 
 static bool sock_lib_started = 0; // 
-static int s_fd_max = 0;
-static int s_fd_min = 0;	/* used as THE fd when single mc group is given (RECVFROM blocked mode) */
-static int s_fd_num = 0;
+static int fd_max = 0;
+static int fd_min = 0;	/* used as THE fd when single mc group is given (RECVFROM blocked mode) */
+static int fd_num = 0;
 static struct mutable_params_t s_mutable_params;
 
 static void set_select_timeout(int time_out_msec);
@@ -1498,7 +1498,7 @@ static int proc_mode_server( int id, int argc, const char **argv )
 			if (aopt_check(common_obj, 'f')) {
 				const char* optarg = aopt_value(server_obj, OPT_THREADS_NUM);
 				if (optarg) {
-					s_user_params.mthread_server = 1;
+					s_user_params.mthread = 1;
 					errno = 0;
 					int threads_num = strtol(optarg, NULL, 0);
 					if (errno != 0  || threads_num <= 0) {
@@ -2190,7 +2190,7 @@ void cleanup()
 	int ifd;
 	if (g_fds_array)
 	{
-		for (ifd = 0; ifd <= s_fd_max; ifd++) {
+		for (ifd = 0; ifd <= fd_max; ifd++) {
 			if (g_fds_array[ifd]) {
 				close(ifd);
 				if (g_fds_array[ifd]->active_fd_list) {
@@ -2212,7 +2212,7 @@ void cleanup()
 	}
 #ifdef USING_VMA_EXTRA_API
 	if (g_vma_api && s_user_params.is_vmazcopyread) {
-		for (int i = s_fd_min; i < s_fd_max; i++) {
+		for (int i = fd_min; i < fd_max; i++) {
 			delete g_zeroCopyData[i];
 		}
 	}
@@ -2291,7 +2291,7 @@ void set_defaults()
 	s_user_params.burst_size	= 1;
 	s_user_params.data_integrity = false;
 	s_user_params.fd_handler_type = RECVFROM;
-	s_user_params.mthread_server = 0;
+	s_user_params.mthread = 0;
 	s_user_params.msg_size = MIN_PAYLOAD_SIZE;
 	s_user_params.msg_size_range = 0;
 	s_user_params.sock_buff_size = SOCK_BUFF_DEFAULT_SIZE;
@@ -2968,7 +2968,7 @@ static int set_sockets_from_feedfile(const char *feedfile_name)
 			/* Check if the same value exists */
 			bool is_exist = false;
 			port_and_type port_type_tmp = {tmp->sock_type,tmp->server_addr.sin_port};
-			for (int i = s_fd_min; i <= s_fd_max; i++) {
+			for (int i = fd_min; i <= fd_max; i++) {
 				/* duplicated values are accepted in case client connection using TCP */
 				/* or in case source address is set for multicast socket */
 				if (((s_user_params.mode == MODE_CLIENT)  && (tmp->sock_type == SOCK_STREAM)) || ((tmp->is_multicast) && (tmp->mc_source_ip_addr.s_addr != INADDR_ANY))) {
@@ -3026,7 +3026,7 @@ static int set_sockets_from_feedfile(const char *feedfile_name)
 					}
 					tmp->memberships_size=0;
 
-					s_fd_num++;
+					fd_num++;
 				}
 				if ( curr_fd >=0 ) {
 					if ( (curr_fd >= MAX_FDS_NUM) ||
@@ -3055,14 +3055,14 @@ static int set_sockets_from_feedfile(const char *feedfile_name)
 						tmp->recv.cur_size = tmp->recv.max_size;
 
 						if (new_socket_flag) {
-							if (s_fd_num == 1){ /*it is the first fd*/
-								s_fd_min = curr_fd;
-								s_fd_max = curr_fd;
+							if (fd_num == 1){ /*it is the first fd*/
+								fd_min = curr_fd;
+								fd_max = curr_fd;
 							}
 							else {
 								g_fds_array[last_fd]->next_fd = curr_fd;
-								s_fd_min = _min(s_fd_min, curr_fd);
-								s_fd_max = _max(s_fd_max, curr_fd);
+								fd_min = _min(fd_min, curr_fd);
+								fd_max = _max(fd_max, curr_fd);
 							}
 							last_fd = curr_fd;
 							g_fds_array[curr_fd] = tmp;
@@ -3088,7 +3088,7 @@ static int set_sockets_from_feedfile(const char *feedfile_name)
 	fclose(file_fd);
 
 	if (!rc) {
-		g_fds_array[s_fd_max]->next_fd = s_fd_min; /* close loop for fast wrap around in client */
+		g_fds_array[fd_max]->next_fd = fd_min; /* close loop for fast wrap around in client */
 
 #ifdef ST_TEST
 		{
@@ -3215,7 +3215,7 @@ int bringup(const int *p_daemonize)
 						else {
 							int i = 0;
 
-							s_fd_num = 1;
+							fd_num = 1;
 
 							for (i = 0; i < MAX_ACTIVE_FD_NUM; i++) {
 								tmp->active_fd_list[i] = (int)INVALID_SOCKET;
@@ -3231,9 +3231,9 @@ int bringup(const int *p_daemonize)
 							tmp->recv.cur_offset = 0;
 							tmp->recv.cur_size = tmp->recv.max_size;
 
-							s_fd_min = s_fd_max = curr_fd;
-							g_fds_array[s_fd_min] = tmp;
-							g_fds_array[s_fd_min]->next_fd = s_fd_min;
+							fd_min = fd_max = curr_fd;
+							g_fds_array[fd_min] = tmp;
+							g_fds_array[fd_min]->next_fd = fd_min;
 						}
 					}
 				}
@@ -3252,7 +3252,7 @@ int bringup(const int *p_daemonize)
 		}
 
 		if ( !rc &&
-				(s_user_params.threads_num > s_fd_num  || s_user_params.threads_num == 0)) {
+				(s_user_params.threads_num > fd_num  || s_user_params.threads_num == 0)) {
 			log_msg("Number of threads should be less than sockets count");
 			rc = SOCKPERF_ERR_BAD_ARGUMENT;
 		}
@@ -3305,7 +3305,7 @@ int bringup(const int *p_daemonize)
 		}
 
 		s_user_params.warmup_msec = TEST_FIRST_CONNECTION_FIRST_PACKET_TTL_THRESHOLD_MSEC +
-				s_fd_num * TEST_ANY_CONNECTION_FIRST_PACKET_TTL_THRESHOLD_MSEC;
+				fd_num * TEST_ANY_CONNECTION_FIRST_PACKET_TTL_THRESHOLD_MSEC;
 		if (s_user_params.warmup_msec < TEST_START_WARMUP_MSEC) {
 			s_user_params.warmup_msec = TEST_START_WARMUP_MSEC;
 		} else {
@@ -3327,12 +3327,12 @@ void do_test()
 	handler_info info;
 
 	info.id = 0;
-	info.fd_min = s_fd_min;
-	info.fd_max = s_fd_max;
-	info.fd_num = s_fd_num;
+	info.fd_min = fd_min;
+	info.fd_max = fd_max;
+	info.fd_num = fd_num;
 #ifdef USING_VMA_EXTRA_API
 	if (g_vma_api && s_user_params.is_vmazcopyread) {
-		for (int i = s_fd_min; i < s_fd_max; i++) {
+		for (int i = fd_min; i < fd_max; i++) {
 			g_zeroCopyData[i] = new ZeroCopyData();
 			g_zeroCopyData[i]->allocate();
 		}
@@ -3343,8 +3343,8 @@ void do_test()
 		client_handler(&info);
 		break;
 	case MODE_SERVER:
-		if (s_user_params.mthread_server) {
-			server_select_per_thread(s_fd_num);
+		if (s_user_params.mthread) {
+			server_select_per_thread(fd_num);
 		}
 		else {
 			server_handler(&info);
@@ -3423,7 +3423,7 @@ packetrate_stats_print_ratio = %d \n\t\
 burst_size = %d \n\t\
 packetrate_stats_print_details = %d \n\t\
 fd_handler_type = %d \n\t\
-mthread_server = %d \n\t\
+mthread = %d \n\t\
 sock_buff_size = %d \n\t\
 threads_num = %d \n\t\
 threads_affinity = %s \n\t\
@@ -3462,7 +3462,7 @@ s_user_params.packetrate_stats_print_ratio,
 s_user_params.burst_size,
 s_user_params.packetrate_stats_print_details,
 s_user_params.fd_handler_type,
-s_user_params.mthread_server,
+s_user_params.mthread,
 s_user_params.sock_buff_size,
 s_user_params.threads_num,
 s_user_params.threads_affinity,
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
