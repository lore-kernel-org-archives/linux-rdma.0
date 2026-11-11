Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794412723;
	b=uSi0+feTH59SdRVBvuql0t3BqBW5E/1tz+lly0VHnz0W4Avl1odXPPq0SWovWhvQfjcT
	 MSiqFqdY6ZNgE0bDpIe7sOinsiIpGdWYPD9Zq2rjrOZVFuVDRR4G39uM1KDcFFQ96li75
	 vYekQ1vfI3TXWiWL8JxmGiBrtsTzs4EQuNem6HjpPDlZIEY39XS2Ctm0KikAjGuoM8KfH
	 8gByCTrp+d6U7pw0rcLQOIlhJmTduoFqTdHLv8bY+WoRD3MQwCvjBW896v+zjL2Reulzz
	 Rv/hHByRTk0Sq8CQCJF6uWIEtclhJEvRZD35QJaet6vCXLBLzQnKqGH+NEmb2vD3Dfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412723;
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
	bh=YqIR2wFwXppcwn3gtueJ3SAHySjgkzb5t71HvQCcraY=;
	b=IlTfYRDkdTaP74i3qaGAOJ3ldRxFL8cnSTEyoeP1STRC/lVhCYR/KJ+ELYUf8LqmlV88
	 gZnIUpNo/sQA4ys7v40mJEnLsF7hQaqtBgHo27DeQdq5AI3WO1O41F4i3nuxhJTUbYz/X
	 KcDRYdyhdc2CPE2wYAO2l6pfsOuqHYK6K8bFGVW5VyrQI7SqNKJPyH/9A3zsH9FvkkFAl
	 w2hVzKyF6yS6BZXHPtQy/4JncumAbL76dAdqHDEQpcrVxy9zK9NMGmwBpPA4kYsGIUsWz
	 Dx6wexyBPiWSV2U2DgIx++CAbgbGLW8EoaC43X64MWWYmTNhYlWmtbUo3evGBk1TOIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="si/eLJPm";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.71
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B8606A326
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 15:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 982B8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=si/eLJPm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OcqGr6loPrcm3vysUcyfZo4yNQX7KCq+vE2C9qN7t5O6ip+aF1yy6Kw9Ba1z6jsPK/EoJwK75CKf2Gp+rz8gBPVFLzQ54NnB5nc8fbL7zl6J0BSHjWfGjPMxN9UB7vYziq6sexVHbWHZ4v4jfGzhRT5CP6ISJKSR+EXylLu0rgIKBYVuSQ+CQmX6vDb22/4nL4nGnsBAxBK5RXyb38ibUfn7xHVlGHra7VJ4m48Tz2j3qw0TDH7gSgrbaQ222bROfwzDsqseIZNCc121BRaZgtqBpseZo+Tn3MIFRqtAeUxOA1QqiAE5r5hMRStekNIDw1/lKSxIKFmhdCEX5mWXWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqIR2wFwXppcwn3gtueJ3SAHySjgkzb5t71HvQCcraY=;
 b=SxusfptEF9UuzhDAXOCFIoMWqQKp3j0xIk7c9+b28ALSMM1pRZ7pOGrJqMWsTADO8EGbuwvvpR2dVelSRLmkZJjR5RcwArXIXD8f+htblXCDRH7bxsDjUmU6F3v7+tGFkObgeavPUpK9S1fRlziJyGQcWcewaD/7I73Bg2V4AS0Er9XPWbkOMOS4pHGeJbkQD2r+8/YpmVh4Irx31y17GrwwabB49P9WTvzgcQsGZCdisX5JsVy9mGWCDbnj7cug4kMC6cC/THAXV+kbSkajtOjSSE7ijW1d90IDfEBpiv0NzW0bW4CICIe/QbOP8lMvGbCWuRN2eNNpE2KkWNHFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqIR2wFwXppcwn3gtueJ3SAHySjgkzb5t71HvQCcraY=;
 b=si/eLJPmMyBX/bW7OWkXPXCi2scp0x7sSiGo7My1AeAZvrBC16Tm1btEq7Ocr+1Wj+9JgYhagqdOpdT+hy6x8zE1izbrYeJyxGpdoHz0G8zh7ZIOq5uoBlAAuTMp2fe8MYoXJI6cETC6sMA9rwGxLxyiEt0Q74y+BJvRcWHiLc7TE+AA/KtaddDBS8+ERYCY3gLvlf4aQeZO7T8wgKyVwwQKhaHWs4dRZo8uc8XCbDvS0JMpNpapP6qa1VCgSIiXYzYRcmuhaOXYI7A5NFJNFgzSMwZ4gVkGstPyXGR/y1fbV1zzbCAJMxNTTx8pas6aVENwr4HgSXQBJDuvVjbaPg==
