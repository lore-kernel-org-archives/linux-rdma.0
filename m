From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Sun, 22 May 2016 20:57:15 +0300
Message-ID: <20160522175715.GD25500@leon.nu>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
 <20160519122622.22041.41686.stgit@scvm10.sc.intel.com>
 <20160521123404.GB25500@leon.nu>
 <20160521162301.GA16770@phlsvsds.ph.intel.com>
 <20160522120129.GC25500@leon.nu>
 <20160522140351.GA10696@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160522140351.GA10696-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 22, 2016 at 10:03:52AM -0400, Dennis Dalessandro wrote:
> On Sun, May 22, 2016 at 03:01:29PM +0300, Leon Romanovsky wrote:
> >>>I think the overall consensus over participants in OFVWG call was to u=
se
> >>>one IOCTL to enter into device specific handler which will do all
> >>>necessary parsing and not spamming common IOCTL interface.
> >>
> >>That was for the verbs working group and the verbs 2.0 uAPI. This is for
> >>psm.
> >
> >I'm glad that you are supporting my point.
> >It is vendor specific implementation for vendor specific driver and not
> >for whole IB core, so there is no need to pollute general IB ioctls.
>=20
> It is making use of and applying a proper classification.  Is there a
> technical concern with this other than that's not how verbs may end up do=
ing
> it?
>=20
> I'm not completely opposed to the single ioctl, I just don't necessarily =
see
> that as better in this case but am willing to listen to a technical
> justification for why it's incorrect.

it will simplify internal and external development by removing the
tensions over ioctls numbers. Do you plan to take the block of ioctls
for future expansion? Do you plan to mix hfi's ioctls with verbs's ioctls
based on acceptance of new code?

>=20
> >>In the interim, while the OFVWG is solidifying its one API to rule them
> >>all,
> >>this solves our current and very specific problem of treating
> >>write()/writev() differently.
> >
> >OFVWG is working on improving current verbs interface, for proprietary t=
hings like this,
> >there is agreed API which will look similar to this:
>=20
> As far as I know there has been no patches posted or real on-list review =
of
> this API as of yet.

Right.

>=20
> -Denny

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXQfL7AAoJEORje4g2clin5PQP/0nmTB4m+X3zIy7pcWGqF6cP
9rpsB9eE95joV827WUO0Lc6xUYtNrZTJlWAyDPPf+uM1p3kNbHKaUWQifflRkilf
geUfxkWF1n9tiNTLtZo2m9/+6B+530brINrplXe9MngYkPrBBnj++JY7X2AfRGBe
bfnjG/30ZBas2V1WwM7dgoZtvZxiKtrBfwd1bjpAdZFOHJrh6LNPWjqYGBBOacvQ
YQIgNhn3Sn6RpM7vFnwQUdbWOGBLcTP4XabV0mLtuuGaCyZMOum1tSfvsqZjPeRO
oMj/c9+0kiJ5ZxuKz9X34rEXR7SLzGTnQ8Hl44ybJr5Om/KpZiUmTenS3wldG9qO
tlyZYtm/1tuFlbsXbW5TzHAEfmq3DLIjiP4Hte77cDKUn7Eo1uLZWmeecBlsuQRf
ZXwxBIXBo7A7utpLsKkHEAq7inQoEY4Q4D39mShoOjAY/wxjk+MmBvt84Y6lGBIz
14R21GmZWaaIb7SqH0mLRnJmpY7KR5MlRTlFuN2AGzutKcw2tCDueN0gV/U0L2QQ
5bqA3rfMIASbs/3s+VygLaaC1YaBqADXuXSGvZ4MHEBjHiLOxRCX0PH834w8MHrR
pjJc9FE9fb0pZo0rTMxqNOspsmwmu7t1sqlvjG3rEAEOKnYRDGf2qPiAhnM7GIvK
3mp1HJ6ysB67Yk7saCbm
=OKj9
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
