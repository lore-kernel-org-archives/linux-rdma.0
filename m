From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/5] RDMA: Convert IB drivers to name allocation routine
Date: Thu, 20 Sep 2018 14:22:00 +0300
Message-ID: <20180920112202.9181-4-leon@kernel.org>
References: <20180920112202.9181-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920112202.9181-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Move internal implementation of device name to the IB/core.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/device.c               | 5 -----
 drivers/infiniband/hw/bnxt_re/main.c           | 6 +++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    | 5 ++++-
 drivers/infiniband/hw/cxgb4/provider.c         | 5 ++++-
 drivers/infiniband/hw/hns/hns_roce_main.c      | 4 +++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      | 7 ++++++-
 drivers/infiniband/hw/mlx4/main.c              | 7 ++++++-
 drivers/infiniband/hw/mlx5/main.c              | 4 +++-
 drivers/infiniband/hw/mthca/mthca_provider.c   | 5 ++++-
 drivers/infiniband/hw/nes/nes_verbs.c          | 6 +++++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     | 7 ++++++-
 drivers/infiniband/hw/qedr/main.c              | 4 +++-
 drivers/infiniband/hw/usnic/usnic_ib_main.c    | 5 ++++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 9 ++++++---
 drivers/infiniband/sw/rxe/rxe_verbs.c          | 5 ++++-
 15 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 3270cde6d806..a9bc2a3f490c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -518,11 +518,6 @@ int ib_register_device(struct ib_device *device,

 	mutex_lock(&device_mutex);

-	if (strchr(device->name, '%')) {
-		ret = alloc_name(device->name);
-		if (ret)
-			goto out;
-
 	if (ib_device_check_mandatory(device)) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 20b9f31052bf..5255e5ffd6f4 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -575,11 +575,15 @@ static void bnxt_re_unregister_ib(struct bnxt_re_dev *rdev)
 static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 {
 	struct ib_device *ibdev = &rdev->ibdev;
+	int ret;

 	/* ib device init */
 	ibdev->owner = THIS_MODULE;
 	ibdev->node_type = RDMA_NODE_IB_CA;
-	strlcpy(ibdev->name, "bnxt_re%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(ibdev, "bnxt_re%d");
+	if (ret)
+		return ret;
+
 	strlcpy(ibdev->node_desc, BNXT_RE_DESC " HCA",
 		strlen(BNXT_RE_DESC) + 5);
 	ibdev->phys_port_cnt = 1;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 1b9ff21aa1d5..3680d80036eb 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1319,7 +1319,10 @@ int iwch_register_device(struct iwch_dev *dev)
 	int i;

 	pr_debug("%s iwch_dev %p\n", __func__, dev);
-	strlcpy(dev->ibdev.name, "cxgb3_%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(&dev->ibdev, "cxgb3_%d");
+	if (ret)
+		return ret;
+
 	memset(&dev->ibdev.node_guid, 0, sizeof(dev->ibdev.node_guid));
 	memcpy(&dev->ibdev.node_guid, dev->rdev.t3cdev_p->lldev->dev_addr, 6);
 	dev->ibdev.owner = THIS_MODULE;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 4eda6872e617..37d40cbdf0dc 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -535,7 +535,10 @@ void c4iw_register_device(struct work_struct *work)
 	struct c4iw_dev *dev = ctx->dev;

 	pr_debug("c4iw_dev %p\n", dev);
-	strlcpy(dev->ibdev.name, "cxgb4_%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(&dev->ibdev, "cxgb4_%d");
+	if (ret)
+		return;
+
 	memset(&dev->ibdev.node_guid, 0, sizeof(dev->ibdev.node_guid));
 	memcpy(&dev->ibdev.node_guid, dev->rdev.lldi.ports[0]->dev_addr, 6);
 	dev->ibdev.owner = THIS_MODULE;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 6edb547baee8..e16f72692c83 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -449,7 +449,9 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	spin_lock_init(&iboe->lock);

 	ib_dev = &hr_dev->ib_dev;
-	strlcpy(ib_dev->name, "hns_%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(ib_dev, "hns_%d");
+	if (ret)
+		return ret;

 	ib_dev->owner			= THIS_MODULE;
 	ib_dev->node_type		= RDMA_NODE_IB_CA;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index e2e6c74a7452..829be11da4e7 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2746,13 +2746,18 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	struct i40iw_ib_device *iwibdev;
 	struct net_device *netdev = iwdev->netdev;
 	struct pci_dev *pcidev = (struct pci_dev *)iwdev->hw.dev_context;
+	int ret;

 	iwibdev = (struct i40iw_ib_device *)ib_alloc_device(sizeof(*iwibdev));
 	if (!iwibdev) {
 		i40iw_pr_err("iwdev == NULL\n");
 		return NULL;
 	}
-	strlcpy(iwibdev->ibdev.name, "i40iw%d", IB_DEVICE_NAME_MAX);
+
+	ret = ib_device_alloc_name(&iwibdev->ibdev, "i40iw%d");
+	if (ret)
+		return NULL;
+
 	iwibdev->ibdev.owner = THIS_MODULE;
 	iwdev->iwibdev = iwibdev;
 	iwibdev->iwdev = iwdev;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bf3cdb88aaf5..8edbc50d298a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2540,7 +2540,10 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->dev = dev;
 	ibdev->bond_next_port	= 0;

-	strlcpy(ibdev->ib_dev.name, "mlx4_%d", IB_DEVICE_NAME_MAX);
+	err = ib_device_alloc_name(&ibdev->ib_dev, "mlx4_%d");
+	if (err)
+		goto err_name;
+
 	ibdev->ib_dev.owner		= THIS_MODULE;
 	ibdev->ib_dev.node_type		= RDMA_NODE_IB_CA;
 	ibdev->ib_dev.local_dma_lkey	= dev->caps.reserved_lkey;
@@ -2882,6 +2885,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)

 err_map:
 	mlx4_ib_free_eqs(dev, ibdev);
+
+err_name:
 	iounmap(ibdev->uar_map);

 err_uar:
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 73782100750d..a4a578ba72ee 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5698,8 +5698,10 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		name = "mlx5_%d";
 	else
 		name = "mlx5_bond_%d";
+	err = ib_device_alloc_name(&dev->ib_dev, name);
+	if (err)
+		goto err_mp;

-	strlcpy(dev->ib_dev.name, name, IB_DEVICE_NAME_MAX);
 	dev->ib_dev.owner		= THIS_MODULE;
 	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
 	dev->ib_dev.local_dma_lkey	= 0 /* not supported for now */;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 0d3473b4596e..67ff3ecdf8d5 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1198,7 +1198,10 @@ int mthca_register_device(struct mthca_dev *dev)
 	if (ret)
 		return ret;

-	strlcpy(dev->ib_dev.name, "mthca%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(&dev->ib_dev, "mthca%d");
+	if (ret)
+		return ret;
+
 	dev->ib_dev.owner                = THIS_MODULE;

 	dev->ib_dev.uverbs_abi_ver	 = MTHCA_UVERBS_ABI_VERSION;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 6940c7215961..7394d50b02f5 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3635,12 +3635,16 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	struct nes_ib_device *nesibdev;
 	struct nes_vnic *nesvnic = netdev_priv(netdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
+	int ret;

 	nesibdev = (struct nes_ib_device *)ib_alloc_device(sizeof(struct nes_ib_device));
 	if (nesibdev == NULL) {
 		return NULL;
 	}
-	strlcpy(nesibdev->ibdev.name, "nes%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(&nesibdev->ibdev, "nes%d");
+	if (ret)
+		return NULL;
+
 	nesibdev->ibdev.owner = THIS_MODULE;

 	nesibdev->ibdev.node_type = RDMA_NODE_RNIC;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 7832ee3e0c84..34f7d8f31ee1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -116,7 +116,12 @@ static void get_dev_fw_str(struct ib_device *device, char *str)

 static int ocrdma_register_device(struct ocrdma_dev *dev)
 {
-	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
+	int ret;
+
+	ret = ib_device_alloc_name(&dev->ibdev, "ocrdma%d");
+	if (ret)
+		return ret;
+
 	ocrdma_get_guid(dev, (u8 *)&dev->ibdev.node_guid);
 	BUILD_BUG_ON(sizeof(OCRDMA_NODE_DESC) > IB_DEVICE_NODE_DESC_MAX);
 	memcpy(dev->ibdev.node_desc, OCRDMA_NODE_DESC,
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index a0af6d424aed..43e14f6b1c6d 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -170,7 +170,9 @@ static int qedr_register_device(struct qedr_dev *dev)
 {
 	int rc;

-	strlcpy(dev->ibdev.name, "qedr%d", IB_DEVICE_NAME_MAX);
+	rc = ib_device_alloc_name(&dev->ibdev, "qedr%d");
+	if (rc)
+		return rc;

 	dev->ibdev.node_guid = dev->attr.node_guid;
 	memcpy(dev->ibdev.node_desc, QEDR_NODE_DESC, sizeof(QEDR_NODE_DESC));
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index f0538a460328..15f1509cac8d 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -335,6 +335,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	union ib_gid gid;
 	struct in_device *ind;
 	struct net_device *netdev;
+	int ret;

 	usnic_dbg("\n");
 	netdev = pci_get_drvdata(dev);
@@ -364,7 +365,9 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.num_comp_vectors = USNIC_IB_NUM_COMP_VECTORS;
 	us_ibdev->ib_dev.dev.parent = &dev->dev;
 	us_ibdev->ib_dev.uverbs_abi_ver = USNIC_UVERBS_ABI_VERSION;
-	strlcpy(us_ibdev->ib_dev.name, "usnic_%d", IB_DEVICE_NAME_MAX);
+	ret = ib_device_alloc_name(&us_ibdev->ib_dev, "usnic_%d");
+	if (ret)
+		goto err_fwd_dealloc;

 	us_ibdev->ib_dev.uverbs_cmd_mask =
 		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT) |
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index a5719899f49a..afe84d55bb52 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -159,10 +159,13 @@ static struct net_device *pvrdma_get_netdev(struct ib_device *ibdev,

 static int pvrdma_register_device(struct pvrdma_dev *dev)
 {
-	int ret = -1;
 	int i = 0;
+	int ret;
+
+	ret = ib_device_alloc_name(&dev->ib_dev, "vmw_pvrdma%d");
+	if (ret)
+		return ret;

-	strlcpy(dev->ib_dev.name, "vmw_pvrdma%d", IB_DEVICE_NAME_MAX);
 	dev->ib_dev.node_guid = dev->dsr->caps.node_guid;
 	dev->sys_image_guid = dev->dsr->caps.sys_image_guid;
 	dev->flags = 0;
@@ -235,7 +238,7 @@ static int pvrdma_register_device(struct pvrdma_dev *dev)
 	dev->cq_tbl = kcalloc(dev->dsr->caps.max_cq, sizeof(struct pvrdma_cq *),
 			      GFP_KERNEL);
 	if (!dev->cq_tbl)
-		return ret;
+		return -ENOMEM;
 	spin_lock_init(&dev->cq_tbl_lock);

 	dev->qp_tbl = kcalloc(dev->dsr->caps.max_qp, sizeof(struct pvrdma_qp *),
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index f5b1e0ad6142..2b017bfeecda 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1159,7 +1159,10 @@ int rxe_register_device(struct rxe_dev *rxe)
 	struct ib_device *dev = &rxe->ib_dev;
 	struct crypto_shash *tfm;

-	strlcpy(dev->name, "rxe%d", IB_DEVICE_NAME_MAX);
+	err = ib_device_alloc_name(dev, "rxe%d");
+	if (err)
+		return err;
+
 	strlcpy(dev->node_desc, "rxe", sizeof(dev->node_desc));

 	dev->owner = THIS_MODULE;
