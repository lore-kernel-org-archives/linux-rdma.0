From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] infiniband: qplib_fp: fix pointer cast
Date: Wed, 14 Mar 2018 17:01:54 -0400
Message-ID: <1521061314.18703.123.camel@redhat.com>
References: <20180220205638.1959033-1-arnd@arndb.de>
         <20180228211514.GC13394@ziepe.ca>
         <CAK8P3a2dsQ7QAb64DCp9Fc2xXjEyHNjBFdRc=y6FanQKsXhADg@mail.gmail.com>
         <20180306234539.GB1037@ziepe.ca>
         <CAK8P3a0mHEm8m8=CfV5Qmw0EcVCc31OetdFXHQ0KEvWk6K40Gw@mail.gmail.com>
         <CAK8P3a2cqjQzhaPwk9rE6=s4QQVFk8vAoYQfqSrh1nOi-KpZew@mail.gmail.com>
         <CAK8P3a2SS4RBwjrd2XCnpA8W_bmHtjdjWdX1RTnkou0OQ5ROdA@mail.gmail.com>
         <1521057831.18703.101.camel@redhat.com>
         <CAK8P3a1=h7cF8kRUWpFG88-OSFL8_7SgUkaX4TUEhG6ypPODkg@mail.gmail.com>
         <1521059294.18703.106.camel@redhat.com>
         <CA+55aFxEsTA7DTBYdLz8sbniq2NRO-X+Nt1vmYxckfWAP0BQZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QvdOF5BTCqq2F29+7Pt9"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxEsTA7DTBYdLz8sbniq2NRO-X+Nt1vmYxckfWAP0BQZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eddie Wai <eddie.wai@broadcom.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-QvdOF5BTCqq2F29+7Pt9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-03-14 at 13:31 -0700, Linus Torvalds wrote:
> On Wed, Mar 14, 2018 at 1:28 PM, Doug Ledford <dledford@redhat.com> wrote=
:
> >=20
> > Arnd sent in a two patch series and it got put into our for-next branch=
.
> >  But, the two patches are the *only* two remaining issues for the arm
> > builds on the kernelci system.  They would like to get this into for-rc
> > so that the build failures stop.  Are you OK with me just cherry-pickin=
g
> > them from for-next to for-rc so I can send them to you?  They'll show a=
s
> > duplicates in the next merge window, but should drop silently.
>=20
> Go ahead, assuming there are no other planned changes around them that
> would cause potential pointless merge problems..

These two patches will be fine in that regard.  They aren't in the area
where all the syzkaller bugs have been getting fixed.  But I need to
merge for-rc into for-next because of all of the syzkaller bugs being
fixed.  We are running into a situation where code updates that were
planned are in areas where syzkaller bugs have been fixed and there
would be significant merge conflicts if I didn't.  So, the plan as it
stands is: get the needed patches in for-rc, merge for-rc to for-next,
then cherry pick from for-next to for-rc just the two patches here
(since I have no idea how cherry picking to for-rc and then merging for-
rc to for-next would play out, I'm just not gonna try it).

It's a bit convoluted, but as long as I don't use my standard git
request pull macro when generating the pull request (it will pick the
wrong merge base every time whenever you've merged for-rc into for-next,=
=20
you have to manually find the alternate merge base and use the right one
for git request pull) it comes out nicely in the end.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-QvdOF5BTCqq2F29+7Pt9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqpjcIACgkQuCajMw5X
L91AYhAAk/fz+G0z9fDw5BQWYh7Mgo+5hIke1Zhpi1XTe/HmQgdzOWMHDZRV5Bh0
dWSBPddUo0jVUHNS8WYY0r/GQoQIJhi/XAAPAY8QTYhy6tIVsgPr4yeeEZMrIWdZ
ozEDxASasgpmiogw9tX/ecfWqUyOu/U+iFclSZinHbrMnKvnvk4C6C3XDzmeF/mR
cI2VM2yEtxTfblticeEmx1zRrlQBl3NjTdGZG7VXE6AOIPTQxqiKKcWXVMri1e3x
UWD0hSKs1OIYFTWOTnxS1quJdj7hexJ5nCW+jaHQ4Rygl2DEGn6uWqDOQ0jnM5DU
DdvBnW8o44IoYpAIMExQ3b2oOgXgy+gyz+PvPGQJ9nrv22/MEpVQaqel47m1sBAw
/vKzQedNwA7bLZdWUZbPn/TTP4TI/zh72Ri39lv7ZYFr660ItlIDqVwm5B83tJwO
k9Si26qeENAlVXjJfiTyp8hd2+dAy/Wxy7i2Jpn3877ZH0ffOtnt2byyhWOljx/A
PGnVNj1U1A5pdUJwv61gQ9l/2CKNYBWYwYtJ5nHRg57sPrZGpOTHkPs2WK6/fiG0
ibO9h2ALfhd8f+ZWlT00UoGb3WwOVRwMlbp5b6afRrhmi/2VvmfnywJeh7OXm8DQ
+DotJLHvXpKAAMI7zp4xFDoNS6zMQsA5O5PGBNXTYP48+1RsKGI=
=Vxrz
-----END PGP SIGNATURE-----

--=-QvdOF5BTCqq2F29+7Pt9--
