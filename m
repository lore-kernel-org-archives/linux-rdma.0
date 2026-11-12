Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471245;
	b=xB046OIEwMQOC/xBzg5wTkfi8uktAFP6OxzTQZpUtAfmnJx41FbSeEsh17UPBE/6x2IA
	 zv9tNOZ2pbKgqnxFI32PEO8iKZ4d/i/D0HQ8PksDxoGLUHLI5Rv3u4fquz8GNuURgP3MH
	 0gnS9EznNpw7SPSEBUZAnwCfKZnPU2J11V2jWxdfQfQrTwu8J5lQBiSQ1+dv6UaSLJju2
	 DYCrH4m/8+LFANoYQZZwNBlQncKbqaS7L6YNBHdt0thx/hm2KAZWPrp8T+hmsWTj/CJD2
	 Mave7faq34dk41gQ5CAjArOB7AbccXGdbU8fQwsh6IwgqPoJ+8qb9MA0jiEEN4bDM/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471245;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DMHEYgOdqvRoaIoBzq+1xGsjU8NWukhmEboUfrer25o=;
	b=gNnkfk8RK3Nkqs46GGyZm5dFTl46CCmKdnI8g+Htwq+/uDf2odKSNJRjiAODHOJ3FquZ
	 9gCH2hJuTdlpjaizeZkOIgvJMzd4lyYbSdglt6kdH7fvenHXTGUSFNNhm0M1rdS/Pf1UP
	 nivrB/QywAeK2tIUjMlYH8mfHB6aOOmwU98kBtsXSp+TAIRhJLC5+5MnR8MdAYELn54oH
	 Wh8GDE+eSMe8EZ5a9UK8nt2vcd/Ov1LscEVaSAgf2QvPya8MEdIqQRx3WuYhId5bfFtrX
	 I7PvqrEqjamerELcx1HwmJb3FRWv6bFwqA90e/dOU4mntsbLxrYkFPKKy2enNe8Fx4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EKXzdu5L;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.50
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012050.outbound.protection.outlook.com [52.101.48.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA805606A31C;
	Thu, 12 Nov 2026 08:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA805606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EKXzdu5L
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofg71QExNwuTfkFvp70A8/PMtK/UwuqvNaVVS3xTE3mR3dTYG+Ru8Z38tRtVQ4OpqcW2TjwtmyJDhYJl9T8FSY9maTL6jqayBGutC53Vsk1sXUTf0pgz+2HIwRrSm7WTuMgey5T+x8khFbF0D9NyNna3NthAgshYsgwOq97vvB/X0uR+/pb7apJG1/807/gWvKGj+AAk4BNZ3DmrHebOYhzKCHwwqSOMHeHra8q9D2Ql5+LPW5/8wNosxjvE9TJa8ds1CVqcKhnODI70spgIY2J9jhDbE05PuKBLL144C2uF3we/1bAxK9xtEmAOzjMhZhasvTfupWGhvZyZ+ZZQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMHEYgOdqvRoaIoBzq+1xGsjU8NWukhmEboUfrer25o=;
 b=H9wookEFzr9kc7fQcJAoq2ZMCsOK6XkFxuyG6uWN2yyy/LqF9iWyuTWhfAOH3oEraBt3OMt2nHaIVlu6R1bKN3Rs7Oay8wOFDQqkf963vj5yfY74PFFrsgqhUmcYdc8fM04omrgytiyKVcAyPc3Zrujvh8LA/Qxyhd2WdIfZ2M8UNLv25p8waBPyDTUf/OZ+tHmTMq5Gp5BnRnnGIFEofT/2b0FUgBY9eXqPXWBBphrEAf1oZLcYeYg26aVhOTkXZCMUHj9nPN6gtYMN5d6o5J0uAZ5m98LKqFc3EyLc6QyxJJUGLdMiL9n1xroTcAeIGem1IzR9tKh1Uirh/E/r6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMHEYgOdqvRoaIoBzq+1xGsjU8NWukhmEboUfrer25o=;
 b=EKXzdu5LpoExvnM/VjJ8N1BdV+skY3wKXolljtNBxHBgBBBmHf7orAdt4xme9DW6Mg3ExTmOUUahh6DHyrsCJj+VzglkFUvArruRMitq9ozJxYMVgEHsse+u8wXQEijiMR+BK10+XbaiGaxC2v/L8+czeXJxy/ncIn/mrodl//hcRndUCUae/cPHw4wtyvq6pBTEX/uqvfK7jObul/rOhaMH7194JqtcaJNFN24O1BSws10C6jXwftCItmwVL0O9GsIC2V+E8g3U++pnh7s+SsUKuS+uKMmAa37WfNDIJkiev32ifhi2MJ0FhSuO48wLHxo6Vnzu+qUThoHpOtY1PA==
Received: from MW4PR04CA0086.namprd04.prod.outlook.com (2603:10b6:303:6b::31)
 by CH3PR12MB8212.namprd12.prod.outlook.com (2603:10b6:610:120::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 08:13:58 +0000
Received: from CO1PEPF0001885E.namprd02.prod.outlook.com
 (2603:10b6:303:6b:cafe::27) by MW4PR04CA0086.outlook.office365.com
 (2603:10b6:303:6b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:13:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF0001885E.mail.protection.outlook.com (10.167.249.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 00:13:41 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 00:13:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 12
 Nov 2026 00:13:34 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Johan Hovold
	<johan@kernel.org>
CC: <driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Amir Tzin
	<amirtz@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>, Przemek Kitszel
	<przemyslaw.kitszel@intel.com>, Jacob Keller <jacob.e.keller@intel.com>, "Gal
 Pressman" <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky
	<leonro@nvidia.com>
Subject: [PATCH V3] driver core: auxiliary bus: Fix IRQ sysfs directory cleanup
Date: Thu, 12 Nov 2026 10:13:19 +0200
Message-ID: <20261112081319.3466442-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF0001885E:EE_|CH3PR12MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 051540f3-d025-4b69-324e-08df4094e6da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|36860700016|82310400026|10067099003|11063799006|260925021311599003|260925022911599003|260925021911599003|56012099006|261022105027099003|261028144727099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Mwij12s21BcR7ckIZYwcvqfDkN45KeybY6C60ATb22Ipf8i4AAw96AQWBtf0X0qqLyAxizy7er3noCoqMoKXRd34rib+M3TWdUe7JVdhqdzXwFWQqkomVSxpo+n8eVnumh7A4jJc6edd/qnrK9pTb2KPivAd9GZJDlqZ5/YZOGv99iA/e0WMwp+wg/SzDinw7mKX+kB+tzhd2SvdwMNuUPIWwFnHyz/Yp7BLzbrAWV8ot6ObWstZn80iZc7cWoZCQ05Xo9jeUZWnGYsHS4xMmQmP5R2BKB/JXygtDXt71VG2XKWXMMZNuhIJG94QI6IcIItlocr3tk99n98y5C6A60QlYIKsE68O+BmL4C3OCwAjMq18+tuNepbOvjVWGFMNtKVHBiWnWHbx5hD1Qtt+Q1SrD8C7Bk2T3VL9ZwkQN7cFg/i6TaZ0QTg2nWMhG+OmPOTVRrnmz8EmBc+N+CZa1jyY6/+HBINX3f5xdHSyXFCfk9619V4WTBwg1dVDTqq8fBJda86pT5D8uKOqJOZwBeMrFB9Z4gXVK/EI8m+qRnz00q0dxZftOF0pPoL6sWXQB87fcjDRWAnlgRYug8U5Y81DDS04mnIzHIpMUg4kqQafUedhHXAaOXylkXzUG0lD13/d6/PKhW9RiLZUyFUENpn8dIDsl3RzMtNeStpjA/JOtDimRi/euK75tp4nloWnK9AyS3ESpSeYD9W+7E40LA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(36860700016)(82310400026)(10067099003)(11063799006)(260925021311599003)(260925022911599003)(260925021911599003)(56012099006)(261022105027099003)(261028144727099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nNW4Q1Ggb6u+yPXoOtOWvwFwSnhPtIAO8GlzlgU69itvb4Aj643nX3i3dufCmmglZwsaat45by8LYjvPPs3JF4MTN3VmrxGo9tSBqqJPbFzkh/e6gQgFtzg70aBlNlHS9/xbSQeSodUKqB6+SslILLFyJMk/aHpl4uSivBD89YLoT6OxpV/QNI9ooLoYuy/rS4THRlB4VVcPnGgd27FhuF2ACEDhiKH19A+ssT+zp8szdPB8IxjtSSBqMrnZnZNgqnw0jM1o1HA46pgmDXmE0AiBcrk2gZioW+uvmW3OLvwRV04cVWgznAwpyMD0biOVcw0y5Sgb3LHN4iPuCgMvdRnuyYIaHV6/yrtAqtrLapW3jGj3KQDFQsmPPIhmHJaAUj7PIqQqrRSJ87muldOn3ukqhTG9kPFy6nXdRYfleRwhvi1pdBZPM8W4VylWYJPz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:58.1224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 051540f3-d025-4b69-324e-08df4094e6da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001885E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8212

From: Amir Tzin <amirtz@nvidia.com>

In case an auxiliary device with IRQs directory is unbound, the
directory is released, but auxdev->sysfs.irq_dir_exists remains true.
This leads to a failure recreating the directory on bind.

[] mlx5_core.sf mlx5_core.sf.2: mlx5_irq_affinity_request:167:(pid 1939):
   Failed to create sysfs entry for irq 56, ret = -2
[] mlx5_core.sf mlx5_core.sf.2: mlx5_eq_table_create:1195:(pid 1939):
   Failed to create async EQs
[] mlx5_core.sf mlx5_core.sf.2: mlx5_load:1362:(pid 1939):
   Failed to create EQs

The irqs directory state is described by three pieces: the sysfs group,
the irq_dir_exists flag and the irqs xarray. Currently, only the sysfs
group removal is managed by the devres API, and on unbind the group is
removed while the flag and xarray are left intact. Thus, a subsequent
bind sees irq_dir_exists still set and skips recreating the directory.

Manage all three under a single release function passed to
devm_add_action_or_reset(), so the whole directory state is created and
destroyed as a unit.

Fixes: a808878308a8 ("driver core: auxiliary bus: show auxiliary device IRQs")
Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/base/auxiliary_sysfs.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

V3:
- New approach.
- Retitle, and add Danilo's Suggested-by.
- Drop Jacob's Reviewed-by, as the approach changed.

V2:
https://lore.kernel.org/all/20260219210435.1769394-1-tariqt@nvidia.com/

V1:
https://lore.kernel.org/all/1761200367-922346-1-git-send-email-tariqt@nvidia.com/

diff --git a/drivers/base/auxiliary_sysfs.c b/drivers/base/auxiliary_sysfs.c
index dea7f46f7dd0..656ba057dc98 100644
--- a/drivers/base/auxiliary_sysfs.c
+++ b/drivers/base/auxiliary_sysfs.c
@@ -22,21 +22,32 @@ static const struct attribute_group auxiliary_irqs_group = {
 	.attrs = auxiliary_irq_attrs,
 };
 
+static void auxiliary_irq_dir_release(void *data)
+{
+	struct auxiliary_device *auxdev = data;
+
+	xa_destroy(&auxdev->sysfs.irqs);
+	auxdev->sysfs.irq_dir_exists = false;
+	sysfs_remove_group(&auxdev->dev.kobj, &auxiliary_irqs_group);
+}
+
 static int auxiliary_irq_dir_prepare(struct auxiliary_device *auxdev)
 {
-	int ret = 0;
+	int ret;
 
 	guard(mutex)(&auxdev->sysfs.lock);
 	if (auxdev->sysfs.irq_dir_exists)
 		return 0;
 
-	ret = devm_device_add_group(&auxdev->dev, &auxiliary_irqs_group);
+	ret = sysfs_create_group(&auxdev->dev.kobj, &auxiliary_irqs_group);
 	if (ret)
 		return ret;
 
 	auxdev->sysfs.irq_dir_exists = true;
 	xa_init(&auxdev->sysfs.irqs);
-	return 0;
+
+	return devm_add_action_or_reset(&auxdev->dev,
+					auxiliary_irq_dir_release, auxdev);
 }
 
 /**

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

