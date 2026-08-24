Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D423FA5CC;
	Mon, 24 Aug 2026 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787592296; cv=fail; b=Ng93DW4TQYl3xTUGo6hPjiDKtVuYPKWpTdsItsQ9OgefDbtuv6BKiMX4zOi/TiY7rQCTKbrh47glNkWSPPZXLjtZkKdKxfVcimVT84aCxQKYsJRo783IuCiKcKOnp4An1RpOEPKeopMr+2glrtqDrmQfMhjBbBoikZGGBs6fCsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787592296; c=relaxed/simple;
	bh=1vbj/dAGlTQsCZw80PAh64V05oEODoE873h7vrqy6WU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L9F2spSIPJOnI8LteL7OPzArHtPDIOlJg0VyEQB6NgkWVNrBQMaHRkBmF6g/F4ALmCsZDL8r83CtkyvyHJqRH4JtCpITcgfeweDg5YQUVr5WxnczWeVVoHulDpwAuSFmeR7L4Z/UvP2ZBAuptIE+DwpFr0k303Qi8X2Vgt0va1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=EHZCsa4k; arc=fail smtp.client-ip=52.101.66.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="EHZCsa4k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djkDKb6VKMChlEejCwgMPUPDheGt5OqjkTNqI6wjUMS22rEKJOA7Kpg0J6PCxqBCKdW0gZZKqzhE8b6EWUvm4vs9x8mMWiKhO5QMDjbpNuzJrHfAPVbZEWRUn7haj2MlKzNfsgJkwPBblkjgV0QIdaCeww3I/M358e2ZXnC4akV3J9szCcGFNSGZ7CQtWQ8hHOOXiNhJY3sZz3XZrIQ5yqsr1kewbZqrxy4OQKj+DbpKg3DnXcPAPu0y0Z5rKqvuig1mMYXz/vWOcH4T7Ha0W0bTHnX2L/U4aOy4MJbU17fYnRnjQgHK9QiyN0UQFpFzPrs7JWu9gUtdRYW0kFWgNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IF7WvxO1pgPjTKRVlEbDus9sinWcH8DbQul9YMGpJxk=;
 b=q2HmAIVMvlUw5MovTkKITNi2ad7W4BxQEGti2ZlrZgzd3zru3MPnf6XEEJD/Heh1686N3s0O0k3qT1eEYIdP4p6iVAvzcTT9TYGkoAPLF/GnyHHUmZN5rBt4q394fKqJ5bTwIjlMTXuw1n6PFtKudlQJS1XgNMed9PgUToFwWo8De7mSVbngOHTXIDb/u9TleVApRanwBA8edbAWpPd4VX3b9D7WvTH+qVSkjLdW3Y4hdrn2wks86iWcObejZ6mflls5zP2psHtxKPWx+EPGGGi3OAClkg85MwZyaD/ifjBORJS9Ju8pBFDKeGHaF6FPe6gX+HYaHqaAj/zbBKCRhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF7WvxO1pgPjTKRVlEbDus9sinWcH8DbQul9YMGpJxk=;
 b=EHZCsa4kyAgscskFrvuJTO4GFamgYaN6UGnHzp8wmMjP8Saomwmc4a5kVvRFs+HtUpuHxsN/bkArCc3DwQaYvrKpfGzLQXlt0RXjHFcXAknfcFy1Ux6EdPBxqpg3g4RjGMlJCmBDjsvtZPOZIZmj8r2yma1O9RVOptg8hv3R6ier3PY7k6iuR0A9WkCv+po7A26ku+1dMZEAe2Cvt6qQ5FtyQJy9dEbtoCq6ZQDOknVkq+XDO1wHoj8bwzK8lMY9tax5JPBf0HFal5kDkP43u9X6l7DI8sCfmJ0o2Ru58NprFNMWb6CnE5lINeyxeg5nOLbsTzk5mLBOmbvjqtRW9g==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by DU2PR07MB8255.eurprd07.prod.outlook.com (2603:10a6:10:278::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Mon, 24 Aug
 2026 17:24:50 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5%2]) with mapi id 15.21.0360.005; Mon, 24 Aug 2026
 17:24:49 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Jijie Shao <shaojijie@huawei.com>, Jakub Kicinski <kuba@kernel.org>
CC: "shenjian15@huawei.com" <shenjian15@huawei.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
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
	<Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: RE: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
