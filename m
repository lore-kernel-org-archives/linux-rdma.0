From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] Move server thread handler to SockPerf.cpp
Date: Mon, 18 Dec 2017 10:26:45 -0500
Message-ID: <f5476bda4fb879e335ddcc29989de42a3284e130.1513609601.git.dledford@redhat.com>
References: <cover.1513609601.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to use the thread starting code as common, move it to
SockPerf.cpp and make it no longer specific to the server.  Next we'll
add a Client handler and call that from the common code.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/Server.cpp   | 133 ++----------------------------------------------------
 src/SockPerf.cpp | 135 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 136 insertions(+), 132 deletions(-)

diff --git a/src/Server.cpp b/src/Server.cpp
index adbc29f07b65..f6d79a245ff4 100644
--- a/src/Server.cpp
+++ b/src/Server.cpp
@@ -32,8 +32,8 @@
 
 // static members initialization
 /*static*/ seq_num_map SwitchOnCalcGaps::ms_seq_num_map;
-static CRITICAL_SECTION	thread_exit_lock;
-static os_thread_t *thread_pid_array = NULL;
+extern CRITICAL_SECTION	thread_exit_lock;
+extern os_thread_t *thread_pid_array;
 
 //==============================================================================
 
@@ -407,7 +407,7 @@ void server_handler(handler_info *p_info)
 
 
 //------------------------------------------------------------------------------
-void *server_handler_for_multi_threaded(void *arg)
+void *server_handler_multi_thread(void *arg)
 {
 	handler_info *p_info = (handler_info *)arg;
 
@@ -431,23 +431,6 @@ void *server_handler_for_multi_threaded(void *arg)
 }
 
 
