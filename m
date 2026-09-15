Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFF5421220
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443463; cv=none; b=Ob8F7eZpZv3Nhb1OObH9sQNg/A2Nt4sbAP1ZU9azoZ9xV427OJjx4YIg2YFDhphmrF9OSbJjJ7x8amz0xCx3BFeSiCkEZ6ItkuVRwSgCL9GX4yF9NEXPh7OIrROnZbb198sfMiHSDKz/MG18Jk7CHnHCvxvCZ1o41//K49RM7Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443463; c=relaxed/simple;
	bh=NPCk3UNkuNr/wRMY5qZRG0qnHIZwtwdhV3lNmS+0vCg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZLgXxYSc2OORaDMZJOCT5WVswkmlgksTypkb8Q1qUnc1lgfaDh0M/y9zJ8+DJxllJbM6x27rzDi33cT0tRt7s+PCj+jCqYw6HT012Q2J3eBRB4Dmww8pNJ4jKP5Z8QhqIRXsOYKh+HKEOo4Ik4u4yT4Xt75drHHtNVkFeue1Zrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CL8A/0Gt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CL8A/0Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9455C1F00899;
	Tue, 15 Sep 2026 03:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443461;
	bh=6CIryginrCcqKSjPR8MT+kFroN1sDA3Y+VuinftscnY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CL8A/0GtrULO5XjqgC3tC6/1qCmoU4bAbFgZXgBehfh8FTFxL0ifuyMF9L8J7N6IT
	 hHbn3N2ffEJVTPa9vOSY04VzcB1BkWGPjspirHiF/PaUbRLC7T54zh3xxGg3AzfFbZ
	 FeUJgh07U7sUsqy47IFTlUHWUx2iggxs0GKXoMiWcFolxkqFKb2UumL4K3qa3wUn1/
	 mC54XINndC/2JXvRIvaK2iUwVwp1SzZPRHf18989Qh02b6DF1jt1Lmt8Ic6rekBKxG
	 k0NkDLgiw/0BdxmruPgRaCs6YM4L+pBuc2M3XMmzwXu1geRCDV0qlTNJSRgUdgdCqt
	 04BKz0fOmLMhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 13/13] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-14-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-14-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:41 +0000
Message-Id: <20260915033741.9455C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Race condition in `rds_send_probe()` can leak `rds_message` and co=
nnection reference during connection teardown.
--

commit 9f78a5cbb0d8c28990a439e07491dbc084983be8
Author: Sharath Srinivasan <sharath.srinivasan@oracle.com>

net/rds: hold a connection reference from struct rds_incoming

This commit ensures that every holder of rds_incoming->i_conn takes a
reference to the connection. This prevents a use-after-free when the
connection is destroyed by device removal or module unload while messages
are still queued on the socket.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev=
@gmail.com/

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 94d6ac174dde8..f59a487b079d5 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
[ ... ]
> @@ -1577,6 +1580,7 @@ rds_send_probe(struct rds_conn_path *cp, __be16 spo=
rt,
>  	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
>  	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
>  	rds_message_addref(rm);
> +	rds_conn_get(cp->cp_conn);	/* put in rds_message_put() */

[Severity: High]
Does this code allow a message and connection reference to be permanently
leaked during connection teardown?

In rds_send_queue_rm(), rds_destroy_pending() is checked while holding
cp->cp_lock before queueing a message. However, here in rds_send_probe(), t=
he
message is added to the send queue and the connection reference is taken
without first checking rds_destroy_pending() under the lock.

If a concurrent network namespace teardown or module unload initiates
rds_conn_destroy(), it calls rds_conn_path_quiesce() which purges the
cp_send_queue under cp_lock. This probe message can then be inserted into
the queue right after the purge.

After releasing the lock, rds_send_probe() checks rds_destroy_pending()
outside the lock to decide whether to queue the worker:

	rcu_read_lock();
	if (!rds_destroy_pending(cp->cp_conn))
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 1);
	rcu_read_unlock();

If the teardown race described above occurs, rds_destroy_pending() will
evaluate to true here, and the worker will not be queued.

Since the message was already added to the purged cp_send_queue and the
worker is skipped, is the message left stranded indefinitely? This would
cause the connection reference to never be dropped, leading to an indefinite
hang during transport module unload, as rds_conn_wait_conns_freed() waits
forever for the connection count to reach zero.

>  	rm->m_inc.i_conn =3D cp->cp_conn;
>  	rm->m_inc.i_conn_path =3D cp;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D13
