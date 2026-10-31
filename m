Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421365;
	b=Q2c1vfbnoKUnAjnqMUV07ro3Ipv+ttVzh9sQmNzCI7Nsl7+xScTO9JK5tQi968cYEKjJ
	 SDKjsCzx3EZbBwMy/2AwuP8HV9omNj2yw04ceGnIMljE5naib1dCeoNsHhsRcQ7xyp7WC
	 WuWIB7pOy3w5WGObLsJt4Q8TY/WzUhO6wWDXHeeSqBKeoDwxIL/pcysqvluxCthaIlgGb
	 YR6s4Erdi+F7OXXN++J1wWEabmofmOoaGMXjP50K7VTaGbnRbZluybMmOVoVDIZ7VbUMO
	 dBdh5ixdVYZfK0KJS358ZkLA2TcQqTYpFW0bPhGMmJSh7d4zI3fRj3KFsybGqyz3ocA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421365;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:CC:X-Mailer:X-ClientProxiedBy:MIME-Version:
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qqSfC37XfR5zPJPIfl6IYLmPcEObkEI4xbqHP9Q6VJM=;
	b=bG60oYUiI3VTdBk75VYBIM9Y07EfwBCLAXEWjpj/Q628NvHeHxJRVxuL81Y/yTwBoEmd
	 OgvF4zV5JOiogl5kNkTttNdopQlZJYL2DwvYZcGD5hX9ErP+pZCAUrlM7sw/cqz+ynWwk
	 vfg798frWNpwGM8tbH1wnPiVFiy3wkSgTfIYTo1I51RoKVM+PeLOZxv6JXIS+QrtvocgQ
	 4DwzABKDe8ayU1aKTHxf8Aa+Op+Fwtj97M/w7xJE1dA2AEPPNkzhsZlqysrKUPloc49dR
	 +a9NMA4iZV+tgjqv9tsuIh4RVVLxCQloizldoYTMQmD6xmiSD/MmndIvxO335P4Jcfg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=mJapQsNI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCC606A31D;
	Sat, 31 Oct 2026 04:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55CCC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=mJapQsNI
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V1GcBv2581286;
	Sat, 31 Oct 2026 04:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=qq
	SfC37XfR5zPJPIfl6IYLmPcEObkEI4xbqHP9Q6VJM=; b=mJapQsNIQ5bcgHtTNR
	GbRrZHJtWDjM+ZUqPmrnUv97C6QxHhAU544VDSuaAEI8+GRkgcvDK1BIXH9KBmqE
	l+B1jZOQrM97cPh93coR9QjsjJZ/wO8MwQXInxU1ilq7hgrjq6NdAH9y77NVfcg3
	YKyOeMcoZPpzzgQ75z0/Uct4BXpbXULmd+6DWriTwLlIOtwvU756IoRdnlo6ZVC+
	28ZwHwba0S6xSmBOL3R6GW1LwYyM7qj6wBda5iHQgWJ27wRiyq/ngkJecgvcnqWU
	D7ZiFFwLXLOtOCkM3oZO/o3cSRB15vBvhuuBVuFD7QYS7dR3hod2UCm6gRyx+S5y
	5AvA==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn6h89e8w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:01 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 7D6808047A6;
	Sat, 31 Oct 2026 04:36:01 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:01 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:00 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:00 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 04:36:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FusYh+1j2riKoPlYRHJS/NWMPU050jSRZPkrO5C5ZcZKT04pHnWkmsR4RJUdRP/nxVWZYaEvuQa75KJVN8CIVHBJtBFAhhl2V1uYZ0SmwqmCuHWNp/k85Z9TrhfuPAshkUXoe4EpFAWkrYe7vnbrPAKu0zccw+N2fCexRNrNtMZmnZRKWBWaitYoKf3uBUW1egCZdBznZMmkFe3zOoPHLk8Vj0Ki5kb5KpHc1PLXzPOkUcBYjq8tCf4luL72ogDI1yuWyjVWDljZn8VWJeyrWinjQTeWyI0prOoHWhW0rBRg3ZK+dRcWk5bRUEunozgRNes86CauII8ujSnf5Q6fdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqSfC37XfR5zPJPIfl6IYLmPcEObkEI4xbqHP9Q6VJM=;
 b=Jev0gphd/Gq6mAC0q1zmdz6H7Gw11KNj8/QsG0kbecH6zvSTxbbUCF1CS8mUXjTuxmW/C5UwskZyKhJ+lTXVIge9WUCFb5B1ai8yPcDqk+IuI2R49Fo7/3RRIj3fbPmgpjXuSindkkEwOGa8ENsScyy5fzhOu1vztpi1cm8ZGU15+pfzZTR/LglyWDg2cPd2pTSprKjPV5PaqMitzRHNEpkE4x9zz0yu8nw10QEeCs8BCSjjJ67BGb3VtzmFw+o4WqxrkweGQO+FpdgfpklTF3aLO2ccd3uNxAK30/HPY2sJ53Bs15c0tpMBzJc6ipWMWXTF3tkPDp8xbcZt18DQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:35:57 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:35:57 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:30 -0700
