Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611503DC4D8;
	Mon, 28 Sep 2026 13:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790600766; cv=fail; b=RkJfqrkN1JLqjf+BVJHMHec9Nh2EZyueai+igjJQIn6F6OQPUOUeqE8n16VXIkKkmOkhLKAZJ1faSX4Nvnu7UIIBZHg2HMXTzzPJt3XGuRkOwfw7fwwxBFwMPtOIzDyIEoGO3le+7adVD7qaR9DXjE2xf8lZUU7ngIYHY9zfjNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790600766; c=relaxed/simple;
	bh=2ZRr9QZvWBL25O2LMw6CzqzryP5vvyusBJm6APjwDp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MyDIc8CxOn6VcaEDOCT/s24h2/cVWv0STUXwLR0gWmHceNrbjAJTt5AuCC5OaKeuUTGd17jpY4ouxy4yGy6t8GDBE0aGY7nn0jEAynby+IgOnga6QY6Tya78CO1LaCmyfmhT9xkZoMzilxb2LKJH2ftIztibTG6aRW2hGl3lSbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EGv3ROV7; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EGv3ROV7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QA+TfCT6fhNblAMGI19HTYtoXaGTnN8ATlSFMav1mgakkPWjEc0QTvS7mT83DzCBEy90p8nSz+mIO91R5MK6LljXEHGQdtkWfNXVkTCkzT7e/yl+OZY55+StF822C2Ihr3P+wy2zqdesghVGC6E7QWaeoPHRsyiSdKnSbaaG2/vdutuJ//qdGZLRfZmPm2+5yhAVn2XrTPq9nUOu7IolTFmuYGOci1Wp4AfQh8KVeJnxiY5nf8gwPZIQArOJ8rrWIkIBllUMZxckfQA7kCPr0RjXwulttPPyVcJimesQowfMMfvg7DBc0wlpmrhqaU4/DAhY6Jpqz75lFlY0fM8ZFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4OIFqcpkYPCXcia/ln7Azecn0Z2fNQdkvCnl9xrjWU=;
 b=NOjj0GP18UMB39F4CwZbj9A7nOALr2NS5Se+tXybu8fzVDEOgZqKR1s4l1NjUzUpoetgRcJ6cgvY8KJJW1jZhTjiQ9jfua7To1ub85jm/KfgYWbaWi8T/M6tnuJIFu66mEM4yRCT7XvJf4ueYB/BgkbHuBQkdcHcY5wDu889O4GJGd4Omk9aWsnPz97cGlEiDJCUvxFOV5QmNSMqqUN6nhATioPcvqGwZBs/h7kMkSOFrxoUagP895zQCWenC+Gsa+GCfXuU7YaATS1k3OEELzCsZbKtMty+F5SfLSi1gsC2X/TPQU8mK2ZRUIJ7sIu1AZlpu5xw0QYC5oCSMpXEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=meta.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4OIFqcpkYPCXcia/ln7Azecn0Z2fNQdkvCnl9xrjWU=;
 b=EGv3ROV7+c53qc6VKwIkuS4XfUD7WE1JaZ2Z+saDNFuJOtIWA+MTkYgOtjJUfdBtNM9S6SvOC+Wlsjb/5Z0Jv5QFVTE43T12gjDyQZVx9NmsmVyZL/4c1Qo49FWj2Ak6xIlEt7h7zXe1Nj0qgBv5utIawtJHXtELUBsDV2S5Fqtse6mIFFTuXZQvw/H9txlYDZqBlezKLyXPZXM9323CEWjiP4crbs2ugCkQAKH9vGqU/iFhchqeVqBo0MKb4aOPyRCq5E0+D8FFyr139maTp3F4NSndN2HAd2SgRA+qCvJtlWfgnMsidxONu81LXplBge3xifJaqiJK2BUVYEPOfg==
