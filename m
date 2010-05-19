From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH 01/12] dapl-2.0: common: add CM-EP linking to support
 mutiple CM's and better protection during destruction
Date: Wed, 19 May 2010 11:00:29 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013030@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ofw_list <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Patch set to add CM to EP linking for better serialization, includes bug fixing as tested.

1/12 common: add CM-EP linking to support mutiple CM's and better protection during destruction
2/12 common: missed linking changes from atomic to acquire/release
3/12 scm, cma, ucm: consolidate dat event/provider event translation
4/12 scm: add support for canceling conn request that times out.
5/12 ibal: changes for EP to CM linking and synchronization.
6/12 ucm: fix error path during accept_usr reply failure
7/12 common: dat_ep_connect should not set timer UD endpoints
8/12 scm: new cm_ep linking broke UD mode over socket cm
9/12 scm: add EP locking and cm checking to socket cm disconnect
10/12 ucm: fix issues with new EP to CM linking changes
11/12 ucm: set timer during RTU_PENDING state change.
12/12 common: EP links to EVD, PZ incorrectly released before provider CM objects freed.

Tested on OFED Linux and Windows.

Add linking for CM to EP, including reference counting, to insure syncronization
during creation and destruction. A cm_list_head has been added to the EP object to
support multiple CM objects (UD) per EP. If the CM object is linked to an EP it
cannot be destroyed.

Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 dapl/common/dapl_cr_callback.c          |    4 +-
 dapl/common/dapl_ep_free.c              |   15 +
 dapl/common/dapl_ep_util.c              |   42 +++-
 dapl/common/dapl_ep_util.h              |   18 ++
 dapl/common/dapl_evd_connection_callb.c |    1 -
 dapl/common/dapl_evd_util.c             |    2 +-
 dapl/include/dapl.h                     |    5 +-
 dapl/openib_cma/cm.c                    |  193 +++++++------
 dapl/openib_cma/dapl_ib_util.h          |   11 +-
 dapl/openib_common/dapl_ib_common.h     |   12 +-
 dapl/openib_common/qp.c                 |   59 +++--
 dapl/openib_scm/cm.c                    |  461 ++++++++++++++-----------------
 dapl/openib_scm/dapl_ib_util.h          |   14 +-
 dapl/openib_ucm/cm.c                    |  381 ++++++++++++--------------
 dapl/openib_ucm/dapl_ib_util.h          |   11 +-
 15 files changed, 641 insertions(+), 588 deletions(-)

diff --git a/dapl/common/dapl_cr_callback.c b/dapl/common/dapl_cr_callback.c
index 55b5841..3997b38 100644
--- a/dapl/common/dapl_cr_callback.c
+++ b/dapl/common/dapl_cr_callback.c
@@ -206,7 +206,6 @@ void dapls_cr_callback(IN dp_ib_cm_handle_t ib_cm_handle, IN const ib_cm_events_
                        }

                        ep_ptr->param.ep_state = DAT_EP_STATE_CONNECTED;
-                       ep_ptr->cm_handle = ib_cm_handle;
                        dapl_os_unlock(&ep_ptr->header.lock);

                        break;
@@ -243,7 +242,6 @@ void dapls_cr_callback(IN dp_ib_cm_handle_t ib_cm_handle, IN const ib_cm_events_
                         */
                        dapl_os_lock(&ep_ptr->header.lock);
                        ep_ptr->param.ep_state = DAT_EP_STATE_DISCONNECTED;
-                       ep_ptr->cm_handle = IB_INVALID_HANDLE;
                        dapls_ib_disconnect_clean(ep_ptr, DAT_FALSE,
                                                  ib_cm_event);
                        dapl_os_unlock(&ep_ptr->header.lock);
@@ -396,7 +394,7 @@ dapli_connection_request(IN dp_ib_cm_handle_t ib_cm_handle,
                        ep_ptr->param.ep_state =
                            DAT_EP_STATE_PASSIVE_CONNECTION_PENDING;
                }
-               ep_ptr->cm_handle = ib_cm_handle;
+               dapl_ep_link_cm(ep_ptr, ib_cm_handle);
        }

        /* link the CR onto the SP so we can pick it up later */
diff --git a/dapl/common/dapl_ep_free.c b/dapl/common/dapl_ep_free.c
index fd9fcc7..8708e6f 100644
--- a/dapl/common/dapl_ep_free.c
+++ b/dapl/common/dapl_ep_free.c
@@ -66,6 +66,7 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
        DAPL_EP *ep_ptr;
        DAPL_IA *ia_ptr;
        DAT_EP_PARAM *param;
+       dp_ib_cm_handle_t cm_ptr, next_cm_ptr;
        ib_qp_state_t save_qp_state;
        DAT_RETURN dat_status = DAT_SUCCESS;

@@ -187,6 +188,20 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
                }
        }

+       /* Free all CM objects */
+       cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
+                 ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
+       while (cm_ptr != NULL) {
+                dapl_log(DAPL_DBG_TYPE_EP,
+                        "dapl_ep_free: Free CM: EP=%p CM=%p\n",
+                        ep_ptr, cm_ptr);
+
+               next_cm_ptr = dapl_llist_next_entry(&ep_ptr->cm_list_head,
+                                                   &cm_ptr->list_entry);
+               dapls_cm_free(cm_ptr); /* blocking call */
+               cm_ptr = next_cm_ptr;
+       }
+
        /* Free the resource */
        dapl_ep_dealloc(ep_ptr);

diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index 505a9f2..bd7cdd9 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -141,6 +141,7 @@ DAPL_EP *dapl_ep_alloc(IN DAPL_IA * ia_ptr, IN const DAT_EP_ATTR * ep_attr)
        ep_ptr->header.user_context.as_ptr = NULL;

        dapl_llist_init_entry(&ep_ptr->header.ia_list_entry);
+       dapl_llist_init_head(&ep_ptr->cm_list_head);
        dapl_os_lock_init(&ep_ptr->header.lock);

        /*
@@ -161,7 +162,6 @@ DAPL_EP *dapl_ep_alloc(IN DAPL_IA * ia_ptr, IN const DAT_EP_ATTR * ep_attr)
        ep_ptr->qp_handle = IB_INVALID_HANDLE;
        ep_ptr->qpn = 0;
        ep_ptr->qp_state = DAPL_QP_STATE_UNATTACHED;
-       ep_ptr->cm_handle = IB_INVALID_HANDLE;

        if (DAT_SUCCESS != dapls_cb_create(&ep_ptr->req_buffer,
                                           ep_ptr,
@@ -537,6 +537,7 @@ dapl_ep_legacy_post_disconnect(DAPL_EP * ep_ptr,
 {
        ib_cm_events_t ib_cm_event;
        DAPL_CR *cr_ptr;
+       dp_ib_cm_handle_t cm_ptr;

        /*
         * Acquire the lock and make sure we didn't get a callback
@@ -557,6 +558,8 @@ dapl_ep_legacy_post_disconnect(DAPL_EP * ep_ptr,
                    dapls_ib_get_cm_event(DAT_CONNECTION_EVENT_DISCONNECTED);

                cr_ptr = ep_ptr->cr_ptr;
+               cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
+                         ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
                dapl_os_unlock(&ep_ptr->header.lock);

                if (cr_ptr != NULL) {
@@ -567,7 +570,7 @@ dapl_ep_legacy_post_disconnect(DAPL_EP * ep_ptr,
                        dapls_cr_callback(cr_ptr->ib_cm_handle,
                                          ib_cm_event, NULL, 0, cr_ptr->sp_ptr);
                } else {
-                       dapl_evd_connection_callback(ep_ptr->cm_handle,
+                       dapl_evd_connection_callback(cm_ptr,
                                                     ib_cm_event,
                                                     NULL, 0, (void *)ep_ptr);
                }
@@ -577,6 +580,41 @@ dapl_ep_legacy_post_disconnect(DAPL_EP * ep_ptr,
 }

 /*
+ * dapl_ep_link_cm
+ *
+ * Add linking of provider's CM object to a EP structure
+ * This enables multiple CM's per EP, and syncronization
+ *
+ * Input:
+ *     DAPL_EP *ep_ptr
+ *     dp_ib_cm_handle_t *cm_ptr  defined in provider's dapl_util.h
+ *
+ *     CM objects linked with EP using  ->list_entry
+ *      CM objects sync'ed with EP using ->ref_count
+ * Output:
+ *     none
+ *
+ * Returns:
+ *     none
+ *
+ */
+void dapl_ep_link_cm(IN DAPL_EP *ep_ptr, IN dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_lock(&ep_ptr->header.lock);
+       dapl_os_atomic_inc(&cm_ptr->ref_count);
+       dapl_llist_add_tail(&ep_ptr->cm_list_head, &cm_ptr->list_entry, cm_ptr);
+       dapl_os_unlock(&ep_ptr->header.lock);
+}
+
+void dapl_ep_unlink_cm(IN DAPL_EP *ep_ptr, IN dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_lock(&ep_ptr->header.lock);
+       dapl_llist_remove_entry(&ep_ptr->cm_list_head, &cm_ptr->list_entry);
+       dapl_os_atomic_dec(&cm_ptr->ref_count);
+       dapl_os_unlock(&ep_ptr->header.lock);
+}
+
+/*
  * Local variables:
  *  c-indent-level: 4
  *  c-basic-offset: 4
diff --git a/dapl/common/dapl_ep_util.h b/dapl/common/dapl_ep_util.h
index 7ac4061..31d0e23 100644
--- a/dapl/common/dapl_ep_util.h
+++ b/dapl/common/dapl_ep_util.h
@@ -83,5 +83,23 @@ dapl_ep_legacy_post_disconnect(
     DAT_CLOSE_FLAGS    disconnect_flags);

 extern char *dapl_get_ep_state_str(DAT_EP_STATE state);
+
+extern void dapl_ep_link_cm(IN DAPL_EP *ep_ptr,
+                           IN dp_ib_cm_handle_t cm_ptr);
+
+extern void dapl_ep_unlink_cm(IN DAPL_EP *ep_ptr,
+                             IN dp_ib_cm_handle_t cm_ptr);
+
+STATIC _INLINE_ dp_ib_cm_handle_t dapl_get_cm_from_ep(IN DAPL_EP *ep_ptr)
+{
+       dp_ib_cm_handle_t cm_ptr;
+
+       dapl_os_lock(&ep_ptr->header.lock);
+       cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
+                 ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
+       dapl_os_unlock(&ep_ptr->header.lock);
+
+       return cm_ptr;
+}

 #endif /*  _DAPL_EP_UTIL_H_ */
diff --git a/dapl/common/dapl_evd_connection_callb.c b/dapl/common/dapl_evd_connection_callb.c
index 8881362..3166702 100644
--- a/dapl/common/dapl_evd_connection_callb.c
+++ b/dapl/common/dapl_evd_connection_callb.c
@@ -130,7 +130,6 @@ dapl_evd_connection_callback(IN dp_ib_cm_handle_t ib_cm_handle,
                                break;
                        }
                        ep_ptr->param.ep_state = DAT_EP_STATE_CONNECTED;
-                       ep_ptr->cm_handle = ib_cm_handle;

                        if (private_data_size > 0) {
                                /* copy in the private data */
diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index cc0aa17..14a10c7 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -1077,7 +1077,7 @@ dapls_evd_post_cr_event_ext(IN DAPL_SP * sp_ptr,
                        ep_ptr->param.ep_state =
                            DAT_EP_STATE_PASSIVE_CONNECTION_PENDING;
                }
-               ep_ptr->cm_handle = ib_cm_handle;
+               dapl_ep_link_cm(ep_ptr, ib_cm_handle);
        }

        /* link the CR onto the SP so we can pick it up later */
diff --git a/dapl/include/dapl.h b/dapl/include/dapl.h
index a36b110..208113b 100755
--- a/dapl/include/dapl.h
+++ b/dapl/include/dapl.h
@@ -438,7 +438,10 @@ struct dapl_ep
     ib_qp_state_t              qp_state;

     /* communications manager handle (IBM OS API) */
-    dp_ib_cm_handle_t          cm_handle;
+   // dp_ib_cm_handle_t                cm_handle;
+
+    /* Add support for multiple CM object ownership */
+    DAPL_LLIST_HEAD            cm_list_head;

     /* store the remote IA address here, reference from the param
      * struct which only has a pointer, no storage
diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index cfa6ede..a85e6ae 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -45,6 +45,7 @@
 #include "dapl_cr_util.h"
 #include "dapl_name_service.h"
 #include "dapl_ib_util.h"
+#include "dapl_ep_util.h"
 #include "dapl_vendor.h"
 #include "dapl_osd.h"

@@ -163,14 +164,14 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)

        dapl_os_memzero(conn, sizeof(*conn));
        dapl_os_lock_init(&conn->lock);
-       conn->refs++;
+       dapls_cm_acquire(conn);

        /* create CM_ID, bind to local device, create QP */
        if (rdma_create_id(g_cm_events, &cm_id, (void *)conn, RDMA_PS_TCP)) {
-               dapl_os_lock_destroy(&conn->lock);
-               dapl_os_free(conn, sizeof(*conn));
+               dapls_cm_release(conn);
                return NULL;
        }
+
        conn->cm_id = cm_id;

        /* setup timers for address and route resolution */
