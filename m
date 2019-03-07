From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 7 Mar 2019 01:34:16 +0000
Message-ID: <20190307013411.GA6010@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

These are the proposed RDMA patches for 5.1.

There is a small conflict with the net tree in
drivers/infiniband/hw/mlx4/Kconfig that is resolved by deleting both
lines. There may also be conflicts with Matt's xarray tree that
changes some of the xarray APIs. RDMA has gained some new users of
those APIs this cycle.

Looking at the patchworks I'm thinking we might have a second merge
window pull request with some bug fixes and other rcish things that
were sent a little too late for this.

The next merge window may also see up to three new RDMA drivers, which
is quite unusual.

Thanks,
Jason

The tag for-linus-merged with my merge resolution to your tree is also avai=
lable to pull.

The following changes since commit 08e8676f1607925adf36e399f0faa8ce3b10bb86:

  IB/mlx5: Add support for 50Gbps per lane link modes (2019-02-14 12:14:42 =
-0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to fca22e7e595f1799cfbfdfa13e16d48ece0d136c:

  net/mlx5: ODP support for XRC transport is not enabled by default in FW (=
2019-03-06 15:53:09 -0400)

----------------------------------------------------------------
5.1 Merge Window Pull Request

This has been a slightly more active cycle than normal with ongoing core
changes and quite a lot of collected driver updates.

- Various driver fixes for bnxt_re, cxgb4, hns, mlx5, pvrdma, rxe

- A new data transfer mode for HFI1 giving higher performance

- Significant functional and bug fix update to the mlx5 On-Demand-Paging MR
  feature

- A chip hang reset recovery system for hns

- Change mm->pinned_vm to an atomic64

- Update bnxt_re to support a new 57500 chip

- A sane netlink 'rdma link add' method for creating rxe devices and fixing
  the various unregistration race conditions in rxe's unregister flow

- Allow lookup up objects by an ID over netlink

- Various reworking of the core to driver interface:
  * Drivers should not assume umem SGLs are in PAGE_SIZE chunks
  * ucontext is accessed via udata not other means
  * Start to make the core code responsible for object memory
    allocation
  * Drivers should convert struct device to struct ib_device
    via a helper
  * Drivers have more tools to avoid use after unregister problems

----------------------------------------------------------------
Adit Ranadive (1):
      RDMA/vmw_pvrdma: Support upto 64-bit PFNs

Bart Van Assche (5):
      IB/core: Declare local functions 'static'
      IB/mlx5: Declare local functions 'static'
      RDMA/srp: Increase max_segment_size
      IB/core: Remove ib_sg_dma_address() and ib_sg_dma_len()
      IB/mlx5: Do not use hw_access_flags for be and CPU data

Colin Ian King (2):
      RDMA/bnxt_re: fix or'ing of data into an uninitialized struct member
      RDMA: Fix allocation failure on pointer pd

Dan Carpenter (2):
      RDMA/bnxt_re: fix a size calculation
      RDMA/core: Fix a WARN() message

Daniel Jurgens (4):
      IB/core: Unregister notifier before freeing MAD security
      IB/core: Fix potential memory leak while creating MAD agents
      IB/core: Eliminate a hole in MAD agent struct
      IB/core: Don't register each MAD agent for LSM notifier

Danit Goldberg (1):
      IB/cma: Define option to set ack timeout and pack tos_set

Davidlohr Bueso (8):
      mm: make mm->pinned_vm an atomic64 counter
      drivers/mic/scif: do not use mmap_sem
      drivers/IB,qib: optimize mmap_sem usage
      drivers/IB,hfi1: do not se mmap_sem
      drivers/IB,usnic: reduce scope of mmap_sem
      drivers/IB,core: reduce scope of mmap_sem
      Documentation/infiniband: update from locked to pinned_vm
      drivers/IB,qib: Fix pinned/locked limit check in qib_get_user_pages()

Devesh Sharma (9):
      RDMA/bnxt_re: Add chip context to identify 57500 series
      RDMA/bnxt_re: Add 64bit doorbells for 57500 series
      RDMA/bnxt_re: Skip backing store allocation for 57500 series
      RDMA/bnxt_re: Enable GSI QP support for 57500 series
      RDMA/bnxt_re: Add extended psn structure for 57500 adapters
      RDMA/bnxt_re: Update kernel user abi to pass chip context
      RDMA/bnxt_en: Enable RDMA driver support for 57500 chip
      bnxt_re: fix the regression due to changes in alloc_pbl
      bnxt_re: Clean cq for kernel consumers only

Doug Ledford (6):
      Merge branch 'opfn' into hfi1-tid
      Merge branch 'tid-read' into hfi1-tid
      Merge branch 'tid-write' into hfi1-tid
      Merge branch 'hfi1-tid' into wip/dl-for-next
      Merge branch 'wip/dl-for-next' into for-next
      Merge branch 'for-next' of git://git.kernel.org/.../rdma/rdma into fo=
r-next

Erez Alfasi (1):
      IB/ipoib: Use __func__ instead of function's name

Gal Pressman (6):
      IB/usnic: Fix out of bounds index check in query pkey
      RDMA/ocrdma: Fix out of bounds index check in query pkey
      RDMA/qedr: Fix out of bounds index check in query pkey
      RDMA: Add indication for in kernel API support to IB device
      IB/usnic: Remove stub functions
      IB/mlx5: Simplify WQE count power of two check

Greg Kroah-Hartman (8):
      infiniband: cxgb4: no need to check return value of debugfs_create fu=
nctions
      infiniband: hfi1: drop crazy DEBUGFS_SEQ_FILE_CREATE() macro
      infiniband: hfi1: no need to check return value of debugfs_create fun=
ctions
      infiniband: qib: no need to check return value of debugfs_create func=
tions
      infiniband: mlx5: no need to check return value of debugfs_create fun=
ctions
      infiniband: ocrdma: no need to check return value of debugfs_create f=
unctions
      infiniband: usnic: no need to check return value of debugfs_create fu=
nctions
      infiniband: ipoib: no need to check return value of debugfs_create fu=
nctions

Gustavo A. R. Silva (6):
      IB/cm: Use struct_size() in kmalloc()
      IB/usnic: Use struct_size() in kmalloc()
      IB/core: Use struct_size() in kzalloc()
      IB/srp: Use struct_size() in kzalloc()
      RDMA/mlx5: Replace kzalloc with kcalloc
      IB/hfi1: Add missing break in switch statement

H=C3=A5kon Bugge (1):
      IB/mlx4: Increase the timeout for CM cache

Ira Weiny (1):
      RDMA/qib: Use GUP longterm for PSM page pining

Israel Rukshin (1):
      IB/iser: Pass the correct number of entries for dma mapped SGL

Jason Gunthorpe (27):
      IB/{core,hw}: Have ib_umem_get extract the ib_ucontext from ib_udata
      RDMA/device: Use __ib_device_get_by_name() in ib_device_rename()
      RDMA/iw_cxgb4: Drop __GFP_NOFAIL
      Merge branch 'devx-async' into k.o/for-next
      Merge branch 'mlx5-next into rdma.git for-next
      Merge tag 'v5.0-rc5' into rdma.git for-next
      RDMA/device: Check that the rename is nop under the lock
      RDMA/device: Ensure that security memory is always freed
      RDMA/device: Call ib_cache_release_one() only from ib_device_release()
      RDMA/device: Get rid of reg_state
      RDMA/device: Use an ida instead of a free page in alloc_name
      RDMA/devices: Use xarray to store the clients
      RDMA/devices: Use xarray to store the client_data
      RDMA/devices: Re-organize device.c locking
      lib/scatterlist: Provide a DMA page iterator
      RDMA/uverbs: Fix an error flow in ib_uverbs_poll_cq
      RDMA: Add and use rdma_for_each_port
      RDMA/device: Consolidate ib_device per_port data into one place
      RDMA/cache: Move the cache per-port data into the main ib_port_data
      RDMA/device: Add ib_device_set_netdev() as an alternative to get_netd=
ev
      RDMA/device: Add ib_device_get_by_netdev()
      RDMA/rxe: Use ib_device_get_by_netdev() instead of open coding
      RDMA/device: Provide APIs from the core code to help unregistration
      RDMA/rxe: Use driver_unregister and new unregistration API
      RDMA/rxe: Add ib_device_get_by_name() and use it in rxe
      RDMA/rxe: Close a race after ib_register_device
      Merge branch 'mlx5-next' into rdma.git for-next

John Hubbard (2):
      RDMA/umem: minor bug fix in error handling path
      RDMA/umem: Revert broken 'off by one' fix

Kaike Wan (46):
      IB/hfi1: Add OPFN helper functions for TID RDMA feature
      IB/hfi1: OPFN interface
      IB/hfi1, IB/rdmavt: Allow for extending of QP's s_ack_queue
      IB/hfi1: Integrate OPFN into RC transactions
      IB/hfi1: Add static trace for OPFN
      IB/hfi: Move RC functions into a header file
      IB/hfi1: TID RDMA flow allocation
      IB/hfi1: TID RDMA RcvArray programming and TID allocation
      IB/hfi1: Add the counter n_tidwait
      IB/hfi1: Add static trace for flow and TID management functions
      IB/hfi1: Add functions to build TID RDMA READ request
      IB/hfi1: Set PbcInsertHcrc for TID RDMA packets
      IB/hfi1: Add functions to receive TID RDMA READ request
      IB/hfi1: Add a function to build TID RDMA READ response
      IB/hfi1: Add functions to receive TID RDMA READ response
      IB/hfi1: Add TID RDMA handlers
      IB/hfi1: Add functions for restarting TID RDMA READ request
      IB/hfi1: Increment the retry timeout value for TID RDMA READ request
      IB/hfi1: Integrate TID RDMA READ protocol into RC protocol
      IB/hfi1: Add interlock between a TID RDMA request and other requests
      IB/hfi1: Enable TID RDMA READ protocol
      IB/hfi1: Add static trace for TID RDMA READ protocol
      IB/hfi1: Build TID RDMA WRITE request
      IB/hfi1: Allow for extra entries in QP's s_ack_queue
      IB/hfi1: Add an s_acked_ack_queue pointer
      IB/hfi1: Add functions to receive TID RDMA WRITE request
      IB/hfi1: Add a function to build TID RDMA WRITE response
      IB/hfi1: Add TID resource timer
      IB/hfi1: Add a function to receive TID RDMA WRITE response
      IB/hfi1: Add a function to build TID RDMA WRITE DATA packet
      IB/hfi1: Add a function to receive TID RDMA WRITE DATA packet
      IB/hfi1: Add a function to build TID RDMA ACK packet
      IB/hfi1: Add a function to receive TID RDMA ACK packet
      IB/hfi1: Add TID RDMA retry timer
      IB/hfi1: Add a function to build TID RDMA RESYNC packet
      IB/hfi1: Add a function to receive TID RDMA RESYNC packet
      IB/hfi1: Resend the TID RDMA WRITE DATA packets
      IB/hfi1: Add the TID second leg send packet builder
      IB/hfi1: Add the TID second leg ACK packet builder
      IB/hfi1: Add the dual leg code
      IB/hfi1: Add TID RDMA WRITE functionality into RDMA verbs
      IB/hfi1: Add interlock between TID RDMA WRITE and other requests
      IB/hfi1: Enable TID RDMA WRITE protocol
      IB/hfi1: Add static trace for TID RDMA WRITE protocol
      IB/hfi1: Prioritize the sending of ACK packets
      IB/hfi1: Fix a build warning for TID RDMA READ

Kamal Heib (5):
      IB/ipoib: Make ipoib_intercept_dev_id_attr() static
      IB/mlx5: Make mlx5_ib_stage_odp_cleanup() static
      IB/mlx5: Remove set but not used variable
      RDMA/rxe: Move rxe_init_av() to rxe_av.c
      RDMA/rxe: Improve loopback marking

Leon Romanovsky (35):
      RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
      RDMA/core: Don't depend device ODP capabilities on kconfig option
      RDMA/mlx5: Introduce and reuse helper to identify ODP MR
      RDMA/mlx5: Embed into the code flow the ODP config option
      RDMA/mlx5: Delete declaration of already removed function
      RDMA: Clear PD objects during their allocation
      RDMA: Clear CQ objects during their allocation
      RDMA: Clear CTX objects during their allocation
      RDMA: Provide safe ib_alloc_device() function
      RDMA/nldev: Dynamically generate restrack dumpit callbacks
      RDMA/nldev: Factor out the PID namespace check
      RDMA/nldev: Prepare CAP_NET_ADMIN checks for .doit callbacks
      RDMA/core: Simplify restrack interface
      RDMA/restrack: Refactor user/kernel restrack additions
      RDMA/core: Use the ops infrastructure to keep all callbacks in one pl=
ace
      RDMA/cma: Remove CM_ID statistics provided by rdma-cm module
      RDMA/core: Share driver structure size with core
      RDMA: Handle PD allocations by IB/core
      RDMA/nes: Remove useless usecnt variable and redundant memset
      RDMA/cxgb4: Remove kref accounting for sync operation
      RDMA/restrack: Convert internal DB from hash to XArray
      RDMA/restrack: Translate from ID to restrack object
      RDMA/nldev: Add resource tracker doit callback
      RDMA/restrack: Reduce scope of synchronization lock while updating DB
      RDMA/restrack: Hide restrack DB from IB/core
      net/mlx5: Factor out HCA capabilities functions
      RDMA/restrack: Prepare restrack_root to addition of extra fields per-=
type
      RDMA/nldev: Share with user-space object IDs
      RDMA/nldev: Provide parent IDs for PD, MR and QP objects
      RDMA/nldev: Connect QP number to .doit callback
      RDMA/nldev: Don't expose number of not-visible entries
      RDMA/iwcm: Fix string truncation error
      RDMA/uverbs: Store PR pointer before it is overwritten
      RDMA: Handle ucontext allocations by IB/core
      RDMA/uverbs: Don't do double free of allocated PD

Lijun Ou (7):
      RDMA/hns: Fix the bug with updating rq head pointer when flush cqe
      RDMA/hns: Bugfix for the scene without receiver queue
      RDMA/hns: Add constraint on the setting of local ACK timeout
      RDMA/hns: Modify the pbl ba page size for hip08
      RDMA/hns: RDMA/hns: Assign rq head pointer when enable rq record db
      RDMA/hns: Configure capacity of hns device
      RDMA/hns: Modify qp&cq&pd specification according to UM

Maor Gottlieb (1):
      IB/mlx5: Don't override existing ip_protocol

Mark Bloch (1):
      RDMA/mlx5: Fix memory leak in case we fail to add an IB device

Masahiro Yamada (2):
      infiniband: remove unneeded header search paths
      infiniband: prefix header search paths with $(srctree)/

Max Gurtovoy (1):
      IB/iser: Fix dma_nents type definition

Michael J. Ruhl (4):
      IB/{hfi1,qib}: Cleanup open coded sge sizing
      IB/{hfi1, qib, rvt} Cleanup open coded sge usage
      IB/rdmavt: Fix concurrency panics in QP post_send and modify to error
      IB/hfi1: Close race condition on user context disable and close

Mike Marciniszyn (2):
      IB/rdmavt: Add wc_flags and wc_immdata to cq entry trace
      IB/rdmavt: Fix loopback send with invalidate ordering

Mitko Haralanov (1):
      IB/hfi1: OPFN support discovery

Moni Shoua (17):
      IB/mlx5: Ranges in implicit ODP MR inherit its write access
      IB/mlx5: Remove dead code
      IB/mlx5: Fix the locking of SRQ objects in ODP events
      IB/core: Allocate a bit for SRQ ODP support
      IB/uverbs: Expose XRC ODP device capabilities
      IB/mlx5: Remove useless check in ODP handler
      IB/mlx5: Clean mlx5_ib_mr_responder_pfault_handler() signature
      IB/mlx5: Add XRC initiator ODP support
      IB/mlx5: Let read user wqe also from SRQ buffer
      IB/mlx5: Add ODP SRQ support
      IB/mlx5: Advertise SRQ ODP support for supported transports
      IB/mlx5: Advertise XRC ODP support
      IB/mlx5: Protect against prefetch of invalid MR
      IB/mlx5: Validate correct PD before prefetch MR
      IB/core: Abort page fault handler silently during owning process exit
      IB/mlx5: Set correct write permissions for implicit ODP MR
      net/mlx5: ODP support for XRC transport is not enabled by default in =
FW

Myungho Jung (1):
      RDMA/cma: Rollback source IP address if failing to acquire device

Noa Osherovich (1):
      RDMA/core: Verify that memory window type is legal

Parav Pandit (9):
      RDMA: Rename port_callback to init_port
      RDMA: Introduce and use rdma_device_to_ibdev()
      IB/core: Simplify rdma cgroup registration
      IB/umad: Avoid additional device reference during open()/close()
      IB/umad: Do not check status of nonseekable_open()
      IB/mlx5: Consider vlan of lower netdev for macvlan GID entries
      RDMA/core: Use simpler device_del() instead of device_unregister()
      RDMA/core: Introduce and use ib_setup_port_attrs()
      RDMA/core: Move device addition deletion to device.c

Parvi Kaustubhi (2):
      IB/usnic: Fix locking when unregistering
      IB/usnic: Fix deadlock

Potnuri Bharat Teja (1):
      iw_cxgb4: Check for send WR also while posting write with completion =
WR

Raju Rangoju (4):
      RDMA/iw_cxgb4: Fix the unchecked ep dereference
      cxgb4: add tcb flags and tcb rpl struct
      iw_cxgb4: complete the cached SRQ buffers
      iw_cxgb4: fix srqidx leak during connection abort

Shamir Rabinovitch (4):
      IB/{core,uverbs}: Move ib_umem_xxx functions from ib_core to ib_uverbs
      IB/uverbs: Add ib_ucontext to uverbs_attr_bundle sent from ioctl and =
cmd flows
      IB/verbs: Add helper function rdma_udata_to_drv_context
      IB/{hw,sw}: Remove 'uobject->context' dependency in object creation A=
PIs

Shaobo He (1):
      cxgb4: kfree mhp after the debug print

Shiraz, Saleem (12):
      RDMA/bnxt_re: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/mthca: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/i40iw: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/hns: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/cxgb4: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/cxgb3: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/vmw_pvrdma: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/qedr: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/ocrdma: Use for_each_sg_dma_page iterator on umem SGL
      RDMA/rxe: Use for_each_sg_page iterator on umem SGL
      RDMA/rdmavt: Adapt to handle non-uniform sizes on umem SGEs
      RDMA/nes: Use for_each_sg_dma_page iterator for umem SGL

Steve Wise (12):
      iw_cxgb*: kzalloc the iwcm verbs struct
      RDMA/IWPM: refactor the IWPM message attribute names
      RDMA/IWPM: Support no port mapping requirements
      RDMA/iwpm: move kdoc comments to functions
      RDMA/cma: listening device cm_ids should inherit tos
      RDMA/iwcm: add tos_set bool to iw_cm struct
      iw_cxgb4: use listening ep tos when accepting new connections
      iw_cxgb4: use tos when importing the endpoint
      iw_cxgb4: use tos when finding ipv6 routes
      RDMA/core: Add RDMA_NLDEV_CMD_NEWLINK/DELLINK support
      rdma_rxe: Use netlink messages to add/delete links
      lib/irq_poll: Support schedules in non-interrupt contexts

Wei Hu (Xavier) (3):
      RDMA/hns: Fix the Oops during rmmod or insmod ko when reset occurs
      RDMA/hns: Fix the chip hanging caused by sending mailbox&CMQ during r=
eset
      RDMA/hns: Fix the chip hanging caused by sending doorbell during reset

Wei Yongjun (1):
      iw_cxgb4: Make function read_tcb() static

Xiaofei Tan (1):
      RDMA/hns: Add the process of AEQ overflow for hip08

Yangyang Li (4):
      RDMA/hns: Add SCC context allocation support for hip08
      RDMA/hns: Add SCC context clr support for hip08
      RDMA/hns: Add timer allocation support for hip08
      RDMA/hns: Bugfix for set hem of SCC

Yishai Hadas (8):
      IB/mlx5: DEVX handling for indirection MKEY
      IB/mlx5: Manage indirection mkey upon DEVX flow for ODP
      IB/mlx5: Add support for ODP for DEVX indirection mkey
      IB/mlx5: Introduce MLX5_IB_OBJECT_DEVX_ASYNC_CMD_FD
      IB/mlx5: Introduce async DEVX obj query API
      IB/mlx5: Implement the file ops of DEVX async command FD
      IB/mlx5: Implement DEVX hot unplug for async command FD
      IB/mlx5: Fix bad flow upon DEVX mkey creation

Yixian Liu (3):
      RDMA/hns: Fix the state of rereg mr
      RDMA/hns: Set allocated memory to zero for wrid
      RDMA/hns: Delete useful prints for aeq subtype event

YueHaibing (6):
      RDMA/qedr: remove set but not used variable 'ib_ctx'
      IB/hw: Remove unneeded semicolons
      RDMA/hns: Remove set but not used variable 'rst'
      RDMA/hns: Make some function static
      RDMA/iwpm: Remove set but not used variable 'msg_seq'
      RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp

Yuval Avnery (1):
      IB/core: Destroy QP if XRC QP fails

Yuval Shaia (1):
      RDMA/core: Cosmetic change - move member initialization to correct bl=
ock

Zhu Yanjun (1):
      IB/rxe: Remove unnecessary rxe variable

chenglang (1):
      RDMA/hns: Limit minimum ROCE CQ depth to 64

 .clang-format                                     |    2 +
 Documentation/infiniband/user_verbs.txt           |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c        |    8 +-
 drivers/infiniband/Kconfig                        |   15 +-
 drivers/infiniband/core/Makefile                  |    4 +-
 drivers/infiniband/core/cache.c                   |  118 +-
 drivers/infiniband/core/cgroup.c                  |    5 +-
 drivers/infiniband/core/cm.c                      |    3 +-
 drivers/infiniband/core/cma.c                     |  139 +-
 drivers/infiniband/core/cma_priv.h                |    4 +-
 drivers/infiniband/core/core_priv.h               |   35 +-
 drivers/infiniband/core/device.c                  | 1323 +++--
 drivers/infiniband/core/iwcm.c                    |   13 +-
 drivers/infiniband/core/iwpm_msg.c                |  232 +-
 drivers/infiniband/core/iwpm_util.c               |   86 +-
 drivers/infiniband/core/iwpm_util.h               |   12 +
 drivers/infiniband/core/mad.c                     |    4 +-
 drivers/infiniband/core/netlink.c                 |    4 +-
 drivers/infiniband/core/nldev.c                   |  492 +-
 drivers/infiniband/core/rdma_core.c               |   42 +-
 drivers/infiniband/core/restrack.c                |  210 +-
 drivers/infiniband/core/restrack.h                |   28 +
 drivers/infiniband/core/rw.c                      |   12 +-
 drivers/infiniband/core/sa_query.c                |    4 +-
 drivers/infiniband/core/security.c                |   96 +-
 drivers/infiniband/core/sysfs.c                   |   93 +-
 drivers/infiniband/core/ucma.c                    |    7 +
 drivers/infiniband/core/umem.c                    |   60 +-
 drivers/infiniband/core/umem_odp.c                |   21 +-
 drivers/infiniband/core/user_mad.c                |   52 +-
 drivers/infiniband/core/uverbs_cmd.c              |   69 +-
 drivers/infiniband/core/uverbs_ioctl.c            |    3 +
 drivers/infiniband/core/uverbs_main.c             |    2 +
 drivers/infiniband/core/uverbs_std_types.c        |    2 +-
 drivers/infiniband/core/uverbs_uapi.c             |   15 +-
 drivers/infiniband/core/verbs.c                   |   73 +-
 drivers/infiniband/hw/bnxt_re/Kconfig             |    1 +
 drivers/infiniband/hw/bnxt_re/Makefile            |    2 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h           |    1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c          |  268 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h          |   16 +-
 drivers/infiniband/hw/bnxt_re/main.c              |  134 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c          |  193 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h          |   47 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c        |   40 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h        |   45 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c         |   22 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h         |   30 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c          |    3 +-
 drivers/infiniband/hw/bnxt_re/roce_hsi.h          |  160 +-
 drivers/infiniband/hw/cxgb3/Makefile              |    2 +-
 drivers/infiniband/hw/cxgb3/iwch.c                |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c       |   95 +-
 drivers/infiniband/hw/cxgb4/Makefile              |    4 +-
 drivers/infiniband/hw/cxgb4/cm.c                  |  199 +-
 drivers/infiniband/hw/cxgb4/device.c              |   10 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h            |   16 +-
 drivers/infiniband/hw/cxgb4/mem.c                 |   36 +-
 drivers/infiniband/hw/cxgb4/provider.c            |   85 +-
 drivers/infiniband/hw/cxgb4/qp.c                  |   33 +-
 drivers/infiniband/hw/cxgb4/t4.h                  |    1 +
 drivers/infiniband/hw/hfi1/Makefile               |    1 +
 drivers/infiniband/hw/hfi1/chip.c                 |   13 +
 drivers/infiniband/hw/hfi1/chip.h                 |    4 +-
 drivers/infiniband/hw/hfi1/common.h               |    4 +
 drivers/infiniband/hw/hfi1/debugfs.c              |   58 +-
 drivers/infiniband/hw/hfi1/debugfs.h              |   12 -
 drivers/infiniband/hw/hfi1/driver.c               |   58 +-
 drivers/infiniband/hw/hfi1/fault.c                |   53 +-
 drivers/infiniband/hw/hfi1/hfi.h                  |   24 +-
 drivers/infiniband/hw/hfi1/init.c                 |   35 +-
 drivers/infiniband/hw/hfi1/iowait.c               |   34 +-
 drivers/infiniband/hw/hfi1/iowait.h               |   99 +-
 drivers/infiniband/hw/hfi1/opfn.c                 |  323 ++
 drivers/infiniband/hw/hfi1/opfn.h                 |   85 +
 drivers/infiniband/hw/hfi1/pio.c                  |   18 +-
 drivers/infiniband/hw/hfi1/qp.c                   |   76 +-
 drivers/infiniband/hw/hfi1/qp.h                   |    7 +
 drivers/infiniband/hw/hfi1/rc.c                   | 1141 ++++-
 drivers/infiniband/hw/hfi1/rc.h                   |   51 +
 drivers/infiniband/hw/hfi1/ruc.c                  |   48 +-
 drivers/infiniband/hw/hfi1/sdma.c                 |   24 +-
 drivers/infiniband/hw/hfi1/sdma_txreq.h           |    1 +
 drivers/infiniband/hw/hfi1/sysfs.c                |   16 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c             | 5418 +++++++++++++++++=
++++
 drivers/infiniband/hw/hfi1/tid_rdma.h             |  311 +-
 drivers/infiniband/hw/hfi1/trace.c                |  118 +
 drivers/infiniband/hw/hfi1/trace.h                |    1 +
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h         |    8 +
 drivers/infiniband/hw/hfi1/trace_rc.h             |   48 +
 drivers/infiniband/hw/hfi1/trace_rx.h             |  107 +-
 drivers/infiniband/hw/hfi1/trace_tid.h            | 1610 ++++++
 drivers/infiniband/hw/hfi1/trace_tx.h             |   18 +-
 drivers/infiniband/hw/hfi1/uc.c                   |    3 +-
 drivers/infiniband/hw/hfi1/ud.c                   |   24 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.h         |    1 -
 drivers/infiniband/hw/hfi1/user_pages.c           |   12 +-
 drivers/infiniband/hw/hfi1/user_sdma.c            |    9 +-
 drivers/infiniband/hw/hfi1/verbs.c                |  210 +-
 drivers/infiniband/hw/hfi1/verbs.h                |  104 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h          |    1 +
 drivers/infiniband/hw/hfi1/vnic_sdma.c            |    6 +-
 drivers/infiniband/hw/hns/Kconfig                 |    1 -
 drivers/infiniband/hw/hns/Makefile                |    2 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c          |   32 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.h          |   12 +
 drivers/infiniband/hw/hns/hns_roce_cq.c           |    9 +-
 drivers/infiniband/hw/hns/hns_roce_db.c           |    6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h       |   63 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c          |   68 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h          |    3 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c        |   36 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c        |  596 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h        |   92 +-
 drivers/infiniband/hw/hns/hns_roce_main.c         |   88 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c           |   95 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c           |   25 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c           |   92 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c          |   16 +-
 drivers/infiniband/hw/i40iw/Makefile              |    2 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c         |    1 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c         |  137 +-
 drivers/infiniband/hw/mlx4/Kconfig                |    1 -
 drivers/infiniband/hw/mlx4/cm.c                   |    2 +-
 drivers/infiniband/hw/mlx4/cq.c                   |   19 +-
 drivers/infiniband/hw/mlx4/doorbell.c             |    6 +-
 drivers/infiniband/hw/mlx4/main.c                 |   77 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h              |    3 +-
 drivers/infiniband/hw/mlx4/mr.c                   |   13 +-
 drivers/infiniband/hw/mlx4/qp.c                   |   84 +-
 drivers/infiniband/hw/mlx4/srq.c                  |   12 +-
 drivers/infiniband/hw/mlx5/Kconfig                |    1 -
 drivers/infiniband/hw/mlx5/cong.c                 |   15 +-
 drivers/infiniband/hw/mlx5/cq.c                   |   15 +-
 drivers/infiniband/hw/mlx5/devx.c                 |  463 +-
 drivers/infiniband/hw/mlx5/doorbell.c             |    6 +-
 drivers/infiniband/hw/mlx5/ib_rep.c               |    6 +-
 drivers/infiniband/hw/mlx5/main.c                 |  249 +-
 drivers/infiniband/hw/mlx5/mem.c                  |    5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |   41 +-
 drivers/infiniband/hw/mlx5/mr.c                   |  126 +-
 drivers/infiniband/hw/mlx5/odp.c                  |  316 +-
 drivers/infiniband/hw/mlx5/qp.c                   |  308 +-
 drivers/infiniband/hw/mlx5/srq.c                  |   11 +-
 drivers/infiniband/hw/mlx5/srq.h                  |    2 -
 drivers/infiniband/hw/mlx5/srq_cmd.c              |   16 +-
 drivers/infiniband/hw/mthca/mthca_main.c          |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c      |  139 +-
 drivers/infiniband/hw/mthca/mthca_qp.c            |   13 +-
 drivers/infiniband/hw/mthca/mthca_srq.c           |   21 +-
 drivers/infiniband/hw/nes/Kconfig                 |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c             |  313 +-
 drivers/infiniband/hw/nes/nes_verbs.h             |    1 -
 drivers/infiniband/hw/ocrdma/Makefile             |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c        |   12 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c       |   67 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c       |  189 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h       |   11 +-
 drivers/infiniband/hw/qedr/main.c                 |    9 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c           |    2 +-
 drivers/infiniband/hw/qedr/verbs.c                |  192 +-
 drivers/infiniband/hw/qedr/verbs.h                |   10 +-
 drivers/infiniband/hw/qib/qib_debugfs.c           |   27 +-
 drivers/infiniband/hw/qib/qib_rc.c                |    7 +-
 drivers/infiniband/hw/qib/qib_sdma.c              |   26 +-
 drivers/infiniband/hw/qib/qib_sysfs.c             |   18 +-
 drivers/infiniband/hw/qib/qib_ud.c                |    6 +-
 drivers/infiniband/hw/qib/qib_user_pages.c        |   75 +-
 drivers/infiniband/hw/qib/qib_verbs.c             |   20 +-
 drivers/infiniband/hw/usnic/Makefile              |    2 +-
 drivers/infiniband/hw/usnic/usnic_debugfs.c       |   26 -
 drivers/infiniband/hw/usnic/usnic_ib_main.c       |   57 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c      |   26 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c      |  114 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h      |   28 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c          |   65 +-
 drivers/infiniband/hw/usnic/usnic_uiom.h          |    1 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c      |    2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |   15 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    |   12 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c    |   21 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c      |    3 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c      |    6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c     |    4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |   98 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |   12 +-
 drivers/infiniband/sw/rdmavt/mr.c                 |   21 +-
 drivers/infiniband/sw/rdmavt/pd.c                 |   29 +-
 drivers/infiniband/sw/rdmavt/pd.h                 |    7 +-
 drivers/infiniband/sw/rdmavt/qp.c                 |  104 +-
 drivers/infiniband/sw/rdmavt/rc.c                 |   13 +
 drivers/infiniband/sw/rdmavt/srq.c                |    5 +-
 drivers/infiniband/sw/rdmavt/trace_cq.h           |   10 +-
 drivers/infiniband/sw/rdmavt/vt.c                 |   34 +-
 drivers/infiniband/sw/rxe/rxe.c                   |   67 +-
 drivers/infiniband/sw/rxe/rxe.h                   |   16 +-
 drivers/infiniband/sw/rxe/rxe_av.c                |    7 +
 drivers/infiniband/sw/rxe/rxe_comp.c              |    6 +-
 drivers/infiniband/sw/rxe/rxe_loc.h               |    9 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                |   15 +-
 drivers/infiniband/sw/rxe/rxe_net.c               |   97 +-
 drivers/infiniband/sw/rxe/rxe_net.h               |    2 +-
 drivers/infiniband/sw/rxe/rxe_param.h             |    3 +-
 drivers/infiniband/sw/rxe/rxe_pool.c              |   77 +-
 drivers/infiniband/sw/rxe/rxe_pool.h              |    4 +
 drivers/infiniband/sw/rxe/rxe_qp.c                |   15 +-
 drivers/infiniband/sw/rxe/rxe_recv.c              |   12 +-
 drivers/infiniband/sw/rxe/rxe_resp.c              |    3 +-
 drivers/infiniband/sw/rxe/rxe_sysfs.c             |   40 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c             |  103 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h             |    9 +-
 drivers/infiniband/ulp/ipoib/ipoib.h              |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c           |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c         |   14 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h          |    2 +-
 drivers/infiniband/ulp/iser/iser_memory.c         |   19 +-
 drivers/infiniband/ulp/isert/Makefile             |    1 -
 drivers/infiniband/ulp/srp/ib_srp.c               |   26 +-
 drivers/infiniband/ulp/srpt/Makefile              |    1 -
 drivers/media/pci/intel/ipu3/ipu3-cio2.c          |    4 +-
 drivers/misc/mic/scif/scif_rma.c                  |   38 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |    3 -
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h       |    8 +
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h       |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   85 +-
 fs/proc/task_mmu.c                                |    2 +-
 include/linux/cgroup_rdma.h                       |    2 +-
 include/linux/mlx5/driver.h                       |    5 +-
 include/linux/mm_types.h                          |    2 +-
 include/linux/scatterlist.h                       |   49 +-
 include/rdma/ib_hdrs.h                            |   14 +-
 include/rdma/ib_mad.h                             |    5 +-
 include/rdma/ib_umem.h                            |    8 +-
 include/rdma/ib_umem_odp.h                        |   34 +-
 include/rdma/ib_verbs.h                           |  274 +-
 include/rdma/iw_cm.h                              |   16 +-
 include/rdma/iw_portmap.h                         |  144 +-
 include/rdma/rdma_cm.h                            |    1 +
 include/rdma/rdma_netlink.h                       |   11 +
 include/rdma/rdma_vt.h                            |   30 +-
 include/rdma/rdmavt_qp.h                          |   20 +-
 include/rdma/restrack.h                           |   58 +-
 include/rdma/tid_rdma_defs.h                      |  108 +
 include/rdma/uverbs_ioctl.h                       |   18 +
 include/rdma/uverbs_std_types.h                   |   18 +-
 include/rdma/uverbs_types.h                       |    1 +
 include/uapi/rdma/bnxt_re-abi.h                   |   11 +
 include/uapi/rdma/ib_user_verbs.h                 |    2 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h          |   18 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h         |    5 +
 include/uapi/rdma/rdma_netlink.h                  |   74 +-
 include/uapi/rdma/rdma_user_cm.h                  |    4 +
 include/uapi/rdma/rdma_user_rxe.h                 |    3 +-
 kernel/cgroup/rdma.c                              |    5 +-
 kernel/events/core.c                              |    8 +-
 kernel/fork.c                                     |    2 +-
 lib/irq_poll.c                                    |    2 +-
 lib/scatterlist.c                                 |   26 +
 mm/debug.c                                        |    5 +-
 net/rds/ib.h                                      |   12 +-
 net/rds/ib_fmr.c                                  |    8 +-
 net/rds/ib_frmr.c                                 |    4 +-
 net/rds/ib_recv.c                                 |    8 +-
 net/rds/ib_send.c                                 |   15 +-
 264 files changed, 16710 insertions(+), 5014 deletions(-)
(diffstat from tag for-linus-merged)

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlyAdQ8ACgkQOG33FX4g
mxqeOA/+PHl7KaNZUWaJwt7rY2SN3LdgrDzq2frU9MXSObXawfH6CEV7ICawI7vJ
MHxeiZk1UuFPd5N0JPzwrAQJ4M3hjSF56j5shBMHnBkWpNj+ZqJ1B92W/+CbeiRM
COCNxGaTHrbvo58KM+L1p6X6j7FaqfAK6JxOnI8ra30MobMGJ4QBbhSxiSrpku97
s1wk5FEtBL8d0Pg8V9vWT9usQ8j1p3E9EOtb3QIxsnXVj/hH6hZfY1Fnidw5F2sF
J+mC3m3oJ0GOkflL4cyNdKVQXrNTw6ygvJy8zWHhs2ZTDPrRC53qCjdR636HXrUq
ZlMvDG1scgGeHtd8AjRGLbGXJVSexMzi6kpeuUakTgYawWl689cT6z4ojdZEOzRy
0NuwFq/PAHEdqmXzlVPw7E5PssavTOudQ63001AQWIr1udg6K0BVJp0o2u1lFZRu
Wf5fAdNPiah28K2SLhtOlXag54teqx1uLl6TlpFZQVpV00OlSdPbou9wjGJXsnJD
sTLaMpPUEPCZsBymL7BzJ4ZNmIgYvG1efh9ngiQyXxN4fhjlH5tKkVQSONzV2UvT
EjhrF0u7pvxZPptUtslbkesIpEbFUY5AVUXgO4DLmfl+LG+V71vZ56ypebQ5mjTQ
GKskJh6bkw1yg538ccthnRHUDsqRSJs/5P8zBpzwSgjMsizLL2Q=
=t9cS
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
