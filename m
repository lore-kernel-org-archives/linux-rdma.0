From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2.0 -  common: restructure EVD processing to handle
 EP destruction phase and overflow conditions
Date: Mon, 20 Sep 2010 11:13:33 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830114D0A73F@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


EVD processing in the common code will return unformatted events
if EP context is invalid as a result of destruction. During
EP destruction, add changes to flush EVD and process DTO completions
before the EP freeing is called. Simplified the locking in the
EVD code to eliminate the unnecessary and very confusing condition
checking of evd_producer_locking_needed. The EVD overflow logic
was also broken and in need of fixing with this restructuring.

new dapls_ep_flush_cqs() call created to synchronize flush and
event processing.

unnecessary KDAPL code removed in the EVD processing.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Regression testing done on latest OFED Windows and Linux
release using dtest, dapltest, Intel MPI test suites
with wait mode and CNO processing enabled.
CMA, SCM, and UCM providers all tested.


---
 dapl/common/dapl_cno_util.c          |   40 ---
 dapl/common/dapl_ep_disconnect.c     |    1 +
 dapl/common/dapl_ep_free.c           |    2 +
 dapl/common/dapl_ep_util.c           |   21 ++
 dapl/common/dapl_ep_util.h           |    4 +-
 dapl/common/dapl_evd_util.c          |  439 +++++++++++-----------------------
 dapl/common/dapl_evd_util.h          |    5 +-
 dapl/include/dapl.h                  |    3 -
 dapl/udapl/dapl_evd_set_unwaitable.c |    2 +-
 dapl/udapl/dapl_evd_wait.c           |   12 +-
 10 files changed, 176 insertions(+), 353 deletions(-)

diff --git a/dapl/common/dapl_cno_util.c b/dapl/common/dapl_cno_util.c
index 2215f29..cad9747 100755
--- a/dapl/common/dapl_cno_util.c
+++ b/dapl/common/dapl_cno_util.c
@@ -148,9 +148,6 @@ void dapl_cno_dealloc(IN DAPL_CNO * cno_ptr)
 void dapl_internal_cno_trigger(IN DAPL_CNO * cno_ptr, IN DAPL_EVD * evd_ptr)
 {
        DAT_RETURN dat_status;
-#if defined(__KDAPL__)
-       DAT_EVENT event;
-#endif                         /* defined(__KDAPL__) */

        dat_status = DAT_SUCCESS;

@@ -167,20 +164,14 @@ void dapl_internal_cno_trigger(IN DAPL_CNO * cno_ptr, IN DAPL_EVD * evd_ptr)
        dapl_os_assert(cno_ptr->cno_state != DAPL_CNO_STATE_DEAD);

        if (cno_ptr->cno_state == DAPL_CNO_STATE_UNTRIGGERED) {
-#if !defined(__KDAPL__)
                DAT_OS_WAIT_PROXY_AGENT agent;

                /* Squirrel away wait agent, and delete link.  */
                agent = cno_ptr->cno_wait_agent;
-#endif                         /* !defined(__KDAPL__) */

                /* Separate assignments for windows compiler.  */
 #ifndef _WIN32
-#if defined(__KDAPL__)
-               cno_ptr->cno_upcall = DAT_UPCALL_NULL;
-#else
                cno_ptr->cno_wait_agent = DAT_OS_WAIT_PROXY_AGENT_NULL;
-#endif                         /* defined(__KDAPL__) */
 #else
                cno_ptr->cno_wait_agent.instance_data = NULL;
                cno_ptr->cno_wait_agent.proxy_agent_func = NULL;
@@ -200,43 +191,12 @@ void dapl_internal_cno_trigger(IN DAPL_CNO * cno_ptr, IN DAPL_EVD * evd_ptr)
                dapl_os_unlock(&cno_ptr->header.lock);

                /* Trigger the OS proxy wait agent, if one exists.  */
-#if defined(__KDAPL__)
-               dat_status = dapl_evd_dequeue((DAT_EVD_HANDLE) evd_ptr, &event);
-               while (dat_status == DAT_SUCCESS) {
-                       if (cno_ptr->cno_upcall.upcall_func !=
-                           (DAT_UPCALL_FUNC) NULL) {
-                               cno_ptr->cno_upcall.upcall_func(cno_ptr->
-                                                               cno_upcall.
-                                                               instance_data,
-                                                               &event,
-                                                               DAT_FALSE);
-                       }
-                       dat_status = dapl_evd_dequeue((DAT_EVD_HANDLE) evd_ptr,
-                                                     &event);
-               }
-#else
                if (agent.proxy_agent_func != (DAT_AGENT_FUNC) NULL) {
                        agent.proxy_agent_func(agent.instance_data,
                                               (DAT_EVD_HANDLE) evd_ptr);
                }
-#endif                         /* defined(__KDAPL__) */
        } else {
                dapl_os_unlock(&cno_ptr->header.lock);
-#if defined(__KDAPL__)
-               dat_status = dapl_evd_dequeue((DAT_EVD_HANDLE) evd_ptr, &event);
-               while (dat_status == DAT_SUCCESS) {
-                       if (cno_ptr->cno_upcall.upcall_func !=
-                           (DAT_UPCALL_FUNC) NULL) {
-                               cno_ptr->cno_upcall.upcall_func(cno_ptr->
-                                                               cno_upcall.
-                                                               instance_data,
-                                                               &event,
-                                                               DAT_FALSE);
-                       }
-                       dat_status = dapl_evd_dequeue((DAT_EVD_HANDLE) evd_ptr,
-                                                     &event);
-               }
-#endif                         /* defined(__KDAPL__) */
        }

        return;
diff --git a/dapl/common/dapl_ep_disconnect.c b/dapl/common/dapl_ep_disconnect.c
index 72da620..90748b0 100644
--- a/dapl/common/dapl_ep_disconnect.c
+++ b/dapl/common/dapl_ep_disconnect.c
@@ -165,6 +165,7 @@ dapl_ep_disconnect(IN DAT_EP_HANDLE ep_handle,
        }
        dapl_os_unlock(&ep_ptr->header.lock);
        dat_status = dapls_ib_disconnect(ep_ptr, disconnect_flags);
+       dapls_ep_flush_cqs(ep_ptr);

       bail:
        dapl_dbg_log(DAPL_DBG_TYPE_RTN | DAPL_DBG_TYPE_CM,
diff --git a/dapl/common/dapl_ep_free.c b/dapl/common/dapl_ep_free.c
index 3bfc541..32d50cc 100644
--- a/dapl/common/dapl_ep_free.c
+++ b/dapl/common/dapl_ep_free.c
@@ -202,6 +202,8 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
                }
        }

