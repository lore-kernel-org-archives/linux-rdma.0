From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 03 May 2017 11:17:03 -0400
Message-ID: <1493824623.3041.219.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

As has been the case with several pull requests lately, I had to wait
until after the net-next pull request was pulled in as my tree is based
on a snapshot of net-next.  I've had people submit some late breaking
stuff this cycle.  I took a series last week that broke a followon
series that was on the list.  The fixed version didn't land until
Saturday, so I didn't get it until Monday.  Everything has passed 0day,
and everything should have been through linux-next (although since new
errors are ignored on the first day of new patches in linux-next, there
is one patch I took by itself yesterday that theoretically might
trigger new warnings, but once you see the patch, you'll agree it's not
an issue).

Primary updates in this release:

- Lots of driver fixes and misc fixes across the board.
- I had to base on a net-next tree because the IPoIB Accelorator
patches needed it.  Unfortunately, it was known to Mellanox that there
would need to be an IPoIB accelorator patch to the net tree (which left
some functions turned off by an #ifdef construct to avoid warnings
about defined but unused functions), then one to the RDMA tree, then a
fixup that went back and re-enabled the functions in the net tree and
enabled their use in the rdma tree.  But, a sparse fix was sent to the
net tree after I did my pull, and the fixup patch conflicts quite
directly with that sparse fix, so I'm going to submit the fixup patch
towards the end of the merge window by itself and based upon your
master branch at the time.
- Two separate rounds of hfi1 fixes, one that got dropped from last
release because it came in just a day or two before the end of the
merge window and then the one from this release cycle.  Of note is that
I now have a third series that just landed from Intel yesterday.  It is
not included in this pull request, but I may submit it by the end of
the week.  I'll talk to Intel about improving the timing of thier
submissions for my workflow.
- Changes to our idr usage in the RDMA subsystem that will tie into our
cgroup management and also into the upcoming changes for the RDMA
kernel<->userspace API.
- Addition of support for a netdev to be tied to an RDMA device at the
core level
- Addition of the VNIC driver from Intel.  While IPoIB provides IP over
InfiniBand (and *only* IP, no lower layer protocol headers are allowed
or supported), the VNIC driver presents a virtual Ethernet device with
support for things like varying Ethertypes, VLANs, priorities and other
features of Ethernet.  The virtual devices are centrally managed by the
OPA fabric manager, making this (for the time being) a strictly OPA
specific feature.
- Improvements to the On-Demand Paging support in the RDMA subsystem.
- Addition of three significant OPA changes.  While we added OPA
support some time ago (via the hfi1 driver), the RDMA subsystem has so
far glossed over the areas where OPA and InfiniBand differ.  With this
release we are starting to add support for the OPA extensions into the
RDMA core in the following area: Extended port information for OPA is
now supported, extended Address Handle attributes for OPA are now
supported, and extended SA Queries to get OPA specific subnet
information is now supported.

That pretty much covers things.  Here's the git produced boiler plate
for you:

