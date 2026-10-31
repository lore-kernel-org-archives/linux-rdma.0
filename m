Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421396;
	b=rVbjVzX+09EBhAZxD9krjBKA0qtr5Pox66wLwOt6F5tYl5tetsIHbwQ8qj5zXxJBZzER
	 pQgk/oUyzQM1gqvtqIj/LC0hgZApNUyol3uq+OQ86+BMlH8b9UWFLPXmawPRSMKsxMRYv
	 2og7ks8WLKSVC4j571JvqUFE3YdsPF2rRgL+9Jw2lV/LRGk6wQXVVBti5IbOKJPD2L2+3
	 tSTQuALuFvLafu4QfQqaxpEKyl56XEgeefXAn3EBluXvIF8qJaibQuICRQWfhNl4cNm0S
	 EP5pwwqZPZ2LwWPbiXDSQz0zB57/iUi/nxFKZISy09Ytfe1Our37qPJeXMQrmqH+OOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421396;
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
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=fp7WbG/55SqZnBaNriWIekJNe0kLamgPy17aQqk1ScA=;
	b=wNWlNl7b9SnTaUMDbdIxIKhAHL7r3bI0lpJn94F8cPdueqCqZ9QueWF4Ntp8JjTeIX5e
	 O4WT9a23udW5wb3UuqDDeVSiSVhaty92Z+g/eUht6mim0zoqxWTtV/T1TtC0m2v3EUvw+
	 katSeqMEDMrtmBFFGO5UXHmoEbNDekWI9hIqgZELcpDrbKSNEe5I06Ukm7quxZrC/fhHp
	 73bAtdWcwPIfpZzSF6XGZT5yLGkY9iEptab9qgFsr0ERRwbzCSqpRXNSywaL9Gd3ofh+n
	 1aZXWgmBkvn7080nSv9QIC+6tEXyKCOnwQRJfnH3D5a8F+xrok4sR5ZgORd2vjS7HvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=Wf5xV9Xf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF6606A331;
	Sat, 31 Oct 2026 04:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76BF6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=Wf5xV9Xf
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V3XP6C3021152;
	Sat, 31 Oct 2026 04:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=fp
	7WbG/55SqZnBaNriWIekJNe0kLamgPy17aQqk1ScA=; b=Wf5xV9Xf888vPNqxGT
	04wfKQHWwsxQXpWkOJM7MOyHLk18kFCFI3yHVezxHT6wiEYdTg8Gxl3T2wsEabDo
	p86kMLmgx15LPdU6QWR4Wb9NWNj1E53gkdk6pCoI79kUfFb7pf+J5DilmiyhugH3
	2NDgA+gXuRjP+8jND9X/2c15kiq32RPdTRvBeztgxE7GPPo1wlGz5TwVRMXdqshU
	9Whl3mIESpX3sFmpC9auzfrfOMdb42wrT499z36VHLwvSPtvYjwbIOFukALiKMuG
	CFuMO2wEoLPKJiYYI8TACA47a0DhwVZ2uAC4k8dXuVRtPkf5jXTbqo3XqFmexj0j
	cA1Q==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4hn8hfgdga-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:23 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 8B084D29F;
	Sat, 31 Oct 2026 04:36:23 +0000 (UTC)
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:23 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:23 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:23 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPnW48ajejXL9BL+cQESDUi8bm7rBFxYJHf6x18iwHu+GBS3wRTpkSCqRFXYbrW8YAbl6DmPkAoKtjt8j+9fem4zfsicM/EPXNh3IzJ/YvnFozwzR0pZHmZWI4zf3Eu5k5SpVU/BDLSNZEvDZaphQO16tK4FD0+IEdMpl2gfXftTpJWjROCG+8myzDySItpvkubJPz8eHPQRHZXrlaj0gU3/l+jB1Nb3xKJIdTIydlZucVdQLyCx9N/fDsgpbv3Lvkj+l/r+PqU44uuxxTm0AhxtlEM/kNkjmKiK9yUoqVk/bosd7Z0bpDPNYsOMVoCaSMa0XwI5NcF5ymAcRxV71A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fp7WbG/55SqZnBaNriWIekJNe0kLamgPy17aQqk1ScA=;
 b=UDUFq3+xk2hTEO37IyukjTSQ+m5msPBVU/PHUXaCb9Ij+A7b2D/YeBP3RT0ORCibquSl4HCorSYM24RyeH4UYCWF9Urnpy+vwljVZJz8ybharV/e+5xX8TAMcfRp3mjeR05S68qjLwqgAQzMkqc60MWI9pHGf8Yfvbb0QW7v0/jHweGTE/BFV7dLm58b+ekW25poHX0DJVGUYeEaPWGrDMfjTCIRTI+Scnl7op1m8Wg0r6/DATbCDi6qUNojPoM2rIOD5sqC4iQd4bUDo3WoSGp09yQbZSr66utYem4DfAFYSaCg6PJ+s18UBlpKKedSc+dJqt+Gc4hfcBPLLxfUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:15 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:15 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:36 -0700
