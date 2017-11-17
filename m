From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Fri, 17 Nov 2017 14:45:01 -0500
Message-ID: <1510947901.3973.26.camel@redhat.com>
References: <20171116204400.GA28216@mellanox.com>
         <1510941272.2846.46.camel@wdc.com> <20171117181410.GL4276@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ShSh+y8qVKN6iykEV0WJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171117181410.GL4276-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ShSh+y8qVKN6iykEV0WJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-17 at 11:14 -0700, Jason Gunthorpe wrote:
> On Fri, Nov 17, 2017 at 05:54:34PM +0000, Bart Van Assche wrote:
> >=20
> > * If you send an e-mail to Wu Fengguang then he will add a branch from =
your
> >   repository to his zero-day testing. This is a great way to catch buil=
d
> >   failures before linux-next catches these.
>=20
> Thanks

On that point...I have my github repo tied into the 0day infrastructure,
not the official repo.  I do that because I've publicly announced that
my github repo is a WIP repo, and that it might be rebased.  That allows
me to correct build issues by fixing up the broken patch and thereby
keep bisectability at its highest.  If you use a branch/tag on k.o for
your 0day testing, then fixes have to be incremental and depending on
which patch broke the build, there might be a significant segment of
code that is no longer bisectable.

> > * Any patches that will be sent to Linus must have been in the for-next
> >   repository for at least a few days. Requests to add a branch to linux=
-next
> >   should be sent to Stephen Rothwell with linux-next in Cc.
>=20
> Doug will send Stephen Rothwell a note to move his for-next pull for
> RDMA from Doug's personal directory to:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
>=20
> Branch k.o/for-next

Actually, the linux-next testing uses a tag instead of a branch.  That
allows for oddball scenarios that you might want to get testing.  Say,
for instance, that you have a for-next branch with most of your stuff,
but you also have a separate branch that simply isn't ready to be pushed
yet, but you still want to get some early merge analysis, then you
create a throwaway branch, merge your for-next and this topic branch
together, throw the for-next tag on it for a couple or three days, and
if Stephen doesn't find anything, you're on the right path with your
development code.  Then you just reset the tag prior to pushing to
Linus.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ShSh+y8qVKN6iykEV0WJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloPPD0ACgkQuCajMw5X
L92NcA//cSulaaEc9ZCUup/lekNXmidiyIHVyXieCe22ZXDp8/WCMtgq6LGX0/Eq
PAPahbhXq+eFDAg/pehoaPB9MUBoEGx4apo6RFh4fSU3YNvF1h33gmHpi+x6BSoY
LVAkOHSgvl7RGxU6xNo61vX2BLy/BTsPrmGTAiZGLmx0rwK6VdPvOA22kKWG8psp
GA1Zyzij4SHUDkC+dT9p2aIIETe822UIt6FK4Zxzf086YWZOOS+BcTcq7Hi9uemZ
L2QUeXlFfktoiu+0D/fx0bT49I/kyrLzYnw8vO31J18kCeKdbEVZM4rLDP/kZGz+
hQe2TA5zxn+yHUfBbhEp5G8+W579UJnoK6BrvvwaoNDHJYVqF6IuEnEVEsU3Mn8j
f4GXmbHKeirDIviZS2BvPVhI368vTOpcWdMxwdw5Rf1rfNtgfi+LjurjpTTG8AP2
zR3nm7sAUaN2Rm67bRvlEJfa1C/F7FolfDzrv8XwD8O9epcEMCMtP9AA02dF6jWG
VHkUQgTD6RcYGtwIJTkRY9mi/lEacto6j17CJLcqHqFsqqQthyDXuXHY+k+V/H4W
rKctuViTrf2h4NmC3UzLMqzMzxQoaYSE6ZvV6G5HaUz3eByLC/fhn58M4DPynP8Z
/j73PWQQ1uejm4wQBqnh/0CHGwtSniXXZ1HbS6FXjVsucdYtRFY=
=Yb0n
-----END PGP SIGNATURE-----

--=-ShSh+y8qVKN6iykEV0WJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
