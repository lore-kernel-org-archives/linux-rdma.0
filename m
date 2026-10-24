Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792885705;
	b=m4T3Y5d2SyfDGQvAqVjTNn7rqUY9UkvdCxI30vR51FGc0XtC65J47Wcjd7ETMVM0U8A/
	 dTGMpCNeS5u0uoojZKlrCB7FdS+dx4j16KsTLKPzx1O2IPXRKy3YOOKeCotgbH9Mja9kx
	 DUhfy8LLcCQ3BmOHtodGzlJpbl5r+XOPEZUnnGhKVMIeKuwjcNrnElKb1ul+IsiWJJgCj
	 dLIqGeVVmc4imOsr5fdxZ3kX13QiKZwDdeKC9ZtM994XRa2owWG5n+tFKTVXYkklgKCvf
	 Lz2sFdKZjVgxjFgBhuQ9a2mx8peH2YQhkLB/03ZslbHcmgV1oGdjoJq50fp1jlYXNFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792885705;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TeJm7zc7lEIpBVq9wFNx6l6n9j2IH2aj6mrm2Pb6m0Y=;
	b=BDwHVq9qFt1L8cbG0w8GfHeoCpfL0dWfeN7LDZa1LauEh4lu+kOFG4zCYFQYoJfGu4LE
	 2FwZpZsmRH6g64KnHnv0UWo17HutDRiHriFnfDKIvCTQErSCj0FDyYJein534/6FWfWFj
	 lCxjjBs93YAdDLD0+/vHsRETzvkBwtOUHoYwL3ncjYwp8DMClrysFRzQtcBFeeMKvxHO5
	 Gfghx82a2PtNlxmX+De5evBmOb4bdor/k5ixhVJ/QjqzV3Lj6oJ0T+/kmWKgXemEXr2h7
	 0Xixmlu9VXjNQoqYBLVJV03F5uuX46CHKh7StnKKpdP9TBGXguqXL6J3uwhdJV4z+Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHLRXUBe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A078606A31E;
	Sat, 24 Oct 2026 23:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHLRXUBe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949891F01828;
	Sat, 24 Oct 2026 23:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792885704;
	bh=TeJm7zc7lEIpBVq9wFNx6l6n9j2IH2aj6mrm2Pb6m0Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gHLRXUBeutqrRN8mV/yRzcuSHfB7iPhstEZ7Mw1YneQuPX8guBC0Fs8Sd5W+S6qUF
	 tlh5GnFDZ+s5RbPh5z6gC4WmK7EqUCjKhjXG3aLBOLKN8+GcdZikmVGFnpjlASWojC
	 FcSw7vBzACTKeZUnJ4w03QUr4+eLEZsOJJmr3HuQoBhDVZ8o98sjUy8UQ1OvchLWxn
	 auBJ8oaoY5dQvOUvZ1b96wMifDlnb0pcLC9gsO8m81V2zY111tviuvo357AAZXvZN5
	 x1qxDBqp3pqT+/js6JI/1lKttO/2cBZ4LdPJdif+ES1iFbYi7MRIDHsG7Bcl1tSM+I
	 8rSBtl+pwbG9g==
Subject: Re: [PATCH net v3 4/4] selftests: drv-net: psp: test ipv6 tcp socket
 with extension headers
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, borisp@nvidia.com, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 daniel.zahka@gmail.com, willemdebruijn.kernel@gmail.com, horms@kernel.org,
 shuah@kernel.org, cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Date: Sat, 24 Oct 2026 23:48:23 +0000
Message-ID: <179288570316.3134.17338958323067090592@kernel.org>
In-Reply-To: <20261023234640.1459291-5-toddfreed@meta.com>
References: <20261023234640.1459291-5-toddfreed@meta.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In data_send_ipv6_exthdr()
  (tools/testing/selftests/drivers/net/psp.py), a missing remote UDP…
- [Low] The new test does not exercise two code paths that earlier
  patches in this series fix, so a regression in either would still pass.

--

selftests: drv-net: psp: test ipv6 tcp socket with extension headers

This adds a data_send_ipv6_exthdr test to psp.py. It sends on a PSP TCP
socket in three phases: with no option, with an IPv6 extension header set
via setsockopt, and with the option removed. After each phase it checks
tx-packets, the received data, and that no plain UDP reaches the peer.
There is a variant each for dstopts, hopopts and rthdr, and the test is
meant to skip if the peer can't install the tc flower filter used for
counting UDP.

> diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
> index 473500901879b..ddf69c0397da1 100755
> --- a/tools/testing/selftests/drivers/net/psp.py
> +++ b/tools/testing/selftests/drivers/net/psp.py

