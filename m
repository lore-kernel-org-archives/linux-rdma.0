From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 14 Aug 2014 09:05:28 -0700
Message-ID: <1408032328-16398-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Main set of InfiniBand/RDMA updates for 3.17 merge window:

 - MR reregistration support
 - MAD support for RMPP in userspace
 - iSER and SRP initiator updates
 - ocrdma hardware driver updates
 - other fixes...

----------------------------------------------------------------
Alex Estrin (1):
      IB/ipoib: Avoid multicast join attempts with invalid P_key

Ariel Nahum (3):
      IB/iser: Seperate iser_conn and iscsi_endpoint storage space
      IB/iser: Protect iser state machine with a mutex
      IB/iser: Replace connection waitqueue with completion object

Bart Van Assche (3):
      scsi_transport_srp: Fix fast_io_fail_tmo=dev_loss_tmo=off behavior
      IB/srp: Fix deadlock between host removal and multipathd
      IB/srp: Fix residual handling

Dan Carpenter (1):
      RDMA/amso1100: Check for integer overflow in c2_alloc_cq_buf()

Devesh Sharma (7):
      RDMA/ocrdma: Avoid posting DPP requests for RDMA READ
      be2net: Issue shutdown event to ocrdma driver
      RDMA/ocrdma: Handle shutdown event from be2net driver
      RDMA/ocrdma: Remove hardcoding of the max DPP QPs supported
      RDMA/ocrdma: Delete AH table if ocrdma_init_hw fails after AH table creation
      RDMA/ocrdma: Obtain SL from device structure
      RDMA/ocrdma: Update sli data structure for endianness

Doug Ledford (2):
      IB/srpt: Handle GID change events
      RDMA/uapi: Include socket.h in rdma_user_cm.h

Erez Shitrit (2):
      IB/ipoib: Use P_Key change event instead of P_Key polling mechanism
      IB/ipoib: Avoid flushing the workqueue from worker context

Fabian Frederick (3):
      IPoIB: Remove unnecessary test for NULL before debugfs_remove()
      IB/mlx4: Use ARRAY_SIZE instead of sizeof/sizeof[0]
      IB/mlx5: Use ARRAY_SIZE instead of sizeof/sizeof[0]

Ira Weiny (5):
      IB/umad: Update module to [pr|dev]_* style print messages
      IB/mad: Update module to [pr|dev]_* style print messages
      IB/mad: Add dev_notice messages for various umad/mad registration failures
      IB/mad: add new ioctl to ABI to support new registration options
      IB/mad: Add user space RMPP support

Jack Morgenstein (1):
      mlx4_core: Add support for secure-host and SMP firewall

Matan Barak (3):
      IB/core: Add user MR re-registration support
      mlx4_core: Add helper functions to support MR re-registration
      IB/mlx4_ib: Add support for user MR re-registration

Mitesh Ahuja (4):
      RDMA/ocrdma: Allow only SEND opcode in case of UD QPs
      RDMA/ocrdma: Do proper cleanup even if FW is in error state
      RDMA/ocrdma: Return proper value for max_mr_size
      RDMA/ocrdma: report asic-id in query device

Or Gerlitz (1):
      IB/ipath: Add P_Key change event support

Roi Dayan (3):
      IB/iser: Support IPv6 address family
      IB/iser: Add TIMEWAIT_EXIT event handling
      IB/iser: Clarify a duplicate counters check

Roland Dreier (1):
      Merge branches 'core', 'cxgb4', 'ipoib', 'iser', 'iwcm', 'mad', 'misc', 'mlx4', 'mlx5', 'ocrdma' and 'srp' into for-next

Sagi Grimberg (2):
      IB/iser: Fix responder resources advertisement
      IB/iser: Remove redundant return code in iser_free_ib_conn_res()

Selvin Xavier (8):
      RDMA/ocrdma: Query and initalize the PFC SL
      RDMA/ocrdma: Add hca_type and fixing fw_version string in device atrributes
      RDMA/ocrdma: Avoid reporting wrong completions in case of error CQEs
      RDMA/ocrdma: Add missing adapter mailbox opcodes
      RDMA/ocrdma: Increase the size of STAG array in dev structure to 16K
      RDMA/ocrdma: Initialize the GID table while registering the device
      RDMA/ocrdma: Fix a sparse warning
      RDMA/ocrdma: Update the ocrdma module version string

Steve Wise (2):
      RDMA/cxgb4: Only call CQ completion handler if it is armed
      RDMA/iwcm: Use a default listen backlog if needed

Wei Yongjun (1):
      IB/srp: Fix return value check in srp_init_module()

 Documentation/infiniband/user_mad.txt              |  13 +-
 drivers/infiniband/core/agent.c                    |  16 +-
 drivers/infiniband/core/cm.c                       |   5 +-
 drivers/infiniband/core/iwcm.c                     |  27 ++
 drivers/infiniband/core/mad.c                      | 283 +++++++++++++-------
 drivers/infiniband/core/mad_priv.h                 |   3 -
 drivers/infiniband/core/sa_query.c                 |   2 +-
 drivers/infiniband/core/user_mad.c                 | 188 +++++++++++--
 drivers/infiniband/core/uverbs.h                   |   1 +
 drivers/infiniband/core/uverbs_cmd.c               |  93 +++++++
 drivers/infiniband/core/uverbs_main.c              |   1 +
 drivers/infiniband/hw/amso1100/c2_cq.c             |   7 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |   1 +
 drivers/infiniband/hw/cxgb4/qp.c                   |  37 ++-
 drivers/infiniband/hw/cxgb4/t4.h                   |  11 +
 drivers/infiniband/hw/ipath/ipath_mad.c            |  14 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/hw/mlx4/main.c                  |   8 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   4 +
 drivers/infiniband/hw/mlx4/mr.c                    |  88 +++++-
 drivers/infiniband/hw/mlx5/qp.c                    |   2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c            |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h              |  26 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           | 227 ++++++++++++++--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h           |   2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  83 +++++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          | 295 ++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  36 ++-
 drivers/infiniband/hw/qib/qib_mad.c                |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c            |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            | 133 ++++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   9 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  47 ++--
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   8 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           | 128 ++++++---
 drivers/infiniband/ulp/srp/ib_srp.c                |  48 +++-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   3 +-
 drivers/net/ethernet/emulex/benet/be.h             |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |   1 +
 drivers/net/ethernet/emulex/benet/be_roce.c        |  18 +-
 drivers/net/ethernet/emulex/benet/be_roce.h        |   3 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   9 +
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  91 ++++++-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   5 +
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   3 +
 drivers/net/ethernet/mellanox/mlx4/mr.c            | 160 +++++++++++
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  26 +-
 drivers/scsi/scsi_transport_srp.c                  |   3 +-
 include/linux/mlx4/cmd.h                           |   7 +
 include/linux/mlx4/device.h                        |  17 ++
 include/rdma/ib_mad.h                              |  18 +-
 include/rdma/ib_verbs.h                            |  10 +-
 include/uapi/rdma/ib_user_mad.h                    |  42 +++
 include/uapi/rdma/ib_user_verbs.h                  |  16 ++
 include/uapi/rdma/rdma_user_cm.h                   |   1 +
 57 files changed, 1851 insertions(+), 455 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
