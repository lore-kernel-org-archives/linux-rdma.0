From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 5/6] mm: track gup pages with page->dma_pinned_* fields
Date: Tue, 3 Jul 2018 11:48:28 -0700
Message-ID: <2e18c1a3-08a3-abaf-1721-89bc527579ab@nvidia.com>
References: <20180702005654.20369-1-jhubbard@nvidia.com>
 <20180702005654.20369-6-jhubbard@nvidia.com>
 <20180702095331.n5zfz35d3invl5al@quack2.suse.cz>
 <bb798475-ebf3-7b02-409f-8c4347fa6674@nvidia.com>
 <010001645d77ee2c-de7fedbd-f52d-4b74-9388-e6435973792b-000000@email.amazonses.com>
 <f01666d5-8da1-7bea-adfb-c3571a54587a@nvidia.com>
 <01000164611dacae-5ac25e48-b845-43ef-9992-fc1047d8e0a0-000000@email.amazonses.com>
 <3c71556f-1d71-873a-6f74-121865568bf7@nvidia.com>
 <0100016461425062-724aa9d3-d7c1-4fa2-a87b-dc59cc5f7800-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0100016461425062-724aa9d3-d7c1-4fa2-a87b-dc59cc5f7800-000000@email.amazonses.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Jan Kara <jack@suse.cz>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 07/03/2018 10:48 AM, Christopher Lameter wrote:
> On Tue, 3 Jul 2018, John Hubbard wrote:
> 
>> The page->_refcount field is used normally, in addition to the dma_pinned_count.
>> But the problem is that, unless the caller knows what kind of page it is,
>> the page->dma_pinned_count cannot be looked at, because it is unioned with
>> page->lru.prev.  page->dma_pinned_flags, at least starting at bit 1, are
>> safe to look at due to pointer alignment, but now you cannot atomically
>> count...
>>
>> So this seems unsolvable without having the caller specify that it knows the
>> page type, and that it is therefore safe to decrement page->dma_pinned_count.
>> I was hoping I'd found a way, but clearly I haven't. :)
> 
> Try to find some way to indicate that the page is pinned by using some of
> the existing page flags? There is already an MLOCK flag. Maybe some
> creativity with that can lead to something (but then the MLOCKed pages are
> on the unevictable LRU....). cgroups used to have something called struct
> page_ext. Oh its there in linux/mm/page_ext.c.
> 

Yes, that would provide just a touch more cabability: we could both read and
write a dma-pinned page(_ext) flag safely, instead of only being able to just 
read.  I'm doubt that that's enough additional information, though. The general
problem of allowing random put_page() calls to decrement the dma-pinned count (see
Jan's diagram at the beginning of this thread) cannot be solved by anything less
than some sort of "who (or which special type of caller, at least) owns this page"
approach, as far as I can see. The put_user_pages() provides arguably the simplest 
version of that kind of solution.

Also, even just using a single bit from page extensions would cost some extra memory, 
because for example on 64-bit systems many configurations do not need the additional 
flags that page_ext.h provides, so they return "false" from the page_ext_operations.need() 
callback. Changing get_user_pages to require page extensions would lead to
*every* configuration requiring page extensions, so 64-bit users would lose some memory
for sure. On the other hand, it avoids the "take page off of the LRU" complexity that 
I've got here. But again, I don't think a single flag, or even a count, would actually 
solve the problem.
