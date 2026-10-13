Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022131.outbound.protection.outlook.com [52.101.126.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2007743304D;
	Tue, 13 Oct 2026 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887977; cv=fail; b=AUDPvXHk6B4pf6fbdnsxHIkdUdgPWcN+uT0Jg1uqs9UcHtVjuAyOCvMV8xL8d5iz6A8w9Cr7spl2jF2PDT0m7E2PKkig9FOTKWmOwR9YoMpmkVCFI8xN80ICJ2Fp9jYbSXFd343h3Z5wTQk03yJsBIFNELT9GYaVNnsiaOBkhuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887977; c=relaxed/simple;
	bh=rweMcaMtn18iGVifiVQmf3dFftPpbY+AQsqlrU5NXjA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FkF4qaJolVtrOgOtbhaB/zf20yrKyuF+Zcg6H4NKu7dUZ641JyO4Ce8RMK21XlrOJPZHP+Ia5P24RsuwjOVgD0+KMumAonHTAWgk6Isuowg46rLnAuxRWJmpWn9L+WumHlgFDQJr2Ij0nrBiVZAbybuM1nEI/8W2Qd97BmvCqBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Up9ckJjs; arc=fail smtp.client-ip=52.101.126.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Up9ckJjs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hc6NKridivr5gLIOj7aMv3FE5afd48f9nUnF0WtoIw+BXFgoPoQ4OAM7k9DTUa1vlxsF+d2oY9hn1Et6VWtlvV6Scb25MERcvV+1zxd11Ea8qmsSpkTNwJdSDLQavzM6s8mCFMck6DH29/BSZT+atjxLUtsEnwYvnzsapOp6xxtifQ8czWLPeTUvFz83mSZnhWPGSPbEGaDgPxhTb7juYrVRE0z3//NUPI0l4graVQoM0cOnyZjcGrGZsL6t6FUCZCs+exJPpyJ+pYceuR1dfjUmmcL5pKInTa/ROvfeB/RDbOGMD0jNV1/ECJf7jmXZQUQgFA7KTcDH70kiJ7h3qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=rweMcaMtn18iGVifiVQmf3dFftPpbY+AQsqlrU5NXjA=;
 b=HBzsWP1hYUBhHqJjonududUgmk+lVdR4V0xFwbs6kw9VYQpa/ji6sLpk5+hjGF/iZ1WCGBX0/EAB/fU1QaGI6qYueoWQqqX+YV4q905b7glNEeq/po/Z1TQhaMvHEQ2XzDouZwRqHRd6/yjWHZJoMRK/9pbCnilK84aYRCo/QTkJgfkXWOVDfJ+1+QKqWAfbY5UjDGihJAQjyFxtGmWPjXUuozHNUkQCrs9a/HBOis+ZrVY4zYZf1MobVvkdE9+MnWPoeFiNe8FfQJpMqAn3BmnQeqbLCmVMA2u28jQAbwjDqjasn9Nvqn4P4ZaoZIqXdInijPVLYTjTKxWhLKTG4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rweMcaMtn18iGVifiVQmf3dFftPpbY+AQsqlrU5NXjA=;
 b=Up9ckJjsgczOLP0vkF2elEduHgqvlI9POaKn8j9yzh1dJdHb6Otf7BudLkge9XzzVBjglCX2WJ6LEF78pF4xbZiw2Yh1Ps4S0hMpDCzEXbmCnBWdfGF5e2Kag/kUfXbMgQRkdS7rIToL8KQTPtFQMyioH/VkxZUWY10KC/hVn4I=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SI3P153MB1696.APCP153.PROD.OUTLOOK.COM (2603:1096:4:2a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.5; Tue, 13 Oct
 2026 10:39:31 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.001; Tue, 13 Oct 2026
 10:39:30 +0000
From: Wei Hu <weh@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>, Wei
 Hu <weh@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v6 04/13] net: mana: swap queue
 sets in mana_set_channels
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v6 04/13] net: mana: swap queue
 sets in mana_set_channels
Thread-Index: AQHdV/xUvLJRYL/He0yqK+zTehzW8rb22xYAgARwaJA=
Date: Tue, 13 Oct 2026 10:39:30 +0000
Message-ID:
 <SE3P153MB184840021BF8046E71625838BB9E2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <a4bef0e79343469ce47507a44d0094d63e7bc131.1790795005.git.weh@linux.microsoft.com>
 <sashiko-outbox-166665@kernel.org>
