From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 08/14] xprtrdma: Acquire MRs in rpcrdma_register_external()
Date: Fri, 8 May 2015 11:40:14 -0400
Message-ID: <6FBAAAF3-3E70-418F-A887-C022525D6C4F@oracle.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175758.3483.44890.stgit@manet.1015granger.net> <554B3EEB.7070302@dev.mellanox.co.il> <CANjDDBiGLcaAofGwz6OGEXUUE_b2rcZepv0ebvTc-XNVEBq5Mw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBiGLcaAofGwz6OGEXUUE_b2rcZepv0ebvTc-XNVEBq5Mw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 8, 2015, at 11:24 AM, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org=
> wrote:

> On Thu, May 7, 2015 at 4:01 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiiQ@public.gmane.org=
il> wrote:
>> On 5/4/2015 8:57 PM, Chuck Lever wrote:
>>>=20
>>> Acquiring 64 MRs in rpcrdma_buffer_get() while holding the buffer
>>> pool lock is expensive, and unnecessary because most modern adapter=
s
>>> can transfer 100s of KBs of payload using just a single MR.
>>>=20
>>> Instead, acquire MRs one-at-a-time as chunks are registered, and
>>> return them to rb_mws immediately during deregistration.
>>>=20
>>> Note: commit 539431a437d2 ("xprtrdma: Don't invalidate FRMRs if
>>> registration fails") is reverted: There is now a valid case where
>>> registration can fail (with -ENOMEM) but the QP is still in RTS.
>>>=20
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  net/sunrpc/xprtrdma/frwr_ops.c |  120
>>> ++++++++++++++++++++++++++++------------
>>>  net/sunrpc/xprtrdma/rpc_rdma.c |    3 -
>>>  net/sunrpc/xprtrdma/verbs.c    |   21 -------
>>>  3 files changed, 86 insertions(+), 58 deletions(-)
>>>=20
>>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c
>>> b/net/sunrpc/xprtrdma/frwr_ops.c
>>> index a06d9a3..6f93a89 100644
>>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>>> @@ -11,6 +11,62 @@
>>>   * but most complex memory registration mode.
>>>   */
>>>=20
>>> +/* Normal operation
>>> + *
>>> + * A Memory Region is prepared for RDMA READ or WRITE using a FAST=
_REG
>>> + * Work Request (frmr_op_map). When the RDMA operation is finished=
, this
>>> + * Memory Region is invalidated using a LOCAL_INV Work Request
>>> + * (frmr_op_unmap).
>>> + *
>>> + * Typically these Work Requests are not signaled, and neither are=
 RDMA
>>> + * SEND Work Requests (with the exception of signaling occasionall=
y to
>>> + * prevent provider work queue overflows). This greatly reduces HC=
A
>>> + * interrupt workload.
>>> + *
>>> + * As an optimization, frwr_op_unmap marks MRs INVALID before the
>>> + * LOCAL_INV WR is posted. If posting succeeds, the MR is placed o=
n
>>> + * rb_mws immediately so that no work (like managing a linked list
>>> + * under a spinlock) is needed in the completion upcall.
>>> + *
>>> + * But this means that frwr_op_map() can occasionally encounter an=
 MR
>>> + * that is INVALID but the LOCAL_INV WR has not completed. Work Qu=
eue
>>> + * ordering prevents a subsequent FAST_REG WR from executing again=
st
>>> + * that MR while it is still being invalidated.
>>> + */
>>> +
>>> +/* Transport recovery
>>> + *
>>> + * ->op_map and the transport connect worker cannot run at the sam=
e
>>> + * time, but ->op_unmap can fire while the transport connect worke=
r
>>> + * is running. Thus MR recovery is handled in ->op_map, to guarant=
ee
>>> + * that recovered MRs are owned by a sending RPC, and not one wher=
e
>>> + * ->op_unmap could fire at the same time transport reconnect is
>>> + * being done.
>>> + *
>>> + * When the underlying transport disconnects, MRs are left in one =
of
>>> + * three states:
>>> + *
>>> + * INVALID:    The MR was not in use before the QP entered ERROR s=
tate.
>>> + *             (Or, the LOCAL_INV WR has not completed or flushed =
yet).
>>> + *
>>> + * STALE:      The MR was being registered or unregistered when th=
e QP
>>> + *             entered ERROR state, and the pending WR was flushed=
=2E
>>> + *
>>> + * VALID:      The MR was registered before the QP entered ERROR s=
tate.
>>> + *
>>> + * When frwr_op_map encounters STALE and VALID MRs, they are recov=
ered
>>> + * with ib_dereg_mr and then are re-initialized. Beause MR recover=
y
>>> + * allocates fresh resources, it is deferred to a workqueue, and t=
he
>>> + * recovered MRs are placed back on the rb_mws list when recovery =
is
>>> + * complete. frwr_op_map allocates another MR for the current RPC =
while
>>> + * the broken MR is reset.
>>> + *
>>> + * To ensure that frwr_op_map doesn't encounter an MR that is mark=
ed
>>> + * INVALID but that is about to be flushed due to a previous trans=
port
>>> + * disconnect, the transport connect worker attempts to drain all
>>> + * pending send queue WRs before the transport is reconnected.
>>> + */
>>> +
>>>  #include "xprt_rdma.h"
>>>=20
>>>  #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
>>> @@ -250,9 +306,9 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct
>>> rpcrdma_mr_seg *seg,
>>>        struct ib_device *device =3D ia->ri_device;
>>>        enum dma_data_direction direction =3D rpcrdma_data_dir(writi=
ng);
>>>        struct rpcrdma_mr_seg *seg1 =3D seg;
>>> -       struct rpcrdma_mw *mw =3D seg1->rl_mw;
>>> -       struct rpcrdma_frmr *frmr =3D &mw->r.frmr;
>>> -       struct ib_mr *mr =3D frmr->fr_mr;
>>> +       struct rpcrdma_mw *mw;
>>> +       struct rpcrdma_frmr *frmr;
>>> +       struct ib_mr *mr;
>>>        struct ib_send_wr fastreg_wr, *bad_wr;
>>>        u8 key;
>>>        int len, pageoff;
>>> @@ -261,12 +317,25 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, stru=
ct
>>> rpcrdma_mr_seg *seg,
>>>        u64 pa;
>>>        int page_no;
>>>=20
>>> +       mw =3D seg1->rl_mw;
>>> +       seg1->rl_mw =3D NULL;
>>> +       do {
>>> +               if (mw)
>>> +                       __frwr_queue_recovery(mw);
>>> +               mw =3D rpcrdma_get_mw(r_xprt);
>>> +               if (!mw)
>>> +                       return -ENOMEM;
>>> +       } while (mw->r.frmr.fr_state !=3D FRMR_IS_INVALID);
>>> +       frmr =3D &mw->r.frmr;
>>> +       frmr->fr_state =3D FRMR_IS_VALID;
>>> +
>>>        pageoff =3D offset_in_page(seg1->mr_offset);
>>>        seg1->mr_offset -=3D pageoff;     /* start of page */
>>>        seg1->mr_len +=3D pageoff;
>>>        len =3D -pageoff;
>>>        if (nsegs > ia->ri_max_frmr_depth)
>>>                nsegs =3D ia->ri_max_frmr_depth;
>>> +
>>>        for (page_no =3D i =3D 0; i < nsegs;) {
>>>                rpcrdma_map_one(device, seg, direction);
>>>                pa =3D seg->mr_dma;
>>> @@ -285,8 +354,6 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct
>>> rpcrdma_mr_seg *seg,
>>>        dprintk("RPC:       %s: Using frmr %p to map %d segments (%d
>>> bytes)\n",
>>>                __func__, mw, i, len);
>>>=20
>>> -       frmr->fr_state =3D FRMR_IS_VALID;
>>> -
>>>        memset(&fastreg_wr, 0, sizeof(fastreg_wr));
>>>        fastreg_wr.wr_id =3D (unsigned long)(void *)mw;
>>>        fastreg_wr.opcode =3D IB_WR_FAST_REG_MR;
>>> @@ -298,6 +365,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct
>>> rpcrdma_mr_seg *seg,
>>>        fastreg_wr.wr.fast_reg.access_flags =3D writing ?
>>>                                IB_ACCESS_REMOTE_WRITE |
>>> IB_ACCESS_LOCAL_WRITE :
>>>                                IB_ACCESS_REMOTE_READ;
>>> +       mr =3D frmr->fr_mr;
>>>        key =3D (u8)(mr->rkey & 0x000000FF);
>>>        ib_update_fast_reg_key(mr, ++key);
>>>        fastreg_wr.wr.fast_reg.rkey =3D mr->rkey;
>>> @@ -307,6 +375,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct
>>> rpcrdma_mr_seg *seg,
>>>        if (rc)
>>>                goto out_senderr;
>>>=20
>>> +       seg1->rl_mw =3D mw;
>>>        seg1->mr_rkey =3D mr->rkey;
>>>        seg1->mr_base =3D seg1->mr_dma + pageoff;
>>>        seg1->mr_nsegs =3D i;
>>> @@ -315,10 +384,9 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struc=
t
>>> rpcrdma_mr_seg *seg,
>>>=20
>>>  out_senderr:
>>>        dprintk("RPC:       %s: ib_post_send status %i\n", __func__,=
 rc);
>>> -       ib_update_fast_reg_key(mr, --key);
>>> -       frmr->fr_state =3D FRMR_IS_INVALID;
>>>        while (i--)
>>>                rpcrdma_unmap_one(device, --seg);
>>> +       __frwr_queue_recovery(mw);
>>>        return rc;
>>>  }
>>>=20
>>> @@ -330,15 +398,19 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, st=
ruct
>>> rpcrdma_mr_seg *seg)
>>>  {
>>>        struct rpcrdma_mr_seg *seg1 =3D seg;
>>>        struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>> +       struct rpcrdma_mw *mw =3D seg1->rl_mw;
>>>        struct ib_send_wr invalidate_wr, *bad_wr;
>>>        int rc, nsegs =3D seg->mr_nsegs;
>>>=20
>>> -       seg1->rl_mw->r.frmr.fr_state =3D FRMR_IS_INVALID;
>>> +       dprintk("RPC:       %s: FRMR %p\n", __func__, mw);
>>> +
>>> +       seg1->rl_mw =3D NULL;
>>> +       mw->r.frmr.fr_state =3D FRMR_IS_INVALID;
>>>=20
>>>        memset(&invalidate_wr, 0, sizeof(invalidate_wr));
>>> -       invalidate_wr.wr_id =3D (unsigned long)(void *)seg1->rl_mw;
>>> +       invalidate_wr.wr_id =3D (unsigned long)(void *)mw;
>>>        invalidate_wr.opcode =3D IB_WR_LOCAL_INV;
>>> -       invalidate_wr.ex.invalidate_rkey =3D
>>> seg1->rl_mw->r.frmr.fr_mr->rkey;
>>> +       invalidate_wr.ex.invalidate_rkey =3D mw->r.frmr.fr_mr->rkey=
;
>>>        DECR_CQCOUNT(&r_xprt->rx_ep);
>>>=20
>>>        while (seg1->mr_nsegs--)
>>> @@ -348,12 +420,13 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, st=
ruct
>>> rpcrdma_mr_seg *seg)
>>>        read_unlock(&ia->ri_qplock);
>>>        if (rc)
>>>                goto out_err;
>>> +
>>> +       rpcrdma_put_mw(r_xprt, mw);
>>>        return nsegs;
>>>=20
>>>  out_err:
>>> -       /* Force rpcrdma_buffer_get() to retry */
>>> -       seg1->rl_mw->r.frmr.fr_state =3D FRMR_IS_STALE;
>>>        dprintk("RPC:       %s: ib_post_send status %i\n", __func__,=
 rc);
