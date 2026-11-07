Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063863;
	b=hjBRBraNSptzR94rePzj6LJQtCKQN3/MCNmtbhPOh+Qr4KIz2XPYSZ1A7cY88Mb+vDSp
	 AhaBamnZ8g4e4r4faP5meBWor5KfAicvfITZ0u1tjjDe+IbpyteFD6bOdHNi/vYs+ZNMF
	 F8EeoBT9tQsSHVm2/nHzsrL3nViwhbCLqG6ByAmC30Vgpgqx66F/OYYr3HTQZwamWHe3v
	 7I6mezBCh+vYTcfZJ7RLcaRh43W/r/jHUMJ0ho8FQRgP++cbAB5eRTAD7+bLwWYMY3wAc
	 JakZE+6OMdXxUZ2pWdddt4VjRdOUGGvE5BVQs/MbrzveG9/7xCl/UhftDRuDwBLyvpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063863;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
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
	bh=6gBRzWzI7TZP7eS6aGMyLLuW9iUQtt8tQbdNR+wgn2E=;
	b=K4BUGB6oLqOEGMeb6KYHgjtDgKd2SVkSTK2OJ5JmJ+wGEBYKnGjt2FmuqQMcxCSoJL7w
	 2j7JGtPrK8Rz2dY/pwBKPJ0k6fbiaPxAYMOlXnUPjaA8TdU6OJLsP3r55nOEE/6JAl2hR
	 FY3+raoIamxcx9hBmgSRHiP7j9t9f/iBKCG2Lf9elLwtBlAMwtDSRZDwqQ3VtwHxQp/GJ
	 pTgYnWLfmrfoxLHRCi/nH8C2c158oUdTTTJ/I62Tu62+sUIeKfNyoWiyyoTqrpUtTJEYO
	 2QQBevLzsExcjeocN3zUDsm2hPbNVkr49+FnHj+IWdYjJNnkG+k3QoUdStN7TNsSQCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=OIMZFKKZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.2
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA77606CE5F;
	Sat,  7 Nov 2026 15:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEA77606CE5F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=OIMZFKKZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoypBhPRRYBcqGZDutgVJ2LYye4rHOOHE5tCQUTY+0+XMJGnQxYSNfTX8guk/YHiM6Nus+ffQOEA92yc/+vAtCNcurLerGVJQMzfeXYgoeAVsvzKkzrOofVFMy4ZRFgT4/I4PXLtrZJI9Sx0OE083L5d5vWsxT9iFBm7/nKUELcaTjVS4MvLjTfoCSG//UjttS3GY38IfBvy6+fL+fbKgD9JhHXU7F2e+tyEFRTLsZShdtr5cA+V9LQ6ioRvOPho4uf1DHiSMWzz4K7YsR59xBpIDxYe+tS/OSE2wcdwcgyJvfzrBGmdihoWeSF8y+1K48c5C5WX2wsnLNb+xOszAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gBRzWzI7TZP7eS6aGMyLLuW9iUQtt8tQbdNR+wgn2E=;
 b=W+VFsay7CJlfqSmd8EDbooAJ9aXd8loaIRIQdObR9skhGf3H41tNLtFEy4/rg7wRUVyo76iOyXGPVlNYSRjq81lSEk9rf6REYj+hFfL6mqc628Dm8pNcJQnz1H/4ssZjyUKfPjyUIrARWzmAx80/brYUcvJ7dKrYzoq3hfmFq9ZYiGxReuUNKOvwXklpvwOXXuspvKa44fa+3hOVSeVkUqmJZ3hfSarW6GoiDTfy4iSB5qQP6fkC1PKvIhQicmaf1nav/5b4TrPCwU3HGOEGaDrozMynBzUfyCv4e5n19TuXw+YtsL2ntD0bXc9qs6t3cnEERmVU0jbc4h7+vpOQQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gBRzWzI7TZP7eS6aGMyLLuW9iUQtt8tQbdNR+wgn2E=;
 b=OIMZFKKZbLMmmQ4JZnXqq1ptd/eu6d9B3rN2JVabTscY0d6LPym7eB8Lriv/jTyWDe+8Xg++Z7aMj+Q9up61EkqIOwVu+RZfACF0xR7nTa2xOxOQ+1m17LBvH/MPDcPGGcvCPGAsMPSfMJtifADtCoVJt0In60NWeu05QhSFZUs=
