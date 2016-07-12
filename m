From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/15] Add Paravirtual RDMA Driver
Date: Tue, 12 Jul 2016 12:36:30 -0700
Message-ID: <1468352205-9137-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug, others,

This patch series adds a driver for a paravirtual RDMA device. The device
is developed for VMware's Virtual Machines and allows existing RDMA
applications to continue to use existing Verbs API when deployed in VMs on
ESX. We recently did a presentation in the OFA Workshop regarding this
device. See - https://goo.gl/pHOXJ8 for our workshop presentation. Note,
that this patch series should be applied all together. I split out the
commits so that it may be easier to review.

Description and RDMA Support
-------------------------------
The virtual device is exposed as a dual function PCIe device. One part is
a virtual network device (VMXNet3) which provides networking properties
like MAC, IP addresses to the RDMA part of the device. The networking
properties are used to register GIDs required by RDMA applications to
communicate.

These patches add support and the all required infrastructure for letting
applications use such a device. We support the mandatory Verbs API as well
as the base memory management extensions (Local Inv, Send with Inv and Fast
Register Work Requests). We currently support both Reliable Connected and
Unreliable Datagram QPs but do not support Shared Receive Queues (SRQs).
Also, we support the following types of Work Requests:
 o Send/Receive (with or without Immediate Data)
 o RDMA Write (with or without Immediate Data)
 o RDMA Read
 o Local Invalidate
 o Send with Invalidate
 o Fast Register Work Requests

This version only adds support for version 1 of RoCE. We will add RoCEv2
support in a future patch. We do support registration of both MAC-based and
IP-based GIDs. 

I have also created a git tree for our user-level driver here:
http://git.openfabrics.org/?p=~aditr/libpvrdma.git;a=summary

Testing
--------
We have tested this internally for various types of Guest OS - Red Hat,
Centos, Ubuntu 12.04/14.04/16.04, Oracle Enterprise Linux, SLES 12
using backported versions of this driver. The tests included several runs
of the performance tests (included with OFED), Intel MPI PingPong benchmark
on OpenMPI, krping for FRWRs. Mellanox has been kind enough to test the
backported version of the driver internally on their hardware using a
VMware provided ESX build. I have also applied and tested this with Doug's
master, k.o/for-4.7, k.o/for-4.8 branches.

Changes v1 -> v2: 
 Patch [07/15] - Addressed Yuval Shaia's comments and 32-bit build errors.

---

Adit Ranadive (15):
  IB/pvrdma: Add paravirtual rdma device
  IB/pvrdma: Add device command support
  IB/pvrdma: Add support for Completion Queues
  IB/pvrdma: Add the paravirtual RDMA device specification
  IB/pvrdma: Add UAR support
  IB/pvrdma: Add virtual device RDMA structures
  IB/pvrdma: Add the main driver module for PVRDMA
  IB/pvrdma: Add helper functions
  IB/pvrdma: Add support for memory regions
  IB/pvrdma: Add Queue Pair support
  IB/pvrdma: Add user-level shared functions
  IB/pvrdma: Add functions for Verbs support
  IB/pvrdma: Add Kconfig and Makefile
  IB: Add PVRDMA driver
  MAINTAINERS: Update for PVRDMA driver

 MAINTAINERS                                    |    7 +
 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/hw/Makefile                 |    1 +
 drivers/infiniband/hw/pvrdma/Kconfig           |    8 +
 drivers/infiniband/hw/pvrdma/Makefile          |    3 +
 drivers/infiniband/hw/pvrdma/pvrdma.h          |  459 +++++++++
 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c      |  104 +++
 drivers/infiniband/hw/pvrdma/pvrdma_cq.c       |  436 +++++++++
 drivers/infiniband/hw/pvrdma/pvrdma_defs.h     |  300 ++++++
 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h  |  342 +++++++
 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c |  128 +++
 drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h |  450 +++++++++
 drivers/infiniband/hw/pvrdma/pvrdma_main.c     | 1189 ++++++++++++++++++++++++
 drivers/infiniband/hw/pvrdma/pvrdma_misc.c     |  309 ++++++
 drivers/infiniband/hw/pvrdma/pvrdma_mr.c       |  333 +++++++
 drivers/infiniband/hw/pvrdma/pvrdma_qp.c       |  976 +++++++++++++++++++
 drivers/infiniband/hw/pvrdma/pvrdma_uapi.h     |  247 +++++
 drivers/infiniband/hw/pvrdma/pvrdma_user.h     |   99 ++
 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c    |  593 ++++++++++++
 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h    |  108 +++
 20 files changed, 6093 insertions(+)
 create mode 100644 drivers/infiniband/hw/pvrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/pvrdma/Makefile
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cq.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_defs.h
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_main.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_misc.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_mr.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_qp.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_uapi.h
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_user.h
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
