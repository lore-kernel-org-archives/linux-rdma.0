From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] xprtrdma: mind the device's max fast register page list depth
Date: Fri, 11 Apr 2014 14:34:44 -0400
Message-ID: <577860CA-7ECC-4353-AED9-16C17A2B918D@oracle.com>
References: <20140410151325.28724.92004.stgit@build.ogc.int>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140410151325.28724.92004.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve-

I reviewed and successfully tested this patch with mlx4 using FRMR and =
MTHCAFMR.
A couple of cosmetic notes are below:


On Apr 10, 2014, at 11:13 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

> Some rdma devices don't support a fast register page list depth of
> at least RPCRDMA_MAX_DATA_SEGS.  So xprtrdma needs to chunk its fast
> register regions according to the minimum of the device max supported
> depth or RPCRDMA_MAX_DATA_SEGS.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>=20
> net/sunrpc/xprtrdma/rpc_rdma.c  |    2 -
> net/sunrpc/xprtrdma/verbs.c     |   64 ++++++++++++++++++++++++++++--=
---------
> net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
> 3 files changed, 47 insertions(+), 20 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc=
_rdma.c
> index 96ead52..14d7634 100644
> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> @@ -249,8 +249,6 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, stru=
ct xdr_buf *target,
> 	req->rl_nchunks =3D nchunks;
>=20
> 	BUG_ON(nchunks =3D=3D 0);

I don=92t see a path through rpcrdma_create_chunks() where nchunks can =
be 0 here. If you
agree, can you remove the above BUG_ON as well, if you re-submit a new =
version of this
patch?

> -	BUG_ON((r_xprt->rx_ia.ri_memreg_strategy =3D=3D RPCRDMA_FRMR)
> -	       && (nchunks > 3));
>=20
> 	/*
> 	 * finish off header. If write, marshal discrim and nchunks.
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c
> index 93726560..c08f193 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -539,6 +539,11 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struc=
t sockaddr *addr, int memreg)
> 				__func__);
> 			memreg =3D RPCRDMA_REGISTER;
> #endif
> +		} else {
> +			/* Mind the ia limit on FRMR page list depth */
> +			ia->ri_max_frmr_depth =3D min_t(unsigned int,
> +				RPCRDMA_MAX_DATA_SEGS,
> +				devattr.max_fast_reg_page_list_len);
> 		}
> 		break;
> 	}
> @@ -659,24 +664,42 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct=
 rpcrdma_ia *ia,
