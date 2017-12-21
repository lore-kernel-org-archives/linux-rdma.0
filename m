From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC PATCH rdma-next 00/14] RDMA resource tracking
Date: Thu, 21 Dec 2017 12:14:24 -0700
Message-ID: <20171221191424.GF20015@ziepe.ca>
References: <20171221181748.17126-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221181748.17126-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 08:17:34PM +0200, Leon Romanovsky wrote:

> Leon Romanovsky (14):
>   RDMA/netlink: Simplify code of autoload modules
>   RDMA/core: Enforce requirement to hold lists_rwsem semaphore
>   RDMA/core: Replace open-coded variant of put_device
>   RDMA/nldev: Refactor nldev handle to be common function
>   RDMA/core: Provide locked variant of device name to index function
>   RDMA/netlink: Protect device query from device removal
>   RDMA/nldev: Protect port query from accidental device removal

These all seem totally unrelated.. Shouldn't these cleanups should go
ahead right away? Can you send them as a non-rfc series?

Then we are down to something less intimidating to review for resource
tracking..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
