From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 08/21] xprtrdma: Back off rkey when FAST_REG_MR fails
Date: Wed, 9 Jul 2014 16:27:20 -0400
Message-ID: <C0DDE6BD-C50A-4B8B-BCEA-653036B63E23@oracle.com>
References: <20140709163326.3496.37893.stgit@manet.1015granger.net> <20140709165739.3496.39485.stgit@manet.1015granger.net> <53BDA10B.6030506@netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BDA10B.6030506-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 9, 2014, at 4:07 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> =
wrote:

> On 07/09/2014 12:57 PM, Chuck Lever wrote:
>> If posting a FAST_REG_MR Work Reqeust fails, revert the rkey update
>> to avoid subsequent IB_WC_MW_BIND_ERR completions.
>>=20
>> Suggested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/verbs.c |   27 ++++++++++++++++++++-------
>> 1 file changed, 20 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index ce847d2..14d24ec 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -1487,6 +1487,24 @@ rpcrdma_unmap_one(struct rpcrdma_ia *ia, stru=
ct rpcrdma_mr_seg *seg)
>> 				seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
>> }
>>=20
>> +static void
>> +rpcrdma_increment_frmr_rkey(struct rpcrdma_mw *mw)
>> +{
>> +	struct ib_mr *mr =3D mw->r.frmr.fr_mr;
>> +	u8 key =3D mr->rkey & 0x000000FF;
>=20
> It's not super obvious to be how this key is being calculated.  Can y=
ou change 0x000000FF into a named constant to help?

Bumping the rkey is the same for any RDMA consumer, so it would be
even better to use a common helper.

include/rdma/ib_verbs.h has ib_inc_rkey() . . .

> It might also be useful to have an frmr_get_rkey() function rather th=
an doing this calculation in two different places.

=2E . . but there isn=92t an ib_dec_rkey(). I could add one.

> Anna
>=20
>> +
>> +	ib_update_fast_reg_key(mr, ++key);
>> +}
>> +
>> +static void
>> +rpcrdma_decrement_frmr_rkey(struct rpcrdma_mw *mw)
>> +{
>> +	struct ib_mr *mr =3D mw->r.frmr.fr_mr;
>> +	u8 key =3D mr->rkey & 0x000000FF;
>> +
>> +	ib_update_fast_reg_key(mr, --key);
>> +}
>> +
>> static int
>> rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>> 			int *nsegs, int writing, struct rpcrdma_ia *ia,
>> @@ -1496,8 +1514,6 @@ rpcrdma_register_frmr_external(struct rpcrdma_=
mr_seg *seg,
>> 	struct rpcrdma_mw *mw =3D seg1->mr_chunk.rl_mw;
>> 	struct rpcrdma_frmr *frmr =3D &mw->r.frmr;
>> 	struct ib_send_wr invalidate_wr, frmr_wr, *bad_wr, *post_wr;
>> -
>> -	u8 key;
>> 	int len, pageoff;
>> 	int i, rc;
>> 	int seg_len;
>> @@ -1557,14 +1573,10 @@ rpcrdma_register_frmr_external(struct rpcrdm=
a_mr_seg *seg,
>> 		rc =3D -EIO;
>> 		goto out_err;
>> 	}
>> -
>> -	/* Bump the key */
>> -	key =3D (u8)(frmr->fr_mr->rkey & 0x000000FF);
>> -	ib_update_fast_reg_key(frmr->fr_mr, ++key);
>> -
>> 	frmr_wr.wr.fast_reg.access_flags =3D (writing ?
>> 				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
>> 				IB_ACCESS_REMOTE_READ);
>> +	rpcrdma_increment_frmr_rkey(mw);
>> 	frmr_wr.wr.fast_reg.rkey =3D frmr->fr_mr->rkey;
>> 	DECR_CQCOUNT(&r_xprt->rx_ep);
>>=20
>> @@ -1573,6 +1585,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_=
mr_seg *seg,
>> 	if (rc) {
>> 		dprintk("RPC:       %s: failed ib_post_send for register,"
>> 			" status %i\n", __func__, rc);
>> +		rpcrdma_decrement_frmr_rkey(seg1->mr_chunk.rl_mw);
>> 		goto out_err;
>> 	} else {
>> 		seg1->mr_rkey =3D frmr->fr_mr->rkey;
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
