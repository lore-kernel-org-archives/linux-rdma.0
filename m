Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5481D282F12;
	Mon, 24 Aug 2026 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787568503; cv=fail; b=SlMMuaiDNtuqKj2yHtuXsKedhBWcxb1wP+uZXIiml3vt+2dsCBhwM9dyljgWQ+Z7D4Dt5ApjD4OErIRr6+ourcOrtgiMA95VlMm5h4zaxR35hyDxUUZ3LTHjxbjZCOpj4c/so52YEALLoRYUg/niuTNONDRP/g0aFu/RhxIZNhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787568503; c=relaxed/simple;
	bh=Jy2E5J7xdi4V0lQxoFamVUfPUCqEuTjjd+TqB6LRMFY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KmAsU18V/h+hhcjT4CZbNVPqT44anCQp7rl+GLDjW+0AlfNTtustB1RAlAccA4+0BPIEqPlGT9QypVArOK4VIXRyUN3j2Ag+7UHnaHzieZppBk0RwwZqREhk8rgojTFazGANSCnFfc3fCZWrpDeqF4ciTgj+FTZcruXVuRWsu3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=otvCfM8n; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="otvCfM8n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9CC7ge4zURTMH9LFb/LYPDQksS1G+cxKImvW6OI8rPKuDn4GnNgjEL8hBiQOdfzyV66undCj2Me0wHeXufb2K6ilLTSM8/kLsPPAym+N1C+LzndFZ11703A3vDBAIR4a4FNUleDrZGXNq+Q7G0J7XUBOFeGrfrFnIETRiNdlGCkuwTqLLnfMOsoH1dxcPHzPNXArdF7PPfbdYWzSb6X+sFbWnILEV1m2EvKMA0/JiGexquZEbN2Zw20F8LSNXyVfvCJrYwkZ0CN4AUgJdFjsdKWrCB8nVWMCAJp8X4Xiy28KdGywnq3BIZFRufCQaXf2hzaL1b8nbMGzkDOIGevcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGM8YvRWqjFqBuQlY/QeDKxAeedk5yZDuPKLFP3ZqKk=;
 b=oWnRYal7fG0CexORHi7fQ3PsFCV9SEsDYqqoZliT2Ka2iWeIlraLJZa49/AnHPeHisFQYYk0en8lUlcootwW5Cg/+RFt1KREV03d7gGFSYrba81H6JpmU53xDWR+vC4FAgguPKLsxjEJ3YQADlX32Zxn1guL+ktNbbHCchMdqlxIUzxyaKHWHVrz3IsZKXCTe1QpNvnk35G03pcPXIy7f13hbkVCxWfSTcj4Xd9mUDzwVAGVWlpNzkIimFkHWM9DrLRgeB9RonSu5qhxRUPQPcSS3B4IOocAs5EeNrpmPxz3eSHnEmK1FdXUGswNPV+qwVszphXx2KIjqScp9kqlvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGM8YvRWqjFqBuQlY/QeDKxAeedk5yZDuPKLFP3ZqKk=;
 b=otvCfM8ntZh0JofDvGKFTzd1YDvsJY3rDsYOJXetjRDiW5mN/kCx6IPoq4YbGZnfGZeH1lIdyTMN+BOp43wmJtn1aJjwCSbn4Ol1R9j4oG1BP71+Q+5AZpEFZfshGpm88Rtg4Yh7/66kUn+O6RmQTw32tZkq9ByBB6wV0QW6L+CMK+/rYwPlv7RLhg27tosieTTVMydEfAoHQ94SsHfxpNbK7I3WNAGugEo3uR5ZYf1fSbiJTnHHRKjFnzyvpx6M+gvN1AToi3z4LDPs5B0kAP/EaDgEtAHvDGbO4gpq12TQKzJdJPJjuMkwJZC7icAI3GU3I80DspDKHogH0nFKXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by CH2PR12MB4245.namprd12.prod.outlook.com (2603:10b6:610:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 10:48:16 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 10:48:16 +0000
Message-ID: <b4abc8e4-aa9e-4e92-97b8-c6a661014c16@nvidia.com>
Date: Mon, 24 Aug 2026 12:48:10 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net v3 2/2] net/mlx5e: Prevent stale XSK buffer release on
 MPWQE refill retry
