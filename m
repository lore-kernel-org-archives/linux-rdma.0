Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023074.outbound.protection.outlook.com [52.101.127.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C254483AC;
	Fri, 16 Oct 2026 08:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139435; cv=fail; b=id5S+B7S92QjeeCha8aOlP3kAXcRoYk/PgChMUxVE9eGCV8EQoxSp9jqB2ua77eeSweXn5lZwvQp1+uyyNkkIksHTpk9OQ17xdCu/QKUPyN5is3zRc4vM4FvN/FyAIjYimEZouf48HZXMNb19RvYx+hrxHH38djSPAc2udtW8Bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139435; c=relaxed/simple;
	bh=RWgl7H5IH+EB9+MamVxamcEoaulq6I3/R5NTzRc8VAU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f8qyoBZTWXtfezmosCoePvDJ3pboFAnnbMF5vbiq+FfxXpQTHBZBHeb9hnjypRJlZwS2zJrthuoVl09ENVW8QtT9UaCQ0ksf6pQT9gFw10sYSJkx6jIHe8964AO+JhqU/ABfNmtrqah5veLGrdDV9NGBOP+O2UInyob/bM8YXJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=G/J5GnR8; arc=fail smtp.client-ip=52.101.127.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="G/J5GnR8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cb8qcw1ENqJ25x1lx7VD+b0NJ2g26Wuk6KzwBAaawBmwVsW9HQSs6EU9t7iZpmSwDd7nlQKzFKAjCKyuASQi4g2qAfPTS/qm/8W7urP+pVDIynGgyCxrbly7Pge9kPKnWhNZeb6PWCBFyyXBfngB62vWUM0ZpVPnnC332YVMYAt4XmJ1k3gbECboiOoC0qFbPyBMLE5TXXI2PIEkj8ighZB0Rlr+VMI888jWxPofYwfYu09Dmi+nTZDBuSs8eaYBiCghW1Wz4ctcwITSSQH0sbi6O8xIqsQJ+gvvtL4e4xy3vnmEHq6IxNo8+vsqaYiODcT0F58J5xolakt1ZbJNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=RWgl7H5IH+EB9+MamVxamcEoaulq6I3/R5NTzRc8VAU=;
 b=RCPEjfxi7ewWEF2WH8qg6iWb+IO3OUMUtSuWcKycaC9+XejC5oiHfFwr4H8v9+zfANqIcwol2usBZRbiE2nPGLrB7ylOzDw3/GSrkaYAFuEexhEzhI8CUSyKMXPnzjJhW68mkDfWi1VdbvPbwsaUJh4jm7hE734LHjnp9W6JoCGV+Q59xYa7CruKzOSHRoS2fXlkMu55R3Syymxq42mljsJGQL04jt2jzl6d+VyIObf2r4n6iNl+BS+8oQH6B9XpZ3WwtObHLDzdU9kY+rWZD7sjR0Z7yFYfPNkJpeudrNnIwZYb8EOdTmRLsKh2sjFExnV5iMH/Q/jnDRpJNqHG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWgl7H5IH+EB9+MamVxamcEoaulq6I3/R5NTzRc8VAU=;
 b=G/J5GnR8usUoENOI9g7+KiI0ekLkK4bP3htaojwNxCkh6jnkgdzLMSVOOdPIKLpLfuMDOOfJcn1I/2daXjL28X9g5CoteVzvfmdtAef5d4KdEi0L3+BcDrljv9RPJ3u/yKoGFgeUkI8/Y1J0zWSbDK1it6zFomu/6DnD6lYgeL8=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by TYNP153MB1769.APCP153.PROD.OUTLOOK.COM (2603:1096:405:3c8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 08:30:25 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 08:30:25 +0000
From: Wei Hu <weh@microsoft.com>
To: "netdev-bot+sashiko@kernel.org" <netdev-bot+sashiko@kernel.org>,
	"weh@linux.microsoft.com" <weh@linux.microsoft.com>
CC: "longli@kernel.org" <longli@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang Zhang
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan
 Cui <DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
	"kees+treewide@kernel.org" <kees+treewide@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "mawasthi@linux.microsoft.com"
	<mawasthi@linux.microsoft.com>, "edumazet@kernel.org" <edumazet@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 4/4] net: mana: add dynamic HWC
 queue depth with reinit path
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 4/4] net: mana: add dynamic
 HWC queue depth with reinit path
