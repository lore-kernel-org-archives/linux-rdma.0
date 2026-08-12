Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F4495051;
	Wed, 12 Aug 2026 22:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575273; cv=none; b=YJxZYQD6xrh/f3uNVqROTvMJIKzqIz2tvAtqOE62VM4S5sNaMNw7RT0p/8L443s4B65PEjWSeC5LNhoTleVjoSJQ755RklenYWjMx2Gny8mBZkjJTKMSHUyyyKtrO0HLXksWCfxwYWVB5qPuQG6CKuk0JjQKqfXGbHKAhIJqw8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575273; c=relaxed/simple;
	bh=k/MgVsA/uFlaI/R1VXL8YigOwc9vssvt8SzVRj/Dzb0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbDrXrdvcHOKq28RVN3OFCj5FVgSR3DXWTaVzkdsLU4U3WLa74mlR9kLZZjbZVZUzg0A0+wUyd6bwn665xEyf0dNCndNYgB4DoYwy/atIyzCZYKr4h5e0EdUS0SCsN1pylmalnDsuSymzyKGf4yctBUAeBv+ZbPoJAKRodpCktY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8b276l4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8b276l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DBB1F000E9;
	Wed, 12 Aug 2026 22:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786575271;
	bh=LRaU12k2z7NCZ51+sUUgUOkWKL/LvwrzQm2TPKyk7O0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n8b276l4O9vawyoI7A8FfXVV/rpvdQbgTbsbPPaxxRreX/gm9MpEUlRbh8ogQbGrE
	 1Wh516SZCWoTbjEqKtyIuWwXlQOFAHSOS3gcRPkxfhq5ebOFOEC8bqpwMY2dCt4ZWB
	 Eb56AdtGLcKIyOqS8ecTu2Sgoh6RU5ANwAJ19ZMIloNTGoJKIKwV/UYBDPNZd2vmZ0
	 4FUS7STKOzm4JXG7CFnGmhv6BmaRSMAOWHrdznMrU15Pang+x6oV9fHrGtkp96kXLT
	 YDsgSwURhixE1NSyMFU984nUrnIWpfEkTJU42OZW83lPDzrNsD3gCsFxKL1Ena4CIA
	 N1ZFKrrxgh7vg==
Date: Wed, 12 Aug 2026 15:54:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
Cc: "shaojijie@huawei.com" <shaojijie@huawei.com>, "shenjian15@huawei.com"
 <shenjian15@huawei.com>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "eperezma@redhat.com" <eperezma@redhat.com>,
 "jasowang@redhat.com" <jasowang@redhat.com>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "mst@redhat.com" <mst@redhat.com>, "xuanzhuo@linux.alibaba.com"
 <xuanzhuo@linux.alibaba.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "edumazet@google.com" <edumazet@google.com>, "linux-doc@vger.kernel.org"
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
 <g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
 <ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
 <mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
 "rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
 <Jason_Livingood@comcast.com>, "vidhi_goel@apple.com"
 <vidhi_goel@apple.com>, Parav Pandit <parav@nvidia.com>, Willem de Bruijn
 <willemb@google.com>
Subject: Re: [PATCH v5 net-next 1/2] net: update comments for
 SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
Message-ID: <20260812155430.6ec81eec@kernel.org>
In-Reply-To: <PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
	<20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
	<20260811173017.3d18dfdc@kernel.org>
	<PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Aug 2026 10:33:19 +0000 Chia-Yu Chang (Nokia) wrote:
> > > -     /* This indicates the tcp segment has CWR set. */
> > > +     /* For TX, this indicates that the first TCP segment has CWR set, and
> > > +      * any subsequent segment in the same skb has CWR cleared. This flag
> > > +      * must not be used in RX, because the connection to which the segment
> > > +      * belongs is not tracked to use RFC3168 or AccECN. Using RFC3168 ECN
> > > +      * offload may clear CWR and corrupt ACE signal (CWR is part of it).
> > > +      * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid CWR corruption.
> > > +      */  
> > 
> > I still can't wrap my head around this TBH.
> > 
> > SKB_GSO_TCP_ECN means RFC3168
> > SKB_GSO_TCP_ACCECN means AccECN
> > 
> > If the HW can correctly detect cwr on first frame and then no cwr and report that as ECN/RFC3168 - what's the problem? TSO will produce the exact expected segment sequence.
> > 
> > Is the program that if we re-GRO that frame in SW we end up with
> > ECN+ACCECN on the same skb?  
> 
> Yes, this is the problem.
> The HW does not know whether the received packets belong to an RFC3168 ECN flow or an AccECN flow on the RX path.
> For example, HW GRO may set SKB_GSO_TCP_ECN after observing that the first packet has CWR=1:
> 
> +===================+==========+=================+================+
> |     Packet id     | CWR flag |       Flag      | Flushed as SKB |
> +===================+==========+=================+================+
> |         0         |     1    | SKB_GSO_TCP_ECN |        0       |
> |         1         |     0    |         -       |        0       |
> |         2         |     1    |         -       |        0       |
> |         3         |     1    |         -       |        1       |
> +===================+==========+=================+================+
> 
> If the aggregated skb is forwarded through a device using GSO, e.g.,
> HW RX (GRO) -> veth TX (GSO), the SKB_GSO_TCP_ECN applies RFC3168
> semantics. This means that only the 1st segment keeps the CWR flag
> while all subsequent segments have CWR cleared:
> 
> +===================+==========+
> |     Packet id     | CWR flag |
> +===================+==========+
> |         0         |     1    |
> |         1         |     0    |
> |         2         |     0    |
> |         3         |     0    |
> +===================+==========+
> 
> This behavior is ok for RFC3168, since CWR is expected to appear only
> once. However, for AccECN, CWR is part of the ACE signal and must be
> preserved across all segments.

But this would be obviously a buggy HW-GRO implementation.
The rules for HW-GRO RFC3168 are -- ignore CWR on first segment
(host responsible for populating SKB_GSO_TCP_ECN), and CWR
_must be 0_ for all subsequent segments.

> In the example above, the original CWR sequence was 1,0,1,1.
> But after re-segmentation it becomes: 1,0,0,0.
> This is why SKB_GSO_TCP_ECN should not be used in RX/GRO paths.

We have extensive gro tests under 
tools/testing/selftests/drivers/net/gro.py

If you want to catch bad devices - add appropriate test cases there.

The comment as stated seems to be misleading - there's nothing wrong
with using the flag if the device follows the RFC3168 semantics
correctly.

And of course, adding a comment and hoping people will find it is much
weaker than adding tests.

Again, maybe I'm missing what _actually_ doesn't work here.
You mention veth but veth does not participate in GRO directly, 
it's not a HW driver either.
