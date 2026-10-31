Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474836;
	b=j3EOEOwXOyDM7cDS6EU4xyyUgtLMuahhVo2ivEjH/s0e83DAHpdSXuxAuNKQfETgp7xh
	 rkgNDnK0eEq6ueHcUBPNj5YjetUDpcOLyWLbEkpndo64hGrUDZkNkH7XfsGS5hj0aGzRK
	 kEUgHj/SAwrw6jlyCMo1Tb6jlRTJodwqN9InIF9NTBIaya0y9HdRtjCHP7ukuA2NE/3Fc
	 926IJVJuDhhIa7ggB2t32FHCd0sFjyTt9L+5ErbCfd8Tur1yLtoKYc7bTiNwQ+YRwC1UA
	 FraYO/BUpjFJe8GKJD311NbnTCig9KyFAbWGY2Vg8S/5holoZm4daJ4yYNlpVIMwpqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474836;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=yz3frglRuNoS8UZXBflfattFPHaFDDLOmPvNTwiJPSo=;
	b=HSL7yQh0oasUJ7ZzQo/UGkFhKxUTdZIitGZgmZpH9LKNe2Dqqz+/jbVsDnC0V8Dqvqax
	 VHV08NBLYwpD/sZnao+B7hAcz6TVgjQ1LLSUV5cxqz257Arr+z031dc2wRzlQXG04WQo/
	 RuACTRNL2q3lL3ycL/oTs/wxQ0axiDliJ9H9Zv7EAHcEXWSG3PL3lQaUpMgXXr7nlmGOh
	 CE7HBV0ph2P2GNh8cg42d0A/Yx29A0pvWIJPyA5946wqmK0MPUkXLQeeiOiLjRn2pjsiv
	 +pEZfWtqQmmFsrhuu6xuqySl8T277XFF04i7CV9pZlJ6K7icO4HCTHa1gLgyqI9yiGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=lQdIgkWA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7FA60A2606;
	Sat, 31 Oct 2026 19:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C7FA60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=lQdIgkWA
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJCdUw099443;
	Sat, 31 Oct 2026 19:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=yz
	3frglRuNoS8UZXBflfattFPHaFDDLOmPvNTwiJPSo=; b=lQdIgkWAwiMo3lIols
	LPrye1SmEi3EZryMexGD5P/ivkCv0dvVWV+i4G0MmitkH79iQ7Gs9+/sgLQxuhrj
	ksPR75cm61PKvufUQDOeTCue4yWs3mh/m043cfWTn32gfhIYV9w26q71zCbZ/ACu
	uhzI03p1tr0HGa+Itd45wzbn404CqWE01kIh2O0OAsp8f4ffv7TAxqmk6RA2xGDE
	uDjVaaIqBmsNxgRuTg9/nXU+9SxumALHio1Qk6gWpwmND//R3Tp480v84ahy3KMt
	/JqyBKSsVi9911YqRhg/1v2AnK2o+RoDcBhkcDO04mgjx6lqBJuM32O4OQYhfBI1
	RnQQ==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn9hc60pr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:27:12 +0000 (GMT)
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 44DF9804785;
	Sat, 31 Oct 2026 19:27:12 +0000 (UTC)
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:27:12 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:27:12 -1200
Received: from SN1PR07CU001.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:27:11 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pvq7cqNkk+dJBwjne9MZ2FvgyZ55sRnhETks8p1D8/Tlcyt4LGpmDY/dt6JkubbbLhSXTBSAUOLbKkdUhKFPuee7b8BBp3cNmEUod63TuAtwxoEgK16zwQLq4PwHv/7Sy/4RsgXNTJ3yMSF+g7MK6uMUfrAF3Aiy4R/pNTvgNaEBg9WoLwGcSyy9/zl8k8Q0c8J98tijK3D8TIsc0WW1tByVVTSQjeUQ2Mx36nVktuG+3Ggrl/hg9Lc2UZwJFsRGRQXc0BijwJzvpNoIZWYk0mPTReYub1WWuECuoeplpgCZNQDaDiueryvWB/QXCMA8tCMNFbI3azu5+Wrk+awSKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yz3frglRuNoS8UZXBflfattFPHaFDDLOmPvNTwiJPSo=;
 b=JnCztxCOZ1Xeg0i0JxfUor5k5m0/+Si9EXANoZj4fTUnR2MDmZ367zDDUJpuyHmraVhslIqyEz3DC+Ha3rW07O7XLAn2Cw5f3Fv4GC4G8YfSCjYs919+aKe8nVLjFcKN4VTFsa/eb/hHhvXmetNAz1RyPSv/Es55TSjZkq6g+Kc2TXyKUAd7Ekd9EHg31ufKboFQ8MSg66oLZvLuwdgIHqo6P++NwRLCVlluNm4rmePknmQOVkOtwySyc0dZu5IQ4/hPBPRZmYAWfTNpg/7EeNPYnP8H5A4VzKRUEARZVN01PxqPy7rZLTjBX9GGnuz5MsLvaQQACBXVSX2UAwgBWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW5PR84MB1891.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:27:07 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:27:07 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:26:04 -0700
