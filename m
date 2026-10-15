Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764DC4FDA68;
	Thu, 15 Oct 2026 11:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064483; cv=fail; b=V09iKmSj5Htin/rK6dOfnaVQNMFdxD8/p9bOHnz7FiPBI1kHuTUF49FwmVGhtm1Nou40KL0fWCDtxNCQJ6lKZaONOxNoriJbGmQDy0rCH89Nmr6JMsWyO6mADBluNGNR+b8uLAC51kbaYVbBRwOkM+HFS66SWry9aoQWYI0wCuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064483; c=relaxed/simple;
	bh=sZpAWTPihBNjQ7wyXUMxfvwnryXQSWWIHmVIoHhtwBU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=Y0mLFVy1rxruTn23iwf3MZ2T1ERXlAUy078ifhGApGc+881/tPm2MRRXr19wllYwBz0/E9Yp85O+s4no9IEhM0vDRmiXtpT/vejOBk/pauYtYptZ2IEXFAWftV9ZGsytcQ35iFYZW9GUsHa4OYN0otVGHsvexT14FVOGH7S79kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z/L3T68W; arc=fail smtp.client-ip=40.107.200.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z/L3T68W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1oYHffVMrdxSHpxfouvCk1hLIa1AsOJ/u5jigo84EIo8h4o/CQ54iQxRaq43S0SRK3GyLwe2XhWIRCWhtUi0ElUOTTjpyT6iJppw3yTThxQawijyG3obJElRy6iIA7yZB8P237Wg44rv8lqkdzkXbYExGwr/KldUmwGOdj4GmQhQ2O77TRyep86zT19PBy96WipvYZbkYvHNPyiJ7H4++BsMz1etXUe2j6s3/aSp3wbuY6Z76UXAk5Hd/3vUMc60LYpo2sdOyTVBuOMC1DSvXR8HM5XS5t1edkCt6FFzW3t4DMMydV8VuJZaMPZkHsw6PiC5/D/1xRD+AlJnlpQ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XXvt1mHvGxoCUiX6+QYasEY30c1dpL6YH0tKP8xtLs=;
 b=U24TPvDrreO97d2xKS+ZhVB1e9HVM6yUxVK9KSOm76ZXZQNHZZ7jubihbwwqJRW09f6/gZLu0hdw0rOqPqAXLqNLe0jgE86mLBtpz22yKP9h4t1E/E6L3vmePe5XKA3AI06oZ6TCvtwN2gAsQWMAFZ6Tdouc5a1LOSfagEv16qNEEq1r0iiB02SZPbYH6oMQeqJm/vnfeEeJNonpaZm8flijk9sUDJpg+UvEygVGMoh4JQPv5ehin5Nzj3Sl2+62MneDyCl4Cg4lBuDUeSq/Om302p0mcqBLqUKGyKgaQozk3FlT9rD/FRykXqpodhmLfG6p2au42AlJeddkFvfsRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XXvt1mHvGxoCUiX6+QYasEY30c1dpL6YH0tKP8xtLs=;
 b=Z/L3T68WBOTWan0qc5/T3GLoQEeH1YM6t6bKr3xJGC6gqxt4QpfN0Ts1Ir79qpHwij3o+ibKkPLg4nqpqaCI8lKt/1C0HEcQJmqY1RqXsO2ekVwk0xfa1fTvs0xdbdwIvzC9vyIlbU+/fgZraUfOfk7BaZHQ9PSgaNMr0cH7nnHZoLTkz4pr+yqSJxMZV20jFxfDe2zNTfhtHpeunG1j4OEk3rG4OB79kcD9dJe3Ffovk57V4m9FFCOrHf+j+hIAKUCl6XqoM+/ugodYqNGnu4kZTK8ltFetexBYu3B/ovth52WnIEUHl+B++Y+fspiapngsrTy3RQkDAt5CMXcLsg==
