From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH WIP 21/43] mlx5: Allocate a private page list in
 ib_alloc_mr
Date: Tue, 28 Jul 2015 13:57:00 +0300
Message-ID: <55B75FFC.6040200@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-22-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-22-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On 22/07/2015 09:55, Sagi Grimberg wrote:
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 ++++
>  drivers/infiniband/hw/mlx5/mr.c      | 45 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index c2916f1..df5e959 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -315,6 +315,11 @@ enum mlx5_ib_mtt_access_flags {
>  
>  struct mlx5_ib_mr {
>  	struct ib_mr		ibmr;
> +	u64		        *pl;
> +	__be64			*mpl;
> +	dma_addr_t		pl_map;
Nit: could you choose more descriptive names for these fields? It can be
difficult to understand what they mean just based on the acronym.

> +	int			ndescs;
This one isn't used in this patch, right?

> +	int			max_descs;
>  	struct mlx5_core_mr	mmr;
>  	struct ib_umem	       *umem;
>  	struct mlx5_shared_mr_info	*smr_info;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
