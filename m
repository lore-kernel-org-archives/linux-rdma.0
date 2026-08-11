Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09D447DD5C;
	Tue, 11 Aug 2026 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476743; cv=fail; b=PTQ8Np6UhHUOBokBPuXDs1A2QsSkLFcLjj6edKk7zzgUGFOpzKk7kiPp47Sig1OOi8ueubix78AC9hg5R5MyOSt+jBU4GXTEHD29WQ2cx1g9zaqFOxAbZoC9od+nRkfCPb3OB9IHDracXOKFIeTT9oXNllO7CHoFCrZWUQq8unI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476743; c=relaxed/simple;
	bh=HLYV42XPYQa4e5YjwOfSkP7GhCWnNGUnRzDvjPNdXJs=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=YOt1vBT0NA2NVxXXEVbr34UuGxpXv8q6fj8lo8mgpXJi7Lr5qVI4+0QY6t1BJGHEqvWsI18Uwo+WwZPDvfFd8zZDsIGl2vyNSyPeN5WYvQK2nLv/7y7Arm15ecxmiKDIt8T2Ve0RwlEi7EetNd9K5kBw+ypjbXXvvhSHEUSyENo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BATzXWJb; arc=fail smtp.client-ip=40.93.194.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BATzXWJb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4oBit4kCwDWpZwaDgekgsOBTrDZvZHijEGVdx3n75FbRZI73Mr1R3jHY6HxNrLMj27zX/fIXZOITYGTsCG77PSxlHkDY6jd2ClpUKKS3MtLKbILPsiayWEOYDVcbJD8L4VSTkh1jPPVeDAG37XuCUERvhXmINFQxrrSvK83oEzzjY4uiedvnpsVBgLGeqlDr0+KbdqWH/XBNn/pH5SV8nJlKG7CzIp+khL9/1BzD/+RpM2WZLMhvMkuErUeaqRj+gXAs8NzZjIqm1Eo9ie5hIlcSzFmNGhGm2cCLf5P8+o+i3WUdUGGX3PtZPwlRkIF5ssyNNkI4WlSz0dRwj/6Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmYFMZU7outDaWLhTzXHwJtqpogf9ozIs/WWDmgPFOY=;
 b=x2ROVyoQAH9CrlC6eTuq7uuGMoHA2jEyUglq1Fy5bzk4BLfHvuRxIs/fCJAqPHy/mx2Z11PJjrSrd4+X19hJIiYu8TUliLt4FGDDUHvGCcgBEJ40YrcQ15GAkWfXhVtDA0eajyMFo8nyHNEOqIc1GNVkIu88JztieoNtvESE06bBz8kmzrSPih5RPpFMLthwoQo8a2wDpDU4y8RpOt/MSjM5oslULdKVDwklNgWPxjn9dzlPkPD6/i9pWLDvznrOoX3InEoH7KOTPDsz5T/KY0rWPsNr65koOiSXLso42Mccik12Q0bCAwklKzLDoqQ66cyatH6/AAPPFtMr7U+6ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmYFMZU7outDaWLhTzXHwJtqpogf9ozIs/WWDmgPFOY=;
 b=BATzXWJb+nOXq1sTYzgcmb9VxmUfTG00PiydL6zPEoe816VzrGYgJwurFccMyQjZ+xGetMy9kY6sNhh6ftOHXC+yf096auVR3aUug8ril7DxTorgusVJ/FM5z6u9lDLulJZhGVt+S1lIL7eKcaO41xvFkfcuOuTncdAYorAt2T6J2xU7e9eisdkcUtUSvN5ItFcSImYOIaKyBtgW7HOKOEAJpfmELzlUn7qAkWLEwgSMs6Kg7V4qDq03QctOEdvt+erN1sgVcYVPhTpjJvNZGVZu9njWR+O20sXt0GtlBBQ5I+cxXPIyzXOxj5w+BdUcTWWlAGd0+IKxTYTShSDCvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 07/15] mlx5: Move RO setting helper to core
 and consolidate mlx5 consumers
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-8-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-8-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669513.282103.13491081227072066344.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH0PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:610:cc::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b9011c5-949d-48ce-af98-08def7df2fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|5023799004|11063799006|56012099006|10067099003|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qO5nEs9K10iQZtUsyZunCr/h52lhb5Gzd6E+JLDnU3xWc4VTV5aSgqKxaE/2qsQtKouFCdq69a+64S/lPFL4f6JF6F9cia+cYBZJOVgo+aogvGBu/CFGFHOXAUZHL11ifIYttQL7WXZtN6QWvVD9aMRV4DVcP2QPg4YO0VeXMfRGDnKo3qHpgE8xYF/PDN1tUHXqbtCL+z/K1PSq25A4XwF4FlcBIonr5Z1kau7QCj9+i80PibquopLw2Rm2eXSaTKH5Z3Qn+XrzgxMXbnbkb11a64HKxmxpAI9gd1DcxJ9LvaD3Jxd8LS9x6aKMtA0T0cvdg7/7MS90aEFnZ3qkU3MF7ug3ZJFS6ZU8quPb9kxk4F3qmtVsjwxewQEk+edAUtjeVH/pshuR5GXvx1D4MfZggNH0nCbLZ0cG/VRyF/5uQVUmYoctbJoneCSxq83eAAfInEKuEK9Vy809exRZg3G9/uis4BKCg71Vk3fIcRdLx3MWWMSeWBzqWQSKDG9PyozM/+kUSfyj9u2/IBlQeTMi8dmm4p8qcL4kPwhJyKGiX1PcOfjveGOR9ja8y4y3H0IOeUNeRqYhXNGzfwtNnMs1xX07XwA1kQ0z/5AxHAkMb6g4+2M7G2T75jP9H3gbSlT8/6yGFodhZ8DbZXfVxkyTXIzRXGbvq8rxU2pqd58=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(5023799004)(11063799006)(56012099006)(10067099003)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlZDMWM1RzhKSkh5S01FdkxLNjRIcGVPQm1GNXFqdnFqazUrRGlETWxUYnVo?=
 =?utf-8?B?SkNkWmFlUThtbnFheE5BRHBrVDQyTlhOTnJTck5ic3ZndjVSQXFRNWl3cHVK?=
 =?utf-8?B?ZTlkTDdScEhsTnd3VXdVNzVySC9XNURLSkZxZW1QU2Y1V0k2SExwWUNxVWJr?=
 =?utf-8?B?OWZ1eWcxcEsvUXJJV0ExZ0Y3eWpLdlJJZ0U0V2xzV1Zoc0RjeExGckVCK09C?=
 =?utf-8?B?NmJWSHp6R2VCRytLUCtvaEhHZ1NNZGFDRm1ITTlZaFlCODIxcytQY2lVbllV?=
 =?utf-8?B?c2FhUjErbHYxekRzLy9qRUM1Nk9vTDJ2R1g4aDhNaXdUY3pVeUlRd2JvTHBi?=
 =?utf-8?B?dlIrckMvNTM2amZCaUFQbmNwMmg0cXJUbnUwMUVoOGpqRXpacHpQbWZISHlS?=
 =?utf-8?B?eGVITUJ5UitiV0FOKzVFMnlDTFZzZ1dhS1hsZ3loZkgrbFVwMmxCZmU3QllM?=
 =?utf-8?B?ZWJEZkFFM1lPU21sOFBpSnNQV21oVXVxRTZvcmFLTXhxam1Xek04dzhaUDZK?=
 =?utf-8?B?V0I3eUltdU5aR2JJRHhDL2JrNjJyQTY2aTV1VzVYTDJOMWs5OFN1SDdBUlR4?=
 =?utf-8?B?YnFWY1ZHZTJoZkZZOWhLTyt3ZGRxaE13ZjBNU0xlL2VNUFJNbVkvNndtOUo2?=
 =?utf-8?B?RmJEa1luTEdYSWxxSkdJNEZUT2gxWU9sWWZXN0tUT1hlOWp1TXJBeVFEc1V1?=
 =?utf-8?B?V2JOTTA2d2JKVTFnaTYzcTFxWmxWbGNIdGVra3dBUTBkZmFhb3QrZitwR1p4?=
 =?utf-8?B?YUFsN240eDM1NjhBS210dytkYTBVR25UMVVkMEdwQjZkYTNZblAyeXNtV3Vs?=
 =?utf-8?B?d1FYVTVzdzlUTlBYMnVSNHE4K0lqUERyK2FkTU1SRlhwdHhmM2FlNjRZU3Jy?=
 =?utf-8?B?WWk5cW1UMFQ2MUYrYlJYSXcxMWp3enJ4c2U2Rk4wWjRSZUhjNmNpa1dOVEJS?=
 =?utf-8?B?SzhPSHpQcDBuOHRwUXlHQ0IyYXVDblpjbVBudkc1TVdkcGtMTVJNdndxVFpF?=
 =?utf-8?B?N0hEcThlYXZObTd5VDhWNExBVHdnbU1HNVhUUElXMWJleXQ0SXBQNHIyOTBN?=
 =?utf-8?B?Y3oweEFyWWhxWHR5ZnpzcXFhZ2NjdGRKZ28yL2ZiaW9Xc1VwZEMzcy9GeVp2?=
 =?utf-8?B?SjU3Nzd6YmhqYzl5UXlmWE1GQjhrV2JjYmFrZGJnZXUrWG05ZjVlWHZHZjB0?=
 =?utf-8?B?aDNvbWRaK1JyRU9UNUFrZk5CNE5zTVhlRFIxaktzOFlicnVLY0xiOEtqM05M?=
 =?utf-8?B?UzZEYXhtOFJvdFhZcENsYTRTTFVYYUVobGE1UXVNMUdtN2M1eWhsdzVkYTJp?=
 =?utf-8?B?QmR0c2U1K3htN3hBeURyNUhFRnJzUXlsSTJ3OW9HNlllRzFhRDJvNTFERGdw?=
 =?utf-8?B?TFlibEw5MFJhVVIzak5JOXd0alFwd1lnYnU1eG5Qd1NjMUxDRFA2MGNhRTlu?=
 =?utf-8?B?TjlVbVExMmprelpod2tBdk9kUjRjQjN3VkRLYk4xbS9CN0ZnL2xGZGJwLzd2?=
 =?utf-8?B?Ny9EemhSb1B0aGNGTGtveDQ3dGlrYWRSMjAzdS9ONXJHYUw4cEpVYURXc2VP?=
 =?utf-8?B?QW9GMFNiNWt2UjQ0U2J3anBhQThmZHo5a25qVXJMTUpobDg3RkEra1hPU0tZ?=
 =?utf-8?B?V0FaOXJjUlMwOVUyb3ByZEVITXkveXNTOFBPMWlXSjRINFRoMWRXRjJYM3RD?=
 =?utf-8?B?REFDTTZncFlqQWs1a3pSL29jcEZyR1ppa3c3K0M2S3VBV1orakQ1SzNZUGIv?=
 =?utf-8?B?Y1o0M0xaczdsbEZlRy9Pb0hLcmNmZHNQWVF6MnZ6MGl0WlA4MkxFNHZGSWFK?=
 =?utf-8?B?Q01OMjhWNXVFaytxOGtXS1hyQktQak9CeUxyMzdXU2dWOTBGMDl4d3lKNDRE?=
 =?utf-8?B?a0ZoSUk5ZjllUGc2NGlOTkN3RmtnQWZSemJ6Y2g1eE95dFZ4ZzFYNmYxZ29L?=
 =?utf-8?B?TmVkNzgyOFZpUitXUW1ER3FTQ0FFNEJWWlpaSG4waXN3a1dCVStLemRoUlZt?=
 =?utf-8?B?bjlocTdjRVk4dWY4eWdlZzJXamJVMFlUeDhabS82K1RvR3NZT0FzYUpQYW1l?=
 =?utf-8?B?Yk10NTExbzFqbnlNS1lnbmVidjBROG1kR1h4bzFBczNid2JaR2JIdys2cDNj?=
 =?utf-8?B?Vnk3cVZIeUlacmVFV1pkcjhtTGVxQ3ZzZXN0TmtDSGdWVDM4RldsVU5qS2hk?=
 =?utf-8?B?NCtpSk04M0l1SE8zazdTdUdDckJNOWV6ZG5adDNoQUZDQ1hYcXNTQ1lQelBk?=
 =?utf-8?B?ZElHZlNLZkI3aXNvNlREYU14ZStKcGlJK1QwYjRGRFQ1MndyNkozS1RYMGVo?=
 =?utf-8?B?ZEZJa2Q5S2Ywc2pWN0taMTZsTERGOVhDZ2xPRmxHV3pJeTRpdnFOQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9011c5-949d-48ce-af98-08def7df2fb0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:48.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtqaTefj5hWOsgdEIGGF7G83GE/vQ9RhLg7at1pEr/9EQByNunrhdblGVeBf9Q3w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

> Move mlx5e_mkey_set_relaxed_ordering() from en_common.c to core/mr.c
> as mlx5_core_mkey_set_relaxed_ordering() and export it. The helper
> centralizes the cap gating for order_write_after_write and
> pci_relaxed_ordered_read so each consumer no longer has to open-code
> the same dance.
> 
> Switch the static MR creation path (set_mkc_access_pd_addr_fields)
> and the UMR access-modify path (mlx5r_umr_set_access_flags) over to
> the new helper. Both call it inside the IB_ACCESS_RELAXED_ORDERING
> gate, preserving their existing conditional semantics: RO bits are
> only written when the caller actually requested RO. The Ethernet
> path already uses the helper unconditionally on every internal mkey
> it creates.
> 
> Consolidating onto the helper has two benefits beyond the
> deduplication itself:
>   * pcie_relaxed_ordering_enabled() is now invoked only when the
>     caller requests RO, avoiding pci_lock contention on every MR
>     registration.

This is wrong anyhow, we shouldn't be checking PCI state in these methods,
the same we don't check PCI ATS state or anything else.

If the FW supports the MKC bit it should accept it in the MKC and it is
entirely fine if the FW decides to ignore it.

But at least as much as a code movement goes this looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
