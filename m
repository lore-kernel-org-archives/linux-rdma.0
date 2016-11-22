From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 02/11] IB/core: Change port_attr.sm_lid from 16 to 32 bits
Date: Tue, 22 Nov 2016 14:38:43 -0500
Message-ID: <1479843532-47496-3-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sm_lid field in port_attr is increased to 32 bits. This
enables core components to use the larger addresses if needed.
The user ABI is unchanged and return 16 bit values when queried.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c    |  2 +-
 drivers/infiniband/core/uverbs_cmd.c  |  6 +++++-
 drivers/infiniband/ulp/srpt/ib_srpt.c |  2 +-
 include/rdma/ib_verbs.h               |  2 +-
 include/rdma/opa_addr.h               | 38 +++++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 4 deletions(-)
 create mode 100644 include/rdma/opa_addr.h

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 81b742c..0b0dc43 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -958,7 +958,7 @@ static void update_sm_ah(struct work_struct *work)
 		pr_err("Couldn't find index for default PKey\n");
 
 	memset(&ah_attr, 0, sizeof ah_attr);
-	ah_attr.dlid     = port_attr.sm_lid;
+	ah_attr.dlid     = (u16)port_attr.sm_lid;
 	ah_attr.sl       = port_attr.sm_sl;
 	ah_attr.port_num = port->port_num;
 	if (port_attr.grh_required) {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..7630c92 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -39,6 +39,7 @@
 #include <linux/sched.h>
 
 #include <asm/uaccess.h>
+#include <rdma/opa_addr.h>
 
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
index 0b1f69e..c6d0c47 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -514,7 +514,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	if (ret)
 		goto err_query_port;
 
-	sport->sm_lid = port_attr.sm_lid;
+	sport->sm_lid = (u16)port_attr.sm_lid;
 	sport->lid = port_attr.lid;
 
 	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 30fa96e..52216f6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -521,7 +521,7 @@ struct ib_port_attr {
 	u32			qkey_viol_cntr;
 	u16			pkey_tbl_len;
 	u16			lid;
-	u16			sm_lid;
+	u32			sm_lid;
 	u8			lmc;
 	u8			max_vl_num;
 	u8			sm_sl;
diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
new file mode 100644
index 0000000..142b327
--- /dev/null
+++ b/include/rdma/opa_addr.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c) 2016 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(OPA_ADDR_H)
+#define OPA_ADDR_H
+
+#define OPA_TO_IB_UCAST_LID(x)	(((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
+				 ? 0 : x)
+#endif /* OPA_ADDR_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
