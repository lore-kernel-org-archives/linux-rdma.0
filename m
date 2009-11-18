From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: add support for IB ACM
Date: Tue, 17 Nov 2009 16:12:04 -0800
Message-ID: <1D7E664969C641BFB0CBD884C816EA19@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow librdmacm to use the IB ACM to resolve remote address and
path record data.  IB ACM support should be considered experimental
and is enabled through the use of a build setting and a runtime
environment variable.  When IB ACM has had sufficient testing and
further development these restrictions can be removed.

When IB ACM support is enabled, the librdmacm will make use of the
libibacm to resolve Infiniband path record.  Path record data is
given to the kernel using the rdma_set_ib_paths interface which is
queued for 2.6.33.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
The IB ACM service interface aligns with the user to kernel RDMA CM
interface. The path record output from IB ACM can now be provided
directly into rdma_set_option(..RDMA_OPTION_IB_PATH..).

Eventually, libibacm can go away, with librdmacm using the IB ACM socket
interface directly, after it matures a little more.

 configure.in            |   20 ++++++++++
 include/rdma/rdma_cma.h |    6 ++-
 src/cma.c               |   92 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/configure.in b/configure.in
index 0dfd666..1c4b56d 100644
--- a/configure.in
+++ b/configure.in
@@ -21,6 +21,15 @@ if test "$with_valgrind" != "" && test "$with_valgrind" != "no"; then
 	fi
 fi
 
+AC_ARG_WITH([ib_acm],
+    AC_HELP_STRING([--with-ib_acm],
+		   [Use IB ACM for route resolution - default NO]))
+
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+	AC_DEFINE([USE_IB_ACM], 1,
+		  [Define to 1 to use IB ACM for endpoint resolution])
+fi
+
 AC_ARG_ENABLE(libcheck, [  --disable-libcheck      do not test for presence of ib libraries],
 [       if test "$enableval" = "no"; then
                 disable_libcheck=yes
@@ -38,6 +47,12 @@ dnl Checks for libraries
 if test "$disable_libcheck" != "yes"; then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  librdmacm requires libibverbs.]))
+
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+AC_CHECK_LIB(ibacm, ib_acm_resolve_ip, [],
+    AC_MSG_ERROR([ib_acm_resolve_ip() not found. build options requres libibacm.]))
+fi
+
 fi
 
 dnl Checks for header files.
