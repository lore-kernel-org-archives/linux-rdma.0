From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 04/10] Do not use kernel byteswap macros
Date: Thu,  9 Feb 2017 14:53:26 -0700
Message-ID: <1486677212-3188-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These days the version in glibc's endian.h is just as good, since
gcc 4.3 (we support no earlier compiler) this just boils down to
__builtin_bswap which is a constant expression if the input is constant.

Done via

$ git ls-files | xargs sed -i -e 's/__constant_cpu_to_be64/htobe64/g'
$ git ls-files | xargs sed -i -e 's/__cpu_to_be64/htobe64/g'
$ git ls-files | xargs sed -i -e 's/__be64_to_cpu/be64toh/g'

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/iwarp_pm_common.c   | 5 +++--
 libibcm/cm.h              | 6 +++---
 libibcm/examples/cmpost.c | 7 +++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index 941e0406ade787..569d53531652aa 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -32,6 +32,7 @@
  */
 
 #include "iwarp_pm.h"
+#include <endian.h>
 
 /* iwpm config params */
 static const char * iwpm_param_names[IWPM_PARAM_NUM] =
@@ -380,7 +381,7 @@ int parse_iwpm_msg(iwpm_wire_msg *pm_msg, iwpm_msg_parms *msg_parms)
 	int ret_value = 0;
 
 	msg_parms->pmtime = pm_msg->pmtime;
-	msg_parms->assochandle = __be64_to_cpu(pm_msg->assochandle);
+	msg_parms->assochandle = be64toh(pm_msg->assochandle);
 	msg_parms->ip_ver = (pm_msg->magic & IWARP_PM_IPVER_MASK) >> IWARP_PM_IPVER_SHIFT;
 	switch (msg_parms->ip_ver) {
 	case 4:
@@ -420,7 +421,7 @@ static void form_iwpm_msg(iwpm_wire_msg *pm_msg, iwpm_msg_parms *msg_parms)
 {
 	memset(pm_msg, 0, sizeof(struct iwpm_wire_msg));
 	pm_msg->pmtime = msg_parms->pmtime;
-	pm_msg->assochandle = __cpu_to_be64(msg_parms->assochandle);
+	pm_msg->assochandle = htobe64(msg_parms->assochandle);
 	/* record IP version, port mapper version, message type */
 	pm_msg->magic = (msg_parms->ip_ver << IWARP_PM_IPVER_SHIFT) & IWARP_PM_IPVER_MASK;
 	pm_msg->magic |= (msg_parms->ver << IWARP_PM_VER_SHIFT) & IWARP_PM_VER_MASK;
diff --git a/libibcm/cm.h b/libibcm/cm.h
index e5e2b5e78c5032..6305e8236a3903 100644
--- a/libibcm/cm.h
+++ b/libibcm/cm.h
@@ -38,7 +38,7 @@
 
 #include <infiniband/verbs.h>
 #include <infiniband/sa.h>
-#include <asm/byteorder.h>
+#include <endian.h>
 
 #ifdef __cplusplus
 extern "C" {
@@ -325,8 +325,8 @@ struct ib_cm_attr_param {
 int ib_cm_attr_id(struct ib_cm_id *cm_id,
 		  struct ib_cm_attr_param *param);
 
-#define IB_CM_ASSIGN_SERVICE_ID_MASK __constant_cpu_to_be64(0xFF00000000000000ULL)
-#define IB_CM_ASSIGN_SERVICE_ID      __constant_cpu_to_be64(0x0200000000000000ULL)
+#define IB_CM_ASSIGN_SERVICE_ID_MASK htobe64(0xFF00000000000000ULL)
+#define IB_CM_ASSIGN_SERVICE_ID      htobe64(0x0200000000000000ULL)
 
 /**
  * ib_cm_listen - Initiates listening on the specified service ID for
diff --git a/libibcm/examples/cmpost.c b/libibcm/examples/cmpost.c
index f7833f5223185b..d27bdc9c1bf9f3 100644
--- a/libibcm/examples/cmpost.c
+++ b/libibcm/examples/cmpost.c
@@ -37,9 +37,8 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netdb.h>
-#include <byteswap.h>
+#include <endian.h>
 
-#include <asm/byteorder.h>
 #include <netinet/in.h>
 
 #include <infiniband/cm.h>
@@ -585,7 +584,7 @@ static void run_server(void)
 		printf("listen request failed\n");
 		return;
 	}
-	ret = ib_cm_listen(listen_id, __cpu_to_be64(0x1000), 0);
+	ret = ib_cm_listen(listen_id, htobe64(0x1000), 0);
 	if (ret) {
 		printf("failure trying to listen: %d\n", ret);
 		goto out;
@@ -702,7 +701,7 @@ static void run_client(char *dst)
 
 	memset(&req, 0, sizeof req);
 	req.primary_path = &test.path_rec;
-	req.service_id = __cpu_to_be64(0x1000);
+	req.service_id = htobe64(0x1000);
 
 	/*
 	 * When choosing the responder resources for a ULP, it is usually
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
