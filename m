Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794227364;
	b=aWlhw3/q6f5KwxDJcsvl7oq4mc0pS+DEF3w/BSqaTqjNrrRRBYYb8zJLSGCTuRvZrvjI
	 fhEDa797Q/ZqEJYsck4c2Cxv2chSKMMMLUGuv7HmBaMA8WVGu9jjDeM60J3ZJMUcFIbR0
	 NcvEdkhXzAl1e0y3aIjOTyJesLDtGRkI8yLFYP0SL2YjeWVqt0ME70h67+6AmgAi1nA0m
	 LAM7fwX9Wc3EPRjCAlZGtRNcMlnCfiX0q2JcZB9Bas/wyMitakAbepOrAeJY5AhGQOapP
	 y6DbH39tCD4AzikRwal2wHoYQO9xlJeCYbR/Fy6Cy3SEdC/CMixNuVPrvnwDxlqKl2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794227364;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:X-B4-Tracking:X-Change-ID:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=qTgN7Yo5pvon6+VrRMDs9eSyGhrieXUQlFr/lggJea4=;
	b=whgQYPxUfo9q1QfgNfYPqVBfmHk+Z3E+u/Di70+2O0wvQf6RYc0gkdpKum1p9IIF3IkQ
	 PaGB43RjUEMdaWRZallX1dIptvEmNkPr2/I6J1obQ6GMAzbG4bzzuJSvljEeiq1nKHSUH
	 z+yyJ4Ze925gmt4IqhVfGRmw9aDjmDH03JBCCd6/gJEVHUTROdtAlKKISBqRUFGaYNgaH
	 FB5e8J/+YtaC3hDgb7icoSh1ufEUy6xxJFEc4vl+BdPj2FZxFYWVR3yaZjfXGraTFZT7N
	 9H32dmXs+Qt0r/Nesfwaq30aR9xiSGo2QFkPboqiKMjkC2WSB2hHgjYDC8kaFCSq6Xg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dbucd4S4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.31
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013031.outbound.protection.outlook.com [40.93.201.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F77606A332;
	Mon,  9 Nov 2026 12:29:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25F77606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dbucd4S4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4AI8wok/GL1Wni17wugAXawdQ5xusILWHoMrSTg3s+53rX7NITw3fPg1jrSgxuFft2U+wU62J1V4rrmgqYlWk/jHk5/scNfoOiCi7axqLRzsDf1+yEVrnM9DaG3YvCyksRxxeckI9R4tsEPyINAmPqB/2eoyTWhODbBC2np9KOGTWy6lBVjxUewFyVKEjtSupBvYeQGkSFerD9bXu9ypJlVMdVHWgEAYNkB6LIy0iyqr7s59fwa6K6Qodt0uWbX+Extq+g+fSMM+Na7zynXVcsSCJ1hvebePebXAYlyabkhmh5pbFmlp+hDM4H1BJntzO8cJxzfp7yCRGjRm/owag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTgN7Yo5pvon6+VrRMDs9eSyGhrieXUQlFr/lggJea4=;
 b=RqAXfx5IBwPbuAynvaQVzIDPyIn62hokjPqbdfLz2d+FE7mDUeux0/eH937yjDiJXM8YNShUo3Az65b8eWcdgQzb79Sn3CDEsVbp6DmtqTGyr9PhrHsWY5jXuB2B2fqliY3/iTGD2q7nOummRHIG90QAasEbi5M9kvUZWfAnSfNMcoCz/Y4vjwk5u3PCqmsgXn9rm09aKDkAx9ofvhZsLrLqffL6bjunNpH4IdJeFoJrKx8O/0wvRvuI+JgNLkULaaKzZl8wsEIPk6kMM/KkM90X9YK6usSLdYh0VIvK2ObpFTKLGtRgkF+3LLA8P99s++aoeM2gu/eb9QU3JYlP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTgN7Yo5pvon6+VrRMDs9eSyGhrieXUQlFr/lggJea4=;
 b=Dbucd4S4RPwme4YUtvKmoISKySSCInz0VAwhVEam3a8XlPDQP1SU6dqSJf9RTB55WZbCP4wjLIfTYQDrRPuCxS17wna0+qGiL54Cxr20wtDP+R76f7Fa69rzk91ipV9QovKmq8swPTFp+SsGWhKeP7EJVksnsw9kARBRSKBIvyStIKOSc7Cgvm8FC+yJRqMtzFSCNUekfzGVd3VTNuJx12DHU1t/B93AcVE/ZSjTq4pxdkuO3EJZEa/Ndpc5o2dNUq5D1uEJ1zJewvWhD3PQY154R3oKj0xTavYvYqgZ18AbejsnHkxGoN1Nd9M8d5yrzF35RelJiWaf5DEZCtd7ng==
Received: from CH0P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::17)
 by CH3PR12MB8307.namprd12.prod.outlook.com (2603:10b6:610:12f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 12:29:18 +0000
Received: from BN3PEPF0000B374.namprd21.prod.outlook.com
 (2603:10b6:610:11c:cafe::e) by CH0P221CA0021.outlook.office365.com
 (2603:10b6:610:11c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 12:29:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B374.mail.protection.outlook.com (10.167.243.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Mon, 9 Nov 2026 12:29:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 04:29:00 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 04:28:59 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 04:28:57 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Mon, 9 Nov 2026 14:28:45 +0200
Subject: [PATCH rdma-next v2] RDMA/mlx5: Add missing error flow in
 mlx5_ib_set_vport_rep
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261109-rep-netdev-leak-v2-1-9a6d164142e5@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAHy88WoC/3WNzQ6CMBCEX4Xs2TXdIvhz8j0Mh0JX2SiFtE2DI
 X13G+4eJ/PNNxsE9sIBbtUGnpMEmV0J+lDBMBr3YhRbMmilW1LUoOcFHUfLCT9s3nitTzVZfdZ
 930NZLZ6fsu7GB3g7mUKvEbpSjRLi7L/7V6Id+KtNhIQNkVJUX1Rr+O6SWDHHYZ6gyzn/AEo1p
 tW6AAAA
X-Change-ID: 20261015-rep-netdev-leak-93431d272bbb
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Tariq
 Toukan" <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Michael Guralnik
	<michaelgur@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794227336; l=3494;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=jDvsS8/8S6rYdWtInMKrriOovtdWVCql9cnVRxmYP3s=;
 b=JIEKbYjkPaMO/oRDWZU+wzqLCoQpgCRlEY1PVNp7NAL4H20Qfa8kEObheaCZ+n6B8n7iSDN9o
 XcrtlnkQ0YXAJUuUqRRSs7n+Y9nYkQ9uFzqNNeFj56rK7gu3kjAOY2x
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B374:EE_|CH3PR12MB8307:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa56109-5a88-42c0-2d46-08df3e5d1346
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|260925022911599003|260925021911599003|260925021311599003|261009223027099003|11063799006|5023799004|56012099006|261021123027099003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|10067099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	YpEn1g9fp8ZJkFDWeo6GuTCGV9IL7kqhQ+TWaGwDRmuE9srLw3O0HF+TDza4q63jBBZx8412S9VkUhs1uTVWpZiBfoGrvTsFOeEC3TStdcfgjcZ4x+TG1GRMm7CjPtByHJZsRW+qoLa2xoxMA4cb0jMBofS++wEbWNlx1f2FvvVDXTndjwulq+1hoklq9HPgLePqYILdxoRQDV6NN5CwTgLN7nIea4ss9bEO5W/PLuInXTbPLYpZr+FPAThaDA/n+EHdYhYR/mobGIR1B/3dhNhigJyhfLmmiccSblDiY/YSrmIaj42XFY99IHe5fLlOCbZ3IZXEDG9WGzYdKvkOiYkAU79PLpoHJUXvPGsdsHbtSAK/JPCccSi/85zP6jVlkFrV76TR/JmQ7ot4kyv0uWdtahXinGZAD5dUJgYt1tMxrbP+gw6jhXo1MI3XanU9rWJ/PCW4bgYxR0Jc9jzSVkur+EVXK7WPjOgRzgmxsnuDYPjR/pkgyvUVkIe4nxa/LNvlwfqU2Ikp+1yxQMMOzGj+ePdIhhYk5HQyHp3doqeJjh5E1BbCuJSV1gQcRXuApVrb9gd8ZoM0Z+UKiwaiHx/aFRXdI21FWq6tk8oid4z8lp1JNS8G6yLksC9dKWghLas5j0b8L8jY175x4hhpkQYY5t59CWq9OsF5w0G0q1QbNqSOWaDUAQILQsZC73Dz6WXibtntvI/yOM2SQV6tiA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(260925022911599003)(260925021911599003)(260925021311599003)(261009223027099003)(11063799006)(5023799004)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yWe1YkEN73CLhLuv0ST1T/s8biF/AIjPNJBb7lqE6EaGSO1T2V1c3QKne6JhjD0JGLC3awW1MM1poQ+KVrTvw6f8KY0OSHtVNEoukjECD0XuzH/jAMTJbwPglh8SHM2bxArkm0eaiEiOYuh0ITqkWSWhyQ5SnKfentf1q14raAjTmkf0qAOaczJ09yYhCYaHodYMm1mdaASBw2ZmPGuOhJDtvbshXmlQdL6CLRbbUZgh4gRwCgPYlO+swUWfLidQjGKN3kiEdIrv3jDChNaD5aijVpT2b9K+T4iE7YRqtXM/kkJMYqROxd7/zzEatUdErrR5p899QxLmR3nAV9Z1MKAusbLyan4vwLIRoLlaU3LsYx7xBjGdEbT0kTnnQ3UZL2YRreKGrhB273FN3kj6TveKHOOVsDv+hjMALEKyEBvsAuOC+7To0lVawY2CF3AC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 12:29:18.4956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa56109-5a88-42c0-2d46-08df3e5d1346
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B374.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8307

From: Shay Drory <shayd@nvidia.com>

mlx5_ib_set_vport_rep() attaches the representor netdev to the IB
device, which takes a netdev reference, and then adds the LAG demux
rule. If mlx5_lag_demux_rule_add() fails, the error is returned
without detaching the netdev. The eswitch does not call unload() for a
representor whose load() failed, so the reference is never dropped and
a later unregister_netdevice() of the representor waits forever while
holding the eswitch representors lock.

Add the demux rule before publishing the rep and attaching its netdev,
so a failure there leaves nothing to undo. The rep pointers are still
set before ib_device_set_netdev() sends the netdev attach event, so a
listener never sees the attached port without its rep.

If ib_device_set_netdev() fails, delete the demux rule and clear the
rep pointers. ib_device_set_netdev() cannot fail here, as the port
index is always valid and the port data was allocated when the uplink
rep was loaded, so clearing the pointers does not race with lockless
readers.

Fixes: d6c9b4de8109 ("{net/RDMA}/mlx5: Add LAG demux table API and vport demux rules")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Changes in v2:
- Add the demux rule before publishing the rep and attaching its netdev,
  instead of clearing the rep pointers when adding it fails, so the error
  path no longer races with lockless readers of the rep pointers (Sashiko).
- Drop the Fixes tag for 8d159eb2117b, as ib_device_set_netdev() cannot
  fail in mlx5_ib_set_vport_rep().
- Rebase on top of rdma for-next.
- Link to v1: https://lore.kernel.org/r/20261015-rep-netdev-leak-v1-1-5110013806ae@nvidia.com
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 65d8767d1830c630f5aa2a2a693110e2c9bc9e48..c460018d04754c40677c05a4b603cf8479d2b469 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -22,21 +22,30 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 	if (!ibdev)
 		return -EINVAL;
 
+	/* Only Vports that are not native to the LAG master eswitch need to add
+	 * demux rule.
+	 */
+	if (mlx5_eswitch_get_total_vports(dev) <= vport_index) {
+		ret = mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
+		if (ret)
+			return ret;
+	}
+
 	ibdev->port[vport_index].rep = rep;
 	rep->rep_data[REP_IB].priv = ibdev;
 	ndev = mlx5_ib_get_rep_netdev(rep->esw, rep->vport);
 
 	ret = ib_device_set_netdev(&ibdev->ib_dev, ndev, vport_index + 1);
 	if (ret)
-		return ret;
+		goto err_set_netdev;
 
-	/* Only Vports that are not native to the LAG master eswitch need to add
-	 * demux rule.
-	 */
-	if (mlx5_eswitch_get_total_vports(dev) > vport_index)
-		return 0;
+	return 0;
 
-	return mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
+err_set_netdev:
+	rep->rep_data[REP_IB].priv = NULL;
+	ibdev->port[vport_index].rep = NULL;
+	mlx5_lag_demux_rule_del(rep_dev, vport_index);
+	return ret;
 }
 
 static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev);

---
base-commit: e50525a486300e5ff8014c9985b8477b2fca0368
change-id: 20261015-rep-netdev-leak-93431d272bbb

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

