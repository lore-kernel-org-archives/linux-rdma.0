Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E6053B35D;
	Tue, 22 Sep 2026 11:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076164; cv=fail; b=QglKasVTgRScd4Kl7iBmTB/Q16AB4GZnBhnmY8duu8oByDuURVMAgjZPFuv2nD0FQ7NPj7E1q+t0Se1drSr02zeJysjC/QKrINI3qYU3sBz9z09ctswcn+N/BoWnjyDLxBwlUMS79syWt7mMzpmVZdO59n4BqzOYlX4vwhNajSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076164; c=relaxed/simple;
	bh=1BJsnym189FlxZwZO6CA7At8vijJ5yxhl2obUHQsKGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=odQwzp6sPIUdXpt0pCygqs2IRN1v3AyNa+XGzoxob0YpwAkoL+zEBzvo4Wjf8/xctmk6QJhqD6gAKqqDLLylMiadDNmepPd24Uy41UHcLMBuAGNcqz7D4OzmFbJfDsdY/64mr6XNhr7Man2xwn5fQK06AWpeBgqxrt2w4BolaCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YF0QvWbz; arc=fail smtp.client-ip=52.101.48.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YF0QvWbz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qt1kmBHg77MY0LtDMBkuVPnVT4jbOkNxD8odjZHvnxQ7ftOGKBz3ulvtqWCExBuvfAzdpWFjf8kfvt0J6dDQEUHFeKY/C/BzSRke6xRlhhLJinX4GofwVYwn+sxjHxkjGTgtUWd2mdszde53/9onAGXW5tusuSiYObOGWyPy/t33Fo641s34Jx2awAgzt33LtLvAb3Mp4HHuAty80KrpAxZaSD7xYTtVh3yglzJAdjuaPh/gmEDzptGYvmeUNJT0O82CggU/A7+vsHt/ZTNZgISU7wvoZFuMAO7l/IWQ3g15OfM7aRDR3YWKhWw/Qoqb3XUp8Eg8g0JsOYbidgmhKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqsfQbyVL7QFXGPfVp/D7Qhxuiy4jjhNnAlyRVaagWU=;
 b=O65syPVuhMkI7e5TjvEDlc/SNJlD3YbbVShfSFgAsur48JmtTr19TsjSEElEaWQF8q6HclVWTWqkicaYI/frPz5Sl1HlE7SdtbL2Yfc1G8oFv9p8Uvi4kUqUC/U86XxZ/LE8+5HKsAMofXXLGmnkybmT0kQgz6IdEEkLEUCNGMThicnTYzYQyg9zCXtOst6ozqt1IIkOu+0q1Go9nt/vIv2o7ebSe8O79ypkNX3pMGJY6USnBZeQNQwggNLDfa4lNFzzOF+GUaAuLijxmhLYc/3uzZC/riy+i2NKOXyZDkZxQMHQLWDzjekZAlOsNcSj4PKCpgOeIToWRNOXt2pSNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=meta.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqsfQbyVL7QFXGPfVp/D7Qhxuiy4jjhNnAlyRVaagWU=;
 b=YF0QvWbzjc5Vbgj1YCIErGpuDZrcFnRMfblZ2i58s+fvXcrYKSb5S/0JmtiV/cAySM5HNPA3OhrktWLdJG3WZ+EXaLmX39/gJILT5NxgR2ysAK2nOOXcVyuRLrov/62DKMLewDIFY64k8o5a8ENzWZ/AgqD7zy3glrmHy9ZLHYc0TnpTXX+8Qtvipzr9ij8OScP6tBOtBoHIy15t0km/F3GgEDQRMAeh+RYI7AtJhgHQeCJFLoMBcmQafWoHE0GhWNNmjitCian3gwF2BqzpeRA2KWy3pzL5sjyzBQH0iS1RiC623zofDA3Fba/Pjicq8pZmoEx8n7ND1Xp1XanXiw==
Received: from BN9PR03CA0124.namprd03.prod.outlook.com (2603:10b6:408:fe::9)
 by PH7PR12MB5904.namprd12.prod.outlook.com (2603:10b6:510:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 11:22:22 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:408:fe:cafe::49) by BN9PR03CA0124.outlook.office365.com
 (2603:10b6:408:fe::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.13 via Frontend Transport; Tue,
 22 Sep 2026 11:22:21 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.0 via Frontend Transport; Tue, 22 Sep 2026 11:22:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:21:57 -0700
Received: from [10.125.206.54] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:21:52 -0700
Message-ID: <94a4632c-0733-4793-a3c1-c66ab263b312@nvidia.com>
Date: Tue, 22 Sep 2026 14:21:50 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] net/mlx5: Bound the command interface drain so
 teardown cannot hang
