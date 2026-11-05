Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913496;
	b=LPypB8VbsAWqUNY/SMj4k0VwYakU9akmvz7hSsqmjSx6OYVZIooc2js2xEu15w5pHrE4
	 NLl6wKqj7698YeHnXUqMv6Tq2ko8Ou3WyH8r3Vdn17dE3JbZCR9NAv5jP5394Vi5Rut+n
	 R/g6XM61J4bJkjvuKRHrnxX9Aj3uLQ3NRX1g8khKtYvy2cCNU6LVPIFdpG2IhNwyDCox6
	 GCwDGNhq8oVyeyfX/XhqTCgk//a+Xn49BNL5+Uz8nxt0y9fTEvpTu8+Am8mYTQL/bCpga
	 mHcLvmPIBcbzM5BaNCkp+aClt8TJo8y+cD+B/LgDkIqeI4hnAhrk8a8ABNDHuqGkvNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913496;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jIpGm/nS8cRQBtZtKDPJiUMCAFUV7dm5xdemjgVm4cA=;
	b=bIFuP0qHTiyjmpNUV2j2Fmroi2Te9UQHmb6fW+g1VcTG/rhgTnLBs8eL0Y9CAviPDOws
	 sOpMJOGz2G7hl2NRLPvGGV2mbEzR965Lyi0SIvF3Jp9mIiQq0Ugh3CxESVfE3BC7iJY03
	 P70TIuc2+5L3r7tK6+WY0mOfApmtGwOL2oJn2v0sXK5XW27JRjVQZeSoImWLz/lFu8TVR
	 OCZmqA7zQJNXZFClcWb5ZjJhZeSfhqDUqUoup2XjrLwKJAtbwe9Zna2rM3ZHKoUC+jxPh
	 PqMjLuMCM5xLx4yDqRX+r6fY8yDHfQuDzW5AH8aThd/xtCxlMQBL89pjbyB5QUYfilw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="iZ/4/Cyo";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.35
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26D5606A330;
	Thu,  5 Nov 2026 21:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B26D5606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iZ/4/Cyo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZStlcPf1NQI+8aM5QB0PVDyZv1RgMx07yIi7uHLzuRz2nQO3ioLJL4wbmTO3wp0HamAJ/ib4YRcJuCGmqBp7G3AalikrPVNdK0RW7cqm2AHkETAXaWviW046Y+Jr8E46/mWg1IiJjOMbg4Po2EEVQWzIRqoWCymy7kzwHeedoVe9cfkjpOkqETVsyQa78iJ4iqabD1WfDNA3jbPmoz/nJ2wlY/uKQ1p/hMzZ8lQ9zR0D7rp138etTvZABNzR0c1PbB44h0Z7pzVwNejLB4VvZj34wnYeXMykpRVEI7hTMvGVWJ1sEoTJc6iku6miQNtbMhRN9y19m9cM0hy73QmhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIpGm/nS8cRQBtZtKDPJiUMCAFUV7dm5xdemjgVm4cA=;
 b=NwuPGQVAwqUmz4xrX9lM+pkw0J30yS0FGnHUiFNX8EY7X6RRqxVCvpnZlpJ8a8Q954/eIkOePuSfHxXGmjaM6z3OP4NqPakOpMMFWjz8RJ2O0HqguLPYTUOWG8iwDvHgPWFh2mvVBsyZAXdaJ5H1cgUw9+LmQ+85KEmYgbKJJnqhI70ol+bBH8rzFl+UbPJPFOkpghgbKIerBqI3ndaohy4b8XOl9/zE7k6BrqFjguWYE7w188kNC5E3ldFznZV0kAo/1ihwf0dSdyDmfn4YWuc/gpo7zPS+p7L2Bj6fLypbLrp1Ei7ecjajGpcFtwTmkjxAJ56jjYCKpF4IvhCXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIpGm/nS8cRQBtZtKDPJiUMCAFUV7dm5xdemjgVm4cA=;
 b=iZ/4/Cyo2GQ1nr7lxuSD4MKSXbc4P8qSDZzbQgrgroPY4vlMar64fy8dn1/sRWDE6m7DVoGk5oJiGMeYOtSI7Kn2iQ3CaF1Np+2uMMOtD4bDmGdwGxlr01Bl6UMCsdAUYvlLUPSDdd4U0Qw3arqNJI+Y6zk2DufbgOHMsJeQwODslVa8I1hyERbgMVwcx3ZqEtHXi4qLFMOIyrkEGauWfrciaLUegAjO41mohniFtqryRMsYXBVuc52evGQj8RrL/lYc/mdbnVxc3Dk+cPSSvQMyvZoi91ximVg2FI+DqOswB7X7Qlhc4B+lh7MZm5Ldp0D+7xJ4ZRC5nwVxten8wg==
