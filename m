Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794727277;
	b=FVgB9SyWXFtultqspuCED0s+VSIk27HP+ivEgHM1XpUXkBKk0eq7Tx+UsBanq29cP5wm
	 kyppAe2K2pn34dYAFkJ3rOBhszGxkIacHRYEosExdZzRFYjOCd9Tnlr86adnOnjKbUo84
	 zbLoERQprrw/gc11RKrL8SKpJW2RYalF4jkgDoEGBnqvAO6tKFKjEi6cBp9vqEXxHaqOK
	 YLIUqMaVKo1zRS40+gMQhrcGFRkKOQYf6Qt0Dj8fVvB1tXS9lI2hB9uUFZyzprN2EbzWT
	 BqLbp71Z7PCZm3kQe/06V7PKSs8jKPoKgD0mcMg+4OyIcceOXjiQKmi4G4WhqH+rn6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727277;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=1wIaAoqveAUksE+imNE0AFXmAQw+PL+pfe8nYBhWq84=;
	b=sON8D346ChDCHa9cV0JJAj2UELdGU+8SxweVVY1XnNAGhs2eMXcSpo1iDzHmKQPoRwt4
	 t0UwGFYOQs4OFIOtf2c1/Uwmg0xaabix/nUst1aGV4mf6YDSBrvORmuWZ5jsnFSDPf5FD
	 RCaPFb01N3aFA0uc8eOgrNfXx6YpCZkQGYRr/YkjjAh4YMiM5b7sy0isZQfckTLlB5k/f
	 KNgt9ei8BIYkTofSzN3VoR/ZhxhZCaKHLARaAMpgtn7QdWccwjQ/v/AZnW5yjpOQpz5KY
	 1ZiH6G6B4b0T5MiSvxOaPHA2ZpuhS+17s11W594/c7ah3gWV0B2sea0RlPmvIUdX8tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lWSx1ymw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CE8606A884;
	Sun, 15 Nov 2026 07:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lWSx1ymw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADDD1F000C4;
	Sun, 15 Nov 2026 07:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794727277;
	bh=1wIaAoqveAUksE+imNE0AFXmAQw+PL+pfe8nYBhWq84=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lWSx1ymwqRfPvPk1GLXLzUv7x3SCPAxEYESanV567uUw+AKA7q8979FM4nIo5zA3N
	 Tf/4Jy8c7fwHIVvYdzppVxuol+fjZKIUz7vBXFR+h/eKPM/Yx+V1Mo0wYZ6Rq4OQI9
	 cQ96d1Xk3cjOaZbjoY/T7bkCBDlgGRloIoCCKvWXpupUsfUXm8BVrFWMOR9/ABbiu/
	 onHdby1te+yFR3QzWs7DEDzmcpQbbRzEFAUzDOQaGYXqm4CpP5bavHYQC/1IJglldP
	 yQYrDwOmcIDAdh8TZy6I8TnYgGbKVgWHIJB+9T1NX9/fWb669T9P0lOT2b0F/jRZR9
	 EB2x/JjGGZb3g==
Subject: Re: [PATCH net v5 6/8] selftests: drv-net: psp: test ipv6 tcp socket
 with extension headers
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, borisp@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dsahern@kernel.org, dtatulea@nvidia.com,
 edumazet@kernel.org, idosch@nvidia.com, kuba@kernel.org,
 john.fastabend@gmail.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, pabeni@redhat.com, raeds@nvidia.com,
 rrameshbabu@nvidia.com, sd@queasysnail.net, saeedm@nvidia.com,
 shuah@kernel.org, horms@kernel.org, tariqt@nvidia.com, weiwan@google.com,
 willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 07:21:15 +0000
Message-ID: <179472727541.2199510.15003590884466629301@kernel.org>
In-Reply-To: <20261111001831.3710881-7-toddfreed@meta.com>
References: <20261111001831.3710881-7-toddfreed@meta.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] In data_send_ipv6_exthdr()
  (tools/testing/selftests/drivers/net/psp.py), the finally block runs…
- [Low] Concern: the commit message overstates coverage ('a variant for
  each extension header a socket can set') because there is no…

--

selftests: drv-net: psp: test ipv6 tcp socket with extension headers

This adds a PSP selftest that sends data on an IPv6 PSP TCP socket in
three phases: with no extension header, with one set (IPV6_DSTOPTS,
IPV6_HOPOPTS or IPV6_RTHDR), and after the option is removed. After each
phase it checks the device's tx-packets and a tc flower UDP counter on
the remote. It also adds a helper that waits for stats to quiesce, and
adds CONFIG_NET_ACT_GACT to the config.

> diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
> index 473500901879b..7e251439a2fd9 100755
> --- a/tools/testing/selftests/drivers/net/psp.py
> +++ b/tools/testing/selftests/drivers/net/psp.py

[ ... ]

> @@ -658,6 +710,95 @@ def removal_device_bi(cfg):

[ ... ]

> +@ksft_variants(_ipv6_exthdr_variants())
> +def data_send_ipv6_exthdr(cfg, opt, val):
> +    """ Test that PSP drops IPv6 packets with an extension header """

[ ... ]

> +        # 2. With the option: dropped, not counted, and nothing reaches the
> +        # peer. The data stays queued.
> +        s.setsockopt(socket.IPPROTO_IPV6, opt, val(peer))

[ ... ]

> +    finally:
> +        # With the option, the queued data, the FIN and the ACKs would be
> +        # dropped, leaving an orphan holding the association
> +        s.setsockopt(socket.IPPROTO_IPV6, opt, b'')
> +        _close_psp_conn(cfg, s)

[Severity: Low]
What happens to this cleanup in data_send_ipv6_exthdr() when the test
runs without CAP_NET_RAW, for the dstopts and hopopts variants?

ipv6_set_opt_hdr() checks the capability before it reaches the
zero-length removal path. That means clearing the option with b'' can
also fail with EPERM:

net/ipv6/ipv6_sockglue.c:ipv6_set_opt_hdr() {
    ...
	/* hop-by-hop / destination options are privileged option */
	if (optname != IPV6_RTHDR && !sockopt_ns_capable(net->user_ns, CAP_NET_RAW))
		return -EPERM;

	/* remove any sticky options header with a zero option
	 * length, per RFC3542.
	 */
	if (optlen > 0) {
    ...
}

In that case the phase 2 setsockopt raises PermissionError first. Then
the setsockopt in the finally block raises a second PermissionError, so
_close_psp_conn() never runs.

When that happens, psp_responder never gets the "data close" command and
keeps its data socket open. The local PSP socket isn't closed explicitly
either, and the original exception ends up chained under the second one.
The following test cases share cfg.comm_sock and the responder state, so
they could be affected.

The rthdr variant isn't affected because IPV6_RTHDR skips the capability
check.

Could the option removal be guarded separately, for example with a
nested try/finally, so that _close_psp_conn() always runs?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111001831.3710881-1-toddfreed%40meta.com
