From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
Date: Wed, 9 Apr 2014 16:26:34 -0400
Message-ID: <F1C70AD6-BDD4-4534-8DC4-61D2767581D9@oracle.com>
References: <014738b6-698e-4ea1-82f9-287378bfec19@CMEXHTCAS2.ad.emulex.com> <D7AB2150-5F25-4BA2-80D9-94890AD11F8F@primarydata.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D7AB2150-5F25-4BA2-80D9-94890AD11F8F-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Apr 9, 2014, at 4:22 PM, Trond Myklebust <trond.myklebust@primarydat=
a.com> wrote:

> Hi Devesh,
>=20
> This looks a lot better. I still have a couple of small suggestions, =
though.
>=20
> On Apr 9, 2014, at 14:40, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wr=
ote:
>=20
>> If the rdma_create_qp fails to create qp due to device firmware bein=
g in invalid state
>> xprtrdma still tries to destroy the non-existant qp and ends up in a=
 NULL pointer reference
>> crash.
>> Adding proper checks for vaidating QP pointer avoids this to happen.
>>=20
>> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/verbs.c |   29 +++++++++++++++++++++++++----
>> 1 files changed, 25 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 9372656..902ac78 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -831,10 +831,12 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, stru=
ct rpcrdma_ia *ia)
>> 	if (ep->rep_connected !=3D 0) {
>> 		struct rpcrdma_xprt *xprt;
>> retry:
>> -		rc =3D rpcrdma_ep_disconnect(ep, ia);
>> -		if (rc && rc !=3D -ENOTCONN)
>> -			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>> +		if (ia->ri_id->qp) {
>> +			rc =3D rpcrdma_ep_disconnect(ep, ia);
>> +			if (rc && rc !=3D -ENOTCONN)
>> +				dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>> 				" status %i\n", __func__, rc);
>> +		}
>> 		rpcrdma_clean_cq(ep->rep_cq);
>>=20
>> 		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
>> @@ -859,7 +861,9 @@ retry:
>> 			goto out;
>> 		}
>> 		/* END TEMP */
>> -		rdma_destroy_qp(ia->ri_id);
>> +		if (ia->ri_id->qp) {
>> +			rdma_destroy_qp(ia->ri_id);
>> +		}
>=20
> Nit: No need for braces here.
>=20
>> 		rdma_destroy_id(ia->ri_id);
>> 		ia->ri_id =3D id;
>> 	}
>> @@ -1557,6 +1561,13 @@ rpcrdma_register_frmr_external(struct rpcrdma=
_mr_seg *seg,
>> 	frmr_wr.wr.fast_reg.rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rk=
ey;
>> 	DECR_CQCOUNT(&r_xprt->rx_ep);

I don=92t think you can DECR_CQCOUNT, then exit without posting the sen=
d. That will screw up the completion counter and result in a transport =
hang, won=92t it?

>>=20
>> +	if (!ia->ri_is->qp) {
>> +		rc =3D -EINVAL;
>> +		while (i--)
>> +			rpcrdma_unmap_one(ia, --seg);
>> +		goto out;
>> +	}
>=20
> Instead of duplicating the rpcrdma_unmap_one() cleanup here, why not =
just do
>=20
> 	if (ia->ri_is->qp)
> 		rc =3D ib_post_send(=85)
> 	else
> 		rc =3D -EINVAL;
>=20
> BTW: can we not simply test for ia->ri_is->qp before we even call rpc=
rdma_map_one() and hence bail out before we have to do any cleanup?
>=20
>> +
>> 	rc =3D ib_post_send(ia->ri_id->qp, post_wr, &bad_wr);
>>=20
>> 	if (rc) {
>> @@ -1571,6 +1582,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_=
mr_seg *seg,
>> 		seg1->mr_len =3D len;
>> 	}
>> 	*nsegs =3D i;
>> +out:
>> 	return rc;
>> }
>>=20
>> @@ -1592,6 +1604,9 @@ rpcrdma_deregister_frmr_external(struct rpcrdm=
a_mr_seg *seg,
>> 	invalidate_wr.ex.invalidate_rkey =3D seg1->mr_chunk.rl_mw->r.frmr.f=
r_mr->rkey;
>> 	DECR_CQCOUNT(&r_xprt->rx_ep);

Ditto.

>>=20
>> +	if (!ia->ri_id->qp)
>> +		return -EINVAL;
>> +
>> 	rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
>> 	if (rc)
>> 		dprintk("RPC:       %s: failed ib_post_send for invalidate,"
>> @@ -1923,6 +1938,9 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
>> 		send_wr.send_flags =3D IB_SEND_SIGNALED;
>> 	}

Ditto.

>>=20
>> +	if (!ia->ri_id->qp)
>> +		return -EINVAL;
>> +
>> 	rc =3D ib_post_send(ia->ri_id->qp, &send_wr, &send_wr_fail);
>> 	if (rc)
>> 		dprintk("RPC:       %s: ib_post_send returned %i\n", __func__,
>> @@ -1951,6 +1969,9 @@ rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
>> 		rep->rr_iov.addr, rep->rr_iov.length, DMA_BIDIRECTIONAL);
>>=20
>> 	DECR_CQCOUNT(ep);

And here.

>> +
>> +	if (!ia->ri_id->qp)
>> +		return -EINVAL;
>> 	rc =3D ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
>>=20
>> 	if (rc)
>> --=20
>> 1.7.1
>>=20
>=20
> _________________________________
> Trond Myklebust
> Linux NFS client maintainer, PrimaryData
> trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
