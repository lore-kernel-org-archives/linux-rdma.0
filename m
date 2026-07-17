Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D683DEAE3;
	Fri, 17 Jul 2026 07:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273072; cv=fail; b=GEQLBqGHLCrt+LXO5oYGOr/i9GtfX87YJpwU7m6IpGisUV2AjHS1YcsBvElwjWd0UJsvAxvdSj3ms7hjFYl/YuICHHzrfLx7G5ouWdFi1Bzb9HwCxtIFFb62aR66+p8TMW5l6NUVZIQtaSEES6bMW8QKoBj1KQ33yCFsENSNsUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273072; c=relaxed/simple;
	bh=rohrswExmgo+bdtTCx51iXdChWihYmipQqJcktGHub4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QLdfOPLRAFK52mvBD50NJ5qDePbMjjV7TBz79po1MxI5ggyab+cVg7EeB1Xav4L2TypDYf0HCGCfkMfDmkQb1nGlAG16705766biDrmxoknKdL7pDWJ+hkBXOQZfpM92HRm1txB/IeOUTkMBxZY7FfBNMPWDx7B5YJWHZnH0kuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H0MxHhmc; arc=fail smtp.client-ip=40.93.196.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H0MxHhmc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aA75Ia7KmhdtJGvbvhG0aC7T/qQC+WW50EYq64EC9/ClsVkeFdFy0uWztEyYXvmnHHsVs7oFTq/z3MSyxjGlvTiUqJgI2I1zXCm0sSWqla8/nkCezzsQxNpwIYipSipBdUgmK4sncqBWh+zgmCOx80B40MuSyLwrdxIkr+c2B2UsZp/SVdZmvPjuXbeKdBJbLeX1txPxYjBruq2xoYWzgDXlJaLIAi8huKIy6adXxkmDzLtpeb2OcOaftAEeXBMKWF9NdDxZPconfonzrNO3y5NxDXZhSnJ88a/7viApOKiYSVE9OCIXUrTrwawSA6C38xcEfR/RX/g2t4imtde1Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jMXMG1BHZIfci6MwwsTypL4XMCJ47XD8WbHwWeKodo=;
 b=OX9pnvDdKRARnNj7HxkhMazyPT0pxBtQs9tvZHm8BBIhG7fRgaZUHLZNmkVRbUxlNxBAcY6RN39f+axoM25iG003WS0o0bH0SxdMWQIUfRLVtQTg0SKEcdE5czSQUP8xkDVw3ALIRY8thIEiOVy6Y0xlVy4g0znr4j5VqgS/Ia29vALnBVadozq8dEG2cjKTLs6XRwZq8iro3Gu0Ww0BVnhWnDZCPOyslpr/YOZAx+IGe9GxH+ncttmUtCfT0wwC+67RjcBZkZ7D6pElQVuLfSIEnbV4MFFmMlvWkuU4CYeuYdDtC1KwT5817r8doZMUm9x/Gf5Fz0pG6m9Mc+IgAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jMXMG1BHZIfci6MwwsTypL4XMCJ47XD8WbHwWeKodo=;
 b=H0MxHhmc2t6psoXy32C0Xzj0bNDykuUG1XdkdlSGk3VcpCS8QnhBJdFrXdEg27jO/NKCU1+ePWJ43eqzhRLDV+GcCk8Bt0YPJOIsC2q1Rrlt5yD9sXdzdi1OtoghMQtmf3CO6dxpfzAsWyGacZtrlixyjUHlktgDUsUZszia0R+tadOHv5W4UJxOLLucuBdbfONYtbCFgCpC4wrGxfX2srLlwivBZ6CWDAftoRKGQMI9MZKmpCI25/RBjrgTzlFONA3EpnlMM0PjgCuqj7euiA/rBbwXIzQrcpbvJ6WT4dA1C4SopMlNLUdyqEVisgQL73Ax8Dc7NBbEVQk+Hho2+g==
