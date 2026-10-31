Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421387;
	b=xTxYVfFXLVVIdyLXXUMSVd/GF2tNuiPfRFzGJNYBZ+GnkutkcZI2v1ihmyB+Zz3uFiVO
	 BC2y8SGALjywl6RkXmxgHpk8qBuVYvrb12P2OVgG4ySql1ZsbhvzjJSbKeLg+8MrcEZse
	 bCp5FsSMEbaT6rbCNELvMUF4R/NVBNmifazuTo5PhyKAp8WJJBljWpUKF8zbnwOP0Oi9W
	 nIDhQseAhtIiqwvq5jSKWxVTff8kklRFRpaZrXPIc1T4R5lvDIN4bmOAW2qvTrkxvfbDA
	 eZtnP52dmdcUW7KLL/iRgzpv8VvT+CCccmabINO8sro/Ph8RLNJ8XE0eeM75LkWxriA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421387;
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=s5Alc3+XEyh+DJDZ7SEAa/bX7EK1Ft7uthUhk8QYARc=;
	b=1uuqu3pjfLN2q3tidnJRpKP7ngryMTxM46JCfkVSFaD2Uc1Psvxu9YhrkAn4bokw3SsR
	 Ls12SKd/NV0MMaYkmn1eGW+QGJWzgN/ZUJDI672/ERYJCoaIm1ZLpUfkypGYY0N/4gwe1
	 DkgCg/1IglLeazM3OEwFoAeu038bgT3ulFJe1wNAOWl7xGUQN2AW4ztAajTKflkXowE1/
	 +1TfxahnXaNcaCE7JhzPNlwuy61WwxK4KrPXl+Qth8ny34AB++6vo0BNbWlPUGIL9WLNA
	 E6pJFOZTzh6qyn3NRduqqnUvYw8xS3NhsBgjrPLINLbZxKblZtHwlh7iUoMcXuNpUoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=k6CbKjpA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB18606A329;
	Sat, 31 Oct 2026 04:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EB18606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=k6CbKjpA
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V1GgfI2581377;
	Sat, 31 Oct 2026 04:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=s5
	Alc3+XEyh+DJDZ7SEAa/bX7EK1Ft7uthUhk8QYARc=; b=k6CbKjpA0DgcwblD9D
	H8/dnE2kR/EB/e3iflHUrhD+2fSLXORaGNnV5+8e9RrZ6VE4QswkwlCzNdw9IvAW
	Ffs6zaRNjVuyr9rU5s67ROzCVc3tZfjsHw5TyqhMwRVCF/SWuR/xIqMCgrPeUfSO
	jEu0JRbAOd9/oAvtqeh/wfAe+XmYJ6eRjjcz3E7Zepf7ls9Sebd+A4HmWvDVUxT5
	99CoCiyMduT3j7OzXEdMFzutCZpb+utpWOwNphd4YPjD+wbvmtjSsTXz0E20QXrG
	EFdSeUOxIllJMwj+Liv84B7wigJe6dcehfOIsTU/D1VUbA6AokeeFNsY4uqRgzJU
	OVAA==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn6h89eb9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:22 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 6115BD2B8;
	Sat, 31 Oct 2026 04:36:22 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:22 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:16 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:15 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8GFN6W9czk4UaMqZjDQnPfykYSQbI8jY7y9H6QcIFycis5NnZj5kp/3a+Av0/s556BBn/b0dMMMKlovl5SIvzAAITDoeOYEdOLDHGL4WwBKzjNs5DAgPOEWXApTz/8mZrE2MdxO55uCS/iaxqX1QhRnY6lfpKPLM1ktar7jzfXT9djkf7eSKhylh/BWKep25Iv0ztcAP3tTdJ25lYVyKYADwcOSrsbzCpCYe5WuOok/u7oqtb1wNGwdvfln9F5sRCzMWMw/dZIE2myAY3m5GmV3OayZm+cG1E/8qnqNZYx8g7yceD/yWz7XJrQgExwrCkY7fvCQ3wcjaf2vszEbMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5Alc3+XEyh+DJDZ7SEAa/bX7EK1Ft7uthUhk8QYARc=;
 b=eLEgmBJ0n/AHXkaBnQ2F9nNkVKt+DDCaekFjAQgAdUMUJRZTa+gQfy8ysh+naIXbBUCdvjsrzloF0O17HgMP9JnxNP+XIHXkwM8fdHA5H0HBL6yupSsR3oEj7uaAV2HVW8Db7TnBXzIHYqUw3PlXx+RqnNNyBmic70PHY46SsDk1nuiiwNWLbtJEFJclATQFbrdgfvHnl0cDDxKNvKMITIDtukm84BINrcBsep/loD8tUamF4gjFHR0ZVyrgHf9/+bjsbq/+gIUKGyzBD8rbIIDR7PVtMIGuVvM1Av9r6W/rMsOCiCveVDOTGidaaXNuIE6yo08xp0Rj2l3OvFDIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:12 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:12 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:35 -0700