Received: from MN0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:208:530::12)
 by SN7PR12MB6863.namprd12.prod.outlook.com (2603:10b6:806:264::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 13:05:59 +0000
Received: from BN6PEPF00000071.namprd03.prod.outlook.com
 (2603:10b6:208:530:cafe::76) by MN0PR02CA0009.outlook.office365.com
 (2603:10b6:208:530::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.24 via Frontend Transport; Mon,
 28 Sep 2026 13:05:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN6PEPF00000071.mail.protection.outlook.com (10.167.248.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 13:05:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 06:05:31 -0700
Received: from [10.242.141.2] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 06:05:26 -0700
Message-ID: <c92a3b53-afb7-477b-8ff8-e3f119f96155@nvidia.com>
Date: Mon, 28 Sep 2026 16:05:23 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5: Don't return firmware-owned command
 mailboxes to the DMA pool
To: <dcostantino@meta.com>
CC: <saeedm@nvidia.com>, <leon@kernel.org>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<eranbe@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20260923190542.848049-1-dcostantino@meta.com>
 <179053692935.3145.9499750768128839597@kernel.org>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <179053692935.3145.9499750768128839597@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF00000071:EE_|SN7PR12MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: e9fa43a7-0df5-4f4d-0c2d-08df1d613be3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|7416014|1800799024|82310400026|3023799007|6133799003|10067099003|11063799006|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4j1MoqmQcKBEUJQptmgooCWDtgnEGmf2eJ66RcMyde/tHbG5plTch8/M8CnDUhzIgT9BjVpgqgmiQzJtnzuY+3EG/hU2sf/IcgfEdvF3HaWAq9iTOK4MjkybUndh0Bh7tsfTzzw+lFWPlp1j9pRGw6C0bQkO6YDJNK4ROXA9WCzCVZN8THt3ygfIiKsrkHr/MPtoXgTj/HouYxKiXEkUYbDKcatJo9IlHemOnLerJSpufDS/ucEJgrs0OOIhR+aHZQiLXAYGEFtsVJzvpxOVzbluDu2BXU/GHTRyTvIzRmJLsVJGX6WhyEaURo7XoAQz+fL7jlAoMeLTP6OAoTrhtAQ/7U6HyVrVkm8E2k9uwFwWKbMwqd+F1ojnSG2fkkVFIHPIWYwqWHOEJpWJzqJOPoC6eD0lW+kECfOxzXoko8c5DrysajK7JpRAQ+aeAABqBgs6PcFOXljaP/noBkrSlZtbT/S/SNbic3RNoFGmyPiWuLirY9QhjKVSIe6k0H3IDxWCnEQlb4abBnRTtR+DgA1/xpNqR68P8hvWXZewUZBp2SZ2pUUlpsMgjOwRDYkxU7AtazHXKLfyQ+oGG2bp8B2N9YSiV9Vhwi7jMkxPo0Z6Prgthl7DIRDOrqQTEPJsav/pIyaw/bbdTASUqtv3R0Agb1+199h/oLn9uSbL1WCdGbqVYkAotwyoobPHWQpP1OjUPoYde7JZtc59onbF9w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(7416014)(1800799024)(82310400026)(3023799007)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eGJ4OMKLqq8WbXVablxRJENURHGvEQgAoNpVpeQbIcpJE3S0/ARARdTvYbruqs5AznMn/wqqTLEL0XC41kpGFc8f7KuYnmLUGwSWg7Y6UsFekrJRjyPxqcgxIqS0fv5B/Tg9pZQuYg2raCK2hFr3vMpZMWxDW4caObda7J6zqYMxyXEfzifdQ6mJj63NN+J2dSxuN7yBuQ7krr/3ffmu1rnCBBtb+r7BY7bNXR1+lw1624ErSYBxU8Z3o7V2urig8f0wirkVTi/t/KftAWqXZScvR7kU/NN5bdQZnq/Ol/RwSgH2eUtgxyUz/2p2tq39X+iNwyUc2HHr4XdoFbcTIedIfrVNYiY8LsDmYq1WbgHUd1RcguqmCVYw7LzfOBtaXyxKVffC9Dcu+zTFGB4HFVtoRfPafJWiiEgz1so0Awkm0p5GTUt4h07OnBftk9C/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 13:05:56.1914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9fa43a7-0df5-4f4d-0c2d-08df1d613be3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000071.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6863



On 9/27/2026 10:22 PM, netdev-bot+sashiko@kernel.org wrote:
> 
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 (2) · Medium: 3 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] Moving the mailbox free into cmd_ent_put() makes it run on
>    whichever context drops the last reference, with nothing synchronising…
> - [Medium] The commit message says an entry that firmware never completes
>    "keeps its mailboxes for the lifetime of the device" and calls the…
> - [Medium] Mailbox retention depends on which reference happens to be
>    dropped last, not on whether firmware still owns the descriptor.
> - [Medium] Retained mailboxes can outlive the dma_pool they came from,
>    but are freed through whatever dev->cmd.pool points to at put time.
> - [Low] The kernel-doc above mlx5_cmd_invoke() (cmd.c ~1252-1266) says
>    that for !callback, 'ret < 0 : Command execution couldn't be submitted…
> 
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but a command that
>    times out while the device is up holds its command slot, and the slot…
> - [High] This problem wasn't introduced by this patch, but on the
>    synchronous path a sync timeout can race with a real completion and…
> 
> --
> 
> net/mlx5: Don't return firmware-owned command mailboxes to the DMA pool
> 
> This patch uses a new own_msgs flag to put off freeing a timed-out
> command's mailboxes until the final cmd_ent_put() of the command entry.
> It does this on both the synchronous and the callback paths. The aim is to
> stop late firmware writes from landing in blocks already returned to the
> mlx5_cmd dma_pool.
> 
>> An entry firmware never completes keeps its mailboxes for the lifetime of
>> the device. dma_pool_destroy() then reports the pool busy and declines to
>> free its pages, which is the memory safe outcome: the pages stay mapped,
>> so a late write lands there rather than in memory handed back to the
>> allocator.
> 
> [Severity: Medium]
> Is "for the lifetime of the device" accurate here? The mlx5_cmd dma_pool
> is created in mlx5_cmd_enable() and destroyed in mlx5_cmd_disable(). Those
> run from mlx5_function_enable()/mlx5_function_disable() on every
> load/unload cycle, not only at probe/remove:
> 
> mlx5_cmd_enable()
>      cmd->pool = dma_pool_create("mlx5_cmd", mlx5_core_dma_dev(dev), size, align, 0);
>      ...
>      create_msg_cache(dev);
> 
> mlx5_cmd_disable()
>      destroy_msg_cache(dev);
>      free_cmd_page(dev, cmd);
>      dma_pool_destroy(cmd->pool);
> 
> If a retained entry still holds blocks, dma_pool_destroy() skips
> dma_free_coherent() for every page in the pool. That includes the pages
> behind the message cache that destroy_msg_cache() has just returned:
> 512x1 + 32x2 + 16x16 + 8x256 + 2x512 = 3904 blocks of 1024 bytes.
> 
> So each command interface incarnation that ends with an unrecovered
> timed-out mailbox appears to leak about 4 MB of DMA-coherent memory. The
> entry and its msg structs are never freed either. Before this patch the
> pool was torn down cleanly, because cmd_exec() had already freed the
> mailboxes.
> 
> Two ways this can be reached:
> 
> - A MANAGE_PAGES timeout in
>    mlx5_function_disable()->mlx5_reclaim_startup_pages(), followed by
>    mlx5_core_disable_hca() and mlx5_cmd_disable().
> - A timeout during mlx5_function_enable()/mlx5_function_open(), followed
>    by the error unwind.
> 
> Later pool incarnations start fresh, so this happens once per
> unrecovered timeout followed by a teardown, not on every later disable.
> 
> Given the Cc: stable tag, could the commit message describe this cost
> more precisely?
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> index 84583dc5eb1c0..4051f97b2ae12 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> 
> [ ... ]
> 
>> @@ -207,6 +214,11 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
>>        }
>>        spin_unlock_irqrestore(&cmd->alloc_lock, flags);
>>
>> +     if (ent->own_msgs) {
>> +             mlx5_free_cmd_msg(dev, ent->out);
>> +             free_msg(dev, ent->in);
>> +     }
>> +
> 
> [Severity: Medium]
> Can a retained mailbox end up freed into a different dma_pool than the
> one it was allocated from? These frees always go through whatever
> dev->cmd.pool and dev->cmd.cache[] are when the last put happens.
> 
> One possible sequence:
> 
> 1. A timed-out entry keeps its FW reference, with own_msgs set.
> 
> 2. mlx5_cmd_disable() runs destroy_msg_cache() and dma_pool_destroy().
>     The pool is busy, so its pages are kept, but the struct dma_pool is
>     still kfree()d.
> 
> 3. mlx5_cmd_enable() does memset(&cmd->vars, 0, ...), sets
>     cmd->vars.bitmask = MLX5_CMD_MASK, and creates a new pool and cache.
>     cmd->ent_arr[] is outside vars and is not cleared, so ent_arr[i]
>     still points at the stale entry.
> 
> 4. A non-forced completion for bit i arrives before slot i is reused.
>     mlx5_cmd_comp_handler() finds PENDING_COMP clear, logs "Command
>     completion arrived after timeout" and calls cmd_ent_put().
> 
> 5. That is the final reference. mlx5_free_cmd_msg()->free_cmd_box() then
>     calls dma_pool_free(dev->cmd.pool, ...) on the new pool with a block
>     from the old one. Without DMAPOOL_DEBUG, pool_block_err() does not
>     catch this. The block goes onto the new pool's free list, and the new
>     pool's nr_active is decremented.
> 
> 6. free_msg(dev, ent->in) also adds an old-pool cached msg to the rebuilt
>     cache list.
> 
> After that, the new pool's nr_active can read 0 while another timed-out
> entry still owns a real block. A later dma_pool_destroy() would then
> dma_free_coherent() pages that firmware may still write to.
> 
> Before this patch, a stale final put only did cmd_free_index(), up() and
> kfree(ent). It never touched the pool or the cache.
> 
>>        cmd_free_ent(ent);
>>   }
>>
>> @@ -958,10 +970,6 @@ static void cb_timeout_handler(struct work_struct *work)
>>        cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
>>   }
> 
> [Severity: High]
> Now that cmd_ent_put() can free mailboxes, can this put race with
> command interface teardown?

