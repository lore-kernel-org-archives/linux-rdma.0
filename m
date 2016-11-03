From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Thu, 3 Nov 2016 16:44:29 -0700
Message-ID: <1478216677-6150-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series adds the userspace library for our paravirtual RDMA device.
I have already sent out the patchset for the RDMA driver before [1]. I will
also send a pull request on github.

I have included the shared ABI file here based on the RDMA fix up stuff 
that Jason pointed me to.

The patch series was built on 28d918732cc4efb2185d91a500be1e41aeb149e7.

[1] http://marc.info/?l=linux-rdma&m=147546066322315&w=2

Adit Ranadive (8):
  libpvrdma: Add ABI and main header files
  libpvrdma: Add ring traversal
  libpvrdma: Add completion queue functions
  libpvrdma: Add queue pair functions
  libpvrdma: Add misc verbs functions
  libpvrdma: Add main library file
  libpvrdma: Add to consolidated rdma-core
  libpvrdma: Add fix up for ABI file

 CMakeLists.txt                           |   1 +
 MAINTAINERS                              |   6 +
 README.md                                |   1 +
 buildlib/RDMA_LinuxHeaders.cmake         |   1 +
 buildlib/fixup-include/rdma-pvrdma-abi.h | 297 ++++++++++++++++++
 providers/pvrdma/CMakeLists.txt          |   6 +
 providers/pvrdma/cq.c                    | 287 ++++++++++++++++++
 providers/pvrdma/pvrdma.h                | 347 +++++++++++++++++++++
 providers/pvrdma/pvrdma_main.c           | 214 +++++++++++++
 providers/pvrdma/pvrdma_ring.h           | 136 +++++++++
 providers/pvrdma/qp.c                    | 505 +++++++++++++++++++++++++++++++
 providers/pvrdma/verbs.c                 | 234 ++++++++++++++
 12 files changed, 2035 insertions(+)
 create mode 100644 buildlib/fixup-include/rdma-pvrdma-abi.h
 create mode 100644 providers/pvrdma/CMakeLists.txt
 create mode 100644 providers/pvrdma/cq.c
 create mode 100644 providers/pvrdma/pvrdma.h
 create mode 100644 providers/pvrdma/pvrdma_main.c
 create mode 100644 providers/pvrdma/pvrdma_ring.h
 create mode 100644 providers/pvrdma/qp.c
 create mode 100644 providers/pvrdma/verbs.c

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
