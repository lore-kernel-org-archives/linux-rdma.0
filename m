Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794333202;
	b=hpwnTWA8iINg1rFiGLGX/xYg7zdCvsgQUHyX150i1+3NT9f8FINU8M5N/Fg1BryDxoLT
	 BTrvYyUgTaLQKX7ZSgJsJt+/9OaffY2BRS8K2IFlIf2mTbLMCSyKZplwNi/CSCDDAYFVa
	 PegqvGKZo3T0aS3SxXJZmROfh85zF1Jnostnoun8f017ZrfXJlzlLK/FyQr9zbvFurACc
	 LcOi+HLHvY+J95pic4lhQf7xp+fo4mBGuzWs2snZRMuDW9t7TFJD21rnrY92qUrclUot5
	 Bi2M374nMm8XPYV3UUS0qMp/X1kKc217ppuIN+ewLwQYQyBdBcPZRTypw9qK7eTKtSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333202;
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
	bh=mLGdzmXskLTksm7jIDzUR3v/UMkb8CNfaadtYNSMMns=;
	b=SWbmIocMRDatvGtp98hkEqKHP+OlwEl4wFFFUZ1w+yrREMosQ1BU9m1peUE7zR7iQMey
	 WZV1BoLvuohfg/1vttUsc7FVlBBvm8WkBy5Q6+FQYq5GAxyI0XXMA/TJUaEQTYWxhIQek
	 +1avL6Ao4BwLQBmOwv2/R/bW+UmaRr0RQDlouO7rOI3dPMcRhhlLlwNvZCusIbse8zEOk
	 rkUcQylxlT5bRga7v9AvhNf2rjda3SEkwkCv470jZh59/8/kzS1Mx7+998tSy8QrJiPPr
	 Vn/vwBE2hvCDjnlHHchuvLb7iwptqJvaTv7wTJmcM4Wx/+Ztr9axwO8D+XhoQDDmZCw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Mc9LxfLg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.49
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A66606A320;
	Tue, 10 Nov 2026 17:53:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3A66606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Mc9LxfLg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yIR8+R5Yc0a3OUg3pzL1lXcHTsrkPbyVvZ5gZyESo2pNzohoqwZmzOW72boBEQBl1kX+JcgLX8OUdWKIGwAH7qw/UpT5OYxhQ8/0kyYAKbNor84FHI9SFlb5gd4iFaS2ZGR0ZraPN1JkuhSF+oq+U1o9IoWg8H2oVf09qJzMUXZZjoZMxW1CGvJuST0trBLCe+XSBpECqyF5xl/gpSPd72aE47yLdJKbaFGlOYh2YSxG5kiuQsPEo6S1x+HkH10QngnwqMfXYnDvOpKe+XC+2WoBgihoSsCjL1UeKZtVh1MDJwBiDfwHJDkRJS2BJNQpBeTzlcQTdlGSmLvb/MAFSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLGdzmXskLTksm7jIDzUR3v/UMkb8CNfaadtYNSMMns=;
 b=lx0VBqCVYxmnx6EAzZttwdfGC7x9ZF28XCbmBF1h5ibEpKDE4q7fomsnhM37DNJ9giiDKDAp+800QOYeM4zHPKtO9fj03wANpsHM/RQc/tH+wrf5sVrvqMMZ/rakjpZequ31+fgqGmhzIwIjCXY+o/vbmrOgrt4D5oT8ohgM67QGem5WE3JlbAfyffRuvmZhTiEmQBsX1rlZEK7rOFyusJNv0gAEOeSwgzdjTiibiaUewGrfPbiiSGxgOHzlLaVzW2cytOgJPp9R6j2zRy8XlPjlbBGbj8eWHLTQ+rgealzeNZikWKa1noYD2doJtm3G559t1xad9IVPQuNtkAdiuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLGdzmXskLTksm7jIDzUR3v/UMkb8CNfaadtYNSMMns=;
 b=Mc9LxfLg3MKL0K5+G3lWc50XEsdq4RKRwhK0/3Q/A8tRYLuF0IGbbXXChOP+FZOGeG3BoCuusJ82H6Y3tc5194sg43okg11bDxvRCN2qm/HDge5zVIogG71TzhfL+a/nH3oev8Y7IRlIOu55EEfNL33cOM3pC1J3A/g3J7Qj4zszgrTWcsOZMQ9VC354eQz5GIp5quYDX/6m59/ZSWGAuyZ1uoVnZ0VMeVb9KV4kEi+YvH1swLT0f1+xgWtUjU7j07TxBFglSnzGILzzkbGUXl165AjYbKNsf9G3TlD5yY9Z8OlSFMS4g1bEFOPODS1oxCGA0O28KjGY7YZcBVXKEA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 17:53:16 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 17:53:15 +0000
