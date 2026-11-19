Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795083491;
	b=w0VFQmqLJNnKX2C0TCKPEX5RazU4IMwI0uAfDXVVetXttzPRTJEuwHfvnYbCwHPruSlp
	 S0c4wmdalETOvR0AQyvH8s7bp8ohRYURiBNh5J68CIYt0ieL9mxFQg1VjNZ3QWXJHyr1o
	 RbnVEtmt0kPQLxgfXc9c1xPj0ZgeVgMuiR4YyJmHFPJhGQsptARCXqncUGHUMBUmKchlH
	 Z/RairT6KAW9msENWpTBqYI5GPz2L5e8K5m2SYW4aJtqjRfJW6a3jQrD0dzJEnA/dC7iD
	 C33zuqztEujLARcfYXNuIEhftjejFq7TsbTQjnSHcyxJtHfx/ow2dR9gGHfmiXYKPtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083491;
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
	bh=s/kBY09noxuY6nnX1Y/OYMEMAca+yIc17McA3QedCnM=;
	b=lgspUzns+21I9QRLgfKVmrP5kxa2/nWMYPp7UyvuLv/zZZ1RO8EDqV42qbl8c7MWn7SN
	 PnY2KOUt/slKa6WrLtlNiyy+s8DgzwELglQqDspbnr5XlXG1WT7OEztJXduhkYE+17D0M
	 xcF0l2nYAZitfjJlcT5hdBo/lOBIJBBOmOPt5qNaPrbYjWokaamt6h5j4M2yhXyCrFCjr
	 XL4TlTrbytuXolh4eVjli7Watp/GQ8oP/eonnT9X7PNmSkYUhIsg/D5SyJ61JMcl7tgtj
	 UqgbwpuwzQvo1PiavLzmGGLzOcSrqIFnBX0P6DP2DZoxnn/lloBmUOG9pXRcQ9qIhAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hQsJ1zMu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.65
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012065.outbound.protection.outlook.com [52.101.53.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96A1606A324
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E96A1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hQsJ1zMu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c57amrct+ph96JGrAvnMO7vr/AaAYSc0hBL47mHZducY6/R3Pa/bin9Lap/RryxY/ELQfKuwNDSFPa+ukC9G/kAYPX/EBDZLnpWYTa1HpspxNbL7DxM7Zn6FmlISi6I1v52G/cG/q+MuXMElfwQS9q4LgzlLUxwhtgt7YFyxLc5fiYQHgo6aFvc8pPHjkHbbl2oUNRn/tTj0crNMt140z4ecFkF79fuSUxCtDrGtbGeYDgRQmJl32tfyufSWv/zrFjm0WDSlI7hVsH9c+sPZeTKPG1a9kQP3RLduDeZ7j068aVTMwIpKVzHC9PUBrfYl92SPnMu7DeIDT5RqVX0UBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/kBY09noxuY6nnX1Y/OYMEMAca+yIc17McA3QedCnM=;
 b=LcVOJadeZoM6mg1NOg7vaBDJv3JF2WTgdMu5rMz0guH/lGyWyxp1EXz3VjmLDkswe4TISiQhSzpNR4huELV0RyczkHWZ3k+Z50P5ed1w205tbl0qViiBStzaeTWUWyPHDDg7NaPtGjahDqdv3iqKuvBK3yn7+Cr4hI7T6+plOTY50qYsjqr/oefuJItTTP77WtwKHsV/niSr4t0DlMW7qTRDNvCfXdffri/2VK0A6/yvoBwbpZbYFkjUFTCqbtOG9EX4YSwY3zcknIoPuHoX9DNNZCK5VoEsBhRCUvSJw1YD7oF8kzJiczyaX/pkwUcWc/s4lyRuEbF+e4KMTOaWEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/kBY09noxuY6nnX1Y/OYMEMAca+yIc17McA3QedCnM=;
 b=hQsJ1zMuJNQUxQeiRTvr4fLH3aNZRvk8isJj/XFg+GR2CywCaRPjL39o6X1WubUgbL/m0UNx302RLAwoFxOX0rkmHnHFpbPlHwnyARGoW9Wwg3cayk2mtVrVrXQY1gf0bjDATyU2yWHfyEp6Ec87VRPx2WE25Z0aAeeN2H/9ZuDAUfer78jpPy8gwVZVY5foR3PfR+QfZVxKa5sYODe5BOjjgyQkETd8v1LskAs2VHxw5G7lLQwjvBoFGEQta6f5GVjPEjvGsRCPQ8fTfdxUuRyvNZbnRTTCfIXFR1reqHXcBuBwt2KyRNN8ouo4hRNWgZcOKETmaMtPETvgntY+OA==
Received: from CH5PR02CA0001.namprd02.prod.outlook.com (2603:10b6:610:1ed::17)
 by MN6PR12MB8541.namprd12.prod.outlook.com (2603:10b6:208:47a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Thu, 19 Nov
 2026 10:18:06 +0000
Received: from BN3PEPF00022BC5.namprd05.prod.outlook.com
 (2603:10b6:610:1ed:cafe::82) by CH5PR02CA0001.outlook.office365.com
 (2603:10b6:610:1ed::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 19
 Nov 2026 10:18:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC5.mail.protection.outlook.com (10.167.248.217) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 10:18:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 02:17:48 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 02:17:47 -0800
Message-ID: <86bf6a16-41af-4c4f-bec1-877ebac6aef4@nvidia.com>
Date: Thu, 19 Nov 2026 12:17:40 +0200
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
Subject: Re: [PATCH V2 rdma-next 12/21] RDMA/mlx5: Verify UMR CQ polling
 against a hostile NIC
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-13-yishaih@nvidia.com>
 <sashiko-outbox-221613@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-221613@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC5:EE_|MN6PR12MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: b346b5d3-9517-400f-a257-08df4626673a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|6133799003|18002099003|22082099003|261009223027099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261021135927099003|261028144727099003|261102123227099003|261021121427099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	E5gSz7XY2XtLvSvVcdTf1HP23EbTCzmDjXYw9UL2t5/2/vJLrBIJEX8fCqrDEVleItdpIQhSNQjucjcSoBn1TqBep9VuiN5DRTOnOFXf/dYfC7xsqwhCvzE42qFlM8mKr0bGmyPXgObSvT7NgycfMF4aIPAYDZETc8YAZVU1KREscDgRFnPZ7vryx/qxtzczyT3LqeJvsFkA8pU3P7+e9r0zIq4PcVg0sN6aEdn1pcl7iMdDVox/GfsBISFeAmhxDzsfsSm13XVmVRCqjvsD0T/t+QIzwcsh2GcEHPAUw727bQNtdcPeUuHrImk4KnTD3TC4Ye8GcPEN/pHEY6ongrOWDTIdtDgo40xrb85sMHntKtmFr9Gb7g9lX0gfPLhGVp8UhCaGJ/gWnES0zvXOwt2BUcqC9qCHadED+1KfUj1HZu7PnLL+WNH3JL/gOCLERbQkVNYuBvzkPvlazD51q+EIUUG6TNxJLYCgu/oRwVdMZL4ro4aXgm4D7s5Fb073ru+48n6Y2hfIfZiJ0aopXN+7qIC8o3Bk2dCyGCTg3XJX0sc67vwWe/CRjDRoGqCPn7hANhWMRX8jvNLXGjSQKULEfMGQIF6WHlEIpQV5gAllG6weJV9/rjn+GcsXg3XQVAuT8umcaYNNORzrZrfxIJfExInsskKxfx8H28SiJHsa4WN1L54Udnf0wDZESyPrLmuyoTctSPQ+i9tOpA42Pg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261021135927099003)(261028144727099003)(261102123227099003)(261021121427099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YyR7HhWhuOsgXkkmHtEGD/T9IoTq4sGHY+rsd/dLgQnwDAAyVkYT+f804o3iv7+m7feP0q2swXmvuNlbAtRXnuEo8CJPyyHJwv/DDrE8+dKSBbrjAhd4Gz+ZgVpVZvJCUegEdhXLyRyUwuv3c7OmIOl4x+u5CJRNlF6oAWgrzD9WqgyeyWTEdLpiZ2hW+3K3hWLLD1XnThoqN0qNS6azK6Xf85cH7oKHi81YAif/bS3iyZ+bJuWCBvGXNCbalcm8K6lR9UgGFu24trHDSfc7nWS3RGH+FWMWdaqeZb3zVURtzPNuA4RMzH1kCoEtroGZ4VDG+N9qQOJYDLC2H6cbPaGncTLHKxlp30ClZwGRXEXkXQ9/Kb3dCgtsLvTa/3aVxNcKHOmwUQG0ODlU5PUcWW9mQK4DEAzm2JRswoCs5sDqYEfKPz56+pHfxjGZuLqj
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 10:18:06.2803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b346b5d3-9517-400f-a257-08df4626673a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8541

On 18/11/2026 19:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] RDMA/mlx5: incomplete umrc->state checks in
>    mlx5_ib_poll_one_umr()
> - [High] RDMA/mlx5: deadlock and lost flush on forged CQE in
>    mlx5_ib_poll_one_umr()
> - [Medium] RDMA/mlx5: CQ re-arm loop in mlx5_ib_arm_cq() when umr_verify
>    is false
> --
> 
> commit d8d114091f7d4e4fa6dc6263146eaffadede67be
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
> 
> This commit adds a dedicated UMR CQ poller for adversarial mode that
> validates CQEs against a shadow FIFO of posted UMR requests and triggers
> forced health recovery if a forged CQE is detected.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 2581a7693585b..a5197318d96f8 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
> 
> [ ... ]
> 
>> @@ -608,6 +609,190 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
>> +static int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct ib_wc *wc)
>> +{
> 
> [ ... ]
> 
>> +	if (opcode == MLX5_CQE_REQ) {
>> +		wc->status = IB_WC_SUCCESS;
>> +	} else {
>> +		/* Copy the CQE, so its syndrome is read once */
>> +		err_cqe = *(struct mlx5_err_cqe *)cqe64;
>> +		mlx5_handle_error_cqe(dev, &err_cqe, wc);
>> +		/*
>> +		 * A real failure during a recovery is forged, the QP
>> +		 * only flushes.
>> +		 */
>> +		if (wc->status != IB_WC_WR_FLUSH_ERR &&
>> +		    cmpxchg(&umrc->state, MLX5_UMR_STATE_ACTIVE,
>> +			    MLX5_UMR_STATE_RECOVER) != MLX5_UMR_STATE_ACTIVE) {
>> +			mlx5_ib_err(dev,
>> +				    "UMR error CQE status %d in state %d, possible NIC forgery\n",
>> +				    wc->status, READ_ONCE(umrc->state));
>> +			goto forged_cqe;
>> +		}
>> +	}
> 
> [Severity: High]
> Should mlx5_ib_poll_one_umr() also verify umrc->state for IB_WC_WR_FLUSH_ERR
> and MLX5_CQE_REQ completions?
> 
> When wc->status is IB_WC_WR_FLUSH_ERR, umrc->state is not checked.  If a
> hostile NIC reports MLX5_CQE_SYNDROME_WR_FLUSH_ERR while umrc->state is
> MLX5_UMR_STATE_ACTIVE, mlx5_ib_poll_one_umr() accepts the CQE without
> changing umrc->state.  The waiter in mlx5r_umr_post_send_wait() then sees
> IB_WC_WR_FLUSH_ERR, loops around while umrc->state is still
> MLX5_UMR_STATE_ACTIVE, and immediately reposts the WQE without sleeping or
> running recovery, allowing repeated flush CQEs to trap the thread in an
> unkillable infinite loop.

Each repost waits in wait_for_completion() for its CQE, so the loop runs 
only as fast as the NIC returns flush CQEs. A hostile NIC can cause the 
same load by flooding any EQ with events, so this is a DoS, not a CPU
spin. It can also hang the waiter by not returning a CQE at all. This
is out of scope for this series.

> 
> Conversely, once a non-flush error has moved the QP to error and umrc->state
> to MLX5_UMR_STATE_RECOVER, subsequent in-flight WQEs can only flush until
> mlx5r_umr_recover() resets the QP, but the MLX5_CQE_REQ branch accepts
> completions as IB_WC_SUCCESS without checking that umrc->state is
> MLX5_UMR_STATE_ACTIVE.

A NIC can report a false success in any state, so checking the state 
doesn't add protection.

> [Severity: High]
> Can deferring waiter completion to mlx5_trigger_health_work_force() deadlock
> on dev->intf_state_mutex or lose the software flush completion?

The deadlock needs a forged CQE while a UMR is pending during unload, a 
rare timing that the NIC doesn't fully control. The same deadlock can
happen today, when the firmware hits a fatal error while a UMR is
pending during unload, as the fatal report work also takes intf_state_mutex.

The software flush, which completes the pending UMR WRs once the device
is in error, can also be lost in rare cases, e.g. during remove, where
the health work is no longer queued. This can happen today as well,
when the firmware hits a fatal error during remove.

In all these cases the outcome is a hung UMR waiter, which a hostile
NIC can cause anyway by not returning a CQE at all. This is out of
scope for this series.

> [Severity: Medium]
> Can returning 0 when cq->umr_verify is false cause an interrupt and softirq
> re-arm storm via mlx5_ib_arm_cq()?
> 

Only a hostile NIC can leave a CQE there, and it's short lived:
- After a forged CQE, the forced health recovery tears down the device.
- A CQE written during UMR init stays in the CQ only until umr_verify is
   set, once the UMR QP is ready. The next poll then checks it against 
the posted UMR WRs, as for any CQE.
- After polling stops, the CQ is destroyed right after.

Again, this is a DoS, which is out of scope for this series.

Yishai
