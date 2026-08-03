Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022110.outbound.protection.outlook.com [52.101.43.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88E534FF78
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773489; cv=fail; b=r3XhQwlCUJdaqUrJ8ZKsvraFYvoXaHmq6CM5fboVMj9yMMvhZRbCLcrrsxpN9llcEk+U53C+zhDv/0zQpB22EXW4ItvFVQe853ko5EA+TCfPIObjEglxlTmTmUYMfBQiAX6grLzQCPpE/wOGDOwHFX3GaM0WLTTN6pIZzNxA2uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773489; c=relaxed/simple;
	bh=d4AYJ3J08Cn+Lic1CHY7T/W3sl9kNpYzlX/6Smu/OkM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ffLre7Lrn0JHrcGCifcIwVRDyun04tkYaCaCT+rY8ZZsuAPohovLlj1mYWvNdwWFYlgZRlruM6Zg+5kwKzQl38Bp40raSggr1r1wFcupkVVEgvzHiZeoH6jBlFJsdCbt2Ti+wvZ7UnHrw6dKCPWXWGuX2ZWgRSTwrwDoGcOR2Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=bDiy3PD2; arc=fail smtp.client-ip=52.101.43.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="bDiy3PD2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsU1npbZNCjBGmeHhdInwFgWkSqZOSQs9ZKUQJWHCUjWQFl4rm4BOT7M+pKfgrumSBx9oRRdEltmxv8VGwaGzj+yoQeEmLigv4GOD384qYofim62mcoHqyzOvFvtKYuODA/S/pCdScRH4v50FwaRE/bXuHWdCs2yVnuyYLLlRdt5iplm/JlBybmflENqgkXtOG4NYllIfTy9WcNs2g17oRKF2swoYqkFzwZM2Gvv0LnPPvw5YXwtXreNjfEkFD8UkhPgnK2LHOo86kMs3PHLhGWaPYNzNHOprnky5IMWqXxe0Uuz1EAnPBimLrg1x8x1L7LcU7q3t/TIkQpBYvg2FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpCNhg1Aw6TQAzbsvpifXMuZYUgVUOIlQGpyBwxn+T4=;
 b=wG2pRQ/cipJgeqtzrNQ1FohlFjIwOOPJuPStmhQMzHWO9Lx5OHJBUlI5j5+drJJux5kl+QOq3LgCsTsev+EgLKXRyspSmfUvb/xxt/r6eOjJvyY2xHkEE0wBTAQqSMws9vLBZYawTTen/0V3B2aSn5Rq5ddihBcTOFfoVSUowFyWv0DZWZCwhsdJQFTVsHmcRXmwLz4e3eCtQsBdQToOQLHhZv7NDQBT9cx2NBS9O8SLRcvifOh1rMuU5jMBv1CuVbByCmXyyNuCpmZmk0+TLhHpbzP/tRUl2cdLjG7U50I+1SSUxLTxBsYAGFFeQPYDbcIXnN7gncB8t2W/MqC13g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpCNhg1Aw6TQAzbsvpifXMuZYUgVUOIlQGpyBwxn+T4=;
 b=bDiy3PD2dqb3Si/quyLu4NlRzwoXeZVDIA37Y8Xjjz65hMEJAyCdRTWw+LJQmZJ/AyPfFMCGIncxRSbt7jvaa0LriR54nUjNbU/6yDnbEuzF0MaYJNnWNnYXboK891Uk9/nkuYXrJisBSe2u8sXMgrUpZG1J3ZIQxyM9lcueasXZuQl92L2veV5REWS/Yh6JrG96tvUxrUwoc54z3pquydH+eHRvOqBt6J8jk/Ji8iRxP4rhztpipz1/8urU/2GyboaWiMpIu9d9O2OwdaMesrHXitbhDjXmsUo0lk2ddGdHy8aL+vAgvvmr0zLmCaEDJ+iPa0HOT4CUvmaD+lwiUQ==
Received: from CY5PR22CA0023.namprd22.prod.outlook.com (2603:10b6:930:16::6)
 by DM4PR01MB7785.prod.exchangelabs.com (2603:10b6:8:68::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:11:23 +0000
Received: from CY4PEPF0000E9CE.namprd03.prod.outlook.com
 (2603:10b6:930:16:cafe::af) by CY5PR22CA0023.outlook.office365.com
 (2603:10b6:930:16::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:11:23 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 CY4PEPF0000E9CE.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:22 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 69F081D71C0;
	Mon,  3 Aug 2026 12:11:22 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 64E371810DF01;
	Mon,  3 Aug 2026 12:11:22 -0400 (EDT)
Subject: [PATCH 6/9] RDMA/hfi2: Pass PCI device to hfi2_pcie_init()
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:22 -0400
Message-ID: <178577348237.1793053.5744992854633842264.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CE:EE_|DM4PR01MB7785:EE_
X-MS-Office365-Filtering-Correlation-Id: 20925f88-05a0-4947-e6db-08def179dcca
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|56012099006|10067099003|6133799003|55112099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rLxLFlb80QqQe2Gqb8lNRvgNPL1JVAbx1SywKX+CoNJlQX2TM7fmgHkylh4Wm24mMg6csxdTfjvPJr94s4jcBnlx5909OUZZb0q8DrL2Oc/l1CFfvnReRP407yLm/uwTULPrb4E+AYs52bFHra3KipMo/IbPo176E/zsFmZpzW6UG/UMd45hk3lcheDnZNHJJtsV35d92gKQ/kiT3QmH4GcrdOB5VMEeXfM+SxSY0ZnzQLg5NLu5MS5ryAKdt8oZO49czfXgVnotgYFJst6ZU4jL+/dYCr7WhX6AbaJ4HnEfDDecB6MXV2hI+ps8ZP8+RKnJevg5YydqmecQ59Oa8jhe4VQU3Eo7XWBsxIl6/r4w3GNbX2h1bIUIuvA8w901D+pirElgxZxS1iHRt/GVkbeHcxyQyQx31HmFDcy8bSP/eLuFwY2MkymJxG4MIfSoBAbJVCf68/j7kCumYMc0k0/BHqPy5F8it2//twfmWR/9E0CFwMDLu7vqyX/qtBVKTQZCPOJY2k65T3uX3iumIWAkNJip/620Rt5v0q2Cz7gqXHxwz8i96EIhl9dG1ceXmOl3hE5WXRccKuNhk99O5GTvXrJqnIgTXrfwDpRRtE5QDp6p5Qa1tmP2QrZK1yPjPmyi0x0+9L/w0s7o2i4bjkl/T8x0x/c+8X7ecGpWimroMCYOAJbMPXvgW1LxJddfyC5DDdj73T1/WDiGEM8/jA==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(56012099006)(10067099003)(6133799003)(55112099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ot9qwfKibIToCGuPL1WHdfcs3Iloj7Q0/e4P8NCHEmsLBC25a6aHnk9fsiJEcVmCLl8oTfvp01cB4oRyS+82lvmig//9gBx4VGGy2qOcUp7vo4A5tXEGq9ZF+2EOtBk8+pgcYGeiB8m5lOa66Y5iQxWgB9cISFqbIj7MvbDgs0kJI7ee70AH41fcbY/SCVeFan6Qsx/VmdELgrnVraTIu3V5z0rhQrQQ1LcYsNx/PQX7ZQulbmG/lz9wpMQqRfTm3LF00MJXAOI2dCEpkNkezxI0CY/QoUXZZAr3KBH7wzDEB2tWPWfyei1347ZnKH+vIyaUgrTGo2ruRRqcFR3Ev4bb1O/p/TelC1n5f2vbLyiADBRkmf3iee1grCPQAZzztnX/yR9JDf0jABgMTZRBrA2u9KAVl/t4/HHUzEOrpSsfNLjFt1iSAOhF37+bY7vX
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:22.9368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20925f88-05a0-4947-e6db-08def179dcca
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR01MB7785

hfi2_pcie_init() only needs the struct pci_dev to do its work, but
currently requires the full struct hfi2_devdata, which does not yet
exist at the point in probe where PCIe initialization is desired to
happen. Change the signature to take a struct pci_dev pointer
directly, and switch its internal error messages from dd_dev_err()
to dev_err() accordingly.

The JKR-specific AER unsupported-request masking call, previously
made from within hfi2_pcie_init() using dd->params->chip_type, is
moved to the call site in init_one() where dd and params are still
available, and mask_aer_unsupported_request() is exported for that
purpose.

Matches hfi1 fix b9cb5e81f7d9 ("RDMA/hfi1: Pass PCI device to
hfi1_pcie_init()").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/hfi2.h |    3 ++-
 drivers/infiniband/hw/hfi2/init.c |    4 +++-
 drivers/infiniband/hw/hfi2/pcie.c |   22 +++++++++++-----------
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/hfi2.h b/drivers/infiniband/hw/hfi2/hfi2.h
index 32a755c0d3d0..0939c45e51f3 100644
--- a/drivers/infiniband/hw/hfi2/hfi2.h
+++ b/drivers/infiniband/hw/hfi2/hfi2.h
@@ -2610,7 +2610,8 @@ void hfi2_verbs_unregister_sysfs(struct hfi2_devdata *dd);
 /* Hook for sysfs read of QSFP */
 int hfi2_qsfp_dump(struct hfi2_pportdata *ppd, char *buf, int len);
 
-int hfi2_pcie_init(struct hfi2_devdata *dd);
+int hfi2_pcie_init(struct pci_dev *pdev);
+void mask_aer_unsupported_request(struct pci_dev *pdev);
 void hfi2_pcie_cleanup(struct pci_dev *pdev);
 int hfi2_pcie_ddinit(struct hfi2_devdata *dd, struct pci_dev *pdev);
 void hfi2_pcie_ddcleanup(struct hfi2_devdata *dd);
diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index ac5004cabd09..71ae134b5e86 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -2472,9 +2472,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* restrict value of hfi2_rcvarr_split */
 	hfi2_rcvarr_split = clamp_val(hfi2_rcvarr_split, 0, 100);
 
-	ret = hfi2_pcie_init(dd);
+	ret = hfi2_pcie_init(pdev);
 	if (ret)
 		goto free_dd;
+	if (params->chip_type == CHIP_JKR)
+		mask_aer_unsupported_request(pdev);
 
 	ret = create_workqueues(dd);
 	if (ret)
diff --git a/drivers/infiniband/hw/hfi2/pcie.c b/drivers/infiniband/hw/hfi2/pcie.c
index e085b8cae020..b5b637fb6011 100644
--- a/drivers/infiniband/hw/hfi2/pcie.c
+++ b/drivers/infiniband/hw/hfi2/pcie.c
@@ -34,7 +34,7 @@ static int pcie_compl_to = PCI_EXP_COMP_TIMEOUT_RANGE_C |
  * Prevent upstream errors from being reported if a software stray read
  * occurs in a write-only BAR range.
  */
-static void mask_aer_unsupported_request(struct pci_dev *pdev)
+void mask_aer_unsupported_request(struct pci_dev *pdev)
 {
 	u32 mask;
 	int aer;
@@ -52,10 +52,9 @@ static void mask_aer_unsupported_request(struct pci_dev *pdev)
 /*
  * Do all the common PCIe setup and initialization.
  */
-int hfi2_pcie_init(struct hfi2_devdata *dd)
+int hfi2_pcie_init(struct pci_dev *pdev)
 {
 	int ret;
-	struct pci_dev *pdev = dd->pcidev;
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
@@ -71,19 +70,19 @@ int hfi2_pcie_init(struct hfi2_devdata *dd)
 		 * about that, it appears.  If the original BAR was retained
 		 * in the kernel data structures, this may be OK.
 		 */
-		dd_dev_err(dd, "pci enable failed: error %d\n", -ret);
+		dev_err(&pdev->dev, "pci enable failed: error %pe\n",
+			ERR_PTR(ret));
 		return ret;
 	}
 
 	ret = pci_request_regions(pdev, DRIVER_NAME);
 	if (ret) {
-		dd_dev_err(dd, "pci_request_regions fails: err %d\n", -ret);
+		dev_err(&pdev->dev, "pci_request_regions fails: err %pe\n",
+			ERR_PTR(ret));
 		goto bail;
 	}
 
 	pci_set_master(pdev);
-	if (dd->params->chip_type == CHIP_JKR)
-		mask_aer_unsupported_request(pdev);
 	return 0;
 
 bail:
@@ -843,7 +842,7 @@ static void pcie_post_steps(struct hfi2_devdata *dd)
 	 */
 	for (i = 0; i < NUM_PCIE_SERDES; i++) {
 		hfi2_sbus_request(dd, hfi2_pcie_pcs_addrs[dd->hfi2_id][i], 0x03,
-			     WRITE_SBUS_RECEIVER, 0x00022132);
+				  WRITE_SBUS_RECEIVER, 0x00022132);
 	}
 
 	hfi2_clear_sbus_fast_mode(dd);
@@ -889,9 +888,10 @@ static int trigger_sbr(struct hfi2_devdata *dd)
 static void write_gasket_interrupt(struct hfi2_devdata *dd, int index, u16 code,
 				   u16 data)
 {
-	hfi2_write_csr(dd, ASIC_PCIE_SD_INTRPT_LIST + (index * 8),
-		  (((u64)code << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_CODE_SHIFT) |
-		   ((u64)data << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_DATA_SHIFT)));
+	hfi2_write_csr(
+		dd, ASIC_PCIE_SD_INTRPT_LIST + (index * 8),
+		(((u64)code << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_CODE_SHIFT) |
+		 ((u64)data << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_DATA_SHIFT)));
 }
 
 /*