>>> +       __frwr_queue_recovery(mw);
>>>        return nsegs;
>>>  }
>>>=20
>>> @@ -370,29 +443,6 @@ out_err:
>>>  static void
>>>  frwr_op_reset(struct rpcrdma_xprt *r_xprt)
>>>  {
>>> -       struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>>> -       struct ib_device *device =3D r_xprt->rx_ia.ri_device;
>>> -       unsigned int depth =3D r_xprt->rx_ia.ri_max_frmr_depth;
>>> -       struct ib_pd *pd =3D r_xprt->rx_ia.ri_pd;
>>> -       struct rpcrdma_mw *r;
>>> -       int rc;
>>> -
>>> -       list_for_each_entry(r, &buf->rb_all, mw_all) {
>>> -               if (r->r.frmr.fr_state =3D=3D FRMR_IS_INVALID)
>>> -                       continue;
>>> -
>>> -               __frwr_release(r);
>>> -               rc =3D __frwr_init(r, pd, device, depth);
>>> -               if (rc) {
>>> -                       dprintk("RPC:       %s: mw %p left %s\n",
>>> -                               __func__, r,
>>> -                               (r->r.frmr.fr_state =3D=3D FRMR_IS_=
STALE ?
>>> -                                       "stale" : "valid"));
>>> -                       continue;
>>> -               }
>>> -
>>> -               r->r.frmr.fr_state =3D FRMR_IS_INVALID;
>>> -       }
>>>  }
>>>=20
>>>  static void
>>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c
>>> b/net/sunrpc/xprtrdma/rpc_rdma.c
>>> index 98a3b95..35ead0b 100644
>>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>>> @@ -284,9 +284,6 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, st=
ruct
>>> xdr_buf *target,
>>>        return (unsigned char *)iptr - (unsigned char *)headerp;
>>>=20
>>>  out:
>>> -       if (r_xprt->rx_ia.ri_memreg_strategy =3D=3D RPCRDMA_FRMR)
>>> -               return n;
>>> -
>>>        for (pos =3D 0; nchunks--;)
>>>                pos +=3D r_xprt->rx_ia.ri_ops->ro_unmap(r_xprt,
>>>=20
>>> &req->rl_segments[pos]);
>>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verb=
s.c
>>> index 8a43c7ef..5226161 100644
>>> --- a/net/sunrpc/xprtrdma/verbs.c
>>> +++ b/net/sunrpc/xprtrdma/verbs.c
>>> @@ -1343,12 +1343,11 @@ rpcrdma_buffer_get_frmrs(struct rpcrdma_req=
 *req,
>>> struct rpcrdma_buffer *buf,
>>>  struct rpcrdma_req *
>>>  rpcrdma_buffer_get(struct rpcrdma_buffer *buffers)
>>>  {
>>> -       struct rpcrdma_ia *ia =3D rdmab_to_ia(buffers);
>>> -       struct list_head stale;
>>>        struct rpcrdma_req *req;
>>>        unsigned long flags;
>>>=20
>>>        spin_lock_irqsave(&buffers->rb_lock, flags);
>>> +
>>>        if (buffers->rb_send_index =3D=3D buffers->rb_max_requests) =
{
>>>                spin_unlock_irqrestore(&buffers->rb_lock, flags);
>>>                dprintk("RPC:       %s: out of request buffers\n",
>>> __func__);
>>> @@ -1367,17 +1366,7 @@ rpcrdma_buffer_get(struct rpcrdma_buffer *bu=
ffers)
>>>        }
>>>        buffers->rb_send_bufs[buffers->rb_send_index++] =3D NULL;
>>>=20
>>> -       INIT_LIST_HEAD(&stale);
>>> -       switch (ia->ri_memreg_strategy) {
>>> -       case RPCRDMA_FRMR:
>>> -               req =3D rpcrdma_buffer_get_frmrs(req, buffers, &sta=
le);
>>> -               break;
>>> -       default:
>>> -               break;
>>> -       }
>>>        spin_unlock_irqrestore(&buffers->rb_lock, flags);
>>> -       if (!list_empty(&stale))
>>> -               rpcrdma_retry_flushed_linv(&stale, buffers);
>>>        return req;
>>>  }
>>>=20
>>> @@ -1389,18 +1378,10 @@ void
>>>  rpcrdma_buffer_put(struct rpcrdma_req *req)
>>>  {
>>>        struct rpcrdma_buffer *buffers =3D req->rl_buffer;
>>> -       struct rpcrdma_ia *ia =3D rdmab_to_ia(buffers);
>>>        unsigned long flags;
>>>=20
>>>        spin_lock_irqsave(&buffers->rb_lock, flags);
>>>        rpcrdma_buffer_put_sendbuf(req, buffers);
>>> -       switch (ia->ri_memreg_strategy) {
>>> -       case RPCRDMA_FRMR:
>>> -               rpcrdma_buffer_put_mrs(req, buffers);
>>> -               break;
>>> -       default:
>>> -               break;
>>> -       }
>>>        spin_unlock_irqrestore(&buffers->rb_lock, flags);
>>>  }
>>>=20
>>>=20
>>=20
>> Don't you need a call to flush_workqueue(frwr_recovery_wq) when you'=
re
>> about to destroy the endpoint (and the buffers and the MRs...)?
>=20
> I agree with Sagi here, in xprt_rdma_destroy() before calling
> rpcrdma_destroy_buffer(), flush_workqueue and cancelling any pending
> work seems required.

The buffer list is destroyed only when all work has completed on the
transport (no RPCs are outstanding, and the upper layer is shutting
down). It=92s pretty unlikely that there will be ongoing recovery work
at this point.

That said, would it be enough to add a defensive call to flush_workqueu=
e()
at the top of frwr_op_destroy() ?

> With the optimization, is it possible that before completion of
> REG-FRMR sever starts traffic on a yet-to-be-reg-complete rkey, this
> will cause access-error async event on client side and server will se=
e
> flush errors.

The server starts driving RDMA transfers only after it receives a
retransmitted RPC (with a fresh rkey). The client can=92t retransmit
an RPC until it has fresh =93invalid=94 MRs to use.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
