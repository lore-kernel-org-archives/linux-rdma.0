Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907373B7749;
	Wed, 16 Sep 2026 04:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533413; cv=none; b=RAO1afXUYn0fKVkjC9wYeognwYvR7EMul7wNxmqBcyfZ8FxPBtBRemLEbTYiSCBNSmlb448BP6PCg8/S3hLx6AwDA7bMwDcOluAW1IiWeABnmy0Nlyag6D8lF9V6L7ENHoqcv6Y74cb3lscuXpbY/XiLuC0SgCPIENNHVjBq3sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533413; c=relaxed/simple;
	bh=PYH5yUWQKGG2jj/PHswv+dP18uRh+PAQehHZflsbolc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DUzgSwzKBjH/Cnq8uybzBef5YCmHO3Pk75/IChs8nm7Xp4jIdUmw/9S/g54eEMGbm0cVAm+haIs3EIyQbghqvzOpzP33wUuvmjTmlm229aqG9TeYyXiRs4F1MpIPAJagn2t/+mwaFCAik8jPjLaqadYHV201OWfZvKFHjzb+jCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn/OGjLQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn/OGjLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9A91F000FF;
	Wed, 16 Sep 2026 04:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533412;
	bh=YEnae5C4Id2yrTp/5M8MCke2lpYvwXxBUYH7lMMZ824=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hn/OGjLQHENefDOC1KYYtw3uwBt/3rsq1dFYQloy58scf+qBpizzimw0VLcWvpyCM
	 8XAO6fUwLfxZJ0BbxqLad3tJUTEO58KFQPYpT9KAS/OYjJAD0y2yeSmeHYJ1OZCBS0
	 RgdUo+S8myNDjtCm/2qivW7vGX/7mdV6KeKyRedHLzWncHu6cuyLqmd+LjgPG5rmv4
	 s+ZKSXtCNY6NsaZeDD9BYE+95chdsl8iT4rMNlBO7waO+9VNwoPkM+6i7b7cPOEG1V
	 HPybvlkivin5Nq3m0r7Zs3S1H6exGZ0gjjxC25KBxRhTNvLSJZsf/PJ6oNNpNCatJb
	 Cj9I2cySRlXyQ==
Subject: Re: [PATCH net-next v2 9/9] net/rds: hold a connection reference from
 struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:51 +0000
Message-ID: <178953341168.22033.7134703325658795703@kernel.org>
In-Reply-To: <20260912035027.27447-10-achender@kernel.org>
References: <20260912035027.27447-10-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 2

- [Low] The commit fixes a reported, user-visible use-after-free (KASAN
  slab-use-after-free in rds6_inc_info_copy() via rds_info_getsockopt(),…
- [Low] In rds_recv_incoming() (net/rds/recv.c), the cross-netns
  rejection comment at lines 424-431 still states that netns teardown…

--

net/rds: hold a connection reference from struct rds_incoming

Every assignment of struct rds_incoming->i_conn now takes a connection
reference, so an inc parked on a socket receive queue (or an m_inc on a
send queue) keeps its connection allocated. The references are dropped
from rds_inc_put() and from a new rds_message_free() helper.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

Two questions, one about the tag block and one about a comment that the
patch appears to make stale.

>     Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
>     Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
>     Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>

[Severity: Low]
Should this carry a Fixes: tag?  The change closes a reported
slab-use-after-free (rds6_inc_info_copy() reached from
rds_info_getsockopt(), and the panic in rds_ib_recv_cache_put() reached
through rds_release()->rds_clear_recv_queue()->rds_ib_inc_free()), but no
originating commit is named.

git blame on the inc->i_conn = conn assignment in rds_inc_init() points at
bdbe6fbc6a2f ("RDS: recv.c"), so the origin looks identifiable.  Other
patches in this series do carry the tag, for example "net/rds: make
rds_destroy_pending() cover single-connection destroy" with Fixes:
cdc306a5c9cd3 and "net/rds: guard every work-requeueing site with
rds_destroy_pending()" with Fixes: ebeeb1ad9b8a.

The commit message says in prose:

    This is not a stable candidate: reaching the use-after-free requires
    freeing a connection out from under a live socket

That reasoning is fine, but it is not something backport tooling parses,
and the tag block on its own does not say how far back the defect reaches.

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..b031c0b43af83 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -46,6 +46,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
>  {
>  	refcount_set(&inc->i_refcount, 1);
>  	INIT_LIST_HEAD(&inc->i_item);
> +	rds_conn_get(conn);	/* put in rds_inc_put() */
>  	inc->i_conn = conn;
>  	inc->i_conn_path = NULL;
>  	inc->i_saddr = *saddr;

[ ... ]

> @@ -325,6 +337,13 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
>  	unsigned long flags;
>  	struct rds_conn_path *cp;
>  
> +	/* every caller initialized @inc with rds_inc_init() or
> +	 * rds_inc_path_init() first, so i_conn already holds a reference.
> +	 * Take the new one before dropping the old, so that re-pointing an
> +	 * inc at the connection it already refers to cannot free it.
> +	 */
> +	rds_conn_get(conn);
> +	rds_conn_put(inc->i_conn);
>  	inc->i_conn = conn;
>  	inc->i_rx_jiffies = jiffies;
>  	if (conn->c_trans->t_mp_capable)

[Severity: Low]
Does this make the cross-netns comment further down in the same function
inaccurate?  That comment still reads:

net/rds/recv.c:rds_recv_incoming() {
    ...
	/*
	 * rds_find_bound() uses a global (netns-agnostic) hash table.
	 * An RDS connection created in netns A can match a socket bound
	 * in the init netns, delivering inc cross-netns with inc->i_conn
	 * pointing into netns A.  When cleanup_net() then frees that conn,
	 * any subsequent dereference of inc->i_conn is a use-after-free.
	 * Drop the inc if the receiving socket lives in a different netns.
	 */
	if (!net_eq(sock_net(rds_rs_to_sk(rs)), rds_conn_net(conn))) {
    ...
}

After this patch the inc owns a reference from rds_inc_init() or
rds_inc_path_init(), and rds_inc_put() releases it only after
->inc_free() has run:

		conn->c_trans->inc_free(inc);
		rds_conn_put(conn);

rds_conn_put() reaches kmem_cache_free() only when the kref hits zero, so
a cross-netns inc sitting on a receive queue keeps its connection
allocated across cleanup_net().

The check itself still looks wanted, since cross-netns delivery is wrong on
its own and an outliving conn leaves conn->c_net stale.  Could the comment
be reworded to state that reason rather than a use-after-free this patch
removes?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
