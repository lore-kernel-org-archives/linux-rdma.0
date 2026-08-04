Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3BE33F5B0;
	Tue,  4 Aug 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785862387; cv=none; b=rVvMFc2FGEbA+0uTqGw98Rq9Ks0WNSBZ3od5m2CDywr6/hZBIijLg4W6a3GzbXW76zjGSIccgP8dFsis3lpeJF6whE7Ke74AOveAvg1NuIsAkct6qZcbHraq9S9Muxd5LAyEaH80yU06e4MaCR72V8Dwi+8tJ2lmr8vfT3/y+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785862387; c=relaxed/simple;
	bh=pB+BSnSnZEyhy+yRmo7o/6u7+WrmXh929OT6CeVHcbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8D4emEOBdDyEuY3rfVeNYqJKPPgaNnrRG3B32a5qDo5lTC9ZArgxfp6KoDSMqsBlnIiw/TAcsvFoGU3I2nxAbfFXgxHYGpCZToT2EXU04CkLBHfCXk3SYXiKRXpnOn+NgyOXhzgVus+DyIGRhbbM2QIAQQ2o9xvqGNu7CB6xpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Le/2ZUee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Le/2ZUee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9011F000E9;
	Tue,  4 Aug 2026 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785862360;
	bh=o/gtKQ0kD6LrGnntllLSqUdcRX4l83XDtNYzAVYeH80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le/2ZUeeyUnV7MpPyDPk7DUo80ldShsF6o7PJWJ2mPl/D9rVWbLy2rHdQFTn3RMfF
	 WIrp6DEE+i0ug9YHukrQDx6+w8yhMgLORawMTJm/YGynETSEGLETgqjIKxjOP8EeSP
	 1iPBuRgr194hSYUIfBEe/Vgq2+SHQaM112EfompqhGyKCKxBYiet9wF9a5NhANkIQ9
	 3GFcwtgRNJJpmPIRlMqHadIVcP/34APsdYpy8alFZTuNS71zStHqRTSRjGUi0uzxqU
	 63BTzNOI6duCW6VXWYE8JSI/PWffp8DZ/cNyYB0ABK4TrQb9+YfijbzfozwM8drbSO
	 plCqBmCaWk9rw==
From: Simon Horman <horms@kernel.org>
To: hidayath@linux.ibm.com
Cc: Simon Horman <horms@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	wintera@linux.ibm.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	pasic@linux.ibm.com,
	gbayer@linux.ibm.com,
	andrew+netdev@lunn.ch,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] dibs: fix double free of dmb_clientid_arr
Date: Tue,  4 Aug 2026 17:52:17 +0100
Message-ID: <20260804165217.525335-1-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730075624.114778-1-hidayath@linux.ibm.com>
References: <20260730075624.114778-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260730075624.114778-1-hidayath@linux.ibm.com?part=1
---
--- Patch [1]: [PATCH net] dibs: fix double free of dmb_clientid_arr ---
commit d9da866ee3cff93c660daf037f85b099a2326866
Author: Hidayath Khan <hidayath@linux.ibm.com>

dibs: fix double free of dmb_clientid_arr

This drops the kfree(dibs->dmb_clientid_arr) from the err_reg path of
dibs_lo_dev_probe(), since dibs_dev_add() already frees that buffer on
both of its own failure paths without clearing the pointer.

Two questions below, one about the commit message tags and one about the
lifetime of the same buffer on the removal path.

