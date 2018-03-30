From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/ocrdma_hw: Remove redundant checks and goto labels
Date: Fri, 30 Mar 2018 10:38:58 -0500
Message-ID: <20180330153858.GA14385@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Check on return values and goto label mbx_err are unnecessary.

Addresses-Coverity-ID: 1271151 ("Identical code for different branches")
Addresses-Coverity-ID: 1268788 ("Identical code for different branches")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 9904918..90cf772 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2014,7 +2014,7 @@ static int ocrdma_mbx_reg_mr_cont(struct ocrdma_dev *dev,
 				  struct ocrdma_hw_mr *hwmr, u32 pbl_cnt,
 				  u32 pbl_offset, u32 last)
 {
-	int status = -ENOMEM;
+	int status;
 	int i;
 	struct ocrdma_reg_nsmr_cont *cmd;
 
@@ -2033,9 +2033,7 @@ static int ocrdma_mbx_reg_mr_cont(struct ocrdma_dev *dev,
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
@@ -3133,12 +3131,12 @@ static int ocrdma_create_eqs(struct ocrdma_dev *dev)
 static int ocrdma_mbx_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
 				 int num)
 {
-	int i, status = -ENOMEM;
+	int i, status;
 	struct ocrdma_modify_eqd_req *cmd;
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_MODIFY_EQ_DELAY, sizeof(*cmd));
 	if (!cmd)
-		return status;
+		return -ENOMEM;
 
 	ocrdma_init_mch(&cmd->cmd.req, OCRDMA_CMD_MODIFY_EQ_DELAY,
 			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
@@ -3151,9 +3149,7 @@ static int ocrdma_mbx_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
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
-- 
2.7.4
