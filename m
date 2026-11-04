Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793809092;
	b=WS5ym7B42jyjyiOm29oht+JR1Ky01M44P+JuM+XzreWyt2ye6Sq2RLkgZWpyygu4hlVY
	 5qKBoAmi6+2muf2E3lVxYeQ95tUQq/biOKg9KmzCm9zQh3fA15qhx4+Kn1+ImkW6NZJuA
	 1UwjGYckX+YEqSJplSwiZk60VtFFdbX7axfYJUseyfJ1nKSoEkjdA5IcJoWvCZ3UDYoGV
	 Q47ahHBS+cbFf+HRvJwoyn3E2y9W2uyC2umJT3xiKee6Wixw1GgtPtw9rJDIBdb8cbB+1
	 VOGCvOod3ilIa9wnuzTdv7oMkf+hV4jF9Lj+wmFQTSxiV1H61n/wtFouxjF7ym3HeWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809092;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:User-Agent:
	 Subject:To:CC:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-HPE-SCL:X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=u4s7R2iIr8k6deIydySEC3tNl/TRvyAh5ErNIRQTp0s=;
	b=xBfqMiDFlFodKpg8pVOnYLjs+ro0gjFOcRYnJ+86SqmIzD9LLx9N7VZvVNVIti1iSf0l
	 v9QcwOxLYBkhj6dtr/ovMQoyoPiK+GSq1AqZp02DyxItUC5vZO/MGmvgQAN+liC0ygPuB
	 M0YxAar0CIP234Kpo192NzfD2i7hwTZPIM9uB5yXxum17dXr+T27yhYNb2YMRTwrX1Aji
	 KtcqRq+enw/0+G3kF+OpsH9NKGpRboQR5V4VN7UBqs5NFwbI4vgp+MykPsBPjzPoKfPXc
	 CvL44HWq9wkAKvCa2K6+gPkMeUG6Mvb3dlxRdmUE2TrzvnKMWfz8FsKdOizKVOKtACA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=VqE+YQb6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF8606EEB0;
	Wed,  4 Nov 2026 16:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10EF8606EEB0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=VqE+YQb6
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4FhkUi864855;
	Wed, 4 Nov 2026 16:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=u4s7R2iIr8k6deIydySEC3tNl/
	TRvyAh5ErNIRQTp0s=; b=VqE+YQb69qDprNB2/2pB4Ikm3HSfntvmVT0dIoqpYP
	hXfxwVL49Mu1aujlZuItUvhID/F0CeiPq2JoKx8xZQYskX2Nj4qme0Cc6Qh1UaN2
	05oDXYi22QKA/zYk42YE3pM0RAuKMPJkBt+Q91amXX8If4IddR4SQNhkBwyQLaLj
	I6XpAblCMDaN8Dy8V9vB2kybFRSjRgSZXtr476CL/S4uCAggIWVQJYF5Kpvn4XeR
	LiRNBqLyI302MvsHxgFCMmS9C6n1F177Z6G6M7hkNh2mlbTm8r423HADEo5Ro+l9
	3e29Isw+iQPRBR3skwxKlFGJA1FVcxmG0yi8GXHwxWXQ==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hr798rw7u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 04 Nov 2026 16:18:09 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 8771C859145;
	Wed,  4 Nov 2026 16:18:08 +0000 (UTC)
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 4 Nov 2026 04:17:31 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 4 Nov 2026 04:17:31 -1200
Received: from SN1PR07CU001.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 4 Nov
 2026 16:17:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGQTR3IfOBDEyb1IxP1NBLjMJ71ZUv4lcvTK0IptMgx3dXa+M6V5AhEz++DPhu0rXw5K3dPRBiW/cii3qfDlipFvLysYkZoHVNh6W0lyDTD43Q+7Ym5o0hW4UA59PeBiFTwpbcNLmQNN7Px2NKVAQgBI7Jp/D4vjP0u8bIlR5cNt8jEGQqPwpy9uX3aq6eMNTsmfOu2ZZENdq2IrBjYd+SSKS/z5ww4zp7qUery/EEME2851ZSun91JtAu6VIw7lPv9ZKEVrhvLj2V8tnA9Gm+DoXDbqexukyxFY3+lOCyJkjxJvHPO8m9+v1puwcn0c/xpTmrruRKT1BmzcphV9fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4s7R2iIr8k6deIydySEC3tNl/TRvyAh5ErNIRQTp0s=;
 b=fGDt6OshA3VtEMneIuPyWntGKzxNUwFkcv58T52wDM/pQKLRhO+PWFkP5mP3LpSORmQzjNmRCWDuAtMVcSqJrDC3KSYtF31XoeBE9YTmzsT4kbZ1uQP1RBAlz0Gb48BYNUrm0saB/DHFf/an4JTt2CPqjHyLzqOqrPW10ljybQ4rkq4+Anp3iRy3qaGyRo8Ul8d6tpHqqSgHnGCYY6NBmVreCQ6/VsbnRpCgohNFcF22SlLjqgAWPYW7j++fWSKqy6+CbdZKResHNChzU382evHXTC4fkp2jq9cxos6ZGVlWTsmiwMA8L+Fv1nqltt7ZiXifqAUnz6NrSV8DeWFwgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by PH7PR84MB1655.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:152::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 16:17:26 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 16:17:25 +0000
