Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58592236EB;
	Mon, 12 Oct 2026 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811776; cv=none; b=tMVL4dnwOahsTDCua7kIRCtPuN9ZHUO0QnsBtj2V8I+gRTBaTRYY9fAQxxHlb/ZgcVS6xDfQVT9e/Zv1OXQdG9hklA6icH/Yb1lFWYBSjYTM3xECLTWiT6xHZ/c4xniSIsraC07zx4FbPKa7dpTPlBhNtccQDjJ0kijsrdFrFzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811776; c=relaxed/simple;
	bh=1/h8OGci7sib4x6nRXRpLYPTLvff9hRPycVbbE11w10=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EndohHbj9pNFW9ihhbB5hwwfY6fRIfvMGbcQi7+ZB1JZNhtesudqvc7zbrfXNB94fWFNVjrwy8/dqKNxHFG+0Sg4OOjFmcMo3jC7nE5kOMoIIWvTnM3m6Z1qs6I0pPS5rhGiQXoW/PCsFotxUgPoXdLZHondkFjYNTruZJQ0DbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3rJo9mF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3rJo9mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA4A1F0089B;
	Mon, 12 Oct 2026 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811775;
	bh=Qt71Wpe5vZz/eJo/NTKl4S8jSBeNz9JRB3NW9TiAP+Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=P3rJo9mFl5uX74K17iAzES6Zh2fPEWw9qO3gf5/8cWp9MOsdEz+NTkndRuUKl+t+c
	 KIcZT0heGNIsx6tsIMrp+iApc7TRZhqXhTHCYzlfM5o50ETlVCcV8mW6eNAxvSN2A5
	 3+zmYEJB/R8wTQ2v3gkji3eBPzdwMtQpLmKEhw71k3EH6gNn2bWu4b4upI0JZZRu5h
	 GUfRzaVMdKjTt6X6Zu8AO7h2uxOHI9w9uzINRrjLXOIOYP8oubO+gVnZsRrWvSvQF2
	 q2X2yjUWcKRnpsoGiO5kBgsPfVOGk1PyEM4SSN7+WbMRD5Vm+FLl9V/HU3TbqcJKN2
	 FYrjLoPnICjHA==
Subject: Re: [PATCH net v3] net/rds: ib: zero the unwritten tail of a short
 receive fragment
From: netdev-bot+sashiko@kernel.org
To: shubham@octane.security
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, achender@kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-kernel@vger.kernel.org, gio@octane.security,
 tjdqudcks0424@naver.com
Date: Mon, 12 Oct 2026 13:29:34 +0000
Message-ID: <179181177407.434549.13953919662725859235@kernel.org>
In-Reply-To: <20261008124940.13371-1-shubham@octane.security>
References: <20261008124940.13371-1-shubham@octane.security>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch closes the info leak, but its v3 approach rests on a
  false premise, and the commit message leaves out what the new memset…

--

net/rds: ib: zero the unwritten tail of a short receive fragment

This patch zeroes the unwritten tail of an RDS/IB receive fragment page in
rds_ib_process_recv() when the received payload is shorter than
RDS_FRAG_SIZE. The goal is to stop rds_ib_inc_copy_to_user() from copying
stale page contents to userspace when a peer sends a fragment shorter than
its h_len implies.

Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@naver.com/

> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..9695c7f24eaa7 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c

[ ... ]

> @@ -949,6 +950,19 @@ static void rds_ib_process_recv(struct rds_connection *conn,
>  		}
>  	}
>  
> +	/* The device wrote only data_len bytes into this recycled fragment
> +	 * page.  Zero the unwritten tail so a later rds_ib_inc_copy_to_user(),
> +	 * which copies up to the peer-declared h_len, cannot hand stale page
> +	 * contents to userspace.
> +	 */
> +	if (data_len < RDS_FRAG_SIZE) {
> +		void *frag = kmap_local_page(sg_page(&recv->r_frag->f_sg));
> +
> +		memset(frag + recv->r_frag->f_sg.offset + data_len, 0,
> +		       RDS_FRAG_SIZE - data_len);
> +		kunmap_local(frag);
> +	}

[Severity: Medium]
Isn't this condition true for the final fragment of almost every well-formed
message? A message whose h_len is not a multiple of RDS_FRAG_SIZE always
ends with a short fragment. So a 100 byte message now pays for a kmap and a
memset of roughly 4KB in the receive completion path.

For well-formed traffic that work doesn't look necessary, because
rds_ib_inc_copy_to_user() already stops at h_len:

net/rds/ib_recv.c:rds_ib_inc_copy_to_user() {
    ...
		to_copy = min_t(unsigned long, to_copy, len - copied);
    ...
}

The stale tail can only be reached when a peer sends a short non-final
fragment, meaning data_len < min(RDS_FRAG_SIZE, ic->i_recv_data_rem).

The v3 changelog gives this reason for dropping the v2 length check:

  A zero-copy send with a small iovec segment can legitimately produce a
  non-final fragment shorter than RDS_FRAG_SIZE

Can that happen on RDS/IB? rds_sendmsg() rejects zero-copy on every
transport except TCP:

net/rds/send.c:rds_sendmsg() {
    ...
	if (zcopy) {
		if (rs->rs_transport->t_type != RDS_TRANS_TCP) {
			ret = -EOPNOTSUPP;
			goto out;
		}
    ...
}

On the copy path, rds_message_copy_from_user() gets its sg entries from
rds_page_remainder_alloc(). Every entry it returns is a full PAGE_SIZE
except the last one. rds_ib_xmit() then splits each entry with:

	len = min(RDS_FRAG_SIZE, sg_dma_len(scat) - rm->data.op_dmaoff);

That means only the last fragment of a message should ever be short.

Would it be better to bound the memset by
min(RDS_FRAG_SIZE, ic->i_recv_data_rem), which is already set at this
point? Rejecting that case as v2 did is another option. Either one should
still close the leak and leave well-formed traffic alone.

As written, a peer that sends short non-final fragments also gets its
message passed to the application with zero-filled holes, as if it were
valid.

The commit message also says:

  Fragments that fill the page are unaffected.

In the common small-message case the final fragment doesn't fill the page.
Could the changelog say that the memset runs on most messages?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008124940.13371-1-shubham%40octane.security
