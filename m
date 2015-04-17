From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 2/4] iw_cxgb4: 32b platform fixes
Date: Fri, 17 Apr 2015 12:48:46 -0400
Message-ID: <1429289326.2980.494.camel@redhat.com>
References: <1429283105-13243-1-git-send-email-hariprasad@chelsio.com>
	 <1429283105-13243-3-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eUpSVWl3PDT9WOrB0Fes"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429283105-13243-3-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-eUpSVWl3PDT9WOrB0Fes
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-04-17 at 20:35 +0530, Hariprasad Shenai wrote:
> - get_dma_mr() was using ~0UL which is should be ~0ULL.  This causes the
> DMA MR to get setup incorrectly in hardware.
>=20
> - wr_log_show() needed a 64b divide function div64_u64() instead of
>   doing
> division directly.
>=20
> - fixed warnings about recasting a pointer to a u64
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c     |  2 +-
>  drivers/infiniband/hw/cxgb4/cq.c     |  6 +++---
>  drivers/infiniband/hw/cxgb4/device.c |  6 +++---
>  drivers/infiniband/hw/cxgb4/mem.c    | 10 +++++-----
>  drivers/infiniband/hw/cxgb4/qp.c     | 14 +++++++-------
>  5 files changed, 19 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxg=
b4/cm.c
> index 6ed5025..636fe84 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -3571,7 +3571,7 @@ static void send_fw_pass_open_req(struct c4iw_dev *=
dev, struct sk_buff *skb,
>  	 * TP will ignore any value > 0 for MSS index.
>  	 */
>  	req->tcb.opt0 =3D cpu_to_be64(MSS_IDX_V(0xF));
> -	req->cookie =3D (unsigned long)skb;
> +	req->cookie =3D (u64)(unsigned long)skb;

Wouldn't uintptr be a better option here?  Storing a pointer in an int
(or vice versa) is exactly the kind of thing it was created to handle in
the first place.

>  	set_wr_txq(req_skb, CPL_PRIORITY_CONTROL, port_id);
>  	ret =3D cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);
> diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxg=
b4/cq.c
> index ab7692a..a0358b1 100644
> --- a/drivers/infiniband/hw/cxgb4/cq.c
> +++ b/drivers/infiniband/hw/cxgb4/cq.c
> @@ -55,7 +55,7 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4=
_cq *cq,
>  			FW_RI_RES_WR_NRES_V(1) |
>  			FW_WR_COMPL_F);
>  	res_wr->len16_pkd =3D cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
> -	res_wr->cookie =3D (unsigned long) &wr_wait;
> +	res_wr->cookie =3D (u64)(unsigned long)&wr_wait;
>  	res =3D res_wr->res;
>  	res->u.cq.restype =3D FW_RI_RES_TYPE_CQ;
>  	res->u.cq.op =3D FW_RI_RES_OP_RESET;
> @@ -125,7 +125,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t=
4_cq *cq,
>  			FW_RI_RES_WR_NRES_V(1) |
>  			FW_WR_COMPL_F);
>  	res_wr->len16_pkd =3D cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
> -	res_wr->cookie =3D (unsigned long) &wr_wait;
> +	res_wr->cookie =3D (u64)(unsigned long)&wr_wait;
>  	res =3D res_wr->res;
>  	res->u.cq.restype =3D FW_RI_RES_TYPE_CQ;
>  	res->u.cq.op =3D FW_RI_RES_OP_WRITE;
> @@ -970,7 +970,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,=
 int entries,
