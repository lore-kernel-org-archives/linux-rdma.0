From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next v4 7/8] IB/core: Change port_attr.sm_lid from 16 to 32 bits
Date: Thu, 10 Aug 2017 14:04:27 -0400
Message-ID: <1502388268-20687-8-git-send-email-don.hiatt@intel.com>
References: <1502388268-20687-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502388268-20687-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

sm_lid field in struct ib_port_attr is increased to 32 bits. This
enables core components to use larger LIDs if needed.
The user ABI is unchanged and return 16 bit values when queried.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 8 +++++---
 include/rdma/ib_verbs.h              | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e693b8b..13484ea 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -275,7 +275,6 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
 	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
 	resp.pkey_tbl_len    = attr.pkey_tbl_len;
-	resp.sm_lid 	     = attr.sm_lid;
 
 	/*
 	 * In the current implementation the only way to get
@@ -283,10 +282,13 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	 * For IB, lids will always be 16bits so cast the
 	 * value accordingly.
 	 */
-	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
+	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
 		resp.lid     = OPA_TO_IB_UCAST_LID(attr.lid);
-	else
+		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
+	} else {
 		resp.lid     = ib_lid_cpu16(attr.lid);
+		resp.sm_lid  = ib_lid_cpu16(attr.sm_lid);
+	}
 	resp.lmc 	     = attr.lmc;
 	resp.max_vl_num      = attr.max_vl_num;
 	resp.sm_sl 	     = attr.sm_sl;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0826a66..c92b98b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -549,7 +549,7 @@ struct ib_port_attr {
 	u32			bad_pkey_cntr;
 	u32			qkey_viol_cntr;
 	u16			pkey_tbl_len;
-	u16			sm_lid;
+	u32			sm_lid;
 	u32			lid;
 	u8			lmc;
 	u8			max_vl_num;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
