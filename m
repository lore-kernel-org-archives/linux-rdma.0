Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022133.outbound.protection.outlook.com [40.107.75.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BF93C8C52;
	Fri, 16 Oct 2026 08:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138427; cv=fail; b=KvZxpgrAvkQSngNrWOKAnE5THCS7nD2o5kA8lD46wIK71URv2p1lNoANiXLiV2GAfzILJSbFHz+cl7olKWxuNaXc3hxbE6zpOYBpFtwAr//EviQf48UVD2zc3M5IOlQ1B2AOEmaCQ9UBnUG1PtvdI4XrIl1hKRSXYrsBPscpjF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138427; c=relaxed/simple;
	bh=PUu+NZMeyTRIwTLEd21skam33qdBI/y8O6XP1dqeE0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=knEVMqz5JzLxb5i4YPbhdqJBUrfldzk+SB1PEs/vWpdSnkatKyH8EyaYTDHyouVufekpLn7ypeMoqddBWzSPfwCEsfPCuFD8mYla69+XlpCsdMuFtdMYSCKBwYtvJS6lYyKokTfnZpzcL6F0gwJsa3Ce6CjfwBYQvQOs+fWGiEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=XGn2b2Kx; arc=fail smtp.client-ip=40.107.75.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="XGn2b2Kx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHR3vYvUivYEOhtx3SEh1KIV3CXfoR8OMrIHSiTMAYHHH7kq7816s32oGiZ9+lXX2aC8hmdPigVi+ZJV4IvCQ2jNl/gNa0PphRiRpAnjR4pCKAe6zrBncbHjsglmBHDVZF0PL8J98MI3G9LspTJIhWg0KA+HdID13X9n8PczkjPhznQg/mhdn78E8mWNiA60PBHk9+M3PCJK528niqduhXLFWz2C4sCxbIzeY2GImO+d/Zpsm3RnXzAbBvDTj4lKgbjcFPJ6F+3O2yEYPo8BbqCe+7a1+9dgEtYfQBUf39EMlsgXgEVwKfgZkk17ILs+6eLLRzo6m9NDW0kCFYRSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=PUu+NZMeyTRIwTLEd21skam33qdBI/y8O6XP1dqeE0o=;
 b=tsaXXQp7u1+rlrUWXbKazlYpndHtUd+oboabKOJDUxmIxbjWc1zkjkV4gdiCA3F4tVRHwfFomhHquA8IPVwHsw9v6cR8omWCXCpWa7tllWxMjjrqZECbtkfwyb+LuGJEG4K50J/hdf3vMzrM1UawHcETzZsmEauTjcO7P/PGV24PrldBeM2QDiOWmj58m6oojd4vP0ArOMcahBUIYe3DwsxNRI0XRLAbOCmuE6j+6F4ZObqmNkdBz4Gb+/XYWlyx5VNMn9VRFynYpG82ss6kZRLbTf1W4qRaQlM5KGdbPVjuD9jm7UA9yuYyaad9Y+ZadCZvngYxPPlMViM+jPxFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUu+NZMeyTRIwTLEd21skam33qdBI/y8O6XP1dqeE0o=;
 b=XGn2b2KxPTYQnfUjw1The63NSis8RfWhZD/vJ5mcMHB5yaJ17oyyARGKdmBM0rtnb371gQOD0vC+JSa7DqLKBIwwGZ392jPrcqKuXQVQnXxpQr9I/a4/6IU62exKWB5Tiv2IWi2EoNzDRhQEBuk/wh9rSqmkci4JWSwGW50GW/0=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SE3P153MB2039.APCP153.PROD.OUTLOOK.COM (2603:1096:101:342::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.9; Fri, 16 Oct
 2026 08:13:39 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 08:13:39 +0000
From: Wei Hu <weh@microsoft.com>
To: "netdev-bot+sashiko@kernel.org" <netdev-bot+sashiko@kernel.org>,
	"weh@linux.microsoft.com" <weh@linux.microsoft.com>
CC: "longli@kernel.org" <longli@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang Zhang
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan
 Cui <DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
	"kees+treewide@kernel.org" <kees+treewide@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "mawasthi@linux.microsoft.com"
	<mawasthi@linux.microsoft.com>, "edumazet@kernel.org" <edumazet@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 2/4] net: mana: give each HWC
 message slot its own completion state
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 2/4] net: mana: give each HWC
 message slot its own completion state
Thread-Index: AQHdW7RDnqc7xkO+H0iKrnMiOxx7tbb/0XzA
Date: Fri, 16 Oct 2026 08:13:38 +0000
Message-ID:
 <SE3P153MB1848D0909B8C44026166D6C3BB9B2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: =?utf-8?q?=3Cb6a611e9de0f67b48ddde2948e257128df1e90fc=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
 <179196575434.434549.4428132041097324407@kernel.org>
