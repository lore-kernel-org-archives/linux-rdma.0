From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] IB/core: Do not allocate more memory than required for
 cma_configfs
Date: Tue, 19 Jan 2016 16:14:24 -0500
Message-ID: <569EA730.2020205@redhat.com>
References: <1451551743-26042-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3h5tgNW3nw1KOAjXnutU234CCOlf1rSe2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451551743-26042-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3h5tgNW3nw1KOAjXnutU234CCOlf1rSe2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/31/2015 03:49 AM, Matan Barak wrote:
> We were allocating larger memory space than required for
> cma_dev_group->default_ports_group.
>=20
> Fixes: 045959db65c6 ('IB/cma: Add configfs for rdma_cm')
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
>=20
> This patch fixes a small issue, where we allocated more space than we
> actually needed. This was introduces in the RoCE v2 series.
>=20
> Regards,
> Matan
>=20
> Changes from V0:
>  - Change subject and fix spelling mistake in commit message
>=20
>  drivers/infiniband/core/cma_configfs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniban=
d/core/cma_configfs.c
> index bd1d640..ab554df 100644
> --- a/drivers/infiniband/core/cma_configfs.c
> +++ b/drivers/infiniband/core/cma_configfs.c
> @@ -169,9 +169,10 @@ static int make_cma_ports(struct cma_dev_group *cm=
a_dev_group,
>  	ports =3D kcalloc(ports_num, sizeof(*cma_dev_group->ports),
>  			GFP_KERNEL);
> =20
> -	cma_dev_group->default_ports_group =3D kcalloc(ports_num + 1,
> -						     sizeof(*cma_dev_group->ports),
> -						     GFP_KERNEL);
> +	cma_dev_group->default_ports_group =3D
> +		kcalloc(ports_num + 1,
> +			sizeof(*cma_dev_group->default_ports_group),
> +			GFP_KERNEL);
> =20
>  	if (!ports || !cma_dev_group->default_ports_group) {
>  		err =3D -ENOMEM;
>=20

Hi Matan, as I'm sure you saw, I grabbed Dan's patch for this.  I didn't
choose either one over the other, I just ran across his in patchworks
first as I was looking for all of the code I needed to review.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3h5tgNW3nw1KOAjXnutU234CCOlf1rSe2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqcwAAoJELgmozMOVy/dnAwP/R1RmJ8Ygil18X5X6lTwLhnt
wc4N+9/ZlS+/PoINBSki8HPtVaSyOFiAoTprcPwCgPQ2+SOsxSt5F2nWNAKJda9H
7syEdfeIUI8vOfjIfxfKROId7GSWtvFwPb+lYAjA4cpFmwMc29qlkSX3hbeJ58ZX
fjGbFe+2J/4jbWdAzE4iLITYefwhTX+Dv5STxIRiqleBwdHv/giVqzOPB+SKH8J7
LmTgpmdmBs3Ckm4iZdo1h+h7WAX/LKHNM2jPQ2i+GUFi/Z8yTx6SnHnAflOeVTI5
dPsiJ8wHYVG2NzQot5rLIf2ThsL1CdHI42sVBJiddNgrJt2K6IdTQoZlShovG11i
7obszHoJMMT9GrzZ+AnV+I0Z1W9MXDajWebMwz+RVYsHALTGH9ivRWTea9OEWhMG
DmMZw2oEGZvcILXlvdF6oP42uONnT4B/66gQKDwqlpZheDNMQznWnFvF9cQEt9uU
kZJzOQUcr7wqFPhjVEk3iQcKd+0VgkJSSsxV8axiaeKwenV9kvAf/2Aeojp891jG
ahLuO4Fc82qKc8/QuPLUiCxZQODec4rHKmVCp40Dof1MSLl+at5oxOtAtSyQYiUk
DeIAUE9Eu5rjeL6Vi7CNWyWoOEuGqvmo1bDZlY6TAJjbaCMcKiAyZMX+cO2R0lWd
7x4OMhloYKHz5olv5t0D
=68RX
-----END PGP SIGNATURE-----

--3h5tgNW3nw1KOAjXnutU234CCOlf1rSe2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
