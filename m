Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021116.outbound.protection.outlook.com [40.93.194.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5972B489FD8;
	Wed,  9 Sep 2026 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788996335; cv=fail; b=IQh4YzVDwxI9P+dl/wHcLHIN7PyPmXXp+akR6b33Jtl/AsXc9VMzY5vyOfy3luTpYozS19TJbhWlAmb3TAAp0Y9cQJllR4PPYXLrNzj1oCF1cgMKixxBQFnZfEw6VbTcmYKPeByn4fEirGG1QLKRar94Q5sIUJQrDURHIAKXVAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788996335; c=relaxed/simple;
	bh=T0UjzKWp4HpR+RBiry25boLFtCWTd3JhP/qGaTefW/U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YdMKCW6kZK9oUwasRQmO5BRrxplaKt/MkCTQWfBBrA8X21e/oj4oKa+jbi4hLTgu3ZIrHi9Mpx+5tEnyoHAe2RM22mjSooFiI0Nu4D8JkL/RSfiH9nforxa7WB4NULJ7gHWjQKkEkukX7nPW8wZfx4SR6G+sImeAZw83pjqj7d4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=gYWwzYFT; arc=fail smtp.client-ip=40.93.194.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="gYWwzYFT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhVlBCZAeYXkcGIMJgi+ML962opvohMoavEinlU94conWm47hXHc0pIjigKPm+QOdYNzHJYoFKDqe5fpUf1PEGFOuklbi5OKGKakdClndp91gFdUbOck8EJrWDeqLxwiMNLKHh6Hv5ZwkIeUA88jUOsYgXu8NUn1paemtmAS36zfdRPPAIbLsi16d/9OxK3wm6NwIgSB8+wm85zc9/Wb9rTuf+vqcEnU6fgM3HOksiRbiE51KLf2D1+Jv6Nm0upOP6EXFukZ6blMtzqnt51Tx7EnYT0y63/1Be3CPSlrSFhzGiSKM3+9TFYMmP5At4B/zzHbiSoVPn8iAVCNzSkjKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJ4H7oXg/wCA6ifWPiTlB3t3rFs+N9MeJ5CMUFfjsQM=;
 b=yvXKO3eJNwqld/ZMOAfpe7Ud6WtBHXDxhBSw4qomvTd3gVFX0wzRCeQT533oFJFd1AkO8NluQ/Yd9mK++hNENADAZC2ii4b9sU2I0amJlP4t4VfD+72UCljX18pp7MOF0AK15VJiRT29mRzLhMjynOcBwBuFMXLsOLeeNV8RX+GZPbtckaC6v9zRvi2wATF5FpkhbS96SK5Ljh4X1faloQp6WIz/99cOtk3GA+go/io48XAXQpCnaX4qg6+A6AokuuLCZA0yql/gbX9fIS3peIjmnfTtIfMg95DAMqa5NBH1KvYLHeAZ5h0Nt5QVUHbRh1mC8GP2bqGCK663t0WTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJ4H7oXg/wCA6ifWPiTlB3t3rFs+N9MeJ5CMUFfjsQM=;
 b=gYWwzYFTZJKdCPwkO5CLbnvWjMc0P+fgbTXzQPp2AeXeInyqfLPwvyJVlBzNK+uYV/zTiJiUs3gh8JqKm5lT/6WGYpvGgQk2Xulnde1P0DeL8EtjF8j5FSnlXcrsqZxUYxVWrdafaEgDeMUQTK/rR8Gud7qh4HF58Ez7w8oV5sE=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6394.namprd21.prod.outlook.com (2603:10b6:806:4a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.3; Wed, 9 Sep 2026
 23:25:30 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Wed, 9 Sep 2026
 23:25:30 +0000
From: Long Li <longli@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v4 04/13] net: mana: swap queue
 sets in mana_set_ringparam
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v4 04/13] net: mana: swap queue
 sets in mana_set_ringparam
