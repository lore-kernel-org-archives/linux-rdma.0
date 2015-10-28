From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mlx5: Publish mlx5 driver support for extended
 create QP
Date: Wed, 28 Oct 2015 10:32:25 -0600
Message-ID: <20151028163225.GA14310@obsidianresearch.com>
References: <1445993915-111262-1-git-send-email-eli@mellanox.com>
 <1445993915-111262-3-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445993915-111262-3-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2015 at 02:58:35AM +0200, Eli Cohen wrote:
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/hw/mlx5/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index f1ccd40..634de84 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1385,7 +1385,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
>  		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
>  		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
>  	dev->ib_dev.uverbs_ex_cmd_mask =
> -		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
> +		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
> +		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP);

Same comment as last time.

http://thread.gmane.org/gmane.linux.drivers.rdma/26110/focus=26163

This still hasn't been fixed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
