From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v4 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Thu, 11 Oct 2018 18:23:24 -0700
Message-ID: <97e89e08-5b94-240a-56e9-ece2b91f6dbc@nvidia.com>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
 <20181008211623.30796-3-jhubbard@nvidia.com>
 <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
 <5198a797-fa34-c859-ff9d-568834a85a83@nvidia.com>
 <20181010164541.ec4bf53f5a9e4ba6e5b52a21@linux-foundation.org>
 <20181011084929.GB8418@quack2.suse.cz> <20181011132013.GA5968@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181011132013.GA5968@ziepe.ca>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 10/11/18 6:20 AM, Jason Gunthorpe wrote:
> On Thu, Oct 11, 2018 at 10:49:29AM +0200, Jan Kara wrote:
> 
>>> This is a real worry.  If someone uses a mistaken put_page() then how
>>> will that bug manifest at runtime?  Under what set of circumstances
>>> will the kernel trigger the bug?
>>
>> At runtime such bug will manifest as a page that can never be evicted from
>> memory. We could warn in put_page() if page reference count drops below
>> bare minimum for given user pin count which would be able to catch some
>> issues but it won't be 100% reliable. So at this point I'm more leaning
>> towards making get_user_pages() return a different type than just
>> struct page * to make it much harder for refcount to go wrong...
> 
> At least for the infiniband code being used as an example here we take
> the struct page from get_user_pages, then stick it in a sgl, and at
> put_page time we get the page back out of the sgl via sg_page()
> 
> So type safety will not help this case... I wonder how many other
> users are similar? I think this is a pretty reasonable flow for DMA
> with user pages.
> 

That is true. The infiniband code, fortunately, never mixes the two page
types into the same pool (or sg list), so it's actually an easier example
than some other subsystems. But, yes, type safety doesn't help there. I can 
take a moment to look around at the other areas, to quantify how much a type
safety change might help.

Back to page flags again, out of desperation:

How much do we know about the page types that all of these subsystems
use? In other words, can we, for example, use bit 1 of page->lru.next (see [1]
for context) as the "dma-pinned" page flag, while tracking pages within parts 
of the kernel that call a mix of alloc_pages, get_user_pages, and other allocators? 
In order for that to work, page->index, page->private, and bit 1 of page->mapping
must not be used. I doubt that this is always going to hold, but...does it?

Other ideas: provide a fast lookup tree that tracks pages that were 
obtained via get_user_pages. Before calling put_page or put_user_page,
use that tree to decide which to call. Or anything along the lines of
"yet another way to track pages without using page flags".

(Also, Andrew: "ack" on your point about CC-ing you on all patches, I've fixed
my scripts accordingly, sorry about that.)


[1] Matthew Wilcox's idea for stealing some tracking bits, by removing
dma-pinned pages from the LRU:

   https://lore.kernel.org/r/20180619090255.GA25522@bombadil.infradead.org


thanks,
-- 
John Hubbard
NVIDIA
