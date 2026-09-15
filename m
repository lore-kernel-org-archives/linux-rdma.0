Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011049.outbound.protection.outlook.com [40.107.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08414E2344;
	Tue, 15 Sep 2026 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472160; cv=fail; b=KtICb+WF8DARtH434vUzPJOS9t6McFBJSWF0BpnF4nSTRhW6/hk4N2UgGx9YmeB+1Kkg8xCmIxvXu9G5K2zMfBIfn8EOcquuTIp4c6GBvkHbFrfpQ4WfC4B4pm3TtrA0GpRvdC/TwEAU9F7I/alm3ZrcZyOxh9yYxmATBaIgD40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472160; c=relaxed/simple;
	bh=xjEeCfFTmQKo41jW1I0bhfozfQKpN52QpE6D7PPuxuo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NoV4xpmvmam/xH/htZkJe+FOw0+sMFO8BdQ6WYbb46oPBdR8TAW58/tRS/GOvSX2R2VoNE8thdZwfXbJG+bZsYf6DsvEIKwSiQfAlE2SrJ8Dvy7xzuD4xWFktXnh7zXW821AqeT7tA/qjnsa9+n91OwFYDqR1PdM9z0+XdQfUM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HbX/K7iW; arc=fail smtp.client-ip=40.107.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HbX/K7iW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kj5uTdRXz7tdWBKgO4/YltIgngTT6QV6zJLkW9RtAdeAlI1CujtU4eFyS2JAzmfWhhbip9h4qAJ/i3dBdj7hAwttZNpmpaZrxt9y0sR42ZKdB2KXbk2TsoHE7hZMrC5p4VpdRrDzpN0g7+sof/BilnqpIFRwZ5FTF06K9uJfCQpx6V+vOc9KoTrtIlSpVfN10Uq7LlbQSxEi10Iww5bsyYWIYMcAXhL2TjbKvf/JNgGKF5776u7VjsHRn6q0KSwXBIkl0kLatDki2XJLv93gQg6VAAJhRdhv3ZUUyAwf3P+7N9zvlJv+OB+yjpw0L9GCuD/+7pLn0R+6LjhRtK8rnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vDtHLhklaVM2e/S7wtGi4tVQCTC9FC1ywDh3WdF+Q4=;
 b=X+uvjTX3HLtk1JZ+mb0RpC6+G6pb+zng6S13EsTc9TEeSInkx01IJpSUuN/Z62uVQS2nE6ItBl5VwQBuFXgKiXmqyWfWWWqs/u5gttp3ghMw1nt5tXXvuSgOG6TTO2iBl6WuKTxKkf0EAO0w/GBghNVqozjn0k63QuG/2KLyMWIm6pO6CRKh7KvOXnFVN5tQkulakuW7yqbcFsbqwCKrKbsqZvQY0ouJ5CSq/FO7mBzbpAnbZU7VxZ8lDACIw/D09WT9VFsZqrr4fkhaI81n1x+186Wt+v4HPz0bVyRxaFBGaMgYICOvSYeQaq3DRuB5pmUwc4GqSGBf+VypQj8LEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vDtHLhklaVM2e/S7wtGi4tVQCTC9FC1ywDh3WdF+Q4=;
 b=HbX/K7iWZJST6E/bsmbCB64dLWss8k30jQEF60jgIjfAPGfT1+JBOW1YyTnJdfTjIZq/rt+U0h0g1bIzbVG3eeCQYqDuWTJkFF1u5l+aalZXzOnDVKAMftSF3rDHL7jtwVSzjeKdWljxMAEF1fww5+wC3boQXTvpTNbpbLFn6xGvBT7IHE0ZtvvA4GZJMrsBZptsL2ylgr6HHCJeh1qabasSiMrehx3a/zl8sjzjHAQSaIigp17UPeZ7r2zdjsBuEIMtFUGa0LVDkc6aly5CG7pQE2g6cr6OChkcu3GlCa0URXbcY+UwvkHcG4zjmrWz0P7mSKLHEfHTQYduc3vKJw==
Received: from CH0PR03CA0074.namprd03.prod.outlook.com (2603:10b6:610:cc::19)
 by DS5PPFEAC589ED8.namprd12.prod.outlook.com (2603:10b6:f:fc00::667) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:35:48 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::13) by CH0PR03CA0074.outlook.office365.com
 (2603:10b6:610:cc::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 11:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:35:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:35:15 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 04:35:15 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 04:35:11 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V3 0/3] net/mlx5: SD LAG and devcom stability fixes
