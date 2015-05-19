From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Tue, 19 May 2015 11:36:44 -0400
Message-ID: <1432049804.3114.41.camel@redhat.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
	 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
	 <1432044878.5304.1.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-y+2IMGDzs2/oQFwsZTKs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432044878.5304.1.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-y+2IMGDzs2/oQFwsZTKs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 16:14 +0200, Yann Droneaud wrote:
> Hi Jeff,
>=20
> Le mardi 19 mai 2015 =C3=A0 14:11 +0000, Jeff Squyres (jsquyres) a =C3=A9=
crit :
> > Doug --
> >=20
> > The feedback on this patch seems to have converged.  What's the=20
> > process for getting this accepted into libibverbs (and rolling a new=
=20
> > libibverbs release)?
> >=20
> >=20
>=20
> Is Doug the maintainer of the userspace library ?

Libibverbs and the kernel verbs interface are very closely tied, so I
did ask Roland if he was OK with me taking over that as well.  It would
make it easier to keep the two in sync.  Roland was fine with that.  If
anyone has any objections, please speak now.

>=20
> > > On May 12, 2015, at 10:14 AM, Jeff Squyres (jsquyres) <
> > > jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> > >=20
> > > It's not a warning or an error if libibverbs cannot find a=20
> > > userspace
> > > driver for kernel devices.  Indeed, returning a num_devices of is
> > > sufficient -- the middleware shouldn't be unconditionally printing=
=20
> > > out
> > > stderr message; let the upper layer application do that (if it=20
> > > wants
> > > to).
> > >=20
> > > For debugging purposes, if the environment variable=20
> > > IBV_SHOW_WARNINGS
> > > is set (to any value), warnings will be emitted to stderr if a
> > > corresponding userspace driver cannot be found for a kernel device.
> > >=20
> > > Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> > > ---
> > > man/ibv_get_device_list.3 | 6 ++++++
> > > src/init.c                | 2 +-
> > > 2 files changed, 7 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/man/ibv_get_device_list.3 b/man/ibv_get_device_list.3
> > > index 16cc1a0..96de554 100644
> > > --- a/man/ibv_get_device_list.3
> > > +++ b/man/ibv_get_device_list.3
> > > @@ -50,6 +50,12 @@ Client code should open all the devices it=20
> > > intends to use with
> > > Once it frees the array with
> > > .B ibv_free_device_list()\fR,
> > > it will be able to use only the open devices; pointers to unopened=
=20
> > > devices will no longer be valid.
> > > +.P
> > > +Setting the environment variable
> > > +.BR IBV_SHOW_WARNINGS
> > > +will cause warnings to be emitted to stderr if a kernel verbs=20
> > > device
> > > +is discovered, but no corresponding userspace driver can be found=
=20
> > > for
> > > +it.
> > > .SH "SEE ALSO"
> > > .BR ibv_fork_init (3),
> > > .BR ibv_get_device_name (3),
> > > diff --git a/src/init.c b/src/init.c
> > > index d0e4b1c..dbdd795 100644
> > > --- a/src/init.c
> > > +++ b/src/init.c
> > > @@ -561,7 +561,7 @@ out:
> > >                  next_dev =3D sysfs_dev ? sysfs_dev->next :=20
> > > NULL;
> > >          sysfs_dev;
> > >          sysfs_dev =3D next_dev, next_dev =3D sysfs_dev ?=20
> > > sysfs_dev->next : NULL) {
> > > -           if (!sysfs_dev->have_driver) {
> > > +           if (!sysfs_dev->have_driver &&=20
> > > getenv("IBV_SHOW_WARNINGS")) {
> > >                     fprintf(stderr, PFX "Warning: no userspace=20
> > > device-specific "
> > >                             "driver found for %s\n", sysfs_dev
> > > ->sysfs_path);
> > >                     if (statically_linked)
> > > --=20
> > > 2.2.1
> > >=20
> >=20
> >=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-y+2IMGDzs2/oQFwsZTKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVW1iMAAoJELgmozMOVy/dO5oQAKiOaLLTtf52Bt/E+/9SasFG
i6ZaKbwQST1I8O4AslVElxhd5ASkxxJEmk3J9HSjf87RPieM7+rYOtC9TN4icZm1
CrP0jm4kgrlATbM6ciQQcK5Td3vI3wDKqSFHsVRRJOldHxIDNiDUzC0vkiT+/hYI
P0jkLUaftySCe7RJwCOeSCp9slX2qouXutAagURPJcz6dsP+23QSBcDZUL6LS8J8
fA4936rrwOi4mUUnYkuK7SvvbMedDEmxzu2XPdZHPGQ7aRJu9FQfzXHk0nQ7YaTv
ZRmiSpp8Vty24qN4vrtr3ie2K32DGgae+qmFy8251gkj/G2d/t+cM6PmMfPWx6Lz
pODC3WvM+MhXSxSi4la3BsPmX9izHZ15Ea4TTqfwHyDyp9gofoCzWBcsSrijdDCC
1OX+vjRa9SX5fLoy4Pc6m3XQ1CBB5mhv4LBSOy2nmJgFDwnXiWu//kYmiZwpO3JJ
A5H0hW5dee7tGR4NluhROgh6kUDyHaVlDh7evMT42mb63mUydA490+QwBbgWd+El
UR6+3ESuu02Ow3NGJ1kcC8O7vt57SxhWoCj/oCz/296WcUAvFyA83ylwJ1COSD/Q
8Zn381F85St1IQJK0Ph4JAcgB+1jrP5m6WW5X/2cgU8clf4Os+YYeiYjhaeQ17C8
yuQ9pYmJXGi4m3/bz66z
=PV+U
-----END PGP SIGNATURE-----

--=-y+2IMGDzs2/oQFwsZTKs--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
