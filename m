From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 09/10] IB/core: Remove smac and vlan id from qp_attr and ah_attr
Date: Fri,  7 Aug 2015 16:01:02 +0300
Message-ID: <1438952463-23707-10-git-send-email-matanb@mellanox.com>
References: <1438952463-23707-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438952463-23707-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Smac and vlan id could be resolved from the GID attribute, and thus
these attributes aren't needed anymore. Removing them.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c   |  4 ----
 drivers/infiniband/core/ucma.c       |  1 -
 drivers/infiniband/core/uverbs_cmd.c |  1 -
 include/rdma/ib_verbs.h              | 13 ++++---------
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 4c9102b..d6731bd 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -993,11 +993,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	}
 	if (force_grh) {
 		memcpy(ah_attr->dmac, rec->dmac, ETH_ALEN);
-		ah_attr->vlan_id = rec->vlan_id;
-	} else {
-		ah_attr->vlan_id = 0xffff;
 	}
-
 	return 0;
 }
 EXPORT_SYMBOL(ib_init_ah_from_path);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index e9037df..9715439 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1207,7 +1207,6 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
 		return -EINVAL;
 
 	memset(&sa_path, 0, sizeof(sa_path));
-	sa_path.vlan_id = 0xffff;
 
 	ib_sa_unpack_path(path_data->path_rec, &sa_path);
 	ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2a22180..215f322 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2679,7 +2679,6 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
 	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
 	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
-	attr.vlan_id           = 0;
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d821014..a795836 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -698,7 +698,6 @@ struct ib_ah_attr {
 	u8			ah_flags;
 	u8			port_num;
 	u8			dmac[ETH_ALEN];
-	u16			vlan_id;
 };
 
 enum ib_wc_status {
@@ -958,10 +957,10 @@ enum ib_qp_attr_mask {
 	IB_QP_PATH_MIG_STATE		= (1<<18),
 	IB_QP_CAP			= (1<<19),
 	IB_QP_DEST_QPN			= (1<<20),
-	IB_QP_SMAC			= (1<<21),
-	IB_QP_ALT_SMAC			= (1<<22),
-	IB_QP_VID			= (1<<23),
-	IB_QP_ALT_VID			= (1<<24),
+	IB_QP_RESERVED1			= (1<<21),
+	IB_QP_RESERVED2			= (1<<22),
+	IB_QP_RESERVED3			= (1<<23),
+	IB_QP_RESERVED4			= (1<<24),
 };
 
 enum ib_qp_state {
@@ -1011,10 +1010,6 @@ struct ib_qp_attr {
 	u8			rnr_retry;
 	u8			alt_port_num;
 	u8			alt_timeout;
-	u8			smac[ETH_ALEN];
-	u8			alt_smac[ETH_ALEN];
-	u16			vlan_id;
-	u16			alt_vlan_id;
 };
 
 enum ib_wr_opcode {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
