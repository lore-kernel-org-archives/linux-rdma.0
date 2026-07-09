Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC4630CD82;
	Thu,  9 Jul 2026 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783588035; cv=none; b=ZnBI3XxcPUY+EUgkoQ54FEkV6It5IU2Uoqn/tEWl2XW2C3/xeMbBgJJCLqrgLpPDCR/WorvRlJwsKWtvtoJdrdofl3q3vCbDzVjHUCCNbwL+oSz+ilgFW2175/TGQ6wh6QXs9jqQXbSC6SktgIyXGUrrPuKUWuD+Y1tAX01Uln8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783588035; c=relaxed/simple;
	bh=R8O+gNyxyQ3mFzwYKMnSBrWNskGC33HSzINn7n78du8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+8H4snd8Ppg9ToGhRJKtOJ2+9+wSTJH18lpMzNZz0/ppYeahheuWAwkNZ+Q8JuZFBLFjl83atZK86FijIddQtUB1NwrcbnHShakOBfEZgJMP9WUywXQlsImuQYn/XouBMXcFrFo7bWvLxZe6rqtq5D2xe5PLwMq4kE2CnJVjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmgEXgVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmgEXgVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846F61F00A3A;
	Thu,  9 Jul 2026 09:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783588031;
	bh=FnbpN+0s4pl5QfhdDEGmVWpJlqoYMnQ1UMGEML7kqgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmgEXgVWqpyrAP4Ogm2k+uufJ6TXDR2fII0uiPZkPq4vA0BGYuS4bbjmnaOGjSPSF
	 tBXHWISVlMXP6nWzqqNdZSsytYM7uGMlhTVqltTmIvx9DrpfGX9Q6pLAF2NZOYzjAm
	 1RJ1Hzvs/euM93PKY/pl+6MAzoTxUMuqcB1wG6BM0TI9sL33BPc7F7E6abt5u/FMSf
	 P49QXzgOlHzzkMjYuIVnks30aAvThRAzuYXLDu/Mb6RSKTeJLhPieJEPl3rloo9n2A
	 PRgwlhEDo4802boZfsa8mJE5yCmhD6oSTA44KOuq9Fmp/vz8X2Ua4AA/h0qqQ4iAhp
	 CW9De6Od+lsgA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH rdma-rc 3/3] RDMA/ipoib: Drain RCU callbacks during module teardown
Date: Thu,  9 Jul 2026 12:06:49 +0300
Message-ID: <20260709-unload-rcu-v1-3-fccd27211e5a@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
References: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

IPoIB reclamation completions can be signaled from inside an RCU callback.
Teardown can wake before the callback returns and unload ib_ipoib while its
code is still executing.

Client registration failure can also remove already-added devices and queue
callbacks. Wait after client and workqueue teardown.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 16a015b67206..6c14246befb1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2783,6 +2783,7 @@ static int __init ipoib_init_module(void)
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 
 err_fs:
 	ipoib_unregister_debugfs();
@@ -2800,6 +2801,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 }
 
 module_init(ipoib_init_module);

-- 
2.54.0

