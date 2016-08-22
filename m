From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: Fix Soft RoCE location
Date: Mon, 22 Aug 2016 14:38:04 -0400
Message-ID: <e62c981a-7d8b-b5bc-129f-4e522157489d@redhat.com>
References: <1471339786-4618-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PpRO33P9wNQd0p5vOpO4DJ6F8aIsMtxO0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471339786-4618-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PpRO33P9wNQd0p5vOpO4DJ6F8aIsMtxO0
Content-Type: multipart/mixed; boundary="lgwlcTC423u6VoLP1F3JTMjDaPTlR2msp"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <e62c981a-7d8b-b5bc-129f-4e522157489d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: Fix Soft RoCE location
References: <1471339786-4618-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1471339786-4618-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--lgwlcTC423u6VoLP1F3JTMjDaPTlR2msp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/16/2016 5:29 AM, Leon Romanovsky wrote:
> The Soft RoCE (rxe) is located in drivers/inifiniband/sw
> and not in drivers/infiniband/hw/.
>=20
> This patch fixes it.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a306795..119edf4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7655,7 +7655,7 @@ L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  S:	Supported
>  W:	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
>  Q:	http://patchwork.kernel.org/project/linux-rdma/list/
> -F:	drivers/infiniband/hw/rxe/
> +F:	drivers/infiniband/sw/rxe/
>  F:	include/uapi/rdma/rdma_user_rxe.h
> =20
>  MEMBARRIER SUPPORT
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--lgwlcTC423u6VoLP1F3JTMjDaPTlR2msp--

--PpRO33P9wNQd0p5vOpO4DJ6F8aIsMtxO0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0aMAAoJELgmozMOVy/dTxcQAIHq5GAxu0XmITQV54XoPbgt
y0RYPeAntWkcVMEiSeo7EHjsQZwaFus3MJUtRo2qNM/dmLOPwD0jvCqMUOZ5/yt5
SVsBCHvWTqSrn4W/O56KVeX0S+XbNlhn9gZWXuRldXxFYLXAZ9TUdR+BQt2rYVCn
ABsjoF0LTGqY6ZQjFT3aVnmJg3t2iQJ6ZYm8qINd4rS10zeoWaytxMd1IAB+FSq+
IfNYUBIsqNmcAhkCbJtjBr1Ry+sV3nQYhCx3CItVJI89yElrXdgxlIdqT+UlHux1
kjmpk3dZNZBDjq4DvIQ4p9yBhF46lFeviQZ3x9NOoyzaO/wpWJ1GQDtdZumM2xW2
3QrJx4vqmkPnaIycOVnMFhNwMyuqdRbs3Jls28X1V0DttU2jweWT7KKqXk26n/lf
5W8EKpsNCEpFgH6nBynGrU2mp9qz4ZCsuPyMVw3O4094MAaKxODvo3gDDZdI1LoB
NWqgMUDeuRWzkE6E7bT+7GUcTDSmzfCXeIBiNZhld/lNz1R0s9emezDebpIAVwRF
y9ymfjc998+k552/OMXQp4PVIxmU422nEVO9TIZ+iNVRNCHatSDlYfD+Ot8fYxoH
lwk9ynJhcr9naNyHm1fzca3ONDTpRL1/He9Jaz4NJh674NZUcBpeZNoJoWoNNOVz
THbHobHO+N54JEUggTya
=ARE1
-----END PGP SIGNATURE-----

--PpRO33P9wNQd0p5vOpO4DJ6F8aIsMtxO0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
