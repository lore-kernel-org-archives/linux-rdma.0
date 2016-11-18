From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 7/7] IB/rxe: Fix ref leaks in duplicate_request() and rxe_create_qp()
Date: Fri, 18 Nov 2016 09:36:49 -0500
Message-ID: <1479479809-10798-7-git-send-email-andrew.boyer@dell.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479479809-10798-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In duplicate_request(), a ref was added after the call to skb_clone().

In rxe_create_qp(), the udata->inlen error path needs to clean up the ref
added by rxe_alloc().

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c  | 1 +
 drivers/infiniband/sw/rxe/rxe_verbs.c | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index a5e9ce3..8643797 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1145,6 +1145,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 					     pkt, skb_copy);
 			if (rc) {
 				pr_err("Failed resending result. This flow is not handled - skb ignored\n");
+				rxe_drop_ref(qp);
 				kfree_skb(skb_copy);
 				rc = RESPST_CLEANUP;
 				goto out;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index de39b0a..071430c 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -564,7 +564,7 @@ static struct ib_qp *rxe_create_qp(struct ib_pd *ibpd,
 	if (udata) {
 		if (udata->inlen) {
 			err = -EINVAL;
-			goto err1;
+			goto err2;
 		}
 		qp->is_user = 1;
 	}
@@ -573,12 +573,13 @@ static struct ib_qp *rxe_create_qp(struct ib_pd *ibpd,
 
 	err = rxe_qp_from_init(rxe, qp, pd, init, udata, ibpd);
 	if (err)
-		goto err2;
+		goto err3;
 
 	return &qp->ibqp;
 
-err2:
+err3:
 	rxe_drop_index(qp);
+err2:
 	rxe_drop_ref(qp);
 err1:
 	return ERR_PTR(err);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
