From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 31 Jan 2018 10:47:35 -0700
Message-ID: <20180131174735.GA18568@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The is the first pull request for the merge window. We are aware of
another 20-30 patches that didn't make the cutoff and are various
kinds of fixes and code quality improvements. Due to this we are
anticipating a 2nd pull request next week.

This cycle had two conflicts between the RDMA tree and v4.15 due to
netdev and RDMA patches that went into the -rc cycle. I checked with
the Mellanox teams involved and they confirm they were co-ordinated
about this and felt the -rc patches needed to go ahead. There were
also two conflicts between RDMA -rc patches and RDMA -next patches
that were resolved by applying for-next patches overtop of RDMA -rc
and merging into RDMA -next.

Since the conflict with v4.15 involves some code motion and is not so
trivial, so I have included a merge to tag v4.15 as the top commit in
this PR that has the resolution reviewed by the patch authors and
tested in linux-next. The tag 'for-linus-unmerged' is available
without this merge if you desire.

Overall this cycle did not have any major excitement, and did not
require any shared branch with netdev. Lots of driver updates,
particularly of the scale-up and performance variety. The largest body
of core work was Parav's patches fixing and restructing some of the
core code to make way for future RDMA containerization.

There is one commit out of our tree:
 lib/kobject.c                                      |    2 +
That was Ack'd by GKH

Regards,
Jason

