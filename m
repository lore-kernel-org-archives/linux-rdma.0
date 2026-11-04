Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801173;
	b=nVCKVli43y4IBHZlpzattUBX06e34Kgyuik1aRbiNCsHdJJcquQugpDgF+OvFbSgB1fQ
	 lOEOlNjxwpthU0+ReiRanDoy2lWXItCrru1eHEW02GrFPfrpO7DR8EIQoRH+it1KzbQaf
	 vNyLr83UPbDzTO73o2lmIh2C8cfKmyIcOCjOzgqub3cfahtQsyxymQFqXjKAiiroRw2DK
	 jn/bMuRCPmy07HDv7E+tCycTJ/7Rk/XTI80zvtFsdvBW/OxGnRwZiyz2iIeF9tr9P59xw
	 s2VZKPb+sCJD0Uc3D2x+ugTzjvLjHlN/VJKsYLevZdVmFbqno/Fzp12XpDWkJ8KhnnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801173;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uH/6JLhT16+uh3bW5gdjq+6yXQL9dmv7OYBFAVG5ong=;
	b=dzDqSkqY3oCP9OrH6dgkgrpiBidRFPEKHv9i9+bsXrvGXDyYlNraoei5u8tFUp6ZX8JC
	 TigcwsG+Ti9UOPH1RJFjPE2OFZVvv6ATNP/a16w9pfwDkE3yH6d8bmVrFoZZ3TmASnabP
	 lfacWOtnap1A7Y2ulmmI8RAVo4baFnjYCZgW7crAG/MAX9pkIiPQrO/YdZGhGOJDXQzP3
	 T17a2ZMWZuHayvSUJs0P60G32630c5F1xDz8rS5ShBBHvRNQCqOQGf9Y5gT4pAu2SJ006
	 fnijdYhXPO/A5pSZB1y5ruMiXHQMxVarIcBYl8pbdZegqTJ18rnVValErF1+m5sTRXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwj21dMA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0478606A31B;
	Wed,  4 Nov 2026 14:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwj21dMA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D1E1F00A02;
	Wed,  4 Nov 2026 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801172;
	bh=uH/6JLhT16+uh3bW5gdjq+6yXQL9dmv7OYBFAVG5ong=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bwj21dMA2bAt5X0SBhxl1ciJ2aZjBzaohvzuvHnnQ2tDGvIHJ/RF53Qp2h1CWpMig
	 EZp6Ph6/MTKHktLMN8c/NiEEFc4LwvljmJJksKjPB/TsLhJ8XXjzNPheYTjO0Ps0Sz
	 esTC2l4gORhcFk1Bby+JEQO7wrkmR5tinkTw9dTsYg/QSiIZRL9UIc7W/qKyB/IP+Q
	 vPodoz+msQIcFomqeSur4lcBoR6t//kfIFcgPUqO6NXH/GGVF3YqhcCyT/ImIjB5Wd
	 m+MkDQuBlrs47seDt7WpsUQjJxGzG7jmVOuEFqYD2/8O3a8qQKlso83Or4z1m0VzM6
	 j5vC5Tl1yoTwg==
Date: Wed, 4 Nov 2026 16:06:08 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Chengyu Liu <lui2012qwq@gmail.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/ipoib: cancel the AH reaper work synchronously
Message-ID: <20261104140608.GF478286@unreal>
References: <20261103170703.1600310-1-lui2012qwq@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103170703.1600310-1-lui2012qwq@gmail.com>

On Wed, Nov 04, 2026 at 01:07:03AM +0800, Chengyu Liu wrote:
> ipoib_stop_ah_reaper() uses cancel_delayed_work(), which cannot stop a
> callback that is already running.  ipoib_reap_ah() re-arms itself after
> an unlocked test_bit(IPOIB_STOP_REAPER) check, so a callback that has
> passed the check but has not re-armed yet still queues the delayed work
> after the "stop":
> 
>   CPU0 (reaper)                     CPU1 (stop/teardown)
>   test_bit(STOP_REAPER) == 0
>                                     set_bit(STOP_REAPER)
>                                     cancel_delayed_work()  (no-op)
>                                     ... destroy_workqueue(priv->wq)
>   queue_delayed_work(priv->wq, ...)  <- delayed work sits on the timer
> 
> destroy_workqueue() cannot see a delayed work that is pending on the
> timer wheel, so the re-armed work fires after the workqueue is
> destroyed and priv is freed: both the queueing onto the dead queue and
> the callback's container_of() on freed memory are use-after-free.
> 
> Use cancel_delayed_work_sync(), which waits for a running callback and
> prevents its re-arm from taking effect.
> 
> The comment above claims ipoib_reap_dead_ahs() "ensures the work is
> really stopped", but it never touches the work item - it only walks the
> dead_ahs list under priv->lock.  The stop guarantee comes from the
> cancel; fix the comment along with it.
> 
> Found by static analysis.  The race was reproduced on a KASAN build
> with a small module exercising this exact guard/cancel/free pattern
> (no Infiniband hardware available); PoC and splat are below.

Please revisit this once you can reproduce the issue with real IPoIB code,
not code that merely resembles it.

Dropped for now.

