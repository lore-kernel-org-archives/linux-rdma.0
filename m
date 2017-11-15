From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 15 Nov 2017 11:01:13 -0500
Message-ID: <1510761673.9947.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0OkcGlNyEEZo0PJvMsOa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0OkcGlNyEEZo0PJvMsOa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is a fairly plain pull request.  Lots of driver updates across the
stack, a huge number of static analysis cleanups including a close to 50
patch series from Bart Van Assche, and a number of new features inside
the stack such as general CQ moderation support.

Nothing really stands out, but there might be a few conflicts as you
take things in.  In particular, the cleanups touched some of the same
lines as the new timer_setup changes.

Everything in this pull request has been through 0day and at least 2
days of linux-next (since Stephen doesn't necessarily flag new
errors/warnings until day2).  A few more items (about 30 patches) from
Intel and Mellanox showed up on the list on Tuesday.  I've excluded
those from this pull request, and I'm sure some of them qualify as fixes
suitable to send any time, but I still have to review them fully.  If
they contain mostly fixes and little or no new development, then I will
probably send them through by the end of the week just to get them out
of the way.

There was a break in my acceptance of patches which coincides with the
computer problems I had, and then when I got things mostly back under
control I had a backlog of patches to process, which I did mostly last
Friday and Monday.  So there is a larger number of patches processed in
that timeframe than I was striving for.

There is a section of this pull request that patches files in the
drivers/net directory.  These come from the shared pull request that
both Dave and I took from Mellanox this cycle.  If you pull Dave's tree
first, those will drop out, or vice versa if you take mine first.  I did
not pull Dave's net-next this cycle, so it should be OK to take my tree
first.

Here's the boilerplate:
The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f=
:

  Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-=
linus

for you to fetch changes up to 4190b4e96954e2c3597021d29435c3f8db8d3129:

  RDMA/core: Rename kernel modify_cq to better describe its usage (2017-11-=
13 16:59:22 -0500)

----------------------------------------------------------------
Updates for 4.15 kernel merge window

- Add iWARP support to qedr driver
- Lots of misc fixes across subsystem
- Multiple update series to hns roce driver
- Multiple update series to hfi1 driver
- Updates to vnic driver
- Add kref to wait struct in cxgb4 driver
- Updates to i40iw driver
- Mellanox shared pull request
- timer_setup changes
- massive cleanup series from Bart Van Assche
- Two series of SRP/SRPT changes from Bart Van Assche
- Core updates from Mellanox
- i40iw updates
- IPoIB updates
- mlx5 updates
- mlx4 updates
- hns updates
- bnxt_re fixes
- PCI write padding support
- Sparse/Smatch/warning cleanups/fixes
- CQ moderation support
- SRQ support in vmw_pvrdma

----------------------------------------------------------------
Ajaykumar Hotchandani (1):
      IB/{ipoib, iser}: Consistent print format of vendor error

Alex Estrin (1):
      IB/rdmavt: Don't wait for resources in QP reset

Alex Vesker (10):
      net/mlx5e: IPoIB, Move underlay QP init/uninit to separate functions
      net/mlx5: Support for attaching multiple underlay QPs to root flow ta=
ble
      IB/ipoib: Grab rtnl lock on heavy flush when calling ndo_open/stop
      IB/ipoib: Add ability to set PKEY index to lower device driver
      net/mlx5e: IPoIB, Support for setting PKEY index to underlay QP
      net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev
      net/mlx5e: IPoIB, Add PKEY child interface nic profile
      net/mlx5e: IPoIB, Add PKEY child interface ndos
      net/mlx5e: IPoIB, Add PKEY child interface ethtool ops
      net/mlx5e: IPoIB, Modify rdma netdev allocate and free to support PKE=
Y

Arnd Bergmann (5):
      RDMA/qedr: fix build error without ipv6
      IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage
      IB/uverbs: clean up INIT_UDATA() macro usage
      infiniband: add MMU dependency for user_mem
      RDMA/core: avoid uninitialized variable warning in create_udata

Arvind Yadav (2):
      IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end with newlines
      IB/ocrdma: pr_err() strings should end with newlines

