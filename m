From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 2/2] mm: set PG_dma_pinned on get_user_pages*()
Date: Sun, 1 Jul 2018 23:10:04 -0700
Message-ID: <235a23e3-6e02-234c-3e20-b2dddc93e568@nvidia.com>
References: <20180626134757.GY28965@dhcp22.suse.cz>
 <20180626164825.fz4m2lv6hydbdrds@quack2.suse.cz>
 <20180627113221.GO32348@dhcp22.suse.cz>
 <20180627115349.cu2k3ainqqdrrepz@quack2.suse.cz>
 <20180627115927.GQ32348@dhcp22.suse.cz>
 <20180627124255.np2a6rxy6rb6v7mm@quack2.suse.cz>
 <20180627145718.GB20171@ziepe.ca>
 <20180627170246.qfvucs72seqabaef@quack2.suse.cz>
 <1f6e79c5-5801-16d2-18a6-66bd0712b5b8@nvidia.com>
 <20180628091743.khhta7nafuwstd3m@quack2.suse.cz>
 <20180702055251.GV3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702055251.GV3014@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, John Hubbard <john.hubbard@gmail.com>, Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 07/01/2018 10:52 PM, Leon Romanovsky wrote:
> On Thu, Jun 28, 2018 at 11:17:43AM +0200, Jan Kara wrote:
>> On Wed 27-06-18 19:42:01, John Hubbard wrote:
>>> On 06/27/2018 10:02 AM, Jan Kara wrote:
>>>> On Wed 27-06-18 08:57:18, Jason Gunthorpe wrote:
>>>>> On Wed, Jun 27, 2018 at 02:42:55PM +0200, Jan Kara wrote:
>>>>>> On Wed 27-06-18 13:59:27, Michal Hocko wrote:
>>>>>>> On Wed 27-06-18 13:53:49, Jan Kara wrote:
>>>>>>>> On Wed 27-06-18 13:32:21, Michal Hocko wrote:
>>>>>>> [...]
>>> One question though: I'm still vague on the best actions to take in the
>>> following functions:
>>>
>>>     page_mkclean_one
>>>     try_to_unmap_one
>>>
>>> At the moment, they are both just doing an evil little early-out:
>>>
>>> 	if (PageDmaPinned(page))
>>> 		return false;
>>>
>>> ...but we talked about maybe waiting for the condition to clear, instead?
>>> Thoughts?
>>
>> What needs to happen in page_mkclean() depends on the caller. Most of the
>> callers really need to be sure the page is write-protected once
>> page_mkclean() returns. Those are:
>>
>>   pagecache_isize_extended()
>>   fb_deferred_io_work()
>>   clear_page_dirty_for_io() if called for data-integrity writeback - which
>>     is currently known only in its caller (e.g. write_cache_pages()) where
>>     it can be determined as wbc->sync_mode == WB_SYNC_ALL. Getting this
>>     information into page_mkclean() will require some plumbing and
>>     clear_page_dirty_for_io() has some 50 callers but it's doable.
>>
>> clear_page_dirty_for_io() for cleaning writeback (wbc->sync_mode !=
>> WB_SYNC_ALL) can just skip pinned pages and we probably need to do that as
>> otherwise memory cleaning would get stuck on pinned pages until RDMA
>> drivers release its pins.
> 
> Sorry for naive question, but won't it create too much dirty pages
> so writeback will be called "non-stop" to rebalance watermarks without
> ability to progress?
> 

That is an interesting point. 

Holding off page writeback of this region does seem like it could cause
problems under memory pressure. Maybe adjusting the watermarks so that we
tell the writeback  system, "all is well, just ignore this region until
we're done with it" might help? Any ideas here are welcome...

Longer term, maybe some additional work could allow the kernel to be able
to writeback the gup-pinned pages (while DMA is happening--snapshots), but
that seems like a pretty big overhaul.

thanks,
-- 
John Hubbard
NVIDIA