Received: from BN0PR04CA0033.namprd04.prod.outlook.com (2603:10b6:408:e8::8)
 by CH3PR12MB8970.namprd12.prod.outlook.com (2603:10b6:610:176::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 15 Oct
 2026 11:41:09 +0000
Received: from MN7PEPF0000014D.namprd04.prod.outlook.com
 (2603:10b6:408:e8:cafe::41) by BN0PR04CA0033.outlook.office365.com
 (2603:10b6:408:e8::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 11:41:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN7PEPF0000014D.mail.protection.outlook.com (10.167.254.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 11:41:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 04:40:48 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 04:40:48 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 15
 Oct 2026 04:40:45 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Thu, 15 Oct 2026 14:40:38 +0300
Subject: [PATCH rdma-next] RDMA/mlx5: Add missing error flow in
 mlx5_ib_set_vport_rep
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261015-rep-netdev-leak-v1-1-5110013806ae@nvidia.com>
X-B4-Tracking: v=1; b=H4sIALW70GoC/x2MwQqDMBAFf0X27IKJtkV/RTwkzWu7qFE2IoL47
 w0eB2bmpAQVJOqKkxS7JFliBlMW9P65+AVLyEy2sk9TmQcrVo7YAnae4EZu66Y2wb6s955ytSo
 +ctzHnjTMLtvHRsN1/QFduAOfbAAAAA==
X-Change-ID: 20261015-rep-netdev-leak-93431d272bbb
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Tariq
 Toukan" <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Michael Guralnik
	<michaelgur@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792064445; l=2456;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=wDV18YZsTMwNB5PqCjwTdEUmL7BobDQZuPfeoWk580Y=;
 b=XGDRs3T1TkvVxPNEGoAYNQ/K0z3B9zsx/rRbKfWfPZUGORviGd0v1bdeW4weHr4qUra3S2qkr
 d3WaHtxjiGgDerDAXRxYXwlxQAZ3c43XuXkApRJsnicZewzFoeiKdQN
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014D:EE_|CH3PR12MB8970:EE_
X-MS-Office365-Filtering-Correlation-Id: e43ef116-ce45-44c8-5f48-08df2ab134b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|10067099003|18002099003|6133799003|11063799006|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	TGAOwPTp6pnWLfQFygPT0x+Hd3vyPagTFZMAbZWzvqykH07l955VEJb1jIxKRBx+WtlC/73AmxIXIOGfd2CW8NihecKHG7ddyEsiAPgiqJmkAYquJ3wTeqKnL/cQsXRjaPMbxRV2jJCcFGeYgyCXn+p6L59yOJXdjtikg9pzIUQi6L00l9ToAiIn97wPDLEsEJmLmsVi8OseNz2/57o3OThXfyhH1X4IBz0M4JplnDdzFpjSoZoUYv2MEeeUO7XIqAi94E71mlt73oKPVM61RdsFH7goKIcCO0B4F1HS/HpOHgTFZiiTYkL7tbVxBJxxtU6Q4yoRPQ8F9h7Se2RlKw0kZ+eG62LYGCvDYPfVpVgHu3p7qyWIhAo25mGmE61sOAGYAjGYW4liDS4dGu0JyUTo8nXwFhqfP9NrPzEGrftd/+zs0ADTcIkINkHXHlxoiK3LHIglVXxuumWNcBqh6u/hCh99/yyeBNgw+uWlYh9pTQJx/7hVdVVmdLQ4TlYDpM4fBEhNtyoeLjlnrxFo0kOLvcrYcRiikl9czUwgVaWxYjS5qeqefiGURww2y2xj6Gug1eMkWfWZfeS36d73PdvE/kcJDU2GyUeO1uhWNJgLr5GaVG8f/1e63Vg1MTv/UEAV6TM1lVOZVTzXSdCb0w2MJM8qaQHP394/li/xK4ebO3rDAO0ahqap47xMK55EOPQQssI+BMY7fwfVkLS+Xw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(10067099003)(18002099003)(6133799003)(11063799006)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fLuqULVpnVZhWhonHKec8v1Q0JnoAFAu/rRRZpdNs5uaxBJtEkx8zz9ihIT80Goeawc2tGeiJ1duxPlzl0Rtp77OGC5kfhMfF5iDxFFF9kkhnVNCAgWafyBf3kiRwsH9SBJ/uU0mRd2QZkbuZ/cSWjs32JdRU3ScAQXhhA+PHsUS6Ou7x3IS+0gu/05pq4dnbI16yKdO3ZqoZYOpgM/GD75rhYPlKq98jLkk4tWvOAw9Tjf+Vftl01eclTMJP2BGnaAotlE/hElam9eDXUGvQVA7HmYxtEa5IG+NAceJihDSgsPnLTRGwUZZ0J7722MM4PPZovOVeRZv6PeQp/yEmkMWmHZ64jabB426Mv2DdT9nz2aLG6ROdT2zp3s7WlH5Ul9sBHEqOscmKJ23UtzA5XJNQhBj5JnmAYFZCDHT4KduAkpuvQeKh1fjh+bBNeup
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:41:09.0057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e43ef116-ce45-44c8-5f48-08df2ab134b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8970

From: Shay Drory <shayd@nvidia.com>

mlx5_ib_set_vport_rep() attaches the representor netdev to the IB
device, which takes a netdev reference, and then adds the LAG demux
rule. If mlx5_lag_demux_rule_add() fails, the error is returned
without detaching the netdev. The eswitch does not call unload() for a
representor whose load() failed, so the reference is never dropped and
a later unregister_netdevice() of the representor waits forever while
holding the eswitch representors lock.

Similarly, if ib_device_set_netdev() fails, the rep pointers assigned at
the start of the function are left dangling.

Undo the netdev attach and clear the rep pointers on failure.

Fixes: d6c9b4de8109 ("{net/RDMA}/mlx5: Add LAG demux table API and vport demux rules")
Fixes: 8d159eb2117b ("RDMA/mlx5: Use IB set_netdev and get_netdev functions")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 65d8767d1830c630f5aa2a2a693110e2c9bc9e48..9cbd27063ba8ff780446d9be2801012492383734 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -28,7 +28,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 
 	ret = ib_device_set_netdev(&ibdev->ib_dev, ndev, vport_index + 1);
 	if (ret)
-		return ret;
+		goto err_set_netdev;
 
 	/* Only Vports that are not native to the LAG master eswitch need to add
 	 * demux rule.
@@ -36,7 +36,18 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 	if (mlx5_eswitch_get_total_vports(dev) > vport_index)
 		return 0;
 
-	return mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
+	ret = mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
+	if (ret)
+		goto err_demux;
+
+	return 0;
+
+err_demux:
+	ib_device_set_netdev(&ibdev->ib_dev, NULL, vport_index + 1);
+err_set_netdev:
+	rep->rep_data[REP_IB].priv = NULL;
+	ibdev->port[vport_index].rep = NULL;
+	return ret;
 }
 
 static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev);

---
base-commit: 978361dd2ccff357d4fe6aac6ce057d1bfae8312
change-id: 20261015-rep-netdev-leak-93431d272bbb

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

