Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEEB420476
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785174538; cv=none; b=OMGljaFmtft8Vi4y/hp2PaTHJS0ewvnCeD2HmwqSNZk3LsEDohRZbzRrDSbBxhGpaVhslqDgQJDydP818F4SQuqeGiwyxWokOlza0yUM2FxVP8StpKMsuXl89VaGcRZ+tnF3m/ZwevkKEaFcwf0fOC+m+liM4wblIe+Rd447f2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785174538; c=relaxed/simple;
	bh=APSDTPUEgNFwya6Uj8Y2KMU/1rodoV6LqxS3uvEU5rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2opYjJTt4k3LTvgtmWXZMafV+0GNmvbAy0Q6sEnQrtHd/unVwG4PM0Dfg7xL8+1mFj0QOOcCSvi7iEbfT9wvVbH9Ya7PW22IIUWlkfCyySueH4F4u0sYpANgvvCPbpHw2l2aBLABsTR8mWGBvSNJDggq4IQEr3kIJaW25g3rsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gY5N+qN+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gY5N+qN+"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf4c37dbe6so2403655ad.2
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 10:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785174531; x=1785779331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/0L8UcHD2YSWW64Z5FD/06NrkfkvZfdKRpj1bBpinDQ=;
        b=gY5N+qN+Zm+NioVy7pCHoKgj1Y3NLQ4/G6V+qe1AMgrjd6dLr/OYwGrLg04WRww9i1
         j8wKaioEbpES9AWscMmkGPARLlHMVArAB3Jxhfp9iW3gKPejTRMajzDhtvuym6C0ojwK
         vsEfUF8c7X50P56WJpY54P32sxUgZm9XqVvhZbRInawoiZvZ+pIQdL0yxkPEUP52yNJj
         1x4R08bymPEPF4QnvsTmH5TmFSrrQznooMlLxd5eEOgS9iFc9iQr9NEQF2TVrELpXtES
         6FpiNU6084tLEhKiKSzXaRvBF7msTeGp3UX/3ou51LOvuXFG3fVGjeVFjyxaESUC3Sts
         rT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785174531; x=1785779331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/0L8UcHD2YSWW64Z5FD/06NrkfkvZfdKRpj1bBpinDQ=;
        b=mqz5rTW+eQ2c9pxBoFpvd+qmLjGsNSqQDwbLFu8gD/o+HpcGfjQdU0t0jcaED+Q4aN
         z9yfB1dknxhGtZLL3UvR5yrHeav4aRR4FiKfXbA57QUlSud394XCqh2DYfWdlBLIymrL
         bPoMUhMppzurO7ScdBJc6jLlnfIy8FWkFUFB5nvU9/twAqZf+591ypt+CKJlTdEhFKa0
         xWbetFRJH30V/wi6wUZfZSM2mufkmaOrkClBTAtnh78tvSx3al8yG0EUS41HjquQYDfn
         kW7qfVK+vXwGGVmLGTmxyz4Tyk7GgFGM7xNaEivpc3OdSmrbCNL6XrQCk8kv78FJDJ05
         o0gg==
X-Forwarded-Encrypted: i=1; AHgh+RqmAPHDr+VKHL06R8vOlV5bT5zxkDexxisAJB1MoWP6t9n7bJJB1+Y8v5TeDdBKVS1eRBx2A+2DH7ZM@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4zfSVRmEQWsSYGmuK/v7uLTJKvsYNUp94bEk30RS3fPA1fj5y
	PW1vc5N8mSZkxK+dq1IxJ96MU3ZTntxgRaTKrE4//lBBPJm6af0t+3JJ
X-Gm-Gg: AR+sD11H3irpiGBEma1W38Gylco7USTPPf4/eMz/liiQBJC4QTeiTI3qMH5znCCkbxp
	8Yzv2ws0DwyRI+cOPkG5YgPMuxZMB9ZPcR7WGlnqFZvfoz9il1DF3CAWwK04kxk0PFlNTlYyjFh
	XJo0N/mNZG6voQIo832MRFXmKOp6aOh0dRd6GN6f84WpaMiQimUSv5+RjFsgyKxUWfZlCafddav
	fwjdAZwjGsK20sa8v9g4yeDoRPO+rZlLUeuOkquqj1dB3yyz4F6rSj6bndNBco0EG0kxPiAXh3D
	1VTQe08lNmVon2WrinDCFN6jucMl/1JdSSIs8mh6a7wGH8WVf8uWyEXiC4XHWEuw2704XtNk8PN
	HwCuQIdcjDFc0JjS1GmOBChYr8Bp4EMGqnlxtWrCkooli96HLH1wCjxsZTHCXU+D41EZ0uqeGpN
	D1A6p5NFqzYoGCIxAPrhEvHbSL7/v/O+Vjx7fSEyp75xZhjfri62G4CYynCb2FfakpkTEN
