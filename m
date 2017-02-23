From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 23 Feb 2017 12:43:29 -0500
Message-ID: <1487871809.86943.136.camel@redhat.com>
References: <1487796701.86943.126.camel@redhat.com>
         <CA+55aFz6mZUHonfz3qtq17MJNcO+m4m4qspuZzhBG8wPi8Azjg@mail.gmail.com>
         <CA+55aFyS3P70r4y53gYYr7OPf1rwaR0EJOpvMDZ3LQ=3XHCbqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mdwXQNcwwfn5k18rNp3q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyS3P70r4y53gYYr7OPf1rwaR0EJOpvMDZ3LQ=3XHCbqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-mdwXQNcwwfn5k18rNp3q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-02-23 at 08:39 -0800, Linus Torvalds wrote:
> On Thu, Feb 23, 2017 at 8:33 AM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >=20
> >=20
> > Do you have pointers to the actual diff?
>=20
> Ok, I found them.

Not sure which you found, mailing list archive or other. =C2=A0But they are
also in my git repo on the k.o/for-4.11-dma_ops branch.

> >=20
> > That doesn't sound very
> > tree-wide, it sounds limited to just rdma, and as such shouldn't
> > impact anybody else.
>=20
> Ok, it's somewhat tree-wide, but doesn't look all that conflicting to
> me. I'd rather have those patches early than late.

I'll get those to you tomorrow then. =C2=A0I pulled these patches on Jan 20=
,
and as a result of being in their own branch and not in my for-next
area (as per some guidance I received on how to handle these since they
are at least lightly tree-wide), they have developed some merge
conflicts. =C2=A0It will be cleaner if I send the Mellanox pull request nex=
t
so you can process it while I fix up those 3 issues tonight (I have to
run to an appt soon).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-mdwXQNcwwfn5k18rNp3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYrx9BAAoJELgmozMOVy/dqkUP/iY78qrJK7dUZhI8BkVa0BpG
uE4BJ/vyTRTC2p2ZPXbTxBAzdvhcEwiwpnd4t6/YyuAmyJIJxUPFFJGDlfeYZiIb
nykdAvOnJPapDbZ9q+nanSVwu/7qN0fswFk09bGP5+inoAz5YIcf1P+CPne+9dx5
kOzfe3HduwuxSoWPFm+ZfjOtT9wtj3vkC7Z0oAQxj32bteHZHw6OM7ccwi9Y0fGc
qfj393Vs3M6c+9xs2vzb6kus4wRNypLm1eXb5fnF7tiE53jADOb4x3lQ0Boftg1i
FuY0MKThN2tEazCHca3ogrY+7xMUrL/dDknlrMlTbqJ5k+ajOscVffstd96SKoUS
MDcRjHGxiKa5TdbN4PDAWSAmerD0w5gKNDgmoJI4Bk+cNfEI/QeYP6PWW8sMHjdL
Ions4ueaqYV1eC55SszvI62zda0C4CrpHXfOLqPdTI5SIo1vVXytcKL1nDUZl+XE
fc/E26zZSHrsNUDAFaXPNZug5SlCabvf3r3BdSqI4s76N3ancdHk2cKnWfGNsRtj
8sCDcY/wLoPnOGXuoa61DL5UnEU86N5pJwxTQeHS9+KILF7U7qiuTCWGl1W0FEIj
7ayX3TURDZtp2QwJIND+YSI4NE/te11bFhiURyRzf4KhOvk6VyVdhHdhjZzXF0U+
ZimJMwRLnFOOGDjuT+p0
=klf4
-----END PGP SIGNATURE-----

--=-mdwXQNcwwfn5k18rNp3q--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
