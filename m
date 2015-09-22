From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 00/32] Soft-RoCE driver
Date: Tue, 22 Sep 2015 10:30:43 +0300
Message-ID: <1442907075-13228-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug and list Hi,

This patchset introduces Soft RoCE driver.

Some background on the driver: The original Soft-RoCE driver was implemented by
Bob Pearson from SFW. Bob started the submission process [3], but his work was
abandoned after v2.
Mellanox decided to pick it up and continue the submission. As part of the
process we detected some problems with the original implementation. Mainly, we
wanted to RoCEv2, also, there are too many locks and 
context switches in the data path. Most of them are already removed.

We've located the driver in the staging subtree. This follows a requirement
to implement an IB transport library - Soft RoCE is in the same boat like the hfi1 
driver. We need to define and implement a lib to prevent those code 
duplications. 

We did address the feedback provided on the original submission.

Another issue is, that this code is based on RoCEv2 patchesets.

So why not wait and submit it when the RoCEv2 IB core bits are upstream?

The main reason we want to submit it now, and not to wait is: "Submit early".  
We understand that 4 years after v2 is not exactly early. But we started few
months ago to work on it, and did some heavy modifications to the code and the
design, and we would like this work to be done under the eye of the community
and not in house (although this work was done @ github [4]). 

Soft-RoCE is sitting on top of Matan's 3 patchsets for gid cache and RoCEv2.
The first [1] is in, the second [2] and third [5] were posted already.

RXE user space (librxe) is located at github [6] with instructions how to use
it [7]

Some notes on the architecture and design:

ib_rxe, implements the RDMA transport and registers with the RDMA core as a
kernel verbs provider. It also implements the packet IO layer. ib_rxe attaches
to the Linux netdev stack as a udp encapsulating protocol and can send and
receive packets over any Ethernet device. It uses the RoCEv2 protocol to handle
RDMA transport. 

The modules are configured by entries in /sys. There is a configuration script
(rxe_cfg) that simplifies the use of this interface. rxe_cfg is part of the
rxe user space code, librxe.

The use of rxe verbs in user space requires the inclusion of librxe as a device
specific plug-in to libibverbs. librxe is packaged separately [6].

Copies of the user space library and tools for 'upstream' and a clone of Doug's tree with 
these patches applied are available at github [4]

Architecture:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

     +-----------------------------------------------------------+
     |                          Application                      |
     +-----------------------------------------------------------+
                             +-----------------------------------+
			                 |             libibverbs            |
User			             +-----------------------------------+
			     			 +----------------+ +----------------+
			     			 | librxe         | | HW RoCE lib    |
			     			 +----------------+ +----------------+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     +--------------+                           +------------+
     | Sockets      |                           | RDMA ULP   |
     +--------------+                           +------------+
     +--------------+                  +---------------------+
     | TCP/IP       |                  | ib_core             |
     +--------------+                  +---------------------+
                             +------------+ +----------------+
Kernel			             | ib_rxe     | | HW RoCE driver |			     
                             +------------+ +----------------+
     +------------------------------------+
     | NIC driver                         |
     +------------------------------------+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The driver components and a non asci chart of the module could be found at a
pdf [8] presented by Bob before the original submission.
The design is very similar, one thing that was changed, is the arbiter task
that was removed. This reduced the number of context switches and locks during
the data path.

A TODO file is placed under the driver folder.

Thanks,
Kamal, Liran and Amir

[1] - http://www.spinics.net/lists/netdev/msg337683.html
[2] - http://www.spinics.net/lists/linux-rdma/msg28031.html
[3] - http://www.spinics.net/lists/linux-rdma/msg08936.html
[4] - https://github.com/SoftRoCE
[5] - http://www.spinics.net/lists/linux-rdma/msg28120.html
[6] - https://github.com/SoftRoCE/librxe-dev
[7] - https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
[8] - http://downloads.openfabrics.org/Media/Sonoma2010/Sonoma_2010_Wednesday_rxe.pdf

Changes from V0:
- rebased to 4.3-rc1
- IPv4 based sessions work
- Fixed the link speed and width we report to the query port verb
- Update the TODO file with Sagi's request

Amir Vadai (3):
  IB/core: Macro for RoCEv2 UDP port
  IB/rxe: Shared objects between user and kernel
  IB/rxe: TODO file while in staging

