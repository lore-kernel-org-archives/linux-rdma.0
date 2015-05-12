From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/6] xprtrdma: Switch to generic logging helpers
Date: Tue, 12 May 2015 14:40:25 +0200
Message-ID: <1431434425.25060.65.camel@opteya.com>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com>
	 <1431432329-859-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431432329-859-6-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 12 mai 2015 =C3=A0 15:05 +0300, Sagi Grimberg a =C3=A9crit :
> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/frwr_ops.c           |    4 +-
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   29 ++++++----
>  net/sunrpc/xprtrdma/verbs.c              |   90 ++------------------=
----------
>  3 files changed, 25 insertions(+), 98 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frw=
r_ops.c
> index dff0481..b3fda09 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -128,8 +128,8 @@ frwr_sendcompletion(struct ib_wc *wc)
> =20
>  	/* WARNING: Only wr_id and status are reliable at this point */
>  	r =3D (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
> -	dprintk("RPC:       %s: frmr %p (stale), status %d\n",
> -		__func__, r, wc->status);
> +	dprintk("RPC:       %s: frmr %p (stale), status %s(%d)\n",
> +		__func__, r, ib_wc_status_msg(wc->status), wc->status);
>  	r->r.frmr.fr_state =3D FRMR_IS_STALE;
>  }
> =20
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xp=
rtrdma/svc_rdma_transport.c
> index f609c1c..abd2d51 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -175,8 +175,8 @@ void svc_rdma_put_req_map(struct svc_rdma_req_map=
 *map)
