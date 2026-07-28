Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F03B3AFCF2;
	Tue, 28 Jul 2026 11:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785237234; cv=fail; b=WMmb/pA3QgLBbcqKDzwdPGk75dqBovLWbXpO1oZE3slTvKcTVCdzCJkWL4Ief07v5VnzB64ErRzrijUoD0XldKU+ppZ4hMcCGXQKoNZOXy4cVTRovWoBRM/AuAKoFb+A+Q0BC7ZfAv3lRaNr0Olgaz+qdrKWLHLj47L+eARXDGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785237234; c=relaxed/simple;
	bh=yT+qFeK0wRtIFqUTXhEhT+1si1l1vkzN5wiJFUkp9K8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMiMufMIGwLhtBG0+GzIdwt52vqvHoVD9ANCzwbylPKqxqnV8AqaAeISspvGKPje4p5m5ACJecw276dwl6e+prCkmOi36Oup4uSa3RnrZxhq/rHGcMd7jrL5GAjHW+j2GR6SzYRL/U1kdxYwDHyYxDwfAm1RiFrhxm5jHBecQN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MbEhCrmq; arc=fail smtp.client-ip=52.101.62.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MbEhCrmq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQnZgoeUdIe5Qecgp6WtrfzzdSGRIOLkvJ4VxhmBFLv6t7+sur4JrO9xKl/kgX67p+97NWFh4gWGIM67NS6GZbJ/m3JddhmzGr40TeraL+94jMKkAwL5kN9Ji/nrUWxPowOoF7lIKLBfvd9UVq9XJGjxBgDcwW1YlWI2QVyb5Oug6WD0yTuDdygzINktrPN2V26yJfc+ubRMKKROQHyIqMV+kcjScA3UDJ7MPD+3lzFM6lxxlFTFhdnMA0aaP2iQ2W0te2hEe7UA7p3f3kiOCWVXsSCveTQ5q7cn+jkvxXHefdPdPTQHxuzv7J5VR/+byPzr90l3GG7AEXWXGI7XyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69zCuGo+liUMS1wNWWqRJCBz1ApoSyi/tYJTuD6gLJY=;
 b=GvupEkiTTTePVuMGREGtBDpgcclxbKedCns000U2X0+EY/GTA5Jw1Dtsh3MN8E2S8t5WRyBU5ef+gruMUx1Rnh1gTmcqOVAzRJdPhlT0T1oJZ0qe//iTMu0C2F6ZtlGejigLqMTzu7nq614SoBf49MU2eZZuDn+9mfl6Zil+qK4EbZOoHrv9ZJy2GiHUdOUf7vQcQNBoI2V2hS1IBUuk34b7VmoW8z1HCh7T4YS16wTLjsmmkTPI25szt/qp7gXfxVloa/g494qqWGvEXugufjG6VjLVzN2l9GJEZBlSxFQpohdnFwklw7HeqXl33fnVLw7jwJpjau+usB+BAdHpdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69zCuGo+liUMS1wNWWqRJCBz1ApoSyi/tYJTuD6gLJY=;
 b=MbEhCrmqMqsikMSNeGUWFDr5zZ7Q4vpzGHlE92CXO4Lv8ReClzKRPQp2nyQa9+u0K9GmhcbARmy7i5L0NJA6wHDaQT5m12QlVKeNDDuwhPeUcAxpbTumh0gtRdSt9Onx2Lc/CwUTXjP51J7xcCdr8Uymc6T+NnMEzE5lwGXae84=
Received: from SA9PR13CA0029.namprd13.prod.outlook.com (2603:10b6:806:21::34)
 by CY1PR12MB9651.namprd12.prod.outlook.com (2603:10b6:930:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 11:13:45 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:806:21:cafe::5a) by SA9PR13CA0029.outlook.office365.com
 (2603:10b6:806:21::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 11:13:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 11:13:44 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 06:13:44 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 04:13:43 -0700
Received: from xhdabhijitg41x.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41
 via Frontend Transport; Tue, 28 Jul 2026 06:13:40 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v5 2/2] RDMA/ionic: Add RCQ userspace support
