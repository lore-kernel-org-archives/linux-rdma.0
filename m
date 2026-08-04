Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E6484239;
	Tue,  4 Aug 2026 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785862951; cv=none; b=KSzYkJ77QIT6G/kK00wICgsP2JIocZKdWtGXXizcBqZLEeX/1AX2SrBPsYoQIe1pvKtvG3Drm+EIEBHGSfCkOLwpBxoGazWyyE5xiHULkFSc8Gjvb/Dd7UoKIwoe167lt5u9qAUeRKVBQWrRbWbTuhz77uaA2leojcwcJs+MnGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785862951; c=relaxed/simple;
	bh=kPUCeIB2RJhyarauEbgq4Nr5biCLiwT4sXhQFwqG5CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r68F4kJZ7xGYi5MpqE+2EzBb6k9NF5MDF4Pi9cUmchtJ3mhSw9kelZXESpSwbgQ0lW6RHWyxD+yWlKCe7cCEVjbNlf3tKPPFZvZ+ok3ZcTCL6mZ1ISyRvOdj8/r+GNQzK9eFFpZyVAHQSKVPWuDbyJfn0swjGL6nDpMX0VLueow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5tYTaeg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5tYTaeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085F71F000E9;
	Tue,  4 Aug 2026 17:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785862935;
	bh=etCVaetWE8gtiCKDaU0Grtt/SITut8tqHIOF7rRaem4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5tYTaegfXczgD3LSeCTxDmIglIK1O7T69cGUcwSv33g/HrePwqC9UK0/kaHtBpa2
	 MWJjx18NE9T0Phs0QTC06P5opUFNWtuLrrJ7Xkkkro5NkOY78q8YiPgdtOj993sXtN
	 P58hQ+fasv/XhuTKyQRKciqwCbYW1fU4q79949ISrLu69/nvZaOhss/0DcOSqUJB+y
	 eGMLsCT27rLJLh1axEiy806WSbu06/txoskuSkzxaEvrFX3hRLIW23Yg38+Tc1VND6
	 mHcaegiKu4fj6GJR2WnCRvR8VG8DUlKFvNaNCXPiKYQ5w3a/NHp6VpqRJeo8okRUpV
	 965I6T4sPCOcA==
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
Subject: Re: [PATCH net] dibs: initialise dibs->lock in dibs_dev_alloc()
Date: Tue,  4 Aug 2026 18:02:06 +0100
Message-ID: <20260804170206.526356-1-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730124227.167829-1-hidayath@linux.ibm.com>
References: <20260730124227.167829-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260730124227.167829-1-hidayath@linux.ibm.com?part=1
---
--- Patch [1]: [PATCH net] dibs: initialise dibs->lock in dibs_dev_alloc() ---
commit d5daf0b54be512c77adffebc7ed60dee0c5e8e74
Author: Hidayath Khan <hidayath@linux.ibm.com>

dibs: initialise dibs->lock in dibs_dev_alloc()

This moves spin_lock_init(&dibs->lock) from dibs_dev_add() into
dibs_dev_alloc(), so the lock is valid as soon as a driver can hand the
device to its interrupt handler, and updates the dibs_dev_alloc()
kerneldoc accordingly.

While looking at the surrounding lifetime rules for struct dibs_dev, two
questions came up about pre-existing behaviour in the same area.

> diff --git a/drivers/dibs/dibs_main.c b/drivers/dibs/dibs_main.c
> index 14c3e2d84902e..4c26fd06973f7 100644
> --- a/drivers/dibs/dibs_main.c
> +++ b/drivers/dibs/dibs_main.c
> @@ -138,6 +138,7 @@ struct dibs_dev *dibs_dev_alloc(void)
>  	dibs = kzalloc_obj(*dibs);
>  	if (!dibs)
>  		return dibs;
> +	spin_lock_init(&dibs->lock);
>  	dibs->dev.release = dibs_dev_release;
>  	dibs->dev.class = &dibs_class;
>  	device_initialize(&dibs->dev);

[Severity: High]
[Finding: main-3-1]
[Sources: opus-5]
This isn't a bug introduced by this patch, but since the commit message
argues about ism_handle_irq() running before dibs_dev_add(), does the
mirror-image window at teardown need the same attention?

