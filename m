Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795350689;
	b=FjA22aF/EMqJSnZpigLQguKX5HcKuT1dJGwXzjyODMXCRbFDLKVmhfIjnRGauZ64w3pX
	 5e2UjHBpRzsooG1rFG7t7extyxJSf2hpyEeSL/SQ47lHGVRkECJILYgA4C8kmpuHW+lTl
	 hRFXc+4pbULY2ZEDqkUORSBuPbsIXKU5fpcBZIlMYVqDeaaRIVypKenahXZb1xFxPne9W
	 bAltChBIAJDjYy3a7FQob5V2/lyEWKwbirzjGJMEqH9rJayE8QaJzC2FYgxnj2hzht+RA
	 XTPZtCZS4qSepZ2aWb3EZS23YOZ+BezHomC+pHQ2P+YlOCbAwklU83Z+ova5CDgRYsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795350689;
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
	bh=78WlRQFq7JRcyOwkYH0yCgIYQ5YiPbnkUkMBte3tVrU=;
	b=r7Z1ywu0qB6qkOzXOhkoc91PscNMRd2nf2Ox20iPZBMsZ7QszqfYasTFSGGdpWyWyXSb
	 aIupaG9roTpQ4s6eu7H+KFuOYW9LjzW12u3O+UmGVWlhe4nkKnJr2YycVtoUQXkm9yKKE
	 vrLRviEIyt/6HgzSwXWrgwcAxCO3VsgkAk5dqDe9C+/S7Qf1WCGKk2xZr4QrtJWNPlXhX
	 a/56M40dewLtsLoqJNY37GLxwkBLORApFwDQsxQxZusa6sYXufOmq+0VSTKEArRzHFC1x
	 CJLiNTha5fem3NKWdcS+JqwOPcMQ0wOhjFuqGf61U6TZEDvT2Gx2PI8kWLvDN2q1cxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uGUEAHm+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.11
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012011.outbound.protection.outlook.com [52.101.48.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC211606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 12:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC211606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uGUEAHm+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fguPQ8eOqISVMrrzXo/ry48+iTFTSrWEe3xqugoiMZDTE59t6pezSWEQQqrJQ8MU1DOjWNpTnqQpwFmuPfvkubimm0Kk97zdfuA/IEfQyXiiDlf9KI/WC+yALm4dDWkvhIPh9PcQ7eF1bxoQ0OwbDJ1y27nMn1Rd36goiPKBNawrdUdvW7EGyyS0PJf8GVJ+OMkXkquKzKNznlEF+65+WfQS2TdoRVX28a3QB/xKUWxsOZoqMlusXiliN+/alW2gQoqQQLFalxjCmkDVOpyxWVHDnUhiXsvjP0ypz7/VQWUZUV/R45woZBLziaXS3pshqcnarKNT9eap5EOXsDJhqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78WlRQFq7JRcyOwkYH0yCgIYQ5YiPbnkUkMBte3tVrU=;
 b=wAuKhhb86JaewLc1T9CHLyEJWL4It/oVwzO9ALleN/Cmw4Zf+jQQXB5CPAQUoSKp+tTJMJlCbXYctJkoo0ngyV5d8ZpVrPMMZ9CpZOze/iXJr63io864s8pJny3sG18NSwJt4RmynMk19E3kFh8O1DP7ZqfYGIHU/0jz1+kenheKE0FTbItChEw9rzW8UB29NcE4wBJb/sWKMFPIPMteKen/4FyKdo2W/718db6SUr3H90tHmXMFs1BOUkB5XjEY77jP/b6wQTT8Z6zh14WSjqgd+hnuK57E801J61D/FFFSkI0SJlj8JCDbwkATnjDI501rWrGbkuvJQZYu75Ix9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78WlRQFq7JRcyOwkYH0yCgIYQ5YiPbnkUkMBte3tVrU=;
 b=uGUEAHm+ZS+JA7VnVBI5BItEHnP620mZuyTXzwzsWS6MKC7KW67NLewoX0p91Ad8+zVywWTabZOX5hTez6RHzdLJ44UfctESLZvoWw6ZqDx8MxkpbE1v8EB9SNfn1KUoGSVfOwP8s9ZVnZJlrFJ+X+eLu4yaL9ny6ieMEbU+7hPI8nnRxXy81qZUmm6Nvdl9EOOts0PgzHBE/GVt+cyy8CV3xUXC8vNmzUTE88gP+cT93H/uD+v93Fy5ygyyuigv/lNBhngvMdMNQxXQ9xL2lt3qWep9Ng8plOPcQq6og348PZ4jD+0U2Vrq4uiwW2WLaput75QTpRMqwuhuuephcQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by PH7PR12MB8015.namprd12.prod.outlook.com (2603:10b6:510:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 12:31:22 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 12:31:22 +0000
Message-ID: <88751677-6649-437a-b221-8492c017f466@nvidia.com>
Date: Sun, 22 Nov 2026 14:31:18 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 04/11] RDMA/mlx5: Select the core device through
 PD for QP commands
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-4-8efd124c7895@nvidia.com>
 <sashiko-outbox-221133@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221133@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0020.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::9)
 To BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|PH7PR12MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e60b0d-98ff-4327-6092-08df4894841f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261028144727099003|261021121427099003|261102123227099003|11063799006|4143699003|56012099006|10067099003|261009223027099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	FFVtUCCS9wd4zSbDh4C1ZMoE9Ljgo5YAJ8PEPNoHuEXRC+wtjOX/X3b/mGXp0K1DTvTmFQQQJjlg7MjW8ZcwNbojApH/MD5nrzizJVGKrO5TYEbhpQZY5zN8paNMhAID/IrNSCd5gf3BGMY+kTL8Ua3hVI1W8IhoTJa7FVAI2yl8JXMMwBD3lwB2d2ujVj5cY0OBQr0XBrFFHEhTedg7e7JrlS+7tWmOSW8VSlpIo8vowSZeST5IhpQ+5ADdJ/ty1ya8JbG4owF8zDPWWh8Rmaev/rEegw55eFjALz/u3hqiNky9hj9oHrIZ46sWcLpn15UdfZtB3CvTqeuziEpp1anTp+OhdhVxyEgn0fzwF0zlNfhtBYMukLKxQujoJnm+fLqVWDFIjqtz7RfXGdH3QIxkX7DojtCk33VmxLA6AwrA7HytqNb2ezKMHsBAlwaP4h7s8s+8LIgxd/d+BvwUQcLvXMnp6mDqXiQeDzdd3P0Qk1zoqPN9Ln2y6hhbmGaDObrJT95L3o0Wy9JLNxf7pl+oTsQHqHXX1i5Ijz8H2QyioAbLv8o4/L1BId3r31j/ZN1wYinvTbG6nzg5QQugsYeb/DB6lTk+WNAMqpPvQjOvSjyLGLRaLvMY3ZLmLO+uLrvs7pVaLWOlgCYWRzLT4fzVc/G1cyX+97c7zhb6uTs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261028144727099003)(261021121427099003)(261102123227099003)(11063799006)(4143699003)(56012099006)(10067099003)(261009223027099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXVzWTFsb2FtZFpiNU5UeFVPanF6dXBMK25CZzY5VDluREpIQWd3WnREL2Jr?=
 =?utf-8?B?MUhOZkd4ckU1emV6V2J5VjJDb2J6M0E4QnFzK1o3VERmNTc5MzZ6NDN5WFZI?=
 =?utf-8?B?NE5RWU03ZXBQbzlqS3lpQWR5dzNvYTFQa3l2SUJib1pYdGR3clFMYi9TVVJl?=
 =?utf-8?B?cDFlUnByRmNZZkpQVmlJQ003V2NZWm1EdWdnVGh0SVpCRit5UEZiUE92MWpx?=
 =?utf-8?B?WkFaREczYnpVcVRVNzdZQTJqS3BUU1ZoNUg3UklpSDhwdHhsYnV5a29pL2xN?=
 =?utf-8?B?WnVrbnFMWlhnSVRZTWM0Vldld01OYnFQTEpRNzlHWURWSkpiZll4TmJ0ZkZa?=
 =?utf-8?B?MC9YUUd1VzEyV0FrdEFPTlNuM0swSUx4NnJXTXdxZjloZ01IRGZnMDBJTndj?=
 =?utf-8?B?ZjJyaUo2anBCVG9lcWljbGo4anhMWjhkeTdHN2ZIRmpLb3pxY21IQktSYWgy?=
 =?utf-8?B?UHFTcEU4d0lqcXF4cmQ3OFJCVmhnL1Q2bmx5VGtFSFZKYndPRG1DalplMlZw?=
 =?utf-8?B?VUdqb2hTdmc0a3hKeHFvUXFsM0E2VmQrVzlEQm9yY1Z0TC95a0tHTE1XSmg2?=
 =?utf-8?B?N29BQjBSZDVOZGRRbEhaZ1c0MDZqV254SEo1UE1uR3JrOHI4UUpYNzIrZ2FR?=
 =?utf-8?B?NFBSQnRkVjFlZmg5TEhLaGhLb2hlOFVyMnczVDJ4c3k5Qnc2eXRVc0dFMDNB?=
 =?utf-8?B?SnJiZHFpNGNyODQ4NnhiVFRLNk5FeThnQWRKUEExT2xrVUtuS2N0MlNDNkM5?=
 =?utf-8?B?VWpSd2wvcXhiajVRcTBTNWNONlNLUFgvRXNLcEVLdzkvSXhBbUFZUTYyYnpR?=
 =?utf-8?B?TGhLNk1WU2VtSlJGdEJkTmtlUFBESHNxUk01WnFrQkRFQVZHQ0kyV09wVG8w?=
 =?utf-8?B?bjFXZGhnTmpPa1ZENE5rNXlCV0pnbHE2TEhwMVg2eTNwV2YvWDhBMjdzUmlm?=
 =?utf-8?B?eUpVcmFQKytQQWVQUGVUdDVwM0toaFlrZVRlTjRoUTRwMUFNcDFnM1RXdS9p?=
 =?utf-8?B?RUVvZ3cvWkFlZ0dwK2l1ZHh3SFYxb29xMG5yQ29wMXh0YXhLdlBjSEpVeFdi?=
 =?utf-8?B?aFpla1Z0bEFZb3FVWFdRbk1Dd2tZOFZRQlFERTJyN2J1ZFhtQmZvb1N4MndR?=
 =?utf-8?B?OE0xYkd0WUY4dFpPUnJvWlJGSmpwRndDb0JPOGdlQTQrdVlOVC9KeFlGYzQx?=
 =?utf-8?B?S2VUMDVYemFoUHJuZXkrRU03TXlIaW9WOGZlZnZZZVZHdGNuS1F3bEJ6T1No?=
 =?utf-8?B?aUVuM29FT1NHeWxhSWQ1LzN3QmljNUN3ekFDcHVXOTR4MnhXdGtnbXdnWm9H?=
 =?utf-8?B?Sm91RlU4R2x3MVM1NC9Cbi9vdmxuZHpRODN1cTUvOHFNTHNVWVFSYXFUVXE4?=
 =?utf-8?B?TkVsVWNZSEljMFdaR2xLQTZ6eUtLTWFtOUMyUHlGbUpsbEhwV3JWOXN1WU1h?=
 =?utf-8?B?QURKVEk5Y2R0bTNSTkFiUEYwb3pqZHl6WE5uMEVpbjhTZFp5ZnlVUEx6bGpU?=
 =?utf-8?B?ekdUU2dYVC9iamtuOTI0UHowSWdWei84Vjc1K0ExREpzRWJ3OE12eENkMnhJ?=
 =?utf-8?B?UU01dCtuYnd3SU44THhKSWExQXBOemZpSFA0aitvZXVZcHdPSHBYWFNPYSsy?=
 =?utf-8?B?bDBjVVJOS0hnSEdEdndQVjFMcXpidlhLQlQ0RkRvbmZ1MzlrcVZmVFpRTUxM?=
 =?utf-8?B?aytwREpNcXloalplV2lqTXpmaGJ5aW1GazBPRDlvZUk5ajJXNG9veTJrZFRN?=
 =?utf-8?B?ZGFsdGhpSElYNlI4dHBYUE5zZE9oUjN2VEJSNjQxMkJLWTJUalF6N3kwUVAv?=
 =?utf-8?B?K3M3V0JXRUdnaDNzbGFPZ3U3QTlDRnpLQnFoVTIvUW5oK1lWNlh0Z0RUTjc2?=
 =?utf-8?B?a1NEWktqcEE2Z3l2RVFFTlovc3NQcUF3TGlHSXJqYlVocEU0eEcwUzZqWDVK?=
 =?utf-8?B?T096aXc1TzBkQ29aUWo2OVduWmVIV3BZMW5sS2NScXVQeDBRdll1eU00Z1o3?=
 =?utf-8?B?Q3VjdHVrNVo1MzN2Z2tXVDRYTTF3YjNwK2xWTFczTXd0TWlaenVIeVZqM3Jk?=
 =?utf-8?B?Y05zY29VMGtyMEp4V3U1bWUvMlZvT1JwVkxza3BodTBtaUtTTGFaL3l1SE1E?=
 =?utf-8?B?TFhueG5XYVpWUm53eEM2NU9VcE1tZUhGZ1BjTlpVd0Y0QkdHeHQvMnZtN3l1?=
 =?utf-8?B?MjNieHQyZUNLdGs0YkI4SXlVZzFuSHNPL0dKSUVJUUhOeCt1WTMvUHhNdGVv?=
 =?utf-8?B?WHFFbnp2NnlCVDVrK1ZlT3c3RVRNOURBWEU4aG5LVzFJV1RQV2Uzek5RSUUw?=
 =?utf-8?B?L0xaMGhOVzlsWUVpbExWMjdLUDVRUm1uVUdoWThtek1jMEJ1OUpPQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e60b0d-98ff-4327-6092-08df4894841f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 12:31:22.0993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCe0MjotUXf0dtrX8azWmRWe6dWZy2a5CWn+kz2Z7G0QMx+2rKTnMGQyour9DkqT+GpaOhfm8Xv1tnqOXBW60w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8015



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 2 related pre-existing issues it does not
> introduce:
> - [Critical] RDMA/mlx5: unhandled error in destroy_raw_packet_qp_rq()
>    causes use-after-free [1]
> - [High] RDMA/mlx5: unchecked to_ib_qp_state() return in query_qp_attr()
>    [2]
> --
> 
> commit c8de8977935b4bc94238c72869a744ae61d62546
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Select the core device through PD for QP commands
> 
> This commit introduces qp_to_mdev() to resolve the core device from a QP's
> associated PD and updates QP, RQ, SQ, and DCT command helpers to obtain the
> core device from the PD or caller.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
>> index da4e9a52d2f9b..2196e06f593e1 100644
>> --- a/drivers/infiniband/hw/mlx5/qp.c
>> +++ b/drivers/infiniband/hw/mlx5/qp.c
> 
> [ ... ]
> 
>> @@ -1526,17 +1525,16 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
>>        pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
>>        mlx5_ib_populate_pas(umem, page_size, pas, 0);
>>
>> -     err = mlx5_core_create_rq_tracked(dev, in, inlen, &rq->base.mqp);
>> +     err = mlx5_core_create_rq_tracked(pd, in, inlen, &rq->base.mqp);
>>
>>        kvfree(in);
>>
>>        return err;
>>   }
>>
>> -static void destroy_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
>> -                                  struct mlx5_ib_rq *rq)
>> +static void destroy_raw_packet_qp_rq(struct ib_pd *pd, struct mlx5_ib_rq *rq)
>>   {
>> -     mlx5_core_destroy_rq_tracked(dev, &rq->base.mqp);
>> +     mlx5_core_destroy_rq_tracked(pd, &rq->base.mqp);
>>   }
> 
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can ignoring the return
> value of mlx5_core_destroy_rq_tracked() in destroy_raw_packet_qp_rq()
> [1] cause a use-after-free?
> 
> When the firmware DESTROY_RQ command fails, mlx5_core_destroy_rq_tracked()
> re-enables the resource and leaves &rq->base.mqp in dev->qp_table.tree:
> 
> drivers/infiniband/hw/mlx5/qpc.c:mlx5_core_destroy_rq_tracked() {
>          ...
>          modify_resource_common_state(dev, rq, true);
>          ret = destroy_rq_tracked(pd_to_mdev(pd), rq->qpn, rq->uid);
>          if (ret) {
>                  modify_resource_common_state(dev, rq, false);
>                  return ret;
>          }
>          destroy_resource_common(dev, rq);
>          return 0;
> }
> 
> Because destroy_raw_packet_qp_rq() drops that error, raw packet QP teardown
> completes and frees the enclosing mlx5_ib_qp.  If an asynchronous firmware
> event later arrives for the undestroyed RQ, rsc_event_notifier() looks up
> the dangling pointer in the radix tree and calls qp->event() on freed
> memory.
> 

