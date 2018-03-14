From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] infiniband: qplib_fp: fix pointer cast
Date: Wed, 14 Mar 2018 16:03:51 -0400
Message-ID: <1521057831.18703.101.camel@redhat.com>
References: <20180220205638.1959033-1-arnd@arndb.de>
         <20180228211514.GC13394@ziepe.ca>
         <CAK8P3a2dsQ7QAb64DCp9Fc2xXjEyHNjBFdRc=y6FanQKsXhADg@mail.gmail.com>
         <20180306234539.GB1037@ziepe.ca>
         <CAK8P3a0mHEm8m8=CfV5Qmw0EcVCc31OetdFXHQ0KEvWk6K40Gw@mail.gmail.com>
         <CAK8P3a2cqjQzhaPwk9rE6=s4QQVFk8vAoYQfqSrh1nOi-KpZew@mail.gmail.com>
         <CAK8P3a2SS4RBwjrd2XCnpA8W_bmHtjdjWdX1RTnkou0OQ5ROdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UJaNqwXGmqS0tl2yU1Rb"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2SS4RBwjrd2XCnpA8W_bmHtjdjWdX1RTnkou0OQ5ROdA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eddie Wai <eddie.wai@broadcom.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-UJaNqwXGmqS0tl2yU1Rb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-03-13 at 09:50 +0100, Arnd Bergmann wrote:
> On Wed, Mar 7, 2018 at 11:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wed, Mar 7, 2018 at 10:05 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >=20
> > > A small complication is that I wrote the changelog for the build warn=
ing
> > > on 32-bit architectures, which is more elaborate. kernelci.org for
> > > some reasons currently skips the allmodconfig build on all 32-bit
> > > architectures (I should ask the kernelci maintainers to change that),
> >=20
> > I see that Olof's build bot does have build results for arm32
> > allmodconfig, which is also big-endian, and reports the same
> > errors that I described in the patch changelog.
> >=20
> > See
> >=20
> > http://arm-soc.lixom.net/buildlogs/arm-soc/v4.16-rc4-25-g41c42fe/
> > http://arm-soc.lixom.net/buildlogs/arm-soc/v4.16-rc4-25-g41c42fe/builda=
ll.arm.allmodconfig.log.passed
> >=20
> > for today's results.
> >=20
> > This bot reports one other warning for arm32, but it's
> > specific to the toolchain version used on that bot.
> > I have a fix for that one as well, but there was some
> > discussion on what the best approach would be.
>=20
> Any update on this? This is now the only remaining gcc warning we get on
> allmodconfig builds for arm (both 32-bit and 64-bit) in linux-4.16-rc.
>=20
>=20
>      Arnd

Do you need the full series to fix this (it looked that way to me)?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UJaNqwXGmqS0tl2yU1Rb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqpgCcACgkQuCajMw5X
L91xFBAAtH7NYOxqPq7xaCstsugw3L8s3QHtEMNDnT4f1zAdQFUW6k1AmlpsT38I
CfrVE91jqi45p9O95ipRv4/diVb4j+RpzO0QLtA/WNpvkgNgwcUdDYHfVpktx+aT
3cZ4RRXbqXZG+AJRKQb1L3wLEDz3sQHeLxQ0n8yZjCksF1SUaKOh6sGpZJdQraFu
O5conXnugLTe8i5b4gZSM39Ak4O/GzNkNtlp8RrbX2Qye55Tyyb0/Gw43Ch86uKR
O3yslNUvs0rkmKCNO+0yVEgnMFdhDi7+qiJ9g3zxqrmIyuuae3owAT0Cchr8aaH+
MumCI4iLN4bRImxvkzzR3aAJAm8eOF0kdFCuOzlUAWzPXz/5V9Sv1Y45fjlqvEhG
hfkUlSeSgZo0y9wZw73w31NGUXhAZxxqR9yLHfmUNjv6GrnlsHmNFIZdjxOKOlwY
c+C2C/k4uUrL/Iyxl3mGq6TFGzAWJOOoZmTVEPzddnLwk1nwLnQK5J1PUHBDM/Zg
+Xy9OHHSpvirIj0XUxXqctBL/v/hiLPTRVpImEP7+RVhcvKLPp87jFCqvaaIfa60
8x5ffiKOmtt6/h4skeCvbalLdQvB9S1PEXE0tbiPr0QZikR7g5cYvUk2HGkkPBTC
a8vrdCIjK9Zq0EFbWPItmENQaTXWRTWM9a/lLm7ZI0e8shsz75s=
=P7RC
-----END PGP SIGNATURE-----

--=-UJaNqwXGmqS0tl2yU1Rb--
