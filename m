From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 3/7] RDMA: Annotate create QP callers
Date: Wed, 17 Jan 2018 10:44:17 -0500
Message-ID: <1516203857.3403.255.camel@redhat.com>
References: <20180111153132.11143-1-leon@kernel.org>
         <20180111153132.11143-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-U4B7aLCgOzNaPS1qHi7R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111153132.11143-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-U4B7aLCgOzNaPS1qHi7R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -243,6 +243,7 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
>                 },
>                 .sq_sig_type =3D IB_SIGNAL_REQ_WR,
>                 .qp_type =3D IB_QPT_RC,
> +               .comm =3D "sec-ib",
                           ^^^
                           Typo?  Should it be smc-ib?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-U4B7aLCgOzNaPS1qHi7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfb1EACgkQuCajMw5X
L92hchAAqMVAdchfHdFR55W/Aaqopb18mp6GOJ3+L7H1CWHl7KHcHqbwyihMITLD
47mVqjuYJvM7eHLucnFAikC8TOdyMnXj3G2Hq+U/+TlyVueCE4uCf+6McGpvmrdm
44xyPfphRg7ujcIk2gtYTPmOexiwWpdh679n2BN7bB6VMiFwYX6JP9WXHGMJyfyJ
wsxjhL6iBwsd51BsNR/Xt5RbO+z80K6qm8wm6qU4Q9d5qj1SBDUO9X/Dxyih7O+k
AHB/ln2PcLDipyp4aCVmpeIV7RJ8TzMPpEYP4BsPuxOdI/Q5+/aASuaiOnHg5CKt
P4vSJ8qQgqxzswZrrrj16LsmWtU+HsIUEk6Shm2SJmyxaAEALph9Af0CaEP67M1q
3eoQAbJubkluOAGuQoGYU6qUo1tEQq6zhP80FtD2WTEFoDEFlz5dQbmjfof2b3BY
gFeq9yYGZt3QkD3c7RCJqx86Jr4LxxdYVabo5wyUCKs2vQAYT5ddlvE2amrC4hgr
bpFh4GvpJD7gretNN1utJ+Hc5mGboPVpZSRxpMXUZ1og/WGSsnkf4tA/f0BJKulI
HKviQoljdKsvI+Z0BdhU32DBxkuXAQUim1Vy1O9lmkKuyOVCusbffPRSLpSaCIwx
rpEh50Biqhv62ShCo6dhzPYFptaueAhwKZtb4y1mikAFhq+8G7k=
=o3me
-----END PGP SIGNATURE-----

--=-U4B7aLCgOzNaPS1qHi7R--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