Thread-Topic: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
Thread-Index: AQHdJFknwofVPz0NnEuqy57Qt9muFbaY4t2AgAFg0yCAANAQgIAJrtaAgAjHFcA=
Date: Mon, 24 Aug 2026 17:24:49 +0000
Message-ID:
 <PAXPR07MB7984BC22EF5F2BCE5319D8A1A3A02@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
 <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
 <PAXPR07MB79842CC27C2F5CF9BD40E007A3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <20260812155927.57ee295b@kernel.org>
 <b1aa6136-3dc1-4190-beaa-32bee88b7091@huawei.com>
In-Reply-To: <b1aa6136-3dc1-4190-beaa-32bee88b7091@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|DU2PR07MB8255:EE_
x-ms-office365-filtering-correlation-id: 7a747943-2038-42bc-0f02-08df02049a20
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|10067099003|56012099006|6133799003|4133799003|22082099003|18002099003|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 1p6oevB/XMeJVLIbwXqFst3wNqEpCDlLMfnkXblPLugt8yJfeFM6U7BIGwdxo5Jcziba77y4+lr1Kn7idAJADAINjiFC+HPFJrIaRP7aUvWtxUSZxEQ4n1/l6qYLC71H2KSa8zvcvtgAqNftFXpF5PjQNv/QXHwL2ditJCKa1Ti0JZ3w1TujGVgqXL5f2UV2jcTobQ1rQ0+UADQRlGzObMsbncmvXD3BIBZ0oYM0E8ZSskSG43BUS3gOwtP0tm8WOD/W/q+uqRklSFoEw5beSCmgsy7N6wZtfnNJdlrVpRLKwaxV+u0yb4XaM/WU4yBGONmFPuWTrCcrbaXFRbdBMjVhxQY8hGxyCB1q7yg9jUY9yY/suXcRVqu/g7VxL4r+opfCiM3sQKpHLhdaq6wSBS9Jhz6yMxOCyt+mcArWWr9HucuGclnbsFuLXvNmuLtjHEvSKr2E7S6D6xXon0fE+k9C6zoAXXBMDeXYQ9xh/4nmoRezS7cqSQcjwDxwZY5oZyqnfURlIYhZQlKsSC7xbEqHDS6OtFW+yl0m8+61zaxWt9Xh5ASyaDUVbOHINPLOSOAPF9gINsIhwLB2ok4ld2ZNWgfyy3C8J0kwKuceZ5FFKNCEha5ef63fHpxZaQP89xF9e5R988Ud25dmK4JpuHf654+LWYB4SQW3e/5TP9NTO0D2ECR/+FtkFHJbs/aZ7KBJXWLURLt4RTcunlzXPLSB4C/yY1RQc7z4ab1JNQQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(10067099003)(56012099006)(6133799003)(4133799003)(22082099003)(18002099003)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Hnp2mIfuI0QYucNSpIAi/BAqTYd9Ake3E43dhsp6wg/hBSWl+miP/sNLwlq/?=
 =?us-ascii?Q?rd5KDxcd85RdHUDTePZ4mxr4tI+lipKlVwpT9iqAIzVlwPFkdg3VR8QivKnk?=
 =?us-ascii?Q?Wg3KACq/CDGhHjb5jVfXr/J0TgS1X/4wIylLfyV7bY8XXWduXR02l6FKZfsc?=
 =?us-ascii?Q?37QmUa8F7ZduUVhFlEDbxq/p26nTPUOWSxnIfkfjlk23B481aTV9N4HuOGxn?=
 =?us-ascii?Q?yxu9MlpJdnUc+8PcKFv7oYJXaWxRhUQVD1xOpR7GFBU6Xx+QDfGdBZkET3PR?=
 =?us-ascii?Q?FbSKfcn5FjslVHCOafISQqdtgo9b8aiGkbbd2VMV9SDkQIP1frJyzluqn7GV?=
 =?us-ascii?Q?1ZsCz5WwAhVI/0Os3GqLyajSsfn2/FlDKRmY0/s93oIJB2bzK7rmqfuqIdzh?=
 =?us-ascii?Q?cMpN1pzGbuMutwbpmoYmLrt8S9wy6OTLzARxeIhm4E89eP3oD6DHMc7b9yjd?=
 =?us-ascii?Q?E9SNv5LYpHzZG1+hluqij4Sos1/qtVGVnmKzXc4ndabsdOAlHzZtudNOepCy?=
 =?us-ascii?Q?kkXZj0wlg++xmtvIsJNW3RcjZbAHGmfxQhabjvzVCMAlZAn+xMoLZTZc+OvT?=
 =?us-ascii?Q?LGnFJWHGjRxOmYEBt9TQy9/emGjB2h8LkA7ZqmuEBDw6ZmpzSxMXfABxYgKt?=
 =?us-ascii?Q?p2KIjUWE2exrBVXebLUuDfshFWpQVWg96IBtmc7VRpaHIss9Te9pWbkKnp9P?=
 =?us-ascii?Q?c9xUu9SO7i/2Ful1982f4YVy+FRsMLMAKJeoZnEGV1tcCVmr+8GZ6W3pzDHR?=
 =?us-ascii?Q?uUFwAdrlPoJvkHTLVOxzmj4N382UgUVQBIi6ykZXaXUZT2Ew9ypkrdOQu9KY?=
 =?us-ascii?Q?6gx/T2BIqqspBzJ9VvosO44Ozi1c9z5iYdHeMvcQmR03Lx3McnXfyxjw69Hr?=
 =?us-ascii?Q?+xWkaAss/cxsBMSmz8chJ3KUUJNW+peVhdNFsfh4WJt9FuDRF5AaYNOjB26i?=
 =?us-ascii?Q?HynI35wUn4+D4Ae5s52ZTo80tjvcIrk8HS1T5+bna/tgIkDgCb6yMVsjj7eh?=
 =?us-ascii?Q?Yr1exA0k53+84UIDCFlWs3m7tjnrwuavbWWwCZnig1JC5S8BQamw5Fdv8HkM?=
 =?us-ascii?Q?NmtEwBOEOlF3uU1wPdALXx6MAk6VXNF/pDw66EqbUD0O7OfWJpDHjkQkCEJS?=
 =?us-ascii?Q?Cy5cbqwjL9Qh/jDIP576YHzDxL65iWTovypvvbRmPPjH1MaojGHagsqXszY2?=
 =?us-ascii?Q?/h2Ias2qAXWY3t0emDNovsgdN4ya7Coy0JKqsJNPy9jCcpiVfQO1o/JE9j+T?=
 =?us-ascii?Q?R1msRwTtGNh1HbPZvWrjl4Kt2acgAo8XvYmNwosXB7ys5e1CMkV5S1qU+YVt?=
 =?us-ascii?Q?7B2aAWrg1NqDqYbQOnYmA5WSRsjGDDMZmd7dESC7G+agy+lPMLzyEKebhX61?=
 =?us-ascii?Q?KK1JwXFMppPO7yPELDKd6PzQfybjXBajq6GjsmkpLVz4TyvtDp8hX963njnX?=
 =?us-ascii?Q?6FCP9a3wnCiSeHZk5OXdZ18PlWuXXd2qq4kPphtdOYpmWMHAi/xwWMyxBK6y?=
 =?us-ascii?Q?6arv0IN7yTjnPrAEG7i198BmYWiWWLtJe4BitzAGzuYVGUNxFAUga7gUU55d?=
 =?us-ascii?Q?CxtMI8YzGSDowyQetw1Y2t6WWL6wkczMy6TxJAFjDUIkuh+3s908YNL7kzoF?=
 =?us-ascii?Q?Inqo38RpgXF8IUjBH3qDWJZJ+siAlIt1KzX+DCEebc3MJjz8pqObIvps+7SZ?=
 =?us-ascii?Q?rNBEnx45cGtJM8Vub0GdMLxW7PPmhbPxc2OnSNk/hIDkOLwlb8JrO5VZAJyE?=
 =?us-ascii?Q?/YhqdCAgjvZffyIHPu12JxKnOqLKrkk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a747943-2038-42bc-0f02-08df02049a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2026 17:24:49.8778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: My8Q79kYWrX4DSPZDeNrQg8zRN80KSnyriy6/C9y4fety/M6bc66y4Fg9Zb8InBtlS02c/zeYq8sz/gEpis+CBEtFPoqG3DwN2mY/GWYWs8qyDbVSzObNefu+wA6nuBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR07MB8255

