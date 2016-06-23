From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] RDMA/Intel X722 iWarp driver fixes
Date: Thu, 23 Jun 2016 10:36:17 -0400
Message-ID: <36720536-9916-49df-2af2-4349d06ad7de@redhat.com>
References: <1465941259-4492-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pgGCpQPrmW1lpQ6HXx8Btov1OCJDVCdpQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465941259-4492-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pgGCpQPrmW1lpQ6HXx8Btov1OCJDVCdpQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/14/2016 05:54 PM, Shiraz Saleem wrote:
> This patch series includes fixes for the Intel X722 iWARP driver i40iw.=

>=20
> It is based on Doug Ledford's https://github.com/dledford/linux.git
> branch: k.o/for-4.7-rc.=20
>=20
> Faisal Latif (2):
>   i40iw: Correct status check on i40iw_get_pble
>   i40iw: Return correct max_fast_reg_page_list_len
>=20
> Shiraz Saleem (2):
>   i40iw: Correct CQ arming
>   i40iw: Enable level-1 PBL for fast memory registration
>=20
>  drivers/infiniband/hw/i40iw/i40iw.h       |  2 ++
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 17 +++++++++++++----
>  2 files changed, 15 insertions(+), 4 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--pgGCpQPrmW1lpQ6HXx8Btov1OCJDVCdpQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa/PhAAoJELgmozMOVy/dOREQAK/1HOtrzArvduPUfL8r0xBW
ZkNWpJWUXP5PaP816JOaUd4Cxk5g+NdkO7gNz22DkSrOuoUO9svjepRFrAHvLw6V
HoVPa+nmlBqHiTbl59ZAFNtQq46MZQx4nUhu7W3gAML5LDsjk5QhxU6novdEWEsy
tVi1PGnCIrjWb4sjkrCn6OHPXN2awYXiZZDM4AcxDx+rLx35K8EK2QlicP/mRixC
V15AAnRWQ8fqrIOC8mqsDHtwlcmYejDu+UtVhJsyUGU5jFb9MMSnWJ/SJlvIZttc
CFpdillSxnP7BPc+uklXhRY/vM3xUYyJ6OiJGd/Ia0WEoyKcEE9ziVLamMys0jur
2xR3l4xU3WLU/4E0PrZcwR6+Q2sIjIkWefYrQ5ulrIrs3pGrSBiYZWFrarYHvwSj
sLdodQpWfLHnGWw3dlGxuKKYE8UOq1Faf2UuXkyapFQ1ZKpPIFzYmIj1XkN9Rrmt
YhPzr7H2xttbpRnF51t5ksL7VKQ+8KBNpmYNgb8cohzJehXOWzNyHV5NYZOvnkOC
oKqr7tHLJX3/gJk8VcE4Ly2h7Nlt/NgVz8MMKrMmeoHHIyqjVd2d4dWgJOewQYqi
jkqHAUGcz7sZt2InSRIx+Z0TFF64JuXJoZzQUAenfbTe5OcXxSS0bC3apV6rS2LI
udoCQ7Op3pgM9kptsQhL
=01/L
-----END PGP SIGNATURE-----

--pgGCpQPrmW1lpQ6HXx8Btov1OCJDVCdpQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
