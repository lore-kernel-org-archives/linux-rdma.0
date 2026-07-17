Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013071.outbound.protection.outlook.com [40.93.201.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED2232B110;
	Fri, 17 Jul 2026 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274723; cv=fail; b=R4XCU5lt4IfTIhB21xCOgDvDy+UdZVbCbLz+uxTvLMj3y7fQ5Gk5/CTi5g/KsYHnp9vOldI5ozOP+sy4aT37wqx9Z5/Mxvk7CwUBhJz2eFER08IZ9TkfUgejOpC5t1oPW/RdpNeHAC/hDqeX7t3mQPZ6nq5sz+E91NECp7waqwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274723; c=relaxed/simple;
	bh=fXXsSfPyiIXc2r37+P1fnbe1RBYdZ/lluzQO6JbRB+k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TdJKIqdsD8XiI+J04KuP99Vqpf/8qtRF5197kY1E820Z35fgtGOepogLO5DPfo2UYVu60IhWSwmWF9YYbf4LUQOUSNCK7I1JfxUyNb/i3IaqMGClCua2kFazpboP4R9Ta18f7/UpZ92+ZuJLCBPlYq9+AGa34Ksd7JsRPF6cJPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gEdnyqUF; arc=fail smtp.client-ip=40.93.201.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gEdnyqUF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tcN+TfQt3xMb/mJaVGQA8sSxyAdYQLr8oU0J4mOAM7Ul3IpYNTTO+HvBkV53K+xyOFe6V6Pks5qrMjI4CII4R0GTcJw7Hn7k8gw87HrcINVqGJj0Dq7MnU7Nng1WdCpI4gUEVXrFQf99GwchRsJtAD1nJHFW+yYHYZAoc6MxbD5ZIKgI6IwUCuSnzBCIhBM9SRXsgPBsHT0JeuNHvkCVfhA0rEusT6KqjIhCXKXFfpdhiNrLY6pal6cjQOGBjMtBtNbhBeV5eP5s74QAEkXjrOuFdRQe4WY2WVQcy1U1px9k6NQzlJ1lRgJBWn7sTsveEIzYKetY6TO9Gi8JFyN71w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swtmPOdrvOsZg4FtMSlcMsiGU721+FhkJLCb44/j4WE=;
 b=FiHSqsC11k0Iuy5IyOQrdM3FNognd29sBTH5h7it+pNI2ylFySixKGkFdN7ZSbuDf4hlkx5i4OfwGnm9wfW1NTgWVaXXVaYRRosIRvxcWBWdOLcwE3kysuogImkRDvY/hNh07XU4cK4Jj6zzfxtocjd0UESadETsbU73j1WSNO0gmlpKXbVsPPMUPojK3Ceh7k6wMqFK3+m+dlt7nD4nM3v7V9PpkjOviDVsAdGYtopkr28sPKGcD/C+3IlLoy9GJLCzkYdKFh6zDoOvOxWhMGyii3YEiltQxkT6Sg/J8Efc0kP2q0n+7IgiVyCF5HSt+zwBKV+OzReOYvD9xva2Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swtmPOdrvOsZg4FtMSlcMsiGU721+FhkJLCb44/j4WE=;
 b=gEdnyqUFp9pHnH9ss7SYfkKKClL2QpxcNvZQCyI/NxaldHpNVHYy2c3oKOIuyLddNpVn+8Ywij/8UwbV/fuitdEbF55GDd4fWypUnI/5HHRreiBhpxWTNIAk21zjjXJzprUVQ3FyohUwQxEsbQULrurTRhLiiwGMmGdv+oZcwGyymofYfldQywGdjnw4WJ/5oA5U1OzOMn6kIVQD4kh6kNkVjLc56dSHHWHrCBb0pfICwYCdZ7X/tTUoYoACTU3rKoX4KHM1+R3aAE27n2qfF39GTaoOrYBsk0DLp1ZlKjKVouK/QUUfQmdWbEMwWEum8ptloKByr6apV3bdzr3NaQ==
Received: from PH8P221CA0066.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::6)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 07:51:56 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:510:349:cafe::39) by PH8P221CA0066.outlook.office365.com
 (2603:10b6:510:349::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.13 via Frontend Transport; Fri,
 17 Jul 2026 07:51:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 07:51:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 17 Jul
 2026 00:51:44 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 17 Jul 2026 00:51:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Jul 2026 00:51:39 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Pavan Chebbi
	<pavan.chebbi@broadcom.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net V2 0/2] net/mlx5e: Report zero bandwidth for non-ETS traffic
