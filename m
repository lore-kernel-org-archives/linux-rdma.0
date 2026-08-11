Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022107.outbound.protection.outlook.com [40.107.200.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA51C2E040D;
	Tue, 11 Aug 2026 21:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483553; cv=fail; b=pppWO+2uyKwx4YHai7zL5QOEX7PV8bJfxlW7PUJScVu1p2FB3FBDhP9vSgseAxeazgGwUjB3E6n/lNZdWQBUEBSoMZ6icpdMhiWpMaW+MEq887Hcns7tAGXVUNYtLtItM80g6NoB45Tx6+UDh8UvSKhPo1DLSnVl7XGBZWZDnUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483553; c=relaxed/simple;
	bh=PP9yAGyyzXVyUNg7p2pryUlqeUDQ41VEEr28VsCFAzA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G6wWRYqLcFAiRZfePNCgkfMpC6MqgDNual9CEG/V+k12ir0FY1AIlHWLGzPdAmuMh96NaInd/6iBn2rUyyU9z6wgchotdGhc2TTHadiCTOt72aMYAiMbsJzV7kCNgplK/lHdZOl/r/j4gIsdW3qUw6wsDPAsTnL8yavdFDHOUlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=WvT2EU7v; arc=fail smtp.client-ip=40.107.200.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="WvT2EU7v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PElR22DC2OCF3ELvTlArKYp0zg8rIyQ2Xml/aiGJR2uTG4i/wlJUASMyHvVvECOCtBVSsGkwfKZ76q+55j72l8rzqLyUwLzXsM8eY4U9Enuz0zALV81ueYExTp5bDU60pCU+fyfMjOPFh8OCAt7h4AEnf524GlHXShHt8S2kNcXypb9wJEJKbTcZWy+VulgZW9TnfIxwbHxOEG8f2WABBXNvnrXiqhcNsbsayfkDzqiAy/nlv48O0vSLIB5etoIYo4CK59vBYJuGxzgvNkm/Vu1/OZAyv0T9MkB2jefp+nV7q3VRz6ggpxJQtQJ7whXrtcNxsWN9waM06zxs34kBWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=laTLZxSmbUteW0NWn2ES793B0xNl3uXt0KGYH8CgDas=;
 b=JSI1WdVOL6rzjMgX6gTBPYRs7EtMP9GW8aj7+n86ZwlLn+WL7q5OGN2J+wH4zFmLrJpwbpfCcuHK2xs3LMnQnvK/IZl1zdjOSucrY2o277hA4N3E2u2evF0iSTkXFxu7pq2xKCg/PY+w4yjeDUp5fjzKijYplfHyP4KwN3a2i4U2saf8O0902Fa9EeF8lZNcTih1p/IevFx4IP0RiSbWDGpMGJpklLdOOwvU6HvFRJJ6hWHxDkM6R0kkl9+5oggl5GdoXhWP7mZWX61dY+lxqNl/RTuoKXWqoOTOL+dS4C0bqVDfBt/KH7eU6FQnZBkjCIvBBNYJAAMg66JBguNb0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laTLZxSmbUteW0NWn2ES793B0xNl3uXt0KGYH8CgDas=;
 b=WvT2EU7v1zv7vqp50RhDrNeKSNQXE1EMwsiCcVb6LYG3vCEaiZOcgl0tj0H2ERvax3UCShzPfLiaw/rK8Pxwir2ZWYMKuaN7wy67l48UhK/IFUR8aYzTattFNwaOsbT3uee9XqGuwKJBNBGWqJZy7mPsarZJ7k9JwGmTpzH8lLM=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6010.namprd21.prod.outlook.com (2603:10b6:806:4ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.2; Tue, 11 Aug
 2026 21:25:48 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 21:25:48 +0000
From: Long Li <longli@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, Jakub Kicinski
	<kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, Paolo Abeni
	<pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Haiyang Zhang
	<haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>, Simon
 Horman <horms@kernel.org>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v6 1/7] net: mana: RCU-protect
 gc->cq_table lookups against concurrent CQ destroy
Thread-Topic: [EXTERNAL] Re: [PATCH net v6 1/7] net: mana: RCU-protect
 gc->cq_table lookups against concurrent CQ destroy
Thread-Index: AQHdKTqPxn+SeL0D+U+Lxn/p3UL227aYgWiAgADb5ZA=
Date: Tue, 11 Aug 2026 21:25:48 +0000
Message-ID:
 <SA1PR21MB66834DE14ECB2919C084E21BCEDD2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260811023823.2391255-1-longli@microsoft.com>
 <20260811023823.2391255-2-longli@microsoft.com>
 <20260811081805.GA30770@unreal>
In-Reply-To: <20260811081805.GA30770@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9f04690f-e653-4601-8191-c2238cdea098;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-11T21:25:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6010:EE_
x-ms-office365-filtering-correlation-id: d44e3c4f-8372-40d3-31e4-08def7ef1c81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|38070700021|56012099006|11063799006|7146999003|10067099003|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 H6oq1u6cy4+7e4AY3U/YGP4aMKYG5Y1b5XApOHcbGOP//FvwKrX6K69lSuOt16pt1LMuWkxPm1oOP4xAElyiBYSrk4cs0Df3llvre+uS3tLpgWQlkicRZoxgOGuzdkjW0B/aBV8lf+0nwMhR1uWjaBSV9PEngxcYBV0MPXJzxMyCJBRBprNODH6si4N47pgOpXgZfUvJoYwVJ8OvG8zTOiN8gPbx05Jhz7Y2C0VuxBUkKzrj+BxnwVF1xs1DDFGiFpbDlv1DY0UPakKSQ+H/qvkgOjF5c5EYOqzt3a3sxu3L8gWEXDDgaP45XwB+wHTaxPML/mnXNf8nsTKFEHNjmsH29PUtJ89ceOwqy4rHs4yBZRui+i1lWbiK7dj/9wfvYU3yf/KBZTpkmlAHj3iHRfFOfS1HHcyMa1eYMBL0IcjqPqGgvmtlGkNu52+JIvoj/23dN2SdTlyZqaSg8Erjmz57kJ2KGrYoVDvmdIQ8m8TCQfNc3Qkk6Hc3Zw7javE/9gZUMShIC41Y5F/mUYCs+4vKddpf4MkTshrj0Vndw7iBIgCsV81XcbQ8cv8OBFVadJ+UC7pCB+sqYdUqmRONkQ/1Lcnlffythc+8ZYHJRlf2GVLac3v2peHrn1nWa7uRMT6M9QwArfE8KwRCpCLENMjhVHXBcxIt4niNw9MAOUzyS4rNggz5sVSzI8329dJllrh9XWv92wEa/o+NTshrEb4nGntsLn/4JWlvUIk+btw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(38070700021)(56012099006)(11063799006)(7146999003)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?LSQtosgn8M71SuNqe9BeF08BRZtSfj4sdDliG2d4n6kBVM0M9bEyOBn0CRWn?=
 =?us-ascii?Q?0z4ae0KELZApITO0VVbqaRPu14ZrpuANfbaGIsF+GM+Un5HtnEqoZtWhjKQ3?=
 =?us-ascii?Q?8fDRWY5mvNJQOTm2q4TjmgRK2toqJifh+oDUHn5TXRRrqOsbOmfsN7yCHwue?=
 =?us-ascii?Q?xKy37PrtImvExrjk7sOGYb8v9Z763b+yTbVqL6r8cEB3x86OhIc6642DZlaA?=
 =?us-ascii?Q?2qxlEBCa4ZVeXcNdqzDSM3/mE3Q05SGl/B5FzfY5lX+ZR942hTuSp8jo9cf9?=
 =?us-ascii?Q?/8+2JKIXLGSIrG/Rwex0WkPGyJsBKfBig27FOFJLIkpwztLcck6vdMxK7eAs?=
 =?us-ascii?Q?l+taVMQb784JviV9VMppFmtgK9HryjsxfX8UbcTZiZNdimnjJQmiRz5F+hVK?=
 =?us-ascii?Q?SR8c1wre4wX9Tsc8iKL2Ab5TnJkRp2ihXLDxYDfbT5sXtBQiBhhe5ZOa7ZAr?=
 =?us-ascii?Q?su+C7yqG4uwSgAVSBg63RLKB8xeQepE2MCJagEoiIe2So8Hg1gZZYiliwKvv?=
 =?us-ascii?Q?akhfPiqS/uk3SGW9QYHp+bnvU8SNOWhL/2HHWXGla7nf637Sb9P+l4pYkqE/?=
 =?us-ascii?Q?qGbOY4Q0n8erGXdmv41Oj410xAwhAJbLzW2mNuDi711fFJNvNbKslBLFTNj7?=
 =?us-ascii?Q?uH4z7c3DddopThARzYmEmKw+D29/tgZHHIEAjiNyx2UUZvXlaj11dlR79oJV?=
 =?us-ascii?Q?YA2ARL/cB5J8kDGkpulvktZuqthqaB4m9yJH0MUPsszHtZJDJl4LSwX/x+Jo?=
 =?us-ascii?Q?w+kTbKKBcdtrvrYmSO/maz9+ib4pWwfCQn27Ivg8d2WfnPrOZtHl6gOiTXR5?=
 =?us-ascii?Q?hLeg7TMos2/apimkk1Q89/uw+w95tKFnmu7uZPBknYzhcNZ4fFUGGE274lih?=
 =?us-ascii?Q?6RCCre3SmT/kglKTX7UayToP6vBLtAu3ukbLyxXbZsy0uUbU9tneNxQLW1QB?=
 =?us-ascii?Q?0HtORzpHUJYsQR3FF63hSp+4sw0sblBsxDOfZnAZ2Vu3Ov+d2hZg7QXB9jvX?=
 =?us-ascii?Q?bbU7dhFUP4SBh5BWQtwGJbOp9tTjMD4Ud2DG8gF6yqUBLMBdNiNd/ANTMeeG?=
 =?us-ascii?Q?a8u3NBdSvK2kcTXNJ1T0lO0mHuPlujby0pyeSm+5fXQLxWXpSNcNcGlDjbXu?=
 =?us-ascii?Q?T7ZY6+ios467d8FJAH/zVBWLWtlqNvaCGhc1+GYMMHTEMPANKw2cB2+KzeVT?=
 =?us-ascii?Q?LZm9TmPTvGR8fdBti64hmXempGnp1yvQpAo4TjRdZ9XUmX2tWnOy6sdnOBNi?=
 =?us-ascii?Q?NAPSetOVnSYM/uSGmCjV33QmRF2Ufbix2hbuTUVOsmlYxU1jdqgEUgA4KhXm?=
 =?us-ascii?Q?6HRqrAnq4RxF29z22Ui8WOjuoP67PRDUyK0eDFwui31C5dOoLtQmNHkOCvrR?=
 =?us-ascii?Q?WQOAaVj5LQQgO27bVIDwIhWvvQcDo0pK2Qx+HLIZjJVvfRXNuMysPOppFIMh?=
 =?us-ascii?Q?j+cwBwXiPbKh8WlNQiB+guCvf9rBYKw1NFKb9YMxJC2374k2kr9Ul6P65WNQ?=
 =?us-ascii?Q?0q/J54JwApK3zBnv8gIh2X5C0N6Vt+PkVCqwT7z/QFf5Q80ZxOnrx9t9zjcd?=
 =?us-ascii?Q?T7XajVkx6Qzt0zFqSJjHIbzADj11Y6XJv/zBt8uv5/zM1ZbxBl+6XLhcAk8c?=
 =?us-ascii?Q?u3r2/jG2jeoO+2ZLVfSM2W3TNQGGesr7/OAeQT4P5ifxvMXFnF5FtXRZlZhm?=
 =?us-ascii?Q?JTHNAbnPCyp1JRgBYrIpbJbJpyaUHbOxSawID20qIgxjOIE/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d44e3c4f-8372-40d3-31e4-08def7ef1c81
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 21:25:48.0416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dmgsg1kQxqz3MSgHn7P+5T6SoDi39QqhTJ9yWaFFxBM1yZeucLwEQOWI0s29YEEOWvSe8vrbJ0erxFeEBYA17Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6010

> On Mon, Aug 10, 2026 at 07:38:15PM -0700, Long Li wrote:
> > The EQ interrupt handler (mana_gd_process_eqe) looks up the completing
> > CQ in gc->cq_table[cq_id] and runs its callback, concurrently with CQ
> > teardown on another CPU that clears the slot and frees the CQ.
> > cq_table was a plain pointer array freed with no grace period, so the
> > two race into a use-after-free:
> >
> >   CPU A (mana_gd_intr, hard IRQ)        CPU B (CQ destroy)
> >   ----------------------------------    ------------------------------
> >   cq =3D gc->cq_table[cq_id];  // valid
> >                                         gc->cq_table[id] =3D NULL;
> >                                         kfree(cq);          // freed
> >   cq->cq.callback(ctx, cq);  // use-after-free
> >
> > The handler's existing rcu_read_lock() only guards the per-IRQ EQ list
> > traversal; cq_table was never under any RCU contract, and a read-side
> > lock is inert unless the freer also defers the free past a grace period=
.
> >
> > Put cq_table under RCU: annotate the base pointer and entries __rcu,
> > read with rcu_dereference() in the handler, publish with
> > rcu_assign_pointer(), and on teardown clear the slot then
> > synchronize_rcu() before freeing the CQ.  The grace period blocks
> > until every in-flight handler has dropped the old pointer, so the kfree=
() can
> no longer race the callback.
> >
> > This fixes only the CQ lifetime (the use-after-free); it does not make
> > the cq_id bound trustworthy.  gc->max_num_cqs is still range-checked
> > outside the published table, and hardening that field against a
> > spoofed device value is a separate change.
> >
> > netdev teardown destroys a CQ per TX and per RX queue, so one grace
> > period each in mana_gd_destroy_cq() would serialize up to
> > 2 * MANA_MAX_NUM_QUEUES synchronize_rcu() calls under RTNL on
> every
> > ifdown, MTU change or ring/channel reconfigure.  Clear all of a port's
> > CQ slots first and take a single grace period per teardown instead:
> > mana_gd_unpublish_cq() clears a slot without waiting, and
> > mana_gd_destroy_cq() -- which still serves the single-CQ callers --
> > finds the slot already cleared and skips its own synchronize_rcu().
> >
> > Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure
> > Network Adapter (MANA)")
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> > Changes in v6:
> >  - mana_gd_unpublish_cq() and mana_ib_remove_cq_cb() clear a cq_table
> >    slot only when it still points at the CQ being torn down, so the
> >    two-pass teardown cannot wipe an entry a concurrent RDMA CQ create
> >    recycled during the grace period.
> >  - mana_gd_process_eqe() drops an already-unpublished (NULL) slot
> quietly
> >    instead of a WARN_ON_ONCE() splat during a normal ifdown/MTU
> change,
> >    and reads gc->cq_table before gc->max_num_cqs with an smp_rmb()
> >    between them so a shrinking re-establish cannot pair a stale bound
> >    with a newly published, smaller table.
> >  - Documented the cq_table/max_num_cqs contract on the cq_table field
> >    instead of rewording the comment above max_num_cqs.
> >
> > Changes in v5:
> >  - No code changes since v4 (resend as a standalone thread).
> >
> > Changes in v4:
> >  - Replaced the per-CQ synchronize_rcu() in the netdev teardown paths
> >    with a two-pass quiesce/free that takes one grace period per
> >    teardown; mana_gd_unpublish_cq() splits the slot-clear from the grac=
e
> >    period.
> >  - Snapshot cq->id and max_num_cqs with READ_ONCE() in
> >    mana_hwc_establish_channel() so one value sizes, bounds and indexes
> >    cq_table.
> >  - Corrected the gc->cq_table lifetime comment in gdma.h; rescoped the
> >    changelog to the use-after-free fix (the bound is patch 7).
> >
> >  drivers/infiniband/hw/mana/cq.c               |  51 ++++++-
> >  .../net/ethernet/microsoft/mana/gdma_main.c   |  65 +++++++--
> >  .../net/ethernet/microsoft/mana/hw_channel.c  |  29 ++--
> > drivers/net/ethernet/microsoft/mana/mana_en.c | 136 ++++++++++++++----
> >  include/net/mana/gdma.h                       |  37 ++++-
> >  5 files changed, 268 insertions(+), 50 deletions(-)
>=20
> This patch is so bloated with AI that it is hard to read and difficult to=
 justify
> such a large diff for a simple change, which all drivers experience that =
flow.
>=20
> As a bare minimum. you need to reorder mana_ib_gd_destroy_cq(),
> mana_ib_destroy_queue(), and mana_ib_remove_cq_cb() so that HW objects
> are stopped before SW state is torn down.
>=20
> And probably introduce get/put CQ primitives.
>=20
> Thanks

I'll clean up and follow your suggestions on v7.

Thanks

Long
