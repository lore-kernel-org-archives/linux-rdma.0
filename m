Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E5417BEBF;
	Sat,  5 Sep 2026 20:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639511; cv=none; b=rbIdg/DE1IS19GIF0iXBtX+oyTendRKnPyEDYMZn2INkVSOg1DxHAcNKEpdHOswXn9gCDDqKF01KzwiivWRY9/GM4OkEte8+03x74ZRDgS0Q/VrM2i1xWsxF5pjE/RS9z+PEIE/QahbEGTvES0G5hwwWiMTqUwexokMY7VdYgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639511; c=relaxed/simple;
	bh=n9Lnfiwyl5OajeeBie6rM5WJfo7cguusl2JA7MBql/0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i6AeVhHWTTWNEoYm3nUPK8AciSG1wkOoXQ6r1jdWiECSScYqYxVehG6wchbbnEha45QePQykul5XyIcsaE1pOzEyp9ltgNIZ3GJYl80OPyoTbTQIYcNaQ87+2lunYexAH9yRNEUSZxPtJt64NNJWQTeJkv7LHmNDTX0wx0Qj2dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrK3a/0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrK3a/0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A5E1F00A3A;
	Sat,  5 Sep 2026 20:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639510;
	bh=w6ICuuD/feq6WGs/LKNzZKUtoP6az1C2mBnyJRe76jM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HrK3a/0miYYhtk1+9SxIH1W0z/jyXF4z5W9Yt7aeZm3hrPAH11Klz+XPMmMN3jWNv
	 ++dBJhKIs9FFrcg2qKKIsDaOi3pAGtDzU7ckJxt1P+lYSGmCZpaMul6mgjh0EI2gKS
	 gAO2wV700JUBAAzE9118Y9I2nHxrkdQ5ckPwC3aa9Y7kfn1gLuq3l1sCltPn8UMWt4
	 DqNRgEKw5pXLNDzJZVV06JK14aEuVdtwMtSoH/QSKJ9CKN348PbAPFAjj5u/35w4Gj
	 iJwhq9QwAVZnL0gjzV3+X0a7hs0S8VHOo68b00YjjZubI0XqVAlUEJs/JXMBLCOz7q
	 UrfzLedtVPGoA==
Subject: Re: [PATCH net v3] net: mana: Clear RDMA teardown and suspend state
 in mana_rdma_probe()
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sat, 05 Sep 2026 20:18:28 +0000
Message-ID: <178863950861.219967.11031826205252016526@kernel.org>
In-Reply-To: <20260902175153.3410560-1-longli@microsoft.com>
References: <20260902175153.3410560-1-longli@microsoft.com>
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

- [Medium] In mana_rdma_probe()
  (drivers/net/ethernet/microsoft/mana/mana_en.c:4296) the servicing…

--

net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()

