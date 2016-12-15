From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libqedr: fix queue wrapping logic
Date: Thu, 15 Dec 2016 11:27:00 +0200
Message-ID: <1481794020-28167-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The pointer to a CQ, SQ or RQ may wrap before reaching the end of the
queue for certain queue depths. This is fixed by using a wrapping logic
based on a pointer rather than an index.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_chain.c | 24 +++++++++++++-----------
 providers/qedr/qelr_chain.h | 22 ++++++++++++----------
 providers/qedr/qelr_verbs.c | 10 +++++-----
 3 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/providers/qedr/qelr_chain.c b/providers/qedr/qelr_chain.c
index 6101f74..edc72f4 100644
--- a/providers/qedr/qelr_chain.c
+++ b/providers/qedr/qelr_chain.c
@@ -44,11 +44,11 @@ void *qelr_chain_get_last_elem(struct qelr_chain *p_chain)
 	void			*p_virt_addr	= NULL;
 	uint32_t		size;
 
-	if (!p_chain->addr)
+	if (!p_chain->first_addr)
 		goto out;
 
 	size		= p_chain->elem_size * (p_chain->n_elems - 1);
-	p_virt_addr	= ((uint8_t *)p_chain->addr + size);
+	p_virt_addr	= ((uint8_t *)p_chain->first_addr + size);
 out:
 	return p_virt_addr;
 }
@@ -58,8 +58,8 @@ void qelr_chain_reset(struct qelr_chain *p_chain)
 	p_chain->prod_idx	= 0;
 	p_chain->cons_idx	= 0;
 
-	p_chain->p_cons_elem	= p_chain->addr;
-	p_chain->p_prod_elem	= p_chain->addr;
+	p_chain->p_cons_elem	= p_chain->first_addr;
+	p_chain->p_prod_elem	= p_chain->first_addr;
 }
 
 #define QELR_ANON_FD		(-1)	/* MAP_ANONYMOUS => file desc.= -1  */
@@ -76,7 +76,7 @@ int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
 	addr = mmap(NULL, a_chain_size, PROT_READ | PROT_WRITE,
 			 MAP_PRIVATE | MAP_ANONYMOUS, QELR_ANON_FD,
 			 QELR_ANON_OFFSET);
-	if (chain->addr == MAP_FAILED)
+	if (chain->first_addr == MAP_FAILED)
 		return errno;
 
 	ret = ibv_dontfork_range(addr, a_chain_size);
@@ -87,13 +87,15 @@ int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
 
 	/* init chain */
 	memset(chain, 0, sizeof(*chain));
-	memset(chain->addr, 0, chain->size);
-	chain->addr = addr;
+	memset(chain->first_addr, 0, chain->size);
+	chain->first_addr = addr;
 	chain->size = a_chain_size;
-	chain->p_cons_elem = chain->addr;
-	chain->p_prod_elem = chain->addr;
+	chain->p_cons_elem = chain->first_addr;
+	chain->p_prod_elem = chain->first_addr;
 	chain->elem_size = elem_size;
 	chain->n_elems = chain->size / elem_size;
+	chain->last_addr = (void *)
+			((uint8_t *)addr + (elem_size * (chain->n_elems -1)));
 
 	return 0;
 }
@@ -101,7 +103,7 @@ int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
 void qelr_chain_free(struct qelr_chain *chain)
 {
 	if (chain->size) {
-		ibv_dofork_range(chain->addr, chain->size);
-		munmap(chain->addr, chain->size);
+		ibv_dofork_range(chain->first_addr, chain->size);
+		munmap(chain->first_addr, chain->size);
 	}
 }