Date: Tue, 28 Jul 2026 16:43:23 +0530
Message-ID: <20260728111323.2559185-3-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
References: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|CY1PR12MB9651:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cebfc1b-a83b-4f4e-c831-08deec9949ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|82310400026|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ClWKggDXNjgjLD2xIHPksdEaByQ7oSZzn5O4oxhEvnoP1AanRAOLnDiMIASfZARfr1qmypFQ3Gu+g9ia/M01rqCrjEYHtXkPjlYI7zOG7c1g/gG+cIGKq/lEFcrXGHVIERqlmmLrX8v5DYJSQnSbrEcLFh43m5gKGBtDDP4nHjBMi5Cf0Ws5zwrMCfPKR9mkl45UOjUQ/N2Rdq3Kml8G8e0WDmIjGdTO408ttDg1mMO84K1XQ2DBaAzlGkiha0DZ1hWrlVHA/7myvSFIJ/CUqnZTwq3oUnsTIMel8lVM3EVovyyJzz9YVdG3EOgaFf4H+DQopleslSRXHQWtObH40NmmwTEpeCCRI6FQYIRftdY49WAX5WcWb8pCAQw3EMbP4I8a+Gb8SmvwM5clSVsDrCbtAy9HGoo2qDo11n+12l9KxRsGrqucPosa+v3iF5ltPPNps6cqkcm+CLD3j9Fdq+WS4konJlJQAKNHm5CcaJFRdfTOFiCSoTIprXIXrwyUEqX1n0Rba0XXjJ79PU867ZCN3B6nQFCLYDFzRcs10DPw/k4e3w/28QQh/HPfUdufHe+aWzimbPVKTJ/NXo5XTkHQ4Z+o5SYL5FwaSPeWBKPv8wGOzn3bkl6H6B5ySfPsMvltj4YmkZJI3Aw2DV6SwjltVV7dFqE685A5We7M3jUf37EEYwXSIlh1rGjCoHxcgac7EniKcd4tbbkqUgwsAQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(82310400026)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ux+pZJyCmM+U78dwd5D8TKQLYojzNNBDo0jSVADZ03wo4m9ocvBBXaYIKhndXA+JGgw92aEdW0+Y5KEtfRFeJi5eLuAvZvbxHtrk2xwotQN+YhptSCRZLM5kYTvdyvA/ReWJu6T3mqgcT9nTGW+12pcZWgfzad7MLxc+RT2PafcuvmNXzytyiz5lKi34Ggljh0XylgLawXb8vVGWBQJSaxjuBrh9sgRwVbLCmNPHhGJuCa6jf2QCcyFiAKy4Bl+bqv2CF3AyemE3ekJ8QQOV9a4oI40GQnMHB+6r5L8IgRiIuu7QNHypWqvJ49WzOuBAlHg3vzwP95ndsEPvqO/tCpV0ToZuSFlRCY0MukQhUHsvlJWzu6+QeZfI+Kw0ixWClJWIgIPhhJp4VWoK1TrfIjyATXmHbcnhns+nQ/IZyCPR8mf+c61rpRk1l2UQsZj5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 11:13:44.6796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cebfc1b-a83b-4f4e-c831-08deec9949ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9651

Expose the Reorder Completion Queue (RCQ) capability to userspace via
ucontext response and allow userspace to specify ionic specific QP
flags during QP creation.

Co-developed-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 19 ++++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_fw.h        |  2 ++
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
 include/uapi/rdma/ionic-abi.h                 |  5 ++++-
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index a70ef59a8064..c328b62dc187 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -418,6 +418,7 @@ int ionic_alloc_ucontext(struct ib_ucontext *ibctx, struct ib_udata *udata)
 
 	resp.udma_count = dev->lif_cfg.udma_count;
 	resp.expdb_mask = dev->lif_cfg.expdb_mask;
+	resp.rcq_sign_bit = dev->lif_cfg.rcq_sign_bit;
 
 	if (dev->lif_cfg.sq_expdb)
 		resp.expdb_qtypes |= IONIC_EXPDB_SQ;
