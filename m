From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 16:40:15 -0400
Message-ID: <6d41d034-01f4-0444-6a4d-4dfb87501c2c@redhat.com>
References: <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu> <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu> <20160628211858.GB5786@obsidianresearch.com>
 <20160629120920.GA24151@infradead.org>
 <20160629183414.GD17031@obsidianresearch.com>
 <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
 <20160629185757.GA17839@obsidianresearch.com>
 <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com>
 <20160629192730.GA18394@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6smbMHJo5xKpJeUFNEXXwbsEfBwXv0c4x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629192730.GA18394-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6smbMHJo5xKpJeUFNEXXwbsEfBwXv0c4x
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/29/2016 03:27 PM, Jason Gunthorpe wrote:
> On Wed, Jun 29, 2016 at 02:15:46PM -0500, Steve Wise wrote:
>=20
>>> I think you start by realizing that nobody uses your git releases
>>> anyhow.
>>>
>>
>> Not true.  RedHat, for one, does.
>=20
> I mean no users.
>=20
>>> Everyone uses either a distro or OFED release and those are already
>>> co-ordinated outside your control.
>>
>> I don't know who "everyone" is, but at least some of the distros get
>> the
>=20
> everyone =3D users

Jason's point, which is correct, is that even though libcxgb3/4 are
separate from libibverbs in their releases, Red Hat (and presumably
other distros), which are the main bodies that take the individual
tarballs, then coordinate between libibverbs and the plugin libraries
before each of our releases.  So your releases are easy for you, and
that gets them directly in the hands of people like Red Hat, but then
they are still coordinated against libibverbs behind the scenes.

>> libcxgb3/4 packages from releases I publish and announce on
>> linux-rdma.  Chelsio recommends to RedHat exactly which libcxb
>> release to pull in for each of their OS releases.  They are not
>> necessarily tied to an OFED release either.  Ditto for SUSE,
>> although they may still take from OFED packages.
>=20
> And that doesn't really change, you just recommend a libibverbs
> release or libibverbs patch.

Pretty much.

>> From what I've experienced, the distros don't take patches for
>> libraries at all.  They take discreet releases that are published by
>> the maintainer of that
>=20
> Your view might be a bit specialized because a plugin 'library' is a
> very special case. Generally the distros will have tight controls on
> library updates to guarentee no change to the ABI/API. Often they
> won't accept new upstream library versions at all, instead only
> backporting necessary fixes.

Correct, for non-RDMA or kernel related packages.  For the entire RDMA
stack and for specific kernel related packages (like ethtool for
instance), the guidelines are different.

> For instance, if you add the new CQ API support the libcxgb (or any
> new API for that matter) then the provider will no longer compile on
> the RH released libibverbs and either Doug will have to work on a
> backport basis, or you will have to jump through configure hoops to
> make it compile.

That's where the special nature of the RDMA stack comes in to play.
Realistically here, we would batch up the libibverbs update that creates
the API plus all of the driver updates to use the API into one release
and the RPM headers for the various packages would Require: the latest
versions of things and simultaneously Conflict: against old releases of
any packages.  That way we can enforce an all-or-nothing install of
matching verbs packages.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6smbMHJo5xKpJeUFNEXXwbsEfBwXv0c4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXdDIvAAoJELgmozMOVy/dZSoP/1zwRoZ7mEhsBmhNTy4iMHNq
GUzFgSHtiiCYxwtoOqR2SZvXA89eMWf7cik29DPNEnGIYluf0qNEbTi9Z/cN1Tl/
FupUl7dia4GvJRWhkoYstXRXC1lmsNkE/Zts9ofhffp+PpheplGS57vU9eNRARjv
ZlzipFLJUvlbsuGqkk+vno+iyVMyGgumWOS4WbH0iA9p4pWq0XpV5EjnbqxGX1qy
VPmRS00WMgFHOuPWeM86/NAFoLBhKC2RUUcTZzmO84gQ2JEpYpd+Idou0ojv7oqs
DK01i/0kyVw0MlAycYdN02UIwGTAQsfaCQEZurK8yDyjf97CxhTe5wEyWeUdgPlX
qhKEVS/bbaqRjsrV1Nrvme1fsU7l/RUSLm2sZiu9hHKYa+qchhpmfcEfrF/BWwzy
cujNf8QfC8e2LQ9TMPsAKhz0Q7NStKY5Vr41DdkJNkDdTrCa1YZtUfkrwuphYihP
8Qkovhl+ohSgo7GzEYRJaH7mf7BjmjRNaMqDOj7VllfdOl4O4CaJvNxCVhorZbXz
nGS4P0+jOwFSMGu/ytDc7mhLcyX1HyScvU3FIcOmo5pNpmr1DxOzVu5N7h95HQwP
+LGaZvAcIBwLHuKi9OCrzEkYp8cMPz3B9+TFR5skVqFcDG5xtecryIiTkGcLqhRz
WcJ5t/2zAf/kGQvd16gm
=DTQg
-----END PGP SIGNATURE-----

--6smbMHJo5xKpJeUFNEXXwbsEfBwXv0c4x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