To: <dcostantino@meta.com>
CC: <saeedm@nvidia.com>, <leon@kernel.org>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<eranbe@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20260915225941.554568-2-dcostantino@meta.com>
 <178986129510.22033.3641334936353721588@kernel.org>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <178986129510.22033.3641334936353721588@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|PH7PR12MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d9d2d7a-5cb7-4812-91a7-08df189bc51e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|23010399003|36860700016|5023799004|10067099003|11063799006|3023799007|6133799003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yAkIoS2dxYQsf3J5tZlq/S7HsBGO5VsTRGkTF6zJLnQQv4zhyNPxY32eSiEhuFlhLbJuXTdwutxauuX1Mr8F9oXSNqd6f7SAzut2tTWmh8e21oBrUexUyBTF0cj3DwhIFYiF84XcyhT0O5W8pi6eFgk8NUMg6b70vsLjFWn4Jv11jNseeM+aYX4Y9RpAdkc9nxn6XF+Ept4FHrFu8JmGEfDUMEbuqjAt56odYgfYXT8erNmK5Iab6310ZWKLeyf280BIVdngclegZrS5i2Zrcu+2G6p9YvdQnMMN/Mv30wsBjMyJOpIWWWXdM3hDDoTfRFTEBY7G0Qjol9tHcw5fjj/pb7Cey0FtBu+B5swkQSEGj7fzS+cxKE7QtaHMqxbNjrZ4BM4MiYE7+f6/LGcq6UQx44MCZLZ5jCKLlMwjGkCsaYWwq0TwT+jAkZnUvlViXqTh3fcAEevhfkIJ7o5c/+6geFg+mQfb9U2V0TDopAWBViVPo0UOAle3VxzI0SW2c6cOKVZCNvq0GYNmgyCLROCfwev+PkfUs8MXWKxjslZZt8n2lYRezsoc0O0Jaq1X3ivHyi5rZiORazbGp6GEGyREZ//lXGG1905b3Iktse6YMqu33GXxvKVPgZSVEvNmraLVUEmcOA94hCLeDALPGbNoQtwqYhVVLVDP+foCI5eOGUcB9Jer3HNpveJzzW7bM6vSJbpRKryJBpFVpmh35w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(23010399003)(36860700016)(5023799004)(10067099003)(11063799006)(3023799007)(6133799003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9sAB0tmPtLJKZQ2nKWTSpfT+GCRV5JoF1psKkuAPzwXnuvhd44Z05+M7++7yeA/rWvwkbKGRon86RKqb4y0to4+4MYHcZFZgaV3jzfY/gOl+q/JIooERm6dg28xKay49cnotFQpGkryvjZNEFG/wPz8R7d1h28xDn6g5zXQot+nyIhx3YvFb331uaHMOj5gcekW5W7xOoYtoII/KJ60uhQ7UjwU5jnQPEJ0RBgMcNfzsXxKpjJfF7MtI1QIoPlc82970tmtIp3lU+qJY8r1Xpl81aJRIAiejU98eTACG2J2xGfnshgFX+nj9jRcXgOJyE0efb9iRp2WhYPD+xixFy4CDhrTvSpzDz7j1BrWKVXA2XChpcgGocdoyYXZnvbZpQRAEZTWeBK/7TZBh9Z4tuRoCUweHnhwD7VIYqwyLoww+q/UEGrtPL0206L6y0NLW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 11:22:21.4246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9d2d7a-5cb7-4812-91a7-08df189bc51e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5904



