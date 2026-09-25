Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A223AFD07;
	Fri, 25 Sep 2026 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329044; cv=fail; b=smhkLaSXB3KuYoBBrf79a2LuJieu3N3pogASuY0s02ZhWFYyUkmApHvUCsKJfRiip/MFEH8celO5x1ablzzAC40xjdYJCgnxqOl8hhU22id2HzjRwGGDrX2sRfwwuWzXNu1zO3ho7F5cpF6fCYo3P1fEBShSraRfqA6PzzvJHsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329044; c=relaxed/simple;
	bh=qPGEniM/4pX3i9SJH7d/XS/ThS68tyv7Z6Tp3MDD7To=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BaMKHVufW8DBDV30xnnEDAREYCwduuHQio9R9//1H2QvzIFnXLO3Pkc3A4VPQtIEKjNBvLCSbHV09X9KNaa/j5ngK1lzLwKx6LbRMN91irAd/UIr7RaLLF21nTmQRrfJfBZHYS3SFDzie2oH1WwOaR7rTJ7O6hUxhUFEAHUiU3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uO9J6XXq; arc=fail smtp.client-ip=40.107.209.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uO9J6XXq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QhqpF167gJFfG+U0Ogl6sU4m5Voy0I4iVAfqL128pAK6vCEqchWjOc30QO1gC7Wv5V1zPOuo0mC938ogjfpYJW+wm8F7Ecq10VbK8cF+QgpI4shhwnbA6ymCgJQRybBlDC18aoq5+0sZov3dUaKMNa91P0R5cXeL1C5BVFLUGHA13bAgMI19eB5nHytq94P+840Qm10+QB59+zM21gZiAkOj5zou4ATzkAWfBErdoh8iEjmsLpCA6KI71MuNViziawmZj6LedYjL9oQhhDon0EePMW6V2SHFS1XU+04MBXuqVXRe2a6jK1Mf7LVbMsBNV4KSxgyxNmZwBp1OG7Hk0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qk67yybPUhNP/kPbiTc78kaHQiAONvRwcxS8Gbb3370=;
 b=DLFGg8K+Z88lxvBX3JE+2ulEZjlszHoXCZObjAUrsPEQXYVRL6mhlJNMMZdTeB6sRcXyQC3gUksp260lvIfVJR53ApXc+WPW6yBmHkbXwAzK6pHk9ngWfW7Qgq92tUL1e4zRnmHHez/l7CNsOJ9KrScY0l+ZSw86rs7S9Sl4JiO1EsKMJsLHdo4MGtO5Gbf6HUlf2FtuKjE6a/GGwTpIDYchUBimKpQAusJRdnkWdVvNeYvAft0He7TlLNGyRshlpMOrYHEDzUIbY+eRNTPh2J7avcAwGjpbaztLgu5HM1GGXgI7qv2eFL99yL8WxyCPMfWXcXEalD/sBcfkHNXSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qk67yybPUhNP/kPbiTc78kaHQiAONvRwcxS8Gbb3370=;
 b=uO9J6XXqcRIknoal2rysjVC0yptzvpFnuvmEucqXbCO++56/jyFZIQ1dsa1y0tFP0rowqfnvfYX+Q5MRjt+EIMtdso075s6IqZDpz6hpbOy6j/GJUyHo8N0TaQsJaYTqCXCkBVyE1+pmxZj/fvVZy5X3Esc/056rvMKST2Zf7D0=
