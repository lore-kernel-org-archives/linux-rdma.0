Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794221099;
	b=OSgVHwxaoEiShmCU1NWDe/dtjgxyNRWkMhPmjPtGmBvlN8ic06mhtWXhSBqh005R5vtj
	 6/A9u2eUDheeW+5KJgiAhwJs2DMHu4Yv72o5yKM2mAfiXK9mfE4LtZ6GpS6pfLdy3HGju
	 wvv14Rwx/Z4kiDZTkqJMMgKu/qs2IS5VysBKEr1mF/rdNcmwwtMMot3DdKjJxkHGTWiqj
	 OkrfJMeewipeHohx2s2U0AUqHc2alCfcPX2xagn6pAW+Q3o+igx6WDirUdq8K+QnjHn1d
	 LeFzZcnyvAayudM9lFUPDnntAkNMjuajB932OEGp5kG5/ffNuvyXM1nJtABIOa87CyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221099;
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
	bh=lxCE1wG/I3mMOJM+8q4VBNuNna6sL2JkhRWTAJELiTY=;
	b=RG+hYxbP+L6QV59ChppHzqB81LFgXmfSC244Anf54ZOr04goJQQxxtXM+IWzi9JTPV1N
	 Cdvrwt1Fk7yZ6vNsttu7uqpvpIh/xoWxvhnqJ+uDhuqFxAqXSPlOxfvCDH5UJ8re7KNnq
	 yZ+Lsufo+Lz7GOYgG2yp/q7mTPG5iUTVi7+yTVZj4Or6XW5OiHixvU3KXeCCHJy6LzAqM
	 1iBP6H4BlOLX0oStaqy5GUy280A3CDld7qgBlz3s3czkD84ocdYpvPw8kpLkWOCFb4A2S
	 UzilPy5l513BmO2jzLbLoU0Uwb0dhWH1qbEY0Y7P+uJGhhR6JFoxqX/PxyWbCT5bG5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VbS7S3AR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.63
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012063.outbound.protection.outlook.com [40.107.209.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D414606A325;
	Mon,  9 Nov 2026 10:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D414606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VbS7S3AR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nrZ5+DUQfd9CFDvV9Q4xKDffiyvnQfWBBOBKGBFS/SRqd1/Ese6LwJzu+wceXtSXm83uRrH2TsVbzSftr7r0Mup1/VzhCmsaPcOPUqVMbdwrWs2J75PqO2Czn+tllYwGtkDPKz0kLPNtxSKQYFWivmAwChEuhOkm+ErsfVeUHo0hHilIJDYrbqCmQHIR2BGwY3X4MGZeq0He5z1FthcyjPKv/MxlMgIZOqFroFViD2vRe54nR+zY+vxM1b1o6d/BdsNIpE9trsmM+oKS10+jcmHmhko1GrWyqnMylmETaXTiCG4yWTlfJF8tGLRghxL0u6pMnuCTPwej+4GgaGUgbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxCE1wG/I3mMOJM+8q4VBNuNna6sL2JkhRWTAJELiTY=;
 b=D2maa3L2NEAXThWUDQb6Yi3yr88ovbxzlVzcUGZ28bEka7buSecNm2I8NzTt8uB+GLQ1hL3VioT5PvbomAD9YZt8o+bFjLXLUU/y85EiBiRqWlmuX2V2kMBzkP1F9CFkEavLqmTyQrYeTCb8dziamDVOWNg7MjBVyGit8geidP3LjajY1e30aZxe+gwZRXtO2juPOa1FS1GHJjuFTSQSktyMPnVGvIJ6oW+S/vMNX7bCYC1Wg6iUMQgfubgL5oypJ3I6lUvdPL77sV8+FErLgJdZZtMSg/jS0lDBlBVcOwEQN5srVxqGlnzDSibNUhjDv48tUwRLXyrLWlr/QIJwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxCE1wG/I3mMOJM+8q4VBNuNna6sL2JkhRWTAJELiTY=;
 b=VbS7S3ARxjOoXgzhO8Qpb5sFQZo40vXo2jd4xuUGtk/BX1bvVCgcr+GZj2dqkTXu2qXtJ3hZjaiG7vEPz69dAF2UxSEXo8roCGANlQet+ihSubKHQV8GRxWfxRzKYV7nGEOLwrJLYl/ScLERSQElMNRzR45rEpumI3ZmUAt5/5L1yPJYoAkLagcjbzdKQBfOKh1WMZ9yw7oI0FeTBdHR0Y2iGnEpyiifYDg0EiC64kcpgKz9codMzSDQuGUbQMeSDy/vXKkKcguECPSclVMTQOciTlGyUowk1u+d0FV9XV3PAUKc8Q3KO/gkJbQiS94OUNPSw0pllV2JRKZ7RfryLw==
Received: from BN9PR03CA0087.namprd03.prod.outlook.com (2603:10b6:408:fc::32)
 by AT6PR12MB026552.namprd12.prod.outlook.com (2603:10b6:170:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:44:52 +0000
Received: from BN3PEPF00022BCD.namprd03.prod.outlook.com
 (2603:10b6:408:fc:cafe::5e) by BN9PR03CA0087.outlook.office365.com
 (2603:10b6:408:fc::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 10:44:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BCD.mail.protection.outlook.com (10.167.248.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:44:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:44:37 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:44:32 -0800
Message-ID: <9113a476-91c5-44fe-9160-ff9c82f7550f@nvidia.com>
Date: Mon, 9 Nov 2026 12:44:29 +0200
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
Subject: Re: [PATCH rdma-next 21/23] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-22-yishaih@nvidia.com>
 <179408310732.994134.11296743978617194234@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310732.994134.11296743978617194234@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCD:EE_|AT6PR12MB026552:EE_
X-MS-Office365-Filtering-Correlation-Id: 36dcd3d7-f796-4d26-02e5-08df3e4e7c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|82310400026|36860700016|11063799006|4143699003|56012099006|261021121427099003|261021135927099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	QSVp12MjEHcRzcw1tLV+mi7W4v6JB7PjtLKHU31OgNHdDymIlEAk7i+RtcZHK+qBFM0mvR3cZFUxaE9ZB22dcduEzFNQ6umTCDtqiunesmCinyq7pqtojovTHQ+oLcF0l0tCjwCsJFyqHGLuFvkLkvCoYQ924dkcF0PooebLJVZHOR1ohmI+2bnVGsaYrHjyX0xLuOYRb86Yv5i9WjBtdLo8J4rZ4s+Ny9kKYhUf4iPBYUV3t2RlMLm94deMaaLaMZZi7vu6w4DEIrrtjqDUTFGBva7mNasLb2c6ay49AZoYUV+9VdOR31qZ1eDo2tCMkStlrJDb7l/UAw8weuju6UkAODuCyqIn0/plaOwi2Mfy0UZ0ut3as6NauIJV+6knw/89AfoCBKtqWwFieg/Jz/fH+OqpO/3neyBKadVJcu8z5kOxs8+rKz9gyDM0b4h+kse9E/pzFwPfr4ascCGEZ6IVptoAbqhU6/6Urvvjv5lWjtAbowyXC1wenRjFch0BxMnWnVuS1U8BSCkJI37a4N/7qmYsA+V8blFo3zd3EsSrh4AjqPX9zaXlv4aZVJfd9N/wsEqQWIfY8apQIfHiEtbML/cHDo3y9NwuLxRMQB9mKmQIyS6kbQOXGsgwySHPq56RdhaPu+TzWdnBaUoqQTX6St1kMnEhu94wvYH0q/x50GX55Am4PIvuVCDepwPlFfGTAODaNxyyqqnscQiG6w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(82310400026)(36860700016)(11063799006)(4143699003)(56012099006)(261021121427099003)(261021135927099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NsH8nGrLRnoBgp6QSfS+Z8H3uxQlPIkilRYynpcp3MbJVFISTlJLlVzR8KII8WFt4/naPZ/XRL4gCG5LNuWoYrYkn5jaKoKzJC/6W2zFkzovZ/+ZCgFoVNgzGAVh8KBba1F3n0fEHaehGeRo72QJ9ECeODpqvvuny6kEeSNB7Vv7jQQ+5qLAFqCb5uwSQQemJIHDgOedQRwwmL0bhvfe/FEIdbbHmBUdL4mXmiAJj4r+drbq7uZ6kRmHXkcJk59bhjDhbgSnzmEmxLkNDpCOVJ6ZjYneXWJnYuEof2ZS86v0sNeMEhTJtJZbIJt53aClwEFy+zzOD+opDSnTcG5H1V4mahUs2qHnEQTnyPFVscIGwQAUYWlzWIa4L0lH3wNfdVfFBSPxYvzTqT9fAHwt6ftN45d6hHDHPLUWZjGdYXGye01NrXyUmGGIHjl15RsM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:44:51.6923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36dcd3d7-f796-4d26-02e5-08df3e4e7c00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT6PR12MB026552

On 07/11/2026 22:25, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] mlx5_ib_create_srq() (drivers/infiniband/hw/mlx5/srq.c) now
>    takes its SRQ size limit from MLX5_CAP_GEN_LOGSZ_U32(log_max_srq_sz).
> - [Low] The commit message does not fully match the diff.
> - [Low] When FW reports log_max_cq_sz >= 31, mlx5_ib_query_device() now
>    advertises props->max_cqe = MLX5_CAP_GEN_LOGSZ_U32(log_max_cq_sz) - 1…
> 
> --
> 
> RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
> 
> This commit replaces the open-coded 1 << cap computations of FW log_max_*
> capabilities with MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64().
> This covers the query_device, query_port, ucontext and SRQ create paths.
> It also computes max_qp_wr in 64 bits and saturates the max_res_rd_atom
> and max_total_mcast_qp_attach products at U32_MAX.
> 
>> The device, port and ucontext attributes and the SRQ size limit are
>> computed as 1 << cap from 8-bit log_max_* FW capabilities. An untrusted
>> NIC can report 31 or more, which makes the shift undefined. The same
>> applies to 1ull << log_pg_sz with a value of 64 or more.
> 
> [Severity: Low]
> This isn't a bug, but is the "8-bit log_max_*" description accurate? In
> mlx5_ifc.h several of the converted fields are narrower, for example:
> 
> 	u8         log_max_msg[0x5];
> 
> log_tag_matching_list_sz is also 5 bits wide. log_max_klm_list_size and
> log_max_ra_req_qp are 6 bits.
> 
> The diff also changes the tso_caps computation in mlx5_ib_query_device():
> 
> 	resp.tso_caps.max_tso = BIT(max_tso);
> 
> Here max_tso comes from the 5-bit Ethernet cap MLX5_CAP_ETH(max_lso_cap),
> not from a log_max_* general cap, and the commit message doesn't mention
> this change. The BIT() conversion itself looks correct.
> 
> Could the message be updated to cover this change and to fix the field
> width?

Right, will fix the commit message in V1.

> 
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index c29102260989f..ace4cdc95c9da 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
> 
> [ ... ]
> 
>> @@ -1111,29 +1112,31 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>>   	props->max_send_sge = max_sq_sg;
>>   	props->max_recv_sge = max_rq_sg;
>>   	props->max_sge_rd	   = MLX5_MAX_SGE_RD;
>> -	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
>> -	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_cq_sz)) - 1;
>> +	props->max_cq		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq);
>> +	props->max_cqe = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz) - 1;
> 
> [Severity: Low]
> If FW reports log_max_cq_sz >= 31, this advertises max_cqe as 2^31 - 1.
> Can the CQ create path actually honour that value?
> 
> mlx5_ib_create_user_cq() in cq.c rounds the requested size up and then
> checks it against INT_MAX:
> 
> 	if (entries > max_cq_entries || entries > INT_MAX)
> 		return -EINVAL;
> 
> cq_roundup_entries() is 1ULL << fls64(cqe), so any cqe in
> [2^30, 2^31 - 1] rounds up to 2^31 and gets -EINVAL. That makes the real
> maximum 2^30 - 1.
> 
> Would a consumer that sizes its CQ from attrs.max_cqe then fail to create
> the CQ? For log_max_cq_sz <= 30 the two values agree.
> 

