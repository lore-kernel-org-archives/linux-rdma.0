Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9D64C901B;
	Thu, 27 Aug 2026 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853633; cv=none; b=mQ8AkkicawCcWfT86BQKxiJIy3MLhJTQB5ELRdsGAvLNtVokfBmy20i0IfaXlmqsOllZCnFlk62LsEWjqTpndKe9oqFye5jALOR/VRTVBSG6M8tpzXOXNSKllH67b0h2AlZaDgHqqsaeXS8DS6HPYnCatkFW60RJ5pb6ddCYz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853633; c=relaxed/simple;
	bh=RF9+sPfdS/ZMkivsjCQ9ZEB+oSkbBQi93O/a/c+SYKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPM3wg9tuoethB8n0VtgxU6vfVAQUKbgFnvF+5pcLNusIRohiuK9XQNR9xo6Q9ncwMmjV54ni4q1LLD/xn6AYt11VNEW7CvLPSOaxNHUqlwbB4lL2QV6PT6BwkLgD8FfJIQYL7DwGocYnaVp2wMqAU3/QOHip35Tpkl7IvMCRTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1X/4BJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1X/4BJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA5F1F000E9;
	Thu, 27 Aug 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787853624;
	bh=17+/WLVfRR8qwNCmLtmWH0gUYCkuZEmB63rt6uapm4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1X/4BJf3TSanFwHTDLZz9awrjbLowU5qIiV7p0/dNS3p1PbVtpiVindvSzaUCyUf
	 5sWyTlAqKqPe8SmZCsFIl48Qa+lVa8wXSYX12N31sbSf5aoiL4UzsrsdcFCzHA/EcM
	 9Ybl15P/XB4DcEFikzXd8ocOl/gzH8+QsyLV5TQ8bseS1fEsAIA5yWbAOu6J/18asn
	 Gw6FQQbz7qyFWRTwKecd116wZPaDfxiEiir5TpwWzCNPJrEKHbdqjFp+ISI/56gQEZ
	 iof55IvG+mu56KczLyAqqBeateOaxtkrj2Rfff01oKLyfrjl6jsYYkO4oOTq9XtInE
	 +dtv1re8VLUtg==
From: Jakub Kicinski <kuba@kernel.org>
To: marsy12010123@gmail.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	nicoyip.dev@gmail.com
Subject: Re: [PATCH net v2] net/smc: prevent device removal during connection setup
Date: Thu, 27 Aug 2026 11:00:22 -0700
Message-ID: <20260827180022.3948710-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823071908.93212-1-marsy12010123@gmail.com>
References: <20260823071908.93212-1-marsy12010123@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/smc: prevent device removal during connection setup

This patch adds a refcount to struct smc_ib_device so that an smcibdev
selected during SMC-R connection setup cannot be freed while the
initialization data still points at it. It also adds an init_cnt/init_wait
pair so that ib device removal waits for the interval between revalidating
the selected device and publishing the resulting link group.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 181647982490..d97bc7323106 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -55,6 +55,17 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
>  
>  static void smc_link_down_work(struct work_struct *work);
>  
> +void smc_init_info_free(struct smc_init_info *ini)
> +{
> +	if (!ini)
> +		return;
> +	if (ini->ib_dev_ref)
> +		smc_ibdev_put(ini->ib_dev);
> +	if (ini->smcrv2.ib_dev_v2_ref)
> +		smc_ibdev_put(ini->smcrv2.ib_dev_v2);
> +	kfree(ini);
> +}
> +

[Severity: High]

This isn't a bug introduced by this patch, but since the commit message
mentions the SMC-D case only in passing, can the smcd_dev pointer in
ini->ism_dev[] be used after free in the same way?

smc_pnet_find_ism_by_pnetid() publishes the raw pointer and then drops the
selection lock:

net/smc/smc_pnet.c:smc_pnet_find_ism_by_pnetid() {
	...
			ini->ism_dev[0] = ismdev;
			break;
		}
	}
	mutex_unlock(&smcd_dev_list.mutex);
}

The removal side only waits for already published link groups via lgr_cnt
and then frees the object:

net/smc/smc_ism.c:smcd_unregister_dev() {
	...
	smc_smcd_terminate_all(smcd);
	destroy_workqueue(smcd->event_wq);
	kfree(smcd);
}

A setup that has selected the device but has not created a link group yet
is not counted anywhere, so the borrowed pointer is still dereferenced
afterwards by smc_connect_ism_vlan_setup() and
smc_connect_ism_vlan_cleanup():

	if (ini->vlan_id && smc_ism_get_vlan(ini->ism_dev[0], ini->vlan_id))

and by smc_lgr_create():

		smcd = ini->ism_dev[ini->ism_selected];
		get_device(&smcd->dibs->dev);

