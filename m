From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 2/2] mm: set PG_dma_pinned on get_user_pages*()
Date: Sun, 17 Jun 2018 14:04:32 -0600
Message-ID: <20180617200432.krw36wrcwidb25cj@ziepe.ca>
References: <20180617012510.20139-1-jhubbard@nvidia.com>
 <20180617012510.20139-3-jhubbard@nvidia.com>
 <CAPcyv4i=eky-QrPcLUEqjsASuRUrFEWqf79hWe0mU8xtz6Jk-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4i=eky-QrPcLUEqjsASuRUrFEWqf79hWe0mU8xtz6Jk-w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 12:53:04PM -0700, Dan Williams wrote:
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 6db729dc4c50..37576f0a4645 100644
> > +++ b/mm/rmap.c
> > @@ -1360,6 +1360,8 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
> >                                 flags & TTU_SPLIT_FREEZE, page);
> >         }
> >
> > +       if (PageDmaPinned(page))
> > +               return false;
> >         /*
> >          * We have to assume the worse case ie pmd for invalidation. Note that
> >          * the page can not be free in this function as call of try_to_unmap()
> 
> We have a similiar problem with DAX and the conclusion we came to is
> that it is not acceptable for userspace to arbitrarily block kernel
> actions. The conclusion there was: 'wait' if the DMA is transient, and
> 'revoke' if the DMA is long lived, or otherwise 'block' long-lived DMA
> if a revocation mechanism is not available.

This might be the right answer for certain things, but it shouldn't be
the immediate reaction to everthing. There are many user APIs that
block kernel actions and hold kernel resources.

IMHO, there should be an identifiable objection, eg is blocking going
to create a DOS, dead-lock, insecurity, etc?

Jason
