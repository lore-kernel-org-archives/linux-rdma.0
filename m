Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012054.outbound.protection.outlook.com [52.101.48.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B0F55C9EC;
	Mon, 19 Oct 2026 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421355; cv=fail; b=U6QmbDxW6VIj76c8IU/GYCTPeI4QFp3fRJ1Q/BOB0y+b/NzM99y+kIorUiDBws6agNO9qAVKFJkdZZd67N52GwRp8v359CrYDM564sKvoR0MlXO72Fl7dLBpNJeWx6kbhBN1Vv3YSP6T60zyFSd2/FhZbX7YrNSxkn3uAWjJeqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421355; c=relaxed/simple;
	bh=wC68wnfmCHgnxzAUyjuhEDt5z2hC12la4jzvC7m0qto=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZIPqk6dn7uqkysF1uUkMleWjMK5WHNxXEKID07qfpJhHee9/QRBXpiaWECOnEivLPom8g0eKc4CqfMQp+D2MY7oi1OxLvbX0I93RAjlOy0F8us1KyztllqTsU09ju/i9mHAXIs9AIImgLzTi7iS9UcsmVs6FmWlU+JOWFBTl9tE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CZUVXABA; arc=fail smtp.client-ip=52.101.48.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CZUVXABA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d+HLmWVqIESRkUY+a3txqBxNlrfi2ZU6Ku8m1Eb5gT9rtfTZOxV282fJmEMo6I6unSASOYabHtGoTwkEoq/9u+q1j2Dm5pJQbnD7HKAX1MVK7J677olEgxmtOjFlBjBTJoyXywxvMqPt5IWEWAevACp1cJIZ84mZj0ZlXgiZZAnqmVFRntZzsyShh1L/k6kTWsPDh+HfQWIuVUuLMwLUZ7DLbGg4NUdB8/x4dM+u4ucXOv6I0TZDaLj9b4eijFx3gFC/6eG34QNgdZyNpzWiVCStzRloo0ANKqV2rpuot9MER3OBXm52MVYsYIsLuFQO96mK/1/aJAnydcBZ93CFwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAJpuXX7hh9Vp3aHuurLTcMRuLISFWZnMlV1rABE67I=;
 b=EhGOaxtt3HdmtzwW2GnnNL8pfpd1UGRihWx6/Nle5vVHYV6RBVTRc0I/SbhtD8SeG8U9Hn3++YDhehzSuXoB2wV+O08i6HgHEhcDGczWRrWud7IVy6hAErwK6HHo/nypEpltJ+Zf0BxreF/9HxT0vaMoR95s0jzFDXTIzPGX82VpsjdpVcidmyKU/NjhX+fvjD92Rjgn4Gt/ppRuyg4WBIoM1YuFL2AziYksLkiCzilFrjKMha0WG02bmCge76BLKIu2y30krI9yG0NX6VzpE3Xx/iW6Zfcg0ZyC9L8/6OqKgG7FNoGsf1I4xTcE7PBLISbIuFgEwzQ90rfPMxwwxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAJpuXX7hh9Vp3aHuurLTcMRuLISFWZnMlV1rABE67I=;
 b=CZUVXABAD5tNc5/pe4u28LprK7BMLhnbV1Z4IiU4czDe7P3FcZO7gBETE2v4XNDhAw0EI9F8WgccDLfn/fy/kHd6NXUBiCGtlTzk2GbIyPkPDR6ufLwGPDJC7mcSUolBon+dzaZngECWq/mUBmlg4whOkALqFALWkuB/RIP3N1wGjGfIOGY+zXtOJoEggcF8JDOifixGWFASFKtaEyymZczqkcGLZLmGhdSS7S+Zrxgeh42PK4zQ+NHUEqmVeZIOjKGECHuwwMCOc4viR8YfXSNwZ4EXSjrXPI50VTZ/lpfD2G357WXafFkY/9RMVqonNsuUszgo2AooA2yJFrEMDg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 14:49:10 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 14:49:10 +0000
Message-ID: <0d3ec087-8db9-4bce-a81e-608f5318ba13@nvidia.com>
Date: Mon, 19 Oct 2026 17:49:03 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 1/2] net/mlx5: HWS, fix modify header pattern
 compare on big-endian
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Hamdan Agbariya <hamdani@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261019133159.1742411-1-acassen@corp.free.fr>
 <20261019133159.1742411-2-acassen@corp.free.fr>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261019133159.1742411-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::12) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|MN2PR12MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 0103a1e0-871a-4429-1b73-08df2df02250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|10067099003|22082099003|4143699003|261009223027099003|5023799004|11063799006|56012099006|15866825006|41080700001;
