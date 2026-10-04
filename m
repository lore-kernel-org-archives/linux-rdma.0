Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AF41E47CC
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 04:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791089889; cv=none; b=TNYT21tzVXKB2cmSI9wC0/j6xbXWsvwRQhfiFLILi1pxrt44oORL6XPkTT2hdZPwJekdaVwSu2pQkxszaVA2HkrwdniHzuO+wTvY5jFGJgdnHsMsrIoMg5EQzVL0jAD+yFY6HpeHyeQq5x01bgQlYK97jspBBO+vZa2pcazE2Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791089889; c=relaxed/simple;
	bh=pveZV1W6doLsEqzB4iSY0Mq5sZMoQ12zOy2I8Xcg3dI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=eXjs3RWqZPz1xGErKv4/UaHvrGhk9IgxEE/qlKLBpVlpUixbhTuJVGfIj3SEUDQop52gABbmneAnTqjKdofn7O1mTDdLbMk6hZTda18LmJL957b5w/NBAFIUWybpzBdPDmWnchb2B2M0sO4l8nduZp/FPtiTHRX6+ZErERmHK7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mAnS3SVL; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mAnS3SVL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=pveZV1W6doLsEqzB4iSY0Mq5sZMoQ12zOy2I8Xcg3dI=; b=m
	AnS3SVLktCalhGVyaUO9VcKHYOPbivbuAraj48tQYc3pakseVXUo502xrGMWN/Lz
	YEAFu8CK51ttXvB7NN4Z+RFKh/RnTpD33OpSVqI8gzRjZFxvWJAkJmFEa6QVBFwZ
	HGzNykilCbS0joAjIvCZ7qUP7ihm2/X+bixgI32GDw=
Date: Sun, 4 Oct 2026 12:57:46 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org
Subject: Re:Re: [PATCH] RDMA/rxe: Validate inline data range in user WQEs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <a1ef2c45-431f-4dad-b812-0b6cccf9ecc5@linux.dev>
References: <20260924100515.502912-1-yaojiale02@163.com>
 <20260924101736.9FA281F000FF@smtp.kernel.org>
 <a1ef2c45-431f-4dad-b812-0b6cccf9ecc5@linux.dev>
X-NTES-SC: AL_Qu2SA/yTtkAt4CeeYukdmE8Uges8WcC0svki1YJUc/8EpB3y+wIGb3hzNHzJ7uWSEgqXjgGsUwRR7/57d5ZbmzNjBIftmBFw290PbxkPRA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <1c28994b.869.1a105467816.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:dygvCgDnH+rK3MFqDlhSAA--.11300W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQp0rmrB3MpbBQAA3+
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

