From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
Date: Wed, 10 Jan 2018 15:53:34 -0500
Message-ID: <1515617614.3403.163.camel@redhat.com>
References: <1510948060.3973.29.camel@redhat.com>
         <20171119145633.07a3a715@canb.auug.org.au>
         <20180105180548.GD11972@mellanox.com>
         <20180107020124.37a7eff1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-spm2GsdiE5tX+e3I9fDU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180107020124.37a7eff1-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-spm2GsdiE5tX+e3I9fDU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2018-01-07 at 02:01 +1100, Stephen Rothwell wrote:
> Hi Jason,
>=20
> On Fri, 5 Jan 2018 11:05:48 -0700 Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
> >=20
> > On Sun, Nov 19, 2017 at 02:56:33PM +1100, Stephen Rothwell wrote:
> > > Hi Doug,
> > >=20
> > > On Fri, 17 Nov 2017 14:47:40 -0500 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote: =20
> > > >=20
> > > > Jason Gunthorpe is now co-maintaining the RDMA subsystem with me.  =
We
> > > > have a shared repo that we can both write into.  I would like you t=
o re-
> > > > aim the RDMA linux-next pull point to:
> > > >=20
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/fo=
r-
> > > > next =20
> > >=20
> > > I have updated to use this and added Jason Gunthorpe <jgg-VPRAkNaXOzXQFizaE/u3fw@public.gmane.org=
m>
> > > as a contact. =20
> >=20
> > Thanks Stephen, has been working well!
>=20
> No worries.

Hi Stephen,

Jason and I would like you to make another change if you could.  Well,
two actually.  First, we've found that now that we are both pushing to
the same tree, the use of a tag instead of a branch for your for-next
testing is dangerous.  In particular, kernel git repos have a fast-
forward requirement on all branches, so an attempted push to a branch
that has stale data from the pusher (say I just managed to push to the
branch a few minutes before Jason and Jason hasn't pulled my changes
into his branch before he decides to push his) is denied by the post
hooks.  But no such check is in place for tags, and indeed we are
allowed to wipe out tags at will.  This has already been an accident
once, and there is no sense letting it be one again, so we've changed
our workflows to compensate for this fact, and with that change, the
for-next tag will no longer be kept up to date, it will only be pushed
when we are sending a pull request, and that's too late for testing.=20
=46rom now on, the for-next branch is the canonical source going forward
for testing purposes prior to a pull request.

The second thing is we would like you to also add our for-rc branch.=20
Most of the time this will be a no-op, but we think there is some value
in making sure that -rc patches aren't going to cause future merge
problems with the for-next branch. =20

Let me know if we can do those two things.  Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-spm2GsdiE5tX+e3I9fDU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpWfU4ACgkQuCajMw5X
L92ZNA/+PxtoLw4VIQhaoeJ8YuOxucv2dSFFZv2cGEAPnypeYO4Yg0y+Bu0UIpx6
Mn/1UMJ6TCycSWl8upVaZKWw+7tBCVP3qaAsx0PyHBMRIJCUKucycvm62qCOGcZI
8I8XOi/aa1dEYncF0Xhb28qzR50GP00D2UBNvoCNjFKKcH8KG/TjCxdicuZ1EC8T
IdlgOMG981qaprmaPCC4KDqsgH6Wa8z3cNrE0LlUPiOy/AbJ8iw8QEgjzkSZvi7v
qsSmS+8R/pwaQ0CU5ok6sUntsAyH8NH9ckc5xNQkQCmu7OoYd0Z6+nfGyc5fSCQm
WcMjeQ6pDSutUJg1hhAoipXDcHWdHmKZrnGHrEcCeu97kupg7u6VXd09XXD+DAHX
GC8y6A1vhsONiVekqEQTlC0AuN1ap0Kxd2BirhPl1BjCVAdOyr9GciLy+xxAB7Gd
5wipxiCEKTRuodDBvFfaGXUiLXAcgTPmoTsG3lV/xboCzeiZW1ZQcfU6nI4kQuWF
DL5aroinQonOvOxX8UlhvJpBX4xmgbBJX2E5sYQWiJUtK8zGduZkShfFm24grSam
HWyJ1iYuKXWyxjYv2J9sV2wBn3wIuI9Z/0E4henVd93VGAkaZhQIZw+sjep10z3Q
44WlCgEaK4OC79vIdWLdhpFT1fTEVO/jt+jMGGB60WbltF+czZs=
=YWGY
-----END PGP SIGNATURE-----

--=-spm2GsdiE5tX+e3I9fDU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
