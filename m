From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 06/13] Consolidate definitions for paths into config.h
Date: Fri, 23 Sep 2016 13:17:01 -0600
Message-ID: <1474658228-5390-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

config.h is the only place we pass through cmake substitution,
so it is the only place that can define the various filesystem
paths.

This patch handles the C code portions that use paths.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                     | 10 ++++++++++
 buildlib/config.h.in               | 13 +++++++++++--
 ibacm/CMakeLists.txt               |  5 -----
 ibacm/linux/osd.h                  |  2 +-
 ibacm/src/acm.c                    |  6 +++---
 ibacm/src/acme.c                   | 10 +++++-----
 ibacm/src/libacm.c                 |  2 +-
 iwpmd/src/iwarp_pm.h               |  1 -
 iwpmd/src/iwarp_pm_server.c        |  1 +
 librdmacm/src/acm.c                |  2 +-
 librdmacm/src/cma.h                |  9 ---------
 srp_daemon/srp_daemon/srp_daemon.c |  4 ++--
 12 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 9b9e34e5cd9d..713788f188e3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -53,6 +53,16 @@ set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd"
 set(ACM_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/ibacm"
   CACHE PATH "Location for ibacm provider plugin shared library files.")
 
+# Allow the 'run' dir to be configurable, this historically has been /var/run, but
+# some systems now use /run/
+set(CMAKE_INSTALL_RUNDIR "var/run"
+  CACHE PATH "Location for runtime information, typically /var/run, or /run")
+if(NOT IS_ABSOLUTE ${CMAKE_INSTALL_RUNDIR})
+  set(CMAKE_INSTALL_FULL_RUNDIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_RUNDIR}")
+else()
+  set(CMAKE_INSTALL_FULL_RUNDIR "${CMAKE_INSTALL_RUNDIR}")
+endif()
+
 #-------------------------
 # Load CMake components
 set(BUILDLIB "${CMAKE_SOURCE_DIR}/buildlib")
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 984d51bfaa09..bbc279d3c9c3 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -17,9 +17,18 @@
 #define HAVE_VALGRIND_MEMCHECK_H 1
 #define INCLUDE_VALGRIND 1
 
-#define SYSCONFDIR "@CMAKE_INSTALL_FULL_SYSCONFDIR@"
-
 #define IBV_CONFIG_DIR "@CONFIG_DIR@"
+#define RS_CONF_DIR "@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/rsocket"
+#define IWPM_CONFIG_FILE "@CMAKE_INSTALL_FULL_SYSCONFDIR@/iwpmd.conf"
+
+#define SRP_DEAMON_CONFIG_FILE "@CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf"
+
+#define ACM_CONF_DIR "@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma"
+#define IBACM_LIB_PATH "@ACM_PROVIDER_DIR@"
+#define IBACM_BIN_PATH "@CMAKE_INSTALL_FULL_BINDIR@"
+#define IBACM_PID_FILE "@CMAKE_INSTALL_FULL_RUNDIR@/ibacm.pid"
+#define IBACM_PORT_FILE "@CMAKE_INSTALL_FULL_RUNDIR@/ibacm.port"
+#define IBACM_LOG_FILE "@CMAKE_INSTALL_FULL_LOCALSTATEDIR@/log/ibacm.log"
 
 // FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
 #cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 8887c13af463..857a6e82320a 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -3,11 +3,6 @@ publish_headers(infiniband
   include/infiniband/acm_prov.h
   )
 
-# FIXME: To config.h
-add_definitions("-DIBACM_CONFIG_PATH=\"${CMAKE_INSTALL_FULL_SYSCONFDIR}/rdma\"")
-add_definitions("-DIBACM_LIB_PATH=\"${ACM_PROVIDER_DIR}\"")
-add_definitions("-DIBACM_BIN_PATH=\"${CMAKE_INSTALL_FULL_BINDIR}\"")
-
 # FIXME: Fixup the include scheme to not require all these -Is
 include_directories("include")
 include_directories("src")
diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 5ca4c6f554c5..83d31b3589c5 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -31,6 +31,7 @@
 #if !defined(OSD_H)
 #define OSD_H
 
