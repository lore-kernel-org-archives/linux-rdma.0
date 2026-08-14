Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1C44963D4;
	Fri, 14 Aug 2026 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786734087; cv=none; b=DtNQSUaG3Zb9vPapvkNqpQQ2BTSFSxqnlmzoDGYZB6qUb6i8oaQE2bYSE1wY2z8miQni3tA+4YwK8Cg8+k2ItnPmv3vEh2CzrwZ08Eb6hextCL4V5EF/syvLeWgC+mEZD6vTtMD8F0RKPi7YQkFeS2D/M8Gax8wwqtM+2hNtE0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786734087; c=relaxed/simple;
	bh=+RfttoHDPzDZ/J4J4LnJzjDshhqbofKwm01MqxC+Mdg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNP5HD1Lpx0bm38X00GxoSd+SPWetdV7s7wNXOHYRuzMBSIpTxjJ9LWzXXNyQ4UI/G1RRfJIHWBVYB2emcbKbBjenvrRyAON9wamCY15nLC9JajBm6Hn/oeV+pevtdV8QmRZvehz2CVbsTtJnQYc1Hdv+VKJUgSFqkXk3l2Jks4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAAxdrnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAAxdrnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527C61F000E9;
	Fri, 14 Aug 2026 19:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786734083;
	bh=lFPzdrrZzc98sDzup9+MQlZUCO3i2gOlV9kV8XaDFO8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KAAxdrnKUbTIljf1y6/2gnF3zIHy/4GiGfrwffymTDuHksJxzzDnwVEMw2hvaOWcL
	 dK4uFYUQ/XUuelcG0UdkaXRaO+hI2Sm/RUSVdgoamKeb9faPva8LLSQeEYdrobLwdl
	 XkMmPCruc1jONobnyl4IKenNeT4j9bV+R4LoreOmaBFTh9QIHfLPFObqUUFTY09n8E
	 JwPbez6r5726A307llqNp8hjxZMR/qYj4zjoxaF1cOxCR58ePFHrCMfN2Shq+P9uwk
	 Cz8/crg6NZm7aKvQJA4xtzJCg0mPd5iu/76qF659All0tXUFB9N/blFi9UbL3NDAeS
	 PQvGl9RB6HZvA==
Date: Fri, 14 Aug 2026 12:01:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>, Mirja
 Kuehlewind <mirja.kuehlewind@ericsson.com>, "shaojijie@huawei.com"
 <shaojijie@huawei.com>, "shenjian15@huawei.com" <shenjian15@huawei.com>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "eperezma@redhat.com" <eperezma@redhat.com>, "jasowang@redhat.com"
 <jasowang@redhat.com>, "virtualization@lists.linux.dev"
 <virtualization@lists.linux.dev>, "mst@redhat.com" <mst@redhat.com>,
 "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
 "pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
 <edumazet@google.com>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "horms@kernel.org" <horms@kernel.org>, "dsahern@kernel.org"
 <dsahern@kernel.org>, "kuniyu@google.com" <kuniyu@google.com>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "dave.taht@gmail.com" <dave.taht@gmail.com>,
 "jhs@mojatatu.com" <jhs@mojatatu.com>, "stephen@networkplumber.org"
 <stephen@networkplumber.org>, "xiyou.wangcong@gmail.com"
 <xiyou.wangcong@gmail.com>, "jiri@resnulli.us" <jiri@resnulli.us>,
 "davem@davemloft.net" <davem@davemloft.net>, "andrew+netdev@lunn.ch"
 <andrew+netdev@lunn.ch>, "donald.hunter@gmail.com"
 <donald.hunter@gmail.com>, "ast@fiberby.net" <ast@fiberby.net>,
 "liuhangbin@gmail.com" <liuhangbin@gmail.com>, "shuah@kernel.org"
 <shuah@kernel.org>, "linux-kselftest@vger.kernel.org"
 <linux-kselftest@vger.kernel.org>, "ij@kernel.org" <ij@kernel.org>,
 "ncardwell@google.com" <ncardwell@google.com>, "Koen De Schepper (Nokia)"
 <koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
 <g.white@cablelabs.com>, Ingemar Johansson S
 <ingemar.s.johansson@ericsson.com>, "cheshire@apple.com"
 <cheshire@apple.com>, "rs.ietf@gmx.at" <rs.ietf@gmx.at>,
 "Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>,
 "vidhi_goel@apple.com" <vidhi_goel@apple.com>, Parav Pandit
 <parav@nvidia.com>, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 net-next 1/2] net: update comments for
 SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
Message-ID: <20260814120121.50e61d01@kernel.org>
In-Reply-To: <willemdebruijn.kernel.c248a28f9c86@gmail.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
	<20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
	<20260811173017.3d18dfdc@kernel.org>
	<PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
	<20260812155430.6ec81eec@kernel.org>
	<PAXPR07MB7984E3E73868BF8966821C27A3DB2@PAXPR07MB7984.eurprd07.prod.outlook.com>
	<CAF=yD-LQbndjPZiXcfA6fMp6msza_+YdzqqwyeUDVTdOCOHhDw@mail.gmail.com>
	<47BE8A8A-F80C-4C30-BC95-C85FEBFFB606@ericsson.com>
	<PAXPR07MB7984ED42ED0849D3A9AB8C19A3DA2@PAXPR07MB7984.eurprd07.prod.outlook.com>
	<willemdebruijn.kernel.c248a28f9c86@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Aug 2026 09:34:01 -0400 Willem de Bruijn wrote:
> > Current SW GRO sets SKB_GSO_TCP_ACCECN when the flushed skb carries CWR in tcp_gro_complete():
> > if (th->cwr)
> >     shinfo->gso_type |= SKB_GSO_TCP_ACCECN;  
> 
> And I suppose it follows correct AccECN rules for coalescing.
> 
> That is a performance regression from RFC 3168 ECN, as it allows for
> less effective coalescing. I have no intuition how much it will
> differ in practice.
> 
> > For HW GRO of a legacy device that implementing RFC3168 semantics, setting SKB_GSO_TCP_ECN seems reasonable.
> > However, such a device would not be able to preserve ACCECN signaling across the GRO/GSO.
> > In that case, if preserving AccECN signaling is required, disabling HW GRO may indeed be necessary.  
> 
> Right.

I'm still not following.. Maybe Willem can ELI5 what the problem is.

_SW_ GRO follows only the AccECN rules.
But if HW GRO follows RFC 3168 and we mark the aggregate as
SKB_GSO_TCP_ECN - TSO will also abide, and segmented output 
will be identical to pre-GRO input.

Are we trying to ban RFC 3168 behavior in HW purely to match SW?

> And there currently is no kernel API to disable only ECN
> coalescing. NETIF_F_GRO_HW enables or disables HW-GRO entirely.
> Or even to signal whether a HW-GRO implementation is AccECN
> capable.
> 
> Disabling HW-GRO can be a huge efficiency regression. I suspect
> many users will prioritize the efficiency over preserving the AccECN
> signal.
> 
> That said, some devices may have other ways to configure such
> finer details of their HW-GRO, even though not available through
> Ethtool.
