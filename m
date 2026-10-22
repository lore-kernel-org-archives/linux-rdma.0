Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792693758;
	b=ao2iJPWBRewRpjXLQjh4WC63AT/hFDqb/5zJw4B5qEsFDEdsrl2WQEBlMm8G3O+vPmOP
	 HFTl+2nZgil0ewqmnwT82zlINimlcYXWuBh0JZoI460VohtJlUPQaxgSLSdEqIz1GCasa
	 7Fw/WHrfeS4i9miE8t+Ch9i0PMbKonHyzZ2bfDrKQICTUA2shMOl4s/V5LLwKrjqlFtdQ
	 sLwt+jYwDvKvtRO/C3DjDaKak7ZZUjL6QZQViyTkba4VPBPdq1ecsbfNlDcueOIxJYMqp
	 ulTxaZR9hWY/q3oKy7TnfQaccSfVeVkjQbRP5Ypyr0OudfuTZ3JTaQZoPwVGDCfitfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693758;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:Content-Type:Content-Disposition:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=aGbYuGFd8S8Bs9KUvlCMSkY2vIuMwchVQ7fE1PetMiY=;
	b=ywLPsW3zMWCNP0jGx9U5jZvjWDzPwZhUsgU+4qJYiRaMFH/pBaE+UaKf5QR2Iieq+a6C
	 4ILVkASkMekY3ft/bxnSYesYt0zwllFQto/zIPyF78rK+E/r+lN7fsi7Yjjp5v+qe1Abj
	 pLANHDiFFcx60UIZxRj95+Wvle7e0NG8rPhCcvqL/MeL4DuGdBRo8pgUTFEMkJFFsYHRc
	 Is6wqPlNHL8hdwGv7iOxOj8yn/nE1QctEd3ybdwkR6r40UJXcJz71ixXDCbKUyaZXfUWB
	 USEBhbwxpv40nazu0ONa5/KZwNIZGpkT3/cbG5VDLTHt/SISOWeBF0yvoEsUJw6W5MA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fuDQPKPr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.26
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5BB606A319;
	Thu, 22 Oct 2026 18:29:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA5BB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fuDQPKPr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UkdvEnXMu+JBaVuDD+woTfKeQBl3VoCMuYFuel/vY50C6iCVWt260f0tdKhNTrzw/JAgtnLmjwdwtZM2JWJdwX40UfV/OJgHLDxKhUrvy2WiNmutVtykWYhcXppDIeAsXOUHNOL3Rw+UxhGfQN6Mlz/moHUPMCDLTU2dG7V40uXqS51vz+UjryZpnmSjxIyHLHf6SUO3iCUEfc914Ly17pxGk74+cGCMQzBZNBRGVvsEEVkIPlm5LWRzDAQu3Ivx6q5aZoaKb+hkoVnRJHGRl0MFHpB782PSPX2RM29JLrhOD1Acd+g0j0z7JQgVaEGn5v58OZtDs1Y05CYyw3FW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGbYuGFd8S8Bs9KUvlCMSkY2vIuMwchVQ7fE1PetMiY=;
 b=heVKzDOyU2fOfYCz8awFEA28AFmXJUJunyh9isfb9Den8BKuvfMQ85YYwn+puQcfTSDAp42rD6uIFKlbmqTHLbNmbThc5E2TYsmvMPh5cu6lMoEeTo8uNCNVNxaiRQeF9l0Q77W0cs4T0t5WbzgZmgad2sj+hfCI+IeqgnJL5f1z8QJgdxdPz/oAIe2U25gtxlu1EnP2FNsPCGzsDpm3J95uDSjBfBfgtjGUqpm0bloh1IErg8KJ1//X1slnuea8iQDkbH446CP/2FmZvpQ5OSZRJI0EwaKivlh7fS+iSwY3pqskvRJYZMWbUE2OT82prdVyjedbiD4J9mpyvZwdUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGbYuGFd8S8Bs9KUvlCMSkY2vIuMwchVQ7fE1PetMiY=;
 b=fuDQPKPrgmhorzTZmHk9LNZNg6rTA6fcPhakTbpI2HflYddZQ0A6lKAtexFa5WhaR2+6wdiQVTx0fs9qQwD/bsMQnlChgbehYsm0Oyw9Q5oH7EELZevqCDo0Fdk+jZrwAA3Hp5adn5t2L0QSS8gncnjvClAKe6koWBhe5sVUAPNJqpt2jd0BNRsv5Yho3EiYWdf6gPQVz1XzVGtDoOYIMZXEL2R0ekK9JdTPe/gkmmKLuAB60er9rdYt0opHI8jELGyn1QfgsyHpifBuIJG3PqoJpRj3zTG9ZiKgsV01XeqcrEGxQDGOwsJsGAnOkZsJjkujV4ZvKF3pHZABYRaqSg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MW6PR12MB7072.namprd12.prod.outlook.com
 (2603:10b6:303:238::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 18:29:14 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 18:29:14 +0000
Date: Thu, 22 Oct 2026 15:29:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Message-ID: <20261022182912.GA3745036@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KJQ0BvcgHr6XY2bt"
Content-Disposition: inline
X-ClientProxiedBy: BN9PR03CA0626.namprd03.prod.outlook.com
 (2603:10b6:408:106::31) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MW6PR12MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba2f9a0-4bff-4ff4-8608-08df306a5f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|18002099003|261022105027099003|261022075727099003|3023799007|11063799006|261021123027099003|261009223327099003|261021135927099003|261009223027099003|261009220027099003|261009221227099003|261009221727099003|261021121427099003|10067099003|56012099006|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	rXmex4fCYjBZnhcmywBNQVmPkv2did8Ex049sx6+tbX8tRM0fOeUuuAA8NRzd6wmsz9uo9feEdF4YaYk5P9jWSbT6pthL/96tRDLjCdjD3SYSf4iwnA7L763VPMaqIVreQ4KSqJl8CAICsHJ6bK+Vggp0k80Ry+3IHtQ0hE7uuhcaqj3+yHWARkBbqlQccFWrwpZvoJ012VKhsnAbozodEyq0l1CFqO5DjvRx/FEWv8hcKm1Xxd+VPdUM/s04rbE1u3aK+aiB/7TAh0NOy+xfAsE8YETUgYZKEtQPzL9PDEMGvm7y3Y2F/RWWcQfZwnPf79Z4w8Sw/5S6s+CaXZOm/dh30uzAkVXz4bbls02Mhu9L9r/TN2/jyPWUl0xmdL4P/tz4S6HCAt/GV8fsA7AjrLktKg7oGSAa+6qbVBQ5rpv+2kX/MF8oS8QEF5dOM5CAXf1yknliYqMV+QmHSHyxuF9d9HKQMp2Iz0daUJWbRB/A1stWssphlQsy1/oR6kYmTx9KC28p5LbRkLFu/MSGSbT5KxVk3QAfb3ZMqOmhnFSqcrQfPWuN5e6ETGn80FQF7WBaQj2ahDb3bDqn+wFx6zOmhuRcDjM8skSwQyHY44j42j9caOA0wAZSK5m8LwlOjMNYIMF8Mb2WGik9rFmrwhdhVIBXoqb/ANihczlGIg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(18002099003)(261022105027099003)(261022075727099003)(3023799007)(11063799006)(261021123027099003)(261009223327099003)(261021135927099003)(261009223027099003)(261009220027099003)(261009221227099003)(261009221727099003)(261021121427099003)(10067099003)(56012099006)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUxSaU5wRjNLWEduRmVVWGxSR211MGt4U3pFaitxQ1VrSVRrMk9od2VKeWdF?=
 =?utf-8?B?YWkrMlRUdXhWQ01jRUlVM2xtc3lBLzRtTS90M3c4aVoxamoyT1V3TW1kNFJQ?=
 =?utf-8?B?ZUlzazg4dFU4OERIY2VIdzlaQk5TaXFBM0ZHUWdHYlNrdHhLa2p3MndvdGhk?=
 =?utf-8?B?ZlFuVDJiZmd1Y0FzbzJGR3FaWGxHRUx5V1dkaEJPYUViVHZkMHhpZ0YyaytM?=
 =?utf-8?B?ZHNWYlVRSVViOUg3YVc3eldFWlVBY0hoMEtwaS9CbFdUeHZ1Rkhsa3JJbDg5?=
 =?utf-8?B?SmluQzYzTE1ESHhJMTEwTHptNmwwbTQ5ZEprUklERmNJV1Q5b09Nb0RWRUVD?=
 =?utf-8?B?QzFhNEZzdFU1Rlh2Sks0dXQvTHFONjU1VlZNNExvMjdhWExrRzR2aDZBUXly?=
 =?utf-8?B?blk1VWo2Njhlbi9pU2ZRaFlsM3lzTjRsalVlMUdmaS9CVlVHUUU1Z3BSZGhX?=
 =?utf-8?B?V2Mrb3d3TEZtZFdmVitJNHRTNlVHa0RSY2J1MkZ0amlJWmV3eVFiNURtYnEz?=
 =?utf-8?B?TnZ3MXl4c3dNbWRJOSsvTGxhblljMUtGaFV4Zzd1b3BBNE96VGJBS3VxS2to?=
 =?utf-8?B?YXVITktKYkUyOXpNaDRDOVVqYTFWb3ZLTStSWW5BbU5Ua2RVUlRlOGM1emg4?=
 =?utf-8?B?c0Y3c0xteTZlTDJ5Y1pwc2FEVndzT3ArOEgwMGpDUUNlakdIWWxmTE5QcTll?=
 =?utf-8?B?RWhidTlFbFNkeSsrSjBLR0F0djdRNHFCWmZ0OHhFK3M0ZXQ0ZytNTHFrTnk1?=
 =?utf-8?B?dVBaTkNGUFhZYnhKcUoxQVIya3VRRkpLVzNTbGZxaEtaTkMwVDVPaDJxZ0JM?=
 =?utf-8?B?SGRFOEp6bFNDYmlFd01wd21nRGpqUzI5Z0pZdWVEN2oxc3MwcGFzVzBiYUVL?=
 =?utf-8?B?WFRMUk5VUkc1MG1WMkZCdDV0Ykw0QjRTWmlMaXRFV2hZRUsrcUtHOXh4OVhu?=
 =?utf-8?B?eDRzOUVyT0hJTFpnN0Z0RXVKWWpkbW5iT2JqL3hucXh6dlI3SmFhc3Aydm5O?=
 =?utf-8?B?WGh3TCtEajY2Wk05WFdScTJzVUd4QzZycHB6U3lhelFkT2kyMHc0ZDdvMGd6?=
 =?utf-8?B?Y2FMaXVMSlhTV0diNDJUNHJQRWhiNXhXaGllUFZvVHI2dTg5QlZsUlFIUTlt?=
 =?utf-8?B?L2ZUR1JsV0dQcE4wUkNsV3hiN1I1NGhrTGxBMitSa1hPd2pVYUVnakJ0NUJh?=
 =?utf-8?B?NFRGOGZyRmttYS8xazVUWnF3SWF3THlBeEVoM2FuTTZpc0kxcGJId1NNdld2?=
 =?utf-8?B?Wis5b09KS0tMbVRjV0F5Lytua2hRakE4V2dKNEc4c3QvMytnSUhpZWZ0V1Bx?=
 =?utf-8?B?b2wxVE4ybkJNWU1URTFhaEE5cytzbk9CWCswMVVjL0E3ZUpRd2poU3hOaktZ?=
 =?utf-8?B?TFRZd3huWmlmRjZ1ZVN5dk9BR0U3UVUrc1JPYUdiSmVUUmx4emxkaElETHp3?=
 =?utf-8?B?QWpnR1V4L1Uxdm1MVVBMUnJVUkhPNElJZzMwRWUvNVJUUGFRd25MdGh1d3Bs?=
 =?utf-8?B?ZkFXb3VrblRsYUNiS0UwUVQxWnErK1BpNGkyYU1oL0dtOEU3bGJwVkkveE1v?=
 =?utf-8?B?VVkvQ0s2TjdHM1RrLzJ3WUp4K056c0VpTy9tTEk5VXZsVXdtV0J0QmNQSm9G?=
 =?utf-8?B?SE1BK0V3TDFOamxiUzF6L0VyZmZ4L1FwOTdSRjU3RzdGcXlmSStMb0dBY3BM?=
 =?utf-8?B?dWdzOXZvZU5ndkRpRGpnR2NPQ1c5QWd6b0dHVUREQjdDbzhqOTZ4cDVwSUhM?=
 =?utf-8?B?V3VoaU9tL29rMnBwNjk3OFdiSjlHN1VvWDJXU25PZmFVeGJXTHppRjF4OHBH?=
 =?utf-8?B?VERaaGpjamVDTDJ1dXMwK3RPMVRzY2gzTitiZGpESDVxUi9zTlZWRHc5QXJ2?=
 =?utf-8?B?N2o0OHZFUytyYnpqNHNIUzFIZVZXakJzY0tMUmR5bUl5Z0NBaUw4bElISXJs?=
 =?utf-8?B?YVpUa0NXQjBjbVV3TTVGaGVnaWhmejc1N3JhTmpxNlVLNVpqTWZZNGlleUJ3?=
 =?utf-8?B?L3JxaTFiMVFIY1JFa3hBc1JsQnhFZytlSUdKNUQ4aGxhaDhTUUw4bVBpVElY?=
 =?utf-8?B?MGZFUXF1NklXdmNlMTd5ZjdxVEs4VTM1Ymd4K0E0MnFwK1hxWTdGNW5NTEdL?=
 =?utf-8?B?UjIyUnJyamJsbGV1RTJXQzdJUlB2Zmd4Ykk2QmpxclI1WHIyQU16dTNzM0Y5?=
 =?utf-8?B?YnR4WTQvRWhEWDJsQ3RjODViU1VJcDVWSlp2NFFBdjdEbUdVd2NBOFJ5R2JM?=
 =?utf-8?B?bjdOWGphSlhYWU1PV1RGSkV5ZWtJSEs0ZzVoVGxNQUFnM1VFRGFnbjREeEpa?=
 =?utf-8?Q?VMy6TTTj8iMHKth8UW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba2f9a0-4bff-4ff4-8608-08df306a5f92
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 18:29:14.2548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOxLP5vFbvOmznfxH7msxxPBCEpwdnIYYvi2HAzPlOelBiCAbxTbnlsfhOqukpGR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7072

--KJQ0BvcgHr6XY2bt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Another merge window, another big pile of AI fixes.

There are several drivers on the list now, and a serious proposal to
support a the UltraEthernet RDMA style protocol. These are winding
their way across the Sashiko threshold and maybe we will see them in
the next couple cycles.

Thanks,
Jason

The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539:

  RDMA/irdma: Bound in-flight CQP ops across deferred completions (2026-10-=
20 06:21:15 -0400)

----------------------------------------------------------------
RDMA v7.4 merge window pull request

A smaller cycle for features, still mostly AI and tool found bug fixes for
long standing issues:

- Bug fixes and minor cleanups across bnxt_re, cxgb4, EFA, ERDMA,
  HFI1, HNS, ionic, iRDMA, mlx4/mlx5, rdmavt, rtrs, RXE, SIW, SRP,
  isert and IPoIB. Lots of error unwind leaks, integer overflows, and
  use after free during teardown from timers/work that was not
  cancelled

- Core fixes for uverbs DMABUF lifetime, RMPP reassembly use after
  free, multicast rb-tree corruption, restrack, and a user triggerable
  NULL deref when creating a WQ without a CQ

- Prevent userspace from getting a writable mmap of the cxgb4 status
  page and the mlx4 clock page

- Many rxe hardening fixes for bad user and network input, plus
  netdev and tunnel socket lifetime fixes

- Peer supplied values are now validated in rtrs-clt, which is remote
  triggerable

- umem now picks the DMA direction from the access flags instead of
  always using DMA_BIDIRECTIONAL, so an IOMMU can stop the device from
  writing to read-only memory. Several drivers were fixed to pin CQ
  and queue memory as writable to go along with this

- SRQ support, firmware assigned CQ IDs and RCQ userspace support for
  ionic

- RC QP improvements in MANA: MMQ creation, fixed size send WQEs and
  power of two send queues. Also multi-port GSI QPs and a rework of
  the UD send/receive and CQ polling paths

- Relaxed ordering MRs for EFA

- Non-contiguous kernel QP and CQ buffers for ERDMA

- Move the mlx5 data direct infrastructure from mlx5_ib to mlx5_core
  so netdev can use it too. The data direct PCI driver is now named
  "mlx5_dd"

- debugfs knob in hns to fix the SL used by the GSI QP, working around
  a HW problem with dropped CQEs

- Selftest fixes, removal of the qib sysfs ABI docs, DT schema
  conversion for hns, and MANA maintainer handover

----------------------------------------------------------------
Abhijit Gangurde (5):
      RDMA/ionic: Add RCQ userspace support
      net: ionic: Fetch qid allocation and SRQ capability from firmware
      RDMA/ionic: Fix XArray initialization to use XArray flags
      RDMA/ionic: Fix double removal of CMB mmap entries in create QP error=
 path
      RDMA/ionic: support firmware-assigned CQ IDs

Abhishek Mohapatra (1):
      RDMA/bnxt_re: Use kvzalloc for QP table allocation

Amit Kumar (3):
      RDMA/ionic: segregate rq related fields from ionic_qp into a new ioni=
c_rq struct
      RDMA/ionic: add Shared receive queue (SRQ) support
      RDMA/ionic: implement SRQ event handling support

Ammar Ratnani (1):
      RDMA/core: Force disconnect if DREP and DREQ fail

Binbin Deng (1):
      RDMA/rxe: unpublish the per-net tunnel socket before

Bjoern Doebel (1):
      selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe is missing

Carolina Jubran (1):
      IB/IPoIB: Cancel normal flush work on device stop

Cheng Xu (5):
      RDMA/erdma: Unwind kernel QP initialization failures
      RDMA/erdma: Support non-contiguous kernel QP buffers
      RDMA/erdma: Support non-contiguous kernel CQ buffers
      RDMA/erdma: Unify userspace and kernel queue buffer management
      RDMA/erdma: Move kernel QP helpers after memory helpers

Chengchang Tang (2):
      RDMA/hns: Fix missing CQE when UD QP use different SL
      RDMA/hns: Support setting GSI QP SL via debugfs

Dairui Zhang (1):
      IB/mad: fix UAF and double-free in RMPP receive reassembly

Dana Malachi (2):
      RDMA/efa: Use device ABI MR permissions instead of verbs flags
      RDMA/efa: Pass relaxed ordering flag to device

Deep Shah (2):
      RDMA/uverbs: Fix uobject leak in DMABUF release
      RDMA/uverbs: Fix DMABUF use-after-free during ufile cleanup

Dragos Tatulea (10):
      RDMA/mlx5: Notify data direct users via a notifier chain on unbind
      RDMA/mlx5: Add mlx5_data_direct_supported() helper
      RDMA/mlx5: Make the data direct VUID query self-contained
      RDMA/mlx5: Give the data direct PCI driver a proper name
      RDMA/mlx5: Move and rename data direct resource functions
      RDMA/mlx5: Add new registration stage for data direct users
      RDMA/mlx5: Extract IB specific lock out of data direct
      RDMA/mlx5: Consolidate data direct state into one object
      RDMA/mlx5: Pull data_direct resource creation in init phase
      mlx5: Move data direct implementation to mlx5_core

Geliang Tang (1):
      RDMA/siw: drop duplicate check_app_limited in siw_tcp_sendpages

Guangshuo Li (1):
      RDMA/irdma: avoid use-after-free in icrdma_remove

Haitam Lazaar (1):
      RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses

Hemanth Selam (2):
      RDMA: fix typos in comments
      RDMA: fix repeated words in comments

Honggang LI (1):
      RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA mes=
sage in 2GiB size

Hongyan Xu (2):
      RDMA/hfi1: shut down the trap timer before unregistering
      RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit

Jacob Moroni (5):
      RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
      RDMA/core: Clear driver_udata before destroying objects in rdma_core
      RDMA/irdma: Check MR contiguity before PBLE alloc
      RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
      RDMA/irdma: Fix PBLE_LEVEL_2 FRWR generation

Jeremy Bongio (1):
      RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation

Jiale Yao (3):
      RDMA/mad: Reject receive completions shorter than GRH
      RDMA/mlx4: Do not allow the user to write to the clock page
      RDMA/cxgb4: Do not allow userspace to write the status page

Junxian Huang (4):
      RDMA/hns: Use u32 for gid_table_len
      RDMA/hns: Limit gmv_entry_num to avoid memory waste
      RDMA/hns: Fix GID capacity loss in 64K system
      RDMA/hns: Fix the use of uninitialized variable

Karl Mehltretter (1):
      ABI: sysfs-class-infiniband: Drop the entries of the removed qib driv=
er

Konstantin Taranov (8):
      RDMA/mana_ib: Extend RC QP udata request and response
      RDMA/mana_ib: MMQ creation for RC QPs
      RDMA/mana_ib: fixed send wqe size support for RC QPs
      RDMA/mana_ib: Optimize shadow queue bookkeeping
      RDMA/mana_ib: Revise UD send posting and WQE definitions
      RDMA/mana_ib: Revise UD receive posting with GDMA_WR_IB_SGL
      RDMA/mana_ib: Make kernel CQ arming robust
      RDMA/mana_ib: Poll UD completions and flush software error QPs

Leon Romanovsky (7):
      RDMA/irdma: Preserve fast-registration IOVA on 32-bit
      RDMA/irdma: Remove unused post_sq arguments
      Merge remote-tracking branch 'ionic/ionic-shared' into wip/leon-for-n=
ext
      mlx5: Move data direct infrastructure to mlx5_core
      RDMA/core: Preserve the selected source GID on failed AH modification
      RDMA/core: Free unpublished port statistics after initial-read failure
      RDMA/core: Reject LAG selection when source MAC lookup fails

Li RongQing (13):
      RDMA/nldev: Put the device when dellink fails
      RDMA/uverbs: Make CQ handle mandatory for WQ creation
      RDMA/mlx5: Print err code when create_qp fails
      RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device=
()
      RDMA/restrack: Don't set RESTRACK_DD mark after a failed xa_insert()
      RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_C=
ONTEXT
      RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
      RDMA/multicast: Fix rb-tree corruption on MGID reassignment in join_h=
andler
      RDMA/mlx5: Guard steering anchor resource destruction on create error
      RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow attributes
      RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
      IB/isert: Don't share drop_cmd_list across concurrent connection tear=
downs
      RDMA/mlx5: Fix CQ resize destination index mask

Liu Zhenlong (1):
      RDMA/rtrs-clt: use find_next_zero_bit() for permit allocation

Long Li (1):
      MAINTAINERS: hand over MANA RDMA driver to Wei Hu

Michael Margolin (1):
      RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring allocations

Nguy=E1=BB=85n V=C4=83n Cao Nguy=C3=AAn (1):
      RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET

Nicolas Morey (1):
      RDMA/rxe: Use validated num_sge in local buffer

Norbert Szetei (2):
      RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after MR creation
      RDMA/rxe: Reject prefetch of a non-ODP MR

Prathamesh Deshpande (2):
      RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
      RDMA/mlx5: Cancel software CQ notifications before teardown

Praveen Kumar Kannoju (1):
      IB/mlx4: Avoid requeueing executing CM timeout work

Quanye Yang (4):
      RDMA/rtrs-clt: Reject invalid queue_depth from the peer
      RDMA/rtrs-clt: Don't WARN on unexpected info-response opcode
      RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
      RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq

Rob Herring (Arm) (1):
      dt-bindings: infiniband: Convert hisilicon,hns-roce-v1 to DT schema

Ruizhe Zhou (2):
      RDMA/hfi1: Remove obsolete 32-bit DMA mask fallback
      RDMA/mlx5: Remove obsolete 32-bit DMA mask fallback

Runyu Xiao (1):
      IB/hfi1: Shutdown self-rearming timers before freeing

Sang-Heon Jeon (1):
      RDMA/mana_ib: Remove redundant NULL check before netdev_put()

Sasha Levin (1):
      RDMA/selftests: Fix the kernel config fragment

Selvin Xavier (8):
      RDMA/bnxt_re: Fix integer overflow in send payload size computation
      RDMA/bnxt_re: Detect wrong sge_len passed for inline
      RDMA/bnxt_re: Validate SRQ max_sge at create time
      RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
      RDMA/bnxt_re: Serialize dcb_wq access against async notifier
      RDMA/bnxt_re: Fix the PD and DPI table size
      RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
      RDMA/bnxt_re: Unpublish QP table before freeing it

Serhat Kumral (7):
      RDMA/srpt: Fix srp_sq_size documentation
      RDMA/irdma: Free IRQ when CEQ vector mapping fails
      RDMA/siw: Fix length of first chunk in siw_try_1seg()
      IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
      RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() fail=
ure
      RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
      RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler

Slavin Liu (1):
      RDMA/irdma: check vport device allocation

Snehal Sanghvi (2):
      RDMA/mana_ib: Enable multi-port GSI QP support for mana_ib
      RDMA/mana_ib: advertise pow2 RC SQ support to user space

Sunny Tiwari (1):
      RDMA/irdma: Bound in-flight CQP ops across deferred completions

Wentao Liang (4):
      RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
      RDMA/cxgb4: Fix skb reference leak in rx_pkt()
      RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
      RDMA/siw: Fix qp use-after-free in siw_get_base_qp()

Yili Zhang (1):
      RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FA=
ILURE

Yishai Hadas (18):
      RDMA/mlx5: Use unsigned comparison in the CQ cleanup loop
      RDMA/mlx4: Use unsigned comparison in the CQ cleanup loop
      RDMA/mthca: Use unsigned comparison in the CQ cleanup loop
      RDMA/hns: Use unsigned comparison in the CQ cleanup loop
      RDMA/erdma: Pin CQ buffer writable to match device DMA write access
      RDMA/hns: Pin CQ buffer writable to match device DMA write access
      RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA wr=
ite access
      RDMA/umem: Reuse ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
      RDMA/umem: Support an explicit DMA direction other than DMA_BIDIRECTI=
ONAL
      RDMA/umem: Map CQ buffers DMA_FROM_DEVICE
      RDMA/umem: Derive DMA direction from IB access flags
      RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
      RDMA/mlx5: Set WQ event handler before firmware RQ insertion
      RDMA/mlx5: Set SRQ event handler before xarray insertion
      RDMA/mlx5: Set RQ event handler for raw-packet QP
      RDMA/mlx5: Set QP event handler before firmware QPC insertion
      RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
      RDMA/mlx5: Fix signed integer overflow in EQE qp_srq type shift

Yonatan Nachum (1):
      RDMA/efa: Fix race between admin command timeout and completion

Youngsung Ahn (5):
      RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound
      RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
      RDMA/rxe: bound the ODP page index against the umem in rxe_check_page=
fault()
      RDMA/rxe: validate inline sge_offset in finish_packet() before indexi=
ng inline_data[]
      RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]