+       dapls_ep_flush_cqs(ep_ptr);
+
        /* Free the resource */
        dapl_ep_dealloc(ep_ptr);

diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index 9aff242..fc911a6 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -606,6 +606,27 @@ void dapl_ep_unlink_cm(IN DAPL_EP *ep_ptr, IN dp_ib_cm_handle_t cm_ptr)
        dapl_os_unlock(&ep_ptr->header.lock);
 }

+static void dapli_ep_flush_evd(DAPL_EVD *evd_ptr)
+{
+       DAT_RETURN dat_status;
+
+       dapl_os_lock(&evd_ptr->header.lock);
+       dat_status = dapls_evd_copy_cq(evd_ptr);
+       dapl_os_unlock(&evd_ptr->header.lock);
+
+       if (dat_status == DAT_QUEUE_FULL)
+               dapls_evd_post_overflow_event(evd_ptr);
+}
+
+void dapls_ep_flush_cqs(DAPL_EP * ep_ptr)
+{
+       if (ep_ptr->param.request_evd_handle)
+               dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.request_evd_handle);
+
+       if (ep_ptr->param.recv_evd_handle)
+               dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.recv_evd_handle);
+}
+
 /*
  * Local variables:
  *  c-indent-level: 4
diff --git a/dapl/common/dapl_ep_util.h b/dapl/common/dapl_ep_util.h
index 31d0e23..37805d4 100644
--- a/dapl/common/dapl_ep_util.h
+++ b/dapl/common/dapl_ep_util.h
@@ -101,5 +101,7 @@ STATIC _INLINE_ dp_ib_cm_handle_t dapl_get_cm_from_ep(IN DAPL_EP *ep_ptr)

        return cm_ptr;
 }
-
+
+extern void dapls_ep_flush_cqs(DAPL_EP * ep_ptr);
+
 #endif /*  _DAPL_EP_UTIL_H_ */
diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index 12d38ff..237293b 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -160,15 +160,6 @@ dapls_evd_internal_create(DAPL_IA * ia_ptr,
                goto bail;
        }

-       /*
-        * If we are dealing with event streams besides a CQ event stream,
-        * be conservative and set producer side locking.  Otherwise, no.
-        * Note: CNO is not considered CQ event stream.
-        */
-       evd_ptr->evd_producer_locking_needed =
-           (!(evd_flags & (DAT_EVD_DTO_FLAG | DAT_EVD_RMR_BIND_FLAG)) ||
-            evd_ptr->cno_ptr);
-
        /* Before we setup any callbacks, transition state to OPEN.  */
        evd_ptr->evd_state = DAPL_EVD_STATE_OPEN;

