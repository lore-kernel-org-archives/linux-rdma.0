Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0AD24DCF9;
	Tue, 24 Feb 2026 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949782; cv=none; b=u+v+QAJwZAihoAdiiY9oEpHsKELzcwmPNfJVh5iq7jL5GeT3oWeJ+xlGNsmwi7lII2aVSu99gHMw2LcXSAgbW0z0DE9yPdoe1p/r6MUw1vksQBs5KRpTu7SHI6vw8pUucfsXDzAd0jalrE6fvl+btEwjrTs01udBr3LnqHaRHbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949782; c=relaxed/simple;
	bh=Jpzg3XcQH9T6/RZ4fN6CUybReuS0zIKiZ1EQ8AI4wBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXQguiYv2+utYM4WYrBn/fIG4EsQZWDo7bnGY9pf1uJ0k/89/x50hkTv0CMe0ASnkVP47QSgM2bRuy6dS64d8ot6dJQjureWjYyfPodnpXPvVIbJdeFtAbI2QrVdT6CZt/5njxakEcqPIm3Bm8MsWAVlOH6do7z+xdMNT2ZeuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mc1wlA8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mc1wlA8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46236C116D0;
	Tue, 24 Feb 2026 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771949782;
	bh=Jpzg3XcQH9T6/RZ4fN6CUybReuS0zIKiZ1EQ8AI4wBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mc1wlA8hy64hMUNU9Jqm8OcTRs+u83cX+Lkgu74ig9i1lNFMtTdiZmZxGPNo0MVvt
	 vJ9foNO3ZA45GT9+8jOQECWUBo3+p1sxztzVYDTi+PBss6QWIrE0Pb7Ftpy/0kxX3A
	 qJmxHR0mNb7M66B+oJ3bxKr+RcyVHIR6us0RQqV8CwA0nX/o86OKyrmUPhLufXkMYO
	 MKUHoE6MyH2FVJRJNxdXjQFs84SwFgJlxVgvjQxuQdjFbyfQMmciOosAsX1w3Hn6Cw
	 AsjdkHO73p1QlHq3UXTvq31/vOV6+HE4NUpHrC5JL/reDp+fJ8Qc/2Yoa2jpKXKcx0
	 v8r5t44DBHiuA==
From: Simon Horman <horms@kernel.org>
To: achender@kernel.org
Cc: Simon Horman <horms@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kuba@kernel.org,
	linux-rdma@vger.kernel.org,
	allison.henderson@oracle.com,
	edumazet@google.com,
	netdev@vger.kernel.org,
	rds-devel@oss.oracle.com,
	pabeni@redhat.com
Subject: Re: [net-next,v5,1/2] net/rds: Refactor __rds_conn_create for blocking transport cleanup
Date: Tue, 24 Feb 2026 16:16:07 +0000
Message-ID: <20260224161607.143920-1-horms@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223221918.2750209-2-achender@kernel.org>
References: <20260223221918.2750209-2-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
net/rds: Refactor __rds_conn_create for blocking transport cleanup

The next patch will delegate fanout operations to a background worker,
which adds cancel_work_sync() to rds_tcp_conn_free(). This is called
during a connection cleanup and requires an operations to be blocking.
However, the error path of __rds_conn_create() currently calls
trans->conn_free() while holding rds_conn_lock (spinlock) and
rcu_read_lock, which creates an atomic context where cancel_work_sync()
cannot sleep.

