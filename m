Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011041.outbound.protection.outlook.com [52.101.65.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E75835C1A1;
	Tue,  4 Aug 2026 12:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847097; cv=fail; b=CnL5K9Kft2fGRIKDBvdm4GJ48YtziaDXK6woo7VtqJx9GNL41CObLgr4Khgf+SHHrZBBirUPL1T2PZ3nxQOfQdiiGOKQ89ZuMtlSclhQLhklS8zyp5AasR310KaJcMehGj5y7v2RRJAaeB5kgH59QF8f1wTIB9fnBDkMe0FTUiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847097; c=relaxed/simple;
	bh=vgAq+KJgLccFNcJBy6CDHgu8lc7fgjgoI0iRn5SzaDQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VCP08dGfGdsFPmVfakL9YgsAyUYBNCnfhx/S3C1gFBRETLHZN1eZvtmYheiJl207smMO+DyRZ42H08odBfBaS2E7AeBD5p3PTYi7/yRx3gbYyVva505IybLzDp/oSBaGICA637aulifcCnH526N86oKwtkpkJhbpZtjKcOq8iKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=phE3H37k; arc=fail smtp.client-ip=52.101.65.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="phE3H37k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6uviyp5YfWQ0da2NWkAfK65Wqf+kEx+/304KncI2J6nMlduU+9df/KYZppkzfsdjKxLBZ8aNPvnEK3ELUlnzXGEtxxEBPyBqttmXpdqgdoD+t6qlld4XmagQDxIjYgx0P9LiZitbwuP7036LJIxD6kqJfv7ZpiznsyrXPDm0vF/EApuL4Kl54CbAdCejlXtG9+CcruU0NLQ/yuZZJC+GYFpJfy7nw/e9sB1Q4FZ8SM8R/o39+4vFc4BoqhBnNsI2WV27+HBcrpI3MY+xLXn6UUI2mITmfiyQv9/h2Wy+LgLPw07YChYEAKWKlAY6IYkIdhDLaqhNstM4E9Qlpvr2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgAq+KJgLccFNcJBy6CDHgu8lc7fgjgoI0iRn5SzaDQ=;
 b=V4xrFPGKzb14n9t+7IEQlsOeambuTfMCIMG+LAJ76pFSCtw18cOyw/+h6G3cSz5+5m/db378/6OjRW35isjTSGHmr29y8rQRZmbh9IPixfgzLBxOOl7ndWLak9Wj+GsRKs1ALcezlR/+Eg9YXDAvY8z0cjjLjbYm1YEnIZd0drVqxTFiYF6+PiSz1mpC1EPZG3swnq9z9mIcww1MX3/rvNp5lBsF4IwxjJQKS/ntu6WrqMA4lDbAQM9ADFA/N4rT7/kPkhu6cRX44IdGqo/jZ3DKnYzdQHR7UEOdp6ADIPeCrwk/5k/CulZr7FWst/84D9A1MXE3Y0BGgyy/WwzdSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgAq+KJgLccFNcJBy6CDHgu8lc7fgjgoI0iRn5SzaDQ=;
 b=phE3H37kCyV/HKR7+EPBA6pGX7G/pdfrOqPW1+tA6Id5yIafme+5UNAjogb7JkEByUW9CCVYEkUqnLm/h0/1t8ZSlViFke9gnCDdvlg8emWWTFb+9Zd9GnfVZHIK6Vg2+zZGecbcqys230p7RchoSXKVbx1CNIHESYBDn+5vKTteu/UIeNCsrETCls41vif2UWxeoAyNSC9gMuxWUb1hZ9BcCrteEk6YpZzMtPdt197ea4Nm+6slnfNmnhouJZFYYSTrUf7BZPHBcuvxW6Dz8Y8rLQgv01+V8s7vEzwyg61y8o5FZ959dLnxIeNDr6yhikRiVmUS7AUKNIDt5liDqQ==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by PA4PR07MB7695.eurprd07.prod.outlook.com (2603:10a6:102:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 12:38:10 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5%2]) with mapi id 15.21.0292.013; Tue, 4 Aug 2026
 12:38:10 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "virtualization@lists.linux.dev"
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
	Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v4 net-next 1/1] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Topic: [PATCH v4 net-next 1/1] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Index: AQHdHquky4Lusn6ys0yW+D1m17BB47aNGEwAgADE2PA=
Date: Tue, 4 Aug 2026 12:38:10 +0000
Message-ID:
 <PAXPR07MB798489DFC97547F586618BEEA3D42@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260728161007.650717-1-chia-yu.chang@nokia-bell-labs.com>
 <20260803174726.585aed45@kernel.org>
