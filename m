Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712704;
	b=lKcK5XmvB6ObZk+hjtkFSyN/2rO+bK0Y6PJpYQ21lekmPQn3B+1MCS7NGxDqQ4fVhuXG
	 CjByBhResrN4ICUM22QArbH4hSGh7ogCzAq5CBG2qe4fi6t1GkGzZdBdSY5CfAcNCHmdN
	 07rsB190WCrh+jIXHF9jzOkdUwt9nSSbQjUabgc9a56OfcEF+DleuD0/RJ+VZ1GdswX6W
	 eonjdwC9hkIdQMVJaL4Cbt+GjqtZaPxB7SLpg17803ZUpoaTjOLp1HzUD6YyGDJ2rQQm5
	 4M0xNPJfPoEyvtSDb26sOAocXWR8Nro5KW6bcUtKnpSXB0TUqP9PsgXkG2KzGf3/Ejg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712704;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=sXM91livLE5Zk7S7Dfg6Y9lrZXf4Fd/4eAz8t9MEIm8=;
	b=2P2w9Okd4THanSjs274HsBVD/ZU9uhP4bfoTwSeoV1CUKNr6YLIrtPhoK/+dXCAdTVKj
	 8hYVrHpiSrdLQ6O4BT7MwZm5I56bHHhWOP0zbUMG/vokqdW7bYWQfO3ga/hIJbUWl0DT5
	 m+5x3Bwz5W92YY/U3V58eH+ogmL6SaUvXaBJXxgFGWezX6cDQnDVfQcLs6tXboq91Sy2b
	 1jCLyJY/uBs6YqmmVKAgvThfiNE+NvdMeO+iSMMf5GA3GaSy2lnWEZmvawAFshMdbfMYr
	 4Fy4E41AeXnSbVOvz63jGNDw3FKKMy/MDFfeZwt4LhHiGQBoApOksFmpHC/U0gzETWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fWQJbWfT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8E160A380F;
	Sun, 15 Nov 2026 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fWQJbWfT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215341F000C4;
	Sun, 15 Nov 2026 03:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712704;
	bh=sXM91livLE5Zk7S7Dfg6Y9lrZXf4Fd/4eAz8t9MEIm8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fWQJbWfTzXJTI68Gmqq6o5l+FKTYFql6yb608yBx6OPusDJ343mZmEMnyQ0dl7ZtM
	 JZQGqJo7tKbQFfgjY62+AvN76PqlIMce5pF/jnp4wyW9tQY8LLqrd7DOa4RvJGkmP0
	 0QET56NfDPahoetP5kcPqh5upHHc3slkNNXxQaN6U3ihuoBAFJ12cukdQzHdXQjCl9
	 geEMCrssWPG1CA6nTmXamzYfTy9UeBjb/Ek0VtmdzXsAyckpDSVc1Q9vlfEp52aesd
	 Ai5abYGjRQbCYSvHq0noZAUhgra2CDIr+zhgazOM0Di+4+PEiIN2ws39KKQm59zMx1
	 uDJLALkLZ/5VA==
Subject: Re: [PATCH net-next v1 08/15] psp: only give time-wait sockets of psp
 connections a validator
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
Date: Sun, 15 Nov 2026 03:18:22 +0000
Message-ID: <179471270271.2199510.4403404984222798506@kernel.org>
In-Reply-To: <20261111005533.6436-9-toddfreed@meta.com>
References: <20261111005533.6436-9-toddfreed@meta.com>
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

- [High] psp_twsk_init() (net/psp/psp_sock.c) now sets
  tw->tw_validate_xmit_skb = psp_validate_xmit whenever the full socket…

--

psp: only give time-wait sockets of psp connections a validator

This commit changes psp_twsk_init() so that tw_validate_xmit_skb is set
only when the full socket has a psp association, not on every tcp
time-wait socket. It prepares for the upcoming tc psp action, which
treats a socket that has a validator as having its own encryption
offload.

> diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
> index 609b06c7af65b..664955bfb4fdb 100644
> --- a/net/psp/psp_sock.c
> +++ b/net/psp/psp_sock.c
> @@ -330,10 +330,14 @@ void psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk)
>  {
>  	struct psp_assoc *pas = psp_sk_assoc(sk);
>  
> -	if (pas)
> +	if (pas) {
>  		refcount_inc(&pas->refcnt);
> +		/* Only for PSP connections: a validator makes the socket
> +		 * look like it has an encryption offload of its own
> +		 */
> +		tw->tw_validate_xmit_skb = psp_validate_xmit;

[Severity: High]
Should this also check pas->tx.spi? As written, an Rx-only association
(pas->tx.spi == 0) also gets the validator here.

On a full socket, the validator is installed only after a Tx key is set,
in psp_sock_set_tx_key():

    WRITE_ONCE(sk->sk_validate_xmit_skb, psp_validate_xmit);

psp_sock_assoc_set_rx() publishes sk->psp_assoc but never sets
sk->sk_validate_xmit_skb. A connection that did rx-assoc but never
tx-assoc therefore has no validator while it is a full socket. It gains
one when it enters TIME_WAIT.

Other places that decide whether a connection is PSP-encrypted test
pas && pas->tx.spi. These include psp_reply_set_decrypted() in this same
file:

    if (pas && pas->tx.spi)
        skb->decrypted = 1;

and also psp_enqueue_set_decrypted() and psp_sk_overhead() in
include/net/psp/functions.h.

With the act_psp patch later in the series, tcf_psp_sk_offload() returns
true for a TIME_WAIT socket that has a tw_validate_xmit_skb:

    return sk_is_inet(sk) && sk->sk_state == TCP_TIME_WAIT &&
           inet_twsk(sk)->tw_validate_xmit_skb;

tcf_psp_act() then drops the packet with SKB_DROP_REASON_PSP_OUTPUT. In
addition, sk_validate_xmit_skb() in net/core/dev.c drops skbs carrying a
PSP metadata dst when the time-wait socket has a validator.

TIME_WAIT replies get skb->sk = tw through skb_set_owner_edemux() from
ip_send_unicast_reply() and tcp_v6_send_response(). The resulting
sequence looks like this:

  psp_sock_assoc_set_rx()       sk->psp_assoc set, tx.spi == 0, no validator
  connection closes
  psp_twsk_init()               tw_validate_xmit_skb set since pas != NULL
  TW ACK/RST reply, skb->sk = tw
  tcf_psp_act() ENCAP
    tcf_psp_sk_offload()        true -> TC_ACT_SHOT

So an egress psp encap rule that covers such a connection encapsulates
its packets while the socket is full. Once the socket is in TIME_WAIT,
the same rule drops its ACK and RST replies. Is this the inconsistency
the commit message describes? It seems to remain for Rx-only
associations.

An Rx-only socket has no Tx offload of its own.
Documentation/networking/psp.rst lists Tx as plain text in the Rx PSP
state.

Would gating on pas && pas->tx.spi, as psp_reply_set_decrypted() does,
match the full-socket rule? Copying the validator only when
sk->sk_validate_xmit_skb == psp_validate_xmit would be another option.

> +	}
>  	rcu_assign_pointer(tw->psp_assoc, pas);
> -	tw->tw_validate_xmit_skb = psp_validate_xmit;
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
