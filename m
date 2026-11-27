Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750838;
	b=hafrZBCjRMM8Yzd6a2w7JH0mv/unIMK45QqHKdPPJr8S743xYLohOcT3MYMYFMe8OalC
	 JsZyYq324c6DUr7NCpLxUFQ8IhtZSB23uFclvrGFyWBU8sXNA/B9WvEzKZ2kgYF2iSwCx
	 H31QQ/TqpofUk5vjplSZpwjN13ASJYafDAk9pvJ65pBNHU+o1NnODvsRdDwICPa7nVYwD
	 yFx06VoL5u+uEE42ihHXGdInA4LSAOzUolijXzc9FTI+d+JRPAZ7yX9JgyQbwTb8YkuuL
	 xBeedSQKelmNoDT7taonWgZYgRvfTEQi1Awi844GCOmXCKFHg3QftnU4eqVRL5xLaJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750838;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=8/qQkcae65QKdmEUw9cyp/yjiIcf3CtxelHf3pV2GhU=;
	b=0tKnfwuLQ7dFai20c905L4wz2G7zyogdGDyh67SY7ZZH8JjTbGc0AMMV7fos5FnHH+r1
	 8vbIFKxc/wHX4ZKz6/ygkn0O0JCbt8kpg76/OW+TQmyV36dUBnPIdsLIR2r2gS8bsEi7u
	 eud9ox6WV3OBBYXL2rIdNTTR8R1NycpMw9DR51xztahzONW2MzSOii6epRiUPwhGJ9LtS
	 DD/DsxIA8mjPId7HsOJgqXWZKXla9hrgcI0S3e5Ts3MHgZ4VLzSG6WhYz0Ukre1fQBNiD
	 iGyFWofYLdKkM9kWoH5JEDe4pYTlta9/bEJUXQhelz4sid/yYEVF6T8Ef23o1BEGh8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orESze8m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF35606A31C;
	Fri, 27 Nov 2026 03:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orESze8m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD3C1F000C1;
	Fri, 27 Nov 2026 03:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795750838;
	bh=8/qQkcae65QKdmEUw9cyp/yjiIcf3CtxelHf3pV2GhU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=orESze8mqEofav3l7R19Sv4/btDUWEWOypOTmQ/g2jKWZTVlzbKqlVvY9p68bJUCH
	 RFZiUo8W8e4EPJ0siaXMvKlk7fKpP2+blPFQALlcAuzsY2VZm/3GC4QsC7zR29wgDb
	 DFViYlToNj0AbaMEBfBaJx9OW6lQV2KkdSjlStec4dNQEqqeoIwo+zVOjm5NmbvcbM
	 +BdMSu/NM6eKUpSC1qaYe9edZ0ehtjmaaR9TbXb9Dki53KjjBRJ44DgrY9M/tO4V0k
	 2CxkfaSTTsGR1T7SRwvavnSlgv8UGnvapbcCyMuZ11o40FonaKgbRqx5jy0OoStY3W
	 /cYlBPncFO79g==
Subject: Re: [PATCH net v2] net/rds: tcp: bound the message length announced
 by the peer
From: netdev-bot+sashiko@kernel.org
To: weidongw@illinois.edu
Cc: achender@kernel.org, andy.grover@oracle.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, zijie4@illinois.edu
Date: Fri, 27 Nov 2026 03:40:37 +0000
Message-ID: <179575083740.3135.167711549334185146@kernel.org>
In-Reply-To: <20261125-h047-send-v2-1-b29031cf6b93@illinois.edu>
References: <20261125-h047-send-v2-1-b29031cf6b93@illinois.edu>
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

- [High] The new check in rds_tcp_data_recv() (net/rds/tcp_recv.c:219-220
  and 230-234) limits the number of payload bytes a peer can announce…

--

net/rds: tcp: bound the message length announced by the peer

This patch limits the h_len announced in an incoming RDS/TCP header to
RDS_MAX_MSG_SIZE in rds_tcp_data_recv(). If a header is larger, the
connection is dropped. The rest of the stream is then consumed and
discarded until shutdown, so the receive queue keeps draining.

> diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
> index ffe843ca219c7..4ca25b9d25d40 100644
> --- a/net/rds/tcp_recv.c
> +++ b/net/rds/tcp_recv.c
> @@ -210,9 +210,29 @@ static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
>  					be32_to_cpu(tinc->ti_inc.i_hdr.h_len);
>  				tinc->ti_inc.i_rx_lat_trace[RDS_MSG_RX_START] =
>  					local_clock();
> +				/*
> +				 * The payload is queued on tinc until the
> +				 * whole message has arrived, so a peer must
> +				 * not announce more than a sender is allowed
> +				 * to send.
> +				 */
> +				if (tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE)
> +					rds_conn_path_drop(cp, false);

[Severity: High]

Does this check bound the memory held for a partially received message,
or only the announced length?

A peer can announce h_len = RDS_MAX_MSG_SIZE, which passes this check.
It can then send the payload as roughly one million 1-byte segments.
Each segment goes through:

rds_tcp_data_ready()
  rds_tcp_read_sock(cp, GFP_ATOMIC)
    tcp_read_sock()
      rds_tcp_data_recv()
        pskb_extract()

Each one ends up as its own clone on tinc->ti_skb_list, further down in
rds_tcp_data_recv():

	clone = pskb_extract(skb, offset, to_copy, arg->gfp);
	...
	skb_queue_tail(&tinc->ti_skb_list, clone);

pskb_extract() calls skb_clone(). The clone has no sk and no destructor,
so nothing is charged to the socket.

It then calls pskb_carve(). For linear data, pskb_carve_inside_header()
allocates a new head of skb_end_offset(skb) bytes with kmalloc_reserve().
For nonlinear data, pskb_carve_inside_nonlinear() also takes
skb_frag_ref() on the rx page frags. Either way, the allocation does not
depend on how few bytes are extracted.

rds_tcp_data_ready() drains sk_receive_queue on every data_ready. That
means tcp_try_coalesce() never has a tail skb to merge small segments
into, so every segment becomes a separate clone.

Wouldn't that leave on the order of 1M uncharged clones per connection
path? Each has an sk_buff plus a new head or pinned page, so the total
is roughly 1 GiB or more, and the receive window stays open.

rds_recv_incoming() later charges only h_len to rs_rcv_bytes, so the
actual truesize is never accounted.

The commit message describes the problem as the receiver holding large
amounts of memory that is not charged to the socket. To close that
fully, could this bound the total truesize on ti_skb_list, or copy or
coalesce small chunks, rather than only check h_len?

>  			}
>  		}
>  
> +		/*
> +		 * After an oversized header the connection is being dropped:
> +		 * consume and discard the rest of the stream until it is shut
> +		 * down, so that the receive queue drains and the shutdown is
> +		 * not held up.
> +		 */
> +		if (!tc->t_tinc_hdr_rem &&
> +		    tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE) {
> +			left = 0;
> +			break;
> +		}
> +
>  		if (left && tc->t_tinc_data_rem) {
>  			to_copy = min(tc->t_tinc_data_rem, left);
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261125-h047-send-v2-1-b29031cf6b93%40illinois.edu
