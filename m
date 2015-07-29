From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/amso1100: deprecate the amso1100 provider
Date: Wed, 29 Jul 2015 11:11:39 -0400
Message-ID: <55B8ED2B.1020206@redhat.com>
References: <20150729144646.C1FF1E0B55@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MXVoMo3BXRsFifB5bNIBEdJLCPqLdCIro"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150729144646.C1FF1E0B55-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MXVoMo3BXRsFifB5bNIBEdJLCPqLdCIro
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/29/2015 10:44 AM, Steve Wise wrote:
> The HW hasn't been sold since 2005, and the SW has definite bit rot.
> Its time to remove it.  So move it to staging for a few releases and
> then remove it after that.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MXVoMo3BXRsFifB5bNIBEdJLCPqLdCIro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuO0rAAoJELgmozMOVy/dvVkP/RHME3mpCWl/H3F/0XkLWCt/
TxGLomkPFzZdlaHrP+I/7t9vYnoeHR0/U1DESDEhGeycO8ZxOjo+M1ASsojz8cGe
0pCEsEV4449uprLapGDJRnhOwfI78dlddRRWXXjHOLjjZFYXFpfohc30gOEqyItx
ZU3B8lxmgnBk6sz4afzcsdgqmJHl9n+CmG7b8rSAqE69peaWjMGGjFJRs+4qjNgK
keJCeaCAKpOIaSqN/t44n8FeYWXsleb/7W4CHue3CfCC1PUuJGdpEDFtRVMVDaQc
RpDkV57H+3YmhvjGzE0nrAyHsQo6riFm/SEqPHSbJCb/zPR1riS4+DX1WRs/7nmx
7Nt1KQA1ouPe+Cg9Z/Zc3YZhI29s1IlEQJo4BvTMFBTbt3bijACIaQN8iD9KXF9U
LG2S3xTwqY4FA9jZeiANxOyq3PM//eAC4ugzdF/Rs7QVKMVcCLbNSBUAEI1UFcqs
rh2ExzNhEDABN9dg4khcGWS34zjsjtp/1Rn3F3z+NfHkpUz2yf8ZO7mZyqEc9BV8
HTT2izv0nqPFl9dOiv8JUlCNuvuJzWS5igKPvgJ+R/9o/LK4VN71dMbW/MdSLygN
3muN1LAc3TSpAT2lU9jawXpTu24veE6jbXNR4hS0+oLrNzaGFOmBSipMZ44Qx2G0
IEb1CFXZng2HkmNkE/oG
=J1Rw
-----END PGP SIGNATURE-----

--MXVoMo3BXRsFifB5bNIBEdJLCPqLdCIro--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
