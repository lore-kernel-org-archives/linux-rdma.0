From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] infiniband: qplib_fp: fix pointer cast
Date: Wed, 14 Mar 2018 16:28:14 -0400
Message-ID: <1521059294.18703.106.camel@redhat.com>
References: <20180220205638.1959033-1-arnd@arndb.de>
         <20180228211514.GC13394@ziepe.ca>
         <CAK8P3a2dsQ7QAb64DCp9Fc2xXjEyHNjBFdRc=y6FanQKsXhADg@mail.gmail.com>
         <20180306234539.GB1037@ziepe.ca>
         <CAK8P3a0mHEm8m8=CfV5Qmw0EcVCc31OetdFXHQ0KEvWk6K40Gw@mail.gmail.com>
         <CAK8P3a2cqjQzhaPwk9rE6=s4QQVFk8vAoYQfqSrh1nOi-KpZew@mail.gmail.com>
         <CAK8P3a2SS4RBwjrd2XCnpA8W_bmHtjdjWdX1RTnkou0OQ5ROdA@mail.gmail.com>
         <1521057831.18703.101.camel@redhat.com>
         <CAK8P3a1=h7cF8kRUWpFG88-OSFL8_7SgUkaX4TUEhG6ypPODkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bB2L5MD3hBAE0BXIzqy7"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1=h7cF8kRUWpFG88-OSFL8_7SgUkaX4TUEhG6ypPODkg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Torvalds, Linus" <torvalds@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eddie Wai <eddie.wai@broadcom.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-bB2L5MD3hBAE0BXIzqy7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-03-14 at 21:16 +0100, Arnd Bergmann wrote:
> On Wed, Mar 14, 2018 at 9:03 PM, Doug Ledford <dledford@redhat.com> wrote=
:
> > On Tue, 2018-03-13 at 09:50 +0100, Arnd Bergmann wrote:
> > > On Wed, Mar 7, 2018 at 11:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > On Wed, Mar 7, 2018 at 10:05 AM, Arnd Bergmann <arnd@arndb.de> wrot=
e:
> > > >=20
> > > > > A small complication is that I wrote the changelog for the build =
warning
> > > > > on 32-bit architectures, which is more elaborate. kernelci.org fo=
r
> > > > > some reasons currently skips the allmodconfig build on all 32-bit
> > > > > architectures (I should ask the kernelci maintainers to change th=
at),
> > > >=20
> > > > I see that Olof's build bot does have build results for arm32
> > > > allmodconfig, which is also big-endian, and reports the same
> > > > errors that I described in the patch changelog.
> > > >=20
> > > > See
> > > >=20
> > > > http://arm-soc.lixom.net/buildlogs/arm-soc/v4.16-rc4-25-g41c42fe/
> > > > http://arm-soc.lixom.net/buildlogs/arm-soc/v4.16-rc4-25-g41c42fe/bu=
ildall.arm.allmodconfig.log.passed
> > > >=20
> > > > for today's results.
> > > >=20
> > > > This bot reports one other warning for arm32, but it's
> > > > specific to the toolchain version used on that bot.
> > > > I have a fix for that one as well, but there was some
> > > > discussion on what the best approach would be.
> > >=20
> > > Any update on this? This is now the only remaining gcc warning we get=
 on
> > > allmodconfig builds for arm (both 32-bit and 64-bit) in linux-4.16-rc=
.
> > >=20
> >=20
> > Do you need the full series to fix this (it looked that way to me)?
>=20
> I just double-checked, as I thought only the first one was needed, but
> indeed we do need both.

Hi Linus,

Arnd sent in a two patch series and it got put into our for-next branch.
 But, the two patches are the *only* two remaining issues for the arm
builds on the kernelci system.  They would like to get this into for-rc
so that the build failures stop.  Are you OK with me just cherry-picking=
=20
them from for-next to for-rc so I can send them to you?  They'll show as
duplicates in the next merge window, but should drop silently.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-bB2L5MD3hBAE0BXIzqy7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqphd4ACgkQuCajMw5X
L90OBhAAtw4Hr5tz3OB5JdJHHjklwSfuIBZYLXvaX9DDeVqFLAIt9WXmERQ0vfAH
VvPDNb119ipPo/CERIApqm3Yuh6prW8qrzYJmxw6E6fnraOymwEWeiIcUJ3pxg/z
9khcdFfMwtJoV+C/rNoDtYAeqhhgUlfLH5Vb6xpUL+2m0ce2SukfEe41GORZjHKa
mKEn7mIjRw4R/6WR/iNt1KYMVe5KqHNUObt0jcCZk2QdWFMo3NCXPSM5iw9YEtX4
//6qmhQ2qzm+suMb7fKBa3YtoBtaA3Et/PN6xNsZRJgSHADgopVR2dEBLexfHJbT
ycygYJHYjLVkQh88R02KRfcOvGIDjTylBNr9N+Ws3JHBXDA3sxl3vkm4qekhF1rK
1vdP2x//f0D2DaWvkPGzSpr/kX0I+U4Y+QXXCBWs24H3vG1hrPJtNELxT6rH+uXT
EXXfZunMZd5K6J18D/kiEzBDLXW7dDjU5Gqy47v1ywSSNznnBp5gYWFqmlK0dEIx
4UTRxxfxvkzEUnUJauvNJk0sCtNJ8BwtWxscK1QtA34v86UcgkLW2d/GIEjSt6dO
71l7fOY+OdYUGmJUMx3CFDDFS5/4B6L0+xTrPU24lit5QHcIeF+0tsjjAsL6Swgm
7lu7aGfsuw6sgfLkMUjs3cHYidIcu2B0cEdjKY9IyfA4dDq+Aic=
=EHuT
-----END PGP SIGNATURE-----

--=-bB2L5MD3hBAE0BXIzqy7--