Date: Tue, 15 Sep 2026 14:34:56 +0300
Message-ID: <20260915113459.3934760-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|DS5PPFEAC589ED8:EE_
X-MS-Office365-Filtering-Correlation-Id: 83fdbf14-507f-45be-08d4-08df131d7cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|13003099007|6133799003|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	l2bb5Z58x1UtTPtZIwpJdiydp+nMtlbuT/JSzcyxViEBZMW1TAOLNxoA+QTyee9yBcb5s3+kPVeG36nV/PVyYF4NJW8zgTvPARQ59CIynqZ5NPGHW8raIVLrwqFEiN9R7CL9ibp+6+aVSXLRIZNeYUsS41H0H6iVUBnBqLZvCeJk6bHJz+o1IMedLZ/Xmb3+ZsZM8XmLXgHCpCRasOoaCz3IJyvhfL5XjhytZi178pPTLQ5vWRTbvOaiOCDKIQXdTdAi0lpub3ucGCRy1PQnEVQXXi3qGyPed8lDRu0F4vMgEZXQgIUb1Lq6FZjfj6xhH6Le7U0Xoycq0XSczXN3QVbObuhjpEvgehWb2jp/fst7DSbUXKcTY/zybjyDR9ZavXb5PSmp4auyuJyLt3ckJsLclnDZEY7i6380KKmTca5aDwZ0Y456HgArmP14Km0rjhsxb5KAmvloUNX0uDKE33swF84Aw8hgWkJE3D6fRjlBJx/E9RrLADkLtjzpZiMZhUNVG7kAj8xgnbQq02GaomBPQzwdGV5ms4jATSWPyKgtUbxasfsp9Cd/Cn91QP4IOlB8onVaQQohtZL9iqn88MhvBLpgNXvlwadkIoVgZM3wMNv2heC/Fjl+g7xNtD9r8plg9L53JuLf8/8qu+DXccgEysT8ZIHwXBR8s0w2iN/aigScT/ILW2I71etYxX24g73DH30haYU+nm7YzPYTSg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(13003099007)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RgjfPOc0NY1yPqAAzNtc13dMsqRbnoJOdA0NShZP49CJoZ8nDYh7X9eE7Mqxo1IL3E+tRlvWCVtHYzUzQykVSsPJCvCd4YauMlcWxvzgIljH2TYU1uhWwNxrfeDigxNdkrkO3WsPJR4eVc6lTBJ5Mz7lwOwarYd0KZwNDT9ytLyfcrLktaAM9yMPQQhyMLbogKRZanfgLBPU4vz76TuTenqpO7YBtJjb9hmozdgDsD/HWdedohwQNyAQFbyn1raPgbxi8KB5bAOPNa8QK69e/XmSTcYCTxXi6Fk4V/OCHB+GzlSpmPD+DEPd652yJ4aO/DReSYIGlpVEZCEn4UqbOjXYMYjMf8i3MlJfl/Oh6al5x0SG6q5P9WYjQAPz/jnKEsietCHPRuOKf+nJMYaWdz12ZEcYIIgxcafAB2MJ0zqfwB2A3iwHrlECHsu+qQET
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:35:47.5442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83fdbf14-507f-45be-08d4-08df131d7cb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFEAC589ED8

Hi,

This series by Shay fixes four bugs in the Socket Direct LAG and devcom
subsystems, all related to initialization/teardown ordering and
concurrent access to the LAG device.

Regards,
Tariq

Internal sashiko comment:
> @@ -342,7 +342,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
>  		return;
>  	}
>
> +recheck:
>  	mutex_lock(&ldev->lock);
> +	if (ldev->mode_changes_in_progress) {
> +		mutex_unlock(&ldev->lock);
> +		msleep(100);
> +		goto recheck;
> +
}
> +
Does this open-coded retry loop reimplement a wait mechanism without
immediate
wakeups or fairness?
It looks like we are polling the mode_changes_in_progress flag using a
hard
coded msleep(100). Could this unnecessarily delay the initialization
path if
the condition clears much sooner than 100ms? Would it be better to use a
proper
synchronization primitive like a waitqueue here instead of an ad-hoc
flag loop?

[SD] This is the same check as in mlx5_lag_remove_mdev().
I agree we need to change it, but this is net-next material

V3:
- Drop the "SD, serialize SD LAG init/cleanup against LAG mode changes"
  patch.
- Elaborate the commit message in "net/mlx5: LAG, reload IB reps of LAG
  master before the rest".

V2:
https://lore.kernel.org/all/20260906071332.3759199-1-tariqt@nvidia.com/

Shay Drory (3):
  net/mlx5: devcom, Base component size on linked devices
  net/mlx5: SD, unload reps on shared FDB create error path
  net/mlx5: LAG, reload IB reps of LAG master before the rest

 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 44 ++++++++++++++-----
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  1 +
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  |  5 ++-
 3 files changed, 37 insertions(+), 13 deletions(-)


base-commit: 23ca4ddc4fce2c233a49e9fd34d4b5b02bd7324e
-- 
2.44.0

