Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A141044781A
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514196; cv=none; b=PeM7KeInqJIqOXO9pgziiBPNgoKQWE/qsT01Iv9iLiBffOEXIZBNhUgJ1bqMuST4dNoluKj/mN2vuIzoUIKsfhQ5lRVdtv7Ygy2/s5nwGW+YNQ0Ix88eULOQyibEWon6WZ22nkbeBkiZk3Y8ASLtwbj5ZXb6XZYMVZ2t52tn+p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514196; c=relaxed/simple;
	bh=z4Qhe6C2aCMSOTeXB7AyUYqEYyZgecaWjg4p4FyQSKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rLPsmn7iji5SR3Pb+1qNVb7ZFv6Rjyy7azGV03/Fw2VkQT5Ic3C99VMVc9xbTJgGtXO70+akJE0XM6EQdH7n2MJ+38QYehcDRhaSLg2p5o1YSA1VrJQYAxN0sHfnMrlNMZ7SbmZldSyiMvswfcltlxgXxqJKwsDy8ipSG9nHLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1NEIcd5; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1NEIcd5"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81bd69f4f6fso676247b3.2
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 09:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514193; x=1786118993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TVPw52z6WBQH7CgAI69D0zm3cgBs9+c1LhxWSzEvrzM=;
        b=U1NEIcd5bRLmMgEJjaUWQl/DKYLg6BfVUmFTQMtyKyjQvhhEfiwgNBWNzX0vcrif30
         6FR7/aqKVbpR0PRjCaMepWVwYu71GQvX83pGgMHfvLf+zNINz3m1hywJH/zSh1+xJuNC
         57Q8JQvSKy+snlT/Vvbs/7MQ26IfemO8+l5cy9WjNZPdsrWjFOCqXgvBS/5QBUGZx/xP
         BVJYH9EH/DtLXSEeXU3IEZTqk7Ve+xcDsVOG7ECjn9viPUVtEb3AB9MBgE7PtXrBkmXC
         hqkdqJi0mENF7CzMf+XZkKrqE3UAIUK+YITdVMOOP4eyGhHvDb0tXFPYGFXuhcF2Gz/n
         7aVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514193; x=1786118993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TVPw52z6WBQH7CgAI69D0zm3cgBs9+c1LhxWSzEvrzM=;
        b=eJscS9fHGK/uMQqzsuehfbRquhZdQ/p3h03XBBMZiHS7X+hyiw4daadworzjvTLHpo
         edgTSLYHI5N56fAYiaJKoIo17aGqKm+nmgZr9iM4LKRTTyO99n/EgRDdnZKlzRstnDax
         gcHhR7zj34DPHuThKKHN0UJdVc/VVKPMAWsuNLRRQIA59zmytrbdDtBYYrxohAvR0TQA
         gcUeRT0RH/U83fabFLl0izZhjzLKF5JG/jCyVB37px9v2ZALN/CLmqlYu4NsPxyyiXLw
         gB61vLnelHzxn2cAOCG43OZY7E1kXDQfBJZG7WNTOO41Nl4EZuQo0ydUXcJlHHOoHNBz
         RXVQ==
X-Forwarded-Encrypted: i=1; AHgh+RowRrFW0nsc3r6586GbKnGkXkcQR//eM88tGppPlEY66wr6eD8RLVNiuj+OCj/3YZN/PauzPVi+TH+j@vger.kernel.org
X-Gm-Message-State: AOJu0YxEiENoqCRsoE3gUQgbgYCWUDNIWYbUNGtq8VFcjIr1ZkPXbjif
	w0dIF4wx2O3a3Mnkgc4Momknjx6BFpIJneXrBgPVpxl+RgBlr8LA5/Fe
