Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.107
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792698140;
	b=nOzP3NHxdZmQXTHD3VFLflFegCUxxyelLd4Y80cPoW1klRTQsMgaiD3aF1llNCFXe47d
	 KX30GN+V5FcX7T0nRjV8WiTQrIrBpWls6PkZFVLk9DX+ThhLsJELMA1V8w70p+Q6SVQV+
	 huuOXVirLkuF8rKPzNitCwA6wcdjlf4XrdL2e8H9PdSs+FhHfsG1czSMF7LHSMk7CheYk
	 ZGK3WtH3ZUUxZXJRAa8zFi3fTgEJYVIckQOa/gCflLo8OuxYI43ToOdLoTTGWM/m3e6/a
	 hc+f/z5Hj/Ow4WwxbE8IkasCHsS2XAI0IoWzmmHbYgEyEUBy2nKaVSKCin37OrE1V/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698140;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=MoXuNjLRfbJCHuq/VbSy0D7t1MNceprDg7IxtXs8bfo=;
	b=Rq7ZNlUJiOrXSnun+z5C9zsnyZ3/41TwLQe5otbF3e9f8VmLGudCeXcsJE5x5Ahmly4I
	 vM5yMQACjBvxAqYa9N2n9BI81aT61n13JPUDNnj5Z1YlBebcbsDzHcK2Pq5bK0dW59hif
	 rRBpvYnSakYbH5Bvi27xF/WLkKLEjyAwWteW9SZrXBscciFMGBU4JG0Co9mBPY26K5qWj
	 y8i78wQ1RdmopazS+l+oKkOBo1iA3L5bKkj+1zY7uDvPtdfgcvpGXvSPd/+RcvFFgyeJP
	 W7cNgTycp5OSyksqiJX1Mw2UWwpD4QgocnPlBCK+RKo+1gTDqfUmwF4bmEpKkRHFacA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=VnDVkP4y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.107
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022107.outbound.protection.outlook.com [40.93.195.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA0E606A319;
	Thu, 22 Oct 2026 19:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BA0E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=VnDVkP4y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7wSKjs4msqIS4LSItD4vkzSGmePFnzoIvin4bY5oGnDSFMqV6QdycbB9J/JfdMTVVbgLEo8/DRFlLb3u+pEcW+wBFWov1cHi10q0G12RsJZ+XLP2LONkj+BJlT3GUzFMxV5RXXpKGqBe3sYJltpx6xwpYzpF2l4uBYu9iv6nlCQ9amzGjQhfwcEDGPbDUxdITmEh18v/Sg5k9fpXZKRUXGbH9tn/PmgIJnJnIzosBeTb7H8ta0x38x3y7W/WpXjfJADqD0xkwUOXs8/ZxnxKzjG5BpEIV/eoK7xa5SUqVErmdz7MR4tifRJaavIJmBCuZQ7qrgPvr4VNaPcxBr8lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoXuNjLRfbJCHuq/VbSy0D7t1MNceprDg7IxtXs8bfo=;
 b=LkSoDHx59yj8F1TvannQ99PuZhLsAOLa5ekTNDTxh91nSIq1ORmk/Xmxheu9hfpAyytSTDKRb+OtDzTx8b8iBxst1kx3c0twjUKAg5hRCdD6S+W2uRvA6qVMaLR7aK5N+kSToyrMFYbYZrTJ6OZjfagqi7O9PFR10mElSw76m65OiOGhWiADHzi5Hh0q6tWkbGYGnNkVINdtjrJU/xbOYnjqOPAIb1fsqFIRgH96tBYj+JfH1TsQfAWV7e9dphXlpQednVxceTbE9OSD0//lInw6ZHd1PeOCaNw1totscvvAZCmvytrVhs0Ho9yksmm5ro/mNEgv98v7Fa40t+A7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoXuNjLRfbJCHuq/VbSy0D7t1MNceprDg7IxtXs8bfo=;
 b=VnDVkP4yDoJVVdDK9IWnhvmX2BUepQ6z1hLtsCBogoC6yPydsaWjUWtX+ACQpw2c3BNM3XogmZe54B4liRcNoch/w/VUIn4Fj3s8Qrud8kJNf14L3/+3A/Vhno7cMl001ypgXWoTcTMQfSsJzmoOoZfiVQyIyblZDHRptSYaEaI=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV2PR21MB3063.namprd21.prod.outlook.com (2603:10b6:408:17c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.3; Thu, 22 Oct
 2026 19:42:16 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%4]) with mapi id 15.21.0569.000; Thu, 22 Oct 2026
 19:42:16 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>, "wei.liu@kernel.org"
	<wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@kernel.org" <edumazet@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>, "horms@kernel.org"
	<horms@kernel.org>, "ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
	"mawasthi@linux.microsoft.com" <mawasthi@linux.microsoft.com>,
	"leitao@debian.org" <leitao@debian.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v3] net: mana: Add support to process throttled EQEs
