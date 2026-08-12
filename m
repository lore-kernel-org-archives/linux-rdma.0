Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011034.outbound.protection.outlook.com [40.107.130.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02BD426EB9;
	Wed, 12 Aug 2026 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530933; cv=fail; b=MVERAIdzT/Hoo/IwipRTjjhWTNtS66zCEobZKP4Ds408uxnT4Snk6betFthoGBYGbeHlxzZOmJJRm6kSTiRXIzK2MkuXuIaf9ryPm6is3AZdIHlXOjT+nj1MY+yj0LhXFTr9G5a1sWeknuzNuQttIXQ9bAJbOaCNGchqlzK5GKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530933; c=relaxed/simple;
	bh=xW1dmafwFGVmdYYvEEOA8XGld9gqUe5hK4HeX6wiZGU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c1sdUp1dajPdktoKoLwi11Lu9Va3DLtOxspL4HOuyWEGrvAT7oE/1XtV5GsShDLd3cedWbtkffnqTl+ZguoK8wraCpRo98d5W+yGVhyqXXWmbZhoGQLs+1wC89+HpWTyMvW4zDSFJbexLEfIeDbcRv6eADCOCPDcsJTVpegJ7Co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=F5Xef8M6; arc=fail smtp.client-ip=40.107.130.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="F5Xef8M6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzA0mghvRfPKeMH+S3RKJOPRa06e1SOl5kEZgez0fZOkNLBiTzyXZvPGsmHVEa9DTAVF7lO+/afWHoGov2BnfkzJLD3IDoPUXvmYgiL9x9f6Q3pgSAKXzvJfdwm3zvCmtfOp/0JmZAG6USYZ1bmBjPzoXvkho/4zdlTyMiMh6/rt9Kw/80ID7cfY1krtAREkw+jS6chS/9Te/j0DVCKqH1yrkQ+UuXWqoKO402JKfj+Y3GkWkiKG28jm7lTrWjrR/E3wJ1Vr3NQvWE3hqhRvxQqbb5k2ttvhR9fHIemOjHoWwv4yLdvMYkqjZVkkPf3vl6e/Z5tVxAiQVoSCFosA+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xW1dmafwFGVmdYYvEEOA8XGld9gqUe5hK4HeX6wiZGU=;
 b=EXrV3a7mc1QPPLBXBrbDFW6h7uq1KIw8G7/ZIMJwuOrlYGjcvyeTrZ4LuDuIHJ1OrioMSKJHsqlVL2jvlAsk28mrrhygQ+FIeH/4MNMGAZe0m9tlm14q50ZdVeasUYVgVMw8XJBg0n956qcmYt70/CYR9fZwawCpHem5T3HILsyGjeTEeAFXUKIaT8uQHYFZgPMVDYp53imXF9vMdTB6sFzMhb0N1U0XhjVQnNj5r0q4+DGlzdtQrfkreKGS7GBLaH72i+DLZCs+nAaeaCdycx+MBKQJgXB6q/WBQlQ/2BUru3+X1lu6D3RlYMcbdnrVJZRrkCOLlfBy+n235OF6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW1dmafwFGVmdYYvEEOA8XGld9gqUe5hK4HeX6wiZGU=;
 b=F5Xef8M64TgEM31Ea2AfQC2Ijd2NyCrJ0IbD0/2BeHAtZ9ECA/wbAT17dQSumDIEsfBlI+NIahcyP7RXVONHD4juPJ5FhWU7R3T05xs1Gzd9ldYKHAvWFUW/XbJcnX+io/PtXlQYtTWYesIWn2MdnnYgt8zcaoZzJEYXTlOmmYgxW8SijPILhoQXk97ZK2V7dppx7bGK+PMNwMxDlqcBC2bCuyXoEjZtzDVB2/s04HdJoUKgyrNLXivlsVl/wiHhAPPecVQR9baxmDpdLRPBim2Q4WbS2ZXb8MnKP8F3peo/FHwTIX7fCPtqvLQQRMIqgLNBtbAHg2zEuuoRZgxBqw==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by AS8PR07MB7733.eurprd07.prod.outlook.com (2603:10a6:20b:350::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 10:35:25 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5%2]) with mapi id 15.21.0339.001; Wed, 12 Aug 2026
 10:35:25 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Jijie Shao <shaojijie@huawei.com>, "shenjian15@huawei.com"
	<shenjian15@huawei.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "eperezma@redhat.com" <eperezma@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "mst@redhat.com" <mst@redhat.com>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"horms@kernel.org" <horms@kernel.org>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "kuniyu@google.com" <kuniyu@google.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "dave.taht@gmail.com" <dave.taht@gmail.com>,
	"jhs@mojatatu.com" <jhs@mojatatu.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>, "jiri@resnulli.us"
	<jiri@resnulli.us>, "davem@davemloft.net" <davem@davemloft.net>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "donald.hunter@gmail.com"
	<donald.hunter@gmail.com>, "ast@fiberby.net" <ast@fiberby.net>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "shuah@kernel.org"
	<shuah@kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "ij@kernel.org" <ij@kernel.org>,
	"ncardwell@google.com" <ncardwell@google.com>, "Koen De Schepper (Nokia)"
	<koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
	<g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
	<ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
	<mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
	<Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: RE: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
