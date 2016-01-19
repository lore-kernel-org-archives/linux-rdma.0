From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] RDMA/nes: checking for NULL instead of IS_ERR
Date: Tue, 19 Jan 2016 15:59:48 -0500
Message-ID: <569EA3C4.5080902@redhat.com>
References: <20160112092743.GA29804@mwanda> <20160112151252.GA2294@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5OOt16dfvhmRXhIc3n479WCNatjaGFjmC"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160112151252.GA2294@lst.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5OOt16dfvhmRXhIc3n479WCNatjaGFjmC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/12/2016 10:12 AM, Christoph Hellwig wrote:
> On Tue, Jan 12, 2016 at 12:27:43PM +0300, Dan Carpenter wrote:
>> nes_reg_phys_mr() returns ERR_PTRs on error.  It doesn't return NULL.
>>
>> This bug has been there for a while, but we recently changed from
>> calling a function pointer to calling nes_reg_phys_mr() directly so no=
w
>> Smatch is able to detect the bug.
>=20
> Looks fine,
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--5OOt16dfvhmRXhIc3n479WCNatjaGFjmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqPFAAoJELgmozMOVy/d818QAMNI59hKApaDB9Kr8bhoMeKs
gkkzHVo86rAVQPdbJzg6JMppK619UKwsNaitcj4EsqTF8lJT4cfsftf6aCmnqy/g
zPmZR9DjgBWW8r5aeNIyGWI6ukse091P9LtodlS461QXpzASqynCdbiGELSfmkDG
XK9RF8krxOi7/FHxlvAkNtKKpKBMwRxDXQVajeGnGKx6UD3QeNq70s5uTc87qL1R
TUg23+3R4b0LOmxKWUpXNfllJYQFtgRDMK4Jt1AWrK3yRsHMS/6/49iTN5Equ7v/
M53t5RX/0AH/YoRhSclrakzmZwbc/IQwD9az+IM3MxX89IbHbF7j05mCZy+8mZB7
R+YZRs2Jk3n/ya9noZoC8+1pBcKFDD+NDbUYWjqKDYxjVUeKkPjNGd9GO3qHJde7
qd+q/TfFBevsQAA+tS5naNY9uTJt3Q4E7EvCzj8DjBkKYs3upRqHSwk+izMnoD9v
xWOa/18fS556P7lXftMYfeaEqRd/CvS9ud/QkGPvmfHlWORyXiTEswERV77XtFLJ
HNW/KkE5pvL3x0GZoksRTGBthL3EUpRa9kYnU7RRTEMMVT84JO5NTqfKB5WSOJKK
bWvoXDzUFWiTPRD6/AetAcuhDGEcQFw7YaIcnCvVQYlgIwhS+6JUXytmNtyb2KYb
Rm+ft5pNDZMGM8KQ9Ib7
=FE7S
-----END PGP SIGNATURE-----

--5OOt16dfvhmRXhIc3n479WCNatjaGFjmC--
