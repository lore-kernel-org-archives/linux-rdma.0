From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 31 Aug 2017 09:42:36 -0400
Message-ID: <1504186956.109926.22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

I'm already on PTO, and will be on PTO throughout the merge window
(I'll try to pop in here or there, but we close on our new house today
and will be moving over the next few weeks), so I'm sending this now to
make sure it is in your hands in plenty of time.

This is a big pull request.  There are a few things that trickled into
the list that I couldn't get to before going on PTO.  I will try and
have some of those sorted before -rc1 (right now there are 10 patches
that need to be handled, a series of 2 and a series of 8).

Of note is that I'm sending you the new ioctl API for the rdma
subsystem.  We put it up on linux-api@, but didn't get much response. 
The API is complex, but it solves two different problems in one go:

1) The bi-directional nature of the RDMA file write calls, which
created the security hole we had to handle (and for which the fix is
now causing problems for systems in production, we were a bit over
zealous in the fix and the ability to open a device, then fork, then
create new queue pairs on the device and use them is broken).

2) The bloat caused by different vendors implementing extensions to the
base verbs API.  Each vendor's hardware is slightly different, and the
hardware might be suitable for one extension but not another.  By the
time we add generic extensions for all the different ways that the
different hardware can offload things, the API becomes bloated.  Things
like our completion structs have started to exceed a cache line in size
because of all the elements needed to support this.  That in turn shows
up heavily in the performance graphs with a noticable drop in
performance on 100Gigabit links as our completion structs go from
occupying one cache line to 1+.  This API makes things like the
completion structs modular in a very similar way to netlink so that
your structs can only include the items needed for the
offloads/features you are actually using on a given queue pair.  In
that way we support everything, but only use what we need, and our
structs stay smaller.

The ioctl API is better explained by the posting on linux-api@ than I
can explain it here, so I'll just leave it at that.

The rest of the pull request is typical stuff.  This tree is *not*
based on net-next, and in general I won't be submitting trees based on
net-next any more.

Finally, I'm giving you two different pull request URLs here.  The only
difference between the two is one is the base pull request plus the
ioctl interface, and the other is just the base pull request (in case
you want to skip the ioctl interface).  The boilerplate I'm including
will be for the ioctl interface included pull request, and in addition
there are a number of patches that the boilerplate pulls up that will
drop out (I had split my for-next area off at v4.13-rc2, but during the
development window, I merged in my -rc pull requests so that we would
be developing/testing on the fixed code and not code that still had
bugs we eliminated in the -rc cycles, all of those -rc patches sent to
you post v4.13-rc2 will drop out of this pull request and not show up
in the final diffstat when you try to pull this).

With the ioctl interface:

git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus-ioctl

*or* without the ioctl interface:

git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

The boilerplate:

