From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 10:32:36 +0200
Message-ID: <55375CA4.2050606@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <20150422024123.GA18675@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150422024123.GA18675-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/22/2015 04:41 AM, ira.weiny wrote:
[snip]
> 
>>
>> 5) Do no modify phys_state_show() in [PATCH v5 09/27] IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>> It *is* the link layer!
> 
> I agree with this.  When the Link Layer is directly being requested we should
> report the link layer.  However, the internal uses of Link Layer should be
> minimal if not 0.

Reform on link_layer_show() and ib_uverbs_query_port() Will be
dropped in next version :-)

Regards,
Michael Wang

> 
>>
>> 6) Remove cap_read_multi_sge
>> It is not device/port feature, but a transport capability.
>> Use rdma_is_iwarp_transport() instead, or introduce a new transport flag in 'enum ib_device_cap_flags'.
> 
> This was already debated and we settled on cap_read_multi_sge.  Checking the
> transport does not allow for other verbs devices to support this unless they set
> that same transport.
> 
>>  
>> 7) Remove [PATCH v5 25/27] IB/Verbs: Use management helper cap_eth_ah().
>> Address handles that refer to Ethernet links always have Ethernet addressing.
> 
> But how does the upper level code _know_ that?  That is the point of
> cap_eth_ah.
> 
>>
>> In the CMA code, using rdma_tech_iboe() is just fine. This is how you define cap_eth_ah() anyway.
>> Currently, this patch just adds clutter.
>>
>> 8) Remove patch [PATCH v5 26/27] IB/Verbs: Clean up rdma_ib_or_iboe().
>> We do need a transport qualifier, as exemplified in comment 5) above, and for a complete clean model.
> 
> I'm confused, comment 5 was talking about Link Layer???
> 
>> This is after renaming the function to rdma_is_ib_transport()...
>>
>>
>> Putting it all together
>> ==================
>>
>> We are left with the following helpers:
>> - rdma_is_ib_transport()
>> - rdma_is_iwarp_transport()
>> - rdma_is_usnic_transport()
>> - rdma_is_iboe()
>> - rdma_has_mad()
> 
> Not sufficient to distinguish OPA MADs from IB
> 
>> - rdma_has_smi()
>> - rdma_has_gsi() - complements smi; can be used by the mad code for clarity
>> - rdma_has_sa()
>> - rdma_has_cm()
> 
> Not sufficient to distinguish between the IB CM and iWarp "CM".
> 
>> - rdma_has_mcast()
> 
> Not sufficient to distinguish between the IB Multicast vs IBoE Multicast.
> 
> 
> In general I'm flexible on the function names.  "cap" vs "rdma" does not really
> matter to me.  Likewise "has" vs "requires" vs "uses" does not matter.
> 
> Regardless we still need more granularity than "Transport" and "Link Layer" for many
> of the code choices.
> 
> The result of this series is pretty explicit and much cleaner as to what the
> upper layers are really checking for.
> 
> Furthermore we know that the implementations are going to change going forward.
> The point of this series is to decouple the MAD, CM, SA, IPoIB, etc modules
> from the knowledge of transport and link layer.  The new interface is simply
> using the old implementation as a stepping stone.
> 
> Ira
> 
>>
>>
>>> Subject: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
>>>
>>>
>>> Since v4:
>>>   * Thanks for the comments from Hal, Sean, Tom, Or Gerlitz, Jason,
>>>     Roland, Ira and Steve :-) Please remind me if anything missed :-P
>>>   * Fix logical issue inside 3#, 14#
>>>   * Refine 3#, 4#, 5# with label 'free'
>>>   * Rework 10# to stop using port 1 when port already assigned
>>>
>>> There are plenty of lengthy code to check the transport type of IB device, or
>>> the link layer type of it's port, but actually we are just speculating whether a
>>> particular management/feature is supported by the device/port.
>>>
>>> Thus instead of inferring, we should have our own mechanism for IB
>>> management capability/protocol/feature checking, several proposals below.
>>>
>>> This patch set will reform the method of getting transport type, we will now
>>> using query_transport() instead of inferring from transport and link layer
>>> respectively, also we defined the new transport type to make the concept
>>> more reasonable.
>>>
>>> Mapping List:
>>> 		node-type	link-layer	old-transport	new-transport
>>> nes		RNIC		ETH		IWARP		IWARP
>>> amso1100	RNIC		ETH		IWARP		IWARP
>>> cxgb3   	RNIC		ETH		IWARP		IWARP
>>> cxgb4   	RNIC		ETH		IWARP		IWARP
>>> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
>>> ocrdma  	IB_CA		ETH		IB		IBOE
>>> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
>>> mlx5    	IB_CA		IB		IB		IB
>>> ehca    	IB_CA		IB		IB		IB
>>> ipath   	IB_CA		IB		IB		IB
>>> mthca   	IB_CA		IB		IB		IB
>>> qib     	IB_CA		IB		IB		IB
>>>
>>> For example:
>>> 	if (transport == IB) && (link-layer == ETH) will now become:
>>> 	if (query_transport() == IBOE)
>>>
>>> Thus we will be able to get rid of the respective transport and link-layer
>>> checking, and it will help us to add new protocol/Technology (like OPA) more
>>> easier, also with the introduced management helpers, IB management logical
>>> will be more clear and easier for extending.
>>>
>>> Highlights:
>>>     The patch set covered a wide range of IB stuff, thus for those who are
>>>     familiar with the particular part, your suggestion would be invaluable ;-)
>>>
>>>     Patch 1#~15# included all the logical reform, 16#~25# introduced the
>>>     management helpers, 26#~27# do clean up.
>>>
>>>     Patches haven't been tested yet, we appreciate if any one who have these
>>>     HW willing to provide his Tested-by :-)
>>>
>>>     Doug suggested the bitmask mechanism:
>>> 	https://www.mail-archive.com/linux-
>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
>>>     which could be the plan for future reforming, we prefer that to be another
>>>     series which focus on semantic and performance.
>>>
>>>     This patch-set is somewhat 'bloated' now and it may be a good timing for
>>>     staging, I'd like to suggest we focus on improving existed helpers and push
>>>     all the further reforms into next series ;-)
>>>
>>> Proposals:
>>>     Sean:
>>> 	https://www.mail-archive.com/linux-
>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23339.html
>>>     Doug:
>>> 	https://www.mail-archive.com/linux-
>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23418.html
>>> 	https://www.mail-archive.com/linux-
>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
>>>     Jason:
>>> 	https://www.mail-archive.com/linux-
>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23425.html
>>>
>>> Michael Wang (27):
>>>     IB/Verbs: Implement new callback query_transport()
>>>     IB/Verbs: Implement raw management helpers
>>>     IB/Verbs: Reform IB-core mad/agent/user_mad
>>>     IB/Verbs: Reform IB-core cm
>>>     IB/Verbs: Reform IB-core sa_query
>>>     IB/Verbs: Reform IB-core multicast
>>>     IB/Verbs: Reform IB-ulp ipoib
>>>     IB/Verbs: Reform IB-ulp xprtrdma
>>>     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>>>     IB/Verbs: Reform cm related part in IB-core cma/ucm
>>>     IB/Verbs: Reform route related part in IB-core cma
>>>     IB/Verbs: Reform mcast related part in IB-core cma
>>>     IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>>     IB/Verbs: Reform cma_acquire_dev()
>>>     IB/Verbs: Reform rest part in IB-core cma
>>>     IB/Verbs: Use management helper cap_ib_mad()
>>>     IB/Verbs: Use management helper cap_ib_smi()
>>>     IB/Verbs: Use management helper cap_ib_cm()
>>>     IB/Verbs: Use management helper cap_iw_cm()
>>>     IB/Verbs: Use management helper cap_ib_sa()
>>>     IB/Verbs: Use management helper cap_ib_mcast()
>>>     IB/Verbs: Use management helper cap_ipoib()
>>>     IB/Verbs: Use management helper cap_read_multi_sge()
>>>     IB/Verbs: Use management helper cap_af_ib()
>>>     IB/Verbs: Use management helper cap_eth_ah()
>>>     IB/Verbs: Clean up rdma_ib_or_iboe()
>>>     IB/Verbs: Cleanup rdma_node_get_transport()
>>>
>>> ---
>>>  drivers/infiniband/core/agent.c              |    4
>>>  drivers/infiniband/core/cm.c                 |   26 +-
>>>  drivers/infiniband/core/cma.c                |  328 ++++++++++++---------------
>>>  drivers/infiniband/core/device.c             |    1
>>>  drivers/infiniband/core/mad.c                |   51 ++--
>>>  drivers/infiniband/core/multicast.c          |   18 -
>>>  drivers/infiniband/core/sa_query.c           |   41 +--
>>>  drivers/infiniband/core/sysfs.c              |    8
>>>  drivers/infiniband/core/ucm.c                |    5
>>>  drivers/infiniband/core/ucma.c               |   27 --
>>>  drivers/infiniband/core/user_mad.c           |   32 +-
>>>  drivers/infiniband/core/uverbs_cmd.c         |    6
>>>  drivers/infiniband/core/verbs.c              |   33 --
>>>  drivers/infiniband/hw/amso1100/c2_provider.c |    7
>>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7
>>>  drivers/infiniband/hw/cxgb4/provider.c       |    7
>>>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6
>>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3
>>>  drivers/infiniband/hw/ehca/ehca_main.c       |    1
>>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7
>>>  drivers/infiniband/hw/mlx4/main.c            |   10
>>>  drivers/infiniband/hw/mlx5/main.c            |    7
>>>  drivers/infiniband/hw/mthca/mthca_provider.c |    7
>>>  drivers/infiniband/hw/nes/nes_verbs.c        |    6
>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1
>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6
>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3
>>>  drivers/infiniband/hw/qib/qib_verbs.c        |    7
>>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1
>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6
>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2
>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
>>>  include/rdma/ib_verbs.h                      |  204 +++++++++++++++-
>>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6
>>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
>>>  35 files changed, 584 insertions(+), 368 deletions(-)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
>>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>>> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