diff --git a/providers/qedr/qelr_chain.h b/providers/qedr/qelr_chain.h
index 2ff5bf5..12a30df 100644
--- a/providers/qedr/qelr_chain.h
+++ b/providers/qedr/qelr_chain.h
@@ -34,8 +34,8 @@
 #define __QELR_CHAIN_H__
 
 struct qelr_chain {
-	/* Address of first page of the chain */
-	void		*addr;
+	void		*first_addr;	/* Address of first element in chain */
+	void		*last_addr;	/* Address of last element in chain */
 
 	/* Point to next element to produce/consume */
 	void		*p_prod_elem;
@@ -64,8 +64,8 @@ static inline void *qelr_chain_produce(struct qelr_chain *p_chain)
 
 	p_ret = p_chain->p_prod_elem;
 
-	if (p_chain->prod_idx % p_chain->n_elems == 0)
-		p_chain->p_prod_elem = p_chain->addr;
+	if (p_chain->p_prod_elem == p_chain->last_addr)
+		p_chain->p_prod_elem = p_chain->first_addr;
 	else
 		p_chain->p_prod_elem = (void *)(((uint8_t *)p_chain->p_prod_elem) +
 				       p_chain->elem_size);
@@ -83,8 +83,9 @@ static inline void *qelr_chain_produce_n(struct qelr_chain *p_chain, int n)
 
 	n_wrap = p_chain->prod_idx % p_chain->n_elems;
 	if (n_wrap < n)
-		p_chain->p_prod_elem = (void *)(((uint8_t *)p_chain->addr) +
-				       (p_chain->elem_size * n_wrap));
+		p_chain->p_prod_elem = (void *)
+				       (((uint8_t *)p_chain->first_addr) +
+					(p_chain->elem_size * n_wrap));
 	else
 		p_chain->p_prod_elem = (void *)(((uint8_t *)p_chain->p_prod_elem) +
 				       (p_chain->elem_size * n));
@@ -100,8 +101,8 @@ static inline void *qelr_chain_consume(struct qelr_chain *p_chain)
 
 	p_ret = p_chain->p_cons_elem;
 
-	if (p_chain->cons_idx % p_chain->n_elems == 0)
-		p_chain->p_cons_elem = p_chain->addr;
+	if (p_chain->p_cons_elem == p_chain->last_addr)
+		p_chain->p_cons_elem = p_chain->first_addr;
 	else
 		p_chain->p_cons_elem	= (void *)
 					  (((uint8_t *)p_chain->p_cons_elem) +
@@ -120,8 +121,9 @@ static inline void *qelr_chain_consume_n(struct qelr_chain *p_chain, int n)
 
 	n_wrap = p_chain->cons_idx % p_chain->n_elems;
 	if (n_wrap < n)
-		p_chain->p_cons_elem = (void *)(((uint8_t *)p_chain->addr) +
-				       (p_chain->elem_size * n_wrap));
+		p_chain->p_cons_elem = (void *)
+				       (((uint8_t *)p_chain->first_addr) +
+					(p_chain->elem_size * n_wrap));
 	else
 		p_chain->p_cons_elem = (void *)(((uint8_t *)p_chain->p_cons_elem) +
 				       (p_chain->elem_size * n));
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 415efc0..793b1f4 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -248,7 +248,7 @@ struct ibv_cq *qelr_create_cq(struct ibv_context *context, int cqe,
 	if (rc)
 		goto err_0;
 
-	cmd.addr = (uintptr_t) cq->chain.addr;
+	cmd.addr = (uintptr_t) cq->chain.first_addr;
 	cmd.len = cq->chain.size;
 	rc = ibv_cmd_create_cq(context, cqe, channel, comp_vector,
 			       &cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
@@ -485,7 +485,7 @@ static inline void
 qelr_create_qp_configure_sq_req(struct qelr_qp *qp,
 				struct qelr_create_qp_req *req)
 {
-	req->sq_addr = (uintptr_t)qp->sq.chain.addr;
+	req->sq_addr = (uintptr_t)qp->sq.chain.first_addr;
 	req->sq_len = qp->sq.chain.size;
 }
 
@@ -493,7 +493,7 @@ static inline void
 qelr_create_qp_configure_rq_req(struct qelr_qp *qp,
 				struct qelr_create_qp_req *req)
 {
-	req->rq_addr = (uintptr_t)qp->rq.chain.addr;
+	req->rq_addr = (uintptr_t)qp->rq.chain.first_addr;
 	req->rq_len = qp->rq.chain.size;
 }
 
@@ -1443,8 +1443,8 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 				   wr->sg_list[i].length, flags);
 			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
 				      "[%d]: len %d key %x addr %x:%x\n", i,
-				      rqe->length, rqe->flags, rqe->addr.hi,
-				      rqe->addr.lo);
+				      rqe->length, rqe->flags,
+				      rqe->first_addr.hi, rqe->first_addr.lo);
 		}
 		/* Special case of no sges. FW requires between 1-4 sges...
 		 * in this case we need to post 1 sge with length zero. this is
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
