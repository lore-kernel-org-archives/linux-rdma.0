Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DCD44E67D;
	Wed,  5 Aug 2026 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785932011; cv=none; b=b+pCa1kEgwBBDMVRI74x6+1ssXTAZfdDGXbCc0k6x08Y6f8JfnsVsYB8GxixQ2qLhozA9m7/T9aR9i5XNjkUO53x0Or6msWn7M0GRAByoFO2lNdhoX5EBddfaE3K+7lYJAngIbCfG3Esgs1QCxOrqGnK4bq45N5WCMFgLKU1M7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785932011; c=relaxed/simple;
	bh=G+LDYaI75y6HB1fykYtTE0wwkh5v6ItDFFRyTrh21wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1bABmrCdGf0Gct+D9O741+2Xeb9biUl+XMpEn9QH3nY1UL8AWLQUqkwed/1a5jtywme0sLNj2mvULuN6/s1JN7VWebvefI6OgcsK7fQOpnvKcqgJ/zwpiwnSs0coyu1gIou8CzVt6h9Z0H/yC+HoWZVSckFbJJBvIAFVnhh5pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBdRvyFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBdRvyFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2D11F000E9;
	Wed,  5 Aug 2026 12:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785932010;
	bh=vUFXBNuXhafwGwK8UGdCE11bMme4oaaRhHR9wpn5xJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZBdRvyFh8alziS7hw7mYBO0guypWSroeTXhSFvQLGZB3l9rTcCFete4o2PH7XJXUY
	 gvp/60COVl0ElpqYiIvyMH5HtkSzFcIiKHn0FFhf91v8jJyqkRIDyPxBLcuRVfi05s
	 xkvk3O3/TgE1pH2DZucVATBzX+Up6s6+PMipQAo1hIkH2G1Xj3q4KRvifFlQHBpNwO
	 x5tn1KddZ/FYKnn5fO/PgwFVNx8akHXaZoCwQ8Fy82iQcL/hE2wcAdhkVjl9SLeSjo
	 lJwmKDq2O6zawqZIW6aDCI5Hn9qZ/uPi5XiSwtwJR5szU57Q29wxrHBrkIIQ2/gqWf
	 7YaS/V0YcbbDg==
Date: Wed, 5 Aug 2026 13:13:25 +0100
From: Simon Horman <horms@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com, wenjia@linux.ibm.com, kuba@kernel.org,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, guangguan.wang@linux.alibaba.com,
	kees@kernel.org, gustavoars@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5 3/3] net/smc: carry oversized SMC-Rv2 LLC messages
 in the queue entry
Message-ID: <20260805121325.GS51943@horms.kernel.org>
References: <20260801094208.1937951-1-yhlee@isslab.korea.ac.kr>
 <20260801094208.1937951-4-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801094208.1937951-4-yhlee@isslab.korea.ac.kr>

On Sat, Aug 01, 2026 at 06:42:08PM +0900, Yehyeong Lee wrote:
> An LLC message longer than the 44-byte union smc_llc_msg arrives either
> whole in the receive buffer or split into the link group's shared v2
> buffer, and both consumers of the tail rebuild that layout themselves.
> Copy the tail into the queue entry instead, so its length and its lifetime
> are those of the message that arrived, and declare the rkeys that do fit
> inline as a member of the union rather than reaching them through a cast of
> a shorter type.
> 
> The bound the previous patch placed on links without a shared v2 receive
> buffer is no longer needed here: the extension is read from the qentry,
> whose length is the length of the message that arrived.
> 
> A DELETE_RKEY_V2 is now bounded by what arrived rather than by the buffer
> it landed in: a 44-byte message declaring 255 rkeys processed 255 of them
> before, and processes the 9 that fit now.
> 
> Suggested-by: D. Wythe <alibuda@linux.alibaba.com>
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> Measured over rxe with KASAN: a DELETE_RKEY_V2 carrying 12 rkeys over a link
> with a shared v2 receive buffer round-trips all 12 values, the last three
> coming from the copied tail; 8, 9 and 10 rkeys and a 44-byte message declaring
> 10 give 8, 9, 10 and 9 processed rkeys respectively.  kmemleak reports nothing
> over the link-addition path, and does report the queue entry when the free
> added by patch 1 is removed again.

There is an AI generated review of this patch-set available at
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260801094208.1937951-1-yhlee%40isslab.korea.ac.kr

Of that review, I think the following warrants particular consideration.

TL;DR: to ensure complete backports, maybe add this tag to this patch,
as it has been added to patch 2/3.

  Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")

The text of the AI-generated review:

  Should this patch carry a Fixes: tag and Cc: stable as well?  Both
  predecessors in the series do, and this is the patch that changes behaviour
  in two places.

  First, the early return this hunk replaces:

	if (!smc_link_shared_v2_rxbuf(link))
		return;
  On a device with max_recv_sge == 1 that means the peer's rkeys in the
  ADD_LINK v2 extension are never installed into lgr->rtokens for the new
  link, even though those bytes do arrive on the link.  Only the
  qentry->body_len bound added here reaches them.

  Second, in smc_llc_rmt_delete_rkey() the shared-v2 path was bounded by the
  capacity of the per-lgr buffer rather than by what the peer sent:

	llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
	buf_len = SMC_WR_BUF_V2_SIZE;
	...
	max = min_t(u32, max, (buf_len - rkey_off) / sizeof(llcv2->rkey[0]));

  So a 44-byte DELETE_RKEY_V2 declaring num_rkeys = 255 walks rkey[9..254] out
  of whatever an earlier oversized peer message left in lgr->wr_rx_buf_v2 and
  passes each value to smc_rtoken_delete(), which can clear a valid rtoken of
  an unrelated connection in the same link group.

  The changelog describes both as consequences rather than as fixes:

	The bound the previous patch placed on links without a shared v2
	receive buffer is no longer needed here
	A DELETE_RKEY_V2 is now bounded by what arrived rather than by the
	buffer it landed in: a 44-byte message declaring 255 rkeys processed
	255 of them before, and processes the 9 that fit now.

  If a stable tree takes the first two patches of the series but not this one,
  does it end up with the ADD_LINK v2 extension ignored on max_recv_sge == 1
  devices and the stale-rkey deletion still present?
