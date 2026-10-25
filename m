Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.140
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792915621;
	b=j3vl/eLuIKqTpp31Vy+vCXWdohBHYLaijrIYtARzt+qGK4dXrVznZ2+E/hfaWsmaPWpO
	 Dr3oqZEqT6uwq7eFwP0n8q45v6oeDwziQ4wxvJboLIzCg8hr0bHZW1KNEql85LxyQT8Wj
	 6lW8bN9YLBWCymDgMuDX6P9uFMb2STV2wx4n8NL5XEEZf5fGQE4Xxz6RPySVa++n8YXSt
	 kjh4WhrahXt4kCDH/DLJLEvL9cho3sN6wwr49Ba0fRa9yABO/TEvMvIS1iozeFYWsKT3D
	 fJhj0l2uZdO11EkzW3ZTIGUNNSVktGU6Ifmt1fqigtJICuzpWIxbZs/qtJoVcDyNHtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792915621;
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
	bh=oNgs3xFVZSXJ/HSQ5Lm/k1wn9RWcbuKoP4lPyQszH00=;
	b=hChrfp152Bhlzw8jGv/BHbaq98ed7S9RrgZ/4wRmpmHFYnZ9zIwqx9YSYvyJakJdQION
	 zt5T9tK4j1cGZ9Dn9D/GwSCp8TKoJTGuQda8GkQnkV9am0T6cmk1zumg5MoZZ19kZNusR
	 SeZNJCvS8dJfm701HnEV2Wtyq7iLILHj07w7VCfi8godts7V1lWFIVoDPagCiyGBhNnSb
	 u0g5tfGBKQQ/MqdL7K2/YO0USVD6UYe1u3eh680sDe6iN3vGgh8WUKWcSH+7spJYxjq/j
	 W3koppginnwS3VqhzJIJqPc/OWsTmkLPQHaW/urBfIOjVnibM+Sn2KGkCRb8jmXOngw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b="Obpn/J3G";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.140
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022140.outbound.protection.outlook.com [52.101.126.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA3606A31A;
	Sun, 25 Oct 2026 08:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1EA3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=Obpn/J3G
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RyObsITt1UOEt7zSc0StqRobPabjC99dsm9I4duXWp3s822lw5cuNjRkQ3tMta3pg3oV1mbpOtVr59UnpymzR+SFfuMLYSoMrOFVcj1JL5PbCgl3OExj7j68PfxiwwyjWgp4n4wRfF0XUf8MFuAzWxccIkxFI/U9jKvyueQjZhNB7CqjO+dkAtkjXt/998KhuU6L+dDjh+YBVhgRAQzhqkn4dnRZK8EcTS4+6RZSr8ebgBULq44bJci/K/rVxfhrnjgwSpR8rJv6tCj/SnNkWEJN1I0o4qIEAJQ/gR5xe1mzA5eHvUSmuUhOqjt38soHBt3P8IGzWtAe2bkM5vNfWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=oNgs3xFVZSXJ/HSQ5Lm/k1wn9RWcbuKoP4lPyQszH00=;
 b=DR1u2Cj9VFgtZlocu6w+2CZZ70azUwwon1d0fHyCQtFJE0dZAVp+EIK/gjP7XrR4Q+JlNm6hdL/34Vj1IDO/4WKTCO4lq3IMEFwN+9uVG3db4LwJ5B3ajAnX9cTaHaQkxDQye/44+8yyIDiAGeOQ0GYa/YjBwk1y/+mKEUJrnmLHSthEuHLQrJH6Q1JjsR7o41dBuIAaYXe8jx0XVpi9e0Fv7++SdH/b5/MosTxHOn+/NGqJPp8Hyh/TPA5GXbHiWGg6s1vkLvM0nxdMcG1bHXeva4l0sF15xF3tARq8HvJ9qju4kx4qs1XJjoOOMSDDL3KBeXkfMeSRj0KNz9kN0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNgs3xFVZSXJ/HSQ5Lm/k1wn9RWcbuKoP4lPyQszH00=;
 b=Obpn/J3GLZfI/MNpO0YfOz1rUamU3z49YPfnMrWHQfR72KTjv/NsIk2z8etTo0RdNjX1Csrco9/Wuphde4P4lYXO5AD/LCq7+x1V9k6kCZSA0vumYiDDLVzywuVGZMPmXQb9HdJjUGGSjy2uS6n65MD7UpMel2UX+ZRFJUf7QSk=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by OSNP153MB1908.APCP153.PROD.OUTLOOK.COM (2603:1096:604:48d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.6; Sun, 25 Oct
 2026 08:06:41 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0569.005; Sun, 25 Oct 2026
 08:06:40 +0000
From: Wei Hu <weh@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>, Wei Hu <weh@linux.microsoft.com>
CC: "longli@kernel.org" <longli@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang
 Zhang <haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	Dexuan Cui <DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
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
Subject: RE: [EXTERNAL] Re: [PATCH net-next v9 0/4] net: mana: concurrent HWC
 requests and dynamic queue depth
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v9 0/4] net: mana: concurrent HWC
 requests and dynamic queue depth
Thread-Index: AQHdYjZ69ITXb+UaP0Kf7P3v63MjTLcJriyAgAQ8bAA=
Date: Sun, 25 Oct 2026 08:06:39 +0000
Message-ID:
 <SE3P153MB18485CA69CAEED7FB2CE4D65BB622@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1792679388.git.weh@linux.microsoft.com>
 <20261022082333.5a259426@kernel.org>
In-Reply-To: <20261022082333.5a259426@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=196c947c-02b3-46d3-aced-af6aa686eaba;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-25T08:04:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|OSNP153MB1908:EE_
x-ms-office365-filtering-correlation-id: 57e25de5-c5a7-413e-b2c8-08df326ee62a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|42112799006|376014|7416014|23010399003|1800799024|38070700021|11063799006|4143699003|56012099006|22082099003|18002099003|10067099003|7146999003|261021133027099003|261021130227099003|261021123027099003|261021121427099003|261021135927099003|261022105027099003|261022075727099003|261022113327099003|261022115727099003|261009223027099003|4133799003;
x-microsoft-antispam-message-info:
 NkbhQZQK3HisJ5wWp2sbO12koBL/Q5wNnFXSDlUKfhF6ndUlZuhAFBYbA7Y+OpMB11x9B7hBczcRGV4Nuz9Ex3y80bZm1UE6rXpWPETlnswhfXvSMiKRHcwdyOS6IX2VUgbtf1Y7e80G16vebDnY0aFKbYnYre+gi3r8QItOfcIuQPlmT/ZfWiI4KVuFNstI13N3H9zYAd+Lmqw4SXpD8CT1l/Fkbg7hjjkaJVb3qBB5L5VMp6cCMentB/RVVut1k0rUei+Guh0QIUe1N4GVHoe4KjA5HnaesDvYijH82SLfVZIwUKESWVA2eX6emW9jbfgHDOT3toi0rBXsJYAolReCFKKUM5HX4HUVb+8EVTVy5k1COH3ckhJ19Xs8L3ZlwNMSwIOfzLFqOJtW/m1VtwrWGlMwtCcqX/qiMOf+D5Y9Ox9kg4F6zAqIwxAE8z/E0B4/GkDat517vUfrVA91jzmGyMLTU4KvdFi1p2sr/mbEC8ihGMvs9Q3aKXfzBYc2Yo9ctNbTWvTHXe2N4N5KI9IhNmXQ+EWX6ZtT7Nz7wXt7/oiI8OzLasRQwbN12Njvc5TTUfwGyLQQwQvkGygmo8uwLPCwDPkNQX+qWuUF0ieDoy/l+u9z7oYGR5VTvHS5iKWcnCATbg9MIgvcvzuM73/Q0iMbnU7mrCtPzn7YhX8/AS7syUk0puwJpNDqlSyvtul7b6flCIxYOCikuSe1++j8rpIjvB8SsPLsKRywmEo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(42112799006)(376014)(7416014)(23010399003)(1800799024)(38070700021)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(10067099003)(7146999003)(261021133027099003)(261021130227099003)(261021123027099003)(261021121427099003)(261021135927099003)(261022105027099003)(261022075727099003)(261022113327099003)(261022115727099003)(261009223027099003)(4133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+2Oo6XRgi0nuI0yS+ZdXoaScdTQFVg9tmW7+iY1cTpg4T7y234kmwytlW3zJ?=
 =?us-ascii?Q?Qh8QtQIXd7rgLajZ/AOCzcl+0B1ZL5JVbTang5oAVjd69Mj9rXua+Nz88ZrK?=
 =?us-ascii?Q?tX4j/cGKAwqUPW9D7lwVI1MCzAo8trkBf948OBhdRxji7J8VjNYpScJGHT0w?=
 =?us-ascii?Q?D0uosC8mlovHyUm6GpAma1QUQ7tASZPuABS3yQfKDQ8zwNZsvqGJL98Fq8Ii?=
 =?us-ascii?Q?XF2aFSnylrxMw8Qf927RnOtoOEdMvOILFHDks8icZBD1ffkFmN/9hdrufDRN?=
 =?us-ascii?Q?XK264DKLRWaDp1oHTkWpr24iiP135EIi37xg/xf2jqiqECiNZeDjTPJzZ/jz?=
 =?us-ascii?Q?GRRalzHm9eG10I3zL1ms7CPGCqwp9YuV2b0oiSRjRwJYOMoeXftShcAkarY1?=
 =?us-ascii?Q?Vgy7LUenuxnLGcv5DFHAHew8C+8nPRioSJ9zPP2VmNKqzoy0jz/8x0UtMV6F?=
 =?us-ascii?Q?4cBE+fP0MPMhfSEEClhGnZ7DTboHhd6Cao+8++UFzX1pilYpOQps9JSMvMud?=
 =?us-ascii?Q?CprsDXbv1szs7Hxc7m7xH61H/OyPeB8ZBE3H839dQXlxW4skfs1mWxZAxKJA?=
 =?us-ascii?Q?CN+e9mHT1igZaw1L7yRdxNsD5Nhh2S4yFTWvCLeW6ynp43BeVJ9KznMWu6wN?=
 =?us-ascii?Q?vBkBKtIZYFiKRDp8Vu3SsFLAlcJ8Y0Fw5CalV+2pxEzpPvmw+w04xJlgYCN7?=
 =?us-ascii?Q?7rDcpQZ4JSsg2WG7UjWfDmyUFeQXxnQz+ffBONbb1hhqBYtk0l8JstjY1XzH?=
 =?us-ascii?Q?sTCEm9P54iGws8MWKUueb5pc435VJ9eRY3xiU9TnXJ0f2+JOnzpNdCo8DL9B?=
 =?us-ascii?Q?ivok8sfusBEJGQREbDIRNfGXnsPUJtwTxfhCgOdnpDRuj6sKwQnyf1DAXuUI?=
 =?us-ascii?Q?7vWsN03JQCvXwjQikPdw9258HjSKysWzMROn3zzp7P2w/rUrWk4Rg/pc6gpM?=
 =?us-ascii?Q?Mf97XsihWSkwQKP6+WUz1W6lIw1WnHPCradX8ZjWg5GjjD1U5fzQEihHqKOP?=
 =?us-ascii?Q?YqAVY3QTZNWFi+qPBhCkgeP2f5/beUVHhcFqTIgGxeiFey5IJVjHD3Y6ypIM?=
 =?us-ascii?Q?S3PlVbJUTuHYLDM6we9tNOvvUtp2FumC8eK0SohaBbPisMK+N0aTQICxeHqc?=
 =?us-ascii?Q?HF0fZ19z5mNQrREGhjKd0TE0NRpfBfSBdFcLNXo+JIJqA0JU2vYuJ/S3w7Fu?=
 =?us-ascii?Q?pHDG3v3EK5Fr/Gwzb95w8Qe7dBhyGmsGnQneD8liiKs5j8BRJ6qR4wXsgv8m?=
 =?us-ascii?Q?PE3wF5IK22U9Adiz7Pm0ZpEfqprnl/+PvIdFbJmw6AYM/wEE2yYIHzEDNjVs?=
 =?us-ascii?Q?8bEXFWlY/UX86o7MRaVLjLOC+J33YA/LRNlK4R8nxfdVWb9cmgt34jeblRp2?=
 =?us-ascii?Q?AmIKtIhy2Xm4d31m1sxx73KEmX0Oix5MOeiNz1dMWHk61FfLuLRvdDnVVYPQ?=
 =?us-ascii?Q?+EIoENby9SvJQQQPgLphQtzoaIt7ShdMUnnecFGhE3EHDgJnkPvC0zVwG2Vh?=
 =?us-ascii?Q?zgLahAjH6ZIr3ZQfjFhH7DaAIe7Z9QjSuToq11sObcJWMzloGe5ysQIDwdYg?=
 =?us-ascii?Q?sZ3bTszrQvYDebTBXkXRwXo7UCsUR9afxaEHWF+2EJgltiQOtsu01gfJluuH?=
 =?us-ascii?Q?6OQxn0VnylFdORXQOfW8ui7I7aTUU+YpyqSuvjJxxT9IgocamdKrrbSEIBnk?=
 =?us-ascii?Q?qZDyCsqCiB/aTWjdMdXaQXdMD0slXKLopTIQiXJ//368jSI4?=
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
X-MS-Exchange-CrossTenant-AuthSource: SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e25de5-c5a7-413e-b2c8-08df326ee62a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2026 08:06:39.9152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbCEhKZNckgt+eGicxNC5Ymd7lLOhClZQdGfLaSyMD4X+VIrXLtA6XSPwjLCFRL1AK0uAF9zU+UgNwei6YfUfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNP153MB1908



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, October 22, 2026 11:24 PM
> On Thu, 22 Oct 2026 15:02:58 +0000 Wei Hu wrote:
> > This four-patch series adds concurrent HWC request ownership and
> > PF-directed HWC queue depth to MANA. It starts with depth-one
> > bootstrap queues and keeps setup private until the final channel is tes=
ted.
>=20
> ## Form letter - net-next-closed
>=20
> The merge window for Linux v7.4 has begun, and the net-next tree is now
> closed for new drivers, features, code refactoring and optimizations. We =
are
> currently accepting bug fixes only.
>=20
> Please repost when net-next reopens. There is some uncertainty about how
> long this merge window will last, so please check
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fnetd
> ev.bots.linux.dev%2Fnet-
> next.html&data=3D05%7C02%7Cweh%40microsoft.com%7Ceb8ac39a1dbf47c
> ecda508df3050713b%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0
> %7C639282794239267419%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1
> hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIl
> dUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DAdSsI%2FNVIHHStOBVRcxQq3
> 8jIHAjzyhTnv4WkMhe5WE%3D&reserved=3D0
> before reposting. net-next _may_ reopen on Nov 2nd.
>=20
> See:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fww
> w.kernel.org%2Fdoc%2Fhtml%2Fnext%2Fprocess%2Fmaintainer-
> netdev.html%23development-
> cycle&data=3D05%7C02%7Cweh%40microsoft.com%7Ceb8ac39a1dbf47cecda
> 508df3050713b%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C
> 639282794239291497%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGk
> iOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIj
> oyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DJs%2FXqxP9IwDMjeCLcc8%2F4XIVt
> A0s20vgCp4oFJ%2FdApY%3D&reserved=3D0
> --
> pw-bot: defer
> pv-bot: closed

Thanks. I will repost when net-next reopens.

Wei
