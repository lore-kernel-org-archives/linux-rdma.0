Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE927FD74;
	Mon, 20 Jul 2026 02:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784513512; cv=none; b=PAN7owZye3pviTxbnu9KCmNoxYwD1ejQGBKson8kLSdcO7wJkBvii/bl+Zee/poXNYEZpWIsRSA9HJiEJsofh4W76bLXvWuaRZ738sb2jiij+3JusmVpBAAwQjGRtaZ8e8LbBNZN0kyBwE+0c1SmjsYRSd+AM3r9TMRImPjvMDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784513512; c=relaxed/simple;
	bh=LLWJ0ruC1iFAdMLHYzsySTE5Dk8YEWW7Kx1cCHLGrlM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=FFJDOZVTvac0upJ0lhja/5s1LCEDC8YewEegaiwei7PB7gC0Vr5UgyhjqfXXKf0lQWg9bTmJjsTbylbYVhWfAlt+ncmOqeaULjHB+jHD+sHSFoXkyRaxW4+2EOzuoU1Fn0zQx0kcQf64TarZpFBubqB+VnnkkjJWcGuH5OSl62I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fDrG4GN4; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fDrG4GN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=LLWJ0ruC1iFAdMLHYzsySTE5Dk8YEWW7Kx1cCHLGrlM=; b=f
	DrG4GN4uYjA26qkaWw/1yQSN07OVkv9+QDp7aAUmyRGQfz+Mb4ovAoxo7iYq0Q/9
	jk3mEXUe3TNYuCxiQZKRFDewZuZEq0IMkbVN0xxLhEH0PO1sgwGbAb3M4A+uGO0A
	evOJvkrWCpzel1tOdilVmYQRDc7C3iQQBmKy3lDDoQ=
Received: from kensanya$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-140 (Coremail) ; Mon, 20 Jul 2026 10:10:34 +0800
 (CST)
Date: Mon, 20 Jul 2026 10:10:34 +0800 (CST)
From: kensanya  <kensanya@163.com>
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, jgg@ziepe.ca,
	leon@kernel.org
Subject: Re:Re: [QUESTION] RDMA/srpt: is target_send_busy() safe before
 target_init_cmd()?
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <9f5875f8-2ab0-4272-a8a3-d6cf711978b5@acm.org>
References: <20260717025402.64054-1-kensanya@163.com>
 <9f5875f8-2ab0-4272-a8a3-d6cf711978b5@acm.org>
X-NTES-SC: AL_Qu2TBvmavEwo4iKYYukcnkcTg+k8WMW1ufsg2Ydec94FlB3O6wcvU15/MUTw7uuzMz6wkSaMUilI0/9CQrl3Ph7SMYVPUovFD3sVZss8cQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <63578cf8.1b55.19f7d4a126c.Coremail.kensanya@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jCgvCgD3v5ebg11qfusgAA--.2224W
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbCwRv41Gpdg5tr2gAA3o
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA3LTE4IDAxOjU5OjM1LCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2NoZUBh
Y20ub3JnPiB3cm90ZToKPk9uIDcvMTYvMjYgNzo1NCBQTSwga2Vuc2FueWFAMTYzLmNvbSB3cm90
ZToKPj4gMS4gSXMgY2FsbGluZyB0YXJnZXRfc2VuZF9idXN5KCkgYmVmb3JlIHRhcmdldF9pbml0
X2NtZCgpIGludGVudGlvbmFsIC8KPj4gICAgIGtub3duLXNhZmU/Cj4KPkkgdGhpbmsgdGhhdCdz
IGEgYnVnLgo+Cj4+IDIuIElmIG5vdCwgc2hvdWxkIGliX3NycHQuYyBzZW5kIGEgZmFicmljLWxv
Y2FsIFNSUF9SU1AgQlVTWSAob3Igb3RoZXJ3aXNlCj4+ICAgICBmcmVlIHRoZSBzZW5kIGlvY3R4
KSB3aGVuIHNlX3RmbyBpcyB1bnNldCwgYW5kIGtlZXAgdGFyZ2V0X3NlbmRfYnVzeSgpCj4+ICAg
ICBvbmx5IGZvciB0aGUgcG9zdC1pbml0IGZhaWx1cmUgcGF0aD8KPgo+SG93IGFib3V0IHN3YXBw
aW5nIHRoZSBvcmRlciBvZiB0aGUgdGFyZ2V0X2luaXRfY21kKCkgYW5kCj5zcnBfZ2V0X2Rlc2Nf
dGJsKCkgY2FsbHMgYW5kIGluaXRpYWxpemluZyAuZGF0YV9sZW5ndGggYW5kIAo+LmRhdGFfZGly
ZWN0aW9uIGFmdGVyIHRoZSBzcnBfZ2V0X2Rlc2NfdGJsKCkgY2FsbD8KPgo+VGhhbmtzLAo+Cj5C
YXJ0LgoKSGmjrApCYXJ0CgpUaGlzIHBsYW4gaW52b2x2ZXMgZmV3ZXIgY2hhbmdlcy4gUGVyaGFw
cyBJIGNvdWxkIHN1Ym1pdCBhIGZpeCBwYXRjaC4KClRoYW5rcwpUYW5aaGVuZwoK