Link: https://ci.syzbot.org/series/1a5ef180-c02c-401d-9df7-670b18570a55

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -170,6 +170,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  	struct hlist_head *head = rds_conn_bucket(laddr, faddr);
>  	struct rds_transport *loop_trans;
>  	struct rds_conn_path *free_cp = NULL;
> +	struct rds_transport *free_trans = NULL;
>  	unsigned long flags;
>  	int ret, i;
>  	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> @@ -305,7 +306,7 @@
>  	if (parent) {
>  		/* Creating passive conn */
>  		if (parent->c_passive) {
> -			trans->conn_free(conn->c_path[0].cp_transport_data);
> +			free_trans = trans;
>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
>  			conn = parent->c_passive;

[ ... ]

> @@ -321,18 +322,7 @@
>  		found = rds_conn_lookup(net, head, laddr, faddr, trans,
>  					tos, dev_if);
>  		if (found) {
> -			struct rds_conn_path *cp;
> -			int i;
> -
> -			for (i = 0; i < npaths; i++) {
> -				cp = &conn->c_path[i];
> -				/* The ->conn_alloc invocation may have
> -				 * allocated resource for all paths, so all
> -				 * of them may have to be freed here.
> -				 */
> -				if (cp->cp_transport_data)
> -					trans->conn_free(cp->cp_transport_data);
> -			}
> +			free_trans = trans;
>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
>  			conn = found;

Does this create a use-after-free in other threads that iterate the
transport list?

Looking at the race-loss path when rds_conn_lookup() finds an existing
connection, the old code called trans->conn_free() before
kmem_cache_free(conn). Now the patch defers conn_free() to after
locks are released at the out: label, but kmem_cache_free(conn) still
executes inside the critical section (line 327 after this change).

This creates a window where rds_tcp_connection objects remain on
rds_tcp_conn_list with tc->t_cpath->cp_conn pointing to the
already-freed conn object.

The timeline would be:

CPU 0 (__rds_conn_create race-loss)
  spin_lock_irqsave(&rds_conn_lock)
  found = rds_conn_lookup()  // finds existing conn
  free_trans = trans
  free_cp = conn->c_path
  kmem_cache_free(rds_conn_slab, conn)  // conn freed
  conn = found
  spin_unlock_irqrestore(&rds_conn_lock)
  rcu_read_unlock()
  // ... later at out: label
  free_trans->conn_free(...)  // removes tc from list, but too late

CPU 1 (rds_tcp_kill_sock)
  spin_lock_irq(&rds_tcp_conn_lock)
  list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node)
    c_net = read_pnet(&tc->t_cpath->cp_conn->c_net)  // UAF here!

The commit message states "connections that 'lose' the race are safe to
clean up outside the critical section since they were never added to
the hashtable, and therefore are inaccessible to other threads."

However, while the rds_connection was never added to the RDS hashtable,
the transport data (tc) WAS added to rds_tcp_conn_list during
rds_tcp_conn_alloc(). Looking at that function in net/rds/tcp.c:

rds_tcp_conn_alloc() {
    // ... allocate tc structures ...
    spin_lock_irq(&rds_tcp_conn_lock);
    for (i = 0; i < RDS_MPATH_WORKERS; i++) {
        tc = conn->c_path[i].cp_transport_data;
        tc->t_tcp_node_detached = false;
        list_add_tail(&tc->t_tcp_node, &rds_tcp_conn_list);
    }
    spin_unlock_irq(&rds_tcp_conn_lock);
}

So the tc objects are accessible to other threads via the transport
list, even though the conn itself never made it into the RDS hashtable.

Functions that iterate rds_tcp_conn_list include:
- rds_tcp_kill_sock() at net/rds/tcp.c:610
- rds_tcp_destroy_conns()
- rds_tcp_sysctl_reset()

All of these dereference tc->t_cpath->cp_conn during iteration.

In the old code, conn_free() ran BEFORE kmem_cache_free(conn), so the tc
was removed from the list before conn was freed. No UAF window existed.

Could the kmem_cache_free(rds_conn_slab, conn) be moved to after
conn_free() at the out: label, or should conn_free() be called before
kmem_cache_free() inside the critical section for the race-loss paths?

> @@ -349,9 +339,23 @@
>
>  out:
>  	if (free_cp) {
> -		for (i = 0; i < npaths; i++)
> +		for (i = 0; i < npaths; i++) {
> +			/*
> +			 * The trans->conn_alloc call may have allocated
> +			 * resources for the cp paths, which will need to
> +			 * be freed before freeing cp itself.  We do this here
> +			 * after the out: label so it runs outside the
> +			 * rds_conn_lock spinlock and rcu_read_lock section,
> +			 * since both destroy_workqueue() and conn_free can
> +			 * block. The local free_trans pointer is only set in
> +			 * the race-loss paths where conn_alloc() succeeded.
> +			 */
> +			if (free_trans && free_cp[i].cp_transport_data)
> +				free_trans->conn_free
> +					(free_cp[i].cp_transport_data);
>  			if (free_cp[i].cp_wq != rds_wq)
>  				destroy_workqueue(free_cp[i].cp_wq);
> +		}
>  		kfree(free_cp);
>  	}
