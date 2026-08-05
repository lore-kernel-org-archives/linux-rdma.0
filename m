Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27523BBFD2;
	Wed,  5 Aug 2026 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785942659; cv=none; b=GU2ETfo8OsB+QTrvdtlhHwZ6twcJcjbRJqtTmCjS2/PkPPj1rxlmONaNiWJGUtY4LfBQT5lqosKkctWpYgXsNTfmy8YL6/78VxruKXLmKERf8p8y842MY17NSxjYXJVa16Ak6DD0yp/Ajl2MefGcr2iNfZ3YrOXFoEPsm71ZqCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785942659; c=relaxed/simple;
	bh=Dx/t/a6d74/ovyCKyuC7mZ9HUVIRb1okR0V/i/X4cnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsxTljwHBM0y2BUWV4beCQZ+12HrkBZRsRf8dYFYa628BvCuznmq2b3V8lRKxMQAG8EeWoMaoozPP+aBhS9iHaeix1D8zcNLFbOL+57MRg1O1zX5ZGrQgdbKon7/HOhNqHaovlpk2qnsH1EG6cN2kRf4/KnuAQ44fQRF8GbgPOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onU8eCWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onU8eCWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6F1F00A3A;
	Wed,  5 Aug 2026 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785942657;
	bh=2r2CpJZz0a88GOElGck54XFNa4Wif2zWHfs+PoE1+3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=onU8eCWYkDDZ2GMPNrMu0l4QtkXrdnHnVK0ca5PjrT6OPIyvJN3Qa1llu//JSZJnJ
	 zqrwA7BAIMgyUT18xD9aA0aXMjvrQIruu1RQ7GbaSm8MTsg1J8cogKB3IpzUW2J7nY
	 gszxluxeGpzVzDDOd7h3vWX4RwBwMPyE8zOcMVPL9zxVyp69wERbcT6ZKw040taErZ
	 xH+MPEF935kzSYFrQj0VwhrS0+mIAAkZzjEdUAgybWqxW1QRhcBjD4qCWE/taIrEIG
	 /WxTmEaqRw4tqnn+2SgJQsWmCYfKxTWoy06GZe8BLNUkSZaiihVdl8R85sxiItlcQt
	 gXJAH/caIjUVw==
Date: Wed, 5 Aug 2026 16:10:51 +0100
From: Simon Horman <horms@kernel.org>
To: Qi Zhang <marsy12010123@gmail.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ursula Braun <ubraun@linux.vnet.ibm.com>,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: prevent device removal during connection
 setup
Message-ID: <20260805151051.GV51943@horms.kernel.org>
References: <20260804123418.2214979-1-marsy12010123@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804123418.2214979-1-marsy12010123@gmail.com>

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260804123418.2214979-1-marsy12010123@gmail.com?part=1
---
--- Patch [1]: [PATCH net] net/smc: prevent device removal during connection setup ---
commit 4fbebcb75cff20404187c33315169e87737af9b3
Author: Chengfeng Ye <nicoyip.dev@gmail.com>

net/smc: prevent device removal during connection setup

This adds a new init_cnt/init_wait pair to struct smc_ib_device, takes a
"selection reference" in smc_pnet_determine_gid() while
smc_ib_devices.mutex is held, releases it from a new smc_init_info_free()
helper, and makes smc_ib_remove_dev() wait for those references before
terminating links.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index b4208cb186c5e..d2f2d4e2e91c1 100644
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
> +		smc_ibdev_init_put(ini->ib_dev);
> +	if (ini->smcrv2.ib_dev_v2_ref)
> +		smc_ibdev_init_put(ini->smcrv2.ib_dev_v2);
> +	kfree(ini);
> +}
> +

[ ... ]

> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 9bb495707445e..01c9b5c62df76 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -950,6 +950,8 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
>  
>  	smcibdev->ibdev = ibdev;
>  	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
> +	atomic_set(&smcibdev->init_cnt, 0);
> +	init_waitqueue_head(&smcibdev->init_wait);
>  	atomic_set(&smcibdev->lnk_cnt, 0);
>  	init_waitqueue_head(&smcibdev->lnks_deleted);
>  	mutex_init(&smcibdev->mutex);
> @@ -1000,6 +1002,9 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
>  	mutex_unlock(&smc_ib_devices.mutex);
>  	pr_warn_ratelimited("smc: removing ib device %s\n",
>  			    smcibdev->ibdev->name);
> +	if (atomic_read(&smcibdev->init_cnt))
> +		wait_event(smcibdev->init_wait,
> +			   !atomic_read(&smcibdev->init_cnt));

[Severity: High]
[Finding: main-1-0]
[Sources: opus-5]
Can a remote peer stall this wait_event() indefinitely?  It is
uninterruptible and has no timeout, and the reference it waits for is held
across peer-controlled blocking TCP I/O on the clcsock.

