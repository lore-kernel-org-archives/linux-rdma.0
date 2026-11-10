Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318262;
	b=xO4NoOsxSqMOLrdckGLmoEc6eVPSrvXp9MupWMdyz9rNI8DojCcARemVSdjNFaIK/4dE
	 VsMBWdpN+BrYhZ0ub6zA/udXLUEDrxS1aoumPwKpRvtxklrmd3e09RtauljDtfoFZ6zft
	 xW6HFDAjuh03xYsOSfW0tucLVaWa3koTZWc1PqxCLDpfIKJTG/PuE6ylqSf9HAm1Czk52
	 JD7dZvCYtQFtMgbQZCKh5Mf/tePfLmQTOv9D5H6JOB9B0PW/uUhB3pfkq46dFfVfOzd0k
	 RGk44tNyCOEmJLvokF/7EDjW00Leen3mJS44imepynb+eeP7SDBCRS+x8VL6KXFUCqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318262;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=8RU4Uffwdzx4hHi86QC03U+wUmKtadevXp33b2fxzQk=;
	b=NYzENsj3Re31hwwUStgSQiFNl6cBMXe+C3yij7u3js+D8ZZGhDvCAqCuVte2swz7R81+
	 WwL/QvkX13DM+LdCGceAmDr2ARSTkS3503NampkDD9KJ+D1EPC60cjYIGnSwOKfpxuBll
	 WzewF0lVXOBegX50bNjHFgd0JQu9XX4TdG92hTIS0xftZnzqcy7OZopbuohQpQ8/FdIWK
	 QIDu1Eiz9KWunfgTg2BqGzjT9MHZvYCLR/ZHIeM8aD0Zbi+xhrxoYDJfPLkm6u1L+HuaX
	 7ZHi7FGGWCNQsB7Gsi3+g/CXaFSjOlWIiko7gOEL7xGTBjTtECvf/fqvNsGtgJ/ZmNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uY6saiKc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.0
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFD860A2606;
	Tue, 10 Nov 2026 13:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CFD860A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uY6saiKc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jj1q52JeV1YyKW/9WwLOJis9+VuAloA3iUDDpsRE2flkVXZl5lAx9KI59Zvnp9maZwAPWbb2eqTCSKUfefk6hvra7agPEUV5JpmvPlPi1Y3dKFdddePeYH+oKt/8Nzi3UIph6PF5CQlALJ1SiKCSLP7SLJVFxPwNvXFdYrkshkO65j3xyA/sPhnqia5Wg7mNXwd98ogNAn6oF+WaaIgCIhmerLIaFALxM0yjtIkpF8eToqJTvXdu6xBRzg/9o5bte3hFaF2mXSzIGDrXuFisVKByQtRaxafD4Xvq/Sw3LYftWTGgIkpAVuVH4wB3YVL8T3NO3PxA03twcyNLahEzQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RU4Uffwdzx4hHi86QC03U+wUmKtadevXp33b2fxzQk=;
 b=lk6z1YNlEIcm8bD5Hsyj7s8FOOJfw8+exJjbpg2/u+vET4xM1XyJSSqI1l3aqaYljlxRPhn2tdmvAk0OdAbLSYtpSz6DpvBw9606dK17eTjBV6tWyEUl/6KfRdqGI55fKNlLnaMSeRdCv4LVYQY/XTs7OJqx4dEuV7YjXN4II3XQmZIJrVDQt5Ma9/kzeGEwYyKnpM+B+tY6soR8D7/VlRUGwdZaGHzlxLlUA583cA4zd/Il0k9Yr5uP1B2RFtHv3r3H3C5Q7JhPaGpwHKz9OHxAdHpYNkO/3KLmRwcaqOgwzTnEG7rt3aqkXzWzR2VzZshWhB6kt8heZaErZRTsmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RU4Uffwdzx4hHi86QC03U+wUmKtadevXp33b2fxzQk=;
 b=uY6saiKcuTuXdMNhE68UGgiRO44S5bK1r7xrd/T9Hm0NI/pCDDX9jblTgstzNCfq3INk7XsxQGjfNkx3jn43TZ/QuBRylnCVcNzyq0zh25vj+0+hwDGAzkhpxBnrezqQUPRGEMcUgxwdx5O28hb0Ooiei1mcWim+3svK8rdXTFDpErkcZqXDIFwEFFQK1C4t0Tm2sY6OnlWDIjEmz2gCXyGk1VDXmOg60RJ2Xoy+4kIKpgg8EEAk6ERl/+QSqELmQ+2gqaPEi9+QqO/EQeBJTQd+1Wjx+7h1XmPrQVtokiYHDS5/Hf4Z3ZJLuqCRkD08ooDBy82Q1XWs+1tjm2uZtg==
