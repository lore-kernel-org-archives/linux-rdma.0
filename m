Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64C2466B5E;
	Wed,  2 Sep 2026 14:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358050; cv=fail; b=InJrr1abqdvRSM9jMeCoWnLMxWRvrBOj8ZZPxSXFEPhCHcq8hR4Lan/ZgGFxpL4hn2rD/ASl2LlEIzu47isWsWdRbIqh6duiKz9OusEKPmZDcwhnotck4Peuk0SBlhjwagC4Cxp9bVP0RnLLq05UDgCr+yCxrqh3EGw7JM5Zdys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358050; c=relaxed/simple;
	bh=NXJaiEwsnxn9n4Nly1vHsjCzzeMn/VqVdjTkI5OayZA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=Q02WpvikLPhTIv9jOzvPQOFsTJFOkLHlCJ+BvuOCU6EVeZMLQtwZcxkzYUoVi67eu1AFaB3EVU0inJnk6MuVVr5Fk3SxFB05WVVz1cnPycuLuVO5zAI9QtfApJXgLUK9JYx7n8axBUFR90O/R1lqXHQotCe0TQUC2lWbFUXLyxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QfOENJpO; arc=fail smtp.client-ip=52.101.56.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QfOENJpO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHaN16AUhTfdOXiKO/2EeK5IkJisyVCU1pJppwq5fOmP5TPDYxVnyZoEy0jR9yBGJF6OtYj1N2daafvXWjB58Qa2u9rvczImkC51+4stUt/eGHAU5WkTa3eLItHjO14pVtptTXvbH8oh+jy62Zqnr4PoBthx/iJW4xYquaJZVUnHrxp7Tq0RT6eMUwyFrpGK26B+naUGX0cwml9btAUToVZrHc33MXElC8CvX8TGYQpwEUlNMj1a8XSxiHAMdjiK1TCr3R3hi/e7F84aYJpvneMqdzmo7Vy1FLQ+QM8iJQi2rggtd7yCH5KXR/Zn3VM08MDPFiEuVZnu2W/zYOhkGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UT2xb8Kn5DkTwt9rQOyuu0TY9zlXzj4Jr5vAh1s12u4=;
 b=QmpZ4TtB+eCN9ek/+o7iX4tVVGPVMQpw7MQQaWq1qWLGs7LqBTtUmAA/IRF3fN7GTviubetahdnKT0jFF2NtziH1sDa/4QdT9exVvdryUFBZRwinWXdaERv2Tk51GlR01txH4gzyrYF/MpJ0peDEsyemsigsQAaRdveoM+pXdSGHE8dv3E0xx9F9wKWKi56ywwAd76oJqiumldgUE1Fmg433OGYvVnlWeOmHH9GlSUL3clDHHl1vFMrvKhaPktcA3QFk+x7gogTq+Ow7D48219Aa0sdUx7k+WoQz6GSM8YIMvwPJKiO9i42jkKE8nf7sxjdMMOqQqtwc/UTFMfLU/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UT2xb8Kn5DkTwt9rQOyuu0TY9zlXzj4Jr5vAh1s12u4=;
 b=QfOENJpOySaOUSxrt6CKBZ+vjSntXN30hnX7OchjSh2bRZrPP76uSPxhIXpizXgJLFfE5t2/A7Vl39nU66icbbhgM8+v+k2hfXTu/6CiRm2zUr0yOIzAyA/s4Au4qiA8kFdC0IwgGANYZAY1uD/dPC85w+Mqm+5EQpH4+XRYdLd6Hvi8sQ+Wnc38C/AAMmW6zw8yiPM2XmriVoHKvYxpcUqsZX3lWriD6BMy6uaOyQnD64He8cjYo7kMnqeqio9nHZU2UIm8WtCgI85K1NpF3peES6KPouW230X5vfFdQRFbSH5sO35CY7p5A1Uzc6vHURY9GYu/FXbeCuTkTGEplQ==
