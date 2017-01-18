From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 0/3] Common Provider Debug Printing
Date: Wed, 18 Jan 2017 07:26:36 +0200
Message-ID: <20170118052636.GR32481@mtr-leonro.local>
References: <1484682331-111172-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oCBD0SPT9UHZkBMO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484682331-111172-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--oCBD0SPT9UHZkBMO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2017 at 01:45:31PM -0600, Tatyana Nikolova wrote:
> Similar debug printing functionality is
> refactored to reduce code duplication in two
> rdma-core providers. Please review and comment
> whether the proposed debug printing approach
> should be adopted by the rdma-core providers.
>
> For more information about the issue this patch
> series addresses, see the email thread titled
> "[PATCH V2 08/10] i40iw: Control debug error prints using env variable"
>
> Tatyana Nikolova (3):
>   util: Add common code for provider debug
>   mlx5: Use common provider debug macros
>   qedr: Use common provider debug macros
>
>  buildlib/rdma_functions.cmake |   2 +-
>  providers/mlx5/buf.c          |  18 ++---
>  providers/mlx5/cq.c           |   6 +-
>  providers/mlx5/mlx5.c         |  51 ++++---------
>  providers/mlx5/mlx5.h         |  27 +------
>  providers/mlx5/qp.c           |  24 +++---
>  providers/mlx5/verbs.c        |  48 ++++++------
>  providers/qedr/qelr.h         |  57 +-------------
>  providers/qedr/qelr_main.c    |  68 +++--------------
>  providers/qedr/qelr_verbs.c   | 168 ++++++++++++++++++++++++------------------
>  util/CMakeLists.txt           |   8 ++
>  util/dbg.c                    |  83 +++++++++++++++++++++
>  util/dbg.h                    |  95 ++++++++++++++++++++++++
>  13 files changed, 358 insertions(+), 297 deletions(-)
>  create mode 100644 util/dbg.c
>  create mode 100644 util/dbg.h

Thanks Tatyana,

There is need to add new file to Documentation/ with description of
these common environmental variables.

And can you please add patch for i40iw debug prints to the final version too?

>
> --
> 1.8.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oCBD0SPT9UHZkBMO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh+/IwACgkQ5GN7iDZy
WKcJIRAAjE3x2uB+MB3961thNjkdVsLJL/Quw8tzV0dgvKB7qw6Y6rSnrMRVI3//
I5cpPd860tR+mMEp0WGvEwwrrYc3+FcyV6IoJW4uvMhjYYJH2zeo6Io3gJzfvgjf
YldSPUGVSUy+eRhQKih009Ctp3a4jE0gsn7/WZ/tzJK1z/PYqTkXREUbgfcf3pNj
iuh/At7ANe3M8ptSxspMxQzVhZCE+WJqTOY+G2WrJP/CS1pONNao/OHdcJvc6hnT
Wf5ZglXqLenYSG0XjyY2EOZfO4OR/x9nFdiOffinquDWGEAI9aDiviO/zlVsTNOu
QyV9RzDqndj7QJJExVBczwg2xKRTAUhk40bkEiLHq/+NblfjpCt+YDNCfDZDeAxN
qX2WuxTiIB63A1WgX6QGarFsEaIu6Jyx4dZVTTFF/y9fgZ474NOsRihzGQ/PObeu
Ujwr87WDyMw+HYpsgKIvozCNWdC4ziTAbJkw6eOu6dZTRJL7UEc7lhYam3RUs18f
bldHn8Lv0lru1eRsZQO6fv59cUGsB3gUMZg8fdFfK/itqtXLcJ2xILgq424+H/ll
CXR+/lFOdBaa3EW9psvWXH77JosDbpSjRbYsm1+4FRar52uXcyZTjTNuc2rtALy2
FcHkWpu8cguSwbRWzk8kcIPyQXQipNAuxWzMY4HK1TSIUqCyRLg=
=k6TG
-----END PGP SIGNATURE-----

--oCBD0SPT9UHZkBMO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
