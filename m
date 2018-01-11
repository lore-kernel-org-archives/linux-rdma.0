From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] RoCE Path Record refactoring
Date: Wed, 10 Jan 2018 17:20:02 -0700
Message-ID: <20180111002002.GA16574@ziepe.ca>
References: <20180108150448.29069-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108150448.29069-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 05:04:42PM +0200, Leon Romanovsky wrote:
> Hi,
> 
> This series is mostly refactoring code in CMA area as a preparation
> to RoCE containers code, however there are two small fixes which is also
> targeted to rdma-next.
> 
> Thanks
> 
> Parav Pandit (6):
>   RDMA/cma: Use the net namespace of the rdma_cm_id
>   RDMA/cma: Provide function to set RoCE path record L2 parameters
>   RDMA/{cma, ucma}: Simplify and rename rdma_set_ib_paths
>   RDMA/cma: Fix setting RoCE specific path record fields
>   RDMA/cma: Fix returning correct path record entry for RoCE

The above were applied to for-next, thanks. I revised some of the commit
messages.

I dropped this patch:

>   RDMA/{cma, ucma}: Refactor to have transport specific checks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
