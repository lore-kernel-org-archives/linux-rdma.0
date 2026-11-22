Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369213;
	b=1zd6Ow4UpFahd+uS1s3/bCoYFee62gp1yM99kii7yj489higbu/h83vEvbUU6aRZ2yWt
	 LTWIIyv4cgl0ggt6XdDIAxGQiQr0ed1t4fjl96qSwaxdvcMAr6JG9GtYv9aiHEKXkrs0f
	 u619rRzktdByaRRgY9Eqe01ghKUMxpgrYIdbgDpR9Xy18lALesXarznrWQvK26Pwz+wmJ
	 GLaTN5skKzQW9BzvZeaLG4Gg1Om17UK1iBibv6dC2gTGw+wzPbkCmBQQrGEQPoEUakNMj
	 A+h22FDXrhYZROpKfXMyep2D8YvZvoqjooP2UU4HqguDAWM3mGj/TArmLMExzlS0iXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369213;
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
	bh=hwxrBl2SZOlRiYSapo83nKDxzaECvVwH4r7GI0Muato=;
	b=F+4heQnGTENh2Hi4Dc2BqVnbVx88MvWfprkcVkt87Z3rea3g6x+E4ZxP+IYfL9NgjnNA
	 rpFCk7DUSzA4SGv0BhHYUDeyIC8eXG0ndQsWZVCDqc1t0IGQxL7ETNU3le6k7tpiNOxWt
	 vTCe9TdtYx3xvYAas9nIhwiaT8Z2kU6LxoNjIb8ZXJrbh4b5rJh/p5qsBLBUrPmOZLzLA
	 PNoMGY+X7Mrks9BRUFIHIwWFZK7sKkcS7e2JJNKliIeVhN9Ih5NPog0isilF7Vhk4fP4h
	 xUWbm85EfWeBIL0zicifdu2UKLJcmw9qZVvv8Xfpyvef2lGGfhDF6uIs3RmQeaLHdOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nLLPa4E3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.60
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013060.outbound.protection.outlook.com [40.93.196.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6E1606A330;
	Sun, 22 Nov 2026 17:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C6E1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nLLPa4E3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CP3M43K9UVJBC1AuwT5+ggJ9WUlBc9u/eBV5SA0VcdCz7XAwvSlAHyvoaRNOXeBXbFbS7WcvlaSM7V2ByBgHHYFC2zWCIRukjGvjSEx0UCzmmmIFKKku0ukonH5/zVaAyd6dAzr48UrGAGKVoXi+c+QMpVRQKT/z+LRvWeyYq9Ojv5bMrHEsnOzPjIHa402+9eVWN9ReuuKWp7YP7mIccFX9fejikku0mxNgAwBumdce9E8vSSoka/WLN3o/zZGPb0k9D7agXz1yXEyiTo33CVb7d2uvmz/QATHVLVXTFkxeM+NRJi4D596tvkZFbNW04UPCHEDXEou/a/M9mevIAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwxrBl2SZOlRiYSapo83nKDxzaECvVwH4r7GI0Muato=;
 b=e0jIxwoUJeJwFZEM3TBMme/7p9VkYWOjiZJU1zgSUDv4Q17r7Gam1nHyQiv9Te57aPgSuq/84gPh7wSTXRdb0cdzOg2w1e+V4CgMdm4BOCezx+dpkxw0frtPZVQ+Dmlq+AX+q6zRPynsHOTl5MqTAfqodXv0Eb79shIG4YaGSZfPO3YO2APMZceNcX7v5o1AKeMFyjxNvsexFfGHtppaT2ZXD1zgIkUUWQDu5nkGzX044x2X4y/oK7iaJLDi8bsyCWzoIcoyDNg5bko7vd9NIn2lG7XNclFGV0ETJbxUVJWuaMqQoubIoAwUsg36BRamC5JEtH0fWW7wPwY/lNCoCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwxrBl2SZOlRiYSapo83nKDxzaECvVwH4r7GI0Muato=;
 b=nLLPa4E34oYFMJNYLkLm6mUYP/a7DhRZq6aEDoZUqrNQHv1x+dZn2OI3MBI0HhMvfyJnTdarACosDg+EZae96c+6lDExpXegiJaZn8vUtMbDdJo+fymWHAQLgxclbvAEujlLab3OvxHNcAk7m6eCQdWjuq0+xNMA9zCIN6bxoVtgkTvAmlWCwIQsU/E6WTk6VTtBbfQa7jZqCL/hgt0pG/SMKWIqOP7yQGD34Xp10cIpDE044oR2U/9jKW7YxHzRT8Gf7jHAKkGtjE6ttTQbB6683m2x2kYNooXeoOeLYFhE5pgxOD0JrwX0P9eiYo1PGxqaaCc5xCGioUO4uhlymg==
Received: from PH0PR07CA0069.namprd07.prod.outlook.com (2603:10b6:510:f::14)
 by DS0PR12MB999313.namprd12.prod.outlook.com (2603:10b6:8:42c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sun, 22 Nov
 2026 17:40:08 +0000
Received: from PH4PEPF0000B60A.namprd21.prod.outlook.com
 (2603:10b6:510:f:cafe::8) by PH0PR07CA0069.outlook.office365.com
 (2603:10b6:510:f::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:40:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 PH4PEPF0000B60A.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Sun, 22 Nov 2026 17:40:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:50 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:49 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:47 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:17 +0200
Subject: [PATCH rdma-next 9/9] RDMA/mlx5: Register event notifier before IB
 registration
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
Message-ID: <20261122-mlx5-port-events-probe-v1-9-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=8472;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=Ocfkvpi2OZ5sc5lDuNcEoW2+X5bB4MqeP+1rFdqHGMc=;
 b=p+8NDv/SEHq1p5CfxVKIe/rDlXxyMae4ic+RlXBGFJvJUHhpCK3mcIEczVPqUgHOcd3O3PW4X
 2o5b8qjsLkvB/DTT8wRgy93Ob+DiN+F4z6R8vFMY4hU0/G+QWJsS4W6
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60A:EE_|DS0PR12MB999313:EE_
X-MS-Office365-Filtering-Correlation-Id: e50df681-55c3-463a-8fc8-08df48bfa654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|1800799024|6133799003|18002099003|22082099003|3023799007|11063799006|261026140227099003|261021123027099003|261022075727099003|261022105027099003|261028144727099003|261026121527099003|56012099006|10067099003|261009223027099003|261102123227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	u81VcDNfoz5VO+8f1ys27LwMnCZB+VSglhSSj4+i50r9apZQmNLvz2CSM19U97d502GlKw1X7+0VtAJOYzCA7l+ozAxFqlUsz9f6joxZSwCKw4qN0PihDRJbzH+OaqxFwr8/5Ps1qdeiU0pvwwoQAR3NYiRickdaNvijziUFV86p8k2AkSDabsm4qjSdfjzxPMcRHAWTOlginF1uYOLDjpuaqcWVpv8hLSwhwaMzZAJwkRuhq4EWpcPsMyPAuP+BsYKWG0smo3rLZA5DjlsM969IlW3wPWKVA+I/nmY27GF57OzX/f5o5fLJZ+iucSkwilihdL1jmfPV9Vwc/umJzshlHA8B9TfwY+aLNN0SuhYZg2wuazFg9Qgcn+oFMxZZgwoZaoEubl9DMsnqUQ4BHpgjNcNcND8YHZCcWl1IXw/7x3bFLAHZknhNoIoAWzUaPK2F8A95GjMIEGh3VocFtEPTLFREcNG1WtUTK1bXWHMkll84VvH3NLm4eb0vNyIwz/tE0EyNz9tD+xvqoqArf4XY9nvFDikPlpcCkgDkWIQMiAMhiTEHZbW1VKmVBtTYE+6JsMquvSFVwb8gnJT6mMf3Wi5x+A/Z2ze/RmTSXiGzQ6UYJ1c2fVOWOrEQASY3iqa6pRPZNms6G5en42XOymOKVJ6XBBGbuKuxCUggwx6vmWCpcBv7K7kXRFth5mFkcyFr6tXBSZKasO+5FhAqvA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(3023799007)(11063799006)(261026140227099003)(261021123027099003)(261022075727099003)(261022105027099003)(261028144727099003)(261026121527099003)(56012099006)(10067099003)(261009223027099003)(261102123227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XnsS+1wbhqE3Q24EEBpI3zJLvUUzeak2JcUo1XpXpcIYW1unhiNbw5zFwBvK8JGyEbGbM3WQV7wZyLtyHZ2kuEHR/SMP6NCG8gKD+DL6ZAvDSe8II7Sw3o5LXkXHFdLhvx95GWX2Z6WSb2B8KYQXlLkubg9lBlDhCe4oTaXr4gY4jzUKNbedPPTGDhylMsXwmBz77saGea/YZmaU7385hoNSymXEvaRpdh4Nb7En26lBcJLcdPH3QN+UmCNvT4JfjPXIwkoUkjTnWF1HUM/G1cFjGy4Ryo3/Dn58H5T2PGIT+wmXf5+PX/ELqyIMdqtuQkMFY39ucAmcJOXrMMJsVW0+q44V9I5Sc5yJPYRmTJT6naXZMCepyowim0XDFKkxhSPRrxUN0F1DFkV8v+ZbL8E+HHTNb45+K0olRaHROq4mGhBfAG7/YjOKno3Uc/Km
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:40:07.5569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e50df681-55c3-463a-8fc8-08df48bfa654
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999313

The device event notifier is registered after ib_register_device(),
so a port change during registration is missed once ib_core or a
client has read the port configuration.

Register it before ib_register_device(), as the system error notifier
already is. Until the device is active the notifier queues no handler,
so the P_Key change work still cannot run while ib_mad creates or
destroys the GSI QPs.

Commit ede132a5cf55 ("RDMA/mlx5: Move events notifier registration to
be after device registration") moved the notifier after registration
so that it is unregistered before the GSI QPs are destroyed. What has
to come first is stopping its work. A new stage,
MLX5_IB_STAGE_EVENT_FLUSH, cleaned up right after MLX5_IB_STAGE_ACTIVE
deactivates the device, flushes mlx5_ib_event_wq and then cancels the
P_Key change work, so a handler queued while the device was active can
no longer rearm it, the race that commit narrowed. A handler that runs
later, queued by a callback that saw the device active or by a slave
port, stops at the ib_active test now at the top of
mlx5_ib_handle_event(), which replaces the tests before dispatching.
MACsec event registration keeps its place, in a stage of its own.

The workqueue is shared by all mlx5_ib devices, and a flush may wait
for another device's replay. That should not deadlock: the replay
sleeps only on its own device's firmware commands, cache and event
handlers, and the slave port handlers on mlx5_ib_multiport_mutex,
which no flush holds; none of these take the E-switch reps_lock held
across representor removal.

Fixes: ede132a5cf55 ("RDMA/mlx5: Move events notifier registration to be after device registration")
Fixes: 7722f47e71e5 ("IB/mlx5: Create GSI transmission QPs when P_Key table is changed")
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 72 ++++++++++++++++++++++++++----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +-
 2 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8a9e68782a5c449e5565a098e75636d5054ee6c1..1e58aa132c5b5c6d6de694f298fe1d6ed11e4cd1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3075,14 +3075,12 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, u32 port, u8 sub_type,
 	switch (sub_type) {
 	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
 	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
-	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
-		if (ibdev->ib_active) {
-			struct ib_event speed_event = {};
+	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED: {
+		struct ib_event speed_event = {};
 
-			speed_event.device = &ibdev->ib_dev;
-			speed_event.event = IB_EVENT_DEVICE_SPEED_CHANGE;
-			ib_dispatch_event(&speed_event);
-		}
+		speed_event.device = &ibdev->ib_dev;
+		speed_event.event = IB_EVENT_DEVICE_SPEED_CHANGE;
+		ib_dispatch_event(&speed_event);
 
 		/* In RoCE, port up/down events are handled in
 		 * mlx5_netdev_event().
@@ -3094,6 +3092,7 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, u32 port, u8 sub_type,
 		ibev->event = (sub_type == MLX5_PORT_CHANGE_SUBTYPE_ACTIVE) ?
 				IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
 		break;
+	}
 
 	case MLX5_PORT_CHANGE_SUBTYPE_LID:
 		ibev->event = IB_EVENT_LID_CHANGE;
@@ -3200,6 +3199,15 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 		ibdev = work->dev;
 	}
 
+	/*
+	 * Teardown may have cancelled the work the handlers below rearm. A
+	 * device seen active here stays usable until this returns: the system
+	 * error handler runs on this same ordered workqueue, and teardown
+	 * flushes it before releasing anything used below.
+	 */
+	if (!mlx5_ib_dev_active(ibdev))
+		goto out;
+
 	switch (work->event) {
 	case MLX5_EVENT_TYPE_PORT_CHANGE: {
 		struct mlx5_eqe *eqe = work->param;
@@ -3217,9 +3225,7 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	}
 
 	ibev.device = &ibdev->ib_dev;
-
-	if (ibdev->ib_active)
-		ib_dispatch_event(&ibev);
+	ib_dispatch_event(&ibev);
 
 out:
 	kfree(work);
@@ -5095,18 +5101,32 @@ static int mlx5_ib_stage_dev_notifier_init(struct mlx5_ib_dev *dev)
 	dev->mdev_events.notifier_call = mlx5_ib_event;
 	mlx5_notifier_register(dev->mdev, &dev->mdev_events);
 
-	mlx5r_macsec_event_register(dev);
-
 	return 0;
 }
 
 static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
+{
+	mlx5_notifier_unregister(dev->mdev, &dev->mdev_events);
+	flush_workqueue(mlx5_ib_event_wq);
+}
+
+static int mlx5_ib_stage_macsec_notifier_init(struct mlx5_ib_dev *dev)
+{
+	mlx5r_macsec_event_register(dev);
+	return 0;
+}
+
+static void mlx5_ib_stage_macsec_notifier_cleanup(struct mlx5_ib_dev *dev)
+{
+	mlx5r_macsec_event_unregister(dev);
+}
+
+static void mlx5_ib_stage_event_flush_cleanup(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int port;
 
-	mlx5r_macsec_event_unregister(dev);
-	mlx5_notifier_unregister(dev->mdev, &dev->mdev_events);
+	flush_workqueue(mlx5_ib_event_wq);
 
 	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
 		cancel_work_sync(&devr->ports[port].pkey_change_work);
@@ -5230,12 +5250,15 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
 		     mlx5_ib_stage_sys_error_notifier_init,
 		     mlx5_ib_stage_sys_error_notifier_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
-		     mlx5_ib_stage_ib_reg_init,
-		     mlx5_ib_stage_ib_reg_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
 		     mlx5_ib_stage_dev_notifier_init,
 		     mlx5_ib_stage_dev_notifier_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
+		     mlx5_ib_stage_ib_reg_init,
+		     mlx5_ib_stage_ib_reg_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_MACSEC_NOTIFIER,
+		     mlx5_ib_stage_macsec_notifier_init,
+		     mlx5_ib_stage_macsec_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
 		     mlx5_ib_stage_post_ib_reg_umr_init,
 		     NULL),
@@ -5245,6 +5268,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_RESTRACK,
 		     mlx5_ib_restrack_init,
 		     NULL),
+	STAGE_CREATE(MLX5_IB_STAGE_EVENT_FLUSH,
+		     NULL,
+		     mlx5_ib_stage_event_flush_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_ACTIVE,
 		     mlx5_ib_stage_active_init,
 		     mlx5_ib_stage_active_cleanup),
@@ -5293,12 +5319,15 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
 		     mlx5_ib_stage_sys_error_notifier_init,
 		     mlx5_ib_stage_sys_error_notifier_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
-		     mlx5_ib_stage_ib_reg_init,
-		     mlx5_ib_stage_ib_reg_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
 		     mlx5_ib_stage_dev_notifier_init,
 		     mlx5_ib_stage_dev_notifier_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
+		     mlx5_ib_stage_ib_reg_init,
+		     mlx5_ib_stage_ib_reg_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_MACSEC_NOTIFIER,
+		     mlx5_ib_stage_macsec_notifier_init,
+		     mlx5_ib_stage_macsec_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
 		     mlx5_ib_stage_post_ib_reg_umr_init,
 		     NULL),
@@ -5308,6 +5337,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_RESTRACK,
 		     mlx5_ib_restrack_init,
 		     NULL),
+	STAGE_CREATE(MLX5_IB_STAGE_EVENT_FLUSH,
+		     NULL,
+		     mlx5_ib_stage_event_flush_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_ACTIVE,
 		     mlx5_ib_stage_active_init,
 		     mlx5_ib_stage_active_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7e1e0bcd096c994473dcfe2db5655b47bd48915e..53ca49e6c4b4b6c7bedd3a1cba57a2dd5fa5093f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -937,11 +937,13 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_PRE_IB_REG_UMR,
 	MLX5_IB_STAGE_WHITELIST_UID,
 	MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
-	MLX5_IB_STAGE_IB_REG,
 	MLX5_IB_STAGE_DEVICE_NOTIFIER,
+	MLX5_IB_STAGE_IB_REG,
+	MLX5_IB_STAGE_MACSEC_NOTIFIER,
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
 	MLX5_IB_STAGE_DELAY_DROP,
 	MLX5_IB_STAGE_RESTRACK,
+	MLX5_IB_STAGE_EVENT_FLUSH,
 	MLX5_IB_STAGE_ACTIVE,
 	MLX5_IB_STAGE_MAX,
 };

-- 
2.49.0