-----Original Message-----
From: Jijie Shao <shaojijie@huawei.com>
Sent: Wednesday, August 19, 2026 4:52 AM
To: Jakub Kicinski <kuba@kernel.org>; Chia-Yu Chang (Nokia) <chia-yu.chang@=
nokia-bell-labs.com>
Cc: shaojijie@huawei.com; shenjian15@huawei.com; linux-rdma@vger.kernel.org=
; eperezma@redhat.com; jasowang@redhat.com; virtualization@lists.linux.dev;=
 mst@redhat.com; xuanzhuo@linux.alibaba.com; pabeni@redhat.com; edumazet@go=
ogle.com; linux-doc@vger.kernel.org; corbet@lwn.net; horms@kernel.org; dsah=
ern@kernel.org; kuniyu@google.com; bpf@vger.kernel.org; netdev@vger.kernel.=
org; dave.taht@gmail.com; jhs@mojatatu.com; stephen@networkplumber.org; xiy=
ou.wangcong@gmail.com; jiri@resnulli.us; davem@davemloft.net; andrew+netdev=
@lunn.ch; donald.hunter@gmail.com; ast@fiberby.net; liuhangbin@gmail.com; s=
huah@kernel.org; linux-kselftest@vger.kernel.org; ij@kernel.org; ncardwell@=
google.com; Koen De Schepper (Nokia) <koen.de_schepper@nokia-bell-labs.com>=
; g.white@cablelabs.com; ingemar.s.johansson@ericsson.com; mirja.kuehlewind=
@ericsson.com; cheshire@apple.com; rs.ietf@gmx.at; Jason_Livingood@comcast.=
com; vidhi_goel@apple.com
Subject: Re: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in=
 the RX path


