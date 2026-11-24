Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.53.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795549202;
	b=N8d8Pq2eFFwu/Lw9yfzpkYzhclgJw3lTraSOv0gqblPUNMFbUj2kWifCDC/l1qCEpTRu
	 uIOSqiRly3M9bYLnrqSwcTPU34y80wgskYeaPhvtBL+0Mql+3uUpVtb2zNSMF9NFjVJV0
	 lCZdL/pEsqsJ3Ow2W428d/DxV+CQclf64Xkax+rpfFdprmquoBAlvCa2O7TYMbu28ZrIC
	 6sjBHkppEfVuHHGKS1EelomU+an5B/mHfe7vorfuKDwTP/I8gw8ewTAm7FwNmtOjJ6rAD
	 Hgzo8PYP24o9pxqjYtWCiejLeuRHJ4k7MyxBpZ6PNOz45+ZVnlv/4VP7m0fPivRkdxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549202;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=aLnnGyD6E5mZ1bokin0sEtZ/yW7QuAVR9FEsODQLLrw=;
	b=k9hCLtUGjXa+18bBylpk1tE1Pldof0m5hvvUNVyxqTSh8LMt7QVQf0HID10bid6KO/yH
	 2u1hsy3hoFbUn2p6zrUM8VsCJnF9kqd9UunVj4I7r2XTiy8ppFgfqveUWhvMCs2E+5+n/
	 D5b4sTJpacRpasNnJ3jglFN4H4YUZokyNgS78zcRja+xniBhA5iq+zE3hXyf6J4PeUhrG
	 B/iWFxFTHAlRSNYMMxUuCq54Gq0FaJzO4acfFRuKxynQQAHuUvxCXCyFwPTAJPpjaMnBd
	 vbg3zmvJQXddVvCLqwfLo9AVPlPXUpuJ373Nx3xMC36SOPTq2PJQEn1JlU6JIg57tPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hotmail.com;
	spf=pass smtp.mailfrom=hotmail.com;
	dkim=pass header.d=hotmail.com header.i=@hotmail.com header.a=rsa-sha256 header.s=selector1 header.b=trpkLIsj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.53.20