That's a valid concern, in cmd_ent_put() mailbox should be freed before 
up() not after.
Also I would drop the last paragraph of the commit message, as we don't 
handle here "An entry firmware never completes".
Thanks, Moshe.

> 
> cmd_work_handler() takes a reference for the timeout work:
> 
>      if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, timeout))
>          cmd_ent_get(ent);
> 
> Take the "Async, recovered after timeout" case.
> mlx5_cmd_eq_recover() recovers the EQE, and mlx5_cmd_comp_handler()
> cannot cancel the running work, because cancel_delayed_work() returns
> false. The handler drops the FW and consumer references, sets own_msgs
> and calls the callback.
> 
> That leaves the put above in cb_timeout_handler(), running on
> system_wq, as the final one. The same happens when a real completion
> races with the timeout work.
> 
> In cmd_ent_put() the slot and semaphore are released under alloc_lock,
> and the mailboxes are only freed after the lock is dropped:
> 
>      cmd_free_index(cmd, ent->idx);
>      up(ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem);
>      ...
>      spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> 
>      if (ent->own_msgs) {
>          mlx5_free_cmd_msg(dev, ent->out);
>          free_msg(dev, ent->in);
>      }
> 
> The teardown paths don't wait for that free:
> 
> - mlx5_cmd_allowed_opcode() and mlx5_cmd_flush() only wait for the up().
> - mlx5_cmd_cleanup_async_ctx() only waits for the callback.
> - mlx5_cmd_disable() only flushes cmd->wq, not system_wq.
> 
> Suppose this worker is delayed just after the up(). Could
> mlx5_cmd_disable() get through destroy_msg_cache() and dma_pool_destroy()
> first? The pool is busy, so its struct is kfree()d. The worker would then
> call dma_pool_free() on the freed pool, or on a newly created one, and
> list_add_tail() onto a destroyed or re-initialised cache list.
> 
> [ ... ]
> 
>> @@ -1313,7 +1321,12 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>>                return 0; /* mlx5_cmd_comp_handler() will put(ent) */
>>
>>        err = wait_func(dev, ent);
>> -     if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
>> +     if (err == -ETIMEDOUT) {
>> +             /* firmware may still DMA into the mailboxes; keep them */
>> +             ent->own_msgs = true;
>> +             goto out_free;
>> +     }
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but can a sync timeout race
> with a real completion and free ent and its messages while the IRQ side
> is still using them?
> 
> CPU A: wait_func_handle_exec_timeout()
>      ent->ret = -ETIMEDOUT;
>      mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
>          loses test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP)
>          continue;
> 
> CPU B: EQ IRQ, mlx5_cmd_comp_handler(dev, vec, false)
>      wins test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP)
>      cmd_ent_put(ent);        /* refcount 2 -> 1 */
>      ent->ts2 = ktime_get_ns();
>      memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
>      dump_command(dev, ent, 0);
>      ...
>      complete(&ent->done);
> 
> On CPU A, wait_func() returns -ETIMEDOUT without waiting on ent->done
> again. mlx5_cmd_invoke() sets own_msgs and makes the final
> cmd_ent_put() (1 -> 0), which frees ent->out, ent->in and ent. CPU B may
> still be writing ent->out and calling complete(&ent->done) at that point.
> 
> The same window existed before, with cmd_exec() freeing the messages
> right after the put. This change moves the frees into that final put but
> doesn't close the window.
> 
> [Severity: Low]
> This isn't a bug, but the kernel-doc above mlx5_cmd_invoke() still says:
> 
>   * return value in case (!callback):
>   *      ret < 0 : Command execution couldn't be submitted by driver
> 
> With this change, -ETIMEDOUT means the command was submitted and in/out
> now belong to the entry, so the caller must not free them. Only
> cmd_exec() knows this, through the new goto out_up. Could the comment
> document the ownership transfer, so a future caller that frees on a
> negative return doesn't double-free?
> 
>> +     if (err == -ECANCELED || err == -EBUSY)
>>                goto out_free;
>>
>>        ds = ent->ts2 - ent->ts1;
>> @@ -1816,8 +1829,10 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>>                                                                 ent->out,
>>                                                                 ent->uout_size);
>>
>> -                             mlx5_free_cmd_msg(dev, ent->out);
>> -                             free_msg(dev, ent->in);
>> +                             /* firmware may still DMA into the mailboxes;
>> +                              * keep them
>> +                              */
>> +                             ent->own_msgs = true;
>>
>>                                /* final consumer is done, release ent */
>>                                cmd_ent_put(ent);
> 
> [Severity: High]
> This is a pre-existing issue, not one introduced by this patch. It is
> raised here because the patch handles exactly these retained entries.
> Can a command that times out while the device is up hold its slot
> semaphore forever, and leave mlx5_cmd_flush() spinning?
> 
> After the timeout, the forced mlx5_cmd_comp_handler() clears
> PENDING_COMP but keeps the FW reference, because mlx5_cmd_is_down() is
> false and the opcode is allowed. The final cmd_ent_put(), which does
> up(&cmd->vars.sem), therefore only runs on a real completion.
> 
> enter_error_state() then sets MLX5_DEVICE_STATE_INTERNAL_ERROR and calls
> mlx5_cmd_flush():
> 
>          for (i = 0; i < cmd->vars.max_reg_cmds; i++) {
>                  while (down_trylock(&cmd->vars.sem)) {
>                          mlx5_cmd_trigger_completions(dev);
>                          cond_resched();
>                  }
>          }
> 
> For the timed-out entry, mlx5_cmd_trigger_completions() takes and drops
> a temporary reference. The forced handler finds PENDING_COMP already
> clear and hits continue without a put. cmd_comp_notifier() ignores real
> EQEs once dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR, so the permit
> never comes back.
> 
> This loop is reached from the fatal health reporter, PCI err_detected,
> sync FW reset, and shutdown through
> mlx5_try_fast_unload()->mlx5_enter_error_state(). Those callers hold
> intf_state_mutex while it runs. On unload, the same held permit also
> blocks the down() loops in mlx5_cmd_allowed_opcode() and
> mlx5_cmd_change_mod().
> 
> Wouldn't recovery, unload and reboot all hang here?
> 
> [ ... ]
> 
>> @@ -2012,6 +2027,9 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>>        if (callback && !err)
>>                return 0;
>>
>> +     if (err == -ETIMEDOUT) /* the command entry owns the mailboxes now */
>> +             goto out_up;
>> +
> 
> [Severity: Medium]
> Does this cover every case where firmware still owns the mailboxes?
> Whether they are kept seems to depend on which reference is dropped
> last, not on whether the descriptor is still owned by hardware.
> 
> First, a forced completion in mlx5_cmd_comp_handler() still drops the
> FW reference when the device looks down:
> 
>                          if (!forced || /* Real FW completion */
>                               mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
>                               !opcode_allowed(cmd, ent->op))
>                                  cmd_ent_put(ent);
> 
> mlx5_cmd_is_down() becomes true as soon as poll_health() sets
> MLX5_DEVICE_STATE_INTERNAL_ERROR on a fatal sensor (for example
> MLX5_SENSOR_FW_SYND_RFR). That happens before any reset or DMA
> quiescence.
> 
> If wait_func_handle_exec_timeout() fires in that state, the put in
> mlx5_cmd_invoke() is final. cmd_ent_put() then frees ent->in and ent->out
> straight away, even though own_msgs was just set. On the async path the
> put in cb_timeout_handler() is the final one.
> 
> Second, mlx5_cmd_flush()->mlx5_cmd_trigger_completions() force-completes
> every allocated slot with MLX5_TRIGGERED_CMD_COMP, so ent->ret becomes
> -ENXIO.
> 
> For sync commands, only -ETIMEDOUT is special-cased above. -ENXIO falls
> through to out_out, and mlx5_free_cmd_msg()/free_msg() release blocks
> for commands that have already been doorbelled. For callback commands,
> own_msgs is set, but the is_down check drops the FW reference and the
> trigger loop's cmd_ent_put() frees them.
> 
> If firmware completes one of these commands before the reset, couldn't
> the late write land in a freed block, or in pool pages freed by a later
> clean dma_pool_destroy()? That is the same corruption the commit message
> describes.
> 
> The new "firmware may still DMA into the mailboxes; keep them" comments
> promise a retention that these paths don't provide.
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923190542.848049-1-dcostantino%40meta.com

