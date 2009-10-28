From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] uDAPL v2: scm: connection peer resets under heavy load,
 incorrect event on error
Date: Wed, 28 Oct 2009 16:19:16 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835F08B51A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Under heavy load, scm occasionally gets a peer reset from the remote stack. In this
case retry the socket connection for this QP setup.

Add debugging with PID's and socket ports to help isolate
these types of socket scaling issues.

Report correct UD event during error, check remote_ah creation.

Fix dapl_poll return codes for single event type only.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c           |  398 ++++++++++++++++++++++++----------------
 dapl/openib_scm/dapl_ib_util.h |    1 +
 dapl/openib_scm/device.c       |    7 +-
 3 files changed, 244 insertions(+), 162 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 0d2d058..c957f29 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -130,7 +130,7 @@ static enum DAPL_FD_EVENTS dapl_poll(DAPL_SOCKET s, enum DAPL_FD_EVENTS event)
        if (ret == 0)
                return 0;
        else if (ret == SOCKET_ERROR)
-               return WSAGetLastError();
+               return DAPL_FD_ERROR;
        else if (FD_ISSET(s, &rw_fds))
                return event;
        else
@@ -161,6 +161,8 @@ static int dapl_socket_errno(void)
        case WSAEACCES:
        case WSAEADDRINUSE:
                return EADDRINUSE;
+       case WSAECONNRESET:
+               return ECONNRESET;
        default:
                return err;
        }
@@ -236,18 +238,17 @@ static enum DAPL_FD_EVENTS dapl_poll(DAPL_SOCKET s, enum DAPL_FD_EVENTS event)
                 s, ret, fds.revents);
        if (ret == 0)
                return 0;
-       else if (fds.revents & (POLLERR | POLLHUP | POLLNVAL))
+       else if (ret < 0 || (fds.revents & (POLLERR | POLLHUP | POLLNVAL)))
                return DAPL_FD_ERROR;
        else
-               return fds.revents;
+               return event;
 }

 static int dapl_select(struct dapl_fd_set *set)
 {
        int ret;

-       dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: sleep, fds=%d\n",
-                    set->index);
+       dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: sleep, fds=%d\n", set->index);
        ret = poll(set->set, set->index, -1);
        dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: wakeup, ret=0x%x\n", ret);
        return ret;
@@ -368,13 +369,8 @@ multi_cleanup:
 notify_thread:

        /* wakeup work thread, if something destroyed */
-       if (hca_ptr != NULL) {
-               if (send(hca_ptr->ib_trans.scm[1],
-                        "w", sizeof "w", 0) == -1)
-                       dapl_log(DAPL_DBG_TYPE_CM,
-                                " cm_destroy: thread wakeup error = %s\n",
-                                strerror(errno));
-       }
+       if (hca_ptr != NULL)
+               send(hca_ptr->ib_trans.scm[1], "w", sizeof "w", 0);
 }

 /* queue socket for processing CM work */
@@ -388,10 +384,7 @@ static void dapli_cm_queue(struct ib_cm_handle *cm_ptr)
        dapl_os_unlock(&cm_ptr->hca->ib_trans.lock);

        /* wakeup CM work thread */
-       if (send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0) == -1)
-               dapl_log(DAPL_DBG_TYPE_CM,
-                        " cm_queue: thread wakeup error = %s\n",
-                        strerror(errno));
+       send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
 }

 /*
@@ -451,10 +444,9 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
                         err == -1 ? "POLL" : "SOCKOPT",
                         err == -1 ? strerror(errno) : strerror(err),
                         inet_ntoa(((struct sockaddr_in *)
-                                  ep_ptr->param.
-                                  remote_ia_address_ptr)->sin_addr),
+                               &cm_ptr->addr)->sin_addr),
                         ntohs(((struct sockaddr_in *)
-                               &cm_ptr->msg.daddr.so)->sin_port));
+                               &cm_ptr->addr)->sin_port));
                goto bail;
        }

@@ -462,7 +454,7 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
        ret = setsockopt(cm_ptr->socket, IPPROTO_TCP, TCP_NODELAY,
                         (char *)&opt, sizeof(opt));
        if (ret)
-               dapl_log(DAPL_DBG_TYPE_WARN,
+               dapl_log(DAPL_DBG_TYPE_ERR,
                         " CONN_PENDING: NODELAY setsockopt: %s\n",
                         strerror(errno));

@@ -522,42 +514,48 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
 {
        dp_ib_cm_handle_t cm_ptr;
        int ret;
+       socklen_t sl;
        DAPL_IA *ia_ptr = ep_ptr->header.owner_ia;
-       struct sockaddr_in addr;
+       DAT_RETURN dat_ret = DAT_INSUFFICIENT_RESOURCES;

        dapl_dbg_log(DAPL_DBG_TYPE_EP, " connect: r_qual %d p_size=%d\n",
                     r_qual, p_size);

        cm_ptr = dapls_ib_cm_create(ep_ptr);
        if (cm_ptr == NULL)
-               return DAT_INSUFFICIENT_RESOURCES;
+               return dat_ret;

        /* create, connect, sockopt, and exchange QP information */
        if ((cm_ptr->socket =
             socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == DAPL_INVALID_SOCKET) {
-               dapl_os_free(cm_ptr, sizeof(*cm_ptr));
-               return DAT_INSUFFICIENT_RESOURCES;
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " connect: socket create ERR %s\n", strerror(errno));
+               goto bail;
        }

        ret = dapl_config_socket(cm_ptr->socket);
        if (ret < 0) {
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " socket connect: config socket %d ERR %d %s\n",
+                        " connect: config socket %d ERR %d %s\n",
                         cm_ptr->socket, ret, strerror(errno));
