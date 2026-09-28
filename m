Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020122.outbound.protection.outlook.com [52.101.85.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9C139D6EF;
	Mon, 28 Sep 2026 19:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623129; cv=fail; b=uig+12QA5jLHdyh7IL/+764UeSzM6MEU7n755K/bnJdNw1N4GK2XnjWQw+kwu0s5DikOI8uZIp8pzCdZiNSVn72i+xidd69nhA0yhTbhVjhkeSehNxQ+gDWWPPrQvwFTKx/z0MW3EFG+4vo885+k9x6ON4q/6HJ8tUZ6CxtrwAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623129; c=relaxed/simple;
	bh=e5WUGPif0xuNw2TMult9KJw75wpfyISZC310ZdXk+qo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=unUobKmDGqGJyxhMJOjWMR4qfLCnzgkrVdm3hk0NJIZzRH6Vcky+RxliBdXhbjD8tEdlyjBLE3aJMKzjmkZysPA9rmpYGjg/eBEstCABvT6tmmKvNfYkJPa9dWURyzaX/WlrvyKGe6rMLdb4LcU9Cqe+JkQMt5xnZHoX7Fy6bDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=i9cRo6GA; arc=fail smtp.client-ip=52.101.85.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="i9cRo6GA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lcw8rgUVAtsP+LJUJ/9GlEYPV1HPkJ7dJVaoq83VA1itNWUZOVtEN2xRWtalWKzpPHigMZjOXKfkhfB4tbmBAnypc1+6EL3fSqmGDs8rfeml4ge79JwyJ8uWZkpnZ4sJItoFxFSxdJdRW4j4OF4PEbRG65ay/jRuoKyKbL1hHTZp6iTwfIeIIoYbqit0vFjw9DYrm3oE8Hs3pa/EMZRuo9qKz+ok68dfN1Io0a/HZJx6ax4fmGYnHrw/c05foDX3/kGAL+Wx2bO3QVs9Txxxs/D8RoIyiHzXnr450WWRRNfvl7Aux3YA9eT4f7T3eHgfwcpuLDMoxvYXTjz8r0dm4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5WUGPif0xuNw2TMult9KJw75wpfyISZC310ZdXk+qo=;
 b=niPMB+8N/dIZlU12nZHq4yJAhNBRSd1nA48NZmkGR9ZU9gHBeEd7XdzrS5ASt9l6OHEZyMBu3ydqP9u1fr3NZcNHEkDO1A5MMwSWFQCP0VhrMfjTnMp7QDPobvGLtR2TuMSvXKj4nUB1pABmpOeYRXPFLOP+Bl9rvYXUOTEvXZEsR8aHIHI5EjACb61hoDZL4+GP2/qf2+MfVVPACg4VXVQFgfVAj6KwgYSkGfV0qA83yP2x33P7xPKuaIGtwlQEz6X1MQnetgZg5aiXmKUm2RQT7n7AuX8bkFR/e9Jz06ZAxWf3ov/WKs57W5iMNhFLzLxDP0bbU3qOp341YoiVwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5WUGPif0xuNw2TMult9KJw75wpfyISZC310ZdXk+qo=;
 b=i9cRo6GAKdc3tt3myqhL4m0CLMtNeCEwzRg5b84XB1moZnIWi1jDolXgtd6QbnE63y8e48Wsx5T4rc4MP4Dv3QyZx9u31C/Nl0c37FZimnAikboxEBXnGxx1UnpUiWoc+ID4GN8nU8TkOI26UZuGIhKOpdkVEyWXtLNkfQWO5Yc=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV2PR21MB3135.namprd21.prod.outlook.com (2603:10b6:408:176::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.7; Mon, 28 Sep
 2026 19:18:45 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%4]) with mapi id 15.21.0496.006; Mon, 28 Sep 2026
 19:18:45 +0000
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
Subject: RE: [PATCH net-next 4/4] net: mana: Add support for CDX device ID
 0x00C2
Thread-Topic: [PATCH net-next 4/4] net: mana: Add support for CDX device ID
 0x00C2
Thread-Index: AQHdTEqSxPGbVHjf10i1z7PnKPEDbLbkY6pg
Date: Mon, 28 Sep 2026 19:18:45 +0000
Message-ID:
 <LV5PR21MB4704AA4D431F2D8DB2766B9DCA8D2@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-5-mawasthi@linux.microsoft.com>
