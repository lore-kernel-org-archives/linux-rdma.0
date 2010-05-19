From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/12] dapl-2.0: ibal: changes for EP to CM linking and
 synchronization
Date: Wed, 19 May 2010 11:11:28 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013086@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Windows IBAL changes to allocate and manage CM objects
and to link them to the EP. This will insure the CM
IBAL objects and cm_id's are not destroy before EP.
Remove windows only ibal_cm_handle in EP structure.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_cr_util.c |    2 +-
 dapl/common/dapl_ep_util.c |    7 -
 dapl/ibal/dapl_ibal_cm.c   |  274 ++++++++++++++++++++++++++++++--------------
 dapl/ibal/dapl_ibal_qp.c   |   14 ++-
 dapl/ibal/dapl_ibal_util.h |   23 ++++-
 dapl/ibal/udapl.rc         |    4 +-
 dapl/include/dapl.h        |    1 -
 7 files changed, 224 insertions(+), 101 deletions(-)

diff --git a/dapl/common/dapl_cr_util.c b/dapl/common/dapl_cr_util.c
index 39b61ad..5970fa0 100644
--- a/dapl/common/dapl_cr_util.c
+++ b/dapl/common/dapl_cr_util.c
@@ -81,7 +81,7 @@ DAPL_CR *dapls_cr_alloc(DAPL_IA * ia_ptr)
 /*
  * dapls_cr_free
  *
- * Free the passed in EP structure.
+ * Free the passed in CR structure.
  *
  * Input:
  *     entry point pointer
diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index daad78d..9aff242 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -214,13 +214,6 @@ void dapl_ep_dealloc(IN DAPL_EP * ep_ptr)
        if (NULL != ep_ptr->cxn_timer) {
                dapl_os_free(ep_ptr->cxn_timer, sizeof(DAPL_OS_TIMER));
        }
-#if defined(_WIN32) || defined(_WIN64)
-       if (ep_ptr->ibal_cm_handle) {
-               dapl_os_free(ep_ptr->ibal_cm_handle,
-                            sizeof(*ep_ptr->ibal_cm_handle));
-               ep_ptr->ibal_cm_handle = NULL;
-       }
-#endif

 #ifdef DAPL_COUNTERS
        dapl_os_free(ep_ptr->cntrs, sizeof(DAT_UINT64) * DCNT_EP_ALL_COUNTERS);
diff --git a/dapl/ibal/dapl_ibal_cm.c b/dapl/ibal/dapl_ibal_cm.c
index c51faf8..e3c12ff 100644
--- a/dapl/ibal/dapl_ibal_cm.c
+++ b/dapl/ibal/dapl_ibal_cm.c
@@ -94,7 +94,7 @@ void dapli_print_private_data( char *prefix, const uint8_t *pd, int len )
     if ( !pd || len <= 0 )
        return;

-    dapl_log ( DAPL_DBG_TYPE_CM, "--> %s: private_data:\n    ",prefix);
+    dapl_log ( DAPL_DBG_TYPE_CM, "--> %s: private_data(len %d)\n    ",prefix,len);

     if (len > IB_MAX_REP_PDATA_SIZE)
     {
@@ -107,13 +107,70 @@ void dapli_print_private_data( char *prefix, const uint8_t *pd, int len )
     for ( i = 0 ; i < len; i++ )
     {
        dapl_log ( DAPL_DBG_TYPE_CM, "%2x ", pd[i]);
-       if ( ((i+1) % 20) == 0 )
+       if ( ((i+1) % 5) == 0 )
            dapl_log ( DAPL_DBG_TYPE_CM, "\n    ");
     }
    dapl_log ( DAPL_DBG_TYPE_CM, "\n");
 }
 #endif

+/* EP-CM linking support */
+dp_ib_cm_handle_t ibal_cm_alloc(void)
+{
+       dp_ib_cm_handle_t cm_ptr;
+
+       /* Allocate CM, init lock, and initialize */
+       if ((cm_ptr = dapl_os_alloc(sizeof(*cm_ptr))) == NULL)
+               return NULL;
+
+       (void)dapl_os_memzero(cm_ptr, sizeof(*cm_ptr));
+       cm_ptr->ref_count = 1;
+
+       if (dapl_os_lock_init(&cm_ptr->lock)) {
+               dapl_os_free(cm_ptr, sizeof(*cm_ptr));
+               return NULL;
+       }
+
+       dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm_ptr->list_entry);
+
+       return cm_ptr;
+}
+
+/* free CM object resources */
+static void ibal_cm_dealloc(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_os_assert(!cm_ptr->ref_count);
+       dapl_os_lock_destroy(&cm_ptr->lock);
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
+       ibal_cm_dealloc(cm_ptr);
+}
+
+/* blocking: called from user thread dapl_ep_free() only */
+void dapls_cm_free(dp_ib_cm_handle_t cm_ptr)
+{
+       dapl_ep_unlink_cm(cm_ptr->ep, cm_ptr);
+
+       /* final reference, alloc */
+       dapls_cm_release(cm_ptr);
+}

 static void
 dapli_ib_cm_apr_cb (
@@ -147,6 +204,7 @@ dapli_ib_cm_dreq_cb (
     ib_cm_drep_t        cm_drep;
     DAPL_EP             *ep_ptr;
     int                        bail=10;
+    dp_ib_cm_handle_t  cm_ptr;

     dapl_os_assert (p_cm_dreq_rec);

@@ -168,6 +226,14 @@ dapli_ib_cm_dreq_cb (
                       DAPL_MAGIC_EP );
         return;
     }
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr)
+    {
+        dapl_dbg_log (DAPL_DBG_TYPE_ERR,
+                      "--> %s: !CM_PTR on EP %p\n", __FUNCTION__, ep_ptr);
+        return;
+    }
+    dapl_os_assert(cm_ptr->ib_cm.h_qp == p_cm_dreq_rec->h_cm_dreq.h_qp);

     dapl_dbg_log (DAPL_DBG_TYPE_CM,
                   "--> %s() EP %p, %s sent_discreq %s\n",
@@ -210,10 +276,8 @@ dapli_ib_cm_dreq_cb (

     if (ep_ptr->cr_ptr)
     {
-        dapl_os_assert(ep_ptr->ibal_cm_handle->cid
-                                             == p_cm_dreq_rec->h_cm_dreq.cid);
         /* passive side */
-        dapls_cr_callback ( ep_ptr->cm_handle,
+        dapls_cr_callback ( cm_ptr,
                             IB_CME_DISCONNECTED,
                             (void * __ptr64) p_cm_dreq_rec->p_dreq_pdata,
                            IB_DREQ_PDATA_SIZE,
@@ -223,7 +287,7 @@ dapli_ib_cm_dreq_cb (
     {
         /* active side */
         dapl_evd_connection_callback (
-                                  (dp_ib_cm_handle_t) &p_cm_dreq_rec->h_cm_dreq,
+                                  cm_ptr,
                                   IB_CME_DISCONNECTED,
                                   (void * __ptr64)
                                   p_cm_dreq_rec->p_dreq_pdata,
@@ -242,6 +306,7 @@ dapli_ib_cm_drep_cb (
         IN    ib_cm_drep_rec_t          *p_cm_drep_rec )
 {
     DAPL_EP            *ep_ptr;
+    dp_ib_cm_handle_t  cm_ptr;

     dapl_os_assert (p_cm_drep_rec != NULL);

@@ -260,11 +325,19 @@ dapli_ib_cm_drep_cb (
                   "--> %s: BAD EP Handle EP=%lx\n", __FUNCTION__,ep_ptr);
         return;
     }
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr)
+    {
+        dapl_dbg_log (DAPL_DBG_TYPE_ERR,
+                      "--> %s: !CM_PTR on EP %p\n", __FUNCTION__, ep_ptr);
+        return;
+    }
+    dapl_os_assert(cm_ptr->ib_cm.h_qp == p_cm_drep_rec->h_qp);

     dapl_dbg_log (DAPL_DBG_TYPE_CM,
        "--> DiCDpcb: EP %p state %s cm_hdl %p\n",ep_ptr,
                   dapl_get_ep_state_str(ep_ptr->param.ep_state),
-                  ep_ptr->cm_handle);
+                  cm_ptr);

     if ( ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED )
     {
@@ -274,17 +347,10 @@ dapli_ib_cm_drep_cb (
         return;
     }

-    if (ep_ptr->cm_handle == DAPL_IB_INVALID_HANDLE )
-    {
-         dapl_dbg_log (DAPL_DBG_TYPE_CM,
-                  "--> %s: Invalid EP->CM handle?\n", __FUNCTION__);
-        return;
-    }
-
     if (ep_ptr->cr_ptr)
     {
         /* passive connection side */
-        dapls_cr_callback ( ep_ptr->cm_handle,
+        dapls_cr_callback ( cm_ptr,
                             IB_CME_DISCONNECTED,
                            (void * __ptr64) p_cm_drep_rec->p_drep_pdata,
                           IB_DREP_PDATA_SIZE,
@@ -294,7 +360,7 @@ dapli_ib_cm_drep_cb (
     {
         /* active connection side */
         dapl_evd_connection_callback (
-                                   ep_ptr->cm_handle,
+                                   cm_ptr,
                                    IB_CME_DISCONNECTED,
                                    (void * __ptr64) p_cm_drep_rec->p_drep_pdata,
                                   IB_DREP_PDATA_SIZE,
@@ -316,6 +382,7 @@ dapli_ib_cm_rep_cb (
     DAPL_PRIVATE        *prd_ptr;
     DAPL_EP             *ep_ptr;
     dapl_ibal_ca_t      *p_ca;
+    dp_ib_cm_handle_t  cm_ptr;

     dapl_os_assert (p_cm_rep_rec != NULL);

@@ -327,8 +394,17 @@ dapli_ib_cm_rep_cb (
                       __FUNCTION__, ep_ptr);
         return;
     }
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr)
+    {
+        dapl_dbg_log (DAPL_DBG_TYPE_ERR,
+                      "--> %s: !CM_PTR on EP %p\n", __FUNCTION__, ep_ptr);
+        return;
+    }
+    dapl_os_assert(cm_ptr->ib_cm.h_qp == p_cm_rep_rec->h_cm_rep.h_qp);
+
     dapl_dbg_log (DAPL_DBG_TYPE_CM,
-                  "--> DiCRpcb: EP = %lx local_max_rdma_read_in %d\n",
+                  "--> DiCRpcb: EP %lx local_max_rdma_read_in %d\n",
                   ep_ptr, p_cm_rep_rec->resp_res);

     p_ca   = (dapl_ibal_ca_t *)
@@ -372,7 +448,7 @@ dapli_ib_cm_rep_cb (
 #endif

     dapl_evd_connection_callback (
-                            (dp_ib_cm_handle_t)&p_cm_rep_rec->h_cm_rep,
+                            cm_ptr,
                             cm_cb_op,
                             (void *) prd_ptr,
                            IB_REP_PDATA_SIZE,
@@ -386,6 +462,7 @@ dapli_ib_cm_rej_cb (
 {
     DAPL_EP         *ep_ptr;
     ib_cm_events_t  cm_event;
+    dp_ib_cm_handle_t  cm_ptr;

     dapl_os_assert (p_cm_rej_rec);

@@ -397,6 +474,14 @@ dapli_ib_cm_rej_cb (
                       __FUNCTION__, ep_ptr);
         return;
     }
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr)
+    {
+        dapl_dbg_log (DAPL_DBG_TYPE_ERR,
+                      "--> %s: !CM_PTR on EP %p\n", __FUNCTION__, ep_ptr);
+        return;
+    }
+    dapl_os_assert(cm_ptr->ib_cm.h_qp == p_cm_rej_rec->h_qp);

     dapl_dbg_log (DAPL_DBG_TYPE_CM,
                   "--> DiCRjcb: EP = %lx QP = %lx rej reason = 0x%x\n",
@@ -456,7 +541,7 @@ dapli_ib_cm_rej_cb (

     if (ep_ptr->cr_ptr)
     {
-        dapls_cr_callback ( ep_ptr->cm_handle,
+        dapls_cr_callback ( cm_ptr,
                             cm_event,
                             (void * __ptr64) p_cm_rej_rec->p_rej_pdata,
                            IB_REJ_PDATA_SIZE,
@@ -465,7 +550,7 @@ dapli_ib_cm_rej_cb (
     else
     {
         dapl_evd_connection_callback (
-                                   ep_ptr->cm_handle,
+                                   cm_ptr,
                                    cm_event,
                                    (void * __ptr64) p_cm_rej_rec->p_rej_pdata,
                                   IB_REJ_PDATA_SIZE,
@@ -481,12 +566,7 @@ dapli_ib_cm_req_cb ( IN  ib_cm_req_rec_t  *p_cm_req_rec )
 {
     DAPL_SP              *sp_ptr;
     DAT_SOCK_ADDR6       dest_ia_addr;
-    dp_ib_cm_handle_t    cm_handle;
-
-    struct ibal_cr_data {
-        ib_cm_handle_t   cm_hdl;
-        DAT_SOCK_ADDR6   dst_ip_addr;
-    } *crd;
+    dp_ib_cm_handle_t    cm_ptr;

     dapl_os_assert (p_cm_req_rec);

@@ -517,8 +597,8 @@ dapli_ib_cm_req_cb ( IN  ib_cm_req_rec_t  *p_cm_req_rec )
      * EP struct deallocation is where this memory is released or prior in the
      * error case.
      */
-    crd = dapl_os_alloc ( sizeof(struct ibal_cr_data) );
-    if ( !crd )
+    cm_ptr = ibal_cm_alloc();
+    if (!cm_ptr)
     {
         dapl_dbg_log ( DAPL_DBG_TYPE_ERR,
                        "%s: FAILED to alloc IB CM handle storage?\n",
@@ -526,9 +606,6 @@ dapli_ib_cm_req_cb ( IN  ib_cm_req_rec_t  *p_cm_req_rec )
         return;
     }

-    cm_handle = &crd->cm_hdl;
-    dapl_os_memzero ( (void*)crd, sizeof(*crd) );
-
     /*
      * Save the cm_srvc_handle to avoid the race condition between
      * the return of the ib_cm_listen and the notification of a conn req
@@ -577,6 +654,16 @@ dapli_ib_cm_req_cb ( IN  ib_cm_req_rec_t  *p_cm_req_rec )

 #endif /* NO_NAME_SERVICE */

+    /* preserve CR cm handle data */
+    dapl_os_memcpy( (void*)&cm_ptr->ib_cm,
+                    (void*)&p_cm_req_rec->h_cm_req,
+                    sizeof(ib_cm_handle_t));
+
+    /* preserve remote IP address */
+    dapl_os_memcpy( (void*)&cm_ptr->dst_ip_addr,
+                    (void*)&dest_ia_addr,
+                    sizeof(dest_ia_addr));
+
 #if defined(DAPL_DBG)
     {
         char ipa[20];
@@ -584,23 +671,13 @@ dapli_ib_cm_req_cb ( IN  ib_cm_req_rec_t  *p_cm_req_rec )
         //rval = ((struct sockaddr_in *) (&dest_ia_addr))->sin_addr.s_addr;

         dapl_dbg_log (DAPL_DBG_TYPE_CM|DAPL_DBG_TYPE_CALLBACK,
-                      "%s: query SA for RemoteAddr: %s\n",
-                      __FUNCTION__,
-                      dapli_get_ip_addr_str( (DAT_SOCK_ADDR6*)
-                                                         &dest_ia_addr, ipa) );
+                      "%s: query SA (CM %lx)->dst_ip_addr: %s\n",
+                      __FUNCTION__,cm_ptr,
+                      dapli_get_ip_addr_str(
+                               (DAT_SOCK_ADDR6*) &cm_ptr->dst_ip_addr, ipa) );
     }
 #endif

-    /* preserve CR cm handle data */
-    dapl_os_memcpy( (void*)cm_handle,
-                    (void*)&p_cm_req_rec->h_cm_req,
-                    sizeof(ib_cm_handle_t) );
-
-    /* preserve remote IP address */
-    dapl_os_memcpy( (void*)&crd->dst_ip_addr,
-                    (void*)&dest_ia_addr,
-                    sizeof(dest_ia_addr) );
-
     /* FIXME - Vu
      * We have NOT used/saved the primary and alternative path record
      * ie. p_cm_req_rec->p_primary_path and p_cm_req_rec->p_alt_path
@@ -614,10 +691,10 @@ dapli_ib_cm_req_cb ( IN  ib_cm_req_rec_t  *p_cm_req_rec )
                   __FUNCTION__, sp_ptr, p_cm_req_rec->resp_res,
                   p_cm_req_rec->p_req_pdata);

-    dapls_cr_callback ( cm_handle,
+    dapls_cr_callback ( cm_ptr,
                         IB_CME_CONNECTION_REQUEST_PENDING,
                         (void * __ptr64) p_cm_req_rec->p_req_pdata,
-                       IB_REQ_PDATA_SIZE,
+                                               IB_REQ_PDATA_SIZE,
                         (void * __ptr64) sp_ptr );
 }

@@ -627,7 +704,7 @@ dapli_ib_cm_mra_cb (
         IN    ib_cm_mra_rec_t          *p_cm_mra_rec )
 {
        UNUSED_PARAM( p_cm_mra_rec );
-    dapl_dbg_log (DAPL_DBG_TYPE_CM | DAPL_DBG_TYPE_CALLBACK,
+       dapl_dbg_log (DAPL_DBG_TYPE_CM | DAPL_DBG_TYPE_CALLBACK,
                        "--> DiCMcb: CM callback MRA\n");
 }

@@ -635,7 +712,8 @@ static void
 dapli_ib_cm_rtu_cb (
         IN    ib_cm_rtu_rec_t          *p_cm_rtu_rec )
 {
-    DAPL_EP         *ep_ptr;
+    DAPL_EP            *ep_ptr;
+    dp_ib_cm_handle_t  cm_ptr;

     dapl_os_assert (p_cm_rtu_rec != NULL);

@@ -647,9 +725,18 @@ dapli_ib_cm_rtu_cb (
                       __FUNCTION__, ep_ptr);
         return;
     }
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr)
+    {
+        dapl_dbg_log (DAPL_DBG_TYPE_ERR,
+                      "--> %s: !CM_PTR on EP %p\n", __FUNCTION__, ep_ptr);
+        return;
+    }
+    dapl_os_assert(cm_ptr->ib_cm.h_qp == p_cm_rtu_rec->h_qp);

     dapl_dbg_log (DAPL_DBG_TYPE_CM | DAPL_DBG_TYPE_CALLBACK,
-                  "--> DiCRucb: EP %lx QP %lx\n", ep_ptr, ep_ptr->qp_handle);
+                  "--> DiCRucb: EP %lx QP %lx CR %lx\n",
+                  ep_ptr, ep_ptr->qp_handle, ep_ptr->cr_ptr);

     if (ep_ptr->cr_ptr)
     {
@@ -657,7 +744,8 @@ dapli_ib_cm_rtu_cb (

         sp_ptr = ((DAPL_CR *) ep_ptr->cr_ptr)->sp_ptr;

-        dapls_cr_callback ( ep_ptr->cm_handle,
+        /* passive connection side */
+        dapls_cr_callback ( cm_ptr,
                             IB_CME_CONNECTED,
                             (void * __ptr64) p_cm_rtu_rec->p_rtu_pdata,
                             IB_RTU_PDATA_SIZE,
@@ -667,7 +755,7 @@ dapli_ib_cm_rtu_cb (
     else
     {
         dapl_evd_connection_callback (
-                            ep_ptr->cm_handle,
+                            cm_ptr,
                             IB_CME_CONNECTED,
                             (void * __ptr64) p_cm_rtu_rec->p_rtu_pdata,
                            IB_RTU_PDATA_SIZE,
@@ -698,18 +786,21 @@ dapls_ib_cm_remote_addr (
 {

     DAPL_HEADER        *header;
-    void               *vp;
+    dp_ib_cm_handle_t  cm;
     char               ipa[20];
+    char               *rtype;

     header = (DAPL_HEADER *)dat_handle;

     if (header->magic == DAPL_MAGIC_EP)
     {
-       vp = &((DAPL_EP *) dat_handle)->remote_ia_address;
+       cm = dapl_get_cm_from_ep((DAPL_EP *)dat_handle);
+       rtype = "EP";
     }
     else if (header->magic == DAPL_MAGIC_CR)
     {
-       vp = &((DAPL_CR *) dat_handle)->remote_ia_address;
+       cm = ((DAPL_CR *) dat_handle)->ib_cm_handle;
+       rtype = "CR";
     }
     else
     {
@@ -719,10 +810,10 @@ dapls_ib_cm_remote_addr (
        return DAT_INVALID_HANDLE;
     }

-    dapl_os_memcpy( remote_address, vp, sizeof(DAT_SOCK_ADDR6) );
+    dapl_os_memcpy( remote_address, &cm->dst_ip_addr, sizeof(DAT_SOCK_ADDR6) );

-    dapl_dbg_log ( DAPL_DBG_TYPE_CM, "%s: returns %s\n",
-                   __FUNCTION__,
+    dapl_dbg_log ( DAPL_DBG_TYPE_CM, "%s: returns %s remote Addrs %s\n",
+                   __FUNCTION__, rtype,
                    dapli_get_ip_addr_str((DAT_SOCK_ADDR6*)remote_address,ipa) );

     return DAT_SUCCESS;
@@ -1011,7 +1102,8 @@ dapls_ib_disconnect ( IN   DAPL_EP           *ep_ptr,
                       IN   DAT_CLOSE_FLAGS   disconnect_flags )
 {
     ib_api_status_t    ib_status = IB_SUCCESS;
-    ib_cm_dreq_t                   cm_dreq;
+    ib_cm_dreq_t       cm_dreq;
+    dp_ib_cm_handle_t  cm_ptr;

     dapl_os_assert(ep_ptr);

@@ -1021,14 +1113,14 @@ dapls_ib_disconnect ( IN   DAPL_EP           *ep_ptr,
                   "--> %s: BAD EP Magic EP=%lx\n", __FUNCTION__,ep_ptr);
         return DAT_SUCCESS;
     }
-
-    if (ep_ptr->cm_handle == DAPL_IB_INVALID_HANDLE )
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr)
     {
-         dapl_dbg_log (DAPL_DBG_TYPE_CM,
-                  "--> %s: Invalid EP->CM handle, OK.\n", __FUNCTION__);
+        dapl_dbg_log (DAPL_DBG_TYPE_ERR,
+                      "--> %s: !CM_PTR on EP %p\n", __FUNCTION__, ep_ptr);
         return DAT_SUCCESS;
     }
-
+
     dapl_dbg_log (DAPL_DBG_TYPE_CM,
        "--> %s() EP %p %s rx_drq %d tx_drq %d Close %s\n", __FUNCTION__,
        ep_ptr, dapl_get_ep_state_str(ep_ptr->param.ep_state),
@@ -1314,12 +1406,12 @@ dapls_ib_reject_connection ( IN  dp_ib_cm_handle_t   ib_cm_handle,
     dapli_print_private_data("DsRjC",private_data,private_data_size);
 #endif

-    ib_status = ib_cm_rej ( *ib_cm_handle, &cm_rej);
+    ib_status = ib_cm_rej(ib_cm_handle->ib_cm, &cm_rej);

     if (ib_status != IB_SUCCESS)
     {
         dapl_dbg_log ( DAPL_DBG_TYPE_ERR,
-                       "--> DsRjC: cm_handle %lx reject failed %s\n",
+                       "--> DsRjC: cm_handle %p reject failed %s\n",
                        ib_cm_handle, ib_get_err_str(ib_status) );
     }

@@ -1390,6 +1482,7 @@ dapls_ib_accept_connection (
     dapl_ibal_port_t       *p_active_port;
     ib_cm_rep_t            cm_rep;
     ib_qp_attr_t           qpa;
+    dp_ib_cm_handle_t      cm_ptr;

     cr_ptr = (DAPL_CR *) cr_handle;
     ep_ptr = (DAPL_EP *) ep_handle;
@@ -1426,28 +1519,36 @@ dapls_ib_accept_connection (
     }

     cr_ptr->param.local_ep_handle = ep_handle;
-    ep_ptr->cm_handle             = cr_ptr->ib_cm_handle;
+
     /*
      * assume ownership, in that once the EP is released the dynamic
      * memory containing the IBAL CM handle (ib_cm_handle_t) struct will
      * be released; see dapl_ep_dealloc().
      */
-    ep_ptr->ibal_cm_handle        = cr_ptr->ib_cm_handle;
-
+
+    /* EP-CM, save/release CR CM object, use EP CM object already linked */
+    cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+    if (!cm_ptr) {
+       dapl_dbg_log ( DAPL_DBG_TYPE_ERR,
+                       "--> DsIBAC: CM linking to EP %p not available\n",
+                       ep_ptr);
+       return (DAT_INVALID_STATE);
+    }
+
     /* set remote IP addr fields. IP addr data is deduced from Connection
      * Request record (gid/lib) and stashed away for use here. DAPL 1.1
      * had an interface for passing the IP info down, interface went away
      * in 2.0?
      */
     dapl_os_memcpy( (void*)&ep_ptr->remote_ia_address,
-                    (void*)(ep_ptr->cm_handle+1),
+                    (void*)&cr_ptr->ib_cm_handle->dst_ip_addr,
                     sizeof(DAT_SOCK_ADDR6) );

     dapl_os_memcpy( (void*)&cr_ptr->remote_ia_address,
                     (void*)&ep_ptr->remote_ia_address,
                     sizeof(DAT_SOCK_ADDR6) );

-#if defined(DAPL_DBG) && 0
+#if defined(DAPL_DBG)
     {
         char ipa[20];

@@ -1455,11 +1556,21 @@ dapls_ib_accept_connection (
                       "%s: EP(%lx) RemoteAddr: %s\n",
                       __FUNCTION__, ep_ptr,
                      dapli_get_ip_addr_str(
-                             (DAT_SOCK_ADDR6*)&ep_ptr->remote_ia_address, ipa));
+                            (DAT_SOCK_ADDR6*)&ep_ptr->remote_ia_address, ipa) );
     }
 #endif

-    ep_ptr->qp_state      = IB_QPS_INIT;
+    dapl_os_memcpy( (void*)&cm_ptr->dst_ip_addr,
+                    (void*)&cr_ptr->ib_cm_handle->dst_ip_addr,
+                    sizeof(DAT_SOCK_ADDR6) );
+
+    /* get h_al and connection ID from CR CM object, h_qp already set */
+    cm_ptr->ib_cm.cid = cr_ptr->ib_cm_handle->ib_cm.cid;
+    cm_ptr->ib_cm.h_al = cr_ptr->ib_cm_handle->ib_cm.h_al;
+    dapls_cm_release(cr_ptr->ib_cm_handle);
+
+    cr_ptr->ib_cm_handle = cm_ptr; /* for dapli_get_sp_ep() upcall */
+
     ep_ptr->cr_ptr        = cr_ptr;

     dapl_os_memzero ( (void*)&cm_rep, sizeof (ib_cm_rep_t) );
@@ -1526,19 +1637,13 @@ dapls_ib_accept_connection (
                 cm_rep.access_ctrl, cm_rep.init_depth,cm_rep.qp_type,
                  dapls_cb_pending(&ep_ptr->req_buffer));

-    ib_status = ib_cm_rep ( *ep_ptr->cm_handle, &cm_rep );
+    ib_status = ib_cm_rep ( cm_ptr->ib_cm, &cm_rep );

     if (ib_status != IB_SUCCESS)
     {
        dapl_dbg_log ( DAPL_DBG_TYPE_ERR,
                        "--> DsIBAC: EP %lx QP %lx CR reply failed '%s'\n",
                        ep_ptr, ep_ptr->qp_handle, ib_get_err_str(ib_status) );
-
-        /* errors not perculated back to CR callback which allocated the
-         * memory, free it here on error.
-         */
-        dapl_os_free ( (void*)ep_ptr->ibal_cm_handle, sizeof(ib_cm_handle_t) );
-        ep_ptr->ibal_cm_handle = NULL;
     }

     return ( dapl_ib_status_convert ( ib_status ) );
@@ -1589,11 +1694,6 @@ dapls_ib_disconnect_clean (

     ep_ptr->sent_discreq = DAT_FALSE;
     ep_ptr->recv_discreq = DAT_FALSE;
-    if ( ep_ptr->ibal_cm_handle )
-    {
-        dapl_os_free ( (void*)ep_ptr->ibal_cm_handle, sizeof(ib_cm_handle_t) );
-    }
-    ep_ptr->ibal_cm_handle = NULL;

     /*
      * Query the QP to get the current state */
@@ -1653,7 +1753,7 @@ dapls_ib_cr_handoff (

     cr_ptr = (DAPL_CR *) cr_handle;

-    if (cr_ptr->ib_cm_handle->cid == 0xFFFFFFFF)
+    if (cr_ptr->ib_cm_handle->ib_cm.cid == 0xFFFFFFFF)
     {
         dapl_dbg_log ( DAPL_DBG_TYPE_ERR,
                        "--> DsCH: CR = %lx invalid cm handle\n", cr_ptr);
@@ -1667,7 +1767,7 @@ dapls_ib_cr_handoff (
         return DAT_INVALID_PARAMETER;
     }

-    ib_status = ib_cm_handoff (*cr_ptr->ib_cm_handle, handoff_serv_id);
+    ib_status = ib_cm_handoff (cr_ptr->ib_cm_handle->ib_cm, handoff_serv_id);

     if (ib_status != IB_SUCCESS)
     {
diff --git a/dapl/ibal/dapl_ibal_qp.c b/dapl/ibal/dapl_ibal_qp.c
index cc8c394..f52f5da 100644
--- a/dapl/ibal/dapl_ibal_qp.c
+++ b/dapl/ibal/dapl_ibal_qp.c
@@ -24,6 +24,7 @@
 #include "dapl_adapter_util.h"
 #include "dapl_evd_util.h"
 #include "dapl_ibal_util.h"
+#include "dapl_ep_util.h"

 #define DAPL_IBAL_QKEY              0
 #define DAPL_IBAL_START_PSN         0
@@ -133,7 +134,8 @@ dapls_ib_qp_alloc (
     ib_cq_handle_t        cq_send;
     dapl_ibal_ca_t        *p_ca;
     dapl_ibal_port_t      *p_active_port;
-    ib_qp_attr_t           qp_attr;
+    ib_qp_attr_t          qp_attr;
+    dp_ib_cm_handle_t     cm_ptr;

     attr = &ep_ptr->param.ep_attr;

@@ -241,6 +243,16 @@ dapls_ib_qp_alloc (
                       ib_get_err_str(ib_status));
        return (DAT_INSUFFICIENT_RESOURCES);
     }
+    /* EP-CM linking */
+    cm_ptr = ibal_cm_alloc();
+    if (!cm_ptr)
+    {
+       dapl_dbg_log (DAPL_DBG_TYPE_ERR, "--> DsQA: Create CM failed\n");
+       return (DAT_INSUFFICIENT_RESOURCES);
+    }
+    cm_ptr->ib_cm.h_qp = ep_ptr->qp_handle;
+    cm_ptr->ep = ep_ptr;
+    dapl_ep_link_cm(ep_ptr, cm_ptr);

     dapl_dbg_log (DAPL_DBG_TYPE_EP, "--> DsQA: EP=%p, tEVD=%p, rEVD=%p QP=%p\n",
                   ep_ptr, ep_ptr->param.request_evd_handle,
diff --git a/dapl/ibal/dapl_ibal_util.h b/dapl/ibal/dapl_ibal_util.h
index a73d6c1..e28bdbe 100644
--- a/dapl/ibal/dapl_ibal_util.h
+++ b/dapl/ibal/dapl_ibal_util.h
@@ -39,8 +39,28 @@
 typedef  struct ib_cm_handle           *dp_ib_cm_handle_t;
 typedef  struct ib_cm_handle           *ib_cm_srvc_handle_t;
 #else
-typedef  ib_cm_handle_t                *dp_ib_cm_handle_t;
+
+/* EP-CM linking requires list_entry, protected ref counting */
+typedef struct dapl_ibal_cm
+{
+       struct dapl_llist_entry list_entry;
+       DAPL_OS_LOCK            lock;
+       int                     ref_count;
+       DAT_SOCK_ADDR6          dst_ip_addr;
+       ib_cm_handle_t          ib_cm;  /* h_al, h_qp, cid */
+       DAPL_EP                 *ep;
+
+} dapl_ibal_cm_t;
+
+typedef  dapl_ibal_cm_t                *dp_ib_cm_handle_t;
 typedef  ib_listen_handle_t            ib_cm_srvc_handle_t;
+
+/* EP-CM linking prototypes */
+extern void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr);
+extern void dapls_cm_release(dp_ib_cm_handle_t cm_ptr);
+extern void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);
+extern dp_ib_cm_handle_t ibal_cm_alloc(void);
+
 #endif

 typedef  ib_net64_t                    IB_HCA_NAME;
@@ -543,7 +563,6 @@ dapli_find_evd_cb_by_context(
 extern IB_HCA_NAME
 dapl_ib_convert_name(IN  char    *name);

-
 STATIC _INLINE_ int32_t
 dapli_ibal_convert_privileges (IN  DAT_MEM_PRIV_FLAGS  privileges )
 {
diff --git a/dapl/ibal/udapl.rc b/dapl/ibal/udapl.rc
index 7c2505a..e5fc1ac 100644
--- a/dapl/ibal/udapl.rc
+++ b/dapl/ibal/udapl.rc
@@ -36,11 +36,11 @@
 #define VER_FILESUBTYPE                        VFT2_UNKNOWN

 #if DBG
-#define VER_FILEDESCRIPTION_STR                "Direct Access Provider Library v2.0 (Debug)"
+#define VER_FILEDESCRIPTION_STR                "Direct Access Provider Library v2.0 (IBAL) (Debug)"
 #define VER_INTERNALNAME_STR           "dapl2d.dll"
 #define VER_ORIGINALFILENAME_STR       "dapl2d.dll"
 #else
-#define VER_FILEDESCRIPTION_STR                "Direct Access Provider Library v2.0"
+#define VER_FILEDESCRIPTION_STR                "Direct Access Provider Library v2.0 (IBAL)"
 #define VER_INTERNALNAME_STR           "dapl2.dll"
 #define VER_ORIGINALFILENAME_STR       "dapl2.dll"
 #endif
diff --git a/dapl/include/dapl.h b/dapl/include/dapl.h
index 208113b..8dab61e 100755
--- a/dapl/include/dapl.h
+++ b/dapl/include/dapl.h
@@ -472,7 +472,6 @@ struct dapl_ep
 #if defined(_WIN32) || defined(_WIN64)
     DAT_BOOLEAN         recv_discreq;
     DAT_BOOLEAN         sent_discreq;
-    dp_ib_cm_handle_t   ibal_cm_handle;
 #endif
 #ifdef DAPL_COUNTERS
     void               *cntrs;
--
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
