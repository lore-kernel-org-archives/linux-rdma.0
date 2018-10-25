From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 25 Oct 2018 21:21:19 +0000
Message-ID: <20181025212112.GA1747@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are the RDMA patches for 4.20.

This time there is one simple git contextual conflict and a conflict
that causes a compile failure. The latter is fixed with this patch:

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5=
/flow.c
index e57435cb6d96..f86cdcafdafc 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -160,7 +160,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
                         ret =3D -EINVAL;
                         goto err_out;
                 }
-               flow_act.has_flow_tag =3D true;
+               flow_act.flags |=3D FLOW_ACT_HAS_TAG;
         }

         flow_handler =3D mlx5_ib_raw_fs_rule_add(dev, fs_matcher, &flow_ac=
t,

This appears to have arisen because a patch was sent to netdev
changing infiniband code that should have gone to the shared tree. The
appropriate people have been reminded about the process.

Otherwise it has been a reasonable cycle here with not too much major
change.

This pull request is following your recommendation from 4.19, the
for-linus tag has no merge, a for-linus-merged tag has my merge
resolution for your reference, and the diffstat below has been
replaced with the diffstat from the for-linus-merged tag.

The following changes since commit 94a04d1d3d3681adde1a3e022b25dbac7b345b7e:

  net/mlx5: Expose DC scatter to CQE capability bit (2018-10-16 21:55:29 +0=
300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to a60109dc9a954ef9eddba6577e2d2e9e7952e487:

  IB/mlx5: Add support for extended atomic operations (2018-10-17 11:53:23 =
-0400)

----------------------------------------------------------------
First merge window pull request

This has been a smaller cycle with many of the commits being smallish code
fixes and improvements across the drivers.

- Driver updates for bnxt_re, cxgb4, hfi1, hns, mlx5, nes, qedr, and rxe

- Memory window support in hns

- mlx5 user API 'flow mutate/steering' allows accessing the full packet
  mangling and matching machinery from user space

- Support inter-working with verbs API calls in the 'devx' mlx5 user API, a=
nd
  provide options to use devx with less privilege

- Modernize the use of syfs and the device interface to use attribute groups
  and cdev properly for uverbs, and clean up some of the core code's device=
 list
  management

- More progress on net namespaces for RDMA devices

- Consolidate driver BAR mmapping support into core code helpers and rework
  how RDMA holds poitners to mm_struct for get_user_pages cases

- First pass to use 'dev_name' instead of ib_device->name

- Device renaming for RDMA devices

----------------------------------------------------------------
Alex Estrin (2):
      IB/sa: simplify return code logic for ib_nl_send_msg()
      IB/hfi1: Add mtu check for operational data VLs

Arnd Bergmann (1):
      RDMA: Fix dependencies for rdma_user_mmap_io

Arseny Maslennikov (3):
      Documentation/ABI: document /sys/class/net/*/dev_port
      IB/ipoib: Use dev_port to expose network interface port numbers
      IB/ipoib: Log sysfs 'dev_id' accesses from userspace

Artemy Kovalyov (1):
      IB/mlx5: Fix MR cache initialization

Brian Welty (1):
      IB/{hfi1, qib, rdmavt}: Move copy SGE logic into rdmavt

Chuck Lever (2):
      RDMA/core: Document CM @event_handler function
      RDMA/core: Document QP @event_handler function

Colin Ian King (3):
      IB/usnic: fix spelling mistake "unvalid" -> "invalid"
      IB/mthca: remove redundant inner check of mdev->mthca_flags
      RDMA/hns: fix spelling mistake "reseved" -> "reserved"

Dan Carpenter (1):
      RDMA/hns: Fix an error code in hns_roce_v2_init_eq_table()

Denis Drozdov (1):
      IB/ipoib: Clear IPCB before icmp_send

Dennis Dalessandro (3):
      IB/hfi1: Rework file list in Makefile
      IB/hfi1: Prepare resource waits for dual leg
      IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds

Devesh Sharma (3):
      RDMA/bnxt_re: Drop L2 async events silently
      RDMA/bnxt_re: Fix qp async event reporting
      RDMA/bnxt_re: Limit max_pkey to 16 bit value

Doug Ledford (4):
      Merge branch 'mlx5-vport-loopback' into rdma.get
      RDMA/umem: Minor optimizations
      RDMA/umem: Fix potential addition overflow
      Merge remote-tracking branch 'mlx5-next' into for-next

Gal Pressman (1):
      RDMA/mlx5: Remove extraneous error check

Guy Levi (1):
      IB/uverbs: Add IDRs array attribute type to ioctl() interface

Hannes Reinecke (1):
      ib_srp: Remove WARN_ON in srp_terminate_io()

H=C3=A5kon Bugge (3):
      RDMA/i40iw: Fix incorrect iterator type
      IB/mlx4: Enable debug print of SMPs
      IB/mlx4: Add port and TID to MAD debug print

Igor Stoppa (1):
      IB/srp: Remove unnecessary unlikely()

Israel Rukshin (1):
      IB/iser: Fix possible NULL deref at iser_inv_desc()

Jack Morgenstein (1):
      IB/core: Add an unbound WQ type to the new CQ API

Jason Gunthorpe (31):
      Merge branch 'mlx5-flow-mutate' into rdma.git for-next
      Merge branch 'uverbs_dev_cleanups' into rdma.git for-next
      IB/rxe: Revise the ib_wr_opcode enum
      RDMA/uverbs: Remove is_closed from ib_uverbs_file
      RDMA/uverbs: Fix error unwind in ib_uverbs_add_one
      RDMA/ucontext: Add a core API for mmaping driver IO memory
      RDMA/mlx4: Use rdma_user_mmap_io
      RDMA/mlx5: Use rdma_user_mmap_io
      RDMA/hns: Use rdma_user_mmap_io
      RDMA/ucontext: Get rid of the old disassociate flow
      RDMA/umem: Do not use current->tgid to track the mm_struct
      RDMA/usnic: Do not use ucontext->tgid
      RDMA/umem: Use ib_umem_odp in all function signatures connected to ODP
      RDMA/umem: Make ib_umem_odp into a sub structure of ib_umem
      RDMA/umem: Get rid of struct ib_umem.odp_data
      RDMA/umem: Move all the ODP related stuff out of ucontext and into pe=
r_mm
      RDMA/umem: Use umem->owning_mm inside ODP
      RDMA/umem: Get rid of per_mm->notifier_count
      RDMA/umem: Handle a half-complete start/end sequence
      RDMA/umem: Avoid synchronize_srcu in the ODP MR destruction path
      RDMA/uverbs: Get rid of ucontext->tgid
      Merge branch 'mellanox/mlx5-next' into rdma.git for-next
      RDMA: Fully setup the device name in ib_register_device
      RDMA/core: Use dev_err/dbg/etc instead of pr_* + ibdev->name
      RDMA/drivers: Use dev_err/dbg/etc instead of pr_* + ibdev->name
      RDMA/core: Use dev_name instead of ibdev->name
      RDMA/drivers: Use dev_name instead of ibdev->name
      RDMA/ulp: Use dev_name instead of ibdev->name
      RDMA: Fix building with CONFIG_MMU=3Dn
      RDMA/uverbs: Fix RCU annotation for radix slot deference
      Merge branch 'for-rc' into rdma.git for-next

Joe Perches (1):
      RDMA/bnxt_re: QPLIB: Add and use #define dev_fmt(fmt) "QPLIB: " fmt

Kaike Wan (3):
      IB/rdmavt: Rename check_send_wqe as setup_wqe
      IB/hfi1: Add static trace for iowait
      IB/hfi1: Use VL15 for SM packets

Kamal Heib (2):
      RDMA/rxe: Remove unused addr_same()
      RDMA: Remove unused parameter from ib_modify_qp_is_ok()

Kamenee Arumugam (1):
      IB/hfi1: PCIe bus width retry

Leon Romanovsky (17):
      RDMA/nes: Delete impossible debug prints
      RDMA/uverbs: Declare closing variable as boolean
      RDMA/umem: Restore lockdep check while downgrading lock
      RDMA/netlink: Simplify netlink listener existence check
      RDMA/restrack: Un-inline set task implementation
      RDMA/restrack: Consolidate task name updates in one place
      RDMA/restrack: Release task struct which was hold by CM_ID object
      RDMA/restrack: Protect from reentry to resource return path
      RDMA/cm: Respect returned status of cm_init_av_by_path
      RDMA/cma: Remove unused timeout_ms parameter from cma_resolve_iw_rout=
e()
      RDMA/core: Align multiple functions to kernel coding style
      RDMA/core: Annotate timeout as unsigned long
      RDMA/core: Implement IB device rename function
      RDMA/nldev: Allow IB device rename through RDMA netlink
      RDMA/core: Increase total number of RDMA ports across all devices
      RDMA/uverbs: Use kernel API to allocate uverbs indexes
      RDMA/umad: Use kernel API to allocate umad indexes

Lijun Ou (15):
      RDMA/hns: Refactor the codes for setting transport opode
      RDMA/hns: Add atomic support
      RDMA/hns: Add CM of vlan device support
      RDMA/hns: Add enable judgement for UD vlan
      RDMA/hns: Bugfix for reserved qp number
      RDMA/hns: Submit bad wr when post send wr exception
      RDMA/hns: Bugfix for CM test
      RDMA/hns: Limit the size of extend sge of sq
      RDMA/hns: Configure ecn field of ip header
      RDMA/hns: Update some attributes of the RoCE device
      RDMA/hns: Limit extend sq sge num
      RDMA/hns: Update some fields of qp context
      RDMA/hns: Support local invalidate for hip08 in kernel space
      RDMA/hns: Add vlan enable bit for hip08
      RDMA/hns: Bugfix for atomic operation

Majd Dibbiny (1):
      IB/mlx5: Change TX affinity assignment in RoCE LAG mode

Mark Bloch (23):
      RDMA/uverbs: Add UVERBS_ATTR_CONST_IN to the specs language
      RDMA/mlx5: Add a new flow action verb - modify header
      RDMA/uverbs: Add generic function to fill in flow action object
      RDMA/mlx5: Add new flow action verb - packet reformat
      RDMA/mlx5: Extend packet reformat verbs
      RDMA/mlx5: Add NIC TX steering support
      RDMA/mlx5: Enable attaching modify header to steering flows
      RDMA/mlx5: Enable decap and packet reformat on flow tables
      RDMA/mlx5: Enable attaching DECAP action to steering flows
      RDMA/mlx5: Enable reformat on NIC RX if supported
      RDMA/mlx5: Enable attaching packet reformat action to steering flows
      RDMA/uverbs: Move flow resources initialization
      RDMA/mlx5: Refactor flow action parsing to be more generic
      RDMA/mlx5: Don't overwrite action if already set
      RDMA/mlx5: Refactor raw flow creation
      RDMA/mlx5: Add flow actions support to raw create flow
      RDMA/mlx5: Add NIC TX namespace when getting a flow table
      RDMA/mlx5: Allow creating a matcher for a NIC TX flow table
      RDMA/mlx5: Refactor transport domain bookkeeping logic
      RDMA/mlx5: Allow creating RAW ethernet QP with loopback support
      RDMA/mlx5: Enable vport loopback when user context or QP mandate
      RDMA/mlx5: Remove superfluous version print
      RDMA/mlx5: Add support for flow tag to raw create flow

Michael J. Ruhl (15):
      IB/hfi1: Remove duplicated defines
      IB/hfi1: tune_pcie_caps is arbitrarily placed, poorly
      IB/hfi1: Get the hfi1_devdata structure as early as possible
      IB/hfi1: Prepare for new HFI1 MSIx API
      IB/hfi1: Make the MSIx resource allocation a bit more flexible
      IB/hfi1: Rework the IRQ API to be more flexible
      IB/hfi1: Move URGENT IRQ enable to hfi1_rcvctrl()
      IB/{hfi1, qib, rdmavt}: Schedule multi RC/UC packets instead of posti=
ng
      IB/hfi1: Eliminate races in the SDMA send error path
      IB/hfi1: Remove race conditions in user_sdma send path
      IB/hfi1: Right size user_sdma sequence numbers and related variables
      IB/hfi1: Missing return value in error path for user sdma
      IB/hfi1: set_intr_bits uses incorrect source for register modification
      IB/hfi1: Move UnsupportedVL bits definitions to the correct header
      IB/hfi1: Error path MAD response size is incorrect

Moni Shoua (1):
      IB/mlx5: Allow transition of DCI QP to reset

Muhammad Sammar (1):
      IB/ipoib: Ensure that MTU isn't less than minimum permitted

Nathan Chancellor (6):
      IB/nes: Remove unnecessary parentheses
      IB/mlx4: Remove unnecessary parentheses
      iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs
      RDMA/qedr: Remove enumerated type qed_roce_ll2_tx_dest
      IB/mlx4: Avoid implicit enumerated type conversion
      IB/rxe: Remove unnecessary enum values

Parav Pandit (44):
      IB/rxe: Simplify rxe_find_route() to avoid GID query for netdev
      IB/rxe: Replace spinlock with rwlock
      IB/rxe: Change pool state enums to capital letters
      IB/rxe: Avoid NULL check when search is successful
      IB/rxe: Refactor lookup memory function
      RDMA/core: Replace open-coded variant of get_device
      RDMA/core: Depend on device_add() to add device attributes
      RDMA/uverbs: Use cdev_device_add() instead of cdev_add()
      RDMA/uverbs: Use device.groups to initialize device attributes
      RDMA/core: Fail early if unsupported QP is provided
      IB/mlx5: Don't hold spin lock while checking device state
      RDMA/core: Rate limit MAD error messages
      RDMA/{cma, core}: Avoid callback on rdma_addr_cancel()
      RDMA/core: No need to protect kfree with spin lock and semaphore
      RDMA/core: Use simplified list_for_each
      RDMA/core: Remove context entries from list while unregistering device
      RDMA/core: Use simpler spin lock irq API from blocking context
      RDMA/core: Define client_data_lock as rwlock instead of spinlock
      RDMA/core: Follow correct unregister order between sysfs and cgroup
      RDMA/core: Assign device ifindex before publishing the device
      RDMA/core Introduce and use rdma_find_ndev_for_src_ip_rcu
      RDMA/core: Avoid unnecessary sa_family overwrite
      RDMA/core: Let protocol specific function typecast sockaddr structure
      RDMA/core: Introduce and use rdma_set_src_addr() between IPv4 and IPv6
      RDMA/core: Rename rdma_copy_addr to rdma_copy_src_l2_addr
      RDMA/core: Use common code flow for IPv4/6 for addr resolve
      RDMA/core: Refer to network type instead of device type
      RDMA/core: Protect against changing dst->dev during destination resol=
ve
      RDMA/core: Simplify roce_resolve_route_from_path()
      RDMA/core: Introduce rdma_read_gid_attr_ndev_rcu() to check GID attri=
bute
      RDMA/core: Consider net ns of gid attribute for RoCE
      RDMA/core: Acquire and release mmap_sem on page range
      RDMA/cma: Allow accepting requests for multi port rdma device
      RDMA/cma: Introduce and use cma_acquire_dev_by_src_ip()
      RDMA/cma: Introduce and use cma_ib_acquire_dev()
      RDMA/core: Check error status of rdma_find_ndev_for_src_ip_rcu
      IB/mlx4: Refer to the device kobject instead of ports_parent
      RDMA/core: Do not expose unsupported counters
      RDMA/core: Rename ports_parent to ports_kobj
      RDMA/core: Allow existing drivers to set one sysfs group per device
      RDMA/drivers: Use core provided API for registering device attributes
      RDMA/core: Fix unwinding flow in case of error to register device
      RDMA/core: Refactor ib_register_device() function
      RDMA/core: Fix comment for hw stats init for port =3D=3D 0

Selvin Xavier (9):
      RDMA/bnxt_re: Add missing spin lock initialization
      RDMA/bnxt_re: Fix recursive lock warning in debug kernel
      RDMA/bnxt_re: Remove the unnecessary version macro definition
      RDMA/bnxt_re: Avoid NULL check after accessing the pointer
      RDMA/bnxt_re: Avoid accessing nq->bar_reg_iomem in failure case
      RDMA/bnxt_re: Expose rx discards and drop counters
      RDMA/bnxt_re: Report out of sequence hw counters
      RDMA/bnxt_re: Wait for delayed work to finish before device removal
      RDMA/bnxt_re: Avoid resource leak in case the NQ registration fails

Somnath Kotur (1):
      RDMA/bnxt_re: Prevent driver crash due to NULL pointer in error messa=
ge print

Venkata Sandeep Dhanalakota (2):
      IB/{hfi1, qib, rdmavt}: Move send completion logic to rdmavt
      IB/{hfi1, qib, rdmavt}: Move ruc_loopback to rdmavt

Vijay Immanuel (4):
      IB/rxe: vary the source udp port for receive scaling
      IB/rxe: fix for duplicate request processing and ack psns
      IB/rxe: avoid back-to-back retries
      IB/rxe: fixes for rdma read retry

Wei Yongjun (1):
      IB/mthca: Fix error return code in __mthca_init_one()

Yishai Hadas (20):
      IB/mlx5: Use uid as part of PD commands
      IB/mlx5: Set uid as part of QP creation
      IB/mlx5: Set uid as part of RQ commands
      IB/mlx5: Set uid as part of SQ commands
      IB/mlx5: Set uid as part of SRQ commands
      IB/mlx5: Set uid as part of DCT commands
      IB/mlx5: Set uid as part of MCG commands
      IB/mlx5: Set uid as part of TIR commands
      IB/mlx5: Set uid as part of TIS commands
      IB/mlx5: Set uid as part of RQT commands
      IB/mlx5: Set uid upon PD allocation
      IB/mlx5: Set uid as part of CQ creation
      IB/mlx5: Set uid as part of XRCD commands
      IB/mlx5: Set uid as part of TD commands
      IB/mlx5: Set valid umem bit on DEVX
      IB/mlx5: Expose RAW QP device handles to user space
      IB/mlx5: Manage device uid for DEVX white list commands
      IB/mlx5: Enable DEVX white list commands
      IB/mlx5: Enable DEVX on IB
      IB/mlx5: Verify DEVX object type

Yixian Liu (2):
      RDMA/hns: Add MW support for hip08
      RDMA/hns: Add FRMR support for hip08

Yonatan Cohen (4):
      IB/mlx5: Support scatter to CQE for DC transport type
      IB/mlx5: Verify that driver supports user flags
      IB/mlx5: Allow scatter to CQE without global signaled WRs
      IB/mlx5: Add support for extended atomic operations

YueHaibing (4):
      RDMA/qedr: remove set but not used variable 'ctx'
      RDMA: Remove duplicated include from ib_addr.h
      RDMA/core: Properly return the error code of rdma_set_src_addr_rcu
      RDMA/hns: remove set but not used variable 'dseg'

Zhu Yanjun (3):
      IB/rxe: remove redudant qpn check
      IB/rxe: replace kvfree with vfree
      IB/rxe: avoid srq memory leak

liuyixian (1):
      RDMA/hns: Move all prints out of irq handle

zhong jiang (2):
      infiniband: remove redundant condition check before debugfs_remove
      RDMA/cxgb4: remove redundant null pointer check before kfree_skb

 Documentation/ABI/testing/sysfs-class-net          |  18 +
 drivers/infiniband/Kconfig                         |   1 +
 drivers/infiniband/core/addr.c                     | 406 +++++++-----
 drivers/infiniband/core/cache.c                    |  79 ++-
 drivers/infiniband/core/cm.c                       |   9 +-
 drivers/infiniband/core/cma.c                      | 251 +++++---
 drivers/infiniband/core/cma_configfs.c             |   2 +-
 drivers/infiniband/core/core_priv.h                |  12 +-
 drivers/infiniband/core/cq.c                       |  10 +-
 drivers/infiniband/core/device.c                   | 264 +++++---
 drivers/infiniband/core/fmr_pool.c                 |   5 +-
 drivers/infiniband/core/iwcm.c                     |   2 +-
 drivers/infiniband/core/mad.c                      |  80 +--
 drivers/infiniband/core/mad_priv.h                 |   2 +-
 drivers/infiniband/core/netlink.c                  |   4 +-
 drivers/infiniband/core/nldev.c                    |  37 +-
 drivers/infiniband/core/rdma_core.c                |  56 +-
 drivers/infiniband/core/rdma_core.h                |   1 +
 drivers/infiniband/core/restrack.c                 |  30 +-
 drivers/infiniband/core/sa.h                       |   8 +-
 drivers/infiniband/core/sa_query.c                 |  70 +--
 drivers/infiniband/core/security.c                 |   7 +-
 drivers/infiniband/core/sysfs.c                    | 101 ++-
 drivers/infiniband/core/umem.c                     | 125 ++--
 drivers/infiniband/core/umem_odp.c                 | 621 +++++++++--------=
--
 drivers/infiniband/core/user_mad.c                 |  13 +-
 drivers/infiniband/core/uverbs.h                   |  15 +-
 drivers/infiniband/core/uverbs_cmd.c               |  43 +-
 drivers/infiniband/core/uverbs_ioctl.c             | 140 ++++-
 drivers/infiniband/core/uverbs_main.c              | 340 +++++++++--
 .../infiniband/core/uverbs_std_types_flow_action.c |   7 +-
 drivers/infiniband/core/uverbs_uapi.c              |  12 +
 drivers/infiniband/core/verbs.c                    |  19 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   3 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |  11 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.h        |   3 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   4 +-
 drivers/infiniband/hw/bnxt_re/main.c               | 125 ++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           | 134 ++--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |  88 +--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  29 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  77 ++-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |  10 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h           |   5 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  55 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   3 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |   2 +-
 drivers/infiniband/hw/cxgb4/provider.c             |  50 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  10 +-
 drivers/infiniband/hw/hfi1/Makefile                |  42 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   4 +-
 drivers/infiniband/hw/hfi1/chip.c                  | 486 ++++-----------
 drivers/infiniband/hw/hfi1/chip.h                  |  71 ++-
 drivers/infiniband/hw/hfi1/chip_registers.h        |   4 +
 drivers/infiniband/hw/hfi1/file_ops.c              |   4 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |  48 +-
 drivers/infiniband/hw/hfi1/init.c                  | 113 ++--
 drivers/infiniband/hw/hfi1/iowait.c                |  94 +++
 drivers/infiniband/hw/hfi1/iowait.h                | 192 ++++--
 drivers/infiniband/hw/hfi1/mad.c                   |   4 +-
 drivers/infiniband/hw/hfi1/msix.c                  | 363 +++++++++++
 drivers/infiniband/hw/hfi1/msix.h                  |  64 ++
 drivers/infiniband/hw/hfi1/pcie.c                  |  74 +--
 drivers/infiniband/hw/hfi1/pio.c                   |   8 -
 drivers/infiniband/hw/hfi1/qp.c                    | 100 ++-
 drivers/infiniband/hw/hfi1/qp.h                    |  31 +-
 drivers/infiniband/hw/hfi1/rc.c                    |  24 +-
 drivers/infiniband/hw/hfi1/ruc.c                   | 382 +-----------
 drivers/infiniband/hw/hfi1/sdma.c                  |  56 +-
 drivers/infiniband/hw/hfi1/sdma.h                  |  21 +-
 drivers/infiniband/hw/hfi1/sysfs.c                 |  69 +--
 drivers/infiniband/hw/hfi1/trace.h                 |   3 +-
 drivers/infiniband/hw/hfi1/trace_iowait.h          |  54 ++
 drivers/infiniband/hw/hfi1/uc.c                    |  14 +-
 drivers/infiniband/hw/hfi1/ud.c                    |  22 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             | 137 ++---
 drivers/infiniband/hw/hfi1/user_sdma.h             |  20 +-
 drivers/infiniband/hw/hfi1/verbs.c                 | 251 +-------
 drivers/infiniband/hw/hfi1/verbs.h                 |  35 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h           |  11 +-
 drivers/infiniband/hw/hfi1/vnic_main.c             |  12 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c             |  21 +-
 drivers/infiniband/hw/hns/Kconfig                  |   1 +
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  45 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 629 ++++++++++++-----=
--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |  96 ++-
 drivers/infiniband/hw/hns/hns_roce_main.c          | 123 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c            | 212 ++++++-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  41 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  73 +--
 drivers/infiniband/hw/mlx4/Kconfig                 |   1 +
 drivers/infiniband/hw/mlx4/mad.c                   |  20 +-
 drivers/infiniband/hw/mlx4/main.c                  | 182 ++----
 drivers/infiniband/hw/mlx4/mcg.c                   |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   5 -
 drivers/infiniband/hw/mlx4/qp.c                    |   8 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |   6 +-
 drivers/infiniband/hw/mlx5/cmd.c                   | 129 ++++
 drivers/infiniband/hw/mlx5/cmd.h                   |  14 +
 drivers/infiniband/hw/mlx5/cq.c                    |   3 +-
 drivers/infiniband/hw/mlx5/devx.c                  | 358 ++++++++---
 drivers/infiniband/hw/mlx5/flow.c                  | 393 +++++++++++-
 drivers/infiniband/hw/mlx5/ib_rep.c                |   3 -
 drivers/infiniband/hw/mlx5/main.c                  | 510 ++++++++--------
 drivers/infiniband/hw/mlx5/mem.c                   |   9 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  98 +--
 drivers/infiniband/hw/mlx5/mr.c                    |  14 +-
 drivers/infiniband/hw/mlx5/odp.c                   | 123 ++--
 drivers/infiniband/hw/mlx5/qp.c                    | 491 +++++++++++----
 drivers/infiniband/hw/mlx5/srq.c                   |   1 +
 drivers/infiniband/hw/mthca/mthca_mad.c            |   5 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   6 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |  44 +-
 drivers/infiniband/hw/mthca/mthca_qp.c             |   4 +-
 drivers/infiniband/hw/nes/nes.c                    |   3 -
 drivers/infiniband/hw/nes/nes.h                    |   9 -
 drivers/infiniband/hw/nes/nes_hw.c                 |   2 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   2 -
 drivers/infiniband/hw/nes/nes_verbs.c              |  63 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  74 +--
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   3 +-
 drivers/infiniband/hw/qedr/main.c                  |  73 +--
 drivers/infiniband/hw/qedr/qedr.h                  |   2 +-
 drivers/infiniband/hw/qedr/qedr_roce_cm.c          |   4 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   5 +-
 drivers/infiniband/hw/qib/qib.h                    |   2 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |  17 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |  18 +-
 drivers/infiniband/hw/qib/qib_ruc.c                | 342 +----------
 drivers/infiniband/hw/qib/qib_sdma.c               |   2 +-
 drivers/infiniband/hw/qib/qib_sysfs.c              | 101 ++-
 drivers/infiniband/hw/qib/qib_uc.c                 |  12 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |  17 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |  47 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |  15 +-
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |   3 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  39 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |  74 +--
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h       |   2 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  16 +-
 drivers/infiniband/hw/usnic/usnic_transport.c      |   2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  91 ++-
 drivers/infiniband/hw/usnic/usnic_uiom.h           |   3 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |  46 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   2 +-
 drivers/infiniband/sw/rdmavt/Kconfig               |   2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  | 677 +++++++++++++++++=
+++-
 drivers/infiniband/sw/rdmavt/qp.h                  |   2 +
 drivers/infiniband/sw/rdmavt/trace_tx.h            |  42 ++
 drivers/infiniband/sw/rdmavt/vt.c                  |  15 +-
 drivers/infiniband/sw/rxe/rxe.c                    |  13 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |  39 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   4 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   5 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  35 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  49 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |   4 -
 drivers/infiniband/sw/rxe/rxe_pool.c               |  55 +-
 drivers/infiniband/sw/rxe/rxe_pool.h               |   6 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  18 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |   4 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  17 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  10 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |  10 +-
 drivers/infiniband/sw/rxe/rxe_sysfs.c              |   2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |  29 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   4 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  36 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |  18 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   9 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   3 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |   3 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  19 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  28 +-
 include/linux/mlx5/driver.h                        |  23 +-
 include/linux/qed/qed_rdma_if.h                    |  11 +-
 include/rdma/ib_addr.h                             |  11 +-
 include/rdma/ib_cm.h                               |   2 +-
 include/rdma/ib_sa.h                               |  38 +-
 include/rdma/ib_umem.h                             |   9 +-
 include/rdma/ib_umem_odp.h                         |  75 +--
 include/rdma/ib_verbs.h                            | 149 +++--
 include/rdma/rdma_cm.h                             |  11 +-
 include/rdma/rdma_netlink.h                        |   4 +-
 include/rdma/rdma_vt.h                             |  51 +-
 include/rdma/rdmavt_qp.h                           |   7 +
 include/rdma/restrack.h                            |  12 +-
 include/rdma/uverbs_ioctl.h                        | 111 +++-
 include/rdma/uverbs_std_types.h                    |  51 ++
 include/uapi/rdma/ib_user_verbs.h                  |  20 +-
 include/uapi/rdma/mlx5-abi.h                       |  16 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  21 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h          |  12 +
 include/uapi/rdma/rdma_netlink.h                   |   3 +-
 include/uapi/rdma/rdma_user_ioctl_cmds.h           |   7 +-
 204 files changed, 7618 insertions(+), 5190 deletions(-)
(diffstat from tag for-linus-merged)

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlvSM8UACgkQOG33FX4g
mxrKMw//TJQwxJIZgHaPoUCA7sK1yKxveMQASXmbo6hX/eZWvI7ZbqAh309QQ8QQ
y5N9RosXD2amKRa1jQTZtJmk/fpvjahPUg6V39tHqVW0zvtCeeDWE30Yf/LChD8i
0+Yik8F4AQ2rQFgne7GRO/w2YZUdw5vg6DOQZz8Ncmr1RluLRjYTidZt/j/2zyY8
QeDiymHjbdjtlGM2NDnT0S03MP/oFYZ2zmIsqfg1csQgpS5tBH3V65ZZSWLZ7+tS
fwvqYeBLQwAolZzh6JhJsflw/fq4clrM18aM/hMLCHIF9pcattK78T9fMPh/wC3s
OhQpdWG/6GiDILB7n5/Ed+G1H/dme43Iwl0s6706nNQ6yo1zEWUlo0FD4sF6e1PY
8y02HwOQJ+PsP8BkOnVyTGqLGeAMd802r3R0hBY3TE7VfbOjpSCWBZ3LiRC3+HVg
qTS1CPP1HJ1LTnt3om4eqb3lkmxv68zC5Hf2yuHrrOnmkv0Ls8a7J24oivOcMLK8
eUBV3JEroOcvMKhlI42gJoMWkoagDIGmtffcChR97tKbUxE0jLf56Wxd7wz0dJ4R
cHBBqyOoaOuFgACyFX5LWhJ+2/3wQCo3O41Xm9rIHnD8bxkloobNxv/6fyFLwKdG
3LmGWSgORhnSDcuk1l+IdYedP8Rr+GfEammtqJJILZFAkYIyPzU=
=eBYc
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
