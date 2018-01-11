From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 1/3] RDMA: Mark imm_data as be32 in the verbs uapi header
Date: Thu, 11 Jan 2018 14:43:05 -0700
Message-ID: <20180111214307.501-2-jgg@ziepe.ca>
References: <20180111214307.501-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111214307.501-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This matches what the userspace copy of this header has been doing
for a while. imm_data is an opaque 4 byte array carried over the network,
and invalidate_rkey is in CPU byte order.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 drivers/infiniband/sw/rdmavt/cq.c    | 3 +--
 drivers/infiniband/sw/rxe/rxe_resp.c | 3 +--
 include/uapi/rdma/ib_user_verbs.h    | 4 ++--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c216d98bb816a0..4ddd61d905075c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1196,7 +1196,7 @@ static int copy_wc_to_user(struct ib_device *ib_dev, void __user *dest,
 	tmp.opcode		= wc->opcode;
 	tmp.vendor_err		= wc->vendor_err;
 	tmp.byte_len		= wc->byte_len;
-	tmp.ex.imm_data		= (__u32 __force) wc->ex.imm_data;
+	tmp.ex.imm_data		= wc->ex.imm_data;
 	tmp.qp_num		= wc->qp->qp_num;
 	tmp.src_qp		= wc->src_qp;
 	tmp.wc_flags		= wc->wc_flags;
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 61fca14c2598be..fb52b669bfce5c 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -101,8 +101,7 @@ void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited)
 		wc->uqueue[head].opcode = entry->opcode;
 		wc->uqueue[head].vendor_err = entry->vendor_err;
 		wc->uqueue[head].byte_len = entry->byte_len;
-		wc->uqueue[head].ex.imm_data =
-			(__u32 __force)entry->ex.imm_data;
+		wc->uqueue[head].ex.imm_data = entry->ex.imm_data;
 		wc->uqueue[head].qp_num = entry->qp->qp_num;
 		wc->uqueue[head].src_qp = entry->src_qp;
 		wc->uqueue[head].wc_flags = entry->wc_flags;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 4240866a533192..f07324f2cde207 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -863,8 +863,7 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 
 			if (pkt->mask & RXE_IMMDT_MASK) {
 				uwc->wc_flags |= IB_WC_WITH_IMM;
-				uwc->ex.imm_data =
-					(__u32 __force)immdt_imm(pkt);
+				uwc->ex.imm_data = immdt_imm(pkt);
 			}
 
 			if (pkt->mask & RXE_IETH_MASK) {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 7e11bb8651b641..fd035641cf41ce 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -449,7 +449,7 @@ struct ib_uverbs_wc {
 	__u32 vendor_err;
 	__u32 byte_len;
 	union {
-		__u32 imm_data;
+		__be32 imm_data;
 		__u32 invalidate_rkey;
 	} ex;
 	__u32 qp_num;
@@ -765,7 +765,7 @@ struct ib_uverbs_send_wr {
 	__u32 opcode;
 	__u32 send_flags;
 	union {
-		__u32 imm_data;
+		__be32 imm_data;
 		__u32 invalidate_rkey;
 	} ex;
 	union {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
