From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl: fix ring buffer synchronization
Date: Thu, 4 Mar 2010 16:18:06 -0800
Message-ID: <FAC9FE73F3AF47139AB1D34495A67D94@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The dapl ring buffer implementation is not thread safe.  Replace
the use of atomic variables with actual locking to ensure that
there are not races inserting and/or removing items at the same time.

Without proper synchronization, the EVD can report invalid events or
the same event multiple times.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 .../ulp/dapl2/dapl/common/dapl_ring_buffer_util.c  |  187 +++++++++-----------
 .../ulp/dapl2/dapl/common/dapl_ring_buffer_util.h  |    7 -
 trunk/ulp/dapl2/dapl/include/dapl.h                |    7 -
 3 files changed, 88 insertions(+), 113 deletions(-)

diff --git a/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c b/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c
index 54517a9..d1ee269 100644
--- a/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c
+++ b/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c
@@ -41,8 +41,7 @@
  * dapls_rbuf_alloc
  *
  * Given a DAPL_RING_BUFFER, initialize it and provide memory for
- * the ringbuf itself. A passed in size will be adjusted to the next
- * largest power of two number to simplify management.
+ * the ringbuf itself.
  *
  * Input:
  *	rbuf		pointer to DAPL_RING_BUFFER
@@ -58,38 +57,27 @@
  */
 DAT_RETURN dapls_rbuf_alloc(INOUT DAPL_RING_BUFFER * rbuf, IN DAT_COUNT size)
 {
-	unsigned int rsize;	/* real size */
-
 	/* The circular buffer must be allocated one too large.
 	 * This eliminates any need for a distinct counter, as
 	 * having the two pointers equal always means "empty" -- never "full"
 	 */
 	size++;
 
-	/* Put size on a power of 2 boundary */
-	rsize = 1;
-	while ((DAT_COUNT) rsize < size) {
-		rsize <<= 1;
-	}
-
-	rbuf->base = (void *)dapl_os_alloc(rsize * sizeof(void *));
-	if (rbuf->base != NULL) {
-		rbuf->lim = rsize - 1;
-		dapl_os_atomic_set(&rbuf->head, 0);
-		dapl_os_atomic_set(&rbuf->tail, 0);
-	} else {
+	rbuf->base = (void *)dapl_os_alloc(size * sizeof(void *));
+	if (rbuf->base == NULL)
 		return DAT_INSUFFICIENT_RESOURCES | DAT_RESOURCE_MEMORY;
-	}
 
+	dapl_os_lock_init(&rbuf->lock);
+	rbuf->size = size;
+	rbuf->head = 0;
+	rbuf->tail = 0;
 	return DAT_SUCCESS;
 }
 
 /*
  * dapls_rbuf_realloc
  *
- * Resizes a DAPL_RING_BUFFER. This function is not thread safe;
- * adding or removing elements from a ring buffer while resizing 
- * will have indeterminate results.
+ * Resizes a DAPL_RING_BUFFER.
  *
  * Input:
  *	rbuf		pointer to DAPL_RING_BUFFER
@@ -106,41 +94,35 @@ DAT_RETURN dapls_rbuf_alloc(INOUT DAPL_RING_BUFFER * rbuf, IN DAT_COUNT size)
  */
 DAT_RETURN dapls_rbuf_realloc(INOUT DAPL_RING_BUFFER * rbuf, IN DAT_COUNT size)
 {
-	DAPL_RING_BUFFER new_rbuf;
-	void *entry;
-	DAT_RETURN dat_status;
-
-	dat_status = DAT_SUCCESS;
+	void **base;
 
 	/* decreasing the size or retaining the old size is not allowed */
-	if (size <= rbuf->lim + 1) {
-		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG2);
-		goto bail;
-	}
+	if (size <= rbuf->size + 1)
+		return DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG2);
 
-	/*
-	 * !This is NOT ATOMIC!
-	 * Simple algorithm: Allocate a new ring buffer, take everything
-	 * out of the old one and put it in the new one, and release the 
-	 * old base buffer.
-	 */
-	dat_status = dapls_rbuf_alloc(&new_rbuf, size);
-	if (dat_status != DAT_SUCCESS) {
-		goto bail;
-	}
+	base = (void *) dapl_os_alloc(size * sizeof(void *));
+	if (base == NULL)
+		return DAT_INSUFFICIENT_RESOURCES | DAT_RESOURCE_MEMORY;
 
