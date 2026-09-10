Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887D049E5C1;
	Thu, 10 Sep 2026 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050521; cv=fail; b=HWHpSyisvPROsr/NK/2jEhNSmmVEN8x0XnFgZ/koxUobGsAcck9vEo3KVxjdk2mE2tulB2tUgcx+aeHaY4IXH6hAT/ECvpvgSXXZ+CFRGSJh2rxfgCXU7iv8wjrlGX8NExaIAXclC0l3EitXMRFLu3dK70zR6qOLgkSzS26rGhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050521; c=relaxed/simple;
	bh=cWF9eC7yZOC8uSjYvCfosVRiIemWgga+1M/IgTIizEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HjOlZmUp4tsKxxrMUaFlttMXfbY0Q7TrI3gEJe4UWQDP4YdnR8qtbUMK3Vdy9nDfDocYWDfSimLHTiwsmU5QJCETdgUOHzfvheFgqJCSNaYFTMSCXIaAFi5Kx1Q9rQTScJ3I23e7YuJHuv9SR+wiAGVNkaCGM+Cv03TyQ4uvV+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EqKNAqDe; arc=fail smtp.client-ip=40.107.209.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EqKNAqDe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bxcXF0mR3LZQh/H2SIkyul2SGdDX4hq8G9T5t+7V9JpHUPrWvfyJp08pURVy9LDWezm1PojBFvDFnVODGqFLdb9nyU2Qo43EzxOY9eZ6FtPfkVnLhagFqIMsgnwZQ9ZqUG1cEfCFwkr9MbflE8jNOK5zydaPmjdBEMfWxY9QLOloCqddue47mLAaUwCigP34C1JDHWUCQYL3+2B8ov30CykH+6OjBHfRUhuvthgy9rR38R4K37LWKXBrxiI3Bo2L8sqAQgq4VtKUwQ+o2xadDG+cFBmB2vj33Y30QlEgRBzLsJn3fONDVjCAQONB4axUS2+96NP6gyC6DqzK+CIz7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7cA5AYlYtqoyA0K92p5DOLIFsCJt2ByckcXzIqodcM=;
 b=Bg3uESTfl0trgbMMGzYGsjrvfd1ULkzzxUzymuv52tdZvXnIWPublBFy/JiqKZByEbWWuei41IH3ArXBhzzW/Xuo0KfIwHP2AjGFP3M70CDgoxsybLiBFD74MWOYTHBsGwWqCpO1BrFb0h8LV5ch09ko5Sx6nMArdI7wzHm7WnWWkpBuC2inpN5agiJtcovx0fcv8fDWUNdl06SNyEt1Qc+jQ+ZVB8fcCtOaSW6KCRU3EVybHHURQBRpyOphTjYuC1X0yjUYUQDPv2+cvoHU/e22rHdVMFWCCjk3CG+KPboE4hHrVIe9cMJwxcwIrILJb90Qe0LiQmH64gVndAxcxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7cA5AYlYtqoyA0K92p5DOLIFsCJt2ByckcXzIqodcM=;
 b=EqKNAqDetu7a3jX2i/5T6bZBcO7RrLEhR+M/JisJkXwk8OfhMsdJwEOEP+2vMoPMMGOU3Zeh+h81xfvfF4NWjTUw5Qdw+5Jnmpagctt7DpQY49PFcU3+HmoIwE4ZBtoDG+/NsrjMdyAnPMQ9DKhyCaAVKLYExgG50eTqbE7mKaIMDJ8jwdZrp7fYtiSU/uuGMO9BxWjOPYQUaFSXLFGfwLR4nDTr/cChG7COSQNs1s3fHg4Dnp2qewIQH9MCmioQ7XBvWIUYBKvEmnfGC73z0j9nAiW5sdmNU+VsuQVwgeyAlwoNrbISX2imSXZYXkbYqdEtDwb5ojZ0RRu2kVFBqg==
Received: from SJ0PR03CA0149.namprd03.prod.outlook.com (2603:10b6:a03:33c::34)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Thu, 10 Sep
 2026 14:28:26 +0000
Received: from SJ1PEPF000023D4.namprd21.prod.outlook.com
 (2603:10b6:a03:33c:cafe::83) by SJ0PR03CA0149.outlook.office365.com
 (2603:10b6:a03:33c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 14:28:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023D4.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.1 via Frontend Transport; Thu, 10 Sep 2026 14:28:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 07:28:00 -0700
Received: from [10.221.192.238] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 07:27:53 -0700
Message-ID: <b55e9bb6-b248-4291-9b10-6b8cabddd272@nvidia.com>
Date: Thu, 10 Sep 2026 17:27:51 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 3/4] net/mlx5: SD, unload reps on shared FDB create
 error path
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <edwards@nvidia.com>, <gal@nvidia.com>,
	<kees@kernel.org>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <msanalla@nvidia.com>, <mbloch@nvidia.com>,
	<ohartoov@nvidia.com>, <parav@nvidia.com>, <phaddad@nvidia.com>,
	<saeedm@nvidia.com>, <horms@kernel.org>
