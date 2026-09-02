Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480584AA407;
	Wed,  2 Sep 2026 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367574; cv=none; b=qj8gxtnUKnYVkMS/XNGvfWEjtaZ2ekgsogumtL/3X9UUt+8iLaIlp3iNsz4fL/a4CXckgS3GlawRK7C447haHLfFBJKB9Ejv5snKxuNohN9MAByYzu8A8zbp8n0gj00g2hwqt2VyiwD5Wq2XoAjdwV0FeGlHIIQXmzNN9/lqsRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367574; c=relaxed/simple;
	bh=zic0TrT16v8VJIkBRRUBGqdxOSQx7/8Ug7AavmbH9mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR8O7qVXqpPamnEBxlpl8BswS5lHfpnpkaMQJ3PqWeCd3U1lM78VmVIEe+F74EiQWoQjU59fnsk2WCNM+rRHTtEZZYLPw80fPeSSwKHsbh8P8BK+7bSA9FxXYZAqZonJorQF8510znNXri4PzwsaI9BWKqRZdE2dsm3GtK3jF+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+rxEDTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+rxEDTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D371F000E9;
	Wed,  2 Sep 2026 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367571;
	bh=+q6EDF1wgOiC60/E1opKcjImp2c2cIOLj39OZi27oXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+rxEDTeZjEZJwYiDoBPhbJhFyp06/8gcaBaG8IMrkn4rqRA85hg5+A6Md+HjPCSM
	 DwLlQkBrkhLVVDLKUQEqsStxNGqWLoenlKeylAgn4/yMnCSF/3KYBxYFBrXPRXdxYL
	 yYI3cG43Szzm6n6yKwVNHdStEUpBe6ws1H8eQizy7avwRfD8f1J63r2558VuScLp3W
	 tfykK9IPUlcMfKOHQZ5y19Hzcw7f5FuP4iYRj+L6K/FwsHcF7sS9mpShB7Nk8r/ahk
	 n/IFiNvmO2I5gmNQUJFDeRHs/WjxvMvaGRZicwbR7UZltAjgismXAJMbnTbt1EBF+u
	 Dx9xCEVNf/ICg==
From: Simon Horman <horms@kernel.org>
To: longli@microsoft.com
Cc: Simon Horman <horms@kernel.org>,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	kys@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	shirazsaleem@microsoft.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
Date: Wed,  2 Sep 2026 17:44:46 +0100
Message-ID: <20260902164445.528471-2-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828001202.2110938-1-longli@microsoft.com>
References: <20260828001202.2110938-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828001202.2110938-1-longli@microsoft.com?part=1
---
net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()

This clears gd->rdma_teardown and gd->is_suspended in mana_rdma_probe() so
that RDMA servicing events are handled again after a hardware service reset
cycle. The gate is re-opened with smp_store_release(), paired with a new
smp_load_acquire() in mana_rdma_service_handle().

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7a1ac853e3abc..56f426da72864 100644
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

> @@ -4279,6 +4280,17 @@ int mana_rdma_probe(struct gdma_dev *gd)
>  	if (err)
>  		return err;
>  
> +	/* Clear the state left by a previous mana_rdma_remove() so servicing
> +	 * events are handled again after a reset cycle.
> +	 */
> +	gd->is_suspended = false;

[Severity: Low]

Does the invariant described in the commit message hold on the initial probe
path?  The commit message says:

    is_suspended is otherwise only touched by mana_rdma_service_handle() on
    the ordered service workqueue, so clear it while rdma_teardown still
    gates that handler

That is true for the reset path, where mana_rdma_remove() set rdma_teardown
and flushed gc->service_wq first.  On mana_gd_probe() -> mana_probe() ->
mana_rdma_probe() the gate was never closed: gc comes from vzalloc(), so both
gd->rdma_teardown and gd->is_suspended are already false, and mana_gd_setup()
has already created gc->service_wq and brought up the HWC and EQs before
mana_rdma_probe() runs.

So on that path the smp_store_release() is a false -> false store and the
handler's smp_load_acquire() has no state change to order against, while the
plain write of gd->is_suspended here (and add_adev()'s plain write of
gd->adev) can run concurrently with the handler's plain accesses to the same
two fields with no lock on either side.

The outcome looks benign today, since is_suspended is already false and the
handler is a no-op in that window, but would it be worth wording the comment
and commit message so they only claim the property that actually holds?

> +
> +	/* Publish is_suspended before re-opening the gate, so the handler
> +	 * cannot act on a stale value.  Pairs with the smp_load_acquire()
> +	 * in mana_rdma_service_handle().
> +	 */
> +	smp_store_release(&gd->rdma_teardown, false);
> +
>  	err = add_adev(gd, "rdma");
>  	if (err)
>  		mana_gd_deregister_device(gd);

[Severity: Medium]

Is the gate re-opened too early here, i.e. before add_adev() has published
gd->adev?  add_adev() stores it as its last step, after
auxiliary_device_add() has already synchronously probed mana_ib:

drivers/net/ethernet/microsoft/mana/mana_en.c:add_adev() {
	...
	ret = auxiliary_device_add(adev);
	if (ret)
		goto add_fail;

	gd->adev = adev;
	...
}

A GDMA_SERVICE_TYPE_RDMA_SUSPEND work item that runs inside that window
passes the acquire load, but sees gd->adev == NULL because remove_adev()
cleared it during the preceding mana_rdma_remove():

mana_rdma_service_handle() {
	case GDMA_SERVICE_TYPE_RDMA_SUSPEND:
		if (!gd->adev || gd->is_suspended)
			break;

		remove_adev(gd);
		gd->is_suspended = true;
		break;

so the suspend event is consumed without setting gd->is_suspended, and the
matching GDMA_SERVICE_TYPE_RDMA_RESUME then also breaks on
!gd->is_suspended.  Doesn't that leave the freshly created RDMA auxiliary
device live across a servicing operation that explicitly asked for it to be
quiesced, which is the same silently-dropped-servicing behaviour this change
sets out to fix, now confined to the probe window?

Can the two contexts really overlap?  mana_serv_reset() runs on the system
workqueue via mana_schedule_serv_work()/schedule_work() (or from
mana_recovery_delayed_func()) and calls mana_gd_suspend() ->
mana_rdma_remove() then mana_gd_resume() -> mana_gd_setup() ->
mana_rdma_probe(), while the handler runs on gc->service_wq, which
mana_gd_setup() re-creates before mana_rdma_probe() is called:

mana_rdma_service_event() {
	...
	INIT_WORK(&serv_work->work, mana_rdma_service_handle);
	queue_work(gc->service_wq, &serv_work->work);

Different workqueues, and GC_IN_SERVICE only serializes further reset
requests.

Related to the new comment: the handler's read of gd->adev is a plain read
racing with add_adev()'s plain write, so "the handler cannot act on a stale
value" holds for is_suspended but not for gd->adev.

mana_rdma_remove() uses the opposite ordering, closing the gate and draining
the workqueue before touching gd->adev:

mana_rdma_remove() {
	WRITE_ONCE(gd->rdma_teardown, true);

	if (gc->service_wq)
		flush_workqueue(gc->service_wq);

	if (gd->adev)
		remove_adev(gd);

Would doing the mirror image in probe work here, i.e. keeping the
gd->is_suspended = false store where it is but issuing
smp_store_release(&gd->rdma_teardown, false) only after add_adev() has
succeeded?  Note that ordering alone still drops such an event, just via the
gate instead; serializing mana_rdma_probe(), mana_rdma_remove() and the
handler body with a mutex rather than extending the bool gate would close the
window entirely.
