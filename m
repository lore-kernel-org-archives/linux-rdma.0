Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=154.81.10.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092070;
	b=nIXndK2ehnIH9lfVu6ofMTmTM7d0NlbATKuTtcI1DUZZ7lfr14Z7IUNhY5gGA2H1KT3c
	 tIeKDxfWz+FfmmbDmhzNeSE4CU972BjzQWvGIUHZRh0a0hq/r8Ezov9/q21KCXxumLnhC
	 /gFtm8N82F96S7VPlZwuip/muAynXxR5UFnO/i7ZMJo9ykPJYbbU2Y3qmVVLZN0ZsKuob
	 ig1rSEOSAUkSS0dkyxjuSe0omgNb5HV+TxvQef0jcxR0nuJX8IRwn7Wvo7YMihwHSQjDe
	 uhX4g/A6TDPUgI3L9xwZxsNfrSj9c3g6lYBylCBfOdsXsjAOJ6JIeIJDoW32y7Ytb5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092070;
	h=DMARC-Filter:Content-Type:Content-Transfer-Encoding:Message-ID:To:Cc:
	 Subject:X-Priority:X-Mailer:X-Originating-IP:In-Reply-To:References:
	 MIME-Version:Received:From:Date:X-HM-Tid:X-HM-MType:X-HM-NTES-SC:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=nFZfj74yvoTFdVjyD7Kb2qFW8dQIj7Yy+nCDe+lCvIA=;
	b=ctTS1W2FUVVRYKP1XqCo6RSm4mItVU8Y4aQgZ3/PAMIL2onOf0KegriqMUAQCiQOWD9f
	 hgyMX0SeE3Ud2+F7YxTsmvYrz1tuKLWHifyaU/SlcURbw0DZEocq+tyIGIqc3Z0E5DLe2
	 dUiHQy/8fgvPsOrxDAetandsQn7F9XQ1MM0cqU+U+J4FMl7HqmE65vTC1fQ8wg3j32Pq6
	 Ccxq1IYLP+2yLd8CGMTmiH3fIQbRrmjEQxjDcfHgP9u69TgssGgpqwAtrx78owjrhUpjO
	 URiZn7M9/SPI5xyOj1a7bQlD7N2fCBVdK4NA96uKfWs8RVkzOD4DsmBXcZMfkLzcW8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=LPgrFHea;
	arc=none smtp.remote-ip=154.81.10.92