-//------------------------------------------------------------------------------
-void find_min_max_fds(int start_look_from, int len, int* p_fd_min, int* p_fd_max) {
-	int num_of_detected_fds;
-	int i;
-
-	for(num_of_detected_fds = 0, i = start_look_from; num_of_detected_fds < len;i++) {
-		if (g_fds_array[i]) {
-			if (!num_of_detected_fds) {
-				*p_fd_min = i;
-			}
-			num_of_detected_fds++;
-		}
-	}
-	*p_fd_max = i - 1;
-}
-
-
 //------------------------------------------------------------------------------
 void server_sig_handler(int signum) {
 	if (g_b_exit) {
@@ -497,116 +480,6 @@ void server_sig_handler(int signum) {
 }
 
 
-//------------------------------------------------------------------------------
-void server_select_per_thread(int _fd_num) {
-	int rc = SOCKPERF_ERR_NONE;
-	int i;
-	os_thread_t thread;
-	int fd_num;
-	int num_of_remainded_fds;
-	int last_fds = 0;
-	handler_info *handler_info_array = NULL;
-
-	handler_info_array = (handler_info*)MALLOC(sizeof(handler_info) * g_pApp->m_const_params.threads_num);
-	memset(handler_info_array, 0, sizeof(handler_info) * g_pApp->m_const_params.threads_num);
-	if (!handler_info_array) {
-		log_err("Failed to allocate memory for handler_info_arr");
-		rc = SOCKPERF_ERR_NO_MEMORY;
-	}
-
-	if (rc == SOCKPERF_ERR_NONE) {
-		thread_pid_array = (os_thread_t*)MALLOC(sizeof(os_thread_t)*(g_pApp->m_const_params.threads_num + 1));
-		if(!thread_pid_array) {
-			log_err("Failed to allocate memory for pid array");
-			rc = SOCKPERF_ERR_NO_MEMORY;
-		}
-		else {
-			memset(thread_pid_array, 0, sizeof(os_thread_t)*(g_pApp->m_const_params.threads_num + 1));
-			log_msg("Running %d threads to manage %d sockets", g_pApp->m_const_params.threads_num, _fd_num);
-		}
-	}
-
-	if (rc == SOCKPERF_ERR_NONE) {
-		INIT_CRITICAL(&thread_exit_lock);
-
-		thread_pid_array[0].tid = os_getthread().tid;
-
-		/* Divide fds_arr between threads */
-		num_of_remainded_fds = _fd_num % g_pApp->m_const_params.threads_num;
-		fd_num = _fd_num / g_pApp->m_const_params.threads_num;
-
-		for (i = 0; i < g_pApp->m_const_params.threads_num; i++) {
-			handler_info *cur_handler_info = (handler_info_array + i);
-
-			/* Set ID of handler (thread) */
-			cur_handler_info->id = i;
-
-			/* Set number of processed sockets */
-			cur_handler_info->fd_num = fd_num;
-			if (num_of_remainded_fds) {
-				cur_handler_info->fd_num++;
-				num_of_remainded_fds--;
-			}
-
-			/* Set min/max possible socket to be processed */
-			find_min_max_fds(last_fds, cur_handler_info->fd_num, &(cur_handler_info->fd_min), &(cur_handler_info->fd_max));
-
-			/* Launch handler */
-			errno = 0;
-			int ret = os_thread_exec(&thread, server_handler_for_multi_threaded, (void *)cur_handler_info);
-
-			/*
-			 * There is undocumented behaviour for early versions of libc (for example libc 2.5, 2.6, 2.7)
-			 * as pthread_create() call returns error code 12 ENOMEM and return value 0
-			 * Note: libc-2.9 demonstrates expected behaivour
-			 */
-			if ( (ret != 0) || (errno == ENOMEM) ) {
-				log_err("create thread has failed");
-				rc = SOCKPERF_ERR_FATAL;
-				break;
-			}
-			thread_pid_array[i + 1].tid = thread.tid;
-			last_fds = cur_handler_info->fd_max + 1;
-		}
-
-		/* Wait for ^C */
-		while ((rc == SOCKPERF_ERR_NONE) && !g_b_exit) {
-			sleep(1);
-		}
-
-		/* Stop all launched threads (the first index is reserved for main thread) */
-		for (i = 1; i <= g_pApp->m_const_params.threads_num; i++) {
-			os_thread_t cur_thread_pid;
-			cur_thread_pid.tid = 0;
-
-			ENTER_CRITICAL(&thread_exit_lock);
-			cur_thread_pid.tid = thread_pid_array[i].tid;
-			if (cur_thread_pid.tid) {
-				os_thread_kill(&cur_thread_pid);
-			}
-			LEAVE_CRITICAL(&thread_exit_lock);
-			if (cur_thread_pid.tid) {
-				os_thread_join(&cur_thread_pid);
-			}
-		}
-
-		DELETE_CRITICAL(&thread_exit_lock);
-	}
-
-	/* Free thread info allocated data */
-	if (handler_info_array) {
-		FREE(handler_info_array);
-	}
-
-	/* Free thread TID array */
-	if (thread_pid_array) {
-		FREE(thread_pid_array);
-	}
-
-	log_msg("%s() exit", __func__);
-}
-
-
 // Temp location because of compilation issue (inline-unit-growth=200) with the way this method was inlined
 void SwitchOnCalcGaps::execute(struct sockaddr_in *clt_addr, uint64_t seq_num, bool is_warmup)
 {
diff --git a/src/SockPerf.cpp b/src/SockPerf.cpp
index 7f8d6969e645..3c628cbc5ba1 100644
--- a/src/SockPerf.cpp
+++ b/src/SockPerf.cpp
@@ -86,12 +86,16 @@
 #include <dlfcn.h>
 #endif
 
+// For use by both Client.cpp & Server.cpp
+CRITICAL_SECTION	thread_exit_lock;
+os_thread_t *thread_pid_array = NULL;
+
 // forward declarations from Client.cpp & Server.cpp
 extern void client_sig_handler(int signum);
 extern void client_handler(handler_info *);
 extern void server_sig_handler(int signum);
 extern void server_handler(handler_info *);
-extern void server_select_per_thread(int fd_num);
+extern void *server_handler_multi_thread(void *);
 
 static bool sock_lib_started = 0; // 
 static int fd_max = 0;
@@ -331,6 +335,133 @@ static const AOPT_DESC  client_opt_desc[] =
 };
 
 
+//------------------------------------------------------------------------------
+void find_min_max_fds(int start_look_from, int len, int* p_fd_min, int* p_fd_max) {
+	int num_of_detected_fds;
+	int i;
+
+	for(num_of_detected_fds = 0, i = start_look_from; num_of_detected_fds < len;i++) {
+		if (g_fds_array[i]) {
+			if (!num_of_detected_fds) {
+				*p_fd_min = i;
+			}
+			num_of_detected_fds++;
+		}
+	}
+	*p_fd_max = i - 1;
+}
+
+
+//------------------------------------------------------------------------------
+void select_per_thread(void *(handler)(void *), int _fd_num) {
+	int rc = SOCKPERF_ERR_NONE;
+	int i;
+	os_thread_t thread;
+	int fd_num;
+	int num_of_remainded_fds;
+	int last_fds = 0;
+	handler_info *handler_info_array = NULL;
+
+	handler_info_array = (handler_info*)MALLOC(sizeof(handler_info) * g_pApp->m_const_params.threads_num);
+	memset(handler_info_array, 0, sizeof(handler_info) * g_pApp->m_const_params.threads_num);
+	if (!handler_info_array) {
+		log_err("Failed to allocate memory for handler_info_arr");
+		rc = SOCKPERF_ERR_NO_MEMORY;
+	}
+
+	if (rc == SOCKPERF_ERR_NONE) {
+		thread_pid_array = (os_thread_t*)MALLOC(sizeof(os_thread_t)*(g_pApp->m_const_params.threads_num + 1));
+		if(!thread_pid_array) {
+			log_err("Failed to allocate memory for pid array");
+			rc = SOCKPERF_ERR_NO_MEMORY;
+		}
+		else {
+			memset(thread_pid_array, 0, sizeof(os_thread_t)*(g_pApp->m_const_params.threads_num + 1));
+			log_msg("Running %d threads to manage %d sockets", g_pApp->m_const_params.threads_num, _fd_num);
+		}
+	}
+
+	if (rc == SOCKPERF_ERR_NONE) {
+		INIT_CRITICAL(&thread_exit_lock);
+
+		thread_pid_array[0].tid = os_getthread().tid;
+
+		/* Divide fds_arr between threads */
+		num_of_remainded_fds = _fd_num % g_pApp->m_const_params.threads_num;
+		fd_num = _fd_num / g_pApp->m_const_params.threads_num;
+
+		for (i = 0; i < g_pApp->m_const_params.threads_num; i++) {
+			handler_info *cur_handler_info = (handler_info_array + i);
+
+			/* Set ID of handler (thread) */
+			cur_handler_info->id = i;
+
+			/* Set number of processed sockets */
+			cur_handler_info->fd_num = fd_num;
+			if (num_of_remainded_fds) {
+				cur_handler_info->fd_num++;
+				num_of_remainded_fds--;
+			}
+
+			/* Set min/max possible socket to be processed */
+			find_min_max_fds(last_fds, cur_handler_info->fd_num, &(cur_handler_info->fd_min), &(cur_handler_info->fd_max));
+
+			/* Launch handler */
+			errno = 0;
+			int ret = os_thread_exec(&thread, handler, (void *)cur_handler_info);
+
+			/*
+			 * There is undocumented behaviour for early versions of libc (for example libc 2.5, 2.6, 2.7)
+			 * as pthread_create() call returns error code 12 ENOMEM and return value 0
+			 * Note: libc-2.9 demonstrates expected behaivour
+			 */
+			if ( (ret != 0) || (errno == ENOMEM) ) {
+				log_err("create thread has failed");
+				rc = SOCKPERF_ERR_FATAL;
+				break;
+			}
+			thread_pid_array[i + 1].tid = thread.tid;
+			last_fds = cur_handler_info->fd_max + 1;
+		}
+
+		/* Wait for ^C */
+		while ((rc == SOCKPERF_ERR_NONE) && !g_b_exit) {
+			sleep(1);
+		}
+
+		/* Stop all launched threads (the first index is reserved for main thread) */
+		for (i = 1; i <= g_pApp->m_const_params.threads_num; i++) {
+			os_thread_t cur_thread_pid;
+			cur_thread_pid.tid = 0;
+
+			ENTER_CRITICAL(&thread_exit_lock);
+			cur_thread_pid.tid = thread_pid_array[i].tid;
+			if (cur_thread_pid.tid) {
+				os_thread_kill(&cur_thread_pid);
+			}
+			LEAVE_CRITICAL(&thread_exit_lock);
+			if (cur_thread_pid.tid) {
+				os_thread_join(&cur_thread_pid);
+			}
+		}
+
+		DELETE_CRITICAL(&thread_exit_lock);
+	}
+
+	/* Free thread info allocated data */
+	if (handler_info_array) {
+		FREE(handler_info_array);
+	}
+
+	/* Free thread TID array */
+	if (thread_pid_array) {
+		FREE(thread_pid_array);
+	}
+
+	log_msg("%s() exit", __func__);
+}
+
+
 //------------------------------------------------------------------------------
 static int proc_mode_help( int id, int argc, const char **argv )
 {
@@ -3344,7 +3475,7 @@ void do_test()
 		break;
 	case MODE_SERVER:
 		if (s_user_params.mthread) {
-			server_select_per_thread(fd_num);
+			select_per_thread(server_handler_multi_thread, fd_num);
 		}
 		else {
 			server_handler(&info);
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
