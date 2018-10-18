From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 4/6] mm: introduce page->dma_pinned_flags, _count
Date: Wed, 17 Oct 2018 17:03:03 -0700
Message-ID: <2367ff26-809c-da94-a8f0-e921bdc4862a@nvidia.com>
References: <20181012060014.10242-1-jhubbard@nvidia.com>
 <20181012060014.10242-5-jhubbard@nvidia.com> <20181013035516.GA18822@dastard>
 <7c2e3b54-0b1d-6726-a508-804ef8620cfd@nvidia.com>
 <20181013230124.GB18822@dastard> <20181016085102.GB18918@quack2.suse.cz>
 <a9f1df2f-da9d-bf7b-b977-d3d3ca710776@nvidia.com>
 <20181017110952.GN18839@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017110952.GN18839@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 10/17/18 4:09 AM, Michal Hocko wrote:
> On Tue 16-10-18 18:48:23, John Hubbard wrote:
> [...]
>> It's hard to say exactly what the active/inactive/unevictable list should
>> be when DMA is done and put_user_page*() is called, because we don't know
>> if some device read, wrote, or ignored any of those pages. Although if 
>> put_user_pages_dirty() is called, that's an argument for "active", at least.
> 
> Any reason to not use putback_lru_page?

That does help with which LRU to use. I guess I'd still need to track whether
a page was on an LRU when get_user_pages() was called, because it seems
that that is not necessarily always the case. And putback_lru_page() definitely
wants to deal with a page that *was* previously on an LRU.

> 
> Please note I haven't really got through your patches to have a wider
> picture of the change so this is just hint for the LRU part of the
> issue.
> 

Understood, and the hints are much appreciated.

-- 
thanks,
John Hubbard
NVIDIA
