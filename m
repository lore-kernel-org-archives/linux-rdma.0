Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B39B13D886;
	Thu,  8 Oct 2026 02:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791425824; cv=none; b=FManvZEl2dk//OzgPTjM9Ydp1wExnLCrKu0ERjlJbAmMpogbrUJw6ApOc9AIsh87amdN0UWnMi1LMHIpYiQB/WugmFo5biiU5WHViZwEGx1w2mOXhiwXFRRqsZ5AW3cxymG8h/RjZyn4z2qaDrWzLlnqk11drCJhbbHmQ/q3Jhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791425824; c=relaxed/simple;
	bh=5Igza3zbL8DsL8iZkd4iOPUqt5mfV9bwMscd7jEwYAs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCHDMAN4jr2lRkXXYf+VQqPCxxpfKcB3wCZhfTzx+QdktUdqfrHwDj+3T98U2roqRkXg0u7AVjgCaXCg+8ir1nZHXO9QqbwFWsqm2nd+g+TUAUKiCBVD+UyxE+dzavliDQi4bX2WzAm72TKVVhh3lOtT/Tnx1utrxd6iS5AZXTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/HC2Kpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/HC2Kpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1219B1F000FF;
	Thu,  8 Oct 2026 02:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791425822;
	bh=09TxWdiMFYWRVecDe6e1P2wuubcsPRofkfD/tSUrqmI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A/HC2KpzGBA5D2N0yCzmSAuzt5ZQdDMcx96SL6btyOfx+IZb7c516v5ZE1cJGC5wS
	 ChUpUGmgxixRUGj81V5Spef75LvsUIpgoAsEOPAOZ7+c2XIzVnxLXdukGUbBIiEodh
	 PUhqOQ0CZJnOOhZShCImDd2y5NqTZPfxoT3WAcbvgDP7JhLLDfGEPz/8fdP7n6yx4n
	 L4qNqhvlRnbW3AOnrfEDDmmtT+MQn7++yb99DYUZnyQjH66bKcoI/aIoLPTAiOnmcX
	 QoIIS39vDVU5t12COaa5ms2vcLGlNmCnW4iw26eVKMoi0l0wPwJlNx6om1aDn2EKhz
	 tMPxQmpCmXxsA==
Date: Wed, 7 Oct 2026 19:17:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li
 <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony Lu
 <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
Cc: Chengfeng Ye <nicoyip.dev@gmail.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: serialize clcsock access with its
 release
Message-ID: <20261007191701.078bfbc1@kernel.org>
In-Reply-To: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
References: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun,  4 Oct 2026 02:33:25 +0800 Chengfeng Ye wrote:
> Link-group termination can release the CLC socket through
> smc_close_active_abort() while the SMC socket is still open, for example
> after shutdown(SHUT_WR). A file reference keeps the SMC socket alive but
> does not prevent this asynchronous release of its CLC socket.

SMC maintainers, please review
