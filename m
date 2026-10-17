Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021074.outbound.protection.outlook.com [40.93.194.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35215331EBE;
	Sat, 17 Oct 2026 23:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792278205; cv=fail; b=YGMCk0v/D4mStczkN5OA01/kBiN/Gw+ouWJJUbY1zEZIU1xDIUtoEz1yD3ZwZHzaRHI4viPjnJW3N/kMPhRlcfjzsDqH3/Qw4BDW4yVkTRuKrTJ4niRluUARP62oKRHyk+wu5pfon/NSP8R0G9rNJl1kmoYhW0MeKidnHNF432Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792278205; c=relaxed/simple;
	bh=2GxBJsP2NALREQipAi340wErOUxkP/Pwn+FBzORgLd4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LhGvThHHFMVy2zchfiveUOKpZP772ZURRiJ2QAAjD1oLUhnzrBG6Qw8n1cgY3Li2GqME+Zu+lounaCNfHngCbdXG6SjnbbQ2J9WwW11sfL4zHkEjUQHRvYerxFojHxNrIaOTaHUDfaSTT5AYz6GY0GtrprtCokgWYJkIYbGYfDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=WCPQH/QW; arc=fail smtp.client-ip=40.93.194.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="WCPQH/QW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6tb8yM5OBKrYOtesqueJ+VpevHxFDeU7vEA3KtOWscBwEVSOQG+ADiMW6IvPR6UgcIOttV63MFM/jRc3Hcy/sx5n9RPsS4C4yXylNzNSxVy6Ea5CiJwILFJsoYIGaRDQel0DYk9s1TktxUtMLKJQEvr4T277xLPhlgZnz79/AFR5n/fuQiAgwkKl09trURdQoiAOGWZX1cxh9At/d76aV7j7c/QvBhtJ/bOd2OlJ10uPZfEVHifV8YGPIWUBXWr0e11d2j9iun7BG4VIUblqndc8hNxDSoAteDSUNuD+l5PfMjPs4IlQK0zUPJzUSZixH1SH8LYtTuUv7xv1EfeWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5WmhWi1rUKXwYaT8TCAmtANKiAkHra7M8wBF4rQIA4=;
 b=qa37pOkaZjn4idxp4VqeLRazZLhaR2csjmU7kdK8GfZ/wyPZAT0YGGIWRD1bLelhhIiuMMPq4soRebd6iLiIkVMXsy35RE687HnmP4sz+Xn4Pz/rHDpUJBJE9qv1AFCgkyDMoclMAiPD+JqUIK4qHReIKXVpKSO8CmPzfh6ZMdI1jOJ+m6f7UhgcOF6eXtPNeIl1c7I29iGX0J2OWLJy8mMP3snP5KErAsXd6dzTj8odWd5WQsj3s2a7j1UV0NWnDLvDI6NJ1riAPpnE6OmCdcKELMiXed8Kf4gcDCjkBzOLhl3IPIca4LGkEfTzQcNlR4zVmSM7Jzccn4n+tmOxoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5WmhWi1rUKXwYaT8TCAmtANKiAkHra7M8wBF4rQIA4=;
 b=WCPQH/QWC697+W6T3jm0+yM37cvTZTK/uODjpFZxO+uj3xAfhktA11eKExPvCx7xbXGN/3Bp4Z3KMn0/z2x9jxjlYxTsH9uoxqfCM5NSEq7d0UvvUKvTd++que2Iq+xMCetEJSEM/gWAEHYowaVd+xjKTHzFH8RUZsmmnbtvj5E=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV5PR21MB5594.namprd21.prod.outlook.com with HTTP via P2P; Sat, 17 Oct
 2026 23:03:21 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%4]) with mapi id 15.21.0546.010; Sat, 17 Oct 2026
 23:03:20 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: Wei Liu <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Konstantin Taranov <kotaranov@microsoft.com>, Simon
 Horman <horms@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev
	<sdf@fomichev.me>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net-next v3] net: mana: add BQL support
