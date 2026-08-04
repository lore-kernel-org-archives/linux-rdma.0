Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010039.outbound.protection.outlook.com [52.101.56.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AA843B495;
	Tue,  4 Aug 2026 08:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832652; cv=fail; b=Pug+mRUNn6RrLx3ytq+JsDOPb/Y0mqe75Q/tCODAc4Go3d5y5ihu+WjAeG6ldSw/RnISMcvxZ0xMNWn3PhdzMKTTStBDGHTo2uzhyOJqK6zoayMGBH3Ns5kqmIRkg8KADLU3oIOZXmLubA3m5+TkgdPF/leJPJGcYQkpiCejZ+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832652; c=relaxed/simple;
	bh=wHTUVtPo4Jc9ZFTJCwRVRrAkEYPn7TM6phZvvpMts3E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U2Bs0udSoyfkh6Xv0SzWytKadiSRtDhQyH63Al2lTEMHRUXhZfmPQLQoTSnANS3HNTpxKAL1rx+PmtyZdR/Z7i00dug8sUJMInIOs+/WUMLzGSIKRENdYJB9RayJG1f/ArF6D9Yu4e0bNKls/PUqt+LLgxfiEIkh2G5fvvcT2AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fprSJ8k2; arc=fail smtp.client-ip=52.101.56.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fprSJ8k2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7MKfsTOFR3pfYbcWn9CpPZ1q+Er108d4qR15i2OwewDJco64F3BoNjDJ83j2H4b/3KRa1yRaWic7FoF3eiMezJ9lmJ/iSP9rWxlpALC2puqeh1RJaJmA+oV2VPdL20IH0PyCh1U4U/K1WKbO4j24mdDSVdiPt8KR9fwV21jXQBSVPqJxRWOO0ajvX2I5+IJiJ5+xug7pS+Z0lohRYDo+UrZX/+AIKizBUeWoq245ruyH7kGoIZSp1r6rF7F5T/3SxyxYZHUmkZGFrnC4siwiRpVSZ0EY+nJ9m7TCUNeZnrsmGlNbuAiFVyYUQoK59A/rQ4uRPdVpKJzenSxGfSyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCuJWh8FE2mADeozQy7CgEIWrLF7bl42mZ2Ft+F3Lt0=;
 b=kJGawJEhzFJpEmnfPdHLZOZ+rwFceesZrSqtjQPrGLj20+QH38EJthF4ynhmVsJvbDf4nKUjn9bPU5UqOsAlZCDISNIPyqDP7sywjjup5+OhxCGfT2IBZsuRgKGHxaDyg1l2OjwuFTpc16w/aLT2AyrfPyA88/5Wn5V7LZ7Whq9eCsaWF2QiPb/03z2co2K33CIBB1A4zmz/rm66GYMbc5t3h55AUWhkZqL62QtuZPxVG2rMM0cNhDTH8jebOaOJnDt6rcOIsfPelndRkJNBw/IyQU3hkdBk9Ra5MY1Vau/f2TpAZUydHuzeBu6pQH9XeNT2R8AygnMCO29SlnQm+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCuJWh8FE2mADeozQy7CgEIWrLF7bl42mZ2Ft+F3Lt0=;
 b=fprSJ8k2ZZnWZQP/OoWhoK3ixNr8FEKOPlnwfsgXbt3TyyLSYrQEWvhLlYe8dYxHT/rmunqmx005kfPgSPHLaCVBLEYVwIlaurAA67lj/xOqROOjNJ6HHyAlQSUctneANtHGBezGDXxUEJSwYDBfsr1yT3LqHpUwva/71hCt757XTbzF+VpnW6ivxcT6p61ZyQXMGkk4YfoH/nxcHj96oCN24FAvqFOWvPpi+JTHWg93YTmMb/QxMuxJ5DKUqHQacs2eRHsk2b7/5gcDv01EdT8OJdKQkHSMrODDEjBunIRkGHpI/FuWr0QSNsCLUBnhu998ZaE2dWAtEo26+Ijm2A==
Received: from CH0PR04CA0028.namprd04.prod.outlook.com (2603:10b6:610:76::33)
 by PH7PR12MB5687.namprd12.prod.outlook.com (2603:10b6:510:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Tue, 4 Aug
 2026 08:37:24 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::72) by CH0PR04CA0028.outlook.office365.com
 (2603:10b6:610:76::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:37:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:37:10 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:37:02 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 03/13] net/mlx5e: psp: Block TC offload when PSP is enabled
Date: Tue, 4 Aug 2026 11:35:25 +0300
Message-ID: <20260804083535.2946459-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|PH7PR12MB5687:EE_
X-MS-Office365-Filtering-Correlation-Id: 55837398-4c21-4f93-ec00-08def2039b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|23010399003|1800799024|82310400026|56012099006|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	oV5S0OX0r/GtC41jwgl0/rI8oW3+GSrulhz65QtQ+m+b5H7E+yXDLvwLhjMi8ijCc2dfV+HC6SADF2Gg1LiKyE/yAy/iAxoXXhFnp6Vp9d6gVF+FUFQLDeALYSP9puRZa5EXvHZYydb0YVggQlNapYtDTVG8904BQmOCdbrbXxrf86AzyZLNyDB2luCVz79Sd7zMZjEhIm25Vk8V/B0g6JhOLBdZT9vTOjQpI6ygXyf5gyK2ZDYHXUNHRBLmRy5vaW9OOTs0Y5WZesQdfJQQR7Dz3T/hPd1RmnyDnNknJ5TBcs5UFiU7iHBm4XyTaJiSIBSnIjDFlVoqIjiAXaXJcGKGgOIb9QD5fmPRctqHVFeGyS3FMFm0t9Nkpgg7JPB5xGtt3lbIZcGLrBysv9/rRrGsVr1zntnk/Pi4IxzfOmDg6/P3kxDGUZr/BS8clZ3l8C/ZxFvXdmM4yVyTs7EoE+tEYltLQmj6A+8Pe8xfsZY/IXIYF/bxKL3dslIlcdcHHfpgmjYJrPRZRujeNUoWmZUThcD5og53iDTTrFRcKYOsWO0d96hzkcPHwo8v8zQZguMo9KZE7sNm6M/Rs5RHqDff9Ps4FLdywSnGRNoi0DxuDhXDqn31EVGp+w3lLNo9AwaywYHoCfnhccZiI6/XYXZ/yCNj2PR1GxgvQHmc1+oZld7+HJd8dZTf9euAUETYQpJQO+4UWPG64cbFUnqDOw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(23010399003)(1800799024)(82310400026)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BfIyEFQAO3FJYNogV8M07i/nIg9fmonNHHHqPofbJDYfHzCAsdVdLxcIvDVH7LS5WZh/GrxF7p+5JtCNJKwZTyymo06YQgMFXuiV3mYMRPitZFXON0U+3LWAZ527sutCwoBvyjd5ozImsuAGs/DFmbYicYGAR6kWZv0gbZvC8PuJpzOU4zHmNHDqGfQKtjXrnmdrTLoZ2/A6hdEhb4b4CwGe+QhOwOpJL13pOdbtejgK4E7mlmUZad6QpfhHZkmFMLbW59L78OJp7OVt2Xb0TyqhJVXFO+QBveOIUL7KwwbewRKWocEbiBZNv14g7i1V4ugyUe5Wvmn2QZQ7WnMXutZNP3YkJs3E59om8v6aGmb0E2O14e4FrcTNDFkAxZGHgJw4Uwe0G8DFok6jx9rivVRhCTMrTl4S/Fn1BH8gCRWMWpw5gKa0lZLVBouYsJV8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:23.4768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55837398-4c21-4f93-ec00-08def2039b39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5687

From: Cosmin Ratiu <cratiu@nvidia.com>

Make use of the mutual exclusion mechanism from the previous patch to
make sure only PSP or TC offload is active on a device. Later in the
series, the PSP protocol marker will move to the flow_tag, which is also
used by TC offload.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/psp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 73b232379263..6cc4b9d54f6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -6,6 +6,7 @@
 #include "mlx5_core.h"
 #include "psp.h"
 #include "lib/crypto.h"
+#include "en_accel/en_accel.h"
 #include "en_accel/psp.h"
 #include "fs_core.h"
 
@@ -526,6 +527,7 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
+	bool tc_blocked = fs->rx.ft;
 	int i;
 
 	/* disconnect */
@@ -535,6 +537,8 @@ static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 	}
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
+	if (tc_blocked)
+		mlx5e_accel_unblock_tc_offload(fs->mdev);
 }
 
 static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
@@ -543,10 +547,16 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
 	int i, err;
 
+	err = mlx5e_accel_block_tc_offload(fs->mdev);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "TC offload active, cannot enable PSP");
+		return err;
+	}
+
 	err = accel_psp_fs_rx_ft_create(fs, &fs->rx);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed creating RX steering table");
-		return err;
+		goto err_unblock_tc;
 	}
 
 	err = accel_psp_fs_rx_check_ft_create(fs, &fs->check);
@@ -583,6 +593,8 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
 err_ft:
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
+err_unblock_tc:
+	mlx5e_accel_unblock_tc_offload(fs->mdev);
 	return err;
 }
 
-- 
2.44.0

