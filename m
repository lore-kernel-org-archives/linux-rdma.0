From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 09:44:56 +0200
Message-ID: <55375178.7080508@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <20150422002850.GB15893@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422002850.GB15893@phlsvsds.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ira.weiny" <ira.weiny@intel.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/22/2015 02:28 AM, ira.weiny wrote:
[snip]
>>
>> Highlights:
>>     The patch set covered a wide range of IB stuff, thus for those who are
>>     familiar with the particular part, your suggestion would be invaluable ;-)
>>
>>     Patch 1#~15# included all the logical reform, 16#~25# introduced the
>>     management helpers, 26#~27# do clean up.
>>
>>     Patches haven't been tested yet, we appreciate if any one who have these
>>     HW willing to provide his Tested-by :-)
>>
>>     Doug suggested the bitmask mechanism:
>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23765.html
>>     which could be the plan for future reforming, we prefer that to be another
>>     series which focus on semantic and performance.
>>
>>     This patch-set is somewhat 'bloated' now and it may be a good timing for
>>     staging, I'd like to suggest we focus on improving existed helpers and push
>>     all the further reforms into next series ;-)
>>
> 
> Series tested for IPoIB and MAD functionality on qib and mlx4 hardware.
> 
> Tested-by: Ira Weiny <ira.weiny@intel.com>

Thanks for the testing :-)

Regards,
Michael Wang

> 
>>
>> Proposals:
>>     Sean:
>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23339.html
>>     Doug:
>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23418.html
>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23765.html
>>     Jason:
>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23425.html
>>
>> Michael Wang (27):
>>     IB/Verbs: Implement new callback query_transport()
>>     IB/Verbs: Implement raw management helpers
>>     IB/Verbs: Reform IB-core mad/agent/user_mad
>>     IB/Verbs: Reform IB-core cm
>>     IB/Verbs: Reform IB-core sa_query
>>     IB/Verbs: Reform IB-core multicast
>>     IB/Verbs: Reform IB-ulp ipoib
>>     IB/Verbs: Reform IB-ulp xprtrdma
>>     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>>     IB/Verbs: Reform cm related part in IB-core cma/ucm
>>     IB/Verbs: Reform route related part in IB-core cma
>>     IB/Verbs: Reform mcast related part in IB-core cma
>>     IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>     IB/Verbs: Reform cma_acquire_dev()
>>     IB/Verbs: Reform rest part in IB-core cma
>>     IB/Verbs: Use management helper cap_ib_mad()
>>     IB/Verbs: Use management helper cap_ib_smi()
>>     IB/Verbs: Use management helper cap_ib_cm()
>>     IB/Verbs: Use management helper cap_iw_cm()
>>     IB/Verbs: Use management helper cap_ib_sa()
>>     IB/Verbs: Use management helper cap_ib_mcast()
>>     IB/Verbs: Use management helper cap_ipoib()
>>     IB/Verbs: Use management helper cap_read_multi_sge()
>>     IB/Verbs: Use management helper cap_af_ib()
>>     IB/Verbs: Use management helper cap_eth_ah()
>>     IB/Verbs: Clean up rdma_ib_or_iboe()
>>     IB/Verbs: Cleanup rdma_node_get_transport()
>>
>> ---
>>  drivers/infiniband/core/agent.c              |    4 
>>  drivers/infiniband/core/cm.c                 |   26 +-
>>  drivers/infiniband/core/cma.c                |  328 ++++++++++++---------------
>>  drivers/infiniband/core/device.c             |    1 
>>  drivers/infiniband/core/mad.c                |   51 ++--
>>  drivers/infiniband/core/multicast.c          |   18 -
>>  drivers/infiniband/core/sa_query.c           |   41 +--
>>  drivers/infiniband/core/sysfs.c              |    8 
>>  drivers/infiniband/core/ucm.c                |    5 
>>  drivers/infiniband/core/ucma.c               |   27 --
>>  drivers/infiniband/core/user_mad.c           |   32 +-
>>  drivers/infiniband/core/uverbs_cmd.c         |    6 
>>  drivers/infiniband/core/verbs.c              |   33 --
>>  drivers/infiniband/hw/amso1100/c2_provider.c |    7 
>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7 
>>  drivers/infiniband/hw/cxgb4/provider.c       |    7 
>>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6 
>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3 
>>  drivers/infiniband/hw/ehca/ehca_main.c       |    1 
>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7 
>>  drivers/infiniband/hw/mlx4/main.c            |   10 
>>  drivers/infiniband/hw/mlx5/main.c            |    7 
>>  drivers/infiniband/hw/mthca/mthca_provider.c |    7 
>>  drivers/infiniband/hw/nes/nes_verbs.c        |    6 
>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1 
>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6 
>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3 
>>  drivers/infiniband/hw/qib/qib_verbs.c        |    7 
>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1 
>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6 
>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2 
>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
>>  include/rdma/ib_verbs.h                      |  204 +++++++++++++++-
>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6 
>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
>>  35 files changed, 584 insertions(+), 368 deletions(-)
