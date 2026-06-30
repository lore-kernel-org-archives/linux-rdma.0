Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C13FC5B9;
	Tue, 30 Jun 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782819047; cv=fail; b=EDDkbhrHObZ0jk+tQ39/JecRYfSZbjRAuz6tKjnr1pCKdZqjOUUnYhHnVpn0+iT+uL6weP1QsCLdWJNzxrLBEEA5cvyLe3dZ5hXDcBd9H02bM8fs+HIMdUZTlZNfVbw5gz9LU+P0debo8Mr7UAFy25Q5SfPdhiREt+qLIkU+fwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782819047; c=relaxed/simple;
	bh=HE2ruMNafAqjufCHRywLq6lT49A9WiLUnV2RWv5HIZ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+1nKTuIDvBZmnjmt6pqUO2J5RBX6nZMxdAZjc+BOS92EpTMYBuBFg2AOtyTnNhZf1nFbB+YFiE180NW81rplUA2j3i2h9w8/QjhLio4ullLKoFnj8aOwlzh20VEdtrnidJIyobPvzXrrkrlyR4EV7Er+n11xsBTHQ16NEgUdoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q21Niqr2; arc=fail smtp.client-ip=52.101.62.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q21Niqr2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/NBMI2cSPa/G5l8MOqLKDiUj5GmCOQa0AvVL0jAS/eHExyw3idRMjRDCN3KRRmGyBeypLGiFa0rh8649cjnKuR+xG7SwjkAh5PMEZNVZ2RkGCRtcrQOPcTmo1UUR88+Kym8WpJqXOey+7be5emZpDYb1H/QOPfYETn55gyiv6MeFar9vkqSTySrbz4DOk1XyNYH2crpN0r2UnDsprwKJQmM6vDoRp7Esiodc2WNEaiP2eC55eC0XSYHwxYPCFv2Pgwgy0xwYF1PvKpgjRA5xP27ZFS/U8ltDujnnnMkUlHbHQeQKSv2BJ3+Dbz5u7iOMySUjdVDuBaJguPXnH943g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxy30zJA9RcjwrZjWZ96M8spw64w1BrRKu/XDWnnf2Y=;
 b=briRC/0Nhvg1Yz7csKpllFb5ss5CF4+BfwrKIn2wAhoIhcU3C+pYnPMsvgURmRTYxykJ3t7tDrJeGYxqgBsUIoqXoK+FmaQiGU/ZAtSiYtlysSGQWbaSuhSVRdB/2ojltSr+jgx3nRoTUfvdFg+0yOjlPwgBlinacGXhrJHRa6gsdpyp4kTeWTjEs/nYoFd6LKiqb5ReiPx+/eTaPMwDgLFUfiH17jc/g+IgNcaTTCcY8vXu0tDVax1BX8dR0SEuMvIVm0hsnu6ilDEANaA9EVrqdSA9WKavlNrMLu3qgmlMR34UKmHmzn9z7gtuoqJuaOA2rLlMhsSsk3Dr56BeAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxy30zJA9RcjwrZjWZ96M8spw64w1BrRKu/XDWnnf2Y=;
 b=Q21Niqr2xr2mNA/cSegOKOLKXDjSZ7eu5q3IZNn3ZLRKR4HQowq/j1198NBj17M2lJ6fDNog14IE6N+OEA2ND+U6LbaDrrCzws9rz0jkxYJoU9QtYXmQxfLsUISpthEUMFGbC4j+/TaMOz3Kk3kjJB5jby6VZUVKExHTKCgO3l3qOdeAn5bsT9At7z0cNx8VwQEygymYJXkOpnxrd4O+cB/UJ/AFnxlXGGs71WSn40M5lbujugKEhDJeoRH6Ajy8ffSllEVSeB9iSVndDSqzkSU9qYD/0oR/jH0FxHtItidxY7k22spSO9FNLcYLS+PvLv3IKLKJwtJX3Dk5rjnTqA==
