From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue,  8 Sep 2015 12:24:38 -0400
Message-ID: <1441729478-19375-1-git-send-email-dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is a fairly sizeable set of changes.  I've put them through a
decent amount of testing prior to sending the pull request due to
that.  There are still a few fixups that I know are coming, but I
wanted to go ahead and get the big, sizable chunk into your hands
sooner rather than waiting for those last few fixups.  Of note is
the fact that this creates what is intended to be a temporary area
in the drivers/staging tree specifically for some cleanups and
additions that are coming for the RDMA stack.  We deprecated two
drivers (ipath and amso1100) and are waiting to hear back if we can
deprecate another one (ehca).  We also put Intel's new hfi1 driver
into this area because it needs to be refactored and a transfer
library created out of the factored out code, and then it and the
qib driver and the soft-roce driver should all be modified to use
that library.  I expect drivers/staging/rdma to be around for
three or four kernel releases and then to go away as all of the
work is completed and final deletions of deprecated drivers are
done.

The following changes since commit c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b:

  Linux 4.2-rc8 (2015-08-23 20:52:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to d1178cbcdcf91900ccf10a177350d7945703c151:

  IB/ipoib: Suppress warning for send only join failures (2015-09-03 17:11:05 -0400)

----------------------------------------------------------------
Changes for 4.3

- Create drivers/staging/rdma
- Move amso1100 driver to staging/rdma and schedule for deletion
- Move ipath driver to staging/rdma and schedule for deletion
- Add hfi1 driver to staging/rdma and set TODO for move to regular tree
- Initial support for namespaces to be used on RDMA devices
- Add RoCE GID table handling to the RDMA core caching code
- Infrastructure to support handling of devices with differing
  read and write scatter gather capabilities
- Various iSER updates
- Kill off unsafe usage of global mr registrations
- Update SRP driver
- Misc. mlx4 driver updates
- Support for the mr_alloc verb
- Support for a netlink interface between kernel and user space cache
  daemon to speed path record queries and route resolution
- Ininitial support for safe hot removal of verbs devices

----------------------------------------------------------------
Adir Lev (1):
      IB/iser: Maintain connection fmr_pool under a single registration descriptor

Ariel Nahum (1):
      IB/mlx4: Fix incorrect cq flushing in error state

Bart Van Assche (12):
      IB/srp: Constify a function argument
      IB/srp: Handle partial connection success correctly
      IB/srp: Bump driver version and release date
      IB/srp: Stop the scsi_eh_<n> and scsi_tmf_<n> threads if login fails
      IB/srp: Re-enable FMR for non-page aligned buffers
      IB/srp: Use multiple registrations for large memory regions
      IB/srp: Add memory descriptor array pointer range checking
      IB/srp: Remove the memory registration backtracking code
      IB/srp: Remove use_mr argument from srp_map_sg_entry()
      IB/srp: Introduce srp_device.use_fmr
      IB/srp: Register the indirect data buffer descriptor
      IB/srp: Create an insecure all physical rkey only if needed

Christoph Hellwig (1):
      IB/uverbs: reject invalid or unknown opcodes

Dan Carpenter (1):
      IB/core: missing curly braces in ib_find_gid()

Dennis Dalessandro (2):
      IB/ipath: Deprecate ipath driver and move to staging.
      IB/core: Add core header changes needed for OPA

Doug Ledford (3):
      Staging: Add staging/rdma directory and update MAINTAINERS
      IB/core: Remove needless bracketization
      IB/ipoib: Clean up send-only multicast joins

Guy Shapiro (1):
      IB/ipoib: Return IPoIB devices matching connection parameters

Haggai Eran (14):
      IB/core: Add rwsem to allow reading device list or client list
      IB/core: lock client data with lists_rwsem
      IB/cm: Expose service ID in request events
      IB/cm: Share listening CM IDs
      IB/cma: Refactor RDMA IP CM private-data parsing code
      IB/cma: Helper functions to access port space IDRs
      IB/cm: Expose BTH P_Key in CM and SIDR request events
      IB/cma: Add net_dev and private data checks to RDMA CM
      IB/cma: Validate routing of incoming requests
      IB/cma: Use found net_dev for passive connections
      IB/cma: Share ib_cm_ids between rdma_cm_ids
      IB/cm: Remove compare_data checks
      IB/cma: Fix net_dev reference leak with failed requests
      IB/mlx5: avoid destroying a NULL mr in reg_user_mr error flow

Hariprasad S (2):
      iw_cxgb4: set the default MPA version to 2
      iw_cxgb4: Add support for clip

Ira Weiny (3):
      IB/hfi1: Add PSM2 user space header to header_install
      IB/core: Remove unnecessary defines from ib_mad.h
      IB/core: Move SM class defines from ib_mad.h to ib_smi.h

Jack Morgenstein (3):
      IB/mlx4: Fix potential deadlock when sending mad to wire
      IB/mlx4: Demote mcg message from warning to debug
      IB/mlx4: Forbid using sysfs to change RoCE pkeys

Jason Gunthorpe (15):
      IB/ucma: Fix theoretical user triggered use-after-free
      IB/core: Make ib_alloc_device init the kobject
      IB/core: Guarantee that a local_dma_lkey is available
      IB/mad: Remove ib_get_dma_mr calls
      IB/ipoib: Remove ib_get_dma_mr calls
      IB/mlx4: Remove ib_get_dma_mr calls
      IB/mlx5: Remove ib_get_dma_mr calls
      IB/iser: Use pd->local_dma_lkey
      iser-target: Remove ib_get_dma_mr calls
      IB/srp: Use pd->local_dma_lkey
      ib_srpt: Remove ib_get_dma_mr calls
      net/9p: Remove ib_get_dma_mr calls
      rds/ib: Remove ib_get_dma_mr calls
      IB/core: Make ib_dealloc_pd return void
      IB/ipoib: Suppress warning for send only join failures

Jeff Becker (1):
      staging/hfi1: replace indent spaces with tabs

Jenny Falkovich (1):
      IB/iser: Change some module parameters to be RO

Jubin John (1):
      IB/hfi1: Add CSRs for CONFIG_SDMA_VERBOSITY

Kaike Wan (5):
      IB/netlink: Add defines for local service requests through netlink
      IB/core: Add rdma netlink helper functions
      IB/sa: Allocate SA query with kzalloc
      IB/sa: Route SA pathrecord query through netlink
      IB/sa: Fix rdma netlink message flags

Matan Barak (5):
      net/ipv6: Export addrconf_ifid_eui48
      net: Add info for NETDEV_CHANGEUPPER event
      net/bonding: Export bond_option_active_slave_get_rcu
      IB/core: Add RoCE GID table management
      IB/core: Add RoCE table bonding support

Mike Marciniszyn (3):
      IB/qib: Change lkey table allocation to support more MRs
      IB/hfi1: add driver files
      IB/hfi1: Support ib_alloc_mr verb

Moni Shoua (3):
      net/mlx4: Postpone the registration of net_device
      IB/mlx4: Implement ib_device callbacks
      IB/mlx4: Replace mechanism for RoCE GID management

Nicholas Krause (1):
      IB/cxgb4: Fix if statement in pick_local_ip6adddrs

Noa Osherovich (1):
      IB/mlx4: Use correct SL on AH query under RoCE

Roland Dreier (1):
      IB/mlx5: Remove dead code from alloc_cached_mr()

Sagi Grimberg (40):
      mlx5: Fix missing device local_dma_lkey
      mlx5: Expose correct page_size_cap in device attributes
      mlx4, mlx5, mthca: Expose max_sge_rd correctly
      IB/core: Get rid of redundant verb ib_destroy_mr
      IB: Modify ib_create_mr API
      IB/iser: Convert to ib_alloc_mr
      iser-target: Convert to ib_alloc_mr
      IB/srp: Convert to ib_alloc_mr
      xprtrdma, svcrdma: Convert to ib_alloc_mr
      RDS: Convert to ib_alloc_mr
      mlx5: Drop mlx5_ib_alloc_fast_reg_mr
      mlx4: Support ib_alloc_mr verb
      ocrdma: Support ib_alloc_mr verb
      iw_cxgb4: Support ib_alloc_mr verb
      cxgb3: Support ib_alloc_mr verb
      nes: Support ib_alloc_mr verb
      qib: Support ib_alloc_mr verb
      IB/core: Drop ib_alloc_fast_reg_mr
      IB/iser: Change minor assignments and logging prints
      IB/iser: Remove '.' from log message
      IB/iser: Fix missing return status check in iser_send_data_out
      IB/iser: Get rid of un-maintained counters
      IB/iser: Fix possible bogus DMA unmapping
      IB/iser: Remove a redundant always-false condition
      IB/iser: Remove an unneeded print for unaligned memory
      IB/iser: Introduce struct iser_reg_resources
      IB/iser: Rename struct fast_reg_descriptor -> iser_fr_desc
      IB/iser: Remove dead code in fmr_pool alloc/free
      IB/iser: Introduce iser_reg_ops
      IB/iser: Move fastreg descriptor allocation to iser_create_fastreg_desc
      IB/iser: Introduce iser registration pool struct
      IB/iser: Rename iser_reg_page_vec to iser_fast_reg_fmr
      IB/iser: Make reg_desc_get a per device routine
      IB/iser: Unify fast memory registration flows
      IB/iser: Pass registration pool a size parameter
      IB/iser: Support up to 8MB data transfer in a single command
      IB/iser: Add debug prints to the various memory registration methods
      IB/iser: Chain all iser transaction send work requests
      mlx5: Fix incorrect wc pkey_index assignment for GSI messages
      IB/srp: Fix possible protection fault

Somnath Kotur (1):
      RDMA/ocrdma: Incorporate the moving of GID Table mgmt to IB/Core

Spencer Baugh (1):
      RDMA/cma: fix IPv6 address resolution

Steve Wise (6):
      RDMA/iser: Limit sgs to the device fastreg depth
      RDMA/amso1100: Deprecate the amso1100 driver and move to staging
      ipath,qib: Expose max_sge_rd correctly
      svcrdma: Use max_sge_rd for destination read depths
      RDMA/Core: remove rdma_cap_read_multi_sge() helper
      svcrdma: limit FRMR page list lengths to device max

Yishai Hadas (6):
      IB/uverbs: Fix reference counting usage of event files
      IB/uverbs: Fix race between ib_uverbs_open and remove_one
      IB/uverbs: Explicitly pass ib_dev to uverbs commands
      IB/uverbs: Enable device removal when there are active user space applications
      IB/mlx4_ib: Disassociate support
      IB/ucma: HW Device hot-removal support

Yotam Kenneth (1):
      IB/core: Find the network device matching connection parameters

 Documentation/infiniband/sysfs.txt                 |    20 +
 MAINTAINERS                                        |     9 +-
 drivers/infiniband/Kconfig                         |     2 -
 drivers/infiniband/core/Makefile                   |     3 +-
 drivers/infiniband/core/cache.c                    |   773 +-
 drivers/infiniband/core/cm.c                       |   215 +-
 drivers/infiniband/core/cma.c                      |   657 +-
 drivers/infiniband/core/core_priv.h                |    54 +-
 drivers/infiniband/core/device.c                   |   335 +-
 drivers/infiniband/core/mad.c                      |    28 +-
 drivers/infiniband/core/mad_priv.h                 |     1 -
 drivers/infiniband/core/multicast.c                |     7 +-
 drivers/infiniband/core/netlink.c                  |    55 +
 drivers/infiniband/core/roce_gid_mgmt.c            |   730 ++
 drivers/infiniband/core/sa_query.c                 |   515 +-
 drivers/infiniband/core/sysfs.c                    |    51 +-
 drivers/infiniband/core/ucm.c                      |     9 +-
 drivers/infiniband/core/ucma.c                     |   146 +-
 drivers/infiniband/core/user_mad.c                 |     6 +-
 drivers/infiniband/core/uverbs.h                   |    16 +-
 drivers/infiniband/core/uverbs_cmd.c               |   147 +-
 drivers/infiniband/core/uverbs_main.c              |   448 +-
 drivers/infiniband/core/verbs.c                    |   131 +-
 drivers/infiniband/hw/Makefile                     |     2 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    14 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    82 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |     4 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |    12 +-
 drivers/infiniband/hw/cxgb4/provider.c             |     2 +-
 drivers/infiniband/hw/mlx4/ah.c                    |     8 +-
 drivers/infiniband/hw/mlx4/cq.c                    |     2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |    23 +-
 drivers/infiniband/hw/mlx4/main.c                  |   891 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |    15 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    40 +-
 drivers/infiniband/hw/mlx4/mr.c                    |    11 +-
 drivers/infiniband/hw/mlx4/qp.c                    |    10 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |     5 +-
 drivers/infiniband/hw/mlx5/cq.c                    |    10 +-
 drivers/infiniband/hw/mlx5/main.c                  |    30 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    14 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   124 +-
 drivers/infiniband/hw/mlx5/qp.c                    |     5 -
 drivers/infiniband/hw/mthca/mthca_provider.c       |     1 +
 drivers/infiniband/hw/nes/nes_verbs.c              |    19 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h              |     1 -
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   236 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          |     2 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |    56 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |    15 +-
 drivers/infiniband/hw/qib/qib_keys.c               |     4 +
 drivers/infiniband/hw/qib/qib_mad.h                |   147 +-
 drivers/infiniband/hw/qib/qib_mr.c                 |     9 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |     1 +
 drivers/infiniband/hw/qib/qib_verbs.c              |    17 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |     6 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |     1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |     4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   236 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |    50 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    22 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |    91 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   206 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |    38 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |   482 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   339 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    47 +-
 drivers/infiniband/ulp/isert/ib_isert.h            |     1 -
 drivers/infiniband/ulp/srp/ib_srp.c                |   282 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |    25 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    22 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |     1 -
 drivers/net/bonding/bond_options.c                 |    13 -
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    36 +-
 drivers/net/ethernet/mellanox/mlx4/intf.c          |     3 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    22 +
 drivers/staging/Kconfig                            |     2 +
 drivers/staging/Makefile                           |     1 +
 drivers/staging/rdma/Kconfig                       |    31 +
 drivers/staging/rdma/Makefile                      |     4 +
 .../hw => staging/rdma}/amso1100/Kbuild            |     0
 .../hw => staging/rdma}/amso1100/Kconfig           |     0
 drivers/staging/rdma/amso1100/TODO                 |     4 +
 .../{infiniband/hw => staging/rdma}/amso1100/c2.c  |     0
 .../{infiniband/hw => staging/rdma}/amso1100/c2.h  |     0
 .../hw => staging/rdma}/amso1100/c2_ae.c           |     0
 .../hw => staging/rdma}/amso1100/c2_ae.h           |     0
 .../hw => staging/rdma}/amso1100/c2_alloc.c        |     0
 .../hw => staging/rdma}/amso1100/c2_cm.c           |     0
 .../hw => staging/rdma}/amso1100/c2_cq.c           |     0
 .../hw => staging/rdma}/amso1100/c2_intr.c         |     0
 .../hw => staging/rdma}/amso1100/c2_mm.c           |     0
 .../hw => staging/rdma}/amso1100/c2_mq.c           |     0
 .../hw => staging/rdma}/amso1100/c2_mq.h           |     0
 .../hw => staging/rdma}/amso1100/c2_pd.c           |     0
 .../hw => staging/rdma}/amso1100/c2_provider.c     |     0
 .../hw => staging/rdma}/amso1100/c2_provider.h     |     0
 .../hw => staging/rdma}/amso1100/c2_qp.c           |     0
 .../hw => staging/rdma}/amso1100/c2_rnic.c         |     0
 .../hw => staging/rdma}/amso1100/c2_status.h       |     0
 .../hw => staging/rdma}/amso1100/c2_user.h         |     0
 .../hw => staging/rdma}/amso1100/c2_vq.c           |     0
 .../hw => staging/rdma}/amso1100/c2_vq.h           |     0
 .../hw => staging/rdma}/amso1100/c2_wr.h           |     0
 drivers/staging/rdma/hfi1/Kconfig                  |    37 +
 drivers/staging/rdma/hfi1/Makefile                 |    19 +
 drivers/staging/rdma/hfi1/TODO                     |     6 +
 drivers/staging/rdma/hfi1/chip.c                   | 10798 +++++++++++++++++++
 drivers/staging/rdma/hfi1/chip.h                   |  1035 ++
 drivers/staging/rdma/hfi1/chip_registers.h         |  1292 +++
 drivers/staging/rdma/hfi1/common.h                 |   415 +
 drivers/staging/rdma/hfi1/cq.c                     |   558 +
 drivers/staging/rdma/hfi1/debugfs.c                |   899 ++
 drivers/staging/rdma/hfi1/debugfs.h                |    78 +
 drivers/staging/rdma/hfi1/device.c                 |   142 +
 drivers/staging/rdma/hfi1/device.h                 |    61 +
 drivers/staging/rdma/hfi1/diag.c                   |  1873 ++++
 drivers/staging/rdma/hfi1/dma.c                    |   186 +
 drivers/staging/rdma/hfi1/driver.c                 |  1241 +++
 drivers/staging/rdma/hfi1/eprom.c                  |   475 +
 drivers/staging/rdma/hfi1/eprom.h                  |    55 +
 drivers/staging/rdma/hfi1/file_ops.c               |  2140 ++++
 drivers/staging/rdma/hfi1/firmware.c               |  1620 +++
 drivers/staging/rdma/hfi1/hfi.h                    |  1821 ++++
 drivers/staging/rdma/hfi1/init.c                   |  1722 +++
 drivers/staging/rdma/hfi1/intr.c                   |   207 +
 drivers/staging/rdma/hfi1/iowait.h                 |   186 +
 drivers/staging/rdma/hfi1/keys.c                   |   411 +
 drivers/staging/rdma/hfi1/mad.c                    |  4257 ++++++++
 drivers/staging/rdma/hfi1/mad.h                    |   325 +
 drivers/staging/rdma/hfi1/mmap.c                   |   192 +
 drivers/staging/rdma/hfi1/mr.c                     |   551 +
 drivers/staging/rdma/hfi1/opa_compat.h             |   129 +
 drivers/staging/rdma/hfi1/pcie.c                   |  1253 +++
 drivers/staging/rdma/hfi1/pio.c                    |  1771 +++
 drivers/staging/rdma/hfi1/pio.h                    |   224 +
 drivers/staging/rdma/hfi1/pio_copy.c               |   858 ++
 drivers/staging/rdma/hfi1/platform_config.h        |   286 +
 drivers/staging/rdma/hfi1/qp.c                     |  1687 +++
 drivers/staging/rdma/hfi1/qp.h                     |   235 +
 drivers/staging/rdma/hfi1/qsfp.c                   |   546 +
 drivers/staging/rdma/hfi1/qsfp.h                   |   222 +
 drivers/staging/rdma/hfi1/rc.c                     |  2426 +++++
 drivers/staging/rdma/hfi1/ruc.c                    |   948 ++
 drivers/staging/rdma/hfi1/sdma.c                   |  2962 +++++
 drivers/staging/rdma/hfi1/sdma.h                   |  1123 ++
 drivers/staging/rdma/hfi1/srq.c                    |   397 +
 drivers/staging/rdma/hfi1/sysfs.c                  |   739 ++
 drivers/staging/rdma/hfi1/trace.c                  |   221 +
 drivers/staging/rdma/hfi1/trace.h                  |  1409 +++
 drivers/staging/rdma/hfi1/twsi.c                   |   518 +
 drivers/staging/rdma/hfi1/twsi.h                   |    68 +
 drivers/staging/rdma/hfi1/uc.c                     |   585 +
 drivers/staging/rdma/hfi1/ud.c                     |   885 ++
 drivers/staging/rdma/hfi1/user_pages.c             |   156 +
 drivers/staging/rdma/hfi1/user_sdma.c              |  1444 +++
 drivers/staging/rdma/hfi1/user_sdma.h              |    89 +
 drivers/staging/rdma/hfi1/verbs.c                  |  2143 ++++
 drivers/staging/rdma/hfi1/verbs.h                  |  1151 ++
 drivers/staging/rdma/hfi1/verbs_mcast.c            |   385 +
 .../{infiniband/hw => staging/rdma}/ipath/Kconfig  |     4 +-
 .../{infiniband/hw => staging/rdma}/ipath/Makefile |     0
 drivers/staging/rdma/ipath/TODO                    |     5 +
 .../hw => staging/rdma}/ipath/ipath_common.h       |     0
 .../hw => staging/rdma}/ipath/ipath_cq.c           |     0
 .../hw => staging/rdma}/ipath/ipath_debug.h        |     0
 .../hw => staging/rdma}/ipath/ipath_diag.c         |     0
 .../hw => staging/rdma}/ipath/ipath_dma.c          |     0
 .../hw => staging/rdma}/ipath/ipath_driver.c       |     0
 .../hw => staging/rdma}/ipath/ipath_eeprom.c       |     0
 .../hw => staging/rdma}/ipath/ipath_file_ops.c     |     0
 .../hw => staging/rdma}/ipath/ipath_fs.c           |     0
 .../hw => staging/rdma}/ipath/ipath_iba6110.c      |     0
 .../hw => staging/rdma}/ipath/ipath_init_chip.c    |     0
 .../hw => staging/rdma}/ipath/ipath_intr.c         |     0
 .../hw => staging/rdma}/ipath/ipath_kernel.h       |     0
 .../hw => staging/rdma}/ipath/ipath_keys.c         |     0
 .../hw => staging/rdma}/ipath/ipath_mad.c          |     0
 .../hw => staging/rdma}/ipath/ipath_mmap.c         |     0
 .../hw => staging/rdma}/ipath/ipath_mr.c           |     0
 .../hw => staging/rdma}/ipath/ipath_qp.c           |     0
 .../hw => staging/rdma}/ipath/ipath_rc.c           |     0
 .../hw => staging/rdma}/ipath/ipath_registers.h    |     0
 .../hw => staging/rdma}/ipath/ipath_ruc.c          |     0
 .../hw => staging/rdma}/ipath/ipath_sdma.c         |     0
 .../hw => staging/rdma}/ipath/ipath_srq.c          |     0
 .../hw => staging/rdma}/ipath/ipath_stats.c        |     0
 .../hw => staging/rdma}/ipath/ipath_sysfs.c        |     0
 .../hw => staging/rdma}/ipath/ipath_uc.c           |     0
 .../hw => staging/rdma}/ipath/ipath_ud.c           |     0
 .../hw => staging/rdma}/ipath/ipath_user_pages.c   |     0
 .../hw => staging/rdma}/ipath/ipath_user_sdma.c    |     0
 .../hw => staging/rdma}/ipath/ipath_user_sdma.h    |     0
 .../hw => staging/rdma}/ipath/ipath_verbs.c        |     1 +
 .../hw => staging/rdma}/ipath/ipath_verbs.h        |     0
 .../hw => staging/rdma}/ipath/ipath_verbs_mcast.c  |     0
 .../hw => staging/rdma}/ipath/ipath_wc_ppc64.c     |     0
 .../hw => staging/rdma}/ipath/ipath_wc_x86_64.c    |     0
 include/linux/mlx4/device.h                        |     3 +-
 include/linux/mlx4/driver.h                        |     1 +
 include/linux/mlx5/device.h                        |    11 +
 include/linux/mlx5/driver.h                        |     1 +
 include/linux/netdevice.h                          |    14 +
 include/linux/sunrpc/svc_rdma.h                    |     1 +
 include/net/addrconf.h                             |    31 +
 include/net/bonding.h                              |     7 +
 include/rdma/ib_cm.h                               |    25 +-
 include/rdma/ib_mad.h                              |    82 +-
 include/rdma/ib_pack.h                             |     2 +
 include/rdma/ib_smi.h                              |    47 +
 include/rdma/ib_verbs.h                            |   203 +-
 include/rdma/opa_port_info.h                       |   433 +
 include/rdma/opa_smi.h                             |    47 +
 include/rdma/rdma_netlink.h                        |     7 +
 include/uapi/rdma/Kbuild                           |     1 +
 include/uapi/rdma/hfi/Kbuild                       |     2 +
 include/uapi/rdma/hfi/hfi1_user.h                  |   427 +
 include/uapi/rdma/rdma_netlink.h                   |    82 +
 net/9p/trans_rdma.c                                |    26 +-
 net/core/dev.c                                     |    12 +-
 net/ipv6/addrconf.c                                |    31 -
 net/rds/ib.c                                       |    13 +-
 net/rds/ib.h                                       |     2 -
 net/rds/ib_cm.c                                    |     4 +-
 net/rds/ib_recv.c                                  |     6 +-
 net/rds/ib_send.c                                  |     8 +-
 net/rds/iw.c                                       |    10 +-
 net/rds/iw_rdma.c                                  |     5 +-
 net/rds/iw_send.c                                  |     5 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |     6 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |    12 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    10 +-
 net/sunrpc/xprtrdma/verbs.c                        |     2 +-
 233 files changed, 64457 insertions(+), 2733 deletions(-)
 create mode 100644 drivers/infiniband/core/roce_gid_mgmt.c
 create mode 100644 drivers/staging/rdma/Kconfig
 create mode 100644 drivers/staging/rdma/Makefile
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/Kbuild (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/Kconfig (100%)
 create mode 100644 drivers/staging/rdma/amso1100/TODO
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_ae.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_ae.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_alloc.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_cm.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_cq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_intr.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_mm.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_mq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_mq.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_pd.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_provider.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_provider.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_qp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_rnic.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_status.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_user.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_vq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_vq.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/amso1100/c2_wr.h (100%)
 create mode 100644 drivers/staging/rdma/hfi1/Kconfig
 create mode 100644 drivers/staging/rdma/hfi1/Makefile
 create mode 100644 drivers/staging/rdma/hfi1/TODO
 create mode 100644 drivers/staging/rdma/hfi1/chip.c
 create mode 100644 drivers/staging/rdma/hfi1/chip.h
 create mode 100644 drivers/staging/rdma/hfi1/chip_registers.h
 create mode 100644 drivers/staging/rdma/hfi1/common.h
 create mode 100644 drivers/staging/rdma/hfi1/cq.c
 create mode 100644 drivers/staging/rdma/hfi1/debugfs.c
 create mode 100644 drivers/staging/rdma/hfi1/debugfs.h
 create mode 100644 drivers/staging/rdma/hfi1/device.c
 create mode 100644 drivers/staging/rdma/hfi1/device.h
 create mode 100644 drivers/staging/rdma/hfi1/diag.c
 create mode 100644 drivers/staging/rdma/hfi1/dma.c
 create mode 100644 drivers/staging/rdma/hfi1/driver.c
 create mode 100644 drivers/staging/rdma/hfi1/eprom.c
 create mode 100644 drivers/staging/rdma/hfi1/eprom.h
 create mode 100644 drivers/staging/rdma/hfi1/file_ops.c
 create mode 100644 drivers/staging/rdma/hfi1/firmware.c
 create mode 100644 drivers/staging/rdma/hfi1/hfi.h
 create mode 100644 drivers/staging/rdma/hfi1/init.c
 create mode 100644 drivers/staging/rdma/hfi1/intr.c
 create mode 100644 drivers/staging/rdma/hfi1/iowait.h
 create mode 100644 drivers/staging/rdma/hfi1/keys.c
 create mode 100644 drivers/staging/rdma/hfi1/mad.c
 create mode 100644 drivers/staging/rdma/hfi1/mad.h
 create mode 100644 drivers/staging/rdma/hfi1/mmap.c
 create mode 100644 drivers/staging/rdma/hfi1/mr.c
 create mode 100644 drivers/staging/rdma/hfi1/opa_compat.h
 create mode 100644 drivers/staging/rdma/hfi1/pcie.c
 create mode 100644 drivers/staging/rdma/hfi1/pio.c
 create mode 100644 drivers/staging/rdma/hfi1/pio.h
 create mode 100644 drivers/staging/rdma/hfi1/pio_copy.c
 create mode 100644 drivers/staging/rdma/hfi1/platform_config.h
 create mode 100644 drivers/staging/rdma/hfi1/qp.c
 create mode 100644 drivers/staging/rdma/hfi1/qp.h
 create mode 100644 drivers/staging/rdma/hfi1/qsfp.c
 create mode 100644 drivers/staging/rdma/hfi1/qsfp.h
 create mode 100644 drivers/staging/rdma/hfi1/rc.c
 create mode 100644 drivers/staging/rdma/hfi1/ruc.c
 create mode 100644 drivers/staging/rdma/hfi1/sdma.c
 create mode 100644 drivers/staging/rdma/hfi1/sdma.h
 create mode 100644 drivers/staging/rdma/hfi1/srq.c
 create mode 100644 drivers/staging/rdma/hfi1/sysfs.c
 create mode 100644 drivers/staging/rdma/hfi1/trace.c
 create mode 100644 drivers/staging/rdma/hfi1/trace.h
 create mode 100644 drivers/staging/rdma/hfi1/twsi.c
 create mode 100644 drivers/staging/rdma/hfi1/twsi.h
 create mode 100644 drivers/staging/rdma/hfi1/uc.c
 create mode 100644 drivers/staging/rdma/hfi1/ud.c
 create mode 100644 drivers/staging/rdma/hfi1/user_pages.c
 create mode 100644 drivers/staging/rdma/hfi1/user_sdma.c
 create mode 100644 drivers/staging/rdma/hfi1/user_sdma.h
 create mode 100644 drivers/staging/rdma/hfi1/verbs.c
 create mode 100644 drivers/staging/rdma/hfi1/verbs.h
 create mode 100644 drivers/staging/rdma/hfi1/verbs_mcast.c
 rename drivers/{infiniband/hw => staging/rdma}/ipath/Kconfig (81%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/Makefile (100%)
 create mode 100644 drivers/staging/rdma/ipath/TODO
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_common.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_cq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_debug.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_diag.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_dma.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_driver.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_eeprom.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_file_ops.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_fs.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_iba6110.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_init_chip.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_intr.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_kernel.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_keys.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_mad.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_mmap.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_mr.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_qp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_rc.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_registers.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_ruc.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_sdma.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_srq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_stats.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_sysfs.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_uc.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_ud.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_user_pages.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_user_sdma.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_user_sdma.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_verbs.c (99%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_verbs.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_verbs_mcast.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_wc_ppc64.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ipath/ipath_wc_x86_64.c (100%)
 create mode 100644 include/rdma/opa_port_info.h
 create mode 100644 include/uapi/rdma/hfi/Kbuild
 create mode 100644 include/uapi/rdma/hfi/hfi1_user.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
