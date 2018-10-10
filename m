From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v4 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Tue, 9 Oct 2018 17:32:16 -0700
Message-ID: <62492f47-d51f-5c41-628c-ff17de21829e@nvidia.com>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
 <20181008211623.30796-3-jhubbard@nvidia.com>
 <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
 <20181009083025.GE11150@quack2.suse.cz>
 <20181009162012.c662ef0b041993557e150035@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009162012.c662ef0b041993557e150035@linux-foundation.org>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 10/9/18 4:20 PM, Andrew Morton wrote:
> On Tue, 9 Oct 2018 10:30:25 +0200 Jan Kara <jack@suse.cz> wrote:
> 
>>> Also, maintainability.  What happens if someone now uses put_page() by
>>> mistake?  Kernel fails in some mysterious fashion?  How can we prevent
>>> this from occurring as code evolves?  Is there a cheap way of detecting
>>> this bug at runtime?
>>
>> The same will happen as with any other reference counting bug - the special
>> user reference will leak. It will be pretty hard to debug I agree. I was
>> thinking about whether we could provide some type safety against such bugs
>> such as get_user_pages() not returning struct page pointers but rather some
>> other special type but it would result in a big amount of additional churn
>> as we'd have to propagate this different type e.g. through the IO path so
>> that IO completion routines could properly call put_user_pages(). So I'm
>> not sure it's really worth it.
> 
> I'm not really understanding.  Patch 3/3 changes just one infiniband
> driver to use put_user_page().  But the changelogs here imply (to me)
> that every user of get_user_pages() needs to be converted to
> s/put_page/put_user_page/.
> 
> Methinks a bit more explanation is needed in these changelogs?
> 

OK, yes, it does sound like the explanation is falling short. I'll work on something 
clearer. Did the proposed steps in the changelogs, such as:
  
[2] https://lkml.kernel.org/r/20180709080554.21931-1-jhubbard@nvidia.com
    Proposed steps for fixing get_user_pages() + DMA problems.

help at all, or is it just too many references, and I should write the words
directly in the changelog?

Anyway, patch 3/3 is a just a working example (which we do want to submit, though), and
many more conversions will follow. But they don't have to be done all upfront--they
can be done in follow up patchsets. 

The put_user_page*() routines are, at this point, not going to significantly change
behavior. 

I'm working on an RFC that will show what the long-term fix to get_user_pages and
put_user_pages will look like. But meanwhile it's good to get started on converting
all of the call sites.

thanks,
-- 
John Hubbard
NVIDIA
