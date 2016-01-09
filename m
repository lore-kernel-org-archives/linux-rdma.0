From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 27/27] IB/hfi1: Clean up register device
Date: Sat, 09 Jan 2016 07:19:09 -0800
Message-ID: <20160109151909.30800.79783.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Now that rdmavt has solidified in its design we can clean up the driver
specific register device functions. This handles hfi1.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |   69 +------------------------------------
 1 files changed, 2 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 6579162..d81de49 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1520,86 +1520,21 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	strlcpy(ibdev->name + lcpysz, "_%d", IB_DEVICE_NAME_MAX - lcpysz);
 	ibdev->owner = THIS_MODULE;
 	ibdev->node_guid = cpu_to_be64(ppd->guid);
-	ibdev->uverbs_abi_ver = HFI1_UVERBS_ABI_VERSION;
-	ibdev->uverbs_cmd_mask =
-		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)         |
-		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)        |
-		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)          |
-		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)            |
-		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)          |
-		(1ull << IB_USER_VERBS_CMD_CREATE_AH)           |
-		(1ull << IB_USER_VERBS_CMD_MODIFY_AH)           |
-		(1ull << IB_USER_VERBS_CMD_QUERY_AH)            |
-		(1ull << IB_USER_VERBS_CMD_DESTROY_AH)          |
-		(1ull << IB_USER_VERBS_CMD_REG_MR)              |
-		(1ull << IB_USER_VERBS_CMD_DEREG_MR)            |
-		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
-		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)           |
-		(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)           |
-		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)          |
-		(1ull << IB_USER_VERBS_CMD_POLL_CQ)             |
-		(1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ)       |
-		(1ull << IB_USER_VERBS_CMD_CREATE_QP)           |
-		(1ull << IB_USER_VERBS_CMD_QUERY_QP)            |
-		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)           |
-		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)          |
-		(1ull << IB_USER_VERBS_CMD_POST_SEND)           |
-		(1ull << IB_USER_VERBS_CMD_POST_RECV)           |
-		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST)        |
-		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST)        |
-		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)          |
-		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)          |
-		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)           |
-		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)         |
-		(1ull << IB_USER_VERBS_CMD_POST_SRQ_RECV);
-	ibdev->node_type = RDMA_NODE_IB_CA;
 	ibdev->phys_port_cnt = dd->num_pports;
-	ibdev->num_comp_vectors = 1;
 	ibdev->dma_device = &dd->pcidev->dev;
-	ibdev->query_device = NULL;
 	ibdev->modify_device = modify_device;
 	ibdev->query_port = query_port;
 	ibdev->modify_port = modify_port;
-	ibdev->query_pkey = NULL;
 	ibdev->query_gid = query_gid;
-	ibdev->alloc_ucontext = NULL;
-	ibdev->dealloc_ucontext = NULL;
-	ibdev->alloc_pd = NULL;
-	ibdev->dealloc_pd = NULL;
-	ibdev->create_ah = NULL;
-	ibdev->destroy_ah = NULL;
-	ibdev->modify_ah = NULL;
-	ibdev->query_ah = NULL;
 	ibdev->create_srq = hfi1_create_srq;
 	ibdev->modify_srq = hfi1_modify_srq;
 	ibdev->query_srq = hfi1_query_srq;
 	ibdev->destroy_srq = hfi1_destroy_srq;
-	ibdev->create_qp = NULL;
-	ibdev->modify_qp = NULL;
 	ibdev->query_qp = hfi1_query_qp;
-	ibdev->destroy_qp = NULL;
-	ibdev->post_send = NULL;
-	ibdev->post_recv = NULL;
 	ibdev->post_srq_recv = hfi1_post_srq_receive;
-	ibdev->create_cq = NULL;
-	ibdev->destroy_cq = NULL;
-	ibdev->resize_cq = NULL;
-	ibdev->poll_cq = NULL;
-	ibdev->req_notify_cq = NULL;
-	ibdev->get_dma_mr = NULL;
-	ibdev->reg_user_mr = NULL;
-	ibdev->dereg_mr = NULL;
-	ibdev->alloc_mr = NULL;
-	ibdev->map_mr_sg = NULL;
-	ibdev->alloc_fmr = NULL;
-	ibdev->map_phys_fmr = NULL;
-	ibdev->unmap_fmr = NULL;
-	ibdev->dealloc_fmr = NULL;
-	ibdev->attach_mcast = NULL;
-	ibdev->detach_mcast = NULL;
+
+	/* keep process mad in the driver */
 	ibdev->process_mad = hfi1_process_mad;
-	ibdev->mmap = NULL;
-	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = port_immutable;
 
 	strncpy(ibdev->node_desc, init_utsname()->nodename,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
