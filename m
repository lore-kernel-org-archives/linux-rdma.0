From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 00/15] IB/hfi1: hfi1 driver patches for 4.12
Date: Tue, 02 May 2017 17:40:58 -0700
Message-ID: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, Ira Weiny <ira.weiny@intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, Tymoteusz Kielan <tymoteusz.kielan@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Easwar Hariharan <easwar.hariharan@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is one more set of patches for the hfi1 driver for the merge window. This
is just fixes and clean ups as usual. Of note there are about 5 patches here
which deal with context initiliazation and usage. 

Patches apply cleanly on top of: 87f0faa : IB/SA: Add OPA addr header

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.12

---

Jakub Byczkowski (1):
      IB/hfi1: Fix checks for Offline transient state

Michael J. Ruhl (9):
      IB/hfi1: Return an error on memory allocation failure
      IB/hfi1: Fix a subcontext memory leak
      IB/hfi1: Name function prototype parameters
      IB/hfi1: Use filedata rather than filepointer
      IB/hfi1: Search shared contexts on the opened device, not all devices
      IB/hfi1: Correctly clear the pkey
      IB/hfi1: Clean up context initialization
      IB/hfi1: Fix an assign/ordering issue with shared context IDs
      IB/hfi1: Clean up on context initialization failure

Mike Marciniszyn (2):
      IB/hfi1,IB/rdmavt: Move r_adefered to r_lock cache line
      IB/hfi1: Fix yield logic in send engine

Sebastian Sanchez (2):
      IB/hfi1: Get rid of divide when setting the tx request header
      IB/hfi1: Remove atomic operations for SDMA_REQ_HAVE_AHG bit

Tymoteusz Kielan (1):
      IB/hfi1: Adjust default eager_buffer_size to 8MB


 drivers/infiniband/hw/hfi1/chip.c         |   47 +--
 drivers/infiniband/hw/hfi1/chip.h         |   10 -
 drivers/infiniband/hw/hfi1/driver.c       |   42 ---
 drivers/infiniband/hw/hfi1/file_ops.c     |  425 +++++++++++++++--------------
 drivers/infiniband/hw/hfi1/hfi.h          |  107 +++----
 drivers/infiniband/hw/hfi1/init.c         |   33 +-
 drivers/infiniband/hw/hfi1/intr.c         |    3 
 drivers/infiniband/hw/hfi1/qp.c           |    4 
 drivers/infiniband/hw/hfi1/rc.c           |   13 -
 drivers/infiniband/hw/hfi1/ruc.c          |   80 +++--
 drivers/infiniband/hw/hfi1/trace_ctxts.h  |   17 +
 drivers/infiniband/hw/hfi1/trace_tx.h     |   34 ++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  182 +++++++-----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |   17 +
 drivers/infiniband/hw/hfi1/user_sdma.c    |  190 ++++++-------
 drivers/infiniband/hw/hfi1/user_sdma.h    |   18 +
 drivers/infiniband/hw/hfi1/verbs.h        |    5 
 drivers/infiniband/hw/hfi1/vnic_main.c    |    8 -
 include/rdma/rdmavt_qp.h                  |    1 
 19 files changed, 633 insertions(+), 603 deletions(-)
