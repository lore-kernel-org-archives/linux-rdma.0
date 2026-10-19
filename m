Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022085.outbound.protection.outlook.com [52.101.126.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2334CDA37;
	Mon, 19 Oct 2026 10:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404820; cv=fail; b=ll3fFrLKRuklAdUE4Cyvl/0MIFVzAndWDoE37anqV5XC7MP7eMw6ZS3obDO5IrvOdNtsKDRZbFhcBMoA+aWmJ/9LV204iO7EgEFK1eaiDUog9OtOWtoFSgo5g+bHoICoAsLCTylg7Fd80A/L5v7ddUD7AaHTYpJjJp8OeyIjBCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404820; c=relaxed/simple;
	bh=h3gVRyxkPQOp5CqpcJtdgXjUv27OZQ5nYBktB501rvQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LYDk3Q/8A1WZCL3eu8x+msbDmLlS7mQ8UoCAHSDrpOTFRa1O5jp0SRhWZ7gqoabV0/zXDd8XUYXnszG0SMvKqtco1HRNfNQG1dnjfG/hF+OkuLtBzOrCike8eC0gOhzl1nVRaYBmM2dlY2ufs/0r41xIoYx5ASWXUMIbzyPRetY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=D9bBWEXw; arc=fail smtp.client-ip=52.101.126.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="D9bBWEXw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgjQiGBIEgTva90n1NC7iA+DBxPqKgjJ7oIAakyK06UUgDUrKzjh+NaX9AFuSfruuPnHEnN1gFcP+ATbtSkxVhUTVWn9Nx5S066WG7o/LNwYhvKqsYS7Qn+sRQqKkjrjh3vqVxiIHbLiMKDujp5q3vVAUJkhNljqasuKYpHY2N6d8WkYDh59pm7AMpRuzznN2Me5toWbZHjuafcf/pB8FnNUCqEQyLxnpm+b1NP4JdUniBRv3PA0Th9SnbCYzeIqPRf4IrwxPk5aqObc+IArNdDkKc6gHWKUr6szbMaX6jSX7VuNn/J6VlvoO/K9W8HhuTQMd5MgPKbQK2kcEJ/rrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=h3gVRyxkPQOp5CqpcJtdgXjUv27OZQ5nYBktB501rvQ=;
 b=GTbzPARuykZxGR4N8TaSIsyyJoskYLcHRPeqIFJZ/7/MkIcmJE9Vc6PkfsUBSFT/KQdA2sojY7ZWyAvOUq6fr1oKAO4PclNB+YiskHRf7Znmj4Gpb/mQx2Gldmgb9BumiNjyOR2vqHnp9SVg2r+rx/26iNzYgyZxX1NLfuGxlCk1yLRclzynfzzn0bVOkeHA/AKOAVQUDJ/lLbYkcETNdiveNiMWkGS5CWQNapdtsZLOPzidAr4ibZ+r+kFV+iG7YAwa57eR6WjsdB/S+ijsaQwmSzV+80tTuS+IVYg3RspkzqxPC6ravEfjPYscXfBnhKIG2MYkNXEClY8hOs6lpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3gVRyxkPQOp5CqpcJtdgXjUv27OZQ5nYBktB501rvQ=;
 b=D9bBWEXwYWXkMi/8/e2ZW/QeCZ56Mq9UZ6mCTH2DGbk67InxgT4rnQ4hi57j8nE2TtbtiWWWsHSFIYPohClxqzbmVE98yyzQ8rYTPJ04s8fsYzmX4jtRIdLNETD1/qLOYkWF3VTEvttq8uhLUVfcH3yrxDtO2RIu0NEOYmBWUF4=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SEZP153MB0791.APCP153.PROD.OUTLOOK.COM (2603:1096:101:a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.0; Mon, 19 Oct
 2026 10:13:32 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0569.000; Mon, 19 Oct 2026
 10:13:31 +0000
From: Wei Hu <weh@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>, Wei
 Hu <weh@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v8 1/4] net: mana: prepare HWC
 ownership for safe reinitialization
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v8 1/4] net: mana: prepare HWC
 ownership for safe reinitialization
Thread-Index: AQHdXWbLNk6ewlhwnUS+aa2fSPI+VLcBpSeAgAL522A=
Date: Mon, 19 Oct 2026 10:13:31 +0000
Message-ID:
 <SE3P153MB18484659AA1DDB56695CF21EBB982@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1791998462.git.weh@linux.microsoft.com>
 <64987f49ea13b5ccdc9ef95f4a9baf23a479edc3.1791998462.git.weh@linux.microsoft.com>
 <sashiko-outbox-175499@kernel.org>