@@ -183,6 +184,7 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
        conn->route_retries = dapl_os_get_env_val("DAPL_CM_ROUTE_RETRY_COUNT",
                                                  IB_ROUTE_RETRY_COUNT);
        if (ep != NULL) {
+               dapl_ep_link_cm(ep, conn);
                conn->ep = ep;
                conn->hca = ((DAPL_IA *)ep->param.ia_handle)->hca_ptr;
        }
@@ -190,40 +192,65 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
        return conn;
 }

-/*
- * Only called from consumer thread via dat_ep_free()
- * accept, reject, or connect.
- * Cannot be called from callback thread.
- * rdma_destroy_id will block until rdma_get_cm_event is acked.
- */
-void dapls_ib_cm_free(dp_ib_cm_handle_t conn, DAPL_EP *ep)
-{
-       dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " destroy_conn: conn %p id %d\n",
-                    conn, conn->cm_id);
+static void dapli_cm_dealloc(dp_ib_cm_handle_t conn) {
+
+       dapl_os_assert(!conn->ref_count);
+       dapl_os_lock_destroy(&conn->lock);
+       dapl_os_free(conn, sizeof(*conn));
+}

+void dapls_cm_acquire(dp_ib_cm_handle_t conn)
+{
        dapl_os_lock(&conn->lock);
-       conn->refs--;
+       conn->ref_count++;
        dapl_os_unlock(&conn->lock);
+}

-       /* block until event thread complete */
-       while (conn->refs)
-               dapl_os_sleep_usec(10000);
+void dapls_cm_release(dp_ib_cm_handle_t conn)
+{
+       dapl_os_lock(&conn->lock);
+       conn->ref_count--;
+       if (conn->ref_count) {
+                dapl_os_unlock(&conn->lock);
+               return;
+       }
+       if (conn->cm_id) {
+               if (conn->cm_id->qp)
+                       rdma_destroy_qp(conn->cm_id);
+               rdma_destroy_id(conn->cm_id);
+       }
+       dapl_os_unlock(&conn->lock);
+       dapli_cm_dealloc(conn);
+}
+
+/* BLOCKING: called from dapl_ep_free, EP link will be last ref */
+void dapls_cm_free(dp_ib_cm_handle_t conn)
+{
+       dapl_log(DAPL_DBG_TYPE_CM,
+                " cm_free: cm %p ep %p refs=%d\n",
+                conn, conn->ep, conn->ref_count);

-       if (ep) {
-               ep->cm_handle = NULL;
-               ep->qp_handle = NULL;
-               ep->qp_state = IB_QP_STATE_ERROR;
-       }
+       dapls_cm_release(conn); /* release alloc ref */

+       /* Destroy cm_id, wait until EP is last ref */
+       dapl_os_lock(&conn->lock);
        if (conn->cm_id) {
                if (conn->cm_id->qp)
                        rdma_destroy_qp(conn->cm_id);
                rdma_destroy_id(conn->cm_id);
+               conn->cm_id = NULL;
        }

-       dapl_os_lock_destroy(&conn->lock);
-       dapl_os_free(conn, sizeof(*conn));
+       /* EP linking is last reference */
+       while (conn->ref_count != 1) {
+               dapl_os_unlock(&conn->lock);
+               dapl_os_sleep_usec(10000);
+               dapl_os_lock(&conn->lock);
+       }
+       dapl_os_unlock(&conn->lock);
+
+       /* unlink, dequeue from EP. Final ref so release will destroy */
+       dapl_ep_unlink_cm(conn->ep, conn);
 }

 static struct dapl_cm_id *dapli_req_recv(struct dapl_cm_id *conn,
@@ -245,11 +272,11 @@ static struct dapl_cm_id *dapli_req_recv(struct dapl_cm_id *conn,
        if (new_conn) {
                (void)dapl_os_memzero(new_conn, sizeof(*new_conn));
                dapl_os_lock_init(&new_conn->lock);
+               dapls_cm_acquire(new_conn);
                new_conn->cm_id = event->id;    /* provided by uCMA */
                event->id->context = new_conn;  /* update CM_ID context */
                new_conn->sp = conn->sp;
                new_conn->hca = conn->hca;
-               new_conn->refs++;

                /* Get requesters connect data, setup for accept */
                new_conn->params.responder_resources =
@@ -532,13 +559,11 @@ DAT_RETURN dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
                            IN DAT_COUNT p_size, IN void *p_data)
 {
        struct dapl_ep *ep_ptr = ep_handle;
-       struct dapl_cm_id *conn = ep_ptr->cm_handle;
+       struct dapl_cm_id *conn = dapl_get_cm_from_ep(ep_ptr);
        int ret;
-
-       /* Sanity check */
-       if (NULL == ep_ptr)
-               return DAT_SUCCESS;
-
+
+       dapl_os_assert(conn != NULL);
+
        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " connect: rSID 0x%llx rPort %d, pdata %p, ln %d\n",
                     r_qual, ntohs(SID_TO_PORT(r_qual)), p_data, p_size);
@@ -547,8 +572,8 @@ DAT_RETURN dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,

        /* Setup QP/CM parameters and private data in cm_id */
        (void)dapl_os_memzero(&conn->params, sizeof(conn->params));
-       conn->params.responder_resources =
-           ep_ptr->param.ep_attr.max_rdma_read_in;
+       conn->params.responder_resources =
+               ep_ptr->param.ep_attr.max_rdma_read_in;
        conn->params.initiator_depth = ep_ptr->param.ep_attr.max_rdma_read_out;
        conn->params.flow_control = 1;
        conn->params.rnr_retry_count = IB_RNR_RETRY_COUNT;
@@ -573,7 +598,7 @@ DAT_RETURN dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
                dapl_log(DAPL_DBG_TYPE_ERR,
                         " dapl_cma_connect: rdma_resolve_addr ERR 0x%x %s\n",
                         ret, strerror(errno));
-               return dapl_convert_errno(errno, "ib_connect");
+               return dapl_convert_errno(errno, "rdma_resolve_addr");
        }
        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " connect: resolve_addr: cm_id %p -> %s port %d\n",
@@ -603,13 +628,13 @@ DAT_RETURN dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 DAT_RETURN
 dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 {
-       dp_ib_cm_handle_t conn = ep_ptr->cm_handle;
+       struct dapl_cm_id *conn = dapl_get_cm_from_ep(ep_ptr);

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " disconnect(ep %p, conn %p, id %d flags %x)\n",
                     ep_ptr, conn, (conn ? conn->cm_id : 0), close_flags);

-       if ((conn == IB_INVALID_HANDLE) || (conn->cm_id == NULL))
+       if ((conn == NULL) || (conn->cm_id == NULL))
                return DAT_SUCCESS;

        /* no graceful half-pipe disconnect option */
@@ -646,7 +671,6 @@ dapls_ib_disconnect_clean(IN DAPL_EP * ep_ptr,
                          IN const ib_cm_events_t ib_cm_event)
 {
        /* nothing to do */
-       return;
 }

 /*
@@ -683,14 +707,13 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,

        dapl_os_memzero(conn, sizeof(*conn));
        dapl_os_lock_init(&conn->lock);
-       conn->refs++;
+       dapls_cm_acquire(conn);

        /* create CM_ID, bind to local device, create QP */
        if (rdma_create_id
            (g_cm_events, &conn->cm_id, (void *)conn, RDMA_PS_TCP)) {
-               dapl_os_lock_destroy(&conn->lock);
-               dapl_os_free(conn, sizeof(*conn));
-               return (dapl_convert_errno(errno, "setup_listener"));
+               dapls_cm_release(conn);
+               return (dapl_convert_errno(errno, "rdma_create_id"));
        }

        /* open identifies the local device; per DAT specification */
@@ -704,7 +727,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
                        dat_status = DAT_CONN_QUAL_IN_USE;
                else
                        dat_status =
-                           dapl_convert_errno(errno, "setup_listener");
+                           dapl_convert_errno(errno, "rdma_bind_addr");
                goto bail;
        }

@@ -728,17 +751,15 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
                        dat_status = DAT_CONN_QUAL_IN_USE;
                else
                        dat_status =
-                           dapl_convert_errno(errno, "setup_listener");
+                           dapl_convert_errno(errno, "rdma_listen");
                goto bail;
        }

        /* success */
        return DAT_SUCCESS;

-      bail:
-       rdma_destroy_id(conn->cm_id);
-       dapl_os_lock_destroy(&conn->lock);
-       dapl_os_free(conn, sizeof(*conn));
+bail:
+       dapls_cm_release(conn);
        return dat_status;
 }

@@ -765,12 +786,12 @@ dapls_ib_remove_conn_listener(IN DAPL_IA * ia_ptr, IN DAPL_SP * sp_ptr)
        ib_cm_srvc_handle_t conn = sp_ptr->cm_srvc_handle;

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " remove_listen(ia_ptr %p sp_ptr %p cm_ptr %p)\n",
+                    " remove_listen(ia_ptr %p sp_ptr %p conn %p)\n",
                     ia_ptr, sp_ptr, conn);

        if (conn != IB_INVALID_HANDLE) {
                sp_ptr->cm_srvc_handle = NULL;
-               dapls_ib_cm_free(conn, NULL);
+               dapls_cm_release(conn);
        }
        return DAT_SUCCESS;
 }
