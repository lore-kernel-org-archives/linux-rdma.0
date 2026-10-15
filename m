Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37AC2FE05C;
	Thu, 15 Oct 2026 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054702; cv=fail; b=UpkYC6MqxZ6XwCQ9Tjgzebt4EPprj+mOeJZWBU5GsRJe9Pe8ODofNf2w1vSIiXOX8jQ1Qk3SkJqcKAJ9Kc4TNUrcjqR6QpYXmtDujF2FCw8zhk4vAv5/+cw/DWV9URXU0zcyZqZrEqutuuNCHodvy9fuR/ZEdtTTmDbnoyA43Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054702; c=relaxed/simple;
	bh=gSg5z42E/V/FH5ehEo2dKsEArxFIHjFqC9N/JSZlTTc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nmuKVCIpOtuX5ZMoQfTPrd2rdPtl02SHrQ7iqV1R5/Rw8AhdVBQ0J6PuesefbmzAL2Ru1nTEPo3tJMLGG9eqWe6XETt47zlaYSrUQ2/ofVAs3A0ksTlVH8eFY5CxbvChPx+jbIFmMC21ObkW4YL28Z42zP0Mg+mJtJ9OPnZiFo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RbH0PQ2G; arc=fail smtp.client-ip=40.93.198.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RbH0PQ2G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZDnT+/bUXqC3yY4izJPbhIjKX8vcOsAmvZnQgbQZZdxrzZQ72/MkcQZmaXIOGU9dlmOSEKctzf0HD+3BDKlH97s9kBP8uJ1lnMjC7KV2a6qDilmWP/u8lcNXiNDhQvIWhx/7EYZn3n5vI1QTsbddZqW2cTEUlq7/u0y3Cy+ys7G4s1ilCbLit8xL4Rt8Vt6A/ugWQpQvVrz6xvXr3pJpjqeRtjG2o+Ecu59x4A7SyPlV14CWy6lFjphpls3DIyU7BvWSnwfNi+3ihJIGUKc96xF0pHuHqozeuKvKFuh+pgmhpvhv2MKzeF4HX1pdzuccfFvvbQEKdYBw/nkI/3VQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WJ880jwdXlLoWGLEG9YmoqoO504ipl3spPVxwKA9oY=;
 b=vAVuQFN2kges866zm7dfQWE2mIrGL/m2eiMXmRwtI3bZY4dQJMi9SyqEmupfjdRa9I+3tdHZt8KCFF/k1vNnYQNT7W4O1tZmfKiv9RHWaXbkzalSRwIbCTJ2RAyz6WtO8I1URoPVuBynSXpJqEsqTGuXbBpUYavuDdHRuLX4kviRHP/s1S08Gp5zjVnX3Fd3ZrIxc79NpzTN/6Ru9KWgw504FGUMUd78+5pBKIDOlvmiNiJQ0cnFwicZF8lKlUmKzwchfwtifmsspejuIU2UQLU58JgN5OiJybRDXq87HyFYbZiEJ5+NRZtheCYn3ygCj7Jx8xOHlMIkcJYkzSoESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WJ880jwdXlLoWGLEG9YmoqoO504ipl3spPVxwKA9oY=;
 b=RbH0PQ2Gg81NYPAVfPf1oo62hfo0vXydRUU4sg5ZqLiK3DC67BF4GvlrACT6EdqClioC5JULtVmZbEYEjhrF9Ohj/l3jmay+tytaEtuiG5LHTsRN+c9BI3WORuMsZ2HfvCcsll+8tcNUDiPtvhctmv56iYZcRgQOfisKPo6D+M0wthcKmwQtMNzzy7FDAjm5jmnqNWlFKaHFOEWu5HMc/dPvZle82FEOHb1Cjf9DNUtL+W1jIPVy3IY0Z1It+lmM1a3eckDsB8ch5jSLhDOcAvdjj9EUGSFLSL2sdtssIbjoYknBfq6nGaXTfT+JrzGtfQl/G3mRp2cQObHUJIrPLw==
