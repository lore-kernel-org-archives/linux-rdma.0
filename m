Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1883A49B449;
	Thu,  8 Oct 2026 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466145; cv=fail; b=U3urQ3HiL6212fexlR72+Q3Q/wenAhUvnTJzSVxLQ3AOCATZC0BRkIbV3w4+JMCi5Afm1cN4/UABe6vF1/r4ItXyy6L40DAd7h/ibukFErcXxq25QMzONDsWWLjXKsOwRR+rBaVRlsL6icBlfgcG6QAg3zYUHfoVNCb5n2lshiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466145; c=relaxed/simple;
	bh=yWbvt0ZPrVfAek80qlzoX4tTT9KPSSxdC5rDoPKm140=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8KFA+fYboVSrh4VSuJZB9dY4jtMCQJaONU3Zr82cVTBh+kwbK4UnamrDt8pmLJSx00PQG30x/BmDKoLvYbBjWD8Op4cEka77cQQSZTjD6X2Jmm2oQSnazfIMLm8ZrrimfA4axAZQquwgSV35+RvNNr/UoYTDqYWqpzY3Etp6Bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OKlpFfVb; arc=fail smtp.client-ip=40.107.209.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OKlpFfVb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7JvxFL87n4pWIrSm9+0WuxWDPktZEN0QC57CTu0SOY9sS92imwiviwxw8oUoWv30dX0ZH2eKL0Xd9WR+x+Pu7DiJ5+tH03r4+SWek0mC/YszoyKqJHT9DNZYPyx0M3VgD1wFfnsYb4yOqvjNT5ux3unAEcq8FQ6FoEB9mZ4IDqhkK075pu94Um79s3cEzwga8KrDW8op6ueh6J5Mz75/X1aqjkso6CFxx02JRvKN093hYy2EUSGKfOgs4rmMB70OIgAVyuZeDLtoYn+lEnXhuC5ibcgh/7w1eaj6lmdW/EpR8rAXnrahAf/XJXIt6dB6nrOVJjARp44Xj/k/B7qjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SoCR1AMwqArv5pmmwLatBqn93SYrkCwGuzN0/MZtwdw=;
 b=YAD9248v9DIlMUd+DVp+aouBHSbl/hMGCp+yoyXkJ1qJWuE55yIe5k3dc7t5h3vSIJ0v+shV5roimwA+zD3sBLH+IL9UWydjOntO8d2B2rLKZxaD6oF7sLSGyfw4cDrBtBJMbR2fR/PMp/UwMvuXHSLjDvQhq0mZcWu2hw7VgoOT04R+yiwyKbe8Wu3pDDhnvnbF/fGZugPmaMf1CCi5wUklhotPoWuKrpOXvE/trGJLNju1sxqFuJ7ybSYIQqRIpcbJmU06rUaSJf0yS9GFK7GxhYWocppGi0cEvKbXx1h/rJk9ablibAs5SHhHeTfKSAWJ0U2cvfBFAMqO67CMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoCR1AMwqArv5pmmwLatBqn93SYrkCwGuzN0/MZtwdw=;
 b=OKlpFfVbGumzjEa14A24XkVEaVM02bOh4b82qiX0vAT9yjkSAJ01C8GfQW8/4vtBJnMfpUgNrgJHHob9lsF+lA0Jfd65GpZdo9eIDldylmSIkCAuP24hAX0carTFqPzRYgVh64h0TrWZZlaHm0MdHpwHWALxGxA97pZgoBNYnZvXAi6i84riSLmIgid11i5tt6UyxMbo5O5+8GTwsbfr06GrTUdraqRX5PpRvAFeD3hnCI4Pz5fcmk3HoCfcutW9PoRUgeF5KB0uY3b52aS1NQXFSyxKU3/s0mrPh/15WGIE4zkLar1Hv7bwpvq1t06o8UPQvIQINHdC3YO/mRJnGA==
Received: from DS7PR05CA0071.namprd05.prod.outlook.com (2603:10b6:8:57::14) by
 PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:28:53 +0000
