From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] NFS-RDMA: fix qp pointer validation checks
Date: Wed, 9 Apr 2014 20:35:16 -0400
Message-ID: <22067556-CC9F-45B3-8597-C801231FC04F@oracle.com>
References: <f02a9959-4530-474f-8076-1139362aaea6@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f02a9959-4530-474f-8076-1139362aaea6-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Devesh-


On Apr 9, 2014, at 7:54 PM, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wr=
ote:

> If the rdma_create_qp fails to create qp due to device firmware being=
 in invalid state
> xprtrdma still tries to destroy the non-existant qp and ends up in a =
NULL pointer reference
> crash.
> Adding proper checks for vaidating QP pointer avoids this to happen.
>=20
> V0: Using IS_ERR() to check validity of qp pointer.
> V1: Use of IS_ERR() will not be able to catch NULL QP pointers as rdm=
a_create_qp() returnes NULL in case
>    ib_create_qp verb is failed. Therefore, changed from usage of IS_E=
RR to null pointer check.
> V2: ib_post_send() should not abort after DECR_CQCOUNT() checking for=
 NULL pointer was causing exit from functions
>    after decrementing CQCOUNT(). Fixed this in V2.
>=20
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
> net/sunrpc/xprtrdma/verbs.c |   92 ++++++++++++++++++++++++++--------=
---------
> 1 files changed, 56 insertions(+), 36 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c
> index 9372656..9e56baf 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -831,10 +831,12 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, struc=
t rpcrdma_ia *ia)
> 	if (ep->rep_connected !=3D 0) {
> 		struct rpcrdma_xprt *xprt;
> retry:
> -		rc =3D rpcrdma_ep_disconnect(ep, ia);
> -		if (rc && rc !=3D -ENOTCONN)
> -			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
> +		if (ia->ri_id->qp) {
> +			rc =3D rpcrdma_ep_disconnect(ep, ia);
> +			if (rc && rc !=3D -ENOTCONN)
> +				dprintk("RPC:       %s: rpcrdma_ep_disconnect"
> 				" status %i\n", __func__, rc);
> +		}
> 		rpcrdma_clean_cq(ep->rep_cq);
>=20
> 		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
> @@ -859,7 +861,8 @@ retry:
> 			goto out;
> 		}
> 		/* END TEMP */
> -		rdma_destroy_qp(ia->ri_id);
> +		if (ia->ri_id->qp)
> +			rdma_destroy_qp(ia->ri_id);
> 		rdma_destroy_id(ia->ri_id);
> 		ia->ri_id =3D id;
> 	}

Does your set up still panic if rpcrdma_ep_connect() is fixed as above,=
 but the rest of these hunks are left unapplied?


