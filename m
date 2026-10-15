Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5863B961F;
	Thu, 15 Oct 2026 16:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792082267; cv=fail; b=gjjjO9hYcok5E7fYqPC89MImtPgJPCuEdtEwsgXeqGxQiwOkbovh4HU7vtqkySF1cMvITl7Yz5vv8LpdCPw3aJfgOwEsQxquiJb/ZuiPIj5RtViT6Vegc3tYpp9p2fdEqMOvhj6Dt4Iisdzs/nqaWcCtz9ik3jn1FCPZxVHWcnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792082267; c=relaxed/simple;
	bh=54EXVZm7poISaTEC2lGdxly2wIGbhUiYWhMFQcwuLHM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QzI/+en0DJbgEdsnxx4fYPW2s4TyNxEIzhfuc9QqvI1LWhKZt7f1pvzqxSV0Yn2RjPOMMz4aut8jE3qCgdVt8EP0ULadsCLa42TLEkSWE5VdttIS57xKRPr6tuUmH2T/fDV7sDWmTEeSzXm7jyJoH8+w4uS29Kl4yLWZSpBTEVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d86JpcnF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f0NN/Xv+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d86JpcnF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f0NN/Xv+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FDRkmv1070981;
	Thu, 15 Oct 2026 16:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=54EXVZm7poISaTEC2lGdxly2wIGbhUiYWhMFQcwuLHM=; b=
	d86JpcnFe1jwQQ+AJSI4YUs5JhaHIEB7Tnl+k8/gvfcGqhwwmrk9S5x03c3GFRGo
	xbUWrBzfNOCUm7RNBuoDak+6tkW7BuWay1hIAKfkew9NWOiT+xS112wdI2AObeEW
	Nshtzg/uf3XpRbal1FUgtIwUJDvcFy1FTwOBzDXiLmoLQadrc5GMrvem6QaCK7wS
	91SIkq5VO1q/IE3zxF5dgrSu7uHtyt+XUOYn5lGaRZ4HWM8p1yCfdhrobKMvvM2i
	a1eowexZipUGZSMoPrAIEBCSJXWzvQ9qOH39cY1Sb+lkFcoCqn8xi06vA+PanbR3
	6A5OJVzRrVL6sw5THPx33g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1rbjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 16:37:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69FGaqPj006459;
	Thu, 15 Oct 2026 16:37:28 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnu0am-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 15 Oct 2026 16:37:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p37PxjZxsCxZWJhIBf2JwXz5bHjof2zpOpfeUIqMVOBCYxQ5Jp+DdX5b/IfshlKvexZE0bpCK7l59FsOkCahmbEEvlx8xZoKWanUPtVlc+OQ9L1CnaBRmVaLnx/T2jqlFLY5WEdwcy+kmRJs87qvbrp00F29ZreBmaWraTbjgPq4PahLqMbRmBdvOxlUnzg29uBHuosRP/kIFqlwDjlSRBsUwc6r7L5U14HqaN/PAvSDglK33diQgoNLBxeX6mM5LGDUl9BKrGxoL6NADwMEpVgRyONuNeI3q2oYma9m3a6zT0eiybI1H9p6SNJFyA/EXX5Z4TQzlEUEBYllP+9AFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54EXVZm7poISaTEC2lGdxly2wIGbhUiYWhMFQcwuLHM=;
 b=pOPEXQc+oLQljeSsY7IyNGOmGqQ3+biLnM56Zy3MronHeP3wuNHMaMK8iM29cFFByOytd3oeIrMMowzUITb/MN5VJgWMIZmzPxtar+uqetTyFBOxkGW/U7HDjZfMg8/hEa9khGuNu+ME9erk4M9MGfNpHIrYPhqwVUYUMIHXdzFS9cCDwrV5mfmW+tpQzyv1YjBZzBmmORNCW6fGYCgGw9ZZZ8zWnMO5Xn9gwtWAmllZWjXzeHXGWzmk8v6NX/mWcc+CRl95cIoA2j5WWlL/Zjc+aJw5+VjbZwJ2mndfVN14hAQ03bt+o1NhHN7E7Y7tJD3QFVWdbS6DILRkIwN36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54EXVZm7poISaTEC2lGdxly2wIGbhUiYWhMFQcwuLHM=;
 b=f0NN/Xv+TdkA61PFXokSRcvamR68Ry4iRLimpx4+gVMs/YoCndr1aH7kwh5Wb3isHRQVTKIOTZKW96edYjfrPmNXizNHhGaM0iiP1KXnWmplxRwgDUitSPLmbt5bkrSG8I8HlEDgzaY+axBZC5s5NW+2dkpiwXpfcatOWDcyWpQ=
