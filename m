Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021123.outbound.protection.outlook.com [52.101.52.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FE93B388C;
	Mon, 28 Sep 2026 19:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623077; cv=fail; b=Q8AntLGU3RDOs/heeR++yBSK1Vfrb2/k8TzXDb7MhJ7MUTXvIxn7XBjnXdrtLUxASNZ17Bcup/3rTU8jj2kuXIGywfZGYkJX53s7vEPxkxipceP9VfUKUm0gymXS+yt6tRqjHH3JUZNEMdq8MaMkwCYvZQbuEnpwU4rJmUe9nrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623077; c=relaxed/simple;
	bh=4Z82PNfQObyGaqHLihDP6MNkiS+N+M2VXaic6G+O/hs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lc1KfQqatrOItiQdCCPjRYYx6G69Ht3CiOX+SlCvqaNqCTu3zGqHZ34wXZGQUp/P/TaKCwzAhT3se7eBU6r6doG3O5++uskv1deECV2cZd3VnIcWhxRwbUJkcIjIirS+xnRu/Lfpu1ppativhcQw7UU7gOoavQmJKOzAPlsD9O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=fpOQ1+wO; arc=fail smtp.client-ip=52.101.52.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="fpOQ1+wO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F46crfSiOPNmQR69qWfNerNePIavqGPaLaYIlFtnj1tw0MF+WUrxUNaKuZ7cfNwxkwb1hVIa0x6aZqn+zoF6CEHlHpca9/JIbNq4a508Q0B8RGJk8VKlRlBhP/IxtT/hEOG7lUtkUUwuOkux4wTEaqWbh8C2AaCsZJmeCMNyHYNy9cFexco71a4J/6dctzPjjKaj8n8kcA8mQiRO8rtpXEcwvV8xEIcTiYqcwEhmjJK8+FhrC6wFfC53nkb2SKJlZrnkLvLJInjFihM2mxiUrODUcEBeaLFwDlzL3e5aUXDJkdKe98DdaM5S0EagCC6v7kkc3brTV1ctJ/7kVOfZFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Z82PNfQObyGaqHLihDP6MNkiS+N+M2VXaic6G+O/hs=;
 b=ixVxhHt632mKElZ3vpFKYVHP/NPBlxSuGEZac1EyVEtQsjJDwcw0nZk/Mq7hAd3brLnOZ3wqhRRmPuo4qj0L3Q7T1FrLRUbQpb+bQL7ofEhCNn/GauUvWHm/Xx9Y392xDH9J+q6rF+9VG+ACDzbO2mzSYA/X9Bc+AZ7ewli79mj84BkYUxNRcfW5vFBciXrkqYDDjMKowK8LvqaTfkEAEwyHJGY5AKau2DL+JRa/gtH9tse8YhPsf/dXc9hcEKjzHZGjltOqel2zFkCL2xzPUpGv7SCSoSjP4nBgZnbIuMUXF8J+nKSiY/mfpYxH9jatsU8p0NzUA165lJGwB2SZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Z82PNfQObyGaqHLihDP6MNkiS+N+M2VXaic6G+O/hs=;
 b=fpOQ1+wOQh3Yg1F4PZQMcmrYSpUflxk8Xbwtom8Wm8oUgh4++ij2KTRKqxbZXY2SIz6X5hfrKp5SbOwELP8/7JanM5OPwFerbDs3nvNiIsHViGlEsfmaNn/i+vSov2rqQaJpiVptsXogi5F1hECwNPesN1Fe/zgl+uDGVDf1/94=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV2PR21MB3135.namprd21.prod.outlook.com (2603:10b6:408:176::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.7; Mon, 28 Sep
 2026 19:17:52 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%4]) with mapi id 15.21.0496.006; Mon, 28 Sep 2026
 19:17:52 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Manish Awasthi <mawasthi@linux.microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, "longli@microsoft.com" <longli@microsoft.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>
CC: "horms@kernel.org" <horms@kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Gupta, Nipun" <nipun.gupta@amd.com>, "nikhil.agarwal@amd.com"
	<nikhil.agarwal@amd.com>, "gargaditya@linux.microsoft.com"
	<gargaditya@linux.microsoft.com>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "kees@kernel.org" <kees@kernel.org>, Paul
 Rosswurm <paulros@microsoft.com>, Manish Awasthi <mawasthi@microsoft.com>
Subject: RE: [PATCH net-next 2/4] net: mana: Move PCI transport code into
 gdma_pci.c
Thread-Topic: [PATCH net-next 2/4] net: mana: Move PCI transport code into
 gdma_pci.c
