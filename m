Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5AA22AE65;
	Sat, 11 Jul 2026 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783738281; cv=none; b=qgp6eh1NCa+p7wU1Dq9OiY0rabtgX6MCrVknYmrSwod5RBfBSt5rR8j0JStk6TeEN7oQsKFX6wOgqmUFL1sEQ9PJamsBX5q4NB7xtYQTGeX8HWvxJ2oktwpD8yNxVXtLhhb9Jymq4ZWsW7tUXXU27iP18wvYI5YkF43c8n/RKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783738281; c=relaxed/simple;
	bh=HnpYdEZfXrruXwRRW2tATZIevr+CvIZTN180epszVag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLHr9/fJJE3PCtNpA8IX6Yd++d0ChKi93Zg/OLDxPVzGV6Uq1Zpq72iiSS6I/7GvMC16pLvTpfx6y9IxxKtv7MRcTcgeEW8xzQIAUoJwfGECPDpoTxmbWxZNioi0uQ2ikG/2M4d8EDu6trMw3NSzson+yEdlf5b6LwCR7HQf1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJ8IUlAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJ8IUlAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0111F00A3D;
	Sat, 11 Jul 2026 02:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783738280;
	bh=TWa3KvqvJ7AjRL3+Kzvohra73Tat77krlT1siQYgeog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJ8IUlApqzOvgO/X26Cl86th97tS30HdB3iVBDEmfXDZjgb5PHoE4iYhj+3fnfclP
	 Uq+WoMgmxiXfxjcqNLo2h1C4tnUFgqU7626mQsoVhOxHP91F+8EWRIgKsh9L1v59du
	 T9EXA2rdW9gdCF51FyL83Urcq1bActz6Wp6blczW3Ba6XL7UumOvqo11zEDmMaQAqd
	 Mj8CkYAGJ9RCoylxLKLuVAswxyGwFZ6co2L6/c2+i0K2IzmL4OTitRAZU575UfemDn
	 +kV4+psQptCT/FTR0gzLBJJNtkHMSMCK2uKNJBfkHMVQ6z4uoZJ3hrhOBeFTwnozOf
	 EshCRXy2vsffQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net 2/3] net/rds: hold the socket while an rds_mr references it
Date: Fri, 10 Jul 2026 19:51:17 -0700
Message-Id: <20260711025118.2449428-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260711025118.2449428-1-achender@kernel.org>
References: <20260711025118.2449428-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

Each rds_mr stores a bare back pointer to the socket that created it
(mr->r_sock) but takes no reference on it.  When the mr is destroyed it
references the rs. Hence, provisions must be made to avoid the rs
being destroyed before all mrs referencing it have been destroyed.

The MR itself is refcounted, and in-flight messages legitimately hold
MR krefs that can outlive the socket: rds_release() drops the rb-tree
references via rds_rdma_drop_keys(), but a send completion arriving
afterwards drops the final message reference from the CQ handler and
ends up in

  rds_message_purge()
    __rds_put_mr_final()
      rds_destroy_mr()   -> takes rs->rs_rdma_lock

dereferencing a socket that may already have been freed.

Oracle UEK fixed the same use-after-free ("rds: Add proper refcnt when
an RDS MR references an RDS Socket") after seeing crashes of the form:

  PF: supervisor write access in kernel mode
  _raw_spin_lock_irqsave+0x4a/0x6a
  __rds_put_mr_final+0x2c/0xe0 [rds]
  rds_message_purge+0x13c/0x150 [rds]
  rds_message_put+0x39/0x54 [rds]
  rds_ib_send_cqe_handler+0x147/0x3dd [rds_rdma]

To fix this, take a socket reference when an MR is created and drop it
when the final MR kref goes away.  The reference cycle is broken by
rds_release(), which always runs rds_rdma_drop_keys() on close.  So the
socket reference held by an MR never prevents release, it only delays
sk_free() until the last MR user is done.

In the on-demand-paging path in rds_cmsg_rdma_args(), we take the reference
after the transport get_mr() call succeeds.  This is  because its error
path frees the MR with kfree() directly rather than through
__rds_put_mr_final(). So an early hold in this case would leak the socket
reference.

Fixes: eff5f53bef75 ("RDS: RDMA support")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: port to net-next (sock_hold/sock_put in place of the UEK
 rds_sock_addref/rds_sock_put helpers); also balance the reference on
 the rds_cmsg_rdma_args() ODP path; update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/rdma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 201cbe38fa893..fe221968f3fe7 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -117,6 +117,7 @@ void __rds_put_mr_final(struct kref *kref)
 	struct rds_mr *mr = container_of(kref, struct rds_mr, r_kref);
 
 	rds_destroy_mr(mr);
+	sock_put(rds_rs_to_sk(mr->r_sock));
 	kfree(mr);
 }
 
@@ -243,7 +244,11 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 	kref_init(&mr->r_kref);
 	RB_CLEAR_NODE(&mr->r_rb_node);
 	mr->r_trans = rs->rs_transport;
+	/* The MR can outlive its socket: a socket reference is held
+	 * until the final kref is dropped in __rds_put_mr_final().
+	 */
 	mr->r_sock = rs;
+	sock_hold(rds_rs_to_sk(rs));
 
 	if (args->flags & RDS_RDMA_USE_ONCE)
 		mr->r_use_once = 1;
@@ -755,6 +760,10 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 			}
 			rdsdebug("Need odp; local_odp_mr %p trans_private %p\n",
 				 local_odp_mr, local_odp_mr->r_trans_private);
+			/* From here on the MR is torn down through
+			 * __rds_put_mr_final(), which drops this reference.
+			 */
+			sock_hold(rds_rs_to_sk(rs));
 			op->op_odp_mr = local_odp_mr;
 			op->op_odp_addr = iov->addr;
 		}
-- 
2.25.1

