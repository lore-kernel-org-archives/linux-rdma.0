From: Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 1/4] IB/isert: fix T10-pi check mask setting
Date: Thu, 31 May 2018 11:05:23 +0300
Message-ID: <1527753926-18593-2-git-send-email-maxg@mellanox.com>
References: <1527753926-18593-1-git-send-email-maxg@mellanox.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1527753926-18593-1-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: leonro@mellanox.com, jgg@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org
Cc: sagi@grimberg.me, hch@lst.de, martin.petersen@oracle.com, Max Gurtovoy <maxg@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

A copy/paste bug (probably) caused setting of an app_tag check mask
in case where a ref_tag check was needed.

Fixes: 38a2d0d429f1 ("IB/isert: convert to the generic RDMA READ/WRITE API")
Fixes: 9e961ae73c2c ("IB/isert: Support T10-PI protected transactions")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index fff40b0..d8b6bde 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2108,7 +2108,7 @@
 
 	sig_attrs->check_mask =
 	       (se_cmd->prot_checks & TARGET_DIF_CHECK_GUARD  ? 0xc0 : 0) |
-	       (se_cmd->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x30 : 0) |
+	       (se_cmd->prot_checks & TARGET_DIF_CHECK_APPTAG ? 0x30 : 0) |
 	       (se_cmd->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x0f : 0);
 	return 0;
 }
-- 
1.8.3.1
