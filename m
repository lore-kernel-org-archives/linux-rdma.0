Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78F7440643;
	Mon, 28 Sep 2026 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607423; cv=fail; b=qOpcnj9qMG+dm8ssDFquTKDeHuQxs2omev5pKyCXv2/6+CiZmNarHA4exYYbWQR5j9EIznqW2sA4PHxjoNFoW+pFsl+cdWku78UBbK4VjjKiAfPHlLffAKRWSWpSM7rWtuB6IVR/HdNCgIhhKoa2LPflswgI1PlBKoSyy4fZi+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607423; c=relaxed/simple;
	bh=ATywLV4PRALGhaDI0qc7Nl/1Nn4q2XMP97Juh2N1aO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ABFcwDm9WbD3KsZ3R++Tv0rr/XO0lSMz/Kujp4GhwDpmYVLINIazn22zK+9nFGy2neiv9PMjjPLuPV357B66KZgfrEl1ug8/sNeHcSMHt8JbKlf3F6GNsFkb8xf+/QDrHUildVnsRIwrmlt0JLCPruVYEIDxl727MC6/UsB216s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tkh/Brln; arc=fail smtp.client-ip=40.107.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tkh/Brln"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mNUkzW0W7Kq1WG5/KQqr9XNEnxVhXOVoV9Qh6b0FwWTWjzhv7bjbj/xGjO7Z0caTi9mbsvWLnIYi5vLGA+PdbvDKTZl6ZUSIWhqay0LLHFznxm/+KJExo4yD0pfbeicbC+6c0KT6ZgC1GL+2otk/J5ZI2wx4lFWBabt5mr5psfE1/xqRbIDsxSIN/YXuoEuysO37L8YEI3WKUb/pvHE0lyeeOCeehwC1Z8+G22TMjrzAK5DHGoQZSie1FeiIsNI8DD9u2P9iKo/X+FS2lJX1QKzafWiVHKW2xCgfFlyC+K0VNBF5VCEJMutB0k5kT3opiCznx48bc1VErONj0sItQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcTOPOrTFR7oXi1nZ34q+9x8GpyT35PqPf6wg19bIC4=;
 b=j5Lbm8n04NSpaSSw/bcDnNQ1ZKgTJXjzfAUfz5vyfDJzwntFEJyZo0VnTsyV62DF66erzaV1N1cQa4Vx9lMshS8sP/fdiFvLla30zQXfiayyo4u3YswdyrglMTepdB+1RPTVEfRGg+FynJaZHepNUBxYz4yGqSlTY83qP5war/jeDDjuzj7GvZEDH9cifqZxYGSZWcVTqcQuoudb2wzo5Yb3D9NHA4y1MEJJ1Qa5iMbnJ3IrP4YKlibDZjrM8PV45YyFkyHPS7TOC8odUD//0SwnqL627wqlnHcpBgO2DN+bjhu0x8w1X57apH6cnDLlclSwWW+onwmgrcsA3/lptQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcTOPOrTFR7oXi1nZ34q+9x8GpyT35PqPf6wg19bIC4=;
 b=Tkh/BrlnpgsJTRZsbxsWb+/JAu71jGCOsxHRjacfUsMbsb3Ghy0R7/kE65nAxtEFcvKkIOYog+JJTtWE14zapSWp/Ps7YPmZlGyL/kxfp5p9xU9cgvpWgbS2yHKDgGlmmCisWtV+h6bXB6MvJQMpzLJ6fMaB36/T+hE12l9fJOOJpGhP034Byu01wf+GHlks+qU2mo65YkDv9iyjm/A0chqDhgJhFoSvGywe7T0HmsRF5NczZpj9E0O4qihEjULTyzhjNxKgEKMBRcKJ8RQMLfNnfsL6wIctYKAIlX8CQW8exqxO6vbPJJmBAoAdQwOmKNZi+O0tzUZu2fzQNZ0cZA==
