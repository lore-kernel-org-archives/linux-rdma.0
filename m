Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793112880;
	b=JhwK1C69on+WVdbuqe4Irdog+9f9K/FvxpqB5unBq3QwcYMS2SqRjGGwEKGpSCpCWmum
	 R7e0/BrIoXuHGSVz4d0GBfeDJikG3sYDgd+sTJJt6xyYEkj7fsNVKIk7t3/c84+IRRF9V
	 ItGp0PlOBZVSeqABUVqYqQVjKwUUjU6TXbD1BN/C+ZU6PIeilWvdYx+czhgKw7SvP2ZB1
	 sfK/323KuX+85NTwI6hcoMpDSrYOBlQhQKPyD5Na/IA1kzpOrvF+5l7BY1anWSb8gW3M1
	 iIZqM5VIwZeusbqHg3zWcUpjWYLS2wkueQqNPFHXMG9YLXFI1JUvvKzDaXVMfVqneFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112880;
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
	bh=YlYsVJNd+bUGkTP1ao7nLrE/Q+2iNW+/YGhSPcDEgr4=;
	b=4rPiEK40gOwjqFRv/+9A5U6WvNPwJXLMOliuTNUV++CXEE8TKqJFA4qqZKndWLNQFkpU
	 QjnbFR3kE2FV51S4ibD0+slasrvysVIgKXR+/tt/BMoEDPFRP5VagT3O5UP2Q5TSZB5a1
	 Fwm1KSjU1p165adxVfRD0g6XbpCeqCccwW/+LgGISdP7OdOvGL8bixnsG1S1amIP71ZdJ
	 4T4fOBa7E34Yk40tf5e7P6FXeQ3Ldpt9OG1FuI87LWcXHAQAuutMpeupqZ+2OU8h8all2
	 YCio4UUwBPFtbQaSitYgwwp45Ht+EHD/S1C9U8WU41IF0MzKGD5hzMAqsAeGWlLLz1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="Y6/nHPrk";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.61
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142E1606A31F;
	Tue, 27 Oct 2026 14:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 142E1606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Y6/nHPrk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B1EKU6QWCE7w0HmKZtKIFWPG0uX+I6P1I87jgFYSYRs0qf2OOPiVp4Fw1rTwuOVqTae5GdTiOVR0dvmuyYhKaSLpHbhQKvHfzpGKQsoVeIdjJEOlUMF76JW9FnhA5tPZwlBuVNc3qp0G+uqmwvBzj6DgiHIwZX5W5zqdclXcK0Awx9fPHTcwobQhOzLAt84LBWvjhsNW0BL7b0NnlU2UFXj4k7CxRTPIkFFLGtGNoqg7h0dLtXOIx1WYBipnAsIhSVUblXRKxrDluOA+EJN503dceQcrFtss35rwPgz8I5RUr+tPQo9iSk9HeiDA0G0NfJj+PldVdLZBIBJ3Lfu7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlYsVJNd+bUGkTP1ao7nLrE/Q+2iNW+/YGhSPcDEgr4=;
 b=oQle+nsULXtQjpdJUOLXLBBWYqmtNzN3UPhzkbhPHmvSbtT2NEInUsaGfRdTS4D/5kzEV1Mp+/S+eZoC2A4OrueJnkWocF/eIfhSQ4dPtxjIp02xcf92cXidyGXp4Ws1E9zqlqwd+kQSXeREHr9vW0w5aX8lOh67xBKYtYc5mdqR83v93crPzZVoqKNSrtNnyeckxibcAWApIeSGOXpbXmZBuPvcLOzqT0B9pskQ1CUhYQ56zc62jvvroply2mG4aWUlThNPuuzASp6zV8UnU+LkdRTTpLWPGvEm7fqq2bXGn2WrajaVtXPgChcp9NBOVzm2ZtyHZ5xIN8+lE/1vWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlYsVJNd+bUGkTP1ao7nLrE/Q+2iNW+/YGhSPcDEgr4=;
 b=Y6/nHPrkyf8W9dSWXWBPq4Oy83+2RPyObavzNZXA5d/85+Dwn6t5gZJgK0sGfYzMKWSr7pzUMq31jG0aJd5mk8KbydMrhRrk6XrWxKCxlYKoVYS08K7USHw/q0gkTrwqgCbFqJVhINEvhqSJ+xwXK88v/G1RZqE4waAbsWZeG6c=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH8PR12MB6748.namprd12.prod.outlook.com (2603:10b6:510:1c4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:54:35 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:54:33 +0000
Message-ID: <43a20d60-89a9-48fc-af73-5907b35a54d7@amd.com>
Date: Tue, 27 Oct 2026 15:54:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
 sumit.semwal@linaro.org, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
 <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
 <20261027123859.GE1671235@nvidia.com>
 <3a09ef96-45a6-486f-b482-fd34c27415af@amd.com>
 <20261027140831.GA2338330@nvidia.com>
 <7193d384-5e28-4f85-8004-1dc9318d5c1c@amd.com>
 <20261027144459.GC2338330@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261027144459.GC2338330@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::10) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH8PR12MB6748:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e816800-1ce3-4f45-eb74-08df343a367e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|6133799003|22082099003|18002099003|261026140227099003|261026130827099003|10067099003|261021121427099003|56012099006|11063799006|4143699003|5023799004|261021130227099003|261021123027099003|261021135927099003|261022075727099003|261022115727099003|261022113327099003|261022105027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	utUkeziJ30WpRWscxmo/Yi/3YOf+fYX9DyMWuZiKOCFOdId4+taS4HOnm27FkWbqHsYvRSuj/P8Ny+L3WcNJ7Vqp06ea3NNvU0ARzsx8uNhLnIit8AGz+p1JJDdIOKPxhy6bJ2IDZcs2SQI5vATs8ZCCakz4RVKs2HYZDpd5RB+lztMeWkH2iNOUKss/WeJvU9X/3waVeCtEcN72XVNus29Oc9sG50mylxbc4k3YqjS/Ij07iIToPwBQdbnYmpPufqJ3wa75FzyK4cr1snx1t6hNEBAmnMyU8cfva5+1Ls036/ZvB285lZz7jPLJl6LxqJrrcP4EcBG7wLn2qjjloxrbfTImC+K39FBUlNJe7tMOzeWkgBxz5hGs5iI6XD/BdRUuN7H4xXzNOIWRqE41WPND6iY1xC8431ZqeLV6aBzK+VoYHImtMKl7mTkEWj8KGlX0RkjRKvSgSroLmuz4YyFuqf/2/Q1KV0GrWsQhoVXfxd1Pw711GczyOL2eG4V3wU0l7XWSmcxTTi/zNyNOwU/CWAYokepFFcYgUf+dxkpjYI0+yuebPa8PIh410mWn0c7a1P2Zju/BktLMv1kXw/vQ19NjSB9u31LVQQJJUXqa0tuQL8LhrZcPm248g3nOWUYhgNUfYIxWNR8MyNKHSM0p8jyGc5FizJ2ZuuwbE84=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(6133799003)(22082099003)(18002099003)(261026140227099003)(261026130827099003)(10067099003)(261021121427099003)(56012099006)(11063799006)(4143699003)(5023799004)(261021130227099003)(261021123027099003)(261021135927099003)(261022075727099003)(261022115727099003)(261022113327099003)(261022105027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djlCRlNYbUw3TDhWM242c1VFWGR6R3VhbHNTai9jd3JNZ3l3L2tIMEdTS09W?=
 =?utf-8?B?RjQySVd6U3VydXJhMW1IdGNzSytRc0d3OTNmTUsrSVVaWUc0OFF3ZmloUTBI?=
 =?utf-8?B?angzR0NYYnBKMjczTXJYYms0ZFIzYXZ5SHdEeDZRTUF3U0V5MGttR0NIK2F3?=
 =?utf-8?B?ckJBeTc1YXR1TDVuSmtubDlad2NiTkVmTHd1QWgvbmhRa0hYT0JWZnU4c0JN?=
 =?utf-8?B?RzNIbWNQYm1YTk9rSHdPUGkveVYvTzhlNWN5MkxiaXMxemttUE9MSVVLTHpQ?=
 =?utf-8?B?SUF4dUZ1YVQ3U08wU29TMU81K2pERnVPWW9OWWtwUzZsRUFXZjlwNWNzM0xU?=
 =?utf-8?B?amZITTg1SWRreUlZazlRKzFYcVE5MWFBalBqZWF1L0ZrcXo2d2RkUVF3QmRM?=
 =?utf-8?B?Q2paY25Bb3VXTVplbk9zNEE0bnd6czFBNzZDV1JWUFgrYU5zYjkxMHdGVy95?=
 =?utf-8?B?M09XOHliV3NnY0lOdmtwQWw3M1VxTVQ5aDZ5RnJ1L3o0aUlQYnE0bGY4OSt0?=
 =?utf-8?B?STFjTHdIZEM0Qkt1QWZhRU84WXZBSG04OWthMWhlWmc1RXpxTFlYV0lGZEtT?=
 =?utf-8?B?SU1KZmpRVkkzSDU4TkNlLzIxc0FBTjIvUVRJZXQvRk5zOTV2NUcydEdOakt1?=
 =?utf-8?B?OVhkNGZQWm10T3NaYlFyMmdndXF0akVLaXMvcGVlTnJIRDdnY0hGczZNVkRJ?=
 =?utf-8?B?Q3dickFjaDZQTVZoRzN5YmhkdGV0cUw2SHhaYmZKZCtEa1hlZmRJWUNzaUp4?=
 =?utf-8?B?WVgyWUpuaXdvZHJaMjJJSjE2bktxOUp0UFkySWxkdXFuNFhCdUpnMnJwbkZ5?=
 =?utf-8?B?MmxPQUxuQWtOWHh4Mm1ZRXBYeWdqa21aZkVhb0dIVzZ5UGI1d2JsVDk1NGw3?=
 =?utf-8?B?NXg3cm1oNmc0TnFyQVVIRURaalBlV2h2NEtNdVQyamtsT3VINlkwMlVhMnlC?=
 =?utf-8?B?VG10QzdTTk1id1E4b1o3UEkrZEVVV1dhWGg5cWdQMVdjeXpib29ybVJuUW94?=
 =?utf-8?B?ZTV5Mk05L1Y4ZWt6MkY4SzFQR0RDeCtyR1krMkxsTk9maUxWMUc2U1czZmtx?=
 =?utf-8?B?cmFnL3FzcS8yZ3Z0OHUxbGlFM05tblR3TGFubTZWa0paNjk2bEZjWk9LY3k3?=
 =?utf-8?B?dHZNcUwvckM4RjdsM3ErNmdtbi9oOVI2WUVXWUx1SGZ3NlJwNnl0b2JxNHNJ?=
 =?utf-8?B?alJpeUJaZStQa2V0clora2RIZGcwSlliNFJKUmZEcG41dU5vNUhWRjcwbnZR?=
 =?utf-8?B?blcyZWJlMlp1THJvY3crV2EwL3V4QUtZbnc5YnlDQ2ZvUEx2TEVBQjg0SXln?=
 =?utf-8?B?bWo5OHBaUlNLVWV6YzE3bGcrQXVXYTNVdExxcnZLUHQ3MXIxYVZTckp5c1Vh?=
 =?utf-8?B?dkNuNlc4M0pPS2pkQlFjVFo1ajFKK0dZWFYyaHJvcUNlQ0Y0UCswNnpDczA5?=
 =?utf-8?B?Mk5aVGdqRXBQeWg3QkVQVkRxKzhoWW1LK080dTdKalIxbHAwZlpFOFVZeTJ1?=
 =?utf-8?B?N0tyODZBSDA5UG8xc2xhTDh1UTNzKzQvb1BUL3BZck9DRjVHRlc3R3Arb3hl?=
 =?utf-8?B?Y0MrZldxQTdscEN2cmpUTlU0MGRVRFhCeDd0K0hLdkNCc3FaUnFYcEg5UE9u?=
 =?utf-8?B?K2o1d1FJeVBteTAvbDRZVitvRGt2K0s3L2RyUkJCblVKU0REbDkzenFMdDJ1?=
 =?utf-8?B?cDBvSnZuZGN5bjBVaFBrTEJtM2NkR05oL1ZxNStNVDZGZFBFd0NiaUpaM2Uv?=
 =?utf-8?B?bUpJNHV3TjJmVWthK0VER1lodmNvTXlNMEExSGFaVTVNc0V5b085d3llMW0x?=
 =?utf-8?B?WEpyOWJlazkrQkVzemVZaXZQK1pXdnZmQkVCa3RqNnhpOXZRUUd1bWtHZjMy?=
 =?utf-8?B?T0NNdlE1ckFrbjZkQzdPSlVHWHFTWUVZUC9La0Qwci84aG5ML2JHNXh0OVgy?=
 =?utf-8?B?L0xmSitVbUsxNkszL3lMaEdtUDZPeVg3VjZoQ3ZCUWpDV3FoYkZBNzY1bytE?=
 =?utf-8?B?RmFraG5lMVRYQTN2bTJJMW10Tlc3anhFbEVWSm55M3FjR2R0VHUxNE81aFdu?=
 =?utf-8?B?eHY1Q0NxZHd4MWIwZHNINjA0MG1JeW5RL0pXVlBWeEl0M2wzbSt6ZkJ5ZjI5?=
 =?utf-8?B?T1ZTY0Y0SUhUSGIyZTRaUTlwaGR4YzY4aGx3OGpBZkt6WWxwZHBtU1g0dkJ4?=
 =?utf-8?B?RHIvOWFvRUZtWitYU1VmR21EcTU5NmlaY0NtbStJYlBvcE5BandLZEtEREx3?=
 =?utf-8?B?RTMvRFBER1VjZ1VnMEVHYlA1UHU0M0p4bUZaam1Kc3lmYkVDdllTa1ovbXNm?=
 =?utf-8?Q?WYoMvzsL1lif6tlGwb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e816800-1ce3-4f45-eb74-08df343a367e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:54:33.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sq5A9jD564lJ+UFKa99Q1H+nw/kWSD8XchlH3ZFHynVqtoZYUSyJJNqljJYWxH3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6748

On 10/27/26 15:44, Jason Gunthorpe wrote:
> On Tue, Oct 27, 2026 at 03:28:44PM +0100, Christian König wrote:
>> On 10/27/26 15:08, Jason Gunthorpe wrote:
>>> On Tue, Oct 27, 2026 at 02:17:16PM +0100, Christian König wrote:
>>>> On 10/27/26 13:38, Jason Gunthorpe wrote:
>>>>> On Tue, Oct 27, 2026 at 01:07:36PM +0100, Christian König wrote:
>>>>>> On 10/26/26 06:36, Alistair Popple wrote:
>>>>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>>>>>
>>>>>>> This attach function always creates a SGT mapping type importer.
>>>>>>
>>>>>> Yeah that is a clear NO-GO. The attachment should be the same for
>>>>>> the new interface as well.
>>>>>
>>>>> Not sure I understand this comment...
>>>>>
>>>>> This was intended as a helper so that existing drivers can run through
>>>>> the sgt based mapping type flow without having to open code it. It is
>>>>> hardwired to only do sgt like this. If you want to use more than sgt
>>>>> as your mapping type don't use this function
>>>>>
>>>>> The point was to create a clear distinction in the API names when
>>>>> things were in a SGT-only flow vs using the newer negotiable flow.
>>>>
>>>> Well that is my point, the dma_buf_attach() or rather
>>>> dynamic_attach() function should still be part of the new flow.
>>>
>>> It is, this is just a helper wrapper effectively to run the flow
>>> exactly as it is right now wired to only do sgt.
>>>
>>> Unless you want to see that open coded in ever driver using the more
>>> general functions, I'm not sure I see the alternative?
>>
>> I still don't see what you mean.
> 
> The function is this:
> 
> struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
> 					      struct device *dev)
> {
> 	struct dma_buf_mapping_match sgt_match[] = {
> 		DMA_BUF_IMAPPING_SGT(dev, DMA_SGT_NO_P2P),
> 	};
> 
> 	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
> 				      NULL, NULL);

