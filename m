From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 01:24:22 +0000
Message-ID: <20190307012417.GU1758@mellanox.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307010153.81157-1-bvanassche@acm.org>
Content-Language: en-US
Content-ID: <A8AD71A8C1147B4C987C76406F5F818A@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 06, 2019 at 05:01:53PM -0800, Bart Van Assche wrote:
> This patch avoids that the following warning is reported when building
> the mlx5 driver with W=3D1:
>=20
> drivers/infiniband/hw/mlx5/qp.c: In function set_user_rq_size:
> ./include/linux/overflow.h:230:6: warning: comparison of unsigned express=
ion >=3D 0 is always true [-Wtype-limits]
>    _s >=3D 0 && _s < 8 * sizeof(*d) ? _s : 0;  \
>       ^
> drivers/infiniband/hw/mlx5/qp.c:5820:6: note: in expansion of macro check=
_shl_overflow
>   if (check_shl_overflow(rwq->wqe_count, rwq->wqe_shift, &rwq->buf_size))
>       ^~~~~~~~~~~~~~~~~~
>=20
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Fixes: 0c66847793d1 ("overflow.h: Add arithmetic shift helper") # v4.19
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>  include/linux/overflow.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index 40b48e2133cb..8afe0c0ada6f 100644
> +++ b/include/linux/overflow.h
> @@ -202,6 +202,24 @@
> =20
>  #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
> =20
> +/*
> + * Evaluate a >=3D 0 without triggering a compiler warning if the type o=
f a
> + * is an unsigned type.
> + */
> +#define is_positive(a) ({					\
> +	typeof(a) _minus_one =3D -1LL;				\
> +	typeof((a) + 0U) _sign_mask =3D _minus_one > 0 ? 0 :	\

This is probably just is_signed_type(a)

> +				1ULL << (8 * sizeof(a) - 1);	\
> +								\
> +	((a) & _sign_mask) =3D=3D 0;				\


This is the same sort of obfuscation that Leon was building, do you
think the & is better than his =3D=3D, >  version?

Will gcc shortcircuit the warning if we write it as

(is_signed_type(a) && a < 0)

?

Jason
