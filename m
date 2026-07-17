Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C61898FB;
	Fri, 17 Jul 2026 02:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784253664; cv=none; b=Y5D715po2x5PvdoNjbE9Hd1/bW6dlEj8y3gzsugdzyMS16XL+09MwZLbJe25NCYkQpOHckL11TmomBtuUJXd38DMZCoDgpqu7bfyHrqJLvWQ7sg01pltEfcg71Oq9ePgQP5peY/aUbwI4LNq8BF+xeF3hoUudtEtl2WaPIJeqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784253664; c=relaxed/simple;
	bh=4C5240sZmSDiyUVZ6hentvDfIa+DfkuS+xQ/gleUO5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=ELwawsE69US7MyEMVVH0ik24kBUgqwramISbTjEin4RuYrpHRfbh+mmDkBz1oVZXMH9w/2WyBGFa6Sbc7ZotM45Cqap7nfLSDjvQWH9Qy0VEstDqyH9kpTOj/vXnjWYLPfkjzBzluo/jxt6yCltVnfc6TLiKzwMbSN7Un/f0pnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=G2/vHDML; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="G2/vHDML"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=4C5240sZmSDiyUVZ6hentvDfIa+DfkuS+xQ/gleUO5A=; b=G
	2/vHDMLuRUP/RMTa8+j++6Am1lNF2d9CkavOhrc18w7dkh+Crnz6eTxPQojYcA4m
	vnGu6zb8ziog32PBB64umrNyiVfWwT4lUQUyhTHEUpb4PO7XagEwlvNz2Ia5D7rg
	oU2RbKM+EJF2QKd+4edNUnPemKvHZddjiJ68Q34MD0=
Received: from kensanya$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-111 (Coremail) ; Fri, 17 Jul 2026 10:00:26 +0800
 (CST)
Date: Fri, 17 Jul 2026 10:00:26 +0800 (CST)
From: kensanya  <kensanya@163.com>
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re:Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind
 counters
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
References: <20260715101550.45345-1-kensanya@163.com>
 <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
