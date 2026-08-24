Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33501446C19;
	Mon, 24 Aug 2026 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787593293; cv=fail; b=TeL1FiER20AqrQbkAZuzaQchl3Wod+o48oWVTrtuxAEU9LGifoII8L3BmpBOfkMk1k5ZB6LLu90AqVYlxvqmgozypEu11JFyH12Xn76XU0fzqLkAlNvCEslpP7hCkVra911GxnbqOCSEGzLfNjqnHoihc3aGyyU6MlQ/2cDin3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787593293; c=relaxed/simple;
	bh=gbem/0/PmnPj9WkkyPIjHeheULH0y2dSj73gNiH3ff0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K2YGXBoVprb2xFI3hZdZqj60nN1M3GcKsuM3mQiVP6ormNKahIjdH1YEp7lz/GMoGI9IbKTUAPzdgyteLC8a9VwhC29lU3hhLVAvjBvTyCprYx0ROzhflVVg2jvIgrkH7okRMHRPlKWIqj11r7DLC+RNpNGEYxWKYzDSESnvsVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SVbWpYRh; arc=fail smtp.client-ip=40.93.198.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SVbWpYRh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jOMgvmBMXWS38XhXkfIG4o4NFX6i3IYVDj3r7E7UgERiQE4XYE3+1kyukoHVVnWu/KiYlgY3dJTroWrcxqQB9ExgDJfprn5Zf2PZGhCvP4JSz6/eZkBCn1aIX6Jibqz3mTtIkC/it66YOf2OKdH9dSm/Z1D/rzY09XE+tq6Q+3qptI7iSMk6OXkWQtHvgY4vAMv/7Lhq2HVVQVKD6CbRAHb1KgFO2T7ma0pC7ARhsd9tA8aLnBDj05Oj7AgqrIakUXPq5zr67QPr0a7hAOZfl6L12TT45TPmvIdOKvRATzMDGsUcsImc58TG/p/hy+neEOXSJSvHjX4mlK2JIAR9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3SvMAHfrknD+ol4CNjCRgMFWdmT0CW/HFFjV+k1EAg=;
 b=vtdgtb5eNdzs2aBSlVDeakjUmdU3cmytUlfsfubKsuuyxjjJiat1s301jfZUJ8kwYdSPum410Imuik8k0zmYRSbneOAIZZ62c/3TPVgKi85gR7swCONp0kphGnMS6EN7oQB2xQ8YSaVNC4fDME6VRcl9lHTlkJ8BmtoVAsYgzVJtA3ZzQdKv+vlBQztf5ln2K1uCLeIX4WxYIYiDRuYofx0UfZSObEgHwx9f5Ug3MbQ6wSSBbnjarKrxMXonTzYQA1ChSBegvUzjMkmE6HrRilpr3ye6E1m6YEBEwdI0n8vbnCyQAvfv+/1OkQF6uU6dx0A2osS4c8mzEPdyCydcdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3SvMAHfrknD+ol4CNjCRgMFWdmT0CW/HFFjV+k1EAg=;
 b=SVbWpYRhSDr/4wMEaTEno+yrVPb1l0HOJKjjHvqC/mfmsG3ZMbGlrY54x/LpnKnYblKYNIaTiR0jdreswh/g3luDFNxtGgUw+gn9MrNYq3Avp3BD0iMc/FV8xDUiOMyTgLvNhozUZCIHC5VLBd2+CPoNKnRBrID2hGYNV7eQD/9a4k1JwnVOULN8ujykPBKVMEoQU0wPNR90cRgDgCQzXa7309B9KvjMeaU/pneRUHC/WQ6S8OV5mncdlZnQtgGiU+m7hQR7zPYaMZdb2bfRlcqFmZoCI376QEVK/qBjrXZsxPhrm66NfOJzUuGdHOPmInErI8i6gcuvM7+FPgnFJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by SN7PR12MB8820.namprd12.prod.outlook.com (2603:10b6:806:341::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 17:41:14 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 17:41:14 +0000
Message-ID: <a2c597e9-784e-41dd-ac0f-7877a1c6f807@nvidia.com>
Date: Mon, 24 Aug 2026 19:41:08 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net v4 2/2] net/mlx5e: Prevent stale XSK buffer release on
 MPWQE refill retry