Subject: [PATCH 11/12] cxiverbs: wire and package the CXI verbs provider
 and tests
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-11-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>,
        Terrence Mitchem
	<terrence.mitchem@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA1P222CA0073.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::23) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW5PR84MB1891:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1270e6-8423-405b-ac92-08df3784f3d9
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|261009223027099003|261028144727099003|261026121527099003|261021121427099003|261021123027099003|261021135927099003|261022105027099003|261026140227099003|261022075727099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: b0C8TalI8nUU7pa4qWFiQ+ywseSOp0Sj2ouKSmIWmIVEfcqMC+QRILxTURk8tYzW3Ye/pgo9igmENFPs4Qkg8/rCf31JWDpkd8aNWYJ3EK6z206w7OamHAYfHbhOb/R74hqsL7H/r5uJbgd5+rbHcf7FdcgYSSD6bslvQz2Yau56y1ZsHDPhIHMMCom+Xge9we1K3oq5GzgyahKzYy0tQf8bph98ydmH73NgENynsh0sVtpNFdaDPPBUhIVl/U3q+EYPUMzwMVNEbtr4j6wocdwrkSTGS3Kx9GfGVU/Oh/TlZmBTjoPToDITawuMSZg/iWr3zaCPOeLCD9QWeDL97wZHkNZqTTDVk6JUMTJ1r5Pj8sMqpO1V5iNyEQTd8c8qioa/wkH3XohRV4oW8RFcz/dHO7TrKCuc3XdKNso9NeKNSJ2dkX6y1GAJh8//nkLfv8n3JaE0ygFZ9ZTwH34FjQGAcs6HmpSQ+EKW8PxfGmZ2IBsmRHaGwW86zyuPdRYiSh9ssGstcaCdBZ/3f64JXvKHlj7Y6Tm0PL2QovBJXnAv3FF7XO7qSut6JP9NES7ICozZnsiHpIcCv7Nl1XLJOqmFqYAPndzPhlxjKIY39WyfGBWuU95Y1Z1lHRSitr0KWMCD6gbf4FPH9gH3tdP8FUyGj2ewV+ayocUa7ywiyps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261021121427099003)(261021123027099003)(261021135927099003)(261022105027099003)(261026140227099003)(261022075727099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmdSelI3MmVuZXM5dUt0K0NHcyt0TllaSzdOR2NQZGdxdWxqcER2cVRlNjJz?=
 =?utf-8?B?NHl6NGJXY0FxMU93cHdKeHFVanE0cDNmT1FzMTNNVmVMdys0eFZvbjZqbXo1?=
 =?utf-8?B?U1hZWmNjZzVoa0pQd2dMeUttWklCdzlVSDB3VWlOL0EwSVZoeW0yVFVLUi9V?=
 =?utf-8?B?eitVK0tPTmk4N1E0Mk5kRmdRbEtXbVVTcVNJMmRScm9jb1pKeU1YNjdTVnh2?=
 =?utf-8?B?V0o1aVB1YTJsOC9ST05FU1dsOHZkNjBHQzBXWTk5U0s5NFFDM2NZTC8wNHZy?=
 =?utf-8?B?U01ZZXpPaEQwdjR0NG1oSDg0WjkxWG4yOFhSZlY5eFR3eXBNM0I2NzVpOXhi?=
 =?utf-8?B?c29aaTY2WllKdjZNNFJ5QmhZcmVmeEttUG9DU0F5ckhaTllVOXNCWGdoZEVW?=
 =?utf-8?B?UjZzUUhlTldhRnh6RVRBU2lsdGxxcDMrMzYxZmJid0ZoaWp1cDFpRWVJL280?=
 =?utf-8?B?YnQvWnhFMGhzejZQNExGRUVkbDVCZDBJZ0M0V21wQks5cnFOR0JVVHFBVFBj?=
 =?utf-8?B?Y0JFWUxPV2hrL3U5Z2I5SDhjZ1NOZ2FUUHU1NkVzYXlhL054M2tuM0hyM2hK?=
 =?utf-8?B?WWowLzhMajh5eHdZejZoeFJCcHFOdkx0WngySlBUSFRXNXZyS3BaUCtkdjU5?=
 =?utf-8?B?bGhPZ0REZzkxWVYxZks1NmNpY2haNlYwbmtkTHNPKzJTRlRpa1ZtSkFFV0Rn?=
 =?utf-8?B?R0ZGcFdUdHZ0bjRkcWl2RjR0cnUra2d6THFPUzVPclMxbkgvUk4zbFpIZEk2?=
 =?utf-8?B?UmQwWVRjVytoQ2dWUDNuWjl2MHA2YnBEM3gveTFGMGh0YzA0aStXbXFRckRY?=
 =?utf-8?B?dFVVVG9OYnNzTDJjb3l4UTYxSDFZNVNJOVNtV3FtK0FhT292eXZpN0ZuTWNz?=
 =?utf-8?B?VGs0RExZamR4bzVoYzBKdmtEZ1I5REtrd0l3MkZ6TitWTVdtTUgycVlYVmxk?=
 =?utf-8?B?dE13em1qeDkxWTlabm5MUGU1QWtnNDREQldPdlVDaUZvMzR5L1puZ2c1TE9m?=
 =?utf-8?B?eHEwWCs2Mk4yYy91L2NSRzA4QlZkbmlXYTVFMVFLM2JyTDhIQ1VKcWFMRTJQ?=
 =?utf-8?B?Rzl5NlM4UDcvaFVwM3V4eVAxZjVtT1d5TkN4RUpxcFNQSHNaN21TVTdWWUd2?=
 =?utf-8?B?d1daaWNnUGtqVC9HSU5RVDZXNXZkTnFrWXFHTklZWDNNWXp1TDRPT2NCTXZP?=
 =?utf-8?B?QUJ0aVd6QjY5VkUyd3VjbEpaZ3Z2WGoyRVhBbDVDaXROS3gxMGl6R1k0SmJs?=
 =?utf-8?B?bENPM21TbWt2VWQ2eE1XVlFQbnZkYnREOHJkMndjVDhaNjhBR3pnb1ZDaTh4?=
 =?utf-8?B?N1dmbklQeGpTSm9VSytXUERsQ204RTJTc1R0OWFSZ3dtMi9EYkVLODR1R1cx?=
 =?utf-8?B?dk5oSFBuc1Njc2ZQem9oMWYwUlZvb3ZkODJrSVZaZUthRlRwUlRTL1ZPUEVt?=
 =?utf-8?B?c0dHOXZHYWhZMG11U1FEcnM3VHZFR0U0cVpOSU90RUdjMEdVRmpiMUMwd2tT?=
 =?utf-8?B?SWJiQ01VNzd5Q0RLUnI3N2Y5K1NOWENLTHpSVWhHWjN6U3k2cGM5SXpDUmVi?=
 =?utf-8?B?cjJYSkRZazlZd09OdVIzMitlVUVuN2RxaVd6d1d0TE5vS1FJODNzM2djUzVv?=
 =?utf-8?B?Vlh2ZGFqUXhCeWV6NEc3ZFJoVUhvVHRxUGp0UHNZWlJHTTJkQy9MVU93UGpB?=
 =?utf-8?B?YWZHWGlZd29YZWNLWEpiZFREcTJidnNoYTJ5SUVmVkdQMmJFVkhuZG9qR2tM?=
 =?utf-8?B?bllDYlROZ0ZDUFJsOHFWa2VTTmFFVGFLOFJLR0Y4RXlmazNjeFQxS3VYRllh?=
 =?utf-8?B?SXRrUjZycVZhWko5WWVRalJwMzd5d1NlTzI4RVNsNllHS2hwSExIQ3FmQWx1?=
 =?utf-8?B?STVoV3A4WXZ6anRBTjJiUDlscUs0YnVnWlAzakNJbXhyZ0JhbW5wR3NmdlFr?=
 =?utf-8?B?dlR2TkV2cVhock1SL1lVWmxwcFZFK3NzcTUvY05hUDNVTEpmWmwvdzJ1NWI3?=
 =?utf-8?B?OVpqbHJNRFZwQVR1MUJwT055S2dqYTRuWHFCaGdyenVPaTdLSnFodHoyRVdr?=
 =?utf-8?B?bDZmOUxRRUhVNENvZWFKKzcxaVc2ZUE2MVgwYzgvOTVqSDZJOWhyd3JoZ0VU?=
 =?utf-8?B?U2RWVW5iMkZYT1kxWXY0YS82Mlc2V2dZTzJmWm5tZGVUcUIxbm5QOFlTR1M3?=
 =?utf-8?B?WlgxYVhFR3N5dXQvMDNlbXVjaWFkYmtqWmFRc0lQZWtHcjh3aVkwT05EcGdt?=
 =?utf-8?B?bEF4a1RFMWdCbDdlVmhEZ3dYL0FrZGlxS1lhbTVTNVVPQ3N2dXdjMGlneTA2?=
 =?utf-8?B?ZGg5VUNxSVVVMU1Fb3lkSHlEeXhteTB1UGw3SEhjTDZXRXZtQjNadz09?=
