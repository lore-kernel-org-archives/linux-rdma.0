Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792741714;
	b=GjW0FWm8Fm1vVRFP7yBuHP2l2HCQ+Jzqf5qEpohF/iOKUy+tjuXedPStCmUm/rEf/LMA
	 aPWVdZzDhp1bB5wwqH0FIEFxB4qI+2BMPAhko7iEq6CQlsRd5tPAxCT4XqsTMaaFwWDu9
	 tE/P41z8gJ/AOZWx7rZ6N7lpwFmaMtD8KDtrkZt9x+Iz03Rm6k+jwuwcLkkAxnZIZjrHH
	 Yk7hxT16vJGDOyw69DCFSiZbb0z01isnBskWibev7YWAcEiWha4iKew3rBq/psO8X0v36
	 /Knny19mxU6ar8rXGQRj1+IczGzelC8w1bc97vnZAAutkm0B+x3DUb56CsdS2WLrfKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792741714;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
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
	bh=hi6yhEy8HZE/cWeWz+yW/F5r4BaK0C7aPq5tHR9HtW0=;
	b=n7qIMFcjVRpp819xTV6SmGqDsE8mzxyUMsuu+76JPXAGA4VtPZgbCV1fi2gRzlrBrRX7
	 ulohbE8WTl5TaOroxePNWAP2nRsw7VfE+XzfadM6QWS5PmJdyZblz8bZtozGHxuLCSqi/
	 5ka0U0YST6bW3uhqfwMwj0uUF3UfoT1ulhEX5mFNQliCuRT/C7gYARwDBykX9mmbOt52+
	 qIOj1cLwy77AnhifEDIm66QSX2s2GnkOo0McGgKbnfSLzqqnCkVceTohyi/hohON+FQz6
	 KouBasj2Q/dLsLfTgdVJZPROpGKD2qD2w3aeNTjVK4/Ts+pq7b2cQe/7wHyqhmWS9Ig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BgztIZa5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.56
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23E606A31E;
	Fri, 23 Oct 2026 07:48:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B23E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BgztIZa5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUYD/FVQfD0g6HvdphVBlSoRLsdmCFo/NdonHUzhsMztTsbc2IYeoP+IGRomLn94ZslrCwb6FFaBLSO/Tvu5yeGyMqLZInqtgJFr1EdWjTuDe6cv3eqNfpigeczuNH3X6p/iyUFQV7YoSrsXSstJLKoDhyLaWByMSlwyxnoNbXyu6uAsmBDUK5+1cv4yvaWBzpurvI8uVT3xABuWffEPxm7PYr2uTuy7Ryu5NNZsSbwFrQu1tSJVEHicDpT2WzhXelJaBM0LYvDlGiIQ/cBDgvYz87E2JWfWuYvFYxNmPbq8tSvp+LCz/9SHJRE+rxBVhzgKxIdqTSalw8hF7zW4cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hi6yhEy8HZE/cWeWz+yW/F5r4BaK0C7aPq5tHR9HtW0=;
 b=CG+L+ihvPBzPI/uTgl4xkGljnPe3MiZGbWrtO/agWbGuVD9CewmrEbLXQ82ZCWq1pz8oSWJ35Hp8w5DPrMIG6xTYy8ipfkLbrEzQwsV5ws4rq/rVCB0wSDR7RDQRD4zGPpqpWsB7UJ+rqLrFgXz20hmWsC+Di32Uopy4kk6h+R1gdFB4xNmCVx+ziGyDpURMUp570wUPNTEzk7JfsNhduox6IgO7bso2STG6abEPT9etl1+4c4fk0BrxETSGj8kJJo3ci2TjNGD7EXl1UC/SP6M3F6WU7jUARGYkPtTnzho+fiZcWxuGbixx5CgfOOMjdiQPIWK+5vEdi2BAqy21Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi6yhEy8HZE/cWeWz+yW/F5r4BaK0C7aPq5tHR9HtW0=;
 b=BgztIZa5V96IllBiLQvbcZe0LGHjw6nj2F18rQtRPiCbwA9gzOMaIyRpzlyZpeGvQ68dBJnOB5/zpRE3+p8k7P+VFV8RaJLZpJIw6PxFAb1yCDy0TwLx8livvq/jMkWKtcCP7LrzrFywQpOVw9fQbDU9QMPXwVDVbIESAAiZqKw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS4PR12MB999102.namprd12.prod.outlook.com (2603:10b6:8:2fc::9)
 by IA1PR12MB6627.namprd12.prod.outlook.com (2603:10b6:208:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 07:48:25 +0000
Received: from DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25]) by DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 07:48:25 +0000
Message-ID: <90eadc73-2db3-8bc9-1529-eb6fc0d0527a@amd.com>
Date: Fri, 23 Oct 2026 13:18:16 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH for-next] RDMA/ionic: Fix GSI QP ID release
Content-Language: en-US
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>
Cc: stable@vger.kernel.org, Keith Lucas <keith.lucas@oracle.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Boyer <andrew.boyer@amd.com>
References: <20261021161651.4020222-1-haakon.bugge@oracle.com>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20261021161651.4020222-1-haakon.bugge@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0177.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1af::10) To DS4PR12MB999102.namprd12.prod.outlook.com
 (2603:10b6:8:2fc::9)
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
X-MS-TrafficTypeDiagnostic: DS4PR12MB999102:EE_|IA1PR12MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 34727331-f577-40ec-78fd-08df30da048c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|11063799006|261021135927099003|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	vnQ3m0UmpOw53BkVN0MnKCmbsco6KcaYQjMQYYIFaqNbAAWRDlp78k0tq7oMKUH4/Jl7SOiRiVPHV4JF3AlLTcFV9J4lLXinx4HSDwB6sj4wIXZCdIvXV67fdfcZr0O6XRLsB13TQJMrdjnmS1F+Abgb2Xud1xs/v/Z+dKh5AkOKYLwRZU3qhoJeRBAbuKTlV/7ecMb5+0L8FJVhhx37lcf4htl7DyExMIKqdkCCQccVQLAHNlqLj4ewwrjWUmx7V6EbTuyz9Qfxf+vW2LX7wiO4bHh92LWn1tzDMjGs2ldNoFlUMVgMvG2Eeaopg763hnZBqzMR3Z5OQUyy4MV04dznsviD7paAmbQLbAkXbNjwA0nosM8SKJNfbSvqImcmPPGgr7APp16CHc0p+7RePY2MMwX5lkU3jPBqBwG/Ic7LNbex7H3DYLh3ayQOxZtv9UWFeEyEa/jOTlx0y3Jpx5QOy09lctw65vOsiCFK4oIKKeNwxdErl8IE5IUvDIQWcLOMzFCCbFU49I8Sqxu7Wd4GkAYbXM553E4i9epLNM0L6rPBD/6NvsDTKblH9ZRdwFZzc+fhVBnfnoqIMPEi5P5w8ee+qKsDMK4T9xvnw07yNoZAQFUxvvpiQjQ026b1Aur3o6ajBnp8Y19RtjFuTcAa1fyKoqdW38HOtRPbawM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB999102.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(11063799006)(261021135927099003)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDZmUncrR1RJMGhlWDJTQ0o0dzQyclpHWHRURTdUd3RmbW0vbGdSNG90TFRR?=
 =?utf-8?B?OUZIeEtvZk8xT2JnYlhBK0Z6eWtvSGlwblZKbEEvVU5aZ0l5K25BZVZZUk1K?=
 =?utf-8?B?aGFoQ3lhamdYRy9QdFV4YVV6TEQrUjV0bG5BTTFmZmVIYXkzTFZXMjNwSUJL?=
 =?utf-8?B?eXNhQ2dVTk1ZUW9hZVJUVkxBVVNjQXpXWFpNdiszYmxLNDRmMFF1cENCZnc2?=
 =?utf-8?B?b1FqWngxVWhzczhKU3I5Nm9LYjd3ZkZmRlZzZ2cwdHBPNW9LbFNKUzYzS2FG?=
 =?utf-8?B?bDRsQ3pGeU01RXFNbHNibDhWMVB1WEVwNW1PYTVvK2FQSG1QcjJhTlpZYSt4?=
 =?utf-8?B?a0Y3NEh5YlVsQmpGckt6V3JISlBxRlJjbzFUM0JUSXc2bEJhNjZWWlNRMkxk?=
 =?utf-8?B?OUJiZHRrdi8ybW5rVForSUVXcW5XSmRlbUtuZFVOblhxZEUrcmJDaWVZVGI5?=
 =?utf-8?B?eFBhdE02Ky9CL0JPR0h0NXFjTFNyaVpGZmpuVXlBUnNoSTQzQlBuQlV2RFJQ?=
 =?utf-8?B?UkZIM2ZmOCthNUhzdy9rVytmOGlVUG8zeXNySS9DcVhuMlZLNTBIc3hGeXNW?=
 =?utf-8?B?NTk3SC84ZVNVU3hCbDMvRFY2dm5tUzNmZDRPREVSTzFmaWF1R2lyS3hUQWlE?=
 =?utf-8?B?ajEwRzR0d0RmVmlWaWNSbGhIVjNxU1JXeDIrei9EaGNnQjcyNjNMb2tIWmdK?=
 =?utf-8?B?emF6T2NFOTRoc0kxYlFuMnZiUmhtdmxFRTRlb0hjVXNUMjZNRlgwNEMzUlRL?=
 =?utf-8?B?dUF3aWh2RDR1RXlvVnVUVGREVm1JWHVEajF2RXc0cTdYWEFjYjBtMEJFNm5H?=
 =?utf-8?B?N05qWFRoRlBZMFJtWko2NVd4Uk04M3dhT2hsRUxGTU1UUGZPNW5EamdZc3pL?=
 =?utf-8?B?bTJ1MnNDc29QUmdLWUxVV2JUQzNqUzJnYk9sekVYNDR2a1d3V2lIWUwxY043?=
 =?utf-8?B?bk9ENUJscnAvUCtlMUVDMEg5cktBUk1wbU9kRk1SS2dIQUtoVHBqajlqZ042?=
 =?utf-8?B?b1F0eVBXQnFVM2J2NnI0THN5MXQwdWNvRTJ0SlV2QzhaMjBETUZlNVA5VWZq?=
 =?utf-8?B?TmRYSWswbDhERjNjRE1TZWxBd2doRGpVbUJsVVUwdW1qWVJMNDRVUlpkbVA4?=
 =?utf-8?B?MHJKcUdHbzM0YVkyOU5jcEdrZWV0emZZS0xzYWE4K3B4YUtES2lqMEJlb003?=
 =?utf-8?B?TTE2QVg4dEc2R0ZHSjJvY01RbFczemJIVXFOQllOYjRrUzQ3TWU4UmZTT0Q4?=
 =?utf-8?B?NlRHcnpkVzIrU2JzWnZaTWhjV3BSekFmMm51Tk4xUHIzUzR0bXlmYWtvYTU3?=
 =?utf-8?B?TEp2RWpNWmg4SVM2TTVSR1ZMaVlxUWF0UnpuaUFtUjhFR1FiSlhONnE1WlNV?=
 =?utf-8?B?TmdySVBKdWhVZzdMdi9PQXJOaEJ2T1Z4VzFsSGtlTTBuQTM5QVdyN25QWHpG?=
 =?utf-8?B?NUJZdGtScWNvRW1KZGx6d3drQjJMbDd2UnNWdURyVDJuWHdaVUtjRnlvNW5o?=
 =?utf-8?B?S2NWdGxIN1NCVjhYbFhoS0Q0b3g5bmtvcjFFL28xRExoTmFXcGhQdFFsY29K?=
 =?utf-8?B?NlEvQUE3S3Ivb0dTV1Y4VjdRcEUvQmU3TjJUenFGM0pSWkxNZWZCYy8zZHU2?=
 =?utf-8?B?TUtRYTl5MTBxV3gyQXBQanMwc3ZVQ2Zjb3NHT3dJWjFRa0lLWGdYc1lGc2sy?=
 =?utf-8?B?TWhNZlpmK3U0aUFPMUMvTzcyVVJxSk42Q3VhYU5TaGNnL1huQWVYQ1Y5cFJS?=
 =?utf-8?B?RnpuZU0rc214WHFyVmxmTHNvOXZpT1ZiaGZHaEFYRWhtQjJIV21sZmdZaGlD?=
 =?utf-8?B?M3pSNWUzcmFwayt5bk1rTnlabTFUWkViYXZ3RjY5bGdkN3piZ1NFS0t2c2pj?=
 =?utf-8?B?MnhHdEI2VCs0V1NVcm1iL3FvZ1FXbEZNLzF6QmU2RUtWWDlCYS9LOENCT09W?=
 =?utf-8?B?c1dOUnBINUxRUVNtblVycjRDeS94QWF1Z213T283VG5YcEdTbHNqRkFtTXU4?=
 =?utf-8?B?YnpEUDV4MWxGOEVCVWswdDdHd2hlZk1BbXFFVEYvQzdMc0xSRmM4WHFrWmNm?=
 =?utf-8?B?V2o0SVAwKzlYMkswY2hqbE1yQWNsSlB5TkJMOGxqeENSODl6VGx5elFBQ1Zy?=
 =?utf-8?B?STVJcHVLamtrZkNhZmJEV2k4eXhDaXdiSVNjbXVVR3pMYVN1Qk9XZmMxNFRM?=
 =?utf-8?B?NEtxNWRIYzR6RFVCS2JaSFd0bXBRZSsra2VRMDl6Y0ErNndqTFhXcEoyWkJO?=
 =?utf-8?B?Z0hnU3BDK0VhMmw1Q2RiM3NVY2RHc3JZYnlWQW1teUdiclBGd1N2YXNxK0dT?=
 =?utf-8?B?T1E2MFFFTkZpcm1FL0VRVHNSaW4vMUNBNFNoc1hMTURNcmhyaHU1dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34727331-f577-40ec-78fd-08df30da048c
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB999102.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 07:48:25.0827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrbrRyHr9QxnrMfQEUd4MVEOoTVjoxhpR65zC1eMQcQd9405YDjS4/XUuOazza3+UzuMNvJy3/DSWj+j7o1aXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6627

