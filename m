Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807822;
	b=dFCrW6a8nUZMgxG2VPuo2w1iDsLET/YIHetPWaDuZOvHbnSQjv7hmQjHmFQwTAw4q+gG
	 jZvA2BogXWw3kQ1D1CIMu85ErnbGNclWdJFxy98W1VC+Ku4QyMyAEbyuboXbGRuSo7umY
	 yKtj8Be5/AcodGReqJYKm4CItaNJLPiOpMLHT8Agfq5q2ZbSuRQPnoeyhTRhbTO3qt+M/
	 IBRKXGqXhE8t1wms31TEUaywE5BP8ORIswhd4lHiODZ+oCKeuB2jjXgXcncrzEnFjZVDZ
	 rQUDoSZUEdNOmGJujKSqsIfDbApSL5KDmkPnVppw8dnvqrhRqu1kvisbFEnrDwHD8mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807822;
	h=DMARC-Filter:DKIM-Signature:To:Subject:Content-Transfer-Encoding:Cc:
	 In-Reply-To:Received:X-Mailer:References:Content-Type:From:Date:
	 Message-Id:Mime-Version:X-Lms-Return-Path:X-Original-From;
	bh=XYD0toCbOJl1spINj1H4KaSUBqfBdPhnuZcf4yKON+E=;
	b=lvgdw6OarzpbjvcMbkSiSZX1zizhq/5/CwHflNdpC7PIwhjIaKHBa7TOK1ZYjzy6glq+
	 NVkuTMKzUEbL7Vq/n09qxmtLtIUR8T2EKLL/5I7fp+P7jZetFLCMUdSNhIjFWDQpxI1xa
	 kJeY2j2aPIMKSQHOmv1yE4HS3iy7HKRAxikJRb2atyRfxJN2qireoSnXh+bAiK3DyxPal
	 itRroo9gb2q4lbB27/wQ+BI9CHkdwzovwsUKnxbM5/+Fd0HamBBjVFM5AjgokNNwN60ai
	 x+uuveLxijzOHoh1GOAYUt12JcbFoIqnTtZrAIt8mlCzqkEbLf7UhcCrLSivQaunk+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b="fNqE/6+j";
	arc=none smtp.remote-ip=209.127.231.30
Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CFF606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61CFF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=fNqE/6+j
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807815; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=XYD0toCbOJl1spINj1H4KaSUBqfBdPhnuZcf4yKON+E=;
 b=fNqE/6+j6Wz3shN9omF8YYlN1ULWxkD9PX70C7HNTDfYUMfl+FttNgSSnVUhVvRc3uNx7T
 yiW+h0zJzTmZd6n4PcS9HJT0A+rpQythPvaXDRUOPusKL0Ry1EOde0ObqY0OYmcUOk/H+u
 Z8HsFoo0GVbLxsbOG/DDxwDqzXUBIWnPb+tcaI0JL/6rjf4tawOQoNr5gkhm3MbhVodArz
 gxk76Kpn/qtgpNrhn5qbpvk0goEzvxPy6AuxFptoTHJxQvu9dKMZMlddz+KnNXM7Nwe7D9
 joXPlxjnZXZFqlXZ2zlq42HAD4wiQXF0AnqUdZJEEgAbh7RNW3Sim+yXlaxLjw==
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Subject: [PATCH v1 01/15] MAINTAINERS: add the Yunsilicon XSC drivers
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:56:52 +0800
X-Mailer: git-send-email 2.25.1
References: <20261104155650.37053-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
From: "Xin Tian" <tianx@yunsilicon.com>
Date: Wed, 04 Nov 2026 23:56:52 +0800
Message-Id: <20261104155650.37053-2-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aeb55c5+777cca+vger.kernel.org+tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>

Add a MAINTAINERS entry for the Yunsilicon XSC drivers.  The hardware
presents both an ethernet function and an RDMA function, so the entry
covers two subtrees, drivers/net/ethernet/yunsilicon/xsc and
drivers/infiniband/hw/xsc, and lists both netdev and linux-rdma as
list addresses.  The file patterns are declared ahead of the code so
that maintainership is established before the first driver patch
lands.

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
-- 
2.18.4
