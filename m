From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Tue, 21 Apr 2015 17:56:36 +0200
Message-ID: <55367334.9000608@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <EE7902D3F51F404C82415C4803930ACD5DC44113@CMEXMB1.ad.emulex.com> <5536006E.3000200@profitbricks.com> <EE7902D3F51F404C82415C4803930ACD5DC44287@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC44287@CMEXMB1.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <Devesh.Sharma@Emulex.Com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/21/2015 01:03 PM, Devesh Sharma wrote:
> Hi Michael,
> 
> It will be great help if you could base you patches on existing Roland's tree and share to branch details to pull. 
> Just like Chuck lever does for his nfs-rdma patches?

I've setup a repository in:
	https://github.com/ywang-pb/infiniband-wy
git url is:
	git@github.com:ywang-pb/infiniband-wy.git

It's based on latest infiniband/for-next, branch 'mgmt-helpers' contain
this patch set, please let me know if there are any issues :-)

Regards,
Michael Wang

> 
> -Regards
> Devesh
> 
>> -----Original Message-----
>> From: Michael Wang [mailto:yun.wang@profitbricks.com]
>> Sent: Tuesday, April 21, 2015 1:17 PM
>> To: Devesh Sharma; Roland Dreier; Sean Hefty; Hal Rosenstock; linux-
>> rdma@vger.kernel.org; linux-kernel@vger.kernel.org; hal@dev.mellanox.co.il
>> Cc: Tom Tucker; Steve Wise; Hoang-Nam Nguyen; Christoph Raisch; Mike
>> Marciniszyn; Eli Cohen; Faisal Latif; Jack Morgenstein; Or Gerlitz; Haggai Eran;
>> Ira Weiny; Tom Talpey; Jason Gunthorpe; Doug Ledford
>> Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
>>
>> Hi, Devesh
>>
>> On 04/21/2015 07:41 AM, Devesh Sharma wrote:
>>> Hi Michael,
>>>
>>> is there a specific git branch available to pull out all the patches?
>>
>> Not yet, we may need the maintainer to tell us which branch could the series
>> been applied for testing purpose, after we all satisfied :-)
>>
>> For now we could 'git am' these patches to 'infiniband.git/for-next'
>> in order to do testing.
>>
>> Regards,
>> Michael Wang
>>
>>>
>>> -Regards
>>> Devesh
>>>
>>>> -----Original Message-----
>>>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>>>> owner@vger.kernel.org] On Behalf Of Michael Wang
>>>> Sent: Monday, April 20, 2015 1:59 PM
>>>> To: Roland Dreier; Sean Hefty; Hal Rosenstock;
>>>> linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>> hal@dev.mellanox.co.il
>>>> Cc: Tom Tucker; Steve Wise; Hoang-Nam Nguyen; Christoph Raisch; Mike
>>>> Marciniszyn; Eli Cohen; Faisal Latif; Jack Morgenstein; Or Gerlitz;
>>>> Haggai Eran; Ira Weiny; Tom Talpey; Jason Gunthorpe; Doug Ledford;
>>>> Michael Wang
>>>> Subject: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
>>>>
>>>>
>>>> Since v4:
>>>>   * Thanks for the comments from Hal, Sean, Tom, Or Gerlitz, Jason,
>>>>     Roland, Ira and Steve :-) Please remind me if anything missed :-P
>>>>   * Fix logical issue inside 3#, 14#
>>>>   * Refine 3#, 4#, 5# with label 'free'
>>>>   * Rework 10# to stop using port 1 when port already assigned
>>>>
>>>> There are plenty of lengthy code to check the transport type of IB
>>>> device, or the link layer type of it's port, but actually we are just
>>>> speculating whether a particular management/feature is supported by the
>> device/port.
>>>>
>>>> Thus instead of inferring, we should have our own mechanism for IB
>>>> management capability/protocol/feature checking, several proposals below.
>>>>
>>>> This patch set will reform the method of getting transport type, we
>>>> will now using query_transport() instead of inferring from transport
>>>> and link layer respectively, also we defined the new transport type
>>>> to make the concept more reasonable.
>>>>
>>>> Mapping List:
>>>> 		node-type	link-layer	old-transport	new-transport
>>>> nes		RNIC		ETH		IWARP		IWARP
>>>> amso1100	RNIC		ETH		IWARP		IWARP
>>>> cxgb3   	RNIC		ETH		IWARP		IWARP
>>>> cxgb4   	RNIC		ETH		IWARP		IWARP
>>>> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
>>>> ocrdma  	IB_CA		ETH		IB		IBOE
>>>> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
>>>> mlx5    	IB_CA		IB		IB		IB
>>>> ehca    	IB_CA		IB		IB		IB
>>>> ipath   	IB_CA		IB		IB		IB
>>>> mthca   	IB_CA		IB		IB		IB
>>>> qib     	IB_CA		IB		IB		IB
>>>>
>>>> For example:
>>>> 	if (transport == IB) && (link-layer == ETH) will now become:
>>>> 	if (query_transport() == IBOE)
>>>>
>>>> Thus we will be able to get rid of the respective transport and
>>>> link-layer checking, and it will help us to add new
>>>> protocol/Technology (like OPA) more easier, also with the introduced
>>>> management helpers, IB management logical will be more clear and easier
>> for extending.
>>>>
>>>> Highlights:
>>>>     The patch set covered a wide range of IB stuff, thus for those who are
>>>>     familiar with the particular part, your suggestion would be
>>>> invaluable ;-)
>>>>
>>>>     Patch 1#~15# included all the logical reform, 16#~25# introduced the
>>>>     management helpers, 26#~27# do clean up.
>>>>
>>>>     Patches haven't been tested yet, we appreciate if any one who have these
>>>>     HW willing to provide his Tested-by :-)
>>>>
>>>>     Doug suggested the bitmask mechanism:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23765.html
>>>>     which could be the plan for future reforming, we prefer that to be
>> another
>>>>     series which focus on semantic and performance.
>>>>
>>>>     This patch-set is somewhat 'bloated' now and it may be a good timing for
>>>>     staging, I'd like to suggest we focus on improving existed helpers and push
>>>>     all the further reforms into next series ;-)
>>>>
>>>> Proposals:
>>>>     Sean:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23339.html
>>>>     Doug:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23418.html
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23765.html
>>>>     Jason:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23425.html
>>>>
>>>> Michael Wang (27):
>>>>     IB/Verbs: Implement new callback query_transport()
>>>>     IB/Verbs: Implement raw management helpers
>>>>     IB/Verbs: Reform IB-core mad/agent/user_mad
>>>>     IB/Verbs: Reform IB-core cm
>>>>     IB/Verbs: Reform IB-core sa_query
>>>>     IB/Verbs: Reform IB-core multicast
>>>>     IB/Verbs: Reform IB-ulp ipoib
>>>>     IB/Verbs: Reform IB-ulp xprtrdma
>>>>     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>>>>     IB/Verbs: Reform cm related part in IB-core cma/ucm
>>>>     IB/Verbs: Reform route related part in IB-core cma
>>>>     IB/Verbs: Reform mcast related part in IB-core cma
>>>>     IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>>>     IB/Verbs: Reform cma_acquire_dev()
>>>>     IB/Verbs: Reform rest part in IB-core cma
>>>>     IB/Verbs: Use management helper cap_ib_mad()
>>>>     IB/Verbs: Use management helper cap_ib_smi()
>>>>     IB/Verbs: Use management helper cap_ib_cm()
>>>>     IB/Verbs: Use management helper cap_iw_cm()
>>>>     IB/Verbs: Use management helper cap_ib_sa()
>>>>     IB/Verbs: Use management helper cap_ib_mcast()
>>>>     IB/Verbs: Use management helper cap_ipoib()
>>>>     IB/Verbs: Use management helper cap_read_multi_sge()
>>>>     IB/Verbs: Use management helper cap_af_ib()
>>>>     IB/Verbs: Use management helper cap_eth_ah()
>>>>     IB/Verbs: Clean up rdma_ib_or_iboe()
>>>>     IB/Verbs: Cleanup rdma_node_get_transport()
>>>>
>>>> ---
>>>>  drivers/infiniband/core/agent.c              |    4
>>>>  drivers/infiniband/core/cm.c                 |   26 +-
>>>>  drivers/infiniband/core/cma.c                |  328 ++++++++++++---------------
>>>>  drivers/infiniband/core/device.c             |    1
>>>>  drivers/infiniband/core/mad.c                |   51 ++--
>>>>  drivers/infiniband/core/multicast.c          |   18 -
>>>>  drivers/infiniband/core/sa_query.c           |   41 +--
>>>>  drivers/infiniband/core/sysfs.c              |    8
>>>>  drivers/infiniband/core/ucm.c                |    5
>>>>  drivers/infiniband/core/ucma.c               |   27 --
>>>>  drivers/infiniband/core/user_mad.c           |   32 +-
>>>>  drivers/infiniband/core/uverbs_cmd.c         |    6
>>>>  drivers/infiniband/core/verbs.c              |   33 --
>>>>  drivers/infiniband/hw/amso1100/c2_provider.c |    7
>>>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7
>>>>  drivers/infiniband/hw/cxgb4/provider.c       |    7
>>>>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6
>>>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3
>>>>  drivers/infiniband/hw/ehca/ehca_main.c       |    1
>>>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7
>>>>  drivers/infiniband/hw/mlx4/main.c            |   10
>>>>  drivers/infiniband/hw/mlx5/main.c            |    7
>>>>  drivers/infiniband/hw/mthca/mthca_provider.c |    7
>>>>  drivers/infiniband/hw/nes/nes_verbs.c        |    6
>>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1
>>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6
>>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3
>>>>  drivers/infiniband/hw/qib/qib_verbs.c        |    7
>>>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1
>>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6
>>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2
>>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
>>>>  include/rdma/ib_verbs.h                      |  204 +++++++++++++++-
>>>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6
>>>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
>>>>  35 files changed, 584 insertions(+), 368 deletions(-)
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>>>> in the body of a message to majordomo@vger.kernel.org More majordomo
>>>> info at http://vger.kernel.org/majordomo-info.html
