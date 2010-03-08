From: "Sean Hefty" <sean.hefty@intel.com>
Subject: [PATCH v2] dapl: fix ring buffer synchronization
Date: Mon, 8 Mar 2010 11:57:54 -0800
Message-ID: <66216D2A290246B581DF66CB5F2C6D36@amr.corp.intel.com>
References: <FAC9FE73F3AF47139AB1D34495A67D94@amr.corp.intel.com>
	<E3280858FA94444CA49D2BA02341C983B5D1459C@orsmsx506.amr.corp.intel.com>
	<88F96DBEF37C4CE595653116D75C6942@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <88F96DBEF37C4CE595653116D75C6942@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Hefty, Sean" <sean.hefty@intel.com>, "Davis, Arlin R" <arlin.r.davis@intel.com>, ofw@lists.openfabrics.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The dapl ring buffer implementation is not thread safe and requires
the user to provide all synchronization.  Since the user must provide
synchronization, replace atomic definitions with simple ints to
improve performance and make the code more self-documenting that
no synchronization is provided.

Signed-off-by: Sean Hefty <sean.hefty@intel.com>
---
change from v1:
removed dapl_os_lock from struct dapl_ring_buffer

 .../ulp/dapl2/dapl/common/dapl_ring_buffer_util.c  |  168 +++++++-------------
 .../ulp/dapl2/dapl/common/dapl_ring_buffer_util.h  |    7 -
 trunk/ulp/dapl2/dapl/include/dapl.h                |    6 -
 3 files changed, 63 insertions(+), 118 deletions(-)

diff --git a/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c b/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c
index 54517a9..710be93 100644
--- a/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c
+++ b/trunk/ulp/dapl2/dapl/common/dapl_ring_buffer_util.c
@@ -31,6 +31,7 @@
  *
  * PURPOSE: Ring buffer management
  * Description: Support and management functions for ring buffers
+ * All synchronization must be provided by the user.
  *
  * $Id:$
  **********************************************************************/
@@ -41,8 +42,7 @@
  * dapls_rbuf_alloc
  *
  * Given a DAPL_RING_BUFFER, initialize it and provide memory for
- * the ringbuf itself. A passed in size will be adjusted to the next
- * largest power of two number to simplify management.
+ * the ringbuf itself.
  *
  * Input:
  *	rbuf		pointer to DAPL_RING_BUFFER
@@ -58,38 +58,26 @@
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
@@ -106,41 +94,33 @@ DAT_RETURN dapls_rbuf_alloc(INOUT DAPL_RING_BUFFER * rbuf, IN DAT_COUNT size)
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
-
-	*rbuf = new_rbuf;
+	dapl_os_free(rbuf->base, rbuf->size * sizeof(void *));
+	rbuf->base = base;
+	rbuf->size = size;
 
-      bail:
-	return dat_status;
+	return DAT_SUCCESS;
 }
 
 /*
@@ -160,15 +140,7 @@ DAT_RETURN dapls_rbuf_realloc(INOUT DAPL_RING_BUFFER * rbuf, IN DAT_COUNT size)
  */
 void dapls_rbuf_destroy(IN DAPL_RING_BUFFER * rbuf)
 {
-	if ((NULL == rbuf) || (NULL == rbuf->base)) {
-		return;
-	}
-
-	dapl_os_free(rbuf->base, (rbuf->lim + 1) * sizeof(void *));
-	rbuf->base = NULL;
-	rbuf->lim = 0;
-
-	return;
+	dapl_os_free(rbuf->base, rbuf->size * sizeof(void *));
 }
 
 /*
@@ -190,22 +162,18 @@ void dapls_rbuf_destroy(IN DAPL_RING_BUFFER * rbuf)
  */
 DAT_RETURN dapls_rbuf_add(IN DAPL_RING_BUFFER * rbuf, IN void *entry)
 {
-	int pos;
-	int val;
+	DAT_RETURN ret;
 
-	while (((dapl_os_atomic_read(&rbuf->head) + 1) & rbuf->lim) !=
-	       (dapl_os_atomic_read(&rbuf->tail) & rbuf->lim)) {
-		pos = dapl_os_atomic_read(&rbuf->head);
-		val = dapl_os_atomic_assign(&rbuf->head, pos, pos + 1);
-		if (val == pos) {
-			pos = (pos + 1) & rbuf->lim;	/* verify in range */
-			rbuf->base[pos] = entry;
-			return DAT_SUCCESS;
-		}
+	if (dapls_rbuf_count(rbuf) < rbuf->size - 1) {
+		rbuf->base[rbuf->head++] = entry;
+		if (rbuf->head == rbuf->size)
+			rbuf->head = 0;
+		ret = DAT_SUCCESS;
+	} else {
+		ret = DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 	}
 
-	return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
-
+	return ret;
 }
 
 /*
@@ -226,26 +194,22 @@ DAT_RETURN dapls_rbuf_add(IN DAPL_RING_BUFFER * rbuf, IN void *entry)
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
+	if (!dapls_rbuf_empty(rbuf)) {
+		entry = rbuf->base[rbuf->tail++];
+		if (rbuf->tail == rbuf->size)
+			rbuf->tail = 0;
+	} else {
+		entry = NULL;
 	}
 
-	return NULL;
+	return entry;
 
 }
 
 /*
- * dapli_rbuf_count
+ * dapls_rbuf_count
  *
  * Return the number of entries in use in the ring buffer
  *
@@ -262,20 +226,10 @@ void *dapls_rbuf_remove(IN DAPL_RING_BUFFER * rbuf)
  */
 DAT_COUNT dapls_rbuf_count(IN DAPL_RING_BUFFER * rbuf)
 {
-	DAT_COUNT count;
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
-
-	return count;
+	if (rbuf->head >= rbuf->tail)
+		return rbuf->head - rbuf->tail;
+	else
+		return rbuf->size - rbuf->tail + rbuf->head;
 }
 
 /*
@@ -299,19 +253,13 @@ DAT_COUNT dapls_rbuf_count(IN DAPL_RING_BUFFER * rbuf)
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
+	for (i = 0; i < rbuf->size; i++)
+		rbuf->base[i] = (void *) ((char *)rbuf->base[i] + offset);
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
+	return rbuf->head == rbuf->tail;
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
index 4439ec5..57aaecf 100644
--- a/trunk/ulp/dapl2/dapl/include/dapl.h
+++ b/trunk/ulp/dapl2/dapl/include/dapl.h
@@ -237,9 +237,9 @@ struct dapl_llist_entry
 struct dapl_ring_buffer
 {
     void		**base;		/* base of element array */
-    DAT_COUNT		lim;		/* mask, number of entries - 1 */
-    DAPL_ATOMIC		head;		/* head pointer index */
-    DAPL_ATOMIC		tail;		/* tail pointer index */
+    DAT_COUNT		size;
+    DAT_COUNT		head;
+    DAT_COUNT		tail;
 };
 
 struct dapl_cookie_buffer
