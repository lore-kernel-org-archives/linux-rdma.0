Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011058.outbound.protection.outlook.com [52.101.62.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8006C365A00
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481454; cv=fail; b=Ga+K+vdJlVfrLGsoGe8QNnuJFcwPAzTvJct8woJVovDU/HZzbsC8Nivfu5rDn+QaKgTbnyl0m4CFJC84GVEM0oquSkxfDS3tAD5BOALKch/xncY5MNzY/1iU3mZDiPohrwGHsyv+zisvsrL50Baz8O/A1XrinY11r0wBktg9IW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481454; c=relaxed/simple;
	bh=src99dxPQpWbbl+Ji+fDRZkuiMX5mbWtY9K6ivNkN+w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0kC53qelPciOucQYE7K2+OrL57VuFobsBYWP4K5M+tTrRddLixy6L0iZGEMdbTJfNxaqA8fddwhCIu1/xqhPOo1gGnypoykpdJfOC0SNYg4nlJPF91+0H88EMtq/gMYJaeNPq8DKiU5y3bkWSMW8DnCDAMtWseSUr0QEjV2l90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=glB6uFTG; arc=fail smtp.client-ip=52.101.62.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="glB6uFTG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P/EOp4V7j/5BqrmzSB4kuFjb0KiBwyKcybUpBfU43uB0ML4yV0UlLY1K/GfKXTe//ZwV2BZvFliSBVh9upLTMeyZIT+y5OKCPn0k1BvZHbQ5nXQuNJ6ru3Wl3i0Q9UoxfdmMsOrkqFUExecQaBtmuNbWNYP37tP+3kV14SPo4HBzYn5g4F/jFDhcH8jyRVNwASz+UPeAvRDe2omrWq8ip0Y1orBpVa5Pbv5effA2QY1DOh9yyKl9qAJqkYNIIflpQcYjJ3otRdW9iHkHy7PPsyXXqzL2Au7kr++nKIPmtdTDVWNckQGB1Zo13T9zJZSr3s2NTmU/c71WcCrCZWzHKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2OopJjjYhWYltMXbx9kHE+W7kN7V0PBVNyebsMED5U=;
 b=rSSYr0eSsM1FuXui5+g1JUc2WC+NaWX5c4oAuaOEGWxrT2GYa2ZSo5ogfcqCXCoSvTWck2VoUram+7NCeJ87opHwvT1oKeUVUy3G7vtCOU+OLnmUsmoDwFuBkuTGNTQ89MVNee0AVnL2ulgHzSb+WIbY7oquRSrl5JZflVB4Gv8gt1UknSgDg9qrFvb/+L0RpIg7/3GBwJvktXXlTbmGbXomE9zyyEGmCB+ZErCV5bnwa+eyiYssv+cEr0mqKeDxiZESlDRBPvRlAGmmJnAsSTXlQUi8trr67Apm38sIFcwB8mxDn9vCUqRd/NnfKixOYms5CT9HlurNtJSQ7XODTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2OopJjjYhWYltMXbx9kHE+W7kN7V0PBVNyebsMED5U=;
 b=glB6uFTGjE9+wbsFYAXqsAoZbheicIJkYKQ1alM9rALRfIkKf1pFvGoKTVDYopd/Rj5inkXpa88kDvFkn/heNrriX6vv5aApyrimn4hz1yidY0xcRIG+ywB/3Dv5yvUveo/Wy0XyLzKxPljEBtTV/ogKNktFcBjvEakettbszmPj0N51oXxoeA6oXyR3m0YF9wuvecb2HepdrNGfJeyptvURWZMQwRP8qNMctHPSM5jcfFgHwDpBN5U18hnLf8EI/MBRFxgr8GE69XRTltvGAkN7ftCzax5NAOrXrv+aXtg6VAeeCRvUc+c8iik/Xo6UQaAwCuotyeQdYcEm9y0OBw==
Received: from SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::21)
 by SA1PR12MB9492.namprd12.prod.outlook.com (2603:10b6:806:459::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:10:49 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:806:22c:cafe::35) by SA1P222CA0020.outlook.office365.com
 (2603:10b6:806:22c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:10:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:10:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:18 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:18 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:14 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 02/15] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Tue, 15 Sep 2026 17:09:20 +0300