+#include <config.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
@@ -46,7 +47,6 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 
-#define ACM_CONF_DIR  IBACM_CONFIG_PATH
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
 
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index ab1269f71d02..4650421b81b7 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -226,9 +226,9 @@ static struct sa_data {
 static char *acme = IBACM_BIN_PATH "/ib_acme -A";
 static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
 static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
-static char log_file[128] = "/var/log/ibacm.log";
+static char log_file[128] = IBACM_LOG_FILE;
 static int log_level = 0;
-static char lock_file[128] = "/var/run/ibacm.pid";
+static char lock_file[128] = IBACM_PID_FILE;
 static short server_port = 6125;
 static int support_ips_in_addr_cfg = 0;
 static char prov_lib_path[256] = IBACM_LIB_PATH;
@@ -578,7 +578,7 @@ static void acm_init_server(void)
 		atomic_init(&client_array[i].refcnt);
 	}
 
-	if (!(f = fopen("/var/run/ibacm.port", "w"))) {
+	if (!(f = fopen(IBACM_PORT_FILE, "w"))) {
 		acm_log(0, "notice - cannot publish ibacm port number\n");
 		return;
 	}
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index f1b0d010625e..4d9003047506 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -130,9 +130,9 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# Examples:\n");
 	fprintf(f, "# log_file stdout\n");
 	fprintf(f, "# log_file stderr\n");
-	fprintf(f, "# log_file /var/log/ibacm.log\n");
+	fprintf(f, "# log_file %s\n", IBACM_LOG_FILE);
 	fprintf(f, "\n");
-	fprintf(f, "log_file /var/log/ibacm.log\n");
+	fprintf(f, "log_file %s\n", IBACM_LOG_FILE);
 	fprintf(f, "\n");
 	fprintf(f, "# log_level:\n");
 	fprintf(f, "# Indicates the amount of detailed data written to the log file.  Log levels\n");
@@ -147,7 +147,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# Specifies the location of the ACM lock file used to ensure that only a\n");
 	fprintf(f, "# single instance of ACM is running.\n");
 	fprintf(f, "\n");
-	fprintf(f, "lock_file /var/run/ibacm.pid\n");
+	fprintf(f, "lock_file %s\n", IBACM_PID_FILE);
 	fprintf(f, "\n");
 	fprintf(f, "# addr_prot:\n");
 	fprintf(f, "# Default resolution protocol to resolve IP addresses into IB GIDs.\n");
@@ -276,7 +276,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# the ACM cache.  This option is only valid if route_preload\n");
 	fprintf(f, "# indicates that routing data should be read from a file.\n");
 	fprintf(f, "# Default is %s/ibacm_route.data\n", ACM_CONF_DIR);
-	fprintf(f, "# route_data_file /etc/rdma/ibacm_route.data\n");
+	fprintf(f, "# route_data_file %s/ibacm_route.data\n", ACM_CONF_DIR);
 	fprintf(f, "\n");
 	fprintf(f, "# addr_preload:\n");
 	fprintf(f, "# Specifies if the ACM address cache should be preloaded, or built on demand.\n");
@@ -292,7 +292,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# the ACM cache.  This option is only valid if addr_preload\n");
 	fprintf(f, "# indicates that address data should be read from a file.\n");
 	fprintf(f, "# Default is %s/ibacm_hosts.data\n", ACM_CONF_DIR);
-	fprintf(f, "# addr_data_file /etc/rdma/ibacm_hosts.data\n");
+	fprintf(f, "# addr_data_file %s/ibacm_hosts.data\n", ACM_CONF_DIR);
 	fprintf(f, "\n");
 	fprintf(f, "# support_ips_in_addr_cfg:\n");
 	fprintf(f, "# If 1 continue to read IP addresses from ibacm_addr.cfg\n");
diff --git a/ibacm/src/libacm.c b/ibacm/src/libacm.c
index 95e562deb031..3ad1db1d307b 100644
--- a/ibacm/src/libacm.c
+++ b/ibacm/src/libacm.c
@@ -48,7 +48,7 @@ static void acm_set_server_port(void)
 {
 	FILE *f;
 
-	if ((f = fopen("/var/run/ibacm.port", "r"))) {
+	if ((f = fopen(IBACM_PORT_FILE, "r"))) {
 		if (fscanf(f, "%hu", (unsigned short *) &server_port) != 1) 
 			printf("Failed to read server port\n"); 
 		fclose(f);
diff --git a/iwpmd/src/iwarp_pm.h b/iwpmd/src/iwarp_pm.h
index bcf88ca30433..5b7c6136f386 100644
--- a/iwpmd/src/iwarp_pm.h
+++ b/iwpmd/src/iwarp_pm.h
@@ -85,7 +85,6 @@
 #define IWPM_IFNAME_SIZE   16
 #define IWPM_IPADDR_SIZE   16
 
-#define IWPM_CONFIG_FILE "/etc/iwpmd.conf"
 #define IWPM_PARAM_NUM 1
 #define IWPM_PARAM_NAME_LEN 64
 
diff --git a/iwpmd/src/iwarp_pm_server.c b/iwpmd/src/iwarp_pm_server.c
index e1c2a9c660bb..39e0aa2c3a36 100644
--- a/iwpmd/src/iwarp_pm_server.c
+++ b/iwpmd/src/iwarp_pm_server.c
@@ -31,6 +31,7 @@
  *
  */
 
+#include "config.h"
 #include "iwarp_pm.h"
 
 const char iwpm_ulib_name [] = "iWarpPortMapperUser";
diff --git a/librdmacm/src/acm.c b/librdmacm/src/acm.c
index f0da01e6d286..75d9d8cf487e 100644
--- a/librdmacm/src/acm.c
+++ b/librdmacm/src/acm.c
@@ -120,7 +120,7 @@ static int ucma_set_server_port(void)
 {
 	FILE *f;
 
-	if ((f = fopen("/var/run/ibacm.port", "r" STREAM_CLOEXEC))) {
+	if ((f = fopen(IBACM_PORT_FILE, "r" STREAM_CLOEXEC))) {
 		fscanf(f, "%" SCNu16, &server_port);
 		fclose(f);
 	}
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index 98eba8dc21e1..091d104655c5 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -179,13 +179,4 @@ struct ib_connect_hdr {
 #define cma_dst_ip6 dst_addr[0]
 };
 
-#ifndef SYSCONFDIR
-#define SYSCONFDIR "/etc"
-#endif
-#ifndef RDMADIR
-#define RDMADIR "rdma"
-#endif
-#define RDMA_CONF_DIR  SYSCONFDIR "/" RDMADIR
-#define RS_CONF_DIR RDMA_CONF_DIR "/rsocket"
-
 #endif /* CMA_H */
diff --git a/srp_daemon/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon/srp_daemon.c
index dfc976b8f6db..70764e00f851 100644
--- a/srp_daemon/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon/srp_daemon.c
@@ -226,7 +226,7 @@ static void usage(const char *argv0)
 	fprintf(stderr, "-R <rescan time>	perform complete Rescan every <rescan time> seconds\n");
 	fprintf(stderr, "-T <retry timeout>	Retries to connect to existing target after Timeout of <retry timeout> seconds\n");
 	fprintf(stderr, "-l <tl_retry timeout>	Transport retry count before failing IO. should be in range [2..7], (default 2)\n");
-	fprintf(stderr, "-f <rules file>	use rules File to set to which target(s) to connect (default: /etc/srp_daemon.conf\n");
+	fprintf(stderr, "-f <rules file>	use rules File to set to which target(s) to connect (default: " SRP_DEAMON_CONFIG_FILE ")\n");
 	fprintf(stderr, "-t <timeout>		Timeout for mad response in milliseconds\n");
 	fprintf(stderr, "-r <retries>		number of send Retries for each mad\n");
 	fprintf(stderr, "-n 			New connection command format - use also initiator extension\n");
@@ -1622,7 +1622,7 @@ static int get_config(struct config_t *conf, int argc, char *argv[])
 	conf->retry_timeout 		= 20;
 	conf->add_target_file  		= NULL;
 	conf->print_initiator_ext	= 0;
-	conf->rules_file		= "/etc/srp_daemon.conf";
+	conf->rules_file		= SRP_DEAMON_CONFIG_FILE;
 	conf->rules			= NULL;
 	conf->tl_retry_count		= 0;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