On the client side:

net/smc/af_smc.c:__smc_connect() {
	rc = smc_find_proposal_devices(smc, ini);   /* takes init_cnt via
						      smc_pnet_determine_gid() */
	...
	rc = smc_connect_clc(smc, aclc, ini);       /* send proposal,
						      wait for accept */
	...
	smc_init_info_free(ini);                    /* drops init_cnt */
}

smc_connect_clc() -> smc_clc_send_proposal() does a blocking kernel_sendmsg()
on the kernel clcsock whose sk_sndtimeo is MAX_SCHEDULE_TIMEOUT, so a peer
that stops reading holds the sender until TCP gives up.  The receive side is
chunked:

net/smc/smc_clc.c:smc_clc_wait_msg() {
	while (datlen) {
		u8 tmp[SMC_CLC_RECV_BUF_LEN];
		...
		len = sock_recvmsg(smc->clcsock, &msg, krflags);
	}
}

sk_rcvtimeo is re-armed to CLC_WAIT_TIME for every 100 byte chunk, and datlen
comes from the peer, so the total time is peer controlled rather than bounded
by CLC_WAIT_TIME.

The server side holds the same reference even longer: smc_listen_work() takes
it in smc_listen_find_device() under the global smc_server_lgr_pending mutex
and only releases it at out_free, after the CONFIRM smc_clc_wait_msg() and
smc_listen_rdma_finish().

Should something also prod the in-flight setup to give up?  The new wait runs
before smc_smcr_terminate_all(), and smc_ib_remove_dev() does not set
ports_going_away or inject an error, so nothing makes the handshake abort
early.  The existing lnk_cnt wait in smc_smcr_terminate_all() runs after
smcr_link_down_cond_sched() has actively driven the links down, so it is
bounded by local teardown.

As written, ib_unregister_device() (rdma link delete, driver unbind, hot
unplug, module unload) can block long past the hung task timeout.