>  	}
>  	PDBG("%s cqid 0x%0x chp %p size %u memsize %zu, dma_addr 0x%0llx\n",
>  	     __func__, chp->cq.cqid, chp, chp->cq.size,
> -	     chp->cq.memsize,
> +	     (unsigned long)chp->cq.memsize,
>  	     (unsigned long long) chp->cq.dma_addr);
>  	return &chp->ibcq;
>  err5:
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw=
/cxgb4/device.c
> index 8fb295e..5f7bb78 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -151,7 +151,7 @@ static int wr_log_show(struct seq_file *seq, void *v)
>  	int prev_ts_set =3D 0;
>  	int idx, end;
> =20
> -#define ts2ns(ts) div64_ul((ts) * dev->rdev.lldi.cclk_ps, 1000)
> +#define ts2ns(ts) div64_u64((ts) * dev->rdev.lldi.cclk_ps, 1000)
> =20
>  	idx =3D atomic_read(&dev->rdev.wr_log_idx) &
>  		(dev->rdev.wr_log_size - 1);
> @@ -784,10 +784,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>  	     rdev->lldi.vr->qp.size,
>  	     rdev->lldi.vr->cq.start,
>  	     rdev->lldi.vr->cq.size);
> -	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
> +	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
>  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
>  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> -	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
> +	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
>  	     rdev->lldi.db_reg,
>  	     rdev->lldi.gts_reg,
>  	     rdev->qpshift, rdev->qpmask,
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cx=
gb4/mem.c
> index 6791fd1..30db971 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -144,7 +144,7 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *r=
dev, u32 addr, u32 len,
>  		if (i =3D=3D (num_wqe-1)) {
>  			req->wr.wr_hi =3D cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR) |
>  						    FW_WR_COMPL_F);
> -			req->wr.wr_lo =3D (__force __be64)(unsigned long) &wr_wait;
> +			req->wr.wr_lo =3D (__force __be64)(unsigned long)&wr_wait;
>  		} else
>  			req->wr.wr_hi =3D cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR));
>  		req->wr.wr_mid =3D cpu_to_be32(
> @@ -676,12 +676,12 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int=
 acc)