Zhiwei Zhang (1):
      RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()

xiongweimin (1):
      RDMA/rxe: Hold netdev reference for transmit skbs

 Documentation/ABI/stable/sysfs-class-infiniband    | 118 ---
 .../bindings/infiniband/hisilicon,hns-roce-v1.yaml | 173 +++++
 .../bindings/infiniband/hisilicon-hns-roce.txt     | 108 ---
 MAINTAINERS                                        |   4 +-
 drivers/infiniband/core/cma.c                      |  34 +-
 drivers/infiniband/core/cma_trace.h                |   1 +
 drivers/infiniband/core/device.c                   |   4 +-
 drivers/infiniband/core/ib_core_uverbs.c           |  22 +-
 drivers/infiniband/core/iwcm.c                     |   2 +-
 drivers/infiniband/core/lag.c                      |  14 +-
 drivers/infiniband/core/mad.c                      |   2 +
 drivers/infiniband/core/mad_rmpp.c                 |   7 +-
 drivers/infiniband/core/multicast.c                |   7 +-
 drivers/infiniband/core/nldev.c                    |   9 +-
 drivers/infiniband/core/rdma_core.c                |   2 +
 drivers/infiniband/core/rdma_core.h                |  17 +-
 drivers/infiniband/core/restrack.c                 |   3 +-
 drivers/infiniband/core/sysfs.c                    |   9 +-
 drivers/infiniband/core/umem.c                     |  77 +-
 drivers/infiniband/core/uverbs.h                   |  37 +
 drivers/infiniband/core/uverbs_std_types_device.c  |   1 +
 drivers/infiniband/core/uverbs_std_types_dmabuf.c  |  46 +-
 drivers/infiniband/core/uverbs_std_types_wq.c      |   2 +-
 drivers/infiniband/core/uverbs_uapi.c              |   2 +-
 drivers/infiniband/core/verbs.c                    |   8 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   4 +
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  69 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  24 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  23 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   5 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |   2 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   5 +
 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h    |   5 +-
 drivers/infiniband/hw/efa/efa_com.c                |  28 +-
 drivers/infiniband/hw/efa/efa_com_cmd.c            |   9 +-
 drivers/infiniband/hw/efa/efa_com_cmd.h            |   8 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   7 +-
 drivers/infiniband/hw/erdma/erdma_cq.c             |  18 +-
 drivers/infiniband/hw/erdma/erdma_main.c           |   2 +-
 drivers/infiniband/hw/erdma/erdma_qp.c             |  38 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          | 577 ++++++++-------
 drivers/infiniband/hw/erdma/erdma_verbs.h          |  66 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   2 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   4 +-
 drivers/infiniband/hw/hfi1/firmware.c              |   2 +-
 drivers/infiniband/hw/hfi1/pcie.c                  |  14 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   3 +
 drivers/infiniband/hw/hfi1/verbs.c                 |   4 +
 drivers/infiniband/hw/hns/hns_roce_bond.c          |   4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   3 +-
 drivers/infiniband/hw/hns/hns_roce_debugfs.c       |  55 ++
 drivers/infiniband/hw/hns/hns_roce_debugfs.h       |   1 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |   6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  63 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  22 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   4 +-
 drivers/infiniband/hw/ionic/ionic_admin.c          | 117 ++-
 drivers/infiniband/hw/ionic/ionic_controlpath.c    | 822 +++++++++++++++--=