X-Exchange-RoutingPolicyChecked: vch56dQN51ZbDbMMflc9o9H16/z8q2n1Th/Sfsc2vsYfnqnlkFVDmn78VqlQAK0zuapxzJegSiq3IBJASpq7fniYhl1e0icIJljQ5MDWDDgEUU0Io6GV0j4TREtmVJJSSrqo1q1sYyX3cNLcU5uulfrGlgUymm4dGn1vHU57fnDtoqYvADal5K96pr8rOu6l7n8JcBbypDZWdj4n7Ew28y90Fcn/gPwH4bLvN/esmdhqSDMDQgrNT2aVEnvZMcYFdRI1hk7o22JjRMubX4m0HOBVEX7P3z3er5pz/9aJpKlG8skYz3tpsG/MpvAHilxfnKWKv+XeVqQfOwk6VbZ2qg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1270e6-8423-405b-ac92-08df3784f3d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:27:07.7796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2c61LbBqhZ+qzYU9BYgdwzl/I3WdNQPQAS1zsoawN0LdCvngdauKFosv4foEzBltonrNjihc0Nl0V9WnA7K0kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1891
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX3CtZGI+uW565
 QWS1GcJhf6yr/qRvx3l2+WwFT1Alq+/NkdJFXVWAKfqItfMWv6sqqKSAqFmqudpBR+f8/hpVo/g
 bieqLF3GhJzmq+vQcD0wNEZG6M4Ps7U=
X-Proofpoint-GUID: IyfzHkikW5zvKratbyrUEsdHphEsQzBu
X-Authority-Analysis: v=2.4 cv=Be9NQbt2 c=1 sm=1 tr=0 ts=6ae64111 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=6XKncaru_qjgLvANlS_8:22 a=RiIid9coAAAA:8 a=MvuuwTCpAAAA:8 a=vggBfdFIAAAA:8
 a=LRmCSSeEhfHNkm-V9ZIA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=XKWKsq0CuoyFKVVHhDP9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX1RkrgtcH0Uux
 2Hhkr0rNIHTAbl1N+oRM2xLJbtcnRLa+I9gKkq78dYZBDrTKhxlNKsBF/7rE0hX4WCtzbiXR4cO
 8uC3ICLjbP/CX0fQfB27aWUGogz7g5QZd8n7yaEII+CKW41W1VSgXUVsVj0pfu0vpl9ZYCbAydJ
 FjRjTXiK7x44Xy862tnmgeurd7tks262hbFKNvMUbhKLgyGnyngmTPeJsT8q3oBhU6u/+t2oh8s
 PrgIbQWO0VWoOhAuNCTMihOlbykE0i/f61VexeNypsCGODrKHi+kIsVGjiexprdxEleMkRdjRjF
 ANGuTWXIGtG564dETMRrwR6mJzK2c+cR1q/rCeAY0o3haHrFZC5C4bCpeG3IT9cQErOsrs+JcIz
 mbPmngqJTZ60tmT3eDCZ4Nn5ofxD7TdbRYuBT/uuNmkQmgXiD0FJEgFr93blR+OYqzdPlpvOUCb
 rSBWvGfyDFYZxkXD51Q==
X-Proofpoint-ORIG-GUID: IyfzHkikW5zvKratbyrUEsdHphEsQzBu
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310077

Add the build files for the provider, its tests and the launcher and
publish the new headers.  The provider is a shared provider library
libcxiverbs that exports the cxidv_* symbols.  Like the other hardware
providers it uses util/udma_barrier.h, so it is built only where
HAVE_COHERENT_DMA is set.

The LNI and PID bindings the pyverbs RU tests need call the cxidv API,
so they live in a pyverbs.providers.cxi.cxidv module, built alongside
the mlx5 and efa provider modules, rather than in the generic
pyverbs.ru module.

libcxiverbs.so.1 is packaged the way efa, mana and mlx5 are: in
ibverbs-providers on Debian, with a symbols section, a lintian override
and a copyright entry; in its own libcxiverbs1 package on SUSE,
required by libibverbs and devel; and in libibverbs on Red Hat.

cxi_launcher ships with the provider library rather than in the -utils
package: client programs cannot run on CXI hardware without it, so it
has to be installed whenever the provider is, and putting it in -utils
would make that package mandatory on every CXI system.  The RPM file
list previously named a uet_launcher plugin and binary that no longer
exist.

checkpatch reports one REPEATED_WORD warning in
pyverbs/providers/cxi/cxidv.pyx ("Context context").  This is a false
positive: it is a Cython typed parameter (type Context, name context),
not a repeated word.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Co-developed-by: Terrence Mitchem <terrence.mitchem@hpe.com>
Signed-off-by: Terrence Mitchem <terrence.mitchem@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 CMakeLists.txt                             |  1 +
 debian/control                             |  1 +
 debian/copyright                           |  5 ++
 debian/ibverbs-providers.install           |  3 ++
 debian/ibverbs-providers.lintian-overrides |  4 +-
 debian/ibverbs-providers.symbols           | 46 +++++++++++++++++
 debian/ibverbs-utils.install               |  1 +
 debian/libibverbs-dev.install              |  5 ++
 debian/rules                               |  6 +--
 kernel-headers/CMakeLists.txt              |  8 +++
 libibverbs/verbs.h                         |  1 +
 providers/cxi/CMakeLists.txt               | 19 +++++++
 providers/cxi/libcxiverbs.map              | 49 ++++++++++++++++++
 providers/cxi/tests/CMakeLists.txt         |  4 ++
 providers/cxi/tests/cxi_launcher_test.c    | 79 ++++++++++++++++++++++++++++++
 providers/cxi/utils/CMakeLists.txt         |  5 ++
 pyverbs/CMakeLists.txt                     |  3 +-
 pyverbs/device.pxd                         |  1 +
 pyverbs/device.pyx                         |  3 +-
 pyverbs/providers/cxi/CMakeLists.txt       |  6 +++
 pyverbs/providers/cxi/__init__.pxd         |  0
 pyverbs/providers/cxi/__init__.py          |  0
 pyverbs/providers/cxi/cxidv.pxd            | 23 +++++++++
 pyverbs/providers/cxi/cxidv.pyx            | 64 ++++++++++++++++++++++++
 pyverbs/ru.pyx                             |  2 +-
 redhat/rdma-core.spec                      |  5 ++
 suse/rdma-core.spec                        | 23 +++++++++
 27 files changed, 359 insertions(+), 8 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4a25e6228a88..85cb10a92ab4 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -806,6 +806,7 @@ if (HAVE_COHERENT_DMA)
 add_subdirectory(providers/bnxt_re)
 add_subdirectory(providers/bnxt_re/man)
 add_subdirectory(providers/cxgb4) # NO SPARSE
