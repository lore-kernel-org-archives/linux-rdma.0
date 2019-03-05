From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error handling
 paths
Date: Tue, 5 Mar 2019 12:10:03 -0800
Message-ID: <9502d777-73e1-f96f-120d-acc1f31045ae@nvidia.com>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
 <20190303165550.GB27123@iweiny-DESK2.sc.intel.com>
 <bef8680b-acc5-9f13-f49e-8f36f1939387@nvidia.com>
 <20190304201338.GA28731@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304201338.GA28731@iweiny-DESK2.sc.intel.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 3/4/19 12:13 PM, Ira Weiny wrote:
[snip]
>> And this reminds me that I have a problem to solve nearby: get_user_pages
>> on huge pages increments the page->_refcount *for each tail page* as well.
>> That's a minor problem for my put_user_page() 
>> patchset, because my approach so far assumed that I could just change us
>> over to:
>>
>> get_user_page(): increments page->_refcount by a large amount (1024)
>>
>> put_user_page(): decrements page->_refcount by a large amount (1024)
>>
>> ...and just stop doing the odd (to me) technique of incrementing once for
>> each tail page. I cannot see any reason why that's actually required, as
>> opposed to just "raise the page->_refcount enough to avoid losing the head
>> page too soon".
> 
> What about splitting a huge page?
> 
> From Documention/vm/transhuge.rst
> 
> <quoute>
> split_huge_page internally has to distribute the refcounts in the head
> page to the tail pages before clearing all PG_head/tail bits from the page
> structures. It can be done easily for refcounts taken by page table
> entries. But we don't have enough information on how to distribute any
> additional pins (i.e. from get_user_pages). split_huge_page() fails any
> requests to split pinned huge page: it expects page count to be equal to
> sum of mapcount of all sub-pages plus one (split_huge_page caller must
> have reference for head page).
> </quote>
> 

heh, so in the end, split_huge_page just needs enough information to say
"no" for gup pages. So as long as page->_refcount avoids one particular
value, the code keeps working. :)


> FWIW, I'm not sure why it needs to "store" the reference in the head page for
> this.  I don't see any check to make sure the ref has been "stored" but I'm not
> really familiar with the compound page code yet.
> 
> Ira
> 

Thanks for peeking at this, I'll look deeper too.

thanks,
-- 
John Hubbard
NVIDIA
