From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Tue, 12 Jan 2016 15:37:11 +0100
Message-ID: <1452609431.9500.24.camel@opteya.com>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452594732-9573-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 12 janvier 2016 =C3=A0 12:32 +0200, Sagi Grimberg a =C3=A9crit=
=C2=A0:
> mlx5 keeps a lot of internal accounting for wr processing.
> mlx5_ib_wq consists of multiple arrays:
> struct mlx5_ib_wq {
> 	u64		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*wrid;
> 	u32		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*wr_data;
> 	struct wr_list	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*w_list;
> 	unsigned	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*wqe_head;
> 	...
> }
>=20
> Each time we access each of these arrays, even for a single index
> we fetch a cacheline. Reduce cacheline bounces by fitting these
> members
> in a cacheline aligned struct (swr_ctx) and allocate an array.
> Accessing
> this array will fetch all of these members in a single shot.
>=20
> Since the receive queue needs only the wrid we use a nameless union
> where in the rwr_ctx we only have wrid member.
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/hw/mlx5/cq.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0| 18 +++++++--------
> =C2=A0drivers/infiniband/hw/mlx5/mlx5_ib.h | 21 +++++++++++++----
> =C2=A0drivers/infiniband/hw/mlx5/qp.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0| 45 +++++++++++++++-----------
> ----------
> =C2=A03 files changed, 44 insertions(+), 40 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index d4b227126265..84cb8fc072a1 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -129,11 +129,24 @@ struct wr_list {
> =C2=A0	u16	next;
> =C2=A0};
> =C2=A0
> +/* Please don't let this exceed a single cacheline */

Don't add a comment, add a compile time assert:

BUILD_BUG_ON(sizeof(struct swr_ctx) <=3D L1_CACHE_BYTES);

> +struct swr_ctx {
> +	u64		wrid;
> +	u32		wr_data;
> +	struct wr_list	w_list;
> +	u32		wqe_head;
> +	u8		rsvd[12];
> +}__packed;
> +

Packing the structure might make some fields unaligned and, on some
architecture, unaligned access are likely unwelcomed.

What about

struct swr_ctx {
	u64		wrid;
	u32		wr_data;
	struct wr_list	w_list;
	u32		wqe_head;
} ____cacheline_aligned;


> +struct rwr_ctx {
> +	u64		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wrid;
> +}__packed;
> +
> =C2=A0struct mlx5_ib_wq {
> -	u64		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*wrid;
> -	u32		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*wr_data;
> -	struct wr_list	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*w_list;
> -	unsigned	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*wqe_head;
> +	union {
> +		struct swr_ctx *swr_ctx;
> +		struct rwr_ctx *rwr_ctx;
> +	};
> =C2=A0	u16		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsig_cou=
nt;

Check the structure layout is the one you expect with pahole.


diff --git a/drivers/infiniband/hw/mlx5/qp.c
> b/drivers/infiniband/hw/mlx5/qp.c
> index 1ea049ed87da..a6b88902d7af 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -794,14 +794,11 @@ static int create_kernel_qp(struct mlx5_ib_dev
> *dev,
>=C2=A0=C2=A0		goto err_free;
>=C2=A0=C2=A0	}
>=C2=A0=C2=A0
> -	qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wrid),=C2=A0=
GFP_KERNEL);
> -	qp->sq.wr_data =3D kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wr_data)=
, GFP_KERNEL);
> -	qp->rq.wrid =3D kmalloc(qp->rq.wqe_cnt * sizeof(*qp->rq.wrid),=C2=A0=
GFP_KERNEL);
> -	qp->sq.w_list =3D kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.w_list), =
GFP_KERNEL);
> -	qp->sq.wqe_head =3D kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wqe_hea=
d), GFP_KERNEL);
> -
> -	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid ||
> -	=C2=A0=C2=A0=C2=A0=C2=A0!qp->sq.w_list || !qp->sq.wqe_head) {
> +	qp->sq.swr_ctx =3D kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.swr_ctx),
> +				=C2=A0GFP_KERNEL);
> +	qp->rq.rwr_ctx =3D kcalloc(qp->rq.wqe_cnt, sizeof(*qp->sq.rwr_ctx),
> +				=C2=A0GFP_KERNEL);
>=C2=A0

Anyway, I'm not sure about the alignment of the memory returned by
kcalloc(), I should have known by the time but don't find time to
figure how it's handled on various SL*B allocator implementation.

Regards.

--=C2=A0
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
