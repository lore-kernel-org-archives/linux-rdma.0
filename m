From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] opensm - standardize on a single Windows #define -
	take #2
Date: Tue, 13 Oct 2009 09:15:35 -0700
Message-ID: <02AF42785F2743CA9BA06E8D48A79A25@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Sasha Khapyorsky <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


Code cleanup, standardize on a single Windows #define '__WIN__'.

Signed-off-by: Stan Smith <stan.smith@intel.com>

diff --git a/opensm/include/iba/ib_cm_types.h b/opensm/include/iba/ib_cm_types.h
index c1fbfaf..061f47b 100644
--- a/opensm/include/iba/ib_cm_types.h
+++ b/opensm/include/iba/ib_cm_types.h
@@ -36,7 +36,7 @@
 #if !defined(__IB_CM_TYPES_H__)
 #define __IB_CM_TYPES_H__
 
-#ifndef WIN32
+#ifndef __WIN__
 
 #include <iba/ib_types.h>
 
@@ -199,5 +199,5 @@ typedef uint16_t ib_sidr_status_t;
 #define IB_SIDR_UNSUPPORTED_VER				5
 
 END_C_DECLS
-#endif				/* ndef WIN32 */
+#endif				/* ndef __WIN__ */
 #endif				/* __IB_CM_TYPES_H__ */
diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index aa566f7..dac3a21 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -50,7 +50,7 @@
 #endif				/* __cplusplus */
 
 BEGIN_C_DECLS
-#if defined( WIN32 ) || defined( _WIN64 )
+#if defined( __WIN__ )
 #if defined( EXPORT_AL_SYMBOLS )
 #define OSM_EXPORT	__declspec(dllexport)
 #else
@@ -8309,7 +8309,7 @@ typedef struct _ib_mcast *__ptr64 ib_mcast_handle_t;
 	in order to be compliant with Infinicon ib_types; later we'll change it to support
 	OpenSM ib_types.h */
 
-#ifndef WIN32
+#ifndef __WIN__
 /****d* Access Layer/ib_api_status_t
 * NAME
 *	ib_api_status_t
@@ -10633,8 +10633,7 @@ typedef struct _ib_ci_op {
 *****/
 
 END_C_DECLS
-#endif				/* ndef WIN32 */
-#if defined( __WIN__ )
+#else				/* ndef __WIN__ */
 #include <iba/ib_types_extended.h>
 #endif
 #endif				/* __IB_TYPES_H__ */
diff --git a/opensm/libvendor/osm_pkt_randomizer.c b/opensm/libvendor/osm_pkt_randomizer.c
index 3e77b56..316c0eb 100644
--- a/opensm/libvendor/osm_pkt_randomizer.c
+++ b/opensm/libvendor/osm_pkt_randomizer.c
@@ -47,7 +47,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#ifndef WIN32
+#ifndef __WIN__
 #include <sys/time.h>
 #include <unistd.h>
 #endif
@@ -130,23 +130,23 @@ __osm_pkt_randomizer_process_path(IN osm_log_t * p_log,
 
 	if (rand_value_init == FALSE) {
 		int seed;
-#ifdef WIN32
+#ifdef __WIN__
 		SYSTEMTIME st;
 #else
 		struct timeval tv;
 		struct timezone tz;
-#endif				/*  WIN32 */
+#endif				/*  __WIN__ */
 
 		/* initiate the rand_value according to timeofday */
 		rand_value_init = TRUE;
 
-#ifdef WIN32
+#ifdef __WIN__
 		GetLocalTime(&st);
 		seed = st.wMilliseconds;
 #else
 		gettimeofday(&tv, &tz);
 		seed = tv.tv_usec;
-#endif				/*  WIN32 */
+#endif				/*  __WIN__ */
 
 		srand(seed);
 	}
diff --git a/opensm/opensm/osm_log.c b/opensm/opensm/osm_log.c
index 8f30784..918e696 100644
--- a/opensm/opensm/osm_log.c
+++ b/opensm/opensm/osm_log.c
@@ -55,7 +55,7 @@
 
 static int log_exit_count = 0;
 
-#ifndef WIN32
+#ifndef __WIN__
 #include <sys/time.h>
 #include <unistd.h>
 #include <complib/cl_timer.h>
@@ -76,9 +76,9 @@ static char *month_str[] = {
 };
 #else
 void OsmReportState(IN const char *p_str);
-#endif				/* ndef WIN32 */
+#endif				/* ndef __WIN__ */
 
-#ifndef WIN32
+#ifndef __WIN__
 
 static void truncate_log_file(osm_log_t * p_log)
 {
@@ -99,7 +99,7 @@ static void truncate_log_file(osm_log_t * p_log)
 	fprintf(stderr,
 		"truncate_log_file: cannot truncate on windows system (yet)\n");
 }
-#endif				/* ndef WIN32 */
+#endif				/* ndef __WIN__ */
 
 void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 	     IN const char *p_str, ...)
@@ -107,7 +107,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 	char buffer[LOG_ENTRY_SIZE_MAX];
 	va_list args;
 	int ret;
-#ifdef WIN32
+#ifdef __WIN__
 	SYSTEMTIME st;
 	uint32_t pid = GetCurrentThreadId();
 #else
@@ -116,7 +116,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 	struct tm result;
 	uint64_t time_usecs;
 	uint32_t usecs;
-#endif				/* WIN32 */
+#endif				/* __WIN__ */
 
 	/* If this is a call to syslog - always print it */
 	if (!(verbosity & (OSM_LOG_SYS | p_log->level)))
@@ -135,9 +135,9 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 			printf("%s\n", buffer);
 			fflush(stdout);
 		}
-#ifdef WIN32
+#ifdef __WIN__
 		OsmReportState(buffer);
-#endif				/* WIN32 */
+#endif				/* __WIN__ */
 	}
 
 	/* regular log to default out_port */
@@ -150,7 +150,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 			p_log->max_size);
 		truncate_log_file(p_log);
 	}
-#ifdef WIN32
+#ifdef __WIN__
 	GetLocalTime(&st);
 _retry:
 	ret =
diff --git a/opensm/opensm/st.c b/opensm/opensm/st.c
index c5a2f53..ea76038 100644
--- a/opensm/opensm/st.c
+++ b/opensm/opensm/st.c
@@ -43,10 +43,6 @@
 #include <string.h>
 #include <opensm/st.h>
 
-#ifdef _WIN32
-#include <malloc.h>
-#endif
-
 typedef struct st_table_entry st_table_entry;
 
 struct st_table_entry {
diff --git a/opensm/osmtest/include/osmtest_base.h b/opensm/osmtest/include/osmtest_base.h
index cda3a31..6c980a3 100644
--- a/opensm/osmtest/include/osmtest_base.h
+++ b/opensm/osmtest/include/osmtest_base.h
@@ -48,11 +48,7 @@
 #endif
 
 #define OSMTEST_MAX_LINE_LEN	120
-#ifdef WIN32
-#define OSMTEST_FILE_PATH_MAX	4096
-#else
 #define OSMTEST_FILE_PATH_MAX	PATH_MAX
-#endif
 
 #define STRESS_SMALL_RMPP_THR 100000
 /*