> on 2026/8/13 6:59, Jakub Kicinski wrote:
> > On Wed, 12 Aug 2026 10:35:25 +0000 Chia-Yu Chang (Nokia) wrote:
> >>> Tested on hns3 HW (2x 100G, direct cable, openEuler 24.03, kernel 7.2=
.0-rc6).
> >>>
> >>> tcpdump confirms HW GRO zeroes IP ToS: aggregated (>MTU) packets carr=
y tos 0x0, while non-aggregated packets keep their ToS/ECN marks - so the z=
eroing is done by HW GRO, not the sender. Before patch, CWR packets had SKB=
_GSO_TCP_ECN set (0x5 =3D SKB_GSO_TCPV4 | SKB_GSO_TCP_ECN). After patch, al=
l GRO events gso_type=3D0x1 (SKB_GSO_TCPV4 only), no 0x5 observed.
> >>>
> >>> Tested-by: Jijie Shao <shaojijie@huawei.com>
> >> Thanks Jijie for confirmation, I will submit to net in the next round.
> > Hold on.. Sounds like hns3 zeros ToS out (?!)
> >
> > This would be invalid and illegal for HW-GRO. If hns3 nukes crucial IP
> > header fields it should probably be advertising LRO not HW-GRO in the
> > first place.
>
> Your assessment is correct - HW GRO on hns3 does NOT zero IP ToS.
>
> My earlier Tested-by claiming "HW GRO zeroes IP ToS" was wrong. The
> tos=3D0x0 I observed was caused by a test methodology error: I used
> iperf3 with --tos but did not set net.ipv4.tcp_ecn=3D1, so the sender's k=
ernel TCP stack cleared the ECN bits before the packets hit the wire.
> I mistakenly attributed this TX-side clearing to HW GRO.
>
> I have retested with tesgine (direct packet construction, bypassing the k=
ernel TCP stack) and confirmed:
>    - HW GRO preserves IP ToS - each aggregate group retains the head
>      packet's ToS value (verified with 0x00/0x02/0x03/0x10/0xB8)
>    - HW GRO segments flows by ToS boundaries - any ToS change (DSCP or
>      ECN bits) terminates the current aggregate group
>    - ECN signals are intact - CE packets (tos=3D0x03) are delivered
>      independently with the CE mark preserved
>
> hns3 HW GRO is behaving correctly. Sorry for the confusion caused by my e=
arlier report.
>
> Full test details in my correction reply to the patch 2/2 thread:
> https://lore.kernel.org/all/dd817755-eb4d-4ac2-b282-ac06f847270d@huawei.c=
om/
>
> Regards,
> Jijie Shao

Hi Jijie,

Thank you for the update, but I'd like to follow up on the CWR flag issue.
How does your HW-GRO determine whether to flush packages related to the CWR=
 flag?

Currently, the software approach (see the test case in 6f74bc8b6e8d) flushe=
s only when the CWR value is different.
This behavior has changed since patch  ab4c8b6f7fcb.

Thanks.
Chia-Yu
