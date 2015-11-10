From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read access flags
Date: Tue, 10 Nov 2015 12:44:13 +0200
Message-ID: <1447152255-28231-2-git-send-email-sagig@mellanox.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447152255-28231-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Different devices may require different access permissions
for rdma reads e.g. for Infiniband devices, local write access
suffices while iWARP devices require remote write permissions as
well.

This situation generates extra logic for ULPs that need to be aware
of the underlying device to determine rdma read access. Instead,
add a device attribute for ULPs to use without being aware of the
underlying device.

Also, set rdma_read_access_flags in the relevant device drivers:
mlx4, mlx5, qib, ocrdma, nes: IB_ACCESS_LOCAL_WRITE
cxgb3, cxgb4, hfi: IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c  | 2 ++
 drivers/infiniband/hw/cxgb4/provider.c       | 2 ++
 drivers/infiniband/hw/mlx4/main.c            | 1 +
 drivers/infiniband/hw/mlx5/main.c            | 1 +
 drivers/infiniband/hw/mthca/mthca_provider.c | 1 +
 drivers/infiniband/hw/nes/nes_verbs.c        | 2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   | 1 +
 drivers/infiniband/hw/qib/qib_verbs.c        | 1 +
 drivers/staging/rdma/hfi1/verbs.c            | 2 ++
 include/rdma/ib_verbs.h                      | 1 +
 10 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index db4c08c53ae3..483ae3c8a13b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1467,6 +1467,8 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.max_pd = dev->attr.max_pds;
 	dev->ibdev.local_ca_ack_delay = 0;
 	dev->ibdev.max_fast_reg_page_list_len = T3_MAX_FASTREG_DEPTH;
+	ibdev->rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE |
+					IB_ACCESS_REMOTE_WRITE;
 
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 84e9b5db0341..001db1cc737c 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -564,6 +564,8 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.max_pd = T4_MAX_NUM_PD;
 	dev->ibdev.local_ca_ack_delay = 0;
 	dev->ibdev.max_fast_reg_page_list_len = t4_max_fr_depth(use_dsgl);
+	dev->ibdev.rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE |
+					    IB_ACCESS_REMOTE_WRITE;
 
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 46305dc27f9f..82af524dfb4e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -524,6 +524,7 @@ static int mlx4_ib_init_device_flags(struct ib_device *ibdev)
 	ibdev->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
 	ibdev->hca_core_clock = dev->dev->caps.hca_core_clock * 1000UL;
 	ibdev->timestamp_mask = 0xFFFFFFFFFFFFULL;
+	ibdev->rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE;
 
 	if (!mlx4_is_slave(dev->dev))
 		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5b733221ca5f..b29f79a03494 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -287,6 +287,7 @@ static int mlx5_ib_init_device_flags(struct ib_device *ibdev)
 	ibdev->max_total_mcast_qp_attach = ibdev->max_mcast_qp_attach *
 					   ibdev->max_mcast_grp;
 	ibdev->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
+	ibdev->rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(mdev, pg))
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 28d7a8bee3f7..ea1882bbe7a5 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -110,6 +110,7 @@ static int mthca_init_device_flags(struct ib_device *ibdev)
 	ibdev->max_mcast_qp_attach = MTHCA_QP_PER_MGM;
 	ibdev->max_total_mcast_qp_attach = ibdev->max_mcast_qp_attach *
 					   ibdev->max_mcast_grp;
+	ibdev->rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE;
 	/*
 	 * If Sinai memory key optimization is being used, then only
 	 * the 8-bit key portion will change.  For other HCAs, the
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 2ef911953e38..adcea173f8dc 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3868,6 +3868,8 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.max_mw = nesibdev->max_mr;
 	nesibdev->ibdev.max_pd = nesibdev->max_pd;
 	nesibdev->ibdev.max_sge_rd = 1;
+	nesibdev->ibdev.rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE;
+
 	switch (nesdev->nesadapter->max_irrq_wr) {
 		case 0:
 			nesibdev->ibdev.max_qp_rd_atom = 2;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 00ddcf9294e4..235bc90bf2c6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -244,6 +244,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.local_ca_ack_delay = dev->attr.local_ca_ack_delay;
 	dev->ibdev.max_fast_reg_page_list_len = dev->attr.max_pages_per_frmr;
 	dev->ibdev.max_pkeys = 1;
+	dev->ibdev.rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE;
 
 	return ib_register_device(&dev->ibdev, NULL);
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9e1af0b9857a..be84307611c4 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2257,6 +2257,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->max_mcast_qp_attach = ib_qib_max_mcast_qp_attached;
 	ibdev->max_total_mcast_qp_attach = ibdev->max_mcast_qp_attach *
 		ibdev->max_mcast_grp;
+	ibdev->rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
 		 "Intel Infiniband HCA %s", init_utsname()->nodename);
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 664548a62e4d..d3e0dd27a8e2 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2062,6 +2062,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->max_mcast_qp_attach = hfi1_max_mcast_qp_attached;
 	ibdev->max_total_mcast_qp_attach = ibdev->max_mcast_qp_attach *
 		ibdev->max_mcast_grp;
+	ibdev->rdma_read_access_flags = IB_ACCESS_LOCAL_WRITE |
+					IB_ACCESS_REMOTE_WRITE;
 
 	strncpy(ibdev->node_desc, init_utsname()->nodename,
 		sizeof(ibdev->node_desc));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 861d92f1a0b0..2abbdd976c18 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1851,6 +1851,7 @@ struct ib_device {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	int			rdma_read_access_flags;
 
 	/**
 	 * The following mandatory functions are used only at device
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
