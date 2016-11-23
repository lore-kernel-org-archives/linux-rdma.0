From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 3/8] IB/rxe: Don't update the response PSN unless it's going forwards
Date: Wed, 23 Nov 2016 12:39:19 -0500
Message-ID: <1479922764-13091-4-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A client might post a read followed by a send. The partner receives
and acknowledges both transactions, posting an RCQ entry for the
send, but something goes wrong with the read ACK. When the client
retries the read, the partner's responder processes the duplicate
read but incorrectly resets the PSN to the value preceding the
original send. When the duplicate send arrives, the responder cannot
tell that it is a duplicate, so the responder generates a duplicate
RCQ entry, confusing the client.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Reviewed-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index dd3d88a..cb3fd4c 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -742,7 +742,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	} else {
 		qp->resp.res = NULL;
 		qp->resp.opcode = -1;
-		qp->resp.psn = res->cur_psn;
+		if (psn_compare(res->cur_psn, qp->resp.psn) >= 0)
+			qp->resp.psn = res->cur_psn;
 		state = RESPST_CLEANUP;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
