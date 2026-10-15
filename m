Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74129270552;
	Thu, 15 Oct 2026 18:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792089371; cv=fail; b=ZY8RJMSMqx0HEFmgHjpU61nsnzIfIvphq49eyClSDJIPMh2/ii76ZQPxM9T0f8FNQnbxWm+ThtlWDr1mFyqSk8p/pGycHraoKXAYS0uQOVvIIh90140zNmAhDejEHVzWUYLMesyn9+G7E2k8C3kXcL6CaejdgiSd/CGRkyNK10Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792089371; c=relaxed/simple;
	bh=eJhVRL7+zGGMYYgyZrZjaMKqmQfX2zEpoMkryF5Z6Bw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LA7yTDkzLa6uTj6yUM+nz2TAcu5neV7h1rjWaOKwHaX/17vLJe0pVp0WWJWjytUcgceBcqU6F8tr9wgS6u7qr6eTWpzvNfk9ZJNHe2PrFTQdQHDLCfdEWrwmnoSaBV6yllN/MBVWraSrZ34L2dPjaoNGfngDuL0f4+OmU0Dg6eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=iBuLcZh7; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="iBuLcZh7"
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FG16Ck1660063;
	Thu, 15 Oct 2026 18:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=sV+96CByh2C5akuExhvAaahrh/
	K8zLI0+6SLaMmkank=; b=iBuLcZh73bWDR8XU/v+vVK2opplVJyoz4RJaojCxPx
	o5bnAc2STofFilbW8tPTYrB6loOADE6bs6ubiYPcodeLHX81j14cbJN4YEV9ROpL
	NSTw2q0IWHl/Ss1lD80K/LYjERGosoJpFSQ2rJJ8L7IPCwl5P/lfN3EDCbv3cnVT
	UBy4CT+3F3NOV3Prr0m7JQGKRlbzIKujHvP+SW6AAiNZLb6FSVsZtbRK3C67G6F/
	fXM4UH6XhsUdsp3xeo0oi48b5zDwouAYWAqI8bNe6ri5lvPrvDljLYhSoUJEOAO2
	8mAMZFcUnRPyyaPns/DZxZdoxqMHTrrl1ZH83l8iCReQ==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hb1gtanpy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 18:36:01 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 7B0DA8047A8;
	Thu, 15 Oct 2026 18:35:59 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 15 Oct 2026 06:35:47 -1200
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 15 Oct 2026 06:35:47 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 15 Oct 2026 06:35:47 -1200
Received: from SJ0PR08CU001.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 15 Oct
 2026 06:35:46 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b3xWE3Wvq0EOmcYEsL9mks4a5obfVEk27Ad1e2ePLW4SYIsIJmzU38dfnXImzd5lAPr1+Gwm98IFdhzQnXtGon0KFF3J7HajPIMG4WNNWbpAY+udgQB4mthsx84ki0SDJ4xfQKZ034R8qu2sh97+LIJqHY+5jL+x5blJig0CZhTWOkFZ5Jus+WHNjdgHe0lBLRS7tZuglX5qwkq91KocEJ7h82XmleZP3ecaeDcLieoZBXAP+SDwEFF9SBt42aH28YZMWj3QMbTt6HzA7zEeNUEvaiHhVgj+UW05/NLk7qdmRKw+4mdYPxiFMRmc/8I4p8gCR2fYCzFQlWpGxJtCCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sV+96CByh2C5akuExhvAaahrh/K8zLI0+6SLaMmkank=;
 b=ehBuF4A22A4ZmiDa6bvHdRs2bmwOWjvAqXI/NoSR+8Wl8rngcIOisH6W5ZWYNmMRET1aV4KyvvV2b2CNyL7DnfxnZ594Z1o+UQg4lO3GrktR+xQTW/2x8Nf6KopHMsO/tK28jOEaTPjf/2trdoAUoO2HTWoDeURlWFt5StKMf+jJlvQ2sjiXkcOAQpKyaI9RNjvAv7UYdiHVvjmQlgfW4ptIirIgCUwtiQ5e2iIeTisLEQtIB+x8I2UTNEq390cbHBWIFB0DzJGn4cCqefmCBTkN0OsA04z8ji0ZWWV3f/m/JkKP98VMPplcD8Psf0BXYz2bQ2Ypq+Df4DSWnT5YLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by DM3PR84MB3532.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:0:43::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 18:35:44 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 18:35:44 +0000
