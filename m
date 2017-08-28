From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/9] IB/hfi1, qib,
 rdmavt: patches for next 08/28/2017
Date: Mon, 28 Aug 2017 11:23:14 -0700
Message-ID: <20170828182121.29434.18989.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is the next round of patches for our drivers. There are a few patches from
Mike that adds a qp iterator and starts the work of cleaning up some of our code
that needs to walk qps. The rest are minor bug fixes.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

---

Jan Sokolowski (1):
      IB/hfi1: Acquire QSFP cable information on loopback

Kaike Wan (1):
      IB/hfi1: Use accessor to determine ring size

Kamenee Arumugam (1):
      IB/qib: Stricter bounds checking for copy to buffer

Michael J. Ruhl (1):
      IB/hif1: Remove static tracing from SDMA hot path

Mike Marciniszyn (5):
      IB/rdmavt: Add QP iterator API for QPs
      IB/hfi1: Convert hfi1_error_port_qps() to use new QP iterator
      IB/hfi1: Convert qp_stats debugfs interface to use new iterator API
      IB/qib: Convert qp_stats debugfs interface to use new iterator API
      IB/rdmavt: Handle dereg of inuse MRs properly


 drivers/infiniband/hw/hfi1/debugfs.c    |   15 +-
 drivers/infiniband/hw/hfi1/file_ops.c   |    3 
 drivers/infiniband/hw/hfi1/mmu_rb.c     |   13 +-
 drivers/infiniband/hw/hfi1/platform.c   |   15 ++
 drivers/infiniband/hw/hfi1/qp.c         |  164 ++++++--------------
 drivers/infiniband/hw/hfi1/qp.h         |   23 ---
 drivers/infiniband/hw/hfi1/trace.h      |    3 
 drivers/infiniband/hw/hfi1/trace_mmu.h  |   95 ++++++++++++
 drivers/infiniband/hw/hfi1/trace_tx.h   |  136 ++++++++++++++++
 drivers/infiniband/hw/hfi1/user_sdma.c  |   31 ++--
 drivers/infiniband/hw/hfi1/user_sdma.h  |    3 
 drivers/infiniband/hw/qib/qib_debugfs.c |   18 +-
 drivers/infiniband/hw/qib/qib_iba7322.c |    4 
 drivers/infiniband/hw/qib/qib_qp.c      |   51 +-----
 drivers/infiniband/hw/qib/qib_verbs.h   |   10 -
 drivers/infiniband/sw/rdmavt/mr.c       |  121 +++++++++++++--
 drivers/infiniband/sw/rdmavt/qp.c       |  256 +++++++++++++++++++++++++++++++
 include/rdma/rdmavt_mr.h                |    3 
 include/rdma/rdmavt_qp.h                |   30 ++++
 19 files changed, 733 insertions(+), 261 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/trace_mmu.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
