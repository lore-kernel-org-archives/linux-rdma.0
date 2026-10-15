Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8274FB9D0
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088567; cv=fail; b=WUxMvNgrXy5hSDYEXNbtlWNpbaAr6Wjlll1G9VcbVC8d3I6jJKXreKVNlvUAGVv+/+RMoLaH3xMb4tQD8y0Y5Ze3XlBejtxZMfib1625d9c7U5FmORLnsO+rhkFkMUAlUwo68mS/0Kd0fqrhvf1pzsOPceYgGptGLh8LHay2vbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088567; c=relaxed/simple;
	bh=oLScwHjL3hiuxhf1VTdEvACgKXG/4v0BwBU0yR81X1g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PnipEvzWRHdGseDwDmZyxrCUAYyCO4n655yZ/Ev4KrSuWdwy57FnFxRqi23S80PDgJhm2pY+vGm27JaqmtGgcfwU4YlCT7qC2+58KN40HkZvTLvsnFDiXgFsriLS0RcbdrzbiVyShaVe9l7zuEAz+CEg0KUimMU9dxwOu2hsPlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=P/VYp4ss; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="P/VYp4ss"
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FH4q7j600437;
	Thu, 15 Oct 2026 18:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=mTF6wHjyJ5Goo3b4hGqDVdlAN/
	o1fPOc0IMqQsnjjFM=; b=P/VYp4ssF2w7DPrehWc96bQxNe5fjbTsn2d05e9zLr
	yziuBvvDCp6+mesIUEk8fa9tKtSESFuFINnWaRffQHxmENV7aB/dauvpRf4Y5NSg
	zBdu5JbHOX1K/W76zkQ0SNZCTinwJJYyrsXFWVnTAT35Kx9TbzXAgG3JvXaktBuH
	pD1YlTSrKwm9nAEbWY21pUssh4Z5X9OPAvJ9jFuATIPUge5j66WflhaxycqlvqSO
	ZmGfBdFl4vK67wQUFw3eVfk/vw7Zrg5sbJSgwuvj5AmsgA15MUthJaIYIgKap11Q
	Xt+Q+hDntUAhzF7EYF808KO//GvnUfyHJYaF+Sg9aOGQ==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hb2wvh3s9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 18:22:39 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 6025B804794;
	Thu, 15 Oct 2026 18:22:38 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 15 Oct 2026 06:22:38 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 15 Oct 2026 06:22:38 -1200
Received: from BL2PR08CU001.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 15 Oct
 2026 06:22:37 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYySOmzRitVjy2z35vj7dzxym0HC2eE5M7hSidCX7ReJuGiKpfMCQIkSn/vtB/Vq+Lqa7KHLggL8tRXBhG1j82q69yspELHFcstAYbTWNlE0MnVvkOdR60WLVNzWAwGed5RPBhDoPvj0prEcSx6AMUaqAc6QO4vLkMTuIMORddho/yrde1b+6aEOUB7U7JQVLziQyatxydaW3KwogoV+FzGP1RQFNii9bGSLE4Rm/bL963tkLt4eOFoHoI7RAZEUsX4Awb2mp3j8yQqJECSywU4+fOKWvURDso6gPXEyAEb0+UHGtFsTIUGr4ZZ6J5v6Tj08Khd94MBpI3JQEZXxkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTF6wHjyJ5Goo3b4hGqDVdlAN/o1fPOc0IMqQsnjjFM=;
 b=YrTCQ/5JdU8xaiwrT9R1YIsQdQG/IjNWhFtvJ8HxUEl3YtTBlZLfc9CnBqbt0TD3GyhJMrLRZ74SaaXEWdmHjFUyKP7OTkRUNqGC5RKfhK1Np1djsMF0KC0GR3P7Bpxymzzkp0QTk0cLhQYkA+oDHt6PwNx31+AeXKULnV2JYFGakEXc/70hSvisN8ynT4SqjRztE1TZ1tqJg5Y0qnP1SiOqjeCqXe0PRGT1s1Av9BGi5xMKwm5314rSGU88su1N13ugznxLQ2Mb/vKZB0OOpsOOU+Wt1BhfPstJUuQqhzX04j9cTCVieFGiez5tG+gRhPJcbl6/W58F2mF13AFY0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB1585.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:22:35 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 18:22:35 +0000
