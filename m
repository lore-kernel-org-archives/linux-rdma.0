Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011037.outbound.protection.outlook.com [52.101.65.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B03353A85;
	Thu, 13 Aug 2026 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786616911; cv=fail; b=qaEaW713fk11j4PGd1mA6oONUHxVK8YnMDC/a6RXIk6jgSEPkPQh1GttiCTQyEu1E3SmvbRo95ywTTzNYsAV5UGB7LF0j7lv0kAnclLvi8y7wdEnf4iVj7++XWDoiOX+0fSRyIVc4Q1m6q08PGOcxho0dZk4aV3557xkhU280KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786616911; c=relaxed/simple;
	bh=CsDqonnBG6NPr9bZVerZkGLDF/klqViySvrSFlOEOLA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=du8XRGZg9FYVoITdIAzcf3BCFTTzYbjd+S/gcLfOxPt9o5pEWhTBRedF9CSmuVu647ntzF6uNZbeB68KT6hkRwuGAxf+LmOuF/LHFfBl7Y+nHPLbqrSstaQcPDDhKTjrYNlhyU+9ND7v/PAxAwpWQk7Ms7EHoSws1qVJuC2psA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=BF1vD95T; arc=fail smtp.client-ip=52.101.65.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="BF1vD95T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EsDoTVXkD8uWvFOXGnTpbMKUYhUiBO8dUChLQJE1Yol5PveVHn/verGS8/on/UNe2MF4XAv9iOrW3gC7j49Let8L2EYiSN4pwKBCPBopNa0FC1GtitfWYa3/+my3qR9RMoxrPUIvTvbWouX2c/qXeXxy+E9BP7ydjB/45s3/PWGddHaA0QH2iRvcP3OS/ZIAHfvoJwy9Lnu4wNkIhY4zFQj/EzTZe1ICop/dD6GxPsswvVlg1lo3HUneoKyZOVwP9RqhPcZslSiDyK1x7EEEy+HpREFipkhkjgOIJcu1385x4gJbtY5pBe+0QvyJqqWUtobZnbA6owqsacwYk65U9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNKNVZ80cyCkp7gvQN+c0bc3dKQ4aYHBRlKQ7tA5Oss=;
 b=tV4/m0RQejxYUX+5JUbaO/hhtU8kV+X5GO/6y+de/AWnGbKChr+EFmGXpUDqs01PGieR3j+BrbptpQb0rfS/78wDDjmpCuCz/MD2ChqZ6cJiC95IH+FcRqajH8EYmqjIwyc0BNxmho9riT4XFZUMtkn3fRcU9tL4a4XrerciFyKzQAULAqtQ8GR5KzzNeYlTzkyV2kaSK97qBJLGf/vN5EZpbDYVqciALiIh+myRO3CmO7n7lly1tkDtcUB8rjHnnhgFfmmPc37MHHCD0+2DZFjL3sTPo/khNMrdKPSmpYDgogowxPWlPK01ZTEzLxm154rM4+YWZ4hsfE6RTK/Qfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNKNVZ80cyCkp7gvQN+c0bc3dKQ4aYHBRlKQ7tA5Oss=;
 b=BF1vD95T1m3Z7hdVtDX2KlNFbatPaC1z3R5dtyMwrNIuempFYmsofEJnZ+ecBDkFySknJcAkj1xjtrhu4pObFUSluBq6gpYQUycIZUGRzTODg1p7V47IC7qSN4N/1DRgD/+vcjAG0kb74W4L6crwbk0J7GJR7AF6ydUGZJzR1CFU084Znf+QE24VFJx5TPCR4unedQt6UCz9i47MNWByYbIDTlUryvXzqeENYuuvmzoLuVj4f5q+ilwTZNe90PpEsLy/gQbu9xUD/Mmr5L8dbKFNNVw6OozxR1Rds9E4UvQlIgv3lr50EzGfr++CddYPqy/qJXuaJ442GX8iP1I8+w==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by DU0PR07MB8785.eurprd07.prod.outlook.com (2603:10a6:10:318::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Thu, 13 Aug
 2026 10:28:25 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5%2]) with mapi id 15.21.0339.001; Thu, 13 Aug 2026
 10:28:25 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "shaojijie@huawei.com" <shaojijie@huawei.com>, "shenjian15@huawei.com"
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
	"jhs@mojatatu.com" <jhs@mojatatu.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>, "jiri@resnulli.us" <jiri@resnulli.us>,
	"davem@davemloft.net" <davem@davemloft.net>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "donald.hunter@gmail.com" <donald.hunter@gmail.com>,
	"ast@fiberby.net" <ast@fiberby.net>, "liuhangbin@gmail.com"
	<liuhangbin@gmail.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"ij@kernel.org" <ij@kernel.org>, "ncardwell@google.com"
	<ncardwell@google.com>, "Koen De Schepper (Nokia)"
	<koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
	<g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
	<ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
	<mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
	<Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>,
	Parav Pandit <parav@nvidia.com>, Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Topic: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Index: AQHdJFkmsZErp6HN50yIAT4nHZCuDbaZmsyAgACaoWCAANzxAIAAlzCg
