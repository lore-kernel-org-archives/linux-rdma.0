From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH qedr 06/10] qedr: Add support for memory registeration verbs
Date: Wed, 5 Oct 2016 18:47:59 +0300
Message-ID: <1475682483-9878-7-git-send-email-Ram.Amrani@cavium.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475682483-9878-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for user, dma and memory regions registration.

Signed-off-by: Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c  |  10 +-
 drivers/infiniband/hw/qedr/qedr.h  |  40 ++++
 drivers/infiniband/hw/qedr/verbs.c | 365 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qedr/verbs.h |  14 ++
 4 files changed, 428 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 40864b4..613cc4d 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -100,7 +100,9 @@ static int qedr_register_device(struct qedr_dev *dev)
 				     QEDR_UVERBS(CREATE_QP) |
 				     QEDR_UVERBS(MODIFY_QP) |
 				     QEDR_UVERBS(QUERY_QP) |
-				     QEDR_UVERBS(DESTROY_QP);
+				     QEDR_UVERBS(DESTROY_QP) |
+				     QEDR_UVERBS(REG_MR) |
+				     QEDR_UVERBS(DEREG_MR);
 
 	dev->ibdev.phys_port_cnt = 1;
 	dev->ibdev.num_comp_vectors = dev->num_cnq;
@@ -133,6 +135,12 @@ static int qedr_register_device(struct qedr_dev *dev)
 
 	dev->ibdev.query_pkey = qedr_query_pkey;
 
+	dev->ibdev.get_dma_mr = qedr_get_dma_mr;
+	dev->ibdev.dereg_mr = qedr_dereg_mr;
+	dev->ibdev.reg_user_mr = qedr_reg_user_mr;
+	dev->ibdev.alloc_mr = qedr_alloc_mr;
+	dev->ibdev.map_mr_sg = qedr_map_mr_sg;
+
 	dev->ibdev.dma_device = &dev->pdev->dev;
 
 	dev->ibdev.get_link_layer = qedr_link_layer;
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 2f97477..fe6b829 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -375,6 +375,41 @@ struct qedr_qp {
 	struct qedr_userq urq;
 };
 
+struct qedr_ah {
+	struct ib_ah ibah;
+	struct ib_ah_attr attr;
+};
+
+enum qedr_mr_type {
+	QEDR_MR_USER,
+	QEDR_MR_KERNEL,
+	QEDR_MR_DMA,
+	QEDR_MR_FRMR
+};
+
+struct mr_info {
+	struct qedr_pbl *pbl_table;
+	struct qedr_pbl_info pbl_info;
+	struct list_head free_pbl_list;
+	struct list_head inuse_pbl_list;
+	u32 completed;
+	u32 completed_handled;
+};
+
+struct qedr_mr {
+	struct ib_mr ibmr;
+	struct ib_umem *umem;
+
+	struct qed_rdma_register_tid_in_params hw_mr;
+	enum qedr_mr_type type;
+
+	struct qedr_dev *dev;
+	struct mr_info info;
+
+	u64 *pages;
+	u32 npages;
+};
+
 static inline int qedr_get_dmac(struct qedr_dev *dev,
 				struct ib_ah_attr *ah_attr, u8 *mac_addr)
 {
@@ -418,4 +453,9 @@ static inline struct qedr_qp *get_qedr_qp(struct ib_qp *ibqp)
 {
 	return container_of(ibqp, struct qedr_qp, ibqp);
 }
+
+static inline struct qedr_mr *get_qedr_mr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct qedr_mr, ibmr);
+}
 #endif
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 87f72ec..084aed4 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2091,3 +2091,368 @@ int qedr_destroy_qp(struct ib_qp *ibqp)
 
 	return rc;
 }
