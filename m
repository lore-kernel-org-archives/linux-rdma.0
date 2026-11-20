Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795142119;
	b=IfyRdjj4V7BEMmS8LASom3yA9yw6w8XkXOpeiVPJ//JYbF4dGNXznPO3nQcyiVkexzc6
	 KAVyLGboTiPVupcbDab+vSWw0RkdMTIUgddFCB6gE8qpdUiP90qzIt9A9rXPYo8BBZyxa
	 UeIbX3npQq3H7l65X4rq+Gn/Em8Hgy/5AJJSzAxw2WUQcUsYKxyokPbpoyO8DpgFkTrg5
	 sXNYQWT57Rc7JylEyx14DCQbdAVpqDbI8eRU33xKr1R+xOIfgfgSz7SaRsXD2blSp15z7
	 tUARTv+RdfMSU7r1poZCjRmwPWL0TWZTYIBWNtxf0IwGxeXTspmKiroWYw3glh1m7nA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142119;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Aw0jpPWE7oGZpWxEbMfMuZ0cWub4y+XKWPjrxoRdG1Y=;
	b=N/AOItu8Dz2oKJQxCOlCDFc+QBkmPQoqz2ChQejO5oe0Pt1Izc41waGbT61HkvrlEpmF
	 1S49srqdBU1hYzTDZzDmrW49lSLIJx1bE8FV9BRs8DCzY90dgj/aYFgDPjChiDB6UCMau
	 ciJyZFrfhXZGJnORfcTlkktQN6odGinmqtkbLq81RcxyOYUES6Ds4tr3zHN/fWiEiYTCR
	 DeCUpFwBqIO0x+6ugNWfGPqGkMpvC1ZkjbP+Vn4qbHrFli3lMtK6BBkvZwH1N4xoobfPm
	 BOe6bLnDA/WSdjBOnuA53TdiwVuwiBo+owcB23bRagkoAJ5L7grpav788hQI6Wbo3jw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="JUGJo/QF";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=NBuLwc9Z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C54F606A326
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 02:35:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C54F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JUGJo/QF;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=NBuLwc9Z
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795142118; x=1826678118;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=e9aL51syIHuyoFV4zmBHVsre+pj4fG3pdbkCxOg6gy8=;
  b=JUGJo/QFH5OGsnKc4G+9gkk5HvOmV9wlTzaa27kkAiZBERwMSqA9FiZP
   2xr+OQRF+9Yf+RYzE2GnicmC/XLC+KodP9mKzC9Bk8fwuLHu+Hc8Pzz4s
   y3398xAsh/G41BkibqFJvL3DeRe5bNMc7MWiyoiHSDkboEc/QmGZr0Vjg
   lfIdxtCjXz+BkQymVRf7dbyDnFm/NB40m+4qCEH0mLpm3JqpR3njnY9oY
   O9sgCXyKlz0AK2Bo1YkHgTdzVL5qYSsI+XKNY87bDNkb4XR8dnpijyrPU
   dxTmMrLlqxQT5qsy8JLHfaDwhOMSNhkaDLCL7oFBKI989yxPc0dUssWit
   g==;
X-CSE-ConnectionGUID: xtkpMokCRKWmLtpIFppxLw==
X-CSE-MsgGUID: EFdq1nVtT2u+qH2ecoKRew==
X-IronPort-AV: E=Sophos;i="6.27,222,1786982400"; 
   d="scan'208";a="159717494"
