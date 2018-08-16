From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 16 Aug 2018 15:57:26 -0600
Message-ID: <20180816215726.GA20526@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are the RDMA patches for 4.19.

This time there are many merge conflicts, all due to various tree-wide or R=
DMA
subystem wide changes done by various people. The resolution is tricky, as =
git
does not highlight two areas that need revision.

An overview of the conflicts:
 - Mark Rutland renamed __atomic_add_unless() conflicting with major rework=
 of
   rdma_core.c
 - Steve Wise split ib_device_attr.max_sge into max_send_sge and max_recv_s=
ge,
   and updated all ULPs. This clashed with other changes in the NVMe over
   fabrics driver adding new users of max_sge. This is tricky as the correct
   use of send/recv in the merge is essential. Christoph Hellwig has review=
ded
   this resolution in linux-next
 - Bart did a tree wide change to use NULL for the last argument in
   ibv_post_send(), clashing with various RDP ULP changes in netdev
 - Parav revised the ugly ib_query_gid API with something saner and
   did a treewide update. This clashed horribly with general work on the SMC
   code in netdev. We've handled this by providing a compat ib_query_gid wr=
apper
   and reverting the SMC changes in rdma.git, so no merge fixup neeed.
   However, I will send a cleanup for this to remove the wrapper as soon as
   possible.
 - Various small conflicts between RDMA -rc and -next resolved by merging t=
he
   v4.18 tag.

Notably we have again avoided the historical merge conflicts in the Mellanox
drivers with the new 'shared branch' arrangement with DaveM, this seems to =
be
working well.

The above tree wide changes explain most of the hunks outside the tree, the
only other cases are a new function check_shl_overflow() in
include/linux/overflow.h ack'd by Kees and an edit to idr.h from Matthew Wi=
lcox
that was needed for other patches he sent to the RDMA tree.

As before I've resolved the conflicts in the for-next tag (this makes the
diffstat below more accurate) and provided the unmerged tree in the
for-linus-unmerged tag. The merge resolution diff is a bit big so it is
included at the end of this message for your reference.

The following changes since commit 5c60a7389d795e001c8748b458eb76e3a5b6008c:

  Merge tag 'for-linus-4.19-ofs1' of git://git.kernel.org/pub/scm/linux/ker=