Received: from BN0PR10CA0018.namprd10.prod.outlook.com (2603:10b6:408:143::29)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 07:24:22 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:143:cafe::50) by BN0PR10CA0018.outlook.office365.com
 (2603:10b6:408:143::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.13 via Frontend Transport; Fri,
 17 Jul 2026 07:24:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 07:24:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Jul
 2026 00:24:01 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Jul
 2026 00:24:00 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Fri, 17
 Jul 2026 00:23:57 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Lazar <alazar@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Maxim
 Mikityanskiy" <maxtram95@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"Tariq Toukan" <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: Fix MCIA register buffer overflow on 32 dword reads
Date: Fri, 17 Jul 2026 10:23:38 +0300
Message-ID: <20260717072338.1240582-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: e9bababb-af24-468a-7fb1-08dee3d46be3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|23010399003|82310400026|1800799024|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Q7QZCkrAvS45ahWGosq5HZasu6nl5zqMlfih7+msTrBopyXG1BYIlQGomZntli2lqi12jf3Zxeux73XLYZSPc9Lmd7aQZKA5zFUWKu69R+ojENg57o9pFRgMvJ08N10PRlpY7oZNrZ8SYgjh/OTu5dcP0Mpjno8VHZJpkNoYpaL1HuH/lk3ggmhsIlMryrYxx+iuA/+HcE6z4oleiBrAcbGSTWbprUwUSvLX3I6PxbLY9b9VaU+5/JKHCXrA49ZniEiIWfNPVMf5X1G/W2teparqM+RIMCnK3c7REonKbbWr8vbpQBPQC82FGr6+g8ANYGkP2T+7IndZW0LlhbDHCp/MDO1szUpGsXIZzLHEgnOktNBiWeK6Uxw4oC/tMG7eAmuY5DYW9nj1NwIoFG0V9xC4SczOOpws1xWGdcpAlx8r+o+qPdCfl25aw4EAY8yqjbdM1wjGEj7Z5G13+dumQ+GOAlSz7kI+fBQynbGxqvTLOAj+PPR7WjsSewVa/WcDrYjIT6aAEedffh98N/Wl/8xDotK5sTwdK797Z+ICk9+2E7NlQEhkNIl6rT92Hea+ulkEVYVT7IoanIS1Ew8E+GTko4fzcAd61PQfDafj98DE3RT3Jkk1+N19cvQUgRowDPJ77jAC30lVl7EbywqwWzZprv3UxtNhls3DcwwKgakESIVtr9HYBgMAxmf4Ya/G9WNlXLn9VN2UJ+NZbpre4g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(23010399003)(82310400026)(1800799024)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SLMOM8HsTqbhUa1y4RRSMdbSDU6DeQDIFrYfYcw/puH4Eh9i4fONtK6OUlFzRR8XE8E+210S90lbyT/oOQQx9KNo4XKQ2Ji6AH5Gq4jAS/OoAWviOy1NT0Q1ZGJggpKzVraFNa3bjQAK/yn/Iyb0BVE9V0ux8Ml/eM4pKoAGM5UqmrRaAshHU4VfiClD0MpUGCYhlyu8ZVgFowrpoPAea0nQDKy/UEstWo+Mm3SLRvRI+TNuxumqYnAlZ94nTN1UzuDdvkoeEA7LBJPKobss4SSDNk8Z8WJvUkTBa3E5hwemdbBED8id4nOshNob5889D5XrX592kmlMRsS8/SCfzxpNKTB/vyEu1IL8Hiv98/Msx1ZMUyGhHSgqNVnquYYO8fh78dNuvZ6YtAWkiU/geT0Vm8c1ree4X/wj0WiAG6/GLL/BShermKOvVRJ5e+Kn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:24:21.3926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bababb-af24-468a-7fb1-08dee3d46be3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047

From: Gal Pressman <gal@nvidia.com>

The MCIA register can return up to 32 dwords (128 bytes) when the device
advertises the mcia_32dwords capability, but struct
mlx5_ifc_mcia_reg_bits only defines dword_0..11, leaving room for just
12 dwords (48 bytes) of data.

mlx5_query_mcia() clamps the read size to mlx5_mcia_max_bytes() and then
memcpy()s that many bytes out of the register, potentially reading past
the end of the 'out' buffer. On kernels built with FORTIFY_SOURCE this
is caught as a buffer overflow while reading the module EEPROM via
ethtool:

  detected buffer overflow in memcpy
  kernel BUG at lib/string_helpers.c:1048!
  RIP: 0010:fortify_panic+0x13/0x20
  Call Trace:
   mlx5_query_mcia.isra.0+0x200/0x210 [mlx5_core]
   mlx5_query_module_eeprom_by_page+0x4a/0xa0 [mlx5_core]
   mlx5e_get_module_eeprom_by_page+0xbb/0x120 [mlx5_core]
   eeprom_prepare_data+0xf3/0x170
   ethnl_default_doit+0xf1/0x3b0

Extend the mcia_reg layout to 32 dwords.

Fixes: 271907ee2f29 ("net/mlx5: Query the maximum MCIA register read size from firmware")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c |  4 ++--
 include/linux/mlx5/mlx5_ifc.h                  | 13 +------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index ddbe9ca8971d..9f682f6bdb50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -314,7 +314,7 @@ static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 
 	*module_id = ptr[0];
 
@@ -399,7 +399,7 @@ static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);
 
 	return size;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 695c86ee6d7a..8f18a508320d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12215,18 +12215,7 @@ struct mlx5_ifc_mcia_reg_bits {
 
 	u8         reserved_at_60[0x20];
 
-	u8         dword_0[0x20];
-	u8         dword_1[0x20];
-	u8         dword_2[0x20];
-	u8         dword_3[0x20];
-	u8         dword_4[0x20];
-	u8         dword_5[0x20];
-	u8         dword_6[0x20];
-	u8         dword_7[0x20];
-	u8         dword_8[0x20];
-	u8         dword_9[0x20];
-	u8         dword_10[0x20];
-	u8         dword_11[0x20];
+	u8         dwords[0x400];
 };
 
 struct mlx5_ifc_dcbx_param_bits {

base-commit: 3f1f755366687d051174739fb99f7d560202f60b
-- 
2.44.0

