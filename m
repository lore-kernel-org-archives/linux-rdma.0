Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794995736;
	b=1vhJLy+7j5PIwEmNxo2oqrRlrcikKJRJmKRiAwzizkK/7bQFIZIiKIg1b0BFHkQ8+OmW
	 zwGywRxB2dcgdPxwbuYhyqU/7AiJKkMfTzImTvdqNE2Ln98fb+MwMCFtDaQO1NWAIeSk2
	 Xaj98Ui7Y+z2ggT1w6DQugXk5i1WVKefhmzRNnXfOQa81PrYu1IuWENaXoD3sxLP91Hup
	 iJtMpxwocY5mpFz+qVPAVTH4gCGNENaVXyXjzj6hWHr/FIpCsygEvDmGlsoSTuWUK7Lx/
	 OiMJQg3npCbZSIdHGZEIaEyc6FhvfUgBwC8y4j1zkZPmNpaPKjGt1BKKWg7mU55+52g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794995736;
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
	bh=xIL67qi/5J1n53vFaJ/cOLtnAmRukFSlBIC+JrXNAi0=;
	b=k3D/7pR9TnybWi8w7gdicajMKgQy02y9vW3OVp5oRNOCKMaUwHTrmzUuBY9ZPpFRDNn0
	 Dg/1wfx4w3bc3gKkm4zc2CCGWI1wih2tY7vF6mP4EIZ34RkIyC+WsEpx1Vng+Ub3Nx7V9
	 Bcle9LDneJWNXBmQzedCgEIl0DJQ+npv9jXuJhXl2juTPiby9tZ8XQimC+rA19ARFZg4f
	 zx8MBMXTd1x+ovdCFKll08F09OtqKYRXqMoOYCNaxhpGCaieushffSsYM4sMW8QpktpXB
	 VsSLgUk/c7byFt4acsw4aWheRvTUF/vZioaTgLesMq8TJAs7IPoR75ucnVPhn2OGRHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LeADCGOC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.71
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3049B606A31C;
	Wed, 18 Nov 2026 09:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3049B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LeADCGOC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jaKrDmoCcZ8PQT41miVoBthnb1BY3fHmnY4d5NpRDKLXUj4k4MERsPO487D63NUkyicRwNyH+MRmmdwFCzD+BDCS3SylHVHHfCBdAket/0DMEbf0wlco9Vd6W7QSS/1WB/vvANDP+BKM9tNTDFfdlOZ7QToIBDoBEk5Sjn990qk85NCDrAZDT0W05yX7Z0hPGtNtkDOCnCrH1PzOUCq2rOopadmS8a8/F+i87CsYwJAq3gW+PoLESdcRN9v1N690WLMvYaC4rXv12kEXo6YHZC3Apz8EG2stsCLLpj4NMN/TH4yrsGQ6bZZmsn5QHk43K4b0E67+CH9I19zdbdjxEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIL67qi/5J1n53vFaJ/cOLtnAmRukFSlBIC+JrXNAi0=;
 b=R85RAGGOcCVzHc8XZK5T3w3sj11S+jMG7VnU42lQENciU+zKYn6nzmxgSYYki5DJV41nUZFCFu8w04+47B06dMiuUT8Fri2HHUvsGtiqpMNSW0buNvQg0oqPEGzX/N1jBSvqtLYeCZRa4mFkG6kMi4LtEG8BLDJRGpKJISavkxaMM9SqmvqqE4GC7SVDVECKKU4jJH9160wMV89srBZIE2AC9yMqVFmLXxS+Y4XqYUjNIrdZaYJZTi0I6Ju1jjYkD+6cYVsdgIe8zdcoJQgfbptDkafbB8DYH6XKoT8rV0iyKTKd2t3V0bJiAS3TCp6nS0oqv67LqnB0oZpJXlX8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIL67qi/5J1n53vFaJ/cOLtnAmRukFSlBIC+JrXNAi0=;
 b=LeADCGOC9PWq8oXHF5KK8tfwkledE8QI5dX68jP0hxEJFm4h7fJUnwKilnGeSkABakRKmehfYKOIDMODVvZpqsLdyPhegVXL6WwNiDcSieZiU8QMEe/p+iHgOcSYrzUlJNIk3jpiFBEMt6sW526zIZyM6sRO/Cv1HX+rPDhsfHNNJlLiC0bEebrjxocK3v+NBtBLs8SEVS9CLY6hf7SKSgaNI6bnbOdrPietfUThEXYkll9aj/r9ADK+ECvoMwFhhNeuwylsMN247bAS4VaCp/UVYtCrJgGrMmGrhJbRygyop1xPcgvOHSH2L5A/+HnzHOUNPkOuIwoKpNTcRbNIMg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by MW4PR12MB7482.namprd12.prod.outlook.com
 (2603:10b6:303:212::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 09:55:32 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 09:55:32 +0000
Message-ID: <bd2573cb-3b42-424d-bcd7-09561153d234@nvidia.com>
Date: Wed, 18 Nov 2026 11:55:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5e: kTLS, Simplify error unwind in
 mlx5e_ktls_set_feature_rx()
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>, netdev@vger.kernel.org,
 tariqt@nvidia.com
Cc: horms@kernel.org, saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 borisp@nvidia.com, witu@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261118025846.3377199-1-xuanqiang.luo@linux.dev>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261118025846.3377199-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|MW4PR12MB7482:EE_
X-MS-Office365-Filtering-Correlation-Id: 953967f3-dce5-4786-446f-08df455a15b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|56012099006|261022105027099003|11063799006|10067099003|261026140227099003|261028144727099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lD/oR2U2avvWoBfgMWhSdnFq0ELDabRIzuviCSNCmY4nmxlSooobLCcicodNWh4VjXbliokXWIMvtlbPOzLVA84CtDU9mLMfx7RtDgOfugCI5rudT2qBMzmKig3F3uiE5AJkqQgxrfc7vW1qfOD/Fdblxs5j6tx1flKwPL2wDScVbQbYAk6zbiKaDfPDJeU4OkdywI4F/7E4uiYhSjZsnCldWFLKSZqZeG6LTGHcCs0NbrKUoVX4eiLlKQBceRnueehIjTuYAM+i6SsSMlrYsm67KtsAQMdc+cFZFShIOfWcPMK/O6rIZHPHVgxZaGCTybiIrVIDZhria0y5dKTFH05Q4S9eKMCYQPFh6MiBIFsqbRARmUlU5SY+nTNNm87DNtR+n1dvCxu7KFSkdP0EqAPBYYe9rGK7kVTq0pOpram/sNK7Rjb091Sjz+Pvk8zMGfQosPYg0eb6GrCLB02oR2PyXDAYPwTXpvZkE3D4As3Z4r0lVrmchzUO8o7kjQh18Lr5XY1P6RO1C7MXy8s9xYSIBsRlaO+3j5wyRVGhrEHjLZUuwnOsCUaL2NjhmDAOPrtPcSB26BsN+qUEGwoIob469WVqEo3oLWyparrZyrlmdnDisBVvV21Kg8iF9rrWv15Lm5k9ycmcZb4oGQrgSneBWcSknqDKp6nTFwqwwGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(56012099006)(261022105027099003)(11063799006)(10067099003)(261026140227099003)(261028144727099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGZNRWh5aDVvR0NwQWVmdEtpVWoyMWZkR2wyMG85YklmT2xJWFdOZTJjWWRX?=
 =?utf-8?B?UUdsVXNJU2xiNS9LZUZtNUZ4N2kxOVNTanBYYWR0eXhpdFE4Q3l6eDZUdHhp?=
 =?utf-8?B?WTVabGVaczlHajlUQVJIRWoxNzBWaHJaMGJnRkxCT2Y2RVhsWkJsYy9jOXJQ?=
 =?utf-8?B?U3pmZ0w3YWZyYVpqYTJsYlA3UUVTbzZXRjZOQjJFemtBaDJaUzJzUGtsdWE4?=
 =?utf-8?B?Mk9rcGNPVWp4WUZRbnBvYlZEVEg4MWtxbXJ6UDkwb2c1MWJGdkRuMUIwTDVw?=
 =?utf-8?B?c2pJdk03ek9DeG5FWnpkMmM2cFhZT0NMNDAzMlIxbkJwc0psQllSZ3p4N0Ro?=
 =?utf-8?B?VUkrSTNKMlVwUkZ2bFNzbDM1NVhaYU1NdTVZdUlpVzZiVzRmejR6U3BNdUNX?=
 =?utf-8?B?WkpKVUZaV3M1a25XOGk3Q2ZqMVlWMXNUcFFONFlveGRMbDJsNUNNdFBBN3F2?=
 =?utf-8?B?NHZTVDRxVndyZXA1blJNYXZVK251ZGNtSGNoN2FxYkhpUkRXZElHb0owODJ3?=
 =?utf-8?B?YlBNaTR6WWc1NGc5MTJWQkR5ZzNRU0k4NEkwK25FamR5ZTRVMkJPa2ZWd2pO?=
 =?utf-8?B?NmlMR04zaVhvSWRqSHhlNCtBZFdKL2swcHUvVEcwVDZaU3hiMWc3OUkya2JZ?=
 =?utf-8?B?Q29Zc1FaT2VkQmc5NlJYOTdxTGNDcjBuank1TFI2TWdGbU1rSEpVRGpMZmxV?=
 =?utf-8?B?c3JoK2J6QkpmZWpZN0hmdDBZUXlET1A1VmIrSmxEcEZSbmFCRElEa2lQay9H?=
 =?utf-8?B?cUo3YlQxWUtwQnp0Szc0UklsenJad21ZMnVTVFUwU0V4OFVKWVpXeFZsUEtF?=
 =?utf-8?B?MjJLa1YwRHVwRnYzZ0lIaTFsNkVldTNJVWkvZ0VybkM2RXR1SjBVYWRXMXhO?=
 =?utf-8?B?YjJQMW03dkRPR25INFQzL1l1TTRobWI2RXNhY0QvdTZZUG53aGovZUxKUWRp?=
 =?utf-8?B?ZUpndWZna1lDOHVmWldLR0FvbEZRZFpBWmxDeURaVEVURDJYNEJFQnlhdXFo?=
 =?utf-8?B?TzYxVzkvdTI0aHkxcnhVR1E3ZW4zaXBBM3hCZS9ZRU9lbmpmdlptZzR5Zk42?=
 =?utf-8?B?RGh5RitKVUlIa24xOXRzNjZXNHVqcmp6NjBDdmU0cys5cXhYdld0RW5Fa0N2?=
 =?utf-8?B?c1l6UENJamFzeHpYNHM3YW5wNXFyemZZN244YjMwY08yNFMzSlhLNXNYd1pC?=
 =?utf-8?B?WktSR2xTL3BQakpwdkVQdXpsVW0ydGVoQ1I3bUZZZjRrMFUvanoxbVd4SlE5?=
 =?utf-8?B?ejFRcUlmc3NhMDRZMytTMEpWWDZxb2ZJK2lOeWlkZ3RHb2ZaYVZwR2FMcEdR?=
 =?utf-8?B?Yy9aWUdVQTVXYnhINlR2ZnhFaHRETStrRS9xK3MyME9aUnF3ejVXY09Wei9X?=
 =?utf-8?B?MDVaL2F4bTc5SENBMnptOVE1dzdjOERjVU5Wc24zREMrQlNJUGtwdVA5R2dx?=
 =?utf-8?B?b2pETDNQYzdtaGROd0dSMnRuT1Z2SEh5VVJ5azMwdFhEY1lNOFcvQituVXhK?=
 =?utf-8?B?UG9jcVRNNGJoQVZmUDZJaFBsV3FYNHRTVGY5VHVrMDlzR0J4cDRBU0hhM1F4?=
 =?utf-8?B?bHFRUmQyVXBtdUcvejFGYWVCc1NMekZBWEk1K0ZvV2YrWHRia2VoRCtObGVF?=
 =?utf-8?B?Y0VaeDYzeHMybVB4TVgrQS82K2ZvTXZPQmV3TlRNbTB1dksrUGFqVzcxeWx0?=
 =?utf-8?B?c3VibVVLRGJLNkJOT1hzOE9aaXQ3ZTRUWUNwc0NkSVZTdUFObnNqOGhYcGxz?=
 =?utf-8?B?REdITm40aTY3aStJSU9UdjRnYlpFbE9jWENPTTh1TFhLTEJNNklvdjlHK2I1?=
 =?utf-8?B?NUszWlp0MTVobFp1RXp4aTcvTEZxSHMvb3NjSWxRMjJwbWtIWlcwNVpnTy9n?=
 =?utf-8?B?eXdobldFT09hUkZGbDZHSnQ1NVV4SGt6a1ZMSWtuWmtNenA3dGFQMm5sd0Ja?=
 =?utf-8?B?eDllVURrTDFlSUdseHBONkxLMXZHNzRxZzhiVjVlNWplV2pUTlVaY0RyREYx?=
 =?utf-8?B?Qi9wdVVDOXdCQ3h0MnhWODRmc2x4ZlF0MEs3a1pSSFUyZzVFTXhLS3lhZ2Q0?=
 =?utf-8?B?S20rTjM2YzBFUEU0Z1RGcm9TcW0vcWtJTzVLdHQ3NEJFdUhOV0VWOEY4Qi8x?=
 =?utf-8?B?bHJuaWtSK1Z6VjZWQ0ZmcU1XQ2R4YzB5Wkt6MU1Ka2ZPNlVvWmMvQTRZYU94?=
 =?utf-8?B?cWVFcTRVVFVBY2w0OTl1R2VnTmx3U2cxNVdNREVVQUVxK2lMcHhHV3lvUzA5?=
 =?utf-8?B?RTRQMXVTSEtYU1hsZ1ZTckszeWpXelpmVTVrMnJaa0p4M3VhdnlPODcybWJI?=
 =?utf-8?B?WlFzZmpIT0lyM2xVdWR3M0g5SGoyUVROWTVTZ2N1anB2WTRUdktLZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953967f3-dce5-4786-446f-08df455a15b6
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 09:55:32.5432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aer9dQt9jCQi+CE2KRz0pA/cB895Q/n9i216DiweTI/wmaXV2VMvKGjidfFQM4PvTdZT6Hp0vxpN0a0r3S54rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7482



On 18/11/2026 4:58, Xuanqiang Luo wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> mlx5e_ktls_set_feature_rx() has become harder to follow: the error
> handling is nested in the conditions and the main flow is conditional.
> 
> Handle the disable case first, handle the error cases in conditionals,
> and keep the main flow unconditional. Use goto to unlock on the early
> returns.
> 
> No functional change intended.
> 
> Suggested-by: Simon Horman <horms@kernel.org>
> Suggested-by: Tariq Toukan <tariqt@nvidia.com>
> Link: https://lore.kernel.org/all/20261029134019.GG257209@horms.kernel.org/
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> ---
> Changes:
> v2:
>    - Handle the disable case first and keep the enable argument unchanged,
>      instead of reusing it as a flag to destroy the tables. (Suggested by
>      Tariq.)
> 
> v1: https://lore.kernel.org/all/20261116110830.2850785-1-xuanqiang.luo@linux.dev/
> 

Thanks for the update, this is what I had in mind.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

