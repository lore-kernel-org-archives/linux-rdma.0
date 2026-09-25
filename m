Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E83911B5;
	Fri, 25 Sep 2026 11:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790336947; cv=none; b=tg2bYE6ethoXWy1ags/37XsC09xh6ah5CYR2UM2v2pmaAvISsFji7EP6dgadf0YbMmin+Olbe4Dy685a/Y30IRdhdOcHzQnTL4IWvfNnUbtgN2qZYGp6mGhH52+RDW3RmoRXKQ49QiP0eoN8s2A6cn3vsQKFPre//2G1KvKmVHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790336947; c=relaxed/simple;
	bh=CVmVtlkKR7SNwFbYgnqNdCKDHUzae+UJ2CuMNtkM8Zw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dAddpI/phkrKM3KL8LdQtSsWSHGwLg9nscOHzjwCmx/WoRmJSpjE/AtrBhAmYbwy7gUfAcv9ls8E1bmMnpB50q/uRj1wMnKrvk/0blWi0J5K35OLDA0g5uBd1yrNHW+bHxoOM9KnfYXQwbzJhgrqBXxUR1Azu0R828IoNjY51Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSWjX/pz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSWjX/pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859F01F000FF;
	Fri, 25 Sep 2026 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790336945;
	bh=WjQSiFQ5fdbwzb3Hntt6SDjtmfEpFahHE3hOQrqP8yQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MSWjX/pzk3hsi3/AtO5vM90P1MfbfmhH92OsQ6tVVwtInc6T5q6Kb8ehWAz9ubdJX
	 Ingqnf3sIYEWLKvvS/stY6dciPbH1cozu5SSIyqMyd9FX8+2FSUVoIpXsERgSnWQNQ
	 EeZYoHS4yi1QsewRONlTdsRw1otIOr1suYqIVwv9U9gm0vO0+kumpDkAAONsbTJ8xQ
	 hISYE+iBjuoVWRiPwFD3itoAIfNLcNv4+EKXDm+l7Bo/yUx7pjUaBQW2BSPMQzfCO1
	 KDj8fuiggQ8Ifkawv+xIh1sZh9KAhVkoM8hdt8FB8LMWu+J+pGYK53TxvOjCjUbRI1
	 aYBRveVK40F4g==
Subject:
 Re: [PATCH net-next v3] net/rds: restrict the rdma_cm ids to IB devices
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Fri, 25 Sep 2026 11:49:05 +0000
Message-ID: <179033694505.2160803.10055619633105856141@kernel.org>
In-Reply-To: <20260922084837.390414-1-achender@kernel.org>
References: <20260922084837.390414-1-achender@kernel.org>
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Commit-message misclassification: the changelog declares this
  change "hardening on top of it, not a fix in its own right, hence no…

Pre-existing issues:
- [Low] rds_rdma_listen_init_common() (net/rds/rdma_transport.c) logs the
  listening port as the compile-time constant RDS_PORT (18634) at line…

--

net/rds: restrict the rdma_cm ids to IB devices

This restricts the three rdma_cm ids RDS creates - the listener, the
per-connection id in rds_ib_conn_path_connect() and the probe id in
rds_ib_laddr_check_cm() - to RDMA_NODE_IB_CA with
rdma_restrict_node_type() before they are bound.  The explicit node_type
test in rds_ib_laddr_check_cm() is dropped as redundant.

>From the changelog:

> With that, no rdma_cm event reaches RDS's handler from a device it
> has no transport for.  The handler itself still assumes IB: it assigns
> its transport pointer only for RDMA_NODE_IB_CA and dereferences it
> regardless, which is the crash that first surfaced this.  The fix for
> that is a separate net patch, Aohan Mei's "net: rds: fix uninitialized
> trans dereference in CM event handler", and is what stable kernels
> without rdma_restrict_node_type() - which arrived in commit
> a760e80e90f5 ("RDMA/core: introduce rdma_restrict_node_type()") - have
> to take; this patch is hardening on top of it, not a fix in its own
> right, hence no Fixes tag.

[Severity: Medium]
Is the "not a fix in its own right, hence no Fixes tag" classification
accurate for the tree this applies to?

The referenced companion patch ("net: rds: fix uninitialized trans
dereference in CM event handler") is not present here.  In
rds_rdma_cm_event_handler_cmn() the transport pointer is still
uninitialized on entry:

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
	struct rds_connection *conn = cm_id->context;
	struct rds_transport *trans;
	...
	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
		trans = &rds_ib_transport;
	...
	case RDMA_CM_EVENT_CONNECT_REQUEST:
		ret = trans->cm_handle_connect(cm_id, event, isv6);
	...
	case RDMA_CM_EVENT_ESTABLISHED:
		if (conn)
			trans->cm_connect_complete(conn, event);
}

So for any event arriving from a device whose node_type is not
RDMA_NODE_IB_CA, trans is dereferenced as stack garbage, and the
CONNECT_REQUEST case is reachable from an inbound connection on the RDS
port.

Before this patch cma_listen_on_dev() installed the RDS listener on every
RDMA device, and cma_acquire_dev_by_src_ip() could pick a software iWARP
device for the same netdev, which is what made that path reachable.  With
the listener restriction added below, cma_listen_on_dev() honours
restricted_node_type and no longer installs the listener on such a device.

That makes this patch the change that removes the remotely reachable route
to that indirect call in this tree.  Should it then carry a Fixes tag and
state the ordering dependency on the companion handler patch, rather than
being described as hardening only?

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..91ff1dde26af0 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -210,6 +210,14 @@ static int rds_rdma_listen_init_common(rdma_cm_event_handler handler,
>  		return ret;
>  	}
>  
> +	/* Only the IB transport is left, so only listen on IB devices */
> +	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
> +	if (ret) {
> +		pr_err("RDS/RDMA: failed to setup listener, rdma_restrict_node_type() returned %d\n",
> +		       ret);
> +		goto out;
> +	}
> +
>  	/*
>  	 * XXX I bet this binds the cm_id to a device.  If we want to support
>  	 * fail-over we'll have to take this into consideration.

[Severity: Low]
This isn't a bug introduced by this patch, but since the patch touches
rds_rdma_listen_init_common() anyway: the debug line further down in the
same function hard-codes the port,

	rdsdebug("cm %p listening on port %u\n", cm_id, RDS_PORT);

while the helper has two callers with different ports.
rds_rdma_listen_init() binds the IPv4 listener with
sin.sin_port = htons(RDS_PORT) and the IPv6 listener with
sin6.sin6_port = htons(RDS_CM_PORT), as the comment above it describes.

For the IPv6 listener the message therefore prints 18634 rather than the
16385 that was bound.  Would it make sense to print the port from the sa
argument that was just bound instead?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922084837.390414-1-achender%40kernel.org
