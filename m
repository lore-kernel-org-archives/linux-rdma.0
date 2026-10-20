Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792482278;
	b=CcHzaU83VQsLSMIUJIe+b1drde87pgaR8i4bvNvcTmqivk67UY24UM4owa/VWHTMx2qj
	 DrLOj4IdxY++C21GKgY9B1f6t6eJv0ALfT8VVICmCbteLe2VV7R3TQRkTX1drn4RpGrNc
	 v+ZzyCgIqsYoSHZyL1LkUvA/QxJBT+e5DC7DOkfEsb8wjgFNryQV5sqc3fL/l9b9Mo29t
	 2GBJfKs7iGxedowKy29J7bkwrZK583YzdAykTneGy1grAAYQglEGESvEqLLT7MnADR3Ca
	 un0dikKoTARqB1q9MwC4Vmcw45SC8i2o6SjkHwJV/u322a32Bkcp+6H+QwLpD7LBt+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482278;
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
	bh=Kk6CJHVtby9GFur+rax2ZFLgS0quKssMvzhf7Hagfdk=;
	b=DkdC3T22jA8Ri0VrBkraYa+EU3K6vDjJciLeSWVHGbfBMVTGht5bfaqWY1Cq6hwonMvh
	 0s4tXCKxEE9vhjyKIh5SBlKroRJR88xJj6+5Xdr0nW6JSVF87sox1rrhq/FF/0k7qTT4W
	 pW64J/ZaRA2rU/Nr3abD1mh7IagVTY4R2Bp/DFxqn3KUhWb15mI3X6kMIEQTHKovQPMGT
	 6XZrB3JvhOW0tJyCUtniTqV9oW8NC7VnvYS3F8MqL6xb/sy2Rup0ogh8OsQ0zWMBxn9kN
	 wUFHLVLSBOKWRFqwRfDHXtPMRi8VS37px64Nhhj5Qia3sHjHJiFrFYzKYLKO/zESrRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Njc+NJD5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.58
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C22C606A31B;
	Tue, 20 Oct 2026 07:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C22C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Njc+NJD5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5v0hYYHOsZQwhG3Bh53R8HxPNj+TlF5w0bMmoxooFRloqOrUbmsiI8Bs7FTr+x3xcWOhH9fDt79PB6ycUM7fth9KwABT0JlMH1i0CwQj/f/g4S+MflHTz1RQ41oOWVgOLHbtF1VH5lhWvnD69xidZ4ZRc4OgI3ivNcioprxSRs9PPl2RbXMGT0jJixV5kfh4dbINYbVYRZz67Rv0v+C+S8gOXEZiRnppozA3eZ/t6zfPMUGlg7djDbVljScR2JTi6Sli6nkAj1lWHv+csLumhZysoi9HTWav26cKpOOZkTVRt275V6AVqOx3nVo9+KnEOuGecMaarXm2pf9ps9ssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kk6CJHVtby9GFur+rax2ZFLgS0quKssMvzhf7Hagfdk=;
 b=KmVJUckvBdzk22pui42/h4bblkdUFPxLXOTpYhH1TZYLDaiuArnCFOPt06yPZe3eNu1uVIwKUwc//YNc5XCZTaxIAGNOydCWrkBxVUn9J8t6BMMDOihjaBTGKx7k6UP1iRUvUF1BbT27bly+eKTW89GjPP0kaQD+UFqOAq+QQY9kjmCYITsctyE7ud1nz0jNm6Vtphk/dPNLaPCjTNDjFjszOFbWw0yg0OS5Zu0RQisnq36/bwHqoCxszryk7SKGTaPqWLJh11bZR3jZrJuLHJUSvn9UYs58Ng7L5gZoToFYzwgcw0gwz/wYlbmo5mvZ3Rdq6+VuCtdrToMYhT6+JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk6CJHVtby9GFur+rax2ZFLgS0quKssMvzhf7Hagfdk=;
 b=Njc+NJD5H4PjpWozWZDEhrwbLOwgd5s/mIaOiTswtOrzSxZcBJ1f1eeja8eiY1CQYTByBODilDDbUQT8apyCaGzyEnMnYKryjkF807/NACiEv+KZpkqZOb065xc1dlMylj0Fy2O495ECgDkVZMnN7/7m9c1exdgs8TIR8p0eaaBYWMR0lDkPt9TV9s4XvieK1pgXgwUZ+/5fMhbvByXpR35uTdndouS3capgHplyEFWPhKudoq0YbW3/g8aJVmcykmKHQdTB9fcD4D8XiUNwu8CPLEo5QLzrKqB5ZJyO68HGBv52u9Ay+/KgXbDHCJybd19qtwhfs4cFL7tzHKCCzQ==
