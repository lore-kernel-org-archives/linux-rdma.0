From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] Update module PVRDMA to VMW_PVRDMA
Date: Fri, 9 Dec 2016 09:10:02 -0800
Message-ID: <cover.1481303342.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

These are the patches for changing the pvrdma.ko module to vmw_pvrdma.ko.
They based on top of your vmw_pvrdma branch.

Thanks,
Adit
---

Adit Ranadive (4):
  IB/vmw_pvrdma: Rename module to vmw_pvrdma
  IB/vmw_pvrdma: Update file paths
  IB: Update to build vmw_pvrdma
  IB/vmw_pvrdma: Update ABI file name

 MAINTAINERS                                        |    2 +-
 drivers/infiniband/Kconfig                         |    2 +-
 drivers/infiniband/hw/Makefile                     |    2 +-
 drivers/infiniband/hw/pvrdma/Kconfig               |    7 -
 drivers/infiniband/hw/pvrdma/Makefile              |    3 -
 drivers/infiniband/hw/pvrdma/pvrdma.h              |  474 --------
 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c          |  119 --
 drivers/infiniband/hw/pvrdma/pvrdma_cq.c           |  425 -------
 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h      |  586 ----------
 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c     |  127 --
 drivers/infiniband/hw/pvrdma/pvrdma_main.c         | 1211 --------------------
 drivers/infiniband/hw/pvrdma/pvrdma_misc.c         |  304 -----
 drivers/infiniband/hw/pvrdma/pvrdma_mr.c           |  334 ------
 drivers/infiniband/hw/pvrdma/pvrdma_qp.c           |  972 ----------------
 drivers/infiniband/hw/pvrdma/pvrdma_ring.h         |  131 ---
 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c        |  577 ----------
 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h        |  435 -------
 drivers/infiniband/hw/vmw_pvrdma/Kconfig           |    7 +
 drivers/infiniband/hw/vmw_pvrdma/Makefile          |    3 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |  474 ++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c      |  119 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |  425 +++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h  |  586 ++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c |  127 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     | 1211 ++++++++++++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c     |  304 +++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c       |  334 ++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |  972 ++++++++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h     |  131 +++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |  577 ++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |  435 +++++++
 include/uapi/rdma/Kbuild                           |    2 +-
 include/uapi/rdma/pvrdma-abi.h                     |  289 -----
 include/uapi/rdma/vmw_pvrdma-abi.h                 |  289 +++++
 34 files changed, 5998 insertions(+), 5998 deletions(-)
 delete mode 100644 drivers/infiniband/hw/pvrdma/Kconfig
 delete mode 100644 drivers/infiniband/hw/pvrdma/Makefile
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cq.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_main.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_misc.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_mr.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_qp.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ring.h
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h
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
 delete mode 100644 include/uapi/rdma/pvrdma-abi.h
 create mode 100644 include/uapi/rdma/vmw_pvrdma-abi.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