+               dat_ret = DAT_INTERNAL_ERROR;
                goto bail;
        }

-       dapl_os_memcpy(&addr, r_addr, sizeof(addr));
-       addr.sin_port = htons(r_qual+1000);
-       ret = dapl_connect_socket(cm_ptr->socket, (struct sockaddr *)&addr,
-                                 sizeof(addr));
+       /* save remote address */
+       dapl_os_memcpy(&cm_ptr->addr, r_addr, sizeof(r_addr));
+
+#ifdef DAPL_DBG
+       /* DBG: Active PID [0], PASSIVE PID [2]*/
+       *(uint16_t*)&cm_ptr->msg.resv[0] = htons((uint16_t)dapl_os_getpid());
+       *(uint16_t*)&cm_ptr->msg.resv[2] = ((struct sockaddr_in *)&cm_ptr->addr)->sin_port;
+#endif
+       ((struct sockaddr_in *)&cm_ptr->addr)->sin_port = htons(r_qual + 1000);
+       ret = dapl_connect_socket(cm_ptr->socket, (struct sockaddr *)&cm_ptr->addr,
+                                 sizeof(cm_ptr->addr));
        if (ret && ret != EAGAIN) {
-               dapl_log(DAPL_DBG_TYPE_ERR,
-                        " socket connect ERROR: %s -> %s r_qual %d\n",
-                        strerror(errno),
-                        inet_ntoa(addr.sin_addr), (unsigned int)r_qual);
-               dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
-               return DAT_INVALID_ADDRESS;
+               dat_ret = DAT_INVALID_ADDRESS;
+               goto bail;
        }

        /* REQ: QP info in msg.saddr, IA address in msg.daddr, and pdata */
@@ -571,9 +569,16 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
        /* save references */
        cm_ptr->hca = ia_ptr->hca_ptr;
        cm_ptr->ep = ep_ptr;
