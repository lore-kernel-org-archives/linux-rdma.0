Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794153996;
	b=Qn6lRjtr+E7ZMTrZGlISRCnaMpmBps02y/GDWNER9g82rB95EkSk1B3cqroIPXlEs5Oh
	 HEC1juI56apmbJ2lAYAWzcyq3/RWZGsLTOfK530lvrz71Ha2NiX+DMa4hf3mujoPzEl9j
	 WfHv+sB1pAAj9zfwIX7tijAx6BzGFuhbmMweRw9xh9UMe2hzOECVaQGxKUwJX4xLPzdC3
	 g9Y/v/cOY2yGLlAuclyU1MxeyMv6XEmJkbjP7VbFhTjc347/WgZg/hID+k4MQpArmTQ43
	 NqKplAkPxEJHgXoCt9FrhqoLvxWWam0+K0lUy4H9p9rXdYY7o/KW8LRzC3ZDV4Zs+hw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794153996;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:X-B4-Tracking:X-Change-ID:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=J1Ea7hFXFrcERp4/pAhrrWGTZUHOseRG142KLgimjs8=;
	b=hWQSYyO2YO6pqeYIbl4UKfqoOtm0jS6a5khQLoCCPWKoMGQL40pkn5PnW/ceQ1hlbmeG
	 urtw3NNxHRSDvlRRxHs7ocv3yuXBsUXs6kLkOJb82HIOGNe+FwAeYzZc/c+Nf/i445c8U
	 OcY2cfhtfNNvBOnq7p8PktA/ZgMK07nJOh/jgXyg90tOm03aCU2teOOBrPEdyvqNiqa00
	 TmPtBUd5PHieBI8TEag+uFf12e2n/1z6Aujl6ikUJFt8OZkvDGjYJiwNSpChG2bdfGEnr
	 cvQ/ZKp212+7XndpXOVLV7+BSouH3SfMUFdiEarK1645N/kpd6Mfq8br1NSXafcU7KQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aqLHykvH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.33
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011033.outbound.protection.outlook.com [40.93.194.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE99C606A31C;
	Sun,  8 Nov 2026 16:06:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE99C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aqLHykvH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MG5qZqwZQyf6v/a7vyIsEaWonnQHlCSYNwcEpkJkxBAxq5sx3kyanKR/qH3a8jcfpJ7RLq+8W7+VamjL/r6X1QhXOpQ8nqa2/4ACE/rY7CBOYJ/yn5JVpuJ8D8+tTGuDOpcVguCHgB7Yd8ieH2jobd0ure4rJXPzInbFEqm2WLmOQaZYMkhJ2Mzqu8pDfV5y9rUVJx8eRujB84TQLcbj48JP5TJQi25wPEnoCA3YNcnOKiJ8PXzK8/uKfryP/665qzKo6H4QPoZE5TZY0kf/Da5ftKnIrzLVgAEPzGHgk0iSEjHY5VNXyhucrklglEK2/FZTZ5osmOcR4rG6rEp4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1Ea7hFXFrcERp4/pAhrrWGTZUHOseRG142KLgimjs8=;
 b=PsybvuNmBrMzuFkYLpWKbvBrPdbrF4tfsm8DRiIB/zOeUjH544ntGdJ/gMOaoCUkD28n3dwJv0I5YJa96dmRuoE9WUR5SZxQYaYrP3pH6/XxJnBuTed7m9LtTwMWgUg6ieXZY14YooWOuZ3S3jGCb2ma6CfsXSOYpSLC1iP4JysG2ldpYQB5oWHwFqvVIF9oWMlRaLRMrQvpdUjUgih+NFk7AIx7yuMcCmkWpVeuzYpvydNK5qMwSPj1veABqhTfhjwyOeIvFUnd+UeAGuJI1WEMu2YycwAJ2nQCFAXGucyYhP1yX+C3jeWWx5fsZ9JlYST1mfz4mJt9sGHHK9FAKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1Ea7hFXFrcERp4/pAhrrWGTZUHOseRG142KLgimjs8=;
 b=aqLHykvHXY9v2uA+nU4nr36535QQHkK1S2AcOAgcm7yQQ61i1xdqHZKF9n8jwGs5OsXkFZA6dPtW1NoIbMACcumzsAodyUTXuzttmHsDyUqivRoZE9DWGy45Un6dGEguwDCwr6QdtpkLLpojyyKmJUwVNlWHoeYQxfGsUa2lwdBAHD2Ixuzs1D1ZwatXo0lNbZNYYNCYzQ6rDj4LqI4nbELQWA2GRnyPRai0z6EHdIVscGxQLlB+D2ZySl7bhTF2oEDDYaTp4uWk4ewH6b75e32gMKY7gmyDrgMzrmplU6a2CxLylCHGt3hHhH2AM7Utn1PIraAafhe0Wf1nV0I1dA==
Received: from MN2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:208:234::18)
 by DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sun, 8 Nov
 2026 16:06:31 +0000