On 9/20/2026 2:41 AM, netdev-bot+sashiko@kernel.org wrote:
> 
> Thank you for your contribution! Sashiko AI review found 8 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 3 · Medium: 5 · Low: 0
> 
> - [High] mlx5_cmd_change_mod() writes dev->cmd.mode unconditionally
>    (cmd.c:1732) even when cmd_sem_down_all() has just reported that the…
> - [High] With the drain bounded, teardown now proceeds while firmware
>    still owns command-interface DMA, and two frees on that path are not…
> - [High] The partial-drain path lets a genuinely live command remain in
>    flight when destroy_async_eqs() proceeds to destroy the cmd EQ, which…
> - [Medium] Commit message contradicts the code (and the code's own
>    comment) for mlx5_cmd_allowed_opcode().
> - [Medium] mlx5_cmd_allowed_opcode() can now silently decline to apply a
>    narrowing request (cmd.c:1717-1721) but still returns void, and…
> - [Medium] In cmd_sem_down_all() the page-queue semaphore is never even
>    attempted once the register-slot loop exhausts the shared deadline,…
> - [Medium] cmd_sem_down_all() budgets a single command timeout for up to
>    max_reg_cmds + 1 sequential semaphore acquisitions (one `end` computed…
> - [Medium] mlx5_cmd_allowed_opcode() writes cmd->allowed_opcode =
>    CMD_ALLOWED_OPCODE_ALL unconditionally on the failed-drain path, on…
> 
> --
> 
> net/mlx5: Bound the command interface drain so teardown cannot hang
> 
> This replaces the unbounded down() loops in mlx5_cmd_allowed_opcode() and
> mlx5_cmd_change_mod() with a shared helper, cmd_sem_down_all(), that bounds
> each acquisition by the command timeout and warns instead of blocking when
> the interface does not drain.  A matching cmd_sem_up_all() releases only
> what was acquired.
> 
> A few questions about the changelog and the new code below.
> 
>>From the changelog:
> 
>> Bound the wait by the command timeout, which is the longest a command that
>> is merely in flight can legitimately take, and update the field without a
>> full drain if it expires.
> 
> and
> 
>> Failing to drain is worth a warning but not a hang: the entries still
>> holding units have already timed out, so they are the least likely to be
>> disturbed by the update, and the alternative is an unrecoverable teardown.
> 
> [Severity: Medium]
> Does the code match this description for mlx5_cmd_allowed_opcode()?
> 
> For any opcode other than CMD_ALLOWED_OPCODE_ALL the field is not updated
> when the drain expires, only a warning is printed, so the narrowing
> requested by create_async_eqs() (MLX5_CMD_OP_CREATE_EQ) and
> destroy_async_eqs() (MLX5_CMD_OP_DESTROY_EQ) is dropped rather than
> applied.
> 
> The in-code comment added by the same hunk argues the opposite safety model
> from the changelog, namely that updating without a drain would hand
> firmware-owned mailboxes back to dev->cmd.pool.
> 
> Meanwhile mlx5_cmd_change_mod() does write dev->cmd.mode unconditionally
> after a failed drain, so the two callers behave differently on the timeout
> path.
> 
> Could the changelog describe that asymmetry, and note that a
> mlx5_cmd_allowed_opcode() call can now become a no-op?  This matters for
> the stable backport this is tagged for.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> index 84583dc5eb1c0..571ed540957b1 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> @@ -1656,36 +1656,81 @@ static void create_debugfs_files(struct mlx5_core_dev *dev)
>>        debugfs_create_file("run", 0200, dbg->dbg_root, dev, &fops);
>>   }
>>
>> -void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
>> +/* Drain the command interface so that cmd->allowed_opcode and cmd->mode can be
>> + * updated without an in flight command straddling the change.  A command that
>> + * timed out keeps its index, and with it its semaphore unit, until firmware
>> + * completes it - which may never happen - so bound the wait by the command
>> + * timeout instead of blocking forever.  Returns the number of cmd->vars.sem
>> + * units taken, and reports separately whether the page queue unit was taken;
>> + * both have to be handed back by cmd_sem_up_all().
>> + */
>> +static int cmd_sem_down_all(struct mlx5_core_dev *dev, bool *pages_sem)
>>   {
>> +     unsigned long end = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, CMD));
> 
> [Severity: Medium]
> Is one command timeout enough budget for max_reg_cmds + 1 sequential
> acquisitions?  A single deadline is computed here and shared by every
> down_timeout() below.
> 
> mlx5_tout_ms(dev, CMD) is also the per-command bound used by
> cmd_work_handler() and wait_func(), so a device with no stalled command at
> all can fail this drain: a command posted shortly after the drain started
> may legitimately still be in flight when the shared deadline expires.
> 
> Doesn't that make the degraded paths reachable in normal operation, and
> contradict the changelog claim that "the entries still holding units have
> already timed out"?  Would a per-acquisition deadline, or a budget scaled
> by the slot count, bound the wait without failing on a busy but healthy
> interface?
> 
>>        struct mlx5_cmd *cmd = &dev->cmd;
>> +     long left;
>>        int i;
>>
>> -     for (i = 0; i < cmd->vars.max_reg_cmds; i++)
>> -             down(&cmd->vars.sem);
>> -     down(&cmd->vars.pages_sem);
>> +     for (i = 0; i < cmd->vars.max_reg_cmds; i++) {
>> +             left = end - jiffies;
>> +             if (left <= 0 || down_timeout(&cmd->vars.sem, left))
>> +                     break;
>> +     }
> 
> [Severity: High]
> Can returning here without a full drain let a genuinely live command
> coexist with destruction of the command EQ, and turn into a read of freed
> DMA memory?