-       cm_ptr->msg.daddr.so = ia_ptr->hca_ptr->hca_address;
-       ((struct sockaddr_in *)
-               &cm_ptr->msg.daddr.so)->sin_port = ntohs((uint16_t)r_qual);
+
+       /* get local address information from socket */
+       sl = sizeof(cm_ptr->msg.daddr.so);
+       if (getsockname(cm_ptr->socket, (struct sockaddr *)&cm_ptr->msg.daddr.so, &sl)) {
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                       " connect getsockname ERROR: %s -> %s r_qual %d\n",
+                       strerror(errno),
+                       inet_ntoa(((struct sockaddr_in *)r_addr)->sin_addr),
+                       (unsigned int)r_qual);;
+       }

        if (p_size) {
                cm_ptr->msg.p_size = htons(p_size);
@@ -591,8 +596,8 @@ dapli_socket_connect(DAPL_EP * ep_ptr,

        dapl_dbg_log(DAPL_DBG_TYPE_EP,
                     " connect: %s r_qual %d pending, p_sz=%d, %d %d ...\n",
-                    inet_ntoa(addr.sin_addr), (unsigned int)r_qual,
-                    ntohs(cm_ptr->msg.p_size),
+                    inet_ntoa(((struct sockaddr_in *)&cm_ptr->addr)->sin_addr),
+                    (unsigned int)r_qual, ntohs(cm_ptr->msg.p_size),
                     cm_ptr->msg.p_data[0], cm_ptr->msg.p_data[1]);

        dapli_cm_queue(cm_ptr);
@@ -606,8 +611,8 @@ bail:
                 (unsigned int)r_qual);

        /* close socket, free cm structure */
-       dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
-       return DAT_INTERNAL_ERROR;
+       dapls_ib_cm_free(cm_ptr, NULL);
+       return dat_ret;
 }

 /*
@@ -618,18 +623,32 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
        DAPL_EP *ep_ptr = cm_ptr->ep;
        int len, exp = sizeof(ib_cm_msg_t) - DCM_MAX_PDATA_SIZE;
        ib_cm_events_t event = IB_CME_LOCAL_FAILURE;
+       socklen_t sl;

        /* read DST information into cm_ptr, overwrite SRC info */
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " connect_rtu: recv peer QP data\n");

        len = recv(cm_ptr->socket, (char *)&cm_ptr->msg, exp, 0);
        if (len != exp || ntohs(cm_ptr->msg.ver) != DCM_VER) {
-               dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CONN_RTU read: ERR %s, rcnt=%d, ver=%d -> %s\n",
-                        strerror(errno), len, cm_ptr->msg.ver,
-                        inet_ntoa(((struct sockaddr_in *)
-                                   ep_ptr->param.remote_ia_address_ptr)->
-                                  sin_addr));
+               dapl_log(DAPL_DBG_TYPE_WARN,
+                        " CONN_RTU read: sk %d ERR %s, rcnt=%d, v=%d -> %s PORT L-%x R-%x PID L-%x R-%x\n",
+                        cm_ptr->socket, strerror(errno), len, ntohs(cm_ptr->msg.ver),
+                        inet_ntoa(((struct sockaddr_in *)&cm_ptr->addr)->sin_addr),
+                        ntohs(((struct sockaddr_in *)&cm_ptr->msg.daddr.so)->sin_port),
+                        ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port),
+                        ntohs(*(uint16_t*)&cm_ptr->msg.resv[0]),
+                        ntohs(*(uint16_t*)&cm_ptr->msg.resv[2]));
+
+               /* Retry; corner case where server tcp stack resets under load */
+               if (dapl_socket_errno() == ECONNRESET) {
+                       closesocket(cm_ptr->socket);
+                       cm_ptr->socket = DAPL_INVALID_SOCKET;
+                       dapli_socket_connect(cm_ptr->ep, (DAT_IA_ADDRESS_PTR)&cm_ptr->addr,
+                                            ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port) - 1000,
+                                            ntohs(cm_ptr->msg.p_size), &cm_ptr->msg.p_data);
+                       dapls_ib_cm_free(cm_ptr, NULL);
+                       return;
+               }
                goto bail;
        }

@@ -640,6 +659,10 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                       &cm_ptr->msg.daddr.so,
                       sizeof(union dcm_addr));

+       /* save local address information from socket */
+       sl = sizeof(cm_ptr->addr);
+       getsockname(cm_ptr->socket,(struct sockaddr *)&cm_ptr->addr, &sl);
+
        dapl_dbg_log(DAPL_DBG_TYPE_EP,
                     " CONN_RTU: DST %s %d lid=0x%x,"
                     " qpn=0x%x, qp_type=%d, psize=%d\n",
@@ -689,15 +712,11 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)

        if (event != IB_CME_CONNECTED) {
                dapl_log(DAPL_DBG_TYPE_CM,
-                        " CONN_RTU: reject from %s\n",
+                        " CONN_RTU: reject from %s %x\n",
                         inet_ntoa(((struct sockaddr_in *)
-                                   ep_ptr->param.
-                                   remote_ia_address_ptr)->sin_addr));
-#ifdef DAT_EXTENSIONS
-               if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD)
-                       goto ud_bail;
-               else
-#endif
+                                   &cm_ptr->msg.daddr.so)->sin_addr),
+                        ntohs(((struct sockaddr_in *)
+                                &cm_ptr->msg.daddr.so)->sin_port));
                goto bail;
        }

@@ -709,11 +728,15 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                                  cm_ptr->msg.saddr.ib.lid,
                                  NULL) != DAT_SUCCESS) {
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CONN_RTU: QPS_RTR ERR %s -> %s\n",
-                        strerror(errno),
+                        " CONN_RTU: QPS_RTR ERR %s (%d,%d,%x,%x,%x) -> %s %x\n",
+                        strerror(errno), ep_ptr->qp_handle->qp_type,
+                        ep_ptr->qp_state, ep_ptr->qp_handle->qp_num,
+                        ntohl(cm_ptr->msg.saddr.ib.qpn),
+                        ntohs(cm_ptr->msg.saddr.ib.lid),
                         inet_ntoa(((struct sockaddr_in *)
-                                  ep_ptr->param.
-                                  remote_ia_address_ptr)->sin_addr));
+                                   &cm_ptr->msg.daddr.so)->sin_addr),
+                        ntohs(((struct sockaddr_in *)
+                                &cm_ptr->msg.daddr.so)->sin_port));
                dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
