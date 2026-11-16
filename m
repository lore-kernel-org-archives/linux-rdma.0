Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794820644;
	b=UG4ONfMKZMM422DQzLiXFrhqUIQmG7J5xTrD70G/1xk7kzcUzAKc9tuOivmOA2N3zMiE
	 oXJCtWvGXwX91gvyZGtr+jTPKrKqw0nrxtW0wRH9fPOztyId8UJx/LL7gFjXl1RADFJPs
	 wXHPk+0dmctyTpcw3I1CxhPnarYoPF2z9twhnc/1zJa9zaoUhSG5zCvUn4lnmMaX1QZ0q
	 9zX+B0nVDko+vIPTu3Los5HyF49EjB/BlGlqG11I8990nBJhq/ZfgEMeVVKWTJHVFSoSj
	 XQn98m42EmmF8qjYkRmldYw2jjYAgCGP74Ic5W4lSJOytAA4PERNdvLI6NYbB0l5HQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820644;
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
	bh=c4rerke3klQsxoxP1AFY8RL3RX5ZgtTkkETd1RRgqas=;
	b=G8gpHbBCzdKaGpk6CUtujk69k/iE84wWAafK/S5l8etmSoKt7+iquWEWKAtPm0+tb18n
	 28wFf1icI9LSfoSkkmgeSH8Tco/6gBsK26FVRCWLsZqFiLQNnsOAdi41siqBBqOFhonZ6
	 qsezD/40HVb4TcfDE344TO+b0A7s64VFR3oJsT8oJ0YsApq3s7LNIJFVgYqng+HtRkont
	 A0TTG9GKXKnbR2z9tMjKaQKECxu9mMfK+ze/S/HAztOUPsetpCi6W4it/aVrPg8aqmL2P
	 5xw7m1oPBHvDgpG7dsWmDQwrNHanRH1vdmmTgD4xuX5tElZISYqYV2LwpsCdKYgXwWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=q342dsqZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.53
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010053.outbound.protection.outlook.com [52.101.193.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D05606A32A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 09:17:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1D05606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=q342dsqZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jY9fzM4S9c+zvskBj+p+F+AqnCwpNidPkFJ87MbC2DZSbn7eTzJBDcbuZVrawiZuZH6RR5sKBql3F4zFwx9/tD+cpwph2AL8+hQHF5wtO47ud9DNLlJQXXgi5c4uqZJ8/s1yf3rKg04RVwJdVkwcc9oF14GsTGF9V0XAjnH0yp9s3F/68O2vRtCYaGc8YgiG/Q0q32Kqa9lIoFv6SqSrdB1mYymvZ7mFXwsBOxbGioKyly6IlJD3BCZySHqz2TMea5TBaZ5HtRGD3n4Ij23N06OKs5g7FLA9uoMMEMLRdJU7urDdyfXNWEHJbx4+eEEe+wNvrvjaH4VLsbfObEPijw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4rerke3klQsxoxP1AFY8RL3RX5ZgtTkkETd1RRgqas=;
 b=GYba2H2Cv6/ykou6C3huIWdGbOZWtFVCFu7mr/ET1S+Ywf3f3WL+9gM1a95d0wf6/PzF6X8LrcBrPQb9H7g1W8mTYGG/ZGJDJ+TDsY47VdDQg8hhJSag/y03zAMZp2YSML0q+b80HdTwfE8YfcDki7qxp0PlN955NHoqMv0CcdZZbcyC5wNlXRwh/XcXEOAH8yj+Ymhq/HNV14f2lCKREnMPy9Yttp3WmJUia+D+XNPNxsud99sWbm1TKAn3QjDBIbsn7QYYP+XaptKxAERWJ5CsFq9TUsPO/PwuHIPte6UupVkNBCn/IgNJ2whvnYWHE0DlvJ0hyaHS6FGSQmSLkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4rerke3klQsxoxP1AFY8RL3RX5ZgtTkkETd1RRgqas=;
 b=q342dsqZ6TEcEhvU0mKCg6iHeDOvqnASSCrgOVqw81Ky+PtNg3ZelTKha6kC5qlRqOSoN3JmXyu9f2C/RHf7li/XDAFhutctf2wDN69zfNz5Im4If3zPBl88P8DR/VgkN1Gf45t0YDD8IQJZ/wz40GwU9nAv0f4ItDfcBP2lDNU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS4PR12MB999102.namprd12.prod.outlook.com (2603:10b6:8:2fc::9)
 by DS0PR12MB9448.namprd12.prod.outlook.com (2603:10b6:8:1bb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 09:17:21 +0000
Received: from DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25]) by DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25%4]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 09:17:21 +0000
Message-ID: <2770c6d3-f595-5d6b-afec-dfa8fee30697@amd.com>
Date: Mon, 16 Nov 2026 14:47:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next 3/4] RDMA/ionic: allocate a PD-scoped DMA MR
Content-Language: en-US
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
 <20261107150249.1576835-4-abhijit.gangurde@amd.com>
 <sashiko-outbox-203825@kernel.org>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <sashiko-outbox-203825@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::18) To DS4PR12MB999102.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PR12MB999102:EE_|DS0PR12MB9448:EE_
