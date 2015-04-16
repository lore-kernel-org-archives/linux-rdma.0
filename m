From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v4 27/27] IB/Verbs: Cleanup rdma_node_get_transport()
Date: Thu, 16 Apr 2015 15:45:24 +0200
Message-ID: <552FBCF4.2070105@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com> <552F6FB4.3060903@profitbricks.com> <552FBAD6.6000400@dev.mellanox.co.il> <552FBBEC.3020606@profitbricks.com> <552FBC48.3010900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552FBC48.3010900@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/16/2015 03:42 PM, Hal Rosenstock wrote:
> On 4/16/2015 9:41 AM, Michael Wang wrote:
>>
>>
>> On 04/16/2015 03:36 PM, Hal Rosenstock wrote:
>> [snip]
>>>> -EXPORT_SYMBOL(rdma_node_get_transport);
>>>> -
>>>>  enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_num)
>>>>  {
>>>>  	if (device->get_link_layer)
>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>> index 262bf44..f9ef479 100644
>>>> --- a/include/rdma/ib_verbs.h
>>>> +++ b/include/rdma/ib_verbs.h
>>>> @@ -84,9 +84,6 @@ enum rdma_transport_type {
>>>>  	RDMA_TRANSPORT_IBOE,
>>>>  };
>>>>  
>>>> -__attribute_const__ enum rdma_transport_type
>>>> -rdma_node_get_transport(enum rdma_node_type node_type);
>>>> -
>>>>  enum rdma_link_layer {
>>>>  	IB_LINK_LAYER_UNSPECIFIED,
>>>
>>> Is IB_LINK_LAYER_UNSPECIFIED still possible ?
>>
>> Actually it's impossible in kernel at first, all those who implemented the callback
>> won't return UNSPECIFIED, others all have the correct transport type (otherwise BUG())
>> and won't result UNSPECIFIED :-)
> 
> Should it be removed from this enum somewhere in this patch series
> (perhaps early on) ?

It was still directly used by helper like ib_modify_qp_is_ok() as indicator, may be
better in another following patch to reform those part :-)

Regards,
Michael Wang

> 
> -- Hal
> 
>> Regards,
>> Michael Wang
>>
>>>
>>>>  	IB_LINK_LAYER_INFINIBAND,
>>
> 
