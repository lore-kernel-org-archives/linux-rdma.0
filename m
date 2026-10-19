Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF2139B48D;
	Mon, 19 Oct 2026 12:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792412086; cv=none; b=MXKSkuwrfNo+wz3oirvpxYsGqaDZ9wmYI2ZVPgkRjpE0MCZovlhKEOG9oaSyiMId33Ik3XS9s5T0poWwERPGJfp5rxReDlsOxD33CiIDGHQ/fovOBS1lWeN5Vm+BnuhQsvmtMz58wL2NWRFzRWa6KrmsdnYBM0Rk5Ok5UcpXZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792412086; c=relaxed/simple;
	bh=Bh72GdJy53aQCViXarW7NDjGQCbaprPPJWXKTIogq3w=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PZZnIzNQUSuJwlD8GDrBQ6g5YM7nkm/VdUwg1lHIa7wkfQfajjcMAR5hrF2VG0O18zPDEJBSd/5ji/JgOsO2VAgNm+GXJjY1sD7S2Um1JpbJUnJF4US8mZm3YY82dg+sNr6pcspHgPomQ3rfLAH33OEF+zFF6pFrOg2J/DIMKYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMKsmmrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMKsmmrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E505A1F000C4;
	Mon, 19 Oct 2026 12:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412084;
	bh=xnQC9XucQfW5esGo46rmdChyfPts6Hpx8bW+w3bC1hs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AMKsmmrvzbNzg/g9VIIWuxq13N5MbAtm0tL2lgd/ypop7qpa5eCklTVtSYx36q+4v
	 dRFEFubrbZ9iRZ1z2oVFxPIiNBVLIXEMX7XfJtfbQ0o9A71e4s/aU3p6/VvdYANY9I
	 90ewplrgQKBk7JHNlsAufkMnUIKtrM282Ok4RKVKKavu1HGusF9BjaadU5i5IfOThF
	 HJLj+68E8QDhI5ST4+g2HtUSyjE0DbxTo9V4WPgddxG4S0nGRsr/frWoHrG1bciz9N
	 ZDwNZlt2HaMCIjRHFXD7ysdV7pz3PRz1Olf+CSbWOhnatyPsiLfikpItqzaYpQfxsa
	 f2m1MnJUtGpUw==
Subject: Re: [PATCH net v5 1/2] net/smc: order the CDC receive path against
 RMB publication
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: kuba@kernel.org, dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
 davem@davemloft.net, pabeni@redhat.com, alibuda@linux.alibaba.com,
 mjambigi@linux.ibm.com, edumazet@kernel.org, horms@kernel.org,
 wenjia@linux.ibm.com, ubraun@linux.ibm.com, hwippel@linux.ibm.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org, guwen@linux.alibaba.com,
 linux-s390@vger.kernel.org
Date: Mon, 19 Oct 2026 12:14:43 +0000
Message-ID: <179241208347.3135.18021879529736748765@kernel.org>
In-Reply-To: <20261015-b4-disp-2a8d85ef-v5-1-6b795e8263c9@proton.me>
References: <20261015-b4-disp-2a8d85ef-v5-1-6b795e8263c9@proton.me>
X-sashiko-severity: High
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

Critical: 0 · High: 1 (2) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new `!smp_load_acquire(&conn->rmb_desc)` check in
  smc_cdc_rx_handler() only tells NULL apart from non-NULL.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the teardown
  ordering leaves the RMB reachable after release.
- [High] This problem wasn't introduced by this patch, but the peer's
  producer cursor is never bounds-checked before it indexes the RMB.

--

net/smc: order the CDC receive path against RMB publication

