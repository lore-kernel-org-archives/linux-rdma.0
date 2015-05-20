From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/14] IB/core: Add rdma_max_mad_size helper
Date: Wed, 20 May 2015 04:13:29 -0400
Message-ID: <1432109615-19564-9-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add max MAD size to the device immutable data structure and change all drivers
that support MADs to set IB_MGMT_MAD_SIZE.

Add WARN_ON to verify that all devices support at least IB_MGMT_MAD_SIZE.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                |  4 ++++
 drivers/infiniband/hw/ehca/ehca_main.c       |  2 ++
 drivers/infiniband/hw/ipath/ipath_verbs.c    |  1 +
 drivers/infiniband/hw/mlx4/main.c            |  2 ++
 drivers/infiniband/hw/mlx5/main.c            |  1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  2 ++
 drivers/infiniband/hw/qib/qib_verbs.c        |  1 +
 include/rdma/ib_mad.h                        |  1 +
 include/rdma/ib_verbs.h                      | 15 +++++++++++++++
 10 files changed, 30 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 8055195b5d60..ea25e9467cb5 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2937,6 +2937,10 @@ static int ib_mad_port_open(struct ib_device *device,
 	unsigned long flags;
 	char name[sizeof "ib_mad123"];
 	int has_smi;
+	size_t max_mad_size = rdma_max_mad_size(device, port_num);
+
+	if (WARN_ON(max_mad_size < IB_MGMT_MAD_SIZE))
+		return -EFAULT;
 
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 5e30b72d3677..64c834b358d6 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -46,6 +46,7 @@
 
 #include <linux/notifier.h>
 #include <linux/memory.h>
+#include <rdma/ib_mad.h>
 #include "ehca_classes.h"
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
@@ -444,6 +445,7 @@ static int ehca_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 764081d305b6..c67e8c22dabc 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1993,6 +1993,7 @@ static int ipath_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c49dd0bb251a..7c62daf58302 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2132,6 +2132,8 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 	else
 		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
 
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b2fdb9cfa645..bb7f718adc11 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1195,6 +1195,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 509d59e7a15a..db11d0cc5d59 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1257,6 +1257,7 @@ static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index f55289869357..8a1398b253a2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -30,6 +30,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include <linux/netdevice.h>
 #include <net/addrconf.h>
@@ -215,6 +216,7 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index dba1c92f1a54..e9e21f9c36e2 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2053,6 +2053,7 @@ static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index ddc82d65a9e5..20ed361a9224 100644
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
index ad499bda62a4..8859afea4e2f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1523,6 +1523,7 @@ struct ib_port_immutable {
 	int                           pkey_tbl_len;
 	int                           gid_tbl_len;
 	u32                           core_cap_flags;
+	u32                           max_mad_size;
 };
 
 struct ib_device {
@@ -2040,6 +2041,20 @@ static inline bool rdma_cap_read_multi_sge(struct ib_device *device,
 	return !(device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IWARP);
 }
 
+/**
+ * rdma_max_mad_size - Return the max MAD size required by this RDMA Port.
+ *
+ * @device: Device
+ * @port_num: Port number
+ *
+ * Return the max MAD size required by the Port.  Should return 0 if the port
+ * does not support MADs
+ */
+static inline size_t rdma_max_mad_size(struct ib_device *device, u8 port_num)
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
