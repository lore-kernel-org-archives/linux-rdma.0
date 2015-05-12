From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/5] IB/core: Formalize the creation of immutable per port data within the ib_device object
Date: Mon, 11 May 2015 21:46:55 -0400
Message-ID: <1431395218-27693-3-git-send-email-ira.weiny@intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431395218-27693-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

This type of data requires a new call back "port_immutable" parameter to
ib_register_device to allow each driver to create this data as appropriate.
This callback is added to ib_register_device rather than as a new device
function because the callback should only be used when devices are first
registered.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/device.c             | 56 ++++++++++++++--------------
 drivers/infiniband/hw/amso1100/c2_provider.c | 20 +++++++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  | 20 +++++++++-
 drivers/infiniband/hw/cxgb4/provider.c       | 20 +++++++++-
 drivers/infiniband/hw/ehca/ehca_main.c       | 20 +++++++++-
 drivers/infiniband/hw/ipath/ipath_verbs.c    | 20 +++++++++-
 drivers/infiniband/hw/mlx4/main.c            | 20 +++++++++-
 drivers/infiniband/hw/mlx5/main.c            | 20 +++++++++-
 drivers/infiniband/hw/mthca/mthca_provider.c | 20 +++++++++-
 drivers/infiniband/hw/nes/nes_verbs.c        | 21 ++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   | 20 +++++++++-
 drivers/infiniband/hw/qib/qib_verbs.c        | 21 ++++++++++-
 drivers/infiniband/hw/usnic/usnic_ib_main.c  | 20 +++++++++-
 include/rdma/ib_verbs.h                      | 13 +++++--
 14 files changed, 268 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b360350..e1e5c8d 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -223,42 +223,42 @@ static int add_client_context(struct ib_device *device, struct ib_client *client
 	return 0;
 }
 
-static int read_port_table_lengths(struct ib_device *device)
+static int read_port_immutable(struct ib_device *device,
+			       int (*port_immutable)(struct ib_device *,
+						     u8,
+						     struct ib_port_immutable *))
 {
-	struct ib_port_attr *tprops = NULL;
 	int num_ports, ret = -ENOMEM;
-	u8 port_index;
-
-	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
-	if (!tprops)
-		goto out;
+	u8 port;
 
 	num_ports = end_port(device) - start_port(device) + 1;
 
-	device->pkey_tbl_len = kmalloc(sizeof *device->pkey_tbl_len * num_ports,
-				       GFP_KERNEL);
-	device->gid_tbl_len = kmalloc(sizeof *device->gid_tbl_len * num_ports,
-				      GFP_KERNEL);
-	if (!device->pkey_tbl_len || !device->gid_tbl_len)
+	device->port_immutable = kmalloc(sizeof(*device->port_immutable)
+						* (num_ports+1),
+					 GFP_KERNEL);
+	if (!device->port_immutable)
 		goto err;
 
-	for (port_index = 0; port_index < num_ports; ++port_index) {
-		ret = ib_query_port(device, port_index + start_port(device),
-					tprops);
+	for (port = 0; port <= num_ports; ++port) {
+
+		if (port == 0 && device->node_type != RDMA_NODE_IB_SWITCH)
+			continue;
+
+		if (port > 0 && device->node_type == RDMA_NODE_IB_SWITCH)
+			break;
+
+		ret = port_immutable(device, port,
+				     &device->port_immutable[port]);
 		if (ret)
 			goto err;
-		device->pkey_tbl_len[port_index] = tprops->pkey_tbl_len;
-		device->gid_tbl_len[port_index]  = tprops->gid_tbl_len;
 	}
 
 	ret = 0;
 	goto out;
 
 err:
-	kfree(device->gid_tbl_len);
-	kfree(device->pkey_tbl_len);
+	kfree(device->port_immutable);
 out:
-	kfree(tprops);
 	return ret;
 }
 
@@ -273,7 +273,9 @@ out:
  */
 int ib_register_device(struct ib_device *device,
 		       int (*port_callback)(struct ib_device *,
-					    u8, struct kobject *))
+					    u8, struct kobject *),
+		       int (*port_immutable)(struct ib_device *, u8,
+					     struct ib_port_immutable *))
 {
 	int ret;
 
@@ -295,7 +297,7 @@ int ib_register_device(struct ib_device *device,
 	spin_lock_init(&device->event_handler_lock);
 	spin_lock_init(&device->client_data_lock);
 
-	ret = read_port_table_lengths(device);
+	ret = read_port_immutable(device, port_immutable);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't create table lengths cache for device %s\n",
 		       device->name);
@@ -306,8 +308,7 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
-		kfree(device->gid_tbl_len);
-		kfree(device->pkey_tbl_len);
+		kfree(device->port_immutable);
 		goto out;
 	}
 
