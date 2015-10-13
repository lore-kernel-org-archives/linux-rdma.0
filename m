From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 12/26] xprtrdma: Port to new memory registration API
Date: Tue, 13 Oct 2015 12:17:36 -0400
Message-ID: <07691C8B-0D73-43E2-BC5C-C25A0D78415E@oracle.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com> <1444752709-15429-13-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444752709-15429-13-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Oct 13, 2015, at 12:11 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
>=20
> Instead of maintaining a fastreg page list, keep an sg table
> and convert an array of pages to a sg list. Then call ib_map_mr_sg
> and construct ib_reg_wr.
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Tested-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


> ---
> net/sunrpc/xprtrdma/frwr_ops.c  | 118 +++++++++++++++++++++++--------=
---------
> net/sunrpc/xprtrdma/xprt_rdma.h |   3 +-
> 2 files changed, 69 insertions(+), 52 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frw=
r_ops.c
> index 0d2f46f600b6..a1434447b0d6 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -151,9 +151,13 @@ __frwr_init(struct rpcrdma_mw *r, struct ib_pd *=
pd, struct ib_device *device,
> 	f->fr_mr =3D ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, depth);
> 	if (IS_ERR(f->fr_mr))
> 		goto out_mr_err;
> -	f->fr_pgl =3D ib_alloc_fast_reg_page_list(device, depth);
> -	if (IS_ERR(f->fr_pgl))
> +
> +	f->sg =3D kcalloc(depth, sizeof(*f->sg), GFP_KERNEL);
> +	if (!f->sg)
> 		goto out_list_err;
> +
> +	sg_init_table(f->sg, depth);
> +
> 	return 0;
>=20
> out_mr_err:
> @@ -163,9 +167,9 @@ out_mr_err:
> 	return rc;
>=20
> out_list_err:
> -	rc =3D PTR_ERR(f->fr_pgl);
> -	dprintk("RPC:       %s: ib_alloc_fast_reg_page_list status %i\n",
> -		__func__, rc);
> +	rc =3D -ENOMEM;
> +	dprintk("RPC:       %s: sg allocation failure\n",
> +		__func__);
> 	ib_dereg_mr(f->fr_mr);
> 	return rc;
> }
> @@ -179,7 +183,7 @@ __frwr_release(struct rpcrdma_mw *r)
> 	if (rc)
> 		dprintk("RPC:       %s: ib_dereg_mr status %i\n",
> 			__func__, rc);
> -	ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
> +	kfree(r->r.frmr.sg);
> }
>=20
> static int
> @@ -312,14 +316,10 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct=
 rpcrdma_mr_seg *seg,
> 	struct rpcrdma_mw *mw;
> 	struct rpcrdma_frmr *frmr;
> 	struct ib_mr *mr;
> -	struct ib_fast_reg_wr fastreg_wr;
> +	struct ib_reg_wr reg_wr;
> 	struct ib_send_wr *bad_wr;
> +	int rc, i, n, dma_nents;
> 	u8 key;
> -	int len, pageoff;
> -	int i, rc;
> -	int seg_len;
> -	u64 pa;
> -	int page_no;
>=20
> 	mw =3D seg1->rl_mw;
> 	seg1->rl_mw =3D NULL;
> @@ -332,64 +332,80 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct=
 rpcrdma_mr_seg *seg,