@@ -299,7 +290,6 @@ DAPL_EVD *dapls_evd_alloc(IN DAPL_IA * ia_ptr,
        evd_ptr->evd_flags = evd_flags;
        evd_ptr->evd_enabled = DAT_TRUE;
        evd_ptr->evd_waitable = DAT_TRUE;
-       evd_ptr->evd_producer_locking_needed = 1;       /* Conservative value.  */
        evd_ptr->ib_cq_handle = IB_INVALID_HANDLE;
        dapl_os_atomic_set(&evd_ptr->evd_ref_count, 0);
        evd_ptr->catastrophic_overflow = DAT_FALSE;
@@ -583,60 +573,12 @@ void dapli_evd_eh_print_cqe(IN ib_work_completion_t * cqe_ptr)
  * Event posting code follows.
  */

-/*
- * These next two functions (dapli_evd_get_event and dapli_evd_post_event)
- * are a pair.  They are always called together, from one of the functions
- * at the end of this file (dapl_evd_post_*_event).
- *
- * Note that if producer side locking is enabled, the first one takes the
- * EVD lock and the second releases it.
- */
-
-/* dapli_evd_get_event
- *
- * Get an event struct from the evd.  The caller should fill in the event
- * and call dapl_evd_post_event.
- *
- * If there are no events available, an overflow event is generated to the
- * async EVD handler.
- *
- * If this EVD required producer locking, a successful return implies
- * that the lock is held.
- *
- * Input:
- *     evd_ptr
- *
- * Output:
- *     event
- *
- */
-
-static DAT_EVENT *dapli_evd_get_event(DAPL_EVD * evd_ptr)
-{
-       DAT_EVENT *event;
-
-       if (evd_ptr->evd_producer_locking_needed) {
-               dapl_os_lock(&evd_ptr->header.lock);
-       }
-
-       event = (DAT_EVENT *) dapls_rbuf_remove(&evd_ptr->free_event_queue);
-
-       /* Release the lock if it was taken and the call failed.  */
-       if (!event && evd_ptr->evd_producer_locking_needed) {
-               dapl_os_unlock(&evd_ptr->header.lock);
-       }
-
-       return event;
-}

 /* dapli_evd_post_event
  *
  * Post the <event> to the evd.  If possible, invoke the evd's CNO.
  * Otherwise post the event on the pending queue.
  *
- * If producer side locking is required, the EVD lock must be held upon
- * entry to this function.
- *
  * Input:
  *     evd_ptr
  *     event
@@ -650,7 +592,6 @@ static void
 dapli_evd_post_event(IN DAPL_EVD * evd_ptr, IN const DAT_EVENT * event_ptr)
 {
        DAT_RETURN dat_status;
-       DAPL_CNO *cno_to_trigger = NULL;

        dapl_dbg_log(DAPL_DBG_TYPE_EVD, "%s: %s evd %p state %d\n",
                     __FUNCTION__, dapl_event_str(event_ptr->event_number),
@@ -665,110 +606,37 @@ dapli_evd_post_event(IN DAPL_EVD * evd_ptr, IN const DAT_EVENT * event_ptr)

        if (evd_ptr->evd_state == DAPL_EVD_STATE_OPEN) {
                /* No waiter.  Arrange to trigger a CNO if it exists.  */
-
-               if (evd_ptr->evd_enabled) {
-                       cno_to_trigger = evd_ptr->cno_ptr;
-               }
-               if (evd_ptr->evd_producer_locking_needed) {
-                       dapl_os_unlock(&evd_ptr->header.lock);
-               }
+               if (evd_ptr->evd_enabled && evd_ptr->cno_ptr)
+                       dapl_internal_cno_trigger(evd_ptr->cno_ptr, evd_ptr);
        } else {
-               /*
-                * We're in DAPL_EVD_STATE_WAITED.  Take the lock if
-                * we don't have it, recheck, and signal.
-                */
-               if (!evd_ptr->evd_producer_locking_needed) {
-                       dapl_os_lock(&evd_ptr->header.lock);
-               }
-
                if (evd_ptr->evd_state == DAPL_EVD_STATE_WAITED
                    && (dapls_rbuf_count(&evd_ptr->pending_event_queue)
                        >= evd_ptr->threshold)) {
-                       dapl_os_unlock(&evd_ptr->header.lock);

                        if (evd_ptr->evd_flags & (DAT_EVD_DTO_FLAG | DAT_EVD_RMR_BIND_FLAG)) {
                                dapls_evd_dto_wakeup(evd_ptr);
                        } else {
                                dapl_os_wait_object_wakeup(&evd_ptr->wait_object);
                        }
-
-               } else {
-                       dapl_os_unlock(&evd_ptr->header.lock);
                }
        }
