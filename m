Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0641F94F;
	Sat, 10 Oct 2026 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791597695; cv=none; b=AjmgvN7J6NASYXAbX0e8bUpaXopVvSPNlDWYhPzsSfn8eWn/CXTjJNz6t0VooLUlh1J46hdkUFnh/hlRVV9gb2D5gkJgvktMppeL4XLYbbXU9sAeq4P1sSTs5ahST8Z0kxyw3Fr6zHd9lJa/AxRn+u2E489Y3Fk6cOGT6qFqk44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791597695; c=relaxed/simple;
	bh=DLBa0K1vHAxtwkOYYKWvmMwhCtZudRLnRf10Q+jOC4E=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FYsWqYDDCgfvCeIWIZWh3dJS9e9B/K61QY6bbdpbY5dOKXLb2RtzhrR8fV4sc2gLYUEPTLYcFGWiFI21/4xaUHzaz9m52fTfs2LoYbzAb/Mamvb/68H8EkrAaAZGcGgwQAJVWWzcDyxz/UPjiWc/+IAjfg8m6qqjl76wKtQMFcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmjDvIau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmjDvIau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C781F000FF;
	Sat, 10 Oct 2026 02:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791597694;
	bh=ne0o7MT5kAKKtWGZv5U4QSpHDlR8HOjUJP7Fk1RxxK0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LmjDvIau3piq8g4QRjd1ptT83TE0H2cSTnF0LYw9vK3aOHB4fnS7bOoZ41/LTuZG2
	 udNWPuAotNgVVdDFIynjyTWDvum91YANqG/QswJL4aj1GPo32j9qVFvqyxYpuaujWl
	 Yrux2o93OdOSIGF6ArGQLOwy/1awXT6cWrksnKr9XWXlC/HrwV7PTuiJs5X5zFryud
	 840WqadNrkYCuUzGtWs/csLzcgvyy6c85yNZYQyviRtmiPZuWILSsK8yMgsjFbz/oN
	 QK0KszI5o8jKuenGvfZSVsYd2m7TKgV4WTqYIt0xUdGNRIjGOItuKV9ZJ+zfY6FqNd
	 hPEKIf+IXCwRQ==
Subject: Re: [PATCH net v2] net/rds: ib: drop fragments shorter than the
 header-declared length
From: netdev-bot+sashiko@kernel.org
To: shubham@octane.security
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, achender@kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-kernel@vger.kernel.org, gio@octane.security,
 tjdqudcks0424@naver.com
Date: Sat, 10 Oct 2026 02:01:33 +0000
Message-ID: <179159769310.434549.3983712650254492426@kernel.org>
In-Reply-To: <20261007062135.49946-1-shubham@octane.security>
References: <20261007062135.49946-1-shubham@octane.security>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch is incomplete.

--

net/rds: ib: drop fragments shorter than the header-declared length

This patch adds a check to rds_ib_process_recv(). A fragment is rejected
when the payload length from the receive completion (data_len) is smaller
than the amount the fragment is accounted to contribute,
min(i_recv_data_rem, RDS_FRAG_SIZE). The goal is to stop
rds_ib_inc_copy_to_user() from copying uninitialized fragment page
contents to userspace.

Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@naver.com/

> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..fee77b6d7ffb2 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connection *conn,
>  		}
>  	}
>  
> +	/* h_len must be backed by the payload actually received (data_len),
> +	 * else the unwritten frag-page tail is copied to userspace.
> +	 */
> +	if (data_len < min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {

[Severity: High]
Is data_len always the number of bytes written into the fragment page?
The commit message says:

  "The number of payload bytes actually received into the fragment page is
  data_len (after subtracting the header)"

rds_ib_recv_cqe_handler() checks only the completion status. It never
checks wc->opcode:

net/rds/ib_recv.c:rds_ib_recv_cqe_handler() {
    ...
	if (wc->status == IB_WC_SUCCESS) {
		rds_ib_process_recv(conn, recv, wc->byte_len, state);
    ...
}

An RDMA WRITE-with-immediate from the peer uses up a posted receive WR and
completes as IB_WC_RECV_RDMA_WITH_IMM. Its payload goes to the MR named by
the rkey, so nothing is written to the WR's header SGE or fragment SGE.
rxe still reports byte_len as the remote write length for this opcode:

drivers/infiniband/sw/rxe/rxe_resp.c:do_complete() {
    ...
	wc->byte_len = (pkt->mask & RXE_IMMDT_MASK &&
				pkt->mask & RXE_WRITE_MASK) ?
					qp->resp.length : wqe->dma.length - wqe->dma.resid;
    ...
}

RDS RC QPs get IB_ACCESS_REMOTE_WRITE through cm_init_qp_init_attr().
RDS MRs are registered with remote write access in the shared PD, so a
peer can get a writable rkey through the normal RDMA cookie exchange.

If the peer sends a WRITE_WITH_IMM of at least sizeof(struct rds_header)
+ RDS_FRAG_SIZE bytes, it looks like this happens:

  - The slot's i_recv_hdrs[] entry still holds the header from that
    slot's last use. That header has a valid checksum.

  - If no message is being reassembled, the old header starts a new
    message with its old h_len.

  - If a message is being reassembled, the old header can also pass the
    h_sequence, h_len and port mismatch checks.

  - data_len is large, so the new min_t() check passes.

  - The fragment page was never written. It is linked onto ii_frags
    anyway.

The page comes from the frag cache or rds_page_remainder_alloc() and is
not zeroed. rds_ib_inc_copy_to_user() would then copy up to h_len bytes
of it, which could include earlier RDS payloads meant for other sockets:

net/rds/ib_recv.c:rds_ib_inc_copy_to_user() {
    ...
		ret = copy_page_to_iter(sg_page(&frag->f_sg),
					frag->f_sg.offset + frag_off,
					to_copy,
					to);
    ...
}

Should completions with wc->opcode != IB_WC_RECV be rejected before
byte_len is trusted as the received length? The disclosure this patch
targets seems to remain reachable through this path.

> +		rds_ib_conn_error(conn,
> +			"fragment shorter than header-declared length; forcing reconnect\n");
> +		goto done;
> +	}
> +
>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag = NULL;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007062135.49946-1-shubham%40octane.security
