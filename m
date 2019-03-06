From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error handling
 paths
Date: Tue, 5 Mar 2019 18:04:35 -0800
Message-ID: <1f922d79-0057-ed80-305c-01768dd40cad@nvidia.com>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
 <332021c5-ab72-d54f-85c8-b2b12b76daed@nvidia.com>
 <903383a6-f2c9-4a69-83c0-9be9c052d4be@mellanox.com>
 <20190306013213.GA1662@ziepe.ca>
 <74f196a1-bd27-2e94-2f9f-0cf657eb0c91@nvidia.com>
 <be6303c6-d8d2-483a-5271-b6707c21178e@nvidia.com>
 <20190306015123.GB1662@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306015123.GB1662@ziepe.ca>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 3/5/19 5:51 PM, Jason Gunthorpe wrote:
> On Tue, Mar 05, 2019 at 05:37:18PM -0800, John Hubbard wrote:
>> On 3/5/19 5:34 PM, John Hubbard wrote:
>> [snip]
>>>>> So release_pages(&local_page_list[j+1], npages - j-1) would be correct.
>>>>
>>>> Someone send a fixup patch please...
>>>>
>>>> Jason
>>>
>>> Yeah, I'm on it. Just need to double-check that this is the case. But Jason,
>>> you're confirming it already, so that helps too.
> 
> I didn't look, just assuming Artemy is right since he knows this
> code..
> 

OK. And I've confirmed it, too.

>>> Patch coming shortly.
>>>
>>
>> Jason, btw, do you prefer a patch that fixes the previous one, or a new 
>> patch that stands alone? (I'm not sure how this tree is maintained, exactly.)
> 
> It has past the point when I should apply a fixup, rdma is general has
> about an approximately 1 day period after the 'thanks applied' message
> where rebase is possible
> 
> Otherwise the tree is strictly no rebase
> 
> Jason
> 

Got it, patch is posted now.

thanks,
-- 
John Hubbard
NVIDIA