Thread-Topic: [PATCH net v3] net: mana: Add support to process throttled EQEs
Thread-Index: AQHdYjce2d/WGheqJ0yvbKQsxSn9q7cJ89Sw
Date: Thu, 22 Oct 2026 19:42:16 +0000
Message-ID:
 <LV5PR21MB47047DE99D8622E45CB41ECBCA652@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20261022145428.323576-1-sahilchandna@linux.microsoft.com>
In-Reply-To: <20261022145428.323576-1-sahilchandna@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b7370f31-b454-451e-9072-9cf81d2142fd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-22T19:32:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV2PR21MB3063:EE_
x-ms-office365-filtering-correlation-id: efdc6ed6-eeca-4d83-dd88-08df307493cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|921020|38070700021|261021135927099003|261021121427099003|56012099006|261009223027099003|261022113327099003|11063799006|261021133027099003|261021123027099003|261021130227099003|10067099003|7146999003|18002099003|22082099003|7053199004|13003099007|4133799003|3023799007|261022105027099003|261022075727099003;
x-microsoft-antispam-message-info:
 /UCjlrDGTzlSxfUuDAv3uGOby20/CY48fZARyru/mwFJ3ojG/zNfslUTBAeM4iJmeCVKOtIA4IRe13RvEJO6y1AnmaIGuE7086UWk8M9uKxvzpk2IqjbzFm+ASkR2yYyNPaCM/sXib4w30pgYdcLd5QVMf296mXkgYM6sS/FJV67dcupHS9GOaNgw0xyzJAAsr3lMEqMYOHOfzMOeHtl9i6nF/OR3kBV+IYqEN3YNwQ4inEDf3ZmmGfXo/4nPCehnCHBfDByRGXT/2iDWpqsZm0pfwvrqJcnbqceQo/zgHO9Mlby3BlGnshwZKVf1F9yA2qyfDdBLw/N5beZXOoQ0f8IcGeumisbccAnpVxfhZ9p3tcsbRmyWTG57H6G+Ts9UUijotDuLqAXjGLWr2eGxppT2edpm5dfeHjY5IW4V8/tvlihG53i5Rmo9wrqGuzKJpA5VKnitaw6l8KA93o3dRNef2FdfctM+qVTyvxU7+MxxPCWwMUJerUE8TeCo2KTSo5n+CzYu/pUWPHdD996crLOOV9ZRXqM+FmaGTVD272JBZ7liFFcMeYsrpyArFhE9tDE/n8EDIdsojCC88CTLJVwCZb0l/qKCPrtpqY2fOnk+4mVZ1j9PioMftGHNbVCMBUGjSgjc3QHH/wd8m+oIp3G8LFsY6GgZfaX9TvHmfoQy5hTZH5OnZF8i4bznSDY
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(921020)(38070700021)(261021135927099003)(261021121427099003)(56012099006)(261009223027099003)(261022113327099003)(11063799006)(261021133027099003)(261021123027099003)(261021130227099003)(10067099003)(7146999003)(18002099003)(22082099003)(7053199004)(13003099007)(4133799003)(3023799007)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?bNj/SXKSN9Pl/NjwPOIHB4U1q6YFp3Y33hXCW/Top7XsCCJy8gOoXd21BWyG?=
 =?us-ascii?Q?Cl+d5SeBFMAwPr0iuGa45JcU/4Bj8jQTtuorOmIyO4j7GQm6vzrUoFNh2Eum?=
 =?us-ascii?Q?LzW1Q9zxkxyTXf3uQ0X4Q6SQQR1Y9QdHQ2veT7mHLafHU6ed0oqxKp7AxS6Q?=
 =?us-ascii?Q?rYvnOPzZg2fzZH0kfRKXjXE71Es76lT3Ap6kjLJT6mljZJU/PpZi4ghD6bZ9?=
 =?us-ascii?Q?kVZE/f7Z9tnp7h5N4Ir4QKqNUs/Mi7jL0opc/uGuB4U22HgCpIFF2vk7bi2u?=
 =?us-ascii?Q?mWY/74EWZNcFJEUjlh8Xb/4VSAXQPKXnLuKeb18OCQ4okAIVQzmXNtQBwG1x?=
 =?us-ascii?Q?JgHkqDwiml+B3ArKRun2oeQ4U9XMqJ5GijdlrTHNctWxUdSSrXUNwk3NI5mF?=
 =?us-ascii?Q?2JRBaFlv/u0GnoUnSCEIIw75hael2XqOfF+ai9U3wblaQQMyMTX+G3lF9l+F?=
 =?us-ascii?Q?0JH4EIfTTEWyNZRF15fdSIFcViQLYuYDt40ex9J2t6grQa7Tkef0jg/XTqy5?=
 =?us-ascii?Q?ZMIa5PIFR3aZx+I7k0cWqVrBUKfEGyxxdUdZUzfICUE0ofWQmgYSBmpdQJX6?=
 =?us-ascii?Q?RhAgDWS8HpKvxgPT1uCzh3EsS50vBubaFtqShQQvxCNLrvLmLygzGbvZJE0V?=
 =?us-ascii?Q?oTIrOi0ps7N4SA9nlQzGrbbrIGE7rObSks5EPk230/2iDBp7yElAnjPgsQ6f?=
 =?us-ascii?Q?kwuMqLtT9g88t6nbWPBGG2X8+TLFJ3PQ1SW6gGVAEpBidNgRGl8TLSFenqtV?=
 =?us-ascii?Q?jDdkerhYYItPFJ2BvqUGLpEANW8Br+jqDKnRiSaJVmB06ZX5Sjg517z8iwqC?=
 =?us-ascii?Q?1CffiGrqQYyMr89/xoLSpAlN87a043A1BwsATWcG3Beb0pGdXSpjVA4RcXPT?=
 =?us-ascii?Q?Hu49e5WES/necDwrxh/5jVoc3v0R5hpY72yQn+3/Cp2XlfUMHnITe9DA6E6k?=
 =?us-ascii?Q?NoaRq7Vuh+1j2D2eR/gd1jClr3ka6rvHNRqVKILuPxlwv+mJmqsmNuKNS54X?=
 =?us-ascii?Q?1EaWjTt0Ir4CWImgloH1rKHPQJFzC9U6+t+E3C5JeWyWhJAzU0w6xMEzC/OM?=
 =?us-ascii?Q?g2kl/dpOwb49gGTymyO7N25mQq3UVYn3/dH7+rFm4AIMqQom77kcq8wUq5Oq?=
 =?us-ascii?Q?rwjuZmMKEVhEYvCt1l3xI4DFKbh7tZlsunQxxsnjKWfsmwXLAtqdf3DmAgJW?=
 =?us-ascii?Q?kRgPWfGUBXCFhgbboaeImjzbZSDT3Fe0EZARSAC7IuGSiM8aKDQCqY604VMn?=
 =?us-ascii?Q?mYqTTnDVSRneJdSgrv3uNZvIkzdyEhbNILFmJDQopqKxWYtD/m9j1gqlozu6?=
 =?us-ascii?Q?AMQx5dY1/JtWMl9CAEm1PaTSGv1rlOWo2WEj7sAeCEjEHYCL404wPIEk0Y1A?=
 =?us-ascii?Q?ztApnELdP5uwaVRh4Aucp2vMq96iML4Yq5B293o7hBW7o/ffxacnzun07uFp?=
 =?us-ascii?Q?WEhQwL7THosUMSS66su7U/APpbpZdAmYJBGSqOtNFVz0vns4+sQtsDsW0+Zh?=
 =?us-ascii?Q?2E99E5SXj0uzvxiufEuylb380PQYJI3XadnNOSZJccXifIg3MNLHYl+jL1R4?=
 =?us-ascii?Q?MfH3ozNfvipwAlfz6PQ6ITkcYhZuajbDFCa7fmRqoyBRk+lYpn7wqpuJWXf5?=
 =?us-ascii?Q?JBw8ZNimMXx5GCe94jSoXLeN+g2muBEuRN8KPcDpSEOj2NUKyFn6R+dWYA45?=
 =?us-ascii?Q?D6R9n92Dm4kdlUP7GtZjEWML+V6JwyInUd0DP33PxH86BRJdeUeHqI8g7Ykw?=
 =?us-ascii?Q?UOuLgbbPnw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV5PR21MB4704.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdc6ed6-eeca-4d83-dd88-08df307493cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 19:42:16.3336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lmMYP/yPjGnPsja0jxqS0gS/frmY1bCLCLp70JyPzHuIu+u7M7taIrH54+9coeJYDhAys5q9iiw4qEIVFboORg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3063



