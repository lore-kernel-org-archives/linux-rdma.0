From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] xprtrdma: Split the completion queue
Date: Wed, 16 Apr 2014 11:08:33 -0400
Message-ID: <E9B601B5-1984-40D8-914A-DDD1380E8183@oracle.com>
References: <20140414220041.20646.63991.stgit@manet.1015granger.net> <20140414222323.20646.66946.stgit@manet.1015granger.net> <534E7C1C.5070407@dev.mellanox.co.il> <534E8608.8030801@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <534E8608.8030801-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi-

Thanks for the review! In-line replies below.


On Apr 16, 2014, at 9:30 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> w=
rote:

> On 4/16/2014 7:48 AM, Sagi Grimberg wrote:
>> On 4/15/2014 1:23 AM, Chuck Lever wrote:
>>> The current CQ handler uses the ib_wc.opcode field to distinguish
>>> between event types. However, the contents of that field are not
>>> reliable if the completion status is not IB_WC_SUCCESS.
>>>=20
>>> When an error completion occurs on a send event, the CQ handler
>>> schedules a tasklet with something that is not a struct rpcrdma_rep=
=2E
>>> This is never correct behavior, and sometimes it results in a panic=
=2E
>>>=20
>>> To resolve this issue, split the completion queue into a send CQ an=
d
>>> a receive CQ. The send CQ handler now handles only struct rpcrdma_m=
w
>>> wr_id's, and the receive CQ handler now handles only struct
>>> rpcrdma_rep wr_id's.
>>=20
>> Hey Chuck,
>>=20
>> So 2 suggestions related (although not directly) to this one.
>>=20
>> 1. I recommend suppressing Fastreg completions - no one cares that t=
hey succeeded.
>>=20
>=20
> Not true.  The nfsrdma client uses frmrs across re-connects for the s=
ame mount and needs to know at any point in time if a frmr is registere=
d or invalid.  So completions of both fastreg and invalidate need to be=
 signaled.  See:
>=20
> commit 5c635e09cec0feeeb310968e51dad01040244851
> Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
> Date:   Wed Feb 9 19:45:34 2011 +0000
>=20
>    RPCRDMA: Fix FRMR registration/invalidate handling.

Steve is correct. For the time being, fast_reg_mr completions have to s=
tay,
as they work around a real issue.

However, the long term goal is to suppress them, as you suggested a few
weeks ago. When we can identify and address the underlying FRMR leak th=
at
Tom has cleverly worked around in 5c635e09, then fast_reg_mr can be don=
e
without completions.

This is possibly related to the issue we are discussing in the other
thread =93[PATCH V1] NFS-REDMA: fix qp pointer validation checks=94.

>=20
>> 2. If I understood correctly, I see that the CQs are loop-polled in =
an interrupt context.
>>    This may become problematic in stress workload where the CQ simpl=
y never drains (imagine
>>    some studios task keeps posting WRs as soon as IOs complete). Thi=
s will cause CQ poll loop
>>    to go on forever. This situation may cause starvation of other CQ=
s that share the same EQ (CPU
>>    is hogged by the endless poller).
>>    This may be solved in 2 ways:
>>    - Use blk-iopoll to maintain fairness - the downside will be movi=
ng from interrupt context to soft-irq (slower).
>>    - Set some configurable budget to CQ poller - after finishing the=
 budget, notify the CQ and bail.
>>      If there is another CQ waiting to get in - it's only fair that =
it will be given with a chance, else another interrupt
>>      on that CQ will immediately come.

I think it would be a reasonable change to pass an array of WC=92s to
ib_poll_cq() just once in rpcrdma_{send,recv}cq_poll(), instead of
looping. Would that be enough?

To be clear, my patch merely cleans up the completion handler logic,
which already did loop-polling. Should we consider this improvement
for another patch?


