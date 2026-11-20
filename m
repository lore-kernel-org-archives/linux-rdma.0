Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795163490;
	b=pAKn6YUUJQ4HJZ2pXdBaCswsTvnC0XuF4g7S7X0qXkmBL7r8X7vr3Pi5fPnbaLn2eY5L
	 rEEXsmLO4zewIqk3p2LMTttwOCFNaPMXowG60W9OOFxdb/0vHThUDN3x2qT1MEOKy+KG5
	 /azY9oOaLz7QLuywmscPMxrpOufGL0qZhuEwSjP2iO6Y4TmRdg7VFGZ7Pvkoqm5s5sB6L
	 pkqKjW9QezwcwdqMfwUPvmeaNiuiHDDZHEB6AWoAQEqltZZ7wiGQ4XCKbKEC5Y2TOULoJ
	 xdmi177EQu64cMe1xVAuruWelryqCuOu1QA0+rojvnlKsULNkbpkn/PrqpLYLLc9svw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163490;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=fOyJpL6/085PFT7Y/Kb2fgbH0PIWRMPFTesF/9e20kg=;
	b=b0rqTo6ABqNlrBzbT3qAfxYXL7wFmDXv+wCK4CVYBxOMYneZMRxaoenzZ1aoHgODGn/a
	 lgGYptHp8V2ZotEi3GY/98w/T0W5qx4W8IivWZ3/QOyRXRidvEfeQasoEY0LGgQ4vl+eI
	 qiNW3UGFLcJu5ACMuFc7uDcTe/jam2w6iBrsFd4wniQzSV1PxmZilrJPxPwEI8lUtwv1O
	 +rIkFk2TZp44woJ3h7bZa1+mHS8Q6l4rtFQLtxAz2XTXSARAD0ogZ5IbvU5YDD1UK0HbY
	 2nkbJ0KgI8LTj/feg3QBrfteb5HYg95Z7LuktG2vb4kulLQQ9iBfsHA6Di8dUFgNxWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WizFtXip;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.5
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66904606A32C;
	Fri, 20 Nov 2026 08:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66904606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WizFtXip
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OaN+jH4sgBqGhB/JQ1SH8ErPq7pU/oIxX/Ko8SGgkiC4rn73xBf7hKNoaTO02d2hT1MeMoaW8FZSb8zTBVgqXFXBJ6CyOV8Yc6J9XHUnhpMyoMYhS2FpzRDuEqljKGBDZcDlYAmlwOfIlipwkAM+gNwLrltgCpaR9h27sRfk3S1wXSvypnkedocPgVvkERf6n3g7QJkoF3Z7JPNkpAB0ReFefj+luLpfNBTYixSku89LesX9F6Vq/FNN+JACKmJ6nRl/8UU0TqWH1Cx2fGXlqiKp83bCNU0wIVaPNw4K/wiHehNK83XMVQJpEAsyp3qJ4vs97LCBPHc8WxMR2U5a1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOyJpL6/085PFT7Y/Kb2fgbH0PIWRMPFTesF/9e20kg=;
 b=Ov5f3r/3JYf+sC6l62zvxJx4PdleaYN6dpJZKaUzFMHmlucTQbE1tsZv0XDhLli1JvkahLm/vf70Xzw9UbGc+u6+4RXJOnTQac76WOIpXpQ0BNjp2mhPfIJYdm5ghbPs1wEzTLod/9IevyLKPxDmsrMskZuPOfFFNGl3XCSzqgDPF8wgddWasS5aq2jBDIWdmHi7xme5Xcm553FFS596l//6U2ILnv4PNh/zbsIJkF+0ppLI3B3JpQJJLCCVfRROuaC/GmR7eBrnEDZGUo6LpU+WOK0lMWXozr/GJQ+9IBICEcY/lPGboMoCC6RTJmHp80qPz+KahwdwLTnBWzWvUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOyJpL6/085PFT7Y/Kb2fgbH0PIWRMPFTesF/9e20kg=;
 b=WizFtXipRMZQWYg+7pddfvRPqmVKdPIJH/JhtdJNWzlor4MKP+mp8m1KBBGfxrr27MICoAISvcISaGLbVp0d2F5AF6f50iudqyaDeRvb761Jw2Iu968+JJILShY56/K48nCLJdybBuuWydvxh/3WDS3UbNcVkTJtGvn6oKLlMjCcjmO6kj8l0+ppQiFKNYVgE9OFhWXl22em1Dr0ccme28sAzj1iYSSvKfbqaXYKvoxpfuhztnzEr05BL2LV4Egcp8Kws87cL8NaWv4Qz8fLThlr9ObJAaa5ZkjpZ5n/yjLr6x8gsUj42JKU47A3yk393BT4ve+7UhjuDEqiypTiiQ==
