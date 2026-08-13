Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020109.outbound.protection.outlook.com [52.101.193.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A23D282F13;
	Thu, 13 Aug 2026 01:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786584063; cv=fail; b=stWYk9Hm+ehVsP/EDg+NsO/L83j/LolfUj4ZO3kbGeRXn0u6URbPjIcpcpjcwkGEXjeWn3y9as/Hx+iRtzGJ9Rnm5sq6UvPgyVyELwmuzUPGKoGHKRW54vxOJkh8Z4Wxjt+mS8O/wXuLxgsAScqRUBBeMz0YR5jzYrFBx8Pef08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786584063; c=relaxed/simple;
	bh=9wpcDqUcZbI+KTAknWTNKvYIm43luxYSV5ADqBGGsGc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iPwZNOpYJONHeuax0ylAmErtgkH/SdqMfyF7tN5gUxp14+EvBzGYu4UL7nf61khfNQIrbwDDMxjH8PgHB+PKfniHZpSLv1ZORbnJmyMwX25nPFqAUSOIHtccCkw7L3qYufpOnaY0wJEw+jhXqfw4QMa/wE7ZSrRuIX3dicUZ5Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=U915T7VV; arc=fail smtp.client-ip=52.101.193.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="U915T7VV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6WyvM8bysz4yXwtSL91HMX0R89hBuQxRVpO3HeamUYr4+qy/V/2oktAqFfHJG767PdhNj/H9uSIm9zNLL8h4iWHIfQurSuUtf9yLsl1NA7/+D8u1t4Yc7mg9TPGuLMK35MwuQetUlrBJf91oU/s3FVVt0BgjxJiXn86ieV3uNmkLivq6e7GEQEcQ/7zC/yTAY4Q3B51BOgHLl+T8lqtuXb7TGC2RgHgFsP2Ap3h3+vHdqUjIx8VdjXnzb3w9+KYFQPqdVK2Oj9hH8qCAHx/0afEl+EtqW2dhgKO7uXzmC9uo+9RwpN6Zc5U+13lzrC3RtQ1AwYy3rKd1O9t4uxG3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFehnb76XfFDlV0kCeByG2sio7QL7u2m9kUrUQrds78=;
 b=VVOF/DB7zXa0jR8hVfxbVFoKVjmUJY0bUEuiUaZOZEuPuRGaSSpeVraoQ9CFVixHnLg5jzc66t1LZ7whYa5iXDxq9eO8BVQJJ2RE4B4nVDteVrujYLQhtE/APof38v42T7P0TTma+uOGyEcVfy2fFI5yBO4ozGkkOYn1NUtFCIup6UhkfPHXNVLwxdEp6KhmjVkS87Wbm+CXQe6dI1WmcdXFKa5ArrtCsaRBb2D2UkQEjpKMcQo2TiCZ2M+RvOOquas9xE9yR6BEXy5C0xcNRxXYMe5AF7C0bQQtzakh7q0Gsu4UP7E+ea9MMV67oHqbg28Ob5/j1j3wwaEuvAi/QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFehnb76XfFDlV0kCeByG2sio7QL7u2m9kUrUQrds78=;
 b=U915T7VVg/GD0Db8S/kNan/ukQIt0nF12V57bEBSApwZBST9Lium7yXDIApDMKcsRpdGhog020RuS682bGaO8QJBw/nZpSFv0hEvOk120JC0kP2wmZG8waAdkLUOpYLu/9jJTh69gHkapAo04Ub9EGdP4AWVLpbrdjqsbnmPgus=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA3PR21MB5845.namprd21.prod.outlook.com (2603:10b6:806:492::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.1; Thu, 13 Aug
 2026 01:20:57 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Thu, 13 Aug 2026
 01:20:56 +0000
From: Long Li <longli@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org"
	<leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v6 4/7] net: mana: validate
 hardware-supplied values in the HWC RX path
Thread-Topic: [EXTERNAL] Re: [PATCH net v6 4/7] net: mana: validate
 hardware-supplied values in the HWC RX path
Thread-Index: AQHdKTqPpTfr/GDmLkajaoPlngNZH7abF0GAgAAYFfA=
Date: Thu, 13 Aug 2026 01:20:56 +0000
Message-ID:
 <SA1PR21MB668398B3CE3EE9E8D8BF8E6FCEDB2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260811023823.2391255-5-longli@microsoft.com>
 <20260812234656.2193529-1-kuba@kernel.org>
In-Reply-To: <20260812234656.2193529-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fbf18ced-d1c7-4f66-ac88-95ec547ec1c0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-13T01:13:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA3PR21MB5845:EE_
x-ms-office365-filtering-correlation-id: abd6f3b0-6055-4b07-c33a-08def8d92060
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|38070700021|6133799003|3023799007|56012099006|11063799006|5023799004|4143699003|10067099003|7146999003;
x-microsoft-antispam-message-info:
 tULdKM2KwLFpkZ4f/5aA3WREK+uu96eiaCq/fq32fqUJ04PMoH2JKie6b/Wj29DMMqLXMeV9okPEpCthsRKUmhtAgfTPYXIlJeBRE2BMH50SMZN4j3JugVYtH4mocnjxKb+rS6kVvYmIgJx34cCSavCTKW/TM19nsoifeVrCJZPC4J/RT74oOAsEi2lawBsw2jbHfi5eaCtjic2RCVDQZLdPQSbSyIR+EE0R8EtkfxUqX4/LdhHx7Q+UFmxC7cKhVixBzz7zICj7mQwsAZ8IcxXYvp6YkQ7toNvXHqd9N0CYPC1/OBIXo2sqlOHxPUeOFKY/zIov05yKg1CQhujuQs3C8lZxGmqWk/rruymTm83BxmRTuyE8U5ribGH7IWB9kxMzhGSH8pbfWFbcGCcflF0Da7cTp3SoN94CmqL9mr9R/dA5EK8r83kJ46DAvDgAnb4P0KJcs2LGOs7orUJzortpv0Rznxm8HsJzADm/zjKzE1nTUhCVEkaxWvvW8rZfXQYzffsABO+O/SPkM/UICb7qdhvkJg7x+IVRT7Gk/+Fr+RC2F56hFiu8w04/reLjLIX7PxHG9148wKiUMi8RYUP0vuin3LcNawEp1+De5rBFJTEsRW2In198g+piJutydzM4BUMIM/eBft5ywsrUrVOGQ1cjbed+PQqw/VknZP0lEW5B6rqc9WYIzHdL3EBSv8yhcdnD7p1kpeJX+IzD3S9um8CHyOPCo5c5iXIZkL8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(3023799007)(56012099006)(11063799006)(5023799004)(4143699003)(10067099003)(7146999003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?VQTh1nt9jBR+55mtPtlpmr/0JWuwJzV2VOLtJhBPcK4O8zkQTsVx+z6xYm4p?=
 =?us-ascii?Q?yc6TDCArPG+my4/p20zB7kbnQf6UTMfMeLdx+Yr3lM5G8OdQ7nzkfmDQxRqf?=
 =?us-ascii?Q?FvPamEFSDjUiAO6EYx8dMNV2U43oTnacMa7HfE1Qcv6NYRW7nIgB+qe6p9rR?=
 =?us-ascii?Q?ynP2u0LTf8UKU0xRAHWDM1DdRklm/b8xj/TmeCyrtNRy0bxxEjMcvovcjIpz?=
 =?us-ascii?Q?hA8eEjvZQ/mpg/ifZgTjBxwGo7daKmVnjpniFJuczqLwCGN9iKruAcc+TwgD?=
 =?us-ascii?Q?JW87LiFUPcPVT7W4R/Q0miR7LVt7I2pjVlF0Qopga4cXkL4cB5+nfb0pHRhl?=
 =?us-ascii?Q?FdrQGQJkyDlrAA+C/EecnTU/PvsW0ytT9U6LjUWaDSg3z/wMfpsyoYQXLu+o?=
 =?us-ascii?Q?omE9t2l/D0L4cGgQNzx9Lr2giANLwbAvF+81PYLlWn5vHgYUCOSh9mX7t0w3?=
 =?us-ascii?Q?RNNhd5tyNL6LUUfwEEuc0/9Ghr2b7JXl+X98/R+bulpDeQZmtjlHltqhVH5y?=
 =?us-ascii?Q?1rVw/+zjfXqvPzNxMBTO/jWqAy1aofgf38c/583wYkuVvyaIU810JM9pcOge?=
 =?us-ascii?Q?575wLNQ5E1PR05SsSwwWzkjWNDcZPiVnQrvw1Pms2fStztECOBmLsUALoga1?=
 =?us-ascii?Q?rnYcnwBPklJha/XOHZOQTgAp7zUWBn5Nb8IWS4Ik5VdHDW0wj5YYDMFFS68I?=
 =?us-ascii?Q?+LDB6zCM2gOl5Duc4MnYL73gWORJHpASp2zRxaE4JyF7hAXBVW3Mk2RYiltL?=
 =?us-ascii?Q?a1rN8ldnDPezCRrgV2Z4uLOdTiWfzEYBBggJEzPHa6kmUbzIcZNnlCgnNbOZ?=
 =?us-ascii?Q?bt4G7oQB1h+JUKJeJJNFgxfScbxjvKWVH7VTYdzjdNYYkbbShlZTqQkX++fY?=
 =?us-ascii?Q?DN6z9BgFz8MljJW36CQC/3IV0dFyvfBnqmjiHQxivZxBT8Ig0VzP3A6giix1?=
 =?us-ascii?Q?6QmTI9i0agPmhjTrOPgUMFj++bkg+vd5xTXx5EFKPa4hI0BkRD+TD5S9bT1s?=
 =?us-ascii?Q?bxn6RkPkCuS0x8eKaXwk6Lhp108S58+MG5+EMYWoHScRJwlJvKJh5AsTqKdc?=
 =?us-ascii?Q?Fp/8HtvkLKAtCiCdEnNp6iepcjHKbFd0wuki2/kLJQpldQsP4YZB8ePN0q9X?=
 =?us-ascii?Q?7wmUjBz/vTyOsOLnN41nTZ4XlVNo5YhOCE609N+T5MVTJ/mDJHtLwoF2b4hw?=
 =?us-ascii?Q?lyYkhEPM7RmdypyLR5tdP+LYTgbq3Gst8jB1ckdfqe0m48auT3kOAUMn47pp?=
 =?us-ascii?Q?Zt2cc8KgOblIWLW5G4L7NR/YGQlTnlD62Q1od8c+0SKhbOKcSc6YpuwsAiHF?=
 =?us-ascii?Q?aIUXIiGOc7EPGPE+DcUMwB86RqKLBrDOlHE3jhVH1Ie5JB9TBqiGmBXo7ybm?=
 =?us-ascii?Q?2w+VtF7E93LoAk4xNBmtZuywMf1KoLo5Nw6KfOk+wmC5NHnHifzHl98yCsOw?=
 =?us-ascii?Q?JJH/u1UjVMGKcY8g+lT1jELyLa7YBAjM/iyCQXTsIkYnBvjGEr7f21HFUYYk?=
 =?us-ascii?Q?UIh8/Bil61dKr4qFolYjgctHveZZ0JladFoBanfZCou2PKWEMYf/UAsDMZir?=
 =?us-ascii?Q?gqMO/6+EKESxmETJa7tFUOKoDWhMKoTZmR4QOmGlMipoW+zZ1iNzS652OQZv?=
 =?us-ascii?Q?skWV+4EXr8CQCFQEj1DCsiEI+NeZqqPMNJKEybiS3BgjXRe5FRfz1yjSJN82?=
 =?us-ascii?Q?WUKdSJH73rnRefgZuu9i40rgzrqcTm3n6Jgw1aJBuA4WvD4O?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: abd6f3b0-6055-4b07-c33a-08def8d92060
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 01:20:56.7920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGLzznPDTNbzqSqITXBZheqcyeIKg3a3bil8Wpaj4A6k27wD+se/qxPPvPGEMnKkF0WDjc4Elb2wEpXQVU5u0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB5845

> This is an AI-generated review of your patch. The human sending this emai=
l has
> considered the AI review valid, or at least plausible.
> ---
> net: mana: validate hardware-supplied values in the HWC RX path
>=20
> This adds validation of device-supplied values in the HWC RX completion
> path: the inline OOB size and the SGE address are snapshotted and checked
> before use, the recovered RX slot index is bounds checked and the SGE add=
ress
> must match the one the driver posted for that slot, and an oversized resp=
onse
> length is rejected.  Untrustworthy completions no longer repost their RX =
WQE;
> those leaks are counted and, once they reach the RQ depth, the command
> timeout is shortened.
>=20
> No Link: tags are present in the commit header.
>=20
> One question about the changelog before the diff:
>=20
> [Severity: Medium]
>=20
> > A short response is no longer rejected in the handler: it reaches
> > mana_hwc_handle_resp(), whose mana_hwc_verify_resp_msg() fails it with
> > -EPROTO and completes the waiting sender, so a single malformed
> > response cannot convert into a channel-wide timeout.
>=20
> Is this paragraph describing a change against the kernel tree, or against=
 an
> earlier revision of the patch?  In the parent commit,
> mana_hwc_rx_event_handler() has no response-length check between
>=20
> 	resp =3D (struct gdma_resp_hdr *)rx_req->buf_va;
>=20
> and the msg_id read, and this diff does not remove such a check, so there=
 is no
> short-response rejection in the handler being relaxed here.
>=20
> Does the stated guarantee hold in the resulting code?  hwc_msg_id sits at
> bytes 10-11 of struct gdma_msg_hdr:
>=20
> include/net/mana/gdma.h:
> struct gdma_msg_hdr {
> 	u32 hdr_type;
> 	u32 msg_type;
> 	u16 msg_version;
> 	u16 hwc_msg_id;
> 	u32 msg_size;
> };
>=20
> A response shorter than 12 bytes therefore does not contain the field the
> handler reads.  If the bytes read there are out of range, the handler ret=
urns
> early and mana_hwc_verify_resp_msg() is never reached, so no sender is
> completed.  Could the paragraph be reworded to describe what the code
> actually guarantees?

You're right -- a <12-byte response has no hwc_msg_id, so the handler retur=
ns early at the msg_id bound check and never reaches mana_hwc_verify_resp_m=
sg(). That paragraph is dropped in v7; the changelog no longer claims a sho=
rt response is handled downstream.

>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > index 19896bb5ce1a4..5db8cfe2d8443 100644
> > --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > @@ -83,6 +83,19 @@ static void mana_hwc_handle_resp(struct
> hw_channel_context *hwc, u32 resp_len,
> >  	struct hwc_caller_ctx *ctx;
> >  	int err;
> >
> > +	/* Defence in depth: the sole caller, mana_hwc_rx_event_handler(),
> > +	 * already rejects msg_id >=3D hwc->num_inflight_msg with the value i=
t
> > +	 * passes here by value, so this cannot be reached out of range.  Kee=
p
> > +	 * the guard at the indexing site so the bitmap and caller_ctx array
> > +	 * are never indexed without a bound in view.
> > +	 */
> > +	if (msg_id >=3D hwc->num_inflight_msg) {
> > +		dev_err(hwc->dev, "hwc_rx: msg_id %u >=3D max %u\n",
> > +			msg_id, hwc->num_inflight_msg);
> > +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> > +		return;
> > +	}
> > +
> >  	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
> >  		dev_err(hwc->dev, "hwc_rx: invalid msg_id =3D %u\n", msg_id);
> >  		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
>=20
> [Severity: High]
>=20
> This isn't a bug introduced by this patch, but while the msg_id guard is =
being
> added here, is the bare test_bit() on hwc->inflight_msg_res.map enough to
> own the slot?  At this commit the bit is tested without inflight_msg_res.=
lock,
> and mana_hwc_send_request() releases the slot on its timeout path:
>=20
> out:
> 	mana_hwc_put_msg_index(hwc, msg_id);
> 	return err;
>=20
> so a late or replayed response can find the bit set again for a reused sl=
ot and
> then write through the previous caller's output_buf:
>=20
> 	ctx =3D hwc->caller_ctx + msg_id;
> 	...
> 	memcpy(ctx->output_buf, resp_msg, resp_len);
>=20
> The new mana_hwc_rx_leak_wqe() latch below makes the abandon-and-reuse
> path much easier to reach.  For completeness: this race is closed later i=
n the
> same series by "net: mana: fix stale HWC response after command timeout",
> which adds per-slot lock, refcount and responded state and NULLs output_b=
uf
> under the lock on timeout, so no change is needed here if the ordering of=
 the
> series is kept.

Agreed, and thanks for confirming the fix. The stale-response patch adds a =
per-slot lock, a refcount and a "responded" flag, and NULLs output_buf unde=
r the lock on timeout, so the reuse race is closed in the final tree. No ch=
ange here.

>=20
> [ ... ]
>=20
> > @@ -237,18 +262,39 @@ static void mana_hwc_init_event_handler(void
> *ctx, struct gdma_queue *q_self,
> >  	}
> >  }
> >
> > +/* An RX WQE whose SGE the handler cannot trust is deliberately not
> > + * reposted: reposting a slot we may have mis-identified could
> > +double-post
> > + * a buffer the device still owns.  Each such leak permanently lowers
> > +the
> > + * RQ's posted depth, so once the whole depth is gone the channel can
> > +no
> > + * longer receive responses.  Make that terminal state explicit --
> > +log it
> > + * once and shorten the command timeout so callers fail fast --
> > +rather than
> > + * letting every later command drain its full timeout against a dead R=
Q.
> > + */
> > +static void mana_hwc_rx_leak_wqe(struct hw_channel_context *hwc) {
> > +	if (++hwc->rx_leaked_wqe =3D=3D hwc->rxq->queue_depth) {
> > +		dev_err(hwc->dev,
> > +			"HWC RX: RQ exhausted after %u leaked WQEs;
> channel unusable\n",
> > +			hwc->rx_leaked_wqe);
> > +		hwc->hwc_timeout =3D 1;
> > +	}
> > +}
>=20
> [Severity: High]
>=20
> Is hwc->rxq->queue_depth ever greater than 1 here?  The header defines:
>=20
> include/net/mana/hw_channel.h:
> #define HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH 1
>=20
> and that is the only depth used:
>=20
> mana_hwc_create_channel()
>   mana_hwc_init_queues(hwc,
> HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH, ...)
>     mana_hwc_create_wq(..., q_depth, ...)
>       hwc_wq->queue_depth =3D q_depth;
>=20
> If so, ++hwc->rx_leaked_wqe =3D=3D hwc->rxq->queue_depth is true on the f=
irst
> call and hwc->hwc_timeout =3D 1 is latched immediately.
>=20
> Does that mean one single unattributable completion, from any of the thre=
e
> new early returns, permanently reduces every later HWC command to
>=20
> 	wait_for_completion_timeout(&ctx->comp_event,
> 				    msecs_to_jiffies(hwc->hwc_timeout))
>=20
> with hwc_timeout =3D=3D 1, returning -ETIMEDOUT?  The inputs that decide =
those
> returns (rx_oob->wqe_offset, the WQE flags word, sge->address) all come
> from the device-writable memory this patch treats as untrusted, and none =
of
> the three paths establishes that a posted WQE was actually consumed, so a
> single forged or stale completion would appear to disable vport configura=
tion,
> queries, RDMA setup and teardown for the life of the device.

Disagree.

Depth is 1 today, so yes, one un-attributable completion latches it. That i=
s intended: the three paths leak the WQE rather than repost it, and at dept=
h 1 the RQ then has no posted buffer, so it genuinely cannot receive anothe=
r response -- shortening the timeout just makes later commands fail fast ag=
ainst a dead RQ instead of each draining the full timeout. The alternative,=
 reposting a WQE we could not attribute, is worse: it could double-post a b=
uffer the device still owns.

>=20
> [Severity: High]
>=20
> This isn't a bug introduced by this patch, but does the new interrupt-con=
text
> path make the following teardown behaviour reachable from device input?
> Once hwc_timeout is 1, mana_gd_destroy_queue() still frees the memory
> whether or not the destroy-region command succeeded:
>=20
> drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue
> () {
> 	...
> 	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
> 	mana_gd_free_memory(gmi);
> 	kfree(queue);
> }
>=20
> mana_gd_destroy_dma_region() is itself an HWC command, so with the
> timeout latched every unbind frees DMA regions whose device-side mappings
> were never torn down.  mana_hwc_send_request() already collapses
> hwc_timeout to
> 1 after a genuine timeout, and this error return has always been ignored,=
 but
> previously that state required a real hardware stall and a failing comman=
d in the
> log.  Should the leak accounting request a service reset instead of silen=
tly
> forcing the fail-fast timeout from an interrupt?

Disagree.

mana_gd_destroy_queue() freeing the region regardless of the command result=
 is pre-existing and independent of this patch, so I'd keep it out of this =
series. Requesting a service reset from hardirq is a heavier, separate desi=
gn choice; the fail-fast timeout is the minimal response to a permanently-e=
xhausted RQ. There are other reset mechanism used by the driver.

>=20
> [Severity: Medium]
>=20
> Is hwc_timeout a safe place to record this terminal state?  The field has=
 other
> writers, and a host-supplied reconfig event overwrites it:
>=20
> drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_init_event_h
> andler() {
> 	...
> 	case HWC_DATA_CFG_HWC_TIMEOUT:
> 		hwc->hwc_timeout =3D val;
> 	...
> }
>=20
> Because the leak helper tests with =3D=3D rather than >=3D, the shortenin=
g can never
> be applied a second time, so after such an event every later command drai=
ns its
> full timeout against a dead RQ again, which is the behaviour the comment
> above the helper says it avoids.
>=20
> In the other direction, the store is unconditional, unlike the existing g=
uard in
> mana_hwc_send_request():
>=20
> 		if (hwc->hwc_timeout > 1)
> 			hwc->hwc_timeout =3D 1;
>=20
> so it can raise hwc_timeout from the 0 sentinel that mana_serv_reset()
> sets:
>=20
> 	/* HWC is not responding in this case, so don't wait */
> 	hwc->hwc_timeout =3D 0;
>=20
> which mana_need_log() also consumes:
>=20
> 	if (hwc && hwc->hwc_timeout =3D=3D 0)
> 		return false;
>=20
> Would a separate sticky flag (and hwc->rx_leaked_wqe being reset when the
> channel is re-established) express this state better?  As it stands rx_le=
aked_wqe
> is never reset and no recovery is requested.

Disagree.

The harmful direction -- resurrecting the serv_reset() 0 sentinel -- is gua=
rded in v7: the store is "if (hwc->hwc_timeout > 1) hwc->hwc_timeout =3D 1;=
", matching mana_hwc_send_request(). The =3D=3D vs >=3D and the reconfig ov=
erwrite are benign for what is a terminal state, so I'd rather not add a se=
parate sticky field for it.

>=20
> [Severity: Medium]
>=20
> Should this store be annotated?  mana_hwc_rx_leak_wqe() runs in HWC
> interrupt context:
>=20
> mana_gd_intr() -> EQ handler -> mana_hwc_comp_event()
>   -> mana_hwc_rx_event_handler() -> mana_hwc_rx_leak_wqe()
>=20
> while the same field is read and read-modify-written from process context=
 with
> plain accesses in mana_hwc_send_request(), written by
> mana_gd_query_hwc_timeout() through a request/response round trip, read
> unlocked by mana_need_log() and used as a 0 sentinel by mana_serv_reset()=
.
> There is no common lock and no READ_ONCE()/WRITE_ONCE() here, so the
> process-context update can be lost and the 0 sentinel can be resurrected =
to 1
> mid-reset.  A structurally identical field in the same series,
> hwc_init_max_num_cqs, is annotated with WRITE_ONCE()/READ_ONCE() and
> a comment; was the omission here intentional?

Fix in v7.

>=20
> > +
> >  static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
> >  				      const struct hwc_rx_oob *rx_oob)  {
>=20
> [ ... ]
>=20
> > @@ -259,28 +305,76 @@ static void mana_hwc_rx_event_handler(void *ctx,
> u32 gdma_rxq_id,
> >  	wqe =3D mana_gd_get_wqe_ptr(rq, rx_oob->wqe_offset /
> GDMA_WQE_BU_SIZE);
> >  	dma_oob =3D (struct gdma_wqe *)wqe;
> >
> > -	sge =3D (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 *
> 4);
> > -
> > -	/* Select the RX work request for virtual address and for reposting. =
*/
> > +	/* inline_oob_size_div4 lives in device-accessible RQ memory (shared
> > +	 * and host-writable in a confidential VM), so snapshot it once and
> > +	 * validate and use only the snapshot.  It is a bit-field, which
> > +	 * READ_ONCE() cannot take the size of, so read the u32 flags word it
> > +	 * shares through the union and extract the field from the local copy=
.
> > +	 * The driver programs INLINE_OOB_SMALL_SIZE for every HWC RQ
> WQE via
> > +	 * mana_gd_post_work_request(), so the only valid value is
> > +	 * INLINE_OOB_SMALL_SIZE / 4, which puts the SGE at wqe + 16 inside
> > +	 * this WQE's own BU.  Reject anything else -- the slot cannot be
> > +	 * trusted, so leak this RX WQE rather than repost the wrong one.
> > +	 */
> > +	oob_snapshot.flags =3D READ_ONCE(dma_oob->flags);
> > +	oob_div4 =3D oob_snapshot.inline_oob_size_div4;
> > +	if (oob_div4 !=3D INLINE_OOB_SMALL_SIZE / 4) {
> > +		dev_err(hwc->dev, "HWC RX: unexpected
> inline_oob_size_div4=3D%u\n",
> > +			oob_div4);
> > +		mana_hwc_rx_leak_wqe(hwc);
> > +		return;
> > +	}
> > +	sge =3D (struct gdma_sge *)(wqe + 8 + oob_div4 * 4);
> > +
> > +	/* Recover the originating RX slot from the SGE address.  Snapshot it
> > +	 * once, for the same shared-memory reason: of the three terms only
> > +	 * sge_addr comes from device memory; rq_base_addr and
> > +	 * max_resp_msg_size are driver-private.  An in-range but wrong SGE
> > +	 * would otherwise truncate onto a neighbouring slot, letting us read
> > +	 * a stale response that could complete the wrong, reused in-flight
> > +	 * request.  Require the index in range AND the address to exactly
> > +	 * match the value the driver posted for that slot.
> > +	 */
> > +	sge_addr =3D READ_ONCE(sge->address);
> >  	rq_base_addr =3D hwc_rxq->msg_buf->mem_info.dma_handle;
> > -	rx_req_idx =3D (sge->address - rq_base_addr) / hwc-
> >max_resp_msg_size;
> > -
> > -	if (rx_req_idx >=3D hwc_rxq->msg_buf->num_reqs) {
> > -		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=3D%llu,
> num_reqs=3D%u\n",
> > -			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
> > +	rx_req_idx =3D (sge_addr - rq_base_addr) / hwc->max_resp_msg_size;
> > +
> > +	if (rx_req_idx >=3D hwc_rxq->queue_depth) {
> > +		/* Cannot identify the slot, so we cannot safely repost this
> > +		 * WQE; leak it.  An out-of-range index means a corrupted SGE
> > +		 * from hardware or host tampering.
> > +		 */
> > +		dev_err(hwc->dev, "HWC RX: SGE idx %llu out of range\n",
> > +			rx_req_idx);
> > +		mana_hwc_rx_leak_wqe(hwc);
> >  		return;
> >  	}
>=20
> [Severity: Low]
>=20
> Why was the bound changed from the array's own counter to a field of a
> different structure?  The index is used immediately afterwards to index
> hwc_rxq->msg_buf->reqs[], which is declared as:
>=20
> include/net/mana/hw_channel.h:
> 	u32 num_reqs;
> 	struct hwc_work_request reqs[] __counted_by(num_reqs);
>=20
> so num_reqs is the annotated bound for that array, while queue_depth is a
> u16 in struct hwc_wq.  The two are equal only by construction:
> mana_hwc_create_wq() sets hwc_wq->queue_depth =3D q_depth and
> separately calls mana_hwc_alloc_dma_buf(hwc, q_depth, ...), which allocat=
es
> reqs[q_depth] and sets dma_buf->num_reqs =3D q_depth.  Nothing ties them
> together, num_reqs becomes write-only in this file, and the change isn't
> mentioned in the changelog even though every other added validation is.
> Would keeping the check against msg_buf->num_reqs (and keeping num_reqs
> in the error message) be preferable?

Yes -- fixed in v7. The bound is back to hwc_rxq->msg_buf->num_reqs (the __=
counted_by bound for reqs[]), and num_reqs is in the error message.

>=20
> >
> >  	rx_req =3D &hwc_rxq->msg_buf->reqs[rx_req_idx];
> > +	if (sge_addr !=3D (u64)rx_req->buf_sge_addr) {
> > +		/* In-range index but the address does not match what the
> > +		 * driver posted for that slot; the same unrecoverable case,
> > +		 * so leak this WQE rather than repost the wrong one.
> > +		 */
> > +		dev_err(hwc->dev, "HWC RX: invalid SGE address %llx
> (idx=3D%llu)\n",
> > +			sge_addr, rx_req_idx);
> > +		mana_hwc_rx_leak_wqe(hwc);
> > +		return;
> > +	}
> > +
>=20
> [Severity: Medium]
>=20
> This isn't a problem introduced by this patch, but does the address match
> establish the invariant the helper's comment relies on ("reposting a slot=
 we
> may have mis-identified could double-post a buffer the device still owns"=
)?
> The check only shows that the WQE named by the device-supplied completion
> offset still contains the OOB size and SGE address the driver once wrote =
there,
> and that offset is masked into the ring rather than
> rejected:
>=20
> drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_get_wqe_ptr()
> {
> 	u32 offset =3D (wqe_offset * GDMA_WQE_BU_SIZE) & (wq->queue_size -
> 1);
>=20
> 	WARN_ON_ONCE((offset + GDMA_WQE_BU_SIZE) > wq->queue_size);
> 	...
> }
>=20
> RQ WQE memory keeps those driver-written values after the device consumes
> the WQE, and mana_hwc_comp_event() dispatches on completions[i].is_sq
> alone, without looking at rx_oob->vendor_err or eom, so a spurious, error=
 or
> replayed completion naming a still-owned slot passes both new checks and
> gets reposted.  The HWC RQ is created with spec.monitor_avl_buf =3D false=
, so
> mana_gd_post_work_request() does no free-space check and
> wq->head simply advances past the number of buffers the driver owns.  Is
> some per-slot posted/consumed state needed for the address match to mean
> "this WQE was just consumed for this buffer"?
>=20
> >  	resp =3D (struct gdma_resp_hdr *)rx_req->buf_va;
> >
> > -	/* Read msg_id once from DMA buffer to prevent TOCTOU:
> > -	 * DMA memory is shared/unencrypted in CVMs - host can
> > -	 * modify it between reads.
> > +	/* Read msg_id once from the DMA buffer to prevent TOCTOU: DMA
> memory
> > +	 * is shared/unencrypted in CVMs, so the host can modify it between
> > +	 * reads.  A short response is not rejected here; it is handed to
> > +	 * mana_hwc_handle_resp() below, whose
> mana_hwc_verify_resp_msg()
> > +	 * fails it with -EPROTO and completes the waiting sender, so one
> > +	 * malformed response cannot stall the whole channel.
> >  	 */
> >  	msg_id =3D READ_ONCE(resp->response.hwc_msg_id);
> >  	if (msg_id >=3D hwc->num_inflight_msg) {
> >  		dev_err(hwc->dev, "HWC RX: wrong msg_id=3D%u\n", msg_id);
> > +		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
> >  		return;
> >  	}
>=20
> [Severity: Low]
>=20
> Should these messages be rate limited?  All four rejection paths in this =
handler
> use plain dev_err() from hardirq context with device-supplied values
> ("unexpected inline_oob_size_div4=3D%u", "SGE idx %llu out of range", "in=
valid
> SGE address %llx (idx=3D%llu)", "wrong msg_id=3D%u").  This path previous=
ly
> returned without reposting, which bounded how often a host could drive it=
;
> with the added mana_hwc_post_rx_wqe() a host that keeps fabricating
> completions can repeat it indefinitely and flood the log, which is unplea=
sant
> with a serial console.  dev_err_ratelimited(), or the counter scheme used=
 for
> the leak accounting, would avoid that.

Good point -- fixed in v7. The reposting paths (wrong msg_id, and the msg_i=
d/resp_len rejections in mana_hwc_handle_resp()) now use dev_err_ratelimite=
d(), so a host can't flood the log. The three leak paths don't repost and a=
re bounded by the RQ depth, so they keep a single dev_err().

Thanks,
Long