>>=20
>>    I noticed that one with iSER which polls from tasklet context (un=
der heavy workload).
>>=20
>> Sagi.
>>=20
>>> Fix suggested by Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>=20
>>> Reported-by: Rafael Reiter <rafael.reiter-cv18SyjCLaheoWH0uzbU5w@public.gmane.org>
>>> Fixes: 5c635e09cec0feeeb310968e51dad01040244851
>>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D73211
>>> Tested-by: Klemens Senn <klemens.senn-cv18SyjCLaheoWH0uzbU5w@public.gmane.org>
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>=20
>>>  net/sunrpc/xprtrdma/verbs.c     |  228 +++++++++++++++++++++++----=
------------
>>>  net/sunrpc/xprtrdma/xprt_rdma.h |    1
>>>  2 files changed, 135 insertions(+), 94 deletions(-)
>>>=20
>>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verb=
s.c
>>> index 0f8c22c..35f5ab6 100644
>>> --- a/net/sunrpc/xprtrdma/verbs.c
>>> +++ b/net/sunrpc/xprtrdma/verbs.c
>>> @@ -142,96 +142,113 @@ rpcrdma_cq_async_error_upcall(struct ib_even=
t *event, void *context)
>>>      }
>>>  }
>>>  -static inline
>>> -void rpcrdma_event_process(struct ib_wc *wc)
>>> +static void
>>> +rpcrdma_send_event_process(struct ib_wc *wc)
>>>  {
>>> -    struct rpcrdma_mw *frmr;
>>> -    struct rpcrdma_rep *rep =3D
>>> -            (struct rpcrdma_rep *)(unsigned long) wc->wr_id;
>>> +    struct rpcrdma_mw *frmr =3D (struct rpcrdma_mw *)(unsigned lon=
g)wc->wr_id;
>>>  -    dprintk("RPC:       %s: event rep %p status %X opcode %X leng=
th %u\n",
>>> -        __func__, rep, wc->status, wc->opcode, wc->byte_len);
>>> +    dprintk("RPC:       %s: frmr %p status %X opcode %d\n",
>>> +        __func__, frmr, wc->status, wc->opcode);
>>>  -    if (!rep) /* send completion that we don't care about */
>>> +    if (wc->wr_id =3D=3D 0ULL)
>>>          return;
>>> -
>>> -    if (IB_WC_SUCCESS !=3D wc->status) {
>>> -        dprintk("RPC:       %s: WC opcode %d status %X, connection=
 lost\n",
>>> -            __func__, wc->opcode, wc->status);
>>> -        rep->rr_len =3D ~0U;
>>> -        if (wc->opcode !=3D IB_WC_FAST_REG_MR && wc->opcode !=3D I=
B_WC_LOCAL_INV)
>>> -            rpcrdma_schedule_tasklet(rep);
>>> +    if (wc->status !=3D IB_WC_SUCCESS)
>>>          return;
>>> -    }
>>>  -    switch (wc->opcode) {
>>> -    case IB_WC_FAST_REG_MR:
>>> -        frmr =3D (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
>>> +    if (wc->opcode =3D=3D IB_WC_FAST_REG_MR)
>>>          frmr->r.frmr.state =3D FRMR_IS_VALID;
>>> -        break;
>>> -    case IB_WC_LOCAL_INV:
>>> -        frmr =3D (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
>>> +    else if (wc->opcode =3D=3D IB_WC_LOCAL_INV)
>>>          frmr->r.frmr.state =3D FRMR_IS_INVALID;
>>> -        break;
>>> -    case IB_WC_RECV:
>>> -        rep->rr_len =3D wc->byte_len;
>>> -        ib_dma_sync_single_for_cpu(
>>> - rdmab_to_ia(rep->rr_buffer)->ri_id->device,
>>> -            rep->rr_iov.addr, rep->rr_len, DMA_FROM_DEVICE);
>>> -        /* Keep (only) the most recent credits, after check validi=
ty */
>>> -        if (rep->rr_len >=3D 16) {
>>> -            struct rpcrdma_msg *p =3D
>>> -                    (struct rpcrdma_msg *) rep->rr_base;
>>> -            unsigned int credits =3D ntohl(p->rm_credit);
>>> -            if (credits =3D=3D 0) {
>>> -                dprintk("RPC:       %s: server"
>>> -                    " dropped credits to 0!\n", __func__);
>>> -                /* don't deadlock */
>>> -                credits =3D 1;
>>> -            } else if (credits > rep->rr_buffer->rb_max_requests) =
{
>>> -                dprintk("RPC:       %s: server"
>>> -                    " over-crediting: %d (%d)\n",
>>> -                    __func__, credits,
>>> -                    rep->rr_buffer->rb_max_requests);
>>> -                credits =3D rep->rr_buffer->rb_max_requests;
>>> -            }
>>> -            atomic_set(&rep->rr_buffer->rb_credits, credits);
>>> -        }
>>> -        rpcrdma_schedule_tasklet(rep);
>>> -        break;
>>> -    default:
>>> -        dprintk("RPC:       %s: unexpected WC event %X\n",
>>> -            __func__, wc->opcode);
>>> -        break;
>>> -    }
>>>  }
>>>  -static inline int
>>> -rpcrdma_cq_poll(struct ib_cq *cq)
>>> +static int
>>> +rpcrdma_sendcq_poll(struct ib_cq *cq)
>>>  {
>>>      struct ib_wc wc;
>>>      int rc;
>>>  -    for (;;) {
>>> -        rc =3D ib_poll_cq(cq, 1, &wc);
>>> -        if (rc < 0) {
>>> -            dprintk("RPC:       %s: ib_poll_cq failed %i\n",
>>> -                __func__, rc);
>>> -            return rc;
>>> -        }
>>> -        if (rc =3D=3D 0)
>>> -            break;
>>> +    while ((rc =3D ib_poll_cq(cq, 1, &wc)) =3D=3D 1)
>>> +        rpcrdma_send_event_process(&wc);
>>> +    return rc;
>>> +}
>>>  -        rpcrdma_event_process(&wc);
>>> +/*
>>> + * Handle send, fast_reg_mr, and local_inv completions.
>>> + *
>>> + * Send events are typically suppressed and thus do not result
>>> + * in an upcall. Occasionally one is signaled, however. This
>>> + * prevents the provider's completion queue from wrapping and
>>> + * losing a completion.
>>> + */
>>> +static void
>>> +rpcrdma_sendcq_upcall(struct ib_cq *cq, void *cq_context)
>>> +{
>>> +    int rc;
>>> +
>>> +    rc =3D rpcrdma_sendcq_poll(cq);
>>> +    if (rc) {
>>> +        dprintk("RPC:       %s: ib_poll_cq failed: %i\n",
>>> +            __func__, rc);
>>> +        return;
>>>      }
>>> +    rc =3D ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>>> +    if (rc) {
>>> +        dprintk("RPC:       %s: ib_req_notify_cq failed: %i\n",
>>> +            __func__, rc);
>>> +        return;
>>> +    }
>>> +    rpcrdma_sendcq_poll(cq);
>>> +}
>>>  -    return 0;
>>> +static void
>>> +rpcrdma_recv_event_process(struct ib_wc *wc)
>>> +{
>>> +    struct rpcrdma_rep *rep =3D
>>> +            (struct rpcrdma_rep *)(unsigned long)wc->wr_id;
>>> +
>>> +    dprintk("RPC:       %s: rep %p status %X opcode %X length %u\n=
",
>>> +        __func__, rep, wc->status, wc->opcode, wc->byte_len);
>>> +
>>> +    if (wc->status !=3D IB_WC_SUCCESS) {
>>> +        rep->rr_len =3D ~0U;
>>> +        goto out_schedule;
>>> +    }
>>> +    if (wc->opcode !=3D IB_WC_RECV)
>>> +        return;
>>> +
>>> +    rep->rr_len =3D wc->byte_len;
>>> + ib_dma_sync_single_for_cpu(rdmab_to_ia(rep->rr_buffer)->ri_id->de=
vice,
>>> +            rep->rr_iov.addr, rep->rr_len, DMA_FROM_DEVICE);
>>> +
>>> +    if (rep->rr_len >=3D 16) {
>>> +        struct rpcrdma_msg *p =3D (struct rpcrdma_msg *)rep->rr_ba=
se;
>>> +        unsigned int credits =3D ntohl(p->rm_credit);
>>> +
>>> +        if (credits =3D=3D 0)
>>> +            credits =3D 1;    /* don't deadlock */
>>> +        else if (credits > rep->rr_buffer->rb_max_requests)
>>> +            credits =3D rep->rr_buffer->rb_max_requests;
>>> +        atomic_set(&rep->rr_buffer->rb_credits, credits);
>>> +    }
>>> +
>>> +out_schedule:
>>> +    rpcrdma_schedule_tasklet(rep);
>>> +}
>>> +
>>> +static int
>>> +rpcrdma_recvcq_poll(struct ib_cq *cq)
>>> +{
>>> +    struct ib_wc wc;
>>> +    int rc;
>>> +
>>> +    while ((rc =3D ib_poll_cq(cq, 1, &wc)) =3D=3D 1)
>>> +        rpcrdma_recv_event_process(&wc);
>>> +    return rc;
>>>  }
>>>    /*
>>> - * rpcrdma_cq_event_upcall
>>> + * Handle receive completions.
>>>   *
>>> - * This upcall handles recv and send events.
>>>   * It is reentrant but processes single events in order to maintai=
n
>>>   * ordering of receives to keep server credits.
>>>   *
>>> @@ -240,26 +257,25 @@ rpcrdma_cq_poll(struct ib_cq *cq)
>>>   * connection shutdown. That is, the structures required for
>>>   * the completion of the reply handler must remain intact until
>>>   * all memory has been reclaimed.
>>> - *
>>> - * Note that send events are suppressed and do not result in an up=
call.
>>>   */
>>>  static void
>>> -rpcrdma_cq_event_upcall(struct ib_cq *cq, void *context)
>>> +rpcrdma_recvcq_upcall(struct ib_cq *cq, void *cq_context)
>>>  {
>>>      int rc;
>>>  -    rc =3D rpcrdma_cq_poll(cq);
>>> -    if (rc)
>>> +    rc =3D rpcrdma_recvcq_poll(cq);
>>> +    if (rc) {
>>> +        dprintk("RPC:       %s: ib_poll_cq failed: %i\n",
>>> +            __func__, rc);
>>>          return;
>>> -
>>> +    }
>>>      rc =3D ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>>>      if (rc) {
>>> -        dprintk("RPC:       %s: ib_req_notify_cq failed %i\n",
>>> +        dprintk("RPC:       %s: ib_req_notify_cq failed: %i\n",
>>>              __func__, rc);
>>>          return;
>>>      }
>>> -
>>> -    rpcrdma_cq_poll(cq);
>>> +    rpcrdma_recvcq_poll(cq);
>>>  }
>>>    #ifdef RPC_DEBUG
>>> @@ -613,6 +629,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct=
 rpcrdma_ia *ia,
>>>                  struct rpcrdma_create_data_internal *cdata)
>>>  {
>>>      struct ib_device_attr devattr;
>>> +    struct ib_cq *sendcq, *recvcq;
>>>      int rc, err;
>>>        rc =3D ib_query_device(ia->ri_id->device, &devattr);
>>> @@ -688,7 +705,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct=
 rpcrdma_ia *ia,
>>>          ep->rep_attr.cap.max_recv_sge);
>>>        /* set trigger for requesting send completion */
>>> -    ep->rep_cqinit =3D ep->rep_attr.cap.max_send_wr/2 /*  - 1*/;
>>> +    ep->rep_cqinit =3D ep->rep_attr.cap.max_send_wr/2 - 1;
>>>      if (ep->rep_cqinit <=3D 2)
>>>          ep->rep_cqinit =3D 0;
>>>      INIT_CQCOUNT(ep);
>>> @@ -696,26 +713,43 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, stru=
ct rpcrdma_ia *ia,
>>>      init_waitqueue_head(&ep->rep_connect_wait);
>>>      INIT_DELAYED_WORK(&ep->rep_connect_worker, rpcrdma_connect_wor=
ker);
>>>  -    ep->rep_cq =3D ib_create_cq(ia->ri_id->device, rpcrdma_cq_eve=
nt_upcall,
>>> +    sendcq =3D ib_create_cq(ia->ri_id->device, rpcrdma_sendcq_upca=
ll,
>>>                    rpcrdma_cq_async_error_upcall, NULL,
>>> -                  ep->rep_attr.cap.max_recv_wr +
>>>                    ep->rep_attr.cap.max_send_wr + 1, 0);
>>> -    if (IS_ERR(ep->rep_cq)) {
>>> -        rc =3D PTR_ERR(ep->rep_cq);
>>> -        dprintk("RPC:       %s: ib_create_cq failed: %i\n",
>>> +    if (IS_ERR(sendcq)) {
>>> +        rc =3D PTR_ERR(sendcq);
>>> +        dprintk("RPC:       %s: failed to create send CQ: %i\n",
>>>              __func__, rc);
>>>          goto out1;
>>>      }
>>>  -    rc =3D ib_req_notify_cq(ep->rep_cq, IB_CQ_NEXT_COMP);
>>> +    rc =3D ib_req_notify_cq(sendcq, IB_CQ_NEXT_COMP);
>>>      if (rc) {
>>>          dprintk("RPC:       %s: ib_req_notify_cq failed: %i\n",
>>>              __func__, rc);
>>>          goto out2;
>>>      }
>>>  -    ep->rep_attr.send_cq =3D ep->rep_cq;
>>> -    ep->rep_attr.recv_cq =3D ep->rep_cq;
>>> +    recvcq =3D ib_create_cq(ia->ri_id->device, rpcrdma_recvcq_upca=
ll,
>>> +                  rpcrdma_cq_async_error_upcall, NULL,
>>> +                  ep->rep_attr.cap.max_recv_wr + 1, 0);
>>> +    if (IS_ERR(recvcq)) {
>>> +        rc =3D PTR_ERR(recvcq);
>>> +        dprintk("RPC:       %s: failed to create recv CQ: %i\n",
>>> +            __func__, rc);
>>> +        goto out2;
>>> +    }
>>> +
>>> +    rc =3D ib_req_notify_cq(recvcq, IB_CQ_NEXT_COMP);
>>> +    if (rc) {
>>> +        dprintk("RPC:       %s: ib_req_notify_cq failed: %i\n",
>>> +            __func__, rc);
>>> +        ib_destroy_cq(recvcq);
>>> +        goto out2;
>>> +    }
>>> +
>>> +    ep->rep_attr.send_cq =3D sendcq;
>>> +    ep->rep_attr.recv_cq =3D recvcq;
>>>        /* Initialize cma parameters */
>>>  @@ -737,7 +771,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struc=
t rpcrdma_ia *ia,
>>>      return 0;
>>>    out2:
>>> -    err =3D ib_destroy_cq(ep->rep_cq);
>>> +    err =3D ib_destroy_cq(sendcq);
>>>      if (err)
>>>          dprintk("RPC:       %s: ib_destroy_cq returned %i\n",
>>>              __func__, err);
>>> @@ -777,8 +811,14 @@ rpcrdma_ep_destroy(struct rpcrdma_ep *ep, stru=
ct rpcrdma_ia *ia)
>>>          ep->rep_pad_mr =3D NULL;
>>>      }
>>>  -    rpcrdma_clean_cq(ep->rep_cq);
>>> -    rc =3D ib_destroy_cq(ep->rep_cq);
>>> +    rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>>> +    rc =3D ib_destroy_cq(ep->rep_attr.recv_cq);
>>> +    if (rc)
>>> +        dprintk("RPC:       %s: ib_destroy_cq returned %i\n",
>>> +            __func__, rc);
>>> +
>>> +    rpcrdma_clean_cq(ep->rep_attr.send_cq);
>>> +    rc =3D ib_destroy_cq(ep->rep_attr.send_cq);
>>>      if (rc)
>>>          dprintk("RPC:       %s: ib_destroy_cq returned %i\n",
>>>              __func__, rc);
>>> @@ -801,7 +841,9 @@ retry:
>>>          if (rc && rc !=3D -ENOTCONN)
>>>              dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>>>                  " status %i\n", __func__, rc);
>>> -        rpcrdma_clean_cq(ep->rep_cq);
>>> +
>>> +        rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>>> +        rpcrdma_clean_cq(ep->rep_attr.send_cq);
>>>            xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
>>>          id =3D rpcrdma_create_id(xprt, ia,
>>> @@ -910,7 +952,8 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, st=
ruct rpcrdma_ia *ia)
>>>  {
>>>      int rc;
>>>  -    rpcrdma_clean_cq(ep->rep_cq);
>>> +    rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>>> +    rpcrdma_clean_cq(ep->rep_attr.send_cq);
>>>      rc =3D rdma_disconnect(ia->ri_id);
>>>      if (!rc) {
>>>          /* returns without wait if not connected */
>>> @@ -1793,7 +1836,6 @@ rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
>>>      ib_dma_sync_single_for_cpu(ia->ri_id->device,
>>>          rep->rr_iov.addr, rep->rr_iov.length, DMA_BIDIRECTIONAL);
>>>  -    DECR_CQCOUNT(ep);
>>>      rc =3D ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
>>>        if (rc)
>>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/=
xprt_rdma.h
>>> index 362a19d..334ab6e 100644
>>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>>> @@ -79,7 +79,6 @@ struct rpcrdma_ep {
>>>      int            rep_cqinit;
>>>      int            rep_connected;
>>>      struct rpcrdma_ia    *rep_ia;
>>> -    struct ib_cq        *rep_cq;
>>>      struct ib_qp_init_attr    rep_attr;
>>>      wait_queue_head_t     rep_connect_wait;
>>>      struct ib_sge        rep_pad;    /* holds zeroed pad */
>>>=20
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>=20
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