Message-ID: <ff1e9a93-f265-42a7-85da-520b342e2603@nvidia.com>
Date: Tue, 10 Nov 2026 19:53:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: HWS, fix flow meter release on FTE update
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>,
 Jacob Keller <jacob.e.keller@intel.com>, Gal Pressman <gal@nvidia.com>,
 Ethan Nelson-Moore <enelsonmoore@gmail.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261110173437.2471233-1-acassen@corp.free.fr>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261110173437.2471233-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::7)
 To SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|MN0PR12MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f67489-d727-4412-1dd6-08df3f537ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|3023799007|261026140227099003|261026121527099003|261028144727099003|261102123227099003|261009223027099003|261021135927099003|261022105027099003|261021123027099003|261021121427099003|261022075727099003|10067099003|11063799006|56012099006|22082099003|18002099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	tZ4RUAxd3HgguKGOrKC9R8HxN1V3KJBjUDCFekYiIAhnAgtuNHZkpIq2gI1Uy8xsT3Malvyba7Jqa8/0JPMiJYb6mfTfLf7MOdl4C8a1aCAkg+/TZk7bTlLHRDuKjfAJjxukYjoSLQn+otL81nwGUHqaDfOZQjd7bjOKUJjqeVHHydk+yH/ycuY8aOclx80OcqiIjrfAhcPNRA+blQLGCYnVd14BtVuNUq1ct6T8q4AojUA49f3rq1xFDgD4v3huAkF6nRGOIle0nivmFr7vXVrd0B2jsdSGDQFVoAJBM7npKDI7PNfuLFXlahp9fRjwd2LqbC7jzKMtR98LPBvRr9LPt8dKTLlO0Z4SZ/GlUak4PCIGv+KDFUfEnR1aiQytAtBW8cvUTvWGXe1Xk0lkleaBySa0gY97p0fTqs0eMxNvP2tZkg5QwzeARp7XTy28BuTSlfrP3l/NjmVxbWaSPe2zZJKTmhDHot0gsXCVCRTlt/kjcNVsrixgHqRXlMMFJRUwGxPDv4zPelkVG2kzxX9Tzb+PbX6ZHBf4G42DqZYpczmbIyXFSOn93L9DbrPb3wPoBx2t8otKrbVa/5SZWN8iSknGvXYB20FgSuHXVGkW01XWzatJHS380qaRG301vP4A2wfhgJAvJ8dMHz+60jOOhzLKoHHj9Tt11oiMj8Rpb4Lff04Q9D7yiHrxNMgodFAaP75FYF9G3JnNjIl7FYHNk04fDecICdgrYmVsXyfrGZmXKygt05LPTnpePtPd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(3023799007)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(261009223027099003)(261021135927099003)(261022105027099003)(261021123027099003)(261021121427099003)(261022075727099003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2ExL1JTV1NqZkRoRUxTTjZJaldJRm8rYXo3MEt0T2dtbVoxYmkzRmlDaHFN?=
 =?utf-8?B?T2xRZVE5SForWjJlUmo0N085OXE3WG5QVEtlWWhjSGNWNndWQ2x3NUFaTi9z?=
 =?utf-8?B?dGpkM0NJaWVGeGc2OUF1SURQdG1SS1J5ZTF5cERaZzU3ZmxWcUN3c0tmQ1VI?=
 =?utf-8?B?MVlqSXR2c1ZqTUt4Q0Rmc2o2YUl4R3JQZ2hrMTgzaUlGNzRMcStFa2p4T01o?=
 =?utf-8?B?R1Z3U1RRdHBURUUvb2pkemtMQ01nNmRNOGR4LzRodTE3RkY5aldrU0tMZjlJ?=
 =?utf-8?B?b2w0LzZoeHpWb0MvRW1KemtxM3J2WFFCTk50dndFQWl2MjlQNHJMaW1LUEFk?=
 =?utf-8?B?dTE0M2lBUExCakx5TTFpeWpkdU1qaWtPSVA1YjRZUzh4dHQ1RUhSMjc4VXFV?=
 =?utf-8?B?cmp6d1JuNnhwNUtublczN3MvMzdtTVZXYnZoVzZ3SWQwVjFHTWhiem1raTRU?=
 =?utf-8?B?MVkvUVpyWW1ySDZ2ajZHSkV2NzdVQk85QU1zbEdRVnZpaW5tU3JUVnpLbWh5?=
 =?utf-8?B?S2lvajJUbnZhMm5yQ0IrR0c3UDhGUEJwZkFOd0NwVFNjZXQwd2U3aGFDY1hP?=
 =?utf-8?B?WHNhQ2Q2L2JqSkVzUWhqbXhTOHY3TEd6ampvSlFmTnc2MU9JaFhEMTcrUFFK?=
 =?utf-8?B?SmxGb2tFWnNjV2E4WTYrVVYvNlQwZjdoWTR1UHg1STRlNVdhS3A2eWJGakhQ?=
 =?utf-8?B?RlAvaHVJalNJSGlLejVPcFJwTTBRRVQyYU54TVcvMlhjbC9WNTY4NkVhVzBL?=
 =?utf-8?B?eldYdTNzRXl0b2dzSTJpbFRYSUdTN2JZelU5VWx0aTI0K2JzQ2NIMDlQZXRE?=
 =?utf-8?B?YzVlZ3lJejI0eHpKV0RHNUcxY3Zla3plOEllS0ViMy9YYlJna2IzSm4vY0tM?=
 =?utf-8?B?SENxaE9RdDcyeEtycmhrNTVBYUdNZGxpenJsdzdQcytnYWFWMnVFcVBFemlE?=
 =?utf-8?B?OTd4Q0ZaemRvQjRQV2ozTkhhcGdRaVVWaUh4d1NOZ055QStIeXRYZDJZNUUv?=
 =?utf-8?B?SDMzQm1UVWFQbHdiRWhYOWdwcUFvZkRCdTY5Q0xuY3dpRFZGcXhDU1VSUDM0?=
 =?utf-8?B?ak90M0JiZExmRkVUYlhWZ0hwYWdCcmkrdzJ1c0V5RzFJMkZGZ3FPQTBZUHNu?=
 =?utf-8?B?cDBtNDFQM1ByT0tYcHpOR0VsTkhjcHhkWk12cVNYOE1wRUhtSGF2K1g2MkZ3?=
 =?utf-8?B?TXkrQVBGTXI5c2phQ1J6T0J2VndwcWp0V3Z5eUIxUy9qVWlKV281WDVGekty?=
 =?utf-8?B?VERlcWJqMFkzVE5KWDVGT2dWSzBnZklMeEV0T0NkRTY2NTNaMFFyUGc0YnBH?=
 =?utf-8?B?TFI2R2VsWDlOY0JyY2RvQ0o4d3d1ZTdGRWU5ZXRvdzVUME1LbnhCazVZSFIv?=
 =?utf-8?B?VTVzUk13SXZUNTVWcE1HSGFWMHZwb0FtellTMkV4RjgxY2xNTDJyTkE4ZmN0?=
 =?utf-8?B?VE5CekpjNzJsQlBBVGhXUTB5Nnp5YVBlbFlYa2xjS0ROMWFycFd2eHRKcVBx?=
 =?utf-8?B?WUZ1VlVFVXdDbExxTWdNK09EamNWbGZmaDlJMG5QZlVNdHhkc1pRT2I4bmsz?=
 =?utf-8?B?dFkrOFJET0tmd0d6MEowOUpBU1NBWVpxU1JZN2dDQUpKcDUvUm9QWVVvTXU1?=
 =?utf-8?B?MUQxam5KN0Z2cVBhczdyNGthbW1vQkFkRTFVMm1zWUYvcUx5L2NGWm43elJt?=
 =?utf-8?B?ZmtKOWswM0dBbEd3YjBPd3p1TEN4VUFSOUJuc254ai9CdDFic1VYS0tjL09W?=
 =?utf-8?B?Zjh0ZHVtQ1crMXJ0QzUvREhuU1FZMFFkM3NMbUJaRlYrSjBBemJBdkZaLzlx?=
 =?utf-8?B?MlNZZHZaTWhHQmJyOFc4bXRXelhDNWx6Y0g4QnkrWGZxaC9YVktzeFhlMDhV?=
 =?utf-8?B?QVpBT1ozck5DOTV3WkExRXpMR2hkM1E2ckNuZnd2dUp6RHEycEh3VktyYWRU?=
 =?utf-8?B?NWREdWJ5Q2FmN3Npd0NlQjhuMUo3U0kvSkdTcFErbFhIdUZFa0Q4UWppUDdE?=
 =?utf-8?B?REN1dE01RGpqbEgvOHQ5V3BxeVlkODZmVEE4SFU1SXJ2bnVWeW8wMFFWazFl?=
 =?utf-8?B?SFA4bmFmclBwSy9memxmSkZaL2c3SnJCK0JuN0ZQWWxNaksraGNaa2VVY0U4?=
 =?utf-8?B?dllPb3duaWtWdjk5R2hBbjU1Ni9qaUhOUk9IMjJJRE4wUEtVeW1EWjIxSWh0?=
 =?utf-8?B?bXNmTW8rbkNQTmtIdG1vS2JNT3FjQkJhRUh0cDRKNzZsek9WNTFzZG8vUmJz?=
 =?utf-8?B?WURQN09XV2plNmF5ODVhQVovMTNMTUtvL08vSHVoZUl1bTdzOTdYMHJFQ0Mx?=
 =?utf-8?B?QVRIU3l2ODF6UU5DUklTWkJpUGNVMU1jRi92REJDSXlFdG5tallkUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f67489-d727-4412-1dd6-08df3f537ed6
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 17:53:15.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhQSuQivTodei6ZZKguE1tVWO2ft49utcxt8C2PvfZl386Nh9HijaR9b20q3U/Ks4hq9MkjCSvMCfhurc6prtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5713



On 10/11/2026 19:34, Alexandre Cassen wrote:
> HWS has no duplicate match. When a flower filter is replaced in place,
> its new rule waits as the pending duplicate of the old FTE. Once the
> old rule goes, switch_to_pending_act_dests() copies the pending actions
> over the FTE before update_fte() releases the actions of the old rule.
> An HWS rule reads the base id of its meter action through a pointer to
> the exe_aso of the FTE. That release takes the meter action of the new
> rule instead.
> 
> When the two meters sit in different ASO objects, the old meter action
> leaks. It keeps its ASO object referenced. The firmware then fails to
> destroy that object and to free the PD of the meters, and its STC is
> still in the pool when the context closes. The new meter action is
> destroyed one release early, while a rule still points to it, and the
> last release underflows its refcount:
> 
>   mlx5_core 0000:b1:00.1: mlx5_cmd_out_err:822:(pid 2641): DESTROY_GENERAL_OBJECT(0xa03) op_mod(0x24) failed, status bad resource(0x5), syndrome (0xeeda5c), err(-22)
>   refcount_t: underflow; use-after-free.
>   WARNING: lib/refcount.c:96 at refcount_dec_not_one+0x3f/0x60, CPU#43: tc/2641
>   Call Trace:
>    <TASK>
>    mlx5_fs_put_hws_action.part.0+0x1a/0xa0 [mlx5_core]
>    mlx5_fs_destroy_fs_actions+0xa8/0x110 [mlx5_core]
>    mlx5_cmd_hws_delete_fte+0x49/0x90 [mlx5_core]
>    del_hw_fte+0x209/0x320 [mlx5_core]
>    mlx5_del_flow_rules+0x10b/0x260 [mlx5_core]
>    __mlx5_eswitch_del_rule+0x5c/0x1b0 [mlx5_core]
>    mlx5_eswitch_del_offloaded_rule+0x10/0x20 [mlx5_core]
>    mlx5e_tc_rule_unoffload+0x4b/0x100 [mlx5_core]
>    mlx5e_tc_unoffload_fdb_rules+0x35/0x80 [mlx5_core]
>    mlx5e_tc_del_fdb_flow+0x2ca/0x310 [mlx5_core]
>    mlx5e_tc_del_flow+0x5d/0x2d0 [mlx5_core]
>    mlx5e_flow_put+0x3a/0x80 [mlx5_core]
>    mlx5e_delete_flower+0x291/0x460 [mlx5_core]
>    mlx5e_setup_tc_block_cb+0xc4/0x110 [mlx5_core]
>    tc_setup_cb_destroy+0xcc/0x1b0
>    fl_hw_destroy_filter+0xa1/0xe0 [cls_flower]
>    __fl_delete+0x2d0/0x3d0 [cls_flower]
>    fl_destroy+0xbd/0x160 [cls_flower]
>    tcf_proto_destroy+0x3b/0x110
>    tcf_proto_put+0x3d/0x70
>    tc_del_tfilter+0x362/0x8f0
>    rtnetlink_rcv_msg+0x384/0x460
>    netlink_rcv_skb+0x61/0x120
>    rtnetlink_rcv+0x15/0x30
>    netlink_unicast+0x2a1/0x3d0
>    netlink_sendmsg+0x237/0x490
>    ____sys_sendmsg+0x33b/0x360
>    ___sys_sendmsg+0x99/0xf0
>    __sys_sendmsg+0x93/0x100
>    __x64_sys_sendmsg+0x1d/0x30
>    x64_sys_call+0x821/0x23d0
>    do_syscall_64+0xba/0x550
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
>   mlx5_core 0000:b1:00.1: mlx5_cmd_out_err:822:(pid 2642): DEALLOC_PD(0x801) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0xef0c8a), err(-22)
>   mlx5_core 0000:b1:00.1: mlx5hws_pool_destroy:386:(pid 2642): Attempting to destroy non-empty pool
> 
> Keep the base id in the rule action, as the sampler id is.
> 
> Discovered while stress testing a 5G UPF kernel code. Without this fix,
> the reproduction below gives the trace above on a ConnectX-7 with
> firmware 28.48.1000. It only uses tc and devlink, with no kernel
> change. 129 meters cannot fit in one ASO object. DEV is the uplink
> representor and PCI its devlink handle:
> 
>   r() { echo "filter $1 dev $DEV ingress prio 1 handle $2 protocol ip flower skip_sw dst_ip 10.0.0.$2 action police index $3 rate 1mbit burst 32k conform-exceed drop/pipe action drop"; }
>   devlink dev param set $PCI name flow_steering_mode value hmfs cmode runtime
>   devlink dev eswitch set $PCI mode switchdev
>   tc qdisc add dev $DEV ingress
>   for i in $(seq 129); do r add $i $i; done | tc -b -
>   r replace 1 1000 | tc -b -
>   tc filter del dev $DEV ingress prio 1
>   devlink dev eswitch set $PCI mode legacy
> 
> With this fix, the reproduction runs clean on the same ConnectX-7.
> It was not tested against kernel selftests.
> 
> Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS action")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Thank you for the fix,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