+
+static void free_mr_info(struct qedr_dev *dev, struct mr_info *info)
+{
+	struct qedr_pbl *pbl, *tmp;
+
+	if (info->pbl_table)
+		list_add_tail(&info->pbl_table->list_entry,
+			      &info->free_pbl_list);
+
+	if (!list_empty(&info->inuse_pbl_list))
+		list_splice(&info->inuse_pbl_list, &info->free_pbl_list);
+
+	list_for_each_entry_safe(pbl, tmp, &info->free_pbl_list, list_entry) {
+		list_del(&pbl->list_entry);
+		qedr_free_pbl(dev, &info->pbl_info, pbl);
+	}
+}
+
+static int init_mr_info(struct qedr_dev *dev, struct mr_info *info,
+			size_t page_list_len, bool two_layered)
+{
+	struct qedr_pbl *tmp;
+	int rc;
+
+	INIT_LIST_HEAD(&info->free_pbl_list);
+	INIT_LIST_HEAD(&info->inuse_pbl_list);
+
+	rc = qedr_prepare_pbl_tbl(dev, &info->pbl_info,
+				  page_list_len, two_layered);
+	if (rc)
+		goto done;
+
+	info->pbl_table = qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
+	if (!info->pbl_table) {
+		rc = -ENOMEM;
+		goto done;
+	}
+
+	DP_DEBUG(dev, QEDR_MSG_MR, "pbl_table_pa = %pa\n",
+		 &info->pbl_table->pa);
+
+	/* in usual case we use 2 PBLs, so we add one to free
+	 * list and allocating another one
+	 */
+	tmp = qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
+	if (!tmp) {
+		DP_DEBUG(dev, QEDR_MSG_MR, "Extra PBL is not allocated\n");
+		goto done;
+	}
+
+	list_add_tail(&tmp->list_entry, &info->free_pbl_list);
+
+	DP_DEBUG(dev, QEDR_MSG_MR, "extra pbl_table_pa = %pa\n", &tmp->pa);
+
+done:
+	if (rc)
+		free_mr_info(dev, info);
+
+	return rc;
+}
+
+struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
+			       u64 usr_addr, int acc, struct ib_udata *udata)
+{
+	struct qedr_dev *dev = get_qedr_dev(ibpd->device);
+	struct qedr_mr *mr;
+	struct qedr_pd *pd;
+	int rc = -ENOMEM;
+
+	pd = get_qedr_pd(ibpd);
+	DP_DEBUG(dev, QEDR_MSG_MR,
+		 "qedr_register user mr pd = %d start = %lld, len = %lld, usr_addr = %lld, acc = %d\n",
+		 pd->pd_id, start, len, usr_addr, acc);
+
+	if (acc & IB_ACCESS_REMOTE_WRITE && !(acc & IB_ACCESS_LOCAL_WRITE))
+		return ERR_PTR(-EINVAL);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(rc);
+
+	mr->type = QEDR_MR_USER;
+
+	mr->umem = ib_umem_get(ibpd->uobject->context, start, len, acc, 0);
+	if (IS_ERR(mr->umem)) {
+		rc = -EFAULT;
+		goto err0;
+	}
+
+	rc = init_mr_info(dev, &mr->info, ib_umem_page_count(mr->umem), 1);
+	if (rc)
+		goto err1;
+
+	qedr_populate_pbls(dev, mr->umem, mr->info.pbl_table,
+			   &mr->info.pbl_info);
+
+	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
+	if (rc) {
+		DP_ERR(dev, "roce alloc tid returned an error %d\n", rc);
+		goto err1;
+	}
+
+	/* Index only, 18 bit long, lkey = itid << 8 | key */
+	mr->hw_mr.tid_type = QED_RDMA_TID_REGISTERED_MR;
+	mr->hw_mr.key = 0;
+	mr->hw_mr.pd = pd->pd_id;
+	mr->hw_mr.local_read = 1;
+	mr->hw_mr.local_write = (acc & IB_ACCESS_LOCAL_WRITE) ? 1 : 0;
+	mr->hw_mr.remote_read = (acc & IB_ACCESS_REMOTE_READ) ? 1 : 0;
+	mr->hw_mr.remote_write = (acc & IB_ACCESS_REMOTE_WRITE) ? 1 : 0;
+	mr->hw_mr.remote_atomic = (acc & IB_ACCESS_REMOTE_ATOMIC) ? 1 : 0;
+	mr->hw_mr.mw_bind = false;
+	mr->hw_mr.pbl_ptr = mr->info.pbl_table[0].pa;
+	mr->hw_mr.pbl_two_level = mr->info.pbl_info.two_layered;
+	mr->hw_mr.pbl_page_size_log = ilog2(mr->info.pbl_info.pbl_size);
+	mr->hw_mr.page_size_log = ilog2(mr->umem->page_size);
+	mr->hw_mr.fbo = ib_umem_offset(mr->umem);
+	mr->hw_mr.length = len;
+	mr->hw_mr.vaddr = usr_addr;
+	mr->hw_mr.zbva = false;
+	mr->hw_mr.phy_mr = false;
+	mr->hw_mr.dma_mr = false;
+
+	rc = dev->ops->rdma_register_tid(dev->rdma_ctx, &mr->hw_mr);
+	if (rc) {
+		DP_ERR(dev, "roce register tid returned an error %d\n", rc);
+		goto err2;
+	}
+
+	mr->ibmr.lkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
+	if (mr->hw_mr.remote_write || mr->hw_mr.remote_read ||
+	    mr->hw_mr.remote_atomic)
+		mr->ibmr.rkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
+
+	DP_DEBUG(dev, QEDR_MSG_MR, "register user mr lkey: %x\n",
+		 mr->ibmr.lkey);
+	return &mr->ibmr;
+
+err2:
+	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
+err1:
+	qedr_free_pbl(dev, &mr->info.pbl_info, mr->info.pbl_table);
+err0:
+	kfree(mr);
+	return ERR_PTR(rc);
+}
+
+int qedr_dereg_mr(struct ib_mr *ib_mr)
+{
+	struct qedr_mr *mr = get_qedr_mr(ib_mr);
+	struct qedr_dev *dev = get_qedr_dev(ib_mr->device);
+	int rc = 0;
+
+	rc = dev->ops->rdma_deregister_tid(dev->rdma_ctx, mr->hw_mr.itid);
+	if (rc)
+		return rc;
+
+	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
+
+	if ((mr->type != QEDR_MR_DMA) && (mr->type != QEDR_MR_FRMR))
+		qedr_free_pbl(dev, &mr->info.pbl_info, mr->info.pbl_table);
+
+	/* it could be user registered memory. */
+	if (mr->umem)
+		ib_umem_release(mr->umem);
+
+	kfree(mr);
+
+	return rc;
+}
+
+struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd, int max_page_list_len)
+{
+	struct qedr_pd *pd = get_qedr_pd(ibpd);
+	struct qedr_dev *dev = get_qedr_dev(ibpd->device);
+	struct qedr_mr *mr;
+	int rc = -ENOMEM;
+
+	DP_DEBUG(dev, QEDR_MSG_MR,
+		 "qedr_alloc_frmr pd = %d max_page_list_len= %d\n", pd->pd_id,
+		 max_page_list_len);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(rc);
+
+	mr->dev = dev;
+	mr->type = QEDR_MR_FRMR;
+
+	rc = init_mr_info(dev, &mr->info, max_page_list_len, 1);
+	if (rc)
+		goto err0;
+
+	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
+	if (rc) {
+		DP_ERR(dev, "roce alloc tid returned an error %d\n", rc);
+		goto err0;
+	}
+
+	/* Index only, 18 bit long, lkey = itid << 8 | key */
+	mr->hw_mr.tid_type = QED_RDMA_TID_FMR;
+	mr->hw_mr.key = 0;
+	mr->hw_mr.pd = pd->pd_id;
+	mr->hw_mr.local_read = 1;
+	mr->hw_mr.local_write = 0;
+	mr->hw_mr.remote_read = 0;
+	mr->hw_mr.remote_write = 0;
+	mr->hw_mr.remote_atomic = 0;
+	mr->hw_mr.mw_bind = false;
+	mr->hw_mr.pbl_ptr = 0;
+	mr->hw_mr.pbl_two_level = mr->info.pbl_info.two_layered;
+	mr->hw_mr.pbl_page_size_log = ilog2(mr->info.pbl_info.pbl_size);
+	mr->hw_mr.fbo = 0;
+	mr->hw_mr.length = 0;
+	mr->hw_mr.vaddr = 0;
+	mr->hw_mr.zbva = false;
+	mr->hw_mr.phy_mr = true;
+	mr->hw_mr.dma_mr = false;
+
+	rc = dev->ops->rdma_register_tid(dev->rdma_ctx, &mr->hw_mr);
+	if (rc) {
+		DP_ERR(dev, "roce register tid returned an error %d\n", rc);
+		goto err1;
+	}
+
+	mr->ibmr.lkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
+	mr->ibmr.rkey = mr->ibmr.lkey;
+
+	DP_DEBUG(dev, QEDR_MSG_MR, "alloc frmr: %x\n", mr->ibmr.lkey);
+	return mr;
+
+err1:
+	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
+err0:
+	kfree(mr);
+	return ERR_PTR(rc);
+}
+
+struct ib_mr *qedr_alloc_mr(struct ib_pd *ibpd,
+			    enum ib_mr_type mr_type, u32 max_num_sg)
+{
+	struct qedr_dev *dev;
+	struct qedr_mr *mr;
+
+	if (mr_type != IB_MR_TYPE_MEM_REG)
+		return ERR_PTR(-EINVAL);
+
+	mr = __qedr_alloc_mr(ibpd, max_num_sg);
+
+	if (IS_ERR(mr))
+		return ERR_PTR(-EINVAL);
+
+	dev = mr->dev;
+
+	return &mr->ibmr;
+}
+
+static int qedr_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct qedr_mr *mr = get_qedr_mr(ibmr);
+	struct qedr_pbl *pbl_table;
+	struct regpair *pbe;
+	u32 pbes_in_page;
+
+	if (unlikely(mr->npages == mr->info.pbl_info.num_pbes)) {
+		DP_ERR(mr->dev, "qedr_set_page failes when %d\n", mr->npages);
+		return -ENOMEM;
+	}
+
+	DP_DEBUG(mr->dev, QEDR_MSG_MR, "qedr_set_page pages[%d] = 0x%llx\n",
+		 mr->npages, addr);
+
+	pbes_in_page = mr->info.pbl_info.pbl_size / sizeof(u64);
+	pbl_table = mr->info.pbl_table + (mr->npages / pbes_in_page);
+	pbe = (struct regpair *)pbl_table->va;
+	pbe +=  mr->npages % pbes_in_page;
+	pbe->lo = cpu_to_le32((u32)addr);
+	pbe->hi = cpu_to_le32((u32)upper_32_bits(addr));
+
+	mr->npages++;
+
+	return 0;
+}
+
+static void handle_completed_mrs(struct qedr_dev *dev, struct mr_info *info)
+{
+	int work = info->completed - info->completed_handled - 1;
+
+	DP_DEBUG(dev, QEDR_MSG_MR, "Special FMR work = %d\n", work);
+	while (work-- > 0 && !list_empty(&info->inuse_pbl_list)) {
+		struct qedr_pbl *pbl;
+
+		/* Free all the page list that are possible to be freed
+		 * (all the ones that were invalidated), under the assumption
+		 * that if an FMR was completed successfully that means that
+		 * if there was an invalidate operation before it also ended
+		 */
+		pbl = list_first_entry(&info->inuse_pbl_list,
+				       struct qedr_pbl, list_entry);
+		list_del(&pbl->list_entry);
+		list_add_tail(&pbl->list_entry, &info->free_pbl_list);
+		info->completed_handled++;
+	}
+}
+
+int qedr_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		   int sg_nents, unsigned int *sg_offset)
+{
+	struct qedr_mr *mr = get_qedr_mr(ibmr);
+
+	mr->npages = 0;
+
+	handle_completed_mrs(mr->dev, &mr->info);
+	return ib_sg_to_pages(ibmr, sg, sg_nents, NULL, qedr_set_page);
+}
+
+struct ib_mr *qedr_get_dma_mr(struct ib_pd *ibpd, int acc)
+{
+	struct qedr_dev *dev = get_qedr_dev(ibpd->device);
+	struct qedr_pd *pd = get_qedr_pd(ibpd);
+	struct qedr_mr *mr;
+	int rc;
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->type = QEDR_MR_DMA;
+
+	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
+	if (rc) {
+		DP_ERR(dev, "roce alloc tid returned an error %d\n", rc);
+		goto err1;
+	}
+
+	/* index only, 18 bit long, lkey = itid << 8 | key */
+	mr->hw_mr.tid_type = QED_RDMA_TID_REGISTERED_MR;
+	mr->hw_mr.pd = pd->pd_id;
+	mr->hw_mr.local_read = 1;
+	mr->hw_mr.local_write = (acc & IB_ACCESS_LOCAL_WRITE) ? 1 : 0;
+	mr->hw_mr.remote_read = (acc & IB_ACCESS_REMOTE_READ) ? 1 : 0;
+	mr->hw_mr.remote_write = (acc & IB_ACCESS_REMOTE_WRITE) ? 1 : 0;
+	mr->hw_mr.remote_atomic = (acc & IB_ACCESS_REMOTE_ATOMIC) ? 1 : 0;
+	mr->hw_mr.dma_mr = true;
+
+	rc = dev->ops->rdma_register_tid(dev->rdma_ctx, &mr->hw_mr);
+	if (rc) {
+		DP_ERR(dev, "roce register tid returned an error %d\n", rc);
+		goto err2;
+	}
+
+	mr->ibmr.lkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
+	if (mr->hw_mr.remote_write || mr->hw_mr.remote_read ||
+	    mr->hw_mr.remote_atomic)
+		mr->ibmr.rkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
+
+	DP_DEBUG(dev, QEDR_MSG_MR, "get dma mr: lkey = %x\n", mr->ibmr.lkey);
+	return &mr->ibmr;
+
+err2:
+	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
+err1:
+	kfree(mr);
+	return ERR_PTR(rc);
+}
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 056d6cb..ce062dc 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -70,4 +70,18 @@ int qedr_query_qp(struct ib_qp *, struct ib_qp_attr *qp_attr,
 		  int qp_attr_mask, struct ib_qp_init_attr *);
 int qedr_destroy_qp(struct ib_qp *ibqp);
 
+struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr);
+int qedr_destroy_ah(struct ib_ah *ibah);
+
+int qedr_dereg_mr(struct ib_mr *);
+struct ib_mr *qedr_get_dma_mr(struct ib_pd *, int acc);
+
+struct ib_mr *qedr_reg_user_mr(struct ib_pd *, u64 start, u64 length,
+			       u64 virt, int acc, struct ib_udata *);
+
+int qedr_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		   int sg_nents, unsigned int *sg_offset);
+
+struct ib_mr *qedr_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
+			    u32 max_num_sg);
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