Received: from mail-westus3azon11012055.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Nov 2026 10:35:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xar5stPq+fg2QiU2tOovRIXXsTCDy0YytyZUP/naWxwIoQnlUPCb3h+AF8Zz2hDMBb/b87axZ0QLT+29j+mR4u47206MIw1BpYSJFYSpsu3xIDta+1JFDeVES/z2TK98XkG0vValUVZWjZF+EjVRlBj1YLOwUE3UY9RwHO772TIewgGCg+kwBmR3gp7RLt/nODl/JZ6azpAGqIPz7PSTVhqRDhVDUa8KcooDbvqePvFIavtlBG14CReEoKvtVtJO23d/pKwpOk1UrO4zUD1goszGJex426p/EB93BCzbJPF1HFXgIFYaWFNbBAcA2nWUAo2Wxh0/u2Dh43U7YD59ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aw0jpPWE7oGZpWxEbMfMuZ0cWub4y+XKWPjrxoRdG1Y=;
 b=NXcKFgvhXQHS4JiAVAYzcHn9iByUMxMvneFX7RvjE0fPFM2ko5HpFNpUmK4Zq1aWc3n1wZbTdZw0qlEIQ/JQJO4IebyxIMqFNUQsYEBSOD/hdSZ7Lr+EBolaZiSCFxFgt8OABesD0jj6IkCQsL4PpqiuTTq+mdA3cSvpYMlTIQnnm7JmzMu+RgJtmbs+IEAPj8UPlGLsdi+CqTyMGVn9kXFjtFZxaOzgMWZ12qYxjqlM2J5EXAl6i0+R5fn5VFg80h27/OXTkq5t6jOF3QJXwW3P02jsHbVbczOkfncN4Om0sR8Tqe8vslWJpe1/KTumy3R09DeHXdAgbtTh4EbhtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aw0jpPWE7oGZpWxEbMfMuZ0cWub4y+XKWPjrxoRdG1Y=;
 b=NBuLwc9ZheUKLlSwJv6ZPlRlbne41MbW8fA5tG6FTiTTejocJ7fNXEbyyYWo9Q6rPIr8QgfiyPN9skzcqyYVtEejGusZnTZh/Oh0EyKtzGjDk8jwrujikEnuoyDGpkXUUB23lt5CwtRia/DxA+sns+1/WGBKxQ2Ifo4lyaJBCPk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by PHXPR04MB10048.namprd04.prod.outlook.com
 (2603:10b6:510:3ce::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 02:35:10 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 02:35:10 +0000
Date: Fri, 20 Nov 2026 11:35:04 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, 
	kbusch@kernel.org
Cc: jgg@ziepe.ca
Subject: Re: [PATCH v2] RDMA/cma: Use a separate lockdep class for the
 listening cm_id
Message-ID: <av-vJXx2CZppcnAW@shinmob>
References: <20261117113129.746490-1-shinichiro.kawasaki@wdc.com>
 <sashiko-outbox-218731@kernel.org>
 <av2QarZ0_u32MHzM@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av2QarZ0_u32MHzM@shinmob>
X-ClientProxiedBy: TY6P301CA0024.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:3bf::17) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|PHXPR04MB10048:EE_
X-MS-Office365-Filtering-Correlation-Id: 06881781-b41b-4fe4-9b7f-08df46aee568
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|19092799006|10067099003|5023799004|11063799006|4143699003|260925021911599003|260925021311599003|260925022911599003|56012099006|261022075727099003|261021121427099003|261021123027099003|261022105027099003|261021135927099003|261009223027099003|261009221727099003|261009220027099003|261009221227099003|261009223327099003|261102123227099003|261026140227099003|261026121527099003|261028144727099003|22082099003|18002099003|17002099007|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	6rQmiSXSBiGqVLrgaY8Cn5n3EC15ekTATWw7a0feD31vEfSDSAxNDZwS/lt9vZ224MDwwcxr8PUrQEVqjteHqaykznmaz5xF0W3a/dHRCf5AdDysPL2ggEoPkaNj2jnW3F9GTct/fMIuJGx8Da7R+qenIYoqQhtNhEI5LQBrKIqotWDZWb9Ku/xVf7TchZ/XScIo57sziikkwA+8FQ+Xm9/m8V+CWhRggbJGPXteNgKzMt3bcq8hh6Zo+tl9B7BT+yvoHIZ6b9WdTXhibWZMShUHJ5PalXWHWXP/CIsAVUt+RSTValfh6OZOkFfpDoFm4ZvPzZwwY4ookQ+p6MDJ9QFJyX9EaUEpDDTMmM2jYp1KPahuDH27UZ98a7KpfKhsG9IwfYhj/bVZ75h6oMjAQuZoOSeJu8naLvh4fwt6rVfAKaIvFRtu5zd9eETBZZLU905hj/1oosidwW49Bodj2CxHpB41DE/xGP5emf/mtmXKU2ebG+N/cMkA6D/D9L08nwwZFbjD2ml0o7GiXAN50U++CzbvgNV105dT21UqjQcelJDOqXjyyW1UKitrLv82Dqeumr1W9lRYY+Lz7+GoeQ+Icj5YmNlFHaJ0CMs/t/vvK/Qq7G2ywiKsRPXVvFkp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(19092799006)(10067099003)(5023799004)(11063799006)(4143699003)(260925021911599003)(260925021311599003)(260925022911599003)(56012099006)(261022075727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261021135927099003)(261009223027099003)(261009221727099003)(261009220027099003)(261009221227099003)(261009223327099003)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(22082099003)(18002099003)(17002099007)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Evv6uBo76fDWbN9jUYoRYja7+bwNya74OMwdW7eVn7CqOTMgSVNKkLV65VAp?=
 =?us-ascii?Q?isRGSUpDotEqw9sy3psLF121D4LxBgaNsBTTlMwts73q5/2wXeJ/2sfoij0z?=
 =?us-ascii?Q?IpKPcEN2936lmP1IP4lV3kmo8NQ2qd83yELlc3uyLc+3EeNv4n5TEZxkCrKN?=
 =?us-ascii?Q?5z2GAkx1eL+ix7IAZ72ZqyALgxGIkf/SIZx9RYeV4O2N9JZhvosxZ+jDSk5a?=
 =?us-ascii?Q?RrQgquIg1WrnXe7EXYyh5+VbkDELuZX1Bpq+jYX0sRLDCwXImLisaD3PtmI2?=
 =?us-ascii?Q?b+q8uacw0PvntESj07LvuGMBC0TCYE+7uTQXzyLFWeFGbKPirBs8FtOtd/5j?=
 =?us-ascii?Q?RkRhXY/S5fPGac1a+y9lzwWD2AFMrrVLNBu+Ayxeqzy7m7jDnR64xDKGwc2K?=
 =?us-ascii?Q?w+M/qoPNWjEA3Gmck0Stk3eSqzK0Cq4EJWOCebhPYoFZjepwqFKPtHeNMwE8?=
 =?us-ascii?Q?maoD7tyKlBx6kK9h6/VimQkOlx9veD5pq0cOedK6h4fFMXFoqEVEWMfK6SRB?=
 =?us-ascii?Q?PZeNGkmak7ac9v1LWz1sXvtEXzinQB1TpfNTg8qKBhs/7r1cLRefDdF0ohiM?=
 =?us-ascii?Q?+k53WP1EcfxsLi0YZP4jvcchW16nvHsNZ+aAuMer4VP2RIFNumAK5plaTt0E?=
 =?us-ascii?Q?OPq4B4iadjC5LUrC1/8CNMy619+jTY+yFXJmN7BIMqRwIaNfPtYiAgf0jYQ0?=
 =?us-ascii?Q?lCBZilfnyjX9216h9EUbwhaRkdAXGrmBzEZEDOQz4kpwd/bOjpPE9Fm6iuXT?=
 =?us-ascii?Q?fTbyycU4YHQ9wT2QxBDmdteSsKOJ7j9lUMomCgYvxhfD8eAJNOMsyUVih+wJ?=
 =?us-ascii?Q?58s4Q7B1fkIs0AX6BYea4nF2NiSzAPV2WdIkeeDSyXIrFrouLIAnN2kCbuAY?=
 =?us-ascii?Q?RVF6dT/GoNqNhBGTxA3UX/pwrX1bZ0vMCBEb3P72ypaO/qkgluDvbS5Q9AA9?=
 =?us-ascii?Q?FaSk0Ah/KDghXgKXmZcz6Era82hbTginxuPW9Ecpay3Qo5LahJzq+eBFmOmh?=
 =?us-ascii?Q?lG6u7UiA9xJ+a2NowitQLcX27KviGPAoj2cRxll7AmhF54blxtDbt+k3x3Um?=
 =?us-ascii?Q?GB4C8/PvJcBv912W/pj5xRmcQuNhRVyOSxwQELUunQnuq0KkgstTG9Tz02BR?=
 =?us-ascii?Q?tf0gg/rfNywMpw9ZEyIZNVPniMdrJ3CIuBpXbD1ryBfiPTmhP1SPGt6xPnZg?=
 =?us-ascii?Q?qlhw3zuEmrr1d3tpc2a8amj715E07QJazGn4Ej9N1uTA7Ij50JHnP8YUejiM?=
 =?us-ascii?Q?oH9r0KhXntx+mag+W+CsDAazjSwIVDqHC+K9jsxNFIN2s2hCmnvW2k2S/V76?=
 =?us-ascii?Q?lcPvD/Wb7o8UXhKuuGX74XO/dFac3RtTHZoFtfpu9QvCXN/YYMKFdRrzNsOb?=
 =?us-ascii?Q?pwDAVpHC/VCYZO8/Dwhh1N9SYt5sp1Bi9REIwx6zRE5JW77ZrSQ4SukCSToB?=
 =?us-ascii?Q?UI/Bwkx6E1h85qEm/IOfJHedc3fD3wvO/z+4vvo3PXs2p2RDBgYBsCYNsGIZ?=
 =?us-ascii?Q?Z7bapmDm3CW09BBqRend8uZ3ZW3QF32a7b+gpMwsTYMiBRXBlbIBR7VMHQxE?=
 =?us-ascii?Q?dQHZkScDSch3oq1Jr1O6F8/TvDTlScqGNHIZEdjSc69bbn+qINxt3m+hBHBw?=
 =?us-ascii?Q?e2bmHB4O2/cZkSwpRZEgz/bwyDTXNt6kfUOxKQLzhJzQPyj9crX61ZLabh6M?=
 =?us-ascii?Q?RulKnrjq2M67JBVRaihdYt25MIKnD8QgiB3qTLJTV3TV1+ci2wIJPahDYVtO?=
 =?us-ascii?Q?228uywsl8CAJlZqfbEbCEBhXSjAuPX0=3D?=