In-Reply-To: <sashiko-outbox-166665@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ae56a50d-f3b1-4f7d-9f6c-103c550b43ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-13T10:29:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SI3P153MB1696:EE_
x-ms-office365-filtering-correlation-id: 9af2be05-6e59-49a9-361f-08df2916437b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|1800799024|366016|376014|23010399003|6133799003|10067099003|18002099003|22082099003|7146999003|11063799006|4143699003|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 ky78tdcUmAyTnVhm+efHM5aeuPYR4jLY/rdXHevndNvuc8oExBGVALMXoNYa1ZukXCOxQ/jyVF9GH0RkSgHDrZYJrc7NXg9UoBWjUTyemJvyEEKSWMP/tmNfezTs4tsXGvrNG8daY7vXWSCdxMtizwZUaNLbuIJTAwFB2MoGHj6ZOtGneStM9w/a2q/JXharXTTnb53N/uAKezRcXs6qEVdTatHRZzBy06iRDm9q4zaM0kyaav6qQjilcEoe/RKuzkv+zdt9w5e4Gs6NMCJmHlX/Mgbtby2QUYag5mQbVlfqK9h5mb70TlaH6pQ8OdjuhM2Cnu+nyGoUW5VF21QfDP4wA1zZzRwwh95ypwTX1+gySko+XzCvHvU2dDAqXIXHfzypZsov/9a6+Oh871Feph8cF266yyhZSJESUFdzk+JTMw7woRloEVb/Yt2opzb62HWdX2fn7LyAUh6pzuus8r2TGPNNgXFlyxZq3sLLpv1BJPQRC5Un5C5cuMEM5XRge3aH4TrQiW1lDJ/T78bOcxgPqvnwlafw5csoGEO9rK+uw1jmYWqhDgIChHlFXNw/HxBKxfy6ynEPf+SKEADj0S79xguMWRdZaWXsUyClqh+azEefv9RBCIbM6T1Y8nKb9MDXwUpfto1YasA0mbofJLwiFWFeVOs0+Roc9dvRhX/xv9rAlU9mXbZbRDLOutA9Mjp67MwSRjva867CnjECbePIlerEjhxKWK4tx0B52EU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(366016)(376014)(23010399003)(6133799003)(10067099003)(18002099003)(22082099003)(7146999003)(11063799006)(4143699003)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/zdLWlrhyY/pc+1S+lqRkzJuFGBUjPgdDcAwMl1Y8nuIJTPuazOt1mQRzNrv?=
 =?us-ascii?Q?ZwMufbp88NpyicSLlgih2TNDgMSI5rvZ+lO12uXzxqxlDokjZcGyXRqrhr6l?=
 =?us-ascii?Q?EcdbomvLocQX5LMNTLiVgbZ5PAoxxnBrmL9NauQwgem6l19yhJTedSXQvcUm?=
 =?us-ascii?Q?Omy0rXdhyfaoeRU1jUf8MQboMBazNWfF7lG9MCBOJdbpaGC/2Fa8QwTr2/6y?=
 =?us-ascii?Q?WYpjWFV5p60CD23S0xaEWH1z7jsT0lmMFp8PGY5DYmjEZv7qi+xK3CMlmdW+?=
 =?us-ascii?Q?rk+rHbEVV9XRgEIx9R+6LVAl5zxqkFIQH/NCmt1QHIbsnzq1M8WXE42/lISz?=
 =?us-ascii?Q?+EpbTaXYTebP0KosHMFibdJqzapC3hY4STrLwbsVil7iKCXla0oejjGog2Va?=
 =?us-ascii?Q?neemUkXZ3mjGH/xGX5IRbkREYd3gORUgo6Fx6JJ5wgDz9D9ff5EC4RiUPCjj?=
 =?us-ascii?Q?GWqYcP9rW2xl0vFQNAHei2jm/lY2TZEudV8vKH/qzxLO4GAUn30Eq2pFInMp?=
 =?us-ascii?Q?M6SGCLZ9kSZ9GBJi9eMge/KQc5Xdf70srsCeLIVka7zFcwgBC9RNQvWTUYbr?=
 =?us-ascii?Q?1qFlbI4vZJuzFOwr93BT32GwMpIa6BCAdQlSXbHzkCnKImhDJSeuNpEjOvYw?=
 =?us-ascii?Q?hswXotM3csKTtWfsj+vkNUHEl/73YK+21qs6DVcacy6KNFOcWCsett4oAq4q?=
 =?us-ascii?Q?hXYG/SYaXyl9ybaY9CG2pO9i1mWFHKtsCA63scYA7HTDeoBbK0PSytTp0HS/?=
 =?us-ascii?Q?WYIIpiIwbIrVpJUsOxHTUO8JNHv8pz3TGPsXCarSzDLwMikyNpGFmuDVv1XV?=
 =?us-ascii?Q?Hj0UBjBIfjjCNlyCDb7OaAzwa1C+2MFe0HF61Y8+5jPLU7ajHy3ybtxvH7LG?=
 =?us-ascii?Q?INKeSpGTzUQX8VUMO8fitc8CdMl94PQv1el71DxPczHKd8H0j6hjZx0M/64B?=
 =?us-ascii?Q?qHrfwWvqlvgrYbEwvPpt0D7dckBwyTAtDNlj7Jjv0D0tXTJqsH5UU1gtGguk?=
 =?us-ascii?Q?s6VDwY5OG1SudhKbHsCVXpgnpzZquVqoT6aX4CkrLcUUrW9Mx68H2vwOBVAe?=
 =?us-ascii?Q?8pE6GW093SmTNUMbtm28/aHUO+VbNCtBAGcNdZXFXD65/GemenRevTs1qdzU?=
 =?us-ascii?Q?gfUMEVeybPstnOQW0pGwzIAQRR8jRIAWH1/hPlC++b8mk9HGlcLZo78xK13N?=
 =?us-ascii?Q?My9UtkWa93lGhuaq8Q7pWd7t0cSjCQgLBsVqhIY1yTCc/q3GeI6OQJrVMNdP?=
 =?us-ascii?Q?I3fe5piqg4J54sOgxwfgdcasRPTKfQgQEIcm3wL+GYsZSWIMFhSXCHerIvwF?=
 =?us-ascii?Q?DwNA53mcyFAgqyDJo4dY0Vt3CT/KFCjGlXYtqREqW6qrGs+UhuRFixrUklRS?=
 =?us-ascii?Q?UdttyZ7VsxZszn9UtsXTp54Y11VE76HVPmiJJjW0OzyCzbKmBRJEw+urtDFj?=
 =?us-ascii?Q?oKlpWxFNgHA49cf5Wcf3LreUgvIQaIunMYFiLHijgN9pgIzeu6FUp/Onw2ev?=
 =?us-ascii?Q?LaAxr5dZM2kTF234xdhSynsD4w+2GpDpTH1HzV3ZatIFoKyzc5CTtfVi9Ytb?=
 =?us-ascii?Q?fHQasZVpds/2UCR5AvaIE8ncWgCgX37U1oJYrbQvdzEEdU5kx8Bdn0ZMoS7j?=
 =?us-ascii?Q?P3UKus1Y/6hDCUNOiKB3xw99a4kJF38Clm0FIfXnINsMU1IwKHYRkShbGDQ6?=
 =?us-ascii?Q?Rs0wXpD4KVKvNwaDsn6A2fjYQ6QHvcA9FIZT0RAyokGkGzGE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af2be05-6e59-49a9-361f-08df2916437b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 10:39:30.7652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hHD3ot1mv5SqBQVZco0FnEt5SNBib5MkhgNG+Fmi2ir4yy6olgPLtAFbtW1skImFzM8x7VBEYR5F92hZaHF+Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3P153MB1696

