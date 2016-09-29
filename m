From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 5/5] libocrdma: Move to use CCAN list functionality
Date: Thu, 29 Sep 2016 14:11:02 +0300
Message-ID: <1475147462-803-6-git-send-email-yishaih@mellanox.com>
References: <1475147462-803-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move to use CCAN list functionality which its license meets
the project needs.

Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libocrdma/src/ocrdma_list.h  | 104 -------------------------------------------
 libocrdma/src/ocrdma_main.c  |  24 +++++-----
 libocrdma/src/ocrdma_main.h  |  12 ++---
 libocrdma/src/ocrdma_verbs.c |  33 +++++++-------
 4 files changed, 33 insertions(+), 140 deletions(-)
 delete mode 100644 libocrdma/src/ocrdma_list.h

diff --git a/libocrdma/src/ocrdma_list.h b/libocrdma/src/ocrdma_list.h
deleted file mode 100644
index 1e0f1ff..0000000
--- a/libocrdma/src/ocrdma_list.h
+++ /dev/null
@@ -1,104 +0,0 @@
-/*
- * Copyright (C) 2008-2013 Emulex.  All rights reserved.
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
- * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT  LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
- * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
- * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
- * THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef __OCRDMA_LIST_H__
-#define __OCRDMA_LIST_H__
-
-struct ocrdma_list_node {
-	struct ocrdma_list_node *next, *prev;
-};
-
-struct ocrdma_list_head {
-	struct ocrdma_list_node node;
-	pthread_mutex_t lock;
-};
-
-#define DBLY_LIST_HEAD_INIT(name) { { &(name.node), &(name.node) } , \
-                        PTHREAD_MUTEX_INITIALIZER }
-
-#define DBLY_LIST_HEAD(name) \
-	struct ocrdma_list_head name = DBLY_LIST_HEAD_INIT(name); \
-
-#define INIT_DBLY_LIST_NODE(ptr) do { \
-	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
-} while (0)
-
-#define INIT_DBLY_LIST_HEAD(ptr) INIT_DBLY_LIST_NODE(ptr.node)
-
-static inline void __list_add_node(struct ocrdma_list_node *new,
-				       struct ocrdma_list_node *prev,
-				       struct ocrdma_list_node *next)
-{
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
-}
-
-static inline void list_add_node_tail(struct ocrdma_list_node *new,
-					  struct ocrdma_list_head *head)
-{
-	__list_add_node(new, head->node.prev, &head->node);
-}
-
-static inline void __list_del_node(struct ocrdma_list_node *prev,
-				       struct ocrdma_list_node *next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
-static inline void list_del_node(struct ocrdma_list_node *entry)
-{
-	__list_del_node(entry->prev, entry->next);
-	entry->next = entry->prev = 0;
-}
-
-#define list_lock(head) pthread_mutex_lock(&((head)->lock))
-#define list_unlock(head) pthread_mutex_unlock(&((head)->lock))
-
-#define list_node(ptr, type, member) \
-    ((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
-
-/**
- * list_for_each_node_safe	-	iterate over a list safe against removal of list entry
- * @pos:	the &struct ocrdma_list_head to use as a loop counter.
- * @n:		another &struct ocrdma_list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_node_safe(pos, n, head) \
-	for (pos = (head)->node.next, n = pos->next; pos != &((head)->node); \
-		pos = n, n = pos->next)
-
-#endif				/* __OCRDMA_LIST_H__ */
diff --git a/libocrdma/src/ocrdma_main.c b/libocrdma/src/ocrdma_main.c
index 5c494d8..064ecb3 100644
--- a/libocrdma/src/ocrdma_main.c
+++ b/libocrdma/src/ocrdma_main.c
@@ -46,7 +46,7 @@
 
 #include "ocrdma_main.h"
 #include "ocrdma_abi.h"
-#include "ocrdma_list.h"
+#include <ccan/list.h>
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -68,7 +68,8 @@ struct {
 	UCNA(EMULEX, GEN1), UCNA(EMULEX, GEN2), UCNA(EMULEX, GEN2_VF)
 };
 
-static DBLY_LIST_HEAD(ocrdma_dev_list);
+static LIST_HEAD(ocrdma_dev_list);
+static pthread_mutex_t ocrdma_dev_list_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static struct ibv_context *ocrdma_alloc_context(struct ibv_device *, int);
 static void ocrdma_free_context(struct ibv_context *);
@@ -222,10 +223,10 @@ found:
 	pthread_mutex_init(&dev->dev_lock, NULL);
 	pthread_spin_init(&dev->flush_q_lock, PTHREAD_PROCESS_PRIVATE);
 	dev->ibv_dev.ops = ocrdma_dev_ops;
