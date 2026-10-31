Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421364;
	b=zbHruSm++ZzWsvVEDLZaJWBLjm9QsLj+nTgg9A1zrUw7PmndiJIpWVa/FoNDYAwfYhjb
	 FMbzJJaIZZXewDGJ/zXWwbLlFhe41ZIW0KB5b95QBHWXBB4pzlvPpeykIccMEaAsujr2d
	 5Np9Uhcl9fZnDfu8zAALChUjTWyXGmP8OGue2nBv3uGKRzOCAvjqMkXRCRbZr60w1Zt8t
	 BAajrDM0hp4xebZzJ+LGUrK7lmG3ddk0KLkBTCptWEqviMjKtC+FKDI9ywLICsu4NLlFU
	 b4hE4ggiy/tMysI/sRKEiwY1mZwPwr/jTsPdHC70nBnef4iRayWHKh4pRFGNrr54B2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421364;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:CC:
	 X-Mailer:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=wmfRUpS5+2yD9fV6zAdZnrI0bdiN6886XAlzBnOrmqE=;
	b=L03Je288eQetYDaIhQSfUHvaVAvR87ZGuX+w7v9ihKcRUQGEcCxb7pXXoXz03bCIIEYv
	 bKDCaZkxcyLKdq8W+ruGvP6FR78DrQpDYuRcm/O+FvcuD0ikSum3bVfsmoW+K5UU53W2S
	 Ky8W3wXQJNN97FzuRFFWlIpvRQ+K/XwP5IuFfpg63OcpagLZeHPZ7dct/+UP93gR8utG+
	 iJiPQphdKR/bgUnsQMNAg3UthF5ap7r9BVSdaq5FlCBOHagX9H/fD4MZAxfGroVZIgBuy
	 qOlh0OLE15Hr5MAEZX+8HtMjAWCwnseUvKDdp59lgisjB+Cr+2AFicGq6uLP7gr0zpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=JbCQlgyn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF11606A31A;
	Sat, 31 Oct 2026 04:36:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CF11606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=JbCQlgyn
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V44LAw2205486;
	Sat, 31 Oct 2026 04:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=wm
	fRUpS5+2yD9fV6zAdZnrI0bdiN6886XAlzBnOrmqE=; b=JbCQlgyndP1LfjmtZP
	5pcl+2XGoHC29MO4TuJLb89gPmnZBjnCK17PaUn1OJpmYSNNsja3rRYQOtpD7c1y
	mLLanMoIQQNZ56mEKdptKbXPNNMnitXeCZ20cXa2qSU4jCpNLEyhhUpZdvc389fG
	2RaspMA3ngkKKfKkd1AUWjvv4C8p+S6ZAKMoGuwaWH437Tgz70YduE8tQzCsXNq5
	x6lYcbMvbJsxbCfOj5/Q0kqXZKiIY+V+Eg7LPgsbysqDBWAHgfHLIbVslcNZFReD
	gr5P6zmwDdAHXSTWV3nxR2agYIjzTtf7uKZY2hDw/qmv1tuxRa2KGVuOOQaPOEDq
	357g==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn900875x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:35:59 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 98CFC800EC4;
	Sat, 31 Oct 2026 04:35:58 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:35:58 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:35:58 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 04:35:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+mpH8r3HoRO4P0AIvpsjP/zXMffXSyFOBMLT0ImS2bDbKnowVgny7nWL7BFOciNC4VpRw2rjaEf/bWkLUGKFuwD/U4gE4ef8d87itbktnWUd8R7r4F2zsjkoU+G7IwzIi+dlRISmbo65xkqfps7cO1FNQcrXRyBytBqQGJOD5RfMha/AwAqFXXCkGXxbVJlIJ3YFFazKOMYTl7bc+OMPlAIatLmiw9Yi8fOkeknvrEvEhQQ5K5MLsTVjF6DWIm2H9nrfwlbTTfI/TgLbDrnmnjPdUOpyODvIdT3C4WdZyf144nSP0ZpSaHh5Yd3GzJQv5Vd+wyDy8NTY6uAnUVyMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmfRUpS5+2yD9fV6zAdZnrI0bdiN6886XAlzBnOrmqE=;
 b=Aaff4buYPFkO/IUpsSTBlxnDB5LWG/PxdLCBy2Bk0BcjxdYoL3hE0tV+ZOZN5e6ZFzO3/AAvEuQMMFKGR/gjwy3kSjcJVXPsVXY6QqkBdpUkpc2WELeV5aK2LKHAb3lMybkRELjhqgstZkBCd03Lf/cPDREDM0rnldTOz/BtBvxJR01DhIOlE33V4Glvv+F2ltiq/oIkhrsBoodwqaKk/mEFkRfENxzcRTV0G5a4fR55s1HQp4tbtlJOFV+ybYxE8QsW4GAASsv8w8eovOKXIoUVPe6oECaqWbLTvFfTWHAsMW2FS8z5F0h3x1u0lRMcj9ZJNZyBS1ws17vO2LWLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:35:55 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:35:55 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:29 -0700