Message-ID: <afba68a0-986f-4807-b6d9-10f8b0518b6a@hpe.com>
Date: Thu, 15 Oct 2026 11:35:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 04/13] RDMA/core: add the reliable unconnected
 queue pair type
To: Jason Gunthorpe <jgg@ziepe.ca>, Eric Davis <eric.davis@broadcom.com>
CC: <sashiko-reviews@lists.linux.dev>, <linux-rdma@vger.kernel.org>,
        "Leon
 Romanovsky" <leon@kernel.org>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-4-a0e626117113@broadcom.com>
 <sashiko-outbox-172001@kernel.org>
 <CAMouMYKADaQjsjeGZZyB+eWvswpf+b_H=aT-VZHVoe=vQFhxZA@mail.gmail.com>
 <CAMouMYKo+z70vA86P5gG-Kz=5TCSUZVfuLS1wAaCLKopze=R=Q@mail.gmail.com>
 <20261015173005.GS14213@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261015173005.GS14213@ziepe.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------V9bj0XjIp4p6NS9t0L2EG45h"
X-ClientProxiedBy: MW4PR04CA0165.namprd04.prod.outlook.com
 (2603:10b6:303:85::20) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|DM3PR84MB3532:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb1a8eb-67d0-453d-cfb7-08df2aeb1fac
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|10067099003|22082099003|18002099003|3023799007|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info: RlnInVI26WT+HivYHOpP719oR4Cm7NesHYgggIhzZ1Q4LQbM6zevVHnLWSqiAe0Pom0plN/3fjeUe0GbKlAhIamm/6hfElp3FSGFEm5Yos4QHOPYLccYRi4fFc5GdDf6oALy3vHu7txDOeoPHJJhVzNTu33HcCLmqSd4iIspyFnb1eCFLcriODKAhCb1A5xCoOVti3JN+1JtnhIdJTrISe4NxbnQSUOXpr70foJGGnSfS1Okhs2q1jUslPNRjVwSeuaX3nePu8zwIADTUFjglFEgCVogo63RZ0XymAZVqYo3zoLSO3xDX1ZLp2zXU5HZLkIqaXR+sBsTqGZ4FgTUnx6rWcxTqqmNT4bzHRu/ClHi1j6Sg4lD3h0zxRglFgo7/DCvuqrjhJ3vHpYDJlAIi4709p8McCqRneiZBWb8SCEp1iUdOGkVk9Nx3/uucWj3+XhBOqfbGls5a72THT5T1Swbgs1MBkHebFum5AnoV1t29pAyMIsbj5mlOPM6HHoiW61EnGMVNgbl/Tr84ZTGq+CIT7IvbVwfspdVrt9loQkIjZokSStdF4/2BbPFIoU/u38Zq8XgyZYwQhZ2CbdU0BAQp2T2BeDiH8Om+CbVTts/J/PMdxFy7uQQiz31tLY9XOwsNaC0YrdBWA51fmpIfabS+7fqIiOrD7EsvJrgjyQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(10067099003)(22082099003)(18002099003)(3023799007)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU54SWJhWk52c0p2Mjh2cUlkYysweDJpazF1c1dIZk5wbzFIY24ybDhDUG5E?=
 =?utf-8?B?NUVKN1h6N25oVUV1Z21PYVgwMDIvKzQ0aE4vdXRlZFhHRlpoUUF4K3gwTEp4?=
 =?utf-8?B?RkZYMW41TGkrL2k0aVVuTzQ1TUFmTTNPSERkOE9vdTlkRHlPMGEvbndqbkFS?=
 =?utf-8?B?d2xzTHF5RTNmSWNwWTBSRVdCY3g1Mkw4bVpFdVhBM0YyZmVZMEtBNklIYkl5?=
 =?utf-8?B?RDdBa2RjQktZa2V4cW45TCtvMkhJMlUvWWVGekF4ZldZQjEzcTFwMHcyWXFk?=
 =?utf-8?B?NjBJN2pOSGgzRG1aWGFnUGVLR1RSUTBDVHRHemQ4SGJXOVhBMkxwWm9xaEFB?=
 =?utf-8?B?OUtxWHVYWVJBdnNhMVVqZTBuVndBcUZ4MTV0czBvZXZpMmVHaGF6RkNhYWRQ?=
 =?utf-8?B?TldXL2I5eU14bWZlT3lCVnRQSC90L0xuMXowOWh3Q2Z2a1hjeHpMdjJMa2dC?=
 =?utf-8?B?OE9tNlV3WXlxVVAvSDh4cWs1MytXMzBvV1BXQ2h3T0VTS1JsS3A2Q0Fqemhk?=
 =?utf-8?B?NTNmemVnaXZPK29rSHo3WThiREN4RlMzNHRzN2RXaEFrMHl1NG8yUkdoOUo4?=
 =?utf-8?B?bWJYeW5hcnlXeENHSjFIRDlDRjZhZ2xaNWJSK2NBS1FFc2pXVzBRVytRZytJ?=
 =?utf-8?B?OC9HM05ucVE1dXZGV3FGTVdqa2RIRmljcXQyZ3hmUVBRRmMyS1BobkVFNGZs?=
 =?utf-8?B?TWVFZXZaYzJydnNiUHhrb0k0TDgxZ2tkWXF5amVmOFpDRE53M3orR0pjODJX?=
 =?utf-8?B?aFhZV1g4b1d5ZVBURE1vZEZhbm1rMmZjL2VFME55RTc5UjJNTVR5cS9nY3RH?=
 =?utf-8?B?M01kTWZGYjdsVHRleVpaOVFWdTdIdTZzUWlFUWdVbWkwenEvUU9HdkRvdEVO?=
 =?utf-8?B?bzV0eTFsOVVxOTBjR1k5cnY0cDdPL09CQlNsTDlFcUhFRkhmclN3L2wxMmk5?=
 =?utf-8?B?dDhpVzBlYlZGcWRpNjFNTkhxL09haG5kdDF2dDdDUDlVWDVsbTJURmJaNkQ3?=
 =?utf-8?B?YjgwMWhQa1hyV0xoaUErcFZYYS9aaEs2YzBZMEU3enVzUUJuRFd2Mk5VUFNo?=
 =?utf-8?B?ZTJkRWZBZXk5cGpMS3hjMFV4WTk4V0c2WWNNTk42UXBGODViWS9xZERLQ0to?=
 =?utf-8?B?azJSWHJuRldLSEs3dFg5RWkrY29Hdkc0TjhDcXVmSlZmUVY3dHNTMW5PeFd1?=
 =?utf-8?B?MXhLL1QvSmV1SGYyR3VNdWxuNktNc0lvTVNSd2dPL25NeXJSeHlNRm8xYUd3?=
 =?utf-8?B?KzdheTBmUHpuT0piWnNuYzNCeVZjUVhTOEhRZ1lZM2N0U2NoU2wxZ3BOWlZF?=
 =?utf-8?B?TWo5c0NVSUtSQ1lTU2V1a3VHWnFoN3hFTDJkdzRzcEc3SWc1WDdRR3FjL1dy?=
 =?utf-8?B?V2ptNENBU1o3REVvR0RXZkxSN1JORDlvWCtnRVFsb3JWejNidWVQYWlWUHM1?=
 =?utf-8?B?eDJDQzIrbEh1MGVtK3BEcjRIWkZUdDU5ek51Vy9tM2hRNHhjczA1OEJmYmhx?=
 =?utf-8?B?WmgvTFJ2ZFM4b3ZtVUJnVlp6SEtOTlJPNlBOWkc0ekVpc2NEL3VvNldEYmpU?=
 =?utf-8?B?alhqTDQvMy9WeVdxc1d5U3RIWjRZbmVYSVZRTlBNNHVYZXA0RXAxNmdBYzdI?=
 =?utf-8?B?NUJhUVgrbmY5eC9YT1lma1o1STNma0U4UHBvbWZBNm9UQjlJSnd3bDZSQllT?=
 =?utf-8?B?dkdNcWdIZzl6N2JLRmxxQVZ4VmFYc0hucm9sU3VsNzFIY0RzeVF0dDUxalJD?=
 =?utf-8?B?UTJyd1BYSnlnUXZycktZbjYrZjRlYjdKdnF2ODdRR092T1h0Vmo3NjMrMm9G?=
 =?utf-8?B?S1pMdk5pRkQyT2lRZjVsODNPYmNzM1gxaFl1RDQyblhTOGlYa2YzQjhyWFlx?=
 =?utf-8?B?cXR1eDF5a1VTVW1naXg1V05HVlRDQnQ2cGMzY3lIY2FldEJyWDFuazkwT0V2?=
 =?utf-8?B?TGNEc093THRiY0lHcWQwRGpzZG1SYnVHMlZvMGdhbjVsQlpYbTVRVk5iRzB5?=
 =?utf-8?B?Vi80ZmhtckdEOTlsVFhsVy9GZ1UzR2ZBUm04Tm1vTHJpUTZ2dUxhSWdDUWFZ?=
 =?utf-8?B?VXlpQTVYSG02MGdORmxRZFdLS21lcHNVVG50NnMyWTRGeFRRZ29yNWhueVFG?=
 =?utf-8?B?Q29xbnNXNkduYjZQVkg3WU5jaTRsdzkzUk1rVGRRZGh0Y0JGR0czNWdGbURZ?=
 =?utf-8?B?ckMyQVFwUXhqVTloSnZSTFN2a0EvSjZPMHhhckRCUDdaOTFIWWFtWmJUblVp?=
 =?utf-8?B?eVVGbFNMS01VWHJpblNpNmlPT1hiTlZxU2tXRk05bWNOMkFkalFQOE1aVlJX?=
 =?utf-8?B?cFZPeVZDQzhCT2RlSk5TWCtobi82K1hzMmNjY3RTWXRvYjVPc2Jtdz09?=
