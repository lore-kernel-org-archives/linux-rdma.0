Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011029.outbound.protection.outlook.com [40.107.208.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC031DD97;
	Sun,  6 Sep 2026 07:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678883; cv=fail; b=prHcaR6p03WGklt4oin3wpYZ2oonIHBkcuXy34M1REsa8OuXscq6fdh8luZ9mAQ4Q6+uHxFqSZtAhRXn3bT2KOFhMbxYIsVaJ6jzGWGMDbo5wHeNPeY03y7T32AUQAPzvGUT6A3BtR8TGFYMi64wyAiPUaDpXEwye2dTTl2sxZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678883; c=relaxed/simple;
	bh=SvKb1CRL7O+RtUCb8nLUPbp3oTyTYBmiWARi9yUXQZ0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bOORTqdZXuI2GuYiVUdwqCfwr/QTZA08YTZy4QRkxfZWi+aMtGxyNkjfAs7kXf2DWTrQfPEivLfyhjQsGXQYpVh7CBZxgYaiRs3XIox4SDGbzOX5sAK8d6P7QS3d6iMI92QZ9TQQV+HXMBaop4e+dCs+c4aVUPfFkbhiMeUc5Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HmcMJqSj; arc=fail smtp.client-ip=40.107.208.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HmcMJqSj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqtsgIpX5bHT07Ofuf51xLNVZfdcwVSOVE31c8lIVXWO+fS/+wpq0a1CFbKcpXlSwDMbqIHYvN6FKDmrdOkf4OSiOUx4nGnTMNJz6Oh8l0v9vdE719QDXPCg6XH7EUCyaeDOiOJmPjMjFBNquJNXyhttdXnviZV06xwLIJN+yEC9QVkgnakziELfSWEsq7Gq2iF/+oyB2fZSlb7M0T7MfvqMgj+9fwjh4bHQQKbFHniV2vnZz5FPUO3loja9MKJ3cKcjNheUD6Am0uIH/cMPBrRn+rHqn74hTGC10BkJSsjZjPxeKdr3brXGUHw0yp/ghKYYndRgp+6t/tlXBbKXBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwETgL8EEMomcJIMSBV6r+uvTU27Eyv0Y4NRxRZxD9o=;
 b=e9+ZAM272WoNqckXU3nZTT50MOCF/EczFr70wzQbB2lSlCJu2elv2384JC17OGAQ+jAadkgMzyQw+C3ki9C3omJgYvG8TdtjLZVlH4qVvTceX/IuR2MEjlGFWvSn0au6feQM49SojPVHPFKfKIN0IIlJg1nJRViWr8/WyQB/kC2DnvXcPeOGMa1A7AO273MwIjeB4/jydAvDAA4P2UK/xbBllacAf1mYrtceh5Gun1Xfh3jvl4y7FG/NVg2nH+48XxYdoYUF0Va2sfW52HOMDKPL1c0xVJPALLO7lWc4QegHSOSKrixb99MmpGYr/tD3ZYkkvGCsISypBFrbbDzK3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwETgL8EEMomcJIMSBV6r+uvTU27Eyv0Y4NRxRZxD9o=;
 b=HmcMJqSjL5mLsmEpTbwFC+PJWucX/FW/IooVsm0UxWJ+1yVc0AXWzO3ZwzEuA012anY+pIOyNcFzELRlCs0ssxc/nO1ISaFmofHPwby+Ti7JdRHz1HxLkWQG7MtjcqZHTlirIFD4s1gOJllQft02uIC/8QasEwaUACo1KIq3+ZvnfsXCwnwm6v3LhQOoQIziHSDyJjCemc9ErZbJ5vhZgcFHM7XvyJM7dMJEUjka9M8ymlX9hLpgkh9E8AmY9AyVeO4LOjgnVr9ie6BkVynhm94+qfyS/U+/cklccogPEQI6Sl7lN/yxuK1jlJegCfHXD3vkgW1rDKFWLoiTlTmxxw==
Received: from SJ2P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::13)
 by DS0PR12MB9421.namprd12.prod.outlook.com (2603:10b6:8:1a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sun, 6 Sep
 2026 07:14:35 +0000
Received: from SJ1PEPF000037AC.namprd03.prod.outlook.com
 (2603:10b6:a03:5da:cafe::82) by SJ2P220CA0007.outlook.office365.com
 (2603:10b6:a03:5da::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Sun, 6
 Sep 2026 07:14:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000037AC.mail.protection.outlook.com (10.167.244.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Sun, 6 Sep 2026 07:14:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:23 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sun, 6 Sep
 2026 00:14:17 -0700
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
Subject: [PATCH net V2 0/4] net/mlx5: SD LAG and devcom stability fixes
Date: Sun, 6 Sep 2026 10:13:28 +0300
Message-ID: <20260906071332.3759199-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AC:EE_|DS0PR12MB9421:EE_
X-MS-Office365-Filtering-Correlation-Id: 4305e50a-087f-4d68-4fa7-08df0be68188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|23010399003|36860700016|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R919VofvMkLrT8nheVCXG5MZuoITGRXHr3k+Kt21c4UxonMfxenHCZuCDAM1ifhkLa4/HYJo5kawZPGlVOMTavA9f4mvmbkkb8pYmo6Q0D6Dz3qLXBrUzzbpwYpy/tMOGVpUENojUfrHr73E4kUmdhIxt3czZAkgTgky++CuGiTBwtlEaUazOYhxgBd+Zp4yamTajeVdnzDGcNsm80HtzB2R2lXeWKA29nyzJZk5Ubkx0BDoXGORQ2mmVvQvLRBWVK50NJ9RodVvVEwa1nxKhMKpleWo8DHS1Bm1jGCztWlmlpjOAONQom4Spxvdatrlsb2/dRRdX37g9MMiXIBQvtlfJpAX3eyzo6GLs/KmjKjF8lZxgs3RlO8/BPjuNT+sxCZuzqywXKrcsEY0SVtuIP7tQA/HtvolHq5oWG95dDBzmZmn7nPI71vgGA0WsZ9ER3/tYySMKpX8G9xqqOTsAy+l1Zd4vsBmiElm7co+peFTXlBYPAtZ5P3oCGjDQ6+3Wah6vg8CYj0lC4sP4AaqWOTBNkY69+Yvg8pvAvyg4laxS/e6cXqVKlCVipl+C+7TqVPeIaZlWbSh++A1Jame0J98rrhLao80voX/mxpU4a4/7K0vjM18o01Cr60FwaSLi0nGE+CkxENS4hbd/LqS5PH5pSKCfA9MFvGBpzHjQkPi9PcaSZxS83IKh2TE380sbFndd4YJnfpvv8nsqk6I1Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sYOIV5Uq0GtyOt25vNfGpxuECvsMH5lCtoGfad+YG7eqS95WEtTQLwdeZVXcJ8JUT/qzr4aI1zqgcX8jBAtqT5cqYuWVDMmQBiRqyNU9CFZqHJnrqDDDl3m24TUCluSzZmaLd4cI1fSlkjftQoqHhqCCGVRK5RzSeBt5jaseeSbfEgLY8/DRzCFT/XxE502GqRdgTIYHaktxN8vfGLsh2xemCmdGvq908T7V/lkE332qK40sj+apmSWQqCyZUeJiy2iSkmZot8VXam1LYrBZPhu3V5M8A+IldxaC+kqZxyRYtt+IImdCHt4b0K6axpGciZKXWcWrQpzgWP5kFUhVZcNTUTfsQTrMeU6q5EySYFY+wPFU+sq1NLcMqg2sjAymN3oOPN+vYh7yNrwtcx0NIJGBgDYx8lJqv7L6OwtlPgLz+ue7Q2WktvL9uMpkaOVN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 07:14:35.3123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4305e50a-087f-4d68-4fa7-08df0be68188
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9421

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

V2:
- Fix git am apply error, and move pre-replies to cover letter.

V1:
https://lore.kernel.org/all/20260902163716.3656279-1-tariqt@nvidia.com/

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


base-commit: 2b4707a149a55e8fa75c9ef32b359d60f470a566
-- 
2.44.0

