Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794775163;
	b=oamEbQDWxSImzWD+yPpcU4OsggrjV3VhB4OmW97PQgPtyxyBugcGAcWlbFUfeXsoS+oO
	 RNF2acXrJsjbRdqSzrwm+mXB0g9T9EKZ0fIFd76Uqxf5W/+txfDbuqZRbQr9BBrZlVQlz
	 fNiKJuhBqQrATDPlNdolMFXyMIqUBC5XBkae0n5wZX10V6mSFwzfYz0yKE4+W5WaaTusM
	 ReWgavVN9+3qxuuAnefq3rVFLfWx13MfWbUj+JT+sWhvYmmKYDSWc/UWwEbDcU8rVpBwW
	 unQrogIcKbzT6gWeSno690B5gv2hVU3SOO2bbIQapc5jftjE876u941CDB/DSAncn8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794775163;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=aGe6G0xKdhfQY0JtnV5P5L35DOTPKkJKnFisezZeybM=;
	b=Xd6ouLz6MZb/Ln1l+SM68QG7T4UfW9Ip7oBilsGiIbBJSzboMpKQO4MqXHBij527WszM
	 ZK3pbBDcmbvuyVDpNMaYILualCojltFlvnqJT1NqXp0buoC3BwLkZftpqLBvTcAWzZrAN
	 F2bPdU+jQSUjgFf2LfoSrdxIxpHnmyifq+6/QKFBJXxxzizJND8r6/zwzjLS+uNq83kG6
	 xOlE/9o5RMX87WeHy4FXv58qSJH+u9zasCSJByc+fNWIReK9S5VJuM72TyI8EE2jHoSDE
	 noroy9blJdxG+X3/1tw9UTsoKQNqizPhp8NFAXhsYbuk4L2cgnPM6gwzN7rnDJjpNcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6f9qJgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CACD606A323;
	Sun, 15 Nov 2026 20:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6f9qJgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264021F000C4;
	Sun, 15 Nov 2026 20:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775162;
	bh=aGe6G0xKdhfQY0JtnV5P5L35DOTPKkJKnFisezZeybM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=B6f9qJgm/CcFJIUl3lq6ZZARB7LEAnB7sbDNpc641VS6e5nH21oGU+oXBr6lonRZ6
	 Y1XvCOS0ETx7UkID+yiB2Xl1n7s8td0+tzETfSNtS3SqFxez+jnaxtBWJfGIvn7SD3
	 A50zMMmq3fvwebmJMLmc9ZHmjipqN+jFePnTlUfbgfp8bF+bMaQmiVqvx3ujgD1To0
	 XbcXAQCmqc4N3eiIUcN07T0QMkXjAJt0bpAuZufZX/TNXLt53/q4rGNgXIQQoci1F+
	 IQ+3zE3L0uWcylFggbjMx8xtz0eOQzBUlbnrNViW7pvgEzHRcMNzjFDMF6LPtxjrqJ
	 wnOjcskm8UV3Q==
Subject:
 Re: [PATCH net] net/rds: tcp: bound the message length announced by the peer
From: netdev-bot+sashiko@kernel.org
To: weidongw@illinois.edu
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, zijie4@illinois.edu
Date: Sun, 15 Nov 2026 20:39:21 +0000
Message-ID: <179477516170.3136.3481236029450144068@kernel.org>
In-Reply-To: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
References: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] After the new check in rds_tcp_data_recv() fires, the receive
  path stops consuming data altogether, and this breaks the drain loop…

Pre-existing issues:
- [High] The patch does not cover the RDS IB/RDMA receive path, which has
  the same flaw it fixes for TCP: the peer-announced h_len is never…

--

net/rds: tcp: bound the message length announced by the peer

This patch adds a check to rds_tcp_data_recv(). Once the header is
complete, the h_len announced by the peer is compared against
RDS_MAX_MSG_SIZE. If it is larger, the connection path is dropped and the
receive actor returns with -EPROTO.

> diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
> index ffe843ca219c7..29db73df84fa3 100644
> --- a/net/rds/tcp_recv.c
> +++ b/net/rds/tcp_recv.c
> @@ -213,6 +213,20 @@ static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
>  			}
>  		}
>  
> +		/*
> +		 * The payload is queued on tinc until the whole message has
> +		 * arrived, so a peer must not announce more than a sender is
> +		 * allowed to send. Check on every pass, not only when the
> +		 * header completes: the drop is asynchronous and more data
> +		 * can arrive before the connection is shut down.
> +		 */
> +		if (!tc->t_tinc_hdr_rem &&
> +		    tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE) {
> +			rds_conn_path_drop(cp, false);
> +			desc->error = -EPROTO;
> +			goto out;
> +		}

[Severity: Medium]
After this check fires, tc->t_tinc is still set, with t_tinc_hdr_rem == 0
and t_tinc_data_rem > RDS_MAX_MSG_SIZE. Won't every later call into
rds_tcp_data_recv() hit the same check straight away and return 0 without
consuming anything?

__tcp_read_sock() stops on a 0 return:

    used = recv_actor(desc, skb, offset, len);
    if (used <= 0) {
        if (!copied)
            copied = used;
        break;
    }

So any payload after the oversized header stays on sk_receive_queue.

The drain loop in rds_tcp_conn_path_shutdown() only exits early when that
queue is empty:

    rds_tcp_recv_path(cp);
    } while (!wait_event_timeout(tc->t_recv_done_waitq,
            (sk->sk_state == TCP_CLOSING ||
             ...
             sk->sk_state == TCP_CLOSE) &&
            skb_queue_empty_lockless(&sk->sk_receive_queue),
            msecs_to_jiffies(100)) &&
         ++rounds < 50);

tc->t_tinc is only reset after this loop. Does that mean the loop now
always runs the full 50 x 100ms (about 5 seconds), even when the peer
answers our FIN promptly?

Each round goes through this chain and calls rds_conn_path_drop() again:

  rds_tcp_recv_path()->rds_tcp_read_sock()->tcp_read_sock()->rds_tcp_data_recv()

That call does atomic_set(&cp->cp_state, RDS_CONN_ERROR) while the path is
in RDS_CONN_DISCONNECTING, and it re-queues cp_down_w. The
DISCONNECTING->DOWN transition in rds_conn_shutdown() then fails and
returns early. Is a second full shutdown pass forced before the reconnect?

This holds up the path's ordered workqueue, or the shared rds_wq if
alloc_ordered_workqueue() failed, and it delays reconnect. It would also
apply to every reconnect cycle of the old-kernel peers that the changelog
says will now be dropped.

Would it work better to consume and discard the rest of the stream once
the protocol error is detected, by returning the full len without cloning?
The drain loop could then finish, and the drop would not be repeated.

[Severity: High]
This isn't a bug introduced by this patch, but the IB transport appears to
have the same unbounded h_len problem. In net/rds/ib_recv.c,
rds_ib_process_recv() does:

    memcpy(hdr, ihdr, sizeof(*hdr));
    ic->i_recv_data_rem = be32_to_cpu(hdr->h_len);

There is no RDS_MAX_MSG_SIZE check. Each fragment is then kept until
i_recv_data_rem reaches 0:

    list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);

Continuation fragments are only checked for a matching header and a
minimum length. rds_ib_refill_one_frag() allocates a replacement frag for
each one consumed, with no limit.

The rds_ib_sysctl_max_recv_allocation cap in rds_ib_refill_one_inc()
counts rds_ib_incoming structures. A single huge message uses only one of
those.

Can an IB/RoCE peer that sends h_len = 0xffffffff, followed by full-sized
fragments, make the receiver hold up to about 4 GiB per connection?

rds.h describes RDS_MAX_MSG_SIZE as the limit for "both RDMA and non-RDMA
RDS message". Should rds_ib_process_recv() get an equivalent check,
followed by rds_ib_conn_error()?

Since this is tagged for stable, would it also help for the changelog to
say that only the TCP receive path is bounded?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111-h047-send-v1-1-2727a38dbfcd%40illinois.edu
