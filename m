From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH] infiniband: scsi: remove unnecessary unlikely()
Date: Fri, 31 Aug 2018 23:16:45 +0300
Message-ID: <20180831201645.15611-1-igor.stoppa@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: igor.stoppa@gmail.com, Igor Stoppa <igor.stoppa@huawei.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

WARN_ON() already contains an unlikely(), so it's not necessary to
wrap it into another.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org (open list:SCSI RDMA PROTOCOL (SRP) TARGET)
Cc: linux-kernel@vger.kernel.org (open list)
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f37cbad022a2..447d21ea479a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2708,7 +2708,7 @@ static void srpt_queue_response(struct se_cmd *cmd)
 		break;
 	}
 
-	if (unlikely(WARN_ON_ONCE(state == SRPT_STATE_CMD_RSP_SENT)))
+	if (WARN_ON_ONCE(state == SRPT_STATE_CMD_RSP_SENT))
 		return;
 
 	/* For read commands, transfer the data to the initiator. */
-- 
2.17.1
