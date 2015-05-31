From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Sun, 31 May 2015 15:14:08 +0300
Message-ID: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patchset adds completion timestamping supports for verbs consumers. 

Reviewing the weekend threads, we've changed the flag time to reflect
that this is completion time-stamp and folded the mlx4 actual support 
into one patch.

Regarding the related user-space support, it's possible to add what you
were suggesting, ibv_get_raw_cqe_timestamp() -- returns ts in cycles and 
ibv_get_cqe_timestamp() -- returns ts in ns, this makes the value returned
by the poll cq verb an opaque one that must go through one of  the convertors.

We would to go for one helper ibv_get_timestamp(uint64_t raw_time, flag) which 
could get the raw time-stamp and one of the following flags: RAW_TIME, RAW_NS_TIME.

We think this would address the reviewer comments for the kernel submission.

The user-space code is in (still uses IB_CQ_FLAGS_TIMESTAMP and miss the 
conversion functions) 

 https://github.com/matanb10/libibverbs timestamp-v1
 https://github.com/matanb10/libmlx4 timestamp-v1

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
CQ which supports timestamping, IB_CQ_FLAGS_TIMESTAMP_COMPLETION should be given.

query_device - We extend query_device uverb further by giving the hardware's
clock frequency and the timestamp mask (the number of timestamp
bits which are supported). If timestamp isn't supported, 0 is returned.

In order to read the timestamp in the WQE, the user needs to query the device 
for support, create an appropriate CQ (using the extanded uverb with
IB_CQ_FLAGS_TIMESTAMP_COMPLETION) and poll the CQ with an extended poll_cq verb (currently,
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

A user-space application could get the current HW's clock by executing

ibv_query_values_ex(struct ibv_context *context, uint32_t q_values,
                    struct ibv_values_ex *values)

The function gets a mask of the values to query and return their values.
Vendors could either implement this as a uverb command or use their 
user-space driver to return those values directly from the HW (the mlx4 way).

Matan and Or.

Changes from V1:
 (1) fixed lustre IB's code build
 (2) squashed mlx4 V1 9-11 patches into one
 (3) changed IB_CQ_FLAGS_TIMESTAMP --> IB_CQ_FLAGS_TIMESTAMP_COMPLETION

Changes from V0:
(1) Pass ib_cq_init_attr instead of cqe and comp_vector.
(2) Fix unneeded indentation.
(3) Change flags to u32.
(4) Add const to create_cq's ib_cq_init_attr argument in vendor implementation.

Matan Barak (9):
  IB/core: Change provider's API of create_cq to be extendible
  IB/core: Change ib_create_cq to use struct ib_cq_init_attr
  IB/core: Add CQ creation time-stamping flag
  IB/core: Extend ib_uverbs_create_cq
  IB/core: Add timestamp_mask and hca_core_clock to query_device
  IB/core: Pass hardware specific data in query_device
  IB/mlx4: Add mmap call to map the hardware clock
  IB/mlx4: Support extended create_cq and query_device uverbs
  IB/mlx4: Add support for CQ time-stamping

 drivers/infiniband/core/device.c                   |    6 +-
 drivers/infiniband/core/mad.c                      |    5 +-
 drivers/infiniband/core/uverbs.h                   |    1 +
 drivers/infiniband/core/uverbs_cmd.c               |  188 ++++++++++++++++----
 drivers/infiniband/core/uverbs_main.c              |    1 +
 drivers/infiniband/core/verbs.c                    |    4 +-
 drivers/infiniband/hw/amso1100/c2_provider.c       |   14 ++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   19 ++-
 drivers/infiniband/hw/cxgb4/cq.c                   |    9 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    8 +-
 drivers/infiniband/hw/cxgb4/provider.c             |    8 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |    7 +-
 drivers/infiniband/hw/ehca/ehca_hca.c              |    6 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h           |    6 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |    6 +-
 drivers/infiniband/hw/ipath/ipath_cq.c             |    9 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c          |    7 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h          |    3 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   13 ++-
 drivers/infiniband/hw/mlx4/mad.c                   |    5 +-
 drivers/infiniband/hw/mlx4/main.c                  |   67 +++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   19 ++-
 drivers/infiniband/hw/mlx5/cq.c                    |   10 +-
 drivers/infiniband/hw/mlx5/main.c                  |   19 ++-
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
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    9 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    6 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    6 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   10 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    5 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   19 ++
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    7 +-
 include/linux/mlx4/device.h                        |    9 +
 include/rdma/ib_verbs.h                            |   25 ++-
 include/uapi/rdma/ib_user_verbs.h                  |   19 ++
 net/9p/trans_rdma.c                                |    5 +-
 net/rds/ib_cm.c                                    |    8 +-
 net/rds/iw_cm.c                                    |    8 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   10 +-
 net/sunrpc/xprtrdma/verbs.c                        |   10 +-
 49 files changed, 564 insertions(+), 139 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
