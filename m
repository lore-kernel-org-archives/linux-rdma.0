From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 0/5] IB/hfi1: Fixes for 5.1 rc cycle
Date: Mon, 18 Mar 2019 09:54:55 -0700
Message-ID: <20190318165205.23550.97894.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org

Here is a set of small fixes that we would like to land in the rc cycle
for 5.1. One of them is marked as stable.

The first patch fixes an unnecessary stack trace due to incorrect WQ flags. The
next three fix issues uncovered due to TID RDMA which was brought in for 5.1.
The last one is a bug in VNIC.

---

Kaike Wan (4):
      IB/hfi1: Failed to drain send queue when QP is put into error state
      IB/hfi1: Clear the IOWAIT pending bits when QP is put into error state
      IB/hfi1: Eliminate opcode tests on mr deref
      IB/hfi1: Fix the allocation of RSM table

Mike Marciniszyn (1):
      IB/hfi1: Fix WQ_MEM_RECLAIM warning


 drivers/infiniband/hw/hfi1/chip.c |   26 +++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/init.c |    3 ++-
 drivers/infiniband/hw/hfi1/qp.c   |    4 +++-
 drivers/infiniband/hw/hfi1/rc.c   |    4 ++--
 4 files changed, 26 insertions(+), 11 deletions(-)
