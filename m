Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5EA282F15
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 07:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791097359; cv=none; b=oC/nGvuAJGMwweaQXT9I+6+pIJ4JrBVWUsNDMBSfylEnOCxyCXVZSY/7rL/KJQ7D7tpn/DWR2tc/stlVUNWwIIsc977r1V1U+5MiFowB16S4gNG/Pfe0pi0o9EPWXluIxqoJExEcVBp+zuSzDIPo7mvHGSjtxMytzj/WE0uEV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791097359; c=relaxed/simple;
	bh=44htYIOJWaocVphmMBjew6h+MC8NZQjNoT/P+yaDj/Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=smftYHo3A95/D3J3rke9dqLgRJJ4ZM6iHUfGva6B66AxdnO5iRg9A4qyy0pZ8RtiiRAf7fwEAma1eohDhGQJmMmTK78wHE7X2VeCiiSYi6kPf5krxPu+oQyXubXDD62lVPAoHYjSFtNVjK2TU8mpj4/f8i3Ja460Pc7+fMt6IIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=U9NNiOi3; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="U9NNiOi3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=44htYIOJWaocVphmMBjew6h+MC8NZQjNoT/P+yaDj/Q=; b=U
	9NNiOi3K44C7F+C01GYLI8Ckisau0epJSDY2UdzeK1TpLzEuSriTe7/Uk27ctJcB
	A1uhkpXnjHroxEvv5mpyilv4V5eZo//UupH/0Ldcqjsx7Vh2xZ5FTIu2VNV9jMtw
	n5I9fYUnu+HVM8v9r/y+WRnH2+vyjtuktWGkK6Z+yk=
Received: from 19888972804$163.com (
 [2408:8207:2421:84e0:61d7:4f14:bc92:6eb5] ) by ajax-webmail-wmsvr-40-144
 (Coremail) ; Sun, 4 Oct 2026 15:02:15 +0800 (CST)
Date: Sun, 4 Oct 2026 15:02:15 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org
Subject: Re:Re: [PATCH] RDMA/rxe: Validate inline data range in user WQEs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <862e30b2-5128-4b1b-985d-cd3faa21fc91@linux.dev>
References: <20260924100515.502912-1-yaojiale02@163.com>
 <20260924101736.9FA281F000FF@smtp.kernel.org>
 <a1ef2c45-431f-4dad-b812-0b6cccf9ecc5@linux.dev>
 <1c28994b.869.1a105467816.Coremail.19888972804@163.com>
 <862e30b2-5128-4b1b-985d-cd3faa21fc91@linux.dev>
X-NTES-SC: AL_Qu2SA/ySuEso4yeaY+kdmE8Uges8WcC0svki1YJUc+wGgwDS/RwQQXJ+G1vY7OaCNhuhvT2zTjZ3yOl6eJFAFZUaWI9fDl8kUtulvvDVxQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <6d3b6560.c4b.1a105b86fb5.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:kCgvCgD3_7L3+cFq56BSAA--.4728W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhfGAWrB+fdLbgAA3e
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGkgWWFuanVuLApBdCAyMDI2LTEwLTA0IDE0OjE0OjA0LCAiWmh1IFlhbmp1biIgPHlhbmp1bi56
aHVAbGludXguZGV2PiB3cm90ZToKPgo+1NogMjAyNi8xMC8zIDIxOjU3LCBqaWFsZSB5YW8g0LS1
wDoKPj4+IEhpLCBKaWFsZQo+Pj4KPj4+IFBsZWFzZSBmaXggdGhlIHByb2JsZW0gdGhhdCBTYXNo
aWtvIG1lbnRpb25lZC4gVGhlbiBzZW5kIG91dCBhIG5ldyBjb21taXQuCj4+Pgo+Pj4gVGhhbmtz
IGEgbG90Lgo+Pj4gWWFuanVuIFpodQo+PiBIb3cgYWJvdXQgdGhpcyBvbmUsCj4+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MDkyNjA3MDQwMy4zMDA1MjUwLTEteWFvamlhbGUwMkAx
NjMuY29tLwo+Cj5TYXNoaWtvIHN0aWxsIGNvbXBsYWlucyBzb21ldGhpbmcuIFBsZWFzZSB0cnkg
dG8gZml4IGl0LgoKRml4ZWQgaXQgaW4sIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2
MTAwNDA2NDQ0NS4xNDg4NzUzLTEteWFvamlhbGUwMkAxNjMuY29tLwpTYXNoaWtvIGhhcyByZXZp
ZXdlZCB0aGlzIHBhdGNoIGFuZCBmb3VuZCBubyBpc3N1ZXMuIAoKPgo+VGhhbmtzIGEgbG90Lgo+
Cj5ZYW5qdW4gWmh1Cj4KPj4+Pj4gKwkJcnhlX2RiZ19xcChxcCwgImludmFsaWQgaW5saW5lIGRh
dGEgcmFuZ2UgaW4gc2VuZCB3cWVcbiIpOwo+Pj4+PiArCQl3cWUtPnN0YXR1cyA9IElCX1dDX0xP
Q19RUF9PUF9FUlI7Cj4+Pj4+ICsJCWdvdG8gZXJyOwo+Pj4+PiArCX0KPj4+Pj4gKwo+Pj4+PiAg
ICAJaWYgKHJ4ZV93cWVfaXNfZmVuY2VkKHFwLCB3cWUpKSB7Cj4+Pj4+ICAgIAkJcXAtPnJlcS53
YWl0X2ZlbmNlID0gMTsKPj4+Pj4gICAgCQlnb3RvIGV4aXQ7Cj4KPi0tIAo+QmVzdCBSZWdhcmRz
LAo+WWFuanVuLlpodQoKSmlhbGU=
