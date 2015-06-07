From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 5/6] xprtrdma, svcrdma: Switch to generic logging helpers
Date: Sun, 7 Jun 2015 02:00:11 -0400
Message-ID: <20150607060010.GA26768@phlsvsds.ph.intel.com>
References: <1431945633-18401-1-git-send-email-sagig@mellanox.com> <1431945633-18401-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431945633-18401-6-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -201,9 +202,10 @@ static void qp_event_handler(struct ib_event *event, void *context)
>  	case IB_EVENT_QP_ACCESS_ERR:
>  	case IB_EVENT_DEVICE_FATAL:
>  	default:
> -		dprintk("svcrdma: QP ERROR event %d received for QP=%p, "
> +		dprintk("svcrdma: QP ERROR event %s (%d) received for QP=%p, "
>  			"closing transport\n",


Generally it is recommended to keep strings on a single line for easier
grepping of the code.

"However, never break user-visible strings such as printk messages, because
that breaks the ability to grep for them."

	-- https://www.kernel.org/doc/Documentation/CodingStyle

I think in this case it is probably ok because of the %p specifier which can't
really be grepped for...

So I'm ok with this but it might be nice to respin.

Same comment for a couple of places below.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> -			event->event, event->element.qp);
> +			ib_event_msg(event->event), event->event,
> +			event->element.qp);
>  		set_bit(XPT_CLOSE, &xprt->xpt_flags);
>  		break;
>  	}
> @@ -402,7 +404,8 @@ static void sq_cq_reap(struct svcxprt_rdma *xprt)
>  		for (i = 0; i < ret; i++) {
>  			wc = &wc_a[i];
>  			if (wc->status != IB_WC_SUCCESS) {
> -				dprintk("svcrdma: sq wc err status %d\n",
> +				dprintk("svcrdma: sq wc err status %s (%d)\n",
> +					ib_wc_status_msg(wc->status),
>  					wc->status);
>  
>  				/* Close the transport */
> @@ -616,7 +619,8 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
>  	switch (event->event) {
>  	case RDMA_CM_EVENT_CONNECT_REQUEST:
>  		dprintk("svcrdma: Connect request on cma_id=%p, xprt = %p, "
> -			"event=%d\n", cma_id, cma_id->context, event->event);
> +			"event = %s (%d)\n", cma_id, cma_id->context,
> +			rdma_event_msg(event->event), event->event);
>  		handle_connect_req(cma_id,
>  				   event->param.conn.initiator_depth);
>  		break;
> @@ -636,7 +640,8 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
>  
>  	default:
>  		dprintk("svcrdma: Unexpected event on listening endpoint %p, "
> -			"event=%d\n", cma_id, event->event);
> +			"event = %s (%d)\n", cma_id,
> +			rdma_event_msg(event->event), event->event);
>  		break;
>  	}
>  
> @@ -669,7 +674,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cma_id,
>  		break;
>  	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>  		dprintk("svcrdma: Device removal cma_id=%p, xprt = %p, "
> -			"event=%d\n", cma_id, xprt, event->event);
> +			"event = %s (%d)\n", cma_id, xprt,
> +			rdma_event_msg(event->event), event->event);
>  		if (xprt) {
>  			set_bit(XPT_CLOSE, &xprt->xpt_flags);
>  			svc_xprt_enqueue(xprt);
> @@ -677,7 +683,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cma_id,
>  		break;
>  	default:
>  		dprintk("svcrdma: Unexpected event on DTO endpoint %p, "
> -			"event=%d\n", cma_id, event->event);
> +			"event = %s (%d)\n", cma_id,
> +			rdma_event_msg(event->event), event->event);
>  		break;
>  	}
>  	return 0;
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 4870d27..6f6b8a5 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -105,32 +105,6 @@ rpcrdma_run_tasklet(unsigned long data)
>  
>  static DECLARE_TASKLET(rpcrdma_tasklet_g, rpcrdma_run_tasklet, 0UL);
>  
> -static const char * const async_event[] = {
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
> @@ -148,7 +122,7 @@ rpcrdma_qp_async_error_upcall(struct ib_event *event, void *context)
>  	struct rpcrdma_ep *ep = context;
>  
>  	pr_err("RPC:       %s: %s on device %s ep %p\n",
> -	       __func__, ASYNC_MSG(event->event),
> +	       __func__, ib_event_msg(event->event),
>  		event->device->name, context);
>  	if (ep->rep_connected == 1) {
>  		ep->rep_connected = -EIO;
> @@ -163,7 +137,7 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
>  	struct rpcrdma_ep *ep = context;
>  
>  	pr_err("RPC:       %s: %s on device %s ep %p\n",
> -	       __func__, ASYNC_MSG(event->event),
> +	       __func__, ib_event_msg(event->event),
>  		event->device->name, context);
>  	if (ep->rep_connected == 1) {
>  		ep->rep_connected = -EIO;
> @@ -172,35 +146,6 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
>  	}
>  }
>  
> -static const char * const wc_status[] = {
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
>  		if (wc->status != IB_WC_SUCCESS &&
>  		    wc->status != IB_WC_WR_FLUSH_ERR)
>  			pr_err("RPC:       %s: SEND: %s\n",
> -			       __func__, COMPLETION_MSG(wc->status));
> +			       __func__, ib_wc_status_msg(wc->status));
>  	} else {
>  		struct rpcrdma_mw *r;
>  
> @@ -302,7 +247,7 @@ out_schedule:
>  out_fail:
>  	if (wc->status != IB_WC_WR_FLUSH_ERR)
>  		pr_err("RPC:       %s: rep %p: %s\n",
> -		       __func__, rep, COMPLETION_MSG(wc->status));
> +		       __func__, rep, ib_wc_status_msg(wc->status));
>  	rep->rr_len = ~0U;
>  	goto out_schedule;
>  }
> @@ -386,31 +331,6 @@ rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
>  		rpcrdma_sendcq_process_wc(&wc);
>  }
>  
> -#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> -static const char * const conn[] = {
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
>  rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
>  {
> @@ -476,7 +396,7 @@ connected:
>  	default:
>  		dprintk("RPC:       %s: %pIS:%u (ep 0x%p): %s\n",
>  			__func__, sap, rpc_get_port(sap), ep,
> -			CONNECTION_MSG(event->event));
> +			rdma_event_msg(event->event));
>  		break;
>  	}
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
