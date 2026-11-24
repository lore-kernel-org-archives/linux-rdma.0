Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.53.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537951;
	b=r1fIJyqcZkYhrqnkhaJuzs3lWj2cgc3fS3/ou5LqFzVFBqPyjHKlol3+CElhIlzj8nn1
	 J1SIgMceYk2LtDCH7qGwWgEeUIyOKrvu+rJg3VxZmuOmE8GdGzAR/T+xDHtkSx0CRJzcT
	 w6MhGmiwb1oiJnOFGA21CRg7FOZM37V54El909Kna5kEEDSQL4BBq2xrLEdfGIwGptc3Y
	 3gsqlrNiiivFLZk4INn16xCg2vLyjbtYEP2OTXRp4UV36iT9XKe86k1QGupyVmahdA0NG
	 Q1NaAH9wqGTXtjf4PqRESLAry91p3ZdPmC6mFxYJAbl8ef0aTQx2Zw0wRNDld7yI2BA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537951;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OAbk9+epIbGokCBVcvwujgbvjNT83mxk5DVBpkVzlMM=;
	b=SFt3Oo/YL1vyCwPD6R8/Lttg1XY+4pGASYWkudKLcTFWGgb3sUOk/g6lbmHzRTNeOaXv
	 lt5tpo26Y8h/v0heFuJS6VTDQhFUPSqP6GiTTwYFPWT2DydFoD9TVAMmqr1f1s4BVKtNd
	 yWVG0OrTaNKCyzh0c1QROoheJ7MTGcbtc5E6CQsMkAfKfFPSWEvrt8q0sq8d6mjX0rvQ0
	 YbGO0Ket4biiA74tXl3yuQkSe+VhBibSF2TtxJUzUE9tQ5nd9gqyPOaw5J9dt348//V8X
	 Vhs+mfTQXdPjo0wQMTiTYigQqLoY984vZwuerEOM0WQFdD/HrV7gKKPtW0fF/Ges0VQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hotmail.com;
	spf=pass smtp.mailfrom=hotmail.com;
	dkim=pass header.d=hotmail.com header.i=@hotmail.com header.a=rsa-sha256 header.s=selector1 header.b=WhuHoPbL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.53.19