Received: from CH5PR05CA0003.namprd05.prod.outlook.com (2603:10b6:610:1f0::16)
 by SA1PR12MB6800.namprd12.prod.outlook.com (2603:10b6:806:25c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 08:58:15 +0000
Received: from CH3PEPF0002457C.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::49) by CH5PR05CA0003.outlook.office365.com
 (2603:10b6:610:1f0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 08:58:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF0002457C.mail.protection.outlook.com (10.167.252.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 08:58:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 01:57:57 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 01:57:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 15 Oct 2026 01:57:53 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
Date: Thu, 15 Oct 2026 11:57:44 +0300
Message-ID: <20261015085744.1109107-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457C:EE_|SA1PR12MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: ab2ef4d4-1bb9-4c9b-e482-08df2a9a72a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|23010399003|10067099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hfkWYPr7ZQ6Wt4JIX8YP2cCZ1urYdLuwOmSFMk27en2AoekhARiD6oG4VjUHrFVDccp+S8NvcfOipDMWNQ9dbXSds3fwSwfgMFcjG+Lb7EDrUwD0Y83zXtOx2My1NACc3qaA+dYTQIrNzMhRp2XJ1CxdEHxdONCdmA6e8Bmau/lhpbOAsfEC4Fob1Cdxad0h429eLSDpMTxZWnl/aLnzlotf7G+ReC99vAPLEDPrqQyoxLzZrX03A9sI8Mp8ZNV6PS4LxIhIzGT4RLpP4uWPeXhGBrydwUJ6pnrx9yGsRS8fFOEJRT4ztfNfMoibTFD/cnmNi4iJ+3CwxisMPpVD+wcM5dvdWtrpWsUsGCd1oLk9j/jGbW38AiEh6vvt32g+xMhJndCF0zi1piFAVBmMK1lxeNodtI2FKlAvr1OF97T82DYNSOMMBA1tcY02GkfJCayQpN38+Zn7HT8sWtC7+Qjt4tuPMyczU0T78jUv6XlWFP70KXz7Xg3xoWVRCtgdKSQ7MQIk7xPuBKOOaiX4y/SyafTI13GI0DmZJElW/NtEI3Y4yCr5uLVqZa8tHq1Qz5fkJGuPRBYlbzy25rqeVGEGbNxq5l+6YXjVwIaaTrzMzjEhAMPK9hPJAUP0KhM+5anaPPFVEIm4KTSyHOm0ZBDtQPF1EHNEFU0cJjEXNbpL+V6EFyd4nMENFpIEvt8Dgu71eSwoxU1ExHs2n7l04w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(23010399003)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9ZihcY0RC7Sdp5HhA8sTmo34YqGZyM4uimqnXoJrz2TGbFb1BLKXGwHN5DkQ0OdtBEis4a9KuiazbfcJO+NMSFn4XR5VAn1v7i3J0cdb9LxeAjqCPv0FKn2SjCzT5bhlZ+7lZ2y8ib9yE8jWIOV7KimjPt4X3a/oCDg4x36vDS4btYWnEqTxSAPn7apzPycrf2J1KCboEzl5d27D0to+u4CTApHeLo4fQ/XIuD3QdKaJYzjbNbnhZf6Bz1BQOtkQ/EZR1dHJWzN14YbUkENEa1I2bKJEUPpj/rYWI7xE6bpZSzi2gWC34lRgLhyEILqwE5iwt3krLYMyMrs7TTbKB6eSkN0FCM7I5bY3BZ6mTJ0CH+pXQhAeZAJ7CYL6ST9BNsGk3iYvpzzU8zovRNiwIjVfMZH+6iTWGqgnolGoFYInedZD2XUr0NniWoLfbl4X
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 08:58:14.5480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2ef4d4-1bb9-4c9b-e482-08df2a9a72a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6800

From: Shay Drory <shayd@nvidia.com>

mlx5e_sqs2vport_stop() frees each rep_sq and its per-peer send-to-vport
rules (rep_sq->sq_peer) while holding only the uplink's priv->state_lock
(it runs from the ndo_stop -> mlx5e_deactivate_priv_channels ->
mlx5e_rep_deactivate_channels path).

The same rep_sq->sq_peer entries are inserted and erased by the devcom
ESW_OFFLOADS PAIR/UNPAIR handler (mlx5e_vport_rep_event_pair/unpair),
which runs under the devcom component write semaphore and takes no
state_lock. The two lock sets are disjoint, so closing the uplink of one
eswitch can run concurrently with a pairing/unpairing event driven by
the peer eswitch, both mutating the same rep's vport_sqs_list / sq_peer.
This is a use-after-free: one side frees rep_sq / sq_peer while the
other walks the list or inserts/erases the xarray.

The add side (mlx5e_sqs2vport_start) already guards the peer-rule work
with mlx5_devcom_for_each_peer_begin(), i.e. the devcom read semaphore,
which excludes the write-side event. The stop side did not. Take the
same read side around the sq_peer teardown so it cannot race the event
handler.

Lock ordering is preserved: like the start path, stop already holds
state_lock and then takes the devcom semaphore (state_lock ->
comp->sem); the event handler takes comp->sem and never state_lock, so
there is no inversion.

Fixes: ed7a8fe71836 ("net/mlx5e: rep, store send to vport rules per peer")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 88a170e40bd9..7211faaffd8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -629,8 +629,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	bool devcom_locked;
 
+	devcom_locked = mlx5_devcom_for_each_peer_begin(esw->devcom);
 	mlx5e_sqs2vport_stop(esw, rep);
+	if (devcom_locked)
+		mlx5_devcom_for_each_peer_end(esw->devcom);
 }
 
 static int

base-commit: 513444cc62e231a11c9b15ea88de0890da9b2b4f
-- 
2.44.0