In-Reply-To: <20260803174726.585aed45@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|PA4PR07MB7695:EE_
x-ms-office365-filtering-correlation-id: d269d89d-c1f4-4e4e-0782-08def2253e62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 rElUnhzrUO8uQs5GmMKhg6Byq6dcmp88z0oiwFP8c3sCekNIrsrrwnn7BPP647GtzMFADM8ZJwQ/UctEttxNH4yK+EEkx2HLvWONEXU8BrXhpTg9s80ICfFlGmSE7MB7TUcTKEpANys2oH+7J8mWvewrp9qdUv8d59KgL8OZzcycp161aivPSiWNT1UvXrkfxw2DRZxTRodBFlhEJNIFWlpO1d8faqiMofwX44IeUhNoTYmEbg1vz7+//roiXo0Qu62Q+7Dtqz24cAZ8B1S0P0CKjlgYnKFNPRChsCfAB+BhO4uosvyrOsqCzT1vibMwB7D7N6eGbCZp9QiotSs4hbaDSkZxvEfPmbyrLnp/21VjTZlkD9SXj++7m4aG2oxW2WiW/kz24fP3XD7zBXyAX6KUSSS+QLS4VfRt5/L/w97WFd1diBtsNLW2VrYQWIShQqLszm/1juiiUO8MJovmOwC1VeN8SKB9j1SKb1OSH3/kJFBH253pyNh0pn6IMe4uTc3CCU66Wfa2cReq5HcMJZ2ahLENCBlBppc/SfP8nVItGh5cCa0ee0UYV+w1NG34oYCH9LVTcJ6+0rMNwWfwsNPh89jkT5BHD8kTcQOD/sPgxoarskOqs86kn5ELy5d3z5WYuhMBKHDJlLJgWHgIDg5/hxCABU6nZFa/2mOFG04=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?z+NRBkvEbfb2Jzv1B7xaIXNdqZfD4q3hE3wY4X6c4Gv+seoiXcR8vNL7vTal?=
 =?us-ascii?Q?kKREFCafuIZbnR6v05hV0MpwirT9jbqi9ZcNLw8BsBghABYvYd1W3MRzIr4c?=
 =?us-ascii?Q?Q99LGL7Vap5aWjI/LUXEra4RnPEQP4xxrD2YchcATEoBKGnUjLvu+SdlZebs?=
 =?us-ascii?Q?zMjLJJhAWPOqBdsq9Tdizy4R76+7XolnZIeEw/ExPuISWDU6JsJ5+BkuIv5i?=
 =?us-ascii?Q?vuhX2tXEEp3G/SPYe6XEUTlgtJzi7rsnYm80WbvrUELlOLKa9vBOleip60xN?=
 =?us-ascii?Q?eOnIE0QwB2oPUVgyA8IohTYeTI1YzwyP7lnn40SSXDbXzNeJ8j1MqfiK6oLO?=
 =?us-ascii?Q?R//In4Sw2lVdtk+Z2mIRlxT+HU2sj3ccelkmhG4WYMqMQCTM2frI0OeomTuS?=
 =?us-ascii?Q?Wv7AU1z6f1ISSM9HYb9gYetFpHtV2nUvfQesH/B38ASKfGpN5vuDlYQa5cn1?=
 =?us-ascii?Q?aTAdgU6UUEYmex9NCdmCuOBEZMzIKQWcCSU7Xwu26j9MOTuVHGm3OpzaxYXR?=
 =?us-ascii?Q?CWCdbfbhl5Z+TMtkv61mC+pWBFXrBisxGbhr/Ra8ckLA8Aa3130WvCfDY4Gs?=
 =?us-ascii?Q?MN3POvC7lssF0sNuaCtd9RPwyR8dThEjbUUGRT2JQLzHGmp9/uTOprgepJCF?=
 =?us-ascii?Q?mEcgSgat5Mk4yPdcMlRACh22hnjjHDANDvc0hI/BBw0P+g/KAAGFPSbvWTVZ?=
 =?us-ascii?Q?WG8KtJDZREz1xWdlGqVmMo/9azek6rrYjGFdCe9HtvQgR87vzcDpyhRXytD0?=
 =?us-ascii?Q?S4brBuQZVqALrsWJaafevELL5jHqAzPfQBA0uVZN1aMdLiNM/T4HJ2bXuSNW?=
 =?us-ascii?Q?Bnz1HU3BK1KEkO0728m4QsyS2scW2PBqpR+lG/emOQKRHEIjvVY/SNdjSIRJ?=
 =?us-ascii?Q?ccPNdkj1dCAAEjWvlPxkralHthqk0bEW6nPZzHmPUbYOFXDwoFuX5rwFGZ+g?=
 =?us-ascii?Q?lOHAU1P4kgVQj8m4v3GQB0+FyzqM0jgzeeRMx16XBRhfckfPzMTT8TKOoie+?=
 =?us-ascii?Q?FigAEjmvqbkCQqYAW8r/Rk9i14yZJowIyboXlTnlHgDZy3xk/CD0oFdmuBf1?=
 =?us-ascii?Q?FuJGdE4cRAojdneEk7VayqNuDWplUv9JJ178vgWsJ1PViSOeLFrgAbgT8ak2?=
 =?us-ascii?Q?jNdf+5aTniXC65fR7P3CfY1oNoUR+2WeGLAqoh00ok/EeMFr1aAm/Km+2JA7?=
 =?us-ascii?Q?DRLFKk7Yx6wEbVrIbIKqd9Zot6yBiHcKAsVP7c0zcmpSY0/t02C88W2g8qVN?=
 =?us-ascii?Q?PhX98NnV0gxjjlC3nmKnafC7HFsfUzXDHyRhfwgJNbK0U3vAcifnEqTVaucd?=
 =?us-ascii?Q?XYDzrO8t44TusxZwkb2Mt2h8cd7QXQKrnReKcCCSdaB4PrrWjhwXzz/cvmkh?=
 =?us-ascii?Q?yASJeHhP3Wjd74BIxoFVtQYOSUfPaefSgvvXNxbHsOIeLQLuugwXRNl5av4J?=
 =?us-ascii?Q?yBVE90FNCngnu9zVNHNxyQVlzCQ/tNoqsBwCbxwy5GRWXHMtYD99O8XAuSDR?=
 =?us-ascii?Q?zzF1kuNYhAGmk07Af2cdjWIDrVxJCtKrD75OFxMgDJcFY5F+4E5kH62enfY4?=
 =?us-ascii?Q?GHHUj7+/LFgHJ3OUhkP96UIjyicVcBhFp25VqorXVYDMOJku15/6bMCXOF1h?=
 =?us-ascii?Q?i3NkS1M2x+TYWR8QT72pD5mkAlzbHyek7zkyYyJLlb9Bs69//V9IKtU6CVUK?=
 =?us-ascii?Q?QqZ+cy/hQEsaOM1qOk1zNbE01V3uGo2EzhGxzsLckwdfSkxHX8uVojo1gY5P?=
 =?us-ascii?Q?KWnm/Uzb62TtajA2JwZZTgat4Y5OY3U=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d269d89d-c1f4-4e4e-0782-08def2253e62
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2026 12:38:10.6901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PBzitiicG6ke6GSN4r7chRk8ZsDshbX7rTKjNVZBV160XTlEDGVIjrRJa+wd0Sueqw6NdpNoPNfNh+GxqVdE3st+lyBAhpJkeAou4feZGbT0GXXx/UcDaW3iNsQ9vqL3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB7695

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>=20
> Sent: Tuesday, August 4, 2026 2:47 AM
> To: Chia-Yu Chang (Nokia) <chia-yu.chang@nokia-bell-labs.com>
> Cc: linux-rdma@vger.kernel.org; eperezma@redhat.com; jasowang@redhat.com;=
 virtualization@lists.linux.dev; mst@redhat.com; xuanzhuo@linux.alibaba.com=