@@ -804,6 +825,7 @@ dapls_ib_accept_connection(IN DAT_CR_HANDLE cr_handle,
        DAPL_EP *ep_ptr = (DAPL_EP *) ep_handle;
        DAPL_IA *ia_ptr = ep_ptr->header.owner_ia;
        struct dapl_cm_id *cr_conn = cr_ptr->ib_cm_handle;
+       struct dapl_cm_id *ep_conn = dapl_get_cm_from_ep(ep_ptr);
        int ret;
        DAT_RETURN dat_status;

@@ -838,18 +860,26 @@ dapls_ib_accept_connection(IN DAT_CR_HANDLE cr_handle,
         * a local device (cm_id and QP) when created. Move the QP
         * to the new cm_id only if device and port numbers match.
         */
-       if (ep_ptr->cm_handle->cm_id->verbs == cr_conn->cm_id->verbs &&
-           ep_ptr->cm_handle->cm_id->port_num == cr_conn->cm_id->port_num) {
+       if (ep_conn->cm_id->verbs == cr_conn->cm_id->verbs &&
+           ep_conn->cm_id->port_num == cr_conn->cm_id->port_num) {
                /* move QP to new cr_conn, remove QP ref in EP cm_id */
-               cr_conn->cm_id->qp = ep_ptr->cm_handle->cm_id->qp;
-               ep_ptr->cm_handle->cm_id->qp = NULL;
-               dapls_ib_cm_free(ep_ptr->cm_handle, NULL);
+               cr_conn->cm_id->qp = ep_conn->cm_id->qp;
+
+               /* remove old CM to EP linking, destroy CM object */
+               dapl_ep_unlink_cm(ep_ptr, ep_conn);
+               ep_conn->cm_id->qp = NULL;
+               ep_conn->ep = NULL;
+               dapls_cm_release(ep_conn);
+
+               /* add new CM to EP linking, qp_handle unchanged */
+               dapl_ep_link_cm(ep_ptr, cr_conn);
+               cr_conn->ep = ep_ptr;
        } else {
                dapl_log(DAPL_DBG_TYPE_ERR,
                         " dapl_cma_accept: ERR dev(%p!=%p) or"
                         " port mismatch(%d!=%d)\n",
-                        ep_ptr->cm_handle->cm_id->verbs, cr_conn->cm_id->verbs,
-                        ntohs(ep_ptr->cm_handle->cm_id->port_num),
+                        ep_conn->cm_id->verbs, cr_conn->cm_id->verbs,
+                        ntohs(ep_conn->cm_id->port_num),
                         ntohs(cr_conn->cm_id->port_num));
                dat_status = DAT_INTERNAL_ERROR;
                goto bail;
@@ -861,16 +891,15 @@ dapls_ib_accept_connection(IN DAT_CR_HANDLE cr_handle,

        ret = rdma_accept(cr_conn->cm_id, &cr_conn->params);
        if (ret) {
-               dapl_log(DAPL_DBG_TYPE_ERR, " dapl_cma_accept: ERR %d %s\n",
+               dapl_log(DAPL_DBG_TYPE_ERR, " dapl_rdma_accept: ERR %d %s\n",
                         ret, strerror(errno));
-               dat_status = dapl_convert_errno(ret, "accept");
+               dat_status = dapl_convert_errno(errno, "accept");
+
+               /* remove new cr_conn EP to CM linking */
+               dapl_ep_unlink_cm(ep_ptr, cr_conn);
                goto bail;
        }

-       /* save accepted conn and EP reference, qp_handle unchanged */
-       ep_ptr->cm_handle = cr_conn;
-       cr_conn->ep = ep_ptr;
-
        /* setup local and remote ports for ep query */
        /* Note: port qual in network order */
        ep_ptr->param.remote_port_qual =
@@ -879,9 +908,11 @@ dapls_ib_accept_connection(IN DAT_CR_HANDLE cr_handle,
            PORT_TO_SID(rdma_get_src_port(cr_conn->cm_id));

        return DAT_SUCCESS;
-      bail:
+bail:
        rdma_reject(cr_conn->cm_id, NULL, 0);
-       dapls_ib_cm_free(cr_conn, NULL);
+
+       /* no EP linking, ok to destroy */
+       dapls_cm_release(cr_conn);
        return dat_status;
 }

@@ -942,7 +973,8 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm_handle,
        ret = rdma_reject(cm_handle->cm_id,
                          cm_handle->p_data, offset + private_data_size);

-       dapls_ib_cm_free(cm_handle, NULL);
+       /* no EP linking, ok to destroy */
+       dapls_cm_release(cm_handle);
        return dapl_convert_errno(ret, "reject");
 }

@@ -966,7 +998,7 @@ DAT_RETURN
 dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle, OUT DAT_SOCK_ADDR6 * raddr)
 {
        DAPL_HEADER *header;
-       dp_ib_cm_handle_t ib_cm_handle;
+       dp_ib_cm_handle_t conn;
        struct rdma_addr *ipaddr;

        dapl_dbg_log(DAPL_DBG_TYPE_EP,
@@ -975,19 +1007,19 @@ dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle, OUT DAT_SOCK_ADDR6 * raddr)

        header = (DAPL_HEADER *) dat_handle;

-       if (header->magic == DAPL_MAGIC_EP)
-               ib_cm_handle = ((DAPL_EP *) dat_handle)->cm_handle;
+       if (header->magic == DAPL_MAGIC_EP)
+               conn = dapl_get_cm_from_ep((DAPL_EP *) dat_handle);
        else if (header->magic == DAPL_MAGIC_CR)
-               ib_cm_handle = ((DAPL_CR *) dat_handle)->ib_cm_handle;
+               conn = ((DAPL_CR *) dat_handle)->ib_cm_handle;
        else
                return DAT_INVALID_HANDLE;

        /* get remote IP address from cm_id route */
-       ipaddr = &ib_cm_handle->cm_id->route.addr;
+       ipaddr = &conn->cm_id->route.addr;

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " remote_addr: conn %p id %p SRC %x DST %x PORT %d\n",
-                    ib_cm_handle, ib_cm_handle->cm_id,
+                    conn, conn->cm_id,
                     ntohl(((struct sockaddr_in *)
                            &ipaddr->src_addr)->sin_addr.s_addr),
                     ntohl(((struct sockaddr_in *)
@@ -1141,20 +1173,12 @@ void dapli_cma_event_cb(void)
                else
                        conn = (struct dapl_cm_id *)event->id->context;

+               dapls_cm_acquire(conn);
+
                dapl_dbg_log(DAPL_DBG_TYPE_CM,
                             " cm_event: EVENT=%d ID=%p LID=%p CTX=%p\n",
                             event->event, event->id, event->listen_id, conn);

-               /* cm_free is blocked waiting for ack  */
-               dapl_os_lock(&conn->lock);
-               if (!conn->refs) {
-                       dapl_os_unlock(&conn->lock);
-                       rdma_ack_cm_event(event);
-                       return;
-               }
-               conn->refs++;
-               dapl_os_unlock(&conn->lock);
-
                switch (event->event) {
                case RDMA_CM_EVENT_ADDR_RESOLVED:
                        dapli_addr_resolve(conn);
@@ -1268,10 +1292,7 @@ void dapli_cma_event_cb(void)

                /* ack event, unblocks destroy_cm_id in consumer threads */
                rdma_ack_cm_event(event);
-
-               dapl_os_lock(&conn->lock);
-                conn->refs--;
-               dapl_os_unlock(&conn->lock);
+                dapls_cm_release(conn);
        }
 }

diff --git a/dapl/openib_cma/dapl_ib_util.h b/dapl/openib_cma/dapl_ib_util.h
index fd4e582..96061b3 100755
--- a/dapl/openib_cma/dapl_ib_util.h
+++ b/dapl/openib_cma/dapl_ib_util.h
@@ -55,14 +55,17 @@
 #define        IB_MAX_DREP_PDATA_SIZE  DAPL_MIN((224-CMA_PDATA_HDR),RDMA_MAX_PRIVATE_DATA)
 #define        IWARP_MAX_PDATA_SIZE    DAPL_MIN((512-CMA_PDATA_HDR),RDMA_MAX_PRIVATE_DATA)

+/* DAPL CM objects MUST include list_entry, ref_count, event for EP linking */
 struct dapl_cm_id {
+       struct dapl_llist_entry         list_entry;
+       struct dapl_llist_entry         local_entry;
+       DAPL_OS_WAIT_OBJECT             event;
        DAPL_OS_LOCK                    lock;
-       int                             refs;
+       int                             ref_count;
        int                             arp_retries;
        int                             arp_timeout;
        int                             route_retries;
        int                             route_timeout;
-       int                             in_callback;
        struct rdma_cm_id               *cm_id;
        struct dapl_hca                 *hca;
        struct dapl_sp                  *sp;
@@ -121,7 +124,9 @@ void dapli_cma_event_cb(void);
 void dapli_async_event_cb(struct _ib_hca_transport *tp);
 void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
-void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
+void dapls_cm_acquire(dp_ib_cm_handle_t cm);
+void dapls_cm_release(dp_ib_cm_handle_t cm);
+void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);

 #ifdef DAPL_COUNTERS
 STATIC _INLINE_ void dapls_print_cm_list(IN DAPL_IA * ia_ptr)
diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 6c66b25..3e32fab 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -279,12 +279,13 @@ typedef enum dapl_cm_state
        DCM_REJECTING,
        DCM_REJECTED,
        DCM_CONNECTED,
-       DCM_RELEASED,
+       DCM_RELEASE,
        DCM_DISC_PENDING,
        DCM_DISCONNECTED,
        DCM_DESTROY,
        DCM_RTU_PENDING,
-       DCM_DISC_RECV
+       DCM_DISC_RECV,
+       DCM_FREE,

 } DAPL_CM_STATE;

@@ -372,14 +373,15 @@ STATIC _INLINE_ char * dapl_cm_state_str(IN int st)
                "CM_REJECTING",
                "CM_REJECTED",
                "CM_CONNECTED",
-               "CM_RELEASED",
+               "CM_RELEASE",
                "CM_DISC_PENDING",
                "CM_DISCONNECTED",
                "CM_DESTROY",
                "CM_RTU_PENDING",
-               "CM_DISC_RECV"
+               "CM_DISC_RECV",
+               "CM_FREE"
         };
-        return ((st < 0 || st > 15) ? "Invalid CM state?" : state[st]);
+        return ((st < 0 || st > 16) ? "Invalid CM state?" : state[st]);
 }

 STATIC _INLINE_ char * dapl_cm_op_str(IN int op)
diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 17eae36..15c1dae 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -24,6 +24,7 @@
  */
 #include "dapl.h"
 #include "dapl_adapter_util.h"
+#include "dapl_ep_util.h"

 /*
  * dapl_ib_qp_alloc
@@ -115,12 +116,14 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 #ifdef _OPENIB_CMA_
        /* Allocate CM and initialize lock */
        if ((conn = dapls_ib_cm_create(ep_ptr)) == NULL)
-               return (dapl_convert_errno(ENOMEM, "create_cq"));
+               return (dapl_convert_errno(ENOMEM, "cm_create"));

        /* open identifies the local device; per DAT specification */
        if (rdma_bind_addr(conn->cm_id,
-                          (struct sockaddr *)&ia_ptr->hca_ptr->hca_address))
-               return (dapl_convert_errno(EAFNOSUPPORT, "create_cq"));
+               (struct sockaddr *)&ia_ptr->hca_ptr->hca_address)) {
+               dapls_cm_free(conn);
+               return (dapl_convert_errno(EAFNOSUPPORT, "rdma_bind_addr"));
+       }
 #endif
        /* Setup attributes and create qp */
        dapl_os_memzero((void *)&qp_create, sizeof(qp_create));
@@ -158,11 +161,10 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,

 #ifdef _OPENIB_CMA_
        if (rdma_create_qp(conn->cm_id, ib_pd_handle, &qp_create)) {
-               dapls_ib_cm_free(conn, ep_ptr);
-               return (dapl_convert_errno(errno, "create_qp"));
+               dapls_cm_free(conn);
+               return (dapl_convert_errno(errno, "rdma_create_qp"));
        }
        ep_ptr->qp_handle = conn->cm_id->qp;
-       ep_ptr->cm_handle = conn;
        ep_ptr->qp_state = IBV_QPS_INIT;

        ep_ptr->param.local_port_qual = rdma_get_src_port(conn->cm_id);
@@ -207,33 +209,30 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
  */
 DAT_RETURN dapls_ib_qp_free(IN DAPL_IA * ia_ptr, IN DAPL_EP * ep_ptr)
 {
-       dapl_dbg_log(DAPL_DBG_TYPE_EP, " qp_free:  ep_ptr %p qp %p\n",
-                    ep_ptr, ep_ptr->qp_handle);
+#ifdef _OPENIB_CMA_
+       dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);

-       if (ep_ptr->cm_handle != NULL) {
-               dapls_ib_cm_free(ep_ptr->cm_handle, ep_ptr);
+       dapl_os_lock(&ep_ptr->header.lock);
+       if (cm_ptr && cm_ptr->cm_id->qp) {
+               rdma_destroy_qp(cm_ptr->cm_id);
+               cm_ptr->cm_id->qp = NULL;
+               ep_ptr->qp_handle = NULL;
        }
-
+#else
+       dapl_os_lock(&ep_ptr->header.lock);
        if (ep_ptr->qp_handle != NULL) {
                /* force error state to flush queue, then destroy */
                dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0,0,0);

-               if (ibv_destroy_qp(ep_ptr->qp_handle))
-                       return (dapl_convert_errno(errno, "destroy_qp"));
-
+               if (ibv_destroy_qp(ep_ptr->qp_handle)) {
+                       dapl_log(DAPL_DBG_TYPE_ERR,
+                                " qp_free: ibv_destroy_qp error - %s\n",
+                                strerror(errno));
+               }
                ep_ptr->qp_handle = NULL;
        }
-
-#ifdef DAT_EXTENSIONS
-       /* UD endpoints can have many CR associations and will not
-        * set ep->cm_handle. Call provider with cm_ptr null to incidate
-        * UD type multi CR's for this EP. It will parse internal list
-        * and cleanup all associations.
-        */
-       if (ep_ptr->param.ep_attr.service_type == DAT_IB_SERVICE_TYPE_UD)
-               dapls_ib_cm_free(NULL, ep_ptr);
 #endif
-
+       dapl_os_unlock(&ep_ptr->header.lock);
        return DAT_SUCCESS;
 }

@@ -329,10 +328,22 @@ dapls_ib_qp_modify(IN DAPL_IA * ia_ptr,
 #if defined(_WIN32) || defined(_WIN64) || defined(_OPENIB_CMA_)
 void dapls_ib_reinit_ep(IN DAPL_EP * ep_ptr)
 {
+       dp_ib_cm_handle_t cm_ptr, next_cm_ptr;
+
        /* work around bug in low level driver - 3/24/09 */
        /* RTS -> RESET -> INIT -> ERROR QP transition crashes system */
        if (ep_ptr->qp_handle != IB_INVALID_HANDLE) {
                dapls_ib_qp_free(ep_ptr->header.owner_ia, ep_ptr);
+
+               /* free any CM object's created */
+               cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
+                         ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
+               while (cm_ptr != NULL) {
+                       next_cm_ptr = dapl_llist_next_entry(&ep_ptr->cm_list_head,
+                                                           &cm_ptr->list_entry);
+                       dapls_cm_free(cm_ptr);
+                       cm_ptr = next_cm_ptr;
+               }
                dapls_ib_qp_alloc(ep_ptr->header.owner_ia, ep_ptr, ep_ptr);
        }
 }
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index e374fb4..39f8417 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -57,6 +57,7 @@
 #include "dapl_cr_util.h"
 #include "dapl_name_service.h"
 #include "dapl_ib_util.h"
+#include "dapl_ep_util.h"
 #include "dapl_osd.h"

 #if defined(_WIN32) || defined(_WIN64)
@@ -154,7 +155,7 @@ static int dapl_select(struct dapl_fd_set *set)
        dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: wakeup\n");

        if (ret == SOCKET_ERROR)
-               dapl_dbg_log(DAPL_DBG_TYPE_CM,
+               dapl_dbg_log(DAPL_DBG_TYPE_THREAD,
                             " dapl_select: error 0x%x\n", WSAGetLastError());

        return ret;
@@ -248,7 +249,7 @@ static enum DAPL_FD_EVENTS dapl_poll(DAPL_SOCKET s, enum DAPL_FD_EVENTS event)
        fds.events = event;
        fds.revents = 0;
        ret = poll(&fds, 1, 0);
-       dapl_log(DAPL_DBG_TYPE_CM, " dapl_poll: fd=%d ret=%d, evnts=0x%x\n",
+       dapl_log(DAPL_DBG_TYPE_THREAD, " dapl_poll: fd=%d ret=%d, evnts=0x%x\n",
                 s, ret, fds.revents);
        if (ret == 0)
                return 0;
@@ -262,16 +263,64 @@ static int dapl_select(struct dapl_fd_set *set)
 {
        int ret;

-       dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: sleep, fds=%d\n", set->index);
+       dapl_dbg_log(DAPL_DBG_TYPE_THREAD, " dapl_select: sleep, fds=%d\n", set->index);
        ret = poll(set->set, set->index, -1);
-       dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: wakeup, ret=0x%x\n", ret);
+       dapl_dbg_log(DAPL_DBG_TYPE_THREAD, " dapl_select: wakeup, ret=0x%x\n", ret);
        return ret;
 }

 #define dapl_socket_errno() errno
 #endif

-dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
+static void dapli_cm_thread_signal(dp_ib_cm_handle_t cm_ptr)
+{
+       send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+}
+
+static void dapli_cm_free(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_lock(&cm_ptr->lock);
+       cm_ptr->state = DCM_FREE;
+       dapl_os_unlock(&cm_ptr->lock);
+       dapli_cm_thread_signal(cm_ptr);
+}
+
+static void dapli_cm_dealloc(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_assert(!cm_ptr->ref_count);
+
+       if (cm_ptr->socket != DAPL_INVALID_SOCKET) {
+               shutdown(cm_ptr->socket, SHUT_RDWR);
+               closesocket(cm_ptr->socket);
+       }
+       if (cm_ptr->ah)
+               ibv_destroy_ah(cm_ptr->ah);
+
+       dapl_os_lock_destroy(&cm_ptr->lock);
+       dapl_os_wait_object_destroy(&cm_ptr->event);
+       dapl_os_free(cm_ptr, sizeof(*cm_ptr));
+}
+
+void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_lock(&cm_ptr->lock);
+       cm_ptr->ref_count++;
+       dapl_os_unlock(&cm_ptr->lock);
+}
+
+void dapls_cm_release(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_lock(&cm_ptr->lock);
+       cm_ptr->ref_count--;
+       if (cm_ptr->ref_count) {
+                dapl_os_unlock(&cm_ptr->lock);
+               return;
+       }
+       dapl_os_unlock(&cm_ptr->lock);
+       dapli_cm_dealloc(cm_ptr);
+}
+
+static dp_ib_cm_handle_t dapli_cm_alloc(DAPL_EP *ep_ptr)
 {
        dp_ib_cm_handle_t cm_ptr;

@@ -283,162 +332,108 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
        if (dapl_os_lock_init(&cm_ptr->lock))
                goto bail;

+       if (dapl_os_wait_object_init(&cm_ptr->event)) {
+               dapl_os_lock_destroy(&cm_ptr->lock);
+               goto bail;
+       }
+       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm_ptr->list_entry);
+       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm_ptr->local_entry);
+
        cm_ptr->msg.ver = htons(DCM_VER);
        cm_ptr->socket = DAPL_INVALID_SOCKET;
-       cm_ptr->ep = ep;
+       dapls_cm_acquire(cm_ptr);
+
+       /* Link EP and CM */
+       if (ep_ptr != NULL) {
+               dapl_ep_link_cm(ep_ptr, cm_ptr); /* ref++ */
+               cm_ptr->ep = ep_ptr;
+               cm_ptr->hca = ((DAPL_IA *)ep_ptr->param.ia_handle)->hca_ptr;
+       }
        return cm_ptr;
 bail:
        dapl_os_free(cm_ptr, sizeof(*cm_ptr));
        return NULL;
 }