Received: from SJ2P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::14)
 by SA3PR12MB7949.namprd12.prod.outlook.com (2603:10b6:806:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 11:30:41 +0000
Received: from SJ5PEPF000001F5.namprd05.prod.outlook.com
 (2603:10b6:a03:5da:cafe::74) by SJ2P220CA0014.outlook.office365.com
 (2603:10b6:a03:5da::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 30
 Jun 2026 11:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F5.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 11:30:41 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 30 Jun
 2026 04:30:20 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 30 Jun
 2026 04:30:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 30
 Jun 2026 04:30:14 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Rongwei Liu <rongweil@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V2 2/3] net/mlx5: LAG, MPESW, Fix missing complete() on devcom error
Date: Tue, 30 Jun 2026 14:29:16 +0300
Message-ID: <20260630112917.698313-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260630112917.698313-1-tariqt@nvidia.com>
References: <20260630112917.698313-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F5:EE_|SA3PR12MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ecc503a-4a31-41a5-7c63-08ded69b043e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|23010399003|36860700016|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	qRRJxekulL403m3oTa55PPk+FIRp+3Vvhg0PxV2Nb1PtiWlI64mO+Sho/cWkKAqBdlwhNeCkUQ5BylXXUs7nqpGH7T9Q4B2Veca2z8Jzws0yX/gjXxDmQ9Z8TMy74bYEtgXC9XdMqQyR8kP18cptayNDXeQruHxTUScGv766vwwxBuAZrrEWQDIORJyCFqn7tEHOX7Im0tWvkO+fhCsdG9x736x+jjuWSVRt2tX84LQVvajf99KGpv8aqzwkaWyIYR/SJM67C7oun4GBMA00P5fPLGxRdlc61yeVM6SZEroSCLlmPZJoFM5r/WvnaoraCT/yV3O4EQck1Q79sKrlNH0JZVYf3XCSZDGYh/goTwF8LJGqtbPcvVzm2fKAjF7R6i/D2QOoPFe3ghoJdLVEjpiyPGE+OrJtC8bhgoBV1iTo7wJFvkILhcrnhkBls3PD4ICQpilnAukCv1ic5B7XxqNDGqYZjzG8zzpTMnOZz6M8knGJvHYl3ewSRXgX5YgMROSSF3yWMTHNKaaSYJa01kRkKlbaVoZogrG0eh554vre1MGc47LiuCA6BfJXR1zwWYK4MwnTjqIYbLH78YLbHMIQCR+hSSTBly2aYkWzEqUsjFjp1rKCILYmOZXQ1v3VaGHVk9bZ02xm74zcmGhP2Rjrm6j7xm6+X5t9w2xfvJLaXzdubaLa99AHQmEvMBqYsFApfblUIbQ7rQ3Z4S0EuA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0eQn/PxRKCoGqGajICF3Cb0ru1wOORqRECL6BtI9S28r15K2mc+dk6ZU7ihsWZlYOMSYXioVleRtw7jr0tN3XKR8HxvXX6kqZmebz2pbFV9jM5TQ6tsi3+OevYNgO9tfeoZQw/Lab8T+A+B+ILFoT99xid+f71FBrpDCkP50Kgby2k5n4WHNjaLpwYbW2EMm+att7VihraPxvLDv5PAFzTH5Nk7Un+QoKLD6XmG6IZ9uG+FA4LtqRw7bpRZPxCSWa+upw+qpAdLeMA6s4i1WICv5Gbefgzg/LHKIZoYaI/eUk7XtZIy+mbvov9q/+OuHO4DBdfecV3/OMziW8t3chlfBSBEflUoz/YlNv5yTAxGHeU8f03UnGmz2lsDQ4kdlHEasZzMmWHNYgg02+GuMzanScM0hONj6r1yNTrGDLg6ZUAB4o/lJLuaxpSrmxien
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:30:41.2259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecc503a-4a31-41a5-7c63-08ded69b043e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7949

From: Shay Drory <shayd@nvidia.com>

mlx5_mpesw_work() returned without calling complete() when
mlx5_lag_get_devcom_comp() returned NULL. A caller that queued the
work and waited on mpesww->comp would block indefinitely.

Funnel the early-return path through a new "complete" label so the
waiter is always woken.

Fixes: b430c1b4f63b ("net/mlx5: Replace global mlx5_intf_lock with HCA devcom component lock")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 50bfb450c71e..abf72026c751 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -194,8 +194,10 @@ static void mlx5_mpesw_work(struct work_struct *work)
 	struct mlx5_lag *ldev = mpesww->lag;
 
 	devcom = mlx5_lag_get_devcom_comp(ldev);
-	if (!devcom)
-		return;
+	if (!devcom) {
+		mpesww->result = -ENODEV;
+		goto complete;
+	}
 
 	mlx5_devcom_comp_lock(devcom);
 	mlx5_mpesw_sd_devcoms_lock(ldev);
@@ -213,6 +215,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 	mutex_unlock(&ldev->lock);
 	mlx5_mpesw_sd_devcoms_unlock(ldev);
 	mlx5_devcom_comp_unlock(devcom);
+complete:
 	complete(&mpesww->comp);
 }
 
-- 
2.44.0

