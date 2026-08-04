Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B4248A2CE
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 21:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879567; cv=none; b=Z6XcmOA8eWDBss2QSzbljNtJoEX8i2aLIaH5rNzgDkPT090vGy3GyWlZ32julJwP9bOmvnIxA2MSTAr+ou6NUZuvd7GzuNfSQzYinRUlIaVQVQ1cglpN4HyHxtM8g3DmyIWzkj4OpqQcQA4aG1gN4BhMfj2BH3F6lBkck3aLKFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879567; c=relaxed/simple;
	bh=c0jHAqCKMMLGqElB9P0Zc/ra2eBZhFiyVAmWgrs0dpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jHuEd0sDVOdOFBCIVxsILJBjgnJkXXgOuodRgGGaxEmZTnM/jIhp1A2tOF/liF2A5FaOAjMZVkEl4BfZ0DZ957RtQe4TqeqmSOJ2oWdFLslbxqmAyTzuthB2bVbKqhPWKsFn+g3pdepqSyQ5aPcupHSfehRgQoJsCXj3Y9gQUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6SmcVV5; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6SmcVV5"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cee9b74ee1so2839545ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 04 Aug 2026 14:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785879564; x=1786484364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AVzPi9qdoodMQ73+79x+gG0Fw90m+Wzneqb+ihmK6gQ=;
        b=e6SmcVV5jfw8sFCaBIZVZtBXSOxoKLFnviVSNIVBBcs83peqIeViDqgJEo3jqTaY0d
         TR8/fjJmVb0hWCcPgGzufqhPCPutU31Xm4xTfJoOCv6teNG29GSiL+L0E48vQwy5jTQ3
         mA/7d2LQHgAacqW5xthUbx9uNEk+JkD2qY11MFzXLwQ3R2pLOPBZe7zB45/csv+uoVDa
         9WBxSmYkNRb7LDzTaCqlF0pqpjxCWtK+Z1M/wOpKyeQhWFNuWI4k+dD1XSOnqQGgwCaD
         djz6ydqXVE1xwO6hy1v8ouFil/C2+7sha/+kWbmx/lw4a3dnppMvVTTnxiIv4qzYIqVj
         2M2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785879564; x=1786484364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AVzPi9qdoodMQ73+79x+gG0Fw90m+Wzneqb+ihmK6gQ=;
        b=ocVJvR57xlNDKfeWrDsVNsXyCZsc7MLdnvpWoaYSp8f83TsOlwLeKxMenuwUQUiD3W
         btUbVmZKMGPhEFNSErF9ZqPCxom84kMzsW0yOiV+/LSt48nU+0SUz8tTJqyCtph6ArGv
         g0qPCtJp37483aipnswusrlRODNO0UFYHXW7El+R+F4aKcqT9+qFzBGtJzuiIxIWwH6i
         Z9CAIqnFro8f07nrM21dYhfzsO+HinOnjHsKzFqDPzHx8EDdyLS86w/R0y7vCjC9ZixT
         uh9ZAHi4JzruqAjenOneLgxaJ7Y9UWzBDP09JHGF0gadWFzUr5aYQKv55i9oZ3ldnd2t
         xrGQ==
X-Forwarded-Encrypted: i=1; AHgh+RqtW79qODez3XrLMGx8AgBQbsafnmvMspQMwnqjrbhiiAEw2k3U5KsRMcMQego3iQR40tJGu+t8ex3t@vger.kernel.org
X-Gm-Message-State: AOJu0YxodKJ7a+ap1oTUneufgk1NnSaGs9gVaoUfyw/1s43ErnXJmx9R
	nraroiUewUuUcG+my2UXOZYfbl//bP9svMrpBY3p/Lg0KA2pQiGegBRW
X-Gm-Gg: AR+sD11TOougx8JIJu2CV10aoPgxW9wXtpqR7GgEkV4XzNvqmvEb6N715mhgLvEbjtf
	GoFKDMmVmwnVxwzwGqsenfX5XA9X/7J6HJR/ka4r2WmIFdWMJKe9RCdoS28x4SB7dNIEHSjV7W1
	NzHzA3ZkVQRZO0EtNvvajodIE5juP2NnX9K91yHWN+S1fIMIq1yQKoCdzTMyenK19hM1xLDj7nS
	lbA+1bK1zXp8QPjxoCBzPyRLQtPnjCBEcbCYNRQ2o/2/KmillDmdhYGO2wb0PaT8TZbceEY6FF9
	lAVM+5M7YEjnk2RA9nWp1HRRkNvHUVpyigy4YnzR69u1EtqnJYDGgDP4x2xz4MAHlIxtc54Nb5k
	rhi2hfDm2y5C3KhLNoc6/omft6+Ee6ro3GEw/4ppCvoPsetbM0GYaII5P7tGCSEtdMv3vhm9Bp7
	bNLW/FwNMNcWFf3w8j4p61jShDvk+oeZ5Y4HtXQIaai9aDbfAziGxsSAKC1UiXoRLqd7oaaZZN9
	TvGtnD139Y9EkVNDgIpRT3pE8WQtiZQrRuK6I1pzFs=
X-Received: by 2002:a05:6a21:a38d:b0:3bf:6fb1:ce0d with SMTP id adf61e73a8af0-3cb85ea3663mr1881337637.21.1785879564575;
        Tue, 04 Aug 2026 14:39:24 -0700 (PDT)
Received: from LAPTOP-DPAKMOI4.it.purdue.edu (pal-210-106-74.itap.purdue.edu. [128.210.106.74])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867bc341sm14727379eec.27.2026.08.04.14.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:39:24 -0700 (PDT)
From: Yifei Gao <gyf161023@gmail.com>
To: "D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	Yifei Gao <gyf161023@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] net/smc: fix sock refcount leak in smc_switch_conns() error path
Date: Tue,  4 Aug 2026 21:39:17 +0000
Message-ID: <20260804213917.3413525-1-gyf161023@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_switch_conns() takes a reference on the socket with sock_hold() before
dropping conns_lock to prefetch a tx slot. On success the reference is
released by the sock_put() after smc_switch_cursor(). When
smc_cdc_get_free_slot() fails, however, the function jumps straight to
err_out without a sock_put(), leaking the reference and leaving the socket
unreclaimable. During SMC-R link failover with an exhausted backup link
this leaks one reference per failing connection switch.

Release the reference before jumping to err_out. The err_out label is also
reached from the smc_switch_cursor() failure path, which has already done
its own sock_put(), so the put must stay at the get_free_slot failure site
rather than at the label.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
---
 net/smc/smc_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cf6b620fef05..04c6ce608ec7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1148,8 +1148,10 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		read_unlock_bh(&lgr->conns_lock);
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
-		if (rc)
+		if (rc) {
+			sock_put(&smc->sk);
 			goto err_out;
+		}
 		/* avoid race with smcr_tx_sndbuf_nonempty() */
 		spin_lock_bh(&conn->send_lock);
 		smc_switch_link_and_count(conn, to_lnk);
-- 
2.43.0

