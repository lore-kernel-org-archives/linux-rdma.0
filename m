From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-rc 0/2] IB/hfi1: Fixes for rc or next if too late
Date: Thu, 31 May 2018 15:08:56 -0400
Message-ID: <6fa4efc3-621e-7411-b72b-ab42c18d1e86@intel.com>
References: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
 <b9791f286ef1be4def5085353a9ee7975957b2d8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <b9791f286ef1be4def5085353a9ee7975957b2d8.camel@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 5/31/2018 2:47 PM, Doug Ledford wrote:
> On Thu, 2018-05-31 at 11:29 -0700, Dennis Dalessandro wrote:
>> Hi Doug and Jason,
>>
>> We have two more late breaking fix up patches. The DMA_RTAIL fix is the more
>> serious of the two. I realize we are at the tail end of 4.17 so I would not be
>> against holding off till 4.18 for these, but if there is another rdma
>> pull request we may want to tack these on.
>>
>> ---
>>
>> Kaike Wan (1):
>>        IB/hfi1: Ensure VL index is within bounds
>>
>> Mike Marciniszyn (1):
>>        IB/hfi1: Fix user context tail allocation for DMA_RTAIL
>>
>>
>>   drivers/infiniband/hw/hfi1/chip.c     |    8 ++++----
>>   drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
>>   drivers/infiniband/hw/hfi1/init.c     |    9 ++++-----
>>   drivers/infiniband/hw/hfi1/sdma.c     |   12 +++---------
>>   4 files changed, 12 insertions(+), 19 deletions(-)
>>
>> --
>> -Denny
> 
> Hi Denny,
> 
> These two patches look fine in terms of the patches themselves.  In
> terms of whether to put them in for-rc or for-next, what's the
> consequences of hitting each of these bugs?
> 

The VL index, could be bad because it would jump beyond the end of the 
array. However, we won't actually hit that with the code the way it 
currently is because of the way we validate the VL in other areas of the 
code. This is more of a we better fix it before we do end up with a 
problem sort of thing.

In the other one, the DMA_RTAIL one, the driver ends up mmaping NULL and 
handing that user space. This only happens though if users muck with the 
CAP_MASK and enable the dma of the rtail. Which is not the default. Mike 
found this through code inspection I believe.

So they do fix serious flaws, but the likelihood of actually hitting 
them is very slim. Based on the stable tag on Mike's patch we have had 
this since 4.9.

-Denny
