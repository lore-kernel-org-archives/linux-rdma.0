Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9B3B4EA1
	for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 09:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782726716; cv=none; b=MFRtmSuAcDJOprvtW+bLDOMqy0vpw3j3Ng5/5bP57VJZKYgqMask7U0D3hE0OMxpG+TGXy2FeSvWIKwB84aDDvTDqlS9SXpPHujJw0b1sqiBrVtWnQwTCTFEIPaqEUbI9p5dKJrQnCNmXzY5PbOB5TDdge6yQK6lagpirXCFw/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782726716; c=relaxed/simple;
	bh=jT/07ZjnEljCDkg1Sui4v5JLloAdoehB4ms4+KILrac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CoKKXVVF8Zz7Lr04shWbm9DpyMuzQoNsbzYWqqu491Kkd65rw3NODs81voLgr0fexdSKjWZEesCAqDOFVFud0gE0dVNWT23chopSqw+gVuDxmJ2HaZ//ZHESPbsQL+zd7p7OB9gu1vG2iESoy+RNe/+WdhJXfl6Bk/HeqR7qblk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bCfx8ehP; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bCfx8ehP"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37defb2f231so1569296a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 02:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782726714; x=1783331514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZntHgB1VK83jSGRR6wDqH2TYAXRNVfVNGYQkueQtUtc=;
        b=bCfx8ehPCTE0J0Qca0r+V0+q7TfDPfuak5II0H7mxn+smEAzEY+0pJvzq8I5eNkFF2
         1IzzHgjqF9JCYXPrNS2ZtkER/jwbBZe4wN68YCckYXt5mCu7tAepva9B5xak5nErdWz9
         cdFrAowT+PsxCf5WYoMUUMNTjlhVppRtUcqbVsqJ73b7U4Gfk8ZF8tJ/U/T6eX5uTiQn
         wjUYrB+pDM+Dx1T0XNwvcLmNBHYMN7CEYMR1eljfAs0n+B12E3whZzjxbRr5mdOvmrdp
         8TWzfW4X4DrsSGNgZsA3/Qta6OyNUZgp4MctoRqwLlMalP2Uyhi/gmjraCl6TLKKyd/7
         t9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782726714; x=1783331514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZntHgB1VK83jSGRR6wDqH2TYAXRNVfVNGYQkueQtUtc=;
        b=TUETISCbi+DU7Aq9SUIQtuwj3SYnEtx9DppqCc/dwdEg0f7WQTLUwMUJCgwdD2heiy
         eOtAms7qcBwv0MymSFLtlGQ5gHGwKrMOAxI3n6VLR2haRLPTvugU2HiavvYPQ/bYZUyD
         F90qn+xpi85I1jHWEGEGZatohS/ur+iPl9J+PEz2RkjMj/EdnxPyHpkG69ITURTevx9U
         iN4R6pfL//jUU9pcBaARP8yW3e6rc3sNArhZIrqPk7mTli31VYxNN6bF03yjq1TA7QXU
         n9AzNxEpOx+8LZWb72XAJpzk39IQzxq3Uyo5yAg+l3Cf+xGZAxrbTyDjzn66hcHef23q
         EyEA==
X-Forwarded-Encrypted: i=1; AHgh+RoouID114pZjZv6kJ7vP8SXZulCwszPsITZTtbNX1CLW9Qt+nLk/Krq3K7vMlOcwMCN8shhl7Vg551T@vger.kernel.org
X-Gm-Message-State: AOJu0YxKS/JgN7Hz9dDA3v9IsWc5Hd/s37oY6gPidKsPMxloISoxLi/X
	atsRhtOaJmZKs+BlUXIb2185Rfa0/jA33RoFfAE/u1kBWxxOb1IwCfxh
X-Gm-Gg: AfdE7cl4sa9Jc9PHARBv6w0YVdre7e7CRx/ccmB42BhLuzCN8Ug1x9qs7eK8NC5f1sw
	9GsQXGL7CHH58Z778/vzj20qFJtKSdytDN+GDpwUm630sHKg3bTPx4UL5+z5Sg357wf7F+9wAe7
	66YAB+yDcRtTMTpkh5SDqADqg10DJoXg09n9b7tPyZt6V28j7cAWQNL6zp/00d92Mec8SdmO84B
	bpjKmgRsOjSnZ/WnmLwfRwl6SNzFL9mD20YJznTcklqQQTRSiVTM7CVH2g00C1bRTvpmw6cz7go
	0v2/1BlAqiSpijNW9pqAcFcfMBXLGbgti6G339pUpQNMCGSeKYGv9P7XuNz/7Ja/oISuu5yR/0Q
	XaeS1dDse6burJ04i9m5jTJqIY9c4RcEexUhF748aRRRkvw9ZhDuXMG69TM/gQbM9G35/QkaLjA
	RMp/ciVaCo6AaYmxhYAe2A336fXQND96Hdamf7x3HBfgVwUj/Fdu8=