Received: from DS2PEPF000061C5.namprd02.prod.outlook.com
 (2603:10b6:8:57:cafe::24) by DS7PR05CA0071.outlook.office365.com
 (2603:10b6:8:57::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 8
 Oct 2026 13:28:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C5.mail.protection.outlook.com (10.167.23.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:28:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:34 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:28:27 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 01/10] net/mlx5: Log the data direct to PF device mapping
Date: Thu, 8 Oct 2026 16:28:06 +0300
Message-ID: <20261008132815.654147-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C5:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 6692ab37-ea1f-4177-895e-08df254018aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|7416014|6133799003|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	GKQ+GuLFpCxGI1GpVvy3l+1sgE/27JctzVXhOoufXT1nPys4V3Xc/zToX/SljMiTQXKOCb2Jw2Bhkcuc+Drz3FAlHcJRy4G5U/ZH8urlyVf2HvUFyklIfjwJNOjcN/HB1Z+G4Wmc6gxMY3jJ1/AOx2LyixfiIZLsJhyzwTdAwUBh338EY0x/uurwi53wG8nwe4RuQxGhgUupE7uHQx3r/9GcMMDLhre6rDtpqfiUHjDNot0POqgr8lfk8AD2zEvYPo324GDhwRHLLz07ltuxVUCulK4du/DlYg8dXFcOZ+xZxbGQM5KLedpuXc8Lu990ROSPP+k7C1qvoTbH7QVRJkrA1+CxtIzBAmc60GT0OOC29KhmDfVHpubP279rawS1OLhEpdsso4Q0g58eYTaTufMMlRdoJZWSIu8UIwc2wXApdX4Abr6WjDbHl/YboFr5eWsmhkuTzs22uF/ZTF3tZ23N4NEKumfU2uXJhZetUy1AsjQAHKFu+nptSpRARsrnJheA/s0fKRnMVhjzkpljmBykZYdha8TY4iqMkrOIOY7Ic/6KTKK/VLSsZayx4P1rdfwYLN9lLTv9C9ygWAYgfZFVSCN5bOrMBgM+uw8jKRmj4pc1fsFT2vaGILnw+bKW4z9sSl4x6bGTrKWJYnlkQEWT1T+PboXSeX9W5xZfsrmAJQcYSBABWa3Rfx4X/E5ivxU4QaT7IvzMoTWNc87Cqg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(7416014)(6133799003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uAnQ0IuaxsT4HyZnpA3tVTUs4q99iNAgi0e5IDZ898wPtb1qlLwaWuKncVD6JWyfUZ3wv449Ie6l685eyQdLqJQ7XqbB4sUTAUJQwKFrz5zU6v56x6EDjeyKdf0/VNYMNqMhAOJv7fFe4Dy/RAn9XYWk2MfKeIE2Q/M2PAuBeH+ZS3I6dCq3mnX0y34oV9JhvTdv0OlXjadmxpBQVGtmhODIEU/xfGG1lSv96dAH8IotTc9rxOXgM4yNI2H9LRPNOVNozmgqJCXFMaHcZfqOPVJYgPFH/gHiKvMJFqXVUXZdQ5KOVS4RMDmhZ/wWNRI3toTso76nZtCed+JoPqrDxsxUoC7gXVlztyLlWyNdSR26nKJfwNema5NfILe/bGd1FLEXv+fIqTBq9Bon4tvMRZ3OwlT9yZddFvWICqno3c8b2VQg6NsHkzjRLpcTB1oa
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:28:53.0461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6692ab37-ea1f-4177-895e-08df254018aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378

From: Dragos Tatulea <dtatulea@nvidia.com>

Emit an informational message when a data direct device is bound to a
PF, showing the data direct BDF alongside the PF BDF (the mlx5_core log
prefix), to make the mapping observable from dmesg.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 5afb11a2a9f0..7db94b8a5b79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
@@ -21,6 +21,7 @@ static LIST_HEAD(mlx5_data_direct_reg_list);
 static DEFINE_MUTEX(mlx5_data_direct_mutex);
 
 struct mlx5_data_direct_registration {
+	struct mlx5_core_dev *mdev;
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1];
 	struct list_head list;
 	struct blocking_notifier_head users;
@@ -189,6 +190,9 @@ static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
 				  struct mlx5_data_direct_dev *dev)
 {
 	WRITE_ONCE(reg->dd.dev, dev);
+
+	mlx5_core_info(reg->mdev, "bound data direct device %s\n",
+		       pci_name(dev->pdev));
 }
 
 static void
@@ -212,6 +216,7 @@ int mlx5_data_direct_init(struct mlx5_core_dev *mdev)
 	if (!reg)
 		return -ENOMEM;
 
+	reg->mdev = mdev;
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
 
 	err = mlx5_data_direct_query_vuid(mdev, reg->vuid);
-- 
2.44.0

