From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
Date: Wed, 22 Jul 2015 11:03:49 -0400
Message-ID: <795F4F28-D92F-46A1-8DA3-2B1B19A17AA3@oracle.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-38-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-38-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 22, 2015, at 2:55 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> net/sunrpc/xprtrdma/frwr_ops.c  | 80 ++++++++++++++++++++++----------=
---------
> net/sunrpc/xprtrdma/xprt_rdma.h |  4 ++-
> 2 files changed, 47 insertions(+), 37 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frw=
r_ops.c
> index 517efed..e28246b 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -151,9 +151,13 @@ __frwr_init(struct rpcrdma_mw *r, struct ib_pd *=
pd, struct ib_device *device,
> 	f->fr_mr =3D ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG, depth, 0);
> 	if (IS_ERR(f->fr_mr))
> 		goto out_mr_err;
> -	f->fr_pgl =3D ib_alloc_fast_reg_page_list(device, depth);
> -	if (IS_ERR(f->fr_pgl))
> +
> +	f->sg =3D kcalloc(sizeof(*f->sg), depth, GFP_KERNEL);
> +	if (IS_ERR(f->sg))
> 		goto out_list_err;
> +
> +	sg_init_table(f->sg, depth);
> +
> 	return 0;
>=20
> out_mr_err:
> @@ -163,7 +167,7 @@ out_mr_err:
> 	return rc;
>=20
> out_list_err:
> -	rc =3D PTR_ERR(f->fr_pgl);
> +	rc =3D -ENOMEM;
> 	dprintk("RPC:       %s: ib_alloc_fast_reg_page_list status %i\n",
> 		__func__, rc);
> 	ib_dereg_mr(f->fr_mr);
> @@ -179,7 +183,7 @@ __frwr_release(struct rpcrdma_mw *r)
> 	if (rc)
> 		dprintk("RPC:       %s: ib_dereg_mr status %i\n",
> 			__func__, rc);
> -	ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
> +	kfree(r->r.frmr.sg);
> }
>=20
> static int
> @@ -320,10 +324,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct =
rpcrdma_mr_seg *seg,
> 	struct ib_send_wr fastreg_wr, *bad_wr;
> 	u8 key;
> 	int len, pageoff;
> -	int i, rc;
> -	int seg_len;
> -	u64 pa;
> -	int page_no;
> +	int i, rc, access;
>=20
> 	mw =3D seg1->rl_mw;
> 	seg1->rl_mw =3D NULL;
> @@ -344,39 +345,46 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct=
 rpcrdma_mr_seg *seg,
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
> +	for (i =3D 0; i < nsegs;) {
> +		sg_set_page(&frmr->sg[i], seg->mr_page,
> +			    seg->mr_len, offset_in_page(seg->mr_offset));

Cautionary note: here we=92re dealing with both the =93contiguous
set of pages=94 case and the =93small region of bytes in a single page=94
case. See rpcrdma_convert_iovs(): sometimes RPC send or receive
buffers can be registered (RDMA_NOMSG).


> 		len +=3D seg->mr_len;
> -		++seg;
> 		++i;
> -		/* Check for holes */
> +		++seg;
> +
> +		/* Check for holes - needed?? */
> 		if ((i < nsegs && offset_in_page(seg->mr_offset)) ||
> 		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
> 			break;
> 	}
> +
> +	frmr->sg_nents =3D i;
> +	frmr->dma_nents =3D ib_dma_map_sg(device, frmr->sg,
> +					frmr->sg_nents, direction);
> +	if (!frmr->dma_nents) {
> +		pr_err("RPC:       %s: failed to dma map sg %p sg_nents %d\n",
> +			__func__, frmr->sg, frmr->sg_nents);
> +		return -ENOMEM;
> +	}
> +
> 	dprintk("RPC:       %s: Using frmr %p to map %d segments (%d bytes)\=
n",
> 		__func__, mw, i, len);
>=20
> -	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
> -	fastreg_wr.wr_id =3D (unsigned long)(void *)mw;
> -	fastreg_wr.opcode =3D IB_WR_FAST_REG_MR;
> -	fastreg_wr.wr.fast_reg.iova_start =3D seg1->mr_dma + pageoff;
> -	fastreg_wr.wr.fast_reg.page_list =3D frmr->fr_pgl;
> -	fastreg_wr.wr.fast_reg.page_shift =3D PAGE_SHIFT;
> -	fastreg_wr.wr.fast_reg.page_list_len =3D page_no;
> -	fastreg_wr.wr.fast_reg.length =3D len;
> -	fastreg_wr.wr.fast_reg.access_flags =3D writing ?
> -				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
> -				IB_ACCESS_REMOTE_READ;
> 	mr =3D frmr->fr_mr;
> +	access =3D writing ? IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE=
 :
> +			   IB_ACCESS_REMOTE_READ;
> +	rc =3D ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, access);

I like this (and the matching ib_dma_unmap_sg). But why wouldn=92t
this function be called ib_dma_map_sg() ? The name ib_map_mr_sg()
had me thinking for a moment that this API actually posted the
=46ASTREG WR, but I see that it doesn=92t.


> +	if (rc) {
> +		pr_err("RPC:       %s: failed to map mr %p rc %d\n",
> +			__func__, frmr->fr_mr, rc);
> +		return rc;
> +	}
> +
> 	key =3D (u8)(mr->rkey & 0x000000FF);
> 	ib_update_fast_reg_key(mr, ++key);
> -	fastreg_wr.wr.fast_reg.rkey =3D mr->rkey;
> +
> +	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
> +	ib_set_fastreg_wr(mr, mr->rkey, (uintptr_t)mw, false, &fastreg_wr);
>=20
> 	DECR_CQCOUNT(&r_xprt->rx_ep);
> 	rc =3D ib_post_send(ia->ri_id->qp, &fastreg_wr, &bad_wr);
> @@ -385,15 +393,14 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct=
 rpcrdma_mr_seg *seg,
>=20
> 	seg1->rl_mw =3D mw;
> 	seg1->mr_rkey =3D mr->rkey;
> -	seg1->mr_base =3D seg1->mr_dma + pageoff;
> +	seg1->mr_base =3D mr->iova;
> 	seg1->mr_nsegs =3D i;
> 	seg1->mr_len =3D len;
> 	return i;
>=20
> out_senderr:
> 	dprintk("RPC:       %s: ib_post_send status %i\n", __func__, rc);
> -	while (i--)
> -		rpcrdma_unmap_one(device, --seg);
> +	ib_dma_unmap_sg(device, frmr->sg, frmr->sg_nents, direction);
> 	__frwr_queue_recovery(mw);
> 	return rc;
> }
> @@ -407,22 +414,23 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, stru=
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

->mr_dir was previously set by rpcrdma_map_one(), which you=92ve replac=
ed
with ib_map_mr_sg(). So maybe frwr_op_map() needs to save =93direction=94
in the rpcrdma_frmr.


> +
> 	read_lock(&ia->ri_qplock);
> 	rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
> 	read_unlock(&ia->ri_qplock);
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xp=
rt_rdma.h
> index 886f8c8..a1c3ab2b 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -195,7 +195,9 @@ enum rpcrdma_frmr_state {
> };
>=20
> struct rpcrdma_frmr {
> -	struct ib_fast_reg_page_list	*fr_pgl;
> +	struct scatterlist		*sg;
> +	unsigned int			sg_nents;
> +	unsigned int			dma_nents;
> 	struct ib_mr			*fr_mr;
> 	enum rpcrdma_frmr_state		fr_state;
> 	struct work_struct		fr_work;

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
