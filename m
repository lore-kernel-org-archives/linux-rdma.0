From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] RDMA/netlink: Advertise IB subnet prefix
Date: Wed, 28 Jun 2017 10:02:51 -0600
Message-ID: <20170628160251.GB14375@obsidianresearch.com>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628133445.16550-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 28, 2017 at 04:34:43PM +0300, Leon Romanovsky wrote:

> +	/*
> +	 * Subnet prefix (in host byte order)
> +	 */
> +	RDMA_NLDEV_ATTR_SUBNET_PREFIX,		/* u64 */

I've always hated how random the be / host choices are in our API.

Since the GUID is in host order I recommend making the subnet_prefix
in host order too.

At the very least, the comments beside anything not in host order
should be 'be64' not u64

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
