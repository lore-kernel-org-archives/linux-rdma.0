From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/4] Use C11 atomics instead of wmb/rmb macros for CPU-only atomics
Date: Tue, 10 Jan 2017 12:02:11 -0700
Message-ID: <1484074931-3847-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1484074931-3847-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484074931-3847-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER for
        hf1.ko" <intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER for
        ib_qib.ko" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ipath/hfi1 and rxe are synchronizing with the kernel (via a shared mmap)
and can safely use the weaker SMP memory model atomics to do it, they do
not need the PCI barriers from arch.h

This allows those providers to compile on all arches.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                    |  5 +--
 providers/hfi1verbs/hfiverbs.h    | 10 +++---
 providers/hfi1verbs/verbs.c       | 17 ++++-----
 providers/ipathverbs/ipathverbs.h | 10 +++---
 providers/ipathverbs/verbs.c      | 18 +++++-----
 providers/rxe/rxe.c               |  5 +--
 providers/rxe/rxe_queue.h         | 72 ++++++++++++++++++++-------------------
 7 files changed, 70 insertions(+), 67 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index d06cb71d3edf03..849d3936d86508 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -376,16 +376,17 @@ add_subdirectory(providers/cxgb4)
 add_subdirectory(providers/hfi1verbs)
 add_subdirectory(providers/hns)
 add_subdirectory(providers/i40iw)
-add_subdirectory(providers/ipathverbs)
 add_subdirectory(providers/mlx4)
 add_subdirectory(providers/mlx5)
 add_subdirectory(providers/mthca)
 add_subdirectory(providers/nes)
 add_subdirectory(providers/ocrdma)
 add_subdirectory(providers/qedr)
+endif()
+
+add_subdirectory(providers/ipathverbs)
 add_subdirectory(providers/rxe)
 add_subdirectory(providers/rxe/man)
-endif()
 
 # Binaries
 add_subdirectory(ibacm)
diff --git a/providers/hfi1verbs/hfiverbs.h b/providers/hfi1verbs/hfiverbs.h
index e82ba2b469ab05..af93dc43e059d9 100644
--- a/providers/hfi1verbs/hfiverbs.h
+++ b/providers/hfi1verbs/hfiverbs.h
@@ -62,9 +62,9 @@
 #include <byteswap.h>
 #include <pthread.h>
 #include <stddef.h>
+#include <stdatomic.h>
 
 #include <infiniband/driver.h>
-#include <infiniband/arch.h>
 #include <infiniband/verbs.h>
 
 #define PFX		"hfi1: "
@@ -100,8 +100,8 @@ struct hfi1_wc {
 };
 
 struct hfi1_cq_wc {
-	uint32_t		head;
-	uint32_t		tail;
+	_Atomic(uint32_t)	head;
+	_Atomic(uint32_t)	tail;
 	struct hfi1_wc		queue[1];
 };
 
