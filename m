Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.209.128.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529078;
	b=FBOVY35ZO8Ehx9RHi90/tkmYm5zwfFdHYJfnmlV/+w/kjw9gbKlpJUwE2Ez2MuZEmBT0
	 DGX4OK+WlISGwurIDU0LRW0oFW3RDh5EfiN2WRepptyHWYLurSkiQ8Z+CeyXjaIAyP+VS
	 gwynkHj7vv3M+TdQU1/a+Svb07gWL7ZG/83+DiFAx2s0KIsRxPs4zG8dK1/MileowVKk1
	 6w0D7rTBhZdyzp0s3XR+1wGy0LzuLN96Ywwc19J0QZE7ovlJXmxSPD3AkmF7SdO+wrzwT
	 DQUJru+7w/atsg+EtrhFomA2yCw4sk+9JqUIpa4PJCl+9swFIAXkKn4U/h7CAeaPKfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529078;
	h=DMARC-Filter:Content-Type:Content-Transfer-Encoding:Message-ID:To:Cc:
	 Subject:X-Priority:X-Mailer:X-Originating-IP:In-Reply-To:References:
	 MIME-Version:Received:From:Date:X-HM-Tid:X-HM-MType:X-HM-NTES-SC:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=g6k7Gsy0AruIKywavFE7AEJ3IGDBGmGDT8DjDZQXTVI=;
	b=0W/yfQQh/9h4mrt2fGU8cE7c+DySwLi4K1pwkjdEvueydAUfESNaGJQFfv/fv8hR4+HL
	 gYbej60Yxh5LZVQJTer6xlMtDw/6a69jQ8kYjm0ruGChurgx8ZMRz1m2qQRLo/6nY33RC
	 CHKnSYFQ1FRwLnSn+EdOPXMKg9HOe2/MJS7b+/eVwVisOZ+t9+OpJn/vTMWayEiJACBnn
	 40Foqih8aENFzKA+HpmHJQlVxjR0PRDsbx2b4HR2Jrs1jpXLenw2feSIcggJdK7kmYCqK
	 h/9nvtdN6GXQVclxnUb9Kf5B/Ux/muOc2WkhMjVbMCvidXF97AoD/OPJW9YmTknYxNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=MXa+Z2L0;
	arc=none smtp.remote-ip=103.209.128.125
Received: from mail-m128125.netease.com (mail-m128125.netease.com [103.209.128.125])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9F606A690;
	Tue, 24 Nov 2026 14:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11E9F606A690
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=MXa+Z2L0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AB*APAAaLFrQFfZxcNOqk4oI.3.1795529068345.Hmail.202321181@mail.sdu.edu.cn>
To: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFJlOiBSZTogW1BBVENIXSBSRE1BL3J0cnM6IEZpeCBwb3RlbnRpYWwgdXNlLWFmdGVyLWZyZWUgb24gY2xpZW50IHN5c2ZzIHNldHVwIGZhaWx1cmU=?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com web
In-Reply-To: <CAJpMwyg1iPJUzMYRz-3rWjnRr=9n=rQrii7x-FMmFMS7Wn5OZA@mail.gmail.com>
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn> <20261109111652.GD8635@unreal> <APEA3wD5LFuJxkDei2Ikqqq4.3.1794229006784.Hmail.202321181@mail.sdu.edu.cn> <20261112190948.GV8635@unreal> <AJcAXwCpLMe4Pb1NjRYKDqpi.3.1795092059235.Hmail.202321181@mail.sdu.edu.cn> <CAJpMwyg1iPJUzMYRz-3rWjnRr=9n=rQrii7x-FMmFMS7Wn5OZA@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 202321181@mail.sdu.edu.cn( [101.76.249.61] ) by ajax-webmail ( [127.0.0.1] ) ; Tue, 24 Nov 2026 22:04:28 +0800 (GMT+08:00)
From: =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Date: Tue, 24 Nov 2026 22:04:28 +0800 (GMT+08:00)
X-HM-Tid: 0aa20ddf0bc6d0cdkusy21e93fd1248d3
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMVHpP02bZAKsMEiErRSAekjx+ys+KNZNl0PLwl
	f2MeqR5lbiqKsoq8sm3hZVy9q3VetZ+Wq0Te/EdHEVk+2W3XygE0t2b+veD5v+x2w+urvHs4BhR6
	QMfvbqdmhQ/6XJA2VRXuRopLnUWdEcY/ttS50=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHk4dVhpCGk5CHk1KThgYGVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
