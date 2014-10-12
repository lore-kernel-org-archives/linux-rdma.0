From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] IB/mlx5: Implement Fast Indirect Memory Registration
 Feature
Date: Sun, 12 Oct 2014 21:39:10 +0200
Message-ID: <543AD8DE.5060404@mellanox.com>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412693281-6161-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 10/7/2014 4:48 PM, Sagi Grimberg wrote:
>
> * Nit change in mr_align() static routine to handle void*
> instead of __be64.

nit comment... any reason not to put in different and unrelated to this 
series patch?

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c


> +static void set_indir_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
> +				  struct ib_send_wr *wr)
> +{
> +	u64 mask;
> +	u32 list_len = wr->wr.indir_reg.indir_list_len;
> +
> +	memset(umr, 0, sizeof(*umr));
> +
> +	umr->klm_octowords = get_klm_octo(list_len * 2);
> +	mask = MLX5_MKEY_MASK_LEN		|
> +		MLX5_MKEY_MASK_PAGE_SIZE	|
> +		MLX5_MKEY_MASK_START_ADDR	|
> +		MLX5_MKEY_MASK_EN_RINVAL	|
> +		MLX5_MKEY_MASK_KEY		|
> +		MLX5_MKEY_MASK_LR		|
> +		MLX5_MKEY_MASK_LW		|
> +		MLX5_MKEY_MASK_RR		|
> +		MLX5_MKEY_MASK_RW		|
> +		MLX5_MKEY_MASK_A		|
> +		MLX5_MKEY_MASK_FREE;
> +
> +	umr->mkey_mask = cpu_to_be64(mask);
> +}

here you basically replicate the majority of the code from 
set_reg_umr_segment - share the common part...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
