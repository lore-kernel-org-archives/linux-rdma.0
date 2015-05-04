From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 4/5] IB/core: Add rdma_dev_max_mad_size call
Date: Mon,  4 May 2015 02:14:58 -0400
Message-ID: <1430720099-32512-5-git-send-email-ira.weiny@intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430720099-32512-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change all IB drivers to report their max MAD size through the
rdma_dev_max_mad_size helper function.

Set all current devices to the IB_MGMT_MAD_SIZE and add check to verify that
all devices support at least IB_MGMT_MAD_SIZE

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from the original OPA series V4:
	Change MAD size error message to a WARN_ON
	Remove reference to cached_dev_attr
	Add rdma_dev_max_mad_size

 drivers/infiniband/core/mad.c                |    4 ++++
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    1 +
 drivers/infiniband/hw/cxgb4/provider.c       |    1 +
 drivers/infiniband/hw/ehca/ehca_hca.c        |    3 +++
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 +
 drivers/infiniband/hw/mlx4/main.c            |    1 +
 drivers/infiniband/hw/mlx5/main.c            |    1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 ++
 drivers/infiniband/hw/nes/nes_verbs.c        |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c        |    1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    2 ++
 include/rdma/ib_mad.h                        |    1 +
 include/rdma/ib_verbs.h                      |   19 +++++++++++++++++++
 15 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 0749d7b..09578a6 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2923,6 +2923,10 @@ static int ib_mad_port_open(struct ib_device *device,
 	unsigned long flags;
 	char name[sizeof "ib_mad123"];
 	int has_smi;
+	size_t max_mad_size = rdma_dev_max_mad_size(device, port_num);
+
+	if (WARN_ON(max_mad_size < IB_MGMT_MAD_SIZE))
+		return -EFAULT;
 
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index d2a6d96..63322c0 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -197,6 +197,7 @@ static int c2_rnic_query(struct c2_dev *c2dev, struct ib_device_attr *props)
 	props->max_srq_sge         = 0;
 	props->max_pkeys           = 0;
 	props->local_ca_ack_delay  = 0;
+	props->max_mad_size        = IB_MGMT_MAD_SIZE;
 
  bail2:
 	vq_repbuf_free(c2dev, reply);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index e270846..714afdc 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1174,6 +1174,7 @@ static int iwch_query_device(struct ib_device *ibdev,
 	props->max_pd = dev->attr.max_pds;
 	props->local_ca_ack_delay = 0;
 	props->max_fast_reg_page_list_len = T3_MAX_FASTREG_DEPTH;
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ff63344..8261b11 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -332,6 +332,7 @@ static int c4iw_query_device(struct ib_device *ibdev,
 	props->max_pd = T4_MAX_NUM_PD;
 	props->local_ca_ack_delay = 0;
 	props->max_fast_reg_page_list_len = t4_max_fr_depth(use_dsgl);
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index a06eadd..8ed3472 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -40,6 +40,7 @@
  */
 
 #include <linux/gfp.h>
+#include <rdma/ib_mad.h>
 
 #include "ehca_tools.h"
 #include "ehca_iverbs.h"
@@ -133,6 +134,8 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 		if (rblock->hca_cap_indicators & cap_mapping[i + 1])
 			props->device_cap_flags |= cap_mapping[i];
 
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
+
 query_device1:
 	ehca_free_fw_ctrlblock(rblock);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index bb66aa7..85b8ad1 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1538,6 +1538,7 @@ static int ipath_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = ib_ipath_max_mcast_qp_attached;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 		props->max_mcast_grp;
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 9db5fdc..881dcd7 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -229,6 +229,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
+	props->max_mad_size        = IB_MGMT_MAD_SIZE;
 
 out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4b8ef01..68f2d2c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -154,6 +154,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
+	props->max_mad_size        = IB_MGMT_MAD_SIZE;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 60fcc02..811e3dd 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -123,6 +123,8 @@ static int mthca_query_device(struct ib_device *ibdev,
 		props->max_map_per_fmr =
 			(1 << (32 - ilog2(mdev->limits.num_mpts))) - 1;
 
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
+
 	err = 0;
  out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 187eda6..d16fdd5 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -555,6 +555,7 @@ static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
 	props->atomic_cap = IB_ATOMIC_NONE;
 	props->max_map_per_fmr = 1;
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 4b8f8e6..8d18053 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -103,6 +103,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
 	attr->max_fast_reg_page_list_len = dev->attr.max_pages_per_frmr;
 	attr->max_pkeys = 1;
+	attr->max_mad_size = IB_MGMT_MAD_SIZE;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 6975528..b95d14a 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1592,6 +1592,7 @@ static int qib_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = ib_qib_max_mcast_qp_attached;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 		props->max_mcast_grp;
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 83c61ef..be04372 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -22,6 +22,7 @@
 
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include "usnic_abi.h"
 #include "usnic_ib.h"
@@ -296,6 +297,7 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = 0;
 	props->max_total_mcast_qp_attach = 0;
 	props->max_map_per_fmr = 0;
+	props->max_mad_size = IB_MGMT_MAD_SIZE;
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
index 6c2b0e5..01bdf12 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -217,6 +217,7 @@ struct ib_device_attr {
 	int			sig_prot_cap;
 	int			sig_guard_cap;
 	struct ib_odp_caps	odp_caps;
+	u32			max_mad_size;
 };
 
 enum ib_mtu {
@@ -1930,6 +1931,24 @@ static inline int cap_read_multi_sge(struct ib_device *device, u8 port_num)
 	return !rdma_protocol_iwarp(device, port_num);
 }
 
+/**
+ * rdma_dev_max_mad_size - Return the max MAD size required by this RDMA Port.
+ *
+ * @device: Device
+ * @port_num: Port number
+ *
+ * Return the max MAD size required by the Port.  May return 0 if the port does
+ * not support MADs
+ */
+static inline size_t rdma_dev_max_mad_size(struct ib_device *device,
+					   u8 port_num)
+{
+	struct ib_device_attr attr;
+
+	device->query_device(device, &attr);
+	return attr.max_mad_size;
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
