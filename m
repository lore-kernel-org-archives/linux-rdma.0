From: Pan Bian <bianpan201602@163.com>
Subject: [PATCH 1/1] infiniband: hw: ocrdma: fix bad initialization
Date: Sat,  3 Dec 2016 21:10:21 +0800
Message-ID: <1480770621-6249-1-git-send-email-bianpan201602@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@avagotech.com>, Devesh Sharma <devesh.sharma@avagotech.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-rdma@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

In function ocrdma_mbx_create_ah_tbl(), returns the value of status on
errors. However, because status is initialized with 0, 0 will be
returned even if on error paths. This patch initialize status with
"-ENOMEM".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188831

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 67fc0b6..6876a71 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1642,7 +1642,7 @@ static int ocrdma_build_q_conf(u32 *num_entries, int entry_size,
 static int ocrdma_mbx_create_ah_tbl(struct ocrdma_dev *dev)
 {
 	int i;
-	int status = 0;
+	int status = -ENOMEM;
 	int max_ah;
 	struct ocrdma_create_ah_tbl *cmd;
 	struct ocrdma_create_ah_tbl_rsp *rsp;
-- 
1.9.1
