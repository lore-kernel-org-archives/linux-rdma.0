From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] clang support
Date: Wed, 12 Oct 2016 14:07:13 -0400
Message-ID: <89bc834d-035b-b2bd-ed49-d0f20f57802e@redhat.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4WrqBLQ6P05IdPxo5pphr0PNrV8Lk9DGB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4WrqBLQ6P05IdPxo5pphr0PNrV8Lk9DGB
Content-Type: multipart/mixed; boundary="FGuv50aaS9HqEBKCRm7mFRURawC1owQve";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <89bc834d-035b-b2bd-ed49-d0f20f57802e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] clang support
References: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--FGuv50aaS9HqEBKCRm7mFRURawC1owQve
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/7/2016 6:36 PM, Jason Gunthorpe wrote:
> This series gets clang running warning free and has travis run the buil=
d
> through clang-3.9 so we don't break it again.
>=20
> Jason Gunthorpe (5):
>   Pull uninitialized_var into util/compiler.h
>   ibacm: Avoid clang 3.8 warning -Wmissing-field-initializers
>   mthca: Avoid bogus gcc 4.8 warning -Wmaybe-uninitialized
>   Improve linker flag detection to work with clang and -Werror
>   Update TravisCI to use clang 3.9 as well
>=20
>  .travis.yml                    | 20 +++++++++++++++++---
>  CMakeLists.txt                 | 22 ++++++++++++++--------
>  buildlib/FindLDSymVer.cmake    | 16 ++++++++++++----
>  buildlib/RDMA_EnableCStd.cmake | 25 +++++++++++++++++++++++++
>  ibacm/prov/acmp/src/acmp.c     |  2 +-
>  providers/cxgb4/cq.c           |  1 +
>  providers/cxgb4/libcxgb4.h     |  2 --
>  providers/cxgb4/qp.c           |  1 +
>  providers/mlx4/mlx4.h          |  4 ----
>  providers/mlx4/qp.c            |  1 +
>  providers/mlx5/mlx5.h          |  4 ----
>  providers/mlx5/qp.c            |  1 +
>  providers/mthca/qp.c           | 23 +++++------------------
>  util/CMakeLists.txt            |  3 +++
>  util/compiler.h                | 18 ++++++++++++++++++
>  15 files changed, 99 insertions(+), 44 deletions(-)
>  create mode 100644 util/CMakeLists.txt
>  create mode 100644 util/compiler.h
>=20

Series merged.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--FGuv50aaS9HqEBKCRm7mFRURawC1owQve--

--4WrqBLQ6P05IdPxo5pphr0PNrV8Lk9DGB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX/nvRAAoJELgmozMOVy/ddmEP/Agum43vPO5ykKX3iVWQAhZK
HW3iL8nd9FJK3HjER6HQARziTaLC9Tk3owqUIeqq/15yScgCK4TGjclsS1wyRvHW
83ci8MxH72w4S9t2nG2jt59/pTXNGrBpir5UetNctoQsm6ZhdlDuzVxBJ9FQYjEP
CTeL81zamvk28aaPsmq0XFc3ceJiO5Uj1RWaxg11LDl0/HSxhwkFBKVO4XiLnpxp
aH0KWh+ggRyuJ8efZG3BbeHw/Y3MdlWPSflVX/jkXBK/+o4462tUUMgS9vxAo4gJ
hk23wQ4xzxGGPhkutK8UJHzpRcgKBoHWCH12MxiY/9DhMPdqldnT0ks8M8qngqYd
jxg/aCQF30caPmoCSo3UG6HGs8/4JLmL1ZY1BU1ZmkIErq0UO+/EIUz+xF6JOpsR
m3shRRK3jktu58BKNMgJanxS+gMN7GOwmgjYoXYrRYAICMfvPRlSXQeDmXnYSgD3
qgcV50EOjfxyK1FtsJQqsYztQ/OJ+6cN8mIKnnukIbmQbsyUfflCV3N/cElsQrKr
6Hs9KNQWLlzMDyc9QSfkTlkkxjgk2J8K4nGvVErbm7CwDd4+oQX1c+a6ju2FQt0g
7kG/RrlwQcOBYHkw54ZlTMCW+OOxaSyeN6bMOrvS1chI08hyuKcxtwK1YQJJ7+Aq
Evu/YXvnq0LR1lhXrXTX
=V6JB
-----END PGP SIGNATURE-----

--4WrqBLQ6P05IdPxo5pphr0PNrV8Lk9DGB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
