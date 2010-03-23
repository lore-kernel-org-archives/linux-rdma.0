From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 18/22] [for 2.6.36] rdma/ucm: add ability to query GID addresses
Date: Tue, 23 Mar 2010 11:23:55 -0700
Message-ID: <6AC3F627E54544ED9CE422D9868678A8@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Part of address resolution is mapping IP addresses to IB GIDs.
With the changes to support querying larger addresses and more
path records, also provide a way to query IB GIDs after
resolution completes.

This finishes separating the functionality of 'query route' into
the various components: address, route, and device data.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |   50 ++++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_user_cm.h    |    3 ++
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 86115ec..1c2083e 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -45,6 +45,7 @@
 #include <rdma/rdma_cm.h>
 #include <rdma/rdma_cm_ib.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("RDMA Userspace Connection Manager Access");
@@ -706,6 +707,52 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 	return ret;
 }
 
+static ssize_t ucma_query_gid(struct ucma_context *ctx,
+			      void __user *response, int out_len)
+{
+	struct rdma_ucm_query_addr_resp resp;
+	struct sockaddr_ib *addr;
+	int ret = 0;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	memset(&resp, 0, sizeof resp);
+
+	ucma_query_device_addr(ctx->cm_id, &resp);
+
+	addr = (struct sockaddr_ib *) &resp.src_addr;
+	resp.src_size = sizeof(*addr);
+	if (ctx->cm_id->route.addr.src_addr.ss_family == AF_IB) {
+		memcpy(addr, &ctx->cm_id->route.addr.src_addr, resp.src_size);
+	} else {
+		addr->sib_family = AF_IB;
+		addr->sib_pkey = (__force __be16) resp.pkey;
+		rdma_addr_get_sgid(&ctx->cm_id->route.addr.dev_addr,
+				   (union ib_gid *) &addr->sib_addr);
+		addr->sib_sid = rdma_get_service_id(ctx->cm_id, (struct sockaddr *)
+						    &ctx->cm_id->route.addr.src_addr);
+	}
+
+	addr = (struct sockaddr_ib *) &resp.dst_addr;
+	resp.dst_size = sizeof(*addr);
+	if (ctx->cm_id->route.addr.dst_addr.ss_family == AF_IB) {
+		memcpy(addr, &ctx->cm_id->route.addr.dst_addr, resp.dst_size);
+	} else {
+		addr->sib_family = AF_IB;
+		addr->sib_pkey = (__force __be16) resp.pkey;
+		rdma_addr_get_dgid(&ctx->cm_id->route.addr.dev_addr,
+				   (union ib_gid *) &addr->sib_addr);
+		addr->sib_sid = rdma_get_service_id(ctx->cm_id, (struct sockaddr *)
+						    &ctx->cm_id->route.addr.dst_addr);
+	}
+
+	if (copy_to_user(response, &resp, sizeof(resp)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static ssize_t ucma_query(struct ucma_file *file,
 			  const char __user *inbuf,
 			  int in_len, int out_len)
@@ -730,6 +777,9 @@ static ssize_t ucma_query(struct ucma_file *file,
 	case RDMA_USER_CM_QUERY_PATH:
 		ret = ucma_query_path(ctx, response, out_len);
 		break;
+	case RDMA_USER_CM_QUERY_GID:
+		ret = ucma_query_gid(ctx, response, out_len);
+		break;
 	default:
 		ret = -ENOSYS;
 		break;
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index ee48dde..2534598 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -115,7 +115,8 @@ struct rdma_ucm_resolve_route {
 
 enum {
 	RDMA_USER_CM_QUERY_ADDR,
-	RDMA_USER_CM_QUERY_PATH
+	RDMA_USER_CM_QUERY_PATH,
+	RDMA_USER_CM_QUERY_GID
 };
 
 struct rdma_ucm_query {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
