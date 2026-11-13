Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794580160;
	b=sHIq17QwGFdecr6HmqMNcIcL37Rs1gyGsmO/lweBDBVviGITYmfMB/+LiVsA/a0Mei8q
	 xvOaqNbi/49DoqtVJ3+4mmqdEZtrrhuzn47MHVauf+htH3APvntrpEUu4WUwCgdjD3qVw
	 ZvAlHv8w2c+twGb3Inyb7QpwdywDGkuZerfcKmUDL6e1kc2Ckw5VdxTqLv9cyhERpQ0k9
	 TMCrTONtRFHMPkKv+tTh25V5jf7jlSvffaC1khExoXu/RxLNHiQ+Fpv9fvNy/dFEiM8mg
	 kVPkq3BxtjxRvAlk0SYj/e4aBq+uzH9suX2Fv4tMzli0lw/JAGUMek+pfj6xgXilKIg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OICuhvTZflej+WWR7scHPBDRm7v1T31zRnEt87KO+lk=;
	b=Ww1n5ZicOjGlSpyrhavVg2E0ANIA2aFwITrjcI9j7kgAoDkmBj9OEO/RnakKrFH5pM1V
	 xzkupSCTcpl/6022eAyUJvsWrT+vGYZ5wEicCf3ESjbNbqoFshTnjuaC/DwZuqKDWLTDB
	 lQTEo0oWEHgF+8k1/uWTwUNt3SwgitO8km+G5ARMe3e52lAMlPBh0Ru6gpXC5dHsd5rBM
	 T+37n4J4WHdyFVIo0JyC2fHNnciRadRrR0C5kS6dP8P8dvfjkArmBZxZKPU7cCO47ekw7
	 BgNC8rTSx2G+ZceJtMV8ETZCiS3aT8skqkhLNm0+50C3y1+MVoL/0ub1zZ9CCD6sR4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dvmg1RR1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.70
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012070.outbound.protection.outlook.com [40.107.209.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66987606A335;
	Fri, 13 Nov 2026 14:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66987606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dvmg1RR1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iV92TtQHqRbyUawm3iPLhaa5pW7hRDSKHcYET0R1EBzVgTXkspBK1b9NDoxiV1BoLLsQoFz0gPIT62fgVGfjDHpy5cAkgPPxsWBa0whnFVDfIu/Ix6qlA/2ABCH3YZpFeBPLknRx8pQxzR9VcBvvb7i04T9Q/3hBPxM5xkk9IqRWH5hhXeqRUBf2pg4ddhEtj9PBL1U7PAGlXj4r3Y9cO4kGzJDCd3P3jZn4i0dANOKWVIlCDcuSi1m4VLjU4fL2ouefdYVusfrsSvO2UpjjUDaJPPykMcyBiqKgZggQHY6Kt10zullFv5Bil9CeBsnvDuGPJWbtEoHjsF/MEzap5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OICuhvTZflej+WWR7scHPBDRm7v1T31zRnEt87KO+lk=;
 b=pTF1Yc5kk1WVHIOmS0iSi0vIeYtgqZGP7UgWXIEn34ccGb1eEzbQapcsRHwGDebKyJXwvfYC2MUQW1ibJAS0hbNaW1HWKac5u8nU37NoFB/wq0osrtlcl/tIbDUNrhS3Z2gXUG0HLgDgIhh8up3FqC3raUh9zL49ueCGGjmU3T76qtZuMS7WxBkSM/Y9TcoEmdMCkEhGD/frloXB4waLeUyErM1oQ/kYZa2YIzdQEQDAeAwUWb9uinFqpAYggL1y3NUqri6jzwJf2aFfGY+Wn0PWS7dFDGnD7F+hY+H+pmee/dxErj7Sf8iI3TFhFemEc9yZHQ6KtVw0KSF/TvxqGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OICuhvTZflej+WWR7scHPBDRm7v1T31zRnEt87KO+lk=;
 b=Dvmg1RR18osuDMghg+uGsUFVRpnN8/O+NDNlk/4lSfJPqjVLcv0AZWQCsWccVt9EXgjtQkd/L5o5ABYum47p3s6EvwcpX9qi7Vymn4Gkw8l3VW37DJ4cYgH8INzP4fhNHvhT2Y6eY3yewaii9zI75x95OcMhpiEQ8N6/SyEnUrqLh3iJQ4tWljm62vEv+UeTxg6LDLo9hh7NdqFhU593HOgBdbEfq1rxBKSz6CJWM915Zsbc9evyVmI8GEyfjwXEQB56FPvRUT7D3DKFHWwyykpvJMxL3/mMq9lv4mwtRyESr7N/awDcOgPunkjNbGdj3SdQPah75E0IWajgfmdpMw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by BN7PPF8FCE094C0.namprd12.prod.outlook.com
 (2603:10b6:40f:fc02::6d8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:29:08 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 14:29:08 +0000
Message-ID: <52cb2c1f-5fe4-4c9d-bb41-3bdc688a6c2b@nvidia.com>
Date: Fri, 13 Nov 2026 16:28:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 06/13] net/mlx5e: Add data direct RX
 infrastructure
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, erfansh@meta.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kaifengw@google.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me, sdf.kernel@gmail.com,
 witu@nvidia.com
References: <20261110183826.2927274-7-tariqt@nvidia.com>
 <179447640550.2199510.9976355768850888899@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447640550.2199510.9976355768850888899@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|BN7PPF8FCE094C0:EE_
X-MS-Office365-Filtering-Correlation-Id: 40c94c30-63ff-4f1d-d933-08df41927a16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|11063799006|4143699003|261021135927099003|261021121427099003|261026121527099003|56012099006|261102123227099003|261009223027099003|261028144727099003|261026140227099003|261022105027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rGpvHXia3E8IOgZFPO16R9Q+C9yiTu51C1E4jB/JENpaodeDmjdT5XnnBXV0RSAt0GkKyTYJw/sQfu1WfsTwgZQU2ja/T9SKiFjj0XmtnuKqwFXcTZMpy1dHpq8U7jGIWsV8BYt+xGML+4E8oIfK8yecka6BqHm0j8zzdZvejwibBam3WSnRJL2Hf2i+P7yv6hcySWRse32ngqBa/p8juKdLOJWYaWMUPYTdEyVdLQCa+vCnCRVdqYYttXNsbuKa0BpTaGSRQtHr3kY8OH/z2eQwTZE22Sz492jtFZvaTZEpmuW1Z/JmO+uWPmXNUTb6iaw7J0cPSOMPt2xuVPt2xZT19PP+bXhcfz7eNGs+gpCt30FIu/NsIdassvnR0+x0Ba53ZnBZJyUHMhHG6kzlcxjHZrdVSRvZiUxD5hSe1cVl0L0InxuZD6oeo2DWytCzSIV/eIhSFwm8ab24R9dE/PTn9eDJ2DsRBWHyC7V/2vLtBNxZeRI9IrfF+izrAE1zqW/ic6VF8kMb9RZiQOdIN24U8eqH9urghttPvlFECNUXFTK2T8zNFHMw6ZyTRuT/UUY/oiGqSUhKomFbtATlT7GZ8wFOIJmYT/z3fqTJrj/ae5f2006GKO6kCoKQYsOePPbGp51gTBrUsuvpK8MjF/RYXvF62vekJUVdhmiVtek=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(11063799006)(4143699003)(261021135927099003)(261021121427099003)(261026121527099003)(56012099006)(261102123227099003)(261009223027099003)(261028144727099003)(261026140227099003)(261022105027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkEzMFNRTDJVWkIwS2gwdWs4YmluNmgxaC9udUM2TGg5S0x4dDR1dVlvTTJt?=
 =?utf-8?B?Vm9DRUd2S1NSV2M2VUFnTnp2aGV1MTlBUnhCaVYzd1BtdWVRMW1vTTE0YXBv?=
 =?utf-8?B?emhFei9BT2RSRkw2c2RHbmZlblFhc29GOXRYNHAyVW5CRFFyNFdMcDNxZkdq?=
 =?utf-8?B?dW1Uc2lVMHExdzRxdEtkSDcreTZ5VVhsQThPT2Fva243T0IvcTRBZVl1UXcy?=
 =?utf-8?B?eDZ2OTNaRlgrUDAyY1o2a2UvYUs1SDVaTVdVTmFNc2JNYzc2NTM4KzhKZlN3?=
 =?utf-8?B?UUtZakJPRmRzTkQyR0k3YzZwUGtqdkEyRE9sUE1NQ3FLdUN0MzRCMVdyUk1M?=
 =?utf-8?B?eVJMUFZOWlZkN2VKUTF0YUhiNm1qNnNhN0RnNC9NMmxUV1Z6QU0vVWlteUxZ?=
 =?utf-8?B?S0tmb2tQblcvRHN5VG9mNENWTFE0M2hqWldBYlBzclZHNlM2elZ3WmlQV1cr?=
 =?utf-8?B?RmFJVTBxNTRRUjZJaUUrQU9kcGx1bjd3VGh6TW0wN0NRVVJZUGs3a1NWaWUz?=
 =?utf-8?B?MkJoTW5FV0prRnU2SEhwMSt3R2dkOHROUHFFVzdQTjE0dmZQYTR6QUgxV2Y0?=
 =?utf-8?B?RmM3Vlo3ME5EN1ZXb3RpdEFENThSMERhaGwxNVc1T0xDR096VXF3ZCswcGhC?=
 =?utf-8?B?VEM2UzV4L0dDNFAxWUVVTmJUb3ZqdW5OUEM0TWVIR1hJbzhiVjBMcmFTejZi?=
 =?utf-8?B?R1JHREZtbjN1eERxaGQwVDdaNmwwa1pzYXd5UWU0Y2tBTWZ3M3U0REFrQlRl?=
 =?utf-8?B?a0NtbmZKQktQaDhOWWFGN3p1UjRnRXdNQnh4NGhHOVR2cm03WVJ1YXJ5WjdW?=
 =?utf-8?B?VmNnTndocFdseDlCN3UxZ0JzcnZQdGs0YTJsOXBDa20yUkxiY2VBMmRpeUZ0?=
 =?utf-8?B?ajNKTTM4REI3ZjE5Q2lHM0NNOGNrZlFYcjQ0bnVtYW41V0JUditkQUk2RGsx?=
 =?utf-8?B?WWQ5WHVqa0JoSmpaUTVncVNuSG1jU1ZGN0Y0alhMYjZkOUVHSWFlVWlsaVFm?=
 =?utf-8?B?bEI1ckV5TDlxQVlsWkJIcTRvZU1Na0VmOFNlNEpiZ0R1ZGFrcWhpUnVHNjBm?=
 =?utf-8?B?Y3czdEtmWnNLZG5JSGJFNEo0WHVzZVlHVXNTa2l6VmtPQjU4Y3h1R2RtcHBU?=
 =?utf-8?B?dnJjUktDUHBwcXorTi9OZEtERjFBODc3TlVESUduaUxqT2VGZ2QxdmU3bzY5?=
 =?utf-8?B?ZDdIcTNmeFVBQy9XcFBGSGVRd2pWN09jSFBQV2hsajJhck9EVTdRemtTeFJH?=
 =?utf-8?B?Vjk1blIrTHU0cDFmNWYvK3krSW1EcjNKZjVHV2QzbjRaWXUyTG9RQmpucldp?=
 =?utf-8?B?ckpacXp5bnQ2a0ZVYkE1YlJZZi91OHNOSEFSNEpVM0h6Snd0TDNZU1o4VVVM?=
 =?utf-8?B?cXMwMnJ5NCtkUnYzeEhXaTJ6UmlWT0R6SjBmcFlIYnJ5amtJV1ZsamU5bTdF?=
 =?utf-8?B?aWNTeFhHRGJoY2JmWGtMZUdIRE1rR0ZlcUpkK0R6U21YZWRCVjk3UFZZQmVv?=
 =?utf-8?B?cndVUS9ZUW1renZPKzVqWW9Sdy81dzlNbGpiWU5QSFhuNzBjNWYrbkFmNUJu?=
 =?utf-8?B?QmtVOW5Tc2Z6NE1VR1cycHVYZVZ6ZFZ6UnJGMVIyUWN1M05PNXpWTk1xdFds?=
 =?utf-8?B?ZndwekV6QmJKRlQ3OWtDZXZoYVlLVnZYQURjdzhrZlhFWG5pS2tHVVZyKy8w?=
 =?utf-8?B?Wms3V1FMQXlnbUtWM3dHVHFBWld1SVlKVE9ldTliem1YZit4OVhmRTcxQWFH?=
 =?utf-8?B?R1JnWkRwWWNiQVNOWTg4bEM0bU9yWi9FYlJNSllFYnVKVnVWT2Z1WG5tdGcy?=
 =?utf-8?B?YVpST054T2Exa0NHTHJ1bngvaU5rL3BMd05YWTBIVXhFdmJCdThESWxKdXdp?=
 =?utf-8?B?WDhsMUx2UlRzMCtjcXpHYkM4bjhHR2NDMmsrK1lSUm83VUZabmtDWmVsNVZj?=
 =?utf-8?B?NXdITzVmOUU4bTFPKzgwY1orSzZJanpjbElMRHNLOERCc3JMZ2JNYjREemwv?=
 =?utf-8?B?Njc4cE5YVmUrWlZNN2d2YWxjLzJ6T3FuUUpISGxzNkhsdEk0S0xERi9PUk9r?=
 =?utf-8?B?NkI4SktwTmRzNjVtaFIxVnNwbTQxMUpyNG5QL0FvYVg3U1lJdkRiNUJ0ZnNq?=
 =?utf-8?B?Q2tWc0xPNENScmY3akxra09EdkNVUlBWN21uU2VLT0RIVnZURUpUVG41blNF?=
 =?utf-8?B?dlZQWFcrNVh2SkxNYVU1MXpLZk8xdDl0emNibXEvS2FxSjZXcmVzcXpEbi9E?=
 =?utf-8?B?Uk0zaW8vN1l1ODVBWXRURUdnY3FYUm5xbVhVdXR6QU9jRUI3c2ZDQTkwNmow?=
 =?utf-8?B?ZHF0clNONW5neS96TlZWOUY4MjNGbCtnajZGck1JeGtaeXlDQUt4QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c94c30-63ff-4f1d-d933-08df41927a16
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:29:08.1492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWj7Ofc4sdt2c1qGO9GXiaOwDEsZi2f0/vDGWoJntdamy0bIPvvuc6ggY7bPhZVxZirsTUl6igYvYVzP6YUQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF8FCE094C0

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 3 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] A data-direct RQ's KSM UMR mkey has child entries from two
>   different PDs and DMA domains.
> - [Medium] mlx5e_alloc_rq() calls mlx5e_rq_alloc_data_direct_mkey() right
>   after mlx5e_create_rq_umr_mkey().
> - [Medium] net/mlx5e: SHAMPO header buffer double-sized in
>   mlx5e_shampo_hd_per_wqe()
> - [Low] Data-direct RQs are forced into MLX5E_MPWRQ_UMR_MODE_UNALIGNED
>   (KSM) by mlx5e_mpwrq_umr_mode().
> - [Low] mlx5e_create_umr_mkey() rejects MLX5E_MPWRQ_UMR_MODE_UNALIGNED
>   when MLX5_CAP_GEN(mdev, fixed_buffer_size) is missing and logs…
> 
> --
> 
> net/mlx5e: Add data direct RX infrastructure
> 
> This commit adds the RX side infrastructure for data direct in mlx5e. It
> adds a new RQ state flag and a crossing mkey over the RQ's UMR mkey. It
> also creates the KSM UMR mkey in the data direct PD and sizes the ICOSQ for
> the KSM UMR mode. Data direct itself is enabled in a later commit.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
>> index 5caf7820a136b..61a77ee77244a 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
>> @@ -62,6 +62,9 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev,
>>  	bool unaligned = xsk ? xsk->unaligned : false;
>>  	bool oversized = false;
>>  
>> +	if (rqo && rqo->data_direct)
>> +		return MLX5E_MPWRQ_UMR_MODE_UNALIGNED;
>> +
> 
> [Severity: Medium]
> mlx5e_open_channel() only enables data direct together with SHAMPO,
> so every data-direct RQ also allocates a SHAMPO header buffer.
> Switching those RQs to UNALIGNED here changes the WQE geometry, but
> the header buffer sizing doesn't seem to follow.
>
This will be improved in v3.

> [...]
> 
> [Severity: Low]
> 
> This puts data-direct RQs under the KSM limits. Is there anything that
> checks the ring size against those limits, the way mlx5e_mpwrq_validate_xsk()
> does for XSK?
> 
> mlx5e_ethtool_get_ringparam() still computes rx_max_pending from the
> MLX5E_MPWRQ_UMR_MODE_ALIGNED geometry. Its comment says only XSK RQs may
> clamp the queue length. mlx5e_mpwqe_get_log_rq_size() makes the same
> assumption:
> 
> 	if (WARN_ON_ONCE(params->log_rq_mtu_frames > log_pkts_per_wqe + max_log_rq_size))
> 		return max_log_rq_size;
> 
> KSM entries are twice the size of MTT entries, and max_num_entries is
> bounded by 1 << log_max_klm_list_size. Take a device with
> log_max_klm_list_size <= 15, an MTU around 9000 and an RX ring of 8192.
> log_pkts_per_wqe would be 3 and max_log_rq_size would be 9, so 3 + 9 < 13.
> 
> Would that trigger the WARN_ON_ONCE() and quietly shrink the RX ring below
> the size ethtool reports? Neither mlx5e_open_channel() nor the later
> set_pflag_data_direct() appears to check for this. The comments in both
> places would also no longer match the code.
> 
log_max_klm_list_size is not <= 15

> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 96b521d8bed35..cee73f3b7a997 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -425,7 +425,7 @@ static u8 mlx5e_mpwrq_access_mode(enum mlx5e_mpwrq_umr_mode umr_mode)
>>  static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
>>  				 u32 npages, u8 page_shift, u32 *umr_mkey,
>>  				 dma_addr_t filler_addr,
>> -				 enum mlx5e_mpwrq_umr_mode umr_mode,
>> +				 enum mlx5e_mpwrq_umr_mode umr_mode, u32 pdn,
>>  				 u32 xsk_chunk_size)
>>  {
> 
> [Severity: Low]
> 
> Data-direct RQs now use UNALIGNED mode, so they hit the existing
> fixed_buffer_size check at the top of this function:
> 
> 	if ((umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED ||
> 	     umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE) &&
> 	    !MLX5_CAP_GEN(mdev, fixed_buffer_size)) {
> 		mlx5_core_warn(mdev, "Unaligned AF_XDP requires fixed_buffer_size capability\n");
> 		return -EINVAL;
> 	}
> 
> On a device without fixed_buffer_size, opening a data-direct channel would
> fail with -EINVAL and a warning about AF_XDP, which the user never set up.
>
Devices that support data-direct also support fixed_buffer_size.

> 
> [ ... ]
> 
>> @@ -546,13 +548,80 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
>>  			      __func__, wq_size, rq->mpwqe.mtts_per_wqe,
>>  			      max_num_entries);
>>  
>> +	pdn = dd ? mdev->data_direct->pdn : mdev->mlx5e_res.hw_objs.pdn;
>>  	err = mlx5e_create_umr_mkey(mdev, num_entries, rq->mpwqe.page_shift,
>>  				    &umr_mkey, rq->wqe_overflow.addr,
>> -				    rq->mpwqe.umr_mode, xsk_chunk_size);
>> +				    rq->mpwqe.umr_mode, pdn,
>> +				    xsk_chunk_size);
> 
> [Severity: Medium]
> 
> With dd set, the parent KSM mkey is now created in
> mdev->data_direct->pdn. However, mlx5e_create_umr_mkey() still fills every
> UNALIGNED entry with the regular NIC mkey and the filler page:
> 
That's how crossed mkeys work for data-direct.

> 
> [ ... ]
> 
>> @@ -975,10 +1050,14 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>>  		if (err)
>>  			goto err_rq_drop_page;
>>  
>> -		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
>> +		err = mlx5e_rq_alloc_data_direct_mkey(rq);
>>  		if (err)
>>  			goto err_rq_mkey;
> 
> [Severity: Medium]
> 
> This creates the crossing mkey right after mlx5e_create_rq_umr_mkey().
> At that point the crossed UMR mkey is still in the free state, because
> mlx5e_create_umr_mkey() sets:
> 
> 	MLX5_SET(mkc, mkc, free, 1);
> 
> The crossed mkey only becomes valid after the first UMR WQE completes on
> the ICOSQ, once the channel is activated.
>
This is the design for all ethernet string RQs. Not an issue.

Thanks,
Dragos

