From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 1/6] IB/core: Introduce and use rdma_create_user_ah
Date: Mon, 16 Oct 2017 08:45:12 +0300
Message-ID: <20171016054517.30643-2-leon@kernel.org>
References: <20171016054517.30643-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054517.30643-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce rdma_create_user_ah API which allows passing udata to
provider driver and additionally which resolves DMAC for RoCE.

ib_resolve_eth_dmac() resolves destination mac address for unicast,
multicast, link local ipv4 mapped ipv6 and ipv6 destination gid entry.
This allows all RoCE provider drivers to avoid duplicating such code.

Such change brings consistency where IB core always resolves dmac and pass
it to RoCE provider drivers for user and kernel consumers, with this
ah_attr->roce.dmac is always an input field for provider drivers.

This uniformity avoids exporting ib_resolve_eth_dmac symbol to providers
or other modules. Therefore its removed as exported symbol at later in
the patch series.

Now uverbs and umad both makes use of rdma_create_user_ah API which
fixes the issue where umad has invalid DMAC for address.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c   |  2 +-
 drivers/infiniband/core/uverbs_cmd.c | 10 +--------
 drivers/infiniband/core/verbs.c      | 40 ++++++++++++++++++++++++++++++++++--
 include/rdma/ib_verbs.h              | 15 ++++++++++++++
 4 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 603acaf91828..4b64dd02e090 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -515,7 +515,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		rdma_ah_set_dgid_raw(&ah_attr, packet->mad.hdr.gid);
 	}
 
-	ah = rdma_create_ah(agent->qp->pd, &ah_attr);
+	ah = rdma_create_user_ah(agent->qp->pd, &ah_attr, NULL);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_up;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 537e5f2cff69..d31e4bc58e9a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2521,7 +2521,6 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct rdma_ah_attr		attr;
 	int ret;
 	struct ib_udata                   udata;
-	u8				*dmac;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -2564,20 +2563,13 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	} else {
 		rdma_ah_set_ah_flags(&attr, 0);
 	}
-	dmac = rdma_ah_retrieve_dmac(&attr);
-	if (dmac)
-		memset(dmac, 0, ETH_ALEN);
-
-	ah = pd->device->create_ah(pd, &attr, &udata);
 
+	ah = rdma_create_user_ah(pd, &attr, &udata);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_put;
 	}
 
-	ah->device  = pd->device;
-	ah->pd      = pd;
-	atomic_inc(&pd->usecnt);
 	ah->uobject  = uobj;
 	uobj->user_handle = cmd.user_handle;
 	uobj->object = ah;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index de57d6c11a25..4dcfe47c479d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -302,11 +302,13 @@ EXPORT_SYMBOL(ib_dealloc_pd);
 
 /* Address handles */
 
-struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
+static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
+				     struct rdma_ah_attr *ah_attr,
+				     struct ib_udata *udata)
 {
 	struct ib_ah *ah;
 
-	ah = pd->device->create_ah(pd, ah_attr, NULL);
+	ah = pd->device->create_ah(pd, ah_attr, udata);
 
 	if (!IS_ERR(ah)) {
 		ah->device  = pd->device;
@@ -318,8 +320,42 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
 
 	return ah;
 }
+
+struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
+{
+	return _rdma_create_ah(pd, ah_attr, NULL);
+}
 EXPORT_SYMBOL(rdma_create_ah);
 
+/**
+ * rdma_create_user_ah - Creates an address handle for the
+ * given address vector.
+ * It resolves destination mac address for ah attribute of RoCE type.
+ * @pd: The protection domain associated with the address handle.
+ * @ah_attr: The attributes of the address vector.
+ * @udata: pointer to user's input output buffer information need by
+ *         provider driver.
+ *
+ * It returns 0 on success and returns appropriate error code on error.
+ * The address handle is used to reference a local or global destination
+ * in all UD QP post sends.
+ */
+struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
+				  struct rdma_ah_attr *ah_attr,
+				  struct ib_udata *udata)
+{
+	int err;
+
+	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
+		err = ib_resolve_eth_dmac(pd->device, ah_attr);
+		if (err)
+			return ERR_PTR(err);
+	}
+
+	return _rdma_create_ah(pd, ah_attr, udata);
+}
+EXPORT_SYMBOL(rdma_create_user_ah);
+
 int ib_get_rdma_header_version(const union rdma_network_hdr *hdr)
 {
 	const struct iphdr *ip4h = (struct iphdr *)&hdr->roce4grh;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e8608b2dc844..09c4a695155e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2857,6 +2857,21 @@ void ib_dealloc_pd(struct ib_pd *pd);
  */
 struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr);
 
+/**
+ * rdma_create_user_ah - Creates an address handle for the given address vector.
+ * It resolves destination mac address for ah attribute of RoCE type.
+ * @pd: The protection domain associated with the address handle.
+ * @ah_attr: The attributes of the address vector.
+ * @udata: pointer to user's input output buffer information need by
+ *         provider driver.
+ *
+ * It returns 0 on success and returns appropriate error code on error.
+ * The address handle is used to reference a local or global destination
+ * in all UD QP post sends.
+ */
+struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
+				  struct rdma_ah_attr *ah_attr,
+				  struct ib_udata *udata);
 /**
  * ib_get_gids_from_rdma_hdr - Get sgid and dgid from GRH or IPv4 header
  *   work completion.
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