X-MS-Office365-Filtering-Correlation-Id: f72997c5-ddb8-48a3-c664-08df43c26b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|261009223027099003|4143699003|11063799006|56012099006|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	FFxDUvla/3cMHWUHGV/wBezh+w3tFHKJrWs3Qx8hqDmM0TGXccx/rB80Kct97VBvKNP9blFbWEg+954SPXHPBtxLZ1MHQIhVuCsFCeXhACmZoQ2obRvtr9K1qDoWLmG2XiZzD4/uAmhRoFvWYXQkZ/YY10yK88uPIiWkdVdZwDyRw2BjSAQkGGp94n2+NCzvZAfx2Rgb7RXa8qoHobtyqoCkVI13rXGwpQCdtKIj+LvZcJ4Wv7wyBamZ4bD9Wz3yZE0gc8jugnZhyd4/lQOPwtgr51UIUDXq8o01q6L8rWmFCQkZwGH6FyYWj5M5VIZmgHA4axHtDlGdoRhqq3OAinh0MRk6IuuaBb/sK9ULyOhE1mSEbIwgZjljOKcCFneLsgweKofdT/Z5owQ9/xE2YDR4Cwtp9yaPZijO7ByPTkqzpSx2EPfVAHX2RZl5NR76Yqr0rzzQ1xnLk/dOtJFCv8Za+wv/hpiZG3W5nP4E8RspmxDGLcsRIulBJrHqrqelCwu6P9csVEpvC8aLaMrBfU/Spxv/ikbZqpPhY7D8HkEyUKnlNy95Vpsjyn0IfZTdznJHQ4tHJ2w0E6nRQcAcYfe/SgayOdrTHjcv/gpQPWPsQtSDtboOlHjl96ILamQm/siPKkR4e2SVDBlAhAG+dRcH+iETvojgDr5Z548YWdQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB999102.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(4143699003)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzRPMFZRVmVLaS9JQTBmc0tjTmxXZ0psVkUyQUo5OGV1c1JLM0htNnUvYzYx?=
 =?utf-8?B?bGZtblp1V0xJMWhscXZyeGFseW1KVUlscnRTMzZJTzZZTlphRHRWcTk5RStC?=
 =?utf-8?B?S0pLOHlKUVl2QmEvS05tMkdOV3FaNWVBcTVHL0tLZzBCZFpjNzl5b08wVi9I?=
 =?utf-8?B?VnRyMkRaNWRUWW1qRDlqOHJCU2ZVcmlXTVBIeVd4U2diSVlRU1JvVHh3bnEz?=
 =?utf-8?B?VkdNb09JWEx5R1lodWtZb21KTEdSdzhwN3Iydjg0UWtibmFWNHFodW1INW5h?=
 =?utf-8?B?MWFxV0gwb3hOeWdCU1FMY3RRbXJXSUo3cHRGSnJkNGJaZStrWWRka0IvWEo3?=
 =?utf-8?B?bGs5eExMK2FPRDhIQjhjeUNnTkJFamNRL2hUMWkzRWNVR2lMY09VdlFnS0F6?=
 =?utf-8?B?RHEvQjdrb2cvbERzdS9yQndVSGEySnJ2Q3FiQ0N6RVdiS0ZKWjdsNGNtcEox?=
 =?utf-8?B?eFJhU3RVVXBMV2dqYis4MnZRbThYZkZJZk4rRVFHNGxJZyt2aUpMMEY1U1lL?=
 =?utf-8?B?OXRCU1pFcnlDaXlUTWd0WkZ4ek5TT2lXUVQvWHdtbWVnQ3RsUmcrL29ydFhp?=
 =?utf-8?B?TnMzSnZ4cnBVRVZoaEo3OHhtN2JLcTZrL3BGUEdyaGVZVTA5NDdMYlhUWUh6?=
 =?utf-8?B?Q1hSNWJhL3ozbUlURHpZdm5Qd2U4ZTNOcTMxdC9sVlJTSTMreTEvSnh2WVAv?=
 =?utf-8?B?Tjl0c1FoTk40NlgyNUw2RzZIRWRueU14MWwyZURTM2NIT2Z0SHhDRXBkZi9P?=
 =?utf-8?B?eEZpNFZlT3BxcTBibk1VMzBZR1RwREFsR1I1ZjM2ckY5Q1krZUE0emQvS3RO?=
 =?utf-8?B?R0NENWtCNFVOeUlYcW00OW4zUStGWEhTQk5mWmR4SkR0YzdFaXRWWEh4eGh0?=
 =?utf-8?B?QnVGd2FDeEozZm95d1A4US9NbHFMQ21EcVU1MGJicEhZYWJNbmFTamZsQW9C?=
 =?utf-8?B?eHBUTGluczdXWVpPVnN2cUtmdFE3N2tKa0twNCtoNTlPd1ZzT2M5SUprSVhj?=
 =?utf-8?B?bVExT1VOa3RESTQxNitrM1FxVFBuUFhpeVQ1d3Y0ZkhRRHUvQm9rUHMzVStz?=
 =?utf-8?B?ODZmMzd6aG5WSWk0dUgvWE1hVTErcUQ5ZGo3bDVaeVNNL3ZwM1FoRWhWTWIv?=
 =?utf-8?B?RGpuSXpzSnFVbHd3enJRNFRuUFhhS3hBdGVUejduS01ESFpFSGJMNFZrVVJR?=
 =?utf-8?B?TndwN2J6d2lhQ3VhUmhHTm0wQmw5U1ZjNFFOS1JjR0ZoYlUxVEVQd3dwZlA3?=
 =?utf-8?B?MXRMek8rc3FtYm00bGR5aURqaGw3WVRkbU9rMTg4Zk1KOGxtd3dzNk5sektW?=
 =?utf-8?B?b2hLN3h5Y3A0RjJLeHY0YmpULzNaZHFQc2NjTTJZYUZFQWhscnpUaGtaL25u?=
 =?utf-8?B?UTFWZTJubVdGY2Z4d3hwS0lHRktmVExWZTVMTDlvWUtrK21YNHM4NDdnSlNi?=
 =?utf-8?B?bWFKK0Nqb3l0R2JNblBLcnczNUNWUk16OTdPbWErbnYxQlRrdXh1N00zYjhN?=
 =?utf-8?B?d3VEWk0ray9IOW1hL3Z1eGk3SXFVSVl3MFZtcEJoM1I2N1NFdG1UVDlDaUpO?=
 =?utf-8?B?QnIzeFFxbnBIMFdvaEVnSVFBdmU4eGhJTWRudkw1elhWUDZONENCZ2oxQ2ZI?=
 =?utf-8?B?cTAwdit4ckZEOVNXajRQdm9Db3Z5Zm5oenFwVkpuOGxjaEZPMGN2SXJ4Nzhj?=
 =?utf-8?B?Qk52WmNsbzhNYWkyZ0NmR2drOEFHTGlRWXM2ajhmVFpSbEk3OS9TOFc2TG1W?=
 =?utf-8?B?NTFlNHUyRXdBT3NlZjY1bGhkbjBuM29KNXRCRFBXbFVVMVZsOWplYXZHcDgx?=
 =?utf-8?B?U2ZCdVQyOVc2K090TEdJSG14OHZTblNXZ1dxaG9VbVN5TC8yNU1KQ1VQbmVI?=
 =?utf-8?B?cjd3aXRDcnUzcmZhWXlqV3V1S3hOM0VxSFpvU2tCdWNYVVVybkdNNGtHTTJV?=
 =?utf-8?B?dXF3WXRiVVJzZldpT2ZyeTlCaS91N2lxZExPUHM0VXFSdFljbnQxV1FtSnlu?=
 =?utf-8?B?dDNLR04rT0llaDF1bkpoUk95UnlLRVdNam51WEJmTTdOUjdTbTc3V3U2b1Jj?=
 =?utf-8?B?Rnp3cmdoQzVtdUV4UU50VDJ6V3Z2VHdDNEZnOU5Ia1p2UkdvZnlsL3dEWmtU?=
 =?utf-8?B?d3lWeFJ4Sitnc1JzOWtlNWRjVTNxajd3U2ZSN1VOSnNiaGZEYnlFZmFobC9S?=
 =?utf-8?B?VU5FdjZkdHZaL1NYUWQwVE1aRjNYaFBYcm1wRXcwM2dGeWxNeENDeXVER0R3?=
 =?utf-8?B?NnI3Y2c2dWJEdXg0dEozQzJLbEl1azA4T1RCalI4QlVONys4Q2pwQkFOczVM?=
 =?utf-8?B?cVp4WUY0ZjViT214cGhaQStvZFMwZTBCbTZxTUJOYkF4MkVwdWRXUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72997c5-ddb8-48a3-c664-08df43c26b2e
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB999102.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 09:17:21.4640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Udlr+02XL4KiKGfgqO54rHVwXFeFMDuYMKX8ey+AIMRrIf4URO07e6JPx4NLBwDTgiY61fp2kFM0eEjOPihow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9448


