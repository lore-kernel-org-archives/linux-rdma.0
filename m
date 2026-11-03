Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724169;
	b=EU7qUEAeZ3NnGPlqrDWmGSriM6SNJBh6SL+rty4Z883CMubZYmMcmT+mus1cMA9Q+9j6
	 VFwdjwzKK7DRZL5KuZQEOm43IadMdpb5/y8N6ir0BlaOhqtONTh9Q2nejZLG3WMBzajkM
	 hLbnKcNpCRAkwRUPOb5r6kCwl0bCkv1P2UUnLW5PcKLfCg2xz1sBdekDovqOwMRoJaS4o
	 vcf9ob/MPr98dZav9aFAYSLSHKj2QRDaHWk8ONWp8PvTT9gAgOrLKy16e5H7kRufG2+mu
	 MFfl/9ow30FeQnAy0rwaCTY89d/aKw1SsEtFIT34zm2NK8+D/KTONGmIX0ZWluXigXg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724169;
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
	b=Lf2u8wTmPK3nwi4dah/BEbX4KKcyFBZgFrXdYrXfpm7NUq/On9uDoMZWIkCqqHbVV462
	 XZcXUui1IoDbRxUx69BcJEVvGAOOuayO+xgK8Pkh/JA9q4r+WPW2oSb/s6Fhlk3vfU10S
	 X3aWWJwsto+JaXiM/3tS39QEDq4A25xHw6egYMS8G3ZRwL8bkg3JH92zL3lA9IBxgQuhJ
	 5xvsB96rYLbKN+kiPwgh83doVD7Dn5p2wODa8NR4OUBszr1iujOTluDuZW8yIBmRK+m9o
	 y8LSiGFxu/WDVUnxGsRzB9z5Tsznu0cNUGedXq/IBqKy9T5cGvnI3wj6ZIe7dBCNcMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LYigGG7f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.1
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1B9606D822;
	Tue,  3 Nov 2026 16:42:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E1B9606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LYigGG7f
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAw6Gm08l3hBl9+a6FeHKPniPWGhtIrJBzpu0XFQtVlM9fPUZZpdgrTt29CVNDRxU2rUJ1YrWfqSkjKzwc9wMr1MPDh/h98QvD8PjMmQ50N0c87IEtqqdSpg4G/1N+0NT15pe0WFEgSS+dXtZP9ei1caVNzU8wJz0xwzyGp+gzaQ6X1hRMrDeUvu6O0STwQgR8nXH72PXg3Ojl/P63Fei5ZYvcaXbP6ulPI7qITjblmWleV5YBmRUW8vD6Ukxt/1YS3IIotVPKnw81wAJCh/u0YcOLcXwHYYRLksYnX74Sy1kqCvJRQYg0nvfEWWFbFLyaqJP4eq6jC41MOGHOgS7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
 b=wLlGCLNOFv/MDKbHXpjY5fL9H2RkM2wgOHgpHStOuILi8PqgdgkE9grCumSzSWD91dnGE0JFx22AO5o6GjUPzc3p8z3fnw38kY7T7mqus/RTit8ZuhxKtnxHrGeZuF7lbBYGgw8VJOVVnD6suP1vHFXO69RKYr/V9DrXddBa8VhfB+cfE7Y4jrVshw1JwHRknj/ayOCn9OUKOUuo4m3tc2UQh84NwtIdqakrmIHmKgDai7r8Mei+kSHxL+ohcUDf99cR1IbY+PvsRrwJgIJJxWQ6zgZzhtvX3WbMJD2zwoi3g8ib36ivEFaY3gSqoJ7m+2Wz783Xr4WGsWnHVJ6RZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
 b=LYigGG7fm7ma8nTsuIJFyG77fFQPYGVbW68Cdn8L5kh5WiN0YalfWzPB2a/8Ox/7EWgzBYJyQi/Qq9h64K1pefeHiGPvBkNGp7nMQ1sK5m0DTpWZnmg1AH3kSF2c5jxZJZujdCqyRKBFE2Kg0npY5iunQlj6q0Qbo4QGGD+MH+cqd+3mFUBbsF3ShWH/DWS9Nv5Sd7vh9bpKcq0H1xBrxU9V8q5W23A/myD2UmlKViBIUSwlvkie1edeR/srt6ACs6A3cT54wCvO0sPQpwZO1iL+1SzMhtR5XmGDSuSsZuaQHewRXyovaWsav6cSmDKIP7H9m//XjFxhxOTqJ/eVSw==