Subject: [PATCH 02/11] RDMA/core: allow jobs without an address table
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cxi-for-next-v1-2-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: DS7P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::27)
 To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB2091:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c838373-c450-41eb-348d-08df3708753f
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|3023799007|56012099006|261021121427099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: EDnc27pIalUpuo295KupZB03vFWVIrT378va6JYPWrI8RP8veCsE4Yr4sQyf3Dj/s3R6z5Ly8dDmzxdxcxo5B8ENeis+ARKx8GGhopvEcN2OImWt8ubh5w67ZQ7Cn6ZVPj1OIUEou8/1pTWrP1+zZ7Z7+hcP9AwOh2vdwwTMXS9cpHiPf3LFW8GyJ/8ebWxnsfgQN8yO0u5wzp9hl8Nnk33mWrur0J6hI31yWne+xi7bwr8ylnlxaFknHJar9GboKaqksRtijDIz4snbTPO6W97pMw7WWtuSebYXXIuJ9phvDkaxybWwYUt1Ps6qxnUxhaZKtvj11knv/6627piFphD7KaHu+rY24Pv/vijsFHJ5m65+CB1ia1orrk/hEGenZECVXuKPmMzqklTf+c0cvOedRay8vXEFITfMqKEHjLi8gEmnmtMqQ8vgHthR7HI7o+wy8TXeAao/qUkd93/LrqM0aT/qtvbkFsEPry0G2cnPpdnsHnxjR2Ie3jWmqz+8DEBqSip2yFLgBHd52mfOM0ukLDP/pjdrzBEmPIVgwi4Nq3DpGAwCXJx9C9rN+kyrQdol3K2V57R4eLXBm0/Z7q//wTmc9dx9JX6qYota6vvlTTlKgbL5XlDYAqCw2HObj+FqTHVoHnHhIKrBX1n8h7OaWgeuNaFCZx6KDP0gbSU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(56012099006)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk9wTnFydHFLMDZkNDJ2NHlWWXFpVytYei94OVI0TG1mdEpaZ3U5a2RmOWdp?=
 =?utf-8?B?VzdzRi9ONHJtRkpSK0duY1VZNEJIc0NEZ2NIM2xVSDljMjBlRk5VdE1TS0RP?=
 =?utf-8?B?VnNXUDM5WWthZHFFVDZkd1p0MmhaKzdUanhYWnpsNGNPUExZSWhXVm5MSTVO?=
 =?utf-8?B?MzMyQTI2ZlVJSG8vdWtnOE43TU84bnZ5V0syUzRXR1BsSXFuNkdBVkh1ZEkw?=
 =?utf-8?B?cGVLcW5nc1NmN1FpazNrUWQzc2lQR3EraTNCWjM2V1RGMWdHRlNEdTV2S0VU?=
 =?utf-8?B?eUN2NHQyQUY3Rm1yNjZiUHRFaWJhenRnWEF0K09zY045STVzemUzM2svWC9K?=
 =?utf-8?B?NWFBeVBrZGRpKzQvaEhpMCtzbnAvak9vUVdYbXhGTW9PV0JablhUdnFpYmtJ?=
 =?utf-8?B?T3lNZ0tYQjBiMHp5N1pRUGtwa1NweVdjZHhaZXBLUFJ4TFFHRXVYQlBWQjBV?=
 =?utf-8?B?dWY4U0JRR2R5a0ZmTGIwRmlsWXNDclV2dS9yaFA2eThRKzRWcitYQ2NDdXJ6?=
 =?utf-8?B?Nmc1WjJ3RW41YmlJcVFUcm93RWM2Z1BsSjNhNCtXcHRLNTlzblk4S0ZsZ0lx?=
 =?utf-8?B?Y1NxWDRNc29lS3NoL29reDR4ZE1aUjQxM09rN3B6WVBHaEVqMmNVOHBvWVBm?=
 =?utf-8?B?bVd0TjRhbkppVHBSQjJ0VHg3RDNiZ1FEQmNTcElwL3VjUmhlaDF3UHBjb2R0?=
 =?utf-8?B?MTRpTmxEZGV0djVxRnNIN0ZZSXhOcXJkVnBiemFkVW8rcmFtVlZBYTQ3d1BN?=
 =?utf-8?B?Y1JELzlQWm1HTEgxQkt6NmdkS3FObzBPT2NYeUZER3VwcFJORDlrS20wNFVh?=
 =?utf-8?B?M3lGdThjd1hycUJQN2dFTjNSYnNnaTF4SzZKeWE3R1lWL2llVmFmSU9kYjhS?=
 =?utf-8?B?bC9WcWRiNHE1TEpqNTAySU5tajBoaHJqell4VkpKMWJPa0FLZTYxTVFwcmJH?=
 =?utf-8?B?WG1zQkpBa3Q4VEY1eE1Rek85dWVBMm1qajlRYml1VktUNWo0endxWXlmQno0?=
 =?utf-8?B?MlJ4TU1VMjlyWS85SHJLbGFVeGVrWVU5NHZOSDM2T2djblRxQTVZVTBuRVdQ?=
 =?utf-8?B?dG5yb1ZXUi9xQytYRTFtbnIrcEh6Y05kZE1Kd243K3lHUTRBVFdWeG1wVmc5?=
 =?utf-8?B?TWNGNmpJSnpUUlFEczRSWUtqZ25xZXZKTXhZZWY4TXRXZXVVQkNmNXZyV1Yz?=
 =?utf-8?B?UkJ5MmNicnBCRGRGbGZieDI1QWUrcC9XR0pxeWVVMkJOVnBielgzWVdmemhX?=
 =?utf-8?B?OEFFNzcxVEZkdlgwbld3dk5JVWMyWTZpakdLUXg4WlRuY0FMMTBTTitBanJ1?=
 =?utf-8?B?ZE9lTDlWRmhiVWQ4Tys2S1dINDNpRFFML1JURWx6V1F2TGMvY0FVbm5aYkgw?=
 =?utf-8?B?eFh0OFhzNzR2NWNNeHA2TUV2L2RYY2g3RXYxUUthc1BxSGhtNW1nMjZSNjBL?=
 =?utf-8?B?cWZWUS9PNTJxblJvakphOHIxUndreEcxSUUrZnN5d0dzUDF3MElMbHZqKzdh?=
 =?utf-8?B?OUlsRHk3ZjRCSHoxa1Rub2kxZmFPYyt6OUVJeEkxWlpzeFpEWVlTOXYzeHo2?=
 =?utf-8?B?UVIwYlNSbVN5cnk1WkRQZittUHVTdVloUG9OdEYwOHJqSlF0QTdLTi9BS0tQ?=
 =?utf-8?B?VjVnK1p3cGVNcFFCVGc0WHl5L1gvTXpIWDBsczVXZElxOE9UZCtkTEZ2djNS?=
 =?utf-8?B?OXVvSDB0UGVuQkUvdkljaUFDV1pUZ1h5bml2aHhjNGpQOHFzTzR5NVlZVDBD?=
 =?utf-8?B?S1VCYkg4NU1CajRFMVFZdDZDQWVqbFBZTUJkUCtaRVVHZktNWU8vc3pHR3Nq?=
 =?utf-8?B?QlBzM0hLNUt4TDdkd2kzWndSRFFOUjFFOXN0YS9qdVJuTlFBd2FqTVNtNEpL?=
 =?utf-8?B?Y2tRVFdUSFFIWjV4ZkNvNXRDcDBvYTNkUWdtQVBiVGtueHd2NlJtMkd6K09s?=
 =?utf-8?B?T1FVQVVvYUlXUHVDeG9sRkdFMEU1RWYwaTAvRkZGU2J6amtmUEF0djNzTnRR?=
 =?utf-8?B?dGpFRTgyVjBDLzQzM0tFWEdUQ2Q2WnNVZmRTeGkrTUwrcFBNL1JNOCtWNXhL?=
 =?utf-8?B?QjhqcXROL2QrVncxSWV4TWszZjdKMEhqeThEdXJYcHU2TlMrMElZYTJmNFUy?=
 =?utf-8?B?M3dqREduazFZRDEyUnFMYld4TmJNMldTSUVod0EzRUJCWU5kOVJOellMejdy?=
 =?utf-8?B?aHArNVgvQnR0TXByaHByYVJVUGFMZ3lTNTA3K0Y1djAxN21ObzgvRTNmV3BC?=
 =?utf-8?B?Y0RWaXRYc0ZqSS9zY1dPbG1RMndIY1I0UmpSTDIzUVl1dU1sZ05ZV2dIY3RK?=
 =?utf-8?B?YXpiVno5S1FIWkxOdHRxcmVWSEJVOFVaUUNQQU5vQ3F6Y24zdndJUT09?=
