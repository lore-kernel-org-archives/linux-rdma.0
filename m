From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 0/2] Patches for 4.20 rc cycle
Date: Wed, 28 Nov 2018 06:44:23 -0800
Message-ID: <20181128143119.10591.16943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniczyn <mike.marciniszyn@intel.com>, Piotr Stankiewicz <piotr.stankiewicz@intel.com>, Stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug and Jason,

Here are two patches that would be good to land in the RC. One fixes a bug
found by KASAN that was marked stable. The other fixes something that was
introduced in the last release cycle.

Both patches are pretty small.

---

Michael J. Ruhl (1):
      IB/hfi1: Fix a latency issue for small messages

Piotr Stankiewicz (1):
      IB/hfi1: Fix an out-of-bounds access in get_hw_stats


 drivers/infiniband/hw/hfi1/chip.c  |    3 ++-
 drivers/infiniband/hw/hfi1/hfi.h   |    2 ++
 drivers/infiniband/hw/hfi1/qp.c    |    7 +++++++
 drivers/infiniband/hw/hfi1/verbs.c |    2 +-
 4 files changed, 12 insertions(+), 2 deletions(-)