Subject: [PATCH 01/11] RDMA/core: read selected counters with timestamps
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cxi-for-next-v1-1-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: DS1P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:8:453::19) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB2091:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e4be16-3330-4c3f-2130-08df370873c5
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|18002099003|22082099003|56012099006|261021121427099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261009223027099003|261009221227099003;
X-Microsoft-Antispam-Message-Info: WtxvgxyauRTiRS4O31ckrDnBMeKOZoeQ4udXcW1qWgNkPIkyahFUSBd6N53n7or7f3moknfGwUcqDCgGsWf+MKoFuKlJ3++cB3D8N/D3LxMg9Uk1kNyuRnKeyEsFylse5QAy9WqfiyiH4P2M6fwvbYzBasYi0HeKg+zFwZTjOokCj1ceXjTwuqVgiOmhgNGbxZRN1Qdcbj2PEL/+BIXpRM94Ok00UuAAr/RBHaafhcFYxt2j2jnqSCokz9afzk2Cdxr6dGaK2hPOBZ1SpowL4DUCnirKtPWCCUQgmYrru1iCi2tu37Zs5PgCWb3fRoR0pCuCGtwvPqcnLQc66phFkgja90KaPDyFkeoHV9mlWQ/OKDQ1M0bdClpsOf359EuDir0baejjzuoW3JtbZRMSw5qCAsTbys2V7gY4eP7SrQdgLZ0sLVFVmHOTeOgfvR4P9uoOlmU4+9ZqcuekusNSDhI57m9b71ktMdEnp1mzoWtTfJ2aYAlcVeTNY4cXtQXa/7dXqHasz/YwKw5iHDGo0NQhPyewfWM655+EICoCDfhLxG50QKVumP2zjrDnU5LPrcNrlchFlNlpLeUSIX+om0K9oHaycRVd1r/dSc3r7RSGxJf6FLJetgMbdm21YBFfJXoKxbV9F9xRi+GKUvXYsdvW365vLHx/jp+ajUCKzuU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(18002099003)(22082099003)(56012099006)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnV2aXpDeUxEVVBTVGhsZEhPL3JLblZMMkJ5b0xodHhsSS9pRFVvT2FsYm5Q?=
 =?utf-8?B?OW9QUWJwa0ZUSTIrbnNPUDVZUmc5N0g5b0ZVRmZOWUZWN1kyUnNQbVMxU3A1?=
 =?utf-8?B?MzdLV3ZSbSt4OTBiYXZTUmRLbzdwdmkxdFpQTHNXMWNHK0orRTIyZllPTmp6?=
 =?utf-8?B?ZW5YeGdwZmxIS21xTXBzZG94dVg4U29ZNkEvb0xKMHRJR3BPZ08wTU01T25Y?=
 =?utf-8?B?Z01JdFR0VTJBcnYxOEFpOXZXVDMwQ1RpNmVFZXoxY0RJZzFlendBTlQ5Lzdi?=
 =?utf-8?B?czYyQ3oyZElpSVZQV1RSejQraGYyZis5NHJmRFNoU2RScno5ejBCZ3h0R1Ja?=
 =?utf-8?B?R0hMcVAxY1FQUnc5cGVjcVlPeGVvdlhnUkdPakpWd3lydFlvNzh1c3EwU21r?=
 =?utf-8?B?Z0VHWUM0NXd1NVdHcjcreXJlZUhBeVZ2OGlLSGxWMHZqcjlBbHhNWFlKQmdB?=
 =?utf-8?B?eG41blQ4UHkzZXZoV0tEU3ArL3RUSGMyY2ZjYjkvK2NEUjJpUTN6bDFSc1Nm?=
 =?utf-8?B?aTNjbFgyVE5KL0FNcGNRMWFIZWV4SkZreEI1RW5vbU5MeERjVEZOaVArWXhV?=
 =?utf-8?B?WEx0bVJYNUN5YXg0NXpaQlprK1IyVnhzVlllQnltOGQ4QnhvNkpyeUVac01X?=
 =?utf-8?B?OHB0MXNUZW5kbmg5ZUFCSHhmVjhoUDc0K3dXVzFSUFRuTXFOVkhtVHJjT01I?=
 =?utf-8?B?b00xeHp4U1FGTGpXclB6TGxXNG5ucHJGSUc5d1BITTFUQ3FrdTNVN0YzSDkw?=
 =?utf-8?B?Z0NVR3VoSnUxbi9zMXU1RTZpTURZZGNpZzN4enQwRVBhcXlPSXl4Vi9xSnVM?=
 =?utf-8?B?NlJMdXFwQnZHYUIxZ1JoZVVLUlJmeXV3NWVEOWdzc0tFK1pWQzh0UzVxWW5z?=
 =?utf-8?B?T0pMb2EvTy9jaC9Rd0R1bFNrSk05d0ZaU3hDbEladVNtYm1xTVljQVBpOFZv?=
 =?utf-8?B?Y0RaVXA2b21NanUyMVJoVjhLMUtidCtlQXc0QUgvaVdpOEs1UmM0ZytSWmEy?=
 =?utf-8?B?dkVtQnNlVVM4c3lLN1FrZWMzQ2IwSERaemx3aHVsK3BwWTBNaitBcDh5SU1h?=
 =?utf-8?B?QkxJNC9vcHVLZ05Sdk1hZituR1RaWkNrVkJNSEw4czJ6dXlLWnd2RFBKUzE4?=
 =?utf-8?B?ekVleTNWUndUREVYRzB1a1BFbjcrLy80b25wUG5KWDl0Nlp1V1dwaUd3TDV6?=
 =?utf-8?B?THlqWXJMQW5UQnl1cTB0djlMM1kvRUQvL3VMRWZWaW51b0ZiNkNpTzdLTW1I?=
 =?utf-8?B?U1lldE9PUy8zWHNkdyt2WFh0Q0RVY0RHdHMrMktBdC9KQ0g2TEEyNUJBMU9n?=
 =?utf-8?B?RkVSeGJlUE4xRC9PbTBzRGNqQnhvU09nYnNGaE1ldHNwWFUzZkhQOGgzK2RY?=
 =?utf-8?B?eFQzODlXWHROeFJGNDYwY3FaM1B6TVE4OXg1V01xbi9lcE1xbTNURHd4d0l4?=
 =?utf-8?B?NEFubGsxMEovZGxzajg2bTFOc2Y2V293MmQ5ZGFxUVcva2VHcFg4YVZnTDUz?=
 =?utf-8?B?aFVWNThFcEM3bEkxMkpiTWZ5N2lqeFN5a2FyZFVDT2VyS2lKY3I4SzVhZENP?=
 =?utf-8?B?YS9nLzg2OFlZem1NbVJHckZsNzlZeGlLRmpqODk2OVJnNHFNOHh4TGd4NFlp?=
 =?utf-8?B?Rk00Z1psbHluNFMrWEdNdU1iTTNZeXVvdFVwSmE5MFVPUEhzWk1FbFhIb1VG?=
 =?utf-8?B?SDB4aDg1d1ZPcDBhSWIzbi9lUkRmdlQrK281QVkrZXVMM1ZkcHowT3B1RUxE?=
 =?utf-8?B?aWxpT0FRWFZiTzRPME9Vd01Yc0V0dFhSMGFWdG9lYzErc2dMNmZBNTArTERM?=
 =?utf-8?B?YURVRytjNERSeGc3ZXlQQjc4UHo4RHhrZEpBY1R3QlB6VUZoWTJMWW81VEtK?=
 =?utf-8?B?MEVrQkp3RFhhWFFDejk3NEh1RStKK2pTZlhiV0s4akhQMG4rZSt3T285QXdH?=
 =?utf-8?B?L2tWNWZZd1RtakVqekxBR0ViczdEdG5MZUViaDFScnFnNitvY2ZPckU0MTRR?=
 =?utf-8?B?YjNTbGRzZUQ4dUVnNlh5ejZPRWRiL2FPdk8wMWVBY1NXV2NWd1grWE9FTWZw?=
 =?utf-8?B?c3FlQkVwMGh1T2hwcVEwanFoemlVQ254Q1ZYdUJUK2tGMm1HcjBWdHRiZUI2?=
 =?utf-8?B?enJzY0pkSndLcnVzUXdmWTJjY1BkQmFFZmFlbWtOVEFQZENyUlZpY1ZhcXg2?=
 =?utf-8?B?VmsySitzODF0S09QOU5wSUJJbC9vck5yL2QwNkdkYmI5SlR2a04ycDJzUjdj?=
 =?utf-8?B?ZWlmdlRKOTNMUTN0S0RGSmhxSVJFMGhRbENJcUdweTc0ZXl4ZHE0dXBYRktU?=
 =?utf-8?B?ZHlrbDlHVmt6QVVLRGhLa0pnaWZZUmFKWFEzS3FWdzJuTWxscmFmdz09?=