Received: from SJ0PR05CA0087.namprd05.prod.outlook.com (2603:10b6:a03:332::32)
 by SAVPR12MB999169.namprd12.prod.outlook.com (2603:10b6:806:4e5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 14:56:56 +0000
Received: from MWH0EPF000C618B.namprd02.prod.outlook.com
 (2603:10b6:a03:332:cafe::90) by SJ0PR05CA0087.outlook.office365.com
 (2603:10b6:a03:332::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Mon, 28
 Sep 2026 14:56:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C618B.mail.protection.outlook.com (10.167.249.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 14:56:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 07:56:32 -0700
Received: from [10.221.193.26] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 07:56:27 -0700
Message-ID: <879f443f-a373-480d-acf8-09c6b46ce6f6@nvidia.com>
Date: Mon, 28 Sep 2026 17:56:25 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 03/13] net/mlx5: LAG, allocate v2p_map
 dynamically
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <cratiu@nvidia.com>, <gal@nvidia.com>,
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <saeedm@nvidia.com>
References: <20260923103830.1183-4-tariqt@nvidia.com>
 <179027195430.2160803.6909532515243574175@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179027195430.2160803.6909532515243574175@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618B:EE_|SAVPR12MB999169:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2c70e9-0e65-47de-7464-08df1d70bd89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|7416014|376014|82310400026|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	hFlSRc1xk7HSPK7thmL+PReP+zHtXydOxj6NREKX5ZCqeIUEWPzGmhfuQbOQUapCEcnPeXR8FhMbJJo7FKG5CpJJbDQQgmHed7pH1ztQ0eHztNVD2t1my+LvVr7Hk74xfcIOzyKj5I7yfaq/201ZHnz2PQ/pA7iM3H8Ees1SMdTF0uuSRuts4hxcDBxXDS2R90pvWF482B2ywYkH4f4UYjLJ9XcwogcrHdMGV1cpbH8pw7rI+EwN3pIrG6WU2w5cngcUNhHs8MpPs0+Jm8IrA7pzSm+jBWmdsJRR4/Mq5xbHF/jqD9TBsqw8YKKIV7dZvv65/oP39Yni5jFKDsJn2XYALdyaXaPERtDVehqH84bIx8JsidFL1Jv9l6a1wGpwm65uvtRAwYA/tteRXvVfgZeH2AKLfymIPbByv3/90kanidxULshwVn4AWXaIYbNVHCvcOhq2wyCGYw3uJMLDuxBEOOijd9obeFbL8/12FK+Umxgwhg5QCeLchg/BZGXslxIJXJ617mAQIyOk4VlJs++aY+UqHf33sppPcU73RCsmfPcy6F7k7F7D9WXKqWIt8e1t1xxEezc//KlGsz6sb5PO+xlhhXvcxiaM10Nm2kB3GcwEIFB7nf2ldBgoxbNCC80osY7fgT8IcXT59qT/OCS1Mc2huBqCAiF6EbTM/9X3uc7VQ+fRF3+VPaIIQyyx6rOZoqmv6+ka9b9UYci2AA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(7416014)(376014)(82310400026)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UXPRJNSLkAOadAwEd27fBC+lWS9ZT4aYFlL2Dsqri9FgsE0ynVvfW4wEai0VbcvI5bpUK5y459eDjiqUKIHMDc8G/YFizIOi1W0qrn6zY+cOFIPnRnsElHimEO2Nxsi9K/vwU/NksN+r07O54hEw9b+gT4p1lhkKCQWnz/p9/yySNYf/OdDA3nImp2Lmv1AvddDBG/aLafDgnAoqJW6et8IEy3thXllajmnag0qyk/Q/siSiAN0ltQlAEp+JBs4WQtZ68z0cTFvSzBTa+mKXuxOCY0UlgVXzHFmSrF607Wj+gZ+mPMjWoK6qu5D8cM7w3nI+XtLinbkQkgGDXb7XBJN4y2AFbQR245nicVFwVMX5Mkb5jTZcX8cnYKL6FD7txznRGVPFgvJO3zIqtJQarjMqhbU51vIBfCN+XF5Q6xro4FbYLqYZO0rNBUn2FLNt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 14:56:56.2270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2c70e9-0e65-47de-7464-08df1d70bd89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR12MB999169



On 24/09/2026 20:45, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] v2p_map and the scratch `ports` buffer in mlx5_modify_lag() are
>    now sized ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS, where ldev->ports…
> - [Medium] Before this patch, mlx5_modify_lag()
>    (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:861) used a zeroed…
> 
> --
> 
> net/mlx5: LAG, allocate v2p_map dynamically
> 
> This commit turns the fixed-size v2p_map array in struct mlx5_lag into a
> pointer allocated in mlx5_lag_dev_alloc(). The new size uses ldev->ports
> instead of MLX5_MAX_PORTS. The scratch ports[] buffer in mlx5_modify_lag()
> moves from the stack to a kcalloc() of the same size.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index c655f6e32e9b0..00b0159cb422f 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> 
> [ ... ]
> 
>> @@ -330,11 +331,16 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
>>        if (!ldev)
>>                return NULL;
>>
>> +     ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
>> +     ldev->buckets = 1;
>> +     ldev->v2p_map = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
>> +                             sizeof(*ldev->v2p_map), GFP_KERNEL);
> 
> [Severity: High]
> Is ldev->ports the right bound for this allocation?
> 
> The users of v2p_map index it by the PF's slot in the ldev->pfs xarray, not
> by a dense port number. For example, in mlx5_infer_tx_affinity_mapping():
> 
>          mlx5_ldev_for_each(i, 0, ldev) {
>                  for (j = 0; j < buckets; j++) {
>                          idx = i * buckets + j;
>                          ports[idx] = mlx5_lag_xa_to_dev_idx(ldev, i) + 1;
>                  }
>          }
> > The slot comes from mlx5_ldev_add_mdev(), which allocates it from the 
full
> MLX5_MAX_PORTS range:
> 
>          err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
>                         GFP_KERNEL);
>          ...
>          if (group_id)
>                  return 0;
> 
>          xa_set_mark(&ldev->pfs, idx, MLX5_LAG_XA_MARK_PORT);
> 
> sd_lag_init() adds Socket-Direct secondaries to the same xarray. They take
> slots but never get the PORT mark. Given that, can a port PF end up at a
> slot >= ldev->ports?