X-Exchange-RoutingPolicyChecked: Gxjec9AK+GGQceR+Zf5v68jVYt8Unauswp4e/ov6zEfzkk8F61PYcFKgah9DgYz97Pz+3UAbiawvQqAJ1Nw5chAypE+u2FTy6CPdiVeGSr9KoM2G4lJ5a2lEMrspZE065Kvl8AudQU/DH+Wpjy07BYjPeWffdOyaeu2EhZfCOZ0GnT+Dg7iGTLRqEg+u3wVNZu/B5uawUAM4AlXgAJGiB3MjpFms6sv/SAjZdv365we0iw1szYqS+P7hlmbAosbj3eWIjDkfATjRu/bj/bjD9Kcgx5HPmGrsUNLHAfr+i04YqYdTgVVPNYTdPekBq+LWPuSzw3gPc4pN3mW/e/zBgg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb1a8eb-67d0-453d-cfb7-08df2aeb1fac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:35:44.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miRAhFz+pbEYwQhcVMYxh4JnXK166FlgdwXu3ZmvboGshiARMBptrFyXhi7KFx+XKov7VxRPSjpM5sYFH4chIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR84MB3532
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA3MSBTYWx0ZWRfXyf+WZ63IWI09
 ejH+z5tfFZ0r++xxNdSunjRF1Lna957dn9pCuusaloWGvWM8RxTECrcOgcrMiR9aZNUV5xOC2kQ
 RLpOmXq8PRVsKJfptlBjjKfWTH02gCU=