Thread-Index: AQHdP0JDeQfyxfzra0mdIplxYnuDerbFmGUAgAFNocA=
Date: Wed, 9 Sep 2026 23:25:29 +0000
Message-ID:
 <SA1PR21MB6683ABC6FD97252DC632A3AFCEB02@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-5-longli@microsoft.com>
 <20260909032945.2C3E41F00A3A@smtp.kernel.org>
In-Reply-To: <20260909032945.2C3E41F00A3A@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6a9f4d4d-7222-467a-abbc-aebdee5bee5e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-09T23:23:50Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6394:EE_
x-ms-office365-filtering-correlation-id: ae94020c-a9ef-41dc-dd61-08df0ec9a345
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|38070700021|6133799003|56012099006|7146999003|4133799003|10067099003|4143699003|5023799004|11063799006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 C8ReC8aVBZYQP5+oQo4m/Dj2d6DXm0iwsXtGxAdGW+JsqbKXOXfBqMTq376McH8uhqMl1c88lixPapod65h5dgO3Z+nU7Nn5CJv5dc+M5jfyepl4WHK0D85CF6rqn3yP6lBog7YkiE1+0lmu5PMIqajO+d+uhjmXqKoOi3Bg6U2QzD8bxg6rzwcRSjR1DckOw4Fyakfu8khVtQfPyz07Vz83zeIIsri5/uw2FcGm54fcSNGJhsUwOFh2/gZJpCCVKI186iBWgwg2CQTy9B9BNAVYC+/xsYrg+gTDmUc3D9jCgfbkurydXu+xDN9i8tpwCp4Hk/MoY42jYxK8/gjGx5vm13MLglsjgOrBSzfFNWj0+QhyrOjVmyydJLcHDsLUpF3MGJWDRCNaPDCmnE2j8zQd2kjOC3OHfRR0eQx3jo6w6K20PvfjGFksDypnkq29tvJO34NRFCqOkWJvbl52Vl6rykhr1RH+MrHj1yM/G0Hq3fVlvELRF/ws28A5e8rXoYoIAokvYoSgCLi5oGGSzIRzJ0gPhnDAuWophUSWOKj7jAWr20SrQKCbi5CrCyaUMHzeKaAqBo49zRE37R/w9yxHAn7LqodS5CoTtdkBpbvQ1oF2mdDhSlOhchlnALlx2qJHWc2I9U80tql7FxSb1A1djvjVRYmFjav9gOd8vNI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(38070700021)(6133799003)(56012099006)(7146999003)(4133799003)(10067099003)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Hcg2LgHlhdpdtfBPlIDTJPSk1+M8tGqSIn4YmHkYIS6RILRm3tSWyC+6lNn6?=
 =?us-ascii?Q?mgsVDqCVI3KX/np39ibPPAj2ChNYgW1aXz3BL5TyuwkuUVLhLdElHDOQmq4q?=
 =?us-ascii?Q?pm/Vrd6Oxyo4cgdclVgaFMhirXmZbQ+tkurRpVeT1vIdeBTMpgplFY3sOBoJ?=
 =?us-ascii?Q?daw2TazgEimYBisudq/G+ZqoKlsTqQrXYqQmRRpN/Se7fPf+xg2lhyQeMu6v?=
 =?us-ascii?Q?JxZIqD2FwV4Ozq0Pb0DEOfn0rLVnxbMRMuOzNxeCo6xYmdfSpZ7YZjrvfLpT?=
 =?us-ascii?Q?l9N1OlJlfZ6/DQ7uszSC8Swdu7wUFhVq/SG+YibXyZJFMk889wy9/KAgmCiC?=
 =?us-ascii?Q?gCxKMWzUyI9a86tn5DSguqF3iXhIjLfzV+5F+9Sc2ewSQABd+QaSYlIBnFAO?=
 =?us-ascii?Q?FXzH107jtORT0+u3ZG5wlquSROI2OcZxJ10ThDhy12guHZz1CX2B1xcVMCdx?=
 =?us-ascii?Q?eGlhP+YDtSCW9jY0OOzjSVxOrV/PmLpmNsnaPiAO3dX9jtDOw/vjt3RCF3Vg?=
 =?us-ascii?Q?1knScglRiCM90pJUqGlgUC9P/u1NEp99n0QdPu+pm0/5Q7X25wz/qC0OZd5F?=
 =?us-ascii?Q?jQ2Hl2riGr9w2fDOf9phS84/KwcrYuMC8zMWbe2Sb5PM3v9uEbeAYxDu02jS?=
 =?us-ascii?Q?FDPESOSnFIWI/Gdht3dAz5+CHkNY9ZBNy96SIJz8udDMKUF6nSPar3iAmMAj?=
 =?us-ascii?Q?KrXcemWIFSA/6jsjbmSBOOV1fGIfbT5P5FrIi+eJAl/NjnR2W0NZZUk2G0tK?=
 =?us-ascii?Q?gnuWmqlMzkdC2YvmeGrISqiyZm0fUV6IJNb78tDNetoul8C9mwcn6Rzk500U?=
 =?us-ascii?Q?Gb3GGjlxfD7VNnrHcvnYknNC6I4QcPvbCotS6sx6h8/gtTomKQWESWxhKYzn?=
 =?us-ascii?Q?puZuwYYm44erLCob19ISWSLgO1te90dKfB9CWMBgdcSeZB9/d/yX/vm+3vdc?=
 =?us-ascii?Q?LCTVHxeZ3XpTB8luDyAAEeTXEwsqkiOH2CYPlx7RHX1VyM9X5+9xE1d9pH8q?=
 =?us-ascii?Q?X3St115l4HCxRc4jsT9WKaSTg4/HnvOTG0A+Su4qDQLIPTM9eQRx1dNlf7Uj?=
 =?us-ascii?Q?7dkIf3a4CRKZfOTi8UIYjGrUnXPkvSj/MkURsMnw7CuVERA7tVu2pflsEdo1?=
 =?us-ascii?Q?FL59C+BIk3Ih60npRPepgHs5ByvBbu5FaYNoDNZ2ERO3DvF7hHlGJsmvu6PF?=
 =?us-ascii?Q?7WxTeROpLJoJWjJt1/7V/H/5xsWsddvRIuRK1nD4IV61rRCcXE2QHuSVLaJ8?=
 =?us-ascii?Q?D4oVKfvvLs9J8Cqa8UIUVSMQ5jExwWvobn7FlCS3VmVzW+2TV0cdXRTgUpr8?=
 =?us-ascii?Q?sP4fWRovo724WsxOa57tpTLF2xBxxiOVafRBZaX+ELxhva3qxHXjUOulxkqN?=
 =?us-ascii?Q?D6pD54XLciutoqFWIDkyiZfOihCeLrt80eBzxS1R9k6n89VR3KS4qo8CnTYA?=
 =?us-ascii?Q?7YbZCpeXRyaRNpwMM2DvYVzGC5kdpkJjVi3e/rnNPkhb7UEYTe2+kAqBFrc+?=
 =?us-ascii?Q?qPDf4vOOmvOAb4Mbg974pMTCUpzGsS0Wq5MdQQVkL/Kv9QryukFvKRVCsPF/?=
 =?us-ascii?Q?RFQkas6diPnGAxM/yG41Grf12xcWqej4y5nvHZrT7oQEc4UzjLe1EISKtVnK?=
 =?us-ascii?Q?xByh4/MesI0dD376DB56V4HdUfBcF6x0OEjRc+F9RWvXWwW2TYK5zaFN+8pI?=
 =?us-ascii?Q?hy/+wgie43yDfFaifC1MZqvcLgf5qdT8JmYAAXrcYCYuiCNq?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ae94020c-a9ef-41dc-dd61-08df0ec9a345
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2026 23:25:29.9904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U0D9nYxaYBJGKGTtOwLg6D8mmz5X2yNyo6Xi+K5LEwxLMNmpVOxVE2AgLY334ukBs+PKiUfBGNL2i+T/vV63Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6394

