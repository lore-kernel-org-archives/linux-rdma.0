From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] RDMA/i40iw: Fixes for i40iw driver
Date: Thu, 28 Apr 2016 22:40:10 -0400
Message-ID: <5722C98A.902@redhat.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="39sRB9ciG7grlOHcItKSRheGrWmNJ8r96"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--39sRB9ciG7grlOHcItKSRheGrWmNJ8r96
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/22/2016 03:14 PM, Tatyana Nikolova wrote:
> This patch series includes a few fixes for the original
> Intel X722 iWARP driver i40iw.
>=20
> It is based on Doug Ledford's https://github.com/dledford/linux.git
> branch: k.o/for-4.6-rc.=20
>=20
> It needs to be applied after the patch series submitted by Mustafa Isma=
il -=20
> "[PATCH V3 00/16] RDMA/Intel X722 iWARP driver update"

I've taken both that set and this set into my for-next branch.

> Chien Tin Tung (1):
>   RDMA/i40iw: Correct STag mask to min of 14 bits
>=20
> Mohammad Khan (1):
>   RDMA/i40iw: Fix for a NOP WQE size
>=20
> Shiraz Saleem (3):
>   RDMA/i40iw: Fixes for WQE alignment
>   RDMA/i40iw: Fix for the size of kernel mode SQ
>   RDMA/i40iw: Fix for using one sge for RDMA READ
>=20
> Tatyana Nikolova (2):
>   RDMA/i40iw: Fix for checking if the QP is destroyed
>   RDMA/i40iw: Fix for removing quad hash entries
>=20
>  drivers/infiniband/hw/i40iw/i40iw_cm.c     |  4 +++-
>  drivers/infiniband/hw/i40iw/i40iw_d.h      |  2 ++
>  drivers/infiniband/hw/i40iw/i40iw_hw.c     |  3 ++-
>  drivers/infiniband/hw/i40iw/i40iw_status.h |  1 +
>  drivers/infiniband/hw/i40iw/i40iw_uk.c     | 26 ++++++++++++++++++++++=
++--
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c  | 10 +++++++---
>  6 files changed, 39 insertions(+), 7 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--39sRB9ciG7grlOHcItKSRheGrWmNJ8r96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIsmKAAoJELgmozMOVy/di4oP+wT0YRBQDqngwVUMYxLd06nN
dp7M9G1/s7cM13JErkwVpkFefVTJEnATfhmOCyMfmnCq8hDFul6ivr8X+KlEWR/K
g/EcIEP89IGUG7xowLac2rkP13Hb9NaHnXUfYHWQj9K4v6p3GSt/ehrAgPwlLRC8
3RxEBW9//zM+qkNPwhsyE7KhDrzDSfplOiNNPuP6yoQwmvR3LrP51IrNTU/d0ezg
/zZad94VdeKl7rXdU4tV8LIWWNE3o6smbLHX8EV5tp3TJNPs42ZVjaWhyz45zpYJ
BKkW0bvM97akU7NN1kG6xj65TBEzGgJvYBA66qJ4Er2d3nQ2n2ucA74nATXhXv0/
lFSG/r+OSvm5tZ+y+7lMWz6Z9mYqh8qzB+hcUvxmu6fFGOAhCny6OPLLS+WEzIzA
AxrfTXNGQ5WFN1DllV3GObPfFOE1gN77lqkFdnh+vtisPIWVwXmR2GpDduC6rCvc
ul+ATz7Rpfg4F16ISlYaJkgeqRxGD4lOZOQAk4yBwIFcHhcm+nXyZxYy/+q3NkbW
mM5ilR5NuHa8wDhqlkJLdYrDnxp5Dh/JzFGRGzte35Z5NZga8N8p4rJ1sMpHI0PJ
bPcfGpllulmicMv+4jzVRrkMqLbH912cLiZByM5kU3HrJyr/SO2B2m+jIDy4XG7m
xxOa1gZMxvFEcrlCW0Fu
=ZMOc
-----END PGP SIGNATURE-----

--39sRB9ciG7grlOHcItKSRheGrWmNJ8r96--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