X-Exchange-RoutingPolicyChecked:
	Ffug+TBygZVU7+XdORbzeflIUdVX/L6fbKb/x5tMikFm1Tn+2ULYJkRaQKaihBXxPz8eZxD26aP+R9HLcaS9sVnP+Hhe/NwpXBfOUjB5Sdbf6JzPrZTEF/rYcBFDOtBWeyGXvewFDJcR7xDIfFwdUEc+20Px5ik2JjXmuknzT93qcYI96quGkH/eiWBOgZ7+pP4kF+3TdplnRuTmgGP/oO7M40f6+3qNow4N2LqG76houKQ20SjV+ZZCTUyStyhoA8OEZQnQuciWddrJATVI8keGR5HjfbH37vAdQpUT6vjRDY243ulEmieUJvVb3H5X7TNyVuLKYx6oOrypz654dQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uEFryYF8rgeAZyHp+deAcYsojbMNRsGwvtxLRpl8dY4BmVYu69YKkiXAoM8CJRtCT0/YiIsCjcLvMEdgiYYrMmCxXpH1GPslmhr4MwG3NeIv8zcnRaSDqAq6XQ9F4v9l0yP+FoRdyQil8FvmPe0qGHEwkjOnGG8eCVl+Jk+wZAH+NDg10XpjXUv5OPpoRxqFAgG/It2bFpwib2PD1Lx6dPK7hgrF7iQ0YRMivZFXnNg00CbvgfsxEPe/sIVx+35Ss/4L82fL8b8f08MKVw+R+ERt9UwoTOiCjktFCAJAqrsVWz3Kk7S33uiCSOr7HxTTwSh2ex7tuUI6G8wG9QlKRP8iUP6gE0l3KyHilZL9UcZR+ZWjDgPHjZ8rRTRT5CIeiS4rpy/vv2Y9fK3/PwWFdKXOf5/QL4WXqIOg5KcCA8p7vj33WNuZNnPlEvu5/XuQbN5R1B4UkYBmoai1jFED59xDNlfU0VzNDZH7QKwaSqKy3dKwSfr97UYdNDKNnlb0f5RhRCGPBSVpfzgM7C3E2TTEoMrJXT9de7r7tazyr0ziiUwIgac+SMgi8OnSyEqytLEVWfT1JliiXleBMcr19jeMCElmD4wqbn1Esp8KjdmpMnAYiNkVk8WdzJhU1bb9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06881781-b41b-4fe4-9b7f-08df46aee568
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 02:35:09.9951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M13NMuZfbjUKlfV5ADQbJvLpAOnQclsi2ATOoO6T8sw/m5cQ+WHXq+Xg4J545/jl6dhtMS5osXawj9ljneZIKIXmb/FDDTyBSRHm3nBQyDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR04MB10048

On Nov 18, 2026 / 20:53, Shin'ichiro Kawasaki wrote:
> On Nov 17, 2026 / 11:48, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issues to consider:
> > - [Medium] RDMA/cma: unsafe lockdep_set_class() placement in
> >   rdma_listen()
> > - [Low] RDMA/cma: unreclassified handler_mutex on
> >   nvmet_rdma_enable_port() error
> 
> I think the two issues are valid. The first one means that the approach
> to reclassify ids in rdma_listen() does not work well. I will think about other
> solutions. One idea is to go back to the solutions to add a new function to
> create rdma id. The other idea is to reclassify the rdma ids not for
> listening. I will try if these approach can address the sashiko issues.

While I worked on the new patch to reclassify the rdma ids not for listening
but for other requests, I ran a local Sashiko review on it before posting.
Sashiko made the comment below, quote:

--- start ---
[Severity: Medium]
Is "this is not a real deadlock" true on iWARP?

All iw_cm_id events run on the single ordered iwcm_wq.  This includes the
connection ID's ESTABLISHED event, which goes through cma_iw_handler().
When the listening ID is destroyed, iw_destroy_cm_id() flushes iwcm_wq if
the ID's refcount is above 1.  A CONNECT_REQUEST still queued for that ID
is enough to raise it:

CPU0                                CPU1 (iw_cm_wq)
----                                ----
nvmet_port_subsys_drop_link()
  down_write(&nvmet_config_sem)
                                    cm_work_handler()
                                      cma_iw_handler()
                                        ...
                                          nvmet_execute_io_connect()
                                            down_read(&nvmet_config_sem)
  nvmet_rdma_disable_port()
    rdma_destroy_id(listen)
      ...
        iw_destroy_cm_id()
          flush_workqueue(iwcm_wq)
          <-- waits for CPU1 forever

The two handler_mutex instances are different.  But the destroy path still
waits for the connection ID's event work, so on siw, cxgb4 or irdma the
hang is real.  With the new class, lockdep no longer reports the
handler_mutex cycle here.  It only sees the iw_cm_wq dependency on runs
where the conditional flush actually happens.
--- end ---

My understanding of the comment is that the lockdep WARN that I'm trying to
suppress is not false-positive. To be precise, it is false-positive with rxe
driver, but not with siw driver or other drivers. I wanted to confirm that the
deadlock really happens, then I asked my AI to create a reproducer patch for
v7.4-rc3 kernel [2] and a reproducer script [3]. With these, I confirmed the
hang is recreated for real [4].

The reproducer patch [2] adds three msleep() calls to siw, nvme-rdma and nvmet-
rdma drivers to widen the reace windows. This is somewhat artificial, but I
think it indicates that the users can face the deadlock in real use cases. So
now I think the WARN should not be hidden and should be fixed properly.

Then I no longer think the cm_id handler mutex reclassification approch is
valid. Instaed, I would like to propose again the nvmet-rdma patch which
executes the commands of established queues in a work item outside the CM
handler [1]. I applied this nvmet-rdma patch on top of the reprodcuer patch, and
confirmed the hang does not happen.

Keith, may I ask your thoughts on this? If you think it's fine, I will revisit
the nvmet-rdma patch and repost [1].


[1] https://lore.kernel.org/linux-nvme/20260922124447.588057-1-shinichiro.kawasaki@opensource.wdc.com/


