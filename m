Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318303;
	b=VWeoDOK9igmAb6a7Z5N0ppyID1R23MhGAL1fmxPgKU2IHrMZXgR9OBaOOLtgyce2NpTF
	 dTYSGLOodZvOJrrvzZPd8O+8VRriB+xKCfiq4S9iDsIOZtGQ8iJm3k7Jm7aitXluyqhtT
	 FkP2uV3q+NsGfWgn6KBA55JjVpdxuFHTREiI+Z5YfuB7ASIegL9yiYJCgU5b6rM3pxxDG
	 w12vbGaa/DhCL3HMOND/w9CxmeX0vEvME7z4qSzTSaS60xyBMQW2dFu95fLePeeynySoB
	 6awVMtgvmUQczlnV0U/CJK0VUscUW7Ubgt03OxQXpL0jaAXXCJ9gctVFmy4pIsI0qYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318303;
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
	bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
	b=zEg7jZkWVNuv9jxJ+y1a6Cv3V5OOCOzPCNg9QF3fRWENpRPf40MQ72sOaQcyJvqj92aC
	 BR+81BdWuiDPFyR2EUZHl3ju3ueilYCDL5zfqXdZKwmeeGwnuJQEDydePmTCAVm88iXV5
	 UNq1AyGu8AN89atWMt/EJabjLVluHBQGqBsL0dEaOQpAKBPFrpU7hdnlrv3+oJj6OTa0p
	 fufQYnaX5GQQXJ1wChjZmxpmBiNRE5SPcW/LY/fVnvRF5xtpISy1yqqYV7ZmuWeHXFVUX
	 IhyhFnBkWgzuFXtNPJaAbkJzy7CWWOW4FQ+0tmyWAJTzIvCCcSPSNSO59gz8K53sreQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=POzVyZXM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.31
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA9606A335;
	Tue, 10 Nov 2026 13:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EFA9606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=POzVyZXM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2Thb45FLpIoBeVpn8rS7y9I+5itScvnHbL4aAeXfP0sfm6nkVgDntqy9vu4MtIQUPlYc1o/Q/LhWu+pnBdsyEhrCrEq5jZFpT2WP2boHlDPfiYSksgwsoJ2SAmPX7HTdW9KNBofTmYX4qBSfzZnG703WKi6difSQ9hzaXZX2+vlayRqt7ASYSNoPQAoDiD/COESpHliWMS3MG0uhZSsB7pB+OYgsR7/Usij1KXV+4bTl8cenWIOrwAl4ydzKuHitYZRhH/1qRpedivxV3STSdPuNChVFhrwTNBraDtkMN9w0ntnvZoGHrzJuJF/64KYMhazhHp/WOCqAQqXp0N41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
 b=Uhg48TcIw7MdzdQxdx3WjzATYDFyBh7t9/6/pOMppyFQlDU62XgIJqorQW+p8QYLdICz0LmpZroG11RiKdpKW1xeNkvDz1k60mn1UwR87aj2D0HUjqENpi5WC6RHrYMijlHyrmnElFamx/o0t8Lryj5uTiBypLcUlKA172FREXSqLXIpG1/gjrK9WZ61y3pWyPiYL1qVg1oA/C+WB6ZN/xcW/ylE5GfR9XUprKL8hxozpUajI+GYL5xUMsYQHMuMp7HObxIXc6HuLiXTTeKUAKJKDCoVy1aiDxbwHn2ffPjFlRVTjkRt7/iMUWVKbURGsrNsZSG0Y/IKaig/U+WV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
 b=POzVyZXMPD+XB/l+SZn7rywM0WKwOSzreFnkrjMTEFouPmiw0mtdf0bWVn2b2zFXXOAbX+i2Aj0kMDR/eNJ9+UhDFAkAlcYPKdOZcsj/3I1bAk/to3gIt38R/CRGGmwU6EkJqwo48eG4NQEbxH7/0sWoYzX4EEoW40QIs3JUgiERqLUW3tqDCoTxIaLNpx5+3m0/7XfeuhIMv1LLLkBAvM79oj3lxzbFrkS+2XK4C8MFX64wHGHLs17yKh38lYhaDrfkeHFvghY9lo5aqPXf4xIO87ZdXSsbZgO/L9Ajr7VRLsDfWBHVbAYp+uF5UoJZgR6wka2T/OialmrnAYaPAw==
