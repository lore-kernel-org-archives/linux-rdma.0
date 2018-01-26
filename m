From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 15/16] IB/core: Map iWarp AH type to undefined in
 rdma_ah_find_type
Date: Fri, 26 Jan 2018 10:58:45 -0500
Message-ID: <ce815670-cf1b-5199-9a52-2779cb8f8c75@intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
 <20180126143315.6868.67354.stgit@scvm10.sc.intel.com>
 <20180126154540.GA23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126154540.GA23869-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/26/2018 10:45 AM, Jason Gunthorpe wrote:
> On Fri, Jan 26, 2018 at 06:33:18AM -0800, Dennis Dalessandro wrote:
>> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> iWarp devices do not support the creation of address handles
>> so return AH_ATTR_TYPE_UNDEFINED for all iWarp devices.
>>
>> While we are here reduce the size of port_num to u8 and add
>> a comment.
>>
>> Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
>> Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>   include/rdma/ib_verbs.h |   15 +++++++++++----
>>   1 files changed, 11 insertions(+), 4 deletions(-)
> 
> What tree are you sending these patches again? This won't apply.

Ugh, I thought I was up to date. Guess not. Let me rebase and respin. 
Looks like you had a comment on one of the other patches so I'll wait 
for Alex to address that and re-send.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
