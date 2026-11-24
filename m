Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795518415;
	b=S9dpGk//cPnMzYihFOiQYahwLRAVNAievc0zZQbyaMKozvdCN3M9EQg9RS0hWZzEOgJe
	 +/NT3zQFKsvRDmxoOegttleza29GwDTRnsKneqvPZ7+jaU7BCT25hXO5oTzREWkIgtEQN
	 XEBMLT1CA8IKMU2qXcWrepTCWjeeUS0mF1VK70UdOtz8flzseW3nhuxyBL2jGO0QuHQ+j
	 5GrAfXq5gIbVvg3tuLBGH1DEa0fgT5aglrpOSjmhLNh7updMWaHwnhRdL1iL6dNSimsDz
	 ZKGTYgpUiTVx+v+ejx+0aTJtQsQuyVM34EiJsK8N3hts+/3zFDj8O+yaGpz627cqUiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518415;
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
	bh=5FfJ0+Y+nzh3rgacx4KX0cX/eSKbNbcNtoud14zOhlk=;
	b=KUxPLzzyB+lkkLrbysUBm1nPTlHcMODsD+NY5CxR/2X9Ot3uC0YLaDizDA7gSfcIwTxY
	 4ZusZ9BF2xE/3mtv8OZvjM93LzZGSHIuKRhmbCFN20vZ7ulEibkhHoRrnQ9ln/tThqnS8
	 8k0AGvM75WY3dVEa79yq8FeV5/4pKZJOVLoJJlLQbZ0EGHpJMvSgdncP41ST3MttNkvGz
	 2Cf9HcE6JWshKlL8eXGYo/mxPwbB1Yv07/D4+kwkj2P7cKOyNVerNq7vkDNAcTn+Jkrl4
	 SSCpwD6/rzZubjRMktPGLeBp3yd1mPzKGtD4oKW/eQ8SWmhL9l78W9LwZebnLBQSzbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tgxBcHWZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.27
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013027.outbound.protection.outlook.com [40.93.201.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802E606A321;
	Tue, 24 Nov 2026 11:06:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8802E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tgxBcHWZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CacvzLm854VnO64LQvZxGHPj4ycrFNEaGq0D+Eyl6s//6Kv9PCMn0+8DOT1jItPlKJFfhOCBaB4Rsn4TrVFqOwVEej2+4r1lHd4V3E1Bl1ZGkJPxbeI1kei9sJ04iPUcXCHatCYfl3NQ6VKJCewye6CVrvtgFyFwjIEyOMTENPp7XMQ6r5+Er1umF6nFjh8IeDdNvyaqvX6idJ9qnKTmIaJY84prPwNBI8CrJZqAbhGR0y01fHl7RiZ4Zsf5aQDnv0xLqMc+Qlw8EgEooqLHflSMUw/n+yiRzk3AqcSDibp5glKKV+Zv/53OsLOJiiPO2IS2tXtRSYTt6HGrVMMnHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FfJ0+Y+nzh3rgacx4KX0cX/eSKbNbcNtoud14zOhlk=;
 b=svYvTOfIjZcPNe1Hv1exaY0ajSXarm0voarl9I9yV9VsC6FKpF2XLr2X8J9PP3Olj/BOlGeiAJvmbgs32u6CfUyZzOiS2b/tIv/DLsmEtpSJEMgO4YgztTtgl3X04GCabHkS/wX2N2laOkMpGx6RTxMexqC6rucdKbbkHq73kG7zIEHuj9Xa/0qPpY3wahscNTzmBRUdpH9mDCJ70IjrIuv0xGiiZNC+/cJr91WcpoNsa+8zVuNd79AX6xjxBuZj9LU8agUS+rDZBP4SEZ+VzwUlA2XZ0pscpTFdReiVpSlK2tfxev1502E8WaX48KPPvoIOWX+oLPwh4shD5fdJUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FfJ0+Y+nzh3rgacx4KX0cX/eSKbNbcNtoud14zOhlk=;
 b=tgxBcHWZfmHo32iI+/DZy+FSSciZKHqV2GfaQ6mUKKBKzzVNmAjyRcRZZMwSZYn5O7K9xykIW3m7xCUF9jeX+m6VWZS+kmQMg9//U7q6I3ROjV1/Wep51vDXinJSBpThsbqid7fREqJAqMIZI1WmTVV4IMrnIUPscpmGsU0PaV3KXeeGOnjRCKFoBjFPuzvYXd2Lcrcagcrrv2gQ3Rn153GP1du1etd2CB4y+joQHt8w34YWJdAHKuyRJZ755qpvDMOFAfGk9sXSDJGezPg6TPLgzjQZ/tYeUu9s4DtQFtByFmQUKmzWJ32vGZac8+fzDjDKHe2PGFEvD+Iy77K7Dg==
Received: from CH0PR07CA0030.namprd07.prod.outlook.com (2603:10b6:610:32::35)
 by BL3PR12MB6379.namprd12.prod.outlook.com (2603:10b6:208:3b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 11:06:49 +0000
Received: from LV8PEPF0000005E.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::58) by CH0PR07CA0030.outlook.office365.com
 (2603:10b6:610:32::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.5 via Frontend Transport; Tue, 24
 Nov 2026 11:06:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 LV8PEPF0000005E.mail.protection.outlook.com (10.167.245.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 11:06:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 03:06:28 -0800
Received: from [10.125.204.85] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 03:06:22 -0800
Message-ID: <933d7cef-d995-479b-a24e-9c53d256290c@nvidia.com>
Date: Tue, 24 Nov 2026 13:06:19 +0200
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
Subject: Re: [PATCH net-next V2 5/5] net/mlx5: LAG, enable LAG over functions
 that do not represent a physical port
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <gal@nvidia.com>, <jgg@ziepe.ca>,
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>,
	<moshe@nvidia.com>, <ohartoov@nvidia.com>, <saeedm@nvidia.com>
References: <20261120075959.2533702-6-tariqt@nvidia.com>
 <179550917403.3135.6078772385370645877@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179550917403.3135.6078772385370645877@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005E:EE_|BL3PR12MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: 417cb936-07de-496b-854f-08df4a1b090b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|7416014|376014|261028144727099003|261102123227099003|261102130727099003|261021121427099003|261021135927099003|261026140227099003|261026121527099003|261022115727099003|261022105027099003|5023799004|11063799006|4143699003|56012099006|10067099003|261022075727099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	GJ2G+6eIWoD6tOudMiFDGfG3uSlp5QchZiEBXkjyLkItj3vftrCqK/Lan0bFkvgva3PYyQ58bsACwHkLnEWgDZkZH7UazTrQOD8NAINX8QZwqGEYydDk93XeJSlQUiwVWGJ3wFHsJtcVXJGRk6spV7Gnr8dA7sQwlipHBw1tDo0Uo2/LlGZmdMAQ+emSheIMcFEuJnbfziv8ZeMmbOcuxD+UEW3JjikMEwmz2i6jahRlDb2g46Yw6PU4cbCSOMxbDSKjuMTJEsU+nIGSGcy4QLScqqqeZovYQxR7anoE1bdhsN7VL60dAd7DfR443w4Zvk0gJQQmTTuXGaCRCgrA90VsGUlLl36B30pkRKUVEkND2n0tbeP1+KyOVZIK+DSXwJQ9oOjRcSicHGfHSX3VUsU86Ga+tRGliFOsMTq51GEuKVqcuYuIlde3KXJinPO7pqbAstfILNH71sUQUuP0lqHZ4V3iCEQaNpytVXuQx5Q9HlpFcMwAFZzK2DK2JHOKT695u229/uKd/RtdUmZrRYFvVgy3dAudwrYB5IvIQSGcpxNxUuSOo4Hxs1CZv9CnC1bmjqp+Nxl3XpInfCKoFOIwEpgRLqBo7lxVfcT++nr9a5teIje821f1hV7pYWGhWWTaEMtqMw6QKXBAtYWQQtSNRZ9BPfESbXYoR84+zBWkRq1eBJ1XmqUVSGigveb3JunyHXphrln+/QSzCvpR4A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(7416014)(376014)(261028144727099003)(261102123227099003)(261102130727099003)(261021121427099003)(261021135927099003)(261026140227099003)(261026121527099003)(261022115727099003)(261022105027099003)(5023799004)(11063799006)(4143699003)(56012099006)(10067099003)(261022075727099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f4MAYSAgrleOdYqfTCj7jpA0KiNHGXX7yoEq8LQEwyFIWRjrccJ917OzwfZdLzcyZiIGoiVG3o0u1CwD/PxVeyZvPCtg0IFdF3Y3oWsQvSuyBw8m/EKuslEaJYAH1aTyuL8CMGel9lnCIuUKYDCUcrooHwkJE6ZbXKeUvSaunEOVBx42DKp2WMnqvwIjEaqae8X8phXaXt/viMzMU0SDFYEvZ0a9aaYJNe50DxtZNsIBJrXLsOu7tVyymxMZmv51Bi2j5DvRkRRxqwb1CjyBpuuFFbdh/vVr7VejG7T7/fGvq5GsDHz3PN2JgGBWfoLopNqxUuxwDd0Ug0D5EtFF3b2B4LoT2A8Hy6PYr9u6eXxHNUK4nyOoxe/MAKUiAFdbve3IrWv+fLn+Of9BAdRqcg56Wy0gqPHPQPeJkG3D8HDigwcK2sZRY4950gGSLWOS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 11:06:48.4516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 417cb936-07de-496b-854f-08df4a1b090b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6379



On 24/11/2026 10:32, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] mlx5_lag_add_mdev() now lets any VF/SF that passes
>    mlx5_virt_lag_is_supported() into the LAG, and nothing caps how many…
> - [Medium] net/mlx5: LAG, empty debugfs member list in members_show() for
>    virt_lag
> - [Low] For a virt LAG, vport speed aggregation does nothing at all.
> - [Low] The commit message does not mention that the exported
>    mlx5_lag_is_mpesw() changes meaning.
> 
> --
> 
> net/mlx5: LAG, enable LAG over functions that do not represent a physical port
> 
> This patch lets VF/SF functions that sit behind a multi_uplink_eswitch
> (num_lag_ports < 2) join a LAG, using mlx5_virt_lag_is_supported() to
> detect them. Such members are not marked as ports. They do not register
> the PORT_CHANGE, netdev or multipath FIB notifiers, and they do not add
> netdevs to the LAG.
> 
> The patch also widens mlx5_lag_get_filter() and mlx5_lag_is_mpesw() for
> virt LAG, makes mlx5_lag_get_num_ports() return at least 1, and stops
> RDMA from assigning a TX port affinity for these functions.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 193fbe47fef15..2cd2319f93189 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> 
> [ ... ]
> 
>> @@ -2398,7 +2404,7 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>>        fn->group_id = group_id;
>>        dev->priv.lag = ldev;
>>
>> -     if (group_id)
>> +     if (group_id || ldev->virt_lag)
>>                return 0;
>>
>>        xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);
> 
> [Severity: Medium]
> Does this early return also leave the lag/members debugfs file empty
> for every virt LAG device?
> 
> mlx5_lag_add_mdev() now lets virt-LAG capable functions through. On
> success it calls mlx5_ldev_add_debugfs(dev), which creates the lag
> directory, including the members file.
> 
> members_show() in lag/debugfs.c lists the members with:
> 
>          mlx5_ldev_for_each(i, 0, ldev)
>                  seq_printf(file, "%s\n",
>                             dev_name(mlx5_lag_fn(ldev, i)->dev->device));
> 
> mlx5_ldev_for_each() uses MLX5_LAG_FILTER_PORTS, so
> mlx5_get_next_lag_func() only walks entries marked with
> MLX5_LAG_XA_MARK_PORT. A virt-LAG member returns here before
> xa_set_mark() runs, so no entry in ldev->fns carries the mark.
> Reading lag/members on such a device then always prints nothing, even
> when the LAG has members.
> 
> This patch already switched mlx5_lag_get_filter() to
> MLX5_LAG_FILTER_ALL for virt LAG because its members are not marked
> as ports. Should members_show() use the same per-device filter, or
> MLX5_LAG_FILTER_ALL when ldev->virt_lag is set, so the file reports
> the real members? Or is the members file not meant to exist for a
> virt LAG?

Left as is for now, since all VFs in the system share the LAG.

> 
> [Severity: Low]
> Because of this early return for virt_lag, no virt-LAG member ever gets
> MLX5_LAG_XA_MARK_PORT or the PORT_CHANGE notifier. Does that leave vport
> speed aggregation doing nothing for a virt LAG?
> 
> mlx5_lag_enable_mpesw() calls mlx5_lag_shared_fdb_create() with
> MLX5_LAG_FILTER_ALL, and that function then does:
> 
>          if (filter == MLX5_LAG_FILTER_PORTS || filter == MLX5_LAG_FILTER_ALL)
>                  mlx5_lag_set_vports_agg_speed(ldev);
> 
> mlx5_lag_set_vports_agg_speed(), mlx5_lag_get_devices_oper_speed() and
> mlx5_lag_get_devices_max_speed() all iterate with mlx5_ldev_for_each(),
> which only visits PORT-marked entries. For a virt LAG the summed speed
> is 0, and the loop that calls mlx5_lag_modify_device_vports_speed() runs
> zero times.
> 
> The skipped notifier, mlx5_lag_mpesw_port_change_event(), is the only
> place that queues speed_update_work. So nothing would refresh the speed
> later either.
> 
> Other virt-LAG paths in this series were moved to MLX5_LAG_FILTER_ALL
> (for example mlx5_lag_get_devcom_comp()). If speed aggregation is not
> meant to apply to virt LAG, should mlx5_lag_shared_fdb_create() skip the
> call explicitly? If it is meant to apply, should the speed helpers and
> the refresh trigger cover all members?

Right, for a virt LAG mlx5_lag_shared_fdb_create() should skip
mlx5_lag_set_vports_agg_speed() explicitly. Today the call has no
effect: virt LAG members are not PORT-marked, so no vport speed is
modified.
I think the explicit skip can be a follow-up cleanup rather than
respin.

> 
>> @@ -2547,7 +2553,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
>>   {
>>        int err;
>>
>> -     if (!mlx5_lag_is_supported(dev))
>> +     if (!mlx5_lag_is_supported(dev) && !mlx5_virt_lag_is_supported(dev))
>>                return;
>>
>>        if (mlx5_lag_register_hca_devcom_comp(dev))
> 
> [Severity: Medium]
> Can the retry loop below this check spin forever once a virt LAG has 255
> members?
> 
> mlx5_lag_add_mdev() gives up only on -EOPNOTSUPP:
> 
>          if (err == -EOPNOTSUPP) {
>                  mlx5_lag_unregister_hca_devcom_comp(dev);
>                  return;
>          }
>          if (err) {
>                  msleep(100);
>                  goto recheck;
>          }
> 
> The devcom match key comes from mlx5_query_nic_sw_system_image_guid().
> It is the system image GUID plus the load_balance_id and VF/SF flag
> bytes. So every virt-LAG capable SF (or VF) of the same NIC in the same
> netns would join the same ldev through __mlx5_lag_dev_add_mdev().
> 
> mlx5_ldev_add_mdev() allocates the slot with:
> 
>          err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
>                         GFP_KERNEL);
> 
> After 255 members this returns -EBUSY, and __mlx5_lag_dev_add_mdev()
> passes it back unchanged. This happens when MPESW is not yet active;
> otherwise the late-joiner -EOPNOTSUPP check returns first. The xarray
> stays full between iterations, so mlx5_load() for the 256th function
> would sleep and retry until some other member unloads.
> 
> An earlier patch in this series ("net/mlx5: E-switch, add match-metadata
> allocator for nested VF/SF eswitches") already mentions the 0-254 slot
> limit from this xa_alloc(). Before this patch, only vport_group_manager
> PFs with 2..MLX5_MAX_PORTS lag ports reached this path, so the limit
> could not be hit.
> 
> Should a permanent capacity error end the LAG join the same way
> -EOPNOTSUPP does, instead of being retried like a transient error?

The retry loop is pre-existing: mlx5_lag_add_mdev() retried every error
before this series as well, and no HW exposes this yet; -EBUSY can only
be returned by future HW. The fix will be sent to net as a separate
patch.

> 
> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
>> index 2d3e61541d8a1..0ef2d13d00968 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
>> @@ -336,7 +336,7 @@ bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev)
>>        struct mlx5_lag *ldev = mlx5_lag_dev(dev);
>>
>>        return ldev && ldev->mode == MLX5_LAG_MODE_MPESW &&
>> -            __mlx5_lag_dev_is_port(ldev, dev);
>> +            (ldev->virt_lag || __mlx5_lag_dev_is_port(ldev, dev));
>>   }
>>   EXPORT_SYMBOL(mlx5_lag_is_mpesw);
> 
> [Severity: Low]
> This isn't a bug, but the commit message does not say that the exported
> mlx5_lag_is_mpesw() now returns true for every virt-LAG member, not only
> for port-marked ones.
> 
> It also does not mention the change in mlx5_lag_get_filter():
> 
>          if (fn && (fn->group_id || ldev->virt_lag))
>                  return MLX5_LAG_FILTER_ALL;
> 
> With this change, mlx5_lag_get_dev_seq(), mlx5_lag_get_next_peer_mdev()
> and the related helpers walk all members of a virt LAG.
> 
> Several places call mlx5_lag_is_mpesw():
> 
>    - eswitch_offloads.c (uplink destination type)
>    - en_tc.c
>    - en/tc_tun.c
>    - ib_rep.c
>    - a devlink parameter getter in eswitch.c, which reports the value to
>      user space
> 
> Their behavior for VF/SF functions now changes. Could the commit message
> describe these two changes?
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com

