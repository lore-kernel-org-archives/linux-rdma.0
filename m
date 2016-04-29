From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc] IB/hfi1: Use kernel default llseek for ui device
Date: Thu, 28 Apr 2016 22:37:26 -0400
Message-ID: <5722C8E6.5080503@redhat.com>
References: <20160422181702.15797.42892.stgit@scvm10.sc.intel.com>
 <20160422182125.GA21996@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fvq1jDdPa92piwiGDdcnRSsntwW91uuX1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160422182125.GA21996-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fvq1jDdPa92piwiGDdcnRSsntwW91uuX1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/22/2016 02:21 PM, Dennis Dalessandro wrote:
> On Fri, Apr 22, 2016 at 11:17:03AM -0700, Dennis Dalessandro wrote:
>> From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> The ui device llseek had a mistake with SEEK_END and did
>> not fully follow seek semantics.  Correct all this by
>> using a kernel supplied function for fixed size devices.
>=20
> Doug, I think this should probably go in the rc, it fixes a 0-day bug.
>=20
> -Denny

It's in my next pull request.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Fvq1jDdPa92piwiGDdcnRSsntwW91uuX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIsjmAAoJELgmozMOVy/dstAP/3zSFt/P2kWXLw12RqJj6gGN
E+XtygtoycdfOrGfwhJ4gpBM2TgFwhxJVBFsOvkR+uH374FcgLYck958zf0bUdGg
KtT1I4erBgysgFDn1h0vAu4Q0Raln04DEKgdjEsHukSTzs0kDw55eOQ6evIP33cC
Ek7qw/5RCujTnihVjkflVkXJv14+7/lz9E0f14WzU1Jt8VCu+VUyja6j6ROwzmhd
p5KxW6nq8GynSgaKOGnrgt2UNLBwaKLgexWNGra8k0Qn3mBvDASRou1wzTmJiAo0
3N60vwHstot4uXxmzPWWlsKf02Fc52NBkUY4rOXpZI+hK8sTcr9qzOWajRkTryhL
J+0FqCTIe8jzuhoulqiLkYj05k0AOeLwJ1NERhY5jAX4t4vssgF5aOqI2yMU9Qol
grZHGGchAu6rVY5XNykxzkkx1TdR6DS7LK0iy7HSmuwZCeRJ1BEJpU1XM0rmHrxk
0chPCvgmlcgkcm0ADfzEd1UmOJLG022+AyMbj6wwn1w5xrM2wwcQ96ANwZKj8EPB
DzsZbI1axRlAkoTdz4D//X2gf6hP0gz1Lkbfe16vDqYUYCcm8gCYRHCVMzi1BPmI
1in9xyBRIcg0+N8dPwXBlZYVWAR3cJ1hFa4XuV0lABW7zvOuqerbQkHKaD2f2c18
cBwbCNhnwby2miYIbeDF
=DRHG
-----END PGP SIGNATURE-----

--Fvq1jDdPa92piwiGDdcnRSsntwW91uuX1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