Message-ID: <a14c59c0-d523-4399-96b2-72f84b883ef4@hpe.com>
Date: Wed, 4 Nov 2026 08:17:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Iraimani P
	<iraimani.pavadai@hpe.com>,
        Mamila Santosh <santosh-kumar.mamila@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261103142826.GJ264423@unreal> <20261103143004.GJ3889730@ziepe.ca>
 <20261104095424.GC478286@unreal>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261104095424.GC478286@unreal>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------85ngTJZ6nDGGF0DAemINvGcg"
X-ClientProxiedBy: SA0PR11CA0186.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::11) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|PH7PR84MB1655:EE_
X-MS-Office365-Filtering-Correlation-Id: b833a1e1-cb92-42ae-610c-08df3a8f1d2d
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|4143699003|56012099006|261021121427099003|261021135927099003|261009223027099003|261028144727099003|261102130727099003|261022105027099003|261026121527099003|261026140227099003|261102123227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: Svhfpo6t50n3aADtC4x4do+PevucatLW1cMdp2HiHeeuRlUDsPIhXj3BG2SShTqU/9CYwh4VZ59nKvqxpOkl7W9nOFZ7376vrUbtRlHeoMcFlmE4CqvKOyARuvpVEtjJDrvw1M+nuCaoHueJg2BEkYoctbwdUECBmYCQTBQTaWHMAPQVEJ7mMKFFHS+DgFtLZ8ew9fs+hbghgTYe3pBVLFfMJ4RIwnEGuDmXZk3uc/hJl74FaZe7ZQwf5WnIXfcJ4EnwxJVJ0THm7rXkT/v/vprzqG1edT0X7mOw5mANFsSfeSsQBxtQrZf2NnIeasgEOoyAoid3ohfdBIA8L9T7698xvOuIhD7wnCoWBoNP5oRGnBwkjx5kvhHXqDdso9+ja0Ao/I1Yum10nmpdKcEXTdyyvqmqtUqY4iYUY70W6KMUMGYBvnIhhh2+ND/xqXfnktfdUgXr5KFL/Q+EiZD9UaMd98yGiLLI7ga5R3xDNEixFsi0DSFgWNBX+3cW680W1egVvYQ3765fpBn3lKVTeRydQ/N7im2QIdCY55g1jOvEcldwcLBZyA5shCllBG8olxlOKAVlB0m/y0fK+gGhqPRJ4atS2Yl21FhygXq36ww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(4143699003)(56012099006)(261021121427099003)(261021135927099003)(261009223027099003)(261028144727099003)(261102130727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVFCR29FZnMxcWtqeDdtTWdsaTZBZkdTSmF4K2k2ZHNSNkVnWFI1cWRBeUZL?=
 =?utf-8?B?VGFCUklRdFF2YWJweXlhbzdXQ2ZYdFMvemo1bmNTbERvT1c4aHR5d3VoeDFY?=
 =?utf-8?B?eFhnd3NteUtwb1M0bFlLcWkzcGxrNElaNUR5QXJtcHhoSXBmZVprVmFpSjFC?=
 =?utf-8?B?MjE3NnZ3N2owbjVVM3V1cjBabTA3aXlVK0wxcUh5MDFqdmtiVk5zSTNCU1lX?=
 =?utf-8?B?UHpta2N4T3VkYVZ3OXZKVlRMYk1wWm42K3JLVHd4SGpTbE1LVm1qUEVON1hv?=
 =?utf-8?B?SEJQZmhCU0R0aGFFUFQ4U0hXREtYZ0tEZXpqbDY1RWYyNkJXZ1JTNk5jdXhB?=
 =?utf-8?B?ei9OZ0xBS01YRitkaHVLMEJzWEZzaTZjUGR1UU5DRkxtcU43RzJYenREd0Z2?=
 =?utf-8?B?OXoyS25qSTRxa0Z0Mjl1VzVjTCtuVFNiT0p1YVlTMG5kcWJ4Y3dyYnEzSDRF?=
 =?utf-8?B?Y2pNcmFoNjJZNjhZK3Q0SmorQmNBcXoxb0hEdTNrYUFSWTZVN2VJR0s3eFdC?=
 =?utf-8?B?UTdmblFRWkxsdnhRMnBZR0dNaEJ2bXlFM25tVUhuUGlWaEdYS1diVWRLd0lF?=
 =?utf-8?B?bStRZjVoeGNtM3RIUWFkeElNQVBXSUpCZWVsRzVCWG43V2ZycjJocnpESFNG?=
 =?utf-8?B?Mm9VSEVaVVRFdUxxaEZjem1kcGo4b1J0RTBTL2NMTUJPUTU3bi9xc2NRaFpV?=
 =?utf-8?B?bkZjemU0OW52VGdlS0NNUEdvUWJob3pGdVFLSW02TFZJUVRQZVh0YzdiWnBW?=
 =?utf-8?B?Q2ZYdWRRc05YWW9tWU1sYWUzSk5EZVRxWWZSTkorYUN0dW9zMWRXR1pIVWdU?=
 =?utf-8?B?WXVzL3UyaWtvNVl6OXNIeXhYcjJjS0V5dElEcUoxNFJyVlA3T1QxN1FWOXor?=
 =?utf-8?B?M0RZbFhXRDI3WjhySzlJK3JReU01YitXVkZzcDdqdTRhNmQxK0pOYlRtbmJq?=
 =?utf-8?B?d2h4d08zc1NPZnY1Szh3cjI4VXFmeTlwQlQ3ci91UHI5b3poczVRUjV1Q3ZB?=
 =?utf-8?B?NVo3U3JQd1BnUXNoUmVzS0d4ZmFlUjJCaDdvMFBIN0oxVUl4c1ZpV2NCbm1h?=
 =?utf-8?B?Y0prRk9nUHhsYWVGSGRwbTM4NHQ2ZWt2S1JROTRtaS9EU3FqMHI4dS9oSG92?=
 =?utf-8?B?dkhobTl6WHZuM1BjSVQ4WEM5a0h2NXd2b0x1VFZiL0xjeXl5STNxVmtpOE1M?=
 =?utf-8?B?ZkxhZzVVdU1hd2s2UFYvTDJwQ2dkZnEwMVBIS1pCK1JSUlFVZHZBdEx1ZHJr?=
 =?utf-8?B?OWpJdG1sclFka3p2OUN5VGpLWS9vdTRyQmpsMEc4ZTdnVjZpYmJSUThaVHZM?=
 =?utf-8?B?VXkyVm9wTTArdmpkdU9FZktEWHVoZ3JOVWtBL2lHOFQwVEpQNWpRaDRBZ0Fz?=
 =?utf-8?B?YVFOTitZbUI0Z0NXcXFMZFZSWVZoSmNZT2NWMVVBN1ppTmJkazFwSmVJb0RR?=
 =?utf-8?B?MUVqQVJTTHc5TmF2aVdKeW1acHFkR0tINDl0WXlGNmFjZXhCc3BSdzJrbi9P?=
 =?utf-8?B?eHlsWGs3UVZJZjFXSlFsT2lXbFpnSXJrQlVrSHRGZnBSK2ZGTVJyYndCVXlq?=
 =?utf-8?B?TTZiQnhWbTJhWXBSVnpnOFZyQ3VET1dWemM0WGdBeTlxRE53QnR0UWtWSFhw?=
 =?utf-8?B?WkNsOTlEWFhoeVNPbFpqd0V3b1ovYUc5MTlwcStCSlRsSVN1WEt5SUdVMFdt?=
 =?utf-8?B?RURITHdRcTlLYkpYZzZBSGNKWm9NV2RFSTAzcDlXUGZoUFBrQnpvbmlnaGJo?=
 =?utf-8?B?MGNkdzRQYVpTKzdFVlVxWEpyR2c3clpnOTQ3QTJobHhIbDJDQkI1dER4YU1M?=
 =?utf-8?B?NnlqdkVmRTRFaTZvL2dPNU93ajZVa0JJSG1GS1VlZlJ4QjFVMlZQVVQzYkwx?=
 =?utf-8?B?bEZaMnRxRytpNi8rUXkyRmpETTlKZVZOYU9jSHphUU5BUk11N2Mrb2xxYWps?=
 =?utf-8?B?TVRmYkZ6N3ppMWk2V2lYVTFCc1ZOS1ZBOXI4WURmbFZBdzc5NTIzRVpuQjVk?=
 =?utf-8?B?aDRhY3Z1d0NkbXg1YUo2RlNFUFJKWXh4NjY5MkVrcWdlSE44ZVY0MjBzUzhk?=
 =?utf-8?B?TW5vdiszUGFJU3VSL3ZnTGJQU0ovY2JyZ1pINnNNNGh4b1dTYlpzeHVmaUZK?=
 =?utf-8?B?aUJsSWpKYklsM2xKQ09zYXg0MHJXYXdTaFFOUndBZkIzZGNYZ3VGMXZqVDRG?=
 =?utf-8?B?b0tjMkdDSStuZERzSkI2ZzdrYzZMYmd1cGZTbFEwVUpYaE53U1NnTWczRzd2?=
 =?utf-8?B?QUVjdWREWE9sTm0zTURVcTdqRVB6TjA3Z2JISnI2MzA4WW1Cekp6YWl3R3Ju?=
 =?utf-8?B?cVBWU3hxbklpdTdENXFYOWRHOGxGOTRFSVN1cEg2RXoza3JXRnB2Zz09?=
X-Exchange-RoutingPolicyChecked: WNmhDw0eMbk895P0litFhEg9+ISP1WcR1nS47eTBvThlrs1Q3YKOE4xRVy4dtP5q0oM8M+ntg53Noj59yGJz/gfBSF5N63wmpA3WkFLpDdyLzbujZD0QcnouU+YY687nJf6kIYIIGFzCPLDPAk4gEVAMiX8D6zdYNaB5EK5vo9zpj1x9OAdSqeQlTo+1wxoFSLLYccd8WnJwqhMDQs2S9I9Cmb/tRq6dkei51ieKbgMqdBn+BJO0dpewu0G6wy5WaalFxo1M/PDvgDiaWBC2Byd3u66M6R+ExkEl6TVJEQxl/Csh7S4yjrLXx0gtlE+Y1U8Fu65vzyT46weIqHKQfg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b833a1e1-cb92-42ae-610c-08df3a8f1d2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 16:17:25.5108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqnQdBpQ8PXmCL14GsqTBd0BK2POfcQR6GuGRFoXuuDHuGp2g2bRhHRWVFqdj+1jI8z2BwtzYB/kMwrPcPibXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1655
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA2NCBTYWx0ZWRfX3QG2cljNa9xP
 4mdkDN5jTAQdAcUW6tN4bxeqeddTN+F7BcAeCvW7JxsoHUtQXsH9FAk+/cLJMjSRB93fAOaVZRC
 SynjSLhON+XhnVskA+5DgRrelf9DEeZrqet/cSxoVM5mBf1mvqPaqUiZ3XljB9Tfl8R0IxUiMHs
 gSN69NocfZnGg8VxseEPk8oKjZUhFlSptttHg8OMpmjtFAEujKd6fFthk0UJ3mO7G2G2Wn0HJvP
 RSbadAthch5jHjrYr3J9wi/xcBsPx55LqWZzRIXvtbvf+/Avqa1DzE1jgKl6DnzxFBjJOviK6A5
 EI9ogGzGFJ9Chf+VhMtOFUP24it2mvsLekuYh7fNCnp7nsA/7eNeY1/b3U8JZHoF6L1GqIzjdjZ
 ECnmeHftGHK1duR2YW3rdgtFU1eFgvow/CY+X9cCTDIAn8mD4yv9topJeF77sd4GPNJfOhQudeV
 cJHP5jNszc4TMSjF4vA==
X-Proofpoint-GUID: UPxDIQsPx0RdkrJ2smgg32lwkzR5oFKA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA2NCBTYWx0ZWRfXx6LYGsu/OVV5
 ChexEdfJAi94qGb/AIgR9el4TSVfCkMNiIlq2tk1di9DmtDXImNqzb3tYg3ZusEW5IpTB5oWx3G
 +Ln8m7EpekP19Yyz/w7GZA9PUZ9sC2M=
X-Proofpoint-ORIG-GUID: UPxDIQsPx0RdkrJ2smgg32lwkzR5oFKA
X-Authority-Analysis: v=2.4 cv=VoC2kO2n c=1 sm=1 tr=0 ts=6aeb5ac1 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=ZSrvDirOKP4VPF05hnFf:22
 a=c92rfblmAAAA:8 a=MvuuwTCpAAAA:8 a=1bGtPqcbkTH8bB8VZU0A:9 a=QEXdDO2ut3YA:10
 a=USH9CIn2an7dnLufpBUA:9 a=FfaGCDsud1wA:10 a=GvGzcOZaWPEFPQC_NcjD:22
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040064

--------------85ngTJZ6nDGGF0DAemINvGcg
Content-Type: multipart/mixed; boundary="------------K642xjH2taC5hBn5cbWYdFC2";
 protected-headers="v1"; hp="clear"
Message-ID: <a14c59c0-d523-4399-96b2-72f84b883ef4@hpe.com>
Date: Wed, 4 Nov 2026 08:17:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Iraimani P <iraimani.pavadai@hpe.com>,
 Mamila Santosh <santosh-kumar.mamila@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261103142826.GJ264423@unreal> <20261103143004.GJ3889730@ziepe.ca>
 <20261104095424.GC478286@unreal>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261104095424.GC478286@unreal>

--------------K642xjH2taC5hBn5cbWYdFC2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/4/26 1:54 AM, Leon Romanovsky wrote:
> On Tue, Nov 03, 2026 at 10:30:04AM -0400, Jason Gunthorpe wrote:
>> On Tue, Nov 03, 2026 at 04:28:26PM +0200, Leon Romanovsky wrote:
>>> On Fri, Oct 30, 2026 at 09:35:28PM -0700, Doug Ledford wrote:
>>>> This series adds cxiverbs, an RDMA driver for the HPE Slingshot Cass=
ini
>>>> NIC. It exposes the NIC through the verbs API using the UET reliable=

>>>> unconnected (RU) queue pair type from the UET RDMA core series.
>>>>
>>>> cxiverbs does not drive the hardware itself. It is an auxiliary bus
>>>> client of the cxi-ss1 Cassini core driver and does everything throug=
h
>>>> that driver's exported CXI interface.
>>>
>>> <...>
>>>
>>>> Before posting, the series was reviewed with the Sashiko AI code
>>>> review tool and checkpatch. All valid findings are fixed, except the=

>>>> open items listed above.
>>>
>>> <...>
>>>
>>>> ---
>>>> base-commit: 306a2f8432f516069b2e673de7a07043132c034f
>>>
>>> Sashiko failed to apply this series as this base-commit doesn't exist=
=2E
>>> =E2=9E=9C  kernel git:(wip/leon-for-rc) git show 306a2f8432f516069b2e=
673de7a07043132c034f
>>> fatal: bad object 306a2f8432f516069b2e673de7a07043132c034f
>>>
>>> https://sashiko.dev/#/patchset/20261030-cxi-for-next-v1-0-bc6e49e0703=
7@hpe.com
>>>
>>> Please make sure that upstream sashiko runs on it too.
>>
>> I don't think he can, it relies on the core code series. I Don't know
>> how to instruct sashiko how to find another series to stich it
>> together
>=20
> This may be a radical, unheard-of suggestion, but how about merging ano=
ther
> series before sending follow-ups?

Well, we're caught in the "no dead code" rule trap.  Can't merge the UET
code because it has no consumer, and can't merge ours without it as a
consumer, so I have to make my branch based on their branch, and their
merge base went away.  They'll have to rebase and then I'll have to
rebase on theirs again.  But I expected a v3 for their code anyway, so
just whenever Eric gets around to fixing the Sashiko findings and
posting v3, I can rebase on that, and then the sashiko prompts can be
run.  But, FWIW, since the rdma portion of our submission was all brand
new code, it passed checkpatch and sashiko on our end.  It's the
existing code in the netdev tree that's where all the fun will be :-/.

--=20
Doug Ledford <doug.ledford@hpe.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D

--------------K642xjH2taC5hBn5cbWYdFC2--

--------------85ngTJZ6nDGGF0DAemINvGcg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmrrWpIFAwAAAAAACgkQuCajMw5XL93O
8Q//Yf7qiD0+0hA0Ie4KpjySzmh+/DnLmSkm7vzKxLbuJPNGua81D1eyrK2LfgTRTH1vNC8c6GWx
wZaSN5zTmcAmwGbDgyVfctrOBEfGxgVB42iPjZrtvaXWDbqEPjAxM44rOType5v9o0BaYyxwa18r
nfsW/6+GkJFnAOUVozvI7LoeelrPIoluBsR9qHEP3evR/OOl5r/1V7HER25wP6tg9o7+jG6LuRL6
9vbq72b6gX3H7se0Fag1pCR5tVOjp4vbEqwk4vrGPKWEuWXRj6+z/+8U+OZPsynh1ExjBbfUMscT
rmPoVhP2+iuzhB43shYJUK/fMxiueXaM7ZVc1a8XJE6SgDeTm7dPjQtFDy+ybT5r08ED91zl4Oi4
5kuuZyxUfH8Dj/CM6DiS4udiDVhUaeG280qlljZbe5MKFZinZUpyMljU+5tZGJzMbUUVBwBVhc0E
eNEf73attOeTqmC9wZIIXXXuTwDc2d8KGv5o2pajZj9kMHaH6urgIVG0bp0fZ9vJ1NWDvyX53ytn
gGCMD10kHrUzHfYZhY0tyHdXhb0YcLspoZ893dnuKXKUFftvujiK8CYeLJzEE5MLQ4+s5INhJS36
eZxdXOmuAgjtVRrS8d668fJDucaoFET6JMOZLajm8vg4hILXxsl4yKQnPbq9bgZu32x0kH51QKeF
wng=
=UG/j
-----END PGP SIGNATURE-----

--------------85ngTJZ6nDGGF0DAemINvGcg--