Received: from WA1P291CU004.outbound.protection.outlook.com (mail-polandcentralazolkn19010020.outbound.protection.outlook.com [52.103.53.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD67606A32E;
	Tue, 24 Nov 2026 19:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBD67606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hotmail.com header.i=@hotmail.com header.a=rsa-sha256 header.s=selector1 header.b=trpkLIsj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQU96bnE3WytL6GLRYuh68A1axL1doQN9CNmVVgeex16q4efoanhm98upxb4Xz05WZVhCJUdBIofRvLA+f+7ulax/TkCYBFsMqUCt6inUF0GN9Tjw8kgkBRY5v+FDSz2t5TOWwLtgY/zk9bcx+Xs+oYEw4CbILUx61muUe8T+C4bUvvDwI5N9+FNkTW5/elZJBFh/7wxAvMsnPfhGiDaYj1xjaug7UJ+k3T/zl+G97KPQZu3XATzUwLGWnJU3GnuJHuQBTtDIrYF1svZxrdVGBWf3GAUWj4J3D+01DlJpeUtiYMxFFt7w9tMFpmpMUGCUTBCuRo3ogHfi93TcKo4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLnnGyD6E5mZ1bokin0sEtZ/yW7QuAVR9FEsODQLLrw=;
 b=KJQUSRNowelE9NrKYQthz7ggjXuuPC24P8BdppAOorvYsoz3nRvQp5YABM53NlZmwGx1qnVbZbEhp5uG2j876QGp316S8QpFaA0+/5/Zlu3oObBBKultFMXCHjncYysQphtnajzRp5qD6EQnhT2iq4+ZmGWgOEYEKzunol0TewMSD1hLCO0FAdZFYRYXqUFw3iUfozKQsxqlsTnT69Zqtz7gdEpzOS3erw7Hkz+mA+oFIy95KvjsaPLnzwN5HlCqaMBEd2WrRZxwjo1cgUURBu2d/mWeqs12Wh96/Ya+lX5HYdCyU+9JXYAfTUcCccxvgoGSWW/tMwfTmfhnvWRX4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLnnGyD6E5mZ1bokin0sEtZ/yW7QuAVR9FEsODQLLrw=;
 b=trpkLIsjxqrTVl148+2P8Z5V6TMOwlc65m40sVosQS0pwzhgSQ8LVzAT0rJJmLlvbHyYvh/f0Jl0PQw3E4C/wxAKw+MdO6X3mIcmgTlGC/VlBm5aNf7fh2Oa/kudLlQqRnDQoKrciZ+RuobLlqWM0Lh0p8Z3+31d67yUEu3HKDdK8w7CXXE0+gP6sUMQs3mK2cMBFyKMC0TTOxhJXlETSwO4oxByX9vGeovYCyl1tHRrvJAnPibrqOijuG0fuptoTw5VQbIzRRjbZoTU0VxCkzuWHqif/w0Id3BFikc3+EVu/jdTO9hRKTLPak+LBcS7BhK+bYvf7JciFGegGvf+wA==
Received: from WA0P291MB0172.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d0:e::6) by
 WA2P291MB0239.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d0:22::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.6; Tue, 24 Nov 2026 19:39:58 +0000
Received: from WA0P291MB0172.POLP291.PROD.OUTLOOK.COM
 ([fe80::1957:c071:8204:8322]) by WA0P291MB0172.POLP291.PROD.OUTLOOK.COM
 ([fe80::1957:c071:8204:8322%7]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 19:39:58 +0000
From: =?utf-8?B?SGFiaWwgRXJlbiBUw7xya2Vy?= <habilerenturker@hotmail.com>
To: =?utf-8?B?SGFiaWwgRXJlbiBUw7xya2Vy?= <habilerenturker@hotmail.com>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, "jiri@resnulli.us" <jiri@resnulli.us>,
	"leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "parav@nvidia.com" <parav@nvidia.com>,
	"syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com"
	<syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com>
Subject: [PATCH] RDMA/core: Fix slab-use-after-free in kernfs_find_ns()
Thread-Topic: [PATCH] RDMA/core: Fix slab-use-after-free in kernfs_find_ns()
Thread-Index: AQHdfDFk7AhQU1eyo0uyOMuSroWd1rc9nrWA
Date: Tue, 24 Nov 2026 19:39:58 +0000
Message-ID: <20261124193956.62075-1-habilerenturker@hotmail.com>
References: <20261124163151.50468-2-habilerenturker@hotmail.com>
In-Reply-To: <20261124163151.50468-2-habilerenturker@hotmail.com>
Accept-Language: tr-TR, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: WA0P291MB0172:EE_|WA2P291MB0239:EE_
x-ms-office365-filtering-correlation-id: bcce5806-1aac-4684-67b9-08df4a62b94f
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|15080799012|55001999006|24021099003|25010399006|51005399006|19110799012|8062599012|38102599003|31061999003|440099028|3412199025|102099032|12091999003|11031999003|40105399003|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?NXgvOEtybHBQZTZwanNlZjkwaUtJbVUyTXZKRkh5cWp2b2tuZTJ6UXRmaEhK?=
 =?utf-8?B?U3J1Zll0dW5MWS9LTGkyenhldk82QkRobTJuVWFIZE0vSndpdXo4STJ0bERz?=
 =?utf-8?B?akRFcDkzUng2N3JHVUhhMXl5RmJBOWZOREYwd0c5SnArNVF0LzlNV0dFK0F2?=
 =?utf-8?B?akt4SWNwNGFCRkpERHVTeGR5aEE4QWZjRXIyUGxFdFVoeURvTDVJSlFwSnI2?=
 =?utf-8?B?Y2N4d2pLM3JsdUYvYVRQWXlFWmZtbXlVang2NTRNTElhbmlDNGJJUSttOHVM?=
 =?utf-8?B?bTNLcGI0VTJ5eFVSdyt3czNEQjY4bTV0cEg5NWxKYXUxVWJObE11Q3JXSHpQ?=
 =?utf-8?B?OGl4UTdKRG1na3FNVTM3ZUM3NU9ONjh4NDRoTWtSZUQzRU9Gb0xqUmZ5V0hL?=
 =?utf-8?B?WVhkazdwVGUxbmdpZHhyc2d2MjVzL1NWT0ZEd0ZGN21SeEp3czFKRFkvSHdY?=
 =?utf-8?B?ZndwTm55Tzh0VjFldExjaEhsRGRjUVFCalZ2Y1BhWFJud0pwa0RML2NqL2p0?=
 =?utf-8?B?NEFNWXI5b0gxWnAxS0g4eXFKd3Yvd3RQK05GdGJnZHIvSlpyd1g3QnF6Rzho?=
 =?utf-8?B?T2Q4WXFXTUhIU28yV1hDb2FmK1ZFbVRBdEFVRE1mbHBjNkkyalNMdTQzNjMy?=
 =?utf-8?B?S3pvT1dQMVRzWlRBYVc5R1FVYnpyYmtnYWFsOWRId1VvVWpjNTZ0MGFQNmU1?=
 =?utf-8?B?YXdxc3pzWjFub29CdVA0ZnlDQ3lQK3pQTmE1RWFBaTZUbTBWakk4YVYwYVpG?=
 =?utf-8?B?MTFaNUpUSlJ1eVNQZG1LanY0TTNJZkZUNXF4SUFOWi9oQ0RSVDdUN3pnSXF3?=
 =?utf-8?B?NHluNncrRFI2YWhsM1JGRUl1dUhzWm1XUEkvVU5oUExHNzQwdmlBU0N1dFUz?=
 =?utf-8?B?YmhJQTBtOXR6MG9wZXRpNjJGdGU4VEVzdk9aWUtYbU1WTjlKS0Z3WG9LKytH?=
 =?utf-8?B?NUsvKzYvYzJrbEM2d04yOVJ2L1BzTkFXTyt5YlVsTndGdnE5ZnFMRGpobFZP?=
 =?utf-8?B?U2ZUdmcrVVNqN2tvNEgrbnRxRG9IakpETk52bkRZb2h0RXlsakJSWFh4S2J2?=
 =?utf-8?B?MThyV2JZWVl6UjIxbjY5cUQwVThzRS9VdzJQS0JwMHlscVRoek9KV2prenlt?=
 =?utf-8?B?R0xLaFlXYUppM0dERGIxV2hocUcyZGNsMHovR2prT05vWk9NM0JuWXk5MmRn?=
 =?utf-8?B?Si9xZVdoTnY1V0pETEd1OU5ackFORUU3TWhsNXFCRnZ1bEQ3NFdNOGZVa0dh?=
 =?utf-8?B?YzhQK3ZVL1RvY0FJUWVucjNscTN2WXRxekJ2WVIwS0Zoc21UbXVNUFhGL0dw?=
 =?utf-8?B?eStYYU1DalU3VWh0dzhmaGFQZ3R2SVJuNHdEWWNNRk85Wm5scmkyVC9HY3dx?=
 =?utf-8?B?TjkrRllFa09PVTFJdG9vVmEvWWR3TzR5dHJuQ2RPVVA2UXNtZHR5RjRFRHo5?=
 =?utf-8?B?VmNiMnltSkpodXZOTzJRamhESXFNSFZrSll3eTR0eDRWc01FMlczbVlmTzBq?=
 =?utf-8?Q?sUVMto=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkUxNHlVVSt2MzE0bTdnbnZVWVVUMUJ3aFhTQ05ocjNnZFQrc1FxSWUzY2hD?=
 =?utf-8?B?UDRpU2gyY2pDN0dRS1kzcFBwTVNDSHd3cXBYamtHRUkrYkcrZ2ZMREhLM0s3?=
 =?utf-8?B?dmU3VGNaWEc5ckVqYkRmTVVDS3FvSWs3QUhDeXdkTHB2RDdSeEZ0a3F6ZkVx?=
 =?utf-8?B?UXhnTzhORTd3SDM4VnNqWVFOUExMN1Y2UmRneXVNY1gwVG1SZTc3YWNaV0dq?=
 =?utf-8?B?T21tRGF1NHpReSt5RnRwYmVNUUp6VXRCdW80aHpuY1hEaW9raUZpcVdVcllZ?=
 =?utf-8?B?a1NKdDVTSzFDY2pRWjE2MTlNL3RWTy85MHdxNXBRc202ZnVTeXFDZXFLbmtT?=
 =?utf-8?B?MDdPTnRTaGRxQ2liUmlDWDdRWjJra0labHlMa3VOa3pIQXBDWWsyZ1FWbjdJ?=
 =?utf-8?B?eTM1cVFFK2E1cVRUN3Y4ZG05dklyaFpuZjdGR2lLVndiZWxqek10L3VyUWtY?=
 =?utf-8?B?SnRiYU4xRURTYmNCUzBvZjRJM0I2ZTNCY2EyeHBQeU9mV3N2ZWVaQUw5REhN?=
 =?utf-8?B?ejlBeHN5a0pvU1NLSWFHa2ZSSHNxTzJFdjR4cEl5RmxXRzZTNTlTUG5qdTht?=
 =?utf-8?B?Y1BHRU9iUVl2TUNKQmhaVzZNTitGd1BkUFdkbFdjUytDY24wY2JqR1BnMkov?=
 =?utf-8?B?b1o3ZWhLZ0x2MTBMeVM0dHlXLzlsZ2ZPQ2s1Z2pXQnFFSk5qeXZGQTNxRU00?=
 =?utf-8?B?MWRCMlJmdHFtUCtwTjB2YlpQeExDOG0wUW1Rd3U4Sm11SDBjU2J4cVF2NHhH?=
 =?utf-8?B?M05zeTN4OWpuQnY4Rm9nWjhpcWFOM0x5R2NlK3lnaVpOWFBLUzVsT0RRSWlG?=
 =?utf-8?B?d0MxbVllYlpZZDhZeVBYU1NOUnUzdUtLbzIwVjEyMW5mdXppdStGMWYrNXE1?=
 =?utf-8?B?dldBTnBJMmtRQ215SytxMnQ4WVJPYjFhQVFtVkRZWVBnMzN2OEFqVjhLUThl?=
 =?utf-8?B?aEJWM0tMNW96dTQ2V01ERURqaEdMOHVhUHFzZUEyanF2bkdzVkVnK0tiSEFT?=
 =?utf-8?B?RnZhMXRHRGhaby8raDJyOTZVei9makNYaVF4ck15RXU5NUJwbkNmWkdoZ01T?=
 =?utf-8?B?UGNVV3RrU1E5aHloaG02ckxxbGRadG1EeHZ6WnhJTVVjc3NKUDQwQnlNUWxt?=
 =?utf-8?B?NDR1UG0yT2VwZmIwQmRnc3AvKzIyVzhNeDY3T2ZodjY1WE9DcUM2cFVnY2Rl?=
 =?utf-8?B?OER6ZVRRTllnaHR3RG5QL0FBeXRtb2Exc0ZEMjd6MU5LVDhibVM4L0hIRVNh?=
 =?utf-8?B?LzZUb01aRHR4aklHTEVTbERlVlI2R1NQMWhMbGxZYU8xcnhwZCtXNkM1VjFj?=
 =?utf-8?B?SW52eGZXbzIydjBCZGovSnE2QzdiSktqK3VKcmZ6empwcG1Bd0VyanJmbHBw?=
 =?utf-8?B?Q0xXZTZpRmdkdktsWmFhS3pONytNS1YrMW9Yb0J0dndEQ1cwaFAybVJ4TGVw?=
 =?utf-8?B?L29nWVJ4bWp6dTRJaWJIemk2dGM5R2pKblNRZlJrbDR6N3FJTDMzQTJiWktE?=
 =?utf-8?B?ekRXY3RNc0VvMGVuZXNrZmZueHpvcXEweTJKempiVEFuUUR2d2xtUm1Kamg1?=
 =?utf-8?B?TUxkakJ5Si8wUXdENWhYcnJBVTJ0alRHQ1o5YVZ1Z2JEendqeGtUZjU2RThl?=
 =?utf-8?B?SVJsYmNsNjdoM0E5MVlQRWswc0NwRXhvRyt5aWZ1cFQ2eU8weTRNQ0poOFNt?=
 =?utf-8?B?WEI0cTRPcDhpV01iV1RhVFluRTBkaUxJdXl5YXU3NjJYMkVWbktpdFBXN3FQ?=
 =?utf-8?B?alhpM1FUU3BNdlJFSXFXNG5IS3dHcWJMY3lTWG93T3pvTlgyNnJaRVpJT3JH?=
 =?utf-8?B?emhPeUZNckZRQnhOdVpKZDdRbFN0YTNHRGdlQmN3SElWbGpVajZtaEMzMHdo?=
 =?utf-8?Q?84X/SqnHFKkQk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A5DDE2035315C4BA3A9A00C820958AA@POLP291.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-2112e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: WA0P291MB0172.POLP291.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: bcce5806-1aac-4684-67b9-08df4a62b94f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 19:39:58.5254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: WA2P291MB0239

SGksCgpUZXN0ZWQgd2l0aCBDT05GSUdfS0FTQU49eSwgQ09ORklHX1BST1ZFX0xPQ0tJTkc9eSwg
Q09ORklHX0xPQ0tERVA9eQphbmQgQ09ORklHX1JETUFfUlhFPXkgb24gUUVNVSB3aXRoIC1zbXAg
NCwgdXNpbmcgdGhlIHN5emJvdCByZXByb2R1Y2VyLgoKV2l0aG91dCB0aGUgcGF0Y2ggKHByZS1j
NDFkNTc3YWM1MjUpLCB0aGUgcmVwcm9kdWNlciByZWxpYWJseSB0cmlnZ2VycwphIEtBU0FOIHNs
YWItdXNlLWFmdGVyLWZyZWUgaW4gdGhlIGRldmljZV9kZWwoKSBwYXRoIChvYnNlcnZlZCBpbgpr
b2JqZWN0X3VldmVudF9lbnYsIHJlYWRpbmcgYSB1ZXZlbnRfbmV0IHRoYXQgd2FzIGZyZWVkIGJ5
IGNsZWFudXBfbmV0CmluIGEgcmFjaW5nIG5ldG5zIHRlYXJkb3duKS4KCldpdGggdGhlIHBhdGNo
IGFwcGxpZWQsIHRoZSBzYW1lIHJlcHJvZHVjZXIgb3ZlciAxMCBpdGVyYXRpb25zIG9mIHRoZQpy
eGUwIGFkZC9kZWwgKyBuZXRucyB0ZWFyZG93biByYWNlIHNob3dzIG5vIEtBU0FOIHNwbGF0IGFu
ZCBubyBsb2NrZGVwCndhcm5pbmcuCgpSZWdhcmRzLApUw7xya2VyCg==
