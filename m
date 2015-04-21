From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 04/27] IB/Verbs: Reform IB-core cm
Date: Tue, 21 Apr 2015 09:42:22 +0200
Message-ID: <5535FF5E.4080502@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534B9E9.1020108@profitbricks.com> <5535318A.8050307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5535318A.8050307@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/20/2015 07:04 PM, Hal Rosenstock wrote:
> On 4/20/2015 4:33 AM, Michael Wang wrote:
>>
>> Use raw management helpers to reform IB-core cm.
>>
>> Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
>> Cc: Steve Wise <swise@opengridcomputing.com>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Cc: Doug Ledford <dledford@redhat.com>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Sean Hefty <sean.hefty@intel.com>
>> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
>> ---
>>  drivers/infiniband/core/cm.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>> index e28a494..3c10b75 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -3761,9 +3761,7 @@ static void cm_add_one(struct ib_device *ib_device)
>>  	unsigned long flags;
>>  	int ret;
>>  	u8 i;
>> -
>> -	if (rdma_node_get_transport(ib_device->node_type) != RDMA_TRANSPORT_IB)
>> -		return;
>> +	int count = 0;
> 
> Nit: Should the int count line be moved above u8 i declaration so
> declarations are naturally aligned ?

Make sense, will be in next version :-)

Regards,
Michael Wang

> 
> -- Hal
> 
> <snip...>
> 
