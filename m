Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EBC36C588;
	Thu, 27 Aug 2026 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847503; cv=none; b=jL2aIOTECUbKosHjo64on0MZ8qW/5+6oQZqCUhsr20gWh8V5ffQpAlW8b18SZWWO9xX/2tZSEeNnX0B3YixJePKn93yS+UZ56gJoDC0sDi3AReil25B2Bs3wvUdwF+y/l3IWlT9uELydl7ducKuEnbFMhFiR/T3SuMTV+dAdwMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847503; c=relaxed/simple;
	bh=NcrmYDp3/x1knGoO/dIS8c/CdSMEhACAx1xS7AEVeFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/gBBam6rPIwavS+5ZoRLZtJpEmOkNI4zJ46Qvtv0+p0WezFWlhaLAdIgiwTMKx6fCMJLi6hjDb0kWtbpm3suoVnYbmc6smHnYEmkrBLGXrhAdWyap7yNz3Dvjys3qaVSxdhegXMY+n6zskuH4JyqF9usyyLONpxE9p8mA3X8po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTh/KTi+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTh/KTi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B8B1F000E9;
	Thu, 27 Aug 2026 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847502;
	bh=mOqEaDKgcLq2GJL2+kULDh7kIMO3nrYg/DVzSD/Tr6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTh/KTi+UnPULcjofyifqpF+4INUxrIxK1gcckqL7oc9RqIeS6Q9PPPW0/Klsh945
	 NvwUXOgyOJ2rBoRiXjeI6ybstSPM20ii8QW5oLKWzV7h9+B4PO0qS3MxguFEECZ2UQ
	 RbaBwtwE9Az8wteDRrlyBsaLuSyDopsgPef+udTF/yJMasfN1uoLd9Q41KZMBY1SH5
	 QXcYZbSEe7dMPURmcn6t5tqTH3rwowFs02sz6LsFCKGV/uiaEDNETEVX249P3mDN24
	 GrtUgY3OhcqKmv8uRxn6/UuIf1p2y2BaadVtKHm5szTwagBtiCwIYiU5v+UneEPXh+
	 fcBBwXznJ7NAg==
From: Jakub Kicinski <kuba@kernel.org>
To: ljp1205831794@gmail.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	achender@kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	kerneljasonxing@gmail.com,
	henrymei@tencent.com,
	corvus@tencent.com,
	stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: rds: fix uninitialized trans dereference in CM event handler
Date: Thu, 27 Aug 2026 09:18:20 -0700
Message-ID: <20260827161820.3867858-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825021223.3483044-1-ljp1205831794@gmail.com>
References: <20260825021223.3483044-1-ljp1205831794@gmail.com>
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
net: rds: fix uninitialized trans dereference in CM event handler

This initializes trans to &rds_ib_transport at declaration in
rds_rdma_cm_event_handler_cmn(), drops the conditional assignment based on
cm_id->device->node_type, and adds an early bail-out that returns 1 for any
event arriving on a device that is not RDMA_NODE_IB_CA.

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..2c5481f1fcb4f 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c

[ ... ]

> @@ -80,6 +77,12 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  		}
>  	}
>  
> +	/* Only the IB transport is supported. */
> +	if (cm_id->device->node_type != RDMA_NODE_IB_CA) {
> +		ret = 1;
> +		goto out;
> +	}
> +

[Severity: High]
Should this non-zero return be limited to RDMA_CM_EVENT_CONNECT_REQUEST?
As written it applies to every event type.

include/rdma/rdma_cm.h documents what a non-zero return means:

/**
 * rdma_cm_event_handler - Callback used to report user events.
 *
 * Notes: Users may not call rdma_destroy_id from this callback to destroy
 *   the passed in id, or a corresponding listen id.  Returning a
 *   non-zero value from the callback will destroy the passed in id.
 */

The cma dispatchers implement exactly that, for example addr_handler() and
cma_work_handler() in drivers/infiniband/core/cma.c:

	if (cma_cm_event_handler(id_priv, &event)) {
		destroy_id_handler_unlock(id_priv);
		return;
	}

But RDS keeps ownership of connection cm_ids.  rds_ib_conn_path_connect()
stores it:

	ic->i_cm_id = rdma_create_id(&init_net, handler, conn,
				     RDMA_PS_TCP, IB_QPT_RC);

and rds_ib_conn_path_shutdown() later dereferences and destroys the same
pointer, clearing it only afterwards:

	if (ic->i_cm_id) {
		rdsdebug("disconnecting cm %p\n", ic->i_cm_id);
		err = rdma_disconnect(ic->i_cm_id);
	...
		rdma_destroy_id(ic->i_cm_id);
	...
		ic->i_cm_id = NULL;

So if any event other than CONNECT_REQUEST is delivered with conn != NULL on
a cm_id whose device node_type is not RDMA_NODE_IB_CA, does the core free the
cm_id while ic->i_cm_id still points at it?  Can the following conn drop,
socket close or module unload then hit freed memory in
rds_ib_conn_path_shutdown(), including a second rdma_destroy_id() on the same
id?

A reachable path without any race: rds_ib_laddr_check() short-circuits via
rds_ib_get_device(), which only walks the ipaddr_list of RDS's own IB
devices:

net/rds/ib_rdma.c:rds_ib_get_device() {
	list_for_each_entry_rcu(rds_ibdev, &rds_ib_devices, list) {
		list_for_each_entry_rcu(i_ipaddr, &rds_ibdev->ipaddr_list, list) {
			if (i_ipaddr->ipaddr == ipaddr) {
	...
}

while the device actually bound for the outgoing connection is picked later
by cma_acquire_dev_by_src_ip(), which walks the global cma dev_list and can
match a siw device on the same address.  siw_device_create() sets:

	base_dev->node_type = RDMA_NODE_RNIC;

In that configuration, rdma_resolve_addr() from rds_ib_conn_path_connect()
binds a RDMA_NODE_RNIC device, and the resulting RDMA_CM_EVENT_ADDR_RESOLVED
with conn != NULL now returns 1, so addr_handler() destroys the id while RDS
still tracks it.

The same function a few lines above already documents the opposite
convention:

		/* If the connection is being shut down, bail out
		 * right away. We return 0 so cm_id doesn't get
		 * destroyed prematurely */
		if (rds_conn_state(conn) == RDS_CONN_DISCONNECTING) {
			/* Reject incoming connections while we're tearing
			 * down an existing one. */
			if (event->event == RDMA_CM_EVENT_CONNECT_REQUEST)
				ret = 1;
			goto out;
		}

Separately, does the unconditional goto out also skip the rds_conn_drop()
that the ADDR_ERROR, ROUTE_ERROR, CONNECT_ERROR, UNREACHABLE,
DEVICE_REMOVAL, ADDR_CHANGE, DISCONNECTED and TIMEWAIT_EXIT cases perform,
leaving the RDS connection stuck in CONNECTING or UP with no error
propagated?

Would something along these lines match the existing convention, while still
dropping the conn for the remaining events:

	ret = (event->event == RDMA_CM_EVENT_CONNECT_REQUEST) ? 1 : 0;

or moving the node_type test into the RDMA_CM_EVENT_CONNECT_REQUEST case?
