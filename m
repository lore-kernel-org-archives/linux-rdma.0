Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011000.outbound.protection.outlook.com [52.101.62.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7063E00B5;
	Mon, 13 Jul 2026 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783957137; cv=fail; b=busf6BdfkjrYZdZPndxMN7/5R72GUtcv2z/STJvH/LP8S/h56IJ7KKrVhe1L0Dn/qbiPM8MpAnepTAE0N+HSKAAG1Sn5blWyIU7OEkL4cCPk/TTwQnX0Q4pMCuJRWXa6O13V9c0qAJo96VmAM40vR20DDNiuVrHKF0cx/lKdvOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783957137; c=relaxed/simple;
	bh=8uPJeswScIvk9vRITO0KMN3ZS1M094TtFx3GodXuqow=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=ppYF5KyLjncTiqlXlUarZ6ZrCwc+9d4KNS1N8eUArT/pFgLoJTAmsWqGY069HY/7Q0+/qE/XHD0DfGLny00LvdA4eb4dcgIuJFN1L/aqQg+t2x+xDkhaq1QHeI+6dwv6GBDTwr5j2QFxp+i1krPUd/ZlDy4hsSyg9B03u1GBSSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D9Haqv60; arc=fail smtp.client-ip=52.101.62.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D9Haqv60"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=husxM0F9e++s/m9pbFPE3xWqq3LxjK4CBt75ym3Hg2DkuM9iyW/pEWiMPG1X+qR5mhjok+kO6pbi/9+ZMO4X7ReRXIvngthbpdadkTpRzGrmJFo0iTfkm1cdl9fQrnJJLakzjmulfXcl9bl32M8rCcmZCDQBfmjlUijupaFNB3YkTLKS8y/k4S71yr6/2+TYQF8M6Nt5rwA/DlnWSaC4VGwKMURm9CxqYh6tR2yeAZg/Y9QSjMu43zzF67xIJfKpXvKYUjhKyAklzwULz5nX4675cXFmL2SUZPKgyWksAQ1LrNTI8Uv1AI1BpdhIbxawGdmU8IR8ILRUMlIZoIXofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w9bjwnNmBHrMM5/hUX8pplxLWIAxSVn0ZzPqjieNB0=;
 b=TXgLxhdilY66/9akw5Esl4tP2kzTC7HKwrsB7Y4nLdtOZ5Fm+FiNl/73KOv6wyXJaGZAA8os64VHZOBiSDRRggzeygVUrypWZJ8FO+lSVLplMYD0hoRUXii+C7UR4uZNzPUp9ovKOmDFBbCbJ1VbxFGSc0E/4BJH6KmjL90yxefMDTpfNeO/iA4uAQWaEH4bdpbb1e3WVhYWzAUG6NW9NJsm6WbDjWibHdy/sr4C3jJrC4+5ZZA+iMHd+hvtl4tyxVHAHCUTwgBhQ6rtnzCnMS6GBqXwaJh+YBflW4LkPXIlFfC4Q5As6x2IGbqtQS/j+GnIwJhAAm1ZEe7ONHEwQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w9bjwnNmBHrMM5/hUX8pplxLWIAxSVn0ZzPqjieNB0=;
 b=D9Haqv60L4ILfjYbV+eCHuzhCX0Mq76z/+D5Ln73cru0lfO97QbrGS7SfD2KRPfTONeyxx/Ohl8NTS4dE3LoqhMQz2yCzzMigLf5lL0yJm4mXzR2jWlUNZnBnxs18AzkPEN79V0d5OWssBTJ5U4NeW6PUfqQ4boCuoRj8sg3iNilIqkSL+qaIxxF84n/cuQpRZWg9YJhuZ87tvcYUyA0mi9A4VvfcZrE5FjiTBgv6qR7F/5dvrNYHYQISpfySNV0pmx+UHasX47WFQ+0+X3qMZsUuLefrJKKCMDLM4DNmQzZRY8ts8zIggNApU1tqL0WCDeydQewOCrQtzwdrzkrcQ==
Received: from BY5PR04CA0016.namprd04.prod.outlook.com (2603:10b6:a03:1d0::26)
 by CY8PR12MB8067.namprd12.prod.outlook.com (2603:10b6:930:74::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 15:38:47 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::14) by BY5PR04CA0016.outlook.office365.com
 (2603:10b6:a03:1d0::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Mon,
 13 Jul 2026 15:38:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Mon, 13 Jul 2026 15:38:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 13 Jul
 2026 08:38:28 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 13 Jul
 2026 08:38:28 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 13
 Jul 2026 08:38:24 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Mon, 13 Jul 2026 18:38:03 +0300
Subject: [PATCH rdma-next v2 4/8] RDMA/core: Fix potential use after free
 in ib_destroy_srq_user()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260713-restrack-uaf-fix-resub-v2-4-bbe8bb270d51@nvidia.com>
References: <20260713-restrack-uaf-fix-resub-v2-0-bbe8bb270d51@nvidia.com>
In-Reply-To: <20260713-restrack-uaf-fix-resub-v2-0-bbe8bb270d51@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Dennis
 Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, Gal Pressman
	<galpress@amazon.com>, Steve Wise <larrystevenwise@gmail.com>, Mark Bloch
	<markb@mellanox.com>, Neta Ostrovsky <netao@nvidia.com>, Mark Zhang
	<markzhang@nvidia.com>, Mark Zhang <markz@mellanox.com>, Majd Dibbiny
	<majd@mellanox.com>, Yishai Hadas <yishaih@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>,
	"Michael Guralnik" <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783957085; l=2320;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=Jvu32SVgro+98Enzm7cCVvzDtkMapOP8jisNcoB1yCI=;
 b=L+JmEbZs0DAeSJZwgJyO2BXl8b6lYb6j0XXk+ynUg0uwSplD7k38KWxtOADLvN1uvnOofKJGW
 tU6q2HXcW4kDl1PmkNaepLB8Iew1PZfo6UXP5KWg6EF+UC3Fp6nUXPG
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|CY8PR12MB8067:EE_
X-MS-Office365-Filtering-Correlation-Id: af335173-010c-480f-3ae0-08dee0f4d46a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|22082099003|18002099003|11063799006|5023799004|56012099006|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	7PsRD3aVyF1ALp/W9XUNydz3yIBG8jlnUceu4O51CLpP3ULmByp4YcJ0Lw2aUwnseqDwa9GI3VGFGuPBRHSX6UdtzeRygeACLD2jUDr3k0n/qpTtUriok/cZFkIwqCkqnGSWB0dL4k24tIT4gkD1b/TZO31Qx95PQKxgvrd5wC4qDtjN4v1LwCO1Tuj+sEaXdD9k5TCC7epBlv1Bp95B20lGAJRG5ZrvLIbDte+brZG+Qv85WjlqcJ6nS3mNlB44I/C8H+gCwuJin4iHm6teVgUnRpd7/qc2qQl2mJNDtUBXp5vWT5zrMUPqy4JnXsxiVtO74gsmjcWSCTFr88i+u0S42iXRqSmBzvYJvoLwU9KrMuR9Wya3uvFAruErpc2dX47Z9+P2nH+gTDLzDEY12YJDBYW7YVTF5p0XZPRqzzrxS/6B3nb6IFTp2aH21VP7yMclAuNqyLxcSXpmENhCIU2BlrRQgSwLksRDRuwZiFIJsPU9syJpfwQFizF25d2VYB+UFF2RX+cbCsUy4AQHAwo+R2bfNJJbhVbEqJE36FjBnk7VIPww3w45xaN97oRnASHwg+nEDSMC4KBkpw35L6ic7SM1XKOp/kNcW4GhTXHcV30SidK4bVoDNw3n4XZiX2uvw2ER9H1wYLEzpmYYxzQ86NagmjP9Mlq/WNRzlMWP6NVPzK4dhAaSbV3z1VtKr2nnsECnJzWCrUxoJlvlyX5Elm6LymFVVBOO+fIRIrh7MuWf/b4p0YceymF9uRyL
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9TgzBAGYxPMbXL9e0dP7Z2+RNzxiM8h9JAbqPLxK0rdNECNkFcVqxPAhtSk1z9JobLJsVBE0aVdTRskzmp0htGCXjNYGLD7RUX2R4IGlIgJ7t8pomgBKzcEN8H0eF6APp+SKsY6lzVdwHZh3B6omNhprY5YkKaLw/0a9gCoeOlRX/iaykTdnGFgwhnlldutrRIqtXfhFiDrajEt5P2HkX2ex7V0S7N7bsrv4NQsRvvKzZonCQkMlijcneKboSC1pCTvxhUX8oD5oAqE0Om1w3nRMW40EuKNSpjE+pYtHbSq4RW8T/UJbYOBEnMehCEzCG+bCTxqetBKRZSRsvgfH8YYKq0Aui/+vsmRmrG8pkk+Z3kgLjsw7XoEUENhnRWqmODN3/stgTyv3uMJrqLObrPTX54T+NzvZt0r4Nqe/PpqUaD/Z9ykDu5NO58bf843C
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 15:38:47.3274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af335173-010c-480f-3ae0-08dee0f4d46a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8067

From: Patrisious Haddad <phaddad@nvidia.com>

When accessing a SRQ via the netlink path the only synchronization
mechanism for the said SRQ is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
ib_destroy_srq_user(), which is too late, since by that point
vendor-specific resources associated with the SRQ might already be
freed. This can leave a short window where the SRQ remains accessible
through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_begin_del() call to the start of
ib_destroy_srq_user(), ensuring that the SRQ is removed from restrack
before its internal resources are released. This guarantees that no new
users hold references to a SRQ that is in the process of destruction.

In addition, this change preserves the intended inverted order
between create and destroy routines: resources are added to
restrack at the end of successful creation, and hence shall be removed
from the restrack first thing during the destruction flow, which keeps
the lifecycle management consistent and predictable.

Fixes: 48f8a70e899f ("RDMA/restrack: Add support to get resource tracking for SRQ")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/verbs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 568cb71da726a61997149e92aa570e0bcb76926c..bfbc25dee95d031f91ffef5389e81faa08170719 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1140,16 +1140,20 @@ int ib_destroy_srq_user(struct ib_srq *srq, struct ib_udata *udata)
 	if (atomic_read(&srq->usecnt))
 		return -EBUSY;
 
+	rdma_restrack_begin_del(&srq->res);
+
 	ret = srq->device->ops.destroy_srq(srq, udata);
-	if (ret)
+	if (ret) {
+		rdma_restrack_abort_del(&srq->res);
 		return ret;
+	}
 
 	atomic_dec(&srq->pd->usecnt);
 	if (srq->srq_type == IB_SRQT_XRC && srq->ext.xrc.xrcd)
 		atomic_dec(&srq->ext.xrc.xrcd->usecnt);
 	if (ib_srq_has_cq(srq->srq_type))
 		atomic_dec(&srq->ext.cq->usecnt);
-	rdma_restrack_del(&srq->res);
+	rdma_restrack_commit_del(&srq->res);
 	kfree(srq);
 
 	return ret;

-- 
2.49.0

