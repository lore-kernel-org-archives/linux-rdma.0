Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022105.outbound.protection.outlook.com [40.107.200.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ED4324716;
	Wed,  5 Aug 2026 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785956249; cv=fail; b=n+0vWFzUvmTb+vpR6suE12+QljX7EfIHJRYgG/dS+ebaDYiKCibCiGeQfu94E60jk3fRc/JndHbErAL2c3gVGUvhBUh//3dyIhrvU9C9zPuECPXuP/FZg33+zqk9iE0Yf3kTma1kyIETxhCRy1vQG++6FKx+14nvpvmqN2/PipU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785956249; c=relaxed/simple;
	bh=zb/qqzOH4UER+8itVurxDycpoYHV0K0caGuxDS0T8cc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C78b4g/igTCxVADZ/bLWffjTpkzKR5vmXwu/eeKis7t1jXrUgWkoYyEPCw7ZOv4e3K+LhX8dzdeGvUTPGeE1mS+GthPnVvRJpx4lbAySWaEhiPAIO4b3jFJpSx2UiIT0zNqPzctga4quUBZY4q3UfB4wkRUrZxuIMgHosR+sYv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=RbJT0yMo; arc=fail smtp.client-ip=40.107.200.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="RbJT0yMo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajBr05a51CkpMKRBlvnRQW5NBHzCl9uY80ZM5YD5if0HG7PRdHAta5MZsVFTyyQ13liAEzgSQOnMzCxzo/6QkkvtqiXJo6Wt6kCKi6I55aEjoC4XqyAbF++f2bZeHmU5XufvJYRqtkxVLzN7ltqBDyx7j7L+GEkFrfdwcDj8NUIdoI32Ox/kQpGBNK0YbVxL/cJT4I4L8db5WdAqRjiNWo2Ft8yIh/q40XljZ1W5idumlrvGstfmFOKckob5EL4GYivOzgDkC5E5aSuZVoaupo9K5WhIBHta6ROPN869BspOj4GphWERR3y/SoiH6RE5WypySKs6o7IiwUGN9DBhew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akQlkY5tAVwmFECRX/GSGWgGZE7Bka5rrgSKcQTRWJA=;
 b=G9hrDjxaPVy3bGF5FUnA68AWaAzZvyjzmHiPTqHI58apGoUFn1ArXLXpwHum2khty7Ue0sV6Zj53Ui5A/Tr1iPYOcIKIk9fHad0s7HeCuoWj84rQr3Rtl8eeN4vQuOG+YLGKz7fcrZ4gp84V4SjiqjtUIKawf2sewzDXcS/h20VBbxrTlubzamZir2aXYLQehZLaeWIEQrw83Dor4DkkNqR7/+k2XaY3UH9CnQlliDy+yioOXzZQ50fiCHf40USaKbKeiZbw9OxII3mgosE8d9dx2rk0QhFSreJoiHEvKgKUK/jOM0fvoXyQ0b4jMyfPtBO/NfHkIRo4x5PP8FuqnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akQlkY5tAVwmFECRX/GSGWgGZE7Bka5rrgSKcQTRWJA=;
 b=RbJT0yMo/WJAGEVzX90ZARtG7MJo6jjLEQMCm+ROi7pH//WuBasHpwQF0ihP/D/LfFrAKdh+sO624vPND14Vnb/1IbK+CrhlVj3atem2JM1V4ze0n85AIFwKryY20Goz6J9aCEHfVQiGYjX2bro4H5D7MPgwKfPvKNCgLhBhiGk=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV9PR21MB4997.namprd21.prod.outlook.com (2603:10b6:408:2f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.5; Wed, 5 Aug 2026
 18:57:21 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%6]) with mapi id 15.21.0315.001; Wed, 5 Aug 2026
 18:57:21 +0000
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
Subject: RE: [PATCH net-next v2] net: mana: Extend RX CQE coalescing up to 8
 packets
Thread-Topic: [PATCH net-next v2] net: mana: Extend RX CQE coalescing up to 8
 packets
Thread-Index: AQHdITLarjnyHDTDWEaw7yPPrfhHaraP1c/g
Date: Wed, 5 Aug 2026 18:57:21 +0000
Message-ID:
 <LV5PR21MB4704A42FB91A2F30C4AADE3CCAD32@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>