smc_ism_get_vlan() takes spin_lock_irqsave(&smcd->lock), so this is a write
into the freed object as well. Since smc_init_info_free() only drops the two
SMC-R references, would it be worth stating in the commit message that
ini->ism_dev[] stays an unowned pointer on purpose?

> @@ -882,6 +900,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
>  	if (!atomic_dec_return(&smcibdev->lnk_cnt))
>  		wake_up(&smcibdev->lnks_deleted);
>  	smc_lgr_put(lgr); /* lgr_hold above */
> +	smc_ibdev_init_end(smcibdev);
>  	return rc;
>  }

[Severity: High]

This is a pre-existing issue, but now that a refcount exists, should it also
cover the lnk_cnt decrement and wakeup above and the identical sequence in
__smcr_link_clear()?

net/smc/smc_core.c:__smcr_link_clear() {
	...
	smcibdev = lnk->smcibdev;
	memset(lnk, 0, sizeof(struct smc_link));
	lnk->state = SMC_LNK_UNUSED;
	if (!atomic_dec_return(&smcibdev->lnk_cnt))
		wake_up(&smcibdev->lnks_deleted);
	...
}

Links take get_device(&lnk->smcibdev->ibdev->dev) but never smc_ibdev_get(),
so nothing pins the smc_ib_device allocation across the decrement and the
wake_up().

The waiter can leave the wait purely by re-evaluating the counter:

net/smc/smc_core.c:smc_smcr_terminate_all() {
	...
		if (atomic_read(&smcibdev->lnk_cnt))
			wait_event(smcibdev->lnks_deleted,
				   !atomic_read(&smcibdev->lnk_cnt));
	...
}

If the clearing task is preempted between atomic_dec_return() returning 0 and
wake_up(), smc_ib_remove_dev() can proceed to smc_ibdev_put() ->
smc_ibdev_release() -> kfree(smcibdev), and the clearing task then takes the
waitqueue spinlock inside freed memory. Would an smc_ibdev_get() in
smcr_link_init() paired with an smc_ibdev_put() after the wakeup close this?

> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 9bb495707445..d858453c64d9 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -1000,11 +1042,14 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
>  	mutex_unlock(&smc_ib_devices.mutex);
>  	pr_warn_ratelimited("smc: removing ib device %s\n",
>  			    smcibdev->ibdev->name);
> +	if (atomic_read(&smcibdev->init_cnt))
> +		wait_event(smcibdev->init_wait,
> +			   !atomic_read(&smcibdev->init_cnt));
>  	smc_smcr_terminate_all(smcibdev);
>  	smc_ib_cleanup_per_ibdev(smcibdev);
>  	ib_unregister_event_handler(&smcibdev->event_handler);
>  	cancel_work_sync(&smcibdev->port_event_work);
> -	kfree(smcibdev);
> +	smc_ibdev_put(smcibdev);
>  }

[Severity: High]

This is a pre-existing behaviour of the termination scan rather than
something the patch introduces, but does the new init_cnt interval really
give the guarantee the commit message claims?

The commit message says:

  "Device removal waits for this interval before terminating links, ensuring
  that it cannot miss a link being created concurrently."

smcr_link_init() returns with the new link in SMC_LNK_ACTIVATING:

	lnk->state = SMC_LNK_ACTIVATING;
	return 0;

and every caller releases init_cnt right away, for example smc_lgr_create():

	if (!ini->is_smcd)
		smc_ibdev_init_end(lnk->smcibdev);

so the interval ends long before smc_llc_link_active() promotes the link to
SMC_LNK_ACTIVE. After the init_cnt wait drains, the single scan in
smc_smcr_terminate_all() reaches smcr_link_down_cond_sched(), which only acts
on an ACTIVE link:

net/smc/smc_core.c:smcr_link_down_cond_sched() {
	if (smc_link_downing(&lnk->state)) {
		...
}

smc_link_downing() is a cmpxchg from SMC_LNK_ACTIVE to SMC_LNK_INACTIVE, so
an ACTIVATING link is skipped and the scan is not repeated. The following

		if (atomic_read(&smcibdev->lnk_cnt))
			wait_event(smcibdev->lnks_deleted,
				   !atomic_read(&smcibdev->lnk_cnt));

then has no timeout, so if the connection completes and stays up,
smc_ib_remove_dev() and therefore ib_unregister_device() block until the link
goes down for an unrelated reason. The ACTIVATING window spans the
peer-controlled CONFIRM_LINK exchange, so a remote peer can widen it. Would
it be more robust to hold init_cnt until the link reaches SMC_LNK_ACTIVE, or
to have the scan also handle ACTIVATING links?
-- 
pw-bot: cr
