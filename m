Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011061.outbound.protection.outlook.com [40.93.194.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0191B274B53;
	Sun,  6 Sep 2026 07:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678900; cv=fail; b=tpclbUfr8oiOWooqNzAL23QYxab8mMRG3Q19QIDAVoK0us6fKxM7m0t+d+pMWtIw4o8I4LOiMaeGZBqALr6prE+efcIyDZMES+/cj5yJGOJcyiusesRs9PMr5wXAuPt5hZVErErhwDeXLEs5PBENW5ho+TR6mTFj0x7B8KgfdBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678900; c=relaxed/simple;
	bh=ylClRsC5Sp3zN8Xd30lUqPW5XbERBmGZJNIlTP2CrQM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GgmWy7ZXMwDEcgSgHgFx1XyEmh+8rbJJGIFYLZ85R5wMgtiVFRepzQU4WYuqNHEsRcM1ZnLzG0vTI4YyUgSLtdvzfuw/PmcAMUK9L2VGGF22UIwQsU9t5a3zoRInSiNl1EAZS0+prV6QsjCrG8r2wy0UJc+f9wppr2oepUs7g/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B6exEYPI; arc=fail smtp.client-ip=40.93.194.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B6exEYPI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y6r1Toj0+0Ui5L5XLYNWvkIHgV0f22DTb5KIXims4zepsF5m1VUACBVxtAhBUxnUdxl9zib7gx8mIJGxCcTBRrePnKqlWiI2hLSyClx27iNyj1HGcXge+Yd2g/82JzlY35AibaxcSV+JQwHtpRBCL4p6dCb+3sb0p6eOEj/QURj2bdrBjrjBAVQaa2ljTit8NDmpeWz9l6sb55xyXuvdeD4KP8+ltbgJosSQVFHi83kFqABbW8IRyZHC52KyCU/iqv12eCTiO2UTqQgLMZVEMK0pWmq0LAFf+DhlnuYZ7k8b8btANKdRtg3ejfJh7xWMH+kw4z4bMxNFMwDalfMCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60O3CEEx81ew4Yc1qsDRTpiNdTdgDRQPRJY4e24VZtw=;
 b=NWfedMiL14LVuU19V0HvH3dFB1QRbJfTRQJHHHtlgoyZMxqZPneicBwTrUR5Q+OHLshes2k6m2QQ6KYgRGoiSHDHnulCfSQ+figvqt1K8V1aTW+P4y9U7r2HrKgWQz6b5OqAayHlEs2ajyE5kZQw0abDulJSb/LX8KUSOOWkkvIWFD+/KF5wKA/lnpivqJ9DeurZS7M1RJN9wMPomBHPN20BjMiQTdzhngjquZ6hr1ZSeWEyZydv4aoJL/LQwGKc2iQI+M8vsk+2U+BL/ZF0UliU76m8bY/ADU3ywY3iYYp+UFLRLQp6VrvGgmgCAPPsIoG+JHuQeBTFB9hhLlEmTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60O3CEEx81ew4Yc1qsDRTpiNdTdgDRQPRJY4e24VZtw=;
 b=B6exEYPIDy838aJjfMn5Aqknc5LAIfJQ/5CcI9svjciwvUGqDMe56Y61uzBDkc5hVubfOZlypfgJm20N0GeNfcTXBt2YdMfXnufq13qtCurxrNNdLJoEf+9eVt13QYdqEItEGk6ROOinC++MhdSaDFzubkCe1aIySvw4SBh7L4olL6irBD+WGgIa5F1hOBSk9knFCot9cZh4EnpoDt4ne0cLoxYRfdTLBgLYu8R3P8JqgsKsiAUql+7yiXNexEhItsxVV7r9exEMVwFaM4u49A67igEVPtPsu3XByArmYKK31SpFSC/O42uROuEOKf7qc5cxiyqRSYFm1LPCxwAQqg==
Received: from DM6PR02CA0111.namprd02.prod.outlook.com (2603:10b6:5:1b4::13)
 by SJ0PR12MB7474.namprd12.prod.outlook.com (2603:10b6:a03:48d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Sun, 6 Sep
 2026 07:14:54 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::36) by DM6PR02CA0111.outlook.office365.com
 (2603:10b6:5:1b4::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Sun, 6
 Sep 2026 07:14:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Sun, 6 Sep 2026 07:14:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:34 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sun, 6 Sep
 2026 00:14:28 -0700
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
Subject: [PATCH net V2 2/4] net/mlx5: devcom, Base component size on linked devices
Date: Sun, 6 Sep 2026 10:13:30 +0300
Message-ID: <20260906071332.3759199-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260906071332.3759199-1-tariqt@nvidia.com>
References: <20260906071332.3759199-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|SJ0PR12MB7474:EE_
X-MS-Office365-Filtering-Correlation-Id: 39294668-560a-4559-bcdd-08df0be68b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|36860700016|1800799024|82310400026|376014|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	6xKsY92Klj21g9H6B3kclVfAdPIokrwsH93aHWuqdG0HISdfKl7KEMDDDGkA8ELd+gkTEEjapfx/NdQum1WQekeUcYGZO8tbOAUPc3bbRRkzgnjKJ0BxyqqsJ9OusrF5C7oKkmkMCUw2Dw+FOOYDrwKxKWECZ/qGyGs7LXAWE/DEumkBSZZaOfgLRAEXVpeC3MORQj0FgkXanXy1CuGMGlTHnPEx92xFlKK2C5oqqB9EceXsmumCjCgXVDjaRGUP3eUpsaaVSFlvo9QLk27b451qKXp43pBL7vS5ZXSBHJvmjeEBMH+CTOVc+svJpp35G5jrImKdzE6DsxsMLDgx/61uHedczlYnC5Pwg9Dr+jcf3UsU/21wAhQoz/HNaMfyvzLz8RHxfqymG5WvlGeohGt7SpQ0bwk6UjqERitU5qKQPFv71i5f0sNttrX0u+8lZ6lqzYwKuAU/zVwrB0XzpdCHCZwJFnRjlXrQw877CMmFeKKruccTgYasCv4aoOtSzPPqjjENYPoHBb23FqAZzv1S8aNGsmGo3zlwu8ZWNKVv6Sf5i+rh/S519YlwUQsv2UPY6VL1i3SljkUAIArMvxchW86tdEpVdipU7BaSPPoeN64IPg4+IB9hPPZ7cAUTZVFIBUBg/VydXxdTH8my0a2G4uqP6Vdgn3D9dSu+xzcqhUHoJtIVlCf91/1YEL0BS0HXCx2FxZZpaDtbeYU3Nw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(36860700016)(1800799024)(82310400026)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KviJNB7evNulrQWzL3yUFDmnzoC9aIEPzOQAaxwv/BdqWcLAv5nYEzqgrewbgG5FR0W8sgXDgNLh6WMA6Bx1CI8kTNryf9OtgbS4wf/4vO1QlJ8StcTDuG0dnfX5XAx+0xOE6p3i9LSlGgq7Vq7SeBmtTsjOK7VxFROhUIYcgSQ60QrVOcT5QVK8o4c6oupuvKBBTPPIBoj5ON9GWNaJaH2/DiuYfB+ymVWEvfzXZxUC+SfK/r7waTjzZ7lZSjfeinXmqV9z23lv2alYM2bWsEV4FxoNsj+r+wnEk9lASluoHb/+OELpuf/rTdg2YNrJKLqlKiwSt++rSZqOSxArevtOZCMUsKNP1eCYwUzKcrbXdzBgA5PdoMprTs3AHXxZiZ12J+DbjA4mTmkTAmr4XnZbQGowr8nxDIxuEONI762V+Djphulcyd8n69SWSTjz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 07:14:51.4231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39294668-560a-4559-bcdd-08df0be68b31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7474

From: Shay Drory <shayd@nvidia.com>

mlx5_devcom_comp_get_size() returns the component's kref count. That
kref is bumped in mlx5_devcom_register_component() under comp_list_lock,
before the comp_dev is linked onto comp_dev_list_head under comp->sem.
The event broadcast (mlx5_devcom_locked_send_event()) walks that list.

Hence, a caller can read the expected size, but send_event won't be sent
to all peers. In the SD group registration path, this lets a member
broadcast its role-election event over an incomplete list, electing a
primary that never completes the group, is never marked ready, and
leaves the group with a stale primary.

Track the number of linked comp_devs in a dedicated counter, maintained
under comp->sem together with the list add/remove, and return it from
mlx5_devcom_comp_get_size().

Fixes: 9bb1ac80738a ("net/mlx5: devcom, Add component size getter")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 64f92427602d..75855481522b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -37,6 +37,7 @@ struct mlx5_devcom_comp {
 	struct mlx5_devcom_key key;
 	mlx5_devcom_event_handler_t handler;
 	struct kref ref;
+	int nr_devs;
 	bool ready;
 	struct rw_semaphore sem;
 	struct lock_class_key lock_key;
@@ -170,6 +171,7 @@ devcom_alloc_comp_dev(struct mlx5_devcom_dev *devc,
 
 	down_write(&comp->sem);
 	list_add_tail(&devcom->list, &comp->comp_dev_list_head);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs + 1);
 	up_write(&comp->sem);
 
 	return devcom;
@@ -182,6 +184,7 @@ devcom_free_comp_dev(struct mlx5_devcom_comp_dev *devcom)
 
 	down_write(&comp->sem);
 	list_del(&devcom->list);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
 	up_write(&comp->sem);
 
 	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
@@ -284,7 +287,7 @@ int mlx5_devcom_comp_get_size(struct mlx5_devcom_comp_dev *devcom)
 {
 	struct mlx5_devcom_comp *comp = devcom->comp;
 
-	return kref_read(&comp->ref);
+	return READ_ONCE(comp->nr_devs);
 }
 
 int mlx5_devcom_locked_send_event(struct mlx5_devcom_comp_dev *devcom,
-- 
2.44.0

