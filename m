From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] mm: introduce page->dma_pinned_flags, _count
Date: Tue, 16 Oct 2018 10:51:02 +0200
Message-ID: <20181016085102.GB18918@quack2.suse.cz>
References: <20181012060014.10242-1-jhubbard@nvidia.com>
 <20181012060014.10242-5-jhubbard@nvidia.com>
 <20181013035516.GA18822@dastard>
 <7c2e3b54-0b1d-6726-a508-804ef8620cfd@nvidia.com>
 <20181013230124.GB18822@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013230124.GB18822@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun 14-10-18 10:01:24, Dave Chinner wrote:
> On Sat, Oct 13, 2018 at 12:34:12AM -0700, John Hubbard wrote:
> > On 10/12/18 8:55 PM, Dave Chinner wrote:
> > > On Thu, Oct 11, 2018 at 11:00:12PM -0700, john.hubbard@gmail.com wrote:
> > >> From: John Hubbard <jhubbard@nvidia.com>
> > [...]
> > >> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > >> index 5ed8f6292a53..017ab82e36ca 100644
> > >> --- a/include/linux/mm_types.h
> > >> +++ b/include/linux/mm_types.h
> > >> @@ -78,12 +78,22 @@ struct page {
> > >>  	 */
> > >>  	union {
> > >>  		struct {	/* Page cache and anonymous pages */
> > >> -			/**
> > >> -			 * @lru: Pageout list, eg. active_list protected by
> > >> -			 * zone_lru_lock.  Sometimes used as a generic list
> > >> -			 * by the page owner.
> > >> -			 */
> > >> -			struct list_head lru;
> > >> +			union {
> > >> +				/**
> > >> +				 * @lru: Pageout list, eg. active_list protected
> > >> +				 * by zone_lru_lock.  Sometimes used as a
> > >> +				 * generic list by the page owner.
> > >> +				 */
> > >> +				struct list_head lru;
> > >> +				/* Used by get_user_pages*(). Pages may not be
> > >> +				 * on an LRU while these dma_pinned_* fields
> > >> +				 * are in use.
> > >> +				 */
> > >> +				struct {
> > >> +					unsigned long dma_pinned_flags;
> > >> +					atomic_t      dma_pinned_count;
> > >> +				};
> > >> +			};
> > > 
> > > Isn't this broken for mapped file-backed pages? i.e. they may be
> > > passed as the user buffer to read/write direct IO and so the pages
> > > passed to gup will be on the active/inactive LRUs. hence I can't see
> > > how you can have dual use of the LRU list head like this....
> > > 
> > > What am I missing here?
> > 
> > Hi Dave,
> > 
> > In patch 6/6, pin_page_for_dma(), which is called at the end of get_user_pages(),
> > unceremoniously rips the pages out of the LRU, as a prerequisite to using
> > either of the page->dma_pinned_* fields. 
> 
> How is that safe? If you've ripped the page out of the LRU, it's no
> longer being tracked by the page cache aging and reclaim algorithms.
> Patch 6 doesn't appear to put these pages back in the LRU, either,
> so it looks to me like this just dumps them on the ground after the
> gup reference is dropped.  How do we reclaim these page cache pages
> when there is memory pressure if they aren't in the LRU?

Yeah, that's a bug in patch 6/6 (possibly in ClearPageDmaPinned). It should
return the page to the LRU from put_user_page().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
