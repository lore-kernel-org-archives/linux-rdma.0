Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021101.outbound.protection.outlook.com [52.101.57.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799032D780C;
	Fri, 31 Jul 2026 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533163; cv=fail; b=lIIMvQExIEeSXapD1ILiwt/iSWucQoSW6Vx9MLQc8MYG8E9gTU+NZNkSjlSTmIOqpnrpxjqbMBFXiRFJynXLsQaZAhXZkVGC24yzPMpyVrlKWPH7Gy8mYxI7x1O6wyLe36lONxGneYuZjjbmabJwkk8612EGkEwJjzB52rrdrB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533163; c=relaxed/simple;
	bh=kLiH5/58Ek/pirVz2RfiMnmwzwb+Sul7Kon85JhE2j4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BjyemE4GvacYgRh8bqog/GoaM/4AMDO6xd3f6WF647594ZPp0A5APc7c9XgUZ4vDPf1By0Y3KSR1Xio4F7eWBTT8+Ui/YFLUBouDkyYnoHvg2tZ9c68WZdwAaQz67dSFsPCpuLX9aNNRjbvHSP9UPnB7BPSzYjtrOfTH0cNG4bI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Si7b+M/2; arc=fail smtp.client-ip=52.101.57.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Si7b+M/2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZKuThtXNQ9U7b+ucKfFnS4IXM/8r0jFNkurwBN9VL1yltqSzQ9vgzCKq3T33XaDqfJaAx0MJI2B+FiLpb0qioGxN8ym99/GUaQxVh0YBFAP0YWGzWdZoE5ucruMzjOJK2a/J+twjUBkw7Dv5YI7fRnchIXUG+/vdkJ9uZQ+kHKkY+JsDBoh+vP2jJj0yYE56VaJToYDqv4g8k/Ax0pAnMVEAWsYBUKJ92coMs4lk0TZvc5k7giUtlpQEgfMo2PvZlvi1mbZQLjUgyQs+kY26K7c5thfQUsbVzGrNQWIom8rzQlL0QtdQIE+lWcgqvzN7ptamG74IDwzqPCzQFpf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5x4OD3dKMKs4+4XhlRD3WT5Y2WCfwAfbbiAo4H23Rdc=;
 b=NaEmGpn90H/+bGV/XjtY1IQmHtaSsRebzXfpkLxOBmHpKBUjYZYmUIl0N5VVNy/1QQLtiEEXC2K+zaHkvfptpVKkB+4ZSSWQ7GoAJykyAOxHu77NHIUZlhXzZmo+L4vfpMaM6VL8EtdK80BiRMb9+Sa3zVCHwteoJXDrrj3FU0fGQe5jGs4Iz19a6QYYs6zYwZAP1qhVNRQSE30Uvu9+JkNyqxhv2pBLc++P8eXYJXldxUxjHwXjA3uU2lqqQ3NlrUMva9h9DN3AOFG84yfDLjsrq5lvxH5OA+fhWbbk8LNKWg95bHbcpw8/dQH33I1b7Aj9k3FvnhyHSX7T9qiK1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x4OD3dKMKs4+4XhlRD3WT5Y2WCfwAfbbiAo4H23Rdc=;
 b=Si7b+M/2OZGTYPJlY0DRmsR/AqV5v3Xtz4SPL4QH/iu5zsqtAD06OBSRV6vK0fj+vUvox4ixmg7cexOQq/oTceYc6He4NZD1Ygw4CHXHn3HbZLiqjVYl3P/Frfs4qnEsi9Jh+C63Q+xC0nU7JROyLfZyPIaqcIYOCu02sBVLUUw=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV2PR21MB6594.namprd21.prod.outlook.com (2603:10b6:408:348::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 31 Jul
 2026 21:25:59 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%6]) with mapi id 15.21.0292.010; Fri, 31 Jul 2026
 21:25:59 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, KY Srinivasan
	<kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, Long Li <longli@microsoft.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Konstantin Taranov <kotaranov@microsoft.com>, Simon
 Horman <horms@kernel.org>, Erni Sri Satya Vennela
	<ernis@linux.microsoft.com>, Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>, Breno Leitao
	<leitao@debian.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>
CC: Paul Rosswurm <paulros@microsoft.com>
Subject: RE: [PATCH net-next] net: mana: Extend RX CQE coalescing up to 8
 packets
Thread-Topic: [PATCH net-next] net: mana: Extend RX CQE coalescing up to 8
 packets
Thread-Index: AQHdH60NAbCTQ7nCeEOGyXAU5iVN67aIJrBg
Date: Fri, 31 Jul 2026 21:25:59 +0000
Message-ID:
 <LV5PR21MB470499130F3AB3029B375BE4CAC82@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260729225235.3573786-1-haiyangz@linux.microsoft.com>