The following changes since commit
70d40b366d2f7c2facaa3bc20f26e562e91ce94d:

  Merge branch 'mlx5-RDMA-netdevice' (2017-04-17 11:08:33 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
24b43c99647bf9be4995e6a6c9c3a923c147770a:

  infiniband: avoid dereferencing uninitialized dst on error path
(2017-05-02 10:45:45 -0400)

----------------------------------------------------------------
Updates for 4.12 kernel merge window

- idr usage and locking changes
- build fix for hns
- ipoib debug path record file fix
- hfi1 updates
- core RDMA netdev addition
- Intel VNIC driver addition
- Enhanced accelerators for IPoIB addition
- Debug cleanups in cxgb3/4
- Trivial cleanups from SF Markus Elfring
- Misc rxe fixes from Mellanox
- Misc ipoib fixes from Mellanox
- Lots of mlx4/mlx5 changes from Mellanox
- Misc fixes across the RDMA subsystem
- ODP paging fixes and improvements
- qedr updates
- hfi1 updates
- OPA port info patches
- OPA AH patches
- OPA SA Query patches

----------------------------------------------------------------
Amrani, Ram (5):
      RDMA/qedr: reset access control when registering a MR
      RDMA/qedr: properly check atomic capabilities
      RDMA/qedr: enhance destroy flow for GSI QP
      RDMA/qedr: destroy CQ only after HW releases it
      RDMA/qedr: add support for send+invalidate in poll CQ

Ariel Levkovich (2):
      IB/mlx5: Add inner spec and IPv6 validation in user's flow
attribute list
      IB/mlx5: Use IP version matching to classify IP traffic

Arnd Bergmann (1):
      infiniband: hns: avoid gcc-7.0.1 warning for uninitialized data

Artemy Kovalyov (10):
      IB: Replace ib_umem page_size by page_shift
      IB/mlx5: Fix function updating xlt emergency path
      IB/mlx5: Fix UMR size calculation
      IB/mlx5: Fix implicit MR GC
      IB/mlx5: Decrease verbosity level of ODP errors
      IB/umem: Add contiguous ODP support
      IB/mlx5: Add contiguous ODP support
      IB/umem: Add support to huge ODP
      IB/mlx5: Extract page fault code
      IB/mlx5: Add ODP support to MW

Bodong Wang (1):
      IB/mlx5: Fix wrong use of kfree at bad flow in create_cq_user

Colin Ian King (3):
      RDMA/bnxt_re: remove redundant initialization of rc to zero
      IB/iser: fix spelling mistake: "unexepected" -> "unexpected"
      IB/rxe: fix typo: "algorithmi" -> "algorithm"

Dan Carpenter (1):
      IB/rdmavt: restore IRQs on error path in rvt_create_ah()

Dasaratharaman Chandramouli (33):
      IB/hfi1: Rename hdr2sc to hfi1_9B_get_sc5
      IB/SA: Fix lines longer than 80 columns
      IB/SA: Add braces when using sizeof
      IB/SA: Remove unwanted braces
      IB/SA: Move functions update_sm_ah() and ib_sa_event()
      IB/SA: Modify SA to implicitly cache Class Port info
      IB/core: Add rdma_cap_opa_ah to expose opa address handles
      IB/core: Move opa_class_port_info definition to header file
      IB/SA: Add support to query opa classport info.
      IB/ocrdma: Add identifier names to function definitions
      IB/IPoIB: Remove 'else' when the 'if' has a return.
      IB/core: Add braces when using sizeof
      IB/core: Check for global flag when using ah_attr
      IB/rxe: Initialize ib_ah_attr during query_ah
      IB/core: Rename struct ib_ah_attr to rdma_ah_attr
      IB/core: Rename ib_create_ah to rdma_create_ah
      IB/core: Rename ib_modify_ah to rdma_modify_ah
      IB/core: Rename ib_query_ah to rdma_query_ah
      IB/core: Rename ib_destroy_ah to rdma_destroy_ah
      IB/mlx4: Rename to_ib_ah_attr to to_rdma_ah_attr
      IB/mlx5: Rename to_ib_ah_attr to to_rdma_ah_attr
      IB/mthca: Rename to_ib_ah_attr to to_rdma_ah_attr
      IB/PVRDMA: Rename ib_ah_attr related functions
      IB/core: Add accessor functions for rdma_ah_attr fields
      IB/core: Use rdma_ah_attr accessor functions
      IB/core: Define 'ib' and 'roce' rdma_ah_attr types
      IB/core: Define 'opa' rdma_ah_attr type
      IB/CM: Add braces when using sizeof
      IB/SA: Rename ib_sa_path_rec to sa_path_rec
      IB/SA: Introduce path record specific types
      IB/SA: Split struct sa_path_rec based on IB and ROCE specific
fields
      IB/SA: Add OPA path record type
      IB/SA: Add support to query OPA path records

Dean Luick (1):
      IB/hfi1: Force logical link down

Dennis Dalessandro (4):
      IB/hfi1: Fix misspelling in comment
      IB/hfi1: Convert %Lx to %llx
      IB/hfi1: Fix unbalanced braces around else
      IB/hfi1: Use bool in process_ecn

Don Hiatt (4):
      IB/hfi1: Add receive fault injection feature
      IB/hfi1: Add transmit fault injection feature
      IB/hfi1: Add functions to parse 9B headers
      IB/hfi1: Use defines from common headers

Doug Ledford (4):
      Merge branch 'k.o/for-4.12' into k.o/for-4.12-rdma-netdevice
      cxgb4: Convert PDBG to pr_debug the second
      RDMA/bnxt_re: Use IS_ERR_OR_NULL where appropriate
      IB/SA: Add OPA addr header

Easwar Hariharan (1):
      IB/hfi1: Check for QSFP presence before attempting reads

Erez Shitrit (5):
      IB/IPoIB: Separate control and data related initializations
      IB/IPoIB: Separate control from HW operation on ipoib_open/stop
ndo
      IB/IPoIB: Rename qpn to be dqpn in ipoib_send and post_send
functions
      IB/IPoIB: Use defined function for netdev_priv function
      IB/IPoIB: Support acceleration options callbacks

Feras Daoud (2):
      IB/ipoib: Update broadcast object if PKey value was changed in
index 0
      IB/ipoib: Fix deadlock between ipoib_stop and mcast join flow

Ganesh Goudar (1):
      iw_cxgb4: Use dsgl by default

Geert Uytterhoeven (1):
      MAINTAINERS: Add file patterns for infiniband device tree
bindings

Geliang Tang (3):
      IB/i40iw: use setup_timer
      IB/nes: use setup_timer
      IB/qib: use setup_timer

Håkon Bugge (2):
      IB/mlx4: Change flush logic so it adheres to the variable name
      IB/mlx4: Fix incorrect order of formal and actual parameters

Ira Weiny (2):
      IB/hfi: Fix up comments in engine mapping
      IB/hfi: Protect against writable mmap

Jack Morgenstein (3):
      IB/core: Fix sysfs registration error flow
      IB/mlx4: Fix ib device initialization error flow
      IB/mlx4: Reduce SRIOV multicast cleanup warning message to debug
level

Jason Gunthorpe (1):
      IB/vmw_pvrdma: Spare annotate imm_data

Joe Perches (4):
      cxgb3: Use more common logging style
      cxgb3: Convert PDBG to pr_debug
      cxgb4: Use more common logging style
      cxgb4: Convert PDBG to pr_debug

Johannes Thumshirn (1):
      IB/rxe: Don't clamp residual length to mtu

Leon Romanovsky (5):
      IB/mthca: Check validity of output parameter pointer
      Ib/core: Mark local uverbs_std_types functions to be static
      Ib/usnic: Explicitly include usnic headers
      IB/usnic: Simplify the code to balance loc/unlock calls
      IB/nes: Fix incorrect type in assignment

Majd Dibbiny (1):
      IB/mlx4: Support RAW Ethernet when RoCE is disabled

Maor Gottlieb (6):
      IB/mlx4: Take write semaphore when changing the vma struct
      IB/mlx4: Change vma from shared to private
      IB/mlx5: Take write semaphore when changing the vma struct
      IB/mlx5: Change vma from shared to private
      IB/mlx5: Check supported flow table size
      IB/mlx5: Enlarge autogroup flow table

Mark Brown (1):
      IB/hns: Explicitly include linux/of.h

Markus Elfring (6):
      IB/hfi1: Use kcalloc() in hfi1_user_exp_rcv_init()
      IB/hfi1: Use kcalloc() in hfi1_user_sdma_alloc_queues()
      IB/hfi1: Remove intermediate var in hfi1_user_sdma_alloc_queues()
      IB/hfi1: Coding style improvement (make sizeof use safer)
      IB/hns: Use kmalloc_array() in hns_roce_cmd_use_events()
      IB/hns: Use kcalloc() in hns_roce_buddy_init()

Matan Barak (13):
      IB/core: Refactor idr to be per uverbs_file
      IB/core: Add support for idr types
      IB/core: Add idr based standard types
      IB/core: Change idr objects to use the new schema
      IB/core: Add lock to multicast handlers
      IB/core: Add support for fd objects
      IB/core: Change completion channel to use the reworked objects
schema
      IB/core: Rename write flag to exclusive in rdma_core
      IB/core: Don't pass the lock state to _rdma_remove_commit_uobject
      IB/core: Nullify ib_uobject during allocation
      IB/core: A small refactor in destroy WQ handler
      IB/core: Don't use is_async in event files to infer events size
      IB/core: Rename uverbs event file structure

Michael J. Ruhl (9):
      IB/hfi1: Race hazard avoidance in user SDMA driver
      IB/hfi1: Cache registers during state change
      IB/hfi1: Add a patch value to the firmware version string
      IB/hfi1: Ensure VL index is within bounds
      IB/core: If the MGID/MLID pair is not on the list return an error
      IB/hfi1: Correct MulticastMask/CollectiveMask info to SMA output
      IB/core: For multicast functions, verify that LIDs are multicast
LIDs
      IB/rdmavt/hfi1/qib: Use the MGID and MLID for multicast
addressing
      IB/hfi1: Validate the TID count before using it

Michael Mera (1):
      IB/ocrdma: fix out of bounds access to local buffer

Mike Marciniszyn (7):
      IB/rdmavt, IB/hfi1, IB/qib: Make wc opcode translation driver
dependent
      IB/rdmavt: Add additional fields to post send trace
      IB/rdmavt: Add tracing for cq entry and poll
      IB/rdmavt: Add swqe completion trace
      IB/rdmavt: Avoid reseting wqe send_flags in unreserve
      IB/hfi1: Eliminate synchronize_rcu() in mr delete
      IB/hfi1: Prevent kernel QP post send hard lockups

Moni Shoua (2):
      IB/cma: Send MRA for reply messages
      IB/mlx5: Set correct SL in completion for RoCE

Neel Desai (2):
      IB/hfi1: Adjust high temperature warning for QSFP cable
      IB/hfi1: Permanently enable P_Key checking in HFI

Niranjana Vishwanathapura (1):
      IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs

Noa Osherovich (3):
      IB/core: Add HDR speed enum
      IB/mlx5: Set mlx5_query_roce_port's return value to void
      IB/mlx5: Add support for active_width and active_speed in RoCE

Pan Bian (1):
      iw_cxgb4: check return value of alloc_skb

Paolo Abeni (2):
      infiniband: call ipv6 route lookup via the stub interface
      infiniband: avoid dereferencing uninitialized dst on error path

Parav Pandit (4):
      IB/rxe: Avoid accessing timers for non RC QPs
      IB/rxe: Do not export module's private function
      IB/core: Fix kernel crash during fail to initialize device
      IB/mlx5: Support congestion related counters

Petr Mladek (1):
      IB/fmr_pool: Convert the cleanup thread into kthread worker API

Sagi Grimberg (1):
      mlx5: Fix mlx5_ib_map_mr_sg mr length

Sebastian Sanchez (3):
      IB/hfi1: NULL pointer dereference when freeing rhashtable
      IB/rdmavt, IB/hfi1: Fix timer migration regressions
      IB/hfi1: Return SC2VL mappings to FM with VL15 instead of
ILLEGAL_VL

Selvin Xavier (1):
      MAINTAINERS: Update ocrdma module status

Shamir Rabinovitch (1):
      IB/IPoIB: ibX: failed to create mcg debug file

Slava Shwartsman (2):
      IB/core: Introduce drop flow specification
      IB/mlx5: Add drop flow steering rule support

Stuart Summers (1):
      IB/hfi1: Cache neighbor secure data after link up

Tadeusz Struk (3):
      IB/hfi1: Check device id early during init
      IB/hfi1: Protect the global dev_cntr_names and port_cntr_names
      IB/hfi1: Fix softlockup issue

Tim Wright (1):
      IB/mlx5: Add port_xmit_wait to counter registers read

Vishwanathapura, Niranjana (12):
      IB/opa-vnic: Virtual Network Interface Controller (VNIC)
documentation
      IB/opa-vnic: RDMA NETDEV interface
      IB/opa-vnic: Virtual Network Interface Controller (VNIC)
interface
      IB/opa-vnic: Virtual Network Interface Controller (VNIC) netdev
      IB/opa-vnic: VNIC Ethernet Management (EM) structure definitions
      IB/opa-vnic: VNIC statistics support
      IB/opa-vnic: VNIC MAC table support
      IB/opa-vnic: VNIC Ethernet Management Agent (VEMA) interface
      IB/opa-vnic: VNIC Ethernet Management Agent (VEMA) function
      IB/hfi1: OPA_VNIC RDMA netdev support
      IB/hfi1: Virtual Network Interface Controller (VNIC) HW support
      IB/hfi1: VNIC SDMA support

Vlad Tsyrklevich (1):
      infiniband/uverbs: Fix integer overflows

Yonatan Cohen (1):
      IB/rxe: Add port protocol stats

Yuval Shaia (2):
      IB/usnic: Remove unused functions
      {net,IB}/{rxe,usnic}: Utilize generic mac to eui32 function

Zhu Yanjun (1):
      IB/core: change the return type to void

yonatanc (2):
      IB/rxe: Offload CRC calculation when possible
      IB/rxe: Cache dst in QP instead of getting it for each send

 Documentation/infiniband/opa_vnic.txt              |  153 ++
 MAINTAINERS                                        |   16 +-
 drivers/infiniband/Kconfig                         |    1 +
 drivers/infiniband/core/Makefile                   |    3 +-
 drivers/infiniband/core/addr.c                     |    6 +-
 drivers/infiniband/core/agent.c                    |    4 +-
 drivers/infiniband/core/cm.c                       |  119 +-
 drivers/infiniband/core/cma.c                      |  132 +-
 drivers/infiniband/core/device.c                   |   33 +-
 drivers/infiniband/core/fmr_pool.c                 |   49 +-
 drivers/infiniband/core/mad.c                      |   28 +-
 drivers/infiniband/core/mad_rmpp.c                 |   16 +-
 drivers/infiniband/core/multicast.c                |   27 +-
 drivers/infiniband/core/rdma_core.c                |  627 ++++++++
 drivers/infiniband/core/rdma_core.h                |   78 +
 drivers/infiniband/core/sa_query.c                 |  886 ++++++++---
 drivers/infiniband/core/sysfs.c                    |    6 +-
 drivers/infiniband/core/ucm.c                      |    6 +-
 drivers/infiniband/core/ucma.c                     |   24 +-
 drivers/infiniband/core/umem.c                     |   17 +-
 drivers/infiniband/core/umem_odp.c                 |   81 +-
 drivers/infiniband/core/user_mad.c                 |   44 +-
 drivers/infiniband/core/uverbs.h                   |   69 +-
 drivers/infiniband/core/uverbs_cmd.c               | 1582 ++++++----
----------
 drivers/infiniband/core/uverbs_main.c              |  508 +++----
 drivers/infiniband/core/uverbs_marshall.c          |   81 +-
 drivers/infiniband/core/uverbs_std_types.c         |  275 ++++
 drivers/infiniband/core/verbs.c                    |   86 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  118 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |    6 +-
 drivers/infiniband/hw/cxgb3/cxio_dbg.c             |   35 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |  201 ++-
 drivers/infiniband/hw/cxgb3/cxio_hal.h             |    7 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c        |   25 +-
 drivers/infiniband/hw/cxgb3/iwch.c                 |   19 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |  269 ++--
 drivers/infiniband/hw/cxgb3/iwch_cm.h              |   18 +-
 drivers/infiniband/hw/cxgb3/iwch_cq.c              |   21 +-
 drivers/infiniband/hw/cxgb3/iwch_ev.c              |   26 +-
 drivers/infiniband/hw/cxgb3/iwch_mem.c             |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  118 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h        |    9 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |   67 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  393 ++---
 drivers/infiniband/hw/cxgb4/cq.c                   |   79 +-
 drivers/infiniband/hw/cxgb4/device.c               |  141 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |   39 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   48 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   44 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   44 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |   96 +-
 drivers/infiniband/hw/cxgb4/resource.c             |   64 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |   24 +-
 drivers/infiniband/hw/hfi1/Makefile                |    2 +-
 drivers/infiniband/hw/hfi1/aspm.h                  |   15 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  590 ++++++--
 drivers/infiniband/hw/hfi1/chip.h                  |   20 +-
 drivers/infiniband/hw/hfi1/common.h                |   15 +-
 drivers/infiniband/hw/hfi1/debugfs.c               |  238 ++-
 drivers/infiniband/hw/hfi1/debugfs.h               |   62 +-
 drivers/infiniband/hw/hfi1/driver.c                |  128 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   31 +-
 drivers/infiniband/hw/hfi1/firmware.c              |   14 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   95 +-
 drivers/infiniband/hw/hfi1/init.c                  |   69 +-
 drivers/infiniband/hw/hfi1/intr.c                  |   27 +-
 drivers/infiniband/hw/hfi1/mad.c                   |   95 +-
 drivers/infiniband/hw/hfi1/pcie.c                  |    2 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   19 +-
 drivers/infiniband/hw/hfi1/pio.h                   |   34 +-
 drivers/infiniband/hw/hfi1/qp.c                    |   12 +-
 drivers/infiniband/hw/hfi1/rc.c                    |   55 +-
 drivers/infiniband/hw/hfi1/ruc.c                   |  137 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   43 +-
 drivers/infiniband/hw/hfi1/sdma.h                  |   46 +-
 drivers/infiniband/hw/hfi1/sysfs.c                 |    4 +-
 drivers/infiniband/hw/hfi1/trace.c                 |    5 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h          |    8 +-
 drivers/infiniband/hw/hfi1/trace_misc.h            |   48 +
 drivers/infiniband/hw/hfi1/trace_rc.h              |    7 +-
 drivers/infiniband/hw/hfi1/trace_tx.h              |   43 +
 drivers/infiniband/hw/hfi1/uc.c                    |   14 +-
 drivers/infiniband/hw/hfi1/ud.c                    |   73 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |   16 +-
 drivers/infiniband/hw/hfi1/user_pages.c            |    5 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   22 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |  153 +-
 drivers/infiniband/hw/hfi1/verbs.h                 |   15 +-
 drivers/infiniband/hw/hfi1/vnic.h                  |  184 +++
 drivers/infiniband/hw/hfi1/vnic_main.c             |  907 +++++++++++
 drivers/infiniband/hw/hfi1/vnic_sdma.c             |  323 ++++
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   62 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |    6 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |    3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |    5 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  119 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   20 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |    3 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |    5 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |   10 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   12 +-
 drivers/infiniband/hw/mlx4/ah.c                    |  134 +-
 drivers/infiniband/hw/mlx4/cm.c                    |   10 +-
 drivers/infiniband/hw/mlx4/cq.c                    |    2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   87 +-
 drivers/infiniband/hw/mlx4/main.c                  |   33 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |   11 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    6 +-
 drivers/infiniband/hw/mlx4/mr.c                    |    6 +-
 drivers/infiniband/hw/mlx4/qp.c                    |  112 +-
 drivers/infiniband/hw/mlx4/srq.c                   |    2 +-
 drivers/infiniband/hw/mlx5/ah.c                    |   74 +-
 drivers/infiniband/hw/mlx5/cmd.c                   |   11 +
 drivers/infiniband/hw/mlx5/cmd.h                   |    2 +
 drivers/infiniband/hw/mlx5/cq.c                    |   21 +-
 drivers/infiniband/hw/mlx5/mad.c                   |    2 +
 drivers/infiniband/hw/mlx5/main.c                  |  397 +++--
 drivers/infiniband/hw/mlx5/mem.c                   |   13 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   12 +-
 drivers/infiniband/hw/mlx5/mr.c                    |    8 +-
 drivers/infiniband/hw/mlx5/odp.c                   |  344 +++--
 drivers/infiniband/hw/mlx5/qp.c                    |  107 +-
 drivers/infiniband/hw/mthca/mthca_av.c             |   69 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c            |   12 +-
 drivers/infiniband/hw/mthca/mthca_dev.h            |    4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c            |   17 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |    7 +-
 drivers/infiniband/hw/mthca/mthca_qp.c             |   94 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    7 +-
 drivers/infiniband/hw/nes/nes_mgt.c                |    5 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   12 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h              |    6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   64 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h           |   10 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   23 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   54 +-
 drivers/infiniband/hw/qedr/main.c                  |   88 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   20 +-
 drivers/infiniband/hw/qedr/qedr_cm.c               |   19 +-
 drivers/infiniband/hw/qedr/qedr_cm.h               |    2 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  240 ++-
 drivers/infiniband/hw/qedr/verbs.h                 |    2 +-
 drivers/infiniband/hw/qib/qib_iba6120.c            |   10 +-
 drivers/infiniband/hw/qib/qib_iba7220.c            |    5 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   10 +-
 drivers/infiniband/hw/qib/qib_init.c               |   15 +-
 drivers/infiniband/hw/qib/qib_mad.c                |    7 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |   31 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |   77 +-
 drivers/infiniband/hw/qib/qib_uc.c                 |    6 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |   57 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   37 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |    4 +-
 drivers/infiniband/hw/usnic/usnic_common_util.h    |   38 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |    1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   48 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |    2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |    8 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c     |   43 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |    8 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |   30 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |    2 +-
 drivers/infiniband/sw/rdmavt/ah.c                  |   39 +-
 drivers/infiniband/sw/rdmavt/ah.h                  |    6 +-
 drivers/infiniband/sw/rdmavt/cq.c                  |    3 +
 drivers/infiniband/sw/rdmavt/mad.c                 |    2 +-
 drivers/infiniband/sw/rdmavt/mcast.c               |   61 +-
 drivers/infiniband/sw/rdmavt/mr.c                  |   57 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   44 +-
 drivers/infiniband/sw/rdmavt/trace.h               |    4 +-
 drivers/infiniband/sw/rdmavt/trace_cq.h            |  127 ++
 drivers/infiniband/sw/rdmavt/trace_rc.h            |  109 ++
 drivers/infiniband/sw/rdmavt/trace_tx.h            |   34 +-
 drivers/infiniband/sw/rxe/Kconfig                  |    1 +
 drivers/infiniband/sw/rxe/Makefile                 |    3 +-
 drivers/infiniband/sw/rxe/rxe.c                    |    6 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   20 +
 drivers/infiniband/sw/rxe/rxe_av.c                 |   32 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   14 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c        |   78 +
 drivers/infiniband/sw/rxe/rxe_hw_counters.h        |   61 +
 drivers/infiniband/sw/rxe/rxe_icrc.c               |    6 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   12 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |   14 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   83 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   33 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |    7 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |    4 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |    7 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   33 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |    9 +
 drivers/infiniband/ulp/Makefile                    |    1 +
 drivers/infiniband/ulp/ipoib/ipoib.h               |   44 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   73 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c            |   13 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  364 ++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  456 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  120 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   13 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   64 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   12 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |    2 +-
 drivers/infiniband/ulp/opa_vnic/Kconfig            |    8 +
 drivers/infiniband/ulp/opa_vnic/Makefile           |    7 +
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |  475 ++++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h   |  489 ++++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c |  187 +++
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |  329 ++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |  389 +++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    | 1056
+++++++++++++
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |  390 +++++
 drivers/infiniband/ulp/srp/ib_srp.c                |   13 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    4 +-
 include/linux/mlx4/device.h                        |    3 +-
 include/linux/mlx5/mlx5_ifc.h                      |   28 +-
 include/net/addrconf.h                             |   22 +-
 include/rdma/ib_cm.h                               |   14 +-
 include/rdma/ib_hdrs.h                             |   66 +
 include/rdma/ib_mad.h                              |   40 +-
 include/rdma/ib_marshall.h                         |    6 +-
 include/rdma/ib_pack.h                             |    2 +
 include/rdma/ib_sa.h                               |  304 +++-
 include/rdma/ib_umem.h                             |    8 +-
 include/rdma/ib_umem_odp.h                         |    6 +-
 include/rdma/ib_verbs.h                            |  325 +++-
 include/rdma/opa_addr.h                            |   79 +
 include/rdma/opa_port_info.h                       |    3 +-
 include/rdma/opa_vnic.h                            |  141 ++
 include/rdma/rdma_cm.h                             |    4 +-
 include/rdma/rdma_cm_ib.h                          |    2 +-
 include/rdma/rdma_vt.h                             |   11 +-
 include/rdma/rdmavt_qp.h                           |   18 +-
 include/rdma/uverbs_std_types.h                    |  114 ++
 include/rdma/uverbs_types.h                        |  172 +++
 include/uapi/linux/pci_regs.h                      |    1 +
 include/uapi/rdma/ib_user_verbs.h                  |   11 +
 include/uapi/rdma/vmw_pvrdma-abi.h                 |    4 +-
 net/smc/smc_ib.c                                   |   11 +-
 242 files changed, 14599 insertions(+), 5505 deletions(-)
 create mode 100644 Documentation/infiniband/opa_vnic.txt
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 drivers/infiniband/core/uverbs_std_types.c
 create mode 100644 drivers/infiniband/hw/hfi1/vnic.h
 create mode 100644 drivers/infiniband/hw/hfi1/vnic_main.c
 create mode 100644 drivers/infiniband/hw/hfi1/vnic_sdma.c
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_cq.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_rc.h
 create mode 100644 drivers/infiniband/sw/rxe/rxe_hw_counters.c
 create mode 100644 drivers/infiniband/sw/rxe/rxe_hw_counters.h
 create mode 100644 drivers/infiniband/ulp/opa_vnic/Kconfig
 create mode 100644 drivers/infiniband/ulp/opa_vnic/Makefile
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
 create mode 100644
drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
 create mode 100644 include/rdma/opa_addr.h
 create mode 100644 include/rdma/opa_vnic.h
 create mode 100644 include/rdma/uverbs_std_types.h
 create mode 100644 include/rdma/uverbs_types.h

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
