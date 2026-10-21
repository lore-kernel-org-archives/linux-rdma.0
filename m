Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792588211;
	b=tn6ih6lgwZRXTYXR9v7+NyLGSpS3+UNY+Nkh5TMHmlsSo404gF3Uv3+u2WSUAWHz6AAg
	 fvJRkEBAOnOK51/N2Cv5bva2080wYWEEy50l5hz7cBIdTh8ORieIFw0C1uQn2NXwvXfMB
	 PJOaxyUYurfy2XziQRngT7yEh/E5n1koXAS4VJZSNlWRKIoTlZm1QjNMEDu/4+LFM/rck
	 Ho9a9jrtBMOYHKorp7a5OAbDZq3L6XlTVB82t+XV3BRrrPM8biFqOQl1tfA5cYQpY99eY
	 h3PMl8N0akv11rkvoE+ra8BLCg5+5wiuD21QoW5amh280bU2HSMbuhGc9STyNEBt4Vw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588211;
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
	bh=38JPmohYw3JtdG07XYkX8XXFWnONVnK1ALykvNznEtI=;
	b=wPqsHLT4hwmoAhZ1ULATwk67lV6CKBA0SUAk+vvwrP1c18xy7BWjfify2kkFiDm/9vTy
	 bChpZGNzMZVSP7DTyHwk14wpy7Zq/wNg4M8iupewnKAkxHSb2GZXqmK/ZcjqyERywV2Ci
	 4BuahkksjKf6KZyK/sNJAM45hpd0C1LWeZzMRvYkQLhYz5jlaG6H/loErjPeBgf8hhZXk
	 NKVGc43xXq89KO4CH3nwQEvtsseRneaCD/iVM0RhUqW3A8VCrSH8lzvb2J8po5a3FU5nw
	 rWGXTBrIx7IyPjvmAXLm+U20c1CF1WTtUJeoHabtSzf9h37fAemF7xMFgz+1YInP8wA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oDCA24rV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.33
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011033.outbound.protection.outlook.com [40.93.194.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B809606A326;
	Wed, 21 Oct 2026 13:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B809606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oDCA24rV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IqguMXLWVBXL0jDaAJmTTxZaXVQuLwDKS1/H+lvW5Vb5ftZea7WpOfh+7+b/pLMGCB9GK0123oZkpwfsBajHEOOwGsfEwzcl9x7oxw3seLLjuEHOx59jhqK2VvpWh4nnaih1MkBjCUOHWKzvPiDbaZ8Zl43jfiMgcAZlWJzQbvcf1G9SlEKi4o42Vg6iuLBweWcahdBj9MbUN2SrBAvU7gtB0vD16Jr2QSphFGbEezn9SBwLpaRX1Hk5qxTvpcCnY3PMzHFk1RlyBTaAkq4XBlA3oDCAK9kPq4O++bGaBGF67G0U2U6K/saS5b0qkL1CuXYHrkGOAg3Dn8La/AKj/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38JPmohYw3JtdG07XYkX8XXFWnONVnK1ALykvNznEtI=;
 b=VLRVDU9z28NF5aXBEppTkVmH9AmhBGkRhTmjc8u+9kQnFacnKBgQI1cHRK0T3YXSAps48Q7wvOe5r9pw0AMkm57txpnn/qfAej4WdhYx+Xb4ukdBqz1iIvcu5WM9OrWRDTSgcwgfKZ6UtZDh/TVGxI5n/FSTL5h8DbRwH/Ql6j9lQZg+vXskTgEczT+mZ6k4kxFi4P2xS1oaLq4s5vOpviS0O5XWHrsCkpJm9UfXrEjGNaNozx0SPfhZJwNF2IB6ifp6Bnjy0+NVKWZ+39FMeQYhksOLzl8UZ/SfcDYkaXwt3O0GE7xJ3YzwjyxPQR7ukUw/G8RclPIsvtoYlJTQ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38JPmohYw3JtdG07XYkX8XXFWnONVnK1ALykvNznEtI=;
 b=oDCA24rVkGc2AeMt3D3ZSXhEZcAI+FSzmTvn8aUi3jHNemE0/0RgO6qGfLoT/NirHtxCa30PfxEGPCswPAQ0lUf5UnDw7jFDXQ+hNbI/gU9XEtQJ1g+DrW+3OomGmvF/AJii8S1Bs4exPXpD9CdU6zUHyOIFtuEygm8IogH/ol3OmiBaVuQjbuzCjNFbLc67F6hXcBM+1PpPiEhQBG6tGnQLSsrZmjfkXVFv/J4iUOpFyL9C88A8FtUbv7xbL7HuerBzoTBqSIyvUrAExSsLDo+68t3kPN5VG6o9oJPjL6uHIt2hn28ad5DbxADXWlGpAoZLaEKEBcqwXk4hYBcJww==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by CH4PR12MB840224.namprd12.prod.outlook.com (2603:10b6:610:51a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Wed, 21 Oct
 2026 13:10:06 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%4]) with mapi id 15.21.0522.013; Wed, 21 Oct 2026
 13:10:05 +0000
