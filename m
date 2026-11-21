Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295864;
	b=qovaG4/rxu/iENdI8wgmoxQ+lWVuQQ1a1x2LM0Jt29v+ubznvx+1hizH1/gIrs1U6nxy
	 NtKGrC5nlxAizO3ZQy3qYRU/vdzb7ibVMIT71763ZhUC3tdzckyrgcJ59D+ln/+wkpWlS
	 1CEHpQVenjqweyNhDETbMn17Kq5otPhaW3ufvMGmMVVtutVG+tIZZPv+6nnukvqUWmybS
	 2eR9FpFe+YMwfyUkoiEpIzm8xhH/lFtUMkgjyMrDPQhG/E7Rzj9FEep13KvBQS4eP59Ao
	 CFwq9qrAd0nx/QsfRon5XAx5m4zZGHoebQFeOWx3YAIA3jzH3ycAKdyladUYhJX8RBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295864;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=tcvRTnOwn9O3TTbSJaDM4Da7hwCv/Q3I4UX7KXPCWZQ=;
	b=wrmvZiukxOpw+SwFbHQxrC/cHvohNAvOPc33xqT4J6AQZ3seN87cL8aIl9iWRxT2I7D6
	 D5QuacekTcmw+do++rlUi9Cz4qG1G1/skHG/D5jLukQql3aZ3BwrAaNGc2/Xvzv7e/VJi
	 pHBxJnsYb+Gcx42//+KSKId9vPxPrX5ylllc2F1Hieql267IfZWHooBa/6kENOt+x4uum
	 B5qgDA4tuxLrZeN+64m7O2DtYREcOQXiAxm4s8ZlD4ZlVgQsXbhEgU6wI63iqYa0s+plv
	 5e7C6rUO/lR8IW1G1s7zEr43ktBvkiUnDRbOieenA6txUhjehM5B2Q+9+3N9ovvaJRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GTJa/YqV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E70606A334;
	Sat, 21 Nov 2026 21:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTJa/YqV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B35B1F000CF;
	Sat, 21 Nov 2026 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295864;
	bh=tcvRTnOwn9O3TTbSJaDM4Da7hwCv/Q3I4UX7KXPCWZQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GTJa/YqVEp4Gt0S+Fx0JQjrXfuKdmeejH3MqQfeQrJjiaONe+UCxzDKqJ6CSJGRFh
	 OC/LyocHpo735f0ArPe438Y+fBXOnWNMaMSkJXgx/E7VUJEa/iX3Y/eOwynIAIuL7R
	 xRvWoNnILZFElNfVAoyoayMrTCUEQ7fz1g8OuJNm9nHi+/gsV1i2nRZkyItzNEpjvV
	 DL3mOvK5EDtbXb7Rj90JvpZKDXKbfm6sIWPiFE7HdcF/TXahV0cw82qa/eTWKrwynu
	 9D4RMSAQ9J+GyPxwTR4rpqAmDMq26fijY79LBxG2NsVz8eSPJkBHvxfNJkn3loFzrg
	 VqZBOpnRZEKEA==
Subject: Re: [PATCH net v6 5/8] ipv6: icmpv6: don't quote decrypted payload in
 icmpv6 errors
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
 willemdebruijn.kernel@gmail.com, stable@vger.kernel.org
Date: Sat, 21 Nov 2026 21:17:42 +0000
Message-ID: <179529586258.3135.12190616828136497053@kernel.org>
In-Reply-To: <20261117203137.804424-6-toddfreed@meta.com>
References: <20261117203137.804424-6-toddfreed@meta.com>
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

- [High] The fix is incomplete on IPv6.

--

ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors

This commit stops icmp6_send() from sending an error about a received skb
that the device has decrypted (skb->decrypted). An error about a locally
originated decrypted skb is still sent, but only if its route goes to a
local address (RTF_LOCAL). This follows the earlier IPv4 patch for
__icmp_send().

> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index d8203ebad8827..574a42d279e03 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -778,6 +778,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>
>  	np = inet6_sk(sk);
>
> +	/* Don't send parts of a decrypted skb onto the network, see
> +	 * __icmp_send(): no error about a received skb. Before the rate
> +	 * limit, so that such an error costs no credit. The check of a
> +	 * locally originated skb below needs the route of the error, which
> +	 * is looked up after the rate limit.
> +	 */
> +	if (unlikely(skb_is_decrypted(skb) && skb->skb_iif))
> +		goto out_unlock;
> +

[Severity: High]
Does this cover the NDISC Redirect sent from ip6_forward()? That path also
quotes the invoking packet, but it never goes through icmp6_send():

net/ipv6/ip6_output.c:ip6_forward() {
    ...
	if (IP6CB(skb)->iif == dev->ifindex &&
	    opt->srcrt == 0 && !skb_sec_path(skb)) {
    ...
		if (peer && inet_peer_xrlim_allow(peer, 1*HZ))
			ndisc_send_redirect(skb, target);
    ...
}

None of these conditions look at skb->decrypted. ndisc_send_redirect()
then copies up to about 1200 bytes of the original packet into a new skb
from ndisc_alloc_skb(), and that skb is not marked decrypted:

net/ipv6/ndisc.c:ndisc_send_redirect() {
    ...
	rd_len = min_t(unsigned int,
		       IPV6_MIN_MTU - sizeof(struct ipv6hdr) - sizeof(*msg) - optlen,
		       skb->len + 8);
    ...
	if (rd_len)
		ndisc_fill_redirect_hdr_option(buff, skb, rd_len);

	skb_dst_set(buff, dst);
	ndisc_send_skb(buff, &ipv6_hdr(skb)->saddr, &saddr_buf);
    ...
}

ndisc_fill_redirect_hdr_option() calls skb_copy_bits() starting at the
network header of the original skb. The decrypted L3/L4/payload bytes
would then go out in cleartext inside the Redirected Header option.

sk_validate_xmit_skb() drops the forwarded packet itself ("unencrypted skb
with no associated socket"). That leaves the redirect as the only way this
plaintext gets out of the host.

On IPv4, the call chain ip_forward()->ip_rt_send_redirect()->icmp_send()->
__icmp_send() reaches the check from the previous patch, because skb_iif
is set. The commit message says:

  as in the previous patch for icmp, don't send an error about a received
  decrypted skb at all

For redirects, though, IPv6 does not match IPv4. Nothing later in the
series seems to change this.

As for how a decrypted skb gets to ip6_forward(): the mlx5 PSP RX decrypt
rule in setup_fte_udp_psp() matches only on ip_protocol == IPPROTO_UDP and
the UDP dport. It does not match on the destination address.
mlx5e_psp_offload_handle_rx_skb() then sets skb->decrypted. With
forwarding enabled, a PSP packet sent to a non-local IPv6 address would be
decrypted and then forwarded.

kTLS RX offload can also produce a decrypted skb whose destination is no
longer local. One example is when the local address is removed while the
offload is still active.

The !skb_sec_path() condition already keeps redirects from quoting frames
decapsulated by IPsec. Would a similar skb_is_decrypted() check make sense,
either in the redirect condition in ip6_forward() or in
ndisc_send_redirect()?

>  	if (!icmpv6_xrlim_allow(sk, type, &fl6, apply_ratelimit))
>  		goto out_unlock;
>

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117203137.804424-1-toddfreed%40meta.com
