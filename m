Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794213490;
	b=3oMZsSBPmvoux6l0ly2RZq8OCVIU6UZ8VFwRX0KjiPexCCktSB69vwTXThpByUm8GuHV
	 OK6wQJKklf9p5HYmPTC/lKL2pt/wPg01tnMOKD2drK+e9Ahp6NuIcAjht+DfkJIwUEV5t
	 1yFopxbHCvoq1BtSDdSmNcsROm4l9c116f5zc8Cm2Ddm9HqA+JshP8xTgeYY2CjEq+pNA
	 GqIz4pyytGL2nNndKEQsRJnXNk6oeWi/UN8Rgy4rDXHMalV2T3j80THi0jmMFEQ0jdtkd
	 b3z32gv+/I+UahcMrOLhiobhLhMrhUtlJkP5a0SKNvxNr0YGUPw3F/6NJiG5mSd/p4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213490;
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
	bh=jYV6tXdH6Utib7JC5wkqCXHH72iKK/l2cL+Kt6f11vw=;
	b=w3MvJrn/UpuPUWlh29EHzuN6iQ5VYJAKTOrQ2OPuw9HDVxKRUffrfCUvfVApELBBcXcG
	 DDfRh6DS0KNPnluAupND9LB60beFjxMNL+3HxYwW0eNBnzSgHivP4yNl6WuTGs/eBWykP
	 VLrGWXKxS+VY8OpfroPeWNgExvE4Xa9k4i3tulx9YNebUD3Vz9ldWI8MY/KsbOyC5Ghyv
	 pvGGnLSY+OgRL2RYCsHa2L1ofGIeRCUPpaLl16BTa0ovpBysPpKMR/TQgLwAp9lEy7gXE
	 USZfHBXTxutElwB3NLkIYuDvdFls4mEIDOJwgR6ZRovYxqwYAKD19EmnKgkvbMhN5og==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pjDPNWeg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.51
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011051.outbound.protection.outlook.com [52.101.57.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FDB606EEA6;
	Mon,  9 Nov 2026 08:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2FDB606EEA6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pjDPNWeg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pUOqd+XAC6laeTPmGX5+33DON9tZswCEPZ1XzL7IPr7O03prwVWI7QVq5Srl5aBT2AoIJ9Sqe0i51sBs7cb7Z+GAZPsx0SX2cU9zraLSYe9ABbbNuiwsHvf6FywURT8B6hgfQHsJiOwZ2NjCqZ4+CLJVUj3zqfbL9JvJU0DthjhFSQWmWYZHcp5RLw1jaQgJRFrKmYhKPTiWvRr8SzdlHPjfBIcPUMWK+P6kc6TioYUdui8GuKi35krxeCg2W2aUpQ6Z4bF236mxNt6qITOpJqGwfjM/VcmPyq8KF+2DrTxBSVtdaLNFDku0aSpMJV9wGHQAhOXKnFb5om/YLoP5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYV6tXdH6Utib7JC5wkqCXHH72iKK/l2cL+Kt6f11vw=;
 b=mshE/MhhoSQUIpcotig7gosmKEbvZX57++4+94Tnm+LW4LykOltutQbk46xuwv3md/FXXVLYcZ0g6woD+WIDIgM8qEOossyyLLNw1xnAL0z5lOy0nHEa0wBmEjleLnE28gkjUuRRRUHYjTIs+c3HcTH4WxIbYIBzh6WNaf6u24aQFNyboEa3vccK6UNAHu1KxNM5P0BBBxVQ4twEDu2cVr6rPA+4Ul3ezn1D3GHrklHePfJkoAzwv/qgBVS3dT9zCuVDussAGY2FJxfi9/VVON4WECV2kd8WsoEY3GbdJa6QHwUHQBRfMG+/LwHsX2JUrtOnva1tS4dB5PriQepnAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYV6tXdH6Utib7JC5wkqCXHH72iKK/l2cL+Kt6f11vw=;
 b=pjDPNWeg5w0tlcGUNvQI+C/3pk2i9IZgDv8MY8FNYCXMK0r0MvvqiH+iK4KKA+nEuTB5rDw9oOqByZCT+DmElVabLw3wj4kgMKZ54G93y/cjBDDpz0XZgYLE41BwvGfvuE9BTcl2w5w3p03CusO6WO+W/uGD67ezM6MoYdReuely/ecdubmjD9FQsBTDisb57Zk5UuVsDCrjrZv85ABhyGo4VPMt1beBrUIf5CGm0V3HtPooiscbDRlz6dC3mr3aQBUTOwOUb6Bv7yMjhkUACBJNONxK4mY2nDB3vKAeeQCu5jSj+7HW3GXTtr2I2kG3gOwZALYoBjlJ5p1mobcfJA==
Received: from BY3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:a03:254::7)
 by SA9PR12MB666623.namprd12.prod.outlook.com (2603:10b6:806:a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Mon, 9 Nov
 2026 08:38:06 +0000
Received: from BY1PEPF000264B4.namprd02.prod.outlook.com
 (2603:10b6:a03:254:cafe::6c) by BY3PR05CA0002.outlook.office365.com
 (2603:10b6:a03:254::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Mon, 9
 Nov 2026 08:38:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BY1PEPF000264B4.mail.protection.outlook.com (10.167.242.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 08:38:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 00:37:52 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 00:37:47 -0800
Message-ID: <b785be15-1189-43ce-8fc8-426f3402c098@nvidia.com>
Date: Mon, 9 Nov 2026 10:37:44 +0200
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
Subject: Re: [PATCH rdma-next 06/23] RDMA/mlx5: Require IB_QPT_DRIVER for the
 DC vendor QP types
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-7-yishaih@nvidia.com>
 <179408308744.994134.2975103686531354002@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408308744.994134.2975103686531354002@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B4:EE_|SA9PR12MB666623:EE_
X-MS-Office365-Filtering-Correlation-Id: ba2a458f-593f-49c3-2c46-08df3e3cc6a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|82310400026|7416014|376014|4143699003|56012099006|11063799006|261009223027099003|261026121527099003|261021121427099003|261028144727099003|261022105027099003|261102123227099003|261026140227099003|10067099003|22082099003|5023799004|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	6HPuQY1JWCVD/kGokvVCP9v4XcH7J52c1qxabp5Op0q3ubIXm5HPTtkGUHa2PQU2ShHN77uGtTSuWfxCTrF3dnC3E9vTQGPz3GLFGHN5X1jdn8V8Ybx6iZyaMUD/ta6u/JLKvXunY5NRnK6TCOwF9wGSAQOqwE4IUdQ6+eBhUYPbKCuQtHNIfn0TP3bPmDvG4moxsjVvo3qsd3qLievaHbedP3GDAQz22RzgF5wFYNJnlhhq3Ts6UFtJyKpLaGFRvXj7Mn0gR/qzV3Q1a/LHGydG/+SXBhi+hJjhxZPmYj78cAgk0sS09rdb8vS8ied4jWRtrVK9voTji1vdiTNK/SRuSb+GkqUopG4EehXgMrLc3In8cl/OIKASg8Ga4TU0bILvAtGx+H3EzcpZPQPey3n7Qq/KnGxJYn1y5gmTYEO88DNqujo/QnMZEjL4AcNctFoo0CxVle43GMfJ7hwlFCdycVLMgtkMs7uhjwb0iz2zg92jpcULcVf8XQBAwIcwNf24/o/+D6lSKYF+Kqinx0j2lr7LsigFEq6VpvqdVegN2M13E3eBpHO1ojGFex/uivZj/2TUAg7uMqYYTJnT8gkLZuicgWT2exXpnWZnZLktrVmV1m+2XW7J6HTO/o7Gd9JNFReHsje0ViMJKO0iCwywuh52vZeS8B9mb0ZB9oa/z3Er/SSJG684Y/w5lPjQxTTv7iX/ZzLFIEstxp7MjA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(82310400026)(7416014)(376014)(4143699003)(56012099006)(11063799006)(261009223027099003)(261026121527099003)(261021121427099003)(261028144727099003)(261022105027099003)(261102123227099003)(261026140227099003)(10067099003)(22082099003)(5023799004)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JEEJMkzAZxaRGWqcb8WOFM+mORYy3wcH2SItjtuFhXMwz0g/gt9w8TUQ4MJfA8YvQ6jKorU4nf8iTiWEPlCe+cCnn87+eTRaV/dNYPZlq07WD87NKqp5YFytZHnHzJxOeR7tu9R0E0U8WMTHFY2LCGLQZIbLMppOaGHHSJAK87v5/bXoL28ubpEgcXpHWT9dfqCYfWTXhFEdXKtmIXK8H23Dh0xlZM3x+HxdHh8ZMO1IfKQCVs/h4vIg4KIViKonoZIqTuehnv6zBdpvQ2rAz/K2U86Zsj+xqStmCMdrDKrsNrJJrMZZEDllWckwVVQNAhtM0Kn9f79U+Nv5MRnB0QSsIvHWUzBgKpzYZ/qw2B7FGO0IJUh6zxvkMqGVOWnI4SsXUqvZdzquIkyeIACboRg09xaC96KQefd8xjIXTWM1mLxvlIoQcjiCrjoPkrJF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 08:38:06.0977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2a458f-593f-49c3-2c46-08df3e3cc6a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA9PR12MB666623

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The commit "RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor
>    QP types" fixes a regression that userspace can trigger, but its…
> 
> --
> 
> RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types
> 
> This patch changes process_vendor_flags() in drivers/infiniband/hw/mlx5/qp.c
> so that it rejects MLX5_QP_FLAG_TYPE_DCI and MLX5_QP_FLAG_TYPE_DCT unless
> the QP was requested as IB_QPT_DRIVER. Without this check, an RC/UC/UD QP
> that carries a DC flag becomes a DC QP and skips the dct capability check
> in check_qp_type().
> 
>> Accept the DC type flags only on IB_QPT_DRIVER, the type userspace
>> uses to create DC QPs.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> 
> [Severity: Medium]
> Should this patch carry a Fixes: tag and Cc: stable? Userspace can reach
> the behavior it fixes, and nothing in the message tells stable maintainers
> to pick it up.

Right, V1 will add the Fixes line.

Yishai