Message-ID: <fa6a33f7-9967-4934-8a84-b50d7cf8570d@nvidia.com>
Date: Wed, 21 Oct 2026 16:09:58 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5: Use only loaded devices for PTP clock
 operations
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
 Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>,
 Patrisious Haddad <phaddad@nvidia.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shahar Shitrit <shshitrit@nvidia.com>, Thomas Gleixner <tglx@kernel.org>
References: <20261021105600.3481485-1-tariqt@nvidia.com>
 <179258039278.3290.9931291968534367820@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179258039278.3290.9931291968534367820@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
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
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|CH4PR12MB840224:EE_
X-MS-Office365-Filtering-Correlation-Id: cddbbba1-8af5-454f-d493-08df2f749fe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|23010399003|376014|366016|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	vdjlfV9KUFilQUk2OCVcJslEb33p2nGQS/S0zdodRJ8L7ej9IIfHLchI3oiCwlS+yBkmYSltH0XJiYuhCsJxnTHJlsFkWd7334QtYRcIjegUH8pjZKW+GYVqzP/nwEzicrd7RLXnOolyfES8wQi1iemqQDCJ+ddOHxLnPDRbwiGq3hkCl5mXmxkv0e5wCfyLNB5sqLDRGqOtG0tJiPZT7ql5LG1OzG1fIcAhUl9DAYzNHKuJA5AexYyYUFGzf2qkfc2YbX0234kXxykIaHqgj8/o+UDFxIQ+O1u/W9xe0ud7QF5VSXYyeagueFHpVpRus/RGavZ6tkxLdHF1T47os5L6aJZJkddctyhad6dI24fOe9zkFXvoO308lDnmTAyIBSHRjbxddSKCmkU1h4lDdUMH3W5z1pEav+uVy8erLsW24ZQrxsi+Tqv9EkhwAXP8dv+ODYVk8RYw94mcyBcpqno8m8sTBVu87zi11EbVRA4qdD80fdRVsY/ziDxJcd09d3oPD1tOW/HwEzNsCAoKZjN6WRvSQDPUKmFonMm9rVodTaw11Slk1atJR04Qm0echf1bwwu4bA2k6TuBM3tAv8S7uNE6LIT9DlIfTMOCZYnWysj6N5wwE5QS7ksCIut4ojIrSh5Tjpv4SRgz6jCWl1Y19MpMy/1sId3aCZ3qMts=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VElJa3F4T0NqazdHb1ZybVJJZEVxdXFvWFV3VkFITWx3RnFxWTQ4MDd2WXA0?=
 =?utf-8?B?anNVL2lPcmdTRnJFRndVa1BUNkIyOU5QMDFWWHZHdGNkR3NuT3MwVTRaVXJq?=
 =?utf-8?B?TnNkOWtYSDBXMVB1ZUxaT090WHVncU1hVUhqZGFaZjdjWlZHMTVmcnhGRWxY?=
 =?utf-8?B?dXF0cnh0bjF5SFA2eUs0WGVNMGIxZ2grMGdQbG8xaUFQckVDUnpJOVdUaDFz?=
 =?utf-8?B?UHJ4dS92YlM3RlNDeFQvZTFuRkg4NmsrVndtQlhlYnk0Zks5aTcrWlptWGQw?=
 =?utf-8?B?dnNOc2t0a25pU0hBRjNPN1ZYUG9jYk4zY29QZXppSEtqeXU5TzZmMHJ4UVhT?=
 =?utf-8?B?SEhiMmorb2V1VFpZT1hzVWZQckkzVzMrZXdqSm5ZMzFZL21reFkrbzl3bVhm?=
 =?utf-8?B?c2tJazRNOUhOZ0JJdFlvM0NIcG16VkZYSlNWTTNLWUVMNjFWUWVVemtWTnoz?=
 =?utf-8?B?N0VHVmJyM3RzdkVxd29SVHlNVE9ibWpzY05QMHZCb0NaS1hyZ2Vnb0V4cGdD?=
 =?utf-8?B?dktYSXlLUTJKYzRRNlNTQXNMN2ptZFRFdkZrT0o5bnZjS1JVS054eFZkYmZu?=
 =?utf-8?B?RGxMUHhlZld5VDY3TG94Wm9wYWNSdzdzbVgyWmNMa1Q3Mi9xZk5IMnVMY21q?=
 =?utf-8?B?WWVGNlRCd2JUWm9UTHlnVGpmNk9mM1RZV2IvOGdjU0pKRWc1TFFTOEJBNTNq?=
 =?utf-8?B?a0lHbUlTdHpxalZXYTRUM0FldUlPalZINXJPWWs3RFl5SXRRTS9nZnIvcVI0?=
 =?utf-8?B?TGpPNi92N2FVZUgrSTR0Tmdqc2V6d2d5cWpSc283MktGRUxuQVMzaGZKbUpv?=
 =?utf-8?B?Q1J3MDhheHVNTzNDd0kvRkZaZWgxZUdvQnUvaTFyazcyWElVY1RtZTZqVEZN?=
 =?utf-8?B?YWR3eWhaZldsS1pYWUtTM1V4dHpjOVdQeGUwZk9uem5zUVJ5NE9CYU81TGF1?=
 =?utf-8?B?d0VQU2xLRXptSzQvMkpuU3A2UXlzTVVLQlhJc3UrK21KZmFGRWljdHRzb2d6?=
 =?utf-8?B?RWc0MGsxa2YvNHlBVDdIclhOcWUzQ2NlSm1PWHlsdTlpR1haeklQdU9aVmNR?=
 =?utf-8?B?anZuSXNvd21aVjJXaVJrTXMyWjdVNnB0MHpRL0tFSEpMSi9leldyOUtYTnlG?=
 =?utf-8?B?anVHZUo2K2N6NzhsN0prcDBvZDJkMWNXb2FGYWpiU1VyQ0lNamMrb2owWTVt?=
 =?utf-8?B?VjlTR1k0Tm1SRTdvcDZ4Rmx3dVhOdThpMFpFU1ZsQ1pqMERPVGthcWp0WGhP?=
 =?utf-8?B?UUNTbm1iR3did3VkbU9zbXR4SGszeHcwQU5QTU5YdjVaTUR2WTZQbllWYzg3?=
 =?utf-8?B?V1htWmc5dWxpdU9nSmtRQVhlTGtUbXBUaytqaVYraEw5MmtXWkpTREJUWDZp?=
 =?utf-8?B?VHErREpSVGZ4NTNkZU1ZTUtWNm1KR21GUktZbGdpVEhWU3pnMXNSdUs3TDdk?=
 =?utf-8?B?TVRJLzZJMzRqWlZRSmY1RjBnbTdzdUhKcld5RzFLWmpNNXF5NS9sUGVqaHh1?=
 =?utf-8?B?c1gwOFdFclJJbEJZdFJBZlliWEdSQnhOVEpIVnFvVHQyMWVldjl4Zll6K1RQ?=
 =?utf-8?B?VDF1N2hvcUZvRGlLTUUwaVNMRGhwZ3lISTBLTEgvbHdDRGh3RWpyM2dlRjZo?=
 =?utf-8?B?VWhvZEFIa21sdStOUlA3NTFmZGJuRFJhdy96SE14K2pCVEdLV0JSTUpJdDE5?=
 =?utf-8?B?UUNTVkJOeDBpd2wwVHBWdEpJQzlQYTcyNEJjQWwrNDRyb250NW1HVW1ZNFN1?=
 =?utf-8?B?U3lXNVRvZnVZaDY4QVVSdlQvNXlDbkhlV2Izb1pVZllxU1lycDlaZGNFbXZF?=
 =?utf-8?B?UUJ5MFNLUmUvTW5QRVdKMjNTM2V4Z1dQL3g0eDhQT25KWUlodlVGemoxb1VR?=
 =?utf-8?B?TkFFbENuVytNcHpkMXdERXNTeTlSVThtWWJydUxxNVBpczdkbG5sdUhkUjhF?=
 =?utf-8?B?STV1UXF4U09Rekd6SGlOWjNLNDMvaVFGNWpFaXAxMlU3RU9iMlFQRHErWmNa?=
 =?utf-8?B?NVpHaHNhcnFDTEcyRFppTXN2a3BZUSs1NE05TlhOcG5YVGJteUM1WU5LY3Bw?=
 =?utf-8?B?a1Z5U0ZucEhCU0lNSUlaUUo0MFdLL3B4L2FjZlhHM0wxSW1VWmJnNXNpeVA5?=
 =?utf-8?B?T3lOcDROdlpyem9mbDFYdEdiNU8rREEzRWlzYzh4dndKRXhLckFlcFh4Mzdr?=
 =?utf-8?B?cVJXaVNkekhQcWxEMGhyaFd3YlJOVjZTd0o3elRFVTQwajQ5WG5kZzFxUUpk?=
 =?utf-8?B?cDh4blBGdFBuQ1ZvbkVvQlU5ZUFCbGE0bnk0VzNrcU9KVjloaDJuOUovMGZi?=
 =?utf-8?Q?CXENSU2Zm8bJ8f+FaV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddbbba1-8af5-454f-d493-08df2f749fe6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:10:05.8516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqyEXEN0FoVje2H23omu2e6bOn8lJOVyqafzsE8cLpq6PWmeDjwwr+iBAoU+nagnYGBgm5V8Q0e2D/M0IQPe6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR12MB840224


On 21/10/2026 13:59, netdev-bot+sinfo@kernel.org wrote:
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
>
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
>
>   - What hardware the change was tested on. For driver fixes please
>     mention the device (and if relevant firmware version) used for
>     testing, or say that the change was not tested on real hardware.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

Hi,

The issue was observed and reported internally during PCI suspend/resume.
During the initial investigation, another team found that stopping the
PTP worker prevented the issue. I do not have any logs to share.

I then investigated the report through manual code inspection and found
that the periodic PTP worker could access PCI registers through its
backing function after that function had been unloaded. Stopping the
worker alone wasn't enough because PTP operations could still access
the same unloaded backing mdev. The change therefore ties the worker to
the load state and ensures that PTP hardware operations use only a loaded
backing function.

The change was tested on ConnectX-7 hardware.

Thanks,
Carolina