This needs DESTROY_RQ to fail in firmware for it to happen. I think the 
"Critical" severity is overstated.
Looks like it was introduced by commit 5d2ea5aebbb2 ("RDMA/mlx5: Fix 
error flow upon firmware failure for RQ destruction"), it needs a 
separate fix with it as Fixes line.

> [ ... ]
> 
>> @@ -5122,8 +5123,8 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
>>        if (!outb)
>>                return -ENOMEM;
>>
>> -     err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
>> -                              false);
>> +     err = mlx5_core_qp_query(qp_to_mdev(qp), &qp->trans_qp.base.mqp, outb,
>> +                              outlen, false);
>>        if (err)
>>                goto out;
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can query_qp_attr() store
> an invalid state in qp->state [2] and cause an out-of-bounds read
> in ib_modify_qp_is_ok()?
> 
> Just below this call, query_qp_attr() assigns to_ib_qp_state() directly to
>   the u8 field qp->state:
> 
> drivers/infiniband/hw/mlx5/qp.c:query_qp_attr() {
>          ...
>          qpc = MLX5_ADDR_OF(query_qp_out, outb, qpc);
> 
>          qp->state = to_ib_qp_state(MLX5_GET(qpc, qpc, state));
>          ...
> }
> 
> For any hardware QPC state not handled in to_ib_qp_state() (such as
> MLX5_QP_STATE_SUSPENDED), to_ib_qp_state() returns -1, which truncates to
> 255 in qp->state.  A subsequent mlx5_ib_modify_qp() call without
> IB_QP_CUR_STATE in attr_mask passes cur_state = qp->state (255) to
> ib_modify_qp_is_ok(), indexing past the 7x7 qp_state_table[] array.
> 

Practically can't happen. to_ib_qp_state() handles every QPC state value 
the device defines (0x0–0x7). MLX5_QP_STATE_SUSPENDED in qp.h isn't one 
of those QPC state values. It has been there since day one and is only 
used for a debug string.

> [1] https://sashiko.dev/#/bug/linux-314256a0-4860-4700-943f-7cc6aed26289
> [2] https://sashiko.dev/#/bug/linux-05b234dc-14ed-449f-97cf-d7b4682a7a8d
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=4