X-Authority-Analysis: v=2.4 cv=GZaCDgXL c=1 sm=1 tr=0 ts=6ad11d11 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=6XKncaru_qjgLvANlS_8:22
 a=MvuuwTCpAAAA:8 a=u59VQwX4gZTHqb_grWsA:9 a=QEXdDO2ut3YA:10
 a=0l42W1jB9cj_GiQ_xoAA:9 a=FfaGCDsud1wA:10
X-Proofpoint-GUID: b9U9Ri6tQ8f0U6yhFTcqH38tPwRlwKAH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA3MSBTYWx0ZWRfX7TvPGRuYZLQ1
 dtun5zAFOKjaHS+xTfUe2ZJY9xUMUh8GaBczhmibHtku1Hbtnv9Gjy+ZxiipsrbZ1DVtqmjLkyz
 21pXofLZjbU9kCvKhXx1o5Kf5dzcOVmPd8k8u23kE3qngBbXGCgZOHdVFhuyoguhOHL2hDe2sbH
 cfuK5YIHb0Soz8SVbWnB83s2g6jhTlLWVbxENYkStdSjcmXFl6uTXu9ATzbS6IUekpP6yueBHGr
 WWDscDhfIz2FgkdM4gdE5xKjIavSfTI8Vdiw2oPcKyYghKFl/doC/u7G7QrUOqiex9JUGT73LRv
 lsubFNFxrejSKVpngH7behl/+BVDy4xYafm/1mED8nnbaX/n5ZrhlBBaZaaAhKhbO3HwlwPcZ3U
 bDRtJpKkM+1ihKjNiofmLE+rMUqSRcNjhrtFq+wWxIwfNscNttHBke4Vax8gL0UnA4mOyHD+fC1
 LuqQ93sdofnMM5hs9Jg==
X-Proofpoint-ORIG-GUID: b9U9Ri6tQ8f0U6yhFTcqH38tPwRlwKAH
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150071

