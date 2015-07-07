From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to
 device fastreg max depth
Date: Tue, 7 Jul 2015 09:26:53 +0300
Message-ID: <559B712D.7020105@dev.mellanox.co.il>
References: <20150705174353.10042.39648.stgit@build2.ogc.int>
 <20150705174452.10042.44695.stgit@build2.ogc.int>
 <559A335A.90506@dev.mellanox.co.il>
 <001401d0b7f9$09c21b40$1d4651c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <001401d0b7f9$09c21b40$1d4651c0$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com
Cc: infinipath@intel.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 7/6/2015 5:35 PM, Steve Wise wrote:
>
>
>> -----Original Message-----
>> From: Sagi Grimberg [mailto:sagig@dev.mellanox.co.il]
>> Sent: Monday, July 06, 2015 2:51 AM
>> To: Steve Wise; dledford@redhat.com
>> Cc: infinipath@intel.com; sagig@mellanox.com; ogerlitz@mellanox.com; roid@mellanox.com; linux-rdma@vger.kernel.org;
>> eli@mellanox.com; target-devel@vger.kernel.org
>> Subject: Re: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
>>
>> On 7/5/2015 8:44 PM, Steve Wise wrote:
>>> Currently the sg tablesize, which dictates fast register page list
>>> depth to use, does not take into account the limits of the rdma device.
>>> So adjust it once we discover the device fastreg max depth limit.  Also
>>> adjust the max_sectors based on the resulting sg tablesize.
>>>
>>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>>> ---
>>>
>>>    drivers/infiniband/ulp/iser/iscsi_iser.c |    9 +++++++++
>>>    1 files changed, 9 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> index 6a594aa..de8730d 100644
>>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> @@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>>>    						   SHOST_DIX_GUARD_CRC);
>>>    		}
>>>
>>> +		/*
>>> +		 * Limit the sg_tablesize and max_sectors based on the device
>>> +		 * max fastreg page list length.
>>> +		 */
>>> +		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
>>> +			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
>>> +		shost->max_sectors = min_t(unsigned int,
>>> +			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
>>> +
>>
>> The min statement is meaningless for max_sectors - you do a min between
>> default sg_tablesize and frpl length - so the maximum sg_tablesize is
>> 128 which is 1024 max_sectors.
>
> I'm not following.  What if ib_conn->device->dev_attr.max_fast_reg_page_list_len is say, 32?
> Then shost->sg_tablesize is set to 32, and max_sectors is set to (32*4K) >> 9 == 256 512B sectors.

Correct - but it cannot exceed 1024 (as it is derived from sg_tablesize
which is maximum 128).
