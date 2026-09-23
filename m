Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746B847A88B
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153682; cv=none; b=URYCHHwBbKtl8J9rWOLXaZzB5yQ++Uv8a60nNMIYTM7GJ9adJFMkK4YuHRGZa1pv7PfJhnO2jl9sIvJJk6Xr1+8agrTF1zMCZA3/Pb+p8bj4lugxKl3N+8pV1x7savsKdDVEoRNTVvsVKQWnBXBgK66OTkNaYWS6PVFGU1w6awI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153682; c=relaxed/simple;
	bh=JzN8QIpmqFQiCUmBIrCxZBqttpHGKab0HJfkLb7idCA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H8rEzZt777J6nceDVV7XXRVhLZErZpfvSLzPSUbU8QgOPuY+sRvDaxdleL/LoCpWydT/KM54TQdR4gp6BwUYRwf8EhUyyK6vAGAYqznOvmQSeTdg0ZcXNM+pjvWKx7pv0r9oZrHKWjSobPuoSmKITjewtfv/HeCzAorpXoA/k1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UchcMUFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UchcMUFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8E1F0089F;
	Wed, 23 Sep 2026 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153668;
	bh=WokBy09rVOcOWWVa2+E/GifQUi/pofsqhS1VIbSbavM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UchcMUFvZMhhpivtbPtw8c5imNqMkjB4y09NNkLxZ/rQRs3USjKmVdUwJ/DhKsAR4
	 jqCA5aTaLRIwIgsAHgDhu9HvorIupsD1L06Kxjtx+XHLItmC+KfjNjTIDkj7MjplDC
	 c4HA1BDfE+6aM4TCAHC8w12Rs7/0ovXI71Y5CIEhevZNP7oAX51yDVy4Ey6tqKNAEY
	 4LhSZl+24r8lrBoC3SyziQHOLUtnWLrJ+CMCfN8QQsmBWZMLI8T23fGucwYh6JQSR9
	 IU844qKx6tSYXObZQ5EPIhC/TH21D9k9gE72EGbE1qYgBSBIJ4V+Z3rALK9Q0kjKVp
	 6Nqi5AM8rA0mQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 09/12] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-10-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:27 +0000
Message-Id: <20260923085428.44F8E1F0089F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rds: BUG_ON panic in rds_conn_path_quiesce() from concurrent sendm=
sg
- [Low] rds: lockless read of rs->rs_tos introduces KCSAN data race
--

commit 9489b74a07c0708162de3f8489ff10b9010c01f0
Author: Allison Henderson <achender@kernel.org>

net/rds: take cp_lock to purge cp_send_queue in the quiesce

This commit modifies rds_conn_path_quiesce() to take the cp_lock when
purging the cp_send_queue. It splices the queue to a local list under
the lock to safely handle concurrent additions during the teardown walk.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -617,10 +619,15 @@ static void rds_conn_path_quiesce(struct rds_conn_p=
ath *cp)
>  	rds_conn_path_drop(cp, true);
>  	flush_work(&cp->cp_down_w);
> =20
> -	/* tear down queued messages */
> -	list_for_each_entry_safe(rm, rtmp,
> -				 &cp->cp_send_queue,
> -				 m_conn_item) {
> +	/* Tear down queued messages.  Every path that adds to
> +	 * cp_send_queue does so under cp_lock; take it here too rather
> +	 * than rely on the argument that nothing can be adding at this
> +	 * point.
> +	 */
> +	spin_lock_irqsave(&cp->cp_lock, flags);
> +	list_splice_init(&cp->cp_send_queue, &purge);
> +	spin_unlock_irqrestore(&cp->cp_lock, flags);
> +	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
>  		list_del_init(&rm->m_conn_item);
>  		BUG_ON(!list_empty(&rm->m_sock_item));

[Severity: High]
If a concurrent sender is executing rds_sendmsg(), can it add a message to
both the socket queue and connection queue via rds_send_queue_rm() after
the rds_destroy_pending() check?

If the newly added message is spliced here into the purge list, it will
still be present on the socket queue (m_sock_item). Will that cause this
BUG_ON() to trigger a kernel panic when the list_empty() check evaluates
to false?

>  		rds_message_put(rm);

[ ... ]

> diff --git a/net/rds/send.c b/net/rds/send.c
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1366,8 +1366,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr =
*msg, size_t payload_len)
> =20
>  		conn =3D rds_conn_create_outgoing(sock_net(sock->sk),
>  						&rs->rs_bound_addr, &daddr,
> -						rs->rs_transport,
> -						READ_ONCE(rs->rs_tos),
> +						rs->rs_transport, rs->rs_tos,

[Severity: Low]
Does removing the READ_ONCE() wrapper here introduce a KCSAN data race
warning?

Since rs_tos is read outside of the rs_lock and could be modified
concurrently by SIOCRDSSETTOS, it seems a lockless read without READ_ONCE()
might be unsafe.

>  						sock->sk->sk_allocation,
>  						scope_id);
>  		if (IS_ERR(conn)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D9
