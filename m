From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 06/20] IB/core: Add mad_size to ib_device_attr
Date: Mon, 12 Jan 2015 12:10:58 -0500
Message-ID: <1421082672-22588-7-git-send-email-ira.weiny@intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change all IB drivers to report the IB management size.
Add check to verify that all devices support at least IB_MGMT_MAD_SIZE

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                |    6 ++++++
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    1 +
 drivers/infiniband/hw/cxgb4/provider.c       |    1 +
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 ++
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 +
 drivers/infiniband/hw/mlx4/main.c            |    1 +
 drivers/infiniband/hw/mlx5/main.c            |    1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 ++
 drivers/infiniband/hw/nes/nes_verbs.c        |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c        |    1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    1 +
 include/rdma/ib_mad.h                        |    1 +
 include/rdma/ib_verbs.h                      |    1 +
 15 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 819b794..031ae6f 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2924,6 +2924,12 @@ static int ib_mad_port_open(struct ib_device *device,
 	char name[sizeof "ib_mad123"];
 	int has_smi;
 
+	if (device->attributes.mad_size < IB_MGMT_MAD_SIZE) {
+		dev_err(&device->dev, "Min MAD size for device is %u\n",
+			IB_MGMT_MAD_SIZE);
+		return -EFAULT;
+	}
+
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
 	if (!port_priv) {
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index d2a6d96..8f77f2c 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -197,6 +197,7 @@ static int c2_rnic_query(struct c2_dev *c2dev, struct ib_device_attr *props)
 	props->max_srq_sge         = 0;
 	props->max_pkeys           = 0;
 	props->local_ca_ack_delay  = 0;
+	props->mad_size            = IB_MGMT_MAD_SIZE;
 
  bail2:
 	vq_repbuf_free(c2dev, reply);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 811b24a..a308760 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1174,6 +1174,7 @@ static int iwch_query_device(struct ib_device *ibdev,
 	props->max_pd = dev->attr.max_pds;
 	props->local_ca_ack_delay = 0;
 	props->max_fast_reg_page_list_len = T3_MAX_FASTREG_DEPTH;
+	props->mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 66bd6a2..cd1434e 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -332,6 +332,7 @@ static int c4iw_query_device(struct ib_device *ibdev,
 	props->max_pd = T4_MAX_NUM_PD;
 	props->local_ca_ack_delay = 0;
 	props->max_fast_reg_page_list_len = t4_max_fr_depth(use_dsgl);
+	props->mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 9ed4d25..ca84efb 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -133,6 +133,8 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 		if (rblock->hca_cap_indicators & cap_mapping[i + 1])
 			props->device_cap_flags |= cap_mapping[i];
 
+	props->mad_size = IB_MGMT_MAD_SIZE;
+
 query_device1:
 	ehca_free_fw_ctrlblock(rblock);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 44ea939..f9d2dc9 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1538,6 +1538,7 @@ static int ipath_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = ib_ipath_max_mcast_qp_attached;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 		props->max_mcast_grp;
+	props->mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 57ecc5b..5c0ca80 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -229,6 +229,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
+	props->mad_size        = IB_MGMT_MAD_SIZE;
 
 out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8a87404..3613f87 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -243,6 +243,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
+	props->mad_size        = IB_MGMT_MAD_SIZE;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 415f8e1..9194b70 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -123,6 +123,8 @@ static int mthca_query_device(struct ib_device *ibdev,
 		props->max_map_per_fmr =
 			(1 << (32 - ilog2(mdev->limits.num_mpts))) - 1;
 
+	props->mad_size = IB_MGMT_MAD_SIZE;
+
 	err = 0;
  out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c0d0296..c4b0aba 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -555,6 +555,7 @@ static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
 	props->atomic_cap = IB_ATOMIC_NONE;
 	props->max_map_per_fmr = 1;
+	props->mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index fb8d8c4..ee04a25 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -103,6 +103,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
 	attr->max_fast_reg_page_list_len = dev->attr.max_pages_per_frmr;
 	attr->max_pkeys = 1;
+	attr->mad_size = IB_MGMT_MAD_SIZE;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9bcfbd8..95ceb17 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1591,6 +1591,7 @@ static int qib_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = ib_qib_max_mcast_qp_attached;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 		props->max_mcast_grp;
+	props->mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 53bd6a2..3cd571e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -296,6 +296,7 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = 0;
 	props->max_total_mcast_qp_attach = 0;
 	props->max_map_per_fmr = 0;
+	props->mad_size = IB_MGMT_MAD_SIZE;
 	/* Owned by Userspace
 	 * max_qp_wr, max_sge, max_sge_rd, max_cqe */
 	mutex_unlock(&us_ibdev->usdev_lock);
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 9c89939..5823016 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -135,6 +135,7 @@ enum {
 	IB_MGMT_SA_DATA = 200,
 	IB_MGMT_DEVICE_HDR = 64,
 	IB_MGMT_DEVICE_DATA = 192,
+	IB_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
 };
 
 struct ib_mad_hdr {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 86fc90f..b35e472 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -210,6 +210,7 @@ struct ib_device_attr {
 	int			sig_prot_cap;
 	int			sig_guard_cap;
 	struct ib_odp_caps	odp_caps;
+	u32			mad_size;
 };
 
 enum ib_mtu {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
