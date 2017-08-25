From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v1 04/11] IB/rxe: Fix up the responder's find_resources() function
Date: Fri, 25 Aug 2017 15:05:49 -0400
Message-ID: <1503687956-7110-5-git-send-email-andrew.boyer@dell.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503687956-7110-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The resource array is sized by max_dest_rd_atomic, not max_rd_atomic.
Iterating over max_rd_atomic entries of qp->resp.resources[] will cause
incorrect behavior when the two attributes are different (or even
crash if max_rd_atomic is larger).

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index a958ee9..4240866 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1055,7 +1055,7 @@ static struct resp_res *find_resource(struct rxe_qp *qp, u32 psn)
 {
 	int i;
 
-	for (i = 0; i < qp->attr.max_rd_atomic; i++) {
+	for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
 		struct resp_res *res = &qp->resp.resources[i];
 
 		if (res->type == 0)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