On 11/8/26 20:34, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] RDMA/ionic: build failure in ionic_fill_lif_cfg() due to
>    missing rdma.cap
> --
>
> commit 71ee46b9e5e60e185b9553d17b2722a569d100ad
> Author: Gregor Dick <gregor.dick@amd.com>
>
> RDMA/ionic: allocate a PD-scoped DMA MR
>
> This commit allocates a PD-scoped DMA MR via CREATE_MR with
> IONIC_MRF_DMA_MR when the firmware advertises IONIC_GEN_CAP_DMA_MR.
>
> [ ... ]
>
>> diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
>> index 66cee57442e7a..dcf54856603d4 100644
>> --- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
>> +++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
>> @@ -95,6 +95,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
>>   	cfg->rq_expdb =
>>   	    !!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_EXPDB);
>>   	cfg->alloc_qid_cap = ident->rdma.alloc_qid_cap;
>> +	cfg->cap = le64_to_cpu(ident->rdma.cap);
>>   }
> [Severity: High]
> Does this break the build when CONFIG_INFINIBAND_IONIC is enabled?
> The rdma struct inside union ionic_lif_identity in
> drivers/net/ethernet/pensando/ionic/ionic_if.h has no cap member.

Patch 1/4 adds __le64 cap to ionic_lif_identity.rdma (replacing reserved 
bytes). Patch 3/4 uses that field, so the build succeeds when the series 
is applied in order. This appears to be a series context false positive(?)

Abhijit