mana_rdma_remove() sets gd->rdma_teardown and nothing ever clears it, so
after the first hardware service reset every GDMA_EQE_HWC_SOC_SERVICE event
returns early.  This patch clears gd->is_suspended and re-opens the gate
with smp_store_release() in mana_rdma_probe(), paired with a new
smp_load_acquire() in mana_rdma_service_handle().

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7a1ac853e3ab..d8e847df7a44 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -3983,7 +3983,8 @@ static void mana_rdma_service_handle(struct work_struct *work)
>  	struct device *dev = gd->gdma_context->dev;
>  	int ret;
>  
> -	if (READ_ONCE(gd->rdma_teardown))
> +	/* Pairs with the smp_store_release() in mana_rdma_probe(). */
> +	if (smp_load_acquire(&gd->rdma_teardown))
>  		goto out;
>  
>  	switch (serv_work->event) {

[ ... ]

> @@ -4279,6 +4280,21 @@ int mana_rdma_probe(struct gdma_dev *gd)
>  	if (err)
>  		return err;
>  
> +	/* Clear the state left by a previous mana_rdma_remove() so servicing
> +	 * events are handled again after a reset cycle.
> +	 */
> +	gd->is_suspended = false;
> +
> +	/* Publish is_suspended before re-opening the gate, so the handler
> +	 * cannot observe an open gate with a stale is_suspended.  Pairs
> +	 * with the smp_load_acquire() in mana_rdma_service_handle().  This
> +	 * matters on the reset path, where mana_rdma_remove() closed the
> +	 * gate and drained the workqueue; on the initial probe path the
> +	 * gate was never closed and both flags are already clear.  It does
> +	 * not order gd->adev, which add_adev() publishes below.
> +	 */
> +	smp_store_release(&gd->rdma_teardown, false);
> +
>  	err = add_adev(gd, "rdma");
>  	if (err)
>  		mana_gd_deregister_device(gd);

[Severity: Medium]

Would it be better to open the gate after add_adev() succeeds rather than
before it?

As written, the store that re-enables the handler happens while gd->adev is
still NULL from the remove half of the reset cycle.  The publication happens
later, at the end of add_adev():

drivers/net/ethernet/microsoft/mana/mana_en.c:add_adev() {
	...
	ret = auxiliary_device_add(adev);
	if (ret)
		goto add_fail;

	gd->adev = adev;
	...
}

A GDMA_SERVICE_TYPE_RDMA_SUSPEND handled in that window passes the gate and
then hits the gd->adev test in mana_rdma_service_handle():

	case GDMA_SERVICE_TYPE_RDMA_SUSPEND:
		if (!gd->adev || gd->is_suspended)
			break;

		remove_adev(gd);
		gd->is_suspended = true;
		break;

so the suspend request is discarded, probe finishes with a live aux device
and is_suspended == false, and the matching RESUME is then also swallowed by
the "if (!gd->is_suspended) break;" test.  Is the resulting state (host asked
for a quiesce, RDMA aux device still live) recoverable without another reset?

Is the concurrency here real on the reset path?  From what I can follow, the
probe runs from system_wq while the handler runs on gc->service_wq:

mana_schedule_serv_work()
	schedule_work(&mns_wk->serv_work)   /* system_wq */
	  mana_serv_reset()
	    mana_gd_suspend() -> mana_rdma_remove()
	    mana_gd_resume()  -> mana_gd_setup()
	                      -> mana_probe()
	                      -> mana_rdma_probe()

and mana_gd_resume() calls mana_gd_setup() first, which re-creates
gc->service_wq, re-arms the HWC IRQs, re-creates the HW channel and
re-detects devices so gc->mana_ib.dev_id.type is valid again, all before
mana_rdma_probe() runs.  So an event arriving during probe reaches
mana_hwc_init_event_handler() -> mana_rdma_service_event() ->
queue_work(gc->service_wq) and mana_rdma_service_handle() can execute on
another CPU while mana_rdma_probe() is still in add_adev().  Since the event
timing is driven by the host, is that window reachable in practice?

In the opposite interleaving, the handler reads gd->adev with a plain load
and immediately destroys the object through remove_adev()
(auxiliary_device_delete/uninit, mana_adev_idx_free) while probe is still
finishing.  The new acquire load only orders is_suspended against the
release; the "gd->adev = adev;" store has no release pairing with the
handler's load.  Would publishing gd->adev with release semantics, or moving
the smp_store_release() below a successful add_adev(), cover this too?

There is also the question of what rdma_teardown now is.  Before this patch
it was a write-once teardown flag; with the clear in mana_rdma_probe() it
becomes a gate that mana_rdma_remove() closes on entry:

	WRITE_ONCE(gd->rdma_teardown, true);

	if (gc->service_wq)
		flush_workqueue(gc->service_wq);

and that mana_rdma_probe() re-opens on the way back in.  That is a flag
guarding a code region rather than expressing device state.  Would a mutex
held across mana_rdma_probe(), mana_rdma_remove() and
mana_rdma_service_handle() be a better fit here, since it would also remove
the window the comment documents instead of describing it?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260902175153.3410560-1-longli%40microsoft.com
