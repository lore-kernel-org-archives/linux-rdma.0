Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012057.outbound.protection.outlook.com [40.93.195.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFB44A99DF;
	Wed,  2 Sep 2026 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367256; cv=fail; b=ev84+evq7yaV8h/BhKCSZQjIifY58vP86XXF4EJD0Ic/gANNLd9BmY6mpa4yIZuiZMG/LD+K3cowm5DWyNxHiSvTh0KyMAHcMIKZX7vm3xzdLcGx/OkANwL7gred1e7Q5llnc0D49glBH4FqgrZxxdScE1LNqmp49gH2zZIb9/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367256; c=relaxed/simple;
	bh=hqhPpjRaVmYhKRUnAr+fB1Pc7bmpGU+JTLK8oZty6Gg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=izKQeoZm1t910eLOoQn3dXGXiLvQUfY6Zqnn/UI6p9zYFwNpFMrprQkFl2wNZfYp+x25+xS2fWMisczsG5/5Xgqs8XliVN4BUSANvjXQCqeUJaZaMCN/gydc62CponyCver40/BgJrfIetHhX1HgrVidc+CWlCcAxUrsbptfg+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VeZLhMkb; arc=fail smtp.client-ip=40.93.195.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VeZLhMkb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+hqaohlMJT1oRdAMwx8TfvhnQxWhJw8VRobq09qiYlIUZJEDD+bypccTiPSDXfwzlp9mdsGfzYt/LDyYzoCxc5sWJq11W8/KbBh/YZrYW6mkhVuWPpkx74ztdipcFMcVUSolgdM1be34M/ku2bwdNxlCxvmYKkAB7dvlPvHI7ig9IKz4Ugu/UDhGeDR4ZVIwbbStwqPgwFHrm5yAWn17eOhl4DMpxAy5yE30QK12bmlF8wg/UywbjQkwtDtl3pz5sKwiHGjCogp48AUkA8butsQEdv9THsgOT/CrYv48/7be6Ot+uDpD86fdByvTq+BAiJlrEBuYJUjjgl8vKY1Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85zi+zaTAk0vRokq7Evrt6o5/uxPCmllsOROBabQP2c=;
 b=h6DNZ9Y2oHPLE5IUjcvL1HWiNeA6rzzicky5r46Qaul4MIBHX45EfDtl62S0mNF7MXvQs2TqOD3YVNGlnKzDvCF1ZK5Ef+zbX7Kz3cHpooAWkSFAtNCGO0fF4mr6oSIpxMbYrl0O7A5uuHYKcCqkbCpj0Nulw5yy/mgEAYAFF9OYPTaMDXVA4/JbtbfaQ1sIoaFgKSTco4dRXCQKfvRF/YlTQTbknM+yUWfwGWFob3NweAHlYqVgBAir23BjtdOB/uVjK9TZ1nHa1czhh1xULdW1DZHacSdRUwa9C38LmXuQTYjSOYjRnHWAGT8Sy0hqyG0OZ1Xm/n9MVsFrRmuy4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85zi+zaTAk0vRokq7Evrt6o5/uxPCmllsOROBabQP2c=;
 b=VeZLhMkbogwzl1uhFcnYuMQPA9Ryl7YxT8MpVdNMIQ0fJ4PXiDjADh64/6l91Vg27Ye2e8A4MkXnGQ5A5fan52IbMNpKe0V1D3U79ciiezIs6i5Hv8DB9n2LgnJR7KaPDP72sHTeJ0e7JmS4aiUNIpxpWppzhU146clhMEfjp3dhRhaNjF5+3SaKxv1IWdH7BrgyrkNX/kNJSY/bufvwHtM4vNYLVjXdLlmlIkwIFsl79fYqm95/OPamhLkRErZ/MJZ/hbeL6rzkMFsR9Mkr+pFWR5lt5NPQgZ5qboV6qdduWhOAws73S6PFYwFK9lYt586CgH4mU5NFGkENEc+2xQ==
Received: from SA1P222CA0077.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::24)
 by PH7PR12MB8778.namprd12.prod.outlook.com (2603:10b6:510:26b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:40:42 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:2c1:cafe::72) by SA1P222CA0077.outlook.office365.com
 (2603:10b6:806:2c1::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:40:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:40:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:40:21 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:40:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:40:15 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net 0/4] net/mlx5: SD LAG and devcom stability fixes
