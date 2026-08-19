Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF7E2D7BF;
	Wed, 19 Aug 2026 00:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098279; cv=fail; b=dABHda2ZJc1W0KR8ezYj3grvlI9eI4ohDGQuChrfwqgiYCXZ3vVY4LT2gsWlEFAGMG5H6aNS4F79Jyhhck//6UZRWhnGOFyfhjD/fil4Tt+oL9aOq4FXrE/CqXAzCkqMuFnTCqmiwAACHDZqnELeo3IPPh1oGv78lJxc05usc30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098279; c=relaxed/simple;
	bh=Trc0M/GOxpBdT+MpW/WqWsGSBrCl7HcKzHS+BE81LSI=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Br5wOI/9RRHeQimFz4PJyCbDwz91HqMX+zloKLLPQspSI+4M3Z67QekHumIJ1fWLn4BIk2UQo/tKa+y9RG4+1DteTc7yxbvRTYAZ7Dpjio8NgOMrzcb5NgkjWNQYNE2S78Q20FzaxjX4lRRs4eioGpXuClGNptF0jw4h1ZPYTOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oe3Ou0Mj; arc=fail smtp.client-ip=40.107.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oe3Ou0Mj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RTh/Bqh14PXa5pIK2hX6a0KGvOMHYQkK3W5+VubKWX6CbDTmJw0dabl/Ad01tzb8Ncjux6ps87Gy0VUTWd622ZVrX4vdcETvB7i3f7SuF/538p0BrBqAw504jTBHqmkrmr6hj9QhQ19vb9zv8+WRR2wYUjLNsMetESrJMUooEEHzQONc30n0PDOEmOsIRgI/guU1/Mdpx+Q/Hexth2b3AgeLbbP1WbZD8jQHPJCSCFJWtD4zAVaeTboTAmHrNyW59fcC8+tGxm6M0BKlq+V2P1VZv+6lSoqfyzM5eyc4UDo/DyDO1locmf6rItDRzmpHc2yi/xRMX8QAMWqOVBB2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ga5i5wbu/L9F9+OvBjfSUAmnfzKL6XBBwhwegIHfRhM=;
 b=imlOFYLSS3SA804uicHfZt2eFlyJCcNiHvzSxAnLJkQFq27Sa80y+BivfbLrZl7wh5PVRMKFZWJMolR3XzOWEJroD9C90M93MwgTgrn7tNG5JS/sc+M0OBSisFwm97LRQPLvAbZgSRq/ZmayLmTyYAyyVjjuuI3EwYin/bC1qch0nbk2Fm0Y4fH8kby6esy9K8jy9yW9qd/NCLm4JdCuaqpJdfBMPYDHgzz0PHszfdD45WOtkjnHylIFbtgyv9nSqPJtPYPw1LvPy6z3cl9wAQl9H4an0cDQJIp5cvZK2kbaSTSEMKGvgVcBtQLHtMblW2wAGWLr9houeJuywkcdmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ga5i5wbu/L9F9+OvBjfSUAmnfzKL6XBBwhwegIHfRhM=;
 b=oe3Ou0MjMhsEwIcuNghWE5fI4U0NhBLzudTfn0LRNapUAvtpGyfZ99nm3J+fNvc5QRMDFy6EQBjbbOw19c86/RdYJlW8hmy9LWdkqHP8YxEiyVhY0u3LtiEzE2Twl5t4ggMmzMl+9YKMjzBepV277fNcbmauI4cho27vUiO5FvOfELe31aoK8wVJVrv5FBXq0iPlf3AQSvp5L+9c1ASWZUCtgcQE2u46MZsLT3hydEshtxtZKJFEdwO8sAJQW8FT4kZGDI6sLj8ViKwXnYLY1vN5e1yj28eZ1Uy3Fo7Q0wXPcYXqWEXYeQ5vafjLwE76RnrwohXq8JqAUxfSTH3//w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7872.namprd12.prod.outlook.com (2603:10b6:510:27c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 00:11:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 00:11:14 +0000
