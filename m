From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 0/6] Simplify some mps and mrrs setting related code
Date: Mon, 9 Sep 2013 21:13:02 +0800
Message-ID: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Airlie <airlied@linux.ie>, Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, Roland Dreier <roland@purestorage.com>
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
List-Id: linux-rdma@vger.kernel.org

This series simplify mps and mrrs setting related code in drivers.
Export the pcie_set/get_mps() like pcie_set/get_readrq(). So drivers
can use these interfaces to simplify code that set mps and mrrs.
Patch 2 use pci_is_root_bus() instead of if (bus->parent) statement
for better readability.

Yijing Wang (6):
  PCI: Export pcie_set_mps() and pcie_get_mps()
  title/pci: use cached pci_dev->pcie_mpss to simplify code
  IB/qib: Use pci_is_root_bus() to check whether it is a root bus
  IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
  staging/et131x: Use cached pci_dev->pcie_mpss and pcie_set_readrq()
    to simplif code
  radeon: Use pcie_get_readrq() and pcie_set_readrq() to simplify code

 arch/tile/kernel/pci.c               |    7 +--
 drivers/gpu/drm/radeon/evergreen.c   |   19 ++-----
 drivers/infiniband/hw/qib/qib_pcie.c |   98 +++++++++++-----------------------
 drivers/pci/pci.c                    |    2 +
 drivers/staging/et131x/et131x.c      |   14 +----
 5 files changed, 44 insertions(+), 96 deletions(-)