Bart Van Assche (59):
      IB/core: Simplify sa_path_set_[sd]lid() calls
      IB/core: Fix endianness annotation in rdma_is_multicast_addr()
      IB/cm: Suppress gcc 7 fall-through complaints
      RDMA/cma: Avoid triggering undefined behavior
      RDMA/iwcm: Remove a set-but-not-used variable
      RDMA/isert: Suppress gcc 7 fall-through complaints
      RDMA/bnxt_re: Suppress gcc 7 fall-through complaints
      RDMA/bnxt_re: Remove set-but-not-used variables
      RDMA/cxgb3: Annotate locking assumptions
      RDMA/cxgb3: Annotate an RCU pointer
      RDMA/cxgb3: Remove a set-but-not-used variable
      RDMA/cxgb4: Fix indentation
      RDMA/cxgb4: Remove the obsolete kernel module option 'c4iw_debug'
      RDMA/cxgb4: Suppress gcc 7 fall-through complaints
      RDMA/cxgb4: Remove a set-but-not-used variable
      IB/hfi1: Suppress gcc 7 fall-through complaints
      IB/hfi1: Remove set-but-not-used variables
      IB/hfi1: Define hfi1_handle_cnp_tbl[] once
      IB/hns: Annotate iomem pointers correctly
      IB/hns: Declare local functions 'static'
      RDMA/i40iw: Fix a race condition
      RDMA/i40iw: Suppress gcc 7 fall-through complaints
      RDMA/i40iw: Remove a set-but-not-used variable
      IB/mthca: Fix indentation
      IB/mlx4: Suppress gcc 7 fall-through complaints
      IB/mlx5: Suppress gcc 7 fall-through complaints
      IB/mlx5: Remove a set-but-not-used variable
      IB/nes: Fix indentation
      IB/nes: Suppress gcc 7 fall-through complaints
      IB/nes: Remove set-but-not-used variables
      IB/nes: Fix a race condition in nes_inetaddr_event()
      RDMA/ocrdma: Use NULL instead of 0 to represent a pointer
      RDMA/ocrdma: Suppress gcc 7 fall-through complaints
      RDMA/ocrdma: Remove set-but-not-used variables
      RDMA/qedr: Use NULL instead of 0 to represent a pointer
      RDMA/qedr: Declare local functions static
      RDMA/qedr: Annotate iomem pointers correctly
      RDMA/qedr: Remove set-but-not-used variables
      IB/qib: Remove remaining code related to writing the EEPROM
      IB/qib: Suppress gcc 7 fall-through complaints
      IB/qib: Remove set-but-not-used variables
      RDMA/rdmavt: Suppress gcc 7 fall-through complaints
      RDMA/rxe: Suppress gcc 7 fall-through complaints
      RDMA/usnic: Make the compiler check declaration consistency during co=
mpilation
      RDMA/usnic: Remove a set-but-not-used variable
      RDMA/usnic: Instantiate data structures once
      RDMA/uverbs: Make the code in ib_uverbs_cmd_verbs() less confusing
      IB/srpt: Do not accept invalid initiator port names
      IB/srpt: Limit the send and receive queue sizes to what the HCA suppo=
rts
      IB/srpt: Cache global L_Key
      IB/srpt: Change default behavior from using SRQ to using RC
      IB/srp: Avoid that a cable pull can trigger a kernel crash
      IB/srp: Remove second argument of srp_destroy_qp()
      IB/srp: Cache global rkey
      IB/srp: Make CM timeout dependent on subnet timeout
      IB/srpt: Introduce helper functions for SRQ allocation and freeing
      IB/srpt: Introduce srpt_disconnect_ch_sync()
      IB/srpt: Wait until channel release has finished during module unload
      IB/srpt: Ensure that modifying the use_srq configfs attribute works

Bharat Potnuri (3):
      iw_cxgb4: Remove __func__ parameter from pr_debug()
      iw_cxgb4: change pr_debug to appropriate log level
      iw_cxgb4: Fix possible circular dependency locking warning

Bob Sharp (1):
      i40iw: Move cqp_cmd_head init to CQP initialization

Bryan Tan (1):
      RDMA/vmw_pvrdma: Add shared receive queue support

Christopher Bednarz (1):
      i40iw: Clear CQP Head/Tail during initialization

Colin Ian King (8):
      IB/core: fix spelling mistake: "aceess" -> "access"
      RDMA/cxgb3: remove redundant first assignement of sqp
      RDMA/hns: make various function static, fixes warnings
      RDMA/hns: remove redundant assignment to variable j
      RDMA/hns: return 0 rather than return a garbage status value
      IB/rxe: check for allocation failure on elem
      IB/core: remove redundant check on prot_sg_cnt
      RDMA/hns: fix spelling mistake: "Reseved" -> "Reserved"

Dan Carpenter (2):
      RDMA/qedr: Missing error code in qedr_init_user_queue()
      i40iw: delete some stray tabs

Daniel Jurgens (1):
      IB/core: Only maintain real QPs in the security lists

Dennis Dalessandro (1):
      IB/hfi1: Handle initial value of 0 for CCTI setting

Devesh Sharma (1):
      RDMA/bnxt_re: report vlan_id and sl in qp1 recv completion

