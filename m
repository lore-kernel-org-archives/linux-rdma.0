Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795015414;
	b=ysZ8XDjVv6AcAoH2yFNbTtTQW3C9RpyekBIzP2tVsV+W25xY490T0CRAdhQMZfg9za19
	 CBQLbG0u5YJ4DbgzkB2emvqzDg9mJMmCnsSp942Zyet3p0DSAkMEbMas2/OcdZifi1BoY
	 a6ap8xvpoksbRoixPz4Bz7mwlThqVRe0EcJ9E31DUN8QPa4hJZ7iI1MXZw12oavEEa/Vl
	 Ky+DDS20h0MwhxUONQbs8M1dKr+uMSyhUXXIFnOpwuCtAOnB/MEjE1fIWxrs3FMIA8Spq
	 pyPi2jYu6EDoC1vWNG9DBYbG5kpRPGE53TPT587SjfYxrTSw6AlOnisbIXpSpofOn6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015414;
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
	bh=2C9X8LTrtQoPv9o4QygSkcww4W0HplBBjURmXnnMcXg=;
	b=d/lapQDCLO4zK81MSFXhL+WR/+pzXxIkJp7A2bi9lQ2Y2xVoOlXcTaDex7SQFDLSCKkl
	 gDyDHT6cjTc7hKjUCDSO/a6aEgzDokP4s3jr2DxQ8PoYEaZbYvFT7bFwyFh4rc9G9LM0x
	 yr87ebkFjZFHJMWpn4iNCZmZXDfGLTulxOpjuIQP2RzBElvRDlimzNs/MKUU16LP0OZf8
	 SM8Kn8VT3vSeJoPGktZG2OZHhzU5Z+OEAknecPJxWF2u3SUJKqYojpFnZ/nbEfMhX5XMU
	 cljkGX3JpttpSq+DfQwU09mXzqt9Obx7I/WEhuYotAcrv1RZDwUkLf5gyuFHpSv4jAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0839ptqO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.64
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011064.outbound.protection.outlook.com [52.101.57.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F700606A31C;
	Wed, 18 Nov 2026 15:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F700606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0839ptqO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IsbaojRxFiq2gUWPBymWIrPgBePmT/m+yt4kQUVf8PC/7vLwtwO95eBwXfTt5feDsZHbVTb42vIvtPQNaDABGpP5SJJnqyA0J9kYWAA2Fs9L8/L/O+aglVskdUnqxINeS/nZzjT73B7mHM3IdCKh2LXxy7NINnPnnKvlT+nA52uNt71AqckHNlGdUX13LKxN3edZ0PayuZgNR6v22uItzL5c7ueqAf3hdrpHEnZn9nAZGKuo4jOaEVL6xdJGpNEqCHZ4ZpZIcvjT7pe9KANDjnbn4Y4Uhz+p60Vh55Huw6bwTLNm5ofuSUzc2GGr0ZLK3+udABnvuxHMiqRqlt5QvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C9X8LTrtQoPv9o4QygSkcww4W0HplBBjURmXnnMcXg=;
 b=hkBI9oNm4l4OwiR12ViDXXLRYcVsaWNCSeFPUIHMVRDpfPoBcPl1FZpLD/cpFAdjI1r/0aKXCeZzpGj/Ct2592knSGFdpV1YC9R9aHhdhvsCsqEbp897uDT6AsYMy6YoLbRS4dzL58I/j3/CC7iOdAl39/7JGcNvC5oM9UTxp4sMRdl1L/3WazKbJzaL3KbbWLNG5MLsCVoJLqQRdt+R+/690Az9SHvi4usoOQlxMm/T3Te/Mrf7Kjfq1quRvpqm1cvhLzbxBW1jnh8C9vp8Hl0/zsv/RjAexPxoKDwzlaFtSe4NAL+4f1NnJAIIaig3Y5DTdVkqUTR74PFOp2rBcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2C9X8LTrtQoPv9o4QygSkcww4W0HplBBjURmXnnMcXg=;
 b=0839ptqOJk9zPZfuHu1eBXAVo0zAVqlMPE61h4KO7BYNzX0yrWhxtJ25Zi02PJuZih8cLo99aKBhL6z0VIO7IClU9atjEiw6Nyyv6qlCi2B1lvrAKv2+NQqQM6HyTLuaWfaZWoALdnOf018NuWEJmvMI3xVd8I1U3m64+TaXIeE=
Received: from PH8PR21CA0020.namprd21.prod.outlook.com (2603:10b6:510:2ce::27)
 by EAYPR12MB999132.namprd12.prod.outlook.com (2603:10b6:303:2c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 15:23:25 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:510:2ce:cafe::3d) by PH8PR21CA0020.outlook.office365.com
 (2603:10b6:510:2ce::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.1 via Frontend Transport; Wed, 18
 Nov 2026 15:23:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 15:23:25 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:23:24 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 09:23:22 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v1 1/2] RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes
Date: Wed, 18 Nov 2026 20:53:12 +0530
Message-ID: <20261118152313.113714-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118152313.113714-1-abhijit.gangurde@amd.com>
References: <20261118152313.113714-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|EAYPR12MB999132:EE_
X-MS-Office365-Filtering-Correlation-Id: 4424f84f-3177-4d5b-5da7-08df4587e3ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|18002099003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261026121527099003|10067099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261021135927099003|261021123027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	OhcQUZiMf6I0+P0fgmW1iZfa14C56DSgA2CEAR6zo7GTjdzM1VMGLhsTOloGrO8BWGHA1i9JS9zfoXZp+JurnqZucdRB8Iot+7DZbA6bPTSGsP61zyiSy87r2tmNbwVbWm3H/OsWbaXGgT/hd/iHsOnWC+O7x6X7UUWus+wr32UFXZuNmSG+vBjzpiI8x6Yw6x88D1V9V3E5EVlY8atQXzLqHspEN4xi55p9MLWDmQsatZmOQefw+3hyAyznwA7QpsOjq2ERFyZZG8p2tOkU8iM1xILoDFo2PZZ5d8fPu/meo1qWlS58vcXIMmkpr8zlz5chBJWqzvtzIyudgtq81AFO7oMTFSlcFv5Bp0bUyELonlJxeCa45PAHfY0VO55CYmsj8f/UMmJIS/7Ibqoi1mdtRClrEHvwlHqHha8FuMrkhae9HKy9plkyr7oSvJcih/Z6Fnn5xOt78Y4Et8RJ7wpTB+jz1Ul5cpv5ClRusEMc3rok53FSXxN+vPAR0suTCt2Rcjv6m3aIGgfVbcC+Rtr2Zgf8DF8BMTPi+XvIapoVw5G32EyvhC2ywZKpHisRzHrcMJTiyOBAGuCtsH7eK2mlfq62zFRKk54JEw8vaCmvnaowQNoGjwI25Athj4IdwvdC8fCnl5XxX8UEYpbohbygeEx3byLOxQZnqQPKNZmTdzeNPCVMdI5H2G0O+Uwvv0SoRusCDo5mDApbzdv2jw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261026121527099003)(10067099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261021135927099003)(261021123027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pHGOqPZPlCJ6+HFj3z2FpiRES5N2QO4ILDnz6GCnpYo6/VEBKVVe9UzbXL2iMkC9IbFGyB7wupIqqopANUb00zA7cK1w51442i5ceXbPkgbtNErX/fwBekfCytkgTXnqV0S0juPAUt2WsIIGlJHEwb15LHiKLPjaK00Qmn61Z1AvLzDHoQyLzqJeJEE3Hm5IeVnX7MhZFHaeV+U9goJOLOhvBiEENZbBohhzlhkAhFoYYVsqQTvGYQYNxmHh/9dwrkUB8b+aTSGHW3+W7XrnGUx97kyuS0/hsds3yYOLqFZRMy4sEOnsFiYrryPyIt64+CpPRSCIEt5jrUIet+BNdhY6rfL8eHEDPHL4riyY4GFsu/mEm/dtxDDjWn9KmTTrV0uOZxAvE0C6jZaaTi28uEQZjzm4g0Ld43Yv1fshJbGVbgSmV7gTMkD1YJzOCP+i
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 15:23:25.5416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4424f84f-3177-4d5b-5da7-08df4587e3ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999132

Userspace can now pass each enabled CQ ring to create_cq as a
struct ib_uverbs_buffer_desc in a per-UDMA driver attribute, instead
of only as a raw address in ionic_cq_req.

Advertise support with IONIC_CTX_CMASK_CQ_QP_BUF_UMEM in the get_context
response. Register two optional UVERBS_ATTR_UMEM attributes,
IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0 and _1, on UVERBS_METHOD_CQ_CREATE
through ibdev->driver_def.

For each UDMA index in udma_mask, ionic_cq_get_user_umem() resolves the
ring buffer:

- No attribute: pin req_cq->addr as before, with DMA_FROM_DEVICE.
- VA descriptor: desc.addr must equal req_cq->addr; pin as before.
- DMABUF descriptor: desc.addr is a page-aligned dma-buf offset; pin
  req_cq->size bytes from desc.fd at that offset.

An attribute for a UDMA index that is not in udma_mask, or any other
buffer type, is rejected with -EINVAL. The kernel admin CQ path passes
no attribute bundle and is unchanged.

ionic_cq_req and ionic_cq_resp are not changed, so older providers
continue to use the write command path.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_admin.c     |  2 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 89 ++++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_ibdev.c     | 17 ++++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  2 +
 include/uapi/rdma/ionic-abi.h                 |  1 +
 include/uapi/rdma/ionic_user_ioctl_cmds.h     | 15 ++++
 6 files changed, 114 insertions(+), 12 deletions(-)
 create mode 100644 include/uapi/rdma/ionic_user_ioctl_cmds.h

diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
index 0ccd869ad8e6..67ce56acb4dc 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -575,7 +575,7 @@ static struct ionic_vcq *ionic_create_rdma_admincq(struct ionic_ibdev *dev,
 	vcq->udma_mask = 1;
 	cq = &vcq->cq[0];
 
-	rc = ionic_create_cq_common(vcq, &buf, &attr, NULL, NULL,
+	rc = ionic_create_cq_common(vcq, &buf, &attr, NULL, NULL, NULL,
 				    NULL, 0);
 	if (rc)
 		goto err_init;
diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 8a0a1575a339..11458262f280 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -73,11 +73,70 @@ static void ionic_put_cqid(struct ionic_ibdev *dev, u32 cqid)
 	ionic_resid_put(&dev->inuse_cqid, bitid);
 }
 
+static const u16 ionic_cq_buf_attrs[] = {
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0,
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_1,
+};
+
+static int ionic_cq_get_user_umem(struct ionic_ibdev *dev, struct ionic_cq *cq,
+				  const struct ionic_qdesc *req_cq,
+				  const struct uverbs_attr_bundle *attrs,
+				  int udma_idx)
+{
+	struct ib_umem_dmabuf *umem_dmabuf;
+	struct ib_uverbs_buffer_desc desc;
+	struct ib_umem *umem;
+	u16 attr_id;
+	int rc;
+
+	if (udma_idx < 0 || udma_idx >= ARRAY_SIZE(ionic_cq_buf_attrs))
+		return -EINVAL;
+
+	attr_id = ionic_cq_buf_attrs[udma_idx];
+	if (attrs && uverbs_attr_is_valid(attrs, attr_id)) {
+		rc = uverbs_get_buffer_desc(attrs, attr_id, &desc);
+		if (rc)
+			return rc;
+
+		if (desc.length < req_cq->size)
+			return -EINVAL;
+
+		if (desc.type == IB_UVERBS_BUFFER_TYPE_DMABUF) {
+			if (desc.addr & (PAGE_SIZE - 1))
+				return -EINVAL;
+
+			umem_dmabuf = ib_umem_dmabuf_get_pinned(&dev->ibdev,
+								desc.addr,
+								req_cq->size,
+								desc.fd,
+								IB_ACCESS_LOCAL_WRITE);
+			if (IS_ERR(umem_dmabuf))
+				return PTR_ERR(umem_dmabuf);
+
+			cq->umem = &umem_dmabuf->umem;
+			return 0;
+		}
+
+		if (desc.type != IB_UVERBS_BUFFER_TYPE_VA ||
+		    desc.addr != req_cq->addr)
+			return -EINVAL;
+	}
+
+	umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL, req_cq->addr,
+					req_cq->size, IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem))
+		return PTR_ERR(umem);
+
+	cq->umem = umem;
+	return 0;
+}
+
 int ionic_create_cq_common(struct ionic_vcq *vcq,
 			   struct ionic_tbl_buf *buf,
 			   const struct ib_cq_init_attr *attr,
 			   struct ionic_ctx *ctx,
 			   struct ib_udata *udata,
+			   const struct uverbs_attr_bundle *attrs,
 			   struct ionic_qdesc *req_cq,
 			   int udma_idx)
 {
@@ -110,13 +169,9 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 		if (rc)
 			goto err_qdesc;
 
-		cq->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL,
-						    req_cq->addr, req_cq->size,
-						    IB_ACCESS_LOCAL_WRITE);
-		if (IS_ERR(cq->umem)) {
-			rc = PTR_ERR(cq->umem);
+		rc = ionic_cq_get_user_umem(dev, cq, req_cq, attrs, udma_idx);
+		if (rc)
 			goto err_qdesc;
-		}
 
 		cq->q.ptr = NULL;
 		cq->q.size = req_cq->size;
