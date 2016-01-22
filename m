From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 22 Jan 2016 13:18:35 -0500
Message-ID: <56A2727B.8040809@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RfjXdKBrr18fUogVoaWGjcoSrd0QIDOK6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RfjXdKBrr18fUogVoaWGjcoSrd0QIDOK6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 4ef7675344d687a0ef5b0d7c0cee12da005870=
c0:

  Linux 4.4-rc6 (2015-12-20 16:06:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 34356f64ac0df2326fa50e2d4bca6f7c03ed16c1:

  IB/mlx5: Unify CQ create flags check (2016-01-21 12:05:37 -0500)

This is a rather large update, and it's not entirely complete.  I have
some changes to merge for the staging/rdma tree too, but I wanted to get
this set in first for dependency reasons, then I'll make a new branch
against Greg's staging tree, then send the changes relative to that.
Expect that pull request early next week.  Thanks.

----------------------------------------------------------------
Initial roundup of 4.5 merge window patches

- Remove usage of ib_query_device and instead store attributes in
  ib_device struct
- Move iopoll out of block and into lib, rename to irqpoll, and use
  in several places in the rdma stack as our new completion queue
  polling library mechanism.  Update the other block drivers that
  already used iopoll to use the new mechanism too.
- Replace the per-entry GID table locks with a single GID table lock
- IPoIB multicast cleanup
- Cleanups to the IB MR facility
- Add support for 64bit extended IB counters
- Fix for netlink oops while parsing RDMA nl messages
- RoCEv2 support for the core IB code
- mlx4 RoCEv2 support
- mlx5 RoCEv2 support
- Cross Channel support for mlx5
- Timestamp support for mlx5
- Atomic support for mlx5
- Raw QP support for mlx5
- MAINTAINERS update for mlx4/mlx5
- Misc ocrdma, qib, nes, usNIC, cxgb3, cxgb4, mlx4, mlx5 updates
- Add support for remote invalidate to the iSER driver (pushed through th=
e
  RDMA tree due to dependencies, acknowledged by nab)
- Update to NFSoRDMA (pushed through the RDMA tree due to dependencies,
  acknowledged by Bruce)

----------------------------------------------------------------
Achiad Shochat (10):
      IB/mlx5: Support IB device's callback for getting the link layer
      IB/mlx5: Support IB device's callback for getting its netdev
      net/mlx5_core: Break down the vport mac address query function
      net/mlx5_core: Introduce access functions to enable/disable RoCE
      net/mlx5_core: Introduce access functions to query vport RoCE field=
s
      IB/mlx5: Extend query_device/port to support RoCE
      IB/mlx5: Set network_hdr_type upon RoCE responder completion
      IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
      IB/mlx5: Add RoCE fields to Address Vector
      IB/mlx5: Support RoCE

Bart Van Assche (4):
      IB/core: Remove set-but-not-used variable from ib_sg_to_pages()
      irq_poll: Fix irq_poll_sched()
      IB/srpt: Fix the RDMA completion handlers
      IB/cm: Fix a recently introduced deadlock

Bodong Wang (1):
      IB/mlx5: report tx/rx checksum cap in query results

Christoph Hellwig (23):
      irq_poll: make blk-iopoll available outside the block layer
      irq_poll: don't disable new irq_poll instances
      irq_poll: fold irq_poll_sched_prep into irq_poll_sched
      irq_poll: fold irq_poll_disable_pending into irq_poll_softirq
      irq_poll: mark __irq_poll_complete static
      irq_poll: remove unused data and max fields
      IB: add a proper completion queue abstraction
      IB/srpt: chain RDMA READ/WRITE requests
      IB/srp: use the new CQ API
      IB/iser: Convert to CQ abstraction
      IB: start documenting device capabilities
      IB: remove ib_query_mr
      IB: remove support for phys MRs
      IB: remove in-kernel support for memory windows
      cxgb3: simplify iwch_get_dma_wr
      nes: simplify nes_reg_phys_mr calling conventions
      amso1100: fold c2_reg_phys_mr into c2_get_dma_mr
      ehca: stop using struct ib_phys_buf
      IB: remove the struct ib_phys_buf definition
      IB: remove the write-only usecnt field from struct ib_mr
      IB/mad: pass ib_mad_send_buf explicitly to the recv_handler
      IB/mad: use CQ abstraction
      svc_rdma: use local_dma_lkey

Christoph Lameter (5):
      IB/IPoIB: factor out common multicast list removal code
      IB/IPoIB: Move multicast specific code out of ipoib_main.c
      IB/core: Create get_perf_mad function in sysfs.c
      IB/core: Specify attribute_id in port_table_attribute
      IB/core: Display extended counter set if available

Chuck Lever (10):
      svcrdma: Clean up rdma_create_xprt()
      svcrdma: Clean up process_context()
      svcrdma: Improve allocation of struct svc_rdma_op_ctxt
      svcrdma: Improve allocation of struct svc_rdma_req_map
      svcrdma: Remove unused req_map and ctxt kmem_caches
      svcrdma: Add gfp flags to svc_rdma_post_recv()
      svcrdma: Remove last two __GFP_NOFAIL call sites
      svcrdma: Make map_xdr non-static
      svcrdma: Define maximum number of backchannel requests
      svcrdma: Add class for RDMA backwards direction transport

Dan Carpenter (2):
      RDMA/nes: checking for NULL instead of IS_ERR
      IB/cma: allocating too much memory in make_cma_ports()

Dean Luick (1):
      IB/mad: Ensure fairness in ib_mad_completion_handler

Devesh Sharma (4):
      RDMA/ocrdma: Fix vlan-id assignment in qp parameters
      RDMA/ocrdma: Dispatch only port event when port state changes
      RDMA/ocrdma: Depend on async link events from CNA
      RDMA/be2net: Remove open and close entry points

Doug Ledford (2):
      Merge branch 'rdma-cq.2' of git://git.infradead.org/users/hch/rdma
into 4.5/rdma-cq
      Merge branches '4.5/Or-cleanup' and '4.5/rdma-cq' into k.o/for-4.5

Eran Ben Elisha (2):
      net/mlx5_core: Add setting ATOMIC endian mode
      IB/mlx5: Advertise atomic capabilities in query device

Erez Shitrit (1):
      IB/IPoIB: Fix kernel panic on multicast flow

Haggai Abramovsky (3):
      IB/mlx5: Fix data validation in mlx5_ib_alloc_ucontext
      IB/mlx5: Add CQE version 1 support to user QPs and SRQs
      IB/mlx5: Expose CQE version to user-space

Hal Rosenstock (1):
      IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling

Hariprasad S (5):
      iw_cxgb4: Pass qid range to user space driver
      iw_cxgb3: Fix incorrectly returning error on success
      iw_cxgb4: Fixes static checker warning in c4iw_rdev_open()
      iw_cxgb4: Fixes GW-Basic labels to meaningful error names
      iw_cxgb4: Take clip reference before starting IPv6 listen

Ira Weiny (2):
      IB/core: Save the device attributes on the device structure
      IB/sysfs: Fix sparse warning on attr_id

Jenny Derzhavetz (5):
      IB/iser: Don't register memory for all immediate data writes
      IB/iser: set intuitive values for mr_valid
      IB/isert: Declare correct flags when accepting a connection
      IB/isert: Support the remote invalidation exception
      IB/iser: Support the remote invalidation exception

Julia Lawall (4):
      IB/usnic: delete unneeded IS_ERR test
      RDMA/nes: constify nes_cm_ops structure
      IB/iser: constify iser_reg_ops structure
      IB/core: constify mmu_notifier_ops structures

Kaike Wan (1):
      IB/sa: Fix netlink local service GFP crash

Leon Romanovsky (9):
      IB/core: Align coding style of ib_device_cap_flags structure
      IB/core: Add cross-channel support
      IB/mlx5: Add driver cross-channel support
      IB/mlx4: Suppress non-fatal memory allocations
      IB/mlx4: Convert kmalloc to kmalloc_array for checkpatch
      IB/mlx5: Expose correct maximum number of CQE capacity
      IB/mlx5: Delete locally redefined variable
      IB/mlx5: Fix passing casted pointer in mlx5_query_port_roce
      IB/mlx5: Unify CQ create flags check

Lucas Tanure (1):
      infiniband: Replace memset with eth_zero_addr

Matan Barak (23):
      IB/core: Refactor GID cache's ib_dispatch_event
      IB/core: Change per-entry lock in RoCE GID table to one lock
      IB/core: don't search the GID table twice
      IB/core: Add gid_type to gid attribute
      IB/cm: Use the source GID index type
      IB/core: Add gid attributes to sysfs
      IB/core: Add ROCE_UDP_ENCAP (RoCE V2) type
      IB/core: Move rdma_is_upper_dev_rcu to header file
      IB/core: Validate route when we init ah
      IB/rdma_cm: Add wrapper for cma reference count
      IB/cma: Add configfs for rdma_cm
      IB/mlx5: Add create_cq extended command
      IB/core: Add ib_is_udata_cleared
      IB/mlx5: Add support for hca_core_clock and timestamp_mask
      IB/mlx5: Add hca_core_clock_offset to udata in init_ucontext
      IB/mlx5: Mmap the HCA's core clock register to user-space
      IB/cma: Fix RDMA port validation for iWarp
      IB/mlx4: Initialize hop_limit when creating address handle
      IB/core: Eliminate sparse false context imbalance warning
      IB/core: Fix dereference before check
      IB/core: Rename rdma_addr_find_dmac_by_grh
      IB/core: Use hop-limit from IP stack for RoCE
      IB/mlx4: Advertise RoCE v2 support

Mike Marciniszyn (2):
      IB/qib: fix mcast detach when qp not attached
      IB/qib: Improve ipoib UD performance

Moni Shoua (15):
      IB/core: Initialize UD header structure with IP and UDP headers
      IB/cma: Join and leave multicast groups with IGMP
      IB/mlx4: Take source mac from AH instead from the port
      net/mlx4: Remove unused macro
      net/mlx4: Query RoCE support
      IB/mlx4: Add gid_type to GID properties
      net/mlx4_core: Configure mlx4 hardware for mixed RoCE v1/v2 modes
      IB/mlx4: Add support for setting RoCEv2 gids in hardware
      net/mlx4_core: Add support for configuring RoCE v2 UDP port
      net/mlx4_core: Add support for RoCE v2 entropy
      IB/core: Add definition for the standard RoCE V2 UDP port
      IB/mlx4: Support modify_qp for RoCE v2
      IB/mlx4: Enable RoCE v2 when the IB device is added
      IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
      IB/mlx4: Create and use another QP1 for RoCEv2

Nelson Escobar (7):
      IB/usnic: Remove unused prototype
      IB/usnic: Improve a failure message
      IB/usnic: Fix incorrect cast in usnic_ib_fw_string_to_u64
      IB/usnic: Fix message typo
      IB/usnic: Support more QP state transitions
      IB/usnic: Fix resource leak in error case
      IB/usnic: Handle 0 counts in resource allocation

Or Gerlitz (8):
      IB/core: Avoid calling ib_query_device
      IB/ulps: Avoid calling ib_query_device
      net/rds: Avoid calling ib_query_device
      xprtrdma: Avoid calling ib_query_device
      staging/o2iblnd: Avoid calling ib_query_device
      IB/core: Remove ib_query_device
      MAINTAINERS: Assign new maintainers to Mellanox mlx5 core and IB
drivers
      MAINTAINERS: Assign maintainer to Mellanox mlx4 core and IB drivers=


Roi Dayan (1):
      IB/iser: Fix module init not cleaning up on error flow

Sagi Grimberg (7):
      IB/iser: Use a dedicated descriptor for login
      IB/iser: Use helper for container_of
      IB/iser: Reuse ib_sg_to_pages
      IB/iser,isert: Create and use new shared header
      IB/isert: Remove unused file iser_proto.h
      IB/iser: Change the increment rkey flow logic
      IB/srpt: Remove redundant wc array

Somnath Kotur (1):
      IB/core: Add rdma_network_type to wc

Vinit Agnihotri (1):
      IB/qib: Support creating qps with GFP_NOIO flag

majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org (10):
      net/mlx5_core: Export transport objects
      net/mlx5_core: Add RQ and SQ event handling
      net/mlx5_core: Warn on unsupported events of QP/RQ/SQ
      IB/mlx5: Allocate a Transport Domain for each ucontext
      IB/mlx5: Refactor mlx5_ib_qp to accommodate other QP types
      IB/mlx5: Add create and destroy functionality for Raw Packet QP
      IB/mlx5: Add Raw Packet QP query functionality
      IB/mlx5: Support setting Ethernet priority for Raw Packet QPs
      {IB, net}/mlx5: Move the modify QP operation table to mlx5_ib
      IB/mlx5: Expose Raw Packet QP to user space consumers

 Documentation/ABI/testing/configfs-rdma_cm         |   22 +
 Documentation/ABI/testing/sysfs-class-infiniband   |   16 +
 Documentation/infiniband/core_locking.txt          |    2 -
 Documentation/kernel-per-CPU-kthreads.txt          |    2 +-
 MAINTAINERS                                        |   32 +-
 block/Makefile                                     |    2 +-
 drivers/infiniband/Kconfig                         |   10 +
 drivers/infiniband/core/Makefile                   |    4 +-
 drivers/infiniband/core/addr.c                     |  194 +++-
 drivers/infiniband/core/cache.c                    |  345 +++++--
 drivers/infiniband/core/cm.c                       |   49 +-
 drivers/infiniband/core/cma.c                      |  265 ++++-
 drivers/infiniband/core/cma_configfs.c             |  321 +++++++
 drivers/infiniband/core/core_priv.h                |   45 +
 drivers/infiniband/core/cq.c                       |  209 ++++
 drivers/infiniband/core/device.c                   |   51 +-
 drivers/infiniband/core/fmr_pool.c                 |   20 +-
 drivers/infiniband/core/mad.c                      |  162 ++--
 drivers/infiniband/core/mad_priv.h                 |    2 +-
 drivers/infiniband/core/multicast.c                |   17 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |   81 +-
 drivers/infiniband/core/sa_query.c                 |   91 +-
 drivers/infiniband/core/sysfs.c                    |  377 +++++++-
 drivers/infiniband/core/ud_header.c                |  155 ++-
 drivers/infiniband/core/umem_odp.c                 |    2 +-
 drivers/infiniband/core/user_mad.c                 |    1 +
 drivers/infiniband/core/uverbs.h                   |    2 +
 drivers/infiniband/core/uverbs_cmd.c               |   38 +-
 drivers/infiniband/core/uverbs_main.c              |   13 +-
 drivers/infiniband/core/uverbs_marshall.c          |    1 +
 drivers/infiniband/core/verbs.c                    |  238 +++--
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cq.c              |    4 -
 drivers/infiniband/hw/cxgb3/iwch_mem.c             |  102 --
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  146 +--
 drivers/infiniband/hw/cxgb3/iwch_provider.h        |   15 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |   82 --
 drivers/infiniband/hw/cxgb4/cm.c                   |   14 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |    3 -
 drivers/infiniband/hw/cxgb4/device.c               |   57 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   13 -
 drivers/infiniband/hw/cxgb4/mem.c                  |  251 -----
 drivers/infiniband/hw/cxgb4/provider.c             |    3 -
 drivers/infiniband/hw/cxgb4/qp.c                   |    5 -
 drivers/infiniband/hw/cxgb4/t4.h                   |    7 +
 drivers/infiniband/hw/cxgb4/user.h                 |    2 +-
 drivers/infiniband/hw/mlx4/ah.c                    |    3 +-
 drivers/infiniband/hw/mlx4/cq.c                    |    3 -
 drivers/infiniband/hw/mlx4/main.c                  |  102 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   10 +-
 drivers/infiniband/hw/mlx4/mr.c                    |   22 -
 drivers/infiniband/hw/mlx4/qp.c                    |  318 ++++--
 drivers/infiniband/hw/mlx4/srq.c                   |    3 +-
 drivers/infiniband/hw/mlx5/ah.c                    |   32 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   31 +-
 drivers/infiniband/hw/mlx5/main.c                  |  445 ++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  129 ++-
 drivers/infiniband/hw/mlx5/odp.c                   |   29 +-
 drivers/infiniband/hw/mlx5/qp.c                    | 1014
+++++++++++++++++---
 drivers/infiniband/hw/mlx5/srq.c                   |   41 +-
 drivers/infiniband/hw/mlx5/user.h                  |   63 +-
 drivers/infiniband/hw/mthca/mthca_cq.c             |    3 -
 drivers/infiniband/hw/mthca/mthca_provider.c       |   84 --
 drivers/infiniband/hw/mthca/mthca_qp.c             |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   17 +-
 drivers/infiniband/hw/nes/nes_cm.h                 |    2 +-
 drivers/infiniband/hw/nes/nes_utils.c              |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |  216 +----
 drivers/infiniband/hw/nes/nes_verbs.h              |    4 +
 drivers/infiniband/hw/ocrdma/ocrdma.h              |   10 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |    7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   49 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h           |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   58 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          |   49 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  165 +---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |    3 -
 drivers/infiniband/hw/qib/qib_mr.c                 |   51 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   46 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   12 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |    4 -
 drivers/infiniband/hw/qib/qib_verbs_mcast.c        |   35 +-
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |    5 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |    4 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   24 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |    2 -
 drivers/infiniband/hw/usnic/usnic_vnic.c           |   54 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   21 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |   14 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   40 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   45 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   13 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |  156 +--
 drivers/infiniband/ulp/iser/iser_initiator.c       |  323 ++++---
 drivers/infiniband/ulp/iser/iser_memory.c          |  179 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c           |  337 ++-----
 drivers/infiniband/ulp/isert/ib_isert.c            |  118 ++-
 drivers/infiniband/ulp/isert/ib_isert.h            |   41 +-
 drivers/infiniband/ulp/isert/isert_proto.h         |   47 -
 drivers/infiniband/ulp/srp/ib_srp.c                |  205 ++--
 drivers/infiniband/ulp/srp/ib_srp.h                |    7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  443 +++------
 drivers/infiniband/ulp/srpt/ib_srpt.h              |   53 +-
 drivers/net/ethernet/emulex/benet/be.h             |    2 -
 drivers/net/ethernet/emulex/benet/be_main.c        |    4 -
 drivers/net/ethernet/emulex/benet/be_roce.c        |   36 -
 drivers/net/ethernet/emulex/benet/be_roce.h        |    4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   39 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    5 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |    7 +
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   26 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   61 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  233 +++--
 drivers/net/ethernet/mellanox/mlx5/core/srq.c      |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c |   50 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  139 ++-
 drivers/scsi/Kconfig                               |    1 +
 drivers/scsi/be2iscsi/Kconfig                      |    1 +
 drivers/scsi/be2iscsi/be.h                         |    4 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |    4 +-
 drivers/scsi/be2iscsi/be_main.c                    |   20 +-
 drivers/scsi/ipr.c                                 |   25 +-
 drivers/scsi/ipr.h                                 |    4 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   21 +-
 drivers/staging/rdma/amso1100/c2_cq.c              |    3 -
 drivers/staging/rdma/amso1100/c2_provider.c        |   72 +-
 drivers/staging/rdma/ehca/ehca_classes.h           |    5 +-
 drivers/staging/rdma/ehca/ehca_iverbs.h            |   16 -
 drivers/staging/rdma/ehca/ehca_main.c              |    4 -
 drivers/staging/rdma/ehca/ehca_mrmw.c              |  477 +--------
 drivers/staging/rdma/ehca/ehca_mrmw.h              |    5 -
 drivers/staging/rdma/ehca/ehca_reqs.c              |    1 -
 drivers/staging/rdma/hfi1/mr.c                     |   51 +-
 drivers/staging/rdma/hfi1/verbs.c                  |    1 -
 drivers/staging/rdma/hfi1/verbs.h                  |    4 -
 drivers/staging/rdma/ipath/ipath_mr.c              |   55 --
 drivers/staging/rdma/ipath/ipath_verbs.c           |    1 -
 drivers/staging/rdma/ipath/ipath_verbs.h           |    4 -
 include/linux/blk-iopoll.h                         |   46 -
 include/linux/interrupt.h                          |    2 +-
 include/linux/irq_poll.h                           |   25 +
 include/linux/mlx4/cmd.h                           |    3 +-
 include/linux/mlx4/device.h                        |   15 +-
 include/linux/mlx4/qp.h                            |   15 +-
 include/linux/mlx5/device.h                        |   45 +-
 include/linux/mlx5/driver.h                        |   20 +-
 include/linux/mlx5/mlx5_ifc.h                      |   50 +-
 include/linux/mlx5/qp.h                            |   46 +-
 .../mlx5/core =3D> include/linux/mlx5}/transobj.h    |   10 +-
 include/linux/mlx5/vport.h                         |    8 +
 include/linux/sunrpc/svc_rdma.h                    |   39 +-
 include/rdma/ib_addr.h                             |   16 +-
 include/rdma/ib_cache.h                            |    4 +
 include/rdma/ib_mad.h                              |    2 +
 include/rdma/ib_pack.h                             |   45 +-
 include/rdma/ib_pma.h                              |    1 +
 include/rdma/ib_sa.h                               |    3 +
 include/rdma/ib_verbs.h                            |  356 ++++---
 include/scsi/iser.h                                |   78 ++
 include/trace/events/irq.h                         |    2 +-
 lib/Kconfig                                        |    5 +
 lib/Makefile                                       |    1 +
 block/blk-iopoll.c =3D> lib/irq_poll.c               |  108 +--
 net/rds/ib.c                                       |   34 +-
 net/rds/iw.c                                       |   23 +-
 net/sunrpc/xprt.c                                  |    1 +
 net/sunrpc/xprtrdma/Makefile                       |    2 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |    7 +-
 net/sunrpc/xprtrdma/svc_rdma.c                     |   41 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |  371 +++++++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   56 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   33 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  360 ++++---
 net/sunrpc/xprtrdma/transport.c                    |   30 +-
 net/sunrpc/xprtrdma/verbs.c                        |   24 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   21 +-
 tools/lib/traceevent/event-parse.c                 |    2 +-
 tools/perf/util/trace-event-parse.c                |    2 +-
 182 files changed, 7272 insertions(+), 4760 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-rdma_cm
 create mode 100644 Documentation/ABI/testing/sysfs-class-infiniband
 create mode 100644 drivers/infiniband/core/cma_configfs.c
 create mode 100644 drivers/infiniband/core/cq.c
 delete mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 delete mode 100644 include/linux/blk-iopoll.h
 create mode 100644 include/linux/irq_poll.h
 rename {drivers/net/ethernet/mellanox/mlx5/core =3D>
include/linux/mlx5}/transobj.h (88%)
 create mode 100644 include/scsi/iser.h
 rename block/blk-iopoll.c =3D> lib/irq_poll.c (55%)
 create mode 100644 net/sunrpc/xprtrdma/svc_rdma_backchannel.c

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--RfjXdKBrr18fUogVoaWGjcoSrd0QIDOK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWonJ7AAoJELgmozMOVy/dFhkQAMVTdv0umiEMotCc1nC4pqge
Jng8DtB1sTkTk6XyzScMpbxikpW9MWt/cAcv3DEL0+BG9Chvmo06Zf1H3F81Ncro
BP4Q+CD8kf3MrHn4ICxUInUjGOiaONIaPpaw8p4CXojP/VaJr+YGH8M6Q08c3l0Z
YVGiDfZ6Z+PbeW/mMi5tizCE7T8aOxbFb9Tlak5Bxfi3dX8dukO/LLmWAygVMd99
KwdL2CgF9mdPGREUG4XAI/EDXsrcmUZ/nZpX7TmQ60JxhhlvW/H9OJn4ExBmmCsz
VXSj5RbbXJGRXoKuYqWxE+uL2GCQDJMFcmv56j5fXxSVMyIAUUvFwCM8Q6MWaykw
TTYzSAjeIp4oQTPlRb47ldOcMSiU4KJIM6MN+4t133WXPE4HZIlw46modu1piAnJ
Rufx9cTgwjx+3jTqwO+gs1tcGHrGgHjQ1aT+oPMlR05/RS2raneVs4d8c93zx4Dy
NAZ/CR8EUZe8m8T6WKQO9bpZalmo4mHi9bXeKYyfxT3GI/0KbdlVqhaN2+b2gRBN
oKqj1oQC5JTBBuMedNJYxw/2yFL3pKI92dA9lFOS43xfUsYal8ZUjz59DwZZJ3zT
ktRu7XTWq+HkYe7SVqWrUDZJm/80+Ii8vZrqvAy4GZnwoXQoHQpKs9ywlG+jYuuT
u02Lgm2CWQw551xew7lK
=xMiq
-----END PGP SIGNATURE-----

--RfjXdKBrr18fUogVoaWGjcoSrd0QIDOK6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