Thread-Topic: [PATCH net-next v3] net: mana: add BQL support
Thread-Index: AQHdW1zKbnIvIvdnm0yytnqZln8d3bcCXNVA
Date: Sat, 17 Oct 2026 23:03:20 +0000
Message-ID:
 <LV5PR21MB470440C7B0B7548BD26BE5D5CA9A2@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
In-Reply-To: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f9650929-3cd0-48af-855d-7e3e7d0823a1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-17T22:49:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV5PR21MB5594:EE_
x-ms-publictraffictype: Email
client-request-id: 6fb85eae-119a-4b33-b5fd-59622e2ab59c
request-id: c1eff096-4787-4feb-6391-08df2ca2d6a8
x-ms-office365-filtering-correlation-id: c1eff096-4787-4feb-6391-08df2ca2d6a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|7053199004|7146999003|22082099003|10067099003|18002099003|5023799004|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info:
 D+CIEn9vSvz4ovgT+/tDa2kCskg85dRjDRk2bHniL85j2IoC2GYdsbSQDGVYtYKigxPl4oFx49XrOrP5QUMzvsdQLArhNdoMXD+SUeoxBphra1b+b4QWQ1eNQ/8h/zyCksSEY7qVV+ZJcc8tBqc5ll/8OpBGjhUlzufA1OH1qVGYwK1/F7WtSzlinuT9oCLnvAwIpH//3LBX1JjoBZLQ2vS22B5MzEVgkt7D+NEr/AkhITZRyxhh6xsCb9O+TOp4ZkoEz39nJusn4/g343B7guIoEZS/ZWeJuHiFQ8sgeaa7wBE9Dqnk+cQcAHus8OrCNLjIjNnbS3dSkfXYT+1trq2iLwKCr384w/pNpo0a+qXcf/ujs57+RdHZVv7s32DaefGwG4uF1Wq8sePsOMLrRBwvagBLfYqgFbOoXk/tT60vr8Ouat3H0GkMnmjJddB9xleQTxaX3Py998Z+6GbGoHbY6oZSuep68dDWDqzSRULZR6/dTocsdUYmxbaqoDRWOZsRqLI96ehht66ofNwBVm8Hdd3C8p29cAed7ns+JeidfJvgkoB/Aqxy7jdzMh7lYvnUt7YftTmDkAGV9kQK5b5p85Qp4sxMtfLZ73QTOwnti8ubB4xQgxAb0bwyTR9gpo1EQ62jKUN3ECEleBYbzS5/dHnk46iXTp1ACvQeP0JDjfS5EvTn0dR679e25qKeGjtEVV+hE+Hxe9zzb1laaTvEVvBy4Oww4KSzg/BADg4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(7053199004)(7146999003)(22082099003)(10067099003)(18002099003)(5023799004)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Yliq/5IkTaaded3MZG12W7WNF0QeEqNJGr+y7DVTg/Z7r+Qh4mgdsAA3NOIB?=
 =?us-ascii?Q?l3nnRy8xFjlWywJDEUr6Rz3Cixdc45/rMwIGbIQ3mSHx6HvUEIZFhwgK3pAB?=
 =?us-ascii?Q?isLd2nxKb0jCwPlOgw+aLelNTgWHJTPBY/U+BV/vseJoRbo9/SKLQMbqwfYK?=
 =?us-ascii?Q?d/iiSdBAaqa5uaw2LtRmfXHjeRup9DXt/rHl3KHJ2ynupJHkb0WiVpWYQvnU?=
 =?us-ascii?Q?fDPnCPoxHwkae32z13Y9Z+kCW8anv5nH3928e85PYmi90Jg8OeD6O885V0ax?=
 =?us-ascii?Q?KrwdItmteOyDsFP6J+qNWMNfb94HWdZPNVq8z2Q+Br3oZU+0K/BZKXKplKt0?=
 =?us-ascii?Q?HjyejFnFw2mt5EBh+7KIeoz5E5qgfkooESi2EXRw/NhcxK3XkyBUc1P4WQTL?=
 =?us-ascii?Q?Wwakv8n6R/OdAl4yCfzSDFPq/sIq1CBG8kN1CtTQZRDiFCNmzM/7vyolfhdH?=
 =?us-ascii?Q?uAbHazGsVP8PFx2UboHZbhA8+1NlJoUAaqquSYrYL84HKgefArgwk/cULmLG?=
 =?us-ascii?Q?58UC0p1gFadlhMoUoYWu4SAtEe7aavClXYdWOPlSlfhbCT2Y20Fq44EE/wOy?=
 =?us-ascii?Q?hHoABNxyR4YtASb+qh29ctPy4PhrNZOm3BhSAbhSIKBuNAQj62LBIJnSK3vg?=
 =?us-ascii?Q?7gjxzlH3Kl+J81gHmLjaFTwXRzurkFJTZiXBTpka4DnMfIZFnEvKNHWcbdoS?=
 =?us-ascii?Q?HGQ0hN4RKwfB6Y4wFG0iYtj+1paLnbT274WyzfAn5ceOYsCitcpzVrhXSlkG?=
 =?us-ascii?Q?tW1gNRTYcxexX/eABRaI47EotkSljWm9pH/zIF93c5JSp81iYAWvqlleXnK4?=
 =?us-ascii?Q?da8hCwfqOZA2pOqufybqJ26eWSuJJdl9Et/bJr0FkzeFXSMSHn+Ux8MUrgP5?=
 =?us-ascii?Q?gKUCmWDSvIrLeXaV0Q6QhXdj5SqNdFq2Uwpuitw/KOFVX0jjp7RDG1BvwYc+?=
 =?us-ascii?Q?ZsB24rQrAJVbMeY5DQq82bnZY6IhgyrJf3e+PNJeBdeNU2W2oPP7Msug8yFa?=
 =?us-ascii?Q?Yc79RaTWISCO24UzFZksLkH5svx9ln37H7QiSy9lavZT760PfsajBxcRpu6a?=
 =?us-ascii?Q?02pB/zGYDrIAkARjm272eH0mstyyHfXIcbYSxhADyqRM/2Bp9OrE/cXY60Jh?=
 =?us-ascii?Q?/uPrm4SRBZviAnoNaO2N2+lEsD2hKWhUURxKVrCEK83RFtlcszIPOi0myv6O?=
 =?us-ascii?Q?vM6IkT+w7r2VhI+5pfL6YPZ4b1wElomJt1+vrwmviWBFRDayaRhoKfyKDdKE?=
 =?us-ascii?Q?jUxxe3u7V6CuIxjScHCp7bqCkp8TEnLCM6dZu0D1vFt6oU9+FOxHsxL9JQ9H?=
 =?us-ascii?Q?Go4nIqep57D3wyApwoGhv6q8aWsL0gpMOd1BtlATN4Mvpw2oar/sjtyuJh3Z?=
 =?us-ascii?Q?/hTco+OiLBqxs3gXUqXDddfqmbin0bIHb7w1svjQXK3OVZD1MzuIhhjoFAom?=
 =?us-ascii?Q?6qPGgNW+XhM1//vsCpOqDv40AbTMvV3o8JNwfBt4fIu9HZIeu2n8ejiq6lka?=
 =?us-ascii?Q?rp76eaiFncMDe7RPuYCfkI2vtB9VTQK8tkx+CAa+oRefp7viQOCubrUQB58A?=
 =?us-ascii?Q?gJOVTLYKVtIfG7m482jPLbLswg1RuF8fcilb92P2mOV/oMj3DwGYMhcpCGE2?=
 =?us-ascii?Q?V+Pu8paHEi+yjLoE8NOBnfWBK3Py+DX5K+IflI1Ecx6m0RSK0UdYRkmFkhpK?=
 =?us-ascii?Q?8iMsD0vlQbxERQGDOJE6TyzFYoZ6i/q9T50bMk12P5AzmkRyQd7Gydt4cmZu?=
 =?us-ascii?Q?WJQn/Abemg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eff096-4787-4feb-6391-08df2ca2d6a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2026 23:03:20.5271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UzYVM17ZXZTe7FIE2eZj0G0RAKtIE+4n3y3vkzFkW3wsm6sxNk5VWS0pPLmUcIMUMq/FKwxh5kUX1DIpuKmj4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR21MB5594