Kamal Heib (29):
  IB/core: Add SEND_LAST_INV and SEND_ONLY_INV opcodes
  IB/rxe: IBA header types and methods
  IB/rxe: Bit mask and lengths declaration for different opcodes
  IB/rxe: Default rxe device and port parameters
  IB/rxe: External interface to lower level modules
  IB/rxe: Misc local interfaces between files in ib_rxe
  IB/rxe: Add maintainer for rxe driver
  IB/rxe: Work request's opcode information table
  IB/rxe: User/kernel shared queues infrastructure
  IB/rxe: Common user/kernel queue implementation
  IB/rxe: Interface to ib_core
  IB/rxe: Allocation pool for RDMA objects
  IB/rxe: RXE tasks handling
  IB/rxe: Address vector manipulation functions
  IB/rxe: Shared Receive Queue (SRQ) manipulation functions
  IB/rxe: Completion Queue (CQ) manipulation functions
  IB/rxe: Queue Pair (QP) handling
  IB/rxe: Memory Region (MR) handling
  IB/rxe: Multicast implementation
  IB/rxe: Received packets handling
  IB/rxe: Completion handling
  IB/rxe: QP request handling
  IB/rxe: QP response handling
  IB/rxe: Dummy DMA callbacks for RXE device
  IB/rxe: ICRC calculations
  IB/rxe: Module init hooks
  IB/rxe: Interface to netdev stack
  IB/rxe: sysfs interface to RXE
  IB/rxe: Add Soft-RoCE to kbuild and makefiles

 MAINTAINERS                      |    9 +
 drivers/staging/Kconfig          |    2 +
 drivers/staging/Makefile         |    1 +
 drivers/staging/rxe/Kconfig      |   23 +
 drivers/staging/rxe/Makefile     |   24 +
 drivers/staging/rxe/TODO         |   18 +
 drivers/staging/rxe/rxe.c        |  436 ++++++++++++
 drivers/staging/rxe/rxe.h        |   72 ++
 drivers/staging/rxe/rxe_av.c     |   87 +++
 drivers/staging/rxe/rxe_comp.c   |  728 +++++++++++++++++++
 drivers/staging/rxe/rxe_cq.c     |  165 +++++
 drivers/staging/rxe/rxe_dma.c    |  166 +++++
 drivers/staging/rxe/rxe_hdr.h    |  950 +++++++++++++++++++++++++
 drivers/staging/rxe/rxe_icrc.c   |   96 +++
 drivers/staging/rxe/rxe_loc.h    |  291 ++++++++
 drivers/staging/rxe/rxe_mcast.c  |  190 +++++
 drivers/staging/rxe/rxe_mmap.c   |  173 +++++
 drivers/staging/rxe/rxe_mr.c     |  764 ++++++++++++++++++++
 drivers/staging/rxe/rxe_net.c    |  729 +++++++++++++++++++
 drivers/staging/rxe/rxe_net.h    |   78 ++
 drivers/staging/rxe/rxe_opcode.c |  961 +++++++++++++++++++++++++
 drivers/staging/rxe/rxe_opcode.h |  128 ++++
 drivers/staging/rxe/rxe_param.h  |  177 +++++
 drivers/staging/rxe/rxe_pool.c   |  511 +++++++++++++
 drivers/staging/rxe/rxe_pool.h   |  161 +++++
 drivers/staging/rxe/rxe_qp.c     |  835 ++++++++++++++++++++++
 drivers/staging/rxe/rxe_queue.c  |  217 ++++++
 drivers/staging/rxe/rxe_queue.h  |  178 +++++
 drivers/staging/rxe/rxe_recv.c   |  371 ++++++++++
 drivers/staging/rxe/rxe_req.c    |  679 ++++++++++++++++++
 drivers/staging/rxe/rxe_resp.c   | 1368 +++++++++++++++++++++++++++++++++++
 drivers/staging/rxe/rxe_srq.c    |  195 +++++
 drivers/staging/rxe/rxe_sysfs.c  |  168 +++++
 drivers/staging/rxe/rxe_task.c   |  154 ++++
 drivers/staging/rxe/rxe_task.h   |   95 +++
 drivers/staging/rxe/rxe_verbs.c  | 1461 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/rxe/rxe_verbs.h  |  497 +++++++++++++
 include/rdma/ib_pack.h           |    4 +
 include/rdma/ib_verbs.h          |    2 +
 include/uapi/rdma/Kbuild         |    1 +
 include/uapi/rdma/ib_rxe.h       |  139 ++++
 41 files changed, 13304 insertions(+)
 create mode 100644 drivers/staging/rxe/Kconfig
 create mode 100644 drivers/staging/rxe/Makefile
 create mode 100644 drivers/staging/rxe/TODO
 create mode 100644 drivers/staging/rxe/rxe.c
 create mode 100644 drivers/staging/rxe/rxe.h
 create mode 100644 drivers/staging/rxe/rxe_av.c
 create mode 100644 drivers/staging/rxe/rxe_comp.c
 create mode 100644 drivers/staging/rxe/rxe_cq.c
 create mode 100644 drivers/staging/rxe/rxe_dma.c
 create mode 100644 drivers/staging/rxe/rxe_hdr.h
 create mode 100644 drivers/staging/rxe/rxe_icrc.c
 create mode 100644 drivers/staging/rxe/rxe_loc.h
 create mode 100644 drivers/staging/rxe/rxe_mcast.c
 create mode 100644 drivers/staging/rxe/rxe_mmap.c
 create mode 100644 drivers/staging/rxe/rxe_mr.c
 create mode 100644 drivers/staging/rxe/rxe_net.c
 create mode 100644 drivers/staging/rxe/rxe_net.h
 create mode 100644 drivers/staging/rxe/rxe_opcode.c
 create mode 100644 drivers/staging/rxe/rxe_opcode.h
 create mode 100644 drivers/staging/rxe/rxe_param.h
 create mode 100644 drivers/staging/rxe/rxe_pool.c
 create mode 100644 drivers/staging/rxe/rxe_pool.h
 create mode 100644 drivers/staging/rxe/rxe_qp.c
 create mode 100644 drivers/staging/rxe/rxe_queue.c
 create mode 100644 drivers/staging/rxe/rxe_queue.h
 create mode 100644 drivers/staging/rxe/rxe_recv.c
 create mode 100644 drivers/staging/rxe/rxe_req.c
 create mode 100644 drivers/staging/rxe/rxe_resp.c
 create mode 100644 drivers/staging/rxe/rxe_srq.c
 create mode 100644 drivers/staging/rxe/rxe_sysfs.c
 create mode 100644 drivers/staging/rxe/rxe_task.c
 create mode 100644 drivers/staging/rxe/rxe_task.h
 create mode 100644 drivers/staging/rxe/rxe_verbs.c
 create mode 100644 drivers/staging/rxe/rxe_verbs.h
 create mode 100644 include/uapi/rdma/ib_rxe.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
