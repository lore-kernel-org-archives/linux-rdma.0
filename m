Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011050.outbound.protection.outlook.com [52.101.57.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0EE34FF79;
	Fri, 25 Sep 2026 09:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329025; cv=fail; b=GzDgdAW8rs2Y2Qu5AjwTFN+DP4d2KrwHfYZe8kNM6q1ux9uU2JXEetwmh5r5vhBLPYMD5d/R02C6DQzYxGXZbnaBHGCqZoX4EI/XluJNSnEatixQCTMSWrIeeQGj5SWOMgj/m5qdFEZt6thppUvMLsj0KFwEyEwIZyhFkZyM35g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329025; c=relaxed/simple;
	bh=1+pbNr4q0pAracGBN5HrgG+ZJg16T+BtCIn3PmehLas=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TjYJaUMhVsSkzhBZMnuXRqPkL8A2FkxhF6lypPWxn3iE19gL0yAFqaq4S2NUG6q+6d81/aJIIXkSzyi06LxOeuEXD+GDS/EXJGoN6fi521hZANfWulpqHfoWVyOzEUMx9KUK8iGfgSvyZafdJTfsOCi3BsJTpVcaIFZI/N5t2Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sk8lWO0N; arc=fail smtp.client-ip=52.101.57.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sk8lWO0N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kgThwECAiNS2DPqm/wMLoCoifUNlaCCvfair0LPA+ON6F1LnSNKcqvScuEy5j0bOS0qxLTTpSca5fja1dh4D11PySzWpEjzNyZDwFfPCwYAqNbixLLYKzN/tbeK8TcRbJQc5luWNZgxnoAHqGB1MLdl6BOMigTdevDsmYDSpczJqavG6urFYavHCwiHYR3p0ea9tIdyvM7IZOo87Wgd1z1dp5e5mWF0SwFJMmUHG+2WqDVGoBiHapRtTXjSrKTxbQxoy3VWyYV56Pv5Z+fdXx/7s01oYYmsZtquoCfqHlOhfslJcs/cdiznOuLTjry/Ew/+stEpiTFtiLC+fAmHsnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5ocx78QHcOYUmuKdhr5eiY6gcsu22GoGkUtcYWEZho=;
 b=M84S7nmy/1ReAwejhZ4XdLWl9SyrgF7sA8Vaf2q2Au2pe5Svodw3UxbgCieVAu8Jqz/8RSXDFn/BUo5QfOJMvT75Y/d7Os947omj0Lv3NrWX/fn1c5+fghHeo1iLi+7FwW5M79bqy4TMESyZaGGquFYqcQdeGW6cmCZfSS+ienwiiEP4qzLW6yWWmiwVkhdmcnIXnunxE/DmbK6kj270ezu6m942sPNxX72tH1at/Uwd0MHFPqN1Spw3GG1hHMgPRt9/A5PabWhGlA1XtGYJ6BAuIVIlXX4FgJBt6Erbxfb64KPqf7tYoI8ySWqwK4w9YazcWHsvD/19zdVSnx/a0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5ocx78QHcOYUmuKdhr5eiY6gcsu22GoGkUtcYWEZho=;
 b=Sk8lWO0Nm/Xk0M9rvW4481faAPdma4JSernxHxdGtZK8DlWjYjHD7jGUZx3a/Xzp1THuSO/VZgvjKz8iKIh2lP+0nOjSwEn/bYqIwOReEKexDhw92k7MTc3SQfmLEK+hTftd1cluBMGUoj1GTAOerppcvAdqt17I3QggOUReYDs=
Received: from BY1P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::13)
 by PHXPR12MB999256.namprd12.prod.outlook.com (2603:10b6:510:3ca::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 09:37:00 +0000
Received: from SJ1PEPF000023D9.namprd21.prod.outlook.com
 (2603:10b6:a03:59d:cafe::6f) by BY1P220CA0007.outlook.office365.com
 (2603:10b6:a03:59d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.17 via Frontend Transport; Fri,
 25 Sep 2026 09:37:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023D9.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.5 via Frontend Transport; Fri, 25 Sep 2026 09:37:00 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 04:36:59 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 04:36:59 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Fri, 25 Sep 2026 04:36:57 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [PATCH 1/2] RDMA/ionic: Fix XArray initialization to use XArray flags
Date: Fri, 25 Sep 2026 15:06:37 +0530
Message-ID: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D9:EE_|PHXPR12MB999256:EE_
X-MS-Office365-Filtering-Correlation-Id: dd2371b1-dcf8-4a4c-22fc-08df1ae88c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	dmlE+BLOjQw2mT3tBf12qkyUBlHdwDlpVq4URQhf3tmHSiPO/4WtjFs7lMoVdDsjvmngNpk6ghMV/xt8XBTxnqf9SJgQHW2l/YgY4eTVCNXnXXn2cTy548E8kBgJ/AE0gMwJqAK8qjnMc+TtON0mjsm9rzqhWDp6wY9AAwyrOpJS9wQqjGxfIRG3NDmnc1HWe1i5jp0NtDGckUtnkaz/lxznq59f2War+45brThMQ86/zePLIKFjCwcl4YitIEaLTKe+RESEIGUGMLpT4urBFSnctHDhh78oUpKx0yRrdDsj2+YX2GNfjsViZOZ8Y4bzIxWmBlGyo19rViu+QLH3FLwLoZpeJw3jT766/VGqHGUKOiFJsmIQ09DlXWIYbCpfAhoGLoYxO4LohmCm5K5EutIspoT3047BkdJJA6pTblD/spg3Z9BSZgDBDz0fYz9gWarsODSqtB0F9Y4t68Lw/K8euXhysMYAGciFfukhH/CTZLdVEme3fEi8Z+lb5Ra88FGJhNiMJY247N9/iHC4whXmq8cM3BJUnUv31F6f32amZse7DnaI/fydmK2DSrDTnq+s8alji6nqEbyKJfF6bTZuwyn8UtF+ViYv6BmZ3cVynsndkI7hBmhrHQZTyDfJoq7fzC8+UXQ1p0wEjoywLYf56GPZGYerA7D7gT/Tq5qSN968LUxbuQSpOLII2T0lUokFHpI1jOFzGoLV3mXa5A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OgjYpApXTGQD175+UvwGEgm2vZGpMrvVPoGx6um/Ynf55xRH4eRK/sEd9WD00Z7Yaj4W4WdC8jiDORY3uKm1rIcZWT6gXJl38rT84hhRCFHjmTakjVLHKF1heXpXnhgBxhsWQspN5zLGGpHHrAIiymNc5Rh9qN7QWnIH/3cOVNGgaIQO77ROwJ9kOLmpCcpeqcrbgpEC13Na3TcLIZExRDsz8bbAKf0mnlyS8TtTC53eyTzKNVHyO64k4RlGh72HhbH2stxjvtVyo1XFuqIKCbQ5rJRralr0y6dcM4NXgi7QfMzVcVb2rE5F6dc85mhprkJGhN1N1ICgKrv6+KYkiGN5JFEihhfL0+d2TeNjExBUEmnwC/x6PTHclDEUxzv2jSnarqJFbn6c81CVmATvw4O541Wt3H3MKrWu4dHP+l9O7wBPXgf6Djsb+98bIKHC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 09:37:00.0367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2371b1-dcf8-4a4c-22fc-08df1ae88c79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR12MB999256

xa_init_flags() takes XArray flags (XA_FLAGS_*), not gfp flags, even
though the parameter is typed gfp_t. Passing GFP_ATOMIC leaves both
lock-type bits clear, so xa_lock_type() resolves to XA_LOCK_NORMAL for
qp_tbl and cq_tbl.

Both tables are used with the IRQ-safe accessors: xa_store_irq() with
GFP_KERNEL from process context, and xa_lock_irqsave() from the event
queue path. When a store needs to grow the tree, __xas_nomem() drops
the lock using the recorded lock type before allocating:

	if (gfpflags_allow_blocking(gfp)) {
		xas_unlock_type(xas, lock_type);
		xas->xa_alloc = kmem_cache_alloc_lru(...);
		xas_lock_type(xas, lock_type);
	}

With XA_LOCK_NORMAL that is a plain spin_unlock(), so the sleeping
GFP_KERNEL allocation runs with interrupts still disabled by
xa_store_irq(), and lockdep annotates the lock with the wrong class.

GFP_ATOMIC also happens to set __GFP_HIGH (0x20), which collides with
XA_FLAGS_ACCOUNT (32U) and silently enables memcg accounting of the
XArray nodes.

Use XA_FLAGS_LOCK_IRQ so the lock type matches how the tables are
actually accessed.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_ibdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index cba7809ec3d9..fa79732c2f7d 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -320,8 +320,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 
 	ionic_fill_lif_cfg(ionic_adev->lif, &dev->lif_cfg);
 
-	xa_init_flags(&dev->qp_tbl, GFP_ATOMIC);
-	xa_init_flags(&dev->cq_tbl, GFP_ATOMIC);
+	xa_init_flags(&dev->qp_tbl, XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_tbl, XA_FLAGS_LOCK_IRQ);
 
 	ionic_init_resids(dev);
 
-- 
2.43.0

