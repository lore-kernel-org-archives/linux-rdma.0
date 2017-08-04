From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/27] IB/core: Change port_attr.sm_lid from 16 to
 32 bits
Date: Fri, 04 Aug 2017 13:53:21 -0700
Message-ID: <20170804205320.17853.77236.stgit@scvm10.sc.intel.com>
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

sm_lid field in struct ib_port_attr is increased to 32 bits. This
enables core components to use larger LIDs if needed.
The user ABI is unchanged and return 16 bit values when queried.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    8 +++++---
 include/rdma/ib_verbs.h              |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7ef74b0..38dce45 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -275,11 +275,13 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
 	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
 	resp.pkey_tbl_len    = attr.pkey_tbl_len;
-	resp.sm_lid 	     = attr.sm_lid;
-	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
+	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
 		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
-	else
+		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
+	} else {
 		resp.lid     = (u16)attr.lid;
+		resp.sm_lid  = (u16)attr.sm_lid;
+	}
 	resp.lmc 	     = attr.lmc;
 	resp.max_vl_num      = attr.max_vl_num;
 	resp.sm_sl 	     = attr.sm_sl;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4eccf89..5f4f2d3 100644
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
