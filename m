Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792954167;
	b=jHZUgBtj55nN4BL6RTD0BGfFDyzPDciFLdIm0gFDo4XJ1q/kUtMVIxYvwQXFsooXIUZf
	 rYXPzsIg6//+oj996KBBegscQyb1UWSCH96450GP0ZM232l+ZNyUvtv8N0k5RP6ayv32A
	 xNL5cmzEYAt6Q4An0we5B8rNDMWJStYPpEZo4ybDYI+E+ex7rGSSAmkwnYk9fIOmKjYdP
	 l8TJyeQ7bezI7IAA7WSEX4rV+dd3lQ2YPZGSPVRB1OThLU9maEefyHQ3Qy1FsjOJDwnrT
	 huSi4AHexq/9F2tu3H3kSbjbKlp1tz0pIb2mpxVtUhHmi7CBzGbh3HhYLtZMyZD4jWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792954167;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=M1EYkJThVb8wjj8i/+8/sHy3gmrgSu5C1nsMxL532Tg=;
	b=xdc4M/4h7OEqaQSSOrkWWRf96YJvDSUNXN06V0tBjyC3pLn088OIitSnhQF+YYerWMm0
	 mjYKbd/sBjMy3aZIXwjrl6wTwe2+KbST51BdBEjImoCD6Ie61+L2IYhtsbqf4crYjGUmz
	 ApyssTIXYTojK6J9UmOF7G3tSvqLcX8ZEZzRokBOaERij7RvFoudGAE3hd800KGhxaZ18
	 UMqTB9VYAsSOkdzwMHRM1UNflt2SpgppS4ZWP20MpGbJI4HXS0bWxeNv55dr+GhTrzV3S
	 YbwA7RfiwIZZzQlqMjh7lVA7w+XJZ6LeRKRebxn7xTy8G7hSAJRTgjFQ8NQJuJBNOdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fVj0DRC/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC3606A31B;
	Sun, 25 Oct 2026 18:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVj0DRC/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEAF1F01825;
	Sun, 25 Oct 2026 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792954166;
	bh=M1EYkJThVb8wjj8i/+8/sHy3gmrgSu5C1nsMxL532Tg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fVj0DRC/tzuIgNxzI2lqtpDjW7ewxWgaY2iSl3bJPdmbJBI+sKgVzBJGEp3j/ZPLt
	 WXFo8sREHPRdex9xcZk5K7bM3Er+V8uVOXDmBohouMyq+a/5j5c+rV2NvOvuB/UzLo
	 SKeGMdKlpVWjfcJu2/dhbph0rfDVASrTKp7iYCez+VFdWMw8BSqp54dSfjV+lsFdeN
	 X6y/ffdkEi2LPEtA6RAeJ9cRpJh/HMwi/qX9KqLhUmKuetolDgHtyvooiECVId7AZr
	 BAxtVC670uh6LxkPO8F5LpdyY4nC0slpqJjYh1DL0NLApFsZJNtJxig9obYnkf1AV6
	 XTaZhz8q044Zg==
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
From: netdev-bot+sashiko@kernel.org
To: josef@toxicpanda.com
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 kuba@kernel.org
Date: Sun, 25 Oct 2026 18:49:25 +0000
Message-ID: <179295416566.3134.16050727697220664295@kernel.org>
In-Reply-To:
 <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
References:
 <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new predicate in mlx5e_napi_poll() (en_txrx.c:216-217)
  uses NAPI_STATE_THREADED, which records the configured mode.
- [Low] The opposite transition has a smaller problem.

--

net/mlx5e: Fix stalled channels with threaded NAPI

With this patch, mlx5e_napi_poll() keeps polling when the NAPI is in
threaded mode, instead of taking the affinity-change path. The changelog
says that path completes the NAPI and arms the CQs while CQEs are still
pending, and this can leave a channel stalled after a burst of traffic
ends.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> index 1851056064698..3142e90e68cee 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> @@ -207,7 +207,14 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
>  				rq);
>  
>  	if (busy) {
> -		if (likely(mlx5e_channel_no_affinity_change(c))) {
> +		/* A NAPI thread runs where the scheduler puts it, which says
> +		 * nothing about the affinity of the interrupt. Completing here
> +		 * would leave the CQEs that are pending to the next interrupt,
> +		 * and arming the CQs raises none for those, only for a new
> +		 * completion.
> +		 */
> +		if (likely(mlx5e_channel_no_affinity_change(c)) ||
> +		    test_bit(NAPI_STATE_THREADED, &napi->state)) {

[Severity: Medium]

NAPI_STATE_THREADED records the configured mode. It does not say whether
the current poll is running in the NAPI kthread. Can a kthread poll still
see this bit clear?

When threaded mode is disabled, napi_set_threaded() calls
napi_stop_kthread(). That function clears THREADED while the kthread
still owns the NAPI, and only waits for SCHED_THREADED afterwards:

net/core/dev.c:napi_stop_kthread() {
    ...
		if ((val & NAPIF_STATE_SCHED_THREADED) ||
		    !(val & NAPIF_STATE_SCHED)) {
			new = val & (~(NAPIF_STATE_THREADED |
				       NAPIF_STATE_THREADED_BUSY_POLL));
    ...
	/* Once STATE_THREADED is unset, wait for SCHED_THREADED to be unset by
	 * the kthread.
	 */
	while (true) {
		if (!test_bit(NAPI_STATE_SCHED_THREADED, &napi->state))
			break;

		msleep(20);
	}
    ...
}

During that window, napi_threaded_poll_loop() keeps calling __napi_poll()
as long as repoll is set, and it never looks at THREADED.

Suppose a busy mlx5e poll runs in the kthread on a CPU outside
c->aff_mask, which the changelog describes as the usual case. It would
then fall through to the affinity-change branch:

	ch_stats->aff_change++;
	aff_change = true;
	if (work_done == budget)
		work_done--;

napi_complete_done() then clears SCHED and SCHED_THREADED. The CQs are
armed with CQEs still pending, and no interrupt is forced.

Isn't that the same state the changelog blames for the stall? If traffic
stops right then and the RQ is dry, the channel could stall the same way.

Would NAPI_STATE_SCHED_THREADED be a better test here? It marks that the
kthread owns the current poll.

[Severity: Low]

The opposite transition seems to have a smaller problem. When threaded
mode is enabled, napi_set_threaded() sets THREADED right away, even if
the NAPI is being polled in softirq at that moment:

net/core/dev.c:napi_set_threaded() {
    ...
	/* Setting/unsetting threaded mode on a napi might not immediately
	 * take effect, if the current napi instance is actively being
	 * polled. In this case, the switch between threaded mode and
	 * softirq mode will happen in the next round of napi_schedule().
    ...
		napi_set_threaded_state(napi, threaded);
    ...
}

____napi_schedule() checks THREADED only at schedule time. A NAPI that is
already on a softirq poll_list therefore keeps being repolled by
net_rx_action() with THREADED set.

Suppose the IRQ affinity changes around the same time, so the softirq
poll runs on a CPU outside c->aff_mask. The new test is then true, so
mlx5e_napi_poll() returns budget and the NAPI is repolled on the same
CPU.

That skips the complete-and-arm step. That step would move the poll to
the IRQ's new CPU, and the next schedule would hand the NAPI to the
kthread.

Does NAPI processing then stay on the old CPU, with the switch to
threaded mode put off until the queue goes idle? Testing
NAPI_STATE_SCHED_THREADED instead of NAPI_STATE_THREADED looks like it
would cover this case as well.

>  			work_done = budget;
>  			goto out;
>  		}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4%40toxicpanda.com