@@ -723,11 +746,15 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
                                  cm_ptr->msg.saddr.ib.lid,
                                  NULL) != DAT_SUCCESS) {
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CONN_RTU: QPS_RTS ERR %s -> %s\n",
-                        strerror(errno),
+                        " CONN_RTU: QPS_RTS ERR %s (%d,%d,%x,%x,%x) -> %s %x\n",
+                        strerror(errno), ep_ptr->qp_handle->qp_type,
+                        ep_ptr->qp_state, ep_ptr->qp_handle->qp_num,
+                        ntohl(cm_ptr->msg.saddr.ib.qpn),
+                        ntohs(cm_ptr->msg.saddr.ib.lid),
                         inet_ntoa(((struct sockaddr_in *)
-                                  ep_ptr->param.
-                                  remote_ia_address_ptr)->sin_addr));
+                                   &cm_ptr->msg.daddr.so)->sin_addr),
+                        ntohs(((struct sockaddr_in *)
+                                &cm_ptr->msg.daddr.so)->sin_port));
                dapl_os_unlock(&ep_ptr->header.lock);
                goto bail;
        }
@@ -753,34 +780,37 @@ ud_bail:
                ib_pd_handle_t pd_handle =
                        ((DAPL_PZ *)ep_ptr->param.pz_handle)->pd_handle;

-               cm_ptr->ah = dapls_create_ah(cm_ptr->hca, pd_handle,
-                                            ep_ptr->qp_handle,
-                                            cm_ptr->msg.saddr.ib.lid,
-                                            NULL);
-               if (!cm_ptr->ah) {
-                       event = IB_CME_LOCAL_FAILURE;
-                       goto bail;
-               }
-
-               dapl_log(DAPL_DBG_TYPE_CM,
-                       " CONN_RTU: UD AH %p for lid 0x%x qpn 0x%x\n",
-                       cm_ptr->ah, ntohs(cm_ptr->msg.saddr.ib.lid),
-                       ntohl(cm_ptr->msg.saddr.ib.qpn));
-
-               /* post EVENT, modify_qp created ah */
-               xevent.status = 0;
-               xevent.type = DAT_IB_UD_REMOTE_AH;
-               xevent.remote_ah.ah = cm_ptr->ah;
-               xevent.remote_ah.qpn = ntohl(cm_ptr->msg.saddr.ib.qpn);
-               dapl_os_memcpy(&xevent.remote_ah.ia_addr,
-                              &ep_ptr->remote_ia_address,
-                              sizeof(union dcm_addr));
-
-               if (event == IB_CME_CONNECTED)
-                       event = DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED;
-               else
+               if (event == IB_CME_CONNECTED) {
+                       cm_ptr->ah = dapls_create_ah(cm_ptr->hca, pd_handle,
+                                                    ep_ptr->qp_handle,
+                                                    cm_ptr->msg.saddr.ib.lid,
+                                                    NULL);
+                       if (cm_ptr->ah) {
+                               /* post UD extended EVENT */
+                               xevent.status = 0;
+                               xevent.type = DAT_IB_UD_REMOTE_AH;
+                               xevent.remote_ah.ah = cm_ptr->ah;
+                               xevent.remote_ah.qpn = ntohl(cm_ptr->msg.saddr.ib.qpn);
+                               dapl_os_memcpy(&xevent.remote_ah.ia_addr,
+                                               &ep_ptr->remote_ia_address,
+                                               sizeof(union dcm_addr));
+                               event = DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED;
+
+                               dapl_log(DAPL_DBG_TYPE_CM,
+                                       " CONN_RTU: UD AH %p for lid 0x%x"
+                                       " qpn 0x%x\n",
+                                       cm_ptr->ah,
+                                       ntohs(cm_ptr->msg.saddr.ib.lid),
+                                       ntohl(cm_ptr->msg.saddr.ib.qpn));
+
+                       } else
+                               event = DAT_IB_UD_CONNECTION_ERROR_EVENT;
+
+               } else if (event == IB_CME_LOCAL_FAILURE) {
+                       event = DAT_IB_UD_CONNECTION_ERROR_EVENT;
+               } else
                        event = DAT_IB_UD_CONNECTION_REJECT_EVENT;
-
+
                dapls_evd_post_connection_event_ext(
                                (DAPL_EVD *) ep_ptr->param.connect_evd_handle,
                                event,
@@ -802,6 +832,11 @@ ud_bail:
        return;

 bail:
+
+#ifdef DAT_EXTENSIONS
+       if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD)
+               goto ud_bail;
+#endif
        /* close socket, and post error event */
        dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
        closesocket(cm_ptr->socket);