Thread-Index: AQHdW7RDPuFatFhGZ0aVXFI+Ix2Q8Lb/2HMw
Date: Fri, 16 Oct 2026 08:30:25 +0000
Message-ID:
 <SE3P153MB184858FE7A2D085C8BE48742BB9B2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: =?utf-8?q?=3Cdf59976f0f5e51ea5766451f02878bd04a4907cc=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
 <179196575846.434549.7933818740976196422@kernel.org>
In-Reply-To: <179196575846.434549.7933818740976196422@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=57b3afe5-0bd7-4145-b61a-211d41b98c40;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-16T08:25:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|TYNP153MB1769:EE_
x-ms-office365-filtering-correlation-id: 125e39f7-2aed-4c15-7da7-08df2b5fb9ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|42112799006|7416014|376014|23010399003|1800799024|6133799003|7053199004|10067099003|22082099003|18002099003|7146999003|11063799006|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 Mj1HT8SV5cq9SdJ2G0TewPLhyyW55rCyC8hMKhbWyBkgdgEniBgjceT5rIpjC1dbUfFyYpCu6Lx0PelKffEyhxTgH+9X+vNaQI/8FvTDFgnB0G2QER56NopYvCKWTx/fK1UrMSQIcr0H6J6ER2MsoskW+l2QBBtY81wMnQJi6wS9ipaQTRVPe9ok6PUBm8n2VCnsSnQpXOiLz/Z5StRe7L+gi2Quu4c75pZYBZF4Gz5d90BwThi1wKWijqzrS3+77PN2fU8CbVtQPjTVD6F8AlGM/l00t+lKMNNl5wfirWbYbH0bBfiwG2PAkHEowjivU5zwzDGtinS3o3aqnQa3kyM/CuhyfKHh1KCXmY5h+YNh4p5JdsfgVTOPDSV4eiHGkjNgK3ecRrf3ZTtyuHM2HR8x8Pi1bt6OlzXPCED1Q3lVSeaSBfAS2ENptl4SONZU0u98a/YpJ4vi2BrndPwQcQOrTLMw16kcxAhAROGyCtePw4sjVXemJHr8t7EpNZ5/kGjGVPxrutcMiMa+J4xpWgrQj9ARq4HBxFTWgqtNNgnTS6ccFLeVgI4FNdzGtmf8E2Wx6PsfAwit0DUqQ5czVRrcSqdtPlQgxpXWaolqKlspbPA2OHcYVdaxbdoFMX0HQAjqeeWsweIt6HGbxZQrjsEuqy1AULcbRyx6uZcwLV1SotcXtH1eGx6nDbJ0sfLfq99+ekBhF45g8Dliu6Xtznzg8Tfuhn4+tO1hjfPfXRs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(42112799006)(7416014)(376014)(23010399003)(1800799024)(6133799003)(7053199004)(10067099003)(22082099003)(18002099003)(7146999003)(11063799006)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mHaiCkPA/ejfherAcZqXrc2H87uKqFjCls20iP90BfZrWDU0ufh6fjrIhOOb?=
 =?us-ascii?Q?x4TQU+rBTAlUnnGEzfxrVjLH719L8H1PwKOxdKDkLOzdiWi/0zrh3bQ6rFku?=
 =?us-ascii?Q?4g7r+4BGDKUAEXSCsPvkKoVm+m6rilRmpcQRNa1giN1923F6mU+qMEyHhgtW?=
 =?us-ascii?Q?zT01Ig7opIkS7w9dFJiEWceyRE67ZB/KVFwO3VJ1JuHvMirOxeX05a6cbSag?=
 =?us-ascii?Q?wdDk4dRyXuX2bycRhrun8e+BjWnAmwhaGTqBx/QdwPZGiVY89wW3AxDjTg+k?=
 =?us-ascii?Q?5SrvBo+eyWuCMFDZV4jCUVPVitV92hMAtjXDhbNSi8v1VK9PmePnCdjpksBQ?=
 =?us-ascii?Q?6/Pb4UDgMCgUq2yY1hLEommx+6Bs63cwO6G15zbA32CAO01O/4rEeGLFWxeJ?=
 =?us-ascii?Q?YqUqqpNJ8OngI3/qBeaXrl8e6yXNiKc0z4ln6cnWgg+ThobTFd7qjLMGluOi?=
 =?us-ascii?Q?+aCE/4/9S1Bwr8VGJcmIBxD2TqtYGofpzVPfhYLKv+8rqLHVAEopplpcAdpt?=
 =?us-ascii?Q?xaXqZwyqd67AbfekLsEyfAHWDwaGfGFFtn+C5wl7FHdh/0QrcNSgTdgZRm5T?=
 =?us-ascii?Q?6P5xrDCY41MgxqWVKxoXKX7X2109UkrrH1rOsflH3UnBUC+NzY4EBG+/V7oq?=
 =?us-ascii?Q?kx2XARNhj38UNIwaTB6ZqXVF1OtEOINP3oakH+5R8yMWlRudEsQGKxO4CaVb?=
 =?us-ascii?Q?gmep+N8KzKxcKhpsMt1A5TlGEj2fJHyIwDtUdUUDQ9+0Vn3fNBtBZe4SP2Fg?=
 =?us-ascii?Q?87S/3iq8O3oSmtWwj0eL2mxeZI1kM1zhl0lj4jTmZzzmKMPOikOI0YBFx3sh?=
 =?us-ascii?Q?CeR1X0iFmu8e4Mt+YUQYX3X2/3rigQKIpVwvU4Y2uQr0w44E+gzqLnKzIX3w?=
 =?us-ascii?Q?4QAIlMl2dxq7rBLPbL2QVV/Vs+wAJ71JZVsQWlKnB18hHh1o34WVQBDnpgGq?=
 =?us-ascii?Q?omZccYq1kw8PekUP40AEdKQvnTkk6ulhsPEnD3Q/79xzZ4BP8LSB6Q4HZpWr?=
 =?us-ascii?Q?MUDd8fMaeQoXKUxV25w+fbw4kv6abr4QFLTUleBu1wFQz8V6HIpvuoPGr4CJ?=
 =?us-ascii?Q?6qPLDRa1TFzYJbjGt6BPc6d96GAYSU9R8ZoAkZekeK+H5zjCw3Onf7sEwFQ5?=
 =?us-ascii?Q?yWrGxr0XOG0FBlvB9TqnEjmVzsuWX4ZczuJNyX/sLUoTPilHrPn+LYkZUMYB?=
 =?us-ascii?Q?zY2shcNkzhwJXwG77yFVVfjmVysv6vn5Mljg1MR/lIslOEsL0y+JLpYOYeco?=
 =?us-ascii?Q?Tl64wzlNQzqmBWf7r+KWaQrYWdIvGrMDp8iAFkAMBDKUvjSST2lZ22oPLjsb?=
 =?us-ascii?Q?MRoRh5HF42guoLyw1uGVscW4XDpfINN47w13bOY7iEy/2lNG+tr4AoqjlmzE?=
 =?us-ascii?Q?MLMzmOvQtZgKBXuJ6GWMHJL6Xh3QJPMFEDCpEsOO+7D72MnZizDv+7ZEzLk8?=
 =?us-ascii?Q?P0J77TCk0bFhmdlc7BolroSM36rf53argWA82ud6DtGFJtv+IzIH3xfXKt5t?=
 =?us-ascii?Q?aPBJNepfsMVzlc7wBZMl/flMHsukKHKo45G1M2u/lD7GmccLJwe+6Pvun2kX?=
 =?us-ascii?Q?T1gW4lMmjcEpgx+euwkAvwikNE9Z6wBJWD0BzP8VT61XA3Hpc80xcHRjlTkC?=
 =?us-ascii?Q?TkjbeSHx4/uEtoAWAALMmIJUNo6kzStreGhV6/GttKbgo+o/IWiRVpNXFtRi?=
 =?us-ascii?Q?wtqqxwjIzdXJCf2z+HbkcXxov97lRy5A/DdvJC+iL3RR00Ku?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 125e39f7-2aed-4c15-7da7-08df2b5fb9ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 08:30:25.0854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xk03imQAy07TkpRCGu/QrucaJ+4ZDaShkLY/C8nXs/5zmfEQVPugoQJXq3HZqQAQCGWWlSEW/Smk+sp/GnyrNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYNP153MB1769

