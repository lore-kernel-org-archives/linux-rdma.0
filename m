From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/ipoib: Remove unnecessary returned value check
Date: Tue, 24 Jan 2017 16:35:07 -0500
Message-ID: <1485293707.43764.88.camel@redhat.com>
References: <20170105061236.GV12077@mtr-leonro.local>
         <1483606568-17232-1-git-send-email-yanjun.zhu@oracle.com>
         <20170105125022.GA15685@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2csvCU91MlZfblYlsL9/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105125022.GA15685-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-2csvCU91MlZfblYlsL9/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-05 at 14:50 +0200, Leon Romanovsky wrote:
> On Thu, Jan 05, 2017 at 03:56:08AM -0500, Zhu Yanjun wrote:
> >=20
> > In the function ipoib_set_dev_features, the returned value is
> > always 0.
> > As such, it is not necessary to check the returned value.
> > This is not a bug. It is a trivial problem.
> >=20
> > Reviewed-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied to -next area.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-2csvCU91MlZfblYlsL9/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8iLAAoJELgmozMOVy/dYgEP/2gysSUjxjfK11RmFuKqbbWH
3mh+/Pgd1IlolcNkVX6gOyKn2qb7MlrQikJsnKBF5Ycy+inKUYxqlPmXFVNsva8h
r1BWOJMgTcS+tmhC9Yb45qaAw0K0tmFHMHBbqXAHlPi3D1kFNHgULWNpvWYxnx8p
C0Fv9epFDa4FZbaqFJ4kHJjdigtqTLZ/B3PsEnxZG3aHkGGkIflO+0LGJsplwW2j
csoqshBkbf8KzPlO3TivJTqTmlxYsQm1FNA/ik/Sf5DI37oajRuwcJIL23oEKKrz
svdJmrQJpYWt5xqWiEI/Pxx2nbLWaZGe9ye4dsUyjtqvbSWOPU5n71vSaS0igaeO
JH4tzP5BZMFB3gLNkPxT3Z+G+TQDbSUxeUawCeGftE4gyB7oTrLaKpa9Sjn1nxyY
TYaQYAo6v3A/IJPe3QXzTCaiVGktRVjXEIn4AjLnluuMCwDP0vD5NBTQU9DEHGtR
bHK8W7nP1w5Le4YcP94aIIjd5RcQEyXRqKL/p+IhJZVy59Ef/ozW2PpXXjgMFgEs
pkVX3wsHnndYEH3UYTGoWSW0FzKJO5aOgGzUMdhoZddDoJNTh1qQOr1zuN2NZfAX
nqT2vmXqxCSMlkfM9L4VA270HYq9NaBK/dct0JZt2143Wd0RZbldH3piSHuplkmd
o6DjD7H7xRQ7GgawRPNg
=I+wi
-----END PGP SIGNATURE-----

--=-2csvCU91MlZfblYlsL9/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
