Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA432E1EFC;
	Wed, 12 Aug 2026 10:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786532322; cv=fail; b=mHIp1rP5Cj1dLbcv16eie0RCe/q0drKcZlk5TVJ/u4OVHnWcPFVTsyd/Pv//EVmKZO9Bz+vB4s6RbDN5l7MsmGd5QVzkrep6We1WZiZtyIR/WlhCiXPX8fwDBqcuh7aEmvk7ZHPGpawomILQmB2whefV1sOkT6rwxTVnPRIuuFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786532322; c=relaxed/simple;
	bh=GQTKpce9HYcLC0Uy5puEDiWuD5CTmsBS0M1/zS4WS9I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dLUqRtajerYiHydSetZ63kcBeZcVhwL1ai+UUNrGYQqkVjKv4mmZQUL8wvV9p/614FLS2QvTW59HsN17DYh/LAPmyfjboQEOWjUrxGOmDpXOz2he4Ucva/KVikFStsJ4wCvG9KGeEOEfN8Kb6txh/QLbHZha+9dZSBs21NXGj04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PDFOBIR8; arc=fail smtp.client-ip=52.101.43.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PDFOBIR8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kfr4+8IkG5MiC6H9Z3XpsjVk1eaKfTusa8GAmDcxXK/u4ZnNXViZuVhrzc9bW1geDK6kesRqe6sdr55xsnFbgpwv9G+sUfQmSmo8W6g40sSQYdkt3Rkr+bHddv+XyWPJX/jSq26zU6SMvbU5j/em4IwZ27NqCC0dLAt4nTrTN2jI+Ru5OZXaKPdgSjLLyg1du63bYywlIdifLjWgTllq8+Hj/iL+5fN9fmgvSWHzYXodSuqhr+Hl5OgoL8wI5yX4xMrfk2wdM/f4/6XXX+jMAQ4hXi1oeu2siC01BSZKaDjbJOKhw8r+/24OXL5rtE28Uk+RmGVpMWAWorTJGGvCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNdH3bB1Wa/kTZALR7lS5GnK5cwAdWS3aAYOG9SU4N4=;
 b=LAP/yhMXy01yPk0305H6FK9x6Se7/mKBNDy2eOeejm3UxIlYs0KDu0T0Zi61NXb9Hu1f3qBYDLE1kkTub0ui3uavZ2sNMZZzyfW+eOkKhjEpZdLvWXfwU7y3j+Z8n0+SozQUF/MijybKsMWEsnal8thoc/tuc5QLf7R9JPBB4jVlsxSwxJck6Q257L9DOkJRdvQNRF5SSmXdvJbbEXNJYe/XYzuOND/6uAi9gFh9IwAQme6Svg2m17A0vh1gU7HLpL/wRV+XWRn4Sb1V9+RhOL9ca0CTnJFjUMJR9P6loDzrlqZUENiQSHeLR8EnJNksL/czRVim0waCpSbKeSaz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNdH3bB1Wa/kTZALR7lS5GnK5cwAdWS3aAYOG9SU4N4=;
 b=PDFOBIR8uCh8NuV4kRkt/xFg5iis2whqzOxRzX2ITG1hWrGyyJ1iYOFtFbX+UTw++l1SOHsDMvhsmD9SLj1kF4VhwlCw8/l255CJyOgtfJwuBX6ys+hESmHQg64qAtkYLcyd0nSVQ749V/fQnz2ngq1svKN0f6Dpsgsu7lyAWhDjV/zqtBDDHiMmRFXXQUCO880GAwAijFiLshxROy4lbNsAukqETxHO+wd9HpdrU9gBrzX6a33rXuY1s1/5GfaAfAU7xrvQPMd9FdgubN97O6Uf3NPpNUI16+6IMhPKWf+GAeuQkrD0m5paSdkpRE75/5akskm5qhAJ47rg3W4amg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by PH8PR12MB7301.namprd12.prod.outlook.com (2603:10b6:510:222::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 10:58:33 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%6]) with mapi id 15.21.0315.012; Wed, 12 Aug 2026
 10:58:29 +0000
Message-ID: <84153a13-6990-43c6-8528-c8b56588496d@nvidia.com>
Date: Wed, 12 Aug 2026 13:58:20 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 1/5] net/mlx5: HWS, Print more details for bad
 completion
