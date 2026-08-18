Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF9E37A485
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 14:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062239; cv=fail; b=B9UFBSLevT0Nn7WQ2QBlooiU6daQG8Aq5IEWpICIjeIZ/LPydzltoVN6WcH01y5uBMb+JqsnDNot+U7v4chJBV+wRaUxkpvHWXmQoUUdISKKq3FKeQjhfJLteeiIt5D1GMj0H7pPxnAu0k8cC9Y5Y9kIQHIb2vQMkSruVmnZwvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062239; c=relaxed/simple;
	bh=Fp7J/9NRAIkGEKakU+4LdmxFfLpmjkhATN/D13Vj/Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e86KeQGBJdjPnQ/MXIWe2uYUT0E/5uBRuc3NrEUp/+lK5K9sBccYgyIqoQHJDEDj6s6Rz1K1OsirBd9m3g+RGsMoj2uTL6dByV1n6kOXBGle71BYy26jTyWJ1A3hoWj4gM+wQrkkA0kV3OQEl4iFKMHoqmJH7pLpG5Xitvkf9Iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CjIRRaHa; arc=fail smtp.client-ip=40.93.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CjIRRaHa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAZ5q/xCI9MNZZeCXMrKXJUy4njzbccWO6j5P7l/MgLzcWzlN7YMQe4e98nchJy4dxcPRoW7cgbPMOo8+nJzI+kxLq4SM4SR7tLeg/57rWpDoHgnIHyV+6LopYKQs9YzJR6b3EFm3VFGF5CBf5/upORxWtsClHmnlBSTSIQZFlI0n2cl9OkxF0IxgPAtNdxCxcEv8FUA5wzz7dv4AB9yurbpyKXrLThCKauD+VFhdx2fFFnPSrUfvALXIzKCkvniWHPc8TJrqwDGJhPHtFVZuqJ1q4fRtQtP4NewKLTnAGLnOMt0AGE+ILrWXVFmnyVibM7rrHxhHkWgs1vmTGbpxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eorTGoCMYi/do2o1ZWXDHynW8VZvPot3i1uwYDZ8l4w=;
 b=A7C9LeF9WQJ4Fk/+ag/MVm/WkJoPjiJ/7Fpbkwhdn8T26g5S5pxAwLpvCkz6F1makbZxV0HWMWC24UUQ7HVVF0GyKfk75+ksNXmWQWlv9FqITBM1IuejajM8vr8m0jE8w/595Qutr6QfSa4Y9CDeYedZa7NldJeRak5EYbzjfYCRqSZZ8IGv6aD+L7cewn2iyUKvj9HuCrRNPTU3hfbLRRitCJ56MB9VHM5xvdnmsLWgYfIMnKvYNk8+WGR9XJ8KQDMH3sVqJMxWd9hW1BwvvQMLvGCs6wqoxmb4XurbIZYCU6ktS/EHJwv49JHBM5bDU5PpuQ+ATz/m+5tnzZPFOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eorTGoCMYi/do2o1ZWXDHynW8VZvPot3i1uwYDZ8l4w=;
 b=CjIRRaHaq2dDWQzXzWK0Jy9CTTDQJ9+ZKIgua8esAB4odKD4eh8vKFyQlSTV7kkQ5iyoCEiLi3Hb5EPdfXJoiKy6gkCBqqZ1PtWao9QpqfwPrfn9FZ1NWjK53fx67wuIIdd1OQQAKk+BtoFSwlp0HYVvBcUymadaSt8be7Ob+niyfwH7WJAKDc8pkbnZftkA6nFPA0nTe0HPSDy06tenglR7aIQ0V8W60kb35ghX22a17g+dRV4yitaFwlsYA5ISe4v21StA1+3caBXtmmxKBEMN+VkkANdOTExTgKJ5/48AoxDlgzbnBRGgYZiaeZopssnxUv/7OTbpgCa5OBlG4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9575.namprd12.prod.outlook.com (2603:10b6:610:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 14:10:33 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 14:10:33 +0000
Date: Tue, 18 Aug 2026 11:10:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: =?utf-8?B?5r2Y54Wc5p2t?= <242270054@hdu.edu.cn>
Cc: linux-rdma@vger.kernel.org, leonro@nvidia.com,
	bryan-bt.tan@broadcom.com, vishnu.dasa@broadcom.com, w@1wt.eu
Subject: Re: 0001-RDMA-uverbs-method-elm-fix
Message-ID: <20260818141032.GD5432@nvidia.com>
References: <AOYAQgCQK3IXqJLr1TB5Qao9.1.1787036796115.Hmail.242270054@hdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AOYAQgCQK3IXqJLr1TB5Qao9.1.1787036796115.Hmail.242270054@hdu.edu.cn>
X-ClientProxiedBy: BN9PR03CA0471.namprd03.prod.outlook.com
 (2603:10b6:408:139::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9575:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ce799d-058b-467a-8d6c-08defd3277df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XmX21RpT88LRpAEaH7V+KQpHPa9CY2mUuQAbPQhX4jTQ4S03ou+CXfZXmEpStIoCs3+/f5rYH8lLNzB+E/LpzHHcfPh3+Abco1hpERSaQrr4EHqp3opgr33PR8W2AhQgJp5hI/lr1yvmPthwH36bhBuIRbFqIr0cOFz2ZDoweDdPQi3NX9O5csw5dqxleE1KOfy0vd5PNarUtfT+86lpebI4+QpPuI5ZgRb2Kkwr67czREFoWnqI2cXvAEFs7ktyP0fVeP7tnJQOR7HeSXm/7hAozqEObMdLzyFrUuzU3XUZAdhw5RS3aA7K3/Zi7XnYaqsSDE8a4Lgc0O2X7Pa5/bVBmHYGo+0u60/mbSc683TJFrAgIa4B49XqOubthOMTZpm5kZYxn1Gz5Zv9aU7i7A6L2yYE19Jwczt+dp9j+um7eWKiByFPOXk5007p+RMUVkBzlT7508C72LrMxFgbjKRe1+2nR+QqKrggBkBnFJyCl8XjGYFISHJ05Dxu1LT+5FTLYEwJzNXVE4OfbDZG0xdJFUarGxVXstXa5qEBlVfMflkodzA1IwYLFtQbCPiybSUwK48AmcD3VaxeMOjvwCcajOF4oYIf0n1ovUDFPai3p0u3JBbxoWxttxUJv418ykEHQr8aiaTHcZJLCFTy96RqzQuhmpZ2ESMG7SQ1r4A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2EzQXowd042OEZDelBKUWpLSTgrZUZmcVdrWDgvanBXNGRYU2Z6OXRWYmhH?=
 =?utf-8?B?NlhkQVl6UzY1MkpSRUYzUEZ2bDhTb0w2TlVuZzJ4N25udkJlOFcrYXVWYWdD?=
 =?utf-8?B?TnhJMlZYNjhzKzl4bzdFSkYycU5KbDlvN1RyRGswRkNRWmEwMndRaUVkeDFq?=
 =?utf-8?B?K1hjczZpcWVuMDErQWFsS0ZTcHY3Y2VNbCs5V3k3T00ydFV6TnRaZ2NoMWZX?=
 =?utf-8?B?dEducUpsR0RJazFZeUVwMHd4eERpVlJ1MzZVUHphT0t6TE1hNlRDVDJLbHY2?=
 =?utf-8?B?V0xBV044NVdBdy95bUNUVVpCR3QyYTZyTi9Obk5obnRYaEphL2lYbWlueDcy?=
 =?utf-8?B?d3VnSEo2TVc2S1VQOE9vZGFRR2FONmZyY2VBU0pnN1ZoamFGcEdmNGFucDkz?=
 =?utf-8?B?bnUvbFBtbTYzb1cvMklCZnpmT2szYUM2QitzdXIxM2NyVzZXL0RSeEtqNEZU?=
 =?utf-8?B?NmZWMG5GVS9xd3RrdHZ0N1E4dVMrVWVnY2pjeHpzeU03VmVINDN5ZHVQbm15?=
 =?utf-8?B?RWgyOTl0M2gzQTJFdEREaTRKckI1ckVIYzF1V0VOdUJEenhLWWFxQ1ZkSXZE?=
 =?utf-8?B?WDY1dDVyQ1h3NFMvTmhnTml0RGpwc0VRUjVLbXpqUURlOG81OWg1UU8rZnlu?=
 =?utf-8?B?Q3dUZzFBM2FISnl5UkNjL2c3S1pYU0pwNzc1dFdtcGRlU2JHc0ZyTUwrc0wv?=
 =?utf-8?B?b2FMTjhSaUFuaVZQTUpUZlZGd1RuejRqanUwbW5Xa3VvOEdFT2tQREgyRWZN?=
 =?utf-8?B?dnVjZ0RObnZ0RHVkSSt1c2JzVmpKb3oyZk8vQ0xXamt0NS8vVm9HdUp0cmRL?=
 =?utf-8?B?VCtzRmZ1UlhKSDdPWllDYkhhaHF2czlpcWdrVzZSTlQ5K3RmekJLVE9IOEZL?=
 =?utf-8?B?alVraWkrMFU1UVpjRG5YRUxtK1lFUWlTMlJrM0pCU0duUTFNbjg0V3JMc3Ra?=
 =?utf-8?B?OWdyUzkxdzAvZk9VMzY0SEFKSUZtRnlyZ0dXb2FRclJzVWw1bWxKUUc0VG9X?=
 =?utf-8?B?dTZGWGNSNXNHbCtid25sMWdVTU5jRE5idk11M1NmYmhTbHNIV2VkQWJybkxj?=
 =?utf-8?B?OC9KTzNEZzgxdHN0Wnp3dTg5cmdCaFBqZ2k5U2pndDdUL1c4aGFIeHN1RHRp?=
 =?utf-8?B?YkhVRlQ1TWJyVnFsZk41V3VFbkRTRGR3QVczQlhRbkFtTDgwdTRqVGNYMzJQ?=
 =?utf-8?B?WTc3ZEFBSlk0Yk13WHZtNDVLQXN5cWZSdkRnVHdYaHlBWGRBbGZZeThRckZT?=
 =?utf-8?B?cGhYcWF3OHNkMmFORitPMTZUdTBpbW1naEFwTVZFc2VUdmxkS2hOMDFDbzkx?=
 =?utf-8?B?WDZpRUs3akg1RnZBb1NFREJZWjVSZmRBc3orWUtqK0ZTRGtLN1lhYW9KMXV3?=
 =?utf-8?B?STdVR0piSncxK05hMjFyeDdsNGg4NW0yTEZIS2ZaMnJGYlFCZ2ZXUW9CbjFH?=
 =?utf-8?B?WkZWOGhScW9DMFNHTkN3a2llcjh1Rk9RUlpCclNvdld0emN1NjQ3MzB2L094?=
 =?utf-8?B?K1NSYkRYbVpLZVh3QXZ0VUkxSXhJUHA2aUFGUXdlUzFYTVRhcFFWUUEzdkhu?=
 =?utf-8?B?OURrcUJYeVZ2VHdyTjQybWQzZUdkcHFKWE9nTW5PdW1kdWc1SjlVTHhPUXEw?=
 =?utf-8?B?eGErTmlGQll0TWRhQWtyczgwSFcyWEQ4VHFCb2c0YmlRNHNWOEE4UExCRWQv?=
 =?utf-8?B?Y1NxbjdWM3NJdGVzL20yY2JwcHdlcUJFK1RJVExTVitzSlZST0dKSTlmTnQ2?=
 =?utf-8?B?ODYrbEhqT1dPOHkwZXA1dWovcVU5VjNRcWZSUllGQW1ldzU4V1dSU1lWN1NX?=
 =?utf-8?B?Z01yeTU2RFAzcEdtcm1MdDBQakNnclZpOTFySlFTc1gxS09sZ3BHZW9zUVZU?=
 =?utf-8?B?bGQraGlZRUZkdmM0ZEF0dzl0MFNreHgxaG5IUExadkY2TWxFRFVNNm5KYlBC?=
 =?utf-8?B?Z01pNS9IVEVxcE1zaDNXOTlZQ3NobGR5Zm9pL0Zucy9kS0x1a2lUM1Fqa1JX?=
 =?utf-8?B?S2R4SWZ2NEpLVHhXc09Gcm1jS3plbU1sbkNwcmlRRHJJY1BsTDFjRTcwWnlP?=
 =?utf-8?B?UnZWd215T2wySE5VZXRlZXRmYi9vODhVSnRSYlRVcDZ6Ri9QaXFSZnZRQWo3?=
 =?utf-8?B?UnR4SHliaUNsR291NXh0NGdzRWZScnVTazhTUGJyQzB5bFVjZkRUVWNIbHNQ?=
 =?utf-8?B?ODRRbW1FTXR4eW9XVFdsaGFhNDZWdk5wd3djYk9LSmZFSXZ2Q1NIWGdoaEo5?=
 =?utf-8?B?emJQMTZrb3RlWTJjcXZEUjd0WGMzUWJNaG1TTHpjVjhSajl3QXJkc1FpV21v?=
 =?utf-8?Q?C+sgnMJQAVSh1d/GxG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ce799d-058b-467a-8d6c-08defd3277df
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 14:10:33.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvzXFDPlV2HZDzqXO3gPwWE0gTSRtKXneYRcp8N3w7t0v92zadQDncFoKf+QatFO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9575

On Tue, Aug 18, 2026 at 03:06:36PM +0800, 潘煜杭 wrote:
>    Hello,
>    This patch fixes a NULL pointer dereference in the legacy RDMA uverbs
>    write() path.
>    The legacy ib_uverbs_write() path dispatches through a
>    uverbs_api_write_method, but the uverbs_attr_bundle passed to provider
>    code
>    does not have an ioctl method element. When malformed provider input
>    causes
>    the common uverbs validation code to emit an error message,
>    uverbs_get_handler_fn() may dereference the uninitialized
>    bundle->method_elm pointer.

I fixed up all the issues with this email and applied the patch.

If you intend to submit more kernel patches please learn the process,
there are files in Documentation/ explaining it

Thanks,
Jason
