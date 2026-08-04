Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013069.outbound.protection.outlook.com [40.93.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AEA32B10D;
	Tue,  4 Aug 2026 07:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785828281; cv=fail; b=QkK5BUcAnpJnFJW25kuR0t5L1vLxakAwAdoMUZarL/cOOQ+DoT3PLz8FnzNNGbJScr8/MSDK+K/E4bCV9YAife2MiwttkLKaw9Q0Q3zNapNe8NdRICphU1YVR4Ojm6Y2I/FRGvOlrQBNEQBbMzC+34GVzP2BQ1SSRpzZ3UAnPZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785828281; c=relaxed/simple;
	bh=NIAbiBQhwzfC7TJ6zuxaQ5pLkoJlD4l9QJCBQGtmwM0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aSULJa2KKZPqEYm454qiDPy7TuiXOHSEvMXBW8WMFz55m9XghaS/GpDHoNJ7xZzyGxBRO7xWRB65mmxr29ONCtLsxLprl4seRCkNF/o77jph+kGVBVMfodiKi2dKwO9cueUXqiRqz0MjsCN3b5tyJWbvMwbeqRqWLUIf8P8aoKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gUTj9RW7; arc=fail smtp.client-ip=40.93.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gUTj9RW7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNUGR2SXWUNCU2vk/WaJOmghZYknh1qCvEmktscuypBXu1RJ+XRTShZZlaP3/Q7Ttjo+/o0YmHZIyEATY+qNw/uFaZGDFMlvZvJCTpRqgPY1GauA7JlmAlTue3y7NbwjtJISg9flKGLTJp/0Y8rHe7v9jkxZ5Y93LD8gqCN3rXswRqkWnUYCGkVoQxUy6KLKOsqD5LDlKJmzfye7wMyO8tudH0UbGMrgXYPG8jwxNMvnM0PTzrjdRHzUifaQwazBIcqY1nMSUocOTxC5kXDF08nx27sgETOl1FbFDsJRxm8yM0UObKzW8yU+ZHkhe9P7/MezVxZElcqiqryan8nang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqSbhTCb0KY8F9FiMNMg/OEWbCcCl0Ufltu7YkuICZw=;
 b=MfetCL20Ga2TL06UWMpnfpoBTPja77/+8Nlf9b1pJmx+4LFPApLqsZFZzKiLcLJMqIop+PCXLtWG8VD5HE7VkPG2ixyMoBgTDkJLY43d4dooTC5qJBnR1qatixri7KPxrtkNvybMgop6es0ij7DAZN+vhPYaSTgeEW5G0068eJPtdnoOIVTs5W33VxXIxTWuEU7sUFpWkVM58tM5rDc29gF8fROmC+uHx20KEmTsw/HLAMe0tnvRUpbWtNNEvu49vYgxsNY5yDdZ0+sGThQXvYLThNUD/0ifOE7o3aa/RVOCnADhMIng152qxy6AckQ2hSiCGGjel7/eIEVMnSTKig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqSbhTCb0KY8F9FiMNMg/OEWbCcCl0Ufltu7YkuICZw=;
 b=gUTj9RW7PkDXRquCt/opcsfVXdNbLg5I5nDMdLZm26WTsTq0+stqbnJlVB3yo/YML8d2TF1waaO5lMheIRGjQVhsd99A4fQX7zP9ZjSyZZfsN+7AGV799G2aVR6Jc4YG98Bph3QX4H9UEXvLdKQp+V+saMqJmSmc9FEx8sbpgSNbDcdwphB7M3pinSN5M7HjU0U+blEXRF5GbpF/aRnQxCfJmoHKsL4/Dg8ykeYD0RhRkVlk7HA5/OXFMa8KRZYErf4L/CxIgYKxuPipn0yQcPnlmDUFy2BI9ly+gydlFsrjzQSU79cLRNOG4wLK/4N3+0qPMoiAsFvWORTI/7uOeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by SA1PR12MB6895.namprd12.prod.outlook.com (2603:10b6:806:24e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 07:24:35 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 07:24:34 +0000
Message-ID: <bd319706-b28b-4131-9dcb-11b586831723@nvidia.com>
Date: Tue, 4 Aug 2026 10:24:23 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5e: strip runt Ethernet padding in HW-GRO
 (SHAMPO)
To: Glenn Judd <gmj@meta.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Khalid Manaa <khalidm@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260731185442.2778723-1-gmj@meta.com>
 <20260803214412.1714151-1-gmj@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260803214412.1714151-1-gmj@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0053.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:270::7) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|SA1PR12MB6895:EE_
X-MS-Office365-Filtering-Correlation-Id: a90cf02a-b213-42aa-267b-08def1f96efc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|6133799003|11063799006|4143699003|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	CaPLdHuQn/HJx+0wh9tumK3ZH3nJkysTR2zdLBHftr83hspLaJd9DUWm1AIXp/1fSlZi7HaOVO3VYFFGeQNurFfLjknO9Y6PbgYqfG/P919hZyuOa6iFYPxb1hlBe3gfZhUPbw/oxIr88Muu3ySVe0s/vV2pOFd0+jSyBK9nLOISdrPjUeeRzD5ev3XnJEoH0KepMqZa7ySRiUqz8WfSUttk7JVbJszp9BP4p07FbVZXNDQw6Sh9I8fcY0NVyzB8Xp/VHI+ShcTUqvCfqL/LJ0qQO0vZXhvNIb/qhqTSEZoOILzY87zbo4ZqM2zr1CxJGcxGN8TAP6/tnp2jr8Wd81j9Voqr50DR39Sag+f/2ee9xT8yBJg0CgqtGUtSxSVjfJ/WYOfNX4p9GmcB6CxgFfGh+v5dhmqxNxRh7Wp+QLvLmx2oCeNUWPcQPYWIy54p+ZwXrLd8bMEo/1gln94p00306Y89yFAHf0Nvwc9rRUnTbhzrxJ61KeE3x9HnZCKltrPAkIRx37ZO3cA4z/OUny190gmR1G9pOBwo0XkyNPW1mz6RRTOO3F63+jFZHzVsGDUEXd94GKHDZ5euTTNS//qhPs9+J1z6fzM7ObJO7gU4JHYG0G9cAUMbLQe/yPuCMheivCmSt1E2x+0JLNqLz2thZIvrcgtI61Hd4ZR8n8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(6133799003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGdHMEZ4UThlK0VOaFRuUDBLTUxMQzlqMmFjeHFralNLYzg5bkRERnk4ZEtk?=
 =?utf-8?B?NFNqdUQvV0U3Q3B0QlUreE55aHVPazloamwzRExtaUU5M09ucWJUVVMrTnlp?=
 =?utf-8?B?RTdDb2tsZGlxeXFOM2V1d28vazdmcm5Wa28yTTlKWVZKcDM0Ym1EQTVQYS9C?=
 =?utf-8?B?VmJLdWhhS082U29xV3VMWitycnZkaHU3N3VnckFsQksrdS9jdXZNM0pveUZQ?=
 =?utf-8?B?NEtsd2dHMkZYeEMwVkpBQS9nb2xqaHJTVEpmUHZKdXRVM2ZTWVI0RzdOTTh0?=
 =?utf-8?B?c3kzcE5leTJOVFMyanJmVlBLaGUrc2pyK3VQRXpibXlnR0hyU1NJNjdKVnpM?=
 =?utf-8?B?bDZ3ayt4NVY5eStJMUQyUGpXbVpFMlQ4aDBsY0RQYkZ1RE5vTTQ3UFQzaVp0?=
 =?utf-8?B?NFZQcXV0aXVwS0RWcWtTdUdMSzFtSUxXU1ZEUUpGQUkwc1NFVzRxWTBpUkVD?=
 =?utf-8?B?OUI3Vlc5SW5jU0JDV1krSSt2MC9lMGpLNDIwWGVPeCs5U0lBYmdka3dQbXhw?=
 =?utf-8?B?bTVpK1pleUE4RHRvZFVJbzBYampHNmtNcE5sV0ttTzdHMFl3U0Z6MDdPQWto?=
 =?utf-8?B?d2d0SThxaitrdmNaUFA2QVM0YXVUaCtSemlCUnVSNmU5QTNHRG80SlBVZUtW?=
 =?utf-8?B?b3ZNVi9hcU1IOWNGMENXR09kclArYkpzbGxRd09SQjJ1WFlBQTh6cCszQ2Iw?=
 =?utf-8?B?QzJFQ1hyczdMR1RPRCtRdCsrYWJkclErN1JuMFZZVjIvRzd4RjVZWjVkbFNs?=
 =?utf-8?B?eUNleUVQS0lZQ3RROWIxeTB5Y3J6amJRN1EvUlZRQ011R2ZBN3hhNDVVd2FN?=
 =?utf-8?B?QThGS3JpWWk5YnV2cGhlWm5lVEVYaEovZXQ3Y3JYMG1abUQzeURrS09JeS9i?=
 =?utf-8?B?VzV0RjVFcVc4WEt3bEVjTWtjdVBHY1YwNXVXVVhqV1VTaEFsamVvVEJkU1ZM?=
 =?utf-8?B?d3AzUno5L1BJaWdhL1BUNVdLU1NZZTJEbGtmMTdHZ3JDOVlyMjl0MHQrYk5L?=
 =?utf-8?B?cW9PV1VwWjZJSjUxK3pPcVYwTlNDa3NUeHBaajlKRjNoQi9jcTREdmsySnpV?=
 =?utf-8?B?TlZXSFlvekRBN3BJYzJFOHBNeXRGVy8yamRJZkY0dzdKSlFGOCt1Znp6dTV1?=
 =?utf-8?B?V0ZZNUdnK2hGMmdMN3loRUNJSVM3eUUvTnZUV3MxamNNUjNzaGxWUkh0Sjhs?=
 =?utf-8?B?M0tMY2ZvclVLbXlHeDUwdU92T1I1ZmFma01reStnejlDcGxsZGtqYzdLSUFl?=
 =?utf-8?B?WU9mN3FaTEoyVHl1M3hzY0VMTVVOUm1lc0tDOWtNK3EwOTU5bUdWb0p0U09Y?=
 =?utf-8?B?b2dVTG13c1pJeTRmK2N5cERCZEsvcGkzM0FtWG8zN3ZDSitjYjZDM2pwYm9Z?=
 =?utf-8?B?Szk5eTBlc2dNOWp2VVVsNUEzYjgxUW9pTEsvbXpMSU1jMHVrUzRDTkJDOE85?=
 =?utf-8?B?MG1OYjFSczROUWR0U1lIY0MyK0Q4aTQ3NGxBQy9YS3ZmTjhON0g2MzV1TnVq?=
 =?utf-8?B?bk05eXVjQmNNbHQxUldjR3h2Ti82T25MMmMzNzRrNE5DM280enhZcG1kejRj?=
 =?utf-8?B?ZkdJR2ZiazFHaTl5WTZDZFU1UCtNVmxWSnZrVlJLWlpmM3FaUWdlMHZHS3dZ?=
 =?utf-8?B?dzdtaXB4dVpLclg2eE9lZVdrSm1JL0lOWG1TQlBKeU1DenV1Zm9SSUkyMVJK?=
 =?utf-8?B?TlJRaWFadW90Mm0zL3ZTWVJ4dGVOQ2V0ZEluTUJMcVpNZWRwOU1ZMWd3NkMw?=
 =?utf-8?B?VXhwRXdrMjRLWmtFL1hGSmJMTXBUOENxVnlEQndHTms1QzMydC9rVnloVGps?=
 =?utf-8?B?Nm8vRlBPdExKbjhZTlJWNXlnOGxCUXNObEZSbDlRVmhNTm4xeTlaT2lJSlEx?=
 =?utf-8?B?alAwL0JCQnhEbk5ZM2RNUk5WTWVtTVdUeUJueUxFNXp4OEYyUlAwN1FQMFY5?=
 =?utf-8?B?aFhKelZTR21haWdqQmRacmcrSXMwNXdYTHhkbFNQODZOSWxMRVdYaTBpeXp5?=
 =?utf-8?B?a3hZMnVNaEU4K3JzNmFVR2cwcVJSL3NZYW9jS2UzTGpOME16emNsMnFxVlF3?=
 =?utf-8?B?ek1KTjRaeXU2YnIyUXA2NGZRaHArLzZnTHgyMUx5allaZXJLSkQ4TVF2ejJD?=
 =?utf-8?B?NTBGU1BqODFBOUcrTTQxdjJlRk8zUUlJR3dqTGRzMGViLzU5UnVHZEJxWEdz?=
 =?utf-8?B?ZFdFZ0Y5amNEVVRNYUszNitwdGR2YWdDYVEyVXFUZDFwajI2T2FCWmd4aTlJ?=
 =?utf-8?B?VTFocUl3S3I1VVFpTjhRVElTblZzcmE3RHdLc0tTWFYwLzZZbDVvYUpnQjlQ?=
 =?utf-8?B?ZHR0cnloSno1OTlXUmgvaDZUUUdkVmpYbmRmY1NMZmxIbFVwRlpQUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90cf02a-b213-42aa-267b-08def1f96efc
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 07:24:34.7986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsxoLTEWsykSB22eu6/PfGQY5h3ztiyr1JXzV8l3PDwufX2J0kBm3dPLWQIBIHwsgPC5pwGCy1INXoa2tn/oKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6895



On 04/08/2026 0:44, Glenn Judd wrote:
> When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment
> that was padded up to the 60-byte minimum Ethernet frame, the trailing
> padding is folded into the merged payload.
> 
> The selftest tools/testing/selftests/drivers/net/hw/gro.py subtest
> hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
> In current code, it receives {106} (100 + 1 payload + 5 pad) instead.
> 
> Fix is to compute the real (unpadded) frame length from the segment's
> IPv4 total (padded) length and drop the padding before it is merged.
> 
> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5.6
> Assisted-by: Meta:internal-AI-tooling
> Signed-off-by: Glenn Judd <gmj@meta.com>
> ---
> 
> Notes:
>      v2:
>       - No functional change.
>       - Address the netdev checkpatch 80-column warning.
>       - Add a comment noting the IPv4 header offset intentionally mirrors the
>         driver's existing no-IP-options logic (raised in review).
>         Changing that logic is outside the scope of this change.
>      v1: https://lore.kernel.org/netdev/20260731185442.2778723-1-gmj@meta.com/
> 
Hi,
Please note that I posted comments on v1, ~1h before your v2.
