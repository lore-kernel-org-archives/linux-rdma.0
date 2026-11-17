Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794877586;
	b=4zqYHRoNFQbRPGwDuTrTVf82JUcXa4WlX8lOIuL8FN+PUTkhW/rPH+Nks742+HJm9EI2
	 LlAMa2eYQXijW4dgp95mykmk1H/sGKPyFTyiawzvnlZrAEP3ogVYEuYMpvfGSsmI1ymhQ
	 RWhytzp7MlBSxigmj3bLo18aC1oblf56g0kErs/6rAu9KiVtxqFrCnMPWBPpwrF2RzSVP
	 nXxeFr7UAFPlzoEn8puPnzi+rOFUXYPDFvUGAH3zUc5zhcux6bk408iEekakc7uHYEOVw
	 7BBBTHtZkyNNMNbO1xWiRR8QOVUB3sUU7/VHIaAP0dxWwHV03gcAt7ndtgaK01sNCgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794877586;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=FtCHv2hJNjrIBksgmbvYqxzyYPeLptLTLEm0XlQYrJE=;
	b=VKemAaOeZkFSntUVNYawPs1scbM/ywABuMcCdTkoRCaD2c/8muGeAi23sCyDQmmSVEC7
	 oXOHqOzInX3FHWhLaxnCniYKd2Wmsd4gSa8bZJfziFgGMcfraoGf7YuFtokvykwXQNMHO
	 MyQ7O/EizXuO5IC61vkz0McnJX52YU0LXIOHgjNf5Rrwfm8qOY7pg1UY3oFm6k6at552A
	 Pvl3LyFaNpPtu1xmK1+UGVOkzMHUqKqe0+atNDe4+H4v/9dItYkKaE9n2tQ9aL3b8q5pR
	 Y8IYsnKz/dqCHSIvdHF8+MsWgyI7KSmzz1eIMXU8yHqxaPu90CDHJ467OuLF03z6cvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PTE+JNZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35031606A31C;
	Tue, 17 Nov 2026 01:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PTE+JNZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BBE1F000C4;
	Tue, 17 Nov 2026 01:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794877585;
	bh=FtCHv2hJNjrIBksgmbvYqxzyYPeLptLTLEm0XlQYrJE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PTE+JNZEjBjJVRA530hJmDLXRIG1kp1wjjGGDbIsDzH+JavxPVvqtldEbXgOMBHYm
	 HDBdV2y0af7sCnrsAzl5Moj64afbGw7cIDiK1TcT1ejfIC6eSpYmrgGCmjlss6FgXL
	 xkg2vINFVhqWT6+98+6OYVPrXjUadR3WFVGmnCow0qDA1ZUxDAS+bZMafrrTZOAxzF
	 Yy4YVd9X8pj0tZ/pz18uzvrwUxymI3KkYOy/RktGWETS3wvWpnsaUeGglr3v5QYMoP
	 gjZaNU8fKug9rLS6tB4gQoTQmo0rW94rAXZzSmOiU+Ik/jeOdO86gIX5SlzaGuq9Yu
	 i9aZmv3PU/HCg==
Subject: Re: [PATCH net v6 2/3] net/smc: clear the buffer pointers before
 registering a connection
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: mjambigi@linux.ibm.com, kuba@kernel.org, dust.li@linux.alibaba.com,
 davem@davemloft.net, edumazet@kernel.org, sidraya@linux.ibm.com,
 pabeni@redhat.com, alibuda@linux.alibaba.com, hwippel@linux.ibm.com,
 linux-kernel@vger.kernel.org, wenjia@linux.ibm.com, netdev@vger.kernel.org,
 hidayath@linux.ibm.com, ubraun@linux.ibm.com, tonylu@linux.alibaba.com,
 linux-rdma@vger.kernel.org, guwen@linux.alibaba.com,
 linux-s390@vger.kernel.org, horms@kernel.org
Date: Tue, 17 Nov 2026 01:06:24 +0000
Message-ID: <179487758425.3136.7345936021290037161@kernel.org>
In-Reply-To: <20261112-b4-disp-1c8d3a53-v6-2-36a38ae35021@proton.me>
References: <20261112-b4-disp-1c8d3a53-v6-2-36a38ae35021@proton.me>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] This patch still leaves rmb_desc and sndbuf_desc dangling while
  the connection can be found by its token.

--

net/smc: clear the buffer pointers before registering a connection

This patch clears conn->rmb_desc and conn->sndbuf_desc under the socket
spinlock in smc_conn_create(). The goal is that a retried handshake does
not register the connection under a new token with stale buffer pointers.
It also makes smc_cdc_msg_recv_action() return early when rmb_desc is
NULL.

