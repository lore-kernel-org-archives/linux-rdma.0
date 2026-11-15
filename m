Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712700;
	b=VSIeqzXaerIUgKs4koW0KuQd4hSN7tjLXlc4yzh7R7ywdMaW4bstUDryUhoawEFB5ayy
	 0TwADB8Oa+yQ0VyJFuzSwtBUMtFPUCbAeZIixY9+7EHjjeGNhNj9JORLQKMCjit/lt523
	 Oqyde0uyI6Z9ho/Ji84Z2uBhKfwMXwhMqmCpPkg0XArh30eo9xLfHlpzuFOcIGd9Ljvjs
	 DIcmjq00M4o+c/ejTWXoZoCGJYikfozKnNWgZc6Z7QgoMt1Z8JAEYDmO9q6LCfY0a0SYC
	 9/x+LWA/vgYXQMkzD6Gp70x8mphkmJC7awXHKJEAAhW/mDxVf0M6fqKNDq238jSLJfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712700;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=zXhT4wOx359GCKUldLkyI3j/qzjMrXPTXW8JlCEpECQ=;
	b=Eol24FyELDC6xi+pyWdFZb3SPL4pvu1zup7pZ15Kt015uR2EwdYdoYlhwGgrKGuBDsjZ
	 Uq2QWpdlBA9PFk6ZaQy78ocYOLSTwslHQCPdpW2DyhrFeVLhkCAxbZoFiv1RWQoF0a+At
	 CZcIFmI7qhcY479CVzt2xtfw5REuNxAWInuYaeNZVfz3VC3xWJvpQZf6hTPs0zQWrxp48
	 Ohxu0e2Y4eaps21XW+agurIsCJE7ozZxgnA9svYFNwRbeaIFyqyQpoVAuD5/tuin9UqP7
	 xDqjruh2/ilslsi+Z43BbU5w/rHsgyo5ICw2Cb605LpCR43LW9cdproHg3XV7vrdtjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZNf2Hla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA1A606A32D;
	Sun, 15 Nov 2026 03:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZNf2Hla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616B01F000CE;
	Sun, 15 Nov 2026 03:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712700;
	bh=zXhT4wOx359GCKUldLkyI3j/qzjMrXPTXW8JlCEpECQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GZNf2HlaLZlCdc46wskxNqEXZk1in6HzCTrmFtIEhE6q3JzCo0VNIMLrWGmOdKlcN
	 CsDUiIAsYE7iG3+hgx4l7d2Iv/ZNlW7se9fyf1cwfzbFiFSNbDmLhJFdZdd+i4Eftr
	 Ie6vTQLSPBEFj0LNRngGCFY0HfWGgeI2ksB9eOxV42VeB2dnF3idKPH6RbNf/VeKIS
	 av+yGB9oND6omGJNsayRsiy9qHvl4zgEdT6OxOnj77HYKh4+MzvEfj0oDKK1RqEMWj
	 7ElIO4UukMSVv5YPLgPTuOegSuKAk21UDdtFhQUJc9MCJ7TTNDvOF0boVBuaTGC5Oz
	 o/8nGgcTyRc4Q==
Subject: Re: [PATCH net-next v1 06/15] net/sched: act_mirred: don't send
 decrypted skbs from egress to ingress
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
 kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 martin.lau@linux.dev, pabeni@redhat.com, saeedm@nvidia.com, horms@kernel.org,
 tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 03:18:18 +0000
Message-ID: <179471269893.2199510.10845713252529893412@kernel.org>
In-Reply-To: <20261111005533.6436-7-toddfreed@meta.com>
References: <20261111005533.6436-7-toddfreed@meta.com>
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

- [Low] This patch adds the egress-to-ingress decrypted check only in
  tcf_mirred_to_dev() (net/sched/act_mirred.c:291-292).

--

net/sched: act_mirred: don't send decrypted skbs from egress to ingress

This commit stops tcf_mirred_to_dev() from sending skbs that have
skb->decrypted set from egress to ingress. On transmit the bit asks the
device to encrypt the packet, and on receive it means the device already
decrypted it. Redirected skbs are dropped and mirrored skbs are not copied.

> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 1c98e4d81ebe6..52c3eeab381ae 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -285,6 +285,12 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
>  		goto err_cant_do;
>  	}
>  
> +	/* On transmit, decrypted asks the device to encrypt the packet. Sent
> +	 * to ingress, the packet would read as decrypted by the device.
> +	 */
> +	if (unlikely(want_ingress && !at_ingress && skb_is_decrypted(skb)))
> +		goto err_cant_do;

[Severity: Low]
At this point in the series, is mirred the only egress to ingress path
that needs this check?

A tc egress BPF program can still call bpf_redirect() or
bpf_clone_redirect() with BPF_F_INGRESS. That skb goes through:

skb_do_redirect() / bpf_clone_redirect()
  __bpf_redirect()
    __bpf_redirect_common() / __bpf_redirect_no_mac()
      __bpf_rx_skb()
        ____dev_forward_skb()
          skb_scrub_packet()

skb_scrub_packet() drops the dst but does not clear skb->decrypted. A
kTLS or PSP offload socket skb would therefore reach ingress looking as
if the device had decrypted it. The socket-less PSP case can't happen yet,
because act_psp only arrives later in the series.

The next patch in the series, "bpf: don't redirect decrypted skbs from
egress to ingress", seems to close this gap. It adds a matching check at
the top of __bpf_redirect() in net/core/filter.c:

	if (unlikely((flags & BPF_F_INGRESS) && !skb_at_tc_ingress(skb) &&
		     skb_is_decrypted(skb))) {
		kfree_skb(skb);
		return -EINVAL;
	}

BPF_F_PEER without BPF_F_EGRESS already drops anything that is not at tc
ingress. So the gap only exists at this intermediate commit.

Would it be worth saying in this commit message that the BPF redirect path
is handled in the following patch?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
