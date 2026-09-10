Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1708C49BD62;
	Thu, 10 Sep 2026 14:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050417; cv=fail; b=cgiyXqBZQmTBOIzO5sWR677pGLHon7avMkt9bWv7wCp6wLv6mVDBQeb1akcHOOYfd02Rli/pgH9pspWV6eYVPOekAAQLqoROZo7jqFQy56INTs7yIU7Rla03KxWvOHFxLshKHp0ZydsJcflALLQ9oDZ35P+Y2M+rMXZwyFFfU7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050417; c=relaxed/simple;
	bh=4BvKkmv+emnA34DTOPuaXnuUFUQhgzlZYaHFmYYdW7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QBRwADW3W9s8kHjXTtkiTDGMR1gaddN1LNodtXl5B8lD5lpWtNFT87KmPzZnl0MyeeVzgwgaGnIL2S8D2Abz+Bu8u3Z7NyhllLDfyJUhxfSyCiY0uXIFau4foByXXsWbefbL0znfbC4j+zcg4Phn1CbwaYneBwXCBS2YhU9Iis8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I5MswDZc; arc=fail smtp.client-ip=52.101.62.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I5MswDZc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FK+QEFLKHcZe/b9QidcKHAMaqB13Fco42sxkzVsDNC4YsKMKxCCqiUTVEWVij26E3QDXy8lA0lWd+tJLpH4ajf4vzlm/NY6Jx/YsMkdQQOSKYS512KTv7VprhFmWRxiCVsXJoTQ0IbAca8E2uWuozEv45no1F43pIeev3F2Z4rJuBq/Dy64lKd7xE0VxNRc2BGSE3A22Bw8tzwvKjjqgGgv5JvhxQWRZsRIdCILTdx5Y6EJTqfB7d/zKPhD3E4VD7Ro27PNFlcu5baSX/QqaMM+wizfXZm2AtRJWHLyuH2R7Q82v0bX8Ql4xCEc6YH+r9DO0IFvYdm8ozvW/hyt1mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ELQ973Fa1wpmw9ENkEa9lulBRF/WeCw8HGplDFxVAT4=;
 b=Jsw9PJkrKK0jgb908cWnKzU7gR2mN7WzSP65Mh2v6OD57zse10MfISfDpp0MBwI00hOU3l2Bz727oUsqGEbBNdY47Y4BIS8LK8JQbb+Cfdfuj7SBxfYiDFo3LbZtdGpCnedOS5j5pk2gqTsrc3yKp2xYeStoj6Oy5PzR0+4y42nZ7LUbNcMKYhpBQcAljFOiQMhKUmoLJyHPFQLYb/xA18c213Ifq3YWKIebyRfQ909h6Vgb/127hwTBiDvmjRTpxyLr9ZOWY2xvkQNv3LAlUkBBMT8MomVcgw0Jtbc3L2W+GtDWHFVos8D9mxaGMSNe5XPb+nZQkuJBN+vG3CoJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELQ973Fa1wpmw9ENkEa9lulBRF/WeCw8HGplDFxVAT4=;
 b=I5MswDZcKr+GyHR2huZTNxw6f/xqcGsJ7VFoK+ENCD8Q+FPutRBoVYy5g/iG7DvnhXzg9hcoI6fy9P9LdpKxX7Zbflzt0kHGPyxZSaQW8ESHaa9cBnpfwirfNMEM4bAJyTOwYi4s5RN4A3l34t6eEUiOYbh+SsZdKZ9OLyugK46a7YxyJ61co/62VpxkOHZe6y2/HpGZZWrsrEgi59kMOYnJTWvhNwfa0vmjk6K9M68R4I97XvOqQRYc9u1tmAyPuCZPVTdJ0mP5vlnu0RfFFGGURnODqVr/+T7kwFIxzLen1Vi0OTqJEdTqBXZy6nbfKV6wk6D0YfiU4st8Jm5eHg==
