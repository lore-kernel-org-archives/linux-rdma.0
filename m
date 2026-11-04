Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793789195;
	b=HS7Kuyv2RhMv1+YOLto1HUrw1u4pJd0pJFly/UQjxRzs+1xnitwWC4VHbDapxQjM5jI+
	 7eH2XglKu+sbe58tKWlPmwWs315eTpmFxLY0xH6DXrnafNIR+2sY48F9WokQ4No1L894h
	 xaOyNmgyfKPtVrauWp5czmVOvY+Moty28F+Fv9vQ8mYEpRgjlVV9u3VyITvbY0Qs5GByk
	 29kVtTgbRWeugTBCXA5ARzuRZXXDzZlxWmLQPtDRjrfZ+8/zIuQp2yaBApjSnqY9BiL48
	 Gs/95MWaxYAZwalcYPN4JwK/IXKrblZSjgeGe2o4IeiY4CD3Gckl5oh0o4woDZHqOdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789195;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
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
	bh=kMW9Loa8ezCoKAdbf+4RUNmDxE3v/RyplAaBa0ns+Yg=;
	b=M1KVj5bjv7rEVWQQfawKTnexQMcFGHvpgBl8arMMjDofeZGyt0uwd93qas4XWpjqphD2
	 ldP6KO2TtREevTJjfoo/LqNs+6E4oM9C5GL7AATG5R7RrZdLLRgZ7vvbzn8rboRgKZ9Ci
	 AuUXKjU41ElKWi/s3sAT5OyX4e9nYG8j15dFciCEqvIKq6y+xaWLuO/txn4vNbmDgfWDC
	 MjxhyCmSC68uesiJVqpCuAASWRBtunzWOe6P/OQCQztz55WWXHGmYRSnEkBvwdrWSQ/A0
	 fBDT09tX8zCqjh2i3ND4/fOgPAM+Ow+G3HVc3NS72WtWK3haUG967fWN8NA6v+rrmuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=earthlink.iq;
	spf=pass smtp.mailfrom=earthlink.iq;
	dkim=pass header.d=earthlink.iq header.i=@earthlink.iq header.a=rsa-sha256 header.s=selector1 header.b=lk7pEmWx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.74
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021074.outbound.protection.outlook.com [52.101.70.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE6606A31B;
	Wed,  4 Nov 2026 10:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECDE6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=earthlink.iq
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earthlink.iq
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=earthlink.iq header.i=@earthlink.iq header.a=rsa-sha256 header.s=selector1 header.b=lk7pEmWx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deKl1A4UOS6jglhU0wQo9wfJYgf6n95WPtqc5BkSdpEDIVelMQlAScR+EW3L0VUBJxkiR6sytnv0qdhOzrjU7Fbohc1HwSbVz5jws5md2UbkCgZM1N0y26WlCNKfJEu+KajG7xjwf8i0ywevh/GvHqh5FHon66zUPc90uecuyuo3ISMcCG6neC/bgm5DGeDcuGKxH2r1r/wfkz5kvmR+CPtutfrIknDBrM9UegROUb9s1JeZbuoSdFeypj3l5vqy0ALwg+Nx+5lC2MNcx1OAQZ2uwsijhM74dVkggmUm1s8uNzHYq00BUtaFMC3BmJmQon2v8uUS+JxsI9ResU/CSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMW9Loa8ezCoKAdbf+4RUNmDxE3v/RyplAaBa0ns+Yg=;
 b=XVz7buhrEvOjIctw7uklInF9cpBfoJkn9uvxRi16Aud+fkG+Ioj5DLhvr6XzuXpKybXICFMcgqCLzbU3t2ERmv6iXyfdZopiIjKDowR6Sp9XxnEXCOTlff2NEHd2ZX4GF3ixY+tB8AMQWhYVTLSTi1KiC5KOvVfX4vvDhhx2pPo27oIgEl8rXCiyDcoIcs9nwi0q0bvfvoyPSfIrzeLOLbxnlHqrpVrG9cZ7G+MfjOqTiwitY+Oz479cHNTI6TcU/z2MnUvg1HqScimi+64zdoHVPcps7qZJKpNtpPpuB9xnk7tDfXwS6p7/24UR0syYo6APTxKkZHexFNHk5FEwGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=earthlink.iq; dmarc=pass action=none header.from=earthlink.iq;
 dkim=pass header.d=earthlink.iq; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=earthlink.iq;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMW9Loa8ezCoKAdbf+4RUNmDxE3v/RyplAaBa0ns+Yg=;
 b=lk7pEmWxfWMQg38/2zogoYL9P8ORi9BD/JmOg0A+TTXrlmn4RkxfRGNH6nLX/eJpbKkiWD8qbOufYgrTCZiKydptcTqp8IpJbTlhQn1bSaBxe27JgWUj8KthtoAqySwZ+gtwVvhPNxXrAWOb6WwcksBulQkwBR+0kJR2FWNtgYBNuGmTc71rUq0U23Uv0rdw6fum5Ac1l0hQAclRyi00I0AY3ncEi7qVWHoBLChRQ9ge7WIa62zuYShqZxhYYTbQfuCYN+sSjSfCDw/OsVEl2PLLKM7sTNZyT/cIxePAaCR5Q7iXMfgUUcPvR0V5St8d817mkwwdYaij8KCixbieRw==
Received: from AM0PR02MB4307.eurprd02.prod.outlook.com (2603:10a6:208:d9::10)
 by GVX0PFC7B6927F7.eurprd02.prod.outlook.com (2603:10a6:158:401::b21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 10:46:28 +0000
Received: from AM0PR02MB4307.eurprd02.prod.outlook.com
 ([fe80::c392:dbc8:75f1:ef9c]) by AM0PR02MB4307.eurprd02.prod.outlook.com
 ([fe80::c392:dbc8:75f1:ef9c%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 10:46:28 +0000
From: Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [BUG] net/mlx5: nf flowtable offload rules never hit in switchdev -
 root chain misses to slow path, not to the FT chain
Thread-Topic: [BUG] net/mlx5: nf flowtable offload rules never hit in
 switchdev - root chain misses to slow path, not to the FT chain
Thread-Index: AQHdbElUgfk1enT3QE6ugzlHtdAqZQ==
Date: Wed, 4 Nov 2026 10:46:27 +0000
Message-ID:
 <AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=earthlink.iq;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR02MB4307:EE_|GVX0PFC7B6927F7:EE_
x-ms-office365-filtering-correlation-id: 1bf317c7-77fe-4253-45be-08df3a60e14e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|18002099003|3023799007|38070700021|56012099006|5023799004|261021135927099003|261022075727099003|261022105027099003|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261009223027099003|261021123027099003|261021121427099003|260925022911599003|260925021911599003|260925021311599003;
x-microsoft-antispam-message-info:
 6D8rndMNMmPI7Mx2j2oq6IThw12aRPIPug275x2GMxV3w39C9mApHhMCexaIvsRX15jdDjYEuPsziV8THv1dTpFeaTGzCt9AjDVMQGlupC4gkejceUugaBpVc5csKM1ZFbY0QxkhuTYBRp6n9ry7PSl/uzWyzhdUQ1f+J6RYpOeaeCkEF5gpqk0Oh7K6SO62PZn+SPj6pwgNez8fWnZTroCUjofhCMeLC+hdWlnh5kErxpNWOams1zO12lx9GRwI0zo6gjfWEIJCh42QJsjpbR+inXWsZU+2DC93WTCgur4ykNP5+9QtdPn2EqbTyL3PdxYgrCdRusSUprOKeb9GB5VZe4lkT0V3fS44fc7eYcMBmrNwXbMV9kbadfOasxk0wRk7dbONhwwp9sj/4eyecj4higIzBmisC1AcqYRiunz7GpbVgW5DtI5tFQDv88d/TuDCFBgJwm5Raw+Tq5ClxEXzrRh/fFywkMFr41EkGWg/HHRBiRAiFIVw5chp+67p2bl/mzfK61aXWcXLIJnbTl6zbEzSupyOUbyqzweqQEMrXVD67IMCKjSz8tNCNztr4uaZQ1uve3zP/SZvsusf+V4wg9VJUuXWh3h6ltTo5x5BhaALUICLSpqZWkMrzr3ZK9nD6tgjJi5wA7aJy4r7BNiuSRW3p2RTALmsnW6e9rXqfOF53ExkeFfFiTHNjC1HP09YQfdYWcUhSgzxF4iDwZxa3SnMPWM8HfCnMCVua58=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4307.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(18002099003)(3023799007)(38070700021)(56012099006)(5023799004)(261021135927099003)(261022075727099003)(261022105027099003)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261009223027099003)(261021123027099003)(261021121427099003)(260925022911599003)(260925021911599003)(260925021311599003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?aBbLu3ICouZeiRV7W6aCo0k01twtksV01Tx2BGwhsNO7JUNtCH43hoTNvf?=
 =?iso-8859-1?Q?xOXU/WTRAqFExaybVRjO0Oir+DmmLRHhQ9yvDbO1Ju3uEVFBCoYMbqbtp6?=
 =?iso-8859-1?Q?3/N+8POq+4Xe5dHOCrHFqfIdfq9UnC3Nlc4Sqz+BpREqNdQN5Kp5Z/GBzg?=
 =?iso-8859-1?Q?N6jjd0aSU7ah4eBZEsiAlTpzunnYb/FXQt8HlV8zbSp4cRK54uRvrOOZWp?=
 =?iso-8859-1?Q?UvIBCDkUaiH+ee5sV0ydyhFUNnnmEs1ZIUtg8O+f8wqWwcAr80WMBvATfS?=
 =?iso-8859-1?Q?nEiU07q3O0VwEUgB9P2A2nMbS9opWkVK+h5LjaX3/a4xx6pMtMyzF3gwI6?=
 =?iso-8859-1?Q?WtVo0isQiszWyc/p/cCKcaLLZssEayPKYxtOAv+5uKdO7MM5uNt0lwxEn0?=
 =?iso-8859-1?Q?70FjHwo12/+WewPTIIWls/cssA/ZQkeUBMQNgQaYQVhghXC025+pEkgH5G?=
 =?iso-8859-1?Q?zUFybpvU4O706cRucIhFGzvrvpEFtWADibOXNhIGvkRCshD97WMJDFVcLz?=
 =?iso-8859-1?Q?aefAlBDkz304sYHPuUhMdy5TaJx8UMUmBO43GDC1AEvD0rZa2ntnTZcsRQ?=
 =?iso-8859-1?Q?nAkERSgGYkmFoAUNhw1D/5URUuxYk40dSgf2/vfv00gky68CeoHBb0qR4e?=
 =?iso-8859-1?Q?KafySe9ow61KckgPsxna+sFODqALH5xok8FLXiIhhMPe83j3Sn0wpbw+6K?=
 =?iso-8859-1?Q?jLkS2BFMTxQ7Qks++b2mwVwNpJN3Z7+/nG9lDHxCh6pOJHSBwCmOvj6ZDS?=
 =?iso-8859-1?Q?4hlFbGofw9yNhJk5ckfp9a3gYx9zLZlqq9QpRV56rP97noJnBBuwBIOYnx?=
 =?iso-8859-1?Q?7qTq1eukBl3GHg8pADYhsiTujcRdw9Is5s2ntW5lGkImSGBWoYVJiTaKnS?=
 =?iso-8859-1?Q?np1b+frx6wuPVRdK8dFXz7M2yNM3nZiQTpg4OxNEuj7HbW8sAJJ1gUHl/x?=
 =?iso-8859-1?Q?9kTRWSK9Aekde9IoniR7gEgNAhruLmFJdyhO8LPwCQHRBvMSWfaXllsrvA?=
 =?iso-8859-1?Q?xtRNtCjTpgOYpIzvnKbRvCGNOlUwwwtQmgkvuDbAytpd6dqic1LiZvWBT7?=
 =?iso-8859-1?Q?ykuCaf8z8xeCo6eSfhoZAQyO0/uNSv1RSeabJd7XIfwMZVpNlF/3/Bndo9?=
 =?iso-8859-1?Q?KyyZKTXfmZNoJH8HgZc4k2DnVRlqZnjUADBwlFx72cUiiZ6JT4oMLX6Gk7?=
 =?iso-8859-1?Q?RKszJVzlyn2V1JJGs0/mpCXK2LB0e8UVa6TYWkE57KEN/OxbsDyOvIdEmB?=
 =?iso-8859-1?Q?Wb9kwozUKojHr0EPj5gRmlgyiL3bHYdnUum2o5ezNY9c7FtDKpyeSz4gZY?=
 =?iso-8859-1?Q?s3EAOEta+GuckluIbPJzKZ9cP+u1zVnYFM5p8YmHdK2GTA6gF3/S+9Peds?=
 =?iso-8859-1?Q?peNToBw+tJ27PGk91M7W6QMc88dQEm1cLrQUhy8PMwCHM2H0F/s4dx675g?=
 =?iso-8859-1?Q?xL1SWm5CdWFECG59oP/+QseLK5k2aE3TndqTEENcr7iD6QxxruEBcDQLco?=
 =?iso-8859-1?Q?TrL4coCEZvGMYMfZhrRfq5s2PlEFi0l1xYyUrE/XlimQAG1oNSgAREnSqp?=
 =?iso-8859-1?Q?OdtoFEt1LKnf1a/VjtY9gX14boXDGn/IAx+3vjpii4putxiCpNW6Z1fQjJ?=
 =?iso-8859-1?Q?tgI0dqKQaCTCuIK2atRfRSSeLs1OKL3kbkH1laEbn6Hs8CbkG6JJib4ysH?=
 =?iso-8859-1?Q?CspO4yA66krxA7uUQGntP5fo5+cy/dTQJwd+MS0w4nU79oy7gp8/eEgH/l?=
 =?iso-8859-1?Q?fsNiEDdEmTHT7lU9eIJAmezD/UpRliC0nmnq8QwjkzLYqw?=
Content-Type: text/plain; charset="iso-8859-1"
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
X-OriginatorOrg: earthlink.iq
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4307.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf317c7-77fe-4253-45be-08df3a60e14e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2026 10:46:27.8204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 89d949e4-9c48-4c58-9092-cf9b53301a04
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2f5kYpwia6FR7C9UNgnjBedbtRm2No06deZ0z4TKv3C+dsi1Xc6EzldSfF/d6Yv5nIMg7LDHJa0Zp8vqy8cM6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVX0PFC7B6927F7

Hi,=0A=
=0A=
nftables hardware flowtable entries offloaded to mlx5 in switchdev mode are=
=0A=
installed correctly but never hit by traffic, because the miss rule of the=
=0A=
root tc table (chain 0, prio 1) points to the slow path instead of the=0A=
reserved nf flowtable chain.=0A=
=0A=
Environment=0A=
-----------=0A=
- NIC:     NVIDIA ConnectX-6 Dx, in-tree mlx5_core, firmware 22.36.1010=0A=
           (DEL0000000027)=0A=
- Kernel:  AlmaLinux 10.2, 6.12.0-211.69.1.el10_2.x86_64; the code involved=
=0A=
           is identical in v6.12, v7.3 and v7.4-rc1=0A=
- eswitch: switchdev, flow_steering_mode smfs, hw-tc-offload on, no VFs,=0A=
           no tc rules=0A=
- nft:     flowtable "flags offload" on two VLAN subinterfaces of the uplin=
k=0A=
           (indirect path, mlx5e_rep_indr_setup_ft_cb); TCP traffic routed=
=0A=
           between the VLANs and hairpinned on the same port=0A=
=0A=
Ruleset:=0A=
  table inet leak {=0A=
      flowtable ft {=0A=
          hook ingress priority 0=0A=
          devices =3D { "ens3f0np0.2", "ens3f0np0.3" }=0A=
          flags offload=0A=
          counter=0A=
      }=0A=
      chain forward {=0A=
          type filter hook forward priority 0; policy accept;=0A=
          meta l4proto tcp ct state established flow add @ft=0A=
      }=0A=
  }=0A=
=0A=
Symptom (fresh boot, no tc rules)=0A=
---------------------------------=0A=
1. The connection is accepted by the driver ([HW_OFFLOAD]), but traffic=0A=
   still goes through the CPU: per-second deltas of the uplink counters=0A=
   rx_packets (sw) / rx_packets_phy and tx_packets / tx_packets_phy:=0A=
=0A=
   tcp 6 src=3D192.168.2.10 dst=3D192.168.1.10 sport=3D45350 dport=3D22 ...=
=0A=
       [HW_OFFLOAD]=0A=
    sec   cpu_rx/s  wire_rx/s   cpu_tx/s  wire_tx/s=0A=
      1      18884      18875      18846      18837=0A=
      2      19196      19215      19179      19198=0A=
      3      19289      19289      19258      19258=0A=
=0A=
2. The rules are present in the FDB (SW steering debugfs dump=0A=
   /sys/kernel/debug/mlx5/<BDF>/steering/fdb/, decoded):=0A=
=0A=
   192.168.2.10:45350 -> 192.168.1.10:22 tcp  pop-vlan,=0A=
       set-dmac=3D02:02:03:1a:00:01, set-smac=3Da0:88:c2:a2:36:9c, counter,=
=0A=
       -> FW table 0xf (VLAN push + out)=0A=
   192.168.1.10:22 -> 192.168.2.10:45350 tcp  pop-vlan,=0A=
       set-dmac=3D02:02:03:19:00:01, set-smac=3Da0:88:c2:a2:36:9c, counter,=
=0A=
       -> FW table 0x10 (VLAN push + out)=0A=
=0A=
3. Adding ANY chain-0 rule with prio >=3D 2 on the uplink fixes it=0A=
   immediately:=0A=
=0A=
     tc qdisc add dev ens3f0np0 ingress=0A=
     tc filter add dev ens3f0np0 ingress protocol ip prio 2 flower skip_sw =
\=0A=
         dst_ip 192.0.2.254 action drop=0A=
=0A=
    sec   cpu_rx/s  wire_rx/s   cpu_tx/s  wire_tx/s=0A=
      1         28      18552          2      18526=0A=
      2         19      18999          1      18981=0A=
      3         28      19050          1      19023=0A=
=0A=
4. Deleting that rule keeps it working until the eswitch is rebuilt:=0A=
=0A=
     tc qdisc del dev ens3f0np0 ingress=0A=
=0A=
    sec   cpu_rx/s  wire_rx/s   cpu_tx/s  wire_tx/s=0A=
      1         26      18777          1      18752=0A=
      2         20      18885          1      18866=0A=
      3         18      19075          1      19058=0A=
=0A=
   An offloaded nftables netdev chain at priority 2 on the uplink has the=
=0A=
   same effect as the tc rule.=0A=
=0A=
Analysis=0A=
--------=0A=
esw_chains_create() (eswitch_offloads.c) does, in this order:=0A=
=0A=
  1. nf_ft =3D mlx5_chains_get_table(chains, mlx5_chains_get_nf_ft_chain(ch=
ains), 1, 0);=0A=
  2. ft =3D mlx5_chains_get_table(chains, 0, 1, 0);      /* "Always open th=
e root" */=0A=
  3. mlx5_chains_set_end_ft(chains, nf_ft);=0A=
=0A=
mlx5_chains_create_prio() (lib/fs_chains.c) chooses the miss destination=0A=
of a new prio when that prio is created:=0A=
=0A=
	next_ft =3D (chain =3D=3D mlx5_chains_get_nf_ft_chain(chains)) ?=0A=
		  chains_default_ft(chains) :=0A=
		  chains_end_ft(chains);=0A=
=0A=
When the root prio is created in step 2, chains_end_ft() is still=0A=
attr->default_ft (set in mlx5_chains_init(), here tc_miss_table). So the=0A=
root's miss rule forwards to tc_miss_table, i.e. the slow path, and the FT=
=0A=
chain is unreachable.=0A=
=0A=
When a second chain-0 prio is created later, mlx5_chains_update_prio_prevs(=
)=0A=
rewires the root's miss to the new prio, whose next_ft is nf_ft. That is=0A=
why the extra rule helps. mlx5_chains_destroy_prio() rewires the root to=0A=
prio->next_ft (=3D nf_ft) again, which is why the fix survives deleting it.=
=0A=
=0A=
In v5.8 (esw/chains.c) the end table was set BEFORE the root was opened:=0A=
=0A=
	/* Create tc_end_fdb(esw) which is the always created ft chain */=0A=
	ft =3D mlx5_esw_chains_get_table(esw, mlx5_esw_chains_get_ft_chain(esw), 1=
, 0);=0A=
	...=0A=
	tc_end_fdb(esw) =3D ft;=0A=
=0A=
	/* Always open the root for fast path */=0A=
	ft =3D mlx5_esw_chains_get_table(esw, 0, 1, 0);=0A=
=0A=
The order changed in "net/mlx5: Refactor multi chains and prios support"=0A=
(Sep 2020, merged for v5.10), which introduced esw_chains_create() with=0A=
mlx5_chains_set_end_ft() after the root is opened.=0A=
=0A=
Setups that always have more than one chain-0 prio (e.g. OVS) would not=0A=
notice this.=0A=
=0A=
Suggested fix (against mainline; compile/runtime UNTESTED on my side)=0A=
---------------------------------------------------------------------=0A=
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c=0A=
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c=0A=
@@ -1693,6 +1693,11 @@=0A=
 		goto nf_ft_err;=0A=
 	}=0A=
 =0A=
+	/* Set the end table before opening the root, so the root's miss=0A=
+	 * rule points to the nf flowtable chain and not to the slow path.=0A=
+	 */=0A=
+	mlx5_chains_set_end_ft(chains, nf_ft);=0A=
+=0A=
 	/* Always open the root for fast path */=0A=
 	ft =3D mlx5_chains_get_table(chains, 0, 1, 0);=0A=
 	if (IS_ERR(ft)) {=0A=
@@ -1707,8 +1712,6 @@=0A=
 			goto level_1_err;=0A=
 	}=0A=
 =0A=
-	mlx5_chains_set_end_ft(chains, nf_ft);=0A=
-=0A=
 	return 0;=0A=
 =0A=
 level_1_err:=0A=
=0A=
With this order, the root's miss rule goes to nf_ft, carrying the chain-0=
=0A=
miss_modify_hdr exactly as a later prio does today. That is the state the=
=0A=
workaround produces, and it works on my system.=0A=
=0A=
Thanks,=0A=
Mohammed Zuhair, Earthlink Telecommunications=
