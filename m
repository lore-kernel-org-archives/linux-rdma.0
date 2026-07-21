Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C7137755D;
	Tue, 21 Jul 2026 12:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784635877; cv=fail; b=oaLuWFEK7P2UdvlZtTEvJ1ZdF7eWbXlyoBxy4F/iFwYEOTsqtlHQbtrz4++VXJTjh6e4E140CpA/SkAdyP+6cfvn4oA98nH8ZBP3AnAbOLiv5An47ctytX+HelRCqcA3Lh5s82aMVV+4h/D6mScK8v9eGGHpEOWegp1S3XPIjk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784635877; c=relaxed/simple;
	bh=H/GMRjlCZ3yOXav7EquAH1yfjUvC1GMOEUeugX5olew=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hke24iu398lLo3/FRsDE/RCmUTSGcJTe3YMKql5rTGrJP4wcIoM86sKBz0HRZ6m2RKBgigs7dwBLMeo7+SsgfHtpnqp0Yg56bVj7ANn5PjrYccJlPdW/gBu7PrEkB8ZnjtV1GUowSJ+FlRDT9u/LqGoM88suzaheX/AwuQ2Cq78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PVY6OmwR; arc=fail smtp.client-ip=40.93.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PVY6OmwR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1q1ifD0+JwnhoQmpgilvx7DC2u9x+uXCLbTEZl1Uo7WKd/NznPBWOFCl5OZbluuuPhhcJQr5yZD+1jvz+a5WcbdurDK2MzW0QQGhazq0QMo0WpH1G8XPZfljSeuUitY7NFoiueCOFO4dJyPwv9Vx4ibb+nr0s0Cn8jZ8XdZ2aHkBLxgo+s7gMg6cF1XbcrdbiVvjH6ksyC8LhQdXAqR62Nl77IxECOWjuTVg2KzXizKO6t4Q+CCV40pC+MxSCF0U4N1xruA7/dE/Kaa5u1ReIz80Od73LQeBl5A4VTRxGFBqPxOJgiFKZNedE7eN8sR2MJCbWdXGvm04tTTmPIhBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nj5P/3W+ARPVjNsWjU9Lhwm7jAWDnw3IW1wFJbrjM6s=;
 b=U5Y0z150godWzglAW5KV6AqyOmMxT8cmROi2obgdpmpPdMjmyVgTbPyPMbxUKn3GGNND+sSkGtK+OsbNihv2A8JYtwDUdWBLWixBAPiL3aApmkev12prNogdB4FGnB2yaWhFIusbRo3e4hew4mgrKlEFfoqBjRsnPugYKioJUMpw41xPsQ5cNmySng7vFlI5m/5TR83HNljqOLfeglxESb29dmulq6qBbFjneIAQSSgRU55RJwMb1jMtOLKm2Jaw5pOAgxiEC0cdQ5sChdpzG0/pA51suqdLZjANneGu5iAL6k62SiLSJx6yc9p7HV5uDzItWw+t/jdg0R9tInkp9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nj5P/3W+ARPVjNsWjU9Lhwm7jAWDnw3IW1wFJbrjM6s=;
 b=PVY6OmwR5mHijv2UJCa04qP3ydvsfOnui9Kky3lbacEOcItZ5Eq0xYnmNoV/FH7o+QdqOp3nk2MrFtqmd7blI3fPj7HHVV3P2rbggm/20yKTKGbkXyh6XXmYOPPea3eMMTl92BCSi2DvTzpvGp411vRDJywPoFVEFuTAO5fhn7Q=
Received: from SA9PR13CA0173.namprd13.prod.outlook.com (2603:10b6:806:28::28)
 by SN7PR12MB7936.namprd12.prod.outlook.com (2603:10b6:806:347::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 12:11:10 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:806:28:cafe::70) by SA9PR13CA0173.outlook.office365.com
 (2603:10b6:806:28::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Tue,
 21 Jul 2026 12:11:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Tue, 21 Jul 2026 12:11:10 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 07:11:00 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 07:11:00 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 21 Jul 2026 07:10:57 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 2/2] RDMA/ionic: Add RCQ userspace support