-/* mark for destroy, remove all references, schedule cleanup */
-/* cm_ptr == NULL (UD), then multi CR's, kill all associated with EP */
-void dapls_ib_cm_free(dp_ib_cm_handle_t cm_ptr, DAPL_EP *ep)
+/* queue socket for processing CM work */
+static void dapli_cm_queue(dp_ib_cm_handle_t cm_ptr)
 {
-       DAPL_IA *ia_ptr;
-       DAPL_HCA *hca_ptr = NULL;
-       dp_ib_cm_handle_t cr, next_cr;
-
-       dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " cm_destroy: cm %p ep %p\n", cm_ptr, ep);
-
-       if (cm_ptr == NULL)
-               goto multi_cleanup;
+       /* add to work queue for cr thread processing */
+       dapl_os_lock(&cm_ptr->hca->ib_trans.lock);
+       dapls_cm_acquire(cm_ptr);
+       dapl_llist_add_tail(&cm_ptr->hca->ib_trans.list,
+                           (DAPL_LLIST_ENTRY *)&cm_ptr->local_entry, cm_ptr);
+       dapl_os_unlock(&cm_ptr->hca->ib_trans.lock);
+       dapli_cm_thread_signal(cm_ptr);
+}

-       /* to notify cleanup thread */
-       hca_ptr = cm_ptr->hca;
+/* called with local LIST lock */
+static void dapli_cm_dequeue(dp_ib_cm_handle_t cm_ptr)
+{
+       /* Remove from work queue, cr thread processing */
+       dapl_llist_remove_entry(&cm_ptr->hca->ib_trans.list,
+                               (DAPL_LLIST_ENTRY *)&cm_ptr->local_entry);
+       dapls_cm_release(cm_ptr);
+}

-       /* cleanup, never made it to work queue */
+/* BLOCKING: called from dapl_ep_free, EP link will be last ref */
+void dapls_cm_free(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_log(DAPL_DBG_TYPE_CM,
+                " cm_free: cm %p %s ep %p refs=%d\n",
+                cm_ptr, dapl_cm_state_str(cm_ptr->state),
+                cm_ptr->ep, cm_ptr->ref_count);
+
+       /* free from internal workq, wait until EP is last ref */
        dapl_os_lock(&cm_ptr->lock);
-       if (cm_ptr->state == DCM_INIT) {
-               if (cm_ptr->socket != DAPL_INVALID_SOCKET) {
-                       shutdown(cm_ptr->socket, SHUT_RDWR);
-                       closesocket(cm_ptr->socket);
-               }
+       cm_ptr->state = DCM_FREE;
+       while (cm_ptr->ref_count != 1) {
                dapl_os_unlock(&cm_ptr->lock);
-               dapl_os_lock_destroy(&cm_ptr->lock);
-               dapl_os_free(cm_ptr, sizeof(*cm_ptr));
-               return;
-       }
-
-       /* free could be called before disconnect, disc_clean will destroy */
-       if (cm_ptr->state == DCM_CONNECTED) {
-               dapl_os_unlock(&cm_ptr->lock);
-               dapli_socket_disconnect(cm_ptr);
-               return;
-       }
-
-       cm_ptr->state = DCM_DESTROY;
-       if ((cm_ptr->ep) && (cm_ptr->ep->cm_handle == cm_ptr)) {
-               cm_ptr->ep->cm_handle = IB_INVALID_HANDLE;
-               cm_ptr->ep = NULL;
+               dapl_os_sleep_usec(10000);
+               dapl_os_lock(&cm_ptr->lock);
        }
-
        dapl_os_unlock(&cm_ptr->lock);
-       goto notify_thread;
-
-multi_cleanup:
-
-       /*
-        * UD CR objects are kept active because of direct private data references
-        * from CONN events. The cr->socket is closed and marked inactive but the
-        * object remains allocated and queued on the CR resource list. There can
-        * be multiple CR's associated with a given EP. There is no way to determine
-        * when consumer is finished with event until the dat_ep_free.
-        *
-        * Schedule destruction for all CR's associated with this EP, cr_thread will
-        * complete the cleanup with state == DCM_DESTROY.
-        */
-       ia_ptr = ep->header.owner_ia;
-       dapl_os_lock(&ia_ptr->hca_ptr->ib_trans.lock);
-       if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)
-                                 &ia_ptr->hca_ptr->ib_trans.list))
-            next_cr = dapl_llist_peek_head((DAPL_LLIST_HEAD*)
-                                           &ia_ptr->hca_ptr->ib_trans.list);
-       else
-           next_cr = NULL;
-
-       while (next_cr) {
-               cr = next_cr;
-               next_cr = dapl_llist_next_entry((DAPL_LLIST_HEAD*)
-                                               &ia_ptr->hca_ptr->ib_trans.list,
-                                               (DAPL_LLIST_ENTRY*)&cr->entry);
-               if (cr->ep == ep)  {
-                       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                                    " qp_free CR: ep %p cr %p\n", ep, cr);
-                       dapli_socket_disconnect(cr);
-                       dapl_os_lock(&cr->lock);
-                       hca_ptr = cr->hca;
-                       cr->ep = NULL;
-                       if (cr->ah) {
-                               ibv_destroy_ah(cr->ah);
-                               cr->ah = NULL;
-                       }
-                       cr->state = DCM_DESTROY;
-                       dapl_os_unlock(&cr->lock);
-               }
-       }
-       dapl_os_unlock(&ia_ptr->hca_ptr->ib_trans.lock);

-notify_thread:
-
-       /* wakeup work thread, if something destroyed */
-       if (hca_ptr != NULL)
-               send(hca_ptr->ib_trans.scm[1], "w", sizeof "w", 0);
-}
-
-/* queue socket for processing CM work */
-static void dapli_cm_queue(struct ib_cm_handle *cm_ptr)
-{
-       /* add to work queue for cr thread processing */
-       dapl_llist_init_entry((DAPL_LLIST_ENTRY *) & cm_ptr->entry);
-       dapl_os_lock(&cm_ptr->hca->ib_trans.lock);
-       dapl_llist_add_tail(&cm_ptr->hca->ib_trans.list,
-                           (DAPL_LLIST_ENTRY *) & cm_ptr->entry, cm_ptr);
-       dapl_os_unlock(&cm_ptr->hca->ib_trans.lock);
-
-       /* wakeup CM work thread */
-       send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+       /* unlink, dequeue from EP. Final ref so release will destroy */
+       dapl_ep_unlink_cm(cm_ptr->ep, cm_ptr);
 }

 /*
  * ACTIVE/PASSIVE: called from CR thread or consumer via ep_disconnect
- *                 or from ep_free
+ *                 or from ep_free.
  */
 DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr)
 {
-       DAPL_EP *ep_ptr = cm_ptr->ep;
        DAT_UINT32 disc_data = htonl(0xdead);

-       if (ep_ptr == NULL)
-               return DAT_SUCCESS;
-
        dapl_os_lock(&cm_ptr->lock);
-       if (cm_ptr->state != DCM_CONNECTED) {
+       if (cm_ptr->state != DCM_CONNECTED ||
+           cm_ptr->state == DCM_DISCONNECTED) {
                dapl_os_unlock(&cm_ptr->lock);
                return DAT_SUCCESS;
        }
-
-       /* send disc date, close socket, schedule destroy */
-       dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0,0,0);
        cm_ptr->state = DCM_DISCONNECTED;
-       send(cm_ptr->socket, (char *)&disc_data, sizeof(disc_data), 0);
        dapl_os_unlock(&cm_ptr->lock);
+
+       /* send disc date, close socket, schedule destroy */
+       dapls_modify_qp_state(cm_ptr->ep->qp_handle, IBV_QPS_ERR, 0,0,0);
+       send(cm_ptr->socket, (char *)&disc_data, sizeof(disc_data), 0);

        /* disconnect events for RC's only */
-       if (ep_ptr->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC) {
-               if (ep_ptr->cr_ptr) {
+       if (cm_ptr->ep->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC) {
+               if (cm_ptr->ep->cr_ptr) {
                        dapls_cr_callback(cm_ptr,
                                          IB_CME_DISCONNECTED,
-                                         NULL, 0,
-                                         ((DAPL_CR *) ep_ptr->cr_ptr)->sp_ptr);
+                                         NULL, 0, cm_ptr->sp);
                } else {
-                       dapl_evd_connection_callback(ep_ptr->cm_handle,
+                       dapl_evd_connection_callback(cm_ptr,
                                                     IB_CME_DISCONNECTED,
-                                                    NULL, 0, ep_ptr);
+                                                    NULL, 0, cm_ptr->ep);
                }
        }
+
+       /* release from workq */
+       dapli_cm_free(cm_ptr);

        /* scheduled destroy via disconnect clean in callback */
        return DAT_SUCCESS;
@@ -505,8 +500,8 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
        return;

 bail:
-       /* close socket, free cm structure and post error event */
-       dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
+       /* mark CM object for cleanup */
+       cm_ptr->state = DCM_FREE;
        dapl_evd_connection_callback(NULL, IB_CME_LOCAL_FAILURE, NULL, 0, ep_ptr);
 }

@@ -514,7 +509,7 @@ bail:
  * ACTIVE: Create socket, connect, defer exchange QP information to CR thread
  * to avoid blocking.
  */
-DAT_RETURN
+static DAT_RETURN
 dapli_socket_connect(DAPL_EP * ep_ptr,
                     DAT_IA_ADDRESS_PTR r_addr,
                     DAT_CONN_QUAL r_qual, DAT_COUNT p_size, DAT_PVOID p_data)
@@ -528,7 +523,7 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " connect: r_qual %d p_size=%d\n",
                     r_qual, p_size);

-       cm_ptr = dapls_ib_cm_create(ep_ptr);
+       cm_ptr = dapli_cm_alloc(ep_ptr);
        if (cm_ptr == NULL)
                return dat_ret;

@@ -566,6 +561,7 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        }

        /* REQ: QP info in msg.saddr, IA address in msg.daddr, and pdata */
+       cm_ptr->hca = ia_ptr->hca_ptr;
        cm_ptr->msg.op = ntohs(DCM_REQ);
        cm_ptr->msg.saddr.ib.qpn = htonl(ep_ptr->qp_handle->qp_num);
        cm_ptr->msg.saddr.ib.qp_type = ep_ptr->qp_handle->qp_type;
@@ -573,10 +569,6 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        dapl_os_memcpy(&cm_ptr->msg.saddr.ib.gid[0],
                       &ia_ptr->hca_ptr->ib_trans.gid, 16);

