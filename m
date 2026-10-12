Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF7F4D5989;
	Mon, 12 Oct 2026 19:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832083; cv=fail; b=io65BgJ0VzgjdvWwTPtp0emP+9mlVoAuRARCd/Oe4HOB1lieHzqLwqefpQfWcL+PmZ+puCGSO1wjN6p3SpXtgehsi4S2YmSRqtZfANxjdl490LZbIwRIMeYJheJi7rJN7nrQn2zV+f+rxxL/uTJhoAZ+7M+/iudwTeL6n3RNwOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832083; c=relaxed/simple;
	bh=gRBl+cYCivoGWF8H7uinyjcMCDo/W7BRS3K6rEqpQoU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nOlejqs5hNY8xlqm94ZZagt+n3290o84BMVGvW4Vwh0W0byT0klACvuQnp98gwZYWNZVS7rxZq6XhzY7Xcaqbihy4aid/ORLUZuqzfsz8xyeZn69xz9yRYuc3+zFGXDT10gCYcS1IiL9ab118jTdJjra3q1vxXKuG26bUn0XLEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ga4U+1Hn; arc=fail smtp.client-ip=40.93.195.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ga4U+1Hn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FfQB9GZ7OH6LUOuf17Y6b0GDw05bhbl1CNGQ1rxNgsB+qOM3rSBNDHwfb+dxNMQC0D2XaGK7a/PpCKWNIW7NRPktc0tRRYsFVeHSjQxgfSyHlwp+hAGA3pmC+a1dpNO8RNONTq6hvHcOJ7E0oEJVqMXy/nYiu4+p71qA5bzBbh+9oxTGjznBuliYShQ8xXi/TRAt3CkG7rci9C1wL3978L3g5bt07Nzmz1io83pL2LBsRefHAmM5pJWuZ1Xxa7xC3fjZefCIVdXIs3Ob6WYnhSfR1W5ZdIdajDwxQ8uzWRxlddI+tqyE1GVLsxMniMv5yKrowadO/BWMvkbsef+UaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDWukZBejfQ2ZFdkMHCZT3V+b5ucaEBgGqV7bbEcWm4=;
 b=JC+/XwaPq7ZePXLRy/5qxLVqHsGINXP/RO2oPYW1oJrz1kSL/o30U1ka9VnvJlI2ZNjOVlK8H00r1t84WriiLZu36KCzCu/+tRFoesg24yBH34JD8hI7khzWkjBdHJERNuVb3np/eCpxlLjqwEoILruWzGnLy90SciqejRoAFEEUlZB2jdzRzSMIpYkjdwdMmU8J96blsYnA/PzmqLmaAMW4sI2+rX+mV5XPqvNv7y37nU5LIeU0j2gUkLosI3xloPOQOLAgxKW0WX/e1Sh4SThn137J+B7Hw6jSDsJypOgoTaWsue8ZWPRS+6kNlbEbHB6Dd7MkY8bl3Em7ajwZlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDWukZBejfQ2ZFdkMHCZT3V+b5ucaEBgGqV7bbEcWm4=;
 b=ga4U+1HnqMqdRkCIRYDvykYslVcRzZBrY7eGjEYSb7dlwht9zpvg06qq3+dnZ9YcBRBZ6aMDLlKK3UZte9VwWvncenXUOmszXs5F0bb1aMGXEvbeBzxDYYp1iVLk4y+5G33eS8BR+xUDwtGY7STlys6chorQnmn/H1Qh5IanoH9V6cGdntT9+p/cEVmOeC65ozaJ3nlZ/rNW3tuBreczX/SI/78uaqcuajnHhsl+NTUvyK1RisRdSGcbU6JH5jk72FgSuN51oB9NIawEepsNBjG3n/oehPxOYY+mH7rlutEK9wZo+ng1y5FUbrUx9MTLDe88ieJplwXFx79iGpYG/Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by PH7PR12MB6907.namprd12.prod.outlook.com (2603:10b6:510:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Mon, 12 Oct
 2026 19:07:58 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Mon, 12 Oct 2026
 19:07:58 +0000
Message-ID: <b7cf63b3-5994-4eea-a53e-5cedacf056ba@nvidia.com>
Date: Mon, 12 Oct 2026 22:07:50 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] net/mlx5e: use skb_share_check() in the
 loopback selftest hook
