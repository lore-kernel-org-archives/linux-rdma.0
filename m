Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022079.outbound.protection.outlook.com [52.101.53.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B8636EA8D
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773480; cv=fail; b=BqYuTVzCNUt/Andabh/7zLMCmbYKW9i52fOO9+tJO/VK5ryhGVhXuB2VnNkkqrb25qZS8P5dqqoHflseps1ugXy47f7YINGsY32wEEAGL0I7TuQiGWU/qmV09emyVE/9BiMoNZUfXhsfc00/o7G3eDT5Qo3uAKtda7m93PrB/Ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773480; c=relaxed/simple;
	bh=kYSYvE2yogcLyhyChak7mGyPNUxQlRVxF6gaIlNIlww=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdayhW1b2rzk+Df4sr6NAvyKNKaQdSsMlS3u+sr5jsZsaCSGmmwDO3JAEYq/iiohljqEl0M/Hofe32lf4zyr4kef5XXdbXDh+FXDmapoP4BgGEmif0qezo4LbVXGjQYTRZjPTEpcucNcNRjwZWP0gok+ikB8kcfYx8siNDkmViU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=Mr2T46Wc; arc=fail smtp.client-ip=52.101.53.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="Mr2T46Wc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cT8yCRvwNLEUX202CaJWRNNZjkgM0VlKNOzqEqHnNs3jHekkrknCLHiy5DvxUSKWTWI82VrIrW+28Qif1Q6dmXPhHM+wXdC4HR2X/ypf3GfAr4tBUHnNtjLmXBPj9YKYy9dreeklWoj795adXhh17RTGzu+zSFGwCfc4VOQesG3oMBoHB2Hf4m0WbDqvoMTgeQ2xWXATFSgtKOZhreFibGCxzbO0y4Ij6z5dUZ5dB1h6+j3ZdVdbICl8GnvsbFNKjapLgrBWlOSULEduMaMQl4B0vSTGN3yLdT5J9FxRETFOsL9KoafNKqUBKjeFB4KWFAgm54bafAZ4VldZfjCyew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rzjsy/0oXTQwhXRzmH/9ACK3vD34u9J9UxLka6sbWgw=;
 b=AR3k5Q3jgWlPZD7APD8McmXnHW0H9rduWj7fbKVTIEf7RtvDdTrVHIcjcdqyMAphKrSQSKtnYk+XkAuvG/8C2oDckvFrjFn8Y75fsHnNfWUGAuc/nYICo4X58YyXfsvvNhEQIfRLLpPDJeDTYDIycI60/x+k/MTytZemkeyRnnfjp6ouGewfbuycQ7yksoymjrMMPswoiTgiUkoLD9ykOA+UsdMYnVxmojQRQ34Ek3mjwNvUQpR29/6yWTMtGbB5J7IUZVqjY9yZ7BEtyjVRK1sWMNmlTSdseH39bR0c6ssK/3tsj6M5JFni7vIP5/Pcla/dilcMAC+KDs8uh9+q6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rzjsy/0oXTQwhXRzmH/9ACK3vD34u9J9UxLka6sbWgw=;
 b=Mr2T46WcrU5eQHKGEw/9IK9L6xmbF4YZOYCLQMH0mOPKu72XGjTw5LhrpvvtJEbdztjhMcjnQMqJw35XgM91B8jkAM8/c2g3a8vI3FzuopSqsYDpmOTPhJg6CaVOuSE2/mx6VjhS59zeGiAUlG0xlDoaB3SPVvNqDe3xV3RX5t0LTLv7XDYttLvR4aK9NL33V8tgNXjpzIBU6CpoAqE85rBp9MU1jpkrdAQsgIMR2arIny/2zfYNWZkwFo5RTq3+9RJMuu5HMZb5QsHtMg95Ov2MLAFkH00Eegg1JqFV9wTY9acOC+MlB32Y6FmAtZJB9aqhIgy90O/KIUdhaztSaQ==
Received: from BN9P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::15)
 by CH0PR01MB7202.prod.exchangelabs.com (2603:10b6:610:f8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:11:13 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:408:13e:cafe::ad) by BN9P220CA0010.outlook.office365.com
 (2603:10b6:408:13e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:11:12 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:12 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 52A4E1D71C0;
	Mon,  3 Aug 2026 12:11:12 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 4DBE71810DF01;
	Mon,  3 Aug 2026 12:11:12 -0400 (EDT)
Subject: [PATCH 4/9] RDMA/hfi2: Remove redundant NULL checks in
 create_workqueues()
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:12 -0400
Message-ID: <178577347228.1793053.7899266546478488225.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|CH0PR01MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 39fb7291-130f-411c-08e0-08def179d683
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|376014|56012099006|10067099003|22082099003|18002099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	H/gByVBepPk5NgNWgPtUmQolZ79c1s+WLntisvXrZW+O83/hhzWmEEpLqRTroEJieJ2bcSRZo6kTUU7WEUyrkEZHO5r3piF8iM46PL5Lxhx+CRl+6ZY7MiJ7g4hFuUk1EBDXv3nLt05eW3LX7OFZBB/mYo+hyEoPS0rO+0r4A2+RwErA9ni2IRTm6F5r08LWwru0O4Wn9MwouH+SfGm5+8qeG1um8sYH+YujpwCV7jtGE0/wKvGeCa5mWsnmNzs5zppNQAyPbDgpQDM2ZDDMtk6MaYcAnOlHPyRyGX6ncrL+NI/7oCzeTkhUjTCwaTnvAk9rF24R4XXefttr/vaEfziNzyLM43IcsDg/SLhJkUoo4R4vbyP6+Da8FJTyCFb80rJN6kvpaC1VCMk5De674RLylpKro9JNiGcAba28SgikV+P0rVlG7PhroiXyThoRxO+22nGZgRxi2CUDymsf1DqPjTMuGyDQRaYOPjiNrketDItAT7h+uBtLBeZxthjmvSMrQ86PAyt8jJPcCh1ymE9fSxWwexhZJNieBicnivygxxUZ5yh7AKW7SxSe3sscPWsOaXX2yFc2Q6UDP1BFXDjz9TebcwbgXWdQ7TRq574CRC8A7DnE1bI/yXJaS10fCKOeH6zQThzhwMPp8e/x6rHmxl37aWUQPr9pPIpFiqT1ZsSOPaDJJYN5VkvMm2pxqRlKY7E+JpJyCQVMYSYy9g==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(376014)(56012099006)(10067099003)(22082099003)(18002099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K8mHSgrv3Ut3almpRNZO1EwcbEs/Rw2EchgjzhxzMaHlJPAim/4SnN8+JV/dOmRZWg76XMNMViL2bemRuIknrFhw8LtxFZNFyjW45fhbwIMRkFl+k9HV0xEayUXQrTvQwPb8CemCuF6KHWWNPPkd9J/fy3zlcV6Kp05uOdjATDrbWJ5gTzAo0VVgX7cLbqr3RCGgDqakW+mQn/iSaRTX2tsIACLraK+j/N36tdX9ya8eD9jCWd7lA0gvOeMQKBp0OWHULIlowHI6q08ru5fZMQU6FyL4YX2gYD2ShvfuGVFj+RiMdzhwryzwPaed03aJoDkKbMFABcELXVSsuZCpfBf5ykokudIBGZ6a/ShZc1YLmXfskiuwPV6wp3m2cZVWtA/XQHd4gS2FO25NllbbAHYaPDHZDv8VoOK3qej0cePVNL9FnhmgQMTGhI7gVrNk
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:12.4880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fb7291-130f-411c-08e0-08def179d683
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7202

Since create_workqueues() operates on freshly allocated data, the wq
pointers will naturally be NULL. Redundant NULL checks in creation and
destruction can be omitted. This follows the pattern of hfi1 fix
22113f3f55a1 ("RDMA/hfi1: Remove redundant NULL checks in
create_workqueues()").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/init.c |   52 +++++++++++++++----------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index 92cf9c55df0e..ac5004cabd09 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -1468,32 +1468,28 @@ static int create_workqueues(struct hfi2_devdata *dd)
 	int pidx;
 	struct hfi2_pportdata *ppd;
 
-	if (!dd->hfi2_wq) {
-		dd->hfi2_wq = alloc_workqueue(
-			"hfi%d",
-			WQ_SYSFS | WQ_HIGHPRI | WQ_CPU_INTENSIVE |
-				WQ_MEM_RECLAIM | WQ_PERCPU,
-			HFI2_MAX_ACTIVE_GEN_WQ_ENTRIES, dd->unit);
-		if (!dd->hfi2_wq)
-			goto wq_error;
-	}
+	dd->hfi2_wq = alloc_workqueue("hfi%d",
+				      WQ_SYSFS | WQ_HIGHPRI | WQ_CPU_INTENSIVE |
+					      WQ_MEM_RECLAIM | WQ_PERCPU,
+				      HFI2_MAX_ACTIVE_GEN_WQ_ENTRIES, dd->unit);
+	if (!dd->hfi2_wq)
+		goto wq_error;
+
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
+		/*
+		 * Make the link workqueue single-threaded to enforce
+		 * serialization.
+		 */
+		ppd->link_wq =
+			alloc_workqueue("hfi_link_%d_%d",
+					WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
+					1, /* max_active */
+					dd->unit, pidx);
 		if (!ppd->link_wq) {
-			/*
-			 * Make the link workqueue single-threaded to enforce
-			 * serialization.
-			 */
-			ppd->link_wq = alloc_workqueue(
-				"hfi_link_%d_%d",
-				WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
-				1, /* max_active */
-				dd->unit, pidx);
-			if (!ppd->link_wq) {
-				pr_err("alloc_workqueue failed for port %d\n",
-				       pidx + 1);
-				goto wq_error;
-			}
+			pr_err("alloc_workqueue failed for port %d\n",
+			       pidx + 1);
+			goto wq_error;
 		}
 	}
 	return 0;
@@ -1515,15 +1511,9 @@ static void destroy_workqueues(struct hfi2_devdata *dd)
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
 
-		if (ppd->link_wq) {
-			destroy_workqueue(ppd->link_wq);
-			ppd->link_wq = NULL;
-		}
-	}
-	if (dd->hfi2_wq) {
-		destroy_workqueue(dd->hfi2_wq);
-		dd->hfi2_wq = NULL;
+		destroy_workqueue(ppd->link_wq);
 	}
+	destroy_workqueue(dd->hfi2_wq);
 }
 
 /**