-       /* save references */
-       cm_ptr->hca = ia_ptr->hca_ptr;
-       cm_ptr->ep = ep_ptr;
-
        /* get local address information from socket */
        sl = sizeof(cm_ptr->msg.daddr.so);
        if (getsockname(cm_ptr->socket, (struct sockaddr *)&cm_ptr->msg.daddr.so, &sl)) {
@@ -607,9 +599,9 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
                     (unsigned int)r_qual, ntohs(cm_ptr->msg.p_size),
                     cm_ptr->msg.p_data[0], cm_ptr->msg.p_data[1]);

+       /* queue up on work thread */
        dapli_cm_queue(cm_ptr);
        return DAT_SUCCESS;
-
 bail:
        dapl_log(DAPL_DBG_TYPE_ERR,
                 " connect ERROR: %s -> %s r_qual %d\n",
@@ -617,8 +609,8 @@ bail:
                 inet_ntoa(((struct sockaddr_in *)r_addr)->sin_addr),
                 (unsigned int)r_qual);

-       /* close socket, free cm structure */
-       dapls_ib_cm_free(cm_ptr, NULL);
+       /* Never queued, destroy */
+       dapls_cm_release(cm_ptr);
        return dat_ret;
 }

@@ -653,7 +645,8 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                        dapli_socket_connect(cm_ptr->ep, (DAT_IA_ADDRESS_PTR)&cm_ptr->addr,
                                             ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port) - 1000,
                                             ntohs(cm_ptr->msg.p_size), &cm_ptr->msg.p_data);
-                       dapls_ib_cm_free(cm_ptr, NULL);
+                       dapl_ep_unlink_cm(cm_ptr->ep, cm_ptr);
+                       dapli_cm_free(cm_ptr);
                        return;
                }
                goto bail;
@@ -728,7 +721,6 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
        }

        /* modify QP to RTR and then to RTS with remote info */
-       dapl_os_lock(&ep_ptr->header.lock);
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
                                  IBV_QPS_RTR,
                                  cm_ptr->msg.saddr.ib.qpn,
@@ -744,7 +736,6 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                                    &cm_ptr->msg.daddr.so)->sin_addr),
                         ntohs(((struct sockaddr_in *)
                                 &cm_ptr->msg.daddr.so)->sin_port));
-               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
@@ -762,10 +753,8 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                                    &cm_ptr->msg.daddr.so)->sin_addr),
                         ntohs(((struct sockaddr_in *)
                                 &cm_ptr->msg.daddr.so)->sin_port));
-               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
-       dapl_os_unlock(&ep_ptr->header.lock);
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " connect_rtu: send RTU\n");

        /* complete handshake after final QP state change, Just ver+op */
@@ -817,7 +806,7 @@ ud_bail:
                        event = DAT_IB_UD_CONNECTION_ERROR_EVENT;
                } else
                        event = DAT_IB_UD_CONNECTION_REJECT_EVENT;
-
+
                dapls_evd_post_connection_event_ext(
                                (DAPL_EVD *) ep_ptr->param.connect_evd_handle,
                                event,
@@ -826,14 +815,14 @@ ud_bail:
                                (DAT_PVOID *) cm_ptr->msg.p_data,
                                (DAT_PVOID *) &xevent);

-               /* done with socket, don't destroy cm_ptr, need pdata */
-               closesocket(cm_ptr->socket);
-               cm_ptr->socket = DAPL_INVALID_SOCKET;
-               cm_ptr->state = DCM_RELEASED;
+               /* cleanup and release from local list */
+               dapl_os_lock(&cm_ptr->lock);
+               cm_ptr->state = DCM_FREE;
+               dapl_os_unlock(&cm_ptr->lock);
+
        } else
 #endif
        {
-               ep_ptr->cm_handle = cm_ptr; /* only RC, multi CR's on UD */
                dapl_evd_connection_callback(cm_ptr, event, cm_ptr->msg.p_data,
                                             DCM_MAX_PDATA_SIZE, ep_ptr);
        }
@@ -846,9 +835,9 @@ bail:
                goto ud_bail;
 #endif
        /* close socket, and post error event */
-       dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
+       cm_ptr->state = DCM_REJECTED;
        closesocket(cm_ptr->socket);
-       cm_ptr->socket = DAPL_INVALID_SOCKET;
+        cm_ptr->socket = DAPL_INVALID_SOCKET;
        dapl_evd_connection_callback(NULL, event, cm_ptr->msg.p_data,
                                     DCM_MAX_PDATA_SIZE, ep_ptr);
 }
@@ -862,12 +851,13 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
        struct sockaddr_in addr;
        ib_cm_srvc_handle_t cm_ptr = NULL;
        DAT_RETURN dat_status = DAT_SUCCESS;
+       int opt = 1;

-       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    " listen(ia_ptr %p ServiceID %d sp_ptr %p)\n",
+       dapl_dbg_log(DAPL_DBG_TYPE_CM,
+                    " setup listen(ia_ptr %p ServiceID %d sp_ptr %p)\n",
                     ia_ptr, serviceID, sp_ptr);

-       cm_ptr = dapls_ib_cm_create(NULL);
+       cm_ptr = dapli_cm_alloc(NULL);
        if (cm_ptr == NULL)
                return DAT_INSUFFICIENT_RESOURCES;

@@ -883,15 +873,16 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
                goto bail;
        }

+       setsockopt(cm_ptr->socket, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));
        addr.sin_port = htons(serviceID + 1000);
        addr.sin_family = AF_INET;
        addr.sin_addr = ((struct sockaddr_in *) &ia_ptr->hca_ptr->hca_address)->sin_addr;

        if ((bind(cm_ptr->socket, (struct sockaddr *)&addr, sizeof(addr)) < 0)
            || (listen(cm_ptr->socket, 128) < 0)) {
-               dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                            " listen: ERROR %s on conn_qual 0x%x\n",
-                            strerror(errno), serviceID + 1000);
+               dapl_log(DAPL_DBG_TYPE_CM,
+                        " listen: ERROR %s on port %d\n",
+                        strerror(errno), serviceID + 1000);
                if (dapl_socket_errno() == EADDRINUSE)
                        dat_status = DAT_CONN_QUAL_IN_USE;
                else
@@ -908,14 +899,13 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
        dapli_cm_queue(cm_ptr);

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " listen: qual 0x%x cr %p s_fd %d\n",
-                    ntohs(serviceID + 1000), cm_ptr, cm_ptr->socket);
+                    " setup listen: port %d cr %p s_fd %d\n",
+                    serviceID + 1000, cm_ptr, cm_ptr->socket);

        return dat_status;
 bail:
-       dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " listen: ERROR on conn_qual 0x%x\n", serviceID + 1000);
-       dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
+       /* Never queued, destroy here */
+       dapls_cm_release(cm_ptr);
        return dat_status;
 }

@@ -934,7 +924,7 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
         */
        do {
                /* Allocate accept CM and initialize */
-               if ((acm_ptr = dapls_ib_cm_create(NULL)) == NULL)
+               if ((acm_ptr = dapli_cm_alloc(NULL)) == NULL)
                        return;

                acm_ptr->sp = cm_ptr->sp;
@@ -949,7 +939,7 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
                        dapl_log(DAPL_DBG_TYPE_ERR,
                                " ACCEPT: ERR %s on FD %d l_cr %p\n",
                                strerror(errno), cm_ptr->socket, cm_ptr);
-                       dapls_ib_cm_free(acm_ptr, acm_ptr->ep);
+                       dapls_cm_release(acm_ptr);
                        return;
                }
                dapl_dbg_log(DAPL_DBG_TYPE_CM, " accepting from %s %x\n",
@@ -1050,8 +1040,8 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
                                  p_data, exp, acm_ptr->sp);
        return;
 bail:
-       /* close socket, free cm structure, active will see close as rej */
-       dapls_ib_cm_free(acm_ptr, acm_ptr->ep);
+       /* mark for destroy, active will see socket close as rej */
+       acm_ptr->state = DCM_FREE;
        return;
 }

@@ -1105,7 +1095,6 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 #endif

        /* modify QP to RTR and then to RTS with remote info already read */
-       dapl_os_lock(&ep_ptr->header.lock);
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
                                  IBV_QPS_RTR,
                                  cm_ptr->msg.saddr.ib.qpn,
@@ -1116,7 +1105,6 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                         strerror(errno),
                         inet_ntoa(((struct sockaddr_in *)
                                     &cm_ptr->msg.daddr.so)->sin_addr));
-               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
@@ -1129,10 +1117,8 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                         strerror(errno),
                         inet_ntoa(((struct sockaddr_in *)
                                     &cm_ptr->msg.daddr.so)->sin_addr));
-               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
-       dapl_os_unlock(&ep_ptr->header.lock);

        /* save remote address information */
        dapl_os_memcpy(&ep_ptr->remote_ia_address,
@@ -1157,8 +1143,6 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
        *(uint16_t*)&cm_ptr->msg.resv[2] = htons((uint16_t)dapl_os_getpid());
        dapl_os_memcpy(local.resv, cm_ptr->msg.resv, 4);
 #endif
-
-       cm_ptr->ep = ep_ptr;
        cm_ptr->hca = ia_ptr->hca_ptr;
        cm_ptr->state = DCM_ACCEPTED;

@@ -1179,7 +1163,6 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                         strerror(errno), len,
                         inet_ntoa(((struct sockaddr_in *)
                                   &cm_ptr->msg.daddr.so)->sin_addr));
-               cm_ptr->ep = NULL;
                goto bail;
        }

@@ -1195,9 +1178,14 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                     htonll(*(uint64_t*)&local.saddr.ib.gid[8]));

        dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: accepted!\n");
+
+       /* Link CM to EP, already queued on work thread */
+       dapl_ep_link_cm(ep_ptr, cm_ptr);
+       cm_ptr->ep = ep_ptr;
        return DAT_SUCCESS;
 bail:
-       dapls_ib_cm_free(cm_ptr, NULL);
+       /* schedule cleanup from workq */
+       dapli_cm_free(cm_ptr);
        return ret;
 }

@@ -1269,14 +1257,12 @@ ud_bail:
                                (DAT_PVOID *) cm_ptr->msg.p_data,
                                (DAT_PVOID *) &xevent);

-                /* done with socket, don't destroy cm_ptr, need pdata */
-                closesocket(cm_ptr->socket);
-                cm_ptr->socket = DAPL_INVALID_SOCKET;
-               cm_ptr->state = DCM_RELEASED;
+                /* cleanup and release from local list, still on EP list */
+               dapli_cm_free(cm_ptr);
+
        } else
 #endif
        {
-               cm_ptr->ep->cm_handle = cm_ptr; /* only RC, multi CR's on UD */
                dapls_cr_callback(cm_ptr, event, NULL, 0, cm_ptr->sp);
        }
        return;
@@ -1286,9 +1272,9 @@ bail:
        if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD)
                goto ud_bail;
 #endif
-       dapls_modify_qp_state(cm_ptr->ep->qp_handle, IBV_QPS_ERR, 0, 0, 0);
-       dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
+       cm_ptr->state = DCM_REJECTED;
        dapls_cr_callback(cm_ptr, event, NULL, 0, cm_ptr->sp);
+       dapli_cm_free(cm_ptr);
 }

 /*
@@ -1318,15 +1304,11 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
                 IN DAT_CONN_QUAL remote_conn_qual,
                 IN DAT_COUNT private_data_size, IN void *private_data)
 {
-       DAPL_EP *ep_ptr;
-       ib_qp_handle_t qp_ptr;
-
+       DAPL_EP *ep_ptr = (DAPL_EP *) ep_handle;
+
        dapl_dbg_log(DAPL_DBG_TYPE_EP,
                     " connect(ep_handle %p ....)\n", ep_handle);

-       ep_ptr = (DAPL_EP *) ep_handle;
-       qp_ptr = ep_ptr->qp_handle;
-
        return (dapli_socket_connect(ep_ptr, remote_ia_address,
                                     remote_conn_qual,
                                     private_data_size, private_data));
@@ -1350,17 +1332,17 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 DAT_RETURN
 dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 {
-       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    "dapls_ib_disconnect(ep_handle %p ....)\n", ep_ptr);
+       dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);

-       /* Transition to error state to flush queue */
-        dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
-
-       if (ep_ptr->cm_handle == NULL ||
-           ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED)
+       if (ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED ||
+               ep_ptr->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC) {
                return DAT_SUCCESS;
-       else
-               return (dapli_socket_disconnect(ep_ptr->cm_handle));
+       }
+
+       /* RC. Transition to error state to flush queue */
+        dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
+
+       return (dapli_socket_disconnect(cm_ptr));
 }

 /*
@@ -1387,18 +1369,7 @@ dapls_ib_disconnect_clean(IN DAPL_EP * ep_ptr,
                          IN DAT_BOOLEAN active,
                          IN const ib_cm_events_t ib_cm_event)
 {
-       /* NOTE: SCM will only initialize cm_handle with RC type
-        *
-        * For UD there can many in-flight CR's so you
-        * cannot cleanup timed out CR's with EP reference
-        * alone since they share the same EP. The common
-        * code that handles connection timeout logic needs
-        * updated for UD support.
-        */
-       if (ep_ptr->cm_handle)
-               dapls_ib_cm_free(ep_ptr->cm_handle, ep_ptr);
-
-       return;
+       /* nothing to cleanup */
 }

 /*
@@ -1450,18 +1421,11 @@ dapls_ib_remove_conn_listener(IN DAPL_IA * ia_ptr, IN DAPL_SP * sp_ptr)
 {
        ib_cm_srvc_handle_t cm_ptr = sp_ptr->cm_srvc_handle;

-       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    "dapls_ib_remove_conn_listener(ia_ptr %p sp_ptr %p cm_ptr %p)\n",
-                    ia_ptr, sp_ptr, cm_ptr);
-
-       /* close accepted socket, free cm_srvc_handle and return */
+       /* free cm_srvc_handle, release will cleanup */
        if (cm_ptr != NULL) {
                /* cr_thread will free */
-               dapl_os_lock(&cm_ptr->lock);
-               cm_ptr->state = DCM_DESTROY;
                sp_ptr->cm_srvc_handle = NULL;
-               send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
-               dapl_os_unlock(&cm_ptr->lock);
+               dapli_cm_free(cm_ptr);
        }
        return DAT_SUCCESS;
 }
