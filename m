From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 0/2] ib: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 16:09:00 +0100
Message-ID: <cover.1392733151.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (2):
  mthca: Use pci_enable_msix_range() instead of pci_enable_msix()
  qib: Use pci_enable_msix_range() instead of pci_enable_msix()

 drivers/infiniband/hw/mthca/mthca_main.c |    9 ++---
 drivers/infiniband/hw/qib/qib_pcie.c     |   55 +++++++++++++++--------------
 2 files changed, 31 insertions(+), 33 deletions(-)

-- 
1.7.7.6
