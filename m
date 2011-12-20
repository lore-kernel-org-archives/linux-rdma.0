From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/25 v2] rdma/ucm: Add ability to query GID addresses
Date: Tue, 20 Dec 2011 21:44:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325661BA8@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Part of address resolution is mapping IP addresses to IB GIDs.
With the changes to support querying larger addresses and more
path records, also provide a way to query IB GIDs after
resolution completes.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |   50 ++++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_user_cm.h    |    3 ++
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 0766011..83208be 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -48,6 +48,7 @@
 #include <rdma/rdma_cm.h>
 #include <rdma/rdma_cm_ib.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("RDMA Userspace Connection Manager Access");
@@ -806,6 +807,52 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
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
@@ -830,6 +877,9 @@ static ssize_t ucma_query(struct ucma_file *file,
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
index effcb75..b0634d4 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -116,7 +116,8 @@ struct rdma_ucm_resolve_route {
 
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