Date: Tue, 18 Aug 2026 21:11:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [GIT PULL] Please pull FWCTL subsystem changes
Message-ID: <20260819001112.GA200468@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NQF9s+ySguzlUyBc"
Content-Disposition: inline
X-ClientProxiedBy: YT4PR01CA0285.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: 4482d1bd-6e2f-4bed-5c76-08defd86617c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|3023799007|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	zRTORxuxIwyPLQZD0mXwKHG2Hfmibl7PTzFdsYRuL5NBDYJNdqhUJTPHw3FuTmgAK40LX6XriWcihKSvkHJVip9JMob/2nphjo7neWqHR9KaanEszH/RRXV4xr6MZgg/6cIdxhpivLt1TYBL9X6ynV0BcsdSRTBAzmaXv1BMS3i2Qaw366G9nP7qMDl3Jqt6ztA8CXUVI+xdXvbjg6tinCVAjjFrfBO0b2a9ihMqEhXrayFGGVcqbituN5EBC1NP6uQbc+DroaTJEVC5sQpEg7iJdB6fWNKVzMrHNC5YekQPzAOp2H+gWwXIG4mNN578kD1KZYHS141uiVpoOaHDHvBtg54p5sojlBw32puBIhrsoWDljBd1VUDrChyZiplgmNia59XrTNzK8FyOl+tLRcEyTzzTV/8F8B3B9p4eAR66qVfyqFVdWZSLQRHCYZIGwQNr6iVbCEIjj1O7bUDUZOZjCCAUC7xLoFOfUsWF4ZHYFZVjCQgtUXVdFqjQqKtvtUXpPF62uXlYCPJAniFZQPLGfzmeSIe3VNJW1fBUM0WKxqcx3egVo93MUeIjmVmgdV2sbcNaeJJzfuf4gsc8NZL0ORxyal8nb5upgto6gkAcP3wta6Jkw5sgBhAJE+bLtmoketuAOHMXUx9GpeY32k0Y0PWf7LBBSdLgUz42IE0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(3023799007)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g0deydXw4wO9sJAJD36kWzuFcYmjemSsqDL3YGQ7ZLAhMXkRtCB93M5+Zmr1?=
 =?us-ascii?Q?JMQ27iS36Lf0nfySCORTzabRb/wnKK0w0BfU8PMQpU6VHHJ2cCcrJgwIOq91?=
 =?us-ascii?Q?nslhdLbaaKhuhfm1J7OoetjY0RcCJ1cSC7BbhrMRmf+pTb4PhZ9Oiyt8/mo/?=
 =?us-ascii?Q?xQV7Z2ybzhAFNigPHRo4N8Gdka27gUqtwdPp8tittUp4hczNlFc8S4/auq8p?=
 =?us-ascii?Q?/ZzBtEHXmOv9s43Lfnu2NoBF9ZJymPtUrea/pFqt/CGli3CdiSWqBclNxxwp?=
 =?us-ascii?Q?iFds6PO0csBFsU9JsG/qeFC9yRXzpOSNOIEDk6BSeIgOsg43qRciwrz9ue6e?=
 =?us-ascii?Q?iFPyZl6CB8/aVCt4CePBsZOl8PyvGh8s2XqO34AE8URXHZieA7YJUl3D7lRW?=
 =?us-ascii?Q?ZkeCiPX2SasbJGfFyzw//uoXELoaZegkVR2qM6YtfSN5E4pkgtrZjoghOdMO?=
 =?us-ascii?Q?X0VBnwnilr1G0+rQUfFpBEqoAw4gF2pdO4EyTpzDmXF8NG4zrLRwFi+5mCnu?=
 =?us-ascii?Q?+/5/lbmo/6fT5PE1kp/1/F3Dorw2SqHvVIuwlbQwLBAqYPPS22FecKwDiWCY?=
 =?us-ascii?Q?/IEa1Vf2tf2COH30kTEMLCMRItaRBKPhkvgryhZucQP7wS9gxnEX0adi4mbV?=
 =?us-ascii?Q?qwcBlFB9AiL/MeTOEgzkN6HIdRvyDvS3CSxZTd0Jc3YYaLzq25pvYKOVIaGm?=
 =?us-ascii?Q?GzNdVwvC7TumsWT+hLtQZZmGkJ9Zzv8ger7Sh+1THFH99FLZQkMJeCb9Hx7J?=
 =?us-ascii?Q?ocr2qnrreBiXjFw7sTPYROgMfz07CnXdjADW/nlT43SCoc0SLUC+XjY/3hkQ?=
 =?us-ascii?Q?ZtdW3LYfc2SKwjEttqYIKzSNOErrg/8Fs4dnwN8VAJIRZ7E0sfbv+iS0cGSy?=
 =?us-ascii?Q?eD3PdmnJsFP/tugam1o6i45q0g+66mgf94oZrtQSlAV4zjzYruLjTvqEo7fU?=
 =?us-ascii?Q?Q0uVZ0twpCxqtN7x8ok3G2qovrk/qUYxXjpKLGiLVoIHeosGXXjinTtR5YYY?=
 =?us-ascii?Q?KVU2JM8+dlWOd2A+N6jLwhxiNruRxb9qf3C/YqzPA0OFXcZ1RfN1sGvfb0i/?=
 =?us-ascii?Q?v7sjL4M323+Aw3U47S6IaYwEve+Gn8iu4ZZOVB8qRwKiLgQJ+t5MpNbpzRXH?=
 =?us-ascii?Q?4gEk2erV9NcTBgAyhf+JTYsSiCIcxHQV3V2POoPGcvYTQSIzbkNUDISA5AOv?=
 =?us-ascii?Q?sFm3npfneneletfdGVzQFrd1oP73p5iTIrdU2QdYKR+aKGIp2IKEzMQug0v5?=
 =?us-ascii?Q?s1Ldze4SYboh+4/znXGKKrSJKwQTEqNU7j8n/0XZwUin9ZmjC5m3glCjefs2?=
 =?us-ascii?Q?80lj57B878qbgST5782cu1aMA8VVDfDTPoarpGuIlwVoGvd5wI794HUohu3+?=
 =?us-ascii?Q?haTENL2j+vniTdGIxHJAj809r1qjPJaBUo+wg2maREUzssQh78EkhUmb1u/8?=
 =?us-ascii?Q?0zgkeH07XkkIEi/wqeOHmXaee3BZp35ZSAY/bUdTfhDLSTt3/Dvnxqs/1rOH?=
 =?us-ascii?Q?nK22B8iH7vkMa0KoslGTzN5jNzqUA2SgkonBNYDpje0tkynaYQ7f+ofToGiu?=
 =?us-ascii?Q?307MS65z3+3buPOBynhTkgS7G9E823Yghwo5BW5mWKO34kC+twT0sh/W65GB?=
 =?us-ascii?Q?+4GNIkMafTpzcwO1fYwTrI6bRLidISudljc5TsUlJx1PVti0f7ugSbpddbFt?=
 =?us-ascii?Q?juIrXP4fsibWPi49dSbhNIiDJlnnyfVcgRiZBMKSc9M2t0Ms?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4482d1bd-6e2f-4bed-5c76-08defd86617c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 00:11:14.0374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8ArLZjqDiWZumRlVKXyv5iLiDBjnOOdREY7333LzpQP3kyvD4MxJvuiHB2v/ZeI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7872