QXQgMjAyNi0wOS0yNiAwMToyMzoyOCwgIlpodSBZYW5qdW4iIDx5YW5qdW4uemh1QGxpbnV4LmRl
dj4gd3JvdGU6Cj7U2iAyMDI2LzkvMjQgMzoxNywgc2FzaGlrby1ib3RAa2VybmVsLm9yZyDQtLXA
Ogo+PiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJldmlldyBm
b3VuZCAxIHBvdGVudGlhbCBpc3N1ZShzKSB0byBjb25zaWRlcjoKPj4gLSBbQ3JpdGljYWxdIFJE
TUEvcnhlOiBUT0NUT1UgYnlwYXNzIG9mIGlubGluZSBXUUUgdmFsaWRhdGlvbgo+PiAtLQo+PiAK
Pj4gY29tbWl0IGUyNzJmNWJlOGQ3NjJlYTJlNzgzMDFjMTMzOWM0NDBhMTllMTEzMGIKPj4gQXV0
aG9yOiBKaWFsZSBZYW8gPHlhb2ppYWxlMDJAMTYzLmNvbT4KPj4gCj4+IFJETUEvcnhlOiBWYWxp
ZGF0ZSBpbmxpbmUgZGF0YSByYW5nZSBpbiB1c2VyIFdRRXMKPj4gCj4+IFRoaXMgY29tbWl0IGFk
ZHMgYm91bmRzIHZhbGlkYXRpb24gZm9yIHRoZSBpbmxpbmUgZGF0YSByYW5nZSBpbiB1c2VyIFdR
RXMgdG8KPj4gcHJldmVudCBrZXJuZWwgbWVtb3J5IGRpc2Nsb3N1cmUgb3Igdm1hbGxvYyBvdXQt
b2YtYm91bmRzIGFjY2Vzc2VzLiBJdCBjaGVja3MKPj4gdGhlIG9mZnNldCBhbmQgbGVuZ3RoIGFn
YWluc3QgdGhlIHBlci1XUUUgaW5saW5lIGFyZWEgdG8gZW5zdXJlIHRoZXkgZml0Lgo+PiAKPj4g
TGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwNzA4MjI0NTM0LjEyMDYtMS1z
ZWN1cml0eUBhdWRpdGNvZGUuYWkvCj4+IAo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5p
YmFuZC9zdy9yeGUvcnhlX3JlcS5jIGIvZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZS9yeGVfcmVx
LmMKPj4+IGluZGV4IDUzZjdjMWU3ZmU1NWIuLjA2Yjc2NjlkN2Y3MzcgMTAwNjQ0Cj4+PiAtLS0g
YS9kcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9yZXEuYwo+Pj4gKysrIGIvZHJpdmVycy9p
bmZpbmliYW5kL3N3L3J4ZS9yeGVfcmVxLmMKPj4+IEBAIC03MTYsNiArNzE2LDE1IEBAIGludCBy
eGVfcmVxdWVzdGVyKHN0cnVjdCByeGVfcXAgKnFwKQo+Pj4gICAJCWdvdG8gZXJyOwo+Pj4gICAJ
fQo+Pj4gICAKPj4+ICsJaWYgKHVubGlrZWx5KCh3cWUtPndyLnNlbmRfZmxhZ3MgJiBJQl9TRU5E
X0lOTElORSkgJiYKPj4+ICsJCSAgICAgKHdxZS0+ZG1hLnNnZV9vZmZzZXQgPiBxcC0+c3EubWF4
X2lubGluZSB8fAo+Pj4gKwkJICAgICAgd3FlLT5kbWEucmVzaWQgPgo+Pj4gKwkJICAgICAgcXAt
PnNxLm1heF9pbmxpbmUgLSB3cWUtPmRtYS5zZ2Vfb2Zmc2V0KSkpIHsKPj4gCj4+IFtTZXZlcml0
eTogQ3JpdGljYWxdCj4+IFNpbmNlIHdxZSBwb2ludHMgZGlyZWN0bHkgdG8gYSBtZW1vcnktbWFw
cGVkIHJpbmcgYnVmZmVyIHNoYXJlZCB3aXRoCj4+IHVzZXJzcGFjZSwgY2FuIHRoaXMgdmFsaWRh
dGlvbiBiZSBieXBhc3NlZCB2aWEgYSBUT0NUT1UgcmFjZT8KPj4gCj4+IEEgbWFsaWNpb3VzIHVz
ZXJzcGFjZSBwcm9ncmFtIGNvdWxkIHByb3ZpZGUgYSB2YWxpZCBzZ2Vfb2Zmc2V0IGhlcmUgdG8K
Pj4gcGFzcyB0aGUgYm91bmRzIGNoZWNrLCBidXQgdGhlbiBjb25jdXJyZW50bHkgbW9kaWZ5IHdx
ZS0+ZG1hLnNnZV9vZmZzZXQKPj4gaW4gc2hhcmVkIG1lbW9yeSB0byBhbiBvdXQtb2YtYm91bmRz
IHZhbHVlLgo+PiAKPj4gV2hlbiBmaW5pc2hfcGFja2V0KCkgZXhlY3V0ZXMgbGF0ZXIgb246Cj4+
IAo+PiBmaW5pc2hfcGFja2V0KCkgewo+PiAgICAgIC4uLgo+PiAgICAgIHU4ICp0bXAgPSAmd3Fl
LT5kbWEuaW5saW5lX2RhdGFbd3FlLT5kbWEuc2dlX29mZnNldF07Cj4+ICAgICAgLi4uCj4+IH0K
Pj4gCj4+IENvdWxkIGl0IHJlLWZldGNoIHRoZSBtb2RpZmllZCwgbm93IG91dC1vZi1ib3VuZHMg
c2dlX29mZnNldCBkaXJlY3RseQo+PiBmcm9tIHNoYXJlZCBtZW1vcnksIHJlc3VsdGluZyBpbiB0
aGUgc2FtZSBrZXJuZWwgbWVtb3J5IGRpc2Nsb3N1cmUgb3IKPj4gdm1hbGxvYyBvdXQtb2YtYm91
bmRzIGFjY2VzcyB0aGlzIHBhdGNoIGludGVuZHMgdG8gZml4Pwo+Cj5IaSwgSmlhbGUKPgo+UGxl
YXNlIGZpeCB0aGUgcHJvYmxlbSB0aGF0IFNhc2hpa28gbWVudGlvbmVkLiBUaGVuIHNlbmQgb3V0
IGEgbmV3IGNvbW1pdC4KPgo+VGhhbmtzIGEgbG90Lgo+WWFuanVuIFpodQpIb3cgYWJvdXQgdGhp
cyBvbmUsCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MDkyNjA3MDQwMy4zMDA1MjUw
LTEteWFvamlhbGUwMkAxNjMuY29tLwo+Cj4+IAo+Pj4gKwkJcnhlX2RiZ19xcChxcCwgImludmFs
aWQgaW5saW5lIGRhdGEgcmFuZ2UgaW4gc2VuZCB3cWVcbiIpOwo+Pj4gKwkJd3FlLT5zdGF0dXMg
PSBJQl9XQ19MT0NfUVBfT1BfRVJSOwo+Pj4gKwkJZ290byBlcnI7Cj4+PiArCX0KPj4+ICsKPj4+
ICAgCWlmIChyeGVfd3FlX2lzX2ZlbmNlZChxcCwgd3FlKSkgewo+Pj4gICAJCXFwLT5yZXEud2Fp
dF9mZW5jZSA9IDE7Cj4+PiAgIAkJZ290byBleGl0Owo+PiAK
