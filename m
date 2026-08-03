Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021107.outbound.protection.outlook.com [40.107.208.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB2D352002
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773467; cv=fail; b=hkqBTocncMQmoauopzzoMlxHPyiRPtSZuAB8uy4MwibHBgMlDnfaTz1gJR/mFYxzOh6vnXFrqpub5PJYm0L8Y34tvYHbALz+mNwjtHciRxP3+spAT9HzB4kbZ0DLeBj0kE5f/UHWWEtP7i/mc7GOuHRc3gsi+zExEavQqQPLyAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773467; c=relaxed/simple;
	bh=T3vV7D8J91kLieAwoJHQ0xRLt5A68Ld9w/PqPIU4KZ8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNCTNm7R5ngq+p/6Opvjqhu6KlHAX49pHGcsE/6LoOJFsaGb4Y4816BRgX5SHx68jRmKGySa5PcbBd1cyXcAHGBr9i8gyggk35cVCKBIg9wUwbQ9ZsVXoVQ9sSnZLzUMrCq3sT4NNj6/TzAM6Zar2uBpdHjtOuYjQXYQuy1OkIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=dh1weR9L; arc=fail smtp.client-ip=40.107.208.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="dh1weR9L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOZjS2Mpqc3V+Q9VW5G9jqIYRdN1uZn+L9nytBkxWPf+KD6JRVW+Ts6PCXDEzxhyZ8bhkpEWxT5CmG4nWn/MV5jlVgUtq1ryLJGQfjzerh4gQltfrk8qj8GVAlBqJSbZ6xzVJwnXIm1VNM3HyGnWyTmgnXhecZc8P2PG5S2x/tWBe1Hz+5NcCh/vpIUK/7nQLjtCI9tUI29MiWI9yM1p/Hz3Xd6S+V9DmfUBcdr58mA+mUDo9QdF0E/VV8q3PjQwMIxpsTuULJqqMSzx7IOPLWFouCJFfUWThwSXdKbTTs8NCILdX/UosBW76mAl6DBvHDHTXygKvsT6aUE7WfRkiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFeeyDV+KOcKzx3YYS1j+QzR8sD17cqwzoL5C1yi4wo=;
 b=j2J4PEvfk1P4RHhbY2VjgzA1aBdISpcjq4tKrtsAlRbfsDtmZ/1tIDfjp+ignTK3RvCVRH0TJ4ei4is6nEkrgnuAGyW1lA8APyedMI9fttZ5j+MsCWcCVvOfQiRejHZsa5S0M15RPR2xZ8QxM1d3FRX1Bg5F/3gCob0Ve/+hRkAmE9/hMZehp6qhyw91ww28HeNAKlv08smuVSA1lZCwBHzdddLg+9iEEwni7szlK47chzzsjVrAk8nShFe+DuR6dXCTnB1jOyqSZVtHWVBIRGjW2mzSpSMzduU90PuaW/68u72YOCYMV0hKIMH8gkMmuayfCQshz/Pl5ALrcA/TKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFeeyDV+KOcKzx3YYS1j+QzR8sD17cqwzoL5C1yi4wo=;
 b=dh1weR9Lmc2mHVOVNMg7l1IDbISpGI6VJXSJf11iWGGUgMEfZiy/Ci6p4+AR81a8ho1LtHDzcO+NeTtT3Mn9Yfbe8+ImBPaFcRC0qXfjUsqZpNYVjou5JJ88wa/eC4lUn8OM5N9XGM1OvLgldpb8tlD7ZT8hWnR3M0EfwwY4nxUrarLdo0y3Oj/TZJGjdfcVBfvZEDIs19pY6OVhD9q2OPY/EUQsq4ezQOMMJKlHo76u558m3O4Yw1P8hlOpLXvQX/dwZthOpBX0EoUwBX8ObhiCwEJ9QlsOChjYf3FLVu/jsurAojHnvGlcpKugqvekPV6XRz7NVz2TdclYj6ElpQ==
Received: from DM6PR07CA0121.namprd07.prod.outlook.com (2603:10b6:5:330::33)
 by CH0PR01MB6857.prod.exchangelabs.com (2603:10b6:610:112::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:10:58 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:5:330:cafe::85) by DM6PR07CA0121.outlook.office365.com
 (2603:10b6:5:330::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:10:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:10:57 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 25A4F1D6F7F;
	Mon,  3 Aug 2026 12:10:57 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 221461810DF01;
	Mon,  3 Aug 2026 12:10:57 -0400 (EDT)
Subject: [PATCH 1/9] RDMA/hfi2: Propagate sdma_txinit_ahg() errors in
 user_sdma.c
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:10:57 -0400
Message-ID: <178577345708.1793053.7854422597621103823.stgit@awdrv-04>
In-Reply-To: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
References: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|CH0PR01MB6857:EE_
X-MS-Office365-Filtering-Correlation-Id: ba3f8356-e6da-46e7-feed-08def179cdb6
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|55112099003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	o01owFLIgo03WZkr/ZJTtm8FX3QaS15M6HRl3/jnwnHlruiPxyNtjdjEAmA5QOyuHDH4LYugB8MdejOjpR7W8mViQUhxBwXsJxYqksYHhwKOUVsMSE6Ws1tbooic8dF1ykWRogjlxW9zoWOPIvgSd04gq0UBlmeRqY4oiV9KkPFd1V7UdpWUZr3YV9HCXIHiXtCR4Zml7azk6wAEXvpztPHhfM6+o+ZPubuNEu0F6L4SN3GMwnTzCkfLVdlcTpXvZP1qB2pdTk9/tuAq05nS0tTaoSSgq9VgfUYYI8HiJMJq2j4C8KGB4+ff5doUdrtWJ4SeOTlY/AmHtxVc7gY4DaIgr1Dks4boUULwMzQ6yvBXWLeJyOREMF4JTpu6sH0/arvJhD5AnlkPSTSXNqXqCW8v2LFnd3E40jQJCPs8wQBtkklLkpg2PBXvw18tDw6hb6hQ2MMMuj3p8HjCZTjcORqoxw17oxKifItc+8wksmQ6ewkuJHhqewlZ305J4YDtpCgGVyaTcc2WxQbPU7Opzjw9fG0Rox6DionvZip9bV9dp5fpyMO/H8mKl8MKXtMZlGxsQX9avw1MmSDjFGJWyA3v3an5ssvUR5ykhfE4GsArDWmag9ua+hKJd6n+gOmyUYNT0YhuoK7Dv0BnHwfIFMq4K13NsW+OADLJCb50c2ADXG49qDlq8OMCH/eIHscEWbnF/ANF1KQWBVKTpph1Ng==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(55112099003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kNo/nlfeV8nrzGjjONsuxUPKVDdNTq7V8bxjDTH3rt/EKe9Hv28gWK8oL6cg2D/taXwLabbZz/4vbeqqQMjh6pl4Nkl6NR9Sd30akZRq5WwXgw3d/8cL73OALUwlyTm7un9PKQeUlVfYfbXuhOEQu0O/WwgDzjYLwuBzozWb2rMyOQc6nOcD4f3wp1grCNsXlq6OJnitVB96oq78DRUzyBZqHlWDQ6RcbBPpjnFLaKg4rj4PNsELtXBKtnRRzs6WyezveZWK2bfeyWy+2dAS12YDNuid8BXipMl5JLSsBTbhACh86KUuO9yxjH65RAs8Ybn6p9yEOSZIaR46oKDpRA8/jMjvQ2xMyozaVGj9vHLMW/nO6sV6WdjbbnFokb4QGxs5Hr56b41WAfo+CqarzVsKHZ3s2oN8K8xHDWSXaesQGg2M8IetF7tdgVZNi66t
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:10:57.6438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3f8356-e6da-46e7-feed-08def179cdb6
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6857

Propagate errors from sdma_txinit_ahg() in set_txreq_header_ahg()
rather than implicitly ignoring them and continuing. This matches the
fix applied to hfi1 in commit 091c6162c022 ("RDMA/hfi1: Propagate
sdma_txinit_ahg() errors").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/user_sdma.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/user_sdma.c b/drivers/infiniband/hw/hfi2/user_sdma.c
index 605fc3df0ccb..e329d91b76fa 100644
--- a/drivers/infiniband/hw/hfi2/user_sdma.c
+++ b/drivers/infiniband/hw/hfi2/user_sdma.c
@@ -1466,6 +1466,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	u16 pbclen = le16_to_cpu(req->h.pbc[0]);
 	u32 val32, tidval = 0, lrhlen = get_lrh_len(req, pad_len(req, datalen));
 	size_t array_size = ARRAY_SIZE(ahg);
+	int ret;
 
 	if (pbc2lrh(req, pbclen) != lrhlen) {
 		/* PBC.PbcLengthDWs */
@@ -1583,8 +1584,11 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	trace_hfi2_sdma_user_header_ahg(pq->dd, pq->ctxt, pq->subctxt,
 					req->info.comp_idx, req->sde->this_idx,
 					req->ahg_idx, ahg, idx, tidval);
-	sdma_txinit_ahg(pq->dd, &tx->txreq, SDMA_TXREQ_F_USE_AHG, datalen,
-			req->ahg_idx, idx, ahg, req->hsize, user_sdma_txreq_cb);
+	ret = sdma_txinit_ahg(pq->dd, &tx->txreq, SDMA_TXREQ_F_USE_AHG, datalen,
+			      req->ahg_idx, idx, ahg, req->hsize,
+			      user_sdma_txreq_cb);
+	if (ret)
+		return ret;
 
 	return idx;
 }


