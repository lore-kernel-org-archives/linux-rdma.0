From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 3/5] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Thu, 12 Jun 2014 11:40:12 -0600
Message-ID: <20140612174012.GA5244@obsidianresearch.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <1400405929-14313-4-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <20140521203107.GD26909@obsidianresearch.com>
 <5399A093.9070104@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5399A093.9070104-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 12, 2014 at 03:44:03PM +0300, Matan Barak wrote:

> We could use a libibverbs API call in order to resolve the IP based
> GID into a MAC, but I think it could cause multiple vendors to have
> some code duplication.

If that is the only objection, I would prefer to see this techique. A
little provider code duplication is a lessor evil than introducing and
vetting new verbs APIs.

I think the patch will be very small and there will be very little to
talk about from an API perspective.

> We hope that in the future, more products will use RoCE with IP
> based GIDs. All those providers will have to supply similar code
> that checks if the link layer is Ethernet and IP based GID is used,
> they'll have to use the libibverbs utility function.

AFAIK all the other RoCEE implementations don't do InfiniBand link
layer, so their providers don't even need the test.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
