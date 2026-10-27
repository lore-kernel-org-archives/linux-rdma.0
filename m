Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793062687;
	b=2fU0sbn+juATTNDOzT0Pmue2nrMRKUh5+SeLRfRVS6N3VfwF0lcADWch3/vuBxJUhLf1
	 42LByctwZPDooRrcP+DjK4I3qbD2dhbfGjO53crlM/wWV8sxfu4HHQ8sYJBxdusmKn4/Z
	 GHglw9+daeSpCQXjeu39WdL5VtJOxQmNsK/lF3tulcpy6AdhMSWWftPay0K1/DsO2+qow
	 1ywY3ZE6WkuZEAToz7G67WCskjNDCxmIMw06gPCZvYeWNShCQIZcM1h0NRbfm6BWYFGnV
	 wIUuw5Ab+KTMKO277Ac3pahZXxmv/8wJvPy6OlpxG1FtgYdERZZQlTBGPxroZdT3Z6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793062687;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sUEwDKmhUCK72nyNcfOYNUcMipaRMF0mJ0oZfnfboSs=;
	b=OrdCRh1n1EhFNKjryEt7/UAwDX774HHAyqeUPVjmrY4b8OBt+eMJgY3TCUha861RQ20J
	 7J/kZzMkGTSK4RPBW27l8+SBXo5PqoWrIhMPKo3UMRkoJUEVLaxJLhz0TahbGoFtQJgRO
	 F4cp10IZzscWadXJgELTHJsuLfliwC++9tesRc0wNeHU9udCIJDSfPmR8v0prD4TrB0EJ
	 sARqjPeORQdQRUpiNZzjMNP6SMYZLtx0yhWmC7aThp0Zh+8WvxWjBbwP5YThaahVsWFWg
	 bmsr1f0cva3/cMeg0VBKapp1ma83sPrBjMnrADKxhBrZsjioCHbkYWzU9o5NiNdIzaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QnK5Angs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B59606A31A;
	Tue, 27 Oct 2026 00:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QnK5Angs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADF31F01825;
	Tue, 27 Oct 2026 00:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793062686;
	bh=sUEwDKmhUCK72nyNcfOYNUcMipaRMF0mJ0oZfnfboSs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QnK5AngslxK4SxemRGecOkdXVnJ9wn73lyJr7uILSfTFni5Wc9opi+Aa0Fy8tIDCn
	 PaKwQy0Mv7wBKxZMH8Rb6hvW6Ol3JRJKH11j1RZuxoiQ3u6RAb3KcB+ZVw3tUMl7UK
	 VXGoVp6CFCwvAa7SRH+Hml9lACCG5v0asZVcfHFlA+p17Ih6GJvlvmmOQnhvbkg0Ab
	 a1zImvVSuIbcpV0Au4n3THn+o3eCdrAJWfWX2c7NSf5h2SvfNSVBWMQXMguN/Vh6nV
	 CUNE10oSAThlY5bFvrTYgwlIsNdCpZu7FMp+xwWJr7uuB0m9mYwtu/w7gAlSYGcVx2
	 iMRtb34HOtBpQ==
Date: Mon, 26 Oct 2026 17:58:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Todd Bert Freed <toddfreed@meta.com>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org,
 borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, pabeni@redhat.com, daniel.zahka@gmail.com,
 willemdebruijn.kernel@gmail.com, horms@kernel.org, shuah@kernel.org,
 cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
Message-ID: <20261026175805.6d4dcae5@kernel.org>
In-Reply-To: <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com>
References: <20261023234640.1459291-3-toddfreed@meta.com>
	<179288570143.3134.8925369868949382653@kernel.org>
	<CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Oct 2026 15:05:42 -0700 Todd Bert Freed wrote:
> > The PSP ICV doesn't cover the outer IPv6 header or its extension headers.
> > An on-path attacker could take a captured PSP packet, insert one of these
> > headers, and set saddr to an address they control. This assumes the
> > device authenticates such packets, which this patch's premise implies.
> >
> > Several of those handlers reply with an ICMPv6 error that quotes the
> > packet. With default sysctls, this happens for an unrecognized routing
> > header type (type 0, for example) with segments_left != 0:
> >
> > Before this patch, all of these packets were dropped at the is_udp check.
> > Forwarding the decrypted skb itself looks blocked by
> > sk_validate_xmit_skb() ("unencrypted skb with no associated socket -
> > dropping"). That leaves the ICMP error path as the open channel.  
> 
> Agree with this finding.

If we're leaking cleartext in ICMP responses that's also a problem
for TLS offload. We should fix that, based on skb->decrypt. right?

BTW I haven't looked closely but is there no existing helper that
would give you the ability to walk the extension headers?
