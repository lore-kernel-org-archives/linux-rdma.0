From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/8] Enable -Wwrite-strings
Date: Fri, 14 Oct 2016 16:14:11 -0600
Message-ID: <1476483257-16308-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The is useful to detect possible writing to read only memory.

The compiler places strings in .rodata so they are unwritable and
are technically const.

Add consts as necessary, no casts were added so this should be safe.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                      |  1 +
 ibacm/include/infiniband/acm_prov.h |  4 ++--
 ibacm/prov/acmp/src/acmp.c          |  2 +-
 ibacm/src/acm.c                     |  8 ++++----
 ibacm/src/acm_util.h                |  2 +-
 ibacm/src/acme.c                    |  8 ++++----
 ibacm/src/parse.c                   |  2 +-
 iwpmd/iwarp_pm.h                    |  2 +-
 iwpmd/iwarp_pm_common.c             |  7 ++++---
 libibverbs/sysfs.c                  | 13 +++++++------
 librdmacm/examples/cmatose.c        |  2 +-
 librdmacm/examples/cmtime.c         |  4 ++--
 librdmacm/examples/common.c         |  2 +-
 librdmacm/examples/common.h         |  2 +-
 librdmacm/examples/rcopy.c          |  2 +-
 librdmacm/examples/rdma_client.c    |  4 ++--
 librdmacm/examples/rdma_server.c    |  2 +-
 librdmacm/examples/rdma_xclient.c   |  2 +-
 librdmacm/examples/rdma_xserver.c   |  2 +-
 librdmacm/examples/riostream.c      |  2 +-
 librdmacm/examples/rping.c          |  2 +-
 librdmacm/examples/rstream.c        |  2 +-
 librdmacm/examples/udaddy.c         |  2 +-
 librdmacm/examples/udpong.c         |  2 +-
 srp_daemon/srp_daemon.c             | 29 +++++++++++++++++------------
 srp_daemon/srp_daemon.h             |  2 +-
 26 files changed, 60 insertions(+), 52 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 21a93892c858..bede766adf4d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -112,6 +112,7 @@ RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WARNINGS
   "-Wall -Wextra -Wno-sign-compare -Wno-unused-parameter")
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WMISSING_PROTOTYPES "-Wmissing-prototypes")
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WMISSING_DECLARATIONS "-Wmissing-declarations")
+RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WWRITE_STRINGS "-Wwrite-strings")
 
 # At some point around 5.4 gcc fixed missing-field-initializers to ignore this
 # common idiom we use extensively. Since this is a useful warning for