+add_subdirectory(providers/cxi)
 add_subdirectory(providers/efa)
 add_subdirectory(providers/efa/man)
 add_subdirectory(providers/erdma)
diff --git a/debian/control b/debian/control
index f709d7ee773a..d9063ad8db8e 100644
--- a/debian/control
+++ b/debian/control
@@ -88,6 +88,7 @@ Description: User space provider drivers for libibverbs
  .
   - bnxt_re: Broadcom NetXtreme-E RoCE HCAs
   - cxgb4: Chelsio T4 iWARP HCAs
+  - cxi: HPE Cassini Network Adapter
   - efa: Amazon Elastic Fabric Adapter
   - erdma: Alibaba Elastic RDMA (iWarp) Adapter
   - hfi1verbs: Intel Omni-Path HFI
diff --git a/debian/copyright b/debian/copyright
index e32de0f172bd..c16e80cf5d77 100644
--- a/debian/copyright
+++ b/debian/copyright
@@ -151,6 +151,11 @@ Files: providers/cxgb4/*
 Copyright: 2003-2016, Chelsio Communications, Inc.
 License: BSD-MIT or GPL-2
 
+Files: providers/cxi/*
+Copyright: 2018-2020, Cray Inc.
+           2024-2026, Hewlett Packard Enterprise Development LP
+License: BSD-2-clause or GPL-2
+
 Files: providers/efa/*
        pyverbs/providers/efa/*
 Copyright: 2019-2024 Amazon.com, Inc. or its affiliates.
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 2ee167b8433a..6609cdc5f418 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -1,5 +1,8 @@
 etc/libibverbs.d/
+# cxi_launcher ships with the CXI provider: CXI client programs cannot run without it
+usr/bin/cxi_launcher
 usr/lib/*/libbnxt_re.so.*
+usr/lib/*/libcxiverbs.so.*
 usr/lib/*/libefa.so.*
 usr/lib/*/libhns.so.*
 usr/lib/*/libibverbs/lib*-rdmav*.so
diff --git a/debian/ibverbs-providers.lintian-overrides b/debian/ibverbs-providers.lintian-overrides
index 400564ff21c3..1ca248856587 100644
--- a/debian/ibverbs-providers.lintian-overrides
+++ b/debian/ibverbs-providers.lintian-overrides
@@ -1,2 +1,2 @@
-# libefa, libhns, libionic, libmana, libmlx4 and libmlx5 are ibverbs provider that provides more functions.
-ibverbs-providers: package-name-doesnt-match-sonames libefa1 libhns1 libionic1 libmana1 libmlx4-1 libmlx5-1
+# libcxiverbs, libefa, libhns, libionic, libmana, libmlx4 and libmlx5 are ibverbs provider that provides more functions.
+ibverbs-providers: package-name-doesnt-match-sonames libcxiverbs1 libefa1 libhns1 libionic1 libmana1 libmlx4-1 libmlx5-1
diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index bb74b34bc133..3772c9c3733b 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -232,3 +232,49 @@ libionic.so.1 ibverbs-providers #MINVER#
  ionic_dv_pd_set_udma_mask@IONIC_1.0 59
  ionic_dv_pd_set_sqcmb@IONIC_1.0 59
  ionic_dv_pd_set_rqcmb@IONIC_1.0 59
+libcxiverbs.so.1 ibverbs-providers #MINVER#
+* Build-Depends-Package: libibverbs-dev
+ CXIVERBS_1.0@CXIVERBS_1.0 66
+ cxidv_alloc_svc@CXIVERBS_1.0 66
+ cxidv_query_svc@CXIVERBS_1.0 66
+ cxidv_get_svc_rsrc_use@CXIVERBS_1.0 66
+ cxidv_get_svc_lpr@CXIVERBS_1.0 66
+ cxidv_destroy_svc@CXIVERBS_1.0 66
+ cxidv_enable_svc@CXIVERBS_1.0 66
+ cxidv_svc_is_enabled@CXIVERBS_1.0 66
+ cxidv_alloc_lni@CXIVERBS_1.0 66
+ cxidv_alloc_cp@CXIVERBS_1.0 66
+ cxidv_destroy_cp@CXIVERBS_1.0 66
+ cxidv_alloc_ct@CXIVERBS_1.0 66
+ cxidv_inbound_wait@CXIVERBS_1.0 66
+ cxidv_alloc_ct_writeback@CXIVERBS_1.0 66
+ cxidv_destroy_ct@CXIVERBS_1.0 66
+ cxidv_alloc_cmdq@CXIVERBS_1.0 66
+ cxidv_alloc_trigger_cmdq@CXIVERBS_1.0 66
+ cxidv_destroy_cmdq@CXIVERBS_1.0 66
+ cxidv_alloc_wait@CXIVERBS_1.0 66
+ cxidv_destroy_wait@CXIVERBS_1.0 66
+ cxidv_alloc_eq@CXIVERBS_1.0 66
+ cxidv_destroy_eq@CXIVERBS_1.0 66
+ cxidv_map_csrs@CXIVERBS_1.0 66
+ cxidv_unmap_csrs@CXIVERBS_1.0 66
+ cxidv_read_csr@CXIVERBS_1.0 66
+ cxidv_write_csr@CXIVERBS_1.0 66
+ cxidv_write8_csr@CXIVERBS_1.0 66
+ cxidv_destroy_lni@CXIVERBS_1.0 66
+ cxidv_alloc_pd@CXIVERBS_1.0 66
+ cxidv_alloc_pid@CXIVERBS_1.0 66
+ cxidv_query_pid@CXIVERBS_1.0 66
+ cxidv_query_device@CXIVERBS_1.0 66
+ cxidv_mr_from_ibv_mr@CXIVERBS_1.0 66
+ cxidv_reg_native_mr@CXIVERBS_1.0 66
+ cxidv_cq_from_ibv_cq@CXIVERBS_1.0 66
+ cxidv_qp_from_ibv_qp@CXIVERBS_1.0 66
+ cxidv_modify_qp_src_id@CXIVERBS_1.0 66
+ cxidv_bind_job_tc@CXIVERBS_1.0 66
+ cxidv_clear_job_tc@CXIVERBS_1.0 66
+ cxidv_set_default_tc@CXIVERBS_1.0 66
+ cxidv_query_tcs@CXIVERBS_1.0 66
+ cxidv_telem_name@CXIVERBS_1.0 66
+ cxidv_telem_lookup@CXIVERBS_1.0 66
+ cxidv_telem_get_set@CXIVERBS_1.0 66
diff --git a/debian/ibverbs-utils.install b/debian/ibverbs-utils.install
index 569012599233..a8ab93836687 100644
--- a/debian/ibverbs-utils.install
+++ b/debian/ibverbs-utils.install
@@ -1,3 +1,4 @@
+usr/bin/cxi_telem
 usr/bin/ibv_asyncwatch
 usr/bin/ibv_devices
 usr/bin/ibv_devinfo
diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index f62250e91641..e09df711b63b 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -1,4 +1,6 @@
 usr/include/infiniband/arch.h
+usr/include/infiniband/cxidv.h
+usr/include/infiniband/cxidv_telem.h
 usr/include/infiniband/bnxt_re-hsi.h
 usr/include/infiniband/bnxt_re_dv.h
 usr/include/infiniband/efadv.h
@@ -18,6 +20,8 @@ usr/include/infiniband/verbs.h
 usr/include/infiniband/verbs_api.h
 usr/lib/*/lib*-rdmav*.a
 usr/lib/*/libbnxt_re.a
+usr/lib/*/libcxiverbs.a
+usr/lib/*/libcxiverbs.so
 usr/lib/*/libbnxt_re.so
 usr/lib/*/libefa.a
 usr/lib/*/libefa.so
@@ -34,6 +38,7 @@ usr/lib/*/libmlx4.so
 usr/lib/*/libmlx5.a
 usr/lib/*/libmlx5.so
 usr/lib/*/pkgconfig/libbnxt_re.pc
+usr/lib/*/pkgconfig/libcxiverbs.pc
 usr/lib/*/pkgconfig/libefa.pc
 usr/lib/*/pkgconfig/libhns.pc
 usr/lib/*/pkgconfig/libibverbs.pc
diff --git a/debian/rules b/debian/rules
index 392ddd75aaa9..22aa8cc03e9e 100755
--- a/debian/rules
+++ b/debian/rules
@@ -18,7 +18,7 @@ dh_params = --with python3 --builddirectory=build-deb
 override_dh_auto_clean:
 	dh_auto_clean
 	rm -rf build-deb
-	for package in ibverbs-providers libibverbs-dev rdma-core; do \
+	for package in ibverbs-providers ibverbs-utils libibverbs-dev rdma-core; do \
 		test ! -e debian/$$package.install.backup || mv debian/$$package.install.backup debian/$$package.install; \
 	done
 
@@ -63,10 +63,10 @@ override_dh_auto_test:
 override_dh_auto_install:
 # Some providers are disabled on architectures that are not able to do coherent DMA
 ifeq (,$(filter-out $(NON_COHERENT_DMA_ARCHS),$(DEB_HOST_ARCH)))
-	for package in ibverbs-providers libibverbs-dev rdma-core; do \
+	for package in ibverbs-providers ibverbs-utils libibverbs-dev rdma-core; do \
 		test -e debian/$$package.install.backup || cp debian/$$package.install debian/$$package.install.backup; \
 	done
-	sed -i '/efa\|hns\|ionic\|mana\|mlx[45]/d' debian/ibverbs-providers.install debian/libibverbs-dev.install debian/rdma-core.install
+	sed -i '/cxi\|efa\|hns\|ionic\|mana\|mlx[45]/d' debian/ibverbs-providers.install debian/ibverbs-utils.install debian/libibverbs-dev.install debian/rdma-core.install
 endif
 	DESTDIR=$(CURDIR)/debian/tmp ninja -C build-deb install
 
diff --git a/kernel-headers/CMakeLists.txt b/kernel-headers/CMakeLists.txt
index cd9c08cad30c..569f42aa5d34 100644
--- a/kernel-headers/CMakeLists.txt
+++ b/kernel-headers/CMakeLists.txt
@@ -1,6 +1,7 @@
 publish_internal_headers(rdma
   rdma/bnxt_re-abi.h
   rdma/cxgb4-abi.h
+  rdma/cxiverbs-abi.h
   rdma/efa-abi.h
   rdma/erdma-abi.h
   rdma/hns-abi.h
@@ -34,6 +35,12 @@ publish_internal_headers(rdma/hfi
   rdma/hfi/hfi1_user.h
   )
 
+# Cassini wire format, shared with the kernel's include/uapi/ethernet/;
+# update alongside kernel-headers/rdma/cxiverbs-abi.h.
+publish_internal_headers(ethernet
+  ethernet/cassini_user_defs.h
+  )
+
 publish_internal_headers(linux
   linux/stddef.h
   linux/vfio.h
@@ -67,6 +74,7 @@ endfunction()
 rdma_kernel_provider_abi(
   rdma/bnxt_re-abi.h
   rdma/cxgb4-abi.h
+  rdma/cxiverbs-abi.h
   rdma/efa-abi.h
   rdma/erdma-abi.h
   rdma/hns-abi.h
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 560643b77e35..5d87f671c0a2 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -2706,6 +2706,7 @@ extern const struct verbs_device_ops verbs_provider_rxe;
 extern const struct verbs_device_ops verbs_provider_siw;
 extern const struct verbs_device_ops verbs_provider_vmw_pvrdma;
 extern const struct verbs_device_ops verbs_provider_ionic;
+extern const struct verbs_device_ops verbs_provider_cxiverbs;
 extern const struct verbs_device_ops verbs_provider_all;
 extern const struct verbs_device_ops verbs_provider_none;
 void ibv_static_providers(void *unused, ...);
diff --git a/providers/cxi/CMakeLists.txt b/providers/cxi/CMakeLists.txt
new file mode 100644
index 000000000000..298dbea53a90
--- /dev/null
+++ b/providers/cxi/CMakeLists.txt
@@ -0,0 +1,19 @@
+# Named cxiverbs (not cxi) to avoid colliding with the separate libcxi.so
+# built by the HPE libcxi project, which links against this via cxidv.h.
+rdma_shared_provider(cxiverbs libcxiverbs.map
+  1 1.0.${PACKAGE_VERSION}
+  cxi.c
+  cxi_telem.c
+  verbs.c
+  )
+
+publish_headers(infiniband
+  cxidv.h
+  cxidv_telem.h
+  )
+
+add_subdirectory(tests)
+
+add_subdirectory(utils)
+
+rdma_pkg_config("cxiverbs" "libibverbs" "${CMAKE_THREAD_LIBS_INIT}")
diff --git a/providers/cxi/libcxiverbs.map b/providers/cxi/libcxiverbs.map
new file mode 100644
index 000000000000..ea7e833d3415
--- /dev/null
+++ b/providers/cxi/libcxiverbs.map
@@ -0,0 +1,49 @@
+/* Export symbols should be added below according to
+   Documentation/versioning.md document. */
+CXIVERBS_1.0 {
+	global:
+		cxidv_alloc_svc;
+		cxidv_query_svc;
+		cxidv_get_svc_rsrc_use;
+		cxidv_get_svc_lpr;
+		cxidv_destroy_svc;
+		cxidv_enable_svc;
+		cxidv_svc_is_enabled;
+		cxidv_alloc_lni;
+		cxidv_alloc_cp;
+		cxidv_destroy_cp;
+		cxidv_alloc_ct;
+		cxidv_inbound_wait;
+		cxidv_alloc_ct_writeback;
+		cxidv_destroy_ct;
+		cxidv_alloc_cmdq;
+		cxidv_alloc_trigger_cmdq;
+		cxidv_destroy_cmdq;
+		cxidv_alloc_wait;
+		cxidv_destroy_wait;
+		cxidv_alloc_eq;
+		cxidv_destroy_eq;
+		cxidv_map_csrs;
+		cxidv_unmap_csrs;
+		cxidv_read_csr;
+		cxidv_write_csr;
+		cxidv_write8_csr;
+		cxidv_destroy_lni;
+		cxidv_alloc_pd;
+		cxidv_alloc_pid;
+		cxidv_query_pid;
+		cxidv_query_device;
+		cxidv_mr_from_ibv_mr;
+		cxidv_reg_native_mr;
+		cxidv_cq_from_ibv_cq;
+		cxidv_qp_from_ibv_qp;
+		cxidv_modify_qp_src_id;
+		cxidv_bind_job_tc;
+		cxidv_clear_job_tc;
+		cxidv_set_default_tc;
+		cxidv_query_tcs;
+		cxidv_telem_name;
+		cxidv_telem_lookup;
+		cxidv_telem_get_set;
+	local: *;
+};
diff --git a/providers/cxi/tests/CMakeLists.txt b/providers/cxi/tests/CMakeLists.txt
new file mode 100644
index 000000000000..99a4d7f2f1cf
--- /dev/null
+++ b/providers/cxi/tests/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_test_executable(cxi_le_test cxi_le_test.c)
+target_link_libraries(cxi_le_test LINK_PRIVATE cxiverbs ibverbs ${CMAKE_THREAD_LIBS_INIT})
+rdma_test_executable(cxi_launcher_test cxi_launcher_test.c)
+target_link_libraries(cxi_launcher_test LINK_PRIVATE cxiverbs ibverbs)
diff --git a/providers/cxi/tests/cxi_launcher_test.c b/providers/cxi/tests/cxi_launcher_test.c
new file mode 100644
index 000000000000..1c5956a2dfad
--- /dev/null
+++ b/providers/cxi/tests/cxi_launcher_test.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+#define _GNU_SOURCE
+#include <sys/resource.h>
+#include <sys/syscall.h>
+#undef SYS_close_range
+int cxi_launcher_program_main(int argc, char **argv);
+#define main cxi_launcher_program_main
+#include "../utils/cxi_launcher.c"
+#undef main
+
+static int check_fd_cleanup(int keep)
+{
+	struct rlimit limit;
+	pid_t child;
+	int status;
+
+	child = fork();
+	if (child < 0)
+		return 1;
+	if (!child) {
+		int source;
+		int high;
+		int descriptor;
+
+		source = open("/dev/null", O_RDWR);
+		if (source < 0)
+			_exit(1);
+		for (descriptor = 0; descriptor < 3; descriptor++)
+			if (dup2(source, descriptor) < 0)
+				_exit(2);
+		if (source != 3) {
+			if (dup2(source, 3) < 0)
+				_exit(3);
+			close(source);
+		}
+		if (getrlimit(RLIMIT_NOFILE, &limit))
+			_exit(5);
+		if (limit.rlim_cur < 70001) {
+			limit.rlim_cur = 70001;
+			if (limit.rlim_max < limit.rlim_cur)
+				limit.rlim_max = limit.rlim_cur;
+			if (setrlimit(RLIMIT_NOFILE, &limit))
+				_exit(4);
+		}
+		high = fcntl(3, F_DUPFD, 70000);
+		if (high < 0)
+			_exit(4);
+		limit.rlim_cur = 256;
+		if (setrlimit(RLIMIT_NOFILE, &limit) || close_inherited_fds(keep))
+			_exit(6);
+		if (fcntl(high, F_GETFD) != -1 || errno != EBADF)
+			_exit(7);
+		for (descriptor = 0; descriptor < 3; descriptor++)
+			if (fcntl(descriptor, F_GETFD) < 0)
+				_exit(8);
+		if (keep >= 3 && fcntl(keep, F_GETFD) < 0)
+			_exit(9);
+		_exit(0);
+	}
+	if (waitpid(child, &status, 0) != child)
+		return 1;
+	if (!WIFEXITED(status) || WEXITSTATUS(status)) {
+		fprintf(stderr, "FD cleanup failed for keep=%d, status=%d\n", keep, status);
+		return 1;
+	}
+	return 0;
+}
+
+int main(void)
+{
+	static const int keep_fds[] = { -1, 0, 1, 3 };
+	size_t index;
+
+	for (index = 0; index < ARRAY_SIZE(keep_fds); index++)
+		if (check_fd_cleanup(keep_fds[index]))
+			return 1;
+	puts("PASS: FD fallback closes high descriptors and preserves stdio/grant");
+	return 0;
+}
diff --git a/providers/cxi/utils/CMakeLists.txt b/providers/cxi/utils/CMakeLists.txt
new file mode 100644
index 000000000000..02b43d044e40
--- /dev/null
+++ b/providers/cxi/utils/CMakeLists.txt
@@ -0,0 +1,5 @@
+rdma_executable(cxi_telem cxi_telem.c)
+target_link_libraries(cxi_telem LINK_PRIVATE cxiverbs ibverbs)
+
+rdma_executable(cxi_launcher cxi_launcher.c)
+target_link_libraries(cxi_launcher LINK_PRIVATE cxiverbs ibverbs ${COMMON_LIBS})
\ No newline at end of file
diff --git a/pyverbs/CMakeLists.txt b/pyverbs/CMakeLists.txt
index d128de2caf98..4d1ec42ef57e 100644
--- a/pyverbs/CMakeLists.txt
+++ b/pyverbs/CMakeLists.txt
@@ -52,8 +52,9 @@ rdma_python_module(pyverbs
   utils.py
   )
 
