Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795461604;
	b=O/0y8/hCA08Kc50AMgvFaU75kyEz023v2+osFyHFy4M7jJvnJ6D7/yFuOaL1f6gkWz7Q
	 iX0hJeU3w2GUZPn0wlmx8l0YTdEomREXKvzQ4r5cJ7w5tgDzzPRA0Hp759u3de57w8NK3
	 2uXeSlb9YQpFvGRJLyGsdlu4VCYe4rl9e7xZzq9wNmF+g5bs3x2LSVEsUjwjSm1oIiR8k
	 IeMl8CsyQGW4OtWJqrWK5C8Nez9Xs02LUonfVtKPkcBnV9F/v4Sd/NfaJBqQbGoX0CJnc
	 1Zqi7t/tFYKauwbgBh563AHkPSppv5hPI2/pndNZ9bR77wu3oGockwZlhhb3DfarL9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461604;
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
	bh=d65RCQauGj1rpBY8ix7dx3Y30Z+mpXmukoB331c1oXg=;
	b=j1yw9vE0pxRj+ua9wPsHU0qOQxESY+3vISVDtBzsuV7l7lmsW+fgf+g7vTJBQLdIhvE+
	 1CntnpZtyw1t5NbtF28VIjEY8ceGHDfW9fiiAOBHt4dyl+qnE0WuCY4t89z+v1PE0fbln
	 OudZ1P9udbqt2gQLsSssadQgjx0TZa9Y8dqVg5D/k2GoPk4QXgOYrfYZBQaZoKBlgcOr/
	 CRb9r+O6DR/92j6kIsT5kCIfSghmjkr9cbp0AS1mSzYlzKbgV7ufls2UzPDnyu64i6QSI
	 ouCuslGuRQq8S9kH4917ZJsyzB5Xqsp4ySHhkNOi8bY9yJSvdiELKO+hAHuh6ddEFsg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="Smv6Px/N";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.61
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013061.outbound.protection.outlook.com [40.107.201.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEF2606A327;
	Mon, 23 Nov 2026 19:20:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CEF2606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Smv6Px/N
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b0mH4cmBwZzXwIubiHDM3514xRG70Nzyb1wmyE25LyjvYUFznrfh7e3n+VxXekzka4A4N26IDRNYyW2bmLgISbM+BrbJglgq6jd/ZyWlWwt9o/S84RvmdqZkPGIjX0RVuJ0p1esrhLVeKC8kvWaWpbd4OIGhagWN5QXE9AsYp4bjoXxcdtWa3q0mykrR6mbMox9v9Q8nuLebDUL46J0zHee2pNa0rhvT9NnHaDRwQ91Kq/DiIdLuGFcpPOnMMheC6L9gt50oq9+o2i3l7zQ4M00QP7Vi3JxssJCbMQwCD4d1KUk8El2oRvfBYLfm9Z0oYZa7L4YcNp/Ko6G1WFo/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d65RCQauGj1rpBY8ix7dx3Y30Z+mpXmukoB331c1oXg=;
 b=B3fP247jBsFlfOvIU7V/8X0fOowmsNLlDgmT2xcgXdVUu/8k2kqf1fBh+fldTcUvJHTqn9vTKHoOxWR4/S5Ftrb8aX0fwUUQ/EmX3X/b3YPunDbXPIO37n0OdLWNW47gGgEgWS27OYxZRFOtdado59uFa50M8TxK0cTWInYg++4t6pqAm6At5uw4Z5ANWiP83JZwOPgOozK4K7mtiDMrjY+urxBJ5OPUk648MRriJpRbQuEjIOhz8NgG+BzMUIkW8UYhswdwFJoWyLAOLd7IUzKr/x1CBY7fwLbqEWkw4BTdL/LlSS+MFLZgmNDIUphVsYIHhWC+uSFCqrVjLemsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d65RCQauGj1rpBY8ix7dx3Y30Z+mpXmukoB331c1oXg=;
 b=Smv6Px/NjLcyygP/LepuqnlmPG0Nb9045xKGzY/LSZxYhkBKYjRKmuOgLOSKl3CH2iqTzVkyDRtVM8DKXffW9YkqVSKsW+jFTKHywVofy6di2khmIoTj+gARH56gxT8Z81smRhSxiT91Uess4GC2khurQwGLRIOnm2XoIEuT/edddaiIKYGsZ9btIt7QfEJV+cKIOaC4Rz954Unx57QcWryXwYKq80ulZEGPsh/73qIC0/RUrKKSUTXQ0e8qsVEewgcXhBagUXvSrfmoojYBPHxp/0FpcXvCHZTg7gnaOkzV+irwVSm9YG5kR+P3y+IhblRKwKzMk5/nyG8z18HWpQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by PH5PR12MB394451.namprd12.prod.outlook.com
 (2603:10b6:510:502::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 19:20:00 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0639.010; Mon, 23 Nov 2026
 19:20:00 +0000
Message-ID: <3f89c58c-ad70-4d20-86a3-4ba3ac8a2689@nvidia.com>
Date: Mon, 23 Nov 2026 20:19:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5e: TX, Do not open a multi-packet WQE
 for a single packet
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>, netdev@vger.kernel.org,
 tariqt@nvidia.com
Cc: saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261123090200.1284018-1-xuanqiang.luo@linux.dev>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261123090200.1284018-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0239.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::16) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|PH5PR12MB394451:EE_
X-MS-Office365-Filtering-Correlation-Id: f65ee965-bcd9-41e5-52ff-08df4996c460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|18002099003|22082099003|3023799007|5023799004|11063799006|56012099006|261022075727099003|261026140227099003|261026121527099003|261021135927099003|261028144727099003|261021123027099003|261009223027099003|10067099003|261102123227099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	dRm/CnABnVfpZyGLuWkIc8z8voZvgUwoC9gDeT5SkO2fY1dMl/Jyl9gn/Igxb0UMfCvcIdpfdFyYuQmpjWNVTJTL1BTOF/N7fOhuEKyHQsohsYFe4zokInDO/0md0mdqqZrUAZuYp+1oXUwKgGoygLx4ai+aFfy4gcOjhpxTpU9bXK3gTWkCNZm8hEUyFAsne8/uv2KPnLDPJOQO+EY6fNC3rHNzNaiH981uj0ZLmDmI7lnwS93IFkosfuMJH2Jf66ePGo+MQL9T91NQ54whc9Wds8lY/0q9j1j8mu1p5xC8OFUj4oAwUCnAqK0vlVGabSseln7RAjJ5zOPPSbJICzJv1V9kM5BFGyVbsjede3GsW8Zljz2MyLDlgJh84YM8OfYFF8FvhhHXQ7xv2ppTxbyEs182Y1C7OFJh6ygWi3gyCsDufVAJz9JpEmVrDDGYXbADeL1qYxqNgPYmnvSq5B2Fio8zvqe+1fMI9s9beAZd7duGoPXcmItn9yZjbZoB6/6W8emHdVWbH7SrGthTrekYgF4jGhu5sp6WzSI1mihGwoBXL+9i0Ei/F/XM6IWiL2VP8Shen5dWIzC1MBP1Vk4aspIcSzm2Q5n60OroVoXBMRL44E/C2eZ36fPq9b2VU4Ottim/SGEGpVvmhmgm7KBvhlage1Fvf2NkodwH3R8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(18002099003)(22082099003)(3023799007)(5023799004)(11063799006)(56012099006)(261022075727099003)(261026140227099003)(261026121527099003)(261021135927099003)(261028144727099003)(261021123027099003)(261009223027099003)(10067099003)(261102123227099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkVBS2dJUW1sa2N3RjNSKzk2L2V4eDRSd3NhQ2FCc3NmT2pKVFp0ekpUY3hT?=
 =?utf-8?B?T2czOE4zcDVadEZNSGJtcWFQQitHUXVnZ05CSjJtem1RMVRnNjVubUxoR3Js?=
 =?utf-8?B?akkrOEY3dkFvdFlweUZHT2tVVGR3YzBGVnRRNjRpSjdsQVNFNWZuSTNZWEJv?=
 =?utf-8?B?NnJtY1VRVTNodnVLSVNzSnhjQ1JqTTg2UzJDYjN0OVIwckl2NndXaStlVllk?=
 =?utf-8?B?NW1wUytZSmFLWGR1cWVLSVkwUFVJOWdjWVp4YjZnUVNCT0ExenNyY2hGdUIx?=
 =?utf-8?B?eEoxSldXVk1Bc2FhZkxhakNMdmYydG9iemlVb2NLYS9Vd1NVQkFhWEtWOG1G?=
 =?utf-8?B?bzFWNnRON1RrSm5JZlMrM1RHblpwL2hkbGFRWEZNbXlYQXdFcUxMa0phTk9L?=
 =?utf-8?B?SVAvVGMvZWlaRUVvMC9Oa0ZXQ1BqVDZHUWZqUmdPdU9iY0xqc3F4Q3ozNEFO?=
 =?utf-8?B?ZFN1SkRaRXJSbGxmTlBYenJOa1A1MzBmUDA2U1BwYVA1RHdIWEdoYUZSMkFn?=
 =?utf-8?B?NHJzdmttOFhvY3FKa1A3VjQ4WnN6bkhPYmFQVUpKVmJmSEJ3bUhxSVRZRkFi?=
 =?utf-8?B?UVZKSGZlQUpiVEJBU3BMYzE2UjUxRjRFcXFrZTlxUVRWZmlhaU1pMG1nVTIx?=
 =?utf-8?B?TVZlNllLV3I4SUdUODR1bkp1UWpMZzBTY1VTQTNlZHJ4dTl1L0tzVDladFFS?=
 =?utf-8?B?ZXJOUm5abm4vRmxJRlI5WnI0ZmtiWlhJMERNS0cvM1lIVWpIUmV1NlB0LzJ0?=
 =?utf-8?B?ajlicGhyWnRYUlZ4ZkhSSFVOZTlqNmsrdjNpL1RkczNLNi8rWkRJcnM4TEE1?=
 =?utf-8?B?N2t4MFJOQUs1Vm13bWlucnZTRGw2L1pPbWdWS0JVbitpK3JnVGpUaVJCcFk3?=
 =?utf-8?B?NitMblBMUzBMaEg0TmFQUHJ5OEp0Ryt6V1VORXgyS3dQazdWd2thdlF3S2Nr?=
 =?utf-8?B?Y3IwbjRRUU5zQkliUksvcU5tOHN5U0hETTVWS2xYb3F5NlJrTC9tRFRYZGgy?=
 =?utf-8?B?MGs2blJuNDViZ0FpYUVpM3c2TDcyVVlwb3c5ZzFQQ1ZvL1p1bFdoOWZWODdT?=
 =?utf-8?B?TEhrTVNVdG1XdkJNRnhkWXZPckd6cnF5QUtiUXVVQXY4K09iMXpGMDRaVEd4?=
 =?utf-8?B?Qjd1S2RBa3dIMkpDZ2RsSW1SWUk4N0w1VWREQXVhVkZHV2FNaVJDN1Nqck52?=
 =?utf-8?B?VjVVOUFORk9Dd1BTWm1HQWhuN0VHaW9YQ0ZBMXhXY2dCOTl6WU15aEpYVnFO?=
 =?utf-8?B?YlhDT3hhQ29FUXZycVUyM0ZkZGlGNWZHQVZRNmQ1OXRkaE5DOXFGRUt6R3Z4?=
 =?utf-8?B?bGFUMEgvS1BsSEh4OEZ6MmNWN3BMZ3dVZGFGa1JXdzlXUTE3cUs3dk5nc3hB?=
 =?utf-8?B?VVJpc0tqUFJRaVBqRWlWbFRBbTRNT21kMzE3b29UQkxGTzJ3bVdUUVJvVUtC?=
 =?utf-8?B?S0RnZ21KOTh5QW9Dc1pJdUVyYVVLVEhuSTc0eWZnajMwRDAzM3NGeWhUSGN0?=
 =?utf-8?B?VGtuOUd5eUJOT3VDejJkcEtPblZYL20ydWtpY0dGMmVvWUtUaUxGbFJzL1F3?=
 =?utf-8?B?NUI0MGxLREE5Mi82MmdySVQ2c3pZRS96SERUUnM1bmQzRC95bitFUCtjczJ0?=
 =?utf-8?B?MjFrandPQ2wwT1RKdE1tbHBjTXBYM212WmZDVXJycERwQS9NTjJObTNpWXBj?=
 =?utf-8?B?YVcyRXJkN3MwWHV0dCtyeE1tUUY5MktaeE1Vclo1N1RZcUdqVHd3Mnlnekc3?=
 =?utf-8?B?eHBFUk5uSHROOE5EYWhYUVhXZGtRTDRjNVg0TEtaUm96WkdEMEdxc01weGh4?=
 =?utf-8?B?VXdYSk90UVNOd2t0bVg5cW9qcjhZTk9mdUE0TUozT2ZWUTlMYWsxMFRoQkdN?=
 =?utf-8?B?ZG1HYmxWY1N3MUZ1bzlsbHpkYUNqNDlxTzF4aVhqb2ovRmJmaXA4VmhZNk5D?=
 =?utf-8?B?UENRTmxwK3pHZHNrdUpJWGZPMEJFbTNNWVU3YnRYbHgzMDVRckFxUE95QWZy?=
 =?utf-8?B?WlNuZlRUcUkzc2ZpTnpkYUZwUVRkZGpwckh4NS9yNWExN3NqczJhc1VNVEZz?=
 =?utf-8?B?SkRTZ3I2MmJyemZtcHJKcVhENXE4ZlJDOEZMazRpZ3J4UFhuT0VVcldRSWIw?=
 =?utf-8?B?NU5xOG9Dc3l4Y1UzNXBSUXlqclU4MDlydnBtWlV4UlBsa0IwUjYvSDdYS0ZW?=
 =?utf-8?B?NW0yaC9QMFdGK2xDNm8ybVA5UEZtWUZtNTk1dmJKSjlwY2Z5TE9qaDVTK3Yy?=
 =?utf-8?B?MXlqWUlmdFNQRW1vNHRSVmlJWXZiZ2lxcWxNcFd6R2JGaFNualpWT0FSeVZH?=
 =?utf-8?B?ZkVtZWxVR1BJbGI3cEFIbFlQVVZuVmVVaUljYXpjWE5tU2tmb2Vrdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65ee965-bcd9-41e5-52ff-08df4996c460
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 19:19:59.9775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rU8lxw/I/UuyDafZz3cquKB0SgkERxSyBbJXVRT0XONP4NQYmMUvOZre2JTEwPnmwzZtUQprJ54hKgTlJaPCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR12MB394451

On 23.11.26 10:02, Xuanqiang Luo wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> A multi-packet WQE (MPWQE, added by commit 5af75c747e2a ("net/mlx5e:
> Enhanced TX MPWQE for SKBs")) lets several packets share one WQE, so the
> control and Ethernet segments are fetched by the device once per batch
> instead of once per packet. This saves PCIe bandwidth and CPU cycles, but
> only if the WQE carries more than one packet.
> 
> With skb_tx_mpwqe enabled, which is the default, mlx5e_xmit() sends every
> skb accepted by mlx5e_tx_skb_supports_mpwqe() through an MPWQE session.
> A session stays open between two calls only while the stack sets
> xmit_more. A packet without xmit_more closes the session and rings the
> doorbell. Hence a packet that comes without xmit_more while no session is
> open opens a session just for itself and closes it right away. Such a WQE
> takes one WQEBB, as a regular WQE does for the same packet, and the
> doorbell is rung for each packet either way, so nothing is saved.
> 
> This is the case for the IP fragments of a large UDP datagram and for
> UDP request/response traffic, which reach the driver one packet at a
> time. With pktgen and burst 1 every MPWQE carries one packet (mpwqe_blks
> equals mpwqe_pkts, xmit_more is 0) and the packet rate is 15% lower than
> with skb_tx_mpwqe turned off.
> 
> Use the regular WQE path for a packet that has no xmit_more and no open
> session. Packets with xmit_more still open and extend a session, and the
> last packet of a batch still closes it, so batching is unchanged.
> 
> The only visible change besides the performance is in the statistics:
> tx*_mpwqe_blks and tx*_mpwqe_pkts no longer count a packet sent alone.
> Such a packet is counted in tx*_packets, as any packet sent with a
> regular WQE.
> 
I don't think that this paragraph is needed. Not worth a respin.

> netperf and pktgen between two 10G ConnectX-5 hosts, 2-socket Hygon
> C86-4G 7490 sender on net-next, the patch switched at run time by a
> temporary module parameter (not part of this patch) so that before and
> after run in the same boot, mean of 3 boots x 2 rounds. "far" is a sender
> on the other socket than the NIC, "near" one on the NIC NUMA node:
> 
>   test                                 before    after   change
>   UDP_STREAM 65507, far, Mbps            3255     3815   +17.2%
>   UDP_STREAM 65507, near, Mbps           5619     5870    +4.5%
>   UDP_RR 1 B, far, trans/s              57667    60688    +5.2%
>   UDP_RR 1 B, near, trans/s             70538    71230    +1.0%
>   TCP_RR 1 B, far, trans/s              56822    57124    +0.5%
>   TCP_RR 1 B, near, trans/s             70048    70011    -0.1%
>   pktgen 64 B burst 1, kpps              1487     1748   +17.5%
>   pktgen 64 B burst 16, kpps             3192     3194    +0.1%
> 
I didn't have a setup with 2 NUMAs at hand. But on a CX7 system with
Intel Xeon Platinum 8380 I measured the near results:

    test                                 before    after   change
    UDP_STREAM 65507, Mbps                19755    20455    +3.5%
    UDP_STREAM 64, Mbps                     496      496    +0.1%
    UDP_RR 1 B, trans/s                   56317    56386    +0.1%
    TCP_RR 1 B, trans/s                   54084    54229    +0.3%
    pktgen 64 B burst 1, kpps              3014     3112    +3.3%
    pktgen 64 B burst 16, kpps            12530    12420    -0.9%

And the 16 packet burst is also a bit noisy so the degradation
is less.

> Batches do not regress: with burst 16, which uses xmit_more, the rate is
> unchanged. TCP_RR does not change beyond the noise, its skbs carry the
> data in page fragments and cannot use MPWQE.
> 
> The price is that the regular path runs a little more code for a packet
> than a single packet MPWQE does (mlx5e_sq_calc_wqe_attr(),
> mlx5e_accel_tx_finish()): the instructions per byte of UDP_STREAM 65507
> go up by 0.3-0.4%, which the gains above outweigh.
> 
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> ---
> Changes:
> v2:
>   - Check xmit_more and the open session first, so that a lone packet
>     skips the skb checks. (Suggested by Tariq.)
>   - Run the tests again with the new code and add netperf results to the
>     commit message. (Suggested by Tariq.)
>   - Rebase onto the latest net-next/main.
> 
> v1: https://lore.kernel.org/all/20261117085036.3138779-1-xuanqiang.luo@linux.dev/
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 14479da98f42..5b5651c14750 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -646,6 +646,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct mlx5e_priv *priv = netdev_priv(dev);
>  	struct mlx5e_accel_tx_state accel = {};
> +	bool xmit_more = netdev_xmit_more();
>  	struct mlx5e_tx_wqe_attr wqe_attr;
>  	struct mlx5e_tx_attr attr;
>  	struct mlx5e_tx_wqe *wqe;
> @@ -678,11 +679,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>  	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
>  
>  	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
> -		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
> +		/* An MPWQE for a lone packet saves nothing, use a regular WQE. */
> +		if ((xmit_more || mlx5e_tx_mpwqe_session_is_active(sq)) &&
> +		    mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
>  			struct mlx5_wqe_eth_seg eseg = {};
>  
>  			mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg, attr.ihs);
> -			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
> +			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, xmit_more);
>  			return NETDEV_TX_OK;
>  		}
>  
> @@ -697,7 +700,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>  	mlx5e_accel_tx_finish(sq, wqe, &accel,
>  			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
>  	mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs);
> -	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
> +	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
>  
>  	return NETDEV_TX_OK;
>  }

The change makes sense to me:
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks for your patch!
Dragos
