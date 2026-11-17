Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935563;
	b=cMLv9aDMvKFQOTDH5JEckSMcgT+Ua9HS+KMcWNoqThyi+MZdYZVG3ECh9g+qe4OhBs+R
	 LqoIC7+vnX5URPXaCLw2snrY7jnaO4WLbQ6ZLtVFSgqbXD5ieKzZUFXrs9lyt5wwxc2hp
	 BJznLeWnt4FLNDte8d74Mg2x+/fJJAx4Dp7BZ5A6efjFl9SjAZ7PTQei3SEJdDriHXxTw
	 T5FuOaTdUAr1J6NQ0oH3PxUL4LA1nfpohfyNHNQwbt3I1v9aDViw9ha3VvO7vGAXo4MnA
	 1Hwl1oeShXDxZvgdcCsb1CrSD4c553jF3Ltk8dY616WWR+Ql0ja4D8qDnFRCEdkSMGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935563;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
	b=BT7VBPtUQ2wVIuFmn/3jWlk9WKkbXEyRPfUBmWXFT1q1dUmzst/+1uqh1SC/a9x7Jnzf
	 NQrdGcDr5GaRB5895NG9qSkm7aP5leLUsusXzlBiFr4M6RN/9OVMvdVNK0jyX4Cldrpxh
	 FL7nBVQ6p15d6vouKwwtxnlRjnCmNKQD8whUPDcoXC5hHU2HnvoV0UGpHsegGSEAY8N9C
	 YXtMbw0doWgPhlye2rr4/FrLosGijoQL7N4DkWo9+M2YtXpwRlr2Vug82jWKg1VxcSaMA
	 wuY6oMelsyht2ChDqYjSjjZcNNvWYiGxDPSreLLWU91Nw/1Ua8W73iEjdMhwT1Z/4eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SdyPCTyf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.34
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF21E606A31C;
	Tue, 17 Nov 2026 17:12:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF21E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SdyPCTyf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lvM2qONIVdvJXmy0rL8hpWBGsDFACEGWd6PjvZL36HxKRlHlsxPHjtpkOmM5jxQ0oMPrPQkLDepeSMvR96kYk49ZMV/JGAL8lArm51f+99wv6mve+i/yvWsQNKClKdZ2rsjsyV4ZoXVS2gOBY3O8zyoszKeZRY8NcTNdtyt4N5kK5Xq9i3GPlsIrEue9MaHqmM68ZKQRDpblSdFgdwwL0e+ykyUA3F9WhirYzu+tU7UrbPy047ciSlZT6ZqbtK6JgQO8si2l1xpwHWFj+VDgUTtcs1r6F3ZXhB3JfEyih78zbP7ScEOdOQ7Hz02MOeZlRAcOczsL7GkZ5vGY+aBP2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
 b=rEzfgF9wEkiVPYo8JtcvhWYngdOXPyeYIWjABkaCfTr8enTiCekxjnp+FR3Gsz4Ai0vnLcJVOjqZkbo+eqP2S3z3qbX30QGjgpLQLWSabXwPdHHDSas1AJcpDqwNxl2MiNr7osOB8ave8ewSMTUGxF1pnPVajJKxGpZ1gf2pDLXW+VANPIpqU5FhRYBqxr0L1dz2OLITu201BMqEKojH9XJ2Sdv5w/mBZvOn9hns7ahSdvoe070G3sBilUMb8a70X0gEgYAd54PKkN6ue3ODQ1fhyNRX9gnfPixwxp4fLmaZbajFP4a94WeqIvwUvQPuNFusVCLWYXSOxSRxc7bpWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
 b=SdyPCTyfZdQQwX0+btyRNyg+QqM/8d1FcCCrF3GfBG4CuxD4nHOoOktEY8FMW0VymQVtwVBzKJM+1sghB2e+1CT3wiSL2CgrJRDw7fcT0mE65lnr78iCdB0aLN6+Ec0KmvfrUDUmiHk+903hHjfj0e+yuXr+o5fijMSmfaA5Cr7JQXK/8v9EVPyIdwWFoxJsC+OLkM50hZCxomnGtcCQKiRyVv2yYqii09ganYBv7C90tYxUmQz80RUhiFCAnmCVVAc7ewRYBY4+vMYvNCLtP4NvXclgmjTMI8Hi8oJFLfzHdNgZe9XK1hHN8Lehqrbm+eUNhRB4MmLXeMM397yU8A==