In-Reply-To: <179196575434.434549.4428132041097324407@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=17d03eea-341b-406a-a453-27790aa2e2ba;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-16T08:00:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SE3P153MB2039:EE_
x-ms-office365-filtering-correlation-id: 726be9d0-ae7f-45f1-6daf-08df2b5d6240
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|42112799006|38070700021|56012099006|11063799006|7146999003|10067099003|18002099003|22082099003|7053199004|3023799007;
x-microsoft-antispam-message-info:
 3sp9DYY46igmgCEfIPwTVzgOcVJwwUkQVTczdu4O3nzbzrFL38hkA/DY/26Yde7fUeBaCWshZeVkIHh3A7wM38z8KgQ7SRMlbo5o6cDpghELo4Kc2IRz0U/ncPuWdc3fvrDTn2bKG4clxi7UVqXGwW7IB1q6lkKtaQNhAK5T1Tu2DMU6uc2l/EadDoZiPnJZuK4XJyGdElb9dYMV5iDdcru5xnOm8p/b8S0Tq82XdV+yP/frFZoxrE25M7nHANvIjB936k3OPHebUm3g0sIRkIBuM2Ak27KXJTim15g3jCBIgta5Zn2ZcbyDTwpQ8dYHfN6JCOdDsAe8nR6VoN9PkiyLFQEhivH6YTWteQQSbykPxY5Igu32mtMEQqUPuxIfrFUhtQSk0soV1UWth8Xv5TLSKlf2eOijjIQ2CQBGZEXm9ey5hKv3IROCjLpz8WXjqYw5hWeDIfwZfGckgAGJ4nv+25izDIM6GeFxsZa1EuG96Rx+WhiTZ9u1uPnojB1rtHs89zNnRwkzuF64ILP3L69W4qTxpDQbzD7g71s68cKVTaPJivH3gETH8eokOh0PUrKDS69iSXElbkVtzim2dxtH9luBzmDWB/xZ92KHV0Z6TxZACl84jp79yaR5OmRA2GtdP5H3oHAGe+k8MC48gAJOYApypWz2QWmkxmDef45B9yQibvulxy4dE0PLNf/7h/mnc/2V1Nsr3WoVKbUOwmq/R8zOJ/K4WTibjRJwEZk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(42112799006)(38070700021)(56012099006)(11063799006)(7146999003)(10067099003)(18002099003)(22082099003)(7053199004)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zr/boIn0TC8bi9A/wTrYIG4qvQtx3HkN0YJj+rMBWEyUkGewwKne9DNwaqmd?=
 =?us-ascii?Q?8V7yDXooL1nlBKgfWwMMi5OT20r6BxOmOuC3PuhqCr4CqEDdlEYa2ufE6Gsk?=
 =?us-ascii?Q?9xyeeKnzEcecIq1gjhYuP0bh8fTpftr/lmhBBmo0B+dWk4yiQf+R/t30/b+x?=
 =?us-ascii?Q?8qvANZcPTFPiZg3KUjqxqU3RgZis+htWMyEILYbiXkO6KC566RPrvBJzHwko?=
 =?us-ascii?Q?bqM9lPzX0Zjl9E599zvLXAoI+m387ANaaPy9AgW320LL8d4P9lubjZl1iNxv?=
 =?us-ascii?Q?BJLfdJPkgDdlRHa8R5WERGX9U6O9upPbxB81k80XQm2mADiO8vZDQbIl7TLz?=
 =?us-ascii?Q?YuReBZMuUlfcoKHREtzYvSSXjDDEkoBYU3Nt/iRC8GrYx9FjS1QAuGwRMYkW?=
 =?us-ascii?Q?Rd4BTWgTzSG0QQ+p80TVy2iQKj0Yv4uuFZQVhFgqpa/7MJ5TgmsBhz3h6ZEx?=
 =?us-ascii?Q?8FEHk0YBlqkyFGsoENDzca+qpJelyxnB7pSATX9v8+i97faqi/DRYvfjQ9oo?=
 =?us-ascii?Q?0lRL7mn6icIfXceMsQ9Ymeu7ZhqYsZgyvM7Z2KWVEr+Eyl1RmuughgZxQgd/?=
 =?us-ascii?Q?P2Bn/BEYZVD6CjRqmc77WMntYiMMWneuWOcHXBIIrg8YQZ3gQBRYCY+uf78b?=
 =?us-ascii?Q?TickUWhKEcEtEg0DzhUkd6Py4tdtNgsG9pJLrMIhd4uxseB4Tb8rcG+LkoCO?=
 =?us-ascii?Q?1yOmzIzVa1RPTu3Oz1S6PE90BNS95BidVseTO1No8EyGp12UjLFzWWBwhtMP?=
 =?us-ascii?Q?fZYJMDFEhTSXC14StO1Xp5KOyu4FJEIyt0VRnZ2GtJs/dTUSkXNX0sLPfsNb?=
 =?us-ascii?Q?tUZCTpZUVagcqU7enyiUJw3f+e0qXu1iFnPLWw6pjLuKxZPwqzh8uUx7ipGX?=
 =?us-ascii?Q?QhAigO01QAXoLTVPvuHbxRK4uxm5S2YP9m05bqYQU42pZBoT0mRikYvt/Jzw?=
 =?us-ascii?Q?PaBTctlPalW6CuHwPmgJoHNaATDrhJLn/GjAPtbo/yC6jRGUWQqbfpYSRlM4?=
 =?us-ascii?Q?AN+gHrVAu+rRW3aXvZ0BGg4VI1MwQYUoB6bu2B3AEgAccn3ldRNvJR/OzI/o?=
 =?us-ascii?Q?6Cqgjc/em0RZErWe9j0WeumR50AZQWUzy+jSCgTu1iR6YsuFd0Qn76v4Ad+R?=
 =?us-ascii?Q?mJlpQmou+KdC6czVg2MdPdonohHiRRBABMm3psI91RrWRtFBAMXrgx6pYnKL?=
 =?us-ascii?Q?BAlcn5HmLGZwrwa43QCa9rni72j7Vk86l0oZpPr971ZiTXaioU4zn9Bw9pSU?=
 =?us-ascii?Q?76TovHqHkcsKZUeZTlaaJTJ26loMm+T0fZKzF/P8SiSNbTUSznP6h8PNGPDR?=
 =?us-ascii?Q?JOl3zLSGCgOXqn9n9gDwpRT1aHe55zue04kzNhuMGd45UCAGA21O7Nrx0BIj?=
 =?us-ascii?Q?eSkALYo4WFRK6KsSnMxqUcNZsO0mXM9W6siROTDNqMvzh5EvYRgGsB60rci7?=
 =?us-ascii?Q?Yn1Z2sxcfC2q/1a+GhVW29tNEeJNhpNxxwK51pIgN3hO+vl8lb8lfFgutsdT?=
 =?us-ascii?Q?R8eYY+hhUwNt02cdax2CBiVb7MwXVaPlubZbAP6C0vJaCoyu65RwvRTMZ1jE?=
 =?us-ascii?Q?/Nrf6Leo02+JK+rP7v1ewkIHsvQIBWvNstRBZa4Z3xZjknUNxEj7UQeig9d3?=
 =?us-ascii?Q?rfkpfAGKpbH2muoHo2FjEV7I0j39+mAAt6tnzngfXmR03CMfHWuWIeZVoQUg?=
 =?us-ascii?Q?Ieo2bYNFp/3nxfTuvvO7VyeAnnOQeFdK+TzWUdh1PaCYb5wA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 726be9d0-ae7f-45f1-6daf-08df2b5d6240
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 08:13:38.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haEJRtTezxtueiJIG6uo5xbGLTQ8l0lXBj/v/GwLRqk9nKRnwSfY8Wvv9S8pNIF+TdGgRsnY2hmWq7K3Qa0iIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3P153MB2039

