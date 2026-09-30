Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114EC1E5B9A;
	Wed, 30 Sep 2026 00:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790729319; cv=none; b=fFzp4tsn5xXIMhYrOMhhrHZRFO9D+DwH2tXdoZJOnovAOOT0KTROeOknaqfmXcicEVr42pmKrUhPDxJ9aMSdbcGlRkD3Y2kO+kQeQWhfIk+TP2U3nB/9zMCfcFxEN+SbUm6/Zoas5B7P6/EKCgZBU+Fc99NKmmZTJpxgC0pPG0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790729319; c=relaxed/simple;
	bh=FAIbWjNgOEEW51IRoG3Dlk7MDao9AQrbvRGcHNnHUnk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WKCDgHLpcwo/srCa7qKKILQfb5IpJQnMPqlHcfwCm2J2i/6rgN9//hdun+qqTZSbDg6tIhcmquGNyb8UgI2E+J3xuyMfgZoYjpxAIAiTH8jPulPclEnDyTrBD0fms1GUVQYfBLDHWRVLwuK0tpHtq7+qHQm59XxexQ+VL/4xW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKckmLp1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKckmLp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898F31F000FF;
	Wed, 30 Sep 2026 00:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790729317;
	bh=B8soeY3Fq26kTRlz/CSkMV/3dgJ9Nb9lV4kRGp3NdKQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bKckmLp1pl/p16Cujn/4l2w9tfjiX1W0r339jA8m1b7vuqm3rY9gzbQzLcfqd2hmS
	 CZMSE2OsUIWUhKBZUTnBN+S7qE8iVyGUdbsg0h0mHSpzZTzDT0OHg0nRBudXsx7vl8
	 KGnAsn65rxwVKxfcEuQuCS7m9d3RcIR2Smsmsmtwz2aY56EBQOjnMudAKNiNoqeRCt
	 Ywq8lBJxgHlyyKIuYOw4MRXxYvsnH/VGJk5jeYcY3D5eo2NGDwcC2M5rhGHEbJuLyF
	 ciu/Bi0NavNCKkeaXU/OgXZOE/eF+ba7zg91//lW2D1c5P67ROJuVlTpjoHQFZFFb8
	 GI1sjUWpjtYtw==
Subject: Re: [PATCH net] net/smc: Serialize CLC preparation with link teardown
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, kgraul@linux.ibm.com,
 ubraun@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 30 Sep 2026 00:48:36 +0000
Message-ID: <179072931609.434549.973981787075835588@kernel.org>
In-Reply-To: <20260927074600.3694802-1-nicoyip.dev@gmail.com>
References: <20260927074600.3694802-1-nicoyip.dev@gmail.com>
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

Critical: 0 · High: 0 · Medium: 2 (2) · Low: 1 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When smc_clc_send_confirm_accept() (net/smc/smc_clc.c) finds
  that conn->lnk is unusable or being cleared under llc_conf_mutex, it…
