Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795606934;
	b=dNL+i5woYiJOOpnHNrUcjAm8okF4OYvRwLuXwpkiUVqAoDIDdyoTOvSnLKZVTiIU9eHn
	 Z1x6kKYZ/iEj9h6kRX3GK3Ox/aKf/KQ857U9a+Pl0Bs6q3ia4BzI1u6/TA2llS6NCOQ4+
	 zqD+IK8RfqZ0bAt3OTfnEJntMI0iHi1hsJlUMDS9WGWhLw+W0n0U9TSmMlSL1zyeCF0h+
	 c08RAci/hBMwZ8DIfFMXEt55lmeznAOJjFE3KqWvI0F2QAQ07Wr0HxW93YZ+EiCCydRwC
	 PZsf2LCUlPDScIPEg3DIQ9RT48E6AfG2/DwfiZZn29KtbJ/KeSXhfxWoFR2cQE1zwyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606934;
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
	bh=dnCs0nm6zZQtlqnyxGQtMNY7n/UQWeL3Ulx2+XM5F48=;
	b=5MZ0jhZAT4JVs5khtVCwC7x0VVWSJy5GBol9hd8Jro2WNWJhbp/o20Z8wQhLM3/XhuFj
	 qq47TwHehXMC+Xvw5zOGFvtfyQpOYf5wN3rW8yy0voVk91BBj27xvdsHFqf0rwsFegDOu
	 n2lYT/lUKmIPBxG/AXK0NLhd7l8Tbbn5kWH1eojlvTDlUXNEyrPlwciX9jghUGPug3bEN
	 MEt3VFRjLfD454dyPXtTMXKD3276N8AlEuCsPykwpIeqtATAWIVAS5YW6s/XabDWsuZ/d
	 FBxVRy1n5rxhwLb1QfH9BrQXcjLO2MzEUnZUxruaKa++VfIjWz5pkknEEIEztmGNRsQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dnEBXTek;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.60
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E22F606A31E;
	Wed, 25 Nov 2026 11:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E22F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dnEBXTek
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L7TI/8P4+9OYletdPn6JvIXwCalVEQ9gDolYO/614F4Mu/1Trc9UCPvRoltTueLUprnbnpG0zBFz5qQB2sppDgLzahW1xI1oDd2SRgXbjkQ4ViVyicAbA8w2giFcZlfQPYfeLRURjx8IT+seqnpXLhnXUzk8Rvv5C7VR/efJFJjVX6uCsr7rLoXD85QMLY2uXWCvmJjNnaTsF7d/hjqWN544yfbXDGiwj+jO8utXxa5FVtIgvm3IaEOzEgk6Gv2M7MoIqLrsp2zgkTKeebkaFVFHXvr0XKDZ695dB8HKqEa8uwAKANyIZjHqkImI7gM4KR5svfb8seynOmYCRqgLqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnCs0nm6zZQtlqnyxGQtMNY7n/UQWeL3Ulx2+XM5F48=;
 b=PBo36COCw31Usa9qcaExkhtRpW3wokFCEf9OMlhym4KsYo32yo9fTnO3n9AICatStNKwDzqpcfgfWgYrfQa0lnScFEZeLC4wrmsxB7WGQ+iH2XztdH6d4J/OXND/VkVX6pR+snpH3GzzcZ8S+vjfMCnnBQvKyiYi6z5Cn8NVMF3Ze8WdsnkzvZ112MMbXQJYdIHkBZkoxKliC3L7wkdJYCuauZH2hNeCqSnykDQtTrbbpb7ZgJnwzcLvU+KyvYeQRc4vubvGrTdHfJaNS0D6Vg0Y53lEcObqnkhsgcE1kjePCM2lz3e2quN5X0BwWJgX+AxMZpZyLF2wJQjr4bAAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnCs0nm6zZQtlqnyxGQtMNY7n/UQWeL3Ulx2+XM5F48=;
 b=dnEBXTek0mYdxyE+t0/HSbzaeWAZHrGzfsjWEsLXKYmuWfZ/kW7Aj7AQbkyOJbXkhaKvhSMy+EqHYKd2vGUnGdpR+h/EJpmbWy0PfSsZUvWHTGtN+Ij99d6H2KP8sqoJWyWvRBqpeb/E+Bj1QgdcIHK09faOMYzvWd+m5egD/S7mvPkJRYX0p5xiMzYoRNPoDBJey4UQuRdBrg2qmQ/GV0JoMG1CugoOL3N/amtiv6OuSuY76/23p6Ya5Cxad5/yADrVBfDHvF55Z4FfXdqeQMJkDVLeIHea0dk88z6YtnC4+DrGo6Ytoe1Gt+IugXHluRBiLEVHYnw5ywhYj8MxLQ==
