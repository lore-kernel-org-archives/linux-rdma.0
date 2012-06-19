From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 03/29] IB/mlx4: Add debug printouts
Date: Tue, 19 Jun 2012 11:21:35 +0300
Message-ID: <1340094121-14858-4-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Define pr_fmt and add some pr_debug prints.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c     |   19 +++++++++++++++++++
 drivers/infiniband/hw/mlx4/main.c    |    2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   10 ++++++++++
 drivers/infiniband/hw/mlx4/qp.c      |   27 +++++++++++++++++++++++++--
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 259b067..84786a9 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -242,6 +242,25 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	int err;
 	struct ib_port_attr pattr;
 
+	if (in_wc && in_wc->qp->qp_num) {
+		pr_debug("received MAD: slid:%d sqpn:%d "
+			"dlid_bits:%d dqpn:%d wc_flags:0x%x, cls %x, mtd %x, atr %x\n",
+			in_wc->slid, in_wc->src_qp,
+			in_wc->dlid_path_bits,
+			in_wc->qp->qp_num,
+			in_wc->wc_flags,
+			in_mad->mad_hdr.mgmt_class, in_mad->mad_hdr.method,
+			be16_to_cpu(in_mad->mad_hdr.attr_id));
+		if (in_wc->wc_flags & IB_WC_GRH) {
+			pr_debug("sgid_hi:0x%016llx sgid_lo:0x%016llx\n",
+				 be64_to_cpu(in_grh->sgid.global.subnet_prefix),
+				 be64_to_cpu(in_grh->sgid.global.interface_id));
+			pr_debug("dgid_hi:0x%016llx dgid_lo:0x%016llx\n",
+				 be64_to_cpu(in_grh->dgid.global.subnet_prefix),
+				 be64_to_cpu(in_grh->dgid.global.interface_id));
+		}
+	}
+
 	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0) {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 3530c41..5266b49 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -50,7 +50,7 @@
 #include "mlx4_ib.h"
 #include "user.h"
 
-#define DRV_NAME	"mlx4_ib"
+#define DRV_NAME	MLX4_IB_DRV_NAME
 #define DRV_VERSION	"1.0"
 #define DRV_RELDATE	"April 4, 2008"
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ff36655..5f298af 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -44,6 +44,16 @@
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
 
+#define MLX4_IB_DRV_NAME	"mlx4_ib"
+
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+#define pr_fmt(fmt)	"<" MLX4_IB_DRV_NAME "> %s: " fmt, __func__
+
+#define mlx4_ib_warn(ibdev, format, arg...) \
+	dev_warn((ibdev)->dma_device, MLX4_IB_DRV_NAME ": " format, ## arg)
+
 enum {
 	MLX4_IB_SQ_MIN_WQE_SHIFT = 6,
 	MLX4_IB_MAX_HEADROOM	 = 2048
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8d4ed24..1b54e41 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1335,11 +1335,21 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask))
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask)) {
+		pr_debug("qpn 0x%x: invalid attribute mask specified "
+			 "for transition %d to %d. qp_type %d,"
+			 " attr_mask 0x%x\n",
+			 ibqp->qp_num, cur_state, new_state,
+			 ibqp->qp_type, attr_mask);
 		goto out;
+	}
 
 	if ((attr_mask & IB_QP_PORT) &&
 	    (attr->port_num == 0 || attr->port_num > dev->dev->caps.num_ports)) {
+		pr_debug("qpn 0x%x: invalid port number (%d) specified "
+			 "for transition %d to %d. qp_type %d\n",
+			 ibqp->qp_num, attr->port_num, cur_state,
+			 new_state, ibqp->qp_type);
 		goto out;
 	}
 
@@ -1350,17 +1360,30 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		int p = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
-		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p])
+		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p]) {
+			pr_debug("qpn 0x%x: invalid pkey index (%d) specified "
+				 "for transition %d to %d. qp_type %d\n",
+				 ibqp->qp_num, attr->pkey_index, cur_state,
+				 new_state, ibqp->qp_type);
 			goto out;
+		}
 	}
 
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
 	    attr->max_rd_atomic > dev->dev->caps.max_qp_init_rdma) {
+		pr_debug("qpn 0x%x: max_rd_atomic (%d) too large. "
+			 "Transition %d to %d. qp_type %d\n",
+			 ibqp->qp_num, attr->max_rd_atomic, cur_state,
+			 new_state, ibqp->qp_type);
 		goto out;
 	}
 
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
 	    attr->max_dest_rd_atomic > dev->dev->caps.max_qp_dest_rdma) {
+		pr_debug("qpn 0x%x: max_dest_rd_atomic (%d) too large. "
+			 "Transition %d to %d. qp_type %d\n",
+			 ibqp->qp_num, attr->max_dest_rd_atomic, cur_state,
+			 new_state, ibqp->qp_type);
 		goto out;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
