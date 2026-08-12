Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012056.outbound.protection.outlook.com [52.101.43.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A4F1E0E14;
	Wed, 12 Aug 2026 06:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514672; cv=fail; b=JuSCErACaJzzxRJQtaWT0rrqB/j87Gh8vEYNjVc/QHjr1tKV9U4cGUgY1qhXJRf1k4H82pyzXFQxGYdACNhhFji63scM3d8bnw8iSY6UsIrcnWah62tF9U9FsXUJm8O9CW47osvsJQ6JCaDdnYc+AjlqOD9iQyDVx1FHzrRCtfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514672; c=relaxed/simple;
	bh=o4QGrlnSX7AKHnKXTUWuI1+zfwHTKAJaxEZKc6ikE+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=N/FpaSjRmyV/hE4TiAXuwbUYzDMBndyxlY06QbiCrWz6DnIXPnxlV9AaIsxt2yyzJp7zb+bGUGc+zBSD37WC3F6g5j+2koCvkxBNKGYK7iQlG/byC0LhFa8BoRAE/LP3i19oiiMCyQZwP7sWC33+s4kdizOi5DKmDoU7q5guoYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xo8nZ5so; arc=fail smtp.client-ip=52.101.43.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xo8nZ5so"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Au4GzCQ1CgwWJNzwQ7gCxNNxZY/pCIPe8JfESUqCkAX/6LgmdF/mrqJKV+VwhnkfmnBRqp+J9yGkvk5wshpPz00cCnJMGQ8uKjz0vJbM5No7V2iEVUObjaIiggm1Al1Jq4o1NrIkUh1R8n4j1m/OqIPUijx2uV7YIJiIVT/iktCXnk3xbRPD8ExLeC0w2X5oWwNisO8c5ggzttV9UQre6O/z7OCwcDA5db/LOwX9eL8IKTrGFzePM0qAq2cIp1TrA7KucAW2RcSjrtP+SYUPDq/em03tWK5IaAwB9aF4WJdi5PiD6xpfzUbFHl/B0WvEdp4qIGVk8EwvFBvkvBsJEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fksMSW8CRxzqCIaOcsdqrltBMYL9D40H0N7or54VpwM=;
 b=AafTuNuuunoQwoLU8tgojzBdU+jWi4v9FYEZS5B4UtICU3cSKTSI630i/J0s0nujhVQP5yQLl4YBp4NHtDfM2LBVLq2aQlPXTV8W/jQO5fX8kXRzkgYrn0dSW5xuX5EYEzxCrnp2wNvE75Mzr+TOBzSm8tfoOIDg2DXwruXF8F6RyU52t8l561NboW8AXdaKxW9SnHJtdAemgtLJukqCDrjRtSJb0uxtxcLWj7VWN8+5KVvXz0kMzAaIr5KYQma9iQUTdXdG/NfLfPSgceYMfFhI29DVdKtXzn4geW2VvL0CGQIM9uTWthIb7vN6WwBmjb2eq86gl3JQWHhhxHfRqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fksMSW8CRxzqCIaOcsdqrltBMYL9D40H0N7or54VpwM=;
 b=Xo8nZ5soGffX63RgCIuubyQ1/JM4SRWpS1SJEF01ytMVRxDEMPuEjxf/+JflBcwQIPxmvHNMksnbqMP0q9CQEVVcyDRCOuwCyC0SNADxQBTacH7EYrhNbQUGD9VXp5eH2zEKdjA9Pw2p8bY3W0UqsJFjHgNgcvEuwsVejapUzPTilnnfw48a1OMjwgU4QNpdClh6/jLlori8hjraDdszUiwsDI7rrWLWY2106P17ZWzF9sAlEXHdS7aC/Gh0sAuoTKVBZ/sNmi9Sk7muRSkzpF4dQThC1UtQkNW9CrtRhFb9kJvPz+XzVsbR2aTX47qBBZiHu10GfS1WE2fvIaNYTw==
Received: from SJ2P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::16)
 by SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 06:04:25 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:5db:cafe::74) by SJ2P221CA0012.outlook.office365.com
 (2603:10b6:a03:5db::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.13 via Frontend Transport; Wed,
 12 Aug 2026 06:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Wed, 12 Aug 2026 06:04:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Aug
 2026 23:04:10 -0700
Received: from [10.221.229.87] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Aug
 2026 23:04:05 -0700
Message-ID: <229ccb80-9dc8-44b1-adff-51139200d15b@nvidia.com>
Date: Wed, 12 Aug 2026 09:03:57 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5: SD, prefer sd_group_size from vport
 context
To: Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>
References: <20260810093037.3138197-1-tariqt@nvidia.com>
 <20260811124407.GF51943@horms.kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20260811124407.GF51943@horms.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|SN7PR12MB6931:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f05e40-afb8-402b-024a-08def8378fe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|7416014|376014|1800799024|82310400026|6133799003|10067099003|5023799004|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MJEpa0oRvUO7rIU4otieUEoIEch/9grzbOZ0ShYoL0xaWPd1m15BMA7f1W/SBIhPpyWjF+6y4uCoNPFL7pNW7dNC5/PzRlPYNVxCWLRY29dQWA5n/foA2qZzp8WppCQGU2DoMTQTDoUH0NPqT469Wxd7CTz9z2+DW47Lbwm5wdARUb5aVAg746c/MiU+TQgthb5hUtuNJZbhk7zcPB5mwsq8gu7BM+PYYp0L/l3muUR3Qdj/+KEi8C8AA+QX0crXXQfD5dWPYNbf2GNoR4RQB+5cJUaM4uFPt4hOJERibs2vgymCXYTOI+AHRMD4comzl+L0lPkB3nFMP5/ASfqVSKc3yAZhsBMWcINkvwU13aiyCaKZB0vhoGaGwVcXRGAUCMEpKVMoqXz3MG7Jc76Ae0YJAPPmkPcTW/PPhAM/3S0WksmfTQNb4vGE/Hxx4v1oyRfUpqNAeS8CNOf+xApkIJtFSehuve0iIeuzGJgBbWqgrvq52XOKmfVtHb0DNf9kwQezIpVJEe2yqhgOnysaMGdweIpjPh05Pr09QJwFi/2x0mKC9qwzBxwySOc8eShvHdiIQeoHVU3UhsG2vOKRX3EBVEJX+L/6l+9NuyjFy3octRHg+r6BlJ1+lKJaPlvnwQsfJTd7BGoXkbjRXrKj/0I3rIlX0dsLUnmDnUrkz7tYQXoNUWUnMtlWcxmVsBF/CgIQQZijBZS5XNdbOMeERA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(7416014)(376014)(1800799024)(82310400026)(6133799003)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9CRvwJgDy/JQz+zAHlIwq47cOtt9IVHVncbSGefQIVjsFXih0fguLqe1snNg9jwE2FaNkD4LFLRO0aqbXLRYeIQ7btmjfAbuBmxz8/znCTVgOza54C+lThhBqhEuFm3HJIcBtbEd234MWGUXO1g+mfNPdTuWg8IT+Hmg6YdQxMr2+WssxzxGWiI+sjjCStRhjshFAYGn5dagUj22lLBLHSv5GAQcSqm4tCdhYQKlD8n2DDeQzPfNHwNY1KZF5vOcOUUYUHDaqnwa3UNmYTggcpS7kgJrG4dssUPY6cxYsFHpuhvfs/kkMF35TS7uZfz7eVzc5wvC6PSpwvIBvMAFTOf4fveGoQX8m9PvIknlkHtyTs7D1PYwfAgA6VGa8B8kAjbpm70enFoGGPp07wsjfoo+3O/W71dIF7sy0QL2CRK7Lpe6oOmycELzG6Ve3UMx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 06:04:25.4021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f05e40-afb8-402b-024a-08def8378fe7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931



On 11/08/2026 15:44, Simon Horman wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, Aug 10, 2026 at 12:30:37PM +0300, Tariq Toukan wrote:
>> From: Shay Drory <shayd@nvidia.com>
>>
>> Newer FW reports the SD group size directly in the NIC vport context
>> via the sd_group_size field, gated by the sd_group_size capability.
>> Switch sd_init() to source the group size from there and fall back to
>> the MPIR-based host_buses query only when the cap is absent.
>> sd_group_size might return 1 in some FW configuration. Add explicit
>> check to disable SD creation in this case.
>>
>> While here, rename host_buses to group_size throughout sd.c to follow
>> the new name on capable FW.
>>
>> issue: 4680618
>> Signed-off-by: Shay Drory <shayd@nvidia.com>
>> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Hi,
> 
> I'd appreciate it if you could take a look over the AI-generated review
> of this patch at https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810093037.3138197-1-tariqt%40nvidia.com
> 
> But my feeling is that this patch is good as-is.
> 
> Reviewed-by: Simon Horman <horms@kernel.org>

Hi,

thanks for the review.

Regarding the comment:
"Can an MPIR-derived group_size of 0 or 1 therefore still reach
sd->group_size?"

[SD] AFAIK, no.
MPIR can't be 1, and if sdm bit is set, it means group_size != 0.


Regarding the comment:
"Would it be clearer to always write a defined value in the callee, or 
to report capability validity explicitly (for example a bool *valid), or
to have sd.c test MLX5_CAP_GEN(dev, sd_group_size) directly instead of
overloading a representable field encoding?

[SD] We considered it, and prefer keeping the cap check confined to
mlx5_query_nic_vport_sd_group() so callers don't have to repeat it.