Received: from PH8P221CA0064.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::16)
 by SJ2PR12MB7824.namprd12.prod.outlook.com (2603:10b6:a03:4c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:44:17 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:510:349:cafe::25) by PH8P221CA0064.outlook.office365.com
 (2603:10b6:510:349::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:43:59 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:43:58 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:43:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 02/24] net/mlx5: Derive adversarial mode from CC guest memory encryption
Date: Tue, 10 Nov 2026 15:42:58 +0200
Message-ID: <20261110134320.34408-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|SJ2PR12MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 45229643-fefc-4560-36fc-08df3f30b6d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|23010399003|18002099003|22082099003|6133799003|10067099003|5023799004|11063799006|56012099006|261102123227099003|261026121527099003|261028144727099003|261022105027099003|261009223027099003|261022075727099003|261021121427099003|261021135927099003|261026140227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	UoNujFO4y/KfiRqKg8qguUi6B44ghL2OYGThRRv6+pmeVfaJYScC7L/J/WI8+jo1x9cS9W89QbSv9x+fOXpsNtEjAJaqvO1+Ppji8qqOAwD4Ftask9wLmBGSNfy3BdVwz9DvZaXxpQulH8QR06nyTDIG1Cju2hO/TZxOt3mzZ+iz2btovWiGq6E6pIH/z5i3VZv1YUPMbqw4iunF7nKVb2tw57HNZlCl/K2deFezdDsM/Z5LFQ8s4IlHoqn0TBQPFMt4YnbNrIKHszWXX8OkDHA7uEFVKHvNWM7RZkmbfk+xcv5I2AXRqo9UUs9nJIy2xHEPg6yoZtUiNuLvKPVoIyOa2pmBjBJJScrBK6vOly49h0947SALG8ouS3R41eE1T5zz8oHh7ZGCc2Z3KrXbpNWB2gmtglPeP+86/DZM5x1XTWoM1CLIwlRrJGgR2rFySfnt8Vhz80kQUncxtyMvdzzI9Q2sIBylgIXkmO3UXzYdIwAnOjLEA57RrRBMpYHeJ3qxVCtdHIuVIh4uuzxdOXl7x0lKuJU4cqtS+pTsQS/cLi7YUsKGKexqqAyD/Wep3kkebu227XvluQzWHldkSrZt+v4cSAk6ll4T/Ylvs+1kOJnWsOJ5uZJ4/Q3Re/7PvAKiwht/9BiQUSkIWUePz0w6G+p/gVoCfEfY0ljWEz1hAiCfKPOt7FayjNFX9wBYaqDYF7T/xgqZxht84Z9jTw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261009223027099003)(261022075727099003)(261021121427099003)(261021135927099003)(261026140227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RGNcnQvUai2gwdmEtpx1DB7V0u4anTmzDGnJVmcYulwFZ5K+fcEY+TO8L6Eq3OLy0txvA/Cyf4RcnDplmWMwKrFJeC2WyzOoyrg01N4JcM+weHjXXAiz8C0z4Y08qBA8zbfRneX5+Immmi8pIUl6R5VjCNci+mfNAFmJRVmVYPNudIB0Pp3Vi8+RSusRqyX8u1Sjm1QHeVdgo7KCdTBw32g+4pLdICdq9EuTVmS1fNCPkpFbR/UxVAg23tvkqlqGE+tChj62456qxDmfmRVF/EGtawLHDPmDzX6WV6BWlkiKGPl71E8ZpgE5TGL9bpbiCD6iZz/nsaXKDr/UdVVnudO4XNbCg8sxLribEaQOOMDMKC8s2OZBUWyaITe5mkELRo2129f2ylzfJtuCVfhhQTGrFo6wlQZE7/FmMAAhzaXsU0Rz14IOMrXTsm1uLwtm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:16.8063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45229643-fefc-4560-36fc-08df3f30b6d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7824

Add mlx5_is_adversarial() to report whether the driver treats the NIC
as untrusted. In a confidential computing guest, the hypervisor and any
passthrough device are outside the guest's trust boundary, so the mode
is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).

This turns adversarial mode on automatically in such guests, without
any administrator configuration.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 +++++++
 include/linux/mlx5/driver.h                    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a45474ce03d..f9e10464a71b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/highmem.h>
+#include <linux/cc_platform.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -484,6 +485,12 @@ bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_is_roce_on);
 
+bool mlx5_is_adversarial(void)
+{
+	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
+}
+EXPORT_SYMBOL_GPL(mlx5_is_adversarial);
+
 static int handle_hca_cap_2(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	bool do_set = false;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a1275e6aa6c1..3d3bc16e581d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1328,6 +1328,7 @@ enum {
 };
 
 bool mlx5_is_roce_on(struct mlx5_core_dev *dev);
+bool mlx5_is_adversarial(void);
 
 static inline bool mlx5_get_roce_state(struct mlx5_core_dev *dev)
 {
-- 
2.18.1

