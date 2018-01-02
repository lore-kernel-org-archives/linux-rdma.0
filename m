From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 0/7] RDMA fixes and refactoring
Date: Tue, 2 Jan 2018 14:07:28 -0700
Message-ID: <20180102210728.GF7614@ziepe.ca>
References: <20180101110717.29686-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180101110717.29686-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 01, 2018 at 01:07:10PM +0200, Leon Romanovsky wrote:
> Leon Romanovsky (7):
>   RDMA/rxe: Remove useless export symbol
>   RDMA/netlink: Simplify code of autoload modules
>   RDMA/core: Replace open-coded variant of put_device
>   RDMA/nldev: Refactor nldev handle to be common function
>   RDMA/cma: Mark end of CMA ID messages

Applied the above to for-next.

These two below got reworked and applied

>   RDMA/core: Provide locked variant of device name to index function
>   RDMA/netlink: Protect device and port queries from device removal

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
