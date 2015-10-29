From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 27/26] IB/hfi1: Remove fast registration from the code
Date: Thu, 29 Oct 2015 11:44:52 -0400
Message-ID: <56323EF4.8030009@redhat.com>
References: <1446132812-20170-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l3H7WpLFfcQXnBolV1LUT6aSHsDQjuLdX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446132812-20170-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l3H7WpLFfcQXnBolV1LUT6aSHsDQjuLdX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 11:33 AM, Sagi Grimberg wrote:
> The driver does not support it anyway, and the support
> should be added to a generic layer shared by both hfi1,
> qib and softroce drivers.
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

> ---
>  drivers/staging/rdma/hfi1/keys.c  |   55 -----------------------------=
--------
>  drivers/staging/rdma/hfi1/mr.c    |   33 +---------------------
>  drivers/staging/rdma/hfi1/verbs.c |    9 +-----
>  drivers/staging/rdma/hfi1/verbs.h |    8 -----
>  4 files changed, 3 insertions(+), 102 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/hfi1/keys.c b/drivers/staging/rdma/hf=
i1/keys.c
> index 82c21b1..cb4e608 100644
> --- a/drivers/staging/rdma/hfi1/keys.c
> +++ b/drivers/staging/rdma/hfi1/keys.c
> @@ -354,58 +354,3 @@ bail:
>  	rcu_read_unlock();
>  	return 0;
>  }
> -
> -/*
> - * Initialize the memory region specified by the work request.
> - */
> -int hfi1_fast_reg_mr(struct hfi1_qp *qp, struct ib_fast_reg_wr *wr)
> -{
> -	struct hfi1_lkey_table *rkt =3D &to_idev(qp->ibqp.device)->lk_table;
> -	struct hfi1_pd *pd =3D to_ipd(qp->ibqp.pd);
> -	struct hfi1_mregion *mr;
> -	u32 rkey =3D wr->rkey;
> -	unsigned i, n, m;
> -	int ret =3D -EINVAL;
> -	unsigned long flags;
> -	u64 *page_list;
> -	size_t ps;
> -
> -	spin_lock_irqsave(&rkt->lock, flags);
> -	if (pd->user || rkey =3D=3D 0)
> -		goto bail;
> -
> -	mr =3D rcu_dereference_protected(
> -		rkt->table[(rkey >> (32 - hfi1_lkey_table_size))],
> -		lockdep_is_held(&rkt->lock));
> -	if (unlikely(mr =3D=3D NULL || qp->ibqp.pd !=3D mr->pd))
> -		goto bail;
> -
> -	if (wr->page_list_len > mr->max_segs)
> -		goto bail;
> -
> -	ps =3D 1UL << wr->page_shift;
> -	if (wr->length > ps * wr->page_list_len)
> -		goto bail;
> -
> -	mr->user_base =3D wr->iova_start;
> -	mr->iova =3D wr->iova_start;
> -	mr->lkey =3D rkey;
> -	mr->length =3D wr->length;
> -	mr->access_flags =3D wr->access_flags;
> -	page_list =3D wr->page_list->page_list;
> -	m =3D 0;
> -	n =3D 0;
> -	for (i =3D 0; i < wr->page_list_len; i++) {
> -		mr->map[m]->segs[n].vaddr =3D (void *) page_list[i];
> -		mr->map[m]->segs[n].length =3D ps;
> -		if (++n =3D=3D HFI1_SEGSZ) {
> -			m++;
> -			n =3D 0;
> -		}
> -	}
> -
> -	ret =3D 0;
> -bail:
> -	spin_unlock_irqrestore(&rkt->lock, flags);
> -	return ret;
> -}
> diff --git a/drivers/staging/rdma/hfi1/mr.c b/drivers/staging/rdma/hfi1=
/mr.c
> index bd64e4f..402bd64 100644
> --- a/drivers/staging/rdma/hfi1/mr.c
> +++ b/drivers/staging/rdma/hfi1/mr.c
> @@ -344,9 +344,10 @@ out:
> =20
>  /*
>   * Allocate a memory region usable with the
> - * IB_WR_FAST_REG_MR send work request.
> + * IB_WR_REG_MR send work request.
>   *
>   * Return the memory region on success, otherwise return an errno.
> + * FIXME: IB_WR_REG_MR is not supported
>   */
>  struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
>  			    enum ib_mr_type mr_type,
> @@ -364,36 +365,6 @@ struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
>  	return &mr->ibmr;
>  }
> =20
> -struct ib_fast_reg_page_list *
> -hfi1_alloc_fast_reg_page_list(struct ib_device *ibdev, int page_list_l=
en)
> -{
> -	unsigned size =3D page_list_len * sizeof(u64);
> -	struct ib_fast_reg_page_list *pl;
> -
> -	if (size > PAGE_SIZE)
> -		return ERR_PTR(-EINVAL);
> -
> -	pl =3D kzalloc(sizeof(*pl), GFP_KERNEL);
> -	if (!pl)
> -		return ERR_PTR(-ENOMEM);
> -
> -	pl->page_list =3D kzalloc(size, GFP_KERNEL);
> -	if (!pl->page_list)
> -		goto err_free;
> -
> -	return pl;
> -
> -err_free:
> -	kfree(pl);
> -	return ERR_PTR(-ENOMEM);
> -}
> -
> -void hfi1_free_fast_reg_page_list(struct ib_fast_reg_page_list *pl)
> -{
> -	kfree(pl->page_list);
> -	kfree(pl);
> -}
> -
>  /**
>   * hfi1_alloc_fmr - allocate a fast memory region
>   * @pd: the protection domain for this memory region
> diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/h=
fi1/verbs.c
> index 981e6c1..6e2da7e 100644
> --- a/drivers/staging/rdma/hfi1/verbs.c
> +++ b/drivers/staging/rdma/hfi1/verbs.c
> @@ -380,9 +380,7 @@ static int post_one_send(struct hfi1_qp *qp, struct=
 ib_send_wr *wr)
>  	 * undefined operations.
>  	 * Make sure buffer is large enough to hold the result for atomics.
>  	 */
> -	if (wr->opcode =3D=3D IB_WR_FAST_REG_MR) {
> -		return -EINVAL;
> -	} else if (qp->ibqp.qp_type =3D=3D IB_QPT_UC) {
> +	if (qp->ibqp.qp_type =3D=3D IB_QPT_UC) {
>  		if ((unsigned) wr->opcode >=3D IB_WR_RDMA_READ)
>  			return -EINVAL;
>  	} else if (qp->ibqp.qp_type !=3D IB_QPT_RC) {
> @@ -417,9 +415,6 @@ static int post_one_send(struct hfi1_qp *qp, struct=
 ib_send_wr *wr)
>  	if (qp->ibqp.qp_type !=3D IB_QPT_UC &&
>  	    qp->ibqp.qp_type !=3D IB_QPT_RC)
>  		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
> -	else if (wr->opcode =3D=3D IB_WR_FAST_REG_MR)
> -		memcpy(&wqe->fast_reg_wr, fast_reg_wr(wr),
> -			sizeof(wqe->fast_reg_wr));
>  	else if (wr->opcode =3D=3D IB_WR_RDMA_WRITE_WITH_IMM ||
>  		 wr->opcode =3D=3D IB_WR_RDMA_WRITE ||
>  		 wr->opcode =3D=3D IB_WR_RDMA_READ)
> @@ -2065,8 +2060,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *=
dd)
>  	ibdev->reg_user_mr =3D hfi1_reg_user_mr;
>  	ibdev->dereg_mr =3D hfi1_dereg_mr;
>  	ibdev->alloc_mr =3D hfi1_alloc_mr;
> -	ibdev->alloc_fast_reg_page_list =3D hfi1_alloc_fast_reg_page_list;
> -	ibdev->free_fast_reg_page_list =3D hfi1_free_fast_reg_page_list;
>  	ibdev->alloc_fmr =3D hfi1_alloc_fmr;
>  	ibdev->map_phys_fmr =3D hfi1_map_phys_fmr;
>  	ibdev->unmap_fmr =3D hfi1_unmap_fmr;
> diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/h=
fi1/verbs.h
> index cf5a3c9..159ec08 100644
> --- a/drivers/staging/rdma/hfi1/verbs.h
> +++ b/drivers/staging/rdma/hfi1/verbs.h
> @@ -353,7 +353,6 @@ struct hfi1_swqe {
>  		struct ib_rdma_wr rdma_wr;
>  		struct ib_atomic_wr atomic_wr;
>  		struct ib_ud_wr ud_wr;
> -		struct ib_fast_reg_wr fast_reg_wr;
>  	};
>  	u32 psn;                /* first packet sequence number */
>  	u32 lpsn;               /* last packet sequence number */
> @@ -1026,13 +1025,6 @@ struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
>  			    enum ib_mr_type mr_type,
>  			    u32 max_entries);
> =20
> -struct ib_fast_reg_page_list *hfi1_alloc_fast_reg_page_list(
> -				struct ib_device *ibdev, int page_list_len);
> -
> -void hfi1_free_fast_reg_page_list(struct ib_fast_reg_page_list *pl);
> -
> -int hfi1_fast_reg_mr(struct hfi1_qp *qp, struct ib_fast_reg_wr *wr);
> -
>  struct ib_fmr *hfi1_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
>  			      struct ib_fmr_attr *fmr_attr);
> =20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--l3H7WpLFfcQXnBolV1LUT6aSHsDQjuLdX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMj70AAoJELgmozMOVy/dCAwQAK9EZgfsRmI5r/QR9onfbCyu
wQmuiwlah3pIC1adyMOzDdLjjowJWdwKK4olVdnUBwjg+68O41maiZ308BeQb4Iw
5uOQGxp5/5gOc5b2eV+uigD6DS81xSOm3A6CyaPTJGQRE7HUXYZrTW4EpEmzwxPr
VBTggK5jWEjlhCMMWbFws5DgV1DW2wLk/4Dm9QlVhZh7hPdWQG5E+nbEVXK64cqh
RzK2MYGdByhXl3/q5Ahq+Z0jCmceRB6JRuexC+RWGxg4WWKsIMha1hx3wrsU7QPk
zFhZ4tDSdUDTamLwpmyY3vj0/Z7/hytLN9THrUlZHbNjceDuboBF6gedQNKb6LUN
KsP9XTDUvoE7SGLDZp2FHM7o7yPhz2HYHFePVgORIAGq4qaFXPujln7sFQkgn690
fAMnrwse92KP9++IBIHpvasS5IibbW24EOnjMo5QteVZvDae8X3tl8JGaNUJORaa
dUDmM9vmFLREekPZfEBCgtFNGvP2ZtEoZ3VDpX5SpYbcBwUtvgye65AcqaKYsI9B
VBwbDwkveHCZfxGuM/spUyI8REG0wcW0ebslbYfs1OK6t7ULa4PvjUqahrooLdhY
SDAPDaxl2qtasj3HkDphryR/xgeZJLvS+xI2U2LvPesdNozuVdcIkorn273CEocv
D4IbUDYcMp30ueCE9sQx
=QjMD
-----END PGP SIGNATURE-----

--l3H7WpLFfcQXnBolV1LUT6aSHsDQjuLdX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