> 	ep->rep_attr.srq =3D NULL;
> 	ep->rep_attr.cap.max_send_wr =3D cdata->max_requests;
> 	switch (ia->ri_memreg_strategy) {
> -	case RPCRDMA_FRMR:
> +	case RPCRDMA_FRMR: {
> +		int depth =3D 7;
> +
> 		/* Add room for frmr register and invalidate WRs.
> 		 * 1. FRMR reg WR for head
> 		 * 2. FRMR invalidate WR for head
> -		 * 3. FRMR reg WR for pagelist
> -		 * 4. FRMR invalidate WR for pagelist
> +		 * 3. N FRMR reg WRs for pagelist
> +		 * 4. N FRMR invalidate WRs for pagelist
> 		 * 5. FRMR reg WR for tail
> 		 * 6. FRMR invalidate WR for tail
> 		 * 7. The RDMA_SEND WR
> 		 */
> -		ep->rep_attr.cap.max_send_wr *=3D 7;
> +
> +		/* Calculate N if the device max FRMR depth is smaller than
> +		 * RPCRDMA_MAX_DATA_SEGS.
> +		 */
> +		if (ia->ri_max_frmr_depth < RPCRDMA_MAX_DATA_SEGS) {
> +			int delta =3D RPCRDMA_MAX_DATA_SEGS -
> +				    ia->ri_max_frmr_depth;
> +
> +			do {
> +				depth +=3D 2; /* FRMR reg + invalidate */
> +				delta -=3D ia->ri_max_frmr_depth;
> +			} while (delta > 0);
> +
> +		}
> +		ep->rep_attr.cap.max_send_wr *=3D depth;
> 		if (ep->rep_attr.cap.max_send_wr > devattr.max_qp_wr) {
> -			cdata->max_requests =3D devattr.max_qp_wr / 7;
> +			cdata->max_requests =3D devattr.max_qp_wr / depth;
> 			if (!cdata->max_requests)
> 				return -EINVAL;
> -			ep->rep_attr.cap.max_send_wr =3D cdata->max_requests * 7;
> +			ep->rep_attr.cap.max_send_wr =3D cdata->max_requests *
> +						       depth;
> 		}
> 		break;
> +	}
> 	case RPCRDMA_MEMWINDOWS_ASYNC:
> 	case RPCRDMA_MEMWINDOWS:
> 		/* Add room for mw_binds+unbinds - overkill! */
> @@ -1043,16 +1066,16 @@ rpcrdma_buffer_create(struct rpcrdma_buffer *=
buf, struct rpcrdma_ep *ep,
> 	case RPCRDMA_FRMR:
> 		for (i =3D buf->rb_max_requests * RPCRDMA_MAX_SEGS; i; i--) {
> 			r->r.frmr.fr_mr =3D ib_alloc_fast_reg_mr(ia->ri_pd,
> -							 RPCRDMA_MAX_SEGS);
> +						ia->ri_max_frmr_depth);
> 			if (IS_ERR(r->r.frmr.fr_mr)) {
> 				rc =3D PTR_ERR(r->r.frmr.fr_mr);
> 				dprintk("RPC:       %s: ib_alloc_fast_reg_mr"
> 					" failed %i\n", __func__, rc);
> 				goto out;
> 			}
> -			r->r.frmr.fr_pgl =3D
> -				ib_alloc_fast_reg_page_list(ia->ri_id->device,
> -							    RPCRDMA_MAX_SEGS);
> +			r->r.frmr.fr_pgl =3D ib_alloc_fast_reg_page_list(
> +						ia->ri_id->device,
> +						ia->ri_max_frmr_depth);
> 			if (IS_ERR(r->r.frmr.fr_pgl)) {
> 				rc =3D PTR_ERR(r->r.frmr.fr_pgl);
> 				dprintk("RPC:       %s: "
> @@ -1498,8 +1521,8 @@ rpcrdma_register_frmr_external(struct rpcrdma_m=
r_seg *seg,
> 	seg1->mr_offset -=3D pageoff;	/* start of page */
> 	seg1->mr_len +=3D pageoff;
> 	len =3D -pageoff;
> -	if (*nsegs > RPCRDMA_MAX_DATA_SEGS)
> -		*nsegs =3D RPCRDMA_MAX_DATA_SEGS;
> +	if (*nsegs > ia->ri_max_frmr_depth)
> +		*nsegs =3D ia->ri_max_frmr_depth;
> 	for (page_no =3D i =3D 0; i < *nsegs;) {
> 		rpcrdma_map_one(ia, seg, writing);
> 		pa =3D seg->mr_dma;
> @@ -1796,6 +1819,7 @@ rpcrdma_register_external(struct rpcrdma_mr_seg=
 *seg,
> {
> 	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
> 	int rc =3D 0;
> +	int tmp_nsegs =3D nsegs;

I don=92t understand what the changes to rpcrdma_register_external() do=
=2E As a test, I reverted
these, and the patch behaves the same. Am I missing something?

>=20
> 	switch (ia->ri_memreg_strategy) {
>=20
> @@ -1805,35 +1829,39 @@ rpcrdma_register_external(struct rpcrdma_mr_s=
eg *seg,
> 		seg->mr_rkey =3D ia->ri_bind_mem->rkey;
> 		seg->mr_base =3D seg->mr_dma;
> 		seg->mr_nsegs =3D 1;
> -		nsegs =3D 1;
> +		tmp_nsegs =3D 1;
> 		break;
> #endif
>=20
> 	/* Registration using frmr registration */
> 	case RPCRDMA_FRMR:
> -		rc =3D rpcrdma_register_frmr_external(seg, &nsegs, writing, ia, r_=
xprt);
> +		rc =3D rpcrdma_register_frmr_external(seg, &tmp_nsegs, writing,
> +						    ia, r_xprt);
> 		break;
>=20
> 	/* Registration using fmr memory registration */
> 	case RPCRDMA_MTHCAFMR:
> -		rc =3D rpcrdma_register_fmr_external(seg, &nsegs, writing, ia);
> +		rc =3D rpcrdma_register_fmr_external(seg, &tmp_nsegs, writing,
> +						   ia);
> 		break;
>=20
> 	/* Registration using memory windows */
> 	case RPCRDMA_MEMWINDOWS_ASYNC:
> 	case RPCRDMA_MEMWINDOWS:
> -		rc =3D rpcrdma_register_memwin_external(seg, &nsegs, writing, ia, =
r_xprt);
> +		rc =3D rpcrdma_register_memwin_external(seg, &tmp_nsegs, writing,
> +						      ia, r_xprt);
> 		break;
>=20
> 	/* Default registration each time */
> 	default:
> -		rc =3D rpcrdma_register_default_external(seg, &nsegs, writing, ia)=
;
> +		rc =3D rpcrdma_register_default_external(seg, &tmp_nsegs, writing,
> +						       ia);
> 		break;
> 	}
> 	if (rc)
> 		return -1;
>=20
> -	return nsegs;
> +	return tmp_nsegs;
> }
>=20
> int
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xp=
rt_rdma.h
> index cc1445d..98340a3 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -66,6 +66,7 @@ struct rpcrdma_ia {
> 	struct completion	ri_done;
> 	int			ri_async_rc;
> 	enum rpcrdma_memreg	ri_memreg_strategy;
> +	unsigned int		ri_max_frmr_depth;
> };
>=20
> /*
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
