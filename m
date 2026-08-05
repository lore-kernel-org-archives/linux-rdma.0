Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41C633F5B0;
	Wed,  5 Aug 2026 05:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785908036; cv=fail; b=fKAGuMVOgbWJ35pPREUWRwirb5auUZQhowL9YPqqmpgeNsPo0bp6k0BvK10DnE7xgbQBJvlFz6iMZFZs/p05FD+L54yiEd/H3LfiaSTl3CxBolI9I6wNAhd5+pllOGONoxGx0vROZDUVqRCaj7cVKJHaOUgx6tcel4cotSsbRwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785908036; c=relaxed/simple;
	bh=E/22vlE4EURb2ZymkFMduptQu9hayO9adxvdGK+QxAk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j1FDKqUS+IEXdUUfh/jKC36NfJGyJ6f7LQQITXmumWdcsa3llAYe9m55XUHmKQK+WokI/hx1wfxA4abevNo5V7zxN0d3ZrsYuQ4+FNgfck/beM2criXKfEysyJT9ZcxC/GL+o0M3QBRPq6l3N4SKeXQClUThIbmoIknEwhVXUko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b0/N5bNY; arc=fail smtp.client-ip=52.101.46.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b0/N5bNY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tC/iRpePxN3l9eyZdvGor8hy/E/m2HwKL/+fFjwUAwQp4F7ULJXbsmWEyVCLxZ67rGQcHa645p4Pjq3KD8oxSAhvJXMIl94qdh+7ce/usb4aVkoRFB6483GoQidqVPXTPWe1SPh/vEh0eaOQJbeJEWoRbrvHvdBXUeCq5LMeMZB1kBIEbtmfk8QjkL+UlppenlmCmHzoEHZE5WGRloAvd8zaNHgPQJMP4b4ypt53mUYXOUQBF7HETjjGZGGUwhqhhoruidRk5LyxHYokViC+fzWhosTG4bHEAotGwW8mUW1i+TfbH2rZSygMdAKJtguZAT/F1uJSFZkcfkM++1nr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmHhxf73gg61p76gtWxiauSjPFeJu+q8NPMY0eDqHWs=;
 b=M3KnSlt5ggeZjIiln1uy8xehNkW10T970J7rhCcx4GlQqv61HAz8zVa2djR1J6+Vb5uFF+T3+dtV44yOU7e1wGWBw7xakT3cs3Co3xcvUXwdV07Bt5FGwonRO/qdTIaXbBt+PE76AIO0ODEtElG7KwZOU3jSVKN+yOhP2GkJ0U6F+/yxOGwHonvItQkVd1tobdx8jOd/sM4DFXV/XHsekFbhN4HBO9+vJrwsayVlIVfKtSBcy4zCi1jyVv3StclLkx9q98dETtoKcSv5bdBmYtpF6OkRSfR/0ElY9PEh8ZwUemIpFGgP0dSJmuD5Zxtt8Xo3IjL4nPci/f5rTeHfmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmHhxf73gg61p76gtWxiauSjPFeJu+q8NPMY0eDqHWs=;
 b=b0/N5bNYL0g/B8Jj5DDxXFZ17GT/e071P7Hi52AKE8djpPCzWHZKYUxtLvQE/7SKYZAha+KWWkDSjYMZBnWHm4jeQ2ZvBxtr7lSr1RPjTt3uAceWt8gLtgmTX2KGyeAPPFxYha6iPiHWOJOjNivyRs/0qqFSJRvKQYgByXsABtU=