@@ -428,7 +483,8 @@ int ionic_alloc_ucontext(struct ib_ucontext *ibctx, struct ib_udata *udata)
 	resp.udma_count = dev->lif_cfg.udma_count;
 	resp.expdb_mask = dev->lif_cfg.expdb_mask;
 	resp.rcq_sign_bit = dev->lif_cfg.rcq_sign_bit;
-	resp.comp_mask |= IONIC_CTX_CMASK_IONIC_FLAGS;
+	resp.comp_mask |= IONIC_CTX_CMASK_IONIC_FLAGS |
+			  IONIC_CTX_CMASK_CQ_QP_BUF_UMEM;
 
 	if (dev->lif_cfg.sq_expdb)
 		resp.expdb_qtypes |= IONIC_EXPDB_SQ;
@@ -1362,13 +1418,24 @@ int ionic_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		goto err_init;
 	}
 
-	for (; udma_idx < dev->lif_cfg.udma_count; ++udma_idx) {
+	for (udma_idx = 0; udma_idx < ARRAY_SIZE(ionic_cq_buf_attrs);
+	     udma_idx++) {
+		if (vcq->udma_mask & BIT(udma_idx))
+			continue;
+
+		if (uverbs_attr_is_valid(attrs, ionic_cq_buf_attrs[udma_idx])) {
+			rc = -EINVAL;
+			udma_idx = 0;
+			goto err_init;
+		}
+	}
+
+	for (udma_idx = 0; udma_idx < dev->lif_cfg.udma_count; ++udma_idx) {
 		if (!(vcq->udma_mask & BIT(udma_idx)))
 			continue;
 
-		rc = ionic_create_cq_common(vcq, &buf, attr, ctx, udata,
-					    &req.cq[udma_idx],
-					    udma_idx);
+		rc = ionic_create_cq_common(vcq, &buf, attr, ctx, udata, attrs,
+					    &req.cq[udma_idx], udma_idx);
 		if (rc)
 			goto err_init;
 
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index b4d4544bb7ac..e64c8e891f30 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -11,6 +11,9 @@
 
 #include "ionic_ibdev.h"
 
+#define UVERBS_MODULE_NAME ionic_rdma
+#include <rdma/uverbs_named_ioctl.h>
+
 #define DRIVER_DESCRIPTION "AMD Pensando RoCE HCA driver"
 #define DEVICE_DESCRIPTION "AMD Pensando RoCE HCA"
 
@@ -217,6 +220,18 @@ static void ionic_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 */
 }
 
+ADD_UVERBS_ATTRIBUTES_SIMPLE(
+	ionic_cq_create,
+	UVERBS_OBJECT_CQ,
+	UVERBS_METHOD_CQ_CREATE,
+	UVERBS_ATTR_UMEM(IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0, UA_OPTIONAL),
+	UVERBS_ATTR_UMEM(IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_1, UA_OPTIONAL));
+
+static const struct uapi_definition ionic_uapi_defs[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_CQ, &ionic_cq_create),
+	{},
+};
+
 static const struct ib_device_ops ionic_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_IONIC,
