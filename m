Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794384868;
	b=tvDT2GStDuo/5LxKBFwdFRmKoGqS1ecG3RTKdJgP2P6Wta2AxENWLrXHT6cMxRyKndHq
	 tFukj+BnSyVAIYbba8WRgKQbD7HFhtMzVTZeD7mdlF87ZeKARDHQgeaKKwPfR9KYehO2R
	 cOEYHcBkzjHh+9e7wTrxwVmFQ4JDHH1VRItS53A6KK1yHkf5oeLIMNVEngBrHBvUVtX6O
	 f8DYFAkCy5Ptx06YWbvg+mpr7fBsmhalaRkIP3z6icPhenYxpGeS2drpvhG5RpGkPPrOI
	 kkPNkE2t6rysCEmycuf6ATN8e9vG9h0V0bNP4T5p3dDyiQQ3C6P6LDRfxakQwsNS2Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794384868;
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
	bh=3gZfIOqivKLlnTq173TC0Es/3ToeJzljc4TxNx0VdYU=;
	b=bd0j1cFqoudNn1E7UOBN2T9ot+ueJt/yKJ1/ORm+tB6QMNIsLhrhIM4KOF1p5s3I6ShY
	 XAVsGD/wm4yHB0UTPPAgLZ++Qg13+Ag0futM6Wn01TNdkhoradkcrjimymqycTmzxQmkt
	 3q2egeZuumcPSqpB+isFeTDPbhdYE/Or2RW9klTB0kTPKKiB/0+dmw9WDY1jBGOTHspwH
	 PHIblyJvfGFAT+njmsvga8xcZXPWWDRZ3YrZrjuGWoNn/enXtLltvIfq2fbJ7cmP/SVX/
	 A3lkM90Ppho27C4lJVdyAQjpif55fcw0yl2Mjd6sxER5v1UEmFi8tGSp+qctfZY6k+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Zp4w0QcD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.26
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CEF606A31C;
	Wed, 11 Nov 2026 08:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55CEF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Zp4w0QcD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iBXaSh+QbI+t6AOSDk97yeIIrD92PWf0kfD4Zn4vX8QIP5SCHRbrnnxqtHRQ3JWwHe7s41E2O4wlNnlA0ZdZCTBUwc1nkf9qbGv0xBQGu71zeLLlf9ZpBGabvZrcmbV0QEq4somUVHYA4AxnvfCTIBaGJFZsJIKHxNxsBU+8fKrk23AU0E+m64SpcLTbrLyJz5zbNQfKtzLjstTA8CkujAkcQi7BsY4FMJ4QU3xwjsF4iGwD6GVKk6W81ApTzpQp3aqt2sbBrXFCsOENqKNHUmqlMb6lm1GUEz3RHSf/0EIYY97K/QxWmBMXBBiihKOaFV88mn+olEqIv4aeq4E25A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gZfIOqivKLlnTq173TC0Es/3ToeJzljc4TxNx0VdYU=;
 b=vsRFAH0JSAHBl3lshV3nlf0M12u657xZmZzbx773wFKg0YPrmVC05d66qK4lTUjOa7f6oR5JanLgFqbidotsrHX/hHP/HXG/bGS6CV5qtjKm92UsniBbo4zTLD2DYqsvcUIMkKrhTW4Ltfac6nxrDqaeEqs/86SbDhaC2qZwz3Ov2FBgZPNP0bNU4rjc+wLB6kvREq/U4veQMa4uaB9nedgD7yO77RdNHvOcUNKjNwJx4KHR7oj4ED+kSmQ+JZHn2AeNVNrA3JtMsjv25DUZjb2y461XF2PQJzZ/l1/btmZ4S/1PBT1rQl75+YPA0gOpHjbIzEpm3QbpRTVnvL7BSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gZfIOqivKLlnTq173TC0Es/3ToeJzljc4TxNx0VdYU=;
 b=Zp4w0QcDca0fXpj6jwTnObVJ4iQ1GEt0cZ0tyjkOUfafYleO1+tsUQ0D5Px/f3sjQpvZecH64tkYt1tH7ZS/+8NTcPY1eiT3ovQ+dvngolk3IsTs4OmzUHLrVT8Nq2u8DRqv8iXY/O7ssNsGHpK/qHtdUIsjcKRb1VRuOZN4V8aDvJJl/Y0yKb4AegWDPfnOmdw6jmgSfkMXfW9F7Ibtc4Pu41cJ1+Nnr9GaIAKTcvbFkLdHk/xiTZ4bH3lZlf1NY11Xl5nCt+i9iL1o9O+kDAB8G8ikTbEQ82qmX9r/AT5JN50QZfRHvAa+Z/rtPcuEV92MvVLcdFD+gtPbCdZwWA==
