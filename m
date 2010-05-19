From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/12] dapl-2.0: scm: new cm_ep linking broke UD mode over
 socket cm
Date: Wed, 19 May 2010 11:11:33 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C701308B@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add EP locking around modify_qp for EP state.
Add new dapli_ep_check for debugging EP
Cleanup extra CR's
Change socket errno to dapl_socket_errno() abstraction

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |  177 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 128 insertions(+), 49 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 6958b67..b6ffbe9 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -60,6 +60,48 @@
 #include "dapl_ep_util.h"
 #include "dapl_osd.h"

+#ifdef DAPL_DBG
+/* Check for EP linking to IA and proper connect state */
+void dapli_ep_check(DAPL_EP *ep)
+{
+       DAPL_IA *ia_ptr = ep->header.owner_ia;
+       DAPL_EP *ep_ptr, *next_ep_ptr;
+       int found = 0;
+
+       dapl_os_lock(&ia_ptr->header.lock);
+       ep_ptr = (dapl_llist_is_empty (&ia_ptr->ep_list_head)
+               ? NULL : dapl_llist_peek_head (&ia_ptr->ep_list_head));
+
+       while (ep_ptr != NULL) {
+               next_ep_ptr =
+                       dapl_llist_next_entry(&ia_ptr->ep_list_head,
+                                             &ep_ptr->header.ia_list_entry);
+               if (ep == ep_ptr) {
+                       found++;
+                       if ((ep->cr_ptr && ep->param.ep_state
+                               != DAT_EP_STATE_COMPLETION_PENDING) ||
+                           (!ep->cr_ptr && ep->param.ep_state
+                               != DAT_EP_STATE_ACTIVE_CONNECTION_PENDING))
+                               goto err;
+                       else
+                               goto match;
+               }
+               ep_ptr = next_ep_ptr;
+       }
+err:
+       dapl_log(DAPL_DBG_TYPE_ERR,
+                " dapli_ep_check ERR: %s %s ep=%p state=%d magic=0x%x\n",
+                ep->cr_ptr ? "PASSIVE":"ACTIVE",
+                found ? "WRONG_STATE":"NOT_FOUND" ,
+                ep, ep->param.ep_state, ep->header.magic);
+match:
+       dapl_os_unlock(&ia_ptr->header.lock);
+       return;
+}
+#else
+#define dapli_ep_check(ep)
+#endif
+
 #if defined(_WIN32) || defined(_WIN64)
 enum DAPL_FD_EVENTS {
        DAPL_FD_READ = 0x1,
@@ -311,13 +353,13 @@ void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr)
 void dapls_cm_release(dp_ib_cm_handle_t cm_ptr)
 {
        dapl_os_lock(&cm_ptr->lock);
-       cm_ptr->ref_count--;
-       if (cm_ptr->ref_count) {
-                dapl_os_unlock(&cm_ptr->lock);
-               return;
-       }
-       dapl_os_unlock(&cm_ptr->lock);
-       dapli_cm_dealloc(cm_ptr);
+       cm_ptr->ref_count--;
+       if (cm_ptr->ref_count) {
+                dapl_os_unlock(&cm_ptr->lock);
+               return;
+       }
+       dapl_os_unlock(&cm_ptr->lock);
+       dapli_cm_dealloc(cm_ptr);
 }

 static dp_ib_cm_handle_t dapli_cm_alloc(DAPL_EP *ep_ptr)
@@ -416,7 +458,9 @@ DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr)
        dapl_os_unlock(&cm_ptr->lock);

        /* send disc date, close socket, schedule destroy */
+       dapl_os_lock(&cm_ptr->ep->header.lock);
        dapls_modify_qp_state(cm_ptr->ep->qp_handle, IBV_QPS_ERR, 0,0,0);
+       dapl_os_unlock(&cm_ptr->ep->header.lock);
        send(cm_ptr->socket, (char *)&disc_data, sizeof(disc_data), 0);

        /* disconnect events for RC's only */