To: Jerome Tollet <jtollet@cisco.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 leonro@nvidia.com, daniel@iogearbox.net, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, ast@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
References: <20260820151558.11015-1-jtollet@cisco.com>
 <cover.1787347981.git.jtollet@cisco.com>
 <675ce8a404cfe305e788a8e273b4091c9a90f867.1787347981.git.jtollet@cisco.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <675ce8a404cfe305e788a8e273b4091c9a90f867.1787347981.git.jtollet@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::17) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|CH2PR12MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: f97cb439-452f-404f-96cf-08df01cd3409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JY42zwRivUnCyDxGk6zYwx8E4hRNgszoqI0VJpY6O0yxHPpwZ56GLMtLe9j55SkfSe5ZrJNL6E4uoBuYga+15PRJ2yXWuHFznSfC8WSdHdJCgfnazm/u03IA5Nu5AJteUigdKrKky5EKufxCOpkQCR94TfRFuq8B6Y3VEODtWEwP26iDKlGf9IbqH/YrmHUkmhNS8bHLTsnWTi07EshEilJlrAET+d9ulEoBgNx34arYTqXOCM3XIFg+TPbzPhGXL/FR2W39nOWXR63QQVwENfU29tHnQotzHYNS5Fw3xl/UY1/tJwXdrfck/gRwLuQDCwUCDhAWZVVz5AQwuUOMUUoF3hn7UA0QM/YFCluhcarlCNCcv301jUJ0JMhUhjZWtQy1719HijTOKF5NlHYltdu5OUenCIrdqMo5UlRTrQlpX+9s2zmZXqdaVyPuUBMNrrm6l+6wDQ85V8Bv3dHi9dzREzyfvc8CimMT5oQXvrUgXxPzTG4nh83w8UO0fCv73k82Y8j8sZVcY7vQUtt2vsGTaqnCXz/Dv48E0PnpJAsOiKC2QdN7YIi/ojjL4t9iGyGuAtQzxgoZcl6zxK6GRRIk6EIZaYE4O2NBgutNR5XdENjnaF0UYCZ8XEJrw7CAeBCql0LmTI9L68Vv1h9xdnTTvQsuEXaGn+xqmtTfYD0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UU4ydHZ5NmJQTmE0UWRjWjN6SDhFdW4yV3RwKzJoRjBKWkhvc3Y2RWc5cDBD?=
 =?utf-8?B?MGhMWEFRTUtPcm9QQ0FndEVVNjY3TU9qM3N4NVFaeUJHeHNJMi9Ea2ZyWkZp?=
 =?utf-8?B?MkgxNlpzYmZ1VWJ1cnQyTWxYQXYwNkZhS2JQcnYrOFpCU0F3T21PUThyUzk3?=
 =?utf-8?B?a0JyTzdkVjNTQ3ZhOW5YYThsOXhuTmVCRWhtcVRLWFZURGNVUmNSbTRWWlRV?=
 =?utf-8?B?OTUvdXJ5VUdEMWJaeE1hMG5WekcyUDA1enUzREZEc1gxQUxOYWRZcGQvQ0Vu?=
 =?utf-8?B?UXZKNlpLVG9vU0FWMFI5aHJsY0d1N2M0NEVIamY1ZTFTRzBJcUpWUWVxQm1K?=
 =?utf-8?B?elhSajJ5SzhjZjk2bXZJMDZrbkh5dGJCVmpwaytaWS9qQjNiTzNMMVRVUW9U?=
 =?utf-8?B?aGFmaGJsM3h6dUZrZW0yRlRmTmxzbTgzREZ6cGJ0M0ZQNS91M1MvdWF0L1FZ?=
 =?utf-8?B?di9EYU96NzJSV2I3ZWRjY3V0UnA4TEx2MHZuZ1FQaGxVUjhkNXJqOGZhY1M5?=
 =?utf-8?B?SHJOVkozbWtnTXppV3FrWWZmMyttY09DdkxNaW9YV1QxYUxGWThzdUFPNXZm?=
 =?utf-8?B?bVRsRFRjcHNkTS9DTEZOdUhZM29SSHF6d2kyZlRWUlJNRG5ZaGxpSTRyQStM?=
 =?utf-8?B?ZFBhaVZoYmpZclZUd1IzNnZJTVI4SlQ3OGdTc21kWUR0dHVIOWVjZmpoaEJ1?=
 =?utf-8?B?OGE5NnI3aU00TEFRSjg4d3B0QlpkVUEvd1F6ejhKZ3hpK0t0THRkQkNOeDBY?=
 =?utf-8?B?K2t2emtRTHZJc3ZWUjM5aWFmWVdGVVhFLzVCZFg2SnlHNUN3Q1QyaXc5UVla?=
 =?utf-8?B?OHJuMGE4blE0SkVLMmxlT2hrWi95M1M5U3hUOVZmZ0dIci9LQWxrUGlITjg1?=
 =?utf-8?B?KzQxRHVPbW5JSzVxZmd5dVZZanp5cTFsZXRHMlFjUXVpNE9jS1V2S0VGUExp?=
 =?utf-8?B?M3VhYmszSWxkb3c5NkVXeTFxR0lHY0laaG81bjh6eXNKaDZtYlVVUThFRXR2?=
 =?utf-8?B?aDJILzhJMkxMOEg0cTRIemR0c1ExaS9tOFZzMFlnSzREbzkyT0pFQnlMRnc3?=
 =?utf-8?B?SEwwRFYzVzM4ekNZOU8xOEV1cUhzVllkaStMaVdhcC9PdFZGcGhNYSsyQTR3?=
 =?utf-8?B?ZGpnaXJPQ251QU5KZnRXWllsQVM5aFBDTmxLamhrdWhVMDdsd0ZpcDlQRW9P?=
 =?utf-8?B?c1JhVzZMY2xtV1hwT1FRY3RueDUrMlh5amxuSkZOVjVEcnNYNCtNUjIvQmp2?=
 =?utf-8?B?Tk4yMkJuUTBBSjRvNmJPZ2pxRGJITVNMRzZIa1BUVVEzQTBOSVVEMGx0SmFp?=
 =?utf-8?B?UG5QMWdnQkM0OEpPTUlRb0hIL3kxYUxnL1d2TFRDMTFxczlSQzBMcXNjejNE?=
 =?utf-8?B?ek9DTXpBWFIyc0lQK0IxZGZpM2JGRy84bit5UG5keHVkNm8wTDdETkFreUpo?=
 =?utf-8?B?WStiOUh6L2xsK0lBMFBCUzNLU1ArYU53RXNIU1VJYk1mSDFKdCtaMFFGNFBC?=
 =?utf-8?B?RHN4eDdNcS9pYTJsT2VoOFVUY3FtTVVmNTNQODRkZFVnQWRONGdpZHZlVTl4?=
 =?utf-8?B?VFFLZmRTbXNraGxXL2RCUTErcjdVMkxhQXV3cm5RSW04TG5wMnRtVVp3eUg1?=
 =?utf-8?B?QnBCMERJQk9VOTVRbEpJek10MStZczlkUXdYclQrYnVOdVowMjVUL29IRkRh?=
 =?utf-8?B?Mmd2cHlWZzJ1ZjZRZ0JpMXliU2xTSjkvU29TV1U3Y3I5SDZwaFEvV2tIVHQ2?=
 =?utf-8?B?ck52a2taMjVPUExROHM0ZjFxTy9nVGhYZkJyN2NLK1RCUktRVU5xQ1g0Qk1F?=
 =?utf-8?B?R1J3S09ib08vQml5TmZpSXA5c3ZxdWxCVDJ4S3N5d0RkaHVLQ0NZOW1kckV4?=
 =?utf-8?B?QnR5MDcxL1JyazR5aldYYllWNVliRkhCVmRVQkhPWjgrZEhkLzFwSk16c3po?=
 =?utf-8?B?ZURxY3JLTStjM2I0KzZEMlYxdHR0TElIcGlSQnJxeFJKT3U5TXptUzlkRmxT?=
 =?utf-8?B?dVBQdGVJZ2lpNHVpTm9MSFo4TFBOOHBvb2hRaTRsajVEd2pjYjJxZ0Zpcml6?=
 =?utf-8?B?TGpaMDVFaHdPSjZweDFRT2x6ZUJOekd0NHY3eHNwQnZGeUFyei9pMld0L1Z5?=
 =?utf-8?B?UVluWHFtRUs5MkdrcjhVSUxleXQwSERxWEtZVFZQZFdwdXpML2ZMaFgrSGNy?=
 =?utf-8?B?WVdzZkhFNXQrY3JDaTB5MkZtZVB0TVZzZmJ6OE1OdUhNT3NRWjVjd0s5OFF4?=
 =?utf-8?B?MnVrdHIvUUhQSisrQ3NLYkZ2SEFUdXNFOGYwWnp4UkxlRTRyclY3aXRDUFEx?=
 =?utf-8?B?YjNibG9LcXdmUnB6cFFiZThXdGEwU2s5Z2FIeEZrd2h6M3VIYXBQdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97cb439-452f-404f-96cf-08df01cd3409
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 10:48:16.5314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8ur94K9ptIIHdBw6+cL4TVa67W1lj51fR5TI8Yj3n2VTg22qGG4OlxXX8LJO7HsIkJSH9R/HoDg9uNhWXZoNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4245



