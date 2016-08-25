From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/{core,hw}: Add constant for node_desc
Date: Thu, 25 Aug 2016 01:53:06 -0700
Message-ID: <1472115186-10718-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c              |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h  |    1 +
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    1 +
 drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
 drivers/infiniband/hw/hfi1/verbs.c           |    3 ++-
 drivers/infiniband/hw/mlx4/mad.c             |    3 ++-
 drivers/infiniband/hw/mlx4/main.c            |    6 +++---
 drivers/infiniband/hw/mlx5/mad.c             |    2 +-
 drivers/infiniband/hw/mlx5/main.c            |    6 +++---
 drivers/infiniband/hw/mthca/mthca_mad.c      |    3 ++-
 drivers/infiniband/hw/mthca/mthca_provider.c |    5 +++--
 drivers/infiniband/hw/ocrdma/ocrdma.h        |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |    3 ++-
 include/rdma/ib_verbs.h                      |    6 ++++--
 16 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 15defef..c1fb545 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1193,7 +1193,7 @@ static ssize_t set_node_desc(struct device *device,
 	if (!dev->modify_device)
 		return -EIO;
 
-	memcpy(desc.node_desc, buf, min_t(int, count, 64));
+	memcpy(desc.node_desc, buf, min_t(int, count, IB_DEVICE_NODE_DESC_MAX));
 	ret = ib_modify_device(dev, IB_DEVICE_MODIFY_NODE_DESC, &desc);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 3edb806..2c204b7 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1396,7 +1396,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	    (1ull << IB_USER_VERBS_CMD_POST_SEND) |
 	    (1ull << IB_USER_VERBS_CMD_POST_RECV);
 	dev->ibdev.node_type = RDMA_NODE_RNIC;
-	memcpy(dev->ibdev.node_desc, IWCH_NODE_DESC, sizeof(IWCH_NODE_DESC));
+	memcpy(dev->ibdev.node_desc, IWCH_NODE_DESC, IB_DEVICE_NODE_DESC_MAX);
 	dev->ibdev.phys_port_cnt = dev->rdev.port_info.nports;
 	dev->ibdev.num_comp_vectors = 1;
 	dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 252c464..8ab3bf5 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -342,6 +342,7 @@ int iwch_alloc_pbl(struct iwch_mr *mhp, int npages);
 void iwch_free_pbl(struct iwch_mr *mhp);
 int iwch_write_pbl(struct iwch_mr *mhp, __be64 *pages, int npages, int offset);
 
+/* node_desc cannot exceed IB_DEVICE_NODE_DESC_MAX */
 #define IWCH_NODE_DESC "cxgb3 Chelsio Communications"
 
 #endif
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index aa47e0a..739d0c6 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -633,6 +633,7 @@ enum c4iw_mmid_state {
 	C4IW_STAG_STATE_INVALID
 };
 
+/* node_desc cannot excced IB_DEVICE_NODE_DESC_MAX */
 #define C4IW_NODE_DESC "cxgb4 Chelsio Communications"
 
 #define MPA_KEY_REQ "MPA ID Req Frame"
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index df127ce..e34041f 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -563,7 +563,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	    (1ull << IB_USER_VERBS_CMD_POST_SEND) |
 	    (1ull << IB_USER_VERBS_CMD_POST_RECV);
 	dev->ibdev.node_type = RDMA_NODE_RNIC;
-	memcpy(dev->ibdev.node_desc, C4IW_NODE_DESC, sizeof(C4IW_NODE_DESC));
+	memcpy(dev->ibdev.node_desc, C4IW_NODE_DESC, IB_DEVICE_NODE_DESC_MAX);
 	dev->ibdev.phys_port_cnt = dev->rdev.lldi.nports;
 	dev->ibdev.num_comp_vectors =  dev->rdev.lldi.nciq;
 	dev->ibdev.dma_device = &(dev->rdev.lldi.pdev->dev);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 2b35954..f803f7b 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1423,7 +1423,8 @@ static int modify_device(struct ib_device *device,
 	}
 
 	if (device_modify_mask & IB_DEVICE_MODIFY_NODE_DESC) {
-		memcpy(device->node_desc, device_modify->node_desc, 64);
+		memcpy(device->node_desc, device_modify->node_desc,
+		       IB_DEVICE_NODE_DESC_MAX);
 		for (i = 0; i < dd->num_pports; i++) {
 			struct hfi1_ibport *ibp = &dd->pport[i].ibport_data;
 
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9c2e53d..7d9ff6e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -345,7 +345,8 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		spin_lock_irqsave(&to_mdev(dev)->sm_lock, flags);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		memcpy(((struct ib_smp *) mad)->data, dev->node_desc,
+		       IB_DEVICE_NODE_DESC_MAX);
 		spin_unlock_irqrestore(&to_mdev(dev)->sm_lock, flags);
 	}
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2af44c2..9c9bb24 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -886,7 +886,7 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 		return -EOPNOTSUPP;
 
 	spin_lock_irqsave(&to_mdev(ibdev)->sm_lock, flags);
-	memcpy(ibdev->node_desc, props->node_desc, 64);
+	memcpy(ibdev->node_desc, props->node_desc, IB_DEVICE_NODE_DESC_MAX);
 	spin_unlock_irqrestore(&to_mdev(ibdev)->sm_lock, flags);
 
 	/*
@@ -897,7 +897,7 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	if (IS_ERR(mailbox))
 		return 0;
 
-	memcpy(mailbox->buf, props->node_desc, 64);
+	memcpy(mailbox->buf, props->node_desc, IB_DEVICE_NODE_DESC_MAX);
 	mlx4_cmd(to_mdev(ibdev)->dev, mailbox->dma, 1, 0,
 		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
 
@@ -2000,7 +2000,7 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	if (err)
 		goto out;
 
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	memcpy(dev->ib_dev.node_desc, out_mad->data, IB_DEVICE_NODE_DESC_MAX);
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 364aab9..39e5848 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -394,7 +394,7 @@ int mlx5_query_mad_ifc_node_desc(struct mlx5_ib_dev *dev, char *node_desc)
 	if (err)
 		goto out;
 
-	memcpy(node_desc, out_mad->data, 64);
+	memcpy(node_desc, out_mad->data, IB_DEVICE_NODE_DESC_MAX);
 out:
 	kfree(in_mad);
 	kfree(out_mad);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a84bb76..4936b4c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -432,7 +432,7 @@ static int mlx5_query_node_guid(struct mlx5_ib_dev *dev,
 }
 
 struct mlx5_reg_node_desc {
-	u8	desc[64];
+	u8	desc[IB_DEVICE_NODE_DESC_MAX];
 };
 
 static int mlx5_query_node_desc(struct mlx5_ib_dev *dev, char *node_desc)
@@ -850,13 +850,13 @@ static int mlx5_ib_modify_device(struct ib_device *ibdev, int mask,
 	 * If possible, pass node desc to FW, so it can generate
 	 * a 144 trap.  If cmd fails, just ignore.
 	 */
-	memcpy(&in, props->node_desc, 64);
+	memcpy(&in, props->node_desc, IB_DEVICE_NODE_DESC_MAX);
 	err = mlx5_core_access_reg(dev->mdev, &in, sizeof(in), &out,
 				   sizeof(out), MLX5_REG_NODE_DESC, 0, 1);
 	if (err)
 		return err;
 
-	memcpy(ibdev->node_desc, props->node_desc, 64);
+	memcpy(ibdev->node_desc, props->node_desc, IB_DEVICE_NODE_DESC_MAX);
 
 	return err;
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 7c3f2fb..9139405 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -153,7 +153,8 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		mutex_lock(&to_mdev(dev)->cap_mask_mutex);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		memcpy(((struct ib_smp *) mad)->data, dev->node_desc,
+		       IB_DEVICE_NODE_DESC_MAX);
 		mutex_unlock(&to_mdev(dev)->cap_mask_mutex);
 	}
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index da2335f..b697a0f 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -193,7 +193,8 @@ static int mthca_modify_device(struct ib_device *ibdev,
 	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
 		if (mutex_lock_interruptible(&to_mdev(ibdev)->cap_mask_mutex))
 			return -ERESTARTSYS;
-		memcpy(ibdev->node_desc, props->node_desc, 64);
+		memcpy(ibdev->node_desc, props->node_desc,
+		       IB_DEVICE_NODE_DESC_MAX);
 		mutex_unlock(&to_mdev(ibdev)->cap_mask_mutex);
 	}
 
@@ -1138,7 +1139,7 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 	if (err)
 		goto out;
 
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	memcpy(dev->ib_dev.node_desc, out_mad->data, IB_DEVICE_NODE_DESC_MAX);
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 45bdfa0..65fee69 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -58,6 +58,7 @@
 #define OCRDMA_ROCE_DRV_VERSION "11.0.0.0"
 
 #define OCRDMA_ROCE_DRV_DESC "Emulex OneConnect RoCE Driver"
+/* node_desc cannot excced IB_DEVICE_NODE_DESC_MAX */
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
 
 #define OC_NAME_SH	OCRDMA_NODE_DESC "(Skyhawk)"
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 07d0c6c..7f319d6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -120,7 +120,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
 	ocrdma_get_guid(dev, (u8 *)&dev->ibdev.node_guid);
 	memcpy(dev->ibdev.node_desc, OCRDMA_NODE_DESC,
-	       sizeof(OCRDMA_NODE_DESC));
+	       IB_DEVICE_NODE_DESC_MAX);
 	dev->ibdev.owner = THIS_MODULE;
 	dev->ibdev.uverbs_abi_ver = OCRDMA_ABI_VERSION;
 	dev->ibdev.uverbs_cmd_mask =
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index fd1dfbc..2d7e526 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1370,7 +1370,8 @@ static int qib_modify_device(struct ib_device *device,
 	}
 
 	if (device_modify_mask & IB_DEVICE_MODIFY_NODE_DESC) {
-		memcpy(device->node_desc, device_modify->node_desc, 64);
+		memcpy(device->node_desc, device_modify->node_desc,
+		       IB_DEVICE_NODE_DESC_MAX);
 		for (i = 0; i < dd->num_pports; i++) {
 			struct qib_ibport *ibp = &dd->pport[i].ibport_data;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..abeaae8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -525,9 +525,11 @@ enum ib_device_modify_flags {
 	IB_DEVICE_MODIFY_NODE_DESC	= 1 << 1
 };
 
+#define IB_DEVICE_NODE_DESC_MAX 64
+
 struct ib_device_modify {
 	u64	sys_image_guid;
-	char	node_desc[64];
+	char	node_desc[IB_DEVICE_NODE_DESC_MAX];
 };
 
 enum ib_port_modify_flags {
@@ -2033,7 +2035,7 @@ struct ib_device {
 	u64			     uverbs_cmd_mask;
 	u64			     uverbs_ex_cmd_mask;
 
-	char			     node_desc[64];
+	char			     node_desc[IB_DEVICE_NODE_DESC_MAX];
 	__be64			     node_guid;
 	u32			     local_dma_lkey;
 	u16                          is_switch:1;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
