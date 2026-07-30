Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012005.outbound.protection.outlook.com [52.101.53.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF8C3F9278;
	Thu, 30 Jul 2026 09:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403152; cv=fail; b=YG8k7uQTuAcFIQyS7JBVLCLctHwUjWVfTilvorviWLb76JCbBI7T5V5IiDVmEeMtLUXOmxcomj/hZZnYFMpqBKNn/6NPqpFYUO4C9tPHAzmkDlRHKjqPR3HVgdf1CXPXWX5LUcZOmD33D+MKH02YPZAPgrCzVjXumZONjFxsFTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403152; c=relaxed/simple;
	bh=iqjSEvvhYRQuJhUWRecF/67q8wladK+EYFXmXG8fMK8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TqAvomvXzQFpMHGNPtUlpMH12Rhf8DOPWzzsROd+8DB/pqdKzuMQ8tatQsDi6Q+TUhQkUwdQsF2E4Db6t4n2uxxX0MrVbZZhjml+CamxZEGrYjCJ1Fce6fcPPgf8QdwkbT6SE8l6ksVSsj4f1adfo3iaEI8GlOKLlXxCnDnjNtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RgWaJ+A3; arc=fail smtp.client-ip=52.101.53.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RgWaJ+A3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaq/0Oob9DtK97dYubt+8JosbxKH3uuTHW9KgZERKfuAq0FOvves9Tyq0iuzaUcH/ldoaFK3zT+aUcdvnNK0zR65RMlTZcnueCiy2ny9qPV9FLsHL0IrKednjfAWnE+H2ZouSFNUVpzYit3W6yjcdg0aWCaaMKgE7YMcMM/wdgqxyQ+Ip3SgN24y5NR9STp+e3LfcVAWXgU8tWWSDZ6PgkkOZc3EMvhUi+CgqhoAz9fi7H0pdarxbRxoCY87htjyrv/EmGSeT3jCmOIe2gVQutuZbufJvkZ9zK9gj5SBSuijJVXf+IpjfJZeLLA41j3x3NDaj7vVCDAUhoXeGcn6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhL7clVwrzojO7vicEjP9ZbfyKXmx8cmdGKqAHizwzI=;
 b=dtDD055lZgrs6F5jHtzfBmpO3p3eQpDXVVshjwKCaNulvwT31DL3VRNNndwlBrRXFW3/SyeLg+psIfHU/NTOxEF1omlxoZwvaiiPKKeVtdvnxVjkSlAKlSdqg6mnzQXmP+W5r2/DbWu0AJ7WqlOZowHZul3JJEZKbotJSnAJBjWUDPy3rS8Jfg/8dhltDRIvQdS2f+TSEK/86xRAtUqbDYMzim8/CTeAjZc+OjlGxps1LOA3x3z4UeFBtTaU2lr5atAvmXL8UeJf3mAIjDEelLASbreJwgrCIYSyptfFcmcpzs9rGEmY7HuQzArHg43jjpGUnH/nJyuNozejdZ4xbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhL7clVwrzojO7vicEjP9ZbfyKXmx8cmdGKqAHizwzI=;
 b=RgWaJ+A3weDdoo/s3E2llLDfbHB3dKu2ktZXYnxtvzlQ4z2f9WccVxPbIsHuliT4nOgvpvu1E9vsez40fsBG0BuCwHSZvFBorqS56EcDzn5a6i9MqWC7HdHau6JZBhEsb0uWsYF5SvLrdfhKm/SC4ju5cHlnWwvywMTpuVL2PlWo8xAFpZKXS1u4eFhWNIQtoT0sFzjNRZfhfm+vih3WOekUtHBGQc2dJ6VM69JXjhnwbmA6FUczJEvuk4l+7TuoQuJB/8Y3BV/cX+g8XIA/HgGli4Ylf1yoNI1uGAdWq83IQ3sTm0MJpztZJdwlZ7PW1kRuDt+iIpnYAGJHoVqFDA==
Received: from CY8PR12CA0046.namprd12.prod.outlook.com (2603:10b6:930:49::24)
 by CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 09:19:03 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:930:49:cafe::2c) by CY8PR12CA0046.outlook.office365.com
 (2603:10b6:930:49::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 09:19:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:19:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:45 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:18:36 -0700
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
Subject: [PATCH net-next 03/13] net/mlx5e: psp: Block TC offload when PSP is enabled
Date: Thu, 30 Jul 2026 12:17:45 +0300
Message-ID: <20260730091756.2543777-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260730091756.2543777-1-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: a4e9a493-c8e3-4e69-c826-08deee1b98b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|82310400026|1800799024|56012099006|11063799006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	N2iGT1tiGTyVmT9Ls3J5tgkOWuFwMPUasKma3aEDulieds2UgKNSXLEAPDO7ogCTGMSBgMWuSxRL9uFAoBkHqrJebedNKjDfc4BRJWPEqwwbACQ1ebQBOPZJXIZvE8dTRRdMHPGUBtO04Af9/vVdsqnYGx752CoBxt7s6EcOm9XGNSxHq7IQ+gMuBuPqJpPOIjXp/huloXeItDlzKtVhl2vaPR3UXajeDwQV+sKo1TToM/KAoO31hLQFTAPu6HVfx8YVGE3SGotQ/AvF+jwUkRV5PQCbb72DzPkF/rLf+k8UQE+eHTIhm90TZ7qEHrGsGasZGURqoXF/5WOppKW6HMIoUX2lPoWjnm1X0v64I41HRbEQ9+6IAFjeSNDjn3t7YsnRaJtnD6HbAyrdHTDJCG+SevIajml2GJhoUOZDNJ760+ZJlYEtiuyRNE1rBwRJQhXN5uXEZOEuWYNLdmS2FHtfsjay9bjnIzYnlkAAf3kZD34IEcFGpOIfON4RC/Nf7HTbGfJNXRmMcAYsDdM65MqXDim8Kv/YhTaj6/Is0ncpgS2DmfWhKe2/Hy2F8fQQVULKGRz4y0A2POVMVu2IIDPV2ve+hnh6GWzzIZJyqmaWqqX4d1fh/e1zhfj0ZqrptrL96wZ+2Nf/6pg/kfzRvAhzbBMNiHCNmqqmUVWRTXDfBeqEmZH0WmO5tAvAdhIG/Kvnc7QaIuox+YWK5c+Isg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(82310400026)(1800799024)(56012099006)(11063799006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4c1gvqImUA4/b+8e0LwR652F7tX0CrNDIea7Q/hq+z4q1DfeCU92l1X3CQbCCRuOCXuS/mgUPXL225imQ4g4sAGRY0tX093vMb1ABQdBHQUGxzsbSmdU9nH40a//4vgv9WCiEl/Fa3vQRgngvWbGRZMWvnTjrUQoLzqom4NZbubx9JUe+6t8/Ag2UDjhV+QPfg4AdatrpT9LBMQ5JmPhlf1Y4sBJL0uUnwJOuhgJWO5LZvWNci+mZal8SN8ot7z61vZXJM8OHCWaucUrkevPnhFnJM7vbF+6ic/QQQkWXX0wnaV6wzl0MM1h06NzrMNYH2cADlS/naAL7Snj7cHrm3l+kPVNCSSxuuqZ17GfkonVCfEDv6TAueA+peY9xiTeXATtVJypt6/7qkP6KRmzsnQUXq2MM3dj1jeGTiNxz8fHP+XnQ+3lX6HqOGWlikUF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:19:02.5939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e9a493-c8e3-4e69-c826-08deee1b98b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430

From: Cosmin Ratiu <cratiu@nvidia.com>

Make use of the mutual exclusion mechanism from the previous patch to
make sure only PSP or TC offload is active on a device. Later in the
series, the PSP protocol marker will move to the flow_tag, which is also
used by TC offload.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
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