Thread-Index: AQHdTEqRhG7NX3bhZ0u1+8sGlBrwp7bkY3BA
Date: Mon, 28 Sep 2026 19:17:52 +0000
Message-ID:
 <LV5PR21MB470496110DDEED3385F99183CA8D2@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-3-mawasthi@linux.microsoft.com>
In-Reply-To: <20260924173054.589291-3-mawasthi@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=71428816-f127-44a1-be87-9c4da2ea392c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-28T19:17:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV2PR21MB3135:EE_
x-ms-office365-filtering-correlation-id: 4b1f9af9-938d-4895-e9a4-08df1d953163
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|38070700021|921020|7146999003|10067099003|56012099006|11063799006|4143699003|7053199004|22082099003|18002099003;
x-microsoft-antispam-message-info:
 i9CYDzOlUy8cSftcnmMIahSlqbVAGEH6rinOajwgKKbr52Be0NlIEYgv8XTi2MvergXL1+gvezSMdQxgIf3uqzBaJS7rEWhsosU/KmCvfOOkRLo5rbHn+rR8itOcJL6e1hqY7tjoupjF+2IkR9uoJaJNFz9T03UTjeOw5++La30AiDWNc27oSgcN1uLYonZ2CNEWSDuXuIOeEesbfmF1XliEqcJ2zO6THz6G5zYyClh4JQ5IZYL1Yi5yKXqU6vcNBESdu/AniUuPHYX3EF6M3RWe4Zngx3/JqJhNqA8hYIEaR8pbqv1Ex45Xwa/lvsE5K06Sx9YyabvfCFAggkKEtQv7TWhoWQ2o6IxvK9aO6Sltxyx9QfMKPOGmfn+rFyF2OQsZRApBzP1ONv9xjq5q/0SATjwSd43sJi100XBj/DXrhp9eFr/RNfPZIGH4r6A9mWPugHIzWNvjKkcpoQnGJ8l1ZGeH8IcIfvFf/q8P91neP3nlcw5bezaj0Rp3SPWOapKDWMkkYdX5sZvPKUbOhbToQHWgIRHshwLh+phs1jRr4Fij05mJqnja11WlCCpy+N2WJLFtJ+LPxpFp+ey9k/zCID2a91ELtcI6AfdNepwKeUkrGQ5DDL6JIouoxcRjpAr/VuuaScoAb9+O6f2smOCLB+5v+x1Nrw1S+/3Asy7uFJ8FyFrlNSX3mCOqrWX0s87HnqOSusA6zP+XAK8UMB6j2rUyfM4z0vtfxGHVRPahzaCmSSi32a2tCoyfLFUT
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(38070700021)(921020)(7146999003)(10067099003)(56012099006)(11063799006)(4143699003)(7053199004)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XnzYy5Ertrem3ktCBnPNrbviMV0c94M80ft635vWmDOxraoEjYR8Vnttam9N?=
 =?us-ascii?Q?o94haoIsOx4DhPe1gTdPdlG6UajRx8hLUIdd+pBDpojD148nT4SkIf4rxYEQ?=
 =?us-ascii?Q?qOymCyfjuyxrhxbTQMHSi1AOsBWAvbCXtYcLrm8MarW11Os/Dbjqp9GdUbvp?=
 =?us-ascii?Q?6xKTiKgZ/wtfzZfQxuFcy1tv+tUNZcoyzXpj2t9fEZORkEX10EfyELCMkVC9?=
 =?us-ascii?Q?0P3KrZkjDy7p0NHxdilBhReJzWum2p6quDgO05E7ctV+wt2yTiIofeWEeMb5?=
 =?us-ascii?Q?8CAmogVsT1Oeqe+ofFSP7iO3drkKI7B29ihB0zXFT4CWzf0DdI7p6xSEuqZV?=
 =?us-ascii?Q?rvCIrehy9O1WPVnMFbptw6BjMCBjxGiN6SZ6xhqvRkCcat0S/D5DTRER3OPW?=
 =?us-ascii?Q?N/1iId2+lhRBsNjvcvY5TFR5wdOsl/UJApl+K8H/vPP6s2UFBMYhud7CUZgb?=
 =?us-ascii?Q?bOCS74t0mf1vlYE6zs9oScSRdzkig9H/QxUecdWBN+aUpIgzxjvCowv64KCU?=
 =?us-ascii?Q?EYROm7sKzGN/uBuKoZS/B3JZzQjVsKiHJMQG2hMruyWY9IGXRbuvKMBq42tV?=
 =?us-ascii?Q?cNqpf+5zIlUZltWvtV6UyWZS0NS+9vOXzkBOxDNkIpdrgOOjX5FopdK/9NLK?=
 =?us-ascii?Q?EpIstKHSKEth9Hw1zQtAWUypvi3AsFu289e3XzCeQSiUBuxl5V58HDWVedTS?=
 =?us-ascii?Q?b9O6CP77QbhFzjXyTY0I+gHWnSMN2NCBvIsWRvj690vnx7tYXgTdqot21750?=
 =?us-ascii?Q?H95kceI+Ae/aKHgnyktNoJa6MCZeLnKm3NMPpbDbPAy8fpXgyZlRycOj9dBh?=
 =?us-ascii?Q?dZnzJRvDaCVFLzAY2MpmhvmX2JiQYGTqo/0Z1wXAlZrE1HoQZ2HNuwzkGMXv?=
 =?us-ascii?Q?CUJinXDMn2XPFeobG4pJSu+PrGS2AZkpc3NCRr04xEE844dIyW+bYv1oEV+j?=
 =?us-ascii?Q?7QmPiKUSYnlPyqW3sgKkH7af+uByR2hE45FmiAQqQxdL44nc6f97044AiHAm?=
 =?us-ascii?Q?LdSmRfnN6dxAfwHqCHW/OPCL/H2BuX9e/8yPd9PTliLJfwFgFAoAZa1ynQ4K?=
 =?us-ascii?Q?UahtFuCrzCKa7M2uotPtTSCcBo7LUziN9Wl8Jj60bBBzsoLgmBC6srPqo0AU?=
 =?us-ascii?Q?6daRhtTt2i3EknjarEePpKCj8dMYqLtcTa91ujsSuBnSaqjZAv6uuIQEZp25?=
 =?us-ascii?Q?RLlUuiYNyATGRGhzfWwPYs9zgzjRvASBCVO+y86ymgPBKJss1Wawnxvrm4Eu?=
 =?us-ascii?Q?qv2cpIjK997xFDsBBuiY0o8nYKpPHttYZcpt1i2V2pe2F8mTb1SmvizsijW6?=
 =?us-ascii?Q?q9T0Ivv7ICV1qNvRk4PpFNBLKixRTPG350esTJTqDWJ0mczFPvXp2QAK6Ie3?=
 =?us-ascii?Q?LXOtiCTsNaK5rJq3qpj7H9c7L2auo+0cOjVOgXBXw68MNKXU4qYclHw7uPiP?=
 =?us-ascii?Q?xGYo4SUagldCeL7UA1Jb5/gUWtVEFhjyCgyfY4yNswnj21Bu22l3mJzTJSLu?=
 =?us-ascii?Q?UtYCoVAALATkou+Cj28anhWciF5wEkBKkAGxuESucbYG0OYsAY/gbMSevDCB?=
 =?us-ascii?Q?/Uk8DpTi4LY1Z9L3PU9TJJo7+XWUhLbOuKBmqOWezbID47g0vRCuuCRXKlFC?=
 =?us-ascii?Q?NcQ/GIUsYlScf4QDDpVZC2xpGCTDlUR1d2cVKO9hoPRf6ALDPdW7tUaEZ/JG?=
 =?us-ascii?Q?IkYjt7s9NoqNx2z7b9t/0ERxkwYGm+859mvnyAPz1BYrOVy8xGsT5F8xPSYl?=
 =?us-ascii?Q?+iKhY40Z3Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1f9af9-938d-4895-e9a4-08df1d953163
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 19:17:52.5820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qZNx1Kn2/vFhMIhwCLo6Em1MpilyqQLv0BJAkamZn1yB+AzSsVAy3WHDHAAAgL07yBwm/xi13kF5pP4Xk8loA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3135



> -----Original Message-----
> From: Manish Awasthi <mawasthi@linux.microsoft.com>
> Sent: Thursday, September 24, 2026 1:31 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <DECUI@microsoft.com>; longli@microsoft.com; andrew+netdev@lunn.ch;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; Konstantin Taranov <kotaranov@microsoft.com>
> Cc: horms@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; bpf@vger.kernel.org; Gupta, Nipun
> <nipun.gupta@amd.com>; nikhil.agarwal@amd.com;
> gargaditya@linux.microsoft.com; ernis@linux.microsoft.com;
> kees@kernel.org; Paul Rosswurm <paulros@microsoft.com>; Manish Awasthi
> <mawasthi@microsoft.com>
> Subject: [PATCH net-next 2/4] net: mana: Move PCI transport code into
> gdma_pci.c
>=20
> Move PCI transport code and driver callbacks from gdma_main.c into
> gdma_pci.c. Keep shared IRQ bookkeeping in the core and update build
> wiring.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