-# mlx5 and efa providers are not built without coherent DMA, e.g. ARM32 build.
+# mlx5, efa and cxi providers are not built without coherent DMA, e.g. ARM32 build.
 if (HAVE_COHERENT_DMA)
 add_subdirectory(providers/mlx5)
 add_subdirectory(providers/efa)
+add_subdirectory(providers/cxi)
 endif()
diff --git a/pyverbs/device.pxd b/pyverbs/device.pxd
index 75ede6889d61..3c44aeafa257 100644
--- a/pyverbs/device.pxd
+++ b/pyverbs/device.pxd
@@ -13,6 +13,7 @@ cdef class Context(PyverbsCM):
     cdef object name
     cdef add_ref(self, obj)
     cdef object pds
+    cdef object lnis
     cdef object dms
     cdef object ccs
     cdef object cqs
diff --git a/pyverbs/device.pyx b/pyverbs/device.pyx
index b8b4b10d35aa..ac9cfd4f8b2f 100644
--- a/pyverbs/device.pyx
+++ b/pyverbs/device.pyx
@@ -111,6 +111,7 @@ cdef class Context(PyverbsCM):
 
         super().__init__()
         self.pds = weakref.WeakSet()
+        self.lnis = weakref.WeakSet()
         self.dms = weakref.WeakSet()
         self.ccs = weakref.WeakSet()
         self.cqs = weakref.WeakSet()
