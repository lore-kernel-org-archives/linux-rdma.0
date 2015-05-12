From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/core: Fix for parsing netlink string attribute
Date: Tue, 12 May 2015 13:14:26 -0400
Message-ID: <1431450866.43876.65.camel@redhat.com>
References: <20150508213633.GA13012@TENIKOLO-MOBL2>
	 <20150508215328.GB3917@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-D/o87EYH8glbPgWlpu1W"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150508215328.GB3917@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, swise@opengridcomputing.com, john.s.lacombe@intel.com, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-D/o87EYH8glbPgWlpu1W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-08 at 15:53 -0600, Jason Gunthorpe wrote:
> On Fri, May 08, 2015 at 04:36:33PM -0500, Tatyana Nikolova wrote:
> > The string iwpm_ulib_name is recorded in a nlmsg as a netlink attribute=
.
> > Without this fix parsing of the nlmsg by the userspace port mapper serv=
ice fails
> > because of unknown attribute length, causing the port mapper service no=
t to
> > register the client, which has sent the nlmsg.
>=20
> Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>=20
> This actually will copy some kernel memory to userspace. I think the
> overflow is in .text, so probably not a security issue..

It shouldn't be in the .text section.  This is defined as static const
char array, so it should be in one of the data sections.  And since we
are using an initializer smaller than the specific size of the array, I
would expect all of the unitialized bits to be 0.  But, the proof is in
the pudding.  A quick compile and check show us:

Contents of section .rodata:
 ...
 01e0 69576172 70506f72 744d6170 70657255  iWarpPortMapperU
 01f0 73657200 00000000 00000000 00000000  ser.............

Yep, just right.  It created a 32byte ro element, initialized it to 0,
then put our text in it.  This is exactly what will get copied in the nl
message and is precisely what we want.

Applied, thanks.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD


--=-D/o87EYH8glbPgWlpu1W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUjTyAAoJELgmozMOVy/dHwsQAJ2i0iD6SRWxKaPTXhDHaZ3K
hHYDpmS+ZLKdke79YD39ntSMTZ858GVx6BkI5aLttADF9d2yvTj1cp2UI+/CrYb7
Lx6FTdqcPHmerpRitMYbNWhz8mYsOmkuWvVX7nzT0FajDip7t3eAN8VhLc2lRDx6
2KufHRUyOHOSN9oegXVopfKeaa8zmQRhY7ISpRbpfLlf4h9iSmZKoV0/bJ0zD3Fk
xP74Gz2fBgLEVlepuODEMhu9wdXHaK+oldnL/Vs7HgFHW7g/yNr4aFsjuvyjZlAH
ZHFvVT6BrG1FSvDUG5JeP5Mfc3kLEpnEGOpB37rd1a7P8nJA5Bs6f6qWo3HWb5Na
y3I/L/dwO2mEpsR8kaaiuHrLmUXNS6oElT5lV61k4Xj3eKvaBNJS2jX9VGRJmQUg
M4rX9zEyr8RGbdUlLXVemNvqgOnbLtQRav+XIHsWS5V9C784IvegapX1EsJ2JG/S
o8BLF1tsXyf9ZXQE9/R545N5qo1b9VNVr8k4n05J9PNDLt4cmLOIvzjjr/OY2hvr
s0TY/JVzBLkLb0nxKJX0mJ2Z0rLKXNFdvKLlgJ+zr27I+Q4vPLBaF/qrAgXDm24e
9jN9hk++2CO7ohPLuiaLWI7Bxay8i3ttDcuieOoQsn2uMMomYtV2HY8ORt4hPKRM
IxSwDLVGA+uHv/WT309A
=lWzY
-----END PGP SIGNATURE-----

--=-D/o87EYH8glbPgWlpu1W--
