Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012037.outbound.protection.outlook.com [52.101.66.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937BE40D588;
	Wed, 12 Aug 2026 10:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530807; cv=fail; b=QD86stPWv3WjTsViSAI0ad7kwnUSLhRsd1OdwyZ4AoVq6VId0jP317bZ0BQYpG4wtWmhTxtvo8D3Qr69ftKrKgCZg/1VabXGcKC1AMkxQRYWCORZUCl1t4nxgTfzYGOn7IH7PCl8neTVhQLkHCYLWv1IttNZqDZ+9DdjiuFCf7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530807; c=relaxed/simple;
	bh=GGYlMY58pTfPGflu0wQYWBvI28b8yaNZ6/w4pPHvALs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fi5s0eZDsEQh+3mVnAp+MEn4lIMEcp41GS+InzA2XNQWioudkhuNsizteOjUMhOWdgDSey0eZkNVXxwqwt1x3rOuMcl69jZKfkNlVN9gnr9lBIlynzZ8rS/qtKRQmC3XZtrHvTx9AMtCFrAca43k9xDRdoSxJyt6sP1gByym6cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=UJawpX1y; arc=fail smtp.client-ip=52.101.66.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="UJawpX1y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NUKzXiLmiQUl5zaPetAlsKo9ryTCji4BxxY4nem+fX+mC7meDGONEy8YHiHEZcaU/dcVF+UTi6AzuV+Gc/feTQ4GfP27Dc6zbRHQJ/V6xdJBkDRjI6sPESr7fAUk7hPqvYAf0MLCYwql8DK0FktCCOBfqOQG1keBNSOja41khLBU2F5WIDlXne9lQn71Rh7jicdTiMP3awQhIxu0A4hIwIidEHSaeS+5o+U0LBsYCkSSHtzf6ZbZcnzAPQoI7CQp26sbEcQvi47W6t6FXiFj6DFuTm9fBOrMiH1dYXpEPkEyL4zyt8q/mvrdgZSTzCiCDFEJzTg0SARZ1cGfKuCeoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8TJwLT+PYe1BbLx0k/79ug0z+h0b0tLmU448nfrdeU=;
 b=dkg21tn31wupw9WzzQQwUfbpMre9gsRKVFdlFYZeo2JjF2r/5gBUsLm+VaUPyX7FHi4teS7Mqd3VprlI3jQcc5XgL96Y3hZzAqG+kHnsX2ugmD72+qGdGzwZmy2Gf5IXSh2uvoMbnQ1eYsxdlhNHpxdRivE19GgdlVZ9TeBW5XIq2NKdzuAu3SQQs0HHO1Q2oPiGej7gdmjG59/DrDodQujjl5n0O+/GElTQ115Ij3+vlBL7NoGIE1I/uvNQ4WNLuyuC8weRa+EuhvSAw3ReYZE6lBNGyX48pWMaMS2EzeRYqbbXX9qfoerv4BXaxuwXxHtUonjYBURZJsgTGSCAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8TJwLT+PYe1BbLx0k/79ug0z+h0b0tLmU448nfrdeU=;
 b=UJawpX1yXx+VoLZEhzBimueQxe4v5mbxKfDC6S6HZO0xj/Fta1xUIFutNCSfkUVpHbGKdZxWAUcvOevA8ZCn8+Uy7ZFCGzmM1YF/HISwYnW6zrprRfyEl+On7spSBeg4smRHQQlsVjiV9yAWOY6V4BUTxMP1eV+l5xQAqI3KoqiFqTeWE0Sbf6+JMWLMCI+eimdWCYyNlSp9U6DGy/rOOSgxUh8usdPBzhbIplctDhOCqgzkgTWC65TXjMIU4ELt7SQ4/DC0+6VNi8Ah7bl2cd9ofsBX2lp4pqCsO1ESmSdLpHXQy4MTlQnmUhBIIxt8stXj03jT3rfuZs64M56MCw==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by AS8PR07MB7733.eurprd07.prod.outlook.com (2603:10a6:20b:350::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 10:33:20 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5%2]) with mapi id 15.21.0339.001; Wed, 12 Aug 2026
 10:33:19 +0000
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
	Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Topic: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Index: AQHdJFkmsZErp6HN50yIAT4nHZCuDbaZmsyAgACaoWA=
Date: Wed, 12 Aug 2026 10:33:19 +0000
Message-ID:
 <PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
	<20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
 <20260811173017.3d18dfdc@kernel.org>