@@ -839,7 +874,7 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
                goto bail;
        }

-       addr.sin_port = htons(serviceID+1000);
+       addr.sin_port = htons(serviceID + 1000);
        addr.sin_family = AF_INET;
        addr.sin_addr = ((struct sockaddr_in *) &ia_ptr->hca_ptr->hca_address)->sin_addr;

@@ -847,7 +882,7 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
            || (listen(cm_ptr->socket, 128) < 0)) {
                dapl_dbg_log(DAPL_DBG_TYPE_CM,
                             " listen: ERROR %s on conn_qual 0x%x\n",
-                            strerror(errno), serviceID);
+                            strerror(errno), serviceID + 1000);
                if (dapl_socket_errno() == EADDRINUSE)
                        dat_status = DAT_CONN_QUAL_IN_USE;
                else
@@ -857,6 +892,7 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)

        /* set cm_handle for this service point, save listen socket */
        sp_ptr->cm_srvc_handle = cm_ptr;
+       dapl_os_memcpy(&cm_ptr->addr, &addr, sizeof(addr));

        /* queue up listen socket to process inbound CR's */
        cm_ptr->state = DCM_LISTEN;
@@ -864,12 +900,12 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " listen: qual 0x%x cr %p s_fd %d\n",
-                    ntohs(serviceID), cm_ptr, cm_ptr->socket);
+                    ntohs(serviceID + 1000), cm_ptr, cm_ptr->socket);

        return dat_status;
 bail:
        dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " listen: ERROR on conn_qual 0x%x\n", serviceID);
+                    " listen: ERROR on conn_qual 0x%x\n", serviceID + 1000);
        dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
        return dat_status;
 }
