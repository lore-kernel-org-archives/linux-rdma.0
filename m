Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132AA2F83B5;
	Thu, 23 Jul 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820280; cv=fail; b=DNJDbOQGX6WxOAzuEQFeuZMBn4Klzu1VEkdWIfYOZRk+r0BHgfUSybf2cwMbq104Ik/aPuplSCt8V2jDbTcjKtNkPFoeyCFZgjjtJBkDxTVAWLsx4Sf9k4i6UgOhDM0M+0tLNWUeLBKqfwqLJ44Nz15i19P4e1+T5JbHkt15oXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820280; c=relaxed/simple;
	bh=7/GpQetmSN5QA0aTRvqOl0BCDz59bmjH9Rhx1K7X6HI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=LZOPDZAa2miiusL7Qga0BgkOWQxTlBg3+OnXoX6pVCROz9jlh2tdg7emZbEL5ZKcMDkQeNSCZU6jFjuuoyfUGGvRlpl+kGMv6wEjxuaXMHSwh/VoePg7hzKY5X0xIz35orYIZsmdbWpKKO1jh9yJFY0osIGPi4f79V8xpRCEeAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q9dHgjO+; arc=fail smtp.client-ip=40.93.198.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q9dHgjO+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YVoLWq9NxefeqMplxmb//U57PQkgoUdNCSGzPVK6zWRFTMWaCJ4EN7B54GCop8AM2piK0UR7ieKQVdrEuOmeYZLRZ1mzwhTdxqXIdXgKfUIEAKQF3q5Oqxe7nTHQQw+YmH4U4kGg0yN39219iiBaI6ioocXC+DIOViTNwpFLSFayy4UEOFNLqmtE82KRKZ4RFGB1AS7GlN2JKcaQJxzQICUr9mvKbVihwIx75A1ZAwfend0PR/JGvYcadVgOWG76rC+9OsKwuvADHyQmHBrrgUd3E3nL5SLCjry0eGEc1v6qGgBQUZsRGiBK60PEHnRGsE1FRTph8rM9l65Wgz5qYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmJJ47+7KdEEFRw1sQLK8yAcd1k4L8j/SGaviWuQbcc=;
 b=APVgzB6XXDN7dX8wIDuTaGuPzk3cZTZr3sLlHuia9m1RrGFMnnguKqQoeNNgRmH1QvphyzukuyxDacJ+KoNLixsibk8MYJJEe4i2swW8qnXvNmxqbPUunKL6o8q9qEBaUlDI9mCthOkyJdYixWQCkvGhcXgmDSLfuBr2ZoAfMb/zhRpHFNASfQPmHUs6T/Jhgn7zGvEduJYxqKvwD4k3vY20/jpac3UPcqTILL07qJNjxTMdFjZX6THjViARTljCBHGN5plMz6XLFERxb7DDvC3wHhLBtxht4uWjw/jLGAIYkuC84yDdTKVbEPHEKkj6vkGtMzWjP/2TiWtfrxgqqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmJJ47+7KdEEFRw1sQLK8yAcd1k4L8j/SGaviWuQbcc=;
 b=q9dHgjO+K0IBXHFaT08LEcJ7CwmNck8k7h1q4xSjs+Kn7WAOGddxhucDqTWdDTexCp+2UU1G6ZCfxwQy3lZYl2b1V8s9UatSGUt1K1ck9/UahPJhlxYF7sPeT3kqHY29+YqXNjYKrenTuwE2/FhC99WB+8aQNjC7AqDb9usNyL2uz/DTlsdxv97lhpgr62LKstA7kA6k4JJ/Pr/XPalO5gSXxQ+/f7Og/sLkHf2FBPAPZZDOnMzxKmKOh2jGgBhk8HP6bPjgQOwnijoGay3G8ziLqW6kCgNL3Ji+YB6iG8IXp6M6nlYfjs4KkdQdclfNt6m493+xPsBFd8q1jNXCNQ==
