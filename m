From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 11/32] IB/rxe: Common user/kernel queue implementation
Date: Wed, 16 Sep 2015 16:42:45 +0300
Message-ID: <1442410986-28232-12-git-send-email-kamalh@mellanox.com>
References: <1442410986-28232-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442410986-28232-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A simple circular buffer that can optionally be shared between user
space and the kernel and can be resized.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rxe/rxe_queue.c | 217 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/rxe/rxe_queue.h | 178 ++++++++++++++++++++++++++++++++
 2 files changed, 395 insertions(+)
 create mode 100644 drivers/staging/rxe/rxe_queue.c
 create mode 100644 drivers/staging/rxe/rxe_queue.h

diff --git a/drivers/staging/rxe/rxe_queue.c b/drivers/staging/rxe/rxe_queue.c
new file mode 100644
index 0000000..aabe04b
--- /dev/null
+++ b/drivers/staging/rxe/rxe_queue.c
@@ -0,0 +1,217 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must retailuce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/vmalloc.h>
+#include "rxe.h"
+#include "rxe_loc.h"
+#include "rxe_queue.h"
+
+int do_mmap_info(struct rxe_dev *rxe,
+		 struct ib_udata *udata,
+		 bool is_req,
+		 struct ib_ucontext *context,
+		 struct rxe_queue_buf *buf,
+		 size_t buf_size,
+		 struct rxe_mmap_info **ip_p)
+{
+	int err;
+	u32 len, offset;
+	struct rxe_mmap_info *ip = NULL;
+
+	if (udata) {
+		if (is_req) {
+			len = udata->outlen - sizeof(struct mminfo);
+			offset = sizeof(struct mminfo);
+		} else {
+			len = udata->outlen;
+			offset = 0;
+		}
+
+		if (len < sizeof(ip->info))
+			goto err1;
+
+		ip = rxe_create_mmap_info(rxe, buf_size, context, buf);
+		if (!ip)
+			goto err1;
+
+		err = copy_to_user(udata->outbuf + offset, &ip->info,
+				   sizeof(ip->info));
+		if (err)
+			goto err2;
+
+		spin_lock_bh(&rxe->pending_lock);
+		list_add(&ip->pending_mmaps, &rxe->pending_mmaps);
+		spin_unlock_bh(&rxe->pending_lock);
+	}
+
+	*ip_p = ip;
+
+	return 0;
+
+err2:
+	kfree(ip);
+err1:
+	return -EINVAL;
+}
+
+struct rxe_queue *rxe_queue_init(struct rxe_dev *rxe,
+				 int *num_elem,
+				 unsigned int elem_size)
+{
+	struct rxe_queue *q;
+	size_t buf_size;
+	unsigned int num_slots;
+
+	/* num_elem == 0 is allowed, but uninteresting */
+	if (*num_elem < 0)
+		goto err1;
+
+	q = kmalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		goto err1;
+
+	q->rxe = rxe;
+
+	/* used in resize, only need to copy used part of queue */
+	q->elem_size = elem_size;
+
+	/* pad element up to at least a cacheline and always a power of 2 */
+	if (elem_size < cache_line_size())
+		elem_size = cache_line_size();
+	elem_size = roundup_pow_of_two(elem_size);
+
+	q->log2_elem_size = order_base_2(elem_size);
+
+	num_slots = *num_elem + 1;
+	num_slots = roundup_pow_of_two(num_slots);
+	q->index_mask = num_slots - 1;
+
+	buf_size = sizeof(struct rxe_queue_buf) + num_slots * elem_size;
+
+	q->buf = vmalloc_user(buf_size);
+	if (!q->buf)
+		goto err2;
+
+	q->buf->log2_elem_size = q->log2_elem_size;
+	q->buf->index_mask = q->index_mask;
+
+	q->buf_size = buf_size;
+
+	*num_elem = num_slots - 1;
+	return q;
+
+err2:
+	kfree(q);
+err1:
+	return NULL;
+}
+
+/* copies elements from original q to new q and then swaps the contents of the
+ * two q headers. This is so that if anyone is holding a pointer to q it will
+ * still work
+ */
+static int resize_finish(struct rxe_queue *q, struct rxe_queue *new_q,
+			 unsigned int num_elem)
+{
+	if (!queue_empty(q) && (num_elem < queue_count(q)))
+		return -EINVAL;
+
+	while (!queue_empty(q)) {
+		memcpy(producer_addr(new_q), consumer_addr(q),
+		       new_q->elem_size);
+		advance_producer(new_q);
+		advance_consumer(q);
+	}
+
+	swap(*q, *new_q);
+
+	return 0;
+}
+
+int rxe_queue_resize(struct rxe_queue *q,
+		     unsigned int *num_elem_p,
+		     unsigned int elem_size,
+		     struct ib_ucontext *context,
+		     struct ib_udata *udata,
+		     spinlock_t *producer_lock,
+		     spinlock_t *consumer_lock)
+{
+	struct rxe_queue *new_q;
+	unsigned int num_elem = *num_elem_p;
+	int err;
+	unsigned long flags = 0, flags1;
+
+	new_q = rxe_queue_init(q->rxe, &num_elem, elem_size);
+	if (!new_q)
+		return -ENOMEM;
+
+	err = do_mmap_info(new_q->rxe, udata, false, context, new_q->buf,
+			   new_q->buf_size, &new_q->ip);
+	if (err) {
+		vfree(new_q->buf);
+		kfree(new_q);
+		goto err1;
+	}
+
+	spin_lock_irqsave(consumer_lock, flags1);
+
+	if (producer_lock) {
+		spin_lock_irqsave(producer_lock, flags);
+		err = resize_finish(q, new_q, num_elem);
+		spin_unlock_irqrestore(producer_lock, flags);
+	} else {
+		err = resize_finish(q, new_q, num_elem);
+	}
+
+	spin_unlock_irqrestore(consumer_lock, flags1);
+
+	rxe_queue_cleanup(new_q);	/* new/old dep on err */
+	if (err)
+		goto err1;
+
+	*num_elem_p = num_elem;
+	return 0;
+
+err1:
+	return err;
+}
+
+void rxe_queue_cleanup(struct rxe_queue *q)
+{
+	if (q->ip)
+		kref_put(&q->ip->ref, rxe_mmap_release);
+	else
+		vfree(q->buf);
+
+	kfree(q);
+}
diff --git a/drivers/staging/rxe/rxe_queue.h b/drivers/staging/rxe/rxe_queue.h
new file mode 100644
index 0000000..8690301
--- /dev/null
+++ b/drivers/staging/rxe/rxe_queue.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef RXE_QUEUE_H
+#define RXE_QUEUE_H
+
+/* implements a simple circular buffer that can optionally be
+ * shared between user space and the kernel and can be resized
+
+ * the requested element size is rounded up to a power of 2
+ * and the number of elements in the buffer is also rounded
+ * up to a power of 2. Since the queue is empty when the
+ * producer and consumer indices match the maximum capacity
+ * of the queue is one less than the number of element slots
+ */
+
+/* this data structure is shared between user space and kernel
+ * space for those cases where the queue is shared. It contains
+ * the producer and consumer indices. Is also contains a copy
+ * of the queue size parameters for user space to use but the
+ * kernel must use the parameters in the rxe_queue struct
+ * this MUST MATCH the corresponding librxe struct
+ * for performance reasons arrange to have producer and consumer
+ * pointers in separate cache lines
+ * the kernel should always mask the indices to avoid accessing
+ * memory outside of the data area
+ */
+struct rxe_queue_buf {
+	__u32			log2_elem_size;
+	__u32			index_mask;
+	__u32			pad_1[30];
+	__u32			producer_index;
+	__u32			pad_2[31];
+	__u32			consumer_index;
+	__u32			pad_3[31];
+	__u8			data[0];
+};
+
+struct rxe_queue {
+	struct rxe_dev		*rxe;
+	struct rxe_queue_buf	*buf;
+	struct rxe_mmap_info	*ip;
+	size_t			buf_size;
+	size_t			elem_size;
+	unsigned int		log2_elem_size;
+	unsigned int		index_mask;
+};
+
+int do_mmap_info(struct rxe_dev *rxe,
+		 struct ib_udata *udata,
+		 bool is_req,
+		 struct ib_ucontext *context,
+		 struct rxe_queue_buf *buf,
+		 size_t buf_size,
+		 struct rxe_mmap_info **ip_p);
+
+struct rxe_queue *rxe_queue_init(struct rxe_dev *rxe,
+				 int *num_elem,
+				 unsigned int elem_size);
+
+int rxe_queue_resize(struct rxe_queue *q,
+		     unsigned int *num_elem_p,
+		     unsigned int elem_size,
+		     struct ib_ucontext *context,
+		     struct ib_udata *udata,
+		     /* Protect producers while resizing queue */
+		     spinlock_t *producer_lock,
+		     /* Protect consumers while resizing queue */
+		     spinlock_t *consumer_lock);
+
+void rxe_queue_cleanup(struct rxe_queue *queue);
+
+static inline int next_index(struct rxe_queue *q, int index)
+{
+	return (index + 1) & q->buf->index_mask;
+}
+
+static inline int queue_empty(struct rxe_queue *q)
+{
+	return ((q->buf->producer_index - q->buf->consumer_index)
+			& q->index_mask) == 0;
+}
+
+static inline int queue_full(struct rxe_queue *q)
+{
+	return ((q->buf->producer_index + 1 - q->buf->consumer_index)
+			& q->index_mask) == 0;
+}
+
+static inline void advance_producer(struct rxe_queue *q)
+{
+	q->buf->producer_index = (q->buf->producer_index + 1)
+			& q->index_mask;
+}
+
+static inline void advance_consumer(struct rxe_queue *q)
+{
+	q->buf->consumer_index = (q->buf->consumer_index + 1)
+			& q->index_mask;
+}
+
+static inline void *producer_addr(struct rxe_queue *q)
+{
+	return q->buf->data + ((q->buf->producer_index & q->index_mask)
+				<< q->log2_elem_size);
+}
+
+static inline void *consumer_addr(struct rxe_queue *q)
+{
+	return q->buf->data + ((q->buf->consumer_index & q->index_mask)
+				<< q->log2_elem_size);
+}
+
+static inline unsigned int producer_index(struct rxe_queue *q)
+{
+	return q->buf->producer_index;
+}
+
+static inline unsigned int consumer_index(struct rxe_queue *q)
+{
+	return q->buf->consumer_index;
+}
+
+static inline void *addr_from_index(struct rxe_queue *q, unsigned int index)
+{
+	return q->buf->data + ((index & q->index_mask)
+				<< q->buf->log2_elem_size);
+}
+
+static inline unsigned int index_from_addr(const struct rxe_queue *q,
+					   const void *addr)
+{
+	return (((u8 *)addr - q->buf->data) >> q->log2_elem_size)
+		& q->index_mask;
+}
+
+static inline unsigned int queue_count(const struct rxe_queue *q)
+{
+	return (q->buf->producer_index - q->buf->consumer_index)
+		& q->index_mask;
+}
+
+static inline void *queue_head(struct rxe_queue *q)
+{
+	return queue_empty(q) ? NULL : consumer_addr(q);
+}
+
+#endif /* RXE_QUEUE_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