Don Hiatt (7):
      IB/core: Use __be32 for LIDs in opa_is_extended_lid
      IB/core: Do not warn on lid conversions for OPA
      IB/hfi1: Do not warn on lid conversions for OPA
      IB/hfi1: Mask out A bit from psn trace
      IB/hfi1: Eliminate allocation while atomic
      IB/core: Convert OPA AH to IB for Extended LIDs only
      IB/hfi1: Mask upper 16Bits of Extended LID prior to rvt_cq_entry

Doug Ledford (12):
      Merge tag 'v4.14-rc2' into k.o/for-next
      Merge branch 'qedr' into k.o/for-next
      Merge branches 'hns' and 'misc' into k.o/for-next
      Merge branch 'hfi1' into k.o/for-next
      Merge branch 'vnic' into k.o/for-next
      IB/rxe: put the pool on allocation failure
      Merge tag 'mlx5-updates-2017-10-06' of git://git.kernel.org/.../mella=
nox/linux into k.o/for-next
      Merge branch 'hfi1' into k.o/for-next
      Merge tag 'mlx5-updates-2017-10-11' of git://git.kernel.org/.../mella=
nox/linux into mlnx-shared
      Merge branch 'for-next-early' into for-next
      Merge branch 'timer_setup' into for-next
      Merge branch 'k.o/for-rc' into k.o/for-next

Erez Shitrit (3):
      IB/ipoib: Get rid of the tx_outstanding variable in all modes
      IB/ipoib: Use NAPI in UD/TX flows
      IB/ipoib: Change number of TX wqe to 64

Feras Daoud (2):
      net/mlx5: File renaming towards ptp core implementation
      net/mlx5: PTP code migration to driver core section

Grzegorz Morys (2):
      IB/hfi1: Correct unnecessary acquisition of HW mutex
      IB/hfi1: Prohibit invalid Init to Armed state transition

Gustavo A. R. Silva (1):
      IB/ocrdma_hw: remove unnecessary code in ocrdma_mbx_dealloc_lkey

Guy Levi (7):
      IB/mlx5: Add 128B CQE compression and padding HW bits
      IB/mlx5: Support 128B CQE compression feature
      IB/mlx5: Support padded 128B CQE feature
      IB/mlx4: Add report for RSS capabilities by vendor channel
      IB/mlx4: Fix RSS's QPC attributes assignments
      IB/mlx4: Use optimal numbers of MTT entries
      IB/mlx4: Add contig support for control objects

Harish Chegondi (2):
      IB/hfi1: Convert the macro AHG_HEADER_SET into an inline function
      IB/hfi1: Remove the debug trace message in pin_sdma_pages()

Himanshu Jha (1):
      IB/qib: Use setup_timer and mod_timer

Ira Weiny (2):
      IB/hfi1: Set default_desc1 just one time
      IB/hfi1: Remove unused link_default variable

Ivan Barrera (1):
      i40iw: Remove UDA QP from QoS list if creation fails

Jakub Byczkowski (4):
      IB/hfi1: Add new state complete decodes for LNI failures
      IB/hfi1: Add parsing for platform configuration format version 4
      IB/hfi1: Allow meta version 4 for platform configuration
      IB/hfi1: Reduce 8051 command timeout

Jan Sokolowski (6):
      IB/hfi1: Remove unnecessary error messages on alloc failures
      IB/hfi1: Remove unused hfi1_cpulist variables
      IB/hfi1: Fix serdes loopback set-up
      IB/hfi1: Allow MgmtAllowed on B2B setups
      IB/hfi1: Remove unnecessary if check
      IB/hfi1: Send 'reboot' as planned down remote reason

J=C3=A9r=C3=A9my Lefaure (1):
      IB/mlx5: Use ARRAY_SIZE

Kaike Wan (1):
      IB/hfi1: Set hdr_type when tx req is allocated

Kalderon, Michal (9):
      RDMA/qedr: Add additional maintainer to MAINTAINERS file
      RDMA/qedr: Rename the qedr_cm file as a preparation for iWARP support
      RDMA/qedr: Add support for registering an iWARP device
      RDMA/qedr: Add iWARP support in existing verbs
      RDMA/qedr: Add support for read with invalidate, supported in iWARP
      RDMA/qedr: Add iWARP connection management qp related callbacks
      RDMA/qedr: Add iWARP connection management functions
      RDMA/qedr: Add support for iWARP in user space
      RDMA/qedr: Fix rdma_type initialization

Kamenee Arumugam (2):
      IB/hfi1: Don't modify num_user_contexts module parameter
      IB/hfi1: Remove wrapper function in mmu_rb