The following changes since commit 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9:

  Linux 4.13-rc2 (2017-07-23 16:15:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus-ioctl

for you to fetch changes up to 8eb19e8e7c8658226d8b7e75728e6dfa2ef32717:

  IB/core: Expose ioctl interface through experimental Kconfig (2017-08-31 08:35:14 -0400)

----------------------------------------------------------------
Updates for 4.14 kernel merge window

- Lots of hfi1 driver updates (mixed with a few qib and core updates as
  well)
- rxe updates
- various mlx updates
- Set default roce type to RoCEv2
- Several larger fixes for bnxt_re that were too big for -rc
- Several larger fixes for qedr that, likewise, were too big for -rc
- Misc core changes
- Make the hns_roce driver compilable on arches other than aarch64 so we
  can more easily debug build issues related to it
- Add rdma-netlink infrastructure updates
- Add automatic IRQ affinity infrastructure
- Add 32bit lid support
- Lots of misc fixes across the subsystem from random people
- Autoloading of RDMA netlink modules
- PCI pool cleanups from Romain Perier
- mlx5 driver feature additions and fixes
- Hardware tag matchine feature
- Fix sleeping in atomic when resolving roce ah
- Add experimental ioctl interface as posted to linux-api@

----------------------------------------------------------------
Adit Ranadive (2):
      RDMA/vmw_pvrdma: Update device query parameters and port caps
      RDMA/vmw_pvrdma: Fix a signedness

Aditya Sarwade (1):
      RDMA/vmw_pvrdma: Report network header type in WC

Alex Estrin (3):
      IB/hfi1: Verify port data VLs credits on transition to Armed
      IB/hfi1: Harden state transition to Armed and Active
      IB/hfi1: Revert egress pkey check enforcement

Alex Vesker (2):
      IB/ipoib: Prevent setting negative values to max_nonsrq_conn_qp
      IB/ipoib: Add multicast packets statistics

Amrani, Ram (3):
      RDMA/qedr: notify user application if DPM is supported
      RDMA/qedr: notify user application of supported WIDs
      IB/core: Fix input len in multiple user verbs

Andrew Boyer (11):
      IB/rxe: Move refcounting earlier in rxe_send()
      IB/rxe: Disable completion upcalls when a CQ is destroyed
      IB/rxe: Remove dangling prototype
      IB/rxe: Fix up the responder's find_resources() function
      IB/rxe: Fix destination cache for IPv6
      IB/rxe: Add dst_clone() in prepare_ipv6_hdr()
      IB/rxe: Fix up rxe_qp_cleanup()
      IB/rxe: Remove unneeded initialization in prepare6()
      IB/rxe: Another fix for broken receive queue draining
      IB/rxe: Avoid ICRC errors by copying into the skb first
      IB/rxe: Handle NETDEV_CHANGE events

Arnd Bergmann (2):
      IB/hns: include linux/interrupt.h
      infiniband: avoid overflow warning

Artemy Kovalyov (11):
      net/mlx5: Update HW layout definitions
      IB/core: Add XRQ capabilities
      IB/core: Separate CQ handle in SRQ context
      IB/core: Add new SRQ type IB_SRQT_TM
      IB/uverbs: Add XRQ creation parameter to UAPI
      IB/uverbs: Add new SRQ type IB_SRQT_TM
      IB/uverbs: Expose XRQ capabilities
      IB/mlx5: Fill XRQ capabilities
      net/mlx5: Add XRQ support
      IB/mlx5: Support IB_SRQT_TM
      Documentation: Hardware tag matching

Arvind Yadav (4):
      infiniband: mthca: constify pci_device_id.
      infiniband: nes: constify pci_device_id.
      infiniband: pvrdma: constify pci_device_id.
      IB/hfi1: constify vm_operations_struct

Bartlomiej Dudek (4):
      IB/hfi1: Fix DC 8051 host info flag array
      IB/hfi1: Check return values from PCI config API calls
      IB/hfi1: Move saving PCI values to a separate function
      IB/hfi1: Use host_link_state to read state when DC is shut down

Bharat Potnuri (2):
      RDMA/uverbs: Initialize cq_context appropriately
      RDMA/uverbs: Initialize cq_context appropriately

Bhumika Goyal (3):
      IB/qib: add const to bin_attribute structures
      IB/hfi1: add const to bin_attribute structures
      i40iw: make some structures const

Bodong Wang (3):
      IB/mlx5: Restore IB guid/policy for virtual functions
      IB/mlx5: Allow posting multi packet send WQEs if hardware supports
      IB/mlx5: Report mlx5 enhanced multi packet WQE capability

Bryan Tan (2):
      RDMA/vmw_pvrdma: Report CQ missed events
      RDMA/vmw_pvrdma: Add RoCEv2 support

Byczkowski, Jakub (3):
      IB/hfi1: Modify handling of physical link state by Host Driver
      IB/hfi1: Fix initialization failure for debug firmware
      IB/hfi1: Remove lstate from hfi1_pportdata

Chien Tin Tung (1):
      i40iw: Fix parsing of query/commit FPM buffers

Christophe Jaillet (2):
      cxgb4: Remove some dead code
      i40iw: Simplify code

Christopher N Bednarz (2):
      i40iw: Use correct alignment for CQ0 memory
      i40iw: Fix potential fcn_id_array out of bounds

Colin Ian King (8):
      net/mlx5: fix spelling mistake: "alloated" -> "allocated"
      IB/hns: fix memory leak on ah on error return path
      IB/qib: fix spelling mistake: "failng" -> "failing"
      IB/hfi1: fix spelling mistake in variable name continious
      RDMA/bnxt_re: fix spelling mistake: "Deallocte" -> "Deallocate"
      i40iw: fix spelling mistake: "allloc_buf" -> "alloc_buf"
      IB/hfi1: fix spelling mistake: "Maximim" -> "Maximum"
      RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"

Dan Carpenter (2):
      IB/hns: checking for IS_ERR() instead of NULL
      IB/usnic: check for allocation failure

Dasaratharaman Chandramouli (10):
      IB/core: Convert ah_attr from OPA to IB when copying to user
      IB/srpt: Increase lid and sm_lid to 32 bits
      IB/IPoIB: Increase local_lid to 32 bits
      IB/mad: Change slid in RMPP recv from 16 to 32 bits
      IB/core: Change port_attr.lid size from 16 to 32 bits
      IB/core: Change port_attr.sm_lid from 16 to 32 bits
      IB/CM: Create appropriate path records when handling CM request
      IB/CM: Set appropriate slid and dlid when handling CM request
      IB/rdmavt, hfi1, qib: Enhance rdmavt and hfi1 to use 32 bit lids
      IB/hfi1: Enable RDMA_CAP_OPA_AH in hfi driver to support extended LIDs

Dennis Dalessandro (7):
      IB/rdmavt: Remove duplicated functions
      IB/hfi1: Ensure dd->gi_mask can not be overflowed
      IB/hfi1: Fix spelling mistake in linkdown reason
      IB/hfi1: Use QPN mask to avoid overflow
      IB/hfi1: Remove subtraction of uninitialized value
      IB/hfi1,qib: Do not send QKey trap for UD qps
      IB/hfi1: Document phys port state bits not used in IB

Don Hiatt (12):
      IB/hfi1: Add functions to parse BTH/IB headers
      IB/hfi1: Separate input/output header tracing
      IB/hfi1: Setup common IB fields in hfi1_packet struct
      IB/rdmavt, hfi1, qib: Modify check_ah() to account for extended LIDs
      IB/hfi1: Add support to receive 16B bypass packets
      IB/hfi1: Add support to send 16B bypass packets
      IB/hfi1: Add support to process 16B header errors
      IB/hfi1: Determine 9B/16B L2 header type based on Address handle
      IB/hfi1: Add 16B UD support
      IB/hfi1: Add 16B trace support
      IB/hfi1: Add 16B RC/UC support
      IB/hfi1: Enhance PIO/SDMA send for 16B

Doug Ledford (15):
      Merge branch 'k.o/for-4.12-rc' into k.o/for-4.13-mlx-shared
      Merge branch 'hfi1' into k.o/for-4.14
      Merge branches 'rxe' and 'mlx' into k.o/for-next
      Merge branch 'misc' into k.o/for-next
      IB/cma: Fix default RoCE type setting
      RDMA/hns: fix build regression
      Merge tag 'rdma-rc-2017-07-26' of git://git.kernel.org/.../leon/linux-rdma into leon-ipoib
      Merge tag 'rdma-next-2017-08-10' of git://git.kernel.org/.../leon/linux-rdma into rdma-netlink
      Merge branches '32bit_lid' and 'irq_affinity' into k.o/merge-test
      Merge branch 'rdma-netlink' into k.o/merge-test
      Revert "RDMA/hns: fix build regression"
      Merge branch 'misc' into k.o/for-next
      Merge branch 'k.o/for-4.13-rc' into k.o/for-next
      Merge branch 'k.o/for-4.13-rc' into k.o/for-next
      Merge branch 'mellanox' into k.o/for-next

Erez Shitrit (4):
      IB/ipoib: Use cancel_delayed_work_sync when needed
      IB/ipoib: Make sure no in-flight joins while leaving that mcast
      IB/ipoib: Notify on modify QP failure only when relevant
      IB/ipoib: Sync between remove_one to sysfs calls that use rtnl_lock

Feras Daoud (4):
      IB/ipoib: Fix race between light events and interface restart
      IB/ipoib: Set IPOIB_NEIGH_TBL_FLUSH after flushed completion initialization
      IB/ipoib: Add get statistics support to SRIOV VF
      IB/ipoib: Enable ioctl for to IPoIB rdma netdevs

Greg Kroah-Hartman (1):
      PCI/IB: add support for pci driver attribute groups

Grzegorz Morys (2):
      IB/hfi1: Remove HFI1_VERBS_31BIT_PSN option
      IB/hfi1: Ratelimit prints from sdma_interrupt

Gustavo A. R. Silva (1):
      IB/qib: remove duplicate code

Guy Levi (8):
      IB/mlx4: Add support for WQ related verbs
      IB/mlx4: Add support for WQ indirection table related verbs
      IB/mlx4: Add support for RSS QP
      IB/mlx4: Expose RSS capabilities
      IB/mlx4: Fix RSS QP type in creation verb
      IB/mlx4: Fix struct mlx4_ib_create_wq alignment
      IB/mlx4: Remove redundant attribute in mlx4_ib_create_qp_rss struct
      IB/mlx4: Check that reserved fields in mlx4_ib_create_qp_rss are zero

Harish Chegondi (7):
      IB/hfi1: Clean up hfi1_user_exp_rcv_setup function
      IB/hfi1: Clean up user_sdma_send_pkts() function
      IB/hfi1: Clean up pin_vector_pages() function
      IB/hfi1: Fix the bail out code in pin_vector_pages() function
      IB/hfi1: Remove duplicate definitions of num_user_pages() function
      IB/hfi1: Move structure definitions from user_exp_rcv.c to user_exp_rcv.h
      IB/hfi1: Move structure and MACRO definitions in user_sdma.c to user_sdma.h

Hiatt, Don (3):
      IB/core: Change wc.slid from 16 to 32 bits
      IB/CM: Add OPA Path record support to CM
      Add OPA extended LID support

Himanshu Jha (1):
      RDMA/bnxt_re: remove unnecessary call to memset

Huy Nguyen (3):
      net/mlx5: Add raw ethernet local loopback firmware command
      IB/mlx5: Add raw ethernet local loopback support
      net/mlx5e: Enable local loopback in loopback selftest

Ilya Lesokhin (3):
      IB/mlx5: Enable UMR for MRs created with reg_create
      IB/mlx5: Decouple MR allocation and population flows
      IB/mlx5: Fix integer overflow when page_shift == 31

Ira Weiny (2):
      IB/hfi1: Remove unused mk_qpn function
      IB/hfi1: Fix up sdma_init function comment

Ismail, Mustafa (1):
      RDMA/core: Add wait/retry version of ibnl_unicast

Jakub Byczkowski (3):
      IB/hfi1: Add flag for platform config scratch register read
      IB/hfi1: Load fallback platform configuration per HFI device
      IB/hfi1: Remove pstate from hfi1_pportdata

Jan Sokolowski (7):
      IB/hfi1: Set proper logging levels on QSFP cable error events
      IB/hfi1: Remove reading platform configuration from EFI variable
      IB/hfi1: Handle missing magic values in config file
      IB/hfi1: Fix code consistency for if/else blocks in chip.c
      IB/hfi1: Do not enable disabled port on cable insert
      IB/hfi1: Disambiguate corruption and uninitialized error cases
      IB/hfi1: Acquire QSFP cable information on loopback

Jason Gunthorpe (2):
      rdma: Allow demand loading of NETLINK_RDMA
      rdma: Autoload netlink client modules

Kaike Wan (5):
      IB/hfi1: Add receiving queue info to qp_stats
      IB/hfi1: Serve the most starved iowait entry first
      IB/hfi1: Add kernel receive context info to debugfs
      IB/hfi1: Add received request info to qp_stats
      IB/hfi1: Use accessor to determine ring size

Kalesh AP (1):
      RDMA/bnxt_re: Add vlan tag for untagged RoCE traffic when PFC is configured

Kamal Heib (7):
      IB/rxe: Use "foo *bar" instead of "foo * bar"
      IB/rxe: Prefer 'unsigned int' to bare use of 'unsigned'
      IB/rxe: Use DEVICE_ATTR_RO macro to show parent field
      IB/rxe: Use __func__ to print function's name
      IB/rxe: Constify static rxe_vm_ops
      IB/rxe: Make rxe_counter_name static
      IB/mlx5: Fix memory leak in clean_mr error path

Kamenee Arumugam (4):
      IB/qib: Remove unnecessary memory allocation for boardname
      IB/qib: Stricter bounds checking for copy and array access
      IB/hfi1: Fix whitespace alignment issue for MAD
      IB/qib: Stricter bounds checking for copy to buffer

Kamenee Arumugame (1):
      IB/hfi1: Stricter bounds checking of MAD trap index

Leon Romanovsky (52):
      IB/ipoib: Clean error paths in add port
      IB/ipoib: Remove double pointer assigning
      Revert "IB/core: Allow QP state transition from reset to error"
      RDMA/bnxt_re: Delete unsupported modify_port function
      RDMA: Remove useless MODULE_VERSION
      IB/mlx5: Fix existence check for extended address vector
      RDMA/uverbs: Prevent leak of reserved field
      RDMA/mlx5: Fix existence check for extended address vector
      RDMA/netlink: Remove netlink clients infrastructure
      RDMA/netlink: Remove redundant owner option for netlink callbacks
      RDMA/netlink: Avoid double pass for RDMA netlink messages
      RDMA/iwcm: Remove useless check of netlink client validity
      RDMA/iwcm: Remove extra EXPORT_SYMBOLS
      RDMA/netlink: Add flag to consolidate common handling
      RDMA/netlink: Simplify the put_msg and put_attr
      RDMA/netlink: Rename and remove redundant parameter from ibnl_unicast*
      RDMA/netlink: Rename and remove redundant parameter from ibnl_multicast
      RDMA/netlink: Simplify and rename ibnl_chk_listeners
      RDMA/netlink: Rename netlink callback struct
      RDMA/core: Add iterator over ib_devices
      RDMA/core: Add and expose static device index
      RDMA/netlink: Add and implement doit netlink callback
      RDMA/netlink: Reduce indirection access to cb_table
      RDMA/netlink: Convert LS to doit callback
      RDMA/netlink: Update copyright
      RDMA/netlink: Add netlink device definitions to UAPI
      RDMA/netlink: Add nldev initialization flows
      RDMA/netlink: Implement nldev device dumpit calback
      RDMA/netlink: Add nldev device doit implementation
      RDMA/netlink: Add nldev port dumpit implementation
      RDMA/netlink: Implement nldev port doit callback
      RDMA/netlink: Expose device and port capability masks
      RDMA: Simplify get firmware interface
      RDMA/netlink: Export FW version
      RDMA/netlink: Export node_guid and sys_image_guid
      RDMA/netlink: Advertise IB subnet prefix
      RDMA/netink: Export lids and sm_lids
      RDMA/netlink: Export LID mask control (LMC)
      RDMA/netlink: Provide port state and physical link state
      RDMA/netlink: Export node_type
      IB/cma: Fix erroneous validation of supported default GID type
      RDMA/mlx4: Don't use uninitialized variable
      RDMA/(core, ulp): Convert register/unregister event handler to be void
      RDMA/core: Cleanup device capability enum
      RDMA/core: Delete BUG() from unreachable flow
      RDMA/core: Refactor get link layer wrapper
      RDMA/mlx4: Remove gfp_mask argument from acquire_group call
      RDMA/usnic: Fix remove address space warning
      RDMA/mthca: Make explicit conversion to 64bit value
      RDMA/mlx5: Limit scope of get vector affinity local function
      RDMA/mlx4: Properly annotate link layer variable
      RDMA/nes: Remove zeroed parameter from port query callback

Li Dongyang (2):
      IB/mlx5: use kvmalloc_array for mlx5_ib_wq
      IB/mlx4: use kvmalloc_array to allocate wrid

Majd Dibbiny (3):
      IB/mlx5: Fix cached MR allocation flow
      IB/mlx5: Fix Raw Packet QP event handler assignment
      IB/mlx5: Always return success for RoCE modify port

Maor Gottlieb (9):
      IB/core: Introduce delay drop for a WQ
      net/mlx5: Introduce set delay drop command
      net/mlx5: Introduce general notification event
      IB/mlx5: Add support to dropless RQ
      IB/mlx5: Add delay drop configuration and statistics
      IB/mlx4: Add inline-receive support
      IB/uverbs: Fix NULL pointer dereference during device removal
      RDMA/mlx4: Fix create qp command alignment
      IB/mlx5: Add necessary delay drop assignment

Matan Barak (15):
      IB/hns: Support compile test for hns RoCE driver
      IB/hns: Avoid compile test under non 64bit environments
      IB/core: Add a generic way to execute an operation on a uobject
      IB/core: Add support to finalize objects in one transaction
      IB/core: Add new ioctl interface
      IB/core: Declare an object instead of declaring only type attributes
      IB/core: Add DEVICE object and root tree structure
      IB/core: Add uverbs merge trees functionality
      IB/core: Add macros for declaring methods and attributes
      IB/core: Explicitly destroy an object while keeping uobject
      IB/core: Export ioctl enum types to user-space
      IB/core: Add legacy driver's user-data
      IB/core: Add completion queue (cq) object actions
      IB/core: Assign root to all drivers
      IB/core: Expose ioctl interface through experimental Kconfig

Michael J. Ruhl (17):
      IB/hfi1: Name function prototype parameters for affinity module
      IB/hfi1: Replace deprecated pci functions with new API
      IB/qib: Replace deprecated pci functions with new API
      IB/hfi1: Initialize TID lists to avoid crash on cleanup
      IB/hfi1: Resolve kernel panics by reference counting receive contexts
      IB/hfi1: Assign context does not clean up file descriptor correctly on error
      IB/hfi1: Remove unused user context data members
      IB/hfi1: Size rcd array index correctly and consistently
      IB/hfi1: Use context pointer rather than context index
      IB/hfi1: Pass the context pointer rather than the index
      IB/hfi1: Send MAD traps until repressed
      IB/hfi1: Split copy_to_user data copy for better security
      IB/hfi1: Only set fd pointer when base context is completely initialized
      IB/hfi1: Protect context array set/clear with spinlock
      IB/hf1: User context locking is inconsistent
      IB/hfi1: Improve local kmem_cache_alloc performance
      IB/hif1: Remove static tracing from SDMA hot path

Mike Marciniszyn (14):
      IB/rdmavt: Compress adjacent SGEs in rvt_lkey_ok()
      IB/hfi1: Create common expected receive verbs/PSM code
      IB/hfi1: Use a template for tid reg/unreg
      IB/hfi1: Add traces for TID operations
      IB/hfi1: Fix bar0 mapping to use write combining
      IB/{rdmavt, hfi1, qib}: Fix panic with post receive and SGE compression
      IB/rdmavt: Use rvt_put_swqe() in rvt_clear_mr_ref()
      IB/{qib, hfi1}: Avoid flow control testing for RDMA write operation
      IB/hfi1: Add opcode states to qp_stats
      IB/rdmavt: Add QP iterator API for QPs
      IB/hfi1: Convert hfi1_error_port_qps() to use new QP iterator
      IB/hfi1: Convert qp_stats debugfs interface to use new iterator API
      IB/qib: Convert qp_stats debugfs interface to use new iterator API
      IB/rdmavt: Handle dereg of inuse MRs properly

Moni Shoua (2):
      IB/cma: Set default gid type to RoCEv2
      IB/mlx5: Change logic for dispatching IB events for port state

Moshe Shemesh (1):
      (IB, net)/mlx4: Add resource utilization support

Mustafa Ismail (2):
      i40iw: Correct variable names
      i40iw: Fix typecast of tcp_seq_num

Neel Desai (1):
      IB/hfi1: Add error checking for buffer overrun in OPA aggregate

Noa Osherovich (5):
      IB/core: Fix the validations of a multicast LID in attach or detach operations
      IB/core: Set RoCEv2 MGID according to spec
      IB/core: Add support for RoCEv2 multicast
      IB/core: Avoid accessing non-allocated memory when inferring port type
      IB/mlx5: Expose software parsing for Raw Ethernet QP

Parav Pandit (4):
      IB/mlx5: Add debug control parameters for congestion control
      IB/mlx5: Expose extended error counters
      IB/core: Fix race condition in resolving IP to MAC
      IB/uverbs: Introduce and use helper functions to copy ah attributes

Roland Dreier (2):
      IB/cm: Fix sleeping in atomic when RoCE is used
      IB/core: Add might_sleep() annotation to ib_init_ah_from_wc()

Romain Perier (3):
      IB/mthca: Replace PCI pool old API
      mlx4: Replace PCI pool old API
      mlx5: Replace PCI pool old API

Sagi Grimberg (12):
      mlx5: convert to generic pci_alloc_irq_vectors
      mlx5e: don't assume anything on the irq affinity mappings of the device
      mlx5: move affinity hints assignments to generic code
      RDMA/core: expose affinity mappings per completion vector
      mlx5: support ->get_vector_affinity
      block: Add rdma affinity based queue mapping helper
      nvme-rdma: use intelligent affinity based queue mappings
      RDMA/core: make ib_device.add method optional
      nvme-rdma: remove redundant empty device add callout
      nvmet-rdma: remove redundant empty device add callout
      cm: Don't allocate ib_cm workqueue with WQ_MEM_RECLAIM
      iwcm: Don't allocate iwcm workqueue with WQ_MEM_RECLAIM

Sebastian Sanchez (11):
      IB/hfi1: Remove unnecessary initialization from tx request
      IB/hfi1: Don't remove RB entry when not needed.
      IB/hfi1: Optimize cachelines for user SDMA request structure
      IB/hfi1: Remove atomic SDMA_REQ_SEND_DONE bit operation
      IB/hfi1: Remove atomic SDMA_REQ_HAS_ERROR bit operation
      IB/hfi1: Reclassify type of messages printed for platform config logic
      IB/hfi1: Create workqueue for link events
      IB/hfi1: Prevent link down request double queuing
      IB/hfi1: Always perform offline transition
      IB/hfi1: Remove pmtu from the QP structure
      IB/hfi1: Check xchg returned value for queuing link down entry

Selvin Xavier (4):
      RDMA/bnxt_re: Allow posting when QPs are in error
      RDMA/bnxt_re: Allocate multiple notification queues
      RDMA: Fix return value check for ib_get_eth_speed()
      IB: Avoid ib_modify_port() failure for RoCE devices

Shiraz Saleem (3):
      IB/core: Protect sysfs entry on ib_unregister_device
      i40iw: Fixes for static checker warnings
      i40iw: Improve CQP timeout logic

Somnath Kotur (1):
      RDMA/bnxt_re: Implement the alloc/get_hw_stats callback

Steve Wise (1):
      iw_cxgb4: fix misuse of integer variable

Tadeusz Struk (1):
      IB/core: Allow QP state transition from reset to error

Talat Batheesh (2):
      IB/mlx4: Fix some spelling mistakes
      IB/mlx5: Fix some spelling mistakes

Vishwanathapura, Niranjana (1):
      IB/core,rdmavt,hfi1,opa-vnic: Send OPA cap_mask3 in trap

Yishai Hadas (8):
      IB/core: Enable QP creation with a given source QP number
      IB/uverbs: Enable QP creation with a given source QP number
      IB/mlx5: Add support for QP with a given source QPN
      IB/mlx5: Add multicast flow steering support for underlay QP
      net/mlx5: Report enhanced capabilities for IPoIB
      IB/mlx5: Report RX checksum capabilities for IPoIB
      IB/uverbs: Fix device cleanup
      IB/mlx5: Add support for multi underlay QP

Yuval Shaia (6):
      IB/usnic: Implement get_netdev hook
      IB/core: Add generic function to extract IB speed from netdev
      IB/rxe: Convert pr_info to pr_warn
      IB/rxe: Remove unneeded check
      IB/pvrdma: Remove unused function
      RDMA/i40iw: Remove unused argument

kbuild test robot (3):
      IB/hns: fix boolreturn.cocci warnings
      IB/hns: fix returnvar.cocci warnings
      IB/hns: fix semicolon.cocci warnings

 Documentation/infiniband/tag_matching.txt          |   64 ++
 block/Kconfig                                      |    5 +
 block/Makefile                                     |    1 +
 block/blk-mq-rdma.c                                |   52 +
 drivers/infiniband/Kconfig                         |    9 +
 drivers/infiniband/core/Makefile                   |    6 +-
 drivers/infiniband/core/addr.c                     |   74 +-
 drivers/infiniband/core/cache.c                    |   23 +-
 drivers/infiniband/core/cm.c                       |  224 ++++-
 drivers/infiniband/core/cma.c                      |   35 +-
 drivers/infiniband/core/core_priv.h                |   27 +-
 drivers/infiniband/core/device.c                   |  149 ++-
 drivers/infiniband/core/iwcm.c                     |   16 +-
 drivers/infiniband/core/iwpm_msg.c                 |   20 +-
 drivers/infiniband/core/iwpm_util.c                |   15 +-
 drivers/infiniband/core/mad_rmpp.c                 |    2 +-
 drivers/infiniband/core/netlink.c                  |  321 +++---
 drivers/infiniband/core/nldev.c                    |  325 ++++++
 drivers/infiniband/core/rdma_core.c                |  179 ++++
 drivers/infiniband/core/rdma_core.h                |   42 +
 drivers/infiniband/core/roce_gid_mgmt.c            |    2 +
 drivers/infiniband/core/sa_query.c                 |   42 +-
 drivers/infiniband/core/sysfs.c                    |    4 +-
 drivers/infiniband/core/ucm.c                      |    2 +-
 drivers/infiniband/core/ucma.c                     |   10 +-
 drivers/infiniband/core/user_mad.c                 |    2 +-
 drivers/infiniband/core/uverbs.h                   |    3 +
 drivers/infiniband/core/uverbs_cmd.c               |  283 +++---
 drivers/infiniband/core/uverbs_ioctl.c             |  364 +++++++
 drivers/infiniband/core/uverbs_ioctl_merge.c       |  665 ++++++++++++
 drivers/infiniband/core/uverbs_main.c              |   42 +-
 drivers/infiniband/core/uverbs_marshall.c          |   48 +-
 drivers/infiniband/core/uverbs_std_types.c         |  281 +++++-
 drivers/infiniband/core/verbs.c                    |  177 +++-
 drivers/infiniband/hw/bnxt_re/Makefile             |    2 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |    5 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |  114 +++
 drivers/infiniband/hw/bnxt_re/hw_counters.h        |   62 ++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  107 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |    3 -
 drivers/infiniband/hw/bnxt_re/main.c               |  168 +++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  486 +++++++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   29 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   26 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   10 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   10 +
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |    2 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   77 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |    2 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h           |    4 +-
 drivers/infiniband/hw/cxgb3/iwch.c                 |    1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    5 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    1 -
 drivers/infiniband/hw/cxgb4/device.c               |    1 -
 drivers/infiniband/hw/cxgb4/mem.c                  |    2 +-
 drivers/infiniband/hw/cxgb4/provider.c             |    5 +-
 drivers/infiniband/hw/hfi1/Kconfig                 |    7 -
 drivers/infiniband/hw/hfi1/Makefile                |    2 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   18 +-
 drivers/infiniband/hw/hfi1/affinity.h              |   14 +-
 drivers/infiniband/hw/hfi1/aspm.h                  |   41 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  808 ++++++++-------
 drivers/infiniband/hw/hfi1/chip.h                  |   29 +-
 drivers/infiniband/hw/hfi1/common.h                |   11 +-
 drivers/infiniband/hw/hfi1/debugfs.c               |   94 +-
 drivers/infiniband/hw/hfi1/driver.c                |  513 +++++++---
 drivers/infiniband/hw/hfi1/eprom.c                 |   11 +-
 drivers/infiniband/hw/hfi1/exp_rcv.c               |  114 +++
 drivers/infiniband/hw/hfi1/exp_rcv.h               |  190 ++++
 drivers/infiniband/hw/hfi1/file_ops.c              |  437 ++++----
 drivers/infiniband/hw/hfi1/firmware.c              |   73 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |  554 +++++++---
 drivers/infiniband/hw/hfi1/init.c                  |  393 ++++++--
 drivers/infiniband/hw/hfi1/intr.c                  |    3 +-
 drivers/infiniband/hw/hfi1/iowait.h                |   70 +-
 drivers/infiniband/hw/hfi1/mad.c                   |  805 ++++++++++-----
 drivers/infiniband/hw/hfi1/mad.h                   |    5 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                |   27 +-
 drivers/infiniband/hw/hfi1/mmu_rb.h                |    5 +-
 drivers/infiniband/hw/hfi1/opa_compat.h            |   21 +-
 drivers/infiniband/hw/hfi1/pcie.c                  |  384 ++++---
 drivers/infiniband/hw/hfi1/pio.c                   |   15 +-
 drivers/infiniband/hw/hfi1/platform.c              |  102 +-
 drivers/infiniband/hw/hfi1/qp.c                    |  222 ++---
 drivers/infiniband/hw/hfi1/qp.h                    |   23 +-
 drivers/infiniband/hw/hfi1/rc.c                    |  426 +++++---
 drivers/infiniband/hw/hfi1/ruc.c                   |  321 ++++--
 drivers/infiniband/hw/hfi1/sdma.c                  |   42 +-
 drivers/infiniband/hw/hfi1/sdma.h                  |    3 +-
 drivers/infiniband/hw/hfi1/sysfs.c                 |    4 +-
 drivers/infiniband/hw/hfi1/trace.c                 |  191 +++-
 drivers/infiniband/hw/hfi1/trace.h                 |    3 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h          |  456 ++++++---
 drivers/infiniband/hw/hfi1/trace_misc.h            |   20 +
 drivers/infiniband/hw/hfi1/trace_mmu.h             |   95 ++
 drivers/infiniband/hw/hfi1/trace_rx.h              |  102 +-
 drivers/infiniband/hw/hfi1/trace_tx.h              |  136 ++-
 drivers/infiniband/hw/hfi1/uc.c                    |   60 +-
 drivers/infiniband/hw/hfi1/ud.c                    |  487 ++++++---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |  371 +++----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h          |   58 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |  626 +++++-------
 drivers/infiniband/hw/hfi1/user_sdma.h             |  169 +++-
 drivers/infiniband/hw/hfi1/verbs.c                 |  384 ++++---
 drivers/infiniband/hw/hfi1/verbs.h                 |   59 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.c           |   11 +-
 drivers/infiniband/hw/hfi1/vnic.h                  |   16 +-
 drivers/infiniband/hw/hfi1/vnic_main.c             |   39 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c             |   27 +-
 drivers/infiniband/hw/hns/Kconfig                  |    2 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |    4 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |    1 +
 drivers/infiniband/hw/hns/hns_roce_eq.c            |    3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |    5 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |    1 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |    2 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   27 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           |  134 ++-
 drivers/infiniband/hw/i40iw/i40iw_d.h              |    4 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |    1 -
 drivers/infiniband/hw/i40iw/i40iw_p.h              |   14 +-
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |    9 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |    8 +-
 drivers/infiniband/hw/i40iw/i40iw_status.h         |    2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h           |    5 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c             |   14 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |   22 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |    7 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |    4 +-
 drivers/infiniband/hw/mlx4/cq.c                    |    4 +-
 drivers/infiniband/hw/mlx4/mad.c                   |    8 +-
 drivers/infiniband/hw/mlx4/main.c                  |   54 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |    9 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   42 +-
 drivers/infiniband/hw/mlx4/qp.c                    | 1054 ++++++++++++++++++--
 drivers/infiniband/hw/mlx4/srq.c                   |   17 +-
 drivers/infiniband/hw/mlx5/Makefile                |    2 +-
 drivers/infiniband/hw/mlx5/cmd.c                   |   20 +
 drivers/infiniband/hw/mlx5/cmd.h                   |    4 +
 drivers/infiniband/hw/mlx5/cong.c                  |  421 ++++++++
 drivers/infiniband/hw/mlx5/cq.c                    |    8 +-
 drivers/infiniband/hw/mlx5/ib_virt.c               |    9 +
 drivers/infiniband/hw/mlx5/mad.c                   |    4 +-
 drivers/infiniband/hw/mlx5/main.c                  |  464 ++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   86 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  121 ++-
 drivers/infiniband/hw/mlx5/odp.c                   |    2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  172 +++-
 drivers/infiniband/hw/mlx5/srq.c                   |   33 +-
 drivers/infiniband/hw/mthca/mthca_av.c             |   10 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c            |   14 +-
 drivers/infiniband/hw/mthca/mthca_dev.h            |    4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c            |    4 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |    3 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |    7 +-
 drivers/infiniband/hw/nes/nes.c                    |   70 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   10 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |    6 +-
 drivers/infiniband/hw/qedr/main.c                  |    7 +-
 drivers/infiniband/hw/qedr/qedr.h                  |    3 +-
 drivers/infiniband/hw/qedr/verbs.c                 |    5 +-
 drivers/infiniband/hw/qib/qib.h                    |    8 +-
 drivers/infiniband/hw/qib/qib_debugfs.c            |   18 +-
 drivers/infiniband/hw/qib/qib_driver.c             |    1 -
 drivers/infiniband/hw/qib/qib_iba6120.c            |   26 +-
 drivers/infiniband/hw/qib/qib_iba7220.c            |   29 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   92 +-
 drivers/infiniband/hw/qib/qib_init.c               |    3 +-
 drivers/infiniband/hw/qib/qib_mad.c                |   23 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |  149 ++-
 drivers/infiniband/hw/qib/qib_qp.c                 |   51 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |    4 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |   32 +-
 drivers/infiniband/hw/qib/qib_sysfs.c              |    4 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |   43 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    9 +
 drivers/infiniband/hw/qib/qib_verbs.h              |   14 +-
 drivers/infiniband/hw/usnic/usnic_fwd.c            |   12 +-
 drivers/infiniband/hw/usnic/usnic_fwd.h            |    2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |   18 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   43 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |    1 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |    2 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |   20 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h  |   37 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   44 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c     |    7 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h     |   17 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |    9 +
 drivers/infiniband/sw/rdmavt/ah.c                  |   10 -
 drivers/infiniband/sw/rdmavt/cq.c                  |    2 +-
 drivers/infiniband/sw/rdmavt/mr.c                  |  170 +++-
 drivers/infiniband/sw/rdmavt/qp.c                  |  348 ++++++-
 drivers/infiniband/sw/rdmavt/trace_mr.h            |   62 ++
 drivers/infiniband/sw/rdmavt/trace_tx.h            |   11 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |    9 +-
 drivers/infiniband/sw/rxe/rxe.c                    |    1 -
 drivers/infiniband/sw/rxe/rxe.h                    |    2 +-
 drivers/infiniband/sw/rxe/rxe_av.c                 |    7 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   19 +
 drivers/infiniband/sw/rxe/rxe_hw_counters.c        |    2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |    6 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c               |    2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |   12 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   26 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |    2 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |    9 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |    6 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |    2 +-
 drivers/infiniband/sw/rxe/rxe_task.c               |    4 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   67 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |    2 +
 drivers/infiniband/ulp/ipoib/ipoib.h               |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    9 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   25 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   50 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   33 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   22 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c           |    6 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    1 -
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |   35 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    1 -
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    5 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    4 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   10 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |    7 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    3 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |    7 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    2 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   57 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   13 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   32 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  123 +--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   42 +
 drivers/net/ethernet/mellanox/mlx5/core/srq.c      |  150 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   62 ++
 drivers/nvme/host/rdma.c                           |   34 +-
 drivers/nvme/target/rdma.c                         |    5 -
 drivers/pci/pci-driver.c                           |    1 +
 include/linux/blk-mq-rdma.h                        |   10 +
 include/linux/mlx4/device.h                        |   12 +-
 include/linux/mlx5/device.h                        |   11 +-
 include/linux/mlx5/driver.h                        |   31 +-
 include/linux/mlx5/mlx5_ifc.h                      |  109 +-
 include/linux/mlx5/qp.h                            |    4 +-
 include/linux/mlx5/srq.h                           |    5 +
 include/linux/mlx5/vport.h                         |    3 +-
 include/linux/pci.h                                |    1 +
 include/rdma/ib_addr.h                             |   11 +-
 include/rdma/ib_hdrs.h                             |   84 ++
 include/rdma/ib_marshall.h                         |    6 +-
 include/rdma/ib_verbs.h                            |  163 ++-
 include/rdma/opa_addr.h                            |   42 +-
 include/rdma/opa_vnic.h                            |    3 -
 include/rdma/rdma_netlink.h                        |   58 +-
 include/rdma/rdma_vt.h                             |   23 +-
 include/rdma/rdmavt_mr.h                           |    3 +
 include/rdma/rdmavt_qp.h                           |   33 +-
 include/rdma/uverbs_ioctl.h                        |  438 ++++++++
 include/rdma/uverbs_std_types.h                    |   58 +-
 include/rdma/uverbs_types.h                        |   39 +-
 include/uapi/rdma/ib_user_ioctl_verbs.h            |   84 ++
 include/uapi/rdma/ib_user_verbs.h                  |   19 +-
 include/uapi/rdma/mlx4-abi.h                       |   52 +-
 include/uapi/rdma/mlx5-abi.h                       |   23 +
 include/uapi/rdma/qedr-abi.h                       |    3 +
 include/uapi/rdma/rdma_netlink.h                   |   84 +-
 include/uapi/rdma/rdma_user_ioctl.h                |   33 +
 include/uapi/rdma/vmw_pvrdma-abi.h                 |    6 +-
 282 files changed, 15100 insertions(+), 5331 deletions(-)
 create mode 100644 Documentation/infiniband/tag_matching.txt
 create mode 100644 block/blk-mq-rdma.c
 create mode 100644 drivers/infiniband/core/nldev.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_merge.c
 create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.c
 create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.h
 create mode 100644 drivers/infiniband/hw/hfi1/exp_rcv.c
 create mode 100644 drivers/infiniband/hw/hfi1/exp_rcv.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_mmu.h
 create mode 100644 drivers/infiniband/hw/mlx5/cong.c
 create mode 100644 include/linux/blk-mq-rdma.h
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/uapi/rdma/ib_user_ioctl_verbs.h

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