@@ -452,7 +496,7 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
                dapl_log(DAPL_DBG_TYPE_ERR,
                         " CONN_PENDING: %s ERR %s -> %s %d\n",
                         err == -1 ? "POLL" : "SOCKOPT",
-                        err == -1 ? strerror(errno) : strerror(err),
+                        err == -1 ? strerror(dapl_socket_errno()) : strerror(err),
                         inet_ntoa(((struct sockaddr_in *)
                                &cm_ptr->addr)->sin_addr),
                         ntohs(((struct sockaddr_in *)
@@ -475,9 +519,10 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
        }

        if (len != (exp + ntohs(cm_ptr->msg.p_size))) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CONN_PENDING len ERR %s, wcnt=%d(%d) -> %s\n",
-                        strerror(errno), len,
+                        " CONN_PENDING len ERR 0x%x %s, wcnt=%d(%d) -> %s\n",
+                        err, strerror(err), len,
                         exp + ntohs(cm_ptr->msg.p_size),
                         inet_ntoa(((struct sockaddr_in *)
                                   ep_ptr->param.
@@ -530,16 +575,19 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        /* create, connect, sockopt, and exchange QP information */
        if ((cm_ptr->socket =
             socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == DAPL_INVALID_SOCKET) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " connect: socket create ERR %s\n", strerror(errno));
+                        " connect: socket create ERR 0x%x %s\n",
+                        err, strerror(err));
                goto bail;
        }

        ret = dapl_config_socket(cm_ptr->socket);
        if (ret < 0) {
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " connect: config socket %d ERR %d %s\n",
-                        cm_ptr->socket, ret, strerror(dapl_socket_errno()));
+                        " connect: config socket %d RET %d ERR 0x%x %s\n",
+                        cm_ptr->socket, ret,
+                        dapl_socket_errno(), strerror(dapl_socket_errno()));
                dat_ret = DAT_INTERNAL_ERROR;
                goto bail;
        }
@@ -556,6 +604,10 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        ret = dapl_connect_socket(cm_ptr->socket, (struct sockaddr *)&cm_ptr->addr,
                                  sizeof(cm_ptr->addr));
        if (ret && ret != EAGAIN) {
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " connect: dapl_connect_socket RET %d ERR 0x%x %s\n",
+                        ret, dapl_socket_errno(),
+                        strerror(dapl_socket_errno()));
                dat_ret = DAT_INVALID_ADDRESS;
                goto bail;
        }
@@ -572,9 +624,10 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        /* get local address information from socket */
        sl = sizeof(cm_ptr->msg.daddr.so);
        if (getsockname(cm_ptr->socket, (struct sockaddr *)&cm_ptr->msg.daddr.so, &sl)) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_ERR,
-                       " connect getsockname ERROR: %s -> %s r_qual %d\n",
-                       strerror(errno),
+                       " connect getsockname ERROR: 0x%x %s -> %s r_qual %d\n",
+                       err, strerror(err),
                        inet_ntoa(((struct sockaddr_in *)r_addr)->sin_addr),
                        (unsigned int)r_qual);;
        }
@@ -604,8 +657,7 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        return DAT_SUCCESS;
 bail:
        dapl_log(DAPL_DBG_TYPE_ERR,
-                " connect ERROR: %s -> %s r_qual %d\n",
-                strerror(errno),
+                " connect ERROR: -> %s r_qual %d\n",
                 inet_ntoa(((struct sockaddr_in *)r_addr)->sin_addr),
                 (unsigned int)r_qual);

@@ -629,9 +681,10 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)

        len = recv(cm_ptr->socket, (char *)&cm_ptr->msg, exp, 0);
        if (len != exp || ntohs(cm_ptr->msg.ver) != DCM_VER) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_WARN,
