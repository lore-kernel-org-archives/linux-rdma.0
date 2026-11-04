Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817644;
	b=LUOZ3xCzXFti0heK5f8OjsUpM8aFaOoOUm16CYMBIIGHNd6TI77PL29XA2+EBzc58Qw+
	 OfRyzHj6NKxqeYEuU5FjCvyjncLdomJ2Sar1iDYsm/45ykUh2g2JB8B8FUt4I6gL+4HNZ
	 iWw/1+FuWsYRuiRMcTAaL0dbMaizAeyl1O54D1F6vpDaANyKeKiTehHJpJMyLZRcWQkKK
	 x3h3U3rtigd1kgDTt9ky1o2/Bj/4qGV9ZBXYSwkixlGjH/e6Kl7hsd33OpQTk26gwBtsC
	 eekyEIIJdIclZlnjRG5LfVgHQlVBYjv0kSxeS7Fb0tnT2mruQ0QkhvCQJtYktUfHc9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817644;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=0nVnhjjSfSTuA70q9le4aaZoZIhzAnldE/qH5+hApDg=;
	b=ZiCVGtdfJ2UG/WuC32Vm42zzhhBsO5b8vJRaewR5NN6gSC/0X+0COlEwav8QjYKnyZoD
	 71Ay9Kfkjd3WTZlDXOGsNWZmNpCoxL8H/xM6SNSlJ34SilZxDJmkZSRoEwru44NX+4a42
	 Vnnl4xIvMwozRePjDdTgecPIXOkXtgCPQhoIIViYStyG76jvdzP07aXFJc9MbXmikzE7X
	 TifKV1vzcJ3c5jkr2nlSDUx0KJ3guedTf+WKdEqFIkz4q6V/HAuOEldg708oyYQYj5o93
	 HmDJuTfAdlus1U5+t/hST45wgrsGmZ99TWWeET76TpOSuLrhZFKE2F6oTN+fPSzqMxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=J4X4KiQ2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.67
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9AF606A328;
	Wed,  4 Nov 2026 18:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB9AF606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=J4X4KiQ2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOxyNSTMcpQr86/BoT9JMZpqTvVGn9wSMKxGbCH78+B1p9cOzo/8lxI3mL92Ou8Lifkt3wqv0c2qHh9XB6Pp0hc+x2KLMG0IMphgiFKYytP/KAwluWZEdH6jjU57OpcCfxqn1aBPZ5leXr1j5Fey6BTfqkjLgu2POb4sXPVzoB1Y12zv00nKkQRSWwiTsjdcWmztoTiqFXFWr2eMKUwnWvdr1slVA03HDwXRz7505ISv5H43KQXCfTt6mC1+DxArHkae/mLvGyumhJx6C1A3Dy+tzO3qPIcUn3MkrPp4pb6Jrj9iQ1gkymv/yiMMnTMarIJFJ+YqDoK5NpK1IlKEJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nVnhjjSfSTuA70q9le4aaZoZIhzAnldE/qH5+hApDg=;
 b=iYk9eavNeeiQgQXWxbBzkqYxNBpme22/PpHAAqulNcyAkN9KYPa/aMga7sL8e/zcrfK8gO+rSBVJdZL5okEifHtetbWecM7q1LqjdCtSi/9PTRm+cu807gNdpmc2UgLC83P6Ajqr+u77oyV/rE0W+OGsmEU798CienDl+nElIyIW7wqIKPeKWGsknFum47H1XiWNRzkgmO6KQ989XwfXibsLGDko0LkW0Vo/48s9/UDKMqPPhXGoCl3Z7CxK3bFLrx5Cx7livNUcMwfCwJwTpvfOZKkjFCeuZsS71e92nxgsA/fczvGeDdxSAqoDp2Cc3Nm/2knLkX+qJIJo2L6P3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nVnhjjSfSTuA70q9le4aaZoZIhzAnldE/qH5+hApDg=;
 b=J4X4KiQ2JwEd4vbzo00ulTjmJAvDRV/zn0RulRfkxXD9I1c8+zWNOyEKw35vuPXikYp6TxfPoecHvdVC1hW92XbFKZzxHdaQz+tmGFr+Oy04XDJtqL4j7fgAV3imDx8adMLDrvVkT7UCzSFMnNM6Xp5LAWgis6p5LMRDDWwcTs8HgjVgfL6ro1Dan1ZOzN3K1C7tWRG6IOjJtIAsXp6n37wA20v67UEaeLyMJQ+dQYFlON8hy1LscWXeX3IgNia5ad5XRzBNKxkAbl7nsCiWm1hymjRbDtKpxThU2ssRX6MskeflYllTEUB8VH7bN0OEL7QsRDQfoQ58Wi4JF3DvOg==
