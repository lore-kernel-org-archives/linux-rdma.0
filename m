From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] IB/qib: Clean up register_ib_device
Date: Wed, 03 Feb 2016 14:20:10 -0800
Message-ID: <20160203222007.4030.95859.stgit@scvm10.sc.intel.com>
References: <20160203221808.4030.95183.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221808.4030.95183.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove some of the unnecessary code from qib_register_ib_device.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   68 ---------------------------------
 1 files changed, 0 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 3785a52..0116f58 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1703,81 +1703,15 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	strlcpy(ibdev->name, "qib%d", IB_DEVICE_NAME_MAX);
 	ibdev->owner = THIS_MODULE;
 	ibdev->node_guid = ppd->guid;
-	ibdev->uverbs_abi_ver = QIB_UVERBS_ABI_VERSION;
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
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
 	ibdev->modify_port = qib_modify_port;
-	ibdev->query_pkey = NULL;
 	ibdev->query_gid = qib_query_gid;
-	ibdev->alloc_ucontext = NULL;
-	ibdev->dealloc_ucontext = NULL;
-	ibdev->alloc_pd = NULL;
-	ibdev->dealloc_pd = NULL;
-	ibdev->create_ah = NULL;
-	ibdev->destroy_ah = NULL;
-	ibdev->modify_ah = NULL;
-	ibdev->query_ah = NULL;
-	ibdev->create_qp = NULL;
 	ibdev->modify_qp = qib_modify_qp;
-	ibdev->query_qp = NULL;
 	ibdev->destroy_qp = qib_destroy_qp;
-	ibdev->post_send = NULL;
-	ibdev->post_recv = NULL;
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
 	ibdev->process_mad = qib_process_mad;
-	ibdev->mmap = NULL;
-	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = qib_port_immutable;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
@@ -1799,8 +1733,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.do_send = qib_do_send;
 	dd->verbs_dev.rdi.driver_f.schedule_send = qib_schedule_send;
 
-	dd->verbs_dev.rdi.flags = 0;
-
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
 	dd->verbs_dev.rdi.dparms.qp_table_size = ib_qib_qp_table_size;
 	dd->verbs_dev.rdi.dparms.qpn_start = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
