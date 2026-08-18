Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021119.outbound.protection.outlook.com [40.93.194.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5C48124E;
	Tue, 18 Aug 2026 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787072867; cv=fail; b=q7bLCTeq27IgStNjzhpdDmqdpDx7wn0YwZlD3K6Gx40ukf+Qlu/L0vNoHsm3CA2IAwucxe9nELkGU5Rg0s0xeUNr3V4hcBHINx9dIyZQYcTU2Tr5bnmtebcEc+MfVaHdHeJtbRCMRe7j5ndwBex1txioMdFGtWjYlsP9d2SxIgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787072867; c=relaxed/simple;
	bh=CVzjVbQLL0kpFcfjhvuq+eRsbvVtMrDs37W4W7zA3vk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uCEFw7UEH0JZ/7myhrANCzfin85oMigRjKAVQuoyfLvV33wPxR3QUsdHCWoKy1IJp5W6wig8W76/hNM2+qoowpruZPlPGlAYFDkrVN4iXZADxXhlMITm2MNVL7BSgxr0O9LfxdmxAV2A8E19U88ZN8pVYOq54HYmyA9lYdoi3T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=OahKktjz; arc=fail smtp.client-ip=40.93.194.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="OahKktjz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rD1TfTBpCCQ0oUyiKnHpkauzcbZU3cLb0OakErHvEZQrdc80qsoEWRtdKeQKHE23UbwyAltQwOBBl7SgJAwSkNJ45QFEeZfvaUtQV/9B7MXEdKRLQyK8my33TmRrbxjZaFx/X0FdDihzPLW0/5QYrl2jt3H8LVRJdcJgzGgTI9iqiC0r08v/3j3VMW+mymLpiFlzL/SljcCzncVnRT6Vj5ySyI2Hq7TXsjFQe4nwvjXcRwnU2EC2Tidlp+nKm3h5tXAsjqwmKk0txS0NgGtBt4BPgmdDSv5toK/F+HDu/u8qzyu3qJqXU5P7CfyZxT0B3oFi+RpN4bnjJ3CSj09xNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZb7cMKYLY50/yQObpw+l7leMHFBKhLPej7yGyISNb8=;
 b=ChfP/U12R9Sy+kWVy42W2RcpaLm+44d+XS/6FzIf1ElIUpZoIbKQLygcrfEoHkt9LGtvaGO/uBYSEiXM/anWE/5mKUKlFj4USQRwNvq3c0VzCyakAkaAheGEYGcADO+g8penU+yZ07cPFu++Bo9mKau5T2TuD2GeFRCmZ7O+rtCtMDaLc6/4b13fo4hd7+1FV3UOBeVog00plGjZqOwhdwDlfqcfQ10JsZKL5twUJAmuHB24gRfk1lgm9FO3iuniQV6r7x8zw5N9eO7dhjcsHY2t3m+sUZi9S6rcggDE4jnjF5uF+L01LkASeIOU4LkkpB5ayrkUCw3+xm8evUJYCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZb7cMKYLY50/yQObpw+l7leMHFBKhLPej7yGyISNb8=;
 b=OahKktjzEri++MkUOAs/0xP07OK8nk6KxQ4nRBtZgntqf9P+Tlpx8ble5htQ87Wutnm3zMRe0HdG3OnuH+NEjXRGBBwhCO5AhgB6Wjw9VZoNxeOEf82dxu/rESFkPA4vZS8pdYRF1j/rP2qVX6dhTHu3gn/YbUZ8h/lx82p5xaw=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by DS0PR21MB6338.namprd21.prod.outlook.com (2603:10b6:8:2f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.0; Tue, 18 Aug
 2026 17:07:41 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Tue, 18 Aug 2026
 17:07:41 +0000
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
	<stephen@networkplumber.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v7 1/7] net: mana: reference-count CQs
 looked up from the EQ handler
Thread-Topic: [EXTERNAL] Re: [PATCH net v7 1/7] net: mana: reference-count CQs
 looked up from the EQ handler
Thread-Index: AQHdK0s6b8UCd55wMUCoJkcRBEYEpLakBESAgAAAPwCAAAz9QA==
Date: Tue, 18 Aug 2026 17:07:41 +0000
Message-ID:
 <SA1PR21MB66837771ABF2A8E34FA11B3FCEA62@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
	<20260813174243.3044348-2-longli@microsoft.com>
	<20260818092005.25dfbc17@kernel.org> <20260818092058.5da26ce6@kernel.org>
In-Reply-To: <20260818092058.5da26ce6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=264cb2ce-bd03-4684-b0f9-b78072168117;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-18T17:07:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|DS0PR21MB6338:EE_
x-ms-office365-filtering-correlation-id: c34df49d-c17d-4dbd-2d27-08defd4b36a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|7146999003|10067099003|4133799003|6133799003|18002099003|22082099003|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 iJL68izpz098L9KDaFMWU8YRefEbgNHLc5bKy3ZcUnDBnuLn0loXHuADv0RfGE2c+tpTYT+4nDSIobaBWnUKY6fCZqlCml2AlnU8EFm1/4fClxYR/zCAMH0jzH2xxtAVx5B6wOPvKQilHO7YwlaIMAHiAQ5eBE7TH7lTAoMx0ACRYaDOCYTNmh+Bpfzz6a5f/vWGk6kk/zBkaSxJ00gqIwTPETLWvGPd1i4NbpPSIfxuD4Mv+pBEQ0862tzwlgVQaQlam0fbjmtQkzoBht2i/SmRhMfr3bUDGpHfDYVCpFjjZksb+1KQIiM7twY5dKGe/OMk5inwQJgexOhxNqRaBhXLpS67VL/GYlC3P+a7zHE/IMKRk8qtGjLPxACVQmGPuqt6QLX2vq+nvalKJFU9Gu9wyINRszXRlaJClvntQw7oZwT0kKqh8LRl1Dl5EYyL0GSBhQQaIjevBwu+XpieNNaHWbLc0WS2iYja/qpNN1qkY4HxclX+GtmUXmK0lenDUOiaqDw33VbsMgTI5+eB9o2G1wbMB3Csx6pGLY4vBOtfK1OelSOaoRvIF7XlbZ+CoR4rhU30Pangxo9eCO9YDSROunDNmcsIPTzlEBNezsPfmtXOeu4letfnsJTbuJKW/8mzot9biE+PXcNvpN+JDpy88lDaGy56TNCEez5VWVlQjb70vY75G5P86Enx3ejl9XAPGilQRPkDpQTjRnqzMYm9G0CYkDa5tPtFx25yzw8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(7146999003)(10067099003)(4133799003)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+N7RstzkWnPiCJfcWQdhkZZFSd7SWwo6V865PoceViMu4iZfooB359VjstJT?=
 =?us-ascii?Q?vjSNL4/Ow4DNbpoOW4iHqGsQhKknwrBT2n5aK6heW6KiKgklsuY/Whwi+G+C?=
 =?us-ascii?Q?0uOmvoqM18ShyaRFS7U4L/xyrMVP4LTLPdyno/8GnQOv9lTdCRCT66l6koHf?=
 =?us-ascii?Q?9xUC8g0Jh5hLlBhLXhOdnl7tsutHusvt0pc4ID7706yA3bVcTeiDYAHmhC6k?=
 =?us-ascii?Q?tQhFay9KO/IhsnRPJ2q6WhnlX9fqXMq8VmILG0HS1AYc4iWGsO3ZQcBkmj+/?=
 =?us-ascii?Q?IpBWd+Mz3Cvejdzz9wk8vIVZoCPqsjlHoEKWnguqHiTM3B4K3aad8b2dc6zF?=
 =?us-ascii?Q?POVeTDKe62SSwekOc81POGRHPOLciSNPtxldYAoY6P7FHsecDd3vQOsUqjE6?=
 =?us-ascii?Q?tfN6u5gnWWTbPv8d7GNynhQ9gJHEgPLSDqETxPMi9NTip5Z3NS/QTutkyoDK?=
 =?us-ascii?Q?6HCo3E6YMwgYq2Wq3v4PbxIGCRyBblvrmG99UR48kM2cXA55MdIb7T3XOTNB?=
 =?us-ascii?Q?qJ0alNZCwSN3WEUeWHVfAx/q1RcPEYQ/FFqqTQAZnCTKGrkeKFXnX2YNQY4K?=
 =?us-ascii?Q?LDY6BSv97SBNu3gUrPeCyobVxn5GMNDw3RqNnlttNrUBtaLBzh5x2BFR0YgV?=
 =?us-ascii?Q?guYMgZgPU4ILgzYASrIIK3BstvbsOHcJme1EDQ7eDEmHfa1oFj5DKgzdZ4S8?=
 =?us-ascii?Q?qFtWx7URIT3hfKoGUAafOGrUI/GYwhPM0SU1BS458ejhiT69pFpy6J8oMqQE?=
 =?us-ascii?Q?I/k3bGQGDC1JALgxE4bdchFUuH1aPi06DkFstbvGVe8N3oFL7JWBQ+kMTCYf?=
 =?us-ascii?Q?nb5WBxXuc7tIPA4Zd3GOY8z3YOItuJSt0qKG9B6WYCHNJ4cyFy8I2vp6dM+F?=
 =?us-ascii?Q?6A/DRFYSkx7QibQw8aXDQkSw1YRDBeI5leFi2Low16+CG8LaiSrutaNyUuux?=
 =?us-ascii?Q?oslkEsvj2ZWYO99pwfpNCzDuUyCE4Dkv6SNkfhLyzx8YiFW6gNBxbBU4OtcM?=
 =?us-ascii?Q?fPF/yy/DoDTx1yqIopzb7G1n28m9fSuuWdZneShE6DuKxMQBs4nkKkF99P/B?=
 =?us-ascii?Q?U4gVOZDhIEAuaQqNKk4M8fWNDYazdRTPKE1Gani/RTbVgG1XU7t6+dp1R1nH?=
 =?us-ascii?Q?g36tmazb8rYWDV/sdNpWnrxVHPEWHN8J/8Is5TNkwYfq3Eg9AoLIVzY30xmg?=
 =?us-ascii?Q?lGZsSh1UlNCzJJUBI8pImo93iI68JBGb0XySX72vZoGEjC5+Uw/3Vt4Gnjk+?=
 =?us-ascii?Q?iLSnfXX68ZjB9ZB2l7vOYnm4Y8lRVL5J1wMJeCi4CnbezN0bkAt2/M+S1DPh?=
 =?us-ascii?Q?hJSCXZ96ifHcSb/UlaEVhIw1BvbFKX1XJAKI5sYA6WwIZSCaiERiIFgCIuh5?=
 =?us-ascii?Q?p7jznWvCF04tnjoj5skVZkkm5Moq6H8L/2DZ9Owwcfu4smNLArw9gueiDMBv?=
 =?us-ascii?Q?SRmB2L7th2Aw30ZgHPkSYrJM8mbQB1sKjZuAhb6mncqFLnxilVS90SoOCtFz?=
 =?us-ascii?Q?4c3OLzcDdPYg4jckhnLpxGtfkUHwOw5Kc0Y4mJFPwqYKAfQ6W6dC5jNa4H64?=
 =?us-ascii?Q?jKgHcXotKtNDsOoM1kjhAfolhF12t7kJ+rwbk2I/+0MCfJT32dE+KocyLtrG?=
 =?us-ascii?Q?dnezcXNxqRUe+Hx4BdxzjUBme3WycJJxFZoWqSUCHvyleQHlRFnfctN3K+9x?=
 =?us-ascii?Q?NHESLLVs63mN+NXaIQZfT05+l9X/S0xXKJPilA+0BG+n/6fc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c34df49d-c17d-4dbd-2d27-08defd4b36a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2026 17:07:41.4033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HztWV9rkK1fhECUJWxGWZpqdwNsuaL11IJNlvChm9bTATRfn1OmMlOVM8MrS19rpDsYmTsirDXs71vGS8zyZTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR21MB6338

>=20
> On Tue, 18 Aug 2026 09:20:05 -0700 Jakub Kicinski wrote:
> > On Thu, 13 Aug 2026 10:42:33 -0700 Long Li wrote:
> > >  }
> > >
> > > +static struct gdma_queue *mana_gd_get_cq(struct gdma_context *gc,
> > > +u32 cq_id); static void mana_gd_put_cq(struct gdma_queue *cq);
> >
> > Forward declarations are considered a bad smell in the kernel.
> > Please add these functions here, I don't see a reason for this they
> > are purely calling kernel APIs.
> >
> > >  static void mana_gd_process_eqe(struct gdma_queue *eq)
>=20
> Well, prolly not gonna have time to review the rest this week due to the
> merge window, so pls TAL at the AI review as well before you respin:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fnetde=
v
> -
> ai.bots.linux.dev%2Fsashiko%2F%23%2Fpatchset%2F20260813174243.304434
> 8-2-
> longli%40microsoft.com&data=3D05%7C02%7Clongli%40microsoft.com%7Cbf02
> ba497de64cc264b108defd44b162%7C72f988bf86f141af91ab2d7cd011db47%7
> C1%7C0%7C639226668643687247%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0
> eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCI
> sIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DJYiJcy2lD1rOwRKuxfrm3zm8JR2n
> rwDggk0GC%2FgH8eE%3D&reserved=3D0

Will do, thank you.

Long
