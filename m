Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395596;
	b=TV6D+ZoH52pc5LaSVAdegSd+y7ObMZM2ZPntKRwG17kZ2ZkdeQQZHi7bxYJSoIX8VMXx
	 FX45JAJa7u3y2LuyPbSRJeoOmTg+VEb5arbdmLIiBmRxkbImNtdOdZRTjwQsKwTHjO5Wg
	 upceMZrHFDjWJHHGuX9R5tUqDefTdeQB9x4a8R8Ylb4S2RqAUxZJDQbk9ePpdyP/ysvjR
	 7EEhECUA5plaU+M8Prygj6tkWPrEViyC/gEZMfMpchqi0718VkJIqKNTB4saE04EOfZXx
	 jtwL522rfIiaNdj5OAiUgqvBJMeP7wPucU/BeIkhXSAb+s/xOygskgQaKIc1c3SCZwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395596;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lHqNLcUeT8ubscwZpiu2BId50GK5hJWk9RBW9/d5aIc=;
	b=KeYnL7j+FwKQl/3XfqYe65Yzb7OUyPk7shsBntYd+zCRCd6Rgw84BDCSrpZ8nJ6NuLim
	 /MU5AZ5wZVjeGOqvfWjtka4xj+RGMJV6RKHxd8Fs4wVtBSXNfHSJEzH1AjH7CsNQxAMEk
	 wo1D7rg0HgguZE/rvCnhZF2154m1a5gjPLmAVmVjnO7bbWNMy+VUcGql9YR5V9/tZ7afc
	 r5w3EH/vDpoGXQSaR/waPZx6ChqRY+bv/9rtttoYbhtp+boxzDhpL3Kwoe6Ge3qK3SrSt
	 rVm67qFel+FnlZGiv8a67c2VVSd+Ya7ma40DVYCiDgiLpBvbeStZtM518PEN8Mg7HOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SamLrRB9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98739606A336;
	Mon, 23 Nov 2026 00:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SamLrRB9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFC51F000C4;
	Mon, 23 Nov 2026 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395596;
	bh=lHqNLcUeT8ubscwZpiu2BId50GK5hJWk9RBW9/d5aIc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SamLrRB96am9a8XSeloC/qxnH0IUqKS3M/viAXV35RSkvw+R0fagvNjA7F5dp3PsP
	 ky2oJWC6PQUxGWXAUs2vbWMFT4hg4BljRlB6SYBZCS6ldpamKTWeCiniQDgiOF1NIh
	 owROd7ydE0hvyDCoRXTraN53ulNn3gq0s4KKSDfyYfKEirhwl9QoxRoaAcIu6KG/d6
	 4x12qbDnPPvFCeNqSW6M/gTJSL/pL762gM7rONL0xiKBNT4rJFqOUF0DEJNH+5pIjS
	 Hzrb9ua4qTExjuAG+VMQBptWrWNMqaPTR+YXhk39gxUY92JBMgtMlaQOon9v2HvtjX
	 A3byRQzpAOm4A==
Subject: Re: [PATCH net-next v3 2/3] RDMA/ionic: Use the ionic command timeout
 for the admin queue
From: netdev-bot+sashiko@kernel.org
To: nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca, leon@kernel.org,
 jiri@resnulli.us, horms@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, eric.joyner@amd.com,
 ArunKumar.Prakash@amd.com
Date: Mon, 23 Nov 2026 00:59:54 +0000
Message-ID: <179539559480.3135.11592624744457325166@kernel.org>
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-2-2cdb8fca15fd@amd.com>
References: <20261119-b4-ionic-cmd-timeout-v3-2-2cdb8fca15fd@amd.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete: a firmware command that takes 2-5 s,
  which the commit message says is within contract, can still reset the…
- [Low] The commit fixes a user-visible bug but has no Fixes: tag.

--

RDMA/ionic: Use the ionic command timeout for the admin queue

This commit changes the RDMA admin queue watchdog timeout from a fixed
2 seconds to HZ * ionic_cmd_timeout(), which is 5 seconds by default.
The goal is that firmware latency within the ionic command timeout no
longer resets the RDMA LIF. The AH create/destroy busy-wait keeps its
fixed 2 second bound.

> diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
> index 0ccd869ad8e6a..b463ad8b4e804 100644
> --- a/drivers/infiniband/hw/ionic/ionic_admin.c
> +++ b/drivers/infiniband/hw/ionic/ionic_admin.c
> @@ -18,8 +18,6 @@
>  #define IONIC_ADMIN_BUSY_RETRY_COUNT	2000
>  #define IONIC_ADMIN_BUSY_RETRY_MS	1
>  
> -/* admin queue will be considered failed if a command takes longer */
> -#define IONIC_ADMIN_TIMEOUT	(HZ * 2)

[Severity: Low]
Should this have a Fixes: tag? The 2 second IONIC_ADMIN_TIMEOUT removed
here was added by:

Fixes: f3bdbd42702c ("RDMA/ionic: Create device queues to support admin operations")

The commit referenced in the message, ec8ee714736e ("ionic: stretch
heartbeat detection"), has a Fixes: tag for the same firmware latency
reasoning. Without a tag here, stable kernels that ship the ionic RDMA
driver won't pick this up.

A backport would also need the earlier "ionic: make the command timeout
per device" commit, because that commit adds ionic_cmd_timeout().

>  #define IONIC_ADMIN_WARN	(HZ / 8)

[ ... ]

> @@ -294,7 +297,7 @@ static void ionic_admin_dwork(struct work_struct *ws)
>  		}
>  
>  		if (time_is_after_eq_jiffies(aq->stamp +
> -					     IONIC_ADMIN_TIMEOUT)) {
> +					     ionic_admin_timeout(dev))) {

[Severity: High]
Can a firmware command that takes between 2 and 5 seconds still reset
the RDMA LIF through ionic_admin_busy_wait()?

The watchdog now waits HZ * ionic_cmd_timeout(). The busy-wait still
gives up after 2000 x mdelay(1), and then it always escalates:

drivers/infiniband/hw/ionic/ionic_admin.c:ionic_admin_busy_wait() {
	for (try_i = 0; try_i < IONIC_ADMIN_BUSY_RETRY_COUNT; ++try_i) {
		...
		mdelay(IONIC_ADMIN_BUSY_RETRY_MS);
		...
	}

	/*
	 * we timed out. Initiate RDMA LIF reset and indicate
	 * error to caller.
	 */
	ionic_admin_timedout(aq);
	return -ETIMEDOUT;
}

ionic_admin_timedout() queues dev->reset_work. ionic_reset_work() then
calls ionic_kill_rdma_admin(dev, true), and after that every verb fails
with -ENODEV. That looks like the same failure this commit is meant to
fix.

Every non-sleepable AH operation goes through the busy-wait.
ionic_create_ah_cmd() and ionic_destroy_ah_cmd() set
IONIC_ADMIN_F_BUSYWAIT when RDMA_CREATE_AH_SLEEPABLE is not set. ib_cm
reaches this path for every CM MAD:

cm_alloc_msg()
  rdma_create_ah(mad_agent->qp->pd, &cm_id_priv->av.ah_attr, 0)
    ionic_create_ah_cmd()
      ionic_admin_wait()
        ionic_admin_busy_wait()

IPoIB and sa_query also destroy AHs with flags 0.

The slow command doesn't have to be the AH command itself.
ionic_admin_post() picks the AQ with raw_smp_processor_id() % aq_count.
ionic_admin_poll_locked() only accepts completions in ring order
(cqe->admin.cmd_idx must equal aq->q.cons).

Say an AH busy-wait is queued behind a create or modify QP that firmware
takes 3 seconds to finish. The watchdog now allows that latency, but
the busy-wait would still time out at 2 seconds and reset the whole
RDMA LIF.

The commit message says the busy-wait keeps its 2 second bound. It
doesn't say that the busy-wait can still reset the LIF, or that a slow
command ahead of it on the same AQ can trigger that reset.

The later commit "ionic: add devlink param for command timeout" allows
cmd_timeout values up to 255 seconds and doesn't touch
drivers/infiniband. By the end of the series, the gap between the two
deadlines is even larger.

Would it work for the busy-wait to cancel the wr and return -ETIMEDOUT
without a LIF reset when it gives up before cmd_timeout, and leave the
reset to the watchdog? The 2 second spin bound in atomic context could
stay as it is.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd%40amd.com