>=20
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s)
> to consider:
> - [Medium] The patch introduces an ad-hoc locking pattern using a boolean
> flag (`apc->channel_changing`) to guard the reconfiguration critical sect=
ion in
> `mana_set_ringparam`.
> --
>=20
> commit 40668ebf41a83bf44835ffb33803930c039ce405
> Author: Long Li <longli@microsoft.com>
>=20
> net: mana: swap queue sets in mana_set_ringparam
>=20
> This commit replaces detach/attach operations in mana_set_ringparam() wit=
h
> queue-set allocation and publication. Failed allocations now leave the
> running queues and ring sizes unchanged instead of risking a detached por=
t.
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> > b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> > --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> [ ... ]
> > @@ -774,32 +772,56 @@ static int mana_set_ringparam(struct net_device
> *ndev,
> >  	netdev_info(ndev, "Using nearest power of 2 values for Txq:%d
> Rxq:%d\n",
> >  		    new_tx, new_rx);
> >
> > -	/* pre-allocating new buffers to prevent failures in mana_attach()
> later */
> > -	apc->rx_queue_size =3D new_rx;
> > -	err =3D mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
> > -	apc->rx_queue_size =3D old_rx;
> > -	if (err) {
> > -		netdev_err(ndev, "Insufficient memory for new
> allocations\n");
> > -		return err;
> > +	if (new_rx =3D=3D apc->rx_queue_size && new_tx =3D=3D apc->tx_queue_s=
ize)
> > +		return 0;
> > +
> > +	if (!apc->port_is_up) {
> > +		apc->rx_queue_size =3D new_rx;
> > +		apc->tx_queue_size =3D new_tx;
> > +		return 0;
> >  	}
> >
> > -	err =3D mana_detach(ndev, false);
> > -	if (err) {
> > -		netdev_err(ndev, "mana_detach failed: %d\n", err);
> > -		goto out;
> > +	/* Exclude RDMA through failure cleanup, which may release the
> vport. */
> > +	mutex_lock(&apc->vport_mutex);
> > +	if (apc->channel_changing) {
> > +		mutex_unlock(&apc->vport_mutex);
> > +		return -EBUSY;
> > +	}
> > +	apc->channel_changing =3D true;
> > +	mutex_unlock(&apc->vport_mutex);
>=20
> [Severity: Medium]
> Does this code introduce an ad-hoc locking pattern using the
> apc->channel_changing boolean flag?
>=20
> The networking drivers subsystem guidelines indicate that using a boolean
> flag set on entry and cleared on exit to guard a reconfiguration critical=
 section
> bypasses lockdep and provides weaker synchronization guarantees than usin=
g
> a proper lock.
>=20
> Could a standard kernel synchronization primitive be used for this critic=
al
> section in mana_set_ringparam() instead of relying on the
> apc->channel_changing flag?

This locking pattern has existed in the base code for a long time; this is =
not introduced by this patch.

This patch just uses this locking pattern for the vport changing states.


>=20
> [ ... ]
> > +clear_flag:
> > +	mutex_lock(&apc->vport_mutex);
> > +	apc->channel_changing =3D false;
> > +	mutex_unlock(&apc->vport_mutex);
> >  	return err;
> >  }
>=20
> --
> Sashiko AI
> review * https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2=
F%
> 2Fsashiko.dev%2F%23%2Fpatchset%2F20260908032843.397667-1-
> longli%40microsoft.com%3Fpart%3D4&data=3D05%7C02%7Clongli%40microsoft.
> com%7Cc67f289fbf6d44697aa108df0e229871%7C72f988bf86f141af91ab2d7cd
> 011db47%7C1%7C0%7C639245213896893836%7CUnknown%7CTWFpbGZsb3
> d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOI
> joiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3Dbb9IsrgM5js%2BYCF
> uaioyc5OMJmhNDee3ut65iShCesk%3D&reserved=3D0
