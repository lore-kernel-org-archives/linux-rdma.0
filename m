Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAD930E82B;
	Sat, 27 Jun 2026 06:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782540432; cv=none; b=a+e5UZ4CQzHKY9W1mSYDPuHyvLQUXdMQxI6jG+Gf06ESXLR9wEq3jotwiA4BPiwf3JmK+MtfKPcXiPBaCGUfrbXc91ZlmXprTuDS4M6hs8hB7mu5+ZuN+3PMiLpMjrXP4E0JCT0NveO/OysLg5YPqwQg0IoVvsJIUCccqknIdJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782540432; c=relaxed/simple;
	bh=Jbq2smD76uDhQqEo+EhjpEeCD41ErGjiAo/Q9+30X5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZpaiymTMDcjXw67vSF+e0x4jRO83vyxEx8IqtOOFJetDpnCAWtxHZZkuRI0VSgG3jFVYy/++PQYkvDyHm44VaUBGtYa6fLkggnQSTC28E+a6r1mlGiv4MrFO0mjVCvpdPDg9CiTC6hpb/NeOE4y09iyTf0QDjjwEwKls7y/PbVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=ih74ZbeP; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="ih74ZbeP"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 43fb57347;
	Sat, 27 Jun 2026 14:01:59 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: dennis.dalessandro@cornelisnetworks.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	zilin@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>
Subject: [PATCH] RDMA/hfi1: fix init_one() probe failure cleanup
Date: Sat, 27 Jun 2026 14:01:59 +0800
Message-Id: <20260627060159.2543686-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f07abad7b03a2kunmf6242eaaebeda
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTB5DVklNSRhDT0hNSUkZHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=ih74ZbePIOibdvNPJarGrXwRYyWKQp01mqOH1rsj3F/AQsQ57cLVt5a3z2oG0Xe9Z+lNhL3Ist3mPFsm/5I7SEQJvM1F37ghfjItrP3KlIAt0MwIl135e4d3X848y6S5wU3/VrM9nK8+cFUcMLFYIVpxX3G88VE6SQ6v6v933OQ=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=rvwuCNXxNLyidJGbUSeXkXFsdXXIEKk9dqf4DdETe6Q=;
	h=date:mime-version:subject:message-id:from;

init_one() allocates hfi1_devdata before validating several module
parameters and initializing PCIe.  Failures in these paths currently jump
to bail and leak the devdata allocated by hfi1_alloc_devdata().

Probe failures after hfi1_init_dd() need a different cleanup path.  On
failure, hfi1_init_dd() frees devdata itself, but after it succeeds the
driver also owns RX state and MSI-X interrupt resources that must be
released before postinit_cleanup().

Fix the early paths to free devdata directly, keep the hfi1_init_dd()
failure path to PCIe cleanup only, and release MSI-X and RX resources on
post-hfi1_init_dd() failures.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
HFI1 adapter to test with, no runtime testing was able to be performed.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Fixes: 57f97e96625f ("IB/hfi1: Get the hfi1_devdata structure as early as possible")
Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 drivers/infiniband/hw/hfi1/init.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index b7fd8b1fbbbd..09fc71891e4c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1590,14 +1590,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Validate some global module parameters */
 	ret = hfi1_validate_rcvhdrcnt(dd, rcvhdrcnt);
 	if (ret)
-		goto bail;
+		goto free_dd;
 
 	/* use the encoding function as a sanitization check */
 	if (!encode_rcv_header_entry_size(hfi1_hdrq_entsize)) {
 		dd_dev_err(dd, "Invalid HdrQ Entry size %u\n",
 			   hfi1_hdrq_entsize);
 		ret = -EINVAL;
-		goto bail;
+		goto free_dd;
 	}
 
 	/* The receive eager buffer size must be set before the receive
@@ -1622,7 +1622,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else {
 		dd_dev_err(dd, "Invalid Eager buffer size of 0\n");
 		ret = -EINVAL;
-		goto bail;
+		goto free_dd;
 	}
 
 	/* restrict value of hfi1_rcvarr_split */
@@ -1630,7 +1630,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = hfi1_pcie_init(dd);
 	if (ret)
-		goto bail;
+		goto free_dd;
 
 	/*
 	 * Do device-specific initialization, function table setup, dd
@@ -1642,7 +1642,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = create_workqueues(dd);
 	if (ret)
-		goto clean_bail;
+		goto postinit_bail;
 
 	/* do the generic initialization */
 	initfail = hfi1_init(dd, 0);
@@ -1685,6 +1685,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
@@ -1695,8 +1696,18 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+postinit_bail:
+	msix_clean_up_interrupts(dd);
+	hfi1_free_rx(dd);
+	postinit_cleanup(dd);
+	goto bail;
+
 clean_bail:
 	hfi1_pcie_cleanup(pdev);
+	goto bail;
+
+free_dd:
+	hfi1_free_devdata(dd);
 bail:
 	return ret;
 }
-- 
2.34.1

