Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793916097;
	b=cIt+tIO1rM8PcMHp/H9C7XkC8lBEyzTsnxQ089gDmnteHykNKjb8Fj48CikDPQkjn9RU
	 H5OpYYPd1/R3+TAGsR0zBG3r5s8duMiNu+G0eVp4yLE3a5T5TZUBBgRSH6S5L/PRozijf
	 Xzn36l2EMabVVmmDxtk5aSUcCB/uNUXF5nw8dKyYW3LKO60qxnrQav26iJ1IAHxHTt+sn
	 SEOrBYznC+FfIfJ72Uy9rxlBykn+Zp7fBONvDH7gjbLzF4EA46XCOm3uZkDft85Z6yioz
	 ziAQlJrX/M4/dtDj5UThCW31EJ7njGVzn0ePs2gpNrb2pRda4azsEiSVvUR3KlJ0+og==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916097;
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
	bh=BjSJj+zJDnnRI8+lGdW2YiDc0SmxvvggWXYIgTmnztY=;
	b=1DzxVwsYUTEnlh934Zj7liJubDR4pcJiZ/OTWE4P9aVr4T44mIVvYqlN/mq4GM8ziEfK
	 CtxFX/Px8GbYwOJDaI+0yFWOMdXGv141YJN+3XIb/ujxy71i64gokWEwQi7QRpa4XaWbS
	 XiPlbygLkPBSlxFw4bgumbx2LgMG3OYIuqr4mZBYQUCZTihPtQFWcQP1pQtO5fq75SDKk
	 wbGfxyZa/IgltkBGzuYDqjEKvGr7o6OM/my81TCQ121OnEiGi7GpV4V/9WfC3rRfwNIzN
	 Vz6cH2xKcBzKKZFbJwklpQ5p1pZ4rim1g07s4/8s+VAlNwBXjrYawkb++bOiCeJadLw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LCeIAbhu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.25
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7B9606A330
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E7B9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LCeIAbhu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d73xcUdG157+yuPXayUbqK8xxo99vdJSV7htYT7jg0dhEGqeyjpvwhJHYHsIACB+kcJJ4t8BPg7Eu//16OUc/VddCu0XBzsIARH5qMSeLsqTCwIjDWiEMLUVfEXtm8AQFEYLGz9T35wDJb/xm6Gllr9Ti664p/zYv/tASSuA0feIl16KtqO+qNDQLps8Y8k7p865ItBghf0u1pGHpODlr4Ix1vB1dFv99ZuFTkWN6zReqb4A82JN2BM6MZUPvFc7taLRM3sxZKtGDXZMZEQG1JmnutH9RpTufQXEixupMuu35ypMztKDvTb3UBJY2Zf/YfnxOzkfXmLh9qL4rZDt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BjSJj+zJDnnRI8+lGdW2YiDc0SmxvvggWXYIgTmnztY=;
 b=qWqoiVJkO7kJxoBLd2D4tvmswaibhHbTspUF/jHZcEcrWtZiELyfUaFlwHxPBhc521zOn2nAA077rtX7ic4uzFcbTLajHvG2wQC76zW0DEEhnDJGvLdeShMUcxkp+qNGuHih11dW2IFq85ezsE1MBZaoz/JQ8sjwEJuEae47pGX8dNZejF9OKzrsMeEUOomEmfYe2oi+GHfduYw5J0/J0RiklqoVb729tPupUZB29dWB6KZtlKzK6q/9fRugu4nm9A+16f8TfW4i2o1MIrtDrSQdxGUSxr9oxCPOSlww3Oue9dVV2AlsYXGFr+9bpnr2chcVR7pJMZ7fzpCfsg5QPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BjSJj+zJDnnRI8+lGdW2YiDc0SmxvvggWXYIgTmnztY=;
 b=LCeIAbhuBN2GfFwpYiLR1bKgAs1aDp7OXAZKo5SspoHG/UmzT2CiBdatCczDSYBwdwJIrTTIPV7aA2BxHpXbYpTdqDFAmozxvT6lge2hKIOtE4g/Z0+Dt5d74ZZNQTZaC9aBzU/gokTIrvpOifdJ4XsG+/IWmgwA6wViPBz2UUE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22)
 by BN7PPF62A0C9A68.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 22:01:31 +0000