@@ -349,8 +350,7 @@ void ib_unregister_device(struct ib_device *device)
 
 	list_del(&device->core_list);
 
-	kfree(device->gid_tbl_len);
-	kfree(device->pkey_tbl_len);
+	kfree(device->port_immutable);
 
 	mutex_unlock(&device_mutex);
 
@@ -678,7 +678,7 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 	int ret, port, i;
 
 	for (port = start_port(device); port <= end_port(device); ++port) {
-		for (i = 0; i < device->gid_tbl_len[port - start_port(device)]; ++i) {
+		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid);
 			if (ret)
 				return ret;
@@ -710,7 +710,7 @@ int ib_find_pkey(struct ib_device *device,
 	u16 tmp_pkey;
 	int partial_ix = -1;
 
-	for (i = 0; i < device->pkey_tbl_len[port_num - start_port(device)]; ++i) {
+	for (i = 0; i < device->port_immutable[port_num].pkey_tbl_len; ++i) {
 		ret = ib_query_pkey(device, port_num, i, &tmp_pkey);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 6fe329a..a29c37f 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -763,6 +763,24 @@ static struct net_device *c2_pseudo_netdev_init(struct c2_dev *c2dev)
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -855,7 +873,7 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.iwcm->create_listen = c2_service_create;
 	dev->ibdev.iwcm->destroy_listen = c2_service_destroy;
 
-	ret = ib_register_device(&dev->ibdev, NULL);
+	ret = ib_register_device(&dev->ibdev, NULL, c2_port_immutable);
 	if (ret)
 		goto out_free_iwcm;
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 298d1ca..a1635e5 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1349,6 +1349,24 @@ static struct device_attribute *iwch_class_attributes[] = {
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -1441,7 +1459,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.iwcm->rem_ref = iwch_qp_rem_ref;
 	dev->ibdev.iwcm->get_qp = iwch_get_qp;
 
-	ret = ib_register_device(&dev->ibdev, NULL);
+	ret = ib_register_device(&dev->ibdev, NULL, iwch_port_immutable);
 	if (ret)
 		goto bail1;
 
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index f52ee63..2281726 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -471,6 +471,24 @@ static struct device_attribute *c4iw_class_attributes[] = {
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -563,7 +581,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.iwcm->rem_ref = c4iw_qp_rem_ref;
 	dev->ibdev.iwcm->get_qp = c4iw_get_qp;
 
-	ret = ib_register_device(&dev->ibdev, NULL);
+	ret = ib_register_device(&dev->ibdev, NULL, c4iw_port_immutable);
 	if (ret)
 		goto bail1;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 321545b..0ad9307 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -431,6 +431,24 @@ init_node_guid1:
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -801,7 +819,7 @@ static int ehca_probe(struct platform_device *dev)
 		goto probe5;
 	}
 
-	ret = ib_register_device(&shca->ib_device, NULL);
+	ret = ib_register_device(&shca->ib_device, NULL, ehca_port_immutable);
 	if (ret) {
 		ehca_err(&shca->ib_device,
 			 "ib_register_device() failed ret=%i", ret);
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 34b94c3a..2f81cf2 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1986,6 +1986,24 @@ static int disable_timer(struct ipath_devdata *dd)
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -2190,7 +2208,7 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	snprintf(dev->node_desc, sizeof(dev->node_desc),
 		 IPATH_IDSTR " %s", init_utsname()->nodename);
 
-	ret = ib_register_device(dev, NULL);
+	ret = ib_register_device(dev, NULL, ipath_port_immutable);
 	if (ret)
 		goto err_reg;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 26678d2..57e1a5c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2124,6 +2124,24 @@ static void mlx4_ib_free_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -2353,7 +2371,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	for (j = 1; j <= ibdev->dev->caps.num_ports; j++)
 		atomic64_set(&iboe->mac[j - 1], ibdev->dev->caps.def_mac[j]);
 
-	if (ib_register_device(&ibdev->ib_dev, NULL))
+	if (ib_register_device(&ibdev->ib_dev, NULL, mlx4_port_immutable))
 		goto err_steer_free_bitmap;
 
 	if (mlx4_ib_mad_init(ibdev))
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8dec380..9bf2564 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1188,6 +1188,24 @@ static void destroy_dev_resources(struct mlx5_ib_resources *devr)
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -1317,7 +1335,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_rsrc;
 
-	err = ib_register_device(&dev->ib_dev, NULL);
+	err = ib_register_device(&dev->ib_dev, NULL, mlx5_port_immutable);
 	if (err)
 		goto err_odp;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index ad1cca3..fc59611 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1250,6 +1250,24 @@ out:
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -1357,7 +1375,7 @@ int mthca_register_device(struct mthca_dev *dev)
 
 	mutex_init(&dev->cap_mask_mutex);
 
-	ret = ib_register_device(&dev->ib_dev, NULL);
+	ret = ib_register_device(&dev->ib_dev, NULL, mthca_port_immutable);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 027f6d1..7cd3c1d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -4000,6 +4000,24 @@ void nes_destroy_ofa_device(struct nes_ib_device *nesibdev)
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
+	memset(immutable, 0, sizeof(*immutable));
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
+	return 0;
+}
+
 /**
  * nes_register_ofa_device
  */
@@ -4010,7 +4028,8 @@ int nes_register_ofa_device(struct nes_ib_device *nesibdev)
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	int i, ret;
 
-	ret = ib_register_device(&nesvnic->nesibdev->ibdev, NULL);
+	ret = ib_register_device(&nesvnic->nesibdev->ibdev, NULL,
+				 nes_port_immutable);
 	if (ret) {
 		return ret;
 	}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 85d99e9..11f2e32 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -202,6 +202,24 @@ static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -302,7 +320,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 		dev->ibdev.destroy_srq = ocrdma_destroy_srq;
 		dev->ibdev.post_srq_recv = ocrdma_post_srq_recv;
 	}
-	return ib_register_device(&dev->ibdev, NULL);
+	return ib_register_device(&dev->ibdev, NULL, ocrdma_port_immutable);
 }
 
 static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9fd4b28..1c60eb2 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2046,6 +2046,24 @@ static void init_ibport(struct qib_pportdata *ppd)
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -2238,7 +2256,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
 		 "Intel Infiniband HCA %s", init_utsname()->nodename);
 
-	ret = ib_register_device(ibdev, qib_create_port_files);
+	ret = ib_register_device(ibdev, qib_create_port_files,
+				 qib_port_immutable);
 	if (ret)
 		goto err_reg;
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index bd9f364..848ba1b 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -300,6 +300,24 @@ static struct notifier_block usnic_ib_inetaddr_notifier = {
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
+	memset(immutable, 0, sizeof(*immutable));
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
@@ -386,7 +404,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.get_dma_mr = usnic_ib_get_dma_mr;
 
 
-	if (ib_register_device(&us_ibdev->ib_dev, NULL))
+	if (ib_register_device(&us_ibdev->ib_dev, NULL, usnic_port_immutable))
 		goto err_fwd_dealloc;
 
 	usnic_fwd_set_mtu(us_ibdev->ufdev, us_ibdev->netdev->mtu);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d59479..fe7efbe 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1481,6 +1481,12 @@ struct ib_dma_mapping_ops {
 
 struct iw_cm_verbs;
 
+/* Per port immutable data */
+struct ib_port_immutable {
+	int                           pkey_tbl_len;
+	int                           gid_tbl_len;
+};
+
 struct ib_device {
 	struct device                *dma_device;
 
@@ -1494,8 +1500,7 @@ struct ib_device {
 	struct list_head              client_data_list;
 
 	struct ib_cache               cache;
-	int                          *pkey_tbl_len;
-	int                          *gid_tbl_len;
+	struct ib_port_immutable     *port_immutable;
 
 	int			      num_comp_vectors;
 
@@ -1699,7 +1704,9 @@ void ib_dealloc_device(struct ib_device *device);
 
 int ib_register_device(struct ib_device *device,
 		       int (*port_callback)(struct ib_device *,
-					    u8, struct kobject *));
+					    u8, struct kobject *),
+		       int (*port_immutable)(struct ib_device *, u8,
+					     struct ib_port_immutable *));
 void ib_unregister_device(struct ib_device *device);
 
 int ib_register_client   (struct ib_client *client);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