X-Exchange-RoutingPolicyChecked: H/By4aafk5fMHL+iQ3yl2IvU5YfyrRwbaBTvEyog34OGiTRvqfWSgHFLq0/tplCzqZacbl6CUcjt44Vvav18Sr/gsicJUIuPATxKZntKDZHmhRlS5CaSKrybcDc1TFnvwB5OBtCanUY9cKmTNiOfjH/NxQ9O/sysM7mP5YRWfisbmmaSjgj3EswxUvXPO6NSiS5YVRvpEi4pRbQKcXJvAuM/mAfwydGnxJD0HUFThs1XKvezYi2BwsmcuYcrDjdTUh9g8ECdwdo4ovOVVl7zVF/oY0KjJ+3JAfz68tiunCycR84pMv29dCixxUUv4kvOcYK9TsApI48ioskghditaA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e4be16-3330-4c3f-2130-08df370873c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:35:55.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFz4VrEG2J9zXZxWCiv1pTjBg5vMzGRZnPasCjvP9fUbgmPaW7XL8IvU88lae+zjP0oTOe3rrOX43bLh3lZLAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=J5I/fwnS c=1 sm=1 tr=0 ts=6ae5702f cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=k7r4yCLl9DVLXMiQTbtC:22 a=MvuuwTCpAAAA:8 a=uh1294_e5LEkvaFg0HwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 7TGPdwZ9PC7jjBQnc0hNWCbAjBsvSTg1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX753H3o3ga0nB
 a5IDvI0fGovv9nu3pAhR9yScxohq/OkmcKjZZYVDghqb7kIHLzmp2akXLvoCzvhIMLbkUU0iUMp
 4FBDO08k0BodhurXAyAasV68k+stAqLab+B42VC2NYYhioD8//rZH9Idu8ge2TS91KoiusuVcwS
 F2b2UOYXq1IAZ57KT/GfCpqhZQmfLlubkdbZ3tgZ+B7Vjb+BDWmziihNdleWGI6mdhtRl+/Cw7j
 Kas5h8yeSTahU2kq+lzGSo58Y96VY+Gw1Gf1dROCzgW9Dp5uLR3cS9vBJh9objr5S2e8qq2tFly
 HeZU3qQUTa2rNTklVmiFPVEO0TBPsaq9Jo72g24dN/VVBcOAjAUMYI+e3iIOpY84C23UxfSxsnw
 +J6QTJa9Ha9eFEMny3cVPSVJK8e1QDCdoVsb6J217W7U6nm76JW3C3fcwEhuJcKzPc20suDL+61
 /WXIw3Srjybhqo6/VpA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX50ppf7PhdbYW
 8W3mZ2IFKVCip5jjhwCZqaoQnkNeXILnABh6e2giMKCRRo4SSnjiRGIl5p9oDp8WsGkJu6lDipV
 x0/MeSBixwMPJvBXc7AQd5iVGH9ROAg=