Received: from DS0PR17CA0018.namprd17.prod.outlook.com (2603:10b6:8:191::18)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Wed, 5 Aug
 2026 05:33:49 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::27) by DS0PR17CA0018.outlook.office365.com
 (2603:10b6:8:191::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Wed, 5
 Aug 2026 05:33:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 05:33:49 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 00:33:48 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 4 Aug
 2026 22:33:48 -0700
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 5 Aug 2026 00:33:46 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Brett Creeley <brett.creeley@amd.com>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [PATCH 1/2] RDMA/ionic: Cap eq_count to the eth driver's interrupt vector budget
Date: Wed, 5 Aug 2026 11:02:53 +0530
Message-ID: <20260805053254.4023262-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d0df4d-e29b-45c2-dccb-08def2b32077
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XOyGR98DIzlDxvjLdyDWC7yf2LAzQDdxpa/fJMLujsYauBNEIMMOKBER91obXaV/Fe7OIjMQCAwOiQcZayuX/cddOJfpv/eWWfq2cFNY/XGTGVIvwGn3/BgZk3zzHsfxAjBKhmh5OSB1j8NqzfGvzxH3nIsBxRiiteT+R0eEnt/jsV1fFR7SindL209P9VjmmApXn8AiowS8dLgTFX147oEVjJJMUkS1rVdouHI5oIYuAn1C+lwPjGAWUNbxxw1B0teLbwE4IFzy8Y+Eg2wkfbEBbIEL+UsNzaM84AhmsoRw+EjZKQ408liNBK+UBrZuv+flrzROF77Xj8AkYg8J2gxuYdcUImS+K8amQiqn3kIV158dUl2fPfiM81YyDY4UZzFQKucVCiMds5+PPsUaXZkfJoLbSIy4gu+jDH9oIV+7UDQtMxvF0cRQrT8VPVSRX5zyCj7eXdq//Piitx1PCyNvn9kT9fK9t/OgihiIm6K5xkWSrKnqDKdMKJFh3uoy+LcLacX4JwCBEWG8k6J7y3kKmUWCmMN4iAk05WI28YZqCcwBOkf8tvqaRTGZZgZcDV3ICQ8MLs301WSfY3n5FGy0OwnAMWiYdbl5pcBgaBAQitEmGTs5Wor+oYPIWGltnb6HpuJO8jwUGlM4xfbwVI0S3LYqupNNG073z55/JPKMc6q8J74MSiKoLFcr3zsh7dLrasbkklq4fYw7MEOjKQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/Xf+HFckB9k7N+elEV9oig2Ne2mFsIHTFmo4yIwNo9f+wcJZehbW+1epcSWGeoloEvuArj8RPjv9gW4Fl5xDp5gujzJKVUoTsUkdoP9XAhJzJ67w2WkyEDzkwxf3tNRCDL9VQpWXSQILXK0ZWG8zpHlsVQBOwP2pRF3cvlpMvCpEEuWcIkE1hP0Mxp+U/DK6iski1k3Mz910fmVEFlfW6iY9/C4JH+oPLVAC7P3P9Th+QqtdzCLUu0wzijzvcHfd2jy+EV0YTW1ZqlOL19wPp+bI7VSCgUQ0PLNc7M3JVYo+GDUrWAecL3U44wxoFJas1sb2XGkkrCGJrQM8mpmKMR59dRIiLMPArBiP8r7GFYhx9NJepKqHKcQxsCXTUVR49ejvgpxXbD71bpm+0BEjn/r75f58K3XFFJGZJNFlGwCt2T302l+fXSGl/FVuiNub
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 05:33:49.0355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d0df4d-e29b-45c2-dccb-08def2b32077
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688

From: Brett Creeley <brett.creeley@amd.com>

ionic_fill_lif_cfg() reads eq_count from firmware uncapped, but the
eth driver only reserves ionic->neqs_per_lif MSI-X vectors for RDMA
event queues. Since ionic_rdma probes via the auxiliary bus before
the netdev is brought up, it can exhaust the shared interrupt bitmap,
causing ionic_open() to fail with -ENOSPC when allocating rx/tx
interrupts.

Cap RDMA eq_count to neqs_per_lif, which is populated by
ionic_lif_size() at PCI probe before the RDMA aux device registers.

Fixes: 8d765af51a09 ("RDMA/ionic: Register auxiliary module for ionic ethernet adapter")
Cc: stable@vger.kernel.org
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
index f3cd281c3a2f..45846dc2e89b 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -70,7 +70,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	 * eq_count is tunable; see ionic_eq_count
 	 */
 	cfg->aq_count = le32_to_cpu(ident->rdma.aq_qtype.qid_count);
-	cfg->eq_count = le32_to_cpu(ident->rdma.eq_qtype.qid_count);
+	cfg->eq_count = lif->ionic->neqs_per_lif;
 	cfg->cq_count = le32_to_cpu(ident->rdma.cq_qtype.qid_count);
 	cfg->qp_count = le32_to_cpu(ident->rdma.sq_qtype.qid_count);
 	cfg->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
-- 
2.43.0

