Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010069.outbound.protection.outlook.com [52.101.193.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3898543E097;
	Thu, 13 Aug 2026 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786618288; cv=fail; b=dNlUBG8UPZt2ciod2DIJ9VWWs4fFIysjKpHThcnFEhcrxlt4855uAIGvuTtIhfcDnZl8lI47WDzhOrmEUUBeWy2Tc1MvBMklhKxcHO+zv8gyR2isl/E28Z1+k4yf223QCM5Ju7n/AF2oUTVqP9qGBdhzhNLzMoMHZCRde6g+/S8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786618288; c=relaxed/simple;
	bh=f/By6shj2UTeg3FqRgNF5zRAneEYH26ihArfsPNQ8Os=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shiL5L6LOreXlfJI3+ZG1iOYiK2EJW8TdcDUZ8v6a0jbBCfpOFFrPJZd/xVIPxSLUJr42EHHiquM1s8wGak6WA2kSW5IuTRQljiqoyQeTeoPFWXf0SRknhGb8R2eCWAd0d6qhV1PV+qpeMLWfoOLT6pxODEjE4N3w6ehkploM0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dbSCE9J3; arc=fail smtp.client-ip=52.101.193.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dbSCE9J3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m5jpBYku0vygFcvW34o8erPq7EY+f3ErkW2x5qvg6tdx/Tt91N/NUwM6XAp6p2PRwGq68AZs7jfYCXkvrfdOUPHohgoiWJsT0jl6jUnT3kd5o4o/L3J9KIqKVGcXr1q1GWS7lRpORWukbKQpkr6VAsg24+W1z1F7I1ZW7ALig6yjEpcu51aJp+DATw0OXGaErxb+cpZHnWupwXts4DZQARux0dXCqHDRzOX7TcgG3nGmbGVe6z+va4Z+XYiQ72UINpnCVaLN+5iYP0WNXf7wtplXryn6nmdQ8VS6ytZjy294ZyjM+yZDKYwh7uFBGveuYNnpFcLsDv8SqamQ1BJtkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7wwGi3E9ZLVmaJBEYyUnDA/6F7QWsMQpr2x2f4qtYc=;
 b=AditBvqNVIGd/vK3tV50w4trgr6LlToIMs0omThM4HJJ/urtCysOi4zNzXLmvwKjVrUODNZd5JSEpVfTGVzH0R2kAknozCz+yS0PEllq0TwHYIX0IoAWO1Z7u1YzM9V4N24d30hDD266+JA4T0XMrZIuvorSgipiDl3dwsE6H3sO3OwRTjlL5cBTAym8QIo6Y+RgRRAa/OPmEf5/WoPdkJpjGydIropGqVqYSU9qmywTL4j+nZxsnT1YleIzbiKrzjbadbRwsK2enIutOuZL7nnGvW+BkGekbDuLwvq++bTB9lkXPxJVROyLL6PtzzrPBT76AyC3YTYczpEkzZCoFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7wwGi3E9ZLVmaJBEYyUnDA/6F7QWsMQpr2x2f4qtYc=;
 b=dbSCE9J3zr7KLmn4eki1cdb8pVZ+ajdFt6cuPt1AMRkPdDyxIgzqNxCNuUDlVfwF69vDRG4HgLsnunG+vuUj0P0wcYPc8AyljB/YLzUZ7bIzLWgj4QCZIi9mh6/+O0BFyCx/Rcc8S4BfJ9LXNzvfoDzyBCnJdxweWaE8o4RKb5g=
Received: from CH5P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::28)
 by DS4PR12MB9746.namprd12.prod.outlook.com (2603:10b6:8:2a4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Thu, 13 Aug
 2026 10:51:13 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::9a) by CH5P221CA0010.outlook.office365.com
 (2603:10b6:610:1f2::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Thu,
 13 Aug 2026 10:51:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Thu, 13 Aug 2026 10:51:13 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 05:50:49 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 05:50:48 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Thu, 13 Aug 2026 05:50:44 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [for-next v6 2/2] RDMA/ionic: Add RCQ userspace support
Date: Thu, 13 Aug 2026 16:19:54 +0530
Message-ID: <20260813104954.319065-3-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813104954.319065-1-abhijit.gangurde@amd.com>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|DS4PR12MB9746:EE_
X-MS-Office365-Filtering-Correlation-Id: 7038736f-d30b-449f-794d-08def928cb4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|376014|7416014|82310400026|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EaXrVgYf7KnihKw1Aayzqgs6HmtzO5PMTOayFNBbLp5vvWOzcXpnjUkupX+fnzyEWUG6jXgWL6ZVH6x39bBB/iL7f53nJCI2AtsvEykyTnoROu96SbGRoIFsrk3PbfRNTu80OQPD9b3Rb5W8uF9EG0NqZ2mSbacY4Mq6VGh8kt8K1g/e8SwLLai8p7e1jnhYeQZl1/QAfIVJ+mE5fKqVkXwCK329QvgpsEUSMaRHqn/SYmOwFb/cW7fA9lZc7LgtHJd0sEE1u/sqNrukhz6E4ZYDtLxlexYL+6cyaVICYuRuOGxBFjKNrVvlta29JCw4MUjka+1tG9h6aOUb/VlavuZlzhPpV5KZ2PLJbRtSeDm1cQoyNyKgLfkDYtDuAbj0RHMxr97ryKU5DAOsHGTSRrjtFxlf4OFg+DDEpY4CT8pCvSTz0oWW91bOC8neITt3+S0wrXtwvDnBD3bM2Yxu81ZcBVfrxQKjIINc8NHaRgWAEGYj64J8JYDLNPrDwX3XkIA1qsCnxgDSwy6Qy7Nb4+miiHK0rGg/jFKmr2PABmyrOOGf/gkRwOnkvVAa4TlXdR0vxjoRXaa9mzZIEcrnmfrYp0mcNlEEu0yK8ipd7zOvs9vKMe2Pg3eEFKBBHUKcogjoqtQdnhmjljaug+zn/FkPVoECeGdAs1nE52SqSIVnxIAPevjlC7zbsfEyW8Gcm0sY4v/K4gE6yaAd4wpZLg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(376014)(7416014)(82310400026)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8UtKoSliRUfZA2P0Mo8fotA35b3/RxxWb9eBfnILCX+5y8iZYs4AosUQ2eUOetQQkAWWgSONKK4NknJiDVDVnQQv7XPfQFBE2uj/TmOYhAvmSuk9rZbABvnT1yC10R3G93c2BgVHKOZWD/n1guwRjeip4Kgc1R72s5IDRObYbCO8l/8jDk7VAFwWdQ9cgm4MqfKnFRyk4jJJ4qfqHVystLaKarhKbP66PO4bl+278AOJGwC0U3jOajfYDjI20F+pSAQS5oXBb4ResJRQp62ER0S7PiaSfZITXFf/62IQCKBAagF6Cs3ZPeB8JQkaXSZOF12fcxZW/zTmoclowg/w0A+8/Yg09XKb+v1qLglgt8UmQy/zin6t874qKVGZ3kyuOxbuOIpb3daOmKd5nDebFlkTDB32X0PqPTiimIuvGRUIK73X6Qv8lP3Suohcq06n
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 10:51:13.2851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7038736f-d30b-449f-794d-08def928cb4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9746

Expose the Reorder Completion Queue (RCQ) capability to userspace via
ucontext response using a comp_mask, and allow userspace to specify
ionic specific QP flags during QP creation.

Co-developed-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 20 ++++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_fw.h        |  2 ++
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
 include/uapi/rdma/ionic-abi.h                 |  9 ++++++++-
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index a70ef59a8064..37f71fb43811 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -418,6 +418,8 @@ int ionic_alloc_ucontext(struct ib_ucontext *ibctx, struct ib_udata *udata)
 
 	resp.udma_count = dev->lif_cfg.udma_count;
 	resp.expdb_mask = dev->lif_cfg.expdb_mask;
+	resp.rcq_sign_bit = dev->lif_cfg.rcq_sign_bit;
+	resp.comp_mask |= IONIC_CTX_CMASK_IONIC_FLAGS;
 
 	if (dev->lif_cfg.sq_expdb)
 		resp.expdb_qtypes |= IONIC_EXPDB_SQ;
@@ -1388,7 +1390,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 			       struct ionic_qp *qp,
 			       struct ionic_tbl_buf *sq_buf,
 			       struct ionic_tbl_buf *rq_buf,
-			       struct ib_qp_init_attr *attr)
+			       struct ib_qp_init_attr *attr,
+			       u32 ionic_flags)
 {
 	const u16 dbid = ionic_obj_dbid(dev, pd->ibpd.uobject);
 	const u32 flags = to_ionic_qp_flags(0, 0,
@@ -1404,7 +1407,12 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
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
@@ -2221,6 +2229,12 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
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
@@ -2301,7 +2315,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
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
index 8e48c00d4959..1e37bd09490f 100644
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
index 2c70ac149c4f..3d8d56922a93 100644
--- a/include/uapi/rdma/ionic-abi.h
+++ b/include/uapi/rdma/ionic-abi.h
@@ -22,6 +22,10 @@
 #define IONIC_CMB_WC		8
 #define IONIC_CMB_UC		16
 
+enum ionic_ctx_resp_comp_mask {
+	IONIC_CTX_CMASK_IONIC_FLAGS = 1 << 0,
+};
+
 struct ionic_ctx_req {
 	__u32 rsvd[2];
 };
@@ -46,8 +50,9 @@ struct ionic_ctx_resp {
 	__u8 udma_count;
 	__u8 expdb_mask;
 	__u8 expdb_qtypes;
+	__u8 rcq_sign_bit;
 
-	__u8 rsvd2[3];
+	__u16 comp_mask;
 	__aligned_u64 phc_offset;
 };
 
@@ -85,6 +90,8 @@ struct ionic_qp_req {
 	__u8 rq_cmb;
 	__u8 udma_mask;
 	__u8 rsvd[3];
+	__u32 ionic_flags;
+	__u32 rsvd_pad;
 };
 
 struct ionic_qp_resp {
-- 
2.43.0