no, the mapping is dense and it is done by mlx5_lag_xa_to_dev_idx().

> 
> Here is an example. With num_lag_ports = 4, both buffers are now 64 bytes.
> Say the SD primary takes slot 0 and its secondary takes slot 1. The fourth
> port PF then lands in slot 4. Because ports > 2,
> mlx5_lag_set_port_sel_mode() sets ldev->buckets to
> MLX5_LAG_MAX_HASH_BUCKETS, so that PF would use indices 64..79.
> 
> Would this write past the end of v2p_map through
> mlx5_activate_lag()->mlx5_infer_tx_affinity_mapping()? Would it also write
> past the new ports[] buffer through mlx5_modify_lag()?
> 
> These readers look like they would go past the end the same way:
> mlx5_modify_lag(), mlx5_lag_print_mapping(),
> __mlx5_lag_modify_definers_destinations(),
> mlx5_lag_create_port_sel_table() and mlx5_lag_get_slave_port(). The
> out-of-bounds bytes would then be passed to mlx5_lag_pf_by_dev_idx() as
> 1-based device indices, and also used to program the port-selection table
> and tx_remap_affinity.
> 
> Before this patch, both buffers were
> MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS bytes, which covers every
> possible slot. The rules[] array in struct mlx5_lag_definer (port_sel.h) is
> indexed the same way and is still that size.
> 
> With this in mind, is the "No functional change" statement in the commit
> message accurate? Should the buffers be sized by the slot range, or should
> the indexing use the dense port sequence instead? Later patches in the
> series still size both buffers by ldev->ports, so this does not appear to
> be fixed later on.
> 
>> +     if (!ldev->v2p_map)
>> +             goto err_v2p_map;
> 
> [ ... ]
> 
>> @@ -864,6 +873,12 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
>>                return;
>>
>>        dev0 = mlx5_lag_pf(ldev, first_idx)->dev;
>> +
>> +     ports = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
>> +                     sizeof(*ports), GFP_KERNEL);
>> +     if (!ports)
>> +             return;
> 
> [Severity: Medium]
> Before this patch, mlx5_modify_lag() could not fail once first_idx was
> valid. Now, if this kcalloc() fails, the function returns without a
> message and skips all of the following:
> 
>    _mlx5_modify_lag()
>    the v2p_map update
>    mlx5_lag_drop_rule_setup()
>    the MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE notifier
> 
> The drop-rule setup and the notifier are skipped even when the mapping has
> not changed.
> 
> mlx5_modify_lag() returns void, so its callers cannot see the failure or
> retry. That covers mlx5_do_bond() (called from mlx5_do_bond_work()) and
> mlx5_lag_set_port_affinity() in mp.c. By this point ldev->tracker already
> holds the new lower state.
> 
> Could the hardware TX affinity then keep pointing at a failed port until
> some unrelated bond event arrives?
> 
> The buffer is at most MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS = 128
> bytes. Could it stay on the stack, or be preallocated with v2p_map, so this
> path does not gain a new failure mode?

this isn't specific to the new allocation:
mlx5_modify_lag() already leaves the same state when
mlx5_infer_tx_affinity_mapping() or _mlx5_modify_lag() fails, and none
of its callers can retry.
The missing error handling is pre-existing and will be fixed separately
for all paths.


> 
>> +
>>        mlx5_infer_tx_affinity_mapping(tracker, ldev, ldev->buckets, ports);
> 
> [ ... ]
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com

