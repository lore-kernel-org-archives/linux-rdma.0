Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795077678;
	b=3YX7mlWCBzOt14xGSsMdz17vcEoO/kcNrt1gQrljfefzYjb6hcQo3h/2i3XZ2BewoXpg
	 H4Evm/lhTRtFM0dvb8Snm7YoPnrwES+CJ7RT8Vkc7h/fXAhN4PgyVwx/SU0wAdnYdq3ua
	 wGW5mS1daY4HP908RPp7xf7TyhKCscZ4brcBJ0/rS52VCmV2nApVWVWnTVEyiKzDaznE3
	 zEXr5QPQ0ZySZxVxdStv7D+NcJHWu1rhwPZYh0QpvDvBpiUClywi8nBtI6M+CObD/3Gd5
	 wMaIfNjT5anKYcmYVjlaigDtSuajPYFLvGRpCgSkhsnhijDYN3WKAk3DjBnjJZpWWfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077678;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=HaSh8DCHFUMHh9Ws85B18yd5Etf04jneBGkKg+rxRnE=;
	b=omTKdPzO++Ngfhg88pIpMZlSAovfm8ddP/IBF3xso0vdQUUXwAOFXJWCc+wfsGzcvhIy
	 SyP/XkBnjxPwMWs7zuYT5yuUbpkYZ8/Jac1Pil0DV6WsNDdv0XbRKTyohZM+zLOtcZLrL
	 vuU6eu4LTgPw8oIIqUAZPOnryOWNu4GFPXzhomv9eerrjovd3icNi//WDvsSqg30Qw3+9
	 pvCMJYW3n5F2V0whbRX9BsT3BDuWbqUHmIk2BlNNMeyy0Xido4GNmC+91FqONvGDcFnTc
	 CFNMqF2e4M7bNSODF8ybEWyMJ/Gj/T0bvScOY5wM7Fb3jxPnejc8R/uiXBZgUsCu9Pg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=giEZ6p4g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.35
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F4B606A331;
	Thu, 19 Nov 2026 08:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25F4B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=giEZ6p4g
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGqG0DbEKrkrNr0DGnlRoM2Kw7RSLMPcS4ZHgbb6k7cfdRRnPa8amuE6jd+2YTunKrBh7dsldhZv7a5ICutgMogQ5e2DBHbz9nrpkHdtCC4zn2vc+laYXqorDLvq5KY43O6VRvzfsgL4GyjYVK2W119OZlrF9lallLYtCCtWNByrZ+07Tl93ukNsjTh+9kscNd3z91pZgfw5Xkjk6qJu/de8XMR9DqhMgnhovZ8xCMvA9hNQNDYz08e37IMQD8vsCbwGoNab+O1E4SwWz9FgGsmoyNOFUxg05iLnC0SZlSW8QidIxnfQH9FWPbtE100SA8a3TzWOzB4UBjINl9gxRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaSh8DCHFUMHh9Ws85B18yd5Etf04jneBGkKg+rxRnE=;
 b=x3rbP+KH81FhNEhgUXdoHywkmTIvl8E2SuDjBCGb74Ll9xbqMtbfXebo9/Jysu0jfGvSeiOVDBg03dC6XYvMxWyS1MvsBVeGbcwKZhV0WrgPeRkC3eJ62UFLm7y9Ro/pvYAC2peRSL7DL02rladAH6gY1QrTGgkm1KqP5W977L7E7GMdG4YFq3ABmVQCqKrkG0/O/AFSxRH30k+iaBYYOxSLJhYoBPxfFoASjjlTHxn87X4P5fygguOmUAc4itZTStUd4q6zDHezlZrRF5nnB5uKNU3qfG7VYYdWrpoeAAhGhVl0Uw6IjfnqbYVhYvU+T92ZPndMI4D2VaiMZNdo+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaSh8DCHFUMHh9Ws85B18yd5Etf04jneBGkKg+rxRnE=;
 b=giEZ6p4g1bLH68TykuPK0LB5EqCii02hmYhJpSTSPzCXzyAYGsPjCb7avr9K9O3UGc/yrAXYZvCC9gJb6IuQ9L3iUP2gymchW8ciaNA5FIdOgiezQGjOMPqDw9/4OkF4gmauUlmY5Yo4lZb76dhJgkqMkaAhdDs99DnIJxEv1exFCEkjCOYA8KSl6fieAOafT3vkKXFJGL9eRKQJ7EWUinPIuc67jox1HAgprqLzWpx4tsXWs04QCtYI8oBJ0t8Migq8xo5uPb5AnFRqD0jhQYjfVr98P6wd4z2duEALsjEC45I3WeWEmTRweXZmPhNrrRqbzG0M+1l8uqfWZ1sfCw==
Received: from PH8P221CA0061.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::17)
 by LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 08:41:13 +0000
