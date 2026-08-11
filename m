Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8004766BC;
	Tue, 11 Aug 2026 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476732; cv=fail; b=jOWcbGH3fLwSwAjGIZ77Fm2YfzeenrvrbTUXHpaT9OcUHVjFVPo+0/2ZyyvOfupMlwz895fuBiBWskiAvtS2DXffinbWiiio76nFnNwJ5+/3fIDuKwFY/1K2AM8k7C+WnmRCyL+ypcFZ5apMRas3FH8hPy8LhU83U2h4QjYLdeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476732; c=relaxed/simple;
	bh=jUXrBFXboJI21LJnIVXtRhJHJyQSL9TqxdWmlISjh5E=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=hbIAhbVKNkyTz4VGCpxmn+rrGXcMATcXyTHnhA0u5kjn40Ns5Gw48RNogcX8OgClujRAy7qlQA1biwIREWqldqAfrpgzFBZUkp5+TGspxpbYkhPsZ6g2OWZiOAGRCgStAQkwAMLBwlPU+fM1iQy50DstADqk2/CQtgIg1cfvIJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i2AkFet8; arc=fail smtp.client-ip=40.107.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i2AkFet8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VPUSkXzfO0fwZSyahaouqm7T7giWgrivYreSdXdSCqxsblII97YXvDCM7G3VQiB1O0ZrJO/C5GaelhMy6uGMO7Q4ChES2HxvE+Xs0DsZjSbauI+DkHGSzqVF8XBxCRLjUzaAqK1yb+jxdDab/Wvsm6UsOx7rj2Af4Z4eh6dBhejfFiptcengkF3dbS7HWvWNGRLKF4jewN28O3/rxAlX2ZZX7o9Wz2HpqtHP4W4igVbnpLAAffkDthY+Oo3Jzeudma4rBzXN7SDPoSXq8DSxZ1yCiqmGzT3uNivzNDkAV+hlpoaTHOXcIlaHXSCxc7wq9jeneS52TU3LN8oSZXLdkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjUCxWyOzXsrFaKgNecwCo5AySABXAziQJ3SOrajssc=;
 b=ErVYHJ7WJaWwHYESakec9P0vL3L/2Hn3AzJGUMJRcCnmRL/oH3nlSBQAIRZ5mo08srSUPNUfO15LwhxlWPr9wz+Nu4yFKaPiYC0P3Vjh9cPuTRouIVyixaW2GEf3iFOSuJT6c4htdBL7weU0OTP0o1i3sriFQoIkgmjTMM4uTNGeo61JwVytIpzFK3U35vjSc27i69Ymp3ydrhUh8EzLhUmYNrqu4UpOEgBGFWse1Dn/sAlHGTNMhfs3hnC+Q1avrKYWvKbNS/viZUlhyJQ/SJ4ukL7HHePUUj4ymjj/IZ7RWX5A0bfTjdjDomje4r7IDiVeG9tox3w2TdelwsAiIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjUCxWyOzXsrFaKgNecwCo5AySABXAziQJ3SOrajssc=;
 b=i2AkFet8W/zi7H83uD+IwY1EbEcGQM/u6O6NzZduIaz+oRtJT2NWeM+Yu/GUNtCxpIy2XiEJnBO5YAV8F/1S0j06xdLfXyuGY4q6JKrrZHVB/6F9t59DOgyRuh1L6fAFzocyT7ZxT/FQYNOnLPbEUlVA3eDHML0KudXasN73ipv2VPUVmK/QQW37pRKpiP7H3/nNwumJnW647RJXrQratbJxPwMb1Pq8XLDq/GrXf86i+CEKde+rF9QDi8cUTPkrtwCyxNNZ3Eh4scXNs7+vV8XwlA0nJjgavSs9snsvgZlpBT1/n62mk4FuOK+GxhXxqAExhZjQ+VpkIVCBFs7pHw==
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
Subject: Re: [PATCH rdma-next 04/15] RDMA/core: Allow optional access flags
 in reg mr ioctl
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, stable@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-5-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-5-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669511.282103.17351232605322822383.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: d4dbe4b2-1b5f-4e02-4d6c-08def7df3362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	PK//jgsnqvn1gcE/McQ1PpUnHgAavEoQWe7kX8MjejfrYp4RPjRfFaLo4xie1M54DgrmBlC9lcqVjEpgBdWDwWuMdkeVEtx8H5RAbCq1eyUxkJZDQTA/i3AP6HkYDNTB1XX0H7+NPi7QvarfBxtharryiNJLNi5aTOQ3Pkb9rtEgd1S6eUY6/e1tY8VPPdtsSmaDni88cDohS7i6DD5kDbVO8QmfRcoX2Sesp5jAgBSBGKHdOxGitTKpvu+choA2HuxUiCfEZWC1wpNDm7e7OtPk0xFgqFE0QJ/xMreCbgBeb+EpdgwSoPI7mKUhX0JsuEDLNNBf9LeEnS/PPtkMKSEWHW+kRWmfsg8Jx5+puuaosQQGBBcppcaQsNG3nQAX43b2zDtL7N9gauuhSgQCpODYB2vXFhIZruiqYfDl4lzVVFHo/yIQsseIpGpzdx6rPof4+6ZFgHlLgBYZlbzPUpSK5WRU2mBwXbUnpg5v2OJ+9vL5CqwPv0eLMbEXXVQQCqpJygfD4zYWdjaI1MuH+vGbHNARlg4DIhOTSQRNVts8V4fBEKRrySJzbKA04Vc3RQcmN7YHWBSR5NLHV+PspMFX0DlmaEspEssn6SvoZzzxpsUvM+Hkbdhowo95jFD1QeK2GXyE/HyAe4ZRRomhykyhg4mhIJ64onoP0dJEFrA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3FDa3ZpbzdCZHk3NjlTRFVvZGQvWnZuZC9SSExJcTVBbmhVS2RieTZRcG85?=
 =?utf-8?B?UkhXWDB0QXN1Y3hEM3ZHc05KT0w5K3F1VmhyTWVNUURrM1VSQUJ5MlRPRUZm?=
 =?utf-8?B?NlNtUXpramhTV3JXN0RqSDUvdXplNU1nU01jK0NIcDlUWjlVQ3c1T2MvcVVQ?=
 =?utf-8?B?Vk01WS9mL2JZQ2tRNGhGdWt3dXZxdHlaU0E1K2pTaG1aN3d3ODE4SlA1VlZC?=
 =?utf-8?B?cEpRY2J4anFHcWc1Rlpzcjc5WXAyMlZpT3ZZOEo5TEw3Rnh1T2k3SGNuRU1R?=
 =?utf-8?B?N0RsUTZBVHBGaWNORjRSOWwveVNSbWpWQjBzQi9pUFlsQ1NnYmR2Ykx2ZHM0?=
 =?utf-8?B?NU1sNFZldTIzMSs0bUZJVnVyOEVsb2JRSXZCM1dnVFZIRXU3WXQwRlB4L3VU?=
 =?utf-8?B?U1pqTXlaZEo0WGt5R1pTVGtVRTJVUmxMa3YzOW91YXhEQk11cHAyQ2dCMVVI?=
 =?utf-8?B?aGc3dTlkN3Noc2I3L2FWeE5LSnMzVFZPUlJ6WERFSFdPWEhLYTRVVW9DdXBB?=
 =?utf-8?B?akswWStWeFU2TkRPN3NKZWZvUXZwc0RWNlpkU215Z3JwMDFWSXRDMDFRUm01?=
 =?utf-8?B?RWpRbkwwWW83djdWYUVkQUdzWkowRjI3SGpFcm9IdTQ3UnlnalNwVmhVYW1K?=
 =?utf-8?B?NHVEanF4V0diTUpyOU1TK29SZ2dhUWE2dzdTMXhBeUZFYStIRHJLNFpZVlZk?=
 =?utf-8?B?RGxUWEpzeFBFTUV3MVJjMjA2Wlg2TThRM3pTall3YTBtSUY3Mlg4WjYrK2E4?=
 =?utf-8?B?MndZd3B5WWFpRHNxdXRBRGJYeWVFelFQcENPdU5NMW9NQWN0Z1dVUWVQT3U2?=
 =?utf-8?B?SlR5OEpuRmJ2SHgwZ0NUMmJBV0pzYVQzQUIvTzlKdk15b1BzWDRXQytvc0Mw?=
 =?utf-8?B?ZURMYUJaZnVFYTc4NEpkMmFKbEthcnN4dlVoRlh4QUVqRjlVTjVGR3dBZUFM?=
 =?utf-8?B?VFY2NzhGN0gvRVdzNFkzVk14MGZCa1VwRDVtamFpdXpNRVRXU09IdHlzU1dt?=
 =?utf-8?B?RTZMVmZwczcrbG4zT3lBOXRBNjY0V1ZqRFA1Mnc4MGhWb09kWDc5U3Bnaml4?=
 =?utf-8?B?ZkdGL0ovU3RzNjhzdERhVFR6UFFKaFh6LzgyS2ZLcG1yK0RqdXZyZ1I3SVZG?=
 =?utf-8?B?N1h0S1cwRFNVWjVtbm1acGpPM082SHpuUHhoakUzU1BBMEdzOFo2aXRxYXZT?=
 =?utf-8?B?U00xTlRqWVI5NFhnSXd2UU1ZZDFSNERNSExCd3h5OThmWUs5ZVd0RlJNNHRM?=
 =?utf-8?B?N1RzSStWY2tMY0lieVJLTjVJRURySTVhSFNXVkVkMU9EQ1pxaG9UQnVQUmtI?=
 =?utf-8?B?VXlyUEVjOEFWSC9rNHA5OGFSOXZNdlNkb2t5d1c1dm1mWU1lazNoNURrbkpM?=
 =?utf-8?B?Y3lDWEh1Uy9EazRsSjd5aGViUVVhRytyNERSTS9RRW52WXgwY21yOU41OFE2?=
 =?utf-8?B?cWVhV3pVKytrZnI1d0NNTUJVSDJIZ2lnSjR6WlQ3ZC9HTjZQankvdDR5RW9y?=
 =?utf-8?B?OXhnUzQxOTRIaTB2Um9QNkpXS1ArUUZxK0Izb2FIR0tCVE5rcWp0VStnSCtS?=
 =?utf-8?B?bVVxakdYUUcwT1pIUjBuQ1ZsOW55cThnU005clFIaUtsWnRKeG82c2xrYzhM?=
 =?utf-8?B?ZTB4anZSaTJMNDBYcldkY2hVQUNQTE82OFlHVWxhcFNHZS90bTNQUE9VOWhZ?=
 =?utf-8?B?anNaejF3aitid0pUenlEem1EWUIvRTVYdk0zSlQrSlpZSEhvcVprZVFhNjVp?=
 =?utf-8?B?UFB3U0V3WHRDWXV5SHhQa2p2QnNBOWJXVE5Nc1RCQTFlaEpUajZ4cTRGMDM2?=
 =?utf-8?B?T21DM1pQdTdUbzBMRmtZSVhBVVowY0liTlR1cnRKcEZiakFBUDkweDF6RVh1?=
 =?utf-8?B?TnQ1Zldla2Nsd1VXdXNONzI3aXBCZXo2bFdFK2I2K2IyZUQ0M0pPQjdiZXp6?=
 =?utf-8?B?eHhoalFXS2FaUzdUMjNTbEhoRTFqZHFZUUlpVnZoWFFjOUNtd2p6a1lsY2lu?=
 =?utf-8?B?Sjc3N3FZaHBjTm4yalhPTmxGaWZVZmx6VW9PdmloMitQZlZsUUpTenRWN3dL?=
 =?utf-8?B?eWZoSkpCUGgzWU9IS2pmNFdoVlZxTXIvVXFGUkppTytDQnZJNVZSWitOYTd5?=
 =?utf-8?B?T1IzcnFheHNIdWdqL0tqMG16Q2JTZVRVNnlVdkwyTE9hc1ovN3BJR05MQWV5?=
 =?utf-8?B?WklncnJQcVVmRVB6eG53QnhIelFQVDh0OGxiV2pCaGhWZ0UzZ2RQQ2cyV3la?=
 =?utf-8?B?NjNXby9JNGhYTElFZTZJZTRwU21aUHExODVrZG1qMElRbEUxYjhXQ0ltRVdx?=
 =?utf-8?B?a05KZHdYbnh2TmhqS3RKY21VS0c0STZ1cW5sY1dpdnpVSndtMHZldz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4dbe4b2-1b5f-4e02-4d6c-08def7df3362
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:54.7690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zx0CaE5ZTebIF7RA0SDG+ROuXpDN+MckhnKPg/lNukfCN6ikxqlbF0+jqGY2qwl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669

On Sun, 26 Jul 2026 12:29:18 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> The uverbs ABI reserves the optional access flags range as best-effort:
> drivers should accept any flag in this range and treat the actual support
> as opportunistic, never failing registration when an optional flag is
> requested.
> 
> Add the optional access flag to the allow-list of dmabuf registration
> through the reg_mr ioctl. Uverbs users can now request any optional access
> flag on dmabuf registrations and mlx5 will apply the flag's effect on a
> best-effort basis when supported.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