Received: from mail-m1092.netease.com (mail-m1092.netease.com [154.81.10.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA42606A320;
	Thu, 19 Nov 2026 12:41:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CA42606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=LPgrFHea
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AJcAXwCpLMe4Pb1NjRYKDqpi.3.1795092059235.Hmail.202321181@mail.sdu.edu.cn>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFJlOiBbUEFUQ0hdIFJETUEvcnRyczogRml4IHBvdGVudGlhbCB1c2UtYWZ0ZXItZnJlZSBvbiBjbGllbnQgc3lzZnMgc2V0dXAgZmFpbHVyZQ==?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com web
In-Reply-To: <20261112190948.GV8635@unreal>
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn> <20261109111652.GD8635@unreal> <APEA3wD5LFuJxkDei2Ikqqq4.3.1794229006784.Hmail.202321181@mail.sdu.edu.cn> <20261112190948.GV8635@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 202321181@mail.sdu.edu.cn( [101.76.249.61] ) by ajax-webmail ( [127.0.0.1] ) ; Thu, 19 Nov 2026 20:40:59 +0800 (GMT+08:00)
From: =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Date: Thu, 19 Nov 2026 20:40:59 +0800 (GMT+08:00)
X-HM-Tid: 0aa1f3d292fed0cdkusy5d64748415ffd
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMVHpP02bZAKsMEiErRSAekjx+ys+KNZNl0PLwl
	f2MeqR5lbiqKsoq8sm3hZVy9q3VVBNOjIUwfWq1GfV2NBR9WJV5pp9Gwt04oeFjraKOA9z+yEZc0
	IOQISNGKIn7Xt1TtqsCUgAxui6en99SU4nXm4=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQhofVkwaS0MaGEoaQkhNSFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
DKIM-Signature: a=rsa-sha256;
	b=LPgrFHeal+8qFaGeU1QGQV4J4CGHD23DzJ41uevZGiXQpMSGo02ogZ8mR3SJ8jqrAIGtgfgJ2cxM9Jsr6EQB6Mzl+JKHR1+wuexVm/6C0/YZnMyKB5Dk+cmtPaF0Qc2YzwhFlGRONaRKY32FDkRgiBNxHKAHV9X2h8HtiLlJhmQ=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=nFZfj74yvoTFdVjyD7Kb2qFW8dQIj7Yy+nCDe+lCvIA=;
	h=date:mime-version:subject:message-id:from;

CkhpIExlb24sCgpUaGFua3MgZm9yIHRoZSByZXZpZXcuCgrlj5Hku7bkurrvvJpMZW9uIFJvbWFu
b3Zza3kgPGxlb25Aa2VybmVsLm9yZz4K5Y+R6YCB5pel5pyf77yaMjAyNi0xMS0xMyAwMzowOTo0
OArmlLbku7bkurrvvJoi5p2O5bm/56GVIiA8bGlndWFuZ3NodW9AbWFpbC5zZHUuZWR1LmNuPgrm
ioTpgIHkurrvvJpKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4sc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZywiTWQuIEhhcmlzIElxYmFsIiA8aGFyaXMuaXFiYWxAaW9ub3MuY29tPixKYWNrIFdh
bmcgPGppbnB1LndhbmdAaW9ub3MuY29tPixsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZyxsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnCuS4u+mimO+8mlJlOiBSZTogW1BBVENIXSBSRE1BL3J0
cnM6IEZpeCBwb3RlbnRpYWwgdXNlLWFmdGVyLWZyZWUgb24gY2xpZW50IHN5c2ZzIHNldHVwIGZh
aWx1cmU+T24gTW9uLCBOb3YgMDksIDIwMjYgYXQgMDg6NTY6NDZQTSArMDgwMCwg5p2O5bm/56GV
IHdyb3RlOgo+PiBIaSBMZW9uLAo+PiAKPj4gVGhhbmtzIGZvciByZXZpZXdpbmcuCj4+IAo+PiBG
cm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4KPj4gRGF0ZTogMjAyNi0xMS0w
OSAxOToxNjo1Mgo+PiBUbzogIEd1YW5nc2h1byBMaSA8bGlndWFuZ3NodW9AbWFpbC5zZHUuZWR1
LmNuPgo+PiBDYzogIEphc29uIEd1bnRob3JwZSA8amdnQHppZXBlLmNhPixzdGFibGVAdmdlci5r
ZXJuZWwub3JnLCJNZC4gSGFyaXMgSXFiYWwiIDxoYXJpcy5pcWJhbEBpb25vcy5jb20+LEphY2sg
V2FuZyA8amlucHUud2FuZ0Bpb25vcy5jb20+LGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnLGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKPj4gU3ViamVjdDogUmU6IFtQQVRDSF0gUkRNQS9y
dHJzOiBGaXggcG90ZW50aWFsIHVzZS1hZnRlci1mcmVlIG9uIGNsaWVudCBzeXNmcyBzZXR1cCBm
YWlsdXJlPk9uIFNhdCwgT2N0IDMxLCAyMDI2IGF0IDEwOjE0OjQ2UE0gKzA4MDAsIEd1YW5nc2h1
byBMaSB3cm90ZToKPj4gPj4gcnRyc19jbHRfY3JlYXRlX3BhdGhfZmlsZXMoKSBkcm9wcyB0aGUg
cGF0aCByZWZlcmVuY2Ugb24gZmFpbHVyZSwgYnV0Cj4+ID4+IGl0cyBjYWxsZXJzIHN0aWxsIGNs
b3NlIGNvbm5lY3Rpb25zIGFuZCBmcmVlIHRoZSBwYXRoLiBUaGlzIGNhbiBhY2Nlc3MKPj4gPj4g
ZnJlZWQgbWVtb3J5IGFuZCBmcmVlIHRoZSBwYXRoIHR3aWNlLgo+PiA+Cj4+ID5Tb3JyeSwgYnV0
IGhvdz8KPj4gPgo+PiBDb25zaWRlciBhbiBhbGxvY2F0aW9uIGZhaWx1cmUgd2hpbGUgc2V0dGlu
ZyB0aGUgbmFtZSBvZiB0aGUgcGF0aAo+PiBrb2JqZWN0IGluIHJ0cnNfY2x0X2NyZWF0ZV9wYXRo
X2ZpbGVzKCkuIGtvYmplY3RfaW5pdF9hbmRfYWRkKCkgaGFzCj4+IGFscmVhZHkgaW5pdGlhbGl6
ZWQgdGhlIHJlZmVyZW5jZSBjb3VudCB0byBvbmUgd2hlbiBzZXR0aW5nIHRoZSBuYW1lCj4+IGZh
aWxzIHdpdGggLUVOT01FTS4gVGhlIHN0YXRzIGtvYmplY3QgaGFzIG5vdCBiZWVuIGNyZWF0ZWQg
eWV0LCBhbmQKPj4gYWRkaW5nIHRoZSBwYXRoIHRvIGNsdC0+cGF0aHNfbGlzdCBkaWQgbm90IHRh
a2UgYSBrb2JqZWN0IHJlZmVyZW5jZS4KPj4gCj4+IFRoZSBlcnJvciBicmFuY2ggdGhlbiBjYWxs
cyBrb2JqZWN0X3B1dCgmY2x0X3BhdGgtPmtvYmopLiBUaGlzIGRyb3BzCj4+IHRoZSBvbmx5IHJl
ZmVyZW5jZS4gV2l0aCBDT05GSUdfREVCVUdfS09CSkVDVF9SRUxFQVNFPW4sCj4+IHJ0cnNfY2x0
X3BhdGhfcmVsZWFzZSgpIHJ1bnMgc3luY2hyb25vdXNseSBhbmQgY2FsbHMgZnJlZV9wYXRoKCks
IHdoaWNoCj4+IGRvZXMga2ZyZWUoY2x0X3BhdGgpLgo+PiAKPj4gQmFjayBpbiBydHJzX2NsdF9v
cGVuKCksIHRoZSBmaXJzdCBzdGF0ZW1lbnQgb24gdGhhdCBlcnJvciBwYXRoIGlzOgo+PiAKPj4g
ICAgICAgICBsaXN0X2RlbF9yY3UoJmNsdF9wYXRoLT5zLmVudHJ5KTsKPj4gCj4+IFRoYXQgYWNj
ZXNzZXMgdGhlIGxpc3Qgbm9kZSBlbWJlZGRlZCBpbiB0aGUgcGF0aCB0aGF0IHdhcyBqdXN0IGZy
ZWVkLgo+PiBUaGlzIGlzIHRoZSB1c2UtYWZ0ZXItZnJlZSBJIG1lYW50Lgo+Cj5UaGUgZXJyb3Ig
aGFuZGxpbmcgYXBwZWFycyB0byBiZSBpbmNvcnJlY3QuIHJ0cnNfY2x0X2NyZWF0ZV9wYXRoX2Zp
bGVzKCkKPnNob3VsZCB1bmRvIG9ubHkgdGhlIGNoYW5nZXMgaXQgbWFkZSBpbnRlcm5hbGx5IGFu
ZCBlcnJvciBoYW5kbGluZyBvZgo+Y2FsbCB0byBydHJzX2NsdF9jcmVhdGVfcGF0aF9maWxlcygp
IHNob3VsZCB1bmRvIHdoYXQgd2FzIGRvbmUgaW4KPnJ0cnNfY2x0X29wZW4oKS4KPgo+VGhhbmtz
Cj4KPj4gCj4+IFRoYW5rcywKPj4gR3VhbmdzaHVvCj4KCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhh
dCBydHJzX2NsdF9jcmVhdGVfcGF0aF9maWxlcygpIHNob3VsZCB1bmRvIGl0cwpvd24gc3lzZnMg
c2V0dXAgb24gZmFpbHVyZS4gVGhlIGNhbGxlciBzdGlsbCBuZWVkcyB0aGUgcGF0aCB0byB1bmxp
bmsKaXQgYW5kIGNsb3NlIHRoZSBjb25uZWN0aW9ucywgc28gaXQgc2hvdWxkIGhvbGQgaXRzIHJl
ZmVyZW5jZSB1bnRpbApib3RoIGFyZSBkb25lLgoKSXMgdGhhdCB0aGUgc3BsaXQgeW91IG1lYW50
PyBJZiBzbywgSSdsbCBzZW5kIGEgdjIgdXNpbmcgaXQgaW4gYm90aApydHJzX2NsdF9vcGVuKCkg
YW5kIHJ0cnNfY2x0X2NyZWF0ZV9wYXRoX2Zyb21fc3lzZnMoKS4KClRoYW5rcywKR3VhbmdzaHVv
Cg==