diff --git a/ibacm/include/infiniband/acm_prov.h b/ibacm/include/infiniband/acm_prov.h
index 890e6baeb5e8..00baf582b74e 100644
--- a/ibacm/include/infiniband/acm_prov.h
+++ b/ibacm/include/infiniband/acm_prov.h
@@ -61,7 +61,7 @@ struct acm_address {
 struct acm_provider {
 	size_t    size; 
 	uint32_t  version;
-	char      *name;
+	const char *name;
 	int	(*open_device)(const struct acm_device *device, 
 			void **dev_context);
 	void	(*close_device)(void *dev_context);
@@ -113,7 +113,7 @@ acm_alloc_sa_mad(const struct acm_endpoint *endpoint, void *context,
 extern void acm_free_sa_mad(struct acm_sa_mad *mad);
 extern int acm_send_sa_mad(struct acm_sa_mad *mad);
 
-extern char * acm_get_opts_file(void);
+extern const char *acm_get_opts_file(void);
 extern void acm_increment_counter(int type);
 
 #endif /* ACM_PROV_H */
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index d70501aff8e8..9ec7db44b0d1 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2868,7 +2868,7 @@ static void acmp_set_options(void)
 	FILE *f;
 	char s[120];
 	char opt[32], value[256];
-	char *opts_file = acm_get_opts_file();
+	const char *opts_file = acm_get_opts_file();
 
 	if (!(f = fopen(opts_file, "r")))
 		return;
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 9186677fcc6f..e512939dd765 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -221,9 +221,9 @@ static struct sa_data {
 /*
  * Service options - may be set through ibacm_opts.cfg file.
  */
-static char *acme = IBACM_BIN_PATH "/ib_acme -A";
-static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
-static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
+static const char *acme = IBACM_BIN_PATH "/ib_acme -A";
+static const char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
+static const char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
 static char log_file[128] = IBACM_LOG_FILE;
 static int log_level = 0;
 static char lock_file[128] = IBACM_PID_FILE;
@@ -292,7 +292,7 @@ int ib_any_gid(union ibv_gid *gid)
 	return ((gid->global.subnet_prefix | gid->global.interface_id) == 0);
 }
 
-char * acm_get_opts_file(void)
+const char *acm_get_opts_file(void)
 {
 	return opts_file;
 }
diff --git a/ibacm/src/acm_util.h b/ibacm/src/acm_util.h
index 5243f8a7e750..055122cbeb86 100644
--- a/ibacm/src/acm_util.h
+++ b/ibacm/src/acm_util.h
@@ -53,6 +53,6 @@ typedef void (*acm_if_iter_cb)(char *ifname, union ibv_gid *gid, uint16_t pkey,
 				char *ip_str, void *ctx);
 int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx);
 
-char **parse(char *args, int *count);
+char **parse(const char *args, int *count);
 
 #endif /* ACM_IF_H */
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index 6b5b2ecb7f8a..a924dad21089 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -44,13 +44,13 @@
 #include "libacm.h"
 #include "acm_util.h"
 
-static char *dest_dir = ACM_CONF_DIR;
-static char *addr_file = ACM_ADDR_FILE;
-static char *opts_file = ACM_OPTS_FILE;
+static const char *dest_dir = ACM_CONF_DIR;
+static const char *addr_file = ACM_ADDR_FILE;
+static const char *opts_file = ACM_OPTS_FILE;
 
 static char *dest_addr;
 static char *src_addr;
-static char *svc_arg = "localhost";
+static const char *svc_arg = "localhost";
 static char *dest_arg;
 static char *src_arg;
 static char addr_type = 'u';
diff --git a/ibacm/src/parse.c b/ibacm/src/parse.c
index 52e66ab814e3..15aab17f8b0a 100644
--- a/ibacm/src/parse.c
+++ b/ibacm/src/parse.c
@@ -70,7 +70,7 @@ static char *expand(char *basename, char *args, int *str_cnt, int *str_size)
 	return str_buf;
 }
 
-char **parse(char *args, int *count)
+char **parse(const char *args, int *count)
 {
 	char **ptrs = NULL;
 	char *str_buf, *cpy, *token, *next;
diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index 766e34fe03c7..b5a5a457a423 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -225,7 +225,7 @@ int send_iwpm_nlmsg(int, struct nl_msg *, int);
 
 struct nl_msg *create_iwpm_nlmsg(__u16, int);
 
-void print_iwpm_sockaddr(struct sockaddr_storage *, char *, __u32);
+void print_iwpm_sockaddr(struct sockaddr_storage *, const char *, __u32);
 
 __be16 get_sockaddr_port(struct sockaddr_storage *sockaddr);
 
diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index ee9d11953018..58b1089a1998 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -39,7 +39,7 @@
 #endif
 
 /* iwpm config params */
-static char * iwpm_param_names[IWPM_PARAM_NUM] =
+static const char * iwpm_param_names[IWPM_PARAM_NUM] =
 	{ "nl_sock_rbuf_size" };
 static int iwpm_param_vals[IWPM_PARAM_NUM] =
 	{ 0 };
@@ -609,8 +609,9 @@ int is_wcard_ipaddr(struct sockaddr_storage *search_addr)
  * print_iwpm_sockaddr - Print socket address (IP address and Port)
  * @sockaddr: socket address to print
  * @msg: message to print
- */ 
-void print_iwpm_sockaddr(struct sockaddr_storage *sockaddr, char *msg, __u32 dbg_flag)
+ */
+void print_iwpm_sockaddr(struct sockaddr_storage *sockaddr, const char *msg,
+			 __u32 dbg_flag)
 {
 	struct sockaddr_in6 *sockaddr_v6;
 	struct sockaddr_in *sockaddr_v4;
diff --git a/libibverbs/sysfs.c b/libibverbs/sysfs.c
index d463241ade08..f45fa1a3614d 100644
--- a/libibverbs/sysfs.c
+++ b/libibverbs/sysfs.c
@@ -42,11 +42,11 @@
 
 #include "ibverbs.h"
 
-static char *sysfs_path;
+static const char *sysfs_path;
 
 const char *ibv_get_sysfs_path(void)
 {
-	char *env = NULL;
+	const char *env = NULL;
 
 	if (sysfs_path)
 		return sysfs_path;
@@ -60,12 +60,13 @@ const char *ibv_get_sysfs_path(void)
 
 	if (env) {
 		int len;
+		char *dup;
 
-		sysfs_path = strndup(env, IBV_SYSFS_PATH_MAX);
-		len = strlen(sysfs_path);
-		while (len > 0 && sysfs_path[len - 1] == '/') {
+		sysfs_path = dup = strndup(env, IBV_SYSFS_PATH_MAX);
+		len = strlen(dup);
+		while (len > 0 && dup[len - 1] == '/') {
 			--len;
-			sysfs_path[len] = '\0';
+			dup[len] = '\0';
 		}
 	} else
 		sysfs_path = "/sys";
diff --git a/librdmacm/examples/cmatose.c b/librdmacm/examples/cmatose.c
index d7bd92d72468..d9b6ca622393 100644
--- a/librdmacm/examples/cmatose.c
+++ b/librdmacm/examples/cmatose.c
@@ -75,7 +75,7 @@ static struct cmatest test;
 static int connections = 1;
 static int message_size = 100;
 static int message_count = 10;
-static char *port = "7471";
+static const char *port = "7471";
 static uint8_t set_tos = 0;
 static uint8_t tos;
 static uint8_t migrate = 0;
diff --git a/librdmacm/examples/cmtime.c b/librdmacm/examples/cmtime.c
index f0b4d0276288..b2a39cedd303 100644
--- a/librdmacm/examples/cmtime.c
+++ b/librdmacm/examples/cmtime.c
@@ -48,7 +48,7 @@
 
 static struct rdma_addrinfo hints, *rai;
 static struct rdma_event_channel *channel;
-static char *port = "7471";
+static const char *port = "7471";
 static char *dst_addr;
 static char *src_addr;
 static int timeout = 2000;
@@ -66,7 +66,7 @@ enum step {
 	STEP_CNT
 };
 
-static char *step_str[] = {
+static const char *step_str[] = {
 	"create id",
 	"bind addr",
 	"resolve addr",
diff --git a/librdmacm/examples/common.c b/librdmacm/examples/common.c
index 09468ce6a03c..8037dd830fa8 100644
--- a/librdmacm/examples/common.c
+++ b/librdmacm/examples/common.c
@@ -47,7 +47,7 @@
 
 int use_rs = 1;
 
-int get_rdma_addr(char *src, char *dst, char *port,
+int get_rdma_addr(const char *src, const char *dst, const char *port,
 		  struct rdma_addrinfo *hints, struct rdma_addrinfo **rai)
 {
 	struct rdma_addrinfo rai_hints, *res;
diff --git a/librdmacm/examples/common.h b/librdmacm/examples/common.h
index ac2d160b0044..28b977a075e6 100644
--- a/librdmacm/examples/common.h
+++ b/librdmacm/examples/common.h
@@ -78,7 +78,7 @@ enum rs_optimization {
 	opt_bandwidth
 };
 
-int get_rdma_addr(char *src, char *dst, char *port,
+int get_rdma_addr(const char *src, const char *dst, const char *port,
 		  struct rdma_addrinfo *hints, struct rdma_addrinfo **rai);
 
 void size_str(char *str, size_t ssize, long long size);
diff --git a/librdmacm/examples/rcopy.c b/librdmacm/examples/rcopy.c
index 38f69291b1f5..9ff7ade29261 100644
--- a/librdmacm/examples/rcopy.c
+++ b/librdmacm/examples/rcopy.c
@@ -52,7 +52,7 @@ union rsocket_address {
 	struct sockaddr_storage storage;
 };
 
-static char *port = "7427";
+static const char *port = "7427";
 static char *dst_addr;
 static char *dst_file;
 static char *src_file;
diff --git a/librdmacm/examples/rdma_client.c b/librdmacm/examples/rdma_client.c
index fd7bbc20aa6a..c27047c5124f 100644
--- a/librdmacm/examples/rdma_client.c
+++ b/librdmacm/examples/rdma_client.c
@@ -36,8 +36,8 @@
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
 
-static char *server = "127.0.0.1";
-static char *port = "7471";
+static const char *server = "127.0.0.1";
+static const char *port = "7471";
 
 static struct rdma_cm_id *id;
 static struct ibv_mr *mr, *send_mr;
diff --git a/librdmacm/examples/rdma_server.c b/librdmacm/examples/rdma_server.c
index 3c7c15e0d318..bcf649febf5f 100644
--- a/librdmacm/examples/rdma_server.c
+++ b/librdmacm/examples/rdma_server.c
@@ -36,7 +36,7 @@
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
 
-static char *port = "7471";
+static const char *port = "7471";
 
 static struct rdma_cm_id *listen_id, *id;
 static struct ibv_mr *mr, *send_mr;
diff --git a/librdmacm/examples/rdma_xclient.c b/librdmacm/examples/rdma_xclient.c
index d86fee1b01ee..3518db95442b 100644
--- a/librdmacm/examples/rdma_xclient.c
+++ b/librdmacm/examples/rdma_xclient.c
@@ -37,7 +37,7 @@
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
 
-static char *server = "127.0.0.1";
+static const char *server = "127.0.0.1";
 static char port[6] = "7471";
 
 static struct rdma_cm_id *id;
diff --git a/librdmacm/examples/rdma_xserver.c b/librdmacm/examples/rdma_xserver.c
index f838e7d5de8b..2fbb4bf5b339 100644
--- a/librdmacm/examples/rdma_xserver.c
+++ b/librdmacm/examples/rdma_xserver.c
@@ -38,7 +38,7 @@
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
 
-static char *port = "7471";
+static const char *port = "7471";
 
 static struct rdma_cm_id *listen_id, *id;
 static struct ibv_mr *mr;
diff --git a/librdmacm/examples/riostream.c b/librdmacm/examples/riostream.c
index bdc1eec04ae8..bd8c60cdcb1d 100644
--- a/librdmacm/examples/riostream.c
+++ b/librdmacm/examples/riostream.c
@@ -88,7 +88,7 @@ static int transfer_size = 1000;
 static int transfer_count = 1000;
 static int buffer_size, inline_size = 64;
 static char test_name[10] = "custom";
-static char *port = "7471";
+static const char *port = "7471";
 static char *dst_addr;
 static char *src_addr;
 static struct timeval start, end;
diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
index c248e66aaa83..ad38f6da7096 100644
--- a/librdmacm/examples/rping.c
+++ b/librdmacm/examples/rping.c
@@ -1138,7 +1138,7 @@ static int get_addr(char *dst, struct sockaddr *addr)
 	return ret;
 }
 
-static void usage(char *name)
+static void usage(const char *name)
 {
 	printf("%s -s [-vVd] [-S size] [-C count] [-a addr] [-p port]\n", 
 	       basename(name));
diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 98b9d3f91ecb..59a0d4351ef5 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -90,7 +90,7 @@ static int transfer_size = 1000;
 static int transfer_count = 1000;
 static int buffer_size, inline_size = 64;
 static char test_name[10] = "custom";
-static char *port = "7471";
+static const char *port = "7471";
 static int keepalive;
 static char *dst_addr;
 static char *src_addr;
diff --git a/librdmacm/examples/udaddy.c b/librdmacm/examples/udaddy.c
index 5e89ca1e1d75..af0d6f713ed1 100644
--- a/librdmacm/examples/udaddy.c
+++ b/librdmacm/examples/udaddy.c
@@ -72,7 +72,7 @@ static struct cmatest test;
 static int connections = 1;
 static int message_size = 100;
 static int message_count = 10;
-static char *port = "7174";
+static const char *port = "7174";
 static uint8_t set_tos = 0;
 static uint8_t tos;
 static char *dst_addr;
diff --git a/librdmacm/examples/udpong.c b/librdmacm/examples/udpong.c
index 0f44f50e6e88..f8d56073012a 100644
--- a/librdmacm/examples/udpong.c
+++ b/librdmacm/examples/udpong.c
@@ -93,7 +93,7 @@ static int transfer_size = 1000;
 static int transfer_count = 1000;
 static int buffer_size;
 static char test_name[10] = "custom";
-static char *port = "7174";
+static const char *port = "7174";
 static char *dst_addr;
 static char *src_addr;
 static union socket_addr addr;
diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 6cb22e4c3f21..e0e550d81ab3 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -82,7 +82,7 @@ enum log_dest { log_to_syslog, log_to_stderr };
 static int get_lid(struct umad_resources *umad_res, ib_gid_t *gid, uint16_t *lid);
 
 static const int   node_table_response_size = 1 << 18;
-static char *sysfs_path = "/sys";
+static const char *sysfs_path = "/sys";
 static enum log_dest s_log_dest = log_to_syslog;
 static int wakeup_pipe[2] = { -1, -1 };
 
@@ -152,7 +152,7 @@ static int check_process_uniqueness(struct config_t *conf)
 }
 
 static int srpd_sys_read_string(const char *dir_name, const char *file_name,
-			 char *str, int max_len)
+				char *str, int max_len)
 {
 	char path[256], *s;
 	int fd, r;
@@ -177,7 +177,8 @@ static int srpd_sys_read_string(const char *dir_name, const char *file_name,
 	return 0;
 }
 
-static int srpd_sys_read_gid(char *dir_name, char *file_name, uint8_t *gid)
+static int srpd_sys_read_gid(const char *dir_name, const char *file_name,
+			     uint8_t *gid)
 {
 	char buf[64], *str, *s;
 	uint16_t *ugid = (uint16_t *)gid;
@@ -195,7 +196,8 @@ static int srpd_sys_read_gid(char *dir_name, char *file_name, uint8_t *gid)
 	return 0;
 }
 
-static int srpd_sys_read_uint64(char *dir_name, char *file_name, uint64_t *u)
+static int srpd_sys_read_uint64(const char *dir_name, const char *file_name,
+				uint64_t *u)
 {
 	char buf[32];
 	int r;
@@ -234,7 +236,7 @@ static void usage(const char *argv0)
 }
 
 static int
-check_equal_uint64(char *dir_name, char *attr, uint64_t val)
+check_equal_uint64(char *dir_name, const char *attr, uint64_t val)
 {
 	uint64_t attr_value;
 
@@ -245,7 +247,7 @@ check_equal_uint64(char *dir_name, char *attr, uint64_t val)
 }
 
 static int
-check_equal_uint16(char *dir_name, char *attr, uint16_t val)
+check_equal_uint16(char *dir_name, const char *attr, uint16_t val)
 {
 	uint64_t attr_value;
 
@@ -309,7 +311,8 @@ void pr_err(const char *fmt, ...)
 	}
 }
 
-static int check_not_equal_str(char *dir_name, char *attr, char *value)
+static int check_not_equal_str(const char *dir_name, const char *attr,
+			       const char *value)
 {
 	const int MAX_ATTR_STRING_LENGTH=64;
 
@@ -329,7 +332,8 @@ static int check_not_equal_str(char *dir_name, char *attr, char *value)
 	return 0;
 }
 
-static int check_not_equal_int(char *dir_name, char *attr, int value)
+static int check_not_equal_int(const char *dir_name, const char *attr,
+			       int value)
 {
 	const int MAX_ATTR_STRING_LENGTH=64;
 
@@ -654,12 +658,13 @@ static void initialize_sysfs(void)
 	env = getenv("SYSFS_PATH");
 	if (env) {
 		int len;
+		char *dup;
 
-		sysfs_path = strndup(env, 256);
-		len = strlen(sysfs_path);
-		while (len > 0 && sysfs_path[len - 1] == '/') {
+		sysfs_path = dup = strndup(env, 256);
+		len = strlen(dup);
+		while (len > 0 && dup[len - 1] == '/') {
 			--len;
-			sysfs_path[len] = '\0';
+			dup[len] = '\0';
 		}
 	}
 }
diff --git a/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
index 5d42d51e6d1c..d9d92f10f84c 100644
--- a/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon.h
@@ -324,7 +324,7 @@ struct config_t {
 	int		timeout;
 	int		recalc_time;
 	int		print_initiator_ext;
-	char	       *rules_file;
+	const char     *rules_file;
 	struct rule    *rules;
 	int 		retry_timeout;
 	int		tl_retry_count;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
