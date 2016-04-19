From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Tue, 19 Apr 2016 11:26:27 -0600
Message-ID: <20160419172627.GC20844@obsidianresearch.com>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
 <1461010463-6603-12-git-send-email-hch@lst.de>
 <57163E99.8090301@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57163E99.8090301@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>, dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 05:20:09PM +0300, Sagi Grimberg wrote:

> In isert if the we have a single sg entry, we use the local_dma_lkey
> just so we can skip a registration (also for protection sg), perhaps
> rdma_rw_init_one_mr can do this optimization too?

Can't more than a single SG can be packed into a WR? Ideally this
common code should try and max out the SG entries before falling back
to using a WR?

There is probably an interesting performance trade off around making
the WR SG list bigger vs using the MR.

But that could be done as a follow up patch... This series is a big,
big improvement already.

Jason
