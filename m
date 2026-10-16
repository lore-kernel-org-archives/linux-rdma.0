Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023119.outbound.protection.outlook.com [52.101.127.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BB83B42C9;
	Fri, 16 Oct 2026 07:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135124; cv=fail; b=iz77oRTdZEaIpfKl989oB2YyP6QuP0W+DgU9EYyRSq5A4SPEDi81K6QdhAMFaj79jbJytw8fP8HQ8UgVR4lWxIGovIupAmJxstryG5WdBBS0uAcnwI4ErtV67gDUP7LJM/+K0ZlXxoFOcjuyXdbgsgnd2BvDXmruDn0LkbY5GRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135124; c=relaxed/simple;
	bh=upTuCc0kLKurxSPmetxuXiZZn88rD3233CJTbrMT4XM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZooLCMO+585EwvLAdD+EXYzRYHxjfUtDZb8yaa2sfoCECdyOw1XQf2LJ1u0eSyMdQnUSPU13ntKL7gMpFg8dUBqDquBlD+zSiax/sXyDdIUKN1BM0lyQMl5lOE0aPYjDiCv3Nv/NRSi50bNxha9CviHUdokW6VdyGgkdwaN4mds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Ckdtkvlx; arc=fail smtp.client-ip=52.101.127.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Ckdtkvlx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aKxUzXmewz0S3viBsDhh+r/GmPmIS8q1CWF8hM5g7zeTlVvzP8wTmfbEqNQTW8kWUW0bEbKb8V26JbQ84Nzm/tY7xlBfUjQcipGfvarVo10jvNXAh+08zV9jsj1sa/l4vgcOgwlJ7QWcgYQkidOiIA6UrFRxN+cFAjZWiuOJk8C31t9zFnWMnEbtoKWh/N5dYs7GdVZD8DgBJEwkWEN5IkJavrPLvUungW9kj87wcPjGB+BFxsuQR3Hunct7JRWHHTbOkyB2fyo3dCiIApWZAVZjnBK67pV/B95kh0HHZ0G0IzxD6zb9YFg/OkPhpRaLVE3CDCPGA4CIuOu56Z9hRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=upTuCc0kLKurxSPmetxuXiZZn88rD3233CJTbrMT4XM=;
 b=jZhD9ZD499Hm2TSrirkainXf15ce0WlhydRE1HlW2Ryv8rNuFzceAjAxUZOKKfiio0L5F/nI/i0/IoRYoDw01kwalfoN/0f0HrCGR3hfz0NZ8tNNXhWe8S30iDxkK7KNFW+IyvBTU5tJtVT+cHKb6Gtsft/851quaJJ8RfT9gqQ4lptyUGEU2wZn+1RRFyLGifDIKwefxJpRVJvrVTl/bLNMdfCOiDC4d1o+qrCLNzW+rT7EHKvozlQTmfXBnKrrCIo73BukQ1KW7bg2E5k4jA3RIzl3yRFEs/jjSLaqzqodbQylo25me/I1pAaOdOcuM+9RCI/PRN0hKN+WtdO/lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upTuCc0kLKurxSPmetxuXiZZn88rD3233CJTbrMT4XM=;
 b=CkdtkvlxTO3CsAtQaqJ+LFVmwPBB/EhyVdB+3eYxypzoSc85GGcikIz4/H/TIVKJbKnbYqQhC0BSqLbMge+vjTPRbGulUdFgP6Pf37iPbQ0bdT3gwfw6frPaKP5bvpPqlItlLhpK4BeyXL5tI/vGHH67nf6yGRJw7SY4I9c5ei4=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by OSQP153MB1329.APCP153.PROD.OUTLOOK.COM (2603:1096:604:372::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 07:18:26 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 07:18:26 +0000
From: Wei Hu <weh@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>, Wei
 Hu <weh@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 3/4] net: mana: support
 concurrent HWC requests
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 3/4] net: mana: support
 concurrent HWC requests
Thread-Index: AQHdWum7zkNP3rIK9U+Z2ggti3z/5bb8r/sAgAMWCEA=
Date: Fri, 16 Oct 2026 07:18:25 +0000
Message-ID:
 <SE3P153MB1848BB5FEF00BEC4ED516A8DBB9B2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1791561995.git.weh@linux.microsoft.com>
 <08f833983788be99fc73b856dd4822826b5876f7.1791561995.git.weh@linux.microsoft.com>
 <sashiko-outbox-170991@kernel.org>