Received: from BN0PR04CA0041.namprd04.prod.outlook.com (2603:10b6:408:e8::16)
 by SACPR12MB275847.namprd12.prod.outlook.com (2603:10b6:806:549::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 09:37:17 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:408:e8:cafe::18) by BN0PR04CA0041.outlook.office365.com
 (2603:10b6:408:e8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Fri,
 25 Sep 2026 09:37:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 25 Sep 2026 09:37:16 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 04:37:14 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 04:37:13 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Fri, 25 Sep 2026 04:37:11 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [PATCH 2/2] RDMA/ionic: Fix double removal of CMB mmap entries in create QP error path
Date: Fri, 25 Sep 2026 15:06:38 +0530
Message-ID: <20260925093638.3032149-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
References: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|SACPR12MB275847:EE_
X-MS-Office365-Filtering-Correlation-Id: f273e4a4-4671-4e4b-84b0-08df1ae8963c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZU/09PFQp+2n885tZXddjkaLeNLgocUPmrzLwUH1rs36Lb3SPtECE3aYBZaME0a9AVQdIs4mc0RhXGr48fg3TiSErT9tMoN6AKx+vXjuSm5CkLCm74j3ts1iQpL8GGFvd55h6N9F4uwyXLOJTJz1hekoRoUBR0njPMNEDjiRVHf9jB1qkNovSl+rizcjpa5IyN+0A1wyBWu1ENz+9rcUSNhDfQO3lcZmPfTVu/vUJ9oSEYcRA7bFAVe0FRKzBoHpyy1yVmuOjwS1a4ie8DnGY4ScBpEStAPMofp+rRMjp89TaTdsyJ7duWmQiKxAVPdg8A4CSemJgmnid/LDR+Fg3gHW7pWifr7lERgDktMZZlRKbah2dI/loZa4rdjGCM2pXvqEp9J93CppKSEu3rHw6cqBA8qoyPQ/j3ySleRQY7eGeLU7JjvSVDCvmCNFeu+vX4x0fb9m2shegToVFW5C5l6J2eWKRx/klE5sntnwBip+3qS2T40Fb+57uYY1sD26x08COjpHRV0R/ocI9vmpRrVYWhKNKw6Ru+/tF/jP1F9lhpmvSGaPROgTi/g5mUJYNrjW2QAlnLQvY9xdTJVx+G+BtJBeqfjoO0qEkLNm2s/NxosjE3JfKWma9Y/tjzZuiifezQ2kdT+e6zhGs2VgYhD3J3IG+O0PFsC20HaTPcoNuWBDOWrgMItKzbxdwsveWlRp77y6sV5ROE8hdt1Irw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zyBKljbNIK19r66td0YZJBGz6PY3676lKyGjFpys6K42nPgluHf7YEU7Z+lcgwKoNBEEOTbqFh4TuKtUDABs80dsiBy56TBZN0HmHiDN4xOivNA2Z5nZt19ejxGkJjR3DCoBuvMfrgd0Wc168Wid99KjoQVc+YC+EV4i6OCLW/MnM3Bch7iA/5M3zcEfW6RYWBjnukhp0lOBWqJtXon6BRpFJfZcUOBzjzJGWirfzMU3jaJTjCNfS+Uq2ddilaQt207NTITTJYzqSYsKMzK6pBnDPTEo0CroyBlJUq4lPD2KFVUFtbhDs+RWq/Id3b9NFwJx01FVeqSN4O+dQP1THdNgYRdYQj3sPeaNlixi3Wtzd4Ne4stt32l6nnfn5wovsgJrZc+AkyCy0pDdtErN6G9Mo4zlU/IsU0OmZPwKhCGWQabixhqOItDdfkoCJzWs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 09:37:16.4730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f273e4a4-4671-4e4b-84b0-08df1ae8963c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB275847

The error unwind in ionic_create_qp() removes the SQ and RQ CMB mmap
entries explicitly, and then falls through to ionic_qp_rq_destroy() and
ionic_qp_sq_destroy(), whose ionic_qp_{rq,sq}_destroy_cmb() helpers
remove the very same entries a second time.

Drop the explicit removals and leave ionic_qp_{rq,sq}_destroy_cmb() as
the single owner on the ionic_destroy_qp() path.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 37f71fb43811..190128290f02 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2350,7 +2350,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 						    &resp.sq_cmb_offset);
 			if (!qp->mmap_sq_cmb) {
 				rc = -ENOMEM;
-				goto err_mmap_sq;
+				goto err_qp_cmd;
 			}
 
 			resp.sq_cmb = qp->sq_cmb;
@@ -2387,7 +2387,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 						    &resp.rq_cmb_offset);
 			if (!qp->mmap_rq_cmb) {
 				rc = -ENOMEM;
-				goto err_mmap_rq;
+				goto err_qp_cmd;
 			}
 
 			resp.rq_cmb = qp->rq_cmb;
@@ -2395,7 +2395,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 		rc = ib_respond_udata(udata, resp);
 		if (rc)
-			goto err_resp;
+			goto err_qp_cmd;
 	}
 
 	ionic_pgtbl_unbuf(dev, &rq_buf);
@@ -2413,7 +2413,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		else
 			rc = xa_err(entry);
 
-		goto err_resp;
+		goto err_qp_cmd;
 	}
 
 	if (qp->has_sq) {
@@ -2444,13 +2444,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	return 0;
 
-err_resp:
-	if (udata && (qp->rq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_rq_cmb);
-err_mmap_rq:
-	if (udata && (qp->sq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_sq_cmb);
-err_mmap_sq:
+err_qp_cmd:
 	ionic_destroy_qp_cmd(dev, qp->qpid);
 err_cmd:
 	ionic_pgtbl_unbuf(dev, &rq_buf);
-- 
2.43.0

