From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 07/12] IB/ocrdma: Adjust 21 checks for null pointers
Date: Sun, 23 Apr 2017 09:07:19 +0300
Message-ID: <20170423060719.GZ14088@mtr-leonro.local>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
 <3ec5ffa4-8976-e793-f22c-5f01c9d6bb9d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ItroYk2LVxvwOvi/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3ec5ffa4-8976-e793-f22c-5f01c9d6bb9d-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ItroYk2LVxvwOvi/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 22, 2017 at 04:47:19PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sat, 22 Apr 2017 14:20:37 +0200
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> The script =E2=80=9Ccheckpatch.pl=E2=80=9D pointed information out like t=
he following.
>
> Comparison to NULL could be written !=E2=80=A6
>
> Thus fix affected source code places.
>
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>
> v2:
> Changes were rebased on source files from Linux next-20170421.
> These were recombined as requested by Doug Ledford.
>
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 20 ++++++++++----------
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 20 ++++++++++----------
>  3 files changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniban=
d/hw/ocrdma/ocrdma_hw.c
> index d5b988b011d1..8c7f0b108a7f 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -665,7 +665,7 @@ static void ocrdma_process_qpcat_error(struct ocrdma_=
dev *dev,
>  	enum ib_qp_state new_ib_qps =3D IB_QPS_ERR;
>  	enum ib_qp_state old_ib_qps;
>
> -	if (qp =3D=3D NULL)
> +	if (!qp)
>  		BUG();

There is a need to get rid of BUG() in driver code.

>  	ocrdma_qp_state_change(qp, new_ib_qps, &old_ib_qps);
>  }
> @@ -693,7 +693,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev=
 *dev,
