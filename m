From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Support older acm.h header files
Date: Fri, 18 May 2012 18:49:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A230D7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Older versions of acm.h do not include the resolve_data or
perf_data fields in struct acm_msg.  If we're using an older
version of the acm.h header file, use an internal definition
of struct acm_msg.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.in |    5 +++++
 src/acm.c    |   16 ++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index fa90fcb..dec6064 100644
--- a/configure.in
+++ b/configure.in
@@ -73,6 +73,11 @@ fi
 AC_CHECK_HEADER(infiniband/acm.h, 
 	AC_DEFINE([USE_IB_ACM], 1, [setting IBACM support]), [])
 
+AC_CHECK_HEADER(infiniband/acm.h,
+	AC_CHECK_MEMBER(struct acm_msg.resolve_data, [],
+		AC_DEFINE(DEFINE_ACM_MSG, 1, [adding ACM message definition]),
+			[#include <infiniband/acm.h>]), [])
+
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
     if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
         ac_cv_version_script=yes
diff --git a/src/acm.c b/src/acm.c
index 7911b41..bcf11da 100755
--- a/src/acm.c
+++ b/src/acm.c
@@ -48,6 +48,18 @@
 #ifdef USE_IB_ACM
 #include <infiniband/acm.h>
 
+#if DEFINE_ACM_MSG
+typedef struct cma_acm_msg {
+	struct acm_hdr                  hdr;
+	union{
+		uint8_t                 data[ACM_MSG_DATA_LENGTH];
+		struct acm_ep_addr_data resolve_data[0];
+	};
+} cma_acm_msg_t;
+#else
+typedef struct acm_msg cma_acm_msg_t;
+#endif
+
 static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
 static int sock;
 static short server_port = 6125;
@@ -237,7 +249,7 @@ err:
 	rdma_freeaddrinfo(ib_rai);
 }
 
-static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_msg *msg)
+static void ucma_ib_save_resp(struct rdma_addrinfo *rai, cma_acm_msg_t *msg)
 {
 	struct acm_ep_addr_data *ep_data;
 	struct ibv_path_data *path_data = NULL;
@@ -306,7 +318,7 @@ static void ucma_copy_rai_addr(struct acm_ep_addr_data *data, struct sockaddr *a
 
 void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints)
 {
-	struct acm_msg msg;
+	cma_acm_msg_t msg;
 	struct acm_ep_addr_data *data;
 	int ret;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
