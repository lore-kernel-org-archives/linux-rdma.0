Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794742015;
	b=QijMoKQc5S32QXLQD35o8qlXvmtngoKwqyBw6uPIadT6FXpmDGvzTmPva8fmYd4Wy8gG
	 6hXcteWHdwohVCclBdq8B0oy1rFK0SzXc5MR/KHW1SoQzMP7I2wNlT01VMNrTpmQGmaSU
	 4TVTRII0oAfWuAJSIJYrTsmtWENVbPkPq2Ijo3LJNvSR5BUMeCdZ118TPiHL7klZOBkmb
	 VDARQhGwLQpjXCJQcJRVDg1JIf3qSWvfF8te9ZDXyAc19kFRRcdh5we3B4Fyv53tYhkis
	 YitlPLEYZjcRH0lOyxYvx21JJPE1Gt9oW+0ODGB7+j8p+ly3DSxxga9NqwNsjvjl+kQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794742015;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=lgePxN+ynRErKsp8V/s5/ILkNwjromOPzZHoGKUYDqk=;
	b=gqzqs8qykl5wCdfN4uyOLbEFlyBUtEfeARDTPvlc/ojKu7y8aNx062IikiJwsC0Sl9T0
	 rdKo0CEXKG48RKIurNF3rne8EyavAFqZ+zhR+YxWSK7+UW2eQoHuAl6XKqKo41b6c84IS
	 IjNZWO0lY3d0mEWaqSa/sxCR8fASyz+/sU93fnWc5d62kxhv1y350LqwoLjXMUS9kfvbY
	 dIECkUqmewGr8IgLcktmv6yJawRibzO3tPCRiiQ32yPBc0tSbDypDMnPCvwvJKvAAukLz
	 zlzlawTQL6WrqpIiFH2SWoZ2kdm7KprHAcZcG0mi1qOpjnD4ddLQ5Tz+W1DXELm5Y+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dLljU5VZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.21
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925EE606A31A;
	Sun, 15 Nov 2026 11:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 925EE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dLljU5VZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nv/Mwv5v8/GOIihWkalhlrFP9hXIVm97b0luOWABfDyxAyNw9S+nPUxC+U5CnAPK/hnF52lEw9mEGqNo42yh3Gc8OgN6slYBtO8Njc/gx1FG49GbgX1HEeUzdI3fa9MaFb5mKz5gOI5QV5LwmZwLcXcM1LXQNcRaSBN7eUuM5fZ3aZQabS/IL1cJ/lITbzM2kEDCPJkh/RYHYgue62UpZGB4v42bpf/3e0wx3LfKsXa676LaH7i5S7uo77Fmwx0LbBhJ0vi95+edwBoV9v31V7D3H0p3cgKVYxp3tAnoppBqeeUI5GnFaozEWABGMh0HT2XY41FerGrvYrjLmV06Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgePxN+ynRErKsp8V/s5/ILkNwjromOPzZHoGKUYDqk=;
 b=EQQ8megyW/pXxa6kI6AhFZbwX7UJvWMPCR+LBMNc9P+5AXsef0T8WzJXuWUJX8NoNo4sQ8gUZmTaSRp1ZKMTeiOXw6T2Vfn0qh7ktD4AfIrD1JcVOJ/Fr+RJobDOFOiRhfV2wCI+bOdGZo7PS+DE8AzQ7U3V4xepqDjf4/N21LxE17WcuQadcu2G/y/ENq2gmzzWzhSZVuNm7mFgzp3Zk12YYIPeNBJ483MVxIHEIrrK54l1BiE/5a/0Gk1Yu6KluTnPDOJi0uZmCHijdJmfiLwwd7JDBSEP78XTxcXMATzIhEnCxIq1N+71gnYCFA7oh7sO8qz+84knraK8/kif1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgePxN+ynRErKsp8V/s5/ILkNwjromOPzZHoGKUYDqk=;
 b=dLljU5VZE1XF1c/oLxTKYcoiP7aHP//hwx2aGoKMtSs8hrt2g8AA4k7Ezy6Xz/o9voUUHu7PiIregRDGj/kcFFxQfKU5uNaVusOB38ud0VPz2E5uGWRGfvXlswySWOIbh32qVeYnEtNj1/bzAAlj8+S23IWwYWn8MIW1K4B8jU0EEcHLTRESlnN/Ztlcs/DwRqe9VooSrguNkXY0n4ziE+DQRq43BB/f57ZnG+MrG+64AhTt8dy7AORmudexnycARR5kV0SCZVG7f0jXa+NrFbtaLZZadfoGfBioVwwNuNlLKia7lhnAY328Q0Y9ALYvZaAH9HsU8x2AlzacneFQRg==
