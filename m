Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022079.outbound.protection.outlook.com [52.101.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283D2421A15;
	Fri, 16 Oct 2026 08:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138826; cv=fail; b=VpyYqgt2AsVpTL1P+OuRHdTV/fvu1nHp6fCF8pFbU1usR3450ouu00l8+tPi5kor1OX9l2TA9lXiffJ62OdpYOMMqhUzGZWqJfvMQxnIqgu8K79X9TowVg8DPkI6ycmEAHcTXu6AtQ2ysrumhS8QDlZD+mFAec/wcDR0oWBmCjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138826; c=relaxed/simple;
	bh=BPOCnhcaVSXKej71J3Q68f6qOwYla+C5R3q16xvnTfE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TRWa0DH2uyAoxbw37ao39xz3eG9+Tff2Zg61ezdq8jYrH+vxHnjRsR2HlWGdXtQQE51eerI8fa/+kiURjEenB706M/+VCdu25c4h4rOnA9znHIEUUh0BnAUasEDlL5bd1/jiuc4VCIwXuHQ+q86MBZU5MNjUadKsTAlyMMnzfpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=VQovOkUB; arc=fail smtp.client-ip=52.101.126.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="VQovOkUB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKlerueZAx8vTsCp8JObwINKfnmMLhxetKzMGOs7oYRUWBFmdmK1qUy5hxC1qZNexOs9YBsB4HbP03Zm1M9BOyUDJ+iBo/e2MJAAMi/Zrn0k6DBHr3I5ycAVce0nYruDi+pN1sycREd+5cnuXeuAXv3dHWwfXYwe7gl5jyu0EDvgI7meHEQRL1SNMMJA/4AiG2BtMDGPNsg7A5nsnrLTIV7Z1astwxmD0UynVEgjK+T7cCdBXX+FGW/qpTbB7JgpNQrCry0XTnjmv0tVfvx68ZY0Gwwu/v3ksqsU7zwRew2/oluiMp2jmPVdzsYsjUG5NJ2iQNvCUH4WWREu9KmJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=BPOCnhcaVSXKej71J3Q68f6qOwYla+C5R3q16xvnTfE=;
 b=EOliEJI/mRM1QThMNLDsICa8aZnKTDRqpQsxR8IMGi4csjwGabiJ0Ey6kk6xA3jRj+jhG4fupuhgiEMxOjtn6O2Ppb4G1uXkzY4rwSgUAn1sQQVY7x8DxFjI9NORcPatXiJXtTy0mAxt4YYdjE5D3W5mtH7ndnh4pb20wEekoOD885f+dF9x/vmtHOM08sfP4w8GH8he+Qp+1LVzyDTD2yGlrxVv73PwAu7Mp5RYEL5AbefyodxDsd9+4T3EZb8RO7gWKqkaQ8cTcLmjCmt8xqfUwugT1xsY0ROpEdc5eA8tdGCQKXt3kLhVso60fplABACLqOx0HAzdWq9EQN/n1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPOCnhcaVSXKej71J3Q68f6qOwYla+C5R3q16xvnTfE=;
 b=VQovOkUB9BDShXEGW/kfqIpP2tqoEYiCadJrm6QKZAtNEGlxd4dG6tZXvA+IE2KrXboaiI19EIp1gn1H3OD8AkE2rmNADDlm5MTEG4W4geqaltBLBe52aS2UB0w7+2jEDFmhFl8COOhgU2AKzYU5foVMKoHMm3DgWc39nWympKg=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SEYP153MB1334.APCP153.PROD.OUTLOOK.COM (2603:1096:101:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 08:20:18 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 08:20:18 +0000
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
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 3/4] net: mana: support
 concurrent HWC requests
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 3/4] net: mana: support
 concurrent HWC requests
Thread-Index: AQHdW7RCOxZeYdcQZ0OG1ksHOUP7eLb/1fnw
Date: Fri, 16 Oct 2026 08:20:17 +0000
Message-ID:
 <SE3P153MB18489E593F946D89FE4865C0BB9B2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: =?utf-8?q?=3C08f833983788be99fc73b856dd4822826b5876f7=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
 <179196575640.434549.9102950927041409151@kernel.org>