@@ -881,6 +917,7 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
 {
        dp_ib_cm_handle_t acm_ptr;
        int ret, len, opt = 1;
+       socklen_t sl;

        /*
         * Accept all CR's on this port to avoid half-connection (SYN_RCV)
@@ -906,18 +943,23 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
                        dapls_ib_cm_free(acm_ptr, acm_ptr->ep);
                        return;
                }
-               dapl_dbg_log(DAPL_DBG_TYPE_CM, " accepting from %s\n",
+               dapl_dbg_log(DAPL_DBG_TYPE_CM, " accepting from %s %x\n",
                             inet_ntoa(((struct sockaddr_in *)
-                                       &acm_ptr->msg.daddr.so)->sin_addr));
+                                       &acm_ptr->msg.daddr.so)->sin_addr),
+                            ntohs(((struct sockaddr_in *)
+                                       &acm_ptr->msg.daddr.so)->sin_port));

                /* no delay for small packets */
                ret = setsockopt(acm_ptr->socket, IPPROTO_TCP, TCP_NODELAY,
                           (char *)&opt, sizeof(opt));
                if (ret)
-                       dapl_log(DAPL_DBG_TYPE_WARN,
+                       dapl_log(DAPL_DBG_TYPE_ERR,
                                 " ACCEPT: NODELAY setsockopt: %s\n",
                                 strerror(errno));
-
+
+               /* get local address information from socket */
+               sl = sizeof(acm_ptr->addr);
+               getsockname(acm_ptr->socket, (struct sockaddr *)&acm_ptr->addr, &sl);
                acm_ptr->state = DCM_ACCEPTING;
                dapli_cm_queue(acm_ptr);

@@ -948,7 +990,7 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
        /* validate private data size before reading */
        exp = ntohs(acm_ptr->msg.p_size);
        if (exp > DCM_MAX_PDATA_SIZE) {
-               dapl_dbg_log(DAPL_DBG_TYPE_ERR,
+               dapl_log(DAPL_DBG_TYPE_ERR,
                             " accept read: psize (%d) wrong\n",
                             acm_ptr->msg.p_size);
                goto bail;
@@ -968,8 +1010,8 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)

        acm_ptr->state = DCM_ACCEPTING_DATA;

-       dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    " ACCEPT: DST %s %d lid=0x%x, qpn=0x%x, psz=%d\n",
+       dapl_dbg_log(DAPL_DBG_TYPE_CM,
+                    " ACCEPT: DST %s %x lid=0x%x, qpn=0x%x, psz=%d\n",
                     inet_ntoa(((struct sockaddr_in *)
                                &acm_ptr->msg.daddr.so)->sin_addr),
                     ntohs(((struct sockaddr_in *)
@@ -1018,15 +1060,23 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
        ib_cm_msg_t local;
        struct iovec iov[2];
        int len, exp = sizeof(ib_cm_msg_t) - DCM_MAX_PDATA_SIZE;
+       DAT_RETURN ret = DAT_INTERNAL_ERROR;
+       socklen_t sl;

-       if (p_size > DCM_MAX_PDATA_SIZE)
+       if (p_size > DCM_MAX_PDATA_SIZE) {
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " accept_usr: psize(%d) too large\n", p_size);
                return DAT_LENGTH_ERROR;
+       }

        /* must have a accepted socket */
-       if (cm_ptr->socket == DAPL_INVALID_SOCKET)
-               return DAT_INTERNAL_ERROR;
+       if (cm_ptr->socket == DAPL_INVALID_SOCKET) {
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " accept_usr: cm socket invalid\n");
+               goto bail;
+       }

-       dapl_dbg_log(DAPL_DBG_TYPE_EP,
+       dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " ACCEPT_USR: remote lid=0x%x"
                     " qpn=0x%x qp_type %d, psize=%d\n",
                     ntohs(cm_ptr->msg.saddr.ib.lid),
@@ -1037,10 +1087,11 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 #ifdef DAT_EXTENSIONS
        if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD &&
            ep_ptr->qp_handle->qp_type != IBV_QPT_UD) {
-               dapl_dbg_log(DAPL_DBG_TYPE_ERR,
-                            " ACCEPT_USR: ERR remote QP is UD,"
-                            ", but local QP is not\n");
-               return (DAT_INVALID_HANDLE | DAT_INVALID_HANDLE_EP);
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " ACCEPT_USR: ERR remote QP is UD,"
+                        ", but local QP is not\n");
+               ret = (DAT_INVALID_HANDLE | DAT_INVALID_HANDLE_EP);
+               goto bail;
        }
 #endif

@@ -1087,9 +1138,17 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
        local.saddr.ib.lid = ia_ptr->hca_ptr->ib_trans.lid;
        dapl_os_memcpy(&local.saddr.ib.gid[0],
                       &ia_ptr->hca_ptr->ib_trans.gid, 16);
-       local.daddr.so = ia_ptr->hca_ptr->hca_address;
-       ((struct sockaddr_in *)&local.daddr.so)->sin_port =
-                               htons((uint16_t)cm_ptr->sp->conn_qual);
+
+       /* Get local address information from socket */
+       sl = sizeof(local.daddr.so);
+       getsockname(cm_ptr->socket, (struct sockaddr *)&local.daddr.so, &sl);
+
+#ifdef DAPL_DBG
+       /* DBG: Active PID [0], PASSIVE PID [2] */
+       *(uint16_t*)&cm_ptr->msg.resv[2] = htons((uint16_t)dapl_os_getpid());
+       dapl_os_memcpy(local.resv, cm_ptr->msg.resv, 4);
+#endif
+
        cm_ptr->ep = ep_ptr;
        cm_ptr->hca = ia_ptr->hca_ptr;
        cm_ptr->state = DCM_ACCEPTED;
@@ -1111,6 +1170,7 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
                         strerror(errno), len,
                         inet_ntoa(((struct sockaddr_in *)
                                   &cm_ptr->msg.daddr.so)->sin_addr));
+               cm_ptr->ep = NULL;
                goto bail;
        }

@@ -1128,9 +1188,8 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: accepted!\n");
        return DAT_SUCCESS;
 bail:
-       dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
-       dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
-       return DAT_INTERNAL_ERROR;
+       dapls_ib_cm_free(cm_ptr, NULL);
+       return ret;
 }

 /*
@@ -1160,39 +1219,42 @@ static void dapli_socket_accept_rtu(dp_ib_cm_handle_t cm_ptr)
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: connected!\n");

 #ifdef DAT_EXTENSIONS
+ud_bail:
        if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD) {
                DAT_IB_EXTENSION_EVENT_DATA xevent;

                ib_pd_handle_t pd_handle =
                        ((DAPL_PZ *)cm_ptr->ep->param.pz_handle)->pd_handle;
-
-               cm_ptr->ah = dapls_create_ah(cm_ptr->hca, pd_handle,
-                                            cm_ptr->ep->qp_handle,
-                                            cm_ptr->msg.saddr.ib.lid,
-                                            NULL);
-               if (!cm_ptr->ah) {
-                       event = IB_CME_LOCAL_FAILURE;
-                       goto bail;
-               }
+
+               if (event == IB_CME_CONNECTED) {
+                       cm_ptr->ah = dapls_create_ah(cm_ptr->hca, pd_handle,
+                                               cm_ptr->ep->qp_handle,
+                                               cm_ptr->msg.saddr.ib.lid,
+                                               NULL);
+                       if (cm_ptr->ah) {
+                               /* post EVENT, modify_qp created ah */
+                               xevent.status = 0;
+                               xevent.type = DAT_IB_UD_PASSIVE_REMOTE_AH;
+                               xevent.remote_ah.ah = cm_ptr->ah;
+                               xevent.remote_ah.qpn = ntohl(cm_ptr->msg.saddr.ib.qpn);
+                               dapl_os_memcpy(&xevent.remote_ah.ia_addr,
+                                       &cm_ptr->msg.daddr.so,
+                                       sizeof(union dcm_addr));
+                               event = DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED;
+                       } else
+                               event = DAT_IB_UD_CONNECTION_ERROR_EVENT;
+               } else
+                       event = DAT_IB_UD_CONNECTION_ERROR_EVENT;

                dapl_log(DAPL_DBG_TYPE_CM,
                        " CONN_RTU: UD AH %p for lid 0x%x qpn 0x%x\n",
                        cm_ptr->ah, ntohs(cm_ptr->msg.saddr.ib.lid),
                        ntohl(cm_ptr->msg.saddr.ib.qpn));

