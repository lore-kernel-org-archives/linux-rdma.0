From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1 1/4] xprtrdma: Replace global lkey with lkey local to PD
Date: Mon, 21 Sep 2015 10:03:56 -0700
Message-ID: <4A6B165D-7603-4803-8B57-1FBDE5D921A5@oracle.com>
References: <1442853674-8677-1-git-send-email-sagig@mellanox.com> <1442853674-8677-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442853674-8677-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Sep 21, 2015, at 9:41 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
>=20
> From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> The core API has changed so that devices that do not have a global
> DMA lkey automatically create an mr, per-PD, and make that lkey
> available. The global DMA lkey interface is going away in favor of
> the per-PD DMA lkey.
>=20
> The per-PD DMA lkey is always available. Convert xprtrdma to use the
> device's per-PD DMA lkey for regbufs, no matter which memory
> registration scheme is in use.
>=20
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

You=E2=80=99ll probably need an Acked-by from Anna or Trond.


> ---
> net/sunrpc/xprtrdma/fmr_ops.c      | 19 -------------------
> net/sunrpc/xprtrdma/frwr_ops.c     |  5 -----
> net/sunrpc/xprtrdma/physical_ops.c | 10 +---------
> net/sunrpc/xprtrdma/verbs.c        |  2 +-
> net/sunrpc/xprtrdma/xprt_rdma.h    |  1 -
> 5 files changed, 2 insertions(+), 35 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_=
ops.c
> index cb25c89da623..f1e8dafbd507 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -39,25 +39,6 @@ static int
> fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
> 	    struct rpcrdma_create_data_internal *cdata)
> {
> -	struct ib_device_attr *devattr =3D &ia->ri_devattr;
> -	struct ib_mr *mr;
> -
> -	/* Obtain an lkey to use for the regbufs, which are
> -	 * protected from remote access.
> -	 */
> -	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
> -		ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
> -	} else {
> -		mr =3D ib_get_dma_mr(ia->ri_pd, IB_ACCESS_LOCAL_WRITE);
> -		if (IS_ERR(mr)) {
> -			pr_err("%s: ib_get_dma_mr for failed with %lX\n",
> -			       __func__, PTR_ERR(mr));
> -			return -ENOMEM;
> -		}
> -		ia->ri_dma_lkey =3D ia->ri_dma_mr->lkey;
> -		ia->ri_dma_mr =3D mr;
> -	}
> -
> 	return 0;
> }
>=20
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frw=
r_ops.c
> index d6653f5d0830..5318951b3b53 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -189,11 +189,6 @@ frwr_op_open(struct rpcrdma_ia *ia, struct rpcrd=
ma_ep *ep,
> 	struct ib_device_attr *devattr =3D &ia->ri_devattr;
> 	int depth, delta;
>=20
> -	/* Obtain an lkey to use for the regbufs, which are
> -	 * protected from remote access.
> -	 */
> -	ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
> -
> 	ia->ri_max_frmr_depth =3D
> 			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
> 			      devattr->max_fast_reg_page_list_len);
> diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma=
/physical_ops.c
> index 72cf8b15bbb4..617b76f22154 100644
> --- a/net/sunrpc/xprtrdma/physical_ops.c
> +++ b/net/sunrpc/xprtrdma/physical_ops.c
> @@ -23,7 +23,6 @@ static int
> physical_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
> 		 struct rpcrdma_create_data_internal *cdata)
> {
> -	struct ib_device_attr *devattr =3D &ia->ri_devattr;
> 	struct ib_mr *mr;
>=20
> 	/* Obtain an rkey to use for RPC data payloads.
> @@ -37,15 +36,8 @@ physical_op_open(struct rpcrdma_ia *ia, struct rpc=
rdma_ep *ep,
> 		       __func__, PTR_ERR(mr));
> 		return -ENOMEM;
> 	}
> -	ia->ri_dma_mr =3D mr;
> -
> -	/* Obtain an lkey to use for regbufs.
> -	 */
> -	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
> -		ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
> -	else
> -		ia->ri_dma_lkey =3D ia->ri_dma_mr->lkey;
>=20
> +	ia->ri_dma_mr =3D mr;
> 	return 0;
> }
>=20
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c
> index 682996779970..eb081ad05e33 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1252,7 +1252,7 @@ rpcrdma_alloc_regbuf(struct rpcrdma_ia *ia, siz=
e_t size, gfp_t flags)
> 		goto out_free;
>=20
> 	iov->length =3D size;
> -	iov->lkey =3D ia->ri_dma_lkey;
> +	iov->lkey =3D ia->ri_pd->local_dma_lkey;
> 	rb->rg_size =3D size;
> 	rb->rg_owner =3D NULL;
> 	return rb;
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xp=
rt_rdma.h
> index d252457ff21a..df5ad4e15702 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -66,7 +66,6 @@ struct rpcrdma_ia {
> 	struct rdma_cm_id 	*ri_id;
> 	struct ib_pd		*ri_pd;
> 	struct ib_mr		*ri_dma_mr;
> -	u32			ri_dma_lkey;
> 	struct completion	ri_done;
> 	int			ri_async_rc;
> 	unsigned int		ri_max_frmr_depth;
> --=20
> 1.8.4.3
>=20

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
