From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
Date: Thu, 10 Apr 2014 13:43:33 -0400
Message-ID: <D7836AB3-FCB6-40EF-9954-B58A05A87791@oracle.com>
References: <014738b6-698e-4ea1-82f9-287378bfec19@CMEXHTCAS2.ad.emulex.com> <D7AB2150-5F25-4BA2-80D9-94890AD11F8F@primarydata.com> <F1C70AD6-BDD4-4534-8DC4-61D2767581D9@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEAA43@CMEXMB1.ad.emulex.com> <E66D006A-0D04-4602-8BF5-6834CACD2E24@oracle.com> <5346B22D.3060706@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5346B22D.3060706-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Apr 10, 2014, at 11:01 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

> On 4/9/2014 7:26 PM, Chuck Lever wrote:
>> On Apr 9, 2014, at 7:56 PM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>=20
>>> Hi Chuk and Trond
>>>=20
>>> I will resend a v2 for this.
>>> What if ib_post_send() fails with immidate error, I that case also =
DECR_CQCOUNT() will be called but no completion will be reported. Will =
that not cause any problems?
>> We should investigate whether an error return from ib_post_{send,rec=
v} means there will be no completion. But I=92ve never seen these verbs=
 fail in practice, so I=92m not in a hurry to make work for anyone! ;-)
>=20
> A synchronous failure from ib_post_* means the WR (or at least one of=
 them if there were > 1) failed and did not get submitted to HW.  So th=
ere will be no completion for those that failed.

OK.

Our post operations are largely single WRs. Before we address CQCOUNT i=
n error cases, we=92d have to deal with chained WRs.

Chained WRs are used only when rpcrdma_register_frmr_external() finds a=
n MR that hasn=92t been invalidated. That=92s actually working around a=
 FRMR re-use bug (commit 5c635e09). If the underlying re-use problem wa=
s fixed, we could get rid of the chained WR in register_frmr_external()=
 (and we wouldn=92t need completions at all for FAST_REG_MR).

But at 100,000 feet, if a post operation fails, that seems like a very =
serious issue. I wonder whether we would be better off disconnecting an=
d starting over in those cases.

>=20
>> However it seems to me the new (!ia->ri_id->qp) checks outside the c=
onnect logic are unnecessary.
>>=20
>> Clearly, as you noticed, the ib_post_{send,recv} verbs do not check =
that their =93qp" argument is NULL before dereferencing it.
>>=20
>> But I don=92t understand how xprtrdma can post any operation if the =
transport isn=92t connected. In other words, how would it be possible t=
o call rpcrdma_ep_post_recv() if the connect had failed and there was n=
o QP?
>>=20
>> If disconnect wipes ia->ri_id->qp while there are still operations i=
n progress, that would be the real bug.
>>=20
>>=20
>>> Also in rpcrdma_register_frmr_external() I am seeing DECT_CQCOUNT i=
s called twice
>>> First at line 1538 (unlikely however) and second at line 1562. Shou=
ldn't  it be only at 1562?
>> if (seg1->mr_chunk.rl_mw->r.frmr.state =3D=3D FRMR_IS_VALID) then rp=
crdma_register_frmr_external() posts two Work Requests (LOCAL_INV then =
=46AST_REG_MR) with one ib_post_send(). Thus it is correct to DECR_CQCO=
UNT twice in that case because each WR will trigger a separate completi=
on event.
>>=20
>>=20
>>> -----Original Message-----
>>> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>>> Sent: Thursday, April 10, 2014 1:57 AM
>>> To: Devesh Sharma
>>> Cc: Linux NFS Mailing List; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Trond Mykle=
bust
>>> Subject: Re: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
>>>=20
>>>=20
>>> On Apr 9, 2014, at 4:22 PM, Trond Myklebust <trond.myklebust@primar=
ydata.com> wrote:
>>>=20
>>>> Hi Devesh,
>>>>=20
>>>> This looks a lot better. I still have a couple of small suggestion=
s, though.
>>>>=20
>>>> On Apr 9, 2014, at 14:40, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>>>=20
>>>>> If the rdma_create_qp fails to create qp due to device firmware b=
eing
>>>>> in invalid state xprtrdma still tries to destroy the non-existant=
 qp