X-NTES-SC: AL_Qu2TBv6evE4p4CCdYOkcnkcTg+k8WMW1ufsg2Ydec/kEuDzw9T47XGR/DGTr4OWALB2otxypUxJw+M1DTYlGcKvb9ADnBvynvJJ3m3ikOQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <386585bd.1730.19f6dcdb6cf.Coremail.kensanya@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bygvCgDXfwq7jFlqMP0fAA--.809W
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6RtCHmpZjLsIEwAA3x
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA3LTE3IDAxOjM3OjM5LCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2NoZUBh
Y20ub3JnPiB3cm90ZToKPk9uIDcvMTUvMjYgMzoxNSBBTSwga2Vuc2FueWFAMTYzLmNvbSB3cm90
ZToKPj4gRnJvbTogVGFuWmhlbmcgPHRhbnpoZW5nQGt5bGlub3MuY24+Cj4+IAo+PiBXaGVuIHNy
cHRfYWxsb2NfcndfY3R4cygpIGZhaWxzIHBhcnR3YXkgdGhyb3VnaCBhIG11bHRpLWJ1ZmZlciBp
bmRpcmVjdAo+PiBkZXNjcmlwdG9yLCB0aGUgdW53aW5kIHBhdGggZGVzdHJveXMgUkRNQSBjb250
ZXh0cyBidXQgbGVhdmVzIHN0YWxlCj4+IG5fcndfY3R4IGFuZCBuX3JkbWEgdmFsdWVzIChhbmQg
YSBkYW5nbGluZyByd19jdHhzIHBvaW50ZXIpLiBMYXRlcgo+PiBzcV93cl9hdmFpbCBhY2NvdW50
aW5nIGluIHNycHRfcXVldWVfcmVzcG9uc2UoKSBvciBzcnB0X3dyaXRlX3BlbmRpbmcoKQo+PiBj
YW4gdGhlbiBzdWJ0cmFjdCB0aGUgd3JvbmcgbnVtYmVyIG9mIHNlbmQgcXVldWUgY3JlZGl0cy4K
Pj4gCj4+IFJlc2V0IHRoZSBjb3VudGVycyBhbmQgY2xlYXIgcndfY3R4cyBhZnRlciBmcmVlaW5n
IHRoZSBoZWFwCj4+IGFsbG9jYXRpb24gYmVmb3JlIHJldHVybmluZyBhbiBlcnJvci4KPj4gCj4+
IEZpeGVzOiBiOTlmOGU0ZDdiY2QgKCJJQi9zcnB0OiBjb252ZXJ0IHRvIHRoZSBnZW5lcmljIFJE
TUEgUkVBRC9XUklURSBBUEkiKQo+PiBTaWduZWQtb2ZmLWJ5OiBUYW5aaGVuZyA8dGFuemhlbmdA
a3lsaW5vcy5jbj4KPj4gLS0tCj4+IHYyOgo+PiAtIEFmdGVyIGtmcmVlKCksIHNldCByd19jdHhz
IHRvIE5VTEwgaW5zdGVhZCBvZiAmc19yd19jdHgKPj4gICAgKExlb24gUm9tYW5vdnNreSkKPj4g
Cj4+ICAgZHJpdmVycy9pbmZpbmliYW5kL3VscC9zcnB0L2liX3NycHQuYyB8IDYgKysrKystCj4+
ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+PiAKPj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvc3JwdC9pYl9zcnB0LmMgYi9kcml2
ZXJzL2luZmluaWJhbmQvdWxwL3NycHQvaWJfc3JwdC5jCj4+IGluZGV4IGY2NmNmZDcwYzI2My4u
YTljNDk5NWFmN2EzIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvdWxwL3NycHQv
aWJfc3JwdC5jCj4+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvc3JwdC9pYl9zcnB0LmMK
Pj4gQEAgLTEwMTQsOCArMTAxNCwxMiBAQCBzdGF0aWMgaW50IHNycHRfYWxsb2NfcndfY3R4cyhz
dHJ1Y3Qgc3JwdF9zZW5kX2lvY3R4ICppb2N0eCwKPj4gICAJCQkJY3R4LT5zZywgY3R4LT5uZW50
cywgZGlyKTsKPj4gICAJCXRhcmdldF9mcmVlX3NnbChjdHgtPnNnLCBjdHgtPm5lbnRzKTsKPj4g
ICAJfQo+PiAtCWlmIChpb2N0eC0+cndfY3R4cyAhPSAmaW9jdHgtPnNfcndfY3R4KQo+PiArCWlm
IChpb2N0eC0+cndfY3R4cyAhPSAmaW9jdHgtPnNfcndfY3R4KSB7Cj4+ICAgCQlrZnJlZShpb2N0
eC0+cndfY3R4cyk7Cj4+ICsJCWlvY3R4LT5yd19jdHhzID0gTlVMTDsKPj4gKwl9Cj4+ICsJaW9j
dHgtPm5fcndfY3R4ID0gMDsKPj4gKwlpb2N0eC0+bl9yZG1hID0gMDsKPj4gICAJcmV0dXJuIHJl
dDsKPj4gICB9Cj4KPlRoZSBhYm92ZSBsb29rcyB3cm9uZyB0byBtZS4gSW4gdGhlIGVycm9yIHBh
dGggaW9jdHgtPm5fcndfY3R4IHNob3VsZCBiZQo+cmVzdG9yZWQgdG8gdGhlIHZhbHVlIGl0IGhh
ZCBhdCB0aGUgc3RhcnQgb2YgdGhlIGZ1bmN0aW9uIGluc3RlYWQgb2YKPnJlc2V0dGluZyBpdCB0
byB6ZXJvLgo+Cj5CYXJ0LgoKSGkgQmFydCwKCkkgaGF2ZSBhIHF1ZXN0aW9uIGFib3V0IHJlc3Rv
cmluZyBuX3J3X2N0eC9uX3JkbWEgZnJvbSBsb2NhbApzbmFwc2hvdHMgdmVyc3VzIGNsZWFyaW5n
IHRoZW0gdG8gMCBvbiB0aGUgdW53aW5kIHBhdGguCgpMb29raW5nIGF0IHRoZSBjYWxsIGNoYWlu
OgogIHNycHRfaGFuZGxlX25ld19pdSgpCiAgICAtPiBzcnB0X2dldF9zZW5kX2lvY3R4KCkgICAv
KiBzZXRzIG5fcmRtYSA9IDAsIG5fcndfY3R4ID0gMCAqLwogICAgLT4gc3JwdF9nZXRfZGVzY190
YmwoKQogICAgICAgICAtPiBzcnB0X2FsbG9jX3J3X2N0eHMoKQoKc28gd2hlbiBzcnB0X2FsbG9j
X3J3X2N0eHMoKSBpcyBlbnRlcmVkLCBib3RoIGNvdW50ZXJzIGFyZSBhbHJlYWR5CjAuICBPbiB0
aGUgY3VycmVudCBjYWxsIHBhdGgsIGFzc2lnbmluZyAwIG9uIHVud2luZCBzZWVtcwplcXVpdmFs
ZW50IHRvIHJlc3RvcmluZyB0aGUgdmFsdWVzIHNhdmVkIGF0IGZ1bmN0aW9uIGVudHJ5LgoKSXMg
dGhlIHNhdmUvcmVzdG9yZSBwcmVmZXJyZWQgYmVjYXVzZSB0aGUgbG9vcCBzdGFydHMgZnJvbQpp
b2N0eC0+bl9yd19jdHggKGkuZS4gdGhlIGZ1bmN0aW9uIGlzIHdyaXR0ZW4gYXMgaWYgaXQgbWF5
IGV4dGVuZAphbiBleGlzdGluZyBhbGxvY2F0aW9uKSwgb3IgaXMgdGhlcmUgYW5vdGhlciByZWFz
b24gdG8gcHJlZmVyIGl0Cm92ZXIgY2xlYXJpbmcgdG8gMD8KClRoYW5rcywKVGFuWmhlbmc=
