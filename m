Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022118.outbound.protection.outlook.com [40.93.195.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587112FB969
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 03:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258451; cv=fail; b=lgR261k6z68l4tm4y+jK8C0HUNioLVHmf9yVo+Mv9gOELXwhahY+mEZln6znNrlaPQn+iFjKw1xboR2jynlsI/LHfqweNEMrVJXW50o7KPOfA/phtbAxb4HtEbxs1l2FIlCMoxu0dBMdmmqA7rXEzTwNcut43URb56dhZvaBWUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258451; c=relaxed/simple;
	bh=pngq8LzflwjL0JNRMcF3IQm/eV7oKMisl6nAu56KneU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sJcz7NxpntmuDulrojGzqduekDdd9uns/DFELWcTRMccB4N3hdFEx/gkBzcfvLZONg792Da0kHxXI/hS4vPiitonDcA60XsIHRL34LrLj/rzFlBLNWFsnoymFybs81nvirxhlBUXQa4QRKHCLMR0GCJfb84bxMakHM8tONHFmlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=KbjUoh/+; arc=fail smtp.client-ip=40.93.195.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="KbjUoh/+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kty+d0eAmVcijGqAuhlVO5PkjYAyg9bjnHNgS5VhOMy3BoNmYzTo/u8z7wbx/975lMyOi4HoNi0UcFtgaqCMamgQeRjlZigDikmD+AtU3KZzKu8BNe53Wx/nAHz+8a8W38aT2j1sKrKzz0ovIi0L3VaPVpO2Yi4JMjhmEypdVbt43hoPT0OQow/NoU6r02QLerEMn+87p+rVmiHmKlqBxq04+WQ5c8nrWPMYLNce+6GdKeSKRb6ESxM0krLTxl+j7jil18XKkyk67whYobVFB+ft9Ik2uvAV4tWZzHZiMKWDzXWJpaEsrr1kayq4U/cNMXVCHmZxefspyoaUhOfmdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9KAtsTzu9Pi48SOEPR2beiccfqmYhucJUuLwFqzYfY=;
 b=aqsuABptK7GGE3g0Q7u6NAyOp3GHyd0yEXWkNeXYjvYxNUPDjYT2ebzPMkSU0AP8mI7Yme8GR7ki5Yiiul9GN/fVosOr1W8GGc8LCOPzypXI5kDdgbr57T9cVmeiMrJ5E9ptg58EmHudL84mzxvDcF9wuRyNXToYdgReRFPIGqlQqRxVijJUYlHmU6vky6nA9qV3ZpEU5agAbtEF/bhOb7HDqng23XGGyJKpt2PpW5gKKGMp0fOY7zvpbIoIu/SdQiZaEKfz/6OWpulXaQ+6xxc6RvcKJbk/NLaL1bQdLTOBHhR1crS44Iky4/Rze/ntPcE6u5vGEHDRhisSfpTBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9KAtsTzu9Pi48SOEPR2beiccfqmYhucJUuLwFqzYfY=;
 b=KbjUoh/+hgVAVZIeSbV9zuhQAGUa9pNQ/4/qz/81ofOW79TeMzeOQBFa/pCN3ZryPdSoH9h3m+psH57oGTDQxk40celI495/TAinCl7CoKsWhxFSF49MBmGLCFDA9EKVkQsZ+2zwF2r+1gRukK2ZOOjcl0wstt8GWFWxTxaxirt531CjrlreFcWSD7zlz9/CK6cDc9rC0nPaWLMWSCVASjMjbZo5g2efZEq2yFj2aBaUBeYBu8Ib5pgAh0OwWV1VuFRw3/wOrKJj4JT7/41d+xNJsmVR+YMwBB7LR/gTi2X/weYwKuIZfDiZaZmZMtLXQl5UsZu+QnUJmU6i85098w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM8PR04MB7992.namprd04.prod.outlook.com (2603:10b6:8:7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 03:20:48 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 03:20:47 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 2/5] RDMA/efa: mark comp_ctx_pool* as guarded by comp_ctx_lock
Date: Thu, 16 Jul 2026 23:16:55 -0400
Message-Id: <20260717031658.477397-3-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260717031658.477397-1-timday@thelustrecollective.com>
References: <20260717031658.477397-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|DM8PR04MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: de302c14-19c8-49b6-a888-08dee3b26521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Md302QcarF5EhsH/77SvQJQE3iRyISdGkvRNzakOEMJBH3I72YUa0v7vzkcRhM/lHr8yzgX6jtnsGQa1ktC6Aw20indtgnncQdRuwa3V8x0bRaXOD2nsWBn8s0JHpxEYITdfLE2kCuxMGwVtg1tz4pOhzwU60kMpKVjx/Pp5B8J5/bWudLnG63+4JmyaqQqMWpspBZJSloOcp7uFXOdvPF/9R8jxW+wlXo9OZYyWn9ebvlFWK/g9XvgB8tnmmd/E9Akgled6Etik4nhgV4x5MPdwGOx/96Dw6IpKQ8313WzpK3gh4Oi2RLvkm7kXS1Cra7EEM3LkmRfrlfemOG9HEWNHjTa1h32u7hvLq9udClazgjv2hitmZ+IQtv+OmHjvUB5uoP/cMhsx0aR0geLDETh/lLfqj2NlO4HYA/MquRSwHW5F8ATMcMc3WiNtHY2KpTnJF1wQ8+/uzqmQeSDUxvSTAfbCd2eaxa17wMrCw21RKMZ7lk6nOgrYe+CFc7CZUEY1kVOZY2E2jNwLqinoQtsUiKQCcqkqTbVrxY8TCd1db4GeyvV1TDffXKO4c3CVMUa87g5XWXcpiFRpAK112tVtRnzwm9GXsfO13zGkzQVQTYa3TyH5vbpR2zABFIG9hD7kveNFlPYbp7v8Gm1AalMhL9VcfkTdRCfnsBVMEws=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4MUviUGv1YAbdw7wzRmFFggstYglGTSP7cyA+zcdYyPjjxcV919cZSpX1OH?=
 =?us-ascii?Q?xFToZmo8eR2Djd31sV3Q447Xls5s6XcpDGyoRZsouQL8iVa8NVRSjxhDSQNx?=
 =?us-ascii?Q?TpuF0E7IlVlb5FzdZ/p3YiMAW/W8uYM2Nq2z6JiaTOVd2+Bc3mlk5XXdLjJH?=
 =?us-ascii?Q?CXyVhGLJDmE5RIj0AFrrMSukl3k6M0oUNPhBIPI8BR1YMOed9j8R/nwh07y7?=
 =?us-ascii?Q?hU4ctg4sBd44p1TJam5SgvuE6SGeCQYOk3oihMbb5iHG3v7he5+WrYTJT9F0?=
 =?us-ascii?Q?1Wq+lZn9UfEl65qUBz+gy7TknKlgrydJwRd73q/p2BW5IL/AktWj82gLxllM?=
 =?us-ascii?Q?7OMM+nhT0eY4ReVENXCjHUngW8HoSiRVjkjaaku+MLOJB1Vxtwsj3F4h79KX?=
 =?us-ascii?Q?RFTGilzNrcZ+6NAJEan/g+n/sufVs3DRxLkIgHhIeucxtgBAVvf5z4pOvinm?=
 =?us-ascii?Q?f17DsxSBHSUhi0cOrToTaOqgcIzxVGI1GShjOTgfM17pDSwEO5rxLG/zJVbb?=
 =?us-ascii?Q?hltN1UW7mMuBuLVEdwOCHwCaNT9e8ay9EEFMj8plE8L4Tpr1HfwWNy42v5rZ?=
 =?us-ascii?Q?TKbMIGYGBcxWC8H5kmKl+19Q9oWCT9Nf2ofhunLdPUveYxU+JJWhvsBlvrx1?=
 =?us-ascii?Q?2ubwHN8eUA3MJEehVhxUsjoHyvNmQ4vpea45qHXprjPvEd4UMrlGrIFbVeJQ?=
 =?us-ascii?Q?X228e5uBKnACxkORUXadQ5nymAqArjdEeLCEEuoUYsqk8KWJzlWrLgbhkrkc?=
 =?us-ascii?Q?DBICsMPMpIz77JDUhyBNnJQYQuAIF53hhiT+t2IBGQePZlyTStiW9jnczPWj?=
 =?us-ascii?Q?LUPIwpa2/0a5hJcBGtCaRgKhB5JbO+1MewiuwzaT89nlkegMe93q4p5njXda?=
 =?us-ascii?Q?jx/IXE2M/uuIY6d+Qxoi+h7+ysLWSxL4Ua+lLZ3//AxBz5zvYkVIsUPbhTBF?=
 =?us-ascii?Q?vrhJgdp3vT0Uh70BAht6wzGkMuvQnq6MzzQY+9uzT7QjRNpmSmdLNGthgV2i?=
 =?us-ascii?Q?bbhmBe/1/j2QgmJ/IKPZIA7F4J1zl2P3ebHz8TqnjeUs/dLzwAFwQBvMLleb?=
 =?us-ascii?Q?eon7DgoeP2YQE30PSSkca7Q4eywIvEY4c2BnbXn1sN2SHX/tRquWTV5aYkxQ?=
 =?us-ascii?Q?Kxra87eyhSPYD6xuraNuCx7oQh7oIvQiIGFs1IK7HYoYKBxHYjGbblOhq4PX?=
 =?us-ascii?Q?KN8n8dDpyZ0Z8k5ois5b9U6YD2234CNMgOijVvbv2F2eK7LR4Sa4oVRXO9Es?=
 =?us-ascii?Q?3NpKmUHKWaWZ32ypeZ873m4Lact8RliyirTfuUbDS70PWQCMBlrwMfeJVZYA?=
 =?us-ascii?Q?tZvfFAxB1gjn90q4OJ1/UIuADK1a/1nfy2WpBHccHLM9jh1o9dngFd/554Bt?=
 =?us-ascii?Q?ZLO5ZX4Jt0ZOgYqVl1nhxfCciwoOOktZGVMSDXPVUVMX7ZmRD6SFn9vTM26J?=
 =?us-ascii?Q?1fWEMpsw40W+RbgIYqoZxSAFYYf7ZnLTLcXrCGKmP9h1WkKEU5ubY4G5BTml?=
 =?us-ascii?Q?AGjOc2hfNeRETOFrzMN1Fis2I4hBowuieFlnoKgPkS1lMxt7uC2ygqI82V9s?=
 =?us-ascii?Q?EcbBuUC2wBjXtoayvGKn0meS40Q/xygxEhp7NsnNp+ZiJ45Tmg5b8/d0CpE5?=
 =?us-ascii?Q?H2LZJz0V3zoUVOHcG7plRTT0McDDPAfkb3yPQMzO3b2QHj1kpkJE8/2WD+nb?=
 =?us-ascii?Q?IP2m1ij13ccFXZongq6ZeUnZiR/U0kquavg6suH8Qdn45efWfe2aBNwfoawV?=
 =?us-ascii?Q?gieG4DfuKzqd0X2Xit/VqPwUut4bJJ8=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de302c14-19c8-49b6-a888-08dee3b26521
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:20:47.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7RJiaEem9/Hn0WS0sSH2gEtI2kighELv5eR/lzAlHBiCUA7/CuXo8K74+fVX3rYYy30zu/t4IrTv/qNvQ1bmpdygnCdG65+n2tVSPpGS9+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7992

comp_ctx_pool and comp_ctx_pool_next are only ever accessed
while holding comp_ctx_lock (in efa_com_alloc_ctx_id() and
efa_com_dealloc_ctx_id()), so annotate comp_ctx_pool_next
with __guarded_by() and comp_ctx_pool with __pt_guarded_by()
for Clang's context analysis.

The comp_ctx_lock initialisation in efa_com_init_comp_ctxt()
is marked with guard(spinlock_init). It is moved earlier in the
function to cover both comp_ctx_pool and comp_ctx_pool_next
initialisation - that are both done before concurrent access
is possible.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 4 ++--
 drivers/infiniband/hw/efa/efa_com.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index c48971595d5ef..4ef5ac363800d 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -386,6 +386,8 @@ static inline int efa_com_init_comp_ctxt(struct efa_com_admin_queue *aq)
 		return -ENOMEM;
 	}
 
+	guard(spinlock_init)(&aq->comp_ctx_lock);
+
 	for (i = 0; i < aq->depth; i++) {
 		comp_ctx = &aq->comp_ctx[i];
 		comp_ctx->status = EFA_CMD_UNUSED;
@@ -394,8 +396,6 @@ static inline int efa_com_init_comp_ctxt(struct efa_com_admin_queue *aq)
 		aq->comp_ctx_pool[i] = i;
 	}
 
-	spin_lock_init(&aq->comp_ctx_lock);
-
 	aq->comp_ctx_pool_next = 0;
 
 	return 0;
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index cd1c68cdc5c43..bf2c0a0f0d9e1 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -77,8 +77,8 @@ struct efa_com_admin_queue {
 	struct efa_com_stats_admin stats;
 
 	spinlock_t comp_ctx_lock; /* Protects completion context pool */
-	u32 *comp_ctx_pool;
-	u16 comp_ctx_pool_next;
+	u32 *comp_ctx_pool __pt_guarded_by(&comp_ctx_lock);
+	u16 comp_ctx_pool_next __guarded_by(&comp_ctx_lock);
 };
 
 struct efa_aenq_handlers;
-- 
2.39.5