Kees Cook (11):
      RDMA/nes: Convert timers to use timer_setup()
      IB/qib: Convert timers to use timer_setup()
      RDMA/i40iw: Convert timers to use timer_setup()
      IB/ipoib: Convert timers to use timer_setup()
      net/mlx4_core: Convert timers to use timer_setup()
      IB/rdmavt: Convert timers to use timer_setup()
      IB/hfi1: Convert timers to use timer_setup()
      RDMA/cxgb3: Convert timers to use timer_setup()
      RDMA/i40iw: Convert timers to use timer_setup() (part 2)
      RDMA/cxgb4: Convert timers to use timer_setup()
      IB/rxe: Convert timers to use timer_setup()

Leon Romanovsky (7):
      RDMA: Remove Sean's and Hal's emails from MAINTAINER file
      RDMA/cxgb4: Declare stag as __be32
      RDMA/umem: Avoid partial declaration of non-static function
      RDMA/cxgb4: Annotate r2 and stag as __be32
      RDMA/bnxt_re: Remove unused vlan_tag variable
      RDMA/cxgb4: Protect from possible dereference
      RDMA/core: Rename kernel modify_cq to better describe its usage

Lijun Ou (6):
      RDMA/hns: Modify the value with rd&dest_rd of qp_attr
      RDMA/hns: Refactor code for readability
      RDMA/hns: Only assign dest_qp if IB_QP_DEST_QPN bit is set
      RDMA/hns: Set rdma_ah_attr type for querying qp
      RDMA/hns: Don't unregister a callback we didn't register
      RDMA/hns: Fix calltrace for sleeping in atomic

Majd Dibbiny (2):
      IB/mlx5: Assign send CQ and recv CQ of UMR QP
      IB/mlx5: Fix RoCE Address Path fields

Maor Gottlieb (11):
      net/mlx5: Avoid NULL pointer dereference on steering cleanup
      net/mlx5: Move the entry index allocator to flow group
      net/mlx5: Export building of matched flow groups list
      net/mlx5: Refactor FTE and FG creation code
      net/mlx5: Replace fs_node mutex with reader/writer semaphore
      net/mlx5: Support multiple updates of steering rules in parallel
      net/mlx5: Allocate FTE object without lock
      net/mlx5: Add FGs and FTEs memory pool
      IB/mlx5: Update tunnel offloads bits
      IB/mlx5: Add tunneling offloads support
      IB/mlx5: Add support for RSS on the inner packet

Mark Bloch (1):
      IB/mlx4: Increase maximal message size under UD QP

Matan Barak (1):
      net/mlx5: Fix creating a new FTE when an existing but full FTE exists

Michael J. Ruhl (16):
      IB/qib: Update QIB to use the latest PCI API
      IB/hfi1: Update HFI to use the latest PCI API
      IB/hfi1: Inline common calculation
      IB/hfi1: Add a safe wrapper for _rcd_get_by_index
      IB/hfi1: Refactor assign_ctxt() IOCTL
      IB/hfi1: Refactor get_ctxt_info
      IB/hfi1: Fix parenthesis alignment issues
      IB/hfi1: Refactor get_base_info
      IB/hfi1: Refactor hfi_user_exp_rcv_setup() IOCTL
      IB/hfi1: Refactor hfi_user_exp_rcv_clear() IOCTLs
      IB/hfi1: Refactor hfi_user_exp_rcv_invalid() IOCTLs
      IB/hfi1: Refactor get_user() IOCTLs
      IB/hfi1: Refactor reset_ctxt() IOCTL
      IB/hfi1: Fix incorrect available receive user context count
      RDMA/netlink: OOPs in rdma_nl_rcv_msg() from misinterpreted flag
      IB/hfi1: Race condition between user notification and driver state

Mike Marciniszyn (7):
      IB/hfi1: Extend input hdr tracing for packet type
      IB/hfi1: Fix output trace issues from 16B change
      IB/hfi1: Add tx_opcode_stats like the opcode_stats
      IB/hfi1: Insure int mask for in-kernel receive contexts is clear
      IB/hfi1: Take advantage of kvzalloc_node in sdma initialization
      IB/srpt: Post receive work requests after qp transition to INIT state
      IB/hfi1: Fix a wrapping test to insure the correct timeout

Mustafa Ismail (6):
      i40iw: Do not generate CQE for RTR on QP flush
      i40iw: Cleanup AE processing
      i40iw: Ignore AE source field in AEQE for some AEs
      i40iw: Remove unused static_rsrc from i40iw_create_qp_info
      i40iw: Move exception_lan_queue to VSI structure
      i40iw: Remove unused structures

Niranjana Vishwanathapura (7):
      IB/opa_vnic: Mark unused Ethernet MTU fields as reserved
      IB/opa_vnic: Set POD value for Ethernet MTU
      IB/opa_vnic: Allow reset of MAC address
      IB/opa_vnic: Properly return the total MACs in UC MAC list
      IB/opa_vnic: Properly set vesw port status
      IB/opa_vnic: Add routing control information
      IB/hfi1: Do not allocate PIO send contexts for VNIC