@@ -1542,8 +1506,6 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm_ptr,
         if (psize > DCM_MAX_PDATA_SIZE)
                 return DAT_LENGTH_ERROR;

-       dapl_os_lock(&cm_ptr->lock);
-
        /* write reject data to indicate reject */
        cm_ptr->msg.op = htons(DCM_REJ_USER);
        cm_ptr->msg.p_size = htons(psize);
@@ -1558,10 +1520,8 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm_ptr,
                writev(cm_ptr->socket, iov, 1);
        }

-       /* cr_thread will destroy CR */
-       cm_ptr->state = DCM_DESTROY;
-       send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
-       dapl_os_unlock(&cm_ptr->lock);
+       /* release and cleanup CM object */
+       dapli_cm_free(cm_ptr);
        return DAT_SUCCESS;
 }

@@ -1586,7 +1546,7 @@ dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle,
                        OUT DAT_SOCK_ADDR6 * remote_ia_address)
 {
        DAPL_HEADER *header;
-       dp_ib_cm_handle_t ib_cm_handle;
+       dp_ib_cm_handle_t conn;

        dapl_dbg_log(DAPL_DBG_TYPE_EP,
                     "dapls_ib_cm_remote_addr(dat_handle %p, ....)\n",
@@ -1595,14 +1555,14 @@ dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle,
        header = (DAPL_HEADER *) dat_handle;

        if (header->magic == DAPL_MAGIC_EP)
-               ib_cm_handle = ((DAPL_EP *) dat_handle)->cm_handle;
+               conn = dapl_get_cm_from_ep((DAPL_EP *) dat_handle);
        else if (header->magic == DAPL_MAGIC_CR)
-               ib_cm_handle = ((DAPL_CR *) dat_handle)->ib_cm_handle;
+               conn = ((DAPL_CR *) dat_handle)->ib_cm_handle;
        else
                return DAT_INVALID_HANDLE;

        dapl_os_memcpy(remote_ia_address,
-                      &ib_cm_handle->msg.daddr.so, sizeof(DAT_SOCK_ADDR6));
+                      &conn->msg.daddr.so, sizeof(DAT_SOCK_ADDR6));

        return DAT_SUCCESS;
 }
@@ -1745,60 +1705,55 @@ void cr_thread(void *arg)
                while (next_cr) {
                        cr = next_cr;
                        next_cr = dapl_llist_next_entry(&hca_ptr->ib_trans.list,
-                                                       (DAPL_LLIST_ENTRY *) &
-                                                       cr->entry);
+                                                       (DAPL_LLIST_ENTRY *)
+                                                       &cr->local_entry);
+                       dapls_cm_acquire(cr); /* hold thread ref */
                        dapl_os_lock(&cr->lock);
-                       if (cr->state == DCM_DESTROY
-                           || hca_ptr->ib_trans.cr_state != IB_THREAD_RUN) {
-                               dapl_os_unlock(&cr->lock);
-                               dapl_llist_remove_entry(&hca_ptr->ib_trans.list,
-                                                       (DAPL_LLIST_ENTRY *) &
-                                                       cr->entry);
-                               dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                                            " CR FREE: %p ep=%p st=%d sock=%d\n",
-                                            cr, cr->ep, cr->state, cr->socket);
+                       if (cr->state == DCM_FREE ||
+                           hca_ptr->ib_trans.cr_state != IB_THREAD_RUN) {
+                               dapl_log(DAPL_DBG_TYPE_CM,
+                                        " CM FREE: %p ep=%p st=%s sck=%d refs=%d\n",
+                                        cr, cr->ep, dapl_cm_state_str(cr->state),
+                                        cr->socket, cr->ref_count);

                                if (cr->socket != DAPL_INVALID_SOCKET) {
                                        shutdown(cr->socket, SHUT_RDWR);
                                        closesocket(cr->socket);
+                                       cr->socket = DAPL_INVALID_SOCKET;
                                }
-                               dapl_os_lock_destroy(&cr->lock);
-                               dapl_os_free(cr, sizeof(*cr));
-                               continue;
-                       }
-                       if (cr->socket == DAPL_INVALID_SOCKET) {
                                dapl_os_unlock(&cr->lock);
+                               dapls_cm_release(cr); /* release alloc ref */
+                               dapli_cm_dequeue(cr); /* release workq ref */
+                               dapls_cm_release(cr); /* release thread ref */
                                continue;
                        }

                        event = (cr->state == DCM_CONN_PENDING) ?
-                                               DAPL_FD_WRITE : DAPL_FD_READ;
+                                       DAPL_FD_WRITE : DAPL_FD_READ;

                        if (dapl_fd_set(cr->socket, set, event)) {
                                dapl_log(DAPL_DBG_TYPE_ERR,
-                                        " cr_thread: DESTROY CR st=%d fd %d"
+                                        " cr_thread: fd_set ERR st=%d fd %d"
                                         " -> %s\n", cr->state, cr->socket,
                                         inet_ntoa(((struct sockaddr_in *)
                                                &cr->msg.daddr.so)->sin_addr));
                                dapl_os_unlock(&cr->lock);
-                               dapls_ib_cm_free(cr, cr->ep);
+                               dapls_cm_release(cr); /* release ref */
                                continue;
                        }
                        dapl_os_unlock(&cr->lock);
-                       dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                                    " poll cr=%p, sck=%d\n", cr, cr->socket);
                        dapl_os_unlock(&hca_ptr->ib_trans.lock);
-
+
                        ret = dapl_poll(cr->socket, event);

-                       dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                                    " poll ret=0x%x cr->state=%d sck=%d\n",
-                                    ret, cr->state, cr->socket);
+                       dapl_dbg_log(DAPL_DBG_TYPE_THREAD,
+                                    " poll ret=0x%x %s sck=%d\n",
+                                    ret, dapl_cm_state_str(cr->state),
+                                    cr->socket);

                        /* data on listen, qp exchange, and on disc req */
                        if ((ret == DAPL_FD_READ) ||
-                           (cr->state != DCM_CONN_PENDING &&
-                            ret == DAPL_FD_ERROR)) {
+                           (cr->state != DCM_CONN_PENDING && ret == DAPL_FD_ERROR)) {
                                if (cr->socket != DAPL_INVALID_SOCKET) {
                                        switch (cr->state) {
                                        case DCM_LISTEN:
@@ -1838,6 +1793,8 @@ void cr_thread(void *arg)
                                else
                                        dapli_socket_connected(cr, opt ? opt : dapl_socket_errno());
                        }
+
+                       dapls_cm_release(cr); /* release ref */
                        dapl_os_lock(&hca_ptr->ib_trans.lock);
                }

@@ -1853,7 +1810,7 @@ void cr_thread(void *arg)
                while (dapl_poll(hca_ptr->ib_trans.scm[0],
                                 DAPL_FD_READ) == DAPL_FD_READ) {
                        if (recv(hca_ptr->ib_trans.scm[0], rbuf, 2, 0) == -1)
-                               dapl_log(DAPL_DBG_TYPE_CM,
+                               dapl_log(DAPL_DBG_TYPE_THREAD,
                                         " cr_thread: read pipe error = %s\n",
                                         strerror(errno));
                }
@@ -1869,7 +1826,7 @@ void cr_thread(void *arg)
        dapl_os_free(set, sizeof(struct dapl_fd_set));
 out:
        hca_ptr->ib_trans.cr_state = IB_THREAD_EXIT;
-       dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cr_thread(hca %p) exit\n", hca_ptr);
+       dapl_dbg_log(DAPL_DBG_TYPE_THREAD, " cr_thread(hca %p) exit\n", hca_ptr);
 }


@@ -1894,7 +1851,7 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
                cr = next_cr;
                next_cr = dapl_llist_next_entry((DAPL_LLIST_HEAD*)
                                 &ia_ptr->hca_ptr->ib_trans.list,
-                               (DAPL_LLIST_ENTRY*)&cr->entry);
+                               (DAPL_LLIST_ENTRY*)&cr->local_entry);

                printf( "  CONN[%d]: sp %p ep %p sock %d %s %s %s %s %s %s PORT L-%x R-%x PID L-%x R-%x\n",
                        i, cr->sp, cr->ep, cr->socket,
diff --git a/dapl/openib_scm/dapl_ib_util.h b/dapl/openib_scm/dapl_ib_util.h
index 831084f..497bc64 100644
--- a/dapl/openib_scm/dapl_ib_util.h
+++ b/dapl/openib_scm/dapl_ib_util.h
@@ -31,10 +31,14 @@
 #include "openib_osd.h"
 #include "dapl_ib_common.h"

+/* DAPL CM objects MUST include list_entry, ref_count, event for EP linking */
 struct ib_cm_handle
 {
-       struct dapl_llist_entry entry;
+       struct dapl_llist_entry list_entry;
+       struct dapl_llist_entry local_entry;
+        DAPL_OS_WAIT_OBJECT    event;
        DAPL_OS_LOCK            lock;
+       int                     ref_count;
        int                     state;
        DAPL_SOCKET             socket;
        struct dapl_hca         *hca;
@@ -45,7 +49,7 @@ struct ib_cm_handle
        DAT_SOCK_ADDR6          addr;
 };

-typedef struct ib_cm_handle    *dp_ib_cm_handle_t;
+typedef struct ib_cm_handle    *dp_ib_cm_handle_t;
 typedef dp_ib_cm_handle_t      ib_cm_srvc_handle_t;

 /* Definitions */
@@ -110,9 +114,9 @@ int dapli_cq_thread_init(struct dapl_hca *hca_ptr);
 void dapli_cq_thread_destroy(struct dapl_hca *hca_ptr);
 void dapli_async_event_cb(struct _ib_hca_transport *tp);
 void dapli_cq_event_cb(struct _ib_hca_transport *tp);
-DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr);
-dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
-void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
+void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr);
+void dapls_cm_release(dp_ib_cm_handle_t cm_ptr);
+void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);

 #ifdef DAPL_COUNTERS
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index c0da589..6efa2f1 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -31,6 +31,7 @@
 #include "dapl_cr_util.h"
 #include "dapl_name_service.h"
 #include "dapl_ib_util.h"
+#include "dapl_ep_util.h"
 #include "dapl_osd.h"


@@ -374,7 +375,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
                ucm_disconnect_final(cm);
                break;
        case DCM_DISCONNECTED:
-       case DCM_DESTROY:
+       case DCM_FREE:
                /* DREQ dropped, resend */
                if (ntohs(msg->op) == DCM_DREQ) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
@@ -392,10 +393,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
                        ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);

                }
-               dapl_os_unlock(&cm->lock);
-               break;
-       case DCM_RELEASED:
-               /* UD reply retried, ignore */
+               /* UD reply retried ok to ignore, any other print warning */
                if (ntohs(msg->op) != DCM_REP) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                " ucm_recv: UNKNOWN operation"
@@ -438,8 +436,8 @@ retry_listenq:
        while (next) {
                cm = next;
                next = dapl_llist_next_entry(list,
-                                            (DAPL_LLIST_ENTRY *)&cm->entry);
-               if (cm->state == DCM_DESTROY)
+                                            (DAPL_LLIST_ENTRY *)&cm->local_entry);
+               if (cm->state == DCM_DESTROY || cm->state == DCM_FREE)
                        continue;

                /* CM sPORT + QPN, match is good enough for listenq */
@@ -619,6 +617,46 @@ bail:
 }

 /* ACTIVE/PASSIVE: CM objects */
