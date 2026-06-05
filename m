Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C6B3C5838;
	Fri,  5 Jun 2026 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694607; cv=none; b=J+uoKjFNHC1H2zm3XHF1X8Q4xyPjNKkyzeGpkf4ZrlC+N9PU2iI41Fg6UBERTvJItHBumkbgThrhBXBIjki/TMQv61wMD6yrGMn94QT6WluxDv4NNJjYABWzQ/lV8zXBAeMf/Mye1gPzhOu22Tv145ug2HUq1AB1RRvnT5kPX+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694607; c=relaxed/simple;
	bh=rJnPQetP7T7nGkkK2knbXybBktnLIc9BHgC/6RTNyNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CZGUETr/zGZFCgGTSj3FdNgqiU/2pyR7dF4EwiTN00k72WAwHf/RSYbZavXm7M+Fo8eL/TIPoDfWWUXIEDi8o7avJi6XfEO7GDlUCHyW2s9O7uvywjC5PYYmZiEo8HE6EcAgb1QthdOIQJvheMUs7Rwfle5x3fhlAyAh9S7PG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=GsLPiIEj; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="GsLPiIEj"
Received: by linux.microsoft.com (Postfix, from userid 1006)
	id 2E1F920B716B; Fri,  5 Jun 2026 14:23:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2E1F920B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780694591;
	bh=HzuEttwZnXVRg1rw6WDnQpWFuwP7rDvB1ZeQDCHMViM=;
	h=From:To:Cc:Subject:Date:From;
	b=GsLPiIEjQnl8agBAcS+Bt9hqQGZNNBZXFCESbtFUovQ9a4sNoq2bm2Cl7YsCh9AYp
	 Ub9cn8/vYF4eyLfBrgZNQLz30vomGelmaGzHdZFOnfP7tFJm+z5180SV3CqEuEuK1j
	 w4mGutnwhEFrTNlOWp9FeTm2n57CIXRdaHoOf9hI=
From: Haiyang Zhang <haiyangz@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: paulros@microsoft.com
Subject: [PATCH net-next] net: mana: Add support for PF device 0x00C1
Date: Fri,  5 Jun 2026 14:22:56 -0700
Message-ID: <20260605212302.2135499-1-haiyangz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haiyang Zhang <haiyangz@microsoft.com>

Update the device id table to include the new device id 0x00C1.
This device's BAR layout is similar to VF's, update the function,
mana_gd_init_registers(), accordingly.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 7 +++++--
 include/net/mana/gdma.h                         | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 712a0881d720..5bc91ee8a543 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -150,7 +150,7 @@ static int mana_gd_init_registers(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 
-	if (gc->is_pf)
+	if (gc->is_pf && !gc->is_pf2)
 		return mana_gd_init_pf_regs(pdev);
 	else
 		return mana_gd_init_vf_regs(pdev);
@@ -2070,7 +2070,7 @@ static void mana_gd_cleanup_device(struct pci_dev *pdev)
 
 static bool mana_is_pf(unsigned short dev_id)
 {
-	return dev_id == MANA_PF_DEVICE_ID;
+	return dev_id == MANA_PF_DEVICE_ID || dev_id == MANA_PF2_DEVICE_ID;
 }
 
 static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -2118,6 +2118,8 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	gc->numa_node = dev_to_node(&pdev->dev);
 	gc->is_pf = mana_is_pf(pdev->device);
+	gc->is_pf2 = (pdev->device == MANA_PF2_DEVICE_ID);
+
 	gc->bar0_va = bar0_va;
 	gc->dev = &pdev->dev;
 	xa_init(&gc->irq_contexts);
@@ -2269,6 +2271,7 @@ static void mana_gd_shutdown(struct pci_dev *pdev)
 
 static const struct pci_device_id mana_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_PF_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_PF2_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_VF_DEVICE_ID) },
 	{ }
 };
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 70d62bc32837..7361e98d94ce 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -418,6 +418,7 @@ struct gdma_context {
 	u32			test_event_eq_id;
 
 	bool			is_pf;
+	bool			is_pf2;
 
 	phys_addr_t		bar0_pa;
 	void __iomem		*bar0_va;
@@ -571,6 +572,7 @@ struct gdma_eqe {
 #define GDMA_SRIOV_REG_CFG_BASE_OFF	0x108
 
 #define MANA_PF_DEVICE_ID 0x00B9
+#define MANA_PF2_DEVICE_ID 0x00C1
 #define MANA_VF_DEVICE_ID 0x00BA
 
 struct gdma_posted_wqe_info {
-- 
2.34.1

