Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.236.52.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229021;
	b=wmLlWSeWQh91ugZAsdqq5cAeT1D8jG1hQP6JXWInz6v6kC2g1pj+2bnJFPznNwX1c/VK
	 68U0evfxR4JsQIIfcs4Zk1nLOKHdyaaDvVbYWAqafz+d0RU1qxwSTeLlIPzT0AdeB10wC
	 a7SLng5ZO8yqCR8+PaljZWKbpksqliiZzqJSAwzt7Zch1rmWQu/OPrGmylENYOaVgOoMp
	 Mp1PHnQ55G1ebcJW8OT75XG7ErMHlBJyQBBMPxHWBtl8/NmQ3ufDDbEwha69F7Krg3BWK
	 i4/FzxU+USIyyA1pkypdFlHgvFlyi8lZeQoF5eU8sT/RLh0hjWW38vnvZr2iXIjQw0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229021;
	h=DMARC-Filter:Content-Type:Content-Transfer-Encoding:Message-ID:To:Cc:
	 Subject:X-Priority:X-Mailer:X-Originating-IP:In-Reply-To:References:
	 MIME-Version:Received:From:Date:X-HM-Tid:X-HM-MType:X-HM-NTES-SC:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=6WjD+7KwCK+a2zO9SxX1GaUGfgsoji0h2p/yuklFq40=;
	b=IOjOaXGNNkkn7oQpUxCAVdn8VxzLpkULn1Vf/DrMV4+VzOyKXbd72mVFskm5EwppBx45
	 Y+Vz4Sk1vi5BgpGQD0OJZyrdxhtcQDfudidp1/bNdGpICda8/kq8t/kqQNxu2jzAhCkWB
	 XkizPM9piiqyMOS/PhGV+gaty7wD0JgUnEIN3onbv0BKPoCw0aTAdeGygkz1DFwz5qj4S
	 rEnBQdSs1g5Yqy8geGa9+Mmg8R7pGESGt8BD9X0nwGlq1xgcm3QOq6RPpzea/u1BcfmIj
	 zZWTZnTAbav3vlHhaC9w9PaEMDq/ROaNGrlVJAWmUXcquCVfHkGwzlUvJZv9lO3wQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=EQawklHm;
	arc=none smtp.remote-ip=160.236.52.228