>>>>> and ends up in a NULL pointer reference crash.
>>>>> Adding proper checks for vaidating QP pointer avoids this to happ=
en.
>>>>>=20
>>>>> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>>>>> ---
>>>>> net/sunrpc/xprtrdma/verbs.c |   29 +++++++++++++++++++++++++----
>>>>> 1 files changed, 25 insertions(+), 4 deletions(-)
>>>>>=20
>>>>> diff --git a/net/sunrpc/xprtrdma/verbs.c
>>>>> b/net/sunrpc/xprtrdma/verbs.c index 9372656..902ac78 100644
>>>>> --- a/net/sunrpc/xprtrdma/verbs.c
>>>>> +++ b/net/sunrpc/xprtrdma/verbs.c
>>>>> @@ -831,10 +831,12 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, s=
truct rpcrdma_ia *ia)
>>>>> 	if (ep->rep_connected !=3D 0) {
>>>>> 		struct rpcrdma_xprt *xprt;
>>>>> retry:
>>>>> -		rc =3D rpcrdma_ep_disconnect(ep, ia);
>>>>> -		if (rc && rc !=3D -ENOTCONN)
>>>>> -			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>>>>> +		if (ia->ri_id->qp) {
>>>>> +			rc =3D rpcrdma_ep_disconnect(ep, ia);
>>>>> +			if (rc && rc !=3D -ENOTCONN)
>>>>> +				dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>>>>> 				" status %i\n", __func__, rc);
>>>>> +		}
>>>>> 		rpcrdma_clean_cq(ep->rep_cq);
>>>>>=20
>>>>> 		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia); @@ -859,=
7
>>>>> +861,9 @@ retry:
>>>>> 			goto out;
>>>>> 		}
>>>>> 		/* END TEMP */
>>>>> -		rdma_destroy_qp(ia->ri_id);
>>>>> +		if (ia->ri_id->qp) {
>>>>> +			rdma_destroy_qp(ia->ri_id);
>>>>> +		}
>>>> Nit: No need for braces here.
>>>>=20
>>>>> 		rdma_destroy_id(ia->ri_id);
>>>>> 		ia->ri_id =3D id;
>>>>> 	}
>>>>> @@ -1557,6 +1561,13 @@ rpcrdma_register_frmr_external(struct rpcr=
dma_mr_seg *seg,
>>>>> 	frmr_wr.wr.fast_reg.rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr-=
>rkey;
>>>>> 	DECR_CQCOUNT(&r_xprt->rx_ep);
>>> I don't think you can DECR_CQCOUNT, then exit without posting the s=
end. That will screw up the completion counter and result in a transpor=
t hang, won't it?
>>>=20
>>>>> +	if (!ia->ri_is->qp) {
>>>>> +		rc =3D -EINVAL;
>>>>> +		while (i--)
>>>>> +			rpcrdma_unmap_one(ia, --seg);
>>>>> +		goto out;
>>>>> +	}
>>>> Instead of duplicating the rpcrdma_unmap_one() cleanup here, why n=
ot
>>>> just do
>>>>=20
>>>> 	if (ia->ri_is->qp)
>>>> 		rc =3D ib_post_send(...)
>>>> 	else
>>>> 		rc =3D -EINVAL;
>>>>=20
>>>> BTW: can we not simply test for ia->ri_is->qp before we even call =
rpcrdma_map_one() and hence bail out before we have to do any cleanup?
>>>>=20
>>>>> +
>>>>> 	rc =3D ib_post_send(ia->ri_id->qp, post_wr, &bad_wr);
>>>>>=20
>>>>> 	if (rc) {
>>>>> @@ -1571,6 +1582,7 @@ rpcrdma_register_frmr_external(struct rpcrd=
ma_mr_seg *seg,
>>>>> 		seg1->mr_len =3D len;
>>>>> 	}
>>>>> 	*nsegs =3D i;
>>>>> +out:
>>>>> 	return rc;
>>>>> }
>>>>>=20
>>>>> @@ -1592,6 +1604,9 @@ rpcrdma_deregister_frmr_external(struct rpc=
rdma_mr_seg *seg,
>>>>> 	invalidate_wr.ex.invalidate_rkey =3D seg1->mr_chunk.rl_mw->r.frm=
r.fr_mr->rkey;
>>>>> 	DECR_CQCOUNT(&r_xprt->rx_ep);
>>> Ditto.
>>>=20
>>>>> +	if (!ia->ri_id->qp)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> 	rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
>>>>> 	if (rc)
>>>>> 		dprintk("RPC:       %s: failed ib_post_send for invalidate,"
>>>>> @@ -1923,6 +1938,9 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
>>>>> 		send_wr.send_flags =3D IB_SEND_SIGNALED;
>>>>> 	}
>>> Ditto.
>>>=20
>>>>> +	if (!ia->ri_id->qp)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> 	rc =3D ib_post_send(ia->ri_id->qp, &send_wr, &send_wr_fail);
>>>>> 	if (rc)
>>>>> 		dprintk("RPC:       %s: ib_post_send returned %i\n", __func__,
>>>>> @@ -1951,6 +1969,9 @@ rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
>>>>> 		rep->rr_iov.addr, rep->rr_iov.length, DMA_BIDIRECTIONAL);
>>>>>=20
>>>>> 	DECR_CQCOUNT(ep);
>>> And here.
>>>=20
>>>>> +
>>>>> +	if (!ia->ri_id->qp)
>>>>> +		return -EINVAL;
>>>>> 	rc =3D ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
>>>>>=20
>>>>> 	if (rc)
>>>>> --
>>>>> 1.7.1
>>>>>=20
>>>> _________________________________
>>>> Trond Myklebust
>>>> Linux NFS client maintainer, PrimaryData
>>>> trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
>>>>=20
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-nf=
s"
>>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordo=
mo
>>>> info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> Chuck Lever
>>> chuck[dot]lever[at]oracle[dot]com
>>>=20
>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> Chuck Lever
>> chuck[dot]lever[at]oracle[dot]com
>>=20
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
