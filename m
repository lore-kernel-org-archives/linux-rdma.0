Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452721;
	b=HiqSLCZ019E6kcseSZ9gIE5bWaa8nvERUq9vhmlKqKiE4DLDRdzNzjkJ45phtUp1isXR
	 m2RL5a9TjuS1OKa5V4fk+XInr40RzPk/dcC4X0vxdyHhuBEl9Y17rKqETZKto49DiCGdV
	 CBA+0FSZyvuoG7Lg2/6DP0XxjT+f8WvvY9EaT/+v1JEFWQxG9EEApfowhZ+mrEQz/L351
	 ZJmZYDgQfTkXOeDLVKq/f62nNAoIIgCSIIR9ICJC0QFo71nlAvwRC3oKG/Hsy0eWBB0h6
	 T7L4SEECV8wJqutJkphYSuy3dfoCTOnVQ6v1zh58d8B/63xU2PzNm7ellw9AYEHoecQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452721;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:x-mailer:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID;
	bh=0N8R3P63jzj5uH75YzMK/Ixe/8m61JajG4W2/ww6bcE=;
	b=haPbPSneMIl8gJrnOc0AByF0TrgY/ukdzW2r7MkE5WwaI0l2BphC14zPU8sFmh9ztl2d
	 Hm+1fWDk+qx/zmuQ4BhkQP6AlLwvNtau+IWy5XAqzMEKMh1tottWsWblJqTiNStnPIrFC
	 AJL20w22p8tTGPofpkvVRteMbaP2rVb7OPqCNfBBmF75P80WfC8s5thwjtAGzaaMfXaU3
	 l1rCNcW2StplTbSrI+EIS8g325CLRJdTUnhi4OIW3hJdSA+DRwboADQc+isoXaJxIdK0D
	 4/n2xXlStZQ3Gm//18U1NWwD1tnCR+R2WZcrWyunGEOmj4erDTd8wEYLDuXFmAj+bHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=ZWSn5foe;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=A1KlQ0A0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EED606A319;
	Mon, 19 Oct 2026 23:32:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4EED606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=ZWSn5foe;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=A1KlQ0A0
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JKtxH01277396;
	Mon, 19 Oct 2026 23:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0N8R3P63jzj5uH75YzMK/Ixe/8m61JajG4W2/ww6bcE=; b=
	ZWSn5foevja4im8kcrvF6p8YESoVwGS8VtzEbQhzi15v/Wu4s+bAHDfw1cug8WPm
	XSAl5UvCGAfpqp6cPKclbqIdTiaBa+gwZ+GqGgKPtFq+lmJYmFBHhTPXQoh0co2J
	dJ0b+rdJ4JvJVBfcps+AhEeFaBz8ItEOewPxAmzlEM+5DK59bFzdXv6plHeraaNt
	MwefcanPYOi61h6gPTqi2L+8A/LqcsY2Thx2F5+2D4lpsJ/32K5bVfzTlZzTdDV2
	hCLode48f77/TSix4PlHLIODl6CLQexvj9qtAj4QdOWv3F4PzDoNYZKG717L9+Qi
	WEx4eiYqCBtNoCi9N7ay4w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hbykxtwgp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Mon, 19 Oct 2026 23:31:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69JLYxpv3472901;
	Mon, 19 Oct 2026 23:31:47 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012003.outbound.protection.outlook.com [40.107.200.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4hdsfypgf5-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 23:31:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AL5wWrKXybCPoqAnjzsWAzzeewWm7XB5W+Eiq+kdEHeb8tv/2u2S4eaMMnttAUQUlUmXCwn+N4rgZ82vAGwrF8VOK3A8NE106F9P/kU6fpnGA568bdvgXPdq9K+2/JVuEkFEuHVdyHnL/BhLbR0HQ66nXYpOFdei2o1SGhE2Z8HxW0CdcCy1ZXtix1WFtcS8sLmWir/D1iX8pa/qXKkMQgDMcPmEKMuVCE3ImlV9k6D4uCT023QoZ1icG0EnIBZHNRyRTLC49RVCuRuy46eEYVe2/caLHmFyh4G1fx6iH14h+zsIOIbeEXDWLHqCv14fKxa2mdQtfamTXpkHaldcuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0N8R3P63jzj5uH75YzMK/Ixe/8m61JajG4W2/ww6bcE=;
 b=E4nE0gNgAIpJfvVLDV7UNCw48N0gkyTeFapEL8Bwjy2c+4JoRt5tZrc+hHXmSGbrU2bBri4R23S6EVdwFhACTRdu3AuhQdgyWd81hlrj/p0f+dfQmL8V1LKlyOUSgW8+YUWsUqgLPooy+wCCDp+P1UqIRfgpbfrud6A/FNDwCy3QYpDGzuxdLSDjxQhYE/ruL0CL1H/QmFRM/xAVPlNFnzlVdfFqtv7EAc9CeFmY9zyyxkuW6ed+cjS2UPebHlhX+vcj/gcG1iTC366duxTkupqPkwDVeLrCFkHfshHl8LObRg/8hOSRsnxt2wHWEIoV9gVRbxX+He9QgOunAzDMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0N8R3P63jzj5uH75YzMK/Ixe/8m61JajG4W2/ww6bcE=;
 b=A1KlQ0A057HdwFhMm5A2MXqCKcN3TfqHFme3ML1zsejbZE6D5IO4ibHzpKreGgNwKOQoSwQ+PsftK1ifbydMmxzRMC2uS6SlR2OzBRAT8W7xP/a4VlVxELcfxzd28Gg6N52akiuedS4oQ4dcwqG3GynwONQiwrjwAjFzwvrEfUk=
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by MW4PR10MB6321.namprd10.prod.outlook.com (2603:10b6:303:1e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Mon, 19 Oct
 2026 23:31:44 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0522.011; Mon, 19 Oct 2026
 23:31:44 +0000
From: Gerd Rausch <gerd.rausch@oracle.com>
To: Allison Henderson <achender@kernel.org>
CC: sungbyeongchan <tjdqudcks0424@naver.com>,
        "David S . Miller"
	<davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate receive
 completion payload length
Thread-Topic: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate
 receive completion payload length
Thread-Index: AQHdVfkYeaU81NT5tUOQtAB1MDRwlLcAqzQAgAIukICAANhfAIAB2JiAgAANUoA=
Date: Mon, 19 Oct 2026 23:31:44 +0000
Message-ID: <24EA8C76-879F-44EA-AA15-E95E7C11C339@oracle.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
 <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
 <7e69b862-7cad-443f-912b-ce2db7854d60@oracle.com>
 <f1504e3ae8da8789bcd6cd474ce51fec7dd15555.camel@kernel.org>
 <30C797F2-FB1B-494D-8E36-B50C58BB8A03@oracle.com>
 <b5ed40d362375f5e93669a974b1ca03b716afa2a.camel@kernel.org>
In-Reply-To: <b5ed40d362375f5e93669a974b1ca03b716afa2a.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.700.51.1.3)
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB6050:EE_|MW4PR10MB6321:EE_
x-ms-office365-filtering-correlation-id: df09d0c2-14b6-4195-27e6-08df2e3922f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|18002099003|22082099003|3023799007|38070700021|4143699003|261009223027099003|10067099003|56012099006;
x-microsoft-antispam-message-info:
 PN4qkp21YKFvLsG5dEUn9BviZF6ieTnDVy+Ks8NbFGrFgPGZeEJcYCNlJURXU1NP6seH5EwNiYLSEFC7btB82jKHRPkaPdEYOML8j+e3MhSavnHGQlGceBDp74k62rxyBtVxeQ63YQMQF8ZA7Sstr+xvrywW1eR4Du0YV1aA0+GnRZW8uqiXYg0oXHWDudwT1VO4cnoRvII/8Jm1ZlIWl3+lwFOhe/dAmnl4aoigCfbu0W6sF0V547zxnI/qhBPkqX++PI5I6JW6pMuJUhSEIS57ZtbyjuEpV97lrp6uhHCoRdPILyaTxUZXhobEBkg0soItJOojuwK+TNdeSrQDB9nqwvB18RKlTabRHEXefKkldEbSHq82cmDcoSRTkpMdJR/nrPPpOslnaA1WIfeFhRYcUfPAHch/PrWDt3C4xrSZh59jHcwYUvyZdrq1868RAFLDxjWcB6olH9zWQjYgB0xaHr1JO7YMOb3dtlSCB2ht+wSLJFZ96fFptxnU0MfycPv0/u7e4sKy7wR49QakXncecMdwGumZL7b9ggl+Nyb+Q+S777kSXOw6JHTVQONzDtNpOR5ZDtxwvuFEbODR85uvyCetgb/sjtQezrTbibpzhNi9XyAC0sLBdcLAGnkr8rWCieXJJlk2CzmJSo69E5EWw4s2kxcCRAlPEV4Pj9lQXu7wkuIIbNw9l9iFnwiuRku+mXIZq+1r45BXiQhc6EAyhyh47611E8XbbhWbesA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(3023799007)(38070700021)(4143699003)(261009223027099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?JLayNUxotR+OIExN3OL+75Tdc50GUPIvJapWT7yKwdBwdaxU1r3fRZ2qcSrl?=
 =?us-ascii?Q?Wf1duT9E9FP0dr7hk+0nvFOeIr6KcVCaXq3JQd1Rh9WxqLWYfE80aS2tR4Cp?=
 =?us-ascii?Q?vM0pHEpq/r6lBxkGVWO9g+pPQ9wT+zlK1bBVnBOJS3HPh5DJkUJJtED5i5c8?=
 =?us-ascii?Q?O++J7rlRRAfnzUsPFJSbhXmj4PX9YF7lauJj17d6ZztS/7cscq7rJl9jtjSP?=
 =?us-ascii?Q?6cc4+ge0TGD953eu4Ul2a5bO7sh9CpB1iT8TQL6kfN/w1feJ2T5IPrYopekq?=
 =?us-ascii?Q?2xLdvCzuAf1uLGROU55AJH1OEvMWIW0twsjifJwlEdcLuMsUCPv5zgKjZGVt?=
 =?us-ascii?Q?J1wv2+jwwOPkSj9STOQcIrrVcnxSdhfJnFgGru2rRnBs9Cv7xJdZQQAXC+/J?=
 =?us-ascii?Q?oq/sJnS6py4KzF6NMVHzrhPB4jujuKGp1c9uDQIFqBzR/cm3voZZiC3U0Isn?=
 =?us-ascii?Q?nyzNHOKlONwEuIAWal0eY7qAlE1Yrd7X+iWrUYXQGfUr7qfLOhIbxfijpIn9?=
 =?us-ascii?Q?MpGoZ+LJ5tIrX7cF9TfcGBoNfJPpOAm9jkfblL22xcxQPxm98aqn1uvQyL2f?=
 =?us-ascii?Q?igQMdb1yeDqIJiTNpVsq/HPmtpjDzZYbBwi6romKp3JFD9mg27xOucda+qPd?=
 =?us-ascii?Q?VVARmwBYCjuqvqw7v8m5v2l4VCXqRQuDgYUPdhe30PQyfNDB11wPErFopzOA?=
 =?us-ascii?Q?22mzPBYI6iCpECR1QMvMkOKaHo0lPz/Wm0dh3t2Wy409AsEfgUy1CXsNSDiD?=
 =?us-ascii?Q?m7zetdQm9VaXqZdR3Rtn8k4Ewc86Vd9fu6E8b+0DWUqinAwVu4jR0lbvUh3k?=
 =?us-ascii?Q?Bx+3gIY0CkVL1xO8o7pKjzKk6czgQmwPHvmp+yeA/aQhq9AfzH8K4cn3vYHh?=
 =?us-ascii?Q?wvNZc1Xot/tE+ljmwQKWcx8cwokBbNpxS2dohAoHf2r8E1oMoMtKxd5bLjM5?=
 =?us-ascii?Q?KRffN2Tb3DpKCs4hhWtSK9+8iKmdek/GxzeIC9x9Je9/VkJnz0gsNbwnQBiA?=
 =?us-ascii?Q?NJW1Cjtb2FmsSTeIE68UP+AKP+3F78sgz8iMZliKVLFaxOboSr/aNPTUxfZ4?=
 =?us-ascii?Q?hXyghviyf+/ldc75OCh1yZweJhT8GJxE79Gta9D9y3y6uo4SVp0fwly2Pqet?=
 =?us-ascii?Q?VVnbP8btZmSvS3HAE8Tkl4dSHrk26uGoHPjHywgcZcMHvZIn5YVhjfUr+1Ad?=
 =?us-ascii?Q?ose5TIerLMYl2QenjnxiYei1oT07A9ZaFcnaQnqxh9w6g8w3YONIV330LBgH?=
 =?us-ascii?Q?3Vva9GSz+m7Iv7cGTixxHgBrPTXTi9ACWCwWOMlgkTKfyKWjtlx1/X9Ll3PH?=
 =?us-ascii?Q?6TfomC2xuOldwvreXTyak6a4mdzHqi9YIUqSYnEB/Q+/pSUoLBj1XYQxgHfp?=
 =?us-ascii?Q?b/guUJaK2Z3ZYQUss9CPUKrPtsCxOtIXb94GfC7Ur1aFZ4cNY8pC90F9uV1E?=
 =?us-ascii?Q?Vw+yQ4tLztsGqKucQttLKx3k86tJXvclcO4kP7USxldrBE75mVMy8Y8GaMwf?=
 =?us-ascii?Q?Lbu7tU+y/WX6VBAiBycnC3iI3td5Jo1FNnW4hBURt+YDfYWTlj5fAtrPdJEi?=
 =?us-ascii?Q?2ROFWOwcXpvbUJg99w713bTDOjB/ayGR3kPTO1UgGOvhtmA8lpeY/LD/s7sD?=
 =?us-ascii?Q?H2Mog7cLrY50POeuiEJBPW6Y7A0whCqce0+/k4QsFsWfjEF4ZfVcd4lD+ofE?=
 =?us-ascii?Q?8s6UQkPRXVWYdIZQZwafEuzWWLM6E51kXV7mfxvyVQUsfQFk8U4A1mz7qVvK?=
 =?us-ascii?Q?FZ9Q/dxjVUFdcEjF99GAmQTknlSNq00=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC9F7B494943E44DA12A0BF0CA727884@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	adfsYI+3wwBK44R3MS9p1yKnQdeiuQ3INWdlj0X+2exqo8Fu1NwPta0sXAbsqV4vltGCE2dvgiM3dc5X/b4MJNp1K8Ww0b5M+2l9EgY5DWuGNNLmRF/bG2tC/2JAx6mjd9DIMEy7gKs57zBULUlukNWwG4HmUIZXpBW6VEOye2r72agTxqR+RZJnv+KcuwKFLnMcsvBxfSjx3NPk01otRLsECi84W2USKo/TzZhBioReltOzOxvaYO32UT0kfkT62ImFrpoyVnhzr/D+odbuEiv1vHa/FCv65OgcAxgGDZCQ4+9viNP7Om6Q6MWQXmts6mBo7StmaXOM841wP+g8RQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MtYrs3GMGXOr41fmiVWMRtQriOa6aeR99DaTUUh+BmYY8EnJZ/YHOptCy29D8vecgMs+f/+ZoUvTBAYgUvQz9ERK4AJOi9ogKzVUgA3gRwk2Zi4aaer+SI/agO8ufGvOJjr9m1kr75Ulbl7+tBM5nfLGylFKvxhQhL0jXn1s9jxxjKZBP/4uhj3DALk000z2gpGPO+1DC7+yUXi9827+hZ2onWVgLVBuha8/UnEx2KmYDdZ7CO3E4y6U6sMo2Z6zn5m1+3WqSIm+jyq2mbCE6rr4gFaG22qUSWtwOS0UfHo2iDI8ETdI92nEaPSYZ+T9/VAGOlQ9rkVFRHfHXuIPOp6zGbKxaQeJt/M7B8WuygK6I8MPO/5u+sG9PMk37Ykf14cdcUl10joGSuks0B5xDQ0ZGvRMi/tReCseEi/AGXxkMyuSkusBy4BfRsq6ioej2kAiP6EuMXgsMAdF7lnyR4X/rKr2TiOWzNPaecxdfJNEcxus0p7987tLW5dAATvBILfO76kmMkuqyml7DN/Xo53nUsxYJc2tD8nrIigheQtHTUB2bshahMrn1FK1JJAj01+Yfuht+XbJ+yVSIDvmQfcEnAA3YlLXVZTJGuEU/AE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df09d0c2-14b6-4195-27e6-08df2e3922f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 23:31:44.3843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZCrEOfby2WVmlUOGI2uHs9U/iHeamF8YdQgAOnRdF0F47jjMvwa2rE9Bt1frXUYPGwoxN6aWluzFLS/eBmWeXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6321
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_06,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2610080000 definitions=main-2610190093
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA5MyBTYWx0ZWRfX8A7j1G653EY6
 vuFnAntAFK57KvDRIRYGqT69KP7kYU+nwbuRpUvkNTwcRQkTgXaPS6CnnlcDzDbzJIk+dWLQUau
 AFXVdxKD10K0ROYzvlaK9LIy8r8ELmt+5cW2GtZxAIO3EsC/UfeB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA5MyBTYWx0ZWRfXwjvn3TnWBaD7
 1mTovMEnOxH+Ntkdme3p6WmNFGfka2Pb55LpEYSM/W621dQcc6LtIbsl0Yces7ZOEhtLY8MAr2i
 OHHeuSQGWxoZfPwyVhnuy1i9m9ZHiQ3a+9yP4x4u+fqm7I8hmhqd5YVEJWqMxrNoPJETP7e6fis
 tJ/tLIonNYfuGj1ASP3UncEjydJpl5zcmU/FjQuVJC9G3BpxZLWwIi/O4nG7y+w3dVq0i3aRWWl
 sHNcbRiREtN9MDoCDnMRYWi5C5rvbIFgeATBMNdurXjYMyhK+5ij/gnwKBLSOp9e8Xkmu6XtrRg
 DiGkrp5esM15w+qsZfcplBshC0xj0COyXmG4anT62e/2r0HJ6JOi1HA5JC6+Eeqrwn6VvkM3MsA
 D09vtod9GRMPjTipBLM9avs32xrvXzTn8zCBdoSntLtUfMTe2jE/NuPMq54gghdNaGKqb7HiFZ3
 jCqxU3QQnbQMftA7vWF1DbdyS9vUC+E5Zc/hz7tk=
X-Authority-Analysis: v=2.4 cv=BOYmP1QG c=1 sm=1 tr=0 ts=6ad6a864 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22
 a=VwQbUJbxAAAA:8 a=3U3S-sJfXCK01vBAj7gA:9 a=CjuIK1q_8ugA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
X-Proofpoint-ORIG-GUID: mELYtmpuBh0pzLhTuaO3zbIDz8UC9Xtt
X-Proofpoint-GUID: mELYtmpuBh0pzLhTuaO3zbIDz8UC9Xtt

Hi Allison,

> On Oct 19, 2026, at 15:44, Allison Henderson <achender@kernel.org> wrote:
> On Sun, 2026-10-18 at 18:32 +0000, Gerd Rausch wrote:
>>=20
>> Wait. This patch was created for a hypothetical case, no?
>> Based on analysis of "Assisted-by: LLM".
> Per Documents/process/coding-assistants.rst it means an LLM contributed i=
n
> some way, but sungbyeongchan patch had a reproducer and Shubham validated
> it under KMSAN
>=20

I saw there was "a reproducer", but it is hard to tell what that thing did.
I didn't see any source-code for that reproducer.

RDS is designed to keep messages in "cp_retrans" unitl they're acknowledged=
 by the peer.
If the connection goes down, unacknowledged messages are sent again.
It's the fundamental working principle of RDS.

What reproducer would change this behavior?

>>=20
>> This patch does *not* refuse to deliver the bogus message.
>> That would have been a fine choice.
>>=20
>> This patch just drops the underlying connection, in the hopes
>> that when this message gets sent again, it'll somehow be different.
> The short fragment is never linked, and the half-built inc is freed when =
the
> connection shuts down, so it doesn't reach the socket.
>=20

Of course the message doesn't reach the socket.
The backend connection is dropped via rds_ib_conn_error() -> rds_conn_drop(=
).

The message remains in "cp_retrans", and gets sent again.
It's the same message.
Unless there's a transport error (that CRC-32 didn't catch), or some
other non-deterministic behavior, the message will look exactly the same.

So the exact same conditional will trigger again. And again. And again.


>>> A per-message reject would be a protocol extension that both ends have =
to
>>> implement.  But that would be net-next material, and it couldn't help
>>> against the only peers that actually send these.  I'd be happy to revie=
w it
>>> if someone wants to take it on, but I don't think it should hold up a s=
table
>>> fix for a data disclosure.
>>>=20
>>=20
>> Again, we don't need to do that.
>> Dropping the message would have been a fine choice here.
>=20
> I think dropping just the offending message, and skipping the rest
> of its fragments by sequence, would be a reasonable refinement for
> net-next.  And it would make sense to treat the header-mismatch exit
> the same way at the same time.  I'd be happy to review patches for those.
>=20

Why add a wrong fix to "net" first, to then fix it in "net-next"?

Dropping an RDS connection because there was bogus payload is as useful
as a compiler closing & reloading a file again, because there was a syntax =
error.

The file won't look any different when you reload it.

The message that RDS sends again, won't look any different either just beca=
use
the backend connection was closed and then re-established.

> The landed fix does refuse to deliver the message though. The conn drop i=
s
> the same policy the other exits in that function use too, so it's the rig=
ht
> solution for stable.  Patches welcome on the other points though.

I guess we can agree to disagree here.

Thanks,

  Gerd

