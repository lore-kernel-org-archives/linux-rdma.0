From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/6] mlx5: Fix missing break statement in
 sq_overhead
Date: Tue, 31 Jan 2017 14:12:39 -0700
Message-ID: <20170131211239.GA22475@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1485896886-23517-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485896886-23517-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 02:08:03PM -0700, Jason Gunthorpe wrote:
> gcc 7.0.1 observes:
> 
> providers/mlx5/verbs.c:745:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    size = sizeof(struct mlx5_wqe_ctrl_seg) + mw_bind_size;
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>  providers/mlx5/verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
> index 04a5462ce41d03..60854402fec2d4 100644
> +++ b/providers/mlx5/verbs.c
> @@ -743,6 +743,8 @@ static int sq_overhead(enum ibv_qp_type	qp_type)
>  
>  	case IBV_QPT_XRC_SEND:
>  		size = sizeof(struct mlx5_wqe_ctrl_seg) + mw_bind_size;
> +		break;
> +
>  	case IBV_QPT_XRC_RECV:
>  		size = max(size, sizeof(struct mlx5_wqe_ctrl_seg) +
>  			   sizeof(struct mlx5_wqe_xrc_seg) +

Hum, looking again this confusing construction was probably as
intended before.. Yishai can you let me know?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