Received: from DS7PR03CA0117.namprd03.prod.outlook.com (2603:10b6:5:3b7::32)
 by DS7PR12MB6117.namprd12.prod.outlook.com (2603:10b6:8:9b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Wed, 2 Sep 2026 14:07:17 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:3b7:cafe::5e) by DS7PR03CA0117.outlook.office365.com
 (2603:10b6:5:3b7::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 14:07:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 14:07:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 07:06:53 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 07:06:53 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 2 Sep
 2026 07:06:50 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Wed, 2 Sep 2026 17:06:32 +0300
Subject: [PATCH rdma-next] IB/IPoIB: Avoid restoring OPER_UP after
 multicast flush
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260902-avoid-rest-oper-up-v1-1-04fcd4916cae@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAGctmGoC/x3MQQrDIBBG4auEWXfASo1tr1K6kPonnUVVxiQII
 XevZPkt3tupQgWVnsNOik2q5NRxvQz0+YY0gyV2kzV2NA9jOWxZIivqwrlAeS3s3Oid97eI6U4
 9LIpJ2jl9kcZf4IS20Ps4/qp6VR1vAAAA
X-Change-ID: 20260902-avoid-rest-oper-up-55675774def8
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Doug
 Ledford" <dledford@redhat.com>, Alex Vesker <valex@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, Ben Davies <ben.davies@gresearch.co.uk>,
	"Cosmin Ratiu" <cratiu@nvidia.com>, Edward Srouji <edwards@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788358009; l=6551;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=q22idShWR8VVI4JeyqgBfHGSDlQcKrCMbcpwvyK2ZhY=;
 b=aWni3/Cn3GDdrmw7guQuL0hY+wRQ/t3gkJQI5rR9Of8n8O2rq9ESZOpEVLVi/895xbZmxXMay
 cBctp3pZOVmCFPPCGIijgw+QOfvU1/ZCupElBHu5oH1OBRGBCRJZ0b1
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|DS7PR12MB6117:EE_
X-MS-Office365-Filtering-Correlation-Id: 040c9087-5b6c-4df9-5de6-08df08fb7f3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	r39CD2PUjFl3miYGetYdwnKQ6kwPxBp7nPYSZlwy5YNhd4CV/13dYUY7xUqxqJUCsmm7SGbmzmeufTkAHJc2qUO0hiBL4ClhY1qOwpDCjwSfg9Fvka/6mlGK2esjlpc7HwyXZcBR9Ii7h7lH++jxYXTU1DUArwe0ka+IQWeeyG/v7r5HcDYtIKfYj5dLOJLnXbG1ZobngYx8CDnXuK5j0EdNg/Q1Fts+B+rTWzgy9jcmK7hOX8MgoZrbri50zniM6VCtX3OTg3DjvlP2r6J6Vx/coFYnFOJfd+a5pyFQhnSLNgtAC4yK2c+MdpOgtroIQHFVI58knQNvscW/A1sx7B5pK041U9ShFDVrA/Gg1Bm4/zqAS0nXKC6I/+34tizS/+QhCae7h4wWnCZIYwpDtAOOIgYlitTUFTMeiBAJZnScZes3VwyV8uTCWw2DEnQGZMQozJ1gQnsH7/RuuwvuanEOT0ekmN3hbN3x2Fbi66FkHln91w48Iywnx4NmMbsaDn60ebsXtbromwJYLBOonT37h78xOSdcrd3sf19In9q30ib0HilQWKhl6lfkVmSdR9RWDxf9KvC9NnJQcgkOGhI8fyBRiG9EhFhLDlydKzWQDiadlFnMl7sNoVEfLmF9gfxTg+0YdfvnmSIxSrcjYb9xVbIPs1BgIwcwsAvN3l8bcbmvk3fbELaDepGs9+DZucAnfquftNofa2W2Z03IoQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XgDifQhX6k/yKeFgCVjl17jzivVU8YmqFWXgTySqBtr+AVWEuIAw30dCka/z0iT44Br6oTCmXVEMQhsm6O7td3kx8ZMAa/D62QP/mEN0TYAAzn75i/uO15/2KksHoge6v7OjyPKoSQOTdkT7HR7vbdhTChxNTqpd26bxLiC2WLFAMfToGMMxghTSxSJ2UE4+nv/mSCDGZNFvGp/eoSwos0M+8EHnJ2OJLv2QTiqKpl+Tvy5yVGDqqeZ8Gpcb6L0ZuZWTdF/TmqPII3Ywxf6+Z3DIFh7a+mHyIPo2NScQq9Fx4xoTPgddbV3mr7wSVscR888DmWou7nU4QA3patnb8Z25yu+jUsi17uvJOKh+ZrmGv1W2iaftukpxlRaywyFCH17XWDDlyCgl2/0VXPh/pA2uoSQcAzDEr1NV7QxWsnq0GyPem68l0CX8yFIopIHp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 14:07:16.9823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 040c9087-5b6c-4df9-5de6-08df08fb7f3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6117

From: Carolina Jubran <cjubran@nvidia.com>

ipoib_ib_dev_flush_light() temporarily clears IPOIB_FLAG_OPER_UP to
prevent multicast joins while ipoib_mcast_dev_flush() is running, and
restores the flag afterwards if it was previously set.

This restore races with ipoib_ib_dev_down(). If the interface is brought
down while the flush is in progress, ipoib_ib_dev_down() clears
IPOIB_FLAG_OPER_UP, but the flush path may set it again after the device
has already gone down.

Since commit 894021a75291 ("IB/ipoib: Make the carrier_on_task race
aware"), ipoib_mcast_carrier_on_task() relies on IPOIB_FLAG_OPER_UP
being cleared to terminate its rtnl_trylock() retry loop. If the flag is
left set after shutdown, the workqueue retries forever, causing teardown
to deadlock when ipoib_ndo_uninit() waits in destroy_workqueue() while
holding RTNL.

Instead of overloading IPOIB_FLAG_OPER_UP to block multicast joins
during a light flush, introduce a dedicated IPOIB_FLAG_MCAST_FLUSH flag.
Use it together with IPOIB_FLAG_OPER_UP to determine whether multicast
joins are allowed, avoiding the race with device shutdown.

Fixes: 344bacca8cd8 ("IB/ipoib: Don't allow MC joins during light MC flush")
Reported-by: Ben Davies <ben.davies@gresearch.co.uk>
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  7 +++++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 12 +++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 16 ++++++++--------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 91f866e3fb8bd2aa3b7f248c709e8782c1ad0e30..143e03b6490210b708da08c63ce23e9ffce16aee 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -87,6 +87,7 @@ enum {
 	IPOIB_FLAG_INITIALIZED	  = 1,
 	IPOIB_FLAG_ADMIN_UP	  = 2,
 	IPOIB_PKEY_ASSIGNED	  = 3,
+	IPOIB_FLAG_MCAST_FLUSH	  = 4,
 	IPOIB_FLAG_SUBINTERFACE	  = 5,
 	IPOIB_STOP_REAPER	  = 7,
 	IPOIB_FLAG_ADMIN_CM	  = 9,
@@ -414,6 +415,12 @@ struct ipoib_dev_priv {
 	const struct net_device_ops	*rn_ops;
 };
 
+static inline bool ipoib_mcast_allowed(struct ipoib_dev_priv *priv)
+{
+	return test_bit(IPOIB_FLAG_OPER_UP, &priv->flags) &&
+	       !test_bit(IPOIB_FLAG_MCAST_FLUSH, &priv->flags);
+}
+
 struct ipoib_ah {
 	struct net_device *dev;
 	struct ib_ah	  *ah;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5061d52a7b12c7d5cfed60746a694d1438e2a166..81bbb3f7c11321cc845ce15c333ce7feeb8d5e52 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1227,17 +1227,19 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	}
 
 	if (level == IPOIB_FLUSH_LIGHT) {
-		int oper_up;
 		ipoib_mark_paths_invalid(dev);
-		/* Set IPoIB operation as down to prevent races between:
+		/* Set MCAST_FLUSH to prevent races between:
 		 * the flush flow which leaves MCG and on the fly joins
 		 * which can happen during that time. mcast restart task
 		 * should deal with join requests we missed.
+		 *
+		 * Do not clear OPER_UP for this; restoring it races with
+		 * ipoib_ib_dev_down() and can leave OPER_UP set after the
+		 * device is down.
 		 */
-		oper_up = test_and_clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
+		set_bit(IPOIB_FLAG_MCAST_FLUSH, &priv->flags);
 		ipoib_mcast_dev_flush(dev);
-		if (oper_up)
-			set_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
+		clear_bit(IPOIB_FLAG_MCAST_FLUSH, &priv->flags);
 		ipoib_reap_dead_ahs(priv);
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 6401af2fd548f1a37e25b6fdaee968b4fc2ff1bd..379b78374e210c3a3f373bb121f038c3c043c212 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -74,7 +74,7 @@ static void __ipoib_mcast_schedule_join_thread(struct ipoib_dev_priv *priv,
 					       struct ipoib_mcast *mcast,
 					       bool delay)
 {
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		return;
 
 	/*
@@ -469,7 +469,7 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 	int ret = 0;
 
 	if (!priv->broadcast ||
-	    !test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	    !ipoib_mcast_allowed(priv))
 		return -EINVAL;
 
 	init_completion(&mcast->done);
@@ -555,7 +555,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	unsigned long delay_until = 0;
 	struct ipoib_mcast *mcast = NULL;
 
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		return;
 
 	if (ib_query_port(priv->ca, priv->port, &port_attr)) {
@@ -577,7 +577,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	netif_addr_unlock_bh(dev);
 
 	spin_lock_irq(&priv->lock);
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		goto out;
 
 	if (!priv->broadcast) {
@@ -749,7 +749,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)		||
+	if (!ipoib_mcast_allowed(priv)				||
 	    !priv->broadcast					||
 	    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags)) {
 		++dev->stats.tx_dropped;
@@ -871,7 +871,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	LIST_HEAD(remove_list);
 	struct ib_sa_mcmember_rec rec;
 
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		/*
 		 * shortcut...on shutdown flush is called next, just
 		 * let it do all the work
@@ -965,9 +965,9 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	ipoib_mcast_remove_list(&remove_list);
 
 	/*
-	 * Double check that we are still up
+	 * Double check that we are still up and not flushing
 	 */
-	if (test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
+	if (ipoib_mcast_allowed(priv)) {
 		spin_lock_irq(&priv->lock);
 		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 		spin_unlock_irq(&priv->lock);

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260902-avoid-rest-oper-up-55675774def8

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