Message-ID: <20260915140933.40580-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|SA1PR12MB9492:EE_
X-MS-Office365-Filtering-Correlation-Id: 45dd3759-f43a-4307-0a37-08df13332528
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|7416014|18002099003|10067099003|3023799007|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	F3/xdLCxINXf2e5BpFy2RGH6h3jUmjI9mYm/yQB0pc8U4aEZp5GHS1+urZ6WeMIeW99Q6qs2m/qQ/mzz2KqFCUWsY9cSMrngm+ZaB9bbP5Z6gk8ENprAQjoCY5mkMrjogseUDSwUuLkjm9kQvP0cYPUWnVMutXkBFIxaYX14COkfGhJsi7ugCNFGUmE4BJ4EQB9K6IHd9Dv8tFhw+U+vnyiSvtcY0ZtpWt3PHvnpcmn9/WhG6GJVoyGBEmmgwqN22EZQrU+ggS3aLMF8TxmlzbvzARp6ktNVpnifQgEo525eLAA2f147VPs3yAd9WWYyFt+Y8nCzriFlmSWgYjiL6Au/r1/eAX1s37bxMiL2QVEW1m/pKmlRcQuxQItSg+4OdQ89N77YHKOYBTMFsWU5kw738CxivDfAzolA9PpF/uD9wAdgdf9FHxc40DSD28rJ9BOg4Oj8FOW5aUXB/NmwYvzsFEGQGTUw35LJ5R+1o/FrpS40ZRfEp4u11VPngMJFJVN2oulvaxGxKO1IKzzLQyH6eT1UfA/57NyYbFV0Qys2e3u53sWS1RrPG3XRLAOHTIcJbSy3yEo0/mOWiBy8JB/5+iMVllpWzNhYZRKHaLOekKE1w3QhhHQfAMG97reiUgqiipYZHTtC1i/ZfPVrwi6RKmUh+RqURcrC6W10Wo5CvMHpbBlfk5Fq20X19//EIeGOsbOjzd4jQquRENsTjw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(7416014)(18002099003)(10067099003)(3023799007)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1BwAeUrQOW+Zjq+sZX99C9KRKAIBPBNYv1jSS5SwdPom3dcAuGIkDjmC2cNw5tjC/7G5lk9qtoPdVaLNvoXTq+Nj2ER2o6u3lF4dTO2VgpmICcFC0KIzeV7abrnVADwuwrJksA+suOF2YBWbjBqdVMXIzlR78H4L3Kmp45/u8vOXkJsBobbS4C++iAECMntmLmCT/KugyLsma7Uxpa/4xn2/K/wPn6Mi+ZhcWCMYm5csaDJRHgibGQVx5b2bh7DjH8+MJMWQ3yPR7uae6ehYNjxVSr7Zpcyr4YvVgLd2qlIUnHh7tjA2M/rtEFlvns96E4wg3jduus1r/7w7R/V8qdAFSzxIqAh9nhWMCjbIHlp7+eGR0rvH+lcgyHCkKY8qQYx80Kx+DReBfRco1GQaGOGYcn909Z682BywXZb3EIxXXiHcj6PIjNZFD6BawEnY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:10:49.6066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dd3759-f43a-4307-0a37-08df13332528
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9492

alloc_cq_buf() leaves user_access zero-initialized, but the device
writes CQEs into the CQ buffer. Set IB_ACCESS_LOCAL_WRITE so the buffer
is pinned writable, matching the device's write access.

Fixes: 744b7bdfa79e ("RDMA/hns: Support 0 hop addressing for CQE buffer")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 1dd0efb5620d..ae314f136732 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -261,6 +261,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-- 
2.18.1

