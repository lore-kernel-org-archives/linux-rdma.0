From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/{core,hw}: Add constant for node_desc
Date: Thu, 25 Aug 2016 10:47:05 -0600
Message-ID: <20160825164705.GA31542@obsidianresearch.com>
References: <1472115186-10718-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472115186-10718-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2016 at 01:53:06AM -0700, Yuval Shaia wrote:

> -	memcpy(dev->ibdev.node_desc, IWCH_NODE_DESC, sizeof(IWCH_NODE_DESC));
> +	memcpy(dev->ibdev.node_desc, IWCH_NODE_DESC, IB_DEVICE_NODE_DESC_MAX);

That is not OK. Nor are any of the similar ones.

Copies random kernel memory at the end of IWCH_NODE_DESC.

> -		memcpy(device->node_desc, device_modify->node_desc, 64);
> +		memcpy(device->node_desc, device_modify->node_desc,
> +		       IB_DEVICE_NODE_DESC_MAX);

And this and similar would be nicer as:

> +		memcpy(device->node_desc, device_modify->node_desc,
>                      sizeof(device_modify->node_desc))

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