Thanks for the review. I have prepared a four-patch v8 based on net-next
commit 05b5019b01fb, with the following dispositions.

On Wed, 14 Oct 2026 08:15:54 +0000, netdev-bot+sashiko@kernel.org wrote:

> Would it make sense to send a self-contained fix for these, with a Fixes:
> tag, to net separately?

Agreed that these changes also fix existing behavior; they are not merely
cosmetic preparation. The v8 messages describe that behavior explicitly.
This revision retains the four-patch feature lineage and does not label a
whole feature-preparation patch as a safe standalone stable backport. A
minimal net/stable series needs separate extraction, a verified Fixes
origin and validation on its target baseline. That separate backport work
is deferred, not rejected, and no claim is made that older kernels are
fixed.

> Could this commit avoid the channel-wide latch so that every commit in th=
e
> series is bisect-safe?

Fixed in the v8 intermediate patch itself. Patch 2 no longer introduces a
permanent channel-wide timeout latch; it preserves the baseline
post-timeout admission policy while fixing caller storage withdrawal and
completion-state locking. Patch 3 then introduces response ownership,
quarantine, bounded admission and recovery signaling together. Thus patch 2
does not newly suppress all later teardown commands. This does not claim to
repair the baseline generic policy that may free a data-queue DMA
allocation after a failed control command.

Regards,
Wei
