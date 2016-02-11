From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Thu, 11 Feb 2016 12:18:38 -0700
Message-ID: <20160211191838.GA23675@obsidianresearch.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 11, 2016 at 06:12:50PM +0200, Artemy Kovalyov wrote:

> Recently introduced ZONE_DEVICE patch [1] allows to register devices as
> providers of "device memory" regions, making RDMA operation with them
> transparantly available. This patch is intended for scenarios which not fit
> into ZONE_DEVICE infrastrcture, but device still want to exposure it's
> IO regions to RDMA access.

Most of this stuff (eg the whole peer_memory_client thing) has no
buisness being part of the RDMA stack. We can't ask other drivers to
call IB functions just because their devices have ZONE_DIRECT memory.

Resubmit those parts under the mm subsystem, or another more
appropriate place.

This is the same comment as last time this was submitted.

If you want to make some incremental progress then implement the
existing ZONE_DEVICE API for the IB core and add the invalidate stuff
later, once you've negotiated a common API for that with linux-mm.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