Subject: [PATCH 08/11] RDMA/cxi: add native memory registration
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-cxi-for-next-v1-8-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0111.namprd11.prod.outlook.com
 (2603:10b6:806:d1::26) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: e284d2b9-895e-4a73-8759-08df37087fb9
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|18002099003|22082099003|56012099006|261021121427099003|261022105027099003|261022113327099003|261026140227099003|261026121527099003|261028144727099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: NQ6bHfBEyY+XeeotZ6O7mNN6zHH3tk6sB9yFFAc/HLtdlQqo4BcMckSgmEumPLGBLMmbnpVVfa+fmbXAtapMFDcFAi8Bvmz+oMkKujJmGJ+B8//wxntWb57ecfHCV5Lk+wdC+/lJ39+fvHPB1epYQpma0FvFti9uZ/RHCXI6IGf6Beb8CNH2CiDc5NpGvkmcFU/9HANXlRpWVWcGgG7A5+JGfwHdNxoxishvYAG4+6EO/RTdYf54R0gVmmTrrux4onLFEtR+6el+7JLZ48A1CtWze+QOSKyxWfaTgpURl0Dn+LwCCJFaK43dWZx9ZYJQhc4OO+FLiksjyLGi1/RWIv0AlxxR5E67FishVGS7CQyJo8KG71E0avX1P2d29re9xE/pCqRP0fv45964/rOMei34YHSZG2VjYNtZfB94r9w1C8GduCgaY5SXybXAapeT+tZ2nslxFP8Kgjt9VGg81y/TZCRLekgT2hDWNJ8nRMEKBGOe875mV6W74nGOC8RYdBEPDotMmSAvIy3AjsVjbNDsgh5YDKSlxSjLww1b8RX0On/jRc6PqEQH/w7yanbnApvn9JIdX6GVsRfIcm9ctv4BaGRxOrdFzh4VA5XO6uW7mbVrY79HGWH6pM3JU5z9t3l3AjWURYCbuAMREkm+hfSNcDh54VFIWB0o3MD6Ubc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(18002099003)(22082099003)(56012099006)(261021121427099003)(261022105027099003)(261022113327099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2w2akh0VHNjbjl0WjZMd3NzTXRiZFNyOEszR3g4S1h1RmZsUHVkQVhiNGZj?=
 =?utf-8?B?VUJ3WXBTaUVxVFBnbStpSUNvaXFSOGsyL2NBNU5Bd0QwM0o3ZjhIdW5GMVdK?=
 =?utf-8?B?dmduUnMvVXk5bGk4SXNabkxrdDNEaEswRXZ4dUhVeWYyNzVFc0NNcjJtRFA4?=
 =?utf-8?B?dnpNSUdUUjM4dEtwalZ1RE51WHNRQUlSOTYxaTBGL2pHWnFaTGJleUNkbkx4?=
 =?utf-8?B?SDl2ckZwM3dCVklIdm5DdTZxVmp5S3RBem42UVIvMDZRVUxZbzFjRXFTb1Vn?=
 =?utf-8?B?NXhqQ0tqQlFlV1lyOFRaSEx4VXZwSzJ6MlpoQUVoUm5MQmV2ZDNHT0xXQ3ov?=
 =?utf-8?B?VElwaGxZK3hodnFFT1pCYWE2S2taMTdZdEY0TjV3NjFtaktsTnV1a29CNXhZ?=
 =?utf-8?B?eVZ0RVZ4eUJmTzI1WnFlYWsrQXAxUm1GYTRCRzM5eWRBSzlXNVNnbXJCMSto?=
 =?utf-8?B?MGw4Y2FuVllQMTVpRzBBUzBhSVdHaDZTOTVjNDVaK2F6SDdwRkVGbGhhWUF3?=
 =?utf-8?B?QkNCNnBBMHdUYnhVcnM5bXdINHQ3TDVJemVyeUxuc0NaRnVtZ1pQemxMLzZJ?=
 =?utf-8?B?bEpkV3NOdUx0Y3lNWWJkN1UrTk9ZYi9NVEFML0xQZUtRRE91ZE4yTlFFaHZD?=
 =?utf-8?B?aXMrQ3BudUZCL1QvZ0NELy9qaVA4MVl4S3I2eHZNSDdOQWYxd2Q3ZVJiQzhP?=
 =?utf-8?B?MnN1K1A0eE9ObkRSdU0xSmRWQ1pTMWpKeDA5Rng2U0J6LzhYR0l5eFVhSVlo?=
 =?utf-8?B?aDh5TTJjQ3FhOUFWaXYzL1A3blNwS2RGcVhqWEZobXBuWmQ1UWVrWWVPUFo1?=
 =?utf-8?B?Wmd0bFo1NG13U2pibWxzbHptdXBUZTBCVm04V2Z1bm9McHdHTXZsUkJVRExN?=
 =?utf-8?B?U0NxbStkdjhEckRJVVhIbkJQMDYzbjJmVzNJTUFORGc0eFcyMnNhN0tPYk9y?=
 =?utf-8?B?QVlpV1hlVHJKRFBoREZBTFZiVERZWjFYMTMzNGZ0aFNWUWpoaWo3bkNCczIy?=
 =?utf-8?B?ZDZmM1k1akdicUUrNkx3RW1BalRFbTB1OTR0SDFYUlllOHh1b0N4OFJRL3ZW?=
 =?utf-8?B?TGpZQzhjNXU3ZmswL3IrL2VqSlRmQ0FoK3BTTnBrYXozeGg5Zkp3QWdPZ29n?=
 =?utf-8?B?N0ZzYTRHT1drcUd6Q0tjQ3NkYmh3N2hLSEszWDhoMVpPWFlzd2pkMW5YQWRw?=
 =?utf-8?B?VFRoc0NLdXgyL2tFQlRmYmpHYitaVytsZnkyNEVSOU4vcWtKMEpXbGJaYkR3?=
 =?utf-8?B?UHBGSHdoc21ic0dwaW1WUGVCZG1MZUpoaEdGTE0yMTIvVkw2MjhEbVRhUEIy?=
 =?utf-8?B?OGxhcWZ4OFhzWm1WcDFTaGEycC9ZaU1TRVVHOTAyRTVOS1crcXBaS0dWYnhC?=
 =?utf-8?B?TzdwL1dMZEhYbDF5TkNhV3FIZy9rWnlCZlVSYUg5ZmROM2duTXVjSlF5djFO?=
 =?utf-8?B?RW5HckkxLzdCeTZHaFRwWnh3bmR1K1hGbEo2TXUxNWtDWUo0T2kvcUdRS1JZ?=
 =?utf-8?B?R245dXJMR1dhVlhPazJtdWFmWklCakNqaDdrUENqSi9oOEkvMzVGU2YyOGU4?=
 =?utf-8?B?c05LVFZaNmR3UnB6Znkyb3lXdnJGZVlLSzdaUmQvZGNZU3JwT00vcWVObGEw?=
 =?utf-8?B?WXo1aEZoUjhjNWtaR1JYYTVBS1BjRkdSNS8wYlBRNm1mcGdFVElyaXVXM05t?=
 =?utf-8?B?ZWxzTkt6QXZZeUVleHNmemREZzh2enpFaEg2cmVXb3JiRU94Z1RhTlNrbHVv?=
 =?utf-8?B?UHhRNlpqazlNSUMyTDR4TVhBVkdESnZsTlgvYVg0R2hhZXYyWmNPcDEzeXJ4?=
 =?utf-8?B?a1IyZE15cVBDRElCOXR4MzFTVDY3VmJjL3Znck9GT1UzYW5oN3cvdWpaS2lH?=
 =?utf-8?B?UDVxaXJITm9rQmxxNS9ncFdrbGU4VjFMaDRsZmdrUWx1dWRPUEtLR091ZTBD?=
 =?utf-8?B?NWR6ZjBONWY4bVBzc2VwN0RldkZDWENTcVpQWnpEdzRXdUFOL1d6c1hibXBy?=
 =?utf-8?B?cVhSTmFUSHUvTWorb3duTUxLRHZoYWF6QkpVYzRMSXI0S2hwV2k2QWlVOXJL?=
 =?utf-8?B?eElFL2lMdDkxQW92MlNtQzhMTE1MRlUyTmQvRysrTy92T1haVW95SHU0ZlNF?=
 =?utf-8?B?N1QrVkc5S0RrU2tPcmZudXJmM3p6aTNEVC9DSittbCsxbFMrVGt2V0Q3dURu?=
 =?utf-8?B?YVRsYmVwUTVpaGg2Ty9kYlV0NlFzZ3FqVGROTldNMENkcmxOTHFYZnc0c1ox?=
 =?utf-8?B?NXphbkVCWFFFQ3FlSis2NFFDK01qVnVKMytJWEpYakdiOWdjSmE0SDRKTWF4?=
 =?utf-8?B?T1FONEgweEJPdy9QRzBRcGNWdk9GR0YwcVdvUkNGY1p5RXhKQWVUZz09?=