In-Reply-To: <20260811173017.3d18dfdc@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|AS8PR07MB7733:EE_
x-ms-office365-filtering-correlation-id: 5f992d50-23e5-4fc9-5e41-08def85d20cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003|4133799003;
x-microsoft-antispam-message-info:
 4QFudAbv6WbHpiL50PX2a/zPZYHEM1CkhSCBVmob93PRppffMcLg69uHgfF6rjc5nZhZ7gRZJcoPUiPeXgJQ3sbJwMksCxfl195OBnRg6cueu4gKiMg9zLaffbzeMuOQlJ6uYTzAip3F/aY//+gvpI+MYZQeGqm8TmUumNyXjffLFvxFbsHic0PXdpiPpsL1BwKhO56+xU/gw8MrXuYYz8/vKmvgvuPFFZmNLijE8MYFAYaslVRaFe2S+p1dCzEzp8DvGX2ujYXvR1jCP7SDjj/1mgoOGf16o7RZdXXfWo1tiYyqEE6WF+ZD3xT+EUosBpAq8btz1tXL9DrvAO8OoX5SZG5lmx8QHQIKiJCJNkLLlBOb0tfkVT+IKB3keHDOIBW9nBTJs8dqsSOm69Ez3k+5Etsdl8yEvWUm+6h7TbXd6SooMkXpbB765wFAJLmRnijkSDWqLW73tXpWK1OeRWm97YIQ1DaAk+OwbX6dkYSh6kushZ+g2ESVz/jWjSsBqumf4VWIUH2/nH0A04+M69dK+kyg/IbXsIZ0zUjk7nmrKUjXyrC80OB4FS1OjF48zX1C5D8FQ8/DUgvNoRFJHjTmICquznory2FBsV+4jLkEqOYaxS5ij4ClnO3As3QkasfHt2YX7JhXhK6Rxkipc53+xQ+62BDF8IzVH/i0qTdCGtHo/ZkEPJ6YykPYKMhB+IRHZxdcX5dgKfkddbrHpUcvQcq+fRAwywEXttt/6Qc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(4133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Mr+7Xk+ZG0XeLwHnfsT3z63OCCwrgTKbTNGB1H6lUuynaIcNjXd+899HXxQc?=
 =?us-ascii?Q?uyOGER46HMAN5E7vu7RNF/hlUpbboy9ZnWTYEP743+e6ugZZF8TQeVMlXNHL?=
 =?us-ascii?Q?rOiXnvAvYFJnwCaxoc1SeZhINdfWsPcYJFBIPVC1MLs50K8wkZYczWYTP1z4?=
 =?us-ascii?Q?SVrt58L4GrvbgUdq+a6w1mSy3DNSftdHko+fqvYOpuzW1Tgcp97C4+kGFLda?=
 =?us-ascii?Q?Jz3VNSxzkhVOxX3152GBHlEiCcjRRDjCNkjHefl0c7E/szPwlYF1+EnTaVJ4?=
 =?us-ascii?Q?ckP5cilex0hF0u5dTiYwmbnc+0VnRIYMsk0Z0TDao+/McIe/OpNjDYxW/GSY?=
 =?us-ascii?Q?Mz8/bK7iN0SKJVcyRALS+VlqlozfGRG9358bILXKPZ16Gtm4zKC9qUKV0E0x?=
 =?us-ascii?Q?UdV+KTFDTJfCp/t58urxv0ouaWrReeHN5s+us6AD7zCr13T54wrdJ4XOqm0S?=
 =?us-ascii?Q?MVYRJUjLcIKFJxiRivhb56fVCNsgAcpAuFNALU1rIPAwvtnB/XNvmNsLA5R7?=
 =?us-ascii?Q?ODzLOedNConoShXVSMViSxiHCc/aDY+N8+l8vNM48GBZaHTWC7zN6BncI6za?=
 =?us-ascii?Q?fTLDy/yj2g0yTCLzqXnlbrmU0I8mAhlo56gU926uAge9DK9WdQiBo679Elic?=
 =?us-ascii?Q?JV2LTsPcY5TF47Ia64JbA+vCcM0ZlljkMM0Iz3B6LY3Lu4lHmPIt15AEjuSr?=
 =?us-ascii?Q?M+W6Yu4Zj0SzJIScI6txGMJWcZKmmCQ+nGNcj5N9iLzNk0j1dZQGjyuQPHTf?=
 =?us-ascii?Q?x6jWwphimZc4xK7F3wNrLWFhvKlmLE7no0+OwcqD7AftBbw8RvA1UIrLi/yY?=
 =?us-ascii?Q?1JxszXzDk3XdKH9aVHJQcnPycgVAcekiU6B2C70yt75957o5mFfu+ZDd97Tv?=
 =?us-ascii?Q?roWnzQk5Z/GDbGORyUa/ZvjaygGZJRysfTsHf+LYXB0tSpm07VqU2juR7rBH?=
 =?us-ascii?Q?tyqtShKEjnBA8OYdItSC08Vr8EQHmDrUH7iVcu+BAdGUIinqAZ+DNj/DM3Hm?=
 =?us-ascii?Q?5JGi5KErW1qMfNGHkZ3N6rBwPJRTtQKj60XpdF/bK4+s+K5i7chqPoBAxMpB?=
 =?us-ascii?Q?DJxH62drMDakIBubobEHUU1BeI38jKvYmfM9JRdLqHlMgUsZniN5jLpoTo7+?=
 =?us-ascii?Q?vtKdZsHWHT/Uj7Ympr/Ot8OW/uqckiyOoAnd3ogXjlwAvGUtHT50ViS55hgC?=
 =?us-ascii?Q?S82UxJQOSjnSrd+kGZtKRgH/AB2GMsKaKb7UzBz76jhEBFu9xM7iqIzIvBXi?=
 =?us-ascii?Q?UaDLP1D55MZAcgaRLMbAH3iQaR93vMdIn9SIaISrd47MHhEbuJum2suqMB9q?=
 =?us-ascii?Q?zs6SJD0Mv4m+goOHBJsKSWVeihH9OUj4oZ2HvVsYtpqvcPgm1EnoQaJ1O8y8?=
 =?us-ascii?Q?t5Z3J12N11tFPdNEjX8WxSdBAjEv3eX/w1NLy8PUAdIE3hAO9ejmayb45LGM?=
 =?us-ascii?Q?YmM30IkLlH6PO1QANSFPQh79pKkQfbws9YI4DHo2+xor7u3LXv2vE3kywrFr?=
 =?us-ascii?Q?nw2csFf4ijmuFeqsuHWO5H+pCDM+5+mdmFDotdt+QSLU2YVJsqaficzJd58M?=
 =?us-ascii?Q?e5X8YUrsKcHA/TwZePdalE7ilO6DV3hCv4/4r9XBr+iSKKIphVHY7pD5tKOp?=
 =?us-ascii?Q?hmhOeEeoMFMCQ6/sEGAOkRYrnC6t1GoZVD5o0JcYlyGmR+pP4iXcF/VyAaua?=
 =?us-ascii?Q?LmDvI1HfMfL3z97qQ83A1tlPX1xSTHJQCOYea8hCxx18TuSaP/kcLC8a0+SX?=
 =?us-ascii?Q?ZogVhAgD6iwzuwhxjMhprp+msv5rhQ4=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f992d50-23e5-4fc9-5e41-08def85d20cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2026 10:33:19.9199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Juhef6DFQEgGEpt4n1prIbGw334GbW9t24PqPSES65cd4Y2GjqTe8SQCOG8aOQODlHCJKqNOf63gdXUSqbym3QIiq3MrJEWuWryayVULoP1cVn0N9JsFkqJzrIK2vrGD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB7733

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>=20
> Sent: Wednesday, August 12, 2026 2:30 AM
> To: Chia-Yu Chang (Nokia) <chia-yu.chang@nokia-bell-labs.com>
> Cc: shaojijie@huawei.com; shenjian15@huawei.com; linux-rdma@vger.kernel.o=
rg; eperezma@redhat.com; jasowang@redhat.com; virtualization@lists.linux.de=
v; mst@redhat.com; xuanzhuo@linux.alibaba.com; pabeni@redhat.com; edumazet@=
google.com; linux-doc@vger.kernel.org; corbet@lwn.net; horms@kernel.org; ds=
ahern@kernel.org; kuniyu@google.com; bpf@vger.kernel.org; netdev@vger.kerne=
l.org; dave.taht@gmail.com; jhs@mojatatu.com; stephen@networkplumber.org; x=
iyou.wangcong@gmail.com; jiri@resnulli.us; davem@davemloft.net; andrew+netd=
ev@lunn.ch; donald.hunter@gmail.com; ast@fiberby.net; liuhangbin@gmail.com;=
 shuah@kernel.org; linux-kselftest@vger.kernel.org; ij@kernel.org; ncardwel=