In-Reply-To: <20260729225235.3573786-1-haiyangz@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=87ab57e8-156f-4f6c-a253-891f0d604d89;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-31T21:24:50Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV2PR21MB6594:EE_
x-ms-office365-filtering-correlation-id: 2ec752e5-c92b-4acf-d1d7-08deef4a50a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|11063799006|22082099003|56012099006|7146999003|18002099003|921020|7053199004|38070700021;
x-microsoft-antispam-message-info:
 ja9LuevP5EBMvUVOsJv3GFc3c0Khfswq3o1PhoPiDuUPi9B9f26kiliX1+Fl/WID8k/Aoxj+MfB5G+XTUB2y49LnoT4V8YRzABKlvpZ4dAXUI1Jv0JPvvryLaT0o09+vv0uEEeC97u75vkPDGM3yFUwIwhk4zrjzLgVFnnb6XfO/PwUEG8wagVRXeOUgZBaq1PsA8cYJH7u6FWw9AEe3qoNHMcaZHsEOwRcFFT7puPQH6roJWb6xCtAEHB5necWypzX/Dz1T+4U4dhtAEPs0oLCzX0bkSIX+L/6GHT4PCk6zMj1csTmTVhPL0PC/CP97nAKuQmWeW2Eg5yEWEwqKGKIDCmp3kEKI/zmEnKE3QzI2xs/HWFZeD5qC0zzQ4pUbDzTI1bSG4W5s4pOzmX1RWYDvi6UYTH9E4Nw2k2hsp2Nl0535p41xfvvIol0q8l83+a44H+CLR3GJ1jGlV4scnQ4xkQ5z28PJezOUAcVCXQM9oT3Djxvu6kCg818sFhux3bafbjPSsU6EzoqgCTjRt1nkJh7tDagXqFUVMNamORQ88DBpaK31nQzHcR73wZQCAcONr3DogT1A0SHusYKz7A8GIvfKAzRrLfS5DMOYk1anx6DQEl4LrDv6oIeoqJtk0HWE3Sq0z9lNa/PiNqD5/t5urbrLXQJ16KuXOQXLt/g+u/4Oe5GG86gBr7rkM9vzkUd08ZLRyfSGl+7MiUC+0SFKSfzcGTRxwj1JSSDmxoM4LHzFDMpBiG4lfAeBW/Pa
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(11063799006)(22082099003)(56012099006)(7146999003)(18002099003)(921020)(7053199004)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?BlZgXUsEkIwGT9oUkzojlKHLKSUHGVs3eDZfqhcUxKF7yC2IH5MGNwD6z5br?=
 =?us-ascii?Q?D9UXvPiD3Uyf8Cyv7tp/G0yHpgKjEFaCRzDmYmaa2grkW7rB6mD4BxG/gRoV?=
 =?us-ascii?Q?M99cM8HZRQ5GgRt+IYd5xkAHgx8kMrjMwAOO/imCArVaLqwjEqjLAgMIPUma?=
 =?us-ascii?Q?QD2VKNg4Ig3bitGu/6mRafoNiOWH5Wxh16WRSov1/zlDFXPxaK6n/kctPOBi?=
 =?us-ascii?Q?XWnRzhyCIkG5MZgR0DglRhm5FYYjGztgAftzjGb6hKQDFRXWxIEJVNlonEUN?=
 =?us-ascii?Q?+AZEQt/LaCQpareZVxmmgrMODnXxGBuFM/xa1IFLSuNfyOs3WwiJ1tIUzlqJ?=
 =?us-ascii?Q?e89UaUAHpO6KY1hIwwVqLRJalAWaKlsCzZE8GgzaC3EqOatFa7xZ+TWJ9zYH?=
 =?us-ascii?Q?3ZhgrFMBCfnmkyuB8OaA8Lz9xiE8PT/LhwabSDgpaCDfBSPAU6XUFBgkTkb0?=
 =?us-ascii?Q?pK3oXSiNXCEXxoBCrnaGlqvYsVMUwC/X17SNm6unfeqStJ9pq4Ky5QdYKTjT?=
 =?us-ascii?Q?WLVTOxeJVs3rcv1kNGJJm3UYM9v+hm8LnFElayusB40+DOINJNTI7toy/XBR?=
 =?us-ascii?Q?jNJVRtQ100mPutku4clVvaHDFJK6u6N02JdZYYaXe4nqLSjQzH2KtLNrZPC0?=
 =?us-ascii?Q?R69MWgT847C2A3C5DJYx0/nPQEks3PaLBFQCprIanfDc78EbRcBTDw2Ci0gS?=
 =?us-ascii?Q?GDtjlSfgcnM+xeb4+/KN09fQGYH2Mc3QZ5mohQ9WfkBNGZf+Kb5Wt6MdlZqo?=
 =?us-ascii?Q?VQPka3b8xoPd74Z1ytOvVlVmpwBSrDOU9GTtZNH+Lw9JlsP4vW+3Sz6UdY+y?=
 =?us-ascii?Q?ykR3GRr838yWu2fpW/h46YplIK8hJYJ9IBjuBy0HhI7vHXXjo7UFFCik3Xc7?=
 =?us-ascii?Q?oXIw9m5Agryh1Yt0Jd6VJrH2bPJbHKShRmm+vMm49o9m6x7fjJFgIwU1RcQm?=
 =?us-ascii?Q?AhXsBBM6q6PXv3CclQPMH3MsjLCSqCUC6cgBQnvjvRqmjlNyql7Kdw8eDAdu?=
 =?us-ascii?Q?YIV88vPcQzlr0hPlpROSRpiZJHA1RXU3xR/UVmSpQC3DpzheRIZMOcjLUih0?=
 =?us-ascii?Q?7A1vZyybm1L2kn5Mfh6gLnPj/30o8ZMkTAu0PUAh9lnjfzt3RQLfn8oKeH9P?=
 =?us-ascii?Q?5blRtrVQiqpopa7YwLz3lIOBFIPwniz3s941Git6hrEyaq0B9JjiLH4IGlzi?=
 =?us-ascii?Q?PCLHWPfnfkl3XXtaQVvnfvwo3VJbZP42OG5ENP61hkgbA0SqWDZg/tYVwJUf?=
 =?us-ascii?Q?QpYrAvCp21dJSFXcY754jzQmSFJfxhSbfFKUM9f3zAveX7af1gPczudVQ/C+?=
 =?us-ascii?Q?FLp0abfdUD16TOzhIKhn079kikpCw7M+Wrgv0sS4zXsUIYFDe/vd3JFT+iu3?=
 =?us-ascii?Q?BMgWvp/TSNyoh6EqIW3EqZ+5H9XXBA7nrCpKb/d2qr4G5BhNbbxHf8JhpG5i?=
 =?us-ascii?Q?+lAzr6YjBBWL7OLqcywTNX0ZXJL/EwbGgYs3EXSYrhykL7fOeZMXwWvH0dIo?=
 =?us-ascii?Q?N90Q85flzpg2HEU1SmOJn1chzI3cAbkDvwTmtt5bZGEmWDqvfrVErL4j52p1?=
 =?us-ascii?Q?HDWsmzgOD6ZwOVMW9JwqwrHYVeQ2B3i9DOtpLjYUmxsv6RO/tF47drRM657y?=
 =?us-ascii?Q?vkD/rJ8RNFvzlRX0ljv7y3ZEK8ouKHlG4ZfW/XuT4sdgDrZIJiEVI+RZP3c4?=
 =?us-ascii?Q?oSfvoNvDYosVAfSyJJWeKjLHadHokw4uyaAkpL/Sr4/LWK1EnekIznrm9s0R?=
 =?us-ascii?Q?R2g4/mj+5g=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: LV5PR21MB4704.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec752e5-c92b-4acf-d1d7-08deef4a50a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 21:25:59.2212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: padWwRowFZZIZ6KTHh2jM8UzNi+9++2il40VdyNV8MeHPF3nuVKI5UdtkrTtPocI16mXO0Bk0gddsZX1M1nZmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB6594



