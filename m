Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022092.outbound.protection.outlook.com [40.107.75.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE14457D3;
	Tue, 13 Oct 2026 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887183; cv=fail; b=NLLloumtUWITOL0jMZfR6DVMWH2Te0jDDDxOx15NZ4NjTlS892Ks8Zc6ayFdP2pfR91kkK87gI/rGD4CODLo1ui08ksOCvp7LBX+53tIlsMPaV509yrA7PtusuzBh7XVcp14+8MCHZfyCCeffuDAxAQZy6nw0BejwlAGOW9m270=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887183; c=relaxed/simple;
	bh=KQql9XBtnBNE2MwzT9PPxkYqJkfCFjZquo4IIAyi93I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d2s8PaPzNDYm4K81lzo+DVQJNTTZCK+YTWnfih7HpP8s9Wk/DMonzmwE1oJWIoBDjUMk+DER3gsKP7OBxqevArb0RaAAsdAZI7F9yhrxQiivxgr+l9V71pbthe0WS0LELvkmE3uv6Jq/0XSLKtlh4c4sxQ+0e8+bO7FjSgKaxVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=AI2TCL+t; arc=fail smtp.client-ip=40.107.75.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="AI2TCL+t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SfIVwGukgbS6gixTbyCAcilutlkoxr3HJl3Ah0aYpIl/DyeL7Be1IXl3paQvpIetsySZU1D8O2hDIVW/oKy8f98fMtllxZMCejFC1znwMxVZ1G6H9K1g6lVqPOMalanZjfK7qBTnQyvycoQycCaFszgZ619qWVamLEesFZEJA0L+hzkrYnY/SS6Ugqf29DWkZILLtIUqsya4ivtf60EHvj/qQtQaz+OQaQeuI52S69gwLIM5Iejc+K/zHDL3s8uHLTbj+wjtbcl1tMVch8ZLXggZhNentgnjlIbdYSr3yuF0m0F/htjMBaQKC72Xu0QIpyaF6Rkrvjr2epsu/P0IUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=kDQ57rcVUpB9wNp2Ed2u80Ocrmu9KwAfuj1zyqOxPac=;
 b=xTL8Duewa+smAvRLzOFKXssPej1YLu3XdZgewSnfNOk6KrkdKtRl5rUu+cYK0XA/k454bbF6yAypkrTYcUZiqUx1dFLCrg6sSQJ1wvyvOzeoItv+hacCn9gaEdDUx6WbEXKMaMDgWhg4OuRK9otdOBgeS5D0lhXt9dkK9VLExt5xckZywmS78paHdoGkM3E+txBecdl6z1w0zVCs+3XofXKhcFA0eTCa7hdZQKkEt+v8lHjSvUPLtIF8KP+n+lVcfrj/+A6VEhylyjVwv/b+mNY01vlVBIwKY2IlAwBWQshh+9+CaDPN3ZwqsIS2rC0APrZGkO42jiwdtM5Jll/gHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDQ57rcVUpB9wNp2Ed2u80Ocrmu9KwAfuj1zyqOxPac=;
 b=AI2TCL+t1U+G2RX+z4VzFNOcpRTT7ujVT2BRue1Q28SwF22aviofJMQsmKRZi+QnTwz7PNXHWduyVy0B2Q042Px4FeUcTGVon2/0NyQTiBBvWOQC8bC4vdB7k6J6oYupq0+vE7PfiJGLPhIEsVKpUIOP1IrZH7Tr28CDiFaIfsQ=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SE3P153MB1821.APCP153.PROD.OUTLOOK.COM (2603:1096:101:342::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.6; Tue, 13 Oct
 2026 10:26:17 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.001; Tue, 13 Oct 2026
 10:26:16 +0000
From: Wei Hu <weh@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>, Wei
 Hu <weh@linux.microsoft.com>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v6 03/13] net: mana: keep
 per-queue statistics in the port context
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v6 03/13] net: mana: keep
 per-queue statistics in the port context
Thread-Index: AQHdV/xQaXhatRuV/Eq18iVf8aSIubb22xCAgARtAYA=
Date: Tue, 13 Oct 2026 10:26:16 +0000
Message-ID:
 <SE3P153MB1848FD85CD1BF3FA4C8864D6BB9E2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <35bb5bd322e53edfb2e53e4b57ed2e678f3b5105.1790795005.git.weh@linux.microsoft.com>
 <sashiko-outbox-166660@kernel.org>