> ---
>  .../net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 8 ++++----
>  .../net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 812b2f3cddcf..cbcbc2b62809 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -523,13 +523,13 @@ mlx5_fs_get_action_aso_meter(struct mlx5_fs_hws_context *fs_ctx,
>  }
>  
>  static void mlx5_fs_put_action_aso_meter(struct mlx5_fs_hws_context *fs_ctx,
> -					 struct mlx5_exe_aso *exe_aso)
> +					 u32 base_id)
>  {
>  	struct mlx5_fs_hws_data *meter_hws_data;
>  	struct xarray *meters_xa;
>  
>  	meters_xa = &fs_ctx->hws_pool.aso_meters;
> -	meter_hws_data = xa_load(meters_xa, exe_aso->base_id);
> +	meter_hws_data = xa_load(meters_xa, base_id);
>  	if (!meter_hws_data)
>  		return;
>  	return mlx5_fs_put_hws_action(meter_hws_data);
> @@ -704,7 +704,7 @@ static void mlx5_fs_destroy_fs_action(struct mlx5_flow_root_namespace *ns,
>  		mlx5_fc_put_hws_action(fs_action->counter);
>  		break;
>  	case MLX5HWS_ACTION_TYP_ASO_METER:
> -		mlx5_fs_put_action_aso_meter(fs_ctx, fs_action->exe_aso);
> +		mlx5_fs_put_action_aso_meter(fs_ctx, fs_action->aso_base_id);
>  		break;
>  	case MLX5HWS_ACTION_TYP_SAMPLER:
>  		mlx5_fs_put_dest_action_sampler(fs_ctx, fs_action->sampler_id);
> @@ -937,7 +937,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
>  			fte_action->exe_aso.flow_meter.init_color;
>  		(*ractions)[num_actions++].action = tmp_action;
>  		fs_actions[num_fs_actions].action = tmp_action;
> -		fs_actions[num_fs_actions++].exe_aso = &fte_action->exe_aso;
> +		fs_actions[num_fs_actions++].aso_base_id = fte_action->exe_aso.base_id;
>  	}
>  
>  	if (fte_action->action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> index cf068fb5bdbf..4fdeea9fdd12 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> @@ -57,7 +57,7 @@ struct mlx5_fs_hws_rule_action {
>  	struct mlx5hws_action *action;
>  	union {
>  		struct mlx5_fc *counter;
> -		struct mlx5_exe_aso *exe_aso;
> +		u32 aso_base_id;
>  		u32 sampler_id;
>  	};
>  };