Received: from CY5PR22CA0062.namprd22.prod.outlook.com (2603:10b6:930:80::7)
 by IA1PR12MB7637.namprd12.prod.outlook.com (2603:10b6:208:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:44:55 +0000
Received: from CY4PEPF000392D7.namprd03.prod.outlook.com
 (2603:10b6:930:80:cafe::97) by CY5PR22CA0062.outlook.office365.com
 (2603:10b6:930:80::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D7.mail.protection.outlook.com (10.167.247.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:55 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:30 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:29 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:26 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 09/24] RDMA/core: Suppress kverbs_provider for adversarial_mode devices
Date: Tue, 10 Nov 2026 15:43:05 +0200
Message-ID: <20261110134320.34408-10-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D7:EE_|IA1PR12MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 99726a3c-c2c4-47a9-13f6-08df3f30cde0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|11063799006|56012099006|22082099003|18002099003|10067099003|261102123227099003|261022105027099003|261021135927099003|261021121427099003|261028144727099003|261026140227099003|261009223027099003|261009221227099003;
X-Microsoft-Antispam-Message-Info:
	rLInT3t4fQpTpihLD3RSyIm2zcaENKe6ONpCH50Wa0oyJVpNZBszN6sJA7ODcxu1ijczyWurqXrtu7wk7O7ISJ9rtRf5ffgyySPl6kAgHooOUZu31IBpurcUN8ef6GzUuitaCBFs+4GfajZ991/eBD9kG5B8dl4ij17I4tGg0TQyDbaNonLeaxzhH3HTb+swDMg39jTeH0cbn12X7b55TO8kpRzS0ZuuxSa1oIn1dB1v3/tVSFfjyQYEtV4edwU0Z3hRbJaVSkqFPeGy+1mngbh9hOlAPg43LU6FoPN8/dnV3wJkow2jl6kW9E5JdzF1C3eY8D8quPwMYrBuM9IohidUeileqlQNuNRQByJmRDZX8wnmXcwQmz8pZTDdbr5jdo50/lw5wFgbjdnmxLA3rwjD0mDVLvtlyntsmLtbogvAgcr39V/E0usOg+o+kfTBKZFVBsQYnK6BWFj5tV4FaODY3etg8cqLEZpF4y1JUufl77zOaTEYuALpvrXYHz9e13WtAu49rRL5VuXHW/tHvvbUOpMEqSyk2N7KLZPdn6Jw29Ig/e9iZuRdG0GtU05+iWW5cR9rizSVM0D4R/TunwNQurJ3HrUe7zm53yrnkBYyOYmOzy1LJWw82pmkPPsB9E94JuPBqav6af4y2gdpAFrfwOMqOt8p6dj9AJTalqY8ieAKxc39WoGKifCmtloLL+YbbU15nNTXvQ6Hpx2/ow==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003)(261102123227099003)(261022105027099003)(261021135927099003)(261021121427099003)(261028144727099003)(261026140227099003)(261009223027099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	q3s7dK7p0FDgpFraLq/5913CQjrSqhUF1Dn5llRVDzIJJTjTS4uFzVLDYyt+RH5O7FQPD5qsBPZUBYupHPxjX8mj00sdCxtdxl1ehxTxyXQIC1vfyPilP/c7Z8ZKEE5xz5JPJ57hPu+VZlQ2SgRJIfK9f79v4PQ2ESCNb0+aDEIFChTO8YDjqBM1mAcLCUPJb+REJU2OHNe3EKsQm/Fa554IxZoNacU6eXQ1skSKXd3NOxwZVjCeP0lk5U08VbwsdpA94pt0Hyuc78pFcxCb53zxdh9ufPF2GgxKCkMs2R/enB3IpdT2yVT+ASlHlKCVgtFHcOk2ZhEjKSwmcJFPmZqy4XaY9OO68EZ8MqfZjYvKHXxI0BkcoxWqg3z7ekoEgIlVVQc0+K7GFoZzHLrNLl4dOgq2B/nZEJU7hIzrI3qyv2vltgWa0XklCnPSmEl9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:55.4214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99726a3c-c2c4-47a9-13f6-08df3f30cde0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7637

In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
reports, its completions and the data it writes, so they must not use
such a device.

Add an adversarial_mode field to struct ib_device and clear
kverbs_provider when it is set. add_client_context() then skips every
client but uverbs, the only one that sets no_kverbs_req, so the kernel
ULPs never bind to the device.

The driver still implements the kverbs ops, as the uverbs path shares
them, so kverbs_provider can't be cleared by the existing check of the
mandatory ops.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/device.c | 8 ++++++++
 include/rdma/ib_verbs.h          | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 29af9fe860e2..eb6aa567d365 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -312,6 +312,14 @@ static void ib_device_check_mandatory(struct ib_device *device)
 			break;
 		}
 	}
+
+	/*
+	 * Kernel ULPs must not bind to an adversarial_mode device. Its kverbs
+	 * ops are still present, as uverbs uses them, so clear kverbs_provider
+	 * explicitly. uverbs sets no_kverbs_req, so it still binds.
+	 */
+	if (device->adversarial_mode)
+		device->kverbs_provider = false;
 }
 
 /*
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d6eaa3fee66e..6209a5166f0d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3008,6 +3008,8 @@ struct ib_device {
 	u16                          use_cq_dim:1;
 	/* CoCo guest with DMA bounce buffering required */
 	u16                          cc_dma_bounce:1;
+	/* Untrusted-NIC, adversarial mode is required */
+	u8			     adversarial_mode;
 	u8                           node_type;
 	u32			     phys_port_cnt;
 	struct ib_device_attr        attrs;
-- 
2.18.1

