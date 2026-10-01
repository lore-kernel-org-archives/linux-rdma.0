Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A59934752E;
	Thu,  1 Oct 2026 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835369; cv=none; b=Q7WyPUDIsUXUHpvs+MCwZGqc7GOeaKWysA8QZIyA94UFtrMU54lgDC0TQpA+f9bNYgJydK/dssTtBW5cMHkGXRfwhRQjv8U8cnYsEpzNF1tqiSOqvEi1mUrEo2TF5mTGNsXsQBsUD51d0AjBlzxZdEc7mTYO8oT7fCT7zLhPeC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835369; c=relaxed/simple;
	bh=u65kaEztNW7qf+Yx7osoUH0fSCqTv87bnZW/gl65oiw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YfeFABOePcAWx6ZCKoZCU91v/tBuxIlSv2Nb9uHVm8YoZubkivB0Z9zSW512o8WsWyYVNFJUTxdQoEN36CQyr9BsvdSCL0Mi4F20q+u03WSdQsH032fY6LVGzmFcyB4TCP8SgiyxlWd6sJ8G1AlnhwBPeZWsPQPB+qxgRu/7V4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecoktKzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecoktKzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B111F000FF;
	Thu,  1 Oct 2026 06:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835368;
	bh=ug/Hf8nuv1NDSPNn3qMuPgw1C2cXCMo8z5w7KK59mhc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ecoktKzvnMQJpGEPsv/noG4FWirG3v7qa6TtVD16Ak/Xm0nkfywOfakAQ5shzZwuC
	 4wvpSIm9eoOt94hVmcms1lSCJ2SwW6Ln5muVMkoPwmvvgvqvlXbkSfAZnrU208XkJ/
	 AlPvpUqaPCd/Zh+T/JjC+kQ0w1ELUybtVdJKhzwpi4NRAKbiU9qHgEIYT29TdasyJ4
	 pt0O6Usi0oOHPAh4Gb9OhSPQev4ywbcD3Ee0oN6uZWhCs9i+orDpO0IgoLFRZ9JRGz
	 3+ULpqY2ic4YBcF8b/6FVL34NYLrhKSt+bh9+zS+a4mIgDzf0JI0C8N6vzt9ThRxeO
	 3a0HafuTDfKjA==
Subject: Re: [PATCH net-next v7 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:07 +0000
Message-ID: <179083536716.434549.1711044668946975049@kernel.org>
In-Reply-To: <20260927061448.167862-4-achender@kernel.org>
References: <20260927061448.167862-4-achender@kernel.org>
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

- [Low] The commit message says this patch fixes a live race, and it
  carries a Fixes: tag, but none of the five newly guarded sites can…

--

net/rds: guard every work-requeueing site with rds_destroy_pending()

This patch wraps five work-arming sites in the rcu_read_lock() plus
rds_destroy_pending() pattern that the other arming sites already use.
The sites are the IB send completion and credit paths, rds_ib_recv_refill(),
rds_tcp_accept_one() and rds_sendmsg(). The goal is to stop new work
being queued on a path workqueue once rds_conn_destroy() has started
cancelling it.

> The IB completion sites are reachable from soft-irq at any point
> before the QP is drained, so a completion landing in the window
> between the cancel and destroy_workqueue() in rds_conn_path_destroy()
> re-arms a work on a workqueue that is about to be destroyed: with
> delay 0 the work is queued directly on the freed workqueue, and with
> delay 1 the timer survives destroy_workqueue() unseen and fires
> afterwards, queueing from a timer_list that lives in the freed c_path
> array.

[ ... ]

> With the predicate as it stands the guards cover the netns teardown and
> module unload cases; the following patch extends it to the destroy of a
> single connection.
>
> Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize netns/module teardown and rds connection/workq management")

[Severity: Low]
At this commit, can any of the five newly guarded sites actually fire
while rds_conn_destroy() is running?

Here rds_destroy_pending() is still only:

net/rds/rds.h:rds_destroy_pending() {
	return !check_net(rds_conn_net(conn)) ||
	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
}

The teardown paths that reach rds_conn_destroy() seem to keep these
sites out of the window between the cancel and destroy_workqueue() in
rds_conn_path_destroy().

For IB, rds_conn_destroy() is only called from
rds_ib_exit()->rds_ib_destroy_nodev_conns(), and that function only takes
connections from ib_nodev_conns:

- rds_ib_setup_qp() takes the connection off that list with
  rds_ib_add_conn() before it calls rdma_create_qp().
- rds_ib_conn_path_shutdown() puts it back with rds_ib_remove_conn()
  only after disable_work_sync() on i_send_work/i_recv_work and after
  rdma_destroy_qp().

So wouldn't every IB connection that reaches rds_conn_destroy() have no
QP or CQ? That would leave rds_ib_send_cqe_handler(),
rds_ib_send_add_credits() and rds_ib_recv_refill() with nothing to
deliver.

For the TCP accept path, rds_tcp_kill_sock() clears
rtn->rds_tcp_listen_sock and flushes rds_tcp_accept_w in
rds_tcp_listen_stop() before it destroys any connection. After that,
rds_tcp_accept_one() returns early:

	if (!listen_sock) /* module unload or netns delete in progress */
		return -ENETUNREACH;

rds_tcp_exit() also calls unregister_pernet_device() before
rds_tcp_destroy_conns().

For rds_sendmsg(), the sending socket holds a reference on its netns.
rs_transport is also pinned with try_module_get() in
rds_trans_get_preferred(). So the new guard there looks like it always
evaluates to false.

The guards seem to take effect only with the follow-up patch, "net/rds:
make rds_destroy_pending() report a connection's own destroy", which adds
the c_destroy_in_prog term. That patch also says the last stragglers
"were converted by the previous patch".

There is one narrow interleaving where the IB guards could matter at
this commit. A CM handler could fetch rds_ibdev through
rds_ib_get_client_data() before rds_ib_remove_one() clears it. It could
then call rds_ib_add_conn() after the sweep's list_splice() and bring up
a QP while rds_conn_destroy() is running. That path already corrupts the
sweep's on-stack list, and the commit message does not describe it.

Would it be more accurate to describe this as preparation for the next
patch? The Fixes: tag could then be adjusted or dropped, or this patch
could be folded into the one that extends the predicate.

The Fixes: tag also doesn't seem to match the rds_sendmsg() hunk. The
cp_conn_w queue site there came from 9d27a0fb122f, not from
ebeeb1ad9b8a. The IB queue lines were rewritten to use cp_wq by
d327e2e74aedbe.

A stable backport chosen from this tag would do nothing on its own. The
rds_sendmsg() hunk would also lack context in older trees.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
