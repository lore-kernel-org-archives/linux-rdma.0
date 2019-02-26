From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 0/3] Driver fixes
Date: Tue, 26 Feb 2019 08:45:02 -0800
Message-ID: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here are some fixes that didn't quite make the boat for 5.0-rc. So we can
go ahead and send them to -next. The third patch here is really a v2 of:

https://patchwork.kernel.org/patch/10769005/

---

Michael J. Ruhl (2):
      IB/rdmavt: Fix concurrency panics in QP post_send and modify to error
      IB/hfi1: Close race condition on user context disable and close

Mike Marciniszyn (1):
      IB/rdmavt: Fix loopback send with invalidate ordering


 drivers/infiniband/hw/hfi1/hfi.h  |    2 +
 drivers/infiniband/hw/hfi1/init.c |   14 ++++++---
 drivers/infiniband/sw/rdmavt/qp.c |   59 ++++++++++++++++++++++++-------------
 3 files changed, 49 insertions(+), 26 deletions(-)
