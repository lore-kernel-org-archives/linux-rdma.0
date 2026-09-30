Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6491B293458;
	Wed, 30 Sep 2026 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728735; cv=none; b=mUtl00QBYJfmC2bgCqkTpiKDhZhW2bZwvn0Mrp8KK+l33kwRMw/fz43adbiqLQ1EMT/Fcf/gT4CYITrVg68gMlVBkGEi2O6WRipYRWqo59jkIz7LnAUIY1Lxfl0k/QFPubZ+rLhvHfvcC/qX/ILmm9Z/QCFpaCUGs0pdbZjkT50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728735; c=relaxed/simple;
	bh=QOeaVmFIaBL7oqMH+zKUhKp040UX1CCwuVq/9yJDKbM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CR/+2i/UET7n2nGf17mb+Cn/XeogZ5r38J9CVjVSDRDOghcvzeWV2V89a4gwvDZPI80COdp2OrlO0ww+ILPVBjoijLIuOLKXvNbevjcLgr8jO3HhLgLqBQmbaQcvv++2i+r8Tgvvrtp/iEy/qDcbFsEToO45rOTkFlop5ecU+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5jjgGdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5jjgGdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D711F000FF;
	Wed, 30 Sep 2026 00:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790728733;
	bh=ySMC+3pDeUNfqhFGyV+XZJLe1lbeVK0MZMq/Y1ewzJk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=l5jjgGdl8BF1iPaXt87uyE0IHCygIU2uAcS4o8/jEwSM6P7XKu75TMFLIE1jUspIm
	 LHP1FKeIgn9P1fi0QxSLq+hfdGzo2bPyhm3PNfuFx767mwfEDGalPfv2XwlqK+6fwS
	 mqPjITgEmwQc3Gws2TLxdVfCDFSHBgS0XJ45mPJpNvde9XaVA3F29BvodDoKeS4qNQ
	 9F1V29N82wqRi21DEWhUp9byvlOuV/hGlsnngi16+0unPG1tROHeBVNmhCILU8NVWS
	 k/7bJfcV6jtMxlABe2ii9Er0cOFLEXIcgDgLkVoX0oCrOLyIZyJYS4/VnlRAYnivTd
	 8JDyu+yHnvXSg==
Subject:
 Re: [PATCH net] net/smc: Serialize early link group cleanup with termination
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, ubraun@linux.ibm.com,
 kgraul@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 30 Sep 2026 00:38:52 +0000
Message-ID: <179072873236.434549.5842458403458661428@kernel.org>
In-Reply-To: <20260927063607.3691520-1-nicoyip.dev@gmail.com>
References: <20260927063607.3691520-1-nicoyip.dev@gmail.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch covers only one of the two callers of
  smc_lgr_cleanup_early().
- [Medium] Early cleanup can free the link group while a
  smc_lgr_free_work() callback that has already started is still using…

Pre-existing issues:
- [Low] In __smc_lgr_terminate() (net/smc/smc_core.c:1573-1574), the
  comment says "cancel free_work sync, will terminate when lgr->freeing…

--

net/smc: Serialize early link group cleanup with termination

This commit makes smc_lgr_cleanup_early() check and claim lgr->freeing
under lgr_lock before it calls __smc_lgr_terminate(). This stops early
cleanup from racing with the other teardown paths. It also makes
smc_conn_abort() hold a temporary link group reference across
smc_conn_free() and early cleanup.

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e9f93b3ab435b..97b0a0b510664 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1011,12 +1011,16 @@ static void smc_conn_abort(struct smc_sock *smc, int local_first)
>  	struct smc_link_group *lgr = conn->lgr;
>  	bool lgr_valid = false;
>  
> -	if (smc_conn_lgr_valid(conn))
> +	if (local_first && smc_conn_lgr_valid(conn)) {
>  		lgr_valid = true;
> +		smc_lgr_hold(lgr);
> +	}

[Severity: High]
This adds a reference for the smc_conn_abort() caller, because the new
lgr->freeing check needs the link group to still be allocated. Does the
other caller of smc_lgr_cleanup_early() need the same protection?

net/smc/smc_core.c:smc_conn_create() {
    ...
		write_lock_bh(&lgr->conns_lock);
		rc = smc_lgr_register_conn(conn, true);
		write_unlock_bh(&lgr->conns_lock);
		if (rc) {
			smc_lgr_cleanup_early(lgr);
			goto out;
		}
	}
	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
    ...
}

