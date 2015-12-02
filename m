From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Wed, 2 Dec 2015 04:27:45 -0800
Message-ID: <20151202122745.GB28278@infradead.org>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221430.32702.86114.stgit@manet.1015granger.net>
 <5653B606.3070700@talpey.com>
 <20151124065225.GB29141@infradead.org>
 <20151124071215.GC23597@obsidianresearch.com>
 <AE86B182-6000-4437-8502-9D2C5EC3B09D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AE86B182-6000-4437-8502-9D2C5EC3B09D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 01, 2015 at 10:33:18AM -0500, Chuck Lever wrote:
> Oracle recently announced Sonoma, which is a SPARC CPU with
> an on-chip IB HCA. Oracle plans to publish an open-source
> GPL device driver that enables this HCA in Linux for SPARC.
> We???d eventually like to contribute it to the upstream
> Linux kernel.
> 
> At the moment, the device and driver support only FMR. As
> you might expect, Oracle needs it to work at least with
> in-kernel RDS. Thus we hope to see the life of in-kernel
> FMR extended for a bit to accommodate this new device.

Oh, that's pretty sad news.  I wonder what the engineers where smoking..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
