From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 3/3] IB/srp: Protect free_tx iu list from concurrent flows
Date: Mon, 24 Feb 2014 16:30:18 +0200
Message-ID: <1393252218-30638-4-git-send-email-sagig@mellanox.com>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393252218-30638-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

srp_reconnect_rport() serializes calls of srp_rport_reconnect()
with srp_queuecommand(), srp_abort(), srp_reset_device(),
srp_reset_host() via rport->mutex and also blocks srp_queuecommand();
however, it cannot block scsi error handler commands (stu, tur).
This may introduces corruption in free_tx IUs list and IU itself

Signed-off-by: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b615135..656602b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -859,6 +859,7 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
 	int i, ret;
+	unsigned long flags;
 
 	srp_disconnect_target(target);
 	/*
@@ -882,9 +883,11 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 		srp_finish_req(target, req, DID_RESET << 16);
 	}
 
+	spin_lock_irqsave(&target->lock, flags);
 	INIT_LIST_HEAD(&target->free_tx);
 	for (i = 0; i < target->queue_size; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
+	spin_unlock_irqrestore(&target->lock, flags);
 
 	if (ret == 0)
 		ret = srp_connect_target(target);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
