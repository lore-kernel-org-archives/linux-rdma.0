Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474806;
	b=KdgTVmTLP9930bi84wgJXWYwcA4OMmu/g0xY6QgdDHQbzmRxvLZGSWaMHPaviZ1yG46B
	 OLnbhzaMbeLJ2c96wgHNN7ecVJxEFLmJ6ybM4XFjq8HkkJuG28a1gyPO8XiY3yG+q86tP
	 TL/zLzUFxjmG4RFjbVdbkHZLQcOh+PnGbv4j/krWCn4tEs32rp4omtZvGAUt5nDSANweP
	 9+RRSURq1Dxv0/+eTdTEwU3otkj7RDD1kMdE3+DxcTSxkzRhoDSF9GAl0fFf85SW/6FLu
	 AMGOC5Aw21x8CMPqgd74zxTVR/woNoKbqeo7w4SalfZHocef7DMa0YIEew4/Mlj+q6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474806;
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=rXp6NjwpQ+lkOf70tLYXkAkEIYZyaY+5aMurF/EMriM=;
	b=YtEDv+JCaZYhuuzPas+IvEJ4p9in7tJNHZQPuHZwkJD58TsrDmbrxOL/Sa4P/JVK2Qzj
	 cKEdHdll2CtnNi00As7da4796mCoBBx0fVHYr+dhn+WAQyFI39XrNSG190k3HQz7ZT243
	 h7UPYSIYtbbmrZNYoUJ4ih6xUr7fTVrOMDCLFo9Rk5MO+2ostM7sCPhXPQeV5eRk5Xpc/
	 KbKlHSwfykkbNZviBYI8evBbFbsHuLfMDASRbuBTiSfveoNw2N7XVOmLO9HBG4M21QvhW
	 xf4diwAwTTP29V1/+hG6eMK7Tzm/7e8EUf3fpTmcDVuOHPmiyWPpkbU8RVYJV+tO2tg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=jKRb4+Db;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140B606A31D;
	Sat, 31 Oct 2026 19:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2140B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=jKRb4+Db
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJCii8279244;
	Sat, 31 Oct 2026 19:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=rX
	p6NjwpQ+lkOf70tLYXkAkEIYZyaY+5aMurF/EMriM=; b=jKRb4+DbPTnHFw2R/j
	ecxQ6U3yvCmohXvV2Ga5vHmoRRz1vOHCXNiHfGNh4da/qmS6H79e78o9x3l+A47p
	pe6MLgZ3ova6ie5MP8zV4KJyS2KQQmFesznVWpiwYwzc1KciuYlPnE/NUwxfMVzT
	wYYjqy3kk8bZvbOJyi6Y+6MVroszsdHRQjHhbQ7XmL8yd6n6T1soKDt2K9oc9vnq
	v1gZc9lTo5hOxn+zE89DjKsgV8FiflRk55CaCt84yHffzOLaK+v/TAqSo6Omuz1K
	JxbpNvw5szt9AfuVFHtIWlwBPaBjVthZ6QfJlg3XmDB3dLf1VmL+D9PzxT8c0tNt
	Ve9A==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn7ajq27g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:26:43 +0000 (GMT)
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 39B04D29F;
	Sat, 31 Oct 2026 19:26:43 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:42 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:42 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 19:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ihaw3LS3TzEZNJtjOvNqEDr/c1f2E2QM85KUuQkFC6qK4GQacUoVntSnfIrPNV8m+vNcfiFZyoc+OwQ63DYI0oVXMuOEySgXWeB/a8ix4st11EXvYOuSmunface3ISFhkFOHDXurqivfAPaZRh+/NlywRD5hy88O9iLmLTHxW/wKMf6iZYKPl6oTKKtZtgNMpJPFzIqXDCB0p6LB+C6+gavRVU0sgX76zSEHYc1lcv+6GG7X61STUoQ9dhieTC1qupLHSevod4sn0gLA6nzHwpYAw9ku8g7djP5yq/g0xxWS+hly3wrh22UpbnQiJNdSJsHMD+WvE+pMVVbYVzKTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXp6NjwpQ+lkOf70tLYXkAkEIYZyaY+5aMurF/EMriM=;
 b=DYFABjrmYtd0XN3XXUfDzq9qj29SJae/+PWQeYf4nP1TC1L4zWioJzyls0uyK3Y6Ibg8zEEn2l6yM+2fOHXGlTXM5g7CpFy6YjX85xM0sFxvWN7DlZNbbqPW031d8K0V9KekF9BVFx1/7qdhAr2fYYYf8IBJzcPJfXob6uGuCYQOU+I4v/3Y/W2nVFSqr/ctrkqpljI5FuIK/Tt2jQSP6GWXk4D3HLpldot2Tt3fvPj5RY3rtP+jtU7aeqfjW7sgVnl4Mduwl64HCKVj4fHuahGwjvF3cTAqFqtc/dr3QXCqFJakrkYVMOnYnu5eKsYO3YcRNLBT4SLyaAP3WGEbsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:41 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:41 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:25:56 -0700
