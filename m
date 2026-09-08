Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683A433E37A;
	Tue,  8 Sep 2026 06:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850502; cv=fail; b=UQ/qlHpAUDSt/VrGSiEE2r9Q024SLiurnA1ImbKMUnipuoVMmhlorxl1vzgtw1krAvwfR3o8B4nxguP8ZPEDfNrh2YXDjOawoO+enSnfoJizV+AKYQWYT7yEjeMg81dhZaPSbOxwoc/SnrVGNLaokFfgGnn2ULrjOvToKXORwFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850502; c=relaxed/simple;
	bh=NzTLbaGwjlLNgf7VDf3kebNHEoWB/e8QSAM6oi8hDcU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihk5WgNL4lKtMjadwgjb7nsiHh2tu5e/NoH2Qbosa4V41xl40gfYHwPCiSmdvGNov57oW5yEGmuKGIV+GvqThPh3s90L5LauFxDNdlowY3UloEfA45MPz3OR8jy+LFJvHj+sCnfU7dIomG2+y9vLhsJC+wVt1Ma43yy9x6cydyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RyGDhPnB; arc=fail smtp.client-ip=52.101.85.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RyGDhPnB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wT67FJQe8II0uIimXh6HcHMEN+4hraUOsxwQNs8LT+idJxgffA+XGd1K7UUiNip1sjb6N+wH3jR8y5SpBHYaFr32EX6MG2ZhFFgR37O0fesmQ65KSdeY/uFjwXl5KNbZ8GNoxx81t2nG/Dq47poYoKl4gn5uQdbfC5XcHza1yUleh43+f+Q+n9w3o+plbFn0+Lpyk/v6ZUgbTQBOkEVL6jFn+IxZ6SZjoPaY/hlroA36AldyLkLfZAqlqVukzB3xpdXolqwtzrp5D11Y7cZJ9eCb2Wz5lB/kfbU6/3BPYeXbm9gTfgeMpL1nCLb2jenQujzr3ZdeZzgEnq3QIuStEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck2c5iiKlvN1GAg0xM1wL/AEaNa4YEx948jp7xz8p44=;
 b=uwnMjOos09j5nox609k0r/54LIY+nYM0761pNVl4GQ5c9bQKBAcou66BSR+F4powOJpO+E18qJjgFF0JySZYlMs/sSgSz3AWsL9uz0sTtpZwle6zCB6cACCKe23UJ4h0Afz87qGGWF9PLy+9lGy0NHSFX+pHvputODejKCzxZhMSFk6ISkPWce14RcmU5XIlfcc7VHkaCGl6JHNXzOonPgHecju231kf6S0CzcujTVXKCRKtdNLhOIRZm3eAdks6dCJQGs/3hswCPmHOuqdFtn+YcBjTnZeonygT4yWge+KHpfulM70HRf9/IfUVnM078Gf9vAln0L0XMlc5x3bo6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck2c5iiKlvN1GAg0xM1wL/AEaNa4YEx948jp7xz8p44=;
 b=RyGDhPnBQI4gtpLk4NpeffTBPc0cyoeP4xKsYU/QitKumQqvFVTO5Sb1yJIBGqrUsb7JCxnctW4bDJs/+OuMHMTQN4iBv96ptqL1iWLOl9C0ocq05QpNd7XCtrSMwfhCy87eecYOII+NQ+SCuUEpoaDQvnRD5uwXBT719qVdi3NNJSXObN8FbulGrMiDRYHU2ZLM5vcTNfbzqZhYaAvdFopEQD8WtmdqvMFJvqRd0zRDeXbvlqko0QNvOrXVTllCx8I4Jbm6sZ6ORcOLoobCuC+k5Ou08QApkVoc74iN8impb/qgtIvQlCtc4r/ve+Be+/B8KA7s4iTkClaXynafqQ==