Date: Thu, 13 Aug 2026 10:28:25 +0000
Message-ID:
 <PAXPR07MB7984E3E73868BF8966821C27A3DB2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
	<20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
	<20260811173017.3d18dfdc@kernel.org>
	<PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <20260812155430.6ec81eec@kernel.org>
In-Reply-To: <20260812155430.6ec81eec@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|DU0PR07MB8785:EE_
x-ms-office365-filtering-correlation-id: 0312e1d0-6910-43dd-2e18-08def9259b95
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|11063799006|5023799004|56012099006|10067099003|6133799003|22082099003|18002099003|4143699003|38070700021;
x-microsoft-antispam-message-info:
 5yAifvT0XhxnTfuth0fZw31T7ZQUzvB8gpoUfu0xfCnpGaLJRw+j7mWl1kL9DVs+j1gsb2AHihnc+zKvNftYJACpi/WiNK8Nkr2EnqBYz8MFWXM7oYI4b+aqb9Uj/+t+wj5ghTE3T2iFXErHfR7MEY6KmztIwU0NkWuoxcyQsb1KED4qKcx1SNYpfVPTdC8ebQyWUbM1z2cF38UcUeOyUIKHUdtEUNscH1FFMoZz/E/CXqF6xKd2cR3y0O1ILEXl654v73R8vNG1dfZNhQATNYlFMZSU10bZu+cw40JffeOkeo72JLI5IOkxfpx7qCtbrQzr1QUBGv5QvsswSP3Kh1vZ+pqZdPMwjkBcZfLkGsKTrA2SsOnYfBis8bLioONS8VhuAXE4IwU9mnyt0LQ5J41ZWRbMH/LKEvyblR7fshRsCCZqIu93fV+UQQ+K18awM4TbNFUr+WSA6lbJck6mO2PH/2nEqSjtWql9FE2mxm3w7TUkyO3aLn7g+st9ir+Ep1UDWbPhK4BIEcBLTh69H5h84+epnZkilR+cmgpL67r+ceDkHfUUF7ezGEoUcBl5kg6V68I+lmZhFUIffgvOVyjEwSHIWl04BnSWhgTlDZN1D/xyty8hL2EyLUzglGXPUjDao2SCnNnv121SGkhdtSoNQkJCpXfYlm5OqWe8GeQUXnghOHnhJcRRH0VwLvANNcGvuo238OGCd7Li++IuHkXvcS0i/B5i3hGva0/Nmnk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(11063799006)(5023799004)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UBjP1+Hke5HU/3Yt24TfOAyJAHi5mdBftiQWGbStHsiKMtgchgr3jY0N3Uq7?=
 =?us-ascii?Q?t4HjbgAH08DwyPaWb/FMTjTlGSn5UZv6t0vBnXy3+fG7aDBYfh2vi80svRBv?=
 =?us-ascii?Q?N90sho0rvEAVpl5BtreOWr1bHy6wumfIkglQ0EbpoOG7pQ86jEY1ibSBAMX6?=
 =?us-ascii?Q?og0FqN45CzNQ+PFT3Q8aeKWptS7uNwmwGwK/ZL4LmpxoMBTtd+8sZz9sfS59?=
 =?us-ascii?Q?7mP9psS4lBPQHIHo7XEGztmTCQzRJq7K6fMPTeiXXgBSNdDAHEuEWhsveE8d?=
 =?us-ascii?Q?ze6obhydR9l8A1ctH29MbQEa0cOqrTx7nM4JJKz8xjdRjlwKOIK0xQXIh9/2?=
 =?us-ascii?Q?WcXN/Uco9fDwUZ29dHTzlRWaIJesjWGgLK/gApStjcW/U4AJjK0ttIBgZF2b?=
 =?us-ascii?Q?X46uEYdOOFpIzw/UAjSugwP4c7nW0tsCSRJVykLxyF5b+1uImakuhRFphDrK?=
 =?us-ascii?Q?hilIcZ0a/V6Vw4LSJYrpoqR984qJKewNfy18JcCL/10W1waIf4fXXKib/zAk?=
 =?us-ascii?Q?rr3X8GpnNyFyml4GYJaudY9eZZhBwYLtfBy7i+zTzAxQqEQlX6lH2wHJS8Gp?=
 =?us-ascii?Q?ym50l/FzS+33B/h5OY7OqTTeDGzJMQ+9ESRTCSd2r4rAvi75Or4U+8VLQvBh?=
 =?us-ascii?Q?hk1PmP1KRqP9miJxUbzqCVxKJ4AOzqr/q6L+hhCKyM/Skqh5ZHqc80th2gKn?=
 =?us-ascii?Q?YgOcgWKBF8Kyt7i1vKMi1PbcHhuffH6nYiklfVu/6EoIOf8euRRcMwBIYleb?=
 =?us-ascii?Q?J+Xgg1xgLtJ9+cMURhAhXoH4zqc2MICPp1Id5Qs0AYFnJGZ5cypq9esETAyC?=
 =?us-ascii?Q?sjuW6X7SDmxkMTwHLf3O6VUK+a3aoDULGWSPQ5aRNKzkE2ttI2Txj2Ygf/xD?=
 =?us-ascii?Q?Q8nASHwUPRBJAaMqcqBsUPBIcB7D8KzYXSjx07z3vdZgLJLvF1OrbfmjEP30?=
 =?us-ascii?Q?2+/wvT14hSoo2CsJjg7aoT1R2khE1TPpB/y+cQnE07MTWrnI+/jVZ0m+xoDR?=
 =?us-ascii?Q?KOUmCG2TjI4ONURMdE1mHZy3TNnF3agslT2Prr4ejzGlIaibqjzaPbYQAF0g?=
 =?us-ascii?Q?LmAnw0bbSbBO6AH3ByrSATH6CvevIXidrrdCrBspS9+EzwGDaOeu10CpTP22?=
 =?us-ascii?Q?VOswxKu4PVEfNaX7mlwdeTM+/LnBneIblQVmVKoh4bXhTF90lKOCXkwwuXiE?=
 =?us-ascii?Q?dGjcx6aJa+fH6ZxOy2YiO9zkdsNe6l+ASP/s2DJtvTpU933jh5tZceFjIh+O?=
 =?us-ascii?Q?oPCiRxjDP6xdgWATn1/UUX4NV0O4m81KlvDQ3Zc0HB3OaBGqW1nNfZd0tFcF?=
 =?us-ascii?Q?yUZD7ISQPRX5QAuC7Gn4bxvw+e75Fe8vF13Kto/VfQLwTsZXIAO6qnxpBud3?=
 =?us-ascii?Q?nVMoqMiihb5CC5dvvWEMM56I3VwOE8MImRKqUBuJ+3PWDOicxgA3ycemZy7g?=
 =?us-ascii?Q?exIlLe3UK/Io90adZ48o6Gq7z49mVx/vSdguwX3EJZjwwveXc18IHmmc63sE?=
 =?us-ascii?Q?1csmKvEH2fDLqUdIhMfMjAeOJ2FZUX2TWgA9cpFqiLq3heCq+UDgggc30QcK?=
 =?us-ascii?Q?4URVaZJGk3dL4n7RE23ElOxaNgYhmNbGaq/tegs0zjT5ZUxJube37X9vw32X?=
 =?us-ascii?Q?0YIwAE/1S9N8SO/dG+KapAKMmtvWd/ggSKfyrxmrN66Xp5FTylt+HxUKuCjT?=
 =?us-ascii?Q?9XIwRUU4WZAcHGZ6Mme+i8rv9DSlt73r3Sw9H7VSB/yr0UqC2EDamca4DIhq?=
 =?us-ascii?Q?vj8mYe/AkBc8558EePqDH347QLBLeyo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR07MB7984.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0312e1d0-6910-43dd-2e18-08def9259b95
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 10:28:25.2179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aGWAw3j0JfyfSYdZhfCoDH4ew3wmNtU7bK5SgApFzwDd1qZGRv24wJYUdRfH0WHWIuGJqdE8LzL7JT3koyYNq4S0isk7vmV8WoJtaTPJfXw4bAsCUJhEZTBpjywDL3BU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR07MB8785

