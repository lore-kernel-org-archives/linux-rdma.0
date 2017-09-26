From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH v2] IB/ocrdma: pr_err() strings should end with newlines
Date: Tue, 26 Sep 2017 12:59:51 +0530
Message-ID: <48e72f72b25c067588b3da9142c7849636615df9.1506410780.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: devesh.sharma@broadcom.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, yuval.shaia@oracle.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

pr_err() messages should end with a new-line to avoid other messages
being concatenated.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2 :
               Add same changes for 'ocrdma_hw.c'

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index dcb5942..b5cb69f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1090,7 +1090,7 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 		rsp = &mqe->u.rsp;
 
 	if (cqe_status || ext_status) {
-		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,",
+		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,\n",
 		       __func__, cqe_status, ext_status);
 		if (rsp) {
 			/* This is for embedded cmds. */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 66056f9..e528d7a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -658,7 +658,7 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
 		if (reset) {
 			status = ocrdma_mbx_rdma_stats(dev, true);
 			if (status) {
-				pr_err("Failed to reset stats = %d", status);
+				pr_err("Failed to reset stats = %d\n", status);
 				goto err;
 			}
 		}
-- 
1.9.1
