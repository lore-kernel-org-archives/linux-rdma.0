Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724102;
	b=Dua3NmnL9BBlM7+d25rY95oBMtCLgl61wgjRqtgFiHxvl5sUAU1yMro6dcwLVUbuFFL7
	 DB5JI4gFAeKMDckJ5w7JG4V/9DHbS/hWGTMNC5TTW3xMCWP2pLpoX8jGjTAu+mNdcE29I
	 ZwTagbNKxQqBzYKWHneuyrjYNE3odMUcahLRdJb9vZXDcXW8RfI5ndemo0Azy61znHHH9
	 tp8jJUsvzNtEvXv7nwgfDPb+EjT04BOGUlH5FRjrtKkdIBh1DJUZVA5XsZBbmvTabZnx+
	 TmPlfStldx9L0llxag0yjzIGT9KN9BWsIYpggbPi4brXX8Qtr0B+OlHsaLO4bJxFi8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724102;
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
	b=Iz+3Ry+gfqzL/NLfwAKcGLc67KPba3lr7FVsqIxn/rNjvY98sBC08PEskhQrTzAIIxxx
	 PIAPJ1HfkexRIjtQZSIKuLzQEQyOGH03B1EGzEIOxcfqtLSBRSDm3LhRtFn1rH/EvcngN
	 L2y7ljNMgLQkMxnSir3p8xrrdwH6kP1Q3bbG/4E6nOcQirHZy89pdeqBS6jlCAcJbU23L
	 YWpj8x6aJxlJSmnNyoP6DwQVPU0CBsm3WMfSVL+oOQS/p+8W288KFzBwdIt0hiPNbY/z3
	 cg5h5rG6wkEQ9y/0sYyyb5gL2Fj+LqU9NGWftkW9NGIR+7ai7cbP63A9ocQ3wyfGzPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K6xvBJjp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.37
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9441F60A260D;
	Tue,  3 Nov 2026 16:41:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9441F60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K6xvBJjp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SU2Nwc4MvEXltP6Y6Ab3MoqyJzEdTa5aoHwWumBRUf2IMLBfqzmrdkqZO6IekGZH4LD0PktkkvIRLVLlGSplZYSONn/TIWrWrIWFqHQENSvSmv36I9vXE4aZOyLvCbTvcFCId3PaVpwZ9KrsgilvepQwrKNrSJ+Fw94DGVaJpLz+qCJx3EQxwFUZYWSY8d8a5g0Cj3zGk70RxHkIAXu3bqEz3f7/NE1lyGrLrmKuupXy+0XTKRFZW7zsBazL7kK9fEUq5dBOVIyIs0kVYDQbwGVlv9CNwowP64zvUJFTpKj7NvIYBbjvNRxBgZyYqtNKOJMnRrwoGG6rUxGoVjONvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7Cm5wqwgCYp2VwGitU9ARop5aWzZpKmxEfrua+HZow=;
 b=ISD4fM6F34LJH4lMuJdIpgBD3e6gwxfHpwKgK0am6y1IlQNcpcdvn43Q+xaB11zvx7gkiR+1/5rQSnRZ+a/DN0k9ZSJ2y51A0ZFmfS+W7HQET6MhlaopfRg8hy0o28a9NnzRsuHhy2H45Y3Us37l6UzFvmMOPwWPm3G78gZwdJjG8N3k/VY/WKLheQiN9WorXDX4jw9+TGJ0hhjDB78axd1txlViE+TN1MpSpYYZW9NvAfc3gsqndVmt5DePWTnCWycjgfV4bfiAmqzdKQpN7Z69FmeUN0xz3m6vvDWaW28lohm5VEYxEgUlAuOfgXWH+gB8bFXbSM2eHSwn3qqK0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7Cm5wqwgCYp2VwGitU9ARop5aWzZpKmxEfrua+HZow=;
 b=K6xvBJjpMxn4DNa1hyA6SeaodXVg1MnVhoLB69swrKUxBu41Pl0KSR12Okgez2HfH71mFJPMD2hcOeKbBX0HmBx//WImB+YJS5Xi0lGgO3MNvXp8PCGO3QgTSCJ2MVTJtbkf2nuOzJdFCIQu4w9+cfi+E22c1JnAVrm7GayEnXwwynzB9UOQ2vAk7epXSM8pIpdY4ZDTrxpc9g6yNYFUzYxWsbXa/VUEycvHfDZoezEOqdH6U+ggJkuhbbBCYBPPGybHSdQuJb8XYni1ZrNbYKy/1UqDigNK15zV8Soe4OzWvam/Z6zA7EeemdcP5kHIYML2WrEe2Tk0icy3n7AbTg==
