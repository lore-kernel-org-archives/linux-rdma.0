Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318355;
	b=H6jw4onEa1xYIxKDHu974eL7wGm1L8AeXpcnClTVMH8v5Djbrw2TDFGo767E+bokA32C
	 6N8sM019wlw8jmokJe7pQf+c1avngf8ZgDALO/jlVpqCCrcYQKZNoXheMNV/H5AHGZsGa
	 +9pM5olZ6JvMZs1ShFFsNhQ5rNT8o00p7JrN2gvygzpROTdPios8XpRJ9HSXUV6C1iBI0
	 JDJYoOs9N9yP6DaDoXhupfZ1r1tHA6R4D2uzmc07IihzIOf9ZHx7a4+UxVj3Ps98Q+o7G
	 TKMwzfRp1wFA7XES9X6cBecUfU8/Z0oOxS2E+sfJdZZ/SzK+Ajf3zl5ZU7LrZk+tGfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318355;
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
	b=e2bOTBHOMcgKXKxMxPIb751+ItbYY0gas+M9KWnLvRmWPM/XTQ47kFun7jXuyRk60tyq
	 sI5Hq2UBnweVGGtsmCIzSXqRjSHy7Ant7NZQfrNgUc92Y4qop0BlQNIj9pMg8xs7nowmN
	 XL9oRuF5IkpcHS4aEXEdFHMnpfl5BRHSZLu+WIIWXnsmZK74wMcGxLKMGLeO6CTwikSQJ
	 ALAH/fssM4AtS3mitAOtmL4VS23Rx13UehVeNjgBvSEwRlwyklGQ6FkqBfJCESRzLr2oh
	 JYs4U1lC/tzse0TMOk43alMNdK5afqlzet0N90hr19k4frdzRhQlIM6Gr1Uv2753v1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="rvnxFs/u";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.45
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6CA60A261C;
	Tue, 10 Nov 2026 13:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC6CA60A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rvnxFs/u
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=InL2urbVLxfMzIktg4pfZNcstxSamXzT66LWiAP3xmrXHm1SWpDV94rWmmDNELNSzKh1TiO/yFi/370w4NGiGmIAIEjI0GcChPM9r9/452C2nsmv5AR90XWLOVvPdj0RxKAJw2gpmJx9aYC/DHNxFr9KPxsuUQvhaKVR2KykKGeZfV1CvYQisdwog36BWgV1yXFXipsXC6iEcKeRjpF2enzOEU11mkFiIX8nVFq1G5aH2IA4El49mx4Fzoy1pyDgo5E8LfkgRt9SCTQjmJ0FrCz+pqDjmZKBp89NAV1JDhOENvJTILqc2GqYjMB7M9BL3SXFS7o7MwxgDw0kI2/xvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
 b=PlDrOgJI7MRXQZ5s69FvAlfjyJfUk3BFUvAvIqcoLTP8bhjg+ye8HLj4GBfev8oEL+E9JhpitHpH9oWEPnZ8vq+0DxcCk48wqqnpKIABVR0nDXrnDezV3uJKFgAEbAnSgYGetAVsZWAt6nctQXY91XP9bhStR2oVbMHmhWx76CK6U03Ql6YKUyPpDdBoessJBvFzbPfoRgPHWF4P0alMJn4duJ57VUTCE6f/HxLXz+h+y3nPrMP0q58sT8Vyg9cCg1KdCstmOSlEdZEANmfdk2n89oKrHFECUWJeHQrlJlg98zie9hyYcfulqA7CICBSUo/mtTz5D2luvqEAhQoUng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBuwnFm7GPO3otpiA6bZqo82TYc7I9bpL9Xe5n7WJUQ=;
 b=rvnxFs/uSDkfLQOcesxNB4OCSuKbboHKSYY0rSMm919JCxglXEyRnBVTuBgemk6fA9CAKi9rh/LzHQwaSd2z68WF3lPWdAyCl41b6iQPJgh/CsZeW+XQWZxmoUSbs6/3Lrz637dryBgZgCe/LDrRs2zgIs75lEjXJKuWEHRcl7H5pI4AIXPQ+DGoNgOvEE2LQxN0II4jZttfz7oJDVRdFOkWDVJJOC3Xku13VN+X87y1j6g3f1x3Xyh86ddkmtussikVrzu4AJLxZ984bDPKChXz4HmJYzdz8KH9qtiJNSdyPhZvKDXWXJ4Wc0s+EXZWBXIs+Ay6vNW2Six8IXNy2g==
