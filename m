From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 27/27] IB/Verbs: Cleanup rdma_node_get_transport()
Date: Thu, 16 Apr 2015 09:42:32 -0400
Message-ID: <552FBC48.3010900@dev.mellanox.co.il>
References: <552F6CF2.4000606@profitbricks.com> <552F6FB4.3060903@profitbricks.com> <552FBAD6.6000400@dev.mellanox.co.il> <552FBBEC.3020606@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FBBEC.3020606-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2015 9:41 AM, Michael Wang wrote:
> 
> 
> On 04/16/2015 03:36 PM, Hal Rosenstock wrote:
> [snip]
>>> -EXPORT_SYMBOL(rdma_node_get_transport);
>>> -
>>>  enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_num)
>>>  {
>>>  	if (device->get_link_layer)
>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>> index 262bf44..f9ef479 100644
>>> --- a/include/rdma/ib_verbs.h
>>> +++ b/include/rdma/ib_verbs.h
>>> @@ -84,9 +84,6 @@ enum rdma_transport_type {
>>>  	RDMA_TRANSPORT_IBOE,
>>>  };
>>>  
>>> -__attribute_const__ enum rdma_transport_type
>>> -rdma_node_get_transport(enum rdma_node_type node_type);
>>> -
>>>  enum rdma_link_layer {
>>>  	IB_LINK_LAYER_UNSPECIFIED,
>>
>> Is IB_LINK_LAYER_UNSPECIFIED still possible ?
> 
> Actually it's impossible in kernel at first, all those who implemented the callback
> won't return UNSPECIFIED, others all have the correct transport type (otherwise BUG())
> and won't result UNSPECIFIED :-)

Should it be removed from this enum somewhere in this patch series
(perhaps early on) ?

-- Hal

> Regards,
> Michael Wang
> 
>>
>>>  	IB_LINK_LAYER_INFINIBAND,
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
