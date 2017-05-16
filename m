From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 7/8] IB/core: Change wc.slid from 16 to 32 bits
Date: Tue, 16 May 2017 10:30:25 -0700
Message-ID: <70d90380-4f5d-c86f-86a4-d32a1d9b2bf4@intel.com>
References: <1494458576-6816-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458576-6816-8-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20170513105558.GJ3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170513105558.GJ3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 5/13/2017 3:55 AM, Leon Romanovsky wrote:
> On Wed, May 10, 2017 at 07:22:55PM -0400, Dasaratharaman Chandramouli wrote:
>> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> slid field in struct ib_wc is increased to 32 bits.
>> This enables core components to use larger LIDs if needed.
>> The user ABI is unchanged and return 16 bit values when queried.
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/infiniband/core/cm.c            |  4 ++--
>>   drivers/infiniband/core/user_mad.c      |  2 +-
>>   drivers/infiniband/core/uverbs_cmd.c    | 11 ++++++++---
>>   drivers/infiniband/hw/hfi1/mad.c        |  2 +-
>>   drivers/infiniband/hw/mlx4/mad.c        |  6 +++---
>>   drivers/infiniband/hw/mlx5/mad.c        |  2 +-
>>   drivers/infiniband/hw/mthca/mthca_cmd.c |  4 ++--
>>   drivers/infiniband/hw/mthca/mthca_mad.c |  2 +-
>>   drivers/infiniband/sw/rdmavt/cq.c       |  2 +-
>>   include/rdma/ib_verbs.h                 |  2 +-
>>   10 files changed, 21 insertions(+), 16 deletions(-)
> 
> I disagree that casting from u32 to u16 in various places is right
> thing to do. Please introduce simple common helper, with proper comment
> on it and meaningful name and use it safely.
> 
> Thanks
> 
Hi Leon,

We'll introduce a helper function and post with the next patch revision.

Thank you.

don

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
