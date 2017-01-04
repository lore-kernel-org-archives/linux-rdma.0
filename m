From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 4 Jan 2017 15:36:56 +0200
Message-ID: <20170104133651.GA20424@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,
My r-b for pvrdma driver is missing.

Yuval

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JuIV5ull1I07UlGfLnhgIGQ5NEA3RtTnx
Content-Type: multipart/mixed; boundary="aQmhCdlFM5GvV4npNCBtkiJ1orSdhujCS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <ac96de9c-391b-70df-4c9d-d65d7dc28263-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--aQmhCdlFM5GvV4npNCBtkiJ1orSdhujCS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the complete update for the rdma stack for this release cycle.
Most of it is typical driver and core updates, but there is the entirely
new VMWare pvrdma driver.  You may have noticed that there were changes
in DaveM's pull request to the bnxt Ethernet driver to support a RoCE
RDMA driver.  The bnxt_re driver was tentatively set to be pulled in
this release cycle, but it simply wasn't ready in time and was dropped
(a few review comments still to address, and some multi-arch build
issues like prefetch() not working across all arches).

There are two merge conflict issues to be aware of.  Since I have not
merged my -rc pull request from 4.9 into my for-4.10 branch (which I can
do if you would prefer, I didn't do it because of your instructions
before about not liking to see otherwise needless merges), there is a
patch in my 4.9-rc pull request that changed rxe_requestor() and added a
direct return in one location.  A patch in this series then adds ref
counting to the qp in that function.  If you don't know this, you can
miss putting a ref put prior to the direct return when fixing up the
merge conflict.  Other than that, it's a straight forward merge conflict
issue that's easy to resolve.

There was a second merge conflict related to the changes to iterating
netdevs, and on that you simply keep your head and drop anything else.

Here's the boilerplate:

