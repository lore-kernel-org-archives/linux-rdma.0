From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Update CMA to use net namespace
Date: Mon, 22 Jan 2018 13:17:50 -0700
Message-ID: <20180122201750.GA10936@ziepe.ca>
References: <20180109135859.7676-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109135859.7676-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 03:58:53PM +0200, Leon Romanovsky wrote:
> Hi,
> 
> This series updates several CMA paths to use net namespaces, those
> patches don't have Fixes line, because the original code wasn't supposed
> to work with namespaces.
> 
> Thanks
> 
> Parav Pandit (6):
>   RDMA/cma: Check existence of netdevice during port validation
>   RDMA/cma: Refactor to access multiple fields of rdma_dev_addr
>   RDMA/cma: Update cma_validate_port to honor net namespace
>   RDMA/cma: Update RoCE multicast routines to use net namespace

I took these ones to for-next

>   RDMA/cma: Protect ifindex access during IPv6 route lookup
>   RDMA/cma: Protect ifindex access during IPv4 route lookup

Left these pending more explanations/rework

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
