Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABA122173D;
	Wed, 23 Sep 2026 06:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144620; cv=none; b=SxdmU7qppkAsNEnF2jcpzESUGlTp6I0BxZ1pj34SgB/IGg3evTnunTSbtiv9fDBoohPxwLoReWZHFB7QJbsCc6Nk82ne5su22L5dvzkqM2TU61ZdEKMblAMELoZzG0ZHSQ44z9bldkKROVOiRnH9z8fL/mB2pO/OOo+E9UIG7Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144620; c=relaxed/simple;
	bh=tztk1rMt7uYOXzaiiNz9eAiIaTLUKJb6Xz1WIjJ9BNM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GiBCapIlmG6Eg8DRY4SVw/otQfZKYQFvGkOoWUhNOacihB9cRM4L1Bp5pD1GWol5DTRYuETN/QWYPBme2n+KlgpxnVuwc31AfUf9VXczv86xrQw5kGYtLYTFKfBl0K/wuEuECv2NOGN8tOqCpC/6vcnGpaJMMiYKQ3CutuGluPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkzRdzA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkzRdzA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33AD1F000FF;
	Wed, 23 Sep 2026 06:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790144619;
	bh=vo/GpK/xjgvJiIt6BIGErzfmsclkg5YWEncAV7jRoM4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hkzRdzA+62ScOsJDof2bY7EyOLeroutVvamzyoFes5r64eQ8sBmHHO3FfmtB96ODO
	 WoPDQdiJbdacx1yyO+E6Z6VBbJZxo4fLPHvWP2bQoAjbis6uGKWYoIqC8fF9saoEjH
	 6q+JH/i2NLpcJAC9nUicQGFvFE59sIrmjTWVYAl0rfeqhhJIHkhTkSG6w1zHDK3bAB
	 plbNwpFmCDAIAp80cmpeBX75unjuCFBKETne0LyHIlkAnLJuQSgxd93xKrBOP5eGS8
	 vCr1IiKZDr/xK7YxBH6JWRWG98BT/GtA5ekddKcawtiRe90rYiXPO/x4DTlWAF+Tu7
	 QWamuPywaTk4A==
Subject:
 Re: [PATCH net-next v2] net/rds: restrict the rdma_cm ids to IB devices
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Wed, 23 Sep 2026 06:23:38 +0000
Message-ID: <179014461813.2160803.2547916485021315736@kernel.org>
In-Reply-To: <20260919061042.250462-1-achender@kernel.org>
References: <20260919061042.250462-1-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The commit message's closing paragraph asserts that "the
  connect-request rejection for non-IB devices in the event handler…
- [Medium] The patch fixes a real, reachable defect but carries no Fixes:
  tag and no stable disclosure.

--

net/rds: restrict the rdma_cm ids to IB devices

This restricts the three rdma_cm ids RDS creates (the listener, the
per-connection id and the probe id in rds_ib_laddr_check_cm()) to
RDMA_NODE_IB_CA via rdma_restrict_node_type() before they are bound, so
the listener is only installed on IB devices and an outgoing connection
can only bind one.

A couple of questions below.

> With that, the connect-request rejection for non-IB devices in the
> event handler becomes unreachable; it stays as the last line of
> defence and is what stable kernels without the new API rely on.

[Severity: High]

Which rejection is this referring to?  Looking at
rds_rdma_cm_event_handler_cmn() in net/rds/rdma_transport.c, the only
node type test has no else arm and no early return:

	struct rds_connection *conn = cm_id->context;
	struct rds_transport *trans;
	...
	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
		trans = &rds_ib_transport;

trans is then dereferenced unconditionally in the switch below:

	case RDMA_CM_EVENT_CONNECT_REQUEST:
		ret = trans->cm_handle_connect(cm_id, event, isv6);
		break;

and the same for trans->cm_initiate_connect() on the
RDMA_CM_EVENT_ROUTE_RESOLVED arm and trans->cm_connect_complete() on the
RDMA_CM_EVENT_ESTABLISHED arm.  rds_ib_cm_handle_connect() in
net/rds/ib_cm.c does not check node_type either, and a grep of net/rds/
for RDMA_NODE only turns up rds_ib_laddr_check_cm() and rds_ib_add_one()
in net/rds/ib.c besides the line above.

So for a device whose node_type is not RDMA_NODE_IB_CA, isn't the
described "last line of defence" actually an indirect call through an
uninitialized stack pointer rather than a rejection?  git blame points
the missing else arm at dcdede0406d30 ("RDS: Drop stale iWARP RDMA
transport").

That also affects the stable statement: kernels without
rdma_restrict_node_type() would have no protection here at all rather
than a fallback.  If the event handler check is meant to be the retained
fallback, should this patch add it, for example initializing trans = NULL
and returning an error when
cm_id->device->node_type != RDMA_NODE_IB_CA?  That form would also be
backportable on its own.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 6e3110a04ae6..e7014453eaec 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -999,6 +999,18 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
>  		goto out;
>  	}
>  
> +	/* rds_ib_laddr_check() only vouched for the local address being
> +	 * on an IB device; the address resolution below picks the device
> +	 * on its own, so restrict it to the same kind.
> +	 */
> +	ret = rdma_restrict_node_type(ic->i_cm_id, RDMA_NODE_IB_CA);
> +	if (ret) {
> +		rdsdebug("rdma_restrict_node_type() failed: %d\n", ret);
> +		rdma_destroy_id(ic->i_cm_id);
> +		ic->i_cm_id = NULL;
> +		goto out;
> +	}
> +
>  	rdsdebug("created cm id %p for conn %p\n", ic->i_cm_id, conn);
>  
>  	if (ipv6_addr_v4mapped(&conn->c_faddr)) {

[ ... ]

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a..91ff1dde26af 100644
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

[Severity: Medium]

Should this carry a Fixes: tag?  Both halves of the change look like they
correct reachable behaviour that predates the patch.

rdma_create_id() initializes id_priv->restricted_node_type to
RDMA_NODE_UNSPECIFIED, and cma_listen_on_dev() only skips a device when a
restriction is set, so before this patch rds_rdma_listen_init_common()
installed the RDS listener on every RDMA device, iWARP RNICs included.

Similarly cma_acquire_dev_by_src_ip() walks every device, so the
rdma_resolve_addr() in rds_ib_conn_path_connect() could bind a non-IB
device for an address that rds_ib_laddr_check() only vouched for on an IB
device.

git blame suggests dcdede0406d30 ("RDS: Drop stale iWARP RDMA transport")
as the candidate commit, since it removed the iWARP transport arm while
leaving the common listener and the per-connection id unrestricted.

Since the fix depends on the new rdma_restrict_node_type() API, could the
message also state explicitly that stable trees need a separate minimal
fix, so backporters know what to pick?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061042.250462-1-achender%40kernel.org
