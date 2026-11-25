Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.74.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795603347;
	b=JsSDK21aaAXqDC8r35H9OTqUlmKQMaQbnCGX2BebVexR21Mgk0ul3HY1ZJH2qiMSAjKL
	 IC55EYXQu4ft64Nt2dM+WMW/2CRUQfI/f14QB9I9dxjd/5MNxoIV4r8/l0pcFk14Dgst+
	 fzfSrYIGZGBytiwJIdE8NAcK9kNIt7DHfuVK1O1LvuldpZHyq+moi0NumGP/g4KHNqC5n
	 JyqaVGpvtpU0dfzDn7SZRt/zlF/QrWV4ZZCIxDK9CrCyEviJ3Xt1AFHDHX78HiHO4B6UP
	 9wKV+rSr4ahJZ+24EWBmEHVAZYWfyklE9LzPuGx/4MNbIxsTo/OTGCOaQKUwHYqv/dg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795603347;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 user-agent:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=i6OxgQL05VezwgjSAKudnNjJ0VyJLjM20WaR9QrMG2s=;
	b=HJmuzAXrh+9dRtibVek+mhOWn97kcHCerUe29w2hesGhQSJEdu70SKEEl6FswOAn9xQ0
	 fEce1+2NFQU1ddx1qvGs4fb6nZrDtoukvLvN9dxvKNkECCGEPNGgUHXpeZOvtaDuNn9Ik
	 +mkQ4IvZ3z//GmE1bUskEs9biHdisJHYhW4k2rxJaMaL50FEymrFF74sawfFrFUIzrRAt
	 zu7ubXoy5YcL0dhWHAIGgBrU9eEiIp3bTcBVyDRPShQ4A1pMXWa9uxW8DvkrUe5IziUA0
	 HeBZRDJWRe49hJqGc54jKs5KTR4Z4FN+M0c+mk1qFcUoB2pAgS1XVVJhDLHKbpG8yxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=cWDiCUhO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.74.61
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011061.outbound.protection.outlook.com [40.107.74.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF8606A329;
	Wed, 25 Nov 2026 10:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CEF8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=cWDiCUhO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZh21xMQgYSJUfEoOP/7P/49OB66DptoHWSqRv5MvtOcj0PkmJnD/K0iYI2pJ0j0ZqagxXkSHxVGyEsjCZ2PhQuqHmcPrGrITjgIcEmale9xR8BQ4MwtumvlfLJ9G62BdBEsQaVyqF+Aa5v+1Qi2Z9Tr2PiN0qPSY0ASLxYE1TtvC7JlxU5uaypoUfvWs0QY9S3Xbsj7BaTt6yKKQVMY+piL2TAiz9LiVQH92b8A6JfLQMGb+07FrpEE1MkCSF6U4wTaiqsQCKObJ5Yl72HfQ2jqymgGpHYSRo+NsvGazcvMhF5gYaEAJDLR1aMfFKrT9cOlEypif6eBVJ841SqzTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6OxgQL05VezwgjSAKudnNjJ0VyJLjM20WaR9QrMG2s=;
 b=o2WlIj7A0FOoqYHob3DTKT3YHQSCB03yoOGR7lAbTRrdr7AfQ8jPRnbVcgLVXm755d553cRIZk9HHvtahde1aKPOgxu7WShn4U+xtcHP+GLgGE9Q9nRHO6OJ5dKtEuUOXzDLZnU1KJqLliAFOzjHE0qNtYd3ckjb5nR9xaX24Q7rvgViqrGR3a94bbPRZb6yWGg8KP5tW/7LzYo9Fh+EJ7auF7D4tNJkahUd3pE4Q0ysucHIjWoBOLDnC5nt85JIMRAtyN4YXDIKd6tf8D+OlhGSbja8EUPYtxMDRlJBBEuXFDzGeoMg/oK95CVlAlpia5BF+s8moZfpsTVWf+pwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6OxgQL05VezwgjSAKudnNjJ0VyJLjM20WaR9QrMG2s=;
 b=cWDiCUhOVWknRrWH6Ug09P5c/FpfX4LYejy6UlVGPAmXzaUrtGvhn9mO8m6NMd16Hh0zr4xtkGoV3Xf8YH8but+QhIM7br+6Lh551SoK/jTxP7V7FEuHd3FuDOxeNV2VyACcRUK9vtHk/iPVsxHSha1LjehFrfghVHY/rkDj7qvOs+rE6NitOXA87F4nsnIIIJoNHbh18CvaWavdXE5Fs8O+ymn5dIa1cuFVL6guP8Km+k0oNKnzECrWP/aYv/TiAW7XS/wZPcRb09SFbMXaceZa6eFW0K8tlE4wRgYXu5xHGcCpcRXg2JKtFuU7eu++Kx+tj4bxJoDiU/g1cs9GlA==
Received: from OS9PR01MB12148.jpnprd01.prod.outlook.com (2603:1096:604:2e6::7)
 by TYWPR01MB10243.jpnprd01.prod.outlook.com (2603:1096:400:1d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Wed, 25 Nov
 2026 10:42:24 +0000
Received: from OS9PR01MB12148.jpnprd01.prod.outlook.com
 ([fe80::7a9a:2706:6589:5131]) by OS9PR01MB12148.jpnprd01.prod.outlook.com
 ([fe80::7a9a:2706:6589:5131%5]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:42:24 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zhu Yanjun
	<yanjun.zhu@linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for-rc] RDMA/rxe: Allocate the MR page array with
 kvzalloc()
Thread-Topic: [PATCH for-rc] RDMA/rxe: Allocate the MR page array with
 kvzalloc()
Thread-Index: AQHdeyzGlhEL4dSCw0uFSdmoUOSCfbc+nPEA
Date: Wed, 25 Nov 2026 10:42:23 +0000
Message-ID: <275f5ca8-0ffe-41f7-bd24-c819fac6d595@fujitsu.com>
References: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
In-Reply-To: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS9PR01MB12148:EE_|TYWPR01MB10243:EE_
x-ms-office365-filtering-correlation-id: 285cd6c4-713e-4b03-7036-08df4ae0ca86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|261009223027099003|18002099003|22082099003|1580799027|38070700021|56012099006|11063799006|261028144727099003|261102123227099003|261021123027099003|261026140227099003|261021121427099003|261022105027099003|10067099003;
x-microsoft-antispam-message-info:
 v/MehJAu3IVXtVysowoI9SK/Xfr1ZRPOKH7RujPojxRL+DFOaSMNOo2aHNPL07lXOrN4+z9APE1oFXYoLdZtCHRmeJ22lMheHoOylp3QO0xUZM8cX82gZgaxKhXcS0yTbF6NOYvBsY5PMHS3tGw9WRwUPvSz11Y+Es8tTNMMbd4S61cg3tg7iY4eEj22NGI7cdX3VeVuuKKi+DlExYyauwSJhA7hdjubXnUp/UeH3C2R3GLBzHgWt7gaStyGEfEANIXY+3zQYaLAoVxd1qL/c5Jr2j7dVBLWziPC+JcrNYxg8lSL2CoKLOJ9r9/FA8HgKJx+7SsMJdFhpCH/2HwQntd1GN3GpTemXZn1E84WyDiIfxJ7IrZcpvOAleopbfRAGOpKYKC6z19UA9OJuMu9jIVHmRlcnek1xlu+IWeEhqOYXgT4rjfnFeGp3xP+8r3H4ETIXOl6/cvfgCt5BmQosoaAhhlAuTkVqC7ZfLT02ktHxro61gr+v5MLwXDiNbAa4ihLiTbXKDHXSEUmKqnhhIpa7tDnWwYKVXUcNpT8teOv1DFjni/EtRvHqf9zj0wlIWk1IKp4VhIOwB94lqe5iyi0CY+CxZCAbKKPSlPc0zYWfzm2x+yQuDavjiQVq/mAQW2L46eINVDTwH2M8GykPkHyjeIJQtskpqz4gL3n+Ft5dJagQTLg1hVsr5qhRRi8qgFtDkO2dqYDSM+gTvqqjsNezSG4+V/SQzf0fn3NM/6zJPA/EdC2DXR9uYW+1lou
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS9PR01MB12148.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(261009223027099003)(18002099003)(22082099003)(1580799027)(38070700021)(56012099006)(11063799006)(261028144727099003)(261102123227099003)(261021123027099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OEdwRjlVcEJSZzZYL0ZITExjS1E5Qzl6QjBvc0pTVXpXSjdEQXBNTDI4WEo2?=
 =?utf-8?B?YVJvcW5xRkZYaHRDa0FITFhnVEtaczRXbndUbkRObnpLell4djhJSWdyS1pQ?=
 =?utf-8?B?TVJacm4zTUNwRVdlNG9laU9IMFBVZWI5NjArWi9pZDNzWTlEeVZUUVA0ZUI4?=
 =?utf-8?B?cGpDdTUzZWkybWU4MlZMTDVqSWVKM1lTZ2t2L0N1K0I2andHZVNOUjh1RVVi?=
 =?utf-8?B?aXhWMzFrSXVDVTIvQzBTN0xCTEZMK0VianpOK3BTVjYvTW5UdnIxTy91emcw?=
 =?utf-8?B?YkhiRC9GZklhM1Z5R1RHVjl0QjYxVkVCNXhqdUNoakJ1ODQ5aTY1d3pRR0FI?=
 =?utf-8?B?SDFkQlhJY29lQ3hINGR2cTAyVTljak95WEZUMWxJZHlGSnJHUHUvUWp1TUtk?=
 =?utf-8?B?YWFaK2pwcjYrUFUwejJOM0RMdStDeDVZWkJObGU0RE5LL2QzRzI3TzlWbFRN?=
 =?utf-8?B?OUp3Y0srcVhSKyt1L2kzeWVZUUJ5T1NQMGR1c2FXNDVCZ09Id1hJc2s4T3pk?=
 =?utf-8?B?WFZKTTBmYUxBSFRQS0VSTmRMM092QUpzYTNQOEFsS011ME9ZR2o5VEhJaTRK?=
 =?utf-8?B?My9lZ05YdVZOb2dNMytUYnZKdVVGazhpRXAyNitMSkZtcE0zNDhWYUJTNXBL?=
 =?utf-8?B?dFFBS1BRV0lYKzBDSmlFcFA1Z09Dc1FVTWJSR2lWRzV2blROZDRwRHgrWG5s?=
 =?utf-8?B?MVdZWmtjc0VZdElyWTh4Q052aWhGbmV0RHZEWDZiTi9rYUZyZkV3RGdxRUYv?=
 =?utf-8?B?SGZnNWhTaTdpUG1jWWEydEdrVCt6cm9QV1VaTEg4UXF3cXVFVXNlQmtUbkE0?=
 =?utf-8?B?U2U1dytaTzBTV21RdmRjUStieHhsQzJ4dTM5a3MrUmNJY3VmMTl3aklVV2sr?=
 =?utf-8?B?U1dNKzlsbEI3N2lhLzlWWDhEYktMdmlMVGVyZ2JjdHNaSkxmdml0elpReUpM?=
 =?utf-8?B?dXE5VGliWjFzNWROYWFEQndzTVdabTdGVEVoU2pvSXlVU3VlQnJ4RjJTY3ps?=
 =?utf-8?B?Z3BIT3h2ZkFZZzQ2RGFNMFN5dnlHTThUeHhuVm1xQUF1cHBpU2pWZTVyYVUz?=
 =?utf-8?B?enJGa2swSFN3VHFzRlhBMGFEZkZUQ28vQXNCWmIvbDcya0VjUXQxaHFCVlhw?=
 =?utf-8?B?cmFUUEhzSXdGVGVqa01Ya2xPeXNVT2tPZmY3ZW4rMnZISndZZ2RPaUJXdE5M?=
 =?utf-8?B?MTdabks1Z3ZIcysxeFBXcmpHMkFORWlaMGhFMGtkQzFmYVA2TG13SzljQUlw?=
 =?utf-8?B?TGNZdHRUeGU2MU1pZ1UzZW1nMDlGVEYxdzc0RFBPbGcyNXdhMnNNaWhhR2d4?=
 =?utf-8?B?QVJLMmltQXl1S3dNMUhBd2g0aHJHTjcza0xKSWdvdnlSKytleERIUjJBdURZ?=
 =?utf-8?B?SHVmL0c2Yy85V1dtajg0N0RBdEVBK2VkVi9zTEt1RGdxQ2Q2b2tiY2lFY0Zy?=
 =?utf-8?B?dmdkUDBaK1F1YjkvNEVkQUJqRE14K0FIVzc0Y3YzQlVENWsrdlRPTEgzVzBi?=
 =?utf-8?B?NjBPQjhkdzBGNzR5eTVLV3pZbk1LVGs3LzlFNnVPSnBxczVRSjNFYkhpc2FR?=
 =?utf-8?B?TVpXaEtUbUpZWmRoUFVPT0N4NkVnbi80ZmppWTVIcmpPbDdaZUtvT2tDZkF4?=
 =?utf-8?B?WW56cks1ekN0WXpRek5CRmozd2VQTlhJZVNQUEx3QTBXVm5ZTDl5dm05QWFa?=
 =?utf-8?B?ZnNNMWY5czd2QkxVR05JUnpETUw5Vm5ZM3gwWU1WR21Vc25ubVZUM0pGVURQ?=
 =?utf-8?B?azZycTFjL08vR21wdGlZYzZYNldNc0g5MUxuNUZJakIxMW9FaGhnODJnS0x1?=
 =?utf-8?B?K3Fsb3k5S2VIbWhuQ3V4QXc0dlZDbGgrOThDUjV1UkZGcVFnVWlXY0toVkll?=
 =?utf-8?B?SDJ1Rk12Sko0TjA0bDZpdDRCWUFTL3h3ZDRDWTJPc3Q4ekRoM1JQWDhXejRB?=
 =?utf-8?B?bUVnV1hSY3pLamFBMjJoQmpSSThvOHNkcUR0UHIwcWhFWEh2K21JeUxTbTM1?=
 =?utf-8?B?a1lBU1hWZ2NmeHFhcThrZmpHM0Nzb01JYkNpWUhGcUEwZXVmbC9nVW1DR3V1?=
 =?utf-8?B?eFM0cEcwbi9NY3I4emltLzk4dm5mYlFNV2cxbFhEQnYwYlpTS0xuTkw3bmp4?=
 =?utf-8?B?Rk5ZUFA2SWp3NE9KUFo5QitSVkdENU56WHRSR3NseXZJY0VZOGlCWHluSzM0?=
 =?utf-8?B?dnNSM09tUmVneTJiMzRaV05kV2JpOXpOaUY4VGxuTnNsZWVUaUhPdTZ2QmRY?=
 =?utf-8?B?L25YbEJwU2gva0lYU1p6QWlKWGNtYkc0bEFMb1l0SUxnUzVKTGdqaVA0YXpp?=
 =?utf-8?B?cjFlTkdmR1FHRjdxYVJydWd1YTV5TkZmTWJ4dDFTRVdlQ1ljOEtzQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E9558B0BB28AB4B8031139F844B762D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
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
	m54i+7rlVbxxTVqUIvZd3xn+c+vO/jjlDQVW6W4Q2S2TNstBBr2JKNEXRO/8FknW52TFN9wAswkc0dP/j8/QZASsznWOaM6SjOFB/oWmmtLw+QgHVclbO93gLnMmgQQ3K0If4Ye9S134gS0GWEIvBlX+cPJh8Uny2F4DW1eqlpySoGIbpJK/jtisiL9rN4XzldEC8xCYcXA9U6aX0PEDZosFInKIN367Kj1emVQ0wrclZyG8lM/jzmLRtjXl/MoZL0rSc20OldMXTZyC+mGQr+DJGQ9Hjn5CZr9P2EvhXaNeFNHqsiinro7bKRJKHnjtEupcGMgngm6J8aBXn1sreQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS9PR01MB12148.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285cd6c4-713e-4b03-7036-08df4ae0ca86
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2026 10:42:23.9734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6PHkxXW32/QqukRbrqd9eIQwEkaDqtjqLGG1EARDWbQ/6ef5+AWSRJEo3doAac2uNaHfAg86FHO7hjknVxU+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10243

DQoNCk9uIDIzLzExLzIwMjYgMTc6MjYsIFFpbGlhbmcgWXVhbiB3cm90ZToNCj4gQSB1c2VyIE1S
IGtlZXBzIGEgc3RydWN0IHJ4ZV9tcl9wYWdlLCAxNiBieXRlcyBvbiA2NC1iaXQsIGZvciBldmVy
eQ0KPiBQQUdFX1NJWkUgcGFnZSBpdCBjb3ZlcnMsIGluIG9uZSBhcnJheSBhbGxvY2F0ZWQgd2l0
aCBremFsbG9jKCkgd2hlbiB0aGUNCj4gTVIgaXMgcmVnaXN0ZXJlZC4gQmVmb3JlIHRoZSBhcnJh
eSwgdGhlIHBhZ2VzIHdlcmUga2VwdCBpbiBhbiB4YXJyYXkuDQo+IA0KPiBXaXRoIDQgS2lCIHBh
Z2VzLCB0aGUgYXJyYXkgb2YgYW4gTVIgbGFyZ2VyIHRoYW4gMSBHaUIgZXhjZWVkcw0KPiBLTUFM
TE9DX01BWF9TSVpFLCBzbyByZWdpc3RlcmluZyBpdCBmYWlscyB3aXRoIC1FTk9NRU0sIGFuZCB0
aGUgZmlyc3QNCj4gYXR0ZW1wdCB3YXJuczoNCj4gDQo+ICAgIFdBUk5JTkc6IG1tL3NsdWIuYzo1
NDU5IGF0IF9fX2ttYWxsb2NfbGFyZ2Vfbm9kZSsweGU5LzB4MTMwDQo+ICAgIENhbGwgVHJhY2U6
DQo+ICAgICBfX2ttYWxsb2NfbGFyZ2Vfbm9kZV9ub3Byb2YNCj4gICAgIF9fa21hbGxvY19ub3By
b2YNCj4gICAgIF9fYWxsb2NfbXJfcGFnZV9pbmZvDQo+ICAgICByeGVfbXJfaW5pdF91c2VyDQo+
ICAgICByeGVfcmVnX3VzZXJfbXINCj4gDQo+IEFsbG9jYXRlIHRoZSBhcnJheSB3aXRoIGt2emFs
bG9jX29ianMoKSBhbmQgZnJlZSBpdCB3aXRoIGt2ZnJlZSgpLCBzbw0KPiB0aGF0IE1ScyBvZiBh
bnkgc2l6ZSBjYW4gYmUgcmVnaXN0ZXJlZCBhZ2Fpbi4NCj4gDQo+IFJlZ2lzdGVyaW5nIGFuIE1S
IG92ZXIgVEhQLWJhY2tlZCBtZW1vcnksIG1lZGlhbiBvZiAzOg0KPiANCj4gICAgc2l6ZSAgICAg
YmVmb3JlIChtcykgICBhZnRlciAobXMpICAgY2hhbmdlDQo+ICAgIDEgR2lCICAgICAgICAgICAg
NS4zICAgICAgICAgIDUuMiAgICAgIC0yJQ0KPiAgICAyIEdpQiAgICAgICAgLUVOT01FTSAgICAg
ICAgIDEwLjggICAgICBuL2ENCj4gICAgNCBHaUIgICAgICAgIC1FTk9NRU0gICAgICAgICAyMS4x
ICAgICAgbi9hDQo+ICAgIDE2IEdpQiAgICAgICAtRU5PTUVNICAgICAgICAgODUuOSAgICAgIG4v
YQ0KPiANCj4gRml4ZXM6IDEyOTg1ZTU5MTVhMGIgKCJSRE1BL3J4ZTogRml4IGlvdmEtdG8tdmEg
Y29udmVyc2lvbiBmb3IgTVIgcGFnZSBzaXplcyAhPSBQQUdFX1NJWkUiKQ0KPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBRaWxpYW5nIFl1YW4gPHFpbGlhbmcu
eXVhbkBsaW51eC5kZXY+DQoNCg0KUmV2aWV3ZWQtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBm
dWppdHN1LmNvbT4NCg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhl
X21yLmMgfCA0ICsrLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUv
cnhlX21yLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9tci5jDQo+IGluZGV4IDEz
Y2IyOGQzOTE2ZjYuLmZiZjRkODk5NDczODMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaW5maW5p
YmFuZC9zdy9yeGUvcnhlX21yLmMNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZS9y
eGVfbXIuYw0KPiBAQCAtMTU3LDcgKzE1Nyw3IEBAIHN0YXRpYyBpbnQgcnhlX21yX2ZpbGxfcGFn
ZXNfZnJvbV9zZ3Qoc3RydWN0IHJ4ZV9tciAqbXIsIHN0cnVjdCBzZ190YWJsZSAqc2d0KQ0KPiAg
IA0KPiAgIHN0YXRpYyBpbnQgX19hbGxvY19tcl9wYWdlX2luZm8oc3RydWN0IHJ4ZV9tciAqbXIs
IGludCBudW1fcGFnZXMpDQo+ICAgew0KPiAtCW1yLT5wYWdlX2luZm8gPSBremFsbG9jX29ianMo
c3RydWN0IHJ4ZV9tcl9wYWdlLCBudW1fcGFnZXMpOw0KPiArCW1yLT5wYWdlX2luZm8gPSBrdnph
bGxvY19vYmpzKHN0cnVjdCByeGVfbXJfcGFnZSwgbnVtX3BhZ2VzKTsNCj4gICAJaWYgKCFtci0+
cGFnZV9pbmZvKQ0KPiAgIAkJcmV0dXJuIC1FTk9NRU07DQo+ICAgDQo+IEBAIC0xODYsNyArMTg2
LDcgQEAgc3RhdGljIHZvaWQgZnJlZV9tcl9wYWdlX2luZm8oc3RydWN0IHJ4ZV9tciAqbXIpDQo+
ICAgCWlmICghbXItPnBhZ2VfaW5mbykNCj4gICAJCXJldHVybjsNCj4gICANCj4gLQlrZnJlZSht
ci0+cGFnZV9pbmZvKTsNCj4gKwlrdmZyZWUobXItPnBhZ2VfaW5mbyk7DQo+ICAgCW1yLT5wYWdl
X2luZm8gPSBOVUxMOw0KPiAgIH0NCj4gICANCj4gDQo+IC0tLQ0KPiBiYXNlLWNvbW1pdDogZTc3
MzJlYzEzNWI1MDFlODdhYjA2MGQ5OTJiM2I1ZjJlYzQzOTZjOQ0KPiBjaGFuZ2UtaWQ6IDIwMjYx
MTIzLWJ1Zy1yZG1hLXJ4ZS1sYXJnZS1tci1mNzUyYTQ5ZDgzNjUNCj4gDQo+IEJlc3QgcmVnYXJk
cywNCg==