Received: from CH0PR03CA0364.namprd03.prod.outlook.com (2603:10b6:610:119::15)
 by LY0PR12MB903988.namprd12.prod.outlook.com (2603:10b6:404:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 11:26:37 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::9f) by CH0PR03CA0364.outlook.office365.com
 (2603:10b6:610:119::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Sun, 15
 Nov 2026 11:26:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 15 Nov 2026 11:26:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 15 Nov
 2026 03:26:28 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 15 Nov 2026 03:26:23 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sinfo@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <agoldberger@nvidia.com>, <gal@nvidia.com>,
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <saeedm@nvidia.com>,
	<horms@kernel.org>
Subject: Re: [PATCH net] net/mlx5: IFC, enlarge active_port field to support 8 port LAG
Date: Sun, 15 Nov 2026 13:26:15 +0200
Message-ID: <20261115112615.1011131-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179458367272.2168702.15400963269849864687@kernel.org>
References: <20261112182940.3655773-1-tariqt@nvidia.com> <179458367272.2168702.15400963269849864687@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|LY0PR12MB903988:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e393f79-ff67-4d5d-c699-08df430b4ff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|7416014|36860700016|10067099003|56012099006|11063799006|4143699003|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+wHiqCnCPGfuV7gfGV59mDIJKV2W4ZhoRXctUcmK+jUb5bkwjhQbtjJu5AQfpXbQ1oBslzos0SsF7IUy06OubpasakA448PHAAcIcJre27hsHozcUdwVm6eiTz/yEHxm3oBa0NIOc0Nh3XGFGu8U+GI6SsTuw4vKnXfOX9Jr+j/OttKyBL6EHT4jaoxrhNzoUlGuQ8UZfCXwjeHojM3FAoOx3NSXP8+Zfuch88rmfiy1N2+B08nlfOBpx1NsZQ8Ct/IicmCk8p0mJkkcN9FxVElaD5x7G1BkCRksD0iqs2j7OJb1zcUfJfr3IzEOuvSb9Uqdg86RCQpLfHUzhzYxpPxeECK8MptmjoMxEhGE94iEu0+C6XD5Cc+cbkv93wq//ZEJygYFE7qcNiLyWlJMTl9ZrI4X0sQK7yDAWJTu/+J7OdxQbPZq5cVjYJLn+b0qfwQYIppUTMWgSFwnUbvZuaoSMy2E9RYzbe7CsLdD2kJ3QKY7beSaRXFKm0Hc09jpkrlYNbrv6XaQtVYpRf67QwbLEvfU1z1pPTyvsJRi6lDG0Tl7+ZCyOb4m0Depch6Sdr7B5nLRyJcS4IpMznsF11c+k2kfb1rssg/DdD8KfMtEaKEMY9U3x39/DZ2T25Ihi/unLxF5+Jkh+Q97dGvsOM30EQGiretLt/T3Sr7k3DDroS2ZAia89i628bYidesuJFiSLFCaRkyVyLoh+/kozA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(7416014)(36860700016)(10067099003)(56012099006)(11063799006)(4143699003)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SflP8Y7hvvl6vgolJxLptNrB3/0hH0xxjC1XdKf2XQYBnNhY8Xe1vwNqBBAvKFyodbi2eEphn8sHHbcZ7lpWhLRiH2wu0y7H8+rHnbA1na87YZo+GkGpwgFGHUZNGWn9YRO5LQLhZwaMnPt/7WcEclwM/FhE/LfNVu0kBFi9fkLJ3wZ8/ZAr8gJSrhwMyiFKl6pPrMhKNBMunmQSSr/ZAuLNm0KFmZq9myo3kYRiUJfpOdeV/dPWbwJqqPVJdZe1rGL39rJuooBUPwJIVXgyFm28aP8lNbWcDLGrR3rysFZqjnWkRtzeeT3XykoL+xHoA0B+DYcslrZzqqUyPD1p8ow14Tx7XvGVYjZX5/wKqSUhjTKJezlN4PS3mjY2hu1vys6YuNWZFdi/TvMRxM4M1hEUj5JWFhSLKOyh0C/i+Jg1nWMXfa/k1NY3HcCvXITA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 11:26:37.3502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e393f79-ff67-4d5d-c699-08df430b4ff3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB903988

On 13/11/2026 17:27, netdev-bot+sinfo@kernel.org wrote:
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

Hi,

It was found by the netdev Sashiko AI review of an earlier mlx5 patch
series, and confirmed against the PRM.
