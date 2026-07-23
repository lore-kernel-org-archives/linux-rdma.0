Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FA730DECE;
	Thu, 23 Jul 2026 01:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784771739; cv=none; b=DbjUIdbkfmelQFYeX6jnlOE/dQMZ7LZWjSYXWgsPgWRz8qALOkP7jJFjktSKRWpmbMbY7k3a5u5KAqSGzsLiAIPtV20dSeb0bcZ6wCybapO6LdLaXXNOw03UfdbotgRb48xsJ/XJE/CGhgW/P80vqpKh97460P3AXmfkSgpYy+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784771739; c=relaxed/simple;
	bh=l9hwMfjoMMRiyYg5TAwiT37asGm5rWTN309CgVu7Rug=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=ZutayJzdxAB8D1msJAefi7vojKiO5otfu2HgGTI/vjGA72rjy6cx4sIOmLdS82D9Z2Ij2GBG7KXjkOflri4OWgbFH2R6eiDV4W+N+phXWdJU/lkQN8qLhAkEHBB0iwc7ja87ekw/t7yXqVkNy+nAb/FC23MU+3bBB+yAa9AipZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=MufHXH28; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="MufHXH28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=l9hwMfjoMMRiyYg5TAwiT37asGm5rWTN309CgVu7Rug=; b=M
	ufHXH28HO5zK0DmYlSlzy912fSxrARN+dU1WC31LeI2yT/iBLDT/eMX2Pua40LQM
	6soD5YV/DQMxilCuxXDb6Reb6PIU8LNs49zjcpJv2H5hds8DrF5qDCtv5g8tTK7t
	O6p7DN4qdgQ5TNtPrzewI3GQRK8TZsfy3Jv6AmR+eE=
Received: from kensanya$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-142 (Coremail) ; Thu, 23 Jul 2026 09:55:03 +0800
 (CST)
Date: Thu, 23 Jul 2026 09:55:03 +0800 (CST)
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
In-Reply-To: <1ab82159-e644-46ac-9af8-a482e2b0f951@acm.org>
References: <20260720025941.69809-1-kensanya@163.com>
 <e5c8e258-8c57-40c8-88a9-04173392e9ae@acm.org>
 <41ddb3a1.16d1.19f87866fa1.Coremail.kensanya@163.com>
 <1ab82159-e644-46ac-9af8-a482e2b0f951@acm.org>
X-NTES-SC: AL_Qu2TBvucvk8r5SiabekcnkcTg+k8WMW1ufsg2Ydec+EGnjzy1gAMTHFDAXLq1u+AMQm+mjeufQdA5vVleKBi6sn68yRjB28k2heh0Wps0A==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <7630d86b.166f.19f8caef41b.Coremail.kensanya@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jigvCgD3N+13dGFqCncjAA--.2251W
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6hctCWphdHcxJgAA3G
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA3LTIzIDAyOjEwOjEzLCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2NoZUBh
Y20ub3JnPiB3cm90ZToKPk9uIDcvMjEvMjYgNjo1MiBQTSwga2Vuc2FueWEgd3JvdGU6Cj4+IEhv
dyBhYm91dCB0aGUgZm9sbG93aW5nIHBsYW4/Cj4+ICAgIC0gSWYgdGFyZ2V0X2luaXRfY21kKCkg
ZmFpbHM6Cj4+ICAgICAgICByZWxlYXNlIHRoZSBzZW5kIGlvY3R4IGxvY2FsbHkgdmlhIHRhcmdl
dF9mcmVlX3RhZyhjaC0+c2VzcywgY21kKQo+PiAgICAgICAgYW5kIGRvIG5vdCBjYWxsIHRhcmdl
dF9zZW5kX2J1c3koKQo+PiAgICAtIElmIHRhcmdldF9pbml0X2NtZCgpIHN1Y2NlZWRzIGJ1dCBh
IGxhdGVyIHN0ZXAgZmFpbHMKPj4gICAgICAoZS5nLiBzcnB0X2dldF9kZXNjX3RibCgpKToKPj4g
ICAgICAgIGtlZXAgdXNpbmcgdGFyZ2V0X3NlbmRfYnVzeShjbWQpCj4KPlRoYXQgc291bmRzIGdv
b2QgdG8gbWUuCj4KPlRoYW5rcywKPgo+QmFydC4KCkkgd2lsbCBzZW5kIHRoZSB2MiBwYXRjaCBs
YXRlci4KClRoYW5rcywKVGFuWmhlbmcK
