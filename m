From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 12/13] IB/core: Assign root to all drivers
Date: Wed,  7 Jun 2017 15:22:51 +0300
Message-ID: <1496838172-39671-13-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to use the parsing tree, we need to assign the root
to all drivers. Currently, we just assign the default parsing
tree.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/main.c           | 5 +++++
 drivers/infiniband/hw/cxgb3/iwch_provider.c    | 5 +++++
 drivers/infiniband/hw/cxgb4/provider.c         | 5 +++++
 drivers/infiniband/hw/hns/hns_roce_main.c      | 5 +++++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      | 5 +++++
 drivers/infiniband/hw/mlx4/main.c              | 5 +++++
 drivers/infiniband/hw/mlx5/main.c              | 5 +++++
 drivers/infiniband/hw/mthca/mthca_provider.c   | 5 +++++
 drivers/infiniband/hw/nes/nes_verbs.c          | 5 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     | 5 +++++
 drivers/infiniband/hw/qedr/main.c              | 5 +++++
 drivers/infiniband/hw/usnic/usnic_ib_main.c    | 5 +++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 5 +++++
 drivers/infiniband/sw/rdmavt/vt.c              | 5 +++++
 drivers/infiniband/sw/rxe/rxe_verbs.c          | 5 +++++
 15 files changed, 75 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 5d35540..23acca2 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -53,6 +53,8 @@
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_addr.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 
 #include "bnxt_ulp.h"
 #include "roce_hsi.h"
