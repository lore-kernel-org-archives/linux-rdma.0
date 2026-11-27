Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795787102;
	b=0S/yoY7WpXGm6eQqIltmL3dqxBc/hfyUl54r/00LVEIIMDaj3lhPy49/JUzorjTbofqJ
	 owPd9M/jZddjPsQpcFY1k2Qym776DJnV7Jayx6ToPL3P8FE2y4/eC6N56tTBpOqots7XB
	 /y0knvoRWnG4cPs2fqk5hSC5iznPnCAGJ/acRGZAQ3xbCH9HdrtzE52YX6zHtoVOMVY0W
	 eiVs0GBE+fhhnrSV+OSq0CTwK+mJFYTlJt0N+n+JkKS0ehFIUIjFaNYOqU74VSiPRfuL1
	 Vb77fJBKU9OT98mkYCRbeXSwSPjfXkRoP89PZnSVy8od7EW64TOkIK4yRwjVZrrHiEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795787102;
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
	bh=InFw9UrHf154I8sJn+zyovCN+8fZW/KRWPL9D90xIcg=;
	b=tIUiLyRo1ezMciACcMLTb6HB1xtrxkGRt8VINeVazamaIU9u4teFDWAnrusygRDtYGVI
	 wSTUQJZwJFzpZy6dy93luaOhMTLWlTpZeg2W3/xmnFCvb3WztTBnRa0HR4sUq3+32wY5v
	 morG9AVksO7Pz/1wILbVJ1SpCbDUiB4E8xz3RPQPKd4eXHNhaJCV3gPRUY+cCEFgs/RG7
	 MfZDfKJus1naCEBxd3tyWCBzO/SCOstAIxfBoNMomgXNIh/q1D7m2BkyzFNhU//F9ROHg
	 2PhnpCGt1rdC92tul1Fn2/E7ecRj/dzhGVSq7MacFz1zxbXxbFXF1Rp19l2LFoP+OKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ztVaFm3U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.58
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0249F606A326;
	Fri, 27 Nov 2026 13:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0249F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ztVaFm3U
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F5g7mDTe9Q54VJo9cUP8Yz2gIiEMpJxMGERhAPybf6ZtD3Lu38eC31UoKXyjwE75neWcajmk1lmW1UKYizPfK8UJx6XEvqCp02CTFQpmutE5UvaNxQ/YzdrPnBA07hL92erKT1SmaC1SbXALRoDu/bQw4Tcfil8W8F/VDPeMJbYOvF4egJWadMHNB1LRN7M9c3RaKCZEb2Ep7C6U/WhNAm8hdL0sI4Q1WGYQAOTl5YqL5grljvo/7ObOYq4AxyPVPaB8Uc+8gExBmsbMG7yR1YEkGLDINbND8XE7UkZzFUFkpdjEBQskPNaZtystDr68ItFjto5/oDH0CcOUc/NaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InFw9UrHf154I8sJn+zyovCN+8fZW/KRWPL9D90xIcg=;
 b=CHAxM4coZ+ldsQ9Y7D7FbCgYZkP0MwXcqqr5iTWaXeqhJ1rMl1P4ri9CrvhfsHFNip0jUM1rTzfl707x4Nw5yeNqRgJdCAsEenroh0nqN+ConMKu0Ge2ec47+aEnXIwhRwbwOOIz7HhkP7y7W0OsLNcUbP6gPhGz0fvj79WfN6Xmvc6RVG7k8Hnq97qr9s0rB/4D4vTPHq/V8fypXTxB1gE1T4ftP6w0DN9KkDbiWoETno3v8Oi5AQuW9kj0u55ztcSwMCSn0nUc1PszF7FJu8Z4hGeefHCMh+LLmsefyLMQX96Z9FAdbINfs5pVyAbPJRxBpQcNSAp2d8PznZ4pVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InFw9UrHf154I8sJn+zyovCN+8fZW/KRWPL9D90xIcg=;
 b=ztVaFm3UcgLwMuPXRkQjeejIDdXDxQwsPqf1sQ0jf4OZweV+nrBnfa2qgstHZLwbg2Fg1nuO2k/k8/kMOS7fCvpYKntmN5cOTQgrWeInzs7aoa5j1kEqihbS+geeqC3H+hVTQL0i5s9tAeEi/Xl1klzH8YoTifEVCIacxsYAk9M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 13:44:57 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 13:44:56 +0000
