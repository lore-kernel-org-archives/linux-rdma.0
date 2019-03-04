From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error handling
 paths
Date: Mon, 4 Mar 2019 15:36:02 -0800
Message-ID: <f73f326b-1ef3-075a-ca11-88d0d881dacb@nvidia.com>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
 <20190303165550.GB27123@iweiny-DESK2.sc.intel.com>
 <bef8680b-acc5-9f13-f49e-8f36f1939387@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bef8680b-acc5-9f13-f49e-8f36f1939387@nvidia.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>, Artemy Kovalyov <artemyko@mellanox.com>
Cc: "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 3/4/19 3:11 PM, John Hubbard wrote:
> On 3/3/19 8:55 AM, Ira Weiny wrote:
>> On Sun, Mar 03, 2019 at 11:52:41AM +0200, Artemy Kovalyov wrote:
>>>
>>>
>>> On 02/03/2019 21:44, Ira Weiny wrote:
>>>>
>>>> On Sat, Mar 02, 2019 at 12:24:35PM -0800, john.hubbard@gmail.com wrote:
>>>>> From: John Hubbard <jhubbard@nvidia.com>
>>>>>
>>>>> ...
>>>>> 3. Dead code removal: the check for (user_virt & ~page_mask)
>>>>> is checking for a condition that can never happen,
>>>>> because earlier:
>>>>>
>>>>>      user_virt = user_virt & page_mask;
>>>>>
>>>>> ...so, remove that entire phrase.
>>>>>
>>>>>   		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
>>>>>   		mutex_lock(&umem_odp->umem_mutex);
>>>>>   		for (j = 0; j < npages; j++, user_virt += PAGE_SIZE) {
>>>>> -			if (user_virt & ~page_mask) {
>>>>> -				p += PAGE_SIZE;
>>>>> -				if (page_to_phys(local_page_list[j]) != p) {
>>>>> -					ret = -EFAULT;
>>>>> -					break;
>>>>> -				}
>>>>> -				put_page(local_page_list[j]);
>>>>> -				continue;
>>>>> -			}
>>>>> -
>>>>
>>>> I think this is trying to account for compound pages. (ie page_mask could
>>>> represent more than PAGE_SIZE which is what user_virt is being incrimented by.)
>>>> But putting the page in that case seems to be the wrong thing to do?
>>>>
>>>> Yes this was added by Artemy[1] now cc'ed.
>>>
>>> Right, this is for huge pages, please keep it.
>>> put_page() needed to decrement refcount of the head page.
>>
>> You mean decrement the refcount of the _non_-head pages?
>>
>> Ira
>>
> 
> Actually, I'm sure Artemy means head page, because put_page() always
> operates on the head page. 
> 
> And this reminds me that I have a problem to solve nearby: get_user_pages
> on huge pages increments the page->_refcount *for each tail page* as well.
> That's a minor problem for my put_user_page() 
> patchset, because my approach so far assumed that I could just change us
> over to:
> 
> get_user_page(): increments page->_refcount by a large amount (1024)
> 
> put_user_page(): decrements page->_refcount by a large amount (1024)
> 
> ...and just stop doing the odd (to me) technique of incrementing once for
> each tail page. I cannot see any reason why that's actually required, as
> opposed to just "raise the page->_refcount enough to avoid losing the head
> page too soon".
> 
> However, it may be tricky to do this in one pass. Probably at first, I'll have
> to do this horrible thing approach:
> 
> get_user_page(): increments page->_refcount by a large amount (1024)
> 
> put_user_page(): decrements page->_refcount by a large amount (1024) MULTIPLIED
>                  by the number of tail pages. argghhh that's ugly.
> 

I see that this is still not stated quite right.

...to clarify, I mean to leave the existing behavior alone. So it would be
the call sites (not put_user_page as the above says) that would be doing all
that decrementing. The call sites know how many decrements are appropriate.

Unless someone thinks of a clever way to clean this up in one shot. I'm not
really seeing any way.

thanks,
-- 
John Hubbard
NVIDIA