@@ -421,6 +423,8 @@ static void bnxt_re_unregister_ib(struct bnxt_re_dev *rdev)
 	ib_unregister_device(&rdev->ibdev);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 {
 	struct ib_device *ibdev = &rdev->ibdev;
@@ -517,6 +521,7 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	ibdev->dealloc_ucontext		= bnxt_re_dealloc_ucontext;
 	ibdev->mmap			= bnxt_re_mmap;
 
+	ibdev->specs_root = &root;
 	return ib_register_device(ibdev, NULL);
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 29d3074..a5e4c6b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -53,6 +53,8 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 
 #include "cxio_hal.h"
 #include "iwch.h"
@@ -1349,6 +1351,8 @@ static void get_dev_fw_ver_str(struct ib_device *ibdev, char *str,
 	snprintf(str, str_len, "%s", info.fw_version);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int iwch_register_device(struct iwch_dev *dev)
 {
 	int ret;
@@ -1442,6 +1446,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	memcpy(dev->ibdev.iwcm->ifname, dev->rdev.t3cdev_p->lldev->name,
 	       sizeof(dev->ibdev.iwcm->ifname));
 
+	dev->ibdev.specs_root = &root;
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
 		goto bail1;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 0771e9a..4fcc567 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -51,6 +51,8 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 
 #include "iw_cxgb4.h"
 
@@ -531,6 +533,8 @@ static void get_dev_fw_str(struct ib_device *dev, char *str,
 		 FW_HDR_FW_VER_BUILD_G(c4iw_dev->rdev.lldi.fw_vers));
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int c4iw_register_device(struct c4iw_dev *dev)
 {
 	int ret;
@@ -624,6 +628,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	memcpy(dev->ibdev.iwcm->ifname, dev->rdev.lldi.ports[0]->name,
 	       sizeof(dev->ibdev.iwcm->ifname));
 
+	dev->ibdev.specs_root = &root;
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
 		goto bail1;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index c3b41f9..302e5f9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -37,6 +37,8 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include <rdma/hns-abi.h>
@@ -424,6 +426,8 @@ static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
 	ib_unregister_device(&hr_dev->ib_dev);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 {
 	int ret;
@@ -507,6 +511,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	/* OTHERS */
 	ib_dev->get_port_immutable	= hns_roce_port_immutable;
 
+	dev->ib_dev.specs_root = &root;
 	ret = ib_register_device(ib_dev, NULL);
 	if (ret) {
 		dev_err(dev, "ib_register_device failed!\n");
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 4dbe61e..f2e89d3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -43,6 +43,8 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/iw_cm.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <rdma/ib_umem.h>
 #include "i40iw.h"
 
@@ -2859,6 +2861,8 @@ void i40iw_destroy_rdma_device(struct i40iw_ib_device *iwibdev)
 	ib_dealloc_device(&iwibdev->ibdev);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /**
  * i40iw_register_rdma_device - register iwarp device to IB
  * @iwdev: iwarp device
@@ -2873,6 +2877,7 @@ int i40iw_register_rdma_device(struct i40iw_device *iwdev)
 		return -ENOMEM;
 	iwibdev = iwdev->iwibdev;
 
+	iwibdev->ibdev.specs_root = &root;
 	ret = ib_register_device(&iwibdev->ibdev, NULL);
 	if (ret)
 		goto error;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 521d0de..75bbd4b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -48,6 +48,8 @@
 
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
 
@@ -2578,6 +2580,8 @@ static void get_fw_ver_str(struct ib_device *device, char *str,
 		 (int) dev->dev->caps.fw_ver & 0xffff);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -2860,6 +2864,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_alloc_diag_counters(ibdev))
 		goto err_steer_free_bitmap;
 
+	ibdev->ib_dev.specs_root = &root;
 	if (ib_register_device(&ibdev->ib_dev, NULL))
 		goto err_diag_counters;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d45772d..7541296 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -58,6 +58,8 @@
 #include <linux/mlx5/vport.h>
 #include "mlx5_ib.h"
 #include "cmd.h"
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 
 #define DRIVER_NAME "mlx5_ib"
 #define DRIVER_VERSION "2.2-1"
@@ -3550,6 +3552,8 @@ static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
 	return mlx5_rdma_netdev_free(netdev);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -3773,6 +3777,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_bfreg;
 
+	dev->ib_dev.specs_root = &root;
 	err = ib_register_device(&dev->ib_dev, NULL);
 	if (err)
 		goto err_fp_bfreg;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index c197cd9..95303ad 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -37,6 +37,8 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -1189,6 +1191,8 @@ static void get_dev_fw_str(struct ib_device *device, char *str,
 		 (int) dev->fw_ver & 0xffff);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int mthca_register_device(struct mthca_dev *dev)
 {
 	int ret;
@@ -1296,6 +1300,7 @@ int mthca_register_device(struct mthca_dev *dev)
 
 	mutex_init(&dev->cap_mask_mutex);
 
+	dev->ib_dev.specs_root = &root;
 	ret = ib_register_device(&dev->ib_dev, NULL);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 25dcd75..01a4631 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -41,6 +41,8 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/iw_cm.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 
 #include "nes.h"
 
@@ -3852,6 +3854,8 @@ void nes_destroy_ofa_device(struct nes_ib_device *nesibdev)
 }
 
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /**
  * nes_register_ofa_device
  */
@@ -3862,6 +3866,7 @@ int nes_register_ofa_device(struct nes_ib_device *nesibdev)
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	int i, ret;
 
+	nesvnic->nesibdev->ibdev.specs_root = &root;
 	ret = ib_register_device(&nesvnic->nesibdev->ibdev, NULL);
 	if (ret) {
 		return ret;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 57c9a2a..2ad90cc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -44,6 +44,8 @@
 #include <linux/idr.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_mad.h>
 
@@ -116,6 +118,8 @@ static void get_dev_fw_str(struct ib_device *device, char *str,
 	snprintf(str, str_len, "%s", &dev->attr.fw_ver[0]);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int ocrdma_register_device(struct ocrdma_dev *dev)
 {
 	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
@@ -219,6 +223,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 		dev->ibdev.destroy_srq = ocrdma_destroy_srq;
 		dev->ibdev.post_srq_recv = ocrdma_post_srq_recv;
 	}
+	dev->ibdev.specs_root = &root;
 	return ib_register_device(&dev->ibdev, NULL);
 }
 
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 6a72095..e5a7c26 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -33,6 +33,8 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <linux/netdevice.h>
 #include <linux/iommu.h>
 #include <linux/pci.h>
@@ -94,6 +96,8 @@ static struct net_device *qedr_get_netdev(struct ib_device *dev, u8 port_num)
 	return qdev->ndev;
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int qedr_register_device(struct qedr_dev *dev)
 {
 	strlcpy(dev->ibdev.name, "qedr%d", IB_DEVICE_NAME_MAX);
@@ -176,6 +180,7 @@ static int qedr_register_device(struct qedr_dev *dev)
 	dev->ibdev.get_link_layer = qedr_link_layer;
 	dev->ibdev.get_dev_fw_str = qedr_get_dev_fw_str;
 
+	dev->ibdev.specs_root = &root;
 	return ib_register_device(&dev->ibdev, NULL);
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index c0c1e8b..2d7deb6 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -48,6 +48,8 @@
 #include <linux/netdevice.h>
 
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <rdma/ib_addr.h>
 
 #include "usnic_abi.h"
@@ -348,6 +350,8 @@ static void usnic_get_dev_fw_str(struct ib_device *device,
 	snprintf(str, str_len, "%s", info.fw_version);
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /* Start of PF discovery section */
 static void *usnic_ib_device_add(struct pci_dev *dev)
 {
@@ -434,6 +438,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.get_dev_fw_str     = usnic_get_dev_fw_str;
 
 
+	us_ibdev->ib_dev.specs_root = &root;
 	if (ib_register_device(&us_ibdev->ib_dev, NULL))
 		goto err_fwd_dealloc;
 
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 34ebc76..a8b033d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -51,6 +51,8 @@
 #include <rdma/ib_addr.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <net/addrconf.h>
 
 #include "pvrdma.h"
@@ -162,6 +164,8 @@ static struct net_device *pvrdma_get_netdev(struct ib_device *ibdev,
 	return netdev;
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int pvrdma_register_device(struct pvrdma_dev *dev)
 {
 	int ret = -1;
@@ -251,6 +255,7 @@ static int pvrdma_register_device(struct pvrdma_dev *dev)
 		goto err_cq_free;
 	spin_lock_init(&dev->qp_tbl_lock);
 
+	dev->ib_dev.specs_root = &root;
 	ret = ib_register_device(&dev->ib_dev, NULL);
 	if (ret)
 		goto err_qp_free;
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 0d7c6bb..9c99d45 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -48,6 +48,8 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/dma-mapping.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include "vt.h"
 #include "trace.h"
 
@@ -716,6 +718,8 @@ static noinline int check_support(struct rvt_dev_info *rdi, int verb)
 	return 0;
 }
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /**
  * rvt_register_device - register a driver
  * @rdi: main dev structure for all of rdmavt operations
@@ -826,6 +830,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	rdi->ibdev.node_type = RDMA_NODE_IB_CA;
 	rdi->ibdev.num_comp_vectors = 1;
 
+	rdi->ibdev.specs_root = &root;
 	/* We are now good to announce we exist */
 	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 	if (ret) {
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e..cf4eef8 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -32,6 +32,8 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <net/addrconf.h>
 #include "rxe.h"
 #include "rxe_loc.h"
@@ -1227,6 +1229,8 @@ static ssize_t rxe_show_parent(struct device *device,
 	&dev_attr_parent,
 };
 
+static DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int rxe_register_device(struct rxe_dev *rxe)
 {
 	int err;
@@ -1334,6 +1338,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 		return PTR_ERR(rxe->tfm);
 	}
 
+	dev->specs_root = &root;
 	err = ib_register_device(dev, NULL);
 	if (err) {
 		pr_warn("rxe_register_device failed, err = %d\n", err);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