> On Wed, 12 Aug 2026 10:33:19 +0000 Chia-Yu Chang (Nokia) wrote:
> > > > -     /* This indicates the tcp segment has CWR set. */
> > > > +     /* For TX, this indicates that the first TCP segment has CWR =
set, and
> > > > +      * any subsequent segment in the same skb has CWR cleared. Th=
is flag
> > > > +      * must not be used in RX, because the connection to which th=
e segment
> > > > +      * belongs is not tracked to use RFC3168 or AccECN. Using RFC=
3168 ECN
> > > > +      * offload may clear CWR and corrupt ACE signal (CWR is part =
of it).
> > > > +      * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid CWR cor=
ruption.
> > > > +      */
> > >
> > > I still can't wrap my head around this TBH.
> > >
> > > SKB_GSO_TCP_ECN means RFC3168
> > > SKB_GSO_TCP_ACCECN means AccECN
> > >
> > > If the HW can correctly detect cwr on first frame and then no cwr and=
 report that as ECN/RFC3168 - what's the problem? TSO will produce the exac=
t expected segment sequence.
> > >
> > > Is the program that if we re-GRO that frame in SW we end up with
> > > ECN+ACCECN on the same skb?
> >
> > Yes, this is the problem.
> > The HW does not know whether the received packets belong to an RFC3168 =
ECN flow or an AccECN flow on the RX path.
> > For example, HW GRO may set SKB_GSO_TCP_ECN after observing that the fi=
rst packet has CWR=3D1:
> >
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > |     Packet id     | CWR flag |       Flag      | Flushed as SKB |
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > |         0         |     1    | SKB_GSO_TCP_ECN |        0       |
> > |         1         |     0    |         -       |        0       |
> > |         2         |     1    |         -       |        0       |
> > |         3         |     1    |         -       |        1       |
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> >
> > If the aggregated skb is forwarded through a device using GSO, e.g.,=20
> > HW RX (GRO) -> veth TX (GSO), the SKB_GSO_TCP_ECN applies RFC3168=20
> > semantics. This means that only the 1st segment keeps the CWR flag=20
> > while all subsequent segments have CWR cleared:
> >
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+
> > |     Packet id     | CWR flag |
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+
> > |         0         |     1    |
> > |         1         |     0    |
> > |         2         |     0    |
> > |         3         |     0    |
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+
> >
> > This behavior is ok for RFC3168, since CWR is expected to appear only=20
> > once. However, for AccECN, CWR is part of the ACE signal and must be=20
> > preserved across all segments.
>=20
> But this would be obviously a buggy HW-GRO implementation.
> The rules for HW-GRO RFC3168 are -- ignore CWR on first segment (host res=
ponsible for populating SKB_GSO_TCP_ECN), and CWR _must be 0_ for all subse=
quent segments.
>=20
> > In the example above, the original CWR sequence was 1,0,1,1.
> > But after re-segmentation it becomes: 1,0,0,0.
> > This is why SKB_GSO_TCP_ECN should not be used in RX/GRO paths.
>=20
> We have extensive gro tests under
> tools/testing/selftests/drivers/net/gro.py
>=20
> If you want to catch bad devices - add appropriate test cases there.
>