Received: from BN9PR03CA0226.namprd03.prod.outlook.com (2603:10b6:408:f8::21)
 by SA3PR12MB7922.namprd12.prod.outlook.com (2603:10b6:806:314::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Tue, 20 Oct
 2026 07:44:33 +0000
Received: from BN2PEPF0000A88E.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::83) by BN9PR03CA0226.outlook.office365.com
 (2603:10b6:408:f8::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.19 via Frontend Transport; Tue,
 20 Oct 2026 07:44:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A88E.mail.protection.outlook.com (10.167.248.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Tue, 20 Oct 2026 07:44:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 00:44:14 -0700
Received: from [10.242.141.178] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 20 Oct
 2026 00:44:09 -0700
Message-ID: <04e7fec0-80dc-4547-84e9-c6c44527d266@nvidia.com>
Date: Tue, 20 Oct 2026 10:44:07 +0300
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
Subject: Re: [PATCH net] net/mlx5: Fix lock dependency cycle on uplink unbind
 in switchdev mode
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <gal@nvidia.com>, <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<mbloch@nvidia.com>, <saeedm@nvidia.com>, <horms@kernel.org>
References: <20261015093419.1150837-1-tariqt@nvidia.com>
 <179240246962.3135.13700501362385534607@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179240246962.3135.13700501362385534607@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A88E:EE_|SA3PR12MB7922:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f32db68-854c-464d-b04f-08df2e7dfb47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|23010399003|376014|1800799024|36860700016|11063799006|5023799004|4143699003|56012099006|261009223027099003|10067099003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DXhQlYcqs+gRZnP8KwMpV7U4Y3iG3HLCeTlZfkPqyyl9UEYgTOgDP2vEWbaSu4GL4pO3yRCGqMA9ZuqUuI5NPLCoNGXImpj8GHq3TSQh78uAfmClQm/1QaltOoIxVyS+0wqvVEhvS2Iifpghu5Qm1EPbfVCVUyw4DMx2OLPkRuzz7ifP3U7IaJRpXoOsCOqMg+lWIfN7ksBQgoyL4+1INteN3v8SBUdPIiflq5UkpqqDx58h/+D/Vok5j2K8vg1OxQoqzgO0uCXLlN4nOBrqsOyDnvwJsSXALkuppibrQM/1YGHzropERTzEiNApkxU1SBjuf4evpEEXhH9mayOBzazwqpIKKQCkcpNvjEM+si3/fixk/Ri44oaNkWpnTx4Y3FYGQa0m2LBRU2+uP58v4NEkrErlfUjZgVOnMU5EK3tJCwps1H1SAL0yp0ChDh3tz50ichRWW7Os+KIUdmOPR1BJI5yrrhqZyLhqpqdFZxqM5fRLjK3nqXFocMfvgR8D+KitmsRFJoq/rP3LpUgQBk+HChg4Q+qnh8VV4eWHK2tqd6GkVTmuUznLrDbDnFHw8HTuRYscqJvTdBZ+c++xSXEIxkx8J1hp/mnnGUMUDmvoEvVuZZhu2+Cc0zL6rFwJlK7ynh5fnZAzWiieobZFyzy0ko1Kz7cs2n2VCWFMzDIKPbZm4URbny4BS2y52hD0hudFxmWsppWSfEoSfDudCg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(23010399003)(376014)(1800799024)(36860700016)(11063799006)(5023799004)(4143699003)(56012099006)(261009223027099003)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HsQ7uRMn6T7eoI5q7C0Dum54Fn/Ww6987KvggYVVLT3cWzNM6V6r4LXR2mDD2K5ftA1UrwfcEWK23Xv7ds+QGcCi9w03ILcddUE1Ef/+cKV6GYGk7KY9peJto2rcG+7OpX7UxV4JDpOtOJT51ZoM0FSkn61lkVnH/lacSA7ADy+U2ILozqicwM13Mr0D1DEpCo/U8UUHcMrW0BCh2HIterVvl3cviueYgELiqmLHiCSoMrJAEPbQuxaPpUJBjf5qEUVJHQ9hgafFvCn8+vrpXxj8BbYYCEK5NvmFOa8hRJqENdHVV41SnEzGuHnd26eOE+8r/xccyXkHKv/22XA6NdV58kJrXBNB1qc7sVEi/ztFJl4dBgZNbGx6sIct7BNaoYsUtzDaAocnlCkJCr3gqi5mEPpmvKozd59VxYSJz2Ob/y3/+hchvr/6+sZqDvih
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 07:44:32.9561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f32db68-854c-464d-b04f-08df2e7dfb47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A88E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7922



On 19/10/2026 12:34, netdev-bot+sashiko@kernel.org wrote:
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
> - [High] mlx5_eswitch_safe_aux_devs_remove() now sets
>    esw->eswitch_operation_in_progress = true, drops mode_lock, removes…
> - [Medium] The patch replaces the read trylock (mlx5_esw_hold(),
>    down_read_trylock) with a write trylock in esw_try_lock_ignore_users()…
> 
> --
> 
> net/mlx5: Fix lock dependency cycle on uplink unbind in switchdev mode
> 
> This patch stops mlx5_eswitch_safe_aux_devs_remove() from holding
> esw->mode_lock for read while it removes the REP aux devices. It now takes
> mode_lock for write through a new esw_try_lock_ignore_users() helper, sets
> eswitch_operation_in_progress, drops mode_lock, removes the REPs, and then
> retakes mode_lock to clear the flag.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> index eb74b6260168..f934cb2b26b0 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> @@ -4438,15 +4438,36 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
>>   #define MLX5_ESW_HOLD_TIMEOUT_MS 7000
>>   #define MLX5_ESW_HOLD_RETRY_DELAY_MS 500
>>
>> +/* Unlike mlx5_esw_try_lock(), don't refuse the lock over eswitch users.
>> + * Teardown must run even with TC flows still offloaded, as those are only
>> + * flushed once the REPs are removed.
>> + */
>> +static bool esw_try_lock_ignore_users(struct mlx5_eswitch *esw)
>> +{
>> +     if (!down_write_trylock(&esw->mode_lock))
>> +             return false;
>> +
>> +     if (esw->eswitch_operation_in_progress) {
>> +             up_write(&esw->mode_lock);
>> +             return false;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>>   void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
>>   {
>> +     struct mlx5_eswitch *esw = dev->priv.eswitch;
>>        unsigned long timeout;
>>        bool hold_esw = true;
>>
>> +     if (!mlx5_esw_allowed(esw))
>> +             return;
>> +
>>        /* Wait for any concurrent eswitch mode transition to complete. */
>> -     if (!mlx5_esw_hold(dev)) {
>> +     if (!esw_try_lock_ignore_users(esw)) {
>>                timeout = jiffies + msecs_to_jiffies(MLX5_ESW_HOLD_TIMEOUT_MS);
>> -             while (!mlx5_esw_hold(dev)) {
>> +             while (!esw_try_lock_ignore_users(esw)) {
>>                        if (!time_before(jiffies, timeout)) {
>>                                hold_esw = false;
>>                                break;
> 
> [Severity: Medium]
> Can concurrent TC flow insertion now make this loop time out?
> 
> The old mlx5_esw_hold() used down_read_trylock(), and other readers never
> block that. esw_try_lock_ignore_users() uses down_write_trylock(), which
> fails whenever any reader holds mode_lock.
> 
> mlx5e_configure_flower() holds mode_lock for read during the whole flow
> insert, FW commands included:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_configure_flower() {
>      ...
>          if (!mlx5_esw_hold(priv->mdev))
>                  return -EBUSY;
>      ...
> }
> 
> TC offload on the REPs doesn't take rtnl, so several of these can run at
> the same time. If flow inserts keep overlapping (for example under heavy
> OVS offload), every 500 ms poll could find a reader. After
> MLX5_ESW_HOLD_TIMEOUT_MS the loop sets hold_esw = false.
> 
> In that case the IB and ETH REP aux devices are never removed, and nothing
> is logged. _mlx5e_remove() then goes on to tear down the uplink:
> 
> _mlx5e_remove()
>      mlx5_eswitch_safe_aux_devs_remove(mdev);   <- REPs left bound
>      mlx5_core_uplink_netdev_set(mdev, NULL);
>      ...
>      unregister_netdev() / mlx5e_destroy_netdev()
> 
> The uplink REP and the IB REP still reference that netdev. Could this bring
> back the unregister_netdevice hang, or a later use of the freed netdev, that
> commit 2ae8c7edea87 fixed?
> 
>> @@ -4455,9 +4476,19 @@ void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
>>                }
>>        }
>>        if (hold_esw) {
>> +             /* Keep mode_lock and reps_lock unnested. The operation flag
>> +              * excludes mode users while mode_lock is dropped before the
>> +              * REPs removal takes reps_lock.
>> +              */
>> +             esw->eswitch_operation_in_progress = true;
>> +             mlx5_esw_unlock(esw);
>> +
>>                if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
>>                        mlx5_core_reps_aux_devs_remove(dev);
>> -             mlx5_esw_release(dev);
>> +
>> +             down_write(&esw->mode_lock);
>> +             esw->eswitch_operation_in_progress = false;
>> +             mlx5_esw_unlock(esw);
> 
> [Severity: High]
> Does this flag really keep other writers out while mode_lock is dropped?
> 
> The commit message says "The flag keeps excluding concurrent mode
> transitions and mode users while mode_lock is not held". However, several
> devlink paths take mode_lock with a plain down_write(). They set and later
> clear the flag without checking it first:
> 
> mlx5_devlink_eswitch_encap_mode_set() {
>          down_write(&esw->mode_lock);
>          ...
>          esw->eswitch_operation_in_progress = true;
>          up_write(&esw->mode_lock);
> 
>          esw_destroy_offloads_fdb_tables(esw);
>          ...
>          err = esw_create_offloads_fdb_tables(esw);
>          ...
>          down_write(&esw->mode_lock);
>          esw->eswitch_operation_in_progress = false;
>      ...
> }
> 
> mlx5_devlink_eswitch_inline_mode_set() does the same around
> mlx5_esw_vports_inline_set(). mlx5_devlink_switchdev_active_mode_change()
> does it around mlx5_esw_fdb_inactive() and mlx5_esw_fdb_active().
> mlx5_devlink_eswitch_mode_set() calls that function before it calls
> mlx5_esw_try_lock().
> 
> Before this patch, the read lock held across REP removal blocked all of
> these in down_write(). The other flag setters run under devl_lock. The
> unbind path (unbind_store->mlx5e_remove->_mlx5e_remove) doesn't take
> devl_lock, so this setter can overlap them.
> 
> One possible interleaving:
> 
> CPU0 (unbind)                        CPU1 (devlink encap-mode set)
> flag = true, up_write()
> mlx5_core_reps_aux_devs_remove()
>                                       down_write() succeeds
>                                       flag = true, up_write()
>                                       esw_destroy_offloads_fdb_tables()
> down_write()
> flag = false, up_write()
>                                       esw_create_offloads_fdb_tables()
> 
> Once CPU0 clears the flag, mlx5e_configure_flower()->mlx5_esw_hold() can
> succeed while CPU1 is still rebuilding the FDB tables.
> 
> The reverse order is possible too. If CPU1 finishes first, it clears the
> flag while CPU0 is still removing REPs. A later
> mlx5_devlink_eswitch_mode_set() can then pass mlx5_esw_try_lock() (when
> user_count is 0) and start a mode transition in the middle of REP removal.
> 
> CPU0 checked mlx5_eswitch_mode() without holding mode_lock. When it
> finishes, it also clears the flag that mode_set just raised.
> 
> This looks like a flag being used as a lock: set on entry and cleared on
> exit. Should the other writers check the flag before setting it, or should
> the bool be replaced with a real lock or a counter?

good find. will fix

pw-bot: cr

> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015093419.1150837-1-tariqt%40nvidia.com

