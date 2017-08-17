From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/bnxt_re: Fix return value check for
 ib_get_eth_speed()
Date: Thu, 17 Aug 2017 16:12:13 +0300
Message-ID: <20170817131213.GG23648@mtr-leonro.local>
References: <1502970504-30010-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502970504-30010-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 17, 2017 at 04:48:24AM -0700, Selvin Xavier wrote:
> ib_get_eth_speed() return 0 on success. Fixing the condition checking
> and prevent reporting failure for query_port verb.
>
> Fixes: d41861942fc5 (Add generic function to extract IB speed from netdev)

There is need to put quotes (" or ')over commit title;
Fixes: d41861942fc5 ("Add generic function to extract IB speed from netdev")

> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
Please fix usnic too, it has the same issue.

Thanks,

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmVlisACgkQ5GN7iDZy
WKfXOQ//eE+p6kvAXt6i7rxCkDTd82zwkVKhX+O4WfOZB92I+CzvKh7F9emVDMHW
tZ84mR2XZMmG23nEQ1j5/3C3/D1lEAN4Zp6tIBWtNBQEy9HQvQJ2p3evYYHnJXNp
zrVjcfwUOVOOjE58maD5l2X+xgHEKrtrII6e9NAo/Fz4L23g81Utjxth8E503Ft2
UaVRPsFvQ0uzeXh2wpz3MQQlLglben7M9u2E2L0ji8fe0do4hIUPQ39CgKSvje0k
ho/mGY+L42NUJI2IrwfCBkAkPX6Nxxnon4RotglzQhPsmYx7pLXZv8nVAK+QGBj7
NimCS2YGZLDZprSY0l2rY1uM6waBF3IVw61/9EbIueXli633fbAPJ8M5jfw6TqXf
pYW5SzteYlC2lqJaf83GJoQCXcYbuywTJOKRF6B7i8tFtVSbWTxac3+8s/WhRV8o
sECPv2J25Qdih+JeC2SqM6qiBAqHYiQK6Y9jUtybCPTCipbLdkdtb1iWAklDruS8
hGLYmreeuW1EFp09U4hLFDYei+HwMC38bk/DVcUkuEXCIF3zg3NnkOUO3GgtjNjR
fsXcV9Vai5WjLwK9PoDaCt0c5Bwqwv8jvUvpr8oWehqb5BrMIYh1lMXssABbpZbc
MEryu66kTfJSQLCI5rbD7NUNtynv7WM2OIb68tlP+QvUZzvup5o=
=kkdN
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
