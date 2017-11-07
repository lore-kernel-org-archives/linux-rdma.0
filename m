From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 7 Nov 2017 08:45:17 -0600
Message-ID: <20171107144517.GA25631@embeddedor.com>
References: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Check on return value and goto label mbx_err are unnecessary.

Addresses-Coverity-ID: 1268780
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
Changes in v2:
 Remove assignment from "int status = -ENOMEM" as suggested by Leon Romanovsky.

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index f8c14c7..0ba695a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1947,7 +1947,7 @@ int ocrdma_mbx_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_hw_mr *hwmr,
 
 int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev *dev, int fr_mr, u32 lkey)
 {
-	int status = -ENOMEM;
+	int status;
 	struct ocrdma_dealloc_lkey *cmd;
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_DEALLOC_LKEY, sizeof(*cmd));
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
