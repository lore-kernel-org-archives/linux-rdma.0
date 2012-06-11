From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 03/29] IB/mlx4: Add run-time switchable error path debug output capability
Date: Mon, 11 Jun 2012 13:45:44 +0300
Message-ID: <1339411570-4689-4-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement debug printouts to assist in supporting the driver.

The intent is to provide more detail in the log for errors which
would otherwise be returned as -EINVAL.

The facility is on-off switchable at run-time
(i.e., module-parameter controlled, off by default).

Error output is added here specifically in ib_process_mad, and
in mlx4_ib_modify_qp.

More use is to follow.

Note: This capability was originally submitted as an RFC in Nov, 2007.
It was not pursued at that time for the upstream kernel.
The short thread starts at:
http://lists.openfabrics.org/pipermail/general/2007-November/043140.html

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c     |   19 ++++++++++++++++++
 drivers/infiniband/hw/mlx4/main.c    |   10 ++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   21 ++++++++++++++++++++
 drivers/infiniband/hw/mlx4/qp.c      |   35 +++++++++++++++++++++++++++++++--
 4 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 259b067..f36db71 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -242,6 +242,25 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	int err;
 	struct ib_port_attr pattr;
 
+	if (in_wc && in_wc->qp->qp_num) {
+		mlx4_ib_dbg("received MAD: slid:%d sqpn:%d "
+			"dlid_bits:%d dqpn:%d wc_flags:0x%x, cls %x, mtd %x, atr %x\n",
+			in_wc->slid, in_wc->src_qp,
+			in_wc->dlid_path_bits,
+			in_wc->qp->qp_num,
+			in_wc->wc_flags,
+			in_mad->mad_hdr.mgmt_class, in_mad->mad_hdr.method,
+			be16_to_cpu(in_mad->mad_hdr.attr_id));
+		if (in_wc->wc_flags & IB_WC_GRH) {
+			mlx4_ib_dbg("sgid_hi:0x%016llx sgid_lo:0x%016llx\n",
+				 be64_to_cpu(in_grh->sgid.global.subnet_prefix),
+				 be64_to_cpu(in_grh->sgid.global.interface_id));
+			mlx4_ib_dbg("dgid_hi:0x%016llx dgid_lo:0x%016llx\n",
+				 be64_to_cpu(in_grh->dgid.global.subnet_prefix),
+				 be64_to_cpu(in_grh->dgid.global.interface_id));
+		}
+	}
+
 	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0) {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 3530c41..cf7a344 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -50,7 +50,7 @@
 #include "mlx4_ib.h"
 #include "user.h"
 
-#define DRV_NAME	"mlx4_ib"
+#define DRV_NAME	MLX4_IB_DRV_NAME
 #define DRV_VERSION	"1.0"
 #define DRV_RELDATE	"April 4, 2008"
 
@@ -59,6 +59,14 @@ MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRV_VERSION);
 
+#ifdef CONFIG_MLX4_DEBUG
+
+int mlx4_ib_debug_level;
+module_param_named(debug_level, mlx4_ib_debug_level, int, 0644);
+MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
+
+#endif /* CONFIG_MLX4_DEBUG */
+
 static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ff36655..0fa1670 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -44,6 +44,27 @@
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
 
+#define MLX4_IB_DRV_NAME       "mlx4_ib"
+
+#ifdef CONFIG_MLX4_DEBUG
+extern int mlx4_ib_debug_level;
+
+#define mlx4_ib_dbg(format, arg...)			\
+	do {						\
+		if (mlx4_ib_debug_level & 1)		\
+			pr_debug("<" MLX4_IB_DRV_NAME "> %s: " format,\
+			       __func__, ## arg);	\
+	} while (0)
+
+#else /* CONFIG_MLX4_DEBUG */
+
+#define mlx4_ib_dbg(format, arg...) do {} while (0)
+
+#endif /* CONFIG_MLX4_DEBUG */
+
+#define mlx4_ib_warn(ibdev, format, arg...) \
+	dev_warn((ibdev)->dma_device, "mlx4_ib: " format, ## arg)
+
 enum {
 	MLX4_IB_SQ_MIN_WQE_SHIFT = 6,
 	MLX4_IB_MAX_HEADROOM	 = 2048
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8d4ed24..81f95eb 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1335,32 +1335,61 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask))
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask)) {
+		mlx4_ib_dbg("qpn 0x%x: invalid attribute mask specified "
+			    "for transition %d to %d. qp_type %d,"
+			    " attr_mask 0x%x\n",
+			    ibqp->qp_num, cur_state, new_state,
+			    ibqp->qp_type, attr_mask);
 		goto out;
+	}
 
 	if ((attr_mask & IB_QP_PORT) &&
 	    (attr->port_num == 0 || attr->port_num > dev->dev->caps.num_ports)) {
+		mlx4_ib_dbg("qpn 0x%x: invalid port number (%d) specified "
+			    "for transition %d to %d. qp_type %d\n",
+			    ibqp->qp_num, attr->port_num, cur_state,
+			    new_state, ibqp->qp_type);
 		goto out;
 	}
 
 	if ((attr_mask & IB_QP_PORT) && (ibqp->qp_type == IB_QPT_RAW_PACKET) &&
 	    (rdma_port_get_link_layer(&dev->ib_dev, attr->port_num) !=
-	     IB_LINK_LAYER_ETHERNET))
+	     IB_LINK_LAYER_ETHERNET)) {
+		mlx4_ib_dbg("qpn 0x%x: QP PORT bit specified in attr_mask "
+			    "for a RAW PACKET QP where port link layer "
+			    "is not ETHERNET on port (%d), "
+			    "for transition %d to %d.\n", ibqp->qp_num,
+			    attr->port_num, cur_state, new_state);
 		goto out;
+	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		int p = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
-		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p])
+		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p]) {
+			mlx4_ib_dbg("qpn 0x%x: invalid pkey index (%d) specified "
+				    "for transition %d to %d. qp_type %d\n",
+				    ibqp->qp_num, attr->pkey_index, cur_state,
+				    new_state, ibqp->qp_type);
 			goto out;
+		}
 	}
 
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
 	    attr->max_rd_atomic > dev->dev->caps.max_qp_init_rdma) {
+		mlx4_ib_dbg("qpn 0x%x: max_rd_atomic (%d) too large. "
+			    "Transition %d to %d. qp_type %d\n",
+			    ibqp->qp_num, attr->max_rd_atomic, cur_state,
+			    new_state, ibqp->qp_type);
 		goto out;
 	}
 
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
 	    attr->max_dest_rd_atomic > dev->dev->caps.max_qp_dest_rdma) {
+		mlx4_ib_dbg("qpn 0x%x: max_dest_rd_atomic (%d) too large. "
+			    "Transition %d to %d. qp_type %d\n",
+			    ibqp->qp_num, attr->max_dest_rd_atomic, cur_state,
+			    new_state, ibqp->qp_type);
 		goto out;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