References: <20260906071332.3759199-4-tariqt@nvidia.com>
 <178895614589.219967.9154250282246662158@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <178895614589.219967.9154250282246662158@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D4:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: cefed145-b464-4636-9e39-08df0f47c712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|82310400026|23010399003|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	41mO0s1u+HbU3cxT2xZbCpGXh8O1T8Ld/3qar/HDrrPH+2iDcCqTKpvSzJx1Q7j6yLLiHmAFNayJdTbktgOgf33OtNB0cqud9tAiYZqqHENhhUQP3zgTGRFD2Qplz4rWgbGgNXI63h+ARM0egnWV2m8Di1kup9vGN+humZjCX/IlHvxprjISVoWEEI+ZD52aX6FLWGqpl6Ly63N+AscVF6jO7e0rUJ5zWNL6AheuCSW1FW4uCLxlf8923/8zWqCUZTm6Zf2vfBb+8bdSrDfYsfTbm1lUqM95F1TPv2yXbrWl53WPFinxQ9F7CamViY2YrfxZkSF5dsogWhQ1mpb+esfZYUZJSezKSkNT9XJWxVkBNqk5ydTVa8AYzPCmCif57L3kXbFOVAwwol0gt53f3Ocvt7bKkeWzqLzSyI6qBXGKwmLuUL16BY+TmxJ5zmrD7TlOIB0vcHxwQwtRSFia5Ftt0TeemuRQF43obGoNtqV1lUR200ppArFyV7mAD2NW03qVmZrpmvskkQ9nu+NgB8FnHsm4iy/x0h6sbZcD8tVyw2RbePN5NU3teqBjMdZyfSmnKxirIgG0T5h2s7tCv9u6VsImhyakGmWGJio0v/tabzbgbW6+aDQcfLAazqY+Oct7duamfmJWG9vlkG6l+aRoWV2s2l/jaCXlWJa0zNhAcHEtRdPRwkbfqkEJ1zQDXxAwdsjJzMk0/UZROt+rOg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(82310400026)(23010399003)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MFw9hGnCcYjiK9+WZvvxeURbsTjLIRmaBJ/03eDEHBROU+rICK+jINmMrleoGUNaM2+IMIPU3O35XRl7ND8auBy405yfRANq9mwdJzUZNNVgD+6b3hkWBZmx0Wnb+FxRxul8LS2Q8/4g6bNgDpQaoxw+mtCHj/eEZpfQxgzwXzEbSRZdBgS/+jsSHgNoL+KnriTkRxubVg0mp9+wSjVKWwVSViXG0JX+Z3yEP/S4TmeIl7lyhLiaU/mHdFOZW0Bj4s2LRB0KiQ1mph3JWx/JCvvEPxgMlq4daGCw4S9hhKB7IhvHlSCed7ioUiKtDqp+jF46mWGuNUYbEpDTDSnpZ/lOdQDNme265hPkdmTeN8VlmA9az/muAiG2IvBTyLUv5+x3JUK2CPb98UTvZXjGYBb+CEEvdSF79eFuCY1F0t6TVuZgNmMvMUYw6fceyvNf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 14:28:26.6488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cefed145-b464-4636-9e39-08df0f47c712
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D4.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060



On 09/09/2026 15:15, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 0 · Medium: 0 · Low: 1
> 
> - [Low] Commit message of "net/mlx5: SD, unload reps on shared FDB create
>    error path" describes the change only as symmetry ("The teardown path…
> 
> --
> 
> net/mlx5: SD, unload reps on shared FDB create error path
> 
> The SD branch of mlx5_lag_shared_fdb_create() now unloads the
> representors on the error path after destroying the single FDB, matching
> what mlx5_lag_shared_fdb_destroy() does.  The patch carries a Fixes: tag
> for 68c2dd59a6c7 ("net/mlx5: E-Switch, Tie rep load/unload to SD LAG
> state").
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
>> index 6b4ad3c53f2f3..424040918fa37 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
>> @@ -270,6 +270,7 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
>>                        pf->sd_fdb_active = false;
>>                }
>>                mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
>> +             mlx5_lag_unload_reps_from_locked(ldev, filter);
> 
> [Severity: Low]
> This isn't a bug in the code, but could the changelog say what state was
> actually left behind before this call was added?
> 
> The commit message only describes symmetry:
> 
>      The teardown path unloads the representors; align the create error
>      path to do the same.
> 
> In the SD branch, mlx5_lag_shared_fdb_create() sets sd_fdb_active for
> every group member before the rescan and the reps reload:
> 
>          mlx5_lag_for_each(i, 0, ldev, filter) {
>                  pf = mlx5_lag_pf(ldev, i);
>                  pf->sd_fdb_active = true;
>          }
>          ...
>          mlx5_lag_rescan_dev_locked(ldev, dev0, true);
>          err = mlx5_lag_reload_ib_reps_from_locked(ldev, 0, filter, false);
>          if (err) {
>                  mlx5_core_err(dev0, "Failed to enable lag\n");
>                  goto err_rescan_drivers;
>          }
> 
> Non-uplink reps are only skipped while SD LAG is inactive, per
> mlx5_esw_offloads_rep_load() in eswitch_offloads.c:
> 
>          if (vport_num != MLX5_VPORT_UPLINK &&
>              mlx5_get_sd(esw->dev) && !mlx5_lag_is_active(esw->dev))
>                  return 0;
> 
> so reps do get loaded in that window.  If
> mlx5_lag_reload_ib_reps_from_locked() then fails, err_rescan_drivers
> clears pf->sd_fdb_active and calls
> mlx5_lag_destroy_single_fdb_filter(), which left the VF/SF reps loaded
> while SD LAG is no longer active, i.e. exactly the state that
> 68c2dd59a6c7 was written to avoid.
> 
> Since this is Fixes-tagged and therefore stable material, would it help
> to spell that resulting state out in the changelog?


good finding, will spell it out in next version


> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906071332.3759199-1-tariqt%40nvidia.com

