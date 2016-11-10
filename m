From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Use vector when creating CQs
Date: Wed,  9 Nov 2016 21:24:48 -0600
Message-ID: <20161110032448.11516-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Assign each CEQ vector to a different CPU when possible, then
when creating a CQ, use the vector for the CEQ id. This
allows completion work to be distributed over multiple cores.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c  | 8 +++++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 5 +++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 078d784..154a9d4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -270,6 +270,7 @@ static void i40iw_disable_irq(struct i40iw_sc_dev *dev,
 		i40iw_wr32(dev->hw, I40E_PFINT_DYN_CTLN(msix_vec->idx - 1), 0);
 	else
 		i40iw_wr32(dev->hw, I40E_VFINT_DYN_CTLN1(msix_vec->idx - 1), 0);
+	irq_set_affinity_hint(msix_vec->irq, NULL);
 	free_irq(msix_vec->irq, dev_id);
 }
 
@@ -688,6 +689,7 @@ static enum i40iw_status_code i40iw_configure_ceq_vector(struct i40iw_device *iw
 							 struct i40iw_msix_vector *msix_vec)
 {
 	enum i40iw_status_code status;
+	cpumask_t mask;
 
 	if (iwdev->msix_shared && !ceq_id) {
 		tasklet_init(&iwdev->dpc_tasklet, i40iw_dpc, (unsigned long)iwdev);
@@ -697,12 +699,15 @@ static enum i40iw_status_code i40iw_configure_ceq_vector(struct i40iw_device *iw
 		status = request_irq(msix_vec->irq, i40iw_ceq_handler, 0, "CEQ", iwceq);
 	}
 
+	cpumask_clear(&mask);
+	cpumask_set_cpu(msix_vec->cpu_affinity, &mask);
+	irq_set_affinity_hint(msix_vec->irq, &mask);
+
 	if (status) {
 		i40iw_pr_err("ceq irq config fail\n");
 		return I40IW_ERR_CONFIG;
 	}
 	msix_vec->ceq_id = ceq_id;
-	msix_vec->cpu_affinity = 0;
 
 	return 0;
 }
@@ -1384,6 +1389,7 @@ static enum i40iw_status_code i40iw_save_msix_info(struct i40iw_device *iwdev,
 	for (i = 0, ceq_idx = 0; i < iwdev->msix_count; i++, iw_qvinfo++) {
 		iwdev->iw_msixtbl[i].idx = ldev->msix_entries[i].entry;
 		iwdev->iw_msixtbl[i].irq = ldev->msix_entries[i].vector;
+		iwdev->iw_msixtbl[i].cpu_affinity = ceq_idx;
 		if (i == 0) {
 			iw_qvinfo->aeq_idx = 0;
 			if (iwdev->msix_shared)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..2dbbf67 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1137,7 +1137,8 @@ static struct ib_cq *i40iw_create_cq(struct ib_device *ibdev,
 	ukinfo->cq_id = cq_num;
 	iwcq->ibcq.cqe = info.cq_uk_init_info.cq_size;
 	info.ceqe_mask = 0;
-	info.ceq_id = 0;
+	if (attr->comp_vector < iwdev->ceqs_count)
+		info.ceq_id = attr->comp_vector;
 	info.ceq_id_valid = true;
 	info.ceqe_mask = 1;
 	info.type = I40IW_CQ_TYPE_IWARP;
@@ -2621,7 +2622,7 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	    (1ull << IB_USER_VERBS_CMD_POST_RECV) |
 	    (1ull << IB_USER_VERBS_CMD_POST_SEND);
 	iwibdev->ibdev.phys_port_cnt = 1;
-	iwibdev->ibdev.num_comp_vectors = 1;
+	iwibdev->ibdev.num_comp_vectors = iwdev->ceqs_count;
 	iwibdev->ibdev.dma_device = &pcidev->dev;
 	iwibdev->ibdev.dev.parent = &pcidev->dev;
 	iwibdev->ibdev.query_port = i40iw_query_port;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
