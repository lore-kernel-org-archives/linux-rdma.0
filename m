Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793096169;
	b=1/yn4AAizfA7KjNuj7D2NnYJdZAVuaPhyBVBkgo9Xo0nWK2KylRUO0GX8F7FN/C6z80F
	 G1UXCuc3F/XKeiCzeorX1Qowek03Y1qOF5Tx5xSCu6TqTJo/Y2yRFRo4JWqsOEtxl+5gi
	 8UVyfBCYwArfhWeg6kbzG0b7ztpE66SR5LoM23Nvy73qVGMmKWqkoEZ/DUj9+rXqt47gC
	 +lJInTD8LBF/AC7TrK7Lfm9KqiXQ+1Xlof/ML6hXGiiWB+v3S7MYuqjsH4a/zviQne9rz
	 +sjYmRKoL/VdD8GcC83REuqOwcQ5bw93+L0fAtfe3Gu+VXJwqfg3uWR78als8D1Kt/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096169;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=BkhzKqHk57FsBIcZJDbLzkOn5QW17cXML6NAzTysNJs=;
	b=de+H3kX7h5tUkoPFJVTJidUuNuBKlWghIz8jvXAfbD9qdeJv9x8mAgbW939YYdy4SNGM
	 76k4FZ4D6t6qS6T0gtERbWOpqdJmHlUzR8a2f4KRr2gT9JQmBWjrmQ+mXEO2a4G1WKsNG
	 yfd0ujUEg/Igf79nDZap+eyC8HACzXV5mTuUKFGkXfECZh37HSP0BZHJlkaMr7XQAxsNw
	 +I2hEoqEI1CXoaJFB8lhGhC1OlYusHuiE/LMk+aOTGBy4wNIOHO4c+A1Hlp6XZe6LERqN
	 3KgypEZo3LpOqarvmRCuVnrad6mGhsdVWwanICdKcu7QolEHn9ziYvzqC0ceJgQxJrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rck7OHEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8A6606A31E;
	Tue, 27 Oct 2026 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rck7OHEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2468D1F01825;
	Tue, 27 Oct 2026 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793096167;
	bh=BkhzKqHk57FsBIcZJDbLzkOn5QW17cXML6NAzTysNJs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Rck7OHEG8G6OagRdPHGjL0nDzragotKIxn9I7T5odO8P3SEFIS4ro5D9gHjazdarP
	 8LEvJBPVb8lpK5Lo8+VAQfglcWupzBiS3Z0ke6oB2ZtMpdKCok+cDKyKJtERPVGHGL
	 fvRcNvxgCwgrW798nDREbllmt65oGTCXm1HXquY+xg0y5Au03PGiKyw7UFM2OO1Dgk
	 6bi6/PRH6EXcmL7o1Aw/JIgGJgqyEeZdzQRBAU7ROD2U/oSLBtMwuSeBg7Pe/beHgR
	 VxqBNw8prDeTR0xvK8kLbF14+H17x1eC+9+ZmkgMUSTD0lcxsOWL3xNNSBShuDoev9
	 4/qm9zg4N7VwQ==
Subject:
 Re: [PATCH] net/rds: hold IB device reference through deferred cleanup
From: netdev-bot+sashiko@kernel.org
To: hackerowskiy@gmail.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org,
 syzbot+221e213bf17f17e0d6cd@syzkaller.appspotmail.com
Date: Tue, 27 Oct 2026 10:16:06 +0000
Message-ID: <179309616666.3134.5893578581226620529@kernel.org>
In-Reply-To: <20261023100206.126692-1-hackerowskiy@gmail.com>
References: <20261023100206.126692-1-hackerowskiy@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch takes an ib_device registration reference
  (ib_device_try_get) in rds_ib_add_one() and releases it only in…
- [High] In rds_ib_get_mr() (net/rds/ib_rdma.c), the ODP branch (need_odp
  == ODP_ZEROBASED or ODP_VIRTUAL) takes an rds_ibdev reference through…
- [Low] The patch is presented as a fix for a syzbot-reported use-after-
  free: rds_ib_dev_free() runs on rds_wq after rds_ib_remove_one() has…

--

net/rds: hold IB device reference through deferred cleanup

This patch takes an ib_device registration reference in rds_ib_add_one()
and drops it at the end of rds_ib_dev_free(). The IB device then stays
registered until the deferred cleanup on rds_wq has run. It addresses a
syzbot-reported use-after-free in that deferred cleanup.

Closes: https://syzkaller.appspot.com/bug?extid=221e213bf17f17e0d6cd

> Reported-by: syzbot+221e213bf17f17e0d6cd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=221e213bf17f17e0d6cd
> Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>

[Severity: Low]
This isn't a bug, but should there be a Fixes: tag here?