On 21.08.26 23:37, Jerome Tollet wrote:
> With AF_XDP on a striding RQ, mlx5e defers releasing XSK buffers until
> an MPWQE is refilled. If XSK allocation then returns -ENOMEM,
> actual_wq_head is not advanced and a later NAPI poll retries the same
> WQE.
> 
> mlx5e_free_rx_mpwqe() currently leaves each released slot marked as
> releasable. On retry it can therefore call xsk_buff_free() again through
> stale pointers after the frames have returned to the XSK pool and been
> reallocated.
> 
> Mark each slot as released immediately after xsk_buff_free(). The
> successful allocation path already clears the bitmap after replacing
> all buffers, so retries become idempotent without changing the success
> path.
> 
> Fault injection forced three consecutive allocation failures for one
> selected MPWQE in AF_XDP zero-copy mode. Stock freed the same 16 XSK
> buffer pointers on all three attempts, for 48 frees. With this change,
> only the initial 16 frees occurred; retries observed a full bitmap, and
> a later successful allocation cleared it.
> 
> Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jerome Tollet <jtollet@cisco.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 7bd0606a5..5fe17d295 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -609,9 +609,12 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi)
>  		 * is no way to return the page to userspace when the interface
>  		 * goes down.
>  		 */
> -		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
> -			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap))
> +		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++) {
> +			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap)) {
>  				xsk_buff_free(xsk_buffs[i]);
> +				__set_bit(i, wi->skip_release_bitmap);
> +			}
> +		}
>  	} else {
>  		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++) {
>  			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap)) {
I'd change this to be consistent with mlx5e_alloc_rx_mpwqe(): set skip_release_bitmap
bits in error path of mlx5e_xsk_alloc_rx_mpwqe.

Thanks,
Dragos
