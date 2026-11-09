Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794217624;
	b=QyCmPP9fHjf6GZs8znF0M4ftztejwJw16niTHq6IxOt5pYUd0FOKtyGEYkNq4fJaTw3d
	 ApFgp50Il79OnuzHOTKZvx6jTsMYfIc2UpxlGPhafnRJatv/73QcsaJEXXHxalMI5YE8y
	 75BJOgBwyU+SDvlsOKBIIvUfzbhsUSFSQ2kOYKC2OXHeRNQJqvLRkeCqpidQFJpi61Wnu
	 JltMSzWejDxS9AnziFwK8RFutS9XWAMhEZIaXSSA9DcMkYiLP5gKtg6v8xvlQYvciDkTj
	 rKJNee2trhlNmLpeUXwUbvs5VWgBaacqnb+gGUf7RHOzMis1pdQZzDoCJBvV46IW5Rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217624;
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
	bh=4MCwH0TkfTLBEMw2tlQow+T3+umK07Yq3lAGGIRY2N0=;
	b=f5m6XSUKw2YA95gTywCkpoO0GNbftfs2+J9mWRNzfKZ3d8yzaDWx7PAoo9XRngGlbl64
	 oXM6GNM1tlRL46roTduSTVfphG1isQvfLFkOK8QZ3na5lqtDLq3KCNbA5Q9dWHDVtwaou
	 bRkVAwiyOyWluQRv0quIvt5m7DqWKSym/1drZGI9gwAcM6vVIIoptRK5mJvaw6xFzQwQR
	 vs+vxCaGyK7XGp+KEQmfE+TPPAmvac3/rMsAwHDMzeUSPd0u79m9EuX3Bg/KFzaEY1Uhx
	 b3Urx011ND1W5ROjsDN4H8sbilVH0vV0tKhSlNyc5M0g2wSePgNdvoS3ySFRloXu97w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WJ6Y8MfJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.21
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011021.outbound.protection.outlook.com [52.101.57.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D66606A321;
	Mon,  9 Nov 2026 09:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97D66606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WJ6Y8MfJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L7T9kbjynP/Cqkkdpxxf8kN1HIDRtp2s4ZR153jaAw/0xZ8b1am2g80+AzqnK4XMRkKJxCV9fpLMcSOPZXJSwWVf8X8JsHokfPptggvyd/CBgLYIekh3qBUMDvV/Uy7lVcjs1gs45VRZclzPhBo4VAkT5SzobphqLi9Cmag8kvv/5FW2KX2Gx3xk7RDLZ2C8xCEh2LSqsnFm/+vvfSudPAJpCs9h6QyBxcB2UFpnNopfw8pvF3JOc+YHaKkaj9nTuzU4/SMD1D40ar0SwI7jCJapvwFXqg9nAxaFyp+yJubhtu1Y908YU7+D991ATDbJIk8VyOQ8PSZPKcKL+UqaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MCwH0TkfTLBEMw2tlQow+T3+umK07Yq3lAGGIRY2N0=;
 b=h67i1GBADGqYepypOHr8oVA7/6/pg+6ITIEw99p3SRukUfcud7NbnTR+PFH8rEfrdzRBdFtPirRpXsCzVNgPjQBRFq5jZNNRbg4VFmrCvb9d3iwxOy7/DkhdTstkPTh+F5+B/HzXl2YgYxpNukhy3omtvI9AQtgTXVoeHRVsgTLc6oIoxWrinQAWaxYtkzNyMdrV9qpASmYzzSpdbrz38pw1pTbqMDYNtppbS7BM9KxNxFd+fbM3DEMYFFSL7n8OVwraxDNOsR/iadi9Imwl4rhXrVJo7imuLEp+MKXuXmjXjXsykyg8I0XvQcpOJYIqwNwNDBfkXKK9B1nfEgT4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MCwH0TkfTLBEMw2tlQow+T3+umK07Yq3lAGGIRY2N0=;
 b=WJ6Y8MfJF+G0pzEjWo7n9l71dxN0kyDBwu96J13FPVVkYkKmvSGYhJmNVtFGRGZSmDOxD1yOn+Xo2Xh2z+CaujbzpWhrlngWjsTM5oVkkQAq8lYFJOLGVOqSqtMEqzX3IDStSYwq6oJY7LFOr/pxfdCmB0IV7Rl+4DELaPEvh61t/m0+kAbPx1OBVOHOBFoTclQDXHd0tArkrxmIRyvPHvFjiOBSXcJB61WNoVoDoaZRjYqtmRx2gKXvIGqWYGhSIVQoqEFWHukajMvYVd/pXtYx/DSwPm6MhWabcVnTYwPD3SeINb7Hxxr7sqn60CaHdQ8ise8CLxQ3Ed8UIbS7BA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by CH3PR12MB7644.namprd12.prod.outlook.com
 (2603:10b6:610:14f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 09:46:58 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 09:46:57 +0000
Message-ID: <0ca08fe5-0aac-46d0-8801-f7a933a75bf2@nvidia.com>
Date: Mon, 9 Nov 2026 11:46:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] net/mlx5e: TC, fix internal port leak when a flow is
 reoffloaded
To: Wentao Liang <vulab@iscas.ac.cn>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261103102855.1340650-1-vulab@iscas.ac.cn>
 <04665957-efb5-4632-878a-6a45fa1553f5@nvidia.com>
 <20261108132100.315011-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261108132100.315011-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0010.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::14) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|CH3PR12MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d2e179-9915-45f3-54b8-08df3e46651f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|10067099003|921020|4143699003|11063799006|261028144727099003|261022105027099003|56012099006|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	fBXIffNqazmIALnTDvwXFDqiakDsCngXSjDqig6baAVQhAG4neanP6uYkF/LcwpMee4tjQdaiiZMrPq9oEx/9ORKS005eXGLTXYFhHmjLuznk58bj3A0k0E2sCypeBLyyw9E1uH2Fjdz8GKjfXgztMZQZFxTJi4Ca5cvcppwu09jqSuPLJVuFx5h9KsAJrZtWKj17XM5qY7PvBy9ktXUUPjR9fwWDhFrbleYoFGdRnFtwQc1/SD+1kRt8mJNVzENpms1heEc8E/fpBRtCimUhQCbC0Fwmp4vOpeLPNlPQdto9HFus33zxLuyLg38/8A6LMPx18P0DeGusWnVfBvW8tJrubn1LP+JlWi7Zt4ulRcT5lPsIwM6u4Ux6AHFr9zZT0uwIRB/1XTf7qqT8RmS6gHvdbEdXWJX/HSc5dAhwUkXbCS50NiFI8cMqvYVo/ZhM3IYp5lcgPPbddCO4kWFaya0lnFtSFjiAVpLNEyHRnJ9LT0s/b1xqXGR/GMSNQu26/qQzP1MLYi2o+NEZMcW7ALsC5dzquOdIJ4j1bjoeCf2AThxcHilBoOKIv01vfh6czd0r7FetlES8gk7CHGwi/FuN4vBOgWS9icOi6ix3pDCste4XD05sMqu0Dv3eyGadmECOsmqs838I9UKRjCSJyDGoyPOAm1kID4EsECwhmiYPgMdy9a8UrYmcL76nij/3DV4duOSxa64RueHHvmPYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(10067099003)(921020)(4143699003)(11063799006)(261028144727099003)(261022105027099003)(56012099006)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?endlTWVaMjJHNmFjZU85cDhxRFVZakRueXhXUnR3VjRTU1dnbm82MjFwUjdU?=
 =?utf-8?B?NVkweHF3VHE1M2NZWmVxbW0rNDZwdmlzeUExSVBXTC9jd045S1FFQ0ZXOHNz?=
 =?utf-8?B?MWdxVEZXV1FrRG1aVWhWZy9UN1c3K2I3VFdvbXYwK2h3K3VlTEtVWlJIakxs?=
 =?utf-8?B?YXlJc1JhR2FLdThUMXRLOURVVncrUDZtL1RRUUNFTnh3TmR6SjM1WkdxVzRX?=
 =?utf-8?B?a1o2UkhDSW1jdjIrSFg5NTU4SldsTDY0L2E4bEYwZGJ5Vjg4R25mTjh4aXlG?=
 =?utf-8?B?cFhFQWs1a09GNWdDVU9vSm5uMm5IZVdnTDRlRFhVQXE2NjNYV0ZNZEF2WjBW?=
 =?utf-8?B?V0Y1MXdHZUJMdnFpRVNLMjdhNmdrQlRYV1VlUVNBbEFNaTQ5VTdMMkVKVm9a?=
 =?utf-8?B?ZERob1cybGg2K2xwNk9IRFptcnZpM0RxM09tRlFzaHRHNzJXN3ZlRSt0UWtY?=
 =?utf-8?B?RU9jd2M4djh6aUphUHFZeUVjakppVHMwaHNZS0R1K1ZtVmRBcWlBaWIzUStC?=
 =?utf-8?B?ZjNMTnFKVTNtQVZjdXJlZzBFdzlqMEhQWkMvOTFPb2hON2s1bjhlbnJjaUVS?=
 =?utf-8?B?eXBQVjU5RnIyckU2Wk91Tm4xdERzbUgzTnFSSUcwcFpKNmJvd081bENCOG9J?=
 =?utf-8?B?dG1ENFZwRGJCK3cwWnhjVDYxZU1Pa1dMWHI2V1l2YUxEcHM3UGxIWEJNZm45?=
 =?utf-8?B?ZWFYNUN2OWdkeHBsU054UTZlNE45UFJsbFF4V2xIdUFacktzYXJTaWllRlJJ?=
 =?utf-8?B?bWI1V1FRdkRqMlZMdDV3dTNlM2pVU2xBY3VWcndsWFpkQlJxV3MzZllmQkRP?=
 =?utf-8?B?Q1EwS096ZHlYZ2cvNVlwK3VTQ1Y2T21nM0FicUxNclRSckh5Rit0ejhIOXFs?=
 =?utf-8?B?SjB0NDArRVJtWGxTRHZ3OFMxKzA4RGZOWVk1RWNHcjMxQ2hJMlVQbTZ5VGJL?=
 =?utf-8?B?bHVZQkd3SmV5VkxoZlU0QlFhemlqajh6ODhxMUpTb0dPdnZNY3o4ZTRvUUdo?=
 =?utf-8?B?ODJtNHNZbDQ1cng1bkdzU0lJT094OTlhQlVRc1hlUEk3Tlc0d3k4aWlHRlFG?=
 =?utf-8?B?ZnJya0lPVGdEby9TQ2tHb21iRU5aK0lMdXh6bHFBTUw1cU92Q3Nsd3BoUG5Y?=
 =?utf-8?B?QkFOVlNEYmpUNmdhVVRoc1g1QnVyZVhxRnJnb1d0enVLL25xNWtlc3o0Q243?=
 =?utf-8?B?YnFFdTJ0eXpMaHgyb2hWaXNwME9ZWlhoZDVVQm02V2hHOENiaENiODBsaVpB?=
 =?utf-8?B?Z21kdTBKVHJqMkpTbVZ0dldrYlRsbWNDQjYyQWRFNWFza0lMLzFrcGt0L3JE?=
 =?utf-8?B?NGlCa0NDMTRFa0svNitrR0NqaXZadml4RVdweUxtMVpDMHdLN1NXRWEzV0Fa?=
 =?utf-8?B?Rlo2NXczWnZNRzdNZXJqeVFVYkdnL05xYjg3NlI4UXBocDdST2tDemVvSXJT?=
 =?utf-8?B?bDI4RHdVN3BRS3loTmR1VDdHZHJsa0x1SHIyYmIwVXdCMU9JQ3pyRnBvNmlS?=
 =?utf-8?B?MjhaSGo5N0lZYVF4cHlER3o2bm90S0F5Zk84N2diZHpabTBHMnVOWDFGL2Jh?=
 =?utf-8?B?S05ZbU9lVUVmM2daQXhaclZwekErQk16M3NqT2JZUUg4SU1HKzhYK2s4Tzhw?=
 =?utf-8?B?dlJwMU9TN3hjVGRPWVd3a3JkRUlqNnR4SXNUMTF3ZlZEVHJaNlFhNU1TUGww?=
 =?utf-8?B?dXNHb0xKMk5oRDU1TUdwUnNGbTBPMldDck9XR2J2bDMvWXFNL1FkdEtLbnRL?=
 =?utf-8?B?Y1dqZGl3aDFzZllkSnVGUVFZdzhuTGR6andqWDFRalVoRVR0SzRpYVluZkxK?=
 =?utf-8?B?ZWVrb0JzWEd1RFd3dTlNdlVvWEpQTHZkSVNZTVYrVXUzWEM0QVdZWTJ0eEhq?=
 =?utf-8?B?NWdLd0xBNFAyc0hJckdib1ZlK2Jua2ZNWUx6T016Smp0bjdIM1lPemp0MDgx?=
 =?utf-8?B?OHJlSXVDOUM2bTFNVHJYY3pIdG81ckEvMEozZHZWSzlyVnU0M09pZCtMQVJR?=
 =?utf-8?B?cDR4b25Hd3BNem5KRnZzL1ZBbE5HeGJDdkVqVWV5VEs2YjgyL2V3ek9WbzNS?=
 =?utf-8?B?TjBsVkVqbm9JTnQ1M1FzODVPTFluME1LbXZaWWdLWnc3cC9UV2JZYTF5YzVE?=
 =?utf-8?B?L0l3T1B0SWZ3bitZNldjKzhWck8zRWpHNHhTcnMyR2UrQVpLZDlBM1NrWkRK?=
 =?utf-8?B?OHdobjc5VXkxQXRiTEl6aW5WSkU2ZUVMbmw0UGgyOEwySGtycWZHSG4xdnBY?=
 =?utf-8?B?NnhTcFgxb09JSEthdE5RT0xOaU1Xa25vSG55UTVBbFBCZDdtL1BCK3JFbVRq?=
 =?utf-8?Q?ZfdZgqD04PEzr5oYzd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d2e179-9915-45f3-54b8-08df3e46651f
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 09:46:57.6870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: taHQPF3hdYo5JzSgW48PRuIaDTB3SldrvvjaoCu9koXSHeobZhaPG4zrjVkkkDv8fur+Qg8+YTkT6jh7xyaY8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7644

