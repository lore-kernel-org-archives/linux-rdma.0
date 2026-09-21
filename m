Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C671D46DFFA;
	Mon, 21 Sep 2026 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982143; cv=none; b=Lr4zCfNSf/oI1xwy2PzgzHTB2iREJbdYtYktqOS1aOsW2ckpZ40IBGsWnDC3KjnDKLbs66jcE30byWG8VQYYEiSN0+UimwZL/5evXFLnYqoATE9QmQaZFBOZV5UEMI+gtdGmd1FRRy3i/hpZ9vnfR5NNWPPMGHxhtD9t6jE1hho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982143; c=relaxed/simple;
	bh=xePakvel9sBaNuZT+EF7YqKll5FKyKDWsDQMVxL/VO8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e0sF+/PcMcdFEP4/194gzvi5VpRLZWtqH7QDMyay/lmLNKawa7gDd+kOGo3rPCBV/bPf4DXnzDMLSkwZPpbBmzJ+NMatFAwpwl9KVaIWXWPPMoKtRW30ezMKjkpQ181m29OY911bo9FwbmyPlKifhLarQg3l1lokqpEcYuXLMg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVcb9Y/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVcb9Y/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E7A1F00893;
	Mon, 21 Sep 2026 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982141;
	bh=LlNlq2VrngCBqZG37gCfBwQV+B/RRl0zC5mhe80BXoo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aVcb9Y/C1XiLViPVTDnnf0BV1evOMyAw/6ezDQto013t7To9cRC2vHeXxB/SvQUyg
	 9Tc0YLI9b1O+VT0oGhwHGgcOF1zod40DHTBvOdxGmMZ1ILNwxCZWcCQTJ6NLU6EBzP
	 C5cnwB0+iN5blk09/bToGXk2cI+An7bTUJnwLUn4UBfQccqumD29IsbslPDqqHyzdk
	 I6Xu/bp8wzd/5G8R8V94m90KQDCNVswvagYCncvTtRDRZ2gl6cHtPg1kL50rPGEaET
	 563xqhh91iMg/TzduZ6KcznwXCBhT/fYpuNtq8yQMhuPPeLNUBnPWtwmmJyJvioyHd
	 5qbkAIfMeojNg==
Subject: Re: [PATCH net-next v4 12/12] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:40 +0000
Message-ID: <178998214084.2160803.755745892282571698@kernel.org>
In-Reply-To: <20260917073958.174056-13-achender@kernel.org>
References: <20260917073958.174056-13-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message's reachability claim — "reaching the use-
  after-free requires freeing a connection out from under a live socket,…
- [Low] The patch closes a reported, KASAN-confirmed use-after-free
  (`rds6_inc_info_copy()` reading a freed `rds_connection` via…

--

net/rds: hold a connection reference from struct rds_incoming

This makes every assignment of rds_incoming->i_conn take a connection
reference, dropped from rds_inc_put() and from the new rds_message_free()
helper, so a connection stays allocated while incs that arrived over it
are still queued on socket receive queues.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

The two comments below are about the changelog only, so the diff hunks
are snipped.

>     This is not a stable candidate: reaching the use-after-free requires
>     freeing a connection out from under a live socket, which needs
>     CAP_SYS_MODULE, netns teardown or physical device removal, and the fix
>     depends on the connection reference counting introduced earlier in this
>     series.

[Severity: Medium]
Is this list of prerequisites complete?  There looks to be a fourth way
to free a live connection that needs none of the three, in
rds_ib_cm_connect_complete():

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	dp = event->param.conn.private_data;
	...
		major = dp->ricp_v4.dp_protocol_major;
		minor = dp->ricp_v4.dp_protocol_minor;
	...
	if (major) {
		rds_ib_set_protocol(conn, RDS_PROTOCOL(major, minor));
	...
	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supported\n", ...);
			rds_conn_destroy(conn);
			return;
		}
	}
}

The version comes from the peer's CM private data, and this callback is
reached from live event handling:

rds_rdma_cm_event_handler_cmn() -> RDMA_CM_EVENT_ESTABLISHED
  -> trans->cm_connect_complete()
    -> rds_ib_cm_connect_complete()
      -> rds_conn_destroy()

Since the same struct rds_connection is reused across reconnects for a
given laddr/faddr/tos tuple, can a reconnect on which the peer advertises
an unsupported version destroy a connection that unread incs from the
previous session still point at, without CAP_SYS_MODULE, netns teardown or
device removal?

If so, could the paragraph be reworded to cover that path, and the stable
reasoning re-derived from it?  The dependency on the reference counting
introduced earlier in the series is a separate argument.

One related note: the sibling patch "net/rds: pin the connection across
RDMA-CM event handling" states this call "has meanwhile been switched to
rds_conn_drop() by commit f97d8c7bab78", but at this revision
rds_ib_cm_connect_complete() still calls rds_conn_destroy(conn).  Which of
the two is right?

>     Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
>     Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

[Severity: Low]
Should this carry a Fixes: tag for the commit that introduced the bare
i_conn assignment in rds_inc_init()?

The changelog documents two user-visible crashes, the KASAN report in
rds6_inc_info_copy() and the panic in rds_ib_inc_free(), and the second
one is reachable on the pre-series code, where nothing keeps the
connection alive for a queued inc:

net/rds/ib_recv.c:rds_ib_inc_free() {
	struct rds_ib_connection *ic = inc->i_conn->c_transport_data;
	...
	rds_ib_recv_cache_put(&ibinc->ii_cache_entry, &ic->i_cache_incs);
}

reached by rds_release() -> rds_clear_recv_queue() -> rds_inc_put().

The other patches in this series that fix pre-existing defects do carry
one (e266df6b -> Fixes: 745cbccac3fe, 23531807 -> Fixes: 1c5113cf796b,
d4f3ede0 -> Fixes: ebeeb1ad9b8a, ef753cfe -> Fixes: cdc306a5c9cd3), so
this one looks inconsistent with the rest.  Even if no backport is
possible because the fix depends on the earlier reference counting, would
naming the introducing commit, or stating which kernels are exposed, help
downstream trees decide whether they are affected?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
