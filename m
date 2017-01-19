From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/5] IB: Query port through the core instead of directly calling the driver handler
Date: Thu, 19 Jan 2017 07:41:02 +0200
Message-ID: <20170119054102.20135-6-leon@kernel.org>
References: <20170119054102.20135-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119054102.20135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change the drivers to call ib_query_port in their get port
immutable handler instead of their own query port handler.

Doing this required to set the core cap flags of this device
before the ib_query_port call is made, since the IB core might
need these caps to serve the port query.

Drivers are ensured by the IB core that the port attributes passed
to the port query verb implementation are zero, and hence we
removed the zeroing from the drivers.

This patch doesn't add any new functionality.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c     |  7 ++++---
 drivers/infiniband/hw/cxgb4/provider.c          |  8 ++++----
 drivers/infiniband/hw/hfi1/verbs.c              |  1 +
 drivers/infiniband/hw/hns/hns_roce_main.c       |  7 ++++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       |  8 ++++----
 drivers/infiniband/hw/mlx4/alias_GUID.c         |  1 +
 drivers/infiniband/hw/mlx4/main.c               | 18 +++++++++---------
 drivers/infiniband/hw/mlx4/sysfs.c              |  1 +
 drivers/infiniband/hw/mlx5/mad.c                |  2 +-
 drivers/infiniband/hw/mlx5/main.c               | 11 +++++++----
 drivers/infiniband/hw/mthca/mthca_provider.c    |  9 +++++----
 drivers/infiniband/hw/nes/nes_verbs.c           |  5 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c      |  9 +++++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     |  1 +
 drivers/infiniband/hw/qedr/verbs.c              |  9 +++++----
 drivers/infiniband/hw/qib/qib_verbs.c           |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c     |  5 +++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c  |  5 +++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  4 ++--
 drivers/infiniband/sw/rdmavt/vt.c               |  7 ++++---
 drivers/infiniband/sw/rxe/rxe_verbs.c           |  6 ++++--
 22 files changed, 73 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 9d5fe18..9e39252 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1133,7 +1133,7 @@ static int iwch_query_port(struct ib_device *ibdev,
 	dev = to_iwch_dev(ibdev);
 	netdev = dev->rdev.port_info.lldevs[port-1];
 
-	memset(props, 0, sizeof(struct ib_port_attr));
+	/* props being zeroed by the caller, avoid zeroing it here */
 	props->max_mtu = IB_MTU_4096;
 	if (netdev->mtu >= 4096)
 		props->active_mtu = IB_MTU_4096;
@@ -1338,13 +1338,14 @@ static int iwch_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = iwch_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 49b51b7..5b00b50a 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -358,8 +358,7 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 
 	dev = to_c4iw_dev(ibdev);
 	netdev = dev->rdev.lldi.ports[port-1];
-
-	memset(props, 0, sizeof(struct ib_port_attr));
+	/* props being zeroed by the caller, avoid zeroing it here */
 	props->max_mtu = IB_MTU_4096;
 	if (netdev->mtu >= 4096)
 		props->active_mtu = IB_MTU_4096;
@@ -505,13 +504,14 @@ static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = c4iw_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 95ed4d6..f2d4e04 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1384,6 +1384,7 @@ static int query_port(struct rvt_dev_info *rdi, u8 port_num,
 	struct hfi1_pportdata *ppd = &dd->pport[port_num - 1];
 	u16 lid = ppd->lid;
 
+	/* props being zeroed by the caller, avoid zeroing it here */
 	props->lid = lid ? lid : 0;
 	props->lmc = ppd->lmc;
 	/* OPA logical states match IB logical states */
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 4953d9c..7be8158 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -249,7 +249,7 @@ static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
 	assert(port_num > 0);
 	port = port_num - 1;
 
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->max_mtu = hr_dev->caps.max_mtu;
 	props->gid_tbl_len = hr_dev->caps.gid_table_len[port];
@@ -400,14 +400,15 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
 	struct ib_port_attr attr;
 	int ret;
 
-	ret = hns_roce_query_port(ib_dev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+
+	ret = ib_query_port(ib_dev, port_num, &attr);
 	if (ret)
 		return ret;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 29e97df..3e83048 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -97,8 +97,7 @@ static int i40iw_query_port(struct ib_device *ibdev,
 	struct i40iw_device *iwdev = to_iwdev(ibdev);
 	struct net_device *netdev = iwdev->netdev;
 
-	memset(props, 0, sizeof(*props));
-
+	/* props being zeroed by the caller, avoid zeroing it here */
 	props->max_mtu = IB_MTU_4096;
 	if (netdev->mtu >= 4096)
 		props->active_mtu = IB_MTU_4096;
@@ -2506,14 +2505,15 @@ static int i40iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = i40iw_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 06020c5..4648374 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
 	struct list_head *head =
 		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
 
+	memset(&attr, 0, sizeof(struct ib_port_attr));
 	err = __mlx4_ib_query_port(ibdev, port, &attr, 1);
 	if (err) {
 		pr_debug("mlx4_ib_query_port failed (err: %d), port: %d\n",
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7019b94..646dcbf 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -741,7 +741,7 @@ int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 {
 	int err;
 
-	memset(props, 0, sizeof *props);
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
 		ib_link_query_port(ibdev, port, props, netw_view) :
@@ -1014,7 +1014,7 @@ static int mlx4_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
 
 	mutex_lock(&mdev->cap_mask_mutex);
 
-	err = mlx4_ib_query_port(ibdev, port, &attr);
+	err = ib_query_port(ibdev, port, &attr);
 	if (err)
 		goto out;
 
@@ -2527,13 +2527,6 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
 	int err;
 
-	err = mlx4_ib_query_port(ibdev, port_num, &attr);
-	if (err)
-		return err;
-
-	immutable->pkey_tbl_len = attr.pkey_tbl_len;
-	immutable->gid_tbl_len = attr.gid_tbl_len;
-
 	if (mlx4_ib_port_link_layer(ibdev, port_num) == IB_LINK_LAYER_INFINIBAND) {
 		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 		immutable->max_mad_size = IB_MGMT_MAD_SIZE;
@@ -2549,6 +2542,13 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 			immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 	}
 
+	err = ib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 69fb5ba..5835165 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -226,6 +226,7 @@ static int add_port_entries(struct mlx4_ib_dev *device, int port_num)
 	int ret = 0 ;
 	struct ib_port_attr attr;
 
+	memset(&attr, 0, sizeof(struct ib_port_attr));
 	/* get the physical gid and pkey table sizes.*/
 	ret = __mlx4_ib_query_port(&device->ib_dev, port_num, &attr, 1);
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 39e5848..4e58b8f 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -515,7 +515,7 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
 	if (!in_mad || !out_mad)
 		goto out;
 
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	init_query_mad(in_mad);
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4e8e78f..176417b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -174,7 +174,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	enum ib_mtu ndev_ib_mtu;
 	u16 qkey_viol_cntr;
 
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->port_cap_flags  |= IB_PORT_CM_SUP;
 	props->port_cap_flags  |= IB_PORT_IP_BASED_GIDS;
@@ -830,7 +830,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
 		goto out;
 	}
 
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	err = mlx5_query_hca_vport_context(mdev, 0, port, 0, rep);
 	if (err)
@@ -978,7 +978,7 @@ static int mlx5_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
 
 	mutex_lock(&dev->cap_mask_mutex);
 
-	err = mlx5_ib_query_port(ibdev, port, &attr);
+	err = ib_query_port(ibdev, port, &attr);
 	if (err)
 		goto out;
 
@@ -2564,6 +2564,7 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
 	}
 
 	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports); port++) {
+		memset(pprops, 0, sizeof(struct ib_port_attr));
 		err = mlx5_ib_query_port(&dev->ib_dev, port, pprops);
 		if (err) {
 			mlx5_ib_warn(dev, "query_port %d failed %d\n",
@@ -2883,7 +2884,9 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, port_num);
 	int err;
 
-	err = mlx5_ib_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = get_core_cap_flags(ibdev);
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index d317087..ce16318 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -146,7 +146,7 @@ static int mthca_query_port(struct ib_device *ibdev,
 	if (!in_mad || !out_mad)
 		goto out;
 
-	memset(props, 0, sizeof *props);
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	init_query_mad(in_mad);
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
@@ -212,7 +212,7 @@ static int mthca_modify_port(struct ib_device *ibdev,
 	if (mutex_lock_interruptible(&to_mdev(ibdev)->cap_mask_mutex))
 		return -ERESTARTSYS;
 
-	err = mthca_query_port(ibdev, port, &attr);
+	err = ib_query_port(ibdev, port, &attr);
 	if (err)
 		goto out;
 
@@ -1166,13 +1166,14 @@ static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = mthca_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index aff9fb1..b7179f4 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -475,7 +475,7 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	struct nes_vnic *nesvnic = to_nesvnic(ibdev);
 	struct net_device *netdev = nesvnic->netdev;
 
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->max_mtu = IB_MTU_4096;
 
@@ -3670,13 +3670,14 @@ static int nes_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+
 	err = nes_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 8960715..3e43bdc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -93,15 +93,16 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 	int err;
 
 	dev = get_ocrdma_dev(ibdev);
-	err = ocrdma_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	if (ocrdma_is_udp_encap_supported(dev))
+		immutable->core_cap_flags |= RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
-	if (ocrdma_is_udp_encap_supported(dev))
-		immutable->core_cap_flags |= RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 6af44f8..013d15c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -210,6 +210,7 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	struct ocrdma_dev *dev;
 	struct net_device *netdev;
 
+	/* props being zeroed by the caller, avoid zeroing it here */
 	dev = get_ocrdma_dev(ibdev);
 	if (port > 1) {
 		pr_err("%s(%d) invalid_port=0x%x\n", __func__,
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 57c8de2..91a16d3 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -238,8 +238,8 @@ int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
 	}
 
 	rdma_port = dev->ops->rdma_query_port(dev->rdma_ctx);
-	memset(attr, 0, sizeof(*attr));
 
+	/* *attr being zeroed by the caller, avoid zeroing it here */
 	if (rdma_port->port_state == QED_RDMA_PORT_UP) {
 		attr->state = IB_PORT_ACTIVE;
 		attr->phys_state = 5;
@@ -3549,14 +3549,15 @@ int qedr_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = qedr_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
+				    RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
-				    RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 4b54c0d..9161574 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1303,6 +1303,7 @@ static int qib_query_port(struct rvt_dev_info *rdi, u8 port_num,
 	enum ib_mtu mtu;
 	u16 lid = ppd->lid;
 
+	/* props being zeroed by the caller, avoid zeroing it here */
 	props->lid = lid ? lid : be16_to_cpu(IB_LID_PERMISSIVE);
 	props->lmc = ppd->lmc;
 	props->state = dd->f_iblink_state(ppd->lastibcstat);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index dde0b23..4f5a45d 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -321,11 +321,12 @@ static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = usnic_ib_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_USNIC;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
-	immutable->core_cap_flags = RDMA_CORE_PORT_USNIC;
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 74819a7..0ba274f 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -330,7 +330,7 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 
 	mutex_lock(&us_ibdev->usdev_lock);
 	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->lid = 0;
 	props->lmc = 1;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 231a1ce..b8b0081 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -132,13 +132,14 @@ static int pvrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 	struct ib_port_attr attr;
 	int err;
 
-	err = pvrdma_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 	return 0;
 }
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index 5489137..b3a982b 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -135,7 +135,7 @@ int pvrdma_query_port(struct ib_device *ibdev, u8 port,
 		return err;
 	}
 
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->state = pvrdma_port_state_to_ib(resp->attrs.state);
 	props->max_mtu = pvrdma_mtu_to_ib(resp->attrs.max_mtu);
@@ -275,7 +275,7 @@ int pvrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
 	}
 
 	mutex_lock(&vdev->port_mutex);
-	ret = pvrdma_query_port(ibdev, port, &attr);
+	ret = ib_query_port(ibdev, port, &attr);
 	if (ret)
 		goto out;
 
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d430c2f..1165639 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -165,7 +165,7 @@ static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
 		return -EINVAL;
 
 	rvp = rdi->ports[port_index];
-	memset(props, 0, sizeof(*props));
+	/* props being zeroed by the caller, avoid zeroing it here */
 	props->sm_lid = rvp->sm_lid;
 	props->sm_sl = rvp->sm_sl;
 	props->port_cap_flags = rvp->port_cap_flags;
@@ -326,13 +326,14 @@ static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 	if (port_index < 0)
 		return -EINVAL;
 
-	err = rvt_query_port(ibdev, port_num, &attr);
+	immutable->core_cap_flags = rdi->dparms.core_cap_flags;
+
+	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = rdi->dparms.core_cap_flags;
 	immutable->max_mad_size = rdi->dparms.max_mad_size;
 
 	return 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index beb7021..371ef3b 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -86,6 +86,7 @@ static int rxe_query_port(struct ib_device *dev,
 
 	port = &rxe->port;
 
+	/* *attr being zeroed by the caller, avoid zeroing it here */
 	*attr = port->attr;
 
 	mutex_lock(&rxe->usdev_lock);
@@ -261,13 +262,14 @@ static int rxe_port_immutable(struct ib_device *dev, u8 port_num,
 	int err;
 	struct ib_port_attr attr;
 
-	err = rxe_query_port(dev, port_num, &attr);
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+
+	err = ib_query_port(dev, port_num, &attr);
 	if (err)
 		return err;
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
