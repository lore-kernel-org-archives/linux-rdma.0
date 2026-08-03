Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020108.outbound.protection.outlook.com [40.93.198.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC81741D208
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773501; cv=fail; b=Kji7S2yIZ8v+M8G07da5Q9epXcvlcSoN5eau/7uJQoG30FytbhGYBgOuV0RRqfbAC+NM85JDIIruOgWHOtXIS00VRzrOebaBxL3wWiZCrqCXNr5xrKg6PKr6fcq06WQL18nIMyja406w/a/k1PNWOm31Vr7fZmN+9DguU8fCJs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773501; c=relaxed/simple;
	bh=Q8UiW6AvXa4mkLBQRiEKTUkTuG6eIEcXQqDF1dFN5oA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oN8/58d4Bk2Xua1tRydzMNc220o+gxqq/FRVvsJsNWWMm12dAmA03Ms4hd3H8xHOhXNhbXar2kQUd8RJJAL8UfywIra3+2Bjzy/hUwYyU81SvTE8S85RtkgpUguOKTWhnyN0RNnhDEwZVXRuNYpGVc8BIR1d+IVzf1cWRf+mDjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=NNXVwsho; arc=fail smtp.client-ip=40.93.198.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="NNXVwsho"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leQpEpAQ+iz9X1nstV+d5SVVRsV2siphmdpb+Uazar7gD3LaSlcc2E4/Ivwui+woboR7w4w0fpUC1d9kXzq4/pDtHHT7SoA3BFYSUM8TQDCOqCQv/QTXH5lTpjDngb+TudT8ejDiFeAH7LsZ1p+KBNqAai3Vbyn/YWqWVMFxjQuLPU5iomdSSTAEoS5acf7s/O3RPXVU/dFNGMKoHE2wvU7vQvWTShoZhSk87+sUYlMONgyi56ST2TR+8INKKFDNVcLWyN1UKiGggcu9CAUXOmb03MyadCw3cNhJsju5qY9e0QO3qMBHWK5oIlQcgLfoeKQSIQV7E4PLpTLrSR3j7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6ql7/6OM6rkKwNW9/IF4k8RjJa4VRiNTc8nl+7uZbQ=;
 b=b/RsdGliaD1k9KAerSL5K9iNnhAJArCDFY0OUTaQkMtgWQn0ka9Pt8KGYJV4iH+QMoaTTYZY6yl+BAMb4cnqtoM6vev/tMiAA7lX9JjFCs6aZnmFfSpajbajgEkA30wIn4vB5lpqGSWdirKSYBhm+bKjYfDym+LTlNvgFc7jXEhR43xZBFxiXn990EQ7x5SuXAk6vun0c7T+6YQp0KCKrxvPPc91hS3Sr2eGpytpLBQ5opKvzScPBtT5E+MAQzFRFMcnClk+7aiLtHb8Fg8GAW7p3UHFumkg/QnZl8/ieUOxbvLMChy9UQhnZm8CTpcKFn5fdqsfs2UPdQP5DOJxtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6ql7/6OM6rkKwNW9/IF4k8RjJa4VRiNTc8nl+7uZbQ=;
 b=NNXVwsho5oQ5BSiX1vvnYEP1JUXRIPwqbWhQctQyYeXAqc2jMavmsVv0PJxUC2MnXxUwfqYFFLzahUObNH25ADAUMpl9bv1+MAtzGquWZ7ozlpgsmfXrHyOMAhcKwSo7k4Fc/MT36G/FCGqzkO9jZRt5Bk2NgK9C+XD/QiefPWzAN81SwkrlnLp0AKId7QhPyhKku1YKHCyAaGg6fXe5c0i9JOWDQRGyHwUNrHP4wZJ5ykr46ekxbNbZrx4PBYGQKPhmWB6/bLcQb1uxZkTSlYkcIUeehgE7iDM2/f1hZhsiHDCWvEW+oQXYiPuv+RcnUQpHtDvIYeAh5ER8sM+oow==
Received: from CH5PR04CA0007.namprd04.prod.outlook.com (2603:10b6:610:1f4::7)
 by LV8PR01MB8479.prod.exchangelabs.com (2603:10b6:408:18c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:11:33 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::36) by CH5PR04CA0007.outlook.office365.com
 (2603:10b6:610:1f4::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:11:33 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:32 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 7F8B51D71C0;
	Mon,  3 Aug 2026 12:11:32 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 7B2EC1810DF01;
	Mon,  3 Aug 2026 12:11:32 -0400 (EDT)
Subject: [PATCH 8/9] RDMA/hfi2: Align probe error unwinding with device
 removal
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:32 -0400
Message-ID: <178577349246.1793053.13693369826252005139.stgit@awdrv-04>
In-Reply-To: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
References: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|LV8PR01MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: a842d20c-9c9b-4c9a-f8c0-08def179e2bb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|6133799003|10067099003|56012099006|22082099003|18002099003|55112099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	7/Dd29iVKwNO9+Fl7+9EL0E0lwymngWolL19fL6+NzyouPlxn2d8iTaCBHmzETIgTsV2fn11IagIpAPT16YBK++hTmULh2uQqDor8rw9o74Uvgd9BbBWPkPASv9kz0+T7zRMAbkKw+zB4AnXo0BCyBhY2GTqhwEZkFrBbpWpn83PeAhpQamfaJ36FHbyilDhaBEXqZ/c3w+iK8MKajS8A1RefXUt8gkd39r0FvGDJEvq5qHbf+T2ThQep6Dv0+pOLN34nYGhD9cd/x9bh1yY0pu6LYPL4jm0z9aF6/dL5ew/f3TvUWUXggwq8KOBIjvYuoPfcv6pRa5CZaOTwB/KjIsWz/lacLRMH6Gkws10QdsZH8pJYd3dLfvq417UeJeihbB6DcbAQQ4Yys3ocXFPRTuq3sudeOb3wwLP1BcxJo7rX/15Mpd9lHFRVyFlfsP+aC+B3C1D0TdHm3MDjCuT+EmnBhFR1AzRDY425GsUol1SoBNdEbIm6ajT3ZMnhwyzUnHow2XDelszjPC5YOXfnqJ1tq3cWc/fgMib5g6hnH8Oe5LVHA7T/kEaX002AWEij7pq3Znb8oA/EEOxyT20HcZoxvG+nfIPhxAS+CY+IXxSRxagdsJjzubrKZHoaQaMR7BXvqJm5pcUWT6DnuCNVmZp7Zaw5LxYwSyTPQSAerJnbA8VtaXt/trZAm/EP4LKtSOE/+sFwQSZYoa91c/3TQ==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003)(55112099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eIhWq9dNUOKIhw+b8CuT2kfIVw4ODkFfVcovMqZ9M3tONHKmzTxXslKJs7zo8VNbJd0AqJamvsrUiTNcipiBI10xEWCjjjOQpdx4NdxJ1chmjDpO1oEa71JG04Ec4vDc2C0EddA3iuj53KRAId1M6quEMLHSMmUz70w5k4rAQ2F3H7Vc8fq9a16TkJdDr0pyz1iO/MSH++JZ79jL820YhAHulfmmlMQO6zHz7cBKSD0R9/MKCR3S+sZiJnJSrXyPhBF8J/mWO0HUs2BpD77D1lDAfaF2M4ESV2G4bLR7ojJXO1F1VqnDQD1Kvt0QId5nocz3NkrU9hk1NCWnifqqNrx3INd91YSuyk3rw7+Ie406FCFty0OgxuXJdh2N9PJOyLZ3hT8MvSNjAww31y0cFwd/ypB17r5dvPaQwQt+zxkxFmUcQvhwi8Y168cuODFZ
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:32.9114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a842d20c-9c9b-4c9a-f8c0-08def179e2bb
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8479

Restructure init_one() to allocate the device data only after PCIe
initialization and early module-parameter validation have succeeded,
matching the order used by hfi1. The rcvhdrcnt, HdrQ entry size, and
eager buffer size checks, along with hfi2_pcie_init(), now run before
struct hfi2_devdata exists and report errors via dev_err()/pci_info()
directly on the struct pci_dev.

Hoist the debugfs initialization out of the conditional success block
so it unconditionally runs only once the whole probe sequence has
succeeded, rather than being nested inside an if-statement alongside
other success-path work.

Unify the success and failure teardown paths in init_one() using a
sequential goto-label chain (free_ib_dev/free_mad/teardown/
destroy_wqs/free_dd/clean_pcie) instead of a large nested
if (initfail || ret) block, mirroring the order used to tear the
device down in remove_one(). postinit_cleanup() is trimmed to only
perform the parts of cleanup that are common to both the error path
and remove_one(); destroy_workqueues(), hfi2_free_devdata(), and
hfi2_pcie_cleanup() are now called explicitly by each caller
(init_one()'s teardown labels and remove_one()) instead of being
folded into postinit_cleanup() itself. remove_one() is reordered to
match, calling postinit_cleanup() before destroying workqueues and
freeing the device data and PCIe resources.

hfi2 carries extra initialization steps not present in hfi1 (MAD
init/deinit, CPort trap setup, per-port stop_port() dispatch), which
are threaded into the new goto chain at the appropriate points.

Matches hfi1 fixes 9f674ba674a0 ("RDMA/hfi1: Allocate device data
after PCI initialization"), bb18740b302f ("RDMA/hfi1: Initialize
debugfs after probe completes"), and e26c48cf23a4 ("RDMA/hfi1: Align
probe error unwinding with device removal").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/init.c |  118 +++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index 12035b21b582..9e71fc8e5979 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -2372,15 +2372,11 @@ static void postinit_cleanup(struct hfi2_devdata *dd)
 	hfi2_release_rsm_rules(dd);
 
 	cleanup_device_data(dd);
-
-	destroy_workqueues(dd);
-	hfi2_pcie_cleanup(dd->pcidev);
-	hfi2_free_devdata(dd);
 }
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int ret = 0, pidx, initfail = 0;
+	int ret = 0, pidx;
 	struct hfi2_devdata *dd;
 	const struct chip_params *params;
 
@@ -2428,22 +2424,16 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -EINVAL;
 	}
 
-	/* Allocate the dd so we can get to work */
-	dd = hfi2_alloc_devdata(pdev, params);
-	if (IS_ERR(dd))
-		return PTR_ERR(dd);
-
 	/* Validate some global module parameters */
 	ret = hfi2_validate_rcvhdrcnt(pdev, rcvhdrcnt);
 	if (ret)
-		goto free_dd;
+		return ret;
 
 	/* use the encoding function as a sanitization check */
 	if (!hfi2_encode_rcv_header_entry_size(hfi2_hdrq_entsize)) {
-		dd_dev_err(dd, "Invalid HdrQ Entry size %u\n",
-			   hfi2_hdrq_entsize);
-		ret = -EINVAL;
-		goto free_dd;
+		dev_err(&pdev->dev, "Invalid HdrQ Entry size %u\n",
+			hfi2_hdrq_entsize);
+		return -EINVAL;
 	}
 
 	/* The receive eager buffer size must be set before the receive
@@ -2462,11 +2452,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		eager_buffer_size = clamp_val(eager_buffer_size,
 					      MIN_EAGER_BUFFER * 8,
 					      MAX_EAGER_BUFFER_TOTAL);
-		dd_dev_info(dd, "Eager buffer size %u\n", eager_buffer_size);
+		pci_info(pdev, "Eager buffer size %u\n", eager_buffer_size);
 	} else {
-		dd_dev_err(dd, "Invalid Eager buffer size of 0\n");
-		ret = -EINVAL;
-		goto free_dd;
+		dev_err(&pdev->dev, "Invalid Eager buffer size of 0\n");
+		return -EINVAL;
 	}
 
 	/* restrict value of hfi2_rcvarr_split */
@@ -2474,13 +2463,20 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = hfi2_pcie_init(pdev);
 	if (ret)
-		goto free_dd;
+		return ret;
 	if (params->chip_type == CHIP_JKR)
 		mask_aer_unsupported_request(pdev);
 
+	/* Allocate the dd so we can get to work */
+	dd = hfi2_alloc_devdata(pdev, params);
+	if (IS_ERR(dd)) {
+		ret = PTR_ERR(dd);
+		goto clean_pcie;
+	}
+
 	ret = create_workqueues(dd);
 	if (ret)
-		goto pcie_cleanup;
+		goto free_dd;
 
 	/*
 	 * Do device-specific initialization.  If hfi2_init_dd() fails, it
@@ -2491,55 +2487,37 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto destroy_wqs; /* error already printed */
 
 	/* do the generic initialization */
-	if (!ret)
-		initfail = hfi2_init(dd, 0);
+	ret = hfi2_init(dd, 0);
+	if (ret)
+		goto teardown;
 
-	if (!initfail && !ret)
-		ret = hfi2_mad_init(dd);
+	ret = hfi2_mad_init(dd);
+	if (ret)
+		goto teardown;
 
-	if (!initfail && !ret)
-		ret = hfi2_register_ib_device(dd);
+	ret = hfi2_register_ib_device(dd);
+	if (ret)
+		goto free_mad;
 
-	if (!initfail && !ret)
-		ret = hfi2_init_cport_trap128(
-			dd); /* after IB device register */
+	ret = hfi2_init_cport_trap128(dd); /* after IB device register */
+	if (ret)
+		goto free_ib_dev;
 
 	/*
 	 * Now ready for use.  this should be cleared whenever we
-	 * detect a reset, or initiate one.  If earlier failure,
-	 * we still create devices, so diags, etc. can be used
-	 * to determine cause of problem.
+	 * detect a reset, or initiate one.
 	 */
-	if (!initfail && !ret) {
-		int pidx;
-
-		dd->flags |= HFI2_INITTED;
-		for (pidx = 0; pidx < dd->num_pports; pidx++) {
-			struct hfi2_pportdata *ppd = dd->pport + pidx;
+	dd->flags |= HFI2_INITTED;
+	for (pidx = 0; pidx < dd->num_pports; pidx++) {
+		struct hfi2_pportdata *ppd = dd->pport + pidx;
 
-			if (ppd->host_link_state == HLS_UP_ACTIVE)
-				hfi2_go_port_active(ppd);
-		}
-		/* create debufs files after init and ib register */
-		hfi2_dbg_ibdev_init(&dd->verbs_dev);
-	}
-
-	if (initfail || ret) {
-		stop_cport(dd);
-		hfi2_msix_clean_up_interrupts(dd);
-		stop_timers(dd);
-		for (pidx = 0; pidx < dd->num_pports; ++pidx)
-			dd->params->stop_port(dd->pport + pidx);
-		if (!ret) {
-			hfi2_unregister_ib_device(dd);
-			hfi2_mad_deinit(dd);
-		}
-		postinit_cleanup(dd);
-		if (initfail)
-			ret = initfail;
-		goto bail; /* everything already cleaned */
+		if (ppd->host_link_state == HLS_UP_ACTIVE)
+			hfi2_go_port_active(ppd);
 	}
 
+	/* create debugfs files after init and ib register */
+	hfi2_dbg_ibdev_init(&dd->verbs_dev);
+
 	hfi2_sdma_start(dd);
 	hfi2_init_cport_overtemp(dd);
 
@@ -2547,13 +2525,24 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hfi2_vf2pf_ready(dd);
 	return 0;
 
+free_ib_dev:
+	hfi2_unregister_ib_device(dd);
+free_mad:
+	hfi2_mad_deinit(dd);
+teardown:
+	stop_cport(dd);
+	hfi2_msix_clean_up_interrupts(dd);
+	stop_timers(dd);
+	for (pidx = 0; pidx < dd->num_pports; ++pidx)
+		dd->params->stop_port(dd->pport + pidx);
+	postinit_cleanup(dd);
+
 destroy_wqs:
 	destroy_workqueues(dd);
-pcie_cleanup:
-	hfi2_pcie_cleanup(pdev);
 free_dd:
 	hfi2_free_devdata(dd);
-bail:
+clean_pcie:
+	hfi2_pcie_cleanup(pdev);
 	return ret;
 }
 
@@ -2613,6 +2602,9 @@ static void remove_one(struct pci_dev *pdev)
 	stop_timers(dd);
 
 	postinit_cleanup(dd);
+	destroy_workqueues(dd);
+	hfi2_free_devdata(dd);
+	hfi2_pcie_cleanup(pdev);
 }
 
 /*