X-Exchange-RoutingPolicyChecked: ikAdlUpJmiHlDDIqqWPg+RMaiyhsb6I28t5IMICSrR4w+58h41IYO6Z+Zkq85B5vlcpWDTy9e3/EjDkSsi7IWBHhUvnpb4OptwDdS+Kty2cxjC0N+DGu+lhReeyi2SVXVWCGH/5SYFhh2+vuvkYw9jBoPtktBliwEzOt3+Gt1Dm0LrUaAFtFz7Z0p9cww6Q7ToBguqXHqmNptPJCcwvfF3BLeV5WyPeKcs1VtaSGLuQjLcrGovc/4wocdgtS/ZTRwpdr3LlMxOmHWm0xcfmhRo4mdiscz5zXV8tKmVPVjrMpE5aS/I6Ojm4ge5mM5S7m8xGxwTsMYkftdoOYRwDbjA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e284d2b9-895e-4a73-8759-08df37087fb9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:15.3481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mf53nxP60sVxJNSS28CfLE1CnefTmc3ioCtAFfDZP3ZbibYuk5SH8OSZ/FXj8vkYVKBQiePI8yX0aOYE/kDESA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=e7ST2qp/ c=1 sm=1 tr=0 ts=6ae57047 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=6_mrDcixewTG61oOsKN3:22 a=MvuuwTCpAAAA:8 a=1Tp-y2fT29_y9-hhnrwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LRg1dkR_S5iK9o1KnGnVVJ782YpKzLA4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX0G7SIcZRwGPt
 6yJ51+328ckNt/OGDfj/k9vDOw8BMW3O5F6SZRA2/jc7b0Tf1c/t6gmk3kqHLeRRBDVHk8lcM3c
 h72NNgEAOXC5mVDPCNMXhWDYsej8/eX3d9M7O2qsrN877v0HpNcwLzIRgvV9havMgsFu9mo2Dke
 H/92r2+kNDis/p8ul2cg/7p3lDEaksZLAiUoyWfM3Z2wo0CwgXYF9/KlNjBQpgf+iRbmB/nv51D
 97LfD5Il3xUQcjNAFjLpmcFZWOzB2/F61U1DLOlEC62PHZ0OgCz7oYV/FJzNpzKDfSRdeSYBDpq
 oXXqsdJsoQYQ2tY9oUGIlRYMDy4Kp6Eyit+K+6M50jNbhaPI5VlGDnBBgYkXtULy4iBHUQSuAo8
 AjwhZVp3/ZEGcrgU1iuElURetEM7hictfu8bv0yi2sUcTFgvmnEH2KMxYohMiQx/Yxv0DVwhN/P
 ezzLdpiP0MALyFo+PEw==
