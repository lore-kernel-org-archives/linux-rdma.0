From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/ucma.c: Different fix for ucma context uid=0,
 causing iWarp RDMA applications to fail in connection establishment
Date: Sun, 5 Aug 2012 06:48:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A7CA42@ORSMSX101.amr.corp.intel.com>
References: <20120803235940.GA4912@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120803235940.GA4912@TENIKOLO-MOBL>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 8002ae6..88c50d2 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -267,6 +267,7 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
>  	if (!uevent)
>  		return event->event == RDMA_CM_EVENT_CONNECT_REQUEST;
> 
> +	mutex_lock(&ctx->file->mut);
>  	uevent->cm_id = cm_id;
>  	ucma_set_event_context(ctx, event, uevent);

Roland, there's a race here where ucma_set_event_context() copies ctx->uid to the event structure outside of the mutex.  Once the mutex is acquired, ctx->uid is checked.  However, the uid could have changed between saving it off to the event and checking it.

>  	uevent->resp.event = event->event;
> @@ -277,7 +278,6 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
>  		ucma_copy_conn_event(&uevent->resp.param.conn,
>  				     &event->param.conn);
> 
> -	mutex_lock(&ctx->file->mut);
>  	if (event->event == RDMA_CM_EVENT_CONNECT_REQUEST) {
>  		if (!ctx->backlog) {
>  			ret = -ENOMEM;
> --
> 1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