Closes: https://lore.kernel.org/all/179241208347.3135.18021879529736748765@kernel.org/

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index ee5ba6c7a5b4a..b3bcc206efe3e 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -334,6 +334,10 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  	struct smc_connection *conn = &smc->conn;
>  	int diff_cons, diff_prod, diff_tx;
>  
> +	/* smc_conn_create() can have cleared rmb_desc */
> +	if (!smp_load_acquire(&conn->rmb_desc))
> +		return;
> +
>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
>  	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
> @@ -484,7 +488,8 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
>  	read_lock_bh(&lgr->conns_lock);
>  	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
>  	/* The connection is in the token tree before __smc_buf_create()
> -	 * sets its RMB: drop a CDC that comes earlier.
> +	 * sets its RMB: drop a CDC that comes earlier. rmb_desc is cleared
> +	 * under the socket spinlock; smc_cdc_msg_recv_action() tests it there.
>  	 */
>  	if (!conn || conn->out_of_sync || !smp_load_acquire(&conn->rmb_desc)) {
>  		read_unlock_bh(&lgr->conns_lock);
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 02269cede641e..9ef9019bc4974 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -2024,6 +2024,15 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>  	spinlock_t *lgr_lock;
>  	int rc = 0;
>  
> +	/* A retried handshake comes back with the buffer pointers of the
> +	 * failed attempt still set: clear them before the connection is
> +	 * registered. smc_cdc_msg_recv_action() tests rmb_desc under this lock.
> +	 */
> +	spin_lock_bh(&smc->sk.sk_lock.slock);
> +	WRITE_ONCE(conn->rmb_desc, NULL);
> +	WRITE_ONCE(conn->sndbuf_desc, NULL);
> +	spin_unlock_bh(&smc->sk.sk_lock.slock);

[Severity: High]
Is this clear too late to close the window the commit message describes?
smc_conn_free() releases the buffers while the connection is still in the
token tree, and it does so without the socket spinlock:

net/smc/smc_core.c:smc_conn_free() {
    ...
	if (!list_empty(&lgr->list))
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
	smc_lgr_unregister_conn(conn);
    ...
}

smc_buf_unuse() leaves conn->rmb_desc and conn->sndbuf_desc set. For
SMC-R, smcr_buf_unuse() either frees the descriptor or puts it back in
the pool:

net/smc/smc_core.c:smcr_buf_unuse() {
    ...
	if (buf_desc->is_reg_err) {
		...
		smc_lgr_buf_list_del(lgr, is_rmb, buf_desc);
		...
		smc_buf_free(lgr, is_rmb, buf_desc);
	} else {
		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
		WRITE_ONCE(buf_desc->used, 0);
	}
}

In the second case, smc_buf_get_slot() can give the RMB to another
connection.

Between smc_buf_unuse() and smc_lgr_unregister_conn(), smc_cdc_rx_handler()
can still find the connection for a CDC that carries the old token. The
CDC passes the non-NULL rmb_desc test there. The new test in
smc_cdc_msg_recv_action() also rejects only NULL, so the handler goes on
to:

	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);

It also reaches conn->rmb_desc->cpu_addr through
smc_cdc_handle_urg_data_arrival().

When is_reg_err is set, is this a use-after-free of the smc_buf_desc?
When it is not set, isn't the CDC applied to an RMB that may now belong to
another connection?

There are two more cases. A handler that looked up the connection before
smc_lgr_unregister_conn() and takes the slock any time before a retry
reaches smc_conn_create() sees the same stale pointer. If no retry happens,
nothing ever clears the pointers. SMC-R also has no RX drain on this path,
since smc_cdc_wait_pend_tx_wr() only waits for TX completions.

is_reg_err gets set when smc_wr_reg_send() fails in smcr_link_reg_buf():
-EINTR from a signal during connect(), -EIO from a flushed REG_MR WR, or
-EPIPE on timeout. A negative CONFIRM_RKEY response from the peer leads to
the returned-to-pool case. The token comes from the global nexttoken
counter in smc_lgr_register_conn(), so the peer can predict it.

The patch notes say "a pointer seen set stays set", and the new comment
in smc_cdc_rx_handler() points to the slock re-test.

Does a set pointer mean the buffer still belongs to this connection,
though?

Could the pointers instead be cleared under the slock where the buffers
are released, in smc_buf_unuse()/smc_conn_free()? Or could the token be
unregistered before the buffers are released? Either would replace the
clear in smc_conn_create() rather than add to it.

>  	lgr_list = ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_list :
>  				  &smc_lgr_list.list;
>  	lgr_lock = ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_lock :

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021%40proton.me
