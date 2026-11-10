Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318315;
	b=SQM/TfRCpZ54gYUjspw1y5qr1pPWxV0wV/y//Y3JbNo1Tj6BegopXDlJvdfPkmsgKYDU
	 s81YTxvvsAQuUPew3j0d3McObsMBw34XABhG/Y9hiAQxYlk3qJEnI1FSVTXmpKPHSHtZb
	 aA1N/YE1p63uNoSmTGljtrNTdRLwsKLGyfYfeKBrK4pA4lebyzkHp7HvNAYv/xiuDVXDQ
	 V8ilz8cRWUBFKo0rDehX0V31D1nxvg8iphz2p7Fu9iAYSD0/jFCswE+8Vpw3kj8y3ufqM
	 ix6AVgqVs5pIK+jhFFnNZ5/ky/yfpe8ZtNy6TsDZZWcBaQeBLusu1C1XNAM/oVVlVsw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318315;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=N7Cm5wqwgCYp2VwGitU9ARop5aWzZpKmxEfrua+HZow=;
	b=SObeL/g38aeN7Xfy8aJdA0RWtyokk2Rrmbf6h7Eg+vLy1hVx0+RfAvn4SSNYwYmCE3J6
	 uT2y7bF4nySG67pN3eebU64li8SbxO6MXS7YMdocl9BfNY9fO1A/qggSyfSh2UVN/QYu0
	 QHqBCrTHTwgXq3dnvTqQxCrEpIhrFkRDgR8ztPz0csiKeAxr0QUVUG4FwBH74EuvVPisj
	 3eRwNIfzLqdpjN86WFkuhlEt0PL5jxy8/MymZ8OUYVNO34vszxDQY/KiFa3XuIuxFBuDM
	 UqamDTISW4Lhp0ibihL7mfIIK5KLlBTW9OJRnG+lOo3MbNhltauckJtCDbHsFuatEmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=k8fZFDGf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.2
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011002.outbound.protection.outlook.com [40.107.208.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA33606A33C;
	Tue, 10 Nov 2026 13:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CA33606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=k8fZFDGf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZkFbH6m90sovff9kbdCCWl3nlQegWy6McEDlE+CJ7XTyljbumSRjG8c8XsHkJPNN1Jdj3gAYGgZIciAR610kR1bZvyY/v9t1aGk+BSaK7E96ZFAXag5t4rxh0jXV5E1rHP4k9sF83K+ohDq/iochtiz6g/VUXTshR0HZLSTOK5dhUHw+LIEF/Lj8YP1HCqapwlKoCgSIZY3pHtc1qtheLWU2tWZC1oIzj5/n1xZIxZWOt3isG5KkvV3cLHGieN0exypUlOIjD/XmzZHvA5Ln/+Vma2NMoju99rI+rbcvXqrgqY/OUskMZGgaK4ShufiE+d4hw4vNg6DFJkBbXfk8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7Cm5wqwgCYp2VwGitU9ARop5aWzZpKmxEfrua+HZow=;
 b=vsDFe1n4JKVci6eAv4MSAtEEhHyA8CSt+npw9gxB1j1zigGwvmMxzJRueLECACzTqQoyHwWDklLW9ZUKw3EiNE1RH+GTMxKEklOmXo7j3e0WlpOnNO9ZDBL2+Qh16zD/4O4X3RM6NNZJjEUUU7RSHDNDFr7E9lsictVRGVWZosyvTXlH0EgerH21ymmxVyiwoZ1ofh7llGCcuwZul88eRx9m7i4kaDg8T37H5zUxFBua46On8R9DSE8yA+fmusVACTsKW0iHaz54NQYFyy10ZZm/fEu+VWvQIV/DUyHF7JJTiEyxlfBrWGR1uetfbt5FSKtSSHNJVVHFga5cI06iPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7Cm5wqwgCYp2VwGitU9ARop5aWzZpKmxEfrua+HZow=;
 b=k8fZFDGfys1rTrgQ/1Pps3YKa4IcJs9ETZW5FXi1M/ZgA2jweEP0ILeuIcdNrZNWGJi7wQfjt7aIzLgZzQbICSP3FmRT5FtrGr3DZE0/YnAGxxQRVuy1FQHpANQt3cXt/Q900+gKbb6zlJB4HLgihTZwfvXvKZNxia8Uj6/v00C6j22hkxR2tFGRX/E2BtxSH9oEWAq8djmnpaDtJIWatsh6wZdCVZTXZPfNS60jh1QGmwqm/oEfhHw4R6cP7WDgZWGUT3iwt10stUQUDQ+Pmc9BMYJECyzC06f5Vm3E6ebKlYxzkvpntFUap685P8YKYumeDUbVsXmb0sxO3P9ljQ==
Received: from CY5PR22CA0082.namprd22.prod.outlook.com (2603:10b6:930:80::27)
 by SN7PR12MB7299.namprd12.prod.outlook.com (2603:10b6:806:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:04 +0000
Received: from CY4PEPF000392D7.namprd03.prod.outlook.com
 (2603:10b6:930:80:cafe::29) by CY5PR22CA0082.outlook.office365.com
 (2603:10b6:930:80::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D7.mail.protection.outlook.com (10.167.247.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:03 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:42 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:38 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:35 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 11/24] RDMA/mlx5: Introduce per-CQ poll_one hook in mlx5_ib_cq
Date: Tue, 10 Nov 2026 15:43:07 +0200
Message-ID: <20261110134320.34408-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D7:EE_|SN7PR12MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 25a996d2-fea2-4aa7-64c3-08df3f30d2fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|11063799006|56012099006|261021123027099003|261021135927099003|261021121427099003|261022105027099003|261026140227099003|261009223027099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	87Ea+fG+t/aDsxVWTseLhmCbo6XgoWZlTUBCpfw7HSCIOsfqAzcbROJ+uUlV1o9OfBp8L/sWTkdE9/L7eI+UxOal2dMMx+rcv8yjPGlSXCBlWLQao8FDckd1iW55L0YrnyjiOBfCEWaTT+ilDxT0t6z8vJZCs7HN3dFjM/B6fYQHaGvREqDaQ2pvJwu+iCiKY5snQJBvegOl00k1KZH9Al37Isqj386MqtIQPQgNx1SWGbnbnGR9/nWcUv7YysukL5uMwrp27r1DgGBaNcjXRs5UKcPm3jJttxp+5VVezxaFe8AgyQHGR0rG8LjI9WoAmSZyNK+3RpWbsiPUIVwgDN84d5EgZ2JBQpAe0siietPxq2nGIJSo8x3RLbZYuzWTuxvTH6qGKs9gKbzF/r8B+J0911VcJty57t0L25/xio4VgapnZG82bJ7K1hVClzgnVkUeFgEGvjpC3HH6ijBCfXODCJUvd9jIxi0pOwHPWG4Up5BV9MFGbYbI4cYeV6cPOnXLfIn6VgsTTPrDINkjtXjVT99hvN2MBSoJryfIUCOlyEBVex7GW9kSFtLOoWsdVm7oqp4D7/6Q4EyyX4TAGZqCmEo8+rtkFMKp+aMHwSGNFc7epU63pzVB1yRdOSuXQ9QB2xtjXrWlksrl1QC+d/ya9TRJrOMSVDQxPhB0HoYasDSJMcqAlkMyhxqlDLxWhGFFxGNmlZvq5LHLDXR2yQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(11063799006)(56012099006)(261021123027099003)(261021135927099003)(261021121427099003)(261022105027099003)(261026140227099003)(261009223027099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AY8AgKkykE8Mua4RR9HvSzJkMk3sXWTdrlDIH7QTIKj0thTOv5R++rrU+o0Jy9JbtPbHX62IlyB8bnLcAqTREz/1TTuZw6ylzMWnoLceiywzlzn44cctAU9KPot6EOwSpF60XEs3qe16oyi5ot18Nk/ub9M3uF83LhuXk4ub/9gj8bENQd4Ruf2Qzusum41hiMJfpnpVeQanBdPW3krher6ovoyBGoRNPOzwm7QwxWLaWefZfkJv/xjqwMlOZCoYISDRrpoQjPCHA56wRyM8axQla1cfdfjTR9cR7xd1pdcbUqjS3OYuh0jCii3RKqfw3Kqtg3UJEqe6wnJIQQFaIKYI2tmTJmNEKeBm3cvWmXWdnQ/50iXlyfbxC0YzEQqdxf9P70yX9njwjYC7xSImVFRTGYDVoUMuzNAO5qDVCP+0XHVr7jvuHIWdQaQ//7wL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:03.9730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a996d2-fea2-4aa7-64c3-08df3f30d2fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7299

Add a poll_one function pointer to struct mlx5_ib_cq and initialize it
to mlx5_poll_one in both mlx5_ib_create_cq() (kernel-ULP CQs) and
mlx5_ib_create_user_cq() (uverbs CQs, the path used by both the
modern ioctl-based and legacy write-based CQ creation commands).
mlx5_ib_poll_cq() is updated to dispatch through the pointer instead
of calling mlx5_poll_one() directly.

This is a pure refactor with no behaviour change. The indirection
allows a specialised poll_one implementation to be installed on a
specific CQ, which a follow-up patch uses to verify the UMR CQ against
a hostile NIC.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 9 ++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 55ffd7d4de51..11c1153747c2 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -633,7 +633,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		soft_polled = poll_soft_wc(cq, num_entries, wc, false);
 
 	for (npolled = 0; npolled < num_entries - soft_polled; npolled++) {
-		if (mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled))
+		if (cq->poll_one(cq, &cur_qp, wc + soft_polled + npolled))
 			break;
 	}
 
@@ -1010,6 +1010,8 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 
 	cq->mcq.comp = mlx5_add_cq_to_tasklet;
 	cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
+	/* Set before the CQ is created, see mlx5_ib_create_cq() */
+	cq->poll_one = mlx5_poll_one;
 
 	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out, sizeof(out));
 	if (err)
@@ -1093,6 +1095,11 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
 
 	cq->mcq.comp = mlx5_ib_cq_comp;
+	/*
+	 * Set before mlx5_core_create_cq(). No real CQE can arrive before a
+	 * QP uses the CQ, but a forged one can make mlx5_ib_poll_cq() call it.
+	 */
+	cq->poll_one = mlx5_poll_one;
 
 	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out,
 				  sizeof(out));
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 980b41800df5..4833f42b3fd1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -592,6 +592,8 @@ struct mlx5_ib_cq {
 	enum ib_cq_notify_flags notify_flags;
 	struct work_struct	notify_work;
 	u16			private_flags; /* Use mlx5_ib_cq_pr_flags */
+	int (*poll_one)(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
+			struct ib_wc *wc);
 };
 
 struct mlx5_ib_wc {
-- 
2.18.1

