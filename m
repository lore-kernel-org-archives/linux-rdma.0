Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4267A13C908;
	Mon, 10 Aug 2026 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354048; cv=fail; b=Vid/Cddtdqyr5wd0mYHLnYDfilCDrI280GrjJ2ngRmLUbYPhHScFW4TOTCYVcf8kvxj6UxX6/qLhzKOCTWWeH4iDJ+hhlbJTAex59caC1NaO4t6PWRD1rsJtfkeKgLLL7a5fSj0Ihkvv/jZBiR9ttlip1DyQH/HOhIj0a5O3rN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354048; c=relaxed/simple;
	bh=SSELDs1f9WoSumqm4oRqbkL1YVletQkwMOrd1MUVP8A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DauQcgGK4FCdDGetZlzTXxB2MrPYkj5scqthMaTcHBoYvJnuOnbcn7vYtXzhAVk7CCyvzyZoCmfLKwTdXR6VwPcMOLPF2fqUGUVuJ+Dxb1ik8BD2b/z8d19dZGlITgFmtV5C16coRiB9+7GNtwNyIjiBQbx9SuDHuLnrNttuUr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q0UEFymu; arc=fail smtp.client-ip=40.93.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q0UEFymu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFpMHiIqvz0rb61wVj6OQ0++hpL3oKAztSt/fVJwDZWmIZ2ouFa+Rj/xhdkO+5y0S0LYXyRmK3dNX3tI2HtgG7KWPOsegBtuF8s2pGSYVm0wHvUl+zlQychQ7fwLaUyb+We+YOcxsHPQEhQZ5SvlWB6sERbCZMd7KQ6wYZbMyouToy+rCxvYtq4siRMuX/T2EE5SCAqAJSIkdM/Ot2akSKMig1rwR2aNv4uM7aULw4qZGL7Ll7KuMPCFlfPKPusQ+Cbe73YcekYoF3A1fy9YWG0WlRiHSnM1Rog8RyEzIxYr4DDnn7x2MhAMrsXETQirgdUvOh0w+pwCkWRp5u0uvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OsgsV/+NQBLpVkYWAGePVUjvJHe5bKk4f2u6ldBxss=;
 b=YPH7hNQpO218zihJMFPOsW+m6QqcbgQrP0qklXs27E3TWMkYzMYLwt77Pbaiw+lvOq9DkK3wQBoNZ3qTA926bN8a5w3CTjYLPgYXomyYVkGMfKp215A5YoVnwZU+eVT4bEL7dBxqHLI5/Uv6wmRkI4i4EqHx76wpD+CX4hIVHP0DR345QYiwl0AM+mCcqaj6iVlZf1eMAxA+ZQlrvDmBqOtp1h5guiKRORm95TJeqKdAs0fs6GrKZd0T1I7NCNpyZn7kCbrWwYOorW6WPFYiVInJl+8p+uBGhoxruT3y/1FXy2yYyJbGvRNZOI+5nMdksHEGp4qWRTGkeBgYZdVPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OsgsV/+NQBLpVkYWAGePVUjvJHe5bKk4f2u6ldBxss=;
 b=q0UEFymutDRQnxkHJVHcO03USFuodOKPV8Gd2pe7FJ+TKrUgJ0w+iRaHX91v2bgYGRzBUQwKak2W5vUKYer15Vy5/9ZHtXjKl1PcH1cfSU3XrVXerv6eC3yLJ4UVLHGoMcwaJz25JS9Z4Sag2kT7WEGW+3Uife/kQyQL5HLoC0ZlUc4yZSOr/T34fA7WLKTLQqJ+4hFneU+ojmVDxBu431+x01tt9elwdLiAOcrcNh35knDdvoRH8sph1y9cahQE00icverH9jsuiLrKouG317wyR+fsT33IsghxCJe2QQkDJ9BjLBgcsZRbhHPyb1Ed/b51MK/WrcoX9FMp16qcAQ==
Received: from BL1P223CA0040.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:5b6::13)
 by DS0PR12MB7849.namprd12.prod.outlook.com (2603:10b6:8:141::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 09:27:22 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:208:5b6:cafe::6c) by BL1P223CA0040.outlook.office365.com
 (2603:10b6:208:5b6::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 09:27:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:27:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 02:26:53 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 02:26:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 02:26:46 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V2 0/5] net/mlx5: HWS misc enhancements