-                        " CONN_RTU read: sk %d ERR %s, rcnt=%d, v=%d -> %s PORT L-%x R-%x PID L-%x R-%x\n",
-                        cm_ptr->socket, strerror(errno), len, ntohs(cm_ptr->msg.ver),
+                        " CONN_RTU read: sk %d ERR 0x%x, rcnt=%d, v=%d -> %s PORT L-%x R-%x PID L-%x R-%x\n",
+                        cm_ptr->socket, err, len, ntohs(cm_ptr->msg.ver),
                         inet_ntoa(((struct sockaddr_in *)&cm_ptr->addr)->sin_addr),
                         ntohs(((struct sockaddr_in *)&cm_ptr->msg.daddr.so)->sin_port),
                         ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port),
@@ -639,7 +692,7 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                         ntohs(*(uint16_t*)&cm_ptr->msg.resv[2]));

                /* Retry; corner case where server tcp stack resets under load */
-               if (dapl_socket_errno() == ECONNRESET) {
+               if (err == ECONNRESET) {
                        closesocket(cm_ptr->socket);
                        cm_ptr->socket = DAPL_INVALID_SOCKET;
                        dapli_socket_connect(cm_ptr->ep, (DAT_IA_ADDRESS_PTR)&cm_ptr->addr,
@@ -692,9 +745,10 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
        if (exp) {
                len = recv(cm_ptr->socket, cm_ptr->msg.p_data, exp, 0);
                if (len != exp) {
+                       int err = dapl_socket_errno();
                        dapl_log(DAPL_DBG_TYPE_ERR,
-                                " CONN_RTU read pdata: ERR %s, rcnt=%d -> %s\n",
-                                strerror(errno), len,
+                                " CONN_RTU read pdata: ERR 0x%x %s, rcnt=%d -> %s\n",
+                                err, strerror(err), len,
                                 inet_ntoa(((struct sockaddr_in *)
                                            ep_ptr->param.
                                            remote_ia_address_ptr)->sin_addr));
@@ -721,6 +775,7 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
        }

        /* modify QP to RTR and then to RTS with remote info */
+       dapl_os_lock(&ep_ptr->header.lock);
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
                                  IBV_QPS_RTR,
                                  cm_ptr->msg.saddr.ib.qpn,
@@ -736,6 +791,7 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                                    &cm_ptr->msg.daddr.so)->sin_addr),
                         ntohs(((struct sockaddr_in *)
                                 &cm_ptr->msg.daddr.so)->sin_port));
+               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
@@ -753,16 +809,20 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                                    &cm_ptr->msg.daddr.so)->sin_addr),
                         ntohs(((struct sockaddr_in *)
                                 &cm_ptr->msg.daddr.so)->sin_port));
+               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
+       dapl_os_unlock(&ep_ptr->header.lock);
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " connect_rtu: send RTU\n");

        /* complete handshake after final QP state change, Just ver+op */
        cm_ptr->state = DCM_CONNECTED;
        cm_ptr->msg.op = ntohs(DCM_RTU);
        if (send(cm_ptr->socket, (char *)&cm_ptr->msg, 4, 0) == -1) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CONN_RTU: write error = %s\n", strerror(errno));
+                        " CONN_RTU: write ERR = 0x%x %s\n",
+                        err, strerror(err));
                goto bail;
        }
        /* post the event with private data */
@@ -821,6 +881,7 @@ ud_bail:
        } else
 #endif
        {
+               dapli_ep_check(cm_ptr->ep);
                dapl_evd_connection_callback(cm_ptr, event, cm_ptr->msg.p_data,
                                             DCM_MAX_PDATA_SIZE, ep_ptr);
        }
@@ -848,7 +909,7 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
        struct sockaddr_in addr;
        ib_cm_srvc_handle_t cm_ptr = NULL;
        DAT_RETURN dat_status = DAT_SUCCESS;
