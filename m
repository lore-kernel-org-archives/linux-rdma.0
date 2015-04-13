From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v3 00/28] IB/Verbs: IB Management Helpers
Date: Mon, 13 Apr 2015 14:20:00 +0200
Message-ID: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


Since v2:
  * Apply suggestions from Doug, Ira, Jason, Tom, Steve, thanks for the comments :-)
    and please remind me if I missed anything :-P

There are plenty of lengthy code to check the transport type of IB device,
or the link layer type of it's port, but actually we are just speculating
whether a particular management/feature is supported by the device/port.

Thus instead of inferring, we should have our own mechanism for IB management
capability/protocol/feature checking, several proposals below.

This patch set will reform the method of getting transport type, we will
now using query_transport() instead of inferring from transport and link
layer respectively, also we defined the new transport type to make the
concept more reasonable.

Mapping List:
		node-type	link-layer	old-transport	new-transport
nes		RNIC		ETH		IWARP		IWARP
amso1100	RNIC		ETH		IWARP		IWARP
cxgb3   	RNIC		ETH		IWARP		IWARP
cxgb4   	RNIC		ETH		IWARP		IWARP
usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
ocrdma  	IB_CA		ETH		IB		IBOE
mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
mlx5    	IB_CA		IB		IB		IB
ehca    	IB_CA		IB		IB		IB
ipath   	IB_CA		IB		IB		IB
mthca   	IB_CA		IB		IB		IB
qib     	IB_CA		IB		IB		IB

For example:
	if (transport == IB) && (link-layer == ETH)
will now become:
	if (query_transport() == IBOE)

Thus we will be able to get rid of the respective transport and link-layer
checking, and it will help us to add new protocol/Technology (like OPA) more
easier, also with the introduced management helpers, IB management logical
will be more clear and easier for extending.

Highlights:
    The patch set covered a wide range of IB stuff, thus for those who are
    familiar with the particular part, your suggestion would be invaluable ;-)

    Patches haven't been tested yet, we appreciate if any one who have these
    HW willing to provide his Tested-by :-)

    Doug suggested the bitmask mechanism:
	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23765.html
    which could be the plan for future reforming, we prefer that to be another
    series which focus on semantic and performance.

    This patch-set is somewhat 'bloated' now and it may be a good timing for
    staging, I'd like to suggest we focus on improving existed helpers and push
    all the further reforms into next series ;-)

Proposals:
    Sean:
	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23339.html
    Doug:
	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23418.html
	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23765.html
    Jason:
	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23425.html

Michael Wang (28):
    [PATCH v3 01/28] IB/Verbs: Implement new callback query_transport()
    [PATCH v3 02/28] IB/Verbs: Implement raw management helpers
    [PATCH v3 03/28] IB/Verbs: Reform IB-core mad/agent/user_mad
    [PATCH v3 04/28] IB/Verbs: Reform IB-core cm
    [PATCH v3 05/28] IB/Verbs: Reform IB-core sa_query
    [PATCH v3 06/28] IB/Verbs: Reform IB-core multicast
    [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
    [PATCH v3 08/28] IB/Verbs: Reform IB-ulp xprtrdma
    [PATCH v3 09/28] IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
    [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core cma
    [PATCH v3 11/28] IB/Verbs: Reform route related part in IB-core cma
    [PATCH v3 12/28] IB/Verbs: Reform mcast related part in IB-core cma
    [PATCH v3 13/28] IB/Verbs: Reserve legacy transport type in 'dev_addr'
    [PATCH v3 14/28] IB/Verbs: Reform cma_acquire_dev()
    [PATCH v3 15/28] IB/Verbs: Reform rest part in IB-core cma
    [PATCH v3 16/28] IB/Verbs: Use management helper cap_ib_mad()
    [PATCH v3 17/28] IB/Verbs: Use management helper cap_ib_smi()
    [PATCH v3 18/28] IB/Verbs: Use management helper cap_ib_cm()
    [PATCH v3 19/28] IB/Verbs: Use management helper cap_iw_cm()
    [PATCH v3 20/28] IB/Verbs: Use management helper cap_ib_sa()
    [PATCH v3 21/28] IB/Verbs: Use management helper cap_ib_mcast()
    [PATCH v3 22/28] IB/Verbs: Use management helper cap_ipoib()
    [PATCH v3 23/28] IB/Verbs: Use management helper cap_read_multi_sge()
    [PATCH v3 24/28] IB/Verbs: Use management helper cap_ib_cm_dev()
    [PATCH v3 25/28] IB/Verbs: Use management helper cap_af_ib()
    [PATCH v3 26/28] IB/Verbs: Use management helper cap_eth_ah()
    [PATCH v3 27/28] IB/Verbs: Clean up rdma_ib_or_iboe()
    [PATCH v3 28/28] IB/Verbs: Cleanup rdma_node_get_transport()

---
 drivers/infiniband/core/agent.c              |    4 
 drivers/infiniband/core/cm.c                 |   28 +-
 drivers/infiniband/core/cma.c                |  331 ++++++++++++---------------
 drivers/infiniband/core/device.c             |    1 
 drivers/infiniband/core/mad.c                |   28 +-
 drivers/infiniband/core/multicast.c          |   18 -
 drivers/infiniband/core/sa_query.c           |   41 +--
 drivers/infiniband/core/sysfs.c              |    8 
 drivers/infiniband/core/ucm.c                |    3 
 drivers/infiniband/core/ucma.c               |   27 --
 drivers/infiniband/core/user_mad.c           |   32 +-
 drivers/infiniband/core/uverbs_cmd.c         |    6 
 drivers/infiniband/core/verbs.c              |   33 --
 drivers/infiniband/hw/amso1100/c2_provider.c |    7 
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7 
 drivers/infiniband/hw/cxgb4/provider.c       |    7 
 drivers/infiniband/hw/ehca/ehca_hca.c        |    6 
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3 
 drivers/infiniband/hw/ehca/ehca_main.c       |    1 
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    7 
 drivers/infiniband/hw/mlx4/main.c            |   10 
 drivers/infiniband/hw/mlx5/main.c            |    7 
 drivers/infiniband/hw/mthca/mthca_provider.c |    7 
 drivers/infiniband/hw/nes/nes_verbs.c        |    6 
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1 
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6 
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3 
 drivers/infiniband/hw/qib/qib_verbs.c        |    7 
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2 
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
 include/rdma/ib_verbs.h                      |  224 +++++++++++++++++-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6 
 net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
 35 files changed, 599 insertions(+), 353 deletions(-)