Received: from CH0PR04CA0094.namprd04.prod.outlook.com (2603:10b6:610:75::9)
 by SN7PR12MB8002.namprd12.prod.outlook.com (2603:10b6:806:34b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:18:06 +0000
Received: from CH2PEPF000166BE.namprd04.prod.outlook.com
 (2603:10b6:610:75:cafe::4) by CH0PR04CA0094.outlook.office365.com
 (2603:10b6:610:75::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:18:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF000166BE.mail.protection.outlook.com (10.167.252.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:18:04 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:42 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:41 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:35 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Raed Salem <raeds@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V3 6/8] net/mlx5e: Block E-Switch mode changes during IPsec policy creation
Date: Thu, 5 Nov 2026 23:16:34 +0200
Message-ID: <20261105211637.1083978-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261105211637.1083978-1-tariqt@nvidia.com>
References: <20261105211637.1083978-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BE:EE_|SN7PR12MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: 53970cc7-8e59-4dd9-fe95-08df3b82481a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|23010399003|1800799024|22082099003|18002099003|6133799003|10067099003|261026121527099003|11063799006|261028144727099003|56012099006|261021123027099003|261022105027099003|261009223027099003|261102123227099003|261022075727099003|261021121427099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	jM5AondCTESUGHNpFn8uxexiDN4nZkWG+8qxa1ZezKDmNw8h5zQjPM6lorjc0A2idyCs8wi7dPhL+TQXNIQx6Vdck55ER0k4Xew28+qdgnZpYSeoWrhjHPqf7BWYUZrSNyaAN038i13zLJRLC01POowfzMVAPT3d4Tsg2Tsjgw4t8p6C0/p1gTeMgvhtTAbjADeveWiTa94qDBB7HZjuNvIBC1vKoMd4SAIa669TKGuFV+9Ncp8rI4k/7SRQdRKIHKzSnqx7ZRZDuYguLlm0ZqGRLakzwv7JPlDKAmTGg2A1IgbBHayaoPWb00bN5A+Jr8rrjRUZqc8XvtngJPKyXUJKFqcjzg5YmPu/vm0rF2fxtGbR0xAKu/jQvegsGvGjx0XGq0AbXzSsYIx+uRFRWP/XS15f8GtZZejeE/9tdKOvmiBsniIOBfElkKQtNUKOMPKs70eDJnBz7T3RvfksSc7HLTPd1HmzbFV1GtuFij5pdZlwiiOfyNSculXtEOCJqc/JKKRuVN1GVu1FAhYjjGau33O3v+p1gkr5ZmO4uHJkRV0Bem8mH0z4tcOr9WF1IwDosSri6KNiU8cL3bIo9Mr8C7WqUjRuLznGGEtiF6ydmWBKGFAY84a6LTi+f5CRjo8t25E1Sd4tEB99EbrylOwDaYkg2RWnJyOJSmwe0LT4E5ZFrsJqYSF9781dWUq/qkCuQ62fz4jfRMLsWQwNuA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(6133799003)(10067099003)(261026121527099003)(11063799006)(261028144727099003)(56012099006)(261021123027099003)(261022105027099003)(261009223027099003)(261102123227099003)(261022075727099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JenGsElWdxiybviLHlu6pRDDQMau3kxfaaQP7Nhr70vd3fnPyVFTjUfB51pZxH9uChJB9vYViMC2+OwD9zCxAxEk57/clVdkITetdCI+os+YXIobo0V7y6L0G2HZB5MgMEnNnhp3qgo+XwIo/UXWyt2H5nwNseLBG0+Q7HJkKlhzSRNw2gMqrqXWLWEAJgKWQSraE6Ven+mN2aG0DyTYjgdOTgXA/jeMhaH1G4OsZ2WJOHgOEMU6VtO4VwSZkZfJakjTXWbJDpyEuye0vnC4gCa8YG3eGCXzxmcAsTcs0Blk5hmoIWEr8hxbkbv3Tm61y8J6rvuVeyaz1fJkpgGK2tWjfyrcHmrPFGcMtboeNvYMBA7pEmnq+VukmisucNWY6RVcBvxC8rgzMm7lu071f7h9iqQKnGnxSMBeFgFEOft66aoCA+96DN/Ej0wivgaV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:18:04.9858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53970cc7-8e59-4dd9-fe95-08df3b82481a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8002

From: Cosmin Ratiu <cratiu@nvidia.com>

Eswitch mode changes can tear down the IPsec context while policy
creation is accessing it. The mode-blocking reference acquired when
creating a flow table comes too late: the table lookup already accesses
the IPsec context before taking that reference.

Take a temporary mode-blocking reference before checking the IPsec
context and validating the policy. This gets dropped after successful
setup, when the flow table holds its own reference.

The temporary reservation must allow reuse of existing IPsec tables.
For example:
1. An offloaded inbound IPsec policy is added on the uplink.
2. A TC flower rule is added on a VF representor.
3. Another uplink policy is added using the same RX tables.

The third policy reuses the first policy's tables, so it must not be
rejected merely because esw->user_count is nonzero. Add a check_users
argument to mlx5_eswitch_block_mode(). Pass false for temporary policy
reservations and true when creating the first table (rx_get()/tx_get()).

Temporary reservations take mode_lock and check operation ownership
without requiring eswitch user_count to be zero.

mlx5e_xfrm_add_state() needs the same early mode reservation and is
handled in the next patch.

This was found by Sashiko, during review of the last patch in the
series. No reproduction attempted, as it seems quite a tricky race to
successfully trigger.

Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 23 +++++++++++++++----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  9 +++++---
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 33a7434a7bb9..3cd0b36a02e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -814,7 +814,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		goto unblock_ipsec;
 
@@ -1288,18 +1288,28 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		return -EBUSY;
 	}
 
+	/* Block esw mode changes until the policy holds its own block. */
+	err = mlx5_eswitch_block_mode(mdev, false);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
+		return err;
+	}
+
 	if (!priv->ipsec) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto unblock_mode;
 	}
 
 	err = mlx5e_xfrm_validate_policy(mdev, x, extack);
 	if (err)
