From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] RDMA/nes: remove redundant check on udata
Date: Sat,  2 Mar 2019 23:06:36 +0000
Message-ID: <20190302230637.8624-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The non-null check on udata is redundant as this check was performed
just a few statements earlier and the check is always true as udata
must be non-null at this point. Remove redundant the check on udata
and the redundant else part that can never be executed.

Detected by CoverityScan, CID#1477317 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 73 +++++++++++++--------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 828e4af3f951..526092d435df 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1039,53 +1039,48 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 				}
 				if (req.user_qp_buffer)
 					nesqp->nesuqp_addr = req.user_qp_buffer;
-				if (udata) {
-					nesqp->user_mode = 1;
-					if (virt_wqs) {
-						err = 1;
-						list_for_each_entry(nespbl, &nes_ucontext->qp_reg_mem_list, list) {
-							if (nespbl->user_base == (unsigned long )req.user_wqe_buffers) {
-								list_del(&nespbl->list);
-								err = 0;
-								nes_debug(NES_DBG_QP, "Found PBL for virtual QP. nespbl=%p. user_base=0x%lx\n",
-									  nespbl, nespbl->user_base);
-								break;
-							}
-						}
-						if (err) {
-							nes_debug(NES_DBG_QP, "Didn't Find PBL for virtual QP. address = %llx.\n",
-								  (long long unsigned int)req.user_wqe_buffers);
-							nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
-							kfree(nesqp->allocated_buffer);
-							return ERR_PTR(-EFAULT);
+
+				nesqp->user_mode = 1;
+				if (virt_wqs) {
+					err = 1;
+					list_for_each_entry(nespbl, &nes_ucontext->qp_reg_mem_list, list) {
+						if (nespbl->user_base == (unsigned long )req.user_wqe_buffers) {
+							list_del(&nespbl->list);
+							err = 0;
+							nes_debug(NES_DBG_QP, "Found PBL for virtual QP. nespbl=%p. user_base=0x%lx\n",
+								  nespbl, nespbl->user_base);
+							break;
 						}
 					}
-
-					nesqp->mmap_sq_db_index =
-						find_next_zero_bit(nes_ucontext->allocated_wqs,
-								   NES_MAX_USER_WQ_REGIONS, nes_ucontext->first_free_wq);
-					/* nes_debug(NES_DBG_QP, "find_first_zero_biton wqs returned %u\n",
-							nespd->mmap_db_index); */
-					if (nesqp->mmap_sq_db_index >= NES_MAX_USER_WQ_REGIONS) {
-						nes_debug(NES_DBG_QP,
-							  "db index > max user regions, failing create QP\n");
+					if (err) {
+						nes_debug(NES_DBG_QP, "Didn't Find PBL for virtual QP. address = %llx.\n",
+							  (long long unsigned int)req.user_wqe_buffers);
 						nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
-						if (virt_wqs) {
-							pci_free_consistent(nesdev->pcidev, nespbl->pbl_size, nespbl->pbl_vbase,
-									    nespbl->pbl_pbase);
-							kfree(nespbl);
-						}
 						kfree(nesqp->allocated_buffer);
-						return ERR_PTR(-ENOMEM);
+						return ERR_PTR(-EFAULT);
 					}
-					set_bit(nesqp->mmap_sq_db_index, nes_ucontext->allocated_wqs);
-					nes_ucontext->mmap_nesqp[nesqp->mmap_sq_db_index] = nesqp;
-					nes_ucontext->first_free_wq = nesqp->mmap_sq_db_index + 1;
-				} else {
+				}
+
+				nesqp->mmap_sq_db_index =
+					find_next_zero_bit(nes_ucontext->allocated_wqs,
+							   NES_MAX_USER_WQ_REGIONS, nes_ucontext->first_free_wq);
+				/* nes_debug(NES_DBG_QP, "find_first_zero_biton wqs returned %u\n",
+						nespd->mmap_db_index); */
+				if (nesqp->mmap_sq_db_index >= NES_MAX_USER_WQ_REGIONS) {
+					nes_debug(NES_DBG_QP,
+						  "db index > max user regions, failing create QP\n");
 					nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
+					if (virt_wqs) {
+						pci_free_consistent(nesdev->pcidev, nespbl->pbl_size, nespbl->pbl_vbase,
+								    nespbl->pbl_pbase);
+						kfree(nespbl);
+					}
 					kfree(nesqp->allocated_buffer);
-					return ERR_PTR(-EFAULT);
+					return ERR_PTR(-ENOMEM);
 				}
+				set_bit(nesqp->mmap_sq_db_index, nes_ucontext->allocated_wqs);
+				nes_ucontext->mmap_nesqp[nesqp->mmap_sq_db_index] = nesqp;
+				nes_ucontext->first_free_wq = nesqp->mmap_sq_db_index + 1;
 			}
 			err = (!virt_wqs) ? nes_setup_mmap_qp(nesqp, nesvnic, sq_size, rq_size) :
 					nes_setup_virt_qp(nesqp, nespbl, nesvnic, sq_size, rq_size);
-- 
2.20.1