[ ... ]

> @@ -658,6 +709,85 @@ def removal_device_bi(cfg):
>          _close_conn(cfg, s)
>  
>  
> +def _ipv6_exthdr_variants():
> +    padn = bytes([0, 0, 1, 4, 0, 0, 0, 0])  # one PadN option
> +
> +    def srh(peer):
> +        """ segment routing header, with @peer as its only segment """
> +        return (bytes([0, 2, 4, 0, 0, 0, 0, 0]) +
> +                socket.inet_pton(socket.AF_INET6, peer))
> +
> +    yield KsftNamedVariant("dstopts", socket.IPV6_DSTOPTS, lambda peer: padn)
> +    yield KsftNamedVariant("hopopts", socket.IPV6_HOPOPTS, lambda peer: padn)
> +    yield KsftNamedVariant("rthdr", socket.IPV6_RTHDR, srh)

[Severity: Low]
This isn't a bug, but two code paths fixed earlier in the series are not
exercised by these variants.

Each variant sets exactly one sticky option, so this loop in
psp_ipv6_nexthdr_off() in net/psp/psp_main.c only ever runs once:

    while (off < len) {

A version that rewrote only the first extension header's nexthdr would
still pass all three variants. A TCP socket can emit two headers here, for
example IPV6_HOPOPTS plus IPV6_DSTOPTS. ip6_xmit() pushes those through
ipv6_push_nfrag_opts() and ipv6_push_frag_opts().

Also, srh() builds an SRH with segments_left=0 and the peer as its only
segment. In ipv6_push_rthdr4():

    sr_phdr->segments[0] = **addr_p;
    *addr_p = &sr_ihdr->segments[sr_ihdr->segments_left];

So the L3 daddr ends up equal to the final destination. As a result, the
intermediate-hop case fixed in mlx5e_psp_handle_tx_skb() by "net/mlx5e:
psp: tso: replace only the length in checksum seed" never comes up here.

Would it be worth adding a variant that sets two sticky options? The
intermediate-hop case probably needs more topology setup.

> +
> +
> +def _remote_seg6_enable(cfg):

[ ... ]

> +@ksft_variants(_ipv6_exthdr_variants())
> +def data_send_ipv6_exthdr(cfg, opt, val):
> +    """ Test PSP on IPv6 packets with an extension header """
> +    cfg.require_ipver("6")
> +    _init_psp_dev(cfg)
> +    if opt == socket.IPV6_RTHDR:
> +        _remote_seg6_enable(cfg)
> +
> +    s = _make_psp_conn(cfg, 0, "6")
> +    try:
> +        # In happy path, PSP traffic arrives at the remote decrypted as TCP
> +        remote_udp = _remote_udp_from(cfg, s.getsockname()[0],
> +                                      s.getpeername()[0])
> +        if not remote_udp:
> +            raise KsftSkipEx("can't count UDP on the remote")

[Severity: Medium]
Can this skip path end up reported as a failure?

_make_psp_conn() has already opened the data connection by the time
_remote_udp_from() runs. psp_responder then runs conn_setup_psp() inline
from run_session(). It sends its key and then blocks waiting for the
client's key:

tools/testing/selftests/drivers/net/psp_responder.c:conn_setup_psp() {
    ...
	sz = recv(data_sock, info, sz, MSG_WAITALL);
    ...
}

The tc filter install can fail, for example when cls_flower or act_gact
is missing on the remote. In that case KsftSkipEx is raised before
_spi_xchg() sends the client key, and the finally block runs:

_close_psp_conn()
  _close_conn()
    _send_with_ack(cfg, b'data close\0')

The responder is still blocked in conn_setup_psp() and never reads the
'data close' command. The recv(4) on comm_sock, which was created with
timeout=1, then raises TimeoutError. That replaces the KsftSkipEx, and
ksft_run() records a FAIL instead of a SKIP.

In _close_conn(), s.close() comes after _send_with_ack(), so the data
socket is not closed explicitly either.

What happens when the socket is eventually closed? The responder might
see the data socket EOF before the queued 'data close', hit the
race_close path with data_sock == -1, and leave a stale 'err' reply on
the control channel. Later tests, including the next variants that take
the same skip path, could then fail with "Unexpected server response".

Could the remote filter be installed before _make_psp_conn() is called?
Another option would be to finish the key exchange before any early exit.

> +
> +        rx_assoc = cfg.pspnl.rx_assoc({"version": 0,

[ ... ]

> +    finally:
> +        _close_psp_conn(cfg, s)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
