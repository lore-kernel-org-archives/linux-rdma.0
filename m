From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 15/15] IB/rxe: Fix an skb leak
Date: Tue, 10 Jan 2017 11:08:22 -0800
Message-ID: <20170110190822.16953-16-bart.vanassche@sandisk.com>
References: <20170110190822.16953-1-bart.vanassche@sandisk.com>
 <20170110190822.16953-2-bart.vanassche@sandisk.com>
 <20170110190822.16953-3-bart.vanassche@sandisk.com>
 <20170110190822.16953-4-bart.vanassche@sandisk.com>
 <20170110190822.16953-5-bart.vanassche@sandisk.com>
 <20170110190822.16953-6-bart.vanassche@sandisk.com>
 <20170110190822.16953-7-bart.vanassche@sandisk.com>
 <20170110190822.16953-8-bart.vanassche@sandisk.com>
 <20170110190822.16953-9-bart.vanassche@sandisk.com>
 <20170110190822.16953-10-bart.vanassche@sandisk.com>
 <20170110190822.16953-11-bart.vanassche@sandisk.com>
 <20170110190822.16953-12-bart.vanassche@sandisk.com>
 <20170110190822.16953-13-bart.vanassche@sandisk.com>
 <20170110190822.16953-14-bart.vanassche@sandisk.com>
 <20170110190822.16953-15-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110190822.16953-15-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Additionally, make it easier to detect skb leaks by issuing a warning
if a leak occurs.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 91317c159b9a..4cd55d5617f7 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -630,6 +630,7 @@ int rxe_completer(void *arg)
 			if (pkt) {
 				rxe_drop_ref(pkt->qp);
 				kfree_skb(skb);
+				skb = NULL;
 			}
 			goto done;
 
@@ -653,6 +654,7 @@ int rxe_completer(void *arg)
 			    qp->qp_timeout_jiffies)
 				mod_timer(&qp->retrans_timer,
 					  jiffies + qp->qp_timeout_jiffies);
+			WARN_ON_ONCE(skb);
 			goto exit;
 
 		case COMPST_ERROR_RETRY:
@@ -665,8 +667,10 @@ int rxe_completer(void *arg)
 			 */
 
 			/* there is nothing to retry in this case */
-			if (!wqe || (wqe->state == wqe_state_posted))
+			if (!wqe || (wqe->state == wqe_state_posted)) {
+				WARN_ON_ONCE(skb);
 				goto exit;
+			}
 
 			if (qp->comp.retry_cnt > 0) {
 				if (qp->comp.retry_cnt != 7)
@@ -688,8 +692,10 @@ int rxe_completer(void *arg)
 				if (pkt) {
 					rxe_drop_ref(pkt->qp);
 					kfree_skb(skb);
+					skb = NULL;
 				}
 
+				WARN_ON_ONCE(skb);
 				goto exit;
 
 			} else {
@@ -709,6 +715,9 @@ int rxe_completer(void *arg)
 				mod_timer(&qp->rnr_nak_timer,
 					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
 						& ~AETH_TYPE_MASK));
+				rxe_drop_ref(pkt->qp);
+				kfree_skb(skb);
+				skb = NULL;
 				goto exit;
 			} else {
 				wqe->status = IB_WC_RNR_RETRY_EXC_ERR;
@@ -724,8 +733,10 @@ int rxe_completer(void *arg)
 			if (pkt) {
 				rxe_drop_ref(pkt->qp);
 				kfree_skb(skb);
+				skb = NULL;
 			}
 
+			WARN_ON_ONCE(skb);
 			goto exit;
 		}
 	}
@@ -734,6 +745,7 @@ int rxe_completer(void *arg)
 	/* we come here if we are done with processing and want the task to
 	 * exit from the loop calling us
 	 */
+	WARN_ON_ONCE(skb);
 	rxe_drop_ref(qp);
 	return -EAGAIN;
 
@@ -741,6 +753,7 @@ int rxe_completer(void *arg)
 	/* we come here if we have processed a packet we want the task to call
 	 * us again to see if there is anything else to do
 	 */
+	WARN_ON_ONCE(skb);
 	rxe_drop_ref(qp);
 	return 0;
 }
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
