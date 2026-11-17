Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794914470;
	b=EaNX6VWu0KKSBedp391my5TsRm+qJIMhpMsXxAspSA1aAmQXFzpo4tDgRnCsvocOnKtO
	 00m2FQc5LJOpWatjbLXtIecgQ9NCAXc2sxMLD2f3p7OLEWUazu2lRydIz/ItsdvCmEMj8
	 7nqmV8evpRZNYwE09bZO4subtZUi4o2vJ7zY83Ob9z1wVN9HOEUaDC4cfQPURzczsOzYU
	 hTb2/0hvoAqijwo53z+lWtn2PM+pjhjGYiahw6SJZkCiVcxH7dUExINykRbpqKTVpgkzI
	 KOS4fXyD0jYz0N4S9fY2ttp2xIg64X5ddal6oyy7P/+bV+NYyRh3YcDCFykQy/HjNjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794914470;
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
	bh=Gd7FYFo8njyH0x+Kz+cwp33Q26sxyxVBUrukt5YkBqI=;
	b=z+7MCleSxKj4C2QpRoirYCBQov3gwoz4Gq59ltXwCv9Yi9+e1C8hvzjuUAji6cgjDqGe
	 N0a0CVQY/yJ77fy4mTBTAXatsvh9uTu/Ip24tKbqrYBrNxOLxJDxV8ASQbzR2oC/PrVrb
	 DU5/i1xrlRiRrzsQrZr/zwMOtP/vooT5rGjo40Kc5fgrPl2AXIUzP8rRXtXvSvaeuSJN/
	 VCb1eEWsklqY6pmjsWyxt0nudDC0jfP6KfYKW8WZIZoThqcTvHEALwAlwVYi/PYVHZR0U
	 cw1nU3nTl31s4vjdu7KwS9f+XoH+137yTsWYUaT5GssjF0m4uPU2BygEqt49Rwcg63g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ewCY9S2k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.11
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013011.outbound.protection.outlook.com [40.93.201.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DABB606A32A;
	Tue, 17 Nov 2026 11:21:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DABB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ewCY9S2k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnKAMZcxMG72ALcqNlsi/ykCvnd71lg1ogH3hIRd27WdDhHXRjtcBHgj3D8IgRq461aFnmNuFrpWuF58RUNrOSmaUEILM8xI5oxMcLlkHB0IBzWx7+dhdD7hkViAM7OUeBjH5b0jXT1IIwOAnuquFMocZ6SfzSZMC5+YzohbFO5OqYMDIayo9Fz+hvLboPx5vw0fL7yrKN1065ya5Bn1YO7MsqyMsYWjsmYbEmJF5X6GGdOrVezNHGTF/Ai+4PPfb8GpeOIQy9Pbc1D32cKOpefZeIC+oVG2AoNKbuz35hjJlfq7rqxlxLvShTEmGFzp1C8/+YVBKckuL1iCPRkbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gd7FYFo8njyH0x+Kz+cwp33Q26sxyxVBUrukt5YkBqI=;
 b=A/MUYJrDmmT3eozj5dyxjWTn6h4x8lvhN82DuOQqMr4rAAQwdzvk5+H9Jw4KOvuHeWce+fxtlJHaLrGksqnsaF+uQc1qgFhN8RKJALr4PYTDr/lfwnwL/yXgL1eMpqby4VVRUIX5X/IezGDBr1PiC76BtiivIdj41FJLvBm+BhV6wjYIySGYpOwVYTsd9Gp6TRFylEbZpI94ERSe+6MGlxkuJR/rXja9HWgIayor07nU6EBcR8d6DEeP4jLScrMEt0q24rok5ykiiFOzijtEp9tHY6C7MDulcKQGlhBS1rzrKDnzCr/38EVShQrsm9Cm3kHnecQ77CKpaL/vDFOPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gd7FYFo8njyH0x+Kz+cwp33Q26sxyxVBUrukt5YkBqI=;
 b=ewCY9S2kGwUPXSrP8uzLKv395NqqM0CtvGszwFHh0016RwhydTqryYkGKQp7NHp3n9VOfNpzJ3D3bDDkaw1Z6X9YoVpG5s5i4Wqru1VGxSkrBU/hbv/V2Nl5oTrNdxKWLSHYtjHP1HK8YencR+5vOmlrLYR20HBU9844UjMXdUYFauRJdi0IHtPyai4dkAIgY3JykIO2PSvZFFutVm+gZWj1NVUpzDCmKiZKostUPqAZtAaf514rkynEd/ZJtZVPmxq+5gZFT/+3dgpO48VdzyUootzhxy5B3sO4yYkhetx53CZQvNkLc0MzkU8sqBNrOQ+eDFHlMOzTdvYR6xBiSw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by IA1PR12MB6308.namprd12.prod.outlook.com
 (2603:10b6:208:3e4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Tue, 17 Nov
 2026 11:21:04 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 11:21:03 +0000
Message-ID: <e4ae51c0-8041-4ad2-811f-cfe8fa1a092b@nvidia.com>
Date: Tue, 17 Nov 2026 12:20:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
To: Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
 <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>,
 Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
 <almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>,
 Bobby Eshleman <bobbyeshleman@gmail.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-11-tariqt@nvidia.com>
 <20261115101720.5fffb5eb@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261115101720.5fffb5eb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::16) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|IA1PR12MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 31303060-aed2-414f-d89c-08df449cddc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|261026121527099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SDM/n/e2Sq9KHg2sdZc/HzKanfiMPCuGXlqcWQa7v+52ArgtDRWFuhBtoSuJlkjgQYRAZct5j+jNQZmPB1xuJL7KEhyazREtrSIMkn/SsSTeT3ymAFeCaKEv49BZBQK3am1WB/BQ6SA3pKKLs5r/rSONwkxMJDUnYZIde3XnWWZOpa7bjyp+wjqdUrwVBVQi5p8O2tEWyouqZoWh4QNaZr6JDH/GcoihKdsNCpLnbK3JOgrxFf6xBfgr0nxIx6xlyp4P+dlutlnspoOQk8b1nNaHgA245vFhZ7tQx/2WUBA1uUKIednFkGPLjDuI//YyVi72sAi34QlUFzHabkLmNbxrGvsL4KPiYdwWbMh0X+NlvpNJnP9QBAhLKQBD+/bNAn9ZLzb4rUc9W3+AuAN/jXKrD6BdlwYuG7cxpYPEetUQ/ZrqWAoOqNfHohOKA0kaw4nXM7m4N7JHugVlo8JYizA+gSxoG+z6qQdzQl0kzOSu4UX2wLHIa2tNnFg9YfmaityGWaTd3AfghoVF/pK0mnxB28DHN+zaY5ArPsek2TFew2M/K5LEHUlnRbnQaDMbDB7oEyowJzSDzJfgr0YWrEJ4lDZ4DIDxYJBN7xrsGeGNoClwRnAaycS5JTRHBugireOIoxNJvsSW80Ws4wS+NYY8heRJY64NMWa5Px1gOys=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261026121527099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SCtxOUsvNVEya2Jsb1o5Q3A1TFdId045Wk9nYkhVN2hiRVhxYy9BTEwzWktN?=
 =?utf-8?B?a2MxZTg5K0lkVlNoQ0RTeGVidlU2TjllbzRVYWIyc1lnd0hxa05USm9JYVhv?=
 =?utf-8?B?czFheGVGMFBsT0cyenBwZ04ycDVtQ1VDelNYL1FIMTB0a1Q2dzJBdTJhdHV5?=
 =?utf-8?B?VzhGdldrZEs5R0d2Rm1FVWp1RmVRUE5vT3ZneElKQUhnT1FaVXA3QWJ6WmZt?=
 =?utf-8?B?S0U5Z1huMmthdElGbWxZUjNGV3FPY3JERTFaNFMrenhzVHJabHloZjVCSEJB?=
 =?utf-8?B?QWx3QXkvQ1gwYWIxZHhla1FCT0FWeVQ2dVd3dStUMkJRczZENjZaSldFS0dR?=
 =?utf-8?B?eHd6aGlUaTZZanNxWE5Kb3pmRlBLL3Q0bXR1UnNPNDBCWVZMM3RPd2xVWUY0?=
 =?utf-8?B?TjNnMGNpYXA5Y29yaDdlaGFma0xZN1QvRTdHbXRzR2V2eUJYRCttOFZONEJz?=
 =?utf-8?B?V21oeFQ5dEZRSGNCSmFraHhSeTVjL0NsZzhUUlQ1Uzl6aEYxc3IvbU5CZ3Rx?=
 =?utf-8?B?NndmdnB6eld4VEFBZkJNNmNZa1Y2d0QvZ21YVStFVGlEVHF2Wis3dWhCekY4?=
 =?utf-8?B?OWtBRGs5RTV3L0pxUjhSbFYwbC81NFYzb3g0dXpJRTdkZldWalRMNFJLT0h1?=
 =?utf-8?B?TCs3b3ZGQjJqUXlrdFhsVE45emxuVEtNS0ZqUlJjQlJSYkgxbGhHeEkxZ1JK?=
 =?utf-8?B?enhDMjIyMEgxVFN5ZHVaSHZjLzNGUWpRZngrcE4vcSsvV05QREwvZEFHYlZZ?=
 =?utf-8?B?Y3NIZ0FyVlU3c3RCQlA2Yk10ZWZFRHRkNXkyUHdyZG5YV2M0YWpiTXBFeXRt?=
 =?utf-8?B?cUpTUmR4WXZxamxzTzBLemhvVWQwdUJad0RZdnJwd29iaGh4NGtlbGRPZmt5?=
 =?utf-8?B?a0lBL2tFQ2dxdDJEZFpBSldJODZPZXk0cUtUMnlNdWdiNlRsK2FnUis5R1M4?=
 =?utf-8?B?cGYrb1RmYVhmMUQ3ZUs2eWV4cFNZL2RjTDMwOWVib1Q2bk9MbTMyNm9tUVNZ?=
 =?utf-8?B?a3FLSjlFR3IxM3dYdjllWlBTMnBmeUhDaEF1T3JxQ0tWcXkzT3o3eDdjOFp6?=
 =?utf-8?B?eWpkTjlES0FkNktCcEhWSStiUEpQNFpFQm54UG9ZajZzclhnNTNIS2txdUQx?=
 =?utf-8?B?Vyt1ejNjcEtISHEzbFU0ZHJqZW14MjRvT3VHT3lSQlcyUXhvaUNTSkZxL283?=
 =?utf-8?B?cnJHVGVVazFzOUppRG9CUExmWWgxZHpDVHZEUlhoTUpKeUtwY1dCcHR1UzFy?=
 =?utf-8?B?M0ZJeExIQVVZWFZLci9tNHNGbTZrRjFHYzlucCswQlY0U0pMOEpOTkY0MFFq?=
 =?utf-8?B?dDhhU2FIRDVKZDRWYjlmdjRKOXRIOVpMcm1BM2t0M0MzN0tuWVJtb21SNVk5?=
 =?utf-8?B?L2d1eENxUk9xUTlYTHdFT0FMTVh6ZkJOeEp0YzA3VjlUV1FTSG51NmJxbmR0?=
 =?utf-8?B?SDQrM3dpQjZXR0lFL2pQT3l3VHBZZCs2blMzV1l1Z0tSSHhsTHYzblBJRTNk?=
 =?utf-8?B?Y3hDa1VvOWtEQzlLRk5BREFPdTk0aTloOE9RdzhyeXBuQVdKS3BhZ0JFY1I1?=
 =?utf-8?B?dWQ0WUM0eVViSHhHcUhkVmtzLy83UVNMQ2NHcTZZQnVLR1VDeDhSRFNkM1d3?=
 =?utf-8?B?aHF6TDN2cjAyQWIzRVJ4RSsrSzRMY2ZjYkNjdFJ6ZmlkSGVIQlRLTmc2K0lT?=
 =?utf-8?B?SzZsV3hna3BlaHlPZkt2dGRFK2piK2d0RUNhSmNiT2txeWlwc0RLclprNm00?=
 =?utf-8?B?bTU0TTQyTm1iWDY2QThlUDNvUm1wdTQxbTNWQTRwa0xvT2UwNVl0eE9KNDNE?=
 =?utf-8?B?VmszQW4ySklvVWdiemluNkMzeUxDTHVrRjJGQSt2UysyZ0w0TEJXWkFTcHh5?=
 =?utf-8?B?ajJtNnNXZWQxV1dKOWM5cXcya3hvdVg0SDEvWEU2aC9VS2QxT29yWHZiV0RQ?=
 =?utf-8?B?Qjl6anRKQ2YvNmNkaUJxRElyb0VxY3JjWG5NY2cxa0phQ2xSRHpHSTMyYWZI?=
 =?utf-8?B?eCtiMnJhU2tKZTM0RWYrVDl4UElxcG1DeXp0MDVEczI2UWtxaFNCejhVWm80?=
 =?utf-8?B?bXE5SlI2emZsNGVnVUtNOU9wNXhKVDh5YlA1UFZKWStOaUt6bUJzbUFDNWJ6?=
 =?utf-8?B?bVpwNE5MWGZYOFc4MnJkZ1BIUURoQ2ZKSXlSd2dmSThKeVh6ZU5FU2x2WGVM?=
 =?utf-8?B?UUUxeGg4alAvWFdMRVc0eHdYNDA3bW1tU0w0cWVWNGl3UnY2NnFnOWRyNGlU?=
 =?utf-8?B?aFFSbHFHbUhFRDJSdUxWejZHcTRoOGxQWDNwc1RFMU85cHRMWlJTaHNMSHQw?=
 =?utf-8?B?a1JUQVNwTkE2U21hNi9URVZibW12NllDUlRQT3Vwb0JGWXhPak93QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31303060-aed2-414f-d89c-08df449cddc0
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 11:21:03.8324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShHiG5AcJPsfySS9sf0FFnE2Hoi4OqrcGw/GlyukQLRPyCPpsfl2YcW2eU2SztNd+Gdy7qb3UdZAYUMuWhfu7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6308

On 15.11.26 19:17, Jakub Kicinski wrote:
> On Tue, 10 Nov 2026 20:38:23 +0200 Tariq Toukan wrote:
>>  include/net/netmem.h | 24 ++++++++++++++++++++++++
> 
> I haven't done a proper review but this jumps out - does the new helper
> really belong to netmem.h ?
Hmmm... no. It should be in include/net/netdev_queues.h, just like
net_devmem_unbind_dma_dev().

Thanks,
Dragos