In-Reply-To: <20260924173054.589291-5-mawasthi@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ef61cd1e-96ed-4e44-8906-2c2b92a9fd62;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-28T19:18:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV2PR21MB3135:EE_
x-ms-office365-filtering-correlation-id: 5d1b8509-9eff-420f-822a-08df1d9550c6
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|38070700021|921020|7146999003|10067099003|56012099006|11063799006|4143699003|7053199004|22082099003|18002099003;
x-microsoft-antispam-message-info:
 nBUsBfXdqW+I6j/5iLhTZy4ktN1kNNkNgNNT80C8pll/YXElY1szf45j6IUkjCqV8BII0fAdK1YTUzdxDfoKSo1wAvdk0+fUqTq28hR0u2vPpL2lgGD5za+JpgfmtRuLZmbGzwy1gZPqvaLynw7cvJDgXqt9IUFRnHb8NaAgR6iUk1q9gfeigyuqjKvm5UsEaVdSOnTF6anHv9BbJCIyGqyQRKH3yvIlECFl63vzkV0M0OqU2kzQ/kueOVfaf0BxRtTTiMoqRwcsDMEvkmyDFNI0gF7/Arae7s6gMegBXjlAasUMNdYFK06Dz8O85o8rNDIxi6EPT31nOQTjJG0ej3uX3Xt02vSAM9zf+zOalH25snk69AvkxHCWdB2yIeCl1nA7dm7OvE0gO+4BO+2lG+2cxAnMhrPXQWO60fD5CWuoYbKkffbTvowTQFrItTSmtthMU0gDll04arg7Fphto+H3aP6hoj+wfg4b0Spjm7WPuAOKm1jt3TzKQ+IYBnEy95XOf83XYPONzEFWLs4BXnUb5uQCti06m6e9YlYnzVnSmZfSicSJ8+Mp+w/N/b3vHipEgGwOByoCQv/6A+7aR0yAedZoDfniN/KP1rYGez/K0MSfaZi3i5kViytR0bf8fsVLpd8KNgvms67sRh77L4OT2FmCHnwJpgpJYcTnBgc9MoKc7y5yXCoh3WIkmAbY2vH8HV63e3cYESRNsEww+GOI4qnOLDOlbG4w2M+rs2dg8tHLIbMDqRzEKNhNm6HI
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(38070700021)(921020)(7146999003)(10067099003)(56012099006)(11063799006)(4143699003)(7053199004)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?p4VF0t/gCg9yJ+w1jQQq9CA/W+fd5A90VUtjMESiPC43l6Mis1oklYHGidKo?=
 =?us-ascii?Q?vkQGpVadBbGAiSAstivZW9lLgevhmadBY8PJ0JHJoh92SoNJNYD8vZvQ+EJs?=
 =?us-ascii?Q?sSeyF1aVQ7fAsr8lXltHz7Z6G2vSuFAspN72ZEHkEweo2PaG5+UqA8aZWxcd?=
 =?us-ascii?Q?fZAifDwaGp+KrMqByyjgF9KfbZwjfJXNOlqtnSlnW75PU95FqLeX+cmKBgrS?=
 =?us-ascii?Q?/yiKSO5NxpBO36j3tcoLAgpZi+PANyt1UJlUNEGPTxcQC1PRk5UpvvTpkJLx?=
 =?us-ascii?Q?Cmgk84CqAeeokA5YrQL3DqRCmDNcnarOTDQY7peJk7NnLHCGNJK1h/AHyVDq?=
 =?us-ascii?Q?pOFS+bAXekXzp/C8Hud3ZxiQQooHdaqd7PY4fC3A/TwFPNM4Tgrbl3dTp6kX?=
 =?us-ascii?Q?qQoPlhO5AenVWCAuZ29PdAAIE7kL+XMh2Io+ByRm4NIXhUBF/8GNhPJ7XqOO?=
 =?us-ascii?Q?HAF50rE6CODDu3cQrgJoiU+jc8oLqOxFxKGysJPBiIaI2nqGAdvzJfZpUud6?=
 =?us-ascii?Q?nU7Iwl/K1AANJc/kOvVjbTPmSyqheCSqbFzqGk98R4IEL5CIovgA2Q/4bEX8?=
 =?us-ascii?Q?OlUj/J651Jz7XWcMKOFO5zDFeBLnPHJpUew7Q+0lntk1SrNd9KbiOs645FmI?=
 =?us-ascii?Q?GrBDaWuFLltmpkIX5GW9DR2O+KhfXqK9s72iU7bkABT6C1eN9EQIONzjPoA+?=
 =?us-ascii?Q?u7MeNxcel8gAxXzH4LP5YoN3MsuyUltQo1Mr0Iqh0EC3Ne3uKqFJTGbKBVUP?=
 =?us-ascii?Q?LYLlcbfQ2sHCTRfsOYWACrDTsOr1ZsTwXlLRL2Zf4sLBz7diWP7hNHCcKXxi?=
 =?us-ascii?Q?bhOtsrjwZX4GaZqMbzLUXW+yI6viypzRYvzcOd4prtMamOYwNSCZxXL2fcdV?=
 =?us-ascii?Q?T6hQPAWtW+AovaACrNzaZp5sQwtvbjk4hkaDee7WlOcTbfXWF/jjxOn8x8KB?=
 =?us-ascii?Q?6i5h5hWk36lteVrOFXLWabbtnDCDIUt1ChohiM+/VCEVHpPBHy7n7aJNdXrS?=
 =?us-ascii?Q?ahZVDVaLYzVbkLJZ/3QQ6ZzsLVacK85FIrG47Cm+5lCXCf2v4gMDZb/2/aEA?=
 =?us-ascii?Q?z09LXtN43YVDFCxIQw2HhXCa6+5IKnMVvgmeSYarxk7KRreW2hhG4hPw8VW1?=
 =?us-ascii?Q?QVpFsWGvuKEah1of7Y4SFuDFBUp3qfDyoBQC3SNSFvFlf9/WyLWju+leXm5K?=
 =?us-ascii?Q?8TCCQOV93dSnWoHhDliaNcOzU5xvSt0I3i1FAYzn4lKlF4f/FJjwQLI5mZWH?=
 =?us-ascii?Q?prM3sIMoWxBCNnJLMOZF7wuSpggvjfXshr3TqCYjdijFzknB8O5b+Xc0GxSi?=
 =?us-ascii?Q?13nk1S2fb/XfqDjB3e2o86qzXHrfb1f281GgotKjd/mxUTu1+Xcs8gmtkqk0?=
 =?us-ascii?Q?BkRHLRvrCgJB5J6trwIbPQwt1ba7CUvL/bY82HL1OFuBahpl7XF1NwppmUHY?=
 =?us-ascii?Q?hGUdNA9gCdvHALKGXIGmMsKGMGObc7p+npb0dkB8fNkPV8vvWNKIdQn2QDs/?=
 =?us-ascii?Q?5zbiMs1PoLeVy/FFJIXCD1HPF9nz517eQ/Z5sYRbUHUibmcwvoYDIs1CCrA+?=
 =?us-ascii?Q?a4JP8N5UKAxnVKP8CXxRwx2O9zxLpz3YhTO2nQQZTnHd2qo5kpHJjOZoBr2F?=
 =?us-ascii?Q?SnjgWOYDe+kIW9GPMNBLxF0anYXiXaK1ng9Kc9qD9aTUXZ+gToeTD778jQ8T?=
 =?us-ascii?Q?V8HlIbkTvfTAyjxINIahmXD0YlhaGcP6rtV3J3VdnKMUj2KhTYHCrG33n5DG?=
 =?us-ascii?Q?CEPoT7WM3Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1b8509-9eff-420f-822a-08df1d9550c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 19:18:45.2065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6knMKPg2tpAe5ugHekAjpCzWm/tHd4GKpSE/RDwjSK+uctkHBZxtBYuclcTH8pqSXocWYfTxWOmO3amx0iVYcA==
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
> Subject: [PATCH net-next 4/4] net: mana: Add support for CDX device ID
> 0x00C2
>=20
> Add the CDX transport as mana_cdx.ko for device ID 0x00C2, using the
> shared
> gdma_core.ko. Allocate interrupts at probe, limit queues to available
> vectors, use 32-bit DMA, and keep CDX auxiliary devices separate from PCI=
.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


