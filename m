From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Wed, 20 Apr 2016 16:46:57 -0400
Message-ID: <5717EAC1.6020602@redhat.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
 <20160419173817.GF20844@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x5sHkOIIUt0wfa6DalUWqlgcDawMTPa1A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0439B0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x5sHkOIIUt0wfa6DalUWqlgcDawMTPa1A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/19/2016 04:44 PM, Hefty, Sean wrote:
>> Right - and the RDMA uAPI has always had an integrated driver-bypass
>> channel as part of the verb uAPI calls, extending that to allow for
>> new-driver-specific calls seems very natural.
>=20
> I remain unconvinced that having the equivalent of:
>=20
> 1 open unrelated-interface
> 2 ioctl open-file
> 3 close unrelated-interface
>=20
> is desirable.  If you want to push for a generic mechanism for mapping =
NIC resources into user space, then separate that from the device impleme=
ntation.
>=20
> Doug, can you weigh in here with your thoughts?
>=20

Yeah.  I've been off working on issues related to 4.6-rc (interfaces
that are DOA).  Give me a little bit to catch up on the thread and I'll
weigh in.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--x5sHkOIIUt0wfa6DalUWqlgcDawMTPa1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXF+rBAAoJELgmozMOVy/dNusP/301iLcL91serK2DQzQMsDC4
HNXTtAK9dYqOQ4RkgRK9Mjez0nq8oNCc3BM0huttR83HwfUgQmnGStETj95ZhCdw
s03UEq+747ykjpZz3R0N+2V0X97z5lPx/wOJ3+gM1anTShZclhQsBd3yq6LW1V/f
lgsJaHY2V9B9vw4v0aIOnvgkq2sgp+lqc2eB2cABLYDepYLMLGtMkjfGYL/SLArJ
H05k1nWmzD7RQm2RSWs/xLMw/1fxYGOmEKBUgVrUuoNpon2Uie5qwHoXSCH//Jkk
eKAR/vKMtdvuEji7NopglJtTZEjc0I8v0SVWzHx9wxB0bF03YXZvQmvJxYsiYz5V
rOHSuCbr1eno+L0/glSc715CkyCBT9tOAfpIQHyxWwOfvcdd+f24rvD5kuIvjZCu
IButw8TrrzfUNKfeVvmOc+1TDx0fVoWtlFbfVaIhE9VTv5dQS3Hrmr5aX2uV2G2p
1/AgETr+chGgILdER0DKJO1yF72fo+yMY5MB513aFNVdq/SVTrvEegc1WWkuKr8E
vhAIqhB7k2/inMa35y8s71w++Y3vPunIl2NbvwuxUhniMpId7Ip/YUBbrIGyXh+h
GsdeIoHf36a3o1vLv4EDcrQJNTj4gfqoQrcMyL5xaJgylmO76seE2TMxcrjnua+4
H8stVHdh7jeWdsm3yy7a
=wdrq
-----END PGP SIGNATURE-----

--x5sHkOIIUt0wfa6DalUWqlgcDawMTPa1A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
