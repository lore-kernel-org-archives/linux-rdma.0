Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BE947533C
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805483; cv=none; b=OPi6SsjFiwLsiKpxq13GUhAbY2XvvSDYvkZATtNLrAFfKYIrVgWGg9lbh9XGo8t5UHsyJCCzsnkiir/hDf8d7lDHJS2kw5UfvUhg0GYcBxbH5o4ay673ZmuOGLvgNYNzPylHq8YF3r0DYJANYau5c/L9nx1Qpv7enRXbpbvckRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805483; c=relaxed/simple;
	bh=DPGdWzT1CJcG0Yk1taVhln21IgwRRBWxi+igSzrXD7I=;
	h=Subject:In-Reply-To:To:Content-Type:References:Mime-Version:From:
	 Message-Id:Cc:Date; b=KdOotMV+gfi6TSdyoUeCj1nLazQhdseJFzMvqiRRvqPGLhaVt5WsUZcSBEMmf6On5MWxuM74XQmdrighZCwLUcZu0wUtQqCUdQUidWacIJDQkw7leGScKBzl21gnY27uGuHpxb5vURVfkserP+OabDmC8Eu8iVSM2+qQj1NJNUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=If8viC/j; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="If8viC/j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805472; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=koqUHj3+MS63DOSiOOGzZI3vsnbqGHyGSggg6dem0bw=;
 b=If8viC/jspqBn03cNaA80ImbuLrdR6vs2aFH8OYLcCz7tdatrKrc61dWCPkTKZrAyvBNa2
 7jBou5LIbq5or1a76qrKpHpv/6OSGzg3qdEixJ4uUuy3EMCkEixCNaxzl24acQbyN5JwoY
 4ZDUh8FkBi0H3Cj8+1a2C8fkHKSFLtDKqzSKDdJ2hjA883a2QYhtdR2gf/WpaCJuFsFWTd
 WxA+5qRFATpCQnI+XgcdQG73N9XrgvOUNVEkzj/ohgaNqRl99hHsts2hV/Peg9QDBNyt1x
 WCilADbvjmDeZxG3zjJaSl+QyypNwhxtwmMm6CecmlasHbwTQPNjUCIwQHZnTA==
Subject: [PATCH 15/15] MAINTAINERS: add the Yunsilicon XSC drivers
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:29 +0800
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26accc81e+62f4bd+vger.kernel.org+tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Xin Tian" <tianx@yunsilicon.com>
Message-Id: <20261012114428.2471317-16-tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Oct 2026 19:44:29 +0800

Add an entry covering the Yunsilicon XSC ethernet and RDMA drivers, with
the netdev and linux-rdma lists on Cc.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c24144478..34902a130 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -30069,6 +30069,15 @@ S:	Maintained
 F:	Documentation/input/devices/yealink.rst
 F:	drivers/input/misc/yealink.*
 
+YUNSILICON XSC DRIVERS
+M:	Honggang Wei <weihg@yunsilicon.com>
+M:	Xin Tian <tianx@yunsilicon.com>
+L:	netdev@vger.kernel.org
+L:	linux-rdma@vger.kernel.org
+S:	Maintained
+F:	drivers/infiniband/hw/xsc
+F:	drivers/net/ethernet/yunsilicon/xsc
+
 ZD1211RW WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
 S:	Orphan