@@ -51,6 +66,11 @@ AC_CHECK_HEADER(valgrind/memcheck.h, [],
     AC_MSG_ERROR([valgrind requested but <valgrind/memcheck.h> not found.]))
 fi
 
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+AC_CHECK_HEADER(infiniband/ib_acm.h, [],
+    AC_MSG_ERROR([IB ACM requested but <infiniband/ib_acm.h> not found.]))
+fi
+
 fi
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 534489d..f755551 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -547,12 +547,14 @@ const char *rdma_event_str(enum rdma_cm_event_type event);
 
 /* Option levels */
 enum {
-	RDMA_OPTION_ID		= 0
+	RDMA_OPTION_ID		= 0,
+	RDMA_OPTION_IB		= 1
 };
 
 /* Option details */
 enum {
-	RDMA_OPTION_ID_TOS	= 0	/* uint8_t: RFC 2474 */
+	RDMA_OPTION_ID_TOS	= 0,	/* uint8_t: RFC 2474 */
+	RDMA_OPTION_IB_PATH	= 1	/* ib_path_rec_data/ib_acm_path_data */
 };
 
 /**
diff --git a/src/cma.c b/src/cma.c
index efad6ae..73e8f26 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -66,6 +66,10 @@
 #   define VALGRIND_MAKE_MEM_DEFINED(addr,len)
 #endif
 
+#ifdef USE_IB_ACM
+#include <infiniband/ib_acm.h>
+#endif
+
 #define PFX "librdmacm: "
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -160,6 +164,7 @@ static struct cma_device *cma_dev_array;
 static int cma_dev_cnt;
 static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
 static int abi_ver = RDMA_USER_CM_MAX_ABI_VERSION;
+static int use_ib_acm;
 
 #define container_of(ptr, type, field) \
 	((type *) ((void *)ptr - offsetof(type, field)))
@@ -206,6 +211,21 @@ static int check_abi_version(void)
 	return 0;
 }
 
+static void ucma_getenv(void)
+{
+	char *val;
+
+	val = getenv("RDMA_CM_USE_IB_ACM");
+	if (!val) {
+		val = getenv("rdma_cm_use_ib_acm");
+		if (!val) {
+			return;
+		}
+	}
+
+	use_ib_acm = atoi(val);
+}
+
 static int ucma_init(void)
 {
 	struct ibv_device **dev_list = NULL;
@@ -259,6 +279,7 @@ static int ucma_init(void)
 		cma_dev->max_responder_resources = (uint8_t) attr.max_qp_rd_atom;
 	}
 
+	ucma_getenv();
 	cma_dev_cnt = dev_cnt;
 	pthread_mutex_unlock(&mut);
 	ibv_free_device_list(dev_list);
@@ -491,7 +512,7 @@ static int ucma_query_route(struct rdma_cm_id *id)
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
-	if (resp->num_paths) {
+	if (resp->num_paths && !id->route.path_rec) {
 		id->route.path_rec = malloc(sizeof *id->route.path_rec *
 					    resp->num_paths);
 		if (!id->route.path_rec)
@@ -546,6 +567,71 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	return ucma_query_route(id);
 }
 
+#ifdef USE_IB_ACM
+static int ucma_acm_save_path(struct rdma_cm_id *id, struct ib_path_record *path)
+{
+	struct ibv_sa_path_rec *sa_path;
+
+	id->route.path_rec = malloc(sizeof *id->route.path_rec);
+	if (!id->route.path_rec)
+		return -ENOMEM;
+
+	memset(id->route.path_rec, 0, sizeof *id->route.path_rec);
+	id->route.num_paths = 1;
+
+	sa_path = id->route.path_rec;
+	memcpy(&sa_path->dgid, &path->dgid, sizeof path->dgid);
+	memcpy(&sa_path->sgid, &path->sgid, sizeof path->sgid);
+	sa_path->dlid = path->dlid;
+	sa_path->slid = path->slid;
+	sa_path->flow_label = htonl((ntohl(path->flowlabel_hoplimit) >> 8) & 0xFFFFF);
+	sa_path->hop_limit = (uint8_t) ntohl(path->flowlabel_hoplimit);
+	sa_path->traffic_class = path->tclass;
+	sa_path->reversible = 1;
+	sa_path->numb_path = 1;
+	sa_path->pkey = path->pkey;
+	sa_path->sl = (uint8_t) ntohs(path->qosclass_sl) & 0xF;
+	sa_path->mtu_selector = path->mtu >> 6;
+	sa_path->mtu = path->mtu & 0x1F;
+	sa_path->rate_selector = path->rate >> 6;
+	sa_path->rate = path->rate & 0x1F;
+	sa_path->packet_life_time_selector = path->packetlifetime >> 6;
+	sa_path->packet_life_time = path->packetlifetime & 0x1F;
+
+	return 0;
+}
+
+static int ucma_acm_resolve_route(struct rdma_cm_id *id)
+{
+	struct ib_acm_path_data *paths;
+	struct ib_acm_cm_data data;
+	int ret, count;
+
+	if (!use_ib_acm)
+		return -1;
+
+	ret = ib_acm_resolve_ip(&id->route.addr.src_addr, &id->route.addr.dst_addr,
+				&paths, &count, &data);
+	if (ret)
+		return ret;
+
+	ret = ucma_acm_save_path(id, &paths[0].path);
+	if (ret)
+		goto free;
+
+	ret = rdma_set_option(id, RDMA_OPTION_IB, RDMA_OPTION_IB_PATH,
+			      paths, sizeof(*paths) * count);
+free:
+	ib_acm_free_paths(paths);
+	return ret;
+}
+#else
+static int ucma_acm_resolve_route(struct rdma_cm_id *id)
+{
+	return -1;
+}
+#endif
+
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		      struct sockaddr *dst_addr, int timeout_ms)
 {
@@ -581,6 +667,10 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	void *msg;
 	int ret, size;
 	
+	ret = ucma_acm_resolve_route(id);
+	if (!ret)
+		return 0;
+
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ROUTE, size);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
