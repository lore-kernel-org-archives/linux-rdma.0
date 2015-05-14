From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/5] IB/core: Formalize the creation of immutable per port data within the ib_device object
Date: Wed, 13 May 2015 20:02:58 -0400
Message-ID: <1431561779-13714-5-git-send-email-ira.weiny@intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

As of commit 5eb620c81ce3 "IB/core: Add helpers for uncached GID and P_Key
searches"; pkey_tbl_len and gid_tbl_len are immutable data which are stored in
the ib_device.

The per port core capability flags to be added later are also immutable data to
be stored in the ib_device object.

In preparation for this create a structure for per port immutable data and
place the pkey and gid table lengths within this structure.

"get_port_immutable" is added as a mandatory device function to allow the
drivers to fill in this data.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes since V1:
	Clean up allocation of port_immutable array (and document it)
	kzalloc the array/remove memsets in drivers
	Delay freeing port_immutable until ib_device_release
	Update printk to reflect new function

 drivers/infiniband/core/device.c             | 63 +++++++++++++---------------
 drivers/infiniband/core/sysfs.c              |  1 +
 drivers/infiniband/hw/amso1100/c2_provider.c | 17 ++++++++
 drivers/infiniband/hw/cxgb3/iwch_provider.c  | 17 ++++++++
 drivers/infiniband/hw/cxgb4/provider.c       | 17 ++++++++
 drivers/infiniband/hw/ehca/ehca_main.c       | 17 ++++++++
 drivers/infiniband/hw/ipath/ipath_verbs.c    | 17 ++++++++
 drivers/infiniband/hw/mlx4/main.c            | 17 ++++++++
 drivers/infiniband/hw/mlx5/main.c            | 17 ++++++++
 drivers/infiniband/hw/mthca/mthca_provider.c | 17 ++++++++
 drivers/infiniband/hw/nes/nes_verbs.c        | 16 +++++++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   | 17 ++++++++
 drivers/infiniband/hw/qib/qib_verbs.c        | 17 ++++++++
 drivers/infiniband/hw/usnic/usnic_ib_main.c  | 17 ++++++++
 include/rdma/ib_verbs.h                      | 19 ++++++++-
 15 files changed, 249 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 0f16dd4d9bb4..4aa4f5420bc9 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -93,7 +93,8 @@ static int ib_device_check_mandatory(struct ib_device *device)
 		IB_MANDATORY_FUNC(poll_cq),
 		IB_MANDATORY_FUNC(req_notify_cq),
 		IB_MANDATORY_FUNC(get_dma_mr),
-		IB_MANDATORY_FUNC(dereg_mr)
+		IB_MANDATORY_FUNC(dereg_mr),
+		IB_MANDATORY_FUNC(get_port_immutable)
 	};
 	int i;
 
@@ -211,42 +212,38 @@ static int add_client_context(struct ib_device *device, struct ib_client *client
 	return 0;
 }
 
