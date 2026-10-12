Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEC73FCB32;
	Mon, 12 Oct 2026 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824082; cv=none; b=psD6EAwQZDja4+6F91QoDCe7qR/DN3HviFRlcJTF4apABduNqwSc+0nqe/nkrYpOa94PUZxyktmEACQ2gxYVK2tWjO14Q0qI9Ns/TjWLKpV9gdwCktrrapHDO1e7j/ptVZjMU7EuoGISGqjjQn882tqeKRjl/qPSMrP6kuWdb5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824082; c=relaxed/simple;
	bh=x9wz9JjXgx9QSm2ge9ebY1KM5lLelapl//gXR5hfebY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y93L9TnFdZqGVYwaD+Qt7LRYATirDgI6u8Vi0Y5kgWtIvSUW+k92XCTN3g+KxUQA9YTdtT25CDfAP2TryTSs9af8fUdaeUI8/YPZKrKIMMEJN/IgtcNH7g80+V9ajw1BInBoNn52XhsA1YDw1RCOQJDRFdI2XaWVRv8hzMSKOT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ixulb86s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ixulb86s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A0D1F0089B;
	Mon, 12 Oct 2026 16:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791824081;
	bh=/0LLAYE84Hs0+AqFqH67O/smM4bU/0+rUKWG9IN4Vlw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ixulb86sjXVmEsRylqbooEFUGLMovYrx8suPMVDK3bLwfyBXfGY3wet/01bbPeFSi
	 /tL7nfl1wF+v0iVHHXAy93UNFOiGWnpgHyi00eATq6LWtrLkOdJxaO2/YJWrq7d4eJ
	 TmfR7lsQcLR9BtOqNvv5G4nSTqVIdZFzeXv5VS26j/hqxT1o8zMygRBhHBzTx3KIre
	 dmeOy3RHi11BYvwc//hCQRZThh85sgjq7U3xLM5lAHehTzobyIWUrE0cjWg4fyurFg
	 UPG4knxasN/ZADdINrv+WmyA1LZVlYo4HOkKkv0stqk6PqO0/WGQm72fHFxC6KeBLp
	 9krNOeMB6Sy6Q==
Subject:
 Re: [PATCH] rds: fix out-of-bounds conn_path access via handshake NPATHS
From: netdev-bot+sashiko@kernel.org
To: bsdhenrymartin@gmail.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Mon, 12 Oct 2026 16:54:40 +0000
Message-ID: <179182408008.434549.9079047641584992003@kernel.org>
In-Reply-To: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
References: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
X-sashiko-severity: Critical
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

Critical: 1 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] This fix leaves the same out-of-bounds walk reachable
  through another lane loop.
- [Medium] The Fixes: tag names the wrong commit.

--

rds: fix out-of-bounds conn_path access via handshake NPATHS

This patch clamps the RDS_EXTHDR_NPATHS value the peer sends in
rds_recv_hs_exthdrs() to the number of rds_conn_path slots the transport
was allocated with. As a result, IB connections (t_mp_capable unset)
negotiate at most one lane. The aim is to stop fan-out paths such as
rds_start_mprds() from walking past the single allocated c_path entry.

> Cc: stable@vger.kernel.org
> Fixes: ba3d1f480c7a ("net/rds: size a connection's path set by the transport it ends up with")

[Severity: Medium]
Is this the right commit for the Fixes: tag?

All ba3d1f480c7a does is recompute npaths a second time after the
loopback swap in __rds_conn_create():

    npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

Its own message says "The c_path array stays sized for the caller's
transport". So it doesn't change how many slots an IB connection gets.

IB connections have had a one-element c_path since 840df162b3eb ("rds:
reduce memory footprint for RDS when transport is RDMA"). That commit
replaced the inline c_path[RDS_MPATH_WORKERS] array with an allocation
sized by:

    int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

The NPATHS clamp to RDS_MPATH_WORKERS and the rds_start_mprds() loop over
c_npaths are even older (5916e2c1554f and 69b92b5b7419).

Stable tooling chooses target trees from the Fixes: tag. Would LTS trees
that carry 840df162b3eb but not ba3d1f480c7a miss this fix? Should the
tag be:

Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport is RDMA")

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..c9528812edef1 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -224,7 +224,8 @@ static void rds_recv_hs_exthdrs(struct rds_header *hdr,
>  		/* Process extension header here */
>  		switch (type) {
>  		case RDS_EXTHDR_NPATHS:
> -			new_npaths = min_t(int, RDS_MPATH_WORKERS,
> +			new_npaths = min_t(int, conn->c_trans->t_mp_capable ?
> +					   RDS_MPATH_WORKERS : 1,
>  					   be16_to_cpu(buffer.rds_npaths));
>  			break;
>  		case RDS_EXTHDR_GEN_NUM:

[Severity: Critical]
This clamps NPATHS. Can the RDS_EXTHDR_GEN_NUM case just below it still
cause the same out-of-bounds walk on IB connections?

rds_recv_hs_exthdrs() always calls rds_conn_peer_gen_update() at the end.
The call does not depend on c_npaths, fan_out or t_mp_capable:

    conn->c_ping_triggered = 0;
    rds_conn_peer_gen_update(conn, new_peer_gen_num);

rds_conn_peer_gen_update() then loops over a fixed RDS_MPATH_WORKERS
lanes:

net/rds/recv.c:rds_conn_peer_gen_update() {
    ...
	WARN_ON(conn->c_trans->t_type != RDS_TRANS_TCP);
	if (peer_gen_num != 0) {
		if (conn->c_peer_gen_num != 0 &&
		    peer_gen_num != conn->c_peer_gen_num) {
			for (i = 0; i < RDS_MPATH_WORKERS; i++) {
				struct rds_conn_path *cp;

				cp = &conn->c_path[i];
				spin_lock_irqsave(&cp->cp_lock, flags);
				cp->cp_next_tx_seq = 1;
				cp->cp_next_rx_seq = 0;
				list_for_each_entry_safe(rm, tmp,
							 &cp->cp_retrans,
							 m_conn_item) {
					set_bit(RDS_MSG_FLUSH, &rm->m_flags);
				}
    ...
}

The WARN_ON() only prints a warning. It doesn't return.

On IB, __rds_conn_create() allocates a single c_path slot. A peer can
send two handshake probes carrying different nonzero GEN_NUM values. A
pong (h_sport == 0, h_dport == RDS_FLAG_PROBE_PORT) has no sysctl or
transport gate. A ping also works if rds_sysctl_ping_enable is set. The
call chain is:

rds_ib_process_recv()
  rds_recv_incoming()
    rds_recv_hs_exthdrs()
      rds_conn_peer_gen_update()

The first probe stores c_peer_gen_num, and the second enters the loop.
For i=1..7, would the loop take a spinlock and write cp_next_tx_seq and
cp_next_rx_seq in heap memory past the allocated slot? It would also walk
a cp_retrans list head read from that memory and call set_bit() through
whatever pointers it finds there.

If so, the commit message's claim "so a peer can never ask us to walk
lanes that do not exist" doesn't hold yet.

Could this loop also be bounded by:

    conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1

which is the count __rds_conn_create() already uses? Another option is to
skip handshake extension processing entirely on transports that are not
mp-capable.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008163843.957325-1-bsdhenrymartin%40gmail.com
