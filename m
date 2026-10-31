Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421376;
	b=uPwX26WErlr4Cnq3cIwMygiw+3HMgVCaUIT/OQpQQ4AxIcEP5wAptQBoP/dTzKRU09Ty
	 PdvnFtODTNrhDDPcfYTYtvWyoUiqHgFfuTqdryZLaC2ys2a5SPLfKHuxcMmVfyFBrziIg
	 hWsbEZ6DKvxY6muhPLS/+b4i2+ES3anB9X5Ho/b5NOfUJroWTzj3ly5C4xiTGOGc59FFx
	 elRzu7ln4K7tgjbAL249P48k8JpSo7pjLY8JW2vLo3/hT//29/jeqR2RjIQAbii/ym6PP
	 otHOTQfR6was5xBUMBRa6LYsQ+ntjFLCjTAKpWxZ8+wSz92EjY74omnU52sYfvyC6DA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421376;
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
	bh=TM5x/xzQx7PGakasEg82/uS1qR3tOsWcgvqev++tfRg=;
	b=HsnOeSmoOVKBSJoianSSV3Jkn0jX/TEsQjUuksjHHbPbkKb3Pde/Lh8UMymO+V1zh90U
	 rRZ/UvGIRuSasQ/QmeOBm0Q5OBC/3uzdJblnxIJgm+eq2NWo4O32zVPfG3Irfk6+cDaCl
	 xKSv08SRjxXvijQvR+oOpAQvOYL/qcvv0Tui61amQK0uxPLer5xtcMWog8BmsOw6jZQDc
	 EaGj2tBny4LzksfElV7gL+86NHQtFEElYrBgOxLwa5wkO8CWifvQ7ildorjfEPiFB/QfF
	 n+SABjCnNyXdvE9fmzZ9t3+dsawWZbUd3IwZ+18zabFMFzWOAkFMCLi0TWHCoN25hYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=hKhNUwro;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6D606A333;
	Sat, 31 Oct 2026 04:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8F6D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=hKhNUwro
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V44JB32205405;
	Sat, 31 Oct 2026 04:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=TM
	5x/xzQx7PGakasEg82/uS1qR3tOsWcgvqev++tfRg=; b=hKhNUwronSE27Rravn
	aqq0P66qiDUEZv793TVuahRNstwcqAa4ipXnC7Ff1+po13VVg+yMSVg/clrigfnw
	7AV7TlATSog+4pj36hLo+nBN9Kf8FdGLAFTtODaz5VzdVlXH8SqQ6lFhZ3txyMxG
	dCpsHYd5eUTCmkTswBivKTlasJvsOJwANBilFQQ60vVkcVWjKe9WrIreYa3Q5fLE
	qOSqLxjzQOfk3DdzJecJAT2E6g0eTIyEryY/U+DzMgCQWOye3rR15oE6fDpNKbV+
	kCaiwCWbKbsuGmavpUdSvlj1xJpfRlkWP4uap2P4gkFps+wuHUcZx21dIBWynEUX
	50zQ==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn900878b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:12 +0000 (GMT)
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 3D61C800EF1;
	Sat, 31 Oct 2026 04:36:12 +0000 (UTC)
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:09 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:09 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 04:36:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZJ220OhSRSPyEfPCxIVo/SIsj6bKw83zEIoAeOubeAzgBMfVXTL33++Q0g3LIdSYtlSntja8DuXsPFEwcHLmxRujIfR+MX6XHX06fGrmcbzkdUfyq2GrsJOaFi765g+xkoMImlhTvaY5xZnjNSrmClBW0fKHM/2ZYU52lMmm55elDTtIFP0G4J+nUVig0ImjfrDk7fSSD+YUQS4skUyS/gsiq7YydmKuRwsB4T8msTx7Y7IYNCrrNcPu2KcWC6EySwPZOOz4+PggSpHa8tn+9MfZZeptjtXCq7I7P7fCRjGyVWurEujsjvmtLe12/4vksOHFZ2IpnOF6hmh6FLy3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TM5x/xzQx7PGakasEg82/uS1qR3tOsWcgvqev++tfRg=;
 b=Qq/MA8Y5BgrnjusZTUj0TURggIM7bKdYDwZbw121Yl1ZafZN2wvB+F2t452c7CpHQzBRMQ32Sl+Ue4aBbnOJAvdCb7iv0WQTcaelfz6qwZhEGTX4scmBDZZRJ/3H0ValHg93kt6kYOIsRQqds970Kqg1ttCy3WqmdJrTfpCXxTAcq0RhQ1PM+htOP4KK2SoPPMg/bXJVaCBuXAnko00VnhvQItSrmR+iHEGiWmU8oz7tscRRgFrSxY03UoBrRQ5KhW/A5JggS09DnjFP9OMaSUfNkLqk2ryITfPH78UnVmDdx/BdqYr50g/xoN6TyB308pSORyCuVBDHQTIjXWESlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:06 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:06 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:33 -0700
