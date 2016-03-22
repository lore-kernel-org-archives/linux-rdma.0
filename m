From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 22 Mar 2016 16:50:23 -0400
Message-ID: <56F1B00F.7010406@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nqL5MsKglWGXoxXxuj4pjxISSJ5lm6FR5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nqL5MsKglWGXoxXxuj4pjxISSJ5lm6FR5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is a monster pull request.  I held off on the hfi1 driver updates
(the hfi1 driver is intimately tied to the qib driver and the new rdmavt
software library that was created to help both of them) in my first pull
request.  The hfi1/qib/rdmavt update is probably 90% of this pull
request.  The hfi1 driver is being left in staging so that it can be
fixed up in regards to the API that Al and yourself didn't like.  Intel
has agreed to do the work, but in the meantime, this clears out 300+
patches in the backlog queue and brings my tree and their tree closer to
sync.  There were some conflicts in the linux-next merge process for
these patches, but they were all minor and basically the result of some
patches coming in via GKH and some from me.  It seems that no matter how
well we update the docs on the driver in staging to indicate that
patches should go to linux-rdma@, some still go to the typical staging
mailing list and invariably a few get picked up by GKH.  As soon as we
get the driver out of staging that issue will go away of course.

This also includes about 10 patches to the core and a few to mlx5 to
create an infrastructure for configuring SRIOV ports on IB devices.
That series includes one patch to the net core that we sent to netdev@
and Dave Miller with each of the three revisions to the series.  We
didn't get any response to the patch, so we took that as implicit approva=
l.

Finally, this series includes Intel's new iWARP driver for their x722
cards.  It's not nearly the beast as the hfi1 driver.  It also has a
linux-next merge issue, but that has been resolved and it now passes
just fine.

I've not ever put in a pull request this large.  Let me know if you need
me to do things differently.

BTW, if you look at the topic branches that created this set, I should
note that there is one lone patch applied directly to the for-4.6 branch
before I merged the three topic branches.  Trying to avoid any surprises
in diffstat outputs or such like we had with the last pull request.

Here's the git request pull boilerplate:

