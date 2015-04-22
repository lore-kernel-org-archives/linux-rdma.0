From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 22 Apr 2015 10:08:31 -0700
Message-ID: <1429722511-10884-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git=
 tags/rdma-for-linus

----------------------------------------------------------------
InfiniBand/RDMA updates for 4.1:
 - IPoIB fixes from Doug Ledford and Erez Shitrit
 - iSER updates from Sagi Grimberg
 - mlx4 GUID handling changes from Yishai Hadas
 - other misc fixes

----------------------------------------------------------------
Bart Van Assche (1):
      IB/srp: Use P_Key cache for P_Key lookups

Doug Ledford (11):
      IB/ipoib: factor out ah flushing
      IB/ipoib: change init sequence ordering
      IB/ipoib: Consolidate rtnl_lock tasks in workqueue
      IB/ipoib: Make the carrier_on_task race aware
      IB/ipoib: Use dedicated workqueues per interface
      IB/ipoib: No longer use flush as a parameter
      IB/ipoib: fix MCAST_FLAG_BUSY usage
      IB/ipoib: deserialize multicast joins
      IB/ipoib: drop mcast_mutex usage
      ib_srpt: convert printk's to pr_* functions
      Merge branches 'cve-fixup', 'ipoib', 'iser', 'misc-4.1', 'or-mlx4=
' and 'srp' into for-4.1

Erez Shitrit (6):
      IB/ipoib: Use one linear skb in RX flow
      IB/ipoib: Update broadcast record values after each successful jo=
in request
      IB/ipoib: Handle QP in SQE state
      IB/ipoib: Save only IPOIB_MAX_PATH_REC_QUEUE skb's
      IB/ipoib: Remove IPOIB_MCAST_RUN bit
      IB/mlx4: Fix WQE LSO segment calculation

Honggang LI (1):
      mlx5: wrong page mask if CONFIG_ARCH_DMA_ADDR_T_64BIT enabled for=
 32Bit architectures

Sagi Grimberg (18):
      IB/iser: Fix unload during ep_poll wrong dereference
      IB/iser: Handle fastreg/local_inv completion errors
      IB/iser: Fix wrong calculation of protection buffer length
      IB/iser: Remove redundant cmd_data_len calculation
      IB/iser: Remove a redundant struct iser_data_buf
      IB/iser: Don't pass ib_device to fall_to_bounce_buff routine
      IB/iser: Move memory reg/dereg routines to iser_memory.c
      IB/iser: Remove redundant assignments in iser_reg_page_vec
      IB/iser: Get rid of struct iser_rdma_regd
      IB/iser: Merge build page-vec into register page-vec
      IB/iser: Move fastreg descriptor pool get/put to helper functions
      IB/iser: Move PI context alloc/free to routines
      IB/iser: Make fastreg pool cache friendly
      IB/iser: Modify struct iser_mem_reg members
      IB/iser: Pass struct iser_mem_reg to iser_fast_reg_mr and iser_re=
g_sig_mr
      IB/iser: Remove code duplication for a single DMA entry
      IB/iser: Bump version to 1.6
      IB/iser: Rewrite bounce buffer code path

Sebastian Ott (1):
      infiniband/mlx4: check for mapping error

Selvin Xavier (1):
      MAINTAINERS: Adding list of maintainers for ocrdma

Stephen Hemminger (1):
      rdma: replace deprecated ifconfig in doc

S=C3=A9bastien Dugu=C3=A9 (1):
      ib_uverbs: Fix pages leak when using XRC SRQs

Yann Droneaud (2):
      IB/core: disallow registering 0-sized memory region
      IB/core: don't disallow registering region starting at 0x0

Yishai Hadas (9):
      IB/mlx4: Alias GUID adding persistency support
      net/mlx4_core: Manage alias GUID per VF
      net/mlx4_core: Set initial admin GUIDs for VFs
      IB/mlx4: Manage admin alias GUID upon admin request
      IB/mlx4: Change init flow to request alias GUIDs for active VFs
      IB/mlx4: Request alias GUID on demand
      net/mlx4_core: Raise slave shutdown event upon FLR
      net/mlx4_core: Return the admin alias GUID upon host view request
      IB/mlx4: Change alias guids default to be host assigned

 Documentation/filesystems/nfs/nfs-rdma.txt         |   9 +-
 MAINTAINERS                                        |   9 +
 drivers/infiniband/core/umem.c                     |   7 +-
 drivers/infiniband/core/uverbs_main.c              |  22 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            | 457 +++++++++++++=
-----
 drivers/infiniband/hw/mlx4/mad.c                   |   9 +
 drivers/infiniband/hw/mlx4/main.c                  |  26 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  14 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   7 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  44 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |  31 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  18 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            | 195 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  73 ++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     | 520 ++++++++++---=
-------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |  44 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |  66 +--
 drivers/infiniband/ulp/iser/iser_initiator.c       |  66 ++-
 drivers/infiniband/ulp/iser/iser_memory.c          | 523 ++++++++++++-=
--------
 drivers/infiniband/ulp/iser/iser_verbs.c           | 220 +++------
 drivers/infiniband/ulp/srp/ib_srp.c                |   9 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              | 188 ++++----
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  42 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |   2 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |  31 ++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   1 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  10 +-
 include/linux/mlx4/device.h                        |   4 +
 28 files changed, 1513 insertions(+), 1134 deletions(-)
