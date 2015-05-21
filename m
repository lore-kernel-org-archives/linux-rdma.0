From: Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] RDMA/ocrdma: remove unneeded tests
Date: Thu, 21 May 2015 22:07:04 +0200
Message-ID: <1432238824-16953-1-git-send-email-laurent.navet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: selvin.xavier@emulex.com, devesh.sharma@emulex.com, mitesh.ahuja@emulex.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
List-Id: linux-rdma@vger.kernel.org

The same code is executed regardless status value, so these tests can
be removed.
Fix Coverity CID 1271151 and 1268788

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 0c9e959..e748090 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1960,9 +1960,6 @@ static int ocrdma_mbx_reg_mr_cont(struct ocrdma_dev *dev,
 		    upper_32_bits(hwmr->pbl_table[i + pbl_offset].pa);
 	}
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
-mbx_err:
 	kfree(cmd);
 	return status;
 }
@@ -3044,9 +3041,6 @@ static int ocrdma_mbx_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
 				(eq[i].aic_obj.prev_eqd * 65)/100;
 	}
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
-mbx_err:
 	kfree(cmd);
 	return status;
 }
-- 
2.1.4
