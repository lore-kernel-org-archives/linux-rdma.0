Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E480435A385;
	Tue, 11 Aug 2026 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476718; cv=fail; b=UM9W8oVXxzjncOMPRgOnp22WbyppaMUSlg6WFt3b1IqQVTd8iXmFkHEbPq2onLys7/5dH1Kx9QYyqHuq00Maxf2jk4fpI1ebQhu7y/G2q+q50wZxe0tmn3Aqk0knFwr8pdoU2/rAikeJ+PIVzbcbqmU7tDacdgiMqhQckhf30nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476718; c=relaxed/simple;
	bh=KJznHsRKBJ4hM696/QIb7OliPNUyPdrz2Y/2njLGLuA=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=G6F4dW5IM4dYWHqVPAHwNzN0ZykD5/dGhwox8pO4sZwnmfs4S07KTlNzlpopgyfn2Uks4OD+YZpytK8+ARyqcCFr9LeaD44c0OXyDomscV+yUhldh6ZNpqNbojK/wDMag4C3xuQtulwz88egAVwT77xrTPBDEi4B69pg8gowkYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QRyQ7oiI; arc=fail smtp.client-ip=52.101.52.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QRyQ7oiI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=By+mWJkq5a4Ef0VLxNPQFLOwRdz9C5HDwV8w2VoJtI8EkE84pG66r6SKYcuj8n/Y6CB7yoEIFIgB12WE5LI66dvKO3cmbQI/FTMHlFfb/fJoy9SbjiTBmdZt6TGZQoIuLOrT24Jt2KJkafpfJKxhKMh/eETYAYFSiIid+5rLf35ru3v6IqOQgsYyQeOywUQ77HMw4ik3qvLmwVrDk/CEeq+db+7a6Coy8qJfl/AeaES1hIoMNufCPjQCwi1VxSC28E3kZheTO+R3sPUdtThVTJVAp4d7JZ4jSmrla5b+VpVbkH7dXGDve735UkKX4Cs5kxBacl45ziIcYNcmsCJuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXJwsYnIRz6Y9CEkDzXyOravAN2p0SbZb6xha1ITPNQ=;
 b=iMN/v+c5ut5vDLaFdseT1otdctzl1Y62p6niEuv+D12g6WDaH6PX+XWaXMgj8E0Xitmu6dTWjMiDGhDwMSUBySpfUBWmgBW1hjiext2ySWhPBFEIiMU6+8zx5wXNi+IJNUlZhgEPlecnK9pdtF+y35ahjKUGAB+rqlTeqY0xDbFSShhEdaYl+ARlOzfodqc1ZRkx4hDNqVHWBFgJfHkNE4DiKWBtrqcNrAIYoL9esb5BP/ITvj4PiOVzVCo5IC8uZdnB1E73a9KaveuEf564o6I6OM/W1jzxSmdlUxEH42aIS/noToQfeVUbDuisYi2wyMuVCLRrpscnkT7Gn4Jb3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXJwsYnIRz6Y9CEkDzXyOravAN2p0SbZb6xha1ITPNQ=;
 b=QRyQ7oiIqVwxjGFk4w4DIgdvmzw26TqW5zesJ+J71DF4+Dh2FT6OsXTDwglffgYkfzbD4NR8XTQkyh1oNQtRU8e8iypUq6mlOtw7A9Fkc4XGiVi8LkaCXbsh+VExsKfFCf/VOX7y5aYfFoVxio+LSZ1jYdFKRsCSyYryP6zJOoEj034StcsCu4Drp3Ehd3AejUXp4ev+R+FtqimhWKGTdmHpeiCj1IY5XxobXwGYayljTFKCDCjMieoKKIb116on++UC1jKnsvMhIkOyQTAkjxN/lCt2zfQjSxyXluhAcSwj21JB9HqQcnzpSFZOJHusPvXbw4SmPalEu1FnpesVlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:53 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 10/15] RDMA/mlx5: Enable relaxed ordering on
 ODP null mkey
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-11-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-11-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669516.282103.16065608402321991453.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH0PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:610:cc::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: e0965934-8ddc-4f20-bab4-08def7df300f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JM4kxq0NmKG4NDwcMcV1hzoALvyfVyclF0gCEF+jxh0Nw5oxv6rqVjKmqdOpTK4tFYXdY+nF+cJLnwzdqzN4zgewC0Zg5FyUTfbMXXGKslZVsWaWTtOGQSh0D155yPkMGEUbp1tM6rG95F+z+0pmvD//M+OYN9+V4MePuw7jKSKC8teLVvPuJaHMPExlVpf/0mSMFTzwCqYCVfo/SIpJ5c5uyvqa1q6x2wlxkYJ2D1UOoz7J6ujeSHph7Kv9/gRNrUuxKyvJW1MjB3yjFhJHjlTBSDHa7CLo9hHLhfMPgEAmF8zbjFYQdTYIDA4bxz3m0yHKusEIpTt63JQSuZrZK+UNDD4scxOgARC46WV6JOXgtcykfcpU+pfEiKLMZfUQGxZRyyDgcwUOZgmHnUVlZ9eDDpRr7N0aTUpZpVMmuqeknCYX1g8x7VUTQuOWwXVLmRZFehzNnJECQvY++LSX5F7m4x9jpH8BLzkFTuyc1trbolXVsiZE2NbzUy4NVgPtIl5g3++zCmSzrjzfFmP8mjkvksQzrLdozXClkx/hTSdIvXtDurgnGoi/ullYLoM3mo/LzWSHFUHVq7oSOzdV3IXM1U/F7YlmwOkjCaMwQGr2GhAmhbJakYHm40ucaoRprmH8SZ3KpJ1/NRPU3F3uwWE6XztfmCogdr9OnJyfA7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEdoa2N1Z01PSFIrcXFrVmdOblQ4VkJybzNXeG4vbDNRNzZOd1NkL3lPM2hl?=
 =?utf-8?B?K1BrU3JZbHJUMS9YQzlrVDBTRzZaMWtpa2Z3bE5TaExEQWJjRk92UloyZW5j?=
 =?utf-8?B?TlgxQjdjcGlEcXpNOHpBd1NDYzE0OUZNdTFaMnlHaWNhbXFVVThwS3Z6ZEN2?=
 =?utf-8?B?b0s3WUhZQ250M0xhTVVoUW5qbXYwZEc5ZHF4MnRGaWh4eXZUY2E5SHVHbDU4?=
 =?utf-8?B?SjBOU3F1dTd2Q04zYjRWek5DUFR3WWZjL3k4Z3U0bkhsRUxNRHdCOC9SVW9D?=
 =?utf-8?B?UGdIVWE4OEUvd3lpSnlCdG9DbnorODJsRklNUjg3aFBvMWVlVVAvRG0wWlFv?=
 =?utf-8?B?cE1NcW5sYzlKaDFTbVVFODh1T0JEdTBrTHBYY2o4a09EdGFiNU1YRW5TVHQ3?=
 =?utf-8?B?VlFsQnhNaGdna0R1ZEMrbnJYTXZFQU5nWlNDRFRHb1U2eUVQSUd4UTBaY3Rn?=
 =?utf-8?B?SXFzeCtqN0E1TFRpbW9SWlhrTTdaVTZkcXBTWFE2MU1iWW9KQ1pSbThrMSt1?=
 =?utf-8?B?ZVF0K1FDRjg0S1htY1ZBb3MwRURDQU5abHFQcjBialZpemZYU3JGQzdwTnJx?=
 =?utf-8?B?MUtPMitBWG1yMUt5VDNJTjE3ZFVaL01FSlg5bFlNQ0E1aHRnQUd0czZZYTVm?=
 =?utf-8?B?eWF0ci85MVlQNkxPc0ZCZUg3UWlVMlZmQkVKWUZYSHMzR2R0R1NVZHJZM0p5?=
 =?utf-8?B?cWl2UmlZeHBqcVJSOWZ4QllqcUt1cENHWWQ5eW0rc2FjRG1ZR3VZcUhRdUxH?=
 =?utf-8?B?Z09TQzJ0VEdNd29PbGptYjVKY013TnVTSU1hYlhxMVZwU1FneXB6V1JZM2o1?=
 =?utf-8?B?Z1RRaDFRYkhQZWw4SVJLa1AwYnpOYk1VZ05kWGVEREMxYWJIS3Z4c1pzVlZy?=
 =?utf-8?B?YnFWWkN4ajJmZGpySmZhOXlUM3p4b2hYTUs5M1o1SlczSjk1NEpySXdqeWJ4?=
 =?utf-8?B?ZEc5QWt1dStQRnZENkpLWWRsaDYrd0JwZlBMcnFRSS90UnVLNHh5TTBzeHpM?=
 =?utf-8?B?SmZmRWNlUzFVSERPeGVVcUNyZW5EUWhhM056R29CZFArTlY0bzhpS1pJckNu?=
 =?utf-8?B?N1lXK0FRdWtIRE53TFdoNWRlVUpFUVVYU0tldS8zR01ydFhKNEVzRklETUta?=
 =?utf-8?B?QUJHYTNSK2Vlck1OWHNNSkl5Z0Zlc1ExYU4veXpQdDdzbzBoZWhsZXkrandz?=
 =?utf-8?B?eERneTNJYXFVR3NoUUcwYmVyQ3hRN3prZzJadDhFc3FZcm1kYWkyTW5HaTRI?=
 =?utf-8?B?bTNSL0NJYTIyRldSMTdpRjc3ZW1hV3ZUQWE5c1YrZ0h6ZTd0SVJiMWFpRTBn?=
 =?utf-8?B?SEVFY2NmM3JNNjl1Rlg4NHdNRVRpOXk3SzlkOTFNN3U3RmlIYkw3NXhDT3RV?=
 =?utf-8?B?bVg0MzN6cFZXUzVFREZxamt4TW0xMldVSmsreUtTVUwrZnBHd1Bwdlh2YkNR?=
 =?utf-8?B?S2VxRThQUXFIVHdvdFdSYnFVMjIwVVh2UDQzY1VvWUd6akg3SXFNQTBuUzJn?=
 =?utf-8?B?anMzZ2NCTGhpQkJ0SXBMeFBydnpmS1pkVnhFSVVRZlZNVWk3NnJhK1VhQUJZ?=
 =?utf-8?B?UEp2VStpaTRtUXRVcHNBM2h4d1IzUkdNMXRxZWtyTlg1NFY4dXRuOFpqZkNi?=
 =?utf-8?B?Ny85NVRnVElIUGtlZEFLaVhyaGVpK01KSTRDOFNEMkh2ZnN5Q3VwaEQrUmlK?=
 =?utf-8?B?RXZqQUt6UnNiMDI0UGR2S0pUUjNhZ3NMRHFMR3Rwa3RvVHlyZ3NRU3Jsblpz?=
 =?utf-8?B?ekptdkpWYlFwSStTVll1ZEJnNThPT2pPUnlIVWpLYUpXc0tzV1JyVWtta0RO?=
 =?utf-8?B?UVc1VnRQVHBldUJUcTNXQXFxUURJNXMvbHRQQ0lJdlNxUHh1ZTJONG5RUk5v?=
 =?utf-8?B?ejNHREZldEFRK0NVNjMvUzNKMy8wTE9sQmRUUjRQZWhleDdoempMdVpGVmdF?=
 =?utf-8?B?SFBkaHdUTUhDSkpFTFpucEVYNGludENDd0JCUkd1allBTXZRWmJNQ2tNNno5?=
 =?utf-8?B?Wmxpem8wV211OXN1QVNORVBsdU02cUY3ZmtYK2NFcFlBZFNYUXlRZVIxZmNS?=
 =?utf-8?B?TjR5Qld1SHlZOU5nSytDNWMyQzc4YlhtYmRmandxWG5UcFQweWo3MkV2RkRl?=
 =?utf-8?B?SXdzT0N4a3dDNTN0eEZ1VGkvYTFoSUtNTUc5OXFUNFhGbHBkLzNLVEdYdDZh?=
 =?utf-8?B?NUFTQ3RWNXNMbDhUSHZDYnVhQkhwd1UwNmFHbjRYUHJmaWdUM3puV3JEWWRJ?=
 =?utf-8?B?dkxpak5OaTRMMzBUV0dxRnlXYlpGRnRjTFM5Mzg5NEVidXVSamxzNmQvVXBz?=
 =?utf-8?B?aWxpWkhyWWZKK3NIZHltR1hDQnFtdnhQZ2QwSG1xcm1yakZDT2NoUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0965934-8ddc-4f20-bab4-08def7df300f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:49.2169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5jDk6lE/NALLa2vlMkkCrBu+5+MhJ7cL27uSZ6l2/nOhiEOh50ayYLVsmCadwrD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

On Sun, 26 Jul 2026 12:29:24 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> Enable relaxed ordering on the ODP implicit-MR null mkey.
> This allows supporting implicit ODP on HW that restricts memory
> registration with strict ordering.
> 
> No functional change as this is a null mkey with no memory mappings.
> 
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