X-Received: by 2002:a17:903:284:b0:2c9:99be:f011 with SMTP id d9443c01a7336-2d00ba3b644mr8041875ad.6.1785174530634;
        Mon, 27 Jul 2026 10:48:50 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e878esm34560986eec.3.2026.07.27.10.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:48:49 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Allison Henderson <achender@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
	Dan Carpenter <error27@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: [PATCH net-next v2] rds: synchronize info callbacks with module unload
Date: Tue, 28 Jul 2026 01:48:26 +0800
Message-ID: <20260727174826.135662-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_info_getsockopt() reads a callback from rds_info_funcs and invokes it
without protecting the callback's lifetime.  Transport modules register
functions stored in this array.  For example, rds_tcp.ko registers
rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.

This permits the following interleaving:

  CPU0                             CPU1
  rds_info_getsockopt()
    func = rds_tcp_tc_info
                                   rmmod rds_tcp
                                     rds_tcp_exit()
                                       rds_info_deregister_func()
                                         rds_info_funcs[offset] = NULL
                                     free rds_tcp module text
    func()

The reader can therefore branch to an address in unloaded module text.

Protect callback invocation with SRCU.  Enter the SRCU read-side critical
section before loading the callback and leave it only after the callback
returns.  Clear the callback with release semantics and call
synchronize_srcu() before deregistration returns, preventing module unload
from freeing its text while an old reader is still executing it.  SRCU is
required because callbacks such as RDS_INFO_COUNTERS can sleep.

Keep the callback array unannotated and use acquire and release operations
for publication so sparse does not have to apply __rcu through the
function-pointer typedef.  Replace the two callback-slot BUG_ON() checks
with WARN_ON_ONCE() and return without changing the slot on mismatch.

Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
Suggested-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---

Changes in v2:
- Split the info callback/module-unload race from the independent
  inc->i_conn lifetime bug.
- Keep the callback array unannotated and use smp_load_acquire() and
  smp_store_release() to resolve the sparse errors.
- Replace the two touched callback-slot BUG_ON() checks with
  WARN_ON_ONCE() error paths.
- Rewrite the commit message for the callback race and omit the unrelated
  inc->i_conn KASAN report.

Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/ [v1]

 net/rds/info.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index 21b32eb16559..408a4f0d04a3 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -32,6 +32,7 @@
  */
 #include <linux/percpu.h>
 #include <linux/seq_file.h>
+#include <linux/srcu.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/export.h>
@@ -68,6 +69,7 @@ struct rds_info_iterator {
 	unsigned long offset;
 };
 
+DEFINE_STATIC_SRCU(rds_info_srcu);
 static DEFINE_SPINLOCK(rds_info_lock);
 static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1];
 
@@ -78,8 +80,13 @@ void rds_info_register_func(int optname, rds_info_func func)
 	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
 
 	spin_lock(&rds_info_lock);
-	BUG_ON(rds_info_funcs[offset]);
-	rds_info_funcs[offset] = func;
+	/* Validate the latest published slot value. */
+	if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]))) {
+		spin_unlock(&rds_info_lock);
+		return;
+	}
+	/* Pair with lockless callback lookup. */
+	smp_store_release(&rds_info_funcs[offset], func);
 	spin_unlock(&rds_info_lock);
 }
 EXPORT_SYMBOL_GPL(rds_info_register_func);
@@ -91,9 +98,15 @@ void rds_info_deregister_func(int optname, rds_info_func func)
 	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
 
 	spin_lock(&rds_info_lock);
-	BUG_ON(rds_info_funcs[offset] != func);
-	rds_info_funcs[offset] = NULL;
+	/* Validate the latest published slot value. */
+	if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]) != func)) {
+		spin_unlock(&rds_info_lock);
+		return;
+	}
+	/* Hide the callback before waiting for old readers. */
+	smp_store_release(&rds_info_funcs[offset], NULL);
 	spin_unlock(&rds_info_lock);
+	synchronize_srcu(&rds_info_srcu);
 }
 EXPORT_SYMBOL_GPL(rds_info_deregister_func);
 
@@ -165,6 +178,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	int npages = 0;
 	int ret;
 	int len;
+	int srcu_idx;
 	int total;
 
 	len = opt->optlen;
@@ -214,8 +228,11 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	rdsdebug("len %d nr_pages %lu\n", len, nr_pages);
 
 call_func:
-	func = rds_info_funcs[optname - RDS_INFO_FIRST];
+	srcu_idx = srcu_read_lock(&rds_info_srcu);
+	/* Pair with callback slot publication and removal. */
+	func = smp_load_acquire(&rds_info_funcs[optname - RDS_INFO_FIRST]);
 	if (!func) {
+		srcu_read_unlock(&rds_info_srcu, srcu_idx);
 		ret = -ENOPROTOOPT;
 		goto out;
 	}
@@ -225,6 +242,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	iter.offset = offset0;
 
 	func(sock, len, &iter, &lens);
+	srcu_read_unlock(&rds_info_srcu, srcu_idx);
 	BUG_ON(lens.each == 0);
 
 	total = lens.nr * lens.each;
-- 
2.43.0

