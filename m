Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474801;
	b=2yyY93EBVXXpwLOQd6XnzlsghsMggjYyFAVZnRadiIrUV4Wqa6RHRLNmWInYgtsDj+aA
	 Dm5mUxJF3C1/XahwNOSgHrCqm1iC/y0rTO0Pcc8CEAZSprGlZyv0p8e7xQ6sClpG+0srG
	 M2jbEfMsK6BIPAv45ZXHaiWeiR9zPhtceNeX4naP076HhMPhwRw7a2HubB21bin2Yv/cm
	 myKsT638cZryfU1tGHJ1bgTgM9wqfIR09i0X6a7fex0eamSl/tWVAcufmSytTBNbCcbmw
	 ndLHkYL++hvt/T9lnH/ZNfv9vZ9M/Iyv/3pXtoRXmNvN1VahEQjyNqNR+tVLig+6Rdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474801;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=r2TNsiZEey5lLi+MneD70R5jNBVbha3MzcPtgVp1T2s=;
	b=pm+0485xhTHbts897CG63GXeJMEZYiR4WFkxRru7nI7oRSfkhQNUWOxvcKkKHYXXvNJA
	 MYXwdNIj5K0AwpD95JQ55j/WdfdU6cNhtx2d8GivatPDcPyxZIctZityuNI6/2E0I1g9G
	 XIyl9BWPkRKpSGfhoaIfJ1q5aAfQsRO0vao2NjPFaW5VTRdk+9p9N/UiY+nwW5In3jja8
	 gqrMXheKcaIywmokRl6VO9Dg86aDnGRA/Sf3Y3WlZgwgiPrd+QOIfrCOOR4hV0q2bdPWg
	 asQddfyYhHYaNernROxn8NcE3jKPdsp/AF3RgKKUZCR+FJ94dxEQS+Wj94abLbBEgcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=DScs2756;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D3606A31A;
	Sat, 31 Oct 2026 19:26:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 990D3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=DScs2756
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJEtcM4164554;
	Sat, 31 Oct 2026 19:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=r2
	TNsiZEey5lLi+MneD70R5jNBVbha3MzcPtgVp1T2s=; b=DScs2756gYTfsXl/Qs
	JDNs8PjRrk8giAFAsPolJz6zhWA5Kn170zJRjo+MnhBF08tLNr/IpMzSlRlyB8E6
	oM7ThhWJsNk1uueZJG87w7WteItL1iXkJgfnqwoTH4Eogy7rx+8ibZuDm9ltee0R
	9mVZNd47yiMUgakAY1AVlrtJOmp5Mo36flgfwdPQUQiGMrNY0nm4DcBklUCQOpMO
	X27ZJkorPAKuIWbB0Uzd6kYbrVGkkX1B5NsSZUh2AjBJlf22U11jJfxhhm3/fJ7s
	Dq9KBu/avgEB69VAjlfIj2ZIk0SMwRXP4QC1CHs7ja8lTD6XJJ8KPNPLFhmk6NC7
	U7hA==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn9qewfyc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:26:38 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 4946A800EC4;
	Sat, 31 Oct 2026 19:26:38 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:38 -1200
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:37 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:37 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:26:37 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QQ438ovFtvL9GjlIRuW09itF/6V6O7Jlem/tCaOP/bEkV5h9bDTjG7nXCJw+ctlWBzhKKQrhDea3/GCvaoW7OXHfOK7LmoAU9M3Ux/p3JMpeMNeZH8596vciGcLscRxYJDpsQoe1SZCXc1uzEqCyItOS5cvi+R+i9MRZXc2ObFwDZIiOgEpOweOZBTLCTX/23taer+cqczQSkb/VwQ3JWn4SuU80VIjX1FEBRxKI2fAAWCK4+IiWp80dHPOGaFjB7xM1u2ZRRYov3WZJEMy7BzpK7DzcVxLGSlA62Ux7DkNFcOl4fitQPxtiUHzDSJaxQR0NzcU3WClIexpXdqyCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2TNsiZEey5lLi+MneD70R5jNBVbha3MzcPtgVp1T2s=;
 b=OXhZvsXN6btygBCufMzrIFjt8vqfYIJFkhxUWyVKcN4K0b3LtYflrocgFHfkXGojE/imX3pQt1ze31LFkVT5JeQQ3GLmiWotB4HsEF88Cu8pmCllBepEj9RlbsWRlLOlR3SCBeKpihSOTW83aCMmps26BG/GisLO5Ru2Yv/fTtK8QHF2UHW6RiO/QnaJ52UjByVmq4sWzwGak8Zw3aKyiS4kQ3pfODkS7CoeEgSEWC2OA3R7SqOg9uRtqs9HTLx12w6ebN5+oaM8tbleNnbYOa98IhO1vhnmx0U7zj+PWeanZKBgIAYrdukO+bFUodFSAHzeYFByVG1Yko0W+kl5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:36 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:36 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:25:54 -0700
