Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012057.outbound.protection.outlook.com [40.93.195.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4A337106E
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 23:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792107802; cv=fail; b=QQTg/JoQlZIWnfVweUhcLFthpf12tc2LqH70yofV9bhhv/wcZVmQU36kR13a1MrpNQ+miVRI0min5GietjflQg2Uj/xTIEiClyrz4asmn0umrrji75kbUuQQ38G/GZfYgzyagtk572yRtPgFSnIpEC8bf5t475egBOOblN0Jdbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792107802; c=relaxed/simple;
	bh=JsJylK9p3YQacbsztoVTCe9kkxSxmV3Y+tmWcaEWF3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EiU7F45pDEllAfjAhMiSeU3EElC3nHdcjhcCTu3/iYExhkMN9jPPsl37YCHqSqaAgd/3DmInw8WpFYmIuV6z1lQqWyFtAWSIcnru/LDylKKlVL3N9abF6DF2GTm18BSuvTY7CvxqdmwfxisVEVEnXzP33hyP10G3UlqwTatKs9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhYshIJd; arc=fail smtp.client-ip=40.93.195.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhYshIJd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tsy10S+zV6uzxwuMHqOSsO86v+Wqr9mFybjnRY46x5AAPMFcy02RdhUNhUc8lcf5vJ/3MS3+kHUqcJXuB88vRhdQnVRWihSZnBl8hibyl1gmTgkdZ9YJhyTbFxv9hNd8XCvP4GvYz1RvYqlcSQMe0xBqrHHvfN4lfGE6By5AFq0ECrPDlbkElam421fWPvpM6dq/AjnHbNwTiqKgk9kPCFqOkPz9RLBygNf5mqJnc1u8MoLOnEm8ZpshHl4y+KEUlCOihJX8fpXQoADWkRoKbuTlL19asZaUgvulradQW0D0VCTCOALGXoWRiYO6WfIw1bKm2iyfB58uTeGHXJnqew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vm2OuAMtgYBSuXOkWAr8+s3XpQc3aR3GF8qIx2oS110=;
 b=h3AVnKMmDHrnqaQyTKO+JrJhuEI+Y0oZ1s0U6Mm+QjItZdqdjNFkUn18mTlDZaV4gP4xGgGW+xH6st/Qv+kfxLJr4dANfSKGQIIUrOeKzYIHDHNca9eCrBeDPp8l6EhT+dBx+Rv04NEwv+9XSVgUzNGcHp4XCJlGKEG9uBItKQM2rZScAFlN/j2OGBl5YNeb4uJnC3LeFGYmkPJ71o4RrGE7NznD0gUsMhcdQk/Q0B/zoCSkZ6r78CbNtf0lL7nHjDBDodglT5uyyk8Qk2hAw0sHDvto+HuDM1oDoI0z+QQywPUx8RFzd8+YPFePHxxhL8p03DLsUwDyUsVCGzkbqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vm2OuAMtgYBSuXOkWAr8+s3XpQc3aR3GF8qIx2oS110=;
 b=rhYshIJds8QJFUI7lKjTEHQcigPbXT6fs8crNDGHqZ+Zr6Y4XHphQ1NYrf50LouKQQeCX6YPP2Ye/VoWYncKlDcc17mTTXLuXm6AJkmCDmw97e6mUXTpejaPJYCUq4X6x81B7hsqABsfb3N2W70VNTs/U2XMTu2ehFJDvFbF9ad+T4w7ZOs2z5MDdm/pG9cIRajyOVYzqOxHWW+eJ/XFRRBJtuq3bXALTb2PGzDAX7eJ5Gcv3ysGAc7PAOO5oaxCDSAw711S0wk+HglUd3DVqcyMAvNnGyERlPV1r1QlTui+3Ruys/HhYBe4yuX8z0n142CzeQAFYsf/QW3Gosk+Hw==
Received: from DS6PR12MB534567.namprd12.prod.outlook.com (2603:10b6:8:498::17)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 15 Oct
 2026 23:43:12 +0000
Received: from DS6PR12MB534567.namprd12.prod.outlook.com
 ([fe80::4b0a:a4e0:694f:c2de]) by DS6PR12MB534567.namprd12.prod.outlook.com
 ([fe80::4b0a:a4e0:694f:c2de%5]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 23:43:12 +0000
From: Sean Hefty <shefty@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Eric Davis <eric.davis@broadcom.com>, "sashiko-reviews@lists.linux.dev"
	<sashiko-reviews@lists.linux.dev>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>
Subject: RE: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Thread-Topic: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Thread-Index:
 AQHdXCpo3QYvbgzNxkCV986BMmoEJ7b9oFYAgAEjKQCAABq+gIAABevQgAAhZACAAA9roIAAIvaAgAAFnrA=
Date: Thu, 15 Oct 2026 23:43:12 +0000
Message-ID:
 <DS6PR12MB534567FD2D0B8E729A47D0F863BD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
 <sashiko-outbox-171976@kernel.org>
 <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
 <20261015173327.GU14213@ziepe.ca>
 <DS6PR12MB53456734E5A7CFFCDD7FBCCC0CBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
 <20261015195408.GX14213@ziepe.ca>
 <DS6PR12MB534567DB240CF76594BE5B5D0DBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
 <20261015225427.GY14213@ziepe.ca>
In-Reply-To: <20261015225427.GY14213@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS6PR12MB534567:EE_|SJ0PR12MB7066:EE_
x-ms-office365-filtering-correlation-id: 0a33efe8-871f-4b57-71e1-08df2b16135f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|10070799003|1800799024|366016|18002099003|6133799003|22082099003|3023799007|10067099003|38070700021|4143699003|11063799006|56012099006;
x-microsoft-antispam-message-info:
 w0PbFE+4WYMc7Z0CZeJI+6tRhh6X12vEb3T6quvxKxDmfNHFOizlP3i/cEwU437fV0E4soUSZSUfWmNW/I5QRjt3jNVHvBigljejAxLAehjc2uGxVWm1ga15eVw8r4lp4BVak9lqE+7qPaH+Ya13dJmR6y4i69mMle85hzNOOMaaJVfUEd6gy81WWPK6ygQBmiBE3VBQJNIKzhPx9RQf28cKiE8wNFv72yoW2+A77FC1lcJ4Ff/5Ruf4kkUwaYffhFhPn75E/yFYgc9K+ylk67NiD4vFGariTiwG4O312vavQsDab4EEDE/YGHTV9j9i5bYbsvVNAEhJVT0vq/238tJVCMsfmOFVDxU61Xy3RfJX7vexEoFvQosN9f3wi8b7ykITP/bJ66ED1jRO3eqB7ZZ0E73iyYhpeTH9mlmhtDMWyKm3DkJ1BE598Jb5UrlMzEFYC6xdTIfUtuziRZA5UNd3jGVqx4/Q+rfDVORYlxlstF+oz2AZZnxnGBeKLoEbGoDzCDsl8flwrCOmCa2aUSGnLE9d82uT4FNbTAjGALZKyoQmJKKBCqTHdJcZnGUQu4px4Gbrnlv0rXFkgXCttwaqoaD9XA1jGawQB78NDkM83WW7YpOiKCB4RVc7jeZggHHtLD5AwUNJWDdOe49BmMFzy7KQQblR1DqY2EuQwmE4PeZAo0ZDnS6TSQF4nlaTUEOJ9RsDFTy3iWuVbwyWtpOuwlxuSc7EOeYyJox5P8w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR12MB534567.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(10070799003)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(3023799007)(10067099003)(38070700021)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?W83Mqlh7NW3wJdf20m3fp7yESL8nPwjJk2ZsEDI+7PDtS9NKJsZ9u9IcKwO3?=
 =?us-ascii?Q?iKf91LtF3lqeIpqTRGhsr2sjiAO+lzrnT+xqC1qvfcoAaXVzh/XqwgKrYueU?=
 =?us-ascii?Q?AIpdEC+Xzzom5p2SDWW1RwyPwLGFiGZbRMy5OB7PLI1wre4b5XBLPV1IED3R?=
 =?us-ascii?Q?JzCfqv6Mdaqp9tlbB5h9OvU6jWOaB7ljp9pR29c/Hf4K2CqQuaUsNTiOVgD0?=
 =?us-ascii?Q?INh3Hq429WTXUK6KUkMYDkGMwXeY4zHbfs8RAsmcDJBBYH4GXi3NpVOD6rrF?=
 =?us-ascii?Q?CYYoWeAOXl6bftcfS/RifYezDysZHuIW/lVVYa8Qsh4StFOZDpTChDZ+CT+E?=
 =?us-ascii?Q?mxwfNTuww2v6WtPMnT/J/cmk7RQA9jqt15hhiJgvrGOIZOLnepZf4mZVgqBo?=
 =?us-ascii?Q?b8neNOEWmnZejrDh/koyzshfxxHwYqO+70rGyS1ruHCMn+PVl2kns5sJSQAb?=
 =?us-ascii?Q?SZHd+ofbc7tR6OFSniL2v2k5CVa1cB/zuDZ//oIwDQgaumwfjwQivqs0GKKT?=
 =?us-ascii?Q?0FNFQYN+3IQwOj0Eua4vTKfi7rw7fHxhGxxFYuixbBPFhZ2SYiW/pIdRWDxP?=
 =?us-ascii?Q?LJGSFcZCwdHuEZkpQbcoNWYpHP1jStxuFznJE4bPogQX3Gwr75e1IFvrfFg1?=
 =?us-ascii?Q?yHyaPimw0dPDCAjLejq0nk6xQUVKPNahSTRjiXYmceBMUCTKocBsl0QyzhLn?=
 =?us-ascii?Q?uEMbM4Ti+eL+hD1N32jzZx9SE4RR9+jiHAn0eJAvJrahMlNTZb3zqk+PH3kb?=
 =?us-ascii?Q?4ppZbdcMO/NEcRvN/CDNpJohOJgywQEcmY64ABg0vNgA1ClSdXvoUJ7MSsYf?=
 =?us-ascii?Q?67utzZdYhgfqRGzjtifc6IQBeQDoj0ju544vuJleAa5g9Wej/5Vs1OdJyhoO?=
 =?us-ascii?Q?uiPiP9LdC8YTSlBXhc00DptQYj2vPmoXjWUKcWRycrVbXRo6TGjycWj8dMb4?=
 =?us-ascii?Q?re1df6gACyki8wARulRE+gl+s5dX9GeboUl9No5cqRgyp2jIZ/GfofRfBkyP?=
 =?us-ascii?Q?F54laILkZvl5jHtDLH91KM+Y0/FHJNqQPJBRdm/gHXaBnBiCaBNaayZ+SeAz?=
 =?us-ascii?Q?7p8wpLJQH/8zIlRlunGU8YFFmc9ro5zBsvWXHwbz2dfSTpUYDaJKYk1EXgQt?=
 =?us-ascii?Q?xvVQJsVqFRiaNvIAWurEjye9uphgFJTeuefyWhpzzjCkbjZnl4T2MUizyV+o?=
 =?us-ascii?Q?nXRrjqegLC3QcEeBsCAd4otbEy4F+eayCjKr72vLvFgSaaV7xsZJGapvtBQC?=
 =?us-ascii?Q?WryuIYkWEKfrH4xTpjEiRKRBCL8MMDY7tFNfqGs4hv352sIAmL5hZbs93iJF?=
 =?us-ascii?Q?sQvuQe9zr6+7K8ouDgA+tD7hZVODqMFyClmBNkkPS00GkPiIE/jl7mMFHzAV?=
 =?us-ascii?Q?CHfPAaz1jy42cwL/EccVSzKbBiDir2Ts/HgYdO4/EiYxNgX+ct6PX79ODV63?=
 =?us-ascii?Q?FbUaQ0xNLUNcw1qhpxZRzcAni3efcFu1DwOsuqvzeO72ZUmvKk7qClfQlW95?=
 =?us-ascii?Q?Kzwp510+qfkdoyTKR8phXEFVgPzdAiQ3hBpYgam4DMBKr5ZcWAAJwAgFmSMd?=
 =?us-ascii?Q?kX90o+TFrcUfFErMUv5lOav82bAaz4gjdN05M0vlU/b8YTRNc7gTtsGkCL3x?=
 =?us-ascii?Q?IB8A5wQMsFcCRyowI6CDkCFcwi4N459ytgOK2bb7nkmBjx3tzr+Q+3vxKbIj?=
 =?us-ascii?Q?I6EYHWER2rDuQgNSTV0g5nhUvD2NFIRO6oYLoPAwILperGL1NTy+nCKcKwPM?=
 =?us-ascii?Q?fTYHstxC5A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS6PR12MB534567.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a33efe8-871f-4b57-71e1-08df2b16135f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 23:43:12.3610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R4jfrMIJ64zhntSwRn4JFy1xToPnFFL2HjHpe8tFDcnbwMhmXiFq8qSVVcM+QV1E0LPpoQgu4dBbW+wvISnF5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

> On Thu, Oct 15, 2026 at 09:14:22PM +0000, Sean Hefty wrote:
> > > > > > > Could this cause incoming UET packets to be incorrectly
> > > > > > > mapped to a
> > > > > > > RoCEv2 GID index, breaking the UET transport response?
> > > > > >
> > > > > > On a port that runs both RoCE and UET the MAD traffic is RoCE,
> > > > > > so mapping it to RoCEv2 is correct.
> > > > >
> > > > > You will need seperate ROCE and UET ib_devices with the current
> > > > > state of affairs, we don't support multi-protocol today.
> > > >
> > > > UEC intentionally considered multi-protocol devices, with a vendor
> > > > deciding
> > > whether it would need to provide separate SW devices.  E.g. using
> > > UET for MPI, but RoCE for storage.  Protocol selection is via GID,
> > > same as RoCEv1 vs v2.
> > > >
> > > > What blocks multi-protocol support?
> > >
> > > Principally I don't think we have the APIs to discover and link the
> > > GUID to protocol to QP type appropriately..
> >
> > I'm missing something regarding the GUID comment.
> >
> > The QP protocol comes from GID index, which is discoverable via
> > ibv_gid_entry::gid_type.  (UET QPs require the GID index on create.)
>=20
> Hmm, that's not the normal case, but I see what you are thinking
>=20
> > E.g. a dual RoCE + UET device would report node_type =3D UNSPECIFIED &
> > transport_type =3D UNSPECIFIED.  GID entries indicate supported
> > protocols.
>=20
> Ah, that would need some opt in scheme to get there, but I supppose it ma=
y
> not be so bad.
>=20
> I thought there were other issues like PDs not being entirely compatible,=
 MRs,
> and so on?

There were issues, but they should be handled.

The UEC 1.1 spec was updated to allow for the equivalent of PD level scopin=
g of rkeys, aligning it with the RDMA stack.  MRs and QPs must still reside=
 within the same PD.  More refined scoping (limiting a MR to a specific QP =
and/or job ID) was added as optional MR attributes, subject to vendor suppo=
rt.

MRs expose both 32-bit and 64-bit rkey values.  Apps select the correct siz=
e based on the protocol.  My expectation is that a dual protocol device wou=
ld just fill the upper 32-bits of a 64-bit rkey with 0s.
