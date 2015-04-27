From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v6 00/26] IB/Verbs: IB Management Helpers
Date: Mon, 27 Apr 2015 09:44:46 +0200
Message-ID: <553DE8EE.4030902@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com> <553A415D.1030502@profitbricks.com> <EE7902D3F51F404C82415C4803930ACD5DC48926@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC48926@CMEXMB1.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <Devesh.Sharma@Emulex.Com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On 04/27/2015 09:19 AM, Devesh Sharma wrote:
> Tested-By: Devesh Sharma <Devesh.sharma@emulex.com>
> 
> I am still in process of reviewing the series. Will respond soon.

Thanks for the testing :-)

We are now planning on another version to solve the conflict on
transport/protocol concept, I think there will be some trivial
change in next version related to naming.

Regards,
Michael Wang

> 
> -Regards
> Devesh
>> -----Original Message-----
>> From: Michael Wang [mailto:yun.wang@profitbricks.com]
>> Sent: Friday, April 24, 2015 6:43 PM
>> To: Roland Dreier; Sean Hefty; Hal Rosenstock; linux-rdma@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Cc: Tom Tucker; Steve Wise; Hoang-Nam Nguyen; Christoph Raisch; Mike
>> Marciniszyn; Eli Cohen; Faisal Latif; Jack Morgenstein; Or Gerlitz; Haggai Eran;
>> Ira Weiny; Tom Talpey; Jason Gunthorpe; Doug Ledford; Devesh Sharma; Liran
>> Liss; Dave Goodell
>> Subject: Re: [PATCH v6 00/26] IB/Verbs: IB Management Helpers
>>
>> Add missing Cc:
>> Devesh Sharma <Devesh.Sharma@Emulex.Com>"
>> Liran Liss <liranl@mellanox.com>"
>> Dave Goodell <dgoodell@cisco.com>"
>>
>> Regards,
>> Michael Wang
>>
>> On 04/24/2015 02:23 PM, Michael Wang wrote:
>>> Since v5:
>>>   * Thanks to Ira, Devesh for the review and testing :-)
>>>   * Thanks for the comments from Steve, Tom, Jason, Hal, Devesh, Ira,
>>>     Liran, Jason, Dave :-) Please remind me if anything missed :-P
>>>   * Trivial fix for 4#
>>>   * Drop the reform on acquiring link-layer in 9#
>>>   * Drop cap_ipoib()
>>>
>>> There are plenty of lengthy code to check the transport type of IB
>>> device, or the link layer type of it's port, but actually we are just
>>> speculating whether a particular management/feature is supported by the
>> device/port.
>>>
>>> Thus instead of inferring, we should have our own mechanism for IB
>>> management capability/protocol/feature checking, several proposals below.
>>>
>>> This patch set will reform the method of getting transport type, we
>>> will now using query_transport() instead of inferring from transport
>>> and link layer respectively, also we defined the new transport type to
>>> make the concept more reasonable.
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
>>> Thus we will be able to get rid of the respective transport and
>>> link-layer checking, and it will help us to add new
>>> protocol/Technology (like OPA) more easier, also with the introduced
>>> management helpers, IB management logical will be more clear and easier
>> for extending.
>>>
>>> Highlights:
>>>     The patch set covered a wide range of IB stuff, thus for those who are
>>>     familiar with the particular part, your suggestion would be
>>> invaluable ;-)
>>>
>>>     Patch 1#~15# included all the logical reform, 16#~25# introduced the
>>>     management helpers, 26#~27# do clean up.
>>>
>>>     we appreciate for those one who have the HW willing to provide
>>> Tested-by :-)
>>>
>>>     Doug suggested the bitmask mechanism:
>>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23765.html
>>>     which could be the plan for future reforming, we prefer that to be another
>>>     series which focus on semantic and performance.
>>>
>>>     This patch-set is somewhat 'bloated' now and it may be a good timing for
>>>     staging, I'd like to suggest we focus on improving existed helpers and push
>>>     all the further reforms into next series ;-)
>>>
>>>     We now have a repository based on latest infiniband/for-next with this
>>>     series applied:
>>>         git@github.com:ywang-pb/infiniband-wy.git
>>>
>>> Proposals:
>>>     Sean:
>>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23339.html
>>>     Doug:
>>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23418.html
>>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23765.html
>>>     Jason:
>>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23425.html
>>>
>>> Michael Wang (26):
>>>   IB/Verbs: Implement new callback query_transport()
>>>   IB/Verbs: Implement raw management helpers
>>>   IB/Verbs: Reform IB-core mad/agent/user_mad
>>>   IB/Verbs: Reform IB-core cm
>>>   IB/Verbs: Reform IB-core sa_query
>>>   IB/Verbs: Reform IB-core multicast
>>>   IB/Verbs: Reform IB-ulp ipoib
>>>   IB/Verbs: Reform IB-ulp xprtrdma
>>>   IB/Verbs: Reform IB-core verbs
>>>   IB/Verbs: Reform cm related part in IB-core cma/ucm
>>>   IB/Verbs: Reform route related part in IB-core cma
>>>   IB/Verbs: Reform mcast related part in IB-core cma
>>>   IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>>   IB/Verbs: Reform cma_acquire_dev()
>>>   IB/Verbs: Reform rest part in IB-core cma
>>>   IB/Verbs: Use management helper cap_ib_mad()
>>>   IB/Verbs: Use management helper cap_ib_smi()
>>>   IB/Verbs: Use management helper cap_ib_cm()
>>>   IB/Verbs: Use management helper cap_iw_cm()
>>>   IB/Verbs: Use management helper cap_ib_sa()
>>>   IB/Verbs: Use management helper cap_ib_mcast()
>>>   IB/Verbs: Use management helper cap_read_multi_sge()
>>>   IB/Verbs: Use management helper cap_af_ib()
>>>   IB/Verbs: Use management helper cap_eth_ah()
>>>   IB/Verbs: Clean up rdma_ib_or_iboe()
>>>   IB/Verbs: Cleanup rdma_node_get_transport()
>>>
>>>  drivers/infiniband/core/agent.c              |   2 +-
>>>  drivers/infiniband/core/cm.c                 |  20 +-
>>>  drivers/infiniband/core/cma.c                | 282 ++++++++++++---------------
>>>  drivers/infiniband/core/device.c             |   1 +
>>>  drivers/infiniband/core/mad.c                |  43 ++--
>>>  drivers/infiniband/core/multicast.c          |  12 +-
>>>  drivers/infiniband/core/sa_query.c           |  30 +--
>>>  drivers/infiniband/core/ucm.c                |   3 +-
>>>  drivers/infiniband/core/ucma.c               |  25 +--
>>>  drivers/infiniband/core/user_mad.c           |  26 ++-
>>>  drivers/infiniband/core/verbs.c              |  31 +--
>>>  drivers/infiniband/hw/amso1100/c2_provider.c |   7 +
>>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |   7 +
>>>  drivers/infiniband/hw/cxgb4/provider.c       |   7 +
>>>  drivers/infiniband/hw/ehca/ehca_hca.c        |   6 +
>>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |   3 +
>>>  drivers/infiniband/hw/ehca/ehca_main.c       |   1 +
>>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |   7 +
>>>  drivers/infiniband/hw/mlx4/main.c            |  10 +
>>>  drivers/infiniband/hw/mlx5/main.c            |   7 +
>>>  drivers/infiniband/hw/mthca/mthca_provider.c |   7 +
>>>  drivers/infiniband/hw/nes/nes_verbs.c        |   6 +
>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   1 +
>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   6 +
>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |   3 +
>>>  drivers/infiniband/hw/qib/qib_verbs.c        |   7 +
>>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |   1 +
>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   6 +
>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |   2 +
>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |  15 +-
>>>  include/rdma/ib_verbs.h                      | 169 +++++++++++++++-
>>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |   4 +-
>>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |  47 ++---
>>>  33 files changed, 503 insertions(+), 301 deletions(-)
>>>