Received: from MW1PEPF0001888D.namprd03.prod.outlook.com
 (2603:10b6:510:349:cafe::30) by PH8P221CA0061.outlook.office365.com
 (2603:10b6:510:349::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 08:41:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MW1PEPF0001888D.mail.protection.outlook.com (10.167.249.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 08:41:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 00:40:57 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 19 Nov 2026 00:40:50 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sashiko@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <phaddad@nvidia.com>, <saeedm@nvidia.com>,
	<udar@nvidia.com>
Subject: Re: [PATCH net-next V2 09/10] net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan
Date: Thu, 19 Nov 2026 10:40:42 +0200
Message-ID: <20261119084042.1589375-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179499791924.3136.16901930891335328702@kernel.org>
References: <20261116103010.1129666-1-tariqt@nvidia.com> <20261116103010.1129666-10-tariqt@nvidia.com> <179499791924.3136.16901930891335328702@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001888D:EE_|LV2PR12MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 69cd48d7-d217-4874-e223-08df4618de14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026|23010399003|261026121527099003|4143699003|261028144727099003|56012099006|11063799006|10067099003|261026140227099003|261022105027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iqLTU7b1raaPNLeRrpK/o3Q9Ih66JY70D34A3Nab9YbHPSXLJltWySqk1vBcimUc+Up9WkCQqyQNYkLVtITZSDwLTYuQrJYF1NH36boOZtzu7NJuJ9dxQxt8DzgyHINqVhkIjzktX9mAvwqBA04Cng87KQIupr5BqiyRfmm4QryjXuqxmpEk9DShax44T5akhMI5uOhJaSxh+uH4pmBtVI4pfnv7Z05lFi9z/UIvtT+DEol6MGNlPEJ0YR5N3LjcwY8D8CBwS+pjT1vPlfUM7hiwisppiKMoQhzUPBkgnlpV6iW/bq7fbQYzvK2PTTzDnug2XBwRU0e+i7xGrnkl57DCWSt+zFFT7xxh8LVtKPL+ehDTNSHxS4DoKlynA3EAzwfXLJasDNb5P307dIG55S7h4k/ErQAz6Z1syEUxNPr+tMZ/KDikvqzvI2iIqwCYvjelBeDdY7/IErrA3V8tgRU6PB7Jk7aFbA5v1HKj2z9awa2qkGnckIqRaGcPl5HnMrhyO3AKxG7dPNHiE5Tj5urIGaINt8ZlxhbBaSRN1YhM4TSSJ+VVScIct65E7fgZJFCE+HrSktTyhdLme9nxHWMFa81QzjKRHObx4XpdrWctUGy5keozxe2FKvOk7+5saDLTh8rcprHuv5ytos4mdPXS779ttTvl3FyzDp61H20UVq+mwNHqjE3Lr6FaaMgVSvEBvqyi5qeyv7zHyUpo+w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026)(23010399003)(261026121527099003)(4143699003)(261028144727099003)(56012099006)(11063799006)(10067099003)(261026140227099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FVP4ztK4KXzZ1/G2W7rA5WgScGBzzPU3j0y5+sLpoTi4r8Q834kNvrGLhaioD4ioimIbghKxAlr1BC2gQejHphwOPvLncS1ZwEBbHC+NMepEoiPS3f5tbdO+4ecCqhddkIPyAzijAmLVk3VmezXP8GC6WF/0YTelsbgyFq1jL8hZFE0Uar2Um2ysZ6YwPHeQeXfWyaJQJ2cQBct/AV5BPTRmhtfd8UU2/w799A7bZ9VbmIGH7jMYTylLKirf+UwWFOihKkE3Fndc53RrChiIwjHXsZtg9tjaE7vmiiOMN+Sr/GZAnk+OA48gzbHwqQL60rfyO6tpy9C0WvBVSMrxyfGaaE+HwifNgUQVZdaeH4JZouzkhl7jOp2USUQ6AQCkvVNITuuFx0pLi9rG+m7uCjzu1GE6Ab3Znsc0R/LIcmXz5unpiGXrKWA3ScRu8oPz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 08:41:12.7947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69cd48d7-d217-4874-e223-08df4618de14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001888D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5869

On Wed, 18 Nov 2026 10:31:59 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] In mlx5_lag_rescan_devices_locked_filter()
>   (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c), this patch…
>
> --
>
> net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan
>
> This commit removes the devs[MLX5_MAX_PORTS] array from
> mlx5_lag_rescan_devices_locked_filter(). The post-unlock rescan loop now
> walks the LAG members again with mlx5_lag_for_each(). The commit message
> describes this as having no functional change.
>
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> > index a7b12353b7225..3e88b3f51612e 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>
> [ ... ]
>
> > @@ -1356,12 +1354,16 @@ static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
> >  			fn->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
> >  		else
> >  			fn->dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
> > -		devs[num_devs++] = fn->dev;
> >  	}
> >
> >  	mlx5_lag_drop_lock_for_reps(ldev, filter);
> > -	for (i = 0; i < num_devs; i++)
> > -		mlx5_rescan_drivers_locked(devs[i]);
> > +	mlx5_lag_for_each(i, 0, ldev, filter) {
> > +		fn = mlx5_lag_fn(ldev, i);
> > +		if (fn->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
> > +			continue;
> > +
> > +		mlx5_rescan_drivers_locked(fn->dev);
> > +	}
>
> [Severity: High]
> This loop now walks ldev->fns after mlx5_lag_drop_lock_for_reps() has
> released ldev->lock. Can a concurrent SD member removal free a lag_fn
> while the walk is in progress?

Valid. The race between SD join/leave and a LAG transition that drops
ldev->lock is pre-existing; SD join/leave doesn't observe
mode_changes_in_progress. It will be fixed in a follow-up series.

>
> On each step, mlx5_get_next_lag_func() reads xarray entries and fn->dev.
> mlx5_lag_fn() then does an xa_load(), and the loop dereferences
> fn->dev->priv.flags. The only thing guarding membership while the lock is
> dropped is ldev->mode_changes_in_progress. The comment in
> mlx5_lag_drop_lock_for_reps() says:
>
> 	/* Keep PF membership stable while ldev->lock is dropped. Device add
> 	 * and remove paths observe mode_changes_in_progress and retry.
> 	 */
>
> The SD paths in lib/sd.c don't appear to check that counter, though.
> sd_lag_cleanup() takes the lock directly:
>
> 	mutex_lock(&ldev->lock);
> 	mlx5_sd_for_each_secondary(i, primary, pos)
> 		mlx5_ldev_remove_mdev(ldev, pos);
>
> mlx5_ldev_remove_mdev() then frees the entry right away, with no RCU
> deferral:
>
> 	fn->dev = NULL;
> 	dev->priv.lag = NULL;
> 	xa_erase(&ldev->fns, fn->idx);
> 	kfree(fn);
>
> sd_lag_cleanup() is serialized only by sd->devcom. For
> MLX5_LAG_FILTER_ALL, this function runs under the HCA devcom instead.
> mlx5_do_bond_work() takes only the HCA devcom trylock plus ldev->lock, and
> not mlx5_mpesw_sd_devcoms_lock(). It reaches this function as follows:
>
> mlx5_do_bond_work()
>   mlx5_do_bond()
>     mlx5_lag_shared_fdb_create(ldev, ..., MLX5_LAG_MODE_SRIOV, 0)
>       mlx5_lag_remove_devices_filter(ldev, MLX5_LAG_FILTER_ALL)
>         mlx5_lag_rescan_devices_locked_filter()
>
> mlx5_disable_lag() -> mlx5_lag_shared_fdb_destroy(ldev, 0) reaches it the
> same way. Group id 0 maps to MLX5_LAG_FILTER_ALL, which matches every
> member, SD secondaries included.
>
> At the same time, removing an SD member's eth aux driver can run:
>
> mlx5e_remove() / mlx5e_suspend()
>   mlx5_sd_cleanup()
>     sd_lag_cleanup()
>       mlx5_ldev_remove_mdev()
>
> This removal can come from a sysfs unbind of mlx5_core.eth.N. It can also
> come from a reload of an SD secondary whose hca_devcom_comp is NULL or in a
> different component. Neither case holds the HCA devcom that the bond work
> holds.
>
> If that happens, mlx5_get_next_lag_func() could read fn->dev from a freed
> lag_fn. mlx5_lag_fn() could also return NULL after xa_erase(), and the
> loop would then dereference it.
>
> The old loop touched only the devs[] core_dev pointers once the lock was
> dropped. Those pointers stay valid across an aux unbind, so lag_fn and
> xarray state was never accessed without the lock.
>
> A similar question applies to sd_lag_init(), which also takes ldev->lock
> without checking mode_changes_in_progress and calls mlx5_ldev_add_mdev().
> Could the second loop then rescan a newly added member whose
> MLX5_PRIV_FLAGS_DISABLE_IB_ADEV flag the first loop never updated?
>
> Given the above, is the "no functional change" statement in the commit
> message accurate?
>
> Would it be safer to keep a snapshot taken under the lock? For example, a
> dynamically sized array, or a reference on each core_dev collected before
> mlx5_lag_drop_lock_for_reps().
>
> As far as I can tell, the last patch in the series doesn't touch this
> function or the SD paths, so this would still be present at the end of the
> series.
> >  	mlx5_lag_retake_lock_after_reps(ldev);
> >  }
> >
>
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