Subject: [PATCH 01/12] libibverbs: add ibv_read_counters_ex()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-1-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0162.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::17) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 810ed475-cb47-410b-3bfa-08df3784e0ea
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|260925021911599003|260925022911599003|260925021311599003|56012099006|261009223027099003|261028144727099003|261021121427099003|261021123027099003|261026121527099003|261022075727099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info: CGhiybfZsGhhseSFjTNImhAZ6UXBwm54YewqBDknDAfhY9qdnSrnWgsvQzlAj52Otm0pBIh5rvAN3SkCj9WWk4qqtDc6M8Y/o8C9YMZID6diWWwDhYolXL0hGFmeWkY7SYXurCSQyH7UfZh726JT1VcXLebGYqJaYQL+i+/fP/ly/DuEC0q+FpkzMhk6TlMH0YTuBebSSySxwxQ59mbKfXJ/BpB4/RE90iOe9klfUr7liAiefygXguqVUwsYRNnKzCvhN15Kcon6khH+C8kYGKGg1aoAiNoSgB5bj3oXUv0LmwAwe3ZzXyhvYkw0huNEGVLbTVLVRctX10djLazIuPRUkA3M7CxbHwqSd3Hx/Qyh26rcZCcUF1dA3ZzofUDT6J2ngN/yDlDTEp2XS63uj3hF/yBmYunrh9Gj9ZACFm9p33U5wnKam/QiG6bph1EVR38Og+srKLgvg8Mh4ToGu7w72zkj2plbJ2ILrqxxN5pK8G4+MD2JLx6uTMSJr8Fmn95fdhVUilSduX3R7oTBbM+cRk9mpJwyWbIi8k/DNv+8gSJD9A2yPSiasNZUGkHqAvDHnO5JlVrvhXtL/5xMxgZJDcOiaJNjU+Y6L9b4ns0agsry5gA1Y+0MRrq8iDmWUFkixQftIZ6M1P/rBR25dSTEgjFuvVp31FRlw58Ycf4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261026121527099003)(261022075727099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnpiR1VQMXIxSGxqNFZXRXpUYnp2dGc2cVlTVDJHRHNHVzNuOWZ1Z09iYzho?=
 =?utf-8?B?b1d1UUNLeGNFV3BOMlNPQ2EyaGhpWGF2VlMzMkF2eTV2Sk40NHQya1FMTVJN?=
 =?utf-8?B?SUVtRERpeThHOFhXNUhWMGlYeDVmWFNTNC85eUJRaWZ4eU1Xb1NrT3VuR2ZW?=
 =?utf-8?B?S2NWRm9Fb2pZVHQyZnpvRlE1NW1yUU0reWZxdTNQLzgvL1l1YjVXWWwwNnFa?=
 =?utf-8?B?ME1iNEp5eGtnQjc5SzgzeDRJa0l1Q0kyM3d6cGpHR0JpMGhXTHd4UW1pd2NZ?=
 =?utf-8?B?YTFWYkpnZC91OStPOFZZSnkyemR5VGJSQXNaY0JwWlRENzBqdUlrR1dmYTFu?=
 =?utf-8?B?ZzhuWXF6QUxneitRMmwrMmdHNUYvM2JlalBBenNIcE83dUpZUC8rMHVNcFNK?=
 =?utf-8?B?YWdFNUNQUUIrRjFhNldVeWJvUTBpazFpMllyeTVKWnVKSVkxYXhxNTVIMEFI?=
 =?utf-8?B?N2MxdXBadVo1TzlmSlkvTjlTeklvRWd2WXkwajFrZ0pJTlgrSnFYbE8zdWZU?=
 =?utf-8?B?bWtHcU11S2hEaDlUc2JwV1FRTTNwWTR5ZFp2S0ZPVXlvTFBDQUx2N1lBbEhE?=
 =?utf-8?B?MkRCUXlxREhwZnMrZTV2eXAyeWpZRVpUSDRSQ2R5RUQ5SEJRNFY5eEhIaWts?=
 =?utf-8?B?T0RGUnRNQnNGbkRNdHN3bUdXMHZhQkltSUJ3TlZvc0FJdnpnZklzTVozd3Zw?=
 =?utf-8?B?ejV5NUkzWFAxNjJ5dG55SnIvWU85VGJHelZjRjRiMWxOaC9WV1M1WWg2RXNN?=
 =?utf-8?B?Vmp0MFdxUllFSWNjV2FnT3haNkRnSTAzZkkyS2xNRUU1bUJRWWNhZFN5UmFm?=
 =?utf-8?B?dDB2R1hZUjlieGQvOGNNUnV6SVFlbjByODY3RWFJVDR3dzJ2MWNCRXFZUGFN?=
 =?utf-8?B?RXJZelB6aDlrVXErcmk0dXJXbVBWMzRsbHlJUHhZeitTZWF5dENTdkxoMG41?=
 =?utf-8?B?RGFab0F6Q1ZneGFtU1VhM0hOb0tKU1JZYmRRMTROazkxazQrR2IzMFBSeVgr?=
 =?utf-8?B?NlhHLy94RzVTS1VvV1hlU1ZLT0dONWUzY3RmMmdFcmc1VWswU3FtZ1VmRjlp?=
 =?utf-8?B?c0xpV2VZc1FOYmRrenQwUGNrMGFzTG9jWTFlZnViWWVWc2J4Y2crcFdHeEtW?=
 =?utf-8?B?bzdKNEhzN2RyQit2ZFZVdzdRVUhHYzFwVURTdlpCSTFpUzRhRlN2UFk2K3lj?=
 =?utf-8?B?a2JHa0VtNC9OMjYxWVhYOHMvMEErbm52WFpDVi9FSkJQb293MVp5Rk9VU3M2?=
 =?utf-8?B?ZWNBSHRLbUZJOEt2OHFpU1dIVlVvOUVJMDVxK2w1aFdzUkxqdWp1bnZ0SVdi?=
 =?utf-8?B?OUFkeWVFRG9rYUJKakxjb1JOZHdnU1NseDdnc2FDWXFuZmEvYWcxTStoM3Vt?=
 =?utf-8?B?WnhraW1Jc2lrTERxcS8vZ3o3WitDRjZEbDdERHB4RjJSaGs4SzBsc2hsa0FM?=
 =?utf-8?B?ZUh0RXl3VnNVU0VFbXRLV05pU0FST3hrSnFnTWY0d0QrekdWVWc4dDVTTnU3?=
 =?utf-8?B?WEx3YkF6UUhySWdFUndRdjQySHBzNlNNY2R4Um1HTEVnUGxNZkxoV2RkMEp1?=
 =?utf-8?B?YUNxMVpZRHNQTE1XeVU3UWdGSGMzc2RqTGVmU3B4VFdob20yekpsR2ZVV0pl?=
 =?utf-8?B?MXVzYlRUcWtQd1hOeXVSR2pMSmg2ZU9hdTlYL3VBMC9lL3ZYWWJCMzdJcldW?=
 =?utf-8?B?a04vSllGVTVrMGZGOVlFVTI2ZGExenNyVE5yWUhjaXZ6clBaenlBNVR0Z1d4?=
 =?utf-8?B?S3ZYeGhEZDF0NlVlVGg1QklSVkdMZzZqMGFzVGMxTlBOT05VV2dSWTljQUxs?=
 =?utf-8?B?R3dSdTZheUtWRTFnREVvcE1FRFJwaldWWERBUmpkU2JuZnVVNWxCcVJHM2tK?=
 =?utf-8?B?T0NtZk1JYVZrR0hPS3dvTTRNeWluTHFlVTd0K0FybkhMb0dITjlVTTdpamNj?=
 =?utf-8?B?TEhjTTFobHZGbHpDOEJ5akVZTzliR1FlMmQ0VWZQZU5ORjRNek1qMXRuQnpV?=
 =?utf-8?B?Y1lIdDhJb3F1aFErWFFMS056enk5ZmRhTVo5MFNwNU9oUDRWMXNQR01Fa1Er?=
 =?utf-8?B?TTVLZVdTSjlLdWcrTmJheGlvRk1BZ1NlRmsvS3NYMFN4dkdvTlF1T1dkM2d2?=
 =?utf-8?B?UXY4SWRaV1J3RFpqa2hlTzZ6TnpRZGVlVXpqdVREWW5oTE9lQWpnOHEwSEor?=
 =?utf-8?B?MUtNUHBwMnY3TFlCNHRFMDdUZWV2d2lBNVhWT09KbHB4VXlTTmhqa2ZOeklo?=
 =?utf-8?B?eHljQjE4cENtdFNXNCt1cGZvWldRSm01bnk4b0VhZVZiR1E5bnN0TGdoQTlL?=
 =?utf-8?B?b2laTk1DS1BFbUx0RGN4SHV4S3VjTURYTjB5ZVA4YXAyU2wwNXlBdz09?=
X-Exchange-RoutingPolicyChecked: 5OSlHLVsD2VccdgQzh+5HeyQX1+2V8C0n7RPg/AQS4YujBlYZuFwzL4sAU60pPI1cJ8fWz5cADm7hwMUbzkixNkn0TKHHAyp/3BEgG4Zrq/hF33hZyDYs9vIi3ZBbr1Waie1w2Ti3dFm3nfSAEXGOhq3JTiRic46P1p/sgJLE3YUUF85lolelDkb3b4bRJTzsANrr3kW3dXlmLA+a9xEShdyVzm5BpanazcHOx7zad+Jn3IgZtMgqLvTEl9nNsWghN1MLNcY0MTnANTad4z2jQP+zGYuZLMmNRAMmUS+grKbailHeuja8OrsAiKM/Cbcdh9ZJzBTMtJmHMtUsDc52w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 810ed475-cb47-410b-3bfa-08df3784e0ea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:36.0579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOwsPHlzjFU4UQqGoh7icJ6RvjpeSVxlRHge0mUc75Rn/FW3tXmcPpCKJDxCGY82+P/AW88b/kU1Uzt1xT0cdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: -DeFdweUtAt49DdqE1t5ft4efC_0DYHP
X-Proofpoint-GUID: -DeFdweUtAt49DdqE1t5ft4efC_0DYHP
X-Authority-Analysis: v=2.4 cv=T5EZ3PKQ c=1 sm=1 tr=0 ts=6ae640ee cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=ModqzXLkJJ0tFyq98apW:22 a=MvuuwTCpAAAA:8 a=eotzTSYjfblQzw7aBGQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX4DawdMRlH1eG
 kq9Qii91MaN9Geco+2uFsyeLzaQtcbSPwpsL2IqyRjVrEzCZe7OiaSv7WgcFt0Nd8aqf653Qajq
 qF1BdEYoiPTi3lDn3+MKwzPtT7xCh0t1scp0qjsFJpNtVXjKVAmztSNujiNJTQnVITes/NOlt8a
 hA0g9s4zG73eYWEjxF7GUYRRd6azwUA6Y25BdIuePWJfw6xeerX/O5X1WbqSpn9wiRwzgP+dXez
 BRrI6piNBDAxB37BwUeCHOwK7Vja+86B/oT55Jw1p0v+8yaUh/A+dCdbvtdjW3ZSdWkBEyPCWx0
 7yWC2hVPjOu1cysJOX2Z4bqD6MT7u/lE+X+dE1HPtAWq/IDyvvh2DSWZaaXvQ5dNBG/a1PyWflE
 t9rsffINKjZLhH0mdrUP28BCnNzgvq6w+yLXdeXGB00TkdNqLUJQEj4H419A0dwGIAmij1RePBn
 n+O2g0Nbegk4T5KffJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX8rGyq8mh2DVh
 EgtckhiE7CupO+FBMC4GM2o+1ohDcu/7vDoYVmF4zBE3ay+UmAQOdINJbtJ23exlz7YNiUwQq/w
 R2X4T3NaPRrBFNMkRH6drpk/ixldftQ=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0
 phishscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310077

Expose the counters read extension of the kernel.  ibv_read_counters_ex()
reads a caller chosen list of driver defined counter items into a
values array and, optionally, a timestamps array holding the time in
nanoseconds each item was sampled.  It is implemented with the
optional ITEMS and TIMESTAMPS attributes of the existing counters read
method, and is dispatched to a new read_counters_ex provider op.  It
returns EOPNOTSUPP when the provider or kernel lacks it.

The new provider op and ibv_cmd_read_counters_ex() extend the private
provider ABI.  IBVERBS_PABI_VERSION is deliberately not bumped: the UET
series this is based on already raised it to 66 and 66.0 has not been
released, so these additions join that unreleased private ABI.

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 debian/libibverbs1.symbols               |  1 +
 kernel-headers/rdma/ib_user_ioctl_cmds.h |  2 ++
 libibverbs/cmd_counters.c                | 25 +++++++++++++++++++++++++
 libibverbs/driver.h                      |  8 ++++++++
 libibverbs/dummy_ops.c                   | 10 ++++++++++
 libibverbs/libibverbs.map.in             |  2 ++
 libibverbs/verbs.c                       | 10 ++++++++++
 libibverbs/verbs.h                       | 17 +++++++++++++++++
 8 files changed, 75 insertions(+)

diff --git a/debian/libibverbs1.symbols b/debian/libibverbs1.symbols
index 61ee1e16f850..9b7d95924571 100644
--- a/debian/libibverbs1.symbols
+++ b/debian/libibverbs1.symbols
@@ -136,6 +136,7 @@ libibverbs.so.1 libibverbs1 #MINVER#
  ibv_rate_to_mbps@IBVERBS_1.1 1.1.8
  ibv_rate_to_mult@IBVERBS_1.0 1.1.6
  ibv_read_comp_cntr@IBVERBS_1.18 65
+ ibv_read_counters_ex@IBVERBS_1.19 66
  ibv_read_err_comp_cntr@IBVERBS_1.18 65
  ibv_read_sysfs_file@IBVERBS_1.0 1.1.6
  ibv_reg_buf_mr@IBVERBS_1.17 64
diff --git a/kernel-headers/rdma/ib_user_ioctl_cmds.h b/kernel-headers/rdma/ib_user_ioctl_cmds.h
index 8de110b8db34..9ee083eed044 100644
--- a/kernel-headers/rdma/ib_user_ioctl_cmds.h
+++ b/kernel-headers/rdma/ib_user_ioctl_cmds.h
@@ -404,6 +404,8 @@ enum uverbs_attrs_read_counters_cmd_attr_ids {
 	UVERBS_ATTR_READ_COUNTERS_HANDLE,
 	UVERBS_ATTR_READ_COUNTERS_BUFF,
 	UVERBS_ATTR_READ_COUNTERS_FLAGS,
+	UVERBS_ATTR_READ_COUNTERS_ITEMS,
+	UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS,
 };
 
 enum uverbs_methods_actions_counters_ops {
diff --git a/libibverbs/cmd_counters.c b/libibverbs/cmd_counters.c
index 8964fed5ea1b..d6fd18b39429 100644
--- a/libibverbs/cmd_counters.c
+++ b/libibverbs/cmd_counters.c
@@ -76,6 +76,31 @@ int ibv_cmd_destroy_counters(struct verbs_counters *vcounters)
 	return 0;
 }
 
+int ibv_cmd_read_counters_ex(struct verbs_counters *vcounters,
+			     const uint64_t *items, uint64_t *counters_value,
+			     uint64_t *timestamps, uint32_t ncounters,
+			     uint32_t flags, struct ibv_command_buffer *link)
+{
+	DECLARE_COMMAND_BUFFER_LINK(cmd, UVERBS_OBJECT_COUNTERS,
+				    UVERBS_METHOD_COUNTERS_READ,
+				    5,
+				    link);
+
+	fill_attr_in_obj(cmd, UVERBS_ATTR_READ_COUNTERS_HANDLE,
+			 vcounters->handle);
+	fill_attr_out_ptr_array(cmd, UVERBS_ATTR_READ_COUNTERS_BUFF,
+				counters_value, ncounters);
+	fill_attr_in_uint32(cmd, UVERBS_ATTR_READ_COUNTERS_FLAGS, flags);
+	if (items)
+		fill_attr_in_ptr_array(cmd, UVERBS_ATTR_READ_COUNTERS_ITEMS,
+				       items, ncounters);
+	if (timestamps)
+		fill_attr_out_ptr_array(cmd, UVERBS_ATTR_READ_COUNTERS_TIMESTAMPS,
+					timestamps, ncounters);
+
+	return execute_ioctl(vcounters->counters.context, cmd);
+}
+
 int ibv_cmd_read_counters(struct verbs_counters *vcounters,
 			  uint64_t *counters_value,
 			  uint32_t ncounters,
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 6c3e73f37037..8327550231f4 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -530,6 +530,10 @@ struct verbs_context_ops {
 			     uint64_t *counters_value,
 			     uint32_t ncounters,
 			     uint32_t flags);
+	int (*read_counters_ex)(struct ibv_counters *counters,
+				const uint64_t *items, uint64_t *counters_value,
+				uint64_t *timestamps, uint32_t ncounters,
+				uint32_t flags);
 	int (*read_err_comp_cntr)(struct ibv_comp_cntr *comp_cntr,
 				  uint64_t *value);
 	struct ibv_mr *(*reg_dm_mr)(struct ibv_pd *pd, struct ibv_dm *dm,
@@ -819,6 +823,10 @@ int ibv_cmd_read_counters(struct verbs_counters *vcounters,
 			  uint32_t ncounters,
 			  uint32_t flags,
 			  struct ibv_command_buffer *link);
+int ibv_cmd_read_counters_ex(struct verbs_counters *vcounters,
+			     const uint64_t *items, uint64_t *counters_value,
+			     uint64_t *timestamps, uint32_t ncounters,
+			     uint32_t flags, struct ibv_command_buffer *link);
 /*
  * Adjust fork protection for the given range. Return 0 on success, or a
  * non-zero value on failure with errno set to indicate the reason.
diff --git a/libibverbs/dummy_ops.c b/libibverbs/dummy_ops.c
index 7a83b1da9d45..fee27c1f6687 100644
--- a/libibverbs/dummy_ops.c
+++ b/libibverbs/dummy_ops.c
@@ -616,6 +616,14 @@ static int read_counters(struct ibv_counters *counters,
 	return EOPNOTSUPP;
 }
 
+static int read_counters_ex(struct ibv_counters *counters,
+			    const uint64_t *items, uint64_t *counters_value,
+			    uint64_t *timestamps, uint32_t ncounters,
+			    uint32_t flags)
+{
+	return EOPNOTSUPP;
+}
+
 static int read_err_comp_cntr(struct ibv_comp_cntr *comp_cntr, uint64_t *value)
 {
 	return EOPNOTSUPP;
@@ -846,6 +854,7 @@ const struct verbs_context_ops verbs_dummy_ops = {
 	query_srq,
 	read_comp_cntr,
 	read_counters,
+	read_counters_ex,
 	read_err_comp_cntr,
 	reg_dm_mr,
 	reg_dmabuf_mr,
@@ -1002,6 +1011,7 @@ void verbs_set_ops(struct verbs_context *vctx,
 	SET_OP(vctx, query_rt_values);
 	SET_PRIV_OP_IC(vctx, read_comp_cntr);
 	SET_OP(vctx, read_counters);
+	SET_PRIV_OP_IC(vctx, read_counters_ex);
 	SET_PRIV_OP_IC(vctx, read_err_comp_cntr);
 	SET_PRIV_OP(ctx, query_srq);
 	SET_OP(vctx, reg_dm_mr);
diff --git a/libibverbs/libibverbs.map.in b/libibverbs/libibverbs.map.in
index 51e8b85db478..0301e32d24ab 100644
--- a/libibverbs/libibverbs.map.in
+++ b/libibverbs/libibverbs.map.in
@@ -215,6 +215,7 @@ IBVERBS_1.19 {
 		ibv_destroy_jkey;
 		ibv_create_ah_ex;
 		ibv_ah_to_ah_ex;
+		ibv_read_counters_ex;
 } IBVERBS_1.18;
 
 /* If any symbols in this stanza change ABI then the entire staza gets a new symbol
@@ -295,6 +296,7 @@ IBVERBS_PRIVATE_@IBVERBS_PABI_VERSION@ {
 		ibv_cmd_query_srq;
 		ibv_cmd_read_comp_cntr;
 		ibv_cmd_read_counters;
+		ibv_cmd_read_counters_ex;
 		ibv_cmd_read_err_comp_cntr;
 		ibv_cmd_reg_dm_mr;
 		ibv_cmd_reg_dmabuf_mr;
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index 2f73c01fec7f..1df4dbf94dcc 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -1034,6 +1034,16 @@ int ibv_read_comp_cntr(struct ibv_comp_cntr *comp_cntr, uint64_t *value)
 	return get_ops(comp_cntr->context)->read_comp_cntr(comp_cntr, value);
 }
 
+int ibv_read_counters_ex(struct ibv_counters *counters, const uint64_t *items,
+			 uint64_t *counters_value, uint64_t *timestamps,
+			 uint32_t ncounters, uint32_t flags)
+{
+	return get_ops(counters->context)->read_counters_ex(counters, items,
+							    counters_value,
+							    timestamps, ncounters,
+							    flags);
+}
+
 int ibv_read_err_comp_cntr(struct ibv_comp_cntr *comp_cntr, uint64_t *value)
 {
 	return get_ops(comp_cntr->context)->read_err_comp_cntr(comp_cntr, value);
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index f887dc5bc356..1bb680b7be39 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -3484,6 +3484,23 @@ int ibv_inc_err_comp_cntr(struct ibv_comp_cntr *comp_cntr, uint64_t amount);
  */
 int ibv_read_comp_cntr(struct ibv_comp_cntr *comp_cntr, uint64_t *value);
 
+/**
+ * ibv_read_counters_ex - Read selected counters, with timestamps
+ * @counters: counters object from ibv_create_counters()
+ * @items: counter numbers to read, or NULL to read counters 0..ncounters-1
+ * @counters_value: receives the value of each counter
+ * @timestamps: if not NULL, receives the time in nanoseconds each counter
+ *              was read, as defined by the provider
+ * @ncounters: number of entries in each array
+ * @flags: enum ibv_read_counters_flags
+ *
+ * Only providers that implement the extended read support it. Returns 0 on
+ * success, else an errno value.
+ */
+int ibv_read_counters_ex(struct ibv_counters *counters, const uint64_t *items,
+			 uint64_t *counters_value, uint64_t *timestamps,
+			 uint32_t ncounters, uint32_t flags);
+
 /**
  * ibv_read_err_comp_cntr - Read the error count value
  * @comp_cntr: The completion counter to read.

-- 
2.56.0

