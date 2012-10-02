From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Tue,  2 Oct 2012 09:08:13 -0700
Message-ID: <1349194094-7981-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

First batch of InfiniBand/RDMA changes for the 3.7 merge window:
 - mlx4 IB support for SR-IOV
 - A couple of SRP initiator fixes
 - Batch of nes hardware driver fixes
 - Fix for long-standing use-after-free crash in IPoIB
 - Other miscellaneous fixes

----------------------------------------------------------------
Amir Vadai (1):
      IB/mlx4: Add CM paravirtualization

Bart Van Assche (2):
      IB/srp: Fix use-after-free in srp_reset_req()
      IB/srp: Avoid having aborted requests hang

Dean Luick (1):
      IB/qib: Add a qib driver version

Dotan Barak (4):
      IB/core: Remove unused variables in ucm/ucma
      RDMA/cma: Use consistent component mask for IPoIB port space multicast joins
      IB/mlx4: Fill in sq_sig_type in query QP
      mlx4_core: Fix wrong offset in parsing query device caps response

Emil Goode (1):
      RDMA/cxgb4: Fix error handling in create_qp()

Jack Morgenstein (20):
      IB/core: Reserve bits in enum ib_qp_create_flags for low-level driver use
      IB/core: Handle table with full and partial membership for the same P_Key
      IB/core: Add ib_find_exact_cached_pkey()
      IB/mlx4: SR-IOV IB context objects and proxy/tunnel SQP support
      mlx4_core: Add proxy and tunnel QPs to the reserved QP area
      IB/mlx4: Initialize SR-IOV IB support for slaves in master context
      mlx4: Implement QP paravirtualization and maintain phys_pkey_cache for smp_snoop
      IB/mlx4: SR-IOV multiplex and demultiplex MADs
      mlx4: MAD_IFC paravirtualization
      mlx4_core: Add IB port-state machine and port mgmt event propagation
      mlx4: Add alias_guid mechanism
      IB/mlx4: Propagate P_Key and guid change port management events to slaves
      IB/mlx4: Add iov directory in sysfs under the ib device
      net/mlx4_core: Adjustments to SET_PORT for IB SR-IOV
      mlx4_core: INIT/CLOSE port logic for IB ports in SR-IOV mode
      IB/mlx4: Miscellaneous adjustments for SR-IOV IB support
      mlx4: Activate SR-IOV mode for IB
      mlx4: Paravirtualize Node Guids for slaves
      mlx4: Modify proxy/tunnel QP mechanism so that guests do no calculations
      IB/mlx4: Create paravirt contexts for VFs when master IB driver initializes

Mike Marciniszyn (1):
      IB/qib: Fix local access validation for user MRs

Or Gerlitz (1):
      mlx4_core: Remove annoying debug message in the resource tracker

Oren Duer (1):
      IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV

Patrick McHardy (1):
      IPoIB: Fix use-after-free of multicast object

Roland Dreier (7):
      mlx4_core: Trivial readability fix: "0X30" -> "0x30"
      mlx4_core: Trivial cleanups to driver log messages
      mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
      mlx4_core: Stash PCI ID driver_data in mlx4_priv structure
      mlx4_core: Clean up enabling of SENSE_PORT for older (ConnectX-1/-2) HCAs
      mlx4_core: Disable SENSE_PORT for multifunction devices
      Merge branches 'cma', 'cxgb4', 'ipoib', 'mlx4', 'mlx4-sriov', 'nes', 'qib' and 'srp' into for-linus

Tatyana Nikolova (6):
      RDMA/nes: Fix incorrect resolving of the loopback MAC address
      RDMA/nes: Fix for incorrect MSS when TSO is on
      RDMA/nes: Cosmetic changes
      RDMA/nes: Fix for crash when TX checksum offload is off
      RDMA/nes: Print hardware resource type
      RDMA/nes: Fix compilation error when nes_debug is enabled

 drivers/infiniband/core/cache.c                    |   43 +-
 drivers/infiniband/core/cma.c                      |    5 +-
 drivers/infiniband/core/device.c                   |   16 +-
 drivers/infiniband/core/ucm.c                      |    1 -
 drivers/infiniband/core/ucma.c                     |    1 -
 drivers/infiniband/hw/cxgb4/qp.c                   |   62 +-
 drivers/infiniband/hw/mlx4/Makefile                |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |  688 +++++++++
 drivers/infiniband/hw/mlx4/cm.c                    |  437 ++++++
 drivers/infiniband/hw/mlx4/cq.c                    |   31 +-
 drivers/infiniband/hw/mlx4/mad.c                   | 1573 +++++++++++++++++++-
 drivers/infiniband/hw/mlx4/main.c                  |  273 +++-
 drivers/infiniband/hw/mlx4/mcg.c                   | 1254 ++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  341 ++++-
 drivers/infiniband/hw/mlx4/qp.c                    |  660 +++++++-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  794 ++++++++++
 drivers/infiniband/hw/nes/nes.h                    |   15 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   34 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    4 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   40 +-
 drivers/infiniband/hw/nes/nes_utils.c              |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   14 +-
 drivers/infiniband/hw/qib/qib_common.h             |   14 +-
 drivers/infiniband/hw/qib/qib_driver.c             |    3 +-
 drivers/infiniband/hw/qib/qib_keys.c               |    5 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   19 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    3 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  242 ++-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |  245 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  246 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   11 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  171 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   59 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |   10 +
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  100 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  222 ++-
 include/linux/mlx4/device.h                        |   69 +-
 include/linux/mlx4/driver.h                        |    2 +
 include/linux/mlx4/qp.h                            |    3 +-
 include/rdma/ib_cache.h                            |   16 +
 include/rdma/ib_verbs.h                            |    3 +
 43 files changed, 7289 insertions(+), 448 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx4/alias_GUID.c
 create mode 100644 drivers/infiniband/hw/mlx4/cm.c
 create mode 100644 drivers/infiniband/hw/mlx4/mcg.c
 create mode 100644 drivers/infiniband/hw/mlx4/sysfs.c
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