Received: from IA0PEPF0000003C.namprd03.prod.outlook.com
 (2603:10b6:208:234:cafe::3e) by MN2PR16CA0049.outlook.office365.com
 (2603:10b6:208:234::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Sun, 8
 Nov 2026 16:06:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 IA0PEPF0000003C.mail.protection.outlook.com (10.167.249.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 16:06:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 08:06:18 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 8 Nov 2026 08:06:18 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Sun, 8 Nov 2026 08:06:16 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 8 Nov 2026 18:06:12 +0200
Subject: [PATCH rdma-next v2] RDMA/mlx5: Warn on pending software WCs at CQ
 destroy
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261108-free-sw-wcs-v2-1-d1e6d80d2746@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAPOd8GoC/22NwQ7CIBBEf6XZs2uAVoKe/A/TA4HF7qHUQENrm
 v67hLPHl5l5c0CmxJTh0R2QqHDmJVZQlw7cZOObkH1lUEJpKUWPIRFh3nBzGY0Lg7BW6+AN1MU
 nUeC92V6Q/Gwx0r7CWKOJ87qkb/spshX+KotEib0xN0fDcBdSPWNhz/bqlhnG8zx/8td5W7IAA
 AA=
X-Change-ID: 20261103-free-sw-wcs-8cf40aa66fd8
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Maher
 Sanalla" <msanalla@nvidia.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794153976; l=1953;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=hErgPWXaVkW38gfibLM3fmFDcwJK10P4Fvx31tfdHAA=;
 b=TaV4WW0zQh+qkWLM5fvIXno6U7Z07S9sa5XixjEaAgllAw/WnAW1H1scDLkHpM/RBGqQB26sx
 XWpSZ09W7fpAzFUG76PjzUmWMPe7mXV93JXQBSQwaya0oJ35ehC6xHx
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF0000003C:EE_|DM4PR12MB9734:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a85ce8-6ab0-465a-a13a-08df3db240b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|18002099003|10067099003|13003099007|11063799006|261028144727099003|261102123227099003|261026140227099003|261022105027099003|56012099006|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	bjHaWyqdAp+szpvnrbMCFewuW01xA5HXDF6QGFmHXLaeVwiornaa1CQRVrmMMrNr5Cpp0M6I4E3o06C92KQTLsmzPQQGZt3UhOPXhcz0SkGQXVTZCLrcmt2l1+QuWpb3isgXGMiu/1IP6SDEKmzjlgitcv3Mh6hSCsc7SeCV9Eo/9cynPg1NQelMb3xhSxIzRNxCj8vdL11Ig+UuRuE9tzh1lIt7hRBlQbYJEkBjCDPL7QJ5mFf1gOgNSprWA2DwSz6lzIf83aWZzEfsJJx+JePOISKugOCXOKNojBjmRBpFnvaYchU8HS+rp2DmqEfgj3CYUE8sc5Ts6xVMvCTcqWk5aGWCJXX/txIFCtF7iK+EPwQITgeSap2j7fJtT9EqhkrNeM1rnJTHJn9+ZKEBD7KZ+uJX3DLU1XLlM8X/RChsrVvEDoktRbpS2/Kkc3ZDKjuDPTTlS7WlKJlrY3tmxLtwh2J5Vq+GTK6yX51UokYa+MhLhtX1bdumrs7G5D9yXSCZHPg9KJd4C5s2n2wtcg5S8QGhSiwiN3kLKZbjSxmtiZB1RpxIQM8xE1ui4iydvaNQHgTjb5iH8E1Y/Xlq/Bw1TRunGtiucZMUnMLljvJCIpe0DiHy1DG7BY9yms74gYbR7fDlQyztDJQBkMzZkUZCdKhqUTCR6W4PlBVZWZlxznyM5gsQbgv4ODkEp00XMNcva5otdbJql0bqDXph3g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(18002099003)(10067099003)(13003099007)(11063799006)(261028144727099003)(261102123227099003)(261026140227099003)(261022105027099003)(56012099006)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FP5N8IXo1Fz5jFwfqMnVm6PyPu8h44AtjNzqiKkjOJxFccmFH6bBTe3PqMHKMixcvcBtFTeOVCHLIHuVAXg7H6BFdcWbHHLDuch9dpYv0E2UeJbwh8GmhygjUnZ4dX9CnSTC32t13jWxX0PMQuMWmwbsgKpA0tYLZy7u9w9DGvXE45stTq2BhqlTkiNopD8Wie9ed6EhjjkFXU7LjIoRO3BRPj3n1uXyd1/hIRiDkitZstsjNQmVfGF5/Y78gsmK20ZD5CHiecLHWdfJY0NV7A8LpZWBu1wNFpSKdffCYjbKj+yEl1ZwirJKHjXUO8pRlQtubO7UCopfbaFrC7vX3ELMRfMhLwIbuS0cjD4Hq3ImsdoxK/Lg5geXOJnVnhT4Pml0K7NnGqklakPvbBIf+vrHJu2ES66W7SBK/rTpKy1eol0YFQfgEDyu68XnwOWD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 16:06:30.7214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a85ce8-6ab0-465a-a13a-08df3db240b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF0000003C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9734

Software WCs generated by mlx5_ib_generate_wc() are allocated, linked
onto cq->wc_list and only freed when a consumer polls them. Anything
still on the list when the CQ is destroyed would be leaked.

This cannot happen with in-tree users. Soft WCs are only generated for
send completions of the mlx5 GSI QP, and ib_mad is the only creator of
GSI QPs. Every MAD send holds a reference on its agent until its send
completion has been processed, unregister_mad_agent() waits for those
references, and ib_mad_port_close() frees the CQ only after all agents
on the port are unregistered. Since poll_soft_wc() frees each soft WC
before its completion handler runs, wc_list is empty by then.

Add a WARN_ON() so that a consumer violating this assumption is caught
instead of silently leaking memory.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Changes in v2:
- Replace freeing of leftover soft WCs with a WARN_ON(), as suggested
  by Leon. wc_list is always empty at CQ destroy with in-tree users,
  see the commit message.
- Drop the Fixes: tag, and Maher's Reviewed-by as the patch was
  rewritten.
- Link to v1: https://lore.kernel.org/r/20261103-free-sw-wcs-v1-1-3885ce449012@nvidia.com
---
 drivers/infiniband/hw/mlx5/cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 55ffd7d4de517e6ce3f04c98b4edcd94b12e43b3..2581a7693585b2ed57b04b54b8505d3d71ed7238 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1125,6 +1125,7 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 
 void mlx5_ib_post_destroy_cq(struct ib_cq *cq)
 {
+	WARN_ON(!list_empty(&to_mcq(cq)->wc_list));
 	destroy_cq_kernel(to_mdev(cq->device), to_mcq(cq));
 }
 

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261103-free-sw-wcs-8cf40aa66fd8

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

