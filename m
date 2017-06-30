From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/core, opa_vnic, hfi1,
 mlx5: Properly free rdma_netdev
Date: Fri, 30 Jun 2017 13:14:46 -0700
Message-ID: <20170630201445.5213.82089.stgit@scvm10.sc.intel.com>
References: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170630201236.5213.72919.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

IPOIB is calling free_rdma_netdev even though alloc_rdma_netdev has
returned -EOPNOTSUPP.
Move free_rdma_netdev from ib_device structure to rdma_netdev structure
thus ensuring proper cleanup function is called for the rdma net device.

Fix the following trace:

ib0: Failed to modify QP to ERROR state
BUG: unable to handle kernel paging request at 0000000000001d20
IP: hfi1_vnic_free_rn+0x26/0xb0 [hfi1]
Call Trace:
 ipoib_remove_one+0xbe/0x160 [ib_ipoib]
 ib_unregister_device+0xd0/0x170 [ib_core]
 rvt_unregister_device+0x29/0x90 [rdmavt]
 hfi1_unregister_ib_device+0x1a/0x100 [hfi1]
 remove_one+0x4b/0x220 [hfi1]
 pci_device_remove+0x39/0xc0
 device_release_driver_internal+0x141/0x200
 driver_detach+0x3f/0x80
 bus_remove_driver+0x55/0xd0
 driver_unregister+0x2c/0x50
 pci_unregister_driver+0x2a/0xa0
 hfi1_mod_cleanup+0x10/0xf65 [hfi1]
 SyS_delete_module+0x171/0x250
 do_syscall_64+0x67/0x150
 entry_SYSCALL64_slow_path+0x25/0x25

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c                |    1 -
 drivers/infiniband/hw/hfi1/vnic.h                 |    1 -
 drivers/infiniband/hw/hfi1/vnic_main.c            |   19 +++++++++--------
 drivers/infiniband/hw/mlx5/main.c                 |   24 +++++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_main.c         |    8 ++++---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |    8 ++++---
 include/rdma/ib_verbs.h                           |    6 ++++-
 7 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 8a63a7e..720e71d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1770,7 +1770,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->alloc_hw_stats = alloc_hw_stats;
 	ibdev->get_hw_stats = get_hw_stats;
 	ibdev->alloc_rdma_netdev = hfi1_vnic_alloc_rn;
-	ibdev->free_rdma_netdev = hfi1_vnic_free_rn;
 
 	/* keep process mad in the driver */
 	ibdev->process_mad = hfi1_process_mad;
diff --git a/drivers/infiniband/hw/hfi1/vnic.h b/drivers/infiniband/hw/hfi1/vnic.h
index e2c4552..4a621cd 100644
--- a/drivers/infiniband/hw/hfi1/vnic.h
+++ b/drivers/infiniband/hw/hfi1/vnic.h
@@ -176,7 +176,6 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 				      const char *name,
 				      unsigned char name_assign_type,
 				      void (*setup)(struct net_device *));
-void hfi1_vnic_free_rn(struct net_device *netdev);
 int hfi1_vnic_send_dma(struct hfi1_devdata *dd, u8 q_idx,
 		       struct hfi1_vnic_vport_info *vinfo,
 		       struct sk_buff *skb, u64 pbc, u8 plen);
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 950c1b4..5a3f80b 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -836,6 +836,15 @@ static void hfi1_vnic_set_vesw_id(struct net_device *netdev, int id)
 	.ndo_get_stats64 = hfi1_vnic_get_stats64,
 };
 
+static void hfi1_vnic_free_rn(struct net_device *netdev)
+{
+	struct hfi1_vnic_vport_info *vinfo = opa_vnic_dev_priv(netdev);
+
+	hfi1_vnic_deinit(vinfo);
+	mutex_destroy(&vinfo->lock);
+	free_netdev(netdev);
+}
+
 struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 				      u8 port_num,
 				      enum rdma_netdev_t type,
@@ -867,6 +876,7 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	vinfo->num_tx_q = dd->chip_sdma_engines;
 	vinfo->num_rx_q = HFI1_NUM_VNIC_CTXT;
 	vinfo->netdev = netdev;
+	rn->free_rdma_netdev = hfi1_vnic_free_rn;
 	rn->set_id = hfi1_vnic_set_vesw_id;
 
 	netdev->features = NETIF_F_HIGHDMA | NETIF_F_SG;
@@ -895,12 +905,3 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	free_netdev(netdev);
 	return ERR_PTR(rc);
 }
-
-void hfi1_vnic_free_rn(struct net_device *netdev)
-{
-	struct hfi1_vnic_vport_info *vinfo = opa_vnic_dev_priv(netdev);
-
-	hfi1_vnic_deinit(vinfo);
-	mutex_destroy(&vinfo->lock);
-	free_netdev(netdev);
-}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9ecc089..cec5932 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3542,6 +3542,11 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
+{
+	return mlx5_rdma_netdev_free(netdev);
+}
+
 static struct net_device*
 mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
 			  u8 port_num,