>  	if (cqe->qpvalid_qpid & OCRDMA_AE_MCQE_QPVALID) {
>  		if (qpid < dev->attr.max_qp)
>  			qp =3D dev->qp_tbl[qpid];
> -		if (qp =3D=3D NULL) {
> +		if (!qp) {
>  			pr_err("ocrdma%d:Async event - qpid %u is not valid\n",
>  			       dev->id, qpid);
>  			return;
> @@ -703,7 +703,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev=
 *dev,
>  	if (cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQVALID) {
>  		if (cqid < dev->attr.max_cq)
>  			cq =3D dev->cq_tbl[cqid];
> -		if (cq =3D=3D NULL) {
> +		if (!cq) {
>  			pr_err("ocrdma%d:Async event - cqid %u is not valid\n",
>  			       dev->id, cqid);
>  			return;
> @@ -882,7 +882,7 @@ static int ocrdma_mq_cq_handler(struct ocrdma_dev *de=
v, u16 cq_id)
>
>  	while (1) {
>  		cqe =3D ocrdma_get_mcqe(dev);
> -		if (cqe =3D=3D NULL)
> +		if (!cqe)
>  			break;
>  		ocrdma_le32_to_cpu(cqe, sizeof(*cqe));
>  		cqe_popped +=3D 1;
> @@ -948,7 +948,7 @@ static void ocrdma_qp_buddy_cq_handler(struct ocrdma_=
dev *dev,
>  	 * false - Check for RQ CQ
>  	 */
>  	bcq =3D _ocrdma_qp_buddy_cq_handler(dev, cq, true);
> -	if (bcq =3D=3D NULL)
> +	if (!bcq)
>  		bcq =3D _ocrdma_qp_buddy_cq_handler(dev, cq, false);
>  	spin_unlock_irqrestore(&dev->flush_q_lock, flags);
>
> @@ -969,7 +969,7 @@ static void ocrdma_qp_cq_handler(struct ocrdma_dev *d=
ev, u16 cq_idx)
>  		BUG();
>
>  	cq =3D dev->cq_tbl[cq_idx];
> -	if (cq =3D=3D NULL)
> +	if (!cq)
>  		return;
>
>  	if (cq->ibcq.comp_handler) {
> @@ -1289,7 +1289,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, b=
ool reset)
>  	int status;
>
>  	old_stats =3D kmalloc(sizeof(*old_stats), GFP_KERNEL);
> -	if (old_stats =3D=3D NULL)
> +	if (!old_stats)
>  		return -ENOMEM;
>
>  	memset(mqe, 0, sizeof(*mqe));
> @@ -1676,12 +1676,12 @@ static int ocrdma_mbx_create_ah_tbl(struct ocrdma=
_dev *dev)
>  	dev->av_tbl.pbl.va =3D dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
>  						&dev->av_tbl.pbl.pa,
>  						GFP_KERNEL);
> -	if (dev->av_tbl.pbl.va =3D=3D NULL)
> +	if (!dev->av_tbl.pbl.va)
>  		goto mem_err;
>
>  	dev->av_tbl.va =3D dma_alloc_coherent(&pdev->dev, dev->av_tbl.size,
>  					    &pa, GFP_KERNEL);
> -	if (dev->av_tbl.va =3D=3D NULL)
> +	if (!dev->av_tbl.va)
>  		goto mem_err_ah;
>  	dev->av_tbl.pa =3D pa;
>  	dev->av_tbl.num_ah =3D max_ah;
> @@ -1722,7 +1722,7 @@ static void ocrdma_mbx_delete_ah_tbl(struct ocrdma_=
dev *dev)
>  	struct ocrdma_delete_ah_tbl *cmd;
>  	struct pci_dev *pdev =3D dev->nic_info.pdev;
>
> -	if (dev->av_tbl.va =3D=3D NULL)
> +	if (!dev->av_tbl.va)
>  		return;
>
>  	cmd =3D ocrdma_init_emb_mqe(OCRDMA_CMD_DELETE_AH_TBL, sizeof(*cmd));
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infinib=
and/hw/ocrdma/ocrdma_main.c
> index e2aa67d6cbb8..b82f6c6942e0 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -238,7 +238,7 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *=
dev)
>
>  	dev->stag_arr =3D kcalloc(OCRDMA_MAX_STAG, sizeof(*dev->stag_arr),
>  				GFP_KERNEL);
> -	if (dev->stag_arr =3D=3D NULL)
> +	if (!dev->stag_arr)
>  		goto alloc_err;
>
>  	ocrdma_alloc_pd_pool(dev);
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index 5eaf946aeac6..c804889db7e1 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -267,7 +267,7 @@ static int ocrdma_add_mmap(struct ocrdma_ucontext *uc=
tx, u64 phy_addr,
>  	struct ocrdma_mm *mm;
>
>  	mm =3D kzalloc(sizeof(*mm), GFP_KERNEL);
> -	if (mm =3D=3D NULL)
> +	if (!mm)
>  		return -ENOMEM;
>  	mm->key.phy_addr =3D phy_addr;
>  	mm->key.len =3D len;
> @@ -1194,7 +1194,7 @@ static int ocrdma_add_qpn_map(struct ocrdma_dev *de=
v, struct ocrdma_qp *qp)
>  {
>  	int status =3D -EINVAL;
>
> -	if (qp->id < OCRDMA_MAX_QP && dev->qp_tbl[qp->id] =3D=3D NULL) {
> +	if (qp->id < OCRDMA_MAX_QP && !dev->qp_tbl[qp->id]) {
>  		dev->qp_tbl[qp->id] =3D qp;
>  		status =3D 0;
>  	}
> @@ -1362,11 +1362,11 @@ static int ocrdma_alloc_wr_id_tbl(struct ocrdma_q=
p *qp)
>  {
>  	qp->wqe_wr_id_tbl =3D kcalloc(qp->sq.max_cnt, sizeof(*qp->wqe_wr_id_tbl=
),
>  				    GFP_KERNEL);
> -	if (qp->wqe_wr_id_tbl =3D=3D NULL)
> +	if (!qp->wqe_wr_id_tbl)
>  		return -ENOMEM;
>  	qp->rqe_wr_id_tbl =3D kcalloc(qp->rq.max_cnt, sizeof(*qp->rqe_wr_id_tbl=
),
>  				    GFP_KERNEL);
> -	if (qp->rqe_wr_id_tbl =3D=3D NULL)
> +	if (!qp->rqe_wr_id_tbl)
>  		return -ENOMEM;

Memory leak here, need to free qp->wqe_wr_id_tb here.

>
>  	return 0;
> @@ -1426,7 +1426,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
>  		goto gen_err;
>  	}
>  	ocrdma_set_qp_init_params(qp, pd, attrs);
> -	if (udata =3D=3D NULL)
> +	if (!udata)
>  		qp->cap_flags |=3D (OCRDMA_QP_MW_BIND | OCRDMA_QP_LKEY0 |
>  					OCRDMA_QP_FAST_REG);
>
> @@ -1438,7 +1438,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
>  		goto mbx_err;
>
>  	/* user space QP's wr_id table are managed in library */
> -	if (udata =3D=3D NULL) {
> +	if (!udata) {
>  		status =3D ocrdma_alloc_wr_id_tbl(qp);
>  		if (status)
>  			goto map_err;
> @@ -1899,11 +1899,11 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ib=
pd,
>  	if (status)
>  		goto err;
>
> -	if (udata =3D=3D NULL) {
> +	if (!udata) {
>  		srq->rqe_wr_id_tbl =3D kcalloc(srq->rq.max_cnt,
>  					     sizeof(*srq->rqe_wr_id_tbl),
>  					     GFP_KERNEL);
> -		if (srq->rqe_wr_id_tbl =3D=3D NULL)
> +		if (!srq->rqe_wr_id_tbl)
>  			goto arm_err;
>
>  		srq->bit_fields_len =3D (srq->rq.max_cnt / 32) +
> @@ -1911,7 +1911,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
>  		srq->idx_bit_fields =3D kmalloc_array(srq->bit_fields_len,
>  						    sizeof(*srq->idx_bit_fields),
>  						    GFP_KERNEL);
> -		if (srq->idx_bit_fields =3D=3D NULL)
> +		if (!srq->idx_bit_fields)
>  			goto arm_err;
>  		memset(srq->idx_bit_fields, 0xff,
>  		       srq->bit_fields_len * sizeof(*srq->idx_bit_fields));
> @@ -2885,7 +2885,7 @@ static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, i=
nt num_entries,
>  		if (qpn =3D=3D 0)
>  			goto skip_cqe;
>  		qp =3D dev->qp_tbl[qpn];
> -		BUG_ON(qp =3D=3D NULL);
> +		BUG_ON(!qp);

Again, bug in driver can crash whole system. There is a need to get rid
of it.

>
>  		expand =3D is_cqe_for_sq(cqe)
>  			 ? ocrdma_poll_scqe(qp, cqe, ibwc, &polled, &stop)
> --
> 2.12.2
>

--ItroYk2LVxvwOvi/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj8RJcACgkQ5GN7iDZy
WKdYLxAApbZ8rW6gO3UEu62BXLfJX1g/wpGcGkrnqNtYYzylyIn+MEzVMF76+yu8
/R1tio+WrApijZKjoLAJVFY3L9dC6rV167PUyLKCis8owKGfE5Amm9ZVADBOmd2+
SFbogcaBPWGSRfsUGzneienqB/yh4NWqvtz72LFutCmdqsaXaIWNzzPZRvdK5HJb
Kd5cuF3zesmMhSkHpIgUUsa1Xkut8k0hmRt9Kfa3sM339Ipod9A6j4Qpw+3NKubp
Fw6DFVHtwOVCp/p/OKvKLMCpAqFamM9164+X1Bq0JO5Ty1olM/5/8w/JfSKr7gey
dTw/JknWqK8SWSrhXOFBr/sNZ4DfhClnU0ydgJ+L3hj9r5Imv+eNRpgseKawwzWc
tW5rEzuZ3FjqaCzDpYMYwaNLwxfcA8ImZww1nF3o2+Q2vkTonUBIjBKg6rz6VJmX
nZrEnDdL97CUnnq6BH3NQSnGsSu1znbuLf0Vd/T5yjf04BN4ykXl7cR4koaP+bIz
vV/MP4e9y8NeOIfAEwIVmJCQp6sVV0HGJ5gt7yMMaGevd4nBBgRP9N0D7U11b96/
9H7KctMf3+UruK+CnOLClyum3liaYrPKvMIbNKdnoqPIJ8IV9fGeKUk7vP4JZd62
pkZYvJn3XVqM+Tr/QygzxMrbez/clejC4vlYKDhqIjsJPcyt3Bw=
=m9vV
-----END PGP SIGNATURE-----

--ItroYk2LVxvwOvi/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
