Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F334EFFB0
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483420; cv=none; b=NbnLrlUqeQlaiHdpUE5pDISvnFHhTpglAcaMRtTYi5KsGa+0eRDK2FbPXfVhMXqDdqoqN2dK0B/5LM+MuaJGgZ0F17ZX3ZPOMtV06lEI2Ll/M52CTBK+ExL8U7L5kBBWLcw797dLJPjQHPZJ7nHA5BugJkAwUfQgTwcfFSVNsoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483420; c=relaxed/simple;
	bh=cta9I8vVWO3spyWvPXMw45oQWyLUSGQTX+HVaGC7pnM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QHKnxif2EuKzk2Ej1lWvPDIjNnqmIDqr3DA48QYlsQbk6j0S3OhzzPWWI0kQYbtacWbsZUkj/5bmFRwB7xP8woEESe+DqEM0P6QvUPU5AKbA12hAIsmaZVcV+aDojOEAXPOgDDRP0GhAkzfRllxy9xxRumfhOxCirWvzvXBdmj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZeQeteq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeQeteq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1DD1F00898;
	Thu,  8 Oct 2026 18:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483419;
	bh=6E63n4T9KloA5p468HTbUp+pZU0q6o/eLuL3jEt9Tw8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZeQeteq+guIQvhIIAz6B6SV7mKX/ASaTOP6nYBDTPanuvPyr28b+XQIh7xT+nI6kL
	 UPA5y6YgFZ9BcQcm4gci23rVrU/gBJSzvupyy67QaIjVRR3ixDjPH9fl79OQBVB8B+
	 OYBqB3CA99yP0p7OjXYDgu7hheb/D36FA7FMcR/eZdYyxieBtqOTeO38ZA5Gcz+rAr
	 iGknsCoRj1504l4VVN4lBWi04TUVUAjJuiyymmIUhwnKVQh7LGkdFeTXCOZMbrwiCq
	 Y+iclUMcPfHbBTUL2pTavwR056SvYYodXRuf12E0HmcNCdWNa/FD/eaNmkr22vR0Bm
	 D0/r+uyimiMwg==
Message-ID: <sashiko-outbox-164447@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 7/9] netxen: use pskb_may_pull() to pull excess
 TX frags into the head
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-7-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-7-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] netxen: TX fragment hardware limit bypass due to unstripped 0-le=
ngth fragments
--

commit daf1ad3622d94edcda5ee23317b335a0a1a7de23
Author: Josef Bacik <josef@toxicpanda.com>

netxen: use pskb_may_pull() to pull excess TX frags into the head

This commit replaces a direct call to __pskb_pull_tail() with pskb_may_pull=
()
in the netxen driver's transmit path to pull excess fragments into the head.

> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drive=
rs/net/ethernet/qlogic/netxen/netxen_nic_main.c
> index 67d9bf69f8f29..202deb64ddefb 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> @@ -2045,7 +2045,7 @@ netxen_nic_xmit_frame(struct sk_buff *skb, struct n=
et_device *netdev)
>  			delta +=3D skb_frag_size(frag);
>  		}
> =20
> -		if (!__pskb_pull_tail(skb, delta))
> +		if (!pskb_may_pull(skb, skb_headlen(skb) + delta))

[Severity: Medium]
Does this change bypass the hardware limit for TX fragments by failing to
strip 0-length fragments?

If an SKB is transmitted with more than 14 fragments and the first excess
fragments are 0-length, delta will be 0.=20

The original code handled this by calling __pskb_pull_tail() which strips
0-length fragments even when the length to eat is 0:

net/core/skbuff.c:__pskb_pull_tail() {
	...
	int size =3D skb_frag_size(&skb_shinfo(skb)->frags[i]);

	if (size <=3D eat) {
		skb_frag_unref(skb, i);
		eat -=3D size;
	} else {
	...
}

Because 0 <=3D 0 evaluates to true, the 0-length fragment is successfully
removed and nr_frags is reduced.

However, pskb_may_pull() returns true immediately without modifying the
SKB when requested to pull skb_headlen(skb) + 0 bytes.

This leaves the SKB with frag_count > NETXEN_MAX_FRAGS_PER_TX (14). Will
the driver then program a descriptor chain with more fragments than the
firmware supports?

>  			goto drop_packet;
> =20
>  		frag_count =3D 1 + skb_shinfo(skb)->nr_frags;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D7
