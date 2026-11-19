Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795090328;
	b=AsBwZT1FNWkQ3ZU35nXABk8kJGCeo5lPFvdfqMXS/0ee1mFgyu8blOZw9V6p8oTUrokR
	 y74tq7vlVtMMOUK93J8J75M68zYYoFgpvUryOmtjDZfIKfZGVasRFMQMxChUI8KtcftjH
	 0ySzCiPKKaVZhFj0IquFJ22AkMYWWLXGJm3i7IAlRFujcr9eiPfzW1A7i6uoZNFUVxhwI
	 DUfZz13237mjdxFtbePzS3RILOSJRgQn8nXUWrE3mfeSRGXQvXo/FyhwirO5BSxc+ADMN
	 HGDR5z5oqHljd26GJrrG33G+klxQ/WvGLc0sjmJ6baSsp3MWobeFtxUs9T0CNAU5wsw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090328;
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
	bh=dwWOckp3rXyZ+UXq3MrByKMMrBIcJ6p0Jz6i/bxs/c0=;
	b=Lx9NsB4g8XEGIPsBFNJ/DcFCnfjuiXNEY6xqIJmcJ/dCxuWuXjOJ73298YRdUBvQBhIc
	 nTC/bM5X3ial5eGX7GPbH2vKgzDo9bQm1sYKmQb1qxszRiw9hPhVBOoVG9c6NvMMRSKkI
	 Finj3Nz0DmGEjKaDkNGKcb+buKq8f/s+F810POvNkCkkB24k72ViUsp/uWEa/Sk0xESwl
	 3PnpQqWLSfu17ip9hWxaCe0pBAEQtvy0EbB5ZQyDvSu5md41LgA0LFjW4BCc8kLTkE1fP
	 WGjwjmJwSkL8MjAHN2n3C5fhHxruo1n7SPH5PPSLOQhn4+64G7YnbonVaFdncbC5oJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bCUoWf3x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.59
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AF060A260B;
	Thu, 19 Nov 2026 12:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38AF060A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bCUoWf3x
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7X/W0UjEadSZL0Ss2jOT9JqELjrIa25zU+/hyURbBczBGOxMRyuHvvCHzS4WAeflWpUJ2K8wWHMYgMNQqwZ0TaYVNDhQmuO0AVW3b5ZDedgpZdsK0dzWyiNkbWfh2YhGC+DyDOM74vPd9PJEtmxcd0ygZ7iVEtoDSi8DlFmo5dBQAl8SMjV1BlL4ULl/lQW8TXO6XrAXJ7Gf9CKMDGeagzVxy6HM94ejGr2XcmQdtBrV7vNAr7ZI9xuTSGkVVgJanZZDBhXV4RPq6U/sFSdPiXWdmgK5MWTOmbIFquCrSPspnNXy0DtvR31E+2ty2llM8qj6p2Q6eaCWf1/Mts2fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwWOckp3rXyZ+UXq3MrByKMMrBIcJ6p0Jz6i/bxs/c0=;
 b=oC4SQaNrxF6AVkT5q0DlxzjyauCEZu0s4G7lsDIBRt0HCk/qc4oLxgZEBf1Qp5LJCBjaGeHCMQ7vIGdaEYUayVjVV4+WOrONUR+BBfk9DUzEsgstvSyB8niwubVBsXWkyhWf7DKhfEBiZJ64sX1xGGlyUjiaErfxHFRQuQ9euXL4xxETnrJb9rklKCZDk1i9F7lvMOYGsp7+6PojyXVTa4I9UnLLkZRysOVoG7mOxWr+9+vQlhHkyEhhvPJ7Hg1LEBxxRFemXxZ/MRofw6vJEMrEhsDcAqMXP7U3dP2ImJWQvgAuD++S8941jgBV1670BlR4ayQhESsX7hu1rSXifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwWOckp3rXyZ+UXq3MrByKMMrBIcJ6p0Jz6i/bxs/c0=;
 b=bCUoWf3xb2nnbET4oBHHoz8Qnudy9XgI41byYGWz+RCvoMU4ReKwEjPbsn//fSf3j6+XX98ZpEdVx9onHr3Luxb3Ufc/ZH6XY5AsRg368nrdsJc02t/VyZDmpGR3I0Hktz/XepSFTAbnFdmlMAd2LKwtnYytEA83zA/4Jm1dqhrw7SkfVsiFV8F4x+iVNSom1uoJhrj0sLJtiXgQPW9YgeOYvLD3ABE+DuKEPGw8m2z1TUFoncq9e7SZCo+f26I5B86LR/QgCmgulZLiw01e0J+n9Fv/g87kZyYR1DnUNi0LKZyznpkuIbpIeKuamdC9TtNMeh/xLuJTAljE7cHxAA==
Received: from CH2PR16CA0028.namprd16.prod.outlook.com (2603:10b6:610:50::38)
 by PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 12:12:03 +0000