Received: from SJ0PR05CA0204.namprd05.prod.outlook.com (2603:10b6:a03:330::29)
 by SJ0PR12MB6968.namprd12.prod.outlook.com (2603:10b6:a03:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 15:24:22 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::a0) by SJ0PR05CA0204.outlook.office365.com
 (2603:10b6:a03:330::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.8 via Frontend Transport; Thu, 23
 Jul 2026 15:24:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 15:24:22 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 08:24:12 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 23 Jul 2026 08:24:11 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 08:24:09 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Thu, 23 Jul 2026 18:23:49 +0300
Subject: [PATCH rdma-next] RDMA/mlx5: Fix integer overflow of user QP
 buffer size
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260723-fix-qp-buf-size-overflow-v1-1-ccb05ee43a7b@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAQyYmoC/x2MwQ6CMBAFf4Xs2U1KMYX4K8YD2lfYBFvcIhIJ/
 27jcZKZ2SlDBZku1U6KVbKkWKA+VfQY+ziAxRcma6wzrW04yMavme/vwFm+4LRCw5Q+7IN16Nr
 auHNDJZ8Vxf2vr6T+2XPEttDtOH6Zrxe2dQAAAA==
X-Change-ID: 20260723-fix-qp-buf-size-overflow-df26e8710643
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Or
 Gerlitz" <ogerlitz@mellanox.com>, Jack Morgenstein
	<jackm@dev.mellanox.co.il>, Roland Dreier <roland@purestorage.com>, Eli Cohen
	<eli@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Maher
 Sanalla" <msanalla@nvidia.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784820248; l=3072;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=LKI5hT4TPn2vi7/ZaN42VQ4r/I9IsxDBPnjT17Yn9V4=;
 b=WXFxuywQPuppCz9k+4nycOSv6tEsWeK+4MndvPiqqnJAtkRR5jJn3Aq7cBvAihw44maai3rfa
 fdXSK+ILSdiAjO57fL5W0GUVdMaFSKcfzRiYqB0LOIy0mUXuuE/YQLP
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|SJ0PR12MB6968:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b9f707-cd11-496a-98ef-08dee8ce7923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sPhmYOGcQwmrnk3FAG1uQB+t2unWBBaINan4HuGwd599FdbPnseafQz8jW1pZnxKVam9HAlX1/rLhTk5sX2eSaUl1l/w78pHXfNuZm2oggXfy1cXNpe397T5duLEQFUv5buRUsMi+MkNfL9/dZJqE+aKxMObPnWnKRHnrD7WW0L76Xh/4nMtCDl0CyeAW4+Br3C9QBpPUQNeN+JU0xmpkvgfkCSdS8Jq0QKaSbo+a5FiOCNQG8PY8noUAGXUQoBrnZAxQ3kfHrb3BytMlwAMmKmbhH/YJIX8JC6UKGGUbxXvVFoEVfRr+7TI66XpYx3H8C1+t+WrOl+lQj2HFG3zmfC3qHrF8PUYjGo9/DxYVzopLvIRSLHcHNQNZp1TqRa8tub9rJO8dVW5Dsryq8sjayJsib4/brwnMhUjGbWAkjWu6a2evR8zJK9NjDOE83JX/dnWBH10sR1CwUr7TQofgh2hO6vCldkcmLUHkMQ0GMY1cyDtcz34mU+osY+0I8ZyJeqt94N9anyJSbzweXkS7QvvpZ9abX1lcJPXwwwfTwBUmamB2jKtf/htZ/47UG3cD5pZu6SpjlTvpoOXePh5Nf0MORLpJLNqAC+nIXJixlC1MnayHfUYnL7+RnGgPG5pI3tnADLKM1zoDavE4uznOce2V1XGzbWqPLl8dLdjCMRFuNjIjBVrzrwKa44vymVvzuUdSZchTjV3o57FClJxag==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qOHI69OBG8B25SUFSKEjFycBswhwGSwSU+0jS/jB4dusjZg23X3LGTFRZi0U1jFvUqXe3z+SpHFa4izT/2PIOefBPTL851940l0mHj/hTj9bHz0PDWTj92m8W+L2Bs/+1zfB1eAZuo1RykJcYzW+OSWIIb5n6GqUrrNqPKwwZ3l16oHYW2Bx1wBR0FLxIhlF1IBRKpUFFEB3XMtd5H5YtR0n5cl/ZxCd7oaj72h4r6WrfhCkO2CbrlnGHlJ8hbTF6I99PzqQaKgNvWfNvWulB6XpUjEC7PmNHShG7F2saMKNh052Dj8/7egywqcvGmruvA87KRe1m1ablIP5p1q2fLVhHQxA3TBZgPxDuCIMl7SCpPUcnFeaJRJq7zM+KU0cJPrGAa45Hwe4roARpXoYblhImBDXEoO6TshOdnd1fBYGKo6vRT86/+lHw7uL8NNE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:24:22.6289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b9f707-cd11-496a-98ef-08dee8ce7923
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6968

From: Maher Sanalla <msanalla@nvidia.com>

set_user_buf_size() computes the QP buffer size by left-shifting the
user-supplied rq.wqe_cnt and rq.wqe_shift values as signed integers.
A sufficiently large rq.wqe_cnt causes signed integer overflow, which
is undefined behavior, and yields a small or negative buf_size, causing
ib_umem_get() to map a buffer smaller than the hardware will actually
write into.

Replace the shifts and addition with check_shl_overflow() and
check_add_overflow(), rejecting invalid user inputs.

Moreover, guard the identical shift computing qp->sq.offset in
_create_user_qp() before set_user_buf_size() is reached.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7ff02d89c31d5b4db4c94453efafc0fce212acea..f2b45f16824e5f1bd7339137277c9e7d1aff69f4 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -647,6 +647,8 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 			    struct ib_qp_init_attr *attr)
 {
 	int desc_sz = 1 << qp->sq.wqe_shift;
+	int rq_buf_size;
+	int sq_buf_size;
 
 	if (desc_sz > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq)) {
 		mlx5_ib_warn(dev, "desc_sz %d, max_sq_desc_sz %d\n",
@@ -671,11 +673,21 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 
 	if (attr->qp_type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN) {
-		base->ubuffer.buf_size = qp->rq.wqe_cnt << qp->rq.wqe_shift;
-		qp->raw_packet_qp.sq.ubuffer.buf_size = qp->sq.wqe_cnt << 6;
+		if (check_shl_overflow(qp->rq.wqe_cnt, qp->rq.wqe_shift,
+				       &base->ubuffer.buf_size))
+			return -EINVAL;
+		if (check_shl_overflow(qp->sq.wqe_cnt, 6,
+				       &qp->raw_packet_qp.sq.ubuffer.buf_size))
+			return -EINVAL;
 	} else {
-		base->ubuffer.buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
-					 (qp->sq.wqe_cnt << 6);
+		if (check_shl_overflow(qp->rq.wqe_cnt, qp->rq.wqe_shift,
+				       &rq_buf_size))
+			return -EINVAL;
+		if (check_shl_overflow(qp->sq.wqe_cnt, 6, &sq_buf_size))
+			return -EINVAL;
+		if (check_add_overflow(rq_buf_size, sq_buf_size,
+				       &base->ubuffer.buf_size))
+			return -EINVAL;
 	}
 
 	return 0;
@@ -1004,7 +1016,11 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	qp->rq.offset = 0;
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
-	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+	if (check_shl_overflow(qp->rq.wqe_cnt, qp->rq.wqe_shift,
+			       &qp->sq.offset)) {
+		err = -EINVAL;
+		goto err_bfreg;
+	}
 
 	err = set_user_buf_size(dev, qp, ucmd, base, attr);
 	if (err)

---
base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
change-id: 20260723-fix-qp-buf-size-overflow-df26e8710643

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

