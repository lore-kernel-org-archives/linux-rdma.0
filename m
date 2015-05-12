From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/5] IB/core: Add rdma_dev_max_mad_size helper call
Date: Mon, 11 May 2015 21:46:57 -0400
Message-ID: <1431395218-27693-5-git-send-email-ira.weiny@intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431395218-27693-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add max MAD size to the device immutable data structure and change all IB
drivers to set the max MAD size.

Set all current devices to the IB_MGMT_MAD_SIZE and add a check to verify that
all devices support at least IB_MGMT_MAD_SIZE

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/core/mad.c                |  4 ++++
 drivers/infiniband/hw/amso1100/c2_provider.c |  1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  1 +
 drivers/infiniband/hw/cxgb4/provider.c       |  1 +
 drivers/infiniband/hw/ehca/ehca_hca.c        |  3 +++
 drivers/infiniband/hw/ipath/ipath_verbs.c    |  1 +
 drivers/infiniband/hw/mlx4/main.c            |  2 ++
 drivers/infiniband/hw/mlx5/main.c            |  1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |  1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  2 ++
 drivers/infiniband/hw/qib/qib_verbs.c        |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  2 ++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  1 +
 include/rdma/ib_mad.h                        |  1 +
 include/rdma/ib_verbs.h                      | 16 ++++++++++++++++
 16 files changed, 39 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 600af26..ca4b988 100644
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
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index e3e0dda..0f4063a 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -772,6 +772,7 @@ static int c2_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 437e20e..870f6d0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1358,6 +1358,7 @@ static int iwch_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index f29f9ac..a4ce40e 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -480,6 +480,7 @@ static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 9ed4d25..6166146 100644
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
index 662ebf3..07c58af6c 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1995,6 +1995,7 @@ static int ipath_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 6ec018b..d32d14c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2135,6 +2135,8 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 	else
 		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCEE;
 
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d789052..35c7f4f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1197,6 +1197,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index b890376..06a48f3 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1259,6 +1259,7 @@ static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 2127477..4b0c85c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -4008,6 +4008,7 @@ static int nes_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 3b93df8..465b74e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -30,6 +30,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include <linux/netdevice.h>
 #include <net/addrconf.h>
@@ -217,6 +218,7 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCEE;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 4c8dd3a..2c9aa60 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2055,6 +2055,7 @@ static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index f851ff8..beda7fa 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -34,6 +34,7 @@
 
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include "usnic_abi.h"
 #include "usnic_common_util.h"
@@ -314,6 +315,7 @@ static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 53bd6a2..04274a8 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -22,6 +22,7 @@
 
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include "usnic_abi.h"
 #include "usnic_ib.h"
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index c0ea51f..a858bf7 100644
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
index f93694f..162a831 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1520,6 +1520,7 @@ struct ib_port_immutable {
 	int                           pkey_tbl_len;
 	int                           gid_tbl_len;
 	u32                           core_cap_flags;
+	u32                           max_mad_size;
 };
 
 struct ib_device {
@@ -1962,6 +1963,21 @@ static inline bool rdma_cap_read_multi_sge(struct ib_device *device,
 		!= RDMA_CORE_CAP_PROT_IWARP;
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
+	return device->port_immutable[port_num].max_mad_size;
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
