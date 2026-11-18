Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795039107;
	b=yBZq2DbNfp8vc8yJHWRwZRG0RnCE4loc5HGSbow8vk8c08DbgiekF0ixwjRLr/aukzEI
	 jPSaLdn6LW/TNBm5BbuIWAL9Gd3NEiq3/Y2CrTGkBtn+KD3Xbfqbg6FFvcCzGC3/2f59R
	 4UwpPFZCdDIs51e0EepQ0fJsIW9fG8YTwBbwe1Gib86XdLQEIbiCYco99EF0PFkshOGwV
	 XgKWi/TXdsxyQsfIMYL9Z867rKzbZkzKzIJllcQpvLuE/3V4Zx8XgBZZIdp3CADhw5JDL
	 t4QiT8HIKY+hLr1BemIdGCCLf+VcwQ3jvmGDfbhec4zh2XXaUB4aTSuOU63M0bpWdTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039107;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-ID:X-B4-Tracking:X-Change-ID:To:CC:X-Mailer:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=PJNYM50ryvR86Ur8YM1WyRrqZqveLVJTeWTW8/IQAfM=;
	b=3Lw8aiGk+8JTFIABHVN0mtieZmICFJTYhX6nkDTvVfNa9xwZE/vlEWq6U+RjQbSe+ZbN
	 P5XqtDbXCoykOw22GaQknKPMcMZ887rbRHC+aqLlvvZK4qI5qopFe9gqpaKem+r0D0G6J
	 z0Uq7nq08vrHa+RvvEm3mUQgmbHrJ/L/pGPzIbjb7KKzgMhq1apQPUTfwhqPdqQlNXz2U
	 zgdA/69IUg1tcAISbOVqQtIAsqYmOgHUfvaiKVzBti8VFo9M9YVJDcxcclJN3rEUX1ZWu
	 wtvSkNx5RSU3U/2IeZ4ChCcG+yN701KaSDw/2zRg0phcQPWbVJuOUEuBMadz2K6rPqQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=hk6tFRlx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.28
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4821606A31C;
	Wed, 18 Nov 2026 21:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4821606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=hk6tFRlx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJF1rhu9ePVvBLoUAVOf/qcS/oIT+tJ/u3VruoWN0aeMcigJKDcl6iE9xdF3q8LkS9lMntt2NGetKyGgAQx+6bAQ+XZgPOMHVNewj2yPgVOpEboGDMFY9eXNDbygjzk1AZATh35z1+0/ZRPbNNf7UYePPLK2CpFQ431TTCoDyjnGTP2TtV2mb87Yh8IyHnZO1TlQXdrxhlClLP67echJPDE5iXMS67BcJOU77W8uTxWzhSlk91790jK/g259MD6LQ2iQOibkWSSw/i8G6G+rVP05T3nqlEwPqQXEbg4h1i7R2me7x9uYaPxLiykWMkAwX6TtR963BXXsi4gYyHO1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJNYM50ryvR86Ur8YM1WyRrqZqveLVJTeWTW8/IQAfM=;
 b=uTmwMNCum0RplAv++lKrO9HKhBzTJSctI0ZZbdAfVh7Ha7Rn9OykshzAx7Gw25dWY/N6i96D3YJWm2/O+UujAvw2C9yw8tTkijm0u07307alLArx47ioHleo65RmnDDNlNe/DGyVdwVAQknl2NN5UGqd8CJKpujGxVe/VA0EpH8k7RY/OTdZg+rTp8358Ph/P5zy/V/ADwub87bcG03oS896fN9RQdRw8IdiWyDgs5O32igMgoDXpxJ+EcPS+bNMXBJuKXde87t7C2+Gw6bxG5zrh10Az4F8pB59ig4hulioCo1MMFsGgPNYaEkv0bTnxon3Qc4V7bGz1BN/h+G5Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJNYM50ryvR86Ur8YM1WyRrqZqveLVJTeWTW8/IQAfM=;
 b=hk6tFRlxyZ4e71rOlFi111uDzXEggxjVR/H/WS0Uc0JFZ4L1sJo4zULqgLY8LPXIMUUPYPc7hmJ4rKy9nmxirGTeBRX49PcS45SI1r7p6v5C0p8NWJW3GZ/N2S/0GNvFzAD4093e41wiFZU7lamHpdiUkHUwt2sqrYbNs9xCWlo=
