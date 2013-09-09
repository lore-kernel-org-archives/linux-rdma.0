From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3/6] IB/qib: Use pci_is_root_bus() to check whether it is a root bus
Date: Mon, 9 Sep 2013 21:13:05 +0800
Message-ID: <1378732388-4508-4-git-send-email-wangyijing@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Airlie <airlied@linux.ie>, Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, Roland Dreier <roland@purestorage.com>
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Use pci_is_root_bus() instead of "if (bus->parent)" statement
for better readability.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index c574ec7..3a5b99b 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -590,7 +590,7 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
-	if (parent->bus->parent) {
+	if (!pci_is_root_bus(parent->bus)) {
 		qib_devinfo(dd->pcidev, "Parent not root\n");
 		goto bail;
 	}
-- 
1.7.1
