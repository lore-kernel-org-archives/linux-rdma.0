Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C341D13B
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 08:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040693; cv=none; b=qH78LOKYf+g6c3SK7oCyVbsrboDImMumqUhSF96MNywY7f27Z2EJVNcMlkJQxhtK7a9ZwzLtLbKAoNGMoIK1jSXFsRdEqgv6Uc21vhXg9MT5TRCX2OBOnAEicEV46oavNl5MFAVedECn76QvzAema+8rV1bAwydvDBrkH/+FMUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040693; c=relaxed/simple;
	bh=gf6eXb6yvLsmDAdin0XQusCflWSPPesgkp75WkmRxzw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OgCIs1IToSWjUGC3Sxq5Mdq72nNdDG5gg/5dn566u7yiPMf5qIL1gbzLPxKt1oHDK3xi9Y+CwA9EZF1gzMpjmvBdzw6Fk/pCTsrkwFtBBQxcrX0d7jmr+vpr7LmkKcJd68HNPmfU7o8X3SeUVIOh6L+Yi3RcwSFnVd7cY4W9PBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YsfnF5Qp; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsfnF5Qp"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49553da76dcso17299405e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 01:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787040689; x=1787645489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DcPr6p2BuA1D1TqcoH29NRqImIBRYTBu7SBRwCO9aWs=;
        b=YsfnF5QpZMY/76Iv+SvxbhRjzkkhpmebhz9KW+7Se9hLVmNxKn1X+qoyd3VNVIlQbS
         HoP6X22WlVwfUidRStB6N7v71TjNO00pteQ/7PArmpNOtszUQJ1+2977n/5nUpWH6RwO
         Y45EynugjfmDwtPSnfFd1flXAmPTJYgiG5BYBVRCN9QOgrC44mOMRISvMBWCus4+Pwhz
         80ujAZ9n27Z58kJDJapHrcRI00xNvygky7A4zMq7IPcqrqn/nfSOqc/IVgfCGVvRAxll
         njYGpFhupsjruo26jiVx45dWBq3E3ml4D1QyxOzD14XrEYt0tOmC0zehSivsFr9YQSrm
         EG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787040689; x=1787645489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DcPr6p2BuA1D1TqcoH29NRqImIBRYTBu7SBRwCO9aWs=;
        b=c0DL1uGsiC5QcTicYWWI+1rLqPogjQXiU1RVdmkhYxD+RRPQP7zrDuT2fJy3qSnFWn
         BLkUIzXZF7dvF/Ioz0j1c3oehX0hWA9lqe/RXXVZBtJDg0iRmbY5/tpjCRwjdLKn5ypz
         mmwgBBxtNBJOjDa7nPwduaLrKeZcxDpgYeUVnGLJFOZhIRPELIfQnN21AZLPhXZgmSV2
         9fCqtgzd5NveRQh6H/f8ELzgWLBXv38YejVNSoWpbJ9iLSL/gNmVScEpW9+9e5BMsnvU
         295H72m9pZ7ecPkeoTtl8toYOd020hBQFvYpJdAodoto3XMqulHKQ+hO9R2/crCgwb/B
         rspA==
X-Forwarded-Encrypted: i=1; AHgh+Rra6ITmGCV44gNz+Beam92YaEB1HaYazUc/5Feg+aglJqpgPl7RqcH8bAe6l9VY075M3J2ZBnlw4Zhv@vger.kernel.org
X-Gm-Message-State: AOJu0YzITu5BMQdUewxrqkLBt9FcXmTmh+zEudV1iboNuo/8okSjWBD1
	BDBx8xpqWQ5DBRiGJ/WbSPJjg693XuVMQAi16dKsvEY686yVIA7vsaQ6