Received: from PH1PEPF000132E6.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::26)
 by PH7PR12MB9101.namprd12.prod.outlook.com (2603:10b6:510:2f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 14:26:42 +0000
Received: from SJ1PEPF000023D8.namprd21.prod.outlook.com
 (2a01:111:f403:c902::13) by PH1PEPF000132E6.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 14:26:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023D8.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.0 via Frontend Transport; Thu, 10 Sep 2026 14:26:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 07:26:12 -0700
Received: from [10.221.192.238] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 07:26:05 -0700
Message-ID: <d02134b9-d63a-4474-bfb6-7cfde2533f82@nvidia.com>
Date: Thu, 10 Sep 2026 17:26:02 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 1/4] net/mlx5: SD, serialize SD LAG init/cleanup
 against LAG mode changes
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <edwards@nvidia.com>, <gal@nvidia.com>,
	<kees@kernel.org>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <msanalla@nvidia.com>, <mbloch@nvidia.com>,
	<ohartoov@nvidia.com>, <parav@nvidia.com>, <phaddad@nvidia.com>,
	<saeedm@nvidia.com>, <horms@kernel.org>
References: <20260906071332.3759199-2-tariqt@nvidia.com>
 <178895614406.219967.15894719869066376557@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <178895614406.219967.15894719869066376557@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D8:EE_|PH7PR12MB9101:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a4483cd-bc7b-4640-030c-08df0f478912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|82310400026|36860700016|1800799024|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mHhX9M2RcVfWzE36XWYAjTlKrfdfuLeo9nT7SOtKuCI6w+STETIuGCa2DcE68LQfrwZXdibqBbv8edKPm8ptnKsZOXTYrSNqh/G9YDi41ZVSk3kd6hZPAUKZILBtovsNoLYzVZi/SnJMW4V+0itTvz3fUHXEfkRnha2mtFzyPO0+klHd6yMRprdHDz390i0OXD2St+RZ8kMVsG65vszocVA5iq4l0/hxIrT54DCkFO4OOEHFdtQnnBcJnRn94gB6iWrNF6qdD/6LoIxliNS6l7fTNM1q+a8k+/0EGqW1kW4OS2mUXiYzpNzEXcCNYnI2KYZAapI/TA9FfhAMOTps/zyWu6SuC82kH+wK6VCdELasjIPr3lLKFEHxO0J7HdECZQDhDamiXAzaF0sq3wyf+OguwwhLPtwCm4vJxj5rFupSOf4GbptXYRLP5I55SbXO7Wh17tZTMS1sZeMeDeQrUxe/Q3yfgWOKiPs924yK+Ly9EZpQyB5tp4bs3Ll8pJXqy4ePiUrneMffDNPCeEKQ7fDgR96wazA/nDhU84pUYKE43hDNNvNVk6BQjDjN02T2E1bzshadf28PKUke2Xxi2FR7hBSZN+8b66OA3BST7nJ2l/7T53drNvKf8PkVrmCsfE9p/kSPBkNLeKYJmktFPxwqlBBn7bX75FlWGBWaErgmwjbErkx11HAgFgKhxiW0gss7/5CsOFBQOvAW1TG2qA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(82310400026)(36860700016)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kCBUhuDZ6NQqPyXT6BG4MIzA351kYuU0+wvO0vMEPDGRYE7mitpQqblXRDNDTwR2b7ieiYq45PsDonK1sZvFvfneB4b76GfsOyC11+VpevOgBKFsSo4yPvHYwNLOlSV5LzlnK/uUtCuw6vbnDjMac5gTon/WyG0IF0wJGTLXCkG4iGcsOwoVlV8xeGq2efunVG46CkXKdiVPJnCuRvBcY42XmSG8q1eopOhWjPxDG5Dw84hZjRnDvT5MOOP3sUU/W7gmsx+OcSuFuoyDy6xgC5VCxHWghQf1ZJYs7t9iZ530q6ND5bhnOwpJlK7R+2Wy44cOivmBIJq+uuIlexZlxavuvr/9l2m3vP3BmiNjrwpIPa/XWuaurZ/5D1GrQEJYa6oGxg8rnSvL71WMOJILB+meca9ATxSDZKXZ0NCEG2i546rXf/1sjjpGvSL1d8zu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 14:26:42.6393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4483cd-bc7b-4640-030c-08df0f478912
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9101



