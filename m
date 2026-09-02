Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E23347F782;
	Wed,  2 Sep 2026 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367674; cv=fail; b=uUtzozT8OATNkPzro9BqT+gfSvUAW46c2OjOV0YeG93obkkz/OvLYHEvW7OPFZu2sp2unTLaIEaX3IJFOI1r/whbfW4Lg3ZT47fJC87t8xJgVYEhmC7nXnFgzdIbbHdUkclB+/Tv8O18ZyyB0SNTG9HTOgtpfbR0bpMICmfGMbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367674; c=relaxed/simple;
	bh=ImjG/ePm1StRngBRW2DoWcM8aFgnoMibJupHlo51V10=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mx6CBom/YF/23mZUMfnIVqtFODWIR7ZnNHnzN5xZLeJMH97iPn4eQq835MgCSQR1dYXnewLlDGqi4x2JOsAVxCeonhI2+0c1exXvFKMrc8wpOMM3tIUgomqEyI4VzQgWJhjGKNVLohqKqY5IxkpGcxFtyfCkyh9DO0O3Tx3bjhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KWJI1goS; arc=fail smtp.client-ip=52.101.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KWJI1goS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OoiUMgDWsUoVD36ZxqmTE6cH3hP4aa/mOE4PWrcStBf9Sl1hIcTS4K6FYhVxf/DQIsTvtJnIlvHVDEIVBnNnHKes6McPAvWapMM8UZysLUUq4yPImCSjHxCeoNKLn0eqzOiqqlz7YkwXKCppZ65H5jz9/3LMaXlLuybKsWWgST010edvvWoQ//q9aGWTh9CSww80x0oXfx3RNoNcREgzCizFHHuSsHe2uGVB9CoUvckQ3NgLUc4lq5iRPjGG3gYjWWZecXEz5tpWDeyP1PyCbjGf1YktqiEyA3xWXuJqGyUZYdhoW6TZ5QF/qRIehvT8vLHNIXLVJVTPqp8PTVEuDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isYPPFXRYko3nc9oKYjVVFM7LFgEHEzdxoW0Sx+0MFs=;
 b=mTDzhhQXo3LxGVcr86ulawAtLTOAWbFsaW7hdBnIkJWVhYD7Ingu+IiHjjqspnTGi3Xu3ooIFpSOwiyq10tXG40FF5jk2dX9GG3LPAum6DP5Q3XcrBCvDLbkXi8ALsSA2oyvZ98+hnTCoW0Et6m7qNVXvaTx0Pz5dkOoQbWOzVMUYCm/j+G5CoIeOURtWJfxWWtxbVDMWkaekC+adov8imkXYk6n5RoZZ/+eIx95MvHVHj2mBprUWjjel8PRIxF9OWtHerT9bCvzqiRYxD1Hixc/G+pt9fGsHKd/CCVFeVhgAGiMhWM8lM+7CrsLUWE8PkEEr9JDjuoHammyNqST7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isYPPFXRYko3nc9oKYjVVFM7LFgEHEzdxoW0Sx+0MFs=;
 b=KWJI1goSQoVB5l5EPilltDrmGblrjVPCYPybjcsxql9bVwmzMKDLpBbKEbSXeWStWro5kr4YpJXcDObUZWK3M2iK74iWJnmENjLmQhtsXsFzg1bPA5RPomy3H+bJfgdmun08DeTfLteYVae0iKEWIKxHux8UzGrXW7FWpiz65vceKXZzRDEEvf+8W6bYJf6XnnxQ+g+fz68r6bf9aHY24JTHS6XztASzxT3DRiFIRnxVXHfFMCDYYb5LlTWJBznIPX48sB6L/KO9ZlnViHMzKn3qtSbtgCeY/1mhRTxnq0SoqY1l4i6dp6UD3xYMwLfN+a+5oy9GH4P/nCHz/jiPlA==
