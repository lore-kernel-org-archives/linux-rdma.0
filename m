From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 0/2] IB/hfi1: RC patches
Date: Mon, 10 Sep 2018 07:53:44 -0700
Message-ID: <20180910143437.10122.50679.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug and Jason,

Here are two patches that should probably land in the RC. The first one ensures
we don't index beyond the end of an array. The other is more subtle but arguably
more important. The bug it fixes results in incorrect IRQ bits to be set and the
result is we do not get an interrupt for an error and have to wait for another
interrupt to fire to see said error.

---

Dennis Dalessandro (1):
      IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds

Michael J. Ruhl (1):
      IB/hfi1: set_intr_bits uses incorrect source for register modification


 drivers/infiniband/hw/hfi1/chip.c                |    2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)
