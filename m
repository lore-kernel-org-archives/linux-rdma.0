From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 0/6] IB/hfi1,rdmavt: Few more for 4.9 incl stable fix
Date: Mon, 10 Oct 2016 06:14:22 -0700
Message-ID: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dean Luick <dean.luick@intel.com>, Jakub Pawlak <jakub.pawlak@intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, Stable <stable@vger.kernel.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Jianxin Xiong <jianxin.xiong@intel.com>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are a couple more patches we have collected for 4.9. There is a stable fix
here that fixes a breakage in IPoIB introduced by a change in 4.8.

Patches apply on your k.o/for-4.9-hfi1 branch.

Can also be found in GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.9

---

Dennis Dalessandro (1):
      IB/rdmavt: rdmavt can handle non aligned page maps

Jakub Pawlak (1):
      IB/hfi1: Fix integrity check flags default values

Mike Marciniszyn (3):
      IB/hfi1: Add unique txwait_lock for txreq events
      IB/hfi1: Inline sdma_txclean() for verbs pio
      IB/hfi1: Optimize lkey validation structures

Tadeusz Struk (1):
      IB/hfi1: Remove redundant sysfs irq affinity entry


 drivers/infiniband/hw/hfi1/affinity.c    |   72 ------------------------------
 drivers/infiniband/hw/hfi1/affinity.h    |    4 --
 drivers/infiniband/hw/hfi1/hfi.h         |   40 +++++++++++------
 drivers/infiniband/hw/hfi1/iowait.h      |    8 +++
 drivers/infiniband/hw/hfi1/pio.c         |   14 ++----
 drivers/infiniband/hw/hfi1/qp.c          |   11 +++--
 drivers/infiniband/hw/hfi1/sdma.c        |   37 +++++----------
 drivers/infiniband/hw/hfi1/sdma.h        |   12 ++++-
 drivers/infiniband/hw/hfi1/sysfs.c       |   25 ----------
 drivers/infiniband/hw/hfi1/verbs.c       |    4 ++
 drivers/infiniband/hw/hfi1/verbs.h       |   13 +++--
 drivers/infiniband/hw/hfi1/verbs_txreq.c |   13 +++--
 drivers/infiniband/sw/rdmavt/dma.c       |    3 -
 drivers/infiniband/sw/rdmavt/mr.c        |   10 ++--
 include/rdma/rdmavt_mr.h                 |   10 +++-
 15 files changed, 97 insertions(+), 179 deletions(-)

--
-Denny
