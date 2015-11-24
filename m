From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 3/9] xprtrdma: Introduce ro_unmap_sync method
Date: Tue, 24 Nov 2015 11:57:07 -0700
Message-ID: <20151124185707.GJ10391@obsidianresearch.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221414.32702.87638.stgit@manet.1015granger.net>
 <20151124064556.GA29141@infradead.org>
 <565442F5.7080400@dev.mellanox.co.il>
 <4B2D7C66-31AC-44F3-A8CC-22CC7136015C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B2D7C66-31AC-44F3-A8CC-22CC7136015C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2015 at 09:39:33AM -0500, Chuck Lever wrote:
> >> Do we really want to go down that road?  It seems like we've decided
> >> in general that while the protocol specs say MR must be unmapped before
> >> proceeding with the data that is painful enough to ignore this
> >> requirement.  E.g. iser for example only does the local invalidate
> >> just before reusing the MR.
> 
> That leaves the MR exposed to the remote indefinitely. If
> the MR is registered for remote write, that seems hazardous.

Agree.

If we have a performance knob it should be to post the invalidate,
then immediately dma unmap and start using the buffer, not to defer
the invalidate potentially indefinitely.  Then it is just a race to be
exploited not a long lived window into random page cache memory.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
