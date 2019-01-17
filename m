From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 0/7] hfi1 and qib patches for rc
Date: Thu, 17 Jan 2019 12:40:57 -0800
Message-ID: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Brian Welty <brian.welty@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Andrzej Witkowski <andrzej.witkowski@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Folks,

Here are a handful of patches we'd like to target for the RC. These are bug
fixes, except one may be a little iffy (Add wc_flags and wc_immdata...) but
it's a very trivial patch and really helps with debugging.

---

Andrzej Witkowski (1):
      IB/hfi1: Use new API to deallocate vnic rdma-netdev in hfi1 driver

Brian Welty (1):
      IB/{hfi1,qib}: Fix WC.byte_len calculation for UD_SEND_WITH_IMM

Michael J. Ruhl (3):
      IB/{hfi1,qib,rdmavt}: Do not depend on IB Verbs name for driver logging
      IB/hfi1: Close race condition on user context disable and close
      IB/hfi1: Remove overly conservative VM_EXEC flag check

Mike Marciniszyn (2):
      IB/rdmavt: Add wc_flags and wc_immdata to cq entry trace
      IB/hfi1: Add limit test for RC/UC send via loopback


 drivers/infiniband/hw/hfi1/affinity.c             |    6 ++-
 drivers/infiniband/hw/hfi1/driver.c               |    8 ++++
 drivers/infiniband/hw/hfi1/file_ops.c             |    4 ++
 drivers/infiniband/hw/hfi1/hfi.h                  |   25 +++++++-------
 drivers/infiniband/hw/hfi1/init.c                 |   10 +++---
 drivers/infiniband/hw/hfi1/ud.c                   |    1 -
 drivers/infiniband/hw/hfi1/verbs.c                |    1 +
 drivers/infiniband/hw/hfi1/vnic_main.c            |    4 +-
 drivers/infiniband/hw/qib/qib.h                   |   12 +++----
 drivers/infiniband/hw/qib/qib_driver.c            |    8 ++++
 drivers/infiniband/hw/qib/qib_init.c              |   10 ++++--
 drivers/infiniband/hw/qib/qib_ud.c                |    1 -
 drivers/infiniband/hw/qib/qib_verbs.c             |    1 +
 drivers/infiniband/sw/rdmavt/qp.c                 |    7 +++-
 drivers/infiniband/sw/rdmavt/trace.h              |    6 ++-
 drivers/infiniband/sw/rdmavt/trace_cq.h           |   10 ++++--
 drivers/infiniband/sw/rdmavt/vt.c                 |    2 +
 drivers/infiniband/sw/rdmavt/vt.h                 |   10 ++++--
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |    5 +--
 include/rdma/ib_verbs.h                           |    7 ----
 include/rdma/rdma_vt.h                            |   38 ++++-----------------
 21 files changed, 92 insertions(+), 84 deletions(-)
