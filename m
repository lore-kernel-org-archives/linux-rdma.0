Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D086E39FCAE;
	Tue, 13 Oct 2026 08:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878603; cv=none; b=AH6P7+DZNhmyZBRxowLD8kv0hA+JgU34FJi0QavkQbkVgsSEvOM19hsDjJvdTOSIi3ENhgt5SlHdrQ7WoKMhrjebz8sGydnmvd8ELZcIlI9ADdPHguwLuqSs1H/XIcpw/3z51OeH8fSjFnKml1Ts4b4IQLc/hzdMjTupJqMub8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878603; c=relaxed/simple;
	bh=uDVIqwl9wf7z4iefSNPp6KWVpjSEFle1efCgDktniEU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ckDaxxReMuMgp++A9tmTK4CLLFngxP/SSH8+LeI8POf7M2BOfb9P7FNr/jlBL+e2bisIV6h02r+MuvLd+Bp3JnnOjQzbTG/zo7zV7nweOPCRpkijPrgEBE8Sj9MzwKJZ7ejTKUxzQ0TSLrBc0e8Gy2XI/ZWo7U+ggQeklqgU6hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I57Xxjje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I57Xxjje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5661F000FF;
	Tue, 13 Oct 2026 08:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791878601;
	bh=AVOqioA6o42aiedEIoPlkGWPjIA7wN2/DbHfLFBLO00=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=I57XxjjeEsjvBQz9cLlsN5Q92ykjm0QfwSTOcCNErGR9uA3bbcxKMYD2TKlMdgoNF
	 jHFgH8fUmwMO+pr1ES2UfBPv2B7lv16J9qlR3JDzlKwqvHz9XLr7ZOAr6UIYG8vBrj
	 vJzhIN6Xnrff+7Oaas1vrDfR3Lrs4Pv5paBWlKF2UT9HWbGXUIaXGgEPmTad9uprgA
	 h/GmXJKj8M8CfVtklDGVzm1Kp7O1xGfZ1TYgyeLWM2PQRlTpgSHmksp/jLV05W146d
	 iYyWljQ+UJ2Xiegs2oYlhrxChCgvIriERpsOHAhncRl6gKYrJYnJjfrXgCHPTX/VWr
	 j0CuW9L8eEBlw==
Subject: Re: [PATCH net v9] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 13 Oct 2026 08:03:19 +0000
Message-ID: <179187859972.434549.160211929714609734@kernel.org>
In-Reply-To: <20261012080034.38770-1-mjambigi@linux.ibm.com>
References: <20261012080034.38770-1-mjambigi@linux.ibm.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 (2) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch adds `smc->sk.sk_prot->unhash(&smc->sk)` as the
  first statement of smc_conn_kill() (net/smc/smc_core.c:1520), so it…
- [Medium] The new sk_state-based guards in __smc_diag_dump()
  (net/smc/smc_diag.c) change the sock_diag uAPI output for sockets…
- [Low] __smc_diag_dump() (net/smc/smc_diag.c:161) now copies
  link->ibname into smc_diag_linkinfo.ibname instead of…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  smc_conn_free() (net/smc/smc_core.c:1279-1280) calls…
- [Medium] This problem wasn't introduced by this patch, but
  smc_diag_handler_dump() (net/smc/smc_diag.c:244) starts the dump…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch closes several windows where the SMC sock_diag dump can
dereference freed conn/lgr/lnk state of a socket that is still hashed. It
adds sk_state guards and acquire/release ordering in __smc_diag_dump(), and
unhashes the socket before smc_conn_free() in the close paths and at the
top of smc_conn_kill(). It also reports the cached link->ibname instead of
link->smcibdev->ibdev->name.

> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c1..aa6363abdd747 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c

[ ... ]

