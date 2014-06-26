From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx5: Add driver for Mellanox Connect-IB adapters
Date: Thu, 26 Jun 2014 13:37:43 +0300
Message-ID: <20140626103743.GA12352@mtldesk30>
References: <20140620175832.GA11900@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140620175832.GA11900@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 20, 2014 at 08:58:32PM +0300, Dan Carpenter wrote:
>    976	
>    977	err_create:
>    978		if (qp->create_type == MLX5_QP_USER)
>    979			destroy_qp_user(pd, qp);
>                         ^^^^^^^^^^^^^^^
> But we dereference it inside destroy_qp_user() unconditionally.
> 
>    980		else if (qp->create_type == MLX5_QP_KERNEL)
>    981			destroy_qp_kernel(dev, qp);
> 

When we get here we already updated create_type and since all
MLX5_QP_USER type QPs have PD the logic is not broken.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