In-Reply-To: <sashiko-outbox-166660@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bcd74dbd-86f5-4094-a89a-21a26cf622e0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-13T10:17:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SE3P153MB1821:EE_
x-ms-office365-filtering-correlation-id: 377cad85-fb47-4196-563a-08df291469f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|1800799024|366016|376014|23010399003|6133799003|10067099003|7146999003|22082099003|18002099003|11063799006|4143699003|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 tCLVShS4e1b6I7aTPoovT7rA8E+kL9JHQtfURLOLpYY2BhPvUSVc3DdgFa/ZnxrYEcw9JKaQrJgOLC6YB1A6KQ0R31wSwOx7cy+Yo917WCVJ5kraN+eOXLX/WW1ElUdavDUVFcKsnvfWRbj1UterMRmH5vjr8hR218hE0aQB3eFAcJGTGXZRmasFHiB+cF/QkOtBMuyHzkQaL+x00MzQiqIEld+lKesbLF0LPTUElcZ6Hv109x3IBmx6U9PSQJ/BCeijfSZHCZUP/C9mUk4LcknQnRl4CQfbEPahnunmXnD564izrLc9tPmFxPtJPzV6fxUgf9jDqycQH+Z2GEKmbZHEi5hZYhmNwtveAXfYIC67yJUWLdanQuhMgoxP4OhPRI5CQx2iUaxQP3VieEI4hYKPSZRrEbsfSbRKNEXrQyhT6QT1nv+uQgtj9fYLeiWvf48SoZpuM1n4P9emt0zJQBvsyvy0mdnHEhQ2ZdeLtOpWlHC6JuK8ut012aNPNbVfAw1Lb3kbJq2lkaqI2zkvmEx5co8EWHFpXdp+ocTZngHpjx7Qfqb32ZN7ChyTb1bMZjrovmc9YsDuFqC9R6KJUUwxVWmYPPcmTIq/5ocSAqZ9xkH/kwDfBzwG9M2t2NC13s8amXh0eZnDl9nl7KM0UhgdpvTsGjOUA+wh09odiw74rfuRjiQ2HtUEe921/+o2eDFae/zkGEa5q6iE5y3OxrIAL9bFawU4N5mU7dWibDU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(366016)(376014)(23010399003)(6133799003)(10067099003)(7146999003)(22082099003)(18002099003)(11063799006)(4143699003)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ij4Y/gjFWn/8WamLL8mYrZpdiIAmmrojEUXz10iTa/W8KGgK5PjMuERB+6RZ?=
 =?us-ascii?Q?lS5J6T4CG04qK2mwesyeygVYuAY882b3HYkIbmwX1gXmHz/DdMirGGwTwXlN?=
 =?us-ascii?Q?hxulMz0gmElTKFr2i+dEYC3a634ba1Yqz/zUZgLtsS6N28qpP9vGSUD22uuF?=
 =?us-ascii?Q?+fom235v5MQUjMv7033nv0Rkir3KX+2C4pwu8xiomSBGIXAh3WHnPq6CUYMg?=
 =?us-ascii?Q?Xsc47R5u9vctL3Pzekd+7p1nDM5vnVHidIJOCyKSQ72eYWHA48lTbvqsS0pl?=
 =?us-ascii?Q?7OUQa9uAzsUby58lbeWwMM6ZjniaKH61Ou/J63hKDLgn2ZMvi3LHxg4Ni5F4?=
 =?us-ascii?Q?pQ8LpwZRfIZOyEoASTjWTg4zVTyGo/GD9VJsVA2laRRHrjF/HUJe8lyj+Uja?=
 =?us-ascii?Q?5+JYeHkMxbs3kBPLLQzFHWnOV6Mpj/hWvpSrYawE+w7FhJS0iVJWoddIdPfl?=
 =?us-ascii?Q?CI3jOQaIfC4mEo2YXCx8j1uSxIFzuVqXAiVWPDr0ZpWvm3KeR9tXbWXSdr6+?=
 =?us-ascii?Q?W51563BRYxnawjZuOSR8DEZOLidciV1HzeiydQaBwLFrop7VIyJ9qxrX1WBX?=
 =?us-ascii?Q?ekHyMY8Z5Syai7lXCLIzQT7kwWv5o4tNGyQcffIbAExi37CQDIUN2urDTbuV?=
 =?us-ascii?Q?9YWsR29NTEnsBiINmZqzSRVlFl1QpmPvD/MU9aFMlDkOxZSvHX4mbzlMM/5V?=
 =?us-ascii?Q?wte0Hy33IN9BDr/s8BqqbKHagpbmaPEWtNAAsXBAnRf3R3tOn3pLzClJ7GwO?=
 =?us-ascii?Q?RGB+fee7AGKWPQQ9rUNlH5mp+4ATBCrQMgukJ8VLQa3PbvvKjVQjssDB1Q5L?=
 =?us-ascii?Q?zFRrNaskoVfcTgGGnzLbhfIzv+xHYNJWKRIQUXEq44DYxjj+NSClniH1uRfi?=
 =?us-ascii?Q?u2KDZQhuDNwcTDCkM0r0PZzJddYrS0hu+1eDDa2b7gM4j+eoGHwn2UfEmWLQ?=
 =?us-ascii?Q?qxy6rzqLHCzfMQbyeQ2vBN9lF9YIAaaluPOAIlvecUPF+z06LTJPWxxQeXK6?=
 =?us-ascii?Q?RqrJ4bbaj8fOH2do+LQGBYRy+u67WeVoXapgIxRQmYtmnlIY4Kj8bfvpB3e3?=
 =?us-ascii?Q?zojyvDoJZtHxG5ambDBD/IWWygA0WUzuhStyfmYfZ2mh63m/M9WM4/A/Do/W?=
 =?us-ascii?Q?TL9AKidEb4OtAk3wxeG7uHR1HWIstW6oa49cQZmtGbOFHxvckKuBtKE7ovvt?=
 =?us-ascii?Q?5WJIQ8ormBdv9uVga1wFeUXosab6eSIW3Zx3AmvkSL7cuXGEn6J6WgOhnKr9?=
 =?us-ascii?Q?vguadXj1MFIvCqmznOusckpDDfby6j6fU5eVjn/Hq7QR3RG6DJMQi+yjAvGQ?=
 =?us-ascii?Q?YItKjcI007qVBxObZj3JUOsSJMDLxppjqj+NmSqsoXhmTgljBl7Fv8nhYrPp?=
 =?us-ascii?Q?2A1qr+iISywdQuhqGtHrJip2xiIm9K0nJwkE+p6vA0wrM/Pwi5kigmfUicC/?=
 =?us-ascii?Q?3/hH+qK3jskwCW69N5ewmtICvxzT1Pgv5ZMib2FZBs/I6fS9gohcK6gVSul4?=
 =?us-ascii?Q?M17F+o8s/ZX6zFACz2zKUVT8CDcwhiv5th9jS5jAIBVIwIr8JW7ltsL/VoZx?=
 =?us-ascii?Q?OmnZXd+psjPKTcBV7KRhRcYXriEICq5kiy30hBCWuHGNXv+YkE54Gfw+Kb0Y?=
 =?us-ascii?Q?Vf3r+iTwu1rh4Fg2CMCytfDEWtE5VzdXclJvNJJQ3CtN7VSZa5VaBnxomviS?=
 =?us-ascii?Q?3k7RF0H8QHwFxkY5wvFUyMj2beMhEZrWjhBf/oCsvTTnIP1m?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 377cad85-fb47-4196-563a-08df291469f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 10:26:16.3560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a2O25Y9N0d7Wv4j6dYcVD/mae17JCfEKRyaEbpmVnfpYM5QxwaIbHPgHuRR7yNU2f95fSvpdcsq0N85tWWdOQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3P153MB1821

