Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692673E1CE1;
	Fri, 17 Jul 2026 07:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273626; cv=fail; b=AFCTO3NfypM147sF5C6dRU59KAO/W1saDoqt+W18QoN0XuSAi+q+lLv5SWy2isEeiHtDrvT4zkBFLKGVAz9ROAeDgALlP4j10MT+Mo0Wh4VbUCj0PozEYbgsLyeJ57BASXmJrsjkhdoHEtGHyDVI3VcFS/jhUjFQqj5keMNvi3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273626; c=relaxed/simple;
	bh=GdSjsIl6KjQ06bsEj5YHKmJQxJ8xsO8ztYXdA79oRt0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S5vu/wRs+RydzEiIAsISDdcc5WFsFzBenCMyehe73pWBfxaoIzYwrd7Z8r/Dl0UQpOo4JIhGFRtuRTh0sltAjO2qQhBUYh6dipjVaHEJ+fv/za1b83W5kE5vDbQcCbTSf7bITFOhcAu03gD8OiwvR/S1MkXsF0r+Fcvg2Cbo/Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r8rLG+Je; arc=fail smtp.client-ip=40.107.209.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r8rLG+Je"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wn4bWro1B8GghUZIdAd6dGVc1aTbI3UB1JBIYL6zNMYuOudmIVihWPlID9aB4uTh5F0341q7tkx4wgLDZRMgiNs5pSYeSlZi9udFBDBJ/+/H2jpgmvOkvJ24jQQyP8nA6IxcY/V2VfcMGlGKnCXX1E/+6rxbdVRxzFnj+y7u891Y4BWvjmDG8uC5HbjYyGgIh9jYUO9EA7jEHZczuqFZRRa3mp2mo4o069m8wC7E70pK5f6YDa3HGh3xSQHB2ZrrYSbA0hxJf+Vr+xQagHHBrsKsP1YbSV/53saFxygAYJDKRBMNhl15cMXKZYTWYPPDU1TYr0XmnbFwrCBuMM/+JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOKgHtDZWy8LVnWhDmNGmiO6q6LZoAYJZ9d9da8nQ1E=;
 b=AUNJUH0Ujz2y+cbHENPP4lTAD/+P3C1c29UkRzawQZnBrkPVVhk8c9KMMmZ9wlG8wIpqrIyMkw3oFkBjf9lg0GdwXXZuAX4dB4rwa6Q9TUaeirUW3BHcXi5o9tCVffXmRgt1ym2IBVXVGwwgZn82ED3GxUHBcreWjCJtYHxKT063TOQBLSjm7DpS3JT3qfpPB8RyEDlfTAGILBfNq9GcS7vqbMrmzc725tueu7Dek/rEsDLAQIJzwJdFQ3zCgJx0BKuALE9IWipoT3JRJH82WL3S50mfMOvcxcJOJScEBlMpd0Jq+fKSCFKJAVEQhbgaJ4e7HKOTExnkPcBBP/JE5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOKgHtDZWy8LVnWhDmNGmiO6q6LZoAYJZ9d9da8nQ1E=;
 b=r8rLG+JeCjNHn8m5eM6qQtDuHcUMiN5JZYTOjqi55OBErqDYBmk4HK12pZtKAWw0BrAuiKEsr/8Xb+fvE2nzrerJUgaepko6Dd74D05mpOEKEDZdpkVXtQGhDxeddXLEvAScMeVM1zoBNPAf9p8BP0Hs9QRCNGRywvvQDtOuChW1vC/28Kbps1D9b7UhXbwgdNiLFjrmueAigKLkKowGn49jMKWyCiKrnaaZWKVD6HcOFjTkgRIajypi34EYX/NBWCanLpUzbyMi9aKuUYA7lU0NxxWv8C1rygekMgZim/t8DRJcTWtC2w7SCJFBejHD1ryMS2JCHjJskQkeLBlJMQ==
