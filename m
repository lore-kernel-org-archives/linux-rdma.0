Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795695826;
	b=tVdTX74aXh1ZHL1PUIQWqVWBJFai3SrtbR4fBYyw8qWZSyycnX2Nqy+EB9hDlZxuKZ+/
	 39Sjc+Z8ywDbr7nsCGTSW69QJcTM0EL3I35m3FkXGhIibYmqc8rcWWUhwyKPhE4t7/eJL
	 UdBc1xIOeJO22EHBd1BAKzjNyFylciVprhb29OSG/D1LuyzMVS7mmDyddVuPS0RZX4NP8
	 NEk/LKSA2N78zmZK6nndSpm+luYtFvX8uAP3cxnFZGvRdgd7u1hDc+a+TWa3c37uOjyIq
	 IP8FOX19e8HrW+SZjg95abYRZqtDBBIOEXkABpzRBWQYGMJb7OgdSJTgrKFSKKgnd6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695826;
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
	bh=Kp2l7l/d6cnPfO+HjUf3VK2uJziE9wTnkqqvtNudSvY=;
	b=F4j129f+GtqcoubsxdTAuHGR6EMQBeiKJfFrfR83whGdROO5QTBhtys4W+w54TVukIt9
	 0nZ/7wHubqtbABTo5Vl2G7oc+3eCjrW5Hb3CoTgC71ClnbaOqCmHsi5YoyqLuWqf6EAhR
	 8TsTs2gBtG0SknllpjeB6tewHgNJkt0UdRZYUwtMjnnU3kqVI/l9tTsq0LxnL+Ueso30q
	 /uL+zQoewTPyE21I+N131iEQcBCb2ef9FftRDrhOXWw4dgYw7JGbUyzb3rTuIWEusADNX
	 wi42bES8kVXh2a9MoQAa24+LkMHVSW9M+Waw/dnfS8pcCKf+iSWpfGQbFJAOthEm3Cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tEj5Ueqb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.6
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012006.outbound.protection.outlook.com [40.93.195.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687F1606A6A6;
	Thu, 26 Nov 2026 12:23:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 687F1606A6A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tEj5Ueqb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ih5hsZd4kbH8EejP7I4dtvb4HSE0ktsHUnR1ccz9J4zNrw/jbsGgurWiUT2EVN1OgJUDbexjivxeyDTrMovNohNx+0op11VPWKXdI+nCCm9+qFBsUBewY6SC0P6pi4TrHbG25RoBLpmbq+9r7rezOhim+GwzEGiROvt2QggRJSIAChf/GHxniLl1pbD3be+rF5V5GkMcB8ojKjd48otup5vfOs/90yKoVDUEKd4QM40Qqz0dP86bydzPN87ET0fpBZAiDRCCbbmBp8u3+/iGKzrCZEm+bRQVpl0DyTWKDVdPldoXxsX7qx95ivkS6C2sewgpJlSh4PjG33J5bgJdrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kp2l7l/d6cnPfO+HjUf3VK2uJziE9wTnkqqvtNudSvY=;
 b=USgaycdYFnuadFzEgDKoN6Nts4FNp8VQpfflIdFk+5S9q1m4gORvjdeD6kBX0CPnx2J76+B6ezSed5MR0VnWOBt8r7jmZqziKEj40gFpxTBZrYp77G1m3PLm2zgzS4svPxdPA5kiBFIVhiIBxmThjS6/SWofCMsYg6ADtpwhPCqtSUn0STHVYGWQHDovyLrNTDWzBa9LNUgJdUqjKPwSYDM9ecgQokER1oI4ra0fmnj6XEvOLwv82vwuJp8QxxchFF0Ru5fC5w0E3sSFL/Zig9LN4vqOwdhdC6O3IJ1HAoQhgO1pqhWWXRQCdAOLiO8SOc5dDFY4+mMO07axVdk+eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kp2l7l/d6cnPfO+HjUf3VK2uJziE9wTnkqqvtNudSvY=;
 b=tEj5UeqbL0ni8Me1qIRRfTMF+jTPrPEMSMTb/3OZ7d+9QmAn7g1vHZd75tkDM5QHnNs/bOyRqdKkgL/Rsf8oW1G4s6B7hMBBQDBFumkOzf6sb5EGci+eVyDqV6JQbdlxiusGeztSL1Crec4Rm2CN0VFuROxh1QI97wTF4zrMwMIEyDghKFKWfp13yoa73gK50+ymaYVd7ekmYM3v31YzKF5FSkncCR08u06uqWwMV7UmO3q+hTZ3FRIbOAyprrqOLVnNlQTnyITdg9uw6MVDtNq5+Uj5PepNRdheLbWT2bUQCgZrCWFvBTqEoYUKXzj5f3DmWnMVt1g9CV7xL+2gFA==
Received: from CH0PR04CA0072.namprd04.prod.outlook.com (2603:10b6:610:74::17)
 by LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 12:23:39 +0000
Received: from CH3PEPF0002457F.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::8f) by CH0PR04CA0072.outlook.office365.com
 (2603:10b6:610:74::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 12:23:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0002457F.mail.protection.outlook.com (10.167.252.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 12:23:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 04:23:25 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 04:23:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 04:23:21 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Gal Pressman <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: TC, Fix parse_attr leak on branch attr alloc failure
Date: Thu, 26 Nov 2026 14:23:16 +0200
Message-ID: <20261126122316.599831-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457F:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: bb79bf5c-9906-4c5d-892a-08df4bb819ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|261022105027099003|261022075727099003|10067099003|56012099006|11063799006|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	DrKGNRZS6c9xnAdQd9NiToBw7Vqsgq0h3ALNdesDqMlep0o+3ugqkZ0vhlSNQfXXq4GbrTFPfprbYo3ZNpnKFLRTU2som5ZvDat8cWyS18vGL6s5a9/HiRGx41eNtuDxk2PTyljsfneuqQOY6+V9GKwLW3lzw6+ns5to60BeahYM89z+DclpV2iZQNpd2A7KdxSVcc+kIR5M3FZyMZpFoe/jdqL/Y1UIfiGqbdwyz2Lq/DuBH7ef8w88O/X58bo0lG1yO3s/QdrW6bkdTKEvw2F50CmtYarPRqyYIxaOd3bYcDn8eTq2lnHeM1AP9icdvSb8+85zid38Nnlf0R7rVDKHd7SKpcPTd+ROPG9FSudAVJmAURlodWPeJlL/yhBio+QA/A3v6tO2UAmSKwFgTEpwr8QbgqNFklKgxof1fHhMjvy0CAgXrX82sOcXdH0zVcUWsAZ6L1Nz03iDK0NFtOxtvWJjC7oaP2hVGGJDV897FimjTd1k0Le2E+d301zEkc16XN/t5hNIvx0TnDIdMoLh5J7r9uYm3/vUDH1w3E+3MtT0AgxpZ7wteE2kiyikcjmW02X6gk/QPE/iVq7SAe7QmwJvva4Vm/qYS6x0oDSRcYnTGaaQEemLocFOxMMJleYuM+iU2e6p66dPVoX2TdYLDOR+OL09iJSSuxKtUh/bK2Sq7pOGegSzzh/QzcivceKBA4mG582AW1/hiN5QdA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(261022105027099003)(261022075727099003)(10067099003)(56012099006)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TFuP0I12tM4l9bc/T3ax1mrxYqcxcQBahd3bS2xgnNrWXsivKv4fKFM9LOX9hUG8Mz19QKdzfTwhCrlVYR++KaIoQBNigHBnOyXqxkqi7q2m3L0gKSr4ecV6W7xcQ+ZLk+ne61nRRYsKRjvePx8GsZVcxGEPjjUa4OnMzXzgjDO3D8Q0jUcLl0BQoG6Cz6Bm9iCu2SDHPH/A8lICVjLv1fvtveH13YGn+Kmzkvh/hqJdWHk5bBmCsSVN1N64LAS2zJg4Lo9keHJyKsMwsTi28M5NZKo22LDbL6M4G2dZWVvR27ryrfoSY1ivDBfhmJOvoMqBq2nIxMV3cfL5OQ6eJ+XrAie5AM7D8pOFjSlXJHsWu8P2CJE+WNQWTmxZJY35OAlBzH+H69XbOHX+GsF8gomLCsAKpCjoSEeAfq8SIH44AelHkT/R9JI87hVo5sYb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 12:23:38.9379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb79bf5c-9906-4c5d-892a-08df4bb819ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992

alloc_branch_attr() gets the branch attribute from
mlx5e_clone_flow_attr_for_post_act(), which also allocates its
parse_attr. When the branch action cannot be offloaded, the error path
frees the attribute but not its parse_attr, leaking it.

This happens, for example, when a police action's conform and exceed
actions are both jumps: the exceed action fails with "Cannot offload
flows with nested jumps".

Free the parse_attr too.

Found by LLM-assisted code inspection, while reviewing a fix for a
double free on the same error path.

Reproduced on ConnectX-6 Dx in switchdev mode, with kmemleak, by
failing 50 times to offload such a filter on the uplink representor:

  tc filter add dev $UPLINK ingress protocol ip flower skip_sw \
          dst_ip 192.0.2.2 action police rate 1mbit burst 20k \
          conform-exceed jump 1 / jump 1 action pass action drop

Without this patch, kmemleak reported 29 unreferenced 4096-byte
objects, all allocated by mlx5e_clone_flow_attr_for_post_act() from
alloc_branch_attr(). With it, kmemleak reported none.

Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 011741553f5b..142cccba907e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3915,7 +3915,8 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 
 	return err;
 out_err:
-	kfree(*cond_attr);
+	kvfree(attr->parse_attr);
+	kfree(attr);
 	*cond_attr = NULL;
 	return err;
 }

base-commit: cc7fe6e741730fef549e484379281736d32746f0
-- 
2.44.0

