From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/2] mm/fs: put_user_page() proposal
Date: Mon, 9 Jul 2018 10:16:51 -0700
Message-ID: <20180709171651.GE2662@bombadil.infradead.org>
References: <20180709080554.21931-1-jhubbard@nvidia.com>
 <20180709184937.7a70c3aa@roar.ozlabs.ibm.com>
 <20180709160806.xjt2l2pbmyiutbyi@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180709160806.xjt2l2pbmyiutbyi@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Nicholas Piggin <npiggin@gmail.com>, john.hubbard@gmail.com, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 09, 2018 at 06:08:06PM +0200, Jan Kara wrote:
> On Mon 09-07-18 18:49:37, Nicholas Piggin wrote:
> > The problem with blocking in clear_page_dirty_for_io is that the fs is
> > holding the page lock (or locks) and possibly others too. If you
> > expect to have a bunch of long term references hanging around on the
> > page, then there will be hangs and deadlocks everywhere. And if you do
> > not have such log term references, then page lock (or some similar lock
> > bit) for the duration of the DMA should be about enough?
> 
> There are two separate questions:
> 
> 1) How to identify pages pinned for DMA? We have no bit in struct page to
> use and we cannot reuse page lock as that immediately creates lock
> inversions e.g. in direct IO code (which could be fixed but then good luck
> with auditing all the other GUP users). Matthew had an idea and John
> implemented it based on removing page from LRU and using that space in
> struct page. So we at least have a way to identify pages that are pinned
> and can track their pin count.
> 
> 2) What to do when some page is pinned but we need to do e.g.
> clear_page_dirty_for_io(). After some more thinking I agree with you that
> just blocking waiting for page to unpin will create deadlocks like:

Why are we trying to writeback a page that is pinned?  It's presumed to
be continuously redirtied by its pinner.  We can't evict it.

> ext4_writepages()				ext4_direct_IO_write()
> 						  __blockdev_direct_IO()
> 						    iov_iter_get_pages()
> 						      - pins page
>   handle = ext4_journal_start_with_reserve(inode, ...)
>     - starts transaction
>   ...
>     lock_page(page)
>     mpage_submit_page()
>       clear_page_dirty_for_io(page) -> blocks on pin

I don't think it should block.  It should fail.