@@ -191,7 +192,7 @@ cdef class Context(PyverbsCM):
                             self.xrcds,
                             self.vars, self.sched_leafs, self.sched_nodes,
                             self.dr_domains, self.event_channels, self.dmahs,
-                            self.comp_cntrs])
+                            self.comp_cntrs, self.lnis])
             rc = v.ibv_close_device(self.context)
             if rc != 0:
                 raise PyverbsRDMAErrno(f'Failed to close device {self.name}')
diff --git a/pyverbs/providers/cxi/CMakeLists.txt b/pyverbs/providers/cxi/CMakeLists.txt
new file mode 100644
index 000000000000..23a071deebcd
--- /dev/null
+++ b/pyverbs/providers/cxi/CMakeLists.txt
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB)
+# Copyright 2026 Hewlett Packard Enterprise Development LP
+
+rdma_cython_module(pyverbs/providers/cxi cxiverbs
+  cxidv.pyx
+)
diff --git a/pyverbs/providers/cxi/__init__.pxd b/pyverbs/providers/cxi/__init__.pxd
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/pyverbs/providers/cxi/__init__.py b/pyverbs/providers/cxi/__init__.py
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/pyverbs/providers/cxi/cxidv.pxd b/pyverbs/providers/cxi/cxidv.pxd
new file mode 100644
index 000000000000..9008a3f4ca3b
--- /dev/null
+++ b/pyverbs/providers/cxi/cxidv.pxd
@@ -0,0 +1,23 @@
+# SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB)
+# Copyright 2026 Hewlett Packard Enterprise Development LP
+
+#cython: language_level=3
+
+from pyverbs.base cimport PyverbsCM
+from pyverbs.device cimport Context
+cimport pyverbs.libibverbs as v
+from libc.stdint cimport uint32_t
+
+cdef extern from "infiniband/cxidv.h":
+    cdef struct cxidv_lni:
+        v.ibv_context *context
+        uint32_t handle
+        uint32_t id
+        uint32_t svc_id
+
+
+cdef class LNI(PyverbsCM):
+    cdef cxidv_lni *lni
+    cdef Context ctx
+    cdef add_ref(self, obj)
+    cpdef close(self)
diff --git a/pyverbs/providers/cxi/cxidv.pyx b/pyverbs/providers/cxi/cxidv.pyx
new file mode 100644
index 000000000000..4b41b3b74953
--- /dev/null
+++ b/pyverbs/providers/cxi/cxidv.pyx
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB)
+# Copyright 2026 Hewlett Packard Enterprise Development LP
+"""
+CXI direct verbs needed to use Ultra Ethernet objects on a CXI device: the
+LNI a PD is allocated from, and the PID bound to that PD.
+"""
+from pyverbs.pyverbs_error import PyverbsError, PyverbsRDMAError
+from pyverbs.device cimport Context
+from pyverbs.pd cimport PD
+cimport pyverbs.libibverbs as v
+from libc.stdint cimport uint32_t
+
+cdef extern from "infiniband/cxidv.h":
+    int cxidv_alloc_lni(v.ibv_context *context, uint32_t svc_id,
+                        cxidv_lni **lni)
+    int cxidv_destroy_lni(cxidv_lni *lni)
+    int cxidv_alloc_pid(v.ibv_pd *pd, uint32_t flags, uint32_t *pid)
+
+
+def alloc_pid(PD pd not None, uint32_t flags=0):
+    cdef uint32_t pid
+    rc = cxidv_alloc_pid(pd.pd, flags, &pid)
+    if rc != 0:
+        raise PyverbsRDMAError('Failed to allocate CXI PID', rc)
+    return pid
+
+
+cdef class LNI(PyverbsCM):
+    def __init__(self, Context context not None, unsigned int svc_id=1):
+        super().__init__()
+        self.lni = NULL
+        rc = cxidv_alloc_lni(context.context, svc_id, &self.lni)
+        if rc != 0:
+            raise PyverbsRDMAError('Failed to allocate CXI LNI', rc)
+        self.ctx = context
+        context.lnis.add(self)
+
+    def __dealloc__(self):
+        self.close()
+
+    cpdef close(self):
+        cdef int rc
+
+        if self.lni != NULL:
+            rc = cxidv_destroy_lni(self.lni)
+            if rc != 0:
+                raise PyverbsRDMAError('Failed to destroy CXI LNI', rc)
+            self.lni = NULL
+            self.ctx = None
+
+    cdef add_ref(self, obj):
+        raise PyverbsError('CXI LNI does not own Python resources')
+
+    @property
+    def handle(self):
+        return self.lni.handle if self.lni != NULL else 0
+
+    @property
+    def id(self):
+        return self.lni.id if self.lni != NULL else 0
+
+    @property
+    def svc_id(self):
+        return self.lni.svc_id if self.lni != NULL else 0
diff --git a/pyverbs/ru.pyx b/pyverbs/ru.pyx
index e21d045a4a8b..4017ffb19ac6 100644
--- a/pyverbs/ru.pyx
+++ b/pyverbs/ru.pyx
@@ -258,7 +258,7 @@ cdef class Job(PyverbsCM):
         if fd is not None:
             rc = v.ibv_import_job(context.context, fd, &self.job)
             if rc != 0:
