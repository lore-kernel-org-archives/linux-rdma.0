From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RDMA PATCH 01/16] RDMA/i40iw: Fix overflow of region length
Date: Mon, 18 Apr 2016 09:51:07 +0300
Message-ID: <20160418065107.GH6349@leon.nu>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
 <1460557852-10824-2-git-send-email-mustafa.ismail@intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZFKeWUZP29EKQNE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460557852-10824-2-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LZFKeWUZP29EKQNE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2016 at 09:30:37AM -0500, Mustafa Ismail wrote:
> Change region_length to u64 as a region can be > 4GB.
>=20
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_user.h  | 2 ++
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 8 +++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniban=
d/hw/i40iw/i40iw_user.h
> index 5cd971b..eac9524 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_user.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
> @@ -102,6 +102,8 @@ enum i40iw_device_capabilities_const {
> =20
>  #define I40IW_STAG_INDEX_FROM_STAG(stag)    (((stag) && 0xFFFFFF00) >> 8)
> =20
> +#define	I40IW_MAX_MR_SIZE	0x10000000000L
> +
>  struct i40iw_qp_uk;
>  struct i40iw_cq_uk;
>  struct i40iw_srq_uk;
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniba=
nd/hw/i40iw/i40iw_verbs.c
> index 1fe3b84..d7c4dd1 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> @@ -1526,14 +1526,16 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_=
pd *pd,
>  	struct i40iw_mr *iwmr;
>  	struct ib_umem *region;
>  	struct i40iw_mem_reg_req req;
> -	u32 pbl_depth =3D 0;
> +	u64 pbl_depth =3D 0;
>  	u32 stag =3D 0;
>  	u16 access;
> -	u32 region_length;
> +	u64 region_length;
>  	bool use_pbles =3D false;
>  	unsigned long flags;
>  	int err =3D -ENOSYS;
> =20
> +	if (length > I40IW_MAX_MR_SIZE)
> +		return ERR_PTR(-EINVAL);
>  	region =3D ib_umem_get(pd->uobject->context, start, length, acc, 0);
>  	if (IS_ERR(region))
>  		return (struct ib_mr *)region;
> @@ -1564,7 +1566,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd=
 *pd,
>  	palloc =3D &iwpbl->pble_alloc;
> =20
>  	iwmr->type =3D req.reg_type;
> -	iwmr->page_cnt =3D pbl_depth;
> +	iwmr->page_cnt =3D (u32)pbl_depth;

The cleanest approach will be to use lower_32_bits() macro, however both
options are valid.

Reviewed-by: Leon Romanvsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> =20
>  	switch (req.reg_type) {
>  	case IW_MEMREG_TYPE_QP:
> --=20
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LZFKeWUZP29EKQNE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJXFIPbAAoJEORje4g2clin1HwP9RSktncgVLumAWNn0EJDXjvJ
tKE7r1WEmDlesvp0hxVBvNU13nbbTu+tV/fzBzuSXF+312BGuMxN2t6ykmgAZM/o
GqK1v8BcudzXm7xnwamR8SSh3mnXY//55/0sCkMAIo3vHpLZdJNtIUQG0OR2EC6T
evx6GmRp4c6I851QY6EbcWOYQ+HTxcXTHIa2CkH0xUelJbEYaD2IZEBrf5PuYbgR
FyCEnI+DXXm/1SuJb1GDfz2R7+WfgFG6XjRW1k59ZSO5L/WfeaTLyOfE2aEx7kt6
01xtp8746AzojhOPjZ2b2V/wIMpSAtEXq6s1F5hfpyJwIfjN11wh+WvOsrMnQxLR
K6OaXjq0nvCTaBPUlek8U2Bu/K8N8MR6Q4yKBIp1pDb0aPlM5niiHNZFEmsI8Ze+
GetgPfLW1ekG3nn63DL0JuZf/E5AsuMnxbJbWOy7zpvyEXIzsWutzPhzqy5PQXLT
wv8dWZUsLlZUt5bXfNVu9fbrJXsZNMngnes5rvRbSg1e54bw3Z3LnjxAcVXU/y5B
OCp7LksuLZ44VuJPtskoSBgR9TkCFM7Mjc2DkNAOdCHXFAhuX5J7MmtrRQsrw23O
G3fH4RqY26g1kGdaYDlP4spuZugM/sDg5N/rellC7lRJY7vG917eT2XB47JOFcVd
ofWCTyTBA2eZnG+rNaU=
=YbON
-----END PGP SIGNATURE-----

--LZFKeWUZP29EKQNE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