To: Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Akiva Goldberger <agoldberger@nvidia.com>,
 Alexei Lazar <alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Erez Shitrit <erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drory <shayd@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>
References: <20260810092630.3137666-1-tariqt@nvidia.com>
 <20260810092630.3137666-2-tariqt@nvidia.com>
 <20260811152538.GG51943@horms.kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260811152538.GG51943@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|PH8PR12MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a35c58-0e31-4a83-a805-08def860a43e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|6133799003|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yGotkRYS6tpJVo2U84sUF2YvVBD0TfZoCj03RKJeawZ042CQm8VAvSG4HNDp/zPMNgkTkWYlFa2ccRVmFBN+a/xKHqyP3VEcgCyzNXHMMykKSN0qr/PhHuhFzS/A+qhOD8eBasgQQB9rOkOrbbvroyMJjBlaJDmjG0YwIsiomM4yqaFYNYx5CFgtdLsaHTSIvNaD7V80XBjRGprrwRuDnX9HFWWOUoA4dkkMsm8vFTC7drOm9H05tAbZGp6VgvYHmn8ibv6d/3NT2fQ0xSdPQ9hrinhbfb9l8v7xL3mz0qLluLXHt8UgmwnKjrZCSVp0DSuLZQ3of3O7kq7+PeellvRMQPcq/Fn11aXsT0GFH8G7DuqvtOtA3L0FjJsIPvBKT2xwQtmmz+xebayQDg1xpHOOtD/HuEQXHXXiINLG8vweGfxV0yT9zhduipVeA9VrJdAXz45FNu6VGkuGvUE8s9VY8Lbb91+IRqfjnwCp3cbJiW0UGmgwtsftY06JW+bAhLwtsdbKfm8a6ztTx5sZDeDsbv6266gp79MBG1ZhJ6PH1gI1ZFVvNc0+F+5Mnx0OC4H7eaxbHhbC0dMhYP+dI4MBHXl7Dh6xAVzNx2IRWWXh5apv+3sJ1QObxW/BiaAmzrJssrlm9CPXizo9YpOT+EOMYnaLPXmX2jr9JGHXHmI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFAzUXZjd29BdUx5d1RhRThKbFBzUjYyS2lScGJOWkt6cGlTcWQxaFhpbHE4?=
 =?utf-8?B?Sk1tQWI0QkF5SEd5Wm8zanRQa1orTE1JR0k1QzUwYWF6c1BHMnlkL0NKTlE3?=
 =?utf-8?B?ejl4L3VpT05jVlVrRjI4VUdHTWMwemFGTG9KdlM4d1FMT0N2c3htVGtWVnpP?=
 =?utf-8?B?ODlJczVoSDF4dUJuS0JaNUgrclBDajVjZzdjaVFwNVNCd3JZS1ZqNUZvTnE4?=
 =?utf-8?B?QSs1czZxQmljNFpRNy9iQm90aUpOemovaTBLUDhRVlY5MlRJYWJ3aFJjMVJ6?=
 =?utf-8?B?bnpBSXhJNk05T2xFdmZ2Q3psajIxOFVOZDNqeDRJUUVNMGdrbDdPR0VzdmVl?=
 =?utf-8?B?a05Sb1VBV0JSK0hJanNXTHQ3TUlBazlaWXZhbWRJTzJYTXVuSHB3d3pyNEFZ?=
 =?utf-8?B?blhIeUh6ekZva3lkN0xpb3k4ZGdVV2ZSZFhvUGw2YnNJSjRVUkNpN1lQcklE?=
 =?utf-8?B?NXk0RERXRTVNejIzZTNFVk9wbGx2aWptTktwR2p5b2NpNGRLdll6MUQydHNk?=
 =?utf-8?B?dDJ5OGRVaTRGQkVNb0gzcUxGMFY5Z3cyUTVPbG5jR3NDWmxGWlRLR3pscDRW?=
 =?utf-8?B?WWNXQmQxaDdadEQ2TzlDWlRUSXN2dVBkK0VCM0lzOVk2T29TRFd6d1lJc3cv?=
 =?utf-8?B?aGFrZlFkM1JGZTdjZzducmtLR3c3ZGdkNm5WdnNvVHRXZ2R5OFM2OFd4T2Jj?=
 =?utf-8?B?V0hWdVkybVQzekYxbFIrY1ZQbS9HNFI2bDNJOUczOE5GbDQ3Ym8raHJpQ29O?=
 =?utf-8?B?ZWp5aHFNTjFJVWxoNHVCeVhzeXB5dUNJSS9wMVVZa2VUTkxVemZKakRIZzBB?=
 =?utf-8?B?a3VwRzhUZjRRb0tNcHBvd2N0MXV1cGJqaUozaU1SQW01aUxGTUJtb3RBL0ox?=
 =?utf-8?B?R1AxUTdiamhlYklaN1hVNTlIVmVZOE91UG1uY05rekt2alVySEVvQXNMWjFE?=
 =?utf-8?B?S3lXTHp3YVpDRWVva2FDc0VKb1ZFTUdOYTFMREc1RGhLdXJUZnVZamJIKzdt?=
 =?utf-8?B?d0JnMDE3Unh4bDZDSGxJOUJOdW9iWE5kR1d1cXpYWFV4QXc3cG5QR01RRGhC?=
 =?utf-8?B?RlpJZnZZcDJxcmZpZjBXTTdjcURDdkN3b0pLWVBLbUxvZTIyS1NoTDV2a1Z5?=
 =?utf-8?B?amRIWjhyYWkwb09ac01Xb1lxRkdwV2tManFPa1pPT2V5NUxRTEkrQ2hsSWNn?=
 =?utf-8?B?RE0ySlZQTWVNWU92eGpFa043RUpwS1BPV2srUUZrV284cUNmclZEZkw3N0ZD?=
 =?utf-8?B?bEQzRVMzcXVpZ25aVEhpSFp0WFd2Q0luNkRSaGREVU0rc2JreDZqbWJyNGpL?=
 =?utf-8?B?b25IRzlDZzczZVoxcjlxNVQ5SGZ1N2c0OTA5WG1sa1ZTdEN3SVhHOXV1M0xY?=
 =?utf-8?B?ZU0vajVzWkt6MGZOby9FTS9GRGx3dTAzS3NJUDdBL2o3YTNiTkgra1k2eUxC?=
 =?utf-8?B?QUNnTFlpL3I5V2ZLYjUyN1JFQnBsTVg1Um5jOTBQRE9BY2Erb0JlSlJDcE53?=
 =?utf-8?B?UlRSSG9vL3JEUTdnT2Vaa21pc0VSVzB6bHZqNldOcGtVL0kyM3Z2aFpCN2FS?=
 =?utf-8?B?K0ZCaEtQd3BYRWJ3eVlZUzI0eWg3NkVwcmZacUI0WGl0RmNkT1R6YzhnT1ZI?=
 =?utf-8?B?UXlHZG5WM1c5UnBraTNxb1IxcitMMVR1VklWYWxyK2ZNendkSk9SMTVUcFF6?=
 =?utf-8?B?bVNuZXdKV3FvcGRaTlBmQnVPMDdOaHdZWDF1bDBKSzVRLzZWRFR5R1UwM3hv?=
 =?utf-8?B?Z3E3RzNJRjVDQmZTVFFpVmZac1FZWHhJZDNKYUZMK2tLM2czaXZoc3FyNUxH?=
 =?utf-8?B?NmtlNTlWenhUWWJQZDdKUURWRjZrU0FBUkNSeUc1eVlLREN6NEpxcnFQNmJH?=
 =?utf-8?B?WThSZWNsZVd2N1hzTUhJL0krWW9iLzZpTXRZMVRraVp0RVA3NmRTSit5MjlE?=
 =?utf-8?B?a2RlRmZPT04yVmQ0R2k5VVVtRnhqYm8rQkw0ZG9FbENTMmoxRVc5Yi9pZ1NI?=
 =?utf-8?B?SkpyWktQRkk5THRDdDZ2NUMvVDNxbXNjMlQyTnhlL0ZvcWUvSG1XWkVVUXZZ?=
 =?utf-8?B?cmh6NEpuYXRXN05DWmMrdEhiRmZaMmFhYlVlbXV0alRMaFRvYmlabmF1a1ow?=
 =?utf-8?B?dDlYWktlaFNyZEpOMW9MTzNxMkk0bnVLc1pKNDQ4ZHlqcFlYWTFJc05HRHIw?=
 =?utf-8?B?TW1LSXNtc1VhNFIralNVbFlhYWJ0OEpwbXhnVVJodnRIRDcrRVNpUTBZKzZh?=
 =?utf-8?B?ZXRweEsxdWdIK1hOaG1nUXpyNVZoTXJOeERDVERWeWdVSXUvL3JZNEF2Sk53?=
 =?utf-8?Q?2HE5MbTTsoRIs94Rru?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a35c58-0e31-4a83-a805-08def860a43e
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 10:58:29.2199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHYIV4KFofEpCdboaukx8+FkkOPPto64SgcuQJxn2eFNUZpoiZq1gBcAphrC1kW7y9O/W3JwaGKVZMexHLSaPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7301



