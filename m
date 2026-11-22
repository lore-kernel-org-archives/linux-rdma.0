Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795344211;
	b=aNcsT3/Tn5M1wt/XQPztdmFOpwTX5/BM/LB9U8n5U0WnJpUcuemleh88gZWJGKgWPaoW
	 6UlMDZvkrDigmvOcHVWJAng/fTd3SUeD59PJJTEBjCVo9Wd5dsqk+NYBTh97MjIPPyA5O
	 ZeOEfoTGX+A4KqB0eWvpErTsReXBd9Z961t1mh9huK/0lYgrcywQ29vY6tkrQJ/w8Bqnq
	 MLnTxScI+dBh3r4gmu3v/I2lV0BA3rnlgnHzGZoV0nGW9h9kouEp7FRwhQxbIajiDRcbm
	 rbrZyhEdwkLIzX+k5CMI9iIw0Ye5Qg40Ai2FZ/EaPK4bL4MtJCafjQoH0wq/4q6SpTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795344211;
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
	bh=5KM6V4B7rnW7uZvfsakaAgU3bCRPg2xeqZkPh3eAyD4=;
	b=Rrw9MBZ6s0WO/6JslYtJK0dUtHVtX2TgvvVAXZ6tEvCG+KemruV3YUWcUD1ZvBgS/YUg
	 sdWRyItVNQU+OK6JJGVr83j29ryx5BR6h2nZ7GmnljQDlZhFgSTGVi9tzMVZGkKQ6f7IA
	 Wf+wdGklLorZ08en96l0SdTRW+fLetRvI/qm5MuHXNaTKPhzVEG1b76Ey5Rkiq5KIZNGU
	 GAwE4W6NSbpEhjhUYM2WAgHC7Ix9DIemjo0ZUgxQ6/3AErzGhqRTT3TT5San/M58r4hvx
	 OwT5mEtCUHnO0rRaOe6O49K3xOs2x55K6DyxGYfxO4yep9DyzXc23DddOtt+pMcyBTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O4dpnG3k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.0
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C05606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 10:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0C05606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O4dpnG3k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnjOo/I+6QdJlOLswLvgaLvHeueXQSslg7SQotD4byjruPTGW9ej5tRoYiU2ov0zl2zEPtzkTolUM3unyxVhKx+i1pnL7FG/LRIu1G3AjMUK/lsFXInu9bY+YAvbS77Lv/XouEMf5Az0/SOMtRFceGcY6+hi3i0dlLMS+U1XiaAsoVNsyRKtTjnxWsvjZAFTMb44vVdYLkIlUS24bjN3H3oUofvoYG0FyjrApfaOOOS5F1EIwr4/eiq6MVhAzL4NunxRHUT7NfQN2ZKhaeIy4GDqhXSuTHd//GP4gzO9dGeSmz7iTQx8gtmDAAt56Mh7dvnFFu0KvZfw3gKnI5dq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KM6V4B7rnW7uZvfsakaAgU3bCRPg2xeqZkPh3eAyD4=;
 b=wYgAXVfkaNQl0iGsGL8EXde8BXcgo4hcrr7ioLGQKNCTBk/vqcEbz9PbN0KeU7asK5mldo/mdrYNuW9dsqxLY0nE25xTkdaR+aZosvVRDnd5CeoS49u831tFaMhKpxQ0Mfe4Km/th8O5qa/C+zqivlrTuhK3axAC+5Wj3ovjkJe3uX2Od8nFxtPmVYKhKlypuLkQJIO41B0ZYCFJuFNci8H7SDtLnhD/jEBLz6nWwTiVQDp/oH+Nbim0/MrYHdzYAlEbR/Aal2PDcPjk6wYP1wwx5VwcJ8+iH3MbiaOtJcmBrClVYXP4NOyY1B6NKUeb+a2dQfX7HdBwaPT0OJ6KOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KM6V4B7rnW7uZvfsakaAgU3bCRPg2xeqZkPh3eAyD4=;
 b=O4dpnG3kUcv+OUzh/btpaVzZNORuDFmwaG7KFUWW7COgb0M3FpbxUXxyUQMqaoV1wBuMQlpzOSV3zSueH2MJV/BrJCnJuoa6dhpStmKSk06LlkPqxOVHL3LtB7e9rKq2uujUBXdHQbTZa4/ITBTGdFw8rC1FbFW47lwaaUOYV961EvL2SbeweBBg9YV6FdyFlopohRVNrcMYbMyZetUd+HKF/MASbRN5mtU+EJQJxsoiKNcTNegFERDpYAcgdratginTSCFlqKsjvhjQb41qp+pm42+T8NyINMQZyhlN+my00M37I7Xo8uxndztaCllwoFzAk1jPW30buKvQ0zewOQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by PH8PR12MB8608.namprd12.prod.outlook.com (2603:10b6:510:1bc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 10:43:27 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 10:43:27 +0000
Message-ID: <137bb7bf-a7b9-4515-88b7-1a76f20c6433@nvidia.com>
Date: Sun, 22 Nov 2026 12:43:23 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 01/11] RDMA/mlx5: Enforce dev/mdev naming for
 device pointers
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-1-8efd124c7895@nvidia.com>
 <sashiko-outbox-221130@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221130@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f57d1f4-7ee3-49f2-2fdc-08df488570d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261102123227099003|261022105027099003|261022075727099003|261021121427099003|261028144727099003|261026121527099003|261026140227099003|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	l3TMHBkR2DKPTDJFaS4GkyOQWMQXOOkCzaQnOFhpr0bpd9niJUl04rFPDTqasaGIV40xndTEReuYEup1Nw45nKtde1ut+J54a9cvSlJo0dp7hMI8Uue8MlddXwhUSaNHkDxkxx3s8imEkO9RMlZdHXaadcMwbOEF97f5UJ06urBTssK6QqZZaZk6m1xqFSe6zAxnN1lgmj/lsKmvG8aybImiY6R3MZ4ag6QnedD77bHJP3kgGq3BxgXpL4qyJg3OJO6PHeiny9qZW8EVKam6e/bTk5vucKGZe3qbrOlqcOFxWuEvWy0Odt/RtR89BfHjKoUSWu8Aph7fDDVhBMG++WoJV6A3eOsEiJY3YrHYWniUuUGqjV7NeEsKcJaT0jagyueuEuR7wI9ECVzWUfLJXsZZU/JjFfCWqk+fY6LoyFQ9hphpsQofq+VlIOOQrwYc/ZlFulRBGsRHH2oAzlj0ebEPzbaM34aA4X8CLRgWjbaPNvgN0gVGsCGDN/7nOAcxgUhCv72DKKIM0dT/gflhFok3d781E9eBRwqjyLiy3ADyEhc6Qy+lVVqds/VdPuUkXKbD3R5vO/tdZe1HPFCa3H44qwz6jruRWtdLH5yWec1IEp5JsgS2V2WIB9MZ+yApI7/dDhwKFDm2wG7S6HF3BBy3gYoa0I1wa4PNfZ1T98s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261102123227099003)(261022105027099003)(261022075727099003)(261021121427099003)(261028144727099003)(261026121527099003)(261026140227099003)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmxkbmpIWTZQZEZHWkFqcVRqczluNVoyS0d0QUlCWUt2ZzR6V3hkd29QOG9U?=
 =?utf-8?B?aDVoYkVWYnVVZ1JoSytvUE5jcjBvTUJrLzF4dVdNbk4wMlNtWXNGL05la2RJ?=
 =?utf-8?B?by8wSkt0clhJeWJtSStDdzFNUmNNalY4dEZIN2VMVWlWYkcvVW44QkNDYjVz?=
 =?utf-8?B?VkFUdFQ1ejdlOGs2WGViT3pSRHdVUE5WZlkyRjM4QVdOUlVEVWdma1dFdjJP?=
 =?utf-8?B?Vlc1aTRpdTNKTlFFUmVlWkQ0eGc3RjlxcThlTy92bHg4Zno5eXhleWZJdWFi?=
 =?utf-8?B?eEIzUG9Rc1ltSTNTRW12TUhlU2lrZG80UllrUm5hWFJPNkFFaTFNaDc3TW4r?=
 =?utf-8?B?dmJLK25DME91L0RVUkRKYTA1ZjNaQkJOVXFNT2VTVHRqb0RHTFQzKzBaa0dh?=
 =?utf-8?B?NUZkTGJ5R0x1V212aTV0Nm9KU2gzdGtqNUQ3S2lWRExvLzJwWkZmeThRaXpE?=
 =?utf-8?B?RVV4VU9EaVlLaDRNTmt5MHpTc1g1V2xHOEsvYldZOEQxcTdDWHMvNDFXdm1m?=
 =?utf-8?B?T1ovaUdRY2wwaXRlVDJyUUU4S2tqVHhBYitlL1pzUUhWMHdZZXA5NkhHNHAy?=
 =?utf-8?B?ZmJ4ckFCelRLbkdseEhLMTArT1dTNTRhQVkyNGNud0ZmQ1FxenNMbGRnWVRO?=
 =?utf-8?B?YlRmcTFHQisxQWt4OVdjcktNa2U1S1NyVTl3YWtaK3ZkWE9UckJuanpTajda?=
 =?utf-8?B?a2l4cGN6QzlGWXBxNnRldXNSWUgzVG93WU0wSHNoejg0UXJTV2k0UlF0cUpv?=
 =?utf-8?B?T1ZnWlh1SkNGVVJWWkJWeUREU2dRSXZGQ3NVZzNxWjc3ZzJGYWhVSE5IM2lG?=
 =?utf-8?B?bjd1OUJjbWYyY0ZYSE0zaDcxVWlGa0QzdCtCM1hndDRzMGx2OHhTT3BYd2lm?=
 =?utf-8?B?UDlDNENJa01mTDBkMkxFeitRczg5QnNybVpkTG16Z1FnRUNSQXFISnl2Sk1P?=
 =?utf-8?B?b0RVc0ZLNkxmNFhLb2pHVEljWTdNTFN2TnFkVkNmK1V5QmI2czVvWU9NMy9L?=
 =?utf-8?B?VTIxL0tpNm1GZHQrbEVLbTFCVFB6TnZBMkFIQWtDMUhXTXRwQTUvQkxhWGlO?=
 =?utf-8?B?M2UzQXphNGF0ODdzeFRuNytvUjcvaktwbVhsYm1heUVNRE54aitZSTJrR0R0?=
 =?utf-8?B?OGFOb3k5TG1qb1RmZDdtWXpNSmg1aTNJb0t0RXlUeit6MlF0QXc0YkxCcFNw?=
 =?utf-8?B?ajJFeXlEd2U0WjUwSkdvZnVYUTZ5WWVPK0Y4SHppWW55TjY4K2tabXpNZllz?=
 =?utf-8?B?a2VCZlBCVGNnT1EzaERHL2hlVEFSOW5QOHBrOWtGeEVHb3Y0L25ON3FjWkh1?=
 =?utf-8?B?RlVkaGhqNzd1MDgyWTRPYmp1Z1pnZkdHZXduODQ1ZnNVVkY1aWZZaU1heG5N?=
 =?utf-8?B?bTRJTFNuQ1lZWlhYNVY0dFlTVEJrZnYwZGlQOXB4aG1TRUplL0QvdDFyK3VM?=
 =?utf-8?B?RFZ0L1ZOMjhaZ2x1d2JRcFJ6OEplRVlIOEJQL2RvNnlRZ2haRXZDaFJveHQ5?=
 =?utf-8?B?cEZ1cithdWIvdVBpM2M3MHdyWmo4TkdhTjFzQmpZUnQreDU2ZHZocEl5STA4?=
 =?utf-8?B?VTZ2SnZjMXVTdVdXWXpIZmZzRHVCQmRMWmdtNWgyRk12eGhIak00K2d0a2FO?=
 =?utf-8?B?N1V0UjFYeUdoYnA0SkxZejA4bDdqb3puUW5QK29pQzNGOHVyWDVNbUxwZ2dO?=
 =?utf-8?B?UE9pS2ZiQ1d2ejEzY0dwUzh6R3FQRHRZRk1XQkJKUVRiamRQU2dLcDl0OHZL?=
 =?utf-8?B?S2ptdGZNb3B6WU5uWUxkdHF3dGJRaHliTm8vZE1oZ2JMTjg5TVIvZDNCRElQ?=
 =?utf-8?B?NG5lcS9XeFZibUhlY2daNW9UK0FyMXRGSC9OQzZLYTdvRE0wV1pzV3pYTTJx?=
 =?utf-8?B?MHBySlB1OFR0Y1VqYUZhRTFQdFh6SGdxTWZsMDBEM2VIWk9YK1Y3WWxNeWl0?=
 =?utf-8?B?cU5yck9tWTM0enpQbzkyN1BFSlZNZnZaTWhnRFkwWUdNc0FTbzMyWjR6cVd0?=
 =?utf-8?B?Q1dsaE11WjEyTm9rcStSRDhua0tvK1MzM2VvSXhFanF4MS9wbWd3Y2NSVFhz?=
 =?utf-8?B?K3FNZU5EZE5xRUdDR2l6RTZrSWRGRlpCdEhja3RWN1ZzbHdXQ0t3U2I0ZU0z?=
 =?utf-8?B?enFZVk9qV05WWXBMVnQ2Mmx6cFcrNnByNUpvWWlaaEdpSmJhYWkraHo1QUIr?=
 =?utf-8?B?c1BHRjU4aUx4WEtKKzhsWmNiU3MzSGRqNlh6cHBJVk9hejRjdnc3SHNlbWtq?=
 =?utf-8?B?WElkN0RFblFLOWczNnhvTlFpcXBDcXZUY0ppNUtST2xUdUFLQjl3eWNUWE1o?=
 =?utf-8?B?VlF0NGl1WkI5a2RWUzBDQjlRbE1mZVk2em9VWTF4Uk9HM2g1dGlZUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f57d1f4-7ee3-49f2-2fdc-08df488570d1
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 10:43:27.1634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rb3ujDU6l183ZRW02QEbVpy35He1ktcVFr4mNF2BanqzOztqq7M+7ZfonZaexQb2uS6K+ljFQDDkjpFQ/t1E9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 2 related pre-existing issues it does not
> introduce:
> - [Medium] RDMA/mlx5: out-of-bounds read in devx_get_obj_id() on short
>    commands [1]
> - [High] RDMA/mlx5: deadlock in mlx5_poll_one() [2]
> --
> 
> commit 3bdcdff9fe049e25d51894257ec6c6716c3a9770
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Enforce dev/mdev naming for device pointers
> 
> This commit renames variables, parameters, and struct fields across mlx5_ib so
> that dev exclusively refers to struct mlx5_ib_dev pointers and mdev
> exclusively refers to struct mlx5_core_dev pointers.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index fc6f793dcc658..7e84dd15ac1f9 100644
>> --- a/drivers/infiniband/hw/mlx5/devx.c
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
> 
> [ ... ]
> 
>> @@ -1652,7 +1652,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
>>                                                          MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
>>        struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
>>                &attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
>> -     struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
>> +     struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
>>        void *cmd_out;
>>        int err, err2;
>>        int uid;
>> @@ -1677,7 +1677,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
>>        MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
>>        devx_set_umem_valid(cmd_in);
>>
>> -     err = mlx5_cmd_do(mdev->mdev, cmd_in,
>> +     err = mlx5_cmd_do(dev->mdev, cmd_in,
>>                          uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
>>                          cmd_out, cmd_out_len);
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but can devx_get_obj_id() read
> past the end of cmd_in [1] when called from
> MLX5_IB_METHOD_DEVX_OBJ_MODIFY, MLX5_IB_METHOD_DEVX_OBJ_QUERY, or
> MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY?
> 
> The uverbs attribute spec only enforces a 16-byte minimum
> (general_obj_in_cmd_hdr) on cmd_in, and these handlers call
> devx_is_valid_obj_id() -> devx_get_obj_id() without checking that the buffer
> is large enough for the opcode-specific object ID field.  For an opcode such
> as MLX5_CMD_OP_MODIFY_FLOW_TABLE, reading table_id in modify_flow_table_in at
> byte offset 20 performs a 4-byte out-of-bounds read when userspace supplies a
> 16-byte cmd_in.
> 

devx_is_valid_obj_id returns false if the obj_id doesn't match anything, 
so a short command is simply rejected. Maybe it's still worth adding a 
length check, but not in this series.

> [ ... ]
> 
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index 65455aedd559b..1ecd79929f8cf 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
> 
> [ ... ]
> 
>> @@ -4483,7 +4483,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
>>        atomic_set(&dev->mkey_var, 0);
>>
>>        spin_lock_init(&dev->dm.lock);
>> -     dev->dm.dev = mdev;
>> +     dev->dm.mdev = mdev;
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can dev->sig_mrs deadlock
> in mlx5_poll_one() [2] because mlx5_ib_stage_init_init() initializes
> it with xa_init() instead of xa_init_flags(..., XA_FLAGS_LOCK_IRQ)?
> 
> Process-context callers such as mlx5_alloc_integrity_descs() and
> __mlx5_ib_dereg_mr() take xa_lock on dev->sig_mrs via xa_store() or
> xa_erase() with local interrupts enabled, while mlx5_poll_one() takes the
> same xa_lock from CQ interrupt context on a MLX5_CQE_SIG_ERR completion:
> 
> mlx5_alloc_integrity_descs()
>    xa_store(&dev->sig_mrs, ...)
>      spin_lock(&xa->xa_lock)
>      <hardirq>
>        ...
>          mlx5_poll_one()
>            xa_lock(&dev->sig_mrs)  <-- spins forever
> 

Right, there is a narrow deadlock case with softirq. This should be 
fixed in a dedicated series/patch.

> [1] https://sashiko.dev/#/bug/linux-2b4a0b34-fea8-4d2a-87be-350c461b8f4f
> [2] https://sashiko.dev/#/bug/linux-4a13b647-d8f7-45a3-8a1e-c17db57fefbb
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=1

