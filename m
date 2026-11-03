Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724093;
	b=G4Wz3ULn0abZOVRosSF1xKsSlVIi8RrwzWoGscjbc6/P3nUkwaImRFXGWDFZTfgi9dXC
	 GJU1vH/18dicQDlCp0IdRPj4H8qsIeXBErXTgxLlVXGzmNPnksc/y01lEKukVmGRBwUSJ
	 guLbWJs+bE76Pw4MCeXeM68ijdekrfru0xwEr9QHMHeg1yzLhE5EDWAdu9NtJtfW2FsL6
	 2BqKWnamFfAGAp78Eyay+8uk9Oi2bXqpHi3pgAnYs9GzQd7mQDOPutVQcouvjYkHSCccn
	 lkldl7H3wMLIwyKq9GRCXFvGZhWWE2Z8Bb1rOWse7NH8sI3afL3+dxZCa1sXIglPC4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724093;
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
	b=FRwXxnv2vCC4kOItCnYvo7m+d+6kXg/DgldCm5qAzWdx8tfLCm+sOqrEcJ2WrHtoEQvv
	 TqlJpxVt64vT5lTXu27JcZkl41bQtuNQYMw+re/7pQ++xTTIH2Aw4u/SM9r1O01BV0S6F
	 gqDH8NrE2HQgrfMDeKn/mEQBRtWk30o8pV3UUnwEBE4NK6mJIXMpZCrWlHK2SPsmc/8sf
	 s0WY5HL9giNueMK8gKcmVVIuvTHd4agNRx2T6hXyPIZ+hqGJzRNePyU6i7xR5eHjp5Fgt
	 LQhI6ub4ogedAVzDscVw+yHH2SXoNr4mJv+ViWWU9w3kvTOvvTQbQ6cXxTzZHl+tSuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kMktdpoF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.63
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BF76083626;
	Tue,  3 Nov 2026 16:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91BF76083626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kMktdpoF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTAaGdsvJFPdx2AKLtXJk5F+bj971K9r9HKnlKKCkzTcjticNvMgnJwfxaIHkjCS1cRwQV4Ty+YYtPpJ8uZJ6nWL1xLmxQzqOWXyAi4UNxKb5Ad4qUUCK+tQYaYEYKc7rSKnlk7sPlScEe8iVfFz913IfFolXYdUAUg7mosrEmpx17K2L4lmv1F6Fsc9OtvxSXRP8VR4/CwYnQK3xH7NFeHewVoG0JPXucEMQ079UU93kCUHwtFVjXSqOppx5VMKJlKFM59x9H/cFHXEBZOVd3TjfwUEZJhx52onLueD8zFxA8xYQsSAXstL6leXNm3WLGcT2y3jtOWHug6Ezdw4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
 b=GF34Dap+A10p7KewZ26UaUYXAm28+3CjqWmRcyHZoNIfBOqBFgMpfmKCxIj057buAhGI4s3jUp61nmPkxyJh60ISOXzhQKiCY2hd3f+UX2m8cyqqiErYF9v71BiEBO5yiFfyNM7PXaiiu2yIhrILbBI7f1dud3grxDOGNW6NSdIYgvhdGSP0qvxmSmQkmQEgKslQ82CQN4ZX4dHpbWVZBmKZEo8fQ84V4B4cwL8U4LbVGSXqKn6qTWCR7tCgE59SVX87T1jiAwGH5dh/7jqgZ4NulHZl5KxqzhkvzsHuex5dUa7sDvMWfaMj0UvnGX+diCpk6xBoCSbsLdUB/cuZmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
 b=kMktdpoFWYbDBoTrJ6IcxdYO0Z2MXrakMLDgpz8irWfT8BHxxPa9D+V3L8NLdw5znOtETX/Gc1wR2ISP+U+XO25dh2IS/aSpYvwDap2YpvLSRQyFJYKP8mpRa1WzsUbCd8OANeuUysWHg7ZTbrAYbMyAdTK7g8VK4C8S2S28zH2doP4KwV3YPIYp07VR3nK9ETBYtvP3rnNb3KuwLQhhxUorKkxgB8ro9uklKVfzXIiHh0ekex68o5OhmFe8zlhU/Bj7czAgyR7cs9DA4px1PG/WGMfkXaPb1+BfslRdf5HUfExXrkQv5XoJNqfT3bLRwvu1BLNvfMR/lgSGoltdzA==