l@google.com; Koen De Schepper (Nokia) <koen.de_schepper@nokia-bell-labs.co=
m>; g.white@cablelabs.com; ingemar.s.johansson@ericsson.com; mirja.kuehlewi=
nd@ericsson.com; cheshire@apple.com; rs.ietf@gmx.at; Jason_Livingood@comcas=
t.com; vidhi_goel@apple.com; Parav Pandit <parav@nvidia.com>
> Subject: Re: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP=
_ECN and SKB_GSO_TCP_ACCECN
>=20
>=20
> CAUTION: This is an external email. Please be very careful when clicking =
links or opening attachments. See the URL nok.it/ext for additional informa=
tion.
>=20
>=20
>=20
> On Tue,  4 Aug 2026 23:35:09 +0200 chia-yu.chang@nokia-bell-labs.com
> wrote:
> > This corresponds to discussions in virtio mailing list:
> > https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flor=
e
> > .kernel.org%2Fall%2F20250814120118.81787-1-chia-yu.chang%40nokia-bell-
> > labs.com%2F&data=3D05%7C02%7Cchia-yu.chang%40nokia-bell-labs.com%7C150b=
5
> > 1c3733640dd2cde08def808e48f%7C5d4717519675428d917b70f44f9630b0%7C0%7C0
> > %7C639220914236399114%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUs
> > IlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7
> > C0%7C%7C%7C&sdata=3DjGSBo1wXJOnjulVOJKW3PAEbrUAq7X30Zax4SBJ6VRQ%3D&rese=
r
> > ved=3D0 And it was suggested to clarify SKB_GSO_TCP_ECN and=20
> > SKB_GSO_TCP_ACCECN.
>=20
> > -     /* This indicates the tcp segment has CWR set. */
> > +     /* For TX, this indicates that the first TCP segment has CWR set,=
 and
> > +      * any subsequent segment in the same skb has CWR cleared. This f=
lag
> > +      * must not be used in RX, because the connection to which the se=
gment
> > +      * belongs is not tracked to use RFC3168 or AccECN. Using RFC3168=
 ECN
> > +      * offload may clear CWR and corrupt ACE signal (CWR is part of i=
t).
> > +      * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid CWR corrupt=
ion.
> > +      */
>=20
> I still can't wrap my head around this TBH.
>=20
> SKB_GSO_TCP_ECN means RFC3168
> SKB_GSO_TCP_ACCECN means AccECN
>=20
> If the HW can correctly detect cwr on first frame and then no cwr and rep=
ort that as ECN/RFC3168 - what's the problem? TSO will produce the exact ex=
pected segment sequence.
>=20
> Is the program that if we re-GRO that frame in SW we end up with
> ECN+ACCECN on the same skb?