Subject: [PATCH 05/11] RDMA/cxi: add the auxiliary device and driver ops
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-cxi-for-next-v1-5-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: DS7P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:25c::9)
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
X-MS-Office365-Filtering-Correlation-Id: ea8b66a6-bbe1-43ee-4eb4-08df37087a9e
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|56012099006|261021121427099003|261021135927099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: H+VrVjCijH23gsxJ71UT461zz2AJIGctb8iSIgDPtCTted353OWbXux0+J8NfMW2Ab8zX3Kod8MYGKTVBDaj8iwNDOz7Uhtj0Bu73hC2gjcJaHiLn8zX88wY1Usfc/HtdxAa6jkLnmWcXPxRWz3c8/0zDHvp/oscqPX8bLQnFk96eEtAGCn4MuiPkOhiz0/PdgvrSWiRcz5QgqvB+ns4AHc7wu0DWUZe42f/sXQlLVZOVA5liLij4NaZdoTxaUJ1VrFFKk3Y545wmt/Se7V1Dc5d2S8SMWw9PjWVcDG9L8XIAX8Pv8DuC/w7cMZFfocusR4xb9VAhoAWRflaHPYsx2TXdEd4S/yjtEmjDToOulKKjlxtVuZlkwDHsRm04uONwNwWChztk0CdfnhE38a7vHWdU6lw0swczIQ03kIArzzYEQaVKsE1LlpLYYnHgEGEQRABEe7/t2+HRL4Wy2WZs6nxFhljhJzEiQShJf4a5/bRnQzmWv9fa6EOxp9Z+PghTKA19Tkdxwt0K3P1q2xOeoxplglnjk8KXDGO+pVJ6t8FRgQ4nk1qiogrtS2cREbEr7HeT5KkK2DkYBTcmb9COE4DU+01OucZF3JEePXjY6bOnVDJVW75YDN7hQdu44Cysc+8bNDq9KEA/D/SVH8xbVjXa11zDD45S0ltCTYpY2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(56012099006)(261021121427099003)(261021135927099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmUrYmY5ejRlaVlNOFpaVnl1ckdrdmUwV2xoV2pGMmhkcVU5a25zYmtWMHNF?=
 =?utf-8?B?eG0rQ1VDMDhCTzl0VDZqbGRRYmlFRlR0TC8zV2RzYTFJZkNyOFhNbmppKzdw?=
 =?utf-8?B?OTVpRDZ5SEUxTWhuMmovS2lTOWNnNUxnNjdjU3FwQzUvZHFQb2MxOWFESVZJ?=
 =?utf-8?B?Y2k3akFBMUNVRHIxZzZzL0NNalhqZGYzVWlINlRXL1VZYUdaMzYrMTZab3RP?=
 =?utf-8?B?OFVFV3lXcDk0VFNUQnNHeVVJZDQ1OWhPOWEwTGpuZTJDR21lSzRoNGxpWjlt?=
 =?utf-8?B?bFh3V29qR1VkSENDSG1WYlRjY1llZWhhcFpROGZnVm9QOHl3cjBvb0hUT3Va?=
 =?utf-8?B?MlVOazJTWWt3Z2ZPRVluTWFRbnFzUkNpWnpLQlBFb1FRUlVaK2plV0lydGxI?=
 =?utf-8?B?cVpZTDE4UG1teFJ6czhNcmZ4Nm1ZaHloaVZiR0J3amh4TzhFT3BPOGtKZXY3?=
 =?utf-8?B?RjNCRVpwS2tNbFJvVmp3WGVJS0w3RC9Id00xYk92bG9yQTlRQVR6VjJFK09R?=
 =?utf-8?B?aHZ0YVQ2NW1SSDVBK3A5RVNxN1l6anJQbVlCYmV0OUxSTzJLb0Y3NWlheXBw?=
 =?utf-8?B?ZWdTNUpmZ3pQZFR1d2xUTEtTTXFqS2YwaHFYQjZKUnN4OHJoakI2UXJKbHVW?=
 =?utf-8?B?ZDFVRWtwNGgrb0hmUE1TVU1MK3NnRWQ3RmZ4Ym9MVzU0V3ZuZnIwUkVWazR2?=
 =?utf-8?B?Z3phcU9tYUN5TjJjeGlZMU0vZitHbUV5TEZmamMyRGlkdm0zekljVlJEWU9G?=
 =?utf-8?B?ekVtczdLRkZac1pBQ3ZVa1U5Yko1cXlnS0p6VTlPeVlvb1hmWTNUZ0YwMkp3?=
 =?utf-8?B?RmNkS0pSdmp1eGdmQnpqb1NTT2IwMTVQVFRXbVc3S2xSU2U3cjZadzZET2VL?=
 =?utf-8?B?WkYwbCtmVWJMTmFvYmluY25pRnlJTGh3disxb0NWeHg1cGFVcEdmMTdFcDVF?=
 =?utf-8?B?ZUVvd3I4WVpYd0JqeXZnVXJVN1dtcWVxK3dDNW95QzBOTTVMVVNXWTZZVVFT?=
 =?utf-8?B?aW80TUU3YzFTdVVuMzVaRlgxSFBuVmQ0L0t6cnVGUWlocGd3K0pIWU1GV2NP?=
 =?utf-8?B?bDVMWHZwbDNDQ1JoRzVxTVNQYW92b3RLK0lzVWtWckhNL21QVEVncGdMbVlM?=
 =?utf-8?B?cURjekNOYzNkQjhzSmhPRkxlQy9IMC9HVmtZbTQ3ZmV4ZTlnSXFwN2xQTC9N?=
 =?utf-8?B?M1VuaGxXdlFYYzlTYnFzM1dLMjlPb1NUaFMrbmxqNjlidUJHQ3p0ekt1TmpT?=
 =?utf-8?B?eFFXcVRwcE0rTjIwUHI3Y1BKTEt2Tm5GSmRzM2VXQnZ6c3B6a3JrUjl1Z3pj?=
 =?utf-8?B?QW1BUGYvcGxRZW5OOHVqbjA2dHljSGFiem52MHRkTk9PRmR5bXcrNmpGYTEr?=
 =?utf-8?B?clZhN0RSeG5XZUVhMnh5RkRvbTNKZG5tNVFuQTkxM1BwaW1DZnNxTHRPNzdO?=
 =?utf-8?B?MC83M0QwOU1janV6RVNUdmw5SWkrNjFvTkF3QjdTSzJ1ZzJLYWNFNVJhUzl4?=
 =?utf-8?B?bUxZaUlhNnpUOVF2ZWk5UThhbVRFeW1tWDdJVFNrZHgreU1jamYrY2UvWld1?=
 =?utf-8?B?eUNUR3A3RndDN2x3WGdZVDFOTXFsSnJUU1NOTmJQTEtqQnB0dzFINjVaMVFX?=
 =?utf-8?B?dUFTUHc5N3RRS0taRkc4RFVReVc5YmZ1Y2RzRElHTWpHT0czV2lCM0xHZEVC?=
 =?utf-8?B?bDFaNWNpL2Z5MStGR2I3VW5lN0UrZWhvbVFtbjE0UWpSOVh5ZDFMWTBCcERS?=
 =?utf-8?B?dFBvRzlSWUM2Qjkrekg1UmJYTnBubEY3YkprRzFQOWk0VC9wVllBbmdNNlBa?=
 =?utf-8?B?ZVhNZktjamMrLzZuUU1qRk1hcEFzems3d1ArckpNYjhnUGhzQnZyTFIrY3Y0?=
 =?utf-8?B?ZHRoTFdvY3diR1dlQXdvVlV5aU1uUWttL3d1OXRGTk9BNStoOGtsNGZqd1Jt?=
 =?utf-8?B?M3FYWWFuN1gxNmMxRFhhVzRXUnpQOEdheUx3MDVhWGVBWGVmV0lITnBjUkFG?=
 =?utf-8?B?TWZqd1E0Q2lZTjFtZ2VGWGIvQWErV3ArTjBnLzNvbklheXFLRnkvYjFteWVC?=
 =?utf-8?B?cjQ5ZzhpS3RqTlM2WkJlNWlwUlJ1aUpXclFaU1o5RFpvRVpXekFtMCtRSEpk?=
 =?utf-8?B?NVRLTVF4YjMrVmNXK1lvZlhFUFo2bEtDa0xBRGU3YVdURFI3UGhma3BKdDFM?=
 =?utf-8?B?Wi9Pc1JVUVFBU2hadnMvUjJRRWVCak5OWEpEWVlSRmxmK3RUZGdSdGtjdnNE?=
 =?utf-8?B?aDVIcm51RWE4SkZqVjcxWk9KQ0F3OWRxMVpTMnA2OWdXaTBsZExXVXluQURK?=
 =?utf-8?B?TlBQNmdjdGVNT1A3OVkvL0JGSGYwOXl2OFlIVlNmU1Mvc2NNcTFYZz09?=
X-Exchange-RoutingPolicyChecked: j9WVmeweXKwUeSDOsXHsMoN0L5/mbvqCg96GyJW7QD6u+tH6wCrIHJmWYT/0nUes0bpYBkMALkO9UHDj6fNlIfNeLsbHQnA985mP0gJy7QC6Dt+rrENLleAAgpVfhNsYuQkYUOUcapdHAGtKbSJ5BlnNPAO5S8xM6wqT6JxCG1ZhqsBKcNaxp8+beaWnbyVe0Q4lNzr11wqybPFD50oDXD9UCVlClr4w5mA7+MyImbET4ZaP0Jh3MfDFiBgIPJWmnR5Y69LbWnoMCwpofh+1KHSjQ0qYbX1imR1+Xe6pW+jI0rC2rr5EqTf9uks9T014vFSISOn47x2X2gLvGl1d8Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8b66a6-bbe1-43ee-4eb4-08df37087a9e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:06.7476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TquG30jghBdmNCbpJXrF6RNd/iJijwOHC+bzl0JOd87jTcJu+h6iW+DdmkGxFOj0H1jcye26ZCEOfKo7XC3xgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=J5I/fwnS c=1 sm=1 tr=0 ts=6ae5703c cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=k7r4yCLl9DVLXMiQTbtC:22 a=MvuuwTCpAAAA:8 a=GI8MULdP9TnhG15yl4MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: SwQ64lAKecz36kqteQ4yKoDIVTyEBxLN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX+88oWhy7Chni
 pIzosyUGtTrRjgfYlpvrSRfXBmUXg3iiJ0Fz5Gk+iCE/2+P8A+9PbrGjwA6nZVBtuNz4qKWKu+Y
 8jbKGym2IROiFej2Aa4vQ1Rzvtu16vXGUWEDfsX3/qmN2KGJlMb0BiVgCj3M3HfImOR+OATWx+U
 SsuB2PGbPnvAIy30Axvl8lUwFyejJZhNDPWm4dzH7Itbb5X0UBqfcII1CMQCPS/wGI8nN23BHk5
 e8wZ4H0IMMSze997xhaiFRIXwPbKFa6YS8ZgAC1mx44j4WZYdROb/x0mCPLkd7/ZURnlAhI0EJv
 +qMoiblL/QHkI8jG6tAoYWdpKq5r3ISvxFaNe2r9+3rErcnghsTGNaJTDfkmMVw/syiECRr4iWf
 z/T11ADAuGdXE4dyusLBKGPoNofCjNH2autZaT+fSwbvQ4ROonx1wT2LRGG4bKETCWv1wJVlI7C
 Cklx6T2j42TuRecs7Ew==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfXzdTmf7Kq8xeH
 kmhjmtwPA7JvPay0dVvbIUXhw3Cq6GARZWmzG3ysM9HJP7A2An4e/eKnuEFOWu4ssBcWdYqH8Lp
 PSuKZg229/xk8xhLXCltWK1GOJboe3o=
X-Proofpoint-GUID: SwQ64lAKecz36kqteQ4yKoDIVTyEBxLN
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Bind to the cxi-ss1 auxiliary device and register an ib_device for
it: probe and remove, the NID notifier that updates the device NID and
node GUID when the core driver changes the NIC address, and creation
and the device ops table, including the telemetry counters ops added
later in the series.

If ib_register_device() fails after the NID notifier is registered,
the notifier is unregistered before the device is freed, so the
notifier chain is not left holding a pointer to freed memory.

checkpatch --strict (100 columns) still reports the following in this
patch. They need coordination with the internal repositories this code
is maintained in and will be fixed in V2:
- CHECK: PARENTHESIS_ALIGNMENT (3)

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs_drv.c | 270 +++++++++++++++++++++++++++++++
 1 file changed, 270 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs_drv.c b/drivers/infiniband/hw/cxi/cxiverbs_drv.c
new file mode 100644
index 000000000000..9472ff896c80
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs_drv.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxi-ib: InfiniBand RDMA driver for the Cassini CXI NIC.
+ * Copyright 2022-2025 Hewlett Packard Enterprise Development LP
+ *
+ * Registers as an auxiliary driver that consumes the "cxi_ss1.rdma"
+ * auxiliary device published by the cxi-driver.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include "cxiverbs.h"
+
+MODULE_AUTHOR("Hewlett Packard Enterprise Development LP");
+MODULE_DESCRIPTION("Cassini CXI RDMA verbs driver");
+MODULE_LICENSE("GPL");
+
+/* -----------------------------------------------------------------------
+ * Device operations table
+ * -----------------------------------------------------------------------
+ */
+static const struct ib_device_ops cxiverbs_dev_ops = {
+	.owner           = THIS_MODULE,
+	.driver_id       = RDMA_DRIVER_CXI,
+	.uverbs_abi_ver  = CXI_IB_UVERBS_ABI_VERSION,
+
+	/* Phase 0 – device and port query */
+	.query_device        = cxiverbs_query_device,
+	.query_port          = cxiverbs_query_port,
+	.get_port_immutable  = cxiverbs_get_port_immutable,
+	.get_netdev           = cxiverbs_get_netdev,
+	.query_pkey          = cxiverbs_query_pkey,
+	.query_gid           = cxiverbs_query_gid,
+
+	/* Phase 1 – user context and protection domain */
+	.alloc_ucontext   = cxiverbs_alloc_ucontext,
+	.dealloc_ucontext = cxiverbs_dealloc_ucontext,
+	.alloc_pd         = cxiverbs_alloc_pd,
+	.dealloc_pd       = cxiverbs_dealloc_pd,
+	.alloc_job        = cxiverbs_alloc_job,
+	.dealloc_job      = cxiverbs_dealloc_job,
+	.query_job        = cxiverbs_query_job,
+	.job_addr_insert  = cxiverbs_job_addr_insert,
+	.job_addr_remove  = cxiverbs_job_addr_remove,
+	.job_addr_query   = cxiverbs_job_addr_query,
+	.query_qp_semantics = cxiverbs_query_qp_semantics,
+	.create_jkey      = cxiverbs_create_jkey,
+	.destroy_jkey     = cxiverbs_destroy_jkey,
+
+	/* Telemetry counters */
+	.create_counters   = cxiverbs_create_counters,
+	.destroy_counters  = cxiverbs_destroy_counters,
+	.read_counters_ex  = cxiverbs_read_counters_ex,
+
+	/* Phase 2 – memory registration */
+	.reg_user_mr = cxiverbs_reg_user_mr,
+	.dereg_mr    = cxiverbs_dereg_mr,
+
+	/* Phase 3 – completion queues and mmap */
+	.create_cq      = cxiverbs_create_cq,
+	.destroy_cq     = cxiverbs_destroy_cq,
+	.poll_cq        = cxiverbs_poll_cq,
+	.req_notify_cq  = cxiverbs_req_notify_cq,
+	.mmap           = cxiverbs_mmap,
+	.mmap_free      = cxiverbs_mmap_free,
+
+	/* Phase 4 – queue pairs */
+	.create_qp  = cxiverbs_create_qp,
+	.modify_qp  = cxiverbs_modify_qp,
+	.query_qp   = cxiverbs_query_qp,
+	.destroy_qp = cxiverbs_destroy_qp,
+	.post_send  = cxiverbs_post_send,
+	.post_recv  = cxiverbs_post_recv,
+
+	/* Phase 5 – address handles and GID management */
+	.create_ah  = cxiverbs_create_ah,
+	.create_user_ah = cxiverbs_create_ah,
+	.destroy_ah = cxiverbs_destroy_ah,
+	.add_gid    = cxiverbs_add_gid,
+	.del_gid    = cxiverbs_del_gid,
+
+	/* Pre-allocated slab sizes for RDMA core object allocator */
+	INIT_RDMA_OBJ_SIZE(ib_ah,        cxiverbs_ah,        ibah),
+	INIT_RDMA_OBJ_SIZE(ib_counters,  cxiverbs_counters,  ibcounters),
+	INIT_RDMA_OBJ_SIZE(ib_cq,        cxiverbs_cq,        ibcq),
+	INIT_RDMA_OBJ_SIZE(ib_pd,        cxiverbs_pd,        ibpd),
+	INIT_RDMA_OBJ_SIZE(ib_job,       cxiverbs_job_entry, ibjob),
+	INIT_RDMA_OBJ_SIZE(ib_jkey,      cxiverbs_jkey,      ibjkey),
+	INIT_RDMA_OBJ_SIZE(ib_qp,        cxiverbs_qp,        ibqp),
+	INIT_RDMA_OBJ_SIZE(ib_ucontext,  cxiverbs_ucontext,  ibucontext),
+};
+
+static void cxiverbs_tc_entries_destroy(struct cxiverbs_dev *dev)
+{
+	struct cxiverbs_job_tc_binding *binding, *tmp;
+	struct cxiverbs_tc_entry *tc_entry;
+	unsigned long index;
+
+	mutex_lock(&dev->jobs_lock);
+	xa_for_each(&dev->tcs, index, tc_entry) {
+		list_for_each_entry_safe(binding, tmp, &tc_entry->job_list, entry) {
+			list_del(&binding->entry);
+			kfree(binding);
+		}
+		kfree(tc_entry);
+	}
+	xa_destroy(&dev->tcs);
+	mutex_unlock(&dev->jobs_lock);
+}
+
+static void cxiverbs_gid_change_event(struct cxiverbs_dev *dev)
+{
+	struct ib_event event = {
+		.device = &dev->ib_dev,
+		.element.port_num = 1,
+		.event = IB_EVENT_GID_CHANGE,
+	};
+
+	ib_dispatch_event(&event);
+}
+
+static __be64 cxiverbs_nid_to_node_guid(u32 nid)
+{
+	if (nid == CXI_INVALID_NID)
+		return cpu_to_be64(U64_MAX);
+
+	return cpu_to_be64(nid);
+}
+
+static int cxiverbs_nid_event(struct notifier_block *nb, unsigned long nid,
+			      void *data)
+{
+	struct cxiverbs_dev *dev = container_of(nb, struct cxiverbs_dev,
+					      nid_notifier);
+
+	WRITE_ONCE(dev->nid, nid);
+	WRITE_ONCE(dev->devinfo.nid, nid);
+	WRITE_ONCE(dev->ib_dev.node_guid, cxiverbs_nid_to_node_guid(nid));
+
+	/*
+	 * The NID is only known once the link trains, which is usually after
+	 * probe, so the cached GID still holds the placeholder read at
+	 * registration. Make the core re-read it via query_gid.
+	 */
+	if (READ_ONCE(dev->ib_registered))
+		cxiverbs_gid_change_event(dev);
+
+	return NOTIFY_OK;
+}
+
+/* -----------------------------------------------------------------------
+ * Auxiliary driver probe / remove
+ * -----------------------------------------------------------------------
+ */
+static int cxiverbs_probe(struct auxiliary_device *adev,
+			const struct auxiliary_device_id *id)
+{
+	struct cxi_adev *cxiadev = container_of(adev, struct cxi_adev, adev);
+	struct cxi_dev_info_use info = {};
+	struct cxiverbs_dev *dev;
+	int ret;
+
+	dev = ib_alloc_device(cxiverbs_dev, ib_dev);
+	if (!dev)
+		return -ENOMEM;
+
+	/* Link to the CXI public API and the PCI device.
+	 * cxi_adev->cxi_dev is set by the cxi-driver before publishing
+	 * the auxiliary device.
+	 */
+	dev->cadev = cxiadev;
+	dev->cdev    = (struct cxi_dev *)cxiadev->cxi_dev;
+	if (!dev->cdev) {
+		dev_err(&adev->dev, "cxiverbs: no cxi_dev in cxi_adev\n");
+		ret = -ENODEV;
+		goto err_dealloc;
+	}
+
+	/* Cache device geometry so individual verbs ops can read it
+	 * without calling cxi_dev_info_get() on every request.
+	 */
+	ret = cxiadev->dev_info_get(dev->cdev, &info);
+	if (ret) {
+		dev_err(&adev->dev, "cxiverbs: cxi_dev_info_get failed: %d\n", ret);
+		goto err_dealloc;
+	}
+	dev->nid         = info.nid;
+	dev->pid_bits    = info.pid_bits;
+	dev->pid_count   = info.pid_count;
+	dev->pid_granule = info.pid_granule;
+	dev->devinfo     = info;
+	xa_init(&dev->jobs);
+	xa_init(&dev->tcs);
+	mutex_init(&dev->jobs_lock);
+	dev->nid_notifier.notifier_call = cxiverbs_nid_event;
+	ret = blocking_notifier_chain_register(&cxiadev->nid_notifier,
+					      &dev->nid_notifier);
+	if (ret)
+		goto err_destroy_jobs_lock;
+
+	ib_set_device_ops(&dev->ib_dev, &cxiverbs_dev_ops);
+
+	dev->ib_dev.node_type       = RDMA_NODE_SLINGSHOT;
+	dev->ib_dev.phys_port_cnt   = 1;
+	dev->ib_dev.num_comp_vectors = 1;
+	dev->ib_dev.local_dma_lkey  = 0;
+	dev->ib_dev.dev.parent      = &cxiadev->pdev->dev;
+
+	dev->ib_dev.node_guid = cxiverbs_nid_to_node_guid(dev->nid);
+
+	/* Expose custom uverbs objects (Counting Triggers, Phase 6). */
+	dev->ib_dev.driver_def = cxiverbs_defs;
+
+	ret = ib_register_device(&dev->ib_dev, "cxi%d", cxiadev->dev);
+	if (ret) {
+		dev_err(&adev->dev, "cxiverbs: ib_register_device failed: %d\n", ret);
+		blocking_notifier_chain_unregister(&cxiadev->nid_notifier,
+						   &dev->nid_notifier);
+		goto err_destroy_jobs_lock;
+	}
+
+	dev_set_drvdata(&adev->dev, dev);
+	WRITE_ONCE(dev->ib_registered, true);
+	cxiverbs_gid_change_event(dev);
+	dev_info(&adev->dev, "CXI RDMA device registered as %s\n",
+		 dev_name(&dev->ib_dev.dev));
+	return 0;
+
+err_dealloc:
+	ib_dealloc_device(&dev->ib_dev);
+	return ret;
+
+err_destroy_jobs_lock:
+	cxiverbs_tc_entries_destroy(dev);
+	xa_destroy(&dev->jobs);
+	mutex_destroy(&dev->jobs_lock);
+	goto err_dealloc;
+}
+
+static void cxiverbs_remove(struct auxiliary_device *adev)
+{
+	struct cxiverbs_dev *dev = dev_get_drvdata(&adev->dev);
+
+	blocking_notifier_chain_unregister(&dev->cadev->nid_notifier,
+					  &dev->nid_notifier);
+	ib_unregister_device(&dev->ib_dev);
+	cxiverbs_tc_entries_destroy(dev);
+	xa_destroy(&dev->jobs);
+	mutex_destroy(&dev->jobs_lock);
+	ib_dealloc_device(&dev->ib_dev);
+}
+
+/* -----------------------------------------------------------------------
+ * Auxiliary device ID table and driver registration
+ * -----------------------------------------------------------------------
+ */
+static const struct auxiliary_device_id cxiverbs_auxiliary_ids[] = {
+	{ .name = "cxi_ss1.rdma", },
+	{},
+};
+MODULE_DEVICE_TABLE(auxiliary, cxiverbs_auxiliary_ids);
+
+static struct auxiliary_driver cxiverbs_driver = {
+	.probe    = cxiverbs_probe,
+	.remove   = cxiverbs_remove,
+	.id_table = cxiverbs_auxiliary_ids,
+};
+module_auxiliary_driver(cxiverbs_driver);

-- 
2.56.0

