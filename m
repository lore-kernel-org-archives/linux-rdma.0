Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012022.outbound.protection.outlook.com [40.107.200.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102B3E7625;
	Thu, 15 Oct 2026 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046422; cv=fail; b=RjBoesSqAu+jhHhnRqQN6gLn6FkRRZdLCSn09+QplUE6zSdFsD3uwwz6uahtH0iUh/pGhj+hBc+dOtZHESsi8k19aZhMC5XeUELT30Ax9YbX7XBxmk9z4MuvmcTNFpwsFHGPNccAEcdO5TZG0Y0w05GvyxBauyrX7Vn3gWMAeKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046422; c=relaxed/simple;
	bh=Ihk7MmAP3q9GbW11znxdle8Om2aR2UA15UbWpb1b8LQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ulw4xK2tOWK4tURq6bj/+4UswE4744mIHZAyFhpQbEUtKySyqKKqeHxaYkcV3G9fcCBYMRY0YnBRfVX02qp4rM21orfTup9XZJgFAAgeQ+jJb+dMI7p90tN9xE+rX6tnJj0kk8W3AMXIJJhKRufncxst3YVjqmsK53B7GFfKdnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KKOHvzm/; arc=fail smtp.client-ip=40.107.200.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KKOHvzm/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZzFriovATMBGwakJGVXkdSrIBu5AswlbMewBHfm83xosB/vIlf+oCchA84MY0r3AP4+nMkIG8PKRhV5obPMYtYLiHxTEhjJuIg4NkzRnUcGWYgwSID3dKegPgMrKceEShDhwQe/NzUkvNaAz8n6kpskyo+kvMlpzIxoCqmKuO3ZnfNz78sAn6w9wwituswekTBPuMfF1YmmMDO4xU6pNXhDr+8sekwCKmhBYzWtdrLN7a2KnmTYa9T6o5NSdsBw3OmW9ljiPQ4UafJ+1J7Ug63G7oj0XBL4vdThXfu4f7FHQXBlo2eETimPL7V0vVX/kWL7PPItozi/kCkWm3sk/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7grbzYZG71SigHSq+usNoOlHanClulfUrANVpy/7EU=;
 b=Z1mHrjpCaD8fExm5oe96a/pjb/UCc0D6Xiv8YHHroAfUcpyg3i2E4rp/6Ynxbiq78jSKwrBWm07F8Nkd0XAhAjMt4H3sAUpWQ1XOax/+j71LuEgaqZHt0DN4Hx3zvngY5ktohoSyNYopzTSPB3vZUSKi5tXIUQ8AZA0g46hdqUHKCn7kGySU3KXBYqokpOnvg3YoYeoSyR5KPLT/6HNYf3UzYzNlocEkg4OlgyZXuM/xnNQqJwqkavneoRIewKbHM2EwY6eY7+4WA1Tyd7JNUVT/NxK7Jnk9HyPePf/xhgiPpfzMPJl4VbC9PQTPBg+aYqvu+hJ/ttrAZ5I6sbyEcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7grbzYZG71SigHSq+usNoOlHanClulfUrANVpy/7EU=;
 b=KKOHvzm/t9OQoCo/71r3Wl5kVTKyBIW/inaOa7/LTaDalPTQ8mKD3JHw/4pWc5TnrUZMghzDXDkBRNV/+6sx4wWAMC3E8pvMtXuSfw7IXCc8IWf5K/I7vkMJQR/LI1QJuj5IeJ7dwSr1fzRg/0/jWuKryQ483Mqx7I65OyRn2x7fhiGPeO9LL1hXqlNME6Zez9yXB/2cwcioFyaB0ibbCKjSQ9LmEhd8Kiq+CcilW2vHtJUCPC574lC3UAzQTMS5jKuTwEo2u4jjE7f1Hsll0EF7eZhANkjdAiprwUaPrpOSp0tTosKOi/GFK/amPTiji0ub9IXspxFqI4Y1Xy/iLA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by CH1PPF989868826.namprd12.prod.outlook.com
 (2603:10b6:61f:fc00::61d) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 06:40:14 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 06:40:13 +0000
Message-ID: <78ee0cd2-ce26-4218-ab0b-629bab1ac7dd@nvidia.com>
Date: Thu, 15 Oct 2026 09:40:08 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net: mlx5e: Fix use-after-free of the MACsec
 xarray entry on RX SC deletion
To: Binbin Deng <18983559317@163.com>, borisp@nvidia.com, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sd@queasysnail.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261010032115.93545-1-18983559317@163.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261010032115.93545-1-18983559317@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::17) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|CH1PPF989868826:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba833b0-e318-4ba4-9db3-08df2a872ab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|18002099003|10067099003|22082099003|260925021911599003|260925022911599003|260925021311599003|921020|11063799006|261009220027099003|261009221227099003|261009221727099003|261009223027099003|261009223327099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	rLj5qfsRlMj9qvTPvHfDZGrZwP8ODiRRCRtAQ50ttWBI/Ts74sd9Q+dNk+MP0mefYh/gvibUXVNNDhEeWeDA0e2bim9QzO7pPMg39diaWVHmJX4yM3iktXhhfY3LPWv1pp6Yfe38kKFMUJ0PL08IL0lftjImakl8iOmoXMl8q5LrEvOLLkIJ54SP+D0GgpD17s77Ca7fhYze4l0VT7Z+fAJY8iSanbnk3DkWLFHYAudqfY1sMpuqbUchSBskjdQBHtJV7WPZwyYIMFmbQ/b1BcadFygfJz0zue0tuz/Mz1+Tv7sCs3PquQ9LEjlRYnZ3HI7tLg9Fk/WaNVoxzWhAQi2U0AW0Srd62tYjU5vThHs2GodUtmbY+UOkCbRZSOE2HrPn38jddWmBgpxQPJkdw4nX6xzJq82SkHJRgQpAr+YoTo0PK+9Id3F2l2hT6KbMXl3pk+o6Wy/JLgkx+L8yie1O7qy5BhFxDOlDso3r/KmuJ5fVSE/vFFsHltrLhFtZxHPJFby1ioZhb33vPEKgNk1BIDtOKjj9ENOFxEbfhguFiEn6j6mLrkt+XQWMJ1QCubiRU6jcuq4WdvYhJ66n/42VH2KSlbIQr6BfwmedSMLfQtmeSSj0QU9P0hdUaGJSKaAOvLd3IGqGH2o0K3cpG9LeWDADue0PZTqvJyLhRigiLq8RsooAerD4lUvXuqxFUrSWSMR+x4qDpi6DEsm4Dw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(10067099003)(22082099003)(260925021911599003)(260925022911599003)(260925021311599003)(921020)(11063799006)(261009220027099003)(261009221227099003)(261009221727099003)(261009223027099003)(261009223327099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1Z0UmNwNU1nT3BKZlFOU3NFSzEvdXRqOEhPa0Y0WU12US9xMk1JbVpYUzdM?=
 =?utf-8?B?am1UU21rZ2lyZktJZDNMSHcyUnhybnkzQ1gvTDVNak1WUndXaUc3Y3VCZ1Vo?=
 =?utf-8?B?MHlFK2hKQUVUbHJHMVd0MW5LWlAxMzZxZElNK2svbi9pZjh3QjV3VHlEWEIr?=
 =?utf-8?B?blc2RWhseXEzekRma0FsVDR1TXYydW8vdjdxenZqeXV5cFJBNFJiZ1Z1ZEpo?=
 =?utf-8?B?blZRQ1F6OXd2NkEvaG9YS2tpZ2IrQVBjV1kvbUJMbmgvN3FCOUt2NDZmRk5K?=
 =?utf-8?B?K3Nyc0Jhb1k5aVFVeE9LTkh1NmhNbkVUdUw3Y0g5MDlvM20ySHo3aWFHVnNR?=
 =?utf-8?B?bER2aGVKS1RyM3pwaTJ5aHFnN2k1NzFjRHRJbkoyTGhIS3FWWlRuUjN5bHds?=
 =?utf-8?B?TDZzU3ZxbUR5a0JjRmM4dGdJb2V2V3hYSnBOazByMUNhOUo1anlNZWlKYWIr?=
 =?utf-8?B?VUdkZFRiNDBoaU85d0tZa1pDVmVOVFgwbDNpNUxlNmFwLytPSXhMTWNMK2Zm?=
 =?utf-8?B?RDRZUU9PY0l3OHdUVnpyRS9xaC9SZVdpT0dEeXFFV29RZnFOb3VJUllOK053?=
 =?utf-8?B?b0NIV3FlVnBkcDZ2cXhZN1RhQ0FHVWxoWU5YUjlORUlNM0wzZXZUazV0RW10?=
 =?utf-8?B?U1htMTgrUHU2ZnBiL0FBU0FONVFnU2tVMVRJUzI2S1YvZzBEVDI5M0EyQ2xh?=
 =?utf-8?B?Y3grdUtEeHJlYlJYTFlvRThPY1NZM09VS0VDR3YvUWI4SWFURVVZOWUrWHlK?=
 =?utf-8?B?dUprdVkyN0dBWm45cWxRamVWZzdLUWJHMTBZdjF3c3dRaUZQc0twR0c3MlRx?=
 =?utf-8?B?Vm45Q0xUYVpnbFNXaFBJaHpyekNNTEVVbVJKNStEeFBpQUJ4UHl2K0Urejhz?=
 =?utf-8?B?dTB6TFJGTmVLWFhINzRwMDlrWGo1ZDhaTHp4ZDY3OENJWmZDRFBSazFFUzlC?=
 =?utf-8?B?ZXdDUlZsQlhuLzJUaEoxS2V6c0Y5bmVDc1J1cDN6SUl3QytKRUlGRmcxMlFL?=
 =?utf-8?B?TDRjRHlLcVVjVGRQekFSd0xFWmswVGxseUV2OVRxemlvajJhcjFFSUdHdzNN?=
 =?utf-8?B?TG4vcXAra2U5azUzNGsxREVrc1Y2My90MTRKRWttTDJ6ZDR2clVlRG5tTnAz?=
 =?utf-8?B?SGNDWS9NalVweHluZTNrYW5mYnYvc1hIb1Z4d1Z6aXBCN3pmTUVaMFdkWUlr?=
 =?utf-8?B?Tm4zMExiRDYxNTJibEVqWDlJUXdmcFBYYTJ1UnBkZHYwUDJ4dlg3RFowL0Fm?=
 =?utf-8?B?SWdkUktxVVcvQzl5cVBFT09wT1hsUlNBeTEreUlaM3FjNkhSZXl6UXFLcWxh?=
 =?utf-8?B?MzhyeUdBY1htbk5lTVlETjlYN3J5bkwrWmpKRjJtTHBUQ2NGUHIrWlhhWnZ4?=
 =?utf-8?B?MDd1MWY2bVZ6OWNzbFUyaEFsazdIRFNhaUtOalNhMGh3T1FRRmJmd3VIVmRT?=
 =?utf-8?B?cktMT0NDQ2VFOWp2V0l0UjZnNUVaNzJwTUdybUc3ckc0SWV4WXNYMDY4cEtP?=
 =?utf-8?B?MjRBTGxwNEsvZHgwSmRjeDRnSlBaMGpVcHFuWEt4bzlQdGtnRW5PUC9CMGts?=
 =?utf-8?B?eVpZS3hOZ1RYQUtRcStCZ0hGRXlVMnlmcjBpZmVNUTUrd1BsMnlaRzVXNnJ3?=
 =?utf-8?B?YzlIbUJsaXhMb3BKdGJpMnBLQndSci9tKzdTdXR0aXpMQUpER1I0Z0RhQlpm?=
 =?utf-8?B?V3J2N1RjNTR4QTFLK21DREoxbkpWeEROSkxZQXRWK2RHT04xczVmK1JYc3ZD?=
 =?utf-8?B?eS84VzlVV2crZWJ5bEpWMzMyQnFjL3g5VzBnOUxyQ1hvMUFrcEh4Z1RGQjZ4?=
 =?utf-8?B?bGhSQWQ4cHZwOHpkNGNYUDBkMFd6K203S3R1dSsrUGkwbUJ6WXBxOFFvVlVD?=
 =?utf-8?B?cituWHlBQ3dvdFVzR0J3RUNFZThtUXJoOFIzbWNJSmhhcXN4UHNKVFhRRG9j?=
 =?utf-8?B?QzdGeDBCbjBoNjRKOUtHdG1YOUc1S2NINkFkcnNDUDhJY3NBY1AyTGllelVZ?=
 =?utf-8?B?ZHNCRGwzODNTMHplS0dmVjFvcG1vRXQ1eGwzbTNSbkNVaGVCOFBJMDVNMGo2?=
 =?utf-8?B?bTJSa3d4YVlCbXlCM1ZUY1pDSUUzTDl6TmFWWG1nVGxodnZ1cFdET29tRzZ6?=
 =?utf-8?B?VUVZY3pBUWtZWFJjRExWUnVoT2tNdnh5UHpuSkM4VFpHTlk1aTliYjBHVFU3?=
 =?utf-8?B?Qlo5NThLK3JLaGlwTWp3cENPNEl3eHhnaDArampMa0M2a082WmpGaXN2U2Nv?=
 =?utf-8?B?MFpiVVM1WFJqdUFnUHVuTGEzOXJpa3RVblRjcDZGT2hxV3ZxeFJUNUJ3QUJn?=
 =?utf-8?B?SW52cGpZSXF2RVZxYW4rTUViZVFmU2QrKy9oU0VNUEE4bUtFdGtsdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba833b0-e318-4ba4-9db3-08df2a872ab1
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 06:40:13.5946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQAlfM1wYjYBIj9ESfy/sQEDpNpiZMORZk9ZWyRq06i+d4EYofBbkZrkM/7ft0CDTB7L594cNbqNjO9YJ5aYuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF989868826



On 10/10/2026 6:21, Binbin Deng wrote:
> In macsec_del_rxsc_ctx(), the RX secure channel is torn down with:
> 
> 	list_del_rcu(&rx_sc->rx_sc_list_element);
> 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> 	dst_release(&rx_sc->md_dst->dst);
> 	kfree(rx_sc->sc_xarray_element);
> 	kfree_rcu_mightsleep(rx_sc);
> 
> The comment above the sequence claims that "xa_erase which uses rcu to
> sync" hides the RX SC from the data path, but this is not sufficient:
> the RCU protection of xarray covers only its internal nodes (making
> xa_load() safe against concurrent erase); it does not extend to the
> object pointed to by the entry value.  A reader that has already
> obtained the pointer from xa_load() is not covered by any grace period,
> and the bare kfree() releases the entry object immediately.
> 
> The reader is mlx5e_macsec_offload_handle_rx_skb() in the NAPI RX
> path, which runs under rcu_read_lock() only:
> 
> 	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
> 	rx_sc = sc_xarray_element ? sc_xarray_element->rx_sc : NULL;
> 
> An RCU read-side critical section protects only against deferred frees
> (call_rcu()/kfree_rcu()); it provides no protection against the
> immediate kfree() above.  If the NAPI reader loads the entry pointer
> and is then delayed while another CPU executes the deletion path, the
> subsequent read of sc_xarray_element->rx_sc dereferences freed memory.
> 
> The path is reachable with CAP_NET_ADMIN while an RX SC has in-flight
> traffic: CQEs carrying the fs_id metadata can still arrive after the
> offload rule has been removed, so deleting an RX SC concurrently with
> reception can race the reader.
> 
> Note that the same function already releases rx_sc itself via
> kfree_rcu_mightsleep(): the author was aware that this teardown needs a
> deferred free, but the intermediate entry object was missed.
> 
> Fix this by adding an rcu_head to the entry object and releasing it
> with kfree_rcu().
> 
> Found during a static-analysis-assisted audit: candidate sites were
> surfaced by a Coccinelle rule, and the reader/writer paths were
> confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
> not observed at runtime; it is identified by code inspection only.
> 
> Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
> Signed-off-by: Binbin Deng <18983559317@163.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index daff53ba7d09..d4caa7affae6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -75,6 +75,7 @@ struct mlx5e_macsec_rx_sc;
>   struct mlx5e_macsec_rx_sc_xarray_element {
>   	u32 fs_id;
>   	struct mlx5e_macsec_rx_sc *rx_sc;
> +	struct rcu_head rcu_head;
>   };
>   
>   struct mlx5e_macsec_rx_sc {
> @@ -839,7 +840,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
>   	list_del_rcu(&rx_sc->rx_sc_list_element);
>   	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
>   	dst_release(&rx_sc->md_dst->dst);
> -	kfree(rx_sc->sc_xarray_element);
> +	kfree_rcu(rx_sc->sc_xarray_element, rcu_head);
>   	kfree_rcu_mightsleep(rx_sc);
>   }
>   

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
