Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020117.outbound.protection.outlook.com [40.93.198.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F2641443D;
	Thu, 10 Sep 2026 20:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789070462; cv=fail; b=J5Z2ENB/89JvqV4GC8AvfNGqRTL0JW/7HMn4kN+77aSY8gY+0BmzCkxR2AlkV32/al/ZyZ8vpclLT7pDJYV4uwNTnpIB1zavO6NaBcevndk1rZQMBmmeMDdmEbk5d5ycnTM11V1TYvLzejILRg7Xb83t8aSQOiyIqCqJei0itGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789070462; c=relaxed/simple;
	bh=UN7jVSi1Rzl9n1deCk9RFYXpu2b/ISZy7FBsf1AUcm4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YhJAJl17zBkn/kiIsgF3J6/1ZjD99ytKXw+GRqknsjAM39cywlmNgQYWsvqib+U0pONXXdAs0DLA891vyaE4LLPyyOZIZrI2v/TXf1a1iQiTD19JK20pA32+YsyrVw2R6jOo6wAZdPJYT/YJL3b2E8YMV9nZDms9WPRvr+yB7N0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=KpNxT5ON; arc=fail smtp.client-ip=40.93.198.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="KpNxT5ON"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fC2+xXAjvJqYN8HeI/O2PQmi03iqa+vaAhhrjIjPFExygymE7voGe85At5YUxXo/83WW2gieDaEx/5PcrBbI41ldhn5wTXSAiTDdwkZ5XcPrJo9zhEv9BdAxzSivYKhRaFiQeqKgdS+CXSEhUPOdu8i/89EWSdRawQBbIN+2EroJLEmioOWf83pLLxR+rurHgoOnuw8Rlbb4FwGi3TF/oVdqczyK7FaA2fmavICHxYepJ1a73PsRYKiTTh5LeHUmqNGj+pH4GG0a2uUdlP4S8vHcO/NZ4xPZ+iFdhlHCPy3fjrVa09sWbrsd7fK7easAyXTJTZjl/kO0h9q9SrN8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JE3sKJgeV2PvsQgq+G6lEqsGGcS0tLc6DM9LesawalA=;
 b=mwCrEE2wTWgSgeb3+Uvgc5NI+G5aRCpfg01cWeRvpe0FKQicP/tmkTPO5etpwltGHKsNpFg1/OYf1dRevaTRUZrP8xI9+FHiSPifLfBMnhqbWJBGbN+K2VOLpmW5qRF8gSZ02fk8wg8Xlt71HGd99NKTT/CkRS1rrNico3BhuhKST/cag6QKZW8XpMdPq+IXdZPRW+ANLv2xrdjRTn+FL6GZuPWkWvZ542PhHJGvia1SotliIMBAehSlaUWW/Uy0rBZS7KdK10WV+VC1mN6xj9KTJjfLxdImqsQvkAHrXjljv/2itT2Pb/lIDlYlxye0XDz8YY1oU/mZ9fgYRqtxTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JE3sKJgeV2PvsQgq+G6lEqsGGcS0tLc6DM9LesawalA=;
 b=KpNxT5ONrbCr3oZrwo8/9UYIrRotOlhR5EGXg88ds5DGhTPsXvjSruOrQepIdmRqFVGUVDR6Ft7/DLYD9eYMbXD4NwAKFNeYyOtqpVzU8+9xQi3EEkCKuYe2a31kqDN+U6C0G7eysE6/8rTVEUIx0Rdq8StwgAL+Zjo2aDIokl0=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by LV5PR21MB5282.namprd21.prod.outlook.com (2603:10b6:408:302::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 20:00:54 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 20:00:53 +0000
From: Long Li <longli@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
	<davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
	<haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>, Simon
 Horman <horms@kernel.org>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "shirazsaleem@microsoft.com"
	<shirazsaleem@microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net] net: mana: do not discard an
 ethtool-configured RSS table on a queue rebuild
Thread-Topic: [EXTERNAL] Re: [PATCH net] net: mana: do not discard an
 ethtool-configured RSS table on a queue rebuild
Thread-Index: AQHdPM/AFo/mFPjv3kSEyv8Y/PH4f7bH9ZIAgABO0gA=
Date: Thu, 10 Sep 2026 20:00:52 +0000
Message-ID:
 <SA1PR21MB668352D9E929B8BBC7DA1BA7CEBF2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260905004401.3937066-1-longli@microsoft.com>
 <20260910081814.1b5b7b36@kernel.org>
In-Reply-To: <20260910081814.1b5b7b36@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ecf67674-d1ce-49dd-8721-21c003a04764;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-10T20:00:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|LV5PR21MB5282:EE_
x-ms-office365-filtering-correlation-id: 27dabc8e-4437-4076-7636-08df0f763881
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003|7146999003|38070700021;
x-microsoft-antispam-message-info:
 DI64J5zp8gLZAhDPSrdqNtn/5QoO0safMJzdADfNEtNB9kNQ7F/Sy+sxGVGn4AYy6zIIAMjMmiHTo1tRzzC5XmbXY15NbAynHCYsU1ja3PDbuhB4R0bLU/fG9/JpCY3FDpyt4hJ4FSGdtwI/Iv753hmZflIUY5NMF0ZOHLaMqFl/f0hqHAOjHJxlQT7nuPRtKZJlyuS9VhJxZJOwHCx8oJgLuyGPw8TQmhYdT0Nj8+HiJpfEkBhofDUTbb3wK/YkETJQjDuqYOuAp/JMUMoFKGfpcJZSDsMpw5FmW4Co8iKip5HyO6caV8vNd7ywREufy5J0/HqD1akN3bV22IiDGgJ7IlOzdyhgEG/0MpfK3bwPucIlHY03MdXOiNnM5lg59tgpB3Tejcrp0siTR0WYgds8Mosbf1IxeDHWFqoL0wE6QrM3c7Xz5LBMR/3qIqTe4ehoIWUp3xV8UAgtE/AWqSkn/mKVXXRuEVkFMjekOk+kgE/EL3rctD1pfFwDhsszlw6D27bmjgCGJqcnZCltpqKidNftCheDWRDBUQLDBN+QR/hRVIrMp3oQor5vBDlZeXALtpfEdB2kFSERueHXUhkn4efUMd8liDFQVyCLiGlcx8bifEh1KkXCRmLla2Q2R05QxBzmg7hZSjjFUOvJcdKv8zFjh+3hNyyQPwZyFiNxAaANu6ULaJYmBnOTTS3SHfpMGLq2JisuUn6RqOx2jU2+y/qJ+zMMYxoEIJ6Jr5Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(7146999003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?B+2OiuxMXXq8qPDEfkPbTwv6bqNQLY8jBt8Ro/EZSHlBBc4SqsNousNtmNly?=
 =?us-ascii?Q?qfFBvmRyKL1B4TvU9CjxPpMGOFipkmkqvx701RVWJA2yrgVtkCM4asiLRA2k?=
 =?us-ascii?Q?PtjW6RmyalZarqWc4YNtNAHLdFOpAi9l5xa91nzNstWUahI8KJI4ljBjpIDw?=
 =?us-ascii?Q?Ff5GZ0svjAhHC9EO8hN6JSoD5US0vZwpnaaKaBacC+6CnWghwVnDHwns8/ZG?=
 =?us-ascii?Q?J/Y9jLCt7PCTjMk27Ep4E0JKRFbencW0ppjnk53wCpupqH48Ds85cLZYu6Gy?=
 =?us-ascii?Q?zWK5ST4HLYk918i+PO8fyzQZ0VVYa8FJ4fctxzqkyJeVqaqIJ8kUT1Cm3snX?=
 =?us-ascii?Q?wbn7M1ZGw1M4yQYTmj4e1oOjCkA/t2aZTBvPdTJ1E99c9BPHUNnzbjD/GkC7?=
 =?us-ascii?Q?VeV/1KcKgtSIDhTBo3XsOVraWM/qHcR3li9skgGW7ppfqMWPJhhCUIfLTGxO?=
 =?us-ascii?Q?LNAa10TvtwvCcimnPbrn7wH/+Z9pnhDwJUeRmNFX+eWSICQB9lAOtqXccnxZ?=
 =?us-ascii?Q?cY2MJH91BlhdPQPf6Uy7U/XHU4a+TIGAbHWj2Jqfedtf7Psbd0a6hYSbcav9?=
 =?us-ascii?Q?b+mRa30r5qtLXsYu0rAPC8AeVy1eEo8AudNFucaBo/hAa+JzDRGtiyPqOKLG?=
 =?us-ascii?Q?dSNXZUa0twYHopmv9dJ0frao2EB8zU23YDuMNrS7R3WwW467xvvC/PJZdAaB?=
 =?us-ascii?Q?UBBIwZHysCWmaoBKnkznnC4jamTQ0pf7vDHqMyG+3L/oiAdFh9SVYQ9RB66h?=
 =?us-ascii?Q?3M0m02pzyew2KzyWnbT2oKEsuK9TCV9BtPk6K35Q0yZ7btj21BEFS+yG9w1X?=
 =?us-ascii?Q?vQHXJKQ/8N0DoQrByXiCpWChPlSrjbkhWqPyrKHq/69Pxuz9ErEAk3XagpQu?=
 =?us-ascii?Q?EUChENWsuki5DphRSMkwP9kn6Sxk5QvANxKlrkCnzdlw+mtcw0MAWOMib/qk?=
 =?us-ascii?Q?PRRxMUUshJQlHfe3Vk8lOi7WLaOqo0fKiVRne34uA71ZDKXGLCui5tXu5wPO?=
 =?us-ascii?Q?8ERzIUwYVpnFkOnrn08hBUr3A0uguUDLF5O0gRsTWKwAGA9tRdRupvFIq/Ku?=
 =?us-ascii?Q?8xO/p3ScQdO9k9I8ttiQCf5CEFBZXDFKeViNSBMCSb0qe9bFPJrn/UR45J4i?=
 =?us-ascii?Q?GLtwJqasusV9VREXesdJ15Tz2a3kB26NYK6R7p7YOezgfQmlYQvinKdfXT+U?=
 =?us-ascii?Q?Eyoirvuaq1CW8oQg8nYrPKjHn/6teaqh67ZJr5STgz5Ml1n7nEybOgKB1rsO?=
 =?us-ascii?Q?zFoX7vTyUuBKeCXm43N1QRVzS/JyWzISFkToFYRAuoGeYjqO9g+khFLqgleM?=
 =?us-ascii?Q?fIFpktjkjN39Bgj32TzT2hmy1n/tzpG9/FLvhXtKxJofhPS5bQ+jYMCLiXLx?=
 =?us-ascii?Q?CjWaYew6mjNWIQ2EQluc5gWtPzDvoh5rvpFPsFrhvo25lw6XCR/tjKbApEU2?=
 =?us-ascii?Q?hYU1lQ6r/OcuDV9z/rjuZyF9ebFW2KQRq2m4fwTc++5Ug+THbqFcmnhYYVGe?=
 =?us-ascii?Q?xh2DD14P/DE/mFe88yWjrceayeoocWSTIKrXkZ4EXhTugOQqirJOJ7+dP/Os?=
 =?us-ascii?Q?1cjjjWLxO3LrJF84zmaZay4ShdTmC1E5ImZvIGD0oVlv7MLRdxVze+HM8B29?=
 =?us-ascii?Q?Wq0bT/09RVNYkd+6dD5KY4Eh/Xb4zTAhE/7hiwDVvAaJu0msSq7T8DLSFrGB?=
 =?us-ascii?Q?zQ5jC0ogNQwxrljvO2afrwmstKes/fYjw8pwr216GCpG1iu9?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6683.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27dabc8e-4437-4076-7636-08df0f763881
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2026 20:00:52.4084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ppLAswL/53b7SLFXInIyZx/HP+FpeHxXEr0ifBqzE8sLSzvbUhwJFTRH1nDTTlf/6ukxxhV0W5NAeB19qJgCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR21MB5282

> On Fri,  4 Sep 2026 17:44:01 -0700 Long Li wrote:
> > mana_alloc_queues() regenerates the RSS indirection table from the
> > driver default every time the queues are built, so a table installed
> > with "ethtool -X" is silently replaced by any operation that rebuilds t=
hem:
> > an MTU change, a ring-size, channel-count or private-flag change, an
> > XDP attach, TX-timeout reset recovery, or resume.
> >
> > The driver never clears the core's IFF_RXFH_CONFIGURED, so
> > netif_is_rxfh_configured() keeps reporting a user table while the
> > hardware has been reprogrammed with the default one. "ethtool -x" then
> > shows a table the user did not ask for, with no indication it changed:
> >
> >   # ethtool -X ens1 equal 2
> >   # ethtool -x ens1
> >   RX flow hash indirection table for ens1 with 16 RX ring(s):
> >       0:      0     1     0     1     0     1     0     1
> >       8:      0     1     0     1     0     1     0     1
> >   # ip link set ens1 mtu 1400
> >   # ethtool -x ens1
> >   RX flow hash indirection table for ens1 with 16 RX ring(s):
> >       0:      0     1     2     3     4     5     6     7
> >       8:      8     9    10    11    12    13    14    15
> >
> > Keep the table instead, and rebuild it only when it is
> > driver-generated or cannot be honoured. An entry may not be kept if it
> > points past the last queue: mana_config_rss() uses these entries to
> > index apc->rxqs[], which holds apc->num_queues pointers. That is
> > reachable because
> > mana_attach() calls mana_init_port(), which lowers apc->num_queues to
> > the maximum the device reports, so a table configured for more queues
> > can outlive them.
>=20
> To be clear this is only acceptable if the number of queues drops due to =
re-
> negotiation of caps with the device, not for example if XDP requires some
> queues to be used for other purposes. In the latter case just refuse the =
config
> change.
>=20
> > A table that cannot be kept is still replaced by the default silently,
> > without ethtool_rxfh_indir_lost(). That helper sends
> > ETHTOOL_MSG_RSS_NTF, which requires the netdev instance lock, and
> > mana_alloc_queues() runs both with that lock held, from ndo_open, and
> > without it, from mana_attach() on the reset and resume paths. Leaving
> > the core's view untouched is what the driver did for every table
> > before this change.
>=20
> Okay, so you have a problem of not having the lock...
>=20
> > Opt the RSS ethtool operations into rtnl_lock() while here. Reading
> > the table in mana_alloc_queues() has to be serialized against
> > mana_set_rxfh() replacing it, and the two had no lock in common:
> > mana_set_rxfh() ran under the netdev instance lock alone, while
> > mana_alloc_queues() reaches this point holding only RTNL, from
> > ndo_open and from mana_attach() on the reset and resume paths. Taking
> > the instance lock there instead is not possible, since ndo_open
> > already runs with it held. The same flag covers the netlink and ioctl e=
ntry
> points.
>=20
> .. and yet your fix is not to try to take it but the reverse, to add a di=
fferent
> lock? You need to explain why reset path can't take the instance lock. Of
> course you can't take it _inside_ ndo_open, but the caller should be able=
 to.

Okay, will send a patch implementing the locks.
