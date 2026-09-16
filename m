Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 6A8243DD847;
	Wed, 16 Sep 2026 06:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541102; cv=none; b=RZxcv+3jXZ9FrUUCByUD8/37YcJ0i9CY39v7HCgQsKm7hDpGAXjDkTDMfbeC1lPWBv4YdOk3h/AWVXMSM7RriyQmEry0UDaGWRR5uYw1ORNZ6Hg6ENDcPd9OKkAgpmwB6abpN7bApbMdltDb6uQOJCV3U1DshwZcsvmZD/VOYcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541102; c=relaxed/simple;
	bh=nZ7JLpEHMtrgZiX1Vtnm/Dcm6f6C9r2aMLKKdkDGaD0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qXC9XVXvpZcLg5FzpscTz/m5rzNfXn76nPrwCAQ1VPsoTq/fSsZI27TAPx1Bl9hPVESHr2YKtbCeRpfGt1WV14mGcLilz5Zjt4YGmnbNNAi5D1MrpGCTwSFOeYfsuoNIgteMU/6ptBnpXanlPDBBKdx7dbO7YrHlxe/f8S3mI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=j4Ct4tOg; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="j4Ct4tOg"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Jiri
 Pirko <jiri@resnulli.us>, Yonatan Nachum <ynachum@amazon.com>, Kalesh AP
	<kalesh-anakkur.purayil@broadcom.com>, Michael Margolin <mrgolin@amazon.com>,
	Kees Cook <kees@kernel.org>, Parav Pandit <parav@nvidia.com>, Mark Zhang
	<markzhang@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device()
Date: Wed, 16 Sep 2026 14:44:35 +0800
Message-ID: <20260916064435.2180-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc10.internal.baidu.com (172.31.50.20) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789541085;
	bh=978sEupC+WWvDTbE37Jvxlx9xT8iqIaTRDTUvABmM6M=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=j4Ct4tOgyUAXot9AYxq0xvbuj1gWPAhd6QTvBo2cOPlJZaqLmpx2QCwopOOMHhACZ
	 BljzNQ/5wfMW4vuSzIKe+aXhaSdMC6Vs/9l1m9e8LkbmZkxo4mNS86uidgaWaZmbFK
	 NeRye17wVmKRSk9pFTViThos7CVrDpxvqUYPWvARx193Xi/HuZoiSV2TD3+H1vGa35
	 4If9P/KP/ZfZCJ8H+JxnCfCj2vWwSIZe1gKvLKyRu4uKfzw+B/pS9+DP3HlEncyaOQ
	 Z6vY+efUdUZy3fbWm2sEIV6ky/Dg+XlylRD92nszcUHbICFnqBYkLoSr5W11v/zh5g
	 jciKXd+QM6qMg==

From: Li RongQing <lirongqing@baidu.com>

ib_add_sub_device() links a new sub-device into its parent's sub-device
list with:

	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);

list_add_tail(new, head) expects the node to insert as the first
argument and the list head as the second, so the call above does the
opposite of what was intended: it treats the parent's list head as the
new node and the sub-device's node as the list head.

Because _ib_alloc_device() initialises subdev_list to a self-referencing
empty head, the misplaced insertion does not crash, but it corrupts the
parent->subdev_list_head list.  After adding two or more sub-devices,
only the last one is reachable through the parent's head, and
ib_del_sub_device_and_put()'s list_del() on &sub->subdev_list rewrites
the head pointers, potentially severing earlier sub-devices from the
chain.  During parent teardown, the reverse iteration over
subdev_list_head then skips the orphaned sub-devices, so their
del_sub_dev() callbacks are never invoked and ib_device_put() on the
parent is never paired, leaking both the HW sub-devices and a refcount.

Swap the arguments to match the documented intent: insert the
sub-device node into the parent's list head.

Fixes: bca51197620a ("RDMA/core: Support IB sub device with type "SMI"")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 7a3ed5e..05dd890 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3067,7 +3067,7 @@ int ib_add_sub_device(struct ib_device *parent,
 	sub->parent = parent;
 
 	mutex_lock(&parent->subdev_lock);
-	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);
+	list_add_tail(&sub->subdev_list, &parent->subdev_list_head);
 	mutex_unlock(&parent->subdev_lock);
 
 	return ret;
-- 
2.9.4