X-Proofpoint-GUID: 7TGPdwZ9PC7jjBQnc0hNWCbAjBsvSTg1
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

The COUNTERS object reads every counter attached to it into one
array, which suits a fixed set but not a device with thousands of
status values of which a monitor wants a few.  Add two optional
attributes to the read method.  ITEMS is an array of driver defined
item numbers, and the values come back in the same order.  TIMESTAMPS
returns, per item, when the driver sampled it, in nanoseconds since the
epoch.  Either may be used without the other.

A driver advertises the extension by providing read_counters_ex().  A
counters object created for such a driver need not have any counters
attached, because the items are chosen at read time; the check for an
attached counter is skipped for those drivers.  Without the callback
the new attributes are rejected with EOPNOTSUPP, and the original
behaviour is unchanged.

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/core/device.c                   |  1 +
 .../infiniband/core/uverbs_std_types_counters.c    | 68 ++++++++++++++++++++--
 include/rdma/ib_verbs.h                            | 11 ++++
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  2 +
 4 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 1b838bf3600d..18c0d9243909 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3026,6 +3026,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, query_ucontext);
 	SET_DEVICE_OP(dev_ops, rdma_netdev_get_params);
 	SET_DEVICE_OP(dev_ops, read_counters);
+	SET_DEVICE_OP(dev_ops, read_counters_ex);
 	SET_DEVICE_OP(dev_ops, read_comp_cntr);
 	SET_DEVICE_OP(dev_ops, reg_dm_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr);
diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
index 381aa5797641..e452854ddaa9 100644
--- a/drivers/infiniband/core/uverbs_std_types_counters.c
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -92,12 +92,20 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_READ)(
 	const struct uverbs_attr *uattr;
 	struct ib_counters *counters =
 		uverbs_attr_get_obj(attrs, UVERBS_ATTR_READ_COUNTERS_HANDLE);
+	bool has_items, has_timestamps;
+	size_t len;
 	int ret;
 
-	if (!counters->device->ops.read_counters)
+	/*
+	 * A driver with read_counters_ex defines what its counters are, so
+	 * they need not be attached to anything before they are read.
+	 */
+	if (!counters->device->ops.read_counters &&
+	    !counters->device->ops.read_counters_ex)
 		return -EOPNOTSUPP;
 
-	if (!atomic_read(&counters->usecnt))
+	if (!counters->device->ops.read_counters_ex &&
+	    !atomic_read(&counters->usecnt))
 		return -EINVAL;
 
 	ret = uverbs_get_flags32(&read_attr.flags, attrs,
@@ -115,10 +123,56 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_READ)(
 	if (IS_ERR(read_attr.counters_buff))
 		return PTR_ERR(read_attr.counters_buff);
 
-	ret = counters->device->ops.read_counters(counters, &read_attr, attrs);
+	has_items = uverbs_attr_is_valid(attrs, UVERBS_ATTR_READ_COUNTERS_ITEMS);
+	has_timestamps = uverbs_attr_is_valid(attrs,
+					      UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS);
+	if ((has_items || has_timestamps) &&
+	    !counters->device->ops.read_counters_ex)
+		return -EOPNOTSUPP;
+
+	if (has_items) {
+		u64 *items;
+
+		len = uverbs_attr_get_len(attrs, UVERBS_ATTR_READ_COUNTERS_ITEMS);
+		if (len != array_size(read_attr.ncounters, sizeof(u64)))
+			return -EINVAL;
+		items = uverbs_zalloc(attrs, len);
+		if (IS_ERR(items))
+			return PTR_ERR(items);
+		ret = _uverbs_copy_from(items, attrs,
+					UVERBS_ATTR_READ_COUNTERS_ITEMS, len);
+		if (ret)
+			return ret;
+		read_attr.items = items;
+	}
+
+	if (has_timestamps) {
+		len = uverbs_attr_get_len(attrs,
+					  UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS);
+		if (len != array_size(read_attr.ncounters, sizeof(u64)))
+			return -EINVAL;
+		read_attr.timestamps = uverbs_zalloc(attrs, len);
+		if (IS_ERR(read_attr.timestamps))
+			return PTR_ERR(read_attr.timestamps);
+	}
+
+	if (counters->device->ops.read_counters_ex)
+		ret = counters->device->ops.read_counters_ex(counters,
+							     &read_attr, attrs);
+	else
+		ret = counters->device->ops.read_counters(counters, &read_attr,
+							  attrs);
 	if (ret)
 		return ret;
 
+	if (has_timestamps) {
+		ret = uverbs_copy_to(attrs, UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS,
+				     read_attr.timestamps,
+				     read_attr.ncounters * sizeof(u64));
+		if (ret)
+			return ret;
+	}
+
 	return uverbs_copy_to(attrs, UVERBS_ATTR_READ_COUNTERS_BUFF,
 			      read_attr.counters_buff,
 			      read_attr.ncounters * sizeof(u64));
@@ -148,7 +202,13 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UVERBS_ATTR_MIN_SIZE(0),
 			    UA_MANDATORY),
 	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_READ_COUNTERS_FLAGS,
-			     enum ib_uverbs_read_counters_flags));
+			     enum ib_uverbs_read_counters_flags),
+	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_READ_COUNTERS_ITEMS,
+			   UVERBS_ATTR_MIN_SIZE(sizeof(u64)),
+			   UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS,
+			    UVERBS_ATTR_MIN_SIZE(sizeof(u64)),
+			    UA_OPTIONAL));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_COUNTERS,
 			    UVERBS_TYPE_ALLOC_IDR(uverbs_free_counters),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a93715323ad5..5aa1fa576a44 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2595,6 +2595,10 @@ struct ib_counters_read_attr {
 	u64	*counters_buff;
 	u32	ncounters;
 	u32	flags; /* use enum ib_read_counters_flags */
+	/* Optional: counter numbers to read, ncounters entries */
+	const u64 *items;
+	/* Optional: filled with a timestamp for each counter read */
+	u64	*timestamps;
 };
 
 struct uverbs_attr_bundle;
@@ -2936,6 +2940,13 @@ struct ib_device_ops {
 	int (*create_counters)(struct ib_counters *counters,
 			       struct uverbs_attr_bundle *attrs);
 	int (*destroy_counters)(struct ib_counters *counters);
+	/*
+	 * Used instead of read_counters when the user selects counters with
+	 * items or asks for timestamps.
+	 */
+	int (*read_counters_ex)(struct ib_counters *counters,
+				struct ib_counters_read_attr *counters_read_attr,
+				struct uverbs_attr_bundle *attrs);
 	int (*read_counters)(struct ib_counters *counters,
 			     struct ib_counters_read_attr *counters_read_attr,
 			     struct uverbs_attr_bundle *attrs);
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 8de110b8db34..9ee083eed044 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -404,6 +404,8 @@ enum uverbs_attrs_read_counters_cmd_attr_ids {
 	UVERBS_ATTR_READ_COUNTERS_HANDLE,
 	UVERBS_ATTR_READ_COUNTERS_BUFF,
 	UVERBS_ATTR_READ_COUNTERS_FLAGS,
+	UVERBS_ATTR_READ_COUNTERS_ITEMS,
+	UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS,
 };
 
 enum uverbs_methods_actions_counters_ops {

-- 
2.56.0

