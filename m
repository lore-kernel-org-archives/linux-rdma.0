From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 6/7] IB/rxe: Fix up one more receive queue drain path that might prevent cleanup
Date: Tue, 25 Jul 2017 09:39:27 -0400
Message-ID: <1500989968-30889-7-git-send-email-andrew.boyer@dell.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: 1217197142d1 ("rxe: fix broken receive queue draining")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 7ee465d..24fc0b8 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -594,8 +594,10 @@ int rxe_requester(void *arg)
 	rxe_add_ref(qp);
 
 next_wqe:
-	if (unlikely(!qp->valid))
+	if (unlikely(!qp->valid)) {
+		rxe_drain_req_pkts(qp, true);
 		goto exit;
+	}
 
 	if (unlikely(qp->req.state == QP_STATE_ERROR)) {
 		rxe_drain_req_pkts(qp, true);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
