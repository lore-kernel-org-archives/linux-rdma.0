From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] mm: gup: don't unmap or drop filesystem buffers
Date: Mon, 18 Jun 2018 01:10:03 -0700
Message-ID: <20180618081003.GA20927@infradead.org>
References: <20180617012510.20139-1-jhubbard@nvidia.com>
 <010001640fbe0dd8-f999e7f6-7b6e-4deb-b073-0c572006727d-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <010001640fbe0dd8-f999e7f6-7b6e-4deb-b073-0c572006727d-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 09:54:31PM +0000, Christopher Lameter wrote:
> On Sat, 16 Jun 2018, john.hubbard@gmail.com wrote:
> 
> > I've come up with what I claim is a simple, robust fix, but...I'm
> > presuming to burn a struct page flag, and limit it to 64-bit arches, in
> > order to get there. Given that the problem is old (Jason Gunthorpe noted
> > that RDMA has been living with this problem since 2005), I think it's
> > worth it.
> >
> > Leaving the new page flag set "nearly forever" is not great, but on the
> > other hand, once the page is actually freed, the flag does get cleared.
> > It seems like an acceptable tradeoff, given that we only get one bit
> > (and are lucky to even have that).
> 
> This is not robust. Multiple processes may register a page with the RDMA
> subsystem. How do you decide when to clear the flag? I think you would
> need an additional refcount for the number of times the page was
> registered.

And it's not just RDMA that is using get_user_pages.  We have tons of
users that do short, spurious get_user_pages do do zero copy operations.

We can't leave the page in a wrecked state after that.

> I still think the cleanest solution here is to require mmu notifier
> callbacks and to not pin the page in the first place. If a NIC does not
> support a hardware mmu then it can still simulate it in software by
> holding off the ummapping the mmu notifier callback until any pending
> operation is complete and then invalidate the mapping so that future
> operations require a remapping (or refaulting).

Sounds ok for RDMA, not going to help for most other users.
