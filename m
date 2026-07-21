Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8380E2FD1A5;
	Tue, 21 Jul 2026 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784593693; cv=none; b=lc7jzllDPWNXwOGzifbrpgnqlw3UhoZjCCgEccLFJqLUDxZgGZ/Tg/n0CqyA8n6PswPiqeowutZFTwFoftySrkeORfVZ+p6YqUNNIf4AqFDhLyiw0Bos8mWdCUGxPsbVmaQBLUNoSN1uLVh/9gWb2uD0CP4Xv2Jas2ThX6VLW1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784593693; c=relaxed/simple;
	bh=c7lhteV67p9AWMJcWvD3z551MOUYGBrCWaCqcfp7Lss=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQQ9jGhIyGg4F68SO1Up3g/DNwLUVDMAEUD3T2POV4Ia+0tkP8lXcwYZe/nZvRxDTNO3QkelCoSQ9OfliTmIM835ywYG7uuiMXRpzwaeA/hg/FAOtZDsHytCXwa6+JUsjMwDOB94825kdvqPzJV/FqaNw1vwmPkoxJrW+Wz0yBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3kWMAe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3kWMAe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F701F000E9;
	Tue, 21 Jul 2026 00:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784593692;
	bh=c7lhteV67p9AWMJcWvD3z551MOUYGBrCWaCqcfp7Lss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F3kWMAe8HEOlIzHY/R4G5ilAmyCC2bnEu/v2WHVk4qVt+OQP1ZeFhPHV2z6yCqm7c
	 YVe8BP9HP3lK3hoLMVL0UhpjD1M5UKZSrODtPSa2tO5G2vppZNdqo5miWDDvswWZSx
	 Ypt8kQjj/PNLkN8ZzzlNL47brU9knc2+UDnzd/cFwlbs35HmdF2wjSorAlSi0VMBTA
	 YAHK99xI7mObk0JGnPghM53t++HUdMtCOwzV15yXbbBtHvqEXoTcMwLiwDfLzWGUpf
	 zjXPihsDFwV3y1vSvHEiDWTaQDB9qqrP2RHRZkBT/k7jGCepCNWZgyHZ70KQQEyOgS
	 aLlQIeFoSZImA==
Date: Mon, 20 Jul 2026 17:28:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: hexlabsecurity@proton.me, Dust Li <dust.li@linux.alibaba.com>, "David S.
 Miller" <davem@davemloft.net>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Eric Dumazet <edumazet@google.com>, "D. Wythe" <alibuda@linux.alibaba.com>,
 Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, Paolo
 Abeni <pabeni@redhat.com>, Stefan Raspl <raspl@linux.ibm.com>, Wen Gu
 <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony Lu
 <tonylu@linux.alibaba.com>, Ursula Braun <ubraun@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Message-ID: <20260720172810.347712b2@kernel.org>
In-Reply-To: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
References: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 05 Jul 2026 02:54:04 -0500 Bryam Vargas via B4 Relay wrote:
> A peer's CDC producer/consumer cursors are copied from the wire and used,
> without an upper bound against the local buffers, as (a) a raw index into the
> RMB on the urgent path, (b) the receive length in smc_rx_recvmsg(), and (c) the
> send length in smc_tx_sendmsg() on the SMC-D DMB-merge path. A malicious or
> buggy peer can forge a cursor so each runs past the relevant buffer: an
> out-of-bounds read of adjacent kernel memory (disclosed to the peer) on the
> receive/urgent side, and, on the send side, an out-of-bounds write whose
> length the peer controls and whose overflowing bytes are the local sender's
> own outbound data.

The netdev patch queue has overflown.
If these patches are still relevant you'll have to repost them.