-static int read_port_table_lengths(struct ib_device *device)
+static int read_port_immutable(struct ib_device *device)
 {
-	struct ib_port_attr *tprops = NULL;
-	int num_ports, ret = -ENOMEM;
-	u8 port_index;
-
-	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
-	if (!tprops)
-		goto out;
-
-	num_ports = rdma_end_port(device) - rdma_start_port(device) + 1;
-
-	device->pkey_tbl_len = kmalloc(sizeof *device->pkey_tbl_len * num_ports,
-				       GFP_KERNEL);
-	device->gid_tbl_len = kmalloc(sizeof *device->gid_tbl_len * num_ports,
-				      GFP_KERNEL);
-	if (!device->pkey_tbl_len || !device->gid_tbl_len)
+	int ret = -ENOMEM;
+	u8 start_port = rdma_start_port(device);
+	u8 end_port = rdma_end_port(device);
+	u8 port;
+
+	/**
+	 * device->port_immutable is indexed directly by the port number to make
+	 * access to this data as efficient as possible.
+	 *
+	 * Therefore port_immutable is declared as a 1 based array with
+	 * potential empty slots at the beginning.
+	 */
+	device->port_immutable = kzalloc(sizeof(*device->port_immutable)
+					 * (end_port + 1),
+					 GFP_KERNEL);
+	if (!device->port_immutable)
 		goto err;
 
-	for (port_index = 0; port_index < num_ports; ++port_index) {
-		ret = ib_query_port(device, port_index + rdma_start_port(device),
-					tprops);
+	for (port = start_port; port <= end_port; ++port) {
+		ret = device->get_port_immutable(device, port,
+						 &device->port_immutable[port]);
 		if (ret)
 			goto err;
-		device->pkey_tbl_len[port_index] = tprops->pkey_tbl_len;
-		device->gid_tbl_len[port_index]  = tprops->gid_tbl_len;
 	}
 
 	ret = 0;
 	goto out;
-
 err:
-	kfree(device->gid_tbl_len);
-	kfree(device->pkey_tbl_len);
+	kfree(device->port_immutable);
 out:
-	kfree(tprops);
 	return ret;
 }
 
@@ -283,9 +280,9 @@ int ib_register_device(struct ib_device *device,
 	spin_lock_init(&device->event_handler_lock);
 	spin_lock_init(&device->client_data_lock);
 
-	ret = read_port_table_lengths(device);
+	ret = read_port_immutable(device);
 	if (ret) {
-		printk(KERN_WARNING "Couldn't create table lengths cache for device %s\n",
+		printk(KERN_WARNING "Couldn't create per port immutable data %s\n",
 		       device->name);
 		goto out;
 	}
@@ -294,8 +291,7 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
-		kfree(device->gid_tbl_len);
-		kfree(device->pkey_tbl_len);
+		kfree(device->port_immutable);
 		goto out;
 	}
 
@@ -337,9 +333,6 @@ void ib_unregister_device(struct ib_device *device)
 
 	list_del(&device->core_list);
 
-	kfree(device->gid_tbl_len);
-	kfree(device->pkey_tbl_len);
-
 	mutex_unlock(&device_mutex);
 
 	ib_device_unregister_sysfs(device);
@@ -666,7 +659,7 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 	int ret, port, i;
 
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
-		for (i = 0; i < device->gid_tbl_len[port - rdma_start_port(device)]; ++i) {
+		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid);
 			if (ret)
 				return ret;
@@ -698,7 +691,7 @@ int ib_find_pkey(struct ib_device *device,
 	u16 tmp_pkey;
 	int partial_ix = -1;
 
-	for (i = 0; i < device->pkey_tbl_len[port_num - rdma_start_port(device)]; ++i) {
+	for (i = 0; i < device->port_immutable[port_num].pkey_tbl_len; ++i) {
 		ret = ib_query_pkey(device, port_num, i, &tmp_pkey);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cbd0383f622e..d0334c101ecb 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -456,6 +456,7 @@ static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
 
+	kfree(dev->port_immutable);
 	kfree(dev);
 }
 
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 6fe329a5d595..fa638963908f 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -763,6 +763,22 @@ static struct net_device *c2_pseudo_netdev_init(struct c2_dev *c2dev)
 	return netdev;
 }
 
+static int c2_port_immutable(struct ib_device *ibdev, u8 port_num,
+			     struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = c2_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 int c2_register_device(struct c2_dev *dev)
 {
 	int ret = -ENOMEM;
@@ -827,6 +843,7 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.reg_phys_mr = c2_reg_phys_mr;
 	dev->ibdev.reg_user_mr = c2_reg_user_mr;
 	dev->ibdev.dereg_mr = c2_dereg_mr;
+	dev->ibdev.get_port_immutable = c2_port_immutable;
 
 	dev->ibdev.alloc_fmr = NULL;
 	dev->ibdev.unmap_fmr = NULL;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 298d1caab3a5..590ba0f422a1 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1349,6 +1349,22 @@ static struct device_attribute *iwch_class_attributes[] = {
 	&dev_attr_board_id,
 };
 
+static int iwch_port_immutable(struct ib_device *ibdev, u8 port_num,
+			       struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = iwch_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 int iwch_register_device(struct iwch_dev *dev)
 {
 	int ret;
@@ -1427,6 +1443,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.post_recv = iwch_post_receive;
 	dev->ibdev.get_protocol_stats = iwch_get_mib;
 	dev->ibdev.uverbs_abi_ver = IWCH_UVERBS_ABI_VERSION;
+	dev->ibdev.get_port_immutable = iwch_port_immutable;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
 	if (!dev->ibdev.iwcm)
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index f52ee6343d41..5eded1b3bbad 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -471,6 +471,22 @@ static struct device_attribute *c4iw_class_attributes[] = {
 	&dev_attr_board_id,
 };
 
+static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
+			       struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = c4iw_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 int c4iw_register_device(struct c4iw_dev *dev)
 {
 	int ret;
@@ -549,6 +565,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.post_recv = c4iw_post_receive;
 	dev->ibdev.get_protocol_stats = c4iw_get_mib;
 	dev->ibdev.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION;
+	dev->ibdev.get_port_immutable = c4iw_port_immutable;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
 	if (!dev->ibdev.iwcm)
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 321545b708ad..8454186e16ab 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -431,6 +431,22 @@ init_node_guid1:
 	return ret;
 }
 
+static int ehca_port_immutable(struct ib_device *ibdev, u8 port_num,
+			       struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = ehca_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 static int ehca_init_device(struct ehca_shca *shca)
 {
 	int ret;
@@ -511,6 +527,7 @@ static int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.process_mad	    = ehca_process_mad;
 	shca->ib_device.mmap		    = ehca_mmap;
 	shca->ib_device.dma_ops		    = &ehca_dma_mapping_ops;
+	shca->ib_device.get_port_immutable  = ehca_port_immutable;
 
 	if (EHCA_BMASK_GET(HCA_CAP_SRQ, shca->hca_cap)) {
 		shca->ib_device.uverbs_cmd_mask |=
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 34b94c3ae674..49b774b6f7e8 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1986,6 +1986,22 @@ static int disable_timer(struct ipath_devdata *dd)
 	return 0;
 }
 
+static int ipath_port_immutable(struct ib_device *ibdev, u8 port_num,
+			        struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = ipath_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 /**
  * ipath_register_ib_device - register our device with the infiniband core
  * @dd: the device data structure
@@ -2186,6 +2202,7 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->process_mad = ipath_process_mad;
 	dev->mmap = ipath_mmap;
 	dev->dma_ops = &ipath_dma_mapping_ops;
+	dev->get_port_immutable = ipath_port_immutable;
 
 	snprintf(dev->node_desc, sizeof(dev->node_desc),
 		 IPATH_IDSTR " %s", init_utsname()->nodename);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 26678d2c1e98..b2befe574033 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2124,6 +2124,22 @@ static void mlx4_ib_free_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 	kfree(ibdev->eq_table);
 }
 
+static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
+			       struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = mlx4_ib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -2252,6 +2268,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
+	ibdev->ib_dev.get_port_immutable = mlx4_port_immutable;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8dec38055c49..8db0edca6dd8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1188,6 +1188,22 @@ static void destroy_dev_resources(struct mlx5_ib_resources *devr)
 	mlx5_ib_dealloc_pd(devr->p0);
 }
 
+static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
+			       struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = mlx5_ib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -1292,6 +1308,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
+	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
 
 	mlx5_ib_internal_query_odp_caps(dev);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index ad1cca3a3a5c..4662fd20b8e6 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1250,6 +1250,22 @@ out:
 	return err;
 }
 
+static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
+			        struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = mthca_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 int mthca_register_device(struct mthca_dev *dev)
 {
 	int ret;
@@ -1330,6 +1346,7 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.reg_phys_mr          = mthca_reg_phys_mr;
 	dev->ib_dev.reg_user_mr          = mthca_reg_user_mr;
 	dev->ib_dev.dereg_mr             = mthca_dereg_mr;
+	dev->ib_dev.get_port_immutable   = mthca_port_immutable;
 
 	if (dev->mthca_flags & MTHCA_FLAG_FMR) {
 		dev->ib_dev.alloc_fmr            = mthca_alloc_fmr;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 027f6d1cd059..4ed2d967d324 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3833,6 +3833,21 @@ static int nes_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_
 	return 0;
 }
 
+static int nes_port_immutable(struct ib_device *ibdev, u8 port_num,
+			      struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = nes_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
 
 /**
  * nes_init_ofa_device
@@ -3934,6 +3949,7 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.iwcm->reject = nes_reject;
 	nesibdev->ibdev.iwcm->create_listen = nes_create_listen;
 	nesibdev->ibdev.iwcm->destroy_listen = nes_destroy_listen;
+	nesibdev->ibdev.get_port_immutable   = nes_port_immutable;
 
 	return nesibdev;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 85d99e9306a0..21744be6cac5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -202,6 +202,22 @@ static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 	return IB_LINK_LAYER_ETHERNET;
 }
 
+static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
+			         struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = ocrdma_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 static int ocrdma_register_device(struct ocrdma_dev *dev)
 {
 	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
@@ -287,6 +303,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.dma_device = &dev->nic_info.pdev->dev;
 
 	dev->ibdev.process_mad = ocrdma_process_mad;
+	dev->ibdev.get_port_immutable = ocrdma_port_immutable;
 
 	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		dev->ibdev.uverbs_cmd_mask |=
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9fd4b285e5e5..48f4784c53a6 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2046,6 +2046,22 @@ static void init_ibport(struct qib_pportdata *ppd)
 	RCU_INIT_POINTER(ibp->qp1, NULL);
 }
 
+static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
+			      struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = qib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 /**
  * qib_register_ib_device - register our device with the infiniband core
  * @dd: the device data structure
@@ -2234,6 +2250,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->process_mad = qib_process_mad;
 	ibdev->mmap = qib_mmap;
 	ibdev->dma_ops = &qib_dma_mapping_ops;
+	ibdev->get_port_immutable = qib_port_immutable;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
 		 "Intel Infiniband HCA %s", init_utsname()->nodename);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index bd9f364e909c..ce3e19bcfe00 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -300,6 +300,22 @@ static struct notifier_block usnic_ib_inetaddr_notifier = {
 };
 /* End of inet section*/
 
+static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
+			        struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = usnic_ib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 /* Start of PF discovery section */
 static void *usnic_ib_device_add(struct pci_dev *dev)
 {
@@ -384,6 +400,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.poll_cq = usnic_ib_poll_cq;
 	us_ibdev->ib_dev.req_notify_cq = usnic_ib_req_notify_cq;
 	us_ibdev->ib_dev.get_dma_mr = usnic_ib_get_dma_mr;
+	us_ibdev->ib_dev.get_port_immutable = usnic_port_immutable;
 
 
 	if (ib_register_device(&us_ibdev->ib_dev, NULL))
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2637e7a6674d..de08dabcfa6a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1481,6 +1481,11 @@ struct ib_dma_mapping_ops {
 
 struct iw_cm_verbs;
 
+struct ib_port_immutable {
+	int                           pkey_tbl_len;
+	int                           gid_tbl_len;
+};
+
 struct ib_device {
 	struct device                *dma_device;
 
@@ -1494,8 +1499,10 @@ struct ib_device {
 	struct list_head              client_data_list;
 
 	struct ib_cache               cache;
-	int                          *pkey_tbl_len;
-	int                          *gid_tbl_len;
+	/**
+	 * port_immutable is indexed by port number
+	 */
+	struct ib_port_immutable     *port_immutable;
 
 	int			      num_comp_vectors;
 
@@ -1684,6 +1691,14 @@ struct ib_device {
 	u32			     local_dma_lkey;
 	u8                           node_type;
 	u8                           phys_port_cnt;
+
+	/**
+	 * The following mandatory functions are used only at device
+	 * registration.  Keep functions such as these at the end of this
+	 * structure to avoid cache line misses when accessing struct ib_device
+	 * in fast paths.
+	 */
+	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 };
 
 struct ib_client {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