X-Gm-Gg: AR+sD13YsQ28D/nMhRdAcNeikmNRBRxGA2l4PF4wdOM4VOA0F5DYAiWUbJ9eSJkFg0x
	kZaPYrNdaC8/mrX4qZvcGRsyJLij0ntsFjI2GCWBxt5ed8kw5RxsXBvvB/GeisMQiLtO8avy8D1
	PXrBWro4jTd43WF6msWz7RS3RTvRzLb9gQlDPPVwKUL+6zwnoK/7sBnPD2ov4iJ3lYtA+QH+xpm
	4rGA9T2xSJ6Lp4Bq+xhliQNBOea9hXawHyvq20TaztbJC3Bz+Eshc7yxfXTbFnZH/Zq0YbuMaOC
	xMWLz2vjavYo276Z7Fk9/tPy7CMyQIHRDBOGItOtDymgEvSEqLUwlxzaqSND7OqaHStbhSIqIbT
	1FrgY9F19rvSl78MSrLhk7DcdeJ2PBlAUmSBmLFLcfkDh/gyVRYE1MYz9bMdhjTYle4xsiaA64J
	fuj5pGPA2ms0fDajzfpFkr790FmhOY0FbmYHUXt3uxG1RrT65vKNBHRzEUVqxnK6ZUOue/jo4oc
	IzZCUtoIbgcfpA=
X-Received: by 2002:a05:600c:848e:b0:499:8156:cd3f with SMTP id 5b1f17b1804b1-4999fb3f78bmr105368795e9.8.1787040688315;
        Tue, 18 Aug 2026 01:11:28 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d10ba73sm115165235e9.13.2026.08.18.01.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 01:11:27 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Parav Pandit <parav@nvidia.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/core: Fix use-after-free when netns exit races compat dev removal
Date: Tue, 18 Aug 2026 11:09:20 +0300
Message-ID: <20260818080920.13555-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A compat device is removed from two places: disable_device() during the
ib device unregistration, and rdma_dev_exit_net() when the netns it
belongs to dies. remove_one_compat_dev() lets the xa_erase() decide
which of the two performs the removal, but drops compat_devs_mutex
before device_del(), so the caller that finds nothing to erase returns
without waiting for the removal the other one is running.

When that caller is rdma_dev_exit_net(), cleanup_net() carries on while
the compat device is still alive. Its kobject is tagged with the dying
net, so the device_del() still in progress dereferences net->uevent_sock
after uevent_net_exit() has freed it:

 CPU0 (ib-unreg-wq)                CPU1 (netns wq)
 ------------------                ---------------
 __ib_unregister_device()
   disable_device()
     remove_compat_devs()
       remove_one_compat_dev()
         xa_erase()
         device_del(cdev)
         ...
                                   cleanup_net()
                                     rdma_dev_exit_net()
                                       remove_one_compat_dev()
                                         xa_erase()
                                       // returns without waiting
                                     uevent_net_exit()
                                       kfree(net->uevent_sock)
         kobject_uevent_env()
           net->uevent_sock->sk    // UAF

  BUG: KASAN: slab-use-after-free in kobject_uevent_env+0xb6f/0xc80
  Read of size 8 at addr ffff888103806490 by task kworker/u16:1/41
  Workqueue: ib-unreg-wq ib_unregister_work
  Call Trace:
   kobject_uevent_env+0xb6f/0xc80
   device_del+0x737/0xc10
   disable_device+0x1ad/0x230
   __ib_unregister_device+0x229/0x3f0
  Freed by task 12:
   kfree+0x1b3/0x550
   ops_undo_list+0x273/0x8c0
   cleanup_net+0x3b3/0x720

Fix by holding compat_devs_mutex across the whole removal, so that once
remove_one_compat_dev() returns the compat device is gone no matter
which caller removed it.

Fixes: 4e0f7b907072 ("RDMA/core: Implement compat device/sysfs tree in net namespace")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
With this patch applied the report no longer shows up.

 drivers/infiniband/core/device.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d954eda63134..a80ac69ef986 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1005,14 +1005,20 @@ static void remove_one_compat_dev(struct ib_device *device, u32 id)
 {
 	struct ib_core_device *cdev;
 
+	/*
+	 * Hold the lock across device_del(): the other remover may have won
+	 * the xa_erase() and still be inside device_del(), and the netns exit
+	 * path has to wait for it instead of letting cleanup_net() free the
+	 * netns state the compat device is still tagged with.
+	 */
 	mutex_lock(&device->compat_devs_mutex);
 	cdev = xa_erase(&device->compat_devs, id);
-	mutex_unlock(&device->compat_devs_mutex);
 	if (cdev) {
 		ib_free_port_attrs(cdev);
 		device_del(&cdev->dev);
 		put_device(&cdev->dev);
 	}
+	mutex_unlock(&device->compat_devs_mutex);
 }
 
 static void remove_compat_devs(struct ib_device *device)
-- 
2.53.0

