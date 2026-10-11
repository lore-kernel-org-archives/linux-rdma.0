Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E6A35AC09;
	Sun, 11 Oct 2026 11:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718569; cv=fail; b=W0/Vsrl+XJSyEMm9Yl52n1uy3Z59RftQD1boWbEXK0vlO7CbVyQnOU5aa4M3xfrxnfsf1vIxFcZ2Ii09F3cLBggDG7/4Vo95BsR6UeDUE4IbMUulbMmt8PKv7+IbEQnIVFHdl1QIZ/90QIGYs5Y5sHKUxs5a7dmfaFDPu8z3rRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718569; c=relaxed/simple;
	bh=XCeldH7g7m/qxVeYgQzOKUXwFud1VhVBvEpf0BVIaXo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fjQS1vZAz5lVwq+6FQhEVuVgkgsOnTgkBry0wNDM+1H+WjGazpqO7QovBRzRMtY0GIMx4h7Oy3UQYCWc8DYvwxFHjJetTyCaVRTnPQCsA5Bhxjo62LcTfzruuM+Iyd7v/Jm4z2Ssk1gB8/wfETSLIQG3cCwH8B1yzriumbErvww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YNzNro2A; arc=fail smtp.client-ip=40.93.195.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YNzNro2A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8vrcE7828P5McOfRIOi6dYEYoBKGE0utLnzKiwOnoe/k6kU7AiJS+Goi47uYT6LKuQfDXYNPmJwOudlW4uiy/U1dANL3H8Ia/UpbQyX5VQvaU7VpRUrJj1/wpgE/nEU/zo1yfXfv2P6PoudCKvO/4MQZbCvDVtfyYPKT4Ag4eMTfSY7AH1rN7xOXiKlVpqVu5B+uUfGPXCSrH4jFGD8Lo+lWCgiVfzTbJxw8MFsqudYX3xw8Ax/CbK1l4/EyAig1DUe6K2Ofi+Kn8qUr08bZGqaIHH8kX3mNoAs3bxfvxeC2iD1ZdZ5I1YHS3v5p6Rot7GtmdVN8Bni4CcE4n4vIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+Dw+xU+QnyIpo7NRb0Uv/HF3mR7WkqdC5p8mnKqM+A=;
 b=AfX2C6NbO3LtCXNDmwt+a30AQ9bD72b9v7P3aURcqhS8zhqzDdrEyiDm348NiQjJzJb8crHUKWoLfLdaSW9m7BuGVZoS8vG9nRiWtt1s4H2IbDtE4ZZeu2l6bqnNwzXkTZuyx/vuoDr4b28DdprcWapk1Ve578WL5IKn8W72Z09PbO8y/AX66JbX83ehwencXivdql1BSxu629/KNz7rDa7HqFCV31CwxrZp5+uj0LwU4Icot4smhQS3ejDTjv7+0HVjfWrhUk+6+zO+oRObQ+xWR4oXtj224bg9RrsS3QsEpVw/E+wnJ6ivDgRJ7Y2wIkuBVuBjehA2snShMixuNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+Dw+xU+QnyIpo7NRb0Uv/HF3mR7WkqdC5p8mnKqM+A=;
 b=YNzNro2AoiqoPhe0Iv3X9OdDafPEHb6A+5cqH+WHZH1qvrz0lBS1jSEP9tjz/B4nnNnPKgwZp4QBPZRzjpYCnxPRuAUJSypvSzxBk/+uNnRwyZyPUodSehVTAf+oxcgArx+ni7sMT5578WckNeD+AJhgao3KWKNGb9elNo/U61ra+jUVDfcYL5+gm5Fz33mlrKINqMPO7Dn79JPU7H7LKpIGAuD5jYshDaBkGsGEUHT/itMQi0mDclVbA0UWsV/T5i0wFuLyik55xv1gZ94fbQgUtJZpmofDOhoTSzLedFHT//+3drgxILsSdto4xklM23eT+OwKcIg3TDXKULqb1Q==
