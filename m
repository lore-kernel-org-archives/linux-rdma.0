Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0BF40855
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 04:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297868; cv=none; b=WYx0vOf/PBbeFFA/7VJ0/iLZpaJYtGv2E3v/dTz+aQzDB/NZPKdj+rcj6K4IxMQ79bALezMBgb2f+xHTn0IVsnEkMicepGugFNgniLfKBYPPV4+R/TNncR9prQn9l+7yP5cWuvT63BvsyDuR4klGjXUQv/g+3QAy6Xxxa1pM+h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297868; c=relaxed/simple;
	bh=k106ttuviyeqPVGbR8VmDsHUFVmjTNg1fWTyI7YGsIo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=PATUyltQgOR3innuG9GouO4MzWXfnmIAUCGOBjQ2IgWbeC54odFWzXX1dNyEP7nJ4bjgqYdgn/qC5uUmR+qhkvrqp0h1SQLBqvTyQKmZbqn1hSLE+zffBjE26pf2/7uodPG7t/dPaQISVOU0Z2dgew4sO0810yn2T5BB+qXvYEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XUJWSK+7; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XUJWSK+7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=k106ttuviyeqPVGbR8VmDsHUFVmjTNg1fWTyI7YGsIo=; b=X
	UJWSK+7s/i5ay8r4ZAvq2wZQSp3zqbNojb5uhS4rBPeRnsxGudYjhevYn9A5wFrZ
	pUyWUgdBxwuTWdt/yRZFU5zI/PbPVZKeREsfQfUi3eBlbVAlG00jcl8rwxlaUhZl
	o1gf4xXaCdOC0VFVI+A/4SuBjE0G+xSkUNTUOViQZc=
Received: from kensanya$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-110 (Coremail) ; Wed, 29 Jul 2026 12:04:00 +0800
 (CST)
Date: Wed, 29 Jul 2026 12:04:00 +0800 (CST)
From: kensanya  <kensanya@163.com>
To: "Leon Romanovsky" <leon@kernel.org>
Cc: bvanassche@acm.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re:Re: Re: Re: [PATCH v2] RDMA/srpt: fix NULL deref when sending
 BUSY before target_init_cmd()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20260727090046.GJ12003@unreal>
References: <20260723024456.52851-1-kensanya@163.com>
 <20260723095120.GF110966@unreal>
 <56479481.2552.19f920118cd.Coremail.kensanya@163.com>
 <20260726075511.GC12003@unreal>
 <71e36b0d.4e93.19fa24c787d.Coremail.kensanya@163.com>
 <20260727090046.GJ12003@unreal>
X-NTES-SC: AL_Qu2TB/6SuEAv5iKabekcnkcTg+k8WMW1ufsg2Ydec+YElAzqwwoGRVNBHEnb782vMTuRogmmYjlt1tZdeoVyzOxGXD4Bf6f9C3UPO+ogkw==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <6174be4b.35cc.19fac0b286c.Coremail.kensanya@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bigvCgD331axe2lqFosnAA--.3542W
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6hEA22ppe7FUAAAA39
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgoKPj4gVGhlcmUgaXMgYSBjb250cmFkaWN0aW9uIGJldHdlZW4gdGhlIHR3byBzdWdnZXN0aW9u
czoKPj4gLSBCYXJ0IHN1Z2dlc3RzIGNhbGxpbmcgdGFyZ2V0X2luaXRfY21kKCkgYmVmb3JlIGNh
bGxpbmcKPj4gICAgc3JwdF9nZXRfZGVzY190YmwoKSAodXNpbmcgYSBwbGFjZWhvbGRlcikgdG8g
ZW5zdXJlIHRoYXQKPj4gICAgdGFyZ2V0X3NlbmRfYnVzeSgpIGNhbiBiZSBzYWZlbHkgZXhlY3V0
ZWQgaWYgdGhlCj4+ICAgIGRlc2NyaXB0b3IgcGFyc2luZyBmYWlscy4KPj4gLSBMZW9uIHBvaW50
cyBvdXQgdGhhdCB0YXJnZXRfaW5pdF9jbWQoKSBtdXN0IHJlY2VpdmUgdGhlCj4+ICAgYWN0dWFs
IGRhdGEgZGlyZWN0aW9uIGNhbGN1bGF0ZWQgYnkgc3JwdF9nZXRfZGVzY190YmwoKSwKPj4gICBy
YXRoZXIgdGhhbiBhIHBsYWNlaG9sZGVyIGxpa2UgRE1BX05PTkUgdGhhdCB3aWxsCj4+ICAgYmUg
b3ZlcndyaXR0ZW4gbGF0ZXIuCj4+IAo+PiBJZiB3ZSBjb250aW51ZSB0byBtb2RpZnkgdGhlIGN1
cnJlbnQgcGF0Y2gsIHRoZSBvbmx5IHdheSBJCj4+IGNhbiB0aGluayBvZiBpcyB0byBleHRyYWN0
IHRoZSBkaXJlY3Rpb24gcGFyc2luZyBsb2dpYyBmcm9tCj4+IHNycHRfZ2V0X2Rlc2NfdGJsIGFu
ZCBwbGFjZSBpdCBiZWZvcmUgdGFyZ2V0X2luaXRfY21kLCBzbwo+PiB0aGF0IHRhcmdldF9pbml0
X2NtZCBjYW4gcmVjZWl2ZSB0aGUgY29ycmVjdCBkaXJlY3Rpb24uCj4+IEhvdyBhYm91dCB0aGlz
Pwo+Cj5TYXkgaXQgdG8geW91ciBBSSB0b29sIHRoYXQgaXQgaXMgbm90IGNvbnRyYWRpY3Rpb24s
IGJ1dCB3cm9uZ2x5Cj5pbXBsZW1lbnRlZCBCYXJ0J3Mgc3VnZ2VzdGlvbi4KPgo+VGhhbmtzCj4K
CkFjY29yZGluZyB0byBteSB1bmRlcnN0YW5kaW5nLCBpZiB3ZSBzd2FwIHRoZSBvcmRlciBvZiBz
cnB0X2dldF9kZXNjX3RibAphbmQgdGFyZ2V0X2luaXRfY21kIGFuZCBlbnN1cmUgdGhhdCB0YXJn
ZXRfaW5pdF9jbWQgY2FuIG9idGFpbiB0aGUgY29ycmVjdApkaXJlY3RvcnksIHRoZW4gbXkgaWRl
YSBpcyB0byBleHRyYWN0IHRoYXQgZGlyZWN0b3J5IGZyb20gc3JwdF9nZXRfZGVzY190YmwuCgoK
SWYgbXkgdW5kZXJzdGFuZGluZyBvciBpbXBsZW1lbnRhdGlvbiBkaWZmZXJzIGZyb20gdGhlIHN1
Z2dlc3Rpb25zIHlvdQpwcm92aWRlZCwgSSBoYXZlIGRvbmUgbXkgYmVzdC4KCgpUaGFua3MK