To: Nicolai Buchwitz <nb@tipi-net.de>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Oleksij Rempel <o.rempel@pengutronix.de>,
 Maxime Chevallier <maxime.chevallier@bootlin.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <Jose.Abreu@synopsys.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Dragos Tatulea <dtatulea@nvidia.com>, Alexei Lazar <alazar@nvidia.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0002.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::8)
 To SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|PH7PR12MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f8ccbbe-2926-48a0-a5c5-08df28942055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|921020|56012099006|11063799006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6zS7iiTs1R0GqPZEmkq6s9tWU+8lY8j1JiyXAspmvPOrQwrsUD9jyIpRo93xg8e9Z/2/otpMtroFhG4H81s/zgHYQJcderGGHhqRoDYJmhkzHQbXn4e2uNE7LRLfvDJvP8o8IyEWieX6YyMNwFGwCU3rSJ/wtQT/YhxMMDQmBQNIhuv2tM8nMddRqt6C54hRoogZa2q6mB/Mk4+NdIH8E7WEJt2r99DmzaU7CY76r99KqtC/MfjGQKDn0abkaE6fReCfJ0xX2P4/TwFBGYdtT3qhdqXstOnZafQjTBmW+F4VkwM3v6+K1CWa3Bi/RV60xJU6l2hi44vcYmbFxc8Y7pxRUeFVzBjDlNk3FpNZJxtd3bF/ku9A7cRvCEbQDANjfU5BY3cnUZ5xbLd7TUJ21OJ/O+WQKANmP3fqdgTd7cWTOFUiZWpAaTi2CA6k9LFlZnwiQZH9UIAY3agTue0Vpfdsrj/HpOEoKPrGsXOVFYKhpep60td+6UYNU445ha22/eiBVdKfGY+uSA8JUruIEAYSAyZ+wQzJWXc8OtJWJJtnA0T7EGV7VXGjWL5Y+Aa5mbHrcrOTCWJrycQHQ/WfDsS1Q8kaRG8Uyu99bVKByAzYogZ46FREctwEbGsmktkuTVCCSebDMw4CcnHSNI6gWcXEBxzbUOJlEbCg7Q96C/UHtio+TYT4JDrD6IziiAuZscTcMF6kBiIAi3eZzf+tUQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(921020)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2szVGVQSTEvWFZzYVV5ZWdxVFRIWW5GRlFyemlPM0pSaGpjTjZ0VUYySy8z?=
 =?utf-8?B?a3NQUkliaVRjUUxKQ0tIWkNDdStpVzUrOXJ3ajVQSis4dm5Bc0hzOEMzTDdW?=
 =?utf-8?B?dG1waitubDRxUzRLZkhUR2tWRTljY2NqL1hGNFBaaGtMcTRuOGxVY1lYT2Jl?=
 =?utf-8?B?VStYVHZiMzZrWnNlWjA2ZjlvUE1LazlvOURDWk93ZlNyM0hJWk8wRzVuRHdZ?=
 =?utf-8?B?RlFNVEpHZXZFVm10RitxYjZZbWZsUkFaR2Q0bml5Z1VGWXlVMkdSNm0xbENk?=
 =?utf-8?B?NnFxWVN3RWZDakl2Y0pzVndqMFZmOGJJNzhzUGhFN2xjNWpxU0R2RVhxOVEv?=
 =?utf-8?B?bWI3OHpYL1REQ3doVzE4VlRJdGxRWVZTVmxhUkFLY1VSOXFZWlZoeFR4Ni84?=
 =?utf-8?B?OWlIeXgrczVwSXNac0F6cXNaYmE5YzFpSjhka2xnMlNxSCsxWkVKOVlKU2Uy?=
 =?utf-8?B?VVdZSjFZaSt5VDJxaStRQmorZVNnSTBpcURzbkFGdVlBc3NWZkIzTVF3VWF2?=
 =?utf-8?B?a1lVbnlmaDJobVhXUW9XaHBiNTl6Q01zV2NuVC8zRFZNMmZLNDlRQjVoNHV6?=
 =?utf-8?B?bHNUUUFmVXpYYTdob2FQeUVDbXFvSGdyTVBEZnFERjdiay9BWVNLL29GcVlp?=
 =?utf-8?B?SFMxMmxQRGJXeXN2VzdoTVRuN2JscjZVaml6U3hHc1FYajV6Ui80UllHanBt?=
 =?utf-8?B?WG05WkZFaWliV0QrR0NJOHNNVFFLSHhjU2llYXB1VTc4Uit1VU5MVlM3THlC?=
 =?utf-8?B?RTZRWFRtT2FWMWNRdWY4OTRhN3VwR0oza1RZRUxDbVdid3BObk9tbjZFdzUv?=
 =?utf-8?B?K3oyOTk4T0J6S2RBMFA1L1FGMmtDc09oRzBMeXc0NlFQUHNKUDdveWFsdEx4?=
 =?utf-8?B?TnZMWWN0b2pQMzhrK3RDQjRJYVBHMzNURjZSb09vTFl3YzJpZkE0RThXRjBF?=
 =?utf-8?B?VHlxcnlzRkRXaTNjTWVBYnhOZnUvMTNBV090NTE0UjV0YUFvalhqNWxVNlUr?=
 =?utf-8?B?UVdSaWZXNUQydmZPZ244NDFxWTlMaUVjVjNHMjBDYlF6TXRDOGV0cU1wcGxN?=
 =?utf-8?B?VEFhdTRxZEpWd1EySGlCNjY2MWdxQ1pXbTFGZXducHBuSmVoZkJ5THo5eGEv?=
 =?utf-8?B?OGN3dzlEaXE5anFTNUgyaG5MVHo4ZnRaRkU3Si80SkM3UlBqRHU5WEd6Z2Rt?=
 =?utf-8?B?aUwyVlFkaFZYSVVrQnhXVklKS3kzR2JVeWlxWkRXTW5kUUduRkI5WWMvUWNC?=
 =?utf-8?B?TE1UbWxWc09wMEF1dkxpaUFKWVg4eGR2dDhZYU1BZHVoeVFIWWVwK0ZlWDc4?=
 =?utf-8?B?VFBJKy9UaC9UQkJWb2gxbllyNDZqYVZCY1RINWxiamJHalFyWFBZWGxIakpR?=
 =?utf-8?B?S2tqL2EwclBHS2V4NEU0SVNlSzk5RmV6R2VqT3ZOZGZsaXBTZ1ZhQlY3Vmk5?=
 =?utf-8?B?eWREUndqRkFSdUtVZm53bEpvK0JNLzJNalFKazZ2RHJ2OVJSYS9nd0xxT0pX?=
 =?utf-8?B?VHplOTNOSjR0NzNuZHdrbGZmUlorOWZvQm1ROWJ1Z0tCOElHblBiMEFIellX?=
 =?utf-8?B?L1ViWGVoK20raVIwQ3p0YU40VWg2SEJUcEhVRVdUZWFZVjZYem41dmFoSkZR?=
 =?utf-8?B?QW8vWGZOR01zMk5STm80K1lRZ1MvcXlxU3kvQUkrcUVvSGpJeDNwRjBWWmxn?=
 =?utf-8?B?dkc3RnM0RzBESEVQMTRMQ2s1cGdoM0d3T1hNR2tlZ3JHdGR4WWJaRGlaMHgx?=
 =?utf-8?B?eCtBMmlyelNkS0xZdjdESU85NTFMaHg4YUcvOC9KdnRBdDJzeUhIZkkrcnZa?=
 =?utf-8?B?SkdhUENpMmpsb05ZVGx1Ym5Kd1dwNDQ3NDR5b2xTNjBrcTVaNzVOcThSaDZs?=
 =?utf-8?B?NldNbjFuM1QyMmEzYzFhM1FXaDZmenoxL3JNcEJWdytpK3R4SDg4eEo4clBp?=
 =?utf-8?B?bVNjYmR6azNSekg2NTdIU2ZpZzZYUUxabDlocHZEOHFrTThoazZoY0pHcVFw?=
 =?utf-8?B?YlVDbXNHODFHTHZST3RWU3FGWEFxRWVXQ2ZuL3NSTytBRHc0L0JaeU0vcldX?=
 =?utf-8?B?ZUZMUU1wdU5xeVVCZHJ4T3BrSzg1cVUrNS85WG5MNmh5amNXNVhIbWFpUVJT?=
 =?utf-8?B?K0ZRRFRWUzhRMDd6b2JiNzNYZjhZSXpnRzlvWDFlUEttNG1PbmdabUFENGVM?=
 =?utf-8?B?bk9NOXc2WDB6d21hdlpHWFM5UkFsT09VejZjOC9WOW90UDIreUc4U3JvQTJY?=
 =?utf-8?B?bllxV1VEM2M5ZDdPb000QlFSY2Q5NCtqLzRNT2ErUklTSGRPYmtFUG9mK2RE?=
 =?utf-8?B?OWtaOW42M0V5d3RrT2Y4SjFzSGlsbElPK1B4NjJrUlJKd3QvQmtyUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8ccbbe-2926-48a0-a5c5-08df28942055
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 19:07:57.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0fWFqzzAcPJ/TnHSIjKpjM3EMlUUAq5gXsmkEsJjvw7pIOpshQpBSvV1EwwQnRcFMhJ7Pxnh6kWqSyMh+2amQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6907



On 07/10/2026 21:29, Nicolai Buchwitz wrote:
> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_linearize() on a non-linear frame then hits
> BUG_ON(skb_shared()).
> 
> Call skb_share_check() before linearizing the skb.
> 
> Fixes: 95b9606b15bb ("net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
> index 1dcdb86690bb..8eb9a9469549 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
> @@ -166,6 +166,10 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
>   	struct udphdr *udph;
>   	struct iphdr *iph;
>   
> +	skb = skb_share_check(skb, GFP_ATOMIC);
> +	if (!skb)
> +		goto out;
> +
>   	if (skb_linearize(skb))
>   		goto out;
>   
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