Received: from BN9PR03CA0066.namprd03.prod.outlook.com (2603:10b6:408:fc::11)
 by SN7PR12MB7324.namprd12.prod.outlook.com (2603:10b6:806:29b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 11:42:07 +0000
Received: from BN7PEPF000000A2.namprd04.prod.outlook.com
 (2603:10b6:408:fc:cafe::4) by BN9PR03CA0066.outlook.office365.com
 (2603:10b6:408:fc::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Wed,
 25 Nov 2026 11:42:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000A2.mail.protection.outlook.com (10.167.248.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 11:42:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:41:57 -0800
Received: from [10.80.22.164] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:41:53 -0800
Message-ID: <e8eaaaa7-545e-4019-9d7f-d2aab00c3217@nvidia.com>
Date: Wed, 25 Nov 2026 13:41:50 +0200
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
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com> <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal> <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal> <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal> <20261124143024.GO9566@ziepe.ca>
 <20261125090309.GY14811@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261125090309.GY14811@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A2:EE_|SN7PR12MB7324:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dab5dc3-391b-4e16-7ef7-08df4ae92267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|23010399003|82310400026|10067099003|5023799004|11063799006|4143699003|56012099006|261021121427099003|261009223027099003|261021135927099003|261102123227099003|261022105027099003|261028144727099003|261026121527099003|261026140227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7RP546421SviAODaF1mccsuH/vzL6/beqeW0iC4O2TMn4vysylhxIWnCaq+oqmFGAjJhDLtGKhkUG3imG86vQc/QmPxdLsFluPTtzMJXtXFiW98H7iAbtJEGQ/bDV01Q+0jACf+8YX/u1LFgnFqO6u4ACLQ4UFnOrfozxoCc7MYMMmw0c3LYNiP4AAIj4ghSZDDswwbJeyx9O2srjJM1gb/pbkDKEfDPUrtfbbOuaLvqKG55gDQrWzfIuJGL2Cj7NYznpXEu53BTDC3kAXz4d20gDfq5DUcHPxcn+BzSNB7c2zE78IgYQoyDb5bVX6lGBZFuKWYiQWGdRlVgCYzdvh5LGwmU9/+0m8kJvP6XNN77Kt+WEV73TL43mx6wfjJ8pbipU+Ku99nq3j9RH22AdaSbREPBrXX23TqiAR31BPyiZveo6au+ZesNtNWN4QLbVPkIZjS60BCrW6dd14n/5Pdzm0XbYiLUpdrsvJPMTCkgchR3GqrD5DBauhhqBPHqE2VOqhnbiZgk4PJc5nx4j2tbpPaR0MfEybJV8JxfVEzkffj9Ikz14DWdzqWD2GKONwbg70/TWQfHlBGTlrnSqjSnefozDbYPjvrina7s3eV007a1rAxmmznFx8H6b+bGH94SgRDXsaU1aglCsUJ9izBD8luyTX3vOFc6pPXLqmcz4nrnNRDjGQGdTOVH7LYOUfDebBet06HgTvCO3sNIWQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(23010399003)(82310400026)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(261021121427099003)(261009223027099003)(261021135927099003)(261102123227099003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DLnuP3keTkJ+S1RyAVN4nKU8tgK/7nxKlbHmtbCooVyEhdo9/xjtJ77aKSRwL2tbf8fjq6sieHMZae4IQ/wmXzezpkRCeXtWD15pwQQttwga/vqsLW3HGKlyk4I6kWJKFOHu/pUw/G70d6tVJGNm+01QylfIHyfFkkI3NPCDGbxQzJImjhhD+H0jOM/PQQMUhkOc1LGAoKMY581SWwy5Cw/ixKzRlLTG+9OsTy5km3Yu7H7bZ0G7/EbK4vzz9bI0KiPhtfWrPAwhFSHQP7wnnAT7M9TB7E18JMzOIodYcv78hCYpvzprEKTtMb3uYKGc1BOJI4mtl7dIbmxGdY4bjw2vF0NciDzk4CuMZKRx2liusgiLtZJRtQdRXUIikJqg4FIdEmeLeHSm9YdS8SL0dUeEknOWVlPagXDqMWTqZq6cQHpTI1jH7/vrRF2X/idk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 11:42:07.3142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dab5dc3-391b-4e16-7ef7-08df4ae92267
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7324

On 25/11/2026 11:03, Leon Romanovsky wrote:
> On Tue, Nov 24, 2026 at 10:30:24AM -0400, Jason Gunthorpe wrote:
>> On Tue, Nov 24, 2026 at 04:09:06PM +0200, Leon Romanovsky wrote:
>>> On Tue, Nov 24, 2026 at 09:47:51AM -0400, Jason Gunthorpe wrote:
>>>> On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
>>>>> On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
>>>>>>>> RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
>>>>>>>>
>>>>>>>> In adversarial mode the NIC is not trusted. As the kernel protects its
>>>>>>>> own code from it, user space has to protect its own area, e.g. the data
>>>>>>>> path that polls CQEs directly from the HW.
>>>>>>>>
>>>>>>>> Hardened user space might use a different data path, with extra checks,
>>>>>>>> and support a smaller surface. This isn't needed for a trusted NIC, so user
>>>>>>>> space must know when a device is in adversarial mode.
>>>>>>>
>>>>>>> This information is part of trust level series. Why is this a “must” in RDMA UAPI?
>>>>>>
>>>>>> Userspace has to work differently if the kernel driver is in the
>>>>>> adversarial mode, and the kernel should not permit an old non-supporting
>>>>>> rdma-core from loading to prevent a security downgrade.
>>>>>
>>>>> I understand the first part of the sentence above, but the second part is
>>>>> unclear. Why should this prevent it? In adversarial mode, the kernel simply
>>>>> isolates that device from the others.
>>>>
>>>> Userspace needs to do it too or it is not a complete defense.
>>>>
>>>>> Moreover, the kernel cannot determine whether rdma-core has actually been
>>>>> adapted. A locally cloned version of rdma-core can set the new adversarial
>>>>> flag without changing the old, legacy version.
>>>>>
>>>>> Once that flag is set, the kernel allows the patched rdma-core to proceed.
>>>>> Therefore, saying that it “should not permit” this makes no sense.
>>>>
>>>> If someone makes a non-official version of rdma-core that doesn't work
>>>> securely then I don't care one bit.
>>>>
>>>> I care that the official versions are not improperly mismtached to
>>>> give something insecure.
>>>
>>> You explain why rdma-core needs to know about adversarial mode, which is
>>> fine. However, you also say that rdma-core MUST send this new flag back
>>> to justify the statement, “The kernel should not permit an old,
>>> non-supporting ...”.
>>>
>>> However, in your last reply, you said that the kernel does not actually care about
>>> the rdma-core mode.
>>
>> What do you mean? This is a mechanism to help the user manage software
>> versions by not accepting incompatible rdma-cores.
> 
> Please take a look at the patch.
> User space provides that new adversarial flag.
> 
> +	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
> +				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
> +	if (ret)
> +		return ret;
> +
> +	if (ib_dev->adversarial_mode &&
> +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
> +		return -EPERM;
> 
> ...
> +	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
> +			     UA_OPTIONAL),
> 
> The kernel does not care whether rdma-core is up to date. It works either
> way, so why should we prohibit older userspace on these systems?

Older userspace is prohibited only in adversarial mode.

The new attribute is optional on both sides. An older rdma-core doesn't
pass it, and the kernel declares it as UA_OPTIONAL, so
uverbs_get_flags32() returns 0 flags when it's not supplied.
The -EPERM is hit only when ib_dev->adversarial_mode is set. In generic 
mode, nothing changes for older userspace.

In adversarial mode, the kernel side works either way, but the process
doesn't. The threat is the NIC, and rdma-core polls HW-written data
(e.g. CQEs) directly, so an rdma-core that predates this support leaves
the process unprotected.

The flag doesn't authenticate rdma-core, and isn't meant to. The process
is the one at risk, so it has no reason to claim support it doesn't
have. The check catches a mismatch between official versions, e.g. an
adversarial-mode kernel with an older rdma-core, which would otherwise
run unprotected without anyone noticing. With the check, it fails at 
GET_CONTEXT instead.

> 
>>
>> It is not a security mechanism to hard guarantee that rdma-core has no
>> bugs.
> 
> It is you who talked about "... security downgrade ...".

The downgrade is a silent mismatch, where an older rdma-core runs in 
adversarial mode without protecting the process from the NIC. Failing
GET_CONTEXT turns this into a visible error.

Would the below commit message make it clearer ?

RDMA/core: Report and enforce adversarial mode via GET_CONTEXT

In adversarial mode the NIC is not trusted. The kernel protects itself,
but user space has to protect its own memory as well, since rdma-core
parses HW-written data, such as CQEs, directly. Hardened user space
might use a different data path with extra checks, so it has to know
when a device is in adversarial mode.

An rdma-core without this support uses that data without validating
it, so on a device in adversarial mode the process runs without
protection from the NIC, a silent mismatch. Such versions are already
released and can't detect this, so fail GET_CONTEXT in the kernel to
turn the mismatch into a visible error.

The kernel reports adversarial mode in the GET_CONTEXT core_support,
and user space declares its support with a new optional GET_CONTEXT
flag. In adversarial mode, a GET_CONTEXT without that flag fails. In
generic mode, nothing changes for older user space.

Yishai

