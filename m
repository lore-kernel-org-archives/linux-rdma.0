From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Sat, 27 Jun 2015 12:12:11 +0300
Message-ID: <558E68EB.9040205@dev.mellanox.co.il>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
 <558C317E.4010402@mellanox.com>
 <005401d0af69$53f5a9e0$fbe0fda0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <005401d0af69$53f5a9e0$fbe0fda0$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org
Cc: 'Or Gerlitz' <ogerlitz@mellanox.com>, 'Roi Dayan' <roid@mellanox.com>, 'target-devel' <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 8:06 PM, Steve Wise wrote:
>
>
>> -----Original Message-----
>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Sagi Grimberg
>> Sent: Thursday, June 25, 2015 11:51 AM
>> To: Steve Wise; linux-rdma@vger.kernel.org
>> Cc: Or Gerlitz; Roi Dayan; target-devel
>> Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
>>
>> On 6/25/2015 6:39 PM, Steve Wise wrote:
>>> Memory regions that are the target of an iWARP RDMA READ RESPONSE need
>>> REMOTE_WRITE access rights.  So enable REMOTE_WRITE for iWARP devices.
>>>
>>> iWARP RDMA READ target sge depth is 1.  So save the max_read_sge in
>>> the target device structure and use that when creating RDMA_READ work
>>> requests.
>>
>> Hi Steve,
>>
>> CC'ing target-devel...
>>
>>>
>>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>>> Tested-by: Vasu Dev <vasu.dev@intel.com>
>>> ---
>>>    drivers/infiniband/ulp/isert/ib_isert.c |   55 ++++++++++++++++++++++++++-----
>>>    drivers/infiniband/ulp/isert/ib_isert.h |    1 +
>>>    2 files changed, 48 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>>> index 9e7b492..b5cde5d 100644
>>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>>> @@ -165,6 +165,11 @@ isert_create_qp(struct isert_conn *isert_conn,
>>>    	attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
>>>    	isert_conn->max_sge = attr.cap.max_send_sge;
>>>
>>> +	if (rdma_cap_read_multi_sge(device->ib_device, cma_id->port_num))
>>> +		isert_conn->max_read_sge = isert_conn->max_sge;
>>> +	else
>>> +		isert_conn->max_read_sge = 1;
>>> +
>>
>> I think it would make sense to change now max_sge to max_write_sge.
>>
>
> Ok.
>
>> And, shouldn't we just use:
>> max_wr_sge = max(2, device->dev_attr.max_sge - 2);
>> max_rd_sge = device->dev_attr.max_sge_rd;
>>
>> Does the Chelsio device reports max_sge_rd != 1 ?
>>
>
> Yes, but I wasn't sure max_sge_rd is really the read target max sge.

Why not?

> I don't see it being set by the mlx* drivers.

Umm, that's a bug.
Let me send an easy fix for all mlx drivers.

> Also since we have the new rdma_cap_read_multi_sge() helper, I thought I should use it. :)

I think that reading the exact device caps max_sge, max_sge_is better
and more straight forward...
