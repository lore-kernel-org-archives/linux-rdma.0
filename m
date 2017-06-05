From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 5/8] IB/core: Change port_attr.lid size from 16 to 32 bits
Date: Mon,  5 Jun 2017 14:19:48 -0400
Message-ID: <1496686791-51297-6-git-send-email-don.hiatt@intel.com>
References: <1496686791-51297-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496686791-51297-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

lid field in struct ib_port_attr is increased to 32 bits. This enables core
components to use larger LIDs if needed.
The user ABI is unchanged and return 16 bit values when queried.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h     | 1 +
 drivers/infiniband/core/uverbs_cmd.c    | 5 ++++-
 drivers/infiniband/hw/mlx4/alias_GUID.c | 2 +-
 drivers/infiniband/hw/mlx4/mad.c        | 2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c | 2 +-
 include/rdma/ib_verbs.h                 | 2 +-
 include/rdma/opa_addr.h                 | 3 ++-
 7 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index cb7d372..0919aeb 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,6 +38,7 @@
 #include <linux/cgroup_rdma.h>
 
 #include <rdma/ib_verbs.h>
+#include <rdma/opa_addr.h>
 
 #if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
 int cma_configfs_init(void);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 70b7fb1..038b993 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -275,8 +275,11 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
 	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
 	resp.pkey_tbl_len    = attr.pkey_tbl_len;
-	resp.lid 	     = attr.lid;
 	resp.sm_lid 	     = attr.sm_lid;
+	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
+		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
+	else
+		resp.lid     = (u16)attr.lid;
 	resp.lmc 	     = attr.lmc;
 	resp.max_vl_num      = attr.max_vl_num;
 	resp.sm_sl 	     = attr.sm_sl;
diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index ea24230..5a897b0 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -528,7 +528,7 @@ static int set_guid_rec(struct ib_device *ibdev,
 
 	memset(&guid_info_rec, 0, sizeof (struct ib_sa_guidinfo_rec));
 
-	guid_info_rec.lid = cpu_to_be16(attr.lid);
+	guid_info_rec.lid = cpu_to_be16((u16)attr.lid);
 	guid_info_rec.block_num = index;
 
 	memcpy(guid_info_rec.guid_info_list, rec_det->all_recs,
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index b469471..cd5bfe1 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -860,7 +860,7 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	    in_mad->mad_hdr.method == IB_MGMT_METHOD_SET &&
 	    in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
 	    !ib_query_port(ibdev, port_num, &pattr))
-		prev_lid = pattr.lid;
+		prev_lid = (u16)pattr.lid;
 
 	err = mlx4_MAD_IFC(to_mdev(ibdev),
 			   (mad_flags & IB_MAD_IGNORE_MKEY ? MLX4_MAD_IFC_IGNORE_MKEY : 0) |
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 7df3db7..617531f 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -256,7 +256,7 @@ int mthca_process_mad(struct ib_device *ibdev,
 	    in_mad->mad_hdr.method == IB_MGMT_METHOD_SET &&
 	    in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
 	    !ib_query_port(ibdev, port_num, &pattr))
-		prev_lid = pattr.lid;
+		prev_lid = (u16)pattr.lid;
 
 	err = mthca_MAD_IFC(to_mdev(ibdev),
 			    mad_flags & IB_MAD_IGNORE_MKEY,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6c4f6da..3b442229 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -548,8 +548,8 @@ struct ib_port_attr {
 	u32			bad_pkey_cntr;
 	u32			qkey_viol_cntr;
 	u16			pkey_tbl_len;
-	u16			lid;
 	u16			sm_lid;
+	u32			lid;
 	u8			lmc;
 	u8			max_vl_num;
 	u8			sm_sl;
diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
index eace28f..46d0567 100644
--- a/include/rdma/opa_addr.h
+++ b/include/rdma/opa_addr.h
@@ -50,7 +50,8 @@
 
 #define	OPA_SPECIAL_OUI		(0x00066AULL)
 #define OPA_MAKE_ID(x)          (cpu_to_be64(OPA_SPECIAL_OUI << 40 | (x)))
-
+#define OPA_TO_IB_UCAST_LID(x) (((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
+				? 0 : x)
 /**
  * ib_is_opa_gid: Returns true if the top 24 bits of the gid
  * contains the OPA_STL_OUI identifier. This identifies that
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