Received: from SJ0PR03CA0071.namprd03.prod.outlook.com (2603:10b6:a03:331::16)
 by DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:24 +0000
Received: from SJ1PEPF000037AC.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::4e) by SJ0PR03CA0071.outlook.office365.com
 (2603:10b6:a03:331::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 3
 Nov 2026 16:41:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AC.mail.protection.outlook.com (10.167.244.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:59 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:58 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 08/23] RDMA/core: Suppress kverbs_provider for adversarial_mode devices
Date: Tue, 3 Nov 2026 18:39:34 +0200
Message-ID: <20261103163949.1554-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AC:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: bb3971fa-0691-4195-0c82-08df39c94ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|261026140227099003|261021135927099003|56012099006|11063799006|261009223027099003|261028144727099003|261022105027099003|261021121427099003|261009221227099003|10067099003|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	DQH9F5xe+ZSxSGFs02vLv9aba1fJjg0GXJK6BMM5TOo9/xuf9w/aabMZei6AL967fZx4s31868ExoiQw/0erd2e93DfJpRPZUhg2L9gXXbwG5m5DtpyTeSwml3ebVewKdemeBiRMicwsgxc8j4LHDblefdMLpx4WXV/B0gYCBZXypV6+dtZW59K8J6bSuhn9+Rgs6KJno/QinOR4ejjw1rVToPvpHSwty2rRLzi8ApiJjWg6U6ee8lT8r2rxi2p38mYsUzHCZ5kyXush40wXb2+fhlqtL8B6N6GfZYMa7UeomosiTP8dWuiJsHmXN0ttB4ugK4fXu3Q8b7AVX2s7XHPXF8VBeaNZdm/tLXiGEd+T+DsexRk20uX55poNH/6ak7nHOxvzno3NEZCmTQnLWDz8SmrO2tnxnW9QnAZQ9OHK/4Yc6IQiUoEUHYZbxL3VuMWbH9PR002NMQhd1xo9u8st7cu1KkDy+pgr6D8NJe1omrTbN329FerW6o32FWELL8QWV7yuE42jHEUOh6Ze8I+pFlF4YyksqC9TvygaGx8tghQAOWieEzrEHU8Cqy7EN5hOJ03s5kuH0nEKkigeWIsrGtv5S1/C9HJFrEKZVt8TFSjlhwkG7Ti1P38UhN9CfliyeHQAkGkcjVColop6mjL8f9MjTXcHzgNp3S62x7RYpcGVt279V3igD1fwMgmgSCE7iHRDbnhPUEnAtFbfFQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(261026140227099003)(261021135927099003)(56012099006)(11063799006)(261009223027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261009221227099003)(10067099003)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8b6hY9gRzJEQG41QskBxz2aHmhHS4b+DlX58mkqsglIIbCSLfx8yKFynk2AXkiqCIRS1ZSzLuTO56MTUZlQsBULz98c2hi/lI+5VjFenfLsTMHuDgl2+sVoDaPSR4tRhuc0jxb7iHhSvAa9rMBILd1p5Wq0+WuXAd88FuQMO8YSGu8y6+T/Mm70yvZSPF62Gi5pFEbEJN7Ea+GEBCFhjQUT17RZawFMU9QC68vy0im1NYmF8WQlYm7fJUrTJ1Ms3L8BHeE1RxMIiA86zxaC4NPmh9aW0i1qMXdWrBVrdtSLwpl0J6NtnQEgpYXsmFT/EndDMwUXjVre2bciwwMLp5SrY5/VvpWIo0yooNkKcY94VvhKM1fTpxkuUWi9lobHMT8TNmfcBJqmM1BWd6pbv3IRYmxy1E7M11FcyyO8VIuPd/wDQ0Lhu6TgCMwL9bhq5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:24.6470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3971fa-0691-4195-0c82-08df39c94ca1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575

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

