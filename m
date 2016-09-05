From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/4] IB/rxe: Fix kmem_cache leak
Date: Mon,  5 Sep 2016 15:09:19 +0300
Message-ID: <1473077359-11546-5-git-send-email-leon@kernel.org>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473077359-11546-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Decrement qp reference when handling error path
in completer to prevent kmem_cache leak.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 36f67de..1c59ef2 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -689,7 +689,14 @@ int rxe_completer(void *arg)
 					qp->req.need_retry = 1;
 					rxe_run_task(&qp->req.task, 1);
 				}
+
+				if (pkt) {
+					rxe_drop_ref(pkt->qp);
+					kfree_skb(skb);
+				}
+
 				goto exit;
+
 			} else {
 				wqe->status = IB_WC_RETRY_EXC_ERR;
 				state = COMPST_ERROR;
@@ -716,6 +723,12 @@ int rxe_completer(void *arg)
 		case COMPST_ERROR:
 			do_complete(qp, wqe);
 			rxe_qp_error(qp);
+
+			if (pkt) {
+				rxe_drop_ref(pkt->qp);
+				kfree_skb(skb);
+			}
+
 			goto exit;
 		}
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
