Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9818484235;
	Thu,  1 Oct 2026 06:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835375; cv=none; b=ZtHyfybGHvBeTlD4QXwvTBEVNx+6DeNgw67xduaRqAldBElgSHq2EYatCTOF6W7HY+eyg6rb/gGAtSNHGiiVpBemPrfet1jMrnQ87SKQLYJr0NX7q+79AFCAZRhT/2TIjzMNiikawIX35qT0H7HMsHhNuyvcG0L/tWZVQuf8m84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835375; c=relaxed/simple;
	bh=JYJtqzVfoUk2cDF6Z7A+Rtg8X6hTjICCRTAzIcLj2sk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pxERNP93cVFM/cha1kJPT/YsnCx7sTCJrY7fEwZJH05tANtNxJ8Bf2r9RJaDa33wrGbKl8n6tMDCiso93ad90f/QyeWK0Mu4JHGmyMliqZfP1ZQVHlveb0ESjWbUZ9B2HNl0rbkYzPwIodptIPYe8LSFeR9pZDmKZxsLR+Yom5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5UAyVqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5UAyVqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6631F0089A;
	Thu,  1 Oct 2026 06:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835373;
	bh=HnkVDMf83TJx/98Hci354poIlcbvxS+YITeQuEMBKV0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=V5UAyVqKtKBrQ8Hn0sx0iyE2cjhlrZ9vMQGJoYXqjIM9N1530LDkmnsJXfZDaOnET
	 xm0vO3DuTrgbJxH8ZPGxYc00Ef8YTmHGXOGM0gNgrcWzvZPKVEkwhM0I7Y0Jfcb6t6
	 ehtsfOkV4i0AZ0wAY1QKy55gubUwV37OMJXB820uVoJUDYXOlgsruWwpve0nTsjNRC
	 Ui9LXa1K+XQrAi/75E5ejJQ6s8ISsGSX9hXno24cKOsAv+lvZFyO9xriuvdhgKJR6I
	 uq9azEFt9NA5XSYyZ5HbHvALBxEx9gMH/k9Fb5zLNE5aPDj5nyn1J/jpyhUcAsdSx8
	 asNgnt6mKMeSw==
Subject: Re: [PATCH net-next v7 09/12] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:13 +0000
Message-ID: <179083537309.434549.10710005666321213055@kernel.org>
In-Reply-To: <20260927061448.167862-10-achender@kernel.org>
References: <20260927061448.167862-10-achender@kernel.org>
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

- [Low] The commit message does not match what the code changes actually
  do.

--

net/rds: take cp_lock to purge cp_send_queue in the quiesce

This commit changes rds_conn_path_quiesce() so that cp_send_queue is
spliced onto a local list under cp_lock before the message references
are dropped. It also clears RDS_MSG_ON_CONN on each spliced message
while holding the lock, and removes the
BUG_ON(!list_empty(&rm->m_sock_item)) check from the purge loop.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 83e59fcaccea6..1d7932cac0358 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -551,12 +553,24 @@ static void rds_conn_path_quiesce(struct rds_conn_path *cp)
>  	rds_conn_path_drop(cp, true);
>  	flush_work(&cp->cp_down_w);
>  
> -	/* tear down queued messages */
> -	list_for_each_entry_safe(rm, rtmp,
> -				 &cp->cp_send_queue,
> -				 m_conn_item) {
> +	/* Tear down queued messages.  Every path that adds to
> +	 * cp_send_queue does so under cp_lock; take it here too.  No
> +	 * sender can still be running at any destroy trigger, so this is
> +	 * lock discipline rather than a race fix: nothing here tells a
> +	 * sender that the queue is closed.
> +	 */
> +	spin_lock_irqsave(&cp->cp_lock, flags);
> +	list_splice_init(&cp->cp_send_queue, &purge);
> +	/* Give up the queue's claim on each message while still under
> +	 * the lock, so that rds_send_drop_to(), which decides ownership
> +	 * of the connection-queue reference by this bit, neither drops
> +	 * it a second time nor unlinks the message from our list.
> +	 */
> +	list_for_each_entry(rm, &purge, m_conn_item)
> +		clear_bit(RDS_MSG_ON_CONN, &rm->m_flags);
> +	spin_unlock_irqrestore(&cp->cp_lock, flags);
> +	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
>  		list_del_init(&rm->m_conn_item);
> -		BUG_ON(!list_empty(&rm->m_sock_item));
>  		rds_message_put(rm);
>  	}

[Severity: Low]
The commit message says:

  drop_to decides whether it owns the queue's reference by test_and_clear
  on RDS_MSG_ON_CONN; the purge left that bit set, so a message it had
  already put could be put a second time by a close() or
  RDS_CANCEL_SENT_TO racing it.

Could that double put happen before this patch? Because of the BUG_ON,
the old loop only called rds_message_put() on a message whose
m_sock_item was empty.

rds_send_queue_rm() links m_sock_item before m_conn_item, and nothing
links m_sock_item again after it has been emptied:

net/rds/send.c:rds_send_queue_rm() {
    ...
		list_add_tail(&rm->m_sock_item, &rs->rs_send_queue);
		set_bit(RDS_MSG_ON_SOCK, &rm->m_flags);
		rds_message_addref(rm);
    ...
		list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
		set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
    ...
}

rds_send_drop_to() can only reach a message through m_sock_item, either
on rs_send_queue or on its own local list. It empties m_sock_item only
in its second loop, and that loop runs after the first loop's
test_and_clear_bit():

net/rds/send.c:rds_send_drop_to() {
    ...
	list_for_each_entry(rm, &list, m_sock_item) {
		...
		if (!test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags)) {
		...
	}
    ...
	while (!list_empty(&list)) {
		rm = list_entry(list.next, struct rds_message, m_sock_item);
		list_del_init(&rm->m_sock_item);
    ...
}

So a message that a racing close() or RDS_CANCEL_SENT_TO could still
reach would have had a non-empty m_sock_item. The old BUG_ON would have
fired before the put happened.

It looks like the drop_to-after-purge double put only becomes possible
once the BUG_ON is removed. The clear_bit(RDS_MSG_ON_CONN) is what makes
that removal safe; it does not fix an existing double put.

The new code does keep the references balanced if a socket still has
the message queued. After the purge clears the bit and drops the
connection-queue reference, a later rds_send_drop_to() skips its first
loop and drops only the socket-queue reference.

The one pre-patch hazard runs the other way. The unlocked
list_for_each_entry_safe() could follow a stale next pointer to a
message that rds_send_drop_to() had already unlinked and put. Taking
cp_lock is what closes that, not the ON_CONN clear.

Could the commit message be reworded to describe what each change does?

Also, both the commit message and the new comment say no sender or
closer can be running at any destroy trigger. If so, the main visible
change at the current callers is that the BUG_ON is gone. It was the
only runtime check that no socket still had messages on cp_send_queue
at destroy. Is losing that check intended?

>  	if (cp->cp_xmit_rm)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