The following changes since commit 082eaa50838c6b70a8244f8b01d7ed7d686f84=
db:

  Merge branches 'nes', 'cxgb4' and 'iwpm' into k.o/for-4.6 (2016-03-16
13:57:43 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 520a07bff6fbb23cac905007d74c67058b189acb:

  Merge branches 'i40iw', 'sriov' and 'hfi1' into k.o/for-4.6
(2016-03-21 17:32:23 -0400)

----------------------------------------------------------------
Round two of 4.6 merge window patches

- A few minor core fixups needed for the next patch series
- The IB SRIOV series.  This has bounced around for several versions.
  Of note is the fact that the first patch in this series effects
  the net core.  It was directed to netdev and DaveM for each iteration
  of the series (three versions total).  Dave did not object, but did
  not respond either.  I've taken this as permission to move forward
  with the series.
- The new Intel X722 iWARP driver
- A huge set of updates to the Intel hfi1 driver.  Of particular interest=

  here is that we have left the driver in staging since it still has an
  API that people object to.  Intel is working on a fix, but getting
  these patches in now helps keep me sane as the upstream and Intel's
  trees were over 300 patches apart.

----------------------------------------------------------------
Alex Estrin (1):
      IB/rdmavt: Post receive for QP in ERR state

Anjali Singhai Jain (1):
      i40e: Add support for client interface for IWARP driver

Ashutosh Dixit (1):
      staging/rdma/hfi1: Add support for enabling/disabling PCIe ASPM

Bryan Morgan (1):
      staging/rdma/hfi1: HFI reports wrong offline disabled reason when
cable removed

Dan Carpenter (1):
      ib_srpt: fix a WARN_ON() message

Dean Luick (35):
      staging/hfi1: set Gen3 half-swing for integrated devices
      staging/hfi1: Remove unneeded variable index
      staging/rdma/hfi1: Fix missing firmware NULL dereference
      staging/rdma/hfi1: Only warn when board description is not found
      staging/rdma/hfi1: Make firmware failure messages warnings
      staging/rdma/hfi1: No firmware retry for simulation
      staging/rdma/hfi1: Skip lcb init for simulation
      staging/rdma/hfi1: Fix for generic I2C interface
      staging/rdma/hfi1: Use device file minor to identify EPROM
      staging/rdma/hfi1: correctly check for post-interrupt packets
      staging/rdma/hfi1: Report physical state changes per device
instead of globally
      staging/rdma/hfi1: Fix fabric serdes reset by re-downloading firmwa=
re
      staging/rdma/hfi1: Split last 8 bytes of copy to user buffer
      staging/rdma/hfi1: Remove PCIe AER diagnostic message
      staging/rdma/hfi1: Correct TWSI reset
      staging/rdma/hfi1: Fix snoop packet length calculation
      staging/rdma/hfi1: Make EPROM check per device
      staging/rdma/hfi1: Remove unused variable nsbr
      staging/rdma/hfi1: Fix xmit discard error weight
      staging/rdma/hfi1: Fix debugfs access race
      staging/rdma/hfi1: Disclose more information when i2c fails
      staging/rdma/hfi1: Guard i2c access against cp
      staging/rdma/hfi1: Fix counter read for cp
      IB/hfi1: Remove ASIC block clear
      IB/hfi1: Add shared ASIC structure
      IB/hfi1: Add ASIC resource reservation functions
      IB/hfi1: Change EPROM handling to use resource reservation
      IB/hfi1: Change SBus handling to use resource reservation
      IB/hfi1: Change QSFP functions to use resource reservation
      IB/hfi1: Change thermal init to use resource reservation
      IB/hfi1: Remove unused HFI1_DO_INIT_ASIC flag
      IB/hfi1: Reduce hardware mutex timeout
      IB/hfi1: Hold i2c resource across debugfs open/close
      IB/hfi1: Add ASIC flag view/clear
      IB/hfi1: Add adaptive cacheless verbs copy

Dennis Dalessandro (100):
      IB/rdmavt: Create module framework and handle driver registration
      IB/rdmavt: Consolidate dma ops in rdmavt.
      IB/rdmavt: Add protection domain to rdmavt.
      IB/rdmavt: Add ib core device attributes to rvt driver params list
      IB/rdmavt: Macroize override checks during driver registration
      IB/rdmavt: Add query and modify device stubs
      IB/rdmavt: Add query and modify port stubs
      IB/rdmavt: Add pkey query stub
      IB/rdmavt: Add query gid stub
      IB/rdmavt: Alloc and dealloc ucontexts
      IB/rdmavt: Add queue pair function stubs
      IB/rdmavt: Add address handle stubs
      IB/rdmavt: Add memory region stubs
      IB/rdmavt: Add SRQ stubs
      IB/rdmavt: Add multicast stubs
      IB/rdmavt: Add process MAD stub
      IB/rdmavt: Add mmap stub
      IB/rdmavt: Add get port immutable stub
      IB/rdmavt: Add completion queue function stubs
      IB/rdmavt: Add post send and recv stubs
      IB/rdmavt: Move MR datastructures into rvt
      IB/rdmavt: Add queue pair data structure to rdmavt
      IB/rdmavt: Move driver helper functions to a common structure
      IB/rdmavt: Add device specific info prints
      IB/rdmavt: Add the start of capability flags
      IB/rdmavt: Move memory registration into rdmavt
      IB/rdmavt: Do not use rvt prints which rely on driver too early
      IB/rdmavt: Move SRQ data structure into rdmavt
      IB/rdmavt: Add an ibport data structure to rdmavt
      IB/rdmavt: Add driver notification for new AH
      IB/rdmavt: Break rdma_vt main include header file up
      IB/rdmavt: Initialize and teardown of qpn table
      IB/rdmavt: Add mmap related functions
      IB/rdmavt: Add pkey support
      IB/qib: Begin to use rdmavt for verbs
      IB/qib: Remove dma.c and use rdmavt version of dma functions
      IB/qib: Use rdmavt protection domain
      IB/qib: Remove most uses of QIB_PERMISSIVE_LID and
QIB_MULTICAST_LID_BASE
      IB/qib: Use rdmavt lid defines in qib
      IB/qib: Remove driver specific members from qib qp type
      IB/qib: Add device specific info prints
      IB/qib: Remove qp and mr functionality from qib
      IB/qib: Use address handle in rdmavt and remove from qib
      IB/qib: Remove srq from qib
      IB/rdmavt: Add R and S flags for queue pairs
      IB/rdmavt: Add create queue pair functionality
      IB/rdmavt: Export reset_qp in rdmavt
      IB/rdmavt: Add completion queue functions
      IB/rdmavt: Add post send to rdmavt
      IB/rdmavt: Add support for tracing events
      IB/rdmavt: Add modify qp
      IB/rdmavt: Add destroy qp verb
      IB/rdmavt: Add post receive to rdmavt
      IB/rdmavt: Add multicast functions
      IB/rdmavt: Add misc dev register functionality
      IB/rdmavt: Add device structure allocation
      IB/rdmavt: Add mad agents to rdmavt
      IB/rdmavt: Fix copyright date
      IB/qib: Use rdmavt device allocation function
      IB/qib: Remove create and free mad agents
      IB/rdmavt: Clean up distinction between port number and index
      IB/rdmavt: Add query gid support.
      IB/qib: Clean up register_ib_device
      IB/qib: Support query gid in rdmavt
      staging/rdma/hfi1: Begin to use rdmavt for verbs
      staging/rdma/hfi1: Add basic rdmavt capability flags for hfi1
      staging/rdma/hfi1: Use rdmavt protection domain
      staging/rdma/hfi1: Remove MR data structures from hfi1
      staging/rdma/hfi1: Remove driver specific members from hfi1 qp type=

      staging/rdma/hfi1: Add device specific info prints
      staging/rdma/hfi1: Use correct rdmavt header files after move.
      staging/rdma/hfi1: Use address handle in rdmavt and remove from hfi=
1
      staging/rdma/hfi1: Implement hfi1 support for AH notification
      staging/rdma/hfi1: Remove hfi1 MR and hfi1 specific qp type
      staging/rdma/hfi1: Remove srq from hfi1
      staging/rdma/hfi1: Remove ibport and use rdmavt version
      staging/rdma/hfi1: Remove mmap from hfi1
      staging/rdma/hfi1: Use rdmavt pkey verbs function
      staging/rdma/hfi1: Use rdmavt send flags and recv flags
      staging/rdma/hfi1: Remove qpdev and qpn table from hfi1
      staging/rdma/hfi1: Remove create_qp functionality
      staging/rdma/hfi1: Remove CQ data structures and functions from hfi=
1
      staging/rdma/hfi1: Clean up return handling
      staging/rdma/hfi1: Use rdmavt version of post_send
      staging/rdma/hfi1: Remove multicast verbs functions
      staging/rdma/hfi1: Remove modify queue pair from hfi1
      staging/rdma/hfi1: Remove destroy qp verb
      staging/rdma/hfi1: Remove post_recv and use rdmavt version
      staging/rdma/hfi1: Clean up register device
      staging/rdma/hfi1: Use rdmavt device allocation function
      staging/rdma/hfi1: Remove create and free mad agents
      staging/rdma/hfi1: Support query gid in rdmavt
      IB/rdmavt: Clean up comments and add more documentation
      IB/rdmavt: Add per verb driver callback checking
      IB/qib: Setup notify free/create mad agent callbacks for rdmavt
      IB/qib,rdmavt: Move smi_ah to qib
      IB/rdmavt: Remove RVT_FLAGs
      IB/rdmavt: Remove signal_supported and comments
      IB/rdmavt: Remove unnecessary exported functions
      staging/rdma/hfi1: Remove header memcpy from sdma send path.

Doug Ledford (1):
      Merge branches 'i40iw', 'sriov' and 'hfi1' into k.o/for-4.6

Easwar Hariharan (13):
      staging/rdma/hfi1: cleanup messages on qsfp_read() failure
      staging/rdma/hfi1: Add active and optical cable support
      staging/rdma/hfi1: Get port type from configuration file
      staging/rdma/hfi1: Support external device configuration requests
from 8051
      staging/rdma/hfi1: Don't attempt to qualify or tune loopback plugs
      staging/rdma/hfi1: Reduce syslog message severity and provide
speed information
      staging/rdma/hfi1: Implement LED beaconing for maintenance
      staging/rdma/hfi1, IB/core: Fix LinkDownReason define for consisten=
cy
      staging/rdma/hfi1: Fetch platform configuration data from EFI varia=
ble
      staging/rdma/hfi1: Tune for unknown channel if configuration file
is absent
      staging/rdma/hfi1: Cleanup comments and logs in PHY code
      staging/rdma/hfi1: Fix reporting of LED status in Get(LedInfo) and
Get(PortInfo)
      IB/hfi1: Improve LED beaconing

Edward Mascarenhas (1):
      staging/hfi1: Clean up comments

Eli Cohen (10):
      net/core: Add support for configuring VF GUIDs
      IB/mlx5: Fix decision on using MAD_IFC
      IB/core: Add subnet prefix to port info
      IB/core: Support accessing SA in virtualized environment
      IB/core: Add interfaces to control VF attributes
      IB/ipoib: Add ndo operations for configuring VFs
      net/mlx5_core: Add VF param when querying vport counter
      net/mlx5_core: Implement modify HCA vport command
      IB/mlx5: Implement callbacks for manipulating VFs
      IB/ipoib: Allow mcast packets from other VFs

Faisal Latif (16):
      i40iw: add entry in rdma_netlink
      i40iw: add main, hdr, status
      i40iw: add connection management code
      i40iw: add puda code
      i40iw: add pble resource files
      i40iw: add hmc resource files
      i40iw: add hw and utils files
      i40iw: add files for iwarp interface
      i40iw: use shared code for port mapper
      i40iw: add file to handle cqp calls
      i40iw: add hardware related header files
      i40iw: add X722 register file
      i40iw: user kernel shared files
      i40iw: virtual channel handling files
      i40iw: Kconfig and Makefile for iwarp module
      i40iw: changes for build of i40iw module

Hari Prasath Gujulan Elango (1):
      IB/qib,staging/rdma/hfi1: use setup_timer api

Harish Chegondi (34):
      staging/hfi1: Move s_sde to read mostly section of hfi1_qp
      IB/rdmavt: Add IB user context allocation and de-alloction function=
s
      IB/rdmavt: Allow reserving just one qpn
      IB/rdmavt: Add support for rvt_query_device function
      IB/qib: Remove ibport and use rdmavt version
      IB/qib: Implement qib support for AH notification
      IB/qib: Remove mmap from qib
      IB/qib: Use rdmavt pkey verbs function
      IB/qib: Remove qpn, qp tables and related variables from qib
      IB/qib: Delete QIB user context allocation and de-alloction functio=
ns
      IB/qib: Remove qib_query_device function
      IB/qib: Use rdmavt send and receive flags
      IB/qib: Remove create qp and create qp table functionality
      IB/rdmavt: Add support for rvt_query_qp
      IB/qib: Remove completion queue data structures and functions from =
qib
      IB/qib: Use rdmavt version of post_send
      IB/qib: Remove qib_post_receive and use rdmavt version
      IB/qib: Remove qib multicast verbs functions
      IB/qib: Remove qib_query_qp function
      IB/rdmavt: Add support for query_port, modify_port and
get_port_immutable
      IB/qib: Remove qib_lookup_qpn and use rvt_lookup_qpn instead
      IB/qib: Remove modify queue pair code
      IB/qib: Remove destroy queue pair code
      IB/qib: Remove modify_port and port_immutable functions
      staging/rdma/hfi1: Remove user context allocation and de-alloction
functions
      staging/rdma/hfi1: Remove query_device function
      staging/rdma/hfi1: Remove hfi1_query_qp function
      staging/rdma/hfi1: Remove modify_port and port_immutable functions
      IB/qib: Rename several functions by adding a "qib_" prefix
      IB/rdmavt: Add trace and error print statements in post_one_wr
      IB/qib: Destroy SMI AH before de-allocating the protection domain
      IB/hfi1: Add the break statement that was removed in an earlier pat=
ch
      IB/hfi1: Move constant to the right in bitwise operations
      IB/hfi1: Replace kmalloc and memcpy with a kmemdup

Ira Weiny (8):
      staging/hfi1: add dd_dev_dbg
      staging/hfi1: Fix Xmit Wait calculation
      IB/rdmavt: Remove unused variable from Queue Pair
      IB/rdmavt: add modify queue pair driver helpers
      IB/rdmavt: Add hardware driver send work request check
      IB/rdmavt: Properly pass gfp to hw driver function
      staging/rdma/hfi1: Consolidate dma ops for hfi1
      staging/rdma/hfi1: Fix SL->SC checks

Jianxin Xiong (1):
      staging/rdma/hfi1: Fix header size calculation for RC/UC QPs with
GRH enabled

Jim Snow (1):
      staging/hfi1: check for ARMED->ACTIVE change in recv int

Jubin John (31):
      IB/rdmavt: Add srq functionality to rdmavt
      IB/qib: Remove srq functionality
      staging/rdma/hfi1: Remove srq functionality
      staging/rdma/hfi1: Clean up init_cntrs()
      staging/rdma/hfi1: Add s_sendcontext priv field
      staging/rdma/hfi1: Add qp to send context mapping for PIO
      staging/rdma/hfi1: Add send context sw index
      staging/rdma/hfi1: Add spaces around binary operators
      staging/rdma/hfi1: Remove multiple blank lines
      staging/rdma/hfi1: Remove space after cast
      staging/rdma/hfi1: Fix comparison to NULL
      staging/rdma/hfi1: Remove blank line after an open brace
      staging/rdma/hfi1: Remove blank line before close brace
      staging/rdma/hfi1: Fix logical continuations
      staging/rdma/hfi1: Add blank link after declarations
      staging/rdma/hfi1: Remove unnecessary parentheses
      staging/rdma/hfi1: Use BIT_ULL macro
      staging/rdma/hfi1: Split multiple assignments
      staging/rdma/hfi1: Fix misspellings
      staging/rdma/hfi1: Remove CamelCase
      staging/rdma/hfi1: Use pointer instead of struct name
      staging/rdma/hfi1: Remove void function return statement
      staging/rdma/hfi1: Add comment for spinlock_t definition
      staging/rdma/hfi1: Fix block comments
      staging/rdma/hfi1: Fix code alignment
      staging/rdma/hfi1: Add braces on all arms of statement
      staging/rdma/hfi1: Remove else after break
      staging/rdma/hfi1: Fix header
      IB/rdmavt: Check lkey_table_size value before use
      staging/rdma/hfi1: Fix memory leaks
      IB/hfi1: Handle host handshake timeout

Kaike Wan (4):
      staging/rdma/hfi1: Put QPs into error state after SL->SC table chan=
ges
      staging/rdma/hfi1: Avoid using upstream component if it is not
accessible
      staging/rdma/hfi1: Check interrupt registers mapping
      IB/hfi1: Don't call cond_resched in atomic mode when sending packet=
s

Kamal Heib (2):
      IB/rdmavt: Add common LID defines to rdmavt
      IB/rdmavt: Add AH to rdmavt

Leon Romanovsky (4):
      net/mlx5_core: Fix caching ATOMIC endian mode capability
      net/mlx5_core: Refactor device capability function
      IB/core: Replace setting the zero values in ib_uverbs_ex_query_devi=
ce
      IB/{core, ulp} Support above 32 possible device capability flags

Mark F. Brown (1):
      staging/hfi1: change krcvqs mod param from byte to uint

Mike Marciniszyn (36):
      IB/rdmavt: Support creating qps with GFP_NOIO flag
      staging/rdma/hfi1: Fix QSFP memory read/write across 128 byte bound=
ary
      staging/rdma/hfi1: Fix per-VL transmit discard counts
      staging/rdma/hfi1: centralize timer routines into rc
      staging/rdma/hfi1: use new timer routines
      staging/rdma/hfi1: use mod_timer when appropriate
      staging/rdma/hfi1: add unique rnr timer
      staging/rdma/hfi1: use new RNR timer
      staging/rdma/hfi1: remove duplicate timeout print
      staging/rdma/hfi1: add s_retry to diagnostics
      staging/rdma/hfi1: Insure last cursor is updated prior to complete
      IB/qib: Insure last cursor is updated prior to complete
      IB/rdmavt: remove unused qp field
      staging/rdma/hfi1: actually use new RNR timer API in loopback path
      IB/qib, staging/rdma/hfi1: add s_hlock for use in post send
      staging/rdma/hfi1: add s_avail to qp_stats
      IB/rdmvt: close send engine struct holes
      staging/rdma/hfi1: move txreq header code
      staging/rdma/hfi1: remove s_rdma_mr
      staging/rdma/hfi1: avoid passing pmtu
      staging/rdma/hfi1: fix panic in send engine
      staging/rdma/hfi1: use u8 for vl/sl
      staging/rdma/hfi1: Adaptive PIO for short messages
      IB/qib, staging/rdma/hfi1, IB/rdmavt: progress selection changes
      staging/rdma/hfi: fix CQ completion order issue
      staging/rdma/hfi1: Determine actual operational VLs
      staging/rdma/hfi1: fix 0-day syntax error
      IB/rdamvt: fix cross build with rdmavt
      IB/hfi1: Report pid in qp_stats to aid debug
      IB/hfi1: Fix issues with qp_stats print
      IB/hfi1: Add unique trace point for pio and sdma send
      IB/hfi1: Fix ordering of trace for accuracy
      IB/hfi1: Fix PIO wakeup timing hole
      IB/hfi1: Fix panic in adaptive pio
      IB/hfi1: Fix adaptive pio packet corruption
      IB/hfi1: Enable adaptive pio by default

Mitko Haralanov (41):
      staging/hfi1: Add function stubs for TID caching
      uapi/hfi1_user: Correct comment for capability bit
      uapi/hfi1_user: Add command and event for TID caching
      staging/hfi1: Add definitions needed for TID cache
      staging/hfi1: Remove un-needed variable
      staging/hfi1: TID group definitions and support funcs
      staging/hfi1: Add building blocks for TID caching
      staging/hfi1: Convert lock to mutex
      staging/hfi1: Add TID cache receive init and free funcs
      staging/hfi1: Add MMU notifier callback function
      staging/hfi1: Add TID free/clear function bodies
      staging/hfi1: Add TID entry program function body
      staging/hfi1: Enable TID caching feature
      IB/rdmavt: Add Mem affinity support
      staging/rdma/hfi1: Correctly set RcvCtxtCtrl register
      staging/rdma/hfi1: Remove unused code
      staging/rdma/hfi1: Remove unnecessary duplicated variable
      staging/rdma/hfi1: Consolidate CPU/IRQ affinity support
      staging/rdma/hfi1: Allocate send ctxt on device NUMA node
      staging/rdma/hfi1: Verbs Mem affinity support
      staging/rdma/hfi1: Improve performance of TID cache look up
      staging/rdma/hfi1: Improve performance of SDMA transfers
      staging/rdma/hfi1: Properly determine error status of SDMA slots
      staging/rdma/hfi1: Improve performance of user SDMA
      staging/rdma/hfi1: Fix bug that could block the process on context
exit
      IB/hfi1: Re-factor MMU notification code
      IB/hfi1: Allow MMU function execution in IRQ context
      IB/hfi1: Prevent NULL pointer dereference
      IB/hfi1: Allow remove MMU callbacks to free nodes
      IB/hfi1: Remove the use of add/remove RB function pointers
      IB/hfi1: Notify remove MMU/RB callback of calling context
      IB/hfi1: Use interval RB trees
      IB/hfi1: Add MMU tracing
      IB/hfi1: Remove compare callback
      IB/hfi1: Add filter callback
      IB/hfi1: Adjust last address values for intervals
      IB/hfi1: Implement SDMA-side buffer caching
      IB/hfi1: Add pin query function
      IB/hfi1: Specify mm when releasing pages
      IB/hfi1: Switch to using the pin query function
      IB/hfi1: Add SDMA cache eviction algorithm

Sadanand Warrier (1):
      staging/rdma/hfi1: Add credits for VL0 to VL7 in snoop mode

Sagi Grimberg (1):
      net/mlx5_core: Introduce offload arithmetic hardware capabilities

Sebastian Sanchez (7):
      staging/rdma/hfi1: Fix for 32-bit counter overflow in driver and
hfi1stats
      staging/rdma/hfi1: Fix for module parameter rcvhdrcnt when it's
2097152
      staging/rdma/hfi1: Change for data type of port number
      staging/rdma/hfi1: Replacement of goto's for break/returns
      staging/rdma/hfi1: Adding support for hfi counters via sysfs
      staging/rdma/hfi1: Removing unused struct hfi1_verbs_counters
      staging/rdma/hfi1: Turning off LED without checking if stepping is =
Ax

Tatyana Nikolova (1):
      i40iw: Replace the obsolete crypto hash interface with shash

Vennila Megavannan (6):
      staging/hfi1: add per SDMA engine stats to hfistats
      staging/rdma/hfi1: Method to toggle "fast ECN" detection
      staging/rdma/hfi1: Change send_schedule counter to a per cpu counte=
r
      staging/rdma/hfi1: Allow a fair scheduling of QPs
      IB/rdmavt, staging/rdma/hfi1: use qps to dynamically scale timeout
value
      staging/rdma/hfi1: add cq head and tail information to qpstats

jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org (2):
      staging/hfi1: Use BIT macro
      staging/hfi1: Change default krcvqs

 Documentation/infiniband/sysfs.txt                 |    3 +-
 MAINTAINERS                                        |   16 +
 drivers/infiniband/Kconfig                         |    3 +
 drivers/infiniband/Makefile                        |    1 +
 drivers/infiniband/core/device.c                   |   15 +-
 drivers/infiniband/core/sa_query.c                 |    5 +
 drivers/infiniband/core/uverbs_cmd.c               |   17 +-
 drivers/infiniband/core/verbs.c                    |   40 +
 drivers/infiniband/hw/Makefile                     |    1 +
 drivers/infiniband/hw/i40iw/Kconfig                |    7 +
 drivers/infiniband/hw/i40iw/Makefile               |    9 +
 drivers/infiniband/hw/i40iw/i40iw.h                |  570 +++
 drivers/infiniband/hw/i40iw/i40iw_cm.c             | 4141 ++++++++++++++=
+++
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |  456 ++
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           | 4743
++++++++++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_d.h              | 1713 +++++++
 drivers/infiniband/hw/i40iw/i40iw_hmc.c            |  821 ++++
 drivers/infiniband/hw/i40iw/i40iw_hmc.h            |  241 +
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |  730 +++
 drivers/infiniband/hw/i40iw/i40iw_main.c           | 1910 ++++++++
 drivers/infiniband/hw/i40iw/i40iw_osdep.h          |  215 +
 drivers/infiniband/hw/i40iw/i40iw_p.h              |  106 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |  618 +++
 drivers/infiniband/hw/i40iw/i40iw_pble.h           |  131 +
 drivers/infiniband/hw/i40iw/i40iw_puda.c           | 1436 ++++++
 drivers/infiniband/hw/i40iw/i40iw_puda.h           |  183 +
 drivers/infiniband/hw/i40iw/i40iw_register.h       | 1030 +++++
 drivers/infiniband/hw/i40iw/i40iw_status.h         |  100 +
 drivers/infiniband/hw/i40iw/i40iw_type.h           | 1312 ++++++
 drivers/infiniband/hw/i40iw/i40iw_ucontext.h       |  107 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c             | 1204 +++++
 drivers/infiniband/hw/i40iw/i40iw_user.h           |  442 ++
 drivers/infiniband/hw/i40iw/i40iw_utils.c          | 1270 ++++++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          | 2437 ++++++++++
 drivers/infiniband/hw/i40iw/i40iw_verbs.h          |  173 +
 drivers/infiniband/hw/i40iw/i40iw_vf.c             |   85 +
 drivers/infiniband/hw/i40iw/i40iw_vf.h             |   62 +
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c       |  748 +++
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h       |  124 +
 drivers/infiniband/hw/mlx5/Makefile                |    2 +-
 drivers/infiniband/hw/mlx5/ib_virt.c               |  194 +
 drivers/infiniband/hw/mlx5/mad.c                   |    2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   12 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    8 +
 drivers/infiniband/hw/qib/Kconfig                  |    2 +-
 drivers/infiniband/hw/qib/Makefile                 |   10 +-
 drivers/infiniband/hw/qib/qib.h                    |   33 +-
 drivers/infiniband/hw/qib/qib_common.h             |    3 -
 drivers/infiniband/hw/qib/qib_cq.c                 |  545 ---
 drivers/infiniband/hw/qib/qib_driver.c             |   71 +-
 drivers/infiniband/hw/qib/qib_iba6120.c            |    8 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |    6 +-
 drivers/infiniband/hw/qib/qib_init.c               |   25 +-
 drivers/infiniband/hw/qib/qib_intr.c               |    2 +-
 drivers/infiniband/hw/qib/qib_keys.c               |  186 +-
 drivers/infiniband/hw/qib/qib_mad.c                |  338 +-
 drivers/infiniband/hw/qib/qib_mmap.c               |  174 -
 drivers/infiniband/hw/qib/qib_mr.c                 |  490 --
 drivers/infiniband/hw/qib/qib_qp.c                 | 1178 +----
 drivers/infiniband/hw/qib/qib_rc.c                 |  409 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |  191 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |   41 +-
 drivers/infiniband/hw/qib/qib_srq.c                |  380 --
 drivers/infiniband/hw/qib/qib_sysfs.c              |   85 +-
 drivers/infiniband/hw/qib/qib_uc.c                 |   79 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |  142 +-
 drivers/infiniband/hw/qib/qib_verbs.c              | 1223 ++---
 drivers/infiniband/hw/qib/qib_verbs.h              |  812 +---
 drivers/infiniband/hw/qib/qib_verbs_mcast.c        |  363 --
 drivers/infiniband/sw/Makefile                     |    1 +
 drivers/infiniband/sw/rdmavt/Kconfig               |    6 +
 drivers/infiniband/sw/rdmavt/Makefile              |   13 +
 drivers/infiniband/sw/rdmavt/ah.c                  |  196 +
 drivers/infiniband/sw/rdmavt/ah.h                  |   59 +
 .../rdma/hfi1 =3D> infiniband/sw/rdmavt}/cq.c        |  325 +-
 drivers/infiniband/sw/rdmavt/cq.h                  |   64 +
 drivers/infiniband/sw/rdmavt/dma.c                 |  184 +
 drivers/infiniband/sw/rdmavt/dma.h                 |   53 +
 drivers/infiniband/sw/rdmavt/mad.c                 |  171 +
 drivers/infiniband/sw/rdmavt/mad.h                 |   60 +
 .../verbs_mcast.c =3D> infiniband/sw/rdmavt/mcast.c} |  262 +-
 drivers/infiniband/sw/rdmavt/mcast.h               |   58 +
 .../rdma/hfi1 =3D> infiniband/sw/rdmavt}/mmap.c      |  142 +-
 drivers/infiniband/sw/rdmavt/mmap.h                |   63 +
 drivers/infiniband/sw/rdmavt/mr.c                  |  830 ++++
 drivers/infiniband/sw/rdmavt/mr.h                  |   92 +
 drivers/infiniband/sw/rdmavt/pd.c                  |  119 +
 drivers/infiniband/sw/rdmavt/pd.h                  |   58 +
 drivers/infiniband/sw/rdmavt/qp.c                  | 1696 +++++++
 drivers/infiniband/sw/rdmavt/qp.h                  |   69 +
 .../rdma/hfi1 =3D> infiniband/sw/rdmavt}/srq.c       |  204 +-
 drivers/infiniband/sw/rdmavt/srq.h                 |   62 +
 drivers/infiniband/sw/rdmavt/trace.c               |   49 +
 drivers/infiniband/sw/rdmavt/trace.h               |  187 +
 drivers/infiniband/sw/rdmavt/vt.c                  |  873 ++++
 drivers/infiniband/sw/rdmavt/vt.h                  |  104 +
 drivers/infiniband/ulp/ipoib/ipoib.h               |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   27 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   65 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/net/ethernet/intel/i40e/Makefile           |    1 +
 drivers/net/ethernet/intel/i40e/i40e.h             |   22 +
 drivers/net/ethernet/intel/i40e/i40e_client.c      | 1012 +++++
 drivers/net/ethernet/intel/i40e/i40e_client.h      |  232 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  115 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |    3 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl.h    |   34 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  247 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   57 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   72 +-
 drivers/staging/rdma/hfi1/Kconfig                  |   13 +-
 drivers/staging/rdma/hfi1/Makefile                 |   10 +-
 drivers/staging/rdma/hfi1/affinity.c               |  430 ++
 drivers/staging/rdma/hfi1/affinity.h               |   91 +
 drivers/staging/rdma/hfi1/aspm.h                   |  309 ++
 drivers/staging/rdma/hfi1/chip.c                   | 2457 +++++-----
 drivers/staging/rdma/hfi1/chip.h                   |  151 +-
 drivers/staging/rdma/hfi1/chip_registers.h         |   20 +-
 drivers/staging/rdma/hfi1/common.h                 |   12 +-
 drivers/staging/rdma/hfi1/debugfs.c                |  332 +-
 drivers/staging/rdma/hfi1/debugfs.h                |    5 +-
 drivers/staging/rdma/hfi1/device.c                 |    5 +-
 drivers/staging/rdma/hfi1/device.h                 |    5 +-
 drivers/staging/rdma/hfi1/diag.c                   |  103 +-
 drivers/staging/rdma/hfi1/dma.c                    |   17 +-
 drivers/staging/rdma/hfi1/driver.c                 |  346 +-
 drivers/staging/rdma/hfi1/efivar.c                 |    8 +-
 drivers/staging/rdma/hfi1/efivar.h                 |    5 +-
 drivers/staging/rdma/hfi1/eprom.c                  |  117 +-
 drivers/staging/rdma/hfi1/eprom.h                  |    7 +-
 drivers/staging/rdma/hfi1/file_ops.c               |  552 +--
 drivers/staging/rdma/hfi1/firmware.c               |  587 ++-
 drivers/staging/rdma/hfi1/hfi.h                    |  259 +-
 drivers/staging/rdma/hfi1/init.c                   |  183 +-
 drivers/staging/rdma/hfi1/intr.c                   |   29 +-
 drivers/staging/rdma/hfi1/iowait.h                 |  126 +-
 drivers/staging/rdma/hfi1/keys.c                   |  356 --
 drivers/staging/rdma/hfi1/mad.c                    | 1048 +++--
 drivers/staging/rdma/hfi1/mad.h                    |   14 +-
 drivers/staging/rdma/hfi1/mmu_rb.c                 |  292 ++
 drivers/staging/rdma/hfi1/mmu_rb.h                 |   73 +
 drivers/staging/rdma/hfi1/mr.c                     |  473 --
 drivers/staging/rdma/hfi1/opa_compat.h             |   20 +-
 drivers/staging/rdma/hfi1/pcie.c                   |  276 +-
 drivers/staging/rdma/hfi1/pio.c                    |  365 +-
 drivers/staging/rdma/hfi1/pio.h                    |  118 +-
 drivers/staging/rdma/hfi1/pio_copy.c               |   67 +-
 drivers/staging/rdma/hfi1/platform.c               |  893 ++++
 .../rdma/hfi1/{platform_config.h =3D> platform.h}    |   58 +-
 drivers/staging/rdma/hfi1/qp.c                     | 1642 ++-----
 drivers/staging/rdma/hfi1/qp.h                     |  198 +-
 drivers/staging/rdma/hfi1/qsfp.c                   |  270 +-
 drivers/staging/rdma/hfi1/qsfp.h                   |   57 +-
 drivers/staging/rdma/hfi1/rc.c                     |  765 ++--
 drivers/staging/rdma/hfi1/ruc.c                    |  373 +-
 drivers/staging/rdma/hfi1/sdma.c                   |  365 +-
 drivers/staging/rdma/hfi1/sdma.h                   |  116 +-
 drivers/staging/rdma/hfi1/sdma_txreq.h             |  135 +
 drivers/staging/rdma/hfi1/sysfs.c                  |  136 +-
 drivers/staging/rdma/hfi1/trace.c                  |   53 +-
 drivers/staging/rdma/hfi1/trace.h                  | 1477 +++---
 drivers/staging/rdma/hfi1/twsi.c                   |  205 +-
 drivers/staging/rdma/hfi1/twsi.h                   |    9 +-
 drivers/staging/rdma/hfi1/uc.c                     |  164 +-
 drivers/staging/rdma/hfi1/ud.c                     |  250 +-
 drivers/staging/rdma/hfi1/user_exp_rcv.c           | 1044 +++++
 drivers/staging/rdma/hfi1/user_exp_rcv.h           |   13 +-
 drivers/staging/rdma/hfi1/user_pages.c             |   74 +-
 drivers/staging/rdma/hfi1/user_sdma.c              |  621 +--
 drivers/staging/rdma/hfi1/user_sdma.h              |   11 +-
 drivers/staging/rdma/hfi1/verbs.c                  | 1667 +++----
 drivers/staging/rdma/hfi1/verbs.h                  |  824 +---
 drivers/staging/rdma/hfi1/verbs_txreq.c            |  149 +
 drivers/staging/rdma/hfi1/verbs_txreq.h            |  116 +
 include/linux/mlx5/device.h                        |    6 +
 include/linux/mlx5/driver.h                        |    8 +-
 include/linux/mlx5/mlx5_ifc.h                      |   37 +-
 include/linux/mlx5/vport.h                         |    7 +-
 include/linux/netdevice.h                          |    3 +
 include/rdma/ib_verbs.h                            |   29 +-
 include/rdma/opa_port_info.h                       |    2 +-
 include/rdma/rdma_vt.h                             |  481 ++
 include/rdma/rdmavt_cq.h                           |   99 +
 include/rdma/rdmavt_mr.h                           |  139 +
 include/rdma/rdmavt_qp.h                           |  446 ++
 include/uapi/linux/if_link.h                       |    7 +
 include/uapi/rdma/hfi/hfi1_user.h                  |   14 +-
 include/uapi/rdma/rdma_netlink.h                   |    1 +
 net/core/rtnetlink.c                               |   36 +
 192 files changed, 49197 insertions(+), 15248 deletions(-)
 create mode 100644 drivers/infiniband/hw/i40iw/Kconfig
 create mode 100644 drivers/infiniband/hw/i40iw/Makefile
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_cm.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_cm.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_ctrl.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_d.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_hmc.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_hmc.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_hw.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_main.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_osdep.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_p.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_pble.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_pble.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_puda.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_puda.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_register.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_status.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_type.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_ucontext.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_uk.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_user.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_utils.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_verbs.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_verbs.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_vf.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_vf.h
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
 create mode 100644 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h
 create mode 100644 drivers/infiniband/hw/mlx5/ib_virt.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_cq.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_mmap.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_mr.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_srq.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_verbs_mcast.c
 create mode 100644 drivers/infiniband/sw/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/Kconfig
 create mode 100644 drivers/infiniband/sw/rdmavt/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/ah.c
 create mode 100644 drivers/infiniband/sw/rdmavt/ah.h
 rename drivers/{staging/rdma/hfi1 =3D> infiniband/sw/rdmavt}/cq.c (72%)
 create mode 100644 drivers/infiniband/sw/rdmavt/cq.h
 create mode 100644 drivers/infiniband/sw/rdmavt/dma.c
 create mode 100644 drivers/infiniband/sw/rdmavt/dma.h
 create mode 100644 drivers/infiniband/sw/rdmavt/mad.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mad.h
 rename drivers/{staging/rdma/hfi1/verbs_mcast.c =3D>
infiniband/sw/rdmavt/mcast.c} (58%)
 create mode 100644 drivers/infiniband/sw/rdmavt/mcast.h
 rename drivers/{staging/rdma/hfi1 =3D> infiniband/sw/rdmavt}/mmap.c (55%=
)
 create mode 100644 drivers/infiniband/sw/rdmavt/mmap.h
 create mode 100644 drivers/infiniband/sw/rdmavt/mr.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mr.h
 create mode 100644 drivers/infiniband/sw/rdmavt/pd.c
 create mode 100644 drivers/infiniband/sw/rdmavt/pd.h
 create mode 100644 drivers/infiniband/sw/rdmavt/qp.c
 create mode 100644 drivers/infiniband/sw/rdmavt/qp.h
 rename drivers/{staging/rdma/hfi1 =3D> infiniband/sw/rdmavt}/srq.c (64%)=

 create mode 100644 drivers/infiniband/sw/rdmavt/srq.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace.c
 create mode 100644 drivers/infiniband/sw/rdmavt/trace.h
 create mode 100644 drivers/infiniband/sw/rdmavt/vt.c
 create mode 100644 drivers/infiniband/sw/rdmavt/vt.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_client.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_client.h
 create mode 100644 drivers/staging/rdma/hfi1/affinity.c
 create mode 100644 drivers/staging/rdma/hfi1/affinity.h
 create mode 100644 drivers/staging/rdma/hfi1/aspm.h
 delete mode 100644 drivers/staging/rdma/hfi1/keys.c
 create mode 100644 drivers/staging/rdma/hfi1/mmu_rb.c
 create mode 100644 drivers/staging/rdma/hfi1/mmu_rb.h
 delete mode 100644 drivers/staging/rdma/hfi1/mr.c
 create mode 100644 drivers/staging/rdma/hfi1/platform.c
 rename drivers/staging/rdma/hfi1/{platform_config.h =3D> platform.h} (89=
%)
 create mode 100644 drivers/staging/rdma/hfi1/sdma_txreq.h
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c
 create mode 100644 drivers/staging/rdma/hfi1/verbs_txreq.c
 create mode 100644 drivers/staging/rdma/hfi1/verbs_txreq.h
 create mode 100644 include/rdma/rdma_vt.h
 create mode 100644 include/rdma/rdmavt_cq.h
 create mode 100644 include/rdma/rdmavt_mr.h
 create mode 100644 include/rdma/rdmavt_qp.h


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nqL5MsKglWGXoxXxuj4pjxISSJ5lm6FR5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW8bAXAAoJELgmozMOVy/dzN4QAKfodeUpB+YsITlomaLnVhTA
sGUiuRoo5mW/qsi8D5tnd9rUXZfBLGHVQzCt05Z4smbtOCPkHYQa/96xZvK4tb2f
uQB3dSIBbCNaTYbQtwLGRMDop/cKjKmN8uGZtATGL9CmdbShbCnQFySQJj1Kl/Rd
aI489Qi3eEj/Flf/TojivhPe9ygyqMhjphzF2OQ4lU/aZu6o7SExTD4jEVaVYL/G
2xWlV9B6SP9/0lrwN7DzajuN2tPn9vsIJ0ChttNpE5xq3zw+IcUXaai5cNeyu4co
0S4VBYedyTUHvdWYjo2YETJ8+ZT0zZjsVMQnhZMUfJzoaq22p5Xgl3VjL2Zrd4FT
wj8FILWMSXsYU5jvUKdUuAA9d8P0wKP88UE1KS8yh8QD+Dk44gDmHryvQUcToofn
5J6x9+x7uKjdGNke9UqPUOl0BVo0nfrZE0/CVZ4OWj0WzHAkvFeNFzSgDY3l5lyy
QWOWL08PTzQgpUvbiAtmv9r3F+aZO2X303fEI8KN/n5N5LvAQw2RSgrlOGY5P+1g
k3CH02omUhiZPb4e0DJ26A6qu28s4hBovGNEguNa6UaFn9ypJxeeQCzUdrCEIB0I
vVZLY+usT0cOGYyGywO5+znB4hIxiHJ+LPhxaZmkll1lHl+6oQmOP8icm30/zf/e
4YGR8ausSFhjjB/hYOlr
=HyJl
-----END PGP SIGNATURE-----

--nqL5MsKglWGXoxXxuj4pjxISSJ5lm6FR5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