Noa Osherovich (5):
      IB/mlx5: Expose multi-packet RQ capabilities
      IB/mlx5: Allow creation of a multi-packet RQ
      IB/core: Add PCI write end padding flags for WQ and QP
      IB/mlx5: Add PCI write end padding support
      IB/mlx5: Fix ABI alignment to 64 bit

Parav Pandit (8):
      IB/core: Introduce and use rdma_create_user_ah
      IB: Let ib_core resolve destination mac address
      IB/core: Fix unable to change lifespan entry for hw_counters
      IB/core: Fix use workqueue without WQ_MEM_RECLAIM
      IB/core: Fix calculation of maximum RoCE MTU
      IB/cm: Fix memory corruption in handling CM request
      IB/core: Avoid crash on pkey enforcement failed in received MADs
      IB/core: Avoid unnecessary return value check

Patel Jay P (1):
      Ib/hfi1: Return actual operational VLs in port info query

Scott Franco (1):
      IB/opa_vnic: Properly clear Mac Table Digest

Sebastian Sanchez (3):
      IB/hfi1: Prevent LNI out of sync by resetting host interface version
      IB/rdmavt: Correct issues with read-mostly and send size cache lines
      IB/hfi1: Validate PKEY for incoming GSI MAD packets

Selvin Xavier (3):
      RDMA/bnxt_re: Set QP state in case of response completion errors
      RDMA/bnxt_re: Flush CQ notification Work Queue before destroying QP
      RDMA/bnxt_re: synchronize poll_cq and req_notify_cq verbs

Shaobo Xu (3):
      RDMA/hns: Add the interfaces to support multi hop addressing for the =
contexts in hip08
      RDMA/hns: Update the interfaces for MTT/CQE multi hop addressing in h=
ip08
      RDMA/hns: Split CQE from MTT in hip08

Shiraz Saleem (5):
      i40iw: Do not allow posting WR after QP is flushed
      i40iw: Account for IPv6 header when setting MSS
      i40iw: Move ceq_valid to i40iw_sc_dev structure
      i40iw: Reinitialize IEQ on MTU change
      i40iw: Refactor queue depth calculation

Somnath Kotur (4):
      bnxt_re: Fix incorrect usage of test_bit()
      bnxt_re: Make room for mapping beyond 32 entries
      bnxt_re: Implement the shutdown hook of the L2-RoCE driver interface
      RDMA/bnxt_re: Add memory barriers when processing CQ/EQ entries

Sriharsha Basavapatna (2):
      bnxt_re: fix a crash in qp error event processing
      bnxt_re: changing the ip address shouldn't affect new connections

Steve Wise (8):
      iw_cxgb4: allocate wait object for each memory object
      iw_cxgb4: allocate wait object for each cq object
      iw_cxgb4: allocate wait object for each qp object
      iw_cxgb4: allocate wait object for each ep object
      iw_cxgb4: add referencing to wait objects
      iw_cxgb4: remove BUG_ON() usage.
      iw_cxgb4: only call the cq comp_handler when the cq is armed
      iw_cxgb4: atomically flush the qp

Tatyana Nikolova (1):
      i40iw: Do not retransmit MPA request after it is ACKed

Thomas Bogendoerfer (2):
      IB/hfi1: Add MODULE_FIRMWARE statements
      IB/rxe: don't crash, if allocation of crc algorithm failed

Wei Hu(Xavier) (26):
      RDMA/hns: Split hw v1 driver from hns roce driver
      RDMA/hns: Move priv in order to add multiple hns_roce support
      RDMA/hns: Initialize the PCI device for hip08 RoCE
      RDMA/hns: Modify assignment device variable to support both PCI devic=
e and platform device
      RDMA/hns: Add command queue support for hip08 RoCE driver
      RDMA/hns: Add profile support for hip08 driver
      RDMA/hns: Add mailbox's implementation for hip08 RoCE driver
      RDMA/hns: Configure BT BA and BT attribute for the contexts in hip08
      RDMA/hns: Support multi hop addressing for PBL in hip08
      RDMA/hns: Configure mac&gid and user access region for hip08 RoCE dri=
ver
      RDMA/hns: Add CQ operations support for hip08 RoCE driver
      RDMA/hns: Add QP operations support for hip08 SoC
      RDMA/hns: Add support for processing send wr and receive wr
      RDMA/hns: Configure the MTPT in hip08
      RDMA/hns: Add releasing resource operation in error branch
      RDMA/hns: Replace condition statement using hardware version informat=
