Received: from outbound.baidu.com (mx14.baidu.com [220.181.3.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B831B377006
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 08:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424106; cv=none; b=Q9lsDInrRoRRqWbkYuI84Am9HgfxV4+NLNc1HvKjlxBQJzIEGL/RQZ/CoZZAZdqaojQn7G0tlN7xOpCx+LVYlGgEr6bH2kJ5FROgyQfn9lKK4I60koLG20LEOfLgmofTF12lVUgTzF+LDMWFUueYJPY4C2MCxXyJXs+ZgQjTT1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424106; c=relaxed/simple;
	bh=9sspEhoRzO3/GHzhfWlvCjlXy7sX7gEUAHC1woFjEVA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k1p/LqlJaoopHpY6NP9vZaZWrgAm7GzGAbpLOu28YWIQzDoOm52erQiNuNBnJbIF8RxV8kIDQtb+TH6mIpYxAMBWiaJKlFAKxBC3NnYK+2UzSMbam8ajW6R+OTVEVBojSZp3IxXnQcaIBIhLNlAn+5uMiNSrUU3jj/PyB07dNdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=HU/unS+3; arc=none smtp.client-ip=220.181.3.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="HU/unS+3"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, Edward
 Srouji <edwards@nvidia.com>, Michael Guralnik <michaelgur@nvidia.com>, Tao
 Cui <cuitao@kylinos.cn>, Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Michael Margolin <mrgolin@amazon.com>, David Ahern <dsahern@kernel.org>, Zhu
 Yanjun <yanjun.zhu@linux.dev>, <linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/nldev: Put the device when dellink fails
Date: Thu, 3 Sep 2026 16:25:50 +0800
Message-ID: <20260903082550.2257-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc9.internal.baidu.com (172.31.50.19) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1788423962;
	bh=Ob4d+Olz7goUaGYWpEZiBHu3PIgWA9XvNxkJ6nwQpLw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=HU/unS+3PhTJBFNrerLEjx6gVhrdyJXAgNAOw+38hP5TjYfqTmtuY0Fdj4RzDaB+0
	 i0ee89sOhPTDmyubASeQKAVd4gbsJa5yeEE3c4kuSD7soyl2WJgL/cldwQh4S++dtF
	 re4AmI700gNbpwiBD2ITsBV3WOqnlqeOx8pJ0YhfTs07es7qTRxzn5fznxhg7wfLgF
	 4jeyxTaZlniu4KnrsHl7Xi6jr1CwpxLA2F6EClGBopbihPTyrBRRjRmi4VdEzy/RNh
	 EHUx1396xUxFXZkRLL3hqhKc0HGTb5ogpTIx1kea0oUXzFD21AfYNL+Yv7UbtsPHY6
	 lTc33WUjZfYDg==

From: Li RongQing <lirongqing@baidu.com>

nldev_dellink() takes a device reference through
ib_device_get_by_index() and normally hands it over to
ib_unregister_device_and_put(). The error path of the ->dellink
callback returns without releasing it, so the reference is leaked.

Once that happens, any later unregistration of the device blocks
forever, because disable_device() drops its own reference and then
waits for the refcount to drain. No in-tree driver returns an error
from ->dellink today, so the leak is currently latent.

Put the device before returning the error.

Fixes: a60e3f3d6fba ("RDMA/nldev: Add dellink function pointer")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/nldev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index a4014a2..a1542ed 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1895,8 +1895,10 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		mutex_lock(&nldev_dellink_mutex);
 		err = device->link_ops->dellink(device);
 		mutex_unlock(&nldev_dellink_mutex);
-		if (err)
+		if (err) {
+			ib_device_put(device);
 			return err;
+		}
 	}
 
 	ib_unregister_device_and_put(device);
-- 
2.9.4