Received: from BLAPR03CA0096.namprd03.prod.outlook.com (2603:10b6:208:32a::11)
 by CY1PR12MB9673.namprd12.prod.outlook.com (2603:10b6:930:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 15:58:35 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:208:32a:cafe::12) by BLAPR03CA0096.outlook.office365.com
 (2603:10b6:208:32a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Wed, 11
 Nov 2026 15:58:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.0 via Frontend Transport; Wed, 11 Nov 2026 15:58:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 07:58:14 -0800
Received: from [10.125.206.103] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 07:58:13 -0800
Message-ID: <cb3378ce-8726-4666-a863-30d44c2d32a4@nvidia.com>
Date: Wed, 11 Nov 2026 17:58:11 +0200
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
Subject: Re: [PATCH V1 rdma-next 19/24] RDMA/mlx5: Validate firmware RQ/SQ
 state before sqrq_trans[] lookup
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-20-yishaih@nvidia.com>
 <sashiko-outbox-209104@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-209104@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|CY1PR12MB9673:EE_
X-MS-Office365-Filtering-Correlation-Id: fb04f610-846d-4490-b933-08df400ca462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|261021135927099003|261026140227099003|261028144727099003|261009223027099003|261022105027099003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E7D2OQj7wQlBbzN5WEBQ+/VBfhO92LJVT9SwS/CVf4KAbmEoO3C7BjtCx9O5+TW/IJmiC9SEbHHD18r5iSY0CdxjErJUG1ADZcmjO/zQ5aqkZcRTwlBlTYYnUtXPCYLkPCCgWG9HlrG/tcgTPr0iZfRuyPzn2HHopO9cmDkRoCEFLJhp6FXMPtzdmWiZ4z9AMCnyB3tjUk8zjYR0KAbjXE058kCJj1ywRUmhYXUp4Z1VT7/4OggEB9VK1Ug1k2RZhpg7n2cpJMHkH5owTdJrx6cqFRZA8WlzrLxVXt6K7RzC2BnwA+5fxpF+GLF7p/z55mRqnbQ9TVfVzirxgNvIMQj0/8OI+5UBqgP9lAJpfmaoUZR1u51dSfsRxSfq2DeJrJ8dfXrVVARo8VaiU9Wq/3aiw+1mbchrZSc5wmar5Qwr4xgVpbcKEBhRxFvls301O1Ua2A+093kVvrMOFxeKSo2E4TzQCt4CDuFFy+xOCQrtvdPQ8diZEYf7MHW0D577OyLiCCizJSWuaaV6bhQJKAjlc2GItN9h8wAj8wLTc49K9pwy3guryapR6fXDfIeyT8XSfYrsvDw2DbSF9q2M+tpqGpNjpPW6iiyOwM9KX1izWWJPRMDYrVeRJEdC5WG+XhCTDY8zdTPe8FckcQyWpbv0xYX7qOK2ULkScZ5qWWMVqxTcPC8Zrdynxu3kTn35PkctynM05PouPO/CYq2sug==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261021135927099003)(261026140227099003)(261028144727099003)(261009223027099003)(261022105027099003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5M6Mxxk5I9iEysVD3lo1KQUeAR9hkc5Or6qsjCQtK2Uh0tambWS5qzB02c29YTRt/aoYc2vxeQJfd8zTKm8r1Qap4U7G4H/V2Da4DevlSOnXXIykz8N+9AAVzLlJnv1652S4FalTKV4B587HPreBv0i8XjvfQ0YuHFE1IA+nvFS5pnb6mqOmR9igWHiIAl5RsjSS+W+Mg2HmniA/nONmo7K2ctJ4Z2kC4vcRMCXdkg48WaxKVelch2RrpanaIHO82pzPi5MeXbDyO+liOwr5zyRyY6X1RZ23wLry0GRJu73cW1GcvpKWhxr2eKFbhxlQ6Dh8IwRJ9DAYTqTEqmt7zsn58Yz6TOzX/T3zLP3CWUEvKH7ohtRXoabe7cooMh/ityewFvmOO0NGwI4VmHt4A8sKc3r8yu/1AIJOTEzIad3tVA+YEZ3w9RHJbI8XVkcd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 15:58:34.9247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb04f610-846d-4490-b933-08df400ca462
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9673

On 11/11/2026 15:46, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] RDMA/mlx5: missing Fixes trailer for sqrq_state_to_qp_state()
>    bounds check
> --
> 
> commit 8e8f815c736eddc60d07600341bb9a6f00977b7c
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
>> RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
>>
>> sqrq_state_to_qp_state() indexes the 5x5 sqrq_trans[] table with the RQ
>> and SQ states returned by QUERY_RQ and QUERY_SQ. The state fields are 4
>> bits wide, so an untrusted NIC can return a state above 4 and the lookup
>> reads past the table.
>>
>> Reject out of range states with -EIO before the lookup.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> 
> [Severity: Low]
> Since this fixes an out-of-bounds read in sqrq_state_to_qp_state(), should it
> include:
> 
>    Fixes: 6d2f89df04b7 ("IB/mlx5: Add Raw Packet QP query functionality")
> 

The existing code is correct, as it trusts the firmware. This is 
hardening for adversarial mode, so no Fixes tag is needed.

Yishai
