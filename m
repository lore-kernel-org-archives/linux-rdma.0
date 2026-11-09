Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794240781;
	b=iHhNSG+VVFwbmFv+Z9ULoql3/oaR3/3Myu7OSSm+3jWFm7vG+r8C2lJAS69RRZIXpVJY
	 qKQEyZKc+F1Ewd+Sx2zu/9M0rpAry5fQpLFk0PViuRCJNuGADUoemIUhLpS/3xaDWn4QN
	 /en7sCsWpJEsrZ9ALjEt9zub00IhaUuoEF8HZ0oy16WItsL8JlN1SfCnxvLDRUGzNT0wM
	 9vFcYXgb/J54vCWGp38ZrYQM6GTHwqOee1vNuokCqsH5oWvH7rcls/S85Y9t8VKIZ7M3+
	 ua3oMqMuGNX/f8VTfA9BKLf8LtJY/hC4NUbJ8sGQ8zexlCV/xIE1PtkPV7fYcdKfDXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240781;
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
	bh=jM3qphLTkpA17+r030Bh6PhevSQ2x6Jbnl14FAwBRaU=;
	b=UjbjUrGhrguRR+TJBrIBevL4UFJOUpX2hpw//qDJrowHdHzlvJ4dtpXxW8plDVEAD1cp
	 a1z6ayqI46HNIqLfoptnVWnAdIEPQVmGT6rvK/h6CNcfO9eV8+gVtFvtPaoy3eXbU6mhD
	 JVR2OXPJBxKesQwqupup3Qhko6YjV6DhK35SoOTP8X1xPSWqLkm5Qr26A6TUd45lh2H/i
	 GaQy7oK1wLlrwG9KpRmFL54qOmFlfCFZxa6pl7A6jiz+VZck3mz4Tqv6VXa3RPEoZqu6U
	 j7Jm5XpWbdVz5p7ypPKsR8afvW/wzYOtiZiQIEjTNHkhiSTyzlMpn8zDcPCh1WwwYQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="jZ/CwGS8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.40
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240D3606A321;
	Mon,  9 Nov 2026 16:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 240D3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jZ/CwGS8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpZa7KOyF5KYGF//YAn72aHmBWwtFcEDjJvyjW55D1YQprXe02awr+ykRkcNFun7ctIag0lDfNWMq8hIUfFx9PJCuz0Pr4mXOQZeRFX3z+yguiF3/s78K8Ds9iWnX52hTz/nhFlp1SXReAwXDS9XBgIHGh3R6VuSYz4tipTO0Eub4zOQK/abCAhKnvQ8J5LMlrllX+jHW4FA5Mz/qhAA0+Y97NZZkcJ62bbp5dwAFHbE7NsfICecBr9xgB0O8kJNVCizAm8ErRjxIzpR0Bb36R6CbmJPv4jP2Ga2LNpL9FZC6fuQPE2ZwQ/c62KLi1RX3wKX4WSPOfBBovMQfKTtWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM3qphLTkpA17+r030Bh6PhevSQ2x6Jbnl14FAwBRaU=;
 b=uC5nSGiySM9pz55iZnDZPpZAL05pMVrYfAwhTkMX5uhO4HZk//zswJ9E63gEQ2qQc567bbSwZ5ZBemmTjlcSZBTL/x6MPaacckf6vfryjb6YgQk/kvnwhAZXU98V6G1T2x6wTeO8v6H/rhzc4PRps8mUQyxM2L8sCwt2V0uA3aCYlpjqr4AnCB6Ysx+G/pvDYUjaVXDgGm1yOLqfWbG0mWzdS15LOodOdSwpQzGZ6dtFToRLqRnOaMC7f7BT/0XiVkZPdPYynVQOLRV/DvGrZw3lp0WNjpYSOvswQ9MU3qmhT9dpR8kG7bQ9t+u3oWJouvt9L3BmUgWLpSRa6KGhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=debian.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jM3qphLTkpA17+r030Bh6PhevSQ2x6Jbnl14FAwBRaU=;
 b=jZ/CwGS8JJfnSgZoEMU/Yvx6w1yQAyHomS7bC6dzesZpfMHdWYQwQeyLUDyz23SN8Aycprk3yvK6LfNY/BLtjwhG+nWD8k5CF1Jf5eEcdU3GpNnvLQB28qR2DtZV903Q7QhQxAJeXe0hfFHsyWjSe2vjuCKuJlyfyDoVGbybWl7TuQqYRjcq3IOZHjET6VySsSB7CKARswdjU0CGhaYJ+OqM4pnHaZADzOt3TjCD/kqKvnfrMZa5eZUuCxvM/PRXDy3+yF/DKeEJjtuvuRoIZmb7u0WDMtpsJhLhHnmejkZJg5/j1e+zCx7yalnAWveQNcjZ9fhFIeExkZRXACrEjA==
