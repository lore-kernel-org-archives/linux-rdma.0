Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421365;
	b=T5QrZD36BJcBw8fn5Lgu7CJ9B6dRAcdevWEe2PcKPdoe8WHnGGqrAI9//0N/ffxsvG1r
	 GKrneEbYwovr5zyNNwDtUpsgUj3hXTiV1RbKHkkTQkLHWgZtHoHoOWNF0rPw0vpC2D3NQ
	 tdPtkL4UAg9X8Unf80QbBKkVfqBbKqLcUpXNY2z5y0S7fchcGkF8s8xyRz7L8yCMJ7sVo
	 oWwRAK5AGco7dCRiK1G6ns7h3v6eNGTWOc2oj3YFlatDhrXw83dlZgjsiRNcbR0fU7fHV
	 9YWaOFmQImC9MEjUG0X2iAHG3MSshZjvVsXsigOEGVP7+8pmFGaI/LsQhqusDtEnh3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421365;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:Subject:Date:
	 Message-Id:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:CC:X-Mailer:X-ClientProxiedBy:MIME-Version:
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
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Jfkw+z3fgfI8mM3aazCa5CoC4gURxMdq8wklCjpJ0Ts=;
	b=4H+yHug5Vo7pD3veZ1A9iB3bqQwV+c02MkZC/NA6RqgRD1tjEaRXtlktAUeOH33p//wE
	 pHtBIjf5H7JSa6UavzfQDEpkMvyzePxvqpIBDpUPsGyOREAQQltoNdKekiFArbEWH0k7s
	 3ktYBMGnxTxaXXa2xfm9qOJmuF5MO2z0N6znQgEcnLXilXq8/80IDDuwyU9SItkQMJrB+
	 BZ4psAc3YhAq4SXIRh+XI+/othJJ7sWGYtjjDKOGQEdas4Wjr7FDfP/xf/0h8Qlvt7x9z
	 9iEJ4gBBYj7A154FT7SJRKimWBA/eedyP61VAVevesKh1Db5t9nr2mEYc/kDeD6MAxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=UBa5xkmP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A875606A31C;
	Sat, 31 Oct 2026 04:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A875606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=UBa5xkmP
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V2JMWN1566781;
	Sat, 31 Oct 2026 04:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps0720; bh=Jfkw+z3fgfI8mM3aazCa5CoC
	4gURxMdq8wklCjpJ0Ts=; b=UBa5xkmPt7C3gApX28bIfy2KX8KKR++fS+VsDIqO
	SyKBPzZ0KoRqydN24Y1fQEwp1r+mPgfZkG/3mop3OlaTIM0Zy09pQUD9JGKI+Wg2
	N2u9qV+SujmC+hnswi9Qdv2QE2tOUuBWfepHiDzdyZbqdom/6eNugbCLmCZ5HerW
	SgxG6wz+jAN31A47vhbsBjlewT8gBWlDRrDWDkoWRTAyEUTWpiowrhs8Bb/cLL41
	YI1L8aeEgUcZpWIRpjhMTtMlpuDdv3G6pxolJMC0p7O35VF0I7RsSRv5rb5Qvj7g
	x5FZ8JPhby3BkEuDRUwadNclfk1FbqQvejgBX9LO1ALzRQ==
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn7esgy4a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:35:58 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id C658912B73;
	Sat, 31 Oct 2026 04:35:57 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:35:57 -1200
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:35:57 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:35:57 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:35:55 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+Gh6WOQN75BbWffX+kzpMrDtRepVxxWVDxaWJzdm3zfZyCcZp0MOxcM7rkz5uMhFYohgaoJGNbYx9NPSdpMpJkgaaebjKqN4IiXPVgQXftNkDKHQu4M1lKvnKNr3bJZ+ICkN+CNTNUZhoRB2oClPzPSuyFm/bK67Pe7kCiRTfTWHyJDyf+rDCJjGOPYlULs4JgRpl0jhH4hm8SO+ktlqig4aVQPRXMkZZ4ngXzYtxV4kJxp67vnsSDFpmXLbeNtAdduFd/i5fWA+v0utrfLtvb48dlU6oSACUOfpmZDSEBiVDiZYgF2s9fDhP2GuNTppyTX/9v2t2RhlrsAJ6gVeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jfkw+z3fgfI8mM3aazCa5CoC4gURxMdq8wklCjpJ0Ts=;
 b=lTzH/orq0N+hAxLXOC3dMo2y+S6zydPMenJLcuBU0wCFLC8371gAaAEjRxmiLxIMPyAhCMFK+MifQeoCg6CH4h43e57WL21vbsJmNusWdWhz5dzd0RnFtCDQjGkK0MDfX9rVswfscNyCfiRRGotjk936doiG+imxoep7EfjKozxaJ8jCavjC51MViOtEYuSv2f6Rxzg+fao1ZV5pCv0indlqWkmsRxZiO0Lr4ZGsEs5jfH2ifxb6Gb3wSnRj10bavGriW4waTATb5wnh6GAhBk+QMPdLKNYjGZf7TwjHCt2fLnykvAv9P18epe4OlUFVtOKgChlYPN1qcTWt79BfWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:35:53 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:35:52 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Subject: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
