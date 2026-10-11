Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7689459AE0;
	Sun, 11 Oct 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791745446; cv=none; b=PWWNFnZHbXuHnZOX8bqrig9ASypcWIRRlVEIrLjxyxuXt4rmWsn9lHgdjdyVP0tDu5eccZ9XLiXjrmwFHe77LYIAenqdVtbTeIRZSGa0vfhkqvTX6eED5a3xn4WgO7SDZn6zhYmcDbJPx1GWiTlGt09qhSnhBbE5f5FfvGyQrFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791745446; c=relaxed/simple;
	bh=u3+DCG4OBowxaxxrfkmvj9Ezccoo3SArK3og9ZMW4NQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k4tkMEMYuByzyNtFcN6x/oQO/ZncR2A3K7HoywRjsKVpY3JsF690hGs5B7sgbJlNFOw8pEd6jLuMcMdZmNHewF+4SSIZQxZxWq2DJ0ZTgehhwSS4zD23jGT852pijBnrSonjw3Lw5/JIJB6Q997o71oYMWPB2q2ffPplUiFjgfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZo2F/Sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZo2F/Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4241F1F0089B;
	Sun, 11 Oct 2026 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791745445;
	bh=Ig+0+y+f6lfiozGzYQzbwtDL6sxb4GUQ6Cp/t/tcq3s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BZo2F/SwAn3E6EeHf7x+ECDWtVASPkWlWNzltBFSHAwoxQnOlT+nh1NASgrpE4PGO
	 lZQJ4xmjJ39tPWzPWN99gpIMFwxDgHEVLl8vW+139XhWKJoem1PGY312qI1g10Ubhz
	 jX2cHNndfHdZo5gAY8Nz9UtzxUb2LGjZ5ZaqGV3HG3JWhA4HpZMHhde5fFLf0wPGiv
	 WnfkWQSQTZa3/h1B9bg3CDJ3KZnuk8xPoWmwECdRyAI7EEfq6BGXDkog+blD6JuDSL
	 KISORjp/9xhmHxYaTyNNpF0/gThUv4mpigBSi66Ksw1rhYxCevY2lkJHqHQXsNHnPx
	 TILMeHZD3vnCA==
Subject: Re: [PATCH net-next 6/9] e1000e: use pskb_may_pull() in the 82571/2/3
 TSO workaround
From: netdev-bot+sashiko@kernel.org
To: josef@toxicpanda.com
Cc: kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, jgross@suse.com,
 sstabellini@kernel.org, oleksandr_tyshchenko@epam.com,
 anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com, manishc@marvell.com,
 rahulv@marvell.com, GR-Linux-NIC-Dev@marvell.com, shshaikh@marvell.com,
 horms@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, xen-devel@lists.xenproject.org,
 intel-wired-lan@lists.osuosl.org
Date: Sun, 11 Oct 2026 19:04:03 +0000
Message-ID: <179174544385.434549.3694135096916688968@kernel.org>
In-Reply-To:
 <20261007-b4-pskb-pull-tail-drivers-v1-6-9512b0fb977b@toxicpanda.com>
References:
 <20261007-b4-pskb-pull-tail-drivers-v1-6-9512b0fb977b@toxicpanda.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] After this patch, two unrelated error paths in e1000e log the
  same message.

--

e1000e: use pskb_may_pull() in the 82571/2/3 TSO workaround

This commit changes the 82571/2/3 TSO workaround in e1000_xmit_frame() to
use pskb_may_pull(skb, len + pull_size) in place of a direct
__pskb_pull_tail() call. With this change the driver no longer calls
__pskb_pull_tail() itself. The error message printed on failure is
updated to match.

> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 844f31ab37ad4..e216868e15cba 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5859,8 +5859,8 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
>  			unsigned int pull_size;
>  
>  			pull_size = min_t(unsigned int, 4, skb->data_len);
> -			if (!__pskb_pull_tail(skb, pull_size)) {
> -				e_err("__pskb_pull_tail failed.\n");
> +			if (!pskb_may_pull(skb, len + pull_size)) {
> +				e_err("pskb_may_pull failed.\n");

[Severity: Low]
This isn't a bug, but this TX message now matches a message that
already exists on the jumbo RX path in the same file:

drivers/net/ethernet/intel/e1000e/netdev.c:e1000_clean_jumbo_rx_irq() {
    ...
		/* eth type trans needs skb->data to point to something */
		if (!pskb_may_pull(skb, ETH_HLEN)) {
			e_err("pskb_may_pull failed.\n");
			dev_kfree_skb_irq(skb);
			goto next_desc;
		}
    ...
}

e_err() expands to netdev_err(adapter->netdev, ...). The log line
therefore shows only the device name, not the function or the
direction.

Before this patch the TX site printed "__pskb_pull_tail failed.", so the
two failures could be told apart in dmesg. After it, a failed RX
ETH_HLEN pull and a failed pull in the TX TSO workaround print the same
line.

Could the TX site use a TX-specific message instead, for example
"TSO workaround pskb_may_pull failed.\n"?

>  				dev_kfree_skb_any(skb);
>  				return NETDEV_TX_OK;
>  			}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b%40toxicpanda.com