+static void dapli_cm_dealloc(dp_ib_cm_handle_t cm) {
+
+       dapl_os_assert(!cm->ref_count);
+       dapl_os_lock_destroy(&cm->lock);
+       dapl_os_wait_object_destroy(&cm->event);
+       dapl_os_free(cm, sizeof(*cm));
+}
+
+void dapls_cm_acquire(dp_ib_cm_handle_t cm)
+{
+       dapl_os_lock(&cm->lock);
+       cm->ref_count++;
+       dapl_os_unlock(&cm->lock);
+}
+
+void dapls_cm_release(dp_ib_cm_handle_t cm)
+{
+       dapl_os_lock(&cm->lock);
+       cm->ref_count--;
+       if (cm->ref_count) {
+                dapl_os_unlock(&cm->lock);
+               return;
+       }
+       /* client, release local conn id port */
+       if (!cm->sp && cm->msg.sport)
+               ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
+
+       /* server, release local conn id port */
+       if (cm->sp && cm->msg.dport)
+               ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.dport));
+
+       /* clean up any UD address handles */
+       if (cm->ah) {
+               ibv_destroy_ah(cm->ah);
+               cm->ah = NULL;
+       }
+       dapl_os_unlock(&cm->lock);
+       dapli_cm_dealloc(cm);
+}
+
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 {
        dp_ib_cm_handle_t cm;
@@ -630,6 +668,12 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
        (void)dapl_os_memzero(cm, sizeof(*cm));
        if (dapl_os_lock_init(&cm->lock))
                goto bail;
+
+       if (dapl_os_wait_object_init(&cm->event)) {
+               dapl_os_lock_destroy(&cm->lock);
+               goto bail;
+       }
+       dapls_cm_acquire(cm);

        cm->msg.ver = htons(DCM_VER);
        *(DAT_UINT32*)cm->msg.resv = htonl(dapl_os_getpid()); /* exchange PID for debugging */
@@ -639,12 +683,17 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
                DAPL_HCA *hca = ep->header.owner_ia->hca_ptr;

                cm->msg.sport = htons(ucm_get_port(&hca->ib_trans, 0));
-               if (!cm->msg.sport)
+               if (!cm->msg.sport) {
+                       dapl_os_wait_object_destroy(&cm->event);
+                       dapl_os_lock_destroy(&cm->lock);
                        goto bail;
+               }
+               /* link CM object to EP */
+               dapl_ep_link_cm(ep, cm);
+               cm->hca = hca;
+               cm->ep = ep;

                /* IB info in network order */
-               cm->ep = ep;
-               cm->hca = hca;
                cm->msg.sqpn = htonl(hca->ib_trans.qp->qp_num); /* ucm */
                cm->msg.saddr.ib.qpn = htonl(ep->qp_handle->qp_num); /* ep */
                cm->msg.saddr.ib.qp_type = ep->qp_handle->qp_type;
@@ -658,128 +707,80 @@ bail:
        return NULL;
 }

-/*
- * UD CR objects are kept active because of direct private data references
- * from CONN events. The cr->socket is closed and marked inactive but the
- * object remains allocated and queued on the CR resource list. There can
- * be multiple CR's associated with a given EP. There is no way to determine
- * when consumer is finished with event until the dat_ep_free.
- *
- * Schedule destruction for all CR's associated with this EP, cr_thread will
- * complete the cleanup with state == DCM_DESTROY.
- */
-static void ucm_ud_free(DAPL_EP *ep)
+/* schedule destruction of CM object */
+void dapli_cm_free(dp_ib_cm_handle_t cm)
 {
-       DAPL_IA *ia = ep->header.owner_ia;
-       DAPL_HCA *hca = NULL;
-       ib_hca_transport_t *tp = &ia->hca_ptr->ib_trans;
-       dp_ib_cm_handle_t cm, next;
-
-       dapl_os_lock(&tp->lock);
-       if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)&tp->list))
-            next = dapl_llist_peek_head((DAPL_LLIST_HEAD*)&tp->list);
-       else
-           next = NULL;
-
-       while (next) {
-               cm = next;
-               next = dapl_llist_next_entry((DAPL_LLIST_HEAD*)&tp->list,
-                                            (DAPL_LLIST_ENTRY*)&cm->entry);
-               if (cm->ep == ep)  {
-                       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                                    " qp_free CM: ep %p cm %p\n", ep, cm);
-                       dapl_os_lock(&cm->lock);
-                       hca = cm->hca;
-                       cm->ep = NULL;
-                       if (cm->ah) {
-                               ibv_destroy_ah(cm->ah);
-                               cm->ah = NULL;
-                       }
-                       cm->state = DCM_DESTROY;
-                       dapl_os_unlock(&cm->lock);
-               }
-       }
-       dapl_os_unlock(&tp->lock);
-
-       /* wakeup work thread if necessary */
-       if (hca)
-               dapls_thread_signal(&tp->signal);
+       dapl_os_lock(&cm->lock);
+       cm->state = DCM_FREE;
+       dapls_thread_signal(&cm->hca->ib_trans.signal);
+       dapl_os_unlock(&cm->lock);
 }

-/* mark for destroy, remove all references, schedule cleanup */
-/* cm_ptr == NULL (UD), then multi CR's, kill all associated with EP */
-void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
+/* Blocking, ONLY called from dat_ep_free */
+void dapls_cm_free(dp_ib_cm_handle_t cm)
 {
-       dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " cm_destroy: %s cm %p ep %p\n",
-                    cm ? dapl_cm_state_str(cm->state) : "", cm, ep);
-
-       if (!cm && ep) {
-               ucm_ud_free(ep);
-               return;
-       }
-
+       dapl_log(DAPL_DBG_TYPE_CM,
+                " cm_free: cm %p %s ep %p refs=%d\n",
+                cm, dapl_cm_state_str(cm->state),
+                cm->ep, cm->ref_count);
+
+       /* free from internal workq, wait until EP is last ref */
        dapl_os_lock(&cm->lock);
-
-       /* client, release local conn id port */
-       if (!cm->sp && cm->msg.sport)
-               ucm_free_port(&cm->hca->ib_trans, cm->msg.sport);
-
-       /* cleanup, never made it to work queue */
-       if (cm->state == DCM_INIT) {
+       cm->state = DCM_FREE;
+       while (cm->ref_count != 1) {
                dapl_os_unlock(&cm->lock);
-               dapl_os_lock_destroy(&cm->lock);
-               dapl_os_free(cm, sizeof(*cm));
-               return;
-       }
-
-       /* free could be called before disconnect, disc_clean will destroy */
-       if (cm->state == DCM_CONNECTED) {
-               dapl_os_unlock(&cm->lock);
-               dapli_cm_disconnect(cm);
-               return;
-       }
-
-       cm->state = DCM_DESTROY;
-       if ((cm->ep) && (cm->ep->cm_handle == cm)) {
-               cm->ep->cm_handle = IB_INVALID_HANDLE;
-               cm->ep = NULL;
+               dapl_os_sleep_usec(10000);
+               dapl_os_lock(&cm->lock);
        }
-
        dapl_os_unlock(&cm->lock);

-       /* wakeup work thread */
-       dapls_thread_signal(&cm->hca->ib_trans.signal);
+       /* unlink, dequeue from EP. Final ref so release will destroy */
+       dapl_ep_unlink_cm(cm->ep, cm);
 }

 /* ACTIVE/PASSIVE: queue up connection object on CM list */
-static void ucm_queue_conn(dp_ib_cm_handle_t cm)
+static void dapli_queue_conn(dp_ib_cm_handle_t cm)
 {
        /* add to work queue, list, for cm thread processing */
-       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm->entry);
+       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm->local_entry);
        dapl_os_lock(&cm->hca->ib_trans.lock);
+       dapls_cm_acquire(cm);
        dapl_llist_add_tail(&cm->hca->ib_trans.list,
-                           (DAPL_LLIST_ENTRY *)&cm->entry, cm);
+                           (DAPL_LLIST_ENTRY *)&cm->local_entry, cm);
        dapl_os_unlock(&cm->hca->ib_trans.lock);
        dapls_thread_signal(&cm->hca->ib_trans.signal);
 }

 /* PASSIVE: queue up listen object on listen list */
-static void ucm_queue_listen(dp_ib_cm_handle_t cm)
+static void dapli_queue_listen(dp_ib_cm_handle_t cm)
 {
        /* add to work queue, llist, for cm thread processing */
-       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm->entry);
+       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm->local_entry);
        dapl_os_lock(&cm->hca->ib_trans.llock);
+       dapls_cm_acquire(cm);
        dapl_llist_add_tail(&cm->hca->ib_trans.llist,
-                           (DAPL_LLIST_ENTRY *)&cm->entry, cm);
+                           (DAPL_LLIST_ENTRY *)&cm->local_entry, cm);
        dapl_os_unlock(&cm->hca->ib_trans.llock);
 }

-static void ucm_dequeue_listen(dp_ib_cm_handle_t cm) {
-       dapl_os_lock(&cm->hca->ib_trans.llock);
-       dapl_llist_remove_entry(&cm->hca->ib_trans.llist,
-                               (DAPL_LLIST_ENTRY *)&cm->entry);
-       dapl_os_unlock(&cm->hca->ib_trans.llock);
+static void dapli_dequeue_listen(dp_ib_cm_handle_t cm)
+{
+       DAPL_HCA *hca = cm->hca;
+
+       dapl_os_lock(&hca->ib_trans.llock);
+       dapl_llist_remove_entry(&hca->ib_trans.llist,
+                               (DAPL_LLIST_ENTRY *)&cm->local_entry);
+       dapls_cm_release(cm);
+       dapl_os_unlock(&hca->ib_trans.llock);
+}
+
+/* called with local LIST and CM object lock */
+static void dapli_cm_dequeue(dp_ib_cm_handle_t cm)
+{
+       /* Remove from work queue, cr thread processing */
+       dapl_llist_remove_entry(&cm->hca->ib_trans.list,
+                               (DAPL_LLIST_ENTRY *)&cm->local_entry);
+       dapls_cm_release(cm);
 }

 static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
@@ -802,6 +803,9 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
                dapls_cr_callback(cm, IB_CME_DISCONNECTED, NULL, 0, cm->sp);
        else
                dapl_evd_connection_callback(cm, IB_CME_DISCONNECTED, NULL, 0, cm->ep);
+
+       /* free local resources, EP ref will prevent destory until dat_ep_free */
+       dapls_cm_release(cm);
 }

 /*
@@ -858,7 +862,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
        ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);
        dapl_os_unlock(&cm->lock);

-       if (finalize)
+       if (finalize)
                ucm_disconnect_final(cm);

        return DAT_SUCCESS;
@@ -896,10 +900,6 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
                         htonl(cm->msg.dqpn),
                         htons(cm->msg.dport));

-               /* update ep->cm reference so we get cleaned up on callback */
-               if (cm->msg.saddr.ib.qp_type == IBV_QPT_RC);
-                       ep->cm_handle = cm;
-
                dapl_os_unlock(&cm->lock);

 #ifdef DAPL_COUNTERS
@@ -925,10 +925,10 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
                     &cm->msg.p_data, ntohs(cm->msg.p_size)))
                goto bail;

-       /* first time through, put on work queue */
-       if (!cm->retries)
-               ucm_queue_conn(cm);
-
+       /* first time through, link EP and CM, put on work queue */
+       if (!cm->retries) {
+               dapli_queue_conn(cm);
+       }
        return DAT_SUCCESS;

 bail:
@@ -938,8 +938,7 @@ bail:
                 htonl(cm->msg.dqpn), htons(cm->msg.dport),
                 htonl(cm->msg.p_size));

-       /* close socket, free cm structure */
-       dapls_ib_cm_free(cm, cm->ep);
+       dapli_cm_free(cm);
        return DAT_INSUFFICIENT_RESOURCES;
 }

@@ -1116,26 +1115,20 @@ ud_bail:
                                (DAT_PVOID *)cm->msg.p_data,
                                (DAT_PVOID *)&xevent);

-               /* we are done, don't destroy cm_ptr, need pdata */
-               dapl_os_lock(&cm->lock);
-               cm->state = DCM_RELEASED;
-               dapl_os_unlock(&cm->lock);
-
+               /* release cm_ptr, EP refs will prevent destroy */
+               dapli_cm_free(cm);
+
        } else
 #endif
        {
-               cm->ep->cm_handle = cm; /* only RC, multi CR's on UD */
                dapl_evd_connection_callback(cm,
                                             IB_CME_CONNECTED,
                                             cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
        }
        return;
 bail:
-       if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD)
-               dapls_ib_reinit_ep(cm->ep); /* reset QP state */
-
        dapl_evd_connection_callback(NULL, event, cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
-       dapls_ib_cm_free(cm, NULL);
+       dapli_cm_free(cm);
 }

 /*
@@ -1184,7 +1177,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
                               msg->p_data, ntohs(msg->p_size));

        acm->state = DCM_ACCEPTING;
-       ucm_queue_conn(acm);
+       dapli_queue_conn(acm);

 #ifdef DAT_EXTENSIONS
        if (acm->msg.daddr.ib.qp_type == IBV_QPT_UD) {
@@ -1209,8 +1202,8 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
        return;

 bail:
-       /* free cm object */
-       dapls_ib_cm_free(acm, NULL);
+       /* schedule work thread cleanup */
+       dapli_cm_free(acm);
        return;
 }

@@ -1289,21 +1282,17 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
                                (DAT_PVOID *)cm->msg.p_data,
                                (DAT_PVOID *)&xevent);

-                /* done with CM object, don't destroy cm, need pdata */
-               dapl_os_lock(&cm->lock);
-                       cm->state = DCM_RELEASED;
-               dapl_os_unlock(&cm->lock);
+                /* done with CM object, EP ref will hold object for pdata */
+               dapli_cm_free(cm);
+
        } else {
 #endif
-               cm->ep->cm_handle = cm; /* only RC, multi CR's on UD */
                dapls_cr_callback(cm, IB_CME_CONNECTED, NULL, 0, cm->sp);
        }
        return;
 bail:
-       if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD)
-               dapls_ib_reinit_ep(cm->ep);     /* reset QP state */
-       dapls_ib_cm_free(cm, cm->ep);
        dapls_cr_callback(cm, IB_CME_LOCAL_FAILURE, NULL, 0, cm->sp);
