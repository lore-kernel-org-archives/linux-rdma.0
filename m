Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022086.outbound.protection.outlook.com [40.107.200.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892C22F7EE0
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773474; cv=fail; b=tUSKthZXJEo6x8V/hi1dVoJF7m6OD+tcFmQgYQPE+evXjGeZKUpszSEb+472Di6BM3smZYHywDRS3XBPJ6vyKwGt8khhi2OtNufoV34yYMsawmOCqCE7xxOsAYgoqREDvCh1Hd4UlYsOCHAISCcAfmKUelSLNrElMDZaS9AraoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773474; c=relaxed/simple;
	bh=6wJ98egU3Y0W5X89MoNa4EESOsCENq019U1C7xfzOI8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdzoR6k0QclfRmZtxWUYsONcm750W6doUczoUd5XDN/0Jp/R5rwC7eWTNqWQ9cRp70MOC+R0IpvHUnFPUHvOdstsNkvTeVLbYq5hghlMM+gXvM9QzTejn0gzOPwODegXwAYSTpS6Fp0D4SB9jkqV08oCdo/qCd+TcnDM2g6YeJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=mh+N/wJJ; arc=fail smtp.client-ip=40.107.200.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="mh+N/wJJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZjLaTc5igpWqRls7y9ud47ZJorxpur0j/39/ewcybLsv0NjFHVKCnQXOxhvZyh6sqIoM3dldc+gqO7QxaYLWJITmbYwcIN61qlvyOLPci7s9Q0exCqAEGHgjW1Wi6u2soutaUM8x5FLiXDCJm91Ln8JMajLkwnOPzV6s4vS47j/cwhN2p5k5rCT7yoLu3IQqHKuYr3IPPajFKDyh5fX24z67Ag0CJLz1AycHFfFzC+KBSd20JAulDyzVfIC5COw0s8D7TAKoSk3+2aKhnVbcE5GElUppQ/Y4kIjO4U4bq2+48Hf66uomJaFdMitmklrEMSa7YjljnHuYzW0ih4YWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YH4ZVBFe51kBw8tIZ750AyS/QivJrxsNFAOvWvJF658=;
 b=HF1Er80dcb6zNiyIxTWUAvQz2EQIPtPFd+efRQIfvawmZkFSnBhNPWTlcZciMhMOY/xReafQO3yxnVJ1Dgv6oh7qI6k4bAu3DleQ/I8/4sJWXaS+pND5FpCXi1jZh+ZdwSPeuGM3fLkzWzVIZt7CSTpcFSzLCGg0xQn1lJAD/KjPdEhV48675IREfKPKLwtuTtiwQPiWZe0hOzsrenWSJhh/UCV/nMz6NESme9Ps5Ual+6S6iDfQmY5SWCAmLQylIR+Yf0LoqG0OZL6YeX5H4KVRfvaZRLwyv+wYoVf1nYzQwCTL5xUkK/zmzsfo0I2Ed/Z1TCi9kbYaDG9H3tbHpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YH4ZVBFe51kBw8tIZ750AyS/QivJrxsNFAOvWvJF658=;
 b=mh+N/wJJSKRYBWqBkmP2H0lpClMNsOOfUexkLYsP16IoM3zFJkpYz6Sq8YkqfnIP55xSSwnF5i3HoVrVgA5+3B6Qw5Cpo08ENqNyddmriL7trhL1X1J/seVzFna6v4Oe/ntqB8vlEZoT26pJ/EWuqt1tdlpmtVpamriyfeo5zQQHPZH1jhd6s6mgfT2+WKMLa6IASpX7hG/nC+4p3uIeNLb19cppHfkzS0olb2YSQzlvbGfxUWK619lVCO3FftKjrg5N0mKk2g9r18L/qA4FxzAxBkEqrGro6fhnERZ3t/fnH19XUyqYdW+CKHCEeRLG7rchiTqzXjTcM+5Ixnylvg==
Received: from MW3PR05CA0016.namprd05.prod.outlook.com (2603:10b6:303:2b::21)
 by EA2PR01MB994403.prod.exchangelabs.com (2603:10b6:303:2bc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 16:11:08 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:303:2b:cafe::ad) by MW3PR05CA0016.outlook.office365.com
 (2603:10b6:303:2b::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.14 via Frontend Transport; Mon, 3
 Aug 2026 16:11:08 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:08 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 4618B1D7180;
	Mon,  3 Aug 2026 12:11:07 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 434F31810DF01;
	Mon,  3 Aug 2026 12:11:07 -0400 (EDT)
Subject: [PATCH 3/9] RDMA/hfi2: Stop flushing global IB workqueue
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:07 -0400
Message-ID: <178577346720.1793053.4813622177553138915.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|EA2PR01MB994403:EE_
X-MS-Office365-Filtering-Correlation-Id: a8c38ff9-fc54-4e41-9f4a-08def179d3ee
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|56012099006|10067099003|55112099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1mvBR+H8uo857WDPriNh2Bul1mdkQZwRufjq1f4pmVqVJ8ekagwHXjq68GYbwjv2U7RFpndNCFYrxfuxyYAlMWkBuSsO7bz4+JAEn9zLeR9QzbKsYOh2VpfcdRnq4ej/FeddmpcSUo3gVkoa7jwIvm0P16gv7ys4E5o2CuS+WvnKpXDrd7TBx4VUO/+aFLKY8SidAMnbk/TcKkBuaqjsIaX8WkKF/0Ay6LkMJiQOHGQbdv5IOvMLVj+B6nk71RQSSsevSMuxhfCXlVH5M+nhbQ6C1rUQadZXSpE5Cb/C4Tc9I5vaF7u09+EXGGl3bnrpdkfXPfdSCUCSHz8y6+Yr4PapIaspaUya4Z7+a6shC1iFauRmzh9GcM0Gvlnl5bwV4Hh7E8XJzkwAtNsp9Er6NLfz+c5tNVqqvERKDVKKs5B7i2ESobQHfOPOHrSDSOWgnchDauTBd1HU3QRouhdHR4wQDySP1CxrK0ESuvF7/Dc3DqiBtnaCMB0SAWxoEPmp9bIovXMYs6Anf1TZLJtRDCrXqQrIvmYxXNYOQtBLySWXg8qdivJz3/GSIxK897l0L8lfpYVfp2lQi8iFLYVHN/fGVcP9fCvqDP1prCkwSqIRjoWaC45BHRqIY9zUclfGuhrt5rIpqUzZoZHgv191Raae/k+zEEdWCw9S6MLgJKahAoq3U1d1h0+sbIdB6DLq
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(55112099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OrYo0I5OISF0oZiALoa1VJ14gYn4hgl9oa1ucA79Gf7II6wOroJiDclcVXVIvI9jFYyTB5QQkEqEyfapu1OV4wxv2fqBjKQkh5hLanG8Y9qYUONK6jjYwmNardAzeL+QyTu18UgFkfNYiKL7dCUz7HmPckOishN0hiqa/ne4HaDBIFweVSB4XNXf1qxPFzIcS3XwcVl6J/f70nPvHzxMLrDdiK7I5OJvSzHFwUhJRXiQP6Lk00l02bzT8zCTOPkV6iXCHa45gKT4xS6yL/UDjjoJDu2oBGCkTTZyKheEs70WQVs536z7fIZWZPHClKGLC/2S3t8G8f9lYZpelJMobw3who35hdzGMPc+1i0vBY398WaMoE/QZufTZFZ8x+Zxx0KGXkmqArykpb6e9Q82JQ6Sl9NrbnUnzmjt2gLJ9VZvstuDZl3+XqMlRnb/5a1F
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:08.0231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c38ff9-fc54-4e41-9f4a-08def179d3ee
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA2PR01MB994403

Flushing the global ib_wq in device specific cleanup paths is unnecessary
and potentially blocks on unrelated work items. Work items for this device
are queued on its private workqueues instead. Matches hfi1 fix
d43b1c17f9e1 ("RDMA/hfi1: Stop flushing the global IB workqueue").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/init.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index 2f2b116e9c57..92cf9c55df0e 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -2536,7 +2536,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		stop_cport(dd);
 		hfi2_msix_clean_up_interrupts(dd);
 		stop_timers(dd);
-		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx)
 			dd->params->stop_port(dd->pport + pidx);
 		if (!ret) {
@@ -2621,9 +2620,6 @@ static void remove_one(struct pci_dev *pdev)
 
 	stop_timers(dd);
 
-	/* wait until all of our (qsfp) queue_work() calls complete */
-	flush_workqueue(ib_wq);
-
 	postinit_cleanup(dd);
 }
 