> @@ -1555,22 +1558,30 @@ rpcrdma_register_frmr_external(struct rpcrdma=
_mr_seg *seg,
> 				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
> 				IB_ACCESS_REMOTE_READ);
> 	frmr_wr.wr.fast_reg.rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rke=
y;
> -	DECR_CQCOUNT(&r_xprt->rx_ep);
>=20
> -	rc =3D ib_post_send(ia->ri_id->qp, post_wr, &bad_wr);
> +	if (!ia->ri_is->qp) {

You mean =93if (ia->ri_id->qp) {=94

> +		DECR_CQCOUNT(&r_xprt->rx_ep);
> +		rc =3D ib_post_send(ia->ri_id->qp, post_wr, &bad_wr);
>=20
> -	if (rc) {
> -		dprintk("RPC:       %s: failed ib_post_send for register,"
> -			" status %i\n", __func__, rc);
> -		while (i--)
> -			rpcrdma_unmap_one(ia, --seg);
> +		if (rc) {
> +			dprintk("RPC:       %s: failed ib_post_send for register,"
> +				" status %i\n", __func__, rc);
> +			goto out;
> +		} else {
> +			seg1->mr_rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
> +			seg1->mr_base =3D seg1->mr_dma + pageoff;
> +			seg1->mr_nsegs =3D i;
> +			seg1->mr_len =3D len;
> +		}
> 	} else {
> -		seg1->mr_rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
> -		seg1->mr_base =3D seg1->mr_dma + pageoff;
> -		seg1->mr_nsegs =3D i;
> -		seg1->mr_len =3D len;
> +		rc =3D -EINVAL;
> +		goto out;
> 	}
> +
> 	*nsegs =3D i;
> +out:
> +	while (i--)
> +		rpcrdma_unmap_one(ia, --seg);
> 	return rc;
> }
>=20
> @@ -1590,12 +1601,16 @@ rpcrdma_deregister_frmr_external(struct rpcrd=
ma_mr_seg *seg,
> 	invalidate_wr.opcode =3D IB_WR_LOCAL_INV;
> 	invalidate_wr.send_flags =3D IB_SEND_SIGNALED;
> 	invalidate_wr.ex.invalidate_rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr=
_mr->rkey;
> -	DECR_CQCOUNT(&r_xprt->rx_ep);
>=20
> -	rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
> -	if (rc)
> -		dprintk("RPC:       %s: failed ib_post_send for invalidate,"
> -			" status %i\n", __func__, rc);
> +	if (ia->ri_id->qp) {
> +		DECR_CQCOUNT(&r_xprt->rx_ep);
> +		rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
> +		if (rc)
> +			dprintk("RPC:       %s: failed ib_post_send for invalidate,"
> +				" status %i\n", __func__, rc);
> +	} else
> +		rc =3D -EINVAL;
> +
> 	return rc;
> }
>=20
> @@ -1916,17 +1931,19 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
> 		req->rl_send_iov[0].addr, req->rl_send_iov[0].length,
> 		DMA_TO_DEVICE);
>=20
> -	if (DECR_CQCOUNT(ep) > 0)
> -		send_wr.send_flags =3D 0;
> -	else { /* Provider must take a send completion every now and then *=
/
> -		INIT_CQCOUNT(ep);
> -		send_wr.send_flags =3D IB_SEND_SIGNALED;
> -	}
> -
> -	rc =3D ib_post_send(ia->ri_id->qp, &send_wr, &send_wr_fail);
> -	if (rc)
> -		dprintk("RPC:       %s: ib_post_send returned %i\n", __func__,
> -			rc);
> +	if (ia->ri_id->qp) {
> +		if (DECR_CQCOUNT(ep) > 0)
> +			send_wr.send_flags =3D 0;
> +		else { /* Provider must take a send completion every now and then =
*/
> +			INIT_CQCOUNT(ep);
> +			send_wr.send_flags =3D IB_SEND_SIGNALED
> +		}
> +		rc =3D ib_post_send(ia->ri_id->qp, &send_wr, &send_wr_fail);
> +		if (rc)
> +			dprintk("RPC:       %s: ib_post_send returned %i\n", __func__,
> +				rc);
> +	} else
> +		rc =3D -EINVAL;
> out:
> 	return rc;
> }
> @@ -1950,11 +1967,14 @@ rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
> 	ib_dma_sync_single_for_cpu(ia->ri_id->device,
> 		rep->rr_iov.addr, rep->rr_iov.length, DMA_BIDIRECTIONAL);
>=20
> -	DECR_CQCOUNT(ep);
> -	rc =3D ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
> +	if (ia->ri_id->qp) {
> +		DECR_CQCOUNT(ep);
> +		rc =3D ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
> +		if (rc)
> +			dprintk("RPC:       %s: ib_post_recv returned %i\n", __func__,
> +				rc);
> +	} else
> +		rc =3D -EINVAL;
>=20
> -	if (rc)
> -		dprintk("RPC:       %s: ib_post_recv returned %i\n", __func__,
> -			rc);
> 	return rc;
> }
> --=20
> 1.7.1
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