-	while ((entry = dapls_rbuf_remove(rbuf)) != NULL) {
-		/* We know entries will fit so ignore the return code */
-		(void)dapls_rbuf_add(&new_rbuf, entry);
+	dapl_os_lock(&rbuf->lock);
+	if (rbuf->head > rbuf->tail) {
+		memcpy(&base[rbuf->tail], &rbuf->base[rbuf->tail],
+			(rbuf->head - rbuf->tail) * sizeof(void *));
+	} else if (rbuf->head < rbuf->tail) {
+		memcpy(&base[0], &rbuf->base[rbuf->tail],
+			(rbuf->size - rbuf->tail) * sizeof(void *));
+		memcpy(&base[rbuf->size - rbuf->tail], &rbuf->base[0],
+			rbuf->head * sizeof(void *));
+		rbuf->head = rbuf->size - rbuf->tail + rbuf->head;
+		rbuf->tail = 0;
 	}
 
-	/* release the old base buffer */
-	dapl_os_free(rbuf->base, (rbuf->lim + 1) * sizeof(void *));
+	dapl_os_free(rbuf->base, rbuf->size * sizeof(void *));
+	rbuf->base = base;
+	rbuf->size = size;
+	dapl_os_unlock(&rbuf->lock);
 
-	*rbuf = new_rbuf;
-
-      bail:
-	return dat_status;
+	return DAT_SUCCESS;
 }
 
 /*
@@ -160,15 +142,21 @@ DAT_RETURN dapls_rbuf_realloc(INOUT DAPL_RING_BUFFER * rbuf, IN DAT_COUNT size)
  */
 void dapls_rbuf_destroy(IN DAPL_RING_BUFFER * rbuf)
 {
-	if ((NULL == rbuf) || (NULL == rbuf->base)) {
-		return;
-	}
+	dapl_os_lock_destroy(&rbuf->lock);
+	dapl_os_free(rbuf->base, rbuf->size * sizeof(void *));
+}
 
-	dapl_os_free(rbuf->base, (rbuf->lim + 1) * sizeof(void *));
-	rbuf->base = NULL;
-	rbuf->lim = 0;
+static DAT_COUNT dapli_rbuf_count(IN DAPL_RING_BUFFER * rbuf)
+{
+	if (rbuf->head >= rbuf->tail)
+		return rbuf->head - rbuf->tail;
+	else
+		return rbuf->size - rbuf->tail + rbuf->head;
+}
 
