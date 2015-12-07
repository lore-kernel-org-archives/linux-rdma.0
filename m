From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/37] Add rdma verbs transport library
Date: Mon, 07 Dec 2015 15:42:56 -0500
Message-ID: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series implements rdmavt. This is the rdma verbs transport
software library which will help to solve the problem of code duplication
between hardware drivers when it comes to a verbs implementation.

Rdmavt is basically just another verbs provider and lives in the Infiniband tree
in a new sw directory. It provides a software implementation of the Infiniband
verbs API. More details can be found in the following threads:

http://www.spinics.net/lists/linux-rdma/msg29064.html
http://www.spinics.net/lists/linux-rdma/msg29922.html

This patch series is based on 4.4-rc3.

---

Dennis Dalessandro (35):
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
      IB/rdamvt: Add post send and recv stubs
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
      IB/rdmavt: Add support for new memory registration API

Kamal Heib (2):
      IB/rdmavt: Add common LID defines to rdmavt
      IB/rdmavt: Add AH to rdmavt


 MAINTAINERS                           |    6 
 drivers/infiniband/Kconfig            |    2 
 drivers/infiniband/Makefile           |    1 
 drivers/infiniband/sw/Makefile        |    1 
 drivers/infiniband/sw/rdmavt/Kconfig  |    6 
 drivers/infiniband/sw/rdmavt/Makefile |   10 
 drivers/infiniband/sw/rdmavt/ah.c     |  172 ++++++
 drivers/infiniband/sw/rdmavt/ah.h     |   62 ++
 drivers/infiniband/sw/rdmavt/cq.c     |  116 ++++
 drivers/infiniband/sw/rdmavt/cq.h     |   65 ++
 drivers/infiniband/sw/rdmavt/dma.c    |  187 ++++++
 drivers/infiniband/sw/rdmavt/dma.h    |   56 ++
 drivers/infiniband/sw/rdmavt/mad.c    |   88 +++
 drivers/infiniband/sw/rdmavt/mad.h    |   62 ++
 drivers/infiniband/sw/rdmavt/mcast.c  |   61 ++
 drivers/infiniband/sw/rdmavt/mcast.h  |   59 ++
 drivers/infiniband/sw/rdmavt/mmap.c   |  201 +++++++
 drivers/infiniband/sw/rdmavt/mmap.h   |   58 ++
 drivers/infiniband/sw/rdmavt/mr.c     |  960 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mr.h     |  103 ++++
 drivers/infiniband/sw/rdmavt/pd.c     |  106 ++++
 drivers/infiniband/sw/rdmavt/pd.h     |   61 ++
 drivers/infiniband/sw/rdmavt/qp.c     |  382 +++++++++++++
 drivers/infiniband/sw/rdmavt/qp.h     |   72 ++
 drivers/infiniband/sw/rdmavt/srq.c    |   89 +++
 drivers/infiniband/sw/rdmavt/srq.h    |   64 ++
 drivers/infiniband/sw/rdmavt/vt.c     |  383 +++++++++++++
 drivers/infiniband/sw/rdmavt/vt.h     |   93 +++
 include/rdma/ib_verbs.h               |    1 
 include/rdma/rdma_vt.h                |  339 ++++++++++++
 include/rdma/rdmavt_mr.h              |  133 +++++
 include/rdma/rdmavt_qp.h              |  298 ++++++++++
 32 files changed, 4297 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/sw/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/Kconfig
 create mode 100644 drivers/infiniband/sw/rdmavt/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/ah.c
 create mode 100644 drivers/infiniband/sw/rdmavt/ah.h
 create mode 100644 drivers/infiniband/sw/rdmavt/cq.c
 create mode 100644 drivers/infiniband/sw/rdmavt/cq.h
 create mode 100644 drivers/infiniband/sw/rdmavt/dma.c
 create mode 100644 drivers/infiniband/sw/rdmavt/dma.h
 create mode 100644 drivers/infiniband/sw/rdmavt/mad.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mad.h
 create mode 100644 drivers/infiniband/sw/rdmavt/mcast.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mcast.h
 create mode 100644 drivers/infiniband/sw/rdmavt/mmap.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mmap.h
 create mode 100644 drivers/infiniband/sw/rdmavt/mr.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mr.h
 create mode 100644 drivers/infiniband/sw/rdmavt/pd.c
 create mode 100644 drivers/infiniband/sw/rdmavt/pd.h
 create mode 100644 drivers/infiniband/sw/rdmavt/qp.c
 create mode 100644 drivers/infiniband/sw/rdmavt/qp.h
 create mode 100644 drivers/infiniband/sw/rdmavt/srq.c
 create mode 100644 drivers/infiniband/sw/rdmavt/srq.h
 create mode 100644 drivers/infiniband/sw/rdmavt/vt.c
 create mode 100644 drivers/infiniband/sw/rdmavt/vt.h
 create mode 100644 include/rdma/rdma_vt.h
 create mode 100644 include/rdma/rdmavt_mr.h
 create mode 100644 include/rdma/rdmavt_qp.h

-- 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