Received: from SJ0PR03CA0169.namprd03.prod.outlook.com (2603:10b6:a03:338::24)
 by DS0PR12MB9347.namprd12.prod.outlook.com (2603:10b6:8:193::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:33 +0000
Received: from SJ1PEPF000037AF.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::37) by SJ0PR03CA0169.outlook.office365.com
 (2603:10b6:a03:338::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 3
 Nov 2026 16:41:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AF.mail.protection.outlook.com (10.167.244.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:08 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:07 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:03 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 10/23] RDMA/mlx5: Introduce per-CQ poll_one hook in mlx5_ib_cq
Date: Tue, 3 Nov 2026 18:39:36 +0200
Message-ID: <20261103163949.1554-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AF:EE_|DS0PR12MB9347:EE_
X-MS-Office365-Filtering-Correlation-Id: cc73c726-6aa7-4851-5003-08df39c951a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|23010399003|22082099003|56012099006|261102123227099003|3023799007|10067099003|18002099003|261009223027099003|261021121427099003|261021123027099003|261022105027099003|261021135927099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	maL8hvLyGCMcbWap/haevZV5UVBn/1LRyydsgdox0noe5Zbib7YoHdZVE7isX3+xHhhW8slxqb5Hm0EE9T8qRx9ofndtyx80Fih6WBehz8vZhaZc2kzX0+fVSIARMu27F7OziQ9iRGgFI0NockVBupQ+LH4phXL5gTUK6GTlvFQuNuvatRd1boGRXKLW4Jw+QlK9vBRYeiv5g4ZwtK8dOLnwtrPhFd6O7/vd9Y9VYRKJ8E3oIKrHRFFlnTHAUkNH2e6h7CmsYsuT7ufZKOxow5dZNtB5BemdS/t+T79snsmWbtSl1jtCTGNZW9erVIFQHjUqEP8MxNpL4axlnkElnIRKwhTpnUGX2UHgRyIVIzf4MxMPxFgbYle24nyJp7wATouPuoKP6UkTu+Cg+iSijbsqryFdKmL6ZT/Kh/lhsyBq4ZruYJddKW2rfP7Z1AnLBdsMenDDY0CyOp43djbimLdpK7Cs7qEr51guG3SzoCt5EikQEO+sxzGEbIkxBPWcZh72E4sh0zGVI5yNfG/A2m+FJJehxU7p3vXjDmvOVNNATUvDyoccNDigLuXeWXy6d4XlrDW/NwwKc81WE0iNSkux0u8loD1yX7mgXu8pe77rd5VKaW1K/rm+uiuqVk7KeXOOyelgvXCxRGN1SI+phcAFN4fBFhX39KtwP4E4CWs72KC7yHVl7z3h/qMdueLG7PcAFZLv++6LQj3fLj2n6g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(22082099003)(56012099006)(261102123227099003)(3023799007)(10067099003)(18002099003)(261009223027099003)(261021121427099003)(261021123027099003)(261022105027099003)(261021135927099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CWYOvS91F2jkPz6jxQFzbLZg5GbetMFDUtmSD7LACa6pKtzo7liGKCuydybJ1PDHevCS9VZZnReaAvPZUCUNmKcL1AaHqED4S9BZwXztGgookIHtiD3cDb2zcnQ3CP0fqs2JYXMhL/EP9TDI5YSiwbeVF6W5ianQC6nbhezMeKKzMQZDSDtX3hXGE39Rr/TdTn+fwxBisjiFwAEPxYHd60AeGQ6f21yBtl946r1cWMQvAHsyBjs9nhhSsnvsjg58FiqL9EQ9Sm1k9U8piqta00ykA+ezuO1p+cjKK5H0GQp2VUCnZYkp2Co+GOSIwsmAuMTvGWJ/mvynXLWaPaKQivwF3nKjwGFSJ2sc/2dX80tKqut60vBW16f5IW9knfPjicDplhMGt8DBq7XiyUugcjxBQLcTy4hVHkHzGPfww3weOC6Gmdk1ciYXac9M52lS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:33.0456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc73c726-6aa7-4851-5003-08df39c951a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9347

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

