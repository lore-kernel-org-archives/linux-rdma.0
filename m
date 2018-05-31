From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 0/2] IB/hfi1: Fixes for rc or next if too late
Date: Thu, 31 May 2018 11:29:59 -0700
Message-ID: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug and Jason,

We have two more late breaking fix up patches. The DMA_RTAIL fix is the more
serious of the two. I realize we are at the tail end of 4.17 so I would not be
against holding off till 4.18 for these, but if there is another rdma
pull request we may want to tack these on.

---

Kaike Wan (1):
      IB/hfi1: Ensure VL index is within bounds

Mike Marciniszyn (1):
      IB/hfi1: Fix user context tail allocation for DMA_RTAIL


 drivers/infiniband/hw/hfi1/chip.c     |    8 ++++----
 drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
 drivers/infiniband/hw/hfi1/init.c     |    9 ++++-----
 drivers/infiniband/hw/hfi1/sdma.c     |   12 +++---------
 4 files changed, 12 insertions(+), 19 deletions(-)
