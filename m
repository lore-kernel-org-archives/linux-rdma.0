Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3B923BCEE;
	Mon, 20 Jul 2026 03:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784516746; cv=none; b=eqUJDx9CJAmWvWM+ewbsEwYvAo0T1Vvdn/tRS+E1O8pyto1RNyO5I0LRz2etLX45I2TCibGjJPpnGDjOqbnok042KJQjLc/ewdU4icI202MjX5WMSSJiFEu0N9Wlx5V0rDs3bFO9rhi/Dwmw5FAbaX995+WNkQrK9MdinyaN7Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784516746; c=relaxed/simple;
	bh=3SN9Am7vZqA1B9+d1tdRf8vEHqcOGpymATh/94O+ghA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=CnXhylyTllbHYt/yw+7yjaVhv4rwLMSrFr47QlBhKSZefKvByMhjjWSRdhW7Aye6uwnakDfd19XmgseZkocfHjIiMGJgFdFcU9dVHLJlkf0tuWMT780dLrgGVCUhHF3XvMeI/F0EZTjay/bLOkixUGyNrSTYrO9QNC7qD55/W2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RmbnRRZr; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RmbnRRZr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=3SN9Am7vZqA1B9+d1tdRf8vEHqcOGpymATh/94O+ghA=; b=R
	mbnRRZrjafS33q/zfl26ZMvXO3zFzxcBdLy7xiRVo736alPftwkl3STb2XILf4fR
	7y4oiswzpRv9W7Ce1pE316YYCKYNBY2yP1CBcfvWsJwfg34khCVSG49e24C2kp83
	mf4MLbLLXIqXMmC3djLOWSBjfYX7CH9ZbqHDC+NT4s=
Received: from kensanya$163.com ( [116.128.244.171] ) by
 ajax-webmail-wmsvr-40-140 (Coremail) ; Mon, 20 Jul 2026 11:05:23 +0800
 (CST)
Date: Mon, 20 Jul 2026 11:05:23 +0800 (CST)
From: kensanya  <kensanya@163.com>
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, jgg@ziepe.ca,
	leon@kernel.org
Subject: Re:Re:Re: [QUESTION] RDMA/srpt: is target_send_busy() safe before
 target_init_cmd()?
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <63578cf8.1b55.19f7d4a126c.Coremail.kensanya@163.com>
References: <20260717025402.64054-1-kensanya@163.com>
 <9f5875f8-2ab0-4272-a8a3-d6cf711978b5@acm.org>
 <63578cf8.1b55.19f7d4a126c.Coremail.kensanya@163.com>
X-NTES-SC: AL_Qu2TBvmauU8p5SOeY+kcnkcTg+k8WMW1ufsg2Ydec94FlB3O6wcvU15/MUTw7uuzMz6wkSaMUilI0/9CQrl38bbr9mC3S6cunuxA4Sk5fw==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <738d1559.2ada.19f7d7c42ae.Coremail.kensanya@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jCgvCgD3n49zkF1qtAAhAA--.2344W
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6hMyDmpdkHM6iQAA3i
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA3LTIwIDEwOjEwOjM0LCAia2Vuc2FueWEiIDxrZW5zYW55YUAxNjMuY29tPiB3
cm90ZToKPgo+QXQgMjAyNi0wNy0xOCAwMTo1OTozNSwgIkJhcnQgVmFuIEFzc2NoZSIgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4gd3JvdGU6Cj4+T24gNy8xNi8yNiA3OjU0IFBNLCBrZW5zYW55YUAxNjMu
Y29tIHdyb3RlOgo+Pj4gMS4gSXMgY2FsbGluZyB0YXJnZXRfc2VuZF9idXN5KCkgYmVmb3JlIHRh
cmdldF9pbml0X2NtZCgpIGludGVudGlvbmFsIC8KPj4+ICAgICBrbm93bi1zYWZlPwo+Pgo+Pkkg
dGhpbmsgdGhhdCdzIGEgYnVnLgo+Pgo+Pj4gMi4gSWYgbm90LCBzaG91bGQgaWJfc3JwdC5jIHNl
bmQgYSBmYWJyaWMtbG9jYWwgU1JQX1JTUCBCVVNZIChvciBvdGhlcndpc2UKPj4+ICAgICBmcmVl
IHRoZSBzZW5kIGlvY3R4KSB3aGVuIHNlX3RmbyBpcyB1bnNldCwgYW5kIGtlZXAgdGFyZ2V0X3Nl
bmRfYnVzeSgpCj4+PiAgICAgb25seSBmb3IgdGhlIHBvc3QtaW5pdCBmYWlsdXJlIHBhdGg/Cj4+
Cj4+SG93IGFib3V0IHN3YXBwaW5nIHRoZSBvcmRlciBvZiB0aGUgdGFyZ2V0X2luaXRfY21kKCkg
YW5kCj4+c3JwX2dldF9kZXNjX3RibCgpIGNhbGxzIGFuZCBpbml0aWFsaXppbmcgLmRhdGFfbGVu
Z3RoIGFuZCAKPj4uZGF0YV9kaXJlY3Rpb24gYWZ0ZXIgdGhlIHNycF9nZXRfZGVzY190YmwoKSBj
YWxsPwo+Pgo+PlRoYW5rcywKPj4KPj5CYXJ0Lgo+Cj5IaaOsCj5CYXJ0Cj4KPlRoaXMgcGxhbiBp
bnZvbHZlcyBmZXdlciBjaGFuZ2VzLiBQZXJoYXBzIEkgY291bGQgc3VibWl0IGEgZml4IHBhdGNo
Lgo+Cj5UaGFua3MKPlRhblpoZW5nCj4KSGkgCkJhcnQKCkhvdyBhYm91dCB0aGlzPyAKaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwNzIwMDI1OTQxLjY5ODA5LTEta2Vuc2FueWFAMTYz
LmNvbS8KClRoYW5rcwpUYW5aaGVuZw==
