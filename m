Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409B440643;
	Mon, 28 Sep 2026 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607507; cv=fail; b=ZTrqs06acM8A2drog0KgfMoUZD1hzVz3ZyPyjzbTzo+ZfLVu+Iyt6gTw3w8LQWxQWozz1cf9/2dQqVrqcFroAbd4K+c1Vx9MONvdayUcuY460AwbYOcZ7Cs6uVY96ryNidV78PbEC/baQh/fHkSxDRt4pWcTqBBUnEgZxG229KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607507; c=relaxed/simple;
	bh=zdVGDcT1RqsoMzb8jzhc54NQ+lMTUgddQTujecHLVIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MatfXkXax8Pfc4Z3oh3qSoHz0cpoCn5aKmVg/y+Q44jokm4MbMa62NK+sVW4emStGs8IonxTnDPAwZ3/HyGhZrWim6yHwNUr9wd7xyul/wGOnTAxWolK8PtCvvY1oeqe99inbS5nqLnxeZziKLg7s/qpAZXZKTUJHsWDyw+nscI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DWTvIDCe; arc=fail smtp.client-ip=52.101.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DWTvIDCe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C7DgLls6MiJYufKpkCfUB04eGuHArcSP78Ky+hB61do043u4mzX/6YQxl2VYBDkRGKUxSx0LUZUxOwX3kcpspYYidO6LNxnOEmcWEoylpXIXw/1pNDUzBlTD9A59Ek+OIVjpOC0Vzv5M2KkqkaoVxyEB6qHnnYtYFdfoBbFmY/u8j2zJ+/xztLQyz9N1pa9c/rzrAI8L4BqDVTKwQ3af1tQGc3F5OBhDi96gfLr152ZWuCBcVSINPcwARbAX8p0aILjvrZvkEqQtOGGrXtictHJwjJx8ExlPkZN3Kxtiz2oTEqlCD2FjHSNRhRd18DSa9zz3l8rSDiG1XuEK6aeBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9svYTHV5iwHqO6EjmEew/FvaQZzR6b8l+sbbf1lopzY=;
 b=rA/xHxmcBkUY5dTK+TJ2PkXzIvLH73ch8ZuCs9JIYm2zGoHJn3oeGWysiFJpEAzjJgDtyzflQQxqommaFAhYt4m54981MDG5VQK4BTjAdR/ozgkV53E9qhRVeW5+ATpNmsvlGjRBkMLBrUQn/mouwOiKUr1gWqRwJ99xp1NFfQs7/XTsIxrzYrwx0B6RPOnr4SoC1dNmgmZnbSz7qhORnvOzCyMDYVpibKnafubKUFBqk6TaZkGPczCL1gDbmzg7YrT9TRsBonfKPrBmUVW1hd7b1chJhPKUVQU6I6lVkdAfaItTh1630hi3nxxCOLJHZRrhTVmsZ8uqLXwF3qCQpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9svYTHV5iwHqO6EjmEew/FvaQZzR6b8l+sbbf1lopzY=;
 b=DWTvIDCeYwTxQ8699fhZ9ia3Dyz3kVE69MuHz6SCsQn5H0z4ZtkMcC6xHQiBFm5x09pMRE9aVmuiU0qfdeZo2KGCPmEtUtLG74+GaYFMvqU4TUT6oFzC6apinFm4+ncRKZxHkoLT83tx43+y0WgrFpRXYUpyuFcv/z4CoZVk7OalGQroQsywxTRf8uPf3hAY8Dx4TGObhjlU6Gix+gGAM4Kq1KlHnm+1VtfsVf8SjTsyvy+3IWLWEO+E8K596vSTIlWLXtnWHi7sKtEedmhD9Fkxm1Ue3Pgah1wr1ZE9rbia2L5ICbcvBcuy2STz0QUCTDShQHtfDBG/SAUP019Ukw==