This patch moves the conn->rmb_desc assignment in __smc_buf_create() after
the other receive fields and makes it a release store. smc_cdc_rx_handler()
now uses an acquire load and drops a CDC whose connection has no rmb_desc
yet. The goal is to stop a CDC with a predicted token from reaching a NULL
rmb_desc in softirq.

Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me?part=1

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..7bf902ebd7ab6 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -483,7 +483,11 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
>  	lgr = smc_get_lgr(link);
>  	read_lock_bh(&lgr->conns_lock);
>  	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
> -	if (!conn || conn->out_of_sync) {
> +	/* The connection is in the token tree before __smc_buf_create()
> +	 * sets its RMB: drop a CDC that comes earlier. rmb_desc is never
> +	 * cleared, so the callees can load it plainly.
> +	 */
> +	if (!conn || conn->out_of_sync || !smp_load_acquire(&conn->rmb_desc)) {

[Severity: High]
Can a NULL check tell us that the current registration's RMB is ready?
Nothing ever resets conn->rmb_desc to NULL. smc_buf_unuse() releases the
RMB and leaves the pointer in place, and smc_conn_create() does not clear
it either.

On the SMC-R listen path, smc_listen_find_device() can try V2 and then
fall back to V1 on the same conn:

smc_find_rdma_v2_device_serv()
  smc_listen_rdma_init()
    smc_conn_create()        /* token registered */
    smc_buf_create()         /* rmb_desc published */
  smc_listen_rdma_reg()      /* fails */
  smc_conn_abort()
    smc_conn_free()
      smc_buf_unuse()
        smcr_buf_unuse()     /* frees or pools the RMB */

smc_find_rdma_v1_device_serv()
  smc_listen_rdma_init()
    smc_conn_create()        /* new token, rmb_desc still stale */
    smc_buf_create()

smcr_buf_unuse() has two outcomes here. If smcr_link_reg_buf() set
is_reg_err, it frees the descriptor through smc_buf_free(). If the peer
failed CONFIRM_RKEY in smcr_lgr_reg_rmbs(), it zeroes the buffer and
returns it to the pool with used=0.

Suppose a CDC with the new token arrives before __smc_buf_create()
publishes the new RMB. That is the same window the commit message
describes. Wouldn't it pass the new check, since the stale pointer is
non-NULL?

smc_cdc_msg_recv_action() would then read conn->rmb_desc->len, and
smc_cdc_handle_urg_data_arrival() would read conn->rmb_desc->cpu_addr. The
descriptor behind them is either freed or owned by another connection.

The stale pointer also matters if the V1 retry fails in
__smc_buf_create(is_rmb). smc_conn_abort() then runs smc_buf_unuse() again:

	if (conn->rmb_desc) {
		bufsize = conn->rmb_desc->len;
		if (!is_smcd) {
			smcr_buf_unuse(conn->rmb_desc, true, lgr);

Could this double free the descriptor or corrupt the rmbs list?

Would it be better to reset conn->rmb_desc and conn->sndbuf_desc to NULL
when the buffers are released, or before the conn is registered again?
The follow-up patch "net/smc: skip the DMB nocopy accounting until the
send buffer is set" doesn't appear to change this.

[Severity: High]
This isn't a bug introduced by this patch, but there is a related problem
at teardown. The comment says rmb_desc is never cleared. That is true of
the pointer value, but what about the lifetime of the object it points to?

smc_conn_free() releases the buffers before the conn leaves the token
tree:

	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}

For SMC-R, smcr_buf_unuse() frees the descriptor through smc_buf_free()
when buf_desc->is_reg_err is set, for example after smcr_link_reg_buf()
failed. Otherwise it zeroes the buffer and sets used=0, so
smc_buf_get_slot() can hand it to another connection.

smc_cdc_rx_handler() doesn't check conn->freed, and it drops conns_lock
after sock_hold(). bh_lock_sock() doesn't wait for a lock_sock() owner,
and smc_conn_free() only waits for pending TX WRs.

Can a peer CDC that finds the conn before smc_lgr_unregister_conn() still
run smc_cdc_msg_recv_action() and smc_cdc_handle_urg_data_arrival()? If
so, they would read conn->rmb_desc->len and conn->rmb_desc->cpu_addr from
a freed or reassigned descriptor. The new check would pass here too,
since the stale pointer is non-NULL.

[Severity: High]
This is a pre-existing issue, but the new comment says the callees can
load rmb_desc plainly once it is set. Is the peer's producer cursor ever
checked against the RMB length?

smc_cdc_cursor_to_host() only rejects cursors that move backwards:

	temp.count = ntohl(net.count);
	temp.wrap = ntohs(net.wrap);
	if ((old.wrap > temp.wrap) && temp.wrap)
		return;
	if ((old.wrap == temp.wrap) &&
	    (old.count > temp.count))
		return;
	smc_curs_copy(local, &temp, conn);

smc_curs_diff() also doesn't cap its result at size, even though its
comment says the difference cannot exceed size.

So if prod_flags.urg_data_present is set and prod.count moves forward by
any amount, smc_cdc_msg_recv_action() calls
smc_cdc_handle_urg_data_arrival(), which does:

	base = (char *)conn->rmb_desc->cpu_addr + conn->rx_off;
	if (conn->urg_curs.count)
		conn->urg_rx_byte = *(base + conn->urg_curs.count - 1);

Could a peer-controlled urg_curs.count make this read up to about 4 GiB
past the RMB in softirq? An unmapped address would oops. A byte read from
a mapped address would be stored in conn->urg_rx_byte, and
smc_rx_recv_urg() copies it to user space through memcpy_to_msg() on
recv(MSG_OOB).

The follow-up patch in the series doesn't touch this path either.

>  		read_unlock_bh(&lgr->conns_lock);
>  		return;
>  	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015-b4-disp-2a8d85ef-v5-0-6b795e8263c9%40proton.me