Message-ID: <f83bc802-7e4f-43c9-b19d-4c397bd88483@hpe.com>
Date: Thu, 15 Oct 2026 11:22:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <eric.davis@broadcom.com>, Leon Romanovsky <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
 <20261015000834.GQ14213@ziepe.ca>
 <733df751-5e7a-4004-84d8-627320734c30@hpe.com>
 <20261015172911.GR14213@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261015172911.GR14213@ziepe.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lUW08kH4yVyhGM6BzePxoHsb"
X-ClientProxiedBy: PH8P222CA0019.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::21) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB1585:EE_
X-MS-Office365-Filtering-Correlation-Id: bf1f34b3-e742-4ce9-e5ce-08df2ae9490a
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|18002099003|10067099003|22082099003|261009223027099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: ybW0QGDXVJKFUP+pDnq8fX3s0uD8z6MlCjPdavz+noexmPUbl6yUFDwwJeAYskTYa34eOzwrSpinzGWE9QL/wk4/Bbbt38jYuhk6bOkeE2b/Oclb+SNxWI9TA6y4UiABgV1pABSuNKMSI6Dtazp9XcumTas/ENCwc/gjUM1upF1ktQQUBUow4vGBQ5YuBPgwOmBqJvFUSJm22/cCOKwiVDL69af10xHSiyxaKkFpgssPT8dfSOt7Hp+VkncF4iivofFBWmNd+H57EhKAHp8+JKckp8B+iJLxEZzj1ZDqUMYMW8mVDp+Sa2nVELbJVp6skU+gkpDKdDM+VvAaZ3YciLcygWtLOhajb09PMPGtXmErfRUE7q63pCD8scy6IFTK9/td9xQFd+US04ZdXrNQUVdHGkB9t485y2lI3y7QMh9jGM6t1FkvfJKvy7lkHuTcAFE2826Wpg7eaD69NtKq3yD/Kjg9NFTHcLhnNZ7lUjwdbPXkd23+m+eJfqhVCrTMQznvIU6a81t8qVCeOwEUzf1ATlMOfdhOzuvjHpnDfMi85ffrFkwrzLEHswAN0ECfC82BUT8RdUM1my4TI27eW8iKuuKHOnB6LG3fMyha3aq6kQN/OUhklA2UD4gq4JXkZh8fV8BkmVIpKGKIkRRCjBnFHmizKkyWMPd/q3hz+ks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(18002099003)(10067099003)(22082099003)(261009223027099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejU1amYzd0RGUCtwcHlWaVlSRkZsOE96cnN4eWdGYXZtWnBDdDJmZ2o5TzFx?=
 =?utf-8?B?YWk4Z3dYVk9uK1JPa2pWbDdTNSttVWM5d0ZUOFlHSFpwU1lLRFBTMUM4aEsw?=
 =?utf-8?B?bTdlUnRmVUdZYzVMTkk5SXFjVERicXBGLy9zZ2dsU0NYK0pjZFRWdk1DWk1v?=
 =?utf-8?B?SkRIbkREOUxOOFJ2eU9laTg2RW9CdHh5MkNGeThiTHZXL01mNTYrZGhMUXNZ?=
 =?utf-8?B?NHdQNlE3NC9NOEdsbGtqNkg3SEdtbHB6bzdqODdDQWZHSDhUV253TStlZlM0?=
 =?utf-8?B?T1BpTEoxL3B5L3dMeFN0Kzh2SWJDcFljS1cxWndVNnQ5SFluYmExSUN0SjRi?=
 =?utf-8?B?b29TempkWG43elZDZk9GeVhPYXNFVm10WTBDdkdJWEJ0bW9PRTF0amxtQmMz?=
 =?utf-8?B?NlU3aHdpclkwaXpnWlB1ZmhaanZsbURCSkRoUXJWR2ZJTzdZcGpLNml3TTBn?=
 =?utf-8?B?TzNzTXNFNmQyYlRIOUZROVlGeHMwbjJ3NnA3Qnp2RHI1OWJkRk4vTFNmVWRt?=
 =?utf-8?B?U1NINE9XZGlzcFcvclpvSUNxRmNheUYzZ1lGeGdCais5SXhrNEJNaFFwMVJ1?=
 =?utf-8?B?NjRnaUpCZ2R6eHFvYmdPV0R6NlFJMWJRVmhJYTZrSEFwZHhxdTZ1bGxoRDVo?=
 =?utf-8?B?dEc5eWU1NWZvaEFnTHZTNkpHWFI1QzhGbDRTZGM2eUpiWGhPRk43NlExUmZJ?=
 =?utf-8?B?dDNpNFVOdkI5MktYWis4VXpza2JETUo0WkFRVnA5VVRRZndaSXZucklDWGV3?=
 =?utf-8?B?TFBzT0p2dUxhaE9kdnY5TmhjN3VwTXQxeE11L2M2aXRkaU1hRGxLWVV2MW0z?=
 =?utf-8?B?UWxkWm85bUJVSkxzU2RWOHl4SVJzZVNONlIzVTZ1Y3QxLzNRWVpxVlQzU0wv?=
 =?utf-8?B?azhvcEozLzBySGhrczIvVkRxSHhLWm5rN0x2SFdUU20veEV0aTRma016ZDJF?=
 =?utf-8?B?SVhweEo1OG81OExNbytaSy9QTHIxbUYySWFHdW12UklQK2d2cFhKS3ZjMVhO?=
 =?utf-8?B?b0NicmlDcjhLTm5UbVZXb0M1NXFFUmFMbTd6NU5GeWhPY0Z5dm96d1N1dG9K?=
 =?utf-8?B?L2dhalNYM214d0RqWHRKa3ViS0lscXErN3M0RHNLUHllN2tvSEc5RFJ3LzZD?=
 =?utf-8?B?VW1TMSswR2xjMEFRMEhrbFAxT1NNcWtiSDA3ZjF5UU9LcGNjR1g3UkdpaERp?=
 =?utf-8?B?M1NCcG03Kzc3NVRFSGc3YlVKOERnVTR0T0ZiRFhkT1dSYTl5clBBMkQvbG1U?=
 =?utf-8?B?U2FkRTJDSHg2TFhSaU1FZnpINWw5dmFmQmxzQk5IQWFiZnJTTDF2K25NSzdl?=
 =?utf-8?B?amtOYjlvc0RYY2VES1ZIMTdpbTVldzk1Z2dPc3F2emN4Zk9XMm1aQldEbmpT?=
 =?utf-8?B?d1RSM1ZWWDlrb1BhWjZna1Y2c0RUR3FocW1FRXZkelMzblJtMmJ0TGhLSUZq?=
 =?utf-8?B?dGkwdVFybHlIazN5ak1NemdZZXY0ZlpiZzRYRTU3K2NVYWprZDBDa285S3ZP?=
 =?utf-8?B?aXhZaFAwME9Zb2JLbk5wM0ZPa3c3b1hLaXNPbkF3bnRFMUlJZFdpTnNReEx6?=
 =?utf-8?B?OGc2Y1lEUHJjbjVzeFhBclphRy83Q2pDWWJnL2d0OGlJdkNrQ29XVVlQdHRz?=
 =?utf-8?B?U1J6emZsbTI1a1RJSEMyRGp2WDJSR0ZOdkRNZTNteEpZK0RFdjhidktNRC80?=
 =?utf-8?B?ZERYWDVZZkdIZ2VNTVU5Q2tEQzJmazFlamRuVk1xVGgycWRBZkREQ1drQm1S?=
 =?utf-8?B?YUx3VkQwajNWVDFRNDM0TTdpNmFscktJQUpyN1BXOHU2V1pyMzVvcFpaZS9m?=
 =?utf-8?B?ekJqc2NiaFcvaUNrQ2ZXWnJkZ0MwTjJxdFdCVkY5N3VmUUF6RDhnRU84ck1V?=
 =?utf-8?B?Z20yV1FObDQxaGY0REdxbDdMS0t6TlFsQTArbTRmTTdXTVA4NkNVWk95b0or?=
 =?utf-8?B?TmxSRWxqVm9PSm1iUGxPOVVpYnB1bklBTFphVExzOGFFVjZUdG5TM0NlRmpK?=
 =?utf-8?B?aWNDR1BtN0VDcVJPenJPUjVkVFVVbnNGT3lJUmgvZ3Jxa3dEcTBjcmlwV3F2?=
 =?utf-8?B?M2NSUFArRFRRTE12UmQ4STdMN0RQQjNNV2JUbk1ESGhGT2l1VHlyck9ZUFFu?=
 =?utf-8?B?S29hSXJGZVNSMklwd2xwUm9iU2NNOU90ZllzcUNmWEZWUzdOTmxnMHRhczVN?=
 =?utf-8?B?V2JtK2hiNzRPSVBSN1RwMUg2UVRkakYzL0pXenl2Tktlb1NVYm1iT0dldzds?=
 =?utf-8?B?T3JwSkR3c0pva0s4ZHpVbUFkNXJkLy92Yzc3aHZpVndtUkxtK2l2V25ZL04y?=
 =?utf-8?B?NFJ1OFVrc3NaaFdoUkRzZFZrUmxQL2diUnFjY3FiK3hQS0N3OXlUdz09?=
X-Exchange-RoutingPolicyChecked: hEuFbzFXVSFQCs2iJR+GNaottR14oFCDfdxK35KHyOuw3PmiVHgqi+6R1lc/k4nsez0yRnqqPg2MBFTw9adKIGtVYecn9rjfDu7obKizfybUh0HUa1H9F4EMBjRwVCTgxGWsOcfNWSn0HN/UftBdiicICQSrlA5N5xcFKIeapof1Y1JbUIZChMaxY8g7fHDbaSTywzpc3PCyL40ZsNYUk2hpBwgnNwZXaX8ZruqixYZ3YceR1iIl4tIGdfdQHBoRdkf2b/u8u6Rz9ua0dUwYmjbP6GA13/zPn/JcfBnBnKGjj741E4aPJSUQWTsemoNqMc9TNDpIbZpy4h2zeCSkCA==
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1f34b3-e742-4ce9-e5ce-08df2ae9490a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:22:35.1649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUi0QkCb3+ufs9bk5lQCNhaDIGctQDmOkIIfPMl+0d6Uy/Lc4k9Z68BEq8gtacCv3+7AiN8aX9U+h09EeX5iFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB1585
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: TyV6loltMPutfCXO955rvyuVaCBocJ4K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA3MiBTYWx0ZWRfX+SHJznqZKGCr
 dZOb2UP9iwuDEiJ87infCGsO9htZ2BDARAblXzG6wP6WT2qeg+Gp9r/LnQmzAva4jSrx5YYgE30
 3pSLv/hty4HbuplyX5cIHAUuLTBoHHHS8gWc+BW0Evov3n1WXJDWu/TFKCVcW3u5YjvusrAgDAD
 YRDZJ+TeVaHX9Wti5PFriYzRFsJ4TN0UTObkzCJyTfrmY2jkGY/iLmizk51C13I8Ow0S+6JJ6Go
 pb9ZkuTb8d725YfTT0xIGfzpUDz4tlPnvomH3yfRz0Jy9T3DQlFftqRf3WXVWGF0lmA0KrztVNk
 hDHPS/uOj5ewsOw+5REqtvbivLE6dMYpQ4iVmAzXODRLRPtw3ViuAPyMacmiavMQ1RlERHVT5lM
 oUlR3WOfA2/x9IO6IQBWnwUv+SvpAozn0Q8lkV6jd+BHLsBfkCymI8VA598YOR97l4QLLE42tGu
 WIJAY6rOZbn8itwCrdQ==
X-Authority-Analysis: v=2.4 cv=bp3Zl0ai c=1 sm=1 tr=0 ts=6ad119ef cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=g3u0LPWLDYfGfufhFw6-:22
 a=MvuuwTCpAAAA:8 a=QhYclbzQx0XkKB4qZJAA:9 a=QEXdDO2ut3YA:10
 a=BP0-5XV_XJw_qWbeU_UA:9 a=FfaGCDsud1wA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA3MiBTYWx0ZWRfX0enbI6kefT+M
 gjbqiAxjbkG2wVrhhPVJUpOeLwLav4rVQ5Yy3i2RzvS/WZ4ICDGW0xILosq0oPXbDBndM9bAgee
 89/rOLeuJkZ9tmqx/sVMax2fFAj2skc=
X-Proofpoint-GUID: TyV6loltMPutfCXO955rvyuVaCBocJ4K
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150072

--------------lUW08kH4yVyhGM6BzePxoHsb
Content-Type: multipart/mixed; boundary="------------qF0VOPEkRyMT00xn1XiMvS1b";
 protected-headers="v1"; hp="clear"
Message-ID: <f83bc802-7e4f-43c9-b19d-4c397bd88483@hpe.com>
Date: Thu, 15 Oct 2026 11:22:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: eric.davis@broadcom.com, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
 <20261015000834.GQ14213@ziepe.ca>
 <733df751-5e7a-4004-84d8-627320734c30@hpe.com>
 <20261015172911.GR14213@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261015172911.GR14213@ziepe.ca>

--------------qF0VOPEkRyMT00xn1XiMvS1b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/15/26 10:29 AM, Jason Gunthorpe wrote:
> On Wed, Oct 14, 2026 at 06:02:38PM -0700, Doug Ledford wrote:
>=20
>>> You are running sashiko locally and fixing the bugs it finds?
>>
>> Yes, but with one caveat here at HPE anyway: We have very limited AI
>> resources we are allowed to use for data exfiltration reasons=20
>=20
> Ah, that will be hard for you. You need several runs through sashiko
> before you post anything so big. That needs a real AI license. Gemini
> or GPT are good choices.

One of the people on our open source team is running it right now.  We
selected the GPT 6.1 Sol model, so hopefully it will do a good enough job=
=2E

>> However, also keep in mind that this is adding a new QP type with
>> semantics much closer to Portals 4 API than verbs, and that does creat=
e
>> some friction not just with the rest of the stack, but with the AI
>> reviews judging by what I've already seen from the Sashiko reviews to
>> this series.
>=20
> Lovely. It is a great sign when AI can't even understand the code :\
>=20
> AI reads the comments, humans read the comments. Same with commit
> messages. Try describing a little more what is going on and why
> things are OK. It does actually help get better results.

Thanks for the tip, will do.

>> Probably wouldn't hurt.  But, our driver is many more lines over in th=
e
>> drivers/net/ethernet space than it is in the RDMA space.
>=20
> Well, you need to get the netdev driver merged first, with a core
> device and aux bus scheme. That means I don't have to look at that for
> about 6 months probably.. Yay.

We did the netdev driver + aux driver model.  Hopefully it won't take
that long :-/.


--=20
Doug Ledford <doug.ledford@hpe.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D

--------------qF0VOPEkRyMT00xn1XiMvS1b--

--------------lUW08kH4yVyhGM6BzePxoHsb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmrRGegFAwAAAAAACgkQuCajMw5XL91Y
UQ//RpZvaKD0EDfdVqM57B+O0X+BKthuN83Vw5IjEfDZBtAKcZZbH3HiPXFx08Cg2qfLDgx2Crjl
e0K7tY5lA18yXeFgDMcyFDVdW/d/mefPb0lX0DHBdOzp7yUOXtcjUEmHPXaC7y4c5gEXuGIDsJN+
7UMNnc/If6IIm+nq6Dutk54q9TF3ta4o3DulYoFg93MCQ2FesFAczCKSge1hqwrXRXwg5//UNTWo
dzrnRb1qDKDX7G2AOxr05y+vC2qET6rMrRx2xl+TOCNsVZrWGdYLBcQ6A2xcJMfAnnjHR4KGH92w
XuaVv7dBes3s1c0vOhhiQVxIXTJ1fXKsCZwWoJPAhWs9XRPKVn8bLgjdZYHC8Izg+nv+DKhvXCQu
15Ixnp3KmXCaSTdrhPmBoJtwEIt2Ib20hUgqMaUIBkDqDwvAGn+i4gqVeuobQMb6oc0ZMpn/gGXu
w8WsnjrF3gxTElzGQBXBfd4UwW1E1IZ0A0cNbXee3ed6C5Z2ofhi71JtYCITm3Nv8Z6iU/sdhbZv
z9c2Ff4zI5MfUTFHRiXPoEFMpZTrQumJEc6mJ+TG7d2FVjMAEFXI8cDvfVeYtGYvFmdAHB+LnjlR
evVTYdONHrLl4iqRpnt7fdfBd9PQDNCmmxBeR8GDQuOhSn32VbfiDjYTboWDwhYdjd94Ug4dcW9O
mGo=
=9qwv
-----END PGP SIGNATURE-----

--------------lUW08kH4yVyhGM6BzePxoHsb--