+       dapli_cm_free(cm);
 }

 /*
@@ -1386,7 +1375,6 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
                dapl_os_unlock(&cm->lock);
                return DAT_INVALID_STATE;
        }
-       dapl_os_unlock(&cm->lock);

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " ACCEPT_USR: remote lid=%x"
@@ -1413,7 +1401,6 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 #endif

        /* modify QP to RTR and then to RTS with remote info already read */
-       dapl_os_lock(&ep->header.lock);
        if (dapls_modify_qp_state(ep->qp_handle,
                                  IBV_QPS_RTR,
                                  cm->msg.daddr.ib.qpn,
@@ -1423,7 +1410,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
                         " ACCEPT_USR: QPS_RTR ERR %s -> lid %x qpn %x\n",
                         strerror(errno), ntohs(cm->msg.daddr.ib.lid),
                         ntohl(cm->msg.daddr.ib.qpn));
-               dapl_os_unlock(&ep->header.lock);
+               dapl_os_unlock(&cm->lock);
                goto bail;
        }
        if (dapls_modify_qp_state(ep->qp_handle,
@@ -1435,10 +1422,9 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
                         " ACCEPT_USR: QPS_RTS ERR %s -> lid %x qpn %x\n",
                         strerror(errno), ntohs(cm->msg.daddr.ib.lid),
                         ntohl(cm->msg.daddr.ib.qpn));
-               dapl_os_unlock(&ep->header.lock);
+               dapl_os_unlock(&cm->lock);
                goto bail;
        }
-       dapl_os_unlock(&ep->header.lock);

        /* save remote address information */
        dapl_os_memcpy(&ep->remote_ia_address,
@@ -1460,24 +1446,22 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
        dapl_os_memcpy(&cm->p_data, p_data, p_size);

        /* save state and setup valid reference to EP, HCA */
-       dapl_os_lock(&cm->lock);
+       dapl_ep_link_cm(ep, cm);
        cm->ep = ep;
        cm->hca = ia->hca_ptr;
        cm->state = DCM_RTU_PENDING;
        dapl_os_get_time(&cm->timer); /* RTU expected */
        dapl_os_unlock(&cm->lock);

-       if (ucm_reply(cm))
+       if (ucm_reply(cm)) {
+               dapl_ep_link_cm(ep, cm);
                goto bail;
-
+       }
        dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
        dapls_thread_signal(&cm->hca->ib_trans.signal);
        return DAT_SUCCESS;
 bail:
-       if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD)
-               dapls_ib_reinit_ep(ep);
-
-       dapls_ib_cm_free(cm, ep);
+       dapli_cm_free(cm);
        return DAT_INTERNAL_ERROR;
 }

@@ -1533,7 +1517,7 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
        cm->state = DCM_REP_PENDING;

        /* build connect request, send to remote CM based on r_addr info */
-       return(dapli_cm_connect(ep, cm));
+       return (dapli_cm_connect(ep, cm));
 }

 /*
@@ -1552,16 +1536,19 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
  *     DAT_SUCCESS
  */
 DAT_RETURN
-dapls_ib_disconnect(IN DAPL_EP *ep, IN DAT_CLOSE_FLAGS close_flags)
+dapls_ib_disconnect(IN DAPL_EP *ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 {
-       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    "dapls_ib_disconnect(ep_handle %p ....)\n", ep);
+       dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);

-       if (ep->cm_handle == NULL ||
-           ep->param.ep_state == DAT_EP_STATE_DISCONNECTED)
+       if (ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED ||
+               ep_ptr->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC) {
                return DAT_SUCCESS;
-       else
-               return (dapli_cm_disconnect(ep->cm_handle));
+       }
+
+       /* RC. Transition to error state to flush queue */
+        dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
+
+       return (dapli_cm_disconnect(cm_ptr));
 }

 /*
@@ -1588,18 +1575,7 @@ dapls_ib_disconnect_clean(IN DAPL_EP *ep,
                          IN DAT_BOOLEAN active,
                          IN const ib_cm_events_t ib_cm_event)
 {
-       /* NOTE: SCM will only initialize cm_handle with RC type
-        *
-        * For UD there can many in-flight CR's so you
-        * cannot cleanup timed out CR's with EP reference
-        * alone since they share the same EP. The common
-        * code that handles connection timeout logic needs
-        * updated for UD support.
-        */
-       if (ep->cm_handle)
-               dapls_ib_cm_free(ep->cm_handle, ep);
-
-       return;
+       /* nothing to cleanup */
 }

 /*
@@ -1660,7 +1636,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA *ia,

        /* queue up listen socket to process inbound CR's */
        cm->state = DCM_LISTEN;
-       ucm_queue_listen(cm);
+       dapli_queue_listen(cm);

        return DAT_SUCCESS;
 }
@@ -1687,7 +1663,6 @@ DAT_RETURN
 dapls_ib_remove_conn_listener(IN DAPL_IA *ia, IN DAPL_SP *sp)
 {
        ib_cm_srvc_handle_t cm = sp->cm_srvc_handle;
-       ib_hca_transport_t *tp = &ia->hca_ptr->ib_trans;

        /* free cm_srvc_handle and port, and mark CM for cleanup */
        if (cm) {
@@ -1696,14 +1671,8 @@ dapls_ib_remove_conn_listener(IN DAPL_IA *ia, IN DAPL_SP *sp)
                     ia, sp, cm, ntohs(cm->msg.dport));

                sp->cm_srvc_handle = NULL;
-               dapl_os_lock(&cm->lock);
-               ucm_free_port(tp, ntohs(cm->msg.dport));
-               cm->msg.dport = 0;
-               cm->state = DCM_DESTROY;
-               dapl_os_unlock(&cm->lock);
-               ucm_dequeue_listen(cm);
-               dapl_os_lock_destroy(&cm->lock);
-               dapl_os_free(cm, sizeof(*cm));
+               dapli_dequeue_listen(cm);
+               dapls_cm_release(cm);  /* last ref, dealloc */
        }
        return DAT_SUCCESS;
 }
@@ -1792,13 +1761,11 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,
        if (ucm_send(&cm->hca->ib_trans, &cm->msg, pdata, psize)) {
                dapl_log(DAPL_DBG_TYPE_WARN,
                         " cm_reject: ERR: %s\n", strerror(errno));
+               dapl_os_unlock(&cm->lock);
                return DAT_INTERNAL_ERROR;
        }
        dapl_os_unlock(&cm->lock);
-
-       /* cleanup and destroy CM resources */
-       dapls_ib_cm_free(cm, NULL);
-
+       dapli_cm_free(cm);
        return DAT_SUCCESS;
 }

@@ -1823,7 +1790,7 @@ dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle,
                        OUT DAT_SOCK_ADDR6 * remote_ia_address)
 {
        DAPL_HEADER *header;
-       dp_ib_cm_handle_t ib_cm_handle;
+       dp_ib_cm_handle_t cm;

        dapl_dbg_log(DAPL_DBG_TYPE_EP,
                     "dapls_ib_cm_remote_addr(dat_handle %p, ....)\n",
@@ -1832,14 +1799,14 @@ dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle,
        header = (DAPL_HEADER *) dat_handle;

        if (header->magic == DAPL_MAGIC_EP)
-               ib_cm_handle = ((DAPL_EP *) dat_handle)->cm_handle;
+               cm = dapl_get_cm_from_ep((DAPL_EP *) dat_handle);
        else if (header->magic == DAPL_MAGIC_CR)
-               ib_cm_handle = ((DAPL_CR *) dat_handle)->ib_cm_handle;
+               cm = ((DAPL_CR *) dat_handle)->ib_cm_handle;
        else
                return DAT_INVALID_HANDLE;

        dapl_os_memcpy(remote_ia_address,
-                      &ib_cm_handle->msg.daddr, sizeof(DAT_SOCK_ADDR6));
+                      &cm->msg.daddr, sizeof(DAT_SOCK_ADDR6));

        return DAT_SUCCESS;
 }
@@ -1976,19 +1943,25 @@ void cm_thread(void *arg)
                while (next) {
                        cm = next;
                        next = dapl_llist_next_entry(&hca->ib_trans.list,
-                                                    (DAPL_LLIST_ENTRY *)&cm->entry);
+                                                    (DAPL_LLIST_ENTRY *)&cm->local_entry);
+                       dapls_cm_acquire(cm); /* hold thread ref */
                        dapl_os_lock(&cm->lock);
-                       if (cm->state == DCM_DESTROY ||
+                       if (cm->state == DCM_FREE ||
                            hca->ib_trans.cm_state != IB_THREAD_RUN) {
-                               dapl_llist_remove_entry(&hca->ib_trans.list,
-                                                       (DAPL_LLIST_ENTRY *)&cm->entry);
                                dapl_os_unlock(&cm->lock);
-                               dapl_os_lock_destroy(&cm->lock);
-                               dapl_os_free(cm, sizeof(*cm));
+                               dapl_log(DAPL_DBG_TYPE_CM,
+                                        " CM FREE: %p ep=%p st=%s refs=%d\n",
+                                        cm, cm->ep, dapl_cm_state_str(cm->state),
+                                        cm->ref_count);
+
+                               dapls_cm_release(cm); /* release alloc ref */
+                               dapli_cm_dequeue(cm); /* release workq ref */
+                               dapls_cm_release(cm); /* release thread ref */
                                continue;
                        }
                        dapl_os_unlock(&cm->lock);
                        ucm_check_timers(cm, &time_ms);
+                       dapls_cm_release(cm); /* release thread ref */
                }

                dapl_os_unlock(&hca->ib_trans.lock);
@@ -2047,20 +2020,25 @@ void cm_thread(void *arg)
                        cm = next;
                        next = dapl_llist_next_entry(
                                        &hca->ib_trans.list,
-                                       (DAPL_LLIST_ENTRY *)&cm->entry);
+                                       (DAPL_LLIST_ENTRY *)&cm->local_entry);
+                       dapls_cm_acquire(cm); /* hold thread ref */
                        dapl_os_lock(&cm->lock);
-                       if (cm->state == DCM_DESTROY ||
+                       if (cm->state == DCM_FREE ||
                            hca->ib_trans.cm_state != IB_THREAD_RUN) {
-                               dapl_llist_remove_entry(
-                                       &hca->ib_trans.list,
-                                       (DAPL_LLIST_ENTRY *)&cm->entry);
                                dapl_os_unlock(&cm->lock);
-                               dapl_os_lock_destroy(&cm->lock);
-                               dapl_os_free(cm, sizeof(*cm));
+                               dapl_log(DAPL_DBG_TYPE_CM,
+                                        " CM FREE: %p ep=%p st=%s refs=%d\n",
+                                        cm, cm->ep, dapl_cm_state_str(cm->state),
+                                        cm->ref_count);
+
+                               dapls_cm_release(cm); /* release alloc ref */
+                               dapli_cm_dequeue(cm); /* release workq ref */
+                               dapls_cm_release(cm); /* release thread ref */
                                continue;
                        }
                        dapl_os_unlock(&cm->lock);
                        ucm_check_timers(cm, &time_ms);
+                       dapls_cm_release(cm); /* release thread ref */
                }

                /* set to exit and all resources destroyed */
@@ -2088,7 +2066,6 @@ void cm_thread(void *arg)
                                 DAPL_FD_READ) == DAPL_FD_READ) {
                        recv(hca->ib_trans.signal.scm[0], rbuf, 2, 0);
                }
-
                dapl_os_lock(&hca->ib_trans.lock);

                /* set to exit and all resources destroyed */
@@ -2129,7 +2106,7 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
        while (next_cm) {
                cm = next_cm;
                next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
-                                               (DAPL_LLIST_ENTRY*)&cm->entry);
+                                               (DAPL_LLIST_ENTRY*)&cm->local_entry);

                printf( "  LISTEN[%d]: sp %p %s uCM_QP: 0x%x %d 0x%x l_pid %x,%d\n",
                        i, cm->sp, dapl_cm_state_str(cm->state),
@@ -2153,7 +2130,7 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
         while (next_cm) {
                cm = next_cm;
                next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
-                                               (DAPL_LLIST_ENTRY*)&cm->entry);
+                                               (DAPL_LLIST_ENTRY*)&cm->local_entry);

                printf( "  CONN[%d]: ep %p cm %p %s %s"
                        "  %x %x %x %s %x %x %x r_pid %x,%d\n",
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index d7844c6..de17f04 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -33,11 +33,15 @@
 #include "openib_osd.h"
 #include "dapl_ib_common.h"

+/* DAPL CM objects MUST include list_entry, ref_count, event for EP linking */
 struct ib_cm_handle
 {
-       struct dapl_llist_entry entry;
+       struct dapl_llist_entry list_entry;
+       struct dapl_llist_entry local_entry;
+       DAPL_OS_WAIT_OBJECT     event;
        DAPL_OS_LOCK            lock;
        DAPL_OS_TIMEVAL         timer;
+        int                    ref_count;
        int                     state;
        int                     retries;
        struct dapl_hca         *hca;
@@ -117,8 +121,9 @@ typedef struct _ib_hca_transport
 void cm_thread(void *arg);
 void ucm_async_event(struct dapl_hca *hca);
 void dapli_cq_event_cb(struct _ib_hca_transport *tp);
-dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
-void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
+void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr);
+void dapls_cm_release(dp_ib_cm_handle_t cm_ptr);
+void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);

 #ifdef DAPL_COUNTERS
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
--
1.5.2.5
