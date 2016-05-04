From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/4] IB/core: Add IP to GID netlink offload
Date: Wed, 4 May 2016 12:52:41 -0600
Message-ID: <20160504185241.GD20554@obsidianresearch.com>
References: <1462376518-6725-1-git-send-email-leon@kernel.org>
 <1462376518-6725-5-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462376518-6725-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 06:41:58PM +0300, Leon Romanovsky wrote:
> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> There is an assumption that rdmacm is used only between nodes
> in the same IB subnet, this why ARP resolution can be used to turn
> IP to GID in rdmacm.
> 
> When dealing with IB communication between subnets this assumption
> is no longer valid. ARP resolution will get us the next hop device
> address and not the peer node's device address.
> 
> To overcome this limitation, let's check user space if it can
> provide the GID of the peer node, and fail if not.
> 
> We add a sequence number to identify each request and fill in the GID
> upon answer from user space.

This description doesn't describe what this patch is trying to do.

This patch is delegating IP to GID translation to user space if there
is a route table entry for the destination.

I have to say, I really don't like this at all. If we want to have
proper routing support then the translation needs to be done somehow
in-band. What is user space supposed to do?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
