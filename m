Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021130.outbound.protection.outlook.com [40.107.208.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F247361948
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773496; cv=fail; b=ORb45omZCvmE1PWRqAFmKfXMF4iX1mtYtzDF0T2Mmqupl0R/9HVgKAKrfHdRuMNuDWVEkRXlFLOe211op9wINq/rilTOI8E6WGmt+e7CUQ4EXIIvGefHuB0fJ+AojYk45RS9F87LphbALGF4VZNJE8lKJK8SOJaq+Rv1nYp+9DQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773496; c=relaxed/simple;
	bh=Mc9N8IIoIKvpSEQJeL3UWIg5yoGpWQ2AGkGgpCFYHQs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9pVPTCLHvwj3CZp2dimYFrQo4VvTGwNGq9/r4FowaT03NAVuAFkLd590iduD2V6GtN16zhNx4hC1ZjTWr8V2RidIZ0zUvDiiYTFIf6e32vubTEHt9bQA9zyBORE46FGDAe8BaTy2Ji7Zh0kkbAFwIYAXUY1NU86QbXl19E2iFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=ZqIH4S10; arc=fail smtp.client-ip=40.107.208.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="ZqIH4S10"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvypgO8UyOieHeYBPB4fAakorkzm4ICS/xtqvZhvQbtwolt26a4+S/5yKctSSYplIknrWY3yQxF8WCfu8VpHrj1L1SVIoZtvCgJYgjqEHwXQ2o/KbSQkTUQGOIR2eVwcr8KINGW9Se1ux4GIs5lNfaRU3cMwx8XUr06lTgiC8ZJo7KIZz+5+OvJYWkahIQBV2EsrqqNaDeWszOIKsXHyKQr/vUE9XE1G+EDrOA4FPHwF1cEDki4C8+RS48OBikgF8nKMN86v86YOOpJYeIC0ChGsaANGFkhiFOfaLeES1dl1L32ysmVS1Wwm595naYtPD11JomdzSoDwukY0ncH1Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0j69pr+hpuy3lhSVnuVPu+0pZGRsWnon4P6SrWbWyU=;
 b=SPlgu/JVvhCcvdnFZAPcF5RGnUt9owkXrUK+OZLWsLrVsSudsejqjTfLLDso40f29HxBkDuvU9sJLcOeFiad8MWEtiK3vxCfMwLSH/OKUJEjML1eEXip74Qr6PRNxCeqYvJwx6ouA3r9bYFgDJSokbhJhHm1+dc63VnuUhm0GXIeDyNFUFvnvP/lJjY5z/KhIf/VW6ZeOXbSSQqL0jHmjzUj8xGN/9tEIwz/0EqR6dxwZwOdEGTPFwmMMcsgjSXqbdOECk9/wI+4Lj86N0c7WFxZtSI5GCFCxhh1+FNJvJWDXUt1WYvw/1hghrLFMqsGkByITL9xdwDPWHAICv3GMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0j69pr+hpuy3lhSVnuVPu+0pZGRsWnon4P6SrWbWyU=;
 b=ZqIH4S10yDXVz2luagZn1nVfG94NIpGzyVlKe+e/wMsJ/nY8ZNuijrjUu6tcDQxSeM5Vp3EAkdWwEqcmH/WLIq7fo8nQWUMH59Ee/cnqouzuS5Rog6BJX9CxHftUCM5vmp4iXCSpDQnemyVSe4i1M0l6cKxpy0HiW8gplS1pgtunWVMdeKr10lN+DTPIGtPKYMy9lqlo0jRqixHjsFxw4BT+2P3HGDxSQC698Sb2O1WpFUTE6hKNgqhvyXBuYmHlng/9/imdvW9+NybTvNOsc4ulwLNmhyyFCbbmezizRlEM8yb4x/wgdOyKhIMEt1sn+2f/ZoUIkVjAf0q1HxdpoA==
Received: from SJ0PR13CA0030.namprd13.prod.outlook.com (2603:10b6:a03:2c0::35)
 by SA1PR01MB8062.prod.exchangelabs.com (2603:10b6:806:335::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Mon, 3 Aug 2026 16:11:28 +0000
Received: from SJ5PEPF00000206.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::9a) by SJ0PR13CA0030.outlook.office365.com
 (2603:10b6:a03:2c0::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Mon, 3
 Aug 2026 16:11:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 SJ5PEPF00000206.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:28 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 754281D7180;
	Mon,  3 Aug 2026 12:11:27 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 70DD41810DF01;
	Mon,  3 Aug 2026 12:11:27 -0400 (EDT)
Subject: [PATCH 7/9] RDMA/hfi2: Drop device data from
 hfi2_validate_rcvhdrcnt()
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:27 -0400
Message-ID: <178577348742.1793053.6416513242041155702.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000206:EE_|SA1PR01MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a20a7b5-b750-4d69-a314-08def179dfed
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|23010399003|3023799007|10067099003|56012099006|22082099003|18002099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	FD/nXU8Gmx1xRN3s8y6DKY6hC2mBCENeA3kk58Sgp5EM6aesWwaOXYDeYQevutuewe9HlXu5b0cs7sMCw+pviV6NJJnE50+BGMcXo6ibgY1EVmIps1hWPn+B+nKLH33K4GDCvk1gs7Hps8JyHQF6JN/5cPjLgQc/07P0LRAinQAmKuNrpHogRcOs9GR8z6M/BkKSTHLSFz1kpoBU88aQJ1PNtIXjbw2Zow37b9guY3b8X7wpsepODFVhHfRXrlaDP8ys417sYNkcOfKcKl4fotWQalAN7vRqqzGDevnw0DgPjerDj85pdnahL631vpj85NM2usUJR56UrfOByS+mQmLVM/+dW2HCs2stys26rwoGGCmfn6vtg01sF/hNkEvon/vmaVvKeDNDub98OJnzBkA2bnLw7WQhRmawYBUYzIfrAf+nPw0s9jz7R4XfOopQHVqYsfo22t3hyDMItVRUN2WcrNy062PbpXYjMrva4iiO6IXQr0w/QUULddaz/oUyMLR0qFgZv2ddF2RgWnCPSXbHyohZxAHyymAg4ElV5sv21eqV7Ifzz1JXKawgCV1DIkH2s7N9fRBKGwXOCpscsRDgCoURAH4vxQsmS9qOT/bbGcrL0BeAsMCRD6Z7hNfASGjwG3g7ky1bXnyKqiAk3Rs3TLtFyPaWkOL3xOYEwh1IRHecYn7bxMSQ0eU6+gN0
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(3023799007)(10067099003)(56012099006)(22082099003)(18002099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BsqlXNvc6vn3Fz9CLdw9MuiwxsieW8EfznRaB2cw6Ktfis8aaM+YfbukbLfjf9StrK6sm64jQFkOSt9aA8bTd4ZHJb3IvIiZafnETypf6ML4bT0mei7OsE4skTjzFhVGG82KWOWA/hOyjkmjUpTp2eurugPx/cbRuF/3XdMFiDgbqMEtIsvg3yXKMIXwf7IdCOW8RjnTshH8wMC3guKjFbm468+T/89fctzwjvYNwICIMrTGMzTtHBVFXI8FnD6jeTYtv/jtTcfYBQlebtCrSIk4BdeXuAgBIsBQwYlzqogeYVoUxT+foMxgFm7K81F7hEoiSaZ/2iu/dW/CJcZZnYz4SZlZ3OaQPSAo6wF+337XPo2gcVXS1DGPvo3IpMf7//Y446kOZp3zC5jsA4xX5rJK6by1asayRIBB7BAJ9fTj6UBlz2fWDahK6MDe4hPr
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:28.1578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a20a7b5-b750-4d69-a314-08def179dfed
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8062

hfi2_validate_rcvhdrcnt() only needs the struct pci_dev to report
errors, but currently requires the full struct hfi2_devdata, which
does not yet exist at the point in probe where this validation is
desired to happen. Change the signature to take a struct pci_dev
pointer directly and switch its internal error messages from
dd_dev_err() to dev_err() accordingly. Also fix a latent %d/%u format
specifier mismatch for the unsigned thecnt parameter in the
divisibility check message.

Matches hfi1 fix 4ebd241071af ("RDMA/hfi1: Drop device data from
hfi1_validate_rcvhdrcnt()").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/chip.c |   14 ++++++--------
 drivers/infiniband/hw/hfi2/chip.h |    2 +-
 drivers/infiniband/hw/hfi2/init.c |    2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/chip.c b/drivers/infiniband/hw/hfi2/chip.c
index 64489c117b65..b46dd5cea5de 100644
--- a/drivers/infiniband/hw/hfi2/chip.c
+++ b/drivers/infiniband/hw/hfi2/chip.c
@@ -8213,28 +8213,26 @@ u8 hfi2_encode_rcv_header_entry_size(u8 size)
 
 /**
  * hfi2_validate_rcvhdrcnt - validate hdrcnt
- * @dd: the device data
+ * @pdev: the pci device
  * @thecnt: the header count
  */
-int hfi2_validate_rcvhdrcnt(struct hfi2_devdata *dd, uint thecnt)
+int hfi2_validate_rcvhdrcnt(struct pci_dev *pdev, uint thecnt)
 {
 	if (thecnt <= HFI2_MIN_HDRQ_EGRBUF_CNT) {
-		dd_dev_err(dd, "Receive header queue count too small\n");
+		dev_err(&pdev->dev, "Receive header queue count too small\n");
 		return -EINVAL;
 	}
 
 	if (thecnt > HFI2_MAX_HDRQ_EGRBUF_CNT) {
-		dd_dev_err(
-			dd,
+		dev_err(&pdev->dev,
 			"Receive header queue count cannot be greater than %u\n",
 			HFI2_MAX_HDRQ_EGRBUF_CNT);
 		return -EINVAL;
 	}
 
 	if (thecnt % HDRQ_INCREMENT) {
-		dd_dev_err(
-			dd,
-			"Receive header queue count %d must be divisible by %lu\n",
+		dev_err(&pdev->dev,
+			"Receive header queue count %u must be divisible by %lu\n",
 			thecnt, HDRQ_INCREMENT);
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/hfi2/chip.h b/drivers/infiniband/hw/hfi2/chip.h
index cf25ea55aaec..b01ec9221992 100644
--- a/drivers/infiniband/hw/hfi2/chip.h
+++ b/drivers/infiniband/hw/hfi2/chip.h
@@ -610,7 +610,7 @@ bool hfi2_wfr_check_synth_status(struct hfi2_devdata *dd);
 void hfi2_wfr_update_synth_status(struct hfi2_devdata *dd);
 
 u8 hfi2_encode_rcv_header_entry_size(u8 size);
-int hfi2_validate_rcvhdrcnt(struct hfi2_devdata *dd, uint thecnt);
+int hfi2_validate_rcvhdrcnt(struct pci_dev *pdev, uint thecnt);
 void hfi2_set_hdrq_regs(struct hfi2_pportdata *ppd, u16 ctxt, u8 entsize,
 			u16 hdrcnt, u8 kdeth_rcv_hdr);
 void hfi2_wfr_update_rcv_hdr_size(struct hfi2_pportdata *ppd, u16 ctxt,
diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index 71ae134b5e86..12035b21b582 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -2434,7 +2434,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return PTR_ERR(dd);
 
 	/* Validate some global module parameters */
-	ret = hfi2_validate_rcvhdrcnt(dd, rcvhdrcnt);
+	ret = hfi2_validate_rcvhdrcnt(pdev, rcvhdrcnt);
 	if (ret)
 		goto free_dd;
 


