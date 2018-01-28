From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] RDMA fixes for 4.16
Date: Sun, 28 Jan 2018 14:12:42 -0700
Message-ID: <20180128211242.GA26025@ziepe.ca>
References: <20180128092533.4156-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128092533.4156-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 11:25:28AM +0200, Leon Romanovsky wrote:
> Hi,
> 
> This is batch of unrelated fixes and two cleanup patches from Parav.
> 
> The fix from Jack is to well-known series 44c58487d51a ("IB/core:
> Define 'ib' and 'roce' rdma_ah_attr types") and it is targeted for
> stable@.
> 
> Thanks
> 
> Jack Morgenstein (1):
>   IB/umad: Fix use of unprotected device pointer

FWIW, that would be a -rc patch if another -rc was still expected.

> Leon Romanovsky (2):
>   RDMA/mlx5: Avoid memory leak in case of XRCD dealloc failure
>   RDMA/cm: Fix access to uninitialized variable
> 
> Parav Pandit (2):
>   IB/core: Avoid SGID attributes query while converting GID from OPA to
>     IB
>   RDMA/cma: Use existing netif_is_bond_master function

Applied to for-next thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