Received: from PH8P221CA0061.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::17)
 by IA0PR12MB7650.namprd12.prod.outlook.com (2603:10b6:208:436::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:54 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:510:349:cafe::7d) by PH8P221CA0061.outlook.office365.com
 (2603:10b6:510:349::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 17:11:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Tue, 17 Nov 2026 17:11:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:11:21 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:11:21 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:11:17 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
Date: Tue, 17 Nov 2026 19:09:14 +0200
Message-ID: <20261117170914.27410-22-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|IA0PR12MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: a2dc012b-fa27-453d-f0b8-08df44cde03f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|22082099003|261009223027099003|56012099006|11063799006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022105027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	n/8l+sOR2U3bvAtmyNl6zCCIjR+KQo7kp8OKJiZQrTDV+Z1uYqPVK8TjzNhZr93Gz2tf8X3sdGCSXXjFxb26Bg/r7ja43knM07Wg4TLjlJqrTrWE3ErSBkUsiSXVS4976wy9UojW1K3vVzDZF+lUrXRHjVjWHsiEYToNvgeDp0Kkn2LI1qG2E8x4MYwKijfUCOGv+SXljMWFB0kPFS7hMb8aisWp5C66I6vIws5TrVAy1qGfb4cs0b7j5DnI/R68pgV1/MXSEroJqa4oEcCGYr1o8ZqZUiK7gwoWCF/NVjn1VGd3ocbcVUwnbhvXdKjYcD7fjcamWxYLbHBFni4pWbwmdWosyYD0oYXGwKZGjwgR7RMfO06/M2loQrTsvRyTopipFuP9ZgSJl6u2D9e59g8UvqGqrNyYeLnVlx3GgeR39Se32rG+JELZ0jYFv4eqVVOqA4pe2YwLqYKz11b/uwVg0lHTDg0+cOB2v1U0uiD8v2isYJBkADQf/4zRPBHgOH02CCbkxEJRnfDeEvguWttjxMSJzC2HXVYVWS2S8P0ExbBbNbpb4qsk6n+2SwVl4C3vth7OoI7xbKvD09wjiKlCAPk2nrborqSTe44KrsSeEUe7WwN7WhCXZhR9n2aAR5CH0g8kgY8M2PGmg+t3Wo2MrOtC3evlNxrsAOtTlZe3RjFFhxytd/kQoA0CAZycBTFZZ9chFg7L7wnerKmt+w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(261009223027099003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022105027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S7ezgVZrbOqLOUSuYCQE6FBlzq0xdEly00/HKLOz9e5ph5LQxojToRKVFPthXM/IPrirgj8tT0TANopcHT4asZjADmSD1osfVDMC6kE7yNo4dfw0koihedEQX2nCAU8/u6gWE+It4t2IhDNwMLulmIvntVjfQHkQd98A0kTi834I+Vd+K+quQUNv2OqAzo2OAo3ucQmsy0sWENTnc8DW7dZ1gHlTNZXSa7bp8qh59FZxAzOlabjWoeV1yIGxkPEjQjxKapYpzpcinhMIkmuMyRCT6Fp9pxY+SHqQ/6z7isCX4yfu3gnb/qHDplpg88FOKne5voriWnjcEL348Y0EpTvIevV1ByOQJkUiCoi/xcP+od1ZZVCiJwzajXshUWgmWSKnrXcPNKaImafVK5938Q6B/oqE9vECzZUdHKyE5bz29yGb8WJi8yrsjAF+qVm8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:53.0037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2dc012b-fa27-453d-f0b8-08df44cde03f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7650

Userspace must know when a device is in adversarial mode, and an
unaware rdma-core must not get a context on such a device, as it
doesn't harden itself against the NIC.

Report the mode with IB_UVERBS_CORE_SUPPORT_ADVERSARIAL in the
core_support of GET_CONTEXT and QUERY_CONTEXT. Add an optional
UVERBS_ATTR_GET_CONTEXT_FLAGS input, where userspace declares
UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED. In adversarial
mode, GET_CONTEXT without that flag fails with -EPERM, and so does the
legacy write() GET_CONTEXT, which has no way to pass it.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/uverbs_cmd.c             |  5 +++++
 .../infiniband/core/uverbs_std_types_device.c    | 16 ++++++++++++++++
 include/uapi/rdma/ib_user_ioctl_cmds.h           |  5 +++++
 include/uapi/rdma/ib_user_ioctl_verbs.h          |  1 +
 4 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index aca7c6ab55cd..b78207a81091 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -292,6 +292,11 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 		goto err_ucontext;
 	}
 
+	if (ib_dev->adversarial_mode) {
+		ret = -EPERM;
+		goto err_uobj;
+	}
+
 	resp = (struct ib_uverbs_get_context_resp){
 		.num_comp_vectors = attrs->ufile->device->num_comp_vectors,
 		.async_fd = uobj->id,
diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index db65032e80b4..72c67f09533e 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -248,6 +248,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 	u32 num_comp = attrs->ufile->device->num_comp_vectors;
 	u64 core_support = IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS;
 	struct ib_device *ib_dev;
+	u32 ctx_flags;
 	int ret;
 
 	ib_dev = srcu_dereference(attrs->ufile->device->ib_dev,
@@ -255,6 +256,15 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 	if (!ib_dev)
 		return -EIO;
 
+	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
+				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
+	if (ret)
+		return ret;
+
+	if (ib_dev->adversarial_mode &&
+	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
+		return -EPERM;
+
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
 			     &num_comp, sizeof(num_comp));
 	if (IS_UVERBS_COPY_ERR(ret))
@@ -262,6 +272,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 
 	if (ib_dev->ops.uverbs_robust_udata)
 		core_support |= IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA;
+	if (ib_dev->adversarial_mode)
+		core_support |= IB_UVERBS_CORE_SUPPORT_ADVERSARIAL;
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
 			     &core_support, sizeof(core_support));
 	if (IS_UVERBS_COPY_ERR(ret))
@@ -303,6 +315,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_CONTEXT)(
 	if (IS_UVERBS_COPY_ERR(ret))
 		return ret;
 
+	if (ib_dev->adversarial_mode)
+		core_support |= IB_UVERBS_CORE_SUPPORT_ADVERSARIAL;
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_CONTEXT_CORE_SUPPORT,
 			     &core_support, sizeof(core_support));
 	if (IS_UVERBS_COPY_ERR(ret))
@@ -519,6 +533,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 			   UVERBS_ATTR_MIN_SIZE(sizeof(int)),
 			   UA_OPTIONAL,
 			   UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
+			     UA_OPTIONAL),
 	UVERBS_ATTR_UHW());
 
 DECLARE_UVERBS_NAMED_METHOD(
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 816b3107464f..3e482a4338f9 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -101,10 +101,15 @@ enum uverbs_attrs_query_comp_cntr_caps_attr_ids {
 	UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_SUPPORTED_QP_ATTACH_OPS,
 };
 
+enum uverbs_attrs_get_context_flags {
+	UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED = 1 << 0,
+};
+
 enum uverbs_attrs_get_context_attr_ids {
 	UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
 	UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
 	UVERBS_ATTR_GET_CONTEXT_FD_ARR,
+	UVERBS_ATTR_GET_CONTEXT_FLAGS,
 };
 
 enum uverbs_attrs_query_context_attr_ids {
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 21f86cc7bb1f..5861f34f8343 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -47,6 +47,7 @@
 enum ib_uverbs_core_support {
 	IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS = 1 << 0,
 	IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA = 1 << 1,
+	IB_UVERBS_CORE_SUPPORT_ADVERSARIAL = 1 << 2,
 };
 
 enum ib_uverbs_access_flags {
-- 
2.18.1

