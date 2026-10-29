Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248053;
	b=B0RNq9Uz7aadmbqDTzCWi8wm5oG77s+ZlLgqW+eLotKEfd5DhInza/B5IOWYjIOuKlUG
	 j7X+Rc3MEnUK6h11SKqGzFp+nY5gZIbpV22UGBXSDBZXtrbtwiPGEoqzBNhl32Y+YHFCN
	 PXhsw5lzEZYW59CRFiW2O6EfrYV3LWrUq75BnyLNqfISYUZ5rERZJT+Uns8zpSlCFfD/A
	 5FzrWKT8ywYsldaneA9o0X3+zXGB0FWFRK+SyBEo0IOu+jxHotAqyG1d1hGXGOyua7sIl
	 L7YQxwxKbV526S8Y75rh5eB+IACNdfk9pQpteTVZCtUtV4RAq4EbUYKW20RuOZCWnxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKqYqsjIxSLlGzKhZXBBrOPGFw2mBf2DyMFxJyqEHDQ=;
	b=kQErrTuYnIfvlJAVmfftB1ItKauLSgajpu4HhADbMMihBhLQSC9+Ul11cSic2D0ZHkTp
	 Z7DhkKabNk034JrQTxNSU2m6Di5DJMO5XTzgYY25D4mHPOVuX/QIMLev7g+9rhyIXaHyc
	 x8iMxOxofAOYuT7hIjVdB8p+L7En+6fMKtDsNNv9iZvpqEhbBmQKQZzLYVjEBpfxpftSj
	 qU1cPxFbbHjDBES6+8nVPJAGQnam+Jh6FP22/h59nixXqdo5HZoO/IXbtoUulp/JtEVI7
	 IitcDg9bUmu/7XKGbtz5mfZ2nbDGWDNz2vaF1s7Fk7+HxqVQS0F2Nx1zO/EQ92oBzLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VRFi4lNE;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B71B606A337
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 04:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B71B606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VRFi4lNE
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so1188627a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 21:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793248052; x=1793852852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RKqYqsjIxSLlGzKhZXBBrOPGFw2mBf2DyMFxJyqEHDQ=;
        b=VRFi4lNEZxpTwtXgGUaYz3Fj+Cz2g4mBhs+TyEgTHiMPyiMjODXTteMaFr8NkgxOVv
         xIjjYQ3OkoA2O+FFQsz9h/jC/zrWzaS0H6J5LT3z0AkOdeVa1rbEGsO9ORvkQqeye6QX
         JvRg9TuTP9Wj4Q8BBcXHNWMGHJ5+p9Xbxo6MtgF/0WuDC7n8ATqlxZWM7H9R7GesXW0V
         Hknahd/sPkNtuMWkfIdY8+XN/Gs94i7xXvsCmap6PSbT7XMvlVrKQugMeBPKCstbOSyc
         Hs0wUMdcZ4KqI5/augboVK1ddAEIFV9hJiZvOh7ej56uyAnjV2P0coXe38K8iq7Pusp6
         DWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793248052; x=1793852852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RKqYqsjIxSLlGzKhZXBBrOPGFw2mBf2DyMFxJyqEHDQ=;
        b=DWa9brDGW9blJyqBtZS/lkGkHdWdyxHLIB4udIxbeFf+WwNirerDHSY2UbMbPmE9OA
         DtsTNP/r8wXuy0MabdEaptcnJIfyoO1gjfNbufcoGkl3VXd3hz6p4JLaM8bJAWxRZqAn
         sqhricLo312rMJiI37iC846RaapFtS5AV/YYZmCeToB4tP5Bi/mgfeWWdAvQwvKY37TH
         rXCnQ/EJTixFsBLTcTL7p1CP0HOlwAB+AvhKLE/H5qPDISfUMGekdyvJK7u9217WYXXY
         aFlm0wD1Gd5gPdO+U/vNVtWZBOhXrdm3KK4e+EEnQ/VYiLiJ1WEsJcy/YGjmA1y32cnh
         X1FA==