In-Reply-To: <179196575640.434549.9102950927041409151@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e57ec545-1f68-44c3-b376-e2b9c613ca29;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-16T08:16:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SEYP153MB1334:EE_
x-ms-office365-filtering-correlation-id: b33d0076-35ce-4933-071b-08df2b5e5019
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|42112799006|366016|38070700021|56012099006|5023799004|11063799006|261009223027099003|7146999003|10067099003|18002099003|22082099003|7053199004|6133799003|3023799007;
x-microsoft-antispam-message-info:
 Kyguawa7wtngZ2yAIXmG/GwutJwuvuH7fM23KxBOOCkNCpBJ5SlRnriuc8sxA5xHsWVCZgaP7llTYErd8oaRd1fqMccEYcq1qiPZBRm6pSAOyrQLZX2E5FgxvdBrW+9+dWEBg329974GzTkza4Zv522hLLoYqsAiyVWTsVn2VkDefjjcOS5uRvFya1Zqvuz5Lrvg5SvYGJMXXgitOcbSZtTe3MqPDGcFKow0Q3zeKi+5I0nWv0PeEhBCKCTSP38FXAyablE6Kx9//MMRRweTuACuaEw0gByh7XfezEITcib0eZWq7gCrWOzXi9GqWaxkoVXEddeHpu+wggQz7aYmvu+vDcYsac8jK3m/R/Ds3aDq+cG6dJ/T5fo6GXc/rYGTFczElHSdVJC9x37ZO2eolKa6bYo1gZk2tsdoKhgRluxnFk7WCKiiLvZj8EIl70dshFm35FZmoBJxiBfd0zhicHE1fYzg5SvOv9LkixC0bYFY8Vzy7P2L/fPi+1iLdSBc1a2JNzstDJ3avcsmHyl5IxVsU6ykdBAgi4vsO3wknjdE0+DuQPBMvfc1FpZXh9ESmVXUedx9+ObcNbAGrPZ6SPHPAuBzmiQp1skzW3TF/8P8wyLmOu/6Qbx+O3Mw0bMRqHT+atrkAXLfdZewsxNo/k2wsl6zz1/MZuS9WPE2do1Ey7+Xgzg3G433j0NczR6qn79hFjJ/IqNcM1wBtZM0KYrkWUb7saSrlei5NbSI1nY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(42112799006)(366016)(38070700021)(56012099006)(5023799004)(11063799006)(261009223027099003)(7146999003)(10067099003)(18002099003)(22082099003)(7053199004)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qs5PV/iQ5jpLIDTpRSC3em6Kqe0qLPghlfO5P+0xviB+vSi3tin2fMYVzcuQ?=
 =?us-ascii?Q?9/XXcer6Q98g4ba7EuKigCBA5XA4MgIgg+tkJ4mBH5ITW0gDQKnGjIkAPFNe?=
 =?us-ascii?Q?mvgIlGUnyNzVLYHNVhmSx/HdT0tHfgcJ8WYi4LSk0QqYZrUcsYlr0924rujB?=
 =?us-ascii?Q?78QFXSVh27Kh1XEOCT/LVgoF/Z7HgQbgzcVyu4Q6XZQbTYRoVI94FkFCquvC?=
 =?us-ascii?Q?CMwysUcvSLQIYrQc5Q/YpZbm3ymBypHbhW26q46HiAG8lzgSrR5iQg5em0gk?=
 =?us-ascii?Q?a4YO+Ha9iRiZywG6VzZ5tZmW2el3bjimIB7JrZROr+i59XONJny1loX1g3m9?=
 =?us-ascii?Q?dJ0FmOidgvznNhWYTHL04wQm4vs9By1fRhOEq1OI9rjky+Rog+9HRAeOUz3W?=
 =?us-ascii?Q?8K2u5dF3O7T7WNiUL+NsCf5sHOn++8Olc/uARFpUoCMZjnfWL/yfkXkGXpmQ?=
 =?us-ascii?Q?3KdpjzBXusWOWbW+NCTK9AaT2uF6yREJ6Laqdv3+D26KwQUAky9hKIl34sRB?=
 =?us-ascii?Q?uVoFIecF7jO3shbzTLj3qqnral01ZJx5Liyyl6GvuOFji7l2poISCzvyFsMb?=
 =?us-ascii?Q?9ZM0UMfqx2UIKlELWeHaGy/EvYmaed8PbnDXCCSGdHPDB3I+r8t+j0RWwePt?=
 =?us-ascii?Q?D0qjJUTixvJC0V2ILS51be5/Sk38+0TyKBI4L3+PXzhkbasiAW6o8mFMXw5I?=
 =?us-ascii?Q?Fty1kTPssDglRR8z88H32PyWAgq68p6QBxL8tEdMgcHYhHYA7Yb9Y3eo25tm?=
 =?us-ascii?Q?n9SfQMR1qwXmJgW5iCPj16e/c9l1lT6590e65OgPdjQTRuE+4H4H4v2VPcCs?=
 =?us-ascii?Q?YG+/HeqtwO9jWYiDk2Nm1qEy6whKTkDglR/6nkOsa7VnPns/HwZoa1bnk2FI?=
 =?us-ascii?Q?bcHjqHxhv7s1/9HwLcehJe93xWD8YrpjA4e3p5hIcQYZ/1IgtuCLwSCvAQEt?=
 =?us-ascii?Q?JOBvVEdSd9/7ufzg7+Xn0CdoSGgOAcvoDYVY8lPsLv4EjBbSY5DQamcVpz0g?=
 =?us-ascii?Q?Y1K88SFBfmYv1KyUA4tbYFT47/QDYMnSY/Tqbk+PBJF8FcBjOFxekO/3SDJj?=
 =?us-ascii?Q?HXpwzUUUklShio+Nol7g7PW1J8iubdN/jHnPXcCXxRntw1jYZD88bvfqi1n/?=
 =?us-ascii?Q?Zv/4FWLzI8xeIhjTbT4r1Qe4fU3HnZus7AmWbzBXiL+S9nqkfLjYvzpU4ntT?=
 =?us-ascii?Q?9JdMrwTnPxVDXJuapnThO8OSCm2xgI4Z3u9Dm8UwwatYbgMlJ/KW7CC9oKAV?=
 =?us-ascii?Q?IyfBKAPIfEJC8H87fQ9x89iDfwQyPvQddqMr0K8L5aWx5Eq3n8Ja9Mpmtkfv?=
 =?us-ascii?Q?lxOdyjqom1fLRJ+NZvx0hEvKdVC9CvxOBun8Y9Hw56RlmDBl70Pu4IoqPpro?=
 =?us-ascii?Q?2CjoUWHmPf3619j2sGvFHz+1DwISNrOxvp8FR6oNMV8V8+1ztgizSJkJMEFn?=
 =?us-ascii?Q?WTn+wHVIBgo0/s0gA8cYJ4vFuc8x1WKR7T75ObQlIulh8gKjwExF8bV2UjKs?=
 =?us-ascii?Q?OVxxiKFo3b1E4Rd/+yVk/IpxWh+1XNu4c2S2CGjWRPphw+dJJ6MgBYST04Yz?=
 =?us-ascii?Q?+si9zAmyb8aDjKKUzVSvvOCBkkIaOm8Ol5imisPGQzPKX3EWMJMdyVXVtTN1?=
 =?us-ascii?Q?iXoVqC34NGLyGdhkaYrIJRJky6RNxRreIeakEjq7a4sP17qDy6HCL/VQtW0a?=
 =?us-ascii?Q?15F0jC4Ua0nuJ9HlQt6MSDOWkTf4jeD9Frnk3LkT2DO0LV4h?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b33d0076-35ce-4933-071b-08df2b5e5019
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 08:20:18.0063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2DOUykFBfmxfEeElPXSPVfIVqBwOrmZsdzUUynOQsS+W/i8bcjn7q+5I23aWUaaHMgdaDnGV054l2ArS3Ospeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYP153MB1334