> -----Original Message-----
> From: Haiyang Zhang <haiyangz@linux.microsoft.com>
> Sent: Wednesday, July 29, 2026 6:52 PM
> To: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Wei Liu
> <wei.liu@kernel.org>; Dexuan Cui <DECUI@microsoft.com>; Long Li
> <longli@microsoft.com>; Andrew Lunn <andrew+netdev@lunn.ch>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Konstantin
> Taranov <kotaranov@microsoft.com>; Simon Horman <horms@kernel.org>; Erni
> Sri Satya Vennela <ernis@linux.microsoft.com>; Dipayaan Roy
> <dipayanroy@linux.microsoft.com>; Aditya Garg
> <gargaditya@linux.microsoft.com>; Breno Leitao <leitao@debian.org>; linux=
-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
> Cc: Paul Rosswurm <paulros@microsoft.com>
> Subject: [PATCH net-next] net: mana: Extend RX CQE coalescing up to 8
> packets
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> To support up to 8 packets per CQE, put two packet lengths and
> hash values into one PPI entry by using the reserved fields.
> Update ethtool handlers to set this feature.
> Update per queue stat to show the coalesced CQE counters.
> This feature is supported on NIC hardware showing the relevant
> PF flag.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 137 ++++++++++++------
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  30 +++-
>  include/net/mana/gdma.h                       |   4 +
>  include/net/mana/mana.h                       |  43 ++++--
>  4 files changed, 150 insertions(+), 64 deletions(-)

I submitted v2 based on the AI review.