X-Exchange-RoutingPolicyChecked: c+lkkj1dTBR6ZJIFzZvBNw4Q+Nn7uJRNo2rkWS4tVvcZc92SUdsKmhlPMrijuXJ8M2xwZZ/HKgsRaYKdNu7Mj46RyCHqC8ZCK6j/jLklBrD1WKHccSmyYbXIdnVBWhr1lcB0UsSh6cY1P4Vf6hjqA6pW7UkwXBC1hZyNLk6opJUoUwqlNd6VdalALB2SeX27EcfvRhcfkyL9YcBCf/2tcH/UVm7ZQKia6/9AVuob0UN3jvHUXTzoRxXJfgvCnDLmXMoAx2/J5wgY7Clh+64uM40otk9JHyXmaqYRvqlRC+aPZ6z5GulTCwefJTw7NADfOpxpx++fh5hAxw1dpIIdKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c838373-c450-41eb-348d-08df3708753f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:35:57.7879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qN9cztq/3x9uUT1c6sF1sUSVUD77G725MC9m4fJZFp92mhcgRfy1kttaNVRIyBvnwyMs9ETfmix6dy5JvsqvaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=bYL+w+PB c=1 sm=1 tr=0 ts=6ae57031 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=ay80y3fxfMS_JZZz1qJy:22 a=MvuuwTCpAAAA:8 a=WeRqcxK4sW8ZVjGh040A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: VA_B2C2oN6TaZ_YqCAdPHqDEypNXGnim
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX3uqCVlinOoSo
 lutdcomOoydkqDBjS+h1p06Pmud7fC4BB/K1uuk8HT6NrA84NoTy7TfUy4UkIDH9G05eOABkbgg
 z84Q9GS35CU19VVy7vFQl9YFPdt+Mvw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfXxZwA4tgp5kLw
 atGXnKJAqPdPRLoJiGo6N8JsS71g3ZxP0jYH+jHcpNIAe1zmEYtR71NN5ElovQmUJ+jGOM6SMAp
 6xeVuVg8ajylKa7xZD/Q2ZWnWRielTKMOpvR4vh7lKrU0gMEbLe9dM4qv9pRb1QxBxo9kPwEBPB
 AJtWi/VkEI1oKQrVFUY59eGbAlaVvalXSU6OULHOJ78ieptrliO5C5DdBftuLVMdFEHJenlkCwZ
 tdomKlsh0OP8nTniDX7huh/T2qtMrZpI17mvwhl6w7+8/s+PLnsGNyiMqLvwl6tvdVejGZs1u+h
 iaQAqSXjr0MqA5HoWkdOVXb787a4WSFN1Q8WhWb3ZFnUr1DyGY/Dm9bkdXMtGrd9/NIHhe2Dmr6
 744qqPr1u9zhT7vbRWTecp+TBwlh32fu4JXAlTaTxCG+KAK4zJPS84LfICAGT85G59CH8tuNE1Q
 oIivdFvIIy0LfpSb0EA==