On 11/08/2026 18:25, Simon Horman wrote:
> On Mon, Aug 10, 2026 at 12:26:26PM +0300, Tariq Toukan wrote:
>> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>
>> When polling for completion returned completion with error,
>> parse some more details: QP number and WQE count.
>> Also, extract all the long value-to-string if conditions
>> to a short value-to-string functions: do it for rule
>> resize state, rule status, and syndrome.
>>
>> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Overall this series looks good to me.
> But the AI-generated review of this patch, pasted below, does seem relevant.
> 

Thanks.
Yeah it seems relevant indeed.
We'll handle.

> ...
> 
>> @@ -423,6 +445,15 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
>>   			    "    rule 0x%08llx:  |--- syndrome = 0x%x\n",
>>   			    HWS_PTR_TO_ID(rule),
>>   			    err_cqe->syndrome);
>> +		mlx5hws_err(ctx,
>> +			    "    rule 0x%08llx:  |--- QPN = 0x%x\n",
>> +			    HWS_PTR_TO_ID(rule),
>> +			    be32_to_cpu(err_cqe->s_wqe_opcode_qpn) &
>> +					0xffffff);
> 
> AI-generated review text:
> 
>    Is this new QPN line printing something that the same function already
>    dumps a few lines later?
> 
>    At the tail of hws_send_engine_dump_error_cqe() there is already:
> 
> 	mlx5hws_err(ctx,
> 		    "    rule 0x%08llx:  |------------ qpn = 0x%06x\n",
> 		    HWS_PTR_TO_ID(rule),
> 		    be32_to_cpu(cqe->sop_drop_qpn) & 0xffffff);
> 
>    err_cqe is just a cast of the same cqe pointer, and both fields land on
>    the same four bytes of the 64 byte CQE (include/linux/mlx5/device.h):
> 
> 	struct mlx5_err_cqe {
> 		u8	rsvd0[32];	/* 0..31  */
> 		__be32	srqn;		/* 32..35 */
> 		u8	rsvd1[18];	/* 36..53 */
> 		u8	vendor_err_synd;/* 54     */
> 		u8	syndrome;	/* 55     */
> 		__be32	s_wqe_opcode_qpn;/* 56..59 */
> 		...
> 	};
> 	struct mlx5_cqe64 {
> 		...
> 		__be32	byte_cnt;	/* 44..47 */
> 		__be32	timestamp_h;	/* 48..51 */
> 		__be32	timestamp_l;	/* 52..55 */
> 		__be32	sop_drop_qpn;	/* 56..59 */
> 		...
> 	};
> 
>    Same offset, same 0xffffff mask, so a single dump now reports the QP
>    number twice, once as "QPN = 0x%x" and once as "qpn = 0x%06x", with
>    different labels and widths.
> 
>    Would it make sense to drop the new QPN line, or at least align its label
>    and width with the existing one, given the one-shot
>    queue->error_cqe_printed guard is there to keep this dump compact?
> 
> Source: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810092630.3137666-1-tariqt%40nvidia.com
> 
>> +		mlx5hws_err(ctx,
>> +			    "    rule 0x%08llx:  |--- WQE_CNT = 0x%04x\n",
>> +			    HWS_PTR_TO_ID(rule),
>> +			    (u32)be16_to_cpu(err_cqe->wqe_counter));
>>   	}
>>   
>>   	mlx5hws_err(ctx,
> 
> ...
> 

