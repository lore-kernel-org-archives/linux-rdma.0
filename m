Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697256;
	b=DnBzAwB4N4pHa29tVuuoxrnxXsyZJSc7Xn0MjHaltGvpRN1tYtcVLyRw0jVkPbCePKuk
	 WtTwlVNrbjB42THA3W/cdW7U2Tz8C9WYXt1XtdhANdKkHIWk6VwxK64kLij3jkn4qpXal
	 IAUXxJWnZowQsKOUIZb0V+X0DlKCUbPDMsAqDHv9INQ1ZzNRfqNEiFb6odkps4arV6m8+
	 JOPX9kb/RWIJVyTyvIpB39+r7OU8mKe1dhnw8mFxocmUwkegwNSuBACzLw41orGVyqYYF
	 oGNEm2avTkN6AKVev/ZjOgVg4QYUwR4fBTKCsI6eCztAe6aZ+MAioSMec/PyyJNCaXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697256;
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
	bh=Up5uQ3ILeExQnU2UyI8DUcBUfkx4KaoUUAZ+tqiYalo=;
	b=3Iq17B1Tp3rcOgSvD82ZexIuPK/0AxjRvg+3+1Nx0nlioYTPQ28b95EyIvmmK9SOZNh7
	 GKKtnd66OPelGnS5IZbiVDqaoahQ8o9PD4qmb4TE7BS9hsR9EvuyCc0A+21ali3yB23Cs
	 DQnYGDitDE/xsXFMbm9IKqPtpXG5+rjzBdt+VIK2dRKFQYXSDKcwlcMYiHg5Lz6KsaWws
	 VOC7p49VywBmqup9aYar1kFwlGZ7++Wtqe4oKivw50sdaLDf22+7lkz4PSf0WrdFpW5J4
	 bdYQDVJbTVLklErbukQSPvhGQVLyDOBgApdLB0KkicXiU4KuWNoOUHXEluXtRST8IMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tH5qFCIS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.49
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013049.outbound.protection.outlook.com [40.93.196.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F437606A319;
	Thu, 22 Oct 2026 19:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F437606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tH5qFCIS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ObBn8464wEOy4tdIpnbG90hXPRyL1QA+01iqR3HaBfSBVY+zy+dpnfJYNI5MRdmfRdNweTdPX/CFa8qfAQEB3DDW+trOOkc1vhFbyaBq/UDlM/uDOj5IymnoJIyvGBO7npW4fBtJV3Fhrn/W9mvkkmYwS4ucCn7CEbbus2mHUTvcnmjoQSinhVT2uwJwkhU2lTHoDAONXcD1bzRm/ej13HXJqJhqC8HbY8Qb25OEodwMKieTnQTZj1I80ZO8HRDlfE+5lHn6wN3GwF5vg1BSMq8gszdNeX45Vpi5ls2jF2J0XFifHysJvEkRb13ZDsULe7Enw0M3sh/MECAWS/F2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up5uQ3ILeExQnU2UyI8DUcBUfkx4KaoUUAZ+tqiYalo=;
 b=MOZkZxuMJz02ottmZqMaYLkr4FpNQWH1gAHVE700t+PzFLwrNcQLUTfTJZbg+PS/g1pPnWi1MvEz5l/fb7sdTRTq1bYPpDSEr984vKUVPK48RWo/GpmjGFarmWwFaEw0j8tsuCjMENfA3d/KRAVt4Qt47gOezc8iZ7RiXwANHEGhfv/+SEoiEacPs2TAejG+1n5Pk58UGYvqgl0W/hf+5c0rv+8XxVYB2yD8R3vrnc+PJJ6ZHG8g2YoFWBHIZY89joD6Z0P38at+3OG408V9FhCSi0vqMlX20LWGkwxxMVZ6XA35psR20y5Sa8IUKNK1P4LWHiv5qqwOvkLE5JYxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up5uQ3ILeExQnU2UyI8DUcBUfkx4KaoUUAZ+tqiYalo=;
 b=tH5qFCIS1ZPqYsX5y4udXE7z013nMi4RSuLwfJxqWOd6RLKpn1EFNtdCaaLXkCTlbQblQoy8CiSGLZuXdU5wUIO0kPF53tO+C7IRLlmNSnujGL4w/yRoj3WeS8EO7i/Y/5QbvZLbQE7sA4n5fcaprjz081KZ7ok6HcB/RSnnk7kzOiilpeN3md+1SzZc8tZfuaL1OTQn7ZZ0vXvasDZWE9Sl6/IKhhoVP+hRlxc878f1zb6cMi65xbGLWPxiWr0PgR3MZbMEIG6Rr2159FbArnsKhtoLXKW2TVpTcv6zRofiX1+QDjLH0+TmMk4kFToJzLv14MVbcxsBhuSIPKyybw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB8509.namprd12.prod.outlook.com
 (2603:10b6:610:157::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Thu, 22 Oct
 2026 19:27:28 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 19:27:27 +0000
Date: Thu, 22 Oct 2026 16:27:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [GIT PULL] Please pull FWCTL subsystem changes
Message-ID: <20261022192726.GA3758618@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6A/oRGRXX8K9i5yy"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:208:2be::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB8509:EE_
X-MS-Office365-Filtering-Correlation-Id: e45b01bd-4772-43e9-9f65-08df307281de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|3023799007|11063799006|261021123027099003|261009223027099003|261021121427099003|10067099003|261022105027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4uScPcEGMdL6fHh+2Hso2foO0wB2T5LbLwtFGwKqn3lvJv+z73NNX3MUdA+HtpJid4T7yqJ5Ej5Z7F80GIg4Jp+5Y3HTCquDfHcEa4FPcMLNZ3d91tUGeM69RioY3qzpXDnXC0o+V4D7P8d/PkIae54nWvyjgUD5tWI7Rdit2rOepxnK22x5iMMcAHfzQfcJFY9+zWWqwmbcNny5XP/j7JvnoxV5IhB9AAzk9mVJPf3r/s/oZt5hg5fk94yHRvkkaPGrPBB658BjcbSFXUQWXI6r7sThJEFQkd8ZWV5rnIJlQcSldGJaxFWvU+a8/Vw5QIhKL+6uCTfuECHVvMGZMTh4K4FNzPiAELmh7ILg5x7lgUeUjnh4lgh4Re3sQnxagzzZpaPHWTXpg6xXgkbdDhACLzgm1G96i0d0SiP39IAdD7s0jqTl3jxb08OwcO83lH3ykTQc4oRSQ4VQtTvr27uKd9XSaEONJD4Br0ToWHGW/4UgNeIIajrHb6GQ6zE48p/UAfx5Oh1LNQWoC/QSAzRXxY98IKKe+YaUWf7cKb0AiarQERs12Tp5zd3n1PgTD5dpHHfS+cH5cGX9I5DHpyQMD/R6UbwzeCc45oAgYds1WsJm27q9xqC+bJgQ7+VzDTRQQaXmi8o4K2D4GHiZuNh797qX8xIfBaOQoeG7qSE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(3023799007)(11063799006)(261021123027099003)(261009223027099003)(261021121427099003)(10067099003)(261022105027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eXhrqJQXhpjDLa0JmMTiu+0pY7r9xwhnJqLMY8zv+aCYlWm3ZblCIjEwVV6o?=
 =?us-ascii?Q?UQb8HIdAqylmOSCrD+mO88lV2gYf6oHbz8ebUD49ubLTYhzZcl0Ve7MUUSD8?=
 =?us-ascii?Q?GU/CpJRYJ1WgnlaTP8QxL2qSww3BYnwJT1Fd2ZJaj2YScYv8ZrrkGC8rsYKl?=
 =?us-ascii?Q?jv+mkYwBzsAhqh6feXUWH9CuMte0eyjHdF2fTv4REHq4mll4+yL7BLzUd2dg?=
 =?us-ascii?Q?eF0wTPtLExftbCYBivn5APupoDyvxyeUC2Z8EB+NBKM+QQZsMHRD5YAYW3pS?=
 =?us-ascii?Q?OENcyXuJ5UuGTO+huRxv8NaGTB8tLq/xlAb+UlnfJ38Q490K+MevGArsChgt?=
 =?us-ascii?Q?Xrmil7Zmy1ns2X4Zy7ebyJfMHACr+IH3hugRsVA2QVUtjSxRXxOxqdOqedYJ?=
 =?us-ascii?Q?s18519l3Y36Hs5euFNaQeOOpfHHLoDEfbf2hIU1J9o0vUHHsjxfnuWKIfT1N?=
 =?us-ascii?Q?o0RZfSELmHTHXX5UoVdA3r4Dpx1kyTONAUoGSyOs5V0ODZ0khxNfTqIXDTNP?=
 =?us-ascii?Q?EHSVM7OJIqUiXRSeGYnBlZC4wFXjVsfO8W9LkUrUg4fD6N9oBUHcTgHWmW3v?=
 =?us-ascii?Q?Vykc+iZqv2Za+lzYt4XgbKL49ScJ9Yf4jzHXMN0kjAD+ak8M6LZWqMACKzgj?=
 =?us-ascii?Q?vFXS25bGuxXY5W60XM34QaCFEID+uYmPiMRM693v1O31/3aI5PAiupK4FWW1?=
 =?us-ascii?Q?Jebwq/OdRKZ7qmpstsCYJytLxfAxkZkBiobDtiJkOJP0uHjMuw1yitBqIs6M?=
 =?us-ascii?Q?kWhD/TTy3uuvQeH09nwyPUFmBPno9sNnpN5DLwn8cxIIS+4nuKfn3pnAcpfG?=
 =?us-ascii?Q?STH82+TadFPQdW331AhfrJT2AZd8Bs0MElYCU6WXjC07iaV/FTTAcAFRlxM1?=
 =?us-ascii?Q?z9YBBOLgDFa7WcD+QgemJNHzBbcC/lJiNBQCRPRTb3ZjtRbLp5Lq6Qpb33Rx?=
 =?us-ascii?Q?qm8br5Q1zJNS530/lwdbWV70F6kqR78d9h6TafOdFtuCf0l9q7dgwuB39IGs?=
 =?us-ascii?Q?pWpvjbzPfmZUNEpqv6HYfkdgkHNOtok5/xy9dRHAYqS/lf9cy1jBzNrdV8IW?=
 =?us-ascii?Q?Y05rus/C+DypmdhkUQ8ygZhW9lB65qiPQF90FVt8XvW/yE4MN85pWiMh4vsO?=
 =?us-ascii?Q?Z1hgBN/80GWcbYDM28wAdz6QI8MDn6F2TtCvmjLI7JWg19eBmrwJTAjaM/Lt?=
 =?us-ascii?Q?NIFnv/HcdC54GlQm8aNuDfPp5ZHxNFHZES6shLnev7JjpUsM59Cq3tBtGKSe?=
 =?us-ascii?Q?6zjn9wR4Wgv7XM9pq+p/Hg/YhoAoIWkOVrmYzqFAb7VPvul9ej6LYjzXlBH/?=
 =?us-ascii?Q?77qwZwxiNU4bl2zEiRMpQpxhtr0qA6iQ60eU8DuHiaynfYdsjxqBm/Rb1YyS?=
 =?us-ascii?Q?WZLwurIDfDPKXq4Vq7Hs2c6sKrd6Y37twPiVnI1irqNQS300a+I3ICrw552Y?=
 =?us-ascii?Q?vD5/vA/AF8joLVklUA0Mfh02FSj1LlTrtEazTMOQ9VSUssFv7HQsCmXPdvYa?=
 =?us-ascii?Q?Kh2QqIPz58a9H8lSgb9vrsROp850KIuVpZ/2WbbRaEHDoW5wH4ilAZHL1IRg?=
 =?us-ascii?Q?2zSV43Og6DDQ6VBQ0/V8atxVoVOQrSOwpSszbqSIntM4JPvqaxLvUreZyo2E?=
 =?us-ascii?Q?NerAYRo9KryADB2xK6pyUt5Ly0MIFlnndRnoAt2GDKOiDrbi5TNa4RcCXggx?=
 =?us-ascii?Q?Ldnr88BmmATojM8tBJ8fsM29693Ag+V7hhCVo9wkrHRaMUN1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45b01bd-4772-43e9-9f65-08df307281de
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:27:27.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LGk248HtMIyU+IN2fxQ++16r0V1K5J2VLGiSsCOy5zEtBg7S8LoobRu8vaWUkRy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8509

--6A/oRGRXX8K9i5yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Single patch for a Rust CFI issue.

Thanks,
Jason

The following changes since commit c03c1a14507dfaf8b856c2608f9ac216021fc222:

  Linux 7.3 (2026-10-18 13:14:58 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git tags/for-li=
nus-fwctl

for you to fetch changes up to bc6f2a284c63313e789d8cd294531e1cc2dc8c99:

  rust: fwctl: declare cfi_encoding for fwctl_rpc_scope (2026-10-21 13:59:4=
7 -0300)

----------------------------------------------------------------
fwctl 7.4 pull request

- One bug fix for a CFI issue in the Rust bindings

----------------------------------------------------------------
Alice Ryhl (1):
      rust: fwctl: declare cfi_encoding for fwctl_rpc_scope

 rust/bindgen_parameters |  2 ++
 rust/kernel/fwctl.rs    | 12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

--=20
Jason

--6A/oRGRXX8K9i5yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCatpjnQAKCRCFwuHvBreF
Yd1BAP9lrVD8LGI55ILFK7l85G1PRhX4TgpRxTIBFlHONBu4DwEAq3/Ee5u4qIPK
nSWt24NDNzzYm0zCybrkNCedq7OtWAo=
=Z6sX
-----END PGP SIGNATURE-----

--6A/oRGRXX8K9i5yy--
