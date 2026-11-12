Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794480230;
	b=pCnVjuwB/ZwTJgLTZSmpPxpGN4rSbBmtlK8QPAGYh5UU+Dz6H6fjnqjOrmreBmynXrpq
	 IoufXXKKqWhquvuNedAdZHK8ziAp4mxJC0cro3fcBjc0JS0chpoudaPT/op4fX2AqSV5q
	 jcempUmJro4vWAwbYmauko1zoVvpapHNOTfQn8Fx6WxCg4lZ7tENOHEowmkHwIofAmKuu
	 L6UO0K7N0uGOYV03nyVtKpm8aDe5Bgr1UaWariOQbYzyeOorsIhUqhHCssZDVZujjyrf4
	 fMBygUI4lrwUNHnKlzQToyR6AKvlbW55AbviDFJZQw3S0ZWtzEfYGFeunWnHG0oUz9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480230;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Hc4D0FRoRj9GN/sEauUH1OFsYFPQley+9V+oVLSt3Uo=;
	b=RPrfRisSvUIUa5oSTVrLKkgBr5iIWjtK5ijrYay61nCzb/p1CEDvcQRVuXTTBTdUiqAu
	 yT9krSSqZTAw1qYi/CkO/FkUEGz2rXZdEIfr1SfZsmI3MAhybD4ex1b+NxXzfPPWwqbUG
	 skYerGcHlD/WSOeUN6h00ylEH71ZEIsr/xXH/QJZ7vv05xgZsKJkvHyRLVMSWR7WjUwjZ
	 8cGy+tZ59rC1VOA9qe5vgkIn2eybzG8IUD5jU9q9JxFyhx9y/ifO6Su2/234k6XCmLp0N
	 3/6dPNmYRRQ9yyixp2BIzWyXhVZJ4X+cX9TybDnHQz5/m6IEAN9v27lSpxTZAufuQAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tFkvKHQR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.26
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012026.outbound.protection.outlook.com [52.101.43.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49112606A889;
	Thu, 12 Nov 2026 10:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49112606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tFkvKHQR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPqbPqqP9UXmoIzkEbBoKxpQctcQ6rNzJrxwcF4iN5h+dN+c/gYnDwpOjlbUpKT3ISkCGvcjz22B6qTL8BffMsZjjgn/0shUTRNYxRyI4Cu4uQCDhOD57SLWuBNPFUGHQO1XIqixrfcNgnK6xmNdslkbHSf4ZcqgNeu8OMtIYlfTVK53DcL+v6JDZuffgaZuVavA0H2oiV6DJ2OsKKECLG87unsiV/R6C87rvskU71mtZPAmW3ihMtrVufBu6zf6UG+Z6mM5xJMwbdnMDj/ZZbIqkwpQteDDht2Zn1xznPQJpvtxtYQx6rtMt6nN796CwT8ZFGHx+ChYQJprzn9Xsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hc4D0FRoRj9GN/sEauUH1OFsYFPQley+9V+oVLSt3Uo=;
 b=Cv5Rvq2NepsvULKbalxjxY9OJHsOxyDsUXQFp/meOuS8MhrulIrBJQO6T/f/csqpcd1Ru6ykTst7H9noFIeZbiQCX0KojONZuj1YcGPd1bhAkSAffpVZ2EWs9i/GHYQbsQaodqv3LOSVam/fIWRjxHMzmqUtri52uy/S6mUnKK3dTTgIPWoeQ4mMdRHSPrjPIIG7YVUYemdtSfRZvvChQNiEoHLf367RQe2qzgyYQ9jjZSXKmdHMopEZpbkl9bCydp6agy7qIOnhLqu9TDoui6GnSRj4cHWaVaz4Z5yLSMvlu8cXYVIuDm9eIqj0mwn7JzXf8r+Q/0hQwn4K0VRATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hc4D0FRoRj9GN/sEauUH1OFsYFPQley+9V+oVLSt3Uo=;
 b=tFkvKHQRJZV9uhIBDCgRCFq2FjPMYc699zqphDTr7p995EUedzSrIzDg1gY8sjcNoO8WxA9WqndSwim3k9CiAhAWr0yQDblmmWyGKWURRGCxhHUhnZ1ezUoFP23XEH7J2rjFuop1XLGfJOx1vXOqwYqVF5FtFsEwkDiQVIoznaa3rAZN/qSYJYgyG99W8rKjY3XlxV8OaDU+eyAll+XKRuVIYQfuqfJUoMZ+RmESDgEEfNIttQ3THpbcgiRD6c/sfviS1eXyqignjxB2cwz95F4SqxGgLaSHnXHme6QAdpYSgkrn7AYgpIZIoFSsOyS79vUEzPNnvlB4wr04M/5TXA==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by LV0PR12MB657608.namprd12.prod.outlook.com
 (2603:10b6:408:609::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 10:43:48 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe%3]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 10:43:47 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "mzuhayr@earthlink.iq"
	<mzuhayr@earthlink.iq>
CC: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>
Subject: Re: [BUG] net/mlx5: nf flowtable offload rules never hit in switchdev
 - root chain misses to slow path, not to the FT chain
Thread-Topic: [BUG] net/mlx5: nf flowtable offload rules never hit in
 switchdev - root chain misses to slow path, not to the FT chain
Thread-Index: AQHdbElUgfk1enT3QE6ugzlHtdAqZbcqTM+A
Date: Thu, 12 Nov 2026 10:43:47 +0000
Message-ID: <62612ebd42aef5eec1f06a5465e3e6aff9110d41.camel@nvidia.com>
References:
 <AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
In-Reply-To:
 <AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|LV0PR12MB657608:EE_
x-ms-office365-filtering-correlation-id: bdc6eace-df8e-4fb3-b4d6-08df40a9d4fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|261009223027099003|18002099003|261022105027099003|261028144727099003|261026121527099003|261026140227099003|56012099006|10067099003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 oOcPmlrl1itIkv6Dq7zA3VlvJTflilIt0PhsdXoSkTfGiwpNDHjmIanPK4jqx5zf6aMtMEIl1bz2l5lxYTC8FRFjOAuPBL2xN5LdKFd0C7A6HFi0A5PgvG5j+5Q2+lNgE9O021IBlHJxY+fRK7UcpHuTQsrdvVbtJgo2O0T6rGwKELeNM8wBNonuY6L5MS0K4T5Vtt+/qMPtKS1isNce4mHM4jkxH9D60Psr77JO8Pd+N6oZbmyeGEHZXgjvWsYRSAxWG8WSmRioDUavZ0+TiokvKuepLf8N4RyKXQh6oaHOEAyJECOtym9CHB2mLyWSo5ymU2DWzzUhj7AVQ55GDNh68MYihsCzDrlCRAE0DJiCoQibNBGb4J28TYYTNfrq6eNnVm1t4UPod917AM7CzL7USBoXgJ1mWaIuaGQEvazeGGfsDHql36YjQOXigdSOeJyuy99qaYXBnOwdFCNz3qZ8E70gwZL8WD8AgiUrPFh/7iGIuzvPtBIGNyVw+34lFDmNQVO552daeGZDtW8LnxQByU2NPx1QtyhZux4qoxAeG4blAxRXorMRTZK8qBAdz0Q9+bufvfw3qTZS+8rEEZRfSsUo9bs4rlhlhmU2+lat2G3TggXzvcl8sd/o5tz3DV67WEnVMatDKbl4cNZ+jGzO8Ir7d3ASsILm6O0Yqb23y69bTVjes90ITSxK/TpCkjDjOEvUy47mBjhRppBj1u+VDiDuvvenYRCUcKamSXE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(261009223027099003)(18002099003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(56012099006)(10067099003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eUpoNWo1SGlSaHpWaWVtcHZPQTlwb1ZlTTNTUU11NVVMVUhBMGhxblVXZlVJ?=
 =?utf-8?B?R2FrZmR0NkRPaFBERGF1OHNESlIyenZPYjQ1Z0FvUS9QaUFpMFk2YlVGdlFm?=
 =?utf-8?B?SHpPSThIUk05dHdmdHVtalh3SEZTN3JQRjJkMDJwRkp3eGpZa3RKOHRGZXdO?=
 =?utf-8?B?S2dSY1E3NUNvRXcva0hVSUh2R0NOMVZ1b0RleWJGN1VtbWMrSkVBRUdqTlha?=
 =?utf-8?B?c2ZLVThHc1hyUVcycU5FZjdPbTFUWGRUZUJzSG5nOGJKK2xIYk5YUkFZVnlt?=
 =?utf-8?B?M2pESkljUTBWcHR1L2Q5M1Q1YzFDMFQydkl4UXdpTHpUMUh2L0lUUzBlTm5M?=
 =?utf-8?B?aDREWFl2MVY1Vyt1NUY2Y3gwclBmTkZIV2JNQ3RZUVUxMWNMT0VEaWt4NCsr?=
 =?utf-8?B?SktaY01rRlNKaDVnM09QRDZ0ZDBBZHJiVndGZFdtMmNTbFRSQjNuV3hTRTNh?=
 =?utf-8?B?VVV0UmVsQ01OT2lJVXlndUVJWkJ1UW5JQTFWSzFEYkc1dXkrWkl0QU9hRThj?=
 =?utf-8?B?VmJNdWlhNmFrNkllbkhkUXRMUUVBVk1Qd29YNVFJZjZSSGlvMjZHRlVOUTdS?=
 =?utf-8?B?RG9YMGU1UVJpcEZVeDRsYWk1YnRJc01sYUlSbFVYb3FQVFQvUkdmUEI0ZkVz?=
 =?utf-8?B?RGJUNVphVmVYV0NlelRnc3NUM3dLajBqcW5xTzQranEzejFOUC9rN2NWS2xD?=
 =?utf-8?B?YW9QMjRZUWpQRnFLODFaZ2FSYUthS05QTFBtazJnMmZ3c2YvTHUraVNxckFO?=
 =?utf-8?B?S2M3akFuaXJuaE5mZXNHV1ZiVEw0Ui9tQ2hudXZCSTJGQUdqT2dnZTNTTWYv?=
 =?utf-8?B?VUFTUm9NUFF5bk1qK1dDZ2xhazV0aktBdUYrZHVPa1dHQ3ZCaWxZYWdYdHZT?=
 =?utf-8?B?cTNvVXZCeCtDdEhIL1E4SjdRM3JXQ09lQ2NneHl3K1l4U2xJUDVjbG0vR290?=
 =?utf-8?B?WFVTSVNjYzI3NVpDNktTZ09xOHlycS9yM2NZdXBWdkZmaEU0YVFoNStyWXpt?=
 =?utf-8?B?QzNETmYwL2hGT3duY2QrRDFqcWRyT2E5OE9EaXVIeDY1WlQrZE9pSzVBemxq?=
 =?utf-8?B?alZSSVAxTkhaSUNCSk5Pb1ZpcUxXMnVLYTNuRHlkNzRXM29McGNJcWRuYVlU?=
 =?utf-8?B?RXh6bVhINndGLzk5aXBLRzhkSE40UnE1YzgzUmQ3bzNxcVA5OTVTdHI0RjZM?=
 =?utf-8?B?dzJkUG9ZNExHelBibnlOSUZVSlY4KzlHbVYzek5FUEpwaDAxMDNqT3pXa1ha?=
 =?utf-8?B?ZytEdDlQWjVXUUkrbW90RjlnQ0xmd3hDTHVnaklWWXp4M3N0RFZ4eWtVcDBm?=
 =?utf-8?B?K0Q2REtHYUZ2Y0U0NFp6aDhxZlVkQm03VGMzVEwvWlRyRTUwZ21IcGVjNkJt?=
 =?utf-8?B?QzhpU2FlTFFTTlc0Ulp6VnZTMkp1YXVwUUFrTWlmcklCbzBXM09SdXQ3OFZ2?=
 =?utf-8?B?VEdNYkhzRG1CNTlCQVEvajJKOXQrUXFBYWk1TlFCdGF2dDY5aUNtd1RMMmk1?=
 =?utf-8?B?OWo4aXkrT0xxMUlZTEE1YjNVb3lkT3FoNTFOZnZ1YlNMeThnN1JlVHAyZy9Y?=
 =?utf-8?B?YTQzUm5Od0dVTkx4N0s5T0NEN1dJcnJGNUNwMHJHdEg0OXJCbVVLcnNRTVV3?=
 =?utf-8?B?L3lob0pZbzF5ZkpVMmFaQjY1Q0pHeXYzU2tXNlQ0VkZCbFh4eHNBUEJvbW1v?=
 =?utf-8?B?Y0t0QlF5amdVTEhOSWd1L2VwZ3YwSEJidUNtZ2t4djMySGIwYmI2TDVRb1lR?=
 =?utf-8?B?NytQamFrUi9OR3U3WERrZzhiaGVlSVNvSW9PUzNqNDVPajZrWmlJTGJrWjVl?=
 =?utf-8?B?UFdMNjh6RXBUK2JSSTZTWW1VZU9aM3Z0VHlFdXBPYmRiMDNNN0ZIRXoyajAv?=
 =?utf-8?B?a2tRZCsrYzV6ZzVvSlh3dVV3SmpORklFZVBVd3RGZzZ6VU5NcjVYczZWSmtj?=
 =?utf-8?B?YXBmZTV0ZXVMVitzNk9vb0VGY0VxYnJudFJNdjhmTXNJWUkvVUlhNDdyYXZT?=
 =?utf-8?B?RVM1ZjMvNGRCalhkeGRpRzJaQWtTTGVoU2FvNFU3M2wvZ3pyOHFBdzBQdnp0?=
 =?utf-8?B?M0dzaU5Xd0NoT3VsajZIWVUyME9ERjhNbTZWdWJrUDI0QWtkV1kyZ0wrTEE1?=
 =?utf-8?B?WXoxdGVyb3Z5NkRPWjJiTzNYNlc0Zk9TL2lZa2ZONG9ZNEVrQlpDQlFHckw1?=
 =?utf-8?B?djJkTng0YXhreU5rS0RXYk8rVzdFOExZWmR1MEc2eFJVT0pJVTcvVnk1aUor?=
 =?utf-8?B?U3dRRy9TVXEvQm1YemJYZ2dRYXYwRUhyYkdvdjhDVm1mV20vSmRLT1ZnUDZ0?=
 =?utf-8?B?b1BTN1NQeGhGUnp3WXlqRDZJbytkdGpFdFlmdDc2QjdaaER2RnVZQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DC26C73E0750D4CAC097E919BD3B995@namprd12.prod.outlook.com>
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
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS5PPF266051432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc6eace-df8e-4fb3-b4d6-08df40a9d4fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2026 10:43:47.6639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 41F55OYag34fsS/ErAqeunv+Sik2zIrFFx8Ci9WyT0fwzZbjsBbf52PVSI8yJ3Pk12MqjLKhIxybtDpVqnaMuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB657608

T24gV2VkLCAyMDI2LTExLTA0IGF0IDEwOjQ2ICswMDAwLCBNdWhhbW1hZCBadWhheXIgYWwtVGF5
eWFyIHdyb3RlOg0KPiBBbmFseXNpcw0KPiAtLS0tLS0tLQ0KPiBlc3dfY2hhaW5zX2NyZWF0ZSgp
IChlc3dpdGNoX29mZmxvYWRzLmMpIGRvZXMsIGluIHRoaXMgb3JkZXI6DQo+IA0KPiDCoCAxLiBu
Zl9mdCA9IG1seDVfY2hhaW5zX2dldF90YWJsZShjaGFpbnMsDQo+IG1seDVfY2hhaW5zX2dldF9u
Zl9mdF9jaGFpbihjaGFpbnMpLCAxLCAwKTsNCj4gwqAgMi4gZnQgPSBtbHg1X2NoYWluc19nZXRf
dGFibGUoY2hhaW5zLCAwLCAxLCAwKTvCoMKgwqDCoMKgIC8qICJBbHdheXMNCj4gb3BlbiB0aGUg
cm9vdCIgKi8NCj4gwqAgMy4gbWx4NV9jaGFpbnNfc2V0X2VuZF9mdChjaGFpbnMsIG5mX2Z0KTsN
Cj4gDQo+IG1seDVfY2hhaW5zX2NyZWF0ZV9wcmlvKCkgKGxpYi9mc19jaGFpbnMuYykgY2hvb3Nl
cyB0aGUgbWlzcw0KPiBkZXN0aW5hdGlvbg0KPiBvZiBhIG5ldyBwcmlvIHdoZW4gdGhhdCBwcmlv
IGlzIGNyZWF0ZWQ6DQo+IA0KPiAJbmV4dF9mdCA9IChjaGFpbiA9PSBtbHg1X2NoYWluc19nZXRf
bmZfZnRfY2hhaW4oY2hhaW5zKSkgPw0KPiAJCcKgIGNoYWluc19kZWZhdWx0X2Z0KGNoYWlucykg
Og0KPiAJCcKgIGNoYWluc19lbmRfZnQoY2hhaW5zKTsNCj4gDQo+IFdoZW4gdGhlIHJvb3QgcHJp
byBpcyBjcmVhdGVkIGluIHN0ZXAgMiwgY2hhaW5zX2VuZF9mdCgpIGlzIHN0aWxsDQo+IGF0dHIt
PmRlZmF1bHRfZnQgKHNldCBpbiBtbHg1X2NoYWluc19pbml0KCksIGhlcmUgdGNfbWlzc190YWJs
ZSkuIFNvDQo+IHRoZQ0KPiByb290J3MgbWlzcyBydWxlIGZvcndhcmRzIHRvIHRjX21pc3NfdGFi
bGUsIGkuZS4gdGhlIHNsb3cgcGF0aCwgYW5kDQo+IHRoZSBGVA0KPiBjaGFpbiBpcyB1bnJlYWNo
YWJsZS4NCg0KVGhhbmsgeW91IGZvciB0aGUgcmVwb3J0LCBpdCBsb29rcyBjb3JyZWN0Lg0KVGhl
IHN1Z2dlc3RlZCBmaXggYWxzbyBsb29rcyBjb3JyZWN0Lg0KDQpXb3VsZCB5b3UgcHJlZmVyIHRv
IGZvcm1hbGx5IHNlbmQgYSBwYXRjaCB3aXRoIHRoZSBmaXggb3IgYXJlIHlvdSBoYXBweQ0KdG8g
bGV0IHVzIGhhbmRsZSBpdCwgd2l0aCBhIFJlcG9ydGVkLWJ5IGF0dHJpYnV0aW5nIHRvIHlvdT8N
Cg0KQ29zbWluLg0K
