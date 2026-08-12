Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F9334E777;
	Wed, 12 Aug 2026 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786494621; cv=none; b=s+pVa3V9WCtKefYak7nGyA0KpRIqfm1yQOGJ105kUjwomdHtXdZnQIZfxtJ/P5cm3yF161uO9nO4Sokhplcv9JHXF9bLcaU/hyplaVR6D6bqIYwHzYs/A7FTpXgipimibKRfBdVHGaCgYlfIc69yQu+BNM8DscTq1qE+BNJeiPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786494621; c=relaxed/simple;
	bh=okRGTHj9xe02E3+2vllt76mrLoc9xeWeOr/WI/Hs9ss=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ExCpzWAtIAlxN/bZwBtcZwkyd5wvZJ4as2tXJxfc0u9R3s5ThS5INnUvU8Kg16diYHsCh7i9t6hK6qZmmQAGy9QsX8kWDhki2RnbbhAzL9abWVLnZp2rgjC8iNlp6gKpa752VD22fWF3MOieWqNIPbCQqAiyIZk+dg6umuIGRM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PF29UAPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PF29UAPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571271F00A3A;
	Wed, 12 Aug 2026 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786494619;
	bh=vBGCSWHaGMmkmmP6yi4Nc/OgFCtfvJsC1RNn5pkjCgg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PF29UAPzPh1648sUupk3yfPPS8lvAWVb7VDO27PVC7jtt/EnlHV64lWDGwg63V+WH
	 yqBRc68+AeMKJWQLroLC4SHU9+h+OX4ZTBEUyI3EltWHfKaewCsksOGHkSyLoViRKW
	 NnjBcWG3lJtPbw5n0wJcmnK7TbT4rM5u+fePCjZ7Dfa/snQDKLyGJSsskGu3i2cVxj
	 Ttcv88MMLW3zbve6ZLK1xt9kR0klDNwUkpjmM5YJ78dNaZB1XbRUPxRQQs0qnil/Ce
	 BQn4ez36ahFzEjrSvabfgx7pTkVnTG4ogTiD664GAusBj75WoszJwN1kHZlM35OLst
	 D+gDoE7aisySg==
Date: Tue, 11 Aug 2026 17:30:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: chia-yu.chang@nokia-bell-labs.com
Cc: shaojijie@huawei.com, shenjian15@huawei.com, linux-rdma@vger.kernel.org,
 eperezma@redhat.com, jasowang@redhat.com, virtualization@lists.linux.dev,
 mst@redhat.com, xuanzhuo@linux.alibaba.com, pabeni@redhat.com,
 edumazet@google.com, linux-doc@vger.kernel.org, corbet@lwn.net,
 horms@kernel.org, dsahern@kernel.org, kuniyu@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, dave.taht@gmail.com,
 jhs@mojatatu.com, stephen@networkplumber.org, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, davem@davemloft.net, andrew+netdev@lunn.ch,
 donald.hunter@gmail.com, ast@fiberby.net, liuhangbin@gmail.com,
 shuah@kernel.org, linux-kselftest@vger.kernel.org, ij@kernel.org,
 ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com,
 g.white@cablelabs.com, ingemar.s.johansson@ericsson.com,
 mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at,
 Jason_Livingood@comcast.com, vidhi_goel@apple.com, Parav Pandit
 <parav@nvidia.com>
Subject: Re: [PATCH v5 net-next 1/2] net: update comments for
 SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
Message-ID: <20260811173017.3d18dfdc@kernel.org>
In-Reply-To: <20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
	<20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  4 Aug 2026 23:35:09 +0200 chia-yu.chang@nokia-bell-labs.com
wrote:
> This corresponds to discussions in virtio mailing list:
> https://lore.kernel.org/all/20250814120118.81787-1-chia-yu.chang@nokia-bell-labs.com/
> And it was suggested to clarify SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN.

> -	/* This indicates the tcp segment has CWR set. */
> +	/* For TX, this indicates that the first TCP segment has CWR set, and
> +	 * any subsequent segment in the same skb has CWR cleared. This flag
> +	 * must not be used in RX, because the connection to which the segment
> +	 * belongs is not tracked to use RFC3168 or AccECN. Using RFC3168 ECN
> +	 * offload may clear CWR and corrupt ACE signal (CWR is part of it).
> +	 * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid CWR corruption.
> +	 */

I still can't wrap my head around this TBH.

SKB_GSO_TCP_ECN means RFC3168
SKB_GSO_TCP_ACCECN means AccECN

If the HW can correctly detect cwr on first frame and then no cwr 
and report that as ECN/RFC3168 - what's the problem? TSO will produce
the exact expected segment sequence.

Is the program that if we re-GRO that frame in SW we end up with
ECN+ACCECN on the same skb?