X-Proofpoint-ORIG-GUID: VA_B2C2oN6TaZ_YqCAdPHqDEypNXGnim
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

max_addr_entries counts slots for remote fabric peers in a job's address
table. An entry describes a destination using address-handle attributes
and a remote QPN; it is not a memory region, mapped page, or ATU address
context.

Cassini transmit commands carry the destination fabric address directly,
including the destination NID and endpoint information. The CXI provider
currently uses address handles and does not implement job address-table
operations or indexed sends. The documented transmit interface does not
expose a programmable peer-address table equivalent to the UET job
table. Cassini's connection/retry state tables are not such an address
vector. Its virtual-memory mappings instead use separate ATU address
contexts and page tables.

Allow an address-handle-only job to request zero peer-table entries
instead of requiring an unused entry. Keep the device upper-bound and
privileged job-allocation checks. JobIDs and job keys remain in use.
Existing index bounds reject every access to a zero-sized job
table. This does not implement indexed addressing for CXI or relax its
memory-mapping resource limits.

This relaxes the shared UET job-allocation contract for providers using
only address handles, not just the CXI driver. It needs core API review.

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/core/uverbs_std_types_job.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_job.c b/drivers/infiniband/core/uverbs_std_types_job.c
index 20acb2aa9871..b05c0619a6b3 100644
--- a/drivers/infiniband/core/uverbs_std_types_job.c
+++ b/drivers/infiniband/core/uverbs_std_types_job.c
@@ -193,8 +193,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_JOB_ALLOC)(
 		return ret;
 
 	/* the table is sized once, every index is checked against it */
-	if (!attr.max_addr_entries ||
-	    attr.max_addr_entries > ib_dev->attrs.max_addr_entries)
+	if (attr.max_addr_entries > ib_dev->attrs.max_addr_entries)
 		return -EINVAL;
 
 	/* the port carries the job's traffic, so it has to be one we have */

-- 
2.56.0