X-Proofpoint-GUID: LRg1dkR_S5iK9o1KnGnVVJ782YpKzLA4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX1te8tkEV1fTT
 yOd/OA0YSTqb5CrZiYsJmmjrfs7fTBnPZZTyHeR+FcaNZWctPQe8XDQ4hQNtNOHaOiOqVWlt8uN
 fYrRtfd3UFS44zgi8oq2eKUl2XRJ5F8=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Add memory region registration on top of the core driver's pinned
mapping and its memory descriptors.  A registration returns, with the
usual lkey/rkey, the native mapping description (VA, IOVA, length,
page and huge page shift, descriptor ID and LAC) so the user space
provider can address the region without a second query.

Remote keys have 48 significant bits: a requested key wider than that
is rejected with EOPNOTSUPP rather than truncated.

Responses use ib_respond_udata().

checkpatch --strict (100 columns) still reports the following in this
patch. They need coordination with the internal repositories this code
is maintained in and will be fixed in V2:
- CHECK: PARENTHESIS_ALIGNMENT (1)

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs_mr.c | 192 ++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs_mr.c b/drivers/infiniband/hw/cxi/cxiverbs_mr.c
new file mode 100644
index 000000000000..97ca5f9a7bb1
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs_mr.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CXI InfiniBand RDMA driver — Memory Registration (Phase 2).
+ * Copyright 2025 Hewlett Packard Enterprise Development LP
+ *
+ * Maps user memory into the CXI ATU (Address Translation Unit).
+ *
+ * Key design points
+ * -----------------
+ * lkey = low 32 bits of (md->id << 3) | lac
+ *   The LAC (Local Address Context) is the hardware protection domain
+ *   for local DMA.  md->id is the ATU MD index.
+ *
+ * rkey = random 32-bit token
+ *   Used as match_bits in the portal target LE for RDMA WRITE/READ.
+ *   The remote initiator must present this token for protected access.
+ *
+ * ODP (On-Demand Paging):
+ *   IB_ACCESS_ON_DEMAND selects native ATS/PRS mapping instead of pinning.
+ *   The native ATS/PASID/HMM paths own invalidation and notifier lifetimes.
+ *   The verbs provider must not install a second notifier or clear native
+ *   mappings from an MMU callback.
+ */
+
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/mm.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_umem.h>
+
+#include "cxiverbs.h"
+
+/* =======================================================================
+ * reg_user_mr
+ * =======================================================================
+ */
+
+struct ib_mr *cxiverbs_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
+				  u64 iova, int access,
+				  struct ib_dmah *dmah,
+				  struct ib_udata *udata)
+{
+	struct cxiverbs_ucontext *uctxt;
+	struct cxiverbs_pd *pd = to_cxiverbs_pd(ibpd);
+	struct cxi_ibv_reg_mr_resp resp = {};
+	struct cxi_ibv_reg_mr cmd = {};
+	struct cxiverbs_mr *mr;
+	bool is_odp   = !!(access & IB_ACCESS_ON_DEMAND);
+	u32 cxi_flags = CXI_MAP_USER_ADDR;
+	int ret;
+
+	if (!ibpd->uobject)
+		return ERR_PTR(-EOPNOTSUPP);
+	uctxt = to_cxiverbs_ucontext(ibpd->uobject->context);
+
+	if (!pd->lni_ref)
+		return ERR_PTR(-EINVAL);
+	if (udata && udata->inlen >= sizeof(cmd)) {
+		ret = ib_copy_from_udata(&cmd, udata, sizeof(cmd));
+		if (ret)
+			return ERR_PTR(ret);
+		if (cmd.flags & ~(CXI_REG_MR_USER_RKEY | CXI_REG_MR_NATIVE_MAP))
+			return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	mr = kzalloc_obj(*mr);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+	mr->cadev = uctxt->cadev;
+
+	if (is_odp) {
+		/* ATS mode: PCIe Address Translation Services / Page Request */
+		cxi_flags |= CXI_MAP_ATS;
+	} else {
+		/* Pin-based: pages locked in RAM for the MR lifetime */
+		cxi_flags |= CXI_MAP_PIN;
+	}
+
+	if (access & (IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE))
+		cxi_flags |= CXI_MAP_WRITE;
+	/* Local read is always needed for SGLs used in post_send */
+	cxi_flags |= CXI_MAP_READ;
+	if (cmd.flags & CXI_REG_MR_NATIVE_MAP) {
+		if (is_odp || !(cmd.native_flags & CXI_MAP_PIN) ||
+		    !(cmd.native_flags & (CXI_MAP_READ | CXI_MAP_WRITE)) ||
+		    (cmd.native_flags & ~(CXI_MAP_PIN | CXI_MAP_READ |
+				  CXI_MAP_WRITE | CXI_MAP_ALLOC_MD))) {
+			ret = -EOPNOTSUPP;
+			goto err_free_mr;
+		}
+		cxi_flags = CXI_MAP_USER_ADDR | cmd.native_flags;
+	}
+
+	/* Map into the ATU under the context's JobID-anchored LNI. */
+	mr->md = uctxt->cadev->cxi_map(pd->lni_ref->lni,
+				     (uintptr_t)start, length,
+					 cxi_flags, NULL);
+	if (IS_ERR(mr->md)) {
+		ret = PTR_ERR(mr->md);
+		mr->md = NULL;
+		goto err_free_mr;
+	}
+
+	mr->lac = mr->md->lac;
+
+	/*
+	 * The narrow keys alias the low word of these, so a caller limited to
+	 * 32 bits gets a usable truncation as long as the descriptor index
+	 * stays under 2^29.
+	 */
+	mr->ibmr.lkey64 = ((u64)mr->lac & CXI_LKEY64_LAC_MASK) |
+			  (((u64)mr->md->id & CXI_LKEY64_MD_MASK) <<
+			   CXI_LKEY64_MD_SHIFT);
+	/*
+	 * Bit 31 keeps the *narrow* key non-zero, so an rkey stays distinct
+	 * from the zero match value SEND uses whether a peer presents the full
+	 * key or only its low word.
+	 */
+	mr->ibmr.rkey64 = (get_random_u64() & CXI_RKEY_MAX) | BIT_ULL(31);
+
+	if (udata && udata->inlen >= sizeof(cmd)) {
+		ret = ib_copy_from_udata(&cmd, udata, sizeof(cmd));
+		if (ret)
+			goto err_unmap;
+
+		/* Taken as given: a narrow value makes a narrow region. */
+		if (cmd.flags & CXI_REG_MR_USER_RKEY) {
+			if (cmd.rkey64 > CXI_RKEY_MAX) {
+				ret = -EOPNOTSUPP;
+				goto err_unmap;
+			}
+			if (!cmd.rkey64) {
+				ret = -EINVAL;
+				goto err_unmap;
+			}
+			mr->ibmr.rkey64 = cmd.rkey64;
+		}
+	}
+	mr->ibmr.lkey = (u32)mr->ibmr.lkey64;
+	mr->ibmr.rkey = (u32)mr->ibmr.rkey64;
+	mr->ibmr.length = length;
+	mr->ibmr.iova   = iova ? iova : start;
+
+	resp.lkey64 = mr->ibmr.lkey64;
+	resp.rkey64 = mr->ibmr.rkey64;
+	resp.iova = CXI_VA_TO_IOVA(mr->md, start);
+	resp.info.va = mr->md->va;
+	resp.info.iova = mr->md->iova;
+	resp.info.length = mr->md->len;
+	resp.info.page_shift = mr->md->page_shift;
+	resp.info.huge_shift = mr->md->huge_shift;
+	resp.info.id = mr->md->id;
+	resp.info.lac = mr->md->lac;
+
+	if (udata) {
+		ret = ib_respond_udata(udata, resp);
+		if (ret)
+			goto err_unmap;
+	}
+
+	return &mr->ibmr;
+
+err_unmap:
+	uctxt->cadev->cxi_unmap(mr->md);
+err_free_mr:
+	kfree(mr);
+	return ERR_PTR(ret);
+}
+
+/* =======================================================================
+ * dereg_mr
+ * =======================================================================
+ */
+
+int cxiverbs_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
+{
+	struct cxiverbs_mr *mr = to_cxiverbs_mr(ibmr);
+	int ret;
+
+	if (atomic_read(&mr->native_users))
+		return -EBUSY;
+	if (mr->md) {
+		ret = mr->cadev->cxi_unmap(mr->md);
+		if (ret)
+			return ret;
+		mr->md = NULL;
+	}
+
+	kfree(mr);
+	return 0;
+}

-- 
2.56.0