X-Forwarded-Encrypted: i=1; AKwUvBz+kJsZ+0//5Egj013lWt7YmtnJH6yb5BsMxxqT4XRsB6+mMXVhrKtIrCrr50k6tPTd6K4mwzARML4d@vger.kernel.org
X-Gm-Message-State: AFq9FYJNa+gndciC3TYjiDGnbSyCwIaLolUoctJ5lsXlva03vRcWI/+D
	l0+OtwR/un6+jvmCRrkrXLWYynY8wdk0Ud0xw31EEeE3c4daYtpfXUNu
X-Gm-Gg: AYBFou1L5xxviQV8Cmi/9ALrqpNfV3WBGvuLt4l0c7nH451JK328WftiorpS/G7kVqM
	2xYKN1uGZe0E55oiFgGojjBBy9NGU/LQlUUYuiBwNz0ScjFsbguqMSLpwaWZyBoF08x8UMYaCd3
	5cTs8doGkG6+nXtA4lsnrgZtnllbMQnpLQ6O/ENKQqdKDjscT9NEuDHiWf7/EEE3bXWa8zoAlla
	MClDDsoqcyswAaGG63rrURZMeho+JoFzRA5btpKvBrmUCg8R7uZvyoeu8HmjPkrdK9QqRV5SC9t
	uBOSVK4qqqI7zkxhpUN2uKYMxaIRK+NVy8QgPGFNXSmwerW6ZtShmIwziFd6LwQpAAQLvZ5rsOl
	QIN5Y9pGXCcfh1zqgGUAHatLHJ4N6o8b4jpLXZQ+IiYdAszvAcdK1m4yGgS6iPm1bXTbRaa0zYM
	lttT5kxG173VPeMbu478twhPjRZRut0SZ6Ns+dA0zmvwl+UXKeVkMmcRlfGdtTvkxB+HUImNCiK
	7oZ0d+nzb1pYHyqKzwK97r5zAG60DMLdUOpM178+9uZSAGGQwriGCGsiqlSv1GLzQQWb1AGs/XS
	JC7+TetuCEgQnETCWdVgJblI0f4Vw3BCXpPWQbh+20rSUNE3Dra4JAo=
X-Received: by 2002:a17:90b:54cd:b0:3a4:6f38:f2a2 with SMTP id 98e67ed59e1d1-3ae580f1940mr3392128a91.25.1793248052271;
        Wed, 28 Oct 2026 21:27:32 -0700 (PDT)
