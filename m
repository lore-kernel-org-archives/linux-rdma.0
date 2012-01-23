From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Mon, 23 Jan 2012 17:11:45 +0100
Message-ID: <4F1D86C1.8050709@itwm.fraunhofer.de>
References: <1828884A29C6694DAF28B7E6B8A823732DC115E2@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC115E2-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/20/2012 07:43 PM, Hefty, Sean wrote:
>> However, what is is with user space setting type to IB_QPT_XRC_TGT?
>> I guess this could be solved by letting the kernel zero the memory
>> returned by ->ops.create_qp(pd, qp_init_attr). Btw, I didn't figure
>> out yet, how this translates at all in kernel space? Is this op
>> directly going to the device driver?
>
> ops.create_qp basically ends up going into the kernel into
> ib_uverbs_create_qp().

Thanks, I didn't find this.

>
>> But even if we are properly going to initialize the qp, what is
>> with user space mischievously trying to crash the system by
>> manipulating struct ib_qp *qp?
>
> There's cleanup in uverbs that ignores the return value from
> ib_destroy_qp(), basically because it shouldn't fail in those
> circumstances.  After calling ib_destroy_qp, uverbs will free some
> internal structures that some of the callback handlers expect to
> access.  This leads to the crashes that you're seeing.
>
> I think the problem is that your first patch is incomplete.
> ib_uverbs_create_qp() will create a QP by either calling
> ib_create_qp() or by calling the device directly (device->create_qp).
> qp->usecnt needs to be initialized in both cases.  Can you try this
> modification to your original patch?

Thanks, this works either. But a question here, couldn't we just add the 
"struct ib_udata *udata" as third parameter to ib_create_qp() and then 
remove the if-condition in ib_uverbs_create_qp()?

	if (cmd.qp_type == IB_QPT_XRC_TGT)
		qp = ib_create_qp(pd, &attr);
	else
		qp = device->create_qp(pd, &attr, &udata);


So reduce this to
	qp = ib_create_qp(pd, &attr, &attr);


Other callers of ib_create_qp() are not that many and would pass NULL 
instead.


Cheers,
Bernd

>
> From: Bernd Schubert<bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
>
> From: Sean Hefty<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> rdma/core: Fix kernel panic by always initializing qp->usecnt
>
> We have just been investigating kernel panics related to
> cq->ibcq.event_handler() completion calls.
>
> Reason is that ib_destroy_qp() fails with -EBUSY.  Further
> investigation revealed qp->usecnt is not initialized.  This counter
> was introduced in linux-3.2 by commit
> 0e0ec7e0638ef48e0c661873dfcc8caccab984c6 and is only initialized for
> IB_QPT_XRC_TGT, but also checked in ib_destroy_qp() for any qp type.
>
> Signed-off-by: Bernd Schubert<bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> Signed-off-by: Sven Breuner<sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> Signed-off-by: Sean Hefty<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> ---
> drivers/infiniband/core/uverbs_cmd.c |    1 +
> drivers/infiniband/core/verbs.c      |    2 +- 2 files changed, 2
> insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c index e26193f..e47dbf1 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c +++
> b/drivers/infiniband/core/uverbs_cmd.c @@ -1472,6 +1472,7 @@ ssize_t
> ib_uverbs_create_qp(struct ib_uverbs_file *file, qp->event_handler =
> attr.event_handler; qp->qp_context	  = attr.qp_context; qp->qp_type
> = attr.qp_type; +		atomic_set(&qp->usecnt, 0);
> atomic_inc(&pd->usecnt); atomic_inc(&attr.send_cq->usecnt); if
> (attr.recv_cq) diff --git a/drivers/infiniband/core/verbs.c
> b/drivers/infiniband/core/verbs.c index 602b1bd..575b780 100644 ---
> a/drivers/infiniband/core/verbs.c +++
> b/drivers/infiniband/core/verbs.c @@ -421,6 +421,7 @@ struct ib_qp
> *ib_create_qp(struct ib_pd *pd, qp->uobject    = NULL; qp->qp_type
> = qp_init_attr->qp_type;
>
> +		atomic_set(&qp->usecnt, 0); if (qp_init_attr->qp_type ==
> IB_QPT_XRC_TGT) { qp->event_handler = __ib_shared_qp_event_handler;
> qp->qp_context = qp; @@ -430,7 +431,6 @@ struct ib_qp
> *ib_create_qp(struct ib_pd *pd, qp->xrcd = qp_init_attr->xrcd;
> atomic_inc(&qp_init_attr->xrcd->usecnt);
> INIT_LIST_HEAD(&qp->open_list); -			atomic_set(&qp->usecnt, 0);
>
> real_qp = qp; qp = __ib_open_qp(real_qp,
> qp_init_attr->event_handler,
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