Right, V1 will cap the advertised max_cqe at the largest CQ size the 
create path accepts.

> [ ... ]
> 
>> diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
>> index 6a4a937d97ce9..3fbb0eaf12558 100644
>> --- a/drivers/infiniband/hw/mlx5/srq.c
>> +++ b/drivers/infiniband/hw/mlx5/srq.c
>> @@ -198,7 +198,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>>   	size_t buf_size;
>>   	int err;
>>   	struct mlx5_srq_attr in = {};
>> -	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
>> +	__u32 max_srq_wqes = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz);
> 
> [Severity: Medium]
> With log_max_srq_sz >= 31 this limit now saturates at 2^31. Can the rest
> of mlx5_ib_create_srq() handle queue sizes that large?
> 
> In adversarial mode the caps filter passes log_max_srq_sz through
> unchanged (MLX5_HCA_CAP_ALLOW in caps_filter.c). A uverbs user could then
> request max_wr = 0x7fffffff, which passes the
> init_attr->attr.max_wr >= max_srq_wqes check. After that:
> 
> 	srq->msrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);
> 
> This stores 2^31 into the int max field of struct mlx5_core_srq, which
> becomes INT_MIN.
> 
> 	buf_size = srq->msrq.max * desc_size;
> 	if (buf_size < desc_size)
> 		return -EINVAL;
> 
> When msrq.max >= 2^26, this size_t product is a power of two >= 2^31. It
> passes the wrap check. However, create_srq_user() and create_srq_kernel()
> take int buf_size, so the value is truncated to 0 or INT_MIN.
> 
> On the user path the truncated value becomes the min_size passed to
> ib_umem_get_desc_check(), so a dmabuf descriptor of any size is accepted.
> 
> in.log_size = ilog2(srq->msrq.max) still describes the full queue to FW.
> mlx5_cmd_create_srq()->create_srq_cmd()->__set_srq_page_size() then calls
> get_pas_size(), which computes:
> 
> 	u32 rq_sz	  = 1 << (log_srq_size + 4 + log_rq_stride);
> 
> Here the shift count is 32 to 36. That is the same kind of undefined shift
> this commit removes.
> 
> The garbage result feeds the WARN_ON() that compares against
> ib_umem_num_dma_blocks() in __set_srq_page_size(). A local user could
> make that WARN fire, or create an SRQ whose FW-declared size doesn't match
> the pinned buffer.
> 
> Finally, init_attr->attr.max_wr = srq->msrq.max - 1 is a signed overflow
> when msrq.max is INT_MIN.
> 
> The downstream overflow could already be reached with log_max_srq_sz
> values of 26 to 30. However, the commit message notes "the limits can now
> reach 2^31" and fixes other consumers of 2^31 values.
> 
> Should the SRQ path get a tighter bound as well? For example, it could
> reject msrq.max > INT_MAX / desc_size, or keep
> log_size + 4 + wqe_shift below 32. 

Right, V1 rejects an SRQ size and a buffer size above INT_MAX, computing
the buffer size with check_mul_overflow(). This also keeps log_size + 4 
+ wqe_shift below 32.

Yishai