ion
      RDMA/hns: Fix inconsistent warning
      RDMA/hns: Delete the unnecessary initializing enum to zero
      RDMA/hns: Check return value of kzalloc
      RDMA/hns: Avoid NULL pointer exception
      RDMA/hns: Support WQE/CQE/PBL page size configurable feature in hip08
      RDMA/hns: Update the IRRL table chunk size in hip08
      RDMA/hns: Update the PD&CQE&MTT specification in hip08
      RDMA/hns: Add rereg mr support for hip08
      RDMA/hns: Generate gid type of RoCEv2
      RDMA/hns: Configure sgid type for hip08 RoCE

Yonatan Cohen (6):
      IB/uverbs: Allow CQ moderation with modify CQ
      IB/mlx4: Exposing modify CQ callback to uverbs layer
      IB/mlx5: Exposing modify CQ callback to uverbs layer
      IB/uverbs: Add CQ moderation capability to query_device
      IB/mlx4: Add CQ moderation capability to query_device
      IB/mlx5: Add CQ moderation capability to query_device

Yuval Shaia (4):
      IB: Move PCI dependency from root KConfig to HW's KConfigs
      IB/{cxgb3,cxgb4}: Remove unneeded config dependencies
      IB/ipoib: Remove device when one port fails to init
      RDMA/core: Make function rdma_copy_addr return void

oulijun (12):
      RDMA/hns: Add modify CQ support for hip08
      RDMA/hns: Update calculation of irrl_ba field for hip08
      RDMA/hns: Configure TRRL field in hip08 RoCE device
      RDMA/hns: Configure fence attribute in hip08 RoCE
      RDMA/hns: Set se attribute of sqwqe in hip08
      RDMA/hns: Enable the cqe field of sqwqe of RC
      RDMA/hns: Set sq_cur_sge_blk_addr field in QPC in hip08
      RDMA/hns: Update the usage of ack timeout in hip08
      RDMA/hns: Add sq_invld_flg field in QP context
      RDMA/hns: Set the owner field of SQWQE in hip08 RoCE
      RDMA/hns: Unify the calculation for hem index in hip08
      RDMA/hns: Modify the usage of cmd_sn in hip08

 MAINTAINERS                                        |    3 +-
 drivers/infiniband/Kconfig                         |    2 +-
 drivers/infiniband/core/Makefile                   |    2 +-
 drivers/infiniband/core/addr.c                     |   29 +-
 drivers/infiniband/core/cm.c                       |   38 +-
 drivers/infiniband/core/cma.c                      |   19 +-
 drivers/infiniband/core/iwcm.c                     |    3 -
 drivers/infiniband/core/mad.c                      |    3 +-
 drivers/infiniband/core/netlink.c                  |   13 +-
 drivers/infiniband/core/rw.c                       |   24 +-
 drivers/infiniband/core/security.c                 |   66 +-
 drivers/infiniband/core/sysfs.c                    |   16 +-
 drivers/infiniband/core/umem_odp.c                 |   72 +
 drivers/infiniband/core/umem_rbtree.c              |  109 -
 drivers/infiniband/core/user_mad.c                 |   13 +-
 drivers/infiniband/core/uverbs.h                   |   36 +-
 drivers/infiniband/core/uverbs_cmd.c               |  189 +-
 drivers/infiniband/core/uverbs_ioctl.c             |   13 +-
 drivers/infiniband/core/uverbs_ioctl_merge.c       |    2 +-
 drivers/infiniband/core/uverbs_main.c              |   23 +-
 drivers/infiniband/core/uverbs_marshall.c          |   13 +-
 drivers/infiniband/core/uverbs_std_types.c         |   20 +-
 drivers/infiniband/core/verbs.c                    |   52 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   78 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   19 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   39 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |    1 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   18 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |    6 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |    2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |    5 +-
 drivers/infiniband/hw/bnxt_re/roce_hsi.h           |    2 +-
 drivers/infiniband/hw/cxgb3/Kconfig                |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |    6 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   18 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.h        |    1 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |    3 +
 drivers/infiniband/hw/cxgb4/Kconfig                |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  330 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |  127 +-
 drivers/infiniband/hw/cxgb4/device.c               |   69 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |   10 +-
 drivers/infiniband/hw/cxgb4/id_table.c             |    1 -
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   95 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  268 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   66 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  186 +-
 drivers/infiniband/hw/cxgb4/resource.c             |   46 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |   29 +-
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h          |    4 +-
 drivers/infiniband/hw/hfi1/aspm.h                  |    7 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  385 +--
 drivers/infiniband/hw/hfi1/chip.h                  |    6 +-
 drivers/infiniband/hw/hfi1/common.h                |    1 +
 drivers/infiniband/hw/hfi1/debugfs.c               |   60 +-
 drivers/infiniband/hw/hfi1/driver.c                |   22 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |  486 +--
 drivers/infiniband/hw/hfi1/firmware.c              |  113 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   35 +-
 drivers/infiniband/hw/hfi1/init.c                  |   53 +-
 drivers/infiniband/hw/hfi1/intr.c                  |   57 +-
 drivers/infiniband/hw/hfi1/mad.c                   |  144 +-
 drivers/infiniband/hw/hfi1/mad.h                   |    4 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                |   24 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   17 -
 drivers/infiniband/hw/hfi1/pio.h                   |    6 -
 drivers/infiniband/hw/hfi1/rc.c                    |    7 +-
 drivers/infiniband/hw/hfi1/ruc.c                   |   11 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   36 +-
 drivers/infiniband/hw/hfi1/sysfs.c                 |    2 +-
 drivers/infiniband/hw/hfi1/trace.c                 |   27 +-
 drivers/infiniband/hw/hfi1/trace.h                 |   10 +
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h          |   49 +-
 drivers/infiniband/hw/hfi1/trace_rx.h              |   11 +-
 drivers/infiniband/hw/hfi1/uc.c                    |    3 +-
 drivers/infiniband/hw/hfi1/ud.c                    |    8 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |    9 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   92 +-
 drivers/infiniband/hw/hfi1/user_sdma.h             |   29 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |   65 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h           |    2 +
 drivers/infiniband/hw/hfi1/vnic_main.c             |   44 +-
 drivers/infiniband/hw/hns/Kconfig                  |   25 +-
 drivers/infiniband/hw/hns/Makefile                 |    8 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   16 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   35 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |  107 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.h           |   54 +
 drivers/infiniband/hw/hns/hns_roce_common.h        |   23 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   95 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  134 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  719 ++++-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |   33 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  609 +++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |    7 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 3296 ++++++++++++++++=