Received: from BYAPR02CA0008.namprd02.prod.outlook.com (2603:10b6:a03:54::37)
 by DSVPR12MB999283.namprd12.prod.outlook.com (2603:10b6:8:41c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:31:25 +0000
Received: from MW3PEPF00001659.namprd21.prod.outlook.com
 (2603:10b6:a03:54:cafe::31) by BYAPR02CA0008.outlook.office365.com
 (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:31:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MW3PEPF00001659.mail.protection.outlook.com (10.167.249.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Fri, 20 Nov 2026 08:31:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:31:06 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 20 Nov 2026 00:31:05 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Fri, 20 Nov 2026 00:31:00 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Randy Dunlap
	<rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 1/2] net/mlx5e: Remove documentation of nonexistent counters
Date: Fri, 20 Nov 2026 10:30:47 +0200
Message-ID: <20261120083050.2540739-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120083050.2540739-1-tariqt@nvidia.com>
References: <20261120083050.2540739-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PEPF00001659:EE_|DSVPR12MB999283:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f24e292-8ab1-4719-59c8-08df46e0aa2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|23010399003|1800799024|18002099003|22082099003|11063799006|56012099006|261022075727099003|261026140227099003|261022105027099003|261028144727099003|261026121527099003|261021135927099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JSTSeRgeFG0N9QkctuhdIMlqCRHWyHIlHK2dIGKe9nbMmlhuTtkiMvAf7U8W/81MKnsfNuB2t0XkTqAi7OwoMZE1kEljSqETuqjBygy3oH1R4KARtyGIXW7aGzVeo8vCcmfbCNbv0+veU2I53wRkOFmuqvQgn85ZTLT+RKcezjE5FTkYYKes/j7oc61iBepFMv61fO0Qgq0RSSHpI18A3S7Tye3zvEO9QVsteIky/38iVfJJFcbjKuRp7BaAF6vsq8IN3ORbjdnKyl2OBHazmDWjRYyYYwpvGWsDCjpSOcpLYFbfOSLtd1DqVzjKZTesGz4wvr70pzkj5EGO2uaWGD28olAiJKSToRuO+y9xsGfRka29M+PPOZLMNZUVMOLV828afdHY7csGbLcXup0dcjzNCxUEO0PB4wgeYOYvuQGD0rf6aP0m0ixMwFHzmDhzE35VUZ7o7mbvqcR2+RRHLNShvzlr849DuZ0/teiKg5m000U6TyIzKEQZBHUSIn8SS7VslNrVIX6jRi9RzyBnefgK+wt8e8KnC923Vz+gRu+JkxjLIHNIabT9qUl1d3JmPkXnPGAgl9S7evaML5cZOk1SePKS7oCRKRvNfKDLca/wCl+vjEvaLhuTVPE0B5BxHI0fIHnjpy39uDvQW4I5aAuOdYuBAzT1nO/rAprRZAiwCQnFTBMVdz5zLX4KQjpz5EEo5hxqc87Et06T4iLO4w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(261022075727099003)(261026140227099003)(261022105027099003)(261028144727099003)(261026121527099003)(261021135927099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7PZek0/9+sV3S5OOQbt5WZtDqA1yGY/H7NxMeLqxZjrN+AEHM1BWv2tdqjyZOtoPySR2ApO0Pgrvkqau0m7VWEpS0YvKYcotwQ9vCrPfFs67J7USRT4/uIFVqzBD7TogQswrci23sMCoJ3//7Djy3xeuqXTt61ofcNp3HFVpiyQXqUgPcGu3bxddn+Vt1TIaHJuPsPapYQG02XV4zzp9U7LtBRi7SHrz5ZX5d7o/Itv0W747Q2tpjL2q9pPL0F7lsWBBuJvrX4+Dp4Aj9F4yAn4qBK05zMpMmt+rXw0vYqwZcKfKwW3F7YUDJ0VeJ34GbNVw47Jek27hp5r2jXJEvwSzvxJ8mhsN33FqynmC4SgqcI74m5VmhNmTYNrddD5cMvfDQ5x8E5hTpg4VJFSRUAeq6HNmX48rKTiatmU82Zu8H5veO/4gL/LeDvpNQNTM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:31:25.0392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f24e292-8ab1-4719-59c8-08df46e0aa2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW3PEPF00001659.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999283

From: Gal Pressman <gal@nvidia.com>

- rx_bits_phy never existed.
- rx_mpwqe_frag was removed by [1].
- dev_out_of_buffer never existed, and looks like a duplicate of
  dev_internal_queue_oob.

[1] Commit 7e426671704d ("net/mlx5e: Single flow order-0 pages for
Striding RQ")

Fixes: 8ce3b586faa4 ("net/mlx5: Add counter information to mlx5 driver documentation")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/counters.rst       | 28 ++-----------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
index cc498895f92e..026259ae383c 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
@@ -341,14 +341,6 @@ the software port.
      - The number of wrong opcodes received on ring i.
      - Error
 
-   * - `rx[i]_mpwqe_frag`
-     - The number of WQEs that failed to allocate compound page and hence
-       fragmented MPWQE’s (Multi Packet WQEs) were used on ring i. If this
-       counter raise, it may suggest that there is no enough memory for large
-       pages, the driver allocated fragmented pages. This is not abnormal
-       condition.
-     - Informative
-
    * - `rx[i]_mpwqe_filler_cqes`
      - The number of filler CQEs events that were issued on ring i.
      - Informative
@@ -1132,29 +1124,18 @@ like flow control, FEC and more.
      - Failed to allocate a buffer to received packet (or SKB) on ring i.
      - Error
 
-   * - `rx_bits_phy`
-     - This counter provides information on the total amount of traffic that
-       could have been received and can be used as a guideline to measure the
-       ratio of errored traffic in `rx_pcs_symbol_err_phy` and
-       `rx_corrected_bits_phy`.
-     - Informative
-
    * - `rx_pcs_symbol_err_phy`
      - This counter counts the number of symbol errors that wasn’t corrected by
        FEC correction algorithm or that FEC algorithm was not active on this
        interface. If this counter is increasing, it implies that the link
        between the NIC and the network is suffering from high BER, and that
-       traffic is lost. You may need to replace the cable/transceiver. The error
-       rate is the number of `rx_pcs_symbol_err_phy` divided by the number of
-       `rx_bits_phy` on a specific time frame.
+       traffic is lost. You may need to replace the cable/transceiver.
      - Error
 
    * - `rx_corrected_bits_phy`
      - The number of corrected bits on this port according to active FEC
        (RS/FC). If this counter is increasing, it implies that the link between
-       the NIC and the network is suffering from high BER. The corrected bit
-       rate is the number of `rx_corrected_bits_phy` divided by the number of
-       `rx_bits_phy` on a specific time frame.
+       the NIC and the network is suffering from high BER.
      - Error
 
    * - `rx_err_lane_[l]_phy`
@@ -1337,11 +1318,6 @@ Device Counters
      - The number of seconds where `outbound_pci_stalled_wr` was above 30%.
      - Informative
 
-   * - `dev_out_of_buffer`
-     - The number of times the device owned queue had not enough buffers
-       allocated.
-     - Error
-
    * - `pci_bw_inbound_high`
      - The number of times the device crossed the high inbound pcie bandwidth
        threshold. To be compared to pci_bw_inbound_low to check if the device
-- 
2.44.0