In-Reply-To: <sashiko-outbox-175499@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7dad0630-2d5a-422a-a578-db5a56cf7494;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-19T09:33:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SEZP153MB0791:EE_
x-ms-office365-filtering-correlation-id: 272cd593-a0aa-45f8-e66c-08df2dc9a05f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|42112799006|366016|1800799024|376014|38070700021|11063799006|4143699003|56012099006|10067099003|7146999003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 fMrxL1rbP7Ah+tznyYL/NrF08ZOHp8lXsjyqUcXBgzYp3CnuMd8HQjr973jiHjYfkbUBCYA0BzNtAdluGcgcXh5JJcQ0xcVn9D0+HWp2YPlopcUXBA2iSwKcXmDQUPraRNf7sCEDnQ0LFV4yl6nhLyBZAwooGRbUYN4U8o0FM51MmXpps2wU6DhhNvN7VGt7zJxVYeyG56FypN1gRHXDKT9RiEX2EEva+7Z47DGaP9TpJmoM+DNiIg7RS1EaDS8HMysh1XobhgqTE8gBkMibQEKXZfDB8wqQOKKeVtaGvyl0WK3x+jXE8cCQ8jhck8Vbo/c7NRywUqYWKh5nopbNR97IzpPc4y0cS0WpkQvzq+M2ujJwxA09zQjb6VNDXGM8SwaBbfXY1R7eqWuMbBv7R4t4b8+Uu9DItP6a7FXzuyZ3cElbaV8TXlAQDmlzDN60lWm00Hil0XojCfTs5sHQq1jZdn8wLvZlKhubpNJxGCoFxwGxw50q1U9mfAb5TyEo9s/H8DWzb/Tll5X5bCLSY4JK/gj4NqHVxIrOtQLDiPsIeVMmNj1izMAr4+XbGaZide5KjUMvXDr5zlSNVY+t2YomIQCSRY8MwDCJ8tObsh00zLUUELZiQskFOjUrS2ZqYKeaO0MPZDXYm4xsMdHCLqS7X1FHLD2ShlqTTBWCJiHkAYhbkgaVMWaD8Ywp1PL6J4RyYUmMxQesEhdLXhCpxusgNxcLIjQDsrtTpBZQ0L0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(42112799006)(366016)(1800799024)(376014)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003)(7146999003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9cU8OogkFHTTLNIrLvXapJamdgLpCIc6Lmz0a9Sa5y2BvTynHTjw9cGh4fzu?=
 =?us-ascii?Q?6VWJ54dGmNXxtZNjKL5fGc/vzZsjPAslcdid2q4oGmSSRPZyz+aWkLeol+9R?=
 =?us-ascii?Q?V9cexp4s3yeq3Pcw8xu+GTaH1Y1fHEOmZ0HaQhSGAhV72KB9PrMkDSS9SEWb?=
 =?us-ascii?Q?8cqy2IeOreUEuBQWwtXTgVxbXKUw8//ixZcDc7jZ6Vg1+hhnvTIhpPvab8/+?=
 =?us-ascii?Q?Yct7jtmovlu/NPqiXzScx26e9xxBne9RqEBicmUT5kfNEthDCxTvnfWJEdrx?=
 =?us-ascii?Q?MtE0Cm99wnG4r57XFISkRWBKY9OHC1/aEOwIAbXrNwa4Y8ZbyaiFm3z3M92Y?=
 =?us-ascii?Q?lrkXrU2C1EVCQ2NpbJ0Ur8mOao/jMAiR7dL+yWxndjs/QHQXga9f3skQX8yN?=
 =?us-ascii?Q?EJPWXmI7RE98SxxLE51jdy/4pC1swwSR5BzLqiT9XMAJ+/7P7Y2PFRvDCWul?=
 =?us-ascii?Q?CGcfNSSH1bRxumZbnj/maGnpN1aGeBsZysFBe6zumLRBmPQBzUdy1tKKW7i0?=
 =?us-ascii?Q?2LtGwsgc+AYspSEjFM2GM4TgBQeM3wNE8NKZnFPIoFIenv/NXTOQ6ejQ6eWH?=
 =?us-ascii?Q?qtjdGpU2hh500y9mzFMyYyHb0pha3fWNBoTehZx+A2xl6aDI8tqyWn1+rXeD?=
 =?us-ascii?Q?YuwUb2PesGVcEwqzglwaljmeKxC8LK18IRCkrUKnmNeqYG/uLKzMXRVGjXg+?=
 =?us-ascii?Q?OJK2B4Gs/KKX/Wp+f75tLGr1OsT39f4TekmKpHgxd5ziKPyT5DOVLI+Kkzck?=
 =?us-ascii?Q?oJpqegpUNpdRpQEQiolNwY+kZDzp64jvUOqaj+3bnFZPKVRcn1muj2H9Qk9x?=
 =?us-ascii?Q?1DMj4r1ie2m9RwG/5ZuoeQbKpBXhAdXfuW3NKHCV2DkdYQainqeaSdJJM96N?=
 =?us-ascii?Q?jPMclsQmLZZFttlQAjkBl+BroPtf2Cfy1zov5+amHXCnBxqjnUfZHPxSYOvo?=
 =?us-ascii?Q?f0W73hvyiVdNpFTEIBbAmBXw6/6aU+K1XS6eTfTyc4/si01hMC9toBNxrXDv?=
 =?us-ascii?Q?1A1DwqHY3/XXcY+bAXKNCsP2VCTsLGQQmAryaeUAmFQkZzSAj/DiTakMJbxA?=
 =?us-ascii?Q?9ulIaLvw3rZrS/6XichYDvmWrxYNSoqUtDWudt3vLXXec3viGS0oLTU1vIUY?=
 =?us-ascii?Q?K2woSQP9yFrJ9h2oVYiovBB69I619jXGLVteBgw+BomQh28t3MLveAUlFamo?=
 =?us-ascii?Q?IbUi27CHgUonHKcwNoYkn9zbVSFtj+2qh01attD4ZVJcetRNO3aMC/GDHxef?=
 =?us-ascii?Q?FdNDlsDOslyfLAtT2kTi57LNTC9Dqc1ZqYrGEGX3KVfgTWeKJpO6jUdHOc2e?=
 =?us-ascii?Q?gQzUFx/NvPfQ30ppyq1KgGcHJAstElNB1XNOZrEF8iNddCVUSJr1vIcgMOsS?=
 =?us-ascii?Q?WZSpUVuSXkYAKop4YPScYrp3wnaPSseeKDYCff3ZzWs8KtLkBTZYE0F+0WFw?=
 =?us-ascii?Q?+Wis15sdKUa1BpEsUIorIpTAUpVP5Ivvplk1jhZwGhBiaP4rvkYPoRMfehqA?=
 =?us-ascii?Q?2Mfn0aJ1aP+0sOMO88bKHHlkTFrDcH3ENIV5XxGm6uCnIal3m0rU73oO7chG?=
 =?us-ascii?Q?TAdQGTBLvu/r9UTivAFxowWoHNnBDx+uzkmBr+mQWAYl1oujCTD+c2DkxePk?=
 =?us-ascii?Q?5uc1mwfnf63v0dqSWKVBXNU1Amj54EnjaMwjNlZ9Zf68FDmNLv+TETT1WYa6?=
 =?us-ascii?Q?AEfXur01Y8vlpNrNq3Jmsb/tZr0MZh5mddRW5oD1LlbMfUm2?=
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
X-MS-Exchange-CrossTenant-AuthSource: SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 272cd593-a0aa-45f8-e66c-08df2dc9a05f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 10:13:31.2018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IgpKMSeuCfPc4xd/OX/bH6WiX7ay2nJyTexyRJIaWgNlkYjGMU/OcwGd0G/LbeAHNRHkZYN4ZeXb1MfTD4Qqfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZP153MB0791

On Sat, Oct 17, 2026 at 12:06:45PM +0000, sashiko-bot@kernel.org wrote:
> Does this sequence still leave a use-after-free regression for Ethernet a=
nd
> RDMA queues during teardown?

Thanks for the report. This is a pre-existing individual-CQ lifetime
issue, rather than a regression introduced by this HWC series.

mana_gd_destroy_cq() clears the slot, but mana_gd_destroy_queue() can free
the CQ while an EQ reader still holds its pointer. The later EQ-side RCU
grace period does not protect the earlier CQ free.

I checked unmodified net-next at 98c2ad4f5d80 on October 17. Its MANA
Ethernet, RDMA and header subtrees are identical to the series base,
05b5019b01fb. The Ethernet CQ reader/teardown ordering is also already
present at upstream commit 02fed6d92bad ("net: mana: add msix index sharing
between EQs"), from December 2023, well before this series.

The HWC-specific teardown addressed by this patch is different: after
acknowledged HWC teardown, it unpublishes the CQ table and waits for
existing IRQ-side RCU readers before freeing the HWC queues. Individual
Ethernet and RDMA CQ lifetime handling remains separate, as stated in the
patch description.

I agree that the reported issue should be addressed in a separate fix to
the existing per-CQ teardown paths, independently of this HWC series.

Thanks,
Wei


