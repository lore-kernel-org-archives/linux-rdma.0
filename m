From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Wed, 20 May 2015 13:11:10 -0400
Message-ID: <1432141870.3114.89.camel@redhat.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
	 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
	 <1432044878.5304.1.camel@opteya.com> <1432049804.3114.41.camel@redhat.com>
	 <1432133301.5304.10.camel@opteya.com> <1432139226.3114.83.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDD9BC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-sXUPz2Zeb5/tFs4S1kOw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDD9BC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-sXUPz2Zeb5/tFs4S1kOw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-20 at 16:39 +0000, Hefty, Sean wrote:
> > As I mentioned, I think there is a pretty strong tie between the kernel
> > stack the libibverbs.  Especially when you consider that things like
> > verbs extensions need to be synced between the two.  That's why I'm
> > offering/suggesting that it would be a good idea that I handle it along
> > with the kernel.
>=20
> Where is your upstream libibverbs tree?  Or do you have one yet?  And whe=
re can the latest packages (e.g. 1.1.8) be found?

The location of the upstream sources and tarballs would not change.
Neither the git repo nor the tarball repo were like the kernel.  The
upstream kernel.org git repo Roland had, had his name in the repo.  So
it had to change.  But the libibverbs repo is in a generic location.
There is no need to change it, only to change the permissions on the git
repo to allow the new maintainer to push directly into it.  Ditto with
the upload/download space on openfabrics.org/downloads/verbs.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-sXUPz2Zeb5/tFs4S1kOw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXMAuAAoJELgmozMOVy/djM0P/1ZC2eF8r21bRuXLulq7iyuu
NBEgStKhXic8U7xLIUaxJ0pqSJiTQGwYo+CWhdLrEUSlILMpI/doRkjZWkvyPOfr
jZOnyqaE6SrD2JXyjwucLJunnxHUftBNz5fbnwr1zXcWZNKJLG565ZkywaPr+HwG
M+Z4r0DSnbXEmbD1h5bgaHRlv0e5cEvwlcnkYVjXWSkQH22gR1QR9K721Z9jM24I
keOc7bzCNp3divoGBVYdS8u79z+loQv912ZtOD63sjEJyGKSAA6lCubqnyimSjex
gyQxVM85MPF94pYYsmF8I2US6IRFe1gQe9X4gDZDKHj6zb0VibFFjt5G9LBLqtV7
W/jgxR8D9h1vLedfDexB1lt17UB7T1JzvgPjnQlyOdc8VobFn15kdT1n49qJEg0k
3xbpwD4PBnVAy9cx3BpfI+Qp3YwJRuPCkKp+saUHijGY8TSQyBFO28PQAcmGPbNy
dBn2ZLHqd9es/NI+55YmI3fEdk/mf1RzP5MZMMwOv8k6WF72Rl3ToXqlmQ36F9sz
OdnW+5TWD11R4fxF9ERWCMDTbj5Icg5vr7inOhmoEt4lxhpwo2h4gzZbImn/N714
wjHHaHuEUCjFKqs4TBgdw16Nv91JjVO5LTFHFGWodoOdeCcv02Lmqo0H3EOVS9Kz
vaWzs8y+cP+U7c/1aWyX
=9/bT
-----END PGP SIGNATURE-----

--=-sXUPz2Zeb5/tFs4S1kOw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
