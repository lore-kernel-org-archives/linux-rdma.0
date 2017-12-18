From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] Move num-threads and cpu-affinity to common opts
Date: Mon, 18 Dec 2017 10:26:44 -0500
Message-ID: <7013670ca1d67055599a3c61fcc0e545cc0a4f5c.1513609601.git.dledford@redhat.com>
References: <cover.1513609601.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The option settings are split into common, server, client (which is
really client common), and client mode specific settings.  Move
the two listed options to the common settings.  This does not make
the options *work* for clients yet, just makes them accepted for
clients.  With the exception of changing the help comment for
num-threads, this made no other change except to move the code
location.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/SockPerf.cpp | 90 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/src/SockPerf.cpp b/src/SockPerf.cpp
index a7bc55e6bbc8..7f8d6969e645 100644
--- a/src/SockPerf.cpp
+++ b/src/SockPerf.cpp
@@ -169,6 +169,14 @@ static const AOPT_DESC  common_opt_desc[] =
 		'f', AOPT_ARG, aopt_set_literal( 'f' ), aopt_set_string( "file" ),
 		"Read multiple ip+port combinations from file <file> (will use IO muxer '-F' such as epoll, poll or select)"
 	},
+	{
+		OPT_THREADS_NUM, AOPT_ARG, aopt_set_literal( 0 ), aopt_set_string( "threads-num" ),
+		"Run <N> threads to process sockets (requires '-f' option)."
+	},
+	{
+		OPT_THREADS_AFFINITY, AOPT_ARG,	aopt_set_literal( 0 ),	aopt_set_string( "cpu-affinity" ),
+		"Set threads affinity to the given core ids in list format (see: cat /proc/cpuinfo)."
+	},
 	{
 		'F', AOPT_ARG, aopt_set_literal( 'F' ), aopt_set_string( "iomux-type" ),
 #ifdef WIN32
@@ -1421,14 +1429,6 @@ static int proc_mode_server( int id, int argc, const char **argv )
 			"Run in Bridge mode."
 		}, 
 */		
-		{
-			 OPT_THREADS_NUM, AOPT_ARG, aopt_set_literal( 0 ), aopt_set_string( "threads-num" ),
-			 "Run <N> threads on server side (requires '-f' option)."
-		 },
-		 {
-			 OPT_THREADS_AFFINITY, AOPT_ARG,	aopt_set_literal( 0 ),	aopt_set_string( "cpu-affinity" ),
-			 "Set threads affinity to the given core ids in list format (see: cat /proc/cpuinfo)."
-		 },
 #ifndef WIN32
 		 {
 			 OPT_VMARXFILTERCB, AOPT_NOARG,	aopt_set_literal( 0 ),	aopt_set_string( "vmarxfiltercb" ),
@@ -1493,43 +1493,6 @@ static int proc_mode_server( int id, int argc, const char **argv )
 			s_user_params.mode = MODE_BRIDGE;
 			p_addr->sin_port = htons(5001); /*iperf's default port*/
 		}
-
-		if ( !rc && aopt_check(server_obj, OPT_THREADS_NUM) ) {
-			if (aopt_check(common_obj, 'f')) {
-				const char* optarg = aopt_value(server_obj, OPT_THREADS_NUM);
-				if (optarg) {
-					s_user_params.mthread = 1;
-					errno = 0;
-					int threads_num = strtol(optarg, NULL, 0);
-					if (errno != 0  || threads_num <= 0) {
-						log_msg("'-%d' Invalid threads number: %s", OPT_THREADS_NUM, optarg);
-						rc = SOCKPERF_ERR_BAD_ARGUMENT;
-					}
-					else {
-						s_user_params.threads_num = threads_num;
-					}
-				}
-				else {
-					log_msg("'-%d' Invalid value", OPT_THREADS_NUM);
-					rc = SOCKPERF_ERR_BAD_ARGUMENT;
-				}
-			}
-			else {
-				log_msg("--threads-num must be used with feed file (option '-f')");
-				rc = SOCKPERF_ERR_BAD_ARGUMENT;
-			}
-		}
-
-		if ( !rc && aopt_check(server_obj, OPT_THREADS_AFFINITY) ) {
-			const char* optarg = aopt_value(server_obj, OPT_THREADS_AFFINITY);
-			if (optarg) {
-				strcpy(s_user_params.threads_affinity, optarg);
-			}
-			else {
-				log_msg("'-%d' Invalid threads affinity", OPT_THREADS_AFFINITY);
-				rc = SOCKPERF_ERR_BAD_ARGUMENT;
-			}
-		}
 #ifndef WIN32
 		if ( !rc && aopt_check(server_obj, OPT_VMARXFILTERCB) ) {
 			s_user_params.is_vmarxfiltercb = true;
@@ -1691,6 +1654,43 @@ static int parse_common_opt( const AOPT_OBJECT *common_obj )
 			}
 		}
 
+		if ( !rc && aopt_check(common_obj, OPT_THREADS_NUM) ) {
+			if (aopt_check(common_obj, 'f')) {
+				const char* optarg = aopt_value(common_obj, OPT_THREADS_NUM);
+				if (optarg) {
+					s_user_params.mthread = 1;
+					errno = 0;
+					int threads_num = strtol(optarg, NULL, 0);
+					if (errno != 0  || threads_num <= 0) {
+						log_msg("'-%d' Invalid threads number: %s", OPT_THREADS_NUM, optarg);
+						rc = SOCKPERF_ERR_BAD_ARGUMENT;
+					}
+					else {
+						s_user_params.threads_num = threads_num;
+					}
+				}
+				else {
+					log_msg("'-%d' Invalid value", OPT_THREADS_NUM);
+					rc = SOCKPERF_ERR_BAD_ARGUMENT;
+				}
+			}
+			else {
+				log_msg("--threads-num must be used with feed file (option '-f')");
+				rc = SOCKPERF_ERR_BAD_ARGUMENT;
+			}
+		}
+
+		if ( !rc && aopt_check(common_obj, OPT_THREADS_AFFINITY) ) {
+			const char* optarg = aopt_value(common_obj, OPT_THREADS_AFFINITY);
+			if (optarg) {
+				strcpy(s_user_params.threads_affinity, optarg);
+			}
+			else {
+				log_msg("'-%d' Invalid threads affinity", OPT_THREADS_AFFINITY);
+				rc = SOCKPERF_ERR_BAD_ARGUMENT;
+			}
+		}
+
 		if ( !rc && aopt_check(common_obj, 'F') ) {
 			if (aopt_check(common_obj, 'f')) {
 				const char* optarg = aopt_value(common_obj, 'F');
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
