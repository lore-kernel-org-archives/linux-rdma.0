From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Remove a set-but-not-used variable from
 ib_sg_to_pages()
Date: Tue, 19 Jan 2016 16:15:50 -0500
Message-ID: <569EA786.60302@redhat.com>
References: <5682561F.7000400@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="j7KbVt2TGG1UfLoR7NkiagHDuhcfgNknl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5682561F.7000400-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j7KbVt2TGG1UfLoR7NkiagHDuhcfgNknl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/29/2015 04:45 AM, Bart Van Assche wrote:
> Detected this by building the IB core with W=3D1. See also patch
> "IB core: Fix ib_sg_to_pages()" (commit 8f5ba10ed40a).
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/=
verbs.c
> index 545906d..c90ed29 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1530,7 +1530,7 @@ int ib_sg_to_pages(struct ib_mr *mr,
>  		   int (*set_page)(struct ib_mr *, u64))
>  {
>  	struct scatterlist *sg;
> -	u64 last_end_dma_addr =3D 0, last_page_addr =3D 0;
> +	u64 last_end_dma_addr =3D 0;
>  	unsigned int last_page_off =3D 0;
>  	u64 page_mask =3D ~((u64)mr->page_size - 1);
>  	int i, ret;
> @@ -1572,7 +1572,6 @@ next_page:
> =20
>  		mr->length +=3D dma_len;
>  		last_end_dma_addr =3D end_dma_addr;
> -		last_page_addr =3D end_dma_addr & page_mask;
>  		last_page_off =3D end_dma_addr & ~page_mask;
>  	}
> =20
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--j7KbVt2TGG1UfLoR7NkiagHDuhcfgNknl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqeGAAoJELgmozMOVy/d/qsQAMTEoMy49RMScf/+WnnWY3HW
YuIKaEtJKy0vCW1uKMrVpQRGRcfOcazlxS69AigFgobfMunSRZmnkZO9ECrv6Va3
iZBjKYT0eFVFuAh9HZ9zpIsp+lqa2ofpd9628kT5xqqbfMQuW21gYdsBy9fPA/7k
XyicQPk7VNNkZXWJhYiqBNmDSz7fr7Ak0YWq6tcfH8vjtgXtRKuzJeES8WA+eTmc
agEoGGljJa0fNaywZqzwy04K05HcGFe2AkEpxeFNMHNaeRRyMghPqRRq9wmlt/T0
FtpueJbFmcZAc9of0OYmpqs5SlIbxkYR4q78lQtbSlMM/ajGBPvDuMDuRA1TQxCt
3ot+Q8l62fx//iW0yOKJyVDMdlwRoZwZXscoo1/7VFh5KWU2/xMwTS6e9yYeKmmg
1WctRVOUfvgAC2tHotf4vOx3ygRd9TlzABss5RD9RgMGXs5YyblAdAMwyMP/sl51
OhItXqEXr4bglwYzgbPFwMm6HQJMf98lViQW3ZD1jlarKapUqYoBcJZeA3/bw484
M29W9IFSUP/SHEczCb+EvBTgaoL+vlerTJQ8HHVcz3LC4WpCGlXBNUvAsScgZh+/
eGXErh/kQrXv3UtoZCeStaL+szE01TgxOu2D6KALapOsgesa7ZX4WT5rgXdKPjZD
EasQAijgv3n57VEQl2Vv
=hjdk
-----END PGP SIGNATURE-----

--j7KbVt2TGG1UfLoR7NkiagHDuhcfgNknl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
