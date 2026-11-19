Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.236.53.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092291;
	b=YHE4w0vOIQnnOLe8cpSdlJ5C3OlX7QEMyCw1nxgENo8IBNXs6fDyKFjgKbipQ/lTtzLP
	 bx8QaoFlaxFROIGaC2NRg+Zr8ZzfJPLf3x4oHXA2WiJO+3zP3RQL1Nhmw4qck+Gd2uZ3m
	 9XtLE0tg4rfLPhT6yz8ZZY7yxwGdDR3GQHZK2OB2k5S52IbcjOSxNqqe6KsXd8vSb2Oh1
	 0txHW7rhxL5uxF/2fRMYloGK7tm5+zyHbwxmlSoDpWpi/CbD3dMVlZVJVzSCjxCuowABD
	 t4kPm4lnZhFUGn7rR2gWCA5Mxe1dEK3WMQtdgzSpSSdZd3DjZynV65iMuVHqZqm9tdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092291;
	h=DMARC-Filter:Content-Type:Content-Transfer-Encoding:Message-ID:To:Cc:
	 Subject:X-Priority:X-Mailer:X-Originating-IP:In-Reply-To:References:
	 MIME-Version:Received:From:Date:X-HM-Tid:X-HM-MType:X-HM-NTES-SC:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=3dqeJugsJq79ha6RZSqW6Sks6KXKi1bn5iTNyHEyu2w=;
	b=EHyK7iAkmERWApeSgUNDG7JtLQuFzp1YIlCHIvT0ns0/8RgfVl7IaTxCQ6UgF5bI+wJ4
	 sWEFFzHbMNGQLsBl25Lv1uQntgp5ePwoKaUM3mhDQ2qPGCy8jxnbmVcCyfbA6vR/9T2gq
	 WlYq5BJ0hgYwma7qxtTwi+5x6fYlhbu6HKIdgJ0YkL5SNnqKvoRRxyc9ZR4leqDhRwuYs
	 16az8RXJOekOAX+SAuubRM/QFybWFl18AzZaldrTFddB8b8894eDI9DIrxpmM7IRIdVpU
	 bBc869C4KYMGhoKUUsOWtIlvR1UqtE0wVuMAiAVoRyv2VoB8HZyRK38OQ1ekOgJDSLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=SiDWSKMv;
	arc=none smtp.remote-ip=160.236.53.86