> 	} while (mw->r.frmr.fr_state !=3D FRMR_IS_INVALID);
> 	frmr =3D &mw->r.frmr;
> 	frmr->fr_state =3D FRMR_IS_VALID;
> +	mr =3D frmr->fr_mr;
>=20
> -	pageoff =3D offset_in_page(seg1->mr_offset);
> -	seg1->mr_offset -=3D pageoff;	/* start of page */
> -	seg1->mr_len +=3D pageoff;
> -	len =3D -pageoff;
> 	if (nsegs > ia->ri_max_frmr_depth)
> 		nsegs =3D ia->ri_max_frmr_depth;
>=20
> -	for (page_no =3D i =3D 0; i < nsegs;) {
> -		rpcrdma_map_one(device, seg, direction);
> -		pa =3D seg->mr_dma;
> -		for (seg_len =3D seg->mr_len; seg_len > 0; seg_len -=3D PAGE_SIZE)=
 {
> -			frmr->fr_pgl->page_list[page_no++] =3D pa;
> -			pa +=3D PAGE_SIZE;
> -		}
> -		len +=3D seg->mr_len;
> +	for (i =3D 0; i < nsegs;) {
> +		if (seg->mr_page)
> +			sg_set_page(&frmr->sg[i],
> +				    seg->mr_page,
> +				    seg->mr_len,
> +				    offset_in_page(seg->mr_offset));
> +		else
> +			sg_set_buf(&frmr->sg[i], seg->mr_offset,
> +				   seg->mr_len);
> +
> 		++seg;
> 		++i;
> +
> 		/* Check for holes */
> 		if ((i < nsegs && offset_in_page(seg->mr_offset)) ||
> 		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
> 			break;
> 	}
> -	dprintk("RPC:       %s: Using frmr %p to map %d segments (%d bytes)=
\n",
> -		__func__, mw, i, len);
> -
> -	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
> -	fastreg_wr.wr.wr_id =3D (unsigned long)(void *)mw;
> -	fastreg_wr.wr.opcode =3D IB_WR_FAST_REG_MR;
> -	fastreg_wr.iova_start =3D seg1->mr_dma + pageoff;
> -	fastreg_wr.page_list =3D frmr->fr_pgl;
> -	fastreg_wr.page_shift =3D PAGE_SHIFT;
> -	fastreg_wr.page_list_len =3D page_no;
> -	fastreg_wr.length =3D len;
> -	fastreg_wr.access_flags =3D writing ?
> -				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
> -				IB_ACCESS_REMOTE_READ;
> -	mr =3D frmr->fr_mr;
> +	frmr->sg_nents =3D i;
> +
> +	dma_nents =3D ib_dma_map_sg(device, frmr->sg, frmr->sg_nents, direc=
tion);
> +	if (!dma_nents) {
> +		pr_err("RPC:       %s: failed to dma map sg %p sg_nents %u\n",
> +		       __func__, frmr->sg, frmr->sg_nents);
> +		return -ENOMEM;
> +	}
> +
> +	n =3D ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, PAGE_SIZE);
> +	if (unlikely(n !=3D frmr->sg_nents)) {
> +		pr_err("RPC:       %s: failed to map mr %p (%u/%u)\n",
> +		       __func__, frmr->fr_mr, n, frmr->sg_nents);
> +		rc =3D n < 0 ? n : -EINVAL;
> +		goto out_senderr;
> +	}
> +
> +	dprintk("RPC:       %s: Using frmr %p to map %u segments (%u bytes)=
\n",
> +		__func__, mw, frmr->sg_nents, mr->length);
> +
> 	key =3D (u8)(mr->rkey & 0x000000FF);
> 	ib_update_fast_reg_key(mr, ++key);
> -	fastreg_wr.rkey =3D mr->rkey;
> +
> +	reg_wr.wr.next =3D NULL;
> +	reg_wr.wr.opcode =3D IB_WR_REG_MR;
> +	reg_wr.wr.wr_id =3D (uintptr_t)mw;
> +	reg_wr.wr.num_sge =3D 0;
> +	reg_wr.wr.send_flags =3D 0;
> +	reg_wr.mr =3D mr;
> +	reg_wr.key =3D mr->rkey;
> +	reg_wr.access =3D writing ?
> +			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
> +			IB_ACCESS_REMOTE_READ;
>=20
> 	DECR_CQCOUNT(&r_xprt->rx_ep);
> -	rc =3D ib_post_send(ia->ri_id->qp, &fastreg_wr.wr, &bad_wr);
> +	rc =3D ib_post_send(ia->ri_id->qp, &reg_wr.wr, &bad_wr);
> 	if (rc)
> 		goto out_senderr;
>=20
> +	seg1->mr_dir =3D direction;
> 	seg1->rl_mw =3D mw;
> 	seg1->mr_rkey =3D mr->rkey;
> -	seg1->mr_base =3D seg1->mr_dma + pageoff;
> -	seg1->mr_nsegs =3D i;
> -	seg1->mr_len =3D len;
> -	return i;
> +	seg1->mr_base =3D mr->iova;
> +	seg1->mr_nsegs =3D frmr->sg_nents;
> +	seg1->mr_len =3D mr->length;
> +
> +	return frmr->sg_nents;
>=20
> out_senderr:
> 	dprintk("RPC:       %s: ib_post_send status %i\n", __func__, rc);
> -	while (i--)
> -		rpcrdma_unmap_one(device, --seg);
> +	ib_dma_unmap_sg(device, frmr->sg, dma_nents, direction);
> 	__frwr_queue_recovery(mw);
> 	return rc;
> }
> @@ -403,22 +419,22 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, stru=
ct rpcrdma_mr_seg *seg)
> 	struct rpcrdma_mr_seg *seg1 =3D seg;
> 	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
> 	struct rpcrdma_mw *mw =3D seg1->rl_mw;
> +	struct rpcrdma_frmr *frmr =3D &mw->r.frmr;
> 	struct ib_send_wr invalidate_wr, *bad_wr;
> 	int rc, nsegs =3D seg->mr_nsegs;
>=20
> 	dprintk("RPC:       %s: FRMR %p\n", __func__, mw);
>=20
> 	seg1->rl_mw =3D NULL;
> -	mw->r.frmr.fr_state =3D FRMR_IS_INVALID;
> +	frmr->fr_state =3D FRMR_IS_INVALID;
>=20
> 	memset(&invalidate_wr, 0, sizeof(invalidate_wr));
> 	invalidate_wr.wr_id =3D (unsigned long)(void *)mw;
> 	invalidate_wr.opcode =3D IB_WR_LOCAL_INV;
> -	invalidate_wr.ex.invalidate_rkey =3D mw->r.frmr.fr_mr->rkey;
> +	invalidate_wr.ex.invalidate_rkey =3D frmr->fr_mr->rkey;
> 	DECR_CQCOUNT(&r_xprt->rx_ep);
>=20
> -	while (seg1->mr_nsegs--)
> -		rpcrdma_unmap_one(ia->ri_device, seg++);
> +	ib_dma_unmap_sg(ia->ri_device, frmr->sg, frmr->sg_nents, seg1->mr_d=
ir);
> 	read_lock(&ia->ri_qplock);
> 	rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
> 	read_unlock(&ia->ri_qplock);
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xp=
rt_rdma.h
> index c09414e6f91b..c82abf44e39d 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -193,7 +193,8 @@ enum rpcrdma_frmr_state {
> };
>=20
> struct rpcrdma_frmr {
> -	struct ib_fast_reg_page_list	*fr_pgl;
> +	struct scatterlist		*sg;
> +	int				sg_nents;
> 	struct ib_mr			*fr_mr;
> 	enum rpcrdma_frmr_state		fr_state;
> 	struct work_struct		fr_work;
> --=20
> 1.8.4.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
