From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] xprtrdma: mind the device's max fast register page list
 depth
Date: Fri, 11 Apr 2014 14:11:10 -0500
Message-ID: <53483E4E.9070607@opengridcomputing.com>
References: <20140410151325.28724.92004.stgit@build.ogc.int> <577860CA-7ECC-4353-AED9-16C17A2B918D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <577860CA-7ECC-4353-AED9-16C17A2B918D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/11/2014 1:34 PM, Chuck Lever wrote:
> Hi Steve-
>
> I reviewed and successfully tested this patch with mlx4 using FRMR an=
d MTHCAFMR.
> A couple of cosmetic notes are below:
>
>
> On Apr 10, 2014, at 11:13 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org=
> wrote:
>
>> Some rdma devices don't support a fast register page list depth of
>> at least RPCRDMA_MAX_DATA_SEGS.  So xprtrdma needs to chunk its fast
>> register regions according to the minimum of the device max supporte=
d
>> depth or RPCRDMA_MAX_DATA_SEGS.
>>
>> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> ---
>>
>> net/sunrpc/xprtrdma/rpc_rdma.c  |    2 -
>> net/sunrpc/xprtrdma/verbs.c     |   64 ++++++++++++++++++++++++++++-=
----------
>> net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
>> 3 files changed, 47 insertions(+), 20 deletions(-)
>>
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index 96ead52..14d7634 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -249,8 +249,6 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, str=
uct xdr_buf *target,
>> 	req->rl_nchunks =3D nchunks;
>>
>> 	BUG_ON(nchunks =3D=3D 0);
> I don=92t see a path through rpcrdma_create_chunks() where nchunks ca=
n be 0 here. If you
> agree, can you remove the above BUG_ON as well, if you re-submit a ne=
w version of this
> patch?

Sure.