On 10/21/26 21:46, Håkon Bugge wrote:
> QPID allocation differs between ordinary QPs and GSI QPs. If GSI QP
> creation fails after allocating its QPID, or is destroyed, we see in
> the log (trimmed for brevity):
>
> kernel: ida_free called for id=32 which is not allocated.
> kernel: WARNING: CPU: 47 PID: 6673 at lib/idr.c:527 ida_free+0xde/0x140
> kernel: CPU: 47 UID: 0 PID: 6673 Comm: modprobe Not tainted 6.12.0+ #18
> kernel: RIP: 0010:ida_free+0xde/0x140
> kernel: Call Trace:
> kernel: <TASK>
> kernel: ionic_create_qp+0x4f5/0xbe0 [ionic_rdma]
> kernel: create_qp+0x19a/0x290 [ib_core]
> kernel: ib_create_qp_kernel+0x3a/0xe0 [ib_core]
> kernel: create_mad_qp+0x8e/0xd6 [ib_core]
> kernel: ib_mad_port_open+0x268/0x3f2 [ib_core]
>
> GSI QPs reserve allocator ID IB_QPT_GSI directly, whereas ordinary QPs
> encode the allocated ID in the QPID. Calling ionic_put_qpid() for a
> GSI QP incorrectly applies the ordinary QPID conversion and releases
> an unallocated ID.
>
> Release IB_QPT_GSI directly in both the creation error path and the
> destruction path.
>
> Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
> Cc: <stable@vger.kernel.org>
> Reported-by: Keith Lucas <keith.lucas@oracle.com>
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> Tested-by: Keith Lucas <keith.lucas@oracle.com>
> ---
>   drivers/infiniband/hw/ionic/ionic_controlpath.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> index a70ef59a8064e..cd623f1de38a3 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> @@ -2450,7 +2450,11 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
>   err_ahid:
>   	kfree(qp->hdr);
>   err_ah_alloc:
> -	ionic_put_qpid(dev, qp->qpid);
> +	if (attr->qp_type == IB_QPT_GSI)
> +		ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI);
> +	else
> +		ionic_put_qpid(dev, qp->qpid);
> +
>   	return rc;
>   }
>   
> @@ -2762,7 +2766,10 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
>   		ionic_put_ahid(dev, qp->ahid);
>   		kfree(qp->hdr);
>   	}
> -	ionic_put_qpid(dev, qp->qpid);
> +	if (qp->qpid == IB_QPT_GSI)
> +		ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI);
> +	else
> +		ionic_put_qpid(dev, qp->qpid);
>   
>   	return 0;
>   }


ionic_put_qpid(1) frees 32 because this firmware reports udma_shift 0. 
That is a recent firmware addition where the QID space is linear and QPs 
are no longer balanced across UDMAs.

Releasing IB_QPT_GSI directly avoids the warning, but it leaves that 
numbering in place. I will send a patch that supports this linear 
configuration. With udma_shift 0 the QID mapping is an identity and 
there is one UDMA, so ionic_put_qpid() frees the index  
ionic_get_gsi_qpid() reserved.

Thanks for the report.

Abhijit