@@ -1388,7 +1389,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 			       struct ionic_qp *qp,
 			       struct ionic_tbl_buf *sq_buf,
 			       struct ionic_tbl_buf *rq_buf,
-			       struct ib_qp_init_attr *attr)
+			       struct ib_qp_init_attr *attr,
+			       u32 ionic_flags)
 {
 	const u16 dbid = ionic_obj_dbid(dev, pd->ibpd.uobject);
 	const u32 flags = to_ionic_qp_flags(0, 0,
@@ -1404,7 +1406,12 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 			.len = cpu_to_le16(IONIC_ADMIN_CREATE_QP_IN_V1_LEN),
 			.cmd.create_qp = {
 				.pd_id = cpu_to_le32(pd->pdid),
-				.priv_flags = cpu_to_be32(flags),
+				/* User-supplied ionic_flags are passed through to
+				 * firmware, which validates and rejects any
+				 * unsupported or unauthorized bits.
+				 */
+				.priv_flags = cpu_to_be32(flags |
+						(ionic_flags & IONIC_QP_USER_FLAGS_MASK)),
 				.type_state = to_ionic_qp_type(attr->qp_type),
 				.dbid_flags = cpu_to_le16(dbid),
 				.id_ver = cpu_to_le32(qp->qpid),
@@ -2221,6 +2228,12 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		rc = ib_copy_validate_udata_in(udata, req, rsvd);
 		if (rc)
 			return rc;
+
+		if (req.ionic_flags & ~IONIC_QP_USER_FLAGS_MASK)
+			return -EINVAL;
+
+		if (req.rsvd_pad)
+			return -EINVAL;
 	} else {
 		req.sq_spec = IONIC_SPEC_HIGH;
 		req.rq_spec = IONIC_SPEC_HIGH;
@@ -2301,7 +2314,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	rc = ionic_create_qp_cmd(dev, pd,
 				 to_ionic_vcq_cq(attr->send_cq, qp->udma_idx),
 				 to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx),
-				 qp, &sq_buf, &rq_buf, attr);
+				 qp, &sq_buf, &rq_buf, attr, req.ionic_flags);
 	if (rc)
 		goto err_cmd;
 
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index ee23062a1762..d0a5bce85ed8 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -105,6 +105,8 @@ enum ionic_qp_flags {
 	IONIC_QPF_SQ_CMB		= BIT(13),
 	IONIC_QPF_RQ_CMB		= BIT(14),
 	IONIC_QPF_PRIVILEGED		= BIT(15),
+
+	IONIC_QP_USER_FLAGS_MASK	= GENMASK(31, 16),
 };
 
 static inline int from_ionic_qp_flags(int flags)
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
index f827dce59973..33e4abf13bd1 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -86,6 +86,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	cfg->udma_count = 2;
 
 	cfg->max_stride = ident->rdma.max_stride;
+	cfg->rcq_sign_bit = ident->rdma.rcq_sign_bit;
 	cfg->expdb_mask = ionic_get_expdb(lif);
 
 	cfg->sq_expdb =
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
index 2b29e646c193..d7835ac27896 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
@@ -57,6 +57,7 @@ struct ionic_lif_cfg {
 	bool sq_expdb;
 	bool rq_expdb;
 	u8 expdb_mask;
+	u8 rcq_sign_bit;
 };
 
 void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg);
diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
index 2c70ac149c4f..b04d953ccb7c 100644
--- a/include/uapi/rdma/ionic-abi.h
+++ b/include/uapi/rdma/ionic-abi.h
@@ -46,8 +46,9 @@ struct ionic_ctx_resp {
 	__u8 udma_count;
 	__u8 expdb_mask;
 	__u8 expdb_qtypes;
+	__u8 rcq_sign_bit;
 
-	__u8 rsvd2[3];
+	__u8 rsvd2[2];
 	__aligned_u64 phc_offset;
 };
 
@@ -85,6 +86,8 @@ struct ionic_qp_req {
 	__u8 rq_cmb;
 	__u8 udma_mask;
 	__u8 rsvd[3];
+	__u32 ionic_flags;
+	__u32 rsvd_pad;
 };
 
 struct ionic_qp_resp {
-- 
2.44.4