Received: from DS4PPFBEF84CD53.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d46) by SJ0PR10MB6432.namprd10.prod.outlook.com
 (2603:10b6:a03:486::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.8; Thu, 15 Oct
 2026 16:36:41 +0000
Received: from DS4PPFBEF84CD53.namprd10.prod.outlook.com
 ([fe80::9bb5:d45d:5658:d556]) by DS4PPFBEF84CD53.namprd10.prod.outlook.com
 ([fe80::9bb5:d45d:5658:d556%7]) with mapi id 15.21.0546.006; Thu, 15 Oct 2026
 16:36:38 +0000
From: Praveen Kannoju <praveen.kannoju@oracle.com>
To: Leon Romanovsky <leon@kernel.org>,
        "yishaih@nvidia.com"
	<yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>,
        Anand
 Khoje <anand.a.khoje@oracle.com>
Subject: RE: [PATCH] IB/mlx4: Avoid requeueing executing CM timeout work
Thread-Topic: [PATCH] IB/mlx4: Avoid requeueing executing CM timeout work
Thread-Index: AQHdXLsKsV6MmZh7Zk+jwO1Q8PxF1bb+zRXw
Date: Thu, 15 Oct 2026 16:36:38 +0000
Message-ID:
 <DS4PPFBEF84CD5320E053AB5064DE9008CE8C9C2@DS4PPFBEF84CD53.namprd10.prod.outlook.com>
References: <20261014121344.100048-1-praveen.kannoju@oracle.com>
 <179207862986.254651.2841817114239793003.b4-ty@kernel.org>
In-Reply-To: <179207862986.254651.2841817114239793003.b4-ty@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_Enabled=True;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_SiteId=4e2c6054-71cb-48f1-bd6c-3a9705aca71b;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_SetDate=2026-10-15T16:36:04.0000000Z;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_Name=Restricted-Including
 External
 Recipients;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_ContentBits=3;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_Method=Standard
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFBEF84CD53:EE_|SJ0PR10MB6432:EE_
x-ms-office365-filtering-correlation-id: a1374370-55df-44a1-69bb-08df2ada7c5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|10067099003|261009223027099003|4143699003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 e8njTk9B2ZOlXfeZiz+ewHdelLIDVckrsnf6Zozxdl19KJLChEqoJtuYYh1lvNINdtHwGFerbn4LDlgxC+GFeVrm2sgsyvVIlIXOZ7NqN+3MvtOV4Vvv0iAac3hwR1vHuVZlapa1BCj3Y1PLJEvgKREFbAUTMmERitY/2GXuqxNQ/d45/dt1OebkcTab93g9YtPsB6zD2QQE+kLlEhgXdLqaoUfcjgUFZScFdjQduX4goZLcvSAW9nvDQWiZXl9e7NQL1wxG09ihBaD4xaYBcNOadt/aMgnVFd9pAVCZkoLj8383Kta98tsqckKWIFCWCnwAal5W3wCOlNVXQcuT4jjp8nXxl4W93OphB5F84AFuVIPmSay1CCdLvsLYSnBCfdLIb5+htW9FUa+1Do4KWfnf53XwFPFxnPFOLmUfuSy0hOAwlZRqBK2rVGyH5n8haraONmyv0dGazLRxI6+YMcDjnDMSOuooVIoHPqw9IsruAZCNwK5RX4swygCGsU2zpFgGpZ6gNhmLes6sSRYgXm40kHp8m+hDB976VaoI/eWOorLLPyMpRCTjUTzqVJbJm095uUpnfgkQs5dLnglalvxabAFuX9UySVkx0h2T02VgcLlzAVP4cYM41Q3Hkl09juP9JR4vrDysZtstZ3A14/zsqqtOpf0i/s6FKTCPtsQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFBEF84CD53.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(261009223027099003)(4143699003)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SThnNVVCU1RUQ1Q2eDR5TE1Kd0djbmtES01GUzlCbFh2a2M5SVE1VXg4d0pX?=
 =?utf-8?B?dnQwWHdRa1Zqd1pqcE5GVyt6RUo1MTUxMUpkWDJPQ0Y3YlBUTTE1TlBaRGZU?=
 =?utf-8?B?Kys1S2MxbkFYZmRnajJ2SGV5Sjl4a0x1bkxHaEJHSnFIYkJKekxmalZLY3dt?=
 =?utf-8?B?Q205LzdIZHdiZExiZXFiWFZONlBENldlR3A5Uy84b3ZoRUNReWNIanBPV1Zr?=
 =?utf-8?B?THkvb2xJWmdKV3RubEV5RHZrYVJHbUExVWFQeWFvaXFrcG5oQVNrL1lSeUs1?=
 =?utf-8?B?MHBMQ3o5SlZvMnA2U2lMVGlKdTd3UnVJOHphN2lHckhaSHhESy9aVjh6ZFlT?=
 =?utf-8?B?VTBRTHhJd2JaNER2dW9zV1J5TnBMSnBmK09lLzhicVVlRGJQaWlqNVdQTXFj?=
 =?utf-8?B?YU15QXAwMVJZaUdOVjM4bXhXdVo0U1MyL2ZFN3dER3p2ajdVRVBFSmRvYlNG?=
 =?utf-8?B?Z3VpVDBUY3pQcVlkMEovMlo1TGhBZ0o4WWpHVG05MEQvQVRaZDlYQUhKYndE?=
 =?utf-8?B?cjdyZUVtK1pSQmtoQlNVMUJMTFJuZDN4UjM2aHpwLzlQdFpPL0s3YWJsc0RV?=
 =?utf-8?B?ZzZDRXYvUkUwYTlsdGRtSSt2R3FCeVhXRlAvZDdFMDJOWHJTMmhwbHZDa3JP?=
 =?utf-8?B?VElSRk4zeXMzaVJacEpaUlNoQXNnR3NLWk1yb0hGdVJGZlVWeWR4TEtZWDlI?=
 =?utf-8?B?SWJiT24raTdXeHJnNUc3YzNqWk5sbldYOHBEOUpyaUFoYXJ2WFNrTGdIRStu?=
 =?utf-8?B?UWNaNDNVRGNrRW9DekJTajE1MlJoamFIeW1ycWtCNWNhU3NSdDFHUUN1MWRq?=
 =?utf-8?B?L2RKOGEzVFlHbkxyTzFlb1ZrVmlHTGFlMTR6V1pxdWNvOUJ5V3JVeWl1cnNO?=
 =?utf-8?B?Y2VlTVhObmxTT01yVGF6ODg5SGxZak9ZemRqRmM1cldEblIxZ0NCSWNDVGIz?=
 =?utf-8?B?cHVCNS8xS0x0cER3aXZLSy95Zms2TlJwaHMybmdRUmZLMW11NWF1dzU3N2tF?=
 =?utf-8?B?N0pkNzV1ZnVVUTcvSTN1ek5IWDQ1ckpISGVkaWVzSEg5cm1zSGg5bHJvZ1lu?=
 =?utf-8?B?WUJEaHJkMmhXdVo2Q1F4YWsvWVhGRENncy9ibEtVR1hlcURQakxWMGRSVmVL?=
 =?utf-8?B?b3pKQnNiR0N2WUxoNWpncXczNDF2REdiRDQxM2duNXpzOU9mUTBpbFlrZDQ0?=
 =?utf-8?B?UFFLVkNtVGdOazJ3UXY4QjJoamxJTXRHVzFzaEszSFgyM3RqNmRVS0Qyc3Z3?=
 =?utf-8?B?UW1SWjRubU1NQkRBbjdtaDVLVWtoK1A4Qzg1SkZvZExTamwzdnRUWHVQbjlY?=
 =?utf-8?B?cXFZdkxZcGF1Nk1vamxmMy9pYld3S0xhcG9xNDltbkdpa3AyaXhVemRSRTRF?=
 =?utf-8?B?K1V6d1ZuMHQ2RFQ1dXNFVmhScFZ1WkloN0dBN2QreWZtSWRWa3NQL0VOR2JQ?=
 =?utf-8?B?dWlJOHJCby9Bc2FpUUsxL2J4aWoxaHR3aDh3ZHQ2bzZJYnQxdE1VTllaNzIy?=
 =?utf-8?B?M1dWcDlDSlhRbUVGUHBsUUFRUU1zUmN0b0VNc3JkbWhhaHRmWWp1Y2pCSVRv?=
 =?utf-8?B?ay9DUnVrb0ZZcnphT1FwR2E2dkF5eWhaWkdaSmVJdFZ2S2YySkFicHVxd0Jt?=
 =?utf-8?B?a054UkRYb1pjYkVYQk1ieUZ6UEVZZ0NlOThLbnl5MUhka2MxQUtWYU1CQXlz?=
 =?utf-8?B?ZnVXR0ppSDk0L0xmMXV2OHFvelllTWEwWno5a1ZwQVBIMXpjM3pRU2FCYVZK?=
 =?utf-8?B?Y2tRbnRkdG5aT0xqd1dudG42bzdPd3VFNDJhTjFqRDRmRWVqOTNZWC9LZFBF?=
 =?utf-8?B?OW9GZEFiVGpMcG5VOXV1SGhSdE1HUHovN284VktVOTNjSlN1bVQ3KzlOZGdM?=
 =?utf-8?B?Wmx2MkN0ZTVJWUw5TGc1VTlEczhYNEVHR3RDQ3ZGQWcyOTVLOVVCbUl2cmlO?=
 =?utf-8?B?TFBFNHFhR2d1emsydXFzM3JWS0U0SmY0czE2TSt4OXN0bktmQnE2UDUrQ2lj?=
 =?utf-8?B?VEJiUWZhRW45ckIzeDRybUNwdS92bkluNk9Mb1RZcHFJK1JOa1FRL0Jxb2JP?=
 =?utf-8?B?Zk9NQUVLbDZ0Mm4zNVMySWIwR01WVXovYWVJbVhiclljeUpuci96eHUxM1Fz?=
 =?utf-8?B?UDZVNzBGaFpwbHlqRHNRSGRDTEN3QWI5NFVoRUdyYmR4RGhsL1FvaDdBTnhQ?=
 =?utf-8?B?d25IcW5OQlpNb0g3YWJreXh2bXAveE5Walh2T2xyWE5pcHgzMGNwZ3F3ekRk?=
 =?utf-8?B?Y283VENRUmxXbisyL25WWHNuKzFwZDQzVGp4amhQenNzYVRxVkFwd2RhTmQ5?=
 =?utf-8?B?ZVZ6dENqOXhxZld6Q3ZoRFVuc1o0cnM2V1RsQ2J6Nk1WTm9BNjNvUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	15QKBEuXKzRvH5xeEyLFo3xAMPXPRSfqUO+HOH7BvJJUtg8hndYjyXQeWyJNe6U3rewTb5H2OmcDNETR34fNTx395L+OsSaPwUGOGQlrGL0bPfxQNMgDE6LoItb44+IgTUgr/E62Wfx8Jyrgtx5BhQEVwxArpEYi9qAdNDLzREFE2T+H1Q4Uc5R2W/mIRiKRNoOHJ/yPH5gdp+iIOaEb+7AjtddEJGnns1zi5wgHqMCv20Iex3V2qSJQMJHzxeOJYVP7tmP07t1QJR7cpnPoB8fKKcNKPTkv0ng/d3qPqXwnQ7lQLjOGtJWeQCj1QFHdJmjmeanWyIFaP9bDNyeQfQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QwmXqgDLNBL4eMvsiiu7vPjuAwMOJyjU6XzS2w+l/1aON0s2OMW+3s28KyjuP04URFrZXhaAxhfQtanmT6JuLDnWA8fYIW33q3twyYH9OwWylx9Vmhhn7PEuR6TD4SGswWCdhYSjuw7UyHG8cgHWsRPo5la3bGRlRq2rd80oN3jZX40/QKFdgYk1InMuIrD6dfTuecrC8myElB6P2mMFBBTnyAvZZ+geD2I7Ip3O11/UZMiEfbRDZPToRtM6wb4qmjwYkuee7eFtK7mn9hMpecuoMcZ+8bqAJcc0V/Si3klfUR0863411T33IrpuMe1oxKQ1fXpOcbjc+N/j51pQYvYdsJ3IcPUOGFgh4FTrgKJzEtC3qRtwtQKxUKG7BkETTlX7rXnwBndBv7bl7W96Lc2l49uAWzuEHb9HNyxaVKd6GUWfdfbGKnKDAJlEIg43IsZvjW04YJTI4qVFhy7bbCQ+kjxwUax5KsEr/F53RPXhn4EvrpFIR7p2Zz2wS5TxZ89mYvaJb2TU4cyRrqd9WgVBuXA1yRAhIgrbDO7CIBmtE/D+jUG5ldwXFMXKQ2oE5FPOmRiRnLBZu5CjkmJdiMlnv1yppHFxMhqi7W9OJb8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFBEF84CD53.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1374370-55df-44a1-69bb-08df2ada7c5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 16:36:38.7301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRgCrFDoyTUNb/fcFRQYQ+x4nVv48weTzyZ4kYH14PThwfKIVy8lXY9VDoxiVzI6xnwfEy+gJ692C5Pg6cPxjx/3VBzKGyLZFsWjZClHDGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610150066
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6ad10149 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=9jRdOu3wAAAA:8 a=yPCof4ZbAAAA:8
 a=KRWGyyuF-297EIY1gzMA:9 a=QEXdDO2ut3YA:10 a=ZE6KLimJVUuLrTuGpvhn:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA2NSBTYWx0ZWRfX0hRZIOZP463e
 YZ+Gy5zxBdxeXaCQ0PAI5cgyknbqsHFDEyTZSEhP6B/UDXymE/oAOib/cG7OUaNEhSJLx+2eEhe
 zvSLA1Y4ZXuvDsx247fR9EmLLcTIxsFd/gKFvv+JN89WeTIivTtX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA2NSBTYWx0ZWRfXzIZUEk6MTb3/
 IPE2lCqO5HJjLTy2YMzNGoGG+GJ4SsT22cHPEp8Hy01VWxh5OCdY6iHbX6y8kVLrdf8wT8ZUkFa
 2GdOB24h7UxmOJOGgEnqa8NE6yVLYFj12SyRI2Uz8kK94CaM6W7AdQzcWuWUTiC+v3dlDQK6n7c
 nVyybeLRXSokjHlUAsQ89eHuCyxhNKK839sRBDBZe+y30l5uJ0pwLpN7SR246E8kA02AEfyMTrq
 32NtxYuz53zUtQGNVYu4pDXipln8lHp8uVfVw4PL4QMuhITLmUcmA8oomtAtxlpstJjXP+q4EmL
 hTpyIOyR/buEMHLdL5q1kufT3UCSHqNBsiQxw+woxSGcWes9Hn40d/iNEcQhMr1VV8yjqaUzf5/
 S0LZWb6CdALaImQM0YcgMe2hiyEhQ2hv+aBRaAcuZ0fitoLtf3MpFisPthPuL6xrONssIDowuOB
 65Ll8Pr6mTO+4ntwhD29AJnHaUfpvP2U1EOqbDlQ=
X-Proofpoint-GUID: yDHAZweFkiEvbzcFwoV_JJCSxue1aVLZ
X-Proofpoint-ORIG-GUID: yDHAZweFkiEvbzcFwoV_JJCSxue1aVLZ

T3JhY2xlIENvbmZpZGVudGlhbA0KDQpUaGFuayB5b3UsIExlb24uDQoNCi0NClByYXZlZW4uDQoN
Cg0KT3JhY2xlIENvbmZpZGVudGlhbA0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4gU2VudDogMTUgT2N0b2Jl
ciAyMDI2IDA5OjA3IFBNDQo+IFRvOiB5aXNoYWloQG52aWRpYS5jb207IGpnZ0B6aWVwZS5jYTsg
bGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBQcmF2ZWVuIEthbm5vanUgPHByYXZlZW4ua2Fubm9qdUBvcmFjbGUuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIXSBJQi9tbHg0OiBBdm9pZCByZXF1ZXVlaW5nIGV4ZWN1dGluZyBDTSB0
aW1lb3V0IHdvcmsNCj4NCj4NCj4gT24gV2VkLCAxNCBPY3QgMjAyNiAxMjoxMzo0NCArMDAwMCwg
UHJhdmVlbiBLdW1hciBLYW5ub2p1IHdyb3RlOg0KPiA+IGlkLT5zY2hlZHVsZWRfZGVsZXRlIGlz
IHNldCBieSBzY2hlZHVsZV9kZWxheWVkKCkgaXRzZWxmLiAgSXQgaXMgdXNlZA0KPiA+IGluIHR3
byBjYXNlcyBhZnRlciB0aGUgUlRVIHRpbWVvdXQgc3VwcG9ydCB3YXMgYWRkZWQ6DQo+ID4NCj4g
PiAqIEEgbmV3IGlkX21hcF9lbnRyeSBpcyBjcmVhdGVkLCBhbmQgYSA2MC1zZWNvbmQgUlRVIHRp
bWVvdXQgaXMNCj4gPiAgIHNjaGVkdWxlZC4NCj4gPiAqIERSRVEgb3IgUkVKIGlzIHJlY2VpdmVk
IGZvciBhbiBleGlzdGluZyBlbnRyeSwgYW5kIHRoZSBub3JtYWwNCj4gPiAgIDMwLXNlY29uZCB0
ZWFyZG93biB0aW1lb3V0IGlzIHNjaGVkdWxlZCBvciBhZGp1c3RlZC4NCj4gPg0KPiA+IFsuLi5d
DQo+DQo+IEFwcGxpZWQsIHRoYW5rcyENCj4NCj4gWzEvMV0gSUIvbWx4NDogQXZvaWQgcmVxdWV1
ZWluZyBleGVjdXRpbmcgQ00gdGltZW91dCB3b3JrDQo+ICAgICAgIGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcmRtYS9yZG1hL2MvOWJjZjQ1YmZjYWY4M2ENCj4NCj4gQmVzdCByZWdhcmRzLA0KPiAt
LQ0KPiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCg0K
