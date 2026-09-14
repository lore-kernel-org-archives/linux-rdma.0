Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C34442B0B;
	Mon, 14 Sep 2026 11:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789384988; cv=none; b=ouss3qF2ZWO80a8CZDJ+qaPFL0A4i3naOgEdpjDmFbHXU6W+lMypAqGXWwbscmZUGjIN80r+IuPY6nJetpCiEjm8zFKY9oc1Abs0KnpzwHK+MYgByhIiAGyAEHz4pY8bB0RhlP1yw2GSQ7dvwhiLzxpwTR9fQ9AenivHIxmkT/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789384988; c=relaxed/simple;
	bh=iAVncddmE5MxAK6kUwA7UXhbZGTwi7fd4RHqWbBg4PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSHs+OnQC1hWY/tARlglpscdO14lgHwWXpJ6R/oYtH/O71x4zm2U9AdDwrUdJ51vufSPWZjSWrL9cy1UjJ2oU9VEkEwanMDsxPktuKtRxhBmvgGxC+ZfFU92qbxZBJ4RjBvaMaIcGJSzSfTjhzbCc+uEarw9/od8i+cACfGGbxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyP3Uczl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyP3Uczl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1271F000FF;
	Mon, 14 Sep 2026 11:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384985;
	bh=OwvFFwMONbtdqqV/gBRe9/xM6CrDdlgyRpvDVfwgLec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyP3UczlpjWlb8XXJPjUOCEqIecoJwHRpUZd0GdLNJiAuxJWKrq5s7+kCiSG2DRZ+
	 dL3woXMDUGmeK8ROOYM/x4gVQT6UdqPwv36mSm5IHerVd4uZ/dp3UpKhYfRm92FaW9
	 dHrrKUJeoXRMt5y/CaJSHU8LgHiE1ZlfT/4RXNTEbrqoKZEdYu3Xy0aaG+RX5ZeeaL
	 qrnSDF3FO/D/bV0L+70ojM4vQrqWYfa5wzmGbyNQYrlbd7J36Wjw9x6Xm1zpUmv7Lj
	 e0BaIsQ69DlKrMSrpyOMlgid4b5AVcS78p+EtyRDb3xskfxVj3l4iRqOGzhtXzBdE8
	 VwulKDy0mx4ZA==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v6 03/18] PCI/P2PDMA: Derive routing from directional ACS controls
Date: Mon, 14 Sep 2026 14:22:36 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-3-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

pci_bridge_has_acs_redir() treats Request and Completion Redirect as
interchangeable. On asymmetric fabrics, a control for only the reverse TLP
direction can unnecessarily force P2PDMA through the host bridge.

Evaluate Request Redirect for client Requests and Completion Redirect for
provider read Completions. Continue treating enabled Egress Control
conservatively as a Request redirect.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 75 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index d8c9d605b828..6da68ec99601 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -21,6 +21,8 @@
 #include <linux/seq_buf.h>
 #include <linux/xarray.h>
 
+#include "pci.h"
+
 /*
  * Lifetime and RCU usage
  *
@@ -513,26 +515,56 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
 	return NULL;
 }
 
+enum pci_acs_p2pdma_state {
+	PCI_ACS_P2PDMA_DIRECT,
+	PCI_ACS_P2PDMA_REDIRECT,
+};
+
 /*
- * Check if a PCI bridge has its ACS redirection bits set to redirect P2P
- * TLPs upstream via ACS. Returns 1 if the packets will be redirected
- * upstream, 0 otherwise.
+ * Decide how a peer-to-peer Request at an ACS-capable ingress port routes,
+ * from that port's ACS Control register.
+ *
+ * Linux does not read the Egress Control Vector, so Egress Control is treated
+ * conservatively as a redirect. Per PCIe r7.0 Table 6-11 the outcomes it
+ * selects are a direct route and an ACS Violation, and neither one lets peer
+ * bus addressing be assumed.
  */
-static int pci_bridge_has_acs_redir(struct pci_dev *pdev)
+static enum pci_acs_p2pdma_state
+pci_acs_p2pdma_request(u16 ctrl)
 {
-	int pos;
-	u16 ctrl;
+	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
+		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
+}
 
-	pos = pdev->acs_cap;
-	if (!pos)
-		return 0;
+/*
+ * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
+ * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
+ * affects a Completion.
+ */
+static enum pci_acs_p2pdma_state
+pci_acs_p2pdma_completion(u16 ctrl)
+{
+	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
+				   PCI_ACS_P2PDMA_DIRECT;
+}
 
-	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+/*
+ * Read @pdev's ACS Control register. A device without an ACS capability has
+ * no peer-to-peer controls at all, which routes the same as having them all
+ * clear. Returns false when the register is present but cannot be read; @ctrl
+ * is then meaningless.
+ */
+static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
+{
+	int pos;
 
-	if (ctrl & (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC))
-		return 1;
+	pos = pdev->acs_cap;
+	if (!pos) {
+		*ctrl = 0;
+		return true;
+	}
 
-	return 0;
+	return !pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
 }
 
 static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
@@ -721,6 +753,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * then to Device B. The mapping type returned depends on the ACS
  * redirection setting of the ports along the path.
  *
+ * The client initiates Requests to provider memory. Check Request Redirect
+ * on the client path and Completion Redirect for read Completions on the
+ * provider path.
+ *
  * If ACS redirect is set on any port in the path, traffic between the
  * devices will go through the host bridge, so return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE; otherwise return
@@ -744,6 +780,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	int dist_a = 0;
 	int dist_b = 0;
 	char buf[128];
+	u16 ctrl;
 
 	seq_buf_init(&acs_list, buf, sizeof(buf));
 
@@ -755,7 +792,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	while (a) {
 		dist_b = 0;
 
-		if (pci_bridge_has_acs_redir(a)) {
+		if (!pci_acs_p2pdma_ctrl(a, &ctrl) ||
+		    pci_acs_p2pdma_completion(ctrl) ==
+			    PCI_ACS_P2PDMA_REDIRECT) {
 			seq_buf_print_bus_devfn(&acs_list, a);
 			acs_cnt++;
 		}
@@ -784,7 +823,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		if (a == bb)
 			break;
 
-		if (pci_bridge_has_acs_redir(bb)) {
+		if (!pci_acs_p2pdma_ctrl(bb, &ctrl) ||
+		    pci_acs_p2pdma_request(ctrl) ==
+			    PCI_ACS_P2PDMA_REDIRECT) {
 			seq_buf_print_bus_devfn(&acs_list, bb);
 			acs_cnt++;
 		}
@@ -1132,10 +1173,10 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 /**
  * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
  * @provider: P2PDMA provider structure
- * @dev: Target device for the transfer
+ * @dev: Client device that initiates the transfer
  *
  * Determines how peer-to-peer DMA transfers should be mapped between
- * the provider and the target device. The mapping type indicates whether
+ * the provider and the client device. The mapping type indicates whether
  * the transfer can be done directly through PCI switches or must go
  * through the host bridge.
  */

-- 
2.55.0