git blame of rds_ib_dev_free() and rds_ib_dev_put() points the deferred
free design at commit 3e0249f9c05c ("RDS/IB: add refcount tracking to
struct rds_ib_device").

Should this also have a Cc: stable?

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..ca6be8b2c3227 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -115,6 +115,7 @@ static void rds_ib_dev_free(struct work_struct *work)
>  
>  	kfree(rds_ibdev->vector_load);
>  
> +	ib_device_put(rds_ibdev->dev);
>  	kfree(rds_ibdev);
>  }
>  
> @@ -142,6 +143,12 @@ static int rds_ib_add_one(struct ib_device *device)
>  				 ibdev_to_node(device));
>  	if (!rds_ibdev)
>  		return -ENOMEM;
> +	/* Keep the device registered until the deferred cleanup completes. */
> +	if (!ib_device_try_get(device)) {
> +		kfree(rds_ibdev);
> +		return -ENODEV;
> +	}
> +	rds_ibdev->dev = device;

[Severity: High]
Can this make ib_unregister_device() wait on userspace?

The reference taken here is dropped only in rds_ib_dev_free(), which runs
only after rds_ibdev->refcount reaches zero. rds_ib_remove_one() drops
just the client data and device list references:

net/rds/ib.c:rds_ib_remove_one() {
    ...
	synchronize_rcu();
	rds_ib_dev_put(rds_ibdev);
	rds_ib_dev_put(rds_ibdev);
}

Sockets can hold other references. For example, an FRMR MR created
through an RDS_CMSG_RDMA_MAP cmsg holds one:

sendmsg()
  rds_cmsg_rdma_map()
    __rds_rdma_map()
      rds_ib_get_mr()
        rds_ib_get_device()        <- takes an rds_ibdev reference
        rds_ib_reg_frmr()
          ibmr->device = rds_ibdev;

The MR is stored in rs->rs_rdma_keys. Its reference is dropped only in
rds_ib_free_mr(), which runs when userspace issues RDS_FREE_MR or closes
the socket.

Neither rds_ib_remove_one() nor rds_ib_dev_shutdown() revokes these MRs.
Suppose the HCA is unregistered (driver unload, hot-unplug, rxe/siw link
delete) while such a socket is open. disable_device() then does:

drivers/infiniband/core/device.c:disable_device() {
    ...
	/* Pairs with refcount_set in enable_device */
	ib_device_put(device);
	wait_for_completion(&device->unreg_completion);
    ...
}

Wouldn't that wait block uninterruptibly, with unregistration_lock held,
until the user frees the MR or closes the socket?

The comment above add_client_context() and remove_client_context() says
client add and remove must be a fence. Keeping the registration refcount
past .remove() seems to break that rule.

Would it work better to tear down the PD and MR pools synchronously in
rds_ib_remove_one() instead?

The commit message also doesn't mention that unregistration now waits on
RDS reference holders.

[Severity: High]
Does the ODP path in rds_ib_get_mr() turn this into a permanent hang?

In net/rds/ib_rdma.c, the ODP branch takes a reference with
rds_ib_get_device(). It returns without storing that reference in
ibmr->device and without dropping it:

net/rds/ib_rdma.c:rds_ib_get_mr() {
    ...
	rds_ibdev = rds_ib_get_device(rs->rs_bound_addr.s6_addr32[3]);
    ...
	if (need_odp == ODP_ZEROBASED || need_odp == ODP_VIRTUAL) {
    ...
		ibmr = kzalloc_obj(*ibmr);
    ...
		ibmr->u.mr = ib_mr;
		ibmr->odp = 1;
    ...
		return ibmr;
	}
    ...
}

When the MR is freed, rds_ib_free_mr() returns early for ODP MRs, before
it reaches rds_ib_dev_put():

	if (ibmr->odp) {
    ...
		INIT_DELAYED_WORK(&ibmr->work, rds_ib_odp_mr_worker);
		queue_delayed_work(rds_ib_mr_wq, &ibmr->work, 0);
		return;
	}

rds_ib_odp_mr_worker() then only calls ib_dereg_mr() and kfree(ibmr).

Before this patch, that imbalance only leaked the rds_ibdev and the PD.
With this patch, a single ODP MR keeps rds_ibdev->refcount from ever
reaching zero, so the new ib_device_put() in rds_ib_dev_free() never
runs.

Any later unregistration of that HCA would then block forever in the
wait_for_completion() in disable_device(), even after the socket is
closed.

A local user can reach the ODP branch on an ODP-capable HCA such as mlx5.
It is taken when rds_pin_pages() returns -EOPNOTSUPP in __rds_rdma_map()
or rds_cmsg_rdma_args(). One case is an FS-DAX mapping, where
FOLL_LONGTERM pinning is refused.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023100206.126692-1-hackerowskiy%40gmail.com
