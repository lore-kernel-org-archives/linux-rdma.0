Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063850;
	b=fbQDHH5UUSqWId/H/XTINCEFfSzTKiZskbRqxXXbEL869SiMAwLCHwoUV2sp+RG7DGDS
	 S6VQwgW1sFiNFMjCNfnnBW7VNvWBkcyOdjrKqX8sGz7i9fdSfLPVdU/uN45vvsSSFZLXp
	 FkiLN/bt1Pgtk11O1exd6Zr7vgQKTlar7qduwiq/xHIuwC0+eBXSPPBGRjldZ6hGTCHWp
	 ii/3I2PGN3fl+VGW6FV8/qgu63bCwLOFORZLfhtsmuamTP0AeevdkqNwf7PJv7SWuFjOf
	 R5ncHeWmuLRbUMaczoNJaPJTj4EOX91K133YstK8N89KU7jVnpqI9U/17oBmGwswTLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063850;
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
	bh=Ol2KMkgAcCy3Degyt+XGIspS+M4vV8st1WnSHYoYrSU=;
	b=e4dObRx2tAu7kWpycbUUjkj0EBLLhmnVNSP8caDIY26Usv0CuyMVNj6O+GuY76a8OzLq
	 h60NAGgOt3REfywjSUJPcZPFmxGpbLC6sCr/3TXvVQNkJduxAzQi79m83gqVL+A6Hmvz5
	 mpWZAptef/7O7WBxe42TKvYLU3sRDc5lCiPdPz4DYDvqXIgc2wXHZKNX4QmdHaBjorqsp
	 3wQJgkNZO/KWhIi5h1vRRDZsazRypw3/lpw+dCtQT1g9Vrlx7QFg1deo8uxmTjMPMuule
	 5rMaLlDh9NqEOEKkDkfSlIlkBUFpmpnuuk5Vzn/c+3FAg6Ok27K0BEiSNfHZzaO06oA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Dhx92kOP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.55
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012055.outbound.protection.outlook.com [40.107.200.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB70F606C009;
	Sat,  7 Nov 2026 15:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB70F606C009
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Dhx92kOP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tl4uQAY8Qsj9tmLvS0lVLulsxW4iYMoOkgGrcwkxGSq0ZJBnA1PKUe0Ubj6Q8dM2hWA0/KDGBfJID2yAgHpe0P02PH6XT+IdhfILuPO70tl5448LBn/jxnqG3ztaNm/nJ8UQBlY0YgC6AJuQLPt7+6+c9K6iXXtASnena6hZ4etbPuycAcnGxKwyF4dOhF6rMeDW51L5Oq70IcDDwjcO0himjjqf5zErZ4/L/gs6KVjbsR7JEZ37UI8v1iWLY+P3V1bYBEAzTyncI3hfw8Mb7NnjaldRp6dXl3MtPXYH476P1LD2ypYmOGYgbuP/SJEbjckcoxlG5JGtRbxPzGGQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ol2KMkgAcCy3Degyt+XGIspS+M4vV8st1WnSHYoYrSU=;
 b=Ue41Bq8XBVFn1QF4+FUeyZGEfJT49LbP+vhqqLIGPnBy/u9SgxhM4smBTvv+unl0pfrwoUMv3ZUlrA4oEUvRdVHUUQTNHKZmjK1LJU0UOmsPcHAGkpaV+1XFYZidg3hSqpOJi0NwytGXdXv/QlxNjKkr0bgrzA4d0qPD6mknssy66dvL0bm7oLeizt94S3b/TlxDeZW+Y+mgkvUj7jAe8nyP8B8flR9BCLU/wjGziFo9vCrh28YQUFgSJSYBrdoGUiaEpbEAHVRq2DqBPle5AoEnlSUetrWhKD50KSAY45GUa+9IlvSBHsPjEUWHHo988Wk3Dy+3OaL3SA86aMyM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol2KMkgAcCy3Degyt+XGIspS+M4vV8st1WnSHYoYrSU=;
 b=Dhx92kOPPXOLXd28tQpzlZPWbgu1xKPh2x0JJXcHCYC+Ve77KSV0MEb3NIewZuNA5cjfNwc8T7JBiofuUVKY/IecMA4wmOEx5zwhwl4aeKYegzr/BO4qWPeMNH/JtQZovdhpefOlFWHuUHrzxxshV1gpY/PPzY/jnLxZDndiXwI=
Received: from CY8PR12CA0030.namprd12.prod.outlook.com (2603:10b6:930:49::8)
 by SJ2PR12MB9162.namprd12.prod.outlook.com (2603:10b6:a03:555::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 15:04:05 +0000
Received: from CY5PEPF00000E81.namprd05.prod.outlook.com
 (2603:10b6:930:49:cafe::3b) by CY8PR12CA0030.outlook.office365.com
 (2603:10b6:930:49::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 15:04:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY5PEPF00000E81.mail.protection.outlook.com (10.167.247.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 15:04:05 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Sat, 7 Nov
 2026 09:04:02 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Sat, 7 Nov 2026 09:03:58 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <eric.joyner@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gregor Dick <gregor.dick@amd.com>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next 3/4] RDMA/ionic: allocate a PD-scoped DMA MR
Date: Sat, 7 Nov 2026 20:32:48 +0530
Message-ID: <20261107150249.1576835-4-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E81:EE_|SJ2PR12MB9162:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bbd8600-d81a-4070-503f-08df3ce05dcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|11063799006|261021121427099003|261021123027099003|261021135927099003|56012099006|261022105027099003|261009223027099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	120aH7jbygBvssty7Mk3sye8m06gcFb0VdZ1NQjXIMAjWfvr0yDB6yaYbrpr1lTciyNWqG3a0Ve/6Cn5S2/bK9ECtF1HxH1u1UBmAiyVOr8vzXufis46aUzGFAmkv+jlsCn6TK7Sxe13LLDCFT/Lo/lp6cCDhch/kyEd2jEz4ZugfyTkSpt7rfoGKLc+b1j0pDlZQqrSfHdpsKzApksIsPtDmvezGAZjaO84rhZ6MOlWXkXXla3YT94l42VbOv8Yee4/Ud3e8BnRdLMjjaJfizwe2Swjdzz2eYG0d+JPJze18c5dBrB76hHt4suVScEfhRSPIViKiiVWOabNBTftQ/95eKRJQLYSn4kIRUNSAYoqmuLEeFhpw4XrJ9e5uSIKbElgZ9tkApt3MHZEGfq8n3+ruU0CJIJcq+5eOUn2Roj1v67sqBZZo1VLViO79sREfaPy8RrjCUTchBn+PcmaBa93ijPxPBY2CUUbaeuZ/8f9bHIs1CWUrOntsQHvvLqCFZMjnMbGm+b9hQzB2L+/G93AcIs8GXRdcOJxU5HxEBUKtlAnquE5sL+B/5/Uf/D186Yw96MzrtI0qdXMLzPcYffw/d/mHlHQtvFEU7DByOFMlWicDnEgx91Eqkl7mHVaLeCzFznfEqYCd4ixLTPH3EnG6vTsGqaCvUg32ZYGeOS2EkcOpTA/MXNSHo7aNS2HFQRrhwC9ihO1IZ9xmTJy2g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(11063799006)(261021121427099003)(261021123027099003)(261021135927099003)(56012099006)(261022105027099003)(261009223027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pOJ4EKh1VgqKhPmD13lJ085HD+i3tnSwOOpeQ7cWLuT2HQXJHM32himY82TR2M3vIv9WJE119zj16XdwGuXz/4r7s6OJNikdcRnZxTywHavg6c3ZrUV6HltlzlAaV7D+xPAnNpYvQeuySjkjJWhxDn1OSeFhuSTXrgXLG2hGZR9u5DIn4CegdPP9GBC1F3qDv2rjU4lE0Oy+Yl7NUWszCYBxhrHfMMlYKkwM90OtdtnDcdOpeK/O4W+8J65ZTkmsW0kGbbtMmGHSHvvAUXBMosvIEtkDsvUxbZmFPX2BY0kQPdyk9IhR/GuNxy5HXd4ao5E8K+WFww5pFGZ7cISj2vAnGONsbHtKHX2w+RZOuRMoicTrFYCoWTGNVjJOhCT43iDOma/GS1Mwpe5J4+LdXMqlK7dKLKhwbNEVhCAvnrZp6kYaIzxKIRRnRc/kPNAJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 15:04:05.3104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbd8600-d81a-4070-503f-08df3ce05dcd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E81.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9162

From: Gregor Dick <gregor.dick@amd.com>

ib_get_dma_mr() returns an rkey for an identity mapping of the whole
address space, bound to the protection domain, with the requested
access. CREATE_MR carries IONIC_MRF_DMA_MR and leaves the VA, length,
and map_count at zero because firmware owns that mapping.

Signed-off-by: Gregor Dick <gregor.dick@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 38 +++++++++++++++++--
 drivers/infiniband/hw/ionic/ionic_fw.h        | 16 ++++++++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  1 -
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
 5 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 8a0a1575a339..b7f878c79070 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -910,20 +910,50 @@ static int ionic_destroy_mr_cmd(struct ionic_ibdev *dev, u32 mrid)
 
 struct ib_mr *ionic_get_dma_mr(struct ib_pd *ibpd, int access)
 {
+	struct ionic_ibdev *dev = to_ionic_ibdev(ibpd->device);
 	struct ionic_pd *pd = to_ionic_pd(ibpd);
 	struct ionic_mr *mr;
+	int rc;
 
 	mr = kzalloc_obj(*mr);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->ibmr.lkey = IONIC_DMA_LKEY;
-	mr->ibmr.rkey = IONIC_DMA_RKEY;
-
-	if (pd)
+	if (!(dev->lif_cfg.cap & IONIC_GEN_CAP_DMA_MR)) {
+		mr->ibmr.lkey = IONIC_DMA_LKEY;
 		pd->flags |= IONIC_QPF_PRIVILEGED;
 
+		return &mr->ibmr;
+	}
+
+	rc = ionic_get_mrid(dev, &mr->mrid);
+	if (rc)
+		goto err_mrid;
+
+	mr->ibmr.lkey = mr->mrid;
+	mr->ibmr.rkey = mr->mrid;
+
+	/*
+	 * Identity map of the whole address space, bound to this pd.
+	 * Firmware owns that extent, so the VA, length, and map_count
+	 * stay zero.
+	 */
+	mr->flags = IONIC_MRF_DMA_MR | to_ionic_mr_flags(access);
+
+	rc = ionic_create_mr_cmd(dev, pd, mr, 0, 0);
+	if (rc)
+		goto err_cmd;
+
+	pd->flags |= IONIC_QPF_PRIVILEGED;
+
 	return &mr->ibmr;
+
+err_cmd:
+	ionic_put_mrid(dev, mr->mrid);
+err_mrid:
+	kfree(mr);
+
+	return ERR_PTR(rc);
 }
 
 struct ib_mr *ionic_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index b8e996d4b8b9..100138e4cae7 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -11,6 +11,11 @@
 
 #define IONIC_EXP_DBELL_SZ		8
 
+/* ionic_lif_identity.rdma.cap bits */
+enum ionic_gen_cap_flags {
+	IONIC_GEN_CAP_DMA_MR = BIT(0),
+};
+
 enum ionic_mrid_bits {
 	IONIC_MRID_INDEX_SHIFT		= 8,
 };
@@ -47,6 +52,17 @@ enum ionic_mr_flags {
 	IONIC_MRF_PB			= BIT(7),
 	IONIC_MRF_ACCESS_MASK		= BIT(12) - 1,
 
+	/*
+	 * DMA_MR is an MR type selector, not an access permission. It
+	 * sits in an otherwise-unused bit inside the access-mask range
+	 * to_ionic_mr_flags() does not derive this bit from IB access
+	 * flags. Firmware tests it before decoding access bits and takes
+	 * a dedicated path.
+	 *
+	 * DMA_MR: identity map of the full address space, bound to a pd.
+	 */
+	IONIC_MRF_DMA_MR		= BIT(8),
+
 	/* bits that determine mr type */
 	IONIC_MRF_UKEY_EN		= BIT(13),
 	IONIC_MRF_IS_MW			= BIT(14),
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 127b79cdfc45..8e7e52c9f492 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -44,7 +44,6 @@
 
 #define IONIC_ROCE_UDP_SPORT	28272
 #define IONIC_DMA_LKEY		0
-#define IONIC_DMA_RKEY		IONIC_DMA_LKEY
 
 #define IONIC_CMB_SUPPORTED \
 	(IONIC_CMB_ENABLE | IONIC_CMB_REQUIRE | IONIC_CMB_EXPDB | \
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
index 66cee57442e7..dcf54856603d 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -95,6 +95,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	cfg->rq_expdb =
 	    !!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_EXPDB);
 	cfg->alloc_qid_cap = ident->rdma.alloc_qid_cap;
+	cfg->cap = le64_to_cpu(ident->rdma.cap);
 }
 
 struct net_device *ionic_lif_netdev(struct ionic_lif *lif)
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
index bc14fc0921da..998785fef2f1 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
@@ -26,6 +26,7 @@ struct ionic_lif_cfg {
 	void *phc_state;
 
 	u64 page_size_supported;
+	u64 cap;
 	u32 npts_per_lif;
 	u32 nmrs_per_lif;
 	u32 nahs_per_lif;
-- 
2.43.0