Thanks for the review. I have prepared a four-patch v8 based on net-next
commit 05b5019b01fb, with the following dispositions.

On Wed, 14 Oct 2026 08:15:58 +0000, netdev-bot+sashiko@kernel.org wrote:

> The commit message says the effective limit is enforced on every request.
> Should the in-tree producers be switched to that same limit?

Fixed in v8 patch 4. The admission path, GDMA queue-region size check and
RDMA MR builder share min(negotiated TX limit, allocated SQ stride). RDMA
CREATE and ADD_PAGES batches are sized from that budget, with
header-plus-one-page checks before subtraction. The RX allocation stride is
not rewritten, since RX indexing still depends on it. The GDMA queue-region
helper retains its existing single-request rejection contract; only the
existing RDMA MR path performs multi-message chunking.

> This closes an existing hole. Could it be split into a separate fix with =
a
> Fixes: tag, so stable trees pick it up?

Agreed: checking the device-supplied doorbell also hardens the initial
establishment, not just a rebuilt channel. The v8 commit message now says
so explicitly. I am not labeling the whole dynamic-depth feature patch as a
standalone stable fix. A minimal backport of initial doorbell
validation/failure reporting belongs in a separately qualified net/stable
follow-up; that routing work is deferred rather than dismissed.

> No dynamic-depth capability bit exists in the tree. The only DYNAMIC flag=
 in
