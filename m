From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 6 Apr 2018 10:05:41 -0600
Message-ID: <20180406160541.GA28094@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are the RDMA patches for for 4.17.

This cycle we have some interesting conflicts, a syzkaller related bug fix =
in
rc clashed very badly with the Mellanox shared pull request. Doug made the
resolution in the RDMA tree for-next tree and DaveM refered to it when he
pulled in the same patches. This turned out to create two commits to the sa=
me
file which then also creates an unexpected conflict here. In retrospect
perhaps we should have tried to push the conflict resolution as a shared pa=
tch
as well.

So at this point we have conflicts between net-next, RDMA for-rc and RDMA
for-next. As before I've resolved them in the top commit, but this couldn't
be done against a nice tag. I choose to use your merge of net-next, which
has all the necessary patches.

The for-linus-unmerged tag is the same PR without this resolution. In this
case the conflicts are easy to resolve by hand. Just deleting the conflict
markers is correct in every case execpt umca.c which requires this:

-       ctx->cm_id =3D __rdma_create_id(current->nsproxy->net_ns,
-                             ucma_event_handler, ctx, cmd.ps, qp_type, NUL=
L);
-       if (IS_ERR(ctx->cm_id)) {
-               ret =3D PTR_ERR(ctx->cm_id);
 -      cm_id =3D rdma_create_id(current->nsproxy->net_ns,
 -                             ucma_event_handler, ctx, cmd.ps, qp_type);
++      cm_id =3D __rdma_create_id(current->nsproxy->net_ns,
++                             ucma_event_handler, ctx, cmd.ps, qp_type, NU=
LL);
+       if (IS_ERR(cm_id)) {
+               ret =3D PTR_ERR(cm_id);

Doug and I are at a conference next week so if another PR is sent I expect =
it
to only be bug fixes. Parav noted yesterday that there are some fringe case
behavior changes in his work that he would like to fix, and I see that Intel
has a number of rc looking patches for HFI1 they posted yesterday.

Parav is again the biggest contributor by patch count with his ongoing work=
 to
enable container support in the RDMA stack, followed by Leon doing syzkaller
inspired cleanups, though most of the actual fixing went to RC.

There is one uncomfortable series here fixing the user ABI to actually work=
 as
intended in 32 bit mode. There are lots of notes in the commit messages, but
the basic summary is we don't think there is an actual 32 bit kernel user of
drivers/infiniband for several good reasons. However we are seeing people w=
ant
to use a 32 bit user space with 64 bit kernel, which didn't completely work
today. So in fixing it we required a 32 bit rxe user to upgrade their
userspace. rxe users are still already quite rare and we think a 32 bit one=
 is
non-existing.

Thanks,
Jason

The following changes since commit 5bb053bef82523a8fd78d650bca81c9f114fa276:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2018-=
04-03 14:04:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 423009d1cbb77b67f6eba65efd116874e6b6b69d:

  Merge net-next of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/=
linux-2.6.git (2018-04-05 20:57:10 -0600)

----------------------------------------------------------------
Merge candidates for 4.17 merge window

- Fix RDMA uapi headers to actually compile in userspace and be more
  complete

- Three shared with netdev pull requests from Mellanox:

   * 7 patches, mostly to net with 1 IB related one at the back). This
     series addresses an IRQ performance issue (patch 1), cleanups related =
to
     the fix for the IRQ performance problem (patches 2-6), and then extends
     the fragmented completion queue support that already exists in the net
     side of the driver to the ib side of the driver (patch 7).

   * Mostly IB, with 5 patches to net that are needed to support the remain=
ing
     10 patches to the IB subsystem. This series extends the current
     'representor' framework when the mlx5 driver is in switchdev mode from
     being a netdev only construct to being a netdev/IB dev construct. The =
IB
     dev is limited to raw Eth queue pairs only, but by having an IB dev of
     this type attached to the representor for a switchdev port, it enables
     DPDK to work on the switchdev device.

   * All net related, but needed as infrastructure for the rdma driver

- Updates for the hns, i40iw, bnxt_re, cxgb3, cxgb4, hns drivers

- SRP performance updates

- IB uverbs write path cleanup patch series from Leon

- Add RDMA_CM support to ib_srpt. This is disabled by default.  Users need =
to
  set the port for ib_srpt to listen on in configfs in order for it to be
  enabled (/sys/kernel/config/target/srpt/discovery_auth/rdma_cm_port)

- TSO and Scatter FCS support in mlx4

- Refactor of modify_qp routine to resolve problems seen while working on n=
ew
  code that is forthcoming

- More refactoring and updates of RDMA CM for containers support from Parav

- mlx5 'fine grained packet pacing', 'ipsec offload' and 'device memory'
  user API features

- Infrastructure updates for the new IOCTL interface, based on increased us=
age

- ABI compatibility bug fixes to fully support 32 bit userspace on 64 bit
  kernel as was originally intended. See the commit messages for
  extensive details

- Syzkaller bugs and code cleanups motivated by them

----------------------------------------------------------------
Andrew Morton (2):
      drivers/infiniband/core/verbs.c: fix build with gcc-4.4.4
      drivers/infiniband/ulp/srpt/ib_srpt.c: fix build with gcc-4.4.4

Andy Shevchenko (1):
      RDMA/hns: Replace __raw_write*(cpu_to_le*()) with LE write*()

Ariel Levkovich (8):
      IB/uverbs: Expose device memory capabilities to user
      IB/uverbs: Add device memory capabilities reporting
      IB/uverbs: Add alloc/free dm uverbs ioctl support
      IB/uverbs: Add device memory registration ioctl support
      net/mlx5: Query device memory capabilities
      IB/mlx5: Device memory support in mlx5_ib
      net/mlx5: Mkey creation command adjustments
      IB/mlx5: Device memory mr registration support

Arnd Bergmann (3):
      infiniband: qplib_fp: fix pointer cast
      infiniband: bnxt_re: use BIT_ULL() for 64-bit bit masks
      RDMA/i40iw: include linux/irq.h

Arushi (1):
      infiniband: hw: Drop unnecessary continue

Aviad Yehezkel (3):
      IB/mlx5: Add implementation for create and destroy action_xfrm
      {net,IB}/mlx5: Add ipsec helper
      IB/mlx5: Add IPsec support for egress and ingress

Bart Van Assche (13):
      IB/srp: Fix completion vector assignment algorithm
      IB/srp: Fix srp_abort()
      Revert "IB/srp: Avoid that a cable pull can trigger a kernel crash"
      IB/srp: Use %pIS instead of inet_ntop()
      RDMA/core: Avoid that ib_drain_qp() triggers an out-of-bounds stack a=
ccess
      RDMA/rxe: Fix an out-of-bounds read
      IB/srpt: Fix an out-of-bounds stack access in srpt_zerolength_write()
      IB/hfi1: Add a missing rcu_read_unlock()
      IB/srpt: Add RDMA/CM support
      IB/hfi1: Fix a kernel-doc warning
      RDMA/bnxt_re: Remove an unused variable
      IB/srp: Fix IPv6 address parsing
      IB/srp: Disallow duplicate RDMA/CM connections

Bharat Potnuri (1):
      iw_cxgb4: print mapped ports correctly

Bodong Wang (2):
      net/mlx5: Packet pacing enhancement
      IB/mlx5: Packet packing enhancement for RAW QP

Boris Pismenny (2):
      IB/mlx4: Check for egress flow steering
      IB/uverbs: Introduce egress flow steering

Colin Ian King (2):
      infiniband: remove redundant assignment to pointer 'rdi'
      qedr: Fix spelling mistake: "hanlde" -> "handle"

Corentin Labbe (1):
      IB/cxgb3: remove cxio_dbg.c

Daniel Jurgens (1):
      IB/mlx5: Only synchronize RCU once when removing mkeys

Doug Ledford (6):
      Merge tag 'mlx5-updates-2018-02-21' of git://git.kernel.org/.../mella=
nox/linux into k.o/wip/dl-for-next
      Merge branch 'k.o/for-rc' into k.o/wip/dl-for-next
      Merge tag 'mlx5-updates-2018-02-23' of git://git.kernel.org/.../mella=
nox/linux into k.o/wip/dl-for-next
      Merge tag 'mlx5-updates-2018-02-28-1' of git://git.kernel.org/.../mel=
lanox/linux into k.o/wip/dl-for-next
      Merge tag 'mlx5-updates-2018-02-28-2' of git://git.kernel.org/.../mel=
lanox/linux into k.o/wip/dl-for-next
      Merge branch 'k.o/wip/dl-for-rc' into k.o/wip/dl-for-next

Gustavo A. R. Silva (2):
      RDMA/bnxt_re/qplib_sp: Use true and false for boolean values
      IB/ocrdma_hw: Remove redundant checks and goto labels

Guy Levi (1):
      IB/mlx4: Add Scatter FCS support over WQ creation

Henry Orosco (2):
      i40iw: Refactor of driver generated AEs
      i40iw: Tear-down connection after CQP Modify QP failure

Hern=C3=A1n Gonzalez (3):
      IB/qib: Remove unused variable (char *qib_sdma_event_names[])
      IB/qib: Move char *qib_sdma_state_names[] and constify while there.
      IB/rxe: Remove unused variable (char *rxe_qp_state_name[])

Honggang Li (2):
      IB/core: Set speed string to SDR for invalid active rates
      IB/mlx5: Set the default active rate and width to QDR and 4X

Ilya Lesokhin (1):
      IB/mlx5: Maintain a single emergency page

Jason Gunthorpe (23):
      RDMA: Do not used __packed in uapi headers
      rxe: Do not use 'struct sockaddr' in a uapi header
      IB/uverbs: Tidy uverbs_uobject_add
      RDMA/rxe: Get rid of confusing udata parameter to rxe_cq_chk_attr
      RDMA/rxe: Use structs to describe the uABI instead of opencoding
      RDMA/mlx4: Move flag constants to uapi header
      RDMA/i40iw: Move uapi header to include/uapi
      RDMA/hns: Use structs to describe the uABI instead of opencoding
      RDMA/cxgb4: Use structs to describe the uABI instead of opencoding
      RDMA/bnxt: Fix structure layout for bnxt_re_pd_resp
      RDMA/cxgb3: Use structs to describe the uABI instead of opencoding
      RDMA/ocrdma: Fix structure layout for ocrdma_alloc_pd
      RDMA: Remove minor pahole differences between 32/64
      RDMA/ucma: Fix uABI structure layouts for 32/64 compat
      RDMA/qedr: Fix uABI structure layouts for 32/64 compat
      RDMA/mlx4: Fix uABI structure layouts for 32/64 compat
      RDMA/rxe: Fix uABI structure layouts for 32/64 compat
      RDMA: Change all uapi headers to use __aligned_u64 instead of __u64
      Merge branch '32compat'
      RDMA: Use u64_to_user_ptr everywhere
      RDMA/mlx5: Fix definition of mlx5_ib_create_qp_resp
      RDMA/qedr: Zero stack memory before copying to user space
      Merge net-next of git://git.kernel.org/.../torvalds/linux-2.6.git

Kalderon, Michal (1):
      RDMA/qedr: Fix wmb usage in qedr

Leon Romanovsky (28):
      RDMA/uverbs: Convert command mask validity check function to be bool
      RDMA/uverbs: Update sizeof users
      RDMA/uverbs: Refactor flags checks and update return value
      RDMA/uverbs: Fail as early as possible if not enough header data was =
provided
      RDMA/uverbs: Return not supported error code for unsupported commands
      RDMA/uverbs: Unify return values of not supported command
      RDMA/uverbs: Refactor command header processing
      RDMA/uverbs: Properly check command supported mask
      RDMA/uverbs: Move uncontext check before SRCU read lock
      RDMa/uverbs: Copy ex_hdr outside of SRCU read lock
      RDMA/uverbs: Refactor the header validation logic
      RDMA/uverbs: Replace user's types with kernel's types
      RDMA/uverbs: Reduce number of command header flags checks
      RDMA/verbs: Return proper error code for not supported system call
      mailmap: Map Leon Romanovsky's emails
      RDMA/mlx5: Refactor QP type check to be as early as possible
      RDMA/mlx5: Fix NULL dereference while accessing XRC_TGT QPs
      RDMA/uverbs: Ensure validity of current QP state value
      RDMA/pvrdma: Properly annotate QP states
      RDMA/verbs: Simplify modify QP check
      RDMA/mlx5: Protect from NULL pointer derefence
      RDMA/mlx5: Return proper value for not-supported command
      RDMA/mlx5: Unify error flows in rereg MR failure paths
      RDMA/mlx5: Guard ODP specific assignments with specific CONFIG
      RDMA/mlx5: Simplify clean and destroy MR calls
      RDMA/restrack: Don't rely on uninitialized variable in restrack_add f=
low
      RDMA/restrack: Remove ambiguity in resource track clean logic
      RDMA/nldev: Provide netdevice name and index

Majd Dibbiny (2):
      IB/mlx5: Enable ECN capable bits for UD RoCE v2 QPs
      IB/mlx5: Respect new UMR capabilities

Mark Bloch (2):
      IB/mlx5: Expose more priorities for bypass namespace
      IB/core: Protect against concurrent access to hardware stats

Markus Elfring (2):
      IB/usnic: Delete an error message for a failed memory allocation in u=
snic_transport_init()
      RDMA/iwpm: Delete an error message for a failed memory allocation in =
iwpm_create_nlmsg()

Martin Wilck (1):
      rdma_rxe: make rxe work over 802.1q VLAN devices

Matan Barak (19):
      IB/uverbs: Move to new headers and make naming consistent
      IB/uverbs: Extend uverbs_ioctl header with driver_id
      IB/uverbs: Enable compact representation of uverbs_attr_spec
      IB/uverbs: Safely extend existing attributes
      IB/uverbs: Expose parsing tree of all common objects to providers
      IB/uverbs: Move ioctl path of create_cq and destroy_cq to a new file
      IB/uverbs: Add macros to simplify adding driver specific attributes
      IB/uverbs: Enable ioctl() uAPI by default for new verbs
      IB/uverbs: UAPI pointers should use __aligned_u64 type
      IB/mlx5: Initialize the parsing tree root without the help of uverbs
      IB/uverbs: Add enum attribute type to ioctl() interface
      IB/uverbs: Refactor kern_spec_to_ib_spec_filter
      IB/uverbs: Add flow_action create and destroy verbs
      IB/uverbs: Add action_handle flow steering specification
      IB/uverbs: Add modify ESP flow_action
      IB/uverbs: Introduce ESP steering match filter
      IB/mlx5: Add modify_flow_action_esp verb
      IB/mlx5: Add information for querying IPsec capabilities
      IB/mlx5: Add ability to hash by IPSEC_SPI when creating a TIR

Mikhail Malygin (1):
      IB/rxe: Fix for oops in rxe_register_device on ppc64le arch

Mustafa Ismail (1):
      i40iw: Refactor handling of txpend list

Parav Pandit (31):
      IB/core: Fix comments of GID query functions
      IB/{core, ipoib}: Simplify ib_find_gid() for unused ndev
      IB/core: Honor return status of ib_init_ah_from_mcmember()
      IB/core: Honor port_num while resolving GID for IB link layer
      IB/cma: Use rdma_protocol_roce() and remove cma_protocol_roce_dev_por=
t()
      IB/core: Remove rdma_resolve_ip_route() as exported symbol
      IB/ocrdma: Removed GID add/del null routines
      IB/cm: Add and use a helper function to add cm_id's to the port list
      IB/core: Refactor ib_init_ah_attr_from_path() for RoCE
      IB/cm: Introduce and use helper function to get cm_port from path
      IB/core: Move rdma_addr_find_l2_eth_by_grh to core_priv.h
      IB/core: Use rdma_is_port_valid()
      IB/core: Remove unimplemented ib_peek_cq
      IB/core: Refer to RoCE port property instead of GID table property
      IB/cma: Resolve route only while receiving CM requests
      IB/cm: Block processing alternate path handling RoCE Rx cm messages
      IB/core: Generate GID change event regardless of RoCE GID table prope=
rty
      IB/core: Refer to RoCE port property instead of GID table property
      IB/core: Search GID only for IB link layer
      IB/core: Refer to RoCE port property to decide building cache
      IB/addr: Constify dst_entry pointer
      RDMA/cma: Move rdma_cm_state to cma_priv.h
      IB/qedr: Remove GID add/del dummy routines
      RDMA/core: Update query_gid documentation for HCA drivers
      RDMA/providers: Simplify query_gid callback of RoCE providers
      IB/core: Simplify ib_query_gid to always refer to cache
      IB/core: Refactor GID modify code for RoCE
      IB/providers: Avoid zero GID check for RoCE
      IB/providers: Avoid null netdev check for RoCE
      RDMA: Use ib_gid_attr during GID modification
      IB/rxe: Removed GID add/del dummy routines

Roland Dreier (1):
      RDMA/ucma: Don't allow setting RDMA_OPTION_IB_PATH without an RDMA de=
vice

Sergey Gorenko (1):
      IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported

Shiraz Saleem (3):
      i40iw: Improve CM node lookup time on connection setup
      i40iw: Implement get_vector_affinity API
      i40iw: Remove pre-production workaround for resource profile 1

Sinan Kaya (2):
      RDMA/qedr: eliminate duplicate barriers on weakly-ordered archs
      IB/mlx4: Eliminate duplicate barriers on weakly-ordered archs

Steve Wise (13):
      RDMA/restrack: clean up res_to_dev()
      RDMA/nldev: common resource dumpit function
      RDMA/CM: move rdma_id_private to cma_priv.h
      RDMA/nldev: provide detailed CM_ID information
      RDMA/nldev: provide detailed CQ information
      iw_cxgb4: initialize ib_mr fields for user mrs
      mlx4_ib: set user mr attributes in struct ib_mr
      RDMA/nldev: provide detailed MR information
      mlx4_ib: zero out struct ib_pd when allocating
      RDMA/nldev: provide detailed PD information
      iw_cxgb4: Add ib_device->get_netdev support
      RDMA/CMA: remove RDMA_PS_SDP
      RDMA/CMA: Add rdma_port_space to UAPI

Tejun Heo (1):
      RDMAVT: Fix synchronization around percpu_ref

Yishai Hadas (2):
      IB/mlx4: Move mlx4_uverbs_ex_query_device_resp to include/uapi/
      IB/mlx4: Report TSO capabilities

Yixian Liu (8):
      RDMA/hns: Fix QP state judgement before receiving work requests
      RDMA/hns: Support rq record doorbell for the user space
      RDMA/hns: Support cq record doorbell for the user space
      RDMA/hns: Support rq record doorbell for kernel space
      RDMA/hns: Support cq record doorbell for kernel space
      RDMA/hns: Fix cqn type and init resp
      RDMA/hns: Fix init resp when alloc ucontext
      RDMA/hns: Fix cq record doorbell enable in kernel

Yuval Shaia (1):
      IB/ipoib: Delete unused struct

Zhu Yanjun (5):
      IB/rxe: remove unnecessary skb_clone
      IB/rxe: remove unnecessary rxe in rxe_send
      IB/rxe: change the function rxe_init_device_param type
      IB: remove duplicate header files
      IB/rxe: optimize mcast recv process

oulijun (2):
      RDMA/hns: Fix a bug with modifying mac address
      RDMA/hns: Use free_pages function instead of free_page

 .mailmap                                           |   2 +
 MAINTAINERS                                        |   1 +
 drivers/infiniband/Kconfig                         |  11 +-
 drivers/infiniband/core/Makefile                   |   4 +-
 drivers/infiniband/core/addr.c                     |  13 +-
 drivers/infiniband/core/cache.c                    | 533 ++++++++++-------=
--
 drivers/infiniband/core/cm.c                       |  67 ++-
 drivers/infiniband/core/cma.c                      | 160 +++---
 drivers/infiniband/core/cma_priv.h                 |  97 ++++
 drivers/infiniband/core/core_priv.h                |  11 +
 drivers/infiniband/core/device.c                   |  18 +-
 drivers/infiniband/core/iwpm_util.c                |   5 +-
 drivers/infiniband/core/multicast.c                |  26 +-
 drivers/infiniband/core/nldev.c                    | 364 +++++++++++--
 drivers/infiniband/core/rdma_core.c                |  13 +-
 drivers/infiniband/core/restrack.c                 | 121 +++--
 drivers/infiniband/core/sa_query.c                 | 202 ++++----
 drivers/infiniband/core/sysfs.c                    |  53 +-
 drivers/infiniband/core/ucm.c                      |  18 +-
 drivers/infiniband/core/ucma.c                     |  40 +-
 drivers/infiniband/core/uverbs.h                   |  41 ++
 drivers/infiniband/core/uverbs_cmd.c               | 279 +++++++---
 drivers/infiniband/core/uverbs_ioctl.c             |  60 ++-
 drivers/infiniband/core/uverbs_ioctl_merge.c       |   2 +-
 drivers/infiniband/core/uverbs_main.c              | 218 ++++----
 drivers/infiniband/core/uverbs_std_types.c         | 326 ++++--------
 drivers/infiniband/core/uverbs_std_types_cq.c      | 210 ++++++++
 drivers/infiniband/core/uverbs_std_types_dm.c      | 108 ++++
 .../infiniband/core/uverbs_std_types_flow_action.c | 435 ++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_mr.c      | 147 ++++++
 drivers/infiniband/core/verbs.c                    |  87 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  20 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   6 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   2 +-
 drivers/infiniband/hw/cxgb3/Kconfig                |   9 -
 drivers/infiniband/hw/cxgb3/Makefile               |   2 -
 drivers/infiniband/hw/cxgb3/cxio_dbg.c             | 206 --------
 drivers/infiniband/hw/cxgb3/cxio_hal.h             |   9 -
 drivers/infiniband/hw/cxgb3/iwch_cq.c              |   6 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   5 +-
 drivers/infiniband/hw/cxgb4/device.c               |  24 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   3 +
 drivers/infiniband/hw/cxgb4/provider.c             |  24 +-
 drivers/infiniband/hw/hfi1/driver.c                |   1 +
 drivers/infiniband/hw/hfi1/hfi.h                   |   1 -
 drivers/infiniband/hw/hfi1/qp.c                    |   1 -
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |   4 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |   2 +-
 drivers/infiniband/hw/hns/Makefile                 |   2 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   8 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  54 +-
 drivers/infiniband/hw/hns/hns_roce_db.c            | 180 +++++++
 drivers/infiniband/hw/hns/hns_roce_device.h        |  59 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   8 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  80 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   3 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |  41 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   2 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |   5 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  70 ++-
 drivers/infiniband/hw/i40iw/i40iw.h                |  11 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             | 129 +++--
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           |  56 +-
 drivers/infiniband/hw/i40iw/i40iw_d.h              |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |  35 ++
 drivers/infiniband/hw/i40iw/i40iw_main.c           |   2 -
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |   8 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h           |  11 +
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |  10 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  57 +-
 drivers/infiniband/hw/mlx4/ah.c                    |  10 +-
 drivers/infiniband/hw/mlx4/main.c                  | 102 ++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  19 +-
 drivers/infiniband/hw/mlx4/mr.c                    |   3 +
 drivers/infiniband/hw/mlx4/qp.c                    |  27 +-
 drivers/infiniband/hw/mlx5/ah.c                    |  12 +
 drivers/infiniband/hw/mlx5/cmd.c                   | 104 ++++
 drivers/infiniband/hw/mlx5/cmd.h                   |   4 +
 drivers/infiniband/hw/mlx5/main.c                  | 572 +++++++++++++++++=
++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  71 ++-
 drivers/infiniband/hw/mlx5/mr.c                    | 257 ++++++---
 drivers/infiniband/hw/mlx5/qp.c                    | 156 ++++--
 drivers/infiniband/hw/mthca/mthca_provider.c       |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c              |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   8 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |  22 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  34 --
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |  12 -
 drivers/infiniband/hw/qedr/main.c                  |   9 +-
 drivers/infiniband/hw/qedr/qedr_roce_cm.c          |  16 +-
 drivers/infiniband/hw/qedr/verbs.c                 | 155 ++----
 drivers/infiniband/hw/qedr/verbs.h                 |   6 -
 drivers/infiniband/hw/qib/qib.h                    |   3 -
 drivers/infiniband/hw/qib/qib_diag.c               |   2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   8 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |  10 +
 drivers/infiniband/hw/qib/qib_init.c               |   4 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |  24 -
 drivers/infiniband/hw/qib/qib_verbs.c              |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |   1 +
 drivers/infiniband/hw/usnic/usnic_transport.c      |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |  32 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   2 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |   5 +-
 drivers/infiniband/sw/rdmavt/vt.h                  |   1 -
 drivers/infiniband/sw/rxe/rxe.c                    |   4 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   6 +-
 drivers/infiniband/sw/rxe/rxe_av.c                 |   5 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |  15 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |  20 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  56 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  35 +-
 drivers/infiniband/sw/rxe/rxe_queue.c              |  24 +-
 drivers/infiniband/sw/rxe/rxe_queue.h              |   5 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |  16 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  15 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |  44 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              | 101 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   2 -
 drivers/infiniband/ulp/ipoib/ipoib.h               |   5 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                | 181 +++----
 drivers/infiniband/ulp/srpt/ib_srpt.c              | 396 +++++++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.h              |   8 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  21 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/rl.c       |  63 ++-
 include/linux/mlx4/device.h                        |   4 -
 include/linux/mlx5/device.h                        |  12 +-
 include/linux/mlx5/driver.h                        |  15 +-
 include/linux/mlx5/fs_helpers.h                    |   8 +
 include/linux/mlx5/mlx5_ifc.h                      | 102 +++-
 include/rdma/ib_addr.h                             |   9 -
 include/rdma/ib_cache.h                            |  29 --
 include/rdma/ib_sa.h                               |  13 +
 include/rdma/ib_verbs.h                            | 212 ++++++--
 include/rdma/rdma_cm.h                             |  44 +-
 include/rdma/rdma_vt.h                             |   2 +-
 include/rdma/restrack.h                            |  26 +-
 include/rdma/uverbs_ioctl.h                        | 153 +++++-
 include/rdma/uverbs_named_ioctl.h                  |  90 ++++
 include/rdma/uverbs_std_types.h                    |  34 +-
 include/uapi/rdma/bnxt_re-abi.h                    |  21 +-
 include/uapi/rdma/cxgb3-abi.h                      |  17 +-
 include/uapi/rdma/cxgb4-abi.h                      |  29 +-
 include/uapi/rdma/hfi/hfi1_ioctl.h                 |  32 +-
 include/uapi/rdma/hfi/hfi1_user.h                  |  10 +-
 include/uapi/rdma/hns-abi.h                        |  22 +-
 .../uapi/rdma/i40iw-abi.h                          |  16 +-
 include/uapi/rdma/ib_user_cm.h                     |  48 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h             | 134 +++++
 include/uapi/rdma/ib_user_ioctl_verbs.h            |  96 ++--
 include/uapi/rdma/ib_user_mad.h                    |   4 +-
 include/uapi/rdma/ib_user_verbs.h                  | 195 ++++---
 include/uapi/rdma/mlx4-abi.h                       |  52 +-
 include/uapi/rdma/mlx5-abi.h                       |  72 ++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  48 ++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h          |  43 ++
 include/uapi/rdma/mthca-abi.h                      |  10 +-
 include/uapi/rdma/nes-abi.h                        |   6 +-
 include/uapi/rdma/ocrdma-abi.h                     |  36 +-
 include/uapi/rdma/qedr-abi.h                       |  20 +-
 include/uapi/rdma/rdma_netlink.h                   |  51 ++
 include/uapi/rdma/rdma_user_cm.h                   |  49 +-
 include/uapi/rdma/rdma_user_ioctl.h                |  38 +-
 include/uapi/rdma/rdma_user_ioctl_cmds.h           |  99 ++++
 include/uapi/rdma/rdma_user_rxe.h                  |  58 ++-
 include/uapi/rdma/vmw_pvrdma-abi.h                 |  49 +-
 175 files changed, 6672 insertions(+), 2915 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_priv.h
 create mode 100644 drivers/infiniband/core/uverbs_std_types_cq.c
 create mode 100644 drivers/infiniband/core/uverbs_std_types_dm.c
 create mode 100644 drivers/infiniband/core/uverbs_std_types_flow_action.c
 create mode 100644 drivers/infiniband/core/uverbs_std_types_mr.c
 delete mode 100644 drivers/infiniband/hw/cxgb3/cxio_dbg.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_db.c
 create mode 100644 include/rdma/uverbs_named_ioctl.h
 rename drivers/infiniband/hw/i40iw/i40iw_ucontext.h =3D> include/uapi/rdma=
/i40iw-abi.h (90%)
 create mode 100644 include/uapi/rdma/ib_user_ioctl_cmds.h
 create mode 100644 include/uapi/rdma/mlx5_user_ioctl_cmds.h
 create mode 100644 include/uapi/rdma/mlx5_user_ioctl_verbs.h
 create mode 100644 include/uapi/rdma/rdma_user_ioctl_cmds.h

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJax5rSAAoJEDht9xV+IJsawQUP/2AOvsUjyDYt0NiIGIFwvnYY
b9pks6aZlA4dTEATakAw37r1i/fcjUmPUFMFQVwAJrzqK/CSXr9GVnYWNgEXXkEa
MuaSMsi0HIY/guFR0N8F8LZ6xvA49LvCvpYKVnCB+T10plZOAReW+UzBUUuofKV1
cr2Kak8WrR0pPyXlLk0lKHpmYzxDwehIEBHjvweN6fMypO4HNoYAHoXxq4ucsaAQ
85kiUyXiIEqZxVwRG6e8XTkO9Uy+fUR3WN6NRfmccMsN7Yn9D8thctjfhBJKr3we
Zc2sVIeriSd2Y7MfJaDMX1G2QsOvogii/Sj6OND0wK6MVUQEXO1lszbXe6eqeIpZ
zoPDqk8t86jMzSl5Q8D8EqMW5n3e3izVqDIFLo+GoC+/y9SuBalnadmrWbaMLJAf
DHJtds4r3v+YTI586w5xAzX4Npj44I9xIQpYPPVL2MsAfcCYPKMj4RoX8bXzhJ37
dle5kz6aHQWjrfk4z0SzRd5rIO+g/tec/MZrdchIm+6kOx+jK5lsNfW2oMUZN+FZ
wvshlEvCJ0bfbT3If/LycPUec1e1wVkglKVAX+rJVYbinUVZ08aXRubb9Fn0zDMV
inBYT1xszLXQxrfSYspJs/4e+YSY1euILFnDtyI89dV7k9klUWPNdKeBD3779VWy
ICP1yH2yQUstFIpjpZTc
=xE5l
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
