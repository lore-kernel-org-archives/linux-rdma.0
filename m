From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 10/12] Clear status reporting from mthca_provider
Date: Thu, 7 Jul 2011 12:22:54 -0500
Message-ID: <20110707172254.GK10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_provider.c |   77 ++++----------------------
 1 files changed, 11 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..365fe0e 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -63,8 +63,6 @@ static int mthca_query_device(struct ib_device *ibdev,
 	int err = -ENOMEM;
 	struct mthca_dev *mdev = to_mdev(ibdev);
 
-	u8 status;
-
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 	if (!in_mad || !out_mad)
@@ -78,14 +76,9 @@ static int mthca_query_device(struct ib_device *ibdev,
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
 	err = mthca_MAD_IFC(mdev, 1, 1,
-			    1, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    1, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	props->device_cap_flags    = mdev->device_cap_flags;
 	props->vendor_id           = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
@@ -141,7 +134,6 @@ static int mthca_query_port(struct ib_device *ibdev,
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
-	u8 status;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
@@ -155,14 +147,9 @@ static int mthca_query_port(struct ib_device *ibdev,
 	in_mad->attr_mod = cpu_to_be32(port);
 
 	err = mthca_MAD_IFC(to_mdev(ibdev), 1, 1,
-			    port, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	props->lid               = be16_to_cpup((__be16 *) (out_mad->data + 16));
 	props->lmc               = out_mad->data[34] & 0x7;
@@ -214,7 +201,6 @@ static int mthca_modify_port(struct ib_device *ibdev,
 	struct mthca_set_ib_param set_ib;
 	struct ib_port_attr attr;
 	int err;
-	u8 status;
 
 	if (mutex_lock_interruptible(&to_mdev(ibdev)->cap_mask_mutex))
 		return -ERESTARTSYS;
@@ -229,14 +215,9 @@ static int mthca_modify_port(struct ib_device *ibdev,
 	set_ib.cap_mask = (attr.port_cap_flags | props->set_port_cap_mask) &
 		~props->clr_port_cap_mask;
 
-	err = mthca_SET_IB(to_mdev(ibdev), &set_ib, port, &status);
+	err = mthca_SET_IB(to_mdev(ibdev), &set_ib, port);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
-
 out:
 	mutex_unlock(&to_mdev(ibdev)->cap_mask_mutex);
 	return err;
@@ -248,7 +229,6 @@ static int mthca_query_pkey(struct ib_device *ibdev,
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
-	u8 status;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
@@ -260,14 +240,9 @@ static int mthca_query_pkey(struct ib_device *ibdev,
 	in_mad->attr_mod = cpu_to_be32(index / 32);
 
 	err = mthca_MAD_IFC(to_mdev(ibdev), 1, 1,
-			    port, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	*pkey = be16_to_cpu(((__be16 *) out_mad->data)[index % 32]);
 
@@ -283,7 +258,6 @@ static int mthca_query_gid(struct ib_device *ibdev, u8 port,
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
-	u8 status;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
@@ -295,14 +269,9 @@ static int mthca_query_gid(struct ib_device *ibdev, u8 port,
 	in_mad->attr_mod = cpu_to_be32(port);
 
 	err = mthca_MAD_IFC(to_mdev(ibdev), 1, 1,
-			    port, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	memcpy(gid->raw, out_mad->data + 8, 8);
 
@@ -311,14 +280,9 @@ static int mthca_query_gid(struct ib_device *ibdev, u8 port,
 	in_mad->attr_mod = cpu_to_be32(index / 8);
 
 	err = mthca_MAD_IFC(to_mdev(ibdev), 1, 1,
-			    port, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
 
@@ -800,7 +764,6 @@ static int mthca_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *uda
 	struct mthca_cq *cq = to_mcq(ibcq);
 	struct mthca_resize_cq ucmd;
 	u32 lkey;
-	u8 status;
 	int ret;
 
 	if (entries < 1 || entries > dev->limits.max_cqes)
@@ -827,9 +790,7 @@ static int mthca_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *uda
 		lkey = ucmd.lkey;
 	}
 
-	ret = mthca_RESIZE_CQ(dev, cq->cqn, lkey, ilog2(entries), &status);
-	if (status)
-		ret = -EINVAL;
+	ret = mthca_RESIZE_CQ(dev, cq->cqn, lkey, ilog2(entries));
 
 	if (ret) {
 		if (cq->resize_buf) {
@@ -1161,7 +1122,6 @@ static int mthca_unmap_fmr(struct list_head *fmr_list)
 {
 	struct ib_fmr *fmr;
 	int err;
-	u8 status;
 	struct mthca_dev *mdev = NULL;
 
 	list_for_each_entry(fmr, fmr_list, list) {
@@ -1182,12 +1142,8 @@ static int mthca_unmap_fmr(struct list_head *fmr_list)
 		list_for_each_entry(fmr, fmr_list, list)
 			mthca_tavor_fmr_unmap(mdev, to_mfmr(fmr));
 
-	err = mthca_SYNC_TPT(mdev, &status);
-	if (err)
-		return err;
-	if (status)
-		return -EINVAL;
-	return 0;
+	err = mthca_SYNC_TPT(mdev);
+	return err;
 }
 
 static ssize_t show_rev(struct device *device, struct device_attribute *attr,
@@ -1253,7 +1209,6 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
-	u8 status;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
@@ -1264,28 +1219,18 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
 
 	err = mthca_MAD_IFC(dev, 1, 1,
-			    1, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    1, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
 	err = mthca_MAD_IFC(dev, 1, 1,
-			    1, NULL, NULL, in_mad, out_mad,
-			    &status);
+			    1, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
-	if (status) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	if (mthca_is_memfree(dev))
 		dev->rev_id = be32_to_cpup((__be32 *) (out_mad->data + 32));
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
