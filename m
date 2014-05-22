From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/4] IB/iser: Fix a possible race in iser connection states transition
Date: Thu, 22 May 2014 11:00:19 +0300
Message-ID: <1400745621-9978-3-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
References: <1400745621-9978-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400745621-9978-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In some circumstances (multiple targets), RDMA_CM ESTABLISHED event and
ep_disconnect may race. In this case, the iser connection state may
transition to UP (after ep_disconnect transitioned it to TERMINATING),
while the connection is being teared down.

Upon RDMA_CM event ESTABLISHED we allow iser connection state to transition
to UP only from PENDING. We also make sure to protect this state change
(done under the connection lock).

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 4c698e5..ea01075 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -732,8 +732,8 @@ static void iser_connected_handler(struct rdma_cm_id *cma_id)
 	iser_info("remote qpn:%x my qpn:%x\n", attr.dest_qp_num, cma_id->qp->qp_num);
 
 	ib_conn = (struct iser_conn *)cma_id->context;
-	ib_conn->state = ISER_CONN_UP;
-	wake_up_interruptible(&ib_conn->wait);
+	if (iser_conn_state_comp_exch(ib_conn, ISER_CONN_PENDING, ISER_CONN_UP))
+		wake_up_interruptible(&ib_conn->wait);
 }
 
 static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