Received: from PH7P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::10)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 18:40:39 +0000
Received: from CY4PEPF000392D6.namprd03.prod.outlook.com
 (2603:10b6:510:326:cafe::65) by PH7P220CA0023.outlook.office365.com
 (2603:10b6:510:326::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Wed, 4
 Nov 2026 18:40:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D6.mail.protection.outlook.com (10.167.247.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 18:40:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:40:10 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:40:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 4 Nov
 2026 10:40:05 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, "Maor
 Gottlieb" <maorg@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: Lag, free steering resources on LAG destroy failure
Date: Wed, 4 Nov 2026 20:39:47 +0200
Message-ID: <20261104183947.772195-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D6:EE_|MW3PR12MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a8dbf5-649e-48c2-27f9-08df3aa31f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|10067099003|18002099003|56012099006|11063799006|261102123227099003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	JWfUTtsElx+0U5Ub0dEhjvEt/NoQF7QceZWeo6Hck0Y/XOG9yuOHFuSZuYqg8xrSGxSrhoVolG/3MUi60Op9eV0thrzd7LDkAb4z77WbpyAUW9XpjBG5Y0rEzqWDgqrcWeQIXxj/namm3vJRxtSHbEPr/bdr8QKrUx9BFCvyorV4AAFPE/OFqn6+Jd8Q1JMpBcz/9rnwfsXb902zWVyeg+9YeHvEMNoqrYB1rBkj1K7efucsk7qhan0oKb/mwqLTRLWzAowZk0fWKtHMQOyseY7NzCwrmWecdwS9PznmuKS1ijzIdfCwghE8BpnCDgN4xtlLUGr6Fc/k/T+YTeLXeyuz3MiJHkUfDDNkljJG+xPRvF1uCvcy9Qizn91sWNEjLYTj/J4gRLife2qla2XiVrSsXonREF4v4XesGnVPI0EZbBWRXaAiYGpLfYo+/T5S7yAANI0nuZHnnVAKD6AB2/ePTgbGh9RtgrM2zauGTkct+9/3HuEp94x0jq/ZnHYShdNZt4tR84IYOUBg50YaRmlWto4lsjDTldp3g6xHTlTCwd//hHI38LjGH9N3dBQhmZB+V0MWnvIDzVc1BYJj9v1CmJ186Ep1kaWf4WhaDcgqyvrFMsZ/XvIlWTJUxaIP0tGLIDojnhv+8qaaexxXVgPLJSlKqsgPh1qUezpyZkWNMrKugCvBcGVyxBkgnJFv
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(10067099003)(18002099003)(56012099006)(11063799006)(261102123227099003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W5cJOSA3GCXhtBIPwxmaO3T33u58ij4B+EmoBjtqhvZ1SL3y78W/9hzFmpj0ZePM8mdu2X5lftfcQeaOnv5wqpsVWMkh4KNXfnIDFPmLFRXiOJzn812O754q5epIgfi2II5RlCnfGqp3VWJw//Lkr4SOUFqDJQq62Roo/LVd/s9anUuTjYpv6jGj777PKDtQsDI39R5MV8IUrYruqEMS5ezakkhWwUIMqTBDTqYkz4rf6dfoXB7SBHO/xeb1uq//1SD2U5cjorn/c8rePfRRz/NV+uvlxbWss/WMsSY7nuddS+E25CMpY/2h7loBBgDpdhSjpivAl8aVt4E8IdWepWEOu6qsddW2zQy5s+xo8vj36ZaSF5TwMwVrdL67Mx/UAPzKEC1xucjMqigYj7Rwd/BaDwJr2hlD3b5imD4Pc7YuMhhhK29I6t4LNrdH7tLU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 18:40:38.4864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a8dbf5-649e-48c2-27f9-08df3aa31f1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441

From: Mark Bloch <mbloch@nvidia.com>

When firmware fails to destroy LAG, driver returns before releasing the
steering resources, leaking the associated software objects.

The bond is no longer eligible for offload, and the driver cannot
prevent its teardown. Release the steering resources even if LAG
destruction fails. Preserve the error logging and return the original
error after cleanup.

Fixes: da6b0bb0fc73 ("net/mlx5: Lag, use steering to select the affinity port in LAG")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 24086267b4a7..c198ff1bb617 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1172,7 +1172,6 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 				      "Failed to deactivate VF LAG; driver restart required\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
 		}
-		return err;
 	}
 
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
@@ -1182,7 +1181,7 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
 
-	return 0;
+	return err;
 }
 
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)

base-commit: 647b81ddefc6364290e67bf33c89d54971f8995e
-- 
2.44.0