> include/net/mana/gdma.h is GDMA_DRV_CAP_FLAG_1_DYNAMIC_IRQ_ALLOC_SUPPORT.
> Also, "from v5" won't mean anything once this is in git history.

Fixed in the v8 commit message. The references to a goto-heavy 'v5' and a
nonexistent proposed capability bit are removed. The message explains the
actual initial-report negotiation and driver-version ordering.
Revision-to-revision notes belong in the cover/changelog, not as
unexplained history in the commit.

> Should the EQ test be part of the rebuild, so a failure there also falls
> back to bootstrap? With the parent commit, the same PF would have run on =
a
> tested depth-one channel. Recovery retries would also go through the same
> rebuild again.

Fixed in v8 patch 4. Candidate functional testing is now inside the bounded
rebuild decision, and fresh bootstrap fallback is also tested before
publication. A failed candidate is not reused without acknowledged
teardown, fallback is attempted at most once, and its own error is
returned. The prior live timeout budget is restored before fallback so a
failed candidate's one-millisecond reduction does not poison the retry;
zero cancellation is never revived.

> This isn't a bug, but is this comment accurate? mana_hwc_destroy_queues()
> is also reached during runtime teardown:

Fixed both comments. Queue destruction now states that setup is private
while runtime teardown has unpublished the channel and drained senders.
Partial initialization cleanup is assigned to the setup path rather than
only mana_hwc_create_channel().

> A later mana_gd_send_request() on that retained channel would compute
> req_limit =3D min(0, ...) =3D 0 here. It would then return -EMSGSIZE and =
log
> an unratelimited dev_err() on every attempt. Before this patch it returne=
d
> -ENODEV, because channel_up is false.

Fixed in v8 patch 4. The size preflight is performed before admission or
caller-state publication, but a stopped channel takes -ENODEV precedence
under the resource lock. A retained never-prepared context with zero
negotiated limits therefore does not produce a bogus -EMSGSIZE or its
size-error log.

> Wouldn't wait_for_completion_timeout() run the full 60 seconds and return
> -ETIMEDOUT, instead of failing fast with -EPROTO? On the rebuild path thi=
s
> can happen at each establish stage.

Fixed in v8 patch 4. Invalid doorbell metadata latches -EPROTO and
completes the initialization wait immediately; it does not depend on
INIT_DONE or another EQ re-arm. Establishment resets the latch for its new
generation and checks it before publishing the CQ table. Later apparently
valid events cannot erase an already-recorded fatal initialization error.

Regards,
Wei