Thread-Topic: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
Thread-Index: AQHdJFknwofVPz0NnEuqy57Qt9muFbaY4t2AgAFg0yA=
Date: Wed, 12 Aug 2026 10:35:25 +0000
Message-ID:
 <PAXPR07MB79842CC27C2F5CF9BD40E007A3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
 <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
In-Reply-To: <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|AS8PR07MB7733:EE_
x-ms-office365-filtering-correlation-id: f35c2a3a-c0fb-4010-1bad-08def85d6b72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|921020|6133799003|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 LaNIgpcfIXAxYhGwiJVJzpzGl1q6Lu0kXieQ7emi6iCM2H9VDMZpDsDS5oLPEP0jy1QjmafqoFcOrZqvxfPa0P9NmBgiYBSWReaPRVVuDFWH8W5yov1rIbJG4QHC41SBAYHxdsHt0tndJYvK+mKm4c6Hbjb518y/hQaVFIOIq0JaDfpN/B3BGZxhivBTFtpWI+U7uiDNekDt569dLuWDs0zk2sMGMxlcEcTpnV5PYDbrrXeZzPTWHBR85ujP9MQzwzXQtTmsaF1BtZ1kyoqpU8xnIIlaraiRc2BSWs2b5v8iV2g+Wjz/xUM388LuHA9ZloTSp1ilsYeZvLHfXO1apX5l+KpVzqM6rjiBV8TYbCkkrtDQc3PHWT8H8LeAQoVVbk9o6Rwsv5V7Ck9aMFb9XY4VgKKp280vbLmMHgI5DzcICQsD9GdK+dCoGcz8OCKa6BV6BCDJpS/BU5pOazRDbWwi2WAB2OkfG2QUsA+8PYhg/H0SJolhnhMWiENmlPkAk5+kgEJsCFN7I7nBeFzviystyAO0ogevzikfmz35vr8zrc8chOtTs+LtHRwHg+KMXqORwdJc70gn9RaXs6lDihxgojC2Nc9XnClSX9F0mp4810gOmuKKTOliSpUZ+kQRePOM9SIG+77Hk+A28wLpGi3p/JWP8a7vFlPGR/5VNjQCfFHmSgYpO6PpmCutF7duvMHDrG+XGcw4QAWFFcaWOnmNArIdyaAKvzK3UEKa+Gk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(921020)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnRYZVVOU2RpbWkxZDR4ZEl3KzBUazZNQkljNEorb3lVMGZzNC9rNkxVWVpZ?=
 =?utf-8?B?Slc5TGRtOVUxNXB4WlRzUUdJS2pRV0FGUWFKMnNYNVR2TFhtY20yS21MaDJ0?=
 =?utf-8?B?eU5Zd2wydEtaRzBoWXlsckIvQWhqUXpRQXlRRXU0RDJzL0NIT011TmJJM1ky?=
 =?utf-8?B?bzk4b1M3SENzbGl5Q3dzbVV2b0FocEFJVUI3YjdXVy9qZ3lVNC93NTdoUWNO?=
 =?utf-8?B?SFpOYUtHWUkyZUo4S2RFQ1RiaVFVLzlMU2FGeE1xSEpkSzF2RisvSXEwTHVU?=
 =?utf-8?B?K1J0YjFDdkVKZGlJeFQ2SVF4K0RQaTBTOTFxWllQMG9qa0tKdDZKSWpXeWQx?=
 =?utf-8?B?WjhXNHU3RGIzSjhqS0RMKzdtd3p6YUNTUVluUGU0N3oySXZ2dUNneFhMSmJx?=
 =?utf-8?B?bm5oanlvVkE3WHRzekRibmlVOXI5VzBqRTR5R2xrWlpmNnd0Snp2bHhZYzg0?=
 =?utf-8?B?Mi9LeFBnV0NXSVFkRDRtVTRjeTJtZUsrTjB4cDh1Yk1YSXd1TnZsRTVoNTdn?=
 =?utf-8?B?SS9naC9id3hxNS8zMjFzUGNPMGNnM3VGR1EyUWFtbmt4VGxnNnpwYVVZWFNs?=
 =?utf-8?B?clVMc1d5VmxUOUpKcFpPYWpoVkdWMmF3bUZZcG41TzlPZ2I3U3N4bTB4bHFO?=
 =?utf-8?B?YUhpcWJYa1NuWlVwNndOY25hczQzRm5kNzlvdVFoQWlEMzg0UXNlalBaNjVT?=
 =?utf-8?B?TmNGeEN4S3AxVzBhUmNBYlgxVmZ1ZTlxdWZFeVVrWlY0UTUxY2xQRkxGVEd5?=
 =?utf-8?B?Q2tSa25halZPZERrRjJmN3haUHVCdkZaRzE2V2RCZkwvdVhmZmtGSDB1T2JX?=
 =?utf-8?B?K0RBR2diRjJOUURQT2ZmSk1CUXc3YmNRSmpOd05NakxGaVlVbEw2eTNnV09k?=
 =?utf-8?B?VGdONHAzTDh5ZnJ2UmRRRmhvM3BBWlVJYThRdCt2RTloWUEvN0tJdGdydWdM?=
 =?utf-8?B?YThHU0Y4bkwvcnNyTUppRW9HY1VXM1Brazhna1VyaGExVFdkZTJHRWN5SEpD?=
 =?utf-8?B?NW8xYmVEeHVPQ0MrZ01NUy9FVEhoci9HdzllcFFTNXhEMUZteSs1dEI1MG1P?=
 =?utf-8?B?VFVZT2wza2dib1pNODdPc0FTL1hRY081UkRQOFU4MVZLYW9FOFk4bEdWQmQv?=
 =?utf-8?B?OXVpQTdnc0RVaVVOTG9wNDRSaStjdU9TeGFZUnBFVFQ2RGwxa0hnMERCVy9a?=
 =?utf-8?B?c2dNNnAzWEx2ZnhpWUVpaWJEditod1JIbkZNRk9ZNGlxcTN3ZS9xMWRueGVB?=
 =?utf-8?B?bmpTNzY5UEUvRmFZbWZSV3NIV0Z4dURzRzBjYVRaVXM5a1B0ODZpMTNSWUk1?=
 =?utf-8?B?bmdhTi9oYzcwT0I0cHJpZVZoeFE1NGxvM0Y0TStPSWlHNnRiNkdYMGI1VUlo?=
 =?utf-8?B?eS9ockgrSkpSd2tyOUdabHJPZ1hSY0JWVTc5dFVNYXJ1dGk2Nmw4ZWMwZjht?=
 =?utf-8?B?VU9wK2Z5UHJnaW5tbmtUUnQ5RUY3bVFBdEtzajhIa3FQMGRPcEdZYXFvdi9q?=
 =?utf-8?B?c2VUcFNmZENrL0U0TkdZaVVRVDFDZXlBVVMySGVLTTZiMTVYSHlDc1M3MUxv?=
 =?utf-8?B?OUdTOUZobFZLa3FwcGVubzNjeVgvL0kwdEdSREJSZm1PZnp5QnZZZzBpd29p?=
 =?utf-8?B?M1ZQcC9IeTNOWmJoajA1RUJtdkZBaGJaWStvT1pQS0N3cUQ3V2d4eDRoUCtY?=
 =?utf-8?B?WXQyU21hVDVRb2QrSHFLU09Bc0FWMUI2SXkyWGdzc09sMjRkcGNCWjZjbDVQ?=
 =?utf-8?B?NlkzOGFkWXoxUGpJVVI2bHJIWTE0ckl6OTFjeDcrTFFNOWxrRnZFTGFzaDhC?=
 =?utf-8?B?WEw2QzIveE9Jc2d0QkdmaWFCSEtOYTR0ZjVUbG43MEFBUjd6NitKWFhaeUlu?=
 =?utf-8?B?RWQ2OVdnZ2dGMFVNNGc5R1pkdEkvcDM1WSs2UGhaNXgzbXpwRTNya0VTMUNF?=
 =?utf-8?B?S2dPWnpOS3hTR1dSY002M3pBWmZWNk9od0pKODk5OEZtSFQ4djJLd2hRQ2xm?=
 =?utf-8?B?aUwwa2lQbUFpdm1YbVR2cWlJWXptQTdFVzcxU3lORVB0MTVabDRYMjhuRnNL?=
 =?utf-8?B?Qzh5RzlwUXAwa2lYN1JCbjZ6T2N3dk5ubnJFZmRTK3BUbjJhSm5uNlBWdHVN?=
 =?utf-8?B?SVdRSmt6dXJWTTNnOFNoOWt1bE5GcEdJaUgzUHdZVXJwVmsrZ0ZPc0RzRTla?=
 =?utf-8?B?b2RKK1I3Vkd1SmlKUUo3Q1dJeUtLYkZMbHVzV29uNVZWSlhwUzBlQlFub2k3?=
 =?utf-8?B?bTBKTDgySjc3WXBjQ3FBYWhHZVBWbGZNanBaeHdNVGl0bGVzSlhUU2srMG1H?=
 =?utf-8?B?YkhBN2cySWZ5c0FhUzhQWFJzNkdXbG9mTHVOV1hGbFRlNXFsN3B4cWgzNVJM?=
 =?utf-8?Q?filCFZPJS6HXydsU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR07MB7984.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35c2a3a-c0fb-4010-1bad-08def85d6b72
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2026 10:35:25.1460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iaQJ5LIHMuVava7qD+g94/bvH+Zf4a0XDhnkve97EUlFPbbMb5EytDhM3Rl9Bx2wYyv7l/q6+D38CAchOijeaK1hNtf2an59Xw+piTLLMs9CWkzN/G9KKfSMWWrt3Ygj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB7733

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaWppZSBTaGFvIDxzaGFvamlq
aWVAaHVhd2VpLmNvbT4gDQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAxMSwgMjAyNiAzOjMyIFBN
DQo+IFRvOiBDaGlhLVl1IENoYW5nIChOb2tpYSkgPGNoaWEteXUuY2hhbmdAbm9raWEtYmVsbC1s
YWJzLmNvbT47IHNoZW5qaWFuMTVAaHVhd2VpLmNvbTsgbGludXgtcmRtYUB2Z2VyLmtlcm5lbC5v
cmc7IGVwZXJlem1hQHJlZGhhdC5jb207IGphc293YW5nQHJlZGhhdC5jb207IHZpcnR1YWxpemF0
aW9uQGxpc3RzLmxpbnV4LmRldjsgbXN0QHJlZGhhdC5jb207IHh1YW56aHVvQGxpbnV4LmFsaWJh
YmEuY29tOyBwYWJlbmlAcmVkaGF0LmNvbTsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsgbGludXgtZG9j
QHZnZXIua2VybmVsLm9yZzsgY29yYmV0QGx3bi5uZXQ7IGhvcm1zQGtlcm5lbC5vcmc7IGRzYWhl
cm5Aa2VybmVsLm9yZzsga3VuaXl1QGdvb2dsZS5jb207IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRhdmUudGFodEBnbWFpbC5jb207IGpoc0Btb2phdGF0dS5j
b207IGt1YmFAa2VybmVsLm9yZzsgc3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc7IHhpeW91Lndh
bmdjb25nQGdtYWlsLmNvbTsgamlyaUByZXNudWxsaS51czsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
YW5kcmV3K25ldGRldkBsdW5uLmNoOyBkb25hbGQuaHVudGVyQGdtYWlsLmNvbTsgYXN0QGZpYmVy
YnkubmV0OyBsaXVoYW5nYmluQGdtYWlsLmNvbTsgc2h1YWhAa2VybmVsLm9yZzsgbGludXgta3Nl
bGZ0ZXN0QHZnZXIua2VybmVsLm9yZzsgaWpAa2VybmVsLm9yZzsgbmNhcmR3ZWxsQGdvb2dsZS5j
b207IEtvZW4gRGUgU2NoZXBwZXIgKE5va2lhKSA8a29lbi5kZV9zY2hlcHBlckBub2tpYS1iZWxs
LWxhYnMuY29tPjsgZy53aGl0ZUBjYWJsZWxhYnMuY29tOyBpbmdlbWFyLnMuam9oYW5zc29uQGVy
aWNzc29uLmNvbTsgbWlyamEua3VlaGxld2luZEBlcmljc3Nvbi5jb207IGNoZXNoaXJlQGFwcGxl
LmNvbTsgcnMuaWV0ZkBnbXguYXQ7IEphc29uX0xpdmluZ29vZEBjb21jYXN0LmNvbTsgdmlkaGlf
Z29lbEBhcHBsZS5jb20NCj4gQ2M6IHNoYW9qaWppZUBodWF3ZWkuY29tDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggdjUgbmV0LW5leHQgMi8yXSBuZXQ6IGhuczM6IGZpeCBHU09fRUNOIGZsYWcgc2V0
dGluZyBpbiB0aGUgUlggcGF0aA0KPiANCj4gDQo+IG9uIDIwMjYvOC81IDU6MzUsIGNoaWEteXUu
Y2hhbmdAbm9raWEtYmVsbC1sYWJzLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBDaGlhLVl1IENoYW5n
IDxjaGlhLXl1LmNoYW5nQG5va2lhLWJlbGwtbGFicy5jb20+DQo+ID4NCj4gPiBDdXJyZW50bHks
IHRoZSBobnMzIFJ4IHBhdGggc2V0cyB0aGUgU0tCX0dTT19UQ1BfRUNOIGZsYWcgd2hlbiBhIFRD
UCANCj4gPiBzZWdtZW50IHdpdGggdGhlIENXUiBmbGFnIHNldCBpcyByZWNlaXZlZC4gVGhpcyBp
cyBpbmNvcnJlY3QgYmVjYXVzZSANCj4gPiB0aGUgaG5zMyBoYXJkd2FyZSBHUk8gcmVzZXRzIHRo
ZSBJUCBUb1MgYnl0ZSB0byAwIGR1cmluZyBwYWNrZXQgDQo+ID4gYWdncmVnYXRpb24uIENvbnNl
cXVlbnRseSwgbm8gdmFsaWQgRUNOIHNpZ25hbHMgYXJlIGNhcnJlaWQsIG1lYW5pbmcgDQo+ID4g
dGhhdCBpdCBjYW5ub3Qgc3VwcG9ydCBSRkMzMTY4IEVDTiBvciBBY2N1cmF0ZSBFQ04gcHJvdG9j
b2xzLiBTZXR0aW5nIA0KPiA+IFNLQl9HU09fVENQX0VDTiBvciBTS0JfR1NPX1RDUF9BQ0NFQ04g
dW5kZXIgdGhlc2UgY29uZGl0aW9ucyBtaXNsZWFkcyANCj4gPiB0aGUgdXBwZXIgbmV0d29yayBz
dGFjay4NCj4gPg0KPiA+IEZpeCB0aGlzIGJ5IHJlbW92aW5nIHRoZSBpbmNvcnJlY3QgU0tCX0dT
T19UQ1BfRUNOIGZsYWcgYXNzaWdubWVudCBpbiANCj4gPiBobnMzX2dyb19jb21wbGV0ZSgpLg0K
PiANCj4gDQo+IFRlc3RlZCBvbiBobnMzIEhXICgyeCAxMDBHLCBkaXJlY3QgY2FibGUsIG9wZW5F
dWxlciAyNC4wMywga2VybmVsIDcuMi4wLXJjNikuDQo+IA0KPiB0Y3BkdW1wIGNvbmZpcm1zIEhX
IEdSTyB6ZXJvZXMgSVAgVG9TOiBhZ2dyZWdhdGVkICg+TVRVKSBwYWNrZXRzIGNhcnJ5IHRvcyAw
eDAsIHdoaWxlIG5vbi1hZ2dyZWdhdGVkIHBhY2tldHMga2VlcCB0aGVpciBUb1MvRUNOIG1hcmtz
IOKAlCBzbyB0aGUgemVyb2luZyBpcyBkb25lIGJ5IEhXIEdSTywgbm90IHRoZSBzZW5kZXIuIEJl
Zm9yZSBwYXRjaCwgQ1dSIHBhY2tldHMgaGFkIFNLQl9HU09fVENQX0VDTiBzZXQgKDB4NSA9IFNL
Ql9HU09fVENQVjQgfCBTS0JfR1NPX1RDUF9FQ04pLiBBZnRlciBwYXRjaCwgYWxsIEdSTyBldmVu
dHMgZ3NvX3R5cGU9MHgxIChTS0JfR1NPX1RDUFY0IG9ubHkpLCBubyAweDUgb2JzZXJ2ZWQuDQo+
IA0KPiBUZXN0ZWQtYnk6IEppamllIFNoYW8gPHNoYW9qaWppZUBodWF3ZWkuY29tPg0KDQpUaGFu
a3MgSmlqaWUgZm9yIGNvbmZpcm1hdGlvbiwgSSB3aWxsIHN1Ym1pdCB0byBuZXQgaW4gdGhlIG5l
eHQgcm91bmQuDQo=