-       int opt = 1;
+       int opt = 1;

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " setup listen(ia_ptr %p ServiceID %d sp_ptr %p)\n",
@@ -864,23 +925,26 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
        /* bind, listen, set sockopt, accept, exchange data */
        if ((cm_ptr->socket =
             socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == DAPL_INVALID_SOCKET) {
-               dapl_log(DAPL_DBG_TYPE_ERR, " ERR: listen socket create: %s\n",
-                        strerror(errno));
+               int err = dapl_socket_errno();
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " listen: socket create: ERR 0x%x %s\n",
+                        err, strerror(err));
                dat_status = DAT_INSUFFICIENT_RESOURCES;
                goto bail;
        }

-       setsockopt(cm_ptr->socket, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));
+       setsockopt(cm_ptr->socket, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));
        addr.sin_port = htons(serviceID + 1000);
        addr.sin_family = AF_INET;
        addr.sin_addr = ((struct sockaddr_in *) &ia_ptr->hca_ptr->hca_address)->sin_addr;

        if ((bind(cm_ptr->socket, (struct sockaddr *)&addr, sizeof(addr)) < 0)
            || (listen(cm_ptr->socket, 128) < 0)) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_CM,
-                        " listen: ERROR %s on port %d\n",
-                        strerror(errno), serviceID + 1000);
-               if (dapl_socket_errno() == EADDRINUSE)
+                        " listen: ERROR 0x%x %s on port %d\n",
+                        err, strerror(err), serviceID + 1000);
+               if (err == EADDRINUSE)
                        dat_status = DAT_CONN_QUAL_IN_USE;
                else
                        dat_status = DAT_CONN_QUAL_UNAVAILABLE;
@@ -933,9 +997,10 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
                                        &acm_ptr->msg.daddr.so,
                                        (socklen_t *) &len);
                if (acm_ptr->socket == DAPL_INVALID_SOCKET) {
+                       int err = dapl_socket_errno();
                        dapl_log(DAPL_DBG_TYPE_ERR,
-                               " ACCEPT: ERR %s on FD %d l_cr %p\n",
-                               strerror(errno), cm_ptr->socket, cm_ptr);
+                               " ACCEPT: ERR 0x%x %s on FD %d l_cr %p\n",
+                               err, strerror(err), cm_ptr->socket, cm_ptr);
                        dapls_cm_release(acm_ptr);
                        return;
                }
@@ -948,11 +1013,14 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
                /* no delay for small packets */
                ret = setsockopt(acm_ptr->socket, IPPROTO_TCP, TCP_NODELAY,
                           (char *)&opt, sizeof(opt));
-               if (ret)
+               if (ret) {
+                       int err = dapl_socket_errno();
                        dapl_log(DAPL_DBG_TYPE_ERR,
-                                " ACCEPT: NODELAY setsockopt: 0x%x 0x%x %s\n",
-                                ret, dapl_socket_errno(), strerror(dapl_socket_errno()));
-
+                                " ACCEPT: NODELAY setsockopt:"
+                                " RET %d ERR 0x%x %s\n",
+                                ret, err, strerror(err));
+               }
+
                /* get local address information from socket */
                sl = sizeof(acm_ptr->addr);
                getsockname(acm_ptr->socket, (struct sockaddr *)&acm_ptr->addr, &sl);
@@ -975,9 +1043,10 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
        /* read in DST QP info, IA address. check for private data */
        len = recv(acm_ptr->socket, (char *)&acm_ptr->msg, exp, 0);
        if (len != exp || ntohs(acm_ptr->msg.ver) != DCM_VER) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " ACCEPT read: ERR %s, rcnt=%d, ver=%d\n",
-                        strerror(errno), len, ntohs(acm_ptr->msg.ver));
+                        " ACCEPT read: ERR 0x%x %s, rcnt=%d, ver=%d\n",
+                        err, strerror(err), len, ntohs(acm_ptr->msg.ver));
                goto bail;
        }

