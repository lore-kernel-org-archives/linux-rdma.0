From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 5/6] mm: track gup pages with page->dma_pinned_* fields
Date: Tue, 3 Jul 2018 10:36:05 -0700
Message-ID: <3c71556f-1d71-873a-6f74-121865568bf7@nvidia.com>
References: <20180702005654.20369-1-jhubbard@nvidia.com>
 <20180702005654.20369-6-jhubbard@nvidia.com>
 <20180702095331.n5zfz35d3invl5al@quack2.suse.cz>
 <bb798475-ebf3-7b02-409f-8c4347fa6674@nvidia.com>
 <010001645d77ee2c-de7fedbd-f52d-4b74-9388-e6435973792b-000000@email.amazonses.com>
 <f01666d5-8da1-7bea-adfb-c3571a54587a@nvidia.com>
 <01000164611dacae-5ac25e48-b845-43ef-9992-fc1047d8e0a0-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01000164611dacae-5ac25e48-b845-43ef-9992-fc1047d8e0a0-000000@email.amazonses.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Jan Kara <jack@suse.cz>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 07/03/2018 10:08 AM, Christopher Lameter wrote:
> On Mon, 2 Jul 2018, John Hubbard wrote:
> 
>>> If you establish a reference to a page then increase the page count. If
>>> the reference is a dma pin action also then increase the pinned count.
>>>
>>> That way you know how many of the references to the page are dma
>>> pins and you can correctly manage the state of the page if the dma pins go
>>> away.
>>>
>>
>> I think this sounds like what this patch already does, right? See:
>> __put_page_for_pinned_dma(), __get_page_for_pinned_dma(), and
>> pin_page_for_dma(). The locking seems correct to me, but I suspect it's
>> too heavyweight for such a hot path. But without adding a new put_user_page()
>> call, that was the best I could come up with.
> 
> When I saw the patch it looked like you were avoiding to increment the
> page->count field.

Looking at it again, this patch is definitely susceptible to Jan's "page gets
dma-unpinnned too soon" problem.  That leaves a window in which the original
problem can occur.

The page->_refcount field is used normally, in addition to the dma_pinned_count.
But the problem is that, unless the caller knows what kind of page it is,
the page->dma_pinned_count cannot be looked at, because it is unioned with
page->lru.prev.  page->dma_pinned_flags, at least starting at bit 1, are 
safe to look at due to pointer alignment, but now you cannot atomically 
count...

So this seems unsolvable without having the caller specify that it knows the
page type, and that it is therefore safe to decrement page->dma_pinned_count.
I was hoping I'd found a way, but clearly I haven't. :)


thanks,
-- 
John Hubbard
NVIDIA
