Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15D4388391
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271442; cv=none; b=uwzHxgLY4K3rh4pwsTUzdsFwJ0eLWqjPqRJM8Syf5AiNdAo+3YPXvGBinpuWWacA8zNR6bQquRX0q8k5BpBzlkvK+cTa5e1se8sBlpYvV4VqpacU3BNBFxdhp+sjORAMDpwxmOXhEDSJPaNv7FaK0rV63nvZw/ZlEMy/N3O+jp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271442; c=relaxed/simple;
	bh=YlXCPi7EXTFOTZrqVfhqmH7OUsdhK4oud/NV0/QMHWk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P+VNIWsKGE9Sb6dtxqx7wm6kL/nUFWWqxfVerOQ8vId/DKheuUHv3zoIBIB6V62ac8I+YpGG13kEoCkERCFhYZ+heh6+bNHpfOUQ4Yhbs2Atk83XGoTyqtb4zOmeqaOtoscd/UzPsJy7S06EIQwtNdPNyfi7n5ey7TF6v3g5TR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoX0vKEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoX0vKEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CEE1F00893;
	Sun, 13 Sep 2026 03:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271441;
	bh=DmbQN0kpp9agHw2rfEx2+ZzHyExkExlxC/D+i5kSDzU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PoX0vKEVEf/3WAiDdBLGDFU8xYZPoAvQhRx+qR0LorIg02r10wlaC8WSUHQPd5h81
	 v0jWvuiEnws7nwCX0Sjwq9s3WNF+GOhfozp7NhxbiE7VTV3153+4K/Gy2KRYOCo40c
	 vjscjJYPp8WTp6kXI3bZkybIDRrL+bKW25RVyFRI24EFoc1tRjmTGgpq0AKlWP9wC+
	 KLy4mhR+EWDQQSZPdbJ3cOMjsWxjt6cFq9+qtN1WqfChElAkMfxjALOvdg73OYK8S3
	 ybyF7AlYbl7l1Xus9kEngXoa34HHnHFgC95KHGpHaLuCErDyZtkS/Gzw72B5FI6I5v
	 Xd72bgsLsePuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 4/9] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-5-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:41 +0000
Message-Id: <20260913035041.68CEE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Repeatedly calling `rds_ib_destroy_nodev_conns` as a resweep callb=
ack causes list corruption and an infinite loop because `list_splice` does =
not reinitialize the list head.
--

commit 597676df37a14231916bc15aaa2d2b879b415a67
Author: Sharath Srinivasan <sharath.srinivasan@oracle.com>

net/rds: wait for connections to be freed on transport unload

This patch tracks the number of live connections per transport and adds a
polling wait loop on transport unload to ensure all connections are fully
destroyed before the module exits. It also provides a resweep callback for
transports like IB that detach asynchronously.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
[ ... ]
> @@ -591,7 +596,51 @@ static void rds_conn_destroy_fini(struct kref *kref)
[ ... ]
> +void rds_conn_wait_conns_freed(struct rds_transport *trans,
> +			       void (*resweep)(void))
> +{
> +	unsigned long warn_interval =3D
> +			msecs_to_jiffies(RDS_CONN_FREE_WARN_INTERVAL_MS);
> +	unsigned long warn_at =3D jiffies + warn_interval;
> +
> +	while (!wait_event_timeout(rds_conn_freed_waitq,
> +				   !atomic_read(&trans->t_conn_count),
> +				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
> +		/* A transport whose teardown is asynchronous (IB moves a
> +		 * connection off its device from the shutdown work) gives
> +		 * us a resweep to destroy what has arrived since.
> +		 */
> +		if (resweep)
> +			resweep();
> +		if (time_after_eq(jiffies, warn_at)) {
[ ... ]
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
[ ... ]
> @@ -537,7 +537,24 @@ void rds_ib_exit(void)
[ ... ]
> +	/* rds_ib_dev_shutdown() only dropped the connections still
> +	 * attached to a device; each moves itself to ib_nodev_conns
> +	 * from its shutdown work.  Destroy what is there now and keep
> +	 * sweeping the list while the wait sees connections outstanding,
> +	 * so a late arrival is destroyed rather than waited on forever.
> +	 */
>  	rds_ib_destroy_nodev_conns();
> +	rds_conn_wait_conns_freed(&rds_ib_transport,
> +				  rds_ib_destroy_nodev_conns);

[Severity: High]
Can this lead to list corruption if rds_ib_destroy_nodev_conns() is called
multiple times?

The new polling loop in rds_conn_wait_conns_freed() will repeatedly call the
resweep function if the transport connection count is greater than zero.

Looking at rds_ib_destroy_nodev_conns() in net/rds/ib_rdma.c, it uses
list_splice() without reinitializing the original list:

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
    ...
    spin_lock_irq(&ib_nodev_conns_lock);
    list_splice(&ib_nodev_conns, &tmp_list);
    spin_unlock_irq(&ib_nodev_conns_lock);
    ...
}

Because list_splice() leaves the ib_nodev_conns head pointing to elements
that are then moved to tmp_list and freed, a second call to this function
during the wait loop will evaluate list_empty() as false and execute
__list_splice() with stale pointers.

This can result in a use-after-free write to the prev and next fields of
freed memory.

Could this use list_splice_init() instead so the list head is safely
emptied for subsequent polling iterations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D4