Received: from BN0PR03CA0030.namprd03.prod.outlook.com (2603:10b6:408:e6::35)
 by IA3PR12MB899783.namprd12.prod.outlook.com (2603:10b6:208:621::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 16:12:56 +0000
Received: from LV8PEPF0000005D.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::1f) by BN0PR03CA0030.outlook.office365.com
 (2603:10b6:408:e6::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 16:12:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 LV8PEPF0000005D.mail.protection.outlook.com (10.167.245.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 16:12:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 08:12:25 -0800
Received: from [10.221.212.27] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 08:12:21 -0800
Message-ID: <d8219aba-5e77-4d99-9725-3ae899c98cf0@nvidia.com>
Date: Mon, 9 Nov 2026 18:12:18 +0200
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
Subject: Re: [PATCH RFC 1/2] net/mlx5: Submit blocking commands from the
 caller's context
To: Breno Leitao <leitao@debian.org>, Saeed Mahameed <saeedm@nvidia.com>,
	"Leon Romanovsky" <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>
References: <20261030-mlx5-cmd-wq-v1-0-1458b2aed637@debian.org>
 <20261030-mlx5-cmd-wq-v1-1-1458b2aed637@debian.org>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261030-mlx5-cmd-wq-v1-1-1458b2aed637@debian.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005D:EE_|IA3PR12MB899783:EE_
X-MS-Office365-Filtering-Correlation-Id: 3913a73e-1648-438e-7b22-08df3e7c5041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|22082099003|18002099003|6133799003|10067099003|3023799007|921020|4143699003|11063799006|5023799004|261028144727099003|261102123227099003|261026140227099003|261022105027099003|261021121427099003|56012099006|261021123027099003|261009223027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	CXdFdxTuSw5dVHVg0Owu+/nOp+CLliR6WX39rsbfG8XMAZmFcgbruBWpy2BtAvGCuIwCBam8i5XLOeENl38jig3sFSZi5lv1oVWzVTyKjEzsqVKb9a8LO5h0+WlCTYyh9H+RJ6EulKnmUaaxO7oIr3QF0u51cXmbUz9YsJCAJ0mU0NJ3UsxcmMESP6S5Pm3NuU00uy/11XYjkxCUKGmhdAx7Xag9e5pUS/S0H+U5Yd5TgH6DktAIR16jVv2/7KA81twZ1J3PDUgF7TX9YvdSQZmL5oMYy8OtuFLh56pm9bWdYSP2G9cq4MsZRtPcUjXn6whUGF+QPniM72Pwcd1m2Lzlmbvey+c/FD0sGgth1ndSIi0T6MXZyyAujhGZXSl5qQ3QkXEzz9wDOLUW+ZjTA4BbzCkAr+5pKgJjNuiQ3kke5R27VKIMFqCtF9n7GPqLlaeHuAnNFqj3if2IcOglTy1PYppZUtlolbeLe/zmYG0kHTi1kWsFawt6+gldXLnMV6LqqccmQd3T09a+3oT+9IQX0MmEmVFTLsVIfWeTfbrFmo3/Zq+7rq5NJZaQU6gjc/YUb+ccln+FsphRayvMss6X0y42F2YQQ5FPFbIwKWWdk3/pScrYo87dDSEshF8GLnlDj9kWBlEaUBSHxxsUzZFdV0r2q3N8mYUXAPSnID7soRmsdyKp9OBrjvtGSis6sn0hCL6Ndsm2i4z0tDnYR4hygfN94NBzH/COBpDXo/PHz8pEWR+omNrSOPpm505O
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(10067099003)(3023799007)(921020)(4143699003)(11063799006)(5023799004)(261028144727099003)(261102123227099003)(261026140227099003)(261022105027099003)(261021121427099003)(56012099006)(261021123027099003)(261009223027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yk4GYGTjIQdGK8ICoSRYh95sB+KrtjmlJt8WhaXnxtzHA2LI9rHe4+SQLVKX38/ZjJrfPG80RJLeWKR6DanbYt+S9VivM2L7IBl1AwN1ZzYm+iRKQzqGRDfySoLyHlXo6HYcjHMI+cWDl1OpUDDYNBBwazGRcZZJxuYCGVZldq76TsNINaRLuDaHHrybnA/fRH+bcTVlz8KEThT4aNyJUf6wc5tHzAD4NbtGB1C4QukLhJD3tgOH+3A6UxNXv7XMEarK+7ak4wRiu4vIWj/wTXvRxE7nEgGflvoDbH8C7LZe2ERwyJKVsVejj4+SrKqwKleI+0HRyN2ZiAwWVsB4rZlTwPtk2dni4bche1ibAy/TriNX2KzkJ44WcjAeUgc+D4x084C5RZAvV9Ecy7vxDW+YWpnR4262hZjt8RCtGWrhn/uUd8iz/B64vu6lWKX6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 16:12:55.1564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3913a73e-1648-438e-7b22-08df3e7c5041
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR12MB899783



On 10/30/2026 6:31 PM, Breno Leitao wrote:
> mlx5_cmd_invoke() queues every command that is not a page-queue command
> on the ordered cmd->wq, and a blocking caller then sleeps in wait_func()
> until the command completes. The work item only takes a command slot,
> writes the descriptor and rings the doorbell, so each blocking command
> pays for a queue_work(), a worker wakeup and a context switch while its
> caller sits idle.
> 
> All ordered workqueues share one unbound worker pool, so the command
> work items of every mlx5 function also contend on a single pool->lock.
> On an arm64 host with a dozen mlx5 functions in switchdev mode, where
> monitoring daemons read /proc/net/dev, lock contention profiling put
> 36% of the pool->lock wait in queue_work() called from cmd_exec(), and
> the rest in the workers running the command and stats work items.
> 
> Page-queue commands already call cmd_work_handler() directly. Do the
> same for every command without a callback. Callback commands keep using
> the workqueue, since mlx5_cmd_exec_cb() must not block.
> 
> Firmware runs up to max_reg_cmds commands concurrently, so callers could
> not rely on the submission order, and the slot semaphore still serves
> its waiters in FIFO order.
> 
> With 32 parallel ethtool -S loops on a ConnectX-4 Lx, this removes all
> 46.7k mlx5_cmd work items of the run and cuts kworker context switches
> from 50.7k to 3.9k.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 84583dc5eb1c05..988518155582a4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -1301,7 +1301,8 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>   
>   	INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
>   	INIT_WORK(&ent->work, cmd_work_handler);
> -	if (page_queue) {
> +	/* A blocking caller waits for the command anyway, submit it inline */
> +	if (page_queue || !callback) {
>   		cmd_work_handler(&ent->work);
>   	} else if (!queue_work(cmd->wq, &ent->work)) {

Thanks for the RFC.
My main concern with the approach is fairness for callback commands.
They still go through the ordered cmd->wq, so only one of them at a
time waits on cmd->vars.sem, behind every blocking caller that now
queues there directly. A callback command queued before a burst of
blocking commands used to be submitted first. Now the whole burst can
be served ahead of it. I don't think we should go this way while
callback commands are left behind like that.


>   		mlx5_core_warn(dev, "failed to queue work\n");
> 

