From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Max fastreg depth depends on DSGL
 support
Date: Thu, 18 Feb 2016 12:32:08 -0500
Message-ID: <56C60018.4050800@redhat.com>
References: <1455273635-30410-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N3i4pGim8XudtcLalsqK3BnH8XnuGU7V4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455273635-30410-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N3i4pGim8XudtcLalsqK3BnH8XnuGU7V4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/12/2016 5:40 AM, Hariprasad Shenai wrote:
> The max depth of a fastreg mr depends on whether the device supports
> DSGL or not.  So compute it dynamically based on the device support and=

> the module use_dsgl option.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Thanks, applied.

> ---
>  drivers/infiniband/hw/cxgb4/mem.c      |  8 +++++---
>  drivers/infiniband/hw/cxgb4/provider.c |  3 ++-
>  drivers/infiniband/hw/cxgb4/qp.c       | 10 ++++------
>  3 files changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/=
cxgb4/mem.c
> index 7849890c4781..9274c909cd19 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -617,12 +617,14 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
>  	int ret =3D 0;
>  	int length =3D roundup(max_num_sg * sizeof(u64), 32);
> =20
> +	php =3D to_c4iw_pd(pd);
> +	rhp =3D php->rhp;
> +
>  	if (mr_type !=3D IB_MR_TYPE_MEM_REG ||
> -	    max_num_sg > t4_max_fr_depth(use_dsgl))
> +	    max_num_sg > t4_max_fr_depth(&rhp->rdev.lldi.ulptx_memwrite_dsgl =
&&
> +					 use_dsgl))
>  		return ERR_PTR(-EINVAL);
> =20
> -	php =3D to_c4iw_pd(pd);
> -	rhp =3D php->rhp;
>  	mhp =3D kzalloc(sizeof(*mhp), GFP_KERNEL);
>  	if (!mhp) {
>  		ret =3D -ENOMEM;
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniban=
d/hw/cxgb4/provider.c
> index ec04272fbdc2..8669f48ebd8e 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -339,7 +339,8 @@ static int c4iw_query_device(struct ib_device *ibde=
v, struct ib_device_attr *pro
>  	props->max_mr =3D c4iw_num_stags(&dev->rdev);
>  	props->max_pd =3D T4_MAX_NUM_PD;
>  	props->local_ca_ack_delay =3D 0;
> -	props->max_fast_reg_page_list_len =3D t4_max_fr_depth(use_dsgl);
> +	props->max_fast_reg_page_list_len =3D
> +		t4_max_fr_depth(dev->rdev.lldi.ulptx_memwrite_dsgl && use_dsgl);
> =20
>  	return 0;
>  }
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/c=
xgb4/qp.c
> index dadf5f1855b3..d7293132ee86 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -606,7 +606,7 @@ static int build_rdma_recv(struct c4iw_qp *qhp, uni=
on t4_recv_wr *wqe,
>  }
> =20
>  static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
> -			struct ib_reg_wr *wr, u8 *len16, u8 t5dev)
> +			struct ib_reg_wr *wr, u8 *len16, bool dsgl_supported)
>  {
>  	struct c4iw_mr *mhp =3D to_c4iw_mr(wr->mr);
>  	struct fw_ri_immd *imdp;
> @@ -615,7 +615,7 @@ static int build_memreg(struct t4_sq *sq, union t4_=
wr *wqe,
>  	int pbllen =3D roundup(mhp->mpl_len * sizeof(u64), 32);
>  	int rem;
> =20
> -	if (mhp->mpl_len > t4_max_fr_depth(use_dsgl))
> +	if (mhp->mpl_len > t4_max_fr_depth(dsgl_supported && use_dsgl))
>  		return -EINVAL;
> =20
>  	wqe->fr.qpbinde_to_dcacpu =3D 0;
> @@ -629,7 +629,7 @@ static int build_memreg(struct t4_sq *sq, union t4_=
wr *wqe,
>  	wqe->fr.va_lo_fbo =3D cpu_to_be32(mhp->ibmr.iova &
>  					0xffffffff);
> =20
> -	if (t5dev && use_dsgl && (pbllen > max_fr_immd)) {
> +	if (dsgl_supported && use_dsgl && (pbllen > max_fr_immd)) {
>  		struct fw_ri_dsgl *sglp;
> =20
>  		for (i =3D 0; i < mhp->mpl_len; i++)
> @@ -808,9 +808,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_se=
nd_wr *wr,
>  			fw_opcode =3D FW_RI_FR_NSMR_WR;
>  			swsqe->opcode =3D FW_RI_FAST_REGISTER;
>  			err =3D build_memreg(&qhp->wq.sq, wqe, reg_wr(wr), &len16,
> -					   is_t5(
> -					   qhp->rhp->rdev.lldi.adapter_type) ?
> -					   1 : 0);
> +				qhp->rhp->rdev.lldi.ulptx_memwrite_dsgl);
>  			break;
>  		case IB_WR_LOCAL_INV:
>  			if (wr->send_flags & IB_SEND_FENCE)
>=20



--N3i4pGim8XudtcLalsqK3BnH8XnuGU7V4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxgAYAAoJELgmozMOVy/dhwgP/1x8zTNDTZ6AEGVsXIM1yzX8
IyLazwlREJX9CxzWdc5ORu4usHeTeZWQ6j8B04zzwUSWF0YPjXvzfC485qdugo6W
KnzCODBYUTWPEpos0VI8cymP+yi7+6Bz/x5PACj80aVBeOuN0hh2BYapOIykdNKK
WCuXeKAEGyvliKRciVNYlXE9E9sb5yaIUKkH2hJBbPZ5TqviSzAVe+dOsVMJ9NeW
fq3FqE9BXS106K0KSTGCxpWBGnCqm+HC+CWnRMmPDcrQNQnrKJ3oTVZBLlAcC4SO
mmz0fBXTFzQR45JmdynniU4/USn15uDg8PbhATLLCA0p/MksA8uH9/5qXMGIBa6g
KK0VKtgvPntq+aewYMFFPckB3Z68ubd/M5KrbMrkb9HaoKDlGPLL85IpzF2qMLG8
MIAW58CxhWY0kEI+S3ISrVnTTJwsTtX0z92VBE5LOGZhejToALpNu+ojL0rKL+dr
PmClbzjoIyRAwwD9IihvCbWKhbZby2VF5qNSH//nffYhEkoAigkogG/STbUsDIAW
grXz1N0fx9JSaX+8Lmp8KlQ5xN1y6S/96E1v5TR7pXazFAZrPN64j2rP+4UhwSWV
y8x4VKR0IOKmeXzM7il5hsmeWrQD6482mqo2ltAaNx+57YAt4JkhkJF6ak/abDa1
Y2+TaaoQ/l9EElUGS3Iv
=tISO
-----END PGP SIGNATURE-----

--N3i4pGim8XudtcLalsqK3BnH8XnuGU7V4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
