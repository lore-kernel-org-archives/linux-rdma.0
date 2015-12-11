From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 02/37] IB/rdmavt: Consolidate dma ops in rdmavt.
Date: Thu, 10 Dec 2015 23:02:02 -0700
Message-ID: <20151211060202.GA16513@obsidianresearch.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204305.8144.7038.stgit@phlsvslse11.ph.intel.com>
 <20151208060821.GD7313@leon.nu>
 <20151210161708.GA13412@phlsvsds.ph.intel.com>
 <20151210174413.GB21482@obsidianresearch.com>
 <20151210234112.GA15546@infradead.org>
 <20151211002950.GA5964@obsidianresearch.com>
 <20151211004624.GA9994@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151211004624.GA9994-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 04:46:24PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 10, 2015 at 05:29:50PM -0700, Jason Gunthorpe wrote:
> > Hrm.. sizeof(void *) > sizeof(dma_addr_t) seemed pretty obscure to me,
> > here is the original discussion:
> > 
> > https://lkml.org/lkml/2006/12/13/245
> > 
> > Sounds like someone was worried about sparc64. I doubt it is an actual
> > issue today, but granted the u64 did make some sense.
> 
> sparc64 still uses a 32-bit dma_addr_t.

Hmm, too bad, that choice severly compromises the rdma userspace -
user space can't create mrs that exceed 4G in total :(

> > So, I *believe* the issue is that linux has (had?) no approved way to
> > convert from a device specific dma_addr_t to a virtual address.
> 
> Linux doesn't have an approved way because it's impossible for the
> generic case.  When you have an iommu you have potentially multiple
> page tables mapping physical addresses to device virtual addresses,
> and there is no easy way to do a reverse mapping.

Yes, I know

> > It is really too bad we can't just use get_dma_ops to handle this case
> > and instead require our own infrastructure.
> 
> FYI, I have a patch series in linux-next to switches all remaining
> architectures to use get_dma_ops, and there are plans to allow generic
> per-device dma_ops based on that.

Great, so once that is merged we can drop the ib_* versions of all
this and just have qib/etc customize get_dma_ops? Other than the
dma_addr_t size issue that sounds great..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
