Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369242;
	b=dYT+ByT5pjO8IeoExm6JVDNDa0wSLvPILLtzdVbJZv97kCrbMCVdW4SVaFQ2O+gJmU7Q
	 sPB82zoU04T495UhpqJbeEd12lDkLdgH2/cthhhqL3Gw/SWi2ELljRr1DKysEpl0Ipmce
	 sxsXvXli3qTEZx3716gxfozMUxUwxPjf7gy88tF1mx89nq6WSiKjbD+jE0daLPFrKwU0f
	 B+XZ0nqk5ukPso0ScJToW7Wc/PZpVbNWmlHlbmLaDEzBQqo22/n645QOD7bGbFlN+QMQx
	 mIkopajzz7cVXgFgk38sYZIhdBXHq7TBlJpC27oNvKzlJhGSqVcndExmXCXnqq8Aggg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369242;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
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
	bh=fmCA8gxEwDoUFdHccU1Z5eka6SsCOF7XUKubeS59lww=;
	b=id+zplOk7QOOcN2+nZf1tRLD8lVX9mc/tq2PXtEWMgD18+N5pzdllFhVwODLLwEQWxZs
	 IXVYZo/M0yDEZvyrsz5mn3Kgjj4SiG+quhDfTOVLp4TiuShrCqTcYbKF3nAi/tyaJ6Mhn
	 X3g6qlS2pCaHfv0/oTCjSatSxthlD5IbGw5yYaCRhr01Zpus/O8zrQOqthteFi0qNwLm/
	 /vvzQawmzvsOw1Y2f10X4P5sNpXVOpcZP2qqGHPpC4oO5g7oP4Bo765DXil9JqIX6crTg
	 vOiI6YHBd4wx+ATNHKcubqnIpzM/71IDyhAu8kNsZTMZ3iqkW6Xe+J5KZkGlFdQeFYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BkpcdTTr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.2
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC4606A331;
	Sun, 22 Nov 2026 17:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87DC4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BkpcdTTr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AwePS0BwgzJtTytWhZ2uwzPGj0cqcDVJh7d4UMsj9lAcPySCuWS+kzNu7d1olgXJmshh5eYfHwZFVPTI25AS5xt6j9EP8OqcpZJVB4cDplPzjF+c7cHL4gAJURr84XzUIjfQ/jgH+U/1ALqgf2HGXj/Q5JF9AlHYbYy+eQfPR2YBuyxV52ANNIurDrKo+nsHQhSs4goLJkQxN/Bg7oBMisVGzkf73bG0OFcETcwNWYUAZnnXAtQ3AONvabW1j5Brltje/xANfLCDKXaaoUA/uvaouv+mP0rS9OFpvEGmpM6pA2VtdOQfHfqnpD1wF8YOItJhl2tobRce6lEApKQgdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmCA8gxEwDoUFdHccU1Z5eka6SsCOF7XUKubeS59lww=;
 b=yJEfcbyf26Ts0/a0ZngBm9VRf8+vmBlMvXsa3diW7APtVNYXb8ERHxdHb70IbEsinAm6uJCr/TLa6sbnMmODCjCXwNSQ1dLZfcQQgABfZyA1FuFnBY2YIJt3lVmaPjY8/4JMsPGhBC4szD2pE82mP4pqqfXJQs51rN3N+coRNmKKAuYEkbTXnTjRaUgJusACpxjX618XDEErOVbgnHORAjjGr3aqXepi9d0YHNmAhvPT9Y7E/09Azez7Y9k5aGECnqTYlKogpuq+7yEOc+yJKitb36dUafm04APMR8AU+zTZ1VGaoPOEWgG6GmluIfw64QE8/+twWltWt/RhZqCF3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmCA8gxEwDoUFdHccU1Z5eka6SsCOF7XUKubeS59lww=;
 b=BkpcdTTr1NC515g9jELICUwI+4VCs/1EVb9e3GVOZNpbBLGwdCLqTwR4++6c7YnxfOhUAhJHFPxN39SMmKobi4pMKB/VbOIrUWR8p4zEPgFpoUwOdAgijlApSwtHjhaF6LnQBzl3aTJUv2tOwGrER30Svayo/jQ8/wjrBweSTB4adRiWAbJ5D2D4hZrWGVYZFqJZSvJ66C45jz5gR/eFCQ/sRqHdE2DxOrhVl3IjHCMNtS/Rsqxj59oDD4WGlJW+z+rK+e/P2W1efPBOJA5VdiFiof5ZRqmDDhS/iXHUQwfDHaG+w8PGnLW5ia8y2m/NszRLG2MnxwWPW2L5jphSZQ==