Received: from BY1P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::15)
 by SA1PR12MB8743.namprd12.prod.outlook.com (2603:10b6:806:37c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Tue, 10 Nov
 2026 13:45:50 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::3e) by BY1P220CA0019.outlook.office365.com
 (2603:10b6:a03:5c3::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:33 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:33 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:29 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 23/24] RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
Date: Tue, 10 Nov 2026 15:43:19 +0200
Message-ID: <20261110134320.34408-24-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SA1PR12MB8743:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3e5097-0f5d-4795-6e5b-08df3f30eebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261026140227099003|261026121527099003|11063799006|261102123227099003|261021121427099003|261021135927099003|56012099006|261009223027099003|261022105027099003|261028144727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ii7Sb3ebHqdnqaO7W28vCR3+c4ew0i1z8FNjtERNc2MIeYWQTCRJUhC1LnXb0s95mHS4T66gHHtJ043uFJ5a/94Bg/UdDxborhX9IvIBvQoJbz+xY9y2rorHGzYLUqITLqBHGSLcUyNzlX3Puk6cu7eL6rVbA+n2baZn2/I5A66CAzGi8t5BX1H36ACKPdWK6IeR4tzyFAz/aQowAFWEm3ZD+UgJ7Qj/0wOCS7p1A0ha8crrdXrMLD4PpJ3F5QFYjCkAtqj/+k6+OjLC7Lp9Q1n1dkXAOZqf6bTqFpKqmttEtJbfL0gSqsN3AfFJfnZnOtlKtCJbvRZ7s0nuhUUd9cPjdcmvFCPdcPQKB428bJmcRtMthuatMlPpTFnVaJ68CDGPBaMVy/n034/zwf9NnJox6ioAYlsX3AJSCsTd3m2m3PJVM9MxR0/v6Pyx3D6ggXsgg3vEDs0UxZHWZUWMXg+r8JzqoBSlc+oq1vsPzWIZUAOHN7GidQmaEqgWOB37Pi9BLciPMTpVMMox3peDBtkx8DIYHNml8JyfqQL0qlN4968CiEZVuIBhezK7u37oenCLDpytVL+f8TR6kvkvpRXrUttj+hfkvP0XNqN7lzB9pmAQyZtO7RfT8PaZrxx5yx/pY3j64CfBo5aNlcJmqdMy+snH1aR3qSDiXPmkSPo47chveLp8hoscmZb8/QL1WQZ9s6HaGR7DDdEoHz1XMQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261026140227099003)(261026121527099003)(11063799006)(261102123227099003)(261021121427099003)(261021135927099003)(56012099006)(261009223027099003)(261022105027099003)(261028144727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jQxSZkm1WW5zUZr6BlRM9wByxWI4fpbs/Crm6hZs4xqlWh3EFj/Zzl2JoLRIWpM+C9MLwl5tqANgPLxjk7tehsDtTLKdZWWAH7R6sUMSB1hHnzWb7LmC/mu3kSg4Ne2eEZkXOlPGUpSV3XuESUXDbL8A/h48fLPCXlX7lCl1tvF0gfzLbWh+4Djs11YIUdY7gg2+gl3UdgmHN3hw3U2mNcN83qPDY6MO3vCaVgUzUuv4tbTJA9Z3tecNwgKDZYBUPctUW0KztO3t16Ol2WjTCB8H1C4XFSEgjHiBNcA9AzH+FSqNHtLyQIKB4SjwxRV97FRhYnihxzsKxe5W9sMOCvYbBkTtkSLSm8TO3dWks3++zh4u0f4o4VUrylmHF5nqha/Fg5NwwACNoyQ7tAOTsQ7elBb2A78Lgz3LGK25HfjtOQ+OleBNFoinwHXcJHBq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:50.5883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3e5097-0f5d-4795-6e5b-08df3f30eebc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8743

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

