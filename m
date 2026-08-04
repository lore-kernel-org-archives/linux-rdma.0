Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011005.outbound.protection.outlook.com [40.93.194.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9643B6CB;
	Tue,  4 Aug 2026 08:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832642; cv=fail; b=j9Q2ztAIwAwJkNGR4nkGn1Wm2TL8ybLwEvXkOaoq554XHd7G4PrRKvlmuNjXDoW8NmzbraJvRWFD0Z6JwEFrxNDkSSrZN6J35PsTfJ4biuVhO9pinrxsBN70tZ01vgAZSNuHSh3ja0ywyRVatP3Uf2C2mVT9F6U10IPLvMWVakg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832642; c=relaxed/simple;
	bh=/yVgWGQ5i6NhfGrZNZkTvdeFQCeJzczJgmXlUGs1q4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VCBZjxkq4Jpn8rL2YFP16GAZ7A6QxJdIjNVdsQNDdS1c9cYko5SdKVafSTOYvkK/Klbf1l2Q/sqvMWQVC6+w+qPirsn1p88k86al6R6kiWSIGHvUt3fO83V3g0hgufq/0VIE55Xl7saq5ldALVtea9QeZL+0Cn+vEKdDcfVReT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rCWJgKzT; arc=fail smtp.client-ip=40.93.194.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rCWJgKzT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IcTixgLYP30vAcLscsr2wFc/qucmhfNfnxdxtDBaAgUSUqutyDH1y9wjHtnbqB2Ar1rOpyQkFX520UNGSsHA4pgTvZJyHSuSKsfFKCRlaNerqGd4RBG59SxJeb8D6QfLolIa8O/eXq+JmyM+Reaa7LCpV89JJqUgveV9mds9N9n5tmsTpKo1AC0CG7MHOyoNIGxHbJixEYHgnNl2TUAvoY4ATLpR8qaKka31Hnhv5FfT3HG/xZdybITBFQzW1qCp6n12bh7SQcAziJvIcAejfaxxayk6NPKttJiNBeN5VzVxEMDk1bATk/k7Sd6meCSrIl+2nAdROe8kC2H+RuCziQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwjGJcrgwcc2qsyZSD1f+yo29MHX3+7gcnDlCIyfrWc=;
 b=uCx1ibajfeB9roiliAZR87R7mZfDKDbBMB6pf7OkXTo97eSONgZtFJa/tEg8+rS0Gm+iVjzB1hYhiQw2aFnYy+KDTuv2DnL9tN981Z4wPsgx2hzgkDNsKC4z4Wtvo+uOlrTU8Z0S9C3p7BZbVsUvxl3RSLiO5BHUWGC19jNjtEvS+zowNjyyH9fUlmKPB17QeU2aq8dAIniwXQ2lO8JBaAmC5XYbXCrCUsFeVahML1EWXRgrXb9wGw6LMERXFOKLtoCYR0YPKR0TCtR66ztyixEl7ngRsuwkHs1UCt6KLr6RZo/ZRfpUqDMsG/6u1hsJGQBWOx8Cxa8dlQCtDAMLSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwjGJcrgwcc2qsyZSD1f+yo29MHX3+7gcnDlCIyfrWc=;
 b=rCWJgKzT5b2h7LV/D7/caPwEb3/bjahWUIqmMNT/FjhqMqJ5Ckv5TibKTV/OwNuMnxdwxyYHlS+/aGlRRkRi3ViFVR4/tyB4Q4YKCg8Z/IUjQ6PZTn00bc+q9IlRuwXRaOGobLpU7LqFb/TSIN9NHS6anBx1Dw64s0vlogl+B9grUytXlYBikwdVPhxUr5JrACAHLPDE+jxexeSH4ca3I0hXWz3hEzg+BkwyzZ30RTrQBd4bkB/zsjTW1SgJnTYvljuTZNUupqGlxG3r0eoAmlYdh95Nl/dqT4D8KPplThqH/OAePL3TE8g6G96DVYlDZUXbsYWJikZFaV+E0ach5Q==
Received: from CH5PR02CA0020.namprd02.prod.outlook.com (2603:10b6:610:1ed::25)
 by PH7PR12MB6956.namprd12.prod.outlook.com (2603:10b6:510:1b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 08:37:13 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::3a) by CH5PR02CA0020.outlook.office365.com
 (2603:10b6:610:1ed::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:37:02 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:36:54 -0700
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
Subject: [PATCH net-next V2 02/13] net/mlx5e: ipsec: Block TC offload when IPsec is enabled
Date: Tue, 4 Aug 2026 11:35:24 +0300
Message-ID: <20260804083535.2946459-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|PH7PR12MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: eeac12c1-0d0a-4f4a-b73f-08def2039529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|23010399003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	OkUWIKIJ9GqaTB1oGfgPOuxAOe6jVBP83Z82zRLYe42XplcuO6rw6zdrtkGrMJZTcRZ5LRzxChEiv+K0UzuO0itQn+nqGBnvKjflDOZPZXf6pVoNvfup9ZjW+jj+/YpLU8JafuD+jLwbE9QDeFeBP0nnFPWujy48DnnA+t5zk6sTfmMkaOTfFpBQ+wfET/1n51Ym4G92oTRDMFM8inB7dVZikFI+sJ37D+Hb6157qdIfbg9qhAaCp7TLfPMiGyqegri8xOVbXQIHtkjyKem08iDLCCyjfLuZ7kQD7SHhS/uLWaHEJjmlozr3VbAHxSv1hllCDaschMul8ULPff95fSKhMD4he37wXFKwCcnNeWABQXOcEJ6V9sGv/SixAhm/cu7hzGqFimQiwpfM1qsifvyjr+SQIhPe93EL+lN8EhHL/QpRecZdUq6wcYEcLT/BJSWD5lYvRULze11mWaCvs0+wE5VNW50uIZN14mjfQrSfzGLWOUennr0XKGkdueV1n1vJyihNKpbMx2PVPnkhnN8iIbIZARFUDOaOM7FMnwqa6eQkk1sDscxdEnBXCFmL/HAibx6cr2hWFFpjumXRcG/dzSqlzz9rbL5uxCXQGzCtioCIcOU6B6Baojn4LoRCYRHULhVsLa84Zy/KlBP48TVO013z2FWfXx96sAYcNRHF2tAyijPz4X42iFMMkhpUQlGYzXjNWyvuPXtW/U2nEA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EqqdTTqqmrxABOtC0GlRXHoD9EaFix9SRIaAHQfEoI+Spdx85A5GPu4obyPBrAPTRL44g7FRgp2JIfAu2dZ1t2lCnJRlU/pm9S4OwN5YiA5LMlrh/vBWkU5dMfr1nQzPsivq7lkK0JvQSihr7ciganbJYNeI6qqpisbhLn3rAI+jde8Y2p3xwV3uoIhLZhZmoZ2qsmC+OwPoiilTG6YmjQHCRdJBt1dop8RR+kQ2igH0l97UoFLPP8/rlZcHhHk/ySHoKhk/oT7qjiPBax0Wh5nGXiOABbZZqbyb0uF/yyeqh7t12BRgXPVO1Gjn6si/sheB50ty9jrWlfPZPexssZZnU1Y4oFI1XPKdvAX9trUpOjRGCr7O/tdOkiPoIRWWevLJ9+aECaQa9SkTJObXhx55OKyMsQrmjMnfLtBSGgx6tGV9aAR/uyMar0bPScyo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:13.3299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eeac12c1-0d0a-4f4a-b73f-08def2039529
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6956

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