Received: from WA1P291CU004.outbound.protection.outlook.com (mail-polandcentralazolkn19010019.outbound.protection.outlook.com [52.103.53.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D2B606A31E;
	Tue, 24 Nov 2026 16:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8D2B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hotmail.com header.i=@hotmail.com header.a=rsa-sha256 header.s=selector1 header.b=WhuHoPbL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3SYQsI6Mv3mTW0/Heu7S4dpz0aDnZ6BeksuECXVbhuFPoRefKqnAFPO5Lui2fUOtNSEKeGXPTisOmq5GPCXHXTZTufXPjX9ihDnXtDjgSglpKJr7llM4OGY9MlPQYD9tylmu3CzMqv9p/aYtX7H24UPDiqBUs1xV3jUgZWzNCMS2wHHZOS502fqmpg+qPkuK1azWrep/BEqLCMQrrtKecSNEgrhDtmxVZ12i1Inh/rBJ3qonlhqDMlrk8joPTzf56MTjk/6y0+SWJR3Q1nbFWYNKELhUPrlxpbBF1CNssgZKxEeNN25WyK0iDVYU2BE2ArPpKBWQLd6Cbv1I7fCdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAbk9+epIbGokCBVcvwujgbvjNT83mxk5DVBpkVzlMM=;
 b=IJcON7Uj00YB0GDwCsum7lP1uq53lZw6Z8Hm7vLW9ufXb+/jmjUwQ3CIIbcNwTookcs7llkzB3Fq/1DFFpRQazddKag04x709btVon8Ts0UY0B/OpTWKXScFgX9M8BmJILC8K2IpEJ8mPyyWrcSmjUT/hTxvmmSzyiH0oME0UVvMnr4HsgE4XaO88nQka8IGuZhvojvbQ88jh1c7XiY3gZ8Cln/HBuzcoXzzEtNkQgftLOA/UJAuyUWCTx7dYEXxph/UI37NKX9dBQhz/1RcbeZwMIYTq046hhWxQuRpRlGGaPIejK2Y7UkyoV3jvddThnGwbfKqWPfE6rQ+3D/yQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAbk9+epIbGokCBVcvwujgbvjNT83mxk5DVBpkVzlMM=;
 b=WhuHoPbLq3yCtwgjNaEUCm1EXe8Nk4a6Sy4Bf75Q+9UlFeGzVsOn5hwwNHPouJTslX/laLaxwbkxvhz9SH3ly01VaVmAEhw+xodD+u8XSLxSyUuPe7swC98K0kMUrRlmTjBtFy4pUklzHo1j5sru0dVEBs2a7tGhuuorcgFUSVUIW7WU+LuIYG+1OhmL1LMpgmmzL/cIJfsA7Ivr80i3QF4gFFySw0FYJSt2yx7IR8ItmO2m8WFYhzpa898J5tYNC+6PHAs9CPvkWuaGRaAeCRgxuBI7WpVYaehNmt7HHYsoxZcQVeIe1PvbBeO55fRzCrl3b6WYYVOuYBZQTnbSPA==
Received: from WA2P291MB0187.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d0:26::11)
 by WA0P291MB0146.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d0:4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 16:32:27 +0000
Received: from WA2P291MB0187.POLP291.PROD.OUTLOOK.COM
 ([fe80::996b:1617:ce96:404]) by WA2P291MB0187.POLP291.PROD.OUTLOOK.COM
 ([fe80::996b:1617:ce96:404%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 16:32:26 +0000
From: =?utf-8?B?SGFiaWwgRXJlbiBUw7xya2Vy?= <habilerenturker@hotmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com"
	<syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com>,
	=?utf-8?B?SGFiaWwgRXJlbiBUw7xya2Vy?= <habilerenturker@hotmail.com>
Subject: [PATCH] RDMA/core: Fix slab-use-after-free in kernfs_find_ns()
Thread-Topic: [PATCH] RDMA/core: Fix slab-use-after-free in kernfs_find_ns()
Thread-Index: AQHdfDFk7AhQU1eyo0uyOMuSroWd1g==
Date: Tue, 24 Nov 2026 16:32:26 +0000
Message-ID: <20261124163151.50468-2-habilerenturker@hotmail.com>
Accept-Language: tr-TR, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: WA2P291MB0187:EE_|WA0P291MB0146:EE_
x-ms-office365-filtering-correlation-id: d6d17542-094e-4ac0-4acb-08df4a4886cd
x-ms-exchange-slblob-mailprops:
 Om8TgR6f4EDKwbHiBQa7ExePO6wqvFC11NlF7sG1hNeydt4SDVDbcUva36ZoNuTiZpSGz9MW3Mzh4YlXGrpHN1XOAWHRbFbjartDnWPaQkYPL3uJ6sXzuFYAn2ZFroijpVCSs7o+Mx6IYN3y7JPXkBVFbeJdibWPUGORQB0dul3OxJ9P9m2+GiepLpfC7l2SL4wyt8fsvvy97WrtS7mui2X1kDR0ak9ZUgdpX+u8gd2U/CX2ZTqnuYJ0rtQyFiPqG11RZhF9qJAQVIVfuYUJU2m/aeW4R4RWivCPZrE2TsbT0GSOzb5KgugCe4/mtLc+BP+HP0HwtPS6NuO1+cOcmbTJcWG3CqvNf9uX9NOwMmzPqUrb0MJ6RpI4v4N9ghf0BjEM+Y8NocUzbTWQGuZ2UWk5WExzPjv7VCFuU/ojMqqsbIwmgUeRogegfno9PRhluW2gZJ2khhH4nEmf5bjQDnm3Ho/B7jvB4pyqZ6hvDsqr+RWf5nsuSBQPXgACtB7b7yImHSVUr3qQZqQXyo+kA1BpMISwc5pkQt4o35EGwLrlufhnzH/Nw12Fve4U0rq5vvrkeTD4clUToyYFhJ+hMXNB8cTGTuEbBpOok9XB8VVUfXKFIQ6EqWczaGeQ8RN23oXuaqz8UDvEp7XpnxwZbFS3FzJ0Ab4+rz62Y6o9bst7/ZG2P07OgPnRusvaRGBwOBRYiqPER+OTZ8ac2FOMsECfaOwb5oI3c7O/hWpgpSr8r9V9/zXziVIgDVsPDMSLEXJppMBbmuae//mVNDx8Vzi0E68y+Lpyk/xD6xQrIeNFG7xTalnSyPX1xGF1iO1wNuOyZXjamFPwZH2QpRfEPzXK7bommG43
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|5062599005|8060799015|19110799012|8062599012|15080799012|55001999006|31061999003|16041099003|25010399006|4140399003|24021099003|102099032|3412199025|440099028|4302099013|1602099012|12091999003|11031999003|10035399007|53005399003|40105399003|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?LytqMFcyb21EQmxDNkYrK3R2bmtnVkRwL1lwMHlIakJDczRDWkVpaGJnM0FM?=
 =?utf-8?B?SzRlUzZwS2ZBTlNHWkMraHVUa0R6SitVaVdaci9VYUtTZ0tnMHluWU5PUkZp?=
 =?utf-8?B?QlJrNHZZcjRwS0l6bkJKQXA1N3pvZFdPaFgwS1FwWFRha3BxMjdBaHE3VExt?=
 =?utf-8?B?QUFlVDFpdUF2ZlN6S25iMjZQdVdTSnBhalR6eVV0Vm1ZRVBROXV5ZVEyQ2xF?=
 =?utf-8?B?a25aNkVnY0F1WGgyQ1pFVnV5RTE3Wm1zVmUwRVBiWno5MTA3M1Zpd3pTMVk5?=
 =?utf-8?B?cnZhdjJKckVyL0pWSkFQL0UyYXBsaWM2cXRtLzlRMzJqdWZpOVZMa0xBc3Bk?=
 =?utf-8?B?TjdaSHBVRW5pb3c3dyt6KzB0ZXIzaUx3MkNFNHpWM1l6OG5rdkVLWFQzeU9a?=
 =?utf-8?B?eXg5KytZWHE4YllUelpjcUc1RWJ0RXFmLzdRempTWHFqYmJXQ3Q2V3cyWjhh?=
 =?utf-8?B?RjVxV2ZNa3dTWkY3K1RtUkdtNzNEaUI0VkI4dzhVQzN2VytUWk1Tb2pweGI3?=
 =?utf-8?B?cWUvMnFSSFRTbFBicEtUbE9XOVN3Y2w2TjVidS9UOFBOTlJOVmdnUUM0Zlkr?=
 =?utf-8?B?eVN5T0ppcjVzQU93QkcwdStMa2MrQVgyMEhURmowM0ZVSXV3a1hDdElPT1hR?=
 =?utf-8?B?MSt3elNLU3h4VjBiNG90dGxvdDRhbHVTQWIyYTMvUVZ4Y3JRODJvVnZLandm?=
 =?utf-8?B?NHpoL09FVmViRXdWeU11c2xqdi9wRk94R2gvQWxVd0VuczcrRFQ3RnRxTlgy?=
 =?utf-8?B?ZjBJMDBFL2E2VC9kdjFzdHVuSnhOTnZSYnR6V3FwNC9NYlh6V3FMYkFZRU5X?=
 =?utf-8?B?M0NpNmV5dzhEQlF1WElkTnhOajZKY1IrcEZJREZHN3haM0g2YXVUSjQxMGpH?=
 =?utf-8?B?TGhUeW83N09XVEZHSEJKcm1uZnAvOUZqdE1XZzhHWFlLNStsYlpUaEJzb0RE?=
 =?utf-8?B?UGhMODhqT3BVdDI1OVROTVp6ZnVMMWVKUW5ZODc4RTB3N2JVVU5KeU9FeVc4?=
 =?utf-8?B?WTg0ajBkMW1uS3hzM25nQTNNVmhNTzZFYXovdytYOE9OcW1QT1dVVmk3RVBX?=
 =?utf-8?B?UHBNWURLaDlpT1FwY2thcEZDTTlpY0x3Ly9kUkVPSjFRSTNUUTdPUGJRSVp0?=
 =?utf-8?B?dU1ZSEV2MW1zV3FIWWl3VmhDUldNYnhGQ2xIZHhGTDVwNWZQZXJWdFlvb2dh?=
 =?utf-8?B?anBFODlraUZJOFNNZUUvQjRIT0lIcmZHSURVc2o2VGhVTkZnN291cDRLeFBU?=
 =?utf-8?B?SUdRaEtwQVEyR09qN2hEY0U4MWxDY1grVHFacDk4azRUQ2sxSm5OQTVrOTNE?=
 =?utf-8?B?bURuKzByb0xkQ0huVS8yUEFKNlJpamtYT2dycnlTMVcxdU43eEUvVXVYOWlS?=
 =?utf-8?B?M2pYd1RuMVpmdXI2VXlHY2RMVkw2N0FxeHZVbDRXaXpRYVdKeHl5dnJ5YzBx?=
 =?utf-8?B?dklwSGNIY2RwZndldE8xU3lnVWNYT3Y0QVdRajlobzJabTI5VEJ0c25ETjU4?=
 =?utf-8?B?cnVnbVh6Q3U0Kzl1emliaEJWRkpUeVBwUk53cjhhSkc2WDIwK3Nlekg3UlVo?=
 =?utf-8?Q?LK6UpivDdgOUsHQcwiX9zFojG1B5z5CkfeNUMsGTEeeLE3?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dkkvN0pIVDFGOWFqdGVzaXo4cU9MVzFhUjVGSUxXQ2FPNUFKbGVGMldYaTBZ?=
 =?utf-8?B?a0xUWHgwVmJ2dERsS2o3QmI5b1U1d29vK0hFNi9MV0FsRG1RQk5kazhlN0Zu?=
 =?utf-8?B?dzgrV0R5TmxobWg4QlhRS3NmN1M4eitxaTRxRlRjNXNWZFF5bXU5aHJjSStH?=
 =?utf-8?B?VDhEQTBSaUNxM3ZZNEhoSmg3Nm8xVXcwaEcvZEwxY3Q4bUJMQlNETDZWTnBE?=
 =?utf-8?B?Y1Y4SElOWEdZa29hM1ZwYmRzNXRXKy9zdEI4N2V0dkxnNHFWRlZXV1NXVEF5?=
 =?utf-8?B?RE0rcUNLTGdBejBWVTlmajI2cGswaEtWZlRxdUZhUExEQXVxN2FWdHZjaE1r?=
 =?utf-8?B?Y0wvblpFVzVmdWlWR1ZETUo3U0thZFY3d0VYVzVYZk1mVS9XWUN3WVE2V1hI?=
 =?utf-8?B?UlYvVkNiUllMeE9sNW1VR01ZZjRDMkt2cE5mNnhqcDV0blh4cTFKc3RidGNF?=
 =?utf-8?B?TXc3NzJENHltRjA1SnhOT0M5SzlKbC9YZVpsTHhFdUlpY3dRM3puR3FRRWlo?=
 =?utf-8?B?QWd2UlVySTRYQTF0ZnNPbjFtNitFNDN4K1FXQkc4bGo1ejlHQzZINlg3RzRB?=
 =?utf-8?B?L3cwMi9kaUxwQmhDdUZoOTFtSXNMMjdYdEMwTThkN04zQUF3WlB1d3lEaFBJ?=
 =?utf-8?B?QnVNV1dEMFlhaFArTHg1TEt4T3BOaGdTUXFhNkJLMHJDRGNUREN5aE1ITWNi?=
 =?utf-8?B?SGhFallzaGR5SWczZEVwaG9yQ1Y2eFV5S0dFazZqdkZYYnZrcFNsWDNJekhD?=
 =?utf-8?B?cEsxVGw1eE5pVFUyWG5iZnF1Z0dYSkRuM0Q3K0RvOWJDRXNFWHlsVjQ0OW5o?=
 =?utf-8?B?a3hPTU1QUjZ0TG56WXpLYmkxZm40QUJqWEdIOHFjZ2I0VXBOVDlLR3lrVE1u?=
 =?utf-8?B?V3o1MStER210dzNrSDdnZlBkb0UzekVYcHJRdkJQa2FNMXZMdUkyZXlpcDF0?=
 =?utf-8?B?Y1diUktUelhOQ0tKdE5jZitDYWJLYWhtVTNSN3VabDVxTUZPOGp4SE8yTXd2?=
 =?utf-8?B?aVdXSFljNFBLNkEwUFVma3hlWGJ0eGlWbmpLcG00STRpbXhUMzNwaHQ4blFU?=
 =?utf-8?B?MUJFSkZpS2xPbG41blRUR2xoYXluOFExM3M2ZUxOL2VtdHZ4aXRsQTF0YjF4?=
 =?utf-8?B?RUJGMC9SOXl5VUI5SDRyM3FaZk1hOFhmbmpzNXVhT2wxVk1CaXZFdCt5c1Jq?=
 =?utf-8?B?Q2hJcmxWRjRDQ2pVZ3p4TDFEUnpPeENhQjdjTWxWTCtSUEpjOEF2WHZOMWM5?=
 =?utf-8?B?cjlhS2xEMFZBaHZmNU0xYTFhVXJRQXowZ0ZObXJMV1haOU9Ha0xrTXBKbklj?=
 =?utf-8?B?Q1NpTzlzTmI0cTRXd0taUFpnb25YWjMxTzVzUHVaWjFBTTRQOUhMbVVlbVps?=
 =?utf-8?B?T0w1TGtHMEovSjF3d1lROGRMMFRiak9nQ0ZYNGVzSjI5eklBT2lGUEVvYnc1?=
 =?utf-8?B?cERmSDNaYnlhblRyYk5uclMxRFNPeG5ZWGJCRE5lTFFYcWkwSHVtbTFjVHR6?=
 =?utf-8?B?YWdTT0tndldWckFsR1BpRWpwbDdPZVMvVStvaTBOdzJZd1pxT2JyS2dmNnZx?=
 =?utf-8?B?Y2UweU0rdFpNeFZzZXBlRnRUb1NrQmZBN25nRnpDd2lRMkpMQmxRRFJsMkI4?=
 =?utf-8?B?Wm4xcW45Y1J5eFE0cG5XR043MHNkeUN6TkZISnRFb1hpeDRzUnIrbkxjNmVG?=
 =?utf-8?B?Rzd2ejFZajNSc2c2WGExT0FVUWQrTnhRMGJlZE93NHlQbFB5NlYrNW9DcE1W?=
 =?utf-8?B?bHFTUTllbi9sOHZuZlJuZFo3bXltbVFFWWdFUWVrZ1ZwcHJOeEFZd3ZraGZx?=
 =?utf-8?B?aGRkK2NuSzg2dUNjSFNEVGpOTlNiUGFyM21jdHIrSzdiQVgwWlM3MTdXWHJV?=
 =?utf-8?Q?ScssRx2ogHfY7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E2CB86F79137E49AA50E2849B133D8F@POLP291.PROD.OUTLOOK.COM>
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
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-2112e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: WA2P291MB0187.POLP291.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d17542-094e-4ac0-4acb-08df4a4886cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 16:32:26.9520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: WA0P291MB0146

SW4gZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvZGV2aWNlLmMsIHJlbW92ZV9vbmVfY29tcGF0X2Rl
digpIHVubG9ja3MKZGV2aWNlLT5jb21wYXRfZGV2c19tdXRleCBpbW1lZGlhdGVseSBhZnRlciBl
cmFzaW5nIGNkZXYgZnJvbQp0aGUgeGFycmF5LiBkZXZpY2VfZGVsKCZjZGV2LT5kZXYpIGlzIHBl
cmZvcm1lZCBvdXRzaWRlIHRoZSBsb2NrLgoKV2hlbiBJQiBkZXZpY2UgcmVtb3ZhbCByYWNlcyB3
aXRoIG5ldHdvcmsgbmFtZXNwYWNlIHRlYXJkb3duCihjbGVhbnVwX25ldCgpIC0+IHJkbWFfZGV2
X2V4aXRfbmV0KCkpLCByZG1hX2Rldl9leGl0X25ldCgpIGNhbGxzCnJlbW92ZV9vbmVfY29tcGF0
X2RldigpIGFuZCBvYnNlcnZlcyBOVUxMIGZyb20geGFfZXJhc2UoKSwgYW5kCnJldHVybnMgd2l0
aG91dCB3YWl0aW5nIGZvciBkZXZpY2VfZGVsKCkgdG8gZmluaXNoLgoKY2xlYW51cF9uZXQoKSBm
cmVlcyBzdHJ1Y3QgbmV0IHdoaWxlIGRldmljZV9kZWwoKSBpcyBzdGlsbCBleGVjdXRpbmcsCmNh
dXNpbmcgZGV2aWNlX3JlbW92ZV9jbGFzc19zeW1saW5rcygpIC0+IHN5c2ZzX2RlbGV0ZV9saW5r
KCkgLT4Ka2VybmZzX25zX2lkKCkgdG8gcmVhZCBucy0+bnNfaWQgZnJvbSB0aGUgZnJlZWQgc3Ry
dWN0IG5ldCwKd2hpY2ggdHJpZ2dlcnMgYSBzbGFiLXVzZS1hZnRlci1mcmVlLgoKRml4IHRoaXMg
YnkgbW92aW5nIG11dGV4X3VubG9jaygmZGV2aWNlLT5jb21wYXRfZGV2c19tdXRleCkgYWZ0ZXIK
ZGV2aWNlX2RlbCgmY2Rldi0+ZGV2KSBmaW5pc2hlcywgd2hpbGUga2VlcGluZyBwdXRfZGV2aWNl
KCZjZGV2LT5kZXYpCm91dHNpZGUgdGhlIGxvY2suCgpGaXhlczogNGUwZjdiOTA3MDcyICgiUkRN
QS9jb3JlOiBJbXBsZW1lbnQgY29tcGF0IGRldmljZS9zeXNmcyB0cmVlIGluIG5ldCBuYW1lc3Bh
Y2UiKQpSZXBvcnRlZC1ieTogc3l6Ym90KzhjMmZhMDBjMjdlY2FmZDE0OGY1QHN5emthbGxlci5h
cHBzcG90bWFpbC5jb20KQ2xvc2VzOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/
ZXh0aWQ9OGMyZmEwMGMyN2VjYWZkMTQ4ZjUKU2lnbmVkLW9mZi1ieTogSGFiaWwgRXJlbiBUw7xy
a2VyIDxoYWJpbGVyZW50dXJrZXJAaG90bWFpbC5jb20+Ci0tLQogZHJpdmVycy9pbmZpbmliYW5k
L2NvcmUvZGV2aWNlLmMgfCA1ICsrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2Rl
dmljZS5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvZGV2aWNlLmMKaW5kZXggMjlhZjlmZTg2
MGUyLi5mMmE1MmFmNjQ3MTggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2Rl
dmljZS5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2RldmljZS5jCkBAIC0xMDMwLDEy
ICsxMDMwLDEzIEBAIHN0YXRpYyB2b2lkIHJlbW92ZV9vbmVfY29tcGF0X2RldihzdHJ1Y3QgaWJf
ZGV2aWNlICpkZXZpY2UsIHUzMiBpZCkKIAogCW11dGV4X2xvY2soJmRldmljZS0+Y29tcGF0X2Rl
dnNfbXV0ZXgpOwogCWNkZXYgPSB4YV9lcmFzZSgmZGV2aWNlLT5jb21wYXRfZGV2cywgaWQpOwot
CW11dGV4X3VubG9jaygmZGV2aWNlLT5jb21wYXRfZGV2c19tdXRleCk7CiAJaWYgKGNkZXYpIHsK
IAkJaWJfZnJlZV9wb3J0X2F0dHJzKGNkZXYpOwogCQlkZXZpY2VfZGVsKCZjZGV2LT5kZXYpOwot
CQlwdXRfZGV2aWNlKCZjZGV2LT5kZXYpOwogCX0KKwltdXRleF91bmxvY2soJmRldmljZS0+Y29t
cGF0X2RldnNfbXV0ZXgpOworCWlmIChjZGV2KQorCQlwdXRfZGV2aWNlKCZjZGV2LT5kZXYpOwog
fQogCiBzdGF0aWMgdm9pZCByZW1vdmVfY29tcGF0X2RldnMoc3RydWN0IGliX2RldmljZSAqZGV2
aWNlKQotLSAKMi40Ny4zCgo=
