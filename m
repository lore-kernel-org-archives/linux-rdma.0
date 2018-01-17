From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/4] IB/srpt: notify QP on Last WQE Reached event arrival
Date: Wed, 17 Jan 2018 15:52:58 +0200
Message-ID: <1516197178-26493-5-git-send-email-maxg@mellanox.com>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197178-26493-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to avoid resource leakage for QP associated with
a Shared Receive Queue (SRQ), notify it on Last WQE Reached
event arrival.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index bfa576a..241c8eb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -209,6 +209,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		pr_debug("%s-%d, state %s: received Last WQE event.\n",
 			 ch->sess_name, ch->qp->qp_num,
 			 get_ch_state_name(ch->state));
+		ib_notify_qp(ch->qp, event->event);
 		break;
 	default:
 		pr_err("received unrecognized IB QP event %d\n", event->event);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