Received: from CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19)
 by DS7PR12MB5864.namprd12.prod.outlook.com (2603:10b6:8:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:35 +0000
Received: from BL2PEPF000352CF.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::39) by CH2PR20CA0009.outlook.office365.com
 (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CF.mail.protection.outlook.com (10.167.249.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:34 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:42:01 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:42:00 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:57 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 22/23] RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
Date: Tue, 3 Nov 2026 18:39:48 +0200
Message-ID: <20261103163949.1554-23-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CF:EE_|DS7PR12MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b22a8b8-5e1c-4243-2214-08df39c97695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|1800799024|36860700016|261028144727099003|261021135927099003|261021121427099003|261022105027099003|261009223027099003|261026121527099003|261026140227099003|11063799006|10067099003|56012099006|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	7p31JjWAiZtvh5A1wLS42ReFZFz31JfuiebKYAo7MIgjhEzMssxof0xfcUTd/ZL1NsueasNwlA2DFUxY58F9U1R7RVloG4pTr7jqiIoFa6K27Qy/7pjEtcxY4K0B1WrtRCIvOWQUegQLQDYoSQH25qIBXKuz3XsnHgNP68vEihy+m4ctZXDb6JgZeZe0iFmCXyK0dmDJ9Oyz8nPvXn1mRHdgiPSZsGEvIR+bu5SSNzZQ2WdA0pgOVEja9x6gi9S5s3Da9P1ZyqBhidgQ6zBKyf2mmSwPa9DvQ5kFZps2hQqqZ/0jhGruNstenwaSITdqhsTIux82EoSbLSGjtukLEseAIVVjXvVcf1ZQ4sKCgavMDfRJyTZn9BjRePhN6/kTy+ubSR3kBkmjB3sIrCFelak3WRkH9SHJnA5MKusrSJnqCH9RYll2/79HFRLPIhWnRnl/IiQ14WxYKlt+bV/tWaFSr6cSwinFQnhvUGlPzwlWsdZh6F3D0lGprNhMNGqII4CBH3v50IMVlRTUQ/n8mEbqsT9ZlBTAby32P89SrErTRvKR3bnIbjcHAdYUvRsE/TZvljtIfX5gcDQ+Y0DIgA+lHEkiUnQA1HX1P4UKYQ6wGcXse160ztdpJjTYMQCeKnJCQTkRuqVmDXLgET16GkXFjDLAppbQZBKedboL1wnW5UVflsZK9tenflkrD3hqXJeOQKEYOlQCsZDDGPYIWQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(1800799024)(36860700016)(261028144727099003)(261021135927099003)(261021121427099003)(261022105027099003)(261009223027099003)(261026121527099003)(261026140227099003)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pjETwJEfazLB0AJAam+ryrw2CmOuCRK4HRnFa/B8Nw5h+O18tQudbLV+oT2xtvvOAJjIS6wAjsHTrAli9PBsCYX+p/dn0BR99buivom1uV3KxsO3+ST5y9P+8EQw4MbP1C1UOzxq+vQPtdjLBrxlXYbbISS8znJ6v8wi4OG3qvpvnDZCEu3HpHdHy2yvx4DbqqzfbAXGtVFEb2xeBC1GkSjYTzG7Y16ekpLBqI59I1Qd7E3efRqRy4qzeG0LCs/Ur+46uaGC32MIZp7zGdfgnC8juU52oTHQTFUIHP0xkyI3ixmAwhQeF3EZWUym5RmtttvCkxA1A7dgT00tTrSr1WkeTnwHyGL6MOaiZ0dRz6n0w7/1SCEbJatLM47YhJXeKu7NKwkTYtssUODTTuFEapnASxALDKy4bXB2jrpyMKAMgxBTmI4x1wah94VI+kqC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:34.8908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b22a8b8-5e1c-4243-2214-08df39c97695
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5864

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

