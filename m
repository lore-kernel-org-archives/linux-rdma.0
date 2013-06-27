From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 14/16 ibacm] Convert linux header files from DOS to unix
 format
Date: Thu, 27 Jun 2013 15:14:24 -0400
Message-ID: <51CC8F10.1000109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
New patch since v1 patches

 linux/dlist.h |  162 ++++++++++++++--------------
 linux/osd.h   |  344 ++++++++++++++++++++++++++++----------------------------
 2 files changed, 253 insertions(+), 253 deletions(-)

diff --git a/linux/dlist.h b/linux/dlist.h
index d08f843..7977d7c 100644
--- a/linux/dlist.h
+++ b/linux/dlist.h
@@ -1,81 +1,81 @@
-/*
- * Copyright (c) 2009 Intel Corporation. All rights reserved.
- *
- * This software is available to you under the OpenIB.org BSD license
- * below:
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
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef _DLIST_H_
-#define _DLIST_H_
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-typedef struct _DLIST_ENTRY {
-	struct _DLIST_ENTRY	*Next;
-	struct _DLIST_ENTRY	*Prev;
-
-}	DLIST_ENTRY;
-
-static void DListInit(DLIST_ENTRY *pHead)
-{
-	pHead->Next = pHead;
-	pHead->Prev = pHead;
-}
-
-static int DListEmpty(DLIST_ENTRY *pHead)
-{
-	return pHead->Next == pHead;
-}
-
-static void DListInsertAfter(DLIST_ENTRY *pNew, DLIST_ENTRY *pHead)
-{
-	pNew->Next = pHead->Next;
-	pNew->Prev = pHead;
-	pHead->Next->Prev = pNew;
-	pHead->Next = pNew;
-}
-
-static void DListInsertBefore(DLIST_ENTRY *pNew, DLIST_ENTRY *pHead)
-{
-	DListInsertAfter(pNew, pHead->Prev);
-}
-
-#define DListInsertHead DListInsertAfter
-#define DListInsertTail DListInsertBefore
-
-static void DListRemove(DLIST_ENTRY *pEntry)
-{
-	pEntry->Prev->Next = pEntry->Next;
-	pEntry->Next->Prev = pEntry->Prev;
-}
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif // _DLIST_H_
-
+/*
+ * Copyright (c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This software is available to you under the OpenIB.org BSD license
+ * below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _DLIST_H_
+#define _DLIST_H_
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+typedef struct _DLIST_ENTRY {
+	struct _DLIST_ENTRY	*Next;
+	struct _DLIST_ENTRY	*Prev;
+
+}	DLIST_ENTRY;
+
+static void DListInit(DLIST_ENTRY *pHead)
+{
+	pHead->Next = pHead;
+	pHead->Prev = pHead;
+}
+
+static int DListEmpty(DLIST_ENTRY *pHead)
+{
+	return pHead->Next == pHead;
+}
+
+static void DListInsertAfter(DLIST_ENTRY *pNew, DLIST_ENTRY *pHead)
+{
+	pNew->Next = pHead->Next;
+	pNew->Prev = pHead;
+	pHead->Next->Prev = pNew;
+	pHead->Next = pNew;
+}
+
+static void DListInsertBefore(DLIST_ENTRY *pNew, DLIST_ENTRY *pHead)
+{
+	DListInsertAfter(pNew, pHead->Prev);
+}
+
+#define DListInsertHead DListInsertAfter
+#define DListInsertTail DListInsertBefore
+
+static void DListRemove(DLIST_ENTRY *pEntry)
+{
+	pEntry->Prev->Next = pEntry->Next;
+	pEntry->Next->Prev = pEntry->Prev;
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif // _DLIST_H_
+
diff --git a/linux/osd.h b/linux/osd.h
index 0b6884f..6d42349 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -1,172 +1,172 @@
-/*
- * Copyright (c) 2009 Intel Corporation.  All rights reserved.
- * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved.
- *
- * This software is available to you under the OpenFabrics.org BSD license
- * below:
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
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#if !defined(OSD_H)
-#define OSD_H
-
-#include <stdlib.h>
-#include <string.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <errno.h>
-#include <byteswap.h>
-#include <pthread.h>
-#include <sys/socket.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <malloc.h>
-#include <arpa/inet.h>
-#include <sys/time.h>
-#include <netinet/in.h>
-
-#ifndef SYSCONFDIR
-#define SYSCONFDIR "/etc"
-#endif
-#ifndef BINDIR
-#define BINDIR "/usr/bin"
-#endif
-#ifndef RDMADIR
-#define RDMADIR "rdma"
-#endif
-#define ACM_CONF_DIR  SYSCONFDIR "/" RDMADIR
-#define ACM_ADDR_FILE "ibacm_addr.cfg"
-#define ACM_OPTS_FILE "ibacm_opts.cfg"
-#define ACM_PATH_REC_FILE "ibacm_path_records.dump"
-
-#define LIB_DESTRUCTOR __attribute__((destructor))
-#define CDECL_FUNC
-
-#define container_of(ptr, type, field) \
-	((type *) ((void *) ptr - offsetof(type, field)))
-
-#define min(a, b) (a < b ? a : b)
-#define max(a, b) (a > b ? a : b)
-
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#define htonll(x) bswap_64(x)
-#else
-#define htonll(x) (x)
-#endif
-#define ntohll(x) htonll(x)
-
-#if DEFINE_ATOMICS
-typedef struct { pthread_mutex_t mut; int val; } atomic_t;
-static inline int atomic_inc(atomic_t *atomic)
-{
-	int v;
-
-	pthread_mutex_lock(&atomic->mut);
-	v = ++(atomic->val);
-	pthread_mutex_unlock(&atomic->mut);
-	return v;
-}
-static inline int atomic_dec(atomic_t *atomic)
-{
-	int v;
-
-	pthread_mutex_lock(&atomic->mut);
-	v = --(atomic->val);
-	pthread_mutex_unlock(&atomic->mut);
-	return v;
-}
-static inline void atomic_init(atomic_t *atomic)
-{
-	pthread_mutex_init(&atomic->mut, NULL);
-	atomic->val = 0;
-}
-#else
-typedef struct { volatile int val; } atomic_t;
-#define atomic_inc(v) (__sync_add_and_fetch(&(v)->val, 1))
-#define atomic_dec(v) (__sync_sub_and_fetch(&(v)->val, 1))
-#define atomic_init(v) ((v)->val = 0)
-#endif
-#define atomic_get(v) ((v)->val)
-#define atomic_set(v, s) ((v)->val = s)
-
-#define stricmp strcasecmp
-#define strnicmp strncasecmp
-
-typedef struct { pthread_cond_t cond; pthread_mutex_t mutex; } event_t;
-static inline void event_init(event_t *e)
-{
-	pthread_cond_init(&e->cond, NULL);
-	pthread_mutex_init(&e->mutex, NULL);
-}
-#define event_signal(e)	pthread_cond_signal(&(e)->cond)
-static inline int event_wait(event_t *e, int timeout) 
-{
-	struct timeval curtime;
-	struct timespec wait;
-	int ret;
-
-	gettimeofday(&curtime, NULL);
-	wait.tv_sec = curtime.tv_sec + ((unsigned) timeout) / 1000;
-	wait.tv_nsec = (curtime.tv_usec + (((unsigned) timeout) % 1000) * 1000) * 1000;
-	pthread_mutex_lock(&e->mutex);
-	ret = pthread_cond_timedwait(&e->cond, &e->mutex, &wait);
-	pthread_mutex_unlock(&e->mutex);
-	return ret;
-}
-
-#define lock_t       pthread_mutex_t
-#define lock_init(x) pthread_mutex_init(x, NULL)
-#define lock_acquire pthread_mutex_lock
-#define lock_release pthread_mutex_unlock
-
-#define osd_init()  0
-#define osd_close()
-
-#define SOCKET         int
-#define SOCKET_ERROR   -1
-#define INVALID_SOCKET -1
-#define socket_errno() errno
-#define closesocket    close
-
-static inline uint64_t time_stamp_us(void)
-{
-	struct timeval curtime;
-	timerclear(&curtime);
-	gettimeofday(&curtime, NULL);
-	return (uint64_t) curtime.tv_sec * 1000000 + (uint64_t) curtime.tv_usec;
-}
-
-#define time_stamp_ms()  (time_stamp_us() / (uint64_t) 1000)
-#define time_stamp_sec() (time_stamp_ms() / (uint64_t) 1000)
-#define time_stamp_min() (time_stamp_sec() / (uint64_t) 60)
-
-#define PER_THREAD __thread
-static inline int beginthread(void (*func)(void *), void *arg)
-{
-	pthread_t thread;
-	return pthread_create(&thread, NULL, (void *(*)(void*)) func, arg);
-}
-
-#endif /* OSD_H */
-
+/*
+ * Copyright (c) 2009 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved.
+ *
+ * This software is available to you under the OpenFabrics.org BSD license
+ * below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(OSD_H)
+#define OSD_H
+
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+#include <byteswap.h>
+#include <pthread.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <malloc.h>
+#include <arpa/inet.h>
+#include <sys/time.h>
+#include <netinet/in.h>
+
+#ifndef SYSCONFDIR
+#define SYSCONFDIR "/etc"
+#endif
+#ifndef BINDIR
+#define BINDIR "/usr/bin"
+#endif
+#ifndef RDMADIR
+#define RDMADIR "rdma"
+#endif
+#define ACM_CONF_DIR  SYSCONFDIR "/" RDMADIR
+#define ACM_ADDR_FILE "ibacm_addr.cfg"
+#define ACM_OPTS_FILE "ibacm_opts.cfg"
+#define ACM_PATH_REC_FILE "ibacm_path_records.dump"
+
+#define LIB_DESTRUCTOR __attribute__((destructor))
+#define CDECL_FUNC
+
+#define container_of(ptr, type, field) \
+	((type *) ((void *) ptr - offsetof(type, field)))
+
+#define min(a, b) (a < b ? a : b)
+#define max(a, b) (a > b ? a : b)
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define htonll(x) bswap_64(x)
+#else
+#define htonll(x) (x)
+#endif
+#define ntohll(x) htonll(x)
+
+#if DEFINE_ATOMICS
+typedef struct { pthread_mutex_t mut; int val; } atomic_t;
+static inline int atomic_inc(atomic_t *atomic)
+{
+	int v;
+
+	pthread_mutex_lock(&atomic->mut);
+	v = ++(atomic->val);
+	pthread_mutex_unlock(&atomic->mut);
+	return v;
+}
+static inline int atomic_dec(atomic_t *atomic)
+{
+	int v;
+
+	pthread_mutex_lock(&atomic->mut);
+	v = --(atomic->val);
+	pthread_mutex_unlock(&atomic->mut);
+	return v;
+}
+static inline void atomic_init(atomic_t *atomic)
+{
+	pthread_mutex_init(&atomic->mut, NULL);
+	atomic->val = 0;
+}
+#else
+typedef struct { volatile int val; } atomic_t;
+#define atomic_inc(v) (__sync_add_and_fetch(&(v)->val, 1))
+#define atomic_dec(v) (__sync_sub_and_fetch(&(v)->val, 1))
+#define atomic_init(v) ((v)->val = 0)
+#endif
+#define atomic_get(v) ((v)->val)
+#define atomic_set(v, s) ((v)->val = s)
+
+#define stricmp strcasecmp
+#define strnicmp strncasecmp
+
+typedef struct { pthread_cond_t cond; pthread_mutex_t mutex; } event_t;
+static inline void event_init(event_t *e)
+{
+	pthread_cond_init(&e->cond, NULL);
+	pthread_mutex_init(&e->mutex, NULL);
+}
+#define event_signal(e)	pthread_cond_signal(&(e)->cond)
+static inline int event_wait(event_t *e, int timeout) 
+{
+	struct timeval curtime;
+	struct timespec wait;
+	int ret;
+
+	gettimeofday(&curtime, NULL);
+	wait.tv_sec = curtime.tv_sec + ((unsigned) timeout) / 1000;
+	wait.tv_nsec = (curtime.tv_usec + (((unsigned) timeout) % 1000) * 1000) * 1000;
+	pthread_mutex_lock(&e->mutex);
+	ret = pthread_cond_timedwait(&e->cond, &e->mutex, &wait);
+	pthread_mutex_unlock(&e->mutex);
+	return ret;
+}
+
+#define lock_t       pthread_mutex_t
+#define lock_init(x) pthread_mutex_init(x, NULL)
+#define lock_acquire pthread_mutex_lock
+#define lock_release pthread_mutex_unlock
+
+#define osd_init()  0
+#define osd_close()
+
+#define SOCKET         int
+#define SOCKET_ERROR   -1
+#define INVALID_SOCKET -1
+#define socket_errno() errno
+#define closesocket    close
+
+static inline uint64_t time_stamp_us(void)
+{
+	struct timeval curtime;
+	timerclear(&curtime);
+	gettimeofday(&curtime, NULL);
+	return (uint64_t) curtime.tv_sec * 1000000 + (uint64_t) curtime.tv_usec;
+}
+
+#define time_stamp_ms()  (time_stamp_us() / (uint64_t) 1000)
+#define time_stamp_sec() (time_stamp_ms() / (uint64_t) 1000)
+#define time_stamp_min() (time_stamp_sec() / (uint64_t) 60)
+
+#define PER_THREAD __thread
+static inline int beginthread(void (*func)(void *), void *arg)
+{
+	pthread_t thread;
+	return pthread_create(&thread, NULL, (void *(*)(void*)) func, arg);
+}
+
+#endif /* OSD_H */
+
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