Received: from SJ0PR03CA0345.namprd03.prod.outlook.com (2603:10b6:a03:39c::20)
 by LV8PR12MB9689.namprd12.prod.outlook.com (2603:10b6:408:296::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 17:39:49 +0000
Received: from MW1PEPF00018893.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::91) by SJ0PR03CA0345.outlook.office365.com
 (2603:10b6:a03:39c::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:39:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MW1PEPF00018893.mail.protection.outlook.com (10.167.249.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 17:39:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:37 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:36 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:34 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:13 +0200
Subject: [PATCH rdma-next 5/9] RDMA/core: Add ib_dispatch_event_sync()
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
Message-ID: <20261122-mlx5-port-events-probe-v1-5-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=5700;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=ShIp3ECtJNK4zEyd0gh3EnMdrRJlZRUDUbv2ykxFpno=;
 b=7weSzIk0IH392YYMfBkvi/bdkG3lLoHMd92GA0oXf0B54QYBgsc/qPknj+mH8SPLL6k8XBS+k
 46aspP9J6j1BCMvG2QvJDip2nKnuEr7TpUDe8OdI73IcApdCF9U6ekr
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF00018893:EE_|LV8PR12MB9689:EE_
X-MS-Office365-Filtering-Correlation-Id: fa366e94-9bb4-452a-ab51-08df48bf9b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|261009223027099003|261009221227099003|18002099003|22082099003|261022075727099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261102130727099003|261102123227099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	bg6kfl9BlFFskW4vWQr0akCGUNy1k+bp4SXeuPm3brZ3bTahad5dPyCSJ0dH79eEBi+dGPvYLExAZixrHHG1gCOellWbrdRF69Ei15ROO32rPjHsBmsKwHLjP1/bydfJT3P7rRgYUG2wpKdkTcJFjXVG1p8UHwrY9I8Y7r9d8Zp+ecF7qTQzDRhdzZMynv55en2t8Je+4B9RxQqtEgUVXB01UdhO9RPp604Z/TaUk4CqLCTZNIYWo3vmrErNSTZfFmaBOuT8ju3cY3XMGqQtX6QHrsfcnTl1OyoLa4hJvy1Mo1heM8SvU6D9gMW0ATOzXkTzHKMrdamHbigFQqRw8gd62Ua0zcSL88RZNe+iKyFO+Z65kBcojJpM26LMjQQunM7Xj9YeL35ru2vmCftRGpYH48vphAPHdX1wM0UDBQzifKo/PhQe8WOdrAmtUx2jAGodi7C5MCn6p4HtleZqKYE27nGrE6bFANVwjgSbt+iG1bnCxfNYJ5MwUjzMHc3pcDltZ1qY+Yah2zajdhmkvq6Hq+ULC2wHr/oukZyg8rtalaIihLl7Zz2sVSDKbCIAXpmZvZTnN4WzyK95Jrv0PTcE5Ot9D5bcYmot9RgNtHa2SrhdyKM/Nam1HPCp18vtvAir2DR4vVVlh2pFGLoqYAyHk+kDonwZzgjlV/fXlWTV6hWCOHbsJjGLKBUcBpHjwHhQ0tITi3c8a6Y8ocBC1A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(261009223027099003)(261009221227099003)(18002099003)(22082099003)(261022075727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102130727099003)(261102123227099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VHlaxJUdE1icNwd+vz7Xbx8c4zatXK4y0cuh20nI5gd2wP+NGniqARe12kDpTa4erZLx6yUazhj6pE+5e954cXF/JWddaxi1pQdLPhHTAXWyZxIJe9FGbh2og7oyVk+/Z1bysVOF9oOioBxzLuDwdU92jrLG1wLmaQhusMA0FuTO37zdPcljB0rNyOrW4cB7JuzMp6v9ZW71mpNo51WTVk3gmiBnhOJ0is2XClsHiOdprz6CD+fVvAGGsMaYYbx7PERu+ILOVKIjQHjGxt4RJxTgD8rtiwQU8ys66UD/U61+W57oa5rLzEQqgHX6oXEgTB9XhvepCp4yAMJm3yxUXnSRZ23h10fhDIdXV2Gfa7WEMDIFKsoC2SjpRi8Yo7t5WQNETr2LdaK7nsSZHBy4xVhH0fWD/uFayoGLa1SeC4FWM5ntzuvlgGBnuGv4aqMA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:48.7373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa366e94-9bb4-452a-ab51-08df48bf9b1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00018893.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9689

ib_dispatch_event() hands each event to a work item on ib_wq, which is
not ordered, so events dispatched one after the other can be processed
in either order, and a cache update can publish an older state after a
newer one. A driver has no way to wait for an event it dispatched
short of flushing ib_wq, which waits for the work of every device,
including work that may itself be waiting for that driver.

Add ib_dispatch_event_sync(), which processes the event in the
caller's context and returns the error of the cache update, so that
events a driver passes to it one after the other are processed in that
order. They are not ordered against events passed to
ib_dispatch_event(). It must be called from a workqueue, the context
event handlers are promised, and not from an event handler, where it
would take event_handler_rwsem recursively and could deadlock behind a
waiting writer; lockdep checks the latter.

The processing moves to a helper shared with the work item: the cache
is still updated before the handlers are called, P_Key and GID changes
still revalidate security, and the handlers are still not called when
the update fails, nor for a GID change. The handlers get a copy of the
event, as they do from the work item.

A later patch uses it in mlx5_ib to replay port events that arrived
while the device was not yet active.

Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/cache.c | 63 ++++++++++++++++++++++++++++++++++-------
 include/rdma/ib_verbs.h         |  1 +
 2 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index c338c2e52d8bd041bdc194ca574b7c35cc9b6d0d..4e376a866715d4e0613087dccde232934171c1e1 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1522,29 +1522,36 @@ ib_cache_update(struct ib_device *device, u32 port, bool update_gids,
 	return ret;
 }
 
-static void ib_cache_event_task(struct work_struct *_work)
+static int ib_cache_event_process(struct ib_event *event)
 {
-	struct ib_update_work *work =
-		container_of(_work, struct ib_update_work, work);
 	int ret;
 
 	/* Before distributing the cache update event, first sync
 	 * the cache.
 	 */
-	ret = ib_cache_update(work->event.device, work->event.element.port_num,
-			      work->event.event == IB_EVENT_GID_CHANGE ||
-			      work->event.event == IB_EVENT_CLIENT_REREGISTER,
-			      work->event.event == IB_EVENT_PKEY_CHANGE,
-			      work->event.event == IB_EVENT_PKEY_CHANGE ||
-			      work->event.event == IB_EVENT_GID_CHANGE);
+	ret = ib_cache_update(event->device, event->element.port_num,
+			      event->event == IB_EVENT_GID_CHANGE ||
+			      event->event == IB_EVENT_CLIENT_REREGISTER,
+			      event->event == IB_EVENT_PKEY_CHANGE,
+			      event->event == IB_EVENT_PKEY_CHANGE ||
+			      event->event == IB_EVENT_GID_CHANGE);
 
 	/* GID event is notified already for individual GID entries by
 	 * dispatch_gid_change_event(). Hence, notifiy for rest of the
 	 * events.
 	 */
-	if (!ret && work->event.event != IB_EVENT_GID_CHANGE)
-		ib_dispatch_event_clients(&work->event);
+	if (!ret && event->event != IB_EVENT_GID_CHANGE)
+		ib_dispatch_event_clients(event);
+
+	return ret;
+}
 
+static void ib_cache_event_task(struct work_struct *_work)
+{
+	struct ib_update_work *work =
+		container_of(_work, struct ib_update_work, work);
+
+	ib_cache_event_process(&work->event);
 	kfree(work);
 }
 
@@ -1593,6 +1600,40 @@ void ib_dispatch_event(const struct ib_event *event)
 }
 EXPORT_SYMBOL(ib_dispatch_event);
 
+/**
+ * ib_dispatch_event_sync - Process an asynchronous event before returning
+ * @event: Event to process
+ *
+ * Does in the caller's context what ib_dispatch_event() leaves to a work
+ * item, by the same rules: an event that affects the cache updates it first,
+ * and the registered event handlers are then called, unless that update
+ * failed or the event is a GID change. All of it completes before this
+ * returns, so events a caller passes here one after the other are processed
+ * in that order. They are not ordered against events passed to
+ * ib_dispatch_event().
+ *
+ * Context: Workqueue context, which event handlers are promised, with no
+ * locks held that the cache update or the handlers may take. Not from an
+ * event handler.
+ *
+ * Return: 0, or the error of the cache update.
+ */
+int ib_dispatch_event_sync(const struct ib_event *event)
+{
+	struct ib_event copy = *event;
+
+	might_sleep();
+	lockdep_assert_not_held(&event->device->event_handler_rwsem);
+
+	if (!is_cache_update_event(&copy)) {
+		ib_dispatch_event_clients(&copy);
+		return 0;
+	}
+
+	return ib_cache_event_process(&copy);
+}
+EXPORT_SYMBOL(ib_dispatch_event_sync);
+
 int ib_cache_setup_one(struct ib_device *device)
 {
 	u32 p;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 29228226a236638aa746b9f5e0172acded69f135..ab6b9af1a6d3018c441e608b0fbaa9afbd1aa3bf 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3308,6 +3308,7 @@ bool ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 void ib_register_event_handler(struct ib_event_handler *event_handler);
 void ib_unregister_event_handler(struct ib_event_handler *event_handler);
 void ib_dispatch_event(const struct ib_event *event);
+int ib_dispatch_event_sync(const struct ib_event *event);
 
 int ib_query_port(struct ib_device *device,
 		  u32 port_num, struct ib_port_attr *port_attr);

-- 
2.49.0