-               /* post EVENT, modify_qp created ah */
-               xevent.status = 0;
-               xevent.type = DAT_IB_UD_PASSIVE_REMOTE_AH;
-               xevent.remote_ah.ah = cm_ptr->ah;
-               xevent.remote_ah.qpn = ntohl(cm_ptr->msg.saddr.ib.qpn);
-               dapl_os_memcpy(&xevent.remote_ah.ia_addr,
-                              &cm_ptr->msg.daddr.so,
-                              sizeof(union dcm_addr));
-
                dapls_evd_post_connection_event_ext(
                                (DAPL_EVD *)
                                cm_ptr->ep->param.connect_evd_handle,
-                               DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED,
+                               event,
                                (DAT_EP_HANDLE) cm_ptr->ep,
                                (DAT_COUNT) ntohs(cm_ptr->msg.p_size),
                                (DAT_PVOID *) cm_ptr->msg.p_data,
@@ -1211,6 +1273,10 @@ static void dapli_socket_accept_rtu(dp_ib_cm_handle_t cm_ptr)
        return;

 bail:
+#ifdef DAT_EXTENSIONS
+       if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD)
+               goto ud_bail;
+#endif
        dapls_modify_qp_state(cm_ptr->ep->qp_handle, IBV_QPS_ERR, 0, 0, 0);
        dapls_ib_cm_free(cm_ptr, cm_ptr->ep);
        dapls_cr_callback(cm_ptr, event, NULL, cm_ptr->sp);
@@ -1716,8 +1782,11 @@ void cr_thread(void *arg)
                                dapl_dbg_log(DAPL_DBG_TYPE_CM,
                                             " CR FREE: %p ep=%p st=%d sock=%d\n",
                                             cr, cr->ep, cr->state, cr->socket);
-                               shutdown(cr->socket, SHUT_RDWR);
-                               closesocket(cr->socket);
+
+                               if (cr->socket != DAPL_INVALID_SOCKET) {
+                                       shutdown(cr->socket, SHUT_RDWR);
+                                       closesocket(cr->socket);
+                               }
                                dapl_os_free(cr, sizeof(*cr));
                                continue;
                        }
@@ -1751,7 +1820,9 @@ void cr_thread(void *arg)
                                     ret, cr->state, cr->socket);

                        /* data on listen, qp exchange, and on disc req */
-                       if (ret == DAPL_FD_READ) {
+                       if ((ret == DAPL_FD_READ) ||
+                           (cr->state != DCM_CONN_PENDING &&
+                            ret == DAPL_FD_ERROR)) {
                                if (cr->socket != DAPL_INVALID_SOCKET) {
                                        switch (cr->state) {
                                        case DCM_LISTEN:
@@ -1773,29 +1844,24 @@ void cr_thread(void *arg)
                                                break;
                                        }
                                }
-                       /* connect socket is writable, check status */
+                       /* ASYNC connections, writable, readable, error; check status */
                        } else if (ret == DAPL_FD_WRITE ||
                                   (cr->state == DCM_CONN_PENDING &&
                                    ret == DAPL_FD_ERROR)) {
+
+                               if (ret == DAPL_FD_ERROR)
+                                       dapl_log(DAPL_DBG_TYPE_ERR, " CONN_PENDING - FD_ERROR\n");
+
                                opt = 0;
                                opt_len = sizeof(opt);
                                ret = getsockopt(cr->socket, SOL_SOCKET,
                                                 SO_ERROR, (char *)&opt,
                                                 &opt_len);
-                               if (!ret)
+                               if (!ret && !opt)
                                        dapli_socket_connected(cr, opt);
                                else
-                                       dapli_socket_connected(cr, dapl_socket_errno());
-
-                       /* POLLUP, ERR, NVAL, or poll error - DISC */
-                       } else if (ret < 0 || ret == DAPL_FD_ERROR) {
-                               dapl_log(DAPL_DBG_TYPE_CM,
-                                    " poll=%d cr->st=%s sk=%d ep %p, %d\n",
-                                    ret, dapl_cm_state_str(cr->state),
-                                    cr->socket, cr->ep,
-                                    cr->ep ? cr->ep->param.ep_state : 0);
-                               dapli_socket_disconnect(cr);
-                       }
+                                       dapli_socket_connected(cr, opt ? opt : dapl_socket_errno());
+                       }
                        dapl_os_lock(&hca_ptr->ib_trans.lock);
                }