Received: from mail-m16023652228.xmail.ntesmail.com (mail-m16023652228.xmail.ntesmail.com [160.236.52.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462E606A31C;
	Mon,  9 Nov 2026 12:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7462E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=EQawklHm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <APEA3wD5LFuJxkDei2Ikqqq4.3.1794229006784.Hmail.202321181@mail.sdu.edu.cn>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSF0gUkRNQS9ydHJzOiBGaXggcG90ZW50aWFsIHVzZS1hZnRlci1mcmVlIG9uIGNsaWVudCBzeXNmcyBzZXR1cCBmYWlsdXJl?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com web
In-Reply-To: <20261109111652.GD8635@unreal>
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn> <20261109111652.GD8635@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 202321181@mail.sdu.edu.cn( [101.76.249.61] ) by ajax-webmail ( [127.0.0.1] ) ; Mon, 9 Nov 2026 20:56:46 +0800 (GMT+08:00)
From: =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Date: Mon, 9 Nov 2026 20:56:46 +0800 (GMT+08:00)
X-HM-Tid: 0aa1c05f60d5d0cdkusya9b7de4bea6c
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMVHpP02bZAKsMEiErRSAekjx+ys+KNZNl0PLwl
	f2MeqR5lbiqKsoq8sm3hZVy9q3VY0Ca69y1LOfMeXKdLfI1E5i1eQoqSDNKmzdVlKZstM3O+8hfF
	V6URxYTc7eahx9VOrzkA6R7vVablFdI1bzF1E=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQhlNVhkdTU1PTB4aGEgeHVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
DKIM-Signature: a=rsa-sha256;
	b=EQawklHmnjEz1eDhnbHy5Vt9I1jjmcweJ9FfL9USrXSbV/oTgLc1IXWz4uFmpd0CcsbsObM3VNJoYcmmQz5ISGVhkKg7TMEWrLj5+6Oc8E+6FqQMScNVqubHmxkva1Fu+6sNNIK5FqPiGALDfVBfNLnh8mPa/ciDqCtmo3gk9qo=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=6WjD+7KwCK+a2zO9SxX1GaUGfgsoji0h2p/yuklFq40=;
	h=date:mime-version:subject:message-id:from;

SGkgTGVvbiwKClRoYW5rcyBmb3IgcmV2aWV3aW5nLgoKRnJvbTogTGVvbiBSb21hbm92c2t5IDxs
ZW9uQGtlcm5lbC5vcmc+CkRhdGU6IDIwMjYtMTEtMDkgMTk6MTY6NTIKVG86ICBHdWFuZ3NodW8g
TGkgPGxpZ3VhbmdzaHVvQG1haWwuc2R1LmVkdS5jbj4KQ2M6ICBKYXNvbiBHdW50aG9ycGUgPGpn
Z0B6aWVwZS5jYT4sc3RhYmxlQHZnZXIua2VybmVsLm9yZywiTWQuIEhhcmlzIElxYmFsIiA8aGFy
aXMuaXFiYWxAaW9ub3MuY29tPixKYWNrIFdhbmcgPGppbnB1LndhbmdAaW9ub3MuY29tPixsaW51
eC1yZG1hQHZnZXIua2VybmVsLm9yZyxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnClN1Ympl
Y3Q6IFJlOiBbUEFUQ0hdIFJETUEvcnRyczogRml4IHBvdGVudGlhbCB1c2UtYWZ0ZXItZnJlZSBv
biBjbGllbnQgc3lzZnMgc2V0dXAgZmFpbHVyZT5PbiBTYXQsIE9jdCAzMSwgMjAyNiBhdCAxMDox
NDo0NlBNICswODAwLCBHdWFuZ3NodW8gTGkgd3JvdGU6Cj4+IHJ0cnNfY2x0X2NyZWF0ZV9wYXRo
X2ZpbGVzKCkgZHJvcHMgdGhlIHBhdGggcmVmZXJlbmNlIG9uIGZhaWx1cmUsIGJ1dAo+PiBpdHMg
Y2FsbGVycyBzdGlsbCBjbG9zZSBjb25uZWN0aW9ucyBhbmQgZnJlZSB0aGUgcGF0aC4gVGhpcyBj
YW4gYWNjZXNzCj4+IGZyZWVkIG1lbW9yeSBhbmQgZnJlZSB0aGUgcGF0aCB0d2ljZS4KPgo+U29y
cnksIGJ1dCBob3c/Cj4KQ29uc2lkZXIgYW4gYWxsb2NhdGlvbiBmYWlsdXJlIHdoaWxlIHNldHRp
bmcgdGhlIG5hbWUgb2YgdGhlIHBhdGgKa29iamVjdCBpbiBydHJzX2NsdF9jcmVhdGVfcGF0aF9m
aWxlcygpLiBrb2JqZWN0X2luaXRfYW5kX2FkZCgpIGhhcwphbHJlYWR5IGluaXRpYWxpemVkIHRo
ZSByZWZlcmVuY2UgY291bnQgdG8gb25lIHdoZW4gc2V0dGluZyB0aGUgbmFtZQpmYWlscyB3aXRo
IC1FTk9NRU0uIFRoZSBzdGF0cyBrb2JqZWN0IGhhcyBub3QgYmVlbiBjcmVhdGVkIHlldCwgYW5k
CmFkZGluZyB0aGUgcGF0aCB0byBjbHQtPnBhdGhzX2xpc3QgZGlkIG5vdCB0YWtlIGEga29iamVj
dCByZWZlcmVuY2UuCgpUaGUgZXJyb3IgYnJhbmNoIHRoZW4gY2FsbHMga29iamVjdF9wdXQoJmNs
dF9wYXRoLT5rb2JqKS4gVGhpcyBkcm9wcwp0aGUgb25seSByZWZlcmVuY2UuIFdpdGggQ09ORklH
X0RFQlVHX0tPQkpFQ1RfUkVMRUFTRT1uLApydHJzX2NsdF9wYXRoX3JlbGVhc2UoKSBydW5zIHN5
bmNocm9ub3VzbHkgYW5kIGNhbGxzIGZyZWVfcGF0aCgpLCB3aGljaApkb2VzIGtmcmVlKGNsdF9w
YXRoKS4KCkJhY2sgaW4gcnRyc19jbHRfb3BlbigpLCB0aGUgZmlyc3Qgc3RhdGVtZW50IG9uIHRo
YXQgZXJyb3IgcGF0aCBpczoKCiAgICAgICAgbGlzdF9kZWxfcmN1KCZjbHRfcGF0aC0+cy5lbnRy
eSk7CgpUaGF0IGFjY2Vzc2VzIHRoZSBsaXN0IG5vZGUgZW1iZWRkZWQgaW4gdGhlIHBhdGggdGhh
dCB3YXMganVzdCBmcmVlZC4KVGhpcyBpcyB0aGUgdXNlLWFmdGVyLWZyZWUgSSBtZWFudC4KClRo
YW5rcywKR3VhbmdzaHVvCg==