- [Medium] smc_clc_send_confirm() (net/smc/smc_clc.c) now does
  `smc->sk.sk_err = smc->clcsock->sk->sk_err ?: -len; reason_code =…
- [Low] The `sk_err ?: -len` changes in smc_clc_send_confirm() and
  smc_clc_send_accept() (net/smc/smc_clc.c) do more than keep the new…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but it concerns
  the locking contract the fix relies on.
- [Medium] This problem wasn't introduced by this patch, but the patch
  makes the CLC send helpers inconsistent.
- [Low] This problem wasn't introduced by this patch (it dates from
  2020).

--

net/smc: Serialize CLC preparation with link teardown

This commit makes smc_clc_send_confirm_accept() hold llc_conf_mutex for
reading while it prepares the SMC-R CONFIRM/ACCEPT message. If the link
is unusable or being cleared, it returns -ENOLINK. It also changes
smc_clc_send_confirm() and smc_clc_send_accept() to use the
kernel_sendmsg() return value when the TCP socket has no sk_err set.

> diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
> index 014d527d5462d..6b9e64a5b9d0a 100644
> --- a/net/smc/smc_clc.c
> +++ b/net/smc/smc_clc.c
> @@ -1169,14 +1169,21 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
>  	clc->hdr.version = version;	/* SMC version */
>  	if (first_contact)
>  		clc->hdr.typev2 |= SMC_FIRST_CONTACT_MASK;
> -	if (conn->lgr->is_smcd)
> +	if (conn->lgr->is_smcd) {
>  		smcd_clc_prep_confirm_accept(conn, clc, first_contact,
>  					     version, eid, ini, &fce_len,
>  					     &fce_v2x, &trl);
> -	else
> +	} else {
> +		down_read(&conn->lgr->llc_conf_mutex);
> +		if (!smc_link_usable(conn->lnk) || conn->lnk->clearing) {
> +			up_read(&conn->lgr->llc_conf_mutex);
> +			return -ENOLINK;

[Severity: Medium]
Should this return a positive CLC decline code instead of -ENOLINK?

Both handshake paths read a negative reason code as "fallback is not
possible". On the client, smc_clc_send_confirm() returns -ENOLINK,
smc_connect_rdma() jumps to connect_abort, and then
smc_connect_decline_fallback() does:

net/smc/af_smc.c:smc_connect_decline_fallback() {
    ...
	if (reason_code < 0) { /* error, fallback is not possible */
    ...
}

As a result, connect() fails with ENOLINK.

On the server, smc_listen_work()->smc_listen_decline() does:

	if (reason_code < 0 ||
	    smc_switch_to_fallback(new_smc, reason_code)) {
		/* error, no fallback possible */
		smc_listen_out_err(new_smc);

and the accepted connection is torn down.

Other SMC-R link and buffer failures at the same stage return positive
decline codes, send a DECLINE and fall back to TCP. Examples in
smc_connect_rdma() are SMC_CLC_DECL_ERR_RDYLNK and
SMC_CLC_DECL_ERR_REGBUF. Neither CONFIRM nor ACCEPT has been sent yet,
so a DECLINE is still valid here.

A matching code already exists and smcr_lgr_conn_assign_link() uses
it:

#define SMC_CLC_DECL_NOACTLINK	0x030a0000  /* no active smc-r link in lgr    */

In multi-link groups, smc_switch_conns() skips SMC_INIT connections. A
connection that is still handshaking therefore keeps the dying link
even when another link is available.

Could SMC_CLC_DECL_NOACTLINK be reported here so the connection falls
back to TCP? The callers of smc_clc_send_confirm_accept() treat positive
return values as byte counts, so the wrappers would need a small
restructure to pass it through.

The commit message also doesn't mention that this case now fails
instead of falling back to TCP.

> +		}
>  		smcr_clc_prep_confirm_accept(conn, clc, first_contact,
>  					     version, eid, ini, &fce_len,
>  					     &fce_v2x, &gle, &trl);
> +		up_read(&conn->lgr->llc_conf_mutex);
> +	}

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch, but it
affects the locking contract this down_read() relies on.
smcr_link_clear() is documented as:

/* must be called under lgr->llc_conf_mutex lock */

smcr_clnt_conf_first_link() in af_smc.c calls smc_llc_cli_add_link()
without taking llc_conf_mutex:

		smc_llc_flow_qentry_clr(&link->lgr->llc_flow_lcl);
		smc_llc_cli_add_link(link, qentry);

smc_llc_cli_add_link() calls smcr_link_init() and
smcr_buf_map_lgr(lnk_new). On its out_clear_lnk error path it also
calls smcr_link_clear(lnk_new).

The other callers take the write side. smc_llc_process_cli_add_link()
wraps the same function in down_write(), and smcr_serv_conf_first_link()
and smc_llc_process_srv_add_link() do the same around
smc_llc_srv_add_link().

The new reader here doesn't seem able to see the cleared lnk_new. That
slot isn't any connection's conn->lnk, and smc_client_lgr_pending
serializes other client connections on this link group.

Should smcr_clnt_conf_first_link() still hold llc_conf_mutex for
writing around smc_llc_cli_add_link()? The new down_read() assumes
that all link setup and teardown runs under the write side.

>  	memset(&msg, 0, sizeof(msg));
>  	i = 0;
>  	vec[i].iov_base = clc;

[Severity: Low]
This isn't a bug introduced by this patch (it dates from 2020), but
further down, smc_clc_send_confirm_accept() builds up to five kvecs
(header, fce_v2x, gle, gid list, trailer) and then sends them with num
set to 1:

	return kernel_sendmsg(smc->clcsock, &msg, vec, 1,
			      ntohs(clc->hdr.length));

kernel_sendmsg() passes num to iov_iter_kvec() as nr_segs. This only
works because iterate_kvec() walks the segments by remaining length
rather than by nr_segs. Afterwards, iter->nr_segs underflows:

	iter->nr_segs -= p - iter->kvec;

Should this pass i instead of 1?

[ ... ]

> @@ -1227,7 +1234,7 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
>  			reason_code = -ENETUNREACH;
>  			smc->sk.sk_err = -reason_code;
>  		} else {
> -			smc->sk.sk_err = smc->clcsock->sk->sk_err;
> +			smc->sk.sk_err = smc->clcsock->sk->sk_err ?: -len;
>  			reason_code = -smc->sk.sk_err;

[Severity: Medium]
Can this copy -ERESTARTSYS into sk_err and into the connect() return
value?

On a blocking connect(), __smc_connect() runs in the caller's context,
and the clcsock sndtimeo defaults to MAX_SCHEDULE_TIMEOUT. Suppose
tcp_sendmsg_locked() waits in sk_stream_wait_memory(), for example
under TCP memory pressure, while a signal is pending. It then returns
sock_intr_errno(MAX_SCHEDULE_TIMEOUT), which is -ERESTARTSYS.

With this change, smc->sk.sk_err is set to 512, which
getsockopt(SO_ERROR) can expose. smc_connect() also returns
-ERESTARTSYS, so the syscall may be restarted, for example after
SIGSTOP/SIGCONT or with an SA_RESTART handler.

smc_connect_decline_fallback() leaves sk_state at SMC_INIT and
sock->state at SS_CONNECTING. On restart, kernel_connect() on the
already connected clcsock returns -EISCONN. The application may read
that as success, even though the SMC connection was aborted.

The receive side in smc_clc_wait_msg() handles this case explicitly:

	if (signal_pending(current)) {
		reason_code = -EINTR;
		clc_sk->sk_err = EINTR;
		smc->sk.sk_err = EINTR;

Should the send side map signal errors to EINTR the same way? Before
this patch the same case was reported as success, so the change helps,
but the errno exposed here looks wrong.

[Severity: Medium]
This is a pre-existing issue, but after this change the CLC send
helpers handle the same error differently. smc_clc_send_proposal()
still does:

	len = kernel_sendmsg(smc->clcsock, &msg, vec, i, plen);
	if (len < 0) {
		smc->sk.sk_err = smc->clcsock->sk->sk_err;
		reason_code = -smc->sk.sk_err;

sk_err can be 0 here: after sk_stream_error()->sock_error() clears it
on EPIPE, or when the send fails with -EAGAIN, -EINTR or -ENOMEM. In
that case this returns 0 even though the send failed. The client then
waits in smc_clc_wait_msg() and is likely to hit an error or EOF there.

Should smc_clc_send_proposal() use the same sk_err ?: -len fallback?

>  		}
>  	}
> @@ -1246,7 +1253,8 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
>  	len = smc_clc_send_confirm_accept(new_smc, &aclc, srv_first_contact,
>  					  version, negotiated_eid, ini);
>  	if (len < ntohs(aclc.hdr.length))
> -		len = len >= 0 ? -EPROTO : -new_smc->clcsock->sk->sk_err;
> +		len = len >= 0 ? -EPROTO :
> +			-(new_smc->clcsock->sk->sk_err ?: -len);
>  
>  	return len > 0 ? 0 : len;
>  }

[Severity: Low]
The commit message describes these two hunks as:

    Preserve the preparation error in both CLC send wrappers when the TCP
    socket has no error recorded. Otherwise the new -ENOLINK return is
    converted to success.

Is that the whole effect? The change also covers every failed
kernel_sendmsg() where clcsock->sk->sk_err is 0.

That case is common. When tcp_sendmsg_locked() fails with EPIPE,
sk_stream_error() calls sock_error(), which clears sk_err. Timeouts and
signals (-EAGAIN, -EINTR, -ERESTARTSYS) also leave sk_err at 0.

Before this patch, those failures became reason_code 0 in
smc_clc_send_confirm() and a return value of 0 in smc_clc_send_accept(),
which callers treat as success.

Could the commit message say that ordinary TCP send failures during
CONFIRM/ACCEPT are no longer reported as success?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927074600.3694802-1-nicoyip.dev%40gmail.com
