Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013023.outbound.protection.outlook.com [40.93.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3ED33F59C;
	Wed, 22 Jul 2026 07:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704266; cv=fail; b=kUomkoW/VZXSnd5KfdFwb82VklRlMh5YYJzfHSJwKdZaet/7L2UWhYW+59Fg8GU8TonfnmyeMOvW478PBFJrEOVOSar3sGDhNl0JcYXcpNKM1D4YZlO6SRoJTmfRI+PWOwVvpBrmAgnBlDU03Ixqbl/Y/C+Wm44VDU5jiNFPVuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704266; c=relaxed/simple;
	bh=sf3zjPF4n5mjjMvjwCMHf7qjpacVwcDoRnN/q4ZKfo4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kzM6EvJFsyRL7QmdYq2Fe4N9LMt/Zn8S4eCDjJm08LzBc4n8aNMjI89bVs4Z0sQCCQQBVU4rb9jrScXzBJGTYf+re9SjGS9XGURUCLAHWtnIH3Mf2gNw2MfiRbGyMNdy2XAXUd52ZbqogK2eld/glfTMYgaWe6A0/hl+xYuGETc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TMd+o7oh; arc=fail smtp.client-ip=40.93.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TMd+o7oh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MB/CFVUu7S43K/4+JGL9unMDKHJ42U5DSLW+O5a9BubtZXr1pEK4W/iReF8viex+Dm1YNfE9jofaBvlKJlftagCjHHKW/QYvfgzFr0WFpF7hzZgR6A7kERVR757bhcC8k2hxCILp0hAlEk8bkiqC/IhfVmpBOHQLa6+Gjy84aWigZYrp9fqcVoVBbfgHDPbnvP9Xoyt0GsCPQNVSwZtyr+85+5fc8GsVAG6SxxX6En1ap0RxDh6E0Kb/XCYwSRYqUECd9OgJTm8Qmk1PbIjuDjBxJBFLVR7yXA8nIjZLVdVGtuh73N+O4T7FlfYLz03e2PMlvN1Y2n1CD5A57ETfeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2XLfzY3myacS6uVv3+PW0pceQHMDtLl5mNMum6zJ8k=;
 b=dOSYsJk/mCw88uuuYO+IMSynsvp8dz6mIMRNjYAaLufiuQ8xozPLdwl3kqyP6Oj36y5kTWVdIZlZGZrbf2NKskoeBwUS9889DUAr577KgOqJ1Cu4oc3hN+/zWg2s6+UIQOwr6KZkBW25KMHB59OuVm9cBHCfxxuDRNivsoTGr0/tiydenA+A6yoGzkrIvh3tIDXKbZ/uLKHXHJy171EYQNXuTR8pwtpLmEzEHHU+++lN8ADziyxiFG9znJtcK85Lzn+22EAGxqvyf2uCGZRaQdSVdyGLECbYxGfcy/JJ/or2BrKEQHeT0hZSlr8BOQWMPbFazlOMswjW6jWbJ6Zu6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2XLfzY3myacS6uVv3+PW0pceQHMDtLl5mNMum6zJ8k=;
 b=TMd+o7ohOwqbPlvdFo7kHWU0ySj8B74k7A51doKtOE3lwKpuhgSfFM1ld35bH/HxJOU2oPv0I1vWrxj11tpK8FubXeiwn2xTkJ03U3owjHnBg4iVh881avki3voBf/RccxzZcn7i8HoGNahqjYlXfsccWLWYaf0kbXNTqCNTmQ4xCKzHd/RNCXRUbLF+ukiACsWuaBPC7SJjNszJcu5ARXe+2BuBWKxYwuzyl0LuUYPdYyspiFLTeIdBN57ayrAHBPCJBhIZ8+1ddCMGhsGW9cZL5ic1DfjKgPaGEbodDA4x6fZV8dlVj5SfXXtFnFZJAd3WlVZOKf0PKV4CyOcW3A==
Received: from CH0PR03CA0237.namprd03.prod.outlook.com (2603:10b6:610:e7::32)
 by IA0PR12MB7626.namprd12.prod.outlook.com (2603:10b6:208:438::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 07:11:01 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::ac) by CH0PR03CA0237.outlook.office365.com
 (2603:10b6:610:e7::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend
 Transport; Wed, 22 Jul 2026 07:10:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Wed, 22 Jul 2026 07:10:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Jul
 2026 00:10:46 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 22 Jul 2026 00:10:45 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Jul 2026 00:10:41 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Alexei Lazar <alazar@nvidia.com>, Alex Vesker
	<valex@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Feng Liu <feliu@nvidia.com>, Kees Cook
	<kees@kernel.org>, <linux-kernel@vger.kernel.org>, Parav Pandit
	<parav@nvidia.com>, Shay Drory <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [pull-request] mlx5-next updates 2026-07-22
Date: Wed, 22 Jul 2026 10:10:30 +0300
Message-ID: <20260722071030.1693021-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|IA0PR12MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8c7337-170a-48c7-2161-08dee7c06197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|7416014|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	uF3wuyRGuoFhz17PhUKWSz/HKXMnI2KJe7xYmOP/hjVoqtKLUVOSA9wMThwcsoOi3nxPq4L9pk5wo9DVVZlYJJAUTcq1zjhLgSm9/pNSeXM2rUGEX/g50gl0Ov6HzqiXWpMvKQqdWi2PgBD3hTy6TxuPMn07pUV6tuEophLweEWQtUcW0p4CYtw4a1pOrqaEiVTfowSCVGDoF0L6hZYxd0zvYj3yNOHDQoIfPBM756KSlGrqJ2BvOh3Hm3cquyTfIEQP5pRaCDhrIIgKugpDfG9JeX1WlDuFi+RFtxe0JD9c/3e0IacyKIFb8TOkMvVx1yxY3qpH9/3us6UbEZ/rLmvsozufafS4Ha5EKIPap1cEmA/9Y2YJULUbCNsqFYw97tocfqRCrRVTiAq4mbhKMfVxW1Ao4eYWTvo4Q59cwNvOxDba1ya8auj5P7b53sTX+eFUx640KXaB2p/QestCIMSKD+RWGVEmH/remnRfDUYUgBYbIgSxtAuddC3odZqcca7UbbF9z/0JINf2D9Zn1zFrYl0L//8nTHKj5qEJexuto+p4TnHn7DKLu+XgzToH0dtrVVvVZ6Qeha9yIZ1+l/vxfmqmRy3RW/QCHicj8u9GwXZUdZAJl2C9qORRCDy9untyFpTJ13il4B1cKB1Ed28itFiXUO0kUNAto/JHGmI48DdZsQOdABtwT2Ypyrp6w17EB/+rbC2hbpwG6MdxQg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(7416014)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FLYEF0RO/JaxFbzylOZyF1SpnxbuOMSl68GFQ30p4ntVQo6H+R8kzHTCc9Q/WAqpDyuUH5zip5p9b8h8UFfv3o1hn4c3i3j+2DtCJ/9xT8mww9TNg/bUeJJY5hH3yDqqif/Y8E7jQuBB1r1LcsE6TnAXQiEsp+0Sm1uqbOvsbE+fZQgE4ShEOXihlYmPruEph3LDL7F/Nc1ZywjaZU+81OkLW89eRxefirYWMgJBKKd2ZfFEiJy8BWH5jpXFpftxUYGQec2Q8EcRYzkzHzy4cTD0KAxBGFgtFGeAgk5g6+8UrPiPs4esskDookBqckwHBUYqrvB3ExmeamEcvlb0X/xoDdcZrT2spzSINGMIAUu1n1V6pU8Koy7LSzpkquGLJ+gQutKfnTUAFEbWdP5j3QuEqL4cp8lbOJgVIfTIGPXjrl6jXRLrg+SFQzmW+Au7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 07:10:58.8773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8c7337-170a-48c7-2161-08dee7c06197
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7626

Hi,

The following pull-request contains common mlx5 updates
for your *net-next* tree.
Please pull and let me know of any problem.

Regards,
Tariq

----------------------------------------------------------------

The following changes since commit a13c140cc289c0b7b3770bce5b3ad42ab35074aa:

  Linux 7.2-rc3 (2026-07-12 14:16:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to bee40a7d0bd1263934f99054db037cdd4a33fd86:

  net/mlx5: Add PSP related fields to the mlx5_ifc (2026-07-16 04:24:02 -0400)

----------------------------------------------------------------
Cosmin Ratiu (1):
      net/mlx5: Add PSP related fields to the mlx5_ifc

Shay Drory (1):
      net/mlx5: Drop redundant esw_cap, reuse e_switch_cap

 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 12 +------
 .../ethernet/mellanox/mlx5/core/steering/hws/cmd.c |  6 ++--
 include/linux/mlx5/device.h                        |  1 +
 include/linux/mlx5/mlx5_ifc.h                      | 38 ++++++++++++----------
 4 files changed, 25 insertions(+), 32 deletions(-)