Date: Fri, 17 Jul 2026 10:51:23 +0300
Message-ID: <20260717075125.1244877-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|MN0PR12MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d113c27-0b60-4ef2-6f98-08dee3d84579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|23010399003|1800799024|13003099007|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bX0SKMdA4JCQZz3m9GgaVK2KZb1epUrXc5x3rMDX6qLTChqVqHKVuoLtTvWtnDEdL6xIaAP+kasqk3WfCHu70cj0koCv47nDEYz4OmyOD43lrrLRg8HDlA7AuNu3i4LQsu+fZXx21lI1jJCG6T3slIWEb9pjpXGoSAd6xdlMOcmIvwpSyrIQ//Ed99aq30Yqec/pTm/fdhi8q9wx06Qij+5ocpJOf59tjmUau4c/UUkmUte5kzEDnDV88MkTxeAKest/ggF31Tgc75NAAdu/mg4wowWgcwtjNOKwKuoHWwOIf6U5ZLnc3Z53hBlj81htfvFHGy0uNY0Q3gn+MiB2XCx8H9pqt1vA2ohHG0fZKpM3Ll3qkdSxyNTm1A9bg4mmklYGO7N9CrqaHnMGeRiHfF90rdadTry59mduQhlFDbPclqsOWgIic+7PU3ra6aj/CaG0ZXjvgPEnt/svR6MAxCY/upsI987CpPCT496LEiH+0TCi1JZK2UQWA2oK1wXA9+5ii72kGJHMOAlIbimEuZ6QobpCH+maTeJPBmKgpbuEv7DMHN8o4iiyF4Erl2nU5mnpHQAlkDblGlrhyWD/XXevx54C1Wc9fkosPW9xjRbVcpn6OpEVeJRmjhkozKJa7Hcpkqk7/udsGD2Rt5+XH7QKw5nZfSTS5c6vEeP6FVomTAIZ9DMJu4kEUW/V9jVjULvbjMBlGs2aQAYke9CNUA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(23010399003)(1800799024)(13003099007)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f0V7Sxp+Vd8DLkl9awlXYqV6ofLRH/dqHOExAE460q6NIMeFf52R7/P9GmFLsdevZIcM5jEtekuAgWeAWGzvhVjImzh8dF5fsf3Y1cJETeYv8GIdcMIzHGWQkZSIOC1YKkOwPBMaJzQh1/DYt5CK9UwoY2arfXCjaBvN5l2KlscgJkD2skdSDn8Gi399NhFlAFmR0a4wQnhHqy9b06G02Z9EwAUG1nTsVlhllMMJ6qO+H1iS4UIdkCc0mbZ/2Ixjiv8uBACgM7sBXKoDNrGYIxLiFkQz/aEnO5vi6zaCrAGbzzzrQ827YtZV1c6zmXxZyn855SOcTA6vnygEe2HkAdeBC7mbHp4wzus/GIr53Op3KKjS0uULk2lHqkZFW6+h6IKB8Vlts8jqLIpq1I0+B6voYFmEgvYqLDNaawGMsPyJV1g58MvXYCHswYkmyHfK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:51:54.9858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d113c27-0b60-4ef2-6f98-08dee3d84579
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811

Hi,

The IEEE 802.1Qaz standard restricts bandwidth allocation percentages
to Enhanced Transmission Selection (ETS) traffic classes; STRICT,
VENDOR, and CB Shaper TSA types carry no bandwidth semantics.  Two
problems exist in the mlx5e DCBNL ETS implementation: the get path
reports 100% bandwidth for all TCs regardless of TSA type due to a
hardware limitation, introduced by commit 820c2c5e773d ("net/mlx5e:
Read ETS settings directly from firmware"), and the set path does
not reject the unsupported CB Shaper TSA, introduced by commit
08fb1dacdd76 ("net/mlx5e: Support DCBNL IEEE ETS").

This series by Alexei Lazar fixes the get path to report zero
bandwidth for non-ETS traffic classes, and rejects CB Shaper TSA
configurations that the driver does not support.

Regards,
Tariq

V2:
- Dropped patch 2 "net/mlx5e: Validate bandwidth for non-ETS
  traffic classes" (Jakub). We'll submit a more generic version of it.

V1:
https://lore.kernel.org/all/20260622112925.624795-1-tariqt@nvidia.com/

Alexei Lazar (2):
  net/mlx5e: Report zero bandwidth for non-ETS traffic classes
  net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation

 .../net/ethernet/mellanox/mlx5/core/en_dcbnl.c    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)


base-commit: 3f1f755366687d051174739fb99f7d560202f60b
-- 
2.44.0