>> -	BUG_ON((r_xprt->rx_ia.ri_memreg_strategy =3D=3D RPCRDMA_FRMR)
>> -	       && (nchunks > 3));
>>
>> 	/*
>> 	 * finish off header. If write, marshal discrim and nchunks.
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 93726560..c08f193 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -539,6 +539,11 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, stru=
ct sockaddr *addr, int memreg)
>> 				__func__);
>> 			memreg =3D RPCRDMA_REGISTER;
>> #endif
>> +		} else {
>> +			/* Mind the ia limit on FRMR page list depth */
>> +			ia->ri_max_frmr_depth =3D min_t(unsigned int,
>> +				RPCRDMA_MAX_DATA_SEGS,
>> +				devattr.max_fast_reg_page_list_len);
>> 		}
>> 		break;
>> 	}
>> @@ -659,24 +664,42 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struc=
t rpcrdma_ia *ia,
>> 	ep->rep_attr.srq =3D NULL;
>> 	ep->rep_attr.cap.max_send_wr =3D cdata->max_requests;
>> 	switch (ia->ri_memreg_strategy) {
>> -	case RPCRDMA_FRMR:
>> +	case RPCRDMA_FRMR: {
>> +		int depth =3D 7;
>> +
>> 		/* Add room for frmr register and invalidate WRs.
>> 		 * 1. FRMR reg WR for head
>> 		 * 2. FRMR invalidate WR for head
>> -		 * 3. FRMR reg WR for pagelist
>> -		 * 4. FRMR invalidate WR for pagelist
>> +		 * 3. N FRMR reg WRs for pagelist
>> +		 * 4. N FRMR invalidate WRs for pagelist
>> 		 * 5. FRMR reg WR for tail
>> 		 * 6. FRMR invalidate WR for tail
>> 		 * 7. The RDMA_SEND WR
>> 		 */
>> -		ep->rep_attr.cap.max_send_wr *=3D 7;
>> +
>> +		/* Calculate N if the device max FRMR depth is smaller than
>> +		 * RPCRDMA_MAX_DATA_SEGS.
>> +		 */
>> +		if (ia->ri_max_frmr_depth < RPCRDMA_MAX_DATA_SEGS) {
>> +			int delta =3D RPCRDMA_MAX_DATA_SEGS -
>> +				    ia->ri_max_frmr_depth;
>> +
>> +			do {
>> +				depth +=3D 2; /* FRMR reg + invalidate */
>> +				delta -=3D ia->ri_max_frmr_depth;
>> +			} while (delta > 0);
>> +
>> +		}
>> +		ep->rep_attr.cap.max_send_wr *=3D depth;
>> 		if (ep->rep_attr.cap.max_send_wr > devattr.max_qp_wr) {
>> -			cdata->max_requests =3D devattr.max_qp_wr / 7;
>> +			cdata->max_requests =3D devattr.max_qp_wr / depth;
>> 			if (!cdata->max_requests)
>> 				return -EINVAL;
>> -			ep->rep_attr.cap.max_send_wr =3D cdata->max_requests * 7;
>> +			ep->rep_attr.cap.max_send_wr =3D cdata->max_requests *
>> +						       depth;
>> 		}
>> 		break;
>> +	}
>> 	case RPCRDMA_MEMWINDOWS_ASYNC:
>> 	case RPCRDMA_MEMWINDOWS:
>> 		/* Add room for mw_binds+unbinds - overkill! */
>> @@ -1043,16 +1066,16 @@ rpcrdma_buffer_create(struct rpcrdma_buffer =
*buf, struct rpcrdma_ep *ep,
>> 	case RPCRDMA_FRMR:
>> 		for (i =3D buf->rb_max_requests * RPCRDMA_MAX_SEGS; i; i--) {
>> 			r->r.frmr.fr_mr =3D ib_alloc_fast_reg_mr(ia->ri_pd,
>> -							 RPCRDMA_MAX_SEGS);
>> +						ia->ri_max_frmr_depth);
>> 			if (IS_ERR(r->r.frmr.fr_mr)) {
>> 				rc =3D PTR_ERR(r->r.frmr.fr_mr);
>> 				dprintk("RPC:       %s: ib_alloc_fast_reg_mr"
>> 					" failed %i\n", __func__, rc);
>> 				goto out;
>> 			}
>> -			r->r.frmr.fr_pgl =3D
>> -				ib_alloc_fast_reg_page_list(ia->ri_id->device,
>> -							    RPCRDMA_MAX_SEGS);
>> +			r->r.frmr.fr_pgl =3D ib_alloc_fast_reg_page_list(
>> +						ia->ri_id->device,
>> +						ia->ri_max_frmr_depth);
>> 			if (IS_ERR(r->r.frmr.fr_pgl)) {
>> 				rc =3D PTR_ERR(r->r.frmr.fr_pgl);
>> 				dprintk("RPC:       %s: "
>> @@ -1498,8 +1521,8 @@ rpcrdma_register_frmr_external(struct rpcrdma_=
mr_seg *seg,
>> 	seg1->mr_offset -=3D pageoff;	/* start of page */
>> 	seg1->mr_len +=3D pageoff;
>> 	len =3D -pageoff;
>> -	if (*nsegs > RPCRDMA_MAX_DATA_SEGS)
>> -		*nsegs =3D RPCRDMA_MAX_DATA_SEGS;
>> +	if (*nsegs > ia->ri_max_frmr_depth)
>> +		*nsegs =3D ia->ri_max_frmr_depth;
>> 	for (page_no =3D i =3D 0; i < *nsegs;) {
>> 		rpcrdma_map_one(ia, seg, writing);
>> 		pa =3D seg->mr_dma;
>> @@ -1796,6 +1819,7 @@ rpcrdma_register_external(struct rpcrdma_mr_se=
g *seg,
>> {
>> 	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> 	int rc =3D 0;
>> +	int tmp_nsegs =3D nsegs;
> I don=92t understand what the changes to rpcrdma_register_external() =
do. As a test, I reverted
> these, and the patch behaves the same. Am I missing something?

I mistakenly thought rpcrdma_register_external() was changing the=20
callers nsegs variable.  But since its passed by value and not=20
reference, that's not possible.  I'll remove this and retest, then send=
=20
out V2 of the patch with the BUG_ON() removed as well.


Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