The following changes since commit e37a79e5d4cac3831fac3d4afbf2461f56b4b7=
bd:

  net/mlx5e: Add tc support for FWD rule with counter (2016-10-30
15:43:18 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 6f94ba20799b98c8badf047b184fb4cd7bc45e44:

  Merge branch 'vmw_pvrdma' into merge-test (2016-12-14 14:56:21 -0500)

----------------------------------------------------------------
Updates for 4.10 kernel merge window

- Shared mlx5 updates with net stack (will drop out on merge if Dave's
  tree has already been merged)
- Driver updates: cxgb4, hfi1, hns-roce, i40iw, mlx4, mlx5, qedr, rxe
- Debug cleanups
- New connection rejection helpers
- SRP updates
- Various misc fixes
- New paravirt driver from vmware

----------------------------------------------------------------
Adit Ranadive (2):
      vmxnet3: Move PCI Id to pci_ids.h
      IB: Add vmw_pvrdma driver

Alexey Khoroshilov (1):
      IB/isert: do not ignore errors in dma_map_single()

Amrani, Ram (1):
      qede: fix general protection fault may occur on probe

Andrew Boyer (10):
      IB/rxe: Remove buffer used for printing IP address
      IB/rxe: Advance the consumer pointer before posting the CQE
      IB/rxe: Don't update the response PSN unless it's going forwards
      IB/rxe: Unblock loopback by moving skb_out increment
      IB/rxe: Add support for zero-byte operations
      IB/rxe: Add support for IB_CQ_REPORT_MISSED_EVENTS
      IB/rxe: Fix ref leak in rxe_create_qp()
      IB/rxe: Fix ref leak in duplicate_request()
      IB/rxe: Wait for tasklets to finish before tearing down QP
      IB/rxe: Hold refs when running tasklets

Arnd Bergmann (3):
      IB/rxe: avoid putting a large struct rxe_qp on stack
      IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
      IB/mlx4: avoid a -Wmaybe-uninitialize warning

Bart Van Assche (14):
      IB/hfi1: Define platform_config_table_limits once
      IB/srpt: Report login failures only once
      IB/mlx4: Rework special QP creation error path
      IB/mad: Fix an array index check
      IPoIB: Avoid reading an uninitialized member variable
      IB/multicast: Check ib_find_pkey() return value
      IB/srp: Fix CONFIG_DYNAMIC_DEBUG=3Dn build
      IB/srp: Introduce a local variable in srp_add_one()
      IB/srp: Make login failures easier to debug
      IB/srp: Make mapping failures easier to debug
      IB/srp: Make writing the add_target sysfs attr interruptible
      mlx5: Use { } instead of { 0 } to init struct
      mlx5: Remove a set-but-not-used variable
      mlx5, calc_sq_size(): Make a debug message more informative

Bhumika Goyal (1):
      IB/hfi1: constify mmu_notifier_ops structure

Bodong Wang (7):
      IB/mlx5: Report mlx5 multi packet WQE caps during query
      IB/mlx5: Report mlx5 CQE compression caps during query
      IB/mlx5: Add support for CQE compressing
      IB/mlx5: Report mlx5 packet pacing capabilities when querying devic=
e
      IB/core: Support rate limit for packet pacing
      IB/uverbs: Extend modify_qp and support packet pacing
      IB/mlx5: Properly adjust rate limit on QP state transitions

Colin Ian King (1):
      qedr: return -EINVAL if pd is null and avoid null ptr dereference

Dan Carpenter (1):
      IB/rxe: Remove unneeded cast in rxe_srq_from_attr()

Dean Luick (5):
      IB/hfi1: Read new EPROM format
      IB/hfi1: Fix dc8051 multiple qword memory reads
      IB/hfi1: Export 8051 memory and LCB registers via debugfs
      IB/hfi1: Add special setting for low power AOC
      IB/hfi1: Preserve external device completed bit

Dennis Dalessandro (1):
      IB/rdmavt: Fix trace hierarchy

Don Hiatt (1):
      IB/hfi1: Remove dependence on qp->s_cur_size

Doug Ledford (5):
      Merge branches 'chelsio', 'debug-cleanup', 'hns' and 'i40iw' into
merge-test
      Merge branch 'hfi1' into merge-test
      Merge branch 'mlx' into merge-test
      Merge branches 'misc', 'qedr', 'reject-helpers', 'rxe' and 'srp'
into merge-test
      Merge branch 'vmw_pvrdma' into merge-test

Easwar Hariharan (1):
      IB/hfi1: Add active channel and backplane support for integrated
devices

Eli Cohen (3):
      IB/mlx5: Wait for all async command completions to complete
      IB/mlx5: Fix reported max SGE calculation
      IB/mlx5: Avoid system crash when enabling many VFs

Eran Ben Elisha (2):
      IB/mlx4: When no DMFS for IPoIB, don't allow NET_IF QPs
      IB/mlx4: Check if GRH is available before using it

Hal Rosenstock (1):
      IB/mad: Eliminate redundant SM class version defines for OPA

Hans Westgaard Ry (1):
      IB/core: Issue DREQ when receiving REQ/REP for stale QP

Harish Chegondi (1):
      IB/hfi1: Avoid credit return allocation for cpu-less NUMA nodes

Henry Orosco (22):
      i40iw: Add Quality of Service support
      i40iw: Enable message packing
      i40iw: Remove workaround for pre-production errata
      i40iw: Set MAX IRD, MAX ORD size to max supported value
      i40iw: Convert page_size to encoded value
      i40iw: Use vector when creating CQs
      i40iw: Correct values for max_recv_sge, max_send_sge
      i40iw: Fix for LAN handler removal
      i40iw: Optimize inline data copy
      i40iw: Query device accounts for internal rsrc
      i40iw: Remove checks for more than 48 bytes inline data
      i40iw: Remove NULL check for cm_node->iwdev
      i40iw: Use actual page size
      i40iw: Use runtime check for IS_ENABLED(CONFIG_IPV6)
      i40iw: Remove check on return from device_init_pestat()
      i40iw: Remove variable flush_code and check to set qp->sq_flush
      i40iw: Fix incorrect assignment of SQ head
      i40iw: Utilize physically mapped memory regions
      i40iw: Add 2MB page support
      i40iw: Code cleanup, remove check of PBLE pages
      i40iw: Add request for reset on CQP timeout
      i40iw: Reorganize structures to align with HW capabilities

Jack Morgenstein (2):
      IB/mlx4: Handle well-known-gid in mad_demux processing
      IB/mlx4: Fix out-of-range array index in destroy qp flow

Jakub Pawlak (2):
      IB/hfi1: Unify access to GUID entries
      IB/hfi1: Disable header suppression for short packets

Jason Gunthorpe (1):
      rdma UAPI: Use __kernel_sockaddr_storage

Jianxin Xiong (1):
      IB/hfi1: Show statistics counters under IB stats interface

Jim Foraker (1):
      IB/rdmavt: Only put mmap_info ref if it exists

Julia Lawall (1):
      IB/usnic: simplify IS_ERR_OR_NULL to IS_ERR

Kamal Heib (1):
      IB/IPoIB: Remove can't use GFP_NOIO warning

Leon Romanovsky (21):
      IB/mad: Remove debug prints after allocation failure
      IB/core: Remove debug prints after allocation failure
      IB/core: Release allocated memory in cache setup failure
      IB/mlx4: Remove debug prints after allocation failure
      IB/mlx5: Remove debug prints after allocation failure
      IB/hfi1: Remove debug prints after allocation failure
      IB/cxgb3: Remove debug prints after allocation failure
      IB/cxgb4: Remove debug prints after allocation failure
      IB/i40iw: Remove debug prints after allocation failure
      IB/qib: Remove debug prints after allocation failure
      IB/nes: Remove debug prints after allocation failure
      IB/mthca: Remove debug prints after allocation failure
      IB/usninc: Remove and fix debug prints after allocation failure
      IB/ocrdma: Remove and fix debug prints after allocation failure
      IB/rxe: Remove and fix debug prints after allocation failure
      IB/isert: Remove and fix debug prints after allocation failure
      IB/ipoib: Remove and fix debug prints after allocation failure
      infiniband: remove WARN that is not kernel bug
      IB/hns: Move HNS RoCE user vendor structures
      net/mlx5: Report multi packet WQE capabilities
      MAINTAINERS: Remove Mitesh Ahuja from emulex maintainers

Lijun Ou (5):
      IB/hns: Add the interface for querying QP1
      IB/hns: add self loopback for CM
      IB/hns: Modify the condition of notifying hardware loopback
      IB/hns: Fix the bug for qp state in hns_roce_v1_m_qp()
      IB/hns: Fix the IB device name

Majd Dibbiny (1):
      IB/mlx5: Limit mkey page size to 2GB

Maor Gottlieb (6):
      IB/mlx5: Fix atomic cap in indirect UMR
      IB/mlx5: Put non zero value in max_ah
      IB/mlx4: Set traffic class in AH
      IB/mlx4: Put non zero value in max_ah device attribute
      IB/mlx5: Assign SRQ type earlier
      IB/mlx5: Use u64 for UMR length

Mark Bloch (1):
      IB/core: Save QP in ib_flow structure

Max Gurtovoy (1):
      IB/mlx5: Replace numerical constant with predefined MACRO

Mike Marciniszyn (11):
      IB/hfi1: Add unique txwait_lock for txreq events
      IB/hfi1: Inline sdma_txclean() for verbs pio
      IB/hfi1: Optimize lkey validation structures
      IB/rdmvat: Organize hot path calldowns into a single cacheline
      IB/hfi1: Optimize pio cachelines
      IB/rdmavt: Add trace of MR segs
      IB/rdmavt: Add a send completion helper
      IB/hfi1,IB/qib: Use new send completion helper
      IB/rdmavt: Add swqe mr deref helper
      IB/hfi1,IB/qib: use rvt swqe mr deref helper
      IB/rdmavt, IB/hfi1, IB/qib: Add inlines for mtu division

Mitko Haralanov (1):
      IB/hfi1: Remove usage of qp->s_cur_sge

Moni Shoua (6):
      IB/mlx4: Handle IPv4 header when demultiplexing MAD
      IB/core: Change ib_resolve_eth_dmac to use it in create AH
      IB/mlx5: Report that device has udata response in create_ah
      IB/core: Let create_ah return extended response to user
      IB/mlx5: Use kernel driver to help userspace create ah
      IB/mlx5: Make create/destroy_ah available to userspace

Moses Reuben (6):
      IB/core: Add flow spec tunneling support
      IB/core: Align structure ib_flow_spec_type
      IB/uverbs: Add support for Vxlan protocol
      IB/mlx5: Support Vxlan tunneling specification
      IB/core: Introduce inner flow steering
      IB/mlx5: Add support to match inner packet fields

Mustafa Ismail (7):
      i40iw: Add missing cleanup on device close
      i40iw: Add IP addr handling on netdev events
      i40iw: Replace list_for_each_entry macro with safe version
      i40iw: Fix double free of QP
      i40iw: Fix memory leak in CQP destroy when in reset
      i40iw: Assign MSS only when it is a new MTU
      i40iw: Fix incorrect check for error

Or Gerlitz (3):
      IB/mlx5: Refactor registration to netdev notifier
      IB/mlx5: Rename RoCE related helpers to reflect being Eth ones
      IB/mlx5: Support RAW Ethernet when RoCE is disabled

Pan Bian (2):
      IB/ocrdma: fix bad initialization
      IB/mlx4: fix improper return value

Petr Mladek (2):
      IB/rdmavt: Avoid queuing work into a destroyed cq kthread worker
      IB/rdmavt: Handle the kthread worker using the new API

Philippe Reynes (1):
      IB/nes: use new api ethtool_{get|set}_link_ksettings

Saeed Mahameed (1):
      IB/mlx4: Fix port query for 56Gb Ethernet links

Salil (1):
      IB/hns: Fix for Checkpatch.pl comment style errors

Sebastian Ott (1):
      IB/core: fix unmap_sg argument

Sebastian Sanchez (8):
      IB/hfi1: Optimize devdata cachelines
      IB/hfi1: Get rid of divide in pio buffer allocator
      IB/hfi1: Optimize pio_buf and send_context structs
      IB/hfi1: Use non-atomic __test_and_clear_bit in hot path
      IB/hfi1: Remove critical section gap in sc_buffer_alloc()
      IB/hfi1: Replace qp->refcount release code with standard driver
wrapper
      IB/hfi1: Use reference count wrapper for MRs
      IB/qib: Use standard refcount wrapper for QPs

Shaobo Xu (3):
      IB/hns: Implement the add_gid/del_gid and optimize the GIDs managem=
ent
      IB/hns: Fix the bug when free mr
      IB/hns: Fix the bug when free cq

Shiraz Saleem (8):
      i40iw: Add NULL check for ibqp event handler
      i40iw: Set TOS field in IP header
      i40iw: Fill in IRD value when on connect request
      i40iw: Correctly fail loopback connection if no listener
      i40iw: Use correct src address in memcpy to rdma stats counters
      i40iw: Fix QP flush to not hang on empty queues or failure
      i40iw: Fix race condition in terminate timer's handler
      MAINTAINERS: Update Intel RDMA RNIC driver maintainers

Souptick Joarder (1):
      IB/mthca: Replace pci_pool_alloc by pci_pool_zalloc

Steve Wise (8):
      rdma_cm: add rdma_reject_msg() helper function
      rdma_cm: add rdma_is_consumer_reject() helper function
      rdma_cm: add rdma_consumer_reject_data helper function
      nvme-rdma: use rdma connection reject helper functions
      ib_iser: log the connection reject message
      rds_rdma: log the connection reject message
      ib_isert: log the connection reject message
      nvmet_rdma: log the connection reject message

Tadeusz Struk (1):
      IB/hfi1: Remove definition of unused hfi1_affinity struct

Thomas Huth (1):
      i40iw: Remove macros I40IW_STAG_KEY_FROM_STAG and
I40IW_STAG_INDEX_FROM_STAG

Wei Hu (Xavier) (8):
      IB/hns: Add code for refreshing CQ CI using TPTR
      IB/hns: Optimize the logic of allocating memory using APIs
      IB/hns: Modify the macro for the timeout when cmd process
      IB/hns: Modify query info named port_num when querying RC QP
      IB/hns: Change qpn allocation to round-robin mode.
      IB/hns: Fix the bug when destroy qp
      IB/hns: Fix the bug of setting port mtu
      IB/hns: Delete the redundant memset operation

Wei Yongjun (5):
      iw_cxgb4: Fix error return code in c4iw_rdev_open()
      IB/rxe: Use DEFINE_SPINLOCK() for spinlock
      qedr: Fix possible memory leak in qedr_create_qp()
      qedr: Use list_move_tail instead of list_del/list_add_tail
      qedr: remove pointless NULL check in qedr_post_send()

Yonatan Cohen (1):
      IB/rxe: Increase max number of completions to 32k

Zhouyi Zhou (1):
      infiniband: nes: return value of skb_linearize should be handled

 MAINTAINERS                                        |   13 +-
 drivers/infiniband/Kconfig                         |    1 +
 drivers/infiniband/core/agent.c                    |    1 -
 drivers/infiniband/core/cache.c                    |   16 +-
 drivers/infiniband/core/cm.c                       |   72 +-
 drivers/infiniband/core/cma.c                      |   43 +
 drivers/infiniband/core/core_priv.h                |    3 -
 drivers/infiniband/core/device.c                   |    5 +-
 drivers/infiniband/core/fmr_pool.c                 |    1 -
 drivers/infiniband/core/iwcm.c                     |   21 +
 drivers/infiniband/core/iwpm_msg.c                 |    1 -
 drivers/infiniband/core/iwpm_util.c                |   12 +-
 drivers/infiniband/core/mad.c                      |   46 +-
 drivers/infiniband/core/multicast.c                |    7 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |   21 +-
 drivers/infiniband/core/ucm.c                      |    5 +-
 drivers/infiniband/core/ucma.c                     |    5 +-
 drivers/infiniband/core/umem.c                     |    2 +-
 drivers/infiniband/core/uverbs.h                   |    1 +
 drivers/infiniband/core/uverbs_cmd.c               |  229 ++--
 drivers/infiniband/core/uverbs_main.c              |    6 +-
 drivers/infiniband/core/verbs.c                    |  108 +-
 drivers/infiniband/hw/Makefile                     |    1 +
 drivers/infiniband/hw/cxgb3/cxio_dbg.c             |   20 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    3 +-
 drivers/infiniband/hw/cxgb4/device.c               |    8 +-
 drivers/infiniband/hw/cxgb4/provider.c             |    4 +-
 drivers/infiniband/hw/hfi1/affinity.c              |    3 +-
 drivers/infiniband/hw/hfi1/affinity.h              |    9 +-
 drivers/infiniband/hw/hfi1/chip.c                  |    9 +-
 drivers/infiniband/hw/hfi1/chip_registers.h        |    3 +
 drivers/infiniband/hw/hfi1/debugfs.c               |  110 ++
 drivers/infiniband/hw/hfi1/driver.c                |    3 +-
 drivers/infiniband/hw/hfi1/eprom.c                 |  211 +++-
 drivers/infiniband/hw/hfi1/firmware.c              |  156 ++-
 drivers/infiniband/hw/hfi1/hfi.h                   |  144 ++-
 drivers/infiniband/hw/hfi1/iowait.h                |    8 +
 drivers/infiniband/hw/hfi1/mad.c                   |   31 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                |    2 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   40 +-
 drivers/infiniband/hw/hfi1/pio.h                   |   38 +-
 drivers/infiniband/hw/hfi1/pio_copy.c              |   22 +-
 drivers/infiniband/hw/hfi1/platform.c              |  193 +++-
 drivers/infiniband/hw/hfi1/platform.h              |  127 +-
 drivers/infiniband/hw/hfi1/qp.c                    |   11 +-
 drivers/infiniband/hw/hfi1/rc.c                    |   60 +-
 drivers/infiniband/hw/hfi1/ruc.c                   |   44 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   18 +-
 drivers/infiniband/hw/hfi1/sdma.h                  |   12 +-
 drivers/infiniband/hw/hfi1/uc.c                    |    4 +-
 drivers/infiniband/hw/hfi1/ud.c                    |    4 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   60 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |  209 +++-
 drivers/infiniband/hw/hfi1/verbs.h                 |   16 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.c           |   13 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h           |    1 +
 drivers/infiniband/hw/hns/hns_roce_ah.c            |    3 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   11 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |    8 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.h           |   12 +-
 drivers/infiniband/hw/hns/hns_roce_common.h        |   44 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   46 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   66 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |    6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         | 1222
+++++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |   74 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |  329 ++----
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   43 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |    5 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |    4 +-
 drivers/infiniband/hw/i40iw/i40iw.h                |   37 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |  377 ++++--
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |   11 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           |  646 +++++++----
 drivers/infiniband/hw/i40iw/i40iw_d.h              |   25 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |   61 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |  166 ++-
 drivers/infiniband/hw/i40iw/i40iw_osdep.h          |    8 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h              |   21 +-
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |    4 -
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |  271 +++--
 drivers/infiniband/hw/i40iw/i40iw_puda.h           |   20 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h           |   98 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c             |   40 +-
 drivers/infiniband/hw/i40iw/i40iw_user.h           |   14 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |  289 ++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  238 +++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.h          |    2 +
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c       |   33 +-
 drivers/infiniband/hw/mlx4/ah.c                    |   10 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |    4 +-
 drivers/infiniband/hw/mlx4/cm.c                    |    4 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   58 +-
 drivers/infiniband/hw/mlx4/main.c                  |   49 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |    5 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    3 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   13 +-
 drivers/infiniband/hw/mlx5/ah.c                    |   25 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   34 +-
 drivers/infiniband/hw/mlx5/main.c                  |  268 +++--
 drivers/infiniband/hw/mlx5/mem.c                   |    7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   12 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   71 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  131 ++-
 drivers/infiniband/hw/mlx5/srq.c                   |    6 +-
 drivers/infiniband/hw/mthca/mthca_av.c             |    6 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |    4 +-
 drivers/infiniband/hw/mthca/mthca_reset.c          |    4 -
 drivers/infiniband/hw/nes/nes.c                    |    1 -
 drivers/infiniband/hw/nes/nes_cm.c                 |    4 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    6 +-
 drivers/infiniband/hw/nes/nes_mgt.c                |   10 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   84 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |    7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |    3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h           |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |    7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |    4 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   27 +-
 drivers/infiniband/hw/qedr/verbs.h                 |    3 +-
 drivers/infiniband/hw/qib/qib_diag.c               |    6 +-
 drivers/infiniband/hw/qib/qib_driver.c             |    3 +-
 drivers/infiniband/hw/qib/qib_eeprom.c             |    6 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |    5 +-
 drivers/infiniband/hw/qib/qib_iba6120.c            |    8 +-
 drivers/infiniband/hw/qib/qib_iba7220.c            |    8 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   22 +-
 drivers/infiniband/hw/qib/qib_init.c               |   47 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |   44 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |   24 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   33 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |   22 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   16 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |    4 +-
 drivers/infiniband/hw/usnic/usnic_vnic.c           |   22 +-
 drivers/infiniband/hw/vmw_pvrdma/Kconfig           |    7 +
 drivers/infiniband/hw/vmw_pvrdma/Makefile          |    3 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |  474 ++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c      |  119 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |  425 +++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h  |  586 ++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c |  127 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     | 1211
+++++++++++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c     |  304 +++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c       |  334 ++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |  972 ++++++++++++++=
++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h     |  131 +++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |  579 ++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |  436 +++++++
 drivers/infiniband/sw/rdmavt/cq.c                  |   64 +-
 drivers/infiniband/sw/rdmavt/mcast.c               |    5 +-
 drivers/infiniband/sw/rdmavt/mr.c                  |   22 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   20 +-
 drivers/infiniband/sw/rdmavt/trace.h               |  141 +--
 drivers/infiniband/sw/rdmavt/trace_mr.h            |  112 ++
 drivers/infiniband/sw/rdmavt/trace_qp.h            |   96 ++
 drivers/infiniband/sw/rdmavt/trace_rvt.h           |   81 ++
 drivers/infiniband/sw/rdmavt/trace_tx.h            |  132 +++
 drivers/infiniband/sw/rxe/rxe_comp.c               |    9 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |    2 -
 drivers/infiniband/sw/rxe/rxe_mr.c                 |    3 +
 drivers/infiniband/sw/rxe/rxe_net.c                |    8 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |    2 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |    1 -
 drivers/infiniband/sw/rxe/rxe_recv.c               |   11 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   19 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |   25 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |    2 +-
 drivers/infiniband/sw/rxe/rxe_task.c               |   19 +
 drivers/infiniband/sw/rxe/rxe_task.h               |    1 +
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   21 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |    7 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    5 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   31 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   48 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   22 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    5 +-
 drivers/net/ethernet/qlogic/qede/qede_roce.c       |    4 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |    3 +-
 drivers/nvme/host/rdma.c                           |   42 +-
 drivers/nvme/target/rdma.c                         |    3 +
 include/linux/mlx5/mlx5_ifc.h                      |    2 +-
 include/linux/pci_ids.h                            |    1 +
 include/rdma/ib_cm.h                               |    6 +
 include/rdma/ib_mad.h                              |    2 +-
 include/rdma/ib_verbs.h                            |   70 +-
 include/rdma/iw_cm.h                               |    6 +
 include/rdma/opa_smi.h                             |    2 -
 include/rdma/rdma_cm.h                             |   25 +
 include/rdma/rdma_vt.h                             |   46 +-
 include/rdma/rdmavt_mr.h                           |   10 +-
 include/rdma/rdmavt_qp.h                           |   77 ++
 include/uapi/rdma/Kbuild                           |    2 +
 include/uapi/rdma/hfi/hfi1_user.h                  |    2 +-
 .../hns_roce_user.h =3D> include/uapi/rdma/hns-abi.h |    9 +-
 include/uapi/rdma/ib_user_verbs.h                  |   38 +
 include/uapi/rdma/mlx5-abi.h                       |   38 +-
 include/uapi/rdma/rdma_user_cm.h                   |   12 +-
 include/uapi/rdma/vmw_pvrdma-abi.h                 |  289 +++++
 net/rds/rdma_transport.c                           |    5 +-
 204 files changed, 12279 insertions(+), 2657 deletions(-)
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/Makefile
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_mr.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_qp.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_rvt.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_tx.h
 rename drivers/infiniband/hw/hns/hns_roce_user.h =3D>
include/uapi/rdma/hns-abi.h (94%)
 create mode 100644 include/uapi/rdma/vmw_pvrdma-abi.h

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--aQmhCdlFM5GvV4npNCBtkiJ1orSdhujCS--

--JuIV5ull1I07UlGfLnhgIGQ5NEA3RtTnx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUsmGAAoJELgmozMOVy/dpV0P/0v2MOlez8U2G5gVE7tUkRIW
aVKGaulH5rzvi82EesDTNxHFsFhKAMEuNIh2JfdBVvbZGicH2DzMWy+/qqGZqoOc
5jNJmF5dPBKbCuKqIWV2cPBGNubOxHW1GFqndrIVl63zisdmQCooe7u1eKlMKrg5
2ALzV4V7rNH0B1wCYHwbizTA4s7kmQ+AvQowB6Nbq6e8WfgKMZzubfvfARqR85BT
PDW98tShP5b7r676xsIIr4HgYSA6IZSonEkTvGXyEHup1yjl2al6zyiv+J8YztPf
GFUptlV7gqwcPv40xXauA2To2pAenrcc9si0USa70knDOWqyAk4RF/7Fyz/iVFz7
ZaAWgmWH+6uU3fgIcU3LYTeukK7ISjDn1CuIQfWarSXxRvM6P5o1So5en9To4Su6
2tJOm4pXYnTlMx655RUMdsQe92YXLXaDAp6Osy2eBCVugmpRy4Gi0dzxu73s3Zv3
kU8hL1jUTt2crUEn3D+7Wroz/3P3vmEzbmTC9uQlLwPXMwHvo6vhuuey/vgf/D9O
yyuwvv0W9LeDLfyQCtlGd+jZbxf++XVZfrOsnFEBYJtvLi87HGz+EKCo5ly988Vu
+UiufZLhxH7iLrw3APIv1xqGVxMoYQeCr5gnlsP+a1eslw/T+ZBSW0iN9aMFMMQK
Iuam1hsXWGQ58gU2/GJy
=5OVt
-----END PGP SIGNATURE-----

--JuIV5ull1I07UlGfLnhgIGQ5NEA3RtTnx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
