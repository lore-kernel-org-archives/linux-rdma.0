From: Israel Rukshin <israelr@mellanox.com>
Subject: [PATCH V2] IB/srp: Fix NULL deref at srp_destroy_qp()
Date: Thu, 11 May 2017 18:52:36 +0300
Message-ID: <1494517956-26669-1-git-send-email-israelr@mellanox.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma <linux-rdma@vger.kernel.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, Israel Rukshin <israelr@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

If srp_init_qp() fails at srp_create_ch_ib() then ch->send_cq
may be NULL.
Calling directly to ib_destroy_qp() is sufficient because
no work requests were posted on the created qp.

Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying a QP")
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Cc: <stable@vger.kernel.org>
---

v2 change:
-add Fixes to commit message

 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index def723a..4306285 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -575,7 +575,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	return 0;
 
 err_qp:
-	srp_destroy_qp(ch, qp);
+	ib_destroy_qp(qp);
 
 err_send_cq:
 	ib_free_cq(send_cq);
-- 
2.4.3
