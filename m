Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010A1368D46;
	Thu, 30 Jul 2026 04:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785384994; cv=none; b=i41uIFvd9Hj+iGk8LoViSVzC6lartfMfiF8vPjbugBJliE9hQbsfa4WJ3TpQMi45ry+xjKK3uTLGY7F88GSwJLX90FX9+DHrjDlUCP+fd+snId3/K1axaRyovKQiajcJkaHhwhhdp7WYVsqb27NtFRPQ7sIpRkUIVzcFDUPzQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785384994; c=relaxed/simple;
	bh=YIUPuKWaoDeomUmNI7w1BNivu4pk5wRKZ4ATKeBXjKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iOUiHhWyFY+m1Qv7qn/8sMo77TIze5188HMVgBf0KDHd4Yt+haZKCZryuwG+6fpuJq3t5CyUle0XEVR56FR2MhXkBN3ZsheSRFpyOg+RCIRIS0rw5n7DTDfE+DsTu560ey0iCZwfyHorq6vC6QpCOtiY8N1N4je/VoOXyLL2yxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNzyTZdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNzyTZdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237571F00A3E;
	Thu, 30 Jul 2026 04:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785384991;
	bh=4om9O0zA9ggQy+KvNS5lb+rLwzYOb/H9jLI7mVJd9d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNzyTZdLr6pcFeNObuyOP5Sj+IrjxpwvyTHhiVULKtM2+kpWDLMu2TcZi79WI4ONj
	 sHuDMrVO0pHBaz64qHgKiEveC/8asMb01EcLFIBZBgFjfhaVUiXM7tvJhxyEOQYD81
	 TQ+6Kzisg6Ojcqn1WZ1erVpJoPGNWoQu8G0cCnK70YOEEQrJAO/VakND46UEy59fdM
	 Arv6a3X1cUXM7pMpOH7ikBYXIzt9dkWWwtnOQcqm/YyiK9cXD7KuN2GcWaUvZyGs1w
	 NuvB+CZCiDknjJ0OvEqrLs25ekA0W6IbWo4sUQkzE9HIPX4NarVFNDog265RC6RzjA
	 s8dVBW9Jx0Xtw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net v4 2/4] net/rds: hold the socket while an rds_mr references it
Date: Wed, 29 Jul 2026 21:16:27 -0700
Message-Id: <20260730041629.3512480-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730041629.3512480-1-achender@kernel.org>
References: <20260730041629.3512480-1-achender@kernel.org>
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

The hold sits next to kref_init() at both allocation sites -
__rds_rdma_map() and the on-demand-paging path in
rds_cmsg_rdma_args() - so every MR owns exactly one socket reference
from the moment it becomes kref-managed.  For that to work on the ODP
path, its get_mr() error handling is converted from a bare kfree() to
kref_put(..., __rds_put_mr_final), with r_trans_private cleared first
since it holds an ERR_PTR there; both sites then tear down through
the same path and a future error-path change cannot silently leak or
double-drop the reference.

Fixes: eff5f53bef75 ("RDS: RDMA support")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: port to net-next (sock_hold/sock_put in place of the UEK
 rds_sock_addref/rds_sock_put helpers); also balance the reference on
 the rds_cmsg_rdma_args() ODP path and unify its error path with
 __rds_put_mr_final(); update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v2, v3: unchanged.
v4:
 - Take the socket reference next to kref_init() on the ODP path too,
   and tear its get_mr() error path down through __rds_put_mr_final()
   so both allocation sites follow the same rule.
 - Document the counted reference at the r_sock field.

 net/rds/rdma.c | 14 +++++++++++++-
 net/rds/rds.h  |  5 ++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index f360a7b3b5fe7..078090d292fa3 100644
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
@@ -759,7 +764,12 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 			RB_CLEAR_NODE(&local_odp_mr->r_rb_node);
 			kref_init(&local_odp_mr->r_kref);
 			local_odp_mr->r_trans = rs->rs_transport;
+			/* The MR can outlive its socket: a socket
+			 * reference is held until the final kref is
+			 * dropped in __rds_put_mr_final().
+			 */
 			local_odp_mr->r_sock = rs;
+			sock_hold(rds_rs_to_sk(rs));
 			local_odp_mr->r_trans_private =
 				rs->rs_transport->get_mr(
 					NULL, 0, rs, &local_odp_mr->r_key, NULL,
@@ -768,7 +778,9 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 				ret = PTR_ERR(local_odp_mr->r_trans_private);
 				rdsdebug("get_mr ret %d %p\"", ret,
 					 local_odp_mr->r_trans_private);
-				kfree(local_odp_mr);
+				local_odp_mr->r_trans_private = NULL;
+				kref_put(&local_odp_mr->r_kref,
+					 __rds_put_mr_final);
 				ret = -EOPNOTSUPP;
 				goto out_pages;
 			}
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 14bff7440b796..2db49573dacd5 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -320,7 +320,10 @@ struct rds_mr {
 	unsigned int		r_invalidate:1;
 	unsigned int		r_write:1;
 
-	struct rds_sock		*r_sock; /* back pointer to the socket that owns us */
+	struct rds_sock		*r_sock; /* socket that owns us; counted
+					  * reference, dropped by
+					  * __rds_put_mr_final()
+					  */
 	struct rds_transport	*r_trans;
 	void			*r_trans_private;
 };
-- 
2.25.1

