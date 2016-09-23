From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 02/11] IB/core: Change port_attr.sm_lid from 16 to 32 bits
Date: Fri, 23 Sep 2016 13:44:25 -0400
Message-ID: <1474652674-13110-3-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

sm_lid field in port_attr is increased to 32 bits. This
enables core components to use the larger addresses if needed.
The user ABI is unchanged and return 16 bit values when queried.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c  | 6 +++++-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 include/rdma/ib_addr.h                | 3 +++
 include/rdma/ib_verbs.h               | 2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f6647318138d..4cb5238edceb 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -39,6 +39,7 @@
 #include <linux/sched.h>
 
 #include <asm/uaccess.h>
+#include <rdma/ib_addr.h>
 
 #include "uverbs.h"
 #include "core_priv.h"
@@ -515,7 +516,10 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
 	resp.pkey_tbl_len    = attr.pkey_tbl_len;
 	resp.lid 	     = attr.lid;
-	resp.sm_lid 	     = attr.sm_lid;
+	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
+		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
+	else
+		resp.sm_lid  = (u16)attr.sm_lid;
 	resp.lmc 	     = attr.lmc;
 	resp.max_vl_num      = attr.max_vl_num;
 	resp.sm_sl 	     = attr.sm_sl;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 883bbfe08e0e..87c911804d62 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -514,7 +514,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	if (ret)
 		goto err_query_port;
 
-	sport->sm_lid = port_attr.sm_lid;
+	sport->sm_lid = (u16)port_attr.sm_lid;
 	sport->lid = port_attr.lid;
 
 	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid,
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 931a47ba4571..04074d7e0763 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -49,6 +49,9 @@
 #include <net/ipv6.h>
 #include <net/net_namespace.h>
 
+#define OPA_TO_IB_UCAST_LID(x)	(((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
+				 ? 0 : x)
+
 struct rdma_addr_client {
 	atomic_t refcount;
 	struct completion comp;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a57fedbc83ed..b4c070a3ecdf 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -509,7 +509,7 @@ struct ib_port_attr {
 	u32			qkey_viol_cntr;
 	u16			pkey_tbl_len;
 	u16			lid;
-	u16			sm_lid;
+	u32			sm_lid;
 	u8			lmc;
 	u8			max_vl_num;
 	u8			sm_sl;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