In-Reply-To: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e0ed9e35-8d66-4a63-9f9a-232c14bb00ad;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-05T18:56:21Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV9PR21MB4997:EE_
x-ms-office365-filtering-correlation-id: 90564ad0-9e38-4e83-e0dd-08def3236155
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|22082099003|18002099003|7053199004|56012099006|11063799006|38070700021|10067099003|7146999003|921020;
x-microsoft-antispam-message-info:
 CmpcJ4C9YqZo6tgoYJNn04ZtYB5fKfDVXdKC+/+/bNHO0IiOBc9fctFBtdk27htSCbAFz2S7+/bC1jHteddeRUy6BtA6lZjYopn0tTEzybinM1Lyf3PrG1argCQgwWIe3cy3d+PURqRe2mr+2UrDf6xjehGYMjELKR3MOR3J04OdcrHr4KM0UtgCKYpKY4SB0NEUKH/mkCYh1pdsAfuDfMT2L37hZGbS4F8BvPQqKxDH0s8WAwV2XCi6B90milesZ8+WBpgRUsZfKZS6cX+5ExMoZyn53xk8qxgV27DpKW6OGdHxlQgxQ2iraqaecwK8oUKQG9D27i60hpX2rW1YBPmhhL1CKf9G7dfABeKqvBAwac8s1yswSzhQtGsVvh4+CxFqTYlD/dQ3wPGDoysJuMdJ7nXCZKTV9j9Qm/TUR6Rbf+2Mp5QFneSPeSSVR3qUg933g+n0kfLOTZsCsTE9Vb7uykVyuN4Ndby1cupQnO02KMlFxlYCYVofj6762KuZlgO1EkIuhGkb7WE1xHkZ6IChhdJHW4j5rjrYuyxayOS/I57ZR8LObtBidcd0UkreYLgqJN4YyL5eZ2CblvEd7lIVoW2A9EoljLne3XBwtpwquHOwaR1xczTBd8YVPIfPlna/uQXn3dtXiIfEFGOdeID0m7tA9rkp+w6khfYpnd/ksj56oKFz7d/JqyvGRN9w9A9AOL0FA8FS/2h2urXinA558eefxhZBvCRkrX05E2g4JZrzum/XC0Jxw4RATolh
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(22082099003)(18002099003)(7053199004)(56012099006)(11063799006)(38070700021)(10067099003)(7146999003)(921020);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?eMrrpiAsoC3qffpbkcB6wPlKuezsasXxE+e+HGwWKLc1HRAeVixTav5CVDym?=
 =?us-ascii?Q?VGTA66nfReJO3EW9+AtR1yWjAKz52Gvd07jJNZB7dzWu3vJIbZF1ieAd1/kN?=
 =?us-ascii?Q?KeUqApNX5oE71jyJMOwkCpMwI3R+P3SdP+aixzkgq9YuutHGxJJDfXbDyA8j?=
 =?us-ascii?Q?ob7uTMsIm+CHC/RpAPxpn0/l5kh2i5G+/jXRouxSmvTwsq6mPXle8P3eLTK4?=
 =?us-ascii?Q?SWjf9+r2u35Dmn/9XgM3fxsZFs8kovlItE6R/eVvhiXc5HwhRjeZMTx8Ss7d?=
 =?us-ascii?Q?22EwRqpDIx01Zc+iS2xS6bGw6bY4kL1pbrnY7TGNvry/E5QgGQj8PZcmc4Ui?=
 =?us-ascii?Q?4TO8aRKiTANhkaRs+EY2U8oQhVTHuf4Qgu+ZkCfTPiNJGFTlog0AveLpBGil?=
 =?us-ascii?Q?4eaBnAB/VcFYgnSIScOQKB8P7XIXdMW/UigHp/xDju5UtbWx5bxfvRhIvayW?=
 =?us-ascii?Q?MkXGgt6EzjcQEft84t0XDKz67XS7gCow3x/cUz6R2Tk2W+DQET/zBT9NKH0v?=
 =?us-ascii?Q?34tD+J8lNEaeWhMHh6lG5xOQCgCSn5tRn56kEVi839dnl9lUSY4sZnmvEOQL?=
 =?us-ascii?Q?eqfOl9VLBlhIfbwkLq8m78RARblB9uSsGoQ+4LBINtkW27MwMw29TiEI/9Cn?=
 =?us-ascii?Q?oVLzBT4VJFg1lPbMvcNhrJQAcq0le4fbVZQVbdw+qDFMZHQNTHhMmXux1uK4?=
 =?us-ascii?Q?M52Yz0J0CtRjZ6mGs4x0oDo0gDiZ9+5MH8jkfcoVJ+40RsrtNqnNaFAmeg5N?=
 =?us-ascii?Q?35x9ffSo/I1BwBB0fN9FabT4018Cq5Ep5jiiIPL8Q4sRp+5+fNZMaWekc/5v?=
 =?us-ascii?Q?JxPPZhjX5oBMKBOax3hBlzaLtUd9oFCCo7R1q6RdIN2XAKS7QOKtg3ry/NzA?=
 =?us-ascii?Q?uBvgA4sklmrybG5jxoxPow0Rou4ktwB7EkWk6T26KtRkh/gZ8s/g+zLNNZaI?=
 =?us-ascii?Q?+o2/TAMTlSE59cAJSnjRLa2mMwrZ7xaJ9S4M2Ze4+VsvT4qugCQISkJxf7hB?=
 =?us-ascii?Q?pbH221ukYI56LuZnffNsint4m4fVewH1qzn+mPsbN46T2hY4DFWdmJ76ibWV?=
 =?us-ascii?Q?44NwbQ5QZPJB3wzgpVuycKg6JZPbVYjd5Fi3NzhTUbyzTYQDNBhPBXWVtNUy?=
 =?us-ascii?Q?8fdIIpF6gxPIN1whrquoo4lCKyHxiXXWp2RjKlSnXPXr+Y7kvZ+YBC92hPFd?=
 =?us-ascii?Q?KWLTqDirLYbU/gA0TyySRcCyI9Xi0AwAm1P4ON6FxWLTopQA+XEASPVB9OOD?=
 =?us-ascii?Q?U+Ux0ajjDYGmO4BU2imqoB+DAZjyPBduAiQAgYcOKzxRep/1fPOH3OMOvaHz?=
 =?us-ascii?Q?pmsWi9WSAFrXgJZlLfbu4Rc9bLl34wbLh96TUskhKx1jgbl98yxlcok4lOLG?=
 =?us-ascii?Q?n3F8H4vkiMTt+6lc1NBrAKpQ9gDO+sQn5wdoH8/mS6JCLx/IMUcucMuYmtck?=
 =?us-ascii?Q?Tqq3pe3F64q61WW8IUL063AeCPP/tYF+UZzGCk+rwn5q4aHMThs/GuBB0LCS?=
 =?us-ascii?Q?Vnja3C6MdT88YX/RXMsR9yZ25W/KwR7lznDBJGittGeKDzq90wEiO6mpibyq?=
 =?us-ascii?Q?apqfa7Zxrt8m8ptxJsEUlXMAvyxMA1tLJhV8Hp0UVtDmIH3CjdCC02uhIQzR?=
 =?us-ascii?Q?HCJlJdSEglJfjWLPoPbUEYU3kcmmiFAjVHQOLD2dmDr8RyqYP9ZeqL9vtm2k?=
 =?us-ascii?Q?RMlbEouK9+uiHOpYQOueOWhRPP0VZ4kggl6OpEksTcZnFmNywGtlhTM2E0VU?=
 =?us-ascii?Q?Xysmtip0iQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 90564ad0-9e38-4e83-e0dd-08def3236155
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 18:57:21.5277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3EBQRoRtAKVg77X/RU/whUP6jQNdtasttADc8JbXn3AvrTMqLTUYE/hxmZDudK0tWEsd7qN5yvYDd7HC8td/2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR21MB4997



> -----Original Message-----
> From: Haiyang Zhang <haiyangz@linux.microsoft.com>
> Sent: Friday, July 31, 2026 5:23 PM
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
> Subject: [PATCH net-next v2] net: mana: Extend RX CQE coalescing up to 8
> packets
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> To support up to 8 packets per CQE, update related CQE processing
> code and structures.
> Update ethtool handlers to set this feature.
> Update per queue stat to show the coalesced CQE counters.
> This feature is supported on NIC hardware showing the relevant
> PF flag.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> v2:
>   Updated PF flag hanlding, and comments based on AI review.
>=20
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 137 ++++++++++++------
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  29 +++-
>  include/net/mana/gdma.h                       |   4 +
>  include/net/mana/mana.h                       |  44 ++++--
>  4 files changed, 150 insertions(+), 64 deletions(-)
>=20

Sent out v3 based on the latest net-next.
- Haiyang