> dibs: fix double free of dmb_clientid_arr
>
> dibs_dev_add() frees dibs->dmb_clientid_arr on both of its failure
> paths, but does not clear the pointer. dibs_lo_dev_probe() then frees
> the same pointer again in its err_reg path, so a failing device_add()
> or sysfs_create_group() results in a double free.
>
> Drop the kfree() from dibs_lo_dev_probe().
>
> Note: commit cc21191b584c ("dibs: Move data path to dibs layer") moved
> the code to its current location; the race was introduced earlier by
> commit c3a910f2380f ("net/smc: implement DMB-merged operations of
> loopback-ism").
>
> Fixes: c3a910f2380f ("net/smc: implement DMB-merged operations of loopback-ism")
> Cc: stable@vger.kernel.org

[Severity: Medium]
[Finding: main-1-0]
[Sources: opus-5]
Is c3a910f2380f the right commit to blame here?

That commit only touches net/smc/smc_loopback.c and net/smc/smc_loopback.h,
adding DMB refcounting plus attach/detach/nocopy support. It creates no
client-id array, and it adds no kfree() on any probe error path. At
c3a910f2380f^ the only matching array in the tree is ISM's private
sba_client_arr in drivers/s390/net/ism_drv.c and include/linux/ism.h.

Blame instead points both halves of the double free at cc21191b584c
("dibs: Move data path to dibs layer"): the allocation and the free in
dibs_dev_add(),

	dibs->dmb_clientid_arr = kzalloc(max_dmbs, GFP_KERNEL);
	...
	free_client_arr:
		kfree(dibs->dmb_clientid_arr);

and the duplicate kfree() in dibs_lo_dev_probe()'s err_reg path that this
patch removes. Would it be more accurate to say cc21191b584c introduced the
problem, rather than that it "moved the code to its current location; the
race was introduced earlier"?

With Cc: stable@vger.kernel.org present, a Fixes tag naming a v6.10-era
net/smc commit points backports at trees where neither drivers/dibs/ nor
dmb_clientid_arr exists, so the patch cannot apply there.

Also, the note calls this a "race", but the double free happens
unconditionally on a deterministic error path when device_add() or
sysfs_create_group() fails. Would "double free" be the better wording?

> diff --git a/drivers/dibs/dibs_loopback.c b/drivers/dibs/dibs_loopback.c
> index fd5caf1e19a8f..649e4e375be33 100644
> --- a/drivers/dibs/dibs_loopback.c
> +++ b/drivers/dibs/dibs_loopback.c
> @@ -335,7 +335,6 @@ static int dibs_lo_dev_probe(void)
>  	return 0;
>  
>  err_reg:
> -	kfree(dibs->dmb_clientid_arr);
>  	/* pairs with dibs_dev_alloc() */
>  	put_device(&dibs->dev);
>  	kfree(ldev);

[Severity: High]
[Finding: main-5-4]
[Sources: opus-5]
This isn't a bug introduced by this patch, but while looking at the
lifetime of dmb_clientid_arr: does the removal path have the same missing
NULL assignment, and can the ISM interrupt handler read the buffer after it
is freed?

dibs_dev_del() in drivers/dibs/dibs_main.c ends with the free outside
dibs->lock and leaves the pointer set:

	device_del(&dibs->dev);
	kfree(dibs->dmb_clientid_arr);

The spin_lock_irqsave(&dibs->lock) section earlier in that function only
clears dibs->subs[], and is released well before the kfree().

ism_remove() in drivers/s390/net/ism_drv.c then runs:

	dibs_dev_del(dibs);
	ism_dev_exit(ism);

and ism_dev_exit() is the only place that calls unregister_sba() and
free_irq(pci_irq_vector(pdev, 0), ism). So the SBA stays registered and the
MSI handler stays armed across the kfree(). ism_handle_irq() does, for every
set DMB bit while holding dibs->lock:

	client_id = dibs->dmb_clientid_arr[bit];
	if (unlikely(client_id == NO_DIBS_CLIENT ||
		     !dibs->subs[client_id]))
		continue;
	dibs->subs[client_id]->ops->handle_irq(dibs, ...);

Since the free does not take dibs->lock, can the handler be mid-loop while
the removal path frees the array underneath it?

There is a second effect if the byte read back is garbage: only
NO_DIBS_CLIENT is rejected, while subs[] has MAX_DIBS_CLIENTS == 8 entries
and is the last member of struct dibs_dev in include/linux/dibs.h. Can a
client_id in 8..254 read past the end of the kmalloc'ed struct dibs_dev and,
if that slot is non-NULL, produce an indirect call through a bogus struct
dibs_client pointer?

For the window to be reachable a DMB bit must still be settable by the peer.
ism_unregister_dmb() writes NO_DIBS_CLIENT and then issues the hardware
unregister command, but:

	ret = ism_cmd(ism, &cmd);
	if (ret && ret != ISM_ERROR)
		goto out;

leaves the DMB registered in the adapter when the command fails, so a remote
peer can keep signalling it.

Would it make sense to free and NULL dmb_clientid_arr only after the owning
driver has quiesced its interrupt and data path, do it under dibs->lock, and
bound-check client_id against MAX_DIBS_CLIENTS in ism_handle_irq()? The
missing NULL assignment in dibs_dev_add() is also what turned the removed
kfree() into a double free.
