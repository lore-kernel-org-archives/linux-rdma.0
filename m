Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011006.outbound.protection.outlook.com [52.101.62.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC0E3C4B60;
	Wed,  2 Sep 2026 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377619; cv=fail; b=EjeASnJA8QHR33X1LsYAwguj9n7v6wRJ56QzYMVw67TS+gxQF4iXM5BjGrfh7NXpzBHaZZogajOHmZVaoQnhy124Dl6Bi8W67V5V1MjwZReopmIolKc6YkvJfysZUiH6ve9SbAhp8f/maMQ810/+6vyC1JPwxsKm/0QmVabnOJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377619; c=relaxed/simple;
	bh=eBdIdF7yAwi1Z2xTDU1DpE96/qYCH0DV1PaQ6D9unI8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cLmnQsq96dTD9bC/inlsBy76kM72e+rrUxDDGF+Qcda1sLQSqHHmatkQ6s/J9NBhlLBGZhZTuS0hpH+cwU5fhsn7+Evf+YZ9EuqYBCAx+OLBryusPIPpXYh3vni8r9YB0p3l8vwawshBmt0erZetCFgPhXjxSqc9RqF/17MX7bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kz0G6Nfn; arc=fail smtp.client-ip=52.101.62.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kz0G6Nfn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3ebHsXxlFrOxXcfrDf09zBSDXnPxmlksl5mwjqXrZjUc0Tc/YSfu730WplCxYt4hO3O66g89Wl01/Pw/gJqMZqOfV8GrRNe7LvDQFn3i8Bj/TAKafnX7ZOKElxqXaEaPBGb7P3Gogm7S79SnguYGgOZkr+88qQPHRwToxuzjpcDZWtZVJk1xRhT+un1RKpkSvXPOk25A/cyv42rDba1HaXrDSBm32mfypeOnH3Bh4IQeod5i1ueGbgtyZ5A2H2V0UatY8r/rhibxaiRmxF6l97NopJdkPFpjPSik6VVPki4qUFQJZUqs6ir5hjuaKGMuvES7wXwbL5XmHNxeBtrHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fmSQ+1bb9Y/014jRGKeWfU5y4OjPVNf/dVVLE+0p60=;
 b=b6vRwYxfYqA5IxlVynEp6JXDNomK1OxugTWUsIt4JeCiFHOk9BER4IiB/LGK6XDXk4+beNxd1iDJjRkcSIEnA2nWHea1vAYFOUi22bJxKx0A/hM4vRK4Kh1Q3X6OVr23buYLvZ0hnoIKQNpNFjrkIyc5SwVJUEZwJRKmoIhRauL4GikVr49ruIkMVkRmNa3fgj2bmtNNBDtN14UTpERBUX/WynTo/JpXuznzgP4SBH/0aeTDMJQifgpzN8nvxPkEDt30X7EAPoahon5xzFDqTgmaeB5/AMHfrJhV280Q5cpa25axIrOYHRTO/g/IX/0AxEMkPXHQhItZwXX0Zp843g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fmSQ+1bb9Y/014jRGKeWfU5y4OjPVNf/dVVLE+0p60=;
 b=Kz0G6NfnOhO7sjJJQ6azKUHoLVtesDJFP38FusiQFVl0wPx4Ckvn3Sppp/ccqO0A9YVHiIstkvlaDJ4Ir57stplHCYx2BEDFtWVacKgKXP0mI2G72oY5faK7Yk3U/HXty5ZvwXXkhCtjFUsNbx7NLfIs4wHaQ1kgeqe9onbijluuzHxEcWA3W61VqkThHQGSTwnA91WObEGdO78W9wo6ZmK3cKfau66QUJJkjBMF9KBI2aWMIDY5uWF28mm1RFncVLSHmijRKsbGpAgeSPIuMxQy/QGm2gZJdmYSK/cUf4r1nSOKjcwQy0S+Gp1HZJ2A6S+jX3YKLuBMNjc4DydkFw==
Received: from MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6) by
 SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 19:33:14 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:23f:cafe::68) by MN2PR01CA0037.outlook.office365.com
 (2603:10b6:208:23f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 19:33:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 19:33:12 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:32:42 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 12:32:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 12:32:38 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%
Date: Wed, 2 Sep 2026 22:32:24 +0300
Message-ID: <20260902193224.3668743-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a0eca5f-096f-4aab-f1ea-08df09290700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|376014|36860700016|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	TBOA5oYFbA3on02LaXKRAJgcV/e4ep544gkvDgHc1F2hurt7Prx4ll8lJF3Y780kWcX3KbaglLdGk1SkRW1+6c6QmwVsUQ+/pJP46pVd+IiULDBNNsLdi94FtoKfTGjkb4j2B4UqNp8D29yuBiz9bnIUeX3ylhNPux4n+zlpDSJgtD6JSVKI6d54TFD2Jx9o3AsvyAdth+2e2Lg2rm6sMnp59C6XziJgjzbrp5SVQRk5CbAZBfcvNE0ZDZjwmJjvcrwX9u8Tl5PfWz1+yhjjXcd9hxJFNfaWXqvxDOhDmTTMMpktfOsZBv3PAJQdcZU+uA8EUda1qOaOMQslRE5jK/Vf3io+7o7wWekRH+b9Ub2lQoyjsyiUB4PWTHVTBBAnlzlwOh/yLPrTDdhW0su/sJWVK3B7a+GoxGxMP1iT4ywKTcAPEFwLcaDuMjDZNrFu+FVwItCV8CnXr3gH2Gvv8sM3btXpZTD1o+tsVvOf56Z5pYHJ/bC/PI5LoHfrUXHRl3+zFoZHfhLM4lRo9c4p4q/7eMrMiis6QiZ1cn2zOG1XenBL2rdZfDxnsZcK8yNHcARIYHtJ89EpYuS0JrpdEbatKyqOeMe04y8mNzg5RermZiDTezK2xAFxki2ARac6roHp+GFgU44Gq41/MYrzvzZnqpL/LJGO/wC5T4e84e0CULKdQObthg+sfUj8t5a9Bq9HFHRB2D0ZNvh0XRUv8w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(376014)(36860700016)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OKk7Ps5YOJ6QJZQsQkaKG9h4q0C44EuQp5mz2dwkhhJazAaMaEhiL9xJx7/7zYJ+b/WwrilPfObkVVIZa5RsG5xzLb9XD6TVtJK5ebOZ6jNCfG01fzBl3lbCa5GgbTR3UFBiuA134l+tSNwQnXSoi/f+xFf8g5XJNNtM82Cbf4A+u0+spxwq4mk5iheFJZsdZaVYd0zV2hW5/PtpkmWgyn3HkE3SdaAQtUTRLK0oEgt3GOW5m5yftG6nYrlVNnSSZIsuvOF4miyh4oPPOHfyl2gtkmn/tx6UTtMMfZlk1scEp/tOScueNWd1o7AiV4CzUr0TJ/ygy4QXLIKNTh296kV1/HDeKYCSAYL1z9Lt9WIvfpO8JbQKo3s1x2i/ddSAgF8tPvt6/FoRra6JhXjWovCtcQk6cBaB9hFtOPxNqNoF5Yv4+04ml7hVK/24rQ8b
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 19:33:12.3871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0eca5f-096f-4aab-f1ea-08df09290700
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861

From: Carolina Jubran <cjubran@nvidia.com>

When ETS TCs with zero bandwidth are configured, the driver programs the
firmware using an alternate representation. On get, it needs
to recognize that representation so those TCs can be translated back and
reported as 0% bandwidth.

The existing detection relied on the programmed bandwidth because it was
enough to identify this representation. However, when a single ETS TC
owns 100% of the bandwidth, its firmware representation becomes the
same as a strict-priority TC, causing zero-bandwidth ETS TCs to be
reported with non-zero bandwidth values.

Use the cached TSA instead to distinguish the ETS and strict-priority
cases.

Fixes: be0f161ef141 ("net/mlx5e: DCBNL, Implement tc with ets type and zero bandwidth")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 00e706e1ede1..741f75b5bfec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -148,7 +148,7 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 		if (err)
 			return err;
 
-		if (ets->tc_tx_bw[i] < MLX5E_MAX_BW_ALLOC &&
+		if (priv->dcbx.tc_tsa[i] == IEEE_8021QAZ_TSA_ETS &&
 		    tc_group[i] == (MLX5E_LOWEST_PRIO_GROUP + 1))
 			is_zero_bw_ets_tc = true;
 
-- 
2.44.0