--------------V9bj0XjIp4p6NS9t0L2EG45h
Content-Type: multipart/mixed; boundary="------------YzJTiFyZdh9Ui0jCO5vuu0JQ";
 protected-headers="v1"; hp="clear"
Message-ID: <afba68a0-986f-4807-b6d9-10f8b0518b6a@hpe.com>
Date: Thu, 15 Oct 2026 11:35:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 04/13] RDMA/core: add the reliable unconnected
 queue pair type
To: Jason Gunthorpe <jgg@ziepe.ca>, Eric Davis <eric.davis@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-4-a0e626117113@broadcom.com>
 <sashiko-outbox-172001@kernel.org>
 <CAMouMYKADaQjsjeGZZyB+eWvswpf+b_H=aT-VZHVoe=vQFhxZA@mail.gmail.com>
 <CAMouMYKo+z70vA86P5gG-Kz=5TCSUZVfuLS1wAaCLKopze=R=Q@mail.gmail.com>
 <20261015173005.GS14213@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261015173005.GS14213@ziepe.ca>

--------------YzJTiFyZdh9Ui0jCO5vuu0JQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/15/26 10:30 AM, Jason Gunthorpe wrote:
> On Thu, Oct 15, 2026 at 09:09:20AM -0700, Eric Davis wrote:
>> If it's preferred, v2 can make both post commands return -EOPNOTSUPP f=
or an
>> IB_QPT_RU QP so that is explicit. Let me know.
>=20
> I didn't try to undertsand all this ai output, but as a general
> comment if things are not supported please return EOPNOTSUPP rather
> than pretending success.
>=20
> Jason

In this particular instance, it might be better to add the support for
RU qp types to the calls.  We don't use them in real providers, but
neither are these calls used in any other hardware provider.  They are
used if someone creates a software provider (rxe, siw, potentially suet
in the future maybe?).  But, this does point out that we can't rely on
"real providers don't do this" because a nefarious user can download
rdma-core, make their own changes to the code, compile, and run it
against the uverbs device.  Since this device is often not overly
restricted in terms of access, we can't guarantee that things won't get
called incorrectly whether by accident or on purpose.  This particular
entry point is an example where not getting this right could cause the
kernel to mis-interpret the struct passed in and then it could do all
sorts of wonky things.  This is the sort of things that google's
syzcaller would be used to trip up.  So, I think this is probably one
that needs resolved.

--=20
Doug Ledford <doug.ledford@hpe.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D

--------------YzJTiFyZdh9Ui0jCO5vuu0JQ--

--------------V9bj0XjIp4p6NS9t0L2EG45h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmrRHP4FAwAAAAAACgkQuCajMw5XL93w
uA/+Ivcxrc4KGNlRC9hQcvbnphSMK5AEq9BokZRcyetz5ratZ6OaMqT40XzPfl61wi6NXuIjYawx
GDDqrSf1Eh0faEw32XPyeJoaNLPI36WELzZwG51mzkD8ZOPyE8u0j6vJ87dFl8Xx+SvdyYibg+Sb
F7CAuhcxUzYKzguH4Mj4HrF8jB6APdewYanZGq7uYJuqSy5bycX90aPm9ao6kMT1ZhGRYayVbBQZ
qUQfNxLx5/ThwEk6W2YSF9ExpM+c/Hy8IT2dP+N23e8lHpvQGxNHnHSvwXaNhNAOxR0L0WrzRpkW
r5MzeaiNJrKD1qcTKG66tmsJreKFwKUUcRFWUbJPcSS57kSe9F6qbaLgug12SI5rIqfsjBHJtpBu
G6WjHhPA/Bsy+UFn8xEw/+xn5kEEOR5Md4yXBg1gLnBwn8r1NTBQecKFkxE4IUNF7HsqXNr2aIUx
IeKV14Qs7IWkp6FhB86klbVsXqJdKD2ys69sp+xL4q5LEA8ckG4Aas4uQYUEMHmEApumKezIl5vJ
MP4x38V5qjyofsysIdB1gnCwjIssv+LqgaY2XyEs9WkkbVOlgKqe7oWJV0QcvgQhiFhxUShkB9w2
OkBnvQa2LdI5Slp5nX43bjNvbS5vNLoEaBONxMmsH/cc7LxtDwpyCL0gBrAjDqtyrfuBSMUl0NLe
1Oc=
=cQNY
-----END PGP SIGNATURE-----

--------------V9bj0XjIp4p6NS9t0L2EG45h--