-	return;
+static int dapli_rbuf_empty(IN DAPL_RING_BUFFER *rbuf)
+{
+	return rbuf->head == rbuf->tail;
 }
 
 /*
@@ -190,22 +178,20 @@ void dapls_rbuf_destroy(IN DAPL_RING_BUFFER * rbuf)
  */
 DAT_RETURN dapls_rbuf_add(IN DAPL_RING_BUFFER * rbuf, IN void *entry)
 {
-	int pos;
-	int val;
-
-	while (((dapl_os_atomic_read(&rbuf->head) + 1) & rbuf->lim) !=
-	       (dapl_os_atomic_read(&rbuf->tail) & rbuf->lim)) {
-		pos = dapl_os_atomic_read(&rbuf->head);
-		val = dapl_os_atomic_assign(&rbuf->head, pos, pos + 1);
-		if (val == pos) {
-			pos = (pos + 1) & rbuf->lim;	/* verify in range */
-			rbuf->base[pos] = entry;
-			return DAT_SUCCESS;
-		}
+	DAT_RETURN ret;
+
+	dapl_os_lock(&rbuf->lock);
+	if (dapli_rbuf_count(rbuf) < rbuf->size - 1) {
+		rbuf->base[rbuf->head++] = entry;
+		if (rbuf->head == rbuf->size)
+			rbuf->head = 0;
+		ret = DAT_SUCCESS;
+	} else {
+		ret = DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 	}
+	dapl_os_unlock(&rbuf->lock);
 
-	return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
-
+	return ret;
 }
 
 /*
@@ -226,21 +212,19 @@ DAT_RETURN dapls_rbuf_add(IN DAPL_RING_BUFFER * rbuf, IN void *entry)
  */
 void *dapls_rbuf_remove(IN DAPL_RING_BUFFER * rbuf)
 {
-	int pos;
-	int val;
-
-	while (dapl_os_atomic_read(&rbuf->head) !=
-	       dapl_os_atomic_read(&rbuf->tail)) {
-		pos = dapl_os_atomic_read(&rbuf->tail);
-		val = dapl_os_atomic_assign(&rbuf->tail, pos, pos + 1);
-		if (val == pos) {
-			pos = (pos + 1) & rbuf->lim;	/* verify in range */
+	void *entry;
 
-			return (rbuf->base[pos]);
-		}
+	dapl_os_lock(&rbuf->lock);
+	if (!dapli_rbuf_empty(rbuf)) {
+		entry = rbuf->base[rbuf->tail++];
+		if (rbuf->tail == rbuf->size)
+			rbuf->tail = 0;
+	} else {
+		entry = NULL;
 	}
+	dapl_os_unlock(&rbuf->lock);
 
-	return NULL;
+	return entry;
 
 }
 
@@ -263,18 +247,10 @@ void *dapls_rbuf_remove(IN DAPL_RING_BUFFER * rbuf)
 DAT_COUNT dapls_rbuf_count(IN DAPL_RING_BUFFER * rbuf)
 {
 	DAT_COUNT count;
-	int head;
-	int tail;
-
-	head = dapl_os_atomic_read(&rbuf->head) & rbuf->lim;
-	tail = dapl_os_atomic_read(&rbuf->tail) & rbuf->lim;
-	if (head > tail) {
-		count = head - tail;
-	} else {
-		/* add 1 to lim as it is a mask, number of entries - 1 */
-		count = (rbuf->lim + 1 - tail + head) & rbuf->lim;
-	}
 
+	dapl_os_lock(&rbuf->lock);
+	count = dapli_rbuf_count(rbuf);
+	dapl_os_unlock(&rbuf->lock);
 	return count;
 }
 
@@ -299,19 +275,20 @@ DAT_COUNT dapls_rbuf_count(IN DAPL_RING_BUFFER * rbuf)
  */
 void dapls_rbuf_adjust(IN DAPL_RING_BUFFER * rbuf, IN intptr_t offset)
 {
-	int pos;
+	int i;
 
-	pos = dapl_os_atomic_read(&rbuf->head);
-	while (pos != dapl_os_atomic_read(&rbuf->tail)) {
-		rbuf->base[pos] = (void *)((char *)rbuf->base[pos] + offset);
-		pos = (pos + 1) & rbuf->lim;	/* verify in range */
-	}
+	dapl_os_lock(&rbuf->lock);
+	for (i = 0; i < rbuf->size; i++)
+		rbuf->base[i] = (void *) ((char *)rbuf->base[i] + offset);
+	dapl_os_unlock(&rbuf->lock);
 }
 
-/*
- * Local variables:
- *  c-indent-level: 4
- *  c-basic-offset: 4
- *  tab-width: 8
- * End:
- */
+int dapls_rbuf_empty(IN DAPL_RING_BUFFER * rbuf)
+{
+	int empty;
+
+	dapl_os_lock(&rbuf->lock);
+	empty = dapli_rbuf_empty(rbuf);
+	dapl_os_unlock(&rbuf->lock);
+	return empty;
+}
diff --git a/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.h b/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.h
index 46c82c9..1eb782d 100644
--- a/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.h
+++ b/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.h
@@ -68,11 +68,8 @@ void dapls_rbuf_adjust (
 	IN  DAPL_RING_BUFFER		*rbuf,
 	IN  intptr_t			offset);
 
-
-/*
- * Simple functions
- */
-#define dapls_rbuf_empty(rbuf)	(rbuf->head == rbuf->tail)
+int dapls_rbuf_empty(
+	IN   DAPL_RING_BUFFER		*rbuf);
 
 
 #endif /* _DAPL_RING_BUFFER_H_ */
diff --git a/trunk/ulp/dapl2/dapl/include/dapl.h b/trunk/ulp/dapl2/dapl/include/dapl.h
index 4439ec5..f7b885b 100644
--- a/trunk/ulp/dapl2/dapl/include/dapl.h
+++ b/trunk/ulp/dapl2/dapl/include/dapl.h
@@ -237,9 +237,10 @@ struct dapl_llist_entry
 struct dapl_ring_buffer
 {
     void		**base;		/* base of element array */
-    DAT_COUNT		lim;		/* mask, number of entries - 1 */
-    DAPL_ATOMIC		head;		/* head pointer index */
-    DAPL_ATOMIC		tail;		/* tail pointer index */
+    DAT_COUNT		size;
+    DAT_COUNT		head;
+    DAT_COUNT		tail;
+    DAPL_OS_LOCK	lock;
 };
 
 struct dapl_cookie_buffer


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