Thanks

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>
> ---
> 
> Reproducer notes (PoC source below; a module parameter selects the
> shape): mode=3 (cancel_delayed_work + lockless guard race, this bug's shape) produces
> 
>     [    2.05] BUG: KASAN: slab-use-after-free in queue_delayed_work_on+0x27/0x70
>     [    2.05] Workqueue: events pm_td_cb [pm_flush_poc]
> 
> after the teardown frees the container; mode=1
> (cancel_delayed_work_sync, i.e. this fix) stays clean.
> 
> ---------------------------- reproducer: pm_flush_poc.c ----------------------------
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * pm_teardown_poc - mechanism PoC for the drv-teardown-sync C/D variants
>  * (F-026 ipoib / F-028 epf-ntb / F-029 habanalabs).
>  *
>  * Modes (module parameter):
>  *   0  F-029 vuln shape:  flush_delayed_work + lockless guard
>  *   1  control:           cancel_delayed_work_sync (>=6.9 swallows re-arm)
>  *   2  F-028 vuln shape:  cancel_delayed_work (non-sync) + unconditional re-arm
>  *   3  F-026 vuln shape:  cancel_delayed_work (non-sync) + guard check/queue
>  *                         race window (test passes, teardown slips in before
>  *                         the queue_delayed_work)
>  *
>  * Every vuln mode must produce KASAN slab-use-after-free when the orphaned
>  * work fires after kfree; the control mode must stay clean.
>  */
> #include <linux/module.h>
> #include <linux/workqueue.h>
> #include <linux/slab.h>
> #include <linux/delay.h>
> 
> static int mode;
> module_param(mode, int, 0444);
> MODULE_PARM_DESC(mode, "0=flush(F-029) 1=cancel_sync(ctrl) 2=cancel_nosync(F-028) 3=cancel_nosync+guard-race(F-026)");
> 
> struct pm_td_ctx {
> 	bool			fini_pending;
> 	struct delayed_work	work;
> };
> 
> static struct pm_td_ctx *ctx;
> 
> static void pm_td_cb(struct work_struct *w)
> {
> 	struct pm_td_ctx *c = container_of(to_delayed_work(w),
> 					   struct pm_td_ctx, work);
> 
> 	pr_info("PM-POC: cb running, fini_pending=%d\n", c->fini_pending);
> 
> 	switch (mode) {
> 	case 0:		/* F-029: lockless guard then long body then re-arm */
> 		if (c->fini_pending)
> 			return;
> 		msleep(300);
> 		schedule_delayed_work(&c->work, HZ / 10);
> 		pr_info("PM-POC: re-armed (flush shape)\n");
> 		break;
> 	case 2:		/* F-028: unconditional re-arm, cancel must catch running cb */
> 		msleep(300);	/* long body so cancel lands mid-run */
> 		schedule_delayed_work(&c->work, HZ / 10);
> 		pr_info("PM-POC: re-armed (no guard)\n");
> 		break;
> 	case 3:		/* F-026: guard check passes, THEN teardown slips in */
> 		if (c->fini_pending)
> 			return;
> 		/* widen the check->queue race window like ipoib's 724->725 */
> 		msleep(300);
> 		schedule_delayed_work(&c->work, HZ / 10);
> 		pr_info("PM-POC: re-armed past guard (test-queue race)\n");
> 		break;
> 	default:
> 		break;
> 	}
> }
> 
> static int __init pm_poc_init(void)
> {
> 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> 	if (!ctx)
> 		return -ENOMEM;
> 	ctx->fini_pending = false;
> 	INIT_DELAYED_WORK(&ctx->work, pm_td_cb);
> 
> 	pr_info("PM-POC: arming, mode=%d\n", mode);
> 	schedule_delayed_work(&ctx->work, 0);
> 
> 	msleep(50);	/* callback is mid-run now */
> 
> 	/* teardown sequence for the selected variant */
> 	ctx->fini_pending = true;
> 	switch (mode) {
> 	case 1:
> 		cancel_delayed_work_sync(&ctx->work);
> 		break;
> 	case 0:
> 		flush_delayed_work(&ctx->work);
> 		break;
> 	default:
> 		cancel_delayed_work(&ctx->work);	/* non-sync: C variants */
> 		break;
> 	}
> 
> 	pr_info("PM-POC: teardown done, freeing ctx\n");
> 	kfree(ctx);
> 
> 	msleep(600);
> 	pr_info("PM-POC: SURVIVED (no KASAN splat)\n");
> 	return 0;
> }
> 
> static void __exit pm_poc_exit(void) { }
> 
> module_init(pm_poc_init);
> module_exit(pm_poc_exit);
> MODULE_LICENSE("GPL");
> MODULE_DESCRIPTION("drv-teardown-sync C/D variant mechanism PoC (F-026/028/029)");
> 
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 81bbb3f7c1..5ed4f709cb 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -736,11 +736,11 @@ static void ipoib_start_ah_reaper(struct ipoib_dev_priv *priv)
>  static void ipoib_stop_ah_reaper(struct ipoib_dev_priv *priv)
>  {
>  	set_bit(IPOIB_STOP_REAPER, &priv->flags);
> -	cancel_delayed_work(&priv->ah_reap_task);
> +	cancel_delayed_work_sync(&priv->ah_reap_task);
>  	/*
>  	 * After ipoib_stop_ah_reaper() we always go through
> -	 * ipoib_reap_dead_ahs() which ensures the work is really stopped and
> -	 * does a final flush out of the dead_ah's list
> +	 * ipoib_reap_dead_ahs() which does a final flush out of the
> +	 * dead_ah's list
>  	 */
>  }
>  
> -- 
> 2.25.1
> 
