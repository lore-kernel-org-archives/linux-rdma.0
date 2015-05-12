From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 5/6] xprtrdma: Switch to generic logging helpers
Date: Tue, 12 May 2015 16:08:45 +0300
Message-ID: <5551FB5D.4060509@dev.mellanox.co.il>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com>	 <1431432329-859-6-git-send-email-sagig@mellanox.com> <1431434425.25060.65.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431434425.25060.65.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/12/2015 3:40 PM, Yann Droneaud wrote:
> Hi,
>
> Le mardi 12 mai 2015 =C3=A0 15:05 +0300, Sagi Grimberg a =C3=A9crit :
>> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
>> ---
>>   net/sunrpc/xprtrdma/frwr_ops.c           |    4 +-
>>   net/sunrpc/xprtrdma/svc_rdma_transport.c |   29 ++++++----
>>   net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------=
------------
>>   3 files changed, 25 insertions(+), 98 deletions(-)
>>
>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/fr=
wr_ops.c
>> index dff0481..b3fda09 100644
>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>> @@ -128,8 +128,8 @@ frwr_sendcompletion(struct ib_wc *wc)
>>
>>   	/* WARNING: Only wr_id and status are reliable at this point */
>>   	r =3D (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
>> -	dprintk("RPC:       %s: frmr %p (stale), status %d\n",
>> -		__func__, r, wc->status);
>> +	dprintk("RPC:       %s: frmr %p (stale), status %s(%d)\n",
>> +		__func__, r, ib_wc_status_msg(wc->status), wc->status);
>>   	r->r.frmr.fr_state =3D FRMR_IS_STALE;
>>   }
>>
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/x=
prtrdma/svc_rdma_transport.c
>> index f609c1c..abd2d51 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> @@ -175,8 +175,8 @@ void svc_rdma_put_req_map(struct svc_rdma_req_ma=
p *map)
>>   static void cq_event_handler(struct ib_event *event, void *context=
)
>>   {
>>   	struct svc_xprt *xprt =3D context;
>> -	dprintk("svcrdma: received CQ event id=3D%d, context=3D%p\n",
>> -		event->event, context);
>> +	dprintk("svcrdma: received CQ event %s(%d), context=3D%p\n",
>> +		ib_event_msg(event->event), event->event, context);
>>   	set_bit(XPT_CLOSE, &xprt->xpt_flags);
>>   }
>>
>> @@ -191,8 +191,9 @@ static void qp_event_handler(struct ib_event *ev=
ent, void *context)
>>   	case IB_EVENT_COMM_EST:
>>   	case IB_EVENT_SQ_DRAINED:
>>   	case IB_EVENT_QP_LAST_WQE_REACHED:
>> -		dprintk("svcrdma: QP event %d received for QP=3D%p\n",
>> -			event->event, event->element.qp);
>> +		dprintk("svcrdma: QP event %s(%d) received for QP=3D%p\n",
>> +			ib_event_msg(event->event), event->event,
>> +			event->element.qp);
>>   		break;
>>   	/* These are considered fatal events */
>>   	case IB_EVENT_PATH_MIG_ERR:
>> @@ -201,9 +202,10 @@ static void qp_event_handler(struct ib_event *e=
vent, void *context)
>>   	case IB_EVENT_QP_ACCESS_ERR:
>>   	case IB_EVENT_DEVICE_FATAL:
>>   	default:
>> -		dprintk("svcrdma: QP ERROR event %d received for QP=3D%p, "
>> +		dprintk("svcrdma: QP ERROR event %s(%d) received for QP=3D%p, "
>>   			"closing transport\n",
>> -			event->event, event->element.qp);
>> +			ib_event_msg(event->event), event->event,
>> +			event->element.qp);
>>   		set_bit(XPT_CLOSE, &xprt->xpt_flags);
>>   		break;
>>   	}
>> @@ -402,7 +404,8 @@ static void sq_cq_reap(struct svcxprt_rdma *xprt=
)
>>   		for (i =3D 0; i < ret; i++) {
>>   			wc =3D &wc_a[i];
>>   			if (wc->status !=3D IB_WC_SUCCESS) {
>> -				dprintk("svcrdma: sq wc err status %d\n",
>> +				dprintk("svcrdma: sq wc err status %s(%d)\n",
>> +					ib_wc_status_msg(wc->status),
>>   					wc->status);
>>
>>   				/* Close the transport */
>> @@ -616,7 +619,8 @@ static int rdma_listen_handler(struct rdma_cm_id=
 *cma_id,
>>   	switch (event->event) {
>>   	case RDMA_CM_EVENT_CONNECT_REQUEST:
>>   		dprintk("svcrdma: Connect request on cma_id=3D%p, xprt =3D %p, "
>> -			"event=3D%d\n", cma_id, cma_id->context, event->event);
>> +			"event=3D%s(%d)\n", cma_id, cma_id->context,
>> +			rdma_event_msg(event->event), event->event);
>>   		handle_connect_req(cma_id,
>>   				   event->param.conn.initiator_depth);
>>   		break;
>> @@ -636,7 +640,8 @@ static int rdma_listen_handler(struct rdma_cm_id=
 *cma_id,
>>
>>   	default:
>>   		dprintk("svcrdma: Unexpected event on listening endpoint %p, "
>> -			"event=3D%d\n", cma_id, event->event);
>> +			"event=3D%s(%d)\n", cma_id, rdma_event_msg(event->event),
>> +			event->event);
>>   		break;
>>   	}
>>
>> @@ -669,7 +674,8 @@ static int rdma_cma_handler(struct rdma_cm_id *c=
ma_id,
>>   		break;
>>   	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>>   		dprintk("svcrdma: Device removal cma_id=3D%p, xprt =3D %p, "
>> -			"event=3D%d\n", cma_id, xprt, event->event);
>> +			"event=3D%s(%d)\n", cma_id, xprt,
>> +			rdma_event_msg(event->event), event->event);
>>   		if (xprt) {
>>   			set_bit(XPT_CLOSE, &xprt->xpt_flags);
>>   			svc_xprt_enqueue(xprt);
>> @@ -677,7 +683,8 @@ static int rdma_cma_handler(struct rdma_cm_id *c=
ma_id,
>>   		break;
>>   	default:
>>   		dprintk("svcrdma: Unexpected event on DTO endpoint %p, "
>> -			"event=3D%d\n", cma_id, event->event);
>> +			"event=3D%d\n", cma_id, rdma_event_msg(event->event),
>> +			event->event);
>
> There's something wrong here, %s is missing.
>

Yep, I'll fix that too...

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
