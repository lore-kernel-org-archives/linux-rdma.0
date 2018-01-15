From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/3] RDMA/core: Remove RoCE support from
 rdma_addr_get_sgid()
Date: Mon, 15 Jan 2018 15:07:41 -0700
Message-ID: <20180115220741.GA18489@ziepe.ca>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109111058.29534-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 01:10:56PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> There are number of issues with RoCE support in rdma_addr_get_sgid() call:
> 
> 1. With IP based GIDs, SGID derived using iboe_addr_get_sgid() was
> not used in connection establishment process. SGID was always derived
> using ip2gid().
> 
> 2. It returns the first IP address of the netdevice, while netdevice
> can have multiple IP addresses and connection could have been established
> using non first IP address.
> 
> 3. It returns SGID based on IPv4 address. It doesn't cover IPv6 addresses.
> 
> 4. As the comment of rdma_dev_addr src_dev_addr and dst_dev_addr suggest,
> such members of rdma_dev_addr stores the mac address. Therefore it is not
> the best place to store the RoCE GIDs. RoCE GIDs are derived from the IP
> addresses and they are already available in cm_id->route->addr.***_addr.
> 
> It was only used to return SGID to rds/ib.c and ucma.c modules, where it
> returned incorrect SGID in above matching conditions.

Yes, but if those conditions were not matched it did something useful
and now what happens?

All the callers in ucma.c are returning the result to userspace, so
this patch looks like it is changing the uapi in some way?

Can you define what the SGID/DGID should be in the rdma CM uapi when
working with rocee?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