Received: from PH8P221CA0064.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::16)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 07:33:33 +0000
Received: from CY4PEPF0000E9CF.namprd03.prod.outlook.com
 (2603:10b6:510:349:cafe::5a) by PH8P221CA0064.outlook.office365.com
 (2603:10b6:510:349::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.13 via Frontend Transport; Fri,
 17 Jul 2026 07:33:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000E9CF.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 07:33:32 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 17 Jul
 2026 00:33:19 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 17 Jul 2026 00:33:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Jul 2026 00:33:15 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Kees Cook <kees@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yael Chemla
	<ychemla@nvidia.com>
Subject: [PATCH net] net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule
Date: Fri, 17 Jul 2026 10:33:06 +0300
Message-ID: <20260717073306.1242399-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CF:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 53282c1f-92bd-48d7-357c-08dee3d5b418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|1800799024|82310400026|6133799003|5023799004|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jiKbKwuxYhc1Ju5Miu8MX+KsMXxtUucH00ohkegCzyq9U4jGdCQfTScINNVZos9l5EAnS5s9Nuq2A4RXksS/AvHRxAaCNgENDzOUZAlT5oDyksyEVMefwyCjWh00/JKMh8lpNV6YXsS3lzM1o1pGFdjSEptEwX/iqFxuBji+wGFxLCVqp1pooYo7cQK31ZF+MgzW8loxT5wj/Ja7hH/jfCTakUtWLi6v4aAXp0YqKZ4IG2QRFUkx0ilyAEeMn9FjCWEbDVBC2CqJJaUJQyQf25EfQIETT7UEctVl2jzxyfdQPZVgpwNKAjbczItfWj/rK+8COKaKMy/doHdvouMTzmKPWGw9NFZJdtpU+yI2IoIZ22AhxhnT1jjQaqA85YDQMlovTSUsy0DU20Tf7aV2RYSkkGdRSdrz+B/0LDetSaHLiNbUeqi432epJn/b8GDT4SkNdLBcc3V6qOQyKRkWXWH0ohSe+QYTLg+0Za8a/wirxnaBcdN7+TuyMrhdI9x+ITHT0eBN5CecaLZ3f0MB/sC6WDSV2aYeVrs3CEJGU5KAGqzNHk8EoQPZq+qndTT9IBuTsy8wWyoa+Ls8jdRY9rqgx440cdJzxDtGkcL+MOj8eIZdyVpvucvW/gKt4HEiBSqnca25ymD8NkwEW5IPm/mEhjwcWuaYMqLswxmEAqzti+wdm7U3YjH1e7FcyN8J0WOTGSyRIdcBmbjMmeyBOQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(6133799003)(5023799004)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mFA7zxEyQ91OZ6DzFQ9n8uC9CAPkRd3zIIjzvyWi8vZ/lDhmWV4Ytv5DzO8fNGe8lqPUXSL452+hW6ujlSb5Dqxhi3QF2wySgpJTSclPH8udK1+rWWTbRnhyXY+DVD6G6FQ5BNtw1ysm8TD3RLVftivX3Or7NEIcw4oPzDCsAgWx5RUqTxwLTJHBGy0BhodjKzq+zy/GMqpax1iVNb4l+/gFSyE2Wv9Z/6IaI1gvXIlDvS0+0AhtdPLsqW2yuBPAEUSU42QyIFvrNglmmkfMHixCNZJeddoqe7hIfEEVnq+KHfHvV0pum3kZXtq0ZRAWQr82bVXTaDQxh32EzD/sfWz2FoKoLgOLPFpEykHxKhOXBCBq+QMSK5laHIh8+Xlpee5PiI2TL67Dwk5XoYNPVdGGGX5mN+mPN4vjnr5+9/3EyIQ+p6V3kpTRQiQ8zELg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:33:32.1015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53282c1f-92bd-48d7-357c-08dee3d5b418
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789

From: Yael Chemla <ychemla@nvidia.com>

esw_egress_acl_vlan_create() hardcodes num_dest=0 in its
mlx5_add_flow_rules() call. When invoked from the non-bond path
fwd_dest is NULL and num_dest=0 is correct. When invoked from
esw_acl_egress_ofld_rules_create() during a bond event, fwd_dest is
non-NULL and flow_act.action carries MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
but _mlx5_add_flow_rules() rejects a non-NULL dest pointer paired with
dest_num<=0 and returns -EINVAL. The error propagates as
"configure slave vport egress fwd, err(-22)". The passive vport's egress
ACL table ends up with its flow groups allocated but no FTEs, so
prio-tagged packets are not popped and bond failover is broken on
prio_tag_required devices.

Fix by passing fwd_dest ? 1 : 0 as num_dest to match the actual number
of destinations supplied.

Fixes: bf773dc0e6d5 ("net/mlx5: E-Switch, Introduce APIs to enable egress acl forward-to-vport rule")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index ba5cce706ea2..9693c74e9b16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -71,7 +71,7 @@ int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw,
 	flow_act.action = flow_action;
 	vport->egress.allowed_vlan =
 		mlx5_add_flow_rules(vport->egress.acl, spec,
-				    &flow_act, fwd_dest, 0);
+				    &flow_act, fwd_dest, fwd_dest ? 1 : 0);
 	if (IS_ERR(vport->egress.allowed_vlan)) {
 		err = PTR_ERR(vport->egress.allowed_vlan);
 		esw_warn(esw->dev,

base-commit: 3f1f755366687d051174739fb99f7d560202f60b
-- 
2.44.0