To: Jerome Tollet <jtollet@cisco.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 leonro@nvidia.com, daniel@iogearbox.net, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, ast@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
References: <cover.1787347981.git.jtollet@cisco.com>
 <20260824141645.23700-1-jtollet@cisco.com>
 <20260824141645.23700-3-jtollet@cisco.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260824141645.23700-3-jtollet@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::12) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|SN7PR12MB8820:EE_
X-MS-Office365-Filtering-Correlation-Id: eaf4eb10-487a-4a73-bebf-08df0206e4b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+NHQOBTycyeckj14Qz3ATJoOdx+3GhqQXdjgk4aYjVyZEITFAVSQh5bmEmwqehf9EvepbQr1U7Y58OhqBi2MoqQ97r+keLL/M8Esiwi4iI/V+gkUk5OeX9F6VW6RNErAauV4C34q5wJrIG84Rw+ILEhJTgqucRmykuBBmsAP9asI01wczsqJQ4SArR/N22EUCe7hUdF03dMs+bkALkhjleU/ZYoTg7vB+WsT+KB0mpvdkjbxh8yIZHOpF6ZLrRXk1gmPfcrsTN4fqxCvsyZkTozGfHLP1Pz/TaEkD8r7nhejhun9AhoWAgnhmT4nr0kNdH10zWac1hKVMdBr8w0ZfRwncnBOA2/J7elTq5t0MFGOLE92oFNc/i6QBBDlSptGpdxnggHIpb+1RAuE4RGGkn9/AnkykAYn93Hkx6bGmK8s0tsbaF2msrcXHqtTUAdrXVl7jqpZSygxkix7OIaW+Pea4gGEdJ0WYpLasXa1KPEaKMtL02VDTMBQG5L7v4RYGw422GKPFDX0kKYVrQiu0rDnFcgsyAMkg2cpPZgtyz/TmUdk5li1T7xRTPgIR9pQkTs0flWNzenueEy1YPYGeVxfbmXD+6YSHoqGAHM1eAH2XYt+PizIVhvaKvMHHocV83e5FKI0gsOcToVbnBT8nLgI1kpxWKWA2rc/FIK8MOk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTZJQi9PQlF2M0g4U2FwTW5nQzgxZnR3djkxc1BQTm40K3d6MjdDd2Z0RDB6?=
 =?utf-8?B?Mnp2RjhhbGRCWjJqaFZKc0syWjl5TmdkOGpHUCtQaGhkeXdHdGNrcDNQNmxq?=
 =?utf-8?B?QjF6WkZiQi9HWWovTnpweS82WWIrVUJFOUQxbXpySGJ2WThXcFNhUlBzd0xK?=
 =?utf-8?B?aGlCQ1RDREg3VkxzTFl5Vi9TMldqdFFsdlFOWWNoMzFPRXE2WWlpelBtZ1ZP?=
 =?utf-8?B?dytFRmw4cUtER25PWDR2NHNHbkI1c25KZmZlY2xvQ2FMK2ZWQ0xCWWZpbjVz?=
 =?utf-8?B?TTJOT2pLMmtvSFZBbGRtWFpLN291am5LMGRaSlo5WGdGeDBTdjJZNnhyWWt5?=
 =?utf-8?B?SVhkQ1BNSXkrbjhkNVc5YTdIc1FYcTRPeE96ekdiejhINDlhUnIva2pTcWRl?=
 =?utf-8?B?KzRicHBEUU1GdlVpbFNibUJmdEU5a2NoQlNDbmo5Mnl2TS9PRTZrczIvZzFa?=
 =?utf-8?B?N1dMaEdROVY2S0xSc2xoaTNrZjV1KzltSlZ6d3VUelkxMWthNkNwVTR0ckpB?=
 =?utf-8?B?dDJkN2hWc0swVnJSQnBFSmtEQmNuQnprMElITlF6WXMrVkRKTlpQYzJIT09H?=
 =?utf-8?B?Q2wxUTRoZVVPTmRMRmRtcUZwbEc3UHlyb0tuLzIrTDlHbUlVUkFtcEtrQ3ZI?=
 =?utf-8?B?aUcwQTZjZURLK1VFRmtpbWk4V1l6dEdkcllYd2ZEM29IMWVMeUwxWFI5c0F6?=
 =?utf-8?B?N0trYUJGUUpaUjErL1Yzb1ZMSEtXZ2kydDNvQVg3b3hQaGZSWG1KNUVlejVI?=
 =?utf-8?B?Vm5uOVdMTDBad2NlV0JOTUgvZ2hiYXp6SjRIc1NoNDRZdGxYd0QzN0JUaXJY?=
 =?utf-8?B?bUlKajNZUWhvUlgrUXNRZGJmcStNMHdmaGxhMU1MZDhCb2lTNTVuNnZzSlZs?=
 =?utf-8?B?M2NaSG05N3BlZnR4eVFwdmdUNXBiNXBrZTAzd28xNVlyTTdydjVvdjJNVzBq?=
 =?utf-8?B?NkVCcW9nU0RrdjlOQlJEWmd5bklFUTVQa1IyckY4UkN3VUJ6SUdndGJ3NGp6?=
 =?utf-8?B?TVlqaEVUL3hJcTVWMTIrRUNhbElnSXRha09idmJoZHpXMG5IU1RhQ0hUNkpy?=
 =?utf-8?B?Y3dYNGxVMUZFYnRLZ2d4cVRmSzM1OFNwVE5RNXFYU0ZQR1lMQWM2ZkJHNGhv?=
 =?utf-8?B?VzZteFg5V2ljZDlMazEzSm5rV3Bxbzk5d3UySWdiY0k4ZStQSEZtSGdhVDhM?=
 =?utf-8?B?ODN2ZlJaNkhNZzU3Y0wvRXhOajJjYXJWODlzVVlZNGN4UDlWQnIwRCtQZWJO?=
 =?utf-8?B?Mmcyc2lsZVFwN0lBcjJBZExvMW51cDhTd0EwMWZ3UzY5ZmdxWGlwSXZXZHlM?=
 =?utf-8?B?bk5yWUljRTFadXhncEtsNU1vYUpEdzJJUFhITlluVlo4K2wxOGVVa29MamlY?=
 =?utf-8?B?YzZzVHhkckNjWUd5WkIrc2x6TGpML2lRZy9HS1d1cmg4L3F3a0Nqc256RnVy?=
 =?utf-8?B?WDFPcXFMakpIVEkyRGRTUmQ4UzJzTnFPeDJHcHhaaEVIR1IyV0pMTGVEUVpa?=
 =?utf-8?B?b1VCcjlBU0puVE9tUHhrbkFFY2Y1STFjRU82dkNlY3hxRUg0QXJPbktoN2Q0?=
 =?utf-8?B?MG80cmJEUkhPOU1MWXArdjRHTHhXSno2OUlxTlk1YTZpZmFqM3k1amlHUzJF?=
 =?utf-8?B?VDd6cHd6RlA4MURTK2toWGNxSEVkQmlTblljNHVRRVVpeUNqUGcwNFhvQTY1?=
 =?utf-8?B?cUVNZkpBVzkyK0pNcmFsWEMwbFlhTUE5RVZocFR0Yk91TmUwZ0tqNGVCQkpz?=
 =?utf-8?B?NHdQTFZycDNjS0JCdHY3QUpoNlptcmQ3UVpuZU0wS1J3Qng2V1VESHIzZDV4?=
 =?utf-8?B?OVNyc291RnJ4L29wY1FTOUhTYzFlbGZBUDhLVTVPY0hTbElJWWxuQzNMb1RU?=
 =?utf-8?B?SytqMEM5SkM3SWNoUzRGOHlSWnNMVWdHRXlPdnQ0M1h0SngyL0dEVjdxL3Jh?=
 =?utf-8?B?NWpRMnl6MjJpUVJDZVhjYUFWWC9xU0JHU09QTXdkRHJuSFZVS2o4M2wxNEx0?=
 =?utf-8?B?RVVUZTFHSldWeGs3cldLeEw2TW5SM3R1WnU1MlFOQ2poWlM0WVJEcUhYSmVV?=
 =?utf-8?B?ZEl2QU83TU5Sa2I5ZTBsVGZxMnFnbmNRSEVORE50RHNQNllQeUtMd2ZoQWtC?=
 =?utf-8?B?MkF6a3V5QUt0LzNZTzdUSGdQR2dZY1diYXpJVzJSOEZ6WDlGK09sU2tQV1B5?=
 =?utf-8?B?UmZUbDdqOE1zL0hwNWJLUlFQbkZZQWdwaVBiWWtBazExNlBXa05VOFJpajJB?=
 =?utf-8?B?MWFkOFBkMzhVKzhqZGVHd0VURTFiNmk1L1RjZW5Kam1lY2t4TDFWaU0wcmVL?=
 =?utf-8?B?R0p2ZmhXRGozV1ZXaCt1Ym4xR2xHdTFUUjZiMERxOGwzZTRLeWo5dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf4eb10-487a-4a73-bebf-08df0206e4b5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 17:41:14.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVG2DNcZKPac/9ap2N16kqwhwPgi/TNTaNNqwp003qhWa3bNFh9pUuu8+6eD2fXszAxDW5GahYkAbuwG1c6UBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8820



