Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDB5190462;
	Wed, 14 Oct 2026 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014595; cv=none; b=i53uWDCO2cnwuvw74f2/6KLf0nyeqbNfrIZqp6TQMVotAyN38RVEYa+sSBzN+oiQ2SuDQWJoYrlnwKEAutPjEU4XFkZnKkbSWaSYf4wa5fdreRZYQhsKBdccInfgIeuZhtiYgb4WWcmBj5XCbCsDHkYgWMjOz57REH0CGO2Tdko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014595; c=relaxed/simple;
	bh=FcAzgEWftwEGhdFlkl1X5UznVkEfO6u8HS6WESVFXgY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LkReTRFJzaBzU/4f+Eus0WkvzJLJm5Lkvhy+9oLkcKZqBHZ0W5g2ve+sr7Z7/k8JRtUWsNhIv4i2SkwXq2eVzwgJuGncfJBJcM+LyXnOlowpd2/bE5Zs4adhuwNUQ9GdL+pEzTdWwef6272o+Uf848+Mgy5V9R0KY6dqF4QJsiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCdS201q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCdS201q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E541F000C4;
	Wed, 14 Oct 2026 21:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792014594;
	bh=44kLSpkPqQ2M5rJSUeF0/Z/StfM9XZgXXcVH8xX3Rvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZCdS201qs4HIRA0rzvqUc8lT25OvqY5AMHo7hOyKRhrCAo/v6iZ2K/REF+kGOSUAV
	 WJ8z6vJ8ytrqDV2388/e4jHg78yPDBzGmmg2f9NXYRM1lfRTl9jcLlKldrj2thO5OH
	 JGC7TUolyxTXvsQusJk6zPI2fHvtWU+wNsck+O/cVRUzmqqvfOqLA4KCPnRSQEBTP/
	 1hmWUKrJBE0NJcXEVPsYUiteUqFra55CUTDiUTBwx5HJSnSOmhbFzV3wXTGhsROgDe
	 AGHO8Fn7BOLZWRnzRuzTOMpx2EH26cjLe0T7EpPGgfsC1laihqI7v6D9BgdbkALH8j
	 qfRvBytgWHT3w==
Message-ID: <sashiko-outbox-171939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3] net: mana: add BQL support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hamza Mahfooz" <hamzamahfooz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
References: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 21:49:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mana: unratelimited netdev_warn in __mana_start_xmit causes log sp=
am under XDP load
--

commit a6a9466a25f553494605c439f140071b9b0b7068
Author: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

net: mana: add BQL support

MANA doesn't support byte queue limits, so each TX queue can hold 256
WQEs by default, and up to 16384, of up to 64 KB TSO packets, before the
qdisc layer sees any backpressure. This adds latency to all the flows
sharing a queue, and defeats AQM qdiscs such as fq_codel. This patch
adds BQL support by reporting the bytes queued and completed to BQL,
except for XDP_TX and XDP_REDIRECT frames.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net=
/ethernet/microsoft/mana/mana_bpf.c
> index 484f061bc75e4..7c55f8724441d 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -21,7 +21,7 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device=
 *ndev)
>  	ndevtxq =3D netdev_get_tx_queue(ndev, txq_idx);
>  	__netif_tx_lock(ndevtxq, smp_processor_id());
> =20
> -	rc =3D mana_start_xmit(skb, ndev);
> +	rc =3D __mana_start_xmit(skb, ndev, true);

[Severity: High]
Does this allow unratelimited log spam under heavy XDP load?

XDP traffic directly calls the transmit path here without checking or
honoring the stopped queue state. If the Send Queue fills up,
__mana_start_xmit() unconditionally calls mana_gd_post_work_request(),
which can return -ENOSPC.

When it fails, __mana_start_xmit() prints an unratelimited warning:

	if (err) {
		(void)skb_dequeue_tail(&txq->pending_skbs);
		mana_unmap_skb(skb, apc);
		netdev_warn(ndev, "Failed to post TX OOB: %d\n", err);
		goto free_sgl_ptr;
	}

If XDP blasts packets into a full queue, could this print for every dropped
packet and cause severe log spew?

>  	__netif_tx_unlock(ndevtxq);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013214937.1453=
12-1-hamzamahfooz@linux.microsoft.com?part=3D1
