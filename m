Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28EA427F89;
	Mon, 17 Aug 2026 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786991343; cv=none; b=iY6d8pIwdnJykwPtYuhK7r0DDXBew8zBnfKia00OcuRitmvO76707oDoJbnmjwvomwa40E7aHBRkTE+Z29REG+A9EDuTQRNxIKsuCBR5b4VeUl5vIKPqCH68fHFfq+QFyIvILVU0NDAm1V+0HtH+MTHVPFlkQpzoIrQkFJ6+xYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786991343; c=relaxed/simple;
	bh=3/vLwVUPn7ktkVxgrDEbk4RCwvyP0b1lAEuYAc6BBPI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWaiUCBa/gnBh7ODaAsljNI4qaxNvhXEGDQs2e6nBoaozuWRjD01yWaP726sUAgsiWH2tPdxlUeOLfyKB27+63RMMrBcgBqyV3389bSQRoHzAMgtp/WmKZOinztCoVyfSs4vf5kINx0WEwyR/oeopvxvmVHR4keJAzAVdCdjEBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVa0X/Wp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVa0X/Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4F01F000E9;
	Mon, 17 Aug 2026 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786991341;
	bh=N67qjoZaa9ds4MBREtFzVPXPTrudOZs6HJhwrXjitfE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mVa0X/WpHVknHSZYDNxI0w7x9oFHos5nKPf70cEUbWY55HZWup2ofsnFpXipyfeUL
	 8fmyu+Hts/FxR3jKjqBSxcjG4YCBENYQBG6MmrQ197FcfUyjS6IVYd8OCEqMlA95dz
	 6t5C3mhSjg7nn7GX6Oe0khVIQtPSfHxTBPPDPWhwOvICTUbRjfquXrxGcvIpXLoFFQ
	 KZtF9/rHtpcozg5c9f2IYhskwZm35L1x89Nw7JOPsvsTgYGEDpdkOo5ShvpLRoFToa
	 VcQXtcgiP/ybpsKEI/tsfj2YpJaj970YA46VLN+iE/LqSnYlnR+mufLHaUGbfAY+/l
	 MNy6xtkDPoRUg==
Date: Mon, 17 Aug 2026 11:29:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 leitao@debian.org, horms@kernel.org, mjambigi@linux.ibm.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 guangguan.wang@linux.alibaba.com, kees@kernel.org, gustavoars@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 0/3] net/smc: fix out-of-bounds and
 use-after-free in SMC-Rv2 LLC processing
Message-ID: <20260817112900.35172251@kernel.org>
In-Reply-To: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
References: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Aug 2026 08:18:59 +0900 Yehyeong Lee wrote:
> Patch 1 fixes a use-after-free of the LLC queue entry in
> smc_llc_srv_add_link(), patch 2 bounds the peer's rkey counts, and patch 3
> carries the tail of an oversized v2 message in the queue entry so that both
> readers are bounded by what arrived.  All three are tagged for stable: a
> tree that takes 1 and 2 without 3 still deletes rkeys read from whatever an
> earlier message left in the shared receive buffer.

SMC maintainers, please review.