----
 drivers/infiniband/hw/ionic/ionic_datapath.c       |  98 +--
 drivers/infiniband/hw/ionic/ionic_fw.h             |  76 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c          |  24 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.h          |  85 ++-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c        |   3 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h        |   3 +
 drivers/infiniband/hw/irdma/ctrl.c                 |  31 +-
 drivers/infiniband/hw/irdma/hw.c                   |  16 +-
 drivers/infiniband/hw/irdma/icrdma_if.c            |   9 +-
 drivers/infiniband/hw/irdma/main.c                 |   2 +
 drivers/infiniband/hw/irdma/pble.c                 |   8 +-
 drivers/infiniband/hw/irdma/protos.h               |   3 +-
 drivers/infiniband/hw/irdma/type.h                 |   7 +-
 drivers/infiniband/hw/irdma/verbs.c                | 134 ++--
 drivers/infiniband/hw/mana/cq.c                    | 372 +++++++---
 drivers/infiniband/hw/mana/device.c                |   3 +-
 drivers/infiniband/hw/mana/main.c                  |  43 +-
 drivers/infiniband/hw/mana/mana_ib.h               | 134 +++-
 drivers/infiniband/hw/mana/qp.c                    | 150 +++-
 drivers/infiniband/hw/mana/shadow_queue.h          |  61 +-
 drivers/infiniband/hw/mana/wq.c                    |   3 +-
 drivers/infiniband/hw/mana/wr.c                    | 158 ++--
 drivers/infiniband/hw/mlx4/cm.c                    |  10 +
 drivers/infiniband/hw/mlx4/cq.c                    |  17 +-
 drivers/infiniband/hw/mlx4/main.c                  |   4 +
 drivers/infiniband/hw/mlx4/mcg.c                   |   4 +-
 drivers/infiniband/hw/mlx5/Makefile                |   1 -
 drivers/infiniband/hw/mlx5/cmd.c                   |  21 -
 drivers/infiniband/hw/mlx5/cmd.h                   |   2 -
 drivers/infiniband/hw/mlx5/cq.c                    |  14 +-
 drivers/infiniband/hw/mlx5/data_direct.c           | 227 ------
 drivers/infiniband/hw/mlx5/data_direct.h           |  23 -
 drivers/infiniband/hw/mlx5/fs.c                    |  52 +-
 drivers/infiniband/hw/mlx5/main.c                  | 200 ++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  18 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   7 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  32 +-
 drivers/infiniband/hw/mlx5/qpc.c                   |  20 +-
 drivers/infiniband/hw/mlx5/srq.c                   |   3 +-
 drivers/infiniband/hw/mlx5/std_types.c             |   3 +-
 drivers/infiniband/hw/mlx5/umr.c                   |  11 +-
 drivers/infiniband/hw/mlx5/wr.c                    |   1 +
 drivers/infiniband/hw/mthca/mthca_cq.c             |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   6 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  25 +-
 drivers/infiniband/hw/usnic/usnic_abi.h            |   2 +-
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   2 +-
 drivers/infiniband/hw/usnic/usnic_transport.h      |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c      |   3 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   4 +-
 drivers/infiniband/sw/rdmavt/srq.c                 |   2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   8 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  18 +-
 drivers/infiniband/sw/rxe/rxe_mw.c                 |   3 +
 drivers/infiniband/sw/rxe/rxe_net.c                |  73 +-
 drivers/infiniband/sw/rxe/rxe_odp.c                |   9 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  10 +
 drivers/infiniband/sw/rxe/rxe_recv.c               |   9 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  11 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  23 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   6 +
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   1 +
 drivers/infiniband/sw/siw/siw_main.c               |   5 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  21 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   7 +
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   6 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             | 100 +--
 drivers/infiniband/ulp/srp/ib_srp.c                |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/data_direct.c  | 400 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  15 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   5 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  49 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  31 +-
 include/linux/mlx5/data_direct.h                   |  47 ++
 include/linux/mlx5/driver.h                        |   8 +
 include/net/mana/gdma.h                            |  12 +-
 include/rdma/ib_umem.h                             |   2 +
 include/rdma/ib_verbs.h                            |   4 +-
 include/rdma/uverbs_ioctl.h                        |   2 +-
 include/uapi/rdma/ionic-abi.h                      |  11 +-
 include/uapi/rdma/mana-abi.h                       |  12 +
 tools/testing/selftests/rdma/config                |  12 +-
 .../testing/selftests/rdma/rxe_sent_rcvd_bytes.sh  |   6 +
 154 files changed, 3805 insertions(+), 2030 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/infiniband/hisilicon,=
hns-roce-v1.yaml
 delete mode 100644 Documentation/devicetree/bindings/infiniband/hisilicon-=
hns-roce.txt
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.c
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
 create mode 100644 include/linux/mlx5/data_direct.h

--=20
Jason

--KJQ0BvcgHr6XY2bt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCatpV9wAKCRCFwuHvBreF
YffYAQCZekIR23KlFQrXQ92H1YpXhvxje9XnxsV353/U2hu1ewEAyebW/NRzid5r
IE2mI/Fv2iaGj1VGxIu/cEubABLftws=
=cP3L
-----END PGP SIGNATURE-----

--KJQ0BvcgHr6XY2bt--