Received: from mail-m1602365386.xmail.ntesmail.com (mail-m1602365386.xmail.ntesmail.com [160.236.53.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D52606A325;
	Thu, 19 Nov 2026 12:44:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7D52606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=SiDWSKMv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <APgA2ADdLAK4Fr01jTNuVqo3.3.1795092279897.Hmail.202321181@mail.sdu.edu.cn>
To: Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSF0gSUIvaGZpMTogRml4IHBvdGVudGlhbCBsZWFrcyBpbiBJUG9JQiBUWCBxdWV1ZSBpbml0aWFsaXphdGlvbg==?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com web
In-Reply-To: <20261115135524.GE42525@unreal>
References: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn> <20261115135524.GE42525@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 202321181@mail.sdu.edu.cn( [101.76.249.61] ) by ajax-webmail ( [127.0.0.1] ) ; Thu, 19 Nov 2026 20:44:39 +0800 (GMT+08:00)
From: =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Date: Thu, 19 Nov 2026 20:44:39 +0800 (GMT+08:00)
X-HM-Tid: 0aa1f3d60e80d0cdkusye5b1956c16013
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMVHpP02bZAKsMEiErRSAekjx+ys+KNZNl0PLwl
	f2MeqR5lbiqKsoq8sm3hZVy9q3VVBNOjIUwfWq1GfV2NBR9WJV5pp9Gwt04oeFjraKOA9zQamUd8
	dcMb4KrMTsuroN9WulQJMq64stjjs2ymImO78=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTh8ZVhkYH0NDGU4dSkhIGVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
DKIM-Signature: a=rsa-sha256;
	b=SiDWSKMvC4IZ3FzIFLRyaAWWSTru4Oew0KnwsDFAKoTTdWPWuzNDo5QQs/7YgBXtiVJK8/1vWnx4wl4xn7KEEQSMaAE6YU/TKYl7Pc/54SLWcYiGWAmQprnf4dPEoDXyZkWN54Chm0hej1r4TYnbUltY234NKpnxdlQ8pZ0vn7w=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=3dqeJugsJq79ha6RZSqW6Sks6KXKi1bn5iTNyHEyu2w=;
	h=date:mime-version:subject:message-id:from;

CkhpIExlb24sCgpUaGFua3MgZm9yIHRoZSByZXZpZXcuCgpGcm9tOiBMZW9uIFJvbWFub3Zza3kg
PGxlb25Aa2VybmVsLm9yZz4KRGF0ZTogMjAyNi0xMS0xNSAyMTo1NToyNApUbzogIEd1YW5nc2h1
byBMaSA8bGlndWFuZ3NodW9AbWFpbC5zZHUuZWR1LmNuPgpDYzogIERlbm5pcyBEYWxlc3NhbmRy
byA8ZGVubmlzLmRhbGVzc2FuZHJvQGNvcm5lbGlzbmV0d29ya3MuY29tPixKYXNvbiBHdW50aG9y
cGUgPGpnZ0B6aWVwZS5jYT4sbGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmcsbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZwpTdWJqZWN0OiBSZTogW1BBVENIXSBJQi9oZmkxOiBGaXggcG90ZW50
aWFsIGxlYWtzIGluIElQb0lCIFRYIHF1ZXVlIGluaXRpYWxpemF0aW9uPk9uIFdlZCwgTm92IDEx
LCAyMDI2IGF0IDA4OjIzOjE5UE0gKzA4MDAsIEd1YW5nc2h1byBMaSB3cm90ZToKPj4gV2hlbiBh
biBTRE1BIGhlYWRlciBhbGxvY2F0aW9uIGZhaWxzLCByb2xsYmFjayBza2lwcyB0aGUgY3VycmVu
dCBUWAo+PiBxdWV1ZS4gSXRzIHJpbmcgYW5kIGFscmVhZHkgYWxsb2NhdGVkIGhlYWRlcnMgYXJl
IGxlYWtlZC4gRnJlZSB0aGUKPj4gcGFydGlhbGx5IGluaXRpYWxpemVkIHJpbmcgYmVmb3JlIHVu
d2luZGluZyB0aGUgY29tcGxldGVkIHF1ZXVlcy4KPgo+ZnJlZV90eF9yaW5nIGFscmVhZHkgcGVy
Zm9ybXMgdGhhdCwgc2VlICJmb3IgKGogPSAwOyBqIDwgdHhfcmluZ19zaXplOyBqKyspIgo+bG9v
cC4KPgo+VGhhbmtzCj4KPj4gCj4+IFRoaXMgaXNzdWUgd2FzIGZvdW5kIGJ5IG91ciBzdGF0aWMg
YW5hbHlzaXMgdG9vbCB1bmRlciBkZXZlbG9wbWVudC4KPj4gCj4+IEZpeGVzOiBjODc0YWQ4Nzlj
MmYgKCJJQi9oaWZpMTogYWRkIGEgbnVsbCBjaGVjayBvZiBremFsbG9jX25vZGUgaW4gaGZpMV9p
cG9pYl90eHJlcV9pbml0IikKPj4gU2lnbmVkLW9mZi1ieTogR3VhbmdzaHVvIExpIDxsaWd1YW5n
c2h1b0BtYWlsLnNkdS5lZHUuY24+Cj4+IC0tLQo+PiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L2hm
aTEvaXBvaWJfdHguYyB8IDYgKysrKystCj4+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pCj4+IAo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5k
L2h3L2hmaTEvaXBvaWJfdHguYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9oZmkxL2lwb2liX3R4
LmMKPj4gaW5kZXggOGI5Y2M1NWRiNTlkLi4yZTkyMjViNTU4YjQgMTAwNjQ0Cj4+IC0tLSBhL2Ry
aXZlcnMvaW5maW5pYmFuZC9ody9oZmkxL2lwb2liX3R4LmMKPj4gKysrIGIvZHJpdmVycy9pbmZp
bmliYW5kL2h3L2hmaTEvaXBvaWJfdHguYwo+PiBAQCAtNzQzLDcgKzc0Myw3IEBAIGludCBoZmkx
X2lwb2liX3R4cmVxX2luaXQoc3RydWN0IGhmaTFfaXBvaWJfZGV2X3ByaXYgKnByaXYpCj4+ICAJ
CQkJa3phbGxvY19ub2RlKHNpemVvZigqdHgtPnNkbWFfaGRyKSwKPj4gIAkJCQkJICAgICBHRlBf
S0VSTkVMLCBwcml2LT5kZC0+bm9kZSk7Cj4+ICAJCQlpZiAoIWhmaTFfdHhyZXFfZnJvbV9pZHgo
dHhfcmluZywgaiktPnNkbWFfaGRyKQo+PiAtCQkJCWdvdG8gZnJlZV90eHFzOwo+PiArCQkJCWdv
dG8gZnJlZV90eF9yaW5nOwo+PiAgCQl9Cj4+ICAKPj4gIAkJbmV0aWZfbmFwaV9hZGRfdHgoZGV2
LCAmdHhxLT5uYXBpLCBoZmkxX2lwb2liX3BvbGxfdHhfcmluZyk7Cj4+IEBAIC03NTEsNiArNzUx
LDEwIEBAIGludCBoZmkxX2lwb2liX3R4cmVxX2luaXQoc3RydWN0IGhmaTFfaXBvaWJfZGV2X3By
aXYgKnByaXYpCj4+ICAKPj4gIAlyZXR1cm4gMDsKPj4gIAo+PiArZnJlZV90eF9yaW5nOgo+PiAr
CXdoaWxlIChqLS0pCj4+ICsJCWtmcmVlKGhmaTFfdHhyZXFfZnJvbV9pZHgodHhfcmluZywgaikt
PnNkbWFfaGRyKTsKPj4gKwlrdmZyZWUodHhfcmluZy0+aXRlbXMpOwo+PiAgZnJlZV90eHFzOgo+
PiAgCWZvciAoaS0tOyBpID49IDA7IGktLSkgewo+PiAgCQlzdHJ1Y3QgaGZpMV9pcG9pYl90eHEg
KnR4cSA9ICZwcml2LT50eHFzW2ldOwo+PiAKPj4gYmFzZS1jb21taXQ6IDY2MjhlN2Q0YzZiMjVj
OGQxOGYxMzQ1ZTNhMjBkMjE4MjlhYWU3ZTQKPj4gCj4KClRoZSBqIGxvb3AgZnJlZXMgYWxsIHRo
ZSBoZWFkZXJzIGluIGVhY2ggcmluZyBpdCB2aXNpdHMuIEFzIEkgcmVhZApmcmVlX3R4cXMsIHRo
ZSBvdXRlciBsb29wIHN0YXJ0cyB3aXRoIGktLSwgc28gaXQgc2tpcHMgdGhlIHF1ZXVlIHdoZXJl
CnRoZSBoZWFkZXIgYWxsb2NhdGlvbiBmYWlsZWQuIElmIHRoYXQgaGFwcGVucyBvbiBxdWV1ZSAw
LCB0aGUgbG9vcApuZXZlciBydW5zLgoKV291bGQgaXQgbWFrZSBzZW5zZSB0byByZXVzZSB0aGUg
cmluZyBjbGVhbnVwIGZvciB0aGUgcGFydGlhbCBxdWV1ZQphbmQga2VlcCBuZXRpZl9uYXBpX2Rl
bCgpIG9ubHkgZm9yIHF1ZXVlcyB3aGVyZSBOQVBJIHdhcyBhZGRlZD8gSWYgc28sCkknbGwgc2Vu
ZCBhIHYyIHRoYXQgZG9lcyB0aGF0LgoKVGhhbmtzLApHdWFuZ3NodW8=