Yes, this is the problem.
The HW does not know whether the received packets belong to an RFC3168 ECN =
flow or an AccECN flow on the RX path.
For example, HW GRO may set SKB_GSO_TCP_ECN after observing that the first =
packet has CWR=3D1:

+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
|     Packet id     | CWR flag |       Flag      | Flushed as SKB |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
|         0         |     1    | SKB_GSO_TCP_ECN |        0       |
|         1         |     0    |         -       |        0       |
|         2         |     1    |         -       |        0       |
|         3         |     1    |         -       |        1       |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+

If the aggregated skb is forwarded through a device using GSO, e.g., HW RX =
(GRO) -> veth TX (GSO), the SKB_GSO_TCP_ECN applies RFC3168 semantics.
This means that only the 1st segment keeps the CWR flag while all subsequen=
t segments have CWR cleared:

+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+
|     Packet id     | CWR flag |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+
|         0         |     1    |
|         1         |     0    |
|         2         |     0    |
|         3         |     0    |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+

This behavior is ok for RFC3168, since CWR is expected to appear only once.
However, for AccECN, CWR is part of the ACE signal and must be preserved ac=
ross all segments.

In the example above, the original CWR sequence was 1,0,1,1.
But after re-segmentation it becomes: 1,0,0,0.
This is why SKB_GSO_TCP_ECN should not be used in RX/GRO paths.

--
Chia-Yu