Thanks for the review. I checked both findings against the v6 base,
47a144672573, and the rebased v7 base, d8674294aefe.

> Does this create a use-after-free race with lockless readers like
> mana_get_stats64()?

I do not think the reported unregister ordering is correct. The call from
mana_remove() takes the immediate, non-batched unregister path:

  unregister_netdevice(ndev)
    -> unregister_netdevice_queue(ndev, NULL)
    -> unregister_netdevice_many()
    -> unregister_netdevice_many_notify()

That path unlists the device and calls synchronize_net(), removes the
netdev's sysfs object, and calls synchronize_net() again before returning.
These steps are not deferred until the later rtnl_unlock()/netdev_run_todo(=
)
processing.

The /proc/net/dev walk holds RCU protection through dev_seq_start()/stop().
The sysfs statistics read is also RCU-protected and checks netif_is_alive()=
.
Consequently, the reported readers are drained before unregister_netdevice(=
)
returns and mana_remove() calls mana_free_queue_stats(). This ordering is
present in both bases.

I have therefore not added another grace period or moved the statistics
arrays to a deferred destructor in v7 for the reported before-rtnl_unlock()
window.

> Can this result in lost statistic increments due to a data race?

I agree that the xdp_xmit update can lose increments. Different CPUs can
select the same TX queue, and u64_stats_sync does not exclude concurrent
writers on the supported 64-bit configurations.

However, the same unlocked "tx_stats->xdp_xmit +=3D count" is already prese=
nt
in mana_xdp_xmit() on the unmodified v6 base. This patch changes the stats
storage from an embedded object to a pointer; it does not introduce that
unlocked update.

I have recorded this as a real, independent statistics bug and am keeping
its fix separate from the queue-set revision. I have not identified a
queue-set regression or a blocking dependency that requires including it
here. The race remains unfixed in v7; it is not being dismissed as a false
positive.

Thanks,
Wei