> -----Original Message-----
> From: Sahil Chandna <sahilchandna@linux.microsoft.com>
> Sent: Thursday, October 22, 2026 10:54 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cu=
i
> <DECUI@microsoft.com>; andrew+netdev@lunn.ch; davem@davemloft.net;
> edumazet@kernel.org; kuba@kernel.org; pabeni@redhat.com; Konstantin
> Taranov <kotaranov@microsoft.com>; horms@kernel.org;
> ernis@linux.microsoft.com; gargaditya@linux.microsoft.com;
> mawasthi@linux.microsoft.com; leitao@debian.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
> Cc: stable@vger.kernel.org
> Subject: [PATCH net v3] net: mana: Add support to process throttled EQEs
>
> When an event queue nears full, the hardware coalesces the per-CQ
> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
> that carries no cq_id. The driver does not handle this event type, so
> it falls through to the default case and is dropped. Any CQ whose
> completion notification was replaced by the throttle EQE can remain
> unserviced, causing its queue to stall.
> The issue was observed internally and following Tx stall logs were
> seen:
>
> 2026-10-03T05:29:01 hv_netvsc eth0: VF slot 0 removed
> 2026-10-03T05:29:23 mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 45:
>                     transmit queue 1 timed out 15133 ms
> 2026-10-03T05:31:05 mana 7870:00:00.0: HWC: Request timed out: 60000 ms
> 2026-10-03T05:31:05 mana 7870:00:00.0: Gf stats wk handler: gf stats
> query timed out.
> 2026-10-03T05:31:21 ens1: NETDEV WATCHDOG: CPU: 20: transmit queue 0
> timed out 15859 ms
> 2026-10-03T05:31:37 ens1: NETDEV WATCHDOG: CPU: 15: transmit queue 0
> timed out 31731 ms
> 2026-10-03T05:31:53 ens1: NETDEV WATCHDOG: CPU: 21: transmit queue 0
> timed out 47603 ms
> 2026-10-03T05:32:08 ens1: NETDEV WATCHDOG: CPU: 42: transmit queue 0
> timed out 62451 ms
>
> Add support to process the CQs which belong to a throttled EQE of type 4
> advertise the capability bit, also add a counter to store the throttled
> EQEs count.
>
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
> Adapter (MANA)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
> ---
> Changes in v3:
> - Resolve race for cq in mana_gd_destroy_cq and irq handler using cq.
> - Rebase to net branch
> Link to v2:
> https://lore.ker/
> nel.org%2Fall%2F20261014134304.4177657-1-
> sahilchandna%40linux.microsoft.com%2F&data=3D05%7C02%7Chaiyangz%40microso=
ft.
> com%7C534992a49c0340631e2f08df304e3c73%7C72f988bf86f141af91ab2d7cd011db47=
%
> 7C1%7C0%7C639282784768349454%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRy=
d
> WUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7=
C
> 0%7C%7C%7C&sdata=3Dw2NpUCx%2FCNtqeFQSR0fIMOYnbHLP7XsFl90sL%2F%2F7Y0g%3D&r=
ese
> rved=3D0
>
> Changes in v2:
> - Use WRITE_ONCE() when clearing max_num_cqs and add RCU
>   grace period wait during HWC teardown.
> - Use synchronize_net() during CQ destroy only when the CQ was
>   attached to its parent EQ.
> - Use WRITE_ONCE() and READ_ONCE() for the throttle-event counter.
> - Add Fixes tag and net instead of net-next.
> - Fix commit message to describe capability bit and counter.
> Link to v1:
> https://lore.ker/
> nel.org%2Fall%2F20261008083315.306076-1-
> sahilchandna%40linux.microsoft.com%2F&data=3D05%7C02%7Chaiyangz%40microso=
ft.
> com%7C534992a49c0340631e2f08df304e3c73%7C72f988bf86f141af91ab2d7cd011db47=
%
> 7C1%7C0%7C639282784768392174%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRy=
d
> WUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7=
C
> 0%7C%7C%7C&sdata=3Doj6Ei41iOntNjgoAWNaLSZdvptpbZSkkZMOCa6c2PDw%3D&reserve=
d=3D0
>
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 62 +++++++++++++++++--
>  .../net/ethernet/microsoft/mana/hw_channel.c  |  6 +-
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  9 +++
>  include/net/mana/gdma.h                       | 12 +++-
>  include/net/mana/mana.h                       |  1 +
>  5 files changed, 81 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 8e9bfc1d6a2a..d74ed00bb783 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -904,6 +904,27 @@ ssize_t mana_gd_read_ring(struct gdma_queue *q, char
> __user *buf,
>       return copied;
>  }
>
> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
> +{
> +     struct gdma_context *gc =3D eq->gdma_dev->gdma_context;
> +     struct gdma_queue *cq;
> +     u8 i;
> +
> +     for (i =3D 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
> +             cq =3D rcu_dereference(eq->eq.child_cq[i]);
> +
> +             if (!cq)
> +                     continue;
> +
> +             if (cq->id >=3D READ_ONCE(gc->max_num_cqs) ||
> +                 !gc->cq_table || gc->cq_table[cq->id] !=3D cq)
> +                     continue;
> +
> +             if (cq->cq.callback)
> +                     cq->cq.callback(cq->cq.context, cq);
> +     }
> +}
> +
>  static void mana_gd_process_eqe(struct gdma_queue *eq)
>  {
>       u32 head =3D eq->head % (eq->queue_size / GDMA_EQE_SIZE);
> @@ -934,6 +955,11 @@ static void mana_gd_process_eqe(struct gdma_queue
> *eq)
>
>               break;
>
> +     case GDMA_EQE_THROTTLE:
> +             WRITE_ONCE(eq->eq.throttle_count, eq->eq.throttle_count + 1=
);
Please use u64_stats_update_begin / end() for stats, which is the standard
way -- see other stats code in this driver.

> +             mana_gd_schedule_eq_cqs(eq);
> +             break;
> +
>       case GDMA_EQE_TEST_EVENT:
>               gc->test_event_eq_id =3D eq->id;
>               complete(&gc->eq_test_event);
[...]


> @@ -250,6 +252,7 @@ static void mana_get_ethtool_stats(struct net_device
> *ndev,
>       u64 short_pkt_fmt;
>       u64 csum_partial;
>       u64 mana_map_err;
> +     u64 throttle_events;
>       int q, i =3D 0, j;
>
>       if (!apc->port_is_up)
> @@ -261,6 +264,12 @@ static void mana_get_ethtool_stats(struct net_device
> *ndev,
>        */
>       mana_query_phy_stats(apc);
>
> +     throttle_events =3D 0;
> +     for (q =3D 0; q < num_queues; q++)
> +             throttle_events +=3D READ_ONCE(apc->eqs[q].eq-
> >eq.throttle_count);

Since you already have per queue throttle_count, please output them for
each EQ.

Thanks,
- Haiyang
