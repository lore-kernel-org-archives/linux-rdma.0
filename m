Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794214246;
	b=z4Nc3DuKOR2eXij1lEmzYBpOqr7SRjWpd3M+yRn5Pxy2RCv+dd3g73OeXvpTihGJzfhb
	 bXIpqtI95HTqm3X6G2BEv9dieENh8KrTQ/ykljZbetKDPDhYj1SQL1N/WqvEb3OoJtSg6
	 gPMPnY6x6pBtpsoifkP1PdmRknZ1AdZAv98tkx9HgbPodhohRYmuys+hoF7lnXwSf/+rh
	 ejmkBQyzLzy4H6ss4zjOBrcQpWYbK2fL2zMq8xHmeBAhCq/DCYD0bf0IXIDhYpLwotHUA
	 HO+XQTO27SQSmCVa+s2DaCvYFZem4Kh8CJplnrzL7ng9S04hU/uLFB7H7AcgiCEvIUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214246;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
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
	bh=kaO+HVcPR1o/4KoikptkMt4tlcItSfPFvehyhRV9lHw=;
	b=q/NhrnhCDqrm7gOJ50SKwkvEULrjWi77r/nQKA7qqJ7+CfUQ2FUtp+SC47/KMPz3200P
	 VbrNBMzsv/toaoldozULFAMkCJn+I1pZZRE59tKauuT+7uWXqHGjAlBBmF35a0jorOj0U
	 h5rYWuVWuUl2R2K8i+wGJp51DyewRML0eb7khiuv1tYlZPsYUjKdPOqUmbmndeh1khaVr
	 mz59AR1RPIyVH7AuMvXCdoWVF/Cb3BxZVizyCo4CXw2+PD+/OkJ9X2B5WzeAtK8kPtKXj
	 Vpv68HXpao7TDy88qvacVvbQTt/8xJ/ZhPY50WeTVeiU9uJ8av1f3BVAHtgQ+eldc+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GVd13vUc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.13
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013013.outbound.protection.outlook.com [40.93.201.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732D606A31C;
	Mon,  9 Nov 2026 08:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8732D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GVd13vUc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YK/PkIb1Y6ZW+O0nX78OdFIkvyr2t5bO3x2/kKZOpZRqs3u/2sDFFf2GeAlIaZQAHygYZS7w1ES2CQrAESuskPZnkrrBqvAtj9esPDOc9fevLl2yYpgFJslqbIIU0iLE1v6Hf+zs93xjLXiEP/Z8KTvUtNU/4tKQmCN3fvwmMP+2LD3G73sLYQVXitlfoug+pjFy5LCE1oMOVt65L7ESa7Zq5QOjop1GOcfNv2Yryu5/cgPkaTYfzy8vNKtfV+HnHNst10fZLe97tlxMmaEn+dUziA0eH9dkjh2eOxz/fyygEb3W2xRFi4iF44icRnhUj6Xd5k7t03mMrTpV2vgopQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kaO+HVcPR1o/4KoikptkMt4tlcItSfPFvehyhRV9lHw=;
 b=hpKCivcbNckrG2hJJ7s6oS5h/2L6fghM3schQQtPGMhNHyaAmHt9MxJFDV30fftFnZi84rgyUgb8HdTh/WgAcOXQIFsJGX8u6jI1B3p+noQJY5kusmnFbtXlYzrinwszFH4LONnCt2OKtxpBp3UvkF3tjmExQLt8wRFKtnxN4x6R3ZldlTaIWKFNGfi5r6oq/HelTd0Y93PujYCgx1wQeEmfK30CG1UsdWYM5tnlr/lO6QyJbH2ZJJfhaCoxoAK/qmV3TS4pRAlpXataNtfyhudd4beP/PBTaEPTSRYRxzYoBC/JwohFn88JiuuHSM2UzpO4SBEM7jYZ/gPjWuKsEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaO+HVcPR1o/4KoikptkMt4tlcItSfPFvehyhRV9lHw=;
 b=GVd13vUc71Wgq+4KFbIIO8ygMpm3rCpAR5V+d08Mc8QPiVKUouw46dXVzjOHJWyLpvY+HIqh29Is0NeMOVW//O6ZLv6vpDzk+3Pvng68B4wnQcf0PAG+EAIF24X1YlATExMT7a1mQZDWED7yXvS9zSwbputjehMN/g60TPB7k0VtFWwKGIz433X2aRXS9ZDvcMHQmNyiyRiBs+tbXmzGKCy3oXQu18WNxyi4BhA4hANGGzhJhzxQzMnlMDT6VOAYbcHmP6BPAOrpS5usB9mK6iNrrWhJPK0EtdjrDYFPlRL2Iyym/dA68uAJtzqLq1uw8dntTkwlLpSQ2oKRtxLgmA==
Received: from SJ0PR05CA0133.namprd05.prod.outlook.com (2603:10b6:a03:33d::18)
 by DS0PR12MB6653.namprd12.prod.outlook.com (2603:10b6:8:cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Mon, 9 Nov
 2026 08:50:39 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::a6) by SJ0PR05CA0133.outlook.office365.com
 (2603:10b6:a03:33d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.5 via Frontend Transport; Mon, 9
 Nov 2026 08:50:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 08:50:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 00:50:20 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 00:50:14 -0800
Message-ID: <67e1f364-2c1d-4c21-a9a2-10362b891001@nvidia.com>
Date: Mon, 9 Nov 2026 10:50:07 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 11/23] RDMA/mlx5: Add shadow FIFO infrastructure
 for UMR completions
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-12-yishaih@nvidia.com>
 <179408309294.994134.208597027649974206@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408309294.994134.208597027649974206@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|DS0PR12MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4d35f7-e48f-4483-894f-08df3e3e8759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006|261028144727099003|261026140227099003|261102123227099003|261022105027099003|261021121427099003|261022075727099003|261026121527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	VnqN98vAuZQzzcHsZB1spomlyVIhP7i8Ym+o5o63oLziA/OLi3j4tCkyjVjj1j4TtVxSYnbfIgYkhdpCDTw6+nZmY37VbHDOsNMxtdXax19bCFV5YeVaO/JAzKlYlOxLx+Kj12ldTOVXed4uKOrCdHI6L1Kkfu9pJzBViafKao/7KzBlLJj/s5/ch9Duc1nb+AwQItG4cSjG4aZjVA/mz4Q2CzmLCA1+DIjUvbdb8J3AgefspRdmAhJBf4KLfMIgbBJQN5Q53ExWtvHKU4O51Ndz5BczcIev9v9lchuPVhKEsu7rJWt5eMQS0DWicfRAuLkK1PRm8HZ2jfFqWBRKz88V7B+xquvw7ZjkUr3cfDaEP2nsAEBP0aaerUrgyJriRg7pgF5d5++E0JwKXidwckoP7a5nHD34FL5rX9BVIwnW6OzAltWoE12iALidkqF0rNfb0sURPifU6mPSqgxLr6WXr/e8+IpInS1XTEcc1CWBDY7tZJUfjiGvGg3kK4Y2FUXMIOTwAcNK/bxEyCxY8rvy1ngI0IOLVzfgE8W4hycrtFtPs+S3fLKMwptl9JnUJ0pVb/adembGRXdzhfiuO+zRor+Z4kbl0zR5JhCFJNHZsDpp0d9H8+bwpspaJa1NGsTpNMVAoFaVdLz/C8Mg5khMNl5UsmtfucuntkvSx2QpnBOpDDRrH6g9VLLifGtfOra5ROGobnOtOqFXH43ZqQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006)(261028144727099003)(261026140227099003)(261102123227099003)(261022105027099003)(261021121427099003)(261022075727099003)(261026121527099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i2SKzq/bf2t+AokNNo9Ca+0oNVfmOcjrp0By9l5//wE+EytAKSc4EYNg7Iad+S0yhXRNYRhAhyW1KWVRdf3FH64IV2w9qv/ZG9qjwOi20Z01pWnOuCSfI7e2VPlMQDD8NyhufEpkLC77gKbeEATNDtAtNvgCrXMMftD3Fa0Ny63zx2+UE9FnA3KOgQV2YCrEQ6oijnplg8w6SHB28WV1yef2op5bdNYQZAOaHwJk6sfbYh3zZ2hkr7aQVYwjFO9lo5CK+LUkxGiNAwXM+3/s0TTArquuteMQd7KSIeGrXT1tH4V1FXbrlKrM3Fyw/e8TNBayPCPXOh+Y/c4dFSZ6He+/8WB3rxknvDGhzWK0T0Ryh5s1ET+74MStle/n1ZWOP3bxeAo14t9NqXcd2iotUzvib7cdwHyhZLXK9UH65U89WH6uJCG2jaYWAiEDMdtK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 08:50:38.9192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4d35f7-e48f-4483-894f-08df3e3e8759
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6653

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit message's design premise is wrong.
> 
> --
> 
> RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions
> 
> This commit adds a shadow FIFO of posted UMR contexts in adversarial
> mode. A later patch can then check each UMR CQE against the oldest
> pending request instead of trusting the CQE wqe_counter. Each context
> also records the SQ producer counter it was posted at.
> 
>> The UMR QP is RC and signals every WR, so its completions arrive in
>> posting order.
> 
> [Severity: Low]
> Is this description accurate? The UMR QP does not look like an RC QP.
> 
> mlx5r_umr_resource_init() in drivers/infiniband/hw/mlx5/umr.c creates it
> as a REG_UMR QP:
> 
> drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_resource_init() {
>      ...
> 	init_attr.qp_type = MLX5_IB_QPT_REG_UMR;
>      ...
> }
> 
> to_mlx5_st() in drivers/infiniband/hw/mlx5/qp.c maps that type to its
> own service type, not MLX5_QP_ST_RC:
> 
> 	case MLX5_IB_QPT_REG_UMR:	return MLX5_QP_ST_REG_UMR;
> 
> mlx5r_umr_qp_rst2rts() also moves the QP to RTS without a remote QPN or
> a path, which an RC connection would need.
> 
> The shadow FIFO design depends on in-order completion. The consumer added
> later in the series, mlx5_ib_poll_one_umr(), treats any CQE whose
> wqe_counter differs from the FIFO head as forged.
> 
> The in-order conclusion is probably still correct, since mlx5 send queues
> complete in order and the generic poll path already relies on that when
> it sets wq->tail = wq->wqe_head[idx] + 1. Only the stated reason seems
> wrong.
> 
> Could the message say that the UMR SQ (a REG_UMR service type QP)
> completes in posting order, instead of calling the QP RC?
> 

Right, will fix the commit message in V1.

Yishai
