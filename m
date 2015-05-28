From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 4/9] RDMA/ocrdma: drop unneeded goto
Date: Thu, 28 May 2015 23:02:19 +0200
Message-ID: <1432846944-7122-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1432846944-7122-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1432846944-7122-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@emulex.com>
Cc: kernel-janitors@vger.kernel.org, Devesh Sharma <devesh.sharma@emulex.com>, Mitesh Ahuja <mitesh.ahuja@emulex.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete jump to a label on the next line, when that label is not
used elsewhere.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier l;
@@

-if (...) goto l;
-l:
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 47615ff..0f3b5ea 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1884,9 +1884,7 @@ int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev *dev, int fr_mr, u32 lkey)
 	cmd->lkey = lkey;
 	cmd->rsvd_frmr = fr_mr ? 1 : 0;
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
-mbx_err:
+
 	kfree(cmd);
 	return status;
 }
@@ -1965,9 +1963,7 @@ static int ocrdma_mbx_reg_mr_cont(struct ocrdma_dev *dev,
 		    upper_32_bits(hwmr->pbl_table[i + pbl_offset].pa);
 	}
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
-mbx_err:
+
 	kfree(cmd);
 	return status;
 }
@@ -2648,10 +2644,7 @@ int ocrdma_mbx_destroy_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
 		return status;
 	cmd->qp_id = qp->id;
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
 
-mbx_err:
 	kfree(cmd);
 	if (qp->sq.va)
 		dma_free_coherent(&pdev->dev, qp->sq.len, qp->sq.va, qp->sq.pa);
@@ -3061,9 +3054,7 @@ static int ocrdma_mbx_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
 				(eq[i].aic_obj.prev_eqd * 65)/100;
 	}
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
-mbx_err:
+
 	kfree(cmd);
 	return status;
 }