Subject: [PATCH 07/11] RDMA/cxi: add VNI-isolated queue pairs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-cxi-for-next-v1-7-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Mamila Santosh <santosh-kumar.mamila@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0098.namprd11.prod.outlook.com
 (2603:10b6:806:d1::13) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: d9e06039-63f4-4f82-e381-08df37087e13
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|3023799007|56012099006|261021121427099003|5023799004|261021135927099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: IDUGRjp5d+tZgwFSPhlUimdn8S76qZ+IVleRdJcAMX8Hv9D6N9CmQxhREQnA/IV2wWU9jBuWKq7wtvuyLLNNfJU7cfPSdtfhjdKfAQ/yLj11Frg36DCj+HneESX9i3CnEsyStRbJPslAgnUjQw/R3hdSjRV/OA0yh3LzkL19ARGgsX3LbIcIeXm6By7B/Mbj3x6fKzVB94pwVUlKzpYQ0wJI6htIMpPvF94sTqMM4pGh7Wy+cRodYdKEIAj6hrCWmuHc9FB8oONrtxbcR4T+ZbR6n4D7rugPCFJzrC/ds+QZOfiMugtFERswmcANH2e7gBXVlu4bn8spMlDbqY6jBcHqGqkgmSMxt4JDYtFp6tjxoinTAgEiln0PlAdENTDn6gM0NwYtgHcfR57V220nVsRyH8b8KFOchlRnS99FJuGR0AD3z/nhhkX8XJw2wuVZBQcja29TbGnZqC57xc4ZE9Zrq5FVOVkuX1I1HsI1MWg36rD5LLu/A1kmZpOBm8PZI3q7TUGIKOKPMqAibLHpfQOQR4U73ODuAjD+CesR0K23K90AuT07rL0ZGyso7rsPvyAdZnSCJ6oYKZ1jJo3r0q1WXt62TJpN5blzATk9S28D4dkBKKCZqBLYRyxOUtm6Gpp5sUowYyOdqSPv1bEJiNuIM0GAXL0F7VMtWZ/uNwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(56012099006)(261021121427099003)(5023799004)(261021135927099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzluZzhhdjVTOGJwUnZDOE5JcDJacGJuN3NOMzJ5TUI1R1ZkQlBsSGxZOUE0?=
 =?utf-8?B?RmNtdVlnN1B0K1pnT0hUdGtTcFA2RXhyN2lSY3lyaURXb25GMVBXU1pIV20w?=
 =?utf-8?B?ZmNGSDFRRUJKa0JQUlE5Uk9ldkdIbHp3TmY5eUE4VXhBbjRpNVJVRWRsTUVr?=
 =?utf-8?B?VWJaaDJOZjUzai8zcVJvZVdwNkVLK0dMTWNVWTJJeEhlaStkdW9DUWdxU21h?=
 =?utf-8?B?QlkzYmtudWp0ZUtseE5UeHJtaUFxSWJVdmd3TEwrK21weCsxVEgzTlloQTR1?=
 =?utf-8?B?U0p4M1Z6OUU5UzMveEl4WExlSTBsaVBaYVBXUmUrQ05pZGxBMUVTNDM2bEZL?=
 =?utf-8?B?SDBleExFcFdBa21aYy9RazNEK0cwM3RYNUl4R2FMWGt5eDU2YTV5RXBmbVNj?=
 =?utf-8?B?MVowRkRJejVXV0JuMmtwNm5JUVIvaWdUUGlzZUQ1TDNYOEQ3OGZmc2t3VnFL?=
 =?utf-8?B?YkQ3eHkwbEpyRHRVVldrNEpyWE8ySWthYnhqaUlwRERpMi9HNWpQaXNEZW05?=
 =?utf-8?B?OHZOcVZhZzRuRThxMWZPcEc5NjRPQ2JmVHVwOGh0ZjdNVXJOQnZFZm42bCtD?=
 =?utf-8?B?QmhObUJidEdyaE9SY0ZCWWtFQStoOEVCNXcvc0lWT2xla0kzVUsvQW9rTVVk?=
 =?utf-8?B?bzcrTEJEQXp0TnJldGIyMFUrcWpwbEE0Si9JcWZSVVFHRW1RUVNVY1h6T1Rn?=
 =?utf-8?B?L2hMdnUvdlFmQ2NvUGpJUHZWS3ZNcjFnOTczNFpGL1puV3JOcTdiT0JWTDQ5?=
 =?utf-8?B?M09OV0ZqRVVraUNNQk81eElKZnlUbmVzRmhuQnIrUk8vT1VFTFZ1b0hrS3NE?=
 =?utf-8?B?STNFdnB5UXpBcklnOXJINVdIZlpxQXFZakV2OVF4L1hPTWVkUjhBMUhNQmNE?=
 =?utf-8?B?L3duTDhYNFhyNm82TzBiMzMyRXVWZnpCbThJejY0MWNXbU5VL0JQMDM4UEhi?=
 =?utf-8?B?Qk5QZVFzOUN3STRDRUM1VjRIV0FWN2pXVmVkaXRTTEtQSlViSGFzUVBiSmxF?=
 =?utf-8?B?WlVGYnJmNHRUN0tJNHZvZGZTWkdlSW5memsySnhYUTNvTE1lekNVa3RWUXpR?=
 =?utf-8?B?cW1kdU4wZzZSWDNTdGgrK0tpTlJlZG9WdldwWStHMnFHMHlJQmIyVVZrUnF4?=
 =?utf-8?B?M2l2VFBpT1N3Nnp4N3o3UGxOKy8zK3NXbG1RMjZKb3VMR2dTUkh1QlNic1FZ?=
 =?utf-8?B?TlRmZ3RIcVJwYzVha1p1d3d1dWc5VUdnUXBlaE1xbm9PRm5LOHdmcWNFU3NG?=
 =?utf-8?B?emM2TVowby9rK0Vzbm9paGl1VDZTT0R6a3dFc0hTV0VLNnF1MmhkYmJLYW41?=
 =?utf-8?B?dHp0d3JRdXZZRVMxcGorTWZ6QzJ3U29Zb1VQTGxjckxJbnFSK1d3MHMzbFpJ?=
 =?utf-8?B?UDl4NHlxdHNqKytVVis1NGp6eFlqVDV1bjJaZHhjTE9SOUE1SEl3N05nWHhj?=
 =?utf-8?B?WjNLSGJValhBQnQxeWZjSWR4WUVHWld5akVpYUF5SlFYeFVPWXNjVklLT1hs?=
 =?utf-8?B?S2xSa0RLTHhCTlFvTEpwUnpDYURkbmtCMkF1NlJPcjlBMVVYWXB1N0FRZ0Ns?=
 =?utf-8?B?VDJBdUFqZng5Z29RelhqZ0JxbDM4T1NhYUtPY1doWlVzQ0NaSTV6bzhDWTNB?=
 =?utf-8?B?ZVlBM2JaT1VUMXNPS0tCODl5RUVkYmNrVlJDSmVYVDVBZVVHMW8wYzRsWHpH?=
 =?utf-8?B?RHVibUhZc3lvZ1JEcFJidG1KdzB5aGc1N0ZrOEJGZmpIT3Q1Y25JTFJ4VEQ5?=
 =?utf-8?B?WStTZVJoWXZVVGFKczFyc3YwbFU4Y2VyT0N4TkozWGZQbWVtWWFOMW9wQ2VZ?=
 =?utf-8?B?RDBWM0d4NnduU1V1WnVqL05ubTk2NGdlbGZyQ0cwNm9lcHdtRXJFdnhNQzkv?=
 =?utf-8?B?QXpWeDFiM0M5VDAveE9VMGI3S1c3L3NsdVBUbGFzdnJDTGdBNTJoU2t0d2Zn?=
 =?utf-8?B?TzE2VlAwRGFjOFFHSlgyQzUvTVBZb1ZqTkJ3SCtlUXFKSFB2ZXZXNE9PZ2Vh?=
 =?utf-8?B?TFpwWFRSL1RzSmhvL1lwVndkRzNWREVhSHRHSDJXcER4bHFyL05uVVpUcm15?=
 =?utf-8?B?eEthV1pnbXRIQTFSV0RZUXZuSDZGM3ZDTkJzTU5WY0Y4NlZNMUlUc1ZWNFJE?=
 =?utf-8?B?V1kzb1pRUG01TkFFTW96Nkd0WjF0MkttMUtpRXE3RHE3UmxiNzZnbUlYMGZ3?=
 =?utf-8?B?MVBMRWM2VDdNWkZMSHRxMjh6MkRjRjI4ZzcraG8zVnRmcDZPei9rYTZGMGRs?=
 =?utf-8?B?N2hCRXh6WGpqZG8wOFUwSE96Z3NwV2JsZUtjSGJHOVhwY2FUa3k4SnRJaVZC?=
 =?utf-8?B?b1QxODZ0Vkx6cVJDN2tuZjlZQ1QrakptZUpEUmtOWGxxUWhqMHV1dz09?=
X-Exchange-RoutingPolicyChecked: bAV01WkhkF+BwDpg52TMpS+KtaVyRexdBW3irtWKrP6fX7eOkBwlMqZ9b+70KaT3sEND2LkWUnnCxi7+7Vn/3Ey9Tc8MeuXwIbw5WYg/2LMVYkf2l6f4XCTvTzPTN76/oovPZpcKCDlkt+tdIOfMDgzbqgDfsypXHtEVyTpcK0e/8thpPKy9agfvL510SSs2ztcgxEMcwckygnezBNafffXb9+jvyP1wfA9eerRngSjGV7FP+jYaL+Scon35TXkSjCeBNFxLAmeaKZANpEDUW/ymS8Jsb/z1jMrxyMQGvRwQ0sBdknIOaGDagQsW3v1RyUFD3q2N72xuKbBGWDXSEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e06039-63f4-4f82-e381-08df37087e13
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:12.5887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJdw12Ipxt4z26oMno7O5xa1eLsPB4+q+7DA9qt7v4SFvmkl6KIhEQW6B4GuKJz3GP5cD27B8FAyfjs9UV9+3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=bYL+w+PB c=1 sm=1 tr=0 ts=6ae57046 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=ay80y3fxfMS_JZZz1qJy:22 a=MvuuwTCpAAAA:8 a=V_vr726seYxFZbyj3qkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0Xp-MSCVIWdCbcroD5uIBo_dsh_FDx6a
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX7T8iSNOXU7yh
 nFDofdaJHGdSubgtDsPuDshFeBbAUhRmfxjWG8XCzSLt0ouw4L192fNn0wEjXZhhFMEefikaG9m
 tCjCveFoS9JxA1jUxBezf6SkkyFtYIM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX8oO7UB4oVZdl
 /i/fr71Nlci0rr0x2oMj3OefnQqvmXMEW8LB70qQQSmdcquTqpHgw4+S1AoEKBcn8kjWaeQ2Bdl
 ERMkKr1UHfTR8VwoMe2DPTxjhdl52MDp3EYTf1qv1W+NvbXf5ffppCDobUo3EM3zB8vURzW+qLz
 ycHcOGdXdYVM/zeFrjZAeD+DSRCz+YBJyDsTm9xuV+v34niYBP3q6s4CKu/ZmAJnEr3eD6FJKEX
 f8P5ufNyOfXNg1/l5L4FPm59UsoBz2amVCgj65494odoIQkcEIKPmLgc4rzasuVxv8DHbLlEu3H
 3AD7qXjDBURNF9U3KPqBGPGeikY0+YHlmZ9e++byPPfWKp6C86Bl5+NTOFlKo2uxKYMhHa4NXnA
 dvnX9lW81WYgoxsYFIxn3Ii8qo/VWAQs/78tol1rhOo86DxkMb/kPWIgwgtH7OzcunQqWHLziio
 7nN6vE1ia2gcrfeqNiQ==
X-Proofpoint-ORIG-GUID: 0Xp-MSCVIWdCbcroD5uIBo_dsh_FDx6a
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Add queue pairs for the RU transport.  A QP is a portal table entry
plus the command and event queues behind it, created in the INIT
state and enabled on the transition to RTR.  Messages are matched on
the packet VNI as well as the key, so two jobs sharing a NIC cannot
match each other's receive buffers or memory regions.  The VNI match
is enabled only on Cassini 2 with the default VNI matching selector;
other configurations are rejected.

modify_qp() follows the UET v2 flow: an RU QP is created ready to send
and the initial modify goes through the v2 path.

If copying the response to user space fails on INIT to RTR after the
PTE has been mapped, the PTE is unmapped and its map index reset.
Without that a retried transition mapped the PTE a second time and
leaked the first slot in the portal list.

Responses use ib_respond_udata().

checkpatch --strict (100 columns) still reports the following in this
patch. They need coordination with the internal repositories this code
is maintained in and will be fixed in V2:
- CHECK: PARENTHESIS_ALIGNMENT (6), PREFER_KERNEL_TYPES (1)

Co-developed-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Signed-off-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs_qp.c | 949 ++++++++++++++++++++++++++++++++
 1 file changed, 949 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs_qp.c b/drivers/infiniband/hw/cxi/cxiverbs_qp.c
new file mode 100644
index 000000000000..3875a5de0a98
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs_qp.c
@@ -0,0 +1,949 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CXI InfiniBand RDMA driver — Queue Pair lifecycle (Phase 4).
+ * Copyright 2025 Hewlett Packard Enterprise Development LP
+ *
+ * Each UEC/CXI Queue Pair allocates the following hardware resources:
+ *
+ *   cxi_domain   — VNI + PID  (fabric endpoint address)
+ *   cxi_cp       — Communication Profile (maps to LCID / traffic class)
+ *   cxi_cq (TXQ) — transmit command queue (initiator path)
+ *   cxi_cq (TGQ) — target command queue   (receive path)
+ *   cxi_pte      — Portal Table Entry     (receive matching)
+ *
+ * QPN encoding:
+ *   bit  31     : addr_mode (1 = absolute, 0 = job-relative)
+ *   bits [23:12]: Resource Index (PTE pid_offset within the PID slice)
+ *   bits [11:0] : PIDonFEP (process-endpoint address)
+ *
+ * QP state machine:
+ *   RESET  -> INIT  : validate parameters; allocate CXI resources
+ *   INIT   -> RTR   : map PTE + insert catch-all receive LE
+ *   RTR    -> RTS   : arm transmit queue
+ *   RTS/RTR -> ERROR: disable PTE and drain TXQ
+ *   any    -> RESET : free all sub-resources
+ */
+
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/random.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+
+#include "cxiverbs.h"
+
+/* Work request queue depth limits */
+#define CXI_MAX_SEND_WR    1024
+#define CXI_MAX_RECV_WR    1024
+#define CXI_MAX_SEND_SGE   1
+#define CXI_MAX_RECV_SGE   1
+#define CXI_MAX_INLINE     192   /* IDC fast-path maximum bytes */
+
+/* TXQ ring buffer entry count (each entry = C_CQ_CMD_SIZE = 64 bytes) */
+#define CXI_TXQ_DEFAULT_ENTRIES 512
+
+int cxiverbs_query_qp_semantics(struct ib_device *device,
+			       enum ib_qp_type type,
+			       struct ib_qp_semantics *sem)
+{
+	if (type != IB_QPT_RU)
+		return -EOPNOTSUPP;
+	memset(sem, 0, sizeof(*sem));
+	sem->comp_mask = IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER |
+		IB_UVERBS_QP_SEMANTICS_MASK_RAW |
+		IB_UVERBS_QP_SEMANTICS_MASK_WAR |
+		IB_UVERBS_QP_SEMANTICS_MASK_WAW |
+		IB_UVERBS_QP_SEMANTICS_MASK_PDU |
+		IB_UVERBS_QP_SEMANTICS_MASK_IMM |
+		IB_UVERBS_QP_SEMANTICS_MASK_USAGE;
+	sem->max_pdu = ib_mtu_enum_to_int(IB_MTU_4096);
+	sem->imm_data_size = 64;
+	sem->usage_flags = IB_UVERBS_QP_USAGE_IMM_DATA_RQ;
+	return 0;
+}
+
+/* =======================================================================
+ * Resource teardown helper
+ * =======================================================================
+ */
+
+struct cxiverbs_qp_resources {
+	refcount_t refs;
+	struct cxi_adev *cadev;
+	struct ib_pd *pd;
+	struct ib_cq *send_cq;
+	struct ib_cq *recv_cq;
+	struct cxi_domain *domain;
+	struct cxi_cp *cp;
+	struct cxi_cq *txq;
+	struct cxi_cq *tgq;
+	struct cxi_pte *pte;
+	int pt_map_index;
+	u32 ri;
+};
+
+static void cxiverbs_qp_resources_put(void *owner)
+{
+	struct cxiverbs_qp_resources *resources = owner;
+	struct cxi_adev *cadev = resources->cadev;
+	struct cxiverbs_pd *pd = to_cxiverbs_pd(resources->pd);
+
+	if (!refcount_dec_and_test(&resources->refs))
+		return;
+
+	cadev->pte_unmap(resources->pte, resources->domain,
+			 resources->pt_map_index);
+	cadev->cxi_pte_free(resources->pte);
+	cadev->cq_free(resources->tgq);
+	cadev->cq_free(resources->txq);
+	cadev->cp_free(resources->cp);
+	cadev->domain_free(resources->domain);
+	xa_erase(&pd->qpns, resources->ri);
+	atomic_dec(&resources->send_cq->usecnt);
+	if (resources->recv_cq)
+		atomic_dec(&resources->recv_cq->usecnt);
+	atomic_dec(&resources->pd->usecnt);
+	kfree(resources);
+}
+
+static struct cxiverbs_mmap_entry *
+cxiverbs_qp_mmap(struct cxiverbs_qp *qp, struct ib_ucontext *ibctx,
+		 bool is_io, phys_addr_t phys, struct page *first_page,
+		 size_t size, u64 *offset)
+{
+	struct cxiverbs_mmap_entry *entry;
+
+	refcount_inc(&qp->resources->refs);
+	entry = cxiverbs_mmap_entry_alloc_owned(ibctx, is_io, phys, first_page,
+						size, offset, qp->resources,
+						cxiverbs_qp_resources_put);
+	if (IS_ERR(entry))
+		cxiverbs_qp_resources_put(qp->resources);
+	return entry;
+}
+
+static void cxiverbs_qp_free_resources(struct cxiverbs_qp *qp)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(qp->ibqp.device);
+
+	/* Remove user mmap entries (they hold references) */
+	if (qp->tgq_db_mmap) {
+		rdma_user_mmap_entry_remove(&qp->tgq_db_mmap->rdma_entry);
+		qp->tgq_db_mmap = NULL;
+	}
+	if (qp->tgq_cmds_mmap) {
+		rdma_user_mmap_entry_remove(&qp->tgq_cmds_mmap->rdma_entry);
+		qp->tgq_cmds_mmap = NULL;
+	}
+	if (qp->txq_db_mmap) {
+		rdma_user_mmap_entry_remove(&qp->txq_db_mmap->rdma_entry);
+		qp->txq_db_mmap = NULL;
+	}
+	if (qp->txq_cmds_mmap) {
+		rdma_user_mmap_entry_remove(&qp->txq_cmds_mmap->rdma_entry);
+		qp->txq_cmds_mmap = NULL;
+	}
+
+	if (qp->resources) {
+		cxiverbs_qp_resources_put(qp->resources);
+		qp->resources = NULL;
+		qp->pte = NULL;
+		qp->tgq = NULL;
+		qp->txq = NULL;
+		qp->cp = NULL;
+		qp->domain = NULL;
+		qp->lni = NULL;
+		qp->identity_reserved = false;
+		return;
+	}
+
+	/* Unmap PTE from domain before freeing */
+	if (qp->pte) {
+		if (qp->pt_map_index >= 0 && qp->domain)
+			dev->cadev->pte_unmap(qp->pte, qp->domain,
+					      qp->pt_map_index);
+		dev->cadev->cxi_pte_free(qp->pte);
+		qp->pte = NULL;
+	}
+
+	if (qp->tgq) {
+		dev->cadev->cq_free(qp->tgq);
+		qp->tgq = NULL;
+	}
+	if (qp->txq) {
+		dev->cadev->cq_free(qp->txq);
+		qp->txq = NULL;
+	}
+	if (qp->cp) {
+		dev->cadev->cp_free(qp->cp);
+		qp->cp = NULL;
+	}
+	if (qp->domain) {
+		dev->cadev->domain_free(qp->domain);
+		qp->domain = NULL;
+	}
+	qp->lni = NULL;
+	if (qp->identity_reserved) {
+		struct cxiverbs_pd *pd = to_cxiverbs_pd(qp->ibqp.pd);
+
+		xa_erase(&pd->qpns, qp->ri);
+		qp->identity_reserved = false;
+	}
+}
+
+/* =======================================================================
+ * create_qp
+ * =======================================================================
+ */
+
+int cxiverbs_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
+		      struct ib_udata *udata)
+{
+	struct ib_pd *ibpd             = ibqp->pd;
+	struct cxiverbs_pd *pd;
+	struct cxiverbs_dev *dev;
+	struct cxiverbs_cq *send_cq;
+	struct cxiverbs_qp *qp           = to_cxiverbs_qp(ibqp);
+	struct cxi_ibv_create_qp_cmd cmd = {};
+	struct cxi_ibv_create_qp_resp resp = {};
+	struct cxi_cq_alloc_opts txq_opts = {};
+	struct cxi_cq_alloc_opts tgq_opts = {};
+	struct cxi_pt_alloc_opts pte_opts = {};
+	size_t txq_cmds_size;
+	struct page *txq_cmds_pages = NULL;
+	phys_addr_t txq_db_phys;
+	size_t txq_db_size;
+	size_t tgq_cmds_size;
+	struct page *tgq_cmds_pages = NULL;
+	phys_addr_t tgq_db_phys;
+	size_t tgq_db_size;
+	u32 requested_pid = init_attr->source_qpn & CXI_QPN_PID_MASK;
+	u32 requested_ri = FIELD_GET(CXI_QPN_RI_MASK, init_attr->source_qpn);
+	u32 requested_addr_mode = init_attr->source_qpn & CXI_QPN_ADDR_MODE_MASK;
+	u32 svc_id;
+	u32 resource_index;
+	u32 ri;
+	u32 tc = CXI_TC_BEST_EFFORT;
+	int pid;
+	int ret;
+	unsigned int pt_index;
+
+	if (!udata || !ibqp->uobject || !ibpd || !ibpd->uobject)
+		return -EOPNOTSUPP;
+
+	pd = to_cxiverbs_pd(ibpd);
+	dev = to_cxiverbs_dev(ibpd->device);
+	send_cq = to_cxiverbs_cq(init_attr->send_cq);
+
+	if (!(dev->cdev->prop.cassini_version & CASSINI_2) ||
+	    dev->cdev->prop.vni_matching != 0)
+		return -EOPNOTSUPP;
+
+	if (!pd->lni_ref || !pd->pidonfep_valid || !init_attr->jkey ||
+	    init_attr->jkey->pd != ibpd)
+		return -EINVAL;
+	if (send_cq->lni_ref != pd->lni_ref ||
+	    (init_attr->recv_cq &&
+	     to_cxiverbs_cq(init_attr->recv_cq)->lni_ref != pd->lni_ref))
+		return -EINVAL;
+
+	if (init_attr->qp_type != IB_QPT_RU)
+		return -EOPNOTSUPP;
+	if (init_attr->qp_semantics) {
+		const struct ib_qp_semantics *sem = init_attr->qp_semantics;
+
+		if (sem->msg_order || sem->max_rdma_raw_size ||
+		    sem->max_rdma_war_size || sem->max_rdma_waw_size ||
+		    (sem->max_pdu &&
+		     sem->max_pdu != ib_mtu_enum_to_int(IB_MTU_4096)) ||
+		    sem->imm_data_size > 64 ||
+		    (sem->usage_flags & ~IB_UVERBS_QP_USAGE_IMM_DATA_RQ))
+			return -EOPNOTSUPP;
+	}
+
+	if (udata->inlen >= sizeof(cmd)) {
+		ret = ib_copy_from_udata(&cmd, udata, sizeof(cmd));
+		if (ret)
+			return ret;
+		if (cmd.comp_mask & ~(CXI_IBV_CREATE_QP_SVC_ID |
+				      CXI_IBV_CREATE_QP_TC))
+			return -EOPNOTSUPP;
+		if ((cmd.comp_mask & CXI_IBV_CREATE_QP_SVC_ID) &&
+		    (!cmd.svc_id || cmd.svc_id > CXI_IBV_SERVICE_ID_MAX))
+			return -EINVAL;
+		if (cmd.comp_mask & CXI_IBV_CREATE_QP_TC)
+			tc = cmd.tc;
+	}
+
+	if (init_attr->create_flags & ~IB_QP_CREATE_SOURCE_QPN)
+		return -EOPNOTSUPP;
+
+	if (init_attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
+		if (init_attr->source_qpn &
+		    ~(CXI_QPN_ADDR_MODE_MASK | CXI_QPN_RI_MASK | CXI_QPN_PID_MASK))
+			return -EINVAL;
+		if (requested_addr_mode != pd->qpn_addr_mode)
+			return -EINVAL;
+		if (requested_pid != pd->pidonfep)
+			return -EINVAL;
+	}
+
+	/*
+	 * The Resource Index selects which receive bucket of this PD's PID
+	 * slice remote peers address (the PTE pid_offset). It is chosen by the
+	 * application and is independent of the service ID, which only names
+	 * the resource-limit pool the LNI draws from.
+	 */
+	ri = (init_attr->create_flags & IB_QP_CREATE_SOURCE_QPN) ?
+		requested_ri : 0;
+	if (dev->pid_granule && ri >= dev->pid_granule)
+		return -EINVAL;
+
+	svc_id = (cmd.comp_mask & CXI_IBV_CREATE_QP_SVC_ID) ? cmd.svc_id :
+		 pd->preferred_svc_id;
+	if (!svc_id)
+		svc_id = pd->lni_ref->svc_id;
+	if (svc_id != pd->lni_ref->svc_id)
+		return -EINVAL;
+	qp->lni = pd->lni_ref->lni;
+
+	spin_lock_init(&qp->lock);
+	mutex_init(&qp->modify_lock);
+	qp->state           = IB_QPS_RESET;
+	qp->pt_map_index    = -1;
+	qp->max_send_wr     = min_t(u32, init_attr->cap.max_send_wr, CXI_MAX_SEND_WR);
+	qp->max_recv_wr     = min_t(u32, init_attr->cap.max_recv_wr, CXI_MAX_RECV_WR);
+	qp->max_send_sge    = min_t(u32, init_attr->cap.max_send_sge, CXI_MAX_SEND_SGE);
+	qp->max_recv_sge    = min_t(u32, init_attr->cap.max_recv_sge, CXI_MAX_RECV_SGE);
+	qp->max_inline_data = min_t(u32, init_attr->cap.max_inline_data, CXI_MAX_INLINE);
+	qp->vni             = init_attr->jkey->job->job_id;
+	qp->svc_id          = svc_id;
+	qp->ri              = ri;
+	qp->tc              = tc;
+
+	mutex_lock(&pd->resource_lock);
+	if (pd->job_id && pd->job_id != qp->vni) {
+		ret = -EINVAL;
+		goto err_unlock_pd;
+	}
+	if (init_attr->create_flags & IB_QP_CREATE_SOURCE_QPN)
+		ret = xa_insert(&pd->qpns, ri, qp, GFP_KERNEL);
+	else
+		ret = xa_alloc(&pd->qpns, &ri, qp,
+			       XA_LIMIT(0, dev->pid_granule - 1), GFP_KERNEL);
+	if (ret)
+		goto err_unlock_pd;
+	pd->job_id = qp->vni;
+	qp->ri = ri;
+	qp->identity_reserved = true;
+	pid = pd->pidonfep;
+	resource_index = FIELD_PREP(CXI_QPN_RI_MASK, ri);
+	mutex_unlock(&pd->resource_lock);
+
+	qp->domain = dev->cadev->domain_alloc(qp->lni, qp->vni, (unsigned int)pid);
+	if (IS_ERR(qp->domain)) {
+		ret = PTR_ERR(qp->domain);
+		qp->domain = NULL;
+		goto err_identity;
+	}
+
+	/* Step 2: Allocate a Communication Profile (LCID + traffic class) */
+	qp->cp = dev->cadev->cp_alloc(qp->lni, qp->vni, qp->tc, CXI_TC_TYPE_DEFAULT);
+	if (IS_ERR(qp->cp)) {
+		ret = PTR_ERR(qp->cp);
+		qp->cp = NULL;
+		goto err_free_domain;
+	}
+	qp->lcid = qp->cp->lcid;
+
+	/* Step 3: Allocate transmit (initiator) CQ.
+	 * cxi-driver internally allocates the ring buffer for user CQs.
+	 */
+	txq_opts.count = CXI_TXQ_DEFAULT_ENTRIES;
+	txq_opts.flags = CXI_CQ_IS_TX | CXI_CQ_USER;
+	txq_opts.lcid  = qp->lcid;
+
+	qp->txq = dev->cadev->cq_alloc(qp->lni, send_cq->eq, &txq_opts, NUMA_NO_NODE);
+	if (IS_ERR(qp->txq)) {
+		ret = PTR_ERR(qp->txq);
+		qp->txq = NULL;
+		goto err_free_cp;
+	}
+
+	/* Step 4: Allocate target (receive) CQ */
+	tgq_opts.count = CXI_TXQ_DEFAULT_ENTRIES;
+	tgq_opts.flags = CXI_CQ_USER;
+
+	if (init_attr->recv_cq) {
+		struct cxiverbs_cq *recv_cq = to_cxiverbs_cq(init_attr->recv_cq);
+
+		qp->tgq = dev->cadev->cq_alloc(qp->lni, recv_cq->eq, &tgq_opts,
+					NUMA_NO_NODE);
+	} else {
+		qp->tgq = dev->cadev->cq_alloc(qp->lni, send_cq->eq, &tgq_opts,
+					NUMA_NO_NODE);
+	}
+	if (IS_ERR(qp->tgq)) {
+		ret = PTR_ERR(qp->tgq);
+		qp->tgq = NULL;
+		goto err_free_txq;
+	}
+
+	/* Step 5: Allocate the Portal Table Entry */
+	/*
+	 * Matching, so an RMA operation can select a region by its rkey. SEND
+	 * uses match bits of zero, which no rkey takes.
+	 */
+	pte_opts.is_matching    = 1;
+	pte_opts.en_match_on_vni = 1;
+	pte_opts.use_long_event = 0;
+
+	qp->pte = dev->cadev->cxi_pte_alloc(qp->lni, send_cq->eq, &pte_opts);
+	if (IS_ERR(qp->pte)) {
+		ret = PTR_ERR(qp->pte);
+		qp->pte = NULL;
+		goto err_free_tgq;
+	}
+	ret = dev->cadev->pte_map(qp->pte, qp->domain, qp->ri,
+				false, &pt_index);
+	if (ret)
+		goto err_free_pte;
+	qp->pt_map_index = pt_index;
+
+	/* Step 6: Get TXQ mmap info from cxi-driver */
+	ret = dev->cadev->cq_user_info(qp->txq, &txq_cmds_size, &txq_cmds_pages,
+			       &txq_db_phys, &txq_db_size);
+	if (ret)
+		goto err_free_pte;
+
+	/* Step 7: Get TGQ mmap info from cxi-driver */
+	ret = dev->cadev->cq_user_info(qp->tgq, &tgq_cmds_size, &tgq_cmds_pages,
+			       &tgq_db_phys, &tgq_db_size);
+	if (ret)
+		goto err_free_pte;
+
+	/* Register mmap entries for user-space direct submission */
+	qp->resources = kzalloc_obj(*qp->resources);
+	if (!qp->resources) {
+		ret = -ENOMEM;
+		goto err_free_pte;
+	}
+	refcount_set(&qp->resources->refs, 1);
+	qp->resources->cadev = dev->cadev;
+	qp->resources->pd = ibpd;
+	qp->resources->send_cq = init_attr->send_cq;
+	qp->resources->recv_cq = init_attr->recv_cq;
+	qp->resources->domain = qp->domain;
+	qp->resources->cp = qp->cp;
+	qp->resources->txq = qp->txq;
+	qp->resources->tgq = qp->tgq;
+	qp->resources->pte = qp->pte;
+	qp->resources->pt_map_index = qp->pt_map_index;
+	qp->resources->ri = qp->ri;
+	atomic_inc(&ibpd->usecnt);
+	atomic_inc(&init_attr->send_cq->usecnt);
+	if (init_attr->recv_cq)
+		atomic_inc(&init_attr->recv_cq->usecnt);
+
+	{
+		struct ib_ucontext *ibctx = ibqp->pd->uobject->context;
+
+		qp->txq_cmds_mmap = cxiverbs_qp_mmap(qp, ibctx, false, 0,
+						     txq_cmds_pages, txq_cmds_size,
+						     &resp.txq_cmds_offset);
+		if (IS_ERR(qp->txq_cmds_mmap)) {
+			ret = PTR_ERR(qp->txq_cmds_mmap);
+			qp->txq_cmds_mmap = NULL;
+			goto err_free_resources;
+		}
+
+		qp->txq_db_mmap = cxiverbs_qp_mmap(qp, ibctx, true, txq_db_phys,
+						   NULL, txq_db_size, &resp.txq_db_offset);
+		if (IS_ERR(qp->txq_db_mmap)) {
+			ret = PTR_ERR(qp->txq_db_mmap);
+			qp->txq_db_mmap = NULL;
+			goto err_free_resources;
+		}
+
+		qp->tgq_cmds_mmap = cxiverbs_qp_mmap(qp, ibctx, false, 0,
+						     tgq_cmds_pages, tgq_cmds_size,
+						     &resp.tgq_cmds_offset);
+		if (IS_ERR(qp->tgq_cmds_mmap)) {
+			ret = PTR_ERR(qp->tgq_cmds_mmap);
+			qp->tgq_cmds_mmap = NULL;
+			goto err_free_resources;
+		}
+
+		qp->tgq_db_mmap = cxiverbs_qp_mmap(qp, ibctx, true, tgq_db_phys,
+						   NULL, tgq_db_size, &resp.tgq_db_offset);
+		if (IS_ERR(qp->tgq_db_mmap)) {
+			ret = PTR_ERR(qp->tgq_db_mmap);
+			qp->tgq_db_mmap = NULL;
+			goto err_free_resources;
+		}
+	}
+
+	/*
+	 * QPN encoding:
+	 *   bits [11:0]  = PIDonFEP   (filled now)
+	 *   bits [23:12] = Resource Index (PTE pid_offset)
+	 *   bit  31      = addr_mode  (0 = job-relative by default)
+	 */
+	qp->qpn_base = (pd->pidonfep & CXI_QPN_PID_MASK) |
+			resource_index |
+			pd->qpn_addr_mode;
+	ibqp->qp_num = qp->qpn_base;
+
+	resp.txq_cmds_size = txq_cmds_size;
+	resp.txq_db_size   = txq_db_size;
+	resp.txq_idx       = cxi_cq_get_cqn(qp->txq);
+	resp.lcid          = qp->lcid;
+	resp.tgq_cmds_size = tgq_cmds_size;
+	resp.tgq_db_size   = tgq_db_size;
+	resp.tgq_idx       = cxi_cq_get_cqn(qp->tgq);
+	resp.job_id        = qp->vni;
+	resp.pte_index     = qp->pte->id;
+
+	ret = ib_respond_udata(udata, resp);
+	if (ret)
+		goto err_free_resources;
+
+	return 0;
+
+err_free_resources:
+	cxiverbs_qp_free_resources(qp);
+	return ret;
+err_free_pte:
+	if (qp->pt_map_index >= 0) {
+		dev->cadev->pte_unmap(qp->pte, qp->domain, qp->pt_map_index);
+		qp->pt_map_index = -1;
+	}
+	dev->cadev->cxi_pte_free(qp->pte);
+	qp->pte = NULL;
+err_free_tgq:
+	dev->cadev->cq_free(qp->tgq);
+	qp->tgq = NULL;
+err_free_txq:
+	dev->cadev->cq_free(qp->txq);
+	qp->txq = NULL;
+err_free_cp:
+	dev->cadev->cp_free(qp->cp);
+	qp->cp = NULL;
+err_free_domain:
+	dev->cadev->domain_free(qp->domain);
+	qp->domain = NULL;
+err_identity:
+	xa_erase(&pd->qpns, qp->ri);
+	qp->identity_reserved = false;
+	return ret;
+err_unlock_pd:
+	mutex_unlock(&pd->resource_lock);
+	return ret;
+}
+
+/* =======================================================================
+ * destroy_qp
+ * =======================================================================
+ */
+
+int cxiverbs_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
+{
+	struct cxiverbs_qp *qp = to_cxiverbs_qp(ibqp);
+
+	cxiverbs_qp_free_resources(qp);
+	mutex_destroy(&qp->modify_lock);
+	return 0;
+}
+
+/* =======================================================================
+ * modify_qp  —  UEC-aligned state machine
+ * =======================================================================
+ */
+
+int cxiverbs_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata)
+{
+	struct cxiverbs_qp *qp = to_cxiverbs_qp(ibqp);
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibqp->device);
+	enum ib_qp_state cur_state, new_state;
+	int ret = -EINVAL;
+
+	if (attr_mask & ~(IB_QP_STATE | IB_QP_CUR_STATE | IB_QP_PORT |
+			  IB_QP_PKEY_INDEX | IB_QP_ACCESS_FLAGS | IB_QP_PATH_MTU))
+		return -EOPNOTSUPP;
+	if (((attr_mask & IB_QP_PORT) && attr->port_num != 1) ||
+	    ((attr_mask & IB_QP_PKEY_INDEX) && attr->pkey_index))
+		return -EINVAL;
+	if (((attr_mask & IB_QP_PATH_MTU) && attr->path_mtu != IB_MTU_4096) ||
+	    ((attr_mask & IB_QP_ACCESS_FLAGS) && attr->qp_access_flags))
+		return -EOPNOTSUPP;
+
+	/*
+	 * uverbs only takes a read reference on the QP for modify, so several
+	 * modifies can run at once. Hold modify_lock for the whole transition:
+	 * the state read below then stays valid until it is published, and the
+	 * portal table map step, which sleeps and so cannot run under the
+	 * spinlock, is not repeated or raced. qp->lock only publishes the state
+	 * to post_send(), post_recv() and query_qp().
+	 */
+	mutex_lock(&qp->modify_lock);
+
+	spin_lock_irq(&qp->lock);
+	cur_state = qp->state;
+	spin_unlock_irq(&qp->lock);
+	new_state = (attr_mask & IB_QP_STATE) ? attr->qp_state : cur_state;
+	if ((attr_mask & IB_QP_CUR_STATE) && attr->cur_qp_state != cur_state) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	switch (cur_state) {
+	case IB_QPS_RESET:
+		if (new_state == IB_QPS_RESET || new_state == IB_QPS_INIT ||
+		    new_state == IB_QPS_RTS) {
+			spin_lock_irq(&qp->lock);
+			qp->state = new_state;
+			spin_unlock_irq(&qp->lock);
+			ret = 0;
+		}
+		break;
+
+	case IB_QPS_INIT:
+		if (new_state == IB_QPS_RTR) {
+			struct cxi_ibv_modify_qp_resp resp = {};
+			unsigned int pt_index;
+			bool mapped = false;
+
+			if (qp->pt_map_index < 0) {
+				ret = dev->cadev->pte_map(qp->pte, qp->domain,
+							qp->ri, false, &pt_index);
+				if (ret)
+					goto out;
+				qp->pt_map_index = (int)pt_index;
+				mapped = true;
+			}
+			pt_index = qp->pt_map_index;
+
+			ibqp->qp_num = qp->qpn_base;
+
+			ibdev_info(&dev->ib_dev,
+				   "QP RTR: qpn=0x%06x ri=%u pid=%u vni=%u pte=%u map_slot=%u\n",
+				   qp->qpn_base, qp->ri,
+				   qp->domain ? qp->domain->pid : 0, qp->vni,
+				   qp->pte->id, pt_index);
+
+			/*
+			 * No list entry is appended here: an LE must be bound to
+			 * a registered MR, which only post_recv has. Until one is
+			 * posted the portal matches nothing and inbound traffic is
+			 * dropped, which is what an empty receive queue means.
+			 */
+
+			/*
+			 * pte_map() hands back an RMU portal-list slot, not the
+			 * PtlTE number that target commands address.
+			 */
+			resp.pte_index = qp->pte->id;
+			if (udata && udata->outlen >= sizeof(resp)) {
+				ret = ib_respond_udata(udata, resp);
+				if (ret) {
+					if (mapped) {
+						dev->cadev->pte_unmap(qp->pte,
+							qp->domain, qp->pt_map_index);
+						qp->pt_map_index = -1;
+					}
+					goto out;
+				}
+			}
+
+			spin_lock_irq(&qp->lock);
+			qp->state = IB_QPS_RTR;
+			spin_unlock_irq(&qp->lock);
+			ret = 0;
+		}
+		break;
+
+	case IB_QPS_RTR:
+		if (new_state == IB_QPS_RTS) {
+			spin_lock_irq(&qp->lock);
+			qp->state = IB_QPS_RTS;
+			spin_unlock_irq(&qp->lock);
+			ret = 0;
+		}
+		break;
+
+	case IB_QPS_RTS:
+	case IB_QPS_ERR:
+		if (new_state == cur_state || new_state == IB_QPS_ERR ||
+		    new_state == IB_QPS_RESET) {
+			spin_lock_irq(&qp->lock);
+			qp->state = new_state;
+			spin_unlock_irq(&qp->lock);
+			ret = 0;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+out:
+	mutex_unlock(&qp->modify_lock);
+	return ret;
+}
+
+/* =======================================================================
+ * query_qp
+ * =======================================================================
+ */
+
+int cxiverbs_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		     int attr_mask, struct ib_qp_init_attr *init_attr)
+{
+	struct cxiverbs_qp *qp = to_cxiverbs_qp(ibqp);
+	unsigned long flags;
+
+	memset(attr, 0, sizeof(*attr));
+	memset(init_attr, 0, sizeof(*init_attr));
+
+	spin_lock_irqsave(&qp->lock, flags);
+	attr->qp_state     = qp->state;
+	attr->cur_qp_state = qp->state;
+	spin_unlock_irqrestore(&qp->lock, flags);
+	attr->pkey_index   = 0;
+	attr->port_num     = 1;
+	attr->path_mtu     = IB_MTU_4096;
+
+	attr->cap.max_send_wr     = qp->max_send_wr;
+	attr->cap.max_recv_wr     = qp->max_recv_wr;
+	attr->cap.max_send_sge    = qp->max_send_sge;
+	attr->cap.max_recv_sge    = qp->max_recv_sge;
+	attr->cap.max_inline_data = qp->max_inline_data;
+
+	init_attr->cap = attr->cap;
+
+	return 0;
+}
+
+/* =======================================================================
+ * post_send  —  translate IB work requests to CXI DMA commands
+ * =======================================================================
+ */
+
+int cxiverbs_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
+		      const struct ib_send_wr **bad_wr)
+{
+	struct cxiverbs_qp  *qp  = to_cxiverbs_qp(ibqp);
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibqp->device);
+	struct cxiverbs_cq  *scq = to_cxiverbs_cq(ibqp->send_cq);
+	int ret = 0;
+
+	spin_lock(&qp->lock);
+	if (qp->state != IB_QPS_RTS && qp->state != IB_QPS_RTR) {
+		spin_unlock(&qp->lock);
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	for (; wr; wr = wr->next) {
+		union c_fab_addr dfa;
+		uint8_t dfa_ext = 0;
+
+		switch (wr->opcode) {
+		case IB_WR_SEND: {
+			const struct ib_ud_wr *ud_wr =
+				container_of(wr, const struct ib_ud_wr, wr);
+			struct cxiverbs_ah *ah = to_cxiverbs_ah(ud_wr->ah);
+			struct c_full_dma_cmd cmd = {};
+			u32 remote_pid;
+			u32 remote_ri;
+
+			if (!wr->num_sge || !wr->sg_list)
+				goto bad;
+
+			/* No CXI command carries a gather list. */
+			if (wr->num_sge > 1) {
+				ret = -EINVAL;
+				goto bad;
+			}
+
+			remote_pid = ud_wr->remote_qpn & CXI_QPN_PID_MASK;
+			remote_ri = FIELD_GET(CXI_QPN_RI_MASK,
+					      ud_wr->remote_qpn);
+			cxi_build_dfa(ah->nid, remote_pid, dev->pid_bits,
+				      remote_ri, &dfa, &dfa_ext);
+
+			/*
+			 * cxi_cq_emit_nomatch_dma() forces restricted=1, which
+			 * suppresses the target PUT event the receiver needs to
+			 * complete its recv WR, and c_nomatch_dma_cmd has no
+			 * user_ptr to carry wr_id. Use an unrestricted full DMA
+			 * put instead; the destination PtlTE is non-matching, so
+			 * match_bits are ignored.
+			 */
+			cmd.command.opcode = C_CMD_PUT;
+			cmd.lac            = wr->sg_list[0].lkey & CXI_LKEY64_LAC_MASK;
+			cmd.dfa            = dfa;
+			cmd.index_ext      = dfa_ext;
+			cmd.remote_offset  = 0;
+			cmd.local_addr     = wr->sg_list[0].addr;
+			cmd.request_len    = wr->sg_list[0].length;
+			cmd.user_ptr       = wr->wr_id;
+			cmd.eq             = scq->eq->eqn;
+			/* One completion per WR: ACK only, not SEND. */
+			cmd.event_send_disable = 1;
+
+			ret = cxi_cq_emit_dma(qp->txq, &cmd);
+			if (ret)
+				goto bad;
+			break;
+		}
+
+		case IB_WR_RDMA_WRITE:
+		case IB_WR_RDMA_READ: {
+			const struct ib_rdma_wr *rdma_wr =
+				container_of(wr, const struct ib_rdma_wr, wr);
+			struct c_full_dma_cmd cmd = {};
+
+			if (!wr->num_sge || !wr->sg_list)
+				goto bad;
+
+			if (wr->num_sge > 1) {
+				ret = -EINVAL;
+				goto bad;
+			}
+
+			/* For RC, remote NID is encoded in the QP's domain/AH.
+			 * Here we use a simplified direct NID from the rkey.
+			 */
+			cxi_build_dfa(0, 0, dev->pid_bits, 0, &dfa, &dfa_ext);
+
+			cmd.command.opcode = (wr->opcode == IB_WR_RDMA_READ) ?
+					     C_CMD_GET : C_CMD_PUT;
+			cmd.lac            = wr->sg_list[0].lkey & CXI_LKEY64_LAC_MASK;
+			cmd.dfa            = dfa;
+			cmd.index_ext      = dfa_ext;
+			cmd.remote_offset  = rdma_wr->remote_addr;
+			cmd.local_addr     = wr->sg_list[0].addr;
+			cmd.request_len    = wr->sg_list[0].length;
+			cmd.match_bits     = (u64)rdma_wr->rkey;
+			cmd.user_ptr       = wr->wr_id;
+			cmd.eq             = scq->eq->eqn;
+
+			ret = cxi_cq_emit_dma(qp->txq, &cmd);
+			if (ret)
+				goto bad;
+			break;
+		}
+
+		case IB_WR_ATOMIC_FETCH_AND_ADD:
+		case IB_WR_ATOMIC_CMP_AND_SWP: {
+			const struct ib_atomic_wr *atomic_wr =
+				container_of(wr, const struct ib_atomic_wr, wr);
+			const struct ib_rdma_wr *rdma_wr =
+				container_of(wr, const struct ib_rdma_wr, wr);
+			struct c_dma_amo_cmd cmd = {};
+			bool fetching = (wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD);
+
+			cxi_build_dfa(0, 0, dev->pid_bits, 0, &dfa, &dfa_ext);
+
+			cmd.command.opcode  = C_CMD_ATOMIC;
+			cmd.lac             = 0;
+			cmd.dfa             = dfa;
+			cmd.index_ext       = dfa_ext;
+			cmd.remote_offset   = rdma_wr->remote_addr;
+			cmd.request_len     = 8;
+			cmd.match_bits      = (u64)rdma_wr->rkey;
+			cmd.user_ptr        = wr->wr_id;
+			cmd.eq              = scq->eq->eqn;
+			cmd.atomic_op       = fetching ? C_AMO_OP_SUM : C_AMO_OP_CSWAP;
+			cmd.atomic_type     = C_AMO_TYPE_UINT64_T;
+			cmd.op2_word1       = atomic_wr->compare_add;
+			if (!fetching)
+				cmd.op2_word2 = atomic_wr->swap;
+
+			ret = cxi_cq_emit_dma_amo(qp->txq, &cmd, fetching);
+			if (ret)
+				goto bad;
+			break;
+		}
+
+		default:
+			ret = -EOPNOTSUPP;
+			goto bad;
+		}
+
+		cxi_cq_ring(qp->txq);
+		continue;
+
+bad:
+		*bad_wr = wr;
+		spin_unlock(&qp->lock);
+		return ret ? ret : -EIO;
+	}
+
+	spin_unlock(&qp->lock);
+	return 0;
+}
+
+/* =======================================================================
+ * post_recv  —  append a receive LE to the portal table
+ * =======================================================================
+ */
+
+int cxiverbs_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
+		      const struct ib_recv_wr **bad_wr)
+{
+	struct cxiverbs_qp *qp = to_cxiverbs_qp(ibqp);
+	int ret = 0;
+
+	spin_lock(&qp->lock);
+	if (qp->state < IB_QPS_RTR) {
+		spin_unlock(&qp->lock);
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	for (; wr; wr = wr->next) {
+		union c_cmdu cmd = {};
+
+		if (!wr->num_sge || !wr->sg_list) {
+			ret = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
+
+		/* A list entry describes one buffer. */
+		if (wr->num_sge > 1) {
+			ret = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
+
+		cmd.command.opcode     = C_CMD_TGT_APPEND;
+		cmd.target.ptlte_index = (u16)qp->pte->id;
+		cmd.target.ptl_list    = C_PTL_LIST_PRIORITY;
+		cmd.target.op_put      = 1;
+		cmd.target.use_once    = 1;
+		cmd.target.lac         = wr->sg_list[0].lkey & CXI_LKEY64_LAC_MASK;
+		cmd.target.start       = wr->sg_list[0].addr;
+		cmd.target.length      = wr->sg_list[0].length;
+		/* SEND carries no key; match exactly the zero an rkey never is. */
+		cmd.target.match_bits  = 0;
+		cmd.target.ignore_bits = 0;
+
+		ret = cxi_cq_emit_target(qp->tgq, &cmd);
+		if (ret) {
+			*bad_wr = wr;
+			break;
+		}
+		cxi_cq_ring(qp->tgq);
+	}
+
+	spin_unlock(&qp->lock);
+	return ret;
+}

-- 
2.56.0

