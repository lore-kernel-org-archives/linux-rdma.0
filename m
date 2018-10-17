From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4/6] mm: introduce page->dma_pinned_flags, _count
Date: Wed, 17 Oct 2018 13:09:52 +0200
Message-ID: <20181017110952.GN18839@dhcp22.suse.cz>
References: <20181012060014.10242-1-jhubbard@nvidia.com>
 <20181012060014.10242-5-jhubbard@nvidia.com>
 <20181013035516.GA18822@dastard>
 <7c2e3b54-0b1d-6726-a508-804ef8620cfd@nvidia.com>
 <20181013230124.GB18822@dastard>
 <20181016085102.GB18918@quack2.suse.cz>
 <a9f1df2f-da9d-bf7b-b977-d3d3ca710776@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a9f1df2f-da9d-bf7b-b977-d3d3ca710776@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue 16-10-18 18:48:23, John Hubbard wrote:
[...]
> It's hard to say exactly what the active/inactive/unevictable list should
> be when DMA is done and put_user_page*() is called, because we don't know
> if some device read, wrote, or ignored any of those pages. Although if 
> put_user_pages_dirty() is called, that's an argument for "active", at least.

Any reason to not use putback_lru_page?

Please note I haven't really got through your patches to have a wider
picture of the change so this is just hint for the LRU part of the
issue.
-- 
Michal Hocko
SUSE Labs
