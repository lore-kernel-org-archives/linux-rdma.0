From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 0/5] IB/hfi1,isert: Updates for-next 5/15/2018
Date: Tue, 15 May 2018 18:31:00 -0700
Message-ID: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Dutile <ddutile@redhat.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug and Jason,

Here are some patches to go to for-next. One is a code cleanup. The rest are
bug fixes that are probably not serious enough for an -rc6. The one that may be
on the fence is the isert patch. Since it only affects debug kernels it can
probably even wait till for-next. It has been marked stable though. 

---

Alex Estrin (1):
      IB/isert: Fix for lib/dma_debug check_sync warning

Kamenee Arumugam (1):
      IB/Hfi1: Mask Unsupported Request error bit in PCIe AER

Michael J. Ruhl (1):
      IB/hfi1: Set port number for errorinfo MAD response

Mike Marciniszyn (2):
      IB/hfi1: Cleanup of exp_rcv
      IB/{rdmavt,hfi1}; Change hrtimer add to use the pinned variation


 drivers/infiniband/hw/hfi1/exp_rcv.c    |   39 +++++++++++++++++++------------
 drivers/infiniband/hw/hfi1/exp_rcv.h    |   24 ++++++++++++++++++-
 drivers/infiniband/hw/hfi1/hfi.h        |   14 ++++++-----
 drivers/infiniband/hw/hfi1/init.c       |    4 +--
 drivers/infiniband/hw/hfi1/mad.c        |    1 +
 drivers/infiniband/hw/hfi1/pcie.c       |   15 ++++++++++++
 drivers/infiniband/hw/hfi1/rc.c         |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c       |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c |   26 ++++++++++++++-------
 9 files changed, 91 insertions(+), 36 deletions(-)
