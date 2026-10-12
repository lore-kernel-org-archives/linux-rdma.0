Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EAC279DCC;
	Mon, 12 Oct 2026 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810502; cv=none; b=oNxHuoRyDm7Gw/TYMBZR591T2Hln3tgBRvQt/Ta9UFbmsms/zR5J7O6ZIDsnXLoup2Hv3DQA80Eg2Dv/rOd4/vz9Rd5Kv7Gt0JjLu3qGqLn2vTZcs4/pV+ufsEqVi4w5XwX38DawstRVmW6QL1O8Y68r8U0Rhcueme59N3x287U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810502; c=relaxed/simple;
	bh=+JuOoIawLBYVjkdfzknoaAWaAx65Sbb48Xu83lKOY3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5gb07usdn9ZVdBl9c6pIgLgzsxedg/c5iLaUiM+pCA6OoD6Eb3sXUb1xB2QFIPOszbazS30s07QOHES2ii5gb6N8v4nLztmA7Mb0Xi764i6sNWy1MFI7hv3xYywFtcLdb18J5CcbLA9KHKviErWW9b/ShcSHt89Hi9TSsbecRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2gNniKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2gNniKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C0C1F0089B;
	Mon, 12 Oct 2026 13:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810501;
	bh=Wm9IiPoSioEgFbMyM/9l45IliWLaiTHM/+Etl15VEGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2gNniKFdHqPU/w5xfFryiCZLV87dVcWxzXk6bPU3WDNatE1VKO8sknTTlgdIL4Dg
	 41T/xiIX0LmN18ntkNA1fyUDPBWwKdKpcvr3irCt6Pwx4IPWmhwgM0ql+wAhWlqpKg
	 csfVFDLbW9N6UPEEQqgHNkHLun60cG77l0+tTncs7QfH0yShFSdmhap9ZHhT9z1zWG
	 uWbLPnDogIKreE4mRjy4F6+W2OwJjWTvCTHGXNfUMZC49723hL9Sj29qNCJmNwN4mp
	 UoDax6ijvvKAMZZrD6BygsKTeCCbqsVlG+KRtaIxUOh19jUrSUd0K4XOEffZU8b2K/
	 /ozlph/yfUu7w==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v10 02/18] PCI/P2PDMA: Derive routing from directional ACS controls
Date: Mon, 12 Oct 2026 16:07:39 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-2-6ffe7b7a4517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
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

Evaluate Request Redirect for the Requester's Requests and Completion
Redirect for the Completer's read Completions. Continue treating enabled
Egress Control conservatively as a Request redirect.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 75 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 45260423dfb0..db54865b0be9 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -21,6 +21,8 @@
 #include <linux/seq_buf.h>
 #include <linux/xarray.h>
 
+#include "pci.h"
+
 struct pci_p2pdma {
 	struct gen_pool *pool;
 	bool p2pmem_published;
@@ -490,26 +492,56 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
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
@@ -704,6 +736,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * then to Device B. The mapping type returned depends on the ACS
  * redirection setting of the ports along the path.
  *
+ * The client is the Requester and the provider the Completer. Check Request
+ * Redirect on the Requester's path and Completion Redirect for read
+ * Completions on the Completer's path.
+ *
  * If ACS redirect is set on any port in the path, traffic between the
  * devices will go through the host bridge, so return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE; otherwise return
@@ -727,6 +763,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	int dist_a = 0;
 	int dist_b = 0;
 	char buf[128];
+	u16 ctrl;
 
 	seq_buf_init(&acs_list, buf, sizeof(buf));
 
@@ -738,7 +775,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	while (a) {
 		dist_b = 0;
 
-		if (pci_bridge_has_acs_redir(a)) {
+		if (!pci_acs_p2pdma_ctrl(a, &ctrl) ||
+		    pci_acs_p2pdma_completion(ctrl) ==
+			    PCI_ACS_P2PDMA_REDIRECT) {
 			seq_buf_print_bus_devfn(&acs_list, a);
 			acs_cnt++;
 		}
@@ -767,7 +806,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		if (a == bb)
 			break;
 
-		if (pci_bridge_has_acs_redir(bb)) {
+		if (!pci_acs_p2pdma_ctrl(bb, &ctrl) ||
+		    pci_acs_p2pdma_request(ctrl) ==
+			    PCI_ACS_P2PDMA_REDIRECT) {
 			seq_buf_print_bus_devfn(&acs_list, bb);
 			acs_cnt++;
 		}
@@ -1116,10 +1157,10 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
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

