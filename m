From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/6] rdmacm: Use C11 stdatomic for all atomics
Date: Wed, 15 Mar 2017 16:12:05 -0600
Message-ID: <1489615927-12117-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No sense in having a private API here. stdatomic will be equivalent
to the gcc builtin.

This is motivated by sparse which does not handle the gcc atomic builtins.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/cma.h     | 49 +++++--------------------------------------------
 librdmacm/preload.c | 14 ++++++--------
 librdmacm/rsocket.c |  7 +++----
 3 files changed, 14 insertions(+), 56 deletions(-)

diff --git a/librdmacm/cma.h b/librdmacm/cma.h
index 8795d2894d262f..645d1e43576279 100644
--- a/librdmacm/cma.h
+++ b/librdmacm/cma.h
@@ -40,6 +40,7 @@
 #include <errno.h>
 #include <endian.h>
 #include <semaphore.h>
+#include <stdatomic.h>
 
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
@@ -53,46 +54,14 @@
 /*
  * Fast synchronization for low contention locking.
  */
-#if DEFINE_ATOMICS
-#define fastlock_t pthread_mutex_t
-#define fastlock_init(lock) pthread_mutex_init(lock, NULL)
-#define fastlock_destroy(lock) pthread_mutex_destroy(lock)
-#define fastlock_acquire(lock) pthread_mutex_lock(lock)
-#define fastlock_release(lock) pthread_mutex_unlock(lock)
-
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
 typedef struct {
 	sem_t sem;
-	volatile int cnt;
+	_Atomic(int) cnt;
 } fastlock_t;
 static inline void fastlock_init(fastlock_t *lock)
 {
 	sem_init(&lock->sem, 0, 0);
-	lock->cnt = 0;
+	atomic_store(&lock->cnt, 0);
 }
 static inline void fastlock_destroy(fastlock_t *lock)
 {
@@ -100,23 +69,15 @@ static inline void fastlock_destroy(fastlock_t *lock)
 }
 static inline void fastlock_acquire(fastlock_t *lock)
 {
-	if (__sync_add_and_fetch(&lock->cnt, 1) > 1)
+	if (atomic_fetch_add(&lock->cnt, 1) > 1)
 		sem_wait(&lock->sem);
 }
 static inline void fastlock_release(fastlock_t *lock)
 {
-	if (__sync_sub_and_fetch(&lock->cnt, 1) > 0)
+	if (atomic_fetch_sub(&lock->cnt, 1) > 0)
 		sem_post(&lock->sem);
 }
 
-typedef struct { volatile int val; } atomic_t;
-#define atomic_inc(v) (__sync_add_and_fetch(&(v)->val, 1))
-#define atomic_dec(v) (__sync_sub_and_fetch(&(v)->val, 1))
-#define atomic_init(v) ((v)->val = 0)
-#endif /* DEFINE_ATOMICS */
-#define atomic_get(v) ((v)->val)
-#define atomic_set(v, s) ((v)->val = s)
-
 uint16_t ucma_get_port(struct sockaddr *addr);
 int ucma_addrlen(struct sockaddr *addr);
 void ucma_set_sid(enum rdma_port_space ps, struct sockaddr *addr,
diff --git a/librdmacm/preload.c b/librdmacm/preload.c
index 1aea3a7f0a247a..bd1bcb1d701015 100644
--- a/librdmacm/preload.c
+++ b/librdmacm/preload.c
@@ -119,7 +119,7 @@ struct fd_info {
 	enum fd_fork_state state;
 	int fd;
 	int dupfd;
-	atomic_t refcnt;
+	_Atomic(int) refcnt;
 };
 
 struct config_entry {
@@ -266,8 +266,7 @@ static int fd_open(void)
 	}
 
 	fdi->dupfd = -1;
-	atomic_init(&fdi->refcnt);
-	atomic_set(&fdi->refcnt, 1);
+	atomic_store(&fdi->refcnt, 1);
 	pthread_mutex_lock(&mut);
 	ret = idm_set(&idm, index, fdi);
 	pthread_mutex_unlock(&mut);
@@ -1013,7 +1012,7 @@ int close(int socket)
 			return ret;
 	}
 
-	if (atomic_dec(&fdi->refcnt))
+	if (atomic_fetch_sub(&fdi->refcnt, 1))
 		return 0;
 
 	idm_clear(&idm, socket);
@@ -1118,7 +1117,7 @@ int dup2(int oldfd, int newfd)
 	newfdi = idm_lookup(&idm, newfd);
 	if (newfdi) {
 		 /* newfd cannot have been dup'ed directly */
-		if (atomic_get(&newfdi->refcnt) > 1)
+		if (atomic_load(&newfdi->refcnt) > 1)
 			return ERR(EBUSY);
 		close(newfd);
 	}
@@ -1145,9 +1144,8 @@ int dup2(int oldfd, int newfd)
 	} else {
 		newfdi->dupfd = oldfd;
 	}
-	atomic_init(&newfdi->refcnt);
-	atomic_set(&newfdi->refcnt, 1);
-	atomic_inc(&oldfdi->refcnt);
+	atomic_store(&newfdi->refcnt, 1);
+	atomic_fetch_add(&oldfdi->refcnt, 1);
 	return newfd;
 }
 
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 69ceab6de745d0..a0bc604845c118 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -190,7 +190,7 @@ struct rs_iomap_mr {
 	uint64_t offset;
 	struct ibv_mr *mr;
 	dlist_entry entry;
-	atomic_t refcnt;
+	_Atomic(int) refcnt;
 	int index;	/* -1 if mapping is local and not in iomap_list */
 };
 
@@ -898,7 +898,7 @@ static int rs_create_ep(struct rsocket *rs)
 
 static void rs_release_iomap_mr(struct rs_iomap_mr *iomr)
 {
-	if (atomic_dec(&iomr->refcnt))
+	if (atomic_fetch_sub(&iomr->refcnt, 1))
 		return;
 
 	dlist_remove(&iomr->entry);
@@ -3798,8 +3798,7 @@ off_t riomap(int socket, void *buf, size_t len, int prot, int flags, off_t offse
 	if (offset == -1)
 		offset = (uintptr_t) buf;
 	iomr->offset = offset;
-	atomic_init(&iomr->refcnt);
-	atomic_set(&iomr->refcnt, 1);
+	atomic_store(&iomr->refcnt, 1);
 
 	if (iomr->index >= 0) {
 		dlist_insert_tail(&iomr->entry, &rs->iomap_queue);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
