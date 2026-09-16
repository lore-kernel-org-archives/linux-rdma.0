Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95747379C40;
	Wed, 16 Sep 2026 04:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533412; cv=none; b=J5Fmq955jooVBJyOAPf3uRatAi44F01fy3Dz0vgVIf0WvlIIHDT4eWpIgkOnFW7XnM0eTaA6fvXdpO6tvWIF5QGTeeR0eqZpT0Ov9cxB+ShXEgzcN0kORgSVzYJy1QDau8G/wPPbs6MnP1BQPKKB0wPAKvCx+j8eKMPWbX1KqE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533412; c=relaxed/simple;
	bh=gGgqnDmzpu6PWLrMlgdT3Lyfemlr4tM3rdbvoK4NDto=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OBb19vr8mgU5pAEKmJ5UfA22CdbKZAZnHU7LOQzrFDlgmcK2nM6HRtNrLMLHTQnSir+TJDtXYGiO/+mBcjdc6qVvl0iH33GanhPauaSHaMG+mrAl8OT34SkS8gW0yci+u3HTvtxxxPxac8eZ4NxkdFs0Qsjaowa/llRyEkOpcAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8Y4iGMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8Y4iGMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE91F00899;
	Wed, 16 Sep 2026 04:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533411;
	bh=tDVkrkfkB4/KiHCzG3hNLwqX7O0DdUn50y8/99gIvhg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=C8Y4iGMRE8htTwuo49anZa77TtS9wBKNAcU/FMMfz57pCVCGO4QmJ8AqhzhbJh6Z8
	 1QWUYNk0LgqZsJEzN50VCWM6QNkFmNEyGvloy4mSVz+BPXZ+kcaKfrpbJRXwDeJHOh
	 FbS48325mk58VWqxOZX9YAwwBpcKwJVnjE6NURFRz1D6W9PRuGl2koHX+NDqG/ItpE
	 cE6UAX80r2ffuspNW/w1lW4AaPixrTMVcDh8fbpNHb4JVmoCrcvEmTh8ufUfR92P34
	 F0CfzFEqaRcGFt8g/nEwjpQuZqyp5MRkhI14ZPIhC1LXY3UL69dYjHWm5meYG1EDX2
	 yVy0b0ZG6aYeQ==
Subject: Re: [PATCH net-next v2 8/9] net/rds: drop rds_conn_count in favor of
 t_conn_count
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:50 +0000
Message-ID: <178953341064.22033.4344829262087873675@kernel.org>
In-Reply-To: <20260912035027.27447-9-achender@kernel.org>
References: <20260912035027.27447-9-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Changelog inaccuracy in "net/rds: drop rds_conn_count in favor of
  t_conn_count": the commit message states that removing the…

--

net/rds: drop rds_conn_count in favor of t_conn_count

This removes the global rds_conn_count now that each transport tracks its
own connections in t_conn_count, and seeds the per-path workqueue names
from t_conn_count instead.  The rds_conn_lock round-trip that existed only
to decrement rds_conn_count is dropped from rds_conn_destroy_fini().

> Removing the counter also removes the rds_conn_lock round-trip that
> rds_conn_destroy_fini() took solely to decrement it, leaving the
> free path lock-free.

[Severity: Low]
Is the free path really lock-free after this change?

rds_conn_destroy_fini() still calls rds_conn_path_free() for every path,
and that ends up in destroy_workqueue():

net/rds/connection.c:rds_conn_path_free() {
	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);
		cp->cp_wq = NULL;
	}
	...
}

destroy_workqueue() drains the queue and takes wq_pool_mutex, so it can
sleep.  The tail of rds_conn_destroy_fini() also takes the wait-queue
spinlock via wake_up_all(&rds_conn_freed_waitq).  What this patch removes
is the last rds_conn_lock acquisition, not all locking.

The concern with the current wording is that a later reader or a
backporter could take "lock-free" to mean the final rds_conn_put() may be
dropped from atomic, IRQ or softirq context, which this path cannot
tolerate because destroy_workqueue() may sleep.

The last patch of this series, "net/rds: hold a connection reference from
struct rds_incoming", states the opposite property:

  "The final rds_conn_put() runs the free path, which destroys the
   per-path workqueues and therefore may sleep, so the last reference has
   to be dropped from process context"

Would something like "removes the last rds_conn_lock round-trip from the
free path" be more accurate here?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 1ec141d6faa38..11813f93961d1 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -656,7 +654,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  						   c_refcount);
>  	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>  	struct rds_transport *trans = conn->c_trans;
> -	unsigned long flags;
>  	int i;
>  
>  	for (i = 0; i < npaths; i++)
> @@ -665,10 +662,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	kfree(conn->c_path);
>  	kmem_cache_free(rds_conn_slab, conn);
>  
> -	spin_lock_irqsave(&rds_conn_lock, flags);
> -	rds_conn_count--;
> -	spin_unlock_irqrestore(&rds_conn_lock, flags);
> -
>  	/* only after everything the transport module owns has been
>  	 * freed above may its unload proceed
>  	 */

The code change itself looks fine; only the changelog wording seems to
overstate the result.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