Date: Wed, 2 Sep 2026 19:37:12 +0300
Message-ID: <20260902163716.3656279-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|PH7PR12MB8778:EE_
X-MS-Office365-Filtering-Correlation-Id: d617afce-d4ab-46fa-4f79-08df0910ed67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|11063799006|6133799003|10067099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	J6/Zu82Okl2u+/OdM1Q/mysOeypbDx2RuBFjP3zC2gYzQquhcb+zxNbrQTHcj4pIDKoye//kgSw3X4YweWm9lhOS8nZlgfhM362GiqhYjRy96B7rEn2TLhjbAmMWioxSO0xQeOgSCAX3jhySyMXKroMjWU7ui6RCzzv4EVJtANxTQ2/VxGx9/URZnE5bsDYdz1sYdVSle251DBb1XaIp9ssERhQbP6/722MufvbZduVT1ae53U2ZG/s/K2wQmMuG1zw6/9D+ilwCwmE9yjJSREfknCyOwNHrYBE/KNx8G5DEUlSzm4Cf4S/TofHTPB7rG3Q6tJZvxJhR6Scp9w4F5UJRv4D9HjWgzxE+6NHelRdCV+FBCMqGTH+QWML2E+80LFW8joKWHu585Vt0Fu0r19X3fkfO/HXQvPZmtVrCz/ncrwWSLiPm2DverOIt+SfbhB8ype1Jm0uFy08UzsP6brdmqZG7ScGx9tqkl9O+p5DzuCxRmAOBL62N4P5cVwbFy2YkSgL0wvbpJM6GdISEQ0bY7OHZb2KN7w1gOSe1tCYeAWjC9Zh179oXJQDDR90dusWmh7d8R/IiinKjvbzm5sWgGh9mx9CQqfdEHGsG6izbv61t0GU+BLI6ckgzazu/S3vg50JAGe9+WI1JaRaXHfi+9lzZB2CuxZJiON9eIushElymelCrT0j0Wl5qO2Dc2BGcCgV2NAJaUIMNX5/m4Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(11063799006)(6133799003)(10067099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gWqzpGnt2haJ0KV0ytXRJC6AF60REASm/iy/7R8IUubTlhyLuY7b7sriU6PZqPFbWRGIg5mp4Ljb6MyAKDNJZno3Z9+C/WKs55c/yuQ5/NCSXUOh7G8zpLKkr/eUIm+zQfiHg54OiO5Yt2mqkJpi3gBHgd5dm+GJ2tgRYxqLEabzRVa7mawzTSoIZgcaZKlKZVsB56kkOjK1FziQKSTO3f3fNFHV5g4cD8KrE/DWEKG+gjP3ox2aNaYt2TfK2vV40Ts5WN7rfIaKJ9UozOlWglvV9OvPWv/uEpBnM/8hIGHWnu298IqSOFdUKXGdQJT7bXuSaQDTooOSMc1oEuZn36SCZXsTmo/enllh9FwVYorCjBAi+pHqSKOVFCnmhM1X4vEBQKAWnT+eRNxZ6yhJQz6LrfXWyWD592gZDh5s7sjonJUOjDAXOqouQtSeVyA8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:40:41.5759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d617afce-d4ab-46fa-4f79-08df0910ed67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8778

Hi,

This series by Shay fixes four bugs in the Socket Direct LAG and devcom
subsystems, all related to initialization/teardown ordering and
concurrent access to the LAG device.

Regards,
Tariq

Shay Drory (4):
  net/mlx5: SD, serialize SD LAG init/cleanup against LAG mode changes
  net/mlx5: devcom, Base component size on linked devices
  net/mlx5: SD, unload reps on shared FDB create error path
  net/mlx5: LAG, reload IB reps of LAG master before the rest

 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 74 ++++++++++++-------
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  1 +
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c  | 13 ++++
 5 files changed, 65 insertions(+), 30 deletions(-)


base-commit: 70f3995830d3f1e79faa14eb0605914f778feca9
-- 
2.44.0