Received: from MW4PR03CA0219.namprd03.prod.outlook.com (2603:10b6:303:b9::14)
 by IA0PR12MB7580.namprd12.prod.outlook.com (2603:10b6:208:43b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Wed, 2 Sep
 2026 16:47:46 +0000
Received: from SJ5PEPF0000020A.namprd05.prod.outlook.com
 (2603:10b6:303:b9:cafe::51) by MW4PR03CA0219.outlook.office365.com
 (2603:10b6:303:b9::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:47:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF0000020A.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:47:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:47:09 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:47:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:47:04 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Eran Ben Elisha <eranbe@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit
	<shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yael Chemla
	<ychemla@nvidia.com>
Subject: [PATCH net 0/3] net/mlx5e: RS FEC variant fixes
Date: Wed, 2 Sep 2026 19:46:31 +0300
Message-ID: <20260902164634.3657606-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF0000020A:EE_|IA0PR12MB7580:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4bf4e7-f8b6-48b2-8cbc-08df0911ea1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|23010399003|1800799024|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	YFtuq/rFeTJxqfUGR0GkeVoZ6kb6T1Qc2b9GOzunYLJ+V0xwNKdur49OFGqBNp+LXvwnc6FRpj+SsUe2Wjo6xii1sEAdaE5kKy9oyLGGXCmuYhhVZWiVOtQY5UZyYMbfxpVREDV+8RglyTQDsQCjenllh2HDEbiCjDomfP+f2Ze2WZ6mDSnUh8129/fno7i7YNEiljzy4OSDolxsVHxHnTM3oESB4QsOt+ItjRM7Vyq3WwpBCkyV18TiarC0u+kpIgu34IRAcVFKkr+CeLlh5YL6M/XezRJ3Huf1GJNqlkZkT9P+hD4kGHYcCURdMZgftzItq+Z/O3/q9LmztNhN9PAYEejMAsRYi6dC4IUtccmzHcJJ4uW/kxXbLQOtXOA+RS7wZWyPN70vYCPxGBlVXE5Ft82QJBcUfCsoeHIbwTp4NukP75t+UYSuWLcBkE6Dpnlae8KaTinyA3qGIThDgl2RWl8uDbPIbd2jMeTf9IKA+BgEE0YX25ekrB9mSrAJokP4esjbRnMHqqvKcfKg6XEefQ9WX++L3bfwG1FASCGJg3Wc0UJy3KwMN2fwWeEZocBpt3lycZaxcKkhikjUi+9piaJxOIi3Oe2qZfAalEN3AdJdlySlUJo8UUnn8dbzAWlUWt9ppbUKcdjXwAZbHfTT0CXjGlZkWlZYLOmccIvexJ4zfkMvAjZ0En34r7U4Z3P5eAcWd/YOq26wZNy7kw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/CyjZIKX+J8v+dlr0EY8iNOoUlFpYeOBHnop+AnaMPe2F6mYyAqWm/mwbZ9pxIW9rjJYXQQBpUohaDZAudzwabT/Ae1lmSTSlTu5/XIfjv0RE906qVQ1CgKS1tDa9lb9rjIV/p918xikjEPHgXf8xRC7FdqVHDQVzx9w6hVO58LKxY/b0dZbwANkmH9V+7gxFfSfEs51ahOgo2YtsxX4b3mlCF9pguHibAtA2iqfJ9DzSso7ho8ZLfNXoDotBunpTPvKbMcVEmOQx3jI/Y//r/YfmwE2tBq+Y8GcXpxtt6Z9PIDcx97z4k4MYP++zEPfMkeukoLkLbChWyRgPUHIGkxoORXguRVV81B28x81ElAhIm3qun4XDx+Y0CkmlIWW73YdOE/UfqpfvuZ5CAFduTMwrf9kllpQnlC5JU+X3u21Is57ZSIvTGdzISZM1VvU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:47:45.6666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4bf4e7-f8b6-48b2-8cbc-08df0911ea1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF0000020A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7580

Hi,

This series by Shahar fixes three related bugs in the RS FEC handling
for mlx5e, all stemming from incomplete coverage of the three RS FEC
hardware variants: RS_528_514 (bit 2), RS_544_514_INTERLEAVED_QUAD
(bit 4), and RS_544_514 (bit 7).

Regards,
Tariq

Shahar Shitrit (3):
  net/mlx5e: Fix missing FEC mode mapping for
    RS_544_514_INTERLEAVED_QUAD
  net/mlx5e: Fix setting RS FEC after remapping
  net/mlx5e: Fix reporting support for all RS FEC variants

 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c  | 13 +++++++------
 3 files changed, 20 insertions(+), 12 deletions(-)


base-commit: 70f3995830d3f1e79faa14eb0605914f778feca9
-- 
2.44.0