@@ -996,9 +1065,10 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
        if (exp) {
                len = recv(acm_ptr->socket, acm_ptr->msg.p_data, exp, 0);
                if (len != exp) {
+                       int err = dapl_socket_errno();
                        dapl_log(DAPL_DBG_TYPE_ERR,
-                                " accept read pdata: ERR %s, rcnt=%d\n",
-                                strerror(errno), len);
+                                " accept read pdata: ERR 0x%x %s, rcnt=%d\n",
+                                err, strerror(err), len);
                        goto bail;
                }
                p_data = acm_ptr->msg.p_data;
@@ -1092,6 +1162,7 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 #endif

        /* modify QP to RTR and then to RTS with remote info already read */
+       dapl_os_lock(&ep_ptr->header.lock);
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
                                  IBV_QPS_RTR,
                                  cm_ptr->msg.saddr.ib.qpn,
@@ -1102,6 +1173,7 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                         strerror(errno),
                         inet_ntoa(((struct sockaddr_in *)
                                     &cm_ptr->msg.daddr.so)->sin_addr));
+               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
        if (dapls_modify_qp_state(ep_ptr->qp_handle,
@@ -1114,8 +1186,10 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                         strerror(errno),
                         inet_ntoa(((struct sockaddr_in *)
                                     &cm_ptr->msg.daddr.so)->sin_addr));
+               dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
+       dapl_os_unlock(&ep_ptr->header.lock);

        /* save remote address information */
        dapl_os_memcpy(&ep_ptr->remote_ia_address,
@@ -1143,6 +1217,10 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
        cm_ptr->hca = ia_ptr->hca_ptr;
        cm_ptr->state = DCM_ACCEPTED;

+       /* Link CM to EP, already queued on work thread */
+       dapl_ep_link_cm(ep_ptr, cm_ptr);
+       cm_ptr->ep = ep_ptr;
+
        local.p_size = htons(p_size);
        iov[0].iov_base = (void *)&local;
        iov[0].iov_len = exp;
@@ -1155,11 +1233,14 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                len = writev(cm_ptr->socket, iov, 1);

        if (len != (p_size + exp)) {
+               int err = dapl_socket_errno();
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " ACCEPT_USR: ERR %s, wcnt=%d -> %s\n",
-                        strerror(errno), len,
+                        " ACCEPT_USR: ERR 0x%x %s, wcnt=%d -> %s\n",
+                        err, strerror(err), len,
                         inet_ntoa(((struct sockaddr_in *)
                                   &cm_ptr->msg.daddr.so)->sin_addr));
+               dapl_ep_unlink_cm(ep_ptr, cm_ptr);
+               cm_ptr->ep = NULL;
                goto bail;
        }

@@ -1176,9 +1257,6 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,

        dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: accepted!\n");

-       /* Link CM to EP, already queued on work thread */
-       dapl_ep_link_cm(ep_ptr, cm_ptr);
-       cm_ptr->ep = ep_ptr;
        return DAT_SUCCESS;
 bail:
        /* schedule cleanup from workq */
@@ -1260,6 +1338,7 @@ ud_bail:
        } else
 #endif
        {
+               dapli_ep_check(cm_ptr->ep);
                dapls_cr_callback(cm_ptr, event, NULL, 0, cm_ptr->sp);
        }
        return;
@@ -1336,9 +1415,6 @@ dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
                return DAT_SUCCESS;
        }

-       /* RC. Transition to error state to flush queue */
-        dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
-
        return (dapli_socket_disconnect(cm_ptr));
 }

@@ -1367,7 +1443,10 @@ dapls_ib_disconnect_clean(IN DAPL_EP * ep_ptr,
                          IN const ib_cm_events_t ib_cm_event)
 {
        if (ib_cm_event == IB_CME_TIMEOUT) {
-               dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+               dp_ib_cm_handle_t cm_ptr;
+
+               if ((cm_ptr = dapl_get_cm_from_ep(ep_ptr)) == NULL)
+                       return;

                dapl_log(DAPL_DBG_TYPE_WARN,
                        "dapls_ib_disc_clean: CONN_TIMEOUT ep %p cm %p %s\n",
--
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
