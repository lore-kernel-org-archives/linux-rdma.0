From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 13:13:56 -0800
Message-ID: <bcc03ee1-4c42-48c3-bc67-942c0f04875e@nvidia.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211201643.7599-3-ira.weiny@intel.com> <20190211203916.GA2771@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211203916.GA2771@ziepe.ca>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, ira.weiny@intel.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 2/11/19 12:39 PM, Jason Gunthorpe wrote:
> On Mon, Feb 11, 2019 at 12:16:42PM -0800, ira.weiny@intel.com wrote:
>> From: Ira Weiny <ira.weiny@intel.com>
[...]
>> +static inline int get_user_pages_fast_longterm(unsigned long start, int nr_pages,
>> +					       bool write, struct page **pages)
>> +{
>> +	return get_user_pages_fast(start, nr_pages, write, pages);
>> +}
>>  #endif /* CONFIG_FS_DAX */
>>  
>>  int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>> @@ -2615,6 +2622,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>>  #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
>>  #define FOLL_COW	0x4000	/* internal GUP flag */
>>  #define FOLL_ANON	0x8000	/* don't do file mappings */
>> +#define FOLL_LONGTERM	0x10000	/* mapping is intended for a long term pin */
> 
> If we are adding a new flag, maybe we should get rid of the 'longterm'
> entry points and just rely on the callers to pass the flag?
> 
> Jason
> 

+1, I agree that the overall get_user_pages*() API family will be cleaner
*without* get_user_pages_longterm*() calls. And this new flag makes that possible.
So I'd like to see the "longerm" call replaced with just passing this flag. Maybe
even as part of this patchset, but either way.

Taking a moment to reflect on where I think this might go eventually (the notes
below do not need to affect your patchset here, but this seems like a good place
to mention this):

It seems to me that the longterm vs. short-term is of questionable value.
It's actually better to just call get_user_pages(), and then if it really is
long-term enough to matter internally, we'll see the pages marked as gup-pinned.
If the gup pages are released before anyone (filesystem, that is) notices, then
it must have been short term.

Doing it that way is self-maintaining. Of course, this assumes that we end up with
a design that doesn't require being told, by the call sites, that a given gup
call is intended for "long term" use. So I could be wrong about this direction, but
let's please consider the possibility.

thanks,
-- 
John Hubbard
NVIDIA
