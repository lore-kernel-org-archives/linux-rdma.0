Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012064.outbound.protection.outlook.com [52.101.53.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645C3F9F50;
	Thu, 30 Jul 2026 09:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403139; cv=fail; b=kmS3bdlFaEPVl4q5ZvjwrnLo2lv6CDl580c52cvWZh8AmYsa8l4zHrwMrtRPONRi9YGIniidyRBIDs0BIR4abqizau3xZYM9W8p3+z68lJLIv/XVtJHexalTOCZ6DYZ23iJ02N8AbXG7WvrT5A/oXIYoUdK50TvMt8CD3PjvgsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403139; c=relaxed/simple;
	bh=/yVgWGQ5i6NhfGrZNZkTvdeFQCeJzczJgmXlUGs1q4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ton3YFyYcRg7ZbURF7vDIU8/LmySfHRoF+mQ8xibeQ0EMAKZ11yy5UzqrvnobKpHUcZ1d9ZYY/xOsDEaEkezKR2NKTQEcFkE5BH3LjyslU0tvRPjfHbQO1yBWKR8NQkTQ1b8wiidHfCQkJxSv/Ej2F1OB7nJc2kfAKRDBk32DpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UggE/qZx; arc=fail smtp.client-ip=52.101.53.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UggE/qZx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQ2G8M9Jy2z3IGKO4XuEV15dC8v83K5k9/cX/Swl7rtULLqIY6NfWO/+HCuv2oCWlnIjPd/BLM7Z25UJbxRrWhM9Q9fuobDDUHIBaSAyDgZ8aobqYH6sHEPVULgormCmTvjR2JXqIHIYXXA3urk99bnLICjzdGxhuy7exfBOhtUOqXXIYPo1s9lUKOLN6jXbh8zARjo6U/cDC/ppbCxnPlg/TKUkkqo4+g2sRXAQiqkqmfltK4LurLkcrlN2asHjlLFoljVPyhcAS6rUiGUx1VNZdu7AqJjFTyk0ZIDGtB7qiEuhIfTnLZLb9lgj07gH371LzJ0j2AZ2k916UsxbMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwjGJcrgwcc2qsyZSD1f+yo29MHX3+7gcnDlCIyfrWc=;
 b=uRLjoYDzs7YgZQMOUHs3+0VIRRlu0CkNInm4+wgoZoQ6iqLKDpiKQDOl3wP5cbWLH79dDAh4cUhUsJn9oVdjqpmIzKnV4D/TrnaOnUIbe8AJYfR8kdrGH9I39UjlDPw/TcVKdIqdyYV3DXbEi09in4qhbRcuxEYF2B22ohxle1mPLryuIhhJ+XO2rCbNrj9njJy23p4jJVgGIITa1AMQ+aTO2onVBWlQy+T8sSd6Z0HR676beCtCQ+lPnbvOihuN61xms0LvHhFYIAGaQWIOszPVB/4jB34Ow0GSf8kSu2WVz06ax5l+YRDD7Mdqe7N7SqkqC8bvSD/zYUqMAGHZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwjGJcrgwcc2qsyZSD1f+yo29MHX3+7gcnDlCIyfrWc=;
 b=UggE/qZxcd9pURqT/goFPv6aZmWAbcMzw01LI9OirvAFRy1ZA9bPqIyMtNibvBqhY8dt8lL0iVaO5KwDIWQqYoVuNriZSHdnGI6uhhrJNI9AKpazWlZmJ09xw15EKoQLIS1l2x0n+BHTXIuDkm4RaicC5tiH33MNJBM6zasP7s2b/5Y6xxlJlasgCzOoYIL22wOkSebSZtFQONVBp44oF0lYLGoMbo5YEMLMf5ewBvUcYrS6ATbz9y7oP+NAfqMDw7iyLSLqzlEjGcOvTvGs5PdSVNn0MDySFbZMge2uGgWqm3mihvTpcro6i/s/aMhEajnwxpzlvLR9hMjjfxPoFA==
Received: from SA0PR11CA0094.namprd11.prod.outlook.com (2603:10b6:806:d1::9)
 by DS7PR12MB8369.namprd12.prod.outlook.com (2603:10b6:8:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 09:18:51 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::23) by SA0PR11CA0094.outlook.office365.com
 (2603:10b6:806:d1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Thu,
 30 Jul 2026 09:18:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:18:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:18:36 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:18:27 -0700
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
Subject: [PATCH net-next 02/13] net/mlx5e: ipsec: Block TC offload when IPsec is enabled
Date: Thu, 30 Jul 2026 12:17:44 +0300
Message-ID: <20260730091756.2543777-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|DS7PR12MB8369:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c383182-62e2-43ab-d974-08deee1b91d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|23010399003|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	09Oxdf7YLfJgrme+Jw2KkWmxXfIHadwJm9hSGZIo5DhXTHIUqiMhr/rCgM5efIOLXoPv5w9TerAC01HmwL1eubYBAU0a2hCZPZaaysFJ+lY0ZJLojQMz38zRyoEUO7XPXnaTG6jOSynvHD0TIDYHcC6306fSRwbB5wDZnK+3TCuTNUzOeeHQiQk8eIEOjmBQ9rR7XgNwNDPb4lpRaOwWrsm4tlN/4LHvmp5YsEYMeAPcVY8YkjyASwBraOGUqaEOiURskKKUwOmturGkGOejj3dLPMxgzfjCUW5gZuA647ztRAu3jK32vI2AFj2mOealpn2AVCqXjfBnaalRiWXjh+k70knxx3lIvbuy+YYsUXFvdIHo/6xVoNJRaQarFBp6kyEPgcTZvKRdOazaKyeSVTDuiIf98RtfCOVUzniiP0MoPDO28aW7sqpajDn+SDY3zhns5w+H/2pAAh3Zl5WJxh201qOBLqDVJKxuEXhW8I+baatv8ZzUfh0ZrC9VytnTGPZV2Tby2YgRIr17aE1hlkHDGnDQXDP+pb+Kyt5HpdL0C5aYn+LH6fYQsxml91F7HBKBClVJD2ItVST0OzHtH2dCY1xvPs+Q0bijkwl8k0wxqfVTiCm3g9XrhjnmqWSODAC5KNodHaVWvnnSzZcPU+JLaSxBUEqNmKKQfVryN6jkvDSfJ6TNn3Y4SFzDG1gnd+rz+d98sSSiH/K+cNt8qQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ydzrDe0yfghoLchz+M6nPqkd/gcGPI+e0S0g3aNXFdjtuRbvh4IRm9wnstQDgs+XMZyNc3gOebeRVaLq23njuZYGicmmil18EATApPwlUYfP/XZCo+d/nd6sOJbfyY0tFhb/uRajhZhYougxtxugQsvD1d4n0Mf9xIbyhRD5UyACfIokkoB8u9cDEjpO2ndfNczAQT5yb/ii7tOiHTpCWIfvQ93RBY/PqhK1g9r5ijjKq+5zjXGyVjfx794Yi3MYp6uIU33yS8GhEhB/U6llS2etPmzIJIIu/vuCpCN6yDGo3pYAx7zzUAxqI0Zg1VvZdveCwKc18sssTHW1uvhgsyszU/zw0eJZ2nKEz3Q5YA4PbH3ZeARVqxlFsajTgeHOANvOUYaIUsazdMj+4WgsH9Aaq/n9Sibb+03ZwEo0lhNFBFkO0+xfecrp4J3gqn/8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:18:51.0320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c383182-62e2-43ab-d974-08deee1b91d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8369

From: Cosmin Ratiu <cratiu@nvidia.com>

Currently the mutual exclusion mechanism is only used in packet offload
mode. But with the upcoming changes to flow_tag, all RX IPsec flows need
to block TC offload, so do that with the help of a small helper.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 74e0aa5b6133..f236672d3a2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2575,11 +2575,18 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
+static bool accel_ipsec_should_block_tc(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	return sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET ||
+		sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN;
+}
+
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	bool block_tc = accel_ipsec_should_block_tc(sa_entry);
 	int err;
 
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET) {
+	if (block_tc) {
 		err = mlx5e_accel_block_tc_offload(sa_entry->ipsec->mdev);
 		if (err)
 			return err;
@@ -2596,7 +2603,7 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return 0;
 
 err_out:
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
+	if (block_tc)
 		mlx5e_accel_unblock_tc_offload(sa_entry->ipsec->mdev);
 	return err;
 }
@@ -2611,7 +2618,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (ipsec_rule->pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
 
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
+	if (accel_ipsec_should_block_tc(sa_entry))
 		mlx5e_accel_unblock_tc_offload(mdev);
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
-- 
2.44.0