[2] hang reproducer kernel patch

From df6ffbbebda4bd080703701f0c11c4cfaad5247b Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Thu, 19 Nov 2026 20:13:24 +0900
Subject: [PATCH] REPRO ONLY: delays to reproduce nvmet-rdma hang on iWARP

---
 drivers/infiniband/sw/siw/siw_cm.c |  1 +
 drivers/nvme/host/rdma.c           |  2 ++
 drivers/nvme/target/rdma.c         |  2 ++
 repro-min.sh                       | 31 ++++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+)
 create mode 100755 repro-min.sh

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index ed49818793dd..bea7c7aacd67 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1738,6 +1738,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		siw_sk_assign_rtr_upcalls(cep);
 	} else {
 		siw_qp_socket_assoc(cep, qp);
+		msleep(300); /* REPRO: let the host send before ESTABLISHED */
 		rv = siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);
 		if (rv)
 			goto error;
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 32189fdfc0f5..e8c55dfad9d5 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -583,6 +583,8 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_queue *queue)
 	struct sockaddr *src_addr = NULL;
 	int ret;
 
+	if (idx == 2)
+		msleep(1000); /* REPRO: connect I/O queue 2 later */
 	mutex_init(&queue->queue_lock);
 	if (idx && ctrl->ctrl.max_integrity_segments)
 		queue->pi_support = true;
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index f386c388da18..cde0315ae71e 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1673,6 +1673,8 @@ static void nvmet_rdma_queue_established(struct nvmet_rdma_queue *queue)
 {
 	unsigned long flags;
 
+	if (queue->host_qid)
+		msleep(10000); /* REPRO: give time to unlink the port */
 	spin_lock_irqsave(&queue->state_lock, flags);
 	if (queue->state != NVMET_RDMA_Q_CONNECTING) {
 		pr_warn("trying to establish a connected queue\n");


[3] reproducer script (repro_min.sh)

#!/bin/bash
# Reproduce nvmet-rdma hang on iWARP (siw), with the REPRO delay patch applied.
IP=192.168.77.1
NQN=testnqn
CFS=/sys/kernel/config/nvmet

echo 30 > /proc/sys/kernel/hung_task_timeout_secs
ip link add dummy0 type dummy
ip addr add $IP/24 dev dummy0
ip link set dummy0 up
modprobe siw
rdma link add siw0 type siw netdev dummy0
modprobe null_blk
modprobe nvmet-rdma
modprobe nvme-rdma

mkdir $CFS/subsystems/$NQN
echo 1 > $CFS/subsystems/$NQN/attr_allow_any_host
mkdir $CFS/subsystems/$NQN/namespaces/1
echo /dev/nullb0 > $CFS/subsystems/$NQN/namespaces/1/device_path
echo 1 > $CFS/subsystems/$NQN/namespaces/1/enable
mkdir $CFS/ports/1
echo rdma > $CFS/ports/1/addr_trtype
echo ipv4 > $CFS/ports/1/addr_adrfam
echo $IP > $CFS/ports/1/addr_traddr
echo 4420 > $CFS/ports/1/addr_trsvcid
ln -s $CFS/subsystems/$NQN $CFS/ports/1/subsystems/$NQN

nvme connect -t rdma -a $IP -s 4420 -n $NQN --nr-io-queues=2 &
sleep 3
rm $CFS/ports/1/subsystems/$NQN	# hangs


[4] reproducer command log with virtme-ng

$ vng -v --user root --cpus 4 --memory 4G -- ./repro-min.sh .
virtme: waiting for virtiofsd to start
virtme: use 'microvm' QEMU architecture
early console in setup code
Probing EDD (edd=off to disable)... ok
[    0.000000][    T0] Linux version 7.4.0-rc3+ (shin@shinexp) (gcc (GCC) 16.2.1 20260819 (Red Hat 16.2.1-2), GNU ld version 2.46.1-1.fc44) #728 SMP PREEMPT_DYNAMIC Mon Nov 16 16:55:23 JST 2026
[    0.000000][    T0] Command line: virtme_hostname=virtme-ng nr_open=2147483584 virtme_link_mods=/home/shin/Linux/linux_2/.virtme_mods/lib/modules/0.0.0 virtme_rw_overlay0=/etc virtme_rw_overlay1=/lib virtme_rw_overlay2=/home virtme_rw_overlay3=/opt virtme_rw_overlay4=/srv virtme_rw_overlay5=/usr virtme_rw_overlay6=/var virtme_rw_overlay7=/tmp virtme_console=ttyS0 console=ttyS0 earlyprintk=serial,ttyS0,115200 panic=-1 virtme.exec=`Li9yZXByby1taW4uc2ggLg==` virtme_chdir=home/shin/Linux/linux_2 debug init=/usr/lib/python3.14/site-packages/virtme/guest/bin/virtme-ng-init
[    0.000000][    T0] x86/CPU: Model not found in latest microcode list
[    0.000000][    T0] BIOS-provided physical RAM map:
[    0.000000][    T0] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff]  System RAM
(snip)
[    9.479199][   T99] virtme-ng-init: waiting for udev to settle
[   10.680848][  T119] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
[   11.093015][   T99] virtme-ng-init: udev is done
[   11.097349][    T1] virtme-ng-init: starting script
[   11.517605][  T155] SoftiWARP attached
[   11.549884][  T165] dummy0 speed is unknown, defaulting to 1000
[   11.549944][  T165] dummy0 speed is unknown, defaulting to 1000
[   11.551299][  T165] dummy0 speed is unknown, defaulting to 1000
[   11.654536][  T166] null_blk: disk nullb0 created
[   11.655263][  T166] null_blk: module loaded
[   11.831301][  T168] Key type psk registered
[   12.102256][  T181] nvmet: adding nsid 1 to subsystem testnqn
[   12.156417][  T183] iwpm_register_pid: Unable to send a nlmsg (client = 2)
[   12.160751][  T183] nvmet_rdma: enabling port 1 (192.168.77.1:4420)
[   12.648901][  T187] nvmet: Created nvm controller 1 for subsystem testnqn for NQN nqn.2014-08.org.nvmexpress:uuid:26b20028-d00f-6e28-37b2-04d4c447b12c.
[   12.661514][  T184] nvme nvme0: creating 2 I/O queues.
[   12.662218][  T184] nvme nvme0: mapped 2/0/0 default/read/poll queues.
[   21.186230][  T191] nvme nvme0: I/O tag 0 (4000) opcode 0x18 (Admin Cmd) QID 0 timeout
[   21.190379][    C0] nvme nvme0: long keepalive RTT (5063 ms)
[   21.190410][    C0] nvme nvme0: failed nvme_keep_alive_end_io error=10
[   23.294680][  T189]
[   23.296090][  T189] ======================================================
[   23.299754][  T189] WARNING: possible circular locking dependency detected
[   23.300509][  T189] 7.4.0-rc3+ #728 Tainted: G            E
[   23.301157][  T189] ------------------------------------------------------
[   23.301858][  T189] kworker/u16:3/189 is trying to acquire lock:
[   23.302450][  T189] ffffffffc124a568 (nvmet_config_sem){++++}-{4:4}, at: nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
[   23.303464][  T189]
[   23.303464][  T189] but task is already holding lock:
[   23.304162][  T189] ffff8880bddf7420 (&id_priv->handler_mutex){+.+.}-{4:4}, at: cma_iw_handler+0xd7/0x5d0 [rdma_cm]
[   23.305177][  T189]
[   23.305177][  T189] which lock already depends on the new lock.
[   23.305177][  T189]
[   23.306156][  T189]
[   23.306156][  T189] the existing dependency chain (in reverse order) is:
[   23.307219][  T189]
[   23.307219][  T189] -> #1 (&id_priv->handler_mutex){+.+.}-{4:4}:
[   23.308289][  T189]        __mutex_lock+0x1a9/0x2550
[   23.308803][  T189]        rdma_destroy_id+0x17/0x20 [rdma_cm]
[   23.309506][  T189]        nvmet_rdma_disable_port+0x44/0x300 [nvmet_rdma]
[   23.310176][  T189]        nvmet_rdma_remove_port+0x42/0x60 [nvmet_rdma]
[   23.310881][  T189]        nvmet_disable_port+0xdc/0x1c0 [nvmet]
[   23.311546][  T189]        nvmet_port_subsys_drop_link+0x261/0x340 [nvmet]
[   23.312240][  T189]        configfs_unlink+0x36d/0x790
[   23.312773][  T189]        vfs_unlink+0x278/0xbc0
[   23.313256][  T189]        filename_unlinkat+0x31d/0x6b0
[   23.313797][  T189]        __x64_sys_unlinkat+0xae/0x100
[   23.314305][  T189]        do_syscall_64+0xf4/0x6b0
[   23.314790][  T189]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   23.315421][  T189]
[   23.315421][  T189] -> #0 (nvmet_config_sem){++++}-{4:4}:
[   23.316172][  T189]        __lock_acquire+0xe68/0x2490
[   23.316700][  T189]        lock_acquire+0x1b1/0x340
[   23.317192][  T189]        down_read+0xa1/0x530
[   23.317656][  T189]        nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
[   23.318303][  T189]        nvmet_ctrl_find_get+0xaa/0x320 [nvmet]
[   23.318930][  T189]        nvmet_execute_io_connect+0x1e0/0x3f0 [nvmet]
[   23.319605][  T189]        nvmet_rdma_execute_command+0x184/0x460 [nvmet_rdma]
[   23.320320][  T189]        nvmet_rdma_handle_command+0x733/0xaf0 [nvmet_rdma]
[   23.321032][  T189]        nvmet_rdma_cm_handler+0x930/0x3140 [nvmet_rdma]
[   23.321716][  T189]        cma_cm_event_handler+0xb0/0x3c0 [rdma_cm]
[   23.322357][  T189]        cma_iw_handler+0x31a/0x5d0 [rdma_cm]
[   23.322934][  T189]        cm_work_handler+0x1100/0x1920 [iw_cm]
[   23.323515][  T189]        process_one_work+0x944/0x1760
[   23.324043][  T189]        worker_thread+0x5fd/0xfe0
[   23.324547][  T189]        kthread+0x36d/0x470
[   23.325004][  T189]        ret_from_fork+0x653/0x9d0
[   23.325514][  T189]        ret_from_fork_asm+0x1a/0x30
[   23.326034][  T189]
[   23.326034][  T189] other info that might help us debug this:
[   23.326034][  T189]
[   23.327096][  T189]  Possible unsafe locking scenario:
[   23.327096][  T189]
[   23.327974][  T189]        CPU0                    CPU1
[   23.328585][  T189]        ----                    ----
[   23.329229][  T189]   lock(&id_priv->handler_mutex);
[   23.329844][  T189]                                lock(nvmet_config_sem);
[   23.330671][  T189]                                lock(&id_priv->handler_mutex);
[   23.331550][  T189]   rlock(nvmet_config_sem);
[   23.332082][  T189]
[   23.332082][  T189]  *** DEADLOCK ***
[   23.332082][  T189]
[   23.332967][  T189] locks held by kworker/u16:3/189: 3, on CPU#1:
[   23.333631][  T189]  #0: ffff8881077ca148 ((wq_completion)iw_cm_wq){+.+.}-{0:0}, at: process_one_work+0x1109/0x1760
[   23.334772][  T189]  #1: ffff888004367d10 ((work_completion)(&work->work)#2){+.+.}-{0:0}, at: process_one_work+0x8c0/0x1760
[   23.336779][  T189]  #2: ffff8880bddf7420 (&id_priv->handler_mutex){+.+.}-{4:4}, at: cma_iw_handler+0xd7/0x5d0 [rdma_cm]
[   23.337954][  T189]
[   23.337954][  T189] stack backtrace:
[   23.338590][  T189] CPU: 1 UID: 0 PID: 189 Comm: kworker/u16:3 Tainted: G            E       7.4.0-rc3+ #728 PREEMPT(full)
[   23.339775][  T189] Tainted: [E]=UNSIGNED_MODULE
[   23.340340][  T189] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.341335][  T189] Workqueue: iw_cm_wq cm_work_handler [iw_cm]
[   23.342133][  T189] Call Trace:
[   23.342517][  T189]  <TASK>
[   23.342916][  T189]  dump_stack_lvl+0x6a/0x90
[   23.343405][  T189]  print_circular_bug.cold+0x189/0x1eb
[   23.344037][  T189]  check_noncircular+0x173/0x1a0
[   23.344629][  T189]  __lock_acquire+0xe68/0x2490
[   23.345211][  T189]  lock_acquire+0x1b1/0x340
[   23.345996][  T189]  ? nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
[   23.347189][  T189]  ? __pfx___might_resched+0x10/0x10
[   23.347795][  T189]  down_read+0xa1/0x530
[   23.348240][  T189]  ? nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
[   23.349068][  T189]  ? __pfx_down_read+0x10/0x10
[   23.349602][  T189]  ? _raw_spin_unlock_irqrestore+0x35/0x60
[   23.350210][  T189]  ? stack_depot_save_flags+0x918/0xbd0
[   23.350969][  T189]  ? sg_miter_skip+0x19/0x3d0
[   23.351652][  T189]  nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
[   23.352319][  T189]  ? __pfx_nvmet_find_get_subsys+0x10/0x10 [nvmet]
[   23.353058][  T189]  ? sg_copy_buffer+0x19f/0x220
[   23.353650][  T189]  ? __pfx_sg_copy_buffer+0x10/0x10
[   23.354219][  T189]  nvmet_ctrl_find_get+0xaa/0x320 [nvmet]
[   23.354905][  T189]  ? __pfx_nvmet_ctrl_find_get+0x10/0x10 [nvmet]
[   23.355619][  T189]  ? __kmalloc_cache_noprof+0x2ce/0x6d0
[   23.356156][  T189]  nvmet_execute_io_connect+0x1e0/0x3f0 [nvmet]
[   23.356899][  T189]  nvmet_rdma_execute_command+0x184/0x460 [nvmet_rdma]
[   23.357616][  T189]  nvmet_rdma_handle_command+0x733/0xaf0 [nvmet_rdma]
[   23.358315][  T189]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   23.358947][  T189]  ? trace_hardirqs_on+0x14/0x190
[   23.359500][  T189]  nvmet_rdma_cm_handler+0x930/0x3140 [nvmet_rdma]
[   23.360246][  T189]  ? cma_iw_handler+0xd7/0x5d0 [rdma_cm]
[   23.360844][  T189]  ? lock_acquire+0x1c1/0x340
[   23.361326][  T189]  ? __pfx___might_resched+0x10/0x10
[   23.361968][  T189]  ? rcu_is_watching+0x12/0xb0
[   23.362467][  T189]  ? __pfx_nvmet_rdma_cm_handler+0x10/0x10 [nvmet_rdma]
[   23.363142][  T189]  ? ret_from_fork_asm+0x1a/0x30
[   23.363711][  T189]  ? cma_iw_handler+0xd7/0x5d0 [rdma_cm]
[   23.364345][  T189]  ? __pfx___mutex_lock+0x10/0x10
[   23.364893][  T189]  ? register_lock_class+0x4a/0x5a0
[   23.365489][  T189]  ? lock_is_held_type+0xf6/0x1b0
[   23.366005][  T189]  cma_cm_event_handler+0xb0/0x3c0 [rdma_cm]
[   23.366683][  T189]  cma_iw_handler+0x31a/0x5d0 [rdma_cm]
[   23.367225][  T189]  ? __pfx_cma_iw_handler+0x10/0x10 [rdma_cm]
[   23.367914][  T189]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   23.368574][  T189]  ? trace_hardirqs_on+0x14/0x190
[   23.369143][  T189]  cm_work_handler+0x1100/0x1920 [iw_cm]
[   23.369759][  T189]  ? __pfx_cm_work_handler+0x10/0x10 [iw_cm]
[   23.370397][  T189]  ? lock_acquire+0x1c1/0x340
[   23.370864][  T189]  ? process_one_work+0x7e0/0x1760
[   23.371366][  T189]  process_one_work+0x944/0x1760
[   23.371859][  T189]  ? __pfx_process_one_work+0x10/0x10
[   23.372384][  T189]  ? rcuwait_wake_up+0x1e/0x190
[   23.372873][  T189]  worker_thread+0x5fd/0xfe0
[   23.373331][  T189]  ? __pfx_worker_thread+0x10/0x10
[   23.373829][  T189]  kthread+0x36d/0x470
[   23.374231][  T189]  ? __pfx_kthread+0x10/0x10
[   23.374687][  T189]  ret_from_fork+0x653/0x9d0
[   23.375140][  T189]  ? __pfx_ret_from_fork+0x10/0x10
[   23.375644][  T189]  ? __switch_to+0x3a9/0xd90
[   23.376101][  T189]  ? __switch_to_asm+0x39/0x70
[   23.376571][  T189]  ? __switch_to_asm+0x33/0x70
[   23.377039][  T189]  ? __pfx_kthread+0x10/0x10
[   23.377496][  T189]  ret_from_fork_asm+0x1a/0x30
[   23.377969][  T189]  </TASK>
[   43.265793][  T188] nvme nvme0: I/O tag 0 (0000) opcode 0x7f (Fabrics Cmd) QID 1 timeout
[   43.265925][   T50] nvme nvme0: Connect command failed, error wo/DNR bit: 881
[   43.266970][   T50] nvme nvme0: failed to connect queue: 1 ret=881
[   61.182016][   T48] INFO: task kworker/u16:1:14 blocked for more than 30 seconds.
[   61.182047][   T48]       Tainted: G            E       7.4.0-rc3+ #728
[   61.182058][   T48] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   61.182074][   T48] task:kworker/u16:1   state:D stack:0     pid:14    tgid:14    ppid:2      task_flags:0x4208060 flags:0x00080000
[   61.182104][   T48] Workqueue: nvmet-wq nvmet_rdma_release_queue_work [nvmet_rdma]
[   61.182149][   T48] Call Trace:
[   61.182158][   T48]  <TASK>
[   61.182176][   T48]  __schedule+0x1dbe/0x7a90
[   61.182233][   T48]  ? lock_acquire+0x1b1/0x340
[   61.182255][   T48]  ? __pfx___schedule+0x10/0x10
[   61.182279][   T48]  ? schedule+0x24a/0x2e0
[   61.182295][   T48]  ? lock_release+0x1b5/0x340
[   61.182316][   T48]  schedule+0xe3/0x2e0
[   61.182337][   T48]  schedule_timeout+0x1ac/0x290
[   61.182356][   T48]  ? __pfx_schedule_timeout+0x10/0x10
[   61.182392][   T48]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   61.182406][   T48]  ? trace_hardirqs_on+0x14/0x190
[   61.182428][   T48]  wait_for_completion+0x17a/0x400
[   61.182452][   T48]  ? __pfx_wait_for_completion+0x10/0x10
[   61.182470][   T48]  ? touch_wq_lockdep_map+0x87/0x1c0
[   61.182503][   T48]  __flush_workqueue+0x3a9/0x10c0
[   61.182521][   T48]  ? do_raw_spin_lock+0x12d/0x280
[   61.182554][   T48]  ? __pfx___flush_workqueue+0x10/0x10
[   61.182570][   T48]  ? _raw_spin_unlock_irqrestore+0x4c/0x60
[   61.182591][   T48]  ? siw_qp_put_ref+0x1e/0x60 [siw]
[   61.182763][   T48]  ? _raw_spin_unlock_irqrestore+0x4c/0x60
[   61.182796][   T48]  iw_destroy_cm_id+0x5e/0x80 [iw_cm]
[   61.182836][   T48]  _destroy_id+0x657/0xcf0 [rdma_cm]
[   61.182954][   T48]  nvmet_rdma_free_queue+0x48b/0x9d0 [nvmet_rdma]
[   61.182984][   T48]  ? __lock_acquire+0x1297/0x2490
[   61.183020][   T48]  ? __pfx_nvmet_rdma_free_queue+0x10/0x10 [nvmet_rdma]
[   61.183050][   T48]  ? lock_acquire+0x1c1/0x340
[   61.183076][   T48]  nvmet_rdma_release_queue_work+0x3e/0x90 [nvmet_rdma]
[   61.183106][   T48]  process_one_work+0x944/0x1760
[   61.183148][   T48]  ? __pfx_process_one_work+0x10/0x10
[   61.183168][   T48]  ? lock_acquire+0x1b1/0x340
[   61.183210][   T48]  worker_thread+0x5fd/0xfe0
[   61.183250][   T48]  ? __pfx_worker_thread+0x10/0x10
[   61.183267][   T48]  kthread+0x36d/0x470
[   61.183286][   T48]  ? __pfx_kthread+0x10/0x10
[   61.183304][   T48]  ret_from_fork+0x653/0x9d0
[   61.183329][   T48]  ? __pfx_ret_from_fork+0x10/0x10
[   61.183352][   T48]  ? __switch_to+0x3a9/0xd90
[   61.183367][   T48]  ? __switch_to_asm+0x39/0x70
[   61.183381][   T48]  ? __switch_to_asm+0x33/0x70
[   61.183394][   T48]  ? __pfx_kthread+0x10/0x10
[   61.183413][   T48]  ret_from_fork_asm+0x1a/0x30
[   61.183456][   T48]  </TASK>
[   61.183505][   T48] INFO: task kworker/u16:3:189 blocked for more than 30 seconds.
[   61.183520][   T48]       Tainted: G            E       7.4.0-rc3+ #728
[   61.183529][   T48] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   61.183536][   T48] task:kworker/u16:3   state:D stack:0     pid:189   tgid:189   ppid:2      task_flags:0x4208060 flags:0x00080000
[   61.183560][   T48] Workqueue: iw_cm_wq cm_work_handler [iw_cm]
[   61.183598][   T48] Call Trace:
[   61.183605][   T48]  <TASK>
[   61.183619][   T48]  __schedule+0x1dbe/0x7a90
[   61.183643][   T48]  ? rcu_is_watching+0x12/0xb0
[   61.183721][   T48]  ? nbcon_cpu_emergency_exit+0xd7/0x160
[   61.183752][   T48]  ? __printk_cpu_sync_put+0x31/0x60
[   61.183777][   T48]  ? __pfx_nbcon_cpu_emergency_exit+0x10/0x10
[   61.183795][   T48]  ? __pfx___schedule+0x10/0x10
[   61.183816][   T48]  ? lock_acquire+0x2f5/0x340
[   61.183828][   T48]  ? rcu_is_watching+0x12/0xb0
[   61.183846][   T48]  ? lock_release+0x285/0x340
[   61.183867][   T48]  schedule+0xe3/0x2e0
[   61.183886][   T48]  ? rwsem_down_read_slowpath+0x31e/0x1120
[   61.183934][   T48]  schedule_preempt_disabled+0x14/0x30
[   61.183953][   T48]  rwsem_down_read_slowpath+0x61e/0x1120
[   61.183968][   T48]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
[   61.183993][   T48]  ? __pfx_rwsem_down_read_slowpath+0x10/0x10
[   61.184028][   T48]  ? __pfx___might_resched+0x10/0x10
[   61.184058][   T48]  down_read+0xf5/0x530
[   61.184077][   T48]  ? __pfx_down_read+0x10/0x10
[   61.184091][   T48]  ? _raw_spin_unlock_irqrestore+0x35/0x60
[   61.184110][   T48]  ? stack_depot_save_flags+0x918/0xbd0
[   61.184131][   T48]  ? sg_miter_skip+0x19/0x3d0
[   61.184154][   T48]  nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
[   61.184265][   T48]  ? __pfx_nvmet_find_get_subsys+0x10/0x10 [nvmet]
[   61.184366][   T48]  ? sg_copy_buffer+0x19f/0x220
[   61.184384][   T48]  ? __pfx_sg_copy_buffer+0x10/0x10
[   61.184409][   T48]  nvmet_ctrl_find_get+0xaa/0x320 [nvmet]
[   61.184523][   T48]  ? __pfx_nvmet_ctrl_find_get+0x10/0x10 [nvmet]
[   61.184741][   T48]  ? __kmalloc_cache_noprof+0x2ce/0x6d0
[   61.184778][   T48]  nvmet_execute_io_connect+0x1e0/0x3f0 [nvmet]
[   61.184919][   T48]  nvmet_rdma_execute_command+0x184/0x460 [nvmet_rdma]
[   61.184958][   T48]  nvmet_rdma_handle_command+0x733/0xaf0 [nvmet_rdma]
[   61.184988][   T48]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   61.185004][   T48]  ? trace_hardirqs_on+0x14/0x190
[   61.185027][   T48]  nvmet_rdma_cm_handler+0x930/0x3140 [nvmet_rdma]
[   61.185062][   T48]  ? cma_iw_handler+0xd7/0x5d0 [rdma_cm]
[   61.185141][   T48]  ? lock_acquire+0x1c1/0x340
[   61.185157][   T48]  ? __pfx___might_resched+0x10/0x10
[   61.185182][   T48]  ? rcu_is_watching+0x12/0xb0
[   61.185203][   T48]  ? __pfx_nvmet_rdma_cm_handler+0x10/0x10 [nvmet_rdma]
[   61.185232][   T48]  ? ret_from_fork_asm+0x1a/0x30
[   61.185246][   T48]  ? cma_iw_handler+0xd7/0x5d0 [rdma_cm]
[   61.185328][   T48]  ? __pfx___mutex_lock+0x10/0x10
[   61.185347][   T48]  ? register_lock_class+0x4a/0x5a0
[   61.185377][   T48]  ? lock_is_held_type+0xf6/0x1b0
[   61.185405][   T48]  cma_cm_event_handler+0xb0/0x3c0 [rdma_cm]
[   61.185486][   T48]  cma_iw_handler+0x31a/0x5d0 [rdma_cm]
[   61.185566][   T48]  ? __pfx_cma_iw_handler+0x10/0x10 [rdma_cm]
[   61.185659][   T48]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   61.185710][   T48]  ? trace_hardirqs_on+0x14/0x190
[   61.185735][   T48]  cm_work_handler+0x1100/0x1920 [iw_cm]
[   61.185779][   T48]  ? __pfx_cm_work_handler+0x10/0x10 [iw_cm]
[   61.185861][   T48]  ? lock_acquire+0x1c1/0x340
[   61.185880][   T48]  ? process_one_work+0x7e0/0x1760
[   61.185927][   T48]  process_one_work+0x944/0x1760
[   61.185968][   T48]  ? __pfx_process_one_work+0x10/0x10
[   61.185990][   T48]  ? rcuwait_wake_up+0x1e/0x190
[   61.186032][   T48]  worker_thread+0x5fd/0xfe0
[   61.186072][   T48]  ? __pfx_worker_thread+0x10/0x10
[   61.186089][   T48]  kthread+0x36d/0x470
[   61.186106][   T48]  ? __pfx_kthread+0x10/0x10
[   61.186125][   T48]  ret_from_fork+0x653/0x9d0
[   61.186147][   T48]  ? __pfx_ret_from_fork+0x10/0x10
[   61.186170][   T48]  ? __switch_to+0x3a9/0xd90
[   61.186184][   T48]  ? __switch_to_asm+0x39/0x70
[   61.186197][   T48]  ? __switch_to_asm+0x33/0x70
[   61.186211][   T48]  ? __pfx_kthread+0x10/0x10
[   61.186229][   T48]  ret_from_fork_asm+0x1a/0x30
[   61.186271][   T48]  </TASK>
[   61.186294][   T48] INFO: task kworker/u16:3:189 <reader> blocked on an rw-semaphore likely owned by task rm:194 <writer>
[   61.186311][   T48] INFO: task rm:194 blocked for more than 30 seconds.
[   61.186324][   T48]       Tainted: G            E       7.4.0-rc3+ #728
[   61.186333][   T48] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   61.186339][   T48] task:rm              state:D stack:0     pid:194   tgid:194   ppid:149    task_flags:0x400000 flags:0x00080000
[   61.186361][   T48] Call Trace:
[   61.186368][   T48]  <TASK>
[   61.186382][   T48]  __schedule+0x1dbe/0x7a90
[   61.186427][   T48]  ? lock_acquire+0x1b1/0x340
[   61.186445][   T48]  ? __pfx___schedule+0x10/0x10
[   61.186461][   T48]  ? lock_acquire+0x1c1/0x340
[   61.186479][   T48]  ? schedule+0x24a/0x2e0
[   61.186494][   T48]  ? lock_release+0x1b5/0x340
[   61.186515][   T48]  schedule+0xe3/0x2e0
[   61.186535][   T48]  schedule_timeout+0x1ac/0x290
[   61.186553][   T48]  ? __pfx_schedule_timeout+0x10/0x10
[   61.186589][   T48]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   61.186603][   T48]  ? trace_hardirqs_on+0x14/0x190
[   61.186623][   T48]  wait_for_completion+0x17a/0x400
[   61.186647][   T48]  ? __pfx_wait_for_completion+0x10/0x10
[   61.186665][   T48]  ? touch_wq_lockdep_map+0x87/0x1c0
[   61.186744][   T48]  __flush_workqueue+0x3a9/0x10c0
[   61.186763][   T48]  ? do_raw_spin_lock+0x12d/0x280
[   61.186792][   T48]  ? lockdep_hardirqs_on_prepare+0xd5/0x1b0
[   61.186808][   T48]  ? __pfx___flush_workqueue+0x10/0x10
[   61.186823][   T48]  ? lockdep_hardirqs_on+0x91/0x140
[   61.186840][   T48]  ? _raw_spin_unlock_irqrestore+0x4c/0x60
[   61.186857][   T48]  ? _raw_spin_unlock_irqrestore+0x35/0x60
[   61.186914][   T48]  ? mark_held_locks+0x40/0x70
[   61.186942][   T48]  iw_destroy_cm_id+0x5e/0x80 [iw_cm]
[   61.186979][   T48]  _destroy_id+0x657/0xcf0 [rdma_cm]
[   61.187071][   T48]  nvmet_rdma_disable_port+0x44/0x300 [nvmet_rdma]
[   61.187112][   T48]  nvmet_rdma_remove_port+0x42/0x60 [nvmet_rdma]
[   61.187141][   T48]  nvmet_disable_port+0xdc/0x1c0 [nvmet]
[   61.187248][   T48]  nvmet_port_subsys_drop_link+0x261/0x340 [nvmet]
[   61.187355][   T48]  ? simple_unlink+0xae/0x100
[   61.187400][   T48]  ? do_raw_spin_unlock+0x147/0x220
[   61.187403][   T48]  ? __pfx_nvmet_port_subsys_drop_link+0x10/0x10 [nvmet]
[   61.187421][   T48]  configfs_unlink+0x36d/0x790
[   61.187428][   T48]  vfs_unlink+0x278/0xbc0
[   61.187437][   T48]  filename_unlinkat+0x31d/0x6b0
[   61.187441][   T48]  ? __pfx_filename_unlinkat+0x10/0x10
[   61.187444][   T48]  ? __virt_addr_valid+0x228/0x500
[   61.187453][   T48]  ? __check_object_size+0x45a/0x620
[   61.187463][   T48]  __x64_sys_unlinkat+0xae/0x100
[   61.187467][   T48]  do_syscall_64+0xf4/0x6b0
[   61.187471][   T48]  ? exc_page_fault+0x94/0x140
[   61.187474][   T48]  ? lock_release+0x1b5/0x340
[   61.187477][   T48]  ? rcu_is_watching+0x12/0xb0
[   61.187480][   T48]  ? do_syscall_64+0x2d/0x6b0
[   61.187483][   T48]  ? trace_hardirqs_off_finish+0x139/0x180
[   61.187486][   T48]  ? lockdep_hardirqs_off+0xaf/0xf0
[   61.187489][   T48]  ? do_syscall_64+0x60/0x6b0
[   61.187491][   T48]  ? clear_bhb_loop+0x30/0x80
[   61.187495][   T48]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   61.187498][   T48] RIP: 0033:0x7f63b6a93e8b
[   61.187501][   T48] RSP: 002b:00007ffdb9dc50d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000107
[   61.187508][   T48] RAX: ffffffffffffffda RBX: 000055768b2ad310 RCX: 00007f63b6a93e8b
[   61.187510][   T48] RDX: 0000000000000000 RSI: 000055768b2ac0f0 RDI: 00000000ffffff9c
[   61.187511][   T48] RBP: 00007ffdb9dc51a0 R08: 0000000000000003 R09: 00007ffdb9dc51ec
[   61.187513][   T48] R10: 0000000000000000 R11: 0000000000000246 R12: 000055768b2ac060
[   61.187515][   T48] R13: 0000000000000000 R14: 00007ffdb9dc51f0 R15: 0000000000000002
[   61.187521][   T48]  </TASK>
[   61.187523][   T48] INFO: lockdep is turned off.
[   91.389938][   T48] INFO: task kworker/u16:1:14 blocked for more than 60 seconds.
[   91.389969][   T48]       Tainted: G            E       7.4.0-rc3+ #728
[   91.389981][   T48] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
(snip)