; pabeni@redhat.com; edumazet@google.com; linux-doc@vger.kernel.org; corbet=
@lwn.net; horms@kernel.org; dsahern@kernel.org; kuniyu@google.com; bpf@vger=
.kernel.org; netdev@vger.kernel.org; dave.taht@gmail.com; jhs@mojatatu.com;=
 stephen@networkplumber.org; xiyou.wangcong@gmail.com; jiri@resnulli.us; da=
vem@davemloft.net; andrew+netdev@lunn.ch; donald.hunter@gmail.com; ast@fibe=
rby.net; liuhangbin@gmail.com; shuah@kernel.org; linux-kselftest@vger.kerne=
l.org; ij@kernel.org; ncardwell@google.com; Koen De Schepper (Nokia) <koen.=
de_schepper@nokia-bell-labs.com>; g.white@cablelabs.com; ingemar.s.johansso=
n@ericsson.com; mirja.kuehlewind@ericsson.com; cheshire@apple.com; rs.ietf@=
gmx.at; Jason_Livingood@comcast.com; vidhi_goel@apple.com; Parav Pandit <pa=
rav@nvidia.com>
> Subject: Re: [PATCH v4 net-next 1/1] net: update comments for SKB_GSO_TCP=
_ECN and SKB_GSO_TCP_ACCECN
>=20
>=20
> CAUTION: This is an external email. Please be very careful when clicking =
links or opening attachments. See the URL nok.it/ext for additional informa=
tion.
>=20
>=20
>=20
> On Tue, 28 Jul 2026 18:10:07 +0200 chia-yu.chang@nokia-bell-labs.com
> wrote:
> > For RX, SKB_GSO_TCP_ECN shall NOT be used
>=20
> but it _is_ still used in hns3, what's your plan there?
> Documenting something we adhere to at the outset seems like a red flag.
>=20
Hello,

I would think to remove the SKB_GSO_TCP_ECN in hns3.
Because hns3 will break the whole TOS byte based on Jijie's email: https://=
lore.kernel.org/all/47530dd8-cba6-4282-ae80-4cabd52b08bc@huawei.com/#t

Also, the virtio related changes will be submitted only after the approval =
from virtio-spec.

Thanks.
Chia-Yu
