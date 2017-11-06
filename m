From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Mon, 6 Nov 2017 08:35:14 -0600
Message-ID: <20171106143514.GA19786@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Check on return value and goto label mbx_err are unnecessary.

Addresses-Coverity-ID: 1268780
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index f8c14c7..db02bbb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1956,9 +1956,7 @@ int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev *dev, int fr_mr, u32 lkey)
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
-- 
2.7.4