@@ -1854,19 +1920,29 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
                                 &ia_ptr->hca_ptr->ib_trans.list,
                                (DAPL_LLIST_ENTRY*)&cr->entry);

-               printf( "  CONN[%d]: sp %p ep %p sock %d %s %s %s %s %d\n",
+               printf( "  CONN[%d]: sp %p ep %p sock %d %s %s %s %s %s %s PORT L-%x R-%x PID L-%x R-%x\n",
                        i, cr->sp, cr->ep, cr->socket,
                        cr->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
-                       dapl_cm_state_str(cr->state),
+                       dapl_cm_state_str(cr->state), dapl_cm_op_str(ntohs(cr->msg.op)),
+                       ntohs(cr->msg.op) == DCM_REQ ? /* local address */
+                               inet_ntoa(((struct sockaddr_in *)&cr->msg.daddr.so)->sin_addr) :
+                               inet_ntoa(((struct sockaddr_in *)&cr->addr)->sin_addr),
                        cr->sp ? "<-" : "->",
-                       cr->state == DCM_LISTEN ?
-                       inet_ntoa(((struct sockaddr_in *)
-                               &ia_ptr->hca_ptr->hca_address)->sin_addr) :
-                       inet_ntoa(((struct sockaddr_in *)
-                               &cr->msg.daddr.so)->sin_addr),
-                       cr->sp ? (int)cr->sp->conn_qual :
-                       ntohs(((struct sockaddr_in *)
-                               &cr->msg.daddr.so)->sin_port));
+                               ntohs(cr->msg.op) == DCM_REQ ? /* remote address */
+                               inet_ntoa(((struct sockaddr_in *)&cr->addr)->sin_addr) :
+                               inet_ntoa(((struct sockaddr_in *)&cr->msg.daddr.so)->sin_addr),
+
+                       ntohs(cr->msg.op) == DCM_REQ ? /* local port */
+                               ntohs(((struct sockaddr_in *)&cr->msg.daddr.so)->sin_port) :
+                               ntohs(((struct sockaddr_in *)&cr->addr)->sin_port),
+
+                       ntohs(cr->msg.op) == DCM_REQ ? /* remote port */
+                               ntohs(((struct sockaddr_in *)&cr->addr)->sin_port) :
+                               ntohs(((struct sockaddr_in *)&cr->msg.daddr.so)->sin_port),
+
+                       cr->sp ? ntohs(*(uint16_t*)&cr->msg.resv[2]) : ntohs(*(uint16_t*)&cr->msg.resv[0]),
+                       cr->sp ? ntohs(*(uint16_t*)&cr->msg.resv[0]) : ntohs(*(uint16_t*)&cr->msg.resv[2]));
+
                i++;
        }
        printf("\n");
diff --git a/dapl/openib_scm/dapl_ib_util.h b/dapl/openib_scm/dapl_ib_util.h
index d6950fa..138a3dd 100644
--- a/dapl/openib_scm/dapl_ib_util.h
+++ b/dapl/openib_scm/dapl_ib_util.h
@@ -42,6 +42,7 @@ struct ib_cm_handle
        struct dapl_ep          *ep;
        ib_cm_msg_t             msg;
        struct ibv_ah           *ah;
+       DAT_SOCK_ADDR6          addr;
 };

 typedef struct ib_cm_handle    *dp_ib_cm_handle_t;
diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index a327390..dedcb16 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -268,7 +268,12 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name, IN DAPL_HCA * hca_ptr)
        if (dat_status != DAT_SUCCESS)
                return dat_status;

-       /* Get list of all IB devices, find match, open */
+#ifdef DAPL_DBG
+       /* DBG: unused port, set process id, lower 16 bits of pid */
+       ((struct sockaddr_in *)&hca_ptr->hca_address)->sin_port =
+                                       htons((uint16_t)dapl_os_getpid());
+#endif
+        /* Get list of all IB devices, find match, open */
        dev_list = ibv_get_device_list(NULL);
        if (!dev_list) {
                dapl_dbg_log(DAPL_DBG_TYPE_ERR,
--
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