-		return err;
+		goto unblock_mode;
 
 	pol_entry = kzalloc_obj(*pol_entry);
-	if (!pol_entry)
-		return -ENOMEM;
+	if (!pol_entry) {
+		err = -ENOMEM;
+		goto unblock_mode;
+	}
 
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
@@ -1315,6 +1325,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		goto err_fs;
 
 	x->xdo.offload_handle = (unsigned long)pol_entry;
+	mlx5_eswitch_unblock_mode(mdev);
 	return 0;
 
 err_fs:
@@ -1322,6 +1333,8 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 ipsec_busy:
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
+unblock_mode:
+	mlx5_eswitch_unblock_mode(mdev);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 1529d4730323..dbe5547d7a49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1134,7 +1134,7 @@ static int rx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (rx->ft.refcnt)
 		goto skip;
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		return err;
 
@@ -1427,7 +1427,7 @@ static int tx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (tx->ft.refcnt)
 		goto skip;
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 1fb67fc6d49a..48eb6acc1e87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -971,7 +971,7 @@ bool mlx5_eswitch_is_peer(struct mlx5_eswitch *esw,
 int mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
 
-int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev);
+int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users);
 void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev);
 
 static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
@@ -1082,7 +1082,11 @@ static inline void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
 {
 }
 
-static inline int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev) { return 0; }
+static inline int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev,
+					  bool check_users)
+{
+	return 0;
+}
 static inline void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev) {}
 static inline bool mlx5_eswitch_block_ipsec(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4da89fcf215b..474784131091 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4365,7 +4365,7 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
+int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
@@ -4373,8 +4373,11 @@ int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	/* Take TC into account */
-	err = mlx5_esw_try_lock(esw);
+	/* Temporary reservations may reuse tables while TC users exist. */
+	if (check_users)
+		err = mlx5_esw_try_lock(esw);
+	else
+		err = mlx5_esw_lock(esw);
 	if (err < 0)
 		return err;
 
-- 
2.44.0

