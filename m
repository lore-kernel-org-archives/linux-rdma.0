From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc v2 0/6] IB/hfi1,rdmavt: Fixes for the 4.17 RC
Date: Tue, 01 May 2018 05:35:27 -0700
Message-ID: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here are 6 patches that might make the bar for RC. The first patch fixes
something that came in pretty recently, I beleive 4.13. The second patch is
trivial, but does modify user visible text.

Patch 3 looks large but it's mostly comments. It just moves code. Patch 4 is
also pretty simple. The last two patches fix memory leaks.

If you don't think these pass muster for RC please carry over to for-next.

Changes since V1:
Correct version tag so it shows up as for-rc in patchworks. 

---

Michael J. Ruhl (1):
      IB/hfi1 Use correct type for num_user_context

Mike Marciniszyn (2):
      IB/hfi1: Fix handling of FECN marked multicast packet
      IB/hfi1: Fix loss of BECN with AHG

Sebastian Sanchez (3):
      IB/hfi1: Fix NULL pointer dereference when invalid num_vls is used
      IB/{hfi1,rdmavt}: Fix memory leak in hfi1_alloc_devdata() upon failure
      IB/hfi1: Fix memory leak in exception path in get_irq_affinity()


 drivers/infiniband/hw/hfi1/affinity.c |   11 +++----
 drivers/infiniband/hw/hfi1/driver.c   |   19 ++++++++++---
 drivers/infiniband/hw/hfi1/hfi.h      |    8 +++--
 drivers/infiniband/hw/hfi1/init.c     |   43 ++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/pcie.c     |    3 --
 drivers/infiniband/hw/hfi1/platform.c |    1 +
 drivers/infiniband/hw/hfi1/qsfp.c     |    2 +
 drivers/infiniband/hw/hfi1/ruc.c      |   50 ++++++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/ud.c       |    6 ++--
 9 files changed, 101 insertions(+), 42 deletions(-)
