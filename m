Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99A2E974D;
	Tue, 11 Aug 2026 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476716; cv=fail; b=a/v2SUUw266U3jecS7tBW6V0ZxWam6R/My98Hvgzvc82iVrGi2uG65T0WSIGwYwHjwA/t+SP80GrAlrzQMjNkb/OXgzgKZrUpvEYLhPMLTqacpuILBvCf3iIVlSUcdAe52aYKeHhnOYw+4lxZ7W2r3YRR34kDlhUpbSaY3k+VEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476716; c=relaxed/simple;
	bh=seq4VNQjwDyj1N1+cPaP2cCjCRcFAhhLVF7Nn8nPw1s=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=JErL0Qu7iQHI9lNI4QKo+RcHF0f2pHG620TlCdgMpzCFWaW6zO4gZ/iNfMSsoyG2qlAiumONuSUYx08gMVr8m4lgqSBqzkNk4e8kUMDep+4UR8oZ1nH/8pJw0seFMUKG14+M+uyJe8TeGKIqzaroabGdefa+pf622Uo06/C5B5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fzdj5f0t; arc=fail smtp.client-ip=52.101.52.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fzdj5f0t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zE6W7dWzmkVA6i8B8l54y+sZe0fPxpNZoG96QOFXKXOgY3nS1P61GtgooOmjQjAXz0xS8dV3GsAqxwMoLVtrLn+NmVOZ00jQLHlEDbKDod4rxmKPGl8HrWG2MZ9JvVxzb10nBuYvCftNkvFb/iQKJ/imXpzVot/YLEi/jH45lpxV7dIvy01PkcqH1tOkHGsQnu7YvuDJYRFlovTlBwpextQk0KLIekA3jmrNnKhLlNm8AoqvkBd1iBrC4AVpXdMV24EyqpAi3tdEMV05VMDnTwg5oUTs45m8F8wi02eDQxAeKz3wP44E6WAZVnqaIX3RxS2SXDNXHIkhVg1u0TmrIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNf5qWop8gOZE00KAneFnGYt2wdoZ90vtsSdhubUEk4=;
 b=lg63Zgmu+wYhfh5P707ZXf06Lf3IO4mSuX3Kz6S9IDrhA9ehr5BeuAMB6l9LBlAVVwzqYL4D4TvqsibHh5eK/628NI2xrd+Efn44VwZlCzS+KvfKEsNSyYoKkdsbXgrdzeZf3PlAGiZj6XGLaRwBOPB6VD9gOSu3RRucR5PA4qiu0VliLHrmf/NjrSDoFfdJNFFnI86wiEc+RD2z+E6A2Ak1FJOJTSOPCBSyYs5UrWa8XCyRthCjTC7jOcv+Pa5gtrdE/X9bLttz3dvRyi9BYM7TazZ3KLoYRRpZpGASUlj80Bayc4NDoS8/nlnCVbR1ruWDGAU78Xl5YAzFmZAIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNf5qWop8gOZE00KAneFnGYt2wdoZ90vtsSdhubUEk4=;
 b=fzdj5f0tRH1ReuNQhIKyNEz2lIJNef7zOxYfikU5GakjJdA1n3GAvtLFTPh0xG+tNidaLDxmaf1L6Cjjrdp2BIwFtNDcm3TAqr0wrqDgI8i81a/C2wsyooO4jSZBmeP7TAlLn81CgsDTOrIjkh4dCIuAoRuOO3FhcXsd6dqJLrnNzH8J59OL92GTcBUgvF7utf2B3QxgMFO55uqpttOItGpwfml7UffdUDLAZskICGmJ6nJF5OYfGUYqLghZ+otA4XuIObw8xk+9Niqsh9zQCQYgUjOif3N1MKhu22s5aereP9daiHTfmMS+dZdQzHIHNZ2odOZik85t/6oKjRIang==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 06/15] net/mlx5: Add IFC bits for new
 ordering caps
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-7-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-7-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669513.282103.5969794645363407828.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::35) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: 308d0d8a-039e-4122-3915-08def7df2fc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0ni+92kdd1tqKI0mKJe2y2bFpkTrgq3U8dfv9tdUVx1ECorxSg9j7x36/MNkZ5Ce4QG/Dl1vO2wnFlsnQuYe18iuS7Ka+0OeVd1VHowAeIZZkRIxPF0bPiZO94OmS3yFUpCBlTg4bzmzVd0oUQlgSFDpBNYcfbesKYfjVOyKWzgLhbaQgoB5xvqhmbIueejGAHrM5VFO/bs9FOFxRmNX0TxwyNW6YTgtFIjjicfq6KfzACMnX+1dgRGp6Ktq4re4J7YhFaRwGh6p63OYiwd1LsiGZdpitE7c6a7SPPYVrrXXrxSrxhydBsMWXdquDKSDu2ZbCy9BLnlstrusqxlQuUo/onnGGs4bPWg9z47ME0JB9oSi2SSXWg9d2m9nAsYHsA0m9IwDkDTTAc29jLhBCEcTwrtPSk2BMmBSxGJhl8hlecuLEajPeFQvNxP+0ptbDKsXYzYPdby1/yLqy414VKfZnNVIm5hnIE+FrtzrTerMnQoCatnZY/xKCxozcLRsrg3mohpaLCN+1kpDzgFg8UNu6Rne3icrmmsZHWuEeNiWJVQYnixtrchujCiJoYRB85Q7M+wGF0gUiOyy3IuX2bwaOJQovFsvpDqTwJ6pZxaP0PUxc2lY2aofHBTSbF0QNCO/lpUJoSZmmFO98tvgjH7QVoYTJj+Is9phk9ipTbY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3BzL1NOalVCRUZxL2ViUVFaSWZZQnhYcUVScGwwaVZlaGg4SHV4SEkwNk1O?=
 =?utf-8?B?MDk5Y1lTMlJOTXlZdEw1aWlpMXhKdmppS0RDbmtOaXA0L0hVSnNEajhGNlZv?=
 =?utf-8?B?b0lRelg1NGhHZEJra0dLVFZzSnlybU9MMXNGcE1GemxpNHI2djY0djMvcVhn?=
 =?utf-8?B?d2Q0c2lpK1ZGUG9aWkhwN0ZjZ1RpMHJoRSsybW9GNkMxNUQrME5GS2NRWlht?=
 =?utf-8?B?MkY2dUsrdlFoWjBrUU1UK1pwU0RuUGZIRjNWWHdiZ2h5S3Z0c010YU1GZE4v?=
 =?utf-8?B?ZlVhVHNiUXhHUFRCb1l0b2RzNnpxckkveCt1NFdoTjFIS0RxM1VSQ2gwRzNL?=
 =?utf-8?B?TVFleHRiVFRtTnBVOWNVOWN4Rm9CWTJLYmlHRWVmQXdaZEQ5a0toL3p5M21o?=
 =?utf-8?B?bG9OVHkzb3RWaXk0azRzUlJFUGJhYXdEdUFlUnBkdWt5Q0dSTEZVckl6UXJx?=
 =?utf-8?B?ci9sdUorc3VTN282TmR5K3hWUHJGaFQxbFRzbkkxSDBRaEZkMUhPTFM2ZFc1?=
 =?utf-8?B?VTlZRW9KWnZJR0V4MGlaaHFsNmtmZVlMREFpeDFpNEg2Mi9tUlJPdU9QVEpt?=
 =?utf-8?B?MGk1aHZSeGoycmhpc3pObk1wQTB5RW5lMXN0MGdsb01BWWVuNmtwLzFkMW4y?=
 =?utf-8?B?Q0tzak9YUzE0SGM2S1pJVlMvVU1oaU4yeXpaZlkvRlNDWWxpRy9zMm9UVE84?=
 =?utf-8?B?TGt6U3pBQlJPL1M3SW1hT3l1eVZxR1Rzcy9WTjRVbWZ6eUdBTFVpeGw5Um5O?=
 =?utf-8?B?emVGMXVJdVJyTGw3N3BMTEpJYzY4eTBPZkdnTnIvSzE4MUw0TG56U1JGRW9R?=
 =?utf-8?B?Y3VpU3JNTWw0UEZxaUthVkJEeWxIYjFJMUpjb0cvcENvNUMvNDNjRGhIZGZT?=
 =?utf-8?B?SHg1NWgzMnpqWHBDL1g5THdyRzFMRWp6Vk9nUWhzYi9aNFFBdCtGNFIwazlO?=
 =?utf-8?B?NEJXcEpXL2pNUVdDWllwWldmVm9WYmd4SUxnQTR0ZlhqL3hLWkVnbDFZVTNu?=
 =?utf-8?B?KzRvaVRaUGl6b3Y0VEtybWZDQTk0RmhRM0RyeDJOZlV2NnpmUDJETmw5Kysy?=
 =?utf-8?B?MGJCZ3ZwNlZTMmNJYmIwZXBSSTkyakEySVlHZ2hJcXZRWU4yZEJ5VGpLQ1po?=
 =?utf-8?B?VjNGZ3VWWFlHV0pQT0tRK1FMZ2RHczhGK3JiTENXQ2pqOG5ZckxWV080cVNV?=
 =?utf-8?B?WHlnSVgvbkVZSnNYcVNUNW9jT1RBS3RTK2FGNWV4OTlKeUMwdENiTlVLL0FZ?=
 =?utf-8?B?L0JRV0ZhaTM1N3cweDc1amMyTXpTeXlDODdybTlyNWxvOTlNd201aHd2SW0y?=
 =?utf-8?B?NFl4NThHSzVzZnBTd0VwR3B2SmdrcjlqTVRRQTJBbFJhaG9DcGJCVzRvSnFQ?=
 =?utf-8?B?bEwvS0tDTnllMXFhR3ROaXFBV2ZHdmJwdzAycXp6K2JIK0FLdS9XOWl2VXB3?=
 =?utf-8?B?NDZ3NENseHIyOHhYeVlZNFhqcFlFU05JaktlSEttcy9RaXlSZTlDMHdDNUwx?=
 =?utf-8?B?VjJkQlpndDBnNkpJdW5nc2IvZmtsOGVCRGZ0UStTMnFSZjFxZnNoSk5zTThw?=
 =?utf-8?B?bGpXK09PakNuWGtsQnQ4NW5PK1ZaTVE1OHJFYVZLaFMrNDBPazNNem1RSDhi?=
 =?utf-8?B?THA1dVFkb0xrS1d6blFDeWI3OU12TTRZOHNLeEJ1QnNCa3AySUVsbzlXWXB3?=
 =?utf-8?B?SVBSSndEUUZzRWtFVlhFUVBoZWpNK2RaOGFTa0krcVk2anNDby9rU29TRnY5?=
 =?utf-8?B?NWZaN3ROMjIwREduWmgydlkrMjR2ZWtNTmNmc05EN1l4cGxxakZjVUNVWG5o?=
 =?utf-8?B?dXVlZDZkSHBuSDNNK1o0UGhDTWxvSHJIcHIveEFPU0ZFUlFHMnlWQXBocTZC?=
 =?utf-8?B?YjA2bHo4VEw4OTBidE9ubkxqbE51VGluVXl5SDUxZzdoNS9aMGZYbVUvdVRW?=
 =?utf-8?B?QjMzMEtEaGJHalBMV3VOb0lZak56bG1jTFBRQmkvak9jWUxtcHhZY0paTy95?=
 =?utf-8?B?ZHBxSUNtR293NlJQWlYyYlFNWi9pQVFYODNDZC9PZkRQS2tGWTFLYk1qRTd1?=
 =?utf-8?B?Q1hVOVZXWjRlR0xjRGZydnRWc1VIdHkvblNuM0xzU0ZIa2JId1JCYWRJeEFu?=
 =?utf-8?B?bnc0bE82VlQvM3YrZ3ZNak5kenpyamJEZ3daM3F4ZEdGQVZRMjRRYjZMMlJQ?=
 =?utf-8?B?RC90RUFnOHNFL21FSGp0OEkreVFRZlN2Q1BBSUtZT1QyTkhvdEJNQkNPQ1ph?=
 =?utf-8?B?eGVaYko1Qm9UanNYSUEwUHArVzdpMFFINE9MaU1hZDA2RHA0TG5TalV1L1NB?=
 =?utf-8?B?ZkdUM0V3TTQwWTZ4cE9ubjZkUzJVcjlPbjlxeU5wZDJ4R25DbC91dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308d0d8a-039e-4122-3915-08def7df2fc1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:48.7643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5nN2MeVe2nuwdBSYGAU59HLjckT9uoovWMNnzaW7hHmkIUL1N8k4HFrBX8mRXEx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

On Sun, 26 Jul 2026 12:29:20 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> Add new HCA capability bits:
> - mkc_order_read_after_write
> - mkc_order_write_after_write_ro_only
> 
> Add new mkey context field:
> - order_read_after_write (2-bit)
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
