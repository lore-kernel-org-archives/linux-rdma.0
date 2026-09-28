Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021136.outbound.protection.outlook.com [40.107.208.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8D73ACEFF;
	Mon, 28 Sep 2026 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623101; cv=fail; b=W3khL8raDPn5Qn/pLDngeWwNZPfDT4r6AoFqk3Gje94vByUSFsgKElEAopU3CbMElr0bmI8qegOGlzCdD3/gNV65cLLvNOCKxnsDW//CJYuV11ZYidOS1/llOYxyyWF1UgSoPNTlXLQcEPk3ff/cAlN4JFAW3CgfQ27zUF7mFoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623101; c=relaxed/simple;
	bh=HV4B5bE2unEqmGuZ8EsjC7Sn9W7TUTIOZeGCfv6vnJ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qGZkUx86GPNyPzV01UeUUrK0RMDyQpgKRAAwrjSL645i0xx1BXlldhMj89QnsN3ngN5TcIo0lWfy+53Krio1W17p2RK3Na5PDgHuAN3YhohU6a2QS0hDg3ljJeDBQSn56/T5dUuHgNbR2GdE51j69MByCRc8qfWgdN+amn1VVBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=CZB6fKJZ; arc=fail smtp.client-ip=40.107.208.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="CZB6fKJZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPcurkWqRsCwYhMRiIgTkt5kG27pfcDn8vHFtwsP0rTOwfEhbCotukfM3SGWOtrTkoFnUrJWMECn5P+GKnvC7A9mW9QJfRFSBY+f0yEJ2eSdGKELLKAb+f68HJiOxftciHw7kaLPVlpDXqGO09nCoycOpJcHiwq3tPMsl0xje5h0yFPzejGLkTu/dw8x1zwJ7dagbAo6wU87Y2Emos9dtK0Uyv5wHgB0i6zK7qt16Jklnj/yftFD4R1YYS2OvjiD7hv5eFkTgg7JI57aepnP6+3USjSpexOB7UlxhAicQ3iGh8XQqMSi/oZJOe+3+VSDw+gODfdkTf5dLWBmtdHG3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV4B5bE2unEqmGuZ8EsjC7Sn9W7TUTIOZeGCfv6vnJ4=;
 b=JLSbN8MQfsea+wC3pn9MoljhPl0r80WHEcE8CNgk++PLfcyt3fyAOGzIUtu/cuv/q34Ra5HL3la1DfhPhAJ8mnx6jNLmSH3hl9ULBzNYtNKFpeOPTYyo+Z6fRt1xz7oyGz0UYvmI31He9dvcRv/g1lp7PtX9cDEwCKh0ri19PheS18SaGrOZUrGEsPGvkR3rORBjR2s7OdmYO9Qpafcj4/NfTGV5efipF+ZjtNDcAKxzsa3QARPcfs7QQ7DHxMNodoBUIiAbRJeMGiOT10f4NbanEni77LHnzQc2n0bzenh5jnmtQQt6qjq0seMH5dZ3By9HsBETYczbpsZjqbTdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV4B5bE2unEqmGuZ8EsjC7Sn9W7TUTIOZeGCfv6vnJ4=;
 b=CZB6fKJZS7ekMaqqvF8+V8wi0y9ySO1FvMExFP+fu5rYbh+6LWPqsi3O0Q7GNHH9n/IhcYhGZ9hggaplpcvX0L+GTr0tlbFIaxto3Dj0M2xEoVIbShTxYPDZDfonc0PiGGxczI4v00p5GUFR5o3h3d3yrldyJnr+BrDTFupyYqc=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV2PR21MB3135.namprd21.prod.outlook.com (2603:10b6:408:176::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.7; Mon, 28 Sep
 2026 19:18:15 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%4]) with mapi id 15.21.0496.006; Mon, 28 Sep 2026
 19:18:15 +0000
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
Subject: RE: [PATCH net-next 3/4] net: mana: Build the PCI transport as a
 separate module
Thread-Topic: [PATCH net-next 3/4] net: mana: Build the PCI transport as a
 separate module
Thread-Index: AQHdTEsFT0mK6TF2hkC25pu4/t3aRLbkY5Ng
Date: Mon, 28 Sep 2026 19:18:15 +0000
Message-ID:
 <LV5PR21MB47047EF3281B49557EBC0EF8CA8D2@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-4-mawasthi@linux.microsoft.com>