Thanks for the review. I have prepared a four-patch v8 based on net-next
commit 05b5019b01fb, with the following dispositions.

On Wed, 14 Oct 2026 08:15:56 +0000, netdev-bot+sashiko@kernel.org wrote:

> Is -EBUSY the right return value when the slot is held by a request that
> timed out?

Fixed in v8 patch 3. Outstanding abandoned responses are counted separately
from healthy admission pressure. If admission expires while such responses
still hold slots, the caller receives -ETIMEDOUT so the existing
statistics/recovery path remains reachable; ordinary saturation still
returns -EBUSY. A late response or teardown retires that state exactly once
with the response reference. Device status is not overloaded as a flag.

> Would it work to initialize the slot while holding ctx->lock nested insid=
e
> r->lock, which matches the existing r->lock then ctx->lock order? Or to
> clear the bitmap bit while holding ctx->lock?

Fixed in v8, starting with the per-slot initialization in patch 2 and
retained in patch 3. Initialization now takes ctx->lock while holding the
resource lock, matching the response path's lock order, and publishes the
bitmap bit last. Returning a permit does not let a new initializer race an
older callback still holding ctx->lock. This fixes that lifetime
interleaving; it does not invent a wire generation field or claim to
distinguish every stale duplicate after a completed message ID has been
reused.

