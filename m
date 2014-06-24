From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 08/13] xprtrdma: Back off rkey when FAST_REG_MR fails
Date: Tue, 24 Jun 2014 12:26:32 -0400
Message-ID: <51111098-A9FF-4F43-8D1A-0B57BD1B952C@oracle.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623224007.1634.55636.stgit@manet.1015granger.net> <53A99DA6.90808@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A99DA6.90808-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jun 24, 2014, at 11:47 AM, Anna Schumaker <schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:

> On 06/23/2014 06:40 PM, Chuck Lever wrote:
>> If posting a FAST_REG_MR Work Reqeust fails, or the FAST_REG WR
>> flushes, revert the rkey update to avoid subsequent
>> IB_WC_MW_BIND_ERR completions.
>>=20
>> Suggested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/verbs.c |   39 +++++++++++++++++++++++++++++----=
------
>> 1 file changed, 29 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index cef67fd..3efc007 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -61,6 +61,8 @@
>> # define RPCDBG_FACILITY	RPCDBG_TRANS
>> #endif
>>=20
>> +static void rpcrdma_decrement_frmr_rkey(struct rpcrdma_mw *);
>> +
>> /*
>>  * internal functions
>>  */
>> @@ -154,13 +156,17 @@ rpcrdma_sendcq_process_wc(struct ib_wc *wc)
>>=20
>> 	if (wrid =3D=3D 0)
>> 		return;
>> -	if (wc->status !=3D IB_WC_SUCCESS)
>> -		return;
>>=20
>> 	fastreg =3D test_and_clear_bit(RPCRDMA_BIT_FASTREG, &wrid);
>> 	mw =3D (struct rpcrdma_mw *)wrid;
>>=20
>> -	mw->r.frmr.fr_state =3D fastreg ? FRMR_IS_VALID : FRMR_IS_INVALID;
>> +	if (wc->status =3D=3D IB_WC_SUCCESS) {
>> +		mw->r.frmr.fr_state =3D fastreg ?
>> +				FRMR_IS_VALID : FRMR_IS_INVALID;
>> +	} else {
>> +		if (fastreg)
>> +			rpcrdma_decrement_frmr_rkey(mw);
>=20
> Isn't this the same as "else if (fastreg)=94?

Yep, those are logically equivalent. I left them separate, and
left the extra braces, so it would be cleaner to add more logic in
both arms of =93if (wc->status =3D=3D IB_WC_SUCCESS)=94 in subsequent
patches.

Using =93switch (wc->status)=94 might be more future-proof.


> Anna
>=20
>> +	}
>> }
>>=20
>> static int
>> @@ -1480,6 +1486,24 @@ rpcrdma_unmap_one(struct rpcrdma_ia *ia, stru=
ct rpcrdma_mr_seg *seg)
>> 				seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
>> }
>>=20
>> +static void
>> +rpcrdma_increment_frmr_rkey(struct rpcrdma_mw *mw)
>> +{
>> +	struct ib_mr *frmr =3D mw->r.frmr.fr_mr;
>> +	u8 key =3D frmr->rkey & 0x000000FF;
>> +
>> +	ib_update_fast_reg_key(frmr, ++key);
>> +}
>> +
>> +static void
>> +rpcrdma_decrement_frmr_rkey(struct rpcrdma_mw *mw)
>> +{
>> +	struct ib_mr *frmr =3D mw->r.frmr.fr_mr;
>> +	u8 key =3D frmr->rkey & 0x000000FF;
>> +
>> +	ib_update_fast_reg_key(frmr, --key);
>> +}
>> +
>> static int
>> rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>> 			int *nsegs, int writing, struct rpcrdma_ia *ia,
>> @@ -1487,8 +1511,6 @@ rpcrdma_register_frmr_external(struct rpcrdma_=
mr_seg *seg,
>> {
>> 	struct rpcrdma_mr_seg *seg1 =3D seg;
>> 	struct ib_send_wr invalidate_wr, frmr_wr, *bad_wr, *post_wr;
>> -
>> -	u8 key;
>> 	int len, pageoff;
>> 	int i, rc;
>> 	int seg_len;
>> @@ -1552,14 +1574,10 @@ rpcrdma_register_frmr_external(struct rpcrdm=
a_mr_seg *seg,
>> 		rc =3D -EIO;
>> 		goto out_err;
>> 	}
>> -
>> -	/* Bump the key */
>> -	key =3D (u8)(seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey & 0x000000FF=
);
>> -	ib_update_fast_reg_key(seg1->mr_chunk.rl_mw->r.frmr.fr_mr, ++key);
>> -
>> 	frmr_wr.wr.fast_reg.access_flags =3D (writing ?
>> 				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
>> 				IB_ACCESS_REMOTE_READ);
>> +	rpcrdma_increment_frmr_rkey(seg1->mr_chunk.rl_mw);
>> 	frmr_wr.wr.fast_reg.rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rk=
ey;
>> 	DECR_CQCOUNT(&r_xprt->rx_ep);
>>=20
>> @@ -1568,6 +1586,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_=
mr_seg *seg,
>> 	if (rc) {
>> 		dprintk("RPC:       %s: failed ib_post_send for register,"
>> 			" status %i\n", __func__, rc);
>> +		rpcrdma_decrement_frmr_rkey(seg1->mr_chunk.rl_mw);
>> 		goto out_err;
>> 	} else {
>> 		seg1->mr_rkey =3D seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