Received: from MW4PR04CA0244.namprd04.prod.outlook.com (2603:10b6:303:88::9)
 by DS2PR12MB432622.namprd12.prod.outlook.com (2603:10b6:8:70b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 14:58:22 +0000
Received: from MWH0EPF000C6184.namprd02.prod.outlook.com
 (2603:10b6:303:88:cafe::1e) by MW4PR04CA0244.outlook.office365.com
 (2603:10b6:303:88::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.24 via Frontend Transport; Mon,
 28 Sep 2026 14:58:21 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C6184.mail.protection.outlook.com (10.167.249.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 14:58:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 07:57:59 -0700
Received: from [10.221.193.26] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 07:57:54 -0700
Message-ID: <dd1f3603-28a9-48d3-ab4a-25cf51d4487e@nvidia.com>
Date: Mon, 28 Sep 2026 17:57:52 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 04/13] net/mlx5: LAG, allocate port-indexed
 scratch buffers dynamically
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <cratiu@nvidia.com>, <gal@nvidia.com>,
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <saeedm@nvidia.com>
References: <20260923103830.1183-5-tariqt@nvidia.com>
 <179027195585.2160803.1977712235305526325@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179027195585.2160803.1977712235305526325@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6184:EE_|DS2PR12MB432622:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e5ef6c3-b456-48df-4d4e-08df1d70f06f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700016|23010399003|10067099003|5023799004|11063799006|56012099006|6133799003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	/p1ud+EXn7XWUqAHenicqmGT+qu0Heqi6IUrLzVRPXvj+J7ek1aJZpc47VL0G/CQoR5YxWaeSi3luK+9o5trLLkZpxj9Q30hPvvTPIZkNBui2j6cIUMmisu+TUcbiqJG90oWSPd4B3ydpo7IHJejxoQrWUAMfG6njzO9AnsI1je2nmDXBQckmM0ISwJpgI/5a6c/+Mo/rUHpr+maW5TKLffpJoSKet15EMHjAWvJfQqzi4MhxKE00K2JFUatlDF0hifNRT9OsgTRKFzpx7kdhxnznR/FLNd/CLLOGOvdlSimzgrqkjbMOeQr1qY5Wgj2+H8oWWGk1yxcdXLL6pnwKlpVUKSuG9f5ncFNBzNbMZIcEZZWVJDZYFMQ3d12tnFQqXDBBeav4HXaSxHa7wDv/BXyj2K8FF9Ff+JqL/8LqrNnZPb1yn9R5DIf17u34uKo6RT+m6wN5/pEcmLQEaP1to8+LueLTl1Zmrnp4mdZT8KE+IefkjHaKoasNZIgq1zUDWCM0YM//lN2SFENxIvChP2dmPLVePkSDHxnvcUWzcjoRZnaBr8B4kZRpEEm/YO5xVdzzdUWN9a6xoQ442gPKmPm+hYX1asMMxofe3OYjqCg6kri4glvULhswXPtck3rqdcX/L30DEpbRrLv63dbSyq+DjDOT5rO53iDh+H7jqgvs/jZZcCQZduVX0xLw99eURzeg3fZDY7sC6C2X8W34w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700016)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dC231cydbr6kJ3e5uVLuq+4PuourBhqyo+Kfb9+Bzw5zibHFK5mnd08xo9e598NXN6S4YWDO5s86wQS6Hfqq+F16ERpKMbBoAqI70dg7wOkVL2tBTuqtVcoySBfEGn9XeUyW6qGA9swQSj3E1/AQ7IBCibXlTR8wMKGifxnX+Wkr6j5uoqBsMgWunQRsEOTE55LFxgsCvSCvS24z+81lXRABuqiRfW5NHKvjsuhYhCuF3qPmyZ4kA5BPd908Wt+P3IoL7Ah4gj64p/w5/H/8CpaKXI3/KdhsgkHBXzagIEI7hls2DssYTJPrpPFD/Y8s7G4oGX2Ee6C00+u7W1yv1QbmSH78k2UI6Dw/R1ANfEAT4q1QeJzSuUI6gvYjUXRJOtrLYiS4KYkYld8fU1iKYxOpFh+p80n+2vICSKAETswlY5YqJx+LRe+XB6hzmws8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 14:58:21.6290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5ef6c3-b456-48df-4d4e-08df1d70f06f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6184.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB432622



On 24/09/2026 20:45, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 0 (1)
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] _mlx5_modify_lag()
>    (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c) can now leave a…
> - [Medium] net/mlx5: heap buffer overflow in MLX5 LAG configuration
>    arrays
> 
> Pre-existing issues:
> - [Low] Concern: lag_active_port_bits() builds a bitmask of up to 8 bits
>    (MLX5_MAX_PORTS = 8), but mlx5_ifc_lagc_bits.active_port is only 4…
> 
> --
> 
> net/mlx5: LAG, allocate port-indexed scratch buffers dynamically
> 
> This patch replaces the MLX5_MAX_PORTS-sized stack arrays in
> lag_active_port_bits(), mlx5_lag_print_mapping() and
> mlx5_infer_tx_affinity_mapping() with kcalloc(ldev->ports, ...)
> allocations. lag_active_port_bits() and mlx5_infer_tx_affinity_mapping()
> now return int, and their callers get -ENOMEM on allocation failure.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 00b0159cb422f..93ead56641528 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> 
> [ ... ]
> 
>> @@ -105,13 +111,21 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
>>                MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[idx0]);
>>                MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[idx1]);
>>                break;
>> -     case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT:
>> +     case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT: {
>> +             u8 active_port;
>> +             int ret;
>> +
>>                if (!MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass))
>>                        break;
>>
>> -             MLX5_SET(lagc, lag_ctx, active_port,
>> -                      lag_active_port_bits(ldev, tracker));
>> +             ret = lag_active_port_bits(ldev, tracker);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             active_port = ret;
>> +             MLX5_SET(lagc, lag_ctx, active_port, active_port);
> 
> [Severity: Low]
> This is a pre-existing issue and was not introduced by this patch.
> lag_active_port_bits() can build a mask up to 8 bits wide
> (MLX5_MAX_PORTS is 8), but the lagc active_port field is only 4 bits wide:
> 
> include/linux/mlx5/mlx5_ifc.h:mlx5_ifc_lagc_bits {
>          ...
>          u8         reserved_at_20[0xc];
>          u8         active_port[0x4];
>          ...
> }
> 
> MLX5_SET() masks the value to the field width. Bits 4..7 would be
> silently dropped here, and also in mlx5_cmd_modify_active_port().