In-Reply-To: <20260924173054.589291-4-mawasthi@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=15402b3c-d8ff-4a2c-b78a-9cd33244f147;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-28T19:18:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV2PR21MB3135:EE_
x-ms-office365-filtering-correlation-id: 220c6ebd-13b0-4254-5b3e-08df1d953f3a
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|38070700021|921020|7146999003|10067099003|56012099006|11063799006|4143699003|7053199004|22082099003|18002099003;
x-microsoft-antispam-message-info:
 CQjdxRBnV/KTmXBCEEDteSG9x+rtCt9gbXCYwJef8N6n0JK/8SnGbDNSEK/PJc8eKI4WsUeUFWuc4mgzHUT8/A1QFR5JZCeLrPrZQnksNFc1RyDXP/w9UI2dYZ8egfPgzyZ8YWisDLM7JG2Pd06zIv/ryGNsidIeXCy1OKXhE769HKpHyUeln5b5vJQtZX4Jiln2eJZzFmMn9Q/ML7s1DL1LBfmgftYe/phU0EETXRsVhRxRjgBKHf4MoQrGpbvQmb8f+uMpAoY7p8qNkmqs9nC0ZZU2E7q5tMcHPzsbcgG34esEqap9vUCIq02Z+Yw3AcD1IT+fNthH267YjZawpnYaxRF3ym3o2KYOuk59/qmRFTRynaUSxx6v7ahbZmNMyqluJYIJpMoo2uIp9Fi61ZEDUPaCFp7Qd2yrTtVdpzdxbk/wdPIgAi+o4N3f/aSqA8nBx3plbauH0/X5n/ZKPZK3lIkvFJd7E0aqB0pCgaiyj6ODR4xzCLXs2iPIObmCnf/nBbolY7Vvv4JCLp3RpVadzKI/yHf+5yQ54allIbIZ4KhUAfMUFtXC+YmSoygv/fAPX8OnZTl2AzVm23fhuujJeUZgvUneRZT4VEsG3wN+WKdPwyjOhO8WCP0fkU5IlhRe+Oo+wldIO6neBZ6UvWHdpjkYEtGSGnfiefWmne76a6K8ecyD3qI9pthice2A
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(38070700021)(921020)(7146999003)(10067099003)(56012099006)(11063799006)(4143699003)(7053199004)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?6/SRx4km3t8WaBvc0mlLl+XX2+3WOsaEa6cbHkpY8j09Jsl6vbo1B+Qqgf4q?=
 =?us-ascii?Q?v1AQPZC3eFuwyGUer2SVYtmJl2T/tR0H2jmlrG0INvLpipdQIJ+6+DFXLGQu?=
 =?us-ascii?Q?6fTIGh1rKRDEbBUShZw4qV9GnTP2GnDbSd7zWPtMasO/WB6MH9OgLWgKzuso?=
 =?us-ascii?Q?te7Vrfq92FnhoXgNk1agvoDtX3Ypci7He2MHr1jatmmK8NrRO3If2P79wnv7?=
 =?us-ascii?Q?B2wGTcEUcTxYH6eOQB8YAscripYpxWdiWYoK9oshjqj0ZHAfwdqnT9PR8wAC?=
 =?us-ascii?Q?F+H/lToMRNzk/24VXIgtvtlj3eevlOSV/KR4FD8+BqGexUV8p5izXVH8hb35?=
 =?us-ascii?Q?rZ6q18yqszyObBdFfI1LAq5VSakiyoimtlI4/U0idoq0y4qCOd5bW4OGFgQW?=
 =?us-ascii?Q?swGhCJiAAupbwptEOMkeQcKUkv4nJqtax17w4TbQuHD+6OnvMZrO9LjbBvVf?=
 =?us-ascii?Q?BoSR5Xp/TtGjD+uB+4Va388kk9/8DD/7TkotGI7lwBbwLY2e+w5Bhx1Ppdz/?=
 =?us-ascii?Q?/ov9IiqEicPnA791LmFXyDQRGXPD/5lAXPHM/OpZEthwOA/omCvQ9aa74QSE?=
 =?us-ascii?Q?uddTity6Jl0lTgE2jamRCKXIEs/PZ/WCdctKrh0/KnvWPSXKA5AVxEc/k2/T?=
 =?us-ascii?Q?h7z/2BKcrLubARstxr2prObPf7XDYgiJZSMR3rirOmX66hC14CPTYvIzYoCt?=
 =?us-ascii?Q?3r3wPXpFRHUeFVxVQZs7bzNrn7ydi922mtJPc89oofqEsJVyuIjYmhrnzMZm?=
 =?us-ascii?Q?b4Y2vOnYCknCKEgpbbh3k6c5+PjfpqDJBP2G8doFp4Sw5q2UW4axrYNM50yn?=
 =?us-ascii?Q?QzuFJ4IZ5KTeo2LR4khfQV3o3nsHy5ImAZVVlK/fxBpnU/yTR4Y6/gT2PvXe?=
 =?us-ascii?Q?QmcGiodOVg7jODKjIOEjhtleQfS3RFg9ImXMXp3vnrDoFJyfSC3dnXmeV5AN?=
 =?us-ascii?Q?f11WQ1qi0VbEgOsRD8kvciD+e8HHvUhdN3avPUPSXjf/aUbOj1+1esYKqOjR?=
 =?us-ascii?Q?Ormd52ZQ+G1oMQ29o3UrrWq1/TVRgo2m/cVAUkLtmqxYUZdz8Bm1vLPPfciZ?=
 =?us-ascii?Q?R9S77bUsUFsMehWX7owUslrPLXKn8SGspUYGci9Sn6dTCLuYt0171sc9M4x1?=
 =?us-ascii?Q?9oYNLLtNsy8gDDxuvkycshpWfn6s7gqvKq0JIf0N9n5KJaYE19dvNNkWK49I?=
 =?us-ascii?Q?Kfsg7gqbzuBE9Cptu/k3N0Vw2cb1MVakCJOhiRFSXSYqxgf51tMIPhg268Wq?=
 =?us-ascii?Q?U515YPhPpqSz0BmXB+dnExGqym/taT3IrjHmmQ8rwS0UU5ch2gKZBYS523LB?=
 =?us-ascii?Q?QlCo2Mu4Dyr2fEYgJPoGwOlQR8kV/bFqUuX+1HqA55odE8ipig8B1+85nO4s?=
 =?us-ascii?Q?g0Jo2A79/LqP3wN8SUQsEW8Hkbb7QsSf6KHWASeQyY5R63P3Hj+vD+P4kFfj?=
 =?us-ascii?Q?9nd1WjRrFHktlM8iJ0GK9rSS4W80kLVhxc4/Fjixy8/T6R7J7vuBTdLUS/+q?=
 =?us-ascii?Q?MAMXMUszDX0rC7RYkjEeJ77ELM+57VvEbxNQKgmo6vpsbq9OojFVsiOHIGRK?=
 =?us-ascii?Q?yi948bPZ4cRTO2+/nD2bUa9cFYHgO9c8gWakcPfl+lbIxD9EtT+jmnVKZP3o?=
 =?us-ascii?Q?0Qs2oHLHL8tMRoK0wbMJRigf+vOpFwUY6tlEMX3Nkboy2hWWGo03pJU6XQGb?=
 =?us-ascii?Q?aE+dwVxw0peiowEa27uZhRAxt4D74IK/2QPZowtJV6KtKPtOAxpxM1UxfOj1?=
 =?us-ascii?Q?i4sUWRHT/Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 220c6ebd-13b0-4254-5b3e-08df1d953f3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 19:18:15.7433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8VltuamPEEV8kX54BFYjuUqkf2ZxXI+soPg17AWdQ0w+eETBL/bvurMEtTcsldmPlZIwcxXTIHkYK7rjXvi7vA==
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
> Subject: [PATCH net-next 3/4] net: mana: Build the PCI transport as a
> separate module
>=20
> Build the shared GDMA and Ethernet code as gdma_core.ko, selected by
> MICROSOFT_GDMA_CORE. Build the PCI transport separately as mana.ko and
> export the required core symbols.
>=20
> Preserve the PCI module name, device table, and mana.eth/mana.rdma
> auxiliary-device names. Each transport registers its own bus driver.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