The following changes since commit d8a5b80568a9cb66810e75b182018e9edb68e8ff:

  Linux 4.15 (2018-01-28 13:20:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to e7996a9a77fc669387da43ff4823b91cc4872bd0:

  Merge tag v4.15 of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git (2018-01-30 09:30:00 -0700)

----------------------------------------------------------------
First merge window pull request for 4.16

- Misc small driver fixups to
  bnxt_re/hfi1/qib/hns/ocrdma/rdmavt/vmw_pvrdma/nes
- Several major feature adds to bnxt_re driver: SRIOV VF RoCE support,
  HugePages support, extended hardware stats support, and SRQ support
- A notable number of fixes to the i40iw driver from debugging scale up
  testing
- More work to enable the new hip08 chip in the hns driver
- Misc small ULP fixups to srp/srpt//ipoib
- Preparation for srp initiator and target to support the RDMA-CM
  protocol for connections
- Add RDMA-CM support to srp initiator, srp target is still a WIP
- Fixes for a couple of places where ipoib could spam the dmesg log
- Fix encode/decode of FDR/EDR data rates in the core
- Many patches from Parav with ongoing work to clean up inconsistencies
  and bugs in RoCE support around the rdma_cm
- mlx5 driver support for the userspace features 'thread domain', 'wallclock
  timestamps' and 'DV Direct Connected transport'. Support for the firmware
  dual port rocee capability
- Core support for more than 32 rdma devices in the char dev allocation
- kernel doc updates from Randy Dunlap
- New netlink uAPI for inspecting RDMA objects similar in spirit to 'ss'
- One minor change to the kobject code acked by GKH

----------------------------------------------------------------
Alex Estrin (1):
      IB/ipoib: Fix for notify send CQ failure messages

Amrani, Ram (1):
      MAINTAINERS: Remove Ram Amrani from Q-Logic RDMA driver

Andrew F. Davis (1):
      IB/ocrdma: Remove unneeded conversions to bool

Andy Shevchenko (1):
      IB/srp: replace custom implementation of hex2bin()

Anton Vasilyev (1):
      RDMA/ocrdma: Fix permissions for OCRDMA_RESET_STATS

Arnd Bergmann (4):
      i40iw: remove unused 'timeval' struct member
      nes: remove unused 'timeval' struct member
      IB/mlx5: revisit -Wmaybe-uninitialized warning
      infiniband: cxgb4: use ktime_get for timestamps

Artemy Kovalyov (1):
      IB/umem: Fix use of npages/nmap fields

Arvind Yadav (1):
      RDMA/bnxt_re: Remove redundant bnxt_qplib_disable_nq() call

Bart Van Assche (35):
      IB/core: Fix two kernel warnings triggered by rxe registration
      IB/srpt: Remove an unused structure member
      IB/srpt: Fix kernel-doc warnings in ib_srpt.c
      IB/srpt: Document all structure members in ib_srpt.h
      IB/srpt: Rename a local variable, a member variable and a constant
      IB/srpt: Reduce the severity level of a log message
      IB/srpt: Verify port numbers in srpt_event_handler()
      IB/srpt: Use the IPv6 format for GIDs in log messages
      IB/srpt: Convert a warning into a debug message
      IB/srpt: Reduce frequency of receive failure messages
      IB/srpt: Introduce srpt_format_guid()
      IB/srpt: Inline srpt_get_cmd_state()
      IB/srpt: Micro-optimize I/O context state manipulation
      RDMA/rxe: Fix a race condition related to the QP error state
      RDMA/rxe: Fix a race condition in rxe_requester()
      RDMA/rxe: Fix rxe_qp_cleanup()
      IB/srp: Use kstrtoull() instead of simple_strtoull()
      IB/srp: Improve path record query error message
      IB/srp: Refactor srp_send_req()
      IB/srpt: Make it safe to use RCU for srpt_device.rch_list
      IB/srpt: Rework srpt_disconnect_ch_sync()
      IB/srpt: Add P_Key support
      IB/srpt: One target per port
      IB/srpt: Use the source GID as session name
      IB/srpt: Rework multi-channel support
      IB/srpt: Simplify srpt_close_session()
      IB/srpt: Log all zero-length writes and completions
      IB/srpt: Fix login-related race conditions
      IB/srpt: Fix a race condition related to wait list processing
      IB/srpt: Don't allow reordering of commands on wait list
      IB/srpt: Preparations for adding RDMA/CM support
      IB/srpt: Move the code for parsing struct ib_cm_req_event_param
      kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
      IB/srp: Add RDMA/CM support
      IB/srp: Add target_can_queue login parameter

Bharat Potnuri (2):
      iser-target: avoid reinitializing rdma contexts for isert commands
      iw_cxgb4: Change error/warn prints to pr_debug

Bodong Wang (1):
      IB/core: Fix ib_wc structure size to remain in 64 bytes boundary

Bryan Tan (5):
      RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file
      RDMA/vmw_pvrdma: Clarify QP and CQ is_kernel logic
      RDMA/vmw_pvrdma: Use more specific sizeof in kcalloc
      RDMA/vmw_pvrdma: Use refcount_t instead of atomic_t
      RDMA/vmw_pvrdma: Remove usage of BIT() from UAPI header

Chien Tin Tung (1):
      i40iw: Use sqsize to initialize cqp_requests elements

Colin Ian King (3):
      IB/qib: remove redundant setting of any in for-loop
      iw_cxgb4: make pointer reg_workq static
      IB/mlx5: remove redundant assignment of mdev

Corentin Labbe (2):
      IB/mthca: remove mthca_user.h
      IB/qib: remove qib_keys.c

Dan Carpenter (2):
      RDMA/cxgb4: Add a sanity check in process_work()
      IB/mlx4: Potential buffer overflow in _mlx4_set_path()

Daniel Jurgens (14):
      IB/cm: Add debug prints to ib_cm
      net/mlx5: Fix race for multiple RoCE enable
      net/mlx5: Set software owner ID during init HCA
      IB/core: Change roce_rescan_device to return void
      IB/mlx5: Reduce the use of num_port capability
      IB/mlx5: Make netdev notifications multiport capable
      {net, IB}/mlx5: Manage port association for multiport RoCE
      IB/mlx5: Move IB event processing onto a workqueue
      IB/mlx5: Implement dual port functionality in query routines
      IB/mlx5: Update counter implementation for dual port RoCE
      {net, IB}/mlx5: Change set_roce_gid to take a port number
      IB/mlx5: Route MADs for dual port RoCE
      IB/mlx5: Don't advertise RAW QP support in dual port mode
      net/mlx5: Set num_vhca_ports capability

Davidlohr Bueso (1):
      IB/mthca: Fix gup usage in mthca_map_user_db()

Dennis Dalessandro (1):
      rdma: Update maintainer contact for Intel RDMA drivers

Devesh Sharma (1):
      RDMA/bnxt_re: Add SRQ support for Broadcom adapters

Don Hiatt (4):
      IB/hfi1: Mask the path bits with the LMC for 16B RC Acks
      IB/CM: Change sgid to IB GID when handling CM request
      IB/core: Use rdma_cap_opa_mad to check for OPA
      IB/hfi1: Change slid arg in ingress_pkey_table_fail to 32bit

Doug Ledford (2):
      Merge branch 'bart-srpt-for-next' into k.o/wip/dl-for-next
      MAINTAINERS: Fix the location of the rdma git repo

Erez Alfasi (1):
      IB/mlx4: Remove unused ibpd parameter

Erez Shitrit (2):
      IB/ipoib: Avoid memory leak if the SA returns a different DGID
      IB/ipoib: Update pathrec field if not valid record

Feras Daoud (2):
      net/mlx5e: Add clock info page to mlx5 core devices
      IB/mlx5: Mmap the HCA's clock info to user-space

Geert Uytterhoeven (2):
      i40w: Remove garbage at end of INFINIBAND_I40IW Kconfig section
      RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()

Gomonovych, Vasyl (1):
      IB/core: Use PTR_ERR_OR_ZERO()

Guy Levi (1):
      IB/mlx4: Add support to RSS hash for inner headers

Hans Westgaard Ry (1):
      RDMA/core: Add encode/decode FDR/EDR rates

Henry Orosco (1):
      i40iw: Change accelerated flag to bool

Himanshu Jha (5):
      IB/ocrdma: Use zeroing memory allocator than allocator/memset
      RDMA/vmw_pvrdma: Use zeroing memory allocator than allocator/memset
      RDMA/qedr: Use zeroing memory allocator than allocator/memset
      RDMA/bnxt_re: Use zeroing memory allocator than allocator/memset
      IB/mthca: Use zeroing memory allocator than allocator/memset

Huy Nguyen (2):
      IB/core: Remove the locking for character device bitmaps
      IB/core: Increase number of char device minors

Jack Morgenstein (2):
      IB/mlx4: Fix incorrectly releasing steerable UD QPs when have only ETH ports
      IB/umad: Fix use of unprotected device pointer

Jan Sokolowski (1):
      IB/hfi1: Use 4096 for default active MTU in query_qp

Jason Gunthorpe (8):
      Merge branch 'from-rc' of git://git.kernel.org/.../rdma/rdma.git
      RDMA: Mark imm_data as be32 in the verbs uapi header
      RDMA/hns: Fix endian problems around imm_data and rkey
      RDMA/qedr: Fix endian problems around imm_data
      RDMA/uverbs: Use an unambiguous errno for method not supported
      IB/rxe: Change RDMA_RXE kconfig to use select
      RDMA: Move enum ib_cq_creation_flags to uapi headers
      Merge tag v4.15 of git://git.kernel.org/.../torvalds/linux-2.6.git

Jia-Ju Bai (1):
      i40iw: Replace mdelay with msleep in i40iw_wait_pe_ready

Joe Perches (1):
      IB/qib: Cleanup qib_set_part_key() with direct returns

Jonathan Toppins (1):
      bnxt_re: report RoCE device support at info level

Kaike Wan (2):
      IB/rdmavt: No need to cancel RNRNAK retry timer when it is running
      IB/rdmavt: Add trace for RNRNAK timer

Kalderon, Michal (1):
      RDMA/qedr: lower print level of flushed CQEs

Leon Romanovsky (17):
      RDMA/rxe: Remove useless EXPORT_SYMBOL
      RDMA/netlink: Simplify code of autoload modules
      RDMA/core: Replace open-coded variant of put_device
      RDMA/nldev: Refactor setting the nldev handle to a common function
      RDMA/cma: Mark end of CMA ID messages
      RDMA/mlx5: Remove redundant allocation warning print
      RDMA/srpt: Fix RCU debug build error
      RDMA/mlx5: Avoid memory leak in case of XRCD dealloc failure
      RDMA/cm: Fix access to uninitialized variable
      RDMA/core: Use the MODNAME instead of the function name for pd callers
      RDMA/core: Save kernel caller name when creating PD and CQ objects
      RDMA/restrack: Add general infrastructure to track RDMA resources
      RDMA/core: Add resource tracking for create and destroy QPs
      RDMA/core: Add resource tracking for create and destroy CQs
      RDMA/core: Add resource tracking for create and destroy PDs
      RDMA/nldev: Provide global resource utilization
      RDMA/nldev: Provide detailed QP information

Majd Dibbiny (1):
      IB/core: Make sure that PSN does not overflow

Maor Gottlieb (1):
      IB/mlx5: Report inner RSS capability

Mark Bloch (6):
      IB/mlx5: Create profile infrastructure to add and remove stages
      IB/mlx5: Move RoCE/ETH initialization to the corresponding stage
      IB/mlx5: Move ODP initialization to the corresponding stage
      IB/mlx5: Move hardware counters initialization to the corresponding stage
      IB/mlx5: Move loopback initialization to the corresponding stage
      IB/mlx5: Move locks initialization to the corresponding stage

Markus Elfring (3):
      IB/iser: Delete an error message for a failed memory allocation in iser_send_data_out()
      IB/iser: Delete an unnecessary variable initialisation in iser_send_data_out()
      IB/iser: Combine substrings for three messages

Matan Barak (1):
      IB/core: Fix memory leak in cm_req_handler error flows

Max Gurtovoy (1):
      IB/core: postpone WR initialization during queue drain

Michael J. Ruhl (4):
      IB/hfi1: Add RQ/SRQ information to QP stats
      IB/{rdmavt, hfi1, qib}: Self determine driver name
      IB/{rdmavt, hfi1, qib}: Remove get_card_name() downcall
      IB/{hfi1, qib}: Fix a concurrency issue with device name in logging

Mike Marciniszyn (3):
      IB/qib: Fix comparison error with qperf compare/swap test
      IB/rdmavt: Use correct numa node for SRQ allocation
      IB/rdmavt: Allocate CQ memory on the correct node

Moni Shoua (6):
      net/mlx5: Add DCT command interface
      net/mlx5: Enable DC transport
      IB/core: Introduce driver QP type
      IB/mlx5: Handle type IB_QPT_DRIVER when creating a QP
      IB/mlx5: Add support for DC Initiator QP
      IB/mlx5: Add support for DC target QP

Mustafa Ismail (3):
      i40iw: Reinitialize add_sd_cnt
      i40iw: Remove setting of rem_addr.len
      i40iw: Free IEQ resources

Parav Pandit (44):
      IB/{core/cm}: Fix generating a return AH for RoCEE
      IB/core: Depend on IPv6 stack to resolve link local address for RoCEv2
      IB/core: Avoid exporting module internal function
      RDMA/cma: Use correct size when writing netlink stats
      RDMA/cma: Set default GID type as RoCE when resolving RoCE route
      RDMA/cma: Simplify netdev check
      RDMA/cma: Avoid setting path record type twice
      RDMA/cma: Introduce and use helper functions to init work
      IB/core: Avoid unnecessary type cast
      IB/core: Refactor to avoid unnecessary check on GID lookup miss
      IB/rxe: Avoid passing unused index pointer which is optional
      IB/core: Avoid exporting module internal ib_find_gid_by_filter()
      RDMA/core: Avoid redundant memcpy in rdma_addr_find_l2_eth_by_grh
      IB/core: Removed unused function
      RDMA/{core, cma}: Simplify rdma_translate_ip
      RDMA/core: Avoid copying ifindex twice
      IB/{core, ipoib}: Simplify ib_find_gid to search only for IB link layer
      IB/{cm, umad}: Handle av init error
      IB/cm: Handle address handle attribute init error
      IB/cm: Fix sleeping while spin lock is held
      IB/{core, cm, cma, ipoib}: Rename ib_init_ah_from_path to ib_init_ah_attr_from_path
      IB/{core, umad, cm}: Rename ib_init_ah_from_wc to ib_init_ah_attr_from_wc
      IB/cm: Refactor to avoid setting path record software only fields
      IB/mlx5: Change debugfs to have per port contents
      RDMA/cma: Use the right net namespace for the rdma_cm_id
      RDMA/cma: Provide a function to set RoCE path record L2 parameters
      RDMA/{cma, ucma}: Simplify and rename rdma_set_ib_paths
      RDMA/cma: Fix rdma_cm raw IB path setting for RoCE
      RDMA/cma: Fix rdma_cm path querying for RoCE
      IB/core: Perform modify QP on real one
      IB/core: Limit DMAC resolution to userspace QPs
      IB/core: Attempt DMAC resolution for only RoCE
      IB/core: Limit DMAC resolution to RoCE Connected QPs
      RDMA/core: Clarify rdma_ah_find_type
      RDMA/cma: Introduce API to read GIDs for multiple transports
      RDMA/ucma: Use rdma cm API to query GID
      net/rds: Use rdma_read_gids to read connection GIDs
      RDMA/core: Simplify rdma_addr_get_sgid() to not support RoCE
      RDMA/cma: Check existence of netdevice during port validation
      RDMA/cma: Refactor to access multiple fields of rdma_dev_addr
      RDMA/cma: Update cma_validate_port to honor net namespace
      RDMA/cma: Update RoCE multicast routines to use net namespace
      IB/core: Avoid SGID attributes query while converting GID from OPA to IB
      RDMA/cma: Use existing netif_is_bond_master function

Pravin Shedge (1):
      drivers: infiniband: remove duplicate includes

Randy Dunlap (5):
      infiniband: drop unknown function from core_priv.h
      infiniband: fix core/verbs.c kernel-doc notation
      infiniband: fix core/fmr_pool.c kernel-doc notation
      infiniband: fix ulp/opa_vnic/opa_vnic_vema.c kernel-doc notation
      infiniband: fix sw/rdmavt/* kernel-doc notation

Sagi Grimberg (1):
      IB/cq: Don't force IB_POLL_DIRECT poll context for ib_process_cq_direct

Sebastian Sanchez (1):
      IB/hfi1: Fix infinite loop in 8051 command error path

Selvin Xavier (3):
      RDMA/bnxt_re: Enable RoCE on virtual functions
      RDMA/bnxt_re: Add support for query firmware version
      RDMA/bnxt_re: expose detailed stats retrieved from HW

Shiraz Saleem (10):
      nes: Change accelerated flag to bool
      i40iw: Set MAX_IRD_SIZE to 64
      i40iw: Use utility function roundup_pow_of_two()
      i40iw: Correct Q1/XF object count equation
      i40iw: Add notifier for network device events
      i40iw: Selectively teardown QPs on IP addr change event
      i40iw: Fix sequence number for the first partial FPDU
      i40iw: Ignore LLP_DOUBT_REACHABILITY AE
      i40iw: Remove extra call to i40iw_est_sd()
      i40iw: Zero-out consumer key on allocate stag for FMR

Sindhu Devale (1):
      i40iw: Remove limit on re-posting AEQ entries to HW

Somnath Kotur (1):
      RDMA/bnxt_re: Add support for MRs with Huge pages

Tatyana Nikolova (2):
      i40iw: Validate correct IRD/ORD connection parameters
      i40iw: Fix the connection ORD value for loopback

Venkata Sandeep Dhanalakota (1):
      IB/SA: Check dlid before SA agent queries for ClassPortInfo

Xiongfeng Wang (1):
      IB/cma: use strlcpy() instead of strncpy()

Yishai Hadas (3):
      IB/mlx5: Extend UAR stuff to support dynamic allocation
      IB/mlx5: Expose dynamic mmap allocation
      IB/mlx5: Enable QP creation with a given blue flame index

Yixian Liu (4):
      RDMA/hns: Refactor eq code for hip06
      RDMA/hns: Add eq support of hip08
      RDMA/hns: Add detailed comments for mb() call
      RDMA/hns: Fix QP state judgement before sending work requests

Yuval Shaia (3):
      RDMA/vmw_pvrdma: Do not re-calculate npages
      IB/ipoib: Replace printk with pr_warn
      IB/ipoib: Warn when one port fails to initialize

Zhu Yanjun (2):
      IB/rxe: add the static type to the variable
      IB/rxe: remove unnecessary skb_clone in xmit

oulijun (12):
      RDMA/hns: Add rq inline data support for hip08 RoCE
      RDMA/hns: Update the usage of sr_max and rr_max field
      RDMA/hns: Set access flags of hip08 RoCE
      RDMA/hns: Filter for zero length of sge in hip08 kernel mode
      RDMA/hns: Assign dest_qp when deregistering mr
      RDMA/hns: Assign the correct value for tx_cqn
      RDMA/hns: Create gsi qp in hip08
      RDMA/hns: Add gsi qp support for modifying qp in hip08
      RDMA/hns: Fill sq wqe context of ud type in hip08
      RDMA/hns: Assign zero for pkey_index of wc in hip08
      RDMA/hns: Update the verbs of polling for completion
      RDMA/hns: Set the guid for hip08 RoCE device

weiyongjun (A) (1):
      RDMA/hns: Remove unnecessary platform_get_resource() error check

 MAINTAINERS                                        |    7 +-
 drivers/infiniband/core/Makefile                   |    2 +-
 drivers/infiniband/core/addr.c                     |   65 +-
 drivers/infiniband/core/cache.c                    |   23 +-
 drivers/infiniband/core/cm.c                       |  227 ++-
 drivers/infiniband/core/cma.c                      |  252 ++-
 drivers/infiniband/core/cma_configfs.c             |    2 +-
 drivers/infiniband/core/core_priv.h                |   52 +-
 drivers/infiniband/core/cq.c                       |   39 +-
 drivers/infiniband/core/device.c                   |   42 +-
 drivers/infiniband/core/fmr_pool.c                 |   12 +-
 drivers/infiniband/core/iwpm_util.c                |    1 +
 drivers/infiniband/core/mad.c                      |    1 -
 drivers/infiniband/core/netlink.c                  |   10 +-
 drivers/infiniband/core/nldev.c                    |  394 ++++-
 drivers/infiniband/core/restrack.c                 |  164 ++
 drivers/infiniband/core/roce_gid_mgmt.c            |   13 +-
 drivers/infiniband/core/sa_query.c                 |   18 +-
 drivers/infiniband/core/security.c                 |   10 +-
 drivers/infiniband/core/sysfs.c                    |    1 -
 drivers/infiniband/core/ucm.c                      |   73 +-
 drivers/infiniband/core/ucma.c                     |   19 +-
 drivers/infiniband/core/umem.c                     |    2 +-
 drivers/infiniband/core/user_mad.c                 |  123 +-
 drivers/infiniband/core/uverbs_cmd.c               |   14 +-
 drivers/infiniband/core/uverbs_ioctl.c             |   19 +-
 drivers/infiniband/core/uverbs_main.c              |   95 +-
 drivers/infiniband/core/uverbs_std_types.c         |    3 +
 drivers/infiniband/core/verbs.c                    |  312 ++--
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   43 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |  145 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.h        |   39 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  404 ++++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   20 +
 drivers/infiniband/hw/bnxt_re/main.c               |  251 ++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  463 ++++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   78 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |    5 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |    7 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |    9 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  141 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   91 +-
 drivers/infiniband/hw/bnxt_re/roce_hsi.h           |  127 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   27 +-
 drivers/infiniband/hw/cxgb4/device.c               |   36 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |    2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |    6 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |    4 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   87 +-
 drivers/infiniband/hw/hfi1/chip.h                  |    2 +-
 drivers/infiniband/hw/hfi1/driver.c                |   16 -
 drivers/infiniband/hw/hfi1/firmware.c              |   64 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   25 +-
 drivers/infiniband/hw/hfi1/init.c                  |    2 +
 drivers/infiniband/hw/hfi1/mad.c                   |    6 +-
 drivers/infiniband/hw/hfi1/qp.c                    |   10 +-
 drivers/infiniband/hw/hfi1/rc.c                    |    8 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |    6 +-
 drivers/infiniband/hw/hns/Makefile                 |    2 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |    1 +
 drivers/infiniband/hw/hns/hns_roce_cmd.h           |   10 +
 drivers/infiniband/hw/hns/hns_roce_common.h        |   11 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   19 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  103 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c            |  759 --------
 drivers/infiniband/hw/hns/hns_roce_eq.h            |  134 --
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  758 +++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |   44 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 1837 ++++++++++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |  283 ++-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   16 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   72 +-
 drivers/infiniband/hw/i40iw/Kconfig                |    1 -
 drivers/infiniband/hw/i40iw/i40iw.h                |    3 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   68 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |    8 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           |   25 +-
 drivers/infiniband/hw/i40iw/i40iw_d.h              |    1 +
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |    3 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |   13 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |    5 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.h           |    1 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c             |   18 +-
 drivers/infiniband/hw/i40iw/i40iw_user.h           |    3 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |   50 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |    5 +-
 drivers/infiniband/hw/mlx4/cq.c                    |    4 +-
 drivers/infiniband/hw/mlx4/main.c                  |   19 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   20 +-
 drivers/infiniband/hw/mlx5/cong.c                  |   83 +-
 drivers/infiniband/hw/mlx5/cq.c                    |    2 +-
 drivers/infiniband/hw/mlx5/mad.c                   |   23 +-
 drivers/infiniband/hw/mlx5/main.c                  | 1411 +++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  111 +-
 drivers/infiniband/hw/mlx5/mr.c                    |    3 +
 drivers/infiniband/hw/mlx5/odp.c                   |    9 -
 drivers/infiniband/hw/mlx5/qp.c                    |  432 ++++-
 drivers/infiniband/hw/mthca/mthca_memfree.c        |    7 +-
 drivers/infiniband/hw/mthca/mthca_user.h           |  112 --
 drivers/infiniband/hw/nes/nes_cm.c                 |    2 +-
 drivers/infiniband/hw/nes/nes_cm.h                 |    3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   19 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |    8 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   10 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   15 +-
 drivers/infiniband/hw/qib/qib.h                    |    8 +-
 drivers/infiniband/hw/qib/qib_driver.c             |   16 -
 drivers/infiniband/hw/qib/qib_eeprom.c             |    3 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   68 +-
 drivers/infiniband/hw/qib/qib_init.c               |    2 +
 drivers/infiniband/hw/qib/qib_keys.c               |  235 ---
 drivers/infiniband/hw/qib/qib_rc.c                 |    6 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    2 -
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |    1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |    1 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |    4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |   13 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   21 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c       |   15 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   11 +-
 drivers/infiniband/sw/rdmavt/cq.c                  |   15 +-
 drivers/infiniband/sw/rdmavt/mcast.c               |    4 +-
 drivers/infiniband/sw/rdmavt/mr.c                  |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   27 +-
 drivers/infiniband/sw/rdmavt/srq.c                 |   16 +-
 drivers/infiniband/sw/rdmavt/trace.h               |    4 +-
 drivers/infiniband/sw/rdmavt/trace_qp.h            |   42 +
 drivers/infiniband/sw/rdmavt/vt.c                  |   10 +-
 drivers/infiniband/sw/rdmavt/vt.h                  |    6 +-
 drivers/infiniband/sw/rxe/Kconfig                  |    4 +-
 drivers/infiniband/sw/rxe/rxe.c                    |    6 -
 drivers/infiniband/sw/rxe/rxe.h                    |    6 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |    1 -
 drivers/infiniband/sw/rxe/rxe_net.c                |   18 +-
 drivers/infiniband/sw/rxe/rxe_net.h                |    1 -
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   12 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |    3 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |    9 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |    5 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |    2 +
 drivers/infiniband/sw/rxe/rxe_verbs.h              |    3 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   18 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   98 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    6 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   16 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    7 +
 drivers/infiniband/ulp/isert/ib_isert.h            |    1 +
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  795 +++++++--
 drivers/infiniband/ulp/srp/ib_srp.h                |   43 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  962 ++++++----
 drivers/infiniband/ulp/srpt/ib_srpt.h              |  100 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    9 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   10 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   55 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c  |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   15 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  125 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   91 +-
 include/linux/mlx5/device.h                        |   16 +
 include/linux/mlx5/driver.h                        |   43 +-
 include/linux/mlx5/mlx5_ifc.h                      |   32 +-
 include/linux/mlx5/qp.h                            |   12 +
 include/linux/mlx5/vport.h                         |    4 +
 include/rdma/ib_addr.h                             |   38 +-
 include/rdma/ib_sa.h                               |   10 +-
 include/rdma/ib_verbs.h                            |   64 +-
 include/rdma/opa_addr.h                            |   16 +
 include/rdma/rdma_cm.h                             |   19 +
 include/rdma/rdma_cm_ib.h                          |    8 +-
 include/rdma/rdma_vt.h                             |   31 +-
 include/rdma/restrack.h                            |  157 ++
 include/scsi/srp.h                                 |   17 +
 include/uapi/rdma/bnxt_re-abi.h                    |    9 +
 include/uapi/rdma/ib_user_verbs.h                  |   11 +-
 include/uapi/rdma/mlx4-abi.h                       |    7 +-
 include/uapi/rdma/mlx5-abi.h                       |   53 +-
 include/uapi/rdma/rdma_netlink.h                   |   49 +
 include/uapi/rdma/vmw_pvrdma-abi.h                 |   12 +-
 lib/kobject.c                                      |    2 +
 net/rds/ib.c                                       |    6 +-
 187 files changed, 10240 insertions(+), 4028 deletions(-)
 create mode 100644 drivers/infiniband/core/restrack.c
 delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.c
 delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.h
 delete mode 100644 drivers/infiniband/hw/mthca/mthca_user.h
 delete mode 100644 drivers/infiniband/hw/qib/qib_keys.c
 create mode 100644 include/rdma/restrack.h

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJacgEzAAoJEDht9xV+IJsaiHEP/j/+TzEwpQIlWufIcltS0isr
JGezyCZqykBmrR5OoKTTw7hIws/1A3U6P4o+L3dp2VAkTUcX/ww1I3K/w2G5g1sx
igeV5PIa0OifbfBVNrBHV6F4lOjZH25Q9rcVsIKGuh2zMj2vas/pX/dkEKYrGkD7
h1RZQepjs2HIkpSehR03J9s/rqJeYgen2vmJc2q5lQhzYME1d2RpXfDGYF7iftol
dBM9+lGggayyKj/5YhSeKPPGso6nraXgOYAakSRc2NhX60ynMwrVrhKvxBY4P/Hs
0XXE9beWbvRk1IAuAlhXHdRIIvUnUf5EehbtrPa1Vvg/dXh5u50u1HBdoWaFjbmA
AdYXvaNXUi4vmHwXk/rLqvJcuGK8AQEhecxgybelckQT4HXouhhonkwhYr+R9yqf
KN81oi+EQtapWVB+5hWDD1VIOI0ys32ny1ZtRbowcWMrsCRRUQoUrjpUar/KIJoq
ym2wMvUr403Q4cEoDFjps0dJoZBLL/tx266j+tqoQL7SUVwaaGt+mKUOenf8aTRx
abKXa5sRsM1cSbkVagGbSTiZ6X4Ls8IrLvQJrgkrMkFlBg/M6GRlFGij67+vZ8dq
zuT4jEAuf+djA7m6H04L+OvVxEOYxddLAHFL7szKGNim1wtZWAvNNv8eHP5mhErz
fJSqf9Utxg7GT+bpZflY
=BJox
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
