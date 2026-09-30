Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010039.outbound.protection.outlook.com [52.101.46.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F57547074;
	Wed, 30 Sep 2026 12:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770338; cv=fail; b=lKwSt92HHKfDCp3rYnYTctF5lcssiLXwR045G3j+0dtc77DifesVH3JgGQHACxKzA01SXl95knZUA98E+2o/X4y6JrcMG/8opDu+pQRp6QzAoPeEH4+u7DIBs1UlHzETr2zuYzBCTrQxleIKgfl6S07A1znmhxq6il0ElZcORfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770338; c=relaxed/simple;
	bh=tL/ERNROutxdrQFWtvHxzAJX/jC787HZEzrMsaXbjtE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZXYLRaLq7JQQphdo8tYKzborAqLZa3cGfCT8YeadqdiJOpW1PAPZPU85rdLOUmYZz3YkfEohyY8uTOWdngrmJwraYqGbOE23tYBI6pvIe/EUzgARjf0pLwCGCE6vjqhbyBGszpcCrcv6/+w0+FKf+cmzGaCiTqgkrerWLNTSuhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B3GWHKrY; arc=fail smtp.client-ip=52.101.46.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B3GWHKrY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kPd8zKGK/J04TdagqAhPAeNXCH/tYNj6ABRf4mcYRxf+C8OTQb6YsSO53F2TGMRVU8pSOCpk/c16Xx1rdlbnfTLv57dvytcGWA459yae2xj/kb0g+GcNMdje5Dzrthz+G2qNrR2o6fqgqgt24K46eYaIwtXd/VURdZVzQ3qGrs02md3XQLKcuZtjIBRROHr5rgYDiNgvFULnbpZ6srgeY1HVCPa+mhQYvoe3r/vZYJ+/s883vRs4Kks6Y8BP6VFcy14ZFJwWW+Z0F+pKR/dYhs4UNfHICIT+1iMoJUOeOMrq3HzH8FCTbDGeHDJkh0ttxhwg0DH61jygBdklqdYrAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cod3Ec2HOPAmAYVkMFeOo+L+zc/EJAstr/lNMa4xZY8=;
 b=vGxNkIq3qEkxfy8teawQ3fH7Rl36WKis/WumRwHmdgMW4R2Z73pEm9eLgCuD3aiC+ytjGngOi9J6ORPldxxsOP9NPBj1VP79LSuAFlxLTOq9gmUjbuQAE4VAhcJmnXCG4v8gSlN7ZWywzFwfc1Vxi0xoQjOO5eNhagvYpXtoXKh2SElwwSr8TKCywOtzRxHA3GkWm3IO9EZ4fY72X6Uj3mNQzTmsAX0T7pf3ws+vy4Sl9P6iV9DSKmFbTPmfy/CY1ZyRzqjKW/CNd+IILydYno44FCztmoBdQEzY0SlHOsZ9sYazkTwEVTGIrSmDmkBYLfRPcO8y5A2osSup7pnSEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cod3Ec2HOPAmAYVkMFeOo+L+zc/EJAstr/lNMa4xZY8=;
 b=B3GWHKrYAeVOEz30k9QULflqaIQ6ECEXpjDsMp3KsWEN1jSjH0PPD49vE+vn4UNUzkyuXgxyXWLLYVic0+LGqpmc7a7vS8LiL9BE5vROcX5iqyr1kBEARlHKeN423lCkrB8DXnNm5xDYbVzhlxVRaRJHoy2vHkM6ezfR0rN/knIqZkXjDjC9ipqcPwL4MVfzZzVvK3+waGyf2ZZcGMK85RZPIqcetTEGLl4Q8cJnskYBATJ+1Xm2P6poZcjQb2nnqMvOL2DVxNEZgYa9dIKuHCzF6m6qPAIGBP+xHmPJCX5g+FbxrkIB1X7PnuVvE0Gq6G8NlRIxdJVGrcpVI29IMQ==
Received: from CH5PR03CA0011.namprd03.prod.outlook.com (2603:10b6:610:1f1::23)
 by BN7PPF9507C739C.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6da) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Wed, 30 Sep
 2026 12:12:11 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:1f1:cafe::9d) by CH5PR03CA0011.outlook.office365.com
 (2603:10b6:610:1f1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:12:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:12:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 05:11:49 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 05:11:48 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 05:11:43 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>, Gal Pressman <gal@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Roi Dayan <roid@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Steffen Klassert <steffen.klassert@secunet.com>, "Tariq
 Toukan" <tariqt@nvidia.com>
Subject: [PATCH net V2 0/4] net/mlx5e: Fix offload lifetime and exclusion bugs
Date: Wed, 30 Sep 2026 15:11:15 +0300
Message-ID: <20260930121119.141953-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|BN7PPF9507C739C:EE_
X-MS-Office365-Filtering-Correlation-Id: f4d9b70d-6611-4b59-a5d8-08df1eec0e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|1800799024|376014|36860700016|13003099007|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	9HD43n1Dq8vzV7MKpmkKgIKYZHBHEk5gKTMwxeq6WF8BVMHLgtFR1b+6YNwRFunTMA0gqGl2To4Bk5JDL8WP/dervN/gCOeb7D3/kC4RfHmf5ihUC/fOSnoewDFRKbuaXR+JScqADXYypP8EIcJZ4mn/tK2fHVq6qX7GZwRLzwTSIAG1D0nAwJaUIcD47+Rl/m/36UOr6jBFWolv9l+07gzi6iRF87+1z9U3tWLQTU9p49Ut/iKxQtOEazLBZJaw8F5wz3nDlDCE6yAUmaaOO/0nqMMnsQEMayGeBjU0y39ZwLLy3P4DkL/ywB25MugM5IFcdWABM+1bGKOM47KXX7ufXRGuSrqBo/ClldDvGs7DTUhk7323ILHKno0td34O8POKKPPFW3fGOdV2DMEtA+PmS/zMgoroHQ0R0HBJF1LaeJXyPZOk3Ac5R3iXoUBEOYkt2AizmRBvOG88+R7Ua38bE8INZIiokV76mXBirHJFMGmXJg+bb0dr//P9jQYKQKf8Js6If5GDpyEqljRHeZgZUnKGoIwZx2p7dg64elMZNRydgr5lFyldVoboRweCVIUcfH+qvXDhNaKDmnVrbh0/7SvFTWyJGPwyzrAgFXEVUH95yqPoJ8rTrfw4oLkNc99r7w+7YR0J7+AFhgYMj94TuNSUJYVpDulfadTfreTUcw2yoayQGUpVgtAnEdJdfHcLNh7n2UjKkOadPmpdSg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(1800799024)(376014)(36860700016)(13003099007)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m8ly3k/W53GLJsb81XXn+6G8q1OhpfhkO0fxuYd/IdILOY9AIUkZ7U2yvZUrWJoW7+Coa4v3tBIP5166hLHq2ogXvCJf7d8fFyrPaKCrqjS6CEBYll4h3gcmXbTRGxdN6YEZsgmI+E+r6L/YuOcQ4avp3Lwd8tIUISzUYyp7cHm6kctZDDc5S646abco+xhYAs78R740EKIjUJE0ihZcmDOcc0nYRlTzpqYUabeCz8wFaTYR4QWQRv+V5HZzF00nLobEHGBjlORyaeqolLi7tH/nIAvTB3DNnZ9FJJuTxqr8JD8xz9EU/qORtVFzGK+aAdESAsVL75FwLWarcWvSyWRY15gLaZwfai0lJk1DgH3kMGEeGW5lqMpT5PlX0r4ISKmTeKTvAD3yiLY5vJ73fhJwRnI4ZCsVtufRVsGzIFDEQun5kX5+F7rhr5WoWwrY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:12:11.0936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d9b70d-6611-4b59-a5d8-08df1eec0e66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF9507C739C

Hi,

This series by Cosmin fixes several mlx5e offload issues:

- Block eswitch mode changes before accessing the IPsec context during
  policy and SA creation.
- Tie TC eswitch and IPsec-blocking references to flow destruction,
  covering bulk cleanup and flows with outstanding references.
- Serialize TC/IPsec exclusion counters with a dedicated mutex.

Regards,
Tariq

V2:
- Use mlx5_esw_lock() in mlx5_eswitch_block_mode() (Sashiko)
- Clarified the fix split across first two patches (Sashiko)
- More careful dereferencing priv->mdev in mlx5e_xfrm_add_state() (Sashiko)
- Avoided spurious error message during IPsec SW fallback (Sashiko)
- Harmonized check_users arg for policy & state add (Sashiko)
- Clarified the scope of the "tc: tie..." fix (Sashiko)
- Moved macsec patches into a separate series.

V1:
https://lore.kernel.org/netdev/20260917175433.4090878-1-tariqt@nvidia.com/

Cosmin Ratiu (4):
  net/mlx5e: ipsec: Block eswitch mode changes during policy creation
  net/mlx5e: ipsec: Block eswitch mode changes before accessing
    priv->ipsec
  net/mlx5e: Serialize TC and IPsec offload exclusion counters
  net/mlx5e: tc: Tie esw & accel blocking refs to the flow's lifetime

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 65 +++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 47 ++++---------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 66 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 10 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  7 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 +
 include/linux/mlx5/driver.h                   |  7 +-
 8 files changed, 128 insertions(+), 88 deletions(-)


base-commit: 99b43ede9e355ba35244cc9470bf1819774ce39d
-- 
2.44.0