Right, also the other comments on mode changing and continue without 
full drain.

When a command times out, that's a failure - but if it never gets an 
answer from FW at all, that's much worse, and it is a bad FW, which is 
something we don't treat in the code, part to health area. I understand 
from the commit message that you actually reproduce by swallowing 
firmware completions with a kprobe. That said, I do see that we can hang 
on health path too (mlx5_cmd_flush), let me take that in a separate patch.

As for the memory issue in the other patch (patch 2), I see we need to 
fix this issue. Once patch 1 is dropped you can't have the race 
complained by Sashiko on patch 2 and few other comments will be solved, 
while others should be treated (excluding the pre-existing). Then, as we 
don't get to mlx5_cmd_disable without full drain, you can simplify the 
fix. Also as Leon wrote please trim the commit message substantially and 
drop most of the inline documentation, code comments only where the code 
can't speak for itself.

> 
> If such a command's waiter took the events branch in wait_func() (it read
> cmd->mode before the flip), it expires and calls:
> 
>    wait_func_handle_exec_timeout()
>      mlx5_cmd_eq_recover()
>        mlx5_eq_async_int(&eq->irq_nb, ASYNC_EQ_RECOVER, NULL)
>          next_eqe_sw(eq)          /* walks eq->frag_buf */
> 
> while the teardown thread runs:
> 
>    destroy_async_eqs()
>      cleanup_async_eq(dev, &table->cmd_eq, "cmd")
>        destroy_async_eq()
>          destroy_unmap_eq()
>            mlx5_frag_buf_free(dev, &eq->frag_buf);
> 
> mlx5_cmd_eq_recover() uses &dev->priv.eq_table->cmd_eq unconditionally and
> serializes only on eq_async->lock, which destroy_unmap_eq() does not take.
> The garbage read out of the freed ring is then dispatched through
> atomic_notifier_call_chain(&eqt->nh[eqe->type], ...), so a bogus
> MLX5_EVENT_TYPE_CMD could reach mlx5_cmd_comp_handler().
> 
> cb_timeout_handler() reaches mlx5_cmd_eq_recover() the same way for
> asynchronous commands, and teardown does not flush that delayed work
> before destroying the EQ.
> 
> Before this patch the unbounded drain guaranteed no command was in flight
> past the update, so neither entry point could run concurrently with cmd EQ
> destruction.  The follow-up patch in the series does not address this
> either, since its cancel_delayed_work_sync() runs later, in
> mlx5_cmd_disable(), after the EQs are gone.
> 
>>
>> -     cmd->allowed_opcode = opcode;
>> +     left = end - jiffies;
>> +     *pages_sem = left > 0 && !down_timeout(&cmd->vars.pages_sem, left);
> 
> [Severity: Medium]
> Is this pages_sem attempt reachable at all after the loop above breaks?
> 
> down_timeout() only returns non-zero once it has consumed the whole
> remaining timeout (___down_common() returns -ETIME after schedule_timeout()
> has expired), so on the break path jiffies has already reached end and the
> recomputed left is <= 0.
> 
> That makes *pages_sem unconditionally false whenever a register slot timed
> out: cmd->vars.pages_sem is never touched even if the page queue slot was
> completely idle, and mlx5_cmd_change_mod() then flips dev->cmd.mode with
> the page queue not drained.
> 
>>
>> -     up(&cmd->vars.pages_sem);
>> -     for (i = 0; i < cmd->vars.max_reg_cmds; i++)
>> +     if (i < cmd->vars.max_reg_cmds)
>> +             mlx5_core_warn(dev, "command interface did not drain, %d of %d slots still busy\n",
>> +                            cmd->vars.max_reg_cmds - i, cmd->vars.max_reg_cmds);
>> +     if (!*pages_sem)
>> +             mlx5_core_warn(dev, "command interface did not drain, page queue slot still busy\n");
> 
> [Severity: Medium]
> Following on from the above, does this second warning misattribute the
> failure?  Given left is provably <= 0 after the loop breaks, "page queue
> slot still busy" is printed whenever a register slot timed out, even
> though pages_sem was never contended and never even sampled.
> 
> [Severity: High]
> With the drain now warning and continuing, does teardown reach two frees
> that are not gated on firmware being finished with the memory?
> 
> destroy_async_eqs() proceeds to cleanup_async_eq(dev, &table->cmd_eq),
> and with the register slots stalled the DESTROY_EQ command fails
> (-ETIMEDOUT, -EAGAIN from mlx5_cmd_all_stalled(), or -ENXIO), yet
> destroy_unmap_eq() frees the buffer anyway:
> 
>    err = mlx5_cmd_destroy_eq(dev, eq->eqn);
>    if (err)
>            mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
>                           eq->eqn);
> 
>    mlx5_frag_buf_free(dev, &eq->frag_buf);
> 
> so firmware is left with a live EQ programmed at DMA addresses that have
> just been released.
> 
> Teardown then continues into mlx5_cmd_disable() -> free_cmd_page(), which
> dma_free_coherent()s cmd->cmd_alloc_buf.  That page still holds the
> mlx5_cmd_layout of every retained (timed out) entry with status_own ==
> CMD_OWNER_HW, and remove_one() has not yet disabled bus mastering.
> 
> Before this patch, teardown of a device with a stalled slot hung inside
> mlx5_cmd_allowed_opcode(), so mlx5_unload() never reached these frees with
> retained entries.
> 
> The follow-up patch in the series ("net/mlx5: Don't return firmware-owned
> command mailboxes to the DMA pool") does close the mailbox, entry-leak and
> cb_timeout_work parts of this via cmd_reclaim_stalled_ents(), but it does
> not gate destroy_unmap_eq()'s frag_buf free and keeps free_cmd_page()
> unconditional, so these two remain at the end of the series.
> 
>> +
>> +     return i;
>> +}
>> +
>> +static void cmd_sem_up_all(struct mlx5_core_dev *dev, int nr, bool pages_sem)
>> +{
>> +     struct mlx5_cmd *cmd = &dev->cmd;
>> +
>> +     if (pages_sem)
>> +             up(&cmd->vars.pages_sem);
>> +     while (nr--)
>>                up(&cmd->vars.sem);
>>   }
>>
>> -static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
>> +void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
>>   {
>>        struct mlx5_cmd *cmd = &dev->cmd;
>> -     int i;
>> +     bool pages_sem;
>> +     int nr;
>>
>> -     for (i = 0; i < cmd->vars.max_reg_cmds; i++)
>> -             down(&cmd->vars.sem);
>> -     down(&cmd->vars.pages_sem);
>> +     nr = cmd_sem_down_all(dev, &pages_sem);
>>
>> -     cmd->mode = mode;
>> +     /* Narrowing the set is only safe once the interface has drained.
>> +      * mlx5_cmd_comp_handler() reads !opcode_allowed() as "no real
>> +      * firmware completion is expected" and releases the entry, so
>> +      * narrowing while a command is still posted would hand its mailboxes
>> +      * back to dev->cmd.pool with firmware still able to write them.
>> +      * Widening back to CMD_ALLOWED_OPCODE_ALL is always safe.
>> +      */
> 
> [Severity: Medium]
> Is widening really always safe?  opcode_allowed() is evaluated twice for
> the same entry and both evaluations have to agree.
> 
> First in cmd_work_handler(), which takes a reference and then, because the
> opcode is not allowed, completes the entry without ringing the doorbell:
> 
>    cmd_ent_get(ent); /* for the _real_ FW event on completion */
>    /* Skip sending command to fw if internal error */
>    if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
>            ent->ret = -ENXIO;
>            mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
>            return;
>    }
> 
> and again in mlx5_cmd_comp_handler(), where dropping that reference is
> conditional:
> 
>    if (!forced || /* Real FW completion */
>        mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
>        !opcode_allowed(cmd, ent->op))
>            cmd_ent_put(ent);
> 
> If the unconditional widening store below lands between the two, all three
> terms are false and cmd_ent_put() is skipped for a command firmware never
> saw.  The refcount then never reaches zero, so cmd_free_index() and
> up(&cmd->vars.sem) never run and the slot, its semaphore unit, the
> mlx5_cmd_work_ent and its mailboxes are lost.
> 
> Doesn't that recreate the never-returned-unit condition this commit exists
> to fix, for the drain paths and mlx5_cmd_flush()?  Before this patch the
> store required every sem unit while cmd_work_handler() holds one for this
> entry, so the window did not exist.  The follow-up patch reclaims such
> entries at mlx5_cmd_disable(), so the loss lasts until unload rather than
> forever, but the race window itself stays open at the end of the series.
> 
>> +     if (opcode == CMD_ALLOWED_OPCODE_ALL ||
>> +         (nr == cmd->vars.max_reg_cmds && pages_sem))
>> +             cmd->allowed_opcode = opcode;
>> +     else
>> +             mlx5_core_warn(dev, "leaving command opcodes unrestricted, interface did not drain\n");
> 
> [Severity: Medium]
> Should the callers be able to see that the narrowing was declined?
> mlx5_cmd_allowed_opcode() still returns void and neither in-tree call site
> was updated.
> 
> create_async_eqs() and destroy_async_eqs() install the restriction
> precisely so that, while the command EQ is being created or destroyed, only
> MLX5_CMD_OP_CREATE_EQ / MLX5_CMD_OP_DESTROY_EQ can be posted.  That
> restriction is what makes cmd_work_handler() and cmd_exec() short-circuit
> every other opcode to -ENXIO via opcode_allowed().
> 
> After this hunk the invariant can quietly not hold, and destroy_async_eqs()
> continues into mlx5_cmd_use_polling() and cleanup_async_eq(dev,
> &table->cmd_eq) with unrelated commands still admitted to firmware.
> 
>>
>> -     up(&cmd->vars.pages_sem);
>> -     for (i = 0; i < cmd->vars.max_reg_cmds; i++)
>> -             up(&cmd->vars.sem);
>> +     cmd_sem_up_all(dev, nr, pages_sem);
>> +}
>> +
>> +static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
>> +{
>> +     bool pages_sem;
>> +     int nr;
>> +
>> +     nr = cmd_sem_down_all(dev, &pages_sem);
>> +     dev->cmd.mode = mode;
> 
> [Severity: High]
> Can writing dev->cmd.mode here after a partial drain reintroduce the
> indefinite hang this patch sets out to remove?
> 
> The full drain was the only thing serializing cmd->mode against the two
> reads that belong to one command's lifetime.  cmd_work_handler() latches it
> before the doorbell:
> 
>    cmd_mode = cmd->mode;
>    ...
>    /* a command latched as CMD_MODE_EVENTS is never polled here */
> 
> and wait_func() re-reads the live value:
> 
>    if (cmd->mode == CMD_MODE_POLLING || ent->polling)
>            wait_for_completion(&ent->done);
> 
> so an events-mode command whose waiter observes CMD_MODE_POLLING takes the
> untimed wait_for_completion().
> 
> CPU0                                    CPU1
> cmd_work_handler()
>    cmd_mode = CMD_MODE_EVENTS
>    ring doorbell
>                                          destroy_async_eqs()
>                                            mlx5_cmd_use_polling()
>                                              mlx5_cmd_change_mod()
>                                                partial drain
>                                                dev->cmd.mode = CMD_MODE_POLLING
>                                              mlx5_eq_notifier_unregister()
>                                            cleanup_async_eq(cmd_eq)
> wait_func()
>    reads CMD_MODE_POLLING
>    wait_for_completion(&ent->done)  /* nothing left to complete it */
> 
> The notifier is unregistered right after the store and the command EQ is
> destroyed next, so no completion source remains and the submitter stays in
> D state, which is the state the changelog is trying to eliminate.
> 
> Before this patch the store required every cmd->vars.sem unit, and
> mlx5_cmd_invoke() holds the entry's reference (hence its unit) across all
> of wait_func(), so no in-flight command could straddle the change.
> 
> On a related note, cmd->mode and cmd->allowed_opcode are now plain
> unannotated loads and stores shared between process context, the cmd
> workqueue and the EQ path with no lock at all on the timeout path.
> 
> The follow-up patch in the series adds cmd_reclaim_stalled_ents() in
> mlx5_cmd_disable() but never complete()s ent->done, so this waiter still
> hangs at the end of the series.
> 
>> +     cmd_sem_up_all(dev, nr, pages_sem);
>>   }
>>
>>   static int cmd_comp_notifier(struct notifier_block *nb,
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915225941.554568-1-dcostantino%40meta.com