@@ -3550,16 +3555,18 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 			  unsigned char name_assign_type,
 			  void (*setup)(struct net_device *))
 {
+	struct net_device *netdev;
+	struct rdma_netdev *rn;
+
 	if (type != RDMA_NETDEV_IPOIB)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	return mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
-				      name, setup);
-}
+	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
+					name, setup);
+	rn = netdev_priv(netdev);
+	rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
 
-static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
-{
-	return mlx5_rdma_netdev_free(netdev);
+	return netdev;
 }
 
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
@@ -3692,10 +3699,9 @@ static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
 	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
-	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads)) {
+	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads))
 		dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
-		dev->ib_dev.free_rdma_netdev	= mlx5_ib_free_rdma_netdev;
-	}
+
 	if (mlx5_core_is_pf(mdev)) {
 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
 		dev->ib_dev.set_vf_link_state	= mlx5_ib_set_vf_link_state;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1015a63..9ec0dbe 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1893,6 +1893,7 @@ static void ipoib_build_priv(struct net_device *dev)
 	rn->send = ipoib_send;
 	rn->attach_mcast = ipoib_mcast_attach;
 	rn->detach_mcast = ipoib_mcast_detach;
+	rn->free_rdma_netdev = free_netdev;
 	rn->hca = hca;
 
 	dev->netdev_ops = &ipoib_netdev_default_pf;
@@ -2288,6 +2289,8 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		return;
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
+		struct rdma_netdev *rn = netdev_priv(priv->dev);
+
 		ib_unregister_event_handler(&priv->event_handler);
 		flush_workqueue(ipoib_workqueue);
 
@@ -2304,10 +2307,7 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		flush_workqueue(priv->wq);
 
 		unregister_netdev(priv->dev);
-		if (device->free_rdma_netdev)
-			device->free_rdma_netdev(priv->dev);
-		else
-			free_netdev(priv->dev);
+		rn->free_rdma_netdev(priv->dev);
 
 		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list)
 			kfree(cpriv);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index 905f39d..5c656c7 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -323,13 +323,13 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 	else if (IS_ERR(netdev))
 		return ERR_CAST(netdev);
 
+	rn = netdev_priv(netdev);
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
 	if (!adapter) {
 		rc = -ENOMEM;
 		goto adapter_err;
 	}
 
-	rn = netdev_priv(netdev);
 	rn->clnt_priv = adapter;
 	rn->hca = ibdev;
 	rn->port_num = port_num;
@@ -367,7 +367,7 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 	mutex_destroy(&adapter->stats_lock);
 	kfree(adapter);
 adapter_err:
-	ibdev->free_rdma_netdev(netdev);
+	rn->free_rdma_netdev(netdev);
 
 	return ERR_PTR(rc);
 }
@@ -376,7 +376,7 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 void opa_vnic_rem_netdev(struct opa_vnic_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct ib_device *ibdev = adapter->ibdev;
+	struct rdma_netdev *rn = netdev_priv(netdev);
 
 	v_info("removing\n");
 	unregister_netdev(netdev);
@@ -385,5 +385,5 @@ void opa_vnic_rem_netdev(struct opa_vnic_adapter *adapter)
 	mutex_destroy(&adapter->mactbl_lock);
 	mutex_destroy(&adapter->stats_lock);
 	kfree(adapter);
-	ibdev->free_rdma_netdev(netdev);
+	rn->free_rdma_netdev(netdev);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9d4d2a7..8c78657 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1930,6 +1930,9 @@ struct rdma_netdev {
 	struct ib_device  *hca;
 	u8                 port_num;
 
+	/* cleanup function must be specified */
+	void (*free_rdma_netdev)(struct net_device *netdev);
+
 	/* control functions */
 	void (*set_id)(struct net_device *netdev, int id);
 	/* send packet */
@@ -2197,7 +2200,7 @@ struct ib_device {
 							   struct ib_udata *udata);
 	int                        (*destroy_rwq_ind_table)(struct ib_rwq_ind_table *wq_ind_table);
 	/**
-	 * rdma netdev operations
+	 * rdma netdev operation
 	 *
 	 * Driver implementing alloc_rdma_netdev must return -EOPNOTSUPP if it
 	 * doesn't support the specified rdma netdev type.
@@ -2209,7 +2212,6 @@ struct ib_device {
 					const char *name,
 					unsigned char name_assign_type,
 					void (*setup)(struct net_device *));
-	void (*free_rdma_netdev)(struct net_device *netdev);
 
 	struct module               *owner;
 	struct device                dev;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
