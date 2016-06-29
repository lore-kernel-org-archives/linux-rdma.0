From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 17:40:37 -0400
Message-ID: <1d03eaca-142a-3912-badf-aa9b14f6b2f6@redhat.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com> <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com> <20160628170549.GE3584@leon.nu>
 <20160628211858.GB5786@obsidianresearch.com>
 <20160629120920.GA24151@infradead.org>
 <20160629183414.GD17031@obsidianresearch.com>
 <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
 <20160629185757.GA17839@obsidianresearch.com>
 <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373AB06699A@ORSMSX109.amr.corp.intel.com>
 <017f01d1d23b$f27c4970$d774dc50$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0669F5@ORSMSX109.amr.corp.intel.com>
 <01bb01d1d248$647061e0$2d5125a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="84UHuFNdkfknGX5UPdShn2nGBvWi9XoTG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01bb01d1d248$647061e0$2d5125a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--84UHuFNdkfknGX5UPdShn2nGBvWi9XoTG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/29/2016 04:54 PM, Steve Wise wrote:
>> I think the concern here is being overstated.
>=20
> I don't think it is being overstated.  It is my concern, and it is vali=
d.
> However, after these discussions it has been alleviated to some degree.=
   It
> seems like some of the members of this discussion already have an under=
standing
> of how this would all work out.   But perhaps other provider maintainer=
s need
> more details (obviously I did).

I can tell you how it worked inside Red Hat for me (I no longer handle
the internal builds, others do, so the methodology might have changed a
little bit), but whenever I got ready to do an update for a release, I
had these steps to complete on each package:

1) Download any new source tarball
2) Build/test locally.
3) Build in build system (all official builds must be built through the
build system, which strictly controls how the build root is created for
each build and what packages are installed in that build root to make
sure a package built out of our build system will actually install and
rebuild on a machine of the same release properly).
4) For packages that other package build against, I had to make sure the
new package was put into the build root of the build system so other
packages would get built against the new version and not the old version
of the package.
5) Then I had to make sure the package made its way into an errata so it
would actually make it to the end users eventually.  Because the
packages in the RDMA stack are so incestuously dependent on each other,
I used one errata for all of the RDMA stack packages.  This is in
contrast to the norm at Red Hat which is a separate errata per package.

Mainly because of the dependency nightmare of "have I built libibverbs
and is it in the build root? Yes...OK, which packages can I build
next..", I kept a spreadsheet around to help me keep track of which
packages were on which steps and let me see at a glance if I could even
move to the next step on a given package.  Putting all of the verbs
providers into the same package as libibverbs itself would reduce about
10 of those lines to a single line.  That would certainly make things
easier to track.  And going back to Jason's comments, it wouldn't really
slow down end user's access to the packages since most end users get the
packages from someone like Red Hat and they are all delayed until the
next release anyway.  But, it would be fairly easy to say that we can
have a policy that supra-minor point releases are a foregone conclusion
when a provider library needs an updates.  And just in case that point
isn't clear, let me put it this way:

libuberverbs->master branch - ongoing development
libuberverbs->x.y.0 - Ubervervs major release, major changes or features
present.  When you make this release, you create a verbs-x.y branch.
Primary development continues on master.
libuberverbs->x.y.z - Minor bug fixes to major releases.  Done on
verbs-x.y branch.  Even before bringing in providers, these are
typically used after a major release as bugs settle out.  After adding
providers, it would simply mean that a provider bugfix is an understood
sufficient cause for new minor point release.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--84UHuFNdkfknGX5UPdShn2nGBvWi9XoTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXdEBWAAoJELgmozMOVy/d4L0P/i7U0TuW758/0QvmQl/L+KB1
l82T62JKG8YVAstwDnqf+zhwRj+qjU5OrrsvsTj6Io7pdus22KzuJfK/foGUWSS5
belPO4H10OHsryJ/YHykBp2iIM92FkjG13qqdHufTIybyTENmpJ09d7N0rZRsNDR
OI6rzrA1MklBosCLP5/q5PqyHXjhmLvEymXZZGIAKFU98t07MEwEX/7Likfu1Lvr
hvO1b9DWKhFVQoLJIgSfZz/+Spp+ky45Vwt7lwTRGDiJH+kKzJkaHbUffA8+uBFA
K282kuiix+g/wtW3aSjjMf6+Wdzq84/7nE+hLx22sKYuG577Ny4JeXFHpyQBLfAN
nnLX/ZvdqiwQfF4Zq///wYE4L+zc6gyykbFkAvouKJxEbFIQKmhux3aZdPAEaO69
44FZXKeR610azP1/kXjaR9mF5KPqUkui/Fu0GJ0QSaFcA8j0vVV/kCia6A2W8Vrx
FX5chq+LO/9HJLe5uQKYFtlkk+Ib85f4RtZgynX1yCBdN0j+bqbcihAmxEQiwDbY
et4pmu9gj/zXgADE0hy7LckYkY9WIMw0BXPqsttgfI9zVI710cIWGTqjkOKW0RFO
U/BVgObp3e3Mit1RQvmMG3XzvroF4ZWE3S/8N2dNL84qK1vJIhsAzi9doq8bVPK+
PV2tN0Y+r0Eicl+HoyVt
=wjeA
-----END PGP SIGNATURE-----

--84UHuFNdkfknGX5UPdShn2nGBvWi9XoTG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
