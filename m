From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/10] Add completion timestamping support
Date: Sun, 17 May 2015 16:36:16 +0300
Message-ID: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patchset adds completion timestamping supports for verbs consumers. 

Timestamping is used by applications in order to know when a WQE was 
received/transmitted by the HW. The value is given is HCA hardware cycles,
but could be easily converted as the hardware's core clock frequecny is 
available through extension of query device. 

Moreover, we add an ability to read the HCA's current clock. This could be 
useful on order to synchronize events to the wall clock.

This functionality is achieved by adding/extending the following verbs:

create_cq - create_cq is extended in order to allow passing creation flags
to the CQ creation function. We change IB/core --> vendors API
to be easily extendible by passing a struct which contains
comp_vectors, cqe and the new flags parameter. In order to create
CQ which supports timestamping, IB_CQ_FLAGS_TIMESTAMP should be given.

query_device - We extend query_device uverb further by giving the hardware's
clock frequency and the timestamp mask (the number of timestamp
bits which are supported). If timestamp isn't supported, 0 is returned.

In order to read the timestamp in the WQE, the user needs to query the device 
for support, create an appropriate CQ (using the extanded uverb with
IB_CQ_FLAGS_TIMESTAMP) and poll the CQ with an extended poll_cq verb (currently,
only implemented in user-space).

In mlx4, allowing the user to read the core clock efficiently involves mapping
this area of the hardware to user-space (being done by using a mmap command)
and reading the clock from the correct offset of the page. 

This offset is returned in the vendor's specific data from mlx4's kernel driver 
to the mlx4's user-space driver. query_device is modified in order to support
passing this vendor specific data. A user-space application could use a new
verb in order to read the hardware's clock.

Translating the hardware's clock into ms could be done by dividing this
value by hca_core_clock (which is returned by the extended version of
query_device uverb).


Matan and Or.


Matan Barak (10):
  IB/core: Change provider's API of create_cq to be extendible
  IB/core: Add flags parameter for ib_create_cq
  IB/core: Extend ib_uverbs_create_cq
  IB/core: Add timestamp_mask and hca_core_clock to query_device
  IB/core: Pass hardware specific data in query_device
  IB/mlx4: Add mmap call to map the hardware clock
  IB/mlx4: Support extended create_cq and query_device uverbs
  IB/mlx4: Add support for timestamp in cq creation
  IB/mlx4: Add timestamp_mask and hca_core_clock to query_device
  IB/mlx4: Return hca core clock's offset in query_device vendor's data

 drivers/infiniband/core/device.c                   |    6 +-
 drivers/infiniband/core/mad.c                      |    4 +-
 drivers/infiniband/core/uverbs.h                   |    1 +
 drivers/infiniband/core/uverbs_cmd.c               |  188 ++++++++++++++++----
 drivers/infiniband/core/uverbs_main.c              |    1 +
 drivers/infiniband/core/verbs.c                    |    6 +-
 drivers/infiniband/hw/amso1100/c2_provider.c       |   14 ++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   19 ++-
 drivers/infiniband/hw/cxgb4/cq.c                   |    9 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    8 +-
 drivers/infiniband/hw/cxgb4/provider.c             |    8 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |    7 +-
 drivers/infiniband/hw/ehca/ehca_hca.c              |    6 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h           |    6 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |    3 +-
 drivers/infiniband/hw/ipath/ipath_cq.c             |    9 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c          |    7 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h          |    3 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   13 ++-
 drivers/infiniband/hw/mlx4/mad.c                   |    2 +-
 drivers/infiniband/hw/mlx4/main.c                  |   64 +++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   19 ++-
 drivers/infiniband/hw/mlx5/cq.c                    |   10 +-
 drivers/infiniband/hw/mlx5/main.c                  |   14 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    5 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |   15 ++-
 drivers/infiniband/hw/nes/nes_verbs.c              |   17 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   13 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |    9 +-
 drivers/infiniband/hw/qib/qib_cq.c                 |   11 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    6 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |    5 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   16 ++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    5 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    8 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    7 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   19 ++
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    7 +-
 include/linux/mlx4/device.h                        |    9 +
 include/rdma/ib_verbs.h                            |   21 ++-
 include/uapi/rdma/ib_user_verbs.h                  |   19 ++
 net/9p/trans_rdma.c                                |    2 +-
 net/rds/ib_cm.c                                    |    4 +-
 net/rds/iw_cm.c                                    |    8 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   15 +-
 net/sunrpc/xprtrdma/verbs.c                        |    8 +-
 49 files changed, 520 insertions(+), 152 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