>  	smc_smcr_terminate_all(smcibdev);
>  	smc_ib_cleanup_per_ibdev(smcibdev);
>  	ib_unregister_event_handler(&smcibdev->event_handler);
> diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
> index ef8ac2b7546df..8e9fd5a200a2b 100644
> --- a/net/smc/smc_ib.h
> +++ b/net/smc/smc_ib.h
> @@ -51,6 +51,8 @@ struct smc_ib_device {				/* ib-device infos for smc */
>  	struct work_struct	port_event_work;
>  	unsigned long		port_event_mask;
>  	DECLARE_BITMAP(ports_going_away, SMC_MAX_PORTS);
> +	atomic_t		init_cnt;	/* number of device selections */
> +	wait_queue_head_t	init_wait;	/* wait for selections to end */
>  	atomic_t		lnk_cnt;	/* number of links on ibdev */
>  	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
>  	struct mutex		mutex;		/* protect dev setup+cleanup */
> @@ -59,6 +61,17 @@ struct smc_ib_device {				/* ib-device infos for smc */
>  	int			ndev_ifidx[SMC_MAX_PORTS]; /* ndev if indexes */
>  };
>  
> +static inline void smc_ibdev_init_get(struct smc_ib_device *smcibdev)
> +{
> +	atomic_inc(&smcibdev->init_cnt);
> +}
> +
> +static inline void smc_ibdev_init_put(struct smc_ib_device *smcibdev)
> +{
> +	if (atomic_dec_and_test(&smcibdev->init_cnt))
> +		wake_up(&smcibdev->init_wait);
> +}

[Severity: High]
[Finding: main-5-5]
[Sources: opus-5]
Is this wake_up() safe?  It touches smcibdev after the last reference on it
has already been dropped.

wait_event() checks its condition before sleeping and again inside
___wait_event() after prepare_to_wait_event(), so the waiter can leave the
wait purely because init_cnt is already zero, without any wakeup:

include/linux/wait.h
	#define wait_event(wq_head, condition)		\
	do {						\
		might_sleep();				\
		if (condition)				\
			break;				\
		__wait_event(wq_head, condition);	\
	} while (0)

So the following interleaving looks possible:

  connection setup                     device removal
  ----------------                     --------------
  smc_init_info_free()
    smc_ibdev_init_put()
      atomic_dec_and_test() == true
  <preempted>
                                       wait_event() sees init_cnt == 0
                                       smc_smcr_terminate_all()
                                       smc_ib_cleanup_per_ibdev()
                                       cancel_work_sync()
                                       kfree(smcibdev)
  wake_up(&smcibdev->init_wait)

The final wake_up() would then take a freed spinlock and walk a freed wait
list.  Would a completion, or a refcount whose release callback performs the
free, close this window?  The existing lnk_cnt/lnks_deleted code has the same
shape, but this patch adds a second independent instance of it.

>  static inline __be32 smc_ib_gid_to_ipv4(u8 gid[SMC_GID_SIZE])
>  {
>  	struct in6_addr *addr6 = (struct in6_addr *)gid;
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index aa6d83af55eda..a8f8876aea563 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -1118,7 +1118,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
>  out_reject:
>  	smc_llc_cli_add_link_reject(qentry);
>  out:
> -	kfree(ini);
> +	smc_init_info_free(ini);
>  	kfree(qentry);
>  	return rc;
>  }

[Severity: Low]
[Finding: main-2-2]
[Sources: opus-5]
This isn't a bug, but the ownership rule for ini->ib_dev and
ini->smcrv2.ib_dev_v2 becomes non-uniform.  Earlier in this same function,
and in smc_llc_srv_add_link(), the fields are filled in with a borrowed
pointer and no smc_ibdev_init_get():

net/smc/smc_llc.c:smc_llc_cli_add_link() {
	if (lgr->smc_version == SMC_V2 && !ini->smcrv2.ib_dev_v2) {
		lgr_new_t = SMC_LGR_ASYMMETRIC_LOCAL;
		ini->smcrv2.ib_dev_v2 = link->smcibdev;
		ini->smcrv2.ib_port_v2 = link->ibport;
	} else if (lgr->smc_version < SMC_V2 && !ini->ib_dev) {
		ini->ib_dev = link->smcibdev;
	...
}

No reference is leaked or over-released, since both assignments are guarded
by the pointer still being NULL and smc_init_info_free() keys purely on the
new flags, and the borrowed device is kept alive by the parent link's
lnk_cnt.  Could a comment next to ib_dev_ref/ib_dev_v2_ref state which
writers own a selection reference, so future callers storing into these
fields know which convention applies?

[ ... ]

> diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
> index 63e286e2dfaa8..7e01e01a522b7 100644
> --- a/net/smc/smc_pnet.c
> +++ b/net/smc/smc_pnet.c
> @@ -980,14 +980,22 @@ static int smc_pnet_determine_gid(struct smc_ib_device *ibdev, int i,
>  	if (!ini->check_smcrv2 &&
>  	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->ib_gid, NULL,
>  				  NULL)) {
> +		if (ini->ib_dev_ref)
> +			smc_ibdev_init_put(ini->ib_dev);
> +		smc_ibdev_init_get(ibdev);
>  		ini->ib_dev = ibdev;
> +		ini->ib_dev_ref = true;
>  		ini->ib_port = i;
>  		return 0;
>  	}

[Severity: High]
[Finding: main-1-1]
[Sources: opus-5]
This isn't a bug introduced by this patch, but the same "publish device
pointer under a list mutex, use it after unlock, device kfree()d by the
removal callback" pattern still exists for SMC-D/ISM, and the commit message
reads as if the class is now covered ("prevent device removal during
connection setup", "Track selected-device users separately from established
links").

The ISM selection is the sibling of the code being fixed here:

net/smc/smc_pnet.c:smc_pnet_find_ism_by_pnetid() {
	mutex_lock(&smcd_dev_list.mutex);
	list_for_each_entry(ismdev, &smcd_dev_list.list, list) {
		if (smc_pnet_match(...) &&
		    !ismdev->going_away && ...) {
			ini->ism_dev[0] = ismdev;
			break;
		}
	}
	mutex_unlock(&smcd_dev_list.mutex);
}

The pointer is dereferenced after the unlock, for example in
smc_clc_send_proposal():

	if (ini->ism_dev[0]) {
		smcd = ini->ism_dev[0];
		copy_to_smcdgid(&smcd_gid, &smcd->dibs->gid);

while removal frees the device with no counter or wait matching the new
init_cnt, and struct smcd_dev has no refcount:

net/smc/smc_ism.c:smcd_unregister_dev() {
	smcd->going_away = 1;
	smc_smcd_terminate_all(smcd);
	mutex_lock(&smcd_dev_list.mutex);
	list_del_init(&smcd->list);
	mutex_unlock(&smcd_dev_list.mutex);
	destroy_workqueue(smcd->event_wq);
	kfree(smcd);
}

going_away is only sampled before the mutex is dropped, so it does not cover
the post-unlock window, which is the same argument the commit message makes
for the RoCE case.  Could the changelog say that only the smc_ib_device half
is addressed, or could the ISM path be handled too?

>  	if (ini->check_smcrv2 &&
>  	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->smcrv2.ib_gid_v2,
>  				  NULL, &ini->smcrv2)) {
> +		if (ini->smcrv2.ib_dev_v2_ref)
> +			smc_ibdev_init_put(ini->smcrv2.ib_dev_v2);
> +		smc_ibdev_init_get(ibdev);
>  		ini->smcrv2.ib_dev_v2 = ibdev;
> +		ini->smcrv2.ib_dev_v2_ref = true;
>  		ini->smcrv2.ib_port_v2 = i;
>  		return 0;
>  	}
