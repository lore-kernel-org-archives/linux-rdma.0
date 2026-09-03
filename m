Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012064.outbound.protection.outlook.com [52.101.53.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F78C46D2DD;
	Thu,  3 Sep 2026 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425726; cv=fail; b=XN35eImN78hbEz5N9HAYPvXGZvEzH5apdWu6IJa6X1oHFpxzHZsqshEqDVN1HyAjwemfKR5aSvFA4qrFi4Yirs5uasz+mvmhl8It0DWJIx6FBthoN94T7MZCyBH40VbeTmuZWULwBr6lb+m3Ql1K/fc2e0ptlCX45IavEyhD0QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425726; c=relaxed/simple;
	bh=dGV6xIC3D8rO81xkhh05x70pdw64GuArb2Dk/aSKZns=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iE2VBVe0yxXyZudhaFuVPp1fMq1h9egi4lz0fxgUw0x6nxrSdDlDhc3ScVb2OkYJsmSvUUj0lxMRKXIHSScl2HsYbYemvfJvUNciVr/RjkYSqBR6KPor5TnqdVTbivaSjlk7RNs2AyZvjGJcpy0ST1StbraA7/dmaUeexxvuG18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t6+WXnFz; arc=fail smtp.client-ip=52.101.53.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t6+WXnFz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6fkSG2hNTpcKisZV2OaMdx4GSyLm3VJ6pmgyBbsoxB/XpCE351F5LX2mGJPnYmJgkaVQtL6+TIPAJqGVVsxe20Fc+mf6lNFzzo1MK4fFDHY033KHiJUdvOIIuGHbYb0AwHVDRTwmBN1ozrFF1vwzbesEpY3QuXgpogYtyLPOWxscm5yKQboggL/HMeugmhdzNEGv8NyZj2/8FCeTFdDGOJsIjcPykhlI4YDkxn1mFfLZkvCFRuvu4NATutykvveojz+Bvn2E/jBK8973va5eCkPUCdd/Njn0yk/l1foer2rYDcWamhtsTBz66sSJsfzgEhS8f8kV7e8rzH8HwZ0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0YdwiG3QMmWNUZFOOzMjc6ZblPTs/XtgN+8O7pshMc=;
 b=DYorEdf7d0DetQ4Xv2zcOByFFg/TXmxmnj7XGCV5Uw8jRjl3KW+/P509ORueI4ETU7Besw1P+c251/ZsASR41YeKzrSYD8L5pBLdomwIUB/pnhCAk9UxloH3H4Cre50LlGng/OWtBssMDkM3Rm7azs7O4R1hkuqRBPn3OC44W/BXlrO2eNkeU8H/TlDUHLc8dL6++BNqMXn4+E8jBXlX9zCVaHjZ5NMq8AQK5EUFutOBPScVi1VnNdakpRaYgUl+bjmJxqlIRubfcI0x9TCMxrfun6awcFglqUmxCMdChMzgDI5VzLhSdM4Pf2C1jQySFQB5riGNqsLmeK9zB7HyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0YdwiG3QMmWNUZFOOzMjc6ZblPTs/XtgN+8O7pshMc=;
 b=t6+WXnFz099HS7TbqyI0xUVKkITDy3YuhCsX56uQL61W04mA76XZH6HfE3c9l8CQYnV3sen4ei902cbPwYoCioXkc0DX93eBa/jkgnhIde/43FDr5ImyvlCaXRO7gcu66q6JFEjqtjBBZgWK2wQHUnUHglQe2NqpH0DfF4pe2Jaii2JvExHCKXJEj9oknscGSftVnBtag3OU6REaTYqG2ExRik1jfdZAs632kkuiR4gXBdHSVTbYT9wsnyfM3vyg5Zu4xMexI0fvKXkPbAWDD7rR0Qg7potgYDj1s047gyXBx07OHb449ZG14+v6/97Afl/Avyspmju3M4JDk85Mqw==
Received: from CH0PR13CA0048.namprd13.prod.outlook.com (2603:10b6:610:b2::23)
 by PH7PR12MB5829.namprd12.prod.outlook.com (2603:10b6:510:1d4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:55:18 +0000
Received: from BN2PEPF0000A803.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::7d) by CH0PR13CA0048.outlook.office365.com
 (2603:10b6:610:b2::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:55:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A803.mail.protection.outlook.com (10.167.245.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:55:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:00 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:00 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:54:48 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 10/15] net/mlx5e: shampo: Flush session on PSP mismatch
Date: Thu, 3 Sep 2026 11:52:10 +0300
Message-ID: <20260903085215.3691657-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260903085215.3691657-1-tariqt@nvidia.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A803:EE_|PH7PR12MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 65849193-d8ca-464c-edcc-08df09991339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QYV4USBiujBIpWpQUJa5VHye/L4j7+CT6uX1vjMJz/clBgPQ+n8tVs6pZHuGb+cbJLnwQXw1BUIXrHUgCy1SRu+ClJnfFVRbn31xGRPtgFfkf2B3/oIG8m8lZFCnYKECnBBv9PyOj0Yhz0ApnyCal7NJnrj776/3Rdr33Sl+rx5ZgN7UwTUvJpi+REvEwKi2trencxqD2eCX9ve9nfZELO5e8XN8qK+YZ7Jk0cTjTAiH1cAsdRwsQZYCvK4MamG11MClRzVOqRbLyQGMRJvcYBOUeOUSKpemFJq8abpX2CkW3rZ0ZUofnZh8IkIqHbqFkN4/wcvcvljPd7mcBHm41ACwxmsOWIhLdazIGhpzLEKQX4kzgQxrUGoaQummZLk/7bJXh8OSmsnSD5HAyhZOiVqS9beD/DkAdcyiYFMmrw25weOkP+dx7Kd2QFTQPvn+izWOhcVMfRllKRygDPIsNjQlygv/i2DAh9Jai8mdqDIOVfc24iy57gzjRJvgjeIyXFwGyglbcNGBy7Svkv6/pHWuDIO4UiYT1tosDv1uacCuG7uBqcwx2aPYEb2YYIO7cpOZl8Z+cpodqSzucML5I9ejxocwXZUZb/n9EVgPLjQpZoLuFMlbAHoxmzoWfgrKY8vjqnb+o2XP3aSMj9oNu3Y263/K2Kwr1u/jrYd99A4dCBb1TSswgHlV64wyO3RR2f2uD4SWvJWJrfLAETGRlw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uavOZnUA250Fw/eAnh9/WNaOgHxIlFwNU4fGhnFVy4fDVsh8FE2VwLqkCdH8RZVZfECUUphn5A9gjCY3OYVyKnQzWvbgNSsm4h6YWQISQo5Ov74gbGO1BnbnS8e6XRRXahXBSem2QAtZ87pMiS1BjgdISqpOGne8PDUXHCX8zxjORQrrgxNhrnUBxzSfbvBjo9fEyEAVx6ZznIsB6VMMMM0q4ZvkG1zW3beZzzzdf2aAqHA+R0fJNdUnncNBB0WDiY+C1xw1rcQ0Fn1736Sac8XL/Ot8SMUvpII9TLqt3U8OkISzrgE4oQfviQs0JamqrcMqFCiZBPNudV0S0yUkhSov34sVeC+hUrvVG/QKWujwE+IaZjIwLLXN/DSYE+JJxexcV3T7XUHR7rJC10TeZ/0P/PGgqhsD+ywmviHYVI2FFzm5vRXbmbSJaWZESUzc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:55:16.5618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65849193-d8ca-464c-edcc-08df09991339
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A803.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5829

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
index 206cf9db3466..90571cb53e32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2221,6 +2221,33 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
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
@@ -2263,8 +2290,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
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

