From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] DMAC RoCE refacting code
Date: Mon, 15 Jan 2018 16:07:10 -0700
Message-ID: <20180115230710.GD1867@ziepe.ca>
References: <20180109132453.29038-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109132453.29038-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 03:24:49PM +0200, Leon Romanovsky wrote:
> Hi,
> 
> The following series is refactoring code for DMAC RoCE code and one fix
> to perform modify QP on real QP.
> 
> Thanks
> 
> Parav Pandit (4):
>   IB/core: Perform modify QP on real one
>   IB/core: Limit DMAC resolution to userspace QPs
>   IB/core: Attempt DMAC resolution for only RoCE
>   IB/core: Limit DMAC resolution to RoCE Connected QPs

I applied all of these to for-next

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