Received: from BN0PR04CA0071.namprd04.prod.outlook.com (2603:10b6:408:ea::16)
 by CYYPR12MB8853.namprd12.prod.outlook.com (2603:10b6:930:cb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Tue, 8 Sep 2026
 06:54:55 +0000
Received: from BN7PEPF000000A6.namprd05.prod.outlook.com
 (2603:10b6:408:ea:cafe::3c) by BN0PR04CA0071.outlook.office365.com
 (2603:10b6:408:ea::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000A6.mail.protection.outlook.com (10.167.245.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:40 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:39 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:54:32 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 10/14] net/mlx5e: shampo: Flush session on PSP mismatch
Date: Tue, 8 Sep 2026 09:52:40 +0300
Message-ID: <20260908065244.3799142-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260908065244.3799142-1-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A6:EE_|CYYPR12MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: bf0015ce-797e-4cbc-5c3b-08df0d7616da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|23010399003|1800799024|36860700016|3023799007|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/pMeSNxL9umJf3OwojjQX4Dszxf9PU5/FB7SMcQ19yeCdgWh8ImYDIrhPIkcKvlZLjIQAhuhFrzWfMCuRbsQMJjT77Gm60SFxvkgTX5Y//xCkt8ZfZpIemd9NYow9KNEqlxBDfb2OIhnSd2VlLNctjte63l0/n0E23Jt4dBbKSk+HLVQf0+HXzHOBNuZFjQG4lht6KvprOZLVJpk8uFe+aEGkHKE89bvdoNxqpmUHVeurgjsZgPV2Aq9q2nD5U3BJproXcYwQqIphukoSKcBl8sLghg4gGbx/cGMi0Mphc06b6bSqUrsouXV1MXJ58/z3HSoo44yS4rY+j8mE2Ctaq0qD02Q85KWEO2LXhLlN7BgHn21R/zN+BVDs7r1sbgLTMz+jwMqOxo4HmKY6eNziKLtN8kJUjpUbpdcV8JRmefIjvcLLpHimG92f3ZYD2QH8Xz7T3VfvAxBgd0ioxE9Pe9T4Kw4o6Lmrq+HYo1x2S/25svXuDVF4RIfGseX6Yk2npnM5/dT3mLzhdeMsMeWIJCzSt/FR5XZLAEsZFtMUzEk7fyxNDLHmW2dN2RuB27QCSIoPGYjJGhinqKLmtpgX6WYOY/vFMyRTlwwmkUGmA80dkitpAyl7njrFI0hHl+MOOb5enJyzV8aYRO0doBET5YTta5xTtkZN0FEzC3LQ6/bvR7iwqOJGMgQqYYjNizEQE4QcN8vCClkXtzF7wuN9g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(23010399003)(1800799024)(36860700016)(3023799007)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PyUFGWWSRSivQhAshBH+1SOmvtKwaMYvTwqP70OFxmNePSY6jWTj7Rp2mzz0qCR6i9zKmb55n+xL7Z2UFEAuxbbfvZLdTpI9tOi7w1GKJn8Si5/yXwUvsew/TOvxLl11SyYp4FG/vU4h0P337MRDXg+Hj0tTcWK74h54O81SFWLjZowG82oE8Qjg6oIa8NuM4IZ0fY90AhvSX/DpqwYwZdzb3mF/SUl3WMO8+3ef3gfLpp8vL4q4P+baEWGq68Wo0qVAY1YxsuBUy83hMrSIo8PRYc/ylZZQpzyF4wMi1ILJxnODPDzelpRrHqPqu7a3JlbAI2rfDUzevr7KNaPjoljJIvufnphl4xJvT7tf1FQsmVHOHdkuj7CvLp8lnpK8rrhMw/dt9D9cX3tltTFS1l9z0DrC7w/rPXpI90zTp8I7uasOFUSc3gr09bs8KAK3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:54.8618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0015ce-797e-4cbc-5c3b-08df0d7616da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8853

From: Cosmin Ratiu <cratiu@nvidia.com>

Flush SHAMPO session on PSP status change (no PSP -> PSP or vice-versa)
or on SPI/version mismatch. HW aggregates by 5-tuple but is unaware of
PSP fields, so sessions must be terminated when security parameters
change to avoid mixing packets from different PSP associations.

The session is also forcefully flushed if non-decapsulated packets are
received. This could happen if, for example, the decap table could not
be created so HW GRO is active but there's no decapsulation.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e3f915beebe1..9eb11be7abe0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2224,6 +2224,33 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
 		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
+static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+#ifdef CONFIG_MLX5_EN_PSP
+	struct psp_skb_ext *pse = skb_ext_find(skb, SKB_EXT_PSP);
+	bool is_psp = mlx5e_psp_is_rx_flow(cqe);
+
+	if (likely(!is_psp && !pse))
+		return true;
+
+	/* No match on PSP status change (no crypto -> crypto or vice-versa). */
+	if (unlikely(is_psp != !!pse))
+		return false;
+
+	/* SPI and version are only available in CQE metadata for decap flows.
+	 * Non-decap PSP cannot be matched here, force a flush.
+	 */
+	if (unlikely(!mlx5e_psp_is_decap(cqe)))
+		return false;
+
+	/* No match on security parameters change. */
+	return pse->spi == mlx5e_psp_get_spi(cqe) &&
+		pse->version == mlx5e_psp_get_version(cqe);
+#else
+	return true;
+#endif
+}
+
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
@@ -2266,8 +2293,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
+	    !(match &&
+	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
+	      mlx5e_hw_gro_psp_match(*skb, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}
-- 
2.44.0

