From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 6 Jun 2018 15:42:59 -0600
Message-ID: <20180606214259.GA15120@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are the RDMA patches for 4.18.

No merge conflicts this time, and as of this writing netdev's pull request =
has
not been merged so the merge diffstat shows a number of ethernet related fi=
les
=66rom the various shared pull requests in the two trees.

There are a few more merge commits in this history than has been typical in
the past. Instead of choosing the net or RDMA tree to get certain patches,
Mellanox is now providing a 'shared branch' which is intended to carry all
commits to drivers/net/ethernet/mellanox/mlx5/core and is used to merge tho=
se
patches into both the net and rdma trees. This is expected to reduce the me=
rge
conflicts by ensuring both trees have all commits related to mlx5/core and
related, and no rdma or netdev commit is left only in the others tree.

The following changes since commit 55ba49cbcef37053d973f9a45bc58818c333fe13:

  RDMA/hns: Move the location for initializing tmp_len (2018-05-23 15:45:44=
 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to c1191a19fecad92b73c25770a7f47174280ca564:

  RDMA/mlx5: Update SPDX tags to show proper license (2018-06-05 14:04:20 -=
0600)

----------------------------------------------------------------
4.18 Merge window pull request

This has been a quiet cycle for RDMA, the big bulk is the usual smallish
driver updates and bug fixes. About four new uAPI related things. Not as mu=
ch
Szykaller patches this time, the bugs it finds are getting harder to fix.

- More work cleaning up the RDMA CM code
- Usual driver bug fixes and cleanups for qedr, qib, hfi1, hns, i40iw, iw_c=
xgb4, mlx5, rxe
- Driver specific resource tracking and reporting via netlink
- Continued work for name space support from Parav
- MPLS support for the verbs flow steering uAPI
- A few tricky IPoIB fixes improving robustness
- HFI1 driver support for the '16B' management packet format
- Some auditing to not print kernel pointers via %llx or similar
- Mark the entire 'UCM' user-space interface as BROKEN with the intent to r=
emove it
  entirely. The user space side of this was long ago replaced with RDMA-CM =
and
  syzkaller is finding bugs in the residual UCM interface nobody wishes to =
fix because
  nobody uses it.
- Purge more bogus BUG_ON's from Leon
- 'flow counters' verbs uAPI
- T10 fixups for iser/isert, these are Acked by Martin but going through th=
e RDMA
  tree due to dependencies

----------------------------------------------------------------
Alex Estrin (3):
      IB/hfi1: Complete check for locally terminated smp
      IB/{hfi1, qib}: Add handling of kernel restart
      IB/isert: Fix for lib/dma_debug check_sync warning

Ariel Levkovich (7):
      IB/uverbs: Expose GRE flow spec to the user-kernel ABI header
      IB/uverbs: Introduce a GRE steering match filter
      IB/uverbs: Expose MPLS flow spec to the user-kernel ABI header
      IB/uverbs: Introduce a MPLS steering match filter
      IB/mlx5: Add support for GRE flow specification
      IB/mlx5: Add support for MPLS flow specification
      IB/mlx5: Expose MPLS related tunneling offloads

Arnd Bergmann (1):
      iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency

Ben Hutchings (1):
      IB: Fix RDMA_RXE and INFINIBAND_RDMAVT dependencies for DMA_VIRT_OPS

Brian Welty (1):
      IB/{hfi1, qib, rdmavt}: Move logic to allocate receive WQE into rdmavt

Christophe JAILLET (3):
      net/mlx5: Vport, Use 'kvfree()' for memory allocated by 'kvzalloc()'
      net/mlx5: Eswitch, Use 'kvfree()' for memory allocated by 'kvzalloc()'
      IB/mlx5: Use 'kvfree()' for memory allocated by 'kvzalloc()'

Colin Ian King (4):
      net/mlx5: remove some extraneous spaces in indentations
      RDMA/qedr: fix spelling mistake: "failes" -> "fails"
      net/mlx5: fix spelling mistake: "modfiy" -> "modify"
      RDMA/qedr: fix spelling mistake: "adrresses" -> "addresses"

Cong Wang (1):
      infiniband: fix a possible use-after-free bug

Don Hiatt (3):
      IB/hfi1: Define 16B Management Packets
      IB/hfi1: Add support for 16B Management Packets
      IB/hfi1: Add 16B Management Packet trace support

Doug Ledford (7):
      Merge branch 'k.o/for-rc' into k.o/wip/dl-for-next
      Merge tag 'mlx5-updates-2018-05-07' of git://git.kernel.org/.../mella=
nox/linux into k.o/wip/dl-for-next
      RDMA/hfi1: Fix build error with debugfs disabled
      RDMA/uapi: Fix uapi breakage
      RDMA/ipoib: Update paths on CLIENT_REREG/SM_CHANGE events
      Merge branch 'wip/dl-ipoib' into wip/dl-for-next
      RDMA/hns_roce: Don't check return value of zap_vma_ptes()

Erez Shitrit (1):
      IB/mlx5: Fetch soft WQE's on fatal error state

Evgenii Smirnov (1):
      RDMA/ipoib: drop skb on path record lookup failure

Idan Burstein (1):
      IB/mlx5: posting klm/mtt list inline in the send queue for reg_wr

Jack Morgenstein (2):
      IB/core: Make testing MR flags for writability a static inline functi=
on
      IB/mlx4: Mark user MR as writable if actual virtual memory is writable

Jason Gunthorpe (8):
      RDMA/rdma_cm: Remove process_req and timer sorting
      RDMA/rdma_cm: Make rdma_addr_cancel into a fence
      RDMA/rdma_cm: Delete rdma_addr_client
      Merge tag 'mlx5-updates-2018-05-17' of git://git.kernel.org/.../mella=
nox/linux into for-next
      Merge branch 'mr_fix' into git://git.kernel.org/.../rdma/rdma for-next
      RDMA/core: Remove indirection through ib_cache_setup()
      Merge branch 'mini_cqe' into git://git.kernel.org/.../rdma/rdma for-n=
ext
      Merge tag 'verbs_flow_counters' of git://git.kernel.org/.../leon/linu=
x-rdma.git into for-next

Jia-Ju Bai (3):
      infiniband: i40iw: Replace GFP_ATOMIC with GFP_KERNEL in i40iw_add_mq=
h_4
      infiniband: i40iw: Replace GFP_ATOMIC with GFP_KERNEL in i40iw_make_l=
isten_node
      infiniband: i40iw: Replace GFP_ATOMIC with GFP_KERNEL in i40iw_l2para=
m_change

Kaike Wan (3):
      IB/hfi1: Ensure VL index is within bounds
      IB/hfi1: Remove unused variable
      IB/hfi1: Rename exp_lock to exp_mutex

Kamenee Arumugam (1):
      IB/Hfi1: Read CCE Revision register to verify the device is responsive

Leon Romanovsky (16):
      net/mlx5: Decrease level of prints about non-existent MKEY
      RDMA/hns: Drop local zgid in favor of core defined variable
      RDMA/mlx5: Remove debug prints of VMA pointers
      RDMA/ucm: Mark UCM interface as BROKEN
      RDMA/mlx4: Catch FW<->SW misalignment without machine crash
      RDMA/mlx4: Discard unknown SQP work requests
      RDMA/cxgb3: Don't crash kernel just because IDR is full
      RDMA/cm: Abort loop in case of CM dequeue
      RDMA/cma: Ignore unknown event
      RDMA/mad: Delete inaccessible BUG_ON
      RDMA/mad: Convert BUG_ONs to error flows
      RDMA/mlx5: Don't check return value of zap_vma_ptes()
      RDMA/mlx4: Don't crash machine if zap_vma_ptes() fails
      mm: Remove return value of zap_vma_ptes()
      RDMA/restrack: Change SPDX tag to properly reflect license
      RDMA/mlx5: Update SPDX tags to show proper license

Matan Barak (2):
      IB/uverbs: Add an ib_uobject getter to ioctl() infrastructure
      IB/core: Support passing uhw for create_flow

Max Gurtovoy (4):
      IB/isert: fix T10-pi check mask setting
      RDMA/core: introduce check masks for T10-PI offload
      IB/iser: use T10-PI check mask definitions from core layer
      IB/isert: use T10-PI check mask definitions from core layer

Michael J. Ruhl (4):
      IB/hfi1: Return actual error value from program_rcvarray()
      IB/hfi1: Return correct value for device state
      IB/hfi1: Reorder incorrect send context disable
      IB/hfi1: Set port number for errorinfo MAD response

Mike Marciniszyn (7):
      IB/hfi1: Fix fault injection init/exit issues
      IB/hfi1: Cleanup of exp_rcv
      IB/{rdmavt,hfi1}: Change hrtimer add to use pinned version
      IB/qib: Fix DMA api warning with debug kernel
      IB/hfi1: Fix user context tail allocation for DMA_RTAIL
      IB/hfi1: Add bypass register defines and replace blind constants
      IB/hfi1: Fix comment on default hdr entry size

Mitko Haralanov (1):
      IB/hfi1: Rework fault injection machinery

Moshe Shemesh (2):
      net/mlx5: Refactor num of blocks in mailbox calculation
      net/mlx5: Fix dump_command mailbox length printed

Or Gerlitz (1):
      net/mlx5: Use flow counter pointer as input to the query function

Parav Pandit (9):
      IB/core: Use CONFIG_SECURITY_INFINIBAND to compile out security code
      IB/core: Make gid_table_reserve_default() return void
      IB/core: Reuse gid_table_release_one() in table allocation failure
      IB/cm: Avoid AV ah_attr overwriting during LAP message handling
      IB/cm: Store and restore ah_attr during LAP msg processing
      IB/cm: Store and restore ah_attr during CM message processing
      IB/core: Remove duplicate declaration of gid_cache_wq
      IB/core: Reduce the places that use zgid
      IB/core: Introduce and use rdma_gid_table()

Rabie Loulou (1):
      net/mlx5e: Explicitly set destination e-switch in FDB rules

Raed Salem (11):
      net/mlx5: Export flow counter related API
      IB/core: Introduce counters object and its create/destroy
      IB/uverbs: Add create/destroy counters support
      IB/core: Introduce counters read verb
      IB/uverbs: Add read counters support
      IB/core: Add support for flow counters
      IB/uverbs: Add support for flow counters
      IB/mlx5: Add counters create and destroy support
      IB/mlx5: Add flow counters binding support
      IB/mlx5: Add flow counters read support
      IB/mlx5: Add counters read support

Roi Dayan (1):
      net/mlx5: Add merged e-switch cap

Sebastian Andrzej Siewior (1):
      IB/ipoib: replace local_irq_disable() with proper locking

Sebastian Sanchez (4):
      IB/hfi1: Prevent LNI hang when LCB can't obtain lanes
      IB/hfi1: Optimize kthread pointer locking when queuing CQ entries
      IB/hfi1: Create common functions for affinity CPU mask operations
      IB/{hfi1, rdmavt, qib}: Implement CQ completion vector support

Sergey Gorenko (1):
      IB/iser: Do not reduce max_sectors

Shahar Klein (4):
      net/mlx5: Properly handle a vport destination when setting FTE
      net/mlx5: Add destination e-switch owner
      net/mlx5: Add source e-switch owner
      net/mlx5e: Explicitly set source e-switch in offloaded TC rules

Shiraz Saleem (1):
      i40iw: Extend port reuse support for listeners

Souptick Joarder (2):
      infiniband: hw: hfi1: Change return type to vm_fault_t
      infiniband: hw: qib: Change return type to vm_fault_t

Steve Wise (12):
      RDMA/nldev: Add explicit pad attribute
      RDMA/nldev: add driver-specific resource tracking
      RDMA/nldev: helper functions to add driver attributes
      iw_cxgb4: dump detailed driver-specific QP information
      iw_cxgb4: fix uninitialized variable warnings
      RDMA/NLDEV: remove mr iova attribute
      iw_cxgb4: remove wr_id attributes
      iw_cxgb4: always set iw_cm_id.provider_data
      RDMA/CMA: add rdma_iw_cm_id() and rdma_res_to_id() helpers
      iw_cxgb4: provide detailed provider-specific CM_ID information
      iw_cxgb4: provide detailed driver-specific CQ information
      iw_cxgb4: provide detailed driver-specific MR information

Tariq Toukan (1):
      net/mlx5: Cleanup unused field in Work Queue parameters

Wei Hu(Xavier) (6):
      RDMA/hns: Modify uar allocation algorithm to avoid bitmap exhaust
      RDMA/hns: Increase checking CMQ status timeout value
      RDMA/hns: Add reset process for RoCE in hip08
      RDMA/hns: Fix the illegal memory operation when cross page
      RDMA/uverbs: Hoist the common process of disassociate_ucontext into i=
b core
      RDMA/hns: Implement the disassociate_ucontext API

Yixian Liu (1):
      RDMA/hns: Add 64KB page size support for hip08

Yonatan Cohen (3):
      net/mlx5: Exposing a new mini-CQE format
      IB/mlx5: Refactor CQE compression response
      IB/mlx5: Introduce a new mini-CQE format

YueHaibing (2):
      IB/cxgb4: use skb_put_zero()/__skb_put_zero
      IB/hns: Use zeroing memory allocator instead of allocator/memset

Yuval Shaia (2):
      IB/rxe: Change rxe_rcv to return void
      IB/core: Remove redundant return

Zhu Yanjun (9):
      IB/rxe: make the variable static
      IB/rxe: avoid export symbols
      IB/rxe: make rxe_release_udp_tunnel static
      IB/rxe: optimize the function duplicate_request
      IB/rxe: replace refcount_inc with skb_get
      IB/rxe: change rxe_set_mtu function type to void
      IB/rxe: remove unused function variable
      IB/rxe: avoid calling WARN_ON_ONCE twice
      IB/rxe: avoid unnecessary export

oulijun (1):
      RDMA/hns: Rename the idx field of db

 drivers/infiniband/Kconfig                         |  11 +
 drivers/infiniband/core/Makefile                   |   9 +-
 drivers/infiniband/core/addr.c                     | 172 +++----
 drivers/infiniband/core/cache.c                    | 112 ++---
 drivers/infiniband/core/cm.c                       |  62 ++-
 drivers/infiniband/core/cma.c                      |  36 +-
 drivers/infiniband/core/core_priv.h                |   3 -
 drivers/infiniband/core/device.c                   |   4 +-
 drivers/infiniband/core/mad.c                      |  12 +-
 drivers/infiniband/core/nldev.c                    | 122 ++++-
 drivers/infiniband/core/restrack.c                 |   9 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |   2 -
 drivers/infiniband/core/security.c                 |   4 -
 drivers/infiniband/core/ucma.c                     |   6 +-
 drivers/infiniband/core/umem.c                     |  13 +-
 drivers/infiniband/core/uverbs.h                   |   2 +
 drivers/infiniband/core/uverbs_cmd.c               | 111 ++++-
 drivers/infiniband/core/uverbs_main.c              |  42 +-
 drivers/infiniband/core/uverbs_std_types.c         |   3 +-
 .../infiniband/core/uverbs_std_types_counters.c    | 157 +++++++
 drivers/infiniband/core/uverbs_std_types_cq.c      |  23 +-
 .../infiniband/core/uverbs_std_types_flow_action.c |   4 +-
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/cxgb3/iwch.h                 |   1 -
 drivers/infiniband/hw/cxgb4/Kconfig                |   1 +
 drivers/infiniband/hw/cxgb4/Makefile               |   3 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   1 +
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   5 +
 drivers/infiniband/hw/cxgb4/provider.c             |   8 +
 drivers/infiniband/hw/cxgb4/qp.c                   |   9 +-
 drivers/infiniband/hw/cxgb4/restrack.c             | 501 +++++++++++++++++=
+++
 drivers/infiniband/hw/hfi1/Makefile                |  10 +-
 drivers/infiniband/hw/hfi1/affinity.c              | 497 +++++++++++++++++=
+--
 drivers/infiniband/hw/hfi1/affinity.h              |  10 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  82 ++--
 drivers/infiniband/hw/hfi1/chip.h                  |  15 +-
 drivers/infiniband/hw/hfi1/chip_registers.h        |  13 +-
 drivers/infiniband/hw/hfi1/debugfs.c               | 292 +-----------
 drivers/infiniband/hw/hfi1/debugfs.h               | 102 ++--
 drivers/infiniband/hw/hfi1/driver.c                |  53 ++-
 drivers/infiniband/hw/hfi1/exp_rcv.c               |  39 +-
 drivers/infiniband/hw/hfi1/exp_rcv.h               |  24 +-
 drivers/infiniband/hw/hfi1/fault.c                 | 375 +++++++++++++++
 drivers/infiniband/hw/hfi1/fault.h                 | 109 +++++
 drivers/infiniband/hw/hfi1/file_ops.c              |   8 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |  61 ++-
 drivers/infiniband/hw/hfi1/init.c                  |  47 +-
 drivers/infiniband/hw/hfi1/mad.c                   |  37 +-
 drivers/infiniband/hw/hfi1/pcie.c                  |   8 +
 drivers/infiniband/hw/hfi1/pio.c                   |  44 +-
 drivers/infiniband/hw/hfi1/rc.c                    |  10 +-
 drivers/infiniband/hw/hfi1/ruc.c                   | 154 +------
 drivers/infiniband/hw/hfi1/sdma.c                  |  12 +-
 drivers/infiniband/hw/hfi1/trace.c                 |  43 +-
 drivers/infiniband/hw/hfi1/trace_dbg.h             |   3 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h          | 160 ++++---
 drivers/infiniband/hw/hfi1/uc.c                    |   4 +-
 drivers/infiniband/hw/hfi1/ud.c                    |  61 ++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |  11 +-
 drivers/infiniband/hw/hfi1/user_sdma.h             |   4 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |  45 +-
 drivers/infiniband/hw/hfi1/verbs.h                 |  15 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   8 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |   3 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |  14 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 188 ++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   7 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |  76 ++-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   6 -
 drivers/infiniband/hw/hns/hns_roce_pd.c            |  10 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |  67 ++-
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |  34 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   1 -
 drivers/infiniband/hw/mlx4/main.c                  |  60 +--
 drivers/infiniband/hw/mlx4/mr.c                    |  50 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   2 +-
 drivers/infiniband/hw/mlx5/cq.c                    |  59 ++-
 drivers/infiniband/hw/mlx5/ib_rep.c                |   2 +-
 drivers/infiniband/hw/mlx5/ib_rep.h                |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  | 511 +++++++++++++++++=
+---
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  36 ++
 drivers/infiniband/hw/mlx5/qp.c                    |  43 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   4 +-
 drivers/infiniband/hw/qib/qib.h                    |   4 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |  12 +-
 drivers/infiniband/hw/qib/qib_init.c               |  13 +
 drivers/infiniband/hw/qib/qib_rc.c                 |   8 +-
 drivers/infiniband/hw/qib/qib_ruc.c                | 154 +------
 drivers/infiniband/hw/qib/qib_uc.c                 |   4 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |   4 +-
 drivers/infiniband/hw/qib/qib_user_pages.c         |  20 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   6 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |   2 -
 drivers/infiniband/sw/rdmavt/Kconfig               |   2 +-
 drivers/infiniband/sw/rdmavt/cq.c                  |  74 ++-
 drivers/infiniband/sw/rdmavt/cq.h                  |   6 +-
 drivers/infiniband/sw/rdmavt/qp.c                  | 151 +++++-
 drivers/infiniband/sw/rdmavt/trace_cq.h            |  35 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |  35 +-
 drivers/infiniband/sw/rxe/Kconfig                  |   1 +
 drivers/infiniband/sw/rxe/rxe.c                    |  11 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   4 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |  10 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |  13 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  13 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  18 +-
 drivers/infiniband/sw/rxe/rxe_net.h                |   3 -
 drivers/infiniband/sw/rxe/rxe_recv.c               |   7 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  20 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  93 ++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  15 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  12 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   6 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   2 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |   4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  21 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  28 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |   1 -
 include/linux/mlx5/device.h                        |  12 +
 include/linux/mlx5/fs.h                            |  10 +-
 include/linux/mlx5/mlx5_ifc.h                      |  66 ++-
 include/linux/mm.h                                 |   8 +-
 include/rdma/ib_addr.h                             |  20 +-
 include/rdma/ib_cache.h                            |   1 +
 include/rdma/ib_verbs.h                            | 102 +++-
 include/rdma/rdma_cm.h                             |   3 +
 include/rdma/rdma_vt.h                             |   7 +-
 include/rdma/rdmavt_cq.h                           |   5 +-
 include/rdma/rdmavt_qp.h                           |   1 +
 include/rdma/restrack.h                            |  22 +-
 include/rdma/uverbs_ioctl.h                        |  11 +
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  21 +
 include/uapi/rdma/ib_user_verbs.h                  |  63 +++
 include/uapi/rdma/mlx5-abi.h                       |  30 +-
 include/uapi/rdma/rdma_netlink.h                   |  30 +-
 mm/memory.c                                        |   7 +-
 156 files changed, 4560 insertions(+), 1827 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_counters.c
 create mode 100644 drivers/infiniband/hw/cxgb4/restrack.c
 create mode 100644 drivers/infiniband/hw/hfi1/fault.c
 create mode 100644 drivers/infiniband/hw/hfi1/fault.h

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJbGFVgAAoJEDht9xV+IJsaFwUQAI+2HnX9pA5vlWknVPmpqy0X
LY3rJYMHAc84KaTW4bJ0oDiBRhSTfAGay6obmsVJY61nLzRKGW3BWLPt9AVt1bTd
3z94naoWG57/kemcMibjqCCns+EWB2ldWsAQGBmRwiLSaOwAxZycGHaeNw8YBRM/
S1pkZqAebQ98/wQAWm4EBGGxPH8xmG0v5vaud36mHvGqVR+ppOQlma18UHkc0lb4
1syudfXwEojSvBYCdvt/OLFoxnnCDVnUkBL6RcE3Iv2oWue3jnlzaszw1oJ9jYXw
b63fZHB0oQstFr3jg+f362PtfIXtb341PkpmEIKqe1DQia1WnnX3BdfB+3WqxweO
nql5KwHFz0WaOHwlkfUokmgLggcci7bFSVX15e7cHCDYv9Ub2S1qa29UvaHuaf1g
zitTJhjjIgFK0h5FHSSnAYvp4hc7ij7/OQYEBdzzKWMNsDVYQFts3AB7L0YOhyh7
KQIup1v3oo8I0sWtInM3A8ot70i4gVmMDqhBElZRPuh61/BQZCKxD340ZdY4d2gH
+B/cRk1Wr8L7rXU5iHYp1dqbdoXyxKObpMcTTeZN2rZAoVWRBnpSDxqBzMnIlbp1
JNHNAt6pKzrR8Gh1B8+HZn4G0k9hGaW3poowmiqZeHNhZqVKM97Gx7HAqcayBgQj
J7uMB6I3Xu8jv0HOQSMp
=Wiug
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
