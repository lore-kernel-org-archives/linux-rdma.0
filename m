Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011032.outbound.protection.outlook.com [52.101.57.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FFC3E6DC3;
	Mon, 15 Jun 2026 12:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781525300; cv=fail; b=iBbAv6mgJio6VOL8j5TAlhSZBD1VI2iHOXrKF72OdvQ/zdFtJmaUyCsy4GaDQimxW/cOB1M0kBZ+dUyxkd+bP74fl75YSSuRaK5jA/gaYMQKAFs7b8GL3Xi2vXlukR8xLaH4jBN0JnJMrMZtVqKa0q4tV0zYY2taMB1QJ2xtidk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781525300; c=relaxed/simple;
	bh=yfbIGaMOlWYEebqkdtxMP4dYW6K+ASXUXG53HNrLfps=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=af00QxKvvwvMLYw2v9qZYjZ26tfa6JvzQUcam/IL7yZ74ekcuD5f+JZkFLCL7sHTR4DVGpYCnu6ACiUBsdWwkiKcu298afLZKkho6V6uVgqeYtecbRhz/mw7Uvhbdb5RncL6TPrQQseftIhmFuMuq/vmbNUOn9ov/+kQaAemcgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iks2J3PW; arc=fail smtp.client-ip=52.101.57.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iks2J3PW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dy99Bi0Gl5NKt5kUpscjc5Uh96BsnsEHJib8Vd4gYFMFb5UJLCjmbYOPpZLfMnurfZAJ325k2DP8hQxBGnzZtOqXNikjWJWP7y2Yp2VXMw6Py0fCysDeKumtLxgtvbrDtuzRmcFFxrjcaAqLfy9spd8b+yNykAzxW++oAXge1xN12Z4XDqj6VQ0QbtGJm0gjFUnz0I9G8C5AiwdS2exuK10o7ybD/o4n+0eEaxY9Lb7nq6bPbe+ZGrkWs3DUlwf9L1lzvSzcUYNRQAKX6mH0F4ulfzvD/bHreHM3667E/MVDrB4sBJAlNO5fFbYea/wdtQeUBxRMKtfhcXRqmnXaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oV0q04s2Udn4CfvhQCNxJCshqlq5+xKY8RKLUYMDPyc=;
 b=WxUHwViUyVDoavFMiH/wkp5eTPnfKGffNcWpSfjJ5ZSp1bli6OJf1gVXfvlCRCKbnJSHmaIsvYv5unOfKbYDTioQ5IpSpmba5umcC3RWlhkS/b4Z+qk0coCBlsh99quDBxCEcjEdQ3Kg0gdZEhWLRLZtXPsMh68kZpwM5rfGg+UJf95kpl1xUNxgQNaYvwg0oFPY+ohqOD807Aj+9Xf+SB3AxXL6LCncJKGDMh/l5kzau+ANQctURJJ81MVcb0HiUVyIdXiNtLUeCnvYpmo5W5eFz+C/s5A5a+z+Xs8/28nAtUKiwtSzvLuLLNuOY4gyHsw0JQIv0hsHdjKfCpQOMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oV0q04s2Udn4CfvhQCNxJCshqlq5+xKY8RKLUYMDPyc=;
 b=iks2J3PWQQrFLGNC6xLC47E/MotaIvg8dT1gqIjzsViurPT1ouUlpe4ohqpPJraFGGKsY6A06Dxno0PDav1Yx/OknvGL1OXtIOhq6je1cMEFN8WxEd7WYAdOp+zH80F8msA2SUWB6MKHtvYFrCD9R5UfQ5yb/u3hmrl3QLdyXV4Ap8QUXymtQgKOQ2ZlbCzW0OBMhzLxzZ/QyD1sKEjFNsCUTKpu78Fgj4ege0cCMF/JYnPb29KZgtcS0rHqclQTGB5dQZGo42PP5MSz0co6/aN+a2gAmSkNtS9JN70t4Mp0jSR4ksBTD/FtYAuxyf0MaHSTUVzdYC0qKEcgITEiLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15)
 by SA3PR12MB7998.namprd12.prod.outlook.com (2603:10b6:806:320::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Mon, 15 Jun
 2026 12:08:14 +0000
Received: from DM4PR12MB5248.namprd12.prod.outlook.com
 ([fe80::92d8:797b:4db0:d385]) by DM4PR12MB5248.namprd12.prod.outlook.com
 ([fe80::92d8:797b:4db0:d385%5]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 12:08:14 +0000
Message-ID: <c8c01a1d-eeb4-4235-8e84-9094d5c4a733@nvidia.com>
Date: Mon, 15 Jun 2026 15:08:08 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: HWS: correct CONFIG_MLX5_HW_STEERING macro name
 in comment
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20260613225904.140791-1-enelsonmoore@gmail.com>
From: Gal Pressman <gal@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260613225904.140791-1-enelsonmoore@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::13) To DM4PR12MB5248.namprd12.prod.outlook.com
 (2603:10b6:5:39c::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5248:EE_|SA3PR12MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: e59a39de-d9bb-46dc-3acb-08decad6c706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	0AVOOiCn+di9TabfSI+Uc7gTa2cKbBftLsfh1jnmAdiY5lPmMJKWTTl4rVNTzSBSPzgTigfRyBTxAo7zPVSpoL39oxi2ThF4PHhPjqwr5NJfdk8qM9omSxOKB2tLTP40PIdb2SDpX5L/9b342v5cKBrqFjU2kAlBu56ZK0e6p9zs4UqjPbUWeN8zhoXGzC1byEgMcoiaZu6mQ9Rp4mTmr4A1w2O8LPce0ASeLhprt/CpE9MRhYIro3UnVZLmIFiIIDQcuVvCnAigEoPLm8g6Ji3CMRqnxeQfvph0Fmmw6Q0g3Ao9rj5daWZ6If88RR88NJVYSEwzUnvKkwjd8EVP4lhLV+JND/cAtLrinSiRcWGVpUeM6KOlt0X53U9sd2TTVNXdr0m7zf5QYFZYj7lvunN4/H1LHXcBK+E1ijSxSe5vKnwa1Kk2zsiMlaawEkC2KbJoxHZSy6T5/D4+GaDhPZhdYat6zBvATzdCFLdHqNfGcUqHBDoe/DGY7LQ+WwY1A1+RHKzoN4aFsk8UYOyhnNqyNFng1FzoVMoUYcVWD6nsU5PQmspSLaJJX2SFFR+LMoW582yHarQ1Z7TIbyClBkjUch3H6EHDoPzGfLbkBhpAOo052is8183CvUBJXUZfVlxSbBmrhhcyByYAb5eZk39nuOLd5b3c+QvJd4lJ8f7ET7AqewdudhQcVbctjxUv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWNVNUR4TVJJTGgvV1FZUTUzVW9QeXdObzBBNTc1dUVqSVdwSGxhckhFZ1lM?=
 =?utf-8?B?Y2xqa1JMNUhpR1RPMGNWVmV4czNYSXY5UVR0Ujd4Y2Jjb1piOXhxRVhLR2c0?=
 =?utf-8?B?Z3FQeGZObk1EY1VPTTA3T0FFNzMrbXJLOG10NnBBS2pnNVVhVUJRb3FpR1U3?=
 =?utf-8?B?WU5MejNtL2RWNEFaVVdsdkVZV2VIRTZFNitMSEpzc0tXU0YvL2c2eDcxb1Jo?=
 =?utf-8?B?SnBneksrc3ZwTEM2THM2MTVYU09td3I2dTQ5d1U2bE9nTTNlN2xLeXRRWk5v?=
 =?utf-8?B?NzhrME9BUVlmWUNoUU0wZ0taWHRqODVLUUlGdWNSRzRYVTZ1eVlnandFdmVx?=
 =?utf-8?B?SkRYd2VMdDVxWHp3MUlFTkEweHUrNldNSHRDVnBaSWRHcGJZRnNobmQxYXdK?=
 =?utf-8?B?OERVT28rRWlZMGgveW5pbnVOTnZIeFVta1UwVmNBRGhUTW8rUjU5MDJlQkt2?=
 =?utf-8?B?dVJGaVoyZnJ2NEFKc0EvMjBZSDk3eHQzTkpSakp6ekgwdWxNQmx2SVZnWHVX?=
 =?utf-8?B?aitmcS9LV3RpZEV6bEhmYUl3S0RhUmtxdTQ1aTRBT0N0UVJXdERFQ2phNnFQ?=
 =?utf-8?B?WEZTbnlLYmI1MXdVMXZLYWtFQ1J2L1VHRmg4NUhHN29HY2FwSTBtNVhqQnVi?=
 =?utf-8?B?aFNQL0Fob3pCZzJHUHhKMGl0dW9sTmFNelBCN2l3b29zS2VScW8rdVRlSVhr?=
 =?utf-8?B?MDRIRjdGWjg5dkJhOFNqdWZ2WWI1U3JaMGdHQXAxdDQyaHY3SFk2dTNMdEsy?=
 =?utf-8?B?NGwrUEtNdmhBODNxRkd4Yk4weUZRZ3VkdjN3ejdSYUhlMnQzdHk2ZmlBRWto?=
 =?utf-8?B?aUZ3RHJaSUVKeFJkUkdhblN5R3NSOEpiaHo3aldOQWFBOUVwVXV2dFhsaWps?=
 =?utf-8?B?ci9MSzhmby9JQXRVOUFZWko0QUtPbWprL3ZFei9EOXB0QlJJYXNCM0tjNW52?=
 =?utf-8?B?L0s2YWdNVWw0cWRaMDc4OTJIdnZaNjlHWkV4U2QxYktQRWtxRDVoRmhvdzRa?=
 =?utf-8?B?clNRN0JQczZlbVlZaWpybmtmTlN4M3RrWkFZd2RhQ1VSWTR2dnY5S2lDOUti?=
 =?utf-8?B?OWdMbzM2RlQ2d3FRc2crNGJCVnhmVGhVNHQ1RGt0N2ZYSWJKVjBRc3F6cXZB?=
 =?utf-8?B?NVBlTGZwMFkwdnBuVXRFNUJFRXF2V3ViSmZkeXY3d1hMRHc1U0xUeEVyQzYz?=
 =?utf-8?B?TTV0MFBoZ1kzVng4cmJzM0RLMVVsMGUxQzl1QUxyb1R0SU9sdE8wU0Q5Tkx3?=
 =?utf-8?B?OWFTUGFHb1FCY0lCWHIrMUdNY1E5bEVlU29oT3NBQWcyK09vOUlpMEZSU0pV?=
 =?utf-8?B?ZmpYeUJZbENTOTBIb1FZSzJNTWFnajZuaGhvUlppZ3pONVdDNU9sdmpMNjc0?=
 =?utf-8?B?WWFzZHo0Zmw1Q2VCTmw4SEZZUS9TQUl5YVVDZ1hiNVo1WjgzSG9uaTFFSm1S?=
 =?utf-8?B?cHVrK3hINmM3VEVVZkVWQXNhTlVTd2FHVytXaFEvNVRwS2xxeGxhM1FpTWJ4?=
 =?utf-8?B?LzJ3WWF4SW1Fd21DOFJGUGNKMGYwVFVPQWhrUHBZMmJmenlkWU45SXhCT0Nj?=
 =?utf-8?B?L1NIWDd5MFhBV0NRVzVCTXhTYi8xcnU5SEgxU2Q1MnVIaWw0S1hob2Nlb1Zu?=
 =?utf-8?B?dm5GcUdTc2tkR3RiRjdjZ1ZxRWZMRFhGN3FwTHNTQk9JVkdjWEVIaTJDSFdP?=
 =?utf-8?B?cGQ3NG9UTnJSOVNuZ3cwUlJPQVR0d1pyMzl4aVcxazRGaTB3QWlBR0x5S0xJ?=
 =?utf-8?B?ZUdnaEw4dG1hOFRBR29TeDdYUVltZXNXT283c2JCYllRRkpGWWJIdGhCWW02?=
 =?utf-8?B?b1ZkbnZ1VVNUQUdCc3A5NVJKSmRaSzFscnRiN1BqdEFtdytHRWczUXcwcUNR?=
 =?utf-8?B?VkV6bTE2YWZHa21qTHRuV0IxV3VyL0J6bE9VV2tVY3Y5WkNZTDlseWkzNzI1?=
 =?utf-8?B?M1RVY1BUV1Y1NE9TL1dXcURjd3I4NzVIVmdBMHlBWSs5V2V4NytOYVJMTWVW?=
 =?utf-8?B?VGtiK2xPSFVPUzVDTFlPeXRtN094dWUxeHdlYmlaeHRxQTdpVmUveks2QUgw?=
 =?utf-8?B?UmN0MU1XTTVrS3IzZ1E5VnBDTVArODg2QlRkMUhrZTdxUnYyZmJyeVBmWU53?=
 =?utf-8?B?SWhvelZ1cG1CVWx3NjlFNldBdUFEaitUbXVwMmVWeGJId1dyd1kxbDVNUWor?=
 =?utf-8?B?UEJBaGZBTVB3VnZyMHh4a0F3Y2dIbVk4NmlYOGhaMDAyMTlyMlZGMk16bnhy?=
 =?utf-8?B?Z0k4UUlDYTRjQ2hMR2tmWStWUGd2NEU1VFhpNFFRc3UveDMzVHI3VTZUekpq?=
 =?utf-8?Q?1aWFuQoXPGIVNSIV/8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59a39de-d9bb-46dc-3acb-08decad6c706
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 12:08:14.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5UxrtB2bC9n2hHkephX8ijC3WSUCk6cotOJKtjB0k7QooxZ6wMOYTcYf8us9wda
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7998

On 14/06/2026 1:59, Ethan Nelson-Moore wrote:
> A comment in
> drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> incorrectly refers to CONFIG_MLX5_HWS_STEERING instead of
> CONFIG_MLX5_HW_STEERING. Correct it.
> 
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> index b92d55b2d147..20cdacd8f12e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> @@ -116,5 +116,5 @@ static inline const struct mlx5_flow_cmds *mlx5_fs_cmd_get_hws_cmds(void)
>  	return NULL;
>  }
>  
> -#endif /* CONFIG_MLX5_HWS_STEERING */
> +#endif /* CONFIG_MLX5_HW_STEERING */
>  #endif

Thanks,
Reviewed-by: Gal Pressman <gal@nvidia.com>
