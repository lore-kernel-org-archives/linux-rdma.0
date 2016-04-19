From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Tue, 19 Apr 2016 20:29:50 +0200
Message-ID: <20160419182950.GC989@lst.de>
References: <1461010463-6603-1-git-send-email-hch@lst.de> <1461010463-6603-12-git-send-email-hch@lst.de> <57163E99.8090301@grimberg.me> <20160419172627.GC20844@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160419172627.GC20844-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 11:26:27AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 19, 2016 at 05:20:09PM +0300, Sagi Grimberg wrote:
> 
> > In isert if the we have a single sg entry, we use the local_dma_lkey
> > just so we can skip a registration (also for protection sg), perhaps
> > rdma_rw_init_one_mr can do this optimization too?
> 
> Can't more than a single SG can be packed into a WR? Ideally this
> common code should try and max out the SG entries before falling back
> to using a WR?

Mellanox signature MRs don't support registering more than a single SGE.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
