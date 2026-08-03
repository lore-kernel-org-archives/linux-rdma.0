Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022114.outbound.protection.outlook.com [52.101.43.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CC434CFCF
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773468; cv=fail; b=QFE/Jef6eJJuoAk9NQfmos/nH1RtJ+mKqfQzgpY4i5l3F2qaFbrimWq9wBoSlfstpn0IKI3fJ/tHmuZhaR0E5mB3Gp1fNIQd+F4mORQg8kCFM774bbumcIz62CkWXWqrcRneelh2psnNuKcaF/LPBkQl6gQqJiLlhDmJ/swkgj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773468; c=relaxed/simple;
	bh=I0diacp4tJ/zL4nzl4OPrX72PCCDI1Qljgo7AUaQV3c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bx2VDavQzlpUygZrJhkrRmBfQnCLQDZoK+0Z3CP7xWQ61YKl+PNweUp4IHe2rkHyFFgIDVrKkt0cGveJ8mH9bXayPFPxOF2xfc93PH5z4orO7NEqIW7Gq+1s4AuqV7moSIJg2T7HgDaD7UiwMDlTmCu27gGlFddAmz3OmK9YEsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=fhcw/nfj; arc=fail smtp.client-ip=52.101.43.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="fhcw/nfj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xb5sfK/W0B670roEq+5H7hkL061NVggk+W/O+jKxtcmeiin/8lp0hz38L6AsXqLmkBiE0K5xLryswm8cU/wxy7qNWAcWSYRNWVw9XzQb1CuBYtcmxWJxD/Z9FBQXXvUPQFABjPkQ0y0QF98JV3V3pMl3xJY9JQM+pXzsZzzVvEI/gnQ7APdnYYSBAAoY8b1NoiEh5Bns35kUdzVUXpX+KCHqermsp4vlhEn2HTkOyrgoufxoJMUC4EMyjTUD63dwcUz3IwMP85/VgUbGszqiIAwhC4D2u1rWQGzBLYidVKbM7sASuytAEqqEHI/0+VfBYUmyX+NeiNAQKleZNjapzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Fi5f/7PsAPLuMStBTGc9LzWJ68T6w0aRaiL2objs6Y=;
 b=dWUsaCiecukNWVuAwoW6cPwxFlvjNNYN8jzn0tQ9AaGfpmvz3tun2UW/yTsHXMoVwl0BnUIW/wI11tEmB2VmgFdnykF/CLt8MJS2spDozhzvotfH/EkFKWPUSJUPMRgev5vFBq7BiDa3TN80JQylcS2aObueB0pEOYqAOhsezjkhaOWzEcofLbUNfptXm7WF+vS2HwJ+mwygmbwZ8CSKo3dEU/gDeKjSIQkWd93+urNW2e5CtJiYVv5OTpd+1Fn2nsZ9b1miknfugqpkTm+LI6XZ5RxKkLlBCBSK1HW9+1z1HytBJVI0QcqTEvOCGNs/odv3WdL0DLSMxx2IbX0opw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Fi5f/7PsAPLuMStBTGc9LzWJ68T6w0aRaiL2objs6Y=;
 b=fhcw/nfjJ+ws4HRx2NplBe86mDtMohoY6HcQnoR8oFUjZTEOzVBt/7BN5BwRUJvxJWsz8F4XXDucm3B0l+UzXdUcJhbrlHHkifmZUdiy1Nr0DYFcUHpqn9pRrHR2NyFIbwEYfriH/dq3+3e9/tDgMvElx8bw9IRprOymkCjPGjjBc1cdkFB3W2nMxj2BREM/1WuPNIj9IFBTgS9+EoQU9ciywNwGvLx/ci3pj6kPzjcj241V9MoDIWZsRjhR+Vt9Ng6DXeCu/m1yDNHWqn7c+uWX/w9TgKqjMQPu7YdMDnPmHWLPwV3axk4ocsKsviBctJyDt7nM6mhWwiygA4iWyg==
Received: from DS7PR03CA0275.namprd03.prod.outlook.com (2603:10b6:5:3ad::10)
 by IA6PR01MB001018.prod.exchangelabs.com (2603:10b6:208:5ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 16:11:03 +0000
Received: from DS2PEPF00003443.namprd04.prod.outlook.com
 (2603:10b6:5:3ad:cafe::41) by DS7PR03CA0275.outlook.office365.com
 (2603:10b6:5:3ad::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.17 via Frontend Transport; Mon, 3
 Aug 2026 16:11:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 DS2PEPF00003443.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:02 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 32E171D6F7F;
	Mon,  3 Aug 2026 12:11:02 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 304311810DF01;
	Mon,  3 Aug 2026 12:11:02 -0400 (EDT)
Subject: [PATCH 2/9] RDMA/hfi2: Preserve unit 0 on allocation failure
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:02 -0400
Message-ID: <178577346214.1793053.3536426297468803473.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003443:EE_|IA6PR01MB001018:EE_
X-MS-Office365-Filtering-Correlation-Id: 9153b9c8-ff27-4275-ac60-08def179d095
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|18002099003|22082099003|55112099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	hnTpfYWUVkq+5hAo1eqE+rg+zqHLetHqMXDAYauGaxZZzJ6u4Libv0XK6t7UshgPF+LB2T7z6DESnXiSWEeNaqriuWfSBuFY14DNu+6wMNW/P4ZiralYPMVzH+FKizho7IL5dhAC0DjBjftgWbkI7+44WwMcf/P2UmzH8pY3UsqPa1mapDqvUzJyuWZkFNbsSBcw9Nb8b0oavSk1s5kW9bVl8n7daLwiqk2+nEJf1bpzNtVnWzFSXd10FIUcSzDt5KpjRrQF36jUIgT+estgVkqC4n8wwrK7CeiTgx9ZY5dwUgrnUh+UlSXR+g88MiEAO+DIqFaSiHxRqgkGthbTLtktB+lDR6yH+gtJ605+OFvauxLoVL8fhLHLP6hKkwsnsCpP3s6Jh1lZqNdYuBJJQoyvsfOwThJ52UnvtaazNp8q6y44fNZ77w6ZLHqW2OJh1gmtFeaIUk4OLltaxBHv5RPxx5UZQ4zsN1h7QEVpR5c8R9J2w9K4FeyYrFgPOhYNfQPjPjH3J5Smk2EwFXtqLoX5j6UBPHDB8+JeJ6y04WOPswtJo4DcYHQ1ZyN0utBiOCpe/7juanxrsyfu6rD379pi/nSKz05RxjGqZw7tidbpyu0axTFJVDaBUBoP8xwsGgsB3A4eKFHKhqHmQT5hyNHbeuR9oDqi44hHtogJnotr7LrldWA29ArhqClSvZ+cZGEsvyIC3k+Wy7dQBmdJQA==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(18002099003)(22082099003)(55112099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zDR4uagL8rhhq4HfSlMvQMvwvIK7nk1RJlo+pMAf4vqsm3wJMaMLvUozp3qe4wjz5lIyoC1lwU982TvyG0lYeLkzOf7sh+FMssM+hlY1dg0lL6hM/n7QE943FLcIz4wnzEV0egfs6UI1NBRGkzeQskVpRv/pJbflds19qbwThGeIK2ZThcNh80a4UIdRsKuntynOSTZioqX5aAVfGX8PMzO4WAkeDeGvmNrkosTwMSZzoG9WrfsC3B7eZqAsrJsHxx4G/ELPVQ6he//fKjNDtmPBiboVz3fqYF3OeIbTn4po+UzzUyV9EKkClbJPAqUIr9SgSTM2Hoj6mpysiMdiBQ4gDQao5ivelDD7LusXz/3wzvdPDwMrTqgM+ReJcqJev/pR4ptJRijM4sgdCv9Dbd4FEsc1PWnNDa8BDhX8yQzkr49/eaoEk/vQeAb5F6pj
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:02.4980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9153b9c8-ff27-4275-ac60-08def179d095
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003443.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR01MB001018

When xa_alloc_irq() fails in hfi2_alloc_devdata(), the unit number
(default 0) remains unchanged. Directly jumping to the common cleanup
path incorrectly erases unit 0 from the xarray. Bail directly without
calling hfi2_free_devdata() instead. Matches hfi1 fix 2e3809ad8911.

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index 5b859ae7ae1e..2f2b116e9c57 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -2045,7 +2045,8 @@ static struct hfi2_devdata *hfi2_alloc_devdata(struct pci_dev *pdev,
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Could not allocate unit ID: error %d\n",
 			-ret);
-		goto bail;
+		rvt_dealloc_device(&dd->verbs_dev.rdi);
+		return ERR_PTR(ret);
 	}
 	dev_set_name(&dd->verbs_dev.rdi.ibdev.dev, "%s_%d", "hfi2", dd->unit);
 	strscpy(dd->verbs_dev.rdi.ibdev.name,


