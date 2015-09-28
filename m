From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 16:49:26 -0400
Message-ID: <5609A7D6.9030808@redhat.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com> <5609A19A.806@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A904D40B@ORSMSX109.amr.corp.intel.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250AFC@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SkDGhNPjkNhtW8Ax2uSqWwiFrXIA805fw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7D250AFC-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SkDGhNPjkNhtW8Ax2uSqWwiFrXIA805fw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/28/2015 04:40 PM, Woodruff, Robert J wrote:
> Sean wrote,
>> The issue is that basically no one tests the releases of the packages.=
 =20
>=20
> We assume that the maintainer of the package tests it before they relea=
se it :)

Every package maintainer I know of does.  But there isn't a single
package maintainer that has a 100% test setup that covers all of the
various ways in which their code is used.  Maintainer testing should be
considered good, but *never* sufficient for release testing.  There
needs to be more done.

> The OFED testing then tests all the currently released packages

This is backwards IMO.  Testing after the release results in exactly
what I mentioned in my email.  The right time to test is during the
release process, not after it is already complete.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SkDGhNPjkNhtW8Ax2uSqWwiFrXIA805fw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCafWAAoJELgmozMOVy/dITUQAKlseK5V/DFj/LB0iQ5zPmK9
Rbs9OeLEG6rnIV9S5LedwGfBGj2Bn4twZ2ssvPUZhSaJRaLbF82mgproiVsyfdY+
arvkNuCSQhuBG312WiHEGeX+ykUSxqv9BPIri7tingSUvZCrwntjDILy39rcUokT
C+zG2avilEcGTCMF9/l5mUa4giJti8RGem0VX4tg9thDXFMQ/99fvA3uhjDfoPnX
fzuQSwrbUNnj2o8lzEQttIRIIp+eiki4YWJv3tmUMVAIOPC7k4yAsCNFbZXM1aUh
cym1u+P7ac9rkqW5U/lUGKidRHCbpsXPZF/1NOoAIgjG6TWtt4zyUnDoeKRz9/RU
/gNhOSnTiWIsXjz/SeAjr2H7CqRhyVIps7Fg7vy2lSDMvaTkHVdAc+6uJ4geJnjL
hcJwtJHVx5Sn1/Dm31RYt9QoWTYxPMjKILBoKTdRvy6tBQgwtP6nPtDLcEROCtM5
8zG2e70sGEgrp5yjnCXmE3bV9TK19z/CEXUnNjVb9+KMVpqxK8ca2ehhZlTW6P/y
1bX6fQxb3AwxNpF8D8WdYA276HV8DH5IZOZ1zkj2k+Zcd6L61zj/a98ReiVBZz2s
uhJ5oFTvd4Ha3o6zuwDEmHyaAL5Ws9iY5Fxmw4YPGLmTiIKlBVyIcLIKj4l/E6kS
wBUrulzY6LrOZU6G2CYA
=Iqtr
-----END PGP SIGNATURE-----

--SkDGhNPjkNhtW8Ax2uSqWwiFrXIA805fw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