Message-ID: <eae24bcc-5d49-4f7a-a66b-164e8ff73bdd@amd.com>
Date: Fri, 27 Nov 2026 14:44:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com, chaitanyak@nvidia.com, Leon Romanovsky <leon@kernel.org>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
 <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
 <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
 <CAPM=9txheaE3=fp7=n4fYh-xshxOm+Tv=eQn9wvHVAc-b1JKDQ@mail.gmail.com>
 <79d62f9a-cea8-4149-a673-7ef86942410d@amd.com>
 <20261127125753.GS246011@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261127125753.GS246011@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::16) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: d92c2e9f-b456-41b3-176c-08df4c8c9f98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261028144727099003|261102130727099003|261102123227099003|261021135927099003|261021121427099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	sMwH5oCGXSW3jaJccl+mWHwagaSg6j3HRWx1ppqY575jg57WtkUlFU77KU5YDPUqyWKL9+de30JlvPNRouRjxH3cBiDjnMeoesCidVo9VOgYHkHUOwI81q4exRcIyB1nKBBYYspPhGTqgKThTzcQnBIuos5lKTq2OjLEQEaxsQiXhh3dZvYjGNYFaWuEtFFJ+ExZVEHTakfvi9fZ7+LdmLM2x4+/1yXqx1e9Pd54n+ZnN5IBEZY2OCuxKr8oWatR1+8423C6WbKa6I63xpXzTYcUCSNa3DhD6jnvFvUcic0hDdzXXSgRmiMV8v4KQYV40f4mtZBRf/vXVNbDrVrZ0I8W/xIikhOHpoCtNLvXE5IitdUovYpzM/6qpbUEVPBHondpBNsnR2PxlLhcgcMbQC+md+SYS1lJvSKJNVho7mmbVr8fks5wmtf9F4CwIQ9f5ksLf1vqWOlJWs2WgB9Rw6JNYsSqCUAFvFDi/i2bfNkJcSqYKvw2nZQpo8erq1GJcG2+nFN76clmJ23PvCmX5EqzQbisOuJnDXu3dDT3NX/DAte5Y6gNmXeTlE/G2IsfI9JBDORjPaNdetJ3RYva+7PG1yiIZqfytdDDhPWg6h0bWkk9sJCo0a2Gf/B9elZ48x44t/wJ/YO1okfgevL5Ov0lp5dWT9xP/4cdrLfSOSM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261028144727099003)(261102130727099003)(261102123227099003)(261021135927099003)(261021121427099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnZTQ0plZ1hVcHNIM3Q4bXplUS9jNGdFYjA4WjZKVUluS29LVXpmVHIrd08x?=
 =?utf-8?B?d0Q1cGtrVFQ3ZVFYRW9hZzJwL1hkZGlUdHd4MDRkbHEzaDlpMTIzVEVOM2Zs?=
 =?utf-8?B?c1YzbVUrd2R3R2NGUXJoSm8xMHVHMFJPa0E1aU5yQkFOejQybFF1VWJJa29t?=
 =?utf-8?B?dkNqNFZ6cnlPT2t4NGl5R3l0Qks0ZCtzZ1lBc2ZMQ1dESlorYjByaWhleWdM?=
 =?utf-8?B?M2phV0tiZUs3aFZaVEtPRytwUFRhU2dBd2RNblQ4RDNKL1lHSHpDZUJpUTE1?=
 =?utf-8?B?S1BseWFIKzMzcVRMbVhic2J3UXNRaExqV2J6WStUb1NvSjQzVGlCK2tTc3Er?=
 =?utf-8?B?T1NzazJTbDEwUUhlQVhpR2JmV29HZHQvMEFoWHZoaEMwdU52M0tocDVYeXlq?=
 =?utf-8?B?SGlsRVlPS1hSWmY4MnVQZ3VzNmVldS9uMzNzK2xvZVdOeUs5emI0cnBOVmRP?=
 =?utf-8?B?NFhhdndKUlpBQnVGYWZ4bGFzU0xyWHJydHZla053MExWbGJvQnBpTUNQU2k1?=
 =?utf-8?B?NWdkc1R2b3MzcU1hOHUzZTdnMmNNYk9jcEZUdVpvdGRHbmxtN2QwMGkxay8w?=
 =?utf-8?B?NVNiYUo3QVhDTnRuRnVBZXdja3RxSFF3WFB6UzFaRU80YSsvaEdoZXV5Umtp?=
 =?utf-8?B?V3dyL1owUU1yRjd1MHlHdTF4ZTlqZDIwUmFOdzk3ZGhHUmlES2QvRDcxNUVj?=
 =?utf-8?B?bmlqL21lazhFaWxWZ2JDQnh6SXJIUkhIR3R1djhoKzUzcVRYaUh6ckp5MW5o?=
 =?utf-8?B?S3NZS1g2Rm9sNFJlaGtIcEEyT0ZVRFBjVlhZVDVHamU1SzhQSHhBa2NKamtj?=
 =?utf-8?B?L3NiRk5IK2txdnA3K0N3cm5zN0lOeXNiWXlGbytQS1VYa2draGlqZ010RWE0?=
 =?utf-8?B?VVpJK3dqNEdCVGJKK2h6MG9iRE5taXNsWFN3WkFFTDVJOGJZUHhDblZnR1lX?=
 =?utf-8?B?bEh6Mzc3M2hmbnFPT0F3TytsWEw4a0YrUEdoUVJNUVNNOFhkZS9VSHdPL2M5?=
 =?utf-8?B?RzNlMVBXQ0htSkNEQi82QWUwMGhpcXFqc3Jxb0poTFBOdytUQjBHd2JDaktE?=
 =?utf-8?B?M0I5TUFIM1BFTjdnajN4NmNsamhNWUsyQ0dKSzgwblF4bGU5dmYzOHJUU1ZI?=
 =?utf-8?B?aTFUc09heExubUNYOVpjbnFIQlpoTnVpTTVWZUxFQ2ZkNFE2TVI3czFjZ1BR?=
 =?utf-8?B?eGtUN2g0RHZ2bTQrUkZWUHpXRVZFeHpFNytGK2Zwb0s4UjdzVTIwNWpqd3pQ?=
 =?utf-8?B?NXJxTWlCWm90M01JVTdiOUQxbmdEL3BmeXBFSDZib2luWFo1OGIxQTZoaGph?=
 =?utf-8?B?T0Z0MDFzSTRvL0p3Uy9YeHFubUFEWGhTWWR4eVlycHJ4c09XNTh1RWt6ZVlq?=
 =?utf-8?B?TnNkMGk3bUFsbVBjcXg5VHlHdkVYZEZ5OXJNVmpNRlBBZEZMckpEWVlVeTNt?=
 =?utf-8?B?dU9BNmp5RExGVnNYQ01VODl0K2RpR3pGWjl2N3VmbnBydkVJeW8xTVpYK0xu?=
 =?utf-8?B?Z2RFU1M3VWhPTWlsS2wydDFwTTMvVDFsbm5WSXdoeXVIZ1h1eTRlNUxoTE8v?=
 =?utf-8?B?ZnJEUUMwdVBrQkdkSmlJcTlEd1ZkM2s1c3BvTkgrdzFHVk9WVG1XWE41cXZ3?=
 =?utf-8?B?eld5S2pSQnlhaG1JNzg3K1pEbGJFS0JuWHMyY3UvQjNVZnRXTFVTaXN4UHZJ?=
 =?utf-8?B?YlV4bEJKQ21CVzZ2ekNQQ01rMXR6d3lSSzdkR013TGljWDZxekJlWUlWSzlo?=
 =?utf-8?B?OFBTSS8rVVFzeGZaeS9KeHo3Z1BIY2VOMlNSczNHZE81Y2doZG5IUkllZHk1?=
 =?utf-8?B?TmMzalFBN2F1L0ZtamIrSFljVC9mc3FGaGpyWHFwSnBPdDBoNWlFWWpFbWVi?=
 =?utf-8?B?NDFHallqb2VRclUwLzU3RkNBcXJOT1VPWDdsSVpyaXBGdDI5ZnF1ZDYwdWRV?=
 =?utf-8?B?ODlJMHN5djZYeGE5M3g2K1hmZ0ZEK25aQWx6dnk4L3hBeDRsRDFHTzZiZFZi?=
 =?utf-8?B?RWZjeUNCWnNXcEluOEFxbXpXTU1vdTJ3SDBLMXNLN0M4Rlh4U0k5Z2RKaHlp?=
 =?utf-8?B?aHpLVk01L2lPU0ExMWR3V0xZMlAvcURQbW5JYXE3WnpHSFE2RytzUWEyeWZ5?=
 =?utf-8?B?ZHcyZ1ZKYUZmVVdxSUJjWGVnRnRaNFBkYUFlN1hBbVdua1pLcHpiVndMeUc1?=
 =?utf-8?B?eGMvNnRtM0YwSktra1NELzV5UXEvZmtFK3owRVQrMXpvcE5DT01JTUNobEUy?=
 =?utf-8?B?azBVQTdIczlCYjhLb09ieFdWZjRvSTBHaWJ1N2VtejJNTk5UeHJ4ck5XbS9W?=
 =?utf-8?Q?FJvK3QUoumGB56BX9J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92c2e9f-b456-41b3-176c-08df4c8c9f98
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 13:44:56.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkYgQ+qjs3pQ1PKzW4whenm0xDv0qTAbMYkK2G0k91C83ME/axC1+i8IY5tTnSzZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625

On 11/27/26 13:57, Jason Gunthorpe wrote:
> On Fri, Nov 27, 2026 at 09:04:15AM +0100, Christian König wrote:
> 
>> If we somehow prevent the CPU physical address from being casted to
>> a struct page and/or used with vmf_insert_pfn/page/dma_map_page
>> etc.. then there is not much of a problem with passing around
>> physical addresses.
> 
> I already offered that in v1 of the series using limits on
> EXPORT_SYMBOL and you NAK'd it too.

Yes, because I think that this is not sufficient to prevent importers from doing nasty things.

>>> If we need to shared object backings and have clearly typed and
>>> negotiated on what the backing contains then we should allow it.
>>> However I mostly agree on the mapping thing, I'd want drivers to
>>> negotiate and natively support whatever backings they can rather than
>>> having an intermediate trying to handle the conversions Not saying the
>>
>> Yes, exactly that's my concern as well. We need to avoid this middle
>> layer trap.
> 
> You avoid middle layers by having reasonable subsystem helpers for
> things to use to build their stuff, especially to encapsulate common
> patterns. These helpers are part of the subsystem, or in a related
> subysstem helper library.
> 
> In Linux terms middle layer almost always means something wrapping a
> function pointer callback into a driver and enforcing specific actions
> on top of that. The recommended counter is to have the driver perform
> the actions with helpers and not wrapper the ops. It particularly came
> from the block world where they stuck something like SCSI after the
> block ops but before the driver.
> 
> It is hard to see that DMABUF is anywhere close to a middle layer.
> 
> This is also why we don't understand your remarks about
> dma_buf_phys_vec_to_sgt(). Of course it belongs in dmabuf, it produces
> the dmabuf spec'd mangled scatterlist that only dmabuf uses. Where
> else would you put this code?

No, that doesn't even remotely belong to DMA-buf.

What could be done inside DMA-buf is converting dma-addr[] and SGT. Because we need that for backward compatibility.

But creating the DMA addresses from the physical addresses is low level DMA API and is not a task the DMA-buf framework should fulfill.

Again: DMA-buf is just the utility which allows importers and exporters to exchange information how to access a buffer.

>>> code doing the conversions can't be a helper, bit it shouldn't ever be
>>> autoamtic or outside driver control.
> 
> I think you do want it automatic, if an exporter is new and makes,
> say, a dma_addr_t[] and the importer is old and wants a sgt, why
> should we be open coding anything in every driver to deal with this?

We shouldn't. That is not what I'm suggesting.

> You can argue if it is automatic because the driver called a very
> general helper or automatic because the helper is wrapping a callback,
> but that should be a fairly minor quibble not a huge thread full of
> NAKs.
> 
> Ultimately DMABUF has a fairly simple flow:
>  1) Allow importer/exporter to negotiate what kind of interconnect
>     they want to use (PCI, ualink, etc)
>  2) Give the exporter enough information about the interconect path to
>     make a placement decision
>  3) Describe the exporter's buffer so any mappings/translation/etc can
>     be setup for the importer
>  4) Program the importers HW.
> 
> Many of these have very common patterns, like PCI GPUs always make the
> same kind of VRAM placement decision in #2 based on P2P support.


> This should all be in helpers under the dmabuf umbrella and not open coded.

Well I completely agree that this shouldn't be open coded in drivers, but it also doesn't belong into DMA-buf.

DMA-buf is just the utility which allows you to communicate the parameters and the result of the mapping/translation back and forth between importer and exporter.

DMA-buf is not and should not be involved in creating the actually mapping, that is the job of a low level DMA API.

Christian.

> 
> Jason