Thanks for the review.

> Should the update be wrapped in local_bh_disable() and local_bh_enable(),
> or use the _irqsave variant?

I do not think that change is required for the reported odd-seqcount
deadlock on the configurations supported by MANA.

On the v6 base, MICROSOFT_MANA depends on X86_64 or little-endian ARM64.
The rebased v7 retains that PCI architecture restriction, and its upstream
CDX transport separately requires 64BIT. Neither provides a supported
32-bit MANA path.

In include/linux/u64_stats_sync.h, struct u64_stats_sync has a seqcount
only when BITS_PER_LONG =3D=3D 32. In the 64-bit implementation, the update
helpers are empty, fetch_begin returns zero, and fetch_retry returns false.
There is therefore no odd sequence value or retry spin through which the
reported same-CPU writer-preemption deadlock can occur.

The folding operation is serialized by RTNL and occurs after the retiring
RX drain-stat writers have quiesced. I am leaving this unchanged in v7
rather than adding BH/IRQ disabling to address the unsupported 32-bit
scenario. This is not a claim that arbitrary 32-bit use of these helpers
would be safe; the series does not add that support.

Separately, the dashboard retains the pre-existing xdp_xmit writer concern
also reported for patch 3. That unlocked increment already exists on the
unmodified base. It is a real statistics race, recorded for a separate fix,
and is not fixed by this revision.

Thanks,
Wei
