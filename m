From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 12/15] IB/rxe: Fix a MR reference leak in check_rkey()
Date: Tue, 10 Jan 2017 11:15:51 -0800
Message-ID: <20170110191554.17359-13-bart.vanassche@sandisk.com>
References: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110191554.17359-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that calling check_rkey() for mem->state == RXE_MEM_STATE_FREE
triggers an MR reference leak.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 33defaddc000..60d78f45aa04 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -418,7 +418,7 @@ static enum resp_states check_length(struct rxe_qp *qp,
 static enum resp_states check_rkey(struct rxe_qp *qp,
 				   struct rxe_pkt_info *pkt)
 {
-	struct rxe_mem *mem;
+	struct rxe_mem *mem = NULL;
 	u64 va;
 	u32 rkey;
 	u32 resid;
@@ -459,38 +459,38 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 	mem = lookup_mem(qp->pd, access, rkey, lookup_remote);
 	if (!mem) {
 		state = RESPST_ERR_RKEY_VIOLATION;
-		goto err1;
+		goto err;
 	}
 
 	if (unlikely(mem->state == RXE_MEM_STATE_FREE)) {
 		state = RESPST_ERR_RKEY_VIOLATION;
-		goto err1;
+		goto err;
 	}
 
 	if (mem_check_range(mem, va, resid)) {
 		state = RESPST_ERR_RKEY_VIOLATION;
-		goto err2;
+		goto err;
 	}
 
 	if (pkt->mask & RXE_WRITE_MASK)	 {
 		if (resid > mtu) {
 			if (pktlen != mtu || bth_pad(pkt)) {
 				state = RESPST_ERR_LENGTH;
-				goto err2;
+				goto err;
 			}
 
 			resid = mtu;
 		} else {
 			if (pktlen != resid) {
 				state = RESPST_ERR_LENGTH;
-				goto err2;
+				goto err;
 			}
 			if ((bth_pad(pkt) != (0x3 & (-resid)))) {
 				/* This case may not be exactly that
 				 * but nothing else fits.
 				 */
 				state = RESPST_ERR_LENGTH;
-				goto err2;
+				goto err;
 			}
 		}
 	}
@@ -500,9 +500,9 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 	qp->resp.mr = mem;
 	return RESPST_EXECUTE;
 
-err2:
-	rxe_drop_ref(mem);
-err1:
+err:
+	if (mem)
+		rxe_drop_ref(mem);
 	return state;
 }
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