-                raise PyverbsRDMAError('Failed to import job', rc)
+                raise PyverbsRDMAErrno('Failed to import job')
             self._is_imported = True
         else:
             if attr is None:
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 9450299fd57c..aa1d38b1cdbf 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -191,6 +191,7 @@ fast path operations.
 Device-specific plug-in ibverbs userspace drivers are included:
 
 - libcxgb4: Chelsio T4 iWARP HCA
+- libcxiverbs: HPE Cassini Network Adapter
 - libefa: Amazon Elastic Fabric Adapter
 - liberdma: Alibaba Elastic RDMA (iWarp) Adapter
 - libhfi1: Intel Omni-Path HFI
@@ -604,6 +605,9 @@ fi
 %dir %{_sysconfdir}/libibverbs.d
 %dir %{_libdir}/libibverbs
 %{_libdir}/libbnxt_re.so.*
+%{_libdir}/libcxiverbs.so.*
+# cxi_launcher ships with the CXI provider: CXI client programs cannot run without it
+%{_bindir}/cxi_launcher
 %{_libdir}/libefa.so.*
 %{_libdir}/libhns.so.*
 %{_libdir}/libibverbs*.so.*
@@ -618,6 +622,7 @@ fi
 
 %files -n libibverbs-utils
 %{_bindir}/ibv_*
+%{_bindir}/cxi_telem
 %{_mandir}/man1/ibv_*
 
 %files -n ibacm
diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 24562b00e9b0..a0450d62a79b 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -34,6 +34,7 @@ Summary:        RDMA core userspace libraries and daemons
 License:        BSD-2-Clause OR GPL-2.0-only
 Group:          Productivity/Networking/Other
 
+%define cxiverbs_so_major 1
 %define efa_so_major    1
 %define hns_so_major    1
 %define ionic_so_major  1
@@ -48,6 +49,7 @@ Group:          Productivity/Networking/Other
 
 %define  bnxt_re_so_major 1
 %define  bnxt_re_lname libbnxt_re%{bnxt_re_so_major}
+%define  cxiverbs_lname libcxiverbs%{cxiverbs_so_major}
 %define  efa_lname    libefa%{efa_so_major}
 %define  hns_lname    libhns%{hns_so_major}
 %define  ionic_lname  libionic%{ionic_so_major}
@@ -166,6 +168,7 @@ Requires:       %{umad_lname} = %{version}-%{release}
 Requires:       %{verbs_lname} = %{version}-%{release}
 %if 0%{?dma_coherent}
 Requires:       %{bnxt_re_lname} = %{version}-%{release}
+Requires:       %{cxiverbs_lname} = %{version}-%{release}
 Requires:       %{efa_lname} = %{version}-%{release}
 Requires:       %{hns_lname} = %{version}-%{release}
 Requires:       %{ionic_lname} = %{version}-%{release}
@@ -220,6 +223,7 @@ Obsoletes:      libocrdma-rdmav2 < %{version}-%{release}
 Obsoletes:      librxe-rdmav2 < %{version}-%{release}
 %if 0%{?dma_coherent}
 Requires:       %{bnxt_re_lname} = %{version}-%{release}
+Requires:       %{cxiverbs_lname} = %{version}-%{release}
 Requires:       %{efa_lname} = %{version}-%{release}
 Requires:       %{hns_lname} = %{version}-%{release}
 Requires:       %{ionic_lname} = %{version}-%{release}
@@ -240,6 +244,7 @@ fast path operations.
 Device-specific plug-in ibverbs userspace drivers are included:
 
 - libcxgb4: Chelsio T4 iWARP HCA
+- libcxiverbs: HPE Cassini Network Adapter
 - libefa: Amazon Elastic Fabric Adapter
 - libhfi1: Intel Omni-Path HFI
 - libhns: HiSilicon Hip08+ SoC
@@ -271,6 +276,13 @@ Group:          System/Libraries
 %description -n %bnxt_re_lname
 This package contains the bnxt_re runtime library.
 
+%package -n %cxiverbs_lname
+Summary:        CXIVERBS runtime library
+Group:          System/Libraries
+
+%description -n %cxiverbs_lname
+This package contains the cxiverbs runtime library.
+
 %package -n %efa_lname
 Summary:        EFA runtime library
 Group:          System/Libraries
@@ -542,6 +554,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 
 %ldconfig_scriptlets -n %verbs_lname
 %ldconfig_scriptlets -n %bnxt_re_lname
+%ldconfig_scriptlets -n %cxiverbs_lname
 %ldconfig_scriptlets -n %efa_lname
 %ldconfig_scriptlets -n %hns_lname
 %ldconfig_scriptlets -n %ionic_lname
@@ -723,6 +736,10 @@ done
 %doc %{_docdir}/%{name}-%{version}/tag_matching.md
 %{_mandir}/man7/rxe*
 %{_prefix}/lib/sysusers.d/rdma.conf
+%if 0%{?dma_coherent}
+# cxi_launcher ships with the CXI provider: CXI client programs cannot run without it
+%{_bindir}/cxi_launcher
+%endif
 
 %files -n libibnetdisc%{ibnetdisc_major}
 %{_libdir}/libibnetdisc.so.*
@@ -737,6 +754,9 @@ done
 %files -n %bnxt_re_lname
 %{_libdir}/libbnxt_re*.so.*
 
+%files -n %cxiverbs_lname
+%{_libdir}/libcxiverbs*.so.*
+
 %files -n %efa_lname
 %{_libdir}/libefa*.so.*
 
@@ -759,6 +779,9 @@ done
 
 %files -n libibverbs-utils
 %{_bindir}/ibv_*
+%if 0%{?dma_coherent}
+%{_bindir}/cxi_telem
+%endif
 %{_mandir}/man1/ibv_*
 
 %files -n ibacm

-- 
2.56.0