Date: Fri, 30 Oct 2026 21:35:28 -0700
Message-Id: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQ5AMBBA0avIrE1SFYKriEVbU8aipEWaiLsrl
 m/x/wWBPFOALrvA08mBV5dQ5BmYWbmJkMdkkELWhSgFmshoV4+O4o6NrYRWUo9VayElmyfL8dv
 1w+9w6IXM/j7gvh91DXQ2cAAAAA==
X-Change-ID: 20261030-cxi-for-next-8f50ba2bd59f
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>,
        Mamila Santosh
	<santosh-kumar.mamila@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: DS1P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:8:44e::15) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 9df7de38-37cb-41d0-3873-08df37087247
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|3023799007|56012099006|261021121427099003|5023799004|261021135927099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261022075727099003|261009223327099003|261009223027099003|261009221227099003|261009221727099003|261009220027099003;
X-Microsoft-Antispam-Message-Info: +BWzEOC1btWT2aZl+5f8/Gfk0rPLmCJUILykA3pR8SvxSuYgyUrrWAmnYCqA3caCHDbPdvaOJb+Qsrth3EzikT4WnkGs4au/txHv4MBFSxnF7k4/jfsyp8a+a5npDd+D/ENhJJuYi/kqFuX2YnTys9i1YTOp7NlBnFka5MEo3788OgQ0IkrHH5KYHYjZZiwItZofavicGasQ4nFuv78at1iQWeeEkzu2SurTDRpMck021fnpYkf5zojeCHarN2cirxIz8kVYW/+oKOagc4IyD7zgJzkjYGvoqKJgHdXMQEdsEJ38uOEQ1RNJDUfhi4twIop+ebAhRtyjGPHLA+dm7WpryDoDx+LYQHfdMw3pjTDUTac4AuOXRjnIxipWsSSbcsNoIuGIf1GhiRXGUVCtoCdGHycw/DTEHbwjOcjrs9/Czvuh3GFO5qtOD0dNANKkH+aU0W8XnBA+DjqWbaUsVK/QtKcnw2lwydIX1TWlU/IIvkQewMnY2qx1OLxzRqqAIu1f3RZg8kdiTGChCifDnJpcha2YAKiqlAJsY/T/x7MXNoVYX91LbL7xPxPyn8JCom9z76c/qJpRBG6HevegrdZjjSJh89+LPpTz4TdUObfUMu+Tc4Ll1j+88Zf80Mce
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(3023799007)(56012099006)(261021121427099003)(5023799004)(261021135927099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022075727099003)(261009223327099003)(261009223027099003)(261009221227099003)(261009221727099003)(261009220027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXh4RHE1Q2w1aEZBV1NHV0pVZHN4eURTQlViTDE0R3pTZ2tKVWNIcUFzRmdM?=
 =?utf-8?B?L2xuc0I0YnZhbmRkaCtqcmp6UnBMTzRFbHhHcC9YWFNoNkp2Vy8rNzlDUTMz?=
 =?utf-8?B?QWhaNU5RbnArRUR1S0JxeWgxRGYxb29VNFdZK2o1TXUvK1pTcmRGZ1NJaFgz?=
 =?utf-8?B?WnByOVhzK0hqZkV2MVhuQmxHVEYzK2RBNFFvdWcxdzVVekJtMVFZSklsb09N?=
 =?utf-8?B?RXBzMXdvYnQ3LytCQ1UzUFJIVklmcU5Ua1NNcTN1azc4aStNREw3R01HMW9F?=
 =?utf-8?B?aGRDbnNlNHc5VE9KR1UzSnRCRS9mbExnazk5SlVDNElxTWZnZUhDdGRGWnFi?=
 =?utf-8?B?dVl1NWoxNnVWVnZRKzNvZ0hRQUs3YXk2SXBnRndmcVZsd1MwcTgzSzdqS1oz?=
 =?utf-8?B?R3ZQcExid0pnV2FMY1A4SnZRQ2JUZTY4YXpOMXRWQlpaVmI2RDFWOHgwSDA3?=
 =?utf-8?B?bFByOXVKTHpyVGUyeTgxS2lnY2hvd3JnZ1FwZXdnRFA4OVNQSmtlbW83RVVr?=
 =?utf-8?B?T1JKcjY3eVBnYnJUeEkyeDZCRWhxTWNBT1Z2bWk5ZnhKTnpFdWR4dDNMSlJv?=
 =?utf-8?B?Mm4zdWVGWXpYT0VZVlErRGRYUm9hUEl2a0hxWDloZ2thcFZUdEdNWE1YMVFz?=
 =?utf-8?B?SmdVelQzZUplYjQ3Z0RUSGlXOGhMM2hGZkVZMUNLL0ZoM2tBMzloekRqWWdU?=
 =?utf-8?B?TjRqZncrYk1DbGVqU1ZQeDBOQ1ppczJvdUV4SGwxL0FEMWZrS0h1ODB1WkVG?=
 =?utf-8?B?MGlXZVpOS3U5KzNGVzlUdS9QbDNVUTNpZGptUUhBY3lQZ3dJT1VTeCsrWEdh?=
 =?utf-8?B?dzQrb2ltQXRmWVlKY0JQL2pDMEdzekJucUdyNmZVZmN1MERrbnJFVUo4cUx2?=
 =?utf-8?B?bGhpZmhacjZYRlRPVE1IVXV1bWJONlJTRGozSWNtV0JFSHpTd2VKZFc1a2xn?=
 =?utf-8?B?ODM3RFhZR2MySDR4UGtNczZJbWt3cVp5V1RFaWpLT05TanRjL24zN2FBZ2cy?=
 =?utf-8?B?dW85bHd1TXQreUdCcVhJeVJNRXFHY2U2NnFGYk15clZ2T3hEYkJrZHA2amlI?=
 =?utf-8?B?Nzg3R3FaOGVhOTFSYitNV21tWFZTTG9RTnphYUJJb1BNQkw3a3BiMm93aTJa?=
 =?utf-8?B?ODVVZVBTUkh3OFFBYk9qajFmQ2NjZUh5ZEhHWGFLYXppLzRDODFIT09Ha1hN?=
 =?utf-8?B?Ty9VUy9wQS9ldG1uZGhQME1JYmQ2UkFnYTVreFVmUDVqL01GaFhGOUNHMXcw?=
 =?utf-8?B?dlRlbjZ6TDJVa3ltUzk5MkxYTHl6YWsvVll5TUZuOC9RMStHSkFhT0FqV2tz?=
 =?utf-8?B?U0hmNEhvNGp6T2JQemVJT1pNeFJWLzNtbnlhUHNHM2VHNC9yLzBFd0JWV1Ba?=
 =?utf-8?B?Q3hwMkZLVXNRODhCYjBmaytuQ2FNdEhTYm5ZUHRVdGx3R01sVUxFN1BSRnlt?=
 =?utf-8?B?c1F1Ly9LM0ZBNmZYQkJjODR6R3V6OURNeVpsZUxHN3FuSEU0ajAySjBGTHIy?=
 =?utf-8?B?SGd0Wm9JQ1RlaktUQ3h5VVErUVJxRGhmcDhNMGRtakt2NWh5MVR2NUlxbEZo?=
 =?utf-8?B?aUYzQmRaQWl2bHlnalFJWFhCOGJjZ0FSc3hDMnJaYmx4YkxBZjB4MEFTSkww?=
 =?utf-8?B?eHVzbXYwSWtQS3pnM0dlam1FR0kxVjVIMXVpekpjaERieXM0ejZrYUh3cGg4?=
 =?utf-8?B?aVE5Q1lXaGxPK0VFY2FtNlIrL09SeUo0bnpZcFVBaS9DL2lzd0U3aDgwNHlH?=
 =?utf-8?B?NG4yd2VrZ2d2cStnUmxkMVpITFlvN2dReEdmaVVKUGFEeWRqVGt4WVdhNXVy?=
 =?utf-8?B?eUhjU2NNbnQ3VjU2MnFTK1dkMDg1ZlB0NXdyQVV0azVBbU9pZUI5Z0RQYmJ2?=
 =?utf-8?B?bDR1SzBDSXJUeUhMaHZXaWVWL0NNOVVzZFhmZ2lZdnlHbnJ5bk51T2g0NG9t?=
 =?utf-8?B?Y1FTbHlMY1FlRVBHQmFUZVYwZTUxTEJYOHZsN2hpbzN5a2xEclE4d21YYm1O?=
 =?utf-8?B?dENqWEdkQ2g0ZFEyV3MvL0ljamRGU2RKN2ZLcyt3bWFkRnNIcHZlSVh3SUNi?=
 =?utf-8?B?YWFMVC9jQXpxbjZMbUdEdUFEcjJQTWdkYVdZSVVoTlhXc1NKQkxQNHM4YXhS?=
 =?utf-8?B?eThSMWlEQ2tOMVVCcjBTUnRFeEVaVHFYWmwzMmN4UXA1bjFPbzJYZlhnTWpL?=
 =?utf-8?B?dkMweURQeG0xOVM4elAvRnNWWHB3Z1ZQeWc0REJSQlBmU2k1SmliemRHZkVp?=
 =?utf-8?B?NkNNNWJoeHFUMTlxcGpEWnVvSlZIZnc3dmVSeExWcjlRbUVJZnJ3QjI3d2Nz?=
 =?utf-8?B?YWRXQ0lIQTJFTzNFYzlSYmRBVk1PSUs5Nk5NcFdlUWYyUHBSc28wZz09?=
X-Exchange-RoutingPolicyChecked: N0Sw89MOePtTQFIrZ/iQFlW5UQ0J4Fwzw92kEbobplYc3o6GZsC04HdMDg4odJd6B5mmfuooIHNpjaAHzdN19jy1gMiCqMdHg8D0T3snS3O7sxjmkSFBevAVMEzEfWL0c6eQm8XtB/otDRuNPBefLOYa2uzAN01HUZSjrLcOMQgftDSuQIBXYN0zK8+3wWYKLZzPlf/n5hmmhLloDHFxBNEJzfCWSL0zTfa2Avz8iHA7rNP2xY4gzfBAB5MXTgKJbgVXo/CPIGd+zmNXmsFu6XarAMgnZiYRuK38mMfpk73hnEafK0HrlxatStHx1HwB0+WmEctyB8cnVBW1IIHVxQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df7de38-37cb-41d0-3873-08df37087247
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:35:52.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2BjVafXh5qOTzwVm1GgityrisfLh25JYR8IkmyMa2DFq7AYnL6Fd1fVSd4oVXp7CIIdNpg5PY5YXzj6+NBqftw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 3n3zQfl5iatnxC5tTcYY7YAsUEQMgTTu
X-Proofpoint-ORIG-GUID: 3n3zQfl5iatnxC5tTcYY7YAsUEQMgTTu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX91izf/uq8Szo
 w7nRnREa/3QiOeOKeaXjeWBQC3PfVV3uuLvsjbNVT5OajYZ8WwgeFWiOR38SaqQcvrKXB6Khh/L
 wsfqDVfmA20AfW9vpgRdW9MBEoyNxWdAFNjaT0hN3AFMcctUICp7PvBnzQQFCuB4VyytKEo70Bu
 uGkMk90z37sES21By/Ji4Z4vaHwzZ/NNPNARZlOXGb2KP0qdZE7zecWruoUf8hDeIpfAO6S5w4B
 quDC3ziuTumKbhWthO5FrWnhv7fCKifwnzmFlfpWEAyVc16n4hKtCC407dvaghixfC4gsk/LiwX
 eGtFYS42XsbFKBHSxgk2L2FK5RgLaw46bTVdKBRgFvJhxbYyqEuF65TMhZ3Z1kT0xOaRHbyIYOz
 XeA9ws20HZrwOkoC8o/Qp5EBClRfCEcLSCzcYyC/8lW0gtBOpiFkD1EG2NIPn4oGUnsorkkhinI
 8ckErcMK/MxeS7UtZmw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX6suOcyrAA5Zn
 oKledobt9bpWN8VvAiyNtwWTNJKlTNil9XGDMImIXgsT2fHFn3q76DYmjsRwXCNPGS77lvCwEEJ
 4zbWGrsmJB3VRdVTsd+Y/a5d3NAll1c=
X-Authority-Analysis: v=2.4 cv=OLayTiaB c=1 sm=1 tr=0 ts=6ae5702e cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=NCWKwCw8Xy9Og0ibBRsL:22 a=VwQbUJbxAAAA:8 a=MvuuwTCpAAAA:8 a=Q-fNiiVtAAAA:8
 a=Ep5skU6GpA05FKZfv_IA:9 a=QEXdDO2ut3YA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310017

This series adds cxiverbs, an RDMA driver for the HPE Slingshot Cassini
NIC. It exposes the NIC through the verbs API using the UET reliable
unconnected (RU) queue pair type from the UET RDMA core series.

cxiverbs does not drive the hardware itself. It is an auxiliary bus
client of the cxi-ss1 Cassini core driver and does everything through
that driver's exported CXI interface.

Patches 1-3 extend the RDMA core:

 - read selected counters, with per-item timestamps, through the
   COUNTERS object, so that a monitor can read a few of the NIC's
   thousands of telemetry values
 - allow UET jobs without an address table. Cassini transmit commands
   carry the destination fabric address directly and the hardware has
   no programmable peer-address table equivalent to the UET job table.
   This relaxes a rule in the UET core series and needs agreement from
   its authors; the commit message gives the hardware reasons.
 - add the Slingshot node type, transport, port capability and a
   driver-owned GID type that carries the 20-bit NID of the port

Patches 4-11 add the driver:

 - the user space ABI is built around explicit resource ownership:
   the CXI service, LNI (logical network interface) and PID are
   allocated explicitly through private uverbs methods instead of as a
   side effect of opening the device
 - VNI-isolated RU queue pairs, native memory registration, services,
   jobs, communication profiles, command and event queues, counting
   triggers, and NIC telemetry read through the counters extension

Dependencies
------------

This series depends on:

 - the Cassini NIC driver series for net-next,
   net: hpe: add HPE Slingshot NIC drivers
   https://lore.kernel.org/netdev/20261030-cxi-netdev-submission-v1-0-8c2c391cc283@hpe.com/
 - the UET RDMA core series
   RDMA/core: Ultra Ethernet transport verbs
   https://lore.kernel.org/linux-rdma/20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com/T/#t

The upcoming cxiverbs rdma-core provider pull request will depend on
this series.

Known open issues
-----------------

Every patch with a known unresolved issue says so in its commit
message. In summary:

 - SR-IOV: patches 9 and 10 carry virtual-function code from an older,
   incomplete version of the Cassini SR-IOV support. V2 will include the
   updated SR-IOV implementation, so please ignore issues in the VF
   paths for now.
 - Patch 9: on a physical function cxi_eq_free() cannot fail. On a
   virtual function it fails if the PF mailbox is unreachable. If that
   happens while the file is closed or the device is removed, the RDMA
   core drops the EQ object without native cleanup, so the VF EQ and its
   references leak. Explicit EQ destroys are retried. This will be fixed
   with the SR-IOV update in V2.

checkpatch
----------

Patches 1-3, 10 and 11 are checkpatch --strict clean. Patches 4-9 still
report CHECK-level items only (157 in total, mostly
PARENTHESIS_ALIGNMENT and OPEN_ENDED_LINE); each patch lists them. This
code is also maintained in internal HPE repositories, so these fixes
need coordination with those repositories and will be made in V2.

Review and testing
------------------

Before posting, the series was reviewed with the Sashiko AI code
review tool and checkpatch. All valid findings are fixed, except the
open items listed above.

Tool use: GitHub Copilot, an AI coding assistant, was used under our
direction to write many of the review fixes, to fold them into these
patches, to write commit messages and to run the build and hardware
tests. Every change was reviewed by the submitter, who takes
responsibility for it as for any other patch.

 - every patch builds incrementally, without compiler warnings, on top
   of the two series it depends on, with an x86_64 configuration that
   enables the driver
 - with this series, the netdev series and the rdma-core provider,
   booted on two Cassini 2 x86_64 nodes, the complete stack
   passed a full test matrix on both nodes: the rdma-core Python suite
   (434 tests; tests that need features this device lacks are
   skipped), resource and VNI isolation tests in default and indexed
   addressing modes, including wrong-VNI rejection, privileged and
   unprivileged CSR access tests, and 36 two-node RU ping-pong and RMA
   traffic cases (polling and event modes) in each direction, 72 in
   total. Native NIC resource accounting was identical before and
   after the traffic, no verbs references remained, and the kernel
   logs had no WARN, BUG or oops reports and no module load errors.
   The only later change is in the netdev series (cxi-eth hardware
   timestamp configuration), which was tested separately on hardware.
 - targeted user space models of the functions changed by the review
   fixes pass under AddressSanitizer and UndefinedBehaviorSanitizer.

Co-developed by Mamila Santosh and Iraimani P, as shown by the trailers
on each patch.

Doug Ledford (11):
  RDMA/core: read selected counters with timestamps
  RDMA/core: allow jobs without an address table
  RDMA/core: add Slingshot identifiers and driver-owned GIDs
  RDMA/cxi: add the native ABI and resource definitions
  RDMA/cxi: add the auxiliary device and driver ops
  RDMA/cxi: add explicit context LNI and PID lifetimes
  RDMA/cxi: add VNI-isolated queue pairs
  RDMA/cxi: add native memory registration
  RDMA/cxi: add services jobs profiles queues and counting triggers
  RDMA/cxi: read the NIC telemetry through counters
  RDMA/cxi: wire the driver into the build

 25 files changed, 5696 insertions(+), 7 deletions(-)

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
Doug Ledford (11):
      RDMA/core: read selected counters with timestamps
      RDMA/core: allow jobs without an address table
      RDMA/core: add Slingshot identifiers and driver-owned GIDs
      RDMA/cxi: add the native ABI and resource definitions
      RDMA/cxi: add the auxiliary device and driver ops
      RDMA/cxi: add explicit context LNI and PID lifetimes
      RDMA/cxi: add VNI-isolated queue pairs
      RDMA/cxi: add native memory registration
      RDMA/cxi: add services jobs profiles queues and counting triggers
      RDMA/cxi: read the NIC telemetry through counters
      RDMA/cxi: wire the driver into the build

 MAINTAINERS                                        |    9 +-
 drivers/infiniband/Kconfig                         |    1 +
 drivers/infiniband/core/cache.c                    |    3 +
 drivers/infiniband/core/device.c                   |    1 +
 drivers/infiniband/core/nldev.c                    |    3 +
 drivers/infiniband/core/roce_gid_mgmt.c            |    3 +
 drivers/infiniband/core/sysfs.c                    |    2 +
 .../infiniband/core/uverbs_std_types_counters.c    |   68 +-
 drivers/infiniband/core/uverbs_std_types_job.c     |    3 +-
 drivers/infiniband/core/verbs.c                    |    2 +
 drivers/infiniband/hw/Makefile                     |    1 +
 drivers/infiniband/hw/cxi/Kconfig                  |   11 +
 drivers/infiniband/hw/cxi/Makefile                 |    5 +
 drivers/infiniband/hw/cxi/cxiverbs.h               |  443 +++++
 drivers/infiniband/hw/cxi/cxiverbs_counters.c      |   38 +
 drivers/infiniband/hw/cxi/cxiverbs_ct.c            | 1906 ++++++++++++++++++++
 drivers/infiniband/hw/cxi/cxiverbs_drv.c           |  270 +++
 drivers/infiniband/hw/cxi/cxiverbs_main.c          | 1105 ++++++++++++
 drivers/infiniband/hw/cxi/cxiverbs_mr.c            |  192 ++
 drivers/infiniband/hw/cxi/cxiverbs_qp.c            |  949 ++++++++++
 include/rdma/ib_verbs.h                            |   25 +
 include/uapi/rdma/cxiverbs-abi.h                   |  658 +++++++
 include/uapi/rdma/ib_user_ioctl_cmds.h             |    2 +
 include/uapi/rdma/ib_user_ioctl_verbs.h            |    2 +
 include/uapi/rdma/rdma_netlink.h                   |    1 +
 25 files changed, 5696 insertions(+), 7 deletions(-)
---
base-commit: 306a2f8432f516069b2e673de7a07043132c034f
change-id: 20261030-cxi-for-next-8f50ba2bd59f

Best regards,
--  
Doug Ledford <doug.ledford@hpe.com>

