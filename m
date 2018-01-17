From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Wed, 17 Jan 2018 15:31:16 -0500
Message-ID: <1516221076.3403.280.camel@redhat.com>
References: <20180112055842.23125-1-leon@kernel.org>
         <20180112141524.GA16256@ctung-MOBL3.amr.corp.intel.com>
         <20180112150602.GN15760@mtr-leonro.local>
         <20180112153402.GA12452@ctung-MOBL3.amr.corp.intel.com>
         <20180112165843.GC15974@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UHGwbPziWxmvc6nTcXFH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112165843.GC15974-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-UHGwbPziWxmvc6nTcXFH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-12 at 09:58 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 12, 2018 at 09:34:02AM -0600, Chien Tin Tung wrote:
> > On Fri, Jan 12, 2018 at 05:06:02PM +0200, Leon Romanovsky wrote:
> > > On Fri, Jan 12, 2018 at 08:15:24AM -0600, Chien Tin Tung wrote:
> > > > On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> > > > > Hi,
> > > > >=20
> > > > > There is small set of fixes targeted for rdma-rc.
> > > >=20
> > > > For RC?  Are these fixing regressions?  We are already in RC7.
> > >=20
> > > Jason was clear last time, he wants to work like Dave, fixes go alway=
s
> > > without any relation to -RC.
> >=20
> > I won't claim to know Dave's process since I don't drectly submit
> > patches to Netdev.  However given Dave's history with the kernel,
> > I highly doubt he would accept patches late in RC cycle that would
> > jeopardize a kernel release.
>=20
> Well, my definition of 'fixes' is pretty high. For instance fixing a
> performance regression is not a 'fix', IMHO.
>=20
> Fixing a user triggerable out-of-bound oops would be though - as in
> these modern times I'm sure someone smart can escalate stuff like that
> to a full security compromise of a trusted boot system..
>=20
> This is why I keep asking for good commit messages for -rc
> patches. Explain why you think this deserves to be in -rc, in terms
> other people can understand:
>=20
>  - Can userspace trigger an oops or memory corruption? How?
>  - Can the kernel oops or memory corrupt in a actual demonstrated way
>    (not theoretical)?
>  - Did this actually get hit durring real world testing?
>  - Could this escalate to some kind of security issue for a
>    trusted-boot kernel?
> =20
> etc.
>=20
> So, when I've said 'fixes should go to rc', I mean fixes that qualify
> as important here:
>=20
> ...  Bugs that have always existed are not regressions, so
>      only push these kinds of fixes if they are important.  ...
>=20
> and I haven't ment 'just anything with a Fixes: tag'.
>=20
> If I think I can't defend why your patch is 'important' to Linus,
> then the likely hood of taking it decreases as we move along the rc
> cycle. It is up to the submitter to write a good commit message.
>=20
> Doug also likes to see patches with a small LOC late in the cycle.

Indeed.  The larger the line count, the harder it is to guarantee that
you aren't just introducing a new bug.  At some point, the devil you
know is better than the devil you don't.  So, if the bug in question is
an oops, or a locking issue resulting in deadlock, or a use after free
that can result in nothing all the way up to silent data corruption or
oops, then those obviously are the ones that I'm going to take on up
into late rc cycles, and even if their LOC count is higher than I like,
if testing shows it solves the problem, I'll take it.

For lesser issues, I'm more likely to take it late if the problem is
obvious and the fix is small so that we can have a high degree of
certainty that the fix won't introduce any other problems.

> eg if we look at the recent patches:
>  - Two security related issues for SRP
>  - A locking issue leading to user triggerable memory corruption
>    (eg add/remove rxe devices in parallel with netlink queries)
>  - In-kernel oops under error situations potentially triggerable
>  - Real world oops caused by SE Linux checking, hit during testing
>  - A issue that damages our potential future ABI compatability in uverbs
>  - User triggerable kernel data corruption due to missing locking
>=20
> etc..
>=20
> and some counter examples that went to -next:
>=20
> - 'RDMA/cma: Fix rdma_cm path querying for RoCE'
>   The uAPI has been broken here since v4.12 and nobody noticed
>   The use case in user space is very obscure
>   Probably would have taken this to -rc around rc1/2/3
> - 'net/mlx5: Fix race for multiple RoCE enable'
>   This has been broken since v4.13
>   Unclear from commit message if this is theoretical, user
>   triggerable, or seen in the real world
>   Could have been -rc if the risks were identified as real world
> - 'IB/{hfi1, qib}: Fix a concurrency issue with device name in
>   logging'
>   Seems kinda -rc worthy but the LOC is high, the bug has existed
>   for soemthing like a decade, and the commit message doesn't
>   explain why computing the wrong string is 'important'. Doesn't
>   seem to be a oops or security issue.
>=20
> At the very least this is the best thinking I've come up with after
> talking to several people - advice welcome of course.
>=20
> Jason

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UHGwbPziWxmvc6nTcXFH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfspUACgkQuCajMw5X
L93FKRAAjUpUryOHQIAvVopBU89oP3OE1ErLsRsk0GB6QibjO2gqEFQcoMLdHY7Z
ANESKZI7bibAyCIJ1+ziOxqvwtNtdH0HSEE30YdRsQAm0E6f6aWpvUhAlEkPZ802
xyLmPOEb8uf7s1y4qswm1y0mjupcJ0QYQPRpAvjBBRlabJ1CVVACU3uWhhgioUNz
X/bK6A0FPCMwuIvc2P2AZUxQiuWuI7RhF1ZhnTrTc2gQPUM6dTeyUG630AqYUjPH
7Z3zlEKQAXSbYEn4LC5Hjur1vuFm/mCgqZPRRowEZ2y+4xojp41NQub1KnG0WZ3a
9Z4DRxWO4qZZ+aybstJ7gIsoPojP+nhGqnk+cRCdnbgEfILSe8Ejtpp7xQsLU9yZ
5WgOpm359jVVXdWWFqkmIknyLdt1LlahbXKkfT4c+Oi7unHa09FI8xVCoGFwMUhM
V4Rv1bUA9MZFvtyR8opfRMXnDnIaoDZjC11d+vVAPx8XhqcytZn9ICCmd+Mlx4TD
O5qkKzhSc+bgWqMHfyXhCIMyX4NCQRyBgDlZnJf6Przyu7EAqQ6WXfutebvsaXJ6
1BNN5oYgHXhoSnmJteSGRV4qOpnwjwF8pdLu21ibLUxWTcOBv0EeQY/2gsnVsfeE
lTlld+b+ShfNYsVWIw4+GE7gQ165Z/SknupDSH5Byz8LEz54n84=
=a1fg
-----END PGP SIGNATURE-----

--=-UHGwbPziWxmvc6nTcXFH--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
