From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 7/8] IB/rxe: Fix ref leak in rxe_create_qp()
Date: Wed, 23 Nov 2016 12:39:23 -0500
Message-ID: <1479922764-13091-8-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The udata->inlen error path needs to clean up the ref
added by rxe_alloc().

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
