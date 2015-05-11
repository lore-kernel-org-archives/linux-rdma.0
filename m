From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] IB/core, cma: Nice log-friendly string helpers
Date: Mon, 11 May 2015 09:44:12 -0400
Message-ID: <B219CB1E-C046-40B2-BD10-DFCA1BC50087@oracle.com>
References: <1431253542-14933-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431253542-14933-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 10, 2015, at 6:25 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Some of us keep revisiting the code to decode IB/RDMA_CM enumerations
> that appear in our logs. Let's borrow the nice logging helpers xprtrdma
> has for CMA events, IB events and WC statuses. Also, have srp, iser and
> isert be early adopters.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> I have been using this patch for some time now so I thought
> it would be nice to get it out.
> 
> drivers/infiniband/ulp/iser/iser_verbs.c |   25 +++++---
> drivers/infiniband/ulp/srp/ib_srp.c      |   15 +++--
> include/rdma/ib_verbs.h                  |   55 ++++++++++++++++++
> include/rdma/rdma_cm.h                   |   23 ++++++++
> net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------------------
> 5 files changed, 106 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index cc2dd35..764f9f9 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -51,19 +51,20 @@ static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
> 
> static void iser_cq_event_callback(struct ib_event *cause, void *context)
> {
> -	iser_err("got cq event %d \n", cause->event);
> +	iser_err("cq event %s(%d)\n", IB_EVENT(cause->event), cause->event);
> }
> 
> static void iser_qp_event_callback(struct ib_event *cause, void *context)
> {
> -	iser_err("got qp event %d\n",cause->event);
> +	iser_err("qp event %s(%d)\n", IB_EVENT(cause->event), cause->event);
> }
> 
> static void iser_event_handler(struct ib_event_handler *handler,
> 				struct ib_event *event)
> {
> -	iser_err("async event %d on device %s port %d\n", event->event,
> -		event->device->name, event->element.port_num);
> +	iser_err("async event %s(%d) on device %s port %d\n",
> +		 IB_EVENT(event->event), event->event,
> +		 event->device->name, event->element.port_num);
> }
> 
> /**
> @@ -873,8 +874,9 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
> 	int ret = 0;
> 
> 	iser_conn = (struct iser_conn *)cma_id->context;
> -	iser_info("event %d status %d conn %p id %p\n",
> -		  event->event, event->status, cma_id->context, cma_id);
> +	iser_info("event %s(%d) status %d conn %p id %p\n",
> +		  CMA_EVENT(event->event), event->event,
> +		  event->status, cma_id->context, cma_id);
> 
> 	mutex_lock(&iser_conn->state_mutex);
> 	switch (event->event) {
> @@ -913,7 +915,8 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
> 		}
> 		break;
> 	default:
> -		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
> +		iser_err("Unexpected RDMA CM event %s(%d)\n",
> +			 CMA_EVENT(event->event), event->event);
> 		break;
> 	}
> 	mutex_unlock(&iser_conn->state_mutex);
> @@ -1173,10 +1176,12 @@ static void iser_handle_wc(struct ib_wc *wc)
> 		}
> 	} else {
> 		if (wc->status != IB_WC_WR_FLUSH_ERR)
> -			iser_err("wr id %llx status %d vend_err %x\n",
> -				 wc->wr_id, wc->status, wc->vendor_err);
> +			iser_err("%s(%d): wr id %llx vend_err %x\n",
> +				 WC_STATUS(wc->status), wc->status, wc->wr_id,
> +				 wc->vendor_err);
> 		else
> -			iser_dbg("flush error: wr id %llx\n", wc->wr_id);
> +			iser_dbg("%s(%d): wr id %llx\n",
> +				 WC_STATUS(wc->status), wc->status, wc->wr_id);
> 
> 		if (wc->wr_id == ISER_BEACON_WRID)
> 			/* all flush errors were consumed */
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 918814c..6b211c4 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -253,7 +253,7 @@ static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
> 
> static void srp_qp_event(struct ib_event *event, void *context)
> {
> -	pr_debug("QP event %d\n", event->event);
> +	pr_debug("QP event %s(%d)\n", IB_EVENT(event->event), event->event);
> }
> 
> static int srp_init_qp(struct srp_target_port *target,
> @@ -1932,17 +1932,18 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
> 	if (target->connected && !target->qp_in_error) {
> 		if (wr_id & LOCAL_INV_WR_ID_MASK) {
> 			shost_printk(KERN_ERR, target->scsi_host, PFX
> -				     "LOCAL_INV failed with status %d\n",
> -				     wc_status);
> +				     "LOCAL_INV failed with status %s(%d)\n",
> +				     WC_STATUS(wc_status), wc_status);
> 		} else if (wr_id & FAST_REG_WR_ID_MASK) {
> 			shost_printk(KERN_ERR, target->scsi_host, PFX
> -				     "FAST_REG_MR failed status %d\n",
> -				     wc_status);
> +				     "FAST_REG_MR failed status %s(%d)\n",
> +				     WC_STATUS(wc_status), wc_status);
> 		} else {
> 			shost_printk(KERN_ERR, target->scsi_host,
> -				     PFX "failed %s status %d for iu %p\n",
> +				     PFX "failed %s status %s(%d) for iu %p\n",
> 				     send_err ? "send" : "receive",
> -				     wc_status, (void *)(uintptr_t)wr_id);
> +				     WC_STATUS(wc_status), wc_status,
> +				     (void *)(uintptr_t)wr_id);
> 		}
> 		queue_work(system_long_wq, &target->tl_err_work);
> 	}
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..d615e63 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -412,6 +412,32 @@ enum ib_event_type {
> 	IB_EVENT_GID_CHANGE,
> };
> 
> +static const char * const ib_events[] = {
> +	"CQ_ERR",
> +	"QP_FATAL",
> +	"QP_REQ_ERR",
> +	"QP_ACCESS_ERR",
> +	"COMM_EST",
> +	"SQ_DRAINED",
> +	"PATH_MIG",
> +	"PATH_MIG_ERR",
> +	"DEVICE_FATAL",
> +	"PORT_ACTIVE",
> +	"PORT_ERR",
> +	"LID_CHANGE",
> +	"PKEY_CHANGE",
> +	"SM_CHANGE",
> +	"SRQ_ERR",
> +	"SRQ_LIMIT_REACHED",
> +	"QP_LAST_WQE_REACHED",
> +	"CLIENT_REREGISTER",
> +	"GID_CHANGE",
> +};
> +
> +#define IB_EVENT(event)						\
> +	((event) < ARRAY_SIZE(ib_events) ?			\
> +		ib_events[(event)] : "UNRECOGNIZED_EVENT")
> +
> struct ib_event {
> 	struct ib_device	*device;
> 	union {
> @@ -663,6 +689,35 @@ enum ib_wc_status {
> 	IB_WC_GENERAL_ERR
> };
> 
> +static const char * const wc_statuses[] = {
> +	"SUCCESS",
> +	"LOC_LEN_ERR",
> +	"LOC_QP_OP_ERR",
> +	"LOC_EEC_OP_ERR",
> +	"LOC_PROT_ERR",
> +	"WR_FLUSH_ERR",
> +	"MW_BIND_ERR",
> +	"BAD_RESP_ERR",
> +	"LOC_ACCESS_ERR",
> +	"REM_INV_REQ_ERR",
> +	"REM_ACCESS_ERR",
> +	"REM_OP_ERR",
> +	"RETRY_EXC_ERR",
> +	"RNR_RETRY_EXC_ERR",
> +	"LOC_RDD_VIOL_ERR",
> +	"REM_INV_RD_REQ_ERR",
> +	"REM_ABORT_ERR",
> +	"INV_EECN_ERR",
> +	"INV_EEC_STATE_ERR",
> +	"FATAL_ERR",
> +	"RESP_TIMEOUT_ERR",
> +	"GENERAL_ERR",
> +};
> +
> +#define WC_STATUS(status)					\
> +	((status) < ARRAY_SIZE(wc_statuses) ?			\
> +		wc_statuses[(status)] : "UNRECOGNIZED_STATUS")
> +
> enum ib_wc_opcode {
> 	IB_WC_SEND,
> 	IB_WC_RDMA_WRITE,
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index 1ed2088..4eec92c 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -62,6 +62,29 @@ enum rdma_cm_event_type {
> 	RDMA_CM_EVENT_TIMEWAIT_EXIT
> };
> 
> +static const char * const cma_events[] = {
> +	"ADDR_RESOLVED",
> +	"ADDR_ERROR",
> +	"ROUTE_RESOLVED",
> +	"ROUTE_ERROR",
> +	"CONNECT_REQUEST",
> +	"CONNECT_RESPONSE",
> +	"CONNECT_ERROR",
> +	"UNREACHABLE",
> +	"REJECTED",
> +	"ESTABLISHED",
> +	"DISCONNECTED",
> +	"DEVICE_REMOVAL",
> +	"MULTICAST_JOIN",
> +	"MULTICAST_ERROR",
> +	"ADDR_CHANGE",
> +	"TIMEWAIT_EXIT",
> +};
> +
> +#define CMA_EVENT(event)					\
> +	((event) < ARRAY_SIZE(cma_events) ?			\
> +		cma_events[(event)] : "UNRECOGNIZED_EVENT")
> +
> enum rdma_port_space {
> 	RDMA_PS_SDP   = 0x0001,
> 	RDMA_PS_IPOIB = 0x0002,
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 4870d27..8423dd2 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -105,32 +105,6 @@ rpcrdma_run_tasklet(unsigned long data)
> 
> static DECLARE_TASKLET(rpcrdma_tasklet_g, rpcrdma_run_tasklet, 0UL);
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
> static void
> rpcrdma_schedule_tasklet(struct list_head *sched_list)
> {
> @@ -148,7 +122,7 @@ rpcrdma_qp_async_error_upcall(struct ib_event *event, void *context)
> 	struct rpcrdma_ep *ep = context;
> 
> 	pr_err("RPC:       %s: %s on device %s ep %p\n",
> -	       __func__, ASYNC_MSG(event->event),
> +	       __func__, IB_EVENT(event->event),
> 		event->device->name, context);
> 	if (ep->rep_connected == 1) {
> 		ep->rep_connected = -EIO;
> @@ -163,7 +137,7 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
> 	struct rpcrdma_ep *ep = context;
> 
> 	pr_err("RPC:       %s: %s on device %s ep %p\n",
> -	       __func__, ASYNC_MSG(event->event),
> +	       __func__, IB_EVENT(event->event),
> 		event->device->name, context);
> 	if (ep->rep_connected == 1) {
> 		ep->rep_connected = -EIO;
> @@ -172,35 +146,6 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
> 	}
> }
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
> static void
> rpcrdma_sendcq_process_wc(struct ib_wc *wc)
> {
> @@ -209,7 +154,7 @@ rpcrdma_sendcq_process_wc(struct ib_wc *wc)
> 		if (wc->status != IB_WC_SUCCESS &&
> 		    wc->status != IB_WC_WR_FLUSH_ERR)
> 			pr_err("RPC:       %s: SEND: %s\n",
> -			       __func__, COMPLETION_MSG(wc->status));
> +			       __func__, WC_STATUS(wc->status));
> 	} else {
> 		struct rpcrdma_mw *r;

There is also a pr_warn() in frwr_sendcompletion() that should be
converted from displaying a numeric error code to a status string.

And, consider updating the NFS/RDMA server-side as well. See
cq_event_handler(), qp_event_handler(), and sq_cq_reap().

For the RPC/RDMA changes:

  Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

IMO you will need to get an Ack or Signed-off-by from Anna
Schumaker as well for the RPC/RDMA changes.


> @@ -302,7 +247,7 @@ out_schedule:
> out_fail:
> 	if (wc->status != IB_WC_WR_FLUSH_ERR)
> 		pr_err("RPC:       %s: rep %p: %s\n",
> -		       __func__, rep, COMPLETION_MSG(wc->status));
> +		       __func__, rep, WC_STATUS(wc->status));
> 	rep->rr_len = ~0U;
> 	goto out_schedule;
> }
> @@ -386,31 +331,6 @@ rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
> 		rpcrdma_sendcq_process_wc(&wc);
> }
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
> static int
> rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
> {
> @@ -476,7 +396,7 @@ connected:
> 	default:
> 		dprintk("RPC:       %s: %pIS:%u (ep 0x%p): %s\n",
> 			__func__, sap, rpc_get_port(sap), ep,
> -			CONNECTION_MSG(event->event));
> +			CMA_EVENT(event->event));
> 		break;
> 	}
> 
> -- 
> 1.7.1
> 

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
