From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 1/1] infiniband/mm: convert put_page() to put_user_page*()
Date: Thu, 23 May 2019 10:46:38 -0700
Message-ID: <fa6d7d7c-13a3-0586-6384-768ebb7f0561@nvidia.com>
References: <20190523072537.31940-1-jhubbard@nvidia.com>
 <20190523072537.31940-2-jhubbard@nvidia.com>
 <20190523172852.GA27175@iweiny-DESK2.sc.intel.com>
 <20190523173222.GH12145@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523173222.GH12145@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, Ira Weiny <ira.weiny@intel.com>
Cc: "john.hubbard@gmail.com" <john.hubbard@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>
List-Id: linux-rdma@vger.kernel.org

On 5/23/19 10:32 AM, Jason Gunthorpe wrote:
> On Thu, May 23, 2019 at 10:28:52AM -0700, Ira Weiny wrote:
>>>   
>>> @@ -686,8 +686,8 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
>>>   			 * ib_umem_odp_map_dma_single_page().
>>>   			 */
>>>   			if (npages - (j + 1) > 0)
>>> -				release_pages(&local_page_list[j+1],
>>> -					      npages - (j + 1));
>>> +				put_user_pages(&local_page_list[j+1],
>>> +					       npages - (j + 1));
>>
>> I don't know if we discussed this before but it looks like the use of
>> release_pages() was not entirely correct (or at least not necessary) here.  So
>> I think this is ok.
> 
> Oh? John switched it from a put_pages loop to release_pages() here:
> 
> commit 75a3e6a3c129cddcc683538d8702c6ef998ec589
> Author: John Hubbard <jhubbard@nvidia.com>
> Date:   Mon Mar 4 11:46:45 2019 -0800
> 
>      RDMA/umem: minor bug fix in error handling path
>      
>      1. Bug fix: fix an off by one error in the code that cleans up if it fails
>         to dma-map a page, after having done a get_user_pages_remote() on a
>         range of pages.
>      
>      2. Refinement: for that same cleanup code, release_pages() is better than
>         put_page() in a loop.
>      
> 
> And now we are going to back something called put_pages() that
> implements the same for loop the above removed?
> 
> Seems like we are going in circles?? John?
> 

put_user_pages() is meant to be a drop-in replacement for release_pages(),
so I made the above change as an interim step in moving the callsite from
a loop, to a single call.

And at some point, it may be possible to find a way to optimize put_user_pages()
in a similar way to the batching that release_pages() does, that was part
of the plan for this.

But I do see what you mean: in the interim, maybe put_user_pages() should
just be calling release_pages(), how does that change sound?


thanks,
-- 
John Hubbard
NVIDIA