> Larger depths only arrive with the next patch in the series, "net: mana:
> add dynamic HWC queue depth with reinit path". Could the message say so?

Clarified in the v8 patch-3 message: bootstrap remains depth one at this
intermediate commit; the following patch negotiates and allocates larger
queues. Patch 3 supplies the concurrency-capable ownership/admission
machinery, not a claim that multiple firmware requests are already
outstanding with a depth-one channel.

> Does this case need a narrower unwind? It can only happen if channel
> creation runs concurrently without serialization, which the normal
> lifecycle doesn't do.

The reported WARN-only failure path is not claimed to recover overlapping
channel creation on one gdma_context. This series supports concurrent
requests, not concurrent device setup/teardown. Before the publication
check, setup has already used GC-wide SMC, IRQ and CQ-table state, so
merely changing cleanup at that check would not preserve an independently
created winner. A complete solution needs device-lifecycle serialization
from setup entry. I have left this as an explicit lifecycle follow-up
rather than add a partial concurrency/reset policy in this series. No
PM/service/remove overlap qualification or fix is claimed.

> Once a late response frees the slot, later commands are posted to the
> firmware and abandoned after about one jiffy, while the firmware may stil=
l
> be executing them. Callers like mana_gd_create_mana_wq_cq() then free the
> DMA memory those commands refer to.

Agreed that the existing one-millisecond fail-fast policy does not
establish DMA-command completion. That reduction and callers which release
data-queue memory after failed control requests already exist in the
baseline. V8 preserves the runtime policy while retaining timed-out HWC
slots until their responses retire or teardown cancels them, and restores
the existing recovery errno. Fixing the wider data-queue/DMA failure policy
requires an independently established device-quiescence contract. It is not
repaired or represented as safe by this HWC series.

> With a depth of 1, wouldn't a single out-of-range msg_id from the device
> leave the RQ with no posted buffers for the rest of the channel's life?
> With the new -EBUSY behaviour above, that starved channel would also neve=
r
> trigger recovery.

Confirmed as a separate baseline issue: the RX handler rejects an invalid
msg_id after locating rx_req but returns without reposting that request.
That function is unchanged by this series. It should be addressed with
explicit malformed-response handling and the RX ownership/repost contract,
not hidden inside the concurrency change. V8 fixes the separate
admission/recovery classification, but does not claim that malformed
responses cannot starve this RQ.

Regards,
Wei

pw-bot: cr
