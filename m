Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7673836728F;
	Sat, 10 Oct 2026 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643327; cv=none; b=Uy3itb+b8BVglP8Ru3vcgSQ28e+j/k7dAkEfJ7wcJGMs6XvbxvBF0nSZ4wQgdm8SXbVn1mzIXuiYIaTg61Tvm6rSwureZBTUqtxsd9H4HULwgXzvYbn9IwOV4AB1FYeAVRXV493MdppmFSekOZrnOi/5yw1iRnkif78fueOgMQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643327; c=relaxed/simple;
	bh=XfiES/JF5+BEiL2Y0P4oPCts2FNlS9FBayDp9R5QRcI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UbDTaifEvLdjDK3j+Jt6v0+OlrOx0sbOt6MUMe0HjGx6BPdLk2tEYO4jibGIRMAPn3NbqxDm4vEFyXMM+3yAoOFHMyTIl1EhrUYqR7JqHb2AbHVIksG3qDGoq6nEbVqqSJ8Didny5//Ok0u7BZ6aP+UyoJ32bWR6kI4SedstDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ex8YJZyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ex8YJZyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100181F000FF;
	Sat, 10 Oct 2026 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643326;
	bh=LAR+xGLl4/AyiMefEhk78M2IoeeWA4anGeM5SUqfl3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ex8YJZyNceZYuvuTNbD3WB7JpWGXy+vVRfQACFQXS7zDlKOlmOznP253lR191sG0X
	 xeyDBUKiCjMFCUwZgKZSsQ9ya6BbTB/+5X1a43r35yqA2HCuSbWKQZQjlAq9gS1jc6
	 B9KZkZBeQlDWid52CiqxH25Bv1bK8BDI1Jc2sqHy++E+G+gM+oKUoiR+RzUCG7ARu0
	 kWJfbWqRo5gmQmfU5lvERXnUKIm4PHSM9O+IxtqmI0TAu58UxXhC/jDrD+/H0wRy7f
	 VK/+XgTQC0qHpG9jdWQTV3wFUDMxPD8M73L16WrBJY0b9GkuEJ6dc4prIoxmSlB1eZ
	 EAdts1rWgkn7w==
Message-ID: <sashiko-outbox-166660@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 03/13] net: mana: keep per-queue statistics
 in the port context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <35bb5bd322e53edfb2e53e4b57ed2e678f3b5105.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <35bb5bd322e53edfb2e53e4b57ed2e678f3b5105.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net: mana: UAF in ndo_get_stats64 due to premature free in mana_re=
move
- [Medium] net: mana: lost xdp_xmit stats due to lockless update in mana_xd=
p_xmit()
--

commit d18c42b1a688757d3c44ba3c118c5293e960c9e8
Author: Long Li <longli@microsoft.com>

net: mana: keep per-queue statistics in the port context

This patch prepares port-lifetime RX/TX statistics before introducing
live queue replacement. It allocates max_queues slots before netdev
registration and preserves counters while the interface is down.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net=
/ethernet/microsoft/mana/mana_bpf.c
> index ff54f89668251..1905214bec487 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -68,7 +68,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struc=
t xdp_frame **frames,
>  		count++;
>  	}
> =20
> -	tx_stats =3D &apc->tx_qp[q_idx]->txq.stats;
> +	tx_stats =3D apc->tx_qp[q_idx]->txq.stats;
> =20
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->xdp_xmit +=3D count;
>  	u64_stats_update_end(&tx_stats->syncp);

[Severity: Medium]
Can this result in lost statistic increments due to a data race?

When multiple CPUs perform XDP redirects to the same queue, they will execu=
te
mana_xdp_xmit() concurrently. Because tx_stats->xdp_xmit is updated outside
of lock protection, the non-atomic addition operations can collide and
cause lost increments.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 45cb23717151f..02cd5f7656ed8 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -4491,6 +4557,7 @@ void mana_remove(struct gdma_dev *gd, bool suspendi=
ng)
> =20
>  		unregister_netdevice(ndev);
>  		mana_cleanup_indir_table(apc);
> +		mana_free_queue_stats(apc);
> =20
>  		/* Remove the port from reset walks before freeing its netdev.
>  		 */

[Severity: High]
Does this create a use-after-free race with lockless readers like
mana_get_stats64()?

When mana_remove() calls unregister_netdevice(), the synchronize_net()
call is deferred until rtnl_unlock() happens later. Because
mana_free_queue_stats() is called here before the RCU grace period complete=
s,
concurrent readers querying the device could dereference the freed
apc->rxq_stats and apc->txq_stats pointers.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D3
