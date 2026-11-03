Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724951;
	b=nS0EE9oN/Ro4N3rm6vbrNT5Hvff3UdHQxlZZrfpASTMwjR8xVAMemG0Om+5dQmTFkR8N
	 g868vs4jO6375hGLg5u0DBauzryTIbcb86mWmfSk7pZg8qRf2f+aqJ1VbAIYIQRV5M4Id
	 iK89FR7yScs/fq17vUA6kdCRoycu9/yX85Qc7s/UH9K2HUnp5AjJiEFRMeDHGHzd/ksq8
	 U3LAhfm8apOPbRG5eZUQZoiE3xKiPg7l8CBsYqNrFzZgGWHiHBZUFfCUYmb924dWk7TUs
	 bbIBPinWThR1VQ7r+bYn12Iao9j/M8WEfydfMiyVd6xOESBEjTetlfwiEzf+umvJ3GQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724951;
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
	bh=LBk8C1ELl91bnpLDdyGUuhWYP/5zgf4UtkDKVMMkqBk=;
	b=Jkh9f+V6LYgEQC2QoT4hpU9ambB8HWL5WDLOwvEN8Md/UGfzh9pnEHHXGqGtqCvq0v2R
	 yHXG+UU8GmoPifBkWOuDPIeeWyfALdhQAlCGFOjaPljN4iQOwmsuGoiXU/mlzEMgzcxPT
	 zMHvBKSjy4KqY39xXZlLypnX4WouPlEPF128UaQwIaQfkCSg6ds6weTb3f8RN+iKhgpez
	 g2nuhsTnwmElmDMwHXQabR+POM02+DL4TvfOQgviqoCM07kKZTRq3asYGFd+sPQGw5xAJ
	 okAsUSR5LDjOFM96Aik3ZaOqYKpoK3w1AviDbuopomypiKmfEApd37/Ypy/aNetDo1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="tsS7J/H9";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.60
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010060.outbound.protection.outlook.com [40.93.198.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5215606A32C;
	Tue,  3 Nov 2026 16:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5215606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tsS7J/H9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0qD18ixshTRiHdWON597PC5u3NCCXWLCQCmnBQgRLM1H9qV/lUQNYC+4MVLCehiUYhtw1v+WrFQYylRVWdw8VqObe7o9qIcnmlA9AbiPm81EdbIKd+KJbNOf8r7AwfCtuDQWWWSnL+eHIxvN3eEhQLARNaT14sWzucWURUbJJCKPysz/JOdxO9GVg69W/v0U8IKvGE9Fs64roWlkoaw8+w8o0RHQS2BY/1wsikhxFgJ/eDX52Bvv8thQDqxl7yvr2VJajzr2TVnZcK8CG116SyqIyqvWKyjVD2RUm8kjd5+OvwtQLk2U1kzG9TU3LWOdnUmITF+KUwJ2H7OTLfwTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBk8C1ELl91bnpLDdyGUuhWYP/5zgf4UtkDKVMMkqBk=;
 b=AYWV4CR6RsWlzwm0zHCAeeE7joycJNDOXIFjJKxCzt8Bf2bqnebZK62KctVbkXdxtH8mJYlNNaTWqCtFnfSBI/tuSvRmkL6QN/L3TnWEHJ+GNbMNzxN+xiooUPDfBUPa5AQvLfhOHC1OlRxbbqsjJ2ZmSSZQmrGoEQtZFd5JcpGUGsZfPtr2a+5IpPcuD6aP8QC6t7udUMC5ynBVMHUfxWsyBPAWrsNlApOUZdnWI2A65+qi9YUKy6jtBA94RB7C4JN29LOIbZ5a7O7fgGbo6GV5b3UbDMeSWcIOFWPqJnFIxxIVOgnvP1HqDNBPCUKJUIYtgSK9Dxuyt2J4ONrkFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBk8C1ELl91bnpLDdyGUuhWYP/5zgf4UtkDKVMMkqBk=;
 b=tsS7J/H9/ktA0S8y5nss48inBQNoeyQdy3rUxhqVqfl/4YMe8N1DfUQY+in2cLZ8z8bysVmSk781TBhuqaqWYbB4160hUJPeXNSSIOmvpEJq9DLuxqGjKhgfagG1WZnanVhb73wssteXYccyPCO6v/rJumIpShAs7oZhM2ykblIBRUXuVVZNAUa6BVi8giJ+tRgPcSwKEQ3pjpW1DBiOvaNN5Dyq6Dow8ATFRuFsmBnx1ounqN9XeqxTBDJKacEFVIcEklGlw2A8MTM6YBZme/ZcaGn3aijhqwl8L3SS6KpmWAMrVwobHWsMEeCes++B3t9zEeR/1gyzG86DaTxS7g==
Received: from SJ0PR03CA0331.namprd03.prod.outlook.com (2603:10b6:a03:39c::6)
 by BL3PR12MB6594.namprd12.prod.outlook.com (2603:10b6:208:38d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:55:45 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:39c:cafe::91) by SJ0PR03CA0331.outlook.office365.com
 (2603:10b6:a03:39c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:55:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:55:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:55:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:55:22 -0800
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:55:20 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 3 Nov 2026 18:55:19 +0200
Subject: [PATCH rdma-next] RDMA/mlx5: Free software WCs left on wc_list at
 CQ destroy
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
Message-ID: <20261103-free-sw-wcs-v1-1-3885ce449012@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAPYR6moC/x3MMQqAMAxA0atIZgOtShGvIg6lTTWDVRJRQby7x
 fEN/z+gJEwKQ/WA0MnKWy6wdQVh8Xkm5FgMjWmctabFJESoF15BsQ+pM947l2IPpdiFEt//bQS
 Jq8dM9wHT+377vhnnaAAAAA==
X-Change-ID: 20261103-free-sw-wcs-8cf40aa66fd8
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Doug
 Ledford" <dledford@redhat.com>, Haggai Eran <haggaie@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Maher
 Sanalla" <msanalla@nvidia.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793724919; l=2741;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=H43TbzbZ8QmyI4tWJBnJfwoaFKfFoUtJUMM617Zr+q0=;
 b=H1l5VlCGSJEXUlCfZ4o3AO5z/JNsfo6WUAkJWUQIMqb9YaSl/ogsN/txvL91cO9hoRH98K9Ey
 f5KvTVjNpNMAKFkfwMlrAawhVXY0l1ujydi8dhUzSqMmr+G22UPVNof
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|BL3PR12MB6594:EE_
X-MS-Office365-Filtering-Correlation-Id: 54180591-0580-45dc-d877-08df39cb4d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|1800799024|23010399003|10067099003|18002099003|261022105027099003|56012099006|5023799004|11063799006|261021123027099003|261028144727099003|261102124527099003|261102123227099003|261021121427099003|261026140227099003|261009223027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	HFbIHRwgLM7fFBrYbMWdFLrI8EK2DuOUKJT9GTteyB9klwzazCoXEoA9/5y7diTlpRl0n76J1V0fb6ahpNczKhvJOf1gN7rLcDOb1mHr6iiKnA2JQcY7+aUwC84dZeJK+7MVUevUG13KZoorj1wj7/EFqIQYKt1XbpXkje7uTKclqz8A9K2x+IggGuubVkhSx62pr8/aGCBfQcN+xawmuiViabRmZAu8qY2AjF8ompau8/LNGSnpNqMPran8d2Hj5PilrIFEbMEhk1gZFUgecNsdbsi56mxidci+zbESoVnMHtWNw9BBnT1QvL0Ri5zNY4g2Io4mpHI8yx6+zYhivYvBgzgGnowhb1apLOEU8LrfmehIw2LdWeumotc3uf1B0mL9sLT1aTxv9FW1pJT1ipmRjiJsqYnS3jDDVKJrhE5sZl1G/FFsC8dGo7C4rLaRi2l6j021ayiLoTAKB3pKqj9IuckczijvfcbI2Mc825LJai9bmNHjnbHEKeUuUSQRElum7jIhH/BJktR5oMsekyC2CEq+sbOnxF+P9XTsYmi9TaJNYKWgJrjvncBwGlGhq3xhLnj23AojF2A+bJsKwuGxbiQtF3JobawQyLLhk9ZGQVUFDtQz1nVYNgSZkz48veRdjAEcAc2jUsNzJ52Y2AEHiw5SF3lv4EVNeSunziPzfOqAM5RLrePT7K4S0Sn48K5WhyVMiaZVtU0Lr/d5Eg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(1800799024)(23010399003)(10067099003)(18002099003)(261022105027099003)(56012099006)(5023799004)(11063799006)(261021123027099003)(261028144727099003)(261102124527099003)(261102123227099003)(261021121427099003)(261026140227099003)(261009223027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t36Pj56XNr91E7RsWfdLOWc7VnP6DVfpQu32AX3er0TmS+//RurxKdPfREngJQhJiHI8fvvQVlAbD3URvz5exYPfcItagIy4qVvnSA8PWjsS369oK41Z57ZH15D8tk27rBojh64KJrlHVswTufOgebgLzG3pIVS2UGOj748xg85TCaTgFwCidL3tEttwD3eB954qCXCaOxXDNIDcIKSRCEFx3At9Pfr9l+iadORMqPskLExJN21TxE4cNVJtyvBCzxIYXvKta9efJy2BkaBAYyM22qcpAhhEs+M8I6vvv5IjClIibxbVBR/nXFn6mhj1yRcZ7k8mnx+Y9YujkrQA98TgPgWOS0hkufTZWCUYU3CGc7kbGQyDRxBFVzf3joX93B8AFM424aX6fJB68SfbDO26vQuqAE5O1Yr8VdEjhlCq5yFl2ewpGFo+dhtXFxpc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:55:44.4584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54180591-0580-45dc-d877-08df39cb4d1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6594

Software WCs generated by mlx5_ib_generate_wc() are allocated one at a
time and linked onto cq->wc_list. The only thing that ever frees them is
poll_soft_wc(), i.e. a consumer actually reaping them. If the CQ is
destroyed while entries are still linked, those allocations are leaked.

Drain the list in destroy_cq_kernel(). Nothing can be walking wc_list by
then: the poll context is the only walker, notify_work the only thing
that can re-arm it, and both are stopped before post_destroy_cq() runs.

destroy_cq_kernel() is also the error unwind for mlx5_ib_create_cq(), so
move the INIT_LIST_HEAD() of wc_list up next to the other list
initialisations, ahead of anything that can jump to err_cqb.  The driver
object is zero-allocated, and list_for_each_entry_safe() evaluates the
next linkage before testing the loop condition, so draining a wc_list
that is still all zeroes would oops.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 55ffd7d4de517e6ce3f04c98b4edcd94b12e43b3..2f7ac350c3d8f179ad1d4d8c1181b93f3151c7ce 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -933,8 +933,19 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	return err;
 }
 
+static void drain_soft_wc(struct mlx5_ib_cq *cq)
+{
+	struct mlx5_ib_wc *soft_wc, *next;
+
+	list_for_each_entry_safe(soft_wc, next, &cq->wc_list, list) {
+		list_del(&soft_wc->list);
+		kfree(soft_wc);
+	}
+}
+
 static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
 {
+	drain_soft_wc(cq);
 	free_cq_buf(dev, &cq->buf);
 	mlx5_db_free(dev->mdev, &cq->db);
 }
@@ -1067,6 +1078,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	spin_lock_init(&cq->lock);
 	INIT_LIST_HEAD(&cq->list_send_qp);
 	INIT_LIST_HEAD(&cq->list_recv_qp);
+	INIT_LIST_HEAD(&cq->wc_list);
 
 	cqe_size = cache_line_size() == 128 ? 128 : 64;
 	err = create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index,
@@ -1102,7 +1114,6 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	mlx5_ib_dbg(dev, "cqn 0x%x\n", cq->mcq.cqn);
 	cq->mcq.event = mlx5_ib_cq_event;
 
-	INIT_LIST_HEAD(&cq->wc_list);
 	kvfree(cqb);
 	return 0;
 

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261103-free-sw-wcs-8cf40aa66fd8

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

