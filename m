Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020143.outbound.protection.outlook.com [52.101.56.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78235411F96
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.143
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773487; cv=fail; b=ZQOBaJT60t7iWNgA4YlVWmcft30Y4R0bG8tFaGLk6jAbQREa1iNg0d9c7ZXQy4dwa2dJB6vw9nX8fETY39WigP5njfwx5vrMP7ouqaARLtUUK4m/h+s6Ndl4W0Xqhcpt8M7wXpfXm/f3szzo0wTFyqSQ8YQPG6PpqhPfBFCH/sY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773487; c=relaxed/simple;
	bh=3XIa2h4vh+2PTS9h7HQYkBd98z/VO7+CrG2sfY/cJn8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D066oxA9mgK9rzgMdywwehQu5eRveKnVbdSturlH0ZFGhfSwwbna14HU0luoFEWJwX9zOvHCaGQ+nj275wegIkCAwIOd6r/ycTxIJGGMY5v971TzJGtQeUHcFzA8MiwFnoF3aILxZSMwikiUGh3ixKblnMwtNdWvZ86T9oarr1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=Cq4ek/sU; arc=fail smtp.client-ip=52.101.56.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="Cq4ek/sU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ppbDJl8Ec0QMCyha3NBCZPzutpem5omAgRbIc1ZzQtStSnynAZbRwsfQtVM+yNo32PXyHV03K1uzHhWV5kANrQuv7AdKnNakgDERxRTk+SsxOpzFvtjaRoP7dMAOb7xT4p3C3OvbgrXalsW1BLSKo+KsFVUQk+s895ZlkyGidiAQrB86SKzg6YJUyuK39WjVdu0epwoe8+2TASBKtFzLGYJbIGs2vAOvh5pTQ6ellkvpEhON3KGBggm2F0wU+QTdkTqzAJhnbCYJt4bxXGP76fboxeOOrpH75QtMNtdOosaU84L3wC2xn2+C8e1ef8RwbPNczlYkHrVf+5IJ6R90PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjyWytTAb0qZnFae+sivNc/e2W/gdo91CMBSSTLVaG8=;
 b=NvpXxRg4FXA5UW7RcCLRR1qPjMu3XAPD1cirghZUvqGEWzkXBwVRbPtGl45i5nV5e/j3UGm8MEW8y102z5UHMSv9VWpiBMl2c1oc4xBroO3Nwbx0cr/3qKPTkrbODRRCwcQYegjrEq2uzHs0bFJ61BePvZZ9Uv4qT9lVWq2yHi1aApomx2hZcTw+bNFNrnTB4zJOvPaLRu17KgVkho8Xtu+nmu7AHBFgknkWFXmqMdKeKz0R9gSr6wbI1PgdS7DNdTKEQuxr48qhRx5IHXHAlGzuvVkqk1GPZaPnojrUsbfBQJdyTuJYgUT8i1ej2vO6Xvi60WbvCQtyTmTzZq0naw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjyWytTAb0qZnFae+sivNc/e2W/gdo91CMBSSTLVaG8=;
 b=Cq4ek/sULPmwK2oLgW+UX+PDDJm6zZCZ7rkkNjkPGa/H1IfJbep2tDS5pUay14cwgg9hjJmgGTZz+wEMSnN2upuPNdvTxNN2mj/BEB1DjeNtKGXWlZOWT4oMbYyM1woBrZ+0U3qI7z8NmGLo37iq/WF8ObsMCT7nrHjzuOH14ulS5k1fwT/XoY6xgR8mPHCUVq304Q/kCVLAIEMS9nvVRFr3saDSo/p2r1y6itR/qTts4YrQWbqyek1xobNSRle9aQwwB/MoUcWVaqUdwTg0Z6S4ScoyUSNd0sbroQTNXu7+++2i7LBC2Qv7M2+4iIAU1Jg6W0zOdtQ7lLr+jdQaKg==
Received: from PH8PR22CA0013.namprd22.prod.outlook.com (2603:10b6:510:2d1::11)
 by BY3PR01MB6657.prod.exchangelabs.com (2603:10b6:a03:356::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:11:18 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:510:2d1:cafe::23) by PH8PR22CA0013.outlook.office365.com
 (2603:10b6:510:2d1::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:11:18 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:17 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 5EB951D7180;
	Mon,  3 Aug 2026 12:11:17 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 590C51810DF01;
	Mon,  3 Aug 2026 12:11:17 -0400 (EDT)
Subject: [PATCH 5/9] RDMA/hfi2: Fix use-after-free in PIO and SDMA map
 teardown
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:17 -0400
Message-ID: <178577347732.1793053.13152251769397445815.stgit@awdrv-04>
In-Reply-To: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
References: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|BY3PR01MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: 75195c12-a751-4ef9-3d87-08def179d9d1
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|55112099003|18002099003|22082099003|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	bj8hkTLnKTW2OvuSFPYMMj/rzo4FQYc5cBOIhbObfw+rXSUYg3J4CG85zkx/6E3u2uBW/dUxBGRzVnh7Iz/qvmFK3QaqwkpW9y1QA7lS5E9WbhE4+JI2qnzQPdbf+4F6CGKfEBV/8dsoofPHIZcSYYqKD7gB9z1NWydUndQGJx+YFY4Hzp+4I8+DZUvZgH1zPWxu+ETc4P7Yw0fybpe9DYVM735weeTKZlZQG2pJNaUfehNWoDRlkX8Zi9dlOgvHZtmNGZ9kM5l8YC2c9GEWcQiF8WqO8VPSOiNu55Pm0UJcc5ZlQ0HNEpV7ZBVLmrikJgafAAqyHklCxQsT+m2aHjVlnNycyT5/KReqA1zaei/AlHFHpfqtSufyoENeoLl3DCckRyUfV6bpCGovGJJtcf0dtU84iVQpZi/oZur4o2ma9S+o/hjieJvQGyQMkQNgQ7Xe69TVjMMdh2my/ztfZKRHYEb0T3QXdgq4eue+2g+qbS2GffuHX4DnfCU4Sg8hhZg9niBPSTK2UR91Mmg73G36JHPCrQGaH/Izk33n9jeY4fnf2x3S9VjsmTIJZE2HCSiEVh9I1nXYyg+zlhIHKugreUoRD4hQNqKwCQMTTH10w2RgjMGA2M2u50zOj4SJ3fEkdCgKX8g9FZVTWzBnRYaN5Y0W5NF0rpqL4hoJiLYbFzQ7CsyS8Udi8oxRXCya5K7cE4+oeYukjRw1Kapjcg==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(55112099003)(18002099003)(22082099003)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9hY2T6A+N3UwSNSkkz8/YQl61ZqI0VwCMhJ6x0WO6yMqSLQ6sQTDp5XXby+eLkDs2W2llzUZ7jL/j/2uWx8pb6Bv1qfJ5kCZmVHRG5v7mck1o/wzyObzz/etq0nJVTj/yi809KQuklB9gqclD7MTQqMWPd825ATud0GULka5XFZnnix3lBHkZel0ZsaJIBHS2kllDl8j6RXHXVoii3B3fe/7p/G8IxLqYZOld99jG9aP22xGacmqEq+LOGpdQqkTiy8rAKQWEq1APnQu7NKz85kCh9Pb4dgWAvyauK0dRy4bPAjIw+aqokRfx32DadNJmhankQFWPxNGcUKq04KhMbPn/trw74P+lFgm24SQXl3r3Bo51qw36WUbpVS7X9u1jH7L5m67lv1CPsBXAgy8LbSkK3TjEGyC3tnnu+yVDQsHN/8LTifKeyb4O68eFcJT
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:17.9459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75195c12-a751-4ef9-3d87-08def179d9d1
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6657

hfi2_free_pio_map() and hfi2_sdma_clean() free the RCU-protected
pio_map/sdma_map pointer while still holding the associated spinlock
and before calling synchronize_rcu(). This means the memory can be
freed while a concurrent RCU reader is still dereferencing it, since
the grace period has not yet elapsed.

Fix this by saving the pointer to a local variable, clearing the
RCU pointer, dropping the lock, waiting for the RCU grace period via
synchronize_rcu(), and only then freeing the saved pointer. Unlike
hfi1, hfi2 maintains these maps per port, so the fix is applied
inside the existing per-port loop in both functions.

Matches hfi1 fix 76b48a70b16b ("IB/hfi1: Fix potential use-after-free
in PIO and SDMA map teardown").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/pio.c  |    4 +++-
 drivers/infiniband/hw/hfi2/sdma.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/pio.c b/drivers/infiniband/hw/hfi2/pio.c
index 90fe6bb14b09..4d457dd69c59 100644
--- a/drivers/infiniband/hw/hfi2/pio.c
+++ b/drivers/infiniband/hw/hfi2/pio.c
@@ -2052,6 +2052,7 @@ int hfi2_pio_map_init(struct hfi2_pportdata *ppd, u8 hfi2_num_vls)
 void hfi2_free_pio_map(struct hfi2_devdata *dd)
 {
 	struct hfi2_pportdata *ppd;
+	struct pio_vl_map *map;
 	int i;
 
 	for (i = 0; i < dd->num_pports; i++) {
@@ -2059,10 +2060,11 @@ void hfi2_free_pio_map(struct hfi2_devdata *dd)
 		/* Free PIO map if allocated */
 		if (rcu_access_pointer(ppd->pio_map)) {
 			spin_lock_irq(&dd->pio_map_lock);
-			pio_map_free(rcu_access_pointer(ppd->pio_map));
+			map = rcu_access_pointer(ppd->pio_map);
 			RCU_INIT_POINTER(ppd->pio_map, NULL);
 			spin_unlock_irq(&dd->pio_map_lock);
 			synchronize_rcu();
+			pio_map_free(map);
 		}
 		kfree(ppd->kernel_send_context);
 		ppd->kernel_send_context = NULL;
diff --git a/drivers/infiniband/hw/hfi2/sdma.c b/drivers/infiniband/hw/hfi2/sdma.c
index a48c548fadc2..8dbeb8ac2f72 100644
--- a/drivers/infiniband/hw/hfi2/sdma.c
+++ b/drivers/infiniband/hw/hfi2/sdma.c
@@ -1376,13 +1376,15 @@ void hfi2_sdma_clean(struct hfi2_devdata *dd)
 
 	for (pidx = 0; pidx < dd->num_pports; pidx++) {
 		struct hfi2_pportdata *ppd = dd->pport + pidx;
+		struct sdma_vl_map *map;
 
 		if (rcu_access_pointer(ppd->sdma_map)) {
 			spin_lock_irq(&dd->sde_map_lock);
-			sdma_map_free(rcu_access_pointer(ppd->sdma_map));
+			map = rcu_access_pointer(ppd->sdma_map);
 			RCU_INIT_POINTER(ppd->sdma_map, NULL);
 			spin_unlock_irq(&dd->sde_map_lock);
 			synchronize_rcu();
+			sdma_map_free(map);
 		}
 	}
 


