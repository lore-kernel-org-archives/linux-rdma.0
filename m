From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 3/4] infiniband/mm: convert to the new put_user_page()
 call
Date: Wed, 3 Oct 2018 16:19:38 -0700
Message-ID: <75712e67-59f1-2057-dc89-779cdf5600ee@nvidia.com>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
 <20180928053949.5381-3-jhubbard@nvidia.com> <20180928153922.GA17076@ziepe.ca>
 <36bc65a3-8c2a-87df-44fc-89a1891b86db@nvidia.com>
 <20181003162758.GI24030@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003162758.GI24030@quack2.suse.cz>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On 10/3/18 9:27 AM, Jan Kara wrote:
> On Fri 28-09-18 20:12:33, John Hubbard wrote:
>>  static inline void release_user_pages(struct page **pages,
>> -                                     unsigned long npages)
>> +                                     unsigned long npages,
>> +                                     bool set_dirty)
>>  {
>> -       while (npages)
>> -               put_user_page(pages[--npages]);
>> +       if (set_dirty)
>> +               release_user_pages_dirty(pages, npages);
>> +       else
>> +               release_user_pages_basic(pages, npages);
>> +}
> 
> Is there a good reason to have this with set_dirty argument? Generally bool
> arguments are not great for readability (or greppability for that matter).
> Also in this case callers can just as easily do:
> 	if (set_dirty)
> 		release_user_pages_dirty(...);
> 	else
> 		release_user_pages(...);
> 
> And furthermore it makes the code author think more whether he needs
> set_page_dirty() or set_page_dirty_lock(), rather than just passing 'true'
> and hoping the function magically does the right thing for him.
> 

Ha, I went through *precisely* that argument in my head, too--and then
got seduced with the idea that it pretties up the existing calling code, 
because it's a drop-in one-liner at the call sites. But yes, I'll change it 
back to omit the bool set_dirty argument.

thanks,
-- 
John Hubbard
NVIDIA