Received: from BN9PR03CA0406.namprd03.prod.outlook.com (2603:10b6:408:111::21)
 by MW4PR12MB8612.namprd12.prod.outlook.com (2603:10b6:303:1ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Wed, 11 Nov
 2026 08:14:20 +0000
Received: from BN1PEPF00018547.namprd05.prod.outlook.com
 (2603:10b6:408:111:cafe::37) by BN9PR03CA0406.outlook.office365.com
 (2603:10b6:408:111::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Wed, 11
 Nov 2026 08:14:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00018547.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 08:14:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 00:13:57 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 00:13:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 11
 Nov 2026 00:13:52 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: IPsec, don't match upper proto selectors in crypto offload TX
Date: Wed, 11 Nov 2026 10:13:37 +0200
Message-ID: <20261111081337.3129580-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018547:EE_|MW4PR12MB8612:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a4f8459-f915-4210-52a1-08df3fcbc62a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|23010399003|36860700016|1800799024|261009223027099003|261028144727099003|261022105027099003|261021123027099003|261021121427099003|56012099006|261022075727099003|261026140227099003|5023799004|261102123227099003|3023799007|6133799003|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	hidC25idiNrZERelR9XeIeerfROsJxBjdjRAUEx8gQzunj3vPFjPB2U+6kIc7axXs7VYYKVyQ/4ub7TopyAdxx+M5drpJ2jGqtg7Cf5xo03hPTiRJatuTlFEWVibfHNNey7+o3Jjg3ZPEDlwW2MpCqzCMMr2Jxz2niv+EqBfwdMnd7yPGQquyda9DzQ/vnWeAIxP0R3eoKMpDE4h2LF/5YX2jubZceMIr+HuJY68xawlAMV/EJF8LB7LiIzXI0GTWbt6OLFOgC0uFJ81gTKg3G3APDdE0UaWUwuMzNWpiT5bK2RfGHEbDoYW9zak0BYxD3malc/DhSNGn1RlsOnfqq/9VfBJdlIt+kORKLzEs7s3Qc+KccV9t+byS8zOrvyZElyHBjXbMHOOJ/nQqfjGoaTS//lKesjr8nYX2J7OIsMR8U7WgNXgPwIQrk7FlxxyYH0DZu/f9Wn6DCVPISArrKIw7VlDQSOSXF4b/6/6SFa5O6oZ95w+ousKHlxfbb8At5OpAcPNOWJcoigqyn6Dc4TaeC09Lh4Fxtx2+KU9/Yvn7IzxHdf0Fwtp4HKZhoySOHZt0PbSGpd4nObxmXzqDmcbNUBYnHk5TxbbMNNYTo9lg/GliC3LNAlle+gDC6QrRQLIdXuqD8xhXypCyTud2VvYDo8oj3JlAKuxG3Z1rQwp49v8ohuQ/fdlzJUL9Ii6eF3abt4AjBUbEUScAE6Fmw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(23010399003)(36860700016)(1800799024)(261009223027099003)(261028144727099003)(261022105027099003)(261021123027099003)(261021121427099003)(56012099006)(261022075727099003)(261026140227099003)(5023799004)(261102123227099003)(3023799007)(6133799003)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pH2gFiZOT8k0pmivITbq5Xl4aXg6HFdD8sz9iYWvfzjqXecx/R65xqdbiTBpax3554z/Bh/GKWy8g2G6++JosuaaWNnDGBNnA/VujOQwSpvO1JDlDePWvLld81OebliIorvuS29zTqJ38clm8WfLGZFyj+abcXeMTBX9H1Bg9yVdCzbkodTusa8jWhPEDP9dfnfcbMP0Nh4DDte9lyXdKriuZ7n8edX4ahgVog9uOUcvM7+btiqIA5187KDvQjBOGfz115A94YmZhpdJyFR3Oi+oSWEKfwhJKmLsK5bD9DuoLE/JynSQeijx/5joET72WTF/DgiFL3fhjJendKkAHkzLtvcxuEame3PPasbDeMl2uinmlPsXc6kUC47TYwpdRpDrKsiDw2q3S4jfYWkdb1cPlJaAgCzn2N5wME8LJOgcBXS2uzxrDqLHc8TGu9KW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 08:14:14.3740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4f8459-f915-4210-52a1-08df3fcbc62a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018547.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8612

From: Cosmin Ratiu <cratiu@nvidia.com>

The mentioned commit introduced support for upper protocol selectors
(protocol & ports) to mlx5 IPsec offload. In crypto offload mode this
causes offloaded TX SAs to stop matching traffic.

In tx_add_rule(), setup_fte_upper_proto_match() is called for all
offload types and programs a match on the upper protocol (TCP/UDP) and
ports. For crypto offload, setup_fte_esp() is then called and sets
ip_protocol to ESP. The resulting rule requires both ESP as the IP
protocol and TCP/UDP ports, which no packet can satisfy, so TX crypto
offload silently stops working for such SAs.

In crypto offload mode the stack builds the ESP packet and the HW only
encrypts it, so the SA rule should only match on the SPI. Move the
setup_fte_upper_proto_match() call under the XFRM_DEV_OFFLOAD_PACKET
case, where the rule matches the plaintext packet and upper protocol
selectors apply.

The other three callers are unaffected: rx_add_rule_sa_selector() is
already only invoked for packet offload, and tx_add_policy() /
rx_add_policy() are only reachable in packet offload mode, since xfrm
policy offload is exclusively of type XFRM_DEV_OFFLOAD_PACKET.

Fixes: a7385187a386 ("net/mlx5e: IPsec, support upper protocol selector field offload")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 8ffa8068e90a..3252a31fbcb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2183,7 +2183,6 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 
 	setup_fte_no_frags(spec);
-	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
@@ -2196,6 +2195,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
+		setup_fte_upper_proto_match(spec, &attrs->upspec);
 		setup_fte_reg_c4(spec, attrs->reqid);
 		err = setup_pkt_reformat(ipsec, attrs, &flow_act);
 		if (err)

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