@@ -376,6 +391,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 
 	ionic_stats_init(dev);
 
+	ibdev->driver_def = ionic_uapi_defs;
+
 	rc = ib_register_device(ibdev, "ionic_%d", ibdev->dev.parent);
 	if (rc)
 		goto err_register;
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 127b79cdfc45..b25fe2f6c4b1 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -10,6 +10,7 @@
 #include <rdma/uverbs_ioctl.h>
 
 #include <rdma/ionic-abi.h>
+#include <rdma/ionic_user_ioctl_cmds.h>
 #include <ionic_api.h>
 #include <ionic_regs.h>
 
@@ -491,6 +492,7 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 			   const struct ib_cq_init_attr *attr,
 			   struct ionic_ctx *ctx,
 			   struct ib_udata *udata,
+			   const struct uverbs_attr_bundle *attrs,
 			   struct ionic_qdesc *req_cq,
 			   int udma_idx);
 int ionic_post_create_cq_cmd(struct ionic_cq *cq,
diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
index ac48fcd19a4f..f503552bf23a 100644
--- a/include/uapi/rdma/ionic-abi.h
+++ b/include/uapi/rdma/ionic-abi.h
@@ -24,6 +24,7 @@
 
 enum ionic_ctx_resp_comp_mask {
 	IONIC_CTX_CMASK_IONIC_FLAGS = 1 << 0,
+	IONIC_CTX_CMASK_CQ_QP_BUF_UMEM = 1 << 1,
 };
 
 struct ionic_ctx_req {
diff --git a/include/uapi/rdma/ionic_user_ioctl_cmds.h b/include/uapi/rdma/ionic_user_ioctl_cmds.h
new file mode 100644
index 000000000000..98bb8d7238e6
--- /dev/null
+++ b/include/uapi/rdma/ionic_user_ioctl_cmds.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (C) 2026, Advanced Micro Devices, Inc */
+
+#ifndef IONIC_USER_IOCTL_CMDS_H
+#define IONIC_USER_IOCTL_CMDS_H
+
+#include <linux/types.h>
+#include <rdma/ib_user_ioctl_cmds.h>
+
+enum ionic_ib_create_cq_attrs {
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0 = UVERBS_ID_DRIVER_NS_WITH_UHW,
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_1,
+};
+
+#endif
-- 
2.43.0

