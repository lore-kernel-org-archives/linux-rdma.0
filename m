From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Mon, 5 Oct 2009 10:45:15 -0700
Message-ID: <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F0EFC2D8E6A340D48497497670C5969C-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide an option for user's to manually specify the socket address
to DGID mapping on InfiniBand.  Currently, all mappings are done
using ipoib, and involve ARP.  This will not work across IP subnets,
and alternative mechanisms of resolving the mapping are being explored.
The latter can be more efficient if combined with route resolution
as well.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c  |   15 +++++++++++++++
 drivers/infiniband/core/ucma.c |   23 +++++++++++++++++++++++
 include/rdma/rdma_cm_ib.h      |   14 ++++++++++++++
 include/rdma/rdma_user_cm.h    |    6 ++++++
 4 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0753178..9adf8fb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1919,6 +1919,21 @@ err:
 }
 EXPORT_SYMBOL(rdma_resolve_addr);
 
+int rdma_set_ib_dest(struct rdma_cm_id *id, struct sockaddr *dst_addr,
+		     union ib_gid *dgid)
+{
+	struct rdma_id_private *id_priv;
+
+	id_priv = container_of(id, struct rdma_id_private, id);
+	if (!cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_ADDR_RESOLVED))
+		return -EINVAL;
+
+	memcpy(&id->route.addr.dst_addr, dst_addr, ip_addr_size(dst_addr));
+	ib_addr_set_dgid(&id->route.addr.dev_addr, dgid);
+	return 0;
+}
+EXPORT_SYMBOL(rdma_set_ib_dest);
+
 static void cma_bind_port(struct rdma_bind_list *bind_list,
 			  struct rdma_id_private *id_priv)
 {
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 1359727..3a252e6 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -832,12 +832,35 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
 	return ucma_event_handler(ctx->cm_id, &event);
 }
 
+static int ucma_set_ib_dest(struct ucma_context *ctx,
+			    struct rdma_ucm_ib_dest *ib_dest, size_t optlen)
+{
+	union ib_gid dgid;
+	struct rdma_cm_event event;
+	int ret;
+
+	if (optlen < sizeof(*ib_dest))
+		return -EINVAL;
+
+	memcpy(&dgid, ib_dest->dgid, sizeof dgid);
+	ret = rdma_set_ib_dest(ctx->cm_id, (struct sockaddr *) &ib_dest->dst_addr, &dgid);
+	if (ret)
+		return ret;
+
+	memset(&event, 0, sizeof event);
+	event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
+	return ucma_event_handler(ctx->cm_id, &event);
+}
+
 static int ucma_set_option_ib(struct ucma_context *ctx, int optname,
 			      void *optval, size_t optlen)
 {
 	int ret;
 
 	switch (optname) {
+	case RDMA_OPTION_IB_DEST:
+		ret = ucma_set_ib_dest(ctx, optval, optlen);
+		break;
 	case RDMA_OPTION_IB_PATH:
 		ret = ucma_set_ib_path(ctx, optval, optlen);
 		break;
diff --git a/include/rdma/rdma_cm_ib.h b/include/rdma/rdma_cm_ib.h
index 2389c3b..7326d35 100644
--- a/include/rdma/rdma_cm_ib.h
+++ b/include/rdma/rdma_cm_ib.h
@@ -48,6 +48,20 @@
 int rdma_set_ib_paths(struct rdma_cm_id *id,
 		      struct ib_sa_path_rec *path_rec, int num_paths);
 
+/**
+ * rdma_set_ib_dest - Manually set the destination address
+ * @id: Connection identifier associated with the request.
+ * @dst_addr: Destination address information.
+ * @dgid: Destination device address information.
+ *
+ * This call allows the user to specify address mappings for rdma_cm_id's
+ * bound to an Infiniband device.  It is called on the client side of a
+ * connection and combined with rdma_bind_addr, replaces the call to
+ * rdma_resolve_addr.
+ */
+int rdma_set_ib_dest(struct rdma_cm_id *id, struct sockaddr *dst_addr,
+		     union ib_gid *dgid);
+
 /* Global qkey for UDP QPs and multicast groups. */
 #define RDMA_UDP_QKEY 0x01234567
 
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index d7829f4..a908b89 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -223,6 +223,7 @@ enum {
 enum {
 	RDMA_OPTION_ID_TOS	= 0,
 
+	RDMA_OPTION_IB_DEST	= 0,
 	RDMA_OPTION_IB_PATH	= 1
 };
 
@@ -234,6 +235,11 @@ struct rdma_ucm_set_option {
 	__u32 optlen;
 };
 
+struct rdma_ucm_ib_dest {
+	__u8 dgid[16];
+	struct sockaddr_in6 dst_addr;
+};
+
 struct rdma_ucm_migrate_id {
 	__u64 response;
 	__u32 id;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
