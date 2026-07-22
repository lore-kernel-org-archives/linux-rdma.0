Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38E437B40E;
	Wed, 22 Jul 2026 01:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784685199; cv=none; b=d0ONCflgHODYdFD6Q3qiV0CxWxZ73w9iW1EzNi6xewCWeZsxF2wDbXNH4bGDlUDMG+nGw8I1ERtI38w2S3tyhMAvV0wJhBi21vIEUGEYBpX/BKRQjgyFl4oCPRcwxLeOddKmJG2GYmUchR6zeBdgrP00M0Ja8MqBFYs2/n1lQ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784685199; c=relaxed/simple;
	bh=c3+qiVfVOhCDSZ4Df8vmy8w2UpeWdkx9CF/vkAcRjQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=BGnoBLl5uixx3lk5QtlOzb2mG6e4lkM+p1wbMU60jJgnbEP3T58YcSINL5op/RdXSKVYKRwuMSNXxQR0evAi1rpg0FuiwpvXJrPiidLQ2xuUyIsPQGJkwp9Tp4HEdFvdCrp0d9uwif5v+Byt0DxTujpxpY+MnmgsFYtj5HmnSMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZRo/i/1X; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZRo/i/1X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=c3+qiVfVOhCDSZ4Df8vmy8w2UpeWdkx9CF/vkAcRjQs=; b=Z
	Ro/i/1X7BaX6eFoQPjmOgU/8KktiZvKvPgcs9NXOFnMJ28FPWd5qc9cb7TPwBqtl
	hIby7rqUsRPRvMpsfTRYvoBMKWefY+MYKAa5sxfmAiydugJcKLKRfAQsXGxgXwIJ
	g1cz9/D0G+OdWj4m7Hp8x6NPkKatSMEeXazh22LQbc=
Received: from kensanya$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-110 (Coremail) ; Wed, 22 Jul 2026 09:52:42 +0800
 (CST)
Date: Wed, 22 Jul 2026 09:52:42 +0800 (CST)
From: kensanya  <kensanya@163.com>
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re:Re: [PATCH] RDMA/srpt: fix NULL deref when sending BUSY before
 target_init_cmd()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <e5c8e258-8c57-40c8-88a9-04173392e9ae@acm.org>
References: <20260720025941.69809-1-kensanya@163.com>
 <e5c8e258-8c57-40c8-88a9-04173392e9ae@acm.org>
X-NTES-SC: AL_Qu2TBvqTukkt5CORYekcnkcTg+k8WMW1ufsg2Ydec+YEgS3E+woGfW5/I0TN3tu3GwaMniSFaAJ1189Gfox/meL4qeCteWDEXQfoAmwjwA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <41ddb3a1.16d1.19f87866fa1.Coremail.kensanya@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bigvCgD390lrImBqbuYiAA--.494W
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6QtVMWpgImuJaQAA3l
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA3LTIxIDAwOjMxOjU4LCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2NoZUBh
Y20ub3JnPiB3cm90ZToKPk9uIDcvMTkvMjYgNzo1OSBQTSwga2Vuc2FueWFAMTYzLmNvbSB3cm90
ZToKPj4gKwlyYyA9IHRhcmdldF9pbml0X2NtZChjbWQsIGNoLT5zZXNzLCAmc2VuZF9pb2N0eC0+
c2Vuc2VfZGF0YVswXSwKPj4gKwkJCSAgICAgc2NzaWx1bl90b19pbnQoJnNycF9jbWQtPmx1biks
IDAgLyogZGF0YV9sZW4gKi8sCj4+ICsJCQkgICAgIFRDTV9TSU1QTEVfVEFHLCBETUFfTk9ORSwg
VEFSR0VUX1NDRl9BQ0tfS1JFRik7Cj4+ICsJaWYgKHJjICE9IDApIHsKPj4gKwkJcHJfZGVidWco
InRhcmdldF9pbml0X2NtZCgpIHJldHVybmVkICVkIGZvciB0YWcgJSNsbHhcbiIsIHJjLAo+PiAr
CQkJIHNycF9jbWQtPnRhZyk7Cj4+ICsJCWdvdG8gYnVzeTsKPj4gKwl9Cj4KPlRoaXMgd2lsbCBj
YXVzZSB0YXJnZXRfc2VuZF9idXN5KCkgdG8gYmUgY2FsbGVkIG9uIGFuIHVuaW5pdGlhbGl6ZWQg
Cj5jb21tYW5kIGFuZCB0aGF0IGlzbid0IGFsbG93ZWQsIGlzbid0IGl0Pwo+Cj5UaGFua3MsCj4K
PkJhcnQuCgpZb3UgYXJlIHJpZ2h0IHRoYXQgdGFyZ2V0X3NlbmRfYnVzeSgpIG11c3Qgbm90IGJl
IHVzZWQgd2hlbgp0YXJnZXRfaW5pdF9jbWQoKSBmYWlsczogdGhlIGNvbW1hbmQgaXMgbm90IGZ1
bGx5IHNldCB1cCBmb3IgdGhlCnRhcmdldC1jb3JlIGNvbXBsZXRpb24gcGF0aCAoZS5nLiBjbWRf
Y250IHdhcyBub3QgdGFrZW4gb24KLUVTSFVURE9XTikuIFRoYXQgZ290by1idXN5LW9uLWluaXQt
ZmFpbHVyZSBwYXRoIGFscmVhZHkgZXhpc3RlZApiZWZvcmUgdGhlIHJlb3JkZXIuCgpIb3cgYWJv
dXQgdGhlIGZvbGxvd2luZyBwbGFuPwogIC0gSWYgdGFyZ2V0X2luaXRfY21kKCkgZmFpbHM6CiAg
ICAgIHJlbGVhc2UgdGhlIHNlbmQgaW9jdHggbG9jYWxseSB2aWEgdGFyZ2V0X2ZyZWVfdGFnKGNo
LT5zZXNzLCBjbWQpCiAgICAgIGFuZCBkbyBub3QgY2FsbCB0YXJnZXRfc2VuZF9idXN5KCkKICAt
IElmIHRhcmdldF9pbml0X2NtZCgpIHN1Y2NlZWRzIGJ1dCBhIGxhdGVyIHN0ZXAgZmFpbHMKICAg
IChlLmcuIHNycHRfZ2V0X2Rlc2NfdGJsKCkpOgogICAgICBrZWVwIHVzaW5nIHRhcmdldF9zZW5k
X2J1c3koY21kKQoKVGhhbmtzo6wKVGFuWmhlbmc=
