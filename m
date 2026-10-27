Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793093051;
	b=m2Sdn79dSS1AYy+T4XB1ayklucBuhzaUG+uT6jRk+mOhKLetPf6+8O/DaEeK26sVZ8yx
	 dnta8i4wDaz0tvhq9Zx/N9vKI5xpyy6/Ff+Y6J78xuS+owNmeGLBRxIH9FeTPTyjp3geX
	 4epAogtugLE6rzxtvE7UOW/pTyUpfFBF1m/2b2vsYscE1wXEI4T8XygZzh5z9NAHkWUc2
	 9I+x4LVMfU8LZUKKfUxA9T7UdvAqovk1tRm/ILZuNCofZ98tpAxM6GK5updsiy17tm++C
	 gxGjoZAwjWZn7zbrHmG0H6WmCyaIVZ1bId8Xw+cgv13s+aW7oAlzFp6s6lUIiXRX7mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093051;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
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
	bh=Ph0ZXvKbsxpY7eBsdQQIhIvjzpqB6VMtkKZrkUL77CA=;
	b=2M9JPxaH/tNK795QSstNmb/26HhugOjodiIoCoxe5+eVz3toyu3jVzAl+xitHRIvD7kk
	 HKrBgVCLuhISZ1MP3UV515JEHDoUUytlidoOAtfdX+g3GLnhlNVFi5meagQvoHWISSeO3
	 SnkcZYmmiYTazZZDqgE96AgTxrTkP3DVWs5u3ViYGfLN3ZvgaKkjsTTWzUFiX8GP3z9PJ
	 ZBDyDNa9Cr2TFG1ayR27tU/uNRUba/HnLnvPLBwjm05TZtisfL5GH8el8o80sz0DnnmA/
	 MnVbBL5FNpHVf6VbLXzLeyqquTa0NRr/k3iuGy6we5ofwae2+OtyhNttva6g2vgJLeQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=T3QCpNZb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.22
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012022.outbound.protection.outlook.com [40.107.209.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0072606A31A;
	Tue, 27 Oct 2026 09:24:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0072606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=T3QCpNZb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXQrcCptLxbmgb4PuoXwxmscJ3UuGmI7rDWDcm7c0zj/bUit6RT3Kht4AK9nIeOfwYYZQgKjPS2+a/4Wgpp61UmkkhJBh44dEWsF7cRXXUBGEk5jeFbERGePRxg43QXyrLz1xIN+cTk2kCOSU09cj9G7K13ewP/zvRghbvCR2v0WKlU6vpOlXpuBdwEbBl+r7CZu5fMFPg3rvPV1sgDmu3opYTHbWWtAscJ8HggWPOgHcggAIt5vyuPqssHL832ZzFd1oZmPxh/f/i8C2A8FmX7hFtMU49pYJOPpCGNH6jwoYiFi9xyzqKdvT9a2N8B5+o4lWMab9wjuSFKEPm/Afw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ph0ZXvKbsxpY7eBsdQQIhIvjzpqB6VMtkKZrkUL77CA=;
 b=FjO0XmB4aFxF52E8W+ur//HZ8xo0PlO0cq+MK+qxB3cbFge+iSWvDmX3TeYUKUoimgev+FyxuN0oTlvzqDJY4uPMMVyz78WjTBLeXIBZy9dJATTxiT4hBfMOeQyrxa1bEkGG12acdMUP3mgUCAUsjyZR10rkDv7TUjr21cbrDmo9SPaiHV/F8oWGwl6/5qf1CDJ3nfeGpXy+jYFOwuMtEGdqjRHSo3/pE08fG+BAyFRct2aZM5XFm7kY0BwvTvW8K+l0fwY1+0GFk88DzJPxD+vcDMEzYVBRpOx8xyTqShsLX+3QmxZh6Lk+8o9ASJb+JqeQcRx/zzFstl+nkgU+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ph0ZXvKbsxpY7eBsdQQIhIvjzpqB6VMtkKZrkUL77CA=;
 b=T3QCpNZbmoi8MO+pA9K0cMtSrBuj0RNrHPEdFs+2OKAMI9QgZqdRakFCrGPsDcMwJu/rdymhiayapTB57kmRWrKDjmPUp4OZF2I/lJlz1r584iwWJOiecLXfZlF/slSuUDOz4yUcH6UyAt4WtTwNrxitngnzExoEiwcmO4jYMw4=
Received: from CYXPR02CA0063.namprd02.prod.outlook.com (2603:10b6:930:cd::8)
 by SJ2PR12MB8805.namprd12.prod.outlook.com (2603:10b6:a03:4d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 09:24:07 +0000
Received: from PH3PEPF00059619.namprd05.prod.outlook.com
 (2603:10b6:930:cd:cafe::70) by CYXPR02CA0063.outlook.office365.com
 (2603:10b6:930:cd::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Tue,
 27 Oct 2026 09:24:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 PH3PEPF00059619.mail.protection.outlook.com (10.167.243.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Tue, 27 Oct 2026 09:24:07 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 27 Oct
 2026 04:24:06 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 27 Oct
 2026 04:24:06 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 27 Oct 2026 04:24:04 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next 1/3] RDMA/ionic: size the MR PTE reservation to max_sg
Date: Tue, 27 Oct 2026 14:53:51 +0530
Message-ID: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: PH3PEPF00059619:EE_|SJ2PR12MB8805:EE_
X-MS-Office365-Filtering-Correlation-Id: ae979c87-d712-45ab-d8c2-08df340c0cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|261009223027099003|261022105027099003|261021123027099003|261021121427099003|261021135927099003|10067099003|56012099006|18002099003|11063799006|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	6xKUyPcuK+xneeARDzeofEQ1LNXwP0alNGanYFWVWM6oRpDGmfXu6Erc30UJnRJZ4SNzzyUJmLGhcmGG6zzNVpTwXsXX5F1E8mbiOsF00CMAprlqKG2jH3ao5SSOxnxCU2p69nnMEg2pMrgRQw9uQWJVqKQbYxoczCC0j7O30+ddPJwf89wBa0FfuxVZre5C2Zm0KKXcCh7g5PRGplEwaFQsBcRjnVJ2qBjQUtzYPrEdSDHPHhkbG0ZDMy1nJ4lm6KzdmHeVRsEk+bIXxFgi539eWFAUIZBhmkBCajwfoA1CaiEkOvt81sf74EeCe6XXFv3ndqHw5+oo/d/sM/7V24cNwyB8/vLrnuQRS2TbeZe1n243gC6D6IhgX2qD/bZ0HOsd5B/ewdXYsxxPSN7kVWIjtLwPmlcICdVFAb1Fk/yrH0IOGHUqB4IxR+emKA3FGL26dJsJcLHLhSaI6lf6jvBb3MAahFTHgxDrZP0LDSSRYesM6m7OaVvvZ9H48RGRmYrYzxPIj4ztS6lJBTfVsmxHQpSjXDA+c4UB6q8Y9LKYd3ijuMlARmgBv2vjVlgEj+uUvL2tr0bULXnDyhcBkI23x+AEgDRopC8tVlCBkqiXKOn7VX4Dby8yQd2UMP3dTP2QJpYTU8fmBFXEopH7unVa4M6BPbtpBvX5c18uozbWgAKVISCem7G1P62fBL8rViDfKagYPeFTkGmRpoqlqA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(261009223027099003)(261022105027099003)(261021123027099003)(261021121427099003)(261021135927099003)(10067099003)(56012099006)(18002099003)(11063799006)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4UHGrKwh9ksqcZFyp4lb8WKoxs9ivnjUU1QqUXoHAoGs/N/ptyZuQeJIO1EH8DoQtoYPAD/Wzshy/TuftvHkjZ9jF2PE4IAadBv29T1AKuFh/ptYJxnUKeXq7J4y68nabAVQgbQcCumxOVfPuqA9L1ZcXWPETDk7lJFr/WYf/VF999gMuA7qYuNB0zQadw7aGMremDJUPtraWH9Q7UjU1ubMOs1/JxFEPO7ltA9cL4t8+OFfbR296CrPQ1l8VDe+flAXD66OYu4VMG6kclcjJaflAWgVMSQOSIIb8Lyy2y6MNnYfEVdcplxjimE8yJVWifxHQwde6411sRRkCGyozq9Ushq1wElyr/160mpIQaJvozEiumf3TtoppWySmBPRwEMEck632do83vhLwpRfu9FvSm7Pooylrwl+FhwW+Z9nielSAGJ4mqb4ySGDw9fq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 09:24:07.1211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae979c87-d712-45ab-d8c2-08df340c0cf9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH3PEPF00059619.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8805

From: Amit Kumar <a.k@amd.com>

CREATE_MR with map_count zero makes firmware reserve its default number
of PTEs. A fast-registration memory region (MR) whose max_sg is larger
than that default fails at REG_MR.

Pass max_sg as map_count. The virtual address (VA) and length stay zero
because no buffer is mapped yet.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Amit Kumar <a.k@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c    | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 18ad967812f5..00f9086f3bab 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -1121,21 +1121,25 @@ struct ib_mr *ionic_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type type,
 
 	mr->flags = IONIC_MRF_PHYS_MR;
 
-	rc = ionic_pgtbl_init(dev, &mr->buf, mr->umem, 0, max_sg, PAGE_SIZE);
+	mr->buf.tbl_pages = max_sg;
+	rc = ionic_create_mr_cmd(dev, pd, mr, 0, 0);
+	if (rc)
+		goto err_cmd;
+
+	rc = ionic_pgtbl_init(dev, &mr->buf, NULL, 0, max_sg, 0);
 	if (rc)
 		goto err_pgtbl;
 
+	/* NIC reservation was already posted. tbl_pages means "mapped". */
 	mr->buf.tbl_pages = 0;
 
-	rc = ionic_create_mr_cmd(dev, pd, mr, 0, 0);
-	if (rc)
-		goto err_cmd;
-
 	return &mr->ibmr;
 
-err_cmd:
-	ionic_pgtbl_unbuf(dev, &mr->buf);
 err_pgtbl:
+	/* Keep the id if the NIC still holds the MR. */
+	if (ionic_destroy_mr_cmd(dev, mr->mrid))
+		goto err_mrid;
+err_cmd:
 	ionic_put_mrid(dev, mr->mrid);
 err_mrid:
 	kfree(mr);
-- 
2.43.0