--NQF9s+ySguzlUyBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Interesting update this time, we have a rust binding for fwctl in this
PR that is expected to be used with the Nova GPU driver next
cycle.

There is a compile failure merge conflict that needs this
one liner in the merge commit:

 https://lore.kernel.org/r/20260818105350.361218-1-ojeda@kernel.org

Thanks,
Jason

The following changes since commit 075b74841bd0065a3bda3440873c747938e69b68:

  Linux 7.2-rc6 (2026-08-02 16:24:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git tags/for-li=
nus-fwctl

for you to fetch changes up to e052daab94ee8c4081c91de3549772bd1c235729:

  rust: introduce abstractions for fwctl (2026-08-14 19:21:17 -0300)

----------------------------------------------------------------
fwctl 7.3 pull request

- Support more commands in bnxt, this completes what they originally
  wanted to do

- Rust bindings for fwctl. The Nova GPU is expected to use them next cycle

----------------------------------------------------------------
Pavan Chebbi (2):
      bnxt_en: Update bnxt firmware spec
      fwctl/bnxt: Add DMA buffer support for HWRM commands

Zhi Wang (1):
      rust: introduce abstractions for fwctl

 MAINTAINERS                     |   3 +
 drivers/fwctl/Kconfig           |  12 +
 drivers/fwctl/bnxt/main.c       | 396 ++++++++++++++++++++++++++-
 include/linux/bnxt/hsi.h        | 585 ++++++++++++++++++++++++++++++++++++=
+++
 include/uapi/fwctl/bnxt.h       |   4 +
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/fwctl.c            |  17 ++
 rust/helpers/helpers.c          |   3 +-
 rust/kernel/fwctl.rs            | 593 ++++++++++++++++++++++++++++++++++++=
++++
 rust/kernel/lib.rs              |   2 +
 10 files changed, 1610 insertions(+), 6 deletions(-)
 create mode 100644 rust/helpers/fwctl.c
 create mode 100644 rust/kernel/fwctl.rs

--=20
Jason

--NQF9s+ySguzlUyBc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaoT0nwAKCRCFwuHvBreF
YaC5AP9wm48YFGNMdiqm3q2Oc6HE8S4AnBrT0SHutbUQwaJ62wEAh/+nPmZyL5RR
KvxMvqv8e9PPpRgyU799p9R+Es9xfAI=
=NHtK
-----END PGP SIGNATURE-----

--NQF9s+ySguzlUyBc--