Received: from SJ0PR13CA0017.namprd13.prod.outlook.com (2603:10b6:a03:2c0::22)
 by SA1PR12MB999085.namprd12.prod.outlook.com (2603:10b6:806:4a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 11:36:04 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::37) by SJ0PR13CA0017.outlook.office365.com
 (2603:10b6:a03:2c0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Sun, 11
 Oct 2026 11:36:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 11:36:04 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 04:35:58 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 11 Oct 2026 04:35:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 11 Oct 2026 04:35:52 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Eric Dumazet <edumazet@google.com>, Gal Pressman <gal@nvidia.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Nimrod Oren <noren@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: [pull-request] mlx5-next updates 2026-10-11
Date: Sun, 11 Oct 2026 14:35:34 +0300
Message-ID: <20261011113534.802524-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|SA1PR12MB999085:EE_
X-MS-Office365-Filtering-Correlation-Id: 89e75364-aca3-449d-f6fc-08df278bd562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|82310400026|1800799024|23010399003|18002099003|260925021311599003|260925021911599003|260925022911599003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	ocNKWEfbowSqxl2egX/SAky9S5JMi4t91/KroHfMCbdFctIOVOfDVajYwva1DCujek17Feg0hoXLaGqed+rrxnrL0PaSHotyXUSFkZonamF0mZS75uHCvFp97ZDLVWGiTOaVuZ33TV360Z/W14nL8Zd8PMkoRuLuWxu2Lbhiiktz4v5w4+rTLdLHnZ9ePGLenD3wR/nhlia+onAIbLzErKU6AbDmhHqz3GBTLQpcey6j0ODdqaw0f3c6iWa1bLfEzOgilWc6e3rVyqAy5khgYId5aoOMwI+UvhQ1bkqRFpuVjMd53a/XZwgUmXSD04DaVsJGPZ8a4NP5T4vPo++5gnp3kf+GXTzg0EBNNWoVAg1ZGE6XFBo58VH+6zhJhcmCSJTFyWdR6tNmo0YTHCZo28EXJWox0aZp9TrA+I+0pICywGA9Yi5SuCTLpH42XT/cnh2MtJwZ1c23t+JbWzOg65PtWFM6NSmds26saOqOJRNIMSkQhsi84+CcI45EV/kNGEkoiN9Egu3oiZEjF4ASF/zTtOlVeNPD0Fvqy+xEbO237IiQNAtDOTtFogYOoBHwQJFFvElFmeV5XF18+IgN0G4c8xNuyhEQnNTlAgKeCXwkEHN74cbfLzMqXC6ky31dD58R7WCv4HV3J+zVZZRoE9OrAW4jqSx/+r1vYJ5ibKuAgMkaNz8AOMFhFD7buPfm4u0TYkwk2/oi2Q1fTBqdrg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(82310400026)(1800799024)(23010399003)(18002099003)(260925021311599003)(260925021911599003)(260925022911599003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	11GAvkz4v5haa02/jaKbm6v1fL6fx+YdxZriDy+qJPNvddvlfmVBlOhg1XPW8bBYWKPeIdzN4ZUot+SA7NA1mNGyO0ofMQiqvQlKEZ18/BKatc2BYQnIC/FReJ/7DxVZINXTxBW2CgayGxUMG7zRBQwbNzZc2BfkR/aqK1QCd4FmaNQM2Dj0kVjoGwJ2FBUjYK+/q1kc6OnzsDYCyTVV15yLvURBDC4UXMD7eY29sAFPm9yqTSxyV4C7oJdSJ2FlMWN+QXDSjxoSF4j5RR9JGr8NMz8HpwpVupYdcpW3S2CC8vPy6QN892E9eua3nV8sZ4UNvRvNq3EBdKKvLEn/s1/oTdhTAJ3nWXseEVhiwnX+ZdErbVdqu+kYmGxxdQJXzYsUDBtSv7LeoNIfY+sVIV6ZKYt90Q34MgdnOBfoaPKzX4INByMb6SZEjGR+tD7I
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 11:36:04.3741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e75364-aca3-449d-f6fc-08df278bd562
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999085

Hi,

The following pull-request contains common mlx5 updates
for your *net-next* tree.
Please pull and let me know of any problem.

Regards,
Tariq

----------------------------------------------------------------

The following changes since commit 00290b9ff59ef47b990d26a6b1a8b2ea6dedf5e9:

  mlx5: Move data direct implementation to mlx5_core (2026-10-01 11:40:42 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 41de84543574f2923776790f608c56389aed972e:

  net/mlx5: IFC, Add capability bits for virtual LAG (2026-10-11 07:06:18 -0400)

----------------------------------------------------------------
Or Har-Toov (1):
      net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC

Shay Drory (1):
      net/mlx5: IFC, Add capability bits for virtual LAG

 include/linux/mlx5/mlx5_ifc.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)
