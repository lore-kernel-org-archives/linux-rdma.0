From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/5] IB/rxe: Prefer 'unsigned int' to bare use of 'unsigned'
Date: Thu, 15 Jun 2017 11:29:04 +0300
Message-ID: <20170615082907.5658-3-leon@kernel.org>
References: <20170615082907.5658-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  | 2 +-
 drivers/infiniband/sw/rxe/rxe_pool.c | 2 +-
 drivers/infiniband/sw/rxe/rxe_req.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index d6299edf9a5b..6b65c0132289 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -250,7 +250,7 @@ void rxe_resp_queue_pkt(struct rxe_dev *rxe,
 void rxe_comp_queue_pkt(struct rxe_dev *rxe,
 			struct rxe_qp *qp, struct sk_buff *skb);
 
-static inline unsigned wr_opcode_mask(int opcode, struct rxe_qp *qp)
+static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 75d11ee635ec..c1b5f38f31a5 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -188,7 +188,7 @@ int rxe_pool_init(
 	struct rxe_dev		*rxe,
 	struct rxe_pool		*pool,
 	enum rxe_elem_type	type,
-	unsigned		max_elem)
+	unsigned int		max_elem)
 {
 	int			err = 0;
 	size_t			size = rxe_type_info[type].size;
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 7ee465d1a1e1..db7161456f45 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -43,7 +43,7 @@ static int next_opcode(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 
 static inline void retry_first_write_send(struct rxe_qp *qp,
 					  struct rxe_send_wqe *wqe,
-					  unsigned mask, int npsn)
+					  unsigned int mask, int npsn)
 {
 	int i;
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