X-Gm-Gg: AR+sD102WaM5A4vhP+iR0cdAIyGclMjOmupUKM629mailIVTJDJPaIHmtMSXHsroIef
	rRGdTVQwnF8GQEvRYXpn3sxJXCuqPV6AQwhZ+TqiQoplQKPeRxHRYR46EhQIGuF1ND/bylCj1tK
	/RAeXteWToWc4VAPYfYBqj1HxUoUpWVXFk1so5ZSF4wvWjgJxgtElYTMS7vynjrX0viMk2GpRo1
	kQ9+bq7dnyuA7FM/gNugZi9iTs7tDbWqGNy3gONcMwR8FYIgkbEGmITokTEt3Hw7zzevlE819nc
	H7i4HlyMsa/BGJlb7iuTtbIIvCgkyzlDEaF8nWi6MDZJz/m3pPkjGIoYT7/Bh4AtwxSkr4wvSDA
	9+ap9KtFvSSMR/oKtiFV80xOG8a/daN18CAFY/b5KBxZsVxIZ1/lTG8hvd5L9682DraJOaAcnsY
	r8047GDeri+hPFNBUwI/mWoyl2jUPD9aI0MJdX+Wt+flYOWAxS3O43oXVsTz5YQTWJcCn28i6Bg
	XpZ0fCV1CBKdmXVnZ3149sOaCkUA9gw+zm85Ta2lOYc4bVQruHUqTQ=
X-Received: by 2002:a05:690c:6601:b0:81e:c06e:58b1 with SMTP id 00721157ae682-81fd49c65eemr5130227b3.1.1785514193473;
        Fri, 31 Jul 2026 09:09:53 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6f24sm9194187b3.30.2026.07.31.09.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:09:53 -0700 (PDT)
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
Subject: [PATCH net-next v3] rds: synchronize info callbacks with module unload
Date: Sat,  1 Aug 2026 00:09:42 +0800
Message-ID: <20260731160942.3245965-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
Suggested-by: Allison Henderson <achender@kernel.org>
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---

Changes in v3:
- Use ordinary loads for callback-slot validation under rds_info_lock;
  retain acquire semantics only for the lockless reader.
- Drop the Fixes tag because this patch targets net-next.
- Add Allison Henderson's Reviewed-by tag.

Link: https://lore.kernel.org/netdev/20260727174826.135662-1-nicoyip.dev@gmail.com/ [v2]

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

 net/rds/info.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index 21b32eb16559..385fefbfa07f 100644
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
 
@@ -78,8 +80,12 @@ void rds_info_register_func(int optname, rds_info_func func)
 	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
 
 	spin_lock(&rds_info_lock);
-	BUG_ON(rds_info_funcs[offset]);
-	rds_info_funcs[offset] = func;
+	if (WARN_ON_ONCE(rds_info_funcs[offset])) {
+		spin_unlock(&rds_info_lock);
+		return;
+	}
+	/* Pair with lockless callback lookup. */
+	smp_store_release(&rds_info_funcs[offset], func);
 	spin_unlock(&rds_info_lock);
 }
 EXPORT_SYMBOL_GPL(rds_info_register_func);
@@ -91,9 +97,14 @@ void rds_info_deregister_func(int optname, rds_info_func func)
 	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
 
 	spin_lock(&rds_info_lock);
-	BUG_ON(rds_info_funcs[offset] != func);
-	rds_info_funcs[offset] = NULL;
+	if (WARN_ON_ONCE(rds_info_funcs[offset] != func)) {
+		spin_unlock(&rds_info_lock);
+		return;
+	}
+	/* Hide the callback before waiting for old readers. */
+	smp_store_release(&rds_info_funcs[offset], NULL);
 	spin_unlock(&rds_info_lock);
+	synchronize_srcu(&rds_info_srcu);
 }
 EXPORT_SYMBOL_GPL(rds_info_deregister_func);
 
@@ -165,6 +176,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	int npages = 0;
 	int ret;
 	int len;
+	int srcu_idx;
 	int total;
 
 	len = opt->optlen;
@@ -214,8 +226,11 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
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
@@ -225,6 +240,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	iter.offset = offset0;
 
 	func(sock, len, &iter, &lens);
+	srcu_read_unlock(&rds_info_srcu, srcu_idx);
 	BUG_ON(lens.each == 0);
 
 	total = lens.nr * lens.each;
-- 
2.43.0