Received: from CY8PR19CA0030.namprd19.prod.outlook.com (2603:10b6:930:6::21)
 by BL3PR12MB6474.namprd12.prod.outlook.com (2603:10b6:208:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 15:04:10 +0000
Received: from CY5PEPF00000E87.namprd05.prod.outlook.com
 (2603:10b6:930:6:cafe::86) by CY8PR19CA0030.outlook.office365.com
 (2603:10b6:930:6::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 15:04:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY5PEPF00000E87.mail.protection.outlook.com (10.167.247.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 15:04:09 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Sat, 7 Nov
 2026 09:04:06 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Sat, 7 Nov 2026 09:04:02 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <eric.joyner@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gregor Dick <gregor.dick@amd.com>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next 4/4] RDMA/ionic: use the v2 atomic send WQE layout
Date: Sat, 7 Nov 2026 20:32:49 +0530
Message-ID: <20261107150249.1576835-5-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E87:EE_|BL3PR12MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: feed808f-e4b5-47c1-4d13-08df3ce06083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|23010399003|1800799024|22082099003|18002099003|10067099003|11063799006|261021123027099003|56012099006|261021121427099003|261021135927099003|261102123227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	CadxGNGI1DplHYvXMXAiwvALIdmm97Hg8v4Z4D2CIpC6TjWlJuQR09sb8aeZQHZtmpgzAiKGLiyfhTWi+YzlKfFC86XoIyMpME2gv7AFbEhpoo1TyT9EQLtTVap5MlFFT1AORiml5/lb+wD0uqHMB2Tuz6xhBiwMjSvJK3JWips57bvh8R9Gf2chbe2D8UezYHVs/uLpdS9W3KuUwnCwZULA9dr9/5kDxwu3oI6E64lmQigDlw4/Gl0nLMg6UD2HbM9FsRaXivh/oHW9rtHOIWKyefWOwzG9sGG40a7DLcw14MpHRSw+Uw8FQZLr/XciNhM5ZIwo5sALsWtXaJttTQs0QLZueVubnVkokG2du3XOXRZ08IvUF949/5oULNKhh1Eb4WVyI4NIME/ekZxLh55NwbCXh3LTkgzJnzgP7sZYf7gL7oqUYoL4bikipPyzs1/SyFQp1KIl5vdjneXxCBaI2sl8bbDjRZ/mTnHjPxMs0+e3WfvTxlqs8OlcwQp7JS3at9wyOiOzpnTKp8rwAQddvW/ulNrOSjkPL1FJxI1OqjAaRu3T/S5KWPC6GhRxCMdjwVzUTsJ7OoSf6tkQAPt6WfU2hy8amcDB6j2oRBIPTHKqQJKwRn/BFvJjU5IpkyUZU51uw3JIwsGoZ3Hm1fttB0RKcgPLiFQ/NT02DPeUIeto3demlJOfdtaCjnYxvlLCm9vqUyuSnWwiYiMuHA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(261021123027099003)(56012099006)(261021121427099003)(261021135927099003)(261102123227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FBIKl+A8RPK3nn1cyilzrwI4N1v96Ds9shmh1XAqFZDpxqZlPSr4mtsWDPrWA3GxQAvfUfDkbohNkLQ5Bl+U5x9PKkJUf2BNF/yDa58FckDQ4rA0/mNR95J0hjzZADEwHkhjy6QaG0F4sykHfp8jYuOL1/5VSbucM4NV0VMSPO0Vt1SYa2eEBnahzWC+O7gB8A+Sl1SRdfK1d7IJ02L4eC8s5zf3x3ilbMxAFwspV6to26BTCh31YHfCvcAiF2LUc1B0UdN1zFP7gJpJ1zIbLZq5ovkKSNba4yrq++sPQY9pCF6NMDEsq0pMyG3f+PGm+yHDXn5fd4LgAlgpyxc9g3huL95W0XN54ol9nI7mM1msFdJJuALLWmEU+2NA/e144N2QPIldL1aUpVMD6ovuCFYxjd/N6JZkjYIBFHVDSwnPki5+qh+OpTLbs5jnZpWF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 15:04:09.8606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: feed808f-e4b5-47c1-4d13-08df3ce06083
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E87.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6474

From: Gregor Dick <gregor.dick@amd.com>

Firmware with RDMA version 2 reads the atomic local operand from the v2
atomic body. The lkey follows compare_low, and the 8-byte local VA is at
offset 32. Version 1 keeps the SGE layout. Select the body with the same
RDMA version that already selects the atomic opcode.

Signed-off-by: Gregor Dick <gregor.dick@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_datapath.c | 12 +++++++++---
 drivers/infiniband/hw/ionic/ionic_fw.h       | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infiniband/hw/ionic/ionic_datapath.c
index 5b6f10256b49..75f82c21cc03 100644
--- a/drivers/infiniband/hw/ionic/ionic_datapath.c
+++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
@@ -1050,9 +1050,15 @@ static int ionic_prep_atomic(struct ionic_qp *qp,
 	wqe->atomic.remote_rkey = cpu_to_be32(wr->rkey);
 
 	wqe->base.num_sge_key = 1;
-	wqe->atomic.sge.va = cpu_to_be64(wr->wr.sg_list[0].addr);
-	wqe->atomic.sge.len = cpu_to_be32(8);
-	wqe->atomic.sge.lkey = cpu_to_be32(wr->wr.sg_list[0].lkey);
+
+	if (dev->lif_cfg.rdma_version >= 2) {
+		wqe->atomic_v2.local_va = cpu_to_be64(wr->wr.sg_list[0].addr);
+		wqe->atomic_v2.lkey = cpu_to_be32(wr->wr.sg_list[0].lkey);
+	} else {
+		wqe->atomic.sge.va = cpu_to_be64(wr->wr.sg_list[0].addr);
+		wqe->atomic.sge.len = cpu_to_be32(8);
+		wqe->atomic.sge.lkey = cpu_to_be32(wr->wr.sg_list[0].lkey);
+	}
 
 	meta->len = 8;
 	ionic_prep_base(qp, &wr->wr, meta, wqe);
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index 100138e4cae7..3f8b69e114a7 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -495,6 +495,20 @@ struct ionic_v1_atomic_bdy {
 	struct ionic_sge		sge;
 };
 
+/* v2 atomic wqe body */
+struct ionic_v2_atomic_bdy {
+	__be32				remote_va_high;
+	__be32				remote_va_low;
+	__be32				remote_rkey;
+	__be32				swap_add_high;
+	__be32				swap_add_low;
+	__be32				compare_high;
+	__be32				compare_low;
+	__be32				lkey;
+	__be64				local_va;
+	__u8				rsvd_expdb[8];
+};
+
 /* v1 reg mr wqe body */
 struct ionic_v1_reg_mr_bdy {
 	__be64				va;
@@ -524,6 +538,7 @@ struct ionic_v1_wqe {
 		struct ionic_v1_recv_bdy	recv;
 		struct ionic_v1_common_bdy	common;
 		struct ionic_v1_atomic_bdy	atomic;
+		struct ionic_v2_atomic_bdy	atomic_v2;
 		struct ionic_v1_reg_mr_bdy	reg_mr;
 		struct ionic_v1_bind_mw_bdy	bind_mw;
 	};
-- 
2.43.0

