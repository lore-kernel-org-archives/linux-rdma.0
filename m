Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318326;
	b=AGY/ym+g37acmA4CYAJwnXYDO1vT0LgR+X0XB7EtKPEKm2cqEewWKjsUSramcigYoxZ+
	 jGM4tT7EnS6n/WB/2gu1xu26sjC14bhjhpgloII0D6FC78UYLK8Aw8slR0SI6X8O5CUUM
	 DdMU/Hs6eEpegnzy0Nyw/f7NDXxhSiOCmjSN8BaDxQbo9C+emjdR7MnR6if1bounL6YLZ
	 G5jkavH2LcuTho3vI4swcn8BhbORE6ivoPjUU60qNfA4ka0woXcM13pm+OeTgmpyfw2Za
	 adc8qEpt4ttCGJ/xkPigvGVE3quIkOuPi3wQGaYQupinUvl94JboI8mo0+mHT2QDdzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318326;
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
	bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
	b=U9KfDNHndZZ6OSLe4w0D2BeSzbc386AOme/Rq8MAzJkeM1kNtWjeXao92pgHQqytQMv1
	 0ftIMUJQYdRKZLCPTRwagMI7JZBZ6nk7TNtQms/d9aA4bEf9hLUDLIGZoRGXmQ8+X4Jw5
	 3zKF19OpsPZvAnIfOAz37yU+g4pL7MDyfXMfh1uuhQnZUr5YdoVFd8R/JE4hYYkC6eoTX
	 +RfKivN9zs681uM2SxKiW1zOhD6i6l5rN2lCwF9X3iDETVJm9t3rMLXEwGdobrFSw4CIL
	 l/euKdMzEO85kpbGaaWCkjB/5D8ZW8Q4SmqzcvMozz4iOmQZPKIPsIZNXvp5DyZykyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vg9PDREc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.17
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010017.outbound.protection.outlook.com [52.101.85.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC36660A261F;
	Tue, 10 Nov 2026 13:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC36660A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vg9PDREc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWmcyUbBLFVP/g/Xt2a/WIkWfIN+cvfiEAcfB1hvxZU8fMCHiiOAIM8webEulKrBO8Z2dBh+G4oVy1EpSKkzg0I7c9iQ7ktB2e1GoTaBSB2qoe2jaBYgFMqe3YEF27ehrD/g4eRtsmaXxm2L4wLVNKA9BnX2JvR8hvP/h1K2SZvLh5QZpfI0LWruUX+8oVYABQMvjFcyH+L1i/ZYZuR9zfnlDcYnX5GKbYlYPuTdEOZj6ot7ynj7bH/eWNDBgibMJnwzlShCOZYn5Wi6VfO8112l7HjaEAaErrfcwZEC6T3kgcKsmn02+1lt4nIhh/+sGjfEuROOZTz5OzqQjggBBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
 b=Apgnohqh8yCA0FI9hHR8A5lReRQCrdm/9L8vFTbV9Yhk9Y+3WI7L4I8pHASP0zi0EJ5OxHzsGoI4cuxgIpihEhPww8qTlj1v6/oRX/NuMwqsDdxNA0SUfHD5M9LyxX7XVGlVMymCV+GqXYH/JIjBVGkUMw9bl/KkKz2gnYN0Zicxpmdp2QZn/bUX/DZMhUYkR8NAd+0umj/n25V4cKsARfWnRJdGLTOKSpsSnmhk0CorHI1lDMYY0i/KoZbmE1M4SIdgWEBJ5/rfJyA+g3k3O0QvdpI22x2B9RVVB7swlthYZP3pYfZVbMDBNrH0yXnhNrssXo4Jp8fwxNTo2KoUJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
 b=Vg9PDREcGmCh640MMkFIfZ3UasVuDMuYQmizfUQ8oBkyp4c8CQX5xiRGP1KGLK5JAykGpLzDg1o7j+hMdv/QebXexv5g/kgjaJq0gCHvOhGMhN6R90icFuCn6XFP4lxkx9IW8leI+IdsfFjW8uEuoHuYK7gMsD0DiiZ5ivmxk+CGagY1hFkkClsqAmz+zLe/dUf8FCttCY+XZEgnqH2ptCh0DRykTKYgixNe1h8xnFa+nhrXR7iDuRRmh/iPoCcofuEuFY83QlZB76nXyXwH/0659xERUL/8i2a/IH98n9uBMa2oy3XMaYO2lZeTwdBpKxWw1INgLqf89Y6wVeqaSQ==
Received: from SJ0PR03CA0029.namprd03.prod.outlook.com (2603:10b6:a03:33a::34)
 by DS0PR12MB8248.namprd12.prod.outlook.com (2603:10b6:8:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:45:20 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::7a) by SJ0PR03CA0029.outlook.office365.com
 (2603:10b6:a03:33a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Tue,
 10 Nov 2026 13:45:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:02 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:01 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:58 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 16/24] RDMA/core: Set the CQ comp_handler after its poll context is set up
Date: Tue, 10 Nov 2026 15:43:12 +0200
Message-ID: <20261110134320.34408-17-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|DS0PR12MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ba1642e-fc0a-4369-1b59-08df3f30dcb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|22082099003|18002099003|10067099003|5023799004|11063799006|261102123227099003|261026121527099003|261022075727099003|261022105027099003|56012099006|261021121427099003|261021123027099003|261026140227099003|261028144727099003|261009221227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	i/nuRijZCK9FtU17mMb7gJL4WMD/94pb0oh2uJ/v2sxavfl1YW+cI9j587ZkXpnRTvfom2obnhlOaYkvVeBvKto9L0tE/Zf4r9FS9norE5ytk7QeA2t83QHXOLV4gnsSXqCuq707DjxjVAGVJYrji57/lMQyhnRq6Z/H8c8Pj2SP2pPfE0vW8xv1mE+it6y4Ujkd/1T4fe237pZEm1HHKgL66N1/Uroj0SdIPRVL2KL0SwDQcOiZmkkhsr1SjhhLj2f22iwLENU3FgLhs6E/TnOt73uDMHOuo+w1f3ibJNKgX7x3nV7GZqe/YNRFx/UzQ3DrarZ316yFkHRe77PQkDFRGh61SluDWCyLboO8SQajDA50E4DzKBOwo+Cti1GSUwPecA8kIy7MvE5zB2qLSVenT2vxFQdoU+MoRI2eRQdUVmns1yMS1iZ+Lyr8R6aA1WWwiJ07YjSJ39XKyaV5ql10ke0Z213O6NRu3tQl/foQviGdSK8zPVm2UfBXkNn/5Zn1lJii1vU3wfmufTl7+BNa7v52+L8vj40WO6usYpNB1eivwSBrTCzaPqa9LjWtDm4RFMcC5sqIbqPUbiGJyTKGGIbw+T4pOEgokDusRIsLTqCU1fpyWAPtQ0Jb8N1Z4V0YoVI5bh/R6M4GXJsKTAEBnuQ2lz8HL2PvHtEf45JKwov9gT1Ghl1xjd8XlhIteovk1/oivQ8h9aiefdvHaA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(261102123227099003)(261026121527099003)(261022075727099003)(261022105027099003)(56012099006)(261021121427099003)(261021123027099003)(261026140227099003)(261028144727099003)(261009221227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JZMjxvfUTowPs0MiZQZOZxZPkbVofDc5oowtuDTToqjsrKPuj9S+xbbcJfe16kJi22txApVYngKXb7ra8F1Cp8S0Ly/YW5fqhNe2APfzwxzIukDdkHHQi0cIXusoKRYAFyDt30zGeyEeCyE9sZzNEUTmA44Fr9VzRXOR2OteOdsUYuNTrQ1Gc5zZGcbEKFAgppOK79Kq+VEB8cThKceHYPjnZmaTjePCZDkovohUypGYD+GWgd6YHe4ZL1KJhbq4dtPgdniTekT6fpHz5rQHliWX2+n1W/F8rM+kLF3tEPbCjOdn32hB7lIh/wDI+lq1VG+ijWRStRpDcqZu6ukE0aheAQqOvvGuKnTUrn+yJBrRZSPX/9U52Bjr+hZjU4aECKKcV+1DwmM4E65eOveMju/FxCqFvwspRqywlJxMVW3C+L5FSYx3lO8hkKHZzLda
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:20.3751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba1642e-fc0a-4369-1b59-08df3f30dcb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8248

__ib_alloc_cq() sets comp_handler before it initializes the poll context
the handler schedules, and for the workqueue contexts it arms the CQ
before setting comp_wq. The CQ is reachable from the completion
interrupt once ops.create_cq() returns, so a completion event raised in
that window would schedule an uninitialized irq_poll or work, or queue
work on a NULL workqueue. A conforming device raises no event for a new,
empty CQ, but nothing in the core relies on that.

Initialize the poll context first, then set comp_handler, and arm the CQ
only after that.

Fixes: 14d3a3b2498e ("IB: add a proper completion queue abstraction")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/cq.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 12304c9a9403..42e4d272f5ad 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -217,6 +217,7 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
 		.cqe		= nr_cqe,
 		.comp_vector	= comp_vector,
 	};
+	ib_comp_handler comp_handler;
 	struct ib_cq *cq;
 	int ret = -ENOMEM;
 
@@ -248,19 +249,16 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
 
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
-		cq->comp_handler = ib_cq_completion_direct;
+		comp_handler = ib_cq_completion_direct;
 		break;
 	case IB_POLL_SOFTIRQ:
-		cq->comp_handler = ib_cq_completion_softirq;
-
+		comp_handler = ib_cq_completion_softirq;
 		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
-		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		break;
 	case IB_POLL_WORKQUEUE:
 	case IB_POLL_UNBOUND_WORKQUEUE:
-		cq->comp_handler = ib_cq_completion_workqueue;
+		comp_handler = ib_cq_completion_workqueue;
 		INIT_WORK(&cq->work, ib_cq_poll_work);
-		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		cq->comp_wq = (cq->poll_ctx == IB_POLL_WORKQUEUE) ?
 				ib_comp_wq : ib_comp_unbound_wq;
 		break;
@@ -269,6 +267,15 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
 		goto out_destroy_cq;
 	}
 
+	/*
+	 * The CQ is reachable from the completion interrupt once created. Set
+	 * the handler only after the poll context it schedules is set up, and
+	 * arm the CQ only after that.
+	 */
+	cq->comp_handler = comp_handler;
+	if (cq->poll_ctx != IB_POLL_DIRECT)
+		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+
 	rdma_restrack_add(&cq->res);
 	trace_cq_alloc(cq, nr_cqe, comp_vector, poll_ctx);
 	return cq;
-- 
2.18.1

