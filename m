From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 0/2] IB/hfi1: More fixes for 4.7 rc
Date: Fri, 17 Jun 2016 19:17:43 -0700
Message-ID: <20160618021550.31540.57897.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Stable <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Doug, here are two more RC fixes that we would like to see landed in 4.7
if possible, including one which is marked as stable.

Patches apply on your k.o/for-4.7-rc tree ontop of the last batch of RC fixes
which you just picked up.

Patches can also be viewed in my repo and have passed 0day builds:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Ashutosh Dixit (1):
      IB/hfi1: Don't zero out qp->s_ack_queue in rvt_reset_qp

Mike Marciniszyn (1):
      IB/hfi1: Fix deadlock with txreq allocation slow path


 drivers/infiniband/hw/hfi1/verbs_txreq.c |    4 +---
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    1 +
 drivers/infiniband/sw/rdmavt/qp.c        |    6 ------
 3 files changed, 2 insertions(+), 9 deletions(-)

--
-Denny
