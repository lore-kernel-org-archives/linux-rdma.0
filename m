From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: cxgb4: Use AF_INET for sin_family field
Date: Thu, 12 Jan 2017 12:11:37 -0500
Message-ID: <1484241097.123135.12.camel@redhat.com>
References: <1482543875-17141-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YtfNsvY/qkspbwqQVtva"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482543875-17141-1-git-send-email-mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-YtfNsvY/qkspbwqQVtva
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-12-24 at 07:14 +0530, Shyam Saini wrote:
> Elsewhere the sin_family field holds a value with a name of the form
> AF_..., so it seems reasonable to do so here as well.=C2=A0 Also the
> values
> of PF_INET and AF_INET are the same.
>=20
> The semantic patch that makes this change is as follows:
>=20
> //</smpl>
> @@
> struct sockaddr_in sip;
> @@
>=20
> (
> sip.sin_family =3D=3D
> - PF_INET
> + AF_INET
> |
> sip.sin_family !=3D
> - PF_INET
> + AF_INET
> |
> sip.sin_family =3D
> - PF_INET
> + AF_INET
> )
> //</smpl>
>=20
> Signed-off-by: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-YtfNsvY/qkspbwqQVtva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7jJAAoJELgmozMOVy/dUcoP/3vzUrHOezkR+fKYL56wi37A
5qE0CwPdXpn+sYLop3pOtSLgGYEdnwj6rNzHP95z3kEs0H9hyZp+N8lSKM0fa/8s
yfABg1jOmpIEZYO1/xqWPBIlgRW5LTG7Q6mo9wsUmjCHI/2kLXiBIdMwmMmMy8yx
QNgc9YUlLQhI8fhkJ1CZ1AmpxkZpnY9wgWPu+QENRlZjhcPSZRq+FqCFhaZiEu4L
GpRQHNYPgolKyr1Hvqg6chtd2T18iJBT4gG6gBtrKSB7bdFDgJexc+m7orU2jDYj
jnEu8eit3TsU3Q/Mpbqyahj9jIaASHSyfM4PRXgs6nIShWfR/7lRzpLsXZbpAPpA
PBvslx7ppmvM4xHz68xL0f2MbS4f+sR/C5rKl74CispmN9tzIOP4snWt+4PxJM3R
PulsqCMfvkZbTEMbLySiW9hghV3FYpJljG7n/x0Ouh2BbmA6W7cZZh2PaK0odOH7
PZBe6BDUyCsaGoOhWcDzDTdzDwbmcvG7i5b/1+u9DD+0zb/hYRZJCxM++phLI7ou
qPlpWgQjEnjsrNC4s1cD1ErIZzbtAAnuszlRrXBjQIWr9Xp0DozkLLlY9uSx39gi
bQGeOTjhQD6NSFWVSzRfyRk1xyciIBs3XQuJ/U4mkvvRsRBIfaERvyEc/jox/WvW
zzj0kGz3OnO142/zFBMb
=8QZL
-----END PGP SIGNATURE-----

--=-YtfNsvY/qkspbwqQVtva--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
