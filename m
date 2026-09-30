Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88624FD26A;
	Wed, 30 Sep 2026 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790779974; cv=fail; b=P2/QdGQYJZ+KvoSajMv+leQai1ioD5E7oKprIC2GmPomsjlEtwr/5GeewSRHv2/ULapVtxtRa8fNJhETrayoYEE+mFmW86AheMBR0l3fwSC2UU+6X7V8VgiUuqX14VX1EUKlt6C/vYfgmqwtZbRh1IsSxWirTfxCvAOJct4U5pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790779974; c=relaxed/simple;
	bh=wLbtFw8NSTO93imkQY6YyTDnxkrPr6kRHDBQv65Ag84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sPirXmjeFRnTeifV2SsJcn4wKl1aRSlAcA0o/3wbQKbrvhl10SbToVWvO19nHQ/AHcUlXGoVgY0uOUYBeEHpmeFxb55NQfbEDqMgsGBG4nZVh2Ggvd+B55NrP9/f21Oi2xd/E2H3BfodDvNVM3uEY4w7DylsDfpIOgq8H0ryhaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A2zbX+qq; arc=fail smtp.client-ip=40.93.195.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A2zbX+qq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rTArQu37RnsvHaTznZdOnRuKQjjpU41OAbdok7JPD9u+QQ6OFcwb8N7wVH47pT5owCLwJ157j77A9s9AM7OhqPgnuCt66oxyYvLD8VpIRj6dWX/jIT6uxTFRCvyMesHPrcrS9Fa14ZycHICrnuFgW9CLkbpXJMSyNhJQhmCvNc05a2i0K19tWbbjm31AJkDeORumzymKxMn8KKfldVRSdPwq1f17/TLJN2QcCVbLven08PMI3oux0hwMX6gubqxMsyxGmA1yU77mvv0Gj9ZC70J9loWwK5xQj8wBlpRuHAIonmO0pkfYo5vNIxZRN98cbXEfZwDNpzaJ3ojMzIWo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmKrbBaCiAJqDuP6A6b35NX0u57+se9thdUV9MNigLo=;
 b=TOcZUXHk4/5xqLnqBr2k6+3KGONWPcQybbWQiqBSUOjS1hjCI9vNPAglKz6ktgpyiNKDvsaBYDctioKb5K8c1wiBywNxraXGynSKSI0T3hvDakAYuMHVJPVUzeExsk7CMlJyv2ICKkquAKvXfBhAoEHCGHDXl42rVvY8lnF6Z3adCVgm4cLQxW6dxT3N2ZTpwT6bTXCrEAs6X+0M0YFrnDFGg4xpC8210mO3k/+M3UZ5d2qZ099FRs+LyzUpAJ9hVwjPmn5EWV1900brIDQ4UVc8ywY4UKVp772Vlx+7u0wzYg047DgRSvpkj2Iu5HGOmW794OIAu4nPSVY91+thrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmKrbBaCiAJqDuP6A6b35NX0u57+se9thdUV9MNigLo=;
 b=A2zbX+qqV0mEtQDvLEx2qQoa65noFS/R6BnVvY+NLTQOVmFoOSyMCBaQAOX5uqmajgaBgWBQDRRar6QLACTV4DA8aVWSrRzP6qM+dI8BxugrSEVCIQPYwXmtRp40pZw6WLJc3EEQBIytD/Vur8B8wjct/mFqVAXr3T1bH4w8eIM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA3PR12MB9228.namprd12.prod.outlook.com (2603:10b6:806:39c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 14:52:28 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 14:52:27 +0000
Message-ID: <ed393791-46d5-40ad-998b-4ac0e1e9c6fa@amd.com>
Date: Wed, 30 Sep 2026 16:52:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Sumit Semwal <sumit.semwal@linaro.org>
References: <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
 <607e8903-a979-4d78-bf08-447321c03119@amd.com>
 <20260929132305.GJ563127@unreal>
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
 <20260930143237.GI3401365@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260930143237.GI3401365@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0264.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA3PR12MB9228:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c0161f-d4b4-4ed7-5cf9-08df1f02720f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|23010399003|376014|1800799024|22082099003|18002099003|4143699003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	B7ULWFaUzNWmRwzYADYhO48aS5SG8VsEAHpgWWgyEccMhVjC/3S0CgbXdlttJ5yQEyZxs5Bin+0+fz3+TgmdWGb7PpT3ywlXaCCuumE/m4LuYoNEcaRXeX09TGoYuGhgaZmhIEuXextE5Kr8nStENg0b2jGuRDtcgQwNAcKwmPiaVRTvjRAs1aEhcHqNj8QSGXPtG83FCg05/IE+8oZTWKBzmjV4/CdQQrhXKfpc3gHmctWpbdo7lBYZzOq7JBacMZwnFDcWiBE26EuVQWShqIW5xdFhzg9BprbNQQ7mRV75PJCdnZrgUhs6QW1VzJAN/xqClic6+hihdNkybLt+87y6am5QihKr8dfPNhSsnA+gt8m8pD29Xn9Gx7Df9mbDJw/0WPYo1cVRjsoshefKoF/bhzVfVaRubqI6yhPqTaox4A6rlt1bNHcB1DO0PHygMMzpDtGecGjPnX1KMbcCUJHtOigsah7Q3QZIQIFu1HJoW7KzLPylfNViuMV3TUv2smzjo/TQhRAPsMxrK0F2CQhKs+uJLCswdspRCc0GNK7NbTeJLR+XNckXJaspASyEc3QNKNyn4nHRGw+kFXaKcJqjwxDelzB6K5UKeZVyULotISJ+p7izeBzYApTevW6bJHnx2Kcg/PZsTwLOICm48Y7uruyjX8lb1+zirnffuN8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUJoQ29wSmtQSFRZNFh5OHNvL2F0VmhtaEl3UkNjMy9uajJSS2pmK2lVWGQ5?=
 =?utf-8?B?cTMzZW0wZjNpWGVYV3A1bFc0UWRZaGN0WmhqZHBRQVBqMm0zTkVqRjhDMU5n?=
 =?utf-8?B?UUhkMFo0MHpUdjdCWDVmMTI3aFA0c1gxcWVvYXVwWmorS3VnV1lScUpNeitI?=
 =?utf-8?B?ZkxIS2xOUzdsczBsNTFyS2hJakp6YUdTeGVpUytnT3VIb1ZKbS94MW5IeFZu?=
 =?utf-8?B?azdHNEVNYTdaOG1CZnRVZ3ZYZ1p2Ukh2RDFKVjdKWU5qa2xLTkd6TEYrdmdp?=
 =?utf-8?B?YW81TEZEc0pTbGpTR2NFUW5CQXVXa1d1VG15UjJwRkpqelJZNGhNU0lTOXpM?=
 =?utf-8?B?YWwrY2M3NGJ4MFpUMkdqMDdwRlRRekx2RzhoSC9TTk9GeFY4YjBDV2FrS3dI?=
 =?utf-8?B?WDB0eHNrM3o2RTJaazVkME9FVTBHSXBqL2QvSzFzYUlVeU5IU0ExdklZMmtC?=
 =?utf-8?B?bXFieVN2ZzVxUmVYdDZubmxVNldmQ3pVQ3ZjKzBXWkI4YkUxMDlNYlQreXBq?=
 =?utf-8?B?K3JLaTFyVXRnYjZLOWNSK0Jab3JMb3NHRng0NVhwUlV3NUtHVEJSVGZSQWVN?=
 =?utf-8?B?YzVkUGNpV2dHUENpTDFqSE93RTZ3UnM1RjVsYmhBTGthcVVBeUY0bE56Yk92?=
 =?utf-8?B?UUZMQmNvNXd1bVhDeG1OV2QrWTZtNnp4TlA5L0ExaHByU1JHVEdIOEtXaGd2?=
 =?utf-8?B?dmUyT2wwbzQ3RUhJem9jUG1CeWxvNDRFYkFhcjJlR0c2MHo0QkpsTTgxSlFP?=
 =?utf-8?B?UFd0YkczdVg4MjlMN25HZ0pqdU0xaUFIaE1WSmZJVFMzcWRnMkJEYXNXTEwr?=
 =?utf-8?B?TzR3c2JRV0lsWGlWMUZrcVBacUFpTUh5UmYyYndGU2RJZ3UwckFJdkpIVWhH?=
 =?utf-8?B?SG1lc2hNWTNKSTB1QzhzU2hXRnR0dXRybXc5MkhnR3pKcHpwMUFXTlE4SVZa?=
 =?utf-8?B?Ym9yMkhYdzB0VEpWYysvYk5XbnNKTnlESlFJUjVUR0RvTFVhQjVyT1FaZ1o3?=
 =?utf-8?B?V24yaU1qeHlIQkZrWng0anR1VzdyS3llUVZRMHNxcVFRU01DemFyUzlkd3My?=
 =?utf-8?B?a05wamdxOXJ5cnBUNW11V2ZQZmorRzROZ0lCcHlBNDNQbXlRdVlTSWgyaGd3?=
 =?utf-8?B?RndGd2xNVldoVVR5RDNUbG5tOWtXSEJhVFo2bEF4SFN3c09jSFJLUVpaTFJs?=
 =?utf-8?B?K0NKZFVXTmdNTHhMY01xckk1ZkN2bExjalpxY2NLQ3BUT2NhaGR6ek1XS0dN?=
 =?utf-8?B?ZjlzWXdQbnIvb04xWlYzQkRLTjlNU1NDTzZpcytxam9GT2M0S2hUUU9oNUdI?=
 =?utf-8?B?VDBsQ3luamxJRHBRdVluYUgwOUZTcStUaWVrNXZjam5tRGNrdTExcGk1T1dY?=
 =?utf-8?B?Q1E0RS82SVBwaUgrQ1dsSVRNb2lSWEdhazEvZmhWQ0p1eXAvbGhuNDZJL3lk?=
 =?utf-8?B?TXRqbks4cnJEd1p3SHBvTnMzcVhlT1B0YjdhVTR5UFAyNFBWYjdXZkV4V1RV?=
 =?utf-8?B?UTdjNmthOCtxdFpsdVVQbTZEeUZRMWxsRmZqSFZzZkNnYWR1RVpndXoxRUY1?=
 =?utf-8?B?QzNLZFR0QUtLdzZCMjFLWC9jcnlZdGYyYU5rcC9kYXBVY1hZb3JUR3ludDgw?=
 =?utf-8?B?UUp5MUUwV0N4V0pvZG9ZR21mOGlyNE95bFpVdVZVdkI1bzRRbE9oU1pMTjRn?=
 =?utf-8?B?emtWSnV4eGhEWEtlaE5NN0lxY1JPTU5RQnRIVUdRR3ZLdDVQYUYxVzBla051?=
 =?utf-8?B?ekFyeFV1SWN4cDA4Ymh5M1pUWTZLZGlldGRQUjU0QlovTTBERG1hY1Z5WFlh?=
 =?utf-8?B?V0dldHF3S3A2Tnh1NVlOVXlGRkVPNno4Ym1JY3pJZk9LekdXWmJTdUFiZXhM?=
 =?utf-8?B?NzUrNlQxTENDYmdVTmJBUUNPNXZwODlZUUh6NW1nT2c3R3RZSytyY3NqUUVR?=
 =?utf-8?B?UmI2SFkxOG54djR0RXFJSUwxM3hCSmp4YXBOd1BKN3dpZTErYlhPc3YxNWNI?=
 =?utf-8?B?MTArc3ZseUtPRytZYTNsSGxnOVV0RmZncXc5bHo0YkNBMGdDa3V0SWl1bnBm?=
 =?utf-8?B?M1hYKzk1STZ3V0RxcHBxK2ZiT045ZUI2WlZ1Z3h6M1lBdW5FS1ptS0xLdks0?=
 =?utf-8?B?WG9ueHJQZDEwdElHZ3JjYWNHM29Cd3JjOHZuUW9LeTgwd1RJQjJvZjkrZlI5?=
 =?utf-8?B?U2U2YmtMUUI0V25RWGtvemQva1gyYVNoZW9WKy8zTFduSjVwL205dDkvY2Ju?=
 =?utf-8?B?WjUwQ244dDk5dVU3UENjM0EzelFVZXBYWVBGUldhMEN5cFJKTTRwdWxTc2Ez?=
 =?utf-8?Q?yO5VpgTkNQaKMn7upy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c0161f-d4b4-4ed7-5cf9-08df1f02720f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 14:52:27.6715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPKistRSlr7nIBA/IQkXvfWI9IrmCZKM2Ed5pgpV1xDPrrHCXnR9vv8tAyP9Nl3N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9228

On 9/30/26 16:32, Leon Romanovsky wrote:
> On Wed, Sep 30, 2026 at 01:52:39PM +0200, Christian König wrote:
...
>>> The importer needs a way to obtain device information from the exporter so
>>> that it can configure itself correctly.
>>
>> That won't work with DMA-buf then, the exporter is completely opaque to the importer and that is for really good reasons.
>>
>> Why in the world does the importer needs to know the information from the exporter before the mapping is created?
>>
>> It is the exporter who decides how data is accessed by the importer and not the other way around.
> 
> There are several reasons:
> 
> 1. This is how DMA-BUF MRs are built in RDMA. In mlx5, they rely on the ODP
>    mechanism, which requires an MKEY to be created first. See commit
>    90da7dc8206a (“RDMA/mlx5: Support dma-buf based userspace memory region”).

I know that patch, but I absolutely don't understand where the problem is.

> 2. P2P routing is a property of devices, not memory. It is known and remains
>    stable.

No, absolutely not. You are making completely incorrect assumptions how DMA-buf works.

Again: What is exported and from which path is up to the exporter and only determined when you create a DMA-buf mapping!

In most cases you don't even have a single device which is the DMA-buf exporter.

Only while creating the mapping the underlying access path is finally determined. It can be that P2P is used, it can be that internal connections are used, it can be that the data is moved to system memory....

That's why we have the distinction between attaching and importer and the importer creating a mapping.

> 3. See the VFIO TPH ST discussion, where the requirement to obtain the
>    exporter’s P2P information in the importer was raised again.

As far as I can see there isn't any. The TPH/ST information are just passed through from the exporter to the importer.

We could define a bit better what needs to come first the mapping or the TPH/ST query but for their use case that is actually irrelevant.

Regards,
Christian.

> 
> Thanks

