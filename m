From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 5/8] IB/rxe: Add support for zero-byte operations
Date: Wed, 23 Nov 2016 12:39:21 -0500
Message-ID: <1479922764-13091-6-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The last_psn algorithm fails in the zero-byte case: it calculates
first_psn = N, last_psn = N-1. This makes the operation unretryable since
the res structure will fail the (first_psn <= psn <= last_psn) test in
find_resource().

While here, use BTH_PSN_MASK to mask the calculated last_psn.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c   |  3 +++
 drivers/infiniband/sw/rxe/rxe_resp.c | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 1869152..d0faca2 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -355,6 +355,9 @@ int rxe_mem_copy(struct rxe_mem *mem, u64 iova, void *addr, int length,
 	size_t			offset;
 	u32			crc = crcp ? (*crcp) : 0;
 
+	if (length == 0)
+		return 0;
+
 	if (mem->type == RXE_MEM_TYPE_DMA) {
 		u8 *src, *dest;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index cb3fd4c..a5e9ce3 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -444,6 +444,13 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 		return RESPST_EXECUTE;
 	}
 
+	/* A zero-byte op is not required to set an addr or rkey. */
+	if ((pkt->mask & (RXE_READ_MASK | RXE_WRITE_OR_SEND)) &&
+	    (pkt->mask & RXE_RETH_MASK) &&
+	    reth_len(pkt) == 0) {
+		return RESPST_EXECUTE;
+	}
+
 	va	= qp->resp.va;
 	rkey	= qp->resp.rkey;
 	resid	= qp->resp.resid;
@@ -680,9 +687,14 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 		res->read.va_org	= qp->resp.va;
 
 		res->first_psn		= req_pkt->psn;
-		res->last_psn		= req_pkt->psn +
-					  (reth_len(req_pkt) + mtu - 1) /
-					  mtu - 1;
+
+		if (reth_len(req_pkt)) {
+			res->last_psn	= (req_pkt->psn +
+					   (reth_len(req_pkt) + mtu - 1) /
+					   mtu - 1) & BTH_PSN_MASK;
+		} else {
+			res->last_psn	= res->first_psn;
+		}
 		res->cur_psn		= req_pkt->psn;
 
 		res->read.resid		= qp->resp.resid;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
