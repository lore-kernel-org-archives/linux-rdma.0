From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/rdmavt: Setting of QP timeout can
 overflow jiffies computation
Date: Sat, 22 Jul 2017 13:44:02 -0400
Message-ID: <a1660c46-98b1-9d2e-b488-ecd2bbc71b1a@redhat.com>
References: <20170617173620.17658.5173.stgit@scvm10.sc.intel.com>
 <20170617173723.17658.85726.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T7rbxiRAs8IqttGCT280UJqsNkCTeq8d3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170617173723.17658.85726.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T7rbxiRAs8IqttGCT280UJqsNkCTeq8d3
Content-Type: multipart/mixed; boundary="VhNs01NUPvBpMXE2T4WOP6gHeXN6Q7rS1";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn
 <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <a1660c46-98b1-9d2e-b488-ecd2bbc71b1a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/rdmavt: Setting of QP timeout can
 overflow jiffies computation
References: <20170617173620.17658.5173.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
 <20170617173723.17658.85726.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20170617173723.17658.85726.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--VhNs01NUPvBpMXE2T4WOP6gHeXN6Q7rS1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/17/2017 1:37 PM, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Current computation of qp->timeout_jiffies in rvt_modify_qp() will caus=
e
> overflow due to the fact that the input to the function usecs_to_jiffie=
s
> is only 32-bit ( unsigned int). Overflow will occur when attr->timeout =
is
> equal to or greater than 30. The consequence is unnecessarily excessive=

> retry and thus degradation of the system performance.
>=20
> This patch fixes the problem by limiting the input to 5-bit and calling=

> usecs_to_jiffies() before multiplying the scaling factor.
>=20
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--VhNs01NUPvBpMXE2T4WOP6gHeXN6Q7rS1--

--T7rbxiRAs8IqttGCT280UJqsNkCTeq8d3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc47iAAoJELgmozMOVy/dekgP/iKT3HBT8C0MbRqPGSluSJWl
39CBd5/dR4v8YXVakmX6dWjg2GZd3sR/UguN03YYDPbvtsiK9dFBTeYj8FJysu9m
7o7EXQo+7wM9d4dMF0etvwmMFN3wCRvm/Cx9yl2A9R2yxW4+svdOlCqITZA7lUl6
zvQ6kDpY3iJ5jV3S4wLid1tpR/0/YmZHp0OvAGr7iFk9oxQaD1oB04b45UWj29Rr
596GASpJ+Sa2pW23aj9Ot9YwEed4ZdUKopMdsZ5huIqulrs97Jaou0wlVTpJ7aiB
0azT7nAmgo0Cv3PKR6lCgv0l7o81QbzKjZ+6sxCs+MJ+T7MG/hK7pfUO/zFkUpFO
u3mM23OVNUr5jhIoxThz5jUiWCvMpb/NCsm7OG/2f6qdGEbTzZ25znxZg9nQlkV+
o0laVzfuWYDoYOCPJ90qnLhipEr6KtJ2rXWz4HdAu35ZNLWIeV6xs2uMz3dwQs2T
a3pOLcGPaITrdl43hNH4CQISZNhC/ulDczOTXpnt11JJomSyCoVSmpUbJkKeXXxe
QhgMm9UATHkmaIzOXsxf6W88VNyOWyc5r16lfAdX8YvcjovBIlcO/9oUPU3QcAf7
CY8LxL2qu0wPFNzZf02opq2+j5vQv906QK9FSUmX0Si8LdpEQl2/WrC9d1ldtgMa
PpHdbRU8+G2R1hDsQSzl
=UgW0
-----END PGP SIGNATURE-----

--T7rbxiRAs8IqttGCT280UJqsNkCTeq8d3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
