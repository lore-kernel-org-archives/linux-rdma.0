From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/8] IB/rdmavt: Add misc dev register functionality
Date: Sat, 09 Jan 2016 07:00:42 -0800
Message-ID: <20160109150041.8585.2148.stgit@scvm10.sc.intel.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109145731.8585.48926.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are a number of minor things that should be set by rdmavt rather
than by the drivers. Now that rdmavt has solidified in its design we can
go ahead and clean up this stuff.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   43 +++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 5a094eb..cf7cac6 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -50,6 +50,8 @@
 #include "vt.h"
 #include "trace.h"
 
+#define RVT_UVERBS_ABI_VERSION 2
+
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("RDMA Verbs Transport Library");
 
@@ -348,6 +350,47 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 
+	/*
+	 * There are some things which could be set by underlying drivers but
+	 * really should be up to rdmavt to set. For instance drivers can't know
+	 * exactly which functions rdmavt supports, nor do they know the ABI
+	 * version, so we do all of this sort of stuff here.
+	 */
+	rdi->ibdev.uverbs_abi_ver = RVT_UVERBS_ABI_VERSION;
+	rdi->ibdev.uverbs_cmd_mask =
+		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)         |
+		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)        |
+		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)          |
+		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)            |
+		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)          |
+		(1ull << IB_USER_VERBS_CMD_CREATE_AH)           |
+		(1ull << IB_USER_VERBS_CMD_MODIFY_AH)           |
+		(1ull << IB_USER_VERBS_CMD_QUERY_AH)            |
+		(1ull << IB_USER_VERBS_CMD_DESTROY_AH)          |
+		(1ull << IB_USER_VERBS_CMD_REG_MR)              |
+		(1ull << IB_USER_VERBS_CMD_DEREG_MR)            |
+		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
+		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)           |
+		(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)           |
+		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)          |
+		(1ull << IB_USER_VERBS_CMD_POLL_CQ)             |
+		(1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ)       |
+		(1ull << IB_USER_VERBS_CMD_CREATE_QP)           |
+		(1ull << IB_USER_VERBS_CMD_QUERY_QP)            |
+		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)           |
+		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)          |
+		(1ull << IB_USER_VERBS_CMD_POST_SEND)           |
+		(1ull << IB_USER_VERBS_CMD_POST_RECV)           |
+		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST)        |
+		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST)        |
+		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)          |
+		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)          |
+		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)           |
+		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)         |
+		(1ull << IB_USER_VERBS_CMD_POST_SRQ_RECV);
+	rdi->ibdev.node_type = RDMA_NODE_IB_CA;
+	rdi->ibdev.num_comp_vectors = 1;
+
 	/* We are now good to announce we exist */
 	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 	if (ret) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
