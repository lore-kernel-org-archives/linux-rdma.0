From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Pull uninitialized_var into util/compiler.h
Date: Sun, 9 Oct 2016 08:46:01 +0300
Message-ID: <20161009054601.GB9282@leon.nu>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475879772-29458-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AdjLlRqdF7kYRNze"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475879772-29458-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AdjLlRqdF7kYRNze
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 07, 2016 at 04:36:08PM -0600, Jason Gunthorpe wrote:
> The new common definition turns it off for new compilers since
> it is not needed and is too easy to abuse.

Jason,
I have two comments.

1. Can we remove this uninitialized_var at all and simply replace by
default values?
We have 5 places like this:
=E2=9E=9C  rdma-core git:(master) grep -r uninitialized_var */src/*.c
libcxgb4/src/cq.c:      struct t4_cqe uninitialized_var(cqe), *rd_cqe;
libcxgb4/src/qp.c:      u8 uninitialized_var(len16);
libmlx4/src/qp.c:       struct mlx4_wqe_ctrl_seg *uninitialized_var(ctrl);
libmlx5/src/qp.c:       uint32_t *uninitialized_var(p);
libmlx5/src/qp.c:                       int uninitialized_var(sz);

2. Do we really want additional folder to ccan with such common headers?
What about rename ccan to be util and put this new file there (in case
you proceed with it)?

Thanks

>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt             |  1 +
>  providers/cxgb4/cq.c       |  1 +
>  providers/cxgb4/libcxgb4.h |  2 --
>  providers/cxgb4/qp.c       |  1 +
>  providers/mlx4/mlx4.h      |  4 ----
>  providers/mlx4/qp.c        |  1 +
>  providers/mlx5/mlx5.h      |  4 ----
>  providers/mlx5/qp.c        |  1 +
>  util/CMakeLists.txt        |  3 +++
>  util/compiler.h            | 18 ++++++++++++++++++
>  10 files changed, 26 insertions(+), 10 deletions(-)
>  create mode 100644 util/CMakeLists.txt
>  create mode 100644 util/compiler.h
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index b0864da660fc..1611e90d7933 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -253,6 +253,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INC=
LUDE}/config.h" ESCAPE_QUOT
>  #-------------------------
>  # Sub-directories
>  add_subdirectory(ccan)
> +add_subdirectory(util)
>  # Libraries
>  add_subdirectory(libibumad)
>  add_subdirectory(libibumad/man)
> diff --git a/providers/cxgb4/cq.c b/providers/cxgb4/cq.c
> index 1ed7dfdb88d4..5f662ac49d0c 100644
> --- a/providers/cxgb4/cq.c
> +++ b/providers/cxgb4/cq.c
> @@ -37,6 +37,7 @@
>  #include <sys/errno.h>
>  #include <netinet/in.h>
>  #include <infiniband/opcode.h>
> +#include <util/compiler.h>
>  #include "libcxgb4.h"
>  #include "cxgb4-abi.h"
>
> diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
> index 4c8383209287..9a4bc98f34e9 100644
> --- a/providers/cxgb4/libcxgb4.h
> +++ b/providers/cxgb4/libcxgb4.h
> @@ -264,6 +264,4 @@ void dump_state();
>  extern int stall_to;
>  #endif
>
> -#define uninitialized_var(x) x =3D x
> -
>  #endif				/* IWCH_H */
> diff --git a/providers/cxgb4/qp.c b/providers/cxgb4/qp.c
> index 384bf11369ac..95b459a1a9b4 100644
> --- a/providers/cxgb4/qp.c
> +++ b/providers/cxgb4/qp.c
> @@ -37,6 +37,7 @@
>  #include <string.h>
>  #include <stdio.h>
>  #include <netinet/in.h>
> +#include <util/compiler.h>
>  #include "libcxgb4.h"
>
>  #ifdef STATS
> diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
> index 95a6521c457b..a2d39e169c15 100644
> --- a/providers/mlx4/mlx4.h
> +++ b/providers/mlx4/mlx4.h
> @@ -43,10 +43,6 @@
>
>  #define MLX4_PORTS_NUM 2
>
> -#ifndef uninitialized_var
> -#define uninitialized_var(x) x =3D x
> -#endif
> -
>  #include <valgrind/memcheck.h>
>
>  #define PFX		"mlx4: "
> diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
> index 4b5acd71108e..268fb7dc83dd 100644
> --- a/providers/mlx4/qp.c
> +++ b/providers/mlx4/qp.c
> @@ -39,6 +39,7 @@
>  #include <pthread.h>
>  #include <string.h>
>  #include <errno.h>
> +#include <util/compiler.h>
>
>  #include "mlx4.h"
>  #include "doorbell.h"
> diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
> index f8674c7a90db..cb65429b51f7 100644
> --- a/providers/mlx5/mlx5.h
> +++ b/providers/mlx5/mlx5.h
> @@ -48,10 +48,6 @@
>  #define unlikely(x)	__builtin_expect((x), 0)
>  #endif
>
> -#ifndef uninitialized_var
> -#define uninitialized_var(x) x =3D x
> -#endif
> -
>  #include <valgrind/memcheck.h>
>
>  #ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
> diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
> index 04abe1588d6e..e82b1a0bebc3 100644
> --- a/providers/mlx5/qp.c
> +++ b/providers/mlx5/qp.c
> @@ -38,6 +38,7 @@
>  #include <string.h>
>  #include <errno.h>
>  #include <stdio.h>
> +#include <util/compiler.h>
>
>  #include "mlx5.h"
>  #include "doorbell.h"
> diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
> new file mode 100644
> index 000000000000..1cda8905d8f4
> --- /dev/null
> +++ b/util/CMakeLists.txt
> @@ -0,0 +1,3 @@
> +publish_internal_headers(util
> +  compiler.h
> +  )
> diff --git a/util/compiler.h b/util/compiler.h
> new file mode 100644
> index 000000000000..9b57e048df4b
> --- /dev/null
> +++ b/util/compiler.h
> @@ -0,0 +1,18 @@
> +/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file */
> +#ifndef UTIL_COMPILER_H
> +#define UTIL_COMPILER_H
> +
> +/* Use to tag a variable that causes compiler warnings. Use as:
> +    int uninitialized_var(sz)
> +
> +   This is only enabled for old compilers. gcc 6.x and beyond have excel=
lent
> +   static flow analysis. If code solicits a warning from 6.x it is almost
> +   certainly too complex for a human to understand.
> +*/
> +#if __GNUC__ >=3D 6 || defined(__clang__)
> +#define uninitialized_var(x) x
> +#else
> +#define uninitialized_var(x) x =3D x
> +#endif
> +
> +#endif
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AdjLlRqdF7kYRNze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+dmZAAoJEORje4g2clinRcMP/RHFtbh1U9VLKewIiwKuemxL
dpaucVzu4hZS+R3uje93dfC36+/s6ng9/0sSM8U9uK4DZ5ceMRjbdhQmNR1kgCWN
qFND834EtZV6WqwrBy9Cgd8MICaiNUxwmyQ/VCKv0f/pekjM2+rsXGUAE0hkzV/K
lqIpyxNknIEMpJgWsgfFW4iHfO4NvzNEqyNM4TX4lVfEAyIJqcv33q/yuy9DvRR7
FBpnhML2hoIMHMs8EtcBQzfJUq4TalYrWVV95ywskixmBZP/nvcKyYg7svwF4thM
NLE0CbDMaicz5Cg+N2hOwgHUtGS5VL6DjU4o0ANvjfX49rDx/Hi2nx1VW/stpFW7
aazfzTIY2ewbDZhNGl8RJLw6sdurDpaH8fjlw7HEpTIY1ifSK3Kq1GGlJXQiar1y
ObmPMkxr+aDq0y2sgkpYNHTQB/3d/y2VQ7Cv7m0932HMsNejBN/FCRtGO6wA0xYK
3hdL9VgVEzw5qNAvqtW0im34f+YzbGTKWg//LJJtEcCyvg1dMbeJIkSWeraxmVlg
lJ0jGp29QUd4PRVQYOZ4UfYKtXhwBdaWeSjADzh1LbBr+GyUYGY/SqcOBWYn614A
uqq5wiCxM/IXORUEHM806tZm5nEiSgyV13L7EB6ZVvyHLYMjDwOSRyKGmxbgXAE4
9+475f4MuEvlgrQ7K8Yg
=RMQr
-----END PGP SIGNATURE-----

--AdjLlRqdF7kYRNze--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