Received: from BN7PEPF000000AA.namprd05.prod.outlook.com
 (2603:10b6:610:50:cafe::63) by CH2PR16CA0028.outlook.office365.com
 (2603:10b6:610:50::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 19
 Nov 2026 12:12:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN7PEPF000000AA.mail.protection.outlook.com (10.167.245.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 12:12:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 04:11:41 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 19 Nov
 2026 04:11:41 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 19
 Nov 2026 04:11:35 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Chris Mi <cmi@nvidia.com>, Edward Srouji <edwards@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Mark Bloch
	<mbloch@nvidia.com>, Michael Gur <michaelgur@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yishai Hadas
	<yishaih@mellanox.com>
Subject: [pull-request] mlx5-next updates 2026-11-19
Date: Thu, 19 Nov 2026 14:11:23 +0200
Message-ID: <20261119121123.2211400-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AA:EE_|PH7PR12MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: bd3c0c56-4cca-48c8-7ba8-08df463651a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|7416014|376014|261102123227099003|261026140227099003|261026121527099003|261028144727099003|11063799006|261021123027099003|261021121427099003|261022105027099003|261021135927099003|56012099006|10067099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	kQC8CR4ihCHvHcvBDQQkayNaCEHZYevuHxj+5gqegK8342rQPIPnTJHxuJx1MbgzEobeYnpBbo6rZ7p5i4tzcbSKQ1VN3XL4Gf84RAh3T6/em2CtWgwhowVZZ3DGNCKC/7OvT9Esxnk1oqo3e5yYydki0GrU24qHuej0meo6Ju8FrinE4Nk3Kejm8FoZjDibx8xMGgPFwWwOFCB3dTC0pJUSOix91a/l+U01WR3qrW8eLofDOSNUEo/2s4xpJLFPoocyPbEW8tQwocwQogA9bTBEpwCgyuXSodvBp/8uAzhUsmJVXYYrSnw7MlQW6gOXyIUdQ7wxjnexUCImHXXDvF01+o/K8kA9/w4bCQHGsbZ/Lxa3woe3c140tBOLmdhNXNZunEIcdTPlETNDRlq1YSgFAUFtJgeSrpP+e3MBgvxiKMYkW6+CWlKPnMjfb00UhOHVmucWRIEZTFTnirEjVXimkwtISENeoTjo1lwLQl+StbliDj4XprXQqYt+ozIK3ay7CkR/Ere3APctAbCZqqKSC5NNw+F+Vo+bAJS95/S1hD2rvXhxvebjnUz1w1csceaKKNJ3xtyhMoEWFcPnWHZl22vvrO/9gtsGXR949MfUG0qmc85FBeuzWWLOYfmqT4biDqESgkYGJ9UTx92YWqNNzGj+mACgF2WC8wVYWMawUDhbKf6h6P4qH/JqElaVGKiYmeapdrL/uBeMKsMuHw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(7416014)(376014)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(11063799006)(261021123027099003)(261021121427099003)(261022105027099003)(261021135927099003)(56012099006)(10067099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iZ74vU/DE6ko2NobCuctRqVly++mQY/Ms3az11rdAzMwSwO4DLC5uCXPNaHH2VuWwEzV7TfT+CoDgwmu6t4Bq6aBILXSrJ9zsRI49q1/RbkQ2e+ZKE9g9Q61FPUq5ge+9I3vyKqH7fjkt6gLZkWo9BW7OTnUZ6LoQXkwWSQ/T3BzptZorv4Lwm5QihsWEUo1Eg8D649wumekycjkNd/qTCv3E+oSVAuhn+X21kLVdFky7ZU3k+lE8t+ZUDroYbeS1feQNPgwh62PjJz0RE2pcAtJqLi3RuY7dPcitUX7QEOwqTIhot4+inG5+BmfbMBVSad1Q/K7f1IGZSC6RRQWNQZRFd4cFPaZUIQVptNXdnEjU8T1xBCDHwwwZdXbHXZhigafvyyyFgygyIPCI/o+oECZpxgh8MiWPg9avrBaoii0ttgu/5DLBDjl9Cylw5/j
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:12:01.6865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3c0c56-4cca-48c8-7ba8-08df463651a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235

Hi,

The following pull-request contains common mlx5 updates
for your *net-next* tree.
Please pull and let me know of any problem.

Regards,
Tariq

----------------------------------------------------------------

The following changes since commit 7475ea8b58616b33c04afb976cf0fbaad9dd63fb:

  Linux 7.4-rc2 (2026-11-08 16:22:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to b77e82a6ebdf451c2eb1f0d95085d4ca8446830b:

  net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc (2026-11-17 06:58:00 -0500)

----------------------------------------------------------------
Chris Mi (1):
      net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc

Michael Gur (4):
      net/mlx5: Add NIC_RX_CLASS IFC bits
      net/mlx5: fs, treat ALLOW as a conflicting action upon merge
      net/mlx5: fs, refactor RDMA transport manager root namespace init/cleanup
      net/mlx5: fs, add NIC_RX_CLASS steering domain support

Moshe Shemesh (2):
      net/mlx5: Extend nic_cap_reg layout to its full register size
      net/mlx5: Add IFC bits for SW RoCE monitor matched packets counter

 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 178 +++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  15 +-
 include/linux/mlx5/device.h                       |   3 +
 include/linux/mlx5/fs.h                           |   4 +-
 include/linux/mlx5/mlx5_ifc.h                     |  24 ++-
 6 files changed, 112 insertions(+), 117 deletions(-)