Subject: [PATCH 03/12] libibverbs: support provider completion channels and
 Slingshot transport
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-3-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0165.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::20) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|CYXPR84MB3613:EE_
X-MS-Office365-Filtering-Correlation-Id: fb3af185-a603-4474-323b-08df3784e414
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|260925021911599003|260925022911599003|260925021311599003|56012099006|261009223027099003|261028144727099003|261021121427099003|261021123027099003|261026121527099003|261021135927099003|261022075727099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: MYZG+RwtleIcxTYgKRWkrGJEQdzgEA3gkASQBxWQd/hNUpGJWLySQo9PYCXIzExpPe82QSLyEsB4MWDHC8VMDALK7lqJO08ITSUzjsIN4mHQSg6Kf+GPchLGFclKpT3M2mvJy55KxXU2FYMUR9MG7u2KG9pLNn4bSj1A1dbknmoxVnWmuV+W+O9dS8O87bk+jEycRzEX1gLgV8trTR5FrWzD262gNb6bzh/TKV0qYgVB5jMZxs/vNAKnF/9qaTXWfva1/xTi7TiPyKRPAmNcRrQFoJ3CfUQ76gClVG4jVFhmGCKobJtCtMWzR4o4N9Az3W14ecmn2owCRLb2hDNPz4HzHe0Ffy187bkaIeUokcYODtsc82oyTEYMppv0UY/KtaVc4PvAzgcme/4yh7rmErkKxpt0O+BuOvSd0Tr6nuzDcw6g2pnjeZ8qXPhJ7ZMRN0GTzOie77XvqBqmvw17Noa0w7g1P740SypJ0D3UUfWUDze3rULIzS9iXRaVSFtpGuc4EO5usC3dSRICx5FzNRDW0qlmZE8xdkmdHiN+vNhb61XMRG+fGm3e7GmLo14OjZ8fpBZIVuvaYzXQJVbVj2cam/mVCUWCkaJ+HFTSfHR4dzkr49X49mc65pTREMUc6JDwd/flQIhs1ijS4Y2+Odzui3Z58+jrTwNZVs9CZ0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261026121527099003)(261021135927099003)(261022075727099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHo3NXBwRGhmRzdKNDV0ZXAzYjByTy84VlhpZStPWEVmUW1rSU5qU2ZMQ2RM?=
 =?utf-8?B?ZXJOazVEZFo2Y3VHV0dUU3VpTERYYXM1SkNENGhBTjZDK2RIYmZIR0MvenVx?=
 =?utf-8?B?SVRNK3FucWQ4cnludVNzeW5EdFAzZkQ0amI3ZUpsWXhQVERoYis0SHhkaEdW?=
 =?utf-8?B?NHhMRzZWbTBBYndLQ01mRUxrRmFpRWdwR3pXb2JqN3VrVEdvNzVUM2ZNN2FD?=
 =?utf-8?B?b25QdjhwWEsvdmlOMWdEb1B4NTFMNkNhVnVLTndyYlVwRlY2WTBZYkRzS1hQ?=
 =?utf-8?B?eHdDaTFyRncrZ2ZkeVk5SElHZVBMRTV6blU5OU9mcTMwTWt6RjliVjNPUUY4?=
 =?utf-8?B?bHNsYy9VUWxiTUZBVnZFbEhKb3NaZnJDaDRjSmY2QldCQnA2d0dwQlFuTWZL?=
 =?utf-8?B?VzRUVnR5UlIveld1a1JWL0VYSlZYZkNhS0FiNEYyVDJCRzhnY0RodFp5S1JJ?=
 =?utf-8?B?YmpvVTdaWHFBa0JPdlBwOEw5MHNsNlpoWHE1SmNkeUdZWE1pTldMRG94eS9R?=
 =?utf-8?B?aXFMekZzaHd5RXVLVURja25VQTJ3WlZXV0lXaStYaVFwbm1McHRzajV5Rmta?=
 =?utf-8?B?YXhtUGxrQ3ZVZm9CSm5DWU1hUGRHK0dZaUhuWmdEMUpWR0ZmaVkvbHpra3hX?=
 =?utf-8?B?WWRnMXpxOXZVNUQ2b1E3ZWtmRW1LZEJnUHh5Rk9SYTBoS1R5VU91WnAxNkRN?=
 =?utf-8?B?U0NjZkE1Y0lOZlBpaEFNS1pKMDBkY2hpVGhxRTZIOURzdkl6TERRWU5LUnVH?=
 =?utf-8?B?d1UvSS9oQUx6Vm5zZEZVMTFrNGFCUjlhOExZaHdDeWYwMXM2alJrWFR2Qmxz?=
 =?utf-8?B?c0JRbUJhRUFKdmtGMFVhZERmcG9WV2dDREpmL2N4WE93YkVmNWhQdS9RVlAz?=
 =?utf-8?B?QTE3Ky9JZnd1dUhsc1NQNUZlUFlkVldvZm1UY0dpTGdnT3dSdzlXV3pDc1g4?=
 =?utf-8?B?UnhwTTM2dGwyTVpZL0R2a3RUSklpVms1Wlh4Z3Q5ZUNOWVRHbFdjY21ueERP?=
 =?utf-8?B?UVNIR0JnSHlmUTJpdmdaMERuTVQvMjh6a3dRUWVxNUxXczVtdy94VU51RHFi?=
 =?utf-8?B?VCs0MDlsL3ZieVY1Y3MwcitpNG96alRuZThzVFl4TlEvS2V5OFR2Y0VWcGxn?=
 =?utf-8?B?RU52N2ZjWVIyTGFoMm5lREFNazMvK1VRSEVYalI1ZGgrWXRaeDZubk5wS3or?=
 =?utf-8?B?YU03ekJjUGhTamh6eUtvN01CeGx2REx0eUh4VngrdVphVXhoUjFGNVZJcStH?=
 =?utf-8?B?R29RQmxvRVhGekttdHBUb3Z5SlRtekxNWDJyd1FyaGczK3BNbkxnMFltZGQ1?=
 =?utf-8?B?d0ZHb3FsVXcwWXNaRER0M0F3a0FsRFo1N01JalNpNGdxb3E5elRDNldIelhI?=
 =?utf-8?B?YitLZ2ZsVjN2ZUtoR3NoZVVZbEpEb3p3dkxmYlhvQnFRODkxbitraDlXZTc0?=
 =?utf-8?B?VVJQblJnVFZuc0VkSHZ3SlI3VG9GTUZpaGZwcVQ2QWZiU3VPQmw3NHNKTkcx?=
 =?utf-8?B?ODNrUEhBUGpwcXhWekRYZnNZRlBMbzEzNmo0eWVVZE5YN200VFJCeThmdmhr?=
 =?utf-8?B?OG04U1N4UU00QU9jQUNkdmU4bytDVVQrUmVpZGtvNWV6NWczNzRyMk9lQlhV?=
 =?utf-8?B?NDkvVFA0SVhVbkllYThzMGJIWUxMSXRaZGhtOGY5ZTFZaHNUQ3E5aEoxUUFx?=
 =?utf-8?B?azU4amZPSXpTZTVDV1dlSlo1OGl0UEdjUFpOc1VxdDJjdldKVnI4d2hXL0Ix?=
 =?utf-8?B?T3dBVnorb3B2cS9KRmJyT2dBTmM1dTFnR2VFZmkxSkNxeDlQUndRdmovbmw3?=
 =?utf-8?B?QTVja3JxZ1Z2aklDWEQ3TEhXdTE3bWc3WkpTSElVekFINkJDb0JBNFdCVjNq?=
 =?utf-8?B?bG1mY1FKNjh2eVdUck5XN21JSmNXakJ5MGNnMHh2Y1crdGtFTkxsVDJVQktZ?=
 =?utf-8?B?VVRHYzdULzQ4aFB5Zm5rUGtDR1BCdi96UUQycTBMSnltd1VSMlJXaFZyUzNW?=
 =?utf-8?B?b0FEWlhIWERHdmUvZ1ArZVg3U3JmcnNkekNBSjBxUTFMK2dKMHU0ZnY5c1pM?=
 =?utf-8?B?WWQ5S2F0K2ZrMTJLWmpydWZuN0ViUFVMVEZNUHJoa2hlSnB1U1B4MjMzemFs?=
 =?utf-8?B?aEJuNEZyKzFCN1JyTkJtZ3VXcjJMb1F0Vzhnck5SdVl6YVRTRldrUWRzS2xY?=
 =?utf-8?B?RkQwTzZFOUw0N0psRlpYd25IbE5rWUZMOUR1emk4UklldVNvZUZpZHEwdjB6?=
 =?utf-8?B?MHo4TnJGTUtQQ2lXRVJkRFkraVdoUS82L3NBRFo2eElVZ2pYekdFdlFFTmJ5?=
 =?utf-8?B?Ri9XK1lJUXZEZnlwZnZNQTBNeEpmbnUyTERjK2JwQ3JtUEJWelJaUT09?=
X-Exchange-RoutingPolicyChecked: 2otAmYWy+UVCIBQIuzmW7cn9VzxJy19r6lsmgQaBiwEpzrZUfmep83IBQzMaUoRJcCyaCuRlTwCvNAwhVSmOHJKDKOmzl3AwhqpDhkuPmVtb+58g49L42MUS4MUzYGpzjgwdS44Xdh+v/n3Jro9yIW6YpJBJ1NFayV47ju0MTmMgFQbzh1g0wSKFflQl4IR9S77qdqjotojqmBKV31BM1uvb9aVyeWfwVSRq6HZ9974Ocl7k8Kx/cs8IQF/lV1qREhrCmIyEqj6rleFNSuzEyY6C3eBJkJRBFC7GbEWFEgftdOw+NWwEfWCgB7D1OSY2FxmD83AjAzUk+jR3rAn8Cw==
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3af185-a603-4474-323b-08df3784e414
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:41.3052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mB13uCOAXftXUtpbW0A+/uaacwc1wsBnBWuqJyJYAh9Bc3MKPBv/oGqWHZtW8ZRz5GxWdsdef8E4axe7No+1MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: ss2gty18PMUl5uNkM6E_j0PZ0grp6tMT
X-Authority-Analysis: v=2.4 cv=O+asLx9W c=1 sm=1 tr=0 ts=6ae640f3 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=3haJ9R1Aw3gUfsUHDaCR:22 a=MvuuwTCpAAAA:8 a=KAeVz4dCoaKfiHejIIYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfXxuzThtNR4glP
 Q066hHneXu7S7WOwICYfA65JruvOEVBBPDWVbPYPI2MoJrZeAgfvvHeREdHe8g/iaq9QIJoOvV/
 bmfrYqlgEjcm5aOLFgq/uCEqJ3++c8C+sRLA/h7/5lrla/Mho0RDLUtbu//dWJVOjZhugLbhzwC
 1xKCfuH7Fh6GZJQv72stHnRu/7LFzBFZxle6+mHY4LYB1qUZcycCQ7MNaNbwg6WM32rv4Uc9wdy
 kS8MPLekXjLnD7Z42GhzydpP1wtcVJq4JnO3LQHqT39jUKqIfQLtwUV6FLHEHgPJMHp4VF7pgCA
 t/vpguZ2MN9Z4GyjR60EGa2U7/Y1lrJWD6d4aZHoASjABSszxaWkTWhTS6jQ+S3iIuD1C5gq+kH
 NvHZ0fioDYIDIxLrAy4tXcc79mOZMUtsv4su4j6bf8pbRhTSntlryt+1KRmCxFYP5wlzyLTOexe
 Un8MZY8nPBunJnlh0bg==
X-Proofpoint-GUID: ss2gty18PMUl5uNkM6E_j0PZ0grp6tMT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX3mZs1edftpwq
 feETnxJ5AkDD+KB7PEOWpIjrUkIcW6vRnoefrddQh1uTreJi0k/2EKDyhx7VzsWVBHiLK3GFsvD
 gTrZUSpFdWH9vlRMpiatxVHfoOF0HJI=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310077

Two independent additions the cxiverbs provider needs from libibverbs.
They are kept together because both are small and neither is useful
without the provider.

Slingshot transport: add IBV_NODE_SLINGSHOT, IBV_TRANSPORT_SLINGSHOT
and the IBV_GID_TYPE_SLINGSHOT_UFH GID type, together with the sysfs
name "SLINGSHOT UFH" that the kernel reports for it.  The kernel
header mirrors that define the matching RDMA_NODE_SLINGSHOT and
IB_UVERBS_GID_TYPE_SLINGSHOT_UFH values (rdma_netlink.h and
ib_user_ioctl_verbs.h) are updated here, byte for byte from the kernel.

Provider completion channels: add create_comp_channel and
destroy_comp_channel to the provider ops.  The default implementation
returns EOPNOTSUPP and libibverbs then falls back to the kernel
uverbs implementation, so existing providers are unaffected.  The
CXI hardware delivers completions through its own event queues and
needs to supply the channel itself.  As with read_counters_ex, the new
ops join the private ABI that the unreleased UET series already bumped
to 66, so IBVERBS_PABI_VERSION is not bumped again.

The sysfs GID type attribute is read into a 16 byte buffer; the
previous 11 bytes truncated "SLINGSHOT UFH" and made the type
unrecognisable.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 kernel-headers/rdma/ib_user_ioctl_verbs.h |  2 ++
 kernel-headers/rdma/rdma_netlink.h        |  1 +
 libibverbs/cmd_device.c                   |  7 ++++++-
 libibverbs/driver.h                       |  3 +++
 libibverbs/dummy_ops.c                    | 15 +++++++++++++++
 libibverbs/enum_strs.c                    |  3 ++-
 libibverbs/init.c                         |  5 +++++
 libibverbs/man/ibv_query_gid_ex.3.md      |  3 ++-
 libibverbs/verbs.c                        | 13 +++++++++++++
 libibverbs/verbs.h                        |  5 +++++
 10 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/kernel-headers/rdma/ib_user_ioctl_verbs.h b/kernel-headers/rdma/ib_user_ioctl_verbs.h
index 75cdfdbdb2f7..e8e84aa034ef 100644
--- a/kernel-headers/rdma/ib_user_ioctl_verbs.h
+++ b/kernel-headers/rdma/ib_user_ioctl_verbs.h
@@ -258,6 +258,7 @@ enum rdma_driver_id {
 	RDMA_DRIVER_ERDMA,
 	RDMA_DRIVER_MANA,
 	RDMA_DRIVER_IONIC,
+	RDMA_DRIVER_CXI,
 };
 
 enum ib_uverbs_gid_type {
@@ -266,6 +267,7 @@ enum ib_uverbs_gid_type {
 	IB_UVERBS_GID_TYPE_ROCE_V2,
 	IB_UVERBS_GID_TYPE_UET_UDP,
 	IB_UVERBS_GID_TYPE_UET_IP,
+	IB_UVERBS_GID_TYPE_SLINGSHOT_UFH,
 };
 
 struct ib_uverbs_gid_entry {
diff --git a/kernel-headers/rdma/rdma_netlink.h b/kernel-headers/rdma/rdma_netlink.h
index ee11c3bbbae2..69ff1dee2db6 100644
--- a/kernel-headers/rdma/rdma_netlink.h
+++ b/kernel-headers/rdma/rdma_netlink.h
@@ -158,6 +158,7 @@ enum {
 	RDMA_NODE_USNIC,
 	RDMA_NODE_USNIC_UDP,
 	RDMA_NODE_UNSPECIFIED,
+	RDMA_NODE_SLINGSHOT,
 };
 
 /*
diff --git a/libibverbs/cmd_device.c b/libibverbs/cmd_device.c
index da7783565d79..ecc58fff66ba 100644
--- a/libibverbs/cmd_device.c
+++ b/libibverbs/cmd_device.c
@@ -283,11 +283,12 @@ static int query_sysfs_gid(struct ibv_context *context, uint8_t port_num, int in
 #define V2_TYPE "RoCE v2"
 #define UET_UDP_TYPE "UET UDP"
 #define UET_IP_TYPE "UET IP"
+#define SLINGSHOT_UFH_TYPE "SLINGSHOT UFH"
 static int query_sysfs_gid_type(struct ibv_context *context, uint8_t port_num,
 				unsigned int index, enum ibv_gid_type_sysfs *type)
 {
 	struct verbs_device *verbs_device = verbs_get_device(context->device);
-	char buff[11];
+	char buff[16];
 
 	/* Reset errno so that we can rely on its value upon any error flow in
 	 * ibv_read_sysfs_file.
@@ -335,6 +336,8 @@ static int query_sysfs_gid_type(struct ibv_context *context, uint8_t port_num,
 			*type = IBV_GID_TYPE_SYSFS_UET_UDP;
 		} else if (!strcmp(buff, UET_IP_TYPE)) {
 			*type = IBV_GID_TYPE_SYSFS_UET_IP;
+		} else if (!strcmp(buff, SLINGSHOT_UFH_TYPE)) {
+			*type = IBV_GID_TYPE_SYSFS_SLINGSHOT_UFH;
 		} else {
 			errno = ENOTSUP;
 			return -1;
@@ -389,6 +392,8 @@ static int query_sysfs_gid_entry(struct ibv_context *context, uint32_t port_num,
 			entry->gid_type = IBV_GID_TYPE_UET_UDP;
 		} else if (gid_type == IBV_GID_TYPE_SYSFS_UET_IP) {
 			entry->gid_type = IBV_GID_TYPE_UET_IP;
+		} else if (gid_type == IBV_GID_TYPE_SYSFS_SLINGSHOT_UFH) {
+			entry->gid_type = IBV_GID_TYPE_SLINGSHOT_UFH;
 		} else {
 			entry->gid_type = IBV_GID_TYPE_ROCE_V2;
 		}
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 8327550231f4..b6f75faf7997 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -173,6 +173,7 @@ enum ibv_gid_type_sysfs {
 	IBV_GID_TYPE_SYSFS_ROCE_V2,
 	IBV_GID_TYPE_SYSFS_UET_UDP,
 	IBV_GID_TYPE_SYSFS_UET_IP,
+	IBV_GID_TYPE_SYSFS_SLINGSHOT_UFH,
 };
 
 enum verbs_query_gid_attr_mask {
@@ -409,6 +410,7 @@ struct verbs_context_ops {
 	struct ibv_cq_ex *(*create_cq_ex)(
 		struct ibv_context *context,
 		struct ibv_cq_init_attr_ex *init_attr);
+	struct ibv_comp_channel *(*create_comp_channel)(struct ibv_context *context);
 	struct ibv_flow *(*create_flow)(struct ibv_qp *qp,
 					struct ibv_flow_attr *flow_attr);
 	struct ibv_flow_action *(*create_flow_action_esp)(struct ibv_context *context,
@@ -437,6 +439,7 @@ struct verbs_context_ops {
 	int (*dealloc_td)(struct ibv_td *td);
 	int (*dereg_mr)(struct verbs_mr *vmr);
 	int (*destroy_ah)(struct ibv_ah *ah);
+	int (*destroy_comp_channel)(struct ibv_comp_channel *channel);
 	int (*destroy_comp_cntr)(struct ibv_comp_cntr *comp_cntr);
 	int (*destroy_counters)(struct ibv_counters *counters);
 	int (*destroy_cq)(struct ibv_cq *cq);
diff --git a/libibverbs/dummy_ops.c b/libibverbs/dummy_ops.c
index fee27c1f6687..278a5e768348 100644
--- a/libibverbs/dummy_ops.c
+++ b/libibverbs/dummy_ops.c
@@ -210,6 +210,12 @@ static struct ibv_cq_ex *create_cq_ex(struct ibv_context *context,
 	return NULL;
 }
 
+static struct ibv_comp_channel *create_comp_channel(struct ibv_context *context)
+{
+	errno = EOPNOTSUPP;
+	return NULL;
+}
+
 static struct ibv_flow *create_flow(struct ibv_qp *qp,
 				    struct ibv_flow_attr *flow_attr)
 {
@@ -310,6 +316,11 @@ static int destroy_ah(struct ibv_ah *ah)
 	return EOPNOTSUPP;
 }
 
+static int destroy_comp_channel(struct ibv_comp_channel *channel)
+{
+	return EOPNOTSUPP;
+}
+
 static int destroy_comp_cntr(struct ibv_comp_cntr *comp_cntr)
 {
 	return EOPNOTSUPP;
@@ -784,6 +795,7 @@ const struct verbs_context_ops verbs_dummy_ops = {
 	create_counters,
 	create_cq,
 	create_cq_ex,
+	create_comp_channel,
 	create_flow,
 	create_flow_action_esp,
 	create_jkey,
@@ -800,6 +812,7 @@ const struct verbs_context_ops verbs_dummy_ops = {
 	dealloc_td,
 	dereg_mr,
 	destroy_ah,
+	destroy_comp_channel,
 	destroy_comp_cntr,
 	destroy_counters,
 	destroy_cq,
@@ -939,6 +952,7 @@ void verbs_set_ops(struct verbs_context *vctx,
 	SET_PRIV_OP(ctx, cq_event);
 	SET_PRIV_OP(ctx, create_ah);
 	SET_OP(vctx, create_ah_ex);
+	SET_OP(vctx, create_comp_channel);
 	SET_PRIV_OP(ctx, create_cq);
 	SET_PRIV_OP_IC(vctx, create_cq_ex);
 	SET_PRIV_OP_IC(vctx, create_comp_cntr);
@@ -959,6 +973,7 @@ void verbs_set_ops(struct verbs_context *vctx,
 	SET_OP(vctx, destroy_counters);
 	SET_PRIV_OP(ctx, dereg_mr);
 	SET_PRIV_OP(ctx, destroy_ah);
+	SET_OP(vctx, destroy_comp_channel);
 	SET_PRIV_OP_IC(vctx, destroy_comp_cntr);
 	SET_PRIV_OP(ctx, destroy_cq);
 	SET_OP2(vctx, ibv_destroy_flow, destroy_flow);
diff --git a/libibverbs/enum_strs.c b/libibverbs/enum_strs.c
index 54ce7362ab09..735048633366 100644
--- a/libibverbs/enum_strs.c
+++ b/libibverbs/enum_strs.c
@@ -42,9 +42,10 @@ const char *ibv_node_type_str(enum ibv_node_type node_type)
 		[IBV_NODE_USNIC]	= "usNIC",
 		[IBV_NODE_USNIC_UDP]	= "usNIC UDP",
 		[IBV_NODE_UNSPECIFIED]	= "unspecified",
+		[IBV_NODE_SLINGSHOT]   = "Slingshot",
 	};
 
-	if (node_type < IBV_NODE_CA || node_type > IBV_NODE_UNSPECIFIED)
+	if (node_type < IBV_NODE_CA || node_type > IBV_NODE_SLINGSHOT)
 		return "unknown";
 
 	return node_type_str[node_type];
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 5f3d11e2d2d7..99bff6561406 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -116,6 +116,8 @@ enum ibv_node_type decode_knode_type(unsigned int knode_type)
 		return IBV_NODE_USNIC_UDP;
 	case RDMA_NODE_UNSPECIFIED:
 		return IBV_NODE_UNSPECIFIED;
+	case RDMA_NODE_SLINGSHOT:
+		return IBV_NODE_SLINGSHOT;
 	}
 	return IBV_NODE_UNKNOWN;
 }
@@ -415,6 +417,9 @@ static struct verbs_device *try_driver(const struct verbs_device_ops *ops,
 	case IBV_NODE_UNSPECIFIED:
 		dev->transport_type = IBV_TRANSPORT_UNSPECIFIED;
 		break;
+	case IBV_NODE_SLINGSHOT:
+		dev->transport_type = IBV_TRANSPORT_SLINGSHOT;
+		break;
 	default:
 		dev->transport_type = IBV_TRANSPORT_UNKNOWN;
 		break;
diff --git a/libibverbs/man/ibv_query_gid_ex.3.md b/libibverbs/man/ibv_query_gid_ex.3.md
index 261249bc4c92..4c7a5e6f76a5 100644
--- a/libibverbs/man/ibv_query_gid_ex.3.md
+++ b/libibverbs/man/ibv_query_gid_ex.3.md
@@ -63,7 +63,8 @@ struct ibv_gid_entry {
 
 	*gid_type*
 :			enum ibv_gid_type, can be one of IBV_GID_TYPE_IB, IBV_GID_TYPE_ROCE_V1,
-			IBV_GID_TYPE_ROCE_V2, IBV_GID_TYPE_UET_UDP or IBV_GID_TYPE_UET_IP.
+			IBV_GID_TYPE_ROCE_V2, IBV_GID_TYPE_UET_UDP, IBV_GID_TYPE_UET_IP,
+			or IBV_GID_TYPE_SLINGSHOT_UFH.
 
 	*ndev_ifindex*
 :			The interface index of the net device associated with this GID.
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index b2f9f4e3f8c0..b79e35ce9a0e 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -873,6 +873,11 @@ struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context)
 	struct ib_uverbs_create_comp_channel_resp resp = {};
 	struct ibv_comp_channel            *channel;
 
+	/* if the provider doesn't support this, fall back to kernel */
+	channel = get_ops(context)->create_comp_channel(context);
+	if (channel || errno != EOPNOTSUPP)
+		return channel;
+
 	channel = malloc(sizeof *channel);
 	if (!channel)
 		return NULL;
@@ -897,6 +902,12 @@ int ibv_destroy_comp_channel(struct ibv_comp_channel *channel)
 	int ret;
 
 	context = channel->context;
+
+	/* if the provider doesn't support this, fall back to kernel */
+	ret = get_ops(context)->destroy_comp_channel(channel);
+	if (ret != EOPNOTSUPP)
+		return ret;
+
 	pthread_mutex_lock(&context->mutex);
 
 	if (channel->refcnt) {
@@ -1236,6 +1247,8 @@ int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
 		*type = IBV_GID_TYPE_SYSFS_UET_UDP;
 	else if (entry.gid_type == IBV_GID_TYPE_UET_IP)
 		*type = IBV_GID_TYPE_SYSFS_UET_IP;
+	else if (entry.gid_type == IBV_GID_TYPE_SLINGSHOT_UFH)
+		*type = IBV_GID_TYPE_SYSFS_SLINGSHOT_UFH;
 	else
 		*type = IBV_GID_TYPE_SYSFS_ROCE_V2;
 
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 1bb680b7be39..560643b77e35 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -76,6 +76,7 @@ enum ibv_gid_type {
 	IBV_GID_TYPE_ROCE_V2,
 	IBV_GID_TYPE_UET_UDP,
 	IBV_GID_TYPE_UET_IP,
+	IBV_GID_TYPE_SLINGSHOT_UFH,
 };
 
 struct ibv_gid_entry {
@@ -103,6 +104,7 @@ enum ibv_node_type {
 	IBV_NODE_USNIC,
 	IBV_NODE_USNIC_UDP,
 	IBV_NODE_UNSPECIFIED,
+	IBV_NODE_SLINGSHOT,
 };
 
 enum ibv_transport_type {
@@ -112,6 +114,7 @@ enum ibv_transport_type {
 	IBV_TRANSPORT_USNIC,
 	IBV_TRANSPORT_USNIC_UDP,
 	IBV_TRANSPORT_UNSPECIFIED,
+	IBV_TRANSPORT_SLINGSHOT,
 };
 
 enum ibv_qp_msg_order {
@@ -2546,6 +2549,8 @@ struct verbs_context {
 	int (*remove_addr)(struct ibv_job *job, unsigned int addr_idx);
 	int (*query_addr)(struct ibv_job *job, unsigned int addr_idx,
 			  struct ibv_ah_attr_ex *ah_attr);
+	struct ibv_comp_channel *(*create_comp_channel)(struct ibv_context *context);
+	int (*destroy_comp_channel)(struct ibv_comp_channel *channel);
 	void (*free_buf)(struct ibv_buf *buf);
 	void *(*alloc_buf)(struct ibv_pd *pd, size_t size,
 			   struct ibv_buf **buf);

-- 
2.56.0

