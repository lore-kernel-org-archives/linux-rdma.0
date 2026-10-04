Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60B9230BE9;
	Sun,  4 Oct 2026 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131700; cv=none; b=BW2dVpz3Mtr6+gp8z4dgMYo8LXyGHnrpjSXkpT5FA82bL72/oelEbB0J+HU7rsCh/Zrb22AxmCx55gWspptzkx75tberm9lhdtebHtjtdW3l21tAycaGgM1G/HB3/RfYt0XTAIitsL+yGfCya+xeLRDO+pn57pPW/Qm2Sudh0NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131700; c=relaxed/simple;
	bh=zynyWVNabLTuT23r0wxYGi1ppYW/+vS6HAa8uJcfn2U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i+jf3M9cPePBMTBa3ozefQknGuz6MbaY8+00qVZUIEO4ovj8hH7tfnex0RmJTsU4q675W2QnJme3l50oJpwozeE8KhRkFzrwmw1Iset5gTctDojMM7U2OthobLbzXT3603slIqp7KP9n05F+/vlhPNZIhp5OK6R6FIyCmegvXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbALxmU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbALxmU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4521F000FF;
	Sun,  4 Oct 2026 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131699;
	bh=Ab5kT+4tqPApjC4hOOwkF+7Qbykw/cgm4dSPeuK25UI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DbALxmU35sbARYw5UgrRfwyE9HewqgrIZPVc1p19wh02CX+ct8S5W+GRiWrC9esiV
	 m7dQ3aTt2mcs7oObxGZ4xi3PkKSDbvncfDZJAcdJHJ2I0HUTOIjLsGtB1e00Ep65dD
	 pBJJ+bnhW7Dj5vLQero2LV0qbmv1I301zAJzVnnLtnfJAPp8etefsl6y6HrBwy/FHI
	 ukruA1kXf9j2/Hn3Vlr3Hx+YF81eq70zJnBsnFS6h1d0jZ9nxTUwGAK4+Y820mjyM8
	 tYDD76CMAoa+NOQ25S4GtpeK3nY1YnGtVeBjzTUl9cTUxaXNDpAVvZ4kNhql1MDPMG
	 8uHeKTuEDb9IQ==
Subject: Re: [PATCH net-next v8 03/13] net/rds: ib: refuse to attach a
 connection to a device being removed
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:34:58 +0000
Message-ID: <179113169845.434549.16777871408089243882@kernel.org>
In-Reply-To: <20261003163215.250253-4-achender@kernel.org>
References: <20261003163215.250253-4-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message gets the trigger wrong.

--

net/rds: ib: refuse to attach a connection to a device being removed

This patch adds a shutting_down flag to struct rds_ib_device.
rds_ib_dev_shutdown() sets it under rds_ibdev->spinlock before walking
conn_list. rds_ib_add_conn() checks the flag under the same lock and
returns -ENODEV, which makes rds_ib_setup_qp() fail the connect.

> rds_ib_remove_one() drops every connection on the device's conn_list
> in rds_ib_dev_shutdown(), then clears the client data so that no new
> connect can find the device.  A connect that is already past
> rds_ib_get_client_data() when the walk runs is not covered by either:
> rds_ib_setup_qp() goes on to rds_ib_add_conn(), which moves the
> connection onto the conn_list the walk has just finished with, and
> builds a QP on a device that is on its way out.  Nothing drops that
> connection afterwards - the device's shutdown walk is over, and the
> connection never returns to ib_nodev_conns, which is the only list the
> transport exit sweeps - so it outlives the device, and the module.

[Severity: Low]
Does this description hold for a real IB device hot-removal?

disable_device() in drivers/infiniband/core/device.c removes clients in
LIFO order. That means rds_ib_remove_one() runs before rdma_cm's
cma_remove_one().

cma_process_remove() then sends DEVICE_REMOVAL to every cm_id still on the
device, including the late connection's ic->i_cm_id. It then waits for
those ids to be destroyed:

cma_remove_one()
  cma_process_remove()
    cma_send_device_removal_put(id_priv)
      ...
        rds_rdma_cm_event_handler_cmn()

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
    ...
	case RDMA_CM_EVENT_DEVICE_REMOVAL:
	case RDMA_CM_EVENT_ADDR_CHANGE:
		if (conn)
			rds_conn_drop(conn);
		break;
    ...
}

During a plain hot-removal, rds_destroy_pending() is false, so this
rds_conn_drop() queues the shutdown. The shutdown tears down the QP and
cm_id, and rds_ib_remove_conn() puts the connection back on
ib_nodev_conns. So on hot-removal the connection does not seem to outlive
the device.

The leak described here seems to need the module unload path instead:

rds_ib_exit()
  rds_ib_set_unloading()
  rds_ib_unregister_client()
    rds_ib_remove_one()    <- device stays registered, no DEVICE_REMOVAL
  rds_ib_destroy_nodev_conns()

On this path rds_destroy_pending() is true, so every non-destroy
rds_conn_drop() returns early. rds_ib_destroy_nodev_conns() only sweeps
ib_nodev_conns. A connection attached after the walk is then leaked.

The code change looks correct for both cases. Could the commit message
name the trigger as unloading rds_rdma while a connect is in flight,
rather than device removal in general? The patch carries a Fixes: tag, so
stable backporters will use this description to judge how the bug
reproduces and what it affects.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