In-Reply-To: <sashiko-outbox-170991@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9e8741b8-720b-480e-9e08-bf3d3fea0683;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-16T07:14:01Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|OSQP153MB1329:EE_
x-ms-office365-filtering-correlation-id: f83746a8-43e0-4584-d921-08df2b55ab5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|42112799006|366016|38070700021|56012099006|4143699003|11063799006|261009223027099003|7146999003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 RfGz3T4NFDi5K/P1MJuvJQNLWyDPIL85pW5HdSLt+nYAzlpbygM5XusPOHxT116AiBHdCkJmpLN9iU6W8Qhmiun03AUiZYiQVTZexTZM0Ag0qirKZFtXwa6gun1bq48X1dk5I6LHeEO/B8+wp2YCBbUaCceYZilsx1dbYRfTiLzZBGZLWk2PYkC1eWgDbFPTmg3mrJUYo0N6ZdwsQZ1Ofycp0bUAeear3ebodr0vPVxZ29blBwCec0fWsRUG4CrBkeHsHIwE4qYbAS4GaHj126CwZy/mhfPZlvuuUC12lGgdcsG6DS2sPIBxRxXo9DAumKCCufOIZUaAutGf6PIZ46YeYB5eJxkiuwSBcsOgPm5jqXHS+X6hVd1VY7f7+Y+TSNKfyE8yLso9xM2T+aT9cMfJLaP+6YlVIYxn501Il4rJKJu9dtXyQNoIYd1QbcevRt4s7p/pHO2STNc/zIuB9qh8n7+KyGv9LQLSUyUCS6YdS7QdQD2ZeA8LJH8eqBSz+pjzAVbp6Ck8IjKn7yt/azwXLkPcKXHP9UoliviYIPv5cBCGDs7402mZ/KWyovCiqFZTeEpCbwb4sxcOr/oOjV3HzgBoyN01uM04Ya9Hg1jNwmcyWRL8HHz61QYFfIhuYOWpM3XKU4NVd+ArYrvgeZeL3hAEsSCQT9B8i5UITUJo4JK9hm3XYakRnu4qnWpXnkTDgn5pFxRPOjXWSCvciUa0NsxpyA1gZlWpp4WRXYI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(42112799006)(366016)(38070700021)(56012099006)(4143699003)(11063799006)(261009223027099003)(7146999003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?e2D7uZP92QAUx047qt2QRsjeXG+lk1hQITX6Iy7QWsCZWZOc1tkQl9YryMPp?=
 =?us-ascii?Q?+xzlfcXSDTHIzdoPeHleWIKFKa+hyrbcuDFsfKO8+oMULTz008y3qKTaqREG?=
 =?us-ascii?Q?8Wn1K2Zzt9xGcg3w928cedkrQEPQR2AX0uak65ios12quHDYuKSlsyaUQUR0?=
 =?us-ascii?Q?qz4mbtBtk+ZzE1ciDRjq2kKvAylHy6Eh/IDmrrdDzCpbMdogW90RsM72hBWf?=
 =?us-ascii?Q?Nl9ydyC1xnVgPROlG0nhC20da8BqMMQFBc+MnEYeYftlWc2yKTl1gYhTrYaQ?=
 =?us-ascii?Q?Zu3ENxCT3v48edaT/Kem4UijYWe/2KBOIN4Oe5z15l8xY409OOrfIHve19s6?=
 =?us-ascii?Q?3n3jrQV7hplDLnwOsUdwRdyinPz6TW0J+11FN52soYR2+GtBYOrn0D3B0Coe?=
 =?us-ascii?Q?3iIeDyK5bxEMoxI7n6SlIuYkQeMgTCWF0mQutYI4EdMy64Jixp/5jxR+ECbX?=
 =?us-ascii?Q?oB6HVKG0XoNhRpSsbR2S1yJWC/Z9eKCxhIQ55czwgHSfJfjk/jt4ukEGq2mb?=
 =?us-ascii?Q?wukstFf0JmDlNf5/izMvqCZD0wGr90qUFOLgPGIz6ecrqizYADemPcx0LDkv?=
 =?us-ascii?Q?akEoWSIM4Q8VFgJe5Xu5kI0cAVoNA6p2QSzM6z7tdZIt/0bQ7JvBzMMkTz0f?=
 =?us-ascii?Q?XN+bV7PhJNXHDHC5YfvOhsOOH0bkJZOBVVw+16+QOouQ8Nf+hQeYhEzv90yD?=
 =?us-ascii?Q?RtqnI9Ag9FfXRKuEcnNRiv7bvq7GXcJlt+lyw+thgRvGWNxQKFB7txcAuHDV?=
 =?us-ascii?Q?vInaN7uFLFKKk3h6ffUWFrI326WrY5g28P7gOXkMwlZACvK155j11S/Rtqx4?=
 =?us-ascii?Q?upjRsOqimqV2kmdXetB4ofCbTzJ8ikcRqOSpDY1cb9Z+ExeIsGF98tfMiOSo?=
 =?us-ascii?Q?yxkTPTHU7Y55rLqwfT8tMIXyDWi9sU2SOL+g+V5Ha3IlCOVof/oJqErq0UMn?=
 =?us-ascii?Q?yx+ZZiHlDt3qNfLnNlRqejZMr7Hp1HjKuVO4q+J86FJdCMVEW1yuzhz+XGIN?=
 =?us-ascii?Q?LFy2ExEch4V7vu0Tzd+82gQW6Tpai5NYXjiTWrLndBpllVG/67k5Hksk784+?=
 =?us-ascii?Q?85eUJ3uPTy8xiPwIkOnX4K+jXZNjosocd/ULr5NJCpJ9H2LtD9JdZX364cbm?=
 =?us-ascii?Q?Q/7NLng/m1+wMnVO5oRnpNYGgxoon+ZBZB0Gh0FrPNGRoySBjfRdHFdo96P2?=
 =?us-ascii?Q?y04l5mGc7qfzixI7e/x6cGMtr+G+meDY79USllE5VTIFLeXojG9IiVGwFlCp?=
 =?us-ascii?Q?tgXvLe7fl9+MQix4Z4O1+WvtO6VhSJsEU+2QRTwq45xa+wGcJWIsBN1syzPS?=
 =?us-ascii?Q?rvLyWSYHKI00m2PK/3Id3eWSWKFuC6qN28JPwfo6qjmc2OIdTM2q8DFGyhZP?=
 =?us-ascii?Q?x97Br8o6fhsQo+PX0DzenfOHpXLDXirpFK1dfPYfR8rRAISojMoo5BEqMQ0D?=
 =?us-ascii?Q?evRXqQZOnVM9kG1/pl0kCOEUNcPK1Pz9Rw9Nuo2gjozKfPrxJOUAZ1P2UcC9?=
 =?us-ascii?Q?p1ybZQmDc1Q2VqNTUazOWVjsnu0UgKwpVXiuEZVxqxrrtWMk8StJkQ7NOmrK?=
 =?us-ascii?Q?nW+env43adEk3xkVAs1KKHCQqpf5U4Yb7PKAVUTI68/sYR4JUasBlyXf6AMo?=
 =?us-ascii?Q?67CbC9OIqjntbFVByo1Cyps9+L2W5ECynNCxxblnrhRn/Vdz/YMqRh6/CB4g?=
 =?us-ascii?Q?D5EvaF1nLcf18fL4zSUyiKRkXr8ZatNQnb34DJCaSPlkJPMx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f83746a8-43e0-4584-d921-08df2b55ab5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 07:18:25.6542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6oo0h1680ESyNTHofubnwcDA+iU76okDzsOTiDGU1g2WPGWVCjVxVaEYM2WZ7fd/cu1BKNEIXAF6DkngcUsXOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQP153MB1329

Thanks for the review. I have prepared a four-patch v8 based on net-next
commit 05b5019b01fb, with the following dispositions.

On Wed, 14 Oct 2026 08:06:24 +0000, sashiko-bot@kernel.org wrote:

> [Severity: High]
> Should there be a bounds check against r->size or hwc->num_inflight_msg
> before msg_id is used here?
>=20
No additional bounds check is needed on the reported path.
mana_hwc_handle_resp() is static and its sole caller is
mana_hwc_rx_event_handler(). That caller reads hwc_msg_id once with
READ_ONCE, rejects msg_id >=3D num_inflight_msg, and passes the
already-bounded local value to the helper. The helper does not reread the
shared DMA field for indexing. The existing out-of-range early return's
missing RX repost is a separate baseline liveness issue, acknowledged here;
it is not an out-of-bounds caller_ctx access.

Regards,
Wei
