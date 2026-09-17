Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F774B486F;
	Thu, 17 Sep 2026 09:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637937; cv=none; b=a09b7wuUQs7lbXNC4wx2F9uNCTY+4iJs4RuY+z8fZW2g38sz3zQi5MxQSYDlY4hYL1nCXJu872W2/JyFeQ8Ua1qkuAGweElw13nuO5WjUILZUvhEIRuqB618L9aGJ3aRVdaUR7hcg3wUXY3y+0NJrbPrbefaC0nbJ0ZU3hwndsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637937; c=relaxed/simple;
	bh=sKDdu8pSCOdHA3Jtn7b1Bo5l8m9aih+z5J1hCPGd53U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gAN0K29SPDfQIueR24fzTSMY2i7YwLHKlQplMI2nAg40mrtk0gyNVkTuecuJdkQgfkgXi3ViZZmAUXMfgVvQ3IFpB2jqeu0z2Hg6ytNcIitFg2LiIEjUAEetEF4Qr439YRBuScs4HlWxyNswsQm011QkV9mgZfOT5NTMxUjMIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0FMocPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0FMocPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632FF1F00893;
	Thu, 17 Sep 2026 09:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637920;
	bh=TOYTSVnUnAD9/sWon/mQg5KH8h1oWZDTJOWGK7VIFjU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e0FMocPCr/j19bRRO/Ul+FP735QmS8c0mYilgNLprnVX/SS7g1t1SgSiIsu2NdKyH
	 JKYYas5rFipPt8+ViwpReV/fuURQ8FsdFfM8AprP9aFZ5ctdsaGuSR4WOYWwxCqsdO
	 0MuTC0nQZmmzt9vJSnvBvmfC4Cu7842hRpbgenFSbqoRPQpbiKXBNqnq036ZODmZii
	 EKrkBmCnj4oLclQcJlqhpYDcnZnGvHiTiW8RcNWOFwZVuWUfTd7BC5WzAssh7zYSlm
	 4EPV960zz5N9T9gtJrSuL+TTeRa7rdPxA+Ebrb1E71m4WhrHF8cc42G9sYp5t2AJ7w
	 RFoFwcxZO6Ctg==
Subject: Re: [PATCH net-next v3 03/13] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:39 +0000
Message-ID: <178963791995.22033.5627133034354921592@kernel.org>
In-Reply-To: <20260914033719.138057-4-achender@kernel.org>
References: <20260914033719.138057-4-achender@kernel.org>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] Incomplete coverage vs. the patch's own claim: the subject
  says "guard every work-requeueing site with rds_destroy_pending()",…

--

net/rds: guard every work-requeueing site with rds_destroy_pending()

This adds the rcu_read_lock() + rds_destroy_pending() guard around five
path-work arming sites: the two cp_send_w re-arms in ib_send.c, the
cp_recv_w re-arm in rds_ib_recv_refill(), the cp_recv_w kick in
rds_tcp_accept_one(), and the cp_conn_w arm in rds_sendmsg().

> net/rds: guard every work-requeueing site with rds_destroy_pending()

[Severity: Medium]
Is "every work-requeueing site" accurate here?  After this patch four
arming sites in net/rds/threads.c still queue path works with no
rcu_read_lock() and no rds_destroy_pending() test.

rds_send_worker():

	switch (ret) {
	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
		break;
	case -ENOMEM:
		rds_stats_inc(s_send_delayed_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 2);
		break;

rds_recv_worker():

	switch (ret) {
	case -EAGAIN:
		rds_stats_inc(s_recv_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 0);
		break;
	case -ENOMEM:
		rds_stats_inc(s_recv_delayed_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 2);
		break;

These four look functionally safe to me, since they are self-requeues
issued from inside the running work item and rds_conn_path_destroy()
disables the work before flushing it:

net/rds/connection.c:rds_conn_path_destroy() {
	/* make sure lingering queued work won't try to ref the conn */
	cancel_delayed_work_sync(&cp->cp_send_w);
	cancel_delayed_work_sync(&cp->cp_recv_w);
	...
}

__cancel_work_sync() grabs the pending bit (deleting any armed
delayed-work timer) and calls work_offqd_disable() before flushing, and
queue_delayed_work_on() then drops the queue attempt via
clear_pending_if_disabled(), so a requeue from the callback that is
being flushed is discarded and the callback cannot run again afterwards.

The following patch in the series also adds a comment on
struct rds_connection::c_destroy_in_prog that states the rule with no
exception:

	 * Set once, by rds_conn_destroy(), before it cancels the path
	 * works; read through rds_destroy_pending().  A site that arms
	 * a path work must test the predicate and queue the work inside
	 * one rcu_read_lock() section: ...

Could either the subject and changelog note the self-requeue exemption
(and the cancel_delayed_work_sync() reason it holds), or the four
threads.c sites be converted too, so the documented invariant and the
code agree?

Also, the changelog argues for the IB sites:

>     The IB completion sites are reachable from soft-irq at any point
>     before the QP is drained, so a completion landing in the window
>     between the cancel and destroy_workqueue() in rds_conn_path_destroy()
>     re-arms a work on a workqueue that is about to be destroyed: with
>     delay 0 the work is queued directly on the freed workqueue, and with
>     delay 1 the timer survives destroy_workqueue() unseen and fires
>     afterwards, queueing from a timer_list that lives in the freed c_path
>     array.

The same delay-2 timer shape appears in the threads.c -ENOMEM cases, so
a reader may conclude those are equally exposed.  Would it help to say
explicitly why the threads.c requeues are not in the same category?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
