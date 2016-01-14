From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v3 2/6] InfiniBand-ocrdma: Delete unnecessary variable
 initialisations in 11 functions
Date: Thu, 14 Jan 2016 18:43:13 +0100
Message-ID: <5697DE31.9040309@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
 <5697D865.5010507@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5697D865.5010507@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Jan 2016 17:47:59 +0100

The variable "status" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 12 ++++++------
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index a343e03..41f0171 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -59,7 +59,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 			struct ib_ah_attr *attr, union ib_gid *sgid,
 			int pdid, bool *isvlan, u16 vlan_tag)
 {
-	int status = 0;
+	int status;
 	struct ocrdma_eth_vlan eth;
 	struct ocrdma_grh grh;
 	int eth_sz;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 283ca84..159b1d5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1113,7 +1113,7 @@ mbx_err:
 static int ocrdma_nonemb_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe,
 				 void *payload_va)
 {
-	int status = 0;
+	int status;
 	struct ocrdma_mbx_rsp *rsp = payload_va;
 
 	if ((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK) >>
@@ -2871,7 +2871,7 @@ int ocrdma_mbx_destroy_srq(struct ocrdma_dev *dev, struct ocrdma_srq *srq)
 static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
 				      struct ocrdma_dcbx_cfg *dcbxcfg)
 {
-	int status = 0;
+	int status;
 	dma_addr_t pa;
 	struct ocrdma_mqe cmd;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 86c303a..119baa3 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -608,7 +608,7 @@ static char *ocrdma_driver_dbg_stats(struct ocrdma_dev *dev)
 static void ocrdma_update_stats(struct ocrdma_dev *dev)
 {
 	ulong now = jiffies, secs;
-	int status = 0;
+	int status;
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		      (struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
 	struct ocrdma_rsrc_stats *rsrc_stats = &rdma_stats->act_rsrc_stats;
@@ -639,7 +639,7 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
 {
 	char tmp_str[32];
 	long reset;
-	int status = 0;
+	int status;
 	struct ocrdma_stats *pstats = filp->private_data;
 	struct ocrdma_dev *dev = pstats->dev;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 4caf167..1d90d18 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -419,7 +419,7 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 					  struct ib_udata *udata)
 {
 	struct ocrdma_pd *pd = NULL;
-	int status = 0;
+	int status;
 
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
@@ -468,7 +468,7 @@ static inline int is_ucontext_pd(struct ocrdma_ucontext *uctx,
 static int _ocrdma_dealloc_pd(struct ocrdma_dev *dev,
 			      struct ocrdma_pd *pd)
 {
-	int status = 0;
+	int status;
 
 	if (dev->pd_mgr->pd_prealloc_valid)
 		status = ocrdma_put_pd_num(dev, pd->id, pd->dpp_enabled);
@@ -593,7 +593,7 @@ map_err:
 
 int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 {
-	int status = 0;
+	int status;
 	struct ocrdma_mm *mm, *tmp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ibctx);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibctx->device);
@@ -620,7 +620,7 @@ int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	unsigned long vm_page = vma->vm_pgoff << PAGE_SHIFT;
 	u64 unmapped_db = (u64) dev->nic_info.unmapped_db;
 	unsigned long len = (vma->vm_end - vma->vm_start);
-	int status = 0;
+	int status;
 	bool found;
 
 	if (vma->vm_start & (PAGE_SIZE - 1))
@@ -1283,7 +1283,7 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 				struct ib_udata *udata, int dpp_offset,
 				int dpp_credit_lmt, int srq)
 {
-	int status = 0;
+	int status;
 	u64 usr_db;
 	struct ocrdma_create_qp_uresp uresp;
 	struct ocrdma_pd *pd = qp->pd;
@@ -1947,7 +1947,7 @@ int ocrdma_modify_srq(struct ib_srq *ibsrq,
 		      enum ib_srq_attr_mask srq_attr_mask,
 		      struct ib_udata *udata)
 {
-	int status = 0;
+	int status;
 	struct ocrdma_srq *srq;
 
 	srq = get_ocrdma_srq(ibsrq);
-- 
2.6.3