@@ -132,8 +132,8 @@ struct hfi1_rwqe {
  * use get_rwqe_ptr() instead.
  */
 struct hfi1_rwq {
-	uint32_t		head;	/* new requests posted to the head */
-	uint32_t		tail;	/* receives pull requests from here. */
+	_Atomic(uint32_t)	head;	/* new requests posted to the head. */
+	_Atomic(uint32_t)	tail;	/* receives pull requests from here. */
 	struct hfi1_rwqe	wq[0];
 };
 
diff --git a/providers/hfi1verbs/verbs.c b/providers/hfi1verbs/verbs.c
index 06ddbb712857f6..8d1b11150977a3 100644
--- a/providers/hfi1verbs/verbs.c
+++ b/providers/hfi1verbs/verbs.c
@@ -298,19 +298,19 @@ int hfi1_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 
 	pthread_spin_lock(&cq->lock);
 	q = cq->queue;
-	tail = q->tail;
+	tail = atomic_load_explicit(&q->tail, memory_order_relaxed);
 	for (npolled = 0; npolled < ne; ++npolled, ++wc) {
-		if (tail == q->head)
+		if (tail == atomic_load(&q->head))
 			break;
 		/* Make sure entry is read after head index is read. */
-		rmb();
+		atomic_thread_fence(memory_order_acquire);
 		memcpy(wc, &q->queue[tail], sizeof(*wc));
 		if (tail == cq->ibv_cq.cqe)
 			tail = 0;
 		else
 			tail++;
 	}
-	q->tail = tail;
+	atomic_store(&q->tail, tail);
 	pthread_spin_unlock(&cq->lock);
 
 	return npolled;
@@ -478,7 +478,7 @@ static int post_recv(struct hfi1_rq *rq, struct ibv_recv_wr *wr,
 
 	pthread_spin_lock(&rq->lock);
 	rwq = rq->rwq;
-	head = rwq->head;
+	head = atomic_load_explicit(&rwq->head, memory_order_relaxed);;
 	for (i = wr; i; i = i->next) {
 		if ((unsigned) i->num_sge > rq->max_sge) {
 			ret = EINVAL;
@@ -487,7 +487,7 @@ static int post_recv(struct hfi1_rq *rq, struct ibv_recv_wr *wr,
 		wqe = get_rwqe_ptr(rq, head);
 		if (++head >= rq->size)
 			head = 0;
-		if (head == rwq->tail) {
+		if (head == atomic_load(&rwq->tail)) {
 			ret = ENOMEM;
 			goto bad;
 		}
@@ -495,9 +495,10 @@ static int post_recv(struct hfi1_rq *rq, struct ibv_recv_wr *wr,
 		wqe->num_sge = i->num_sge;
 		for (n = 0; n < wqe->num_sge; n++)
 			wqe->sg_list[n] = i->sg_list[n];
+
 		/* Make sure queue entry is written before the head index. */
-		wmb();
-		rwq->head = head;
+		atomic_thread_fence(memory_order_release);
+		atomic_store(&rwq->head, head);
 	}
 	ret = 0;
 	goto done;
diff --git a/providers/ipathverbs/ipathverbs.h b/providers/ipathverbs/ipathverbs.h
index ff25854519fdc7..ebd2dcfbc413a9 100644
--- a/providers/ipathverbs/ipathverbs.h
+++ b/providers/ipathverbs/ipathverbs.h
@@ -42,9 +42,9 @@
 #include <byteswap.h>
 #include <pthread.h>
 #include <stddef.h>
+#include <stdatomic.h>
 
 #include <infiniband/driver.h>
-#include <infiniband/arch.h>
 #include <infiniband/verbs.h>
 
 #define PFX		"ipath: "
@@ -80,8 +80,8 @@ struct ipath_wc {
 };
 
 struct ipath_cq_wc {
-	uint32_t		head;
-	uint32_t		tail;
+	_Atomic(uint32_t)	head;
+	_Atomic(uint32_t)	tail;
 	struct ipath_wc		queue[1];
 };
 
@@ -112,8 +112,8 @@ struct ipath_rwqe {
  * use get_rwqe_ptr() instead.
  */
 struct ipath_rwq {
-	uint32_t		head;	/* new requests posted to the head */
-	uint32_t		tail;	/* receives pull requests from here. */
+	_Atomic(uint32_t)	head;	/* new requests posted to the head. */
+	_Atomic(uint32_t)	tail;	/* receives pull requests from here. */
 	struct ipath_rwqe	wq[0];
 };
 
diff --git a/providers/ipathverbs/verbs.c b/providers/ipathverbs/verbs.c
index 35b2162a84f0ae..b8cd46bd3c892d 100644
--- a/providers/ipathverbs/verbs.c
+++ b/providers/ipathverbs/verbs.c
@@ -275,19 +275,20 @@ int ipath_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 
 	pthread_spin_lock(&cq->lock);
 	q = cq->queue;
-	tail = q->tail;
+	tail = atomic_load_explicit(&q->tail, memory_order_relaxed);
 	for (npolled = 0; npolled < ne; ++npolled, ++wc) {
-		if (tail == q->head)
+		if (tail == atomic_load(&q->head))
 			break;
+
 		/* Make sure entry is read after head index is read. */
-		rmb();
+		atomic_thread_fence(memory_order_acquire);
 		memcpy(wc, &q->queue[tail], sizeof(*wc));
 		if (tail == cq->ibv_cq.cqe)
 			tail = 0;
 		else
 			tail++;
 	}
-	q->tail = tail;
+	atomic_store(&q->tail, tail);
 	pthread_spin_unlock(&cq->lock);
 
 	return npolled;
@@ -454,7 +455,7 @@ static int post_recv(struct ipath_rq *rq, struct ibv_recv_wr *wr,
 
 	pthread_spin_lock(&rq->lock);
 	rwq = rq->rwq;
-	head = rwq->head;
+	head = atomic_load_explicit(&rwq->head, memory_order_relaxed);;
 	for (i = wr; i; i = i->next) {
 		if ((unsigned) i->num_sge > rq->max_sge) {
 			ret = EINVAL;
@@ -463,7 +464,7 @@ static int post_recv(struct ipath_rq *rq, struct ibv_recv_wr *wr,
 		wqe = get_rwqe_ptr(rq, head);
 		if (++head >= rq->size)
 			head = 0;
-		if (head == rwq->tail) {
+		if (head == atomic_load(&rwq->tail)) {
 			ret = ENOMEM;
 			goto bad;
 		}
@@ -471,9 +472,10 @@ static int post_recv(struct ipath_rq *rq, struct ibv_recv_wr *wr,
 		wqe->num_sge = i->num_sge;
 		for (n = 0; n < wqe->num_sge; n++)
 			wqe->sg_list[n] = i->sg_list[n];
+
 		/* Make sure queue entry is written before the head index. */
-		wmb();
-		rwq->head = head;
+		atomic_thread_fence(memory_order_release);
+		atomic_store(&rwq->head, head);
 	}
 	ret = 0;
 	goto done;
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index d23ef3d6b85cf9..a76c74b04ced8e 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -50,7 +50,6 @@
 #include <stddef.h>
 
 #include <infiniband/driver.h>
-#include <infiniband/arch.h>
 #include <infiniband/verbs.h>
 #include <rdma/rdma_user_rxe.h>
 
@@ -255,7 +254,7 @@ static int rxe_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 		if (queue_empty(q))
 			break;
 
-		rmb();
+		atomic_thread_fence(memory_order_acquire);
 		src = consumer_addr(q);
 		memcpy(wc, src, sizeof(*wc));
 		advance_consumer(q);
@@ -402,8 +401,6 @@ static int rxe_post_one_recv(struct rxe_wq *rq, struct ibv_recv_wr *recv_wr)
 	wqe->dma.num_sge = wqe->num_sge;
 	wqe->dma.sge_offset = 0;
 
-	rmb();
-
 	advance_producer(q);
 
 out:
diff --git a/providers/rxe/rxe_queue.h b/providers/rxe/rxe_queue.h
index e9794727913461..629aad98f914aa 100644
--- a/providers/rxe/rxe_queue.h
+++ b/providers/rxe/rxe_queue.h
@@ -37,15 +37,16 @@
 #ifndef H_RXE_PCQ
 #define H_RXE_PCQ
 
+#include <stdatomic.h>
+
 /* MUST MATCH kernel struct rxe_pqc in rxe_queue.h */
 struct rxe_queue {
 	uint32_t		log2_elem_size;
 	uint32_t		index_mask;
 	uint32_t		pad_1[30];
-	volatile uint32_t	producer_index;
+	_Atomic(uint32_t)	producer_index;
 	uint32_t		pad_2[31];
-	volatile uint32_t	consumer_index;
-	uint32_t		pad_3[31];
+	_Atomic(uint32_t)	consumer_index;
 	uint8_t			data[0];
 };
 
@@ -56,48 +57,59 @@ static inline int next_index(struct rxe_queue *q, int index)
 
 static inline int queue_empty(struct rxe_queue *q)
 {
-	return ((q->producer_index - q->consumer_index)
-			& q->index_mask) == 0;
+	/* Must hold consumer_index lock */
+	return ((atomic_load(&q->producer_index) -
+		 atomic_load_explicit(&q->consumer_index,
+				      memory_order_relaxed)) &
+		q->index_mask) == 0;
 }
 
 static inline int queue_full(struct rxe_queue *q)
 {
-	return ((q->producer_index + 1 - q->consumer_index)
-			& q->index_mask) == 0;
+	/* Must hold producer_index lock */
+	return ((atomic_load_explicit(&q->producer_index,
+				      memory_order_relaxed) +
+		 1 - atomic_load(&q->consumer_index)) &
+		q->index_mask) == 0;
 }
 
 static inline void advance_producer(struct rxe_queue *q)
 {
-	q->producer_index = (q->producer_index + 1)
-			& q->index_mask;
+	/* Must hold producer_index lock */
+	atomic_thread_fence(memory_order_release);
+	atomic_store(
+	    &q->producer_index,
+	    (atomic_load_explicit(&q->producer_index, memory_order_relaxed) +
+	     1) &
+		q->index_mask);
 }
 
 static inline void advance_consumer(struct rxe_queue *q)
 {
-	q->consumer_index = (q->consumer_index + 1)
-			& q->index_mask;
+	/* Must hold consumer_index lock */
+	atomic_store(
+	    &q->consumer_index,
+	    (atomic_load_explicit(&q->consumer_index, memory_order_relaxed) +
+	     1) &
+		q->index_mask);
 }
 
 static inline void *producer_addr(struct rxe_queue *q)
 {
-	return q->data + ((q->producer_index & q->index_mask)
-				<< q->log2_elem_size);
+	/* Must hold producer_index lock */
+	return q->data + ((atomic_load_explicit(&q->producer_index,
+						memory_order_relaxed) &
+			   q->index_mask)
+			  << q->log2_elem_size);
 }
 
 static inline void *consumer_addr(struct rxe_queue *q)
 {
-	return q->data + ((q->consumer_index & q->index_mask)
-				<< q->log2_elem_size);
-}
-
-static inline unsigned int producer_index(struct rxe_queue *q)
-{
-	return q->producer_index;
-}
-
-static inline unsigned int consumer_index(struct rxe_queue *q)
-{
-	return q->consumer_index;
+	/* Must hold consumer_index lock */
+	return q->data + ((atomic_load_explicit(&q->consumer_index,
+						memory_order_relaxed) &
+			   q->index_mask)
+			  << q->log2_elem_size);
 }
 
 static inline void *addr_from_index(struct rxe_queue *q, unsigned int index)
@@ -111,14 +123,4 @@ static inline unsigned int index_from_addr(const struct rxe_queue *q, const void
 	return (((uint8_t *)addr - q->data) >> q->log2_elem_size) & q->index_mask;
 }
 
-static inline unsigned int queue_count(const struct rxe_queue *q)
-{
-	return (q->producer_index - q->consumer_index) & q->index_mask;
-}
-
-static inline void *queue_head(struct rxe_queue *q)
-{
-	return queue_empty(q) ? NULL : consumer_addr(q);
-}
-
 #endif /* H_RXE_PCQ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