>  	mhp->attr.zbva =3D 0;
>  	mhp->attr.va_fbo =3D 0;
>  	mhp->attr.page_size =3D 0;
> -	mhp->attr.len =3D ~0UL;
> +	mhp->attr.len =3D ~0ULL;
>  	mhp->attr.pbl_size =3D 0;
> =20
>  	ret =3D write_tpt_entry(&rhp->rdev, 0, &stag, 1, php->pdid,
>  			      FW_RI_STAG_NSMR, mhp->attr.perms,
> -			      mhp->attr.mw_bind_enable, 0, 0, ~0UL, 0, 0, 0);
> +			      mhp->attr.mw_bind_enable, 0, 0, ~0ULL, 0, 0, 0);
>  	if (ret)
>  		goto err1;
> =20
> @@ -930,7 +930,7 @@ struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(=
struct ib_device *device,
> =20
>  	PDBG("%s c4pl %p pll_len %u page_list %p dma_addr %pad\n",
>  	     __func__, c4pl, c4pl->pll_len, c4pl->ibpl.page_list,
> -	     &c4pl->dma_addr);
> +	     (void *)(unsigned long)c4pl->dma_addr);
> =20
>  	return &c4pl->ibpl;
>  }
> @@ -941,7 +941,7 @@ void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_li=
st *ibpl)
> =20
>  	PDBG("%s c4pl %p pll_len %u page_list %p dma_addr %pad\n",
>  	     __func__, c4pl, c4pl->pll_len, c4pl->ibpl.page_list,
> -	     &c4pl->dma_addr);
> +	     (void *)(unsigned long)c4pl->dma_addr);
> =20
>  	dma_free_coherent(&c4pl->dev->rdev.lldi.pdev->dev,
>  			  c4pl->pll_len,
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxg=
b4/qp.c
> index 15cae5a..3496cc7 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -275,7 +275,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t=
4_wq *wq,
>  			FW_RI_RES_WR_NRES_V(2) |
>  			FW_WR_COMPL_F);
>  	res_wr->len16_pkd =3D cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
> -	res_wr->cookie =3D (unsigned long) &wr_wait;
> +	res_wr->cookie =3D (u64)(unsigned long)&wr_wait;
>  	res =3D res_wr->res;
>  	res->u.sqrq.restype =3D FW_RI_RES_TYPE_SQ;
>  	res->u.sqrq.op =3D FW_RI_RES_OP_WRITE;
> @@ -1209,7 +1209,7 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c=
4iw_qp *qhp,
>  	wqe->flowid_len16 =3D cpu_to_be32(
>  		FW_WR_FLOWID_V(ep->hwtid) |
>  		FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*wqe), 16)));
> -	wqe->cookie =3D (unsigned long) &ep->com.wr_wait;
> +	wqe->cookie =3D (u64)(unsigned long)&ep->com.wr_wait;
> =20
>  	wqe->u.fini.type =3D FW_RI_TYPE_FINI;
>  	ret =3D c4iw_ofld_send(&rhp->rdev, skb);
> @@ -1279,7 +1279,7 @@ static int rdma_init(struct c4iw_dev *rhp, struct c=
4iw_qp *qhp)
>  		FW_WR_FLOWID_V(qhp->ep->hwtid) |
>  		FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*wqe), 16)));
> =20
> -	wqe->cookie =3D (unsigned long) &qhp->ep->com.wr_wait;
> +	wqe->cookie =3D (u64)(unsigned long)&qhp->ep->com.wr_wait;
> =20
>  	wqe->u.init.type =3D FW_RI_TYPE_INIT;
>  	wqe->u.init.mpareqbit_p2ptype =3D
> @@ -1766,11 +1766,11 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, st=
ruct ib_qp_init_attr *attrs,
>  		mm2->len =3D PAGE_ALIGN(qhp->wq.rq.memsize);
>  		insert_mmap(ucontext, mm2);
>  		mm3->key =3D uresp.sq_db_gts_key;
> -		mm3->addr =3D (__force unsigned long) qhp->wq.sq.udb;
> +		mm3->addr =3D (u64)(unsigned long)qhp->wq.sq.udb;
>  		mm3->len =3D PAGE_SIZE;
>  		insert_mmap(ucontext, mm3);
>  		mm4->key =3D uresp.rq_db_gts_key;
> -		mm4->addr =3D (__force unsigned long) qhp->wq.rq.udb;
> +		mm4->addr =3D (u64)(unsigned long)qhp->wq.rq.udb;
>  		mm4->len =3D PAGE_SIZE;
>  		insert_mmap(ucontext, mm4);
>  		if (mm5) {
> @@ -1786,9 +1786,9 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, stru=
ct ib_qp_init_attr *attrs,
>  	INIT_LIST_HEAD(&qhp->db_fc_entry);
>  	PDBG("%s sq id %u size %u memsize %zu num_entries %u "
>  	     "rq id %u size %u memsize %zu num_entries %u\n", __func__,
> -	     qhp->wq.sq.qid, qhp->wq.sq.size, qhp->wq.sq.memsize,
> +	     qhp->wq.sq.qid, qhp->wq.sq.size, (unsigned long)qhp->wq.sq.memsize=
,
>  	     attrs->cap.max_send_wr, qhp->wq.rq.qid, qhp->wq.rq.size,
> -	     qhp->wq.rq.memsize, attrs->cap.max_recv_wr);
> +	     (unsigned long)qhp->wq.rq.memsize, attrs->cap.max_recv_wr);
>  	return &qhp->ibqp;
>  err8:
>  	kfree(mm5);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-eUpSVWl3PDT9WOrB0Fes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVMTlvAAoJELgmozMOVy/dGL0P/3zCqa0bVCgUiwFwGdeTA8r2
YKuVNzld9ZxDUzgaF3LzpMwnDaKR1Tc3TLg+Yfbs+HTtz9fStsIsLVrbU2fOyLzl
CoMJNAaP7xHjoI1d8BuMvHcxUWebfpwr3KKpXl2ka8CfAQwj9vsNESSse8U1Qgd3
X2Ss9ZkZqj7v4bw00+7dCkX/H6PqbL7/XAj2wcUNN5uwWQmTmCI9451SMOqQs2MK
YHGliTp8C37gtKrq/VfGCi7GjjY2entl3xNLvi5gKzzpA9jK4LFWc5ffjn1XOlpI
KJUXGLVG7KGz+4hAGGz5w8QcCBED3TQHbz7Om27NHZ2UDTI1AWiQOfbzeaD6MAlA
OGUiTCMmpfSyhI5MLvbRFZNpqV0GkaJ90MNXd9eZyuuJG4x959A8bN5dTqC9oXti
Rp2XzKs8IKAymERwhzf2qtl/UzVT2Mm8B3sTc254hJ49cbimp5pHbAa/qbMyINJj
z3928BOPFLaNz9R0HA1oqH4SbQk7qMoPXL4XLGUUiSoE+qSTWOXvOZ8Y+F3RoHLv
1U6+i2SPspCkDUMoxjZhe0NYIwFikFyh8Kjp0X/qEk2M93ZZmcH538Fef6Z1bKSt
9uckXxgN632GAX5Mj0Gdu2AG/TiOLqZZb5LeCY4mR/nwDO5q3j1lQPqbGkgnDSg+
bai+h3Gxa6tHimfJXD7g
=rhZo
-----END PGP SIGNATURE-----

--=-eUpSVWl3PDT9WOrB0Fes--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