I added a test case in patch 6f74bc8b6e8d related to the CWR flag.
In that case, there are 5 packets with CWR values of 0, 1, 1, 0, and 0, and=
 packets are flushed after the 1st, 3rd, and 5th packets.
The gro.py uses this case in tools/testing/selftests/net/lib/gro.c to verif=
y CWR behavior.
But indeed, that does not cover whether SKB_GSO_TCP_ECN or SKB_GSO_TCP_ACCE=
CN shall be set during the GRO.
So, a test might be added to verify the SKB_GSO_TCP_ECN or SKB_GSO_TCP_ACCE=
CN flags (if there is another suggested way, please let me know)?

> The comment as stated seems to be misleading - there's nothing wrong with=
 using the flag if the device follows the RFC3168 semantics correctly.
>=20
> And of course, adding a comment and hoping people will find it is much we=
aker than adding tests.
>
> Again, maybe I'm missing what _actually_ doesn't work here.

Before adding an extra test, we need to clarify the definition and usages o=
f these flags.
At the TX path, in tcp_gso_segment() of net/ipv4/tcp_offload.c, the SKB_GSO=
_TCP_ACCECN flag is used to preserve the CWR flags for AccECN flows.
Otherwise, when without SKB_GSO_TCP_ACCECN (RFC3168 ECN or Non-ECN flows), =
cwr will be cleared from the following packets.

For the RX path, unfortunately I do not find a clear rule of when SKB_GSO_T=
CP_ECN shall be set except in include/linux/skbuff.h.
Plus, the device usually does not track packets belonging to RFC3168 ECN or=
 ACCECN flows.
So, my previous thought is to always use SKB_GSO_TCP_ACCECN in the RX path =
to avoid any potential CWR bleaching.

And FYI we will further include the related changes on the virtio-net after=
 we get an approval in the virtio-spec.
