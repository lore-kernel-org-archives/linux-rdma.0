Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792612720;
	b=UG5b1TJFET+uyMgbXggHI2HNNpQJP2EQpzTHTnT/LS7JT2BOEZ6w25tp8PGLhYNFZcnz
	 y/D79VwpgBWnFkGuPBlAAbtW9dKwsCfZqcG6L3DJEEcIcQVh57OVXJo94TgmkamAcC7fb
	 AI5oT29riDj7U6x4nURZZk0pceQh5RnKxdwf4mxnGl14742SFxICQCNWgppAj/qcaq5sF
	 hdj3ceK9TFAQQrjycQ1TfwfClL5cIv4t49V8swC0IAxTCzSGXHVYkYdvU/3f+cWZ0Krqx
	 ZFVxxIdUofXXLC4TQ3bfi6b0NsbstUclvuIjDdJS+qe2NuRjWGnODtq5i3fP8J7uufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792612720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BbfDl+a5HT/kYr5JHWb9Xql181M0qQxBom3y0z6c3yA=;
	b=eGi3uTLUllWfSujywBVMaMHYrCxkHRj5vbTKQoxFlIARaoXrbVW3Q+xg5bORbehygZYA
	 LKMCmigH4l42rzRpd/uuaDPoiZ3V8pB/QOnaukp0lHNBEC3AutEGUTjEvyBfYqi9EmVp4
	 OX6UHgjm5tqnstl5sOOpFpAacvC6FjjLMxA64HN5miM7zDHO9MKtV4myEw54ARKM+fyiO
	 VbM/ZRagTfG2UtoiVacCTJZzxZDgN/n6w0TuSxlnbtlzSJjDceKiSxSpcJuUxF1/bn5+a
	 mc/v6xJjFW/JdFO/yvGUEZELUThX/wZagODZ/XlhazMYfCfRCW5uf0gwyGe3k8o7a4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LcgBOBfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D86606A31A;
	Wed, 21 Oct 2026 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LcgBOBfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEAF1F000C4;
	Wed, 21 Oct 2026 19:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612719;
	bh=BbfDl+a5HT/kYr5JHWb9Xql181M0qQxBom3y0z6c3yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcgBOBfDsbVTN55jE/NOhCAEzwJUCSCpIZ98Z0y6nJOmGoUZzHEJQa6yQ8H1smZX5
	 gwukLC0Fl38HTjgkrIl9zZwFEy2139eiUAC0iYlgpHMtgQGLEUxqr37Z/wUWXplScg
	 zcrllwXKyfjDxCJZVDjGYUc0lFL1f/DzWOazKk8qv5VfUNEz3Irzj32fbf0wTGAt8u
	 jj0NiJkKX2dGOihWXAp5kwiz7i5DiDTNaR7a4OvHu1D2RrfpvEnK4YJUndfondRi4W
	 06GR+WYFFuDWdFtnDz3z10R2+ZVqv49GIXUQR+o+3LHMA/cRXYV9nRK/Mf6t0jJyE6
	 zlclLSZSsaJMg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	oleg@redhat.com,
	joel.granados@kernel.org
Subject: [PATCH net 1/2] net/rds: do not fail init when CONFIG_SYSCTL=n
Date: Wed, 21 Oct 2026 12:58:36 -0700
Message-ID: <20261021195837.142802-2-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261021195837.142802-1-achender@kernel.org>
References: <20261021195837.142802-1-achender@kernel.org>
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

With CONFIG_SYSCTL=n, register_net_sysctl() and register_net_sysctl_sz()
are inline stubs that return NULL.  rds_sysctl_init(),
rds_ib_sysctl_init() and rds_tcp_init_net() all treat that NULL as
-ENOMEM, so RDS refuses to initialize at all even though every tunable
has a sane compiled-in default.

When RDS is built in, that is worse than a missing feature: the failed
rds_init() destroys rds_wq, but the rds_rdma initcall still runs, and
when rds_ib_sysctl_init() fails the same way, the error path in
rds_ib_init() flushes the already freed workqueue:

  BUG: KASAN: slab-use-after-free in touch_wq_lockdep_map
  ...
   __flush_workqueue
   rds_ib_init
   rds_rdma_init
  ...
  Allocated by task 1:
   alloc_workqueue_noprof
   rds_threads_init
   rds_init
  ...
  Freed by task 0:
   kfree
   rcu_do_batch

Only treat the NULL return as a failure when sysctl support is actually
compiled in.  The exit paths need no change: unregister_net_sysctl_table()
is an empty stub with CONFIG_SYSCTL=n and already tolerates a NULL header
otherwise.

The underlying problem of built-in transports initializing after
rds_init() has failed is independent of sysctl and is addressed
separately.

Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
Fixes: 3e5048495c85 ("RDS: sysctls")
Fixes: e6babe4cc4ce ("RDS/IB: Stats and sysctls")
Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
Suggested-by: Joel Granados <joel.granados@kernel.org>
Assisted-by: LLM
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_sysctl.c | 2 +-
 net/rds/sysctl.c    | 2 +-
 net/rds/tcp.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
index 2af678e71e3c..bc97a3eecad6 100644
--- a/net/rds/ib_sysctl.c
+++ b/net/rds/ib_sysctl.c
@@ -114,7 +114,7 @@ void rds_ib_sysctl_exit(void)
 int rds_ib_sysctl_init(void)
 {
 	rds_ib_sysctl_hdr = register_net_sysctl(&init_net, "net/rds/ib", rds_ib_sysctl_table);
-	if (!rds_ib_sysctl_hdr)
+	if (!rds_ib_sysctl_hdr && IS_ENABLED(CONFIG_SYSCTL))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
index 025f518a4349..968d6279bbd3 100644
--- a/net/rds/sysctl.c
+++ b/net/rds/sysctl.c
@@ -103,7 +103,7 @@ int rds_sysctl_init(void)
 
 	rds_sysctl_reg_table =
 		register_net_sysctl(&init_net, "net/rds", rds_sysctl_rds_table);
-	if (!rds_sysctl_reg_table)
+	if (!rds_sysctl_reg_table && IS_ENABLED(CONFIG_SYSCTL))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 774a71f88d37..34815b4f658b 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -637,7 +637,7 @@ static __net_init int rds_tcp_init_net(struct net *net)
 	tbl[RDS_TCP_RCVBUF].data = &rtn->rcvbuf_size;
 	rtn->rds_tcp_sysctl = register_net_sysctl_sz(net, "net/rds/tcp", tbl,
 						     ARRAY_SIZE(rds_tcp_sysctl_table));
-	if (!rtn->rds_tcp_sysctl) {
+	if (!rtn->rds_tcp_sysctl && IS_ENABLED(CONFIG_SYSCTL)) {
 		pr_warn("could not register sysctl\n");
 		err = -ENOMEM;
 		goto fail;
-- 
2.50.1

