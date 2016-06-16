From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 rdma-next 00/29] Soft RoCE driver
Date: Thu, 16 Jun 2016 16:45:22 +0300
Message-ID: <1466084751-29901-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug

Soft RoCE (RXE) - The software RoCE driver

ib_rxe implements the RDMA transport and registers to the RDMA core device as a
kernel verbs provider. It also implements the packet IO layer. On the other hand
ib_rxe registers to the Linux netdev stack as a udp encapsulating protocol, in
that case RDMA, for sending and receiving packets over any Ethernet device.
This yields a RDMA transport over the UDP/Ethernet network layer forming a RoCEv2
compatible device.

The configuration procedure of the Soft RoCE drivers requires binding to any existing
Ethernet network device. This is done with /sys interface.

A userspace Soft RoCE library (librxe) provides user applications the ability to run
with Soft RoCE devices.  The use of rxe verbs in user space requires the inclusion of
librxe as a device specific plug-in to libibverbs. librxe is packaged separately.

Architecture:


     +-----------------------------------------------------------+
     |                          Application                      |
     +-----------------------------------------------------------+
                            +-----------------------------------+
                            |             libibverbs            |
User                        +-----------------------------------+
                            +----------------+ +----------------+
                            | librxe         | | HW RoCE lib    |
                            +----------------+ +----------------+
+---------------------------------------------------------------+
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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     +-----------------------------------------------------------+
     |                          Application                      |
     +-----------------------------------------------------------+
                            +-----------------------------------+
                            |             libibverbs            |
User                        +-----------------------------------+
                            +----------------+ +----------------+
                            | librxe         | | HW RoCE lib    |
                            +----------------+ +----------------+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Soft RoCE was previously pushed to drivers/infiniband/staging and now, after cleanups
and bug fixes is pushed to the hardware provides section in the RDMA stack.

Soft RoCE resources:

[1[ https://github.com/SoftRoCE/librxe-dev librxe - source code in Github
[2] https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home - Soft RoCE Wiki page
[3] https://github.com/SoftRoCE/librxe-dev - Soft RoCE userspace library

Changes from V1
===============================================================================
- Rebase to kernel 4.7-rc2
- Fix error code in rxe_srq_from_init() (from Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>)
- Fix 32-bit build warnings (from Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)
- Add UDP_TUNNEL dependency (from Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)
- Avoid 64-bit division (from Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)
- Changed deprecated module_param_call() to module_param_cb()
- Add description to module params 'add' and 'remove'
- Hold list of RXE devices in list instead of array
- Fix race when received before wqe state update
- Add prefix "rxe" to memory cache names
- Rename ib_rxe.h to ib_user_rxe.h (comes with same change in librxe).
- Fix copyright date issue

Note: The FMR interface is left in until the fast memory registration interface
will be added so iSER can still work with Soft RoCE.

Note
Moni Shoua (29):
  IB/rxe: IBA header types and methods
  IB/rxe: Bit mask and lengths declaration for different opcodes
  IB/rxe: Default rxe device and port parameters
  IB/rxe: External interface to lower level modules
  IB/rxe: Misc local interfaces between files
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
  IB/rxe: Memory Region (MR) manioulation
  IB/rxe: Add multicast infrastructure
  IB/rxe: Received packets handling
  IB/rxe: Completion handling
  IB/rxe: QP request handling
  IB/rxe: QP response handling
  IB/rxe: Dummy DMA callbacks for RXE device
  IB/rxe: Invariant CRC implementation
  IB/rxe: Module init hooks
  IB/rxe: Interface to netdev stack
  IB/rxe: sysfs interface to RXE
  IB/rxe: Shared objects between user and kernel
  IB/rxe: Add Soft-RoCE to kbuild and makefiles

 MAINTAINERS                            |    9 +
 drivers/infiniband/Kconfig             |    1 +
 drivers/infiniband/hw/Makefile         |    1 +
 drivers/infiniband/hw/rxe/Kconfig      |   24 +
 drivers/infiniband/hw/rxe/Makefile     |   24 +
 drivers/infiniband/hw/rxe/rxe.c        |  411 ++++++++++
 drivers/infiniband/hw/rxe/rxe.h        |   77 ++
 drivers/infiniband/hw/rxe/rxe_av.c     |   98 +++
 drivers/infiniband/hw/rxe/rxe_comp.c   |  734 +++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_cq.c     |  165 ++++
 drivers/infiniband/hw/rxe/rxe_dma.c    |  166 ++++
 drivers/infiniband/hw/rxe/rxe_hdr.h    |  952 ++++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_icrc.c   |   96 +++
 drivers/infiniband/hw/rxe/rxe_loc.h    |  289 +++++++
 drivers/infiniband/hw/rxe/rxe_mcast.c  |  190 +++++
 drivers/infiniband/hw/rxe/rxe_mmap.c   |  173 ++++
 drivers/infiniband/hw/rxe/rxe_mr.c     |  679 ++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_net.c    |  708 +++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_net.h    |   53 ++
 drivers/infiniband/hw/rxe/rxe_opcode.c |  961 ++++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_opcode.h |  128 +++
 drivers/infiniband/hw/rxe/rxe_param.h  |  173 ++++
 drivers/infiniband/hw/rxe/rxe_pool.c   |  510 ++++++++++++
 drivers/infiniband/hw/rxe/rxe_pool.h   |  164 ++++
 drivers/infiniband/hw/rxe/rxe_qp.c     |  851 ++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_queue.c  |  217 +++++
 drivers/infiniband/hw/rxe/rxe_queue.h  |  178 +++++
 drivers/infiniband/hw/rxe/rxe_recv.c   |  420 ++++++++++
 drivers/infiniband/hw/rxe/rxe_req.c    |  692 ++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_resp.c   | 1364 ++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_srq.c    |  193 +++++
 drivers/infiniband/hw/rxe/rxe_sysfs.c  |  157 ++++
 drivers/infiniband/hw/rxe/rxe_task.c   |  154 ++++
 drivers/infiniband/hw/rxe/rxe_task.h   |   95 +++
 drivers/infiniband/hw/rxe/rxe_verbs.c  | 1352 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_verbs.h  |  486 ++++++++++++
 include/uapi/rdma/Kbuild               |    1 +
 include/uapi/rdma/ib_user_rxe.h        |  139 ++++
 38 files changed, 13085 insertions(+)
 create mode 100644 drivers/infiniband/hw/rxe/Kconfig
 create mode 100644 drivers/infiniband/hw/rxe/Makefile
 create mode 100644 drivers/infiniband/hw/rxe/rxe.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_av.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_comp.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_cq.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_dma.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_hdr.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_icrc.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_loc.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_mcast.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_mmap.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_mr.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_net.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_net.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_opcode.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_opcode.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_param.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_pool.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_pool.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_qp.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_queue.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_queue.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_recv.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_req.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_resp.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_srq.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_sysfs.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_task.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_task.h
 create mode 100644 drivers/infiniband/hw/rxe/rxe_verbs.c
 create mode 100644 drivers/infiniband/hw/rxe/rxe_verbs.h
 create mode 100644 include/uapi/rdma/ib_user_rxe.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