-
-       if (cno_to_trigger != NULL) {
-               dapl_internal_cno_trigger(cno_to_trigger, evd_ptr);
-       }
 }

-/* dapli_evd_post_event_nosignal
- *
- * Post the <event> to the evd.  Do not do any wakeup processing.
- * This function should only be called if it is known that there are
- * no waiters that it is appropriate to wakeup on this EVD.  An example
- * of such a situation is during internal dat_evd_wait() processing.
- *
- * If producer side locking is required, the EVD lock must be held upon
- * entry to this function.
- *
- * Input:
- *     evd_ptr
- *     event
- *
- * Output:
- *     none
- *
- */
-
-static void
-dapli_evd_post_event_nosignal(IN DAPL_EVD * evd_ptr,
-                             IN const DAT_EVENT * event_ptr)
+static DAT_EVENT *dapli_evd_get_and_init_event(IN DAPL_EVD * evd_ptr,
+                                              IN DAT_EVENT_NUMBER event_number)
 {
-       DAT_RETURN dat_status;
-
-       dapl_dbg_log(DAPL_DBG_TYPE_EVD, "%s: Called with event %s\n",
-                    __FUNCTION__, dapl_event_str(event_ptr->event_number));
-
-       dat_status = dapls_rbuf_add(&evd_ptr->pending_event_queue,
-                                   (void *)event_ptr);
-       dapl_os_assert(dat_status == DAT_SUCCESS);
-
-       dapl_os_assert(evd_ptr->evd_state == DAPL_EVD_STATE_WAITED
-                      || evd_ptr->evd_state == DAPL_EVD_STATE_OPEN);
+       DAT_EVENT *event_ptr;

-       if (evd_ptr->evd_producer_locking_needed) {
-               dapl_os_unlock(&evd_ptr->header.lock);
+       event_ptr = (DAT_EVENT *) dapls_rbuf_remove(&evd_ptr->free_event_queue);
+       if (event_ptr) {
+               event_ptr->evd_handle = (DAT_EVD_HANDLE) evd_ptr;
+               event_ptr->event_number = event_number;
        }
-}
-
-/* dapli_evd_format_overflow_event
- *
- * format an overflow event for posting
- *
- * Input:
- *     evd_ptr
- *     event_ptr
- *
- * Output:
- *     none
- *
- */
-static void
-dapli_evd_format_overflow_event(IN DAPL_EVD * evd_ptr,
-                               OUT DAT_EVENT * event_ptr)
-{
-       DAPL_IA *ia_ptr;
-
-       ia_ptr = evd_ptr->header.owner_ia;

-       event_ptr->evd_handle = (DAT_EVD_HANDLE) evd_ptr;
-       event_ptr->event_number = DAT_ASYNC_ERROR_EVD_OVERFLOW;
-       event_ptr->event_data.asynch_error_event_data.dat_handle =
-           (DAT_HANDLE) ia_ptr;
+       return event_ptr;
 }

-/* dapli_evd_post_overflow_event
+/* dapls_evd_post_overflow_event
  *
  * post an overflow event
  *
@@ -780,52 +648,38 @@ dapli_evd_format_overflow_event(IN DAPL_EVD * evd_ptr,
  *     none
  *
  */
-static void
-dapli_evd_post_overflow_event(IN DAPL_EVD * async_evd_ptr,
-                             IN DAPL_EVD * overflow_evd_ptr)
+void
+dapls_evd_post_overflow_event(IN DAPL_EVD * evd_ptr)
 {
-       DAT_EVENT *overflow_event;
+       DAPL_EVD *async_evd_ptr = evd_ptr->header.owner_ia->async_error_evd;
+       DAT_EVENT *event_ptr;

-       /* The overflow_evd_ptr mght be the same as evd.
-        * In that case we've got a catastrophic overflow.
-        */
-       dapl_log(DAPL_DBG_TYPE_WARN,
-                " WARNING: overflow event on EVD %p/n", overflow_evd_ptr);
+       dapl_log(DAPL_DBG_TYPE_WARN, " WARNING: overflow event on EVD %p/n", evd_ptr);

-       if (async_evd_ptr == overflow_evd_ptr) {
-               async_evd_ptr->catastrophic_overflow = DAT_TRUE;
-               async_evd_ptr->evd_state = DAPL_EVD_STATE_DEAD;
-               return;
-       }
+       dapl_os_lock(&async_evd_ptr->header.lock);

-       overflow_event = dapli_evd_get_event(overflow_evd_ptr);
-       if (!overflow_event) {
-               /* this is not good */
-               overflow_evd_ptr->catastrophic_overflow = DAT_TRUE;
-               overflow_evd_ptr->evd_state = DAPL_EVD_STATE_DEAD;
-               return;
-       }
-       dapli_evd_format_overflow_event(overflow_evd_ptr, overflow_event);
-       dapli_evd_post_event(overflow_evd_ptr, overflow_event);
+       /* The overflow evd_ptr mght be the same as the async evd.
+        * In that case we've got a catastrophic overflow.
+        */
+       if (async_evd_ptr == evd_ptr)
+               goto err;
+
+       event_ptr = dapli_evd_get_and_init_event(async_evd_ptr,
+                                                DAT_ASYNC_ERROR_EVD_OVERFLOW);
+       if (!event_ptr)
+               goto err;
+
+       event_ptr->event_data.asynch_error_event_data.dat_handle =
+           (DAT_HANDLE) evd_ptr->header.owner_ia;

+       dapli_evd_post_event(async_evd_ptr, event_ptr);
+       dapl_os_unlock(&async_evd_ptr->header.lock);
        return;
-}
-
-static DAT_EVENT *dapli_evd_get_and_init_event(IN DAPL_EVD * evd_ptr,
-                                              IN DAT_EVENT_NUMBER event_number)
-{
-       DAT_EVENT *event_ptr;

-       event_ptr = dapli_evd_get_event(evd_ptr);
-       if (NULL == event_ptr) {
-               dapli_evd_post_overflow_event(evd_ptr->header.owner_ia->
-                                             async_error_evd, evd_ptr);
-       } else {
-               event_ptr->evd_handle = (DAT_EVD_HANDLE) evd_ptr;
-               event_ptr->event_number = event_number;
-       }
-
-       return event_ptr;
+err:
+       async_evd_ptr->catastrophic_overflow = DAT_TRUE;
+       async_evd_ptr->evd_state = DAPL_EVD_STATE_DEAD;
+       dapl_os_unlock(&async_evd_ptr->header.lock);
 }

 DAT_RETURN
@@ -837,17 +691,11 @@ dapls_evd_post_cr_arrival_event(IN DAPL_EVD * evd_ptr,
                                DAT_CR_HANDLE cr_handle)
 {
        DAT_EVENT *event_ptr;
-       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */

-       if (event_ptr == NULL) {
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
-       }
+       dapl_os_lock(&evd_ptr->header.lock);
+       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
+       if (event_ptr == NULL)
+               goto err;

        event_ptr->event_data.cr_arrival_event_data.sp_handle = sp_handle;
        event_ptr->event_data.cr_arrival_event_data.local_ia_address_ptr
@@ -856,8 +704,13 @@ dapls_evd_post_cr_arrival_event(IN DAPL_EVD * evd_ptr,
        event_ptr->event_data.cr_arrival_event_data.cr_handle = cr_handle;

        dapli_evd_post_event(evd_ptr, event_ptr);
-
+       dapl_os_unlock(&evd_ptr->header.lock);
        return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 }

 DAT_RETURN
@@ -868,17 +721,11 @@ dapls_evd_post_connection_event(IN DAPL_EVD * evd_ptr,
                                IN DAT_PVOID private_data)
 {
        DAT_EVENT *event_ptr;
-       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */

-       if (event_ptr == NULL) {
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
-       }
+       dapl_os_lock(&evd_ptr->header.lock);
+       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
+       if (event_ptr == NULL)
+               goto err;

        event_ptr->event_data.connect_event_data.ep_handle = ep_handle;
        event_ptr->event_data.connect_event_data.private_data_size
@@ -886,8 +733,13 @@ dapls_evd_post_connection_event(IN DAPL_EVD * evd_ptr,
        event_ptr->event_data.connect_event_data.private_data = private_data;

        dapli_evd_post_event(evd_ptr, event_ptr);
-
+       dapl_os_unlock(&evd_ptr->header.lock);
        return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 }

 DAT_RETURN
@@ -896,27 +748,27 @@ dapls_evd_post_async_error_event(IN DAPL_EVD * evd_ptr,
                                 IN DAT_IA_HANDLE ia_handle)
 {
        DAT_EVENT *event_ptr;
-       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */
+
        dapl_log(DAPL_DBG_TYPE_WARN,
                 " WARNING: async event - %s evd=%p/n",
                 dapl_event_str(event_number), evd_ptr);

-       if (event_ptr == NULL) {
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
-       }
+       dapl_os_lock(&evd_ptr->header.lock);
+       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
+       if (event_ptr == NULL)
+               goto err;

        event_ptr->event_data.asynch_error_event_data.dat_handle =
            (DAT_HANDLE) ia_handle;

        dapli_evd_post_event(evd_ptr, event_ptr);
-
+       dapl_os_unlock(&evd_ptr->header.lock);
        return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 }

 DAT_RETURN
@@ -925,23 +777,22 @@ dapls_evd_post_software_event(IN DAPL_EVD * evd_ptr,
                              IN DAT_PVOID pointer)
 {
        DAT_EVENT *event_ptr;
-       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */

-       if (event_ptr == NULL) {
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
-       }
+       dapl_os_lock(&evd_ptr->header.lock);
+       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
+       if (event_ptr == NULL)
+               goto err;

        event_ptr->event_data.software_event_data.pointer = pointer;

        dapli_evd_post_event(evd_ptr, event_ptr);
-
+       dapl_os_unlock(&evd_ptr->header.lock);
        return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 }

 /*
@@ -968,27 +819,58 @@ dapls_evd_post_generic_event(IN DAPL_EVD * evd_ptr,
 {
        DAT_EVENT *event_ptr;

+       dapl_os_lock(&evd_ptr->header.lock);
        event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */
-
-       if (event_ptr == NULL) {
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
-       }
+       if (event_ptr == NULL)
+               goto err;

        event_ptr->event_data = *data;

        dapli_evd_post_event(evd_ptr, event_ptr);
-
+       dapl_os_unlock(&evd_ptr->header.lock);
        return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 }

 #ifdef DAT_EXTENSIONS
 DAT_RETURN
+dapls_evd_do_post_cr_event_ext(IN DAPL_EVD * evd_ptr,
+                               IN DAT_EVENT_NUMBER event_number,
+                               IN DAPL_SP *sp_ptr,
+                               IN DAPL_CR *cr_ptr,
+                               IN DAT_PVOID ext_data)
+{
+       DAT_EVENT *event_ptr;
+
+       dapl_os_lock(&evd_ptr->header.lock);
+       event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
+       if (event_ptr == NULL)
+               goto err;
+
+       event_ptr->event_data.cr_arrival_event_data.sp_handle.psp_handle =
+           (DAT_PSP_HANDLE) sp_ptr;
+       event_ptr->event_data.cr_arrival_event_data.local_ia_address_ptr =
+           (DAT_IA_ADDRESS_PTR) &sp_ptr->header.owner_ia->hca_ptr->hca_address;
+       event_ptr->event_data.cr_arrival_event_data.conn_qual = sp_ptr->conn_qual;
+       event_ptr->event_data.cr_arrival_event_data.cr_handle = (DAT_CR_HANDLE) cr_ptr;
+
+       dapl_os_memcpy(&event_ptr->event_extension_data[0], ext_data, 64);
+
+       dapli_evd_post_event(sp_ptr->evd_handle, event_ptr);
+       dapl_os_unlock(&evd_ptr->header.lock);
+       return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
+}
+
+DAT_RETURN
 dapls_evd_post_cr_event_ext(IN DAPL_SP * sp_ptr,
                            IN DAT_EVENT_NUMBER event_number,
                            IN dp_ib_cm_handle_t ib_cm_handle,
@@ -998,7 +880,6 @@ dapls_evd_post_cr_event_ext(IN DAPL_SP * sp_ptr,
        DAPL_CR *cr_ptr;
        DAPL_EP *ep_ptr;
        DAT_EVENT *event_ptr;
-       DAT_SP_HANDLE sp_handle;

        dapl_os_lock(&sp_ptr->header.lock);
        if (sp_ptr->listening == DAT_FALSE) {
@@ -1087,36 +968,8 @@ dapls_evd_post_cr_event_ext(IN DAPL_SP * sp_ptr,
        /* link the CR onto the SP so we can pick it up later */
        dapl_sp_link_cr(sp_ptr, cr_ptr);

-       /* assign sp_ptr to union to avoid typecast errors from some compilers */
-       sp_handle.psp_handle = (DAT_PSP_HANDLE) sp_ptr;
-
-       /* Post the event.  */
-
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */
-       event_ptr = dapli_evd_get_and_init_event(sp_ptr->evd_handle,
-                                                event_number);
-       if (event_ptr == NULL)
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
-
-       event_ptr->event_data.cr_arrival_event_data.sp_handle = sp_handle;
-       event_ptr->event_data.cr_arrival_event_data.local_ia_address_ptr =
-           (DAT_IA_ADDRESS_PTR) & sp_ptr->header.owner_ia->hca_ptr->
-           hca_address;
-       event_ptr->event_data.cr_arrival_event_data.conn_qual =
-           sp_ptr->conn_qual;
-       event_ptr->event_data.cr_arrival_event_data.cr_handle =
-           (DAT_HANDLE) cr_ptr;
-
-       dapl_os_memcpy(&event_ptr->event_extension_data[0], ext_data, 64);
-
-       dapli_evd_post_event(sp_ptr->evd_handle, event_ptr);
-
-       return DAT_SUCCESS;
+       return dapls_evd_do_post_cr_event_ext(sp_ptr->evd_handle, event_number,
+                                             sp_ptr, cr_ptr, ext_data);
 }

 DAT_RETURN
@@ -1128,15 +981,11 @@ dapls_evd_post_connection_event_ext(IN DAPL_EVD * evd_ptr,
                                    IN DAT_PVOID ext_data)
 {
        DAT_EVENT *event_ptr;
+
+       dapl_os_lock(&evd_ptr->header.lock);
        event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
-       /*
-        * Note event lock may be held on successful return
-        * to be released by dapli_evd_post_event(), if provider side locking
-        * is needed.
-        */
        if (event_ptr == NULL)
-               return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
-                                DAT_RESOURCE_MEMORY);
+               goto err;

        event_ptr->event_data.connect_event_data.ep_handle = ep_handle;
        event_ptr->event_data.connect_event_data.private_data_size
@@ -1146,8 +995,13 @@ dapls_evd_post_connection_event_ext(IN DAPL_EVD * evd_ptr,
        dapl_os_memcpy(&event_ptr->event_extension_data[0], ext_data, 64);

        dapli_evd_post_event(evd_ptr, event_ptr);
-
+       dapl_os_unlock(&evd_ptr->header.lock);
        return DAT_SUCCESS;
+
+err:
+       dapl_os_unlock(&evd_ptr->header.lock);
+       dapls_evd_post_overflow_event(evd_ptr);
+       return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 }
 #endif

@@ -1187,10 +1041,6 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,

        ep_ptr = cookie->ep;
        dapl_os_assert((NULL != ep_ptr));
-       if (ep_ptr->header.magic != DAPL_MAGIC_EP) {
-               /* ep may have been freed, just return */
-               return;
-       }

        dapls_io_trc_update_completion(ep_ptr, cookie, dto_status);

@@ -1343,18 +1193,8 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
  * Copy all entries on a CQ associated with the EVD onto that EVD
  * Up to caller to handle races, if any.  Note that no EVD waiters will
  * be awoken by this copy.
- *
- * Input:
- *     evd_ptr
- *
- * Output:
- *     None
- *
- * Returns:
- *     none
- *
  */
-void dapls_evd_copy_cq(DAPL_EVD * evd_ptr)
+DAT_RETURN dapls_evd_copy_cq(DAPL_EVD * evd_ptr)
 {
        ib_work_completion_t cur_cqe;
        DAT_RETURN dat_status;
@@ -1362,7 +1202,7 @@ void dapls_evd_copy_cq(DAPL_EVD * evd_ptr)

        if (evd_ptr->ib_cq_handle == IB_INVALID_HANDLE) {
                /* Nothing to do if no CQ.  */
-               return;
+               return DAT_SUCCESS;
        }

        while (1) {
@@ -1381,18 +1221,13 @@ void dapls_evd_copy_cq(DAPL_EVD * evd_ptr)
                 * Can use DAT_DTO_COMPLETION_EVENT because dapli_evd_cqe_to_event
                 * will overwrite.
                 */
-
-               event =
-                   dapli_evd_get_and_init_event(evd_ptr,
-                                                DAT_DTO_COMPLETION_EVENT);
-               if (event == NULL) {
-                       /* We've already attempted the overflow post; return.  */
-                       return;
-               }
+               event = dapli_evd_get_and_init_event(evd_ptr, DAT_DTO_COMPLETION_EVENT);
+               if (event == NULL)
+                       return DAT_QUEUE_FULL;

                dapli_evd_cqe_to_event(evd_ptr, &cur_cqe, event);

-               dapli_evd_post_event_nosignal(evd_ptr, event);
+               dapli_evd_post_event(evd_ptr, event);
        }

        if (DAT_GET_TYPE(dat_status) != DAT_QUEUE_EMPTY) {
@@ -1400,7 +1235,9 @@ void dapls_evd_copy_cq(DAPL_EVD * evd_ptr)
                             "dapls_evd_copy_cq: dapls_ib_completion_poll returned 0x%x\n",
                             dat_status);
                dapl_os_assert(!"Bad return from dapls_ib_completion_poll");
+               return dat_status;
        }
+       return DAT_SUCCESS;
 }

 /*
diff --git a/dapl/common/dapl_evd_util.h b/dapl/common/dapl_evd_util.h
index e5a7c3f..65472d7 100644
--- a/dapl/common/dapl_evd_util.h
+++ b/dapl/common/dapl_evd_util.h
@@ -165,11 +165,14 @@ extern void dapl_evd_qp_async_error_callback (
     IN ib_error_record_t *     cause_ptr,
     IN void *                  context);

-extern void dapls_evd_copy_cq (
+extern DAT_RETURN dapls_evd_copy_cq (
     DAPL_EVD                   *evd_ptr);

 extern DAT_RETURN dapls_evd_cq_poll_to_event (
     IN DAPL_EVD                *evd_ptr,
     OUT DAT_EVENT              *event);

+extern void dapls_evd_post_overflow_event (
+    IN DAPL_EVD                        *evd_ptr);
+
 #endif
diff --git a/dapl/include/dapl.h b/dapl/include/dapl.h
index 8dab61e..a522f15 100755
--- a/dapl/include/dapl.h
+++ b/dapl/include/dapl.h
@@ -349,9 +349,6 @@ struct dapl_evd
     DAT_BOOLEAN                evd_enabled; /* For attached CNO.  */
     DAT_BOOLEAN                evd_waitable; /* EVD state.  */

-    /* Derived from evd_flags; see dapls_evd_internal_create.  */
-    DAT_BOOLEAN                evd_producer_locking_needed;
-
     /* Every EVD has a CQ unless it is a SOFTWARE_EVENT only EVD */
     ib_cq_handle_t     ib_cq_handle;

diff --git a/dapl/udapl/dapl_evd_set_unwaitable.c b/dapl/udapl/dapl_evd_set_unwaitable.c
index 718e433..36b632a 100644
--- a/dapl/udapl/dapl_evd_set_unwaitable.c
+++ b/dapl/udapl/dapl_evd_set_unwaitable.c
@@ -71,7 +71,6 @@ DAT_RETURN DAT_API dapl_evd_set_unwaitable(IN DAT_EVD_HANDLE evd_handle)
        }
        dapl_os_lock(&evd_ptr->header.lock);
        evd_ptr->evd_waitable = DAT_FALSE;
-       dapl_os_unlock(&evd_ptr->header.lock);

        /*
         * If this evd is waiting, wake it up. There is an obvious race
@@ -85,6 +84,7 @@ DAT_RETURN DAT_API dapl_evd_set_unwaitable(IN DAT_EVD_HANDLE evd_handle)
                else
                        dapl_os_wait_object_wakeup(&evd_ptr->wait_object);
        }
+       dapl_os_unlock(&evd_ptr->header.lock);
       bail:
        return dat_status;
 }
diff --git a/dapl/udapl/dapl_evd_wait.c b/dapl/udapl/dapl_evd_wait.c
index 79afb0d..33cec50 100644
--- a/dapl/udapl/dapl_evd_wait.c
+++ b/dapl/udapl/dapl_evd_wait.c
@@ -168,14 +168,12 @@ DAT_RETURN DAT_API dapl_evd_wait(IN DAT_EVD_HANDLE evd_handle,
                 * return right away if the ib_cq_handle associate with these evd
                 * equal to IB_INVALID_HANDLE
                 */
-               dapl_os_unlock(&evd_ptr->header.lock);
-               dapls_evd_copy_cq(evd_ptr);
-               dapl_os_lock(&evd_ptr->header.lock);
+               dat_status = dapls_evd_copy_cq(evd_ptr);
+               if (dat_status == DAT_QUEUE_FULL)
+                       goto bail;

-               if (dapls_rbuf_count(&evd_ptr->pending_event_queue) >=
-                   threshold) {
+               if (dapls_rbuf_count(&evd_ptr->pending_event_queue) >= threshold)
                        break;
-               }

                /*
                 * Do not enable the completion notification if this evd is not
@@ -266,6 +264,8 @@ DAT_RETURN DAT_API dapl_evd_wait(IN DAT_EVD_HANDLE evd_handle,
        if (dat_status) {
                dapl_dbg_log(DAPL_DBG_TYPE_RTN,
                             "dapl_evd_wait () returns 0x%x\n", dat_status);
+               if (dat_status == DAT_QUEUE_FULL)
+                       dapls_evd_post_overflow_event(evd_ptr);
        }
        return dat_status;
 }
--
1.5.2.5



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