>  static void cq_event_handler(struct ib_event *event, void *context)
>  {
>  	struct svc_xprt *xprt =3D context;
> -	dprintk("svcrdma: received CQ event id=3D%d, context=3D%p\n",
> -		event->event, context);
> +	dprintk("svcrdma: received CQ event %s(%d), context=3D%p\n",
> +		ib_event_msg(event->event), event->event, context);
>  	set_bit(XPT_CLOSE, &xprt->xpt_flags);
>  }
> =20
> @@ -191,8 +191,9 @@ static void qp_event_handler(struct ib_event *eve=
nt, void *context)
>  	case IB_EVENT_COMM_EST:
>  	case IB_EVENT_SQ_DRAINED:
>  	case IB_EVENT_QP_LAST_WQE_REACHED:
> -		dprintk("svcrdma: QP event %d received for QP=3D%p\n",
> -			event->event, event->element.qp);
> +		dprintk("svcrdma: QP event %s(%d) received for QP=3D%p\n",
> +			ib_event_msg(event->event), event->event,
> +			event->element.qp);
>  		break;
>  	/* These are considered fatal events */
>  	case IB_EVENT_PATH_MIG_ERR:
> @@ -201,9 +202,10 @@ static void qp_event_handler(struct ib_event *ev=
ent, void *context)
>  	case IB_EVENT_QP_ACCESS_ERR:
>  	case IB_EVENT_DEVICE_FATAL:
>  	default:
> -		dprintk("svcrdma: QP ERROR event %d received for QP=3D%p, "
> +		dprintk("svcrdma: QP ERROR event %s(%d) received for QP=3D%p, "
>  			"closing transport\n",
> -			event->event, event->element.qp);
> +			ib_event_msg(event->event), event->event,
> +			event->element.qp);
>  		set_bit(XPT_CLOSE, &xprt->xpt_flags);
>  		break;
>  	}
> @@ -402,7 +404,8 @@ static void sq_cq_reap(struct svcxprt_rdma *xprt)
>  		for (i =3D 0; i < ret; i++) {
>  			wc =3D &wc_a[i];
>  			if (wc->status !=3D IB_WC_SUCCESS) {
> -				dprintk("svcrdma: sq wc err status %d\n",
> +				dprintk("svcrdma: sq wc err status %s(%d)\n",
> +					ib_wc_status_msg(wc->status),
>  					wc->status);
> =20
>  				/* Close the transport */
> @@ -616,7 +619,8 @@ static int rdma_listen_handler(struct rdma_cm_id =
*cma_id,
>  	switch (event->event) {
>  	case RDMA_CM_EVENT_CONNECT_REQUEST:
>  		dprintk("svcrdma: Connect request on cma_id=3D%p, xprt =3D %p, "
> -			"event=3D%d\n", cma_id, cma_id->context, event->event);
> +			"event=3D%s(%d)\n", cma_id, cma_id->context,
> +			rdma_event_msg(event->event), event->event);
>  		handle_connect_req(cma_id,
>  				   event->param.conn.initiator_depth);
>  		break;
> @@ -636,7 +640,8 @@ static int rdma_listen_handler(struct rdma_cm_id =
*cma_id,
> =20
>  	default:
>  		dprintk("svcrdma: Unexpected event on listening endpoint %p, "
> -			"event=3D%d\n", cma_id, event->event);
> +			"event=3D%s(%d)\n", cma_id, rdma_event_msg(event->event),
> +			event->event);
>  		break;
>  	}
> =20
> @@ -669,7 +674,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cm=
a_id,
>  		break;
>  	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>  		dprintk("svcrdma: Device removal cma_id=3D%p, xprt =3D %p, "
> -			"event=3D%d\n", cma_id, xprt, event->event);
> +			"event=3D%s(%d)\n", cma_id, xprt,
> +			rdma_event_msg(event->event), event->event);
>  		if (xprt) {
>  			set_bit(XPT_CLOSE, &xprt->xpt_flags);
>  			svc_xprt_enqueue(xprt);
> @@ -677,7 +683,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cm=
a_id,
>  		break;
>  	default:
>  		dprintk("svcrdma: Unexpected event on DTO endpoint %p, "
> -			"event=3D%d\n", cma_id, event->event);
> +			"event=3D%d\n", cma_id, rdma_event_msg(event->event),
> +			event->event);

There's something wrong here, %s is missing.

>  		break;
>  	}
>  	return 0;
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c
> index 4870d27..6f6b8a5 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -105,32 +105,6 @@ rpcrdma_run_tasklet(unsigned long data)
> =20
>  static DECLARE_TASKLET(rpcrdma_tasklet_g, rpcrdma_run_tasklet, 0UL);
> =20
> -static const char * const async_event[] =3D {
> -	"CQ error",
> -	"QP fatal error",
> -	"QP request error",
> -	"QP access error",
> -	"communication established",
> -	"send queue drained",
> -	"path migration successful",
> -	"path mig error",
> -	"device fatal error",
> -	"port active",
> -	"port error",
> -	"LID change",
> -	"P_key change",
> -	"SM change",
> -	"SRQ error",
> -	"SRQ limit reached",
> -	"last WQE reached",
> -	"client reregister",
> -	"GID change",
> -};
> -
> -#define ASYNC_MSG(status)					\
> -	((status) < ARRAY_SIZE(async_event) ?			\
> -		async_event[(status)] : "unknown async error")
> -
>  static void
>  rpcrdma_schedule_tasklet(struct list_head *sched_list)
>  {
> @@ -148,7 +122,7 @@ rpcrdma_qp_async_error_upcall(struct ib_event *ev=
ent, void *context)
>  	struct rpcrdma_ep *ep =3D context;
> =20
>  	pr_err("RPC:       %s: %s on device %s ep %p\n",
> -	       __func__, ASYNC_MSG(event->event),
> +	       __func__, ib_event_msg(event->event),
>  		event->device->name, context);
>  	if (ep->rep_connected =3D=3D 1) {
>  		ep->rep_connected =3D -EIO;
> @@ -163,7 +137,7 @@ rpcrdma_cq_async_error_upcall(struct ib_event *ev=
ent, void *context)
>  	struct rpcrdma_ep *ep =3D context;
> =20
>  	pr_err("RPC:       %s: %s on device %s ep %p\n",
> -	       __func__, ASYNC_MSG(event->event),
> +	       __func__, ib_event_msg(event->event),
>  		event->device->name, context);
>  	if (ep->rep_connected =3D=3D 1) {
>  		ep->rep_connected =3D -EIO;
> @@ -172,35 +146,6 @@ rpcrdma_cq_async_error_upcall(struct ib_event *e=
vent, void *context)
>  	}
>  }
> =20
> -static const char * const wc_status[] =3D {
> -	"success",
> -	"local length error",
> -	"local QP operation error",
> -	"local EE context operation error",
> -	"local protection error",
> -	"WR flushed",
> -	"memory management operation error",
> -	"bad response error",
> -	"local access error",
> -	"remote invalid request error",
> -	"remote access error",
> -	"remote operation error",
> -	"transport retry counter exceeded",
> -	"RNR retry counter exceeded",
> -	"local RDD violation error",
> -	"remove invalid RD request",
> -	"operation aborted",
> -	"invalid EE context number",
> -	"invalid EE context state",
> -	"fatal error",
> -	"response timeout error",
> -	"general error",
> -};
> -
> -#define COMPLETION_MSG(status)					\
> -	((status) < ARRAY_SIZE(wc_status) ?			\
> -		wc_status[(status)] : "unexpected completion error")
> -
>  static void
>  rpcrdma_sendcq_process_wc(struct ib_wc *wc)
>  {
> @@ -209,7 +154,7 @@ rpcrdma_sendcq_process_wc(struct ib_wc *wc)
>  		if (wc->status !=3D IB_WC_SUCCESS &&
>  		    wc->status !=3D IB_WC_WR_FLUSH_ERR)
>  			pr_err("RPC:       %s: SEND: %s\n",
> -			       __func__, COMPLETION_MSG(wc->status));
> +			       __func__, ib_wc_status_msg(wc->status));
>  	} else {
>  		struct rpcrdma_mw *r;
> =20
> @@ -302,7 +247,7 @@ out_schedule:
>  out_fail:
>  	if (wc->status !=3D IB_WC_WR_FLUSH_ERR)
>  		pr_err("RPC:       %s: rep %p: %s\n",
> -		       __func__, rep, COMPLETION_MSG(wc->status));
> +		       __func__, rep, ib_wc_status_msg(wc->status));
>  	rep->rr_len =3D ~0U;
>  	goto out_schedule;
>  }
> @@ -386,31 +331,6 @@ rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
>  		rpcrdma_sendcq_process_wc(&wc);
>  }
> =20
> -#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> -static const char * const conn[] =3D {
> -	"address resolved",
> -	"address error",
> -	"route resolved",
> -	"route error",
> -	"connect request",
> -	"connect response",
> -	"connect error",
> -	"unreachable",
> -	"rejected",
> -	"established",
> -	"disconnected",
> -	"device removal",
> -	"multicast join",
> -	"multicast error",
> -	"address change",
> -	"timewait exit",
> -};
> -
> -#define CONNECTION_MSG(status)						\
> -	((status) < ARRAY_SIZE(conn) ?					\
> -		conn[(status)] : "unrecognized connection error")
> -#endif
> -
>  static int
>  rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *eve=
nt)
>  {
> @@ -476,7 +396,7 @@ connected:
>  	default:
>  		dprintk("RPC:       %s: %pIS:%u (ep 0x%p): %s\n",
>  			__func__, sap, rpc_get_port(sap), ep,
> -			CONNECTION_MSG(event->event));
> +			rdma_event_msg(event->event));
>  		break;
>  	}
> =20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
