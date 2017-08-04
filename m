From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/27] IB/core: Change port_attr.lid size from 16
 to 32 bits
Date: Fri, 04 Aug 2017 13:53:15 -0700
Message-ID: <20170804205314.17853.94294.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804204842.17853.14858.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

lid field in struct ib_port_attr is increased to 32 bits. This enables core
components to use larger LIDs if needed.
The user ABI is unchanged and return 16 bit values when queried.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h     |    1 +
 drivers/infiniband/core/uverbs_cmd.c    |    5 ++++-
 drivers/infiniband/hw/mlx4/alias_GUID.c |    2 +-
 drivers/infiniband/hw/mlx4/mad.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |    2 +-
 include/rdma/ib_verbs.h                 |    2 +-
 include/rdma/opa_addr.h                 |    3 ++-
 7 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 11ae675..9d4f17f 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -39,6 +39,7 @@
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_mad.h>
+#include <rdma/opa_addr.h>
 #include "mad_priv.h"
 
 struct pkey_index_qp_list {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 60535c7..7ef74b0 100644
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
index 21d31cb..00f0570 100644
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
index 1082b4c..4eccf89 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -549,8 +549,8 @@ struct ib_port_attr {
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