Received: from MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9]) by MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9%7]) with mapi id 15.21.0569.011; Thu, 5 Nov 2026
 22:01:31 +0000
Message-ID: <396e7329-587f-4610-b492-a6bd28049ae3@amd.com>
Date: Thu, 5 Nov 2026 14:01:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] ionic: add devlink param for command timeout
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, "Nikhil P. Rao" <nikhil.rao@amd.com>
References: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
 <20261102-b4-ionic-cmd-timeout-v1-3-2f75c2d0a0c7@amd.com>
 <sashiko-outbox-196113@kernel.org>
Content-Language: en-US
From: "Rao, Nikhil" <nikhirao@amd.com>
In-Reply-To: <sashiko-outbox-196113@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0133.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::18) To MN2PR12MB3485.namprd12.prod.outlook.com
 (2603:10b6:208:c9::22)
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
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_|BN7PPF62A0C9A68:EE_
X-MS-Office365-Filtering-Correlation-Id: b0f8859c-d2a9-447d-b23e-08df3b88594f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261021135927099003|261021123027099003|11063799006|4143699003|261022075727099003|261026140227099003|261028144727099003|261009223027099003|261021121427099003|56012099006|5023799004|261022105027099003|261026121527099003|10067099003|18002099003|261102123227099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	H0+7aknPShRqR9Uf2BwLOOrgbAkoHiztWaJzKksUncDxAOitsg1mHBTeWDCG51hyW2EUCOUwyOELEFKvDnQTrTuSsmUr0JdIJxM5Jj0yNgC/m9tfm0A0egHZbmssyZEcchKw6qEyEK3skwrnG5t+QXwh9CXZvXTsyMka3aYuWfIqXz+3R9osHghANxUcSni0rslNzKlqBnzfUqT/GwQJNzlX99d0+rTxGaRxXd8Dn99lfnMbJU1O21np/F7pAw35l8P8CNE1S5f4Jh5GZ2iin/ZdGyPv/Sh+h2YFaiAD0IsxSM36Fj/B9OXwprdQHY+upD8hwbbFpoT4WALQ+ceaS7egTyths3jQHeWN5WBt4emMldeyBb0zt2i/JLxcBxK/DodF8H/2tlGuvXdUpz98YW6wRZxNeqz0nalYmCf6sWtIM7MSkIgI2CUOXW57+Vy5PcxIJv8OHCNEOxQwVZKhiFInIl3GAIcm5Weehv7izbnofNpWIvhz5cCvQIuy2hraZqryRmCnfyBUitWQ0XPdU0tgm1dOIVTUV6C5Nq1UNDSlIM1Vpv4pdjIoT2ibD+0OFEjxGiXpVGi4+Z9OdY6cEqGCokWMcbZ0Dt5pX/HZxSNDkSNykE0hKgFbUOygnXDm5cRnFjtDyUKMoU3h/uKWkSTjXxLDZECm1W/MkTQfAFA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261021135927099003)(261021123027099003)(11063799006)(4143699003)(261022075727099003)(261026140227099003)(261028144727099003)(261009223027099003)(261021121427099003)(56012099006)(5023799004)(261022105027099003)(261026121527099003)(10067099003)(18002099003)(261102123227099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkRlZldtZjhHY21zZjR1R0NBMVUyMEJ6eXpabVBHUXg2TU5pT2YwdGlscnhZ?=
 =?utf-8?B?bUhTbnRmdDAzNTYvWnk3dThDNmczR1BwTUdBR1F4eTF4b1d4RU5iYVA3amIx?=
 =?utf-8?B?dndscHhNQlVhUHZqenF2bDVjRlUvVDlNSm1NR2xGQjlsNVF3SlFUOGJUNlNq?=
 =?utf-8?B?L3Q5WVJISzdZS1F4alM1OVlHOGFNQ1lVelIvRUpiNjFQRXN5dDVDTGZ3L3lt?=
 =?utf-8?B?S2EzQ3YzdVNpMHROcWxwK0xiSVVBWVhMMHBPTFQzOG1jNHlDVzZGRTZPM3Nq?=
 =?utf-8?B?STE2TjJRUXFub3RGaUEwZ09XL253cEZDZHZrT21CTmFhenBsUWgweDFQdDE1?=
 =?utf-8?B?RU1UUXJ4d2ZmQmhrZGpJZzRNNjVDeG5tbE92azZ2Yk0xcHI0TS9ScCtSUjFk?=
 =?utf-8?B?MHY2Z0xYd2ZvNCsvVjYxRXJ3NmRBclJOeTVISC9CRS92ZExUU1h1WThpbkNI?=
 =?utf-8?B?QklsSHA3ekNoQkJ0a2o5SWRPU21qd3lvcXA2ZC9pQmR6bVh1WGowNWZXdWNG?=
 =?utf-8?B?ODYwc3lzNWFZTXdoTzNXOXh5b1dZNzJiSmxmR09HcGdzWTIwWTA4cUZ5dmdC?=
 =?utf-8?B?QVdjeUkrcHhuN1FGaVVXaTREUFpyakRnckZKM3lleVpYazFCQ1VoY3o1SjNm?=
 =?utf-8?B?cDlTYTl4ZGNhRWJPQ2p6NnVTUnpGenJ2L1lCdzBNQ2hPaGhYc3NzZG5HM2Vu?=
 =?utf-8?B?SVdzN3RWQVRiNUFRU1lVc01laWhyUGs2YWR2SEtMQi8vb2dRRmwzOEdycEQv?=
 =?utf-8?B?ajc3SzFGTjR5K3FHdWRBOERlaEhkOU9JVllWckplTmhiYm4wSVRLNVYxbFla?=
 =?utf-8?B?VGdzZGtxaEhTOXdKdGJsNVN0ZThTOFB0MmxzMkpaUTIwSFhXc1IvelZ2cUpw?=
 =?utf-8?B?ODk0ZENwOE9VUWk2cjZYQjhLelZ3T3VYSnVCVGZnUzkzY2lOU2tiV21JaGFl?=
 =?utf-8?B?RW1mM3FDZ1VRZzVhU3JMMjJJVXJnVTVMdk1nQnpNTWdVS3hqVGRyUEthbnh2?=
 =?utf-8?B?cUhlRVhQdlR3eThRUGxOVjlVZVMydWFKRkN2UzRrTlpzaXRzelhqS2QwaWM5?=
 =?utf-8?B?YnUzcW5jVFVnVTRQL0xITTFUWVdqUjR6c0lTKzExYWNvR0FwcHRkUEFnWUVq?=
 =?utf-8?B?SklqZlJ1TzVROFR0d2pNZjJTQ3RwUnVBMmgvT29CMG56OUhjRmp4eUsrQ001?=
 =?utf-8?B?WTlvbmhYeUsyeEV4SGN6SFRNVmp1cVNvQ2tUQ0Y1eEx2YmIyQlZPa2dieGFx?=
 =?utf-8?B?MVlxSDZFMVY3eHdWcFBNaEVGK1RLdGJCeUUxTUNtNFMvUG9IZ1ZaVkFXU0tl?=
 =?utf-8?B?d3BVeE40N0RXYlFaUzJRTUtjSS9TM1hQRWN6UDJBcmN3V0ZCKytYZ2FDNFZm?=
 =?utf-8?B?K2dXeDRqQ3ZUdEk1cm5ISUIrcS9MNG8xNVN1T2d1M2ZmQkNwYjZxMWtTejhs?=
 =?utf-8?B?NXJMQ1NROGF1MG11Wm43ZExmbHcvRTluQ3JFS1JVSUNROHI3YlRzWFgra2RV?=
 =?utf-8?B?bTZtOVduaUZkY1pQRkFmYXlVRUlHOE9nU2xrZlkyOUtZdVJQNXZUR1B6RFVL?=
 =?utf-8?B?K3FKRzJlUG83a01RM0J0K0JxeUVtU0ZpQVpsNW5QUE9QQnFZd3UvMTB2NVlN?=
 =?utf-8?B?clFiT3UyM3IxL2U2NFVKUEdJSmcrVEpESGNXb1F5MHRTaUY4cGxWaGk3ODR0?=
 =?utf-8?B?NGs0KzRsV09FdXZxcU90VjlOSlFFYWRnSDhORTZvWi9CdlhlaVZLa3NVNkxU?=
 =?utf-8?B?ZHliU1FsK2laSnp0Y1VYU3FLMEZZVEhGN2g3d0tzL010NGJObU42ZWRnSnVB?=
 =?utf-8?B?ZUdDVUtlRGNKeEd3Z1M4Y0xKQUVzMmlIZzM2YWZRZVBTTGlWNW9JU3Y5bnhC?=
 =?utf-8?B?Uml6MjQ3SVpGN1g2UitQTnd2VC9YeURZMmNQUDJYRmZlRHlWdnBGNndKcFlT?=
 =?utf-8?B?WGRoeW5iZ2U2dlFOR0toWVJ2clVRUDJBNzAvdHlYaEVRaktYMkkzczVEZTNn?=
 =?utf-8?B?S3VHRVZuQlMxUmkvNWhncWFiNmNsODJiL0JBSjlSdWNCcGFBUnJ1V0syQWNO?=
 =?utf-8?B?STlLT0NzS2pLL244YTRwTjhRbkxLNFBzRm90bVVEVEpGTzNRZzQ5WlZRTzFr?=
 =?utf-8?B?S01uV29ITmllQnJpcjZiM1U1Y1Nicm9LQy9OZzlkKzRDaitjL0xlTlQ0dmdq?=
 =?utf-8?B?RUFsU3E2R05vWVpCbDZhRnBvelpsbHBZaHhEZk9zSlJmUS9aODFFUWFqZnBB?=
 =?utf-8?B?MjdOZU1adlhTZWM4NzZQZDRUMlhPUVRtdFFzMWkxanBQNkZDdWsvVFhjUTBK?=
 =?utf-8?B?TjRiWUtwRm9LM25jb0x2ak83VkxvYmQ0bVNJb1RWSTFucTFGSzJEZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f8859c-d2a9-447d-b23e-08df3b88594f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 22:01:31.1855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZGRNlBtqTpLZjTXC1tMvlP2YbdHhRvLzxA7Tc6DpSoBK9210Vh91mJdTtZq3hPYxkYigkkI0yjlbuSaxoMwoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF62A0C9A68

On 11/3/2026 2:28 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>> +static int ionic_dl_cmd_timeout_get(struct devlink *dl, u32 id,
>> +                                 struct devlink_param_gset_ctx *ctx,
>> +                                 struct netlink_ext_ack *extack)
>> +{
>> +     struct ionic *ionic = devlink_priv(dl);
>> +
>> +     return ionic_dev_getattr_cmd_timeout(ionic, &ctx->val.vu8);
>> +}
>> +
>> +static int ionic_dl_cmd_timeout_set(struct devlink *dl, u32 id,
>> +                                 struct devlink_param_gset_ctx *ctx,
>> +                                 struct netlink_ext_ack *extack)
>> +{
>> +     struct ionic *ionic = devlink_priv(dl);
>> +
>> +     if (test_bit(IONIC_LIF_F_FW_RESET, ionic->lif->state))
>> +             return -EBUSY;
>> +
>> +     return ionic_dev_setattr_cmd_timeout(ionic, ctx->val.vu8);
>> +}
> 
> [Severity: Medium]
> Unlike ionic_dl_cmd_timeout_set(), ionic_dl_cmd_timeout_get() does not check
> IONIC_LIF_F_FW_RESET (or IONIC_LIF_F_FW_STOPPING) before calling
> ionic_dev_getattr_cmd_timeout().
> 
> During firmware down or PCI reset preparation in ionic_lif_handle_fw_down()
> and ionic_reset_prepare() (including when ionic_pci_error_detected() is
> called with pci_channel_io_frozen), IONIC_LIF_F_FW_RESET is set and then
> ionic_devlink_params_unregister() is called while the devlink instance is
> still registered:
> 
> ionic_lif_handle_fw_down() / ionic_reset_prepare()
>    ionic_devlink_params_unregister()
>      devl_params_unregister()
>        devlink_param_unregister()
>          devlink_param_notify(..., DEVLINK_CMD_PARAM_DEL)
>            devlink_nl_param_fill()
>              ionic_dl_cmd_timeout_get()
>                ionic_dev_getattr_cmd_timeout()
> 
> Similarly, ionic_devlink_unregister() calls devlink_unregister() before
> ionic_devlink_params_unregister(), which also invokes devlink_nl_param_fill()
> via devlink_params_notify_unregister().

On remove, get runs from devlink_unregister() with the firmware running
and completes, or fails immediately if the firmware is already down.

> 
> If a userspace netlink listener is monitoring devlink events, or if a user
> queries devlink parameters during the window before the parameter is
> unregistered, won't ionic_dl_cmd_timeout_get() issue a synchronous MMIO
> IONIC_CMD_GETATTR command while the firmware is down, the device is in
> reset, or the PCI channel is frozen, potentially stalling reset recovery for
> up to cmd_timeout (255) seconds under devl_lock and dev_cmd_lock?
> 

__ionic_dev_cmd_wait() returns -ENXIO as soon as fw_status shows the
firmware is not running, which is the case after firmware down (running
bit clear) and with a frozen channel (reads return all-ones). For a PCI
reset, get is only called from reset_prepare, before the reset starts
and while the firmware is running, and the parameter stays unregistered
until reset_done.

get has no FW_RESET check on purpose: devlink calls it from
reset_prepare, while the firmware is still running, to fill the
PARAM_DEL notification, and the check would make it fail there and drop
that notification.

I'll send a v2 with a comment in get explaining why it has no FW_RESET
check.

>> @@ -3495,6 +3497,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
>>        err = ionic_identify(ionic);
>>        if (err)
>>                goto err_out;
>> +     ionic_update_cmd_timeout(ionic);
>>        err = ionic_port_identify(ionic);
>>        if (err)
>>                goto err_out;
> 
> [Severity: Medium]
> The commit message notes that idev->last_hb_time is back-dated by the
> largest possible interval so that a larger cmd_timeout value does not delay
> the first heartbeat sample after probe or reset.
> 
> However, ionic_watchdog_init() is only called from ionic_dev_setup() during
> initial probe and PCI function reset, and is not called when recovering from
> a firmware reset in ionic_lif_handle_fw_up().
> 
> When firmware comes back up in ionic_lif_handle_fw_up() and
> ionic_update_cmd_timeout() applies a large timeout, idev->last_hb_time still
> holds the timestamp from before the firmware reset. In
> ionic_heartbeat_check():
> 
>          last_check_time = idev->last_hb_time;
>          if (time_before(check_time,
>                          last_check_time +
>                          READ_ONCE(ionic->cmd_timeout) * 2 * HZ))
>                  return 0;
> 
> Could this cause ionic_heartbeat_check() to skip sampling fw_heartbeat for
> up to 2 * cmd_timeout (510 seconds) after a firmware reset unless
> idev->last_hb_time is also back-dated in ionic_lif_handle_fw_up()?
> 

The next sample can be up to 2 * cmd_timeout away after firmware up, but
that is the normal sampling interval.

The back-dating at probe and PCI reset exists because the first sample
there only records a baseline (last_fw_hb is 0), so without it a stall
would take 4 * cmd_timeout to detect.

After firmware up, last_fw_hb already holds a real reading, so the first
sample can detect a stall and detection takes 2 * cmd_timeout, as in
steady state.

v2 also changes the changelog's "after probe or reset" to "after probe
or PCI reset".

Nikhil