Hi,

For some reason, this V2 is threaded in the same mail-thread of V1.

On 08/11/2026 15:21, Wentao Liang wrote:
> For a flow originating from an OVS internal port,
> mlx5e_tc_add_fdb_flow() takes a reference on the internal port and stores
> it in the flow's esw attribute.
> 
> If the flow cannot be offloaded because the encap route is not available
> (-ENETUNREACH) on a multipath LAG setup, __mlx5e_add_fdb_flow() keeps the
> flow on the unready list instead of freeing it. When
> mlx5e_tc_reoffload_flows_work() retries, mlx5e_tc_add_fdb_flow() takes
> another reference and overwrites the stored pointer, so the previous
> reference is never dropped.
> 
Thanks for the report, the leak is real.

It is one case of a wider problem, though. A flow kept for re-offload 
holds on to whatever the failed attempt attached, and the next attempt 
attaches it again. Sashiko pointed at other cases on v1 [1]:

IMO we better fix this by releasing what the failed attempt attached 
before the flow is kept for re-offload. That covers the filter device's 
internal port as well, so the check here won't be needed.

We'll post the fix with your Reported-by. Unless you really want to post 
it yourself.

[1] 
https://lore.kernel.org/netdev/179405518707.994134.3869617957663198262@kernel.org/