On 24.08.26 16:16, Jerome Tollet wrote:
> With AF_XDP on a striding RQ, mlx5e defers releasing XSK buffers until
> an MPWQE is refilled. If XSK allocation then returns -ENOMEM,
> actual_wq_head is not advanced and a later NAPI poll retries the same
> WQE.
> 
> mlx5e_free_rx_mpwqe() leaves each released slot marked as releasable. On
> retry it can therefore call xsk_buff_free() again through stale pointers
> after the frames have returned to the XSK pool and been reallocated.
> 
> Set all skip_release_bitmap bits in the common error path of
> mlx5e_xsk_alloc_rx_mpwqe(). This matches mlx5e_alloc_rx_mpwqe(). A
> successful allocation already clears the bitmap after replacing every
> buffer, so retries become idempotent without changing the success path.
> 
> Fault injection forced three consecutive failures for one selected MPWQE.
> Both an early allocation failure and a partial 8-of-16-buffer unwind
> released the original 16 XSK buffers only once. Each error left a full
> bitmap, the following NAPI retry skipped the release, and a later
> successful allocation cleared it. A 20-second AF_XDP zero-copy pressure
> run exercised 1,575,262 buffer allocation failures without invalid
> descriptors, WQE errors, or kernel warnings.
> 
> Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jerome Tollet <jtollet@cisco.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index 4f984f6a2cb9..55ec6387ab28 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -3,6 +3,7 @@
>  
>  #include "rx.h"
>  #include "en/xdp.h"
> +#include <linux/bitmap.h>
>  #include <net/xdp_sock_drv.h>
>  #include <linux/filter.h>
>  
> @@ -156,6 +157,7 @@ err_reuse_batch:
>  		xsk_buff_free(xsk_buffs[batch]);
>  
>  err:
> +	bitmap_fill(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
>  	rq->stats->buff_alloc_err++;
>  	return -ENOMEM;
>  }

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos
