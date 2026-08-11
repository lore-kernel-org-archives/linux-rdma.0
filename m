Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4FF476CCA;
	Tue, 11 Aug 2026 19:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476729; cv=fail; b=o2yuHJhh98Gb3YwvuSbtnVjFLHSPJSZ4sYzvRUA0U/h2imMfAbuhMeoTSX7jT1K21dJBUbb/Ha4MzHrACaplkZ6y0YtqxY35rzTxAGCaM9tS77fgowKb5/6etvgcqFdOIHV9okZ8sJkDa5egQ4GJq7MWPPDPRWQ3OQEVNBsh6eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476729; c=relaxed/simple;
	bh=AFVClpEOdqZAXS2VFsViLXUU3Vu9VhJB0uHv8V0idGo=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=ZT2rUQFZgvhw52Ono8ptECG4ec4H8Xm3Qn/DCFE9aoyM9oqrWw1nlJ5bsoG+Q5psfhuWzjQlq5a0gm0au8C0nGVJTe6VYf0wGgaRuGSI0fTzDAG4z2vF/CV0qhvk1R0QuUzKtcq4EviGnJcOkW7fhd5Mp0uvHi57fFn+HQEr8+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f33N9okl; arc=fail smtp.client-ip=40.107.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f33N9okl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fZzpErBA7hytiS68G2Oqof4t3Gc28PncfNnZGTy10ZAL6DIGYetZWxAQyV3f4cxIUSAJXfdlwXjeLCAhyuJXAG8JiK/lpvBsaftmTUonIqDYjwldCNe6Glxfwb3qJguc9npW2JhkOsod+C5JAcbrQGHqiZ2tn6yqF09eVXnrcUifmNODpDs1bqw3R8NlxBkTN+C+WmHEvov9MKUfWefn0V7Q3OG5AAu+U+wJeeO6ZB05wXgwi/8JC8pWXPCoTNFqgNwImyWS0GWTjEDEhRX36gL8tT4iqO3lbOL5azpMmyWGP0TxbQdTIUGNb/mBol3VpM1rkB7ULT7fnuyI4A4hUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8SPWDZebk9fV4HXHMBq29f7WQ3O4+lTuxcr7ltaj+k=;
 b=KB6dJWiYo1mzKwAMKXvRyDqxfqNolPrwc0d3UviTD4Vj1dQk22vS7KTkhmGIKzdmkOWXs/2M+y2zr68EOUn0vKM97fZQweA1O97ha009frYfnSjE4KieEs0Jle+VOF84x83mR435srPe0MNxPmiZNVJNpg7hxsr0sjNiuiGLz/vlCQE7vTpbq8GeMmFFXM6pdkPVJQCv/OaSLIKRs3mj5fVAndf8x6Z6blIL/U5+J2Ae3Azyi+pA3wkoAxn/zt+NHyKAWhOfVDnrpNoF2ofYOaXs/FL8iuCqE8jE6ySj1JcaEPg9tuGKZICV1IeapNT3iQTouJrvW3/18xgTwv4h6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8SPWDZebk9fV4HXHMBq29f7WQ3O4+lTuxcr7ltaj+k=;
 b=f33N9oklo/QMbqb0QQMyvH8r0xHoCSxXtVaq89EfAKdlvVynCK8m62sUakhcfW0LXdHAfNDhSAkv+pNPnjvHx75HajdyB1RhmP9pw3bXSjTHCNAOuBtykRNcWs8MCHCZzRYQGzRJXUSGTYWju+8VqY+waK8IzXPfyv+zq9SxmVUhcfHbMi3nLkC3ppHfiVfh9HTib9Ds86eWf5CJ9snG908o1TJ15KdDWZYa4nmczmS9D2793W0/7EWEZ1R5EUqHAbFgPO6rPbYIVCsdpJyoTm96WP2iLMgngvPHQwtfyCUpH5lQ7AJNBWgbZ2iWLgMh/zrzJe4liqEWhIcguuLvzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB5669.namprd12.prod.outlook.com (2603:10b6:806:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:56 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:56 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 05/15] mlx5: Rename IFC bits of relaxed
 ordering fields
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
 Nathan Chancellor <nathan@kernel.org>, Raed Salem <raeds@nvidia.com>, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-6-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-6-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669513.282103.5529387341676384360.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH2PR18CA0042.namprd18.prod.outlook.com
 (2603:10b6:610:55::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d36a65f-ce06-4dbf-b1a1-08def7df318f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	awaASNvfF9kb9viVDB24yM6L8WwPZ9Z9BYwe4CKX9ANl8of1jfd6nmVNNSeUDmmbWi2hyOSTS/ZQy+o62/28E6e9umH6Ganr4xHxiaTNAwjN9a1k27brQnrF8VLp1HDcOwSajj4bujYWlPZDovo6h6Ol6/QwX8vA3Vv1Q3k7MAsI9gSzhEPv1pz4KsnHjHcECFqvHkW9aaarUItYu5pc9WehEKJozsvdySJ96vfuYA+qBOr96P13Gkh6hofvSWTM+Wd2DUqC9Rkrur9KLJVeRxB2+0T83/1KisMnkBb9YjImaDpLDjmUc9R3q3/Db8QWbpe4hm0W2Dj/wGplRnCUcpDd49762ucdjv5XPirv08xMaRNvzygLBqL8uXcV9I0wK0njrbkZX+onNoStJGLo9CJwspY2Ic+E/hTELS/nDfYCmobLEGpFSmZ2FmcLqp87wxYiGPWHwPPIMg/glgxdn478VA9I8OTndaKoj1Bj97RplCt6M1aCaST5xCJn03/l9lb05pVgxTm2XOpBC6wnz8u9eMckjx6cxlbhI45VRHk9UaVQ5fZ1Wfx/Dn18q5pd+3co7vMkCk50olTPdBlHJkC1m9gob0rKzaBF1SQBqBaioHfgUr3XJiYTyr89KdVe6m99MznNXfKcCelZwbD5bre/GPPKaZIzbfusiVy3SaY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmEzN1c0WW93UFUya0FPMjN6WWErWjBDVzBOOFFJY0x4Z2toQ1ZERkVTcFYz?=
 =?utf-8?B?ZURCTlRvNE13eDJ0S0VVSkdSU3B6TTk0VDRHSFVPbURHN3Z5RWFLczk5ZWl0?=
 =?utf-8?B?Tk41Y1FDbWwwdlJtK3E1RzBpSnpEcWZraG5NRGpWa3dhUjJCRFN1dHpBSXE0?=
 =?utf-8?B?TkREQm1CVElUSDdlSjU2dWdMS3NOblIvWTRVUGlyc0ZUZEFIYk9GZkh3VVQ0?=
 =?utf-8?B?Y1Rab0FnYk43TVZlNDVQb0RqM1pWMDFubDBXOFZXTWNsdDVBRmhkSE1FczJq?=
 =?utf-8?B?cjJGb0xZak9ZbWtvSHBVZTZYUzlRM003RlNUUHg5R21Fby9hWm80L1ZRY0ZZ?=
 =?utf-8?B?WTFzNkR6Kzh3SzVhbFliV1NvUHY5Q3NlQTRxcWxpM29HNDFQaXg5R1pVVEYr?=
 =?utf-8?B?MzhoM0k0NkU1L3RVQmRjQWNJY0w2cmZrQkRqZktRM3Bla3JJOGhabVhleFV3?=
 =?utf-8?B?b2ZaRFU4YjFHU0JhQmoxRzFHclN6MEY5YmhXUENlUktxRWpzckhpYkhOaXN2?=
 =?utf-8?B?dit0Slg4OGJvS2JoL244aGFqK1k2aDBQcVU3RnZOdVRwdUR5YW53ZTRxbUNv?=
 =?utf-8?B?RldUUW9PclJXb3F0Ync5citBRnpDUUdEbDk5RXIzdnR3Z1lETDBVSG8xQ2lJ?=
 =?utf-8?B?aCt4Q3BMeTZNRXE2dVdSMzFaWjN3RHpIMWJKUzNqakx5WFdsUnVBazlHcTU0?=
 =?utf-8?B?N0ZwYjJUcE9ITUh4d3NuUlc0TXRqamhXVkdiQTN4U2lFWWRhaFRQMVlqVGtY?=
 =?utf-8?B?VlVuckhuSEJNRE84WXVtckVUVk11bzBJR2pMN3VRUTMzeXZpUUZzbW1uOEJF?=
 =?utf-8?B?cTRIRnprVHk3WUl1OEExcGdvTlYyUVI0eU5GckFzNk9NY3NnU0tDbHBsZE9h?=
 =?utf-8?B?dTNVTWpITjcvTFJIUFdUZ0NTb0lwMzdTdkxLaUJ5ZXBxdFVaSGNPZEFZS3hi?=
 =?utf-8?B?OXRNYisxZ1lLSjZUV1ZoRW5GT0ozZHZmSG91OFVENGV3aURUTVFmcDgrNTlT?=
 =?utf-8?B?SUcxdkF3Q0RsUm13aDRYdXZyRTloTzk3TEVjbVZDMkliVnZwZXYwdFhFMnZp?=
 =?utf-8?B?YXB0RlJ3b2F2M3NkUUs4ei9XK0lMYlh1RkV3cHAvdjFyKzRhVUdFQVRyZlNW?=
 =?utf-8?B?amdSUTRRZUVIT3dmNWNvaVM3ZW81UkIveXFWcldMRjhBMXM4djZvc2JHdk5k?=
 =?utf-8?B?M04xczV5dkpvR2ZKb2U3K0FnM09DSTBkanBJQ21JWUhzZURKcjgyclYvbm1o?=
 =?utf-8?B?VGZzUXc2djJuY2hlZURmWW0xVVBvajF4ZnR3UVRkSHFTd3dNYlNRV0UxMHMz?=
 =?utf-8?B?QzN4eHQyZHpacWU2NDJkRWRUWUI4NXRMdEFsN0tUUnBYYnZQR0hrSTFLMEtJ?=
 =?utf-8?B?RU8zNmkydllYSnhQSFJLUTlSbGMxTGVNZk9VRytmOWJ0OVpKUW9YWlVJeGxw?=
 =?utf-8?B?Vng4UWt6RU5kTTNiSndBTUJpRER3OFpwK2c1d0tZMDdFc3Nqa3FWWXJjU2M0?=
 =?utf-8?B?aXpuRTVWUStBaGlCOGpDdldzaXN0MjhhcmhtRldPY2JrU01Oc1ZmYmY4aTRr?=
 =?utf-8?B?RW5DdTRCY2VPZEZrMXFsR3pmRjBwY09lcy9jejhYZnV4dUJ1Y2YvK3gwVGVU?=
 =?utf-8?B?K3l6aDRHSlA2bTRhSkZ4SnQxaEFYbDEydmlNOU1jWHFjbXlyMlB5SHl1UTV6?=
 =?utf-8?B?UmQzNHVLNDgzbnM4Ulp0bjJpYWZuOHRWQjR0YlRtbU9QMzlVbU9MOFBuQktP?=
 =?utf-8?B?aHp1a0VkQ2tZQ3prTG1QVlhwcUxmTmpKQjNwZ3hwT3k2akowbjRJYndKV3Zt?=
 =?utf-8?B?OG8vV0M1SjdUUm5tTHh6ZW9EZ3d3ZzJoK2pJa3BEZXRuM3MzQ3N5UVo1Vmh3?=
 =?utf-8?B?bG1KdTNHbWc4OG03SjdtOGdXS1orZnVySEh5b3U5RkdaOFhnQ1IvSC9QUnZv?=
 =?utf-8?B?WnFKaTA3cDVTRyt2OFRNSnJZRFdSa1ZhdXZSNW5XMXoxR2w3dkYya2FtaHBr?=
 =?utf-8?B?Tmg5dVBmVFpEM2tRVTNSSkg5NlZFUkVPcXlTMExRUnRsSkZ5dDdFUmhQTmVm?=
 =?utf-8?B?bTJBWHpQU1FnUVBKajA4OUJRYnFBem9yRTRaYVVyL2tIVkVSNHF1b0N2eUh3?=
 =?utf-8?B?NG81M00xRHhyOGZYaC9aSFh2MlU1aTdKdGtHN1JRYW8xVDd6dmlJK2c0VlZX?=
 =?utf-8?B?NmhrWWlKeDdjdkRqeDVyNklnR1NPdENQNnFzWm1VYk5JRFhqNXdjMEd2c0pq?=
 =?utf-8?B?MVZZRVRXNUxLdnhhWmxReVBUcUpkQTlKTzVWZlNjREJDRnd3LzhkdUp1cnZt?=
 =?utf-8?B?NktZWFh1b2Jmc2NYT0dsQkVIZXVWdFBvU2pCbzdoQkg1NCtEYTBQUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d36a65f-ce06-4dbf-b1a1-08def7df318f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:51.7451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMa2m7KcAjqySRDs8IYX85WsZB12DP6ql0/Jx9UniGIzN5lg/oBLHtFRu78Tbe+M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669

On Sun, 26 Jul 2026 12:29:19 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> Align the IFC field names with the new naming:
> - relaxed_ordering_write_umr -> order_write_after_write_umr (cap)
> - relaxed_ordering_read_umr -> pci_relaxed_ordered_read_umr (cap)
> - relaxed_ordering_write -> mkc_order_write_after_write_ro (cap)
> - relaxed_ordering_write -> order_write_after_write (mkc)
> - relaxed_ordering_read -> pci_relaxed_ordered_read (cap and mkc)
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
