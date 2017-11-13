From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] RDMA/core: Make function rdma_copy_addr return void
Date: Mon, 13 Nov 2017 16:19:42 -0500
Message-ID: <1510607982.3735.40.camel@redhat.com>
References: <20171107084909.6561-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZUOmQ1MsIvqS9MCvdQk5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107084909.6561-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ZUOmQ1MsIvqS9MCvdQk5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-11-07 at 10:49 +0200, Yuval Shaia wrote:
> Function returns zero - make it void.
>=20
> While there make struct net_device const.
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ZUOmQ1MsIvqS9MCvdQk5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKDG4ACgkQuCajMw5X
L90gRxAAhrjsZxguL/ZcO3cwjws3PmcnTXi68mkzzKAQN0XmXEwIR36s1KrboMUb
boxbrK2fc7ZK/qFX7rbuxKmrAy77OqDUNg+MvB/LecOCRVzrRA4wTxt5CinvrHWI
FU9nVT4f5NvTm5ZvB31tUBSLWj7vTdF7jLPN69wciJq6nZMpDVkvWvOGT2EyI899
fOYOi1labVjUPT2YJyzPq5zoo7kJFdXNL28e6C8fFCFxL+4yCGfVnAwW+fGfBues
S0j7BTNBbBHFDlOtcgSL01CH7E7k3uxM5y0qpzIin/vShDyBrJSL07vh7Ocs7pX5
GNSkOneaRPJLoBcP5JNDQbz9e+UZvgXhRnXBvXJUJfUZ2FC46pJE7gVScSn+8cau
j1bddyWFHEKXozjSfFcsIASdnwEXfTmbL4c7AfdvG8ujdlyXafYWd7xxx1WYf40t
i9WgVswa6WScJ/DNImnpb16r5RKBEGdcsKx7y5g0ZgEsPS+VMroH4DhIhzuJ6hoD
SuHwaF69SseN8N0ZEa0Zficpt9uMXf9VwsqHTtCOBX76UOT7GScxJHUWJ7BqAslJ
8Iolux0gomB4eGwvwZqZ3B8KLso50dPeKznfDMsxcYKJf0/tGN1HN6ulfjo4FbO2
7OFnN4Am031c8grdalgM0SJKKaeTEgoBfk9seC5PwQ1ZvT7ZVIM=
=l0KJ
-----END PGP SIGNATURE-----

--=-ZUOmQ1MsIvqS9MCvdQk5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