On 09/09/2026 15:15, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 1 · Medium: 0 (1) · Low: 0
> 
> - [High] New unbounded `msleep(100)` wait loops in `sd_lag_init()` and
>    `sd_lag_cleanup()` (drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c)…
> 
> Pre-existing issues:
> - [Medium] `sd_lag_cleanup()`
>    (drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c:386-412) dismantles…
> 
> --
> 
> net/mlx5: SD, serialize SD LAG init/cleanup against LAG mode changes
> 
> This makes sd_lag_init() and sd_lag_cleanup() wait for
> ldev->mode_changes_in_progress to reach zero before touching ldev, folds
> the SD shared-FDB teardown in mlx5_lag_disable_change() into the main
> locked section, and moves mlx5_sd_eswitch_mode_set() in
> mlx5_eswitch_disable() after mlx5_lag_enable_change(). A couple of
> questions below about the new wait loop and about the group_id handling in
> the relocated teardown loop.
> 
> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 2285c889c215e..aee5ce471eba7 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> @@ -2589,6 +2589,8 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
>>        mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
>>        if (mpesw)
>>                mlx5_mpesw_sd_devcoms_lock(ldev);
>> +     else if (sd_devcom)
>> +             mlx5_devcom_comp_lock(sd_devcom);
>>        mutex_lock(&ldev->lock);
>>
>>        ldev->mode_changes_in_progress++;
>> @@ -2599,26 +2601,22 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
>>                        mlx5_disable_lag(ldev);
>>        }
>>
>> +     if (sd_devcom) {
>> +             mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
>> +                     pf = mlx5_lag_pf(ldev, i);
>> +                     if (pf->dev == dev && pf->sd_fdb_active) {
>> +                             mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
>> +                             break;
>> +                     }
>> +             }
>> +     }
> 
> [Severity: Medium]
> 
> This is a pre-existing issue and not introduced by this patch, but since
> the loop is being relocated here: pf->group_id is passed to
> mlx5_lag_shared_fdb_destroy() without checking that it is non-zero, and
> mlx5_lag_shared_fdb_destroy() in lag/shared_fdb.c treats zero as
> "everything":
> 
>          u32 filter = group_id ? group_id : MLX5_LAG_FILTER_ALL;
>          ...
>          if (filter == MLX5_LAG_FILTER_PORTS || filter == MLX5_LAG_FILTER_ALL) {
>                  err = mlx5_deactivate_lag(ldev);
> 
> while lag.h documents group_id 0 as "not SD":
> 
>          u32 group_id;        /* SD group ID, 0 = not SD */
>          bool sd_fdb_active;  /* set on all SD group members */
> 
> sd_lag_cleanup() zeroes group_id but never looks at sd_fdb_active, and
> mlx5_lag_shared_fdb_create() sets sd_fdb_active on every member of the
> group, so the primary can be left with sd_fdb_active == true and
> group_id == 0. sd_lag_init()'s error path produces the same combination.
> 
> Do the normal teardown paths hide this because
> mlx5_unload_one_devl_locked() calls mlx5_eswitch_disable() before
> mlx5_detach_device(), so sd_fdb_active is already false by the time
> sd_lag_cleanup() runs?
> 
> What happens on a manual auxiliary driver unbind, where mlx5e_remove() ->
> mlx5_sd_cleanup() -> sd_lag_cleanup() runs with the eswitch still in
> switchdev and the SD shared FDB armed? From there it looks like the
> per-group single-FDB association, the peer-miss rules and the secondary
> FDB-root alias are left installed, sd_cmd_unset_secondary() goes on to
> silence the secondary TX root and destroy the alias flow table object, and
> a later mlx5_lag_disable_change() reaching the loop above with
> group_id == 0 would take the MLX5_LAG_FILTER_ALL / mlx5_deactivate_lag()
> path rather than the SD group path.
> 
> Would it make sense for sd_lag_cleanup() to call
> mlx5_lag_shared_fdb_destroy(ldev, group_id) (or at least warn when
> sd_fdb_active is set) before erasing the group's lag_func entries?
> 
>> +
>>        mutex_unlock(&ldev->lock);
>>        if (mpesw)
>>                mlx5_mpesw_sd_devcoms_unlock(ldev);
>> +     else if (sd_devcom)
>> +             mlx5_devcom_comp_unlock(sd_devcom);
>>        mlx5_devcom_comp_unlock(primary->priv.hca_devcom_comp);
>> -
>> -     if (!sd_devcom)
>> -             return;
>> -
>> -     /* Teardown SD shared FDB for this device's group if active */
>> -     mlx5_devcom_comp_lock(sd_devcom);
>> -     mutex_lock(&ldev->lock);
>> -     mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
>> -             pf = mlx5_lag_pf(ldev, i);
>> -             if (pf->dev == dev && pf->sd_fdb_active) {
>> -                     mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
>> -                     break;
>> -             }
>> -     }
>> -     mutex_unlock(&ldev->lock);
>> -     mlx5_devcom_comp_unlock(sd_devcom);
>>   }
>>
>>   void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
>> index 4cdc50cd6f038..99cf455a61e1a 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
>> @@ -345,7 +345,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
>>                return;
>>        }
>>
>> +recheck:
>>        mutex_lock(&ldev->lock);
>> +     if (ldev->mode_changes_in_progress) {
>> +             mutex_unlock(&ldev->lock);
>> +             msleep(100);
>> +             goto recheck;
>> +     }
>> +
> 
> [Severity: High]
> 
> Can this loop sleep while holding the locks that the mode-change thread
> needs in order to make progress?
> 
> sd_lag_init() is called from mlx5_sd_init() with sd->devcom held, and
> mlx5_sd_init() itself runs from adrv->probe/resume, i.e. inside the
> hca_devcom_comp write semaphore taken by mlx5_attach_device() /
> mlx5_register_device(). The same is true of the copy of this loop in
> sd_lag_cleanup(), reached via mlx5_detach_device() -> mlx5e_suspend() /
> mlx5e_remove() -> mlx5_sd_cleanup(). So the msleep() poll runs with two
> devcom write semaphores held.
> 
> On the other side, mlx5_lag_disable_change() raises
> mode_changes_in_progress and then drops every lock, and code running
> inside that window re-takes hca_devcom_comp:
> 
> mlx5_devlink_eswitch_mode_set()
>    mlx5_lag_disable_change(esw->dev)   /* mode_changes_in_progress++, locks dropped */
>    esw_offloads_start()
>      esw_mode_change()
>        mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp)  /* blocks */
>    mlx5_lag_enable_change(esw->dev)    /* never reached, counter stays > 0 */
> 
> and mlx5_devcom_comp_lock() is a write semaphore shared by all devices
> matching the same sw system image GUID:
> 
> drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c:
> void mlx5_devcom_comp_lock(struct mlx5_devcom_comp_dev *devcom)
> {
>          if (!devcom)
>                  return;
>          down_write(&devcom->comp->sem);
> }
> 
> The two threads can be on different devlink instances (mode change on one
> PF, aux probe/remove on another PF of the same ldev), so the devlink lock
> does not serialize them. msleep() is uninterruptible and the loop has no
> timeout or bail-out, and since the wait is a poll on a plain int it is
> also invisible to lockdep.
> 
> The commit message says the new loop is "mirroring mlx5_lag_remove_mdev()"
> - mlx5_lag_remove_mdev() polls the same counter but holds no devcom
> semaphore. Is the mirror still valid for callers that do hold sd->devcom
> and hca_devcom_comp?


This is a real finding and the fix needs a new approach.
I am dropping this patch.

> 
>>        pf = mlx5_lag_pf_by_dev(ldev, primary);
>>        if (!pf) {
>>                sd_warn(primary, "%s: primary not registered in ldev, skipping\n",
>> @@ -388,7 +395,13 @@ static void sd_lag_cleanup(struct mlx5_core_dev *dev)
>>        if (!ldev)
>>                return;
>>
>> +recheck:
>>        mutex_lock(&ldev->lock);
>> +     if (ldev->mode_changes_in_progress) {
>> +             mutex_unlock(&ldev->lock);
>> +             msleep(100);
>> +             goto recheck;
>> +     }
>>        mlx5_sd_for_each_secondary(i, primary, pos)
>>                mlx5_ldev_remove_mdev(ldev, pos);
>>
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906071332.3759199-1-tariqt%40nvidia.com

