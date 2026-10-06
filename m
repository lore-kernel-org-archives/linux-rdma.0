Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010042.outbound.protection.outlook.com [52.101.193.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5D93E8C77;
	Tue,  6 Oct 2026 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791291719; cv=fail; b=cZqezz0VJFKHg79r+e7T4RVeEtT1Z9j4UTJnol6eD4EeCrTu2vKal1zIA4lzOs4X1HghrQitR0rx6Bx7mSdlQL1F+IZIHPKtET+Ud3oN31QVysisz7YmQ+5Kvvgr+W6lHVRaRNihNSKCXP/RI/wmzipxkoPS6ic1P631ISyOyb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791291719; c=relaxed/simple;
	bh=mUoaTFtpBEJXVb7wDMPEACh+5MQmv+YmOM29EHDD3Fw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YT0N4/gWB1TOHrZka29XzTv6by4vGNN3we9A6KQddS1AcIfcwBxfqgZdss9+1n1d7VhgFknz8bnFPYSTwaGOlvQa//E4V/B4rvh3cWbWk1B00Sfu+8NyveFsPLt01vN/ERul8RhdnUyapcsLNaZ10lhp+k6ABRs6KsSZitNYqfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q/lJUp86; arc=fail smtp.client-ip=52.101.193.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q/lJUp86"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBKTyiltryu+TXQCXsJ/2IkJM1631zg3ZuQYn/mC741r4wXfyUuInOm7Jt6fdtynwkCpdWYUVMvO/WxVxvv27rA1H3dckZ0/GrCZNy0Fc1lVHGIhQEUTaFzkFH3++hfluaSHMc5ShCBse0pZIRAZLYG2LbG0jLSLSh/TfU3BQaT8zgM3RPDnRLxtzgqHbudg9a8mxkLMcIGCTuZ6b9YY8SPwn8kzTpTfD7Uo7mnA4gIyCqEzRHFAYwL2NwJJEEqloaXbF93aXwCsvGolXfNwhZj2gNkJepuaqyhBvJHHkX01W0QjmJTHaqsB6ahLTImLarSgYjfkBmV9tNlhsjwUYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyuzNdjuTAt39xb2qiqvQlia5i0QVQUk+0wUMw+bSsY=;
 b=Bvj1j/FxqNdXVQX4CvH73Pmp0AWFjN0TSFmE5VMwj/eBErRNxuplSqOu4N0UuD9lKWtLP2H4MLEgyqlzk0DG2MjR7x1TAduYmkiI0yRIiTn+CUXHGKJYJiYHzjXLuyeUaQaf3+fYf6rXnTO0bGF7iFc3fV00yPRgFrPEpJnHOrBlH6S8VXFVktd5W1DKnE2UXJoTdnxoJIe0IQCTrXLUWmmhPaSKVlXBFWGOX7dAyXvzEpzEvd6OovQgBRlGkVdYKmiLezvlJ14N/6hogAeVFg6VHw1AIPVosdSlOeeuY4Xa5xDTWcc47YNJQFC2KnVLyEex5d2m5CziucC5cmDT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyuzNdjuTAt39xb2qiqvQlia5i0QVQUk+0wUMw+bSsY=;
 b=q/lJUp8618mPa0T6ENLb7rOY6AkoQgNLm40sbO+g/kWYLnafH1kyif7w1BZEEEz+X4Q78Fcfm0GnAk08aBUfzsAn5aqKBSPjoe6Oqh4Twig/q/2g4U1eo6RN3Lin4AELfOr8/9C/Tx15/OBbt/fI7PqoM62EpamVlYl0VnlAauYxhDThVqBmTpiOmt31lH2qQaYFqVYSRKzPQL/6aqkfLXRcIijJGUIN3tl7PVgLNZAq4Hcj0z31xa1plQoPmEDBbaqRq4M11LEeF8e9SNplhVEc0btAiBownXReDSCLmH/XyI+WPqrIKu6Y6o9zQw6+m3jnlGz1BFvRSE/HC8nvNQ==
Received: from SJ0PR03CA0291.namprd03.prod.outlook.com (2603:10b6:a03:39e::26)
 by DS6PR12MB884699.namprd12.prod.outlook.com (2603:10b6:8:4c7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 13:01:53 +0000
Received: from MWH0EPF000C618E.namprd02.prod.outlook.com
 (2603:10b6:a03:39e:cafe::4) by SJ0PR03CA0291.outlook.office365.com
 (2603:10b6:a03:39e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 6
 Oct 2026 13:01:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C618E.mail.protection.outlook.com (10.167.249.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 13:01:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 06:01:13 -0700
Received: from [10.125.205.2] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 06:01:10 -0700
Message-ID: <87d6f88d-e78a-4a32-a8ac-e9c68e3f2189@nvidia.com>
Date: Tue, 6 Oct 2026 16:01:07 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
To: Manjunath Patil <manjunath.b.patil@oracle.com>, <saeedm@nvidia.com>
CC: <leonro@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618E:EE_|DS6PR12MB884699:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f915100-fd56-4dc0-0636-08df23a9fdf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700016|23010399003|6133799003|22082099003|18002099003|10067099003|3023799007|11063799006|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	XiOy4TD+gmSCQsK0bpXT8YwKFfvWYhfo6R3Xa9yXIOtTrTQ0AWSqqvsH375sVfNymb3FXuYEttiTPCIKOzhGnNxSXTgG7wK+XJZNWGiluUnYAWR/7kIS98MZHeNg9VZy1pSYZRhZayMCgIl9tteJR77FCIyTX9RrYlXe/LsLwNH2scG/PWpfs0WGgtOVl2HFwoOV4TdbPYOZnwasDXdhqucTI6iXHAZORapwS61sQfqkqcFnMK8GPd3nxslmg6OI5/JO33zbiPGE47i3HXgr1KR9bIOhIHlYn7hl664X+HdpmVOHLd9+XzsftSHSp9PI8yguEZliZd/kRE/q8emeK87Lz3Fdw3DeSA7oeCdmHPpS3yXP/2WUeLuEfX3tSLlsbuXBAOe8CLYJYMc8cfZSqvOcbtuhK3I8Vkl+vEs60NoLLygpsv03b0Q1WFsPSD7l6ZgaXKlsLR8GhVZK/d8TagATriQa/9t2SkXDn188xTG83Y/XoesSR8OMtJ1mXMr9ZPHDnAqKjoRc3vAASpLoZ0AJPUdcemZWA6s8O7zxhHJZvEqq6YGH4yX291EANH70l+jdiAjrL5BRqmvV/1cH3Evj7lw3ji04Oa+JdIckZQJmtKXU811Ngd1Y7R1v3XTHUpbc8V7wNlzGa4JsTw5HzaYFgx3KlnZTCr8B31r3nADBb+jRjTg0+KHHS10z5iQFczsqnke1t7acx4HDxW/PCA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007)(11063799006)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+C5q+9PJX5Ew0IgyPKpmNQ+2jOoMSzVMMl1UX0X9XL0CUJ0Xit9k1frAQAuF56jWdGNeBPhwVcctlZROCPbzIER23ODtf3XhhiSNLBOeixRLV4cKF2W2dR1pbKsm707FJr5uTg5LtOBVuvp+TKUXfRbeRrscfq0UtoaJm2p42NbwLCkJPTW8fVJFng3WCSKQaj1JVNUz5KGe/F7Lvh/jpj119mqU7whOSu2uNUr8W+hUXxNPW/HTuBsPheGOrt5dKzwchkfpK2ApLdTXZy748qzIBTrqda4T+sHUgjoq1FZSlSW68GLIl/sSaS0oQfacp4B1K52rNs+iioH24U1kZ1LDEgV22ZCjZMPmeHnFuWGuDIpv1bEz4tiS/FMbDUjsW7VzWYf1MTNMbZBqhA4RRC05sOuysxDWK/KIvrcZpf0Oux2PJ9RdtMruh6E3aar+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 13:01:52.5373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f915100-fd56-4dc0-0636-08df23a9fdf4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB884699



On 10/2/2026 11:56 PM, Manjunath Patil wrote:
> Firmware can access command DMA mailboxes after the driver times out.
> The command entry already keeps a reference for a possible firmware
> completion, which keeps its slot allocated, but the blocking caller
> and async callback can still free their input and output mailboxes on
> timeout. A late firmware access can therefore hit reallocated DMA
> pool memory.
> 
> Give the entry ownership of the mailboxes on timeout and free them when
> its final reference is dropped. If timeout claims PENDING_COMP first,
> retain the firmware-event reference while a real completion remains
> possible; a late completion drops it.
> 
> The real EQ handler may instead claim PENDING_COMP before the blocking
> timeout handler runs and still be reading the mailboxes. Set
> RETAIN_MSGS before forcing timeout completion in the blocking path.
> The EQ handler holds its entry reference through its last mailbox
> access and done notification, so the caller can return on timeout
> without freeing memory beneath it.
> 
> Serialize completion claims and firmware-reference handoffs under
> alloc_lock. The existing reset/error flush marks synthetic
> completions with MLX5_TRIGGERED_CMD_COMP and treats them as terminal
> for firmware ownership; only such a triggered completion drops a
> reference retained by an earlier timeout. Normal command EQ teardown
> and its slot-drain policy are unchanged.
> 
> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Assisted-by: Codex:gpt-5
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 127 ++++++++++++++----
>   include/linux/mlx5/driver.h                   |   1 +
>   2 files changed, 103 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 84583dc5eb1c..22508b26972d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -142,8 +142,19 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
>   	return ent;
>   }
>   

Hi Manjunath, thanks for your patch.
Danielle Costantino has sent recently a patch for the same bug.
See v2 on 
https://lore.kernel.org/netdev/20260923190542.848049-1-dcostantino@meta.com/
Please follow on that thread.

Thanks,
Moshe.

> +static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
> +static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
> +			      struct mlx5_cmd_msg *msg);
> +
>   static void cmd_free_ent(struct mlx5_cmd_work_ent *ent)
>   {
> +	if (test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state)) {
> +		struct mlx5_core_dev *dev = container_of(ent->cmd,
> +							  struct mlx5_core_dev, cmd);
> +
> +		mlx5_free_cmd_msg(dev, ent->out);
> +		free_msg(dev, ent->in);
> +	}
>   	kfree(ent);
>   }
>   
> @@ -958,10 +969,6 @@ static void cb_timeout_handler(struct work_struct *work)
>   	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
>   }
>   
> -static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
> -static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
> -			      struct mlx5_cmd_msg *msg);
> -
>   static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
>   {
>   	if (cmd->allowed_opcode == CMD_ALLOWED_OPCODE_ALL)
> @@ -1163,6 +1170,10 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
>   		       mlx5_command_str(ent->op), ent->op);
>   
>   	ent->ret = -ETIMEDOUT;
> +	/* The real handler may have claimed the completion but still be using
> +	 * the mailboxes. Keep them with the entry until its last reference.
> +	 */
> +	set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
>   	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
>   }
>   
> @@ -1260,7 +1271,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>   			   struct mlx5_cmd_msg *out, void *uout, int uout_size,
>   			   mlx5_cmd_cbk_t callback,
>   			   void *context, int page_queue,
> -			   u8 token, bool force_polling)
> +			   u8 token, bool force_polling, bool *retain_msgs)
>   {
>   	struct mlx5_cmd *cmd = &dev->cmd;
>   	struct mlx5_cmd_work_ent *ent;
> @@ -1313,6 +1324,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>   		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
>   
>   	err = wait_func(dev, ent);
> +	*retain_msgs = test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
>   	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
>   		goto out_free;
>   
> @@ -1732,6 +1744,66 @@ static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)
>   	}
>   }
>   
> +/*
> + * cmd_work_handler() takes an entry reference for the firmware event and
> + * sets PENDING_COMP before ringing the command doorbell. Firmware can still
> + * use the input and output DMA mailboxes after the caller times out.
> + *
> + * Claim PENDING_COMP under alloc_lock so exactly one handler makes the
> + * mailbox and firmware-reference decisions:
> + *
> + * - A timeout that wins retains the mailboxes in the entry. If the command
> + *   interface is still up and the opcode is allowed, firmware can still
> + *   generate a real completion, so TIMEDOUT retains the firmware-event ref.
> + * - A real completion that wins consumes its firmware-event ref normally.
> + * - A real completion that loses is the late event after a timeout. It drops
> + *   the ref retained by TIMEDOUT; RETAIN_MSGS stays set until entry teardown.
> + * - A reset completion cannot be followed by a real firmware event. It drops
> + *   a ref only when TIMEDOUT says the timeout retained one.
> + *
> + * A blocking timeout retains the mailboxes even when a real completion has
> + * claimed PENDING_COMP. That handler keeps its firmware-event reference until
> + * it finishes using the mailboxes. Keeping the reference transitions under
> + * alloc_lock prevents timeout, firmware, and reset from consuming the same
> + * reference.
> + */
> +static bool mlx5_cmd_claim_completion(struct mlx5_core_dev *dev,
> +				      struct mlx5_cmd_work_ent *ent, u64 vec,
> +				      bool forced, bool *drop_fw_ref)
> +{
> +	struct mlx5_cmd *cmd = &dev->cmd;
> +	unsigned long flags;
> +	bool timed_out = forced && ent->ret == -ETIMEDOUT;
> +	bool pending;
> +
> +	*drop_fw_ref = false;
> +	spin_lock_irqsave(&cmd->alloc_lock, flags);
> +	pending = test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP,
> +				     &ent->state);
> +	if (pending) {
> +		if (timed_out)
> +			set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
> +
> +		if (timed_out && !mlx5_cmd_is_down(dev) &&
> +		    opcode_allowed(cmd, ent->op)) {
> +			set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
> +		} else {
> +			clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
> +			*drop_fw_ref = true;
> +		}
> +	} else if (!forced) {
> +		clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
> +		*drop_fw_ref = true;
> +	} else if (vec & MLX5_TRIGGERED_CMD_COMP) {
> +		/* Reset cannot receive a late firmware completion. */
> +		*drop_fw_ref = test_and_clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
> +						  &ent->state);
> +	}
> +	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> +
> +	return pending;
> +}
> +
>   static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced)
>   {
>   	struct mlx5_cmd *cmd = &dev->cmd;
> @@ -1744,38 +1816,33 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>   	struct mlx5_cmd_stats *stats;
>   	unsigned long flags;
>   	unsigned long vector;
> +	bool pending;
> +	bool drop_fw_ref;
>   
>   	/* there can be at most 32 command queues */
>   	vector = vec & 0xffffffff;
>   	for (i = 0; i < (1 << cmd->vars.log_sz); i++) {
>   		if (test_bit(i, &vector)) {
>   			ent = cmd->ent_arr[i];
> -
> -			if (forced && ent->ret == -ETIMEDOUT)
> -				set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
> -					&ent->state);
> -			else if (!forced) /* real FW completion */
> -				clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
> -					  &ent->state);
> +			pending = mlx5_cmd_claim_completion(dev, ent, vec, forced,
> +							    &drop_fw_ref);
>   
>   			/* if we already completed the command, ignore it */
> -			if (!test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP,
> -						&ent->state)) {
> -				/* only real completion can free the cmd slot */
> +			if (!pending) {
>   				if (!forced) {
> -					mlx5_core_err(dev, "Command completion arrived after timeout (entry idx = %d).\n",
> +					mlx5_core_err(dev,
> +						      "Command completion arrived after timeout (entry idx = %d).\n",
>   						      ent->idx);
> -					cmd_ent_put(ent);
>   				}
> +				if (drop_fw_ref)
> +					cmd_ent_put(ent);
>   				continue;
>   			}
>   
>   			if (ent->callback && cancel_delayed_work(&ent->cb_timeout_work))
>   				cmd_ent_put(ent); /* timeout work was canceled */
>   
> -			if (!forced || /* Real FW completion */
> -			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
> -			     !opcode_allowed(cmd, ent->op))
> +			if (drop_fw_ref && ent->callback)
>   				cmd_ent_put(ent);
>   
>   			ent->ts2 = ktime_get_ns();
> @@ -1816,17 +1883,23 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>   								 ent->out,
>   								 ent->uout_size);
>   
> -				mlx5_free_cmd_msg(dev, ent->out);
> -				free_msg(dev, ent->in);
> +				if (!test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS,
> +					      &ent->state)) {
> +					mlx5_free_cmd_msg(dev, ent->out);
> +					free_msg(dev, ent->in);
> +				}
>   
>   				/* final consumer is done, release ent */
>   				cmd_ent_put(ent);
>   				callback(err, context);
>   			} else {
> -				/* release wait_func() so mlx5_cmd_invoke()
> -				 * can make the final ent_put()
> +				/* No mailbox accesses after done. If the caller timed out,
> +				 * the firmware reference keeps ent and its mailboxes alive
> +				 * until this handler has finished.
>   				 */
>   				complete(&ent->done);
> +				if (drop_fw_ref)
> +					cmd_ent_put(ent);
>   			}
>   		}
>   	}
> @@ -1965,6 +2038,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>   	gfp_t gfp;
>   	u8 token;
>   	int err;
> +	bool retain_msgs = false;
>   
>   	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode))
>   		return -ENXIO;
> @@ -2008,9 +2082,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>   	}
>   
>   	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
> -			      pages_queue, token, force_polling);
> +			      pages_queue, token, force_polling, &retain_msgs);
>   	if (callback && !err)
>   		return 0;
> +	/* The entry releases retained DMA mailboxes with its final reference. */
> +	if (retain_msgs)
> +		goto out_up;
>   
>   	if (err > 0) /* Failed in FW, command didn't execute */
>   		err = deliv_status_to_err(err);
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index 83d0a83bbfbc..99cabe13e6c1 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -829,6 +829,7 @@ typedef void (*mlx5_cmd_cbk_t)(int status, void *context);
>   enum {
>   	MLX5_CMD_ENT_STATE_PENDING_COMP,
>   	MLX5_CMD_ENT_STATE_TIMEDOUT,
> +	MLX5_CMD_ENT_STATE_RETAIN_MSGS,
>   };
>   
>   struct mlx5_cmd_work_ent {