good find.
will push as a separate patch.

> 
> In hash LAG with port_select_flow_table_bypass, would ports 5..8 ever be
> reported to FW as active? It's not clear whether FW offers bypass on
> devices with more than 4 LAG ports.
> 
>>                break;
>> +     }
>>        default:
>>                break;
>>        }
> 
> [ ... ]
> 
>> @@ -816,7 +857,10 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev,
>>                    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
>>                        return ret;
>>
>> -             active_ports = lag_active_port_bits(ldev, tracker);
>> +             ret = lag_active_port_bits(ldev, tracker);
>> +             if (ret < 0)
>> +                     return ret;
> 
> [Severity: Medium]
> Can a failed kcalloc() in lag_active_port_bits() leave a hash-based LAG
> only partly reprogrammed?
> 
> By the time lag_active_port_bits() runs, mlx5_lag_port_sel_modify() has
> already rewritten the FT rule destinations in hardware:
> 
> _mlx5_modify_lag()
>    mlx5_lag_port_sel_modify(ldev, ports)
>      mlx5_lag_modify_definers_destinations()
>        __mlx5_lag_modify_definers_destinations()
>          mlx5_modify_rule_destination()
>    lag_active_port_bits()
>      kcalloc() fails -> return -ENOMEM
> 
> If that happens, mlx5_cmd_modify_active_port() is never sent. The FW
> active_port bitmask used by bypass traffic still lists the old active
> uplinks, which could include a port whose link just went down.
> 
> mlx5_modify_lag() then takes the error path and skips the v2p_map update:
> 
>          err = _mlx5_modify_lag(ldev, tracker, ports);
>          if (err) {
>                  ...
>                  goto out;
>          }
>          memcpy(ldev->v2p_map, ports,
>                 ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS);
> 
> Both mlx5_modify_lag() and __mlx5_lag_modify_definers_destinations()
> skip entries where ports[idx] == v2p_map[idx]. Suppose the tracker later
> returns to the state that matches the stale v2p_map. Would the FT rules
> then stay on the intermediate mapping, with nothing to reprogram them?
> 
> A FW failure in mlx5_cmd_modify_active_port() could already cause this
> before the patch. This patch adds a software failure point between the
> two hardware steps.