nel/git/hubcap/linux (2018-08-16 10:53:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 0a3173a5f09bc58a3638ecfd0a80bdbae55e123c:

  Merge branch 'linus/master' into rdma.git for-next (2018-08-16 14:21:29 -=
0600)

----------------------------------------------------------------
This has been a large cycle for RDMA, with several major patch series
reworking parts of the core code.

- Rework the so-called 'gid cache' and internal APIs to use a kref'd
  pointer to a struct instead of copying, push this upwards into the
  callers and add more stuff to the struct. The new design avoids some
  ugly races the old one suffered with. This is part of the namespace
  enablement work as the new struct is learning to be namespace aware.

- Various uapi cleanups, moving more stuff to include/uapi and fixing some
  long standing bugs that have recently been discovered.

- Driver updates for mlx5, mlx4 i40iw, rxe, cxgb4, hfi1, usnic, pvrdma,
  and hns

- Provide max_send_sge and max_recv_sge attributes to better support HW
  where these values are asymmetric.

- mlx5 user API 'devx' allows sending commands directly to the device FW,
  instead of trying to cram every wild and niche feature into the common
  API. Sort of like what GPU does.

- Major write() and ioctl() API rework to cleanly support PCI device hot
  unplug and advance the ioctl conversion work

- Sparse and compile warning cleanups

- Add 'const' to the ib_poll_cq() signature, and permit a NULL 'bad_wr',
  which is the common use case

- Various patches to avoid high order allocations across the stack

- SRQ support for cxgb4, hns and qedr

- Changes to IPoIB to better follow the netdev model for working with
  struct net_device liftime

----------------------------------------------------------------
Arnd Bergmann (1):
      infiniband: i40iw, nes: don't use wall time for TCP sequence numbers

Artemy Kovalyov (2):
      RDMA: Validate grh_required when handling AVs
      IB/uverbs: Pass IB_UVERBS_QPF_GRH_REQUIRED to user space

Bart Van Assche (51):
      MAINTAINERS: Update SRP entries
      IB/srpt: Support HCAs with more than two ports
      include/rdma/opa_addr.h: Fix an endianness issue
      IB/srp: Remove driver version and release data information
      IB/mlx5: Remove set-but-not-used variables
      ib_srpt: Fix a use-after-free in srpt_close_ch()
      ib_srpt: Fix a use-after-free in __srpt_close_all_ch()
      RDMA/core: Remove ib_find_cached_gid() and ib_find_cached_gid_by_port=
()
      RDMA/core: Remove set-but-not-used variables
      IB/nes: Fix a compiler warning
      RDMA/ocrdma: Remove a set-but-not-used variable
      IB/iser: Remove set-but-not-used variables
      RDMA/rxe: Simplify the error handling code in rxe_create_ah()
      RDMA/cxgb3: Make iwch_poll_cq_one() easier to analyze
      RDMA/cxgb4: Make c4iw_poll_cq_one() easier to analyze
      RDMA/rw: Fix rdma_rw_ctx_signature_init() kernel-doc header
      RDMA/nes: Avoid complaints about unused variables
      RDMA/ocrdma: Make ocrdma_destroy_qp() easier to analyze
      IB/hfi1: Suppress a compiler warning
      hns: Remove a set-but-not-used variable
      IB/srpt: Fix srpt_cm_req_recv() error path (1/2)
      IB/srpt: Fix srpt_cm_req_recv() error path (2/2)
      RDMA/bnxt_re: Modify a fall-through annotation
      MAINTAINERS: Remove Dave Goodell from the usnic RDMA driver maintaine=
r list
      IB/core: Allow ULPs to specify NULL as the third ib_post_(send|recv|s=
rq_recv)() argument
      RDMA/core: Simplify ib_post_(send|recv|srq_recv)() calls
      IB/IPoIB: Simplify ib_post_(send|recv|srq_recv)() calls
      IB/iser: Simplify ib_post_(send|recv|srq_recv)() calls
      IB/isert: Simplify ib_post_(send|recv|srq_recv)() calls
      IB/srp: Simplify ib_post_(send|recv|srq_recv)() calls
      IB/srpt: Simplify ib_post_(send|recv|srq_recv)() calls
      nvme-rdma: Simplify ib_post_(send|recv|srq_recv)() calls
      nvmet-rdma: Simplify ib_post_(send|recv|srq_recv)() calls
      fs/cifs: Simplify ib_post_(send|recv|srq_recv)() calls
      net/9p: Simplify ib_post_(send|recv|srq_recv)() calls
      net/rds: Remove two WARN_ON() statements
      net/rds: Simplify ib_post_(send|recv|srq_recv)() calls
      net/smc: Remove a WARN_ON() statement
      net/smc: Simplify ib_post_(send|recv|srq_recv)() calls
      net/xprtrdma: Simplify ib_post_(send|recv|srq_recv)() calls
      RDMA/ocrdma: Suppress a compiler warning
      RDMA/usnic: Suppress a compiler warning
      IB/iser: Inline two work request conversion functions
      RDMA: Constify the argument of the work request conversion functions
      IB/mlx5, ib_post_send(), IB_WR_REG_SIG_MR: Do not modify the 'wr' arg=
ument
      RDMA, core and ULPs: Declare ib_post_send() and ib_post_recv() argume=
nts const
      rdma/cxgb4: Remove a set-but-not-used variable
      rdma/cxgb4: Fix SRQ endianness annotations
      rdma/cxgb4: Simplify a structure initialization
      RDMA/rxe: Set wqe->status correctly if an unexpected response is rece=
ived
      Update the e-mail address of Bart Van Assche

Bharat Potnuri (1):
      iw_cxgb4: remove duplicate memcpy() in c4iw_create_listen()

Dan Carpenter (4):
      IB/core: type promotion bug in rdma_rw_init_one_mr()
      RDMA/bnxt_re: Fix a couple off by one bugs
      RDMA/bnxt_re: Fix a bunch of off by one bugs in qplib_fp.c
      rdma/cxgb4: fix some info leaks

Denis Drozdov (1):
      IB/IPoIB: Set ah valid flag in multicast send flow

Erez Shitrit (1):
      IB/ipoib: Use cancel_delayed_work_sync for neigh-clean task

Gal Pressman (1):
      RDMA/hns: Fix usage of bitmap allocation functions return values

H=C3=A5kon Bugge (1):
      IB/cm: Remove unused and erroneous msg sequence encoding

Jack Morgenstein (1):
      IB/mlx4: Use 4K pages for kernel QP's WQE buffer

Jan Dakinevich (2):
      ib_srpt: use kvmalloc to allocate ring pointers
      IPoIB: use kvzalloc to allocate an array of bucket pointers

Jann Horn (1):
      IB/mlx5: fix uaccess beyond "count" in debugfs read/write handlers

Jason Gunthorpe (90):
      IB/core: Provide rdma_ versions of the gid cache API
      IB/core: Make rdma_find_gid_by_filter support all protocols
      IB/rxe: Do not hide uABI stuff in memcpy
      IB/core: Add a sgid_attr pointer to struct rdma_ah_attr
      IB{cm, core}: Introduce and use ah_attr copy, move, replace APIs
      RDMA: Hold the sgid_attr inside the struct ib_ah/qp
      Merge branch 'mellanox/mlx5-next' into RDMA for-next
      Merge branch 'icrc-counter' into rdma.git for-next
      IB/uverbs: Delete type and id from uverbs_obj_attr
      RDMA/core: Remove unused ib cache functions
      IB/usnic: Update with bug fixes from core code
      RDMA/uverbs: Check existence of create_flow callback
      IB/mlx4: Create slave AH's directly
      IB/core: Check for rdma_protocol_ib only after validating port_num
      IB/cm: Remove now useless rcu_lock in dst_fetch_ha
      Merge branch 'mlx5-dump-fill-mkey' into rdma.git for-next
      RDMA/uverbs: Store the specs_root in the struct ib_uverbs_device
      RDMA/uverbs: Split UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE
      RDMA/uverbs: Simplify UVERBS_ATTR family of macros
      RDMA/uverbs: Simplify method definition macros
      RDMA/uverbs: Simplify UVERBS_OBJECT and _TREE family of macros
      RDMA/uverbs: Get rid of the & in method specifications
      RDMA/uverbs: Remove UA_FLAGS
      RDMA/uverbs: Use UVERBS_ATTR_MIN_SIZE correctly and uniformly
      RDMA/uverbs: Combine MIN_SZ_OR_ZERO with UVERBS_ATTR_STRUCT
      IB/uverbs: Add a uobj_perform_destroy helper
      IB/uverbs: Move non driver related elements from ib_ucontext to ib_uf=
ile
      IB/uverbs: Replace ib_ucontext with ib_uverbs_file in core function c=
alls
      IB/uverbs: Replace file->ucontext with file in uverbs_cmd.c
      IB/uverbs: Tidy up remaining references to ucontext
      IB/uverbs: Remove ib_uobject_file
      IB/uverbs: Replace ib_ucq_object uverbs_file with the one in ib_uobje=
ct
      IB/uverbs: Do not use uverbs_cmd_mask in the ioctl path
      RDMA: Fix storage of PortInfo CapabilityMask in the kernel
      RDMA/hfi1: Move grh_required into update_sm_ah
      RDMA/cxgb4: Restore the dropped uninitialized_var
      IB/cm: Remove cma_multicast->igmp_joined
      IB/uverbs: Move ib_access_flags and ib_read_counters_flags to uapi
      Merge branch 'mellanox/mlx5-next' into rdma.git for-next
      IB/uverbs: Get rid of null_obj_type
      IB/uverbs: Handle IDR and FD types without truncation
      IB/uverbs: Clarify the kref'ing ordering for alloc_commit
      IB/uverbs: Revise the placement of get/puts on uobject
      IB/uverbs: Clarify and revise uverbs_close_fd
      IB/uverbs: Revise and clarify the rwsem and uobjects_lock
      IB/uverbs: Rework the locking for cleaning up the ucontext
      IB/uverbs: Always propagate errors from rdma_alloc_commit_uobject()
      IB/uverbs: Move the FD uobj type struct file allocation to alloc_comm=
it
      IB/mlx5: Use the ucontext from the uobj, not the file
      IB/uverbs: Fix locking around struct ib_uverbs_file ucontext
      IB/usnic: usnic should not select INFINIBAND_USER_ACCESS
      net/xprtrdma: Restore needed argument to ib_post_send
      IB/cache: Restore compatibility for ib_query_gid
      IB/uverbs: Add UVERBS_ATTR_FLAGS_IN to the specs language
      IB/uverbs: Remove rdma_explicit_destroy() from the ioctl methods
      IB/uverbs: Make the write path destroy methods use the same flow as i=
octl
      IB/uverbs: Consolidate uobject destruction
      IB/uverbs: Convert 'bool exclusive' into an enum
      IB/uverbs: Allow RDMA_REMOVE_DESTROY to work concurrently with disass=
ociate
      IB/uverbs: Allow uobject allocation to work concurrently with disasso=
ciate
      IB/uverbs: Lower the test for ongoing disassociation
      IB/uverbs: Do not pass struct ib_device to the write based methods
      IB/uverbs: Do not pass struct ib_device to the ioctl methods
      IB/uverbs: Do not block disassociate during write()
      IB/uverbs: Allow all DESTROY commands to succeed after disassociate
      IB/ipoib: Get rid of IPOIB_FLAG_GOING_DOWN
      IB/ipoib: Move all uninit code into ndo_uninit
      IB/ipoib: Move init code to ndo_init
      RDMA/netdev: Use priv_destructor for netdev cleanup
      IB/ipoib: Get rid of the sysfs_mutex
      IB/ipoib: Do not remove child devices from within the ndo_uninit
      IB/ipoib: Maintain the child_intfs list from ndo_init/uninit
      IB/ipoib: Consolidate checking of the proposed child interface
      overflow.h: Add arithmetic shift helper
      IB/uverbs: Fix reading of 32 bit flags
      IB/uverbs: Have the core code create the uverbs_root_spec
      IB/uverbs: Build the specs into a radix tree at runtime
      IB/uverbs: Use uverbs_api to manage the object type inside the uobject
      IB/uverbs: Provide implementation private memory for the uverbs_attr_=
bundle
      IB/uverbs: Remove the ib_uverbs_attr pointer from each attr
      IB/uverbs: Add a simple allocator to uverbs_attr_bundle
      IB/uverbs: Use uverbs_alloc for allocations
      IB/uverbs: Use uverbs_api to unmarshal ioctl commands
      IB/uverbs: Remove struct uverbs_root_spec and all supporting code
      IB/uverbs: Do not check for device disassociation during ioctl
      IB/ucm: Fix compiling ucm.c
      IB/mlx5: Fix leaking stack memory to userspace
      Merge tag 'v4.18' into rdma.git for-next
      Revert "net/smc: Replace ib_query_gid with rdma_get_gid_attr"
      Merge branch 'linus/master' into rdma.git for-next

Kamal Heib (11):
      RDMA/ipoib: Use min_t() macro instead of min()
      RDMA/ipoib: Prefer unsigned int to bare use of unsigned
      RDMA/ipoib: Fix use of sizeof()
      RDMA/ipoib: Fix return code from ipoib_cm_dev_init
      RDMA/mlx5: Remove set but not used variables
      RDMA/providers: Fix return value from create_srq callbacks
      RDMA/ipoib: Fix check for return code from ib_create_srq
      RDMA/core: Remove {create,destroy}_ah from mandatory verbs
      RDMA/core: Check for verbs callbacks before using them
      RDMA/providers: Remove pointless functions
      RDMA: Fix return code check in rdma_set_cq_moderation

Kees Cook (1):
      test_overflow: Add shift overflow tests

Leon Romanovsky (16):
      RDMA/nldev: Return port capability flag for IB only
      RDMA/uverbs: Refactor flow_resources_alloc() function
      RDMA/mlx5: Refactor transport domain checks
      RDMA/verbs: Drop kernel variant of create_flow
      RDMA/verbs: Drop kernel variant of destroy_flow
      RDMA/uverbs: Don't overwrite NULL pointer with ZERO_SIZE_PTR
      RDMA/umem: Don't check for a negative return value of dma_map_sg_attr=
s()
      RDMA/uverbs: Remove redundant check
      RDMA/mlx5: Don't leak UARs in case of free fails
      RDMA/i40w: Hold read semaphore while looking after VMA
      RDMA/mlx5: Remove unused port number parameter
      RDMA/mlx5: Melt consecutive calls to alloc_bfreg() in one call
      RDMA/mlx5: Check that supplied blue flame index doesn't overflow
      RDMA/umem: Don't hold mmap_sem for too long
      RDMA/umem: Refactor exit paths in ib_umem_get
      RDMA/mlx5: Fix shift overflow in mlx5_ib_create_wq

Lijun Ou (12):
      RDMA/hns: Do not overwrite the error code during error unwind in hns_=
roce_init
      RDMA/hns: Add 50GE type of hnae3 device match
      RDMA/hns: Return correct error code from hns_roce_v1_rsv_lp_qp()
      RDMA/hns: Add illegal hop_num judgement
      RDMA/hns: Use delay instead of usleep
      RDMA/hns: Update the data type of immediate data
      RDMA/hns: Enable modify_cq for uverbs.
      RDMA/hns: Only assgin the fields of the av if IB_QP_AV bit is set
      RDMA/hns: Assign the value for vlan field of qp context
      RDMA/hns: Modify qp will return errno when qp type is illegal
      RDMA/hns: Use macro instead of magic number
      RDMA/hns: Program the tclass and flow label into the hardware

Maor Gottlieb (1):
      IB/mlx5: Fix GRE flow specification

Matan Barak (5):
      IB/uverbs: Export uverbs idr and fd types
      IB/uverbs: Refactor uverbs_finalize_objects
      IB/uverbs: Add PTR_IN attributes that are allocated/copied automatica=
lly
      IB/uverbs: Add a macro to define a type with no kernel known size
      IB/uverbs: Allow an empty namespace in ioctl() framework

Matthew Wilcox (1):
      IB/mad: Agent registration is process context only

Michael J. Ruhl (3):
      IB/hfi1: Remove INTx support and simplify MSIx usage
      IB/hfi1: Set in_use_ctxts bits for user ctxts only
      IB/hfi1: Remove incorrect call to do_interrupt callback

Mike Marciniszyn (10):
      IB/hfi1: Move normal functions from hfi1_devdata to const array
      IB/hfi1: Move rhf_offset from devdata to ctxtdata
      IB/hfi1: Remove rcvhdrsize
      IB/rdmavt, IB/hfi1: Create device dependent s_flags
      IB/hfi1: Remove rcvhdrq_size
      IB/hfi1: Remove rcvctrl from ctxtdata
      IB/hfi1: Rightsize ctxt_eager_bufs fields
      IB/hfi1: Remove unused/writeonly devdata fields
      IB/hfi1: Remove caches of chip CSRs
      IB/hfi1: Reorg ctxtdata and rightsize fields

Neil Horman (1):
      vmw_pvrdma: Release netdev when vmxnet3 module is removed

Or Gerlitz (1):
      MAINTAINERS: Moving out...

Parav Pandit (45):
      IB/core: Do not set the gid type when reserving default entries
      IB/core: Store default GID property per-table instead of per-entry
      IB/core: Introduce GID entry reference counts
      RDMA: Use GID from the ib_gid_attr during the add_gid() callback
      IB/core: Introduce GID attribute get, put and hold APIs
      IB/core: Replace ib_query_gid with rdma_get_gid_attr
      net/smc: Replace ib_query_gid with rdma_get_gid_attr
      IB: Replace ib_query_gid/ib_get_cached_gid with rdma_query_gid
      IB/rxe: Use rdma GID API
      IB: Ensure that all rdma_ah_attr's are zero initialized
      IB/core: Tidy ib_resolve_eth_dmac
      RDMA: Convert drivers to use sgid_attr instead of sgid_index
      IB/mlx4: Use GID attribute from ah attribute
      RDMA: Convert drivers to use the AH's sgid_attr in post_wr paths
      RDMA/cma: Consider net namespace while leaving multicast group
      IB/core: Free GID table entry during GID deletion
      IB: Make ib_init_ah_attr_from_wc set sgid_attr
      IB: Make ib_init_ah_from_mcmember set sgid_attr
      IB: Make init_ah_attr_grh_fields set sgid_attr
      IB/cm: Keep track of the sgid_attr that created the cm id
      IB/cm: Pass the sgid_attr through various events
      IB/cm: Replace members of sa_path_rec with 'struct sgid_attr *'
      IB/cm: Use sgid_attr from the AV
      IB/mlx5: Honor cnt_set_id_valid flag instead of set_id
      IB/core: Simplify check for RoCE route resolve
      IB/core: Introduce and use sgid_attr in CM requests
      RDMA/cma: Consider netdevice for RoCE ports
      RDMA/cma: Do not ignore net namespace for unbound cm_id
      RDMA/cma: Initialize resource type in __rdma_create_id()
      RDMA/cma: Simplify rdma_resolve_addr() error flow
      RDMA/core: Constify dst_addr argument
      RDMA/cma: Constify path record, ib_cm_event, listen_id pointers
      RDMA/cma: Get rid of 1 bit boolean
      RDMA/core: Return bool instead of int
      RDMA/core: Avoid holding lock while initializing fields on stack
      RDMA/core: Simplify gid type check in cma_acquire_dev()
      RDMA/core: Prefix _ib to IB/RoCE specific functions
      IB/ucm: Initialize sgid request GID attribute pointer
      IB/core: Add comment for change upper netevent handling
      IB/core: Avoid confusing del_netdev_default_ips
      IB/core: Delete lower netdevice default GID entries in bonding scenar=
io
      IB/core: Consider adding default GIDs of bond device
      IB/core: Add default GIDs of the bond master netdev
      IB/core: Update GID entries for netdevice whose mac address changes
      IB/core: Change filter function return type from int to bool

Potnuri Bharat Teja (3):
      iw_cxgb4: RDMA write with immediate support
      iw_cxgb4: Support FW write completion WR
      iw_cxgb4: pass window scale in flowc work request

Qing Huang (1):
      IB/mlx5: avoid excessive warning msgs when creating VFs on 2nd port

Raju Rangoju (3):
      rdma/cxgb4: Add support for 64Byte cqes
      rdma/cxgb4: Add support for srq functions & structs
      rdma/cxgb4: Add support for kernel mode SRQ's

Sagi Grimberg (1):
      IB/iser: set can_queue earlier to allow setting higher queue depth

Shiraz Saleem (1):
      i40iw: Reorganize acquire/release of locks in i40iw_manage_apbvt

Steve Wise (1):
      IB/core: add max_send_sge and max_recv_sge attributes

Talat Batheesh (1):
      IB/mlx5: Support RoCE ICRC encapsulated error counter

Tarick Bedeir (1):
      IB/mlx4: Test port number before querying type.

Varsha Rao (1):
      IB/core: Remove extra parentheses

Vijay Immanuel (3):
      IB/rxe: increase max MR limit
      IB/rxe: support for 802.1q VLAN on the listener
      IB/rxe: don't clear the tx queue on every transfer

Wei Yongjun (1):
      IB/ipoib: Fix error return code in ipoib_dev_init()

Yishai Hadas (22):
      IB/core: Introduce DECLARE_UVERBS_GLOBAL_METHODS
      IB/core: Expose ib_ucontext from a given ib_uverbs_file
      IB/mlx5: Introduce DEVX
      IB/mlx5: Add support for DEVX general command
      IB/mlx5: Add obj create and destroy functionality
      IB/mlx5: Add DEVX support for modify and query commands
      IB/mlx5: Add support for DEVX query UAR
      IB/mlx5: Add DEVX support for memory registration
      IB/mlx5: Add DEVX query EQN support
      IB/mlx5: Expose DEVX tree
      IB/mlx5: Add support for drain SQ & RQ
      IB/mlx4: Add support for drain SQ & RQ
      IB: Improve uverbs_cleanup_ucontext algorithm
      IB: Enable uverbs_destroy_def_handler to be used by drivers
      net/mlx5: Add forward compatible support for the FTE match data
      net/mlx5: Add support for flow table destination number
      IB/mlx5: Introduce flow steering matcher uapi object
      IB: Support ib_flow creation in drivers
      IB/mlx5: Introduce driver create and destroy flow methods
      IB/mlx5: Support adding flow steering rule by raw description
      IB/mlx5: Add support for a flow table destination for driver flow ste=
ering
      IB/mlx5: Enable driver uapi commands for flow steering

Yixian Liu (1):
      RDMA/hns: Support flush cqe for hip08 in kernel space

Yonatan Cohen (1):
      IB/mlx5: Expose dump and fill memory key

Yuval Bason (3):
      qedr: Add wrapping generic structure for qpidr and adjust idr routine=
s.
      qedr: Add support for kernel mode SRQ's
      qedr: Add user space support for SRQ

Yuval Shaia (1):
      RDMA/vmw_pvrdma: Delete unused function

Zhu Yanjun (2):
      IB/rxe: avoid unnecessary NULL check
      IB/rxe: Drop QP0 silently

oulijun (5):
      RDMA/hns: Fix endian conversions and annotations
      RDMA/hns: Add TSQ link table support
      RDMA/hns: Add TPQ link table support
      RDMA/hns: Update the implementation of set_gid
      RDMA/hns: Update the implementation of set_mac

willy@infradead.org (2):
      IDR: Expose the XArray lock
      IB/mad: Use IDR for agent IDs

 .mailmap                                           |    2 +
 MAINTAINERS                                        |   16 +-
 drivers/infiniband/Kconfig                         |    2 +-
 drivers/infiniband/core/Makefile                   |    5 +-
 drivers/infiniband/core/addr.c                     |   16 +-
 drivers/infiniband/core/cache.c                    |  724 ++++++++-----
 drivers/infiniband/core/cm.c                       |  147 +--
 drivers/infiniband/core/cm_msgs.h                  |    7 -
 drivers/infiniband/core/cma.c                      |  362 ++++---
 drivers/infiniband/core/core_priv.h                |    4 +-
 drivers/infiniband/core/device.c                   |   23 +-
 drivers/infiniband/core/mad.c                      |  113 +-
 drivers/infiniband/core/mad_priv.h                 |    7 +-
 drivers/infiniband/core/multicast.c                |   40 +-
 drivers/infiniband/core/nldev.c                    |   16 +-
 drivers/infiniband/core/rdma_core.c                | 1018 +++++++++++-----=
--
 drivers/infiniband/core/rdma_core.h                |   96 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |  306 ++++--
 drivers/infiniband/core/rw.c                       |    8 +-
 drivers/infiniband/core/sa_query.c                 |  138 ++-
 drivers/infiniband/core/sysfs.c                    |   66 +-
 drivers/infiniband/core/ucm.c                      |   15 +-
 drivers/infiniband/core/umem.c                     |   62 +-
 drivers/infiniband/core/user_mad.c                 |    1 +
 drivers/infiniband/core/uverbs.h                   |   34 +-
 drivers/infiniband/core/uverbs_cmd.c               |  599 +++++------
 drivers/infiniband/core/uverbs_ioctl.c             |  709 ++++++++-----
 drivers/infiniband/core/uverbs_ioctl_merge.c       |  664 ------------
 drivers/infiniband/core/uverbs_main.c              |  232 ++--
 drivers/infiniband/core/uverbs_marshall.c          |    2 -
 drivers/infiniband/core/uverbs_std_types.c         |  200 ++--
 .../infiniband/core/uverbs_std_types_counters.c    |  108 +-
 drivers/infiniband/core/uverbs_std_types_cq.c      |  154 ++-
 drivers/infiniband/core/uverbs_std_types_dm.c      |   61 +-
 .../infiniband/core/uverbs_std_types_flow_action.c |  170 +--
 drivers/infiniband/core/uverbs_std_types_mr.c      |   88 +-
 drivers/infiniband/core/uverbs_uapi.c              |  346 ++++++
 drivers/infiniband/core/verbs.c                    |  523 ++++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  144 +--
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   15 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   12 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cq.c              |   64 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   44 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h        |    8 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |   32 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   90 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |  269 +++--
 drivers/infiniband/hw/cxgb4/device.c               |   20 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |    5 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   57 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   56 +-
 drivers/infiniband/hw/cxgb4/qp.c                   | 1051 +++++++++++++++-=
--
 drivers/infiniband/hw/cxgb4/resource.c             |   51 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |  164 ++-
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h          |   68 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  205 ++--
 drivers/infiniband/hw/hfi1/chip.h                  |   30 +
 drivers/infiniband/hw/hfi1/driver.c                |   63 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   10 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |  243 ++---
 drivers/infiniband/hw/hfi1/init.c                  |   44 +-
 drivers/infiniband/hw/hfi1/pcie.c                  |   19 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   14 +-
 drivers/infiniband/hw/hfi1/qp.c                    |    6 +-
 drivers/infiniband/hw/hfi1/qp.h                    |   24 +-
 drivers/infiniband/hw/hfi1/rc.c                    |    6 +-
 drivers/infiniband/hw/hfi1/ruc.c                   |   14 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   10 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |   18 +-
 drivers/infiniband/hw/hfi1/vnic_main.c             |   12 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   21 +-
 drivers/infiniband/hw/hns/hns_roce_common.h        |    9 -
 drivers/infiniband/hw/hns/hns_roce_db.c            |    2 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |   45 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |    7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  430 +++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |    2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  698 ++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |  136 ++-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   15 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |    2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   55 +-
 drivers/infiniband/hw/i40iw/Kconfig                |    1 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   26 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |   83 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   54 +-
 drivers/infiniband/hw/mlx4/ah.c                    |   70 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   29 +-
 drivers/infiniband/hw/mlx4/main.c                  |   41 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   21 +-
 drivers/infiniband/hw/mlx4/qp.c                    |  421 ++++----
 drivers/infiniband/hw/mlx4/srq.c                   |    4 +-
 drivers/infiniband/hw/mlx5/Makefile                |    2 +
 drivers/infiniband/hw/mlx5/ah.c                    |   11 +-
 drivers/infiniband/hw/mlx5/cmd.c                   |   12 +
 drivers/infiniband/hw/mlx5/cmd.h                   |    1 +
 drivers/infiniband/hw/mlx5/cong.c                  |    9 +-
 drivers/infiniband/hw/mlx5/cq.c                    |    2 +-
 drivers/infiniband/hw/mlx5/devx.c                  | 1119 ++++++++++++++++=
++++
 drivers/infiniband/hw/mlx5/flow.c                  |  252 +++++
 drivers/infiniband/hw/mlx5/gsi.c                   |    8 +-
 drivers/infiniband/hw/mlx5/main.c                  |  570 +++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   85 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   34 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  294 +++--
 drivers/infiniband/hw/mlx5/srq.c                   |    4 +-
 drivers/infiniband/hw/mthca/mthca_av.c             |    5 +-
 drivers/infiniband/hw/mthca/mthca_dev.h            |   24 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |    7 +-
 drivers/infiniband/hw/mthca/mthca_qp.c             |   24 +-
 drivers/infiniband/hw/mthca/mthca_srq.c            |    8 +-
 drivers/infiniband/hw/nes/nes.h                    |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    8 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    6 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   74 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   32 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h           |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   26 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   50 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |   12 +-
 drivers/infiniband/hw/qedr/main.c                  |  107 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   43 +-
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |   11 +
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   12 +-
 drivers/infiniband/hw/qedr/qedr_roce_cm.c          |   37 +-
 drivers/infiniband/hw/qedr/qedr_roce_cm.h          |    8 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  625 +++++++++--
 drivers/infiniband/hw/qedr/verbs.h                 |   17 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    3 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |    5 +-
 drivers/infiniband/hw/usnic/Kconfig                |    2 +-
 drivers/infiniband/hw/usnic/usnic_fwd.c            |    4 +-
 drivers/infiniband/hw/usnic/usnic_fwd.h            |    2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   10 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |    8 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   40 +-
 drivers/infiniband/hw/usnic/usnic_uiom.h           |    5 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |    5 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |   26 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   52 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   11 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c      |    7 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |    6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |   15 +-
 drivers/infiniband/sw/rdmavt/ah.c                  |    4 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   27 +-
 drivers/infiniband/sw/rdmavt/qp.h                  |   12 +-
 drivers/infiniband/sw/rdmavt/srq.c                 |    2 +-
 drivers/infiniband/sw/rxe/rxe.c                    |    3 +-
 drivers/infiniband/sw/rxe/rxe_av.c                 |   30 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |    1 +
 drivers/infiniband/sw/rxe/rxe_loc.h                |    5 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   67 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |    2 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   31 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |   24 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |    5 +
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   70 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   32 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   81 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c            |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   15 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  444 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   23 -
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |  261 +++--
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   16 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |    5 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   14 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   26 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   27 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   71 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    5 +
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   81 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   37 +-
 drivers/nvme/host/rdma.c                           |   13 +-
 drivers/nvme/target/rdma.c                         |   13 +-
 fs/cifs/smbdirect.c                                |   32 +-
 include/linux/idr.h                                |   11 +
 include/linux/mlx5/driver.h                        |    3 -
 include/linux/mlx5/fs.h                            |    1 +
 include/linux/mlx5/mlx5_ifc.h                      |    5 +
 include/linux/overflow.h                           |   31 +
 include/rdma/ib.h                                  |    4 +-
 include/rdma/ib_addr.h                             |    6 +-
 include/rdma/ib_cache.h                            |   83 +-
 include/rdma/ib_cm.h                               |   18 +-
 include/rdma/ib_mad.h                              |   33 +
 include/rdma/ib_sa.h                               |   49 +-
 include/rdma/ib_verbs.h                            |  257 +++--
 include/rdma/opa_addr.h                            |    2 +-
 include/rdma/rdma_cm.h                             |    2 +-
 include/rdma/rdmavt_qp.h                           |   30 +-
 include/rdma/uverbs_ioctl.h                        |  627 ++++++-----
 include/rdma/uverbs_named_ioctl.h                  |  109 +-
 include/rdma/uverbs_std_types.h                    |   96 +-
 include/rdma/uverbs_types.h                        |  133 +--
 include/uapi/rdma/cxgb4-abi.h                      |   32 +-
 include/uapi/rdma/hns-abi.h                        |    1 +
 include/uapi/rdma/ib_user_ioctl_cmds.h             |    7 +-
 include/uapi/rdma/ib_user_ioctl_verbs.h            |   58 +
 include/uapi/rdma/ib_user_verbs.h                  |    5 +-
 include/uapi/rdma/mlx5-abi.h                       |    6 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  121 +++
 include/uapi/rdma/qedr-abi.h                       |   17 +
 include/uapi/rdma/rdma_user_ioctl_cmds.h           |    7 +-
 lib/test_overflow.c                                |  198 +++-
 net/9p/trans_rdma.c                                |    8 +-
 net/core/secure_seq.c                              |    1 +
 net/rds/ib.c                                       |    2 +-
 net/rds/ib_frmr.c                                  |   11 +-
 net/rds/ib_recv.c                                  |    6 +-
 net/rds/ib_send.c                                  |    6 +-
 net/smc/smc_core.c                                 |    1 +
 net/smc/smc_ib.c                                   |    1 +
 net/smc/smc_tx.c                                   |    3 +-
 net/smc/smc_wr.c                                   |    9 +-
 net/smc/smc_wr.h                                   |    3 +-
 net/sunrpc/xprtrdma/fmr_ops.c                      |    4 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |    7 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |    3 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |    3 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |    3 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    2 +-
 net/sunrpc/xprtrdma/verbs.c                        |    5 +-
 233 files changed, 12380 insertions(+), 7059 deletions(-)
 delete mode 100644 drivers/infiniband/core/uverbs_ioctl_merge.c
 create mode 100644 drivers/infiniband/core/uverbs_uapi.c
 create mode 100644 drivers/infiniband/hw/mlx5/devx.c
 create mode 100644 drivers/infiniband/hw/mlx5/flow.c

Merge resolution diff:

diff --cc drivers/infiniband/core/rdma_core.c
index 12e7c6c102c136,475910ffbcb680..6eb64c6f08028b
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@@ -77,201 -120,19 +77,201 @@@ static int uverbs_try_lock_object(struc
  	 * concurrently, setting the counter to zero is enough for releasing
  	 * this lock.
  	 */
 -	if (!exclusive)
 +	switch (mode) {
 +	case UVERBS_LOOKUP_READ:
- 		return __atomic_add_unless(&uobj->usecnt, 1, -1) =3D=3D -1 ?
+ 		return atomic_fetch_add_unless(&uobj->usecnt, 1, -1) =3D=3D -1 ?
  			-EBUSY : 0;
 +	case UVERBS_LOOKUP_WRITE:
 +		/* lock is exclusive */
 +		return atomic_cmpxchg(&uobj->usecnt, 0, -1) =3D=3D 0 ? 0 : -EBUSY;
 +	case UVERBS_LOOKUP_DESTROY:
 +		return 0;
 +	}
 +	return 0;
 +}
 +
 +static void assert_uverbs_usecnt(struct ib_uobject *uobj,
 +				 enum rdma_lookup_mode mode)
 +{
 +#ifdef CONFIG_LOCKDEP
 +	switch (mode) {
 +	case UVERBS_LOOKUP_READ:
 +		WARN_ON(atomic_read(&uobj->usecnt) <=3D 0);
 +		break;
 +	case UVERBS_LOOKUP_WRITE:
 +		WARN_ON(atomic_read(&uobj->usecnt) !=3D -1);
 +		break;
 +	case UVERBS_LOOKUP_DESTROY:
 +		break;
 +	}
 +#endif
 +}
 +
 +/*
 + * This must be called with the hw_destroy_rwsem locked for read or write,
 + * also the uobject itself must be locked for write.
 + *
 + * Upon return the HW object is guaranteed to be destroyed.
 + *
 + * For RDMA_REMOVE_ABORT, the hw_destroy_rwsem is not required to be held,
 + * however the type's allocat_commit function cannot have been called and=
 the
 + * uobject cannot be on the uobjects_lists
 + *
 + * For RDMA_REMOVE_DESTROY the caller shold be holding a kref (eg via
 + * rdma_lookup_get_uobject) and the object is left in a state where the c=
aller
 + * needs to call rdma_lookup_put_uobject.
 + *
 + * For all other destroy modes this function internally unlocks the uobje=
ct
 + * and consumes the kref on the uobj.
 + */
 +static int uverbs_destroy_uobject(struct ib_uobject *uobj,
 +				  enum rdma_remove_reason reason)
 +{
 +	struct ib_uverbs_file *ufile =3D uobj->ufile;
 +	unsigned long flags;
 +	int ret;
 +
 +	lockdep_assert_held(&ufile->hw_destroy_rwsem);
 +	assert_uverbs_usecnt(uobj, UVERBS_LOOKUP_WRITE);
 +
 +	if (uobj->object) {
 +		ret =3D uobj->uapi_object->type_class->destroy_hw(uobj, reason);
 +		if (ret) {
 +			if (ib_is_destroy_retryable(ret, reason, uobj))
 +				return ret;
 +
 +			/* Nothing to be done, dangle the memory and move on */
 +			WARN(true,
 +			     "ib_uverbs: failed to remove uobject id %d, driver err=3D%d",
 +			     uobj->id, ret);
 +		}
 +
 +		uobj->object =3D NULL;
 +	}
 =20
 -	/* lock is either WRITE or DESTROY - should be exclusive */
 -	return atomic_cmpxchg(&uobj->usecnt, 0, -1) =3D=3D 0 ? 0 : -EBUSY;
 +	if (reason =3D=3D RDMA_REMOVE_ABORT) {
 +		WARN_ON(!list_empty(&uobj->list));
 +		WARN_ON(!uobj->context);
 +		uobj->uapi_object->type_class->alloc_abort(uobj);
 +	}
 +
 +	uobj->context =3D NULL;
 +
 +	/*
 +	 * For DESTROY the usecnt is held write locked, the caller is expected
 +	 * to put it unlock and put the object when done with it. Only DESTROY
 +	 * can remove the IDR handle.
 +	 */
 +	if (reason !=3D RDMA_REMOVE_DESTROY)
 +		atomic_set(&uobj->usecnt, 0);
 +	else
 +		uobj->uapi_object->type_class->remove_handle(uobj);
 +
 +	if (!list_empty(&uobj->list)) {
 +		spin_lock_irqsave(&ufile->uobjects_lock, flags);
 +		list_del_init(&uobj->list);
 +		spin_unlock_irqrestore(&ufile->uobjects_lock, flags);
 +
 +		/*
 +		 * Pairs with the get in rdma_alloc_commit_uobject(), could
 +		 * destroy uobj.
 +		 */
 +		uverbs_uobject_put(uobj);
 +	}
 +
 +	/*
 +	 * When aborting the stack kref remains owned by the core code, and is
 +	 * not transferred into the type. Pairs with the get in alloc_uobj
 +	 */
 +	if (reason =3D=3D RDMA_REMOVE_ABORT)
 +		uverbs_uobject_put(uobj);
 +
 +	return 0;
  }
 =20
 -static struct ib_uobject *alloc_uobj(struct ib_ucontext *context,
 -				     const struct uverbs_obj_type *type)
 +/*
 + * This calls uverbs_destroy_uobject() using the RDMA_REMOVE_DESTROY
 + * sequence. It should only be used from command callbacks. On success the
 + * caller must pair this with rdma_lookup_put_uobject(LOOKUP_WRITE). This
 + * version requires the caller to have already obtained an
 + * LOOKUP_DESTROY uobject kref.
 + */
 +int uobj_destroy(struct ib_uobject *uobj)
  {
 -	struct ib_uobject *uobj =3D kzalloc(type->obj_size, GFP_KERNEL);
 +	struct ib_uverbs_file *ufile =3D uobj->ufile;
 +	int ret;
 +
 +	down_read(&ufile->hw_destroy_rwsem);
 +
 +	ret =3D uverbs_try_lock_object(uobj, UVERBS_LOOKUP_WRITE);
 +	if (ret)
 +		goto out_unlock;
 +
 +	ret =3D uverbs_destroy_uobject(uobj, RDMA_REMOVE_DESTROY);
 +	if (ret) {
 +		atomic_set(&uobj->usecnt, 0);
 +		goto out_unlock;
 +	}
 =20
 +out_unlock:
 +	up_read(&ufile->hw_destroy_rwsem);
 +	return ret;
 +}
 +
 +/*
 + * uobj_get_destroy destroys the HW object and returns a handle to the uo=
bj
 + * with a NULL object pointer. The caller must pair this with
 + * uverbs_put_destroy.
 + */
 +struct ib_uobject *__uobj_get_destroy(const struct uverbs_api_object *obj,
 +				      u32 id, struct ib_uverbs_file *ufile)
 +{
 +	struct ib_uobject *uobj;
 +	int ret;
 +
 +	uobj =3D rdma_lookup_get_uobject(obj, ufile, id, UVERBS_LOOKUP_DESTROY);
 +	if (IS_ERR(uobj))
 +		return uobj;
 +
 +	ret =3D uobj_destroy(uobj);
 +	if (ret) {
 +		rdma_lookup_put_uobject(uobj, UVERBS_LOOKUP_DESTROY);
 +		return ERR_PTR(ret);
 +	}
 +
 +	return uobj;
 +}
 +
 +/*
 + * Does both uobj_get_destroy() and uobj_put_destroy().  Returns success_=
res
 + * on success (negative errno on failure). For use by callers that do not=
 need
 + * the uobj.
 + */
 +int __uobj_perform_destroy(const struct uverbs_api_object *obj, u32 id,
 +			   struct ib_uverbs_file *ufile, int success_res)
 +{
 +	struct ib_uobject *uobj;
 +
 +	uobj =3D __uobj_get_destroy(obj, id, ufile);
 +	if (IS_ERR(uobj))
 +		return PTR_ERR(uobj);
 +
 +	rdma_lookup_put_uobject(uobj, UVERBS_LOOKUP_WRITE);
 +	return success_res;
 +}
 +
 +/* alloc_uobj must be undone by uverbs_destroy_uobject() */
 +static struct ib_uobject *alloc_uobj(struct ib_uverbs_file *ufile,
 +				     const struct uverbs_api_object *obj)
 +{
 +	struct ib_uobject *uobj;
 +	struct ib_ucontext *ucontext;
 +
 +	ucontext =3D ib_uverbs_get_ucontext(ufile);
 +	if (IS_ERR(ucontext))
 +		return ERR_CAST(ucontext);
 +
 +	uobj =3D kzalloc(obj->type_attrs->obj_size, GFP_KERNEL);
  	if (!uobj)
  		return ERR_PTR(-ENOMEM);
  	/*
diff --cc drivers/nvme/host/rdma.c
index 72e8e8e7d2d7cd,0805fa6215eefb..dc042017c293ad
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@@ -374,6 -377,8 +377,8 @@@ nvme_rdma_find_get_device(struct rdma_c
  		goto out_free_pd;
  	}
 =20
+ 	ndev->num_inline_segments =3D min(NVME_RDMA_MAX_INLINE_SEGMENTS,
 -					ndev->dev->attrs.max_sge - 1);
++					ndev->dev->attrs.max_send_sge - 1);
  	list_add(&ndev->entry, &device_list);
  out_unlock:
  	mutex_unlock(&device_list_mutex);
diff --cc drivers/nvme/target/rdma.c
index 1a642e214a4ce2,e7f43d1e17797f..3533e918ea376b
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@@ -382,13 -435,22 +435,21 @@@ static void nvmet_rdma_free_rsps(struc
  static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
  		struct nvmet_rdma_cmd *cmd)
  {
 -	struct ib_recv_wr *bad_wr;
+ 	int ret;
+=20
  	ib_dma_sync_single_for_device(ndev->device,
  		cmd->sge[0].addr, cmd->sge[0].length,
  		DMA_FROM_DEVICE);
 =20
  	if (ndev->srq)
- 		return ib_post_srq_recv(ndev->srq, &cmd->wr, NULL);
- 	return ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, NULL);
 -		ret =3D ib_post_srq_recv(ndev->srq, &cmd->wr, &bad_wr);
++		ret =3D ib_post_srq_recv(ndev->srq, &cmd->wr, NULL);
+ 	else
 -		ret =3D ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, &bad_wr);
++		ret =3D ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, NULL);
+=20
+ 	if (unlikely(ret))
+ 		pr_err("post_recv cmd failed\n");
+=20
+ 	return ret;
  }
 =20
  static void nvmet_rdma_process_wr_wait_list(struct nvmet_rdma_queue *queu=
e)
@@@ -491,7 -553,7 +552,7 @@@ static void nvmet_rdma_queue_response(s
  		rsp->send_sge.addr, rsp->send_sge.length,
  		DMA_TO_DEVICE);
 =20
- 	if (ib_post_send(cm_id->qp, first_wr, NULL)) {
 -	if (unlikely(ib_post_send(cm_id->qp, first_wr, &bad_wr))) {
++	if (unlikely(ib_post_send(cm_id->qp, first_wr, NULL))) {
  		pr_err("sending cmd response failed\n");
  		nvmet_rdma_release_rsp(rsp);
  	}
@@@ -805,6 -890,18 +889,18 @@@ nvmet_rdma_find_get_device(struct rdma_
  	if (!ndev)
  		goto out_err;
 =20
+ 	inline_page_count =3D num_pages(port->inline_data_size);
+ 	inline_sge_count =3D max(cm_id->device->attrs.max_sge_rd,
 -				cm_id->device->attrs.max_sge) - 1;
++				cm_id->device->attrs.max_recv_sge) - 1;
+ 	if (inline_page_count > inline_sge_count) {
+ 		pr_warn("inline_data_size %d cannot be supported by device %s. Reducing=
 to %lu.\n",
+ 			port->inline_data_size, cm_id->device->name,
+ 			inline_sge_count * PAGE_SIZE);
+ 		port->inline_data_size =3D inline_sge_count * PAGE_SIZE;
+ 		inline_page_count =3D inline_sge_count;
+ 	}
+ 	ndev->inline_data_size =3D port->inline_data_size;
+ 	ndev->inline_page_count =3D inline_page_count;
  	ndev->device =3D cm_id->device;
  	kref_init(&ndev->ref);
 =20
diff --cc net/rds/ib_recv.c
index 4c5a937304b274,d300186b8dc020..2f16146e4ec94e
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@@ -416,10 -415,10 +414,10 @@@ void rds_ib_recv_refill(struct rds_conn
  				&recv->r_frag->f_sg));
 =20
  		/* XXX when can this fail? */
 -		ret =3D ib_post_recv(ic->i_cm_id->qp, &recv->r_wr, &failed_wr);
 +		ret =3D ib_post_recv(ic->i_cm_id->qp, &recv->r_wr, NULL);
  		if (ret) {
  			rds_ib_conn_error(conn, "recv post on "
- 			       "%pI4 returned %d, disconnecting and "
+ 			       "%pI6c returned %d, disconnecting and "
  			       "reconnecting\n", &conn->c_faddr,
  			       ret);
  			break;
diff --cc net/rds/ib_send.c
index 8ac80c1b051e1a,c8dd3125d39877..2dcb555e6350d1
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@@ -758,8 -758,7 +758,7 @@@ int rds_ib_xmit_atomic(struct rds_conne
  {
  	struct rds_ib_connection *ic =3D conn->c_transport_data;
  	struct rds_ib_send_work *send =3D NULL;
 -	struct ib_send_wr *failed_wr;
 +	const struct ib_send_wr *failed_wr;
- 	struct rds_ib_device *rds_ibdev;
  	u32 pos;
  	u32 work_alloc;
  	int ret;
diff --cc net/smc/smc_wr.c
index de1a438cf9773f,f856b8402b3fe5..3c458d27985574
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@@ -246,14 -239,11 +238,10 @@@ int smc_wr_tx_send(struct smc_link *lin
  	ib_req_notify_cq(link->smcibdev->roce_cq_send,
  			 IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
  	pend =3D container_of(priv, struct smc_wr_tx_pend, priv);
 -	rc =3D ib_post_send(link->roce_qp, &link->wr_tx_ibs[pend->idx],
 -			  &failed_wr);
 +	rc =3D ib_post_send(link->roce_qp, &link->wr_tx_ibs[pend->idx], NULL);
  	if (rc) {
- 		struct smc_link_group *lgr =3D
- 			container_of(link, struct smc_link_group,
- 				     lnk[SMC_SINGLE_LINK]);
-=20
  		smc_wr_tx_put_slot(link, priv);
- 		smc_lgr_terminate(lgr);
+ 		smc_lgr_terminate(smc_get_lgr(link));
  	}
  	return rc;
  }

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlt180MACgkQOG33FX4g
mxr9GxAAhfaxgTd2sPXqiMNBsh88tdnJejOwpINJG6t1zVLc7Eb5W5WZ0btGTNC7
fCFsK98l7SSEi/lpHrUCGL4465EyZiPJDU/my4nMvzXR1Op7VRV8jAlyfbCsLv1n
bDlRLwmAHNTPJyxNKU04BMjtVPno4UhL7Sz3IOkOpolo13OOZ5UhfC923JZ5hnLS
d2LZox3G2USzZv2fjNLinEw7Xlx57lLvWJ8CegTfBFxH5u6aTsXdleRIZW/Lxd6f
CWXcCiZFkjGQrWcINEZ+nVaLUcuouFumLTXNXum1kHlY0TZXl7qLs4NsJ59FIrmb
p4YtKwC3hgVlQjF6pk0t63p7iLoh7tGnVBPLYDuB4bxUMMaNBHQVXm939f/wH7Ck
+JC/j101w+A4HPtNP8R143ZCT3SLBU+yTLsIqmc6J/gv6g0609pkDG+iO8VJjKgx
8mWN4eScuN1ztdCaWo5RDs9Lxuo2pg7Ttn0pFDeapj/vS07+rRQoKvFx2qyorq/w
A44tVxY8R0JhYsTlx8gX254sY4ugIbSvlrP0eX7aEWHCBnHCC3iZBwRcDlfT0rTn
QylSPv1m/XWSNeSfBUfXFmCLNXyUi+ic7BKdQ6DjFheXr5qAeOMBHeBRYTRADlHY
UsrFg8ErB1sJz6fH9PWJiD2ilhonjInutGx9GaHtd2mrvnDg2Pw=
=I5wV
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