Date: Tue, 21 Jul 2026 17:40:34 +0530
Message-ID: <20260721121034.1616562-3-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|SN7PR12MB7936:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b0cced0-5adc-4113-5e9b-08dee72126b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|36860700016|1800799024|82310400026|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R+c/jTWc/Ln7cC0ub4irrjYhgvjh/id3x6N+8Pn2pulfQ8friOIiKAb/73C42SUW7lK9+8H9Y+vdz26AMmunYOGiBNGmKXsIBK2hfnKYCYoiSI2QLNLkffzbi1XcjQ/dofRJBav7GcwWxuLM4Q+7EE6vKPo4lKuNqNwYRp0TE5Afs3HFMYoJefG/P3T4JMt6cxaShW5rhefFK8L/8+Fd0dE+SyRj6Ca4rR5xzwA7K9nB69OASvRdIQ1w2B6T0MkABXZVgeInZO5H6/7JUgbMphCVQW1F1eH6vFYCTdxI3QDiwZa0U785eaJJlfdJ6KXizwLcUJTmg3sYCbqk3w906jhSDCjX/FHDpvi4AqrqoMTDROXgKzKN9V7km97/gXtBykYsskfgKdc6FO5h4lmRlz4aYQr9XZY7tcxWYbH78A+6+yiYkG6XMLq8Dg9xnSsYZJWGJNUI64wHjxe0MYITHICdTNwsCQI+UX0WdZW4addV+T4qEpwJjvQIotdpLH9xq8GFJOSg8krPaX8i5rB+q9fHxPJY2lTxfz7lj2PZ5gEDznfOuaRV47xXng9LwYak8fNzji3l3jTJMLapLLO1+UGZMXx94VEhu6RFIOvqstqTwoCNYiR88ra3BWlsYJ5Wwq1l0HM1TL3/SCCABjz8UF2Bxhm+JvZhIaRFF7/UF+mkg5X1nHVxg8MqGwsaYyW0/oMddoOBhYMNWK1lp6eXWQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(36860700016)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6Ij3E549KH82ILHi0JDj3jKuz1ss/U2lNRAmy0S2uWpxT06JnEdU8nB58Gwl+jJ8f1iAmyh80UMYzEHqh+wkMkCrIo7miyPa3pSqhhjnwRs4cyYo3oXuMFzIaFrSy5WJEVDvSuUqJn0WBatECTS0Zu879F5Ipx5DUP8KDJfQiWRCZWCik3yQCIFv23O4FCnRlSa4QiftR2I9ir3k4eGtZoA4e7TyKozKXYeznt12+oG2onDNpxIEKRPZBxWOyC8znOUpED7oPhlyKMFrbXP5dPGEfnLMv2uXFc06P2EzVHPtpd3KxZmXBYZRP/OsSYGebd19veQXeFZnoDMOwZ2d0LoS9h/sFHIYzGYeCHUJ3shE1q6rld2KkRPh83u7HtB7Bcnm/jGzhwgSDJlpi0VsFIxvLh2dm1DFGhiJdDAqnNdQWCdXlN5WUR5z2X1JMq1F
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 12:11:10.2027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0cced0-5adc-4113-5e9b-08dee72126b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7936

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
index 9d91f7667d4f..d28f26c58927 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -408,6 +408,7 @@ int ionic_alloc_ucontext(struct ib_ucontext *ibctx, struct ib_udata *udata)
 
 	resp.udma_count = dev->lif_cfg.udma_count;
 	resp.expdb_mask = dev->lif_cfg.expdb_mask;
+	resp.rcq_sign_bit = dev->lif_cfg.rcq_sign_bit;
 
 	if (dev->lif_cfg.sq_expdb)
 		resp.expdb_qtypes |= IONIC_EXPDB_SQ;
@@ -1324,7 +1325,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 			       struct ionic_qp *qp,
 			       struct ionic_tbl_buf *sq_buf,
 			       struct ionic_tbl_buf *rq_buf,
-			       struct ib_qp_init_attr *attr)
+			       struct ib_qp_init_attr *attr,
+			       u32 ionic_flags)
 {
 	const u16 dbid = ionic_obj_dbid(dev, pd->ibpd.uobject);
 	const u32 flags = to_ionic_qp_flags(0, 0,
@@ -1340,7 +1342,12 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
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
@@ -2157,6 +2164,12 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
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
@@ -2237,7 +2250,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	rc = ionic_create_qp_cmd(dev, pd,
 				 to_ionic_vcq_cq(attr->send_cq, qp->udma_idx),
 				 to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx),
-				 qp, &sq_buf, &rq_buf, attr);
+				 qp, &sq_buf, &rq_buf, attr, req.ionic_flags);
 	if (rc)
 		goto err_cmd;
 
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index adfbb89d856c..4c6752bfb1de 100644
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
index f3cd281c3a2f..a9044f47c913 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -84,6 +84,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	cfg->udma_count = 2;
 
 	cfg->max_stride = ident->rdma.max_stride;
+	cfg->rcq_sign_bit = ident->rdma.rcq_sign_bit;
 	cfg->expdb_mask = ionic_get_expdb(lif);
 
 	cfg->sq_expdb =
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
index 20853429f623..e6b17055147f 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
@@ -56,6 +56,7 @@ struct ionic_lif_cfg {
 	bool sq_expdb;
 	bool rq_expdb;
 	u8 expdb_mask;
+	u8 rcq_sign_bit;
 };
 
 void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg);
diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
index 7b589d3e9728..b1ec59efb49c 100644
--- a/include/uapi/rdma/ionic-abi.h
+++ b/include/uapi/rdma/ionic-abi.h
@@ -46,8 +46,9 @@ struct ionic_ctx_resp {
 	__u8 udma_count;
 	__u8 expdb_mask;
 	__u8 expdb_qtypes;
+	__u8 rcq_sign_bit;
 
-	__u8 rsvd2[3];
+	__u8 rsvd2[2];
 };
 
 struct ionic_qdesc {
@@ -84,6 +85,8 @@ struct ionic_qp_req {
 	__u8 rq_cmb;
 	__u8 udma_mask;
 	__u8 rsvd[3];
+	__u32 ionic_flags;
+	__u32 rsvd_pad;
 };
 
 struct ionic_qp_resp {
-- 
2.43.0

