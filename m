From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core: cmake minimum version issue on RH 6.5
Date: Thu, 29 Sep 2016 11:08:55 -0400
Message-ID: <57ED2E87.50008@redhat.com>
References: <5169a490-10b4-cb9f-d7b7-fb552692f1f6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Pj5Oc3tWk0rKTA2WPCdwJGra4nPuv5cl6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5169a490-10b4-cb9f-d7b7-fb552692f1f6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gunthorpe Jason <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pj5Oc3tWk0rKTA2WPCdwJGra4nPuv5cl6
Content-Type: multipart/mixed; boundary="gTjl3DBtINAFpJ7dnN5wUsUChoS49QRpK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Gunthorpe Jason <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <57ED2E87.50008-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core: cmake minimum version issue on RH 6.5
References: <5169a490-10b4-cb9f-d7b7-fb552692f1f6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
In-Reply-To: <5169a490-10b4-cb9f-d7b7-fb552692f1f6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

--gTjl3DBtINAFpJ7dnN5wUsUChoS49QRpK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/29/16 7:40 AM, Yishai Hadas wrote:
> Hi Jason,
>=20
> Currently there is a hard requirement of cmake minimum version of 2.8.1=
1
> to build the rdma-core project. (i.e. cmake_minimum_required(VERSION
> 2.8.11 ATAL_ERROR)).
>=20
>=20
> Trying to build with default yum install of cmake on RH6.5 fails as it
> doesn't meet the above requirement. (i.e. cmake version 2.6-patch 4).
>=20
> As a test phase, we tried to comment out this limitation from the cmake=

> files, however, the build failed with few other errors. (e.g. CMake
> Error at buildlib/rdma_functions.cmake:39 (set_property):
> set_property could not find TARGET APPEND_STRING. Perhaps it has not ye=
t
> been created).
>=20
> Is it a real requirement for above cmake minimum version in this projec=
t
> ? if yes, where the appropriate cmake should come from to work on RH6.5=
=2E
>=20
> Yishai
>=20
>=20

Is anyone really running 6.5?  I mean the current version in the 6
family is 6.8, and there are significant improvements between 6.5 and 6.8=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--gTjl3DBtINAFpJ7dnN5wUsUChoS49QRpK--

--Pj5Oc3tWk0rKTA2WPCdwJGra4nPuv5cl6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7S6HAAoJELgmozMOVy/dRYUP/ibQ27rGwrHiTQqJfdHt9r8Z
A2hOTTbqlvq7kqzyxD64BuWcVVpT2BPqN8U68YHYE3nYgxjAdKFEMJgl/Wtqewha
rOyZUC+jN5GuV9+wwJ4ljZlUHxAi3G3NSQxoOh83op49YjhAKo4mqVRWW9jb7Cti
VMSks1uPay6+IUa1jaB+1TZiYo6BQpEY4JcFqE/c2bMWgyxIDj4NfE7MGlRk2m9U
1y3cr/roJsowNif5htBQDh0TCSabHnEVoF7ZMy9W0cbHQyhw76TipqgbUlSJCCkP
wT2RpfmPlDZ6JVBsv01Ou3ifXv6IRIJaKmwz1uiNq8HPx9IJH/AIVKEYN53jOt97
RaZ9VYWXKkU1uqVxwUkWdpwn/cxgSJttmG9jODSsyP400mUbPRbt8Sbv2fMHwpK4
1Ax5TKk2zl+j6s1DtCqf/svfV2ouiPW0Z5a5taY23n5Q0Z79fXAfsIpHPZiKr1/B
NJ7zVLHi0JDmBo0blKWt5oklpFOOCwDqR5fd0ZHumWC8SUTpZyYG0pEyAPFlu1cL
8KbHtDOnwOj6yuIX1S7nXpJZXzF8vCGAAwUyWtrzE/vfFu62B5awfD6ipG0R7EDi
GB9WbDRbN767EyGblzzaE5wCoLICF1PiyHs8t+3Pl4K8bsi0T5cT0WtwB0sCydvV
zF1n9BI9Ch75sXPtJpRb
=djIx
-----END PGP SIGNATURE-----

--Pj5Oc3tWk0rKTA2WPCdwJGra4nPuv5cl6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
