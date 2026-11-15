Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794727273;
	b=jbbFXDxC9XtLctDRxfIVOpjWsxAT5/MCqNZkXQagia+F5mRAQCk9dbsD05RJNdebO6Av
	 GevcoCyQI09WPEB/c5WaL2mYTdBlKIeQ/oXczrpmf/9utOjfJh9U1nXaB8RcslXVLM0ay
	 lyiCVHXKnaiS41pVlxv0hB0GzD37fb3dBrMTcOwHydlxOJ8CG5Kx0eww8SOWaQcVzkgif
	 Ua+3DTcZoYl1gCp+bEqOKfdhIUHSAX7FQasbaF0jwO0SwEybmuS1vuNrx4Ndh1bXXUTUI
	 EjkpQFb9OATOR624kIWIcdLVasM50cKE5uv1Fz/LYkkUFKfVHhB63CdFFEgNaCaugog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727273;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=rQkXsM7aTK1ejfcEgqQ8A28+qA/EL1BgfPpRxPrkcmM=;
	b=srEtkfBKrYmn6xG4n/O1XAGu8gQBNdjJdUdlNgq0OapqPixAp/TB+ZU+2Q50VCTxys0U
	 a6T7W9EuBKQPLLKZ1fbcnSAJKpzS+02Y60bCRCReIQiyhr4S29sQqz4eMw79i8zxh5SCP
	 VSiULkgZMDn9ucg3zJNpYPpuWfO0iO9dKBelgXYPPo8EH8+/dYT68N75OjPLWFdk+Lx9M
	 z84ax29T3RjFDMQaWDbo8kTohSIdX8F7DqHMdrx5pLyetGxHX7UX2A9NU4VBj8t0muMzt
	 4kJ5KPfxkd1VheXd6TxoFj85ypr8QB9Ip7sJXyGtZw36HmH8836+7JFjuLIFyXivqig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WBSPv3/5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FECE606A31A;
	Sun, 15 Nov 2026 07:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBSPv3/5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EECE1F000C4;
	Sun, 15 Nov 2026 07:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794727273;
	bh=rQkXsM7aTK1ejfcEgqQ8A28+qA/EL1BgfPpRxPrkcmM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WBSPv3/5mQQn/Yr4p7hQKzQf7t7BgsLBY8A33mwoBMkC0Ii9VhGPbcAf09pKp370X
	 rnM1l/BKKXKK+ou24cATlwOfI/ng7SWcSRH2/z46EVqAJyxZeZMaC6cu4gg1uZ0jJW
	 XSmgn+5s21FPyV8UXQ92yW7tY2zY7kTI1dtOved2V6o+ylxLhii5Z7n6ev9abEFD7c
	 Dj30pR/mdGkkiA4Lx6UjxbzZtiQoEJvkz4QUtyFngEjS+wJ7oC41K/2KjfArbAT/8d
	 RlrYkvA96cF1fhuuIV3B3xnyMrbkdKEe1yRtFJuv/0rTFsLfT0tWELgocdbCLnFwVt
	 s3uZPPf1+khVQ==
Subject: Re: [PATCH net v5 4/8] ipv4: icmp: don't quote decrypted payload in
 icmp errors
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
Date: Sun, 15 Nov 2026 07:21:10 +0000
Message-ID: <179472727079.2199510.11728930190494845454@kernel.org>
In-Reply-To: <20261111001831.3710881-5-toddfreed@meta.com>
References: <20261111001831.3710881-5-toddfreed@meta.com>
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

- [High] Incomplete fix, and the commit message is wrong about which
  reject paths it covers.

--

ipv4: icmp: don't quote decrypted payload in icmp errors

This patch makes __icmp_send() skip the ICMP error when the invoking
skb has skb->decrypted set. The one exception is a locally originated
skb whose error is routed to a local address. The goal is to stop
device-decrypted kTLS or PSP data from being quoted back onto the
network in cleartext.

Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com

> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 90c0e22c29bea..e11008aa4cecd 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -979,6 +979,18 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>  	if (rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
>  		goto ende;
>  
> +	/* Don't send parts of a decrypted skb onto the network. A received skb
> +	 * was decrypted by the device, and the transport header may have been
> +	 * encrypted. The different offloads can't be distinguished in all cases
> +	 * so simply don't send the error.
> +	 *
> +	 * A locally originated skb to be encrypted may be quoted if its source
> +	 * address (target of the error) is local.
> +	 */
> +	if (unlikely(skb_is_decrypted(skb_in)) &&
> +	    (skb_in->skb_iif || !(rt->rt_flags & RTCF_LOCAL)))
> +		goto ende;

[Severity: High]
Does this check cover every reject path the commit message names? The
commit message says:

    a reject rule (iptables REJECT, nft reject) sends its icmp error with
    icmp_send(), through nf_send_unreach(). so now, a received packet which
    the device decrypted, and which hits a reject rule in the INPUT or
    FORWARD chain, is now dropped without a reply, like a drop rule.

That is true for iptables REJECT and for the nft ip and inet families.
The nft netdev and bridge families are different. They build their own
ICMP error and never reach __icmp_send():

nft_reject_netdev_eval()
  nft_reject_netdev_send_v4_unreach()
    nf_reject_skb_v4_unreach()
    nft_reject_queue_xmit()
      dev_queue_xmit()

nft_reject_br_send_v4_unreach()
  nf_reject_skb_v4_unreach()
  br_forward()

nf_reject_skb_v4_unreach() copies the original packet into the error
and has no skb_is_decrypted() check:

net/ipv4/netfilter/nf_reject_ipv4.c:nf_reject_skb_v4_unreach() {
    ...
	/* RFC says return as much as we can without exceeding 576 bytes. */
	len = min_t(unsigned int, 536, oldskb->len);
    ...
	skb_put_data(nskb, skb_network_header(oldskb), len);
    ...
}

Take an nft netdev reject rule on the ingress hook of a NIC that does
kTLS or PSP RX offload. The ingress hook in __netif_receive_skb_core()
sees the skb after the driver has decrypted it.

Wouldn't the ICMP error then send the decrypted TCP payload (kTLS), or
the TCP header plus payload (PSP), out in cleartext?

The new nskb has decrypted == 0, so nothing later on the tx path stops
it. The bridge family uses the same helper. A decrypted skb on a bridge
port is less likely, but the code doesn't rule it out.

The rest of the series doesn't seem to close this gap either. The ipv6
follow-up, "ipv6: icmpv6: don't quote decrypted payload in icmpv6
errors", seems to leave the same gap in nf_reject_skb_v6_unreach() for
the netdev and bridge families.

Should the check also go into nf_reject_skb_v4_unreach() and
nf_reject_skb_v6_unreach(), or into their callers? If not, could the
commit message be narrowed to the reject paths that are actually
covered?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111001831.3710881-1-toddfreed%40meta.com
