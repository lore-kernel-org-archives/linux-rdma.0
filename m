From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core] Remove atexit and destructors
Date: Thu, 22 Dec 2016 15:10:47 -0700
Message-ID: <20161222221047.GA15780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is no guarantee how a process will be exiting, specifically there
is no guarantee that there is only 1 thread. This means what atexit
handlers can safely do is very limited.

In particular freeing resources that would otherwise be freed by the OS
is absolutely wrong in a multi-threaded environment.

- neigh.c: This deletes the netlink socket
- ocrdma_main.c: These delete locks and free devices
- cma.c: This frees pds and other objects
- amp.c: We don't need to wait for a thread to exit if we are
  exiting.

This fixes a crash on-exit observed with at least rping where a
thread calls exit() while the main thread is still running.
This creates a race where rdma_destroy_id() runs concurrently
with ucma_cleanup() and one of them will randomly crash with a jump
to NULL.

This will create some leaked memory complaints from valgrind
mem checkers. These need to be solved with sensible resource
tracking to free the objects once all possible users are gone
and not relying on atexit.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c     | 19 -------------------
 libibverbs/ibverbs.h           |  1 -
 libibverbs/neigh.c             |  7 -------
 librdmacm/cma.c                | 27 ---------------------------
 providers/ocrdma/ocrdma_main.c | 21 ---------------------
 5 files changed, 75 deletions(-)

This seems to be a longstanding bug, but I'm hitting it nearly every
time on my Xenial systems with rdma-core's build.

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 27f41b8db2289d..56567ef8bf379c 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2923,25 +2923,6 @@ static void __attribute__((constructor)) acmp_init(void)
 	acmp_initialized = 1;
 }
 
-static void __attribute__((destructor)) acmp_exit(void)
-{
-	acm_log(1, "Unloading...\n");
-	if (retry_thread_started) {
-		if (pthread_cancel(retry_thread_id)) {
-			acm_log(0, "Error: failed to cancel the retry thread\n");
-			return;
-		}
-		if (pthread_join(retry_thread_id, NULL)) {
-			acm_log(0, "Error: failed to join the retry thread\n");
-			return;
-		}
-		retry_thread_started = 0;
-	}
-
-	umad_done();
-	acmp_initialized = 0;
-}
-
 int provider_query(struct acm_provider **provider, uint32_t *version)
 {
 	acm_log(1, "\n");
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index dd2dacf4534d65..1ec43e6cf7d896 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -41,7 +41,6 @@
 #include <valgrind/memcheck.h>
 
 #define INIT		__attribute__((constructor))
-#define FINI		__attribute__((destructor))
 
 #define DEFAULT_ABI	"IBVERBS_1.1"
 
diff --git a/libibverbs/neigh.c b/libibverbs/neigh.c
index 12e58cd4b63c2c..053a0c2972a27f 100644
--- a/libibverbs/neigh.c
+++ b/libibverbs/neigh.c
@@ -628,16 +628,9 @@ free:
 	return oif;
 }
 
-static void destroy_zero_based_socket(void)
-{
-	if (zero_socket != NULL)
-		nl_socket_free(zero_socket);
-}
-
 static void alloc_zero_based_socket(void)
 {
 	zero_socket = nl_socket_alloc();
-	atexit(&destroy_zero_based_socket);
 }
 
 int neigh_init_resources(struct get_neigh_handler *neigh_handler, int timeout)
diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 77f6fea38c6ba9..7f79ee942186bb 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -134,28 +134,6 @@ int af_ib_support;
 static struct index_map ucma_idm;
 static fastlock_t idm_lock;
 
-static void ucma_cleanup(void)
-{
-	ucma_ib_cleanup();
-
-	if (cma_dev_cnt) {
-		while (cma_dev_cnt--) {
-			if (!cma_dev_array[cma_dev_cnt].verbs)
-				continue;
-
-			if (cma_dev_array[cma_dev_cnt].refcnt)
-				ibv_dealloc_pd(cma_dev_array[cma_dev_cnt].pd);
-			ibv_close_device(cma_dev_array[cma_dev_cnt].verbs);
-			free(cma_dev_array[cma_dev_cnt].port);
-			cma_init_cnt--;
-		}
-
-		fastlock_destroy(&idm_lock);
-		free(cma_dev_array);
-		cma_dev_cnt = 0;
-	}
-}
-
 static int check_abi_version(void)
 {
 	char value[8];
@@ -378,11 +356,6 @@ void rdma_free_devices(struct ibv_context **list)
 	free(list);
 }
 
-static void __attribute__((destructor)) rdma_cma_fini(void)
-{
-	ucma_cleanup();
-}
-
 struct rdma_event_channel *rdma_create_event_channel(void)
 {
 	struct rdma_event_channel *channel;
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 39da8f0a1228b0..dfd3172841255b 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -239,24 +239,3 @@ void ocrdma_register_driver(void)
 {
 	ibv_register_driver("ocrdma", ocrdma_driver_init);
 }
-
-static __attribute__ ((destructor))
-void ocrdma_unregister_driver(void)
-{
-	struct ocrdma_device *dev;
-	struct ocrdma_device *dev_tmp;
-	pthread_mutex_lock(&ocrdma_dev_list_lock);
-	list_for_each_safe(&ocrdma_dev_list, dev, dev_tmp, entry) {
-		pthread_mutex_destroy(&dev->dev_lock);
-		pthread_spin_destroy(&dev->flush_q_lock);
-		list_del(&dev->entry);
-		/*
-		 * Avoid freeing the dev here since MPI get SIGSEGV
-		 * in few error cases because of reference to ib_dev
-		 * after free.
-		 * TODO Bug 135437 fix it properly to avoid mem leak
-		 */
-		/* free(dev); */
-	}
-	pthread_mutex_unlock(&ocrdma_dev_list_lock);
-}
-- 
2.7.4


-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