X-Received: by 2002:a17:90b:57cc:b0:37d:85cd:1367 with SMTP id 98e67ed59e1d1-37dfa2363cbmr14496003a91.15.1782726713861;
        Mon, 29 Jun 2026 02:51:53 -0700 (PDT)
Received: from cps-manycore-1.. ([147.46.174.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37e1c93272fsm5550432a91.14.2026.06.29.02.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 02:51:53 -0700 (PDT)
From: Sechang Lim <rhkrqnwk98@gmail.com>
To: "D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Guvenc Gulce <guvenc@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH net v3] net/smc: fix out-of-bounds read when sk_user_data holds a sk_psock
Date: Mon, 29 Jun 2026 09:51:33 +0000
Message-ID: <20260629095140.679754-1-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A passive-open child inherits the listener's smc_clcsock_data_ready().
sk_clone_lock() clears its sk_user_data to NULL because the listener tagged
it SK_USER_DATA_NOCOPY. Until accept restores the callback, a BPF sock_ops
program can add the established child to a sockmap, and sk_psock_init()
installs a sk_psock into the NULL sk_user_data. The inherited callback then
reads it back through smc_clcsock_user_data(), which strips only NOCOPY,
takes the sk_psock for an smc_sock, and dereferences a clcsk_* field past
its end:

  BUG: KASAN: slab-out-of-bounds in smc_clcsock_data_ready+0x84/0x200 net/smc/af_smc.c:2637
  Read of size 8 at addr ffff8880013b8674 by task syz.6.12484/67930
   <IRQ>
   smc_clcsock_data_ready+0x84/0x200 net/smc/af_smc.c:2637
   tcp_urg+0x24d/0x360 net/ipv4/tcp_input.c:6264
   tcp_rcv_state_process+0x280d/0x4940 net/ipv4/tcp_input.c:7336
   tcp_child_process+0x371/0xa50 net/ipv4/tcp_minisocks.c:1002
   tcp_v4_rcv+0x1eaa/0x2a00 net/ipv4/tcp_ipv4.c:2186
   [...]
   </IRQ>

  Allocated by task 67930:
   sk_psock_init+0x142/0x740 net/core/skmsg.c:766
   sock_hash_update_common+0xd3/0x990 net/core/sock_map.c:1010
   bpf_sock_hash_update+0x114/0x170 net/core/sock_map.c:1229
   __cgroup_bpf_run_filter_sock_ops+0x74/0xa0 kernel/bpf/cgroup.c:1727
   tcp_init_transfer+0x1085/0x1100 net/ipv4/tcp_input.c:6693
   [...]

Resolve the conflict on the write path. Reserve the child's sk_user_data
with a NULL pointer tagged SK_USER_DATA_NOCOPY so sk_psock_init() returns
-EBUSY, and release it at accept. smc_clcsock_user_data() still strips the
tag to NULL, so the inherited callback stays a no-op.

Fixes: a60a2b1e0af1 ("net/smc: reduce active tcp_listen workers")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
v3:
 - reserve sk_user_data on the write path instead of the read-side check (D. Wythe)

v2:
 - https://lore.kernel.org/netdev/20260619150342.3626224-1-rhkrqnwk98@gmail.com/

v1:
 - https://lore.kernel.org/netdev/20260614120931.4041687-1-rhkrqnwk98@gmail.com/

 net/smc/af_smc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b5db69073e20..78f162344fe3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -154,7 +154,11 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 					       own_req, opt_child_init);
 	/* child must not inherit smc or its ops */
 	if (child) {
-		rcu_assign_sk_user_data(child, NULL);
+		/* reserve sk_user_data so sockmap cannot claim the slot */
+		write_lock_bh(&child->sk_callback_lock);
+		__rcu_assign_sk_user_data_with_flags(child, NULL,
+						     SK_USER_DATA_NOCOPY);
+		write_unlock_bh(&child->sk_callback_lock);
 
 		/* v4-mapped sockets don't inherit parent ops. Don't restore. */
 		if (inet_csk(child)->icsk_af_ops == inet_csk(sk)->icsk_af_ops)
@@ -1773,6 +1777,7 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 	/* new clcsock has inherited the smc listen-specific sk_data_ready
 	 * function; switch it back to the original sk_data_ready function
 	 */
+	write_lock_bh(&new_clcsock->sk->sk_callback_lock);
 	new_clcsock->sk->sk_data_ready = lsmc->clcsk_data_ready;
 
 	/* if new clcsock has also inherited the fallback-specific callback
@@ -1786,6 +1791,9 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 		if (lsmc->clcsk_error_report)
 			new_clcsock->sk->sk_error_report = lsmc->clcsk_error_report;
 	}
+	/* release the slot reserved in smc_tcp_syn_recv_sock() */
+	rcu_assign_sk_user_data(new_clcsock->sk, NULL);
+	write_unlock_bh(&new_clcsock->sk->sk_callback_lock);
 
 	(*new_smc)->clcsock = new_clcsock;
 out:
-- 
2.43.0

