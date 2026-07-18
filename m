Received: from mail-wr2-f2.google.com (mail-wr2-f2.google.com [74.125.225.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E9138C2C0
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784385755; cv=none; b=BpTmpndr2GdDHDHlOM0H8a0cKKVeYJjJmfa0Amf8Rrc4EvDBpANeidXB3pU/1VolZeWg4aw3funzKrlmQFMcgBUrjB7gPoTP96cVflLD/pMMLWY9hzqIkpIs6VecBpVM34HFwWCOnWzQt+QaQqrDgcokPU7IBz7ZVU0fAzWQJio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784385755; c=relaxed/simple;
	bh=Gec7Y40LrmfBcnCc7AUSx/MFDR5ApUHWGPxvi9+X3KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fubtc693NeMgjEZSo8jwZNUqFk+o7IpQbx/DfBAez3CDFet8HCGkfh5Vrn+tpgidtuEThVWEOljAGZcTGY7VrnOe954H9txypmvNX2F7+a5OX1BY2bGy3Bkc5xXdDkQCFzMPzXBloxt1LlW2AmaxcTEj1r3L8mUzA0zCqkHY80M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AtO3jPrR; arc=none smtp.client-ip=74.125.225.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AtO3jPrR"
Received: by mail-wr2-f2.google.com with SMTP id ffacd0b85a97d-472365266f5so4191457f8f.1
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 07:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784385752; x=1784990552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2yx8a34b5Emf6vrj/2nayvymgX9i9Fh5C1RmvOWAaK4=;
        b=AtO3jPrRdVlqMb4BL41wXyG55XzyvdzG55MKFexGGvgHfnZmMhJD8WFsPmSjmyReSW
         NgJXpNvSGkiwA1IzaA8+He1lHt2ME3SRL3obKQiqp+SRwSZ74yoclahy5NyAmgDw9kSX
         M49mth1TGpUQdeUkdXB9Sm8W4Y0R/n+1XaJndR60ZJKcBN6+ND3gqoi0gG/f5hfR6VVJ
         CBPmthJTRRLbnuoS+K/pw1BtQMw0Az74mC8mGwGgABz6eqfa+UscnxNSa1D5bnNXiev+
         hfnDkuQQvH2eS9hyIZazgQJ7J9AtjoZQkT7PWIwCju/eXCC0jBMKoGP9l80A8M8dJclY
         vYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784385752; x=1784990552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2yx8a34b5Emf6vrj/2nayvymgX9i9Fh5C1RmvOWAaK4=;
        b=qzEILyXMP70FkAIKGBLL2MnAOGnME8LRKNfsJdDIuDaK31vqKTnN2CcppRgfEmsTap
         x1/chwTMe5lK+utIeJXS0YnIDPImNxeG6zkH47l81Rhb1tUY4w4U9A2E8CEWbOKvGo0z
         cUfLwPHwEGLgcWsseJkBb57J+qnUMvH/baqM7wARB3si0Oz+SiCAaLNEo0Cqryke7RZY
         00PG5mhY/cDOn9Bv8g5iH0NKHPMtLA2UX7tCm8pkaHquwRBawuhQLy0nj+ZqTqvNd7Pm
         XcApSuzXEhJyG3tZBXNkV32mpNUVy6v31lfBbwyjmWBqTtaoJ/RG0tYlIztc1rbP7ZQD
         y1vw==
X-Forwarded-Encrypted: i=1; AHgh+RpZyCewtGaj72Nw6mi59KfY+ELy6wQYgDdJZo/5KNFfYprsOPNCMxcp5s9XayLAD+8Lyk+RRVa/7i6m@vger.kernel.org
X-Gm-Message-State: AOJu0YwY+isAJ/FeXzl0N/9v44SWaPjRBcPXBJ9rgi+Xn2J9F7CSs0hZ
	zZ2OMdjxgYb/WSD7/Y4VjDvTX3xV75ASJZY8Lh5qumVqgtVB9KvR2vU2
X-Gm-Gg: AfdE7cmm2uZ0muk8r70CJAIKIw1EzTK2p+wSwWsO5+Rt098rTDsmdbObxneQKRGiip7
	E2vq9y5dAr1KeIkdZeUjmnPc5Q4btclyBK1NslxvEhM+ytnKpUZDjnLAnY5arcK76R+6WFfuOwL
	7lKKWGxXYI7YzKY5+4wwnI7yvKH/YTR8sUq0THVX57WCcfp4kA86LT6xNMypL5tVG1Yzs7Ya1xx
	yBI1WPe7ocVxhLgs9mABLf05hDofw2XW8E3CRKj/bK0MOgV6S9k5yJaiFUrxAxbrXjloEGY2FB4
	wJxsbx5BYnCccDGNequcVWS4EkAXC0rP8vWggsnftqWDhQNAuoVxJP1i8UAYXgFVhOYo66KbapO
	YTIKyORwrVXVrpCwSHPnciTE4VnlAkk+aIIyPuSaM49cpheUVTaqk4yBqkMra0BSLOOmkB0I9jL
	ZG
X-Received: by 2002:a05:6000:1882:b0:47f:5c33:5eb9 with SMTP id ffacd0b85a97d-47f6233c20amr7922807f8f.52.1784385752070;
        Sat, 18 Jul 2026 07:42:32 -0700 (PDT)
Received: from fedora ([212.253.209.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e51c33sm11394317f8f.12.2026.07.18.07.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 07:42:31 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [RFC PATCH 2/2] RDMA/nldev: remove the unused dellink link op
Date: Sat, 18 Jul 2026 17:26:42 +0300
Message-ID: <20260718142642.102924-2-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260718142642.102924-1-serhatkumral1@gmail.com>
References: <20260718142642.102924-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rxe was the only driver implementing rdma_link_ops.dellink and does
not need it anymore now that its UDP tunnel sockets follow the GID
table. Remove the callback, the nldev code invoking it, the mutex
that serialized it and the now unused ib_device::link_ops field the
invocation looked it up through.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/core/nldev.c | 15 ---------------
 include/rdma/ib_verbs.h         |  2 --
 include/rdma/rdma_netlink.h     |  1 -
 3 files changed, 18 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index f599c24b34e8..0d1e749d78e1 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -51,7 +51,6 @@
  * a controlled QKEY.
  */
 static bool privileged_qkey;
-static DEFINE_MUTEX(nldev_dellink_mutex);
 
 typedef int (*res_fill_func_t)(struct sk_buff*, bool,
 			       struct rdma_restrack_entry*, uint32_t);
@@ -1866,20 +1865,6 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	/*
-	 * This path is triggered by the 'rdma link delete' administrative command.
-	 * For Soft-RoCE (RXE), we ensure that transport sockets are closed here.
-	 * Note: iWARP driver does not implement .dellink, so this logic is
-	 * implicitly scoped to the driver supporting dynamic link deletion like RXE.
-	 */
-	if (device->link_ops && device->link_ops->dellink) {
-		mutex_lock(&nldev_dellink_mutex);
-		err = device->link_ops->dellink(device);
-		mutex_unlock(&nldev_dellink_mutex);
-		if (err)
-			return err;
-	}
-
 	ib_unregister_device_and_put(device);
 	return 0;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 794746de8db0..620f00f5d026 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2984,8 +2984,6 @@ struct ib_device {
 	struct completion unreg_completion;
 	struct work_struct unregistration_work;
 
-	const struct rdma_link_ops *link_ops;
-
 	/* Protects compat_devs xarray modifications */
 	struct mutex compat_devs_mutex;
 	/* Maintains compat devices for each net namespace */
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 2fd1358ea57d..d1a7186f7436 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -127,7 +127,6 @@ struct rdma_link_ops {
 	struct list_head list;
 	const char *type;
 	int (*newlink)(const char *ibdev_name, struct net_device *ndev);
-	int (*dellink)(struct ib_device *dev);
 };
 
 void rdma_link_register(struct rdma_link_ops *ops);
-- 
2.54.0