> -----Original Message-----
> From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> Sent: Tuesday, October 13, 2026 5:50 PM
> To: netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>;
> Dexuan Cui <DECUI@microsoft.com>; Andrew Lunn <andrew+netdev@lunn.ch>;
> David S. Miller <davem@davemloft.net>; Eric Dumazet <edumazet@kernel.org>=
;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Konstantin Taranov <kotaranov@microsoft.com>; Simon Horman
> <horms@kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; Stanislav Fomichev
> <sdf@fomichev.me>; linux-hyperv@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; bpf@vger.kernel.org;
> Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> Subject: [PATCH net-next v3] net: mana: add BQL support
>=20
> MANA doesn't support byte queue limits, so each TX queue can hold 256
> WQEs by default, and up to 16384, of up to 64 KB TSO packets, before the
> qdisc layer sees any backpressure. This adds latency to all the flows
> sharing a queue, and defeats AQM qdiscs such as fq_codel, which rely on
> BQL to keep the driver queues short.
>=20
> Report the bytes queued and completed to BQL, except for the XDP_TX and
> XDP_REDIRECT frames. These share the SQs, but bypass the qdisc and are
> sent even when the queue is stopped, so BQL can't hold them back.
> Counting them would let sustained XDP traffic keep the queue stopped,
> starving the stack, and the TX watchdog would then either fire while the
> completions still arrive, or, if the XDP sends refreshed trans_start,
> not fire when the completions stop. The XDP SKBs are marked in their
> skb->cb, next to the WQE size, so that their completions are skipped as
> well.
>=20
> Reset the BQL state when destroying the queues, once their NAPI is
> disabled, since the SKBs still pending after a drain timeout are freed
> without being completed.
>=20
> Lost TX completions can now stop a queue sooner: it also stops when the
> bytes in flight exceed the BQL limit, not only when the SQ is full, and
> the limit may never grow enough to cover the lost bytes. This includes
> the completions skipped by the WARN_ON_ONCE() early returns in
> mana_poll_tx_cq(), which already leak SQ space: completing the SKBs
> already freed there wouldn't reliably balance BQL, since
> mana_gd_poll_cq() has already consumed the CQEs of the rest of the
> batch. The TX watchdog then fires, as nothing refreshes the trans_start
> of a queue stopped by BQL, and its handler resets the queues along with
> their BQL state. The exception, as before this patch, is XDP traffic
> keeping the SQ full: each XDP send then stops the queue again,
> refreshing its trans_start.
>=20
> Tested on two Standard_D16ds_v6 Azure VMs in a proximity placement
> group, where the throughput is capped at 10.6 Gbps, with the DUT
> alternately booting net-next (c1c1f0a31712) with and without this patch
> applied.
>=20
> The throughput stays at the cap with 1, 8 and 64 TCP flows, and the idle
> TCP_RR latency doesn't change (p50 of 47 us with vs. without the patch).
> With 16 senders of 64-byte UDP packets, the DUT sends 3.7 to 4.0 Mpps
> without the patch and 3.7 to 4.1 Mpps with it. With bulk TCP flows
> sharing the queues, the netperf TCP_RR latency drops (medians of 6
> runs):
>=20
>   16 queues, 64 flows: p50 4649 -> 2182 us, p99 5621 -> 2677 us
>   1 queue, 8 flows:    p50 2554 ->  418 us, p99 2723 ->  624 us
>=20
> The standing queue moves from the SQs to fq_codel, which now drops
> packets: about 2500 qdisc drops and 88K TCP retransmissions per 48 s run
> with 64 flows, against at most 29 retransmissions before. The
> retransmissions are about 0.2% of the segments sent. The TCP_RR flows
> lose no packets, and the packets of the bulk flows are dropped before
> they reach the wire, so the goodput changes by less than 0.01%.
>=20
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

Thank you!
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


