From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
Date: Tue, 23 Aug 2016 04:41:35 +0300
Message-ID: <20160823014135.GF15065@leon.nu>
References: <1471910507-83104-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471910507-83104-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 22, 2016 at 07:01:47PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> In i40iw_free_virt_mem(), do not set mem->va to NULL
> after freeing it as mem->va is a self-referencing pointer
> to mem.

Sorry, I failed to understand your commit message and your change.
What did you mean? How do you suppose to use mem->va pointer
after kfree() call on that pointer? Won't you have use-after-free bug in
such case?

>=20
> Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
>=20
> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>=20
> V2: Fix typo in subject line.
>=20
>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniba=
nd/hw/i40iw/i40iw_utils.c
> index 0e8db0a..d5f5de2 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
> @@ -674,7 +674,6 @@ enum i40iw_status_code i40iw_free_virt_mem(struct i40=
iw_hw *hw,
>  	if (!mem)
>  		return I40IW_ERR_PARAM;
>  	kfree(mem->va);
> -	mem->va =3D NULL;
>  	return 0;
>  }
> =20
> --=20
> 2.8.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXu6nPAAoJEORje4g2clinJ+8QAKrD58WFcF2l+6XQjUXEuy/i
kfiNnLX6/Lwca7e87RotsA0l74xKwaroC1qntdIGwMrAE9TW1KtRGjfRzARE4n5T
AmMjilkT0Fev4bRLvDCGAxkgki/MhryCVqv5IKufZaF0tzCb51W5RoYumv60vXWo
UPhw8OckEGbVkOozSc3EExLu+nuYq+lAM1Tgfcgdi1BtVz92XFDChtAyzM21f8TP
KnLpj2ZqarcvHmp5HvUP6yYvL4xhJQePMGjVZcjNlv9GtgRdC+3VwQ0vNjYHMh0t
YdJ8Sl+Rt+Z8IioGJ+zwG3nXGaBS9IP0Z3N3OK4qUV2tOOoV+O2gG0SURgtDXnlX
Y7oMRhoMuYvhk6II0KjBYA5DyP2TowBGSB3fgsEDOTNZwAG0+BjtXduD5gJ+dns3
sKzeQkZFWAbLIahuIXSo3auqmGpEyfFyWhT4WW7ESa4TyrV0h6fk4mOOmx2lYIob
kRhTKX/gYIAv3UGm+/AstgWUfULBGPK2GHAPpvCn5iHiHwKW/Tpv3RDzPSgPrPRf
6VufDbii/VeX/59JD8Ev0GOHfvMWomZKm8QFB4VUKSeZbudc3hGCK5pkMh1KVdsL
Ssue8n10OmTU8pdNN5HlFXKdH4xPVu+z/KQ60xqwnAklaq7fk+ldX8L14O06wMcW
wempXIYN6frhNae+SOgM
=Qz8Q
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