Received: from PH7PR17CA0036.namprd17.prod.outlook.com (2603:10b6:510:323::20)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 21:58:20 +0000
Received: from MW3PEPF00001653.namprd21.prod.outlook.com
 (2603:10b6:510:323:cafe::39) by PH7PR17CA0036.outlook.office365.com
 (2603:10b6:510:323::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 21:58:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW3PEPF00001653.mail.protection.outlook.com (10.167.249.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Wed, 18 Nov 2026 21:58:20 +0000
Received: from [10.11.96.223] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 15:58:19 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Wed, 18 Nov 2026 21:57:52 +0000
Subject: [PATCH rdma-rc] RDMA/ionic: Wait the device command timeout for
 admin queue commands
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
X-B4-Tracking: v=1; b=H4sIAF8f/moC/yWMywrCMBAAf6Xs2QUTg69fkR7SzUZXSCqbVAql/
 95Yj8MMs0BhFS5w7xZQ/kqRMTcwhw7o5fOTUUJjsEd7NsZccXDYEiHUkDz6kCRjlcTjVPFEdIv
 OR7buAu3wUY4y7/cH7L0S9H9RpuHNVH9vWNcNKDd264gAAAA=
X-Change-ID: 20261118-b4-ionic-rdma-admin-timeout-3cc9f4afe247
To: Abhijit Gangurde <abhijit.gangurde@amd.com>, Allen Hubbe
	<allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Andrew Boyer <andrew.boyer@amd.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Nikhil P.
 Rao" <nikhil.rao@amd.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PEPF00001653:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: a7165426-dd4f-4978-71e2-08df45bf0eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|23010399003|18002099003|261009223027099003|11063799006|261026121527099003|261026140227099003|56012099006|261021123027099003|261021135927099003|261022105027099003|261021121427099003|261028144727099003|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	iUlMywNnA7LOsUNSQOT65EBEylScnRscyL6bz2Efv3WKDxBGitEOJwVLwah3jZWbz7WhN5bMzdkewREzjRIO74Da1k/X4Sb+JVLUXT74uiCRuO/GreR5LkOETVJ56tIVHAFfl6954K2OOoT1eCw4YSsvjLqswHpgioOAmU7cMfyUAELuE3k6jTlgluDTB/E0S5D27F8Sn8tWcyUW9nf0V15Iw7QLrE5Oh34Wzgfb76jj2nc1OhhmLaPRUsDOB0Didl5zFL34VaWpxuO8DJkqWVnDM7EAhl74LN0DOHwrTC3JvQJxv2vwaKcOWgFxnFzOb+FUrG2ZwyDm0tKUtk/xt1zi6bVfTSNSaAeNGApQvIHWTn6i9FtdGKa9Jx/vBnYPffpDrwXSwAVoOYjUpS8t1k7ZTr7K9fSgX1b3i7zspdQhcE9bO0hvIfgeyWaO5ANTf+ou0Xpv/5CbVpEDcFA2xWCKbTEk+NuzVJ/Nq0qcpx95SmuMseOYqEPN1UPkgjapnpfLU4H4aaWh5cACeTCQjaSnfMlYYerSXWolKie2In9vkps/TU5AlmnZwN5SVXzt4IYKOTxzpW70BfFzrktmmuI/oHxYTaK7O9ORC6OyV5QFYnSMHLfdtcecxHx5/ygAGBtR8q4RWBUT0nlBdfBaNzueccwokyrufAxOXz4XRNMfEB+J7eJWPsxSFV/TGgXq6ITHxC+S8nEOhmkaJH+8pA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(18002099003)(261009223027099003)(11063799006)(261026121527099003)(261026140227099003)(56012099006)(261021123027099003)(261021135927099003)(261022105027099003)(261021121427099003)(261028144727099003)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IsnkZvOKOXYV1XPVnqa5DE5osYjZLm94iEPS67sT6ipa/7y8+fSspQ1wK5ybrdpg03eVANXocEi9+Kj1ucIv6dw8GXuZ/0YUWBq2XXB6hXqyIAlahTs88gtQLACBCMCHay4viC5pH+MQ4wmr4g0TRzLoodwdypXIJbuVTV/68CzpVeAdTT/Ji29qFdRRgUW2SrU11Q77/FP7risMEcfV87m+CpglWFPc04DF21ZNF1EWDy//YRq8tgotJ3ZsXVrMKYPcwfP3NLYZ/ejr3X/eb2Lt4CMGuBlVUF5yRY4savm0oakdNEFUfEM4ylyhY17vKNDwFBDs9cMypcuwF1CerLPV24cMCEwLQuTQ3mZpToGGFuMU+1DK8NCZUm8U3lOVUkXPRX1Ie2q9I5YRf/4ld2Thhhg+Y6Mh4ra6U8XxzpgabyzS7RFOja1fs8YRZxSe
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 21:58:20.1791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7165426-dd4f-4978-71e2-08df45bf0eff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW3PEPF00001653.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536

Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
firmware can take more than 2 seconds to service a device or admin
queue request, and is only expected to complete it within the ionic
command timeout of 5 seconds. The RDMA admin queue watchdog gives up
after 2 seconds, and a timeout resets the RDMA LIF, after which every
verb fails with -ENODEV. Wait 5 seconds, as ionic does for its own
admin queue.

Fixes: f3bdbd42702c ("RDMA/ionic: Create device queues to support admin operations")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_admin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
index 0ccd869ad8e6..859893568538 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -19,7 +19,7 @@
 #define IONIC_ADMIN_BUSY_RETRY_MS	1
 
 /* admin queue will be considered failed if a command takes longer */
-#define IONIC_ADMIN_TIMEOUT	(HZ * 2)
+#define IONIC_ADMIN_TIMEOUT	(HZ * 5)
 #define IONIC_ADMIN_WARN	(HZ / 8)
 
 /* will poll for admin cq to tolerate and report from missed event */

---
base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
change-id: 20261118-b4-ionic-rdma-admin-timeout-3cc9f4afe247

Best regards,
--  
Nikhil P. Rao <nikhil.rao@amd.com>

