From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/security: Restrict use of the write() interface
Date: Wed, 18 May 2016 17:42:34 -0400
Message-ID: <673ebb5e-80fa-f4d5-1fbd-59e8a27e0f86@redhat.com>
References: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford@redhat.com>
 <20160518172012.GA6879@kroah.com>
 <c6c952ea-3562-48e1-cf56-5b8c810654f1@redhat.com>
 <CAJ3xEMi0Rg7nc7TN9Hn7=nuWmBZH1qoncKr+HuzjUP=8yMRrDA@mail.gmail.com>
 <53639dec-5d1d-58af-3022-963368c144db@redhat.com>
 <CAJ3xEMjrNUYPmxSBm6J-w+3gr6Uv60tN-Y00=o4dk1aS9yEYuA@mail.gmail.com>
 <8496b72b-c6ac-4d71-48c1-80d48991b6ca@redhat.com>
 <CAJ3xEMj4Q0Y1OsEqJaoEpWjitaLDy0G8qmLBrPo30JCc596Kyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FkHTTbeO6tk4QTqC1qCPSwt8vX9QCVJPu"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMj4Q0Y1OsEqJaoEpWjitaLDy0G8qmLBrPo30JCc596Kyw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Greg KH <greg@kroah.com>, stable@vger.kernel.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FkHTTbeO6tk4QTqC1qCPSwt8vX9QCVJPu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 04:36 PM, Or Gerlitz wrote:
> On Wed, May 18, 2016 at 10:59 PM, Doug Ledford <dledford@redhat.com> wr=
ote:
>> On 05/18/2016 03:47 PM, Or Gerlitz wrote:
>=20
>>> Is there a special reason you didn't add the CVE number to the change=
-log?
>=20
>> I didn't write the commit change log.  I used the commit change log fr=
om
>> the original patch that didn't fail to apply.
>=20
> I mean on the original patch when you added your maintainer S.O.B

Because of an issue of confusion.  Red Hat had an internal CVE assigned,
but I didn't know I could put that on here.  There wasn't an assigned
MITRE CVE yet.  Then people noticed the patch, someone requested a CVE
on the mitre list, and another one got assigned.  Red Hat has since
dropped their internal CVE and adopted the mitre CVE.  That probably
would have been avoided had I known to put Red Hat's internal CVE on ther=
e.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--FkHTTbeO6tk4QTqC1qCPSwt8vX9QCVJPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPOHKAAoJELgmozMOVy/drxYP/04eVgo1/HX+B1mYdfz+Kxv5
xfrzMBmdZZUURc1gWP2//M72o+mb69agEM01mL7xanZRBNt1N+8bvSfY1++KLs6C
qXfI2qhSfR2Excm2RY6Oh1BEMAIc2rFpjiTX7hfG6AnYaKeAqd24XJGWWH0Cj3VI
sAHszQZ37idvs329fLpJh9A2PSRQeS9Ce7Bck/o7m5Uq7JMJ9fgQ8Ml9e1Er4zGS
yyHYm0z5IOGwY3+epi1qOx+iXknlgrDjTSCAlTwjucUE00epHs2BsNf+RUk144CT
vlmlTPH96+SmVBF30HWtB3ibD/kCpkZMXin302G6wo5M2WVA7Op51HgwXQ2nxFDQ
GRKm1NzfTDdFoAbBeyJRhMqw3d33wjTYtY4KNaO7zssW7G3XHlDrRhFW4s4FT4Zz
fwvXcKLLFecj0xisKBRr7m7KinjnXHjr7b/oIhybuSDEBZfroXqLi/O+wFJyV1lK
xpOW35OodCg0JJrf5n1MzWHOZL3l3z/6chDdgsuWa9sUE737TSSq1uaqi5WjT4Ef
j/Q6dlc6vzQaNo4/9VzJ2mEw/+EwWvqG9RKRd/Gwl8zXyxrqW+bO81HDnLyQYzAs
xe7tDLi38hZS57En61aybd0rhxtx0TibLcDuHR3K/bpwza319x+u/b0L1pA8/uh4
ZK2TOWP2SLg9MMqxkNML
=YF1r
-----END PGP SIGNATURE-----

--FkHTTbeO6tk4QTqC1qCPSwt8vX9QCVJPu--