X-Microsoft-Antispam-Message-Info:
	dKN38GcDvp7en1HiPOU01zMiuhn3S7IWU0KI4LStxC/S1A5Fp5imcyvZ/ioGC1YXyjZVLiMweUW75x6Jloyxke/b/yuZcZi/mbiyOewsUp9+ph2+cHhzcFQRZtAK+LhJbRH5xMFtLtlF6zEqIzzatVIBQL9fbRGjH4gD3X70AFj37cmVXDp58+Z7CCc8JRvZ6z3u37+KBkJ4x1yPOmK8K6np5C2ZsUIGGBCiURP6tyyxpxLhu3ombWZJjcn0yumDf62xn7msUtQ3sfVjubsZtLJgOP6cqXTjnp8Hchf/MIHbiOgcQAgYoMUc0xqXehr8A9iuuql0Er6d/TWfcjjeK1sClMWG4K0NWOf0rAzoW6SoxDG6SGT2JgJLP5bFU+cd/MVVWMoIinjppbeSxeFY9dV1lv1TRc6cRCFukaO/5KG0cMj5Co3yKCYCyC3HteJB4+I7LFi/TTkJZRBi/73XNeLeMBKerBzMwuQnNYbjYIRA039J3Fq2N3vmjK4trMgMBXlIq1i/Smg2EnrmUflarZQFJ7SmzcVBdJqSjnOcZihDry0znN9vWl+6eBk523rnFLDTGi12AADaTjE80b8PzceHOMR5/+4Kiv0uUrw+/SE1bLn6CXL7Zve9vt35/G7zQpYS7eS4tB8eoQMDNnfSV6HTS39Jb0UsrAcuQW8OXj+HjHFHHyVi0LbDCzgRYRdrkzeyl/lbm6vtYaYvBf1MoZlcYXORr1gaOVyUGBnvzvJ87kVsZwPK0p0LgM6yM4I1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(10067099003)(22082099003)(4143699003)(261009223027099003)(5023799004)(11063799006)(56012099006)(15866825006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um5zNmlOeFQ5ZHEwTGZWbEZoSlRib3BZNVdjQWVUSDNaYStmNEZRODB2cXhT?=
 =?utf-8?B?S3JScEhKMzNJOXlnSHp4RVdzeU5FSW9QL3kwc3l4Ty9oMTh3c0tXc1B5QXI0?=
 =?utf-8?B?T1BiR3VUZzJrSVRjT1prZjd5eVJlSmJnNklZUHJsODNYdDlXOFFuRGJqcFpr?=
 =?utf-8?B?R0xjVVFmd0JObU5GcmhUbVVwM3l1YWQ4eW5RVU5jOER1Z2ZHRTRxZmxtRWgw?=
 =?utf-8?B?VWVXMHJzWTNGV0dPK2t0T3NVeGorWVZ4eW5jZTh4R1hZa3NPK0VoQ0N5enZj?=
 =?utf-8?B?QnlPYzd1MGkya3NKRTZ4SmcydDZSaXBUMDR1Q2xKUUdPMEUxVDZhNVdGV2Zu?=
 =?utf-8?B?aUxad2NodkZVQWR3RFUzeHo5bjVUalZ5cXlmb0JBUmc3UVY1WDA0V0lXQ2Jz?=
 =?utf-8?B?dWFVWXVHajNtTlBVbWV1cVdFQUtWM3U1dnpZRnpjTklCU0U3TFJGejRURHgy?=
 =?utf-8?B?cUd1SUdobFVaVDRYdXNkUWhjeG5CcmgydXNyakVFejc1Mkx6ZW1TWVgvNTJN?=
 =?utf-8?B?SjRUMnRtdVV5dk9FSFFPTDBoaHh5NmFGMWd0bDQ3bU16Z2NwaERKYk5UUmdw?=
 =?utf-8?B?RHQyRlhsSEhSYjlnSWFTK0FnQlpNeE9aT1dsTlFpdnlpZmlXVDN2Ykp5eUR3?=
 =?utf-8?B?L0MvYjZXTlBmM1JnTDQxNlp3MEpYK3lOU0JYNVUyNUppbDZDNENDVGh3dVVC?=
 =?utf-8?B?ZHY4ajNycnhKTldlZ3c3Zkw2N1dNQUpYTXR2MVVmOWlzbkpLMkFRTUhienBx?=
 =?utf-8?B?SlY0WGpKdnRVMmV4MjE2LzByczRQNUNmQVU4bXNFTGFJd3Y3NkJXVmw4eEZU?=
 =?utf-8?B?bnErMjhZbzQwMFRMck1hMndiTDBWeE9pMExhbUJIQkR6UE9Xb0NIdTFjWENh?=
 =?utf-8?B?dFZaS2pUZGVZR0w3V1A3Y1J4MW5sV1A3c2VQdTl5UUtpQ280SkdNb3I0UlJ4?=
 =?utf-8?B?TkVtTDhLMTNvVTVVQUZMNlVjbWFiNnBkUHB4ZXA1d1ZkSnlvRmlFU0VPV2ln?=
 =?utf-8?B?U1pnZiszQUVPd01JRTlJV1NaRWd6bUZUejNyajFUdVlFMWFiV1BTeVI1eEtC?=
 =?utf-8?B?eXNzOWxhKzlRa1M5K0pGNjQ0L2lZNlNXMko0dU81NG5QV0ZxNk9mdWYxMEpR?=
 =?utf-8?B?UVhGcGpJTVpkcEFJMUZMNWMxaERWNW1JTml4QjNCWGFCblNQeHE5TmFxY0c1?=
 =?utf-8?B?S0tSUnF3QVRRUnJ3bzI2bGdDVU45U1ZpMDRJa0FXR3VQU0hod2xFU2FtRTgw?=
 =?utf-8?B?bnl2aG9UV2JTSmozem1ROUVDc01IK2lQZEtFNk45c2NEMFlncldpb1dzejRE?=
 =?utf-8?B?aHFLZzdPaXlLd2dSNWxxeGpOVzdDMWpEeHR5ZnMxVnFTclBHNHpDMjVrdlMr?=
 =?utf-8?B?Y2pzQW5kQ3V3eUltUmdTalRmN3lZdEZPYjRLUHJsL01zOWRvMlhVdWRTTlI2?=
 =?utf-8?B?RkMzSkxMZjdWR1BqUHlvdVBEV1hQWjRNVHZuQ1F4MkRvVDlSSUtKT28wMFFv?=
 =?utf-8?B?aVdJdStHM29vQ0ZmU1RQbDBoUUFUMzRmTGExY2pjL3ptYUFENHhva1FHM1h4?=
 =?utf-8?B?ZDJ5RWc3SFU0bUxnTklKeWNFNXhqVmRKNGhvM1MrRGRkZzViaFhDemNGemd3?=
 =?utf-8?B?bmFONEh3YnpjRlFubE90TCtJTWZCU1Y0a3dLNzhwSVgrS1RrdXMwTVVKeXN0?=
 =?utf-8?B?WGNTY0FGYjRSa0pydHZVNzIya0FEWHNuVTRQN0orWUlDUSs5TFduNWVWM2Qz?=
 =?utf-8?B?ekhxQUtpK0QrQzVXQWIzanBUbjVxUUx4RTFOWlRyUkRHeG4vSzFUWDJ5QTZY?=
 =?utf-8?B?R2diUm5kL2ZJdFpNWkl3ODBkaC9nc2V3ditxaXlkZCtFMFoxcWV0b1pRNHll?=
 =?utf-8?B?SUZWbFRDYmJBaEUzUGdjRU12VTdIZHIwV2xTM3NRcWFoU0pwTHhHcEFNRTFH?=
 =?utf-8?B?bnRNMExnVEZGK01HdDd5TjNQanZNeVFxNE5DcHJkNHY5Q0JJZ1lXOFozZC9j?=
 =?utf-8?B?Y0VEWTM3RlF1ZXI5MXNpZUNFUmdhS2twNVFCVlM4S3lzaVRWZlg5K0paeW9t?=
 =?utf-8?B?L2NsNS9ZOWJxV0kvMFZ1eWJQckpYVlNRNnYzVkI5bmtBSnk3em10MGhsTTN0?=
 =?utf-8?B?TnVWNDkxbDNnaTUrU3NtQzRNM3lBS3Y3cmJSM3JmYlZ4UndCRy9JUjROaFcx?=
 =?utf-8?B?K08vdE5rNzl6QmgvV0tjQUxuNGo1T1h0ZUhkdk5SRWVRbmJLMENTaDZLS213?=
 =?utf-8?B?N1NaaDhQZ3dqVWdQRFpzeTl3RGxMSFg5WjhVMnJqenhDdHBpSGxWQnZWWUFH?=
 =?utf-8?Q?XSgapD7uS8xEVVlbIy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0103a1e0-871a-4429-1b73-08df2df02250
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 14:49:10.2307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgGuaiT5r4MkoqlaeLo1tsuDJtWxh2p0I8W4BTk8AvtCiDXRXIjxbGIlAY2vfBUXaiQSgslVhQlPiYeEnEm97A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390

On 19-Oct-26 16:31, Alexandre Cassen wrote:
> mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
> compare only its control dword. On big-endian this keeps the data dword
> instead, which HWS clears from the pattern of set and add actions. Two
> such actions writing the same value into different fields then share a
> pattern and the second rule modifies the wrong field.
> 
> Read the first dword of each action from memory instead. Little-endian
> behavior is unchanged.
> 
> Discovered by an AI code review agent [1] and confirmed by code
> inspection. Not reproduced for lack of big-endian hardware running HWS.
> Tested for regressions on ConnectX-7 with firmware 28.48.1000 on a
> little-endian host.
> 
> Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr [1]
> Reviewed-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c    | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> index 9af449c2b4d5..512299b59fd0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> @@ -116,8 +116,8 @@ static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
>   				return false;
>   		} else {
>   			/* Compare just the control, not the values */
> -			if ((__force __be32)actions[i] !=
> -			    (__force __be32)cur_actions[i])
> +			if (*(__be32 *)&actions[i] !=
> +			    *(__be32 *)&cur_actions[i])
>   				return false;
>   		}
>   	}

Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>

