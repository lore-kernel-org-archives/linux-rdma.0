From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Mon, 15 Jan 2018 16:06:16 -0700
Message-ID: <20180115230616.GB1867@ziepe.ca>
References: <20180112055842.23125-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112055842.23125-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:

> Leon Romanovsky (1):
>   RDMA/mlx5: Fix out-of-bound access while querying AH

This one when to for-rc and it causes a merge conflict with for-next
we will have to handle

> Bodong Wang (1):
>   IB/core: Fix ib_wc structure size to remain in 64 bytes boundary

> Jack Morgenstein (1):
>   IB/mlx4: Fix incorrectly releasing steerable UD QPs when have only ETH
>     ports
> 
> Parav Pandit (1):
>   RDMA/core: Fix avoid decoding iWarp port as RoCE

These three went to for-next, I rewrote the commit message for the
last one

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
