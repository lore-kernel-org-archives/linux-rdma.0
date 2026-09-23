Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346E2440A34;
	Wed, 23 Sep 2026 07:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147498; cv=none; b=rloTtYABZcaaGtUPCsONVHIt5NCp/B7iw+tyVrKG7QBFsYU9h2XCL0rKv1av9xTxPIjvHNTExViBHskSTqurr+kUwa3DwGf7oThLr21CHbDuk5WPZINPrXc+SzfZgVVkISyPJnin/topa29NGRYjkBWLxQTBT46dwP7RqNfmEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147498; c=relaxed/simple;
	bh=LEWEiJYBJp+uwPB8n/S6TWdfEWnw3lijyMkz+DaV9pw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fi7fivJQpDHjFmeKMoLOaC688d6WqCnZ4+9OUdHuL0Sfx82d9P+HU+Fi4DwVGwGYznXv1VsJWxmzKVSKWx0J3aUOCUVwAZqy01M6R/6Tjgz5yr2FCVNJhJKayctxYfpaxO1H0r0mD4oB7P6EsufY0q943sxaQvrtXNFXx+NI6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxV8sgsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxV8sgsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9541F00893;
	Wed, 23 Sep 2026 07:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147495;
	bh=tWPxxxoq9sxTBc1nEvSh/BuJGcqyYk8Rpn1Z3OMGt8k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kxV8sgsxvMP3mqW5YM+lgSZqs+ix3uGguuLyOoCO2K35PZIC2yg8H/EB7jHazL47i
	 UHzmne5au6C1V7t3kZrCbGUXgnnDNKrrA1XuTFdspJATvjidAMPPlJ9jpmfaeFdsR3
	 QHz8bzU04+xtN06ntNbLdbO3AOYnx81EdX24pl1wFgYyd1sdiQ5iaPd4Vsqyr23sL6
	 eKweUD210Kr6B698H/jyZ+piPFYhpYglDA31ZWfDQylSno5S+ktM/z/YqiEbVNAR0j
	 nw1qsASpSrwd131gaYAbs9BEQu3oVSfPjoXSuL8BHEYSDIl7EQHlXxmj/+Jnqceesa
	 QXmmsWbUugneA==
Subject: Re: [PATCH net-next v5 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:34 +0000
Message-ID: <179014749455.2160803.10795988973893823504@kernel.org>
In-Reply-To: <20260919061149.250658-4-achender@kernel.org>
References: <20260919061149.250658-4-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Commit-message precision only (no reachable bug at this SHA): the
  opening paragraph of "net/rds: guard every work-requeueing site with…

--

net/rds: guard every work-requeueing site with rds_destroy_pending()

This adds the rcu_read_lock() + rds_destroy_pending() guard to five sites
that re-arm path works: the two IB send paths, the IB recv refill, the TCP
accept path and the multipath reconnect in rds_sendmsg().  The four
self-requeues in rds_send_worker() and rds_recv_worker() are deliberately
left unguarded.

The code changes themselves look fine to me; my only question is about the
changelog, so the diff hunks are snipped.

> net/rds: guard every work-requeueing site with rds_destroy_pending()
>
> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  The sites that can re-arm those works are
> supposed to test rds_destroy_pending() under rcu_read_lock() first,
> paired with the synchronize_rcu() in the destroy path, so that no new
> work can be queued once the cancellation has begun.

[Severity: Low]

Is "paired with the synchronize_rcu() in the destroy path" the right
attribution at this point in the series?

At this commit the predicate has no per-connection destroy term:

net/rds/rds.h:
	static inline bool rds_destroy_pending(struct rds_connection *conn)
	{
		return !check_net(rds_conn_net(conn)) ||
		       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
	}

The only per-path destroy bit the IB hook consults is RDS_DESTROY_PENDING:

net/rds/ib.c:rds_ib_is_unloading()
	return (test_bit(RDS_DESTROY_PENDING, &cp->cp_flags) ||
		atomic_read(&rds_ib_unloading) != 0);

and that bit is defined in rds.h but never set anywhere in net/rds, so the
IB hook reduces to "the module is unloading".

The synchronize_rcu() inside rds_conn_destroy() publishes only the
hlist_del_init_rcu() of c_hash_node:

net/rds/connection.c:rds_conn_destroy()
	spin_lock_irq(&rds_conn_lock);
	hlist_del_init_rcu(&conn->c_hash_node);
	spin_unlock_irq(&rds_conn_lock);
	synchronize_rcu();

rds_destroy_pending() does not read c_hash_node, so that grace period is
not what makes the new guards fire.  The grace periods that do are in the
callers: rds_ib_exit() and rds_tcp_exit() call their set_unloading()
helpers followed by synchronize_rcu(), and cleanup_net() is what makes
check_net() false for the netns-teardown callers.

The last paragraph of the changelog does disclose the limitation:

> With the predicate as it stands the guards cover the netns teardown and
> module unload cases; the following patch extends it to the destroy of a
> single connection.

and the following patch in the series does close the gap: rds.h grows
READ_ONCE(conn->c_destroy_in_prog) in the predicate, rds_conn_destroy()
does WRITE_ONCE(conn->c_destroy_in_prog, true) before hlist_del_init_rcu()
and synchronize_rcu(), RDS_DESTROY_PENDING is removed, and all five guards
added here survive.

Walking the rds_conn_destroy() callers at this commit, none of them runs
with the netns alive and the module loaded: rds_ib_destroy_nodev_conns()
is reached only from rds_ib_exit(), rds_tcp_destroy_conns() and
rds_tcp_kill_sock() only from rds_tcp_exit() and rds_tcp_exit_net(),
rds_loop_kill_conns() likewise, and ib_cm.c no longer calls it.  So no
crash path is reachable here and no code change seems needed - would it be
worth rewording the first paragraph to credit the unload and netns grace
periods rather than rds_conn_destroy()'s own synchronize_rcu()?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