++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         | 1177 +++++++
 drivers/infiniband/hw/hns/hns_roce_main.c          |  384 +--
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  692 +++-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |   20 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  226 +-
 drivers/infiniband/hw/i40iw/Kconfig                |    1 +
 drivers/infiniband/hw/i40iw/i40iw.h                |    3 -
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   30 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |    1 +
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           |   76 +-
 drivers/infiniband/hw/i40iw/i40iw_d.h              |   30 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |    3 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |   48 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h              |    3 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |   19 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.h           |    2 -
 drivers/infiniband/hw/i40iw/i40iw_type.h           |   13 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c             |   76 +-
 drivers/infiniband/hw/i40iw/i40iw_user.h           |   23 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |   30 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   47 +-
 drivers/infiniband/hw/mlx4/ah.c                    |    8 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   10 +-
 drivers/infiniband/hw/mlx4/main.c                  |   23 +
 drivers/infiniband/hw/mlx4/mcg.c                   |    1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   19 +-
 drivers/infiniband/hw/mlx4/mr.c                    |  284 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   26 +-
 drivers/infiniband/hw/mlx5/ah.c                    |    4 -
 drivers/infiniband/hw/mlx5/cq.c                    |   38 +-
 drivers/infiniband/hw/mlx5/main.c                  |   57 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   18 +
 drivers/infiniband/hw/mlx5/mr.c                    |    4 +-
 drivers/infiniband/hw/mlx5/odp.c                   |    6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  149 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   10 +-
 drivers/infiniband/hw/nes/nes.c                    |   33 +-
 drivers/infiniband/hw/nes/nes.h                    |    6 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   14 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |   27 +-
 drivers/infiniband/hw/nes/nes_hw.h                 |    1 +
 drivers/infiniband/hw/nes/nes_mgt.c                |    9 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   12 +-
 drivers/infiniband/hw/nes/nes_utils.c              |   24 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   22 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   15 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   14 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |    4 +-
 drivers/infiniband/hw/qedr/Kconfig                 |    1 +
 drivers/infiniband/hw/qedr/Makefile                |    2 +-
 drivers/infiniband/hw/qedr/main.c                  |  118 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   31 +-
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |    6 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |  749 +++++
 drivers/infiniband/hw/qedr/qedr_iw_cm.h            |   49 +
 .../hw/qedr/{qedr_cm.c =3D> qedr_roce_cm.c}          |   31 +-
 .../hw/qedr/{qedr_cm.h =3D> qedr_roce_cm.h}          |    0
 drivers/infiniband/hw/qedr/verbs.c                 |  359 ++-
 drivers/infiniband/hw/qedr/verbs.h                 |    2 +
 drivers/infiniband/hw/qib/Kconfig                  |    1 +
 drivers/infiniband/hw/qib/qib.h                    |   30 +-
 drivers/infiniband/hw/qib/qib_7220.h               |    2 +-
 drivers/infiniband/hw/qib/qib_diag.c               |    6 -
 drivers/infiniband/hw/qib/qib_driver.c             |    9 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |    9 -
 drivers/infiniband/hw/qib/qib_iba6120.c            |   81 +-
 drivers/infiniband/hw/qib/qib_iba7220.c            |   95 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |  196 +-
 drivers/infiniband/hw/qib/qib_init.c               |   29 +-
 drivers/infiniband/hw/qib/qib_intr.c               |    6 +-
 drivers/infiniband/hw/qib/qib_mad.c                |   16 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |  128 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |    2 +-
 drivers/infiniband/hw/qib/qib_sd7220.c             |   12 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |    2 +-
 drivers/infiniband/hw/qib/qib_tx.c                 |    8 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    9 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |    2 -
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      |   25 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |    1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   25 +
 drivers/infiniband/hw/vmw_pvrdma/Makefile          |    2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |   25 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h  |   54 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   59 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   55 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c      |  319 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |    3 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |   18 +
 drivers/infiniband/sw/rdmavt/Kconfig               |    1 +
 drivers/infiniband/sw/rdmavt/mcast.c               |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   13 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |    8 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |    4 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |   16 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |    4 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |    4 +-
 drivers/infiniband/sw/rxe/rxe_task.c               |    2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   11 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   16 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   56 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  150 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   29 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   17 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   14 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   42 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h   |   22 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    7 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |   44 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |    1 +
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |   22 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   90 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |    3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  331 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    9 +-
 drivers/net/ethernet/chelsio/cxgb3/t3cdev.h        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/catas.c         |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   39 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_clock.c |  619 ----
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |    1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   95 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  976 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   18 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    5 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  260 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   36 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  350 +++
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  525 ++++
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |   51 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    4 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    1 +
 drivers/staging/lustre/lnet/Kconfig                |    2 +-
 include/linux/mlx4/cq.h                            |    3 +
 include/linux/mlx5/cq.h                            |    9 +-
 include/linux/mlx5/driver.h                        |   24 +
 include/linux/mlx5/mlx5_ifc.h                      |    9 +-
 include/rdma/ib_addr.h                             |   16 +-
 include/rdma/ib_pack.h                             |   19 +-
 include/rdma/ib_sa.h                               |   12 +-
 include/rdma/ib_umem_odp.h                         |    4 -
 include/rdma/ib_verbs.h                            |   35 +-
 include/rdma/opa_addr.h                            |    6 +-
 include/rdma/rdmavt_qp.h                           |    6 +-
 include/uapi/rdma/ib_user_verbs.h                  |   22 +-
 include/uapi/rdma/mlx5-abi.h                       |   52 +-
 include/uapi/rdma/vmw_pvrdma-abi.h                 |    2 +
 255 files changed, 14874 insertions(+), 4849 deletions(-)
 delete mode 100644 drivers/infiniband/core/umem_rbtree.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.h
 rename drivers/infiniband/hw/qedr/{qedr_cm.c =3D> qedr_roce_cm.c} (96%)
 rename drivers/infiniband/hw/qedr/{qedr_cm.h =3D> qedr_roce_cm.h} (100%)
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_clock.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vla=
n.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-0OkcGlNyEEZo0PJvMsOa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloMZMkACgkQuCajMw5X
L931rBAAscw1bLtB7Plv1NocHyWTkoo2I5lRwMOZbxM4Qloi2qjCui69jjibQOxl
4E9BMq9lIBM3MDg36JyGClv0KMaaoU7AnS6VTr+Qmf1GXAJh2jR9NXeX/Kd40VVV
BcQxC0nbUCSNoMlLE300CAdplXmLIreKUajfnBK0xxWpUmAWhU6BGZrz3Kzyagvq
CJR5KcX/1pT3i1N5VBHBByslddXZFeMrPLQ2cWo2cH7uMbbUHiMxrBuYFWVsHdtz
4oJ1IznTy17TgiGTAFRkp0a8uJFm1ae3XUcL4MaGI5tgH18tKfFe2n0df595dl0E
4hnNopx1LgELY5XkU2DfMutJEz/ixsMveZ6cc/qnzbEN3wKKH3JxJJWH2VvE/hSl
3VQDCZ/r0wJwvjawCCWd699h+fmoO4HImTJWFsOLALc45HVHN8KHRE29lNj2iLMt
rqKAK3ki7YicgSsba0lVk0RJreo5S9WUHovzzCz//nsDVSqTXlKIyRst58LSKQIr
vqFnxTd2lr90rxJGd0EqBZfNRj2QNtT4ratuvaD7xTyJsWKNpAnns0WVGp9/JY3K
3b4jGElkbYs+869VY485Ki1Ev8kyYPCUjRjAd9qc+mi2m+IJ7I581Q8xROtuRUxE
ZB+neuU+rfcZQ0pEYMkyZ+e9rP9hD0+m3yqEJdwHT5f2EZy+jQQ=
=b1KO
-----END PGP SIGNATURE-----

--=-0OkcGlNyEEZo0PJvMsOa--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
