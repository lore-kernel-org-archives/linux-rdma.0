From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 0/2] mm: gup: don't unmap or drop filesystem buffers
Date: Sun, 17 Jun 2018 21:54:31 +0000
Message-ID: <010001640fbe0dd8-f999e7f6-7b6e-4deb-b073-0c572006727d-000000@email.amazonses.com>
References: <20180617012510.20139-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180617012510.20139-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, 16 Jun 2018, john.hubbard@gmail.com wrote:

> I've come up with what I claim is a simple, robust fix, but...I'm
> presuming to burn a struct page flag, and limit it to 64-bit arches, in
> order to get there. Given that the problem is old (Jason Gunthorpe noted
> that RDMA has been living with this problem since 2005), I think it's
> worth it.
>
> Leaving the new page flag set "nearly forever" is not great, but on the
> other hand, once the page is actually freed, the flag does get cleared.
> It seems like an acceptable tradeoff, given that we only get one bit
> (and are lucky to even have that).

This is not robust. Multiple processes may register a page with the RDMA
subsystem. How do you decide when to clear the flag? I think you would
need an additional refcount for the number of times the page was
registered.

I still think the cleanest solution here is to require mmu notifier
callbacks and to not pin the page in the first place. If a NIC does not
support a hardware mmu then it can still simulate it in software by
holding off the ummapping the mmu notifier callback until any pending
operation is complete and then invalidate the mapping so that future
operations require a remapping (or refaulting).