The hold is only taken after registration succeeds. On the failure path,
smc_lgr_cleanup_early() runs without a reference of its own.

For SMC-R first contact, smc_lgr_register_conn() fails through
smcr_lgr_conn_assign_link() only when the new link is no longer
SMC_LNK_ACTIVATING. As far as I can tell, that happens only when
__smcr_link_clear() resets the link inside a teardown's smc_lgr_free(). That
teardown drops the link's lgr reference and then the initial one. For
example:

smc_smcr_terminate_all(NULL)   /* reboot notifier via smc_lgrs_shutdown() */
    list_splice_init(&smc_lgr_list.list, &lgr_free_list);
    lgr->freeing = 1;
    __smc_lgr_terminate(lgr, false)
        smc_lgr_free()
            smcr_link_clear()->__smcr_link_clear()  /* link UNUSED, lgr put */
            smc_lgr_put(lgr); /* theoretically last lgr_put */
                __smc_lgr_free()->kfree(lgr)

The connecting thread (connect() or the smc_hs_wq listen worker) then sees
registration fail and calls smc_lgr_cleanup_early() on the freed lgr. There,
smc_lgr_list_head() reads lgr->is_smcd and the new check reads
lgr->freeing.

The commit message says:

    The extra reference keeps the group alive until early cleanup has
    checked teardown ownership.

The smc_conn_create() caller has the same lifetime requirement. Is a
use-after-free from early cleanup racing with termination still reachable
through that path? The window is narrow. It looks like it needs a teardown
such as a reboot to run during an SMC-R first-contact handshake.

>  
>  	smc_conn_free(conn);
> -	if (local_first && lgr_valid)
> +	if (lgr_valid) {
>  		smc_lgr_cleanup_early(lgr);
> +		smc_lgr_put(lgr);
> +	}
>  }
>  
>  /* check if there is a rdma device available for this connection. */
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..b166a379753c7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -688,6 +688,11 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
>  
>  	smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
> +	if (lgr->freeing) {
> +		spin_unlock_bh(lgr_lock);
> +		return;
> +	}
> +	lgr->freeing = 1;

[Severity: Medium]
Can early cleanup free the link group while a smc_lgr_free_work() callback
that has already started is still using it?

After freeing is claimed here, __smc_lgr_terminate() only does a
non-synchronous cancel:

net/smc/smc_core.c:__smc_lgr_terminate() {
    ...
	/* cancel free_work sync, will terminate when lgr->freeing is set */
	cancel_delayed_work(&lgr->free_work);
	lgr->terminating = 1;
    ...
}

free_work is queued on system_percpu_wq, not lgr->tx_wq. So
destroy_workqueue(lgr->tx_wq) in smc_lgr_free() does not flush it. The
callback also holds no lgr reference.

Suppose the callback has started but has not yet reached the freeing check:

net/smc/smc_core.c:smc_lgr_free_work() {
    ...
	smc_lgr_list_head(lgr, &lgr_lock);
	spin_lock_bh(lgr_lock);
	if (lgr->freeing) {
    ...
}

Teardown can then run to completion. smc_lgr_free() drops the initial
reference, and the new smc_lgr_put() in smc_conn_abort() drops the last
one. __smc_lgr_free() then frees the lgr and its embedded free_work, and
the callback goes on to dereference freed memory.

The commit message says:

    This also prevents early cleanup from racing with the delayed free
    worker

It looks like the freeing flag only prevents a second teardown while the
object is still allocated. It does not keep the lgr alive for a worker that
lost the race. Is the commit message accurate here?

To trigger this, the SMC_LGR_FREE_DELAY_* timer has to expire during the
creator's abort. That looks like it needs an unusual stall or a jiffies
jump.

[Severity: Low]
This isn't a bug introduced by this patch, but the comment in
__smc_lgr_terminate() quoted above says "cancel free_work sync". The code
calls cancel_delayed_work(), which does not wait for a callback that is
already running.

What protects a pending smc_lgr_free_work() is its own re-check of
lgr->freeing under lgr_lock, not a synchronous cancel. Early cleanup now
reaches this code after claiming freeing. Could the comment be updated to
match the code?

>  	/* do not use this link group for new connections */
>  	if (!list_empty(&lgr->list))
>  		list_del_init(&lgr->list);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927063607.3691520-1-nicoyip.dev%40gmail.com