Received: from localhost.localdomain ([155.69.168.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e898317sm2010846a91.16.2026.10.28.21.27.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 21:27:31 -0700 (PDT)
From: Yuqiang Sun <izaiahsun@gmail.com>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	guoqing.jiang@linux.dev,
	gi-oh.kim@ionos.com,
	aleksei.marov@ionos.com,
	lgs201920130244@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/3] RDMA/rtrs-srv: Do not free the path on path file creation failure
Date: Thu, 29 Oct 2026 12:27:17 +0800
Message-ID: <20261029042719.75868-2-izaiahsun@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029042719.75868-1-izaiahsun@gmail.com>
References: <20261029042719.75868-1-izaiahsun@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When rtrs_srv_create_path_files() fails after kobject_init_and_add() of
srv_path->kobj, its error path ends with kobject_put(&srv_path->kobj),
and the release, rtrs_srv_release(), frees srv_path.  The caller does
not expect that: process_info_req() goes on to free its tx IU through
srv_path->s.dev, and rtrs_srv_info_req_done() then closes the path,
whose close work tears down the connections, puts the session and
finally frees srv_path again in free_path().

Commit 5b7437339011 ("RDMA/rtrs: Fix use-after-free in path file
creation cleanup") reordered the cleanup inside
rtrs_srv_create_path_files() so that the helper runs before the put, but
the final put still frees srv_path under the caller.  The same pattern
exists one level down: rtrs_srv_create_stats_files() puts
srv_path->stats->kobj_stats on failure, whose release frees
srv_path->stats, which free_path() frees again.

With one allocation failure injected into kobject_init_and_add() of the
path kobject (failslab restricted to rtrs_srv_create_path_files), KASAN
reports while a client connects:

  BUG: KASAN: slab-use-after-free in rtrs_srv_info_req_done+0xe43/0x1740
  Read of size 8 by task kworker/0:1H/84
  Call Trace:
   rtrs_srv_info_req_done
   __ib_process_cq
   ib_cq_poll_work
  Freed by task 84:
   kfree
   kobject_put
   rtrs_srv_create_path_files
   rtrs_srv_info_req_done

These paths run in the server's completion worker when a client sends
its info request, and are reached when allocating or creating the sysfs
entries for the new path fails.

Keep srv_path and its stats owned by the caller on failure: the error
paths only delete what they added, and free_path(), which runs in every
case, drops the kobjects that were initialized but never made it into
sysfs, so their releases free the structures; otherwise it frees them
as before.  This keeps the kobject names from leaking, which is what the
puts in the error paths were added for.

The problem was found with kbound, a static analysis prototype that
checks whether callers rely on an object after a callee returns a value
for which the callee may have released it, on v7.2.12; it is present in
the rdma for-next branch.

Build-tested with x86_64 and arm64 allmodconfig (W=1, sparse): no new
warnings.  Run-tested under KVM (KASAN, lockdep, kmemleak), failing the
path or the stats kobject allocation with failslab during a client's
connection: before this series KASAN reports use-after-free in
rtrs_srv_info_req_done() and rtrs_srv_close_work() and a general
protection fault follows; with this series nothing is reported, also
with CONFIG_DEBUG_KOBJECT_RELEASE.  Failures of the two
sysfs_create_group() calls were not injected.  With this patch alone,
the close work still uses the session freed as described in the next
patch.  Not tested on RDMA hardware.

Fixes: 424774c9f3fa ("RDMA/rtrs: Call kobject_put in the failure path")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5 kbound
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 16 +++++++---------
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 14 +++++++++++++-
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 9dd9141c86a5..45ee07a98ca8 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -238,25 +238,24 @@ static int rtrs_srv_create_stats_files(struct rtrs_srv_path *srv_path)
 				   &srv_path->kobj, "stats");
 	if (err) {
 		rtrs_err(s, "kobject_init_and_add(): %pe\n", ERR_PTR(err));
-		kobject_put(&srv_path->stats->kobj_stats);
 		return err;
 	}
 	err = sysfs_create_group(&srv_path->stats->kobj_stats,
 				 &rtrs_srv_stats_attr_group);
 	if (err) {
 		rtrs_err(s, "sysfs_create_group(): %pe\n", ERR_PTR(err));
-		goto err;
+		kobject_del(&srv_path->stats->kobj_stats);
+		return err;
 	}
 
 	return 0;
-
-err:
-	kobject_del(&srv_path->stats->kobj_stats);
-	kobject_put(&srv_path->stats->kobj_stats);
-
-	return err;
 }
 
+/*
+ * On failure, the caller still owns srv_path and frees it in free_path(),
+ * which also drops the kobjects initialized here.  Do not put them here:
+ * their releases free srv_path and srv_path->stats.
+ */
 int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
 {
 	struct rtrs_srv_sess *srv = srv_path->srv;
@@ -296,7 +295,6 @@ int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
 	kobject_del(&srv_path->kobj);
 destroy_root:
 	rtrs_srv_destroy_once_sysfs_root_folders(srv_path);
-	kobject_put(&srv_path->kobj);
 
 	return err;
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 5314599d29fe..641a7bf5e02c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1584,11 +1584,23 @@ static void free_path(struct rtrs_srv_path *srv_path)
 	if (srv_path->kobj.state_in_sysfs) {
 		kobject_del(&srv_path->kobj);
 		kobject_put(&srv_path->kobj);
+		return;
+	}
+
+	/*
+	 * rtrs_srv_create_path_files() may have failed after initializing
+	 * these kobjects; then their releases free the structures.
+	 */
+	if (srv_path->stats->kobj_stats.state_initialized) {
+		kobject_put(&srv_path->stats->kobj_stats);
 	} else {
 		free_percpu(srv_path->stats->rdma_stats);
 		kfree(srv_path->stats);
-		kfree(srv_path);
 	}
+	if (srv_path->kobj.state_initialized)
+		kobject_put(&srv_path->kobj);
+	else
+		kfree(srv_path);
 }
 
 static void rtrs_srv_close_work(struct work_struct *work)

base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.53.0