Date: Mon, 10 Aug 2026 12:26:25 +0300
Message-ID: <20260810092630.3137666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de45ca6-083e-4d56-970d-08def6c194eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|7416014|1800799024|82310400026|13003099007|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8foBXpvU7TzJcrjUZ1e7YyAvokHUX7yivUGRb2mGDpqnrZccLmyTydqDUyXOPfDIxQ/4kaRXSbS0mpybpg8ioc1xEOUtl2itGI/efqzgXuf4D6B8X9TsOoDepriWLrmfXzTdiOk8kDHxUMeRPzDh5QQAFo79SHg1MUh6r6RR1WpturXrWbSh+Y8hV/kZcciK0S/V4AGYxs9aFeW1iTg7T4GC8pAj8hFZGOKBEkM9xYGkMlAVn1Ne9MsPIaSZw1olAysNCkfnHP+T3xSv0NDBcY9P6n88mu/mNFjIUEyN+DyAJkJfL7YpK2kJvrQIZ5xzau0LqoOIRDI5zwoLGQT0z/0CRNo8L/F3wN2rMLAQherpvsgIEYIPy15JGuXJ7qUbViCzT/1OqiPzyUgsFIGhxVOr8sHZpULhS5KVITytI01odFbj/uAKOB3qgNEFMU5sqoA0c6FvvOMk1/a5RVioRTxf9ceRg6fZA3i7+xN9nkRpJex4IUOZ+9Hud7G1z/1mLLfwnCDlaCMmPudRI5Q75OsvfhuQwFZD8ZaYt8wYD5TyzpiCbmoRlwEA42pIIcxDge5AFpvZbhSfBbUiTzCYE+OJJ82mImEA1sEIN/Q5La6NC7KOPxdjlSUbpZZ0oKgSjJ/bnEvpdIHO8QIraXEHfT01r0zbM7qeq0Wb6KcBPyjO5cKFSgx5BIiMvtm1vfTHvOD+0Y0AAYUTSPWDrXPRlQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(7416014)(1800799024)(82310400026)(13003099007)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TYtlQ+nIsU0KQpbUkwo+aZpHifT3AegKmd0TagF4Lgtfi89YjylldIenHL2hoSiDNm02nns9f3Wg8yDUO+yEC/Hz99VEI9ACrbVGZqR6v17FtAAha5aCF1XPo9Dt3zNOuFaBXUk1hPk/zJcjQSPm0ZMMIt70oVkezuv2s4r9WqXOqi7KRZ8cQyVBFVdJLAJUmKGOvabxM54t4KNpIM08P3CwnWoZl0IVf12FzhflkB8fbpXCMNFMVmuQPMpMDwzjdZR31fCZeyzELhwe/x5O3tqbjSRwFwrE1JqmPW5fkCgbhqnCgobdc3Ms7mnhyvxeVCa94Lk1/Xk3g45Vl3ecY2zm/daTNRrj8tbHje2g97zFFxz0VCql/b5SDLmwFDGTGHsDquzl13H4toZmW8MjG3UWHwV7+kVJcnE8vLpDfppOmUnVMGSh1gb4pxzvZEB3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:27:21.8838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de45ca6-083e-4d56-970d-08def6c194eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849

Hi,

This series by Yevgeny brings several misc improvements to the mlx5 HWS
driver.

Regards,
Tariq

V2:
- Rebased.

V1:
https://lore.kernel.org/all/20260723095349.1890983-1-tariqt@nvidia.com/

Yevgeny Kliteynik (5):
  net/mlx5: HWS, Print more details for bad completion
  net/mlx5: HWS, Log syndrome on STC modify failure
  net/mlx5: HWS, Set the num of queues only when alloc succeeded
  net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
  net/mlx5: HWS, Remove redundant FW command when reading caps

 .../mellanox/mlx5/core/steering/hws/cmd.c     | 15 ++--
 .../mellanox/mlx5/core/steering/hws/send.c    | 72 +++++++++++++------
 2 files changed, 56 insertions(+), 31 deletions(-)


base-commit: 001b5d347d8ba39b2dccaefcc57967b18caec8fe
-- 
2.44.0

