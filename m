From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/verbs: Check each operation of dma_ops individually
Date: Tue, 14 Apr 2015 14:10:50 -0600
Message-ID: <20150414201050.GI7682@obsidianresearch.com>
References: <1424667027-8790-1-git-send-email-yuval.shaia@oracle.com>
 <552CD53B.3@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552CD53B.3-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 14, 2015 at 11:52:11AM +0300, Sagi Grimberg wrote:
> On 2/23/2015 6:50 AM, Yuval Shaia wrote:
> >Current approach force one to implement all ops even when some functions can use the default implementation.
> >As a result, for new DMA ops (e.x new arch) many functions just wrap the default function.
> >The fix is to check each DMA operation individually so one can leave empty the ones not need to be override.
> >
> 
> I guess this is OK, but aren't we better off with wrappers than
> adding another condition statement?

Yeah, the drivers should provide all the ops.

With the current scheme the core could fill in the NULL ops with
default on device register, other subsystems do this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