In that case I think this is more of pre-existing bug which can be
handled in a separate patch.

> 
> The bitmask doesn't seem to need a scratch buffer. Could it be built
> directly while walking mlx5_ldev_for_each()? Alternatively, could it be
> computed before mlx5_lag_port_sel_modify() touches the hardware?
> 
>> +             active_ports = ret;
>>
>>                return mlx5_cmd_modify_active_port(dev0, active_ports);
>>        }
> 
> [ ... ]
> 
>> @@ -668,20 +696,28 @@ static bool __mlx5_lag_is_sd_active(struct mlx5_lag *ldev,
>>    * If there are ports that are disabled fill the relevant slots
>>    * with mapping that points to active ports.
>>    */
>> -static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
>> -                                        struct mlx5_lag *ldev,
>> -                                        u8 buckets,
>> -                                        u8 *ports)
>> +static int mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
>> +                                       struct mlx5_lag *ldev,
>> +                                       u8 buckets,
>> +                                       u8 *ports)
>>   {
>> -     int disabled[MLX5_MAX_PORTS] = {};
>> -     int enabled[MLX5_MAX_PORTS] = {};
>>        int disabled_ports_num = 0;
>>        int enabled_ports_num = 0;
>> +     int *disabled;
>> +     int *enabled;
>> +     int err = 0;
>>        int idx;
>>        u32 rand;
>>        int i;
>>        int j;
>>
>> +     enabled = kcalloc(ldev->ports, sizeof(*enabled), GFP_KERNEL);
>> +     disabled = kcalloc(ldev->ports, sizeof(*disabled), GFP_KERNEL);
>> +     if (!enabled || !disabled) {
>> +             err = -ENOMEM;
>> +             goto out;
>> +     }
>> +
>>        mlx5_ldev_for_each(i, 0, ldev) {
>>                if (tracker->netdev_state[i].tx_enabled &&
>>                    tracker->netdev_state[i].link_up)
> 
> [Severity: Medium]
> The old stack arrays were sized by MLX5_MAX_PORTS, which is also the
> limit on how many entries ldev->pfs can hold. The new buffers are sized
> by ldev->ports instead. However, the loops that fill them still walk
> the xarray with mlx5_ldev_for_each() and index by a running count:
> 
> mlx5_infer_tx_affinity_mapping()
>    mlx5_ldev_for_each(i, 0, ldev)
>      enabled[enabled_ports_num++] = i;
>      or disabled[disabled_ports_num++] = i;
> 
> mlx5_infer_tx_enabled() / mlx5_infer_tx_disabled()
>    ports[(*num_enabled)++] = i;
> 
> None of these helpers checks the count against ldev->ports.
> 
> Is there anything that guarantees the number of PFs added to ldev->pfs
> never exceeds ldev->ports (num_lag_ports)?

Yes. mlx5_lag_check_prereq() will return false if the number of PFs in
ldev->pfs is different than ldev->ports.

> Suppose devcom pairs more
> functions sharing the same system image GUID than FW reported in
> num_lag_ports. Then these buffers would be written past the end of
> their kcalloc() allocations:
> 
>    enabled[] and disabled[] in mlx5_infer_tx_affinity_mapping()
>    enabled_ports in lag_active_port_bits()
>    enabled_ports in mlx5_lag_print_mapping()
> 
> Before this patch the same situation stayed inside the MLX5_MAX_PORTS
> stack arrays.
> 
> The same applies to buf in mlx5_lag_print_mapping(). It is now sized
> ldev->ports * 10 + 1, but the non-hash branch emits one " port %d:%d"
> per iterated port and bucket, so an extra PF would push the
> scnprintf() writes past the allocation.
> 
> If the invariant holds, could it be enforced where a PF is added to
> ldev->pfs? Alternatively, could these loops bound the count by
> ldev->ports, so an unexpected extra PF can't turn into a heap
> overwrite?
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com

