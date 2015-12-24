From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V2 00/32] Soft-RoCE driver
Date: Thu, 24 Dec 2015 11:17:46 +0200
Message-ID: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug and list Hi,

This patchset introduces Soft RoCE driver.

Some background on the driver: The original Soft-RoCE driver was implemented by
Bob Pearson from SFW. Bob started the submission process [1], but his work was
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

Soft-RoCE is sitting on top of Matan's RoCEv2 series [2] which was taken
to 4.5 and present Doug's k.o/for-4.5 branch.

RXE user space (librxe) is located at github [4] with instructions how to use
it [5]

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
specific plug-in to libibverbs. librxe is packaged separately [4].

Copies of the user space library and tools for 'upstream' and a clone of Doug's tree with
these patches applied are available at github [3] under rxe_submission-v2 branch

Architecture:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

     +-----------------------------------------------------------+
     |                          Application                      |
     +-----------------------------------------------------------+
                             +-----------------------------------+
                             |             libibverbs            |
User                         +-----------------------------------+
                             +----------------+ +----------------+
                             | librxe         | | HW RoCE lib    |
                             +----------------+ +----------------+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     +--------------+                           +------------+
     | Sockets      |                           | RDMA ULP   |
     +--------------+                           +------------+
     +--------------+                  +---------------------+
     | TCP/IP       |                  | ib_core             |
     +--------------+                  +---------------------+
                             +------------+ +----------------+
Kernel                       | ib_rxe     | | HW RoCE driver |
                             +------------+ +----------------+
     +------------------------------------+
     | NIC driver                         |
     +------------------------------------+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The driver components and a non asci chart of the module could be found at a
pdf [6] presented by Bob before the original submission.
The design is very similar, one thing that was changed, is the arbiter task
that was removed. This reduced the number of context switches and locks during
the data path.

A TODO file is placed under the driver folder.

Thanks,
Kamal, Liran and Amir

[1] - http://www.spinics.net/lists/linux-rdma/msg08936.html
[2] - http://marc.info/?l=linux-rdma&m=145087562709661&w=2
[3] - https://github.com/SoftRoCE/rxe-dev
[4] - https://github.com/SoftRoCE/librxe-dev
[5] - https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
[6] - http://downloads.openfabrics.org/Media/Sonoma2010/Sonoma_2010_Wednesday_rxe.pdf

Changes from V0:
- Rebased to 4.3-rc1
- IPv4 based sessions work
- Fixed the link speed and width we report to the query port verb
- Update the TODO file with Sagi's request

Changes from V1:
- Rebased to 4.4.0-rc6 and to Doug's k.o/for-4.5 github branch 
- Move driver to be under "drivers/staging/rdma/"

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

 MAINTAINERS                           |    9 +
 drivers/staging/rdma/Kconfig          |    2 +
 drivers/staging/rdma/Makefile         |    1 +
 drivers/staging/rdma/rxe/Kconfig      |   23 +
 drivers/staging/rdma/rxe/Makefile     |   24 +
 drivers/staging/rdma/rxe/TODO         |   18 +
 drivers/staging/rdma/rxe/rxe.c        |  436 ++++++++++
 drivers/staging/rdma/rxe/rxe.h        |   72 ++
 drivers/staging/rdma/rxe/rxe_av.c     |   87 ++
 drivers/staging/rdma/rxe/rxe_comp.c   |  728 +++++++++++++++++
 drivers/staging/rdma/rxe/rxe_cq.c     |  165 ++++
 drivers/staging/rdma/rxe/rxe_dma.c    |  166 ++++
 drivers/staging/rdma/rxe/rxe_hdr.h    |  950 ++++++++++++++++++++++
 drivers/staging/rdma/rxe/rxe_icrc.c   |   96 +++
 drivers/staging/rdma/rxe/rxe_loc.h    |  291 +++++++
 drivers/staging/rdma/rxe/rxe_mcast.c  |  190 +++++
 drivers/staging/rdma/rxe/rxe_mmap.c   |  173 ++++
 drivers/staging/rdma/rxe/rxe_mr.c     |  764 ++++++++++++++++++
 drivers/staging/rdma/rxe/rxe_net.c    |  729 +++++++++++++++++
 drivers/staging/rdma/rxe/rxe_net.h    |   78 ++
 drivers/staging/rdma/rxe/rxe_opcode.c |  961 ++++++++++++++++++++++
 drivers/staging/rdma/rxe/rxe_opcode.h |  128 +++
 drivers/staging/rdma/rxe/rxe_param.h  |  177 ++++
 drivers/staging/rdma/rxe/rxe_pool.c   |  511 ++++++++++++
 drivers/staging/rdma/rxe/rxe_pool.h   |  161 ++++
 drivers/staging/rdma/rxe/rxe_qp.c     |  835 +++++++++++++++++++
 drivers/staging/rdma/rxe/rxe_queue.c  |  217 +++++
 drivers/staging/rdma/rxe/rxe_queue.h  |  178 +++++
 drivers/staging/rdma/rxe/rxe_recv.c   |  371 +++++++++
 drivers/staging/rdma/rxe/rxe_req.c    |  679 ++++++++++++++++
 drivers/staging/rdma/rxe/rxe_resp.c   | 1368 +++++++++++++++++++++++++++++++
 drivers/staging/rdma/rxe/rxe_srq.c    |  195 +++++
 drivers/staging/rdma/rxe/rxe_sysfs.c  |  168 ++++
 drivers/staging/rdma/rxe/rxe_task.c   |  154 ++++
 drivers/staging/rdma/rxe/rxe_task.h   |   95 +++
 drivers/staging/rdma/rxe/rxe_verbs.c  | 1423 +++++++++++++++++++++++++++++++++
 drivers/staging/rdma/rxe/rxe_verbs.h  |  486 +++++++++++
 include/rdma/ib_pack.h                |    4 +
 include/rdma/ib_verbs.h               |    2 +
 include/uapi/rdma/Kbuild              |    1 +
 include/uapi/rdma/ib_rxe.h            |  139 ++++
 41 files changed, 13255 insertions(+)
 create mode 100644 drivers/staging/rdma/rxe/Kconfig
 create mode 100644 drivers/staging/rdma/rxe/Makefile
 create mode 100644 drivers/staging/rdma/rxe/TODO
 create mode 100644 drivers/staging/rdma/rxe/rxe.c
 create mode 100644 drivers/staging/rdma/rxe/rxe.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_av.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_comp.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_cq.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_dma.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_hdr.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_icrc.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_loc.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_mcast.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_mmap.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_mr.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_net.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_net.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_opcode.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_opcode.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_param.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_pool.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_pool.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_qp.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_queue.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_queue.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_recv.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_req.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_resp.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_srq.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_sysfs.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_task.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_task.h
 create mode 100644 drivers/staging/rdma/rxe/rxe_verbs.c
 create mode 100644 drivers/staging/rdma/rxe/rxe_verbs.h
 create mode 100644 include/uapi/rdma/ib_rxe.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
