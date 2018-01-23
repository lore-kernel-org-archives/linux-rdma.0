From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH iproute2-next v2 00/10] RDMA resource tracking
Date: Tue, 23 Jan 2018 11:33:55 -0700
Message-ID: <f0ac1406-6ef4-cdcb-5a81-82c52e9d450d@gmail.com>
References: <20180117100232.3155-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117100232.3155-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/17/18 3:02 AM, Leon Romanovsky wrote:
> 
> David, Stephen,
> 
> The kernel code is not accepted yet, but the interface and functionality
> of iproute2 stable enough and ready for review.
> 
> iproute2 part:
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/iproute2.git/log/?h=topic/resource-tracking-3
> 
> kernel part:
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=rn/restrack-v5

BTW, I just remembered rdma tool is using libmnl and it has the same
problem devlink had -- old commands may not work as expected on newer
kernels as more RDMA_NLDEV_ATTR_ are added.

Specifically, this check in rd_attr_cb:
	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
		return MNL_CB_ERROR;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
