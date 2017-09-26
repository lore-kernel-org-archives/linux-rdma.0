From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 0/7] IB/hfi1: Fixes for RC
Date: Tue, 26 Sep 2017 06:05:49 -0700
Message-ID: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Sokolowski <jan.sokolowski@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

Here are our first batch of patches for 4.14 RC cycle. These all fix bugs and
most are pretty straight forward.

However, of note is a revert by Alex for an IPoIB patch. This has been marked
stable as well. 

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

---

Alex Estrin (1):
      Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"

Harish Chegondi (1):
      IB/hfi1: Unsuccessful PCIe caps tuning should not fail driver load

Jan Sokolowski (1):
      IB/hfi1: Check eeprom config partition validity

Kamenee Arumugam (1):
      IB/hfi1: Return correct value in general interrupt handler

Michael J. Ruhl (1):
      IB/hfi1: On error, fix use after free during user context setup

Sebastian Sanchez (2):
      IB/hfi1: Turn off AOC TX after offline substates
      IB/hfi1: Only reset QSFP after link up and turn off AOC TX


 drivers/infiniband/hw/hfi1/chip.c       |  101 ++++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/chip.h       |    3 +
 drivers/infiniband/hw/hfi1/eprom.c      |   20 +++++-
 drivers/infiniband/hw/hfi1/file_ops.c   |   41 +++++++------
 drivers/infiniband/hw/hfi1/pcie.c       |   50 ++++++---------
 drivers/infiniband/hw/hfi1/platform.c   |    4 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   13 ----
 7 files changed, 141 insertions(+), 91 deletions(-)
