From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 7/7] RDMA/core: Rename kernel modify_cq to better describe its usage
Date: Mon, 13 Nov 2017 10:51:19 +0200
Message-ID: <20171113085119.1705-8-leon@kernel.org>
References: <20171113085119.1705-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113085119.1705-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Current ib_modify_cq() is used to set CQ moderation parameters.

This patch renames ib_modify_cq() to be rdma_set_cq_moderation(),
because the kernel version of RDMA API doesn't need to follow already
exposed to user's API pattern (create_XXX/modify_XXX/query_XXX/destroy_XXX)
and better to have more accurate name which describes the actual usage.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c         | 2 +-
 drivers/infiniband/core/verbs.c              | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 5 +++--
 include/rdma/ib_verbs.h                      | 4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 53143e4b1c50..16d55710b116 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3901,7 +3901,7 @@ int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
 	if (!cq)
 		return -EINVAL;

-	ret = ib_modify_cq(cq, cmd.attr.cq_count, cmd.attr.cq_period);
+	ret = rdma_set_cq_moderation(cq, cmd.attr.cq_count, cmd.attr.cq_period);

 	uobj_put_obj_read(cq);

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index d8f1a5d34f4f..3fb8fb6cc824 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1550,12 +1550,12 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_create_cq);

-int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
+int rdma_set_cq_moderation(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 {
 	return cq->device->modify_cq ?
 		cq->device->modify_cq(cq, cq_count, cq_period) : -ENOSYS;
 }
-EXPORT_SYMBOL(ib_modify_cq);
+EXPORT_SYMBOL(rdma_set_cq_moderation);

 int ib_destroy_cq(struct ib_cq *cq)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 8dc1e6225cc8..2706bf26cbac 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -99,8 +99,9 @@ static int ipoib_set_coalesce(struct net_device *dev,
 	    coal->rx_max_coalesced_frames > 0xffff)
 		return -EINVAL;

-	ret = ib_modify_cq(priv->recv_cq, coal->rx_max_coalesced_frames,
-			   coal->rx_coalesce_usecs);
+	ret = rdma_set_cq_moderation(priv->recv_cq,
+				     coal->rx_max_coalesced_frames,
+				     coal->rx_coalesce_usecs);
 	if (ret && ret != -ENOSYS) {
 		ipoib_warn(priv, "failed modifying CQ (%d)\n", ret);
 		return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0b484c023fa9..fd84cda5ed7c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3169,13 +3169,13 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
 int ib_resize_cq(struct ib_cq *cq, int cqe);

 /**
- * ib_modify_cq - Modifies moderation params of the CQ
+ * rdma_set_cq_moderation - Modifies moderation params of the CQ
  * @cq: The CQ to modify.
  * @cq_count: number of CQEs that will trigger an event
  * @cq_period: max period of time in usec before triggering an event
  *
  */
-int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
+int rdma_set_cq_moderation(struct ib_cq *cq, u16 cq_count, u16 cq_period);

 /**
  * ib_destroy_cq - Destroys the specified CQ.
--
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