ism_remove() tears things down in this order:

drivers/s390/net/ism_drv.c:ism_remove() {
	...
	dibs_dev_del(dibs);
	ism_dev_exit(ism);
	/* pairs with dibs_dev_alloc() */
	put_device(&dibs->dev);
}

and ism_dev_exit() only disarms the interrupt as its last step:

drivers/s390/net/ism_drv.c:ism_dev_exit() {
	...
	unregister_ieq(ism);
	unregister_sba(ism);
	free_irq(pci_irq_vector(pdev, 0), ism);
}

unregister_sba() frees the SBA and sets ism->sba = NULL, but the handler
writes through it unconditionally on entry:

drivers/s390/net/ism_drv.c:ism_handle_irq() {
	spin_lock(&dibs->lock);
	ism->sba->s = 0;
	...
}

Likewise unregister_ieq() frees the IEQ buffer and NULLs ism->ieq, while
ism_handle_event() dereferences it in the loop condition:

	while ((ism->ieq_idx + 1) != READ_ONCE(ism->ieq->header.idx)) {

Is there anything that serializes ism_handle_irq() against those frees?
dibs->lock is the only lock the handler takes, and unregister_ieq() /
unregister_sba() never take it, so an MSI serviced on another CPU during
ism_remove() looks like it can write to a freed/NULL sba and read a freed
ieq in hardirq context. Would calling free_irq() (or synchronize_irq())
before releasing the structures the handler consumes close this?

The same ordering shows up on the probe error path: dibs_dev_add() failure
frees dmb_clientid_arr and returns to ism_probe(), which only reaches
ism_dev_exit() (and thus free_irq()) afterwards.

> @@ -186,7 +187,6 @@ int dibs_dev_add(struct dibs_dev *dibs)
>  	int i, ret;
>  
>  	max_dmbs = dibs->ops->max_dmbs();
> -	spin_lock_init(&dibs->lock);
>  	dibs->dmb_clientid_arr = kzalloc(max_dmbs, GFP_KERNEL);
>  	if (!dibs->dmb_clientid_arr)
>  		return -ENOMEM;

[Severity: High]
[Finding: main-3-0]
[Sources: opus-5]
This is a pre-existing issue and not something this patch changes, but
while the ownership rules of dibs_dev_add() are in view: can
dmb_clientid_arr be freed twice on the loopback probe error path?

dibs_dev_add() frees the array on every failure after the allocation and
leaves the pointer in place:

drivers/dibs/dibs_main.c:dibs_dev_add() {
	...
	ret = device_add(&dibs->dev);
	if (ret)
		goto free_client_arr;
	...
err_device_del:
	device_del(&dibs->dev);
free_client_arr:
	kfree(dibs->dmb_clientid_arr);
	return ret;
}

and dibs_lo_dev_probe() frees it again:

drivers/dibs/dibs_loopback.c:dibs_lo_dev_probe() {
	ret = dibs_dev_add(dibs);
	if (ret)
		goto err_reg;
	...
err_reg:
	kfree(dibs->dmb_clientid_arr);
	/* pairs with dibs_dev_alloc() */
	put_device(&dibs->dev);
	kfree(ldev);
}

The early -ENOMEM return is harmless because the pointer is still NULL,
but a device_add() or sysfs_create_group() failure would reach the same
slab object twice. The two callers also disagree here: ism_probe()'s
err_ism / err_dibs paths do not repeat the kfree(). Would setting
dibs->dmb_clientid_arr = NULL after the kfree() in dibs_dev_add(), or
documenting who owns the array on failure, resolve the mismatch?

Also, dibs_dev_del() ends with kfree(dibs->dmb_clientid_arr) without
clearing the pointer, while ism_handle_irq() reads it for any set DMB bit:

drivers/s390/net/ism_drv.c:ism_handle_irq() {
	...
	client_id = dibs->dmb_clientid_arr[bit];
	if (unlikely(client_id == NO_DIBS_CLIENT ||
		     !dibs->subs[client_id]))
	...
}

Since client_id comes straight from that buffer and is used unchecked as
an index into the 8-entry subs[] array before an indirect call, does a
post-free interrupt here read freed memory and potentially index past the
end of struct dibs_dev?

[ ... ]
