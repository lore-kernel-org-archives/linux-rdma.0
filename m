From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx5 1/7] Refactor mlx5_poll_one
Date: Wed, 1 Jun 2016 12:39:06 -0600
Message-ID: <20160601183906.GA3471@obsidianresearch.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
 <1464788882-1876-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464788882-1876-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 01, 2016 at 04:47:56PM +0300, Yishai Hadas wrote:
>  static void mlx5_handle_error_cqe(struct mlx5_err_cqe *cqe,
> -				  struct ibv_wc *wc)
> +				  enum ibv_wc_status *pstatus)
>  {

Yuk

 static enum ibv_wc_status mlx5_get_error_status(const struct mlx5_err_cqe *cqe)

>  	case MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR:
> -		wc->status = IBV_WC_LOC_LEN_ERR;
> +		*pstatus = IBV_WC_LOC_LEN_ERR;
>  		break;

	case MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR:
	        return IBV_WC_LOC_LEN_ERR;

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