Yeah. exactly that is a clear NO-GO from my side.

The existing dma_buf_dynamic_attach() function should already have everything you need to negotiate the mapping type.

Don't add any new dma_buf_mapping_attach() function since attachments are generally not mapping related.

Regards,
Christian.


> }
> EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_attach, "DMA_BUF");
> 
> Which is just a wrapper around the more general attach function,
> forcing it to do SGT.
> 
> I don't see why we should label a function that can ony do SGT anything
> other than under the SGT names.
> 
> If you want to get rid of it then the above has to get dropped into
> every caller, or something like...
> 
>> If a driver can only deal with sgt then it won't implement the
>> dma_buf_attach_ops->supported_mapping_types (or whatever we name
>> that).
>>
>> So if either dma_buf_attach_ops is NULL or
>> dma_buf_attach_ops->supported_mapping_types is NULL then we only
>> match to the sgt export.
> 
> This is basically changing how dma_buf_mapping_attach() works to hard
> wire in SGT behaviors. I think this is something you'd regret down the
> road as it starts muddling up different concerns..
> 
> dma_buf_sgt_attach() is very readable for what the driver is doing,
> and grepable. Implicitly doing things when other things are NULL is
> more indirect.
> 
>> What I want to avoid is to get just another dma_buf_attach() variant
>> since we already added a parameter structure here.
> 
> It is a pretty standard kernel style to do things like this rather
> than expose super APIs with complex signatures to every caller. If
> there are many places with the same operation it does tend to help
> alot to mark them with a helper function like this.
> 
> Jason