> @@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct *work)
>  		sk->sk_state_change(sk);
>  		if ((sk->sk_state == SMC_CLOSED) &&
>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			sk->sk_prot->unhash(sk);
>  			smc_conn_free(conn);

[Severity: Medium]
This isn't a bug introduced by this patch, but it came up while looking at
the smc_conn_free() calls here. Can smc_conn_free() leak the smc_sock
reference that a pending abort_work holds?

On SMC-R, smc_cdc_msg_validate() takes a reference for the work:

net/smc/smc_cdc.c:smc_cdc_msg_validate() {
    ...
		sock_hold(&smc->sk); /* sock_put in abort_work */
		if (!queue_work(smc_close_wq, &conn->abort_work))
			sock_put(&smc->sk);
    ...
}

That reference is normally dropped at the end of smc_conn_abort_work():

	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */

smc_conn_free() ignores the return value of the cancel:

net/smc/smc_core.c:smc_conn_free() {
    ...
		if (current_work() != &conn->abort_work)
			cancel_work_sync(&conn->abort_work);
    ...
}

Suppose smc_conn_free() runs from __smc_release() or
smc_close_passive_work() while abort_work is still pending. Then
cancel_work_sync() returns true, and nothing drops the reference the work
was holding.

smc_close_cancel_work() handles the same pattern for close_work:

	if (cancel_work_sync(&smc->conn.close_work))
		sock_put(sk);

Should smc_conn_free() do the same for abort_work?

>  			if (smc->clcsock)
>  				release_clcsock = true;
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..663926465ba7f 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  {
>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>  
> +	smc->sk.sk_prot->unhash(&smc->sk);

[Severity: Medium]
Does this hide sockets that stay open from sock_diag for the rest of their
lifetime?

The unhash runs for every SMC-R and SMC-D kill. Only the SMC-D dmb_nocopy
smcd_buf_detach() further down needs it.

smc_conn_kill() is called from __smc_lgr_terminate() for every connection
of a terminating link group (link down, device removal, admin
termination). It is also called from smc_conn_abort_work().

For SMC_ACTIVE, SMC_APPCLOSEWAIT1 and SMC_APPCLOSEWAIT2,
smc_close_active_abort() does not free the conn afterwards:

net/smc/smc_close.c:smc_close_active_abort() {
    ...
	case SMC_ACTIVE:
	case SMC_APPCLOSEWAIT1:
	case SMC_APPCLOSEWAIT2:
		sk->sk_state = SMC_PEERABORTWAIT;
		smc_close_cancel_work(smc);
		if (sk->sk_state != SMC_PEERABORTWAIT)
			break;
		sk->sk_state = SMC_CLOSED;
		sock_put(sk); /* (postponed) passive closing */
		break;
    ...
}

The early "if (sk->sk_state != SMC_PEERABORTWAIT) break;" exits also leave
the socket alive. The application keeps its fd until close().

SMC sockets are hashed only once, in smc_sk_init(), so they never go back
into the hash table.

smc_unhash_sk() also calls sock_prot_inuse_add(..., -1). The inuse count in
/proc/net/protocols then drops while the socket is still alive.

On SMC-R this doesn't seem to add any safety:
- smc_lgr_unregister_conn() clears alert_token_local
- the conn keeps its lgr and link references until smc_conn_free()
- the free inside smc_close_active_abort() now has its own unhash

The v6 changelog says the per-site placement "avoids prematurely hiding
live SMC_ACTIVE/APPCLOSEWAIT sockets from smcss". The commit message
describes this hunk only as an SMC-D dmb_nocopy reorder.

Would it be enough to move the unhash into the
smc_ism_support_dmb_nocopy() branch, right before smcd_buf_detach()?

>  	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>  	else
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..36a3b8f31f28d 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  
>  	r = nlmsg_data(nlh);
>  	smc_diag_msg_common_fill(r, sk);
> -	r->diag_state = sk->sk_state;
> +	r->diag_state = smp_load_acquire(&sk->sk_state);
>  	if (smc->use_fallback)
>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (r->diag_state != SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
> +		goto out;
> +

[Severity: Medium]
Do these two sk_state checks change the sock_diag uAPI output for sockets
whose connection is still live?

With the diag_mode change, every non-fallback SMC-D socket in SMC_INIT now
reports SMC_DIAG_MODE_SMCR. In include/uapi/linux/smc_diag.h, SMCR is 0
and SMCD has its own value, so there is no "unknown" value to fall back on.

SMC_INIT is not limited to the abort window:
- smc_connect_ism() and smc_connect_rdma() run smc_conn_create(),
  smc_buf_create(), smcd_buf_attach() and the whole CLC confirm exchange
  while in SMC_INIT
- on the server side the socket stays in SMC_INIT through
  smc_listen_work() until smc_listen_out_connected()

During these windows the lgr, alert_token_local and the buffers are all
valid, and the socket is hashed and visible to diag.

The new goto out also skips SMC_DIAG_CONNINFO, SMC_DIAG_LGRINFO and
SMC_DIAG_DMBINFO even when req->diag_ext asks for them. That bypasses the
existing alert_token_local, smc_conn_lgr_valid(), list_empty(&lgr->list)
and rmb_desc checks.

SMC_CLOSED doesn't mean the conn was freed either:
- smc_close_active() reached through shutdown(SHUT_RDWR) sets SMC_CLOSED in
  the APPCLOSEWAIT/APPFINCLOSEWAIT/PROCESSABORT cases without calling
  smc_conn_free()
- the SMC_ACTIVE branch of smc_close_active_abort() does the same
- smc_close_passive_work() frees the conn only when SOCK_DEAD is set or
  sk->sk_socket is NULL:

net/smc/smc_close.c:smc_close_passive_work() {
    ...
		if ((sk->sk_state == SMC_CLOSED) &&
		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
    ...
}

These sockets keep their conn until close(), but now report no extension
data.

The commit message says:

    As a side effect the diag_mode field is
    reported as SMC_DIAG_MODE_SMCR for SMC-D sockets still in SMC_INIT; smcss
    suppresses those rows before printing the mode string so there is no rendered
    regression.

That covers only one consumer, smcss. It also doesn't mention the dropped
extensions for live SMC_CLOSED sockets.

Is this change in uAPI output intended for sockets that still have a live
connection?

>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. Can
req->diag_ext be read past the end of the request payload here?

smc_diag_handler_dump() calls netlink_dump_start() without checking
nlmsg_len(h) against sizeof(struct smc_diag_req). The only length check
before that is in __sock_diag_cmd():

net/core/sock_diag.c:__sock_diag_cmd() {
    ...
	if (nlmsg_len(nlh) < sizeof(*req))
		return -EINVAL;
    ...
}

That checks only the 2-byte struct sock_diag_req, but diag_ext is at
payload offset 3.

An unprivileged user can send a SOCK_DIAG_BY_FAMILY/NLM_F_DUMP request with
nlmsg_len = NLMSG_HDRLEN + 2. This read then lands in uninitialized
tailroom of the request skb.

Whether CONNINFO, LGRINFO and DMBINFO appear in the reply would then reveal
bits of that byte, and KMSAN would report uninit-value.

inet_diag and unix_diag both check nlmsg_len against their full request
struct. Should smc_diag_handler_dump() return -EINVAL when
nlmsg_len(h) < sizeof(struct smc_diag_req)?

[ ... ]

> @@ -154,8 +158,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			.lnk[0].link_id = link->link_id,
>  		};
>  
> -		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
> -		       sizeof(link->smcibdev->ibdev->name));
> +		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));

[Severity: Low]
Can this report a stale RDMA device name after the device is renamed?

link->ibname is copied only once, when the link is initialized:

net/smc/smc_core.c:smcr_copy_dev_info_to_link() {
    ...
	snprintf(link->ibname, sizeof(link->ibname), "%s",
		 smcibdev->ibdev->name);
    ...
}

ib_device_rename() updates ibdev->name and notifies clients through their
->rename callback. smc_ib_client doesn't have one:

static struct ib_client smc_ib_client = {
	.name	= "smc_ib",
	.add	= smc_ib_add_dev,
	.remove = smc_ib_remove_dev,
};

If the device is renamed (for example with "rdma dev set ... name ...")
while an SMC-R link is up, SMC_DIAG_LGRINFO would show the old name. The
SMC device dump in smc_nl_handle_smcr_dev() would show the current
ibdev->name. Before this patch, smc_diag reported the current name.

The SMC genl link dump (smc_nl_fill_lgr_link()) and the tracepoints already
use the cached name, so this follows an existing convention that goes stale
in the same way.

Would a full fix need a rename callback that refreshes link->ibname?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012080034.38770-1-mjambigi%40linux.ibm.com
