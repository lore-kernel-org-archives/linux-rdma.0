Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE412D781B;
	Mon, 12 Oct 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825400; cv=none; b=iAffT0pkSNnbk3/Dk7ePwUdPsu+gW46qk6czV7zN0r4ZBzYsorxjvYA95gDbSNpNptcOO8EDMKyHp8aqQq7igK7jIK+FDtpnxP1Nau6uRSJjSPa/ZboXXfhyLdH37Ssu8YeQzaEzjTZVew3rMlZ7noAfI9aUto3oxoEEonATh2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825400; c=relaxed/simple;
	bh=/agcCFouw/gqTSOvTcaEZQDSWyCL+YpsYbk5myDAEF4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e8a+4qSydx5djbXlGRMGbCVxvG+NMYipPEDuwWC+WdTXTNO/qw3KfvzuChU9G9fBSg8u7QU0EJPSy32lEt77999TyfJvcpOTXgYdWnek1541iGan9u3YLpi1FJgLYj0TojGGUForbQUqi/92INcKfKdICdA6DKkP5boedfsNdsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdLN9Fh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdLN9Fh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65CD1F0089B;
	Mon, 12 Oct 2026 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791825398;
	bh=EpezYIC2PF522Pn091cXv35Yzr07N8vqXygIgiVc8QE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BdLN9Fh7u/aIlHTvwiaw72L7/uA1Go/ZmjNTJq49DmvgeKLil4xKjARZjUGmJfK34
	 k2EVDN+qH7ysxyDl6AdNDGIstnNvhTqxEk1zTFAlYkUhBNd7YdxDIE5h2uoejSP0Fv
	 TO0koRwyGMc5Je8yJI8euIajtqnDXmt9mAlkMg5ILoecG8iACaPq3mRMqRBbWZOHWf
	 MjPIyyjXnVDOEDdwRWTi7Raf5LZ48PX69BKYwc9SGa8mqXeJ7PEio116QojvPLh7Zn
	 o8mXNsZK3VZGe8S9KHtCq2IVfSvfXNkMIuEMR9/xOpTA2ginXIVLrt/UdUF7Q0A/Z2
	 bil+TlcwaugVw==
Subject: Re: [PATCH] rds: fix out-of-bounds conn_path walk in peer gen update
From: netdev-bot+sashiko@kernel.org
To: bsdhenrymartin@gmail.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Mon, 12 Oct 2026 17:16:37 +0000
Message-ID: <179182539748.434549.902490805365673328@kernel.org>
In-Reply-To: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
References: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
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

- [Critical] The patch only bounds the loop in
  rds_conn_peer_gen_update().
- [Medium] The Fixes: tag names ba3d1f480c7a ("net/rds: size a
  connection's path set by the transport it ends up with", Sep 2026),…

--

rds: fix out-of-bounds conn_path walk in peer gen update

This patch limits the loop in rds_conn_peer_gen_update() to the number of
rds_conn_path entries allocated for the connection's transport. With it, a
non-mp-capable (IB) connection only walks its single c_path slot when the
peer announces a new generation number.

> Cc: stable@vger.kernel.org
> Fixes: ba3d1f480c7a ("net/rds: size a connection's path set by the transport it ends up with")

[Severity: Medium]
Is this the right commit for the Fixes: tag?

git blame shows that the RDS_MPATH_WORKERS loop in
rds_conn_peer_gen_update() dates from 905dd4184e07 (2016).

The single-entry c_path allocation for non-mp-capable transports came from
840df162b3eb ("rds: reduce memory footprint for RDS when transport is
RDMA", 2017):

net/rds/connection.c:__rds_conn_create() {
    ...
	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
    ...
}

ba3d1f480c7a only adds a second npaths computation after the loopback
transport swap. That changes how many paths get initialised, not the size
of c_path. Its own commit message says "The c_path array stays sized for
the caller's transport". IB conns had one slot before that commit and
still have one after it.

Stable tooling uses the Fixes: tag to pick target trees, so this tag could
leave out LTS trees from 2017 onward that have the out-of-bounds write.
Should it be this instead?

Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport is RDMA")

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..afc810a2e3cf9 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -144,7 +144,8 @@ static void rds_conn_peer_gen_update(struct rds_connection *conn,
>  	if (peer_gen_num != 0) {
>  		if (conn->c_peer_gen_num != 0 &&
>  		    peer_gen_num != conn->c_peer_gen_num) {
> -			for (i = 0; i < RDS_MPATH_WORKERS; i++) {
> +			for (i = 0; i < (conn->c_trans->t_mp_capable ?
> +			     RDS_MPATH_WORKERS : 1); i++) {

[Severity: Critical]
This limits the walk here. Can the same handshake packet still overrun the
single-entry c_path[] of an IB connection through c_npaths?

rds_recv_incoming() calls rds_recv_hs_exthdrs() for handshake pings and
pongs on every transport, and nothing on that path checks t_mp_capable.
The ping sysctl does not gate the pong branch:

net/rds/recv.c:rds_recv_incoming() {
    ...
	if (be16_to_cpu(inc->i_hdr.h_dport) ==  RDS_FLAG_PROBE_PORT &&
	    inc->i_hdr.h_sport == 0) {
		rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
		/* if this is a handshake pong, start multipath if necessary */
		rds_start_mprds(cp->cp_conn);
    ...
}

rds_recv_hs_exthdrs() takes the RDS_EXTHDR_NPATHS value from the peer and
caps it at RDS_MPATH_WORKERS, not at the allocated path count. It then
stores the result:

net/rds/recv.c:rds_recv_hs_exthdrs() {
    ...
		case RDS_EXTHDR_NPATHS:
			new_npaths = min_t(int, RDS_MPATH_WORKERS,
					   be16_to_cpu(buffer.rds_npaths));
    ...
	conn->c_npaths = max_t(int, new_npaths, 1);
    ...
}

This lets c_npaths reach 8 on an IB conn where __rds_conn_create()
allocated only one c_path entry.

In the same receive call, when laddr < faddr, rds_start_mprds() walks
c_npaths entries:

net/rds/recv.c:rds_start_mprds() {
    ...
		for (i = 0; i < conn->c_npaths; i++) {
			cp = &conn->c_path[i];
			rds_conn_path_connect_if_down(cp);
		}
    ...
}

When laddr > faddr, c_npaths still stays inflated. A later rds_sendmsg()
reaches rds_check_all_paths() whenever the selected path is down:

net/rds/connection.c:rds_check_all_paths() {
    ...
	do {
		rds_conn_path_connect_if_down(&conn->c_path[i]);
	} while (++i < conn->c_npaths);
}

For c_path[1..7], rds_conn_path_connect_if_down() reads cp->cp_conn from
the neighbouring slab object and dereferences it in rds_destroy_pending().
It also does test_and_set_bit() on cp->cp_flags and calls
queue_delayed_work() with cp->cp_wq and cp->cp_conn_w from that same
memory.

rds_send_probe() only sends these extension headers when t_mp_capable is
set, but the receive side applies them on every transport.

Would it be better to skip rds_recv_hs_exthdrs() and rds_start_mprds() for
non-mp-capable transports, or to clamp c_npaths to the allocated path
count? Either would cover all of these walks.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008164041.961961-1-bsdhenrymartin%40gmail.com