DKIM-Signature: a=rsa-sha256;
	b=MXa+Z2L0/mpxY8u/O0UZlY9bpbNuWZq7CVspsuxTT8XeA+d3cInQ8TbvaVdlOmkSO7/BT39T/A6lJfJpfRiOsZqGoZsXx/aII43C529fI/qNAlBv61Tp5L0N5TxXW0ElWvsoI6eiYmnlJfbl3Ik7aQNXVzZ8tY8JGzAMtTWfBSc=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=g6k7Gsy0AruIKywavFE7AEJ3IGDBGmGDT8DjDZQXTVI=;
	h=date:mime-version:subject:message-id:from;

SGkgSGFyaXMsCgpUaGFua3MgZm9yIGNoZWNraW5nIHRoaXMgaW50ZXJuYWxseS4KCuWPkeS7tuS6
uu+8mkhhcmlzIElxYmFsIDxoYXJpcy5pcWJhbEBjbG91ZC5pb25vcy5jb20+CuWPkemAgeaXpeac
n++8mjIwMjYtMTEtMTkgMjI6MzU6MjMK5pS25Lu25Lq677yaIuadjuW5v+ehlSIgPGxpZ3Vhbmdz
aHVvQG1haWwuc2R1LmVkdS5jbj4K5oqE6YCB5Lq677yaTGVvbiBSb21hbm92c2t5IDxsZW9uQGtl
cm5lbC5vcmc+LEphc29uIEd1bnRob3JwZSA8amdnQHppZXBlLmNhPixzdGFibGVAdmdlci5rZXJu
ZWwub3JnLEphY2sgV2FuZyA8amlucHUud2FuZ0Bpb25vcy5jb20+LGxpbnV4LXJkbWFAdmdlci5r
ZXJuZWwub3JnLGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcK5Li76aKY77yaUmU6IFJlOiBS
ZTogW1BBVENIXSBSRE1BL3J0cnM6IEZpeCBwb3RlbnRpYWwgdXNlLWFmdGVyLWZyZWUgb24gY2xp
ZW50IHN5c2ZzIHNldHVwIGZhaWx1cmU+T24gVGh1LCBOb3YgMTksIDIwMjYgYXQgMTo0MeKAr1BN
IOadjuW5v+ehlSA8bGlndWFuZ3NodW9AbWFpbC5zZHUuZWR1LmNuPiB3cm90ZToKPj4KPj4KPj4g
SGkgTGVvbiwKPj4KPj4gVGhhbmtzIGZvciB0aGUgcmV2aWV3Lgo+Pgo+PiDlj5Hku7bkurrvvJpM
ZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4KPj4g5Y+R6YCB5pel5pyf77yaMjAyNi0x
MS0xMyAwMzowOTo0OAo+PiDmlLbku7bkurrvvJoi5p2O5bm/56GVIiA8bGlndWFuZ3NodW9AbWFp
bC5zZHUuZWR1LmNuPgo+PiDmioTpgIHkurrvvJpKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5j
YT4sc3RhYmxlQHZnZXIua2VybmVsLm9yZywiTWQuIEhhcmlzIElxYmFsIiA8aGFyaXMuaXFiYWxA
aW9ub3MuY29tPixKYWNrIFdhbmcgPGppbnB1LndhbmdAaW9ub3MuY29tPixsaW51eC1yZG1hQHZn
ZXIua2VybmVsLm9yZyxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnCj4+IOS4u+mimO+8mlJl
OiBSZTogW1BBVENIXSBSRE1BL3J0cnM6IEZpeCBwb3RlbnRpYWwgdXNlLWFmdGVyLWZyZWUgb24g
Y2xpZW50IHN5c2ZzIHNldHVwIGZhaWx1cmU+T24gTW9uLCBOb3YgMDksIDIwMjYgYXQgMDg6NTY6
NDZQTSArMDgwMCwg5p2O5bm/56GVIHdyb3RlOgo+PiA+PiBIaSBMZW9uLAo+PiA+Pgo+PiA+PiBU
aGFua3MgZm9yIHJldmlld2luZy4KPj4gPj4KPj4gPj4gRnJvbTogTGVvbiBSb21hbm92c2t5IDxs
ZW9uQGtlcm5lbC5vcmc+Cj4+ID4+IERhdGU6IDIwMjYtMTEtMDkgMTk6MTY6NTIKPj4gPj4gVG86
ICBHdWFuZ3NodW8gTGkgPGxpZ3VhbmdzaHVvQG1haWwuc2R1LmVkdS5jbj4KPj4gPj4gQ2M6ICBK
YXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4sc3RhYmxlQHZnZXIua2VybmVsLm9yZywiTWQu
IEhhcmlzIElxYmFsIiA8aGFyaXMuaXFiYWxAaW9ub3MuY29tPixKYWNrIFdhbmcgPGppbnB1Lndh
bmdAaW9ub3MuY29tPixsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZyxsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnCj4+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIFJETUEvcnRyczogRml4IHBv
dGVudGlhbCB1c2UtYWZ0ZXItZnJlZSBvbiBjbGllbnQgc3lzZnMgc2V0dXAgZmFpbHVyZT5PbiBT
YXQsIE9jdCAzMSwgMjAyNiBhdCAxMDoxNDo0NlBNICswODAwLCBHdWFuZ3NodW8gTGkgd3JvdGU6
Cj4+ID4+ID4+IHJ0cnNfY2x0X2NyZWF0ZV9wYXRoX2ZpbGVzKCkgZHJvcHMgdGhlIHBhdGggcmVm
ZXJlbmNlIG9uIGZhaWx1cmUsIGJ1dAo+PiA+PiA+PiBpdHMgY2FsbGVycyBzdGlsbCBjbG9zZSBj
b25uZWN0aW9ucyBhbmQgZnJlZSB0aGUgcGF0aC4gVGhpcyBjYW4gYWNjZXNzCj4+ID4+ID4+IGZy
ZWVkIG1lbW9yeSBhbmQgZnJlZSB0aGUgcGF0aCB0d2ljZS4KPj4gPj4gPgo+PiA+PiA+U29ycnks
IGJ1dCBob3c/Cj4+ID4+ID4KPj4gPj4gQ29uc2lkZXIgYW4gYWxsb2NhdGlvbiBmYWlsdXJlIHdo
aWxlIHNldHRpbmcgdGhlIG5hbWUgb2YgdGhlIHBhdGgKPj4gPj4ga29iamVjdCBpbiBydHJzX2Ns
dF9jcmVhdGVfcGF0aF9maWxlcygpLiBrb2JqZWN0X2luaXRfYW5kX2FkZCgpIGhhcwo+PiA+PiBh
bHJlYWR5IGluaXRpYWxpemVkIHRoZSByZWZlcmVuY2UgY291bnQgdG8gb25lIHdoZW4gc2V0dGlu
ZyB0aGUgbmFtZQo+PiA+PiBmYWlscyB3aXRoIC1FTk9NRU0uIFRoZSBzdGF0cyBrb2JqZWN0IGhh
cyBub3QgYmVlbiBjcmVhdGVkIHlldCwgYW5kCj4+ID4+IGFkZGluZyB0aGUgcGF0aCB0byBjbHQt
PnBhdGhzX2xpc3QgZGlkIG5vdCB0YWtlIGEga29iamVjdCByZWZlcmVuY2UuCj4+ID4+Cj4+ID4+
IFRoZSBlcnJvciBicmFuY2ggdGhlbiBjYWxscyBrb2JqZWN0X3B1dCgmY2x0X3BhdGgtPmtvYmop
LiBUaGlzIGRyb3BzCj4+ID4+IHRoZSBvbmx5IHJlZmVyZW5jZS4gV2l0aCBDT05GSUdfREVCVUdf
S09CSkVDVF9SRUxFQVNFPW4sCj4+ID4+IHJ0cnNfY2x0X3BhdGhfcmVsZWFzZSgpIHJ1bnMgc3lu
Y2hyb25vdXNseSBhbmQgY2FsbHMgZnJlZV9wYXRoKCksIHdoaWNoCj4+ID4+IGRvZXMga2ZyZWUo
Y2x0X3BhdGgpLgo+PiA+Pgo+PiA+PiBCYWNrIGluIHJ0cnNfY2x0X29wZW4oKSwgdGhlIGZpcnN0
IHN0YXRlbWVudCBvbiB0aGF0IGVycm9yIHBhdGggaXM6Cj4+ID4+Cj4+ID4+ICAgICAgICAgbGlz
dF9kZWxfcmN1KCZjbHRfcGF0aC0+cy5lbnRyeSk7Cj4+ID4+Cj4+ID4+IFRoYXQgYWNjZXNzZXMg
dGhlIGxpc3Qgbm9kZSBlbWJlZGRlZCBpbiB0aGUgcGF0aCB0aGF0IHdhcyBqdXN0IGZyZWVkLgo+
PiA+PiBUaGlzIGlzIHRoZSB1c2UtYWZ0ZXItZnJlZSBJIG1lYW50Lgo+PiA+Cj4+ID5UaGUgZXJy
b3IgaGFuZGxpbmcgYXBwZWFycyB0byBiZSBpbmNvcnJlY3QuIHJ0cnNfY2x0X2NyZWF0ZV9wYXRo
X2ZpbGVzKCkKPj4gPnNob3VsZCB1bmRvIG9ubHkgdGhlIGNoYW5nZXMgaXQgbWFkZSBpbnRlcm5h
bGx5IGFuZCBlcnJvciBoYW5kbGluZyBvZgo+PiA+Y2FsbCB0byBydHJzX2NsdF9jcmVhdGVfcGF0
aF9maWxlcygpIHNob3VsZCB1bmRvIHdoYXQgd2FzIGRvbmUgaW4KPj4gPnJ0cnNfY2x0X29wZW4o
KS4KPj4gPgo+PiA+VGhhbmtzCj4+ID4KPj4gPj4KPj4gPj4gVGhhbmtzLAo+PiA+PiBHdWFuZ3No
dW8KPj4gPgo+Pgo+PiBNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgcnRyc19jbHRfY3JlYXRlX3Bh
dGhfZmlsZXMoKSBzaG91bGQgdW5kbyBpdHMKPj4gb3duIHN5c2ZzIHNldHVwIG9uIGZhaWx1cmUu
IFRoZSBjYWxsZXIgc3RpbGwgbmVlZHMgdGhlIHBhdGggdG8gdW5saW5rCj4+IGl0IGFuZCBjbG9z
ZSB0aGUgY29ubmVjdGlvbnMsIHNvIGl0IHNob3VsZCBob2xkIGl0cyByZWZlcmVuY2UgdW50aWwK
Pj4gYm90aCBhcmUgZG9uZS4KPj4KPj4gSXMgdGhhdCB0aGUgc3BsaXQgeW91IG1lYW50PyBJZiBz
bywgSSdsbCBzZW5kIGEgdjIgdXNpbmcgaXQgaW4gYm90aAo+PiBydHJzX2NsdF9vcGVuKCkgYW5k
IHJ0cnNfY2x0X2NyZWF0ZV9wYXRoX2Zyb21fc3lzZnMoKS4KPgo+VGhhbmsgeW91IEd1YW5nc2h1
byBmb3IgdGhlIHBhdGNoIGFuZCBMZW9uIGZvciB0aGUgcmV2aWV3Lgo+VGhlIGJ1ZyBpcyByZWFs
LiBXZSB2ZXJpZmllZCBpdCBpbnRlcm5hbGx5LCBhbmQgc29tZXdoZXJlIGJldHdlZW4gdGhpcwo+
cGF0Y2ggYW5kIHRoZSBmaXJzdCBvbmUgR3VhbmdzaHVvIHNlbnQgaW4gTWF5LCB3ZSBzb2x2ZWQg
dGhpcwo+aW50ZXJuYWxseSBidXQgbWlzc2VkIHNlbmRpbmcgaXQgdXBzdHJlYW0uIEl0IHdhcyBh
IG1pc3MgZnJvbSB1cywKPmFwb2xvZ2llcyBmb3IgdGhhdC4KPgo+V2Ugd2lsbCBzZW5kIHRoZSB2
ZXJzaW9uIHdlIGhhdmUgc29vbiwgYWxvbmdzaWRlIHdpdGggb3RoZXIgZml4ZXMuCj4KPj4KPj4g
VGhhbmtzLAo+PiBHdWFuZ3NodW8KPgo+Cj4KPi0tIAo+Cj5SZWdhcmRzCj4tSGFyaXMKPgoKSSB1
bmRlcnN0YW5kIHRoYXQgeW91IGFscmVhZHkgaGF2ZSBhIGZpeCBhbmQgd2lsbCBzZW5kIGl0IHdp
dGggdGhlCm90aGVyIGNoYW5nZXMuIEknbGwgd2FpdCBmb3IgeW91ciBzZXJpZXMgYW5kIHJldmll
dyB0aGF0IHZlcnNpb24uCgpUaGFua3MsCkd1YW5nc2h1bwo=
