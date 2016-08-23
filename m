From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
Date: Tue, 23 Aug 2016 12:43:13 -0400
Message-ID: <d82d2d5a-34b9-27c1-f24e-5bc0a841d47d@redhat.com>
References: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
 <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JtwLFxpfpgfORwu0g0Ig9eh4jgdABQDge"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, SF Markus Elfring <elfring@users.sourceforge.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JtwLFxpfpgfORwu0g0Ig9eh4jgdABQDge
Content-Type: multipart/mixed; boundary="Mx5lL0WrBGHcShoFoKVhLnrd719plKlDx"
From: Doug Ledford <dledford@redhat.com>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
 SF Markus Elfring <elfring@users.sourceforge.net>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, "Hefty, Sean"
 <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
 Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <d82d2d5a-34b9-27c1-f24e-5bc0a841d47d@redhat.com>
Subject: Re: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
References: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
 <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>

--Mx5lL0WrBGHcShoFoKVhLnrd719plKlDx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/19/2016 11:27 AM, Marciniszyn, Mike wrote:
>> Subject: [PATCH] IB/qib: Use memdup_user() rather than duplicating its=

>> diff --git a/drivers/infiniband/hw/qib/qib_fs.c
>=20
> I would be even more aggressive at reducing lines of code.
>=20
> For example do direct returns when ok to do:
>         if (pos !=3D 0 || count !=3D sizeof(struct qib_flash))
>                 return -EINVAL;
>=20
>         tmp =3D memdup_user(buf, count);
>         if (IS_ERR(tmp))
>                 return PTR_ERR(tmp);
>=20
> The bail_tmp: label is then not needed.
>=20
> Mike
>=20

With Mike's additional cleanups in place, patch applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--Mx5lL0WrBGHcShoFoKVhLnrd719plKlDx--

--JtwLFxpfpgfORwu0g0Ig9eh4jgdABQDge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH0hAAoJELgmozMOVy/dvd0P/Rk+PacmC4jIglbXfO8It6mJ
labmn92GU17POt2Ypsb/drNBNBgGQSavRiMnF9eThCeyV6JGFuMaaXBRlvc6qdLE
11pfCURtuSTe21kXxNpi4cTlmnBlTFkfwjNGlpqpURcEUkF5L02hV2ID7jchTdlq
pERqxkGOQ1CGuO3iAti1jB49LFps6g+x7EgQwRtTzs0urIiuOuuHObgBCz2VTQ2i
6Dp7UPtuEytj+Rx/5LlTF0eoq3+2h2qxJPUvzf19zjrjaKWV+CsZrW2l9DAgBTdf
giH741oelE44Cpqjk9OHpKAcfWSYbSshCunqFc4TqjncA/BXr8PLw6hKLWu2aVtQ
/a9a5Zh5v34K+vW3a9xYR8BkVkEMKmkLy6rr9zeJGGOlS/6GQV92VzGduy9HphbY
L/wypwaSP2yCaR0T9WAsZ7GHL6AfH/v+nFFeIqYM/pJZuI3zpxVO88PIG5a9v3jN
g4JU1BayAVw3C3IJLiDHQ1ucyc8ZgqO6LhDIyaZXSAM0WzA2MXQETClr7DQ848+E
9WA257zwGTvy2Yv9xPspvP60qtbtnwCer8Ksr90iQZDzMS/rKmWcIGgjXTBlS3cN
5VcH5puu/xMNtA+QijScikzwIKqz00VlE/pESTe/EG4ObdU8QgiwqlB4Uc7uCH3p
5SFPaLVXjmllBzF5d6wc
=Kxt4
-----END PGP SIGNATURE-----

--JtwLFxpfpgfORwu0g0Ig9eh4jgdABQDge--
