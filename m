From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 0/2] mm: gup: don't unmap or drop filesystem buffers
Date: Sun, 17 Jun 2018 15:23:14 -0700
Message-ID: <4708f5be-1829-3a20-8fad-5a445d18aa84@nvidia.com>
References: <20180617012510.20139-1-jhubbard@nvidia.com>
 <010001640fbe0dd8-f999e7f6-7b6e-4deb-b073-0c572006727d-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <010001640fbe0dd8-f999e7f6-7b6e-4deb-b073-0c572006727d-000000@email.amazonses.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>, john.hubbard@gmail.com
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 06/17/2018 02:54 PM, Christopher Lameter wrote:
> On Sat, 16 Jun 2018, john.hubbard@gmail.com wrote:
> 
>> I've come up with what I claim is a simple, robust fix, but...I'm
>> presuming to burn a struct page flag, and limit it to 64-bit arches, in
>> order to get there. Given that the problem is old (Jason Gunthorpe noted
>> that RDMA has been living with this problem since 2005), I think it's
>> worth it.
>>
>> Leaving the new page flag set "nearly forever" is not great, but on the
>> other hand, once the page is actually freed, the flag does get cleared.
>> It seems like an acceptable tradeoff, given that we only get one bit
>> (and are lucky to even have that).
> 
> This is not robust. Multiple processes may register a page with the RDMA
> subsystem. How do you decide when to clear the flag? I think you would
> need an additional refcount for the number of times the page was
> registered.

Effectively, page->_refcount is what does that here. It would be a nice, but 
not strictly required optimization to have a separate reference count. That's
because the new page flag gets cleared when the page is fully freed. So unless
we're dealing with pages that don't get freed, it's functional, right?

Each of those multiple processes also wants protection from the ravages
of try_to_unmap() and drop_buffers(), anyway. Having said that, it would
be nice to have that refcount, but seems hard to get one.

> 
> I still think the cleanest solution here is to require mmu notifier
> callbacks and to not pin the page in the first place. If a NIC does not
> support a hardware mmu then it can still simulate it in software by
> holding off the ummapping the mmu notifier callback until any pending
> operation is complete and then invalidate the mapping so that future
> operations require a remapping (or refaulting).
> 

Interesting. I didn't want a solution that only supported the few devices
that can support their own replayable page faulting, so I was sort of putting
the mmu notifier idea on the back burner. But somehow I missed the
idea of just holding off the invalidation, in MMU notifier callback, to 
work for non-page-faultable hardware. On one hand, it's wild to hold off
the invalidation perhaps for a long time, but on the other hand--you get
behavior that the hardware cannot otherwise do: access to non-pinned memory.

I know this was brought up before. Definitely would like to hear more 
opinions and brainstorming here.

thanks,
-- 
John Hubbard
NVIDIA