-	INIT_DBLY_LIST_NODE(&dev->entry);
-	list_lock(&ocrdma_dev_list);
-	list_add_node_tail(&dev->entry, &ocrdma_dev_list);
-	list_unlock(&ocrdma_dev_list);
+	list_node_init(&dev->entry);
+	pthread_mutex_lock(&ocrdma_dev_list_lock);
+	list_add_tail(&ocrdma_dev_list, &dev->entry);
+	pthread_mutex_unlock(&ocrdma_dev_list_lock);
 	return &dev->ibv_dev;
 qp_err:
 	free(dev);
@@ -244,14 +245,13 @@ void ocrdma_register_driver(void)
 static __attribute__ ((destructor))
 void ocrdma_unregister_driver(void)
 {
-	struct ocrdma_list_node *cur, *tmp;
 	struct ocrdma_device *dev;
-	list_lock(&ocrdma_dev_list);
-	list_for_each_node_safe(cur, tmp, &ocrdma_dev_list) {
-		dev = list_node(cur, struct ocrdma_device, entry);
+	struct ocrdma_device *dev_tmp;
+	pthread_mutex_lock(&ocrdma_dev_list_lock);
+	list_for_each_safe(&ocrdma_dev_list, dev, dev_tmp, entry) {
 		pthread_mutex_destroy(&dev->dev_lock);
 		pthread_spin_destroy(&dev->flush_q_lock);
-		list_del_node(&dev->entry);
+		list_del(&dev->entry);
 		/*
 		 * Avoid freeing the dev here since MPI get SIGSEGV
 		 * in few error cases because of reference to ib_dev
@@ -260,5 +260,5 @@ void ocrdma_unregister_driver(void)
 		 */
 		/* free(dev); */
 	}
-	list_unlock(&ocrdma_dev_list);
+	pthread_mutex_unlock(&ocrdma_dev_list_lock);
 }
diff --git a/libocrdma/src/ocrdma_main.h b/libocrdma/src/ocrdma_main.h
index c81188b..b8be6e5 100644
--- a/libocrdma/src/ocrdma_main.h
+++ b/libocrdma/src/ocrdma_main.h
@@ -42,7 +42,7 @@
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
 
-#include "ocrdma_list.h"
+#include <ccan/list.h>
 
 #define ocrdma_err(format, arg...) printf(format, ##arg)
 
@@ -58,7 +58,7 @@ struct ocrdma_device {
 	struct ocrdma_qp **qp_tbl;
 	pthread_mutex_t dev_lock;
 	pthread_spinlock_t flush_q_lock;
-	struct ocrdma_list_node entry;
+	struct list_node entry;
 	int id;
 	int gen;
 	uint32_t wqe_size;
@@ -106,8 +106,8 @@ struct ocrdma_cq {
 	uint8_t deferred_arm;
 	uint8_t deferred_sol;
 	uint8_t first_arm;
-	struct ocrdma_list_head sq_head;
-	struct ocrdma_list_head rq_head;
+	struct list_head sq_head;
+	struct list_head rq_head;
 };
 
 enum {
@@ -203,8 +203,8 @@ struct ocrdma_qp {
 
 	enum ibv_qp_type qp_type;
 	enum ocrdma_qp_state state;
-	struct ocrdma_list_node sq_entry;
-	struct ocrdma_list_node rq_entry;
+	struct list_node sq_entry;
+	struct list_node rq_entry;
 	uint16_t id;
 	uint16_t rsvd;
 	uint32_t db_shift;
diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 6062626..413c706 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -51,7 +51,7 @@
 
 #include "ocrdma_main.h"
 #include "ocrdma_abi.h"
-#include "ocrdma_list.h"
+#include <ccan/list.h>
 
 static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
 			      int solicited, uint32_t num_cqe);
@@ -307,8 +307,8 @@ static struct ibv_cq *ocrdma_create_cq_common(struct ibv_context *context,
 		ocrdma_ring_cq_db(cq, 0, 0, 0);
 	}
 	cq->ibv_cq.cqe = cqe;
-	INIT_DBLY_LIST_HEAD(&cq->sq_head);
-	INIT_DBLY_LIST_HEAD(&cq->rq_head);
+	list_head_init(&cq->sq_head);
+	list_head_init(&cq->rq_head);
 	return &cq->ibv_cq;
 cq_err2:
 	(void)ibv_cmd_destroy_cq(&cq->ibv_cq);
@@ -621,8 +621,8 @@ struct ibv_qp *ocrdma_create_qp(struct ibv_pd *pd,
 		}
 	}
 	qp->state = OCRDMA_QPS_RST;
-	INIT_DBLY_LIST_NODE(&qp->sq_entry);
-	INIT_DBLY_LIST_NODE(&qp->rq_entry);
+	list_node_init(&qp->sq_entry);
+	list_node_init(&qp->rq_entry);
 	return &qp->ibv_qp;
 
 map_err:
@@ -663,10 +663,9 @@ static int ocrdma_is_qp_in_sq_flushlist(struct ocrdma_cq *cq,
 					struct ocrdma_qp *qp)
 {
 	struct ocrdma_qp *list_qp;
-	struct ocrdma_list_node *cur, *tmp;
+	struct ocrdma_qp *list_qp_tmp;
 	int found = 0;
-	list_for_each_node_safe(cur, tmp, &cq->sq_head) {
-		list_qp = list_node(cur, struct ocrdma_qp, sq_entry);
+	list_for_each_safe(&cq->sq_head, list_qp, list_qp_tmp, sq_entry) {
 		if (qp == list_qp) {
 			found = 1;
 			break;
@@ -679,10 +678,9 @@ static int ocrdma_is_qp_in_rq_flushlist(struct ocrdma_cq *cq,
 					struct ocrdma_qp *qp)
 {
 	struct ocrdma_qp *list_qp;
-	struct ocrdma_list_node *cur, *tmp;
+	struct ocrdma_qp *list_qp_tmp;
 	int found = 0;
-	list_for_each_node_safe(cur, tmp, &cq->rq_head) {
-		list_qp = list_node(cur, struct ocrdma_qp, rq_entry);
+	list_for_each_safe(&cq->rq_head, list_qp, list_qp_tmp, rq_entry) {
 		if (qp == list_qp) {
 			found = 1;
 			break;
@@ -708,11 +706,11 @@ static void ocrdma_del_flush_qp(struct ocrdma_qp *qp)
 	pthread_spin_lock(&dev->flush_q_lock);
 	found = ocrdma_is_qp_in_sq_flushlist(qp->sq_cq, qp);
 	if (found)
-		list_del_node(&qp->sq_entry);
+		list_del(&qp->sq_entry);
 	if (!qp->srq) {
 		found = ocrdma_is_qp_in_rq_flushlist(qp->rq_cq, qp);
 		if (found)
-			list_del_node(&qp->rq_entry);
+			list_del(&qp->rq_entry);
 	}
 	pthread_spin_unlock(&dev->flush_q_lock);
 }
@@ -724,11 +722,11 @@ static void ocrdma_flush_qp(struct ocrdma_qp *qp)
 	pthread_spin_lock(&qp->dev->flush_q_lock);
 	found = ocrdma_is_qp_in_sq_flushlist(qp->sq_cq, qp);
 	if (!found)
-		list_add_node_tail(&qp->sq_entry, &qp->sq_cq->sq_head);
+		list_add_tail(&qp->sq_cq->sq_head, &qp->sq_entry);
 	if (!qp->srq) {
 		found = ocrdma_is_qp_in_rq_flushlist(qp->rq_cq, qp);
 		if (!found)
-			list_add_node_tail(&qp->rq_entry, &qp->rq_cq->rq_head);
+			list_add_tail(&qp->rq_cq->rq_head, &qp->rq_entry);
 	}
 	pthread_spin_unlock(&qp->dev->flush_q_lock);
 }
@@ -2034,7 +2032,7 @@ int ocrdma_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 	int cqes_to_poll = num_entries;
 	int num_os_cqe = 0, err_cqes = 0;
 	struct ocrdma_qp *qp;
-	struct ocrdma_list_node *cur, *tmp;
+	struct ocrdma_qp *qp_tmp;
 
 	cq = get_ocrdma_cq(ibcq);
 	pthread_spin_lock(&cq->cq_lock);
@@ -2045,8 +2043,7 @@ int ocrdma_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 	if (cqes_to_poll) {
 		wc = wc + num_os_cqe;
 		pthread_spin_lock(&cq->dev->flush_q_lock);
-		list_for_each_node_safe(cur, tmp, &cq->sq_head) {
-			qp = list_node(cur, struct ocrdma_qp, sq_entry);
+		list_for_each_safe(&cq->sq_head, qp, qp_tmp, sq_entry) {
 			if (cqes_to_poll == 0)
 				break;
 			err_cqes = ocrdma_add_err_cqe(cq, cqes_to_poll, qp, wc);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
