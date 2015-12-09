From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC contig pages support 1/2] IB: Supports contiguous memory
 operations
Date: Wed, 9 Dec 2015 10:48:31 -0700
Message-ID: <20151209174831.GC31636@obsidianresearch.com>
References: <1449587707-24214-1-git-send-email-yishaih@mellanox.com>
 <1449587707-24214-2-git-send-email-yishaih@mellanox.com>
 <20151208151852.GA6688@infradead.org>
 <20151208171542.GB13549@obsidianresearch.com>
 <AM4PR05MB146005B448BEA876519335CDDCE80@AM4PR05MB1460.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM4PR05MB146005B448BEA876519335CDDCE80-n5Jp0YuYvM1n/kQvjoF5G9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 10:00:02AM +0000, Shachar Raindel wrote:
> > Yes please.

> Note that other HW vendors are developing similar solutions, see for
> example:
> http://www.slideshare.net/linaroorg/hkg15106-replacing-cmem-meeting-tis-soc-shared-buffer-allocation-management-and-address-translation-requirements

CMA and it's successors are for something totally different.

> > We already have huge page mmaps, how much win is had by going from
> > huge page maps to this contiguous map?
> 
> As far as gain is concerned, we are seeing gains in two cases here:
> 1. If the system has lots of non-fragmented, free memory, you can
> create large contig blocks that are above the CPU huge page size.
> 2. If the system memory is very fragmented, you cannot allocate huge
> pages. However, an API that allows you to create small (i.e. 64KB,
> 128KB, etc.) contig blocks reduces the load on the HW page tables
> and caches.

I understand what it does, I was looking for performance numbers. The
last time I trivially benchmarked huge pages vs not huge pages on mlx4
I wasn't able to detect a performance difference.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
